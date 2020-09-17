#INCLUDE "TOTVS.CH"

/*/

{Protheus.doc} MT410TOK
                 
Ponto de Entrada

@author  Milton J.dos Santos	
@since   15/07/20
@version 1.0

/*/

User Function MT410TOK()
Local lRet   := .T.
Local lRegra := .T.

If Type("l410Auto") == "U"
//	lRegra := .F.		// Se for gestao de cerais pode vir vazio (NIL)
	lRegra := U_PEGC()	// Pontos de entrada da Gestao de Cereais
Else
	lRegra := ! ( l410Auto ) // Se for EXECUATO nao pode executar as Regra de Precos e descontos
Endif

// Verifica os campos obrigatorios para regra de precos e descontos
If  lRegra
	If ExistBlock("CMPREGRA")
		lRet := ExecBlock( "CMPREGRA", .F., .F.)
	EndIf
EndIf

//*************************************************************************************************************************************
/*Implemente o ponto de entrada antes da chamada do Bloco de Função do Gestão de Cereais....*/
//*************************************************************************************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³ Específico para ser utilizado pelo Gestão de Cereais 																			  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRet
	If ExistBlock("xMT40TOK")
		lRet := ExecBlock( "xMT40TOK", .F., .F.)
	EndIf
EndIf

Return( lRet )

