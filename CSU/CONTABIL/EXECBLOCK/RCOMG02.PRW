#Include 'Rwmake.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ Rcomg02  ºAutor  ³ Sergio Oliveira    º Data ³  Abr/2009   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Execblock executado no gatilho do campo D1_NATFULL p/ atua-º±±
±±º          ³ lizar o TES de acordo com a condicao de pagamento cadastra-º±±
±±º          ³ da no pedido de compras.                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA103 - Documento de Entrada                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Rcomg02()

Local _aAreaAn 		:= GetArea()
Local _cOperCum 	:= GetMv("MV_XOPRCUM")
Local _cTesNaoCum 	:= Posicione("SED",1,xFilial("SED")+M->D1_NATFULL,"ED_XTESNC")
Local _cTesCum    	:= Posicione("SED",1,xFilial("SED")+M->D1_NATFULL,"ED_XTESC")
Local _cAnt			:= "000" //O.S 3041/15


/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ OS 0176/09: Geracao de TES de acordo com a condicao de pagamento desde que ³
³             a condicao de pagamento esteja amarrada a algum TES.           ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

If AliasInDic("ZA5",.t.) .And. FUNNAME() != "MATA140" //O.S 3041/15
	
	_cAnt := Posicione( 'SB1',1,xFilial('SB1')+BuscaCols("D1_COD"),"B1_TE" )
	
	If Select('ZA5') == 0
		ChkFile('ZA5')
	EndIf
	
	
	If !Empty(_cTesNaoCum) .And. !Empty(_cTesCum)
	
		If Left(GdFieldGet("D1_ITEMCTA"),2) $ _cOperCum
			GdFieldPut( "D1_TES",_cTesCum )
			GdFieldPut( "D1_CF" ,Posicione("SF4",1,xFilial('SF4')+_cTesCum,"F4_CF") )
				
			_cAnt     := _cTesCum
		Else
			GdFieldPut( "D1_TES",_cTesNaoCum )
			GdFieldPut( "D1_CF" ,Posicione("SF4",1,xFilial('SF4')+_cTesNaoCum,"F4_CF") )
				
			_cAnt     := _cTesNaoCum
		EndIf				

	Else

		ZA5->( DbsetOrder(3) )
		SC7->( DbSetOrder(1) )
		If SC7->( DbSeek( xFilial('SC7')+aCols[n][GdFieldPos("D1_PEDIDO")] ) ) .And.;
			ZA5->( DbSeek( xFilial('ZA5')+SC7->C7_COND ) )
			
			If ZA5->( DbSetOrder(4), DbSeek( xFilial('ZA5')+M->D1_NATFULL ) )
				GdFieldPut( "D1_TES",ZA5->ZA5_TES )
				GdFieldPut( "D1_CF" ,Posicione("SF4",1,xFilial('SF4')+ZA5->ZA5_TES,"F4_CF") )
				
				If !Empty(ZA5->ZA5_NATURE)
					GdFieldPut( "D1_NATFULL",ZA5->ZA5_NATURE )
					M->D1_NATFULL := ZA5->ZA5_NATURE
				EndIf
				
				_cAnt     := ZA5->ZA5_TES
			Else
				GdFieldPut( "D1_TES",ZA5->ZA5_TES )
				GdFieldPut( "D1_CF" ,Posicione("SF4",1,xFilial('SF4')+ZA5->ZA5_TES,"F4_CF") )
				
				If !Empty(ZA5->ZA5_NATURE)
					GdFieldPut( "D1_NATFULL",ZA5->ZA5_NATURE )
					M->D1_NATFULL := ZA5->ZA5_NATURE
				EndIf
				
				_cAnt     := ZA5->ZA5_TES
				
			EndIf	
		Else
			If ZA5->( DbSetOrder(4), DbSeek( xFilial('ZA5')+M->D1_NATFULL ) )
				
				GdFieldPut( "D1_TES",ZA5->ZA5_TES )
				GdFieldPut( "D1_CF" ,Posicione("SF4",1,xFilial('SF4')+ZA5->ZA5_TES,"F4_CF") )
				
				_cAnt     := ZA5->ZA5_TES
			EndIf
		EndIf
	EndIf
EndIf

RestArea( _aAreaAn )

Return( _cAnt )