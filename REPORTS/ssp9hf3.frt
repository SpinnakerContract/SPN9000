   h   !                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        u  need TO place      Arial               *:POP      H  !  winspool HP LaserJet III \\Joe-gateway \hp iii                                           �HP LaserJet III                  � @ g           ,  ,                                                                                 @ MSUDHP LaserJet III                 �              d 
                    �DRIVER=winspool
DEVICE=HP LaserJet III
OUTPUT=\\Joe-gateway \hp iii
ORIENTATION=0
PAPERSIZE=1
COPIES=1
DEFAULTSOURCE=1
PRINTQUALITY=300
YRESOLUTION=300
TTOPTION=2
                       df3.file_name                                                 Courier New                    df3.field_name                                                Courier New                    	dd2.label                      Courier New                    DATE()                         Courier New                    TranStr("F3 Help","R")         Arial                          TranStr("Page:","R")           Courier New                    _PAGENO                        Arial                          J                              TIME()                         Courier New                    df3.f3_text                                                   Arial                          TranStr("Table/View","R")      Arial                          TranStr("Label","R")           Arial                          TranStr("F3 Text","R")         Arial                          TranStr("Field","R")           Arial                          Arial                          Courier New                    Arial                          Arial                          dataenvironment                iLeft = 10
Top = 195
Width = 404
Height = 196
InitialSelectedAlias = "df3"
Name = "Dataenvironment"
                        �PROCEDURE OpenTables
SET TALK OFF
SET DELETED ON

IF _SCREEN.oApp.OpenView('F3HELPREPORT_V','System_v','df3',,,,,,,SET('DATASESSION'))
   INDEX ON LEFT(file_name,112)+field_name TAG file_name
   SET FILTER TO LEN(ALLTRIM(df3.f3_text)) > 0
   LOCATE
   IF _SCREEN.oApp.OpenView('DD2_V','System_v','dd2',,,,,,,SET('DATASESSION'))
      INDEX ON LEFT(file_name,112)+field_name TAG file_name
      SELECT df3
      SET RELATION TO LEFT(file_name,112)+field_name INTO dd2
   ENDIF
ENDIF

ENDPROC
                  ���    �  �                        �   %   u      �     �          �  U   G2� G �K %�C� F3HELPREPORT_V� System_v� df3������C� DATASESSIONv�9�  � ��� & �C� �p=� ��� � G(�CC� � �>� �� -�B %�C� DD2_V� System_v� dd2������C� DATASESSIONv�9�  � �� � & �C� �p=� ��� � F� � G-(�C� �p=� ��� � � � U  OAPP OPENVIEW	 FILE_NAME
 FIELD_NAME DF3 F3_TEXT DD2
 OpenTables,     ��1 a a �qaA !qq �A A 2                       �      )   �                  C