#INCLUDE "totvs.ch"
#INCLUDE "colors.ch"
#INCLUDE "font.ch"
#INCLUDE "topconn.ch"

/*/{Protheus.doc} MSRFATHT

Relatorio de Pedido de Venda chamado via menu para envio via E-mail

@type function
@author Hermes Vieira Jr
@since 16/06/2007

@history 21/06/2016, Carlos Eduardo Niemeyer Rodrigues
/*/
User Function MSRFATHT(lAuto,cNum)
	Local oClassRelatorioPV	:= ClassRelatorioPV():newClassRelatorioPV()
	Local lReg				:= .F. // Verifica a existencia de Registros
	Local nLastKey			:= 0
	Local titulo   			:= "Relatório de Pedido de Venda"
	Local cMens 			:= "Não há registros para os parametros informados !!"  
	Local cMailDig    		:= Space(255)  
	Local oDL, oMail 

	Local nCount			:= 0
	Local cNPv
	Local nFrete
	Local nDespesa
	Local nTotal
	Local cHtml
	Local cOpt
	Local cQuery  
	Local cEMISSAO       

	Local cCond 		:=	""
	Local cDescri 		:= 	""
	Local cVolum		:= 	""
	Local cDesc1		:=  ""
	Local cDesc2		:= 	""
	Local cDesc3		:= 	""
	Local cValid		:= 	""
	Local cTipoF		:= 	""
	Local cEspec		:= 	""
	Local cNTrans		:=  ""
	Local cNVend		:=  ""
	Local cMenNota		:=  ""
	Local cMenPad		:=  ""
	Local cPedido     	:=  ""       
	Local cNomeCli		:=  ""
	Local cEmailCli		:=  ""

	Local cEmailCab		:= RetEmailUsr() //AllTrim(GetMV("ZZ_SCEMAIL")) //Ajuste Carlos Niemeyer - FSW - TOTVS RP - 23/11/2011
	Local cEmail 		:= ""
	Local cConta 		:= AllTrim(GETMV("MV_RELACNT"))
	Local cEmailDe 		:= AllTrim(GETMV("MV_RELFROM"))
	Local cPass 		:= AllTrim(GETMV("MV_RELPSW"))
	Local cServ 		:= AllTrim(GETMV("MV_RELSERV"))
	Local lAutent 		:= GETMV("MV_RELAUTH")
	Local cLogoMail   	:= AllTrim(GETMV("ZZ_LOGOEXT"))

	Local cPerg			:= "PERFAT" 

	Default lAuto 		:= .F.
	Default cNum  		:= ""

	ValidPerg(cPerg)      

	If lAuto
		mv_par01 := cNum
		mv_par02 := cNum
		mv_par03 := Ctod("01/01/1990")
		mv_par04 := Ctod("31/12/2060")
	Else
		If !(Pergunte(cPerg,.T.))
			Return
		Endif  
	Endif

	If lastKey() == 27 .or. nLastKey == 27 .or. nLastKey == 286
		return
	Endif
		 
	// Query que retorna os dados do pedido de compra e os dados dos itens.
	cQuery := "SELECT "
	cQuery += "		SC5.C5_NUM, SC5.C5_EMISSAO, SC5.C5_DESC1, SC5.C5_DESC2, SC5.C5_DESC3, SC5.C5_DESC4,SC5.C5_FRETE, SC5.C5_DESPESA, "
	cQuery += "		SC5.C5_TPFRETE, SC5.C5_ESPECI1, SC5.C5_VEND1, SC5.C5_MENNOTA, SC5.C5_MENPAD, SC5.C5_CONDPAG, SC5.C5_TRANSP,SC5.C5_VOLUME1,SC5.C5_ZZVALID,  "
	cQuery += "		SA1.A1_COD, SA1.A1_NOME, SA1.A1_NREDUZ, SA1.A1_EMAIL, SA1.A1_END, SA1.A1_MUN, SA1.A1_EST, SA1.A1_DDD, SA1.A1_TEL, SA1.A1_FAX, SA1.A1_CEP, SA1.A1_BAIRRO, SA1.A1_EST, SA1.A1_CONTATO, SA1.A1_HPAGE,SA1.A1_CGC, SA1.A1_INSCR,"
	cQuery += "		SC6.C6_NUM, SC6.C6_ITEM, SC6.C6_PRODUTO, SC6.C6_DESCRI, SC6.C6_UM, SC6.C6_QTDVEN, SC6.C6_PRCVEN, SC6.C6_VALOR, SC6.C6_ENTREG,SC6.C6_TES,SC6.C6_PEDCLI, "
	cQuery += "		SB1.B1_IPI, SB1.B1_DESC, SE4.E4_DESCRI, SA4.A4_NOME, SA3.A3_NOME "
	cQuery += "FROM " + RetSqlName("SC5") + " AS SC5 "
	cQuery += "		INNER JOIN " + RetSqlName("SA1") + " AS SA1 ON "
	cQuery += "			SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND SC5.C5_CLIENTE = A1_COD AND SC5.C5_LOJACLI = A1_LOJA AND SA1.D_E_L_E_T_ = ' ' "
	cQuery += "		INNER JOIN " + RetSqlName("SC6") + " AS SC6 ON "
	cQuery += "			SC6.C6_FILIAL = '" + xFilial("SC6") + "' AND SC5.C5_NUM = SC6.C6_NUM AND SC6.D_E_L_E_T_ = ' ' "
	cQuery += "		LEFT JOIN " + RetSqlName("SB1") + " AS SB1 ON "
	cQuery += "			SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND SC6.C6_PRODUTO = SB1.B1_COD AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += "		LEFT JOIN " + RetSqlName("SE4") + " AS SE4 ON "
	cQuery += "			SE4.E4_FILIAL = '" + xFilial("SE4") + "' AND SC5.C5_CONDPAG = SE4.E4_CODIGO AND SE4.D_E_L_E_T_ = ' ' "
	cQuery += "		LEFT JOIN " + RetSqlName("SA4") + " AS SA4 ON "
	cQuery += "			SA4.A4_FILIAL = '" + xFilial("SA4") + "' AND SC5.C5_TRANSP = SA4.A4_COD AND SA4.D_E_L_E_T_ = ' ' "
	cQuery += "		LEFT JOIN " + RetSqlName("SA3") + " AS SA3 ON "
	cQuery += "			SA3.A3_FILIAL = '" + xFilial("SA3") + "' AND SC5.C5_VEND1 = SA3.A3_COD AND SA3.D_E_L_E_T_ = ' ' "
	cQuery += "	WHERE SC5.C5_FILIAL = '" + xFilial("SC5") + "' AND SC5.D_E_L_E_T_ = ' ' AND SC5.C5_NUM >= '"+ mv_par01 +"' AND SC5.C5_NUM <= '"+ mv_par02 +"' "
	If !Empty(mv_par03) .AND. !Empty(mv_par04)
		cQuery += " AND C5_EMISSAO BETWEEN '" + DtoS(mv_par03) + "' AND '" + DtoS(mv_par04) + "' "
	EndIf
	cQuery += " ORDER BY SC5.C5_NUM, SC6.C6_ITEM"
		
	TCQUERY cQuery NEW ALIAS "cAlias"

	TCSETFIELD("cAlias","C5_EMISSAO","D",08,00)   
	TCSETFIELD("cAlias","C5_ENTREG","D",08,00)   
	TCSETFIELD("cAlias","C5_ZZVALID","D",08,00)   

	Count to nCount      

	cAlias->(dbgotop())
		
	If 	cAlias->(EOF())
		MsgSTOP(cMens)
		cAlias->(dbCloseArea())
	Else
		
		oEmail:= CONEMAIL():New(cServ, cConta , cPass ,, lAutent)
		
		oEmail:PegaEmail()
		cEmailDe := AllTrim(oEmail:cEmail)	
		
		Do While  cAlias->(!Eof())
			
			TCSETFIELD("cAlias","C5_EMISSAO","D",08,00)   
			TCSETFIELD("cAlias","C5_ZZVALID","D",08,00)          

			cNPv 	:= cAlias->C5_NUM
			cEmissao:= cAlias->C5_EMISSAO
			cPedido := ""
			cHtml   := '<body>'  
			
			cHtml   += '<table width="100%" border="0">'
			cHtml   += '<tr>    '
			cHtml   += '	<td width="53%" height="99"><div align="left"><img src="'+cLogoMail+'" width="252" height="88"></div></td>'
			cHtml   += '	<td width="47%"><div align="left"><p><font size="2" face="Arial, Helvetica, sans-serif"><strong>'+ RTrim(SM0->M0_NOMECOM)+ '<br>'
			cHtml   +=  AllTrim(SM0->M0_ENDENT) + ' ' + AllTrim(SM0->M0_CIDENT) + '/' + AllTrim(SM0->M0_ESTENT) + ' ' + LEFT(AllTrim(SM0->M0_CEPENT),5) + '-' + RIGHT(AllTrim(SM0->M0_CEPENT),3) + '<br>'

			cHtml   += '	E-mail: ' + Alltrim(cEmailCab)+ '<br>'

			cHtml   += '	Fone: '+AllTrim(SM0->M0_TEL) + ' FAX: ' + AllTrim(SM0->M0_FAX)+'<br>'
			cHtml   += ' 	CNPJ: '+ AllTrim(Transform(SM0->M0_CGC, "@R 99.999.999/9999-99")) + ' - IE: ' +  AllTrim(Transform(SM0->M0_INSC, "@R 999.999.999.999")) + '</p>'
			cHtml   += '	</strong></font></div></td>'
			cHtml   += '</tr>'
			cHtml   += '</table>'         
			
			cHtml   += '<hr> '
			cHtml   += '<table width="100%" border="0">'
			cHtml   += ' <tr>'
			cHtml   += '   <td><font size="3" face="Arial, Helvetica, sans-serif"><strong>Pedido de Venda N° '+cNPv+'</strong></font></td>'
			cHtml   += '   <td><div align="right"><font size="3" face="Arial, Helvetica, sans-serif"><strong>Data: ' + DTOC(cEMISSAO)+ '</strong></font></div></td>'
			cHtml   += ' </tr>'
			cHtml   += '</table>'
			cHtml   += '<hr>'                  
		
			cHtml   += '<table width="100%" border="0"> '
			cHtml   += '  <tr>' 
			cHtml   += '    <td width="12%"><font size="2" face="Arial, Helvetica, sans-serif"><strong>Cliente:</strong></font></td>'
			cHtml   += '    <td width="39%"><font size="2" face="Arial, Helvetica, sans-serif">'+ cAlias->A1_COD + ' - '+ cAlias->A1_NOME + '</font></td>'
			cHtml   += '    <td width="9%"><font size="2" face="Arial, Helvetica, sans-serif">&nbsp;</font></td>'
			cHtml   += '    <td width="40%">&nbsp;</td>'
			cHtml   += '  </tr>'
			cHtml   += '  <tr>' 
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>E-Mail:</strong></font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+cAlias->A1_EMAIL+'</font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Contato:</strong></font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+cAlias->A1_CONTATO+'</font></td>'
			cHtml   += '  </tr>'
			cHtml   += '  <tr>' 
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Endereço:</strong></font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+cAlias->A1_END+'</font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Bairro:</strong></font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+cAlias->A1_BAIRRO+'</font></td>'
			cHtml   += '  </tr>'
			cHtml   += '  <tr>' 
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Cidade:</strong></font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+AllTrim(cAlias->A1_MUN)+"/"+cAlias->A1_EST+'</font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Cep:</strong></font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+LEFT(cAlias->A1_CEP,5) + "-" + RIGHT(cAlias->A1_CEP,3)+'</font></td>'
			cHtml   += '  </tr>'
			cHtml   += '  <tr>' 
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Tel:</strong></font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">(' + cAlias->A1_DDD + ') ' + LEFT(cAlias->A1_TEL,4) + '-' + SUBSTR(cAlias->A1_TEL,5,8) + '</font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>FAX:</strong></font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">(' + cAlias->A1_DDD + ') ' + LEFT(cAlias->A1_FAX,4) + '-' + SUBSTR(cAlias->A1_FAX,5,8) + '</font></td>'
			cHtml   += '  </tr>' 
			cHtml   += '  <tr>'
			If LEN(ALLTRIM(cAlias->A1_CGC)) > 11   
				cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>CNPJ:</strong></font></td>'
				cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+AllTrim(Transform(cAlias->A1_CGC,"@R 99.999.999/9999-99"))+'</font></td>'
			ELSE
				cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>CPF:</strong></font></td>'
				cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+AllTrim(Transform(cAlias->A1_CGC,"@R 999.999.999-99"))+'</font></td>'
			ENDIF
			
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>I.E.:</strong></font></td>'
			If LEN(ALLTRIM(cAlias->A1_INSCR)) > 6
				cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+AllTrim(Transform(cAlias->A1_INSCR,"@R 999.999.999.999"))+'</font></td>'
			ELSE
				cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+AllTrim(cAlias->A1_INSCR)+'</font></td>'
			ENDIF
			cHtml   += '  </tr>'
			cHtml   += '</table>'
			cHtml   += '	<table width="100%" border="1">'
			cHtml   += '<tr>' 
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Item</strong></font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Produto</strong></font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Descrição</strong></font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>UM</strong></font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Qtde.</strong></font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Valor Unit.</strong></font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Valor Total</strong></font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>%IPI</strong></font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Entrega</strong></font></td>'
			cHtml   += '  </tr>'
			
			nTotal		:=0  
			
			nFrete    	:= cAlias->C5_FRETE
					
			nDespesa	:= cAlias->C5_DESPESA 
			
			cCond 		:=	cAlias->C5_CONDPAG
			cDescri 	:= 	cAlias->E4_DESCRI
			cVolum		:= 	cAlias->C5_VOLUME1
			cDesc1		:=  cAlias->C5_DESC1
			cDesc2		:= 	cAlias->C5_DESC2
			cDesc3		:= 	cAlias->C5_DESC3
			cValid		:= 	cAlias->C5_ZZVALID
			cTipoF		:= 	cAlias->C5_TPFRETE
			cEspec		:= 	cAlias->C5_ESPECI1
			cNTrans		:= "(" + cAlias->C5_TRANSP + ") " + cAlias->A4_NOME
			cNVend		:= "(" + cAlias->C5_VEND1 + ") " +	cAlias->A3_NOME
			cMenNota	:=  cAlias->C5_MENNOTA
			cMenPad		:=  cAlias->C5_Menpad
			cNomeCli	:=  cAlias->A1_NREDUZ
			cEmailCli	:=  cAlias->A1_EMAIL
			
			While cNPv == cAlias->C5_NUM   
			
				TCSETFIELD("cAlias","C6_ENTREG","D") 
			
				cHtml   += '  <tr>' 
				cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+Ltrim(cAlias->C6_ITEM)+'</font></td>'
				cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+Ltrim(cAlias->C6_PRODUTO)+'</font></td>'
				cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+Ltrim(cAlias->B1_DESC)+'</font></td>'
				cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+LTrim(cAlias->C6_UM)+'</font></td>'
				cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+Alltrim(STR(cAlias->C6_QTDVEN))+'</font></td>'
				cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+Alltrim(Transform(cAlias->C6_PRCVEN,PesqPict('SC6', 'C6_PRCVEN')))+'</font></td>'
				cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+Alltrim(Transform(cAlias->C6_VALOR,PesqPict('SC6', 'C6_VALOR')))+'</font></td>'
			   
				cPedido += IIF(!cAlias->C6_PEDCLI$cPedido,IIF(Empty(cPedido),""," / ")+cAlias->C6_PEDCLI,"")

				dbSelectArea("SF4")
				dbSetOrder(1)
				dbSeek(xFilial("SF4") + cAlias->C6_TES)
				If SF4->F4_IPI == "S"
					cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+Alltrim(STR(cAlias->B1_IPI,4,1))+'</font></td>'
				Else
					cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">0.0</font></td>'
				EndIf
				SF4->(dbCloseArea()) 
			   
				cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+DTOC(cAlias->C6_ENTREG)+'</font></td>'
				cHtml   += '  </tr>'
				
				nTotal := cAlias->C6_VALOR + nTotal
				
				cNPv := cAlias->C5_NUM
				
				cAlias->(dbskip())
				
			EndDo 
			
			nTotal := nTotal + nFrete + nDespesa     
			
			cHtml   += '</table>'

			cHtml   += '<br>'    
			
			cHtml   += '<table width="100%" border="0">'     
			
			cHtml   += '<tr>' 
			cHtml   += '<td width="18%"><div align="left"><font size="2" face="Arial, Helvetica, sans-serif"><strong>Valor Frete: </strong></font></div></td>'
			cHtml   += '<td width="26%"><div align="right"><font size="2" face="Arial, Helvetica, sans-serif">' + Alltrim(Transform(nFrete,PesqPict('SC5', 'C5_FRETE'))) + '</font><font size="2" face="Arial, Helvetica, sans-serif">&nbsp;</font></div></td>'
			cHtml   += '<td width="8%">&nbsp;</td>'
			cHtml   += '<td Colspan="2"><div align="left"><font size="2" face="Arial, Helvetica, sans-serif"><strong>Valor da Despesa:</strong></font></div></td>'
			cHtml   += '<td width="24%"><div align="right"><font size="2" face="Arial, Helvetica, sans-serif">' + Alltrim(Transform(nDespesa,PesqPict('SC5', 'C5_DESPESA'))) + '</font></div></td>'
			cHtml   += '<tr> '
			cHtml   += '<td width="18%"><div align="left"><font size="2" face="Arial, Helvetica, sans-serif"><strong>&nbsp;&nbsp;</strong></font></div></td>'
			cHtml   += '<td width="26%"><div align="right"><font size="2" face="Arial, Helvetica, sans-serif">&nbsp;&nbsp;</font><font size="2" face="Arial, Helvetica, sans-serif">&nbsp;</font></div></td>'
			cHtml   += '<td width="8%">&nbsp;</td>'
			cHtml   += '<td Colspan="2"><div align="left"><font size="2" face="Arial, Helvetica, sans-serif"><strong>Valor Total:</strong></font></div></td>' 
			cHtml   += '<td width="24%"><div align="right"><font size="2" face="Arial, Helvetica, sans-serif">' + Alltrim(Transform(nTotal,PesqPict('SC6', 'C6_VALOR'))) + '</font></div></td>'
			
			cHtml   += '</table>'     
			
			cHtml   += '<hr>  '
			cHtml   += '<table width="100%" border="0">'
			cHtml   += '  <tr> '
			cHtml   += '    <td colspan="2"><div align="center"><strong><font size="3" face="Arial, Helvetica, sans-serif">Informações Gerais</font></strong></div></td> '
			cHtml   += '  </tr>'
			cHtml   += '  <tr>' 
			cHtml   += '    <td> <p><strong><font size="2" face="Arial, Helvetica, sans-serif">Forma de Pagamento:</font></strong></p></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+ cCond + ' - ' + cDescri +'</font></td>'
			cHtml   += '  </tr>'
			cHtml   += '  <tr> '
			cHtml   += '    <td width="23%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Transportadora:</font></strong></td>'
			cHtml   += '    <td width="77%"><font size="2" face="Arial, Helvetica, sans-serif">'+ cNTrans +'</font></td>'
			cHtml   += '  </tr>' 
			cHtml   += '  <tr> '
			cHtml   += '    <td width="23%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Volume:</font></strong></td>'
			cHtml   += '    <td width="77%"><font size="2" face="Arial, Helvetica, sans-serif">'+ALLTRIM(STR(cVolum))+'</font></td>'
			cHtml   += '  </tr>'  
			cHtml   += '  <tr> '
			cHtml   += '    <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Espécie:</font></strong></td> '
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+ cEspec + '</font></td>'
			cHtml   += '  </tr> '
			cHtml   += '  <tr> '
			cHtml   += '    <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Descontos %:</font></strong></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+AllTrim(TRANSFORM(cDesc1,PesqPict('SC5', 'C5_DESC1'))) + ' + ' + AllTrim(TRANSFORM(cDesc2,PesqPict('SC5', 'C5_DESC2'))) + ' + ' + AllTrim(TRANSFORM(cDesc3,PesqPict('SC5', 'C5_DESC3')))+'</font></td> '
			cHtml   += '  </tr>'
			cHtml   += '  <tr>' 
			cHtml   += '    <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Tipo de Frete:</font></strong></td>'
			If AllTrim(cTipoF) = "C" 
				cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">CIF</font></td> '
			ELSE
				cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">FOB</font></td> '
			ENDIF
			cHtml   += '  </tr>'
			cHtml   += '  <tr> '
			cHtml   += '    <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Vendedor:</font></strong></td> '
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+ cNVend + '</font></td>'
			cHtml   += '  </tr> ' 
			cHtml   += '  <tr> '
			cHtml   += '    <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Validade:</font></strong></td> '
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+ DTOC(cValid) + '</font></td>'
			cHtml   += '  </tr> '		     
			cHtml   += '  <tr> '
			cHtml   += '    <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Pedido Cliente:</font></strong></td> '
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+ cPedido + '</font></td>'
			cHtml   += '  </tr> '		     
			cHtml   += '  <tr> '
			cHtml   += '    <td><strong><font size="2" face="Arial, Helvetica, sans-serif">Mensagem:</font></strong></td> '
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+Transform(cMenNota,'@!S100')+'</font></td>'
			cHtml   += '  </tr>'
						
			dbSelectArea("SM4")
			dbSetOrder(1)
			dbSeek(xFilial("SM4") + cAlias->C5_MENPAD)
			
			cHtml   += '  <tr> '
			cHtml   += '    <td colspan="2"><font size="2" face="Arial, Helvetica, sans-serif">'+ ALLTRIM(Transform(SM4->M4_DESCR,'@!S100')) +'</font></td>'
			cHtml   += '  </tr>'
			
			SM4->(dbCloseArea())
			
			cHtml   += '</table>'
			cHtml   += '<hr>'
			
			oEmail:CONECTAR()        
			
			cEmail := U_SU5PV(cNPv)   
			If Empty(cEmail)
				cEmail := Alltrim(cEmailCli)
			Endif                      
			
			cMailDig := PADR(cEmail,255)
			
			Define MsDialog oDL Title "E-mail do Cliente " + cNomeCli From 0, 0 To 70, 330 Pixel Style 128
				oDL:lEscClose := .f.
				Define Font oBold Name "Arial" Size 0, -13 Bold
				@ 000, 000 Bitmap oBmp ResName "LOGIN" Of oDL Size 30, 120 NoBorder When .f. Pixel
				@ 003,040 Say "E-Mail: " Font oBold Pixel
				@ 014, 030 To 016, 400 Label '' Of oDL  Pixel 
				@ 003,070 MsGet oEndMa Var cMailDig Size 090,008 Pixel //Valid cMailDig <> Space(60) .AND. "@" $ cMailDig 
				@ 020, 120 Button "Confirmar" Size 40, 13 Pixel Of oDL Action oDL:End()
			Activate MsDialog oDL Centered 
			
			//cEmail := IIF(!Empty(cMailDig), cEmail + ";" + cMailDig, cEmail) //Corrigido por Carlos Niemeyer - FSW - Totvs RP - 23/11/2011
			cEmail := AllTrim(cMailDig)
				
			If oEmail:ENVIAR(cEmailDe,alltrim(cEmail),"Relatório de Pedido de Venda",cHtml)
				MsgInfo("Relatório do Pedido " + cNPv + " Enviado com Sucesso para '" + cEmail + "'.","Envio de E-mail")
			EndIF
			
		EndDo 
		cAlias->(dbCloseArea())
	EndIF	

Return .T.       

/*
	Valida se existe um grupo de perguntas caso contrario o grupo de perguntas e criado
*/
Static Function ValidPerg(cPerg)
	Local _sAlias := Alias()
	Local aRegs   := {}
	Local i,j

	dbSelectArea("SX1")
	dbSetOrder(1)
	//cPerg := PADR(cPerg,6)
	cPerg := PADR(cPerg,Len(SX1->X1_GRUPO))

	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	aAdd(aRegs, {cPerg, "01", "Pedido de "        			,"" ,"" ,"mv_ch1", "C", 06, 0, 0, "G", "", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
	aAdd(aRegs, {cPerg, "02", "Pedido até "        			,"" ,"" ,"mv_ch2", "C", 06, 0, 0, "G", "", "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
	aAdd(aRegs, {cPerg, "03", "Data de "        			,"" ,"" ,"mv_ch3", "D", 08, 0, 0, "G", "", "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
	aAdd(aRegs, {cPerg, "04", "Data até "        			,"" ,"" ,"mv_ch4", "D", 08, 0, 0, "G", "", "mv_par04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
	//aAdd(aRegs, {cPerg, "05", "Produto de "     			,"" ,"" ,"mv_ch5", "C", 06, 0, 0, "G", "", "mv_par05", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
	//aAdd(aRegs, {cPerg, "06", "Produto até "     			,"" ,"" ,"mv_ch6", "C", 06, 0, 0, "G", "", "mv_par06", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
	//aAdd(aRegs, {cPerg, "03", "Onde Criar?"  			,"" ,"" ,"mv_ch3", "C", 08, 0, 0, "G", "", "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})

	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next

	dbSelectArea(_sAlias)
  
Return .T.

/*
	Retorna o Email do Usuário Logado ou informado
*/
Static Function  RetEmailUsr(cCodUser)
	Local aDadUser	:= {}
	Local cEmail	:= ""

	Default cCodUser := RetCodUsr()

	PswOrder(1)
	If PswSeek(cCodUser, .T.)
		aDadUser:= PswRet(1)
		cEmail	:= Alltrim(aDadUser[1, 14])	// E-mail do Usuario
	Endif
	
Return (cEmail)