#Include 'Rwmake.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |MT120LOK  บAutor  ณCristian Werneck    บ Data ณ  15/01/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de entrada para validar a linha digitada da solicita_บฑฑ
ฑฑบ          ณ cao de compras                                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Modulo de Compras                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MT120LOK()

// Sergio em Abr/2007: Atendimento ao chamado 001214 - Incluir o campo C1_CLVL na validacao
Local lContinua := U_VldCTBg( BuscaCols('C7_ITEMCTA'), BuscaCols('C7_CC'), BuscaCols('C7_CLVL'), Nil )
Local Ret := .F.
Local _lEnd := .T.

If	_lEnd
	If Round( GdFieldGet('C7_QUANT') * Round( GdFieldGet('C7_PRECO'), TamSX3("C7_PRECO")[2] ),TamSX3("D1_TOTAL")[2] ) # Round( GdFieldGet('C7_TOTAL'), TamSX3("C7_TOTAL")[2] )
		cTxtBlq := "Valor total invalido. Verifique a quantidade * valor unitแrio!"
		Aviso("Quantidade * Pre็o Unitแrio",cTxtBlq,;
		{"&Fechar"},3,"Valor Total Divergente",,;
		"QMT_NO")
		_lEnd := .F.
	EndIf
EndIf

If lContinua == .T. .And. _lEnd == .T.
	Ret := .T.
EndIf

Return( Ret )
