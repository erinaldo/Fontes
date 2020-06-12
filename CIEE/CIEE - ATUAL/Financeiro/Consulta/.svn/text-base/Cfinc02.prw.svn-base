#INCLUDE "rwmake.ch"
#include "_FixSX.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFINC02   º Autor ³ Andy               º Data ³  10/03/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Consulta de Previsão de Pgto.                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CFINC02()

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


cCadastro := "Consulta à Previsão de Contas a Pagar "
aCores    := {}
aRotina   := { 	{"Pesquisar" ,"AxPesqui"    , 0 , 1},;
{"Previsao"     ,"U_PRESE2"   , 0 , 2},;
{"Legenda"      ,'BrwLegenda(cCadastro,"Legenda",{{"BR_AMARELO","Previsto"},{"BR_PRETO","Realizado"}})',0 , 3 }}

Aadd( aCores, { " Empty(E2_BAIXA) .And. Empty(E2_NUMBOR) .And. Empty(E2_NUMAP) "  , "BR_AMARELO" 	} )
Aadd( aCores, { "!Empty(E2_BAIXA) .Or. !Empty(E2_NUMBOR) .Or. !Empty(E2_NUMAP) "  , "BR_PRETO"	} )

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
±±ºPrograma  ³ PRESE2 º Autor ³ Andy                 º Data ³  04/03/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PRESE2()

Private cPerg  := "FIC002    "

_aPerg := {}

AAdd(_aPerg,{cPerg,"01","Ordem              ?","","","mv_ch1","N",01,0,0,"C","","mv_par01","Vencimento","","","","","Natureza","","","","","","","","","","","","","","","","","","","","",""})
aAdd(_aPerg,{cPerg,"02","Do  Vencimento     ?","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(_aPerg,{cPerg,"03","Ate Vencimento     ?","","","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(_aPerg,{cPerg,"04","Da  Natureza       ?","","","mv_ch4","C",15,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(_aPerg,{cPerg,"05","Ate Natureza       ?","","","mv_ch5","C",15,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aPerg,{cPerg,"06","Do  Fornecedor     ?","","","mv_ch6","C",06,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SA2","",""})
aAdd(_aPerg,{cPerg,"07","Ate Fornecedor     ?","","","mv_ch7","C",06,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SA2","",""})


AjustaSX1(_aPerg)
// Atualiza o campo data de referencia (mv_par03)
// para a daba base do sistema (dDataBase).
SX1->(dbSetOrder(1)); SX1->(dbSeek(cPerg + "06"))
RecLock("SX1", .F.)
SX1->X1_CNT01 := SE2->E2_FORNECE
SX1->(msUnLock())                                
SX1->(dbSeek(cPerg + "07"))
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
_cQuery += " AND E2_FORNECE >=  '"     + mv_par06 + "'"
_cQuery += " AND E2_FORNECE <=  '"     + mv_par07 + "'"
_cQuery += " AND E2_BAIXA    =  ''"
_cQuery += " AND E2_NUMBOR   =  ''" 
_cQuery += " AND E2_NUMAP    =  ''" 
_cQuery += " AND E2_NUM     *= F1_DOC "
_cQuery += " AND E2_PREFIXO *= F1_SERIE "
_cQuery += " AND E2_FORNECE *= F1_FORNECE "
_cQuery += " AND E2_LOJA    *= F1_LOJA "

U_EndQuery( @_cQuery,_cOrdem, "SE2TMP", {"SE2","SF1" },,,.T. )


dbSelectArea("SE2TMP")
dbGoTop()

_nConta      := 1

While !Eof()            

	If !Empty(SE2TMP->F1_DOC)
		_cUserLG   := FWLeUserlg("SE2TMP->F1_USERLGI")  //PATRICIA FONTANEZI - 09/10/2012 - Embaralha(SE2TMP->F1_USERLGI,1)
		_cUsuario1 := Subs(_cUserLG,1,15)
	Else
		_cUserLG   := FWLeUserlg("SE2TMP->E2_USERLGI") //PATRICIA FONTANEZI - 09/10/2012 - Embaralha(SE2TMP->E2_USERLGI,1)
		_cUsuario1 := Subs(_cUserLG,1,15)
	EndIf
	
	If SE2TMP->E2_TIPO == "FL "
	  _cFL:=SE2TMP->E2_NUM
	Else
	  _cFL:=Space(6)
	EndIf

    aAdd(aPags,{SE2TMP->E2_TIPO+"/"+SE2TMP->E2_NUM, SE2TMP->E2_VENCREA, SE2TMP->E2_NOMFOR, SE2TMP->E2_VALOR, _cFL, SE2TMP->E2_NATUREZ, SE2TMP->E2_EMISSAO, _cUsuario1 })
    
	dbSelectArea("SE2TMP")
	DbSkip()
EndDo

// "Titulo"                           ,"Vencimento"        ,"Fornecedor"        ,"Valor"                                            "FL"                ,"Natureza"         ,"Emissao"                ,"Usuario        
// 1                                   2                    3                    4                                                   5                   6                   7                         8
// SE2TMP->E2_TIPO+"/"+SE2TMP->E2_NUM ,SE2TMP->E2_VENCREA  ,SE2TMP->E2_NOMFOR   ,SE2TMP->E2_VALOR                                                       ,_cFL               ,SE2TMP->E2_EMISSAO       ,_cUsuario1
// aPags[oLbx1:nAt,1]                 ,aPags[oLbx1:nAt,2]  ,aPags[oLbx1:nAt,3]  ,Transform(aPags[oLbx1:nAt,4],"@EZ 999,999,999.99") ,aPags[oLbx1:nAt,5] ,aPags[oLbx1:nAt,6] ,aPags[oLbx1:nAt,7]       ,aPags[oLbx1:nAt,8]      


dbSelectArea("SE2TMP")                                                     		

If Len(aPags) > 0
	
	DEFINE MSDIALOG oDlg FROM  31,58 TO 360,695 TITLE "Escolha Movimentacao Contas a Pagar a conciliar " PIXEL
	@ 05,05 LISTBOX oLbx1 FIELDS HEADER "Titulo","Vencimento","Fornecedor","Valor","FL","Natureza","Emissao","Usuario" SIZE 310, 130 OF oDlg PIXEL //;
	
	
	oLbx1:SetArray(aPags)
	oLbx1:bLine := { || {aPags[oLbx1:nAt,1], aPags[oLbx1:nAt,2], aPags[oLbx1:nAt,3], Transform(aPags[oLbx1:nAt,4],"@EZ 999,999,999.99"), aPags[oLbx1:nAt,5], aPags[oLbx1:nAt,6],aPags[oLbx1:nAt,7],aPags[oLbx1:nAt,8]} }
	oLbx1:nFreeze  := 1
	

	DEFINE SBUTTON FROM 145, 256 TYPE 6  ENABLE OF oDlg ACTION U_CFINR015()
	DEFINE SBUTTON FROM 145, 288 TYPE 1  ENABLE OF oDlg ACTION (oDlg:End())
	                                                                             	
	ACTIVATE MSDIALOG oDlg CENTERED
Else
	MsgInfo("Não Há Pagtos. Previstos com os Parâmetros Informados!","Atenção")
Endif

dbSelectArea("SE2TMP")                                                     		
DbCloseArea()

RestArea(aArea)

Return
		