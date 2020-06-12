#INCLUDE "rwmake.ch"
#include "_FixSX.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³  CONSB1  º Autor ³ Andy               º Data ³  08/01/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Consulta a SB1 e SB5                                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CONSB1()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cArq,cInd,cPerg
Local cString := "SB1"

dbSelectArea("SB1")
dbSetOrder(1)



cCadastro := "Consulta a cadastro de produtos"
aRotina   := { 	{"Pesquisar" ,"AxPesqui"    , 0 , 1},;
{"Visualizar"   ,"AxVisual"   , 0 , 2},;
{"Consulta"     ,"U_SB1SB5" , 0 , 3}}


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Realiza a Filtragem                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SB1")
dbSetOrder(1)

//mBrowse( 6,1,22,75,"SB1",,,,,2, aCores)
mBrowse( 6,1,22,75,"SB1")
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Consulta SB1 x SB5º Autor ³ Andy      º Data ³  08/01/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function SB1SB5()

Local aArea    := GetArea()

dbSelectArea("SB5")
dbSetOrder(1)
If dbSeek(xFilial("SB5")+SB1->B1_COD)
   _nPrv2:=SB5->B5_PRV2
   _nPrv3:=SB5->B5_PRV3
   _nPrv4:=SB5->B5_PRV4
   _nPrv5:=SB5->B5_PRV5
   _nPrv6:=SB5->B5_PRV6
   _nPrv7:=SB5->B5_PRV7
Else     
   _nPrv2:=0
   _nPrv3:=0
   _nPrv4:=0
   _nPrv5:=0
   _nPrv6:=0
   _nPrv7:=0
EndIf
              
_cNome1:=""
_cNome2:=""
_cNome3:=""
_cNome4:=""
_cNome5:=""

// _cTexto  := Memoread(SB1->B1_ESPEC)
 _nLinhas := Mlcount(SB1->B1_ESPEC,50)
 For _nL := 1 to _nLinhas
     _cAux:= AllTrim(str(_nL))
	    _cNome&(_cAux) := Memoline(SB1->B1_ESPEC,50,_nL)                                                                                 	
 Next

dbSelectArea("SB1")
@ 200,1 TO 520,450 DIALOG oProcDoc TITLE OemToAnsi("Preco de Venda")     	
@ 002,10 TO 135,220
@ 010,018 Say "Codigo              : " + SB1->B1_COD
@ 018,018 Say "Ult. Compra       : " + DTOC(SB1->B1_UCOM)
@ 026,018 Say "Descricao         : " + _cNome1
@ 034,018 Say "                         : " + _cNome2
@ 042,018 Say "                         : " + _cNome3
@ 050,018 Say "                         : " + _cNome4
@ 058,018 Say "                         : " + _cNome5
@ 074,018 Say "Preco Venda 1 : " + STR(SB1->B1_PRV1,17,2)   
@ 082,018 Say "Preco Venda 2 : " + STR(_nPRV2,17,2)   
@ 090,018 Say "Preco Venda 3 : " + STR(_nPRV3,17,2)   
@ 098,018 Say "Preco Venda 4 : " + STR(_nPRV4,17,2)   
@ 106,018 Say "Preco Venda 5 : " + STR(_nPRV5,17,2)   
@ 114,018 Say "Preco Venda 6 : " + STR(_nPRV6,17,2)   
@ 122,018 Say "Preco Venda 7 : " + STR(_nPRV7,17,2)   

@ 145,180 BMPBUTTON TYPE 01 ACTION Close(oProcDoc)

Activate Dialog oProcDoc Centered

RestArea(aArea)


Return



