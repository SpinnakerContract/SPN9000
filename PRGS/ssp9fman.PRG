** 24Feb20 24Sep19 23Sep19 18Sep19 10Sep19 03Sep19
SET SAFETY OFF
SET TALK OFF
_SCREEN.BORDERSTYLE = 3
_SCREEN.VISIBLE=.F.
SET STATUS BAR OFF

IF FILE("C:\nacvfp9\Shipping.Vld")
  _screen.MinHeight =  820 + 45 && these set to be about the size of forms without being full screen
  _screen.MinWidth  = 1310 + 20
  _screen.Height    =  840 + 45
  _screen.Width     = 1310 + 20
ELSE
  _screen.MinHeight =  780  && these set to be about the size of forms without being full screen
  _screen.MinWidth  = 1150
  _screen.Height    =  810
  _screen.Width     = 1210
ENDIF

=SYS(3050,1,24000000) && FOREGROUND MEMORY set to 24 meg
=SYS(3050,1,24000000) && BACKGROUND MEMORY set to 24 meg
SET SAFETY OFF
SET PROCEDURE TO davmprcs
SET CPDIALOG OFF && ensure that tables without CodePage do not get prompts
SET COMPATIBLE OFF && ensures that FSIZE returns the field size not file size
SET EXCLUSIVE OFF
SET DELETED ON
SET REFRESH TO 5,5
zzStartDrv = ALLT(SYS(5))
zzStartDir = ALLT(SYS(5))+ALLT(SYS(2003))
_SCREEN.VISIBLE=.T.
IF 1=1  &&__pWS_Single = [W]
  SET PATH TO ALLT(zzStartDir)+[;]+zzStartDir+"\DATA"+[;]+zzStartDir+"\PRGS"+[;]+zzStartDir+"\FORMS"+[;F:\NACFOX] && needed, to "get started on right path"
&& // 05Aug2004 found that workstations were opening the server's configlc b4 VPM established path
ENDIF
*_SCREEN.VISIBLE=.F. 1024 768
IF SYSM(1) < 1020 .OR. SYSM(2) < 760
  _SCREEN.VISIBLE=.T.
  =MESSAGEBOX('Your Video resolution   '+ALLT(STR(SYSM(1)))+[ X ]+ALLT(STR(SYSM(2)))+'   is too low to run SPN9000 properly'+CHR(13);
    +[You will need a higher Video resolution to see all SPN9000 screens  ]+CHR(13)+CHR(13);
    +[Click on  File  then  Exit   -  to leave the SPN9000, ]+CHR(13);
    +[adjust your resolution to   1024 X 768   or higher and try again.  ],0+16,[SPN Notice])
ENDIF
*!*  IF FILE("sSP9fapd.apd") && check apd file and if missing fields re-structure the apd  ver5 to ver9 VPME
*!*    SET EXCLUSIVE ON
*!*    SELECT 0
*!*    USE sSP9fapd.apd
*!*    lneed1 = FSIZE("bell_file") < 1
*!*    lneed2 = FSIZE("lang_id") < 1
*!*    lneed3 = FSIZE("strict") < 1
*!*    lneed4 = FSIZE("name") # 50
*!*    SELECT sSP9fapd
*!*    USE
*!*    IF !USED("sSP9fapd").AND.lneed1.OR.lneed2.OR.lneed3.OR.lneed4
*!*  *!*      IF FILE("C:\ThisFileOnlyOn.CTI")
*!*  *!*        =pwaitMB([CTI  ONLY   APD FILE NEED ALTERATIONS])
*!*  *!*      ENDIF
*!*      IF lneed1
*!*        ALTER TABLE sSP9fapd.apd ADD COLUMN bell_file C(40)
*!*      ENDIF
*!*      IF lneed2
*!*        ALTER TABLE sSP9fapd.apd ADD COLUMN lang_id C(3)
*!*      ENDIF
*!*      IF lneed3
*!*        ALTER TABLE sSP9fapd.apd ADD COLUMN STRICT N(1)
*!*      ENDIF
*!*      IF lneed4
*!*        ALTER TABLE sSP9fapd.apd ALTER COLUMN NAME C(50)
*!*      ENDIF
*!*      REPLACE lang_id WITH [ML],STRICT WITH 1 IN sSP9fapd
*!*      IF USED("sSP9fapd")
*!*        USE IN sSP9fapd
*!*      ENDIF
*!*    ELSE
*!*      **WAIT [NO alter needed] WIND 
*!*    ENDIF
*!*  ENDIF
SET EXCLUSIVE OFF
IF [6.0] $ OS(3) .and. DOW(DATE())=2 && W7 mondays
  wtd=MESSAGEBOX([Please leave your computer on tonight for updates, ]+CHR(13)+CHR(13)+[Thanx - Spinnaker IT Department],0+48,[MONDAY UPDATE])
*1=OK

ENDIF

SET TALK OFF
SET FULLPATH ON
FOR ww = 2 TO 12 && sets all function keys config.fp
  ON KEY LABEL 'F'+ALLTRIM(STR(ww))
NEXT ww
PUBLIC psysvers,_pUserId,_pSecIsOn,_OkFpReset,__pWS_Single
IF 1=1  &&__pWS_Single = [W]
  SET PATH TO ALLT(zzStartDir)+[;]+zzStartDir+"\DATA"+[;]+zzStartDir+"\PRGS"+[;]+zzStartDir+"\FORMS"+[;F:\NACFOX] && needed, to "get started on right path"
&& // 05Aug2004 found that workstations were opening the server's configlc b4 VPM established path
ENDIF
SET FULLPATH ON
ERASE C:\nacvfp9\temp\tmpWBall.*
zCrCr = CHR(13)+CHR(13)
zCrLf = CHR(13)+CHR(10)
**WAIT SET("PATH") WINDOW TIMEOUT 1
*###################%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
*###################%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
*###################%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
*###################%%%%%%%%%%%%%%%%%%%%%\%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
*###################               DO  PREP_BUILD                !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

STORE                              [10.94  Build: MAR-23-2020]        TO psysvers &&+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*////                              [1234567890123456789012345]  NEVER CHANGE FORMAT or LEngth (c25) of psysvers.  SysInfo and other forms parse and analyze
*###################%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
*###################%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
*###################%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
*###################%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SET PROCEDURE TO davmprcs

SET SAFETY OFF

IF !FILE("F:\nacfox\confmirq.dbf")
  CREATE DBF F:\nacfox\confmirq FREE (fincre_r1 N(10))
  USE IN confmirq
ENDIF
IF !FILE("C:\nacvfp9\docassociations.dbf")
  CREATE DBF c:\nacvfp9\docassociations FREE ( cext c(5), apploc c(254), cmisc01 C(254), cmisc02 C(254), lflag01 L(1), dcreate T(8) )
  USE IN docassociations
ENDIF
IF !FILE("C:\nacvfp9\csmloccfg.dbf")
  CREATE DBF c:\nacvfp9\csmloccfg  FREE ( lastrma N(10), lastpa N(10), lastca N(10), lastcf N(10), lastscar N(10), last02 N(10), logic01 L(1), text1 C(200), lastav N(10))
  APPEND BLANK IN csmloccfg
  USE IN csmloccfg
ELSE
  SELE 0
  USE C:\nacvfp9\csmloccfg.dbf EXCL
  IF FSIZE('lastav')<1
    ALTER TABLE csmloccfg ADD COLUMN lastav C(10)
  ENDIF
  USE IN csmloccfg
ENDIF

ERASE C:\nacvfp9\docstemp\*.*  &&28Mar14 per GuyN so none hang around, users would need to use the docs copy function again in INVT FERRET or JOB MANAGEMENT


***** DOCASSOCIATIONS *****
cFileName = zzStartDir+'\docassociations.dbf'
IF !FILE((cFileName)) .and. FILE("F:\nacfox\docassociations.DBF")
  USE F:\nacfox\docassociations.DBF SHARED IN 0 NOUPDATE ALIAS prodfile
  SELE prodfile
  COPY TO (cFileName)
  SELECT prodfile
  USE
ENDIF

***** CONFIGLC *****
cFileName = zzStartDir+'\configlc.dbf'
IF !FILE((cFileName)) .and. FILE("F:\nacfox\configlc.DBF")
  USE F:\nacfox\configlc.DBF SHARED IN 0 NOUPDATE ALIAS prodfile
  SELE prodfile
  COPY TO (cFileName)
  SELECT prodfile
  USE
ENDIF

***** CONFLOC *****
cFileName = zzStartDir+'\confloc.dbf'
IF !FILE((cFileName)) .and. FILE("F:\nacfox\confloc.DBF")
  **WAIT cFileName  WIND
  USE F:\nacfox\confloc.DBF SHARED IN 0 NOUPDATE ALIAS prodfile
  SELE prodfile
  COPY TO (cFileName)
  SELECT prodfile
  USE
ENDIF
IF !USED('confloc')
  SELE 0
  USE (cFileName) ALIAS confloc EXCL
  IF FSIZE('fdefmenu') < 1
    ALTER TABLE confloc ADD COLUMN fdefmenu C(6)
  ENDIF
  IF FSIZE('lastvend') < 10 && 19Sep19 was 4 char
    ALTER TABLE confloc ALTER COLUMN lastvend C(10)
  ENDIF
  IF FSIZE('lastcust') < 10 && 19Sep19 was 4 char
    ALTER TABLE confloc ALTER COLUMN lastcust C(10)
  ENDIF
  IF FSIZE('last_po') < 6 && 19Sep19 was 5 char
    ALTER TABLE confloc ALTER COLUMN last_po C(6)
  ENDIF
  SELECT confloc
  USE
ENDIF


IF !FILE("C:\nacvfp9\n2o_cfg")
  CREATE DBF c:\nacvfp9\n2o_cfg ( clots c(254), cassemblys c(254), ccustcodes c(254);
    , lthr L(1), lcab L(1), lsmt L(1), lem L(1), lastmfg c(25), dstop D(8) )
  SELE n2o_cfg
  APPE BLANK
  REPL dstop WITH DATE()+180, lcab WITH .T., lsmt WITH .T., lem WITH .T., lthr WITH .T. IN n2o_cfg
  USE IN n2o_cfg
ENDIF
IF !FILE("C:\nacvfp9\temp\n2o_last.dbf")
  CREATE DBF c:\nacvfp9\temp\n2o_last ( lastdate D(8), lasttime C(8))
  SELE n2o_last
  APPE BLANK
  USE IN n2o_last
ENDIF
IF 1=1 &&!FILE("C:\nacvfp9\tmpinvt3")
  CREATE DBF c:\nacvfp9\temp\tmpinvt3 ( mfg c(25), loc c(10);
    , onhand N(9,2), avgcost N(10,4), extended N(12,2), desc c(30), misc C(30))
  SELE tmpinvt3
  *APPE BLANK
  *REPL mfg WITH [*******************] IN tmpinvt2
  COPY TO c:\nacvfp9\temp\tmpinvt2
  USE IN tmpinvt3
ENDIF
IF !FILE("F:\NACFOX\DOCS_CFG.DBF")
  CREATE DBF F:\NACFOX\DOCS_CFG (primaryloc C(100) )
  SELE docs_cfg
  APPE BLANK
  REPL primaryloc WITH [F:\DRAWINGS\] IN docs_cfg
  USE IN docs_cfg
ENDIF
IF 1=1 && NEED To ORDER   !FILE("C:\nacvfp9\temp\shorts.dbf").or. !FILE("C:\nacvfp9\temp\shortdet.dbf")
  *#############################   CAREFUL CHANGING STRUCTURES HERE, COULD MESS UP N2O MODULE ##############################
  SET TALK OFF
  SET SAFETY OFF  && _START_SPN_3.EXE
SET SAFETY OFF
*WAIT [A] WIND
IF FILE("F:\NACFOX\wsc16.dll") &&.and.!FILE("C:\nacvfp9\zlib.dll")
  COPY FILE F:\NACFOX\wsc16.dll TO C:\nacvfp9\wsc16.dll
ENDIF
IF FILE("F:\NACFOX\wsc32.dll") &&.and.!FILE("C:\nacvfp9\zlib.dll")
  COPY FILE F:\NACFOX\wsc32.dll TO C:\nacvfp9\wsc32.dll
ENDIF
IF FILE("F:\NACFOX\wsc32con.fox") &&.and.!FILE("C:\nacvfp9\zlib.dll")
  COPY FILE F:\NACFOX\wsc32con.fox TO C:\nacvfp9\wsc32con.fox
ENDIF
IF FILE("F:\NACFOX\wsc32fun.fox") &&.and.!FILE("C:\nacvfp9\zlib.dll")
  COPY FILE F:\NACFOX\wsc32fun.fox TO C:\nacvfp9\wsc32fun.fox
ENDIF
IF FILE("F:\NACFOX\zlib.dll").and.!FILE("C:\nacvfp9\zlib.dll")
  COPY FILE F:\NACFOX\zlib.dll TO C:\nacvfp9\zlib.dll
ENDIF
IF FILE("F:\NACFOX\zlib1.dll").and.!FILE("C:\nacvfp9\zlib1.dll")
  COPY FILE F:\NACFOX\zlib1.dll TO C:\nacvfp9\zlib1.dll
ENDIF
IF FILE("F:\NACFOX\xym16.dll").and.!FILE("C:\nacvfp9\xym16.dll")
  COPY FILE F:\NACFOX\xym16.dll TO C:\nacvfp9\xym16.dll
ENDIF
IF FILE("F:\NACFOX\xym32.dll").and.!FILE("C:\nacvfp9\xym32.dll")
  COPY FILE F:\NACFOX\xym32.dll TO C:\nacvfp9\xym32.dll
ENDIF
IF FILE("F:\NACFOX\xfrxlib.fll").and.!FILE("C:\nacvfp9\xfrxlib.dll")
  COPY FILE F:\NACFOX\xfrxlib.fll TO C:\nacvfp9\xfrxlib.fll
ENDIF
IF FILE("F:\NACFOX\xfrx.fxp").and.!FILE("C:\nacvfp9\xfrx.fxp") &&hndlib.dll
  COPY FILE F:\NACFOX\xfrx.fxp TO C:\nacvfp9\xfrx.fxp
ENDIF
IF FILE("F:\NACFOX\hndlib.dll").and.!FILE("C:\nacvfp9\hndlib.dll") &&
  COPY FILE F:\NACFOX\hndlib.dll TO C:\nacvfp9\hndlib.dll
ENDIF

IF !FILE("C:\NACVFP9\confloc.dbf")
  IF FILE("C:\NACFOX\confloc.dbf")
    COPY FILE C:\NACFOX\confloc.dbf TO C:\nacvfp9\confloc.dbf
  ELSE
    * can't just copy file because may be in use
    *!*      IF FILE("F:\NACFOX\confloc.dbf")
    *!*        COPY FILE F:\NACFOX\confloc.dbf TO C:\nacvfp9\confloc.dbf
    *!*      ENDIF
    IF FILE("F:\NACFOX\confloc.dbf")
      SET EXCLUSIVE OFF
      USE F:\NACFOX\confloc.dbf
      COPY TO C:\nacvfp9\confloc.dbf
      USE IN confloc
    ENDIF
  ENDIF
ENDIF
IF !FILE("C:\NACVFP9\confloc.fpt")
  IF FILE("C:\NACFOX\confloc.fpt")
    COPY FILE C:\NACFOX\confloc.fpt TO C:\nacvfp9\confloc.fpt
  ELSE
    * can't just copy file because may be in use
    *!*      IF FILE("F:\NACFOX\confloc.fpt")
    *!*        COPY FILE F:\NACFOX\confloc.dbf TO C:\nacvfp9\confloc.fpt
    *!*      ENDIF
  ENDIF
ENDIF

*!*    IF !FILE("c:\nacvfp9\TEMP\tshortdet.dbf")
*!*      CREATE DBF c:\nacvfp9\TEMP\tshortdet (LOT C(6) ,PART C(19) ,MFG C(25) ,QTY N(14,2) ,KIT_DATE D(8) ,ONORDER N(14,2) ,;
*!*      LOT_CNT N(3) ,KITTED N(14,2) ,QUOTE C(6) ,ON_HAND N(14,2) ,AVAILABLE N(14,2) ,TWO_LOT C(6) ,;
*!*      TWO_KIT D(8) ,CAE C(25) ,CUSTOMER C(10) ,CAE_OH N(14,2) ,CAE_OO N(14,2) ,PO_OO N(14,2) ,;
*!*      CAE_PO C(5) ,CAE_DUE D(8) ,ONHAND N(14,2) ,ON_ORDER N(14,2) ,CREATE_PO C(1) ,PO_CREATED L(1) ,;
*!*      VCODE C(10) ,CAES L(1) ,UCOST N(14,4) ,DESIREDDAT D(8) ,DESIREDQTY N(14,3) ,DESIREDCST N(14,4) ,;
*!*      LEXTRA L(1) ,LEADFREE C(1) ,ROHS C(1) ,UL C(1) ,CSA C(1) ,CEC C(1) ,;
*!*      BUYAM C(1) ,LINCLUDE L(1) ,LINCL_CAES L(1) ,RFQNUM N(10) ,LCAEEXTRA L(1) ,TRBL_QTY N(14,2) ,;
*!*      TROUBLES M(4) ,NEED_ALL N(14,2) ,NEXTDUE D(8) ,LAMORT L(1) )
*!*    ENDIF
*!*    IF !FILE("c:\nacvfp9\TEMP\shortdet.dbf")
*!*      CREATE DBF c:\nacvfp9\TEMP\shortdet;
*!*       ( LOT C(6) ,PART C(19) ,MFG C(25) ,QTY N(12,2) ,KIT_DATE D(8) ,ONORDER N(14,2) ,;
*!*         LOT_CNT N(3) ,KITTED N(14,2) ,QUOTE C(6) ,ON_HAND N(14,2) ,AVAILABLE N(14,2) ,TWO_LOT C(6) ,;
*!*         TWO_KIT D(8) ,CAE C(25) ,CUSTOMER C(10) ,CAE_OH N(14,2) ,CAE_OO N(12) ,PO_OO N(14,2) ,;
*!*         CAE_PO C(5) ,CAE_DUE D(8) ,ONHAND N(14,2) ,ON_ORDER N(14,2) ,CREATE_PO C(1) ,PO_CREATED L(1) ,;
*!*         VCODE C(10) ,CAES L(1) ,UCOST N(14,4) ,DESIREDDAT D(8) ,DESIREDQTY N(14,3) ,DESIREDCST N(14,4) ,;
*!*         LEXTRA L(1) ,LEADFREE C(1) ,ROHS C(1) ,UL C(1) ,CSA C(1) ,CEC C(1) ,;
*!*         BUYAM C(1) ,LINCLUDE L(1) ,LINCL_CAES L(1) ,RFQNUM N(10) ,LCAEEXTRA L(1) ,LAMORT L(1) ,;
*!*         MCODE C(10)  )
*!*        SELE shortdet
*!*        INDEX ON mfg+DTOC(kit_date,1) TAG mfg
*!*        INDEX ON lot TAG lot
*!*    ENDIF
*!*    
*!*    IF !FILE("c:\nacvfp9\TEMP\shorts.dbf")
*!*      SELE linclude,MFG,rohs,QUOTE,part,UCOST,VAL(TRAN(SUM(shortdet.QTY),'9999999.99')) AS totneed,000000000.00 AS net_need,;
*!*        MIN(KIT_DATE) AS need_date, LOT,desiredqty,desiredcst,0000000.00 AS tot_oo,0000000.00 AS tot_oh,000000.00 AS pq_need, .F. AS lfrompq,;
*!*        CREATE_PO, PO_CREATED, VCODE,MCODE, CAES,CAE, CUSTOMER,lincl_caes,;
*!*        CAE_OH, CAE_OO,PO_OO, VCODE AS Session, LEFT(VCODE,5) AS ponum,rfqnum;
*!*        FROM c:\nacvfp9\TEMP\shortdet GROUP BY shortdet.MFG WHERE linclude INTO DBF c:\nacvfp9\TEMP\shorts
*!*        SELE shorts
*!*    ENDIF
*!*    IF !FILE("c:\nacvfp9\TEMP\shortsexcl.dbf")
*!*      SELE linclude,MFG,rohs,QUOTE,part,UCOST,VAL(TRAN(SUM(shortdet.QTY),'9999999.99')) AS totneed,000000000.00 AS net_need,;
*!*        MIN(KIT_DATE) AS need_date, LOT,desiredqty,desiredcst,0000000.00 AS tot_oo,0000000.00 AS tot_oh, SPAC(254) AS reason,;
*!*        CREATE_PO, PO_CREATED, VCODE,MCODE, CAES,CAE, CUSTOMER,lincl_caes,;
*!*        CAE_OH, CAE_OO,PO_OO, VCODE AS Session, LEFT(VCODE,5) AS ponum,rfqnum;
*!*        FROM c:\nacvfp9\TEMP\shortdet GROUP BY shortdet.MFG WHERE linclude INTO DBF c:\nacvfp9\TEMP\shortsexcl
*!*        SELE shortsexcl
*!*        *INDEX ON mfg                 FOR !EMPT(need_date) .and. !EMPT(mfg) TAG mfg
*!*        *INDEX ON lot+mfg             FOR !EMPT(need_date) .and. !EMPT(mfg) TAG lot_mfg
*!*        *INDEX ON DTOS(need_date)+mfg FOR !EMPT(need_date) .and. !EMPT(mfg) TAG kit_mfg
*!*    ENDIF
*!*    IF USED("shorts")
*!*      USE IN shorts
*!*    ENDIF
*!*    IF USED("shortsexcl")
*!*      USE IN shortsexcl
*!*    ENDIF
*!*    IF USED("shortdet")
*!*      USE IN shortdet
*!*    ENDIF
ENDIF
**WAIT [B] WIND
SET SAFETY OFF
IF 1=1 &&!FILE("c:\nacvfp9\temp\tmpbom_b.dbf")
  SELE 0
  USE F:\NACFOX\main_b
  COPY STRU TO c:\nacvfp9\temp\tmpbom_b
  USE IN main_b
  SELE 0
  USE F:\NACFOX\main_m
  COPY STRU TO c:\nacvfp9\temp\tmpbom_m
  USE IN main_m
ENDIF
IF LEFT(zzStartDir,3)=="C:\" .and.!DIRECTORY(zzStartDir+"\TEMP")
  MD zzStartDir+"\TEMP"
ENDIF
IF LEFT(zzStartDir,3)=="C:\" .and.!DIRECTORY(zzStartDir+"\TEMP2")
  MD zzStartDir+"\TEMP2"
ENDIF
IF LEFT(zzStartDir,3)=="C:\" .and.!DIRECTORY(zzStartDir+"\TEMP3")
  MD zzStartDir+"\TEMP3"
ENDIF
IF LEFT(zzStartDir,3)=="C:\" .and.!DIRECTORY(zzStartDir+"\TEMP3\BACKUP")
  MD zzStartDir+"\TEMP3\BACKUP"
ENDIF
IF LEFT(zzStartDir,3)=="C:\" .and.!DIRECTORY(zzStartDir+"\TEMP4")
  MD zzStartDir+"\TEMP4"
ENDIF
IF LEFT(zzStartDir,3)=="C:\" .and.!DIRECTORY(zzStartDir+"\TEMP4\BACKUP")
  MD zzStartDir+"\TEMP4\BACKUP"
ENDIF
IF LEFT(zzStartDir,3)=="C:\" .and.!DIRECTORY(zzStartDir+"\WESTELL")
  MD zzStartDir+"\WESTELL"
ENDIF
*WAIT [C] WIND
zOnError = ON([ERROR])
ON ERROR zzerrnum = ERROR( )
SET SAFETY OFF
*!*  zExcl=SET([EXCL])
*!*  SET EXCL ON
zzerrnum = 0

SET SAFETY ON
PUBLIC _JUserFirst,_JUserLast,_JUserFull,_JUserPass,_JUserGoals,_JGoalsPass
STORE [] TO _JUserFirst,_JUserLast,_JUserFull,_JUserPass
*!*  _JUserFirst = [Pete]
*!*  _JUserLast  = [Ryder]
*!*  _JUserFull  = [Pete Ryder]
*!*  _JUserPass  = [5544/+]
*!*  _JUserGoals = .F.
*!*  _JGoalsPass = []
FOR ttq = 1 TO 3
  PUBLIC _JUserFirst,_JUserLast,_JUserFull,_JUserPass,_JUserGoals,_JGoalsPass,_JUserCrimp
  STORE [] TO _JUserFirst,_JUserLast,_JUserFull,_JUserPass
  STORE [&%*&Y(] TO _JGoalsPass
  STORE .F. TO kCont,_JUserGoals,_JUserCrimp
  SET EXCLUSIVE OFF
  SELE 0
  USE F:\NACFOX\pass
  zmess = [Good Day]
  DO CASE
    CASE BETW(SECO(),0,43199)
      zMess = [Good Morning]
    CASE BETW(SECO(),43200,63799)
      zMess = [Good Afternoon]
    OTHERWISE
      zMess = [Good Evening]
  ENDCASE
  DO CASE
    CASE ttq = 2
      nleft= -160
      ntop = 260
    CASE ttq = 3
      nleft= -200
      ntop = 360
    OTHERWISE
      nleft= 160
      ntop = 0
  ENDCASE
  DO FORM get_1_line WITH zMess+zCrLf+[Enter  your  SCMI  password  please  ],[];
    ,ntop,nleft,[ SCMI PassWord  (]+n_s(ttq)+[/3)],15,[],.T. TO _JUserPass
  SET PATH TO ALLT(zzStartDir)+[;]+zzStartDir+"\DATA"+[;]+zzStartDir+"\PRGS"+[;]+zzStartDir+"\FORMS"+[;F:\NACFOX] && needed, to "get started on right path"
  IF !USED("pass")
    *WAIT [C1a  ]+SET("path") WINDOW TIMEOUT 2
    SELE 0
    USE F:\NACFOX\pass
    *WAIT [C1b  ]+SET("path") WINDOW TIMEOUT 2
  ENDIF
  _JUserPass = ALLT(_JUserPass)
  *WAIT [C1   ]+_JUserPass WINDOW TIMEOUT 2
  IF LEN(ALLT(_JUserPass))>1
    *WAIT [C2] WINDOW TIMEOUT 2
    SELE pass
    SET ORDER TO first IN pass
    *WAIT [C3] WINDOW TIMEOUT 2
    lok92=.F.
    IF INLI(ALLT(_JUserPass),[(((((],[)))))]) &&[*****]
      DO FORM get_1_line WITH zMess+zCrLf+[PASSWORD  password  please  ],[];
        ,0,160,[ SCMI PassWord  (]+n_s(ttq)+[/3)],15,[],.T. TO _JPass21
      IF !USED("pass")
        *WAIT [D1a  ]+SET("path") WINDOW TIMEOUT 2
        SELE 0
        USE F:\NACFOX\pass
        *WAIT [D1b  ]+SET("path") WINDOW TIMEOUT 2
      ENDIF
      lshow_pw = [5544] == ALLT(_jpass21)
      ON KEY LABEL ENTER KEYB CHR(23)
      BROWSE FIELD first,last,xcq3=Reverseit(Lower(pass),lshow_pw):15 NOED NOAPPE NODELE FONT 'Verdana', 8
      ON KEY LABEL ENTER *
      lok92 = .T.
      _JUserPass = pass.pass
      IF !USED("pass")
        *WAIT [D2a  ]+SET("path") WINDOW TIMEOUT 2
        SELE 0
        USE F:\NACFOX\pass
        *WAIT [D2b  ]+SET("path") WINDOW TIMEOUT 2
       ENDIF
      SELE pass
      LOCATE FOR UPPE(ALLT(pass.pass)) == UPPE(ALLT(_JUserPass))
    ELSE
       IF !USED("pass")
        *WAIT [E1a  ]+SET("path") WINDOW TIMEOUT 2
        SELE 0
        USE F:\NACFOX\pass
        *WAIT [E1b  ]+SET("path") WINDOW TIMEOUT 2
      ENDIF
      SELE pass
      LOCATE FOR UPPE(ALLT(pass.pass)) == UPPE(ALLT(_JUserPass))
    ENDIF
    *WAIT [C4] WINDOW TIMEOUT 2
    *BROW
    IF FOUND() .or. lok92
      kCont = .T.
      _JUserFirst = ALLT(pass.first)
      _JUserLast  = ALLT(pass.last)
      _JUserFull  = ALLT(pass.first)+[ ]+ALLT(Pass.Last)
      _JUserGoals = pass.flag74
      _JGoalsPass = LEFT(pass.cflag01,10)
      _JUserCrimp = pass.flag12
      =zwindon(zMess+[  ]+_JUserFull)
      =zwindoff(.8)
      c82 = [Mach: ]+STRTR(ALLT(SYS(0)),[ # ],[  User: ])+[ ]+TTOC(DATET()) && +[   IP: ]+cip23+[   ]
      SELE pass
      REPLACE flagdet WITH ALLT(c82)+[  ]+_JUserFull+[  ]+ALLT(STR(SYSM(1)))+[-]+ALLT(STR(SYSM(2))) IN pass
      *WAIT [C5] WINDOW TIMEOUT 2
    ENDIF
  ENDIF
  RELE zMess
  USE IN pass
  *WAIT [C6] WINDOW TIMEOUT 2
  IF !kCont
   IF ttq = 3
      =pwaitMB([Invalid  SCMI  Password, access denied])
      **=siExitApp()
      RETURN
    ELSE
    ENDIF
  ELSE
    EXIT
  ENDIF
ENDFOR

if _JUserCrimp
  USE f:\nacfox\toolnotify.dbf shared IN o
  if toolnotify.needsmaint = 'YES'
    MESSAGEBOX('Maintenance is required for tools. Use SPN9000 Tooling to view tools.',0+64,'TOOL MAINTENANCE REQUIRED')
  endif
endif
*WAIT [D   ]+SET("PATH") WINDOW TIMEOUT 2


*################################  START OF VPME9  New Project  08/30/2019

=NUMLOCK(.T.)

SET TALK OFF
SET PATH TO ALLT(zzStartDir)+[;]+zzStartDir+"\DATA"+[;]+zzStartDir+"\PRGS"+[;]+zzStartDir+"\FORMS"+[;F:\NACFOX] && needed, to "get started on right path"
*WAIT [Petes place  ]+SET("PATH") WINDOW TIMEOUT 2

* Refox lines used when branding the application.
IF .F.
   _ReFox_=(9876543210)
   _ReFox_=(9876543210)
ENDIF
* Instantiate the Application object.
SET CLASSLIB TO ProApp ADDITIVE
SET CLASSLIB TO VPMApp ADDITIVE
_SCREEN.AddProperty('oApp')
_SCREEN.oApp = CREATEOBJECT('ProApp')
IF TYPE('_SCREEN.oApp') <> 'O'
   RELEASE CLASSLIB ProApp,VPMApp
   RETURN
ENDIF
SET PATH TO ALLT(zzStartDir)+[;]+zzStartDir+"\DATA"+[;]+zzStartDir+"\PRGS"+[;]+zzStartDir+"\FORMS"+[;F:\NACFOX] && needed, to "get started on right path"
*WAIT [E  ]+SET("PATH") WIND

* Initialize the application environment, bring up the application interface, and issue
* the READ EVENTS command. Pass the application prefix to the Startup method to identify
* the application being run.
_SCREEN.oApp.Startup('SP9')

* The CLEAR EVENTS command has been issued so release the Application object and exit
* the application.
_SCREEN.oApp.Cleanup_ExitApplication()
_SCREEN.oApp = .F.

**********************
FUNCTION AppEntryError
**********************
* The application's initial ON ERROR command calls this function when an error occurs
* before complete entry into the application has been attained. Therefore, the normal
* method if displaying error messages using the messaging system cannot be used.

LPARAM stnErrNum,stcMess,stcCode,stcProg16,stnCurLine

slnCodeLength = 191-LEN(ALLTRIM(STR(stnErrNum)))-LEN(stcMess)-LEN(stcProg16)-LEN(ALLTRIM(STR(stnCurLine)))
IF slnCodeLength > 0
   WAIT WINDOW 'ERROR #: '+ALLTRIM(STR(stnErrNum))+CHR(13)+'MESSAGE: '+stcMess+CHR(13)+;
      'PROGRAM: '+stcProg16+CHR(13)+'LINE #: '+ALLTRIM(STR(stnCurLine))+CHR(13)+;
      'CODE: '+LEFT(stcCode,slnCodeLength)+CHR(13)+CHR(13)+'Press any key...'
ELSE
   WAIT WINDOW 'ERROR #: '+ALLTRIM(STR(stnErrNum))+CHR(13)+'MESSAGE: '+stcMess+CHR(13)+;
      'PROGRAM: '+stcProg16+CHR(13)+'LINE #: '+ALLTRIM(STR(stnCurLine))+CHR(13)+CHR(13)+'Press any key...'
ENDIF
_SCREEN.oApp.Cleanup_ExitApplication()
_SCREEN.oApp = .F.
IF [C:\SP9] $ zzSartDir
  SET PATH TO ALLT(zzStartDir)+[;]+zzStartDir+"\DATA"+[;]+zzStartDir+"\PRGS"+[;]+zzStartDir+"\FORMS"+[;F:\NACFOX] && needed, to "get started on right path"
ENDIF
QUIT
