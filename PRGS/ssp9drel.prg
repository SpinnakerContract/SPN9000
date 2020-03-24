*****************************************************************
*                                                               *
*   ProMatrix Corporation                                       *
*                                                               *
*   Copyright � 1995-2000 ProMatrix Corporation                 *
*                                                               *
*   5225 Ehrlich Road, Suite C                                  *
*   Tampa, FL  33624                                            *
*   U.S.A.                                                      *
*                                                               *
*   This computer program is protected by copyright law and     *
*   international treaties.  No part of this program may be     *
*   reproduced or transmitted in any form or by any means,      *
*   electronic or mechanical, for any purpose, without the      *
*   express written permission of ProMatrix Corporation.        *
*   Unauthorized reproduction or distribution of this program,  *
*   or any portion of it, may result in severe civil and        *
*   criminal penalties, and will be prosecuted to the maximum   *
*   extent possible under the law.                              *
*                                                               *
*****************************************************************

***************
* S<Prefix>DRel - Called from the Table Relations report. Returns data to be printed on report.
***************

PARAM slnPrtNum

PRIVATE slcReturn,slcValData,slcValD,slnQuote1,slnQuote2,slnQuote3,slnQuote4,slcSAFile,slcSAField,sllOKToPrt,slcField,;
   slnComma,slcForFlds,slnFor,slcFK,slcForFld,slnComma1,slnComma2,slnUpdRule,slnDelRule,slcPriFlds,slcPK,slcPriFld

slcReturn = ''

* The DD2 table is opened twice. The first time (alias DD2) to run the report. The second time (alias AltDD2) to be used by
* this program to derive the data to be returned to the report.
IF PCOUNT() = 0 OR NOT USED('DD2') OR NOT USED('ALTDD2')
   RETURN slcReturn
ENDIF

slcValData = ''
IF SEEK(PADR(LEFT(dd2.file_name,112),112)+PADR(dd2.field_name,128),'altdd2')
   IF altdd2.val_type = 3					&& Referential validation
      slcValData = ALLTRIM(altdd2.val_data)
   ELSE
      IF altdd2.val_type = 4				&& Same As validation
         DO WHILE .T.
            slcValD = ALLTRIM(val_data)
            slnQuote1 = AT('"',slcValD,1)
            slnQuote2 = AT('"',slcValD,2)
            slnQuote3 = AT('"',slcValD,3)
            slnQuote4 = AT('"',slcValD,4)
            IF slnQuote1 > 0 AND slnQuote2 > 0 AND slnQuote3 > 0 AND slnQuote4 > 0
               slcSAFile = ALLTRIM(UPPER(SUBSTR(slcValD,slnQuote1+1,slnQuote2-slnQuote1-1)))
               slcSAField = ALLTRIM(UPPER(SUBSTR(slcValD,slnQuote3+1,slnQuote4-slnQuote3-1)))
               IF SEEK(PADR(LEFT(slcSAFile,112),112)+PADR(slcSAField,128),'altdd2')
                  DO CASE
                     CASE altdd2.val_type = 3
                        slcValData = ALLTRIM(altdd2.val_data)
                     CASE altdd2.val_type = 4
                        EXIT
                  ENDCASE
               ENDIF
            ENDIF
         ENDDO
      ENDIF
   ENDIF
ENDIF

IF NOT EMPTY(slcValData)
   * Print each relationship only once, not for each field in the foreign key.
   sllOKToPrt = .F.
   slnQuote1 = AT('"',slcValData,3)
   slnQuote2 = AT('"',slcValData,4)
   IF slnQuote1 > 0 AND slnQuote2 > 0
      slcField = ALLTRIM(UPPER(SUBSTR(slcValData,slnQuote1+1,slnQuote2-slnQuote1-1)))
      slnComma = AT(',',slcField)
      IF slnComma > 1
         slcField = LEFT(slcField,slnComma-1)
      ENDIF
      IF LEFT(slcField,2) == 'M.'
         slcField = SUBSTR(slcField,3)
      ENDIF
      IF slcField == ALLTRIM(dd2.field_name)
         sllOKToPrt = .T.
      ENDIF
   ENDIF
   IF sllOKToPrt
      DO CASE
         CASE slnPrtNum = 1				&& Child table or view name
            slcReturn = ALLTRIM(dd2.file_name)
         CASE slnPrtNum = 2				&& Child table or view foreign key field(s)
            slcForFlds = ''
            FOR slnFor = 1 TO 4
               slnQuote1 = AT('"',slcValData,slnFor*2+1)
               slnQuote2 = AT('"',slcValData,slnFor*2+2)
               IF slnQuote1 > 0 AND slnQuote2 > 0
                  slcFK = SUBSTR(slcValData,slnQuote1+1,slnQuote2-slnQuote1-1)
                  IF NOT EMPTY(slcFK)
                     slcForFlds = slcForFlds+','+slcFK
                  ENDIF
               ENDIF
            ENDFOR
            IF NOT EMPTY(slcForFlds)
               slcForFlds = IIF(LEFT(slcForFlds,1) <> ',',','+slcForFlds,slcForFlds)
               slcForFlds = IIF(RIGHT(slcForFlds,1) <> ',',slcForFlds+',',slcForFlds)
            ENDIF
            DO WHILE .T.
               slnComma1 = AT(',',slcForFlds,1)
               slnComma2 = AT(',',slcForFlds,2)
               IF slnComma1 > 0 AND slnComma2 > 0
                  slcForFld = SUBSTR(slcForFlds,slnComma1+1,slnComma2-slnComma1-1)
                  slcForFlds = SUBSTR(slcForFlds,slnComma2)
               ELSE
                  EXIT
               ENDIF
               IF NOT EMPTY(slcForFld)
                  IF LEFT(slcForFld,2) == 'M.'
                     slcForFld = SUBSTR(slcForFld,3)
                  ENDIF
                  IF EMPTY(slcReturn)
                     slcReturn = slcForFld
                  ELSE
                     slcReturn = slcReturn+CHR(13)+slcForFld
                  ENDIF
               ENDIF
            ENDDO
         CASE slnPrtNum = 3				&& Update rule
            slnQuote1 = AT('"',slcValData,23)
            slnQuote2 = AT('"',slcValData,24)
            IF slnQuote1 > 0 AND slnQuote2 > 0
               slnUpdRule = VAL(SUBSTR(slcValData,slnQuote1+1,slnQuote2-slnQuote1-1))
               DO CASE
                  CASE slnUpdRule = 2
                     slcReturn = 'Set Null'
                  CASE slnUpdRule = 3
                     slcReturn = 'Cascade'
                  CASE slnUpdRule = 4
                     slcReturn = 'No Change'
                  OTHERWISE
                     slcReturn = 'Restrict'
               ENDCASE
            ENDIF
         CASE slnPrtNum = 4				&& Delete rule
            slnQuote1 = AT('"',slcValData,25)
            slnQuote2 = AT('"',slcValData,26)
            IF slnQuote1 > 0 AND slnQuote2 > 0
               slnDelRule = VAL(SUBSTR(slcValData,slnQuote1+1,slnQuote2-slnQuote1-1))
               DO CASE
                  CASE slnDelRule = 2
                     slcReturn = 'Set Null'
                  CASE slnDelRule = 3
                     slcReturn = 'Cascade'
                  CASE slnDelRule = 4
                     slcReturn = 'No Change'
                  OTHERWISE
                     slcReturn = 'Restrict'
               ENDCASE
            ENDIF
         CASE slnPrtNum = 5				&& Parent table or view name
            slnQuote1 = AT('"',slcValData,1)
            slnQuote2 = AT('"',slcValData,2)
            IF slnQuote1 > 0 AND slnQuote2 > 0
               * Reference table or view
               slcReturn = ALLTRIM(SUBSTR(slcValData,slnQuote1+1,slnQuote2-slnQuote1-1))
            ENDIF
            IF EMPTY(slcReturn)
               slnQuote1 = AT('"',slcValData,41)
               slnQuote2 = AT('"',slcValData,42)
               IF slnQuote1 > 0 AND slnQuote2 > 0
                  * Picklist table or view
                  slcReturn = ALLTRIM(SUBSTR(slcValData,slnQuote1+1,slnQuote2-slnQuote1-1))
               ENDIF
            ENDIF
            IF EMPTY(slcReturn)
               slnQuote1 = AT('"',slcValData,43)
               slnQuote2 = AT('"',slcValData,44)
               IF slnQuote1 > 0 AND slnQuote2 > 0
                  * Valid table or view
                  slcReturn = ALLTRIM(SUBSTR(slcValData,slnQuote1+1,slnQuote2-slnQuote1-1))
               ENDIF
            ENDIF
            IF NOT EMPTY(slcReturn) AND LEFT(slcReturn,2) == 'M.' AND NOT slcReturn == 'M.DBF'
               slcReturn = ALLTRIM(UPPER(&slcReturn))
            ENDIF
         CASE slnPrtNum = 6				&& Parent table or view primary key field(s)
            slcPriFlds = ''
            FOR slnFor = 1 TO 4
               slnQuote1 = AT('"',slcValData,slnFor*2+9)
               slnQuote2 = AT('"',slcValData,slnFor*2+10)
               IF slnQuote1 > 0 AND slnQuote2 > 0
                  slcPK = SUBSTR(slcValData,slnQuote1+1,slnQuote2-slnQuote1-1)
                  IF NOT EMPTY(slcPK)
                     slcPriFlds = slcPriFlds+','+slcPK
                  ENDIF
               ENDIF
            ENDFOR
            IF NOT EMPTY(slcPriFlds)
               slcPriFlds = IIF(LEFT(slcPriFlds,1) <> ',',','+slcPriFlds,slcPriFlds)
               slcPriFlds = IIF(RIGHT(slcPriFlds,1) <> ',',slcPriFlds+',',slcPriFlds)
            ENDIF
            DO WHILE .T.
               slnComma1 = AT(',',slcPriFlds,1)
               slnComma2 = AT(',',slcPriFlds,2)
               IF slnComma1 > 0 AND slnComma2 > 0
                  slcPriFld = SUBSTR(slcPriFlds,slnComma1+1,slnComma2-slnComma1-1)
                  slcPriFlds = SUBSTR(slcPriFlds,slnComma2)
               ELSE
                  EXIT
               ENDIF
               IF NOT EMPTY(slcPriFld)
                  IF EMPTY(slcReturn)
                     slcReturn = slcPriFld
                  ELSE
                     slcReturn = slcReturn+CHR(13)+slcPriFld
                  ENDIF
               ENDIF
            ENDDO
      ENDCASE
   ENDIF
ENDIF

RETURN slcReturn
