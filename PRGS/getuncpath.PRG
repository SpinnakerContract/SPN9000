* Program....: GetUNCPath.prg
* Version....: 1.0
* Author.....: Andrew Coates
* Date.......: September 28, 1998
* Notice.....: Copyright © 1998 Civil Solutions, All 
* Rights Reserved.
* Compiler...: Visual FoxPro 05.00.00.0415 for Windows
* Abstract...: Wrapper to the API call that converts a
* mapped drive path to the UNC path
* Changes....:
* Originally used WNetGetUniversalName, but that 
* doesn't work under Win95 (see KB Q131416). Now uses
* WNetGetConnection which uses a string rather than a
* structure so STRUCTURE_HEADER is now 0 
lParameters tcMappedPath, tnBufferSize 
* from winnetwk.h
#define UNIVERSAL_NAME_INFO_LEVEL 0x00000001
#define REMOTE_NAME_INFO_LEVEL 0x00000002
 
* from winerror.h
#define NO_ERROR 0
#define ERROR_BAD_DEVICE 1200
#define ERROR_CONNECTION_UNAVAIL 1201
#define ERROR_EXTENDED_ERROR 1208
#define ERROR_MORE_DATA 234
#define ERROR_NOT_SUPPORTED 50
#define ERROR_NO_NET_OR_BAD_PATH 1203
#define ERROR_NO_NETWORK 1222
#define ERROR_NOT_CONNECTED 2250
 
* local decision - paths are not likely to be longer
* than this - if they are, this function calls itself
* recursively with the appropriate buffer size as the 
* second parameter
#DEFINE MAX_BUFFER_SIZE 500
 
* string length at the beginning of the structure 
* returned before the UNC path
* ACC changed to 0 on 9/10/98 - Now using 
* WnetGetConnection which uses a string rather than a 
* struct
#DEFINE STRUCTURE_HEADER 0
 
local lcReturnValue
 
if type('tcMappedPath') = "C" and ! isnull(tcMappedPath)
* split up the passed path to get just the drive
local lcDrive, lcPath
* just take the first two characters - we'll put it 
* all back together later. If the first two 
* characters are not a valid drive, that's OK. The 
* error value returned from the function call will 
* handle it.
 
* case statement ensures we don't get the "cannot 
* access beyond end of string" error
do case
case len(tcMappedPath) > 2
lcDrive = left(tcMappedPath, 2)
lcPath = substr(tcMappedPath, 3)
case len(tcMappedPath) <= 2
lcDrive = tcMappedPath
lcPath = ""
endcase
 
declare INTEGER WNetGetConnection IN WIN32API ;
STRING @lpLocalPath, ;
STRING @lpBuffer, ;
INTEGER @lpBufferSize
 
* set up some variables so the appropriate call can 
* be made
local lcLocalPath, lcBuffer, lnBufferSize, ;
lnResult, lcStructureString
 
* set to +1 to allow for the null terminator
lnBufferSize = iif(pcount() = 1 or type('tnBufferSize') # "N" or isnull(tnBufferSize), ;
MAX_BUFFER_SIZE, ;
tnBufferSize) + 1
 
lcLocalPath = lcDrive
lcBuffer = space(lnBufferSize)
 
* now call the dll function
lnResult = WNetGetConnection(@lcLocalPath, @lcBuffer, @lnBufferSize)
 
do case
* string translated sucessfully
case lnResult = NO_ERROR 
* Actually, this structure-stripping is no longer
* required because WnetGetConnection() returns a
* string rather than a struct
lcStructureString = alltrim(substr(lcBuffer, STRUCTURE_HEADER + 1))
lcReturnValue = left(lcStructureString, ;
at(chr(0), lcStructureString) - 1) + lcPath
 
* The string pointed to by lpLocalPath is invalid.
case lnResult = ERROR_BAD_DEVICE 
lcReturnValue = tcMappedPath
 
* There is no current connection to the remote 
* device, but there is a remembered (persistent) 
* connection to it.
case lnResult = ERROR_CONNECTION_UNAVAIL 
lcReturnValue = tcMappedPath
 
* A network-specific error occurred. Use the 
* WNetGetLastError function to obtain a description 
* of the error.
case lnResult = ERROR_EXTENDED_ERROR 
lcReturnValue = tcMappedPath
 
* The buffer pointed to by lpBuffer is too small. 
* The function sets the variable pointed to by 
* lpBufferSize to the required buffer size.
case lnResult = ERROR_MORE_DATA 
lcReturnValue = [Unk...] &&dgetuncpath(tcMappedPath, lnBufferSize)
 
* None of the providers recognized this local name 
* as having a connection. However, the network is 
* not available for at least one provider to whom 
* the connection may belong.
case lnResult = ERROR_NO_NET_OR_BAD_PATH 
lcReturnValue = tcMappedPath
 
* There is no network present.
case lnResult = ERROR_NO_NETWORK 
lcReturnValue = tcMappedPath
 
* The device specified by lpLocalPath is not 
* redirected.
case lnResult = ERROR_NOT_CONNECTED 
lcReturnValue = tcMappedPath
 
otherwise
lcReturnValue = tcMappedPath
 
endcase
else 
lcReturnValue = tcMappedPath


endif


return lcReturnValue

