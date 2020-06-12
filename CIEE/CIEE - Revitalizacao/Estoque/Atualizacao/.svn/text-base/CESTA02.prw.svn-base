#include "rwmake.ch"
#define _PL CHR(13) + CHR(10)     
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CESTA02
Gera solicitacao de compra para os itens que estao abaixo do ponto de pedido. 
@author     Totvs
@since     	01/01/2015
@version  	P.11.8      
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum
Altera็๕es Realizadas desde a Estrutura็ใo Inicial
------------+-----------------+----------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                                                                                 
------------+-----------------+----------------------------------------------------------
		  	|				  | 
------------+-----------------+----------------------------------------------------------
/*/                             
//---------------------------------------------------------------------------------------
User Function CESTA02()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis.                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private cPerg11, cPerg12, cPerg13
Private lAbortPrint := .F., lEnd := .F.

_cMsg := "Isso irแ gerar solic. de compra para os" + _PL +;
"produtos que estใo abaixo do ponto de pedido." + _PL + _PL +;
"Continuar?"    

If MsgYesNo(OemToAnsi(_cMsg), OemToAnsi("Mensagem")) .and. Pergunte("MT170a    ", .T.)
	// Perguntas excluidas do padrao do sistema e assumindo valores fixos.
	mv_par11 := ctod('')  // Data Limite p/ Empe? (vazio)
	mv_par12 := 2         // Cons. Qtd. De 3os. ? (Nao)
	mv_par13 := 2         // Cons. Qtd. Em 3os. ? (Nao)
	MsAguarde({|lEnd| C4A02PRO() }, "Gerando SC...", "Aguarde", .T.)
Endif             

Return
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ C4A02PRO   บAutor  ณ Totvs       	   บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Continua processando...		         		              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/  
Static Function C4A02PRO()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis.                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local _cAlias
_cAlias := Alias()
dbSelectArea("SB1")
Set Filter to B1_XAUTSC == "1" .and.;  // Gera SC por PP?  1 - Sim
SubStr(B1_COD, 1, 3) != "MOD" .and.;
(B1_COD   >= mv_par01 .and. B1_COD   <= mv_par02) .and.;
(B1_GRUPO >= mv_par03 .and. B1_GRUPO <= mv_par04) .and.;
(B1_TIPO  >= mv_par05 .and. B1_TIPO  <= mv_par06)

SB1->(dbGoTop())
Do While SB1->(!eof())
	MsProcTxt("Processando produtos: " + SB1->B1_COD)
	If lAbortPrint; Exit; Endif
	U_C4A02GSC(SB1->B1_COD, 0, .T.)
	SB1->(dbSkip())
EndDo
Set Filter to
dbSelectArea(_cAlias)

Return 
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ C4A02GSC   บAutor  ณ Totvs       	   บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Gera SC automaticamente, logo que o produto alcanca o pon  บฑฑ 
ฑฑบ          ณ to de pedido, sem que o usuario tenha que executar uma ro- บฑฑ
ฑฑบ          ณ tina para criar a SC.                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/  
user Function C4A02GSC(_Par01, _Par02, _lGera)
Private _cProd := _Par01, _nQuant := _Par02

// Verifiva nos parametros se eh pra gerar SC automaticamente.
If _lGera .or. upper(AllTrim(GetMV("MV_AUTOSC"))) == "S"
	C4A02PAR() 
Endif 

Return
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ C4A02PAR   บAutor  ณ Totvs       	   บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Parametros		         		              			  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
Static Function C4A02PAR()

Local _aAreaB1
Private _aPerg, cPerg

_aAreaB1 := SB1->(GetArea())

_aPerg := {}
cPerg := "MT170a    "
aAdd (_aPerg, {cPerg,"01","Produto de         ?","จDe Producto       ?","From Product       ?","mv_ch1","C",15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SB1","",""})
aAdd (_aPerg, {cPerg,"02","Produto at        ?","จA  Producto       ?","To Product         ?","mv_ch2","C",15,0,0,"G","","mv_par02","","","","ZZZZZZZZZZZZZZZ","","","","","","","","","","","","","","","","","","","","","SB1","",""})
aAdd (_aPerg, {cPerg,"03","Grupo de           ?","จDe Grupo          ?","From Group         ?","mv_ch3","C",4,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SBM","",""})
aAdd (_aPerg, {cPerg,"04","Grupo at          ?","จA  Grupo          ?","To Group           ?","mv_ch4","C",4,0,0,"G","","mv_par04","","","","ZZZZ","","","","","","","","","","","","","","","","","","","","","SBM","",""})
aAdd (_aPerg, {cPerg,"05","Tipo de            ?","จDe Tipo           ?","From Type          ?","mv_ch5","C",2,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","02","",""})
aAdd (_aPerg, {cPerg,"06","Tipo at           ?","จA  Tipo           ?","To Type            ?","mv_ch6","C",2,0,0,"G","","mv_par06","","","","ZZ","","","","","","","","","","","","","","","","","","","","","02","",""})
aAdd (_aPerg, {cPerg,"07","Endereco de        ?","จDe Ubicacion      ?","From Address       ?","mv_ch7","C",2,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd (_aPerg, {cPerg,"08","Endereco ate       ?","จA  Ubicacion      ?","To Address         ?","mv_ch8","C",2,0,0,"G","","mv_par08","","","","ZZ","","","","","","","","","","","","","","","","","","","","","","",""})
//aAdd (_aPerg, {cPerg,"09","Cons. Necess. Bruta?","จConsd. Neces.Bruta?","Cons. Gross Necess.?","mv_ch9","N",1,0,1,"C","","mv_par09","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","","",""})
//aAdd (_aPerg, {cPerg,"10","Saldo Neg Considera?","จConsd Saldo Negat.?","Cons.Negat.Balance ?","mv_cha","N",1,0,1,"C","","mv_par10","Saldo","Saldo","Balance","","","Saldo+LE","Saldo+LE","Bal.+Econ.Lot","","","","","","","","","","","","","","","","","","",""})
//aAdd (_aPerg, {cPerg,"11","Data Limite p/ Empe?","จFch. Limite p/Empe?","Deadline to Allocat?","mv_chb","D",8,0,0,"G","","mv_par11","","","","'  /  /  '","","","","","","","","","","","","","","","","","","","","","","",""})
//aAdd (_aPerg, {cPerg,"12","Cons. Qtd. De 3os. ?","จCons.Ctd.de Terc. ?","Cons.Qt.from 3rdPty?","mv_chc","N",1,0,2,"C","","mv_par12","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","","",""})
//aAdd (_aPerg, {cPerg,"13","Cons. Qtd. Em 3os. ?","จCons.Ctd.en Terc. ?","Cons.Qt.in 3rdP.Pos?","mv_chd","N",1,0,2,"C","","mv_par13","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","","",""})
AjustaSX1(_aPerg)  

Pergunte(cPerg, .F.)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis utilizadas para parametros        ณ
//ณ mv_par01     // Produto de                  ณ
//ณ mv_par02     // Produto ate                 ณ
//ณ mv_par03     // Grupo de                    ณ
//ณ mv_par04     // Grupo ate                   ณ
//ณ mv_par05     // Tipo de                     ณ
//ณ mv_par06     // Tipo ate                    ณ
//ณ mv_par07     // Local de                    ณ
//ณ mv_par08     // Local ate                   ณ
//ณ mv_par09     // Considera Necess Bruta 1 simณ  Pto Pedido
//ณ mv_par10     // Saldo Neg Considera    1 simณ  Lot.Economico
//ณ mv_par11     // Data limite p/ empenhos     ณ
//ณ mv_par12     // Cons.Qtd. De 3os.? Sim / Naoณ
//ณ mv_par13     // Cons.Qtd. Em 3os.? Sim / Naoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SG1->(dbSetOrder(1))  // Estrutura dos produtos.
SB1->(dbSetOrder(1))  // Cad. de produtos.
SB1->(dbSeek(xFilial("SB1") + _cProd, .F.))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Filtra grupos e tipos nao selecionados e tambem se eh MOD. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If  !(SB1->B1_GRUPO < mv_par03 .or. SB1->B1_GRUPO > mv_par04) .and.;
	!(SB1->B1_TIPO  < mv_par05 .or. SB1->B1_TIPO  > mv_par06) .and.;
	!(SubStr(SB1->B1_COD, 1, 3) == "MOD" .or. SB1->B1_TIPO == "BN") .and.;
	!(SB1->B1_CONTRAT == "S" .or. SG1->(dbSeek(xFilial("SG1") + SB1->B1_COD)))
	U_C4A02SC1(.T., _nQuant)
Endif

SB1->(RestArea(_aAreaB1))
Return
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ C4A02SC1   บAutor  ณ Totvs       	   บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Gera a solicitacao de compras	              			  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
static Function C4A02SC1(_lGeraSC, _nQuant)
Local cNumSolic, nPrazo, aQtdes := {}
Local nQuant := 0, _nQtdeArre := 0, nSaldo := 0, nNeces := 0, _nSldAux := 0
Local nTamUser, aTamSX3 := {}
Local nEstSeg   := 0
Local nAuxQuant := 0
Local cFornece  := CriaVar("C1_FORNECE")
Local cLoja     := CriaVar("C1_LOJA")
Local aFornepad := {}
aTamSX3  := TamSX3("C1_SOLICIT")
nTamUser := IIf(aTamSX3[1] < 15, aTamSX3[1], 15)
_nQuant  := IIf(ValType(_nQuant) == "N", _nQuant, 0)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Calcula o saldo atual de todos os almoxarifados.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
SB2->(dbSeek(xFilial("SB2") + SB1->B1_COD, .T.))
Do While SB2->(!eof()) .and. SB2->(B2_FILIAL + B2_COD) == xFilial("SB2") + SB1->B1_COD
	If !(SB2->B2_LOCAL < mv_par07 .or. SB2->B2_LOCAL > mv_par08)
		// Formula padrao do sistema para o calculo do saldo atual do produto.
		//nSaldo += (SaldoSB2(,, If(empty(mv_par11), dDataBase, mv_par11), mv_par12 == 1, mv_par13 == 1) + SB2->B2_SALPEDI) - SB2->B2_QPEDVEN
		nSaldo += SB2->B2_QATU
	Endif
	SB2->(dbSkip())
EndDo

// Acrescenta as solicitacoes e os pedidos em aberto ao saldo.
// 1 - Produto
// 2 - Considera as solicitacoes.
// 3 - Considera os pedidos.
nSaldo += C4A02GSD(SB1->B1_COD, .T., .T.)

//nEstSeg := CalcEstSeg(SB1->B1_ESTFOR)
//nSaldo -= nEstSeg
// Considera a quantidade do movimento atual que tambem esta saindo.
nSaldo -= _nQuant

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Essas sao as formula de calculo de necessidade criadas pelo ana- ณ
//ณ lista Felipe Raposo, de acordo com as necessidades do usuario    ณ
//ณ Waldir, todas registradas por atas de reuniao.                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
// Previsao de saldo na data de entrega do produto.
//_nSldAux := nSaldo - SB1->B1_XPEQ //(SB1->B1_PE * U_GetConsMed(SB1->B1_COD)/30)
//_nSldAux := IIf (_nSldAux < 0, 0, _nSldAux)
_nSldAux := IIf (nSaldo < 0, 0, nSaldo)

// Calculo da necessidade.
nNeces := IIf (_nSldAux <= SB1->B1_EMIN, SB1->(B1_LE + B1_EMIN) - _nSldAux, 0)

If nNeces > 0
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica se produto tem estrutura.                        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aQtdes := CalcLote(SB1->B1_COD, nNeces, "C")
	For nX := 1 to Len(aQtdes)
		nQuant += aQtdes[nX]
	Next
Endif
dbSelectArea("SB1")
If ExistBlock("MS170QTD")
	nAuxQuant := Execblock("MS170QTD", .F., .F., nQuant)
	If (ValType(nAuxQuant) == "N"); nQuant := nAuxQuant; Endif
Endif

// Se houver necessidade, cria a SC.
If nQuant > 0
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Pega o prazo de entrega do material         ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	nPrazo := CalcPrazo(SB1->B1_COD, nQuant)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Gera solicitacao de compra                  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cNumSolic := GetNumSC1(.T.)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ PDE para gravacao de fornecedor na solicitacao de compra. ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If ExistBlock("MS170FOR")
		aFornepad := Execblock("MS170FOR", .F., .F.)
		If ValType(aFornepad) == "A"
			cFornece := aFornepad[1]
			cLoja    := aFornepad[2]
		Endif
	Endif
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Arredonda o valor da necessidade, de acordo com os        ณ
	//ณ parametros informados no cad. de produto.                 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	_nQtdeArre := nQuant
	If SB1->B1_XARRED == "1"  // Sim.
		_nFator := 10 ^ SB1->B1_XFATARR   // 10 elevado a potencia contida em B1_XFATARR.
		_nQtdeArre := int(nQuant / _nFator) * _nFator
		_nQtdeArre += IIf(_nQtdeArre == nQuant, 0, _nFator)
	Endif
	
	If _lGeraSC
		Begin Transaction
		RecLock("SC1",.T.)
		SC1->C1_FILIAL  := xFilial("SC1")
		SC1->C1_NUM     := cNumSolic
		SC1->C1_NUMCIEE := cNumSolic		
		SC1->C1_ITEM    := "01"
		SC1->C1_EMISSAO := dDataBase
		SC1->C1_PRODUTO := SB1->B1_COD
		SC1->C1_LOCAL   := SB1->B1_LOCPAD
		SC1->C1_UM      := SB1->B1_UM
		SC1->C1_SEGUM   := SB1->B1_SEGUM
		SC1->C1_DESCRI  := SB1->B1_DESC
		SC1->C1_QUANT   := _nQtdeArre
		SC1->C1_QTDCALC := nQuant  // Campo especifico CIEE.
		SC1->C1_CONTA   := SB1->B1_CONTA
		SC1->C1_CC      := SB1->B1_CC
		SC1->C1_ITEMCTA := SB1->B1_ITEMCC
		SC1->C1_CLVL    := SB1->B1_CLVL
		SC1->C1_QTSEGUM := IIf(SB1->B1_TIPCONV == "M", (nQuant * SB1->B1_CONV), (nQuant /SB1->B1_CONV))
		SC1->C1_SOLICIT := "Demanda" // Substr(cUsuario, 7, nTamUser)
		SC1->C1_DATPRF  := dDataBase + nPrazo
		SC1->C1_OBS     := "Gerado automaticamente por ponto de pedido."
		SC1->C1_IMPORT  := SB1->B1_IMPORT
		SC1->C1_FORNECE := cFornece
		SC1->C1_LOJA    := cLoja
		SC1->C1_ESPEC	:= SB1->B1_XESPEC
		MaAvalSC("SC1",1)
		If __lSX8; ConfirmSX8(); Endif
		If ExistBlock("MT170SC1"); ExecBlock("MT170SC1", .F., .F.); Endif
		// Ponto de entrada que eh executado antes da gravacao de cada
		// item no MATA110 (Sol. de Compras).
		If ExistBlock("MT110GRV"); ExecBlock("MT110GRV", .F., .F.); Endif
		End Transaction
	Endif
Endif     

Return ({_nSldAux, nQuant, _nQtdeArre})
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ C4A02SC1   บAutor  ณ Totvs       	   บ Data ณ01/01/2015 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Calcula a quantidade em pendencia para entrega no almoxa-  บฑฑ
ฑฑบ          ณ rifado pelos fornecedores de acordo com os parametros.     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
static Function C4A02GSD(_cProduto, _lSolicit, _lPedido)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de variaveis.                                            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local _aAreaC1, _aAreaC7, _nRet := 0

// Armazena as condicoes das tabelas
// antes do processamento.
_aAreaC1 := SC1->(GetArea())
_aAreaC7 := SC7->(GetArea())

// Acrescenta as solicitacoes de compra ao saldo,
// caso tenha sido solicitado pelo usuario.
If _lSolicit
	SC1->(dbSetOrder(2))  // C1_FILIAL+C1_PRODUTO+C1_NUM+C1_ITEM+C1_FORNECE+C1_LOJA.
	SC1->(dbSeek(xFilial("SC1") + _cProduto, .F.))
	Do While SC1->(C1_FILIAL + C1_PRODUTO) == xFilial("SC1") + _cProduto
		_nRet += SC1->(C1_QUANT - C1_QUJE)
		SC1->(dbSkip())
	EndDo
Endif

// Acrescenta os pedidos de compra ao saldo,
// caso tenha sido solicitado pelo usuario.
If _lPedido
	SC7->(dbSetOrder(2))  // C7_FILIAL+C7_PRODUTO+C7_FORNECE+C7_LOJA+C7_NUM.
	SC7->(dbSeek(xFilial("SC7") + _cProduto, .F.))
	Do While SC7->(C7_FILIAL + C7_PRODUTO) == xFilial("SC7") + _cProduto
		If SC7->C7_RESIDUO != "S"
			_nRet += SC7->(C7_QUANT - C7_QUJE)
		Endif
		SC7->(dbSkip())
	EndDo
Endif

// Restaura as condicoes das tabelas
// anterioes ao processamento.
SC1->(RestArea(_aAreaC1))
SC7->(RestArea(_aAreaC7))
Return (_nRet)