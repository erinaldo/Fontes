#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE "TOPCONN.CH"
#INCLUDE "TCBROWSE.CH"

/*
///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | FIGCTE01()         | AUTOR | TOTVS          | DATA | 10/07/2013 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - U_FIGCTE01()                                           |//
//|           | Solicitação de Contrato  									         |//
//+-----------------------------------------------------------------------------+//
//| MANUTENCAO DESDE SUA CRIACAO                                                |//
//+-----------------------------------------------------------------------------+//
//| DATA     | AUTOR                | DESCRICAO                                 |//
//+-----------------------------------------------------------------------------+//
//|          |                      |                                           |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
*/

#Define ENTER Chr(13)+Chr(10)

User Function FIGCTE01()

Local aCores    := {	{ 'EMPTY(Z7_USUAPR)'  , 'BR_VERMELHO'},;
{ '!EMPTY(Z7_USUAPR)' , 'BR_VERDE'}}

Private nUsado     := 0
Private cCadastro  := "Solicitação de Contrato - SIGAGCT"
Private cAlias1    := "SZ7"  // Solicitação de Contrato
Private cFilSZ7    := ""
Private aRotina    := {}
Private aPos       := {15, 1, 70, 315}
Private oCliente   := Nil
Private oTotal     := Nil
Private cCliente   := ""
Private nTotal     := 0

Private aSize    	:= {}
Private aObjects 	:= {}
Private aInfo    	:= {}
Private aPosObj  	:= {}
Private aPosGet  	:= {}

aSize := MsAdvSize()
aInfo := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}

aAdd(aObjects,{100,100,.T.,.T.})
aAdd(aObjects,{100,100,.T.,.T.})
aAdd(aObjects,{100,015,.T.,.F.})

aPosObj := MsObjSize(aInfo,aObjects)
aPosGet := MsObjGetPos((aSize[3]-aSize[1]),315,{{004,024,240,270}} )

aAdd( aRotina ,{"Pesquisar" ,"AxPesqui"  	,0,1})
aAdd( aRotina ,{"Visualizar",'AxVisual'		,0,2})		  		 		// Chama Visualização da Solicitação
aAdd( aRotina ,{"Incluir"   ,'U_AxIncSZ7'	,0,3})
aAdd( aRotina ,{"Alterar"   ,'u_AxAltSZ7'	,0,4})
aAdd( aRotina, {"Excluir"   ,"u_mSolDel"	,0,5})
aAdd( aRotina ,{"Legenda"   ,"u_Legend()"	,0,6})

If  Upper(Alltrim(cUsername)) == "ADMINISTRADOR"
	aAdd( aRotina ,{"Efetivar Solicitação"	,'u_FIGCTAP'	,0,7})  	// Chama tela de Processamento de Aprovação
	aAdd( aRotina ,{"Aprovar  Solicitação"	,'u_FIGCTAP'	,0,8})  	// Chama tela de Processamento de Aprovação
	aAdd( aRotina ,{"Gerar Contrato"			,'u_FIGCTAP'	,0,9})  	// Chama tela de Processamento de Aprovação
	aAdd( aRotina ,{"Cancelar Solicitação"	,'u_FIGCTAP'	,0,10})  	// Chama tela de Processamento de Aprovação
Endif

dbSelectArea(cAlias1)
dbSetOrder(1)
cFilPCE := xFilial(cAlias1)

mBrowse(,,,,cAlias1,,,,,,aCores,,, )

Return

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | u_LEGEND      | AUTOR | Donizeti A. Lopes  | DATA |   10/07/13  |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_Legenda()                                            |//
//|           |                                                                 |//
//|           | Cria legenda para usuario identificar os registros Processados  |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
User Function Legend()
Local aCor := {}

aAdd(aCor,{"BR_AMARELA"	,"Em Elaboração"    })
aAdd(aCor,{"BR_MARROM"		,"Aguardando Contingência" })
aAdd(aCor,{"BR_CYAN"		,"Orçamento Reprovado"      })
aAdd(aCor,{"BR_AZUL"		,"Aguardando Aprovação"     })
aAdd(aCor,{"BR_VERDE" 		,"Solicitação Pendente"     })
aAdd(aCor,{"BR_VERMELHO"	,"Solicitação Atendida"     })
aAdd(aCor,{"BR_PRETO"		,"Solicitação Cancelada"    })

BrwLegenda(cCadastro,OemToAnsi("Solicitação"),aCor)

Return


///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | FIGCTAP()          | AUTOR | Donizeti Lopes  | DATA | 10/07/2013 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_FIGCTP()                                             |//
//|           | Processamento da Aprovação      									  |//
//+-----------------------------------------------------------------------------+//
//| MANUTENCAO DESDE SUA CRIACAO                                                |//
//+-----------------------------------------------------------------------------+//
//| DATA     | AUTOR                | DESCRICAO                                 |//
//+-----------------------------------------------------------------------------+//
//|          |                      |                                           |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////

User Function FIGCTAP()

IF !EMPTY(SZ7->Z7_USUAPR)
	Aviso( cCadastro, OemToAnsi("Usuário "+SUBSTR(cUsuario,7,15) + ", solicitação " + SZ7->Z7_NUM + ENTER + ENTER + "Encontra-se APROVADA !"),{"Ok"})
else
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Consultar Saldo PCO									 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

ENDIF

Return

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³Fun‡…o    ³OpenSM0    ³ Autor ³TOTVS                 ³ Data ³24/02/09  ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Descri‡…o ³ Efetua a abertura do SM0 exclusivo                         ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³ Uso      ³ Atualizacao EST                                            ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function OpenEmp(lCompart)

Local lOpen      := .F.
Local nLoop      := 0

If Select('SM0') > 0
	dbSelectArea('SM0')
	dbCloseArea()
EndIf

For nLoop := 1 To 20
	dbUseArea(.T.,, 'SIGAMAT.EMP', 'SM0', lCompart, lCompart )
	If Select('SM0') > 0
		lOpen := .T.
		dbSetIndex('SIGAMAT.IND')
		Exit
	EndIf
	Sleep(500)
Next nLoop

Return lOpen

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | MSOLDEL.prw       | AUTOR | TOTVS           | DATA | 10/07/2013 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - mSolDel()                                              |//
//|           | Exclui o registro em questao                                    |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////

User Function mSolDel(cAlias1,nReg,nOpc)
Local nOpcA := 0
Local lDelSZ7 := .F.

nOpcA := AxVisual(cAlias1,nReg,2)

If nOpcA == 1
	dbSelectArea("SZ7")
	dbSetOrder(1)
	lDelSZ7 := IIF (EMPTY(SZ7->Z7_USUAPR),.T.,.F.)
	
	If lDelSZ7
		Begin Transaction
		DbSelectArea(cAlias1)
		RecLock(cAlias1,.F.)
		dbDelete()
		MsUnLock()
		End Transaction
	Else
		Aviso( cCadastro, "Não é possível a exclusão, esta solicitação ja foi aprovada.", {"Ok"} )
	Endif
Endif

Return

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | AxAltSZ7.PRW      | AUTOR | TOTVS           | DATA | 10/07/2013 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - AxAltSZ7()                                              |//
//|           | Valida a Alteração da Solicitação                               |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////

User Function AxAltSZ7(cAlias1,nReg,nOpc)
Local lAltSZ7 := .F.

lAltSZ7 := IIF (EMPTY(SZ7->Z7_USUAPR),.T.,.F.)

If lAltSZ7
    AxAltera(cAlias1,nReg,nOpc,,,,,"U_FITUDOOK()")
Else
	Aviso( cCadastro, "Não é possível a ALTERAÇÃO, esta solicitação ja foi aprovada.", {"Ok"} )
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AxIncSZ7 º Autor ³ TOTVS			       º Data ³  15/07/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina de Manutencao de Cadastro de Solicitação de Contratoº±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ FIESP                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AxIncSZ7()      

Local lRet     	:= .T.

AxInclui(cAlias1, , , , , ,"U_FITUDOOK()")  

Return lret                                  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FITUDOOK º  Autor   ³ TOTVS             º Data ³  15/07/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida a Inclusão/Alteração da Solicitação                   º±±
±±º          ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION FITUDOOK()
LOCAL _lRet := .T. // se nao bloquear grava os lançamentos com a chamada a funcao PcoDetLan

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Consultar Saldo PCO									 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Aviso( cCadastro, "Consultar Saldo PCO.", {"Ok"} )

if !PcoVldLan("900001","01","FIGCTE01")    
	_lRet	:=	.F.	
Endif

Return _lRet
