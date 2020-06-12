#INCLUDE "rwmake.ch"
#include "_FixSX.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFINA17   º Autor ³ Andy               º Data ³  25/08/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Cadastro de Diferencas FIBA                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CFINA17()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cArq,cInd,cPerg
Local cString := "SZC"
Local aStru

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.
Private aPags := {}
Private _dPar01, _dPar02
Private _cSZCBan, _cSZCAge, _cSZCCon, _dSZCEmi, _dSZCTip

_cSZCBan:=Space(03)
_cSZCAge:=Space(05)
_cSZCCon:=Space(10)
_cSZCTip:=Space(02)
_dSZCEmi:=dDataBase

dbSelectArea("SZC")
dbSetOrder(1)

cDelFunc  := "U_ALTSZC()"
cCadastro := "FIBA - Cadastro das Diferencas"
aCores    := {}
aRotina   := { 	{"Pesquisar"  ,"AxPesqui"    , 0 , 1},;
{"Visualizar"  ,"AxVisual"    , 0 , 2},;
{"Incluir"     ,'AxInclui("SZC",Recno(),3,,"U_SZCIni",,"U_SZCTudOK()")' , 0 , 3},;
{"Alterar"     ,'AxAltera("SZC",Recno(),4,,,,,"U_ALTSZC()")'            , 0 , 4},;
{"Excluir"     ,"AxDeleta"    , 0 , 5},;
{"Fechamento"      ,"U_SZCBaixa" , 0 , 6},;
{"Legenda"     ,'BrwLegenda(cCadastro,"Legenda",{{"BR_VERDE","Aberto"},{"BR_VERMELHO","Fechado"}})',0 , 7 }}

Aadd( aCores, { " Empty(ZC_STATUS)"    , "BR_VERDE" 	 	    } )
Aadd( aCores, { " !Empty(ZC_STATUS)"    , "BR_VERMELHO" 	 	    } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Realiza a Filtragem                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SZC")
dbSetOrder(2)

mBrowse( 6,1,22,75,"SZC",,,,,2, aCores)

Return


User Function SZCIni()
Local  _aArea := GetArea()
//M->Z8_BANCO    := _cSZCBan
RestArea(_aArea)
Return


User Function SZCTudOK()

Local  _aArea := GetArea()
//_cSZCBan := M->Z8_BANCO
RestArea(_aArea)
Return(.T.)

User Function ALTSZC()
Local  _aArea := GetArea()
_cRet:=If(Empty(ZC_STATUS),.T.,.F.)
If !_cRet
	_cMsg := "Registro com Fechamento nao pode ser Alterado, ou Excluido!!!"
	MsgAlert(_cMsg, "Atenção")
EndIf
RestArea(_aArea)
Return(_cRet)

User Function SZCBaixa()
Local  _aArea := GetArea()
_cMsg := "Vai gerar relatorio de Fechamento!!!"
MsgAlert(_cMsg, "Atenção")
RestArea(_aArea)
Return


User Function FINA17()

Local  _aArea := GetArea()
Local  _cRet  := .T.
/*
DbSelectarea("SZC")
If dbSeek(xFilial("SZC")+M->ZC_, .F.)
If SZC->ZC_ == M->ZC_
_cRet:=.F.
EndIf
EndIf
*/
RestArea(_aArea)
Return(_cRet)

