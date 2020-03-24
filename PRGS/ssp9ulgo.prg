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
* S<Prefix>ULgo - Display the application's logo.
***************

LOCAL slnSaveArea,slnSaveDSID,slcWOnTop

slnSaveArea = SELECT()
slnSaveDSID = SET('DATASESSION')

slcWOnTop = WONTOP()
ACTIVATE SCREEN
CLEAR

IF _SCREEN.oApp.OpenTable('S'+_SCREEN.oApp.cCurPre+'FAPD.APD','fapd',,,,,SET('DATASESSION'))
   IF NOT EOF()
      IF TYPE('fapd.logo_bmp') <> 'U' AND NOT EMPTY(fapd.logo_bmp)
         * Display logo from BMP or ICO file.
         IF TYPE('_SCREEN.imgLogo') <> 'O'
            _SCREEN.AddObject('imgLogo','image')
         ENDIF
         _SCREEN.imgLogo.Picture = fapd.logo_bmp
         IF TYPE('_SCREEN.oApp.oInt') = 'O'
            * This is an international application so translate the logo
            * file name.
            _SCREEN.oApp.oInt.TranslatePicture(_SCREEN.imgLogo)
         ENDIF
         _SCREEN.imgLogo.BackStyle = 0
         IF fapd.logo_pos = 1
            * Center logo.
            _SCREEN.imgLogo.Top = (_SCREEN.Height-_SCREEN.imgLogo.Height)/2
            _SCREEN.imgLogo.Left = (_SCREEN.Width-_SCREEN.imgLogo.Width)/2
         ELSE
            * Display logo at user-specified coordinates.
            _SCREEN.imgLogo.Top = fapd.logo_row
            _SCREEN.imgLogo.Left = fapd.logo_col
         ENDIF
         _SCREEN.imgLogo.Visible = .T.
      ELSE
         * Display logo from general field.
         IF fapd.logo_pos = 1
            * Center logo.
            @ 0,0 SAY fapd.logo_pic ;
               CENTER ;
               STYLE 'T'
         ELSE
            * Display logo at user-specified coordinates.
            @ fapd.logo_row,fapd.logo_col SAY fapd.logo_pic STYLE 'T'
         ENDIF
      ENDIF
      DO (_SCREEN.oApp.cCopyrightNoticeProgram)
   ENDIF
   USE IN fapd
ENDIF

SET DATASESSION TO (slnSaveDSID)
SELECT (slnSaveArea)

IF NOT EMPTY(slcWOnTop)
   ACTIVATE WINDOW (slcWOnTop) SAME
ENDIF
