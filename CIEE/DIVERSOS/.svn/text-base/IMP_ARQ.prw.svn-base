#include 'protheus.ch'
#include 'parmtype.ch'

user function IMP_ARQ()

Local   cTitulo   := "IMPORTACAO TABELAS"
Local   cDesc1    := "SE2"
Local   cDesc2    := "SEA"
Local   cDesc3    := ""
Local   cDesc4    := ""
Local   cDesc5    := ""
Local   aButton   := {}
Local   aSay      := {}
Local   lOk       := .F.

Private oMainWnd  := NIL
Private oProcess  := NIL

// Mensagens de Tela Inicial
aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )
aAdd( aSay, cDesc4 )
aAdd( aSay, cDesc5 )
//aAdd( aSay, cDesc6 )
//aAdd( aSay, cDesc7 )

// Botoes Tela Inicial
aAdd(  aButton, {  1, .T., { || lOk := .T., FechaBatch() } } )
aAdd(  aButton, {  2, .T., { || lOk := .F., FechaBatch() } } )

FormBatch(  cTitulo,  aSay,  aButton )

If lOk	
	If MsgNoYes( "Confirma a atualização dos dicionários ?", cTitulo )
		oProcess := MsNewProcess():New( { | lEnd | lOk := ImpProc( @lEnd ) }, "Atualizando", "Aguarde, atualizando ...", .F. )
		oProcess:Activate()
		If lOk
			MsgStop( "Atualização Realizada.", "UPBCFG01" )
			dbCloseAll()
		Else
			MsgStop( "Atualização não Realizada.", "UPBCFG01" )
			dbCloseAll()
		EndIf

	EndIf

EndIf

/*/{Protheus.doc} ImpProc
//TODO Descrição auto-gerada.
@author emerson.natali
@since 19/02/2018
@version undefined

@type function
/*/
Static Function ImpProc(lEnd)

RpcSetType( 3 )
RpcSetEnv( '01', '0001' )

oProcess:SetRegua1( 8 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Atualiza o dicionário SX2         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oProcess:IncRegua1( "Atualizando arquivos" + " - " + SM0->M0_CODIGO + " " + SM0->M0_NOME + " ..." )

aDirect    := Directory("\1-TOTVS\EMERSON\*.DTC")

For _nI := 1 to Len(adirect)
	_cTopAlias 	:= SUBSTR(adirect[_nI,1],1,3)
	_cAlias 	:= "__"+SUBSTR(adirect[_nI,1],1,3)
	
	dbUseArea(.T., "CTREECDX", "\1-TOTVS\EMERSON\"+adirect[_nI,1], _cAlias , .F., .F.)
	
	dbSelectArea((_cAlias))
	((_cAlias))->(dbGotop())
	
	Do While !EOF()
		dbSelectArea((_cTopAlias))
		((_cTopAlias))->(DbSetOrder(1))
		((_cTopAlias))->(dbGotop())
		If _cTopAlias == "SE2"
			If !( ((_cTopAlias))->(DbSeek(xFilial()+ ((_cAlias))->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA) )) )
				RecLock("SE2",.T.)
				MsUnLock()
			EndIf
		Else
			If !( ((_cTopAlias))->(DbSeek(xFilial()+ ((_cAlias))->(EA_FILIAL+EA_NUMBOR+EA_PREFIXO+EA_NUM+EA_PARCELA+EA_TIPO+EA_FORNECE+EA_LOJA) )) )
			EndIf
		EndIf
		
		((_cAlias))->(DbSkip())
	EndDo
Next _nI

MsgInfo("Importacao Finalizada com Sucesso!!!")

RpcClearEnv()

return