#INCLUDE "rwmake.ch"
#include "_FixSX.ch"
#DEFINE _EOL CHR(13) + CHR(10)

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


// Fecha o arquivo texto e o arquivo de saida.
fClose(_nArq1)

Return


Static Function CodSB1()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pega Todos os Campos do SB1 em SX3
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SX3->(dbSetOrder(1)); SX3->(dbSeek("SB1"))
Do While SX3->X3_ARQUIVO == "SB1"
	If  X3USO(SX3->X3_USADO) .And. SX3->X3_CONTEXT != "V"
		aAdd(_aRet,SX3->X3_CAMPO)
	Endif
	SX3->(dbSkip())
EndDo



dbSelectArea("SB1")
dbGoTop()
Do While !Eof() 

	IncProc("Processando")

	dbSelectArea("SZZ")
	RecLock("SZZ", .T.)

	msUnLock()
   	DbSelectarea("SB1")
	dbSkip()

EndDo

Return 