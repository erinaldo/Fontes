#Include 'Rwmake.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A120PIDF  �Autor  � Sergio Oliveira    � Data �  Abr/2007   ���
�������������������������������������������������������������������������͹��
���          � Ponto de entrada no momento da atualiza��o dos Pedidos de  ���
���          � Compras. Tem como objetivo filtrar as Solicita��es de Com- ���
���Descricao � pras de acordo com o comprador logado. O mecanismo de fil- ���
���          � tro consiste em filtrar os grupos de compras relacionados  ���
���          � ao comprador. *** FILTRO POR SC INTEIRA ***                ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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