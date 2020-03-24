*****************************************************************
*                                                               *
*   ProMatrix Corporation                                       *
*                                                               *
*   Copyright © 1995-2000 ProMatrix Corporation                 *
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
* S<Prefix>DGK1 - Generates a character or numeric value to be placed in a field. Normally, this program is run to generate
***************   a value to be placed in a key field in a new record. This program can be run from within an application or
*                 as a standalone program outside of an application.
*
* Syntax:
*
*    S<Prefix>DGK1(cFieldID [,lGenerateNumeric] [,cGenerationProgram] [,cGeneratedKeyView] [,cInitialLastUsed]
*       [,cGeneratedKeyViewDBC])
*
* Returns:
*
*    The value to be placed in the field. If the value for the field cannot be generated, a value of .F. is returned.
*
* Arguments:
*
*    cFieldID
*
*       The string used to find the field's record in the Generated Key table.
*
*    lGenerateNumeric
*
*       The last value generated is stored in a character field in the Generated Key table. However, the value returned by
*       this program does not have to be stored in a character field. If this parameter is .T., the value returned by this
*       program will be numeric, which can be stored in a numeric, integer, float, double, or currency field. Otherwise,
*       the value returned by this program will be of character type, which can be stored in a character or memo field.
*
*    cGenerationProgram
*
*       The name of the program that performs the calculation of the next generated value to use. This parameter allows for
*       a calculation routine other than the default VPM routine to be used. The program must accept the last value used as
*       a parameter.
*       Note: This parameter is required if this program is being run outside of a VPM application.
*
*    cGeneratedKeyView
*
*       The view that is used to access the last generated value used for the field. The view that is specified in this
*       parameter must use the parameter PKValue. If this parameter is not used, the default view, GENKEY_VP, is used.
*       Note: This parameter is required if this program is being run outside of a VPM application.
*
*    cInitialLastUsed
*
*       The initial last value used for the field. The value in this parameter is only used if a record does not exist in
*       the Generated Key table for the field and a new record is created.
*
*    cGeneratedKeyViewDBC
*
*       If a view is specified in the cGeneratedKeyView parameter, the database that contains that view must be specified
*       with this parameter. The path and/or extension can be included.

#INCLUDE 'MAIN.H'

LPARAM stcFieldID,stlGenerateNumeric,stcGenerationProgram,stcGeneratedKeyView,stcInitialLastUsed,stcGeneratedKeyViewDBC

LOCAL sllNewPKValue,slSavePKValue,sllGenerateNumeric,slcGenerationProgram,slcGeneratedKeyView,slcGeneratedKeyViewDBC,;
   slcInitialLastUsed,slnCurArea,sllGenKeyCursorAlreadyOpen,slcGKOnEscape,slcGKSetEscape,slnSaveDateTime,slReturnValue,;
   slcNewKey

slReturnValue = .F.
IF EMPTY(stcFieldID)
   RETURN slReturnValue
ENDIF

* Handle parameters.
sllGenerateNumeric = IIF(EMPTY(stlGenerateNumeric),.F.,.T.)
slcGenerationProgram = IIF(EMPTY(stcGenerationProgram),'S'+_SCREEN.oApp.cCurPre+'DGK2',stcGenerationProgram)
IF NOT EMPTY(stcGeneratedKeyView) AND NOT EMPTY(stcGeneratedKeyViewDBC)
   slcGeneratedKeyView = stcGeneratedKeyView
   slcGeneratedKeyViewDBC = stcGeneratedKeyViewDBC
ELSE
   slcGeneratedKeyView = 'GENKEY_VP'
   slcGeneratedKeyViewDBC = 'SYSTEM_V'
ENDIF
slcInitialLastUsed = IIF(EMPTY(stcInitialLastUsed),'0',stcInitialLastUsed)

* Set up the ON ESCAPE command so that the user will be able to abort the key generation process by pressing the Escape key.
RELEASE sglGKEscape
PUBLIC sglGKEscape
sglGKEscape = .F.
slcGKOnEscape = ON('ESCAPE')
slcGKSetEscape = SET('ESCAPE')
SET ESCAPE ON
ON ESCAPE sglGKEscape = .T.

slnCurArea = SELECT()
sllTransaction = TXNLEVEL() > 0
sllGenKeyCursorAlreadyOpen = USED('genkey')
IF sllGenKeyCursorAlreadyOpen AND sllTransaction
   USE IN genkey
   sllGenKeyCursorAlreadyOpen = .F.
ENDIF
sllNewPKValue = .F.
slSavePKValue = ''
slnSaveDateTime = GetDateTime()

DO WHILE .T.

   * If the user presses the Escape key, abort the key generation process.
   IF sglGKEscape
      EXIT
   ENDIF
   
   * Using the Generated Key view, retrieve the record for the field for which this program is being run.
   sllGenKeyCursorOpen = USED('genkey')
   IF (sllGenKeyCursorOpen AND sllTransaction) OR NOT sllGenKeyCursorOpen
      IF sllGenKeyCursorOpen
         * If a transaction is in progress the view cursor cannot be requeried and must be closed and reopened.
         USE IN genkey
      ENDIF
      SetParam(stcFieldID,@sllNewPKValue,@slSavePKValue)
      IF TYPE('_SCREEN.oApp') = 'O'
         * If this program is run from within an application, open the view using the OpenView method.
         _SCREEN.oApp.CloseViewSourceTables(.T.)
         IF NOT _SCREEN.oApp.OpenView(slcGeneratedKeyView,slcGeneratedKeyViewDBC,'genkey',,,,,,,SET('DATASESSION'))
            ResetParam(sllNewPKValue,slSavePKValue)
            EXIT
         ENDIF
      ELSE
         * If this program is run as a standalone program outside of an application, open the view using the USE command.
         SELECT 0
         USE (JUSTSTEM(slcGeneratedKeyViewDBC)+'!'+slcGeneratedKeyView) ALIAS genkey
         IF NOT USED('genkey')
            EXIT
         ENDIF
      ENDIF
      ResetParam(sllNewPKValue,slSavePKValue)
   ELSE
      SELECT genkey
      SetParam(stcFieldID,@sllNewPKValue,@slSavePKValue)
      IF REQUERY() <> 1
         ResetParam(sllNewPKValue,slSavePKValue)
         EXIT
      ENDIF
      ResetParam(sllNewPKValue,slSavePKValue)
   ENDIF

   * If a record does not exist for the field, create it.
   IF EOF()
      APPEND BLANK
      REPLACE genkey.fieldid WITH stcFieldID,;
              genkey.lastused WITH slcInitialLastUsed
      IF NOT TABLEUPDATE()
         TABLEREVERT()
         EXIT
      ENDIF
   ENDIF

   * Generate the key value.
   slcNewKey = &slcGenerationProgram(genkey.lastused)
   REPLACE genkey.lastused WITH slcNewKey
   IF TABLEUPDATE()
      IF sllGenerateNumeric
         slReturnValue = VAL(slcNewKey)		&& Return a numeric value
      ELSE
         slReturnValue = slcNewKey			&& Return a character value
      ENDIF
      EXIT
   ELSE
      TABLEREVERT()
   ENDIF
   
   * The key value could not be generated so keep trying. If at the end of 5 seconds the key value has not been generated,
   * display a message asking the user if they want to keep trying. If so, keep trying for another 5 seconds before bringing
   * up the message again.
   IF GetDateTime()-slnSaveDateTime > 5		&& Try for 5 seconds
      IF TYPE('_SCREEN.oApp.oMessage') <> 'O' OR _SCREEN.oApp.oMessage.DisplayMessage('Record already being used') = IDNO
         * The record you are attempting to use is already being used by someone else.  The record may be available if you
         * try to use it again.  Would you like to attempt to use the record again?
         EXIT
      ENDIF
      slnSaveDateTime = GetDateTime()
   ENDIF
ENDDO

* Restore the previous ON ESCAPE and SET ESCAPE commands.
RELEASE sglGKEscape
SET ESCAPE &slcGKSetEscape
ON ESCAPE &slcGKOnEscape

* Close the Generated Key cursor if it had to be opened by this program.
IF NOT sllGenKeyCursorAlreadyOpen
   IF USED('genkey')
      USE IN genkey
   ENDIF
   IF TYPE('_SCREEN.oApp') = 'O'
      _SCREEN.oApp.CloseViewSourceTables(.F.,SET('DATASESSION'))
   ENDIF
ENDIF

SELECT (slnCurArea)

RETURN slReturnValue

*****************
FUNCTION SetParam
*****************
LPARAMETERS stcFldID,stlNewPKValue,stSavePKValue

IF TYPE('PKValue') = 'U'
   PUBLIC PKValue
   stlNewPKValue = .T.
   stSavePKValue = ''
ELSE
   stlNewPKValue = .F.
   stSavePKValue = PKValue
ENDIF
PKValue = stcFldID

*******************
FUNCTION ResetParam
*******************
LPARAMETERS stlNewPKValue,stSavePKValue

IF stlNewPKValue
   RELEASE PKValue
ELSE
   PKValue = stSavePKValue
ENDIF

********************
FUNCTION GetDateTime
********************
* Return a string of the current year, month, day, and time of day in seconds (yyyymmddsssss.ss).

LOCAL sldCurrentDate,slnCurrentSeconds

sldCurrentDate = DATE()
slnCurrentSeconds = SECONDS()
IF sldCurrentDate <> DATE()		&& Make sure the DATE() and SECONDS() functions are evaluated on the same day
   sldCurrentDate = DATE()
   slnCurrentSeconds = SECONDS()
ENDIF
RETURN VAL(DTOC(sldCurrentDate,1)+CHRTRAN(STR(slnCurrentSeconds,8,2),' ','0'))
