CLOSE DATABASES ALL 
CLEAR 

CD c:\sp9\reports\
WAIT WINDOW 'Browse windows appear when objcode = 53 and Expr contains PRINTER'

nDir = ADIR(arFRX,'*.FRX')
FOR x = 1 TO nDir
	cFile = ALLTRIM(arFrx(x,1))
	USE (cFile) SHARED IN 0 ALIAS thisFrx
	SELECT thisFrx
	SCAN 
		IF thisFrx.objcode = 53 AND ATC('Printer',thisFrx.Expr) > 0
			BROWSE 
		ENDIF 
	ENDSCAN 
	SELECT thisFrx
	USE 	
ENDFOR 
CD c:\sp9\

WAIT WINDOW 'Fix FRX complete'
