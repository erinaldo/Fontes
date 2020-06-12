#INCLUDE "rwmake.ch"
#include "_FixSX.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA25   บ Autor ณ Andy               บ Data ณ  29/04/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Reclassificacao da Natureza do SE5                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CFINA25()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local   aArea := GetArea()
Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private aAcho := {}
Private aCpos := {}
lAltera:=.T.
aMemos := {}

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SE5")
aHeader:={}
While !Eof() .And. (x3_arquivo == "SE5")
	IF X3USO(x3_usado).And. AllTrim(x3_campo)<>"FILIAL" .And. x3_propri=="C"
		AADD(aAcho, AllTrim(x3_campo))
	Endif
	dbSkip()
EndDo

AADD(aCpos,"E5_NATREC")
AADD(aCpos,"E5_FLUXO")

dbSelectArea("SE5")
dbSetOrder(1)

cCadastro := "Natureza de Contas a Receber"
aCores    := {}
aRotina   := { 	{"Pesquisar"  ,"AxPesqui"    , 0 , 1},;
{"Visualizar" ,"U_VisSE5"  , 0 , 2},;
{"Natureza"   ,"U_NatSE5"   , 0 , 4},;
{"Legenda"    ,'BrwLegenda(cCadastro,"Legenda",{{"BR_AMARELO","Natureza a Reclassificar"},{"BR_VERDE","Natureza Reclassificada"},{"BR_VERMELHO","Natureza Definitiva"},{"BR_AZUL","Movimenta็ใo Cancelada"}})',0 , 4 }}

Aadd( aCores, { "Alltrim(E5_SITUACA) <> 'C' .And. Empty(E5_NATREC) .And. ALLTRIM(E5_NATUREZ) = '6.08.01'"  , "BR_AMARELO" 	 } )
Aadd( aCores, { "Alltrim(E5_SITUACA) <> 'C' .And. !Empty(E5_NATREC)" , "BR_VERDE" 	 } )
Aadd( aCores, { "Alltrim(E5_SITUACA) <> 'C' .And. ALLTRIM(E5_NATUREZ) <> '6.08.01'"                         , "BR_VERMELHO" } )
Aadd( aCores, { "Alltrim(E5_SITUACA) == 'C'" 	                     , "BR_AZUL"	 } )
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRealiza a Filtragem                                                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("SE5")
dbSetOrder(1)

mBrowse( 6,1,22,75,"SE5",,,,,2, aCores)

Return

User Function VisSE5()
AxVisual('SE5',Recno(),2,aAcho,aCpos)
Return

User Function NatSE5()
// AxAltera("SE1",Recno(),4,aAcho,aCpos,,,'ExecBlock("SE1SE5",.F.,.F.)')
If AllTrim(SE5->E5_SITUACA) == "C"
	_cMsg := "Movimenta็ใo Bancแria Cancelada Nใo permite Reclassifica็ใo!!"
	MsgAlert(_cMsg, "Aten็ใo")
Else
	If AllTrim(SE5->E5_NATUREZ) == "6.08.01"
		AxAltera("SE5",Recno(),4,aAcho,aCpos)
	Else
		_cMsg := "Natureza de Origem Nใo permite Reclassifica็ใo!!"
		MsgAlert(_cMsg, "Aten็ใo")
	EndIf
EndIf
Return


