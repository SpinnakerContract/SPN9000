   �   !                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              Arial                          6    winspool  HPLJ1012  DOT4_001                           �HPLJ1012                        <� 4�            X                                                                                               SDDM    hp LaserJet 1012                                                                                                                                -                      ��� �   ��   �   ��   � � �                 d   d                                                       �  �           �                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        �DRIVER=winspool
DEVICE=HPLJ1012
OUTPUT=DOT4_001
ORIENTATION=0
PAPERSIZE=1
COPIES=1
DEFAULTSOURCE=7
PRINTQUALITY=600
DUPLEX=1
TTOPTION=0
COLLATE=0
      DTOC(DATE())+[   ]+TIME()                                     Arial                          "@I"                           Arial                          "FGI SHIPMENT NOTICE"          "@I"                           Arial                          "Ship"                         FGI_SHIP                                                      Arial                          "99,999"                       "@I"                           Arial                          
"Ship Amt"                     SHIP_AMT                                                      Arial                          "@Z $$$,$$$.$$"                "@I"                           Arial                          "PackSlip#"                    	SHIP_CRTN                                                     Arial                          "999999"                       "@I"                           Arial                          "Lot#"                         JOB                            Arial                          "@I"                           Arial                          "Fgi_OH"                       FGI                                                           Arial                          	"999,999"                      "@I"                           Arial                          "Bal"                          BAL                            Arial                          	"999,999"                      "@I"                           Arial                          "Code"                         CODE                           Arial                          CUSTOMER                       Arial                          "@I"                           Arial                          "Po"                           PO                             Arial                          "@I"                           Arial                          "Part"                         PART                           Arial                          "@I"                           Arial                          "Rev"                          REV                            Arial                          	CONSIGNED                      Arial                          "@I"                           Arial                          "PCode"                        	PROD_CODE                      Arial                          "@I"                           Arial                          
"Nextship"                     NEXTSHIP                       Arial                          "Page " + ALLTRIM(STR(_PAGENO))                                 Arial                          "@I"                           Arial                          "Qty"                          FGI_SHIP                                                      Arial                          	"@99,999"                      Arial                          Arial                          Arial                          Arial                          Arial                          dataenvironment                LLeft = 163
Top = 410
Width = 520
Height = 200
Name = "Dataenvironment"
                     cursor                         �Left = 10
Top = 20
Width = 101
Height = 90
Alias = "tmpfgiship1"
CursorSource = ..\..\nacvfp\temp3\tmpfgiship1.dbf
Name = "Cursor1"
                        wPROCEDURE Init
SET PROC TO DAVMPRCS
IF WEXIST("Report Designer")
  ZOOM WIND "Report Designer" MAX
ENDIF
ENDPROC
     