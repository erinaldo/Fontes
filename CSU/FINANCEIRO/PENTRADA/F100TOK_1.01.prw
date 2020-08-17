#include "rwmake.ch"

User Function F100TOK()

_aArea := {}
_aArea := GetArea()
_cNome := ""

_bRet := .F.

dbSelectArea("SA6")
If dbSeek(cFilial+M->E5_BANCO+M->E5_AGENCIA+M->E5_CONTA,.F.)
	
	If ALLTRIM(SA6->A6_EMPRESA) == ""
	
	Alert("E necessario cadastrar a empresa para a conta "+ALLTRIM(M->E5_CONTA)+" no cadastro de bancos!!!")
			
	Else
	
	_bRet := .T.
	
	Endif
	
Endif


RestArea(_aArea)

Return(_bRet)
