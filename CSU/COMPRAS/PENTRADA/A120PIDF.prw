#Include 'Rwmake.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A120PIDF  ºAutor  ³ Sergio Oliveira    º Data ³  Abr/2007   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Ponto de entrada no momento da atualização dos Pedidos de  º±±
±±º          ³ Compras. Tem como objetivo filtrar as Solicitações de Com- º±±
±±ºDescricao ³ pras de acordo com o comprador logado. O mecanismo de fil- º±±
±±º          ³ tro consiste em filtrar os grupos de compras relacionados  º±±
±±º          ³ ao comprador. *** FILTRO POR SC INTEIRA ***                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function A120PIDF()

Local cQryDbf := '', cQrySql := ''
Local aGrupo  := {}
Local nCntFor

If nTipoPed == 1 .And. ( MV_PAR03 == 1 .Or. GetMv("MV_RESTCOM")=="S" )
	
	aGrupo := UsrGrComp(RetCodUsr())
	If ( Ascan(aGrupo,"*") == 0 )
		cQryDbf  := " (C1_GRUPCOM=='"+Space( TamSX3("C1_GRUPCOM")[1] )+"'"
		cQrySql  += " (C1_GRUPCOM= '"+Space( TamSX3("C1_GRUPCOM")[1] )+"'"
		For nCntFor := 1 To Len(aGrupo)
			cQryDbf += ".Or.C1_GRUPCOM=='"+aGrupo[nCntFor]+"'"
			cQrySql += " OR C1_GRUPCOM= '"+aGrupo[nCntFor]+"'"
		Next nCntFor
	EndIf
	
EndIf

If nTipoPed == 1
	
	If !Empty( cQryDbf )
		cQryDbf += " ) .And. "
		cQrySql += " ) And "
	EndIf
	
	cQryDbf += " C1_QUANT>C1_QUJE.And.C1_APROV$'L'.And.C1_COTACAO$'      /XXXXXX' .And. "
	cQryDbf += " C1_FILIAL = '"+xFilial('SC1')+"' .And. C1_RESIDUO = ' ' "
	
	cQrySql += " C1_QUANT > C1_QUJE AND C1_APROV = 'L' AND C1_COTACAO IN('      ','XXXXXX') AND "
	cQrySql += " C1_FILIAL = '"+xFilial('SC1')+"' AND C1_RESIDUO = ' '  "
	
EndIf

Return( { cQryDbf, cQrySql } )