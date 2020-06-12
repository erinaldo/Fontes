#include "rwmake.ch"
#include "_FixSX.ch" // "AddSX1.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ Cesta06  ³ Autor ³ Felipe Raposo         ³ Data ³ 29/11/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gera solicitacao de compra para os itens que estao abaixo  ³±±
±±³          ³ do ponto de pedido.                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico CIEE.                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function cesta06()
Local _cAlias
_cAlias := Alias()
dbSelectArea("SB1")
Set Filter to AllTrim(B1_TIPO) == "ME"
SB1->(dbGoTop())
Do While SB1->(!eof())
	Cmata170(SB1->B1_COD, 0)
	SB1->(dbSkip())
EndDo
Set Filter to 
dbSelectArea(_cAlias)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ MT240TOK ³ Autor ³ Felipe Raposo         ³ Data ³ 06/05/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de entrada - valida o movimento (MATA240).           ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico CIEE.                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT240TOK()
Cmata170(M->D3_COD, M->D3_QUANT)
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ MT241TOK ³ Autor ³ Felipe Raposo         ³ Data ³ 06/05/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de entrada - valida o movimento  (mod. 2) (MATA241). ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico CIEE.                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT241TOK()
Local _lRetorno, _nPsProd, _nPsQuant, _iAux, _nQuant
_lRetorno := .T.
_nPsProd  := aScan (aHeader, {|x| AllTrim(x[2]) == "D3_COD"})
_nPsQuant := aScan (aHeader, {|x| AllTrim(x[2]) == "D3_QUANT"})
// Varre todos os itens da aCols e teste produto por produto.
For _iAux := 1 to len(aCols)
	_cProd  := aCols [_iAux, _nPsProd]
	_nQuant := aCols [_iAux, _nPsQuant]
	Cmata170(_cProd, _nQuant)
Next _iAux
Return (_lRetorno)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ DATA   ³ BOPS ³Prograd.³ALTERACAO                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³21.05.98³16326A³Eduardo ³Acerto p/considerar estoque de seguranca.     ³±±
±±³22.06.98³16335A³Edson   ³Inclusao do PE. MS170QTD.                     ³±±
±±³25/06/98³16726A³Eduardo ³ Acerto numeracao SC1/SC2/SC7                 ³±±
±±³10.09.98³Wagner³Simidu  ³Gravacao do campo C1_IMPORT.                  ³±±
±±³25.11.98³18720 ³Edson   ³Correcao no calculo do saldo por almox.       ³±±
±±³08/01/99³Melhor³Viviani ³Nova forma de criacao de dialogos (Protheus). ³±±
±±³06/05/02³CIEE  ³Felipe R³Customizacoes especificas CIEE.               ³±±
±±ÀÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATA170  ³ Autor ³ Claudinei M. Benzi    ³ Data ³ 07/07/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gera solicita‡”es de compras baseado no ponto de pedido.   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Gen‚rico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CMATA170 ³ Autor ³ Felipe Raposo         ³ Data ³ 06/05/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gera SC automaticamente, logo que o produto alcanca o pon- ³±±
±±³          ³ to de pedido, sem que o usuario tenha que executar uma ro- ³±±
±±³          ³ tina para criar a SC.                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico CIEE.                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Cmata170(_Par01, _Par02, _lGera)
Local _cOpc
Private _cProd := _Par01, _nQuant := _Par02
_cOpc := IIf ((Type("_lGera") == "L" .and. _lGera), "S", upper(AllTrim(GetMV("MV_AUTOSC"))))// Verifiva nos parametros se eh pra gerar SC automaticamente.
If (_cOpc == "S")
	A170Point()
Endif
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A170Point³ Autor ³ Claudinei M. Benzi    ³ Data ³ 07/07/92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gera as solicitacoes de compra.                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MATA170                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function A170POINT()

Private _aPerg := {}
Private cPerg := "MT170a"
aAdd (_aPerg, {cPerg,"01","Produto de         ?","¨De Producto       ?","From Product       ?","mv_ch1","C",15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SB1","",""})
aAdd (_aPerg, {cPerg,"02","Produto at‚        ?","¨A  Producto       ?","To Product         ?","mv_ch2","C",15,0,0,"G","","mv_par02","","","","ZZZZZZZZZZZZZZZ","","","","","","","","","","","","","","","","","","","","","SB1","",""})
aAdd (_aPerg, {cPerg,"03","Grupo de           ?","¨De Grupo          ?","From Group         ?","mv_ch3","C",4,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SBM","",""})
aAdd (_aPerg, {cPerg,"04","Grupo at‚          ?","¨A  Grupo          ?","To Group           ?","mv_ch4","C",4,0,0,"G","","mv_par04","","","","ZZZZ","","","","","","","","","","","","","","","","","","","","","SBM","",""})
aAdd (_aPerg, {cPerg,"05","Tipo de            ?","¨De Tipo           ?","From Type          ?","mv_ch5","C",2,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","02","",""})
aAdd (_aPerg, {cPerg,"06","Tipo at‚           ?","¨A  Tipo           ?","To Type            ?","mv_ch6","C",2,0,0,"G","","mv_par06","","","","ZZ","","","","","","","","","","","","","","","","","","","","","02","",""})
aAdd (_aPerg, {cPerg,"07","Endereco de        ?","¨De Ubicacion      ?","From Address       ?","mv_ch7","C",2,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd (_aPerg, {cPerg,"08","Endereco ate       ?","¨A  Ubicacion      ?","To Address         ?","mv_ch8","C",2,0,0,"G","","mv_par08","","","","ZZ","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd (_aPerg, {cPerg,"09","Cons. Necess. Bruta?","¨Consd. Neces.Bruta?","Cons. Gross Necess.?","mv_ch9","N",1,0,1,"C","","mv_par09","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","","",""})
aAdd (_aPerg, {cPerg,"10","Saldo Neg Considera?","¨Consd Saldo Negat.?","Cons.Negat.Balance ?","mv_cha","N",1,0,1,"C","","mv_par10","Saldo","Saldo","Balance","","","Saldo+LE","Saldo+LE","Bal.+Econ.Lot","","","","","","","","","","","","","","","","","","",""})
aAdd (_aPerg, {cPerg,"11","Data Limite p/ Empe?","¨Fch. Limite p/Empe?","Deadline to Allocat?","mv_chb","D",8,0,0,"G","","mv_par11","","","","'  /  /  '","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd (_aPerg, {cPerg,"12","Cons. Qtd. De 3os. ?","¨Cons.Ctd.de Terc. ?","Cons.Qt.from 3rdPty?","mv_chc","N",1,0,2,"C","","mv_par12","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","","",""})
aAdd (_aPerg, {cPerg,"13","Cons. Qtd. Em 3os. ?","¨Cons.Ctd.en Terc. ?","Cons.Qt.in 3rdP.Pos?","mv_chd","N",1,0,2,"C","","mv_par13","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","","",""})
AjustaSX1(_aPerg)
Pergunte(cPerg, .F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros        ³
//³ mv_par01     // Produto de                  ³
//³ mv_par02     // Produto ate                 ³
//³ mv_par03     // Grupo de                    ³
//³ mv_par04     // Grupo ate                   ³
//³ mv_par05     // Tipo de                     ³
//³ mv_par06     // Tipo ate                    ³
//³ mv_par07     // Local de                    ³
//³ mv_par08     // Local ate                   ³
//³ mv_par09     // Considera Necess Bruta 1 sim³  Pto Pedido
//³ mv_par10     // Saldo Neg Considera    1 sim³  Lot.Economico
//³ mv_par11     // Data limite p/ empenhos     ³
//³ mv_par12     // Cons.Qtd. De 3os.? Sim / Nao³
//³ mv_par13     // Cons.Qtd. Em 3os.? Sim / Nao³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SG1->(dbSetOrder(1))  // Estrutura dos produtos.
SB1->(dbSetOrder(1))  // Cad. de produtos.
SB1->(dbSeek(xFilial("SB1") + _cProd, .F.))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtra grupos e tipos nao selecionados e tambem se eh MOD. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If  !(SB1->B1_GRUPO < mv_par03 .or. SB1->B1_GRUPO > mv_par04) .and.;
	!(SB1->B1_TIPO  < mv_par05 .or. SB1->B1_TIPO  > mv_par06) .and.;
	!(SubStr(SB1->B1_COD, 1, 3) == "MOD" .or. SB1->B1_TIPO == "BN") .and.;
	!(SB1->B1_CONTRAT == "S" .or. SG1->(dbSeek(xFilial("SG1") + SB1->B1_COD)))
	GeraSC()
EndIf
Return

// Continua processamento.
Static Function GeraSC()
Local cNumSolic, nPrazo, aQtdes := {}
Local nQuant := 0, nSaldo := 0, nNeces := 0, _nSldAux := 0
Local nTamUser, aTamSX3 := {}
Local nEstSeg   := 0
Local nAuxQuant := 0
Local cFornece  := CriaVar("C1_FORNECE")
Local cLoja     := CriaVar("C1_LOJA")
Local aFornepad := {}
Local lMS170FOR := (ExistBlock("MS170FOR"))
Local lMS170QTD := (ExistBlock("MS170QTD"))
Local lMT170SC1 := (ExistBlock("MT170SC1"))
aTamSX3  := TamSX3("C1_SOLICIT")
nTamUser := If(aTamSX3[1] < 15, aTamSX3[1], 15)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calcula o saldo atual de todos os almoxarifados.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SB2->(dbSeek(xFilial("SB2") + SB1->B1_COD, .T.))
Do While SB2->(!eof()) .and. SB2->B2_FILIAL + SB2->B2_COD == cFilial + SB1->B1_COD
	If !(SB2->B2_LOCAL < mv_par07 .or. SB2->B2_LOCAL > mv_par08)
		// Formula padrao do sistema para o calculo do saldo atual do produto.
		nSaldo += (SaldoSB2(,, If(empty(mv_par11), dDataBase, mv_par11), mv_par12 == 1, mv_par13 == 1) + SB2->B2_SALPEDI) - SB2->B2_QPEDVEN
	EndIf
	SB2->(dbSkip())
EndDo
//nEstSeg := CalcEstSeg(SB1->B1_ESTFOR)
//nSaldo -= nEstSeg

// Considera a quantidade do movimento atual que tambem esta saindo.
nSaldo -= _nQuant


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Essas sao as formula de calculo de necessidade criadas pelo ana- ³
//³ lista Felipe Raposo, de acordo com as necessidades do usuario    ³
//³ Waldir, todas registradas por atas de reuniao.                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Previsao de saldo na data de entrega do produto.
_nSldAux := nSaldo - (SB1->B1_PE * U_GetConsMed(SB1->B1_COD)/30)
_nSldAux := If (_nSldAux < 0, 0, _nSldAux)

// Calculo da necessidade.
nNeces := If (nSaldo <= SB1->B1_EMIN, SB1->B1_LE + SB1->B1_ESTSEG - _nSldAux, 0)

/*
// Essa eh a forma padrao de calculo do sistema microsiga.
// mv_par09  - Considera Necess Bruta 1 Sim -  Pto Pedido
// mv_par10  - Saldo Neg Considera    1 Sim -  Lot.Economico
If (Round(nSaldo, 4) != 0) .or. (mv_par09 == 1)
	Do Case
		Case (SB1->B1_EMIN != 0 .and. MV_PAR09 == 1)
			nNeces := If((nSaldo < 0),Abs(nSaldo)+SB1->B1_EMIN,(SB1->B1_EMIN-nSaldo))
		Case (SB1->B1_EMIN != 0 .and. MV_PAR09 == 2)
			nNeces := If((nSaldo < 0),Abs(nSaldo),(SB1->B1_EMIN-nSaldo))
		Case (SB1->B1_LE != 0 .and. (nSaldo < 0  .or. mv_par09 == 2))
			If (MV_PAR10 == 2 .and. nSaldo < 0)
				nNeces := Abs(nSaldo)+SB1->B1_LE
			Else
				nNeces := If(Abs(nSaldo)<SB1->B1_LE,SB1->B1_LE,if(nSaldo<0,Abs(nSaldo),0))
			EndIf
		OtherWise
			nNeces := IF(MV_PAR09 == 1,IIf(nSaldo<0,Abs(nSaldo),0),0)
	EndCase
Else
	If SB1->B1_EMIN != 0
		nNeces := SB1->B1_EMIN
	Else
		nNeces := 0
	Endif
EndIf
*/
If nNeces > 0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se produto tem estrutura.                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aQtdes := CalcLote(SB1->B1_COD, nNeces, "C")
	For nX := 1 to Len(aQtdes)
		nQuant += aQtdes[nX]
	Next
EndIf
dbSelectArea("SB1")
If lMS170QTD
	nAuxQuant := Execblock("MS170QTD", .F., .F., nQuant)
	If ValType(nAuxQuant) == "N"
		nQuant := nAuxQuant
	EndIf
EndiF

// Se houver necessidade, cria a SC.
If nQuant > 0
	Begin Transaction
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Pega o prazo de entrega do material         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nPrazo := CalcPrazo(SB1->B1_COD,nQuant)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gera solicitacao de compra                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cNumSolic := GetNumSC1(.T.)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ PDE para gravacao de fornecedor na solicitacao de compra. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lMS170FOR
		aFornepad := Execblock("MS170FOR", .F., .F.)
		If ValType(aFornepad) == "A"
			cFornece := aFornepad[1]
			cLoja    := aFornepad[2]
		EndIf
	EndiF
	RecLock("SC1",.T.)
	SC1->C1_FILIAL  := xFilial("SC1")
	SC1->C1_NUM     := cNumSolic
	SC1->C1_ITEM    := "01"
	SC1->C1_EMISSAO := dDataBase
	SC1->C1_PRODUTO := SB1->B1_COD
	SC1->C1_LOCAL   := SB1->B1_LOCPAD
	SC1->C1_UM      := SB1->B1_UM
	SC1->C1_SEGUM   := SB1->B1_SEGUM
	SC1->C1_DESCRI  := SB1->B1_DESC
	SC1->C1_QUANT   := nQuant
	SC1->C1_CONTA   := SB1->B1_CONTA
	SC1->C1_CC      := SB1->B1_CC
	SC1->C1_ITEMCTA := SB1->B1_ITEMCC
	SC1->C1_CLVL    := SB1->B1_CLVL
	SC1->C1_QTSEGUM := If(SB1->B1_TIPCONV=="M",(nQuant*SB1->B1_CONV),(nQuant/SB1->B1_CONV))
	SC1->C1_SOLICIT := Substr(cUsuario, 7, nTamUser)
	SC1->C1_DATPRF  := dDataBase+nPrazo
	SC1->C1_OBS     := cCadastro
	SC1->C1_IMPORT  := SB1->B1_IMPORT
	SC1->C1_FORNECE := cFornece
	SC1->C1_LOJA    := cLoja
	MaAvalSC("SC1",1)
	If __lSX8
		ConfirmSX8()
	EndIf
	If lMt170SC1
		ExecBlock("MT170SC1", .F., .F.)
	EndIf
	// Ponto de entrada que eh executado antes da gravacao de cada
	// item no MATA110 (Sol. de Compras).
	If ExistBlock("MT110GRV")
		ExecBlock("MT110GRV", .F., .F.)
	EndIf
	End Transaction
Endif
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Exibe a tela de perguntas ao usuario.          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
User Function MT170a()
Return (Pergunte("MT170a", .T.))