#INCLUDE "RWMAKE.CH" 
#INCLUDE "TBICONN.CH" 


User Function WSFLUIG016( aVetor, cOper, cEmp, cFil)
Local cMsg := ""
Local cRet := ""
private lMsErroAuto := .F.

	DO CASE
	         CASE 	cOper == 1
	         	cRet := IncluiSB1( aVetor, cEmp, cFil )
	         	
	         CASE	cOper == 2
	         	cRet := AlteraSB1( aVetor, cEmp, cFil )
	      
	         OTHERWISE
	         	cMsg := .F.
	         	
	ENDCASE
 
Return cRet

Static Function IncluiSB1( aVetor, cEmp, cFil )
	Local cRet 	:= .F.
	Local aCod	:= {}
	Local cPath := ""
	Local cNomeArq := ""
	private lMsErroAuto := .F.

	dbCloseAll()
	cEmpAnt	:= cEmp
	cFilAnt	:= cFil
	cNumEmp := cEmpAnt+cFilAnt
	OpenSM0(cEmpAnt+cFilAnt)
	OpenFile(cEmpAnt+cFilAnt)

	BeginTran()

	MSExecAuto({|x,y| Mata010(x,y)},aVetor,3)
 
	If lMsErroAuto
	 	cMsg := MostraErro()
	 	DisarmTransaction()
	Else
		cRet := .T.
	Endif
	
	EndTran()
Return cRet

Static Function AlteraSB1( aVetor, cEmp, cFil )
Local cMsg := ""
Local cRet 	:= .F.
Local aCod	:= {}
Local cPath := ""
Local cNomeArq := "" 
private lMsErroAuto := .F.

	If aVetor[49][2] == ""
		aDel(aVetor, 49)
		aSize(aVetor, 48)
	Endif
	
	dbCloseAll()
	cEmpAnt	:= cEmp
	cFilAnt	:= cFil
	cNumEmp := cEmpAnt+cFilAnt
	OpenSM0(cEmpAnt+cFilAnt)
	OpenFile(cEmpAnt+cFilAnt)

	BeginTran()

	MSExecAuto({|x,y| Mata010(x,y)},aVetor,4)
 
	If lMsErroAuto
	 	cMsg := MostraErro()
	 	DisarmTransaction()
	Else
		cRet := .T.
	Endif
	
	EndTran()
	
Return cRet