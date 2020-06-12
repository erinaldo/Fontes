#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAFIN050TP  บ Autor ณ Patricia Fontaneziบ Data ณ  14/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ  Contas a Pagar(AFIN050TP) - TABELA PA9  				  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function AFIN050TP()

Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cAlias1 	:= "PA9"
Private cCadastro 	:= "Tํtulos - Contas a Pagar "
Private cDelFunc 	:= .T.
Private cString 	:= "PA9"
Private _cBanco 	:= SPACE(3)
Private _cAgencia   := SPACE(5)
Private _cConta     := SPACE(10)
Private lExibeLanc	:= .T.				// Exibir lancamento contแbil

Private aRotina := {{"Pesquisar"		,"AxPesqui"			,0,1},;
					{"Visualizar" 		,"AxVisual"			,0,2},;
					{"Incluir"			,"U_PA9INC()"		,0,3},; 		// Inclusao de Titulo
					{"Excluir" 			,"U_PA9EXCLUI"		,0,5},;
					{"Baixa Total" 		,"U_PA9Baixa()"		,0,6},; 	    // Baixa Total de Titulo
					{"Canc Baixa Total"	,"U_PA9BCANC()"		,0,7},;         // Cancelamento da Baixa Total
					{"Baixa Parcial"	,"U_BXPARCIAL()"	,0,8},;         // Baixa Parcial do Titulo
					{"Inconsistencia"	,"U_IINCON()"		,0,9},;	   		// Inconsistencia
					{"Eliminar Pend๊ncia","U_ELIMRES()"		,0,10},;		// Eliminar Residuo
					{"Historico"		,"U_CADPAC()"		,0,11},;		// Historico
					{"Legenda"   		,"U_LEGTP()"		,0,12}}			// Legenda



aCores	:= {{'PA9_RECONC == " " .AND. PA9_SALDO == PA9_VALOR'										, 'BR_VERDE'	},;  // EM ABERTO
			{'(PA9_RECONC == " " .OR. PA9_RECONC == "S") .AND. PA9_SALDO == 0'						, 'BR_VERMELHO'	},;  // BAIXADO TOTAL													, 'BR_AZUL'		},;
			{'PA9_RECONC == "S" .AND. PA9_SALDO <> 0'												, 'BR_AMARELO'	}}   // BAIXADO PARCIAL

dbSelectArea("PA9")
dbSetOrder(1)

dbSelectArea(cString)
mBrowse( 6,1,22,75,cString,,,,,,aCores)



Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPA9INC  บ Autor ณ Patricia Fontaneziบ Data ณ  14/06/12  	 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ  Botใo Inclusใo - se confirmado, o ExecAuto FINA050 sera   บฑฑ
ฑฑบ          ณ  ativado, para a gravacao dos dados na Tabela SE2          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function PA9INC()

Private _cNUM	   		:= ""
Private _cLoja 			:= ""
Private _cFornece  		:= ""
Private _cTipo 			:= ""
Private _cPrefixo  		:= 'FL'
Private _cItemCr  		:= ""
Private _nValor			:= 0
Private _cBco    		:= ""
Private _cAg      		:= ""
Private _cDAg    		:= ""
Private _cNatur			:= ""
Private _cConta  		:= ""
Private _aTitulo		:= {}
Private aCols			:= {}
Private lMsErroAuto 	:= .F.
Private _cNumRat		:= ""
Private _nCRESP

Private cArq	        := ""

_ret := AxInclui("PA9",0,3,,,,"U_VALINC()")//AxInclui(cAlias1)

IF _ret == 1   //Verifica se foi precionado o botao OK
	
	lEnd	:= .F.
	MsAguarde({|lEnd| RunProc(@lEnd)}, "Aguarde...", OemToAnsi("Processando Inclusใo do Tํtulo...Aguarde.."),.T.)
	
	//Deleta Arquivo (fisico) Temporario (tela de rateio contabil)
	If File(CARQ)
		dbselectarea("TCIEE")
		DbCloseArea("TCIEE")
		fErase(CARQ+".DBF")
	EndIf
Else	//Pressionado o Botao Cancelar
	//PODE-SE USAR TAMBEM O COMANDO ALIASINDIC("SA1"), QUE MOSTRA SE A TABELA ESTA OU NAO ABERTA
	IF SELECT("TCIEE") > 0
		DbSelectArea("PAA")
		PAA->(DbSetOrder(3))
		If Dbseek(xfilial("PAA")+ Alltrim(TCIEE->xNum +TCIEE->xPref +TCIEE->xForn + TCIEE->xLoja))
			While PAA->(!EOF()) .and. Alltrim(TCIEE->xNum +TCIEE->xPref +TCIEE->xForn + TCIEE->xLoja) == PAA->(PAA_TITULO+PAA_PREFIX+PAA_FORNEC+PAA_LOJA)
				PAA->(RecLock("PAA",.F.))
				DBDELETE()
				PAA->(MSUNLOCK())
				PAA->(DBSKIP())
			Enddo
		Endif
	Endif
	
Endif

_ret := 0

DbCloseArea("TCIEE")


Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRunProc  บ Autor ณ Patricia Fontaneziบ Data ณ  14/06/12  	 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ  MS AGUARDE DA INCLUSAO									   บฑฑ
ฑฑบ          ณ  													       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function RunProc(lEnd)

_cNUM		:= PA9->PA9_NUM
_cLoja		:= PA9->PA9_LOJA
_cFornece   := PA9->PA9_FORNEC
_nValor		:= PA9->PA9_VALOR
_cTipo		:= PA9->PA9_TIPO
_cItemCr	:= PA9->PA9_CTACRE
_cItemDeb	:= PA9->PA9_CTADEB
_cRateio	:= PA9->PA9_RATEIO
_nCRESP		:= PA9->PA9_CC
_cNatur		:= PA9->PA9_NATURE
_DEmiss		:= PA9->PA9_EMISSA
_DVenc		:= PA9->PA9_VENC
_DVencRe	:= PA9->PA9_VENCRE
_cHist		:= PA9->PA9_HIST
lExibeLanc	:= .T.

If Alltrim(PA9->PA9_TIPO) == 'FL' .AND. Alltrim(PA9->PA9_PREFIX) == 'FL'
	//If !TMP->CTJ_FLAG
	_aTitulo := {{"E2_PREFIXO", _CPREFIXO   			, NIL},; //FIXO
				{"E2_NUM"    , _CNUM				, NIL},; //Numero do Relatorio
				{"E2_PARCELA", ' '					, NIL},; //FIXO
				{"E2_TIPO"   , _CTIPO				, NIL},; //FIXO
				{"E2_HIST"   , _cHist				, NIL},; //FIXO
				{"E2_NATUREZ", _cNatur				, NIL},; //FIXO
				{"E2_FORNECE", _cFornece			, NIL},;
				{"E2_LOJA"   , _cLoja				, NIL},;
				{"E2_REDUZ"  , _cItemDeb			, NIL},;
				{"E2_RED_CRE", _cItemCr				, NIL},;
				{"E2_EMISSAO", _DEmiss				, NIL},;
				{"E2_VENCTO" , _DVenc				, NIL},;
				{"E2_VENCREA", _DVencRe				, NIL},;
				{"E2_RATEIO" , _cRateio				, NIL},;
				{"E2_VALOR"  , _nValor				, NIL},;
				{"E2_CCUSTO" ,_nCRESP				, NIL}}
	
	Begin Transaction
	
	MsExecAuto({|x,y,z,a,b,c| FINA050(x,y,z,a,b,c)},_aTitulo,,3,,,lExibeLanc)   	//MSEXECAUTO DE INCLUSAO DE TITULO
	
	If lMsErroAuto
		_aArea := GetArea()
		
		RestArea(_aArea)
		
		DisarmTransaction()
		MostraErro()
		break
	EndIf
	End Transaction
	
Endif

lEnd := .T.
Return


//*******************************************************************
// Valida็ใo de exist๊ncia de Tํtulo na Tabela PA9
//*******************************************************************

User Function TitDUP()

Local _cNumTit	:= PADL(ALLTRIM(M->PA9_NUM),9,"0")
Local _cForne2	:= M->PA9_FORNEC
Local _cRet		:= .T.
Local cQr		:= ""
Local _ncQr		:= 0

If !EMPTY(_cForne2)
	DBSELECTAREA("SA2")
	DBSETORDER(1)
	DBGOTOP()
	IF !DBSEEK(xFilial("SA2")+M->PA9_FORNEC)
		Alert("Fornecedor nใo cadastrado")
		_cRet	:= .F.
	Endif
Endif

cQr := " SELECT PA9_PREFIX,PA9_TIPO,PA9_FORNEC,PA9_LOJA, PA9_NUM "
cQr += " FROM "+ RetSqlName("PA9")
cQr += " WHERE PA9_NUM = '"+_cNumTit+"' AND PA9_PREFIX = '"+M->PA9_PREFIX+"' AND "
cQr += " PA9_TIPO = '"+M->PA9_TIPO +"' AND PA9_FORNEC = '"+M->PA9_FORNEC+"' AND "
cQr += " PA9_LOJA = '"+M->PA9_LOJA +"' AND PA9_FILIAL = '"+xFilial("PA9")+"' AND "
cQr += " D_E_L_E_T_ <> '*' "

cQr:= ChangeQuery(cQr)
DbUsearea(.T., 'TOPCONN', TCGENQRY(,,cQr),'cQr',.F.,.T.)

DbSelectarea("cQr")
While !EOF("cQR")
	_ncQr ++
	cQR->(DbSkip())
Enddo

If _ncQr <> 0
	Alert("Registro jแ existente. Favor verifique o n๚mero do Tํtulo e Fornecedor")
	_cRet	:= .F.
Endif

DbSelectarea("CQR")
CQR->(DBCLOSEAREA())

Return(_cRet)



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPA9BAIXA   บ Autor ณ Patricia Fontaneziบ Data ณ  03/07/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ  BAIXA TOTAL DO TITULO A PAGAR          					  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/


USER FUNCTION PA9BAIXA()

Local _cAlias 		:= GetArea()
Private aVetor 		:= {}
Private _lRet1		:= .F.
Private lF050AUTO  	:= .T.
Private lMsErroAuto := .F.
Private lEnd		:= .F.

lMsErroAuto 		:= .F.

If PA9->PA9_RECONC	== 'S'
	MSGINFO("Tํtulo Baixado!")
	Return
Endif


DEFINE MSDIALOG oDlgA FROM  51,58 TO 200,460 TITLE "BAIXA TOTAL - BANCO" PIXEL

@ 005, 060 SAY "Informe os Dados do Banco.:" SIZE 100, 007 OF oDlgA COLORS 0, 16777215 PIXEL

//@ 009, 005 SAY " _________________________________________________________________________________" SIZE 190, 007 OF oDlgA COLORS 0, 16777215 PIXEL
@ 012, 005 SAY " ----------------------------------------------------------------------------------------------" SIZE 200, 007 OF oDlgA COLORS 0, 16777215 PIXEL
@ 028, 005 SAY oSay4 PROMPT "Banco" SIZE 030, 007 OF oDlgA COLORS 0, 16777215 PIXEL
@ 028, 025 MSGET oGet2 VAR _cBanco F3 "PA9" WHEN .T. SIZE 005, 010 OF oDlgA COLORS 0, 16777215 PIXEL VALID BANCOCP()

@ 028, 065 SAY oSay4 PROMPT "Ag๊ncia" SIZE 030, 007 OF oDlgA COLORS 0, 16777215 PIXEL
@ 026, 090 MSGET oGet1 VAR _cAgencia When .F.  SIZE 007, 010 OF oDlgA COLORS 0, 16777215 PIXEL

@ 028, 130 SAY oSay4 PROMPT "Conta" SIZE 030, 007 OF oDlgA COLORS 0, 16777215 PIXEL
@ 028, 150 MSGET oGet1 VAR _cConta When .F.  SIZE 040, 010 OF oDlgA COLORS 0, 16777215 PIXEL

DEFINE SBUTTON FROM 058, 075 TYPE 1 ENABLE OF oDlgA ACTION (_lRet1:=.T.,oDlgA:End())
DEFINE SBUTTON FROM 058, 105 TYPE 2 ENABLE OF oDlgA ACTION (_lRet1 :=.F.,oDlgA:End())

ACTIVATE MSDIALOG oDlgA CENTERED

MsAguarde({|lEnd| AGBAIXA(@lEnd)}, "Aguarde...", OemToAnsi("Processando Baixa Total do Tํtulo...Aguarde.."),.T.)

RestArea(_cAlias)

Return

//*************************************************
//MSAGUARDE DA BAIXA TOTAL
//*************************************************

STATIC FUNCTION AGBAIXA(lEnd)

Local cNat999 := SuperGetMV("CI_NAT999",.T.,"99999999",)
If _lRet1
	DbSelectArea("SE2")
	DbSetOrder(1)
	DbGotop()
	If DbSeek(xFilial("SE2")+PA9->PA9_PREFIX + PA9->PA9_NUM +" "+ PA9->PA9_TIPO + PA9->PA9_FORNEC + PA9->PA9_LOJA)
		
		If EMPTY(SE2->E2_DATALIB)            //03 EH TITULO LIBERADO
			MSGINFO("Tํtulo nใo Liberado. Realize a Libera็ใo do Tํtulo!")
			Return()
		Else
			If AllTrim(SE2->E2_NATUREZ) == cNat999					//"9.99.99"
				MSGINFO("Titulo nใo poderแ ser Baixado. Altere a Natureza!")
				Return()
				
			Else
				aVetor :={{"E2_PREFIXO"	,PA9->PA9_PREFIX,Nil},;
						{"E2_NUM"	 	,PA9->PA9_NUM	,Nil},;
						{"E2_PARCELA"	," "			,Nil},;
						{"E2_TIPO"		,PA9->PA9_TIPO	,Nil},;
						{"E2_FORNECE"	,PA9->PA9_FORNEC,Nil},;
						{"E2_LOJA"  	,PA9->PA9_LOJA	,Nil},;
						{"AUTMOTBX" 	,"NOR"			,Nil},;		//MOTIVO BAIXA
						{"AUTBANCO"		,_cBanco		,Nil},;     //BANCO
						{"AUTAGENCIA"	,_cAgencia		,Nil},;     //AGENCIA
						{"AUTCONTA" 	,_cConta		,Nil},;     //CONTA
						{"AUTDTBAIXA"	,dDatabase		,Nil},;     //DATA BAIXA
						{"AUTDTDEB"		,dDatabase		,Nil},;     //DATA DO DEBITO
						{"AUTHIST"		,"BAIXA TITULO"	,Nil},;     //HISTORICO
						{"AUTVLRPG"		,PA9->PA9_VALOR ,Nil}}
				
				MSExecAuto({|x,y| Fina080(x,y)},aVetor,3) //Inclusใo da Baixa do Titulo,inclui a data da baixa do titulo no SE2,e gera registro do titulo no SE5
				If lMsErroAuto
					MSGINFO("Nใo foi possํvel concluir a Baixa do Tํtulo " + PA9->PA9_NUM)
					MostraErro()
				Else
					RECLOCK("PA9",.F.)
					PA9->PA9_RECONC	:= ''
					PA9->PA9_SALDO	:= 0
					MSUNLOCK()
					
					MSGINFO("Baixa Total do Tํtulo " + PA9->PA9_NUM + " concluํda com Sucesso !")
				Endif
			Endif
		Endif
	Endif
Else
	MSGINFO("Opera็ใo cancelada pelo usuแrio!")
Endif

lEnd := .T.

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPA9BCANC   บ Autor ณ Patricia Fontaneziบ Data ณ  03/07/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ  CANCELAMENTO BAIXA TOTAL DO TITULO A PAGAR  			  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/


USER FUNCTION PA9BCANC()

Local _cAlias 		:= GetArea()
Private aVetor 		:= {}
Private _cBancoSE5
Private _cAgSE5
Private _cContSE5
Private lF050AUTO  		:= .T.
Private _lReconc		:= .F.
Private lEnd			:= .F.

lMsErroAuto := .F.

DbSelectArea("SE5")
DbSetOrder(7)
DbGotop()
If DbSeek(xFilial("SE5")+PA9->PA9_PREFIX + PA9->PA9_NUM +" "+ PA9->PA9_TIPO + PA9->PA9_FORNEC + PA9->PA9_LOJA)
	While SE5->(!EOF()) .AND. SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA) == PA9->PA9_PREFIX + PA9->PA9_NUM +" "+ PA9->PA9_TIPO + PA9->PA9_FORNEC + PA9->PA9_LOJA
		If SE5->E5_SITUACA <> 'C'
			_cBancoSE5	:= SE5->E5_BANCO
			_cAgSE5		:= SE5->E5_AGENCIA
			_cContSE5	:= SE5->E5_CONTA
			If SE5->E5_RECONC == 'x'
				_lReconc	:= .T.
				Exit
			Endif
		Endif
		SE5->(dbskip())
	Enddo
Endif

MsAguarde({|lEnd| AGCANCB(@lEnd)}, "Aguarde...", OemToAnsi("Processando Cancelamento do Tํtulo...Aguarde.."),.T.)

RestArea(_cAlias)

Return


//****************************************
//MSAGUARDE DO CANCELAMENTO DA BAIXA
//****************************************

STATIC FUNCTION AGCANCB(lEnd)

If !_lReconc
	
	/*If PA9->PA9_SALDO == 0 .AND. PA9->PA9_RECONC = ' '
	MSGINFO("Titulo Totalmente Baixado. Nใo poderแ ser Cancelado")
	Return
	//Endif */
	
	DbSelectArea("SE2")
	DbSetOrder(1)
	DbGotop()
	If DbSeek(xFilial("SE2")+PA9->PA9_PREFIX + PA9->PA9_NUM +" "+ PA9->PA9_TIPO + PA9->PA9_FORNEC + PA9->PA9_LOJA)
		DbSelectArea("SE5")
		DbSetOrder(7)
		DbGotop()
		If DbSeek(xFilial("SE5")+PA9->PA9_PREFIX + PA9->PA9_NUM +" "+ PA9->PA9_TIPO + PA9->PA9_FORNEC + PA9->PA9_LOJA)
			While SE5->(!EOF()) .AND. SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA) == PA9->PA9_PREFIX + PA9->PA9_NUM +" "+ PA9->PA9_TIPO + PA9->PA9_FORNEC + PA9->PA9_LOJA
				If SE5->E5_SITUACA <> 'C'
					
					_cChave := SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)
					aRecSE5 := TrazRecSE5(_cChave)
					
					_nPos := Iif(Len(aRecSE5)>0,aScan(aRecSE5, SE5->(Recno())),0)
					
					aVetor :={{"E2_PREFIXO"	,PA9->PA9_PREFIX,Nil},;
							{"E2_NUM"	 	,PA9->PA9_NUM	,Nil},;
							{"E2_PARCELA"	," "			,Nil},;
							{"E2_TIPO"		,PA9->PA9_TIPO	,Nil},;
							{"E2_FORNECE"	,PA9->PA9_FORNEC,Nil},;
							{"E2_LOJA"  	,PA9->PA9_LOJA	,Nil},;
							{"AUTMOTBX" 	,"NOR"			,Nil},;		//MOTIVO BAIXA
							{"AUTBANCO"		,_cBancoSE5		,Nil},;     //BANCO
							{"AUTAGENCIA"	,_cAgSE5		,Nil},;     //AGENCIA
							{"AUTCONTA" 	,_cContSE5		,Nil},;     //CONTA
							{"AUTDTBAIXA"	,dDatabase		,Nil},;     //DATA BAIXA
							{"AUTDTDEB"		,dDatabase		,Nil},;     //DATA DO DEBITO
							{"AUTHIST"		,"BAIXA TITULO"	,Nil},;     //HISTORICO
							{"AUTVLRPG"		,SE5->E5_VALOR ,Nil}}
					
					//autvlrpg
					MSExecAuto({|x,y,z,w| Fina080(x,y,z,w)},aVetor,5,.F.,Iif(_nPos>0,_nPos,)) //Cancelamento da Baixa do Titulo,inclui a data da baixa do titulo no SE2,e gera registro do titulo no SE5
					
					//ATUALIZA O CAMPO DE RECONCILIACAO, PARA QUE POSSA SER FEITO NOVAS BAIXAS NESSE TITULO
					DBSELECTAREA("PA9")
					DBSETORDER(1)
					IF DBSEEK(xFilial("PA9")+PA9->PA9_PREFIX + PA9->PA9_NUM + PA9->PA9_TIPO + PA9->PA9_FORNEC + PA9->PA9_LOJA)
						RECLOCK("PA9",.F.)
						//						PA9->PA9_RECONC	:= ''
						PA9->PA9_RECONC	:= 'S' //alteracao 02/04/13. mesmo no cancelamento registra como possivel INCONSISTENCIA
						PA9->PA9_SALDO	:= PA9->PA9_VALOR
						MSUNLOCK()
					Endif
					
					DBSELECTAREA("PAB")
					DBSETORDER(3)
					IF DBSEEK(xFilial("PAB")+PA9->PA9_PREFIX + PA9->PA9_NUM + PA9->PA9_FORNEC)
						//While PAB->(!EOF())                // retirado em 17/10/2013
						While PAB->(!EOF()) .And. PAB->(PAB_FILIAL+PAB_PREFIX+PAB_NUM+PAB_CLIFOR) = xFilial("PAB")+PA9->(PA9_PREFIX+PA9_NUM+PA9_FORNEC)
							RecLock("PAB",.F.)
							//							PAB->PAB_SALDO	:= 0
							PAB->PAB_SALDO	:= PAB->PAB_VALOR  //alteracao 02/04/13. mesmo no cancelamento registra como possivel INCONSISTENCIA
							MSUNLOCK()
							PAB->(DBSKIP())
						ENDDO
					ENDIF
					
				Endif
				SE5->(DbSkip())
			Enddo
		Endif
		If lMsErroAuto
			MSGINFO("Nใo foi possํvel concluir o Cancelamento Baixa do Tํtulo " + PA9->PA9_NUM)
			MostraErro()
		Else
			MSGINFO("Cancelamento Baixa Total do Tํtulo " + PA9->PA9_NUM + " concluํda com Sucesso !")
		Endif
	Else
		MSGINFO("Tํtulo nใo encontrado para Cancelamento")
		Return()
	Endif
Else
	MSGINFO("Tํtulo jแ reconciliado, nใo poderแ ser Cancelado")
	Return()
Endif

lEnd	:= .T.

RETURN

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPA9BAIXAP   บ Autor ณ Patricia Fontaneziบ Data ณ  03/07/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ  BAIXA PARCIAL DO TITULO A PAGAR     					  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/


USER FUNCTION BXPARCIAL()

Static oMkwdlg
Static oDlg
Local oComboBo1
Local _cAlias 			:= GetArea()
Local n2 				:= 0
Private aPags	 		:= {}
Private _cTit           := PA9->PA9_NUM
Private _nValor         := TRANSFORM(PA9->PA9_VALOR,'9,999,999.99')
Private _nVlDeb			:= 0
Private _cPrefix		:= PA9->PA9_PREFIX
Private _cForn			:= PA9->PA9_FORNEC
Private _nVal			:= 0
Private _lClose			:= .F.
Private oOk     		:= LoadBitmap( GetResources(), "LBOK" )
Private oNo     		:= LoadBitmap( GetResources(), "LBNO" )
Private _lRet			:= .T.
Private lMsErroAuto 	:= .F.


//Se ja realizado o Parcial uma vez, nใo pode ser realizado novamente
/*
If PA9->PA9_RECONC	== 'S'
MSGINFO("Tํtulo Baixado")
Return
Endif
*/

If PA9->PA9_SALDO == 0
//If PA9->PA9_SALDO <> PA9->PA9_VALOR
	MSGINFO("Titulo Totalmente Baixado!")
//	MSGINFO("Tํtulo Baixado")
	Return
Endif

DBSELECTAREA("SA2")
DBGOTOP()
DBSETORDER(1)
If Dbseek(xFilial("SA2")+alltrim(_cForn))
	_cFornNome	:= SA2->A2_NOME
Endif

_cQR := " SELECT PAB_CLIFOR, PAB_NATURE, PAB_PREFIX, PAB_NUM, PAB_LOJA, PAB_VALOR, PAB_SALDO, ED_CODIGO, ED_DESCRIC "
_cQR += " FROM " + retsqlname("PAB") + " INNER JOIN "
_cQR += retsqlname("SED") + " ON PAB_NATURE = ED_CODIGO "
_cQR += " WHERE PAB_NUM = '"+PA9->PA9_NUM+"' AND PAB_PREFIX = '"+PA9->PA9_PREFIX+"' AND PAB_CLIFOR = '"+PA9->PA9_FORNEC+"' AND "
_cQR += " PAB_LOJA = '"+PA9->PA9_LOJA+"' AND PAB_SALDO <> '0' AND "
_cQR += retsqlname("SED") + ".D_E_L_E_T_ = ' ' AND "
_cQR += retsqlname("PAB") + ".D_E_L_E_T_ = ' ' AND PAB_FILIAL = '"+xFilial("PAB")+"' "

If SELECT("QRY") > 0
	QRY->(DBCLOSEAREA())
Endif

_cQR := ChangeQuery(_cQR)
DbUsearea(.T.,"TOPCONN",TCGENQRY(,,_cQR),"QRY",.F.,.T.)

DbselectArea("QRY")
While QRY->(!EOF())
	AADD(aPags,{.f.,QRY->PAB_NATURE,QRY->PAB_VALOR,QRY->PAB_SALDO,QRY->ED_DESCRIC,0})
	QRY->(DBSKIP())
Enddo

// Fluxo 2013          
If SELECT("QRY") > 0
	QRY->(DBCLOSEAREA())
Endif

_cQR := " SELECT PAB_CLIFOR, PAB_NATURE, PAB_PREFIX, PAB_NUM, PAB_LOJA, PAB_VALOR, PAB_SALDO, ED_CODIGO, ED_DESCRIC "
_cQR += " FROM " + retsqlname("PAB") + " INNER JOIN "
_cQR += retsqlname("SED") + " ON PAB_NATURE = ED_SUPORC "
_cQR += " WHERE PAB_NUM = '"+PA9->PA9_NUM+"' AND PAB_PREFIX = '"+PA9->PA9_PREFIX+"' AND PAB_CLIFOR = '"+PA9->PA9_FORNEC+"' AND " 
_cQR += " PAB_LOJA = '"+PA9->PA9_LOJA+"' AND PAB_SALDO <> '0' AND "	
_cQR += retsqlname("SED") + ".D_E_L_E_T_ = ' ' AND "
_cQR += retsqlname("PAB") + ".D_E_L_E_T_ = ' ' AND PAB_FILIAL = '"+xFilial("PAB")+"' "

If SELECT("QRY") > 0
	QRY->(DBCLOSEAREA())
Endif

_cQR := ChangeQuery(_cQR)
DbUsearea(.T.,"TOPCONN",TCGENQRY(,,_cQR),"QRY",.F.,.T.)

DbselectArea("QRY")
While QRY->(!EOF())   
	AADD(aPags,{.f.,QRY->PAB_NATURE,QRY->PAB_VALOR,QRY->PAB_SALDO,QRY->ED_DESCRIC,0})
	QRY->(DBSKIP())
Enddo 
//Se nใo ha dados no Array aPags, avisa ao usuแrio para abandonar a rotina
If Len(aPags) == 0
	Aviso("Baixa Parcial", "Nใo hแ dados a Consultar", {"OK"})
	Return
Endif


//DEFINE MSDIALOG oDlg FROM  31,58 TO 360,495 TITLE "BAIXA PARCIAL" PIXEL

DEFINE MSDIALOG oDlg FROM  51,58 TO 360,695 TITLE "BAIXA PARCIAL" PIXEL
@ 30,05 LISTBOX oLbx1 FIELDS HEADER "","Natureza","Descri็ใo","Valor","Valor a ser Debitado" SIZE 310, 100 OF oDlg PIXEL ;
ON DBLCLICK (u_MARKD())

@ 005, 005 SAY oSay4 PROMPT "Banco" SIZE 030, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 005, 025 MSGET oGet2 VAR _cBanco F3 "PA9" WHEN .T. SIZE 005, 010 OF oDlg COLORS 0, 16777215 PIXEL VALID BANCOCP()

@ 005, 065 SAY oSay4 PROMPT "Ag๊ncia" SIZE 030, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 005, 090 MSGET oGet1 VAR _cAgencia When .F.  SIZE 007, 010 OF oDlg COLORS 0, 16777215 PIXEL

@ 005, 130 SAY oSay4 PROMPT "Conta" SIZE 030, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 005, 150 MSGET oGet1 VAR _cConta When .F.  SIZE 040, 010 OF oDlg COLORS 0, 16777215 PIXEL


oLbx1:SetArray(aPags)
oLbx1:bLine := { || {If(aPags[oLbx1:nAt,1],oOk,oNo),aPags[oLbx1:nAt,2],aPags[oLbx1:nAt,5],Transform(aPags[oLbx1:nAt,3],"@EZ 999,999,999.99"),Transform(aPags[oLbx1:nAt,4],"@EZ 999,999,999.99")}}//,Transform(aPags[oLbx1:nAt,4],"@EZ 999,999,999.99")}}
oLbx1:nFreeze  := 1

DEFINE SBUTTON FROM 140, 128 TYPE 1 ENABLE OF oDlg ACTION (SomaOK(),_lRet)
DEFINE SBUTTON FROM 140, 158 TYPE 2 ENABLE OF oDlg ACTION (_lRet :=.F.,oDlg:End())

ACTIVATE MSDIALOG oDlg CENTERED

If _lRet == .F.
	MSGINFO("Opera็ใo cancelada pelo Usuแrio!")
Else
	If Empty(_cBanco)
		MsgInfo("Preencha os dados Bancแrio")
		Return(.F.)
	Endif
Endif

//oDlg:End()
RestArea(_cAlias)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAFIN050TP บAutor  ณPatricia Fontanezi  บ Data ณ  05/07/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Abre CX Dialogo caso seja ticado o check Box               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

STATIC FUNCTION EDITA()

Local _nI  		:= 0
Local _nSoma	:= 0
Local _nVlDig	:= 0
Local _nResto	:= 0
//Local aAlterado	:= {}
_nVal 		:= aPags[oLbx1:nAt,4]

@ 000,000 TO 190,290 Dialog oDlg01 Title "Altera็ใo Valor Titulo"
@ 001,001 TO 006,017
@ 002,006 Say "   DIGITE O VALOR : "
@ 003,007 Get _nVal Picture "@E 9,999,999.99" size 45,15 VALID ValDig()
@ 067,062 BMPBUTTON TYPE 1 Action (FunClose(_lClose :=.T.,_lRet,))
Activate Dialog oDlg01 CENTERED


oLbx1:Refresh(.T.)

_nVal	:= 0

Return(_lRet)

//********************************************
//Validacao na digitacao do usuario
//********************************************

STATIC FUNCTION VALDIG()

If _nVal == 0
	MSGINFO("Digite o Valor corretamente")
	_lRet	:= .F.
Else
	If _nVal > aPags[oLbx1:nAt,3]
		MSGINFO("Valor digitado Maior do que o Valor permitido por essa Natureza")
		_lRet	:= .F.
	Else
		aPags[oLbx1:nAt,4] 	:= _nVal
		_lRet	:= .T.
	Endif
Endif

RETURN(_lRet)


//**************************************
// FUNCAO PARA FECHAR CAIXA DE DIALOGO
//**************************************
Static Function FunClose()
oDlg01:End()
Return(.T.)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAFIN050TP บAutor  ณPATRICIA FONTANEZI  บ Data ณ  05/07/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ Funcao Verifica se esta ticado ou nao o checkBox           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User FUNCTION MARKD()

_lFlag := aPags[oLbx1:nAt,1]

If _lFlag
	aPags[oLbx1:nAt,1] := .F.
	aPags[oLbx1:nAt,4] := aPags[oLbx1:nAt,3]
Else
	aPags[oLbx1:nAt,1] := .T.
	EDITA()
EndIf

oLbx1:Refresh(.T.)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSOMAOK    บAutor  ณPATRICIA FONTANEZI  บ Data ณ  05/07/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ VALIDA SE O VALOR ALTERADO BATE COM O TOTAL DO TITULO      บฑฑ
ฑฑบ          ณ VALIDACAO NO BOTAO OK                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

STATIC FUNCTION SOMAOK()

Private _n1		:= 0
Private _nSoma	:= 0
Private _nVlDig	:= 0
Private _nResto	:= 0
Private _nSaldo	:= 0
Private _nVlBaix:= 0
Private aResto	:= {}
Private lEnd	:= .F.
/*For _n1 := 1 to Len(aPags)
_nSoma	+= aPags[_n1][3]
_nVlDig	+= aPags[_n1][4]
Next _n1

If _nSoma > _nVlDig
MSGINFO("Somat๓ria do Valor Digitado menor que o valor total do Tํtulo")
_lRet	:= .F.
ElseIf _nSoma < _nVlDig
MSGINFO("Somat๓ria do Valor Digitado maior que o valor total do Tํtulo")
_lRet	:= .F.
Else
_lRet	:= .T.
//For _n1 := 1 to Len(aPags)
//CHAMAR O EXECAUTO PARA GERAR QUEBRADO CADA NATUREZA
//GERAR NO SE5 SEMPRE A NATUREZA COM O VALOR DIGITADO, E SE HOUVER SOBRAS,
// GERAR OUTRO REGISTRO NO SE5 COM A MESMA NATUREZA QUE FOI FEITA A DIGITACAO, POREM CONTENDO O VALOR QUE SOBROU
//Next _n1
MSGINFO("Opera็ใo realizada com Sucesso!")
oDlg:End()
Endif
*/
//-----------------------------------------------------------------------------------------------------------------------
//CHAMAR O EXECAUTO PARA GERAR QUEBRADO CADA NATUREZA
//GERAR NO SE5 SEMPRE A NATUREZA COM O VALOR DIGITADO, E SE HOUVER SOBRAS,
// GERAR OUTRO REGISTRO NO SE5 COM A MESMA NATUREZA QUE FOI FEITA A DIGITACAO, POREM CONTENDO O VALOR QUE SOBROU
//-----------------------------------------------------------------------------------------------------------------------

//Grava no array o valor que sobrou, caso nao seja igual ao valor real da natureza
MsAguarde({|lEnd| AGBXPC(@lEnd)}, "Aguarde...", OemToAnsi("Processando Baixa Parcial do Tํtulo...Aguarde.."),.T.)

Return

//**************************************
//MSAGUARDE DA BAIXA PARCIAL DO TITULO
//*************************************
STATIC FUNCTION AGBXPC(lEnd)

Local _nTick	:= 0
Local cNat999 := SuperGetMV("CI_NAT999",.T.,"99999999",)
For _n1 := 1 to Len(aPags)
	If aPags[_n1][4] == 0
		MSGINFO("Nใo sใo permitidos valores zerados")
		Exit
		_lRet	:= .F.
	Else
		_lRet	:= .T.
	Endif
	If aPags[_n1][1] == .F.      //Soma a qtidade de nใo ticados, caso nใo haja nenhum ticado, sera disparada a pergunta abaixo
		_nTick++
	Endif
Next _n1

If _nTick == Len(aPags)
	If APMSGYESNO("Nใo foi selecionada nenhuma Baixa Parcial. Deseja Continuar ?")
		_lRet	:= .T.
	Else
		_lRet	:= .F.
		Return()
	Endif
Else
	_lRet	:= .T.
Endif
//BAIXA PARCIAL COM VALOR TOTAL
If _lRet
	For _n1 := 1 to Len(aPags)
		//If aPags[_n1][1] == .T.
		DbSelectArea("SE2")
		DbSetOrder(1)
		DbGotop()
		If DbSeek(xFilial("SE2")+PA9->PA9_PREFIX + PA9->PA9_NUM +" "+ PA9->PA9_TIPO + PA9->PA9_FORNEC + PA9->PA9_LOJA)
			If EMPTY(SE2->E2_DATALIB)
				MSGINFO("Tํtulo nใo Liberado. Realize a Libera็ใo do Tํtulo!")
				Return()
			Else
				If AllTrim(SE2->E2_NATUREZ) == cNat999					//"9.99.99"
					MSGINFO("Titulo nใo poderแ ser Baixado. Altere a Natureza!")
					Return()
				Else
					aVetor :={{"E2_PREFIXO"	,PA9->PA9_PREFIX,Nil},;
							{"E2_NUM"	 	,PA9->PA9_NUM	,Nil},;
							{"E2_PARCELA"	," "			,Nil},;
							{"E2_TIPO"		,PA9->PA9_TIPO	,Nil},;
							{"E2_FORNECE"	,PA9->PA9_FORNEC,Nil},;
							{"E2_LOJA"  	,PA9->PA9_LOJA	,Nil},;
							{"AUTMOTBX" 	,"NOR"			,Nil},;		//MOTIVO BAIXA
							{"AUTBANCO"		,_cBanco		,Nil},;     //BANCO
							{"AUTAGENCIA"	,_cAgencia		,Nil},;     //AGENCIA
							{"AUTCONTA" 	,_cConta		,Nil},;     //CONTA
							{"AUTDTBAIXA"	,dDatabase		,Nil},;     //DATA BAIXA
							{"AUTDTDEB"		,dDatabase		,Nil},;     //DATA DO DEBITO
							{"AUTHIST"		,"BAIXA TITULO"	,Nil},;     //HISTORICO
							{"AUTVLRPG"		,aPags[_n1][4] ,Nil}}       // vALOR DIGITADO PELO USUARIO
					
					MSExecAuto({|x,y| Fina080(x,y)},aVetor,3)
					//BAIXA DAS SOBRAS COM A NATIREZA da Sobra
					
					If lMsErroAuto
						MostraErro()
						Return
					Endif
					
					If aPags[_n1][1] == .T.
						
						RECLOCK("SE5",.F.)
						SE5->E5_RECONC	:= 'x'
						MSUNLOCK()
					Endif
					
					If aPags[_n1][4] <> aPags[_n1][3]
						_nResto	:= (aPags[_n1][3] - aPags[_n1][4])
						aPags[_n1][5]	:= _nResto
						aVetor :={{"E2_PREFIXO"	,PA9->PA9_PREFIX,Nil},;
								{"E2_NUM"	 	,PA9->PA9_NUM	,Nil},;
								{"E2_PARCELA"	," "			,Nil},;
								{"E2_TIPO"		,PA9->PA9_TIPO	,Nil},;
								{"E2_FORNECE"	,PA9->PA9_FORNEC,Nil},;
								{"E2_LOJA"  	,PA9->PA9_LOJA	,Nil},;
								{"AUTMOTBX" 	,"NOR"			,Nil},;		//MOTIVO BAIXA
								{"AUTBANCO"		,_cBanco		,Nil},;     //BANCO
								{"AUTAGENCIA"	,_cAgencia		,Nil},;     //AGENCIA
								{"AUTCONTA" 	,_cConta		,Nil},;     //CONTA
								{"AUTDTBAIXA"	,dDatabase		,Nil},;     //DATA BAIXA
								{"AUTDTDEB"		,dDatabase		,Nil},;     //DATA DO DEBITO
								{"AUTHIST"		,"BAIXA TITULO"	,Nil},;     //HISTORICO
								{"AUTVLRPG"		,aPags[_n1][5] ,Nil}}       // vALOR DIGITADO PELO USUARIO
						
						MSExecAuto({|x,y| Fina080(x,y)},aVetor,3)
						
						If lMsErroAuto
							MostraErro()
							Return
						Endif
						/*
						11/12/2012
						TENTAR ALTERAR O LANCAMENTO CONTABIL
						INVERTENDO AS CONTAS NO CT2
						**********************************************************************************************************/
						_ct2Area 	:= GetArea()
						_dData		:= DTOS(CT2->CT2_DATA)
						_cLote		:= CT2->CT2_LOTE
						_cSbLote	:= CT2->CT2_SBLOTE
						_cDoc		:= CT2->CT2_DOC
						_cItemD		:= ""
						_cContaD	:= ""
						_cCCD		:= ""
						_cItemC		:= ""
						_cContaC	:= ""
						_cCCC		:= ""
						DbSelectArea("CT2")
						DbSetOrder(1) //FILIAL+DTOS(DATA)+LOTE+SBLOTE+DOC+LINHA)
						If DbSeek(xFilial("CT2")+_dData+_cLote+_cSbLote+_cDoc)
							Do While !EOF() .and. CT2->(DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC) == _dData+_cLote+_cSbLote+_cDoc
								If !Empty(CT2->CT2_ITEMD) //CT2_DC == '1'
									_cItemD		:= CT2->CT2_ITEMD
									_cContaD	:= CT2->CT2_DEBITO
									_cCCD		:= CT2->CT2_CCD
								ElseIf !Empty(CT2->CT2_ITEMC) //CT2_DC == '2'
									_cItemC		:= CT2->CT2_ITEMC
									_cContaC	:= CT2->CT2_CREDIT
									_cCCC		:= CT2->CT2_CCC
								EndIf
								DbSelectArea("CT2")
								CT2->(DbSkip())
							EndDo
						EndIf
						If DbSeek(xFilial("CT2")+_dData+_cLote+_cSbLote+_cDoc)
							Do While !EOF() .and. CT2->(DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC) == _dData+_cLote+_cSbLote+_cDoc
								If CT2->CT2_DC == '1'
									RecLock("CT2",.F.)
									CT2->CT2_ITEMD		:= _cItemD  //_cItemC
									CT2->CT2_DEBITO		:= _cContaD //_cContaC
									CT2->CT2_CCD		:= _cCCD 	//_cCCC
									MsUnLock()
								ElseIf CT2->CT2_DC == '2'
									RecLock("CT2",.F.)
									CT2->CT2_ITEMC		:= GetMv("CI_FLIREG")//_cItemD
									CT2->CT2_CREDIT		:= POSICIONE("CT1",2,XFILIAL("CT1")+alltrim(GetMv("CI_FLIREG")),"CT1_CONTA")//_cContaD
									CT2->CT2_CCC		:= ""//_cCCD
									MsUnLock()
								EndIf
								DbSelectArea("CT2")
								CT2->(DbSkip())
							EndDo
						EndIf
						RestArea(_ct2Area)
						
						/***********************************************************************************************************/
						
						//Atualiza as naturezas, mostrando a quantidade que sobrou para baixar em cada natureza
						DBSELECTAREA("PAB")
						DBSETORDER(3)
						IF DBSEEK(xFilial("PAB")+PA9->PA9_PREFIX + PA9->PA9_NUM + PA9->PA9_FORNEC + aPags[_n1][2])
							U_GravaPAJ(1,aPags[_n1][4])
							RECLOCK("PAB",.F.)
							PAB->PAB_SALDO	:= aPags[_n1][5]
							MSUNLOCK()
						ENDIF
					Else
						If aPags[_n1][1] == .F.
							DBSELECTAREA("PAB")
							DBSETORDER(3)
							IF DBSEEK(xFilial("PAB")+PA9->PA9_PREFIX + PA9->PA9_NUM + PA9->PA9_FORNEC + aPags[_n1][2])
								U_GravaPAJ(1, aPags[_n1][3])
								RECLOCK("PAB",.F.)
								PAB->PAB_SALDO	:= aPags[_n1][3]
								MSUNLOCK()
							ENDIF
						Endif
						
					Endif
					
					If aPags[_n1][1] == .T.
						_nVlBaix	+= aPags[_n1][4]
					Endif
					
				Endif
			Endif
		Endif
		
		//Endif
	Next
	
	_nSaldo	:= (PA9->PA9_VALOR - _nVlBaix)
	
	If lMsErroAuto
		MSGINFO("Nใo foi possํvel concluir a Baixa Parcial do Tํtulo " + PA9->PA9_NUM)
		MostraErro()
	Else
		MSGINFO("Baixa Parcial do Tํtulo " + PA9->PA9_NUM + " concluํda com Sucesso !")
	Endif
	
	If lMsErroAuto == .F.
		//Atualiza Saldo na PA9, mostrando a quantidade que falta baixar
		DBSELECTAREA("PA9")
		DBSETORDER(1)
		IF DBSEEK(xFilial("PA9")+PA9->PA9_PREFIX + PA9->PA9_NUM + PA9->PA9_TIPO + PA9->PA9_FORNEC + PA9->PA9_LOJA)
			RECLOCK("PA9",.F.)
			PA9->PA9_RECONC	:= "S"
			PA9->PA9_SALDO	:= _nSaldo
			PA9->PA9_VLINCO	:= _nSaldo
			MSUNLOCK()
		Endif
	Endif
Endif

lEnd	:= .T.
oDlg:End()

RETURN(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNATRAT    บAutor  ณPATRICIA FONTANEZI  บ Data ณ  05/07/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ GATILHO DO RATEIO NO CAMPO NATUREZA                        บฑฑ
ฑฑบ          ณ 							                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

USER FUNCTION RATNAT()
Local cNat888 := SuperGetMV("CI_NAT888",.T.,"88888888",)
Local cNat999 := SuperGetMV("CI_NAT999",.T.,"99999999",)
IF SELECT("TCIEE") > 0
	M->PA9_NATURE := cNat888		//"8.88.88"
Else
	M->PA9_NATURE := cNat999		//"9.99.99"
Endif


RETURN(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBANCOCP    บAutor  ณPATRICIA FONTANEZI  บ Data ณ  05/07/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ GATILHO DO BANCO NA AGENCIA E CONTA                        บฑฑ
ฑฑบ          ณ 							                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

STATIC FUNCTION BANCOCP()

If EMPTY(_cBanco)
	MSGINFO("ษ obrigat๓rio o preenchimento dos dados Bancแrio")
	Return(.F.)
Endif

RETURN()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLEGTP     บAutor  ณPATRICIA FONTANEZI  บ Data ณ  05/07/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Legenda								                      บฑฑ
ฑฑบ          ณ 							                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


USER FUNCTION LEGTP()

_aLeg := {	{"BR_VERDE"		, "Em Aberto"  		},;
{"BR_VERMELHO"	, "Baixa Total"		},;
{"BR_AMARELO"	, "Baixa Parcial"	}}

BrwLegenda(cCadastro, "Legenda", _aLeg)


RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPA9EXCLUI บAutor  ณPATRICIA FONTANEZI  บ Data ณ  05/07/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Exclusao													  บฑฑ
ฑฑบ          ณ 							                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
USER FUNCTION PA9EXCLUI()

Local _aArea			:= GetArea()
Private	aTitulo			:= {}
Private lMsErroAuto 	:= .F.

IF PA9->PA9_RECONC == 'S' .And.	PA9_VALOR<>PA9_SALDO
	MSGINFO("Titulo Parcialmente Baixado. Cancele o Titulo !")
	Return
ElseIF PA9->PA9_RECONC == " " .AND. PA9->PA9_SALDO == 0
	MSGINFO("Titulo Baixado. Nao poderแ ser Excluํdo !")
	Return
Else
	If PA9_VALOR==PA9_SALDO .And. !MsgYesNo("Confirma a exclusใo deste Tํtulo?","ATENวยO!",)
		Return
	EndIf
	
	MsAguarde({|lEnd| EXTIT(@lEnd)}, "Aguarde...", OemToAnsi("Processando a Exclusใo do Tํtulo...Aguarde.."),.T.)
	//EXTIT()
Endif

RestArea(_aArea)

RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEXTIT     บAutor  ณPATRICIA FONTANEZI  บ Data ณ  05/07/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ MSAGUARDE DE EXCLUSAO									  บฑฑ
ฑฑบ          ณ 							                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC FUNCTION EXTIT()

Local cFLIncons := ""
Local aAreaPA9	:= PA9->(GetArea())
Local aAreaPAB	:= PAB->(GetArea())
Local aRecSE5	:= {}
Local _cChave	:= "", _nPos := 0, dDtEmis := PA9->PA9_EMISSA

dbSelectArea("SE2")
SE2->(dbSetOrder(1))
SE2->(dbSeek(PA9->(PA9_FILIAL+PA9_PREFIX+PA9_NUM+Repli(" ",TamSX3("E2_PARCELA")[1])+PA9_TIPO+PA9_FORNEC+PA9_LOJA)))

dbSelectArea("PA9")

/*
Exclusใo especifica de FLI
Ao excluir uma FLI verificar a possibilidade de voltar as FL Origem ao status ABERTO para serem reutilizadas
----------------------------------------------------------------------------------------------------------------------------------
*/
If alltrim(PA9->PA9_PREFIX) == "FLI"
	cQuery := "SELECT * "
	cQuery +=   "FROM "+RetSQLname('PAC')+" "
	cQuery +=  "WHERE D_E_L_E_T_ = '' "
	cQuery +=    "AND PAC_NUMORI = '"+ALLTRIM(PA9->PA9_NUM)+"' "
	cQuery += "ORDER BY PAC_NUMORI "
	cQuery := ChangeQuery(cQuery)
	If Select("PACTM1")>0
		PACTM1->(dbCloseArea())
	EndIf
	DbUsearea(.T., 'TOPCONN', TCGENQRY(,,cQuery),'PACTM1',.F.,.T.)
	
	DbSelectarea("PACTM1")
	DbGotop()
	_nCont	:= 0
	Do While !EOF()
		_nCont++
		MsgBox(OemToAnsi("Nao pode excluir a FLI pois a mesma esta amarrada a outra Inconsistencia nr. "+PACTM1->PAC_NUMFLI), OemToAnsi("Exclusใo FL Inconsistencia"), "ALERT")
		DbSelectarea("PACTM1")
		PACTM1->(DbSkip())
		PACTM1->(DbClosearea())
		Return(.F.)
	EndDo
	
	If _nCont == 0
		DbSelectarea("PACTM1")
		PACTM1->(DbClosearea())
	EndIf
EndIf

//TABELA SE5 - MOVIMENTO BANCARIO
cQuery	:= "SELECT R_E_C_N_O_ E5REC, * FROM "+RetSQLname('SE5')+" "
cQuery	+= "WHERE D_E_L_E_T_ = '' "
cQuery	+= "AND E5_HISTOR LIKE '%"+ALLTRIM(PA9->PA9_NUM)+"%' "
cQuery  += "AND E5_SITUACA='' "
cQuery  += "AND E5_RECONC='' "
cQuery := ChangeQuery(cQuery)
If Select("SE5TMP")>0
	SE5TMP->(dbCloseArea())
EndIf
DbUsearea(.T., 'TOPCONN', TCGENQRY(,,cQuery),'SE5TMP',.F.,.T.)

DbSelectarea("SE5TMP")
DbGotop()
_nValCanc	:= 0
_cChave		:= SE5TMP->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)
cFLIncons	:= ""

Do While SE5TMP->(!EOF())
	
	If _cChave <> SE5TMP->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)
		_nValCanc	:= 0
		_cChave := SE5TMP->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)
	EndIf
	SE2->(dbSetOrder(1))
	SE2->(dbSeek(xFilial("SE2")+_cChave))
	_nValCanc+= SE5TMP->E5_VALOR
	
	// Identifica a referencia das baixas FL CP
	cFLIncons += SE5TMP->E5_XREFFLC
	
	aRecSE5 := TrazRecSE5(_cChave)
	
	SE5->(dbGoTo(SE5TMP->E5REC))
	_nPos := Iif(Len(aRecSE5)>0,aScan(aRecSE5, SE5TMP->E5REC),0)
	
	SE5->(dbGoTo(SE5TMP->E5REC))
	RecLock("SE5",.F.)
	SE5->E5_SITUACA := "C"
	SE5->(MsUnLock())
	
	//ATUALIZA O CAMPO DE RECONCILIACAO, PARA QUE POSSA SER FEITO NOVAS BAIXAS NESSE TITULO
	DBSELECTAREA("PA9")
	DBSETORDER(1)
	IF DBSEEK(xFilial("PA9")+SE5TMP->(E5_PREFIXO + E5_NUMERO + E5_TIPO + E5_CLIFOR + E5_LOJA))
		RECLOCK("PA9",.F.)
		PA9->PA9_RECONC	:= 'S' //alteracao 02/04/13. mesmo no cancelamento registra como possivel INCONSISTENCIA
		PA9->PA9_SALDO	:= PA9->PA9_VLINCO
		MSUNLOCK()
		dDtEmis := Iif(dDtEmis>PA9->PA9_EMISSA,PA9->PA9_EMISSA,dDtEmis)
	Endif
	
	DBSELECTAREA("PAB")
	DBSETORDER(3)
	IF DBSEEK(xFilial("PAB")+PA9->(PA9_PREFIX+PA9_NUM+PA9_FORNEC))
		While PAB->(!EOF()).And.PAB->(PAB_PREFIX+PAB_NUM+PAB_CLIFOR)=PA9->(PA9_PREFIX+PA9_NUM+PA9_FORNEC)
			U_GravaPAJ(2, SE5->E5_VALOR)
			RECLOCK("PAB",.F.)
//			PAB->PAB_SALDO	:= PAB->PAB_VALOR  //alteracao 02/04/13. mesmo no cancelamento registra como possivel INCONSISTENCIA
			PAB->PAB_SALDO	+= SE5->E5_VALOR  //alteracao 02/04/13. mesmo no cancelamento registra como possivel INCONSISTENCIA
			MSUNLOCK()
			PAB->(DBSKIP())
		ENDDO
	ENDIF
	
	DbSelectarea("SE5TMP")
	SE5TMP->(DbSkip())
	
EndDo
DbSelectarea("SE5TMP")
SE5TMP->(DbClosearea())

// Cancela as baixas referenciadas da FL CP
If Len(AllTrim(cFLIncons))>0
	aFLIncons := {Left(cFLIncons,7)}
	If Len(AllTrim(cFLIncons))>7
		For _nX:=9 to Len(AllTrim(cFLIncons)) Step 8
			cX:=SubStr(cFLIncons,_nX,7)
			xn:=aScan(aFLIncons, {|x| x=cX})
			If xn=0
				aAdd(aFLIncons, cX )
				aSort(aFLIncons,,, { |x, y| x < y })
			EndIf
		Next _nX
	EndIf
	
	If Len(aFLIncons)>0
		For _nX:=1 to Len(aFLIncons)
			cX := aFLIncons[_nX]
			cQuery := "SELECT * "
			cQuery += "FROM "+RetSqlName("SE5")+" "
			cQuery += "WHERE D_E_L_E_T_='' "
			cQuery += "AND E5_DATA>='"+DtoS(dDtEmis)+"' "
			cQuery += "AND E5_XREFFLC='"+cX+"' "
			cQuery += "AND E5_HISTOR NOT LIKE '%TIT FLI%' "
			cQuery += "AND E5_RECONC='' "
			//			cQuery += "AND E5_SITUACA='' "
			cQuery := ChangeQuery(cQuery)
			If Select("SE5TMP")>0
				SE5TMP->(dbCloseArea())
			EndIf
			DbUsearea(.T., 'TOPCONN', TCGENQRY(,,cQuery),'SE5TMP',.F.,.T.)
			
			SE5TMP->(dbGoTop())
			While SE5TMP->(!Eof())
				_cChave		:= SE5TMP->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)
				SE2->(dbSetOrder(1))
				SE2->(dbSeek(xFilial("SE2")+_cChave))
				SE5->(dbGoTo(SE5TMP->R_E_C_N_O_))
				
				RecLock("SE5",.F.)
				SE5->E5_SITUACA := Iif(SE5->E5_SITUACA=="C"," ","C")
				SE5->(MsUnLock())
				
				If SE2->E2_SALDO>0
					RecLock("SE2",.F.)
					SE2->E2_SALDO:=0
					SE2->(MsUnLock())
				EndIf
				
				SE5TMP->(dbSkip())
			End
			
			SE5TMP->(dbCloseArea())
			
		Next _nX
	EndIf
	
EndIf


//EndIf
//*/
/*
----------------------------------------------------------------------------------------------------------------------------------
*/

RestArea(aAreaPAB)
RestArea(aAreaPA9)

_aTitulo := {{"E2_PREFIXO",PA9->PA9_PREFIX 		, NIL},; //FIXO
			{"E2_NUM"    , PA9->PA9_NUM			, NIL},; //Numero do Relatorio
			{"E2_PARCELA", " "					, NIL},; //FIXO
			{"E2_TIPO"   , PA9->PA9_TIPO		, NIL},; //FIXO
			{"E2_HIST"   , PA9->PA9_HIST		, NIL},; //FIXO
			{"E2_NATUREZ", PA9->PA9_NATURE		, NIL},; //FIXO
			{"E2_FORNECE", PA9->PA9_FORNEC		, NIL},;
			{"E2_LOJA"   , PA9->PA9_LOJA		, NIL},;
			{"E2_REDUZ"  , PA9->PA9_CTADEB		, NIL},;
			{"E2_RED_CRE", PA9->PA9_CTACRE		, NIL},;
			{"E2_EMISSAO", PA9->PA9_EMISSA		, NIL},;
			{"E2_VENCTO" , PA9->PA9_VENC		, NIL},;
			{"E2_VENCREA", PA9->PA9_VENCRE		, NIL},;
			{"E2_RATEIO" , PA9->PA9_RATEIO		, NIL},;
			{"E2_VALOR"  , PA9->PA9_VALOR		, NIL},;
			{"E2_CCUSTO" , PA9->PA9_CC			, NIL}}

Begin Transaction
MsExecAuto({|x,y,z| FINA050(x,y,z)},_aTitulo,,5)   	//MSEXECAUTO DE EXCLUSAO DE TITULO

If lMsErroAuto
	MSGINFO("Nใo foi possํvel concluir a Exclusใo do Tํtulo " + PA9->PA9_NUM)
	MostraErro()
	Return
Endif
End Transaction

//TABELA PAC - HISTORICO
cQuery := "SELECT R_E_C_N_O_, * "
cQuery += "FROM "+RetSQLname('PAC')+" "
cQuery += "WHERE D_E_L_E_T_ = '' "
cQuery += "AND PAC_NUMFLI = '"+ALLTRIM(PA9->PA9_NUM)+"' "
cQuery += "ORDER BY PAC_NUMORI "
cQuery := ChangeQuery(cQuery)
If Select("PACTM2")>0
	PACTM2->(dbCloseArea())
EndIf
DbUsearea(.T., 'TOPCONN', TCGENQRY(,,cQuery),'PACTM2',.F.,.T.)

DbSelectarea("PACTM2")
PACTM2->(DbGotop())
Do While PACTM2->(!EOF())
	DbSelectArea("PAC")
	PAC->(DbGoto(PACTM2->R_E_C_N_O_))
	RecLock("PAC",.F.)
	PAC->(DbDelete())
	PAC->(MsUnLock())
	DbSelectarea("PACTM2")
	PACTM2->(DbSkip())
EndDo
DbSelectarea("PACTM2")
PACTM2->(DbClosearea())

// Alterado em 06/08/2013 por Daniel G.Jr - Criar chave de busca antes de excluir PA9
_cChavePA9 := PA9->(PA9_PREFIX + PA9_NUM + PA9_FORNEC)
RECLOCK("PA9",.F.)
PA9->(DBDELETE())
PA9->(MSUNLOCK())

DBSELECTAREA("PAB")
DBSETORDER(3)
//IF DBSEEK(xFilial("PAB")+PA9->PA9_PREFIX + PA9->PA9_NUM + PA9->PA9_FORNEC)		// Alterado em 06/08/2013 por Daniel G.Jr.
IF DBSEEK(xFilial("PAB")+_cChavePA9)
	//	While PAB->(!EOF()) .AND. PA9->PA9_PREFIX + PA9->PA9_NUM + PA9->PA9_FORNEC == PAB->PAB_PREFIX + PAB->PAB_NUM + PAB->PAB_CLIFOR		// Alterado em 06/08/2013 por Daniel G.Jr.
	While PAB->(!EOF()) .AND. _cChavePA9 == PAB->PAB_PREFIX + PAB->PAB_NUM + PAB->PAB_CLIFOR
		U_GravaPAJ(2)
		RECLOCK("PAB",.F.)
		PAB->(DBDELETE())
		PAB->(MSUNLOCK())
		PAB->(DBSKIP())
	ENDDO
ENDIF

//Alterado dia 26/03/13 - Emerson Natali. Acrescentado bloco abaixo para excluir tambem a PAA
DbSelectArea("PAA")
PAA->(DbSetOrder(3))
//If Dbseek(xFilial("PAA")+ PA9->PA9_NUM + PA9->PA9_PREFIX + PA9->PA9_FORNEC + PA9->PA9_LOJA)		// Alterado em 06/08/2013 por Daniel G.Jr.
If Dbseek(xFilial("PAA")+ _cChavePA9)
	//	Do While PAA->(!EOF()) .and. PA9->(PA9_NUM+PA9_PREFIX+PA9_FORNEC+PA9_LOJA) == PAA->(PAA_TITULO+PAA_PREFIX+PAA_FORNEC+PAA_LOJA)		// Alterado em 06/08/2013 por Daniel G.Jr.
	Do While PAA->(!EOF()) .and. _cChavePA9 == PAA->(PAA_TITULO+PAA_PREFIX+PAA_FORNEC+PAA_LOJA)
		RecLock("PAA",.F.)
		DbDelete()
		MsUnLock()
		PAA->(DbSkip())
	EndDo
EndIF

//*
If lMsErroAuto == .F.
	msginfo("Tํtulo " + PA9->PA9_NUM + " excluํdo com Sucesso")
Endif

RETURN


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTrazRecSE5บAutor  ณDaniel G.Jr.TI1239  บ Data ณ Ago/2013    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Traz o recno das baixas por ordem sequencial, para permitirบฑฑ
ฑฑบ          ณ a exclusใo de uma sequencia em especํfico                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function TrazRecSE5(_cChave)

Local cQuery := ""
Local aArea  := GetArea()
Local aRet	 := {}

cQuery := "SELECT R_E_C_N_O_ RECSE5, E5_SEQ "
cQuery +=   "FROM " + RetSqlName("SE5") + " E51 "
cQuery +=  "WHERE E51.D_E_L_E_T_='' "
cQuery +=    "AND E51.E5_FILIAL = '" + xFilial("SE5") + "' "
cQuery +=    "AND E51.E5_TIPODOC = 'BA' "
cQuery +=    "AND E51.E5_PREFIXO+E51.E5_NUMERO+E51.E5_PARCELA+E51.E5_TIPO+E51.E5_CLIFOR+E51.E5_LOJA = '" + _cChave + "' "
cQuery +=    "AND E51.E5_SITUACA <> 'C' "
cQuery +=    "AND E51.E5_RECPAG = 'P' "
cQuery +=    "AND (SELECT COUNT(*) TOT "
cQuery +=           "FROM " + RetSqlName("SE5") + " E52 "
cQuery +=          "WHERE E52.D_E_L_E_T_='' "
cQuery +=            "AND E52.E5_FILIAL = '" + xFilial("SE5") + "' "
cQuery +=            "AND E52.E5_TIPODOC = 'ES' "
cQuery +=            "AND E52.E5_PREFIXO+E52.E5_NUMERO+E52.E5_PARCELA+E52.E5_TIPO+E52.E5_CLIFOR+E52.E5_LOJA = '" + _cChave + "' "
cQuery +=            "AND E52.E5_SITUACA <> 'C' "
cQuery +=            "AND E52.E5_SEQ = E51.E5_SEQ ) = 0 "
cQuery += "ORDER BY E5_SEQ "
cQuery := ChangeQuery(cQuery)
If Select("SEQ5")>0
	SEQ5->(dbCloseArea())
EndIf
DbUsearea(.T., 'TOPCONN', TCGENQRY(,,cQuery),'SEQ5',.F.,.T.)

DbSelectarea("SEQ5")
SEQ5->(DbGotop())
Do While SEQ5->(!EOF())
	aAdd(aRet, SEQ5->RECSE5)
	SEQ5->(dbSkip())
EndDo
SEQ5->(dbCloseArea())

RestArea(aArea)

Return( aRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVALINC บAutor  ณPATRICIA FONTANEZI  บ Data ณ  05/07/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Exclusao													  บฑฑ
ฑฑบ          ณ 							                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
USER FUNCTION VALINC()

Local _lRet	:= .T.

IF SELECT("TCIEE") <= 0
	If M->PA9_RATEIO == 'N' .AND. EMPTY(M->PA9_CTADEB)
		MSGINFO("Preencha a Conta D้bito")
		_lRet	:= .F.
		RETURN(_lRet)
	Endif
	
	If M->PA9_RATEIO == 'S'
		MSGINFO("Altere o Campo Rateio para Nใo")
		_lRet	:= .F.
		RETURN(_lRet)
	EndIf
	
	IF DATE() > M->PA9_VENC
		msgbox(OemToAnsi("Nใo ้ permitido digitar um titulo com vencimento anterior a Data do Servidor!!!"), "Alert")
		_lRet	:= .F.
		RETURN(_lRet)
	EndIf
	
Endif

RETURN(_lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCTADEBNAT บAutor  ณPATRICIA FONTANEZI  บ Data ณ  05/07/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ VALIDACAO DA CONTA CONTABIL DEBITO PARA A NATUREZA
ฑฑบ          ณ 							                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

USER FUNCTION CTADEBNAT()

Local _cNatureza
Local cNat888 := SuperGetMV("CI_NAT888",.T.,"88888888",)
If M->PA9_RATEIO == 'N'
	DBSELECTAREA("CT1")
	DBSETORDER(2)
	DBGOTOP()
	IF DBSEEK(xFilial("CT1")+M->PA9_CTADEB)
		If !EMPTY(CT1->CT1_NATURE)
			_cNatureza	:= cNat888			//"8.88.88" //CT1->CT1_NATURE
		Else
			_cNatureza	:= cNat888			//"8.88.88"
		ENdif
	ENDIF
ENDIF

RETURN(_cNatureza)


//***********************************
//RATEIO E NATUREZA
//**********************************
USER FUNCTION CTADCNAT()

Local cNat999 := SuperGetMV("CI_NAT999",.T.,"99999999",)
Local cNat888 := SuperGetMV("CI_NAT888",.T.,"88888888",)
Local _cNature	:= cNat999				//'9.99.99'
If M->PA9_RATEIO == 'S'
	_cNature	:= cNat888				//'8.88.88'
Endif

RETURN(_cNature)


//------------------------------------
//CENTRO DE RESPONSABILIDADE
//------------------------------------

USER FUNCTION CCRESP()

DbSelectArea("CT1")
CT1->(DbSetOrder(2))
dBGOTOP()
If DbSeek(xFilial("CT1")+M->PA9_CTACRED)
	IF CT1->CT1_CCOBRG == '1' .AND. EMPTY(M->PA9_CC)
		MSGINFO("Digite o Centro de Responsabilidade")
		Return(.F.)
	Endif
Endif


RETURN


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIINCON    บAutor  ณPATRICIA FONTANEZI  บ Data ณ  19/07/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ BOTAO INCONSISTENCIA
ฑฑบ          ณ 							                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


USER FUNCTION IINCON()

Local aArea		:= GetArea()
Private _lRet	:= .F.
Private _lRet2	:= .F.
Private _dP1	:= SPACE(8)
Private _dP2    := SPACE(8)


//DEFINE MSDIALOG oDlgA FROM  51,58 TO 200,460 TITLE "INCONSISTENCIAS" PIXEL


@ 000,000 TO 190,290 Dialog oDlgA Title "PERอODO - INCONSISTENCIAS"
@ 001,001 TO 006,017
@ 002,004 Say "  DATA  DE.: "
@ 002,009 Get _dP1 PICTURE "@D 99/99/99" size 30,8
@ 003,004 Say "  DATA  ATE.: "
@ 003,009 Get _dP2 PICTURE "@D 99/99/99" size 30,8 VALID DTBRANCO()

//DEFINE SBUTTON FROM 067, 045 TYPE 1 ENABLE OF oDlgA ACTION (BUSCAINC(),_lRet :=.T.,oDlgA:End())
//DEFINE SBUTTON FROM 067, 077 TYPE 2 ENABLE OF oDlgA ACTION (_lRet :=.F.,oDlgA:End())
@ 067, 045 BMPBUTTON TYPE 1 ACTION(BUSCAINC(),_lRet :=.T.,oDlgA:End())
@ 067, 077 BMPBUTTON TYPE 2 ACTION(_lRet :=.F.,oDlgA:End())

ACTIVATE MSDIALOG oDlgA CENTERED

IF SELECT("TRB") > 0
	TRB->(DBCLOSEAREA())
Endif

RestArea(aArea)

RETURN(_lRet)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBUSCAINC  บAutor  ณPATRICIA FONTANEZI  บ Data ณ  19/07/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ BUSCA INCONSISTENCIA ATRAVES DOS PARAMETROS PREENCHIDOS
ฑฑบ          ณ 							                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

STATIC FUNCTION BUSCAINC()

Local _cQR 		:= ""
Local _dP11
Local _dP22
Private aPAB	:= {}
Private oOk    	:= LoadBitmap( GetResources(), "LBOK" )
Private oNo     := LoadBitmap( GetResources(), "LBNO" )

_dP11	:= "20"+substr(_dP1,7,2)+substr(_dP1,4,2)+substr(_dP1,1,2)
_dP22	:= "20"+substr(_dP2,7,2)+substr(_dP2,4,2)+substr(_dP2,1,2)

//QUERY BUSCA OS TITULOS PARCIALMENTE BAIXADOS
_cQR := " SELECT PA9_PREFIX,PA9_TIPO,PA9_FORNEC,PA9_LOJA, PA9_NUM, PA9_SALDO, PA9_VALOR "
_cQr += " FROM "+ RetSqlName("PA9")
_cQr += " WHERE PA9_EMISSA >= '"+_dP11+"' AND PA9_EMISSA <= '"+_dP22+"' AND "
_cQr += " PA9_SALDO <> 0 AND PA9_RECONC = 'S' AND "
_cQr += " D_E_L_E_T_ <> '*' "
_cQr += " ORDER BY PA9_EMISSA, PA9_NUM "

IF SELECT("TRB") > 0
	TRB->(DBCLOSEAREA())
Endif


//DEVE-SE BUSCAR OS REGISTROS QUE O E5_RECONC ESTEJA = ''

_cQr:= ChangeQuery(_cQr)
DbUsearea(.T., 'TOPCONN', TCGENQRY(,,_cQr),'TRB',.F.,.T.)

DBSELECTAREA("TRB")
DBGOTOP()
While !EOF("TRB")
	AADD(aPAB,{.F.,TRB->PA9_NUM, TRB->PA9_PREFIX, TRB->PA9_FORNEC, TRB->PA9_SALDO, TRB->PA9_VALOR})
	TRB->(DbSkip())
Enddo

// MONTA A TELA COM FLAG, COM OS TITULOS BAIXADOS PARCIALMENTE - SOMENTE VISUAL
If Len(aPAB) == 0
	MSGINFO("Nใo hแ dados nesse Perํodo")
	Return()
Else
	
	DEFINE MSDIALOG oDlg FROM  51,58 TO 360,495 TITLE "INCONSISTสNCIA" PIXEL
	@ 30,05 LISTBOX oLbx1 FIELDS HEADER "","Tํtulo","Valor Titulo","Saldo" SIZE 210, 100 OF oDlg PIXEL ;
	ON DBLCLICK (u_MARKD1())
	
	@ 005, 025 SAY oSay4 PROMPT "Perํodo de.:" SIZE 030, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 005, 065 MSGET oGet2 VAR _dP1 WHEN .F. SIZE 005, 010 OF oDlg COLORS 0, 16777215 PIXEL VALID BANCOCP()
	
	@ 005, 100 SAY oSay4 PROMPT "Ate.: " SIZE 030, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 005, 120 MSGET oGet1 VAR _dP2 When .F.  SIZE 007, 010 OF oDlg COLORS 0, 16777215 PIXEL
	
	
	oLbx1:SetArray(aPAB)
	oLbx1:bLine := { || {If(aPAB[oLbx1:nAt,1],oOk,oNo),aPAB[oLbx1:nAt,2],Transform(aPAB[oLbx1:nAt,6],"@EZ 999,999,999.99"),Transform(aPAB[oLbx1:nAt,5],"@EZ 999,999,999.99")}}//,Transform(aPags[oLbx1:nAt,4],"@EZ 999,999,999.99")}}
	oLbx1:nFreeze  := 1
	
	DEFINE SBUTTON FROM 140, 158 TYPE 1 ENABLE OF oDlg ACTION (PABOK(),_lRet2,oDlg:End())
	DEFINE SBUTTON FROM 140, 188 TYPE 2 ENABLE OF oDlg ACTION (_lRet2 :=.F.,oDlg:End())
	
	ACTIVATE MSDIALOG oDlg CENTERED
Endif

RETURN


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAFIN050TP บAutor  ณPATRICIA FONTANEZI  บ Data ณ  05/07/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ Funcao Verifica se esta ticado ou nao o checkBox           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User FUNCTION MARKD1()

_lFlag := aPAB[oLbx1:nAt,1]

If _lFlag
	aPAB[oLbx1:nAt,1] := .F.
Else
	aPAB[oLbx1:nAt,1] := .T.
EndIf

oLbx1:Refresh(.T.)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPABOK     บAutor  ณPATRICIA FONTANEZI  บ Data ณ  19/07/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ BOTAO OK DA TELA DE ESCOLHA DE TITULOS INCONSISTENTES
ฑฑบ          ณ 							                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

STATIC FUNCTION PABOK()

Local N				:= 0
Local _nQtTiques	:= 0
Local _cDescNat
Private aNVtt		:= {}

//Adiciona em um novo array, os ticados para que seja gerada uma nova tela com esses registros
For N := 1 to LEN(aPAB)
	If aPAB[N][1] == .T.
		_nQtTiques++
		DbSelectArea("PAB")
		DbSetOrder(3)
		DbGotop()
		If DbSeek(xFilial("PAB")+aPAB[N][3] + aPAB[N][2] + aPAB[N][4])
			While PAB->(!EOF()) .AND. PAB->(PAB_PREFIX + PAB_NUM + PAB_CLIFOR) == aPAB[N][3] + aPAB[N][2] + aPAB[N][4]
				If PAB->PAB_SALDO > 0
					_cDescNat:=""
					DbSelectArea("SA2")
					DbSetOrder(1)
					DbGotop()
					If DbSeek(xFilial("SA2")+ ALLTRIM(aPAB[N][4]))
						_cNomFor	:= SA2->A2_NREDUZ
					Endif
					
					DbSelectArea("SED") 
					DbSetOrder(1)
					If DbSeek(xFilial("SED")+ PAB->PAB_NATURE)
						_cDescNat	:= SED->ED_DESCRIC        
					Else
						DbSelectarea("SED")
						SED->(DbOrderNickName("SUPORC"))
						If SED->(DbSeek(xFilial("SED")+PAB->PAB_NATURE))
							_cDescNat	:= SED->ED_DESCRIC        
						Endif                
					EndIf
					//ARRAY PARA CRIACAO DAS NATUREZAS NO NOVO TITULO
					//aadd(aNVtt,{aPAB[N][2],_cNomFor,PAB->PAB_NATURE, aPAB[N][5],aPAB[N][5]})
					aadd(aNVtt,{aPAB[N][2],_cNomFor,PAB->PAB_NATURE, PAB->PAB_SALDO,PAB->PAB_SALDO,_cDescNat})
				EndIf
				PAB->(DBSKIP())
			Enddo
		Endif
	Endif
Next

If _nQtTiques == 0
	MSGINFO("Nใo hแ sele็ใo de Tํtulos. Selecione um Tํtulo.")
	Return()
Else
	//NOVOTIT()
	u_xTELAFL(aNVtt)
Endif



RETURN


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDTBRANCO  บAutor  ณPATRICIA FONTANEZI  บ Data ณ  19/07/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ VALIDACAO NO CAMPO DATA 2
ฑฑบ          ณ 							                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


STATIC FUNCTION DTBRANCO()

IF EMPTY(_dP2)
	MSGINFO("Obrigat๓rio o Preenchimento do P้riodo 2 ")
	Return(.F.)
Endif

RETURN


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVOTIT  บAutor  ณPATRICIA FONTANEZI  บ Data ณ  19/07/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ TELA DE GET DADOS PARA INCLUSAO DE UM NOVO TITULO, CASO ESTEJA
ฑฑบ          ณ TICADO NA TELA DE INCONSISTENCIA					         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

STATIC FUNCTION NOVOTIT()

RETURN

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAFIN050TP บAutor  ณEmerson Natali      บ Data ณ  18/09/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina de Elimina Residuo                                  บฑฑ
ฑฑบ          ณ Cancela o Saldo do PA9/PAB geranco SE5 com motivo RES      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ELIMRES()

Local _nValRes	:= 0
Local _nCont	:= 0
Local _cFL
Local _cMotvo	:= SPACE(40)
Local _lRet 	:=.T.


If !MsgYesNo(OemToAnsi("Tem certeza que deseja Eliminar Pend๊ncias"+CHR(13) + CHR(10)+"Deseja continuar?"), OemToAnsi("Eliminar Pend๊ncias"))
	_lRet 	:=.F.
	Return(_lRet)
EndIf

DbSelectArea("PAB")
DbSetorder(1)
If DbSeek(xFilial("PAB")+PA9->(PA9_PREFIX+PA9_NUM+" "+PA9_TIPO+PA9_FORNEC+PA9_LOJA))
	
	Do While PAB->(!EOF()) .and. PA9->(PA9_PREFIX+PA9_NUM+" "+PA9_TIPO+PA9_FORNEC+PA9_LOJA) == PAB->(PAB_PREFIX+PAB_NUM+" "+PAB_TIPO+PAB_CLIFOR+PAB_LOJA)
		
		If PAB->PAB_SALDO == 0
			DbSelectArea("PAB")
			PAB->(DbSkip())
			Loop
		EndIf
		
		DbSelectArea("SE5")
		DbSetOrder(7)
		DbGotop()
		If DbSeek(xFilial("SE5")+PAB->(PAB_PREFIX+PAB_NUM+" "+PAB_TIPO+PAB_CLIFOR+PAB_LOJA))
			Do While SE5->(!EOF()) .AND. SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA) == PAB->(PAB_PREFIX+PAB_NUM+" "+PAB_TIPO+PAB_CLIFOR+PAB_LOJA)
				If SE5->E5_SITUACA <> 'C' .AND. SE5->E5_RECONC <> 'x' .AND. SE5->E5_VALOR == PAB->PAB_SALDO .AND. SE5->E5_MOTBX == "NOR"
					
					_cBancoSE5	:= SE5->E5_BANCO
					_cAgSE5		:= SE5->E5_AGENCIA
					_cContSE5	:= SE5->E5_CONTA
					
					
					RecLock("SE5",.F.)
					SE5->E5_SITUACA := "C"
					MsUnLock()
					
					DbSelectArea("SE2")
					DbSetOrder(1)
					If DbSeek(xFilial("SE2")+SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA))
						RecLock("SE2",.F.)
						SE2->E2_SALDO	:= PAB->PAB_SALDO
						SE2->E2_VALLIQ	:= 0
						MsUnlock()
					EndIf
				Else
					DbSelectArea("SE5")
					SE5->(DbSkip())
					Loop
				EndIf
				
				_nCont++
				If _nCont == 1
					@ 000,000 TO 190,290 Dialog oDlg01 Title "Motivo de exclusใo"
					@ 001,001 TO 006,017
					@ 002,007 Say " MOTIVO.: "
					@ 003,002 Get _cMotvo size 110,8
					@ 067,062 BMPBUTTON TYPE 1 Action (FunClose(_lClose :=.T.,_lRet,))
					Activate Dialog oDlg01 CENTERED
					
					If Empty(alltrim(_cMotvo))
						_cMotvo := "ELIMINADO POR "+alltrim(cUserName)
					EndIf
					
				Endif
				aVetor :={{"E2_PREFIXO"	,PAB->PAB_PREFIX,Nil},;
						{"E2_NUM"	 	,PAB->PAB_NUM	,Nil},;
						{"E2_PARCELA"	," "			,Nil},;
						{"E2_TIPO"		,PAB->PAB_TIPO	,Nil},;
						{"E2_FORNECE"	,PAB->PAB_CLIFOR,Nil},;
						{"E2_LOJA"  	,PAB->PAB_LOJA	,Nil},;
						{"AUTMOTBX" 	,"ELI"			,Nil},;		//MOTIVO BAIXA
						{"AUTBANCO"		,_cBancoSE5		,Nil},;     //BANCO
						{"AUTAGENCIA"	,_cAgSE5		,Nil},;     //AGENCIA
						{"AUTCONTA" 	,_cContSE5		,Nil},;     //CONTA
						{"AUTDTBAIXA"	,dDatabase		,Nil},;     //DATA BAIXA
						{"AUTDTDEB"		,dDatabase		,Nil},;     //DATA DO DEBITO
						{"AUTHIST"		,_cMotvo		,Nil},;     //HISTORICO
						{"AUTVLRPG"		,PAB->PAB_SALDO ,Nil}}
				
				MSExecAuto({|x,y| Fina080(x,y)},aVetor,3)
				
				/*
				11/12/2012
				TENTAR ALTERAR A CONTA E O HISTORICO
				E MUDAR O TIPO DE 'RES' PARA 'ELI'
				**********************************************************************************************************/
				_ct2Area 	:= GetArea()
				_dData		:= DTOS(CT2->CT2_DATA)
				_cLote		:= CT2->CT2_LOTE
				_cSbLote	:= CT2->CT2_SBLOTE
				_cDoc		:= CT2->CT2_DOC
				_cItemD		:= ""
				_cContaD	:= ""
				_cCCD		:= ""
				_cItemC		:= ""
				_cContaC	:= ""
				_cCCC		:= ""
				DbSelectArea("CT2")
				DbSetOrder(1) //FILIAL+DTOS(DATA)+LOTE+SBLOTE+DOC+LINHA)
				If DbSeek(xFilial("CT2")+_dData+_cLote+_cSbLote+_cDoc)
					Do While !EOF() .and. CT2->(DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC) == _dData+_cLote+_cSbLote+_cDoc
						If !Empty(CT2->CT2_ITEMD) //CT2_DC == '1'
							_cItemD		:= CT2->CT2_ITEMD
							_cContaD	:= CT2->CT2_DEBITO
							_cCCD		:= CT2->CT2_CCD
						ElseIf !Empty(CT2->CT2_ITEMC) //CT2_DC == '2'
							_cItemC		:= CT2->CT2_ITEMC
							_cContaC	:= CT2->CT2_CREDIT
							_cCCC		:= CT2->CT2_CCC
						EndIf
						DbSelectArea("CT2")
						CT2->(DbSkip())
					EndDo
				EndIf
				If DbSeek(xFilial("CT2")+_dData+_cLote+_cSbLote+_cDoc)
					Do While !EOF() .and. CT2->(DTOS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC) == _dData+_cLote+_cSbLote+_cDoc
						If CT2->CT2_DC == '1'
							RecLock("CT2",.F.)
							//							CT2->CT2_ITEMD		:= _cItemC
							//							CT2->CT2_DEBITO		:= _cContaC
							//							CT2->CT2_CCD		:= _cCCC
							CT2->CT2_HIST		:= "RES FL"+PAB->PAB_NUM
							MsUnLock()
						ElseIf CT2->CT2_DC == '2'
							RecLock("CT2",.F.)
							//							CT2->CT2_ITEMC		:= _cItemD
							//							CT2->CT2_CREDIT		:= _cContaD
							//							CT2->CT2_CCC		:= _cCCD
							CT2->CT2_HIST		:= "RES FL"+PAB->PAB_NUM
							MsUnLock()
						EndIf
						DbSelectArea("CT2")
						CT2->(DbSkip())
					EndDo
				EndIf
				RestArea(_ct2Area)
				/***********************************************************************************************************/
				
				DbSelectArea("SE5")
				SE5->(DbSkip())
			EndDo
		EndIf
		
		If _nCont > 0
			_nValRes += PAB->PAB_SALDO
			If _nCont > 0
				U_GravaPAJ(1, PAB->PAB_SALDO)
				RecLock("PAB",.F.)
				PAB->PAB_SALDO	:= 0
				MsUnLock()
			EndIf
		EndIf
		
		DbSelectArea("PAB")
		PAB->(DbSkip())
	EndDo
	
	If _nCont > 0
		RecLock("PA9",.F.)
		PA9->PA9_SALDO 	:= 0
		PA9->PA9_VLRESI	:= _nValRes
		MsUnLock()
	EndIf
	
EndIf

If _nCont > 0
	MSGINFO("Elimina็ใo de pendencias realizada com Sucesso !!")
Else
	MSGINFO("Nao ้ possivel eliminar pendecias de um titulo sem pagamentos")
Endif

Return(_lRet)

User Function GravaPAJ(_nTipo, _nValor)

Local _cSeqPAJ := "" , cQuery := "", _cFilial := xFilial("PAJ")
Default _nTipo := 1
Default _nValor:= 0

dbSelectArea("PAJ")
PAJ->(dbSetOrder(1))
If _nTipo==1    		// Inclui registro de movimento do PAB
	
	cQuery := "SELECT MAX(PAJ_SEQ) NLAST "
	cQuery += "FROM "+RetSqlName("PAJ")+" PAJ "
	cQuery += "WHERE D_E_L_E_T_='' "
	cQuery += "AND PAJ_FILIAL='"+_cFilial+"' "
	cQuery += "AND PAJ_PREFIX='"+PAB->PAB_PREFIX+"' "
	cQuery += "AND PAJ_NUM='"+PAB->PAB_NUM+"' "
	cQuery += "AND PAJ_NATURE='"+PAB->PAB_NATURE+"' "
	cQuery := ChangeQuery(cQuery)
	If Select("TPAJ")>0
		TPAJ->(dbCloseArea())
	EndIf
	DbUsearea(.T., 'TOPCONN', TCGENQRY(,,cQuery),'TPAJ',.F.,.T.)
	
	DbSelectarea("TPAJ")
	TPAJ->(DbGotop())
	_cSeqPAJ := Soma1(TPAJ->NLAST)
	TPAJ->(dbCloseArea())
	
	RecLock("PAJ",.T.)
	PAJ->PAJ_FILIAL	:= _cFilial
	PAJ->PAJ_PREFIX	:= PAB->PAB_PREFIX
	PAJ->PAJ_NUM	:= PAB->PAB_NUM
	PAJ->PAJ_NATURE	:= PAB->PAB_NATURE
	PAJ->PAJ_DATA	:= Date()
	PAJ->PAJ_VALOR	:= _nValor
	PAJ->PAJ_SEQ	:= _cSeqPAJ
	PAJ->(MsUnLock())
	
ElseIf _nTipo==2		// Exclui registro de movimento do PAB
	If PAJ->(dbSeek(_cFilial+PAB->(PAB_PREFIX+PAB_NUM+PAB_NATURE)))
		While PAJ->(PAJ_FILIAL+PAJ_PREFIX+PAJ_NUM+PAJ_NATURE) == PAB->(_cFilial+PAB_PREFIX+PAB_NUM+PAB_NATURE)
			If _nValor=0 .Or. (_nValor!=0 .And. PAJ_VALOR=_nValor)
				RecLock("PAJ",.F.)
				PAJ->(dbDelete())
				PAJ->(MsUnLock())
			EndIf
			PAJ->(dbSkip())
		End
	EndIf
EndIf

Return
