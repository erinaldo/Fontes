#INCLUDE "rwmake.ch"
#include "_FixSX.ch"

User Function Codi()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//Programa  ³ Tirar Caractere especial do SB1 ³ Andy º Data ³  03/11/03 ³ 
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local   _nRet := 0
 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a regua de processamento                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If _nRet == 0
	_cMsg := "Aguarde Processando Cadastro de Produto..."
	Processa({|| _nRet := CodSB1()}, _cMsg)
Endif


Return


Static Function CodSB1()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pega Todos os Campos do SB1 em SX3
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_cCampo:={}
_cVal  :={}

dbSelectArea("SB1")
dbGoTop()
Do While !Eof() 

	IncProc("Processando")

    _cCod:=StrTran( SB1->B1_COD, ".", "" )
    _cCod:=StrTran( _cCod, "-", "" )

	dbSelectArea("SB1")
	RecLock("SB1", .F.) 
	_nTam:=Fcount()               
	For _nConta := 1 To _nTam
		AADD(_cCampo, FieldName(_nConta) )
		AADD(_cVal,FieldGet(FieldPos(FieldName(_nConta))) )
	Next      
	msUnLock()       
	  
	dbSelectArea("SZZ")           
	RecLock("SZZ",.T.)
	For _nConta := 1 To _nTam
		_nPos2	:= FieldPos(_cCampo[_nConta])
		FieldPut(_nPos2,_cVal[_nConta])
	Next
    SZZ->B1_COD:=_cCod 
    msUnLock()    
    
    _cCampo:={}
    _cVal  :={}
   	
   	DbSelectarea("SB1")
	dbSkip()

EndDo

Return 