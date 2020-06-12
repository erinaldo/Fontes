#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "SHELL.CH"
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
���Funcao    �FIFINA03		 �Autor  �L�gia Sarnauskas	  � Data � 23/12/13    ���
������������������������������������������������������������������������������͹��
���Desc.     �Browse Registro/Libera��o de Sol.Reembolso      				   ���
������������������������������������������������������������������������������͹��
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
*/

User Function FIFINA03()

Local clFilter		:= ""
Local alCores		:= {{"Empty(ZM_LIBER)" ,"BR_VERDE" },{"ZM_LIBER=='E'" ,"BR_AMARELO" },{"ZM_LIBER=='S'" ,"BR_AZUL" },{"ZM_LIBER=='X'" ,"BR_VERMELHO" },{"ZM_LIBER=='R'" ,"BR_PRETO" }}
Local aFixo			:= {}
Private lpCtrl		:= .T.
Private cCadastro 	:= ""
Private aRotina 	:= {{"Pesquisar","PesqBrw"			,0,1},;
{"Legenda"               , "U_fileg03"	           		,0,6},;
{"Incluir"               , "U_fiInc03"  	            ,0,3},;
{"Alterar"               , "U_fialt03"                  ,0,4},;
{"Enviar para aprova��o" , "U_fiEAp03"                  ,0,3},;
{"Aprova��o"             , "U_fiapr03"                  ,0,3},;
{"Imprimir Solicita��o"  , "U_fiImp03"                  ,0,3},;
{"Baixar Solicita��o"    , "U_fibax03"                  ,0,3},;
{"Excluir"               , "U_fiexc03"		            ,0,6}}

clFilter := ""

AADD(aFixo,{AvSx3("ZM_NUMERO",5),"ZM_NUMERO"} )
AADD(aFixo,{AvSx3("ZM_REGISTR",5),"ZM_REGISTR"} )
AADD(aFixo,{AvSx3("ZM_FORNECE",5),"ZM_FORNECE"} )
AADD(aFixo,{AvSx3("ZM_LOJA",5),"ZM_LOJA"} )
AADD(aFixo,{AvSx3("ZM_NOMEFOR",5),"ZM_NOMEFOR"} )
AADD(aFixo,{AvSx3("ZM_SOLICIT",5),"ZM_SOLICIT"} )
AADD(aFixo,{AvSx3("ZM_USUREEM",5),"ZM_USUREEM"} )
AADD(aFixo,{AvSx3("ZM_VALOR",5),"ZM_VALOR"} )


DbSelectArea("SZM")
SZM->(DbSetOrder(1))
mBrowse(,,,,"SZM",aFixo,,,,,alCores,,,,,,,,clFilter)

Return


/*
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
���Funcao    �fiInc03		 �Autor  �L�gia Sarnauskas	  � Data � 23/12/13    ���
������������������������������������������������������������������������������͹��
���Desc.     �Inclusao de Solicita��o de Reeembolso  						   ���
������������������������������������������������������������������������������͹��
���Uso       �			                                                       ���
������������������������������������������������������������������������������͹��
���Parametros�																   ���
������������������������������������������������������������������������������͹��
���Retorno   �															       ���
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
*/
User Function fiInc03()

cagencia   := Space(5)
cbanco     := Space(3)
cccusto    := Space(09)
cconta     := Space(10)
cdatareg   := SUBSTR(dtos(DDATABASE),7,2)+"/"+SUBSTR(dtos(DDATABASE),5,2)+"/"+SUBSTR(dtos(DDATABASE),1,4)
cdescit    := Space(30)
cdescusto  := Space(30)
cdigito    := Space(1)
cfornece   := SPACE(09)
citemctb   := Space(09)
cloja      := SPACE(04)
cnomefor   := SPACE(40)
cnomprod   := Space(30)
cobserv    := " "
cprod      := Space(15)
csolicita  := Space(30)
cusuario   := Space(30)
nvlrSol    := 0
cnomefor   := SPACE(40)
_ddataDes  := stod(space(08))

If Select("TMP") > 0     // Verificando se o alias esta em uso
	dbSelectArea("TMP")
	dbCloseArea()
EndIf
_cQry := "SELECT MAX(ZM_NUMERO) MAXNUM "
_cQry += "FROM "+RetSqlName("SZM")+" SZM "
_cQry += "WHERE SZM.D_E_L_E_T_ = ''  "
_cQry += "AND SZM.ZM_FILIAL= '"+xFilial("SZM")+"' "
TCQUERY _cQry NEW ALIAS "TMP"
Dbselectarea("TMP")
Dbgotop()

If !EOF()
	cNumero    := STRZERO(VAL(TMP->MAXNUM)+1,6)
Else
	cNumero    := "000001"
Endif

IncNvReem()

Return
/*������������������������������������������������������������������������ٱ�
�� Declara��o de cVariable dos componentes                                 ��
ٱ�������������������������������������������������������������������������*/

Static Function IncNvReem()

_cClas   := ""
_aClassif:={}
AADD(_aClassif,"1-NF")
AADD(_aClassif,"2-CUPOM FISCAL")
AADD(_aClassif,"3-RECIBO")

If Select("TMP") > 0     // Verificando se o alias esta em uso
	dbSelectArea("TMP")
	dbCloseArea()
EndIf
_cQry := "SELECT MAX(ZM_SEQUEN) SEQUEN "
_cQry += "FROM "+RetSqlName("SZM")+" SZM "
_cQry += "WHERE SZM.D_E_L_E_T_ = ''  "
_cQry += "AND SZM.ZM_FILIAL = '"+xFilial("SZM")+"' "
_cQry += "AND SZM.ZM_NUMERO = '"+cNumero+"' "
TCQUERY _cQry NEW ALIAS "TMP"
Dbselectarea("TMP")
Dbgotop()

If !EOF()
	_cSeq    := STRZERO(VAL(TMP->SEQUEN)+1,3)
Else
	_cSeq    := "001"
Endif


PswOrder(2)
If 	PswSeek(ALLTRIM(__CUSERID),.T.)
	
	// Obtenho o resultado conforme vetor
	_aRetUser := PswRet(1)
	
	csolicita  := upper(alltrim(_aRetUser[1,4]))
	
EndIf

/*������������������������������������������������������������������������ٱ�
�� Definicao do Dialog e todos os seus componentes.                        ��
ٱ�������������������������������������������������������������������������*/
Define MsDialog oDlg Title "Solicita��o de Reembolso" From 084, 230 To 622, 726 Pixel
@ 06,008 TO 35,242 LABEL "Dados Solicita��o" OF oDlg PIXEL
@ 016,020 SAY "Numero: "   SIZE 35,8 PIXEL OF oDlg
@ 015,043 MSGET cNumero  when .f. SIZE 26,10 PIXEL OF oDlg
@ 015,073 MSGET _cSeq when .f. SIZE 06,10 PIXEL OF oDlg
@ 016,100 SAY "Dt.Registro: "   SIZE 35,8 PIXEL OF oDlg
@ 015,130 MSGET cdatareg picture "99/99/9999" when .f. SIZE 35,10 PIXEL OF oDlg
@ 016,170 SAY "Solicit: "   SIZE 35,8 PIXEL OF oDlg
@ 015,187 MSGET csolicita when .f. SIZE 50,10 PIXEL OF oDlg
@ 040,008 TO 110,242 LABEL "Dados Reembolso" OF oDlg PIXEL
@ 050,020 SAY "Usu�rio Reembolsado:"   SIZE 75,8 PIXEL OF oDlg
@ 049,080 MSGET cusuario f3 "US3" when .T. SIZE 60,10 PIXEL OF oDlg
@ 050,150 SAY "Dt.Despesa:"   SIZE 35,8 PIXEL OF oDlg
@ 049,185 MSGET _ddataDes VALID ValDtdesp() picture "99/99/9999" when .t. SIZE 45,10 PIXEL OF oDlg
@ 065,020 SAY "Fornecedor:"  SIZE 35,8 PIXEL OF oDlg
@ 064,055 MSGET cfornece f3 "SA2A" Valid ValFornece() when .T. SIZE 40,10 PIXEL OF oDlg
@ 064,100 MSGET cloja when .F. SIZE 10,10 PIXEL OF oDlg
@ 064,125 MSGET cnomefor when .T. SIZE 105,10 PIXEL OF oDlg
@ 080,020 SAY "Banco:"  SIZE 35,8 PIXEL OF oDlg
@ 079,045 MSGET cbanco when .T. SIZE 10,10 PIXEL OF oDlg
@ 080,072 SAY "Agencia:"  SIZE 35,8 PIXEL OF oDlg
@ 079,097 MSGET cagencia when .T. SIZE 10,10 PIXEL OF oDlg
@ 080,130 SAY "Conta:"  SIZE 35,8 PIXEL OF oDlg
@ 079,150 MSGET cconta when .T. SIZE 40,10 PIXEL OF oDlg
@ 080,195 SAY "Digito:"  SIZE 35,8 PIXEL OF oDlg
@ 079,215 MSGET cdigito when .T. SIZE 5,10 PIXEL OF oDlg
@ 095,020 SAY "Valor:"  SIZE 35,8 PIXEL OF oDlg
@ 094,045 MSGET nvlrSol Picture '@E 999,999,999.99' when .T. SIZE 60,10 PIXEL OF oDlg
@ 095,130 SAY "Classifica��o:"  SIZE 35,8 PIXEL OF oDlg
@ 094,183 ComboBox _cClas Items _aClassif Size 46,21
@ 114,020 SAY "Produto:"  SIZE 35,8 PIXEL OF oDlg
@ 113,045 MSGET cprod F3 "SB1" VALID ValProd() when .T. SIZE 45,10 PIXEL OF oDlg
@ 113,092 MSGET cnomprod when .F. SIZE 136,10 PIXEL OF oDlg
@ 129,020 SAY "Item Ctb:"  SIZE 35,8 PIXEL OF oDlg
@ 128,045 MSGET citemctb F3 "CTD" VALID ValItCtb() when .T. SIZE 45,10 PIXEL OF oDlg
@ 128,092 MSGET cdescit when .F. SIZE 136,10 PIXEL OF oDlg
@ 144,020 SAY "C.Custo:"  SIZE 35,8 PIXEL OF oDlg
@ 143,045 MSGET cccusto F3 "CTT" VALID ValCCusto() when .T. SIZE 45,10 PIXEL OF oDlg
@ 143,092 MSGET cdescusto when .F. SIZE 136,10 PIXEL OF oDlg
@ 165,008 SAY "Observa��es:"  SIZE 35,8 PIXEL OF oDlg
@ 175,008 Get cobserv Size 234, 050 Memo Object oMemo
@ 230,155 BUTTON "_Registrar" 	SIZE 40,15 ACTION FIEGRVREEB()
@ 230,202 BUTTON "_Cancelar" 	SIZE 40,15 ACTION close(oDlg)
Activate MsDialog oDlg Center

Return

Static Function ValDtdesp()
If _ddataDes> CTOD(cdatareg)
	alert("N�o � poss�vel registrar reembolsos de despesas futuras!")
	_ddataDes:=space(08)
Endif

Return()

Static Function ValFornece()

Dbselectarea("SA2")
Dbsetorder(1)
If Dbseek(Xfilial("SA2")+cfornece+cloja)
	cnomefor:=SA2->A2_NOME
	oDlg:Refresh()
Endif

Return()

Static Function ValProd()

Dbselectarea("SB1")
Dbsetorder(1)
If Dbseek(Xfilial("SB1")+cprod)
	If SB1->B1_MSBLQL <> "1"
		cnomprod:=SB1->B1_DESC
		oDlg:Refresh()
	Else
		alert("Esse cadastro est� bloqueado indique outro produto.")
		cprod:=SPACE(15)
		oDlg:Refresh()
	Endif
Endif

Return()

Static Function ValItCtb()

Dbselectarea("CTD")
Dbsetorder(1)
If Dbseek(Xfilial("CTD")+citemctb)
	If CTD->CTD_CLASSE == "1"
		alert("O item cont�bil selecionado � sint�tico, para fazer o reembolso � necess�rio indicar um item cont�bil anal�tico.")
		citemctb:=""
		oDlg:Refresh()
	Else
		cdescit:=CTD->CTD_DESC01
		oDlg:Refresh()
	Endif
Endif

Return()

Static Function ValCCusto()

Dbselectarea("CTT")
Dbsetorder(1)
If Dbseek(Xfilial("CTT")+cccusto)
	If CTT->CTT_CLASSE == "1"
		alert("O centro de custo selecionado � sint�tico, para fazer o reembolso � necess�rio indicar um centro de custo anal�tico.")
		cccusto:=""
		oDlg:Refresh()
	Else
		cdescusto:=CTT->CTT_DESC01
		oDlg:Refresh()
	Endif
Endif

Return()


Static Function FIEGRVREEB()

Dbselectarea("SZM")
RecLock("SZM",.T.)
SZM->ZM_FILIAL :=xFilial("SZM")
SZM->ZM_NUMERO :=cNumero
SZM->ZM_SEQUEN :=_cSeq
SZM->ZM_REGISTR:=CTOD(cdatareg)
SZM->ZM_FORNECE:=cfornece
SZM->ZM_LOJA   :=cloja
SZM->ZM_NOMEFOR:=cnomefor
SZM->ZM_SOLICIT:=csolicita
SZM->ZM_USUREEM:=cusuario
SZM->ZM_BANCO  :=cbanco
SZM->ZM_AGENCIA:=cagencia
SZM->ZM_CONTA  :=cconta
SZM->ZM_DIGITO :=cdigito
SZM->ZM_VALOR  :=nvlrSol
SZM->ZM_PRODUTO:=cprod
SZM->ZM_DESCPRO:=cnomprod
SZM->ZM_ITEMCTB:=citemctb
SZM->ZM_CCUSTO :=cccusto
SZM->ZM_CLASSIF:=substr(_cClas,1,1)
SZM->ZM_OBSERV :=cobserv
SZM->ZM_DTDESP :=_ddataDes
MsUnlock()

ALERT("Solicita��o Inclu�da com sucesso!")
oDlg:End()

If MsgYesNo("Inclui nova despesa nessa solicita��o de reembolso?")
	cdescit    := Space(30)
	cdescusto  := Space(30)
	citemctb   := Space(09)
	cnomprod   := Space(30)
	cobserv    := " "
	cprod      := Space(15)
	nvlrSol    := 0
	IncNvReem()
Endif

Return()


User Function fialt03()

_cClas   := ""
_aClassif:={}

Dbselectarea("SZM")
Dbsetorder(1)
If Dbseek(xFilial("SZM")+SZM->ZM_NUMERO+SZM->ZM_SEQUEN)
	If EMPTY(SZM->ZM_LIBER)
		
		cNumero   := SZM->ZM_NUMERO
		cdatareg  := SUBSTR(DTOS(SZM->ZM_REGISTR),7,2)+"/"+SUBSTR(DTOS(SZM->ZM_REGISTR),5,2)+"/"+SUBSTR(DTOS(SZM->ZM_REGISTR),1,4)
		_ddataDes := SZM->ZM_DTDESP
		cfornece  := SZM->ZM_FORNECE
		cloja     := SZM->ZM_LOJA
		cnomefor  := SZM->ZM_NOMEFOR
		csolicita := SZM->ZM_SOLICIT
		cusuario  := SZM->ZM_USUREEM
		cbanco    := SZM->ZM_BANCO
		cagencia  := SZM->ZM_AGENCIA
		cconta    := SZM->ZM_CONTA
		cdigito   := SZM->ZM_DIGITO
		nvlrSol   := SZM->ZM_VALOR
		cprod     := SZM->ZM_PRODUTO
		cnomprod  := SZM->ZM_DESCPRO
		citemctb  := SZM->ZM_ITEMCTB
		cccusto   := SZM->ZM_CCUSTO
		cobserv   := SZM->ZM_OBSERV
		cdescit   := Posicione( "CTD", 1, xFilial( "CTD" ) + citemctb, "CTD_DESC01" )
		cdescusto := Posicione( "CTT", 1, xFilial( "CTT" ) + cccusto,  "CTT_DESC01" )
		_cSeq     := SZM->ZM_SEQUEN
		_cClas    := SZM->ZM_CLASSIF
		
		
		IF SUBSTR(_cClas,1,1)=="1"
			AADD(_aClassif,"1-NF")
			AADD(_aClassif,"2-CUPOM FISCAL")
			AADD(_aClassif,"3-RECIBO")
		ELSEIF SUBSTR(_cClas,1,1)=="2"
			AADD(_aClassif,"2-CUPOM FISCAL")
			AADD(_aClassif,"1-NF")
			AADD(_aClassif,"3-RECIBO")
		ELSEIF SUBSTR(_cClas,1,1)=="2"
			AADD(_aClassif,"3-RECIBO")
			AADD(_aClassif,"1-NF")
			AADD(_aClassif,"2-CUPOM FISCAL")
		eLSE
			AADD(_aClassif,"1-NF")
			AADD(_aClassif,"2-CUPOM FISCAL")
			AADD(_aClassif,"3-RECIBO")
		ENDIF
		
		
		
		Define MsDialog oDlg Title "Altera��o de Solicita��o de Reembolso" From 084, 230 To 622, 726 Pixel
		@ 06,008 TO 35,242 LABEL "Dados Solicita��o" OF oDlg PIXEL
		@ 016,020 SAY "Numero: "   SIZE 35,8 PIXEL OF oDlg
		@ 015,043 MSGET cNumero  when .f. SIZE 26,10 PIXEL OF oDlg
		@ 015,073 MSGET _cSeq when .f. SIZE 06,10 PIXEL OF oDlg
		@ 016,100 SAY "Dt.Registro: "   SIZE 35,8 PIXEL OF oDlg
		@ 015,130 MSGET cdatareg picture "99/99/9999" when .f. SIZE 35,10 PIXEL OF oDlg
		@ 016,170 SAY "Solicit: "   SIZE 35,8 PIXEL OF oDlg
		@ 015,187 MSGET csolicita when .f. SIZE 50,10 PIXEL OF oDlg
		@ 040,008 TO 110,242 LABEL "Dados Reembolso" OF oDlg PIXEL
		@ 050,020 SAY "Usu�rio Reembolsado:"   SIZE 75,8 PIXEL OF oDlg
		@ 049,080 MSGET cusuario f3 "US3" when .T. SIZE 60,10 PIXEL OF oDlg
		@ 050,150 SAY "Dt.Despesa:"   SIZE 35,8 PIXEL OF oDlg
		@ 049,185 MSGET _ddataDes valid ValDtdesp() picture "99/99/9999" when .t. SIZE 45,10 PIXEL OF oDlg
		@ 065,020 SAY "Fornecedor:"  SIZE 35,8 PIXEL OF oDlg
		@ 064,055 MSGET cfornece f3 "SA2A" Valid ValFornece() when .T. SIZE 40,10 PIXEL OF oDlg
		@ 064,100 MSGET cloja when .F. SIZE 10,10 PIXEL OF oDlg
		@ 064,125 MSGET cnomefor when .T. SIZE 105,10 PIXEL OF oDlg
		@ 080,020 SAY "Banco:"  SIZE 35,8 PIXEL OF oDlg
		@ 079,045 MSGET cbanco when .T. SIZE 10,10 PIXEL OF oDlg
		@ 080,072 SAY "Agencia:"  SIZE 35,8 PIXEL OF oDlg
		@ 079,097 MSGET cagencia when .T. SIZE 10,10 PIXEL OF oDlg
		@ 080,130 SAY "Conta:"  SIZE 35,8 PIXEL OF oDlg
		@ 079,150 MSGET cconta when .T. SIZE 40,10 PIXEL OF oDlg
		@ 080,195 SAY "Digito:"  SIZE 35,8 PIXEL OF oDlg
		@ 079,215 MSGET cdigito when .T. SIZE 5,10 PIXEL OF oDlg
		@ 095,020 SAY "Valor:"  SIZE 35,8 PIXEL OF oDlg
		@ 094,045 MSGET nvlrSol Picture '@E 999,999,999.99' when .T. SIZE 60,10 PIXEL OF oDlg
		@ 095,130 SAY "Classifica��o:"  SIZE 35,8 PIXEL OF oDlg
		@ 094,183 ComboBox _cClas Items _aClassif Size 46,21
		@ 114,020 SAY "Produto:"  SIZE 35,8 PIXEL OF oDlg
		@ 113,045 MSGET cprod F3 "SB1" VALID ValProd() when .T. SIZE 45,10 PIXEL OF oDlg
		@ 113,092 MSGET cnomprod when .F. SIZE 136,10 PIXEL OF oDlg
		@ 129,020 SAY "Item Ctb:"  SIZE 35,8 PIXEL OF oDlg
		@ 128,045 MSGET citemctb F3 "CTD" VALID ValItCtb() when .T. SIZE 45,10 PIXEL OF oDlg
		@ 128,092 MSGET cdescit when .F. SIZE 136,10 PIXEL OF oDlg
		@ 144,020 SAY "C.Custo:"  SIZE 35,8 PIXEL OF oDlg
		@ 143,045 MSGET cccusto F3 "CTT" VALID ValCCusto() when .T. SIZE 45,10 PIXEL OF oDlg
		@ 143,092 MSGET cdescusto when .F. SIZE 136,10 PIXEL OF oDlg
		@ 165,008 SAY "Observa��es:"  SIZE 35,8 PIXEL OF oDlg
		@ 175,008 Get cobserv Size 234, 050 Memo Object oMemo
		@ 230,155 BUTTON "_Registrar" 	SIZE 40,15 ACTION FIEGRVALT()
		@ 230,202 BUTTON "_Cancelar" 	SIZE 40,15 ACTION close(oDlg)
		Activate MsDialog oDlg Center
	Else
		alert("Solicita��es que n�o estejam com status 'Em elabora��o' n�o podem ser alteradas.")
	Endif
Endif

Return



Static Function FIEGRVALT()

Dbselectarea("SZM")
Dbsetorder(1)
If Dbseek(xFilial("SZM")+SZM->ZM_NUMERO+SZM->ZM_SEQUEN)
	RecLock("SZM",.F.)
	SZM->ZM_FORNECE:=cfornece
	SZM->ZM_LOJA   :=cloja
	SZM->ZM_NOMEFOR:=cnomefor
	SZM->ZM_SOLICIT:=csolicita
	SZM->ZM_USUREEM:=cusuario
	SZM->ZM_BANCO  :=cbanco
	SZM->ZM_AGENCIA:=cagencia
	SZM->ZM_CONTA  :=cconta
	SZM->ZM_DIGITO :=cdigito
	SZM->ZM_VALOR  :=nvlrSol
	SZM->ZM_PRODUTO:=cprod
	SZM->ZM_DESCPRO:=cnomprod
	SZM->ZM_ITEMCTB:=citemctb
	SZM->ZM_CCUSTO :=cccusto
	SZM->ZM_CLASSIF:="1"
	SZM->ZM_OBSERV :=cobserv
	MsUnlock()
	ALERT("Solicita��o Alterada com sucesso!")
Endif

oDlg:End()
Return()


User Function fiExc03()

Dbselectarea("SZM")
Dbsetorder(1)
If Dbseek(xFilial("SZM")+SZM->ZM_NUMERO)
	If empty(SZM->ZM_LIBER)
		If MsgYesNo("Confirma a exclus�o da solicita��o?")
			RecLock("SZM",.F.)
			Delete
			MsUnlock()
		Endif
	Else
		alert("Solicita��es que n�o estejam com status 'Em elabora��o' n�o podem ser exclu�das.")
	Endif
Endif
Return()

User Function fiEAp03()

Dbselectarea("SZM")
Dbsetorder(1)
If Dbseek(xFilial("SZM")+SZM->ZM_NUMERO)
	_cNumero:=SZM->ZM_NUMERO
	
	If empty(SZM->ZM_LIBER)
		If MsgYesNo("Confirma o envio da solicita��o de reembolso para Aprova��o?")
			
			_cCCusto    :=SZM->ZM_CCUSTO
			lValido:=.t.
			_cCodUser	:=__CUSERID
			
			Dbselectarea("SAL")
			Dbsetorder(1)
			If Dbseek(xFilial("SAL")+ALLTRIM(_cCCusto))
				_cUser:=SAL->AL_USER
				
				// Dados Aprovador
				PswOrder(1)	// ordena por user CODIGO
				If PswSeek(_cUser, .T. )
					_aDados := PswRet() // Retorna vetor com informacoes do usuario
				EndIf
				_cAprov	:=_aDados[1][4]
				
				// Dados solicitante
				PswOrder(1)	// ordena por user CODIGO
				If PswSeek(_cCodUser, .T. )
					_aDados := PswRet() // Retorna vetor com informacoes do usuario
				EndIf
				
				_cNameUsr	:=_aDados[1][4]
				_cDepto		:=_aDados[1][12]
			Endif
			
			_cEMail := Alltrim(UsrRetMail(_cUser))
			_cBody  := "Prezado(a) "+_cAprov+ ", " + Chr(13)+Chr(10)+Chr(13)+Chr(10)
			_cBody  += "Informamos que a solicita��o de reembolso - "+SZM->ZM_NUMERO+" incluida pelo usu�rio: "+SZM->ZM_SOLICIT+", precisa ser aprovada."
			_cBody  += Chr(13)+Chr(10)+Chr(13)+Chr(10)
			_cBody  += "Solicita��o de Reembolso ref. a :"+SZM->ZM_PRODUTO+"/"+SZM->ZM_DESCPRO+" - "+SZM->ZM_OBSERV+"."
			_cBody  += Chr(13)+Chr(10)+Chr(13)+Chr(10)
			_cBody  += "Favor acessar a Rotina de Solicita��o de Reembolso e efetuar a Libera��o da Solicita��o. "
			ACSendMail( ,,,,_cEMail,"Solicitacao de Reembolso: "+SZM->ZM_NUMERO+" - NECESSARIA APROVACAO",_cBody)
			
			While(SZM->ZM_NUMERO == _cNumero)
				RecLock("SZM",.F.)
				SZM->ZM_LIBER:="E"
				MsUnlock()
				Dbselectarea("SZM")
				Dbskip()
			Enddo
		Endif
	Else
		ALERT("Essa solicita��o j� est� em processo de aprova��o e essa a��o n�o poder� ser acionada novamente.")
	Endif
Endif
Return()


User Function fileg03()

Local aLegenda := {}

AADD(aLegenda,{"BR_VERDE"			, "Em elabora��o"		 })
AADD(aLegenda,{"BR_AMARELO"			, "Aguardando aprova��o" })
AADD(aLegenda,{"BR_AZUL"  		, "Solicita��o aprovada - Aguardando reembolso"	})
AADD(aLegenda,{"BR_PRETO"		, "Solicita��o Rejeitada"	})
AADD(aLegenda,{"BR_VERMELHO"		, "Reembolso efetuado - Finalizado"	})


BrwLegenda("FIESP","Status da Solicita��o de Reembolso",aLegenda)
Return


User Function fiapr03()
_cClas   := ""
_aClassif:={}

Dbselectarea("SZM")
Dbsetorder(1)
If Dbseek(xFilial("SZM")+SZM->ZM_NUMERO)
	_cNumero:=SZM->ZM_NUMERO
	If (SZM->ZM_LIBER)=="E"
		While(SZM->ZM_NUMERO==_cNumero)
			cNumero   := SZM->ZM_NUMERO
			cdatareg  := SUBSTR(DTOS(SZM->ZM_REGISTR),7,2)+"/"+SUBSTR(DTOS(SZM->ZM_REGISTR),5,2)+"/"+SUBSTR(DTOS(SZM->ZM_REGISTR),1,4)
			_ddataDes := SZM->ZM_DTDESP
			cfornece  := SZM->ZM_FORNECE
			cloja     := SZM->ZM_LOJA
			cnomefor  := SZM->ZM_NOMEFOR
			csolicita := SZM->ZM_SOLICIT
			cusuario  := SZM->ZM_USUREEM
			cbanco    := SZM->ZM_BANCO
			cagencia  := SZM->ZM_AGENCIA
			cconta    := SZM->ZM_CONTA
			cdigito   := SZM->ZM_DIGITO
			nvlrSol   := SZM->ZM_VALOR
			cprod     := SZM->ZM_PRODUTO
			cnomprod  := SZM->ZM_DESCPRO
			citemctb  := SZM->ZM_ITEMCTB
			cccusto   := SZM->ZM_CCUSTO
			cobserv   := SZM->ZM_OBSERV
			cdescit   := Posicione( "CTD", 1, xFilial( "CTD" ) + citemctb, "CTD_DESC01" )
			cdescusto := Posicione( "CTT", 1, xFilial( "CTT" ) + cccusto,  "CTT_DESC01" )
			_cSeq     := SZM->ZM_SEQUEN
			_cClas    := SZM->ZM_CLASSIF
			
			
			IF SUBSTR(_cClas,1,1)=="1"
				AADD(_aClassif,"1-NF")
				AADD(_aClassif,"2-CUPOM FISCAL")
				AADD(_aClassif,"3-RECIBO")
			ELSEIF SUBSTR(_cClas,1,1)=="2"
				AADD(_aClassif,"2-CUPOM FISCAL")
				AADD(_aClassif,"1-NF")
				AADD(_aClassif,"3-RECIBO")
			ELSEIF SUBSTR(_cClas,1,1)=="2"
				AADD(_aClassif,"3-RECIBO")
				AADD(_aClassif,"1-NF")
				AADD(_aClassif,"2-CUPOM FISCAL")
			eLSE
				AADD(_aClassif,"1-NF")
				AADD(_aClassif,"2-CUPOM FISCAL")
				AADD(_aClassif,"3-RECIBO")
			ENDIF
			
			
			Define MsDialog oDlg Title "Aprova��o da Solicita��o de Reembolso" From 084, 230 To 622, 726 Pixel
			@ 06,008 TO 35,242 LABEL "Dados Solicita��o" OF oDlg PIXEL
			@ 016,020 SAY "Numero: "   SIZE 35,8 PIXEL OF oDlg
			@ 015,043 MSGET cNumero  when .f. SIZE 26,10 PIXEL OF oDlg
			@ 015,073 MSGET _cSeq when .f. SIZE 06,10 PIXEL OF oDlg
			@ 016,100 SAY "Dt.Registro: "   SIZE 35,8 PIXEL OF oDlg
			@ 015,130 MSGET cdatareg picture "99/99/9999" when .f. SIZE 35,10 PIXEL OF oDlg
			@ 016,170 SAY "Solicit: "   SIZE 35,8 PIXEL OF oDlg
			@ 015,187 MSGET csolicita when .f. SIZE 50,10 PIXEL OF oDlg
			@ 040,008 TO 110,242 LABEL "Dados Reembolso" OF oDlg PIXEL
			@ 050,020 SAY "Usu�rio Reembolsado:"   SIZE 75,8 PIXEL OF oDlg
			@ 049,080 MSGET cusuario f3 "US3" when .f. SIZE 60,10 PIXEL OF oDlg
			@ 050,150 SAY "Dt.Despesa:"   SIZE 35,8 PIXEL OF oDlg
			@ 049,185 MSGET _ddataDes valid ValDtdesp() picture "99/99/9999" when .f. SIZE 45,10 PIXEL OF oDlg
			@ 065,020 SAY "Fornecedor:"  SIZE 35,8 PIXEL OF oDlg
			@ 064,055 MSGET cfornece f3 "SA2A" Valid ValFornece() when .f. SIZE 40,10 PIXEL OF oDlg
			@ 064,100 MSGET cloja when .f. SIZE 10,10 PIXEL OF oDlg
			@ 064,125 MSGET cnomefor when .f. SIZE 105,10 PIXEL OF oDlg
			@ 080,020 SAY "Banco:"  SIZE 35,8 PIXEL OF oDlg
			@ 079,045 MSGET cbanco when .f. SIZE 10,10 PIXEL OF oDlg
			@ 080,072 SAY "Agencia:"  SIZE 35,8 PIXEL OF oDlg
			@ 079,097 MSGET cagencia when .f. SIZE 10,10 PIXEL OF oDlg
			@ 080,130 SAY "Conta:"  SIZE 35,8 PIXEL OF oDlg
			@ 079,150 MSGET cconta when .f. SIZE 40,10 PIXEL OF oDlg
			@ 080,195 SAY "Digito:"  SIZE 35,8 PIXEL OF oDlg
			@ 079,215 MSGET cdigito when .f. SIZE 5,10 PIXEL OF oDlg
			@ 095,020 SAY "Valor:"  SIZE 35,8 PIXEL OF oDlg
			@ 094,045 MSGET nvlrSol Picture '@E 999,999,999.99' when .f. SIZE 60,10 PIXEL OF oDlg
			@ 095,130 SAY "Classifica��o:"  SIZE 35,8 PIXEL OF oDlg
			@ 094,183 ComboBox _cClas Items _aClassif WHEN .F. Size 46,21
			@ 114,020 SAY "Produto:"  SIZE 35,8 PIXEL OF oDlg
			@ 113,045 MSGET cprod F3 "SB1" VALID ValProd() when .f. SIZE 45,10 PIXEL OF oDlg
			@ 113,092 MSGET cnomprod when .F. SIZE 136,10 PIXEL OF oDlg
			@ 129,020 SAY "Item Ctb:"  SIZE 35,8 PIXEL OF oDlg
			@ 128,045 MSGET citemctb F3 "CTD" VALID ValItCtb() when .f. SIZE 45,10 PIXEL OF oDlg
			@ 128,092 MSGET cdescit when .F. SIZE 136,10 PIXEL OF oDlg
			@ 144,020 SAY "C.Custo:"  SIZE 35,8 PIXEL OF oDlg
			@ 143,045 MSGET cccusto F3 "CTT" VALID ValCCusto() when .f. SIZE 45,10 PIXEL OF oDlg
			@ 143,092 MSGET cdescusto when .F. SIZE 136,10 PIXEL OF oDlg
			@ 165,008 SAY "Observa��es:"  SIZE 35,8 PIXEL OF oDlg
			@ 175,008 Get cobserv when .f. Size 234, 050 Memo Object oMemo
			@ 230,155 BUTTON "_Aprovar" 	SIZE 40,15 ACTION Fi03Aprov(SZM->ZM_NUMERO,SZM->ZM_SEQUEN)
			@ 230,202 BUTTON "_Rejeitar" 	SIZE 40,15 ACTION Fi03Reprov(SZM->ZM_NUMERO,SZM->ZM_SEQUEN)
			Activate MsDialog oDlg Center
			Dbselectarea("SZM")
			Dbskip()
		Enddo
	Else
		Alert("S� podem ser aprovadas solicita��es que estejam com status de 'Aguardando aprova��o' - Legenda Amarela")
	Endif
Endif
Return


Static Function Fi03Aprov(_cNumero,_cSequen)

Dbselectarea("SZM")
Dbsetorder(1)
If Dbseek(xFilial("SZM")+_cNumero+_cSequen)
	RecLock("SZM",.F.)
	SZM->ZM_LIBER  :="S"
	SZM->ZM_APROV  :=__CUSERID
	SZM->ZM_DTAPROV:=DDATABASE
	MsUnlock()
	lValido:=.t.
	_cCodUser	:=__CUSERID
	_cCCusto    :=SZM->ZM_CCUSTO
	_cUsuFin    := GetMv("FI_USUREEM",,.F.)
	
	// Dados Usu�rio pela libera��o do $$
	/*	PswOrder(1)	// ordena por user CODIGO
	If PswSeek(_cUsuFin, .T. )
	_aDados := PswRet() // Retorna vetor com informacoes do usuario
	EndIf
	_cAprov	:=_aDados[1][4]
	
	// Dados solicitante
	PswOrder(1)	// ordena por user CODIGO
	If PswSeek(_cCodUser, .T. )
	_aDados := PswRet() // Retorna vetor com informacoes do usuario
	EndIf
	
	_cNameUsr	:=_aDados[1][4]
	_cDepto		:=_aDados[1][12]
	
	_cEMail := Alltrim(UsrRetMail(_cUsuFin))
	_cBody  := "Prezado(a) "+_cAprov+ ", " + Chr(13)+Chr(10)+Chr(13)+Chr(10)
	_cBody  += "Informamos que a solicita��o de reembolso - "+SZM->ZM_NUMERO+" Seq:"+SZM->ZM_SEQUEN+", solicitada por: "+alltrim(SZM->ZM_SOLICIT)+", foi aprovada. Programe o credito ou a libera��o do valor para o solicitante."
	_cBody  += Chr(13)+Chr(10)+Chr(13)+Chr(10)
	_cBody  += "Ao liberar o valor, favor acessar a rotina de Solicita��o de Reembolso e efetuar a baixa da Solicita��o. "
	ACSendMail( ,,,,_cEMail,"Libera��o de Solicitacao de Reembolso: "+SZM->ZM_NUMERO+"/"+SZM->ZM_SEQUEN+" - INFORMACAO",_cBody)*/
eNDIF
CLOSE(oDlg)
Return()

Static Function Fi03Reprov(_cNumero,_cSequen)
_cMotRej:="   "

Define MsDialog oDlg1 Title "Rejei��o da Solicita��o de Reembolso" From 091, 232 To 312, 607 Pixel
@ 006,008 SAY "Indique o motivo da rejei��o da solicita��o: "   SIZE 105,8 PIXEL OF oDlg1
@ 016,008 Get _cMotRej when .T. Size 174, 060 Memo Object oMemo
@ 080,140 BUTTON "_Ok" 	SIZE 40,15 ACTION RegRej03(_cNumero,_cSequen)
Activate MsDialog oDlg1 Center
Return()

Static Function RegRej03(_cNumero,_cSequen)

Dbselectarea("SZM")
Dbsetorder(1)
If Dbseek(xFilial("SZM")+_cNumero+_cSequen)
	_cCodUser:=SZM->ZM_SOLICIT
	Reclock("SZM",.F.)
	SZM->ZM_LIBER:="R"
	Msunlock()
	
	PswOrder(2)	// ordena por user CODIGO
	If PswSeek(_cCodUser, .T. )
		_aDados := PswRet() // Retorna vetor com informacoes do usuario
	EndIf
	_cCodUsu    :=_aDados[1][1]
	_cNameUsr	:=_aDados[1][4]
	_cDepto		:=_aDados[1][12]
	
	_cEMail := Alltrim(UsrRetMail(_cCodUsu))
	_cBody  := "Prezado(a) "+_cNameUsr+ ", " + Chr(13)+Chr(10)+Chr(13)+Chr(10)
	_cBody  += "Informamos que a sua solicita��o de reembolso - "+SZM->ZM_NUMERO+" Seq:"+SZM->ZM_SEQUEN+", foi reprovada. "
	_cBody  += Chr(13)+Chr(10)+Chr(13)+Chr(10)
	_cBody  += "Motivo: "+_cMotRej
	ACSendMail( ,,,,_cEMail,"Rejei��o de Solicitacao de Reembolso: "+SZM->ZM_NUMERO+"/"+SZM->ZM_SEQUEN+" - INFORMACAO",_cBody)
	
Endif
close(oDlg1)
close(oDlg)
Return()

User Function fibax03()

Dbselectarea("SZM")
Dbsetorder(1)
If Dbseek(xFilial("SZM")+SZM->ZM_NUMERO+SZM->ZM_SEQUEN)
	If (SZM->ZM_LIBER)=="S"
		If MsgYesNo("Confirma a Baixa da solicita��o de reembolso?")
			RecLock("SZM",.F.)
			SZM->ZM_LIBER:="X"
			MsUnlock()
		eNDIF
		
		_cCodUser	:=__CUSERID
		_cCCusto    :=SZM->ZM_CCUSTO
		
		// Dados solicitante
		PswOrder(1)	// ordena por user CODIGO
		If PswSeek(_cCodUser, .T. )
			_aDados := PswRet() // Retorna vetor com informacoes do usuario
		EndIf
		
		_cNameUsr	:=_aDados[1][4]
		_cDepto		:=_aDados[1][12]
		
		_cEMail := Alltrim(UsrRetMail(_cCodUser))
		_cBody  := "Prezado(a) "+_cNameUsr+ ", " + Chr(13)+Chr(10)+Chr(13)+Chr(10)
		_cBody  += "Informamos que a sua solicita��o de reembolso - "+SZM->ZM_NUMERO+", foi aprovada. "
		_cBody  += Chr(13)+Chr(10)+Chr(13)+Chr(10)
		ACSendMail( ,,,,_cEMail,"Solicitacao de Reembolso Liberada: "+SZM->ZM_NUMERO+" - INFORMACAO",_cBody)
	Endif
Endif
Return

User Function fiImp03()

If SZM->ZM_LIBER <> "S"
	
	IF MsgYesNo("Imprime a Solicita��o de Reembolso, mesmo sem estar aprovada?")
		_cMens:="Solicita��o de Reembolso n�o aprovada."
		_cRetAprov:=.F.
			Processa({|| Imp03Sol(_cMens)}, "Processando Arquivos...")
	Endif
Else
	_cMens:=""                                                            
			_cRetAprov:=.T.
				Processa({|| Imp03Sol(_cMens)}, "Processando Arquivos...")
Endif
Return()

Static Function Imp03Sol(_cMens)                          

_cDatab:=DTOS(DDATABASE)
_cHora:=time()
_cUsuario:=""
_nPag:=0

_NomeUser := substr(cUsuario,7,15)
// Defino a ordem
PswOrder(2) // Ordem de nome
     
// Efetuo a pesquisa, definindo se pesquiso usu�rio ou grupo
If PswSeek(_NomeUser,.T.)

// Obtenho o resultado conforme vetor
   _aRetUser := PswRet(1)

   _cUsuario:= upper(alltrim(_aRetUser[1,2]))
         
EndIf     

Private cTitulo := "SOLICITA��O DE REEMBOLSO: "+SZM->ZM_NUMERO
Private oFont1 := TFont():New("Courier New", , 16, , .T., , , , .F., .F.)
Private oFont2 := TFont():New("Courier New", , 12, , .T., , , , .F., .F.)
Private oFont3 := TFont():New("Courier New", , 12, , .F., , , , .F., .F.)
Private oFont4 := TFont():New("Courier New", , 10, , .T., , , , .F., .F.)
Private oFont5 := TFont():New("Courier New", , 10, , .F., , , , .F., .F.)
Private oFont6 := TFont():New("Courier New", , 08, , .T., , , , .F., .F.)
Private oFont7 := TFont():New("Courier New", , 08, , .F., , , , .F., .F.)
Private oFont8 := TFont():New("Courier New", , 18, , .T., , , , .F., .F.)
Private oFont9 := TFont():New("Courier New", , 14, , .T., , , , .F., .F.)
Private oFont10:= TFont():New("Courier New", , 11, , .F., , , , .F., .F.)
Private oBrush  := TBrush():New(, CLR_HGRAY)


oPrint := TMSPrinter():New(cTitulo)
oPrint:SetPortrait() 
oPrint:SetPaperSize(9)
oPrint:Setup()
oPrint:StartPage()

impcabec()

	_cCodUser:=SZM->ZM_USUREEM
	
	PswOrder(2)	// ordena por user CODIGO
	If PswSeek(_cCodUser, .T. )
		_aDados := PswRet() // Retorna vetor com informacoes do usuario
	EndIf
	_cCodUsu    :=_aDados[1][1]
	_cNameUsr	:=_aDados[1][4]
	_cDepto		:=_aDados[1][12]


oPrint:Box(0310, 0100, 0400, 2320)
oPrint:Say(0340, 0490, "Favorecido: ", oFont9, , , , 1)
oPrint:Say(0340, 0750, ALLTRIM(_cCodUser), oFont9, , , , 1)
//++" - "+_cNameUsr
// Cabe�alho da tabela

// Item
oPrint:Box(0420, 0100, 0510, 0300)
oPrint:Say(0440, 0250, "Item", oFont2, , , , 1)
// Produto
oPrint:Box(0420, 0300, 0510, 1750)
oPrint:Say(0440, 0520, "Produto", oFont2, , , , 1)
// Valor 
oPrint:Box(0420, 1750, 0510, 2320)
oPrint:Say(0440, 2140, "Valor", oFont2, , , , 1)

_nLinha:=0510
           
Dbselectarea("SZM")
Dbsetorder(1)
If Dbseek(xFilial("SZM")+SZM->ZM_NUMERO)
_cNumero:=SZM->ZM_NUMERO
_nTotal:=0
While SZM->ZM_NUMERO == _cNumero

If _nLinha >= 2210                                    
ImpRodape(.t.)
Endif     

//Grade dos itens                                                             
// Item
oPrint:Box(_nLinha, 0100, _nLinha+100, 0300)
// Produto
oPrint:Box(_nLinha, 0300, _nLinha+100, 1750)
// Valor 
oPrint:Box(_nLinha, 1750, _nLinha+100, 2320)

// Item
oPrint:Say(_nLinha, 0240, SZM->ZM_SEQUEN, oFont3, , , , 1)
// Produto
oPrint:Say(_nLinha, 0510, ALLTRIM(SZM->ZM_PRODUTO), oFont5, , , , 1)
oPrint:Say(_nLinha, 0590, " - ", oFont5, , , , 1)
oPrint:Say(_nLinha, 1485, (SZM->ZM_DESCPRO), oFont5, , , , 1)
// Valor 
oPrint:Say(_nLinha, 2170, AllTrim(Transform(SZM->ZM_VALOR, PesqPict("SZM", "ZM_VALOR"))), oFont3, , , , 1)
_nLinha:=_nLinha+100

_nTotal:=_nTotal+SZM->ZM_VALOR
Dbselectarea("SZM")
Dbskip()
Enddo
Endif

If _nLinha+100 >= 2210                                    
ImpRodape(.t.)
Endif     

// Total                                    
oPrint:Box(_nLinha, 1750, _nLinha+100, 2320)
oPrint:Say(_nLinha, 2170, AllTrim(Transform(_nTotal, PesqPict("SZM", "ZM_VALOR"))), oFont2, , , , 1)                    

If _nLinha+200 >= 2210                                    
ImpRodape(.t.)
Endif     
_nLinha:=_nLinha+200

If _nLinha >= 2210                                    
ImpRodape(.t.)
Endif     

// Cabe�alho da contabilizacao

// Item
oPrint:Box(_nLinha, 0100, _nLinha+100, 0300)
oPrint:Say(_nLinha+30, 0250, "Item", oFont2, , , , 1)
// C.Custo
oPrint:Box(_nLinha, 0300, _nLinha+100, 1550)
oPrint:Say(_nLinha+30, 0720, "Centro de Custo", oFont2, , , , 1)
// Item Contabil 
oPrint:Box(_nLinha, 1550, _nLinha+100, 1950)
oPrint:Say(_nLinha+30, 1920, "Item Cont�bil", oFont2, , , , 1)
// Conta Cont�bil 
oPrint:Box(_nLinha, 1950, _nLinha+100, 2320)
oPrint:Say(_nLinha+30, 2260, "C.Contabil", oFont2, , , , 1)

_nLinha:=_nLinha+100                    

Dbselectarea("SZM")
Dbsetorder(1)
If Dbseek(xFilial("SZM")+_cNumero)
_cNumero:=SZM->ZM_NUMERO
_nTotal:=0
While SZM->ZM_NUMERO == _cNumero

If _nLinha >= 2210                                    
ImpRodape(.t.)
Endif     

//Grade dos itens                                                             
// Item
oPrint:Box(_nLinha, 0100, _nLinha+100, 0300)
// c.Custo
oPrint:Box(_nLinha, 0300, _nLinha+100, 1550)
// Item Contabil 
oPrint:Box(_nLinha, 1550, _nLinha+100, 1950)
// Conta
oPrint:Box(_nLinha, 1950, _nLinha+100, 2320)


// Item
oPrint:Say(_nLinha, 0240, SZM->ZM_SEQUEN, oFont3, , , , 1)
// Centro de Custo
oPrint:Say(_nLinha, 0450, ALLTRIM(SZM->ZM_CCUSTO), oFont5, , , , 1)
oPrint:Say(_nLinha, 0530, " - ", oFont5, , , , 1)
oPrint:Say(_nLinha, 1420, Posicione( "CTT", 1, xFilial( "CTT" ) + SZM->ZM_CCUSTO,  "CTT_DESC01" ), oFont5, , , , 1)
// Item Contabil 
oPrint:Say(_nLinha, 1820, ALLTRIM(SZM->ZM_ITEMCTB), oFont5, , , , 1)
// Conta Contabil 
oPrint:Say(_nLinha, 2450, Posicione( "SB1", 1, xFilial( "SB1" ) + SZM->ZM_PRODUTO,  "B1_CONTA" ), oFont5, , , , 1)

_nLinha:=_nLinha+100

Dbselectarea("SZM")
Dbskip()
Enddo
Endif                   

If _nLinha+200 >= 2210                                    
ImpRodape(.t.)
Endif     
_nLinha:=_nLinha+200


If _nLinha+100 >= 2210                                    
ImpRodape(.t.)
Endif     
// Cabe�alho das observacoes

// Item
oPrint:Box(_nLinha, 0100, _nLinha+100, 0300)
oPrint:Say(_nLinha+30, 0250, "Item", oFont2, , , , 1)
// Observacoes
oPrint:Box(_nLinha, 0300, _nLinha+100, 2320)
oPrint:Say(_nLinha+30, 0620, "Observacoes", oFont2, , , , 1)

_nLinha:=_nLinha+100          


Dbselectarea("SZM")
Dbsetorder(1)
If Dbseek(xFilial("SZM")+_cNumero)
_cNumero:=SZM->ZM_NUMERO
_nTotal:=0
While SZM->ZM_NUMERO == _cNumero

If _nLinha >= 2210                                    
ImpRodape(.t.)
Endif     

//Grade dos itens                                                             
// Item
oPrint:Box(_nLinha, 0100, _nLinha+100, 0300)
// Item
oPrint:Say(_nLinha, 0240, SZM->ZM_SEQUEN, oFont3, , , , 1)
// Observacoes             

nLinhas := MLCount(SZM->ZM_OBSERV,88)
_nLinIni:=_nLinha
For nXi:= 1 To nLinhas
        cTxtLinha := MemoLine(SZM->ZM_OBSERV,88,nXi)
        If !Empty(cTxtLinha)
            oPrint:Say(_nLinha+10,0320,(cTxtLinha),oFont5)
        EndIf
        _nLinha:=_nLinha+100
Next nXi

// Observacoes
oPrint:Box(_nLinIni, 0300, _nLinha, 2320)

_cCodUser:=SZM->ZM_SOLICIT
_dDtReg:=SZM->ZM_REGISTR               

_cCodAprov:=SZM->ZM_APROV
_dDtApr:=SZM->ZM_DTAPROV

Dbselectarea("SZM")
Dbskip()
Enddo
Endif              
If _nLinha+200 >= 2210                                    
ImpRodape(.t.)
Endif     
_nLinha:=_nLinha+200                 

If _nLinha+300 >= 2210                                    
ImpRodape(.t.)
Endif                     

iF 		_cRetAprov==.T.
// CAIXA APROVA��ES
oPrint:Box(_nLinha, 0100, _nLinha+300, 0544)
oPrint:Box(_nLinha, 0544, _nLinha+300, 0988)
oPrint:Box(_nLinha, 0988, _nLinha+300, 1432)
oPrint:Box(_nLinha, 1432, _nLinha+300, 1876)
oPrint:Box(_nLinha, 1876, _nLinha+300, 2320)

oPrint:Say(_nLinha+10, 0230,"Emitente",oFont2)

	
	PswOrder(2)	// ordena por user CODIGO
	If PswSeek(_cCodUser, .T. )
		_aDados := PswRet() // Retorna vetor com informacoes do usuario
	EndIf
	_cNameUsr	:=_aDados[1][4]	
	
	PswOrder(1)	// ordena por user CODIGO
	If PswSeek(_cCodAprov, .T. )
		_aDados := PswRet() // Retorna vetor com informacoes do usuario
	EndIf
	_cNameApr	:=_aDados[1][4]	
oPrint:Say(_nLinha+100, 0140,SUBSTR(_cNameUsr,1,15),oFont3)
oPrint:Say(_nLinha+200, 0200,SUBSTR(DTOS(_dDtReg),7,2)+"/"+SUBSTR(DTOS(_dDtReg),5,2)+"/"+SUBSTR(DTOS(_dDtReg),1,4),oFont3)

oPrint:Say(_nLinha+10, 0694,"Gestor",oFont2)               
oPrint:Say(_nLinha+100, 0574,SUBSTR(_cNameApr,1,15),oFont3)
oPrint:Say(_nLinha+200, 0600,SUBSTR(DTOS(_dDtApr),7,2)+"/"+SUBSTR(DTOS(_dDtApr),5,2)+"/"+SUBSTR(DTOS(_dDtApr),1,4),oFont3)

oPrint:Say(_nLinha+10, 1158,"GCF",oFont2)
oPrint:Say(_nLinha+200, 1018," ____/____/____",oFont3)

oPrint:Say(_nLinha+10, 1485,"Dir.Financeiro",oFont2)
oPrint:Say(_nLinha+200, 1462," ____/____/____",oFont3)

oPrint:Say(_nLinha+10, 1930,"Dir.Secret�rio",oFont2)
oPrint:Say(_nLinha+200, 1906," ____/____/____",oFont3)
Else

oPrint:Say(_nLinha, 0230,"SOLICITA��O DE REEMBOLSO PENDENTE DE APROVA��O",oFont9)
ENDIF


_nLinha:=2210          

If _nLinha >= 2210                                    
ImpRodape(.f.)	    
Endif                                 

oPrint:EndPage()
oPrint:Preview()
oPrint:End()

Return(lRet)         

Static Function ImpCabec()
oPrint:Box(0050, 0100, 0200, 2320)
oPrint:SayBitmap(053, 0103, "logo_fiesp.jpg", 524, 147, , )
oPrint:Say(0100, 0450, "                         SOLICITACAO DE REEMBOLSO ", oFont8, , , , 1)


oPrint:Box(0210, 0100, 0300, 2320)
oPrint:Say(0240, 0850, "Empresa/Filial: "+SZM->ZM_FILIAL, oFont9, , , , 1)
oPrint:Say(0240, 2250, "No: "+SZM->ZM_NUMERO, oFont9, , , , 1)
Return()


Static Function ImpRodape(_cRet)

_nPag:=_nPag+1
oPrint:Say(2310,2280,"Data de Impress�o: "+SUBSTR(_cDatab,7,2)+"/"+SUBSTR(_cDatab,5,2)+"/"+SUBSTR(_cDatab,1,4)+" Hora: "+_cHora+" Usu�rio: "+_cUsuario+" P�g."+ALLTRIM(str(_nPag))+".", oFont6, , , , 1)               
If _cRet == .t.
_nLinha:=0410
	    oPrint:EndPage(.T.)
        oPrint:StartPage() 
        ImpCabec()
Endif        
Return()



