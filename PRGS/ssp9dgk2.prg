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
* S<Prefix>DGK2 - Increment the character value passed to this program and return that incremented character value. This
***************   program is called by the program S<Prefix>DGK1.

LPARAM stcLastUsed

LOCAL slcReturnValue

IF EMPTY(stcLastUsed)
   slcReturnValue = '1'
ELSE
   slcReturnValue = ALLTRIM(STR(VAL(stcLastUsed)+1))
ENDIF

RETURN slcReturnValue
