#INCLUDE "rwmake.ch"
#include "_FixSX.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFINC01   º Autor ³ Andy               º Data ³  04/03/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Consulta de Titulos                                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CFINC01()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cArq,cInd,cPerg
Local cString := "SE2"
Local aStru

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.
Private aPags := {}

Private _lRet

dbSelectArea("SE2")
dbSetOrder(1)


cCadastro := "Consulta a Contas a Pagar "
aCores    := {}
aRotina   := { 	{"Pesquisar" ,"AxPesqui"    , 0 , 1},;
{"Consultar"   ,"U_CONSE2(1)"   , 0 , 2},;
{"Pendentes"   ,"U_CONSE2(2)"   , 0 , 3},;
{"Legenda"      ,'BrwLegenda(cCadastro,"Legenda",{{"BR_VERDE","Aberto"},{"BR_VERMELHO","Baixado"}})',0 , 4 }}

Aadd( aCores, { " Empty(E2_BAIXA)  "  , "BR_VERDE" 	} )
Aadd( aCores, { "!Empty(E2_BAIXA)  "  , "BR_VERMELHO"	} )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Realiza a Filtragem                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SE2")
dbSetOrder(1)

mBrowse( 6,1,22,75,"SE2",,,,,2, aCores)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ConSE2 º Autor ³ Andy                 º Data ³  04/03/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CONSE2(_nOpc)

Private cPerg  := "FIC001"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros		    		    ³
//³ mv_par01				// Data De        					³
//³ mv_par02				// Data Ate       					³
//³ mv_par03				// Natureza De                      ³
//³ mv_par04				// Natureza	Ate	                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_aPerg := {}
AAdd(_aPerg,{cPerg,"01","Ordem              ?","","","mv_ch1","N",01,0,0,"C","","mv_par01","Vencimento","","","","","Natureza","","","","","","","","","","","","","","","","","","","","",""})
aAdd(_aPerg,{cPerg,"02","Do  Vencimento     ?","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(_aPerg,{cPerg,"03","Ate Vencimento     ?","","","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(_aPerg,{cPerg,"04","Da  Natureza       ?","","","mv_ch4","C",15,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(_aPerg,{cPerg,"05","Ate Natureza       ?","","","mv_ch5","C",15,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aPerg,{cPerg,"06","Baixa/Conciliado   ?","","","mv_ch6","N",01,0,0,"C","","mv_par06","Baixados","","","","","Conciliados","","","","","Ambos","","","","","Todos","","","","","","","","","","",""})
aAdd(_aPerg,{cPerg,"07","Da  Baixa          ?","","","mv_ch7","D",08,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(_aPerg,{cPerg,"08","Ate Baixa          ?","","","mv_ch8","D",08,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(_aPerg,{cPerg,"09","Do  Conciliado     ?","","","mv_ch9","D",08,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(_aPerg,{cPerg,"10","Ate Conciliado     ?","","","mv_cha","D",08,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aPerg,{cPerg,"11","Do  Fornecedor     ?","","","mv_chb","C",06,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","SA2","",""})
aAdd(_aPerg,{cPerg,"12","Ate Fornecedor     ?","","","mv_chc","C",06,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","SA2","",""})
aAdd(_aPerg,{cPerg,"13","Tipo Pgto          ?","","","mv_chd","C",03,0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","","05","",""})

AjustaSX1(_aPerg)
// Atualiza o campo data de referencia (mv_par03)
// para a daba base do sistema (dDataBase).
SX1->(dbSetOrder(1)); SX1->(dbSeek(cPerg + "11"))
RecLock("SX1", .F.)
SX1->X1_CNT01 := SE2->E2_FORNECE
SX1->(msUnLock())
SX1->(dbSeek(cPerg + "12"))
RecLock("SX1", .F.)
SX1->X1_CNT01 := SE2->E2_FORNECE
SX1->(msUnLock())

If !Pergunte(cPerg, .T.)
	Return
EndIf

aArea    := GetArea()
aPags    := {}

DbSelectArea("SE2")
DbSetOrder(1)
If mv_par01==1
	cChave  := "E2_FILIAL+DTOS(E2_VENCREA)+E2_NATUREZ+STR(E2_VALOR)"
Else
	cChave  := "E2_FILIAL+E2_NATUREZ+DTOS(E2_VENCREA)+STR(E2_VALOR)"
EndIf

_xFilSE2:=xFilial("SE2")
_xFilSF1:=xFilial("SF1")


If _nOpc == 1
	_cOrdem := cChave
	_cQuery := " SELECT *, SE2.R_E_C_N_O_ REGSE2"
	_cQuery += " FROM "
	_cQuery += RetSqlName("SE2")+" SE2,"
	_cQuery += RetSqlName("SF1")+" SF1"
	_cQuery += " WHERE '"+ _xFilSE2 +"' = E2_FILIAL"
	_cQuery += " AND   '"+ _xFilSF1 +"' = F1_FILIAL"
	_cQuery += " AND E2_VENCREA >=  '"     + DTOS(mv_par02) + "'"
	_cQuery += " AND E2_VENCREA <=  '"     + DTOS(mv_par03) + "'"
	_cQuery += " AND E2_NATUREZ >=  '"     + mv_par04 + "'"
	_cQuery += " AND E2_NATUREZ <=  '"     + mv_par05 + "'"
	_cQuery += " AND E2_TIPO NOT IN ('TX','INS','ISS')"
	If mv_par06==1 .Or. mv_par06==3
		_cQuery += " AND E2_BAIXA  <>  ''"
		_cQuery += " AND E2_BAIXA   >=  '"     + DTOS(mv_par07) + "'"
		_cQuery += " AND E2_BAIXA   <=  '"     + DTOS(mv_par08) + "'"
	EndIf
	_cQuery += " AND E2_FORNECE >=  '"     + mv_par11 + "'"
	_cQuery += " AND E2_FORNECE <=  '"     + mv_par12 + "'"
	_cQuery += " AND E2_NUM     *= F1_DOC "
	_cQuery += " AND E2_PREFIXO *= F1_SERIE "
	_cQuery += " AND E2_FORNECE *= F1_FORNECE "
	_cQuery += " AND E2_LOJA    *= F1_LOJA "
	If !Empty(mv_par13)
		_cQuery += " AND E2_TIPO    = '"     + mv_par13 + "'"
	EndIf	
Else
	_cOrdem := cChave
	_cQuery := " SELECT *, SE2.R_E_C_N_O_ REGSE2"
	_cQuery += " FROM "
	_cQuery += RetSqlName("SE2")+" SE2,"
	_cQuery += RetSqlName("SF1")+" SF1"
	_cQuery += " WHERE '"+ _xFilSE2 +"' = E2_FILIAL"
	_cQuery += " AND   '"+ _xFilSF1 +"' = F1_FILIAL"
	_cQuery += " AND E2_VENCREA >=  '"     + DTOS(mv_par02) + "'"
	_cQuery += " AND E2_VENCREA <=  '"     + DTOS(mv_par03) + "'"
	_cQuery += " AND E2_NATUREZ >=  '"     + mv_par04 + "'"
	_cQuery += " AND E2_NATUREZ <=  '"     + mv_par05 + "'"
	_cQuery += " AND ((E2_BAIXA   =  '' AND E2_NUMBOR  <>  '')  OR (E2_BAIXA   =  '' AND E2_NUM  <>  '' AND E2_TIPO  =  'FL '))"
	_cQuery += " AND E2_FORNECE >=  '"     + mv_par11 + "'"
	_cQuery += " AND E2_FORNECE <=  '"     + mv_par12 + "'"
	_cQuery += " AND E2_NUM     *= F1_DOC "
	_cQuery += " AND E2_PREFIXO *= F1_SERIE "
	_cQuery += " AND E2_FORNECE *= F1_FORNECE "
	_cQuery += " AND E2_LOJA    *= F1_LOJA "
EndIf
U_EndQuery( @_cQuery,_cOrdem, "SE2TMP", {"SE2","SF1" },,,.T. )


dbSelectArea("SE2TMP")
dbGoTop()

_nConta      := 1

While !Eof()
	_dConc    := cTod("  /  /  ")
	_cBanco   := Space(03)
	_cAgencia := Space(05)
	_cConta   := Space(10)
	_cCheque  := Space(10)
	
	SE5->(dbSetOrder(7))
	If SE5->(dbSeek(xFilial("SE5")+SE2TMP->E2_PREFIXO+SE2TMP->E2_NUM+SE2TMP->E2_PARCELA+SE2TMP->E2_TIPO+SE2TMP->E2_FORNECE+SE2TMP->E2_LOJA, .F.))
		While !SE5->(Eof()) .And. SE2TMP->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)==SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)
			If SE5->(E5_VALOR)==SE2TMP->(E2_VALLIQ) //(E2_VALOR) ALTERADO POR CG EM 08/06/06 CONF CHAMADO 17108
				_cBanco   := SE5->(E5_BANCO)
				_cAgencia := SE5->(E5_AGENCIA)
				_cConta   := SE5->(E5_CONTA)
				
				If SE5->(E5_RECONC) == "x"
					_dConc:=SE5->(E5_DTDISPO)
				EndIf
				Exit
			EndIf
			SE5->(dbSkip())
		EndDo
	EndIf
	
	If !Empty(SE2TMP->E2_NUMAP)
		dbSelectArea("SEF")
		dbSetOrder(3)
		If dbSeek(xFilial("SEF")+SE2TMP->E2_PREFIXO+SE2TMP->E2_NUM+SE2TMP->E2_PARCELA+SE2TMP->E2_TIPO,.F.)
			_cCheque  := LEFT(SEF->EF_NUM,10)
			_cBanco   := SEF->EF_BANCO
			_cAgencia := SEF->EF_AGENCIA
			_cConta   := SEF->EF_CONTA
			SE5->(dbSetOrder(1))
			If SE5->(dbSeek(xFilial("SE5")+DTOS(SEF->EF_DATA)+SEF->EF_BANCO+SEF->EF_AGENCIA+SEF->EF_CONTA+SEF->EF_NUM, .F.))
				If SE5->(E5_RECONC) == "x"
					_dConc := SE5->(E5_DTDISPO)
				EndIf
			EndIf
		EndIf
	Else
		_cCheque := Space(10)
	EndIf
	
	dbSelectArea("SE2TMP")
	If (mv_par06==2 .Or. mv_par06==3)
		If _dConc<mv_par09 .Or. _dConc>mv_par10 .Or. Empty(_dConc)
			dbSelectArea("SE2TMP")
			DbSkip()
			Loop
		EndIf
	EndIf
	
	If !Empty(SE2TMP->F1_DOC)
		_cUserLG    := Embaralha(SE2TMP->F1_USERLGI,1)
		_cUsuario1  := Subs(_cUserLG,1,15)
	Else
		_cUserLG    := Embaralha(SE2TMP->E2_USERLGI,1)
		_cUsuario1  := Subs(_cUserLG,1,15)
	EndIf
	
	If SE2TMP->E2_TIPO == "FL "
		_cFL:=SE2TMP->E2_NUM
	Else
		_cFL:=Space(6)
	EndIf
	
	aAdd(aPags,{SE2TMP->E2_TIPO+"/"+SE2TMP->E2_NUM, SE2TMP->E2_VENCREA, SE2TMP->E2_NOMFOR, SE2TMP->E2_VALOR, SE2TMP->E2_VALLIQ, SE2TMP->E2_NUMBOR, SE2TMP->E2_NUMAP, _cCheque, _cFl, SE2TMP->E2_NATUREZ, SE2TMP->E2_EMISSAO, SE2TMP->E2_BAIXA, _dConc, _cBanco, _cAgencia, _cConta, _cUsuario1, SE2TMP->E2_HIST })
	
	dbSelectArea("SE2TMP")
	DbSkip()
EndDo

// "Titulo"                           ,"Vencimento"        ,"Fornecedor"        ,"Valor"                                            ,"Bordero"          ,"AP"                ,"Cheque"           ,"FL                ,"Natureza"         ,"Emissao"                ,"Baixa"               ,"Concilacao"        ,"Banco"             ,"Agencia"           ,"Conta"             ,"Usuario
// 1                                   2                    3                    4                                                   5                   6                    7                   8                   9                   10                        11                     12                   13                   14                   15                   16
// SE2TMP->E2_TIPO+"/"+SE2TMP->E2_NUM ,SE2TMP->E2_VENCREA  ,SE2TMP->E2_NOMFOR   ,SE2TMP->E2_VALOR                                   ,SE2TMP->E2_NUMBOR  ,SE2TMP->E2_NUMAP    _cCheque            ,_cFL               ,SE2TMP->E2_NATUREZ ,STOD(SE2TMP->E2_EMISSAO) ,STOD(SE2TMP->E2_BAIXA ,_dConc              ,_cBanco             ,_cAgencia           ,_cConta             ,_cUsuario1
// aPags[oLbx1:nAt,1]                 ,aPags[oLbx1:nAt,2]  ,aPags[oLbx1:nAt,3]  ,Transform(aPags[oLbx1:nAt,4],"@EZ 999,999,999.99") ,aPags[oLbx1:nAt,5] ,aPags[oLbx1:nAt,6]  ,aPags[oLbx1:nAt,7] ,aPags[oLbx1:nAt,8] ,aPags[oLbx1:nAt,9] ,aPags[oLbx1:nAt,10]      ,aPags[oLbx1:nAt,11]   ,aPags[oLbx1:nAt,12] ,aPags[oLbx1:nAt,13] ,aPags[oLbx1:nAt,14] ,aPags[oLbx1:nAt,15] ,aPags[oLbx1:nAt,16]


dbSelectArea("SE2TMP")
//DbCloseArea()

If Len(aPags) > 0
	
	DEFINE MSDIALOG oDlg FROM  31,58 TO 360,695 TITLE "Escolha Movimentacao Contas a Pagar a conciliar " PIXEL
	@ 05,05 LISTBOX oLbx1 FIELDS HEADER "Titulo","Vencimento","Fornecedor","Valor Titulo","Valor Liquido","Bordero","AP","Cheque","FL","Natureza","Emissao","Baixa","Concilacao" ,"Banco","Agencia","Conta","Usuario","Historico" SIZE 310, 130 OF oDlg PIXEL //;
	
	
	oLbx1:SetArray(aPags)
	oLbx1:bLine := { || {aPags[oLbx1:nAt,1], aPags[oLbx1:nAt,2], aPags[oLbx1:nAt,3], Transform(aPags[oLbx1:nAt,4],"@EZ 999,999,999.99"), Transform(aPags[oLbx1:nAt,5],"@E 999,999,999.99"), aPags[oLbx1:nAt,6], aPags[oLbx1:nAt,7], aPags[oLbx1:nAt,8], aPags[oLbx1:nAt,9], aPags[oLbx1:nAt,10], aPags[oLbx1:nAt,11], aPags[oLbx1:nAt,12],aPags[oLbx1:nAt,13],aPags[oLbx1:nAt,14],aPags[oLbx1:nAt,15],aPags[oLbx1:nAt,16],aPags[oLbx1:nAt,17],aPags[oLbx1:nAt,18]  } }
	oLbx1:nFreeze  := 1
	
	
	//	DEFINE SBUTTON FROM 130, 030 TYPE 9  ENABLE OF oDlg ACTION (oDlg:End())
	//	DEFINE SBUTTON FROM 130, 062 TYPE 8  ENABLE OF oDlg ACTION (oDlg:End())
	//	DEFINE SBUTTON FROM 130, 096 TYPE 7  ENABLE OF oDlg ACTION (oDlg:End())
	//	DEFINE SBUTTON FROM 130, 128 TYPE 6  ENABLE OF oDlg ACTION (oDlg:End())
	//	DEFINE SBUTTON FROM 130, 160 TYPE 5  ENABLE OF oDlg ACTION (oDlg:End())
	//	DEFINE SBUTTON FROM 130, 192 TYPE 4  ENABLE OF oDlg ACTION (oDlg:End())
	//	DEFINE SBUTTON FROM 130, 224 TYPE 3  ENABLE OF oDlg ACTION (oDlg:End())
	//	DEFINE SBUTTON FROM 130, 256 TYPE 2  ENABLE OF oDlg ACTION (oDlg:End())
	//	DEFINE SBUTTON FROM 130, 288 TYPE 1  ENABLE OF oDlg ACTION (oDlg:End())
	
	//	DEFINE SBUTTON FROM 140, 030 TYPE 18  ENABLE OF oDlg ACTION (oDlg:End())
	//	DEFINE SBUTTON FROM 140, 062 TYPE 17  ENABLE OF oDlg ACTION (oDlg:End())
	//	DEFINE SBUTTON FROM 140, 096 TYPE 16  ENABLE OF oDlg ACTION (oDlg:End())
	//	DEFINE SBUTTON FROM 140, 128 TYPE 15  ENABLE OF oDlg ACTION (oDlg:End())
	//	DEFINE SBUTTON FROM 140, 160 TYPE 14  ENABLE OF oDlg ACTION (oDlg:End())
	//	DEFINE SBUTTON FROM 140, 192 TYPE 13  ENABLE OF oDlg ACTION (oDlg:End())
	//	DEFINE SBUTTON FROM 140, 224 TYPE 12  ENABLE OF oDlg ACTION (oDlg:End())
	//	DEFINE SBUTTON FROM 140, 256 TYPE 11  ENABLE OF oDlg ACTION (oDlg:End())
	//	DEFINE SBUTTON FROM 140, 288 TYPE 10  ENABLE OF oDlg ACTION (oDlg:End())
	
	DEFINE SBUTTON FROM 145, 256 TYPE 6  ENABLE OF oDlg ACTION U_CFINR014()
	DEFINE SBUTTON FROM 145, 288 TYPE 1  ENABLE OF oDlg ACTION (oDlg:End())
	
	ACTIVATE MSDIALOG oDlg CENTERED
Else
	MsgInfo("Não Há Pagtos. com os Parâmetros Informados!","Atenção")
Endif

dbSelectArea("SE2TMP")
DbCloseArea()

RestArea(aArea)

Return

