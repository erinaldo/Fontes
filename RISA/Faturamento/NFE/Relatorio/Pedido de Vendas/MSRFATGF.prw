#INCLUDE "totvs.ch"
#INCLUDE "colors.ch"
#INCLUDE "font.ch"
#INCLUDE "topconn.ch"

/*/{Protheus.doc} MSRFATGF

Rotina responsável pela impressão do relatório gráfico do Pedido de Vendas

@type function
@author Winston Dellano de Castro
@since 27/10/2006

@history 21/06/2016, Carlos Eduardo Niemeyer Rodrigues
/*/
User Function MSRFATGF(lAuto,cNumero)
	Local oClassRelatorioPV	:= ClassRelatorioPV():newClassRelatorioPV()
	Local cTitulo      		:= "Relatório de Pedido de Vendas"
	Local nCount       		:= 0  
	Local cPerg        		:= "PERFAT"
	
	Default lAuto      		:= .F.
	Default cNumero    		:= ""
	
	Private cPedido 		:= ""    
	Private cEmissao   		:= ""
	Private nQtdPag    		:= 0
	Private aTotaIpi   		:= {0,0}                                      // Controle do Valor Total do IPI
	Private nTotaIcm   		:= 0
	Private oFont1     		:= TFont():New("Arial",09,14,   ,.T.,,,,,.F.) // Parametros TFonte ("Tipo Fonte", ,Tamanho Fonte , , ,Italico (.T./.F.))
	Private oFont2     		:= TFont():New("Arial",07,08,   ,.F.,,,,,.F.) // Normal
	Private oFont3     		:= TFont():New("Arial",09,10,.T.,.T.,,,,,.F.) // Negrito
	Private oFont4     		:= TFont():New("Arial",09,14,.T.,.T.,,,,,.T.) // Negrito - Sublinhado
	Private oFont5     		:= TFont():New("Arial",09,10,   ,.F.,,,,,.F.) // Negrito
	Private oPrint     		:= Nil
	
	//Instanciação do Objeto OPrint
	oPrint := TMSPrinter():New()
	
	ValidPerg(cPerg)
	
	If lAuto
		mv_par01 := cNumero
		mv_par02 := cNumero
		mv_par03 := Ctod("01/01/1990")
		mv_par04 := Ctod("31/12/2060")
	Else
		If !(Pergunte(cPerg,.T.))
			Return
		EndIf  
	EndIf
	     
	// Query que retorna os dados do pedido e os dados dos itens.
	cQuery := "SELECT C5_NUM,C5_EMISSAO,C5_CONDPAG,C5_DESC1,C5_DESC2,C5_DESC3,C5_FRETE, " + CRLF
	cQuery += "       C5_DESPESA,C5_DESC4,C5_DATA1,C5_DATA2,C5_DATA3,C5_DATA4,C5_PARC1, " + CRLF
	cQuery += "       C5_PARC2,C6_PEDCLI,C5_PARC3,C5_PARC4,C5_CLIENTE,C5_LOJACLI,       " + CRLF
	cQuery += "       C5_TRANSP,C5_VEND1,C6_ITEM,C6_NUM,C6_PRODUTO,C6_DESCRI,C6_UM,     " + CRLF
	cQuery += "       CONVERT(VARCHAR(8000),											" + CRLF
	cQuery += "       CONVERT(VARBINARY(8000),C5_MENNOTA)) C5_MENNOTA,					" + CRLF
	cQuery += "       C6_TES,C6_QTDVEN,C6_PRCVEN,C6_VALOR,B1_IPI,				 		" + CRLF
	cQuery += "		  CASE WHEN C5_TIPO = 'B' THEN A2_COD		ELSE A1_COD		END COD,	 " + CRLF
	cQuery += "       CASE WHEN C5_TIPO = 'B' THEN A2_NOME		ELSE A1_NOME	END NOME,    " + CRLF
	cQuery += "		  CASE WHEN C5_TIPO = 'B' THEN A2_END		ELSE A1_END		END ENDERECO," + CRLF
	cQuery += "		  CASE WHEN C5_TIPO = 'B' THEN A2_MUN		ELSE A1_MUN 	END MUN,	 " + CRLF
	cQuery += "		  CASE WHEN C5_TIPO = 'B' THEN A2_EST		ELSE A1_EST		END EST,   	 " + CRLF
	cQuery += "		  CASE WHEN C5_TIPO = 'B' THEN A2_DDD		ELSE A1_DDD		END DDD,   	 " + CRLF
	cQuery += "       CASE WHEN C5_TIPO = 'B' THEN A2_EMAIL		ELSE A1_EMAIL	END EMAIL,   " + CRLF
	cQuery += "       CASE WHEN C5_TIPO = 'B' THEN A2_TEL		ELSE A1_TEL 	END TEL,	 " + CRLF
	cQuery += "		  CASE WHEN C5_TIPO = 'B' THEN A2_GRPTRIB 	ELSE A1_GRPTRIB END GRPTRIB, " + CRLF
	cQuery += "		  CASE WHEN C5_TIPO = 'B' THEN A2_TIPO		ELSE A1_TIPO	END TIPO,	 " + CRLF
	cQuery += "		  CASE WHEN C5_TIPO = 'B' THEN A2_FAX		ELSE A1_FAX 	END FAX,	 " + CRLF
	cQuery += "		  CASE WHEN C5_TIPO = 'B' THEN A2_CEP		ELSE A1_CEP		END CEP,	 " + CRLF
	cQuery += "       CASE WHEN C5_TIPO = 'B' THEN A2_CONTATO	ELSE A1_CONTATO	END CONTATO, " + CRLF
	cQuery += "		  CASE WHEN C5_TIPO = 'B' THEN A1_BAIRRO	ELSE A1_BAIRRO	END BAIRRO,	 " + CRLF
	cQuery += "		  CASE WHEN C5_TIPO = 'B' THEN A2_HPAGE		ELSE A1_HPAGE	END HPAGE,	 " + CRLF
	cQuery += "		  CASE WHEN C5_TIPO = 'B' THEN A2_CGC		ELSE A1_CGC 	END CGC,	 " + CRLF
	cQuery += "       CASE WHEN C5_TIPO = 'B' THEN A2_INSCR		ELSE A1_INSCR	END INSCR,	 " + CRLF
	cQuery += "       ISNULL(A3_NOME,'')   A3_NOME,B1_GRTRIB,B1_PICM,                   " + CRLF
	cQuery += "       ISNULL(A4_NOME,'')   A4_NOME,                                     " + CRLF
	cQuery += "       ISNULL(E4_DESCRI,'') E4_DESCRI                                    " + CRLF
	cQuery += "FROM "       + RetSqlName("SC5")+" C5                                    " + CRLF
	cQuery += "INNER JOIN " + RetSqlName("SC6")+" C6                                    " + CRLF
	cQuery += "ON C6_FILIAL = '"+xFilial("SC6")+"' AND                                  " + CRLF
	cQuery += "   C6_NUM    = C5_NUM AND                                                " + CRLF
	cQuery += "   C6.D_E_L_E_T_ = ' '                                                   " + CRLF
	cQuery += "LEFT JOIN "+  RetSqlName("SA1")+" A1                                     " + CRLF
	cQuery += "ON A1_FILIAL = '"+xFilial("SA1")+"' AND                                  " + CRLF
	cQuery += "   A1_COD    = C5_CLIENTE AND                                            " + CRLF
	cQuery += "   A1_LOJA   = C5_LOJACLI AND                                            " + CRLF
	cQuery += "   A1.D_E_L_E_T_ = ' '                                                   " + CRLF
	cQuery += "LEFT JOIN "+  RetSqlName("SA2")+" A2                                     " + CRLF
	cQuery += "ON A2_FILIAL = '"+xFilial("SA2")+"' AND                                  " + CRLF
	cQuery += "   A2_COD    = C5_CLIENTE AND                                            " + CRLF
	cQuery += "   A2_LOJA   = C5_LOJACLI AND                                            " + CRLF
	cQuery += "   A2.D_E_L_E_T_ = ' '                                                   " + CRLF
	cQuery += "INNER JOIN " + RetSqlName("SB1")+" B1                                    " + CRLF
	cQuery += "ON B1_FILIAL = '"+xFilial("SB1")+"' AND                                  " + CRLF
	cQuery += "   B1_COD    = C6_PRODUTO AND                                            " + CRLF
	cQuery += "   B1.D_E_L_E_T_ = ' '                                                   " + CRLF
	cQuery += "LEFT JOIN " +  RetSqlName("SE4")+" E4                                    " + CRLF
	cQuery += "ON E4_FILIAL = '"+xFilial("SE4")+"' AND                                  " + CRLF
	cQuery += "   E4_CODIGO = C5_CONDPAG AND                                            " + CRLF
	cQuery += "   E4.D_E_L_E_T_ = ' '                                                   " + CRLF
	cQuery += "LEFT JOIN " +  RetSqlName("SA3")+" A3                                    " + CRLF
	cQuery += "ON A3_FILIAL = '"+xFilial("SA3")+"' AND                                  " + CRLF
	cQuery += "   A3_COD    = C5_VEND1 AND                                              " + CRLF
	cQuery += "   A3.D_E_L_E_T_ = ' '                                                   " + CRLF
	cQuery += "LEFT JOIN " +  RetSqlName("SA4")+" A4                                    " + CRLF
	cQuery += "ON A4_FILIAL = '"+xFilial("SA4")+"' AND                                  " + CRLF
	cQuery += "   A4_COD    = C5_TRANSP AND                                             " + CRLF
	cQuery += "   A4.D_E_L_E_T_ = ' '                                                   " + CRLF
	cQuery += "WHERE C5_FILIAL = '"+xFilial("SC5")+ "' AND                              " + CRLF
	cQuery += "     C5_NUM     BETWEEN '"+ mv_par01     +"' AND '"+ mv_par02 +"'     AND" + CRLF
	If !Empty(mv_par03) .AND. !Empty(mv_par04)
		cQuery += " C5_EMISSAO BETWEEN '"+Dtos(mv_par03)+"' AND '"+Dtos(mv_par04)+"' AND" + CRLF
	EndIf
	cQuery += "      C5.D_E_L_E_T_ = ' '                                                " + CRLF
	cQuery += "ORDER BY C5_NUM,C6_ITEM                                                  " + CRLF
			
	TCQUERY cQuery NEW ALIAS "QRY"
	
	Count to nCount
	
	QRY->(dbgotop())
	
	If QRY->(Eof())
		MsgSTOP("Não há registros para os parametros informados !!")
		QRY->(dbCloseArea())
		Return
	EndIf
		
	While QRY->(!Eof())
	
		TcSetField("QRY","C5_EMISSAO","D")
	
		cPedido := QRY->C5_NUM
		cEmissao   := QRY->C5_EMISSAO
		aTotaIpi   := {0,0}
		nTotaIcm   := 0
				
		// Query que retorna a Quantidade Total de itens em um pedido
		cQuery := "SELECT COUNT(C6_ITEM) AS TOTAL "
		cQuery += "FROM " + RetSqlName("SC6") + " "
		cQuery += "WHERE C6_NUM = '" + QRY->C5_NUM + "' AND D_E_L_E_T_ = ' ' "
		
		TCQUERY cQuery NEW ALIAS "cCount"
		
		// Atribui a Quantidade Total de itens na Variavel nCount
		nCount := cCount->TOTAL 
		
		// Controla a Quantidade de Paginas no Relatorio
		nQtdPag := Str((cCount->TOTAL / 30)+ 1) 
		nQtdPag := Left(nQtdPag, At(".",nQtdPag)-1)
		
		cCount->(dbCloseArea())
		
		// Inicia uma Nova Pagina para Impressao
		oPrint:StartPage()
		
		// Define o modo de Impressao como Retrato
		oPrint:SetPortrait()  // SetLandscape -> Para definir como modo Paisagem
		
		PrintHeader(cPedido,cEmissao)       // Funcao para impressao do Cabecalho
	    PrintCustomer()	                       // Funcao para impressao dos dados do Cliente
	   	PrintDetail(cPedido,nCount,nQtdPag) // Funcao para impressao dos Detalhes do Produto
				
	Enddo
	
	Define MsDialog oDlg Title "Pedido de Vendas" From 0, 0 To 090, 430 Pixel
	Define Font oBold Name "Arial" Size 0, -13 Bold
	@ 000, 000 Bitmap oBmp ResName "LOGIN" Of oDlg Size 30, 120 NoBorder When .f. Pixel
	@ 003, 040 Say cTitulo Font oBold Pixel
	@ 014, 030 To 016, 400 Label '' Of oDlg  Pixel
	@ 020, 040 Button "Configurar" 	Size 40, 13 Pixel Of oDlg Action oPrint:Setup()
	@ 020, 082 Button "Imprimir"   	Size 40, 13 Pixel Of oDlg Action oPrint:Print()
	@ 020, 124 Button "Visualizar" 	Size 40, 13 Pixel Of oDlg Action oPrint:Preview()
	@ 020, 166 Button "Sair"       	Size 40, 13 Pixel Of oDlg Action oDlg:End()
	Activate MsDialog oDlg Centered

	QRY->(dbCloseArea())

Return

/*
	Impressao do cabecalho do relatorio.
	Informacao: Cabecalho - Dados da Empresa
*/
Static Function PrintHeader(cPedido,cEmissao)
	Local nTopo    := 0  // Controle de Linhas
	Local nInicio  := 0  // Indica a posição da primeira coluna  
	Local cEmail   := AllTrim(GetMV("MV_RELFROM"))
	Local cLogo    := AllTrim(GetMV("ZZ_LOGO"))
	Local cAddress := ""
	Local cCnpj    := ""
	
	// Retorna o tamanho Horizontal e Vertical da pagina.
	nVertSize := oPrint:nVertSize()
	nHorzSize := oPrint:nHorzSize()
	
	// Impressao do cabeçalho do Relatorio.
	// Obs.: O Logo pode ser colocado na pasta System do Protheus, no caso só referencia o nome.
	
	// oPrint:SayBitmap(Coluna, Linha, Caminho, Largura, Altura) 
	oPrint:SayBitmap(nTopo + 50,nInicio + 40,cLogo,410,185)
	dbSelectArea("SM0")
	SM0->(dbseek(cEmPant + cFilant))
	
	cAddress := AllTrim(SM0->M0_ENDENT)+" "+AllTrim(SM0->M0_CIDENT)+"/"+AllTrim(SM0->M0_ESTENT)+" "+Left(AllTrim(SM0->M0_CEPENT),5) + "-" + Right(AllTrim(SM0->M0_CEPENT),3)
	cCnpj    := "CNPJ: " + AllTrim(Transform(SM0->M0_CGC, "@R 99.999.999/9999-99")) + " - IE: " +  AllTrim(Transform(SM0->M0_INSC, "@R 999.999.999.999"))
	
	// oPrint:Say(Coluna, Linha, Texto, Fonte, Num de Caracteres, , ,Alinhamento - 0=Left, 1=Right e 2=Center)
	oPrint:Say(nTopo + 0050,nInicio + 2360,AllTrim(SM0->M0_NOMECOM)       ,oFont1,100,,,1)
	oPrint:Say(nTopo + 0100,nInicio + 2360,cAddress                       ,oFont5,100,,,1)
	oPrint:Say(nTopo + 0150,nInicio + 2360,"E-mail: " + AllTrim(cEmail)   ,oFont3,100,,,1)
	oPrint:Say(nTopo + 0200,nInicio + 2360,"Fone: " + AllTrim(SM0->M0_TEL),oFont5,100,,,1)
	oPrint:Say(nTopo + 0250,nInicio + 2360,cCnpj                          ,oFont5,100,,,1)
	
	// oPrint:Line(Coluna, Linha, Coluna, Linha)
	oPrint:Line(nTopo + 0310,nInicio + 0040,nTopo + 0310,nInicio + 2360)
	oPrint:Line(nTopo + 0313,nInicio + 0040,nTopo + 0313,nInicio + 2360)
	oPrint:Line(nTopo + 0410,nInicio + 0040,nTopo + 0410,nInicio + 2360)
	oPrint:Line(nTopo + 0413,nInicio + 0040,nTopo + 0413,nInicio + 2360)
	
	oPrint:Say(nTopo + 0335,nInicio + 0040,"Pedido N° " + cPedido,oFont1,100,,,0)
	oPrint:Say(nTopo + 0335,nInicio + 2360,"Data: " + Dtoc(cEmissao)   ,oFont1,100,,,1)
	
Return
	
/*
	Impressao dos Dados do Cliente
	Informacoes: Nome, E-mail, Endereco, Cidade, CEP, Tel, FAX,Contato e Bairro.
*/
Static Function PrintCustomer()
	Local nTopo        := 0  // Controle de Linhas
	Local nInicio      := 0  // Indica a posicao da primeira coluna
	Local cPhoneNumber := ""
	Local cZipCode     := ""
	Local cFaxNumber   := ""
	
	// Impressão da Estrutura dos Dados do Cliente
	
	// Texto a Esquerda
	oPrint:Say(nTopo + 0430,nInicio + 0040,"Cliente" ,oFont3,100,,,0)
	oPrint:Say(nTopo + 0480,nInicio + 0040,"E-mail"  ,oFont3,100,,,0)
	oPrint:Say(nTopo + 0530,nInicio + 0040,"Endereço",oFont3,100,,,0)
	oPrint:Say(nTopo + 0580,nInicio + 0040,"Cidade"  ,oFont3,100,,,0)
	oPrint:Say(nTopo + 0630,nInicio + 0040,"TEL"     ,oFont3,100,,,0)
	If Len(AllTrim(QRY->CGC)) > 11 
		oPrint:Say(nTopo + 0680,nInicio + 0040,"CNPJ",oFont3,100,,,0)
	Else
		oPrint:Say(nTopo + 0680,nInicio + 0040,"CPF" ,oFont3,100,,,0)
	EndIf
	
	// Texto Centralizado
//	oPrint:Say(nTopo + 0430	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Site"    ,oFont3,100,,,0)
	oPrint:Say(nTopo + 0480	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Contato" ,oFont3,100,,,0)
	oPrint:Say(nTopo + 0530	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Bairro"  ,oFont3,100,,,0)
	oPrint:Say(nTopo + 0580	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"CEP"     ,oFont3,100,,,0)
//	oPrint:Say(nTopo + 0630	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"FAX"     ,oFont3,100,,,0)
	oPrint:Say(nTopo + 0630	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"I.E."    ,oFont3,100,,,0)
	  
    // Texto a Esquerda
    cPhoneNumber := ": (" + QRY->DDD + ") " + Left(QRY->TEL,4) + "-" + Substr(QRY->TEL,5,8)
    
	oPrint:Say(nTopo + 0430,nInicio + 0190,": " + QRY->COD + " - " + QRY->NOME  ,oFont5,100,,,0)
	oPrint:Say(nTopo + 0480,nInicio + 0190,": " + QRY->EMAIL                    ,oFont5,100,,,0)
	oPrint:Say(nTopo + 0530,nInicio + 0190,": " + QRY->ENDERECO                  ,oFont5,100,,,0)
	oPrint:Say(nTopo + 0580,nInicio + 0190,": " + AllTrim(QRY->MUN)+"/"+QRY->EST,oFont5,100,,,0)
	oPrint:Say(nTopo + 0630,nInicio + 0190,cPhoneNumber                          ,oFont5,100,,,0)

	If Len(AllTrim(QRY->CGC)) > 11  
		oPrint:Say(nTopo + 0680,nInicio + 0190,": " + AllTrim(Transform(QRY->CGC,"@R 99.999.999/9999-99")),oFont5,100,,,0)
	Else	
		oPrint:Say(nTopo + 0680,nInicio + 0190,": " + AllTrim(Transform(QRY->CGC,"@R 999.999.999-99"))    ,oFont5,100,,,0)
	EndIf
	
	// Texto Centralizado
	cZipCode   := ": " + Left(QRY->CEP,5) + "-" + Right(QRY->CEP,3)
	cFaxNumber := ": (" + QRY->DDD + ") " + Left(QRY->FAX,4) + "-" + Substr(QRY->FAX,5,8)
	
//	oPrint:Say(nTopo + 0430	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150,": " + QRY->HPAGE  ,oFont5,100,,,0)
	oPrint:Say(nTopo + 0480	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150,": " + QRY->CONTATO,oFont5,100,,,0)
	oPrint:Say(nTopo + 0530	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150,": " + QRY->BAIRRO ,oFont5,100,,,0)
	oPrint:Say(nTopo + 0580	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150,cZipCode              ,oFont5,100,,,0)
//	oPrint:Say(nTopo + 0630	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150,cFaxNumber            ,oFont5,100,,,0)

	If Len(AllTrim(QRY->INSCR)) > 6
		oPrint:Say(nTopo + 0630	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150,": " + AllTrim(Transform(QRY->INSCR,"@R 999.999.999.999")),oFont5,100,,,0)
	Else
		oPrint:Say(nTopo + 0630	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150,": " + AllTrim(QRY->INSCR),oFont5,100,,,0)
	EndIf
	
Return
	
/*
	Impressao dos Dados de Detalhes dos Produtos.
	Parametros: cPedido - Numero do Pedido de Venda Corrente.
				nCount     - Quantidade Total de Itens.
*/
Static Function PrintDetail(cPedido,nCount,nQtdPag)
	Local nTopo    := 750 // Controle de Linhas
	Local nInicio  := 0   // Indica a posição da primeira coluna
	Local nTotal   := 0   // Controle do Valor Total do Pedido 
	Local nTotal2  := 0   // Controle do Valor Total do Pedido 
	Local nFrete   := 0   // Controle do Valor Total do Pedido 
	Local nDespesa := 0   // Controle do Valor Total do Pedido
	Local nPage    := 1
	Local nCont    := 1
	Local nCon     := 0 
	Local nContP   := 0 
	Local nTamDes  := 0
	Local nTamStr  := 0
	Local cPrcVen  := ""
    Local cValor   := ""
	
	Private nTpag  := 0

	// Box, Linhas Verticais e Dados do Cabecalho de Pedido.
	// Box
	oPrint:Box(nTopo,nInicio + 0040, nTopo + 0050,nInicio + 2360)
	
	// Linhas Verticais
	oPrint:Line(nTopo,nInicio + 0120,nTopo + 0050,nInicio + 0120) //180
	oPrint:Line(nTopo,nInicio + 0440,nTopo + 0050,nInicio + 0440) //580
	oPrint:Line(nTopo,nInicio + 1190,nTopo + 0050,nInicio + 1190) //1330
	oPrint:Line(nTopo,nInicio + 1270,nTopo + 0050,nInicio + 1270) //1440
	oPrint:Line(nTopo,nInicio + 1430,nTopo + 0050,nInicio + 1430) //1600
	oPrint:Line(nTopo,nInicio + 1730,nTopo + 0050,nInicio + 1730) //1900
	oPrint:Line(nTopo,nInicio + 2030,nTopo + 0050,nInicio + 2030) //2200
	oPrint:Line(nTopo,nInicio + 2200,nTopo + 0050,nInicio + 2200)
	
	// Texto
	oPrint:Say(nTopo + 0007,nInicio + 0050,"Item"     ,oFont3,100,,,0) //60
	oPrint:Say(nTopo + 0007,nInicio + 0140,"Produto"  ,oFont3,100,,,0) //200
	oPrint:Say(nTopo + 0007,nInicio + 0460,"Descrição",oFont3,100,,,0) //600
	oPrint:Say(nTopo + 0007,nInicio + 1210,"UM"       ,oFont3,100,,,0) //1350
	oPrint:Say(nTopo + 0007,nInicio + 1290,"Qtd."     ,oFont3,100,,,0) //1460
	oPrint:Say(nTopo + 0007,nInicio + 1450,"Preço R$" ,oFont3,100,,,0) //1620
	oPrint:Say(nTopo + 0007,nInicio + 1750,"Total R$" ,oFont3,100,,,0) //1920
	oPrint:Say(nTopo + 0007,nInicio + 2050,"% ICMS"   ,oFont3,100,,,0)
	oPrint:Say(nTopo + 0007,nInicio + 2220,"% IPI"    ,oFont3,100,,,0)
			
	While QRY->(!Eof()) .AND. QRY->C5_NUM == cPedido
		
		// Testa se o limite da pagina para a impressao dos produtos.
		// Caso ultrapasse o limite gera uma Nova Pagina
		If (nTopo + 0130) >= 2550
			
			// Linhas Horizontais  -  FIM Pedido
			oPrint:Line(nTopo + 0040,nInicio + 0040,nTopo + 0040,nInicio + 2360)
		
			PrintTrailer(nPage,nTotal,nTopo)
			
			// Inicia uma Nova Pagina para Impressao
			oPrint:StartPage()
			
			// Define o modo de Impressão como Retrato
			oPrint:SetPortrait()   // SetLandscape -> Para definir como modo Paisagem
			
			// Funcao para impressao do Cabecalho
			PrintHeader(cPedido,cEmissao)
			
			// Incrementa o contador de Paginas
			nPage := nPage + 1
			nTopo := 450
			
   			// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			// ³ Box, Linhas Verticais e Dados do Cabecalho de Pedido.                                        ³
			// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			// Box
			oPrint:Box(nTopo,nInicio + 0040, nTopo + 0050,nInicio + 2360)
			
			// Linhas Verticais
			oPrint:Line(nTopo,nInicio + 0120,nTopo + 0050,nInicio + 0120) //180
			oPrint:Line(nTopo,nInicio + 0440,nTopo + 0050,nInicio + 0440) //580
			oPrint:Line(nTopo,nInicio + 1190,nTopo + 0050,nInicio + 1190) //1330
			oPrint:Line(nTopo,nInicio + 1270,nTopo + 0050,nInicio + 1270) //1440
			oPrint:Line(nTopo,nInicio + 1430,nTopo + 0050,nInicio + 1430) //1600
			oPrint:Line(nTopo,nInicio + 1730,nTopo + 0050,nInicio + 1730) //1900
			oPrint:Line(nTopo,nInicio + 2030,nTopo + 0050,nInicio + 2030)
			oPrint:Line(nTopo,nInicio + 2200,nTopo + 0050,nInicio + 2200)
			
			// Texto
			oPrint:Say(nTopo + 0007,nInicio + 0050,"Item"     ,oFont3,100,,,0) //60
			oPrint:Say(nTopo + 0007,nInicio + 0140,"Produto"  ,oFont3,100,,,0) //200
			oPrint:Say(nTopo + 0007,nInicio + 0460,"Descrição",oFont3,100,,,0) //600
			oPrint:Say(nTopo + 0007,nInicio + 1350,"UM"       ,oFont3,100,,,0)
			oPrint:Say(nTopo + 0007,nInicio + 1290,"Qtd."     ,oFont3,100,,,0) //1460
			oPrint:Say(nTopo + 0007,nInicio + 1450,"Preço R$" ,oFont3,100,,,0)
			oPrint:Say(nTopo + 0007,nInicio + 1750,"Total R$" ,oFont3,100,,,0)
			oPrint:Say(nTopo + 0007,nInicio + 2050,"% ICMS"   ,oFont3,100,,,0)
			oPrint:Say(nTopo + 0007,nInicio + 2220,"% IPI"    ,oFont3,100,,,0)
			
		EndIf

		// Box, Linhas Verticais, Linhas Horizontais e Dados do Pedido.
		
		nTamDes := Len(AllTrim(QRY->C6_DESCRI)) / 30
		
		If nTamDes > 2       
			// Linhas Verticais - Divisao Colunas
			oPrint:Line(nTopo + 0030,nInicio + 0040,nTopo + 0090,nInicio + 0040)
			oPrint:Line(nTopo + 0030,nInicio + 0120,nTopo + 0090,nInicio + 0120) //180
			oPrint:Line(nTopo + 0030,nInicio + 0440,nTopo + 0090,nInicio + 0440) //580
			oPrint:Line(nTopo + 0030,nInicio + 1190,nTopo + 0090,nInicio + 1190) //1330
			oPrint:Line(nTopo + 0030,nInicio + 1270,nTopo + 0090,nInicio + 1270) //1440
			oPrint:Line(nTopo + 0030,nInicio + 1430,nTopo + 0090,nInicio + 1430) //1600
			oPrint:Line(nTopo + 0030,nInicio + 1730,nTopo + 0090,nInicio + 1730) //1900
			oPrint:Line(nTopo + 0030,nInicio + 2030,nTopo + 0090,nInicio + 2030)
			oPrint:Line(nTopo + 0030,nInicio + 2200,nTopo + 0090,nInicio + 2200)
			oPrint:Line(nTopo + 0030,nInicio + 2360,nTopo + 0090,nInicio + 2360)
			
			// Impressao dos Campos dos Detalhes dos Produtos
			cPrcVen := AllTrim(Transform(QRY->C6_PRCVEN,PesqPict("SC6","C6_PRCVEN")))
			cValor  := AllTrim(Transform(QRY->C6_VALOR ,PesqPict("SC6","C6_VALOR")))
			
			oPrint:Say(nTopo + 0057,nInicio + 0050,AllTrim(QRY->C6_ITEM)               ,oFont2,100,,,0) //60
			oPrint:Say(nTopo + 0057,nInicio + 0140,AllTrim(QRY->C6_PRODUTO)            ,oFont2,100,,,0) //200
			oPrint:Say(nTopo + 0057,nInicio + 0460,Substr(AllTrim(QRY->C6_DESCRI),1,30),oFont2,100,,,0) //600
			oPrint:Say(nTopo + 0057,nInicio + 1210,AllTrim(QRY->C6_UM)                 ,oFont2,100,,,0) //1350
			oPrint:Say(nTopo + 0057,nInicio + 1410,AllTrim(Str(QRY->C6_QTDVEN))        ,oFont2,100,,,1) //1580
			oPrint:Say(nTopo + 0057,nInicio + 1720,cPrcVen                             ,oFont2,100,,,1)
			oPrint:Say(nTopo + 0057,nInicio + 2020,cValor                              ,oFont2,100,,,1)
			oPrint:Say(nTopo + 0057,nInicio + 2190,getIcmValue(1)                      ,oFont2,100,,,1)
			oPrint:Say(nTopo + 0057,nInicio + 2340,getIpiValue(1)                      ,oFont2,100,,,1)
			
			getIcmValue(2)
			getIpiValue(2)

			nTamStr := 31
				
			For nCon := 2 to Int(nTamDes) + 1			
				nTopo := nTopo + 50 
				
				// Testa se o limite da pagina para a impressao dos produtos.
				// Caso ultrapasse o limite gera uma Nova Pagina
				If (nTopo + 0130) >= 2550
					
					// Linhas Horizontais  -  FIM Pedido
					oPrint:Line(nTopo + 0040,nInicio + 0040,nTopo + 0040,nInicio + 2360)
				
					PrintTrailer(nPage,nTotal,nTopo)
					
					// Inicia uma Nova Pagina para Impressao
					oPrint:StartPage()
					
					// Define o modo de Impressão como Retrato
					oPrint:SetPortrait()   // SetLandscape -> Para definir como modo Paisagem
					
					// Funcao para impressao do Cabecalho
					PrintHeader(cPedido,cEmissao)
					
					// Incrementa o contador de Paginas
					nPage := nPage + 1										
					nTopo := 450
					
					// Box, Linhas Verticais e Dados do Cabecalho de Pedido.
					// Box
					oPrint:Box(nTopo,nInicio + 0040, nTopo + 0050,nInicio + 2360)
					
					// Linhas Verticais
					oPrint:Line(nTopo,nInicio + 0120,nTopo + 0050,nInicio + 0120) //180
					oPrint:Line(nTopo,nInicio + 0440,nTopo + 0050,nInicio + 0440) //580
					oPrint:Line(nTopo,nInicio + 1190,nTopo + 0050,nInicio + 1190) //1330
					oPrint:Line(nTopo,nInicio + 1270,nTopo + 0050,nInicio + 1270) //1440
					oPrint:Line(nTopo,nInicio + 1430,nTopo + 0050,nInicio + 1430) //1600
					oPrint:Line(nTopo,nInicio + 1730,nTopo + 0050,nInicio + 1730) //1900
					oPrint:Line(nTopo,nInicio + 2030,nTopo + 0050,nInicio + 2030)
					oPrint:Line(nTopo,nInicio + 2200,nTopo + 0050,nInicio + 2200)
					
					// Texto
					oPrint:Say(nTopo + 0007,nInicio + 0050,"Item"     ,oFont3,100,,,0) //60
					oPrint:Say(nTopo + 0007,nInicio + 0140,"Produto"  ,oFont3,100,,,0) //200
					oPrint:Say(nTopo + 0007,nInicio + 0460,"Descrição",oFont3,100,,,0) //600
					oPrint:Say(nTopo + 0007,nInicio + 1350,"UM"       ,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 1290,"Qtd."     ,oFont3,100,,,0) //1460
					oPrint:Say(nTopo + 0007,nInicio + 1450,"Preço R$" ,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 1750,"Total R$" ,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 2050,"% ICMS"   ,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 2220,"% IPI"    ,oFont3,100,,,0)
					
				EndIf      
				
				// Linhas Verticais - Divisao Colunas
				oPrint:Line(nTopo + 0030,nInicio + 0040,nTopo + 0090,nInicio + 0040)				
				oPrint:Line(nTopo + 0030,nInicio + 0120,nTopo + 0090,nInicio + 0120) //180
				oPrint:Line(nTopo + 0030,nInicio + 0440,nTopo + 0090,nInicio + 0440) //580
				oPrint:Line(nTopo + 0030,nInicio + 1190,nTopo + 0090,nInicio + 1190) //1330
				oPrint:Line(nTopo + 0030,nInicio + 1270,nTopo + 0090,nInicio + 1270) //1440
				oPrint:Line(nTopo + 0030,nInicio + 1430,nTopo + 0090,nInicio + 1430) //1600
				oPrint:Line(nTopo + 0030,nInicio + 1730,nTopo + 0090,nInicio + 1730) //1900
				oPrint:Line(nTopo + 0030,nInicio + 2030,nTopo + 0090,nInicio + 2030)
				oPrint:Line(nTopo + 0030,nInicio + 2200,nTopo + 0090,nInicio + 2200)
				oPrint:Line(nTopo + 0030,nInicio + 2360,nTopo + 0090,nInicio + 2360)   
				
				oPrint:Say(nTopo + 0057,nInicio + 0460, Substr(AllTrim(QRY->C6_DESCRI),nTamStr,30),oFont2,100,,,0) //600
			    
			 	nTamStr := nTamStr + 30				
			Next 			
		Else		
			// Linhas Verticais - Divisao Colunas
			oPrint:Line(nTopo + 0030,nInicio + 0040,nTopo + 0090,nInicio + 0040)			
			oPrint:Line(nTopo + 0030,nInicio + 0120,nTopo + 0090,nInicio + 0120) //180
			oPrint:Line(nTopo + 0030,nInicio + 0440,nTopo + 0090,nInicio + 0440) //580
			oPrint:Line(nTopo + 0030,nInicio + 1190,nTopo + 0090,nInicio + 1190) //1330
			oPrint:Line(nTopo + 0030,nInicio + 1270,nTopo + 0090,nInicio + 1270) //1440
			oPrint:Line(nTopo + 0030,nInicio + 1430,nTopo + 0090,nInicio + 1430) //1600
			oPrint:Line(nTopo + 0030,nInicio + 1730,nTopo + 0090,nInicio + 1730) //1900
			oPrint:Line(nTopo + 0030,nInicio + 2030,nTopo + 0090,nInicio + 2030)
			oPrint:Line(nTopo + 0030,nInicio + 2200,nTopo + 0090,nInicio + 2200)
			oPrint:Line(nTopo + 0030,nInicio + 2360,nTopo + 0090,nInicio + 2360)
			
			// Impressao dos Campos dos Detalhes dos Produtos
			cPrcVen := AllTrim(Transform(QRY->C6_PRCVEN,PesqPict("SC6","C6_PRCVEN")))
			cValor  := AllTrim(Transform(QRY->C6_VALOR ,PesqPict("SC6","C6_VALOR")))
			
			oPrint:Say(nTopo + 0057,nInicio + 0050,AllTrim(QRY->C6_ITEM)       ,oFont2,100,,,0)
			oPrint:Say(nTopo + 0057,nInicio + 0140,AllTrim(QRY->C6_PRODUTO)    ,oFont2,100,,,0)
			oPrint:Say(nTopo + 0057,nInicio + 0460,AllTrim(QRY->C6_DESCRI)     ,oFont2,100,,,0) //600
			oPrint:Say(nTopo + 0057,nInicio + 1210,AllTrim(QRY->C6_UM)         ,oFont2,100,,,0) //1350
			oPrint:Say(nTopo + 0057,nInicio + 1410,AllTrim(Str(QRY->C6_QTDVEN)),oFont2,100,,,1) //1580
			oPrint:Say(nTopo + 0057,nInicio + 1720,cPrcVen                     ,oFont2,100,,,1)
			oPrint:Say(nTopo + 0057,nInicio + 2020,cValor                      ,oFont2,100,,,1)
			oPrint:Say(nTopo + 0057,nInicio + 2190,getIcmValue(1)              ,oFont2,100,,,1)
			oPrint:Say(nTopo + 0057,nInicio + 2340,getIpiValue(1)              ,oFont2,100,,,1)
			
			getIcmValue(2)
			getIpiValue(2)
		EndIf
		
		// Calculo do Valor Total do Pedido de Venda
		nTotal += QRY->C6_VALOR 				
		nTopo  := nTopo + 0050
		
		// Impressão da Observação do Pedido		
//		nTamDes := Len(AllTrim(QRY->C6_OBS)) / 30
		
		If nTamDes > 2  
			// Testa se o limite da pagina para a impressao dos produtos.
			// Caso ultrapasse o limite gera uma Nova Pagina
			If (nTopo + 0130) >= 2550
						
				// Linhas Horizontais  -  FIM Pedido
				oPrint:Line(nTopo + 0040,nInicio + 0040,nTopo + 0040,nInicio + 2360)
				
				PrintTrailer(nPage,nTotal,nTopo)
				
				// Inicia uma Nova Pagina para Impressao
				oPrint:StartPage()
				
				// Define o modo de Impressão como Retrato
				oPrint:SetPortrait()   // SetLandscape -> Para definir como modo Paisagem
				
				// Funcao para impressao do Cabecalho
				PrintHeader(cPedido,cEmissao)
				
				// Incrementa o contador de Paginas
				nPage := nPage + 1									
				nTopo := 450

				// ³ Box, Linhas Verticais e Dados do Cabecalho de Pedido.
				// Box
				oPrint:Box(nTopo,nInicio + 0040, nTopo + 0050,nInicio + 2360)
				
				// Linhas Verticais
				oPrint:Line(nTopo,nInicio + 0120,nTopo + 0050,nInicio + 0120) //180
				oPrint:Line(nTopo,nInicio + 0440,nTopo + 0050,nInicio + 0440) //580
				oPrint:Line(nTopo,nInicio + 1190,nTopo + 0050,nInicio + 1190) //1330
				oPrint:Line(nTopo,nInicio + 1270,nTopo + 0050,nInicio + 1270) //1440
				oPrint:Line(nTopo,nInicio + 1430,nTopo + 0050,nInicio + 1430) //1600
				oPrint:Line(nTopo,nInicio + 1730,nTopo + 0050,nInicio + 1730) //1900
				oPrint:Line(nTopo,nInicio + 2030,nTopo + 0050,nInicio + 2030)
				oPrint:Line(nTopo,nInicio + 2200,nTopo + 0050,nInicio + 2200)
				
				// Texto
				oPrint:Say(nTopo + 0007,nInicio + 0050,"Item"     ,oFont3,100,,,0) //60
				oPrint:Say(nTopo + 0007,nInicio + 0140,"Produto"  ,oFont3,100,,,0) //200
				oPrint:Say(nTopo + 0007,nInicio + 0460,"Descrição",oFont3,100,,,0) //600
				oPrint:Say(nTopo + 0007,nInicio + 1350,"UM"       ,oFont3,100,,,0)
				oPrint:Say(nTopo + 0007,nInicio + 1290,"Qtd."     ,oFont3,100,,,0) //1460
				oPrint:Say(nTopo + 0007,nInicio + 1450,"Preço R$" ,oFont3,100,,,0)
				oPrint:Say(nTopo + 0007,nInicio + 1750,"Total R$" ,oFont3,100,,,0)
				oPrint:Say(nTopo + 0007,nInicio + 2050,"% ICMS"   ,oFont3,100,,,0)
				oPrint:Say(nTopo + 0007,nInicio + 2220,"% IPI"    ,oFont3,100,,,0)
			EndIf   
		       	// Linhas Verticais - Divisao Colunas
				oPrint:Line(nTopo + 0030,nInicio + 0040,nTopo + 0090,nInicio + 0040)				
				oPrint:Line(nTopo + 0030,nInicio + 0120,nTopo + 0090,nInicio + 0120) //180
				oPrint:Line(nTopo + 0030,nInicio + 0440,nTopo + 0090,nInicio + 0440) //580
				oPrint:Line(nTopo + 0030,nInicio + 1190,nTopo + 0090,nInicio + 1190) //1330
				oPrint:Line(nTopo + 0030,nInicio + 1270,nTopo + 0090,nInicio + 1270) //1440
				oPrint:Line(nTopo + 0030,nInicio + 1430,nTopo + 0090,nInicio + 1430) //1600
				oPrint:Line(nTopo + 0030,nInicio + 1730,nTopo + 0090,nInicio + 1730) //1900
				oPrint:Line(nTopo + 0030,nInicio + 2030,nTopo + 0090,nInicio + 2030)
				oPrint:Line(nTopo + 0030,nInicio + 2200,nTopo + 0090,nInicio + 2200)
				oPrint:Line(nTopo + 0030,nInicio + 2360,nTopo + 0090,nInicio + 2360)
				
				// Impressao dos Campos dos Detalhes dos Produtos
//				oPrint:Say(nTopo + 0057,nInicio + 0600, Substr(AllTrim(QRY->C6_OBS),1,30),oFont2,100,,,0)
					
				nTamStr := 31
				
			For nCon := 2 to Int(nTamDes) + 1  
			
				nTopo := nTopo + 0050 

				// Testa se o limite da pagina para a impressao dos produtos.
				// Caso ultrapasse o limite gera uma Nova Pagina
				If (nTopo + 0130) >= 2550
					
					// Linhas Horizontais  -  FIM Pedido
					oPrint:Line(nTopo + 0040,nInicio + 0040,nTopo + 0040,nInicio + 2360)
				
					PrintTrailer(nPage,nTotal,nTopo)
					
					// Inicia uma Nova Pagina para Impressao
					oPrint:StartPage()
					
					// Define o modo de Impressão como Retrato
					oPrint:SetPortrait()   // SetLandscape -> Para definir como modo Paisagem
					
					// Funcao para impressao do Cabecalho
					PrintHeader(cPedido,cEmissao)
					
					// Incrementa o contador de Paginas
					nPage := nPage + 1										
					nTopo := 450
					
					// Box, Linhas Verticais e Dados do Cabecalho de Pedido.
					// Box
					oPrint:Box(nTopo,nInicio + 0040, nTopo + 0050,nInicio + 2360)
					
					// Linhas Verticais
					oPrint:Line(nTopo,nInicio + 0120,nTopo + 0050,nInicio + 0120) //180
					oPrint:Line(nTopo,nInicio + 0440,nTopo + 0050,nInicio + 0440) //580
					oPrint:Line(nTopo,nInicio + 1190,nTopo + 0050,nInicio + 1190) //1330
					oPrint:Line(nTopo,nInicio + 1270,nTopo + 0050,nInicio + 1270) //1440
					oPrint:Line(nTopo,nInicio + 1430,nTopo + 0050,nInicio + 1430) //1600
					oPrint:Line(nTopo,nInicio + 1730,nTopo + 0050,nInicio + 1730) //1900
					oPrint:Line(nTopo,nInicio + 2030,nTopo + 0050,nInicio + 2030)
					oPrint:Line(nTopo,nInicio + 2200,nTopo + 0050,nInicio + 2200)
					
					// Texto
					oPrint:Say(nTopo + 0007,nInicio + 0050,"Item"     ,oFont3,100,,,0) //60
					oPrint:Say(nTopo + 0007,nInicio + 0140,"Produto"  ,oFont3,100,,,0) //200
					oPrint:Say(nTopo + 0007,nInicio + 0460,"Descrição",oFont3,100,,,0) //600
					oPrint:Say(nTopo + 0007,nInicio + 1350,"UM"       ,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 1290,"Qtd."     ,oFont3,100,,,0) //1460
					oPrint:Say(nTopo + 0007,nInicio + 1450,"Preço R$" ,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 1750,"Total R$" ,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 2050,"% ICMS"   ,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 2220,"% IPI"    ,oFont3,100,,,0)
				EndIf
				
				// Linhas Verticais - Divisao Colunas
				oPrint:Line(nTopo + 0030,nInicio + 0040,nTopo + 0090,nInicio + 0040)				
				oPrint:Line(nTopo + 0030,nInicio + 0120,nTopo + 0090,nInicio + 0120) //180
				oPrint:Line(nTopo + 0030,nInicio + 0440,nTopo + 0090,nInicio + 0440) //580
				oPrint:Line(nTopo + 0030,nInicio + 1190,nTopo + 0090,nInicio + 1190) //1330
				oPrint:Line(nTopo + 0030,nInicio + 1270,nTopo + 0090,nInicio + 1270) //1440
				oPrint:Line(nTopo + 0030,nInicio + 1430,nTopo + 0090,nInicio + 1430) //1600
				oPrint:Line(nTopo + 0030,nInicio + 1730,nTopo + 0090,nInicio + 1730) //1900
				oPrint:Line(nTopo + 0030,nInicio + 2030,nTopo + 0090,nInicio + 2030)
				oPrint:Line(nTopo + 0030,nInicio + 2200,nTopo + 0090,nInicio + 2200)
				oPrint:Line(nTopo + 0030,nInicio + 2360,nTopo + 0090,nInicio + 2360)   
				
//				oPrint:Say(nTopo + 0057,nInicio + 0600, Substr(AllTrim(QRY->C6_OBS),nTamStr,30)		,oFont2,100,,,0)
			    
			 	nTamStr := nTamStr + 30				
			Next			
			nTopo := nTopo + 0050			
		EndIf 		
		
		// Incrementa Contador da Quantidade de Itens no Pedido de Venda
		nCont ++
		
		// Se o arquivo chegou ao fim, imprime rodape.
		If nCont > nCount
		
			nTotal := nTotal + QRY->C5_FRETE + QRY->C5_DESPESA
			
			// Box e Dados - Valor Total
			oPrint:Box(nTopo  + 0060,nInicio + 1600,nTopo + 0110,nInicio + 2200)
			oPrint:Line(nTopo + 0060,nInicio + 1900,nTopo + 0110,nInicio + 1900) 
			
			oPrint:Say(nTopo + 0067,nInicio + 1620,"Valor Produtos",oFont3,100,,,0)
			oPrint:Say(nTopo + 0067,nInicio + 2190," " + AllTrim(Transform(nTotal,PesqPict("SC6","C6_VALOR"))),oFont3,100,,,1)
			
			// Box e Dados - Valor Total
			oPrint:Box(nTopo  + 0060,nInicio + 0580,nTopo + 0160,nInicio + 1330)
			oPrint:Line(nTopo + 0060,nInicio + 0955,nTopo + 0160,nInicio + 0955) 
			
			oPrint:Line(nTopo + 0110,nInicio + 0580,nTopo + 0110,nInicio + 1330) 
			
			oPrint:Say(nTopo + 0067,nInicio + 0600,"Valor Frete",oFont3,100,,,0)
			oPrint:Say(nTopo + 0067,nInicio + 1310," " + AllTrim(Transform(QRY->C5_FRETE,PesqPict("SC5","C5_FRETE"))),oFont3,100,,,1)
			
			oPrint:Say(nTopo + 0117,nInicio + 0600,"Valor Total ICM",oFont3,100,,,0)
			oPrint:Say(nTopo + 0117,nInicio + 1310," " + AllTrim(Transform(nTotaIcm,"@E 9,999,999.99")),oFont3,100,,,1)	
						
			oPrint:Box(nTopo  + 0120,nInicio + 1600,nTopo + 0170,nInicio + 2200)
			oPrint:Line(nTopo + 0120,nInicio + 1900,nTopo + 0170,nInicio + 1900) 
			
			oPrint:Say(nTopo + 0127,nInicio + 1615,"Valor Total + IPI",oFont3,100,,,0)
			oPrint:Say(nTopo + 0127,nInicio + 2190," " + AllTrim(Transform(aTotaIpi[2],"@E 9,999,999.99")),oFont3,100,,,1)
		
			// Linhas Horizontais  -  FIM Pedido
			oPrint:Line(nTopo + 0040,nInicio + 0040,nTopo + 0040,nInicio + 2360)
			
			
			// Imprime o Numero de Paginas
			oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0150,nInicio + 2360,"Página: " + Str(nPage) + " / " + AllTrim(nQtdPag)  ,oFont3,100,,,1)
			
			// Funcao de Impressao do Rodape. Parametro: Numero da linha atual
		   	PrintTrailer(nPage,nTotal,nTopo)
		EndIf  
				
		QRY->(dbskip())		
		
	EndDo
	
Return

/*
	Busca a Alíquota e/ou o Valor do IPI
	nOption = 1 (Alíquota) / 2 (Valor)
*/
Static Function getIpiValue(nOption)

	Local cIpiValue := ""
	Local nIpiValue := 0
	Local cCalcIPI  := AllTrim(Posicione("SF4",1,xFilial("SF4")+QRY->C6_TES,"F4_IPI"))
	
	If nOption == 1
		cIpiValue := If(cCalcIPI == "S",AllTrim(Str(QRY->B1_IPI,4,1)),"0,0")
	Else
		If cCalcIPI == "S"
			nIpiValue := (QRY->C6_VALOR * ((QRY->B1_IPI)/100))
		EndIf
		
		// Calcula o Valor Total do Pedido de Venda com IPI
		aTotaIpi[1] += nIpiValue
		aTotaIpi[2] += nIpiValue + QRY->C6_VALOR
		
		cIpiValue := AllTrim(Transform(nIpiValue,PesqPict("SD2","D2_VALIPI")))
	EndIf
	
Return cIpiValue

/*
	Busca a Alíquota e/ou o Valor do ICMS
	nOption = 1 (Alíquota) / 2 (Valor)
*/
Static Function getIcmValue(nOption)
	Local cIcmValue := ""
	Local nIcmValue := 0
	Local cCalcICM  := AllTrim(Posicione("SF4",1,xFilial("SF4")+QRY->C6_TES,"F4_ICM"))
	Local nAliqIcm  := getAliqICM()
	
	If nOption == 1
		cIcmValue := If(cCalcICM == "S",AllTrim(Str(nAliqIcm,4,1)),"0,0")
	Else
		If cCalcIcm == "S"
			nIcmValue := (QRY->C6_VALOR * ((nAliqIcm)/100))
		EndIf
		
		nTotaIcm += nIcmValue
		
		cIcmValue := AllTrim(Transform(nIcmValue,PesqPict("SD2","D2_VALICM")))
	EndIf
	
Return cIcmValue

/*
	Recupera a Alíquota do ICMS
*/
Static Function getAliqICM()
	Local cQuery   := ""
	Local nAliqIcm := 0
	
	cQuery := "SELECT F7_SEQUEN,F7_ALIQINT,F7_ALIQEXT,F7_ALIQDST" + CRLF
	cQuery += "FROM "+RetSqlName("SF7")+" F7                    " + CRLF
	cQuery += "WHERE F7_FILIAL  = '"+xFilial("SF7")+"' AND      " + CRLF
	cQuery += "      F7_GRTRIB  = '"+QRY->B1_GRTRIB+"' AND      " + CRLF
	cQuery += "      F7_GRPCLI  = '"+QRY->GRPTRIB+"' AND     " + CRLF
	cQuery += "      F7_EST     = '"+QRY->EST+"' AND         " + CRLF
	cQuery += "      F7_TIPOCLI = '"+QRY->TIPO+"' AND        " + CRLF
	cQuery += "      F7.D_E_L_E_T_ = ' '                        " + CRLF
	
	TCQUERY cQuery NEW ALIAS "QICM"
	
	If QICM->(!eof())
		nAliqIcm := QICM->F7_ALIQINT
	ElseIf QRY->B1_PICM > 0
		nAliqIcm := QRY->B1_PICM
	Else
		//nAliqIcm := GetMv("MV_ESTICM")
		nAliqIcm := Val(Subs(alltrim(getmv("MV_ESTICM")),AT(QRY->EST,alltrim(getmv("MV_ESTICM")))+2,2))
	EndIf
	
	QICM->(dbCloseArea())
	
Return nAliqIcm

/*
	Função para impressão do Rodapé
*/
Static Function PrintTrailer(nPage,nTotal,nTopo)
	Local nInicio    := 0  // Indica a posicao da primeira coluna
	Local cDescontos := ""
	
	If QRY->C5_DESC1 > 0
		cDescontos += AllTrim(Str(QRY->C5_DESC1, 10, 2))
	EndIf
	
	If QRY->C5_DESC2 > 0
		If !Empty(cDescontos)
			cDescontos += " + "
		Endif
		cDescontos += AllTrim(Str(QRY->C5_DESC2, 10, 2))
	EndIf
	
	If QRY->C5_DESC3 > 0
		If !Empty(cDescontos)
			cDescontos += " + "
		Endif
		cDescontos += AllTrim(Str(QRY->C5_DESC3, 10, 2))
	EndIf
	
	If QRY->C5_DESC4 > 0
		If !Empty(cDescontos)
			cDescontos += " + "
		Endif
		cDescontos += AllTrim(Str(QRY->C5_DESC4, 10, 2))
	EndIf
		
	If nTopo <= (Mm2Pix(oPrint, oPrint:nVertSize()) - 0600)
	
		// Box Condicoes Gerais
		oPrint:Box(Mm2Pix(oPrint, oPrint:nVertSize()) - 0650,nInicio + 0040, Mm2Pix(oPrint, oPrint:nVertSize()) - 0290,nInicio + 2360)
		
		// Titulo Centralizado
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0630, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Informações Gerais",oFont1,100,,,2)
			
		// Textos Posicionados à Esquerda
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0550,nInicio + 0060,"Forma de Pagamento"  									,oFont3,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0550,nInicio + 0450,": " + QRY->C5_CONDPAG + " - " + QRY->E4_DESCRI	,oFont5,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0500,nInicio + 0060,"Transportadora" 				 			   			,oFont3,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0500,nInicio + 0450,": (" + QRY->C5_TRANSP + ") " + QRY->A4_NOME		,oFont5,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0450,nInicio + 0060,"Nº do Pedido Cliente" 				 				,oFont3,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0450,nInicio + 0450,": " + QRY->C6_PEDCLI								,oFont5,100,,,0)
		
		If !Empty(cDescontos)
			oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0400,nInicio + 0060,"Descontos % "   ,oFont3,100,,,0)
			oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0400,nInicio + 0450,": " + cDescontos,oFont5,100,,,0)
		EndIf
				
		// Textos Posicionados à Esquerda
//		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0550, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Validade" 				 		  ,oFont3,100,,,0)
//		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0550, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0250,": " + Dtoc(QRY->C5_VALIDA),oFont5,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0450, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Vendedor" 					 	  ,oFont3,100)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0450, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0250,": (" + QRY->C5_VEND1 + ") " + QRY->A3_NOME,oFont5,100)
				
		// Box para a Mensagem da Nota
		oPrint:Box(Mm2Pix(oPrint, oPrint:nVertSize()) - 0270,nInicio + 0040, Mm2Pix(oPrint, oPrint:nVertSize()) - 0170  ,nInicio + 2360)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0260,nInicio + 0060,"Obs"                                       ,oFont3,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0260,nInicio + 0200,".: " + Substr(QRY->C5_MENNOTA,1,100)      ,oFont5,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0210,nInicio + 0200,Space(03) + Substr(QRY->C5_MENNOTA,101,100),oFont5,100,,,0)
		           
		// Imprime o Numero de Paginas
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0150,nInicio + 2360,"Página: " + Str(nPage) + " / " + AllTrim(nQtdPag)   ,oFont3,100,,,1)
		
		oPrint:EndPage()
		
	Else
		
		// Encerra a Pagina Atual
		oPrint:EndPage()
		
		// Inicia uma Nova Pagina para Impressao
		oPrint:StartPage()
		
		// Define o modo de Impressão como Retrato
		oPrint:SetPortrait()  // SetLandscape -> Para definir como modo Paisagem
		
		// Funcao para impressao do Cabecalho
		PrintHeader(cPedido,cEmissao)
		nTopo := 0420
		
		nPage += 1
	
		// Box Condicoes Gerais
		oPrint:Box(Mm2Pix(oPrint, oPrint:nVertSize()) - 0650,nInicio + 0040, Mm2Pix(oPrint, oPrint:nVertSize()) - 0290,nInicio + 2360)
		
		// Titulo Centralizado
		oPrint:Say (Mm2Pix(oPrint, oPrint:nVertSize()) - 0630, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Informações Gerais"		,oFont1,100,,,2)
			
		// Textos Posicionados à Esquerda
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0550,nInicio + 0060,"Forma de Pagamento"  								 ,oFont3,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0550,nInicio + 0450,": " + QRY->C5_CONDPAG + " - " + QRY->E4_DESCRI,oFont5,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0500,nInicio + 0060,"Transportadora" 				 			   		 ,oFont3,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0500,nInicio + 0450,": (" + QRY->C5_TRANSP + ") " + QRY->A4_NOME	 ,oFont5,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0450,nInicio + 0060,"Nº Pedido Cliente" 				 				 ,oFont3,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0450,nInicio + 0450,": " + QRY->C6_PEDCLI							 ,oFont5,100,,,0)
				
		If !Empty(cDescontos)
			oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0400,nInicio + 0060,"Descontos % "   ,oFont3,100,,,0)
			oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0400,nInicio + 0450,": " + cDescontos,oFont5,100,,,0)
		EndIf
				
		// Textos Posicionados à Esquerda
//		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0550, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Validade" 				 		  ,oFont3,100,,,0)
//		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0550, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0250,": " + Dtoc(QRY->C5_VALIDA),oFont5,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0450, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Vendedor" 					 	  ,oFont3,100)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0450, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0250,": (" + QRY->C5_VEND1 + ") " + QRY->A3_NOME,oFont5,100)
				
		// Box para a Mensagem da Nota
		oPrint:Box(Mm2Pix(oPrint, oPrint:nVertSize()) - 0270,nInicio + 0040, Mm2Pix(oPrint, oPrint:nVertSize()) - 0170  ,nInicio + 2360)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0260,nInicio + 0060,"Obs" 			   						    ,oFont3,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0260,nInicio + 0200,".: " + Transform(QRY->C5_MENNOTA,'@!S100'),oFont5,100,,,0)
		           
		// Imprime o Numero de Paginas
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0150,nInicio + 2360,"Página: " + Str(nPage) + " / " + AllTrim(nQtdPag),oFont3,100,,,1)
				
		oPrint:EndPage()
			
	EndIf
		
Return
	
/*
	Retorna a Largura da Pagina em Pixel.
	Retirado metodo oPrint:nLogPixelX(), pois estava ocorrendo casos em clientes 
	em que a linha impressa que utliza a funcao MM2PIX saia desconfigurada
	Local nValor := (nMm * oPrint:nLogPixelX()) / 25.4
*/
Static Function Mm2Pix(oPrint,nMm)
	Local nValor := (nMm * 300) / 25.4
	
Return nValor

/*
	Valida se existe um grupo de perguntas caso contrario o grupo de perguntas é criado.
*/
Static Function ValidPerg(cPerg)	
	Local _sAlias := Alias()
	Local aRegs := {}
	Local i,j
	
	dbSelectArea("SX1")
	dbSetOrder(1)

	cPerg := Padr(cPerg,Len(SX1->X1_GRUPO))
		
	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	aAdd(aRegs,{cPerg,"01","Pedido de " ,"","","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SC5"})
	aAdd(aRegs,{cPerg,"02","Pedido até ","","","mv_ch2","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SC5"})
	aAdd(aRegs,{cPerg,"03","Data de "      ,"","","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"04","Data até "     ,"","","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
	
	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				EndIf
			Next
			MsUnlock()
		EndIf
	Next
	
	dbSelectArea(_sAlias)
  
Return .T.
