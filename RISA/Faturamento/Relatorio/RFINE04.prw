#include "protheus.ch"         
#INCLUDE "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa³PE01NFESEFAZ³ Autor ³ Daniel Peixoto                  ³ Data ³ 13/05/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±   
±±³Descri‡…o ³ PE para ajustes nos dados da NFe                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ HISTORICO DE ATUALIZACOES DA ROTINA ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Desenvolvedor   ³ Data   ³Solic.³ Descricao                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Daniel          ³13/05/13³      ³ Criacao da Rotina                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß    

CRIAR CAMPOS
=============================
Campo: VVA_MENPAD
Tipo: Caracter
Tamanho: 3
Titulo: Msg Padrao
Contexto: Real
Propriedade: Alterar
Obrigatorio: Nao
Browse: SIm

Campo: VOO_MENPAD
Tipo: Caracter
Tamanho: 3
Titulo: Msg Padrao
Contexto: Real
Propriedade: Alterar
Obrigatorio: Nao
Browse: SIm

*/

User Function PE01NFESEFAZ()
Local aArea      := GetArea()
Local aProd      := PARAMIXB[1]
Local cMensCli   := PARAMIXB[2]
Local cMensFis   := PARAMIXB[3]
Local aDest      := PARAMIXB[4]
Local aNota      := PARAMIXB[5]
Local aInfoItem  := PARAMIXB[6]
Local aDupl      := PARAMIXB[7]
Local aTransp    := PARAMIXB[8]
Local aEntrega   := PARAMIXB[9]
Local aRetirada  := PARAMIXB[10]
Local aVeiculo   := PARAMIXB[11]
Local aReboque   := PARAMIXB[12]
Local aNfVincRur := PARAMIXB[13]

Local nCont      := 0, cMsgCust := ""
Local aMsg       := {}  
Local cTipo      := If(Len(aNota) >  0,aNota[04],"")
Local cNota      := If(Len(aNota) >  0,aNota[02],"")
Local cSerie     := If(Len(aNota) >  0,aNota[01],"")
Local cClieFor   := "", cLoja      := "", cSeparador1 := "", cDescProd := ""

Local cLJTPNFE := "", cWhere := "", cAliasSE1 := ""
Local cMV_LJTPNFE	:= SuperGetMV("MV_LJTPNFE", ," ")
Local cValLiqB		:= SuperGetMv("MV_BX10925", ,"2")
Local nValDupl := 0 

/*DbSelectArea("SC5")
 DbSetOrder(1)

 If SC5->(MsSeek(xFilial("SC5")+SD2->D2_PEDIDO))
  cMensCli += "  "
  cMensCli += "PEDIDO: " + SC5->C5_NUM
  cMensCli += " / "
  cMensCli += "COD CLI/FOR: " + SC5->C5_CLIENTE + " - " + SC5->C5_LOJACLI
  cMensCli += " / "
  cMensCli += "N FANTASIA: " + Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_NREDUZ")
  cMensCli += " / "
  cMensCli += "COND PAGTO: " + SC5->C5_CONDPAG + " - " + Posicione("SE4",1,xFilial("SE4")+SC5->C5_CONDPAG,"E4_DESCRI")
  cMensCli += " / " 
 EndIf
 */
if cTipo == "2"	//TIPO = ENTRADA

 	/*dbSelectArea("SF1")
 	dbSetOrder(1)//FILIAL + DOC + SERIE
 	MsSeek(xFilial("SF1")+aNota[02]+aNota[01])
  While xFilial("SF1")+aNota[02]+aNota[01] == SF1->F1_FILIAL + SF1->F1_DOC + SF1->F1_SERIE .And. SF1->F1_FORMUL <> "S"
   DbSkip()
  EndDo 

		If SF1->F1_TIPO $ "DB" 
   dbSelectArea("SA1")
			dbSetOrder(1)
			MsSeek(xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA)
   cClieFor   := SA1->A1_COD
   cLoja      := SA1->A1_LOJA
   cNome      := SA1->A1_NOME
 	Else
  	dbSelectArea("SA2")
  	dbSetOrder(1)
  	MsSeek(xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA)
   cClieFor   := SA2->A2_COD
   cLoja      := SA2->A2_LOJA
   cNome      := SA2->A2_NOME
  EndIf
  */

	RestArea(aArea)
	Return({aProd,cMensCli,cMensFis,aDest,aNota,aInfoItem,aDupl,aTransp,aEntrega,aRetirada,aVeiculo,aReboque,aNfVincRur}) 

endif	//Fim ENTRADA


//INICIO SAIDA       
SF2->( dbSetOrder(1) )
SF2->( MsSeek( xFilial("SF2") + cNota + cSerie ) )


// Alterado Pedro Paulo - 14/07/2016     
if len(aDupl) == 0

	cLJTPNFE := (StrTran(cMV_LJTPNFE,","," ','"))+" "
	cWhere := cLJTPNFE

	cAliasSE1 := GetNextAlias()
	BeginSql Alias cAliasSE1
			COLUMN E1_VENCORI AS DATE

		SELECT E1_FILIAL,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_TIPO,E1_VENCORI,E1_VALOR,E1_VLCRUZ,E1_ORIGEM,E1_PIS,E1_COFINS,E1_CSLL,E1_INSS,E1_VLRREAL,E1_IRRF,E1_ISS
		FROM %Table:SE1% SE1
		WHERE
				SE1.E1_FILIAL = %xFilial:SE1% AND
				SE1.E1_PREFIXO = %Exp:SF2->F2_PREFIXO% AND 
				SE1.E1_NUM = %Exp:SF2->F2_DUPL% AND 
				SE1.%NotDel%
		ORDER BY %Order:SE1%

	EndSql

	while !(cAliasSE1)->( Eof() ) .And. xFilial("SE1") == (cAliasSE1)->E1_FILIAL .And.;
			SF2->F2_PREFIXO == (cAliasSE1)->E1_PREFIXO .And.;
			SF2->F2_DOC == (cAliasSE1)->E1_NUM  

		nValDupl := IIF((cAliasSE1)->E1_VLRREAL > 0,(cAliasSE1)->E1_VLRREAL,(cAliasSE1)->E1_VLCRUZ)

		if cValLiqB == "1"
			aadd(aDupl,{(cAliasSE1)->E1_PREFIXO+(cAliasSE1)->E1_NUM+(cAliasSE1)->E1_PARCELA,(cAliasSE1)->E1_VENCORI;
						,(nValDupl-(cAliasSE1)->E1_PIS-(cAliasSE1)->E1_COFINS-(cAliasSE1)->E1_CSLL-(cAliasSE1)->E1_INSS)-(cAliasSE1)->E1_IRRF-(cAliasSE1)->E1_ISS})					
		else
			aadd(aDupl,{(cAliasSE1)->E1_PREFIXO+(cAliasSE1)->E1_NUM+(cAliasSE1)->E1_PARCELA,(cAliasSE1)->E1_VENCORI,nValDupl})	
		endif

		(cAliasSE1)->( DbSkip() )

	enddo

endif


//-- NFE TOTVS DMS - INICIO
//------ VEICULO OU EQUIPAMENTO ------

if AllTrim( SF2->F2_PREFORI ) == "VEI" .or. SD2->D2_GRUPO $ "VEIC|AMS1|AMS2|AMS3|AMS4"

	_cvend := Posicione("SA3",1,xFilial("SA3")+SF2->F2_VEND1,"A3_NOME")
	
	cMensFis += Space(2) + " Vendedor: " +Alltrim(_cvend)  

	VV0->( dbSetOrder( 4 ) )
	VV0->( DbSeek( xFilial( "VV0" ) + SF2->F2_DOC + SF2->F2_SERIE ) )

	cMensFis +=  Space(2) + MSMM( VV0->VV0_OBSMNF )

//----- OFICINA ------
elseIf AllTrim( SF2->F2_PREFORI ) $ "OFI"                                 

	VOO->( dbSetOrder( 4 ) )
	VOO->( dbSeek( xFilial( "VOO" ) + SF2->F2_DOC + SF2->F2_SERIE ) )

	cMensFis += Space(2) + MSMM( VOO->VOO_OBSMNF )

	// Incluido Whilton - 07/11.
	_cNumOsV := VOO->VOO_NUMOSV

	VO1->( dbSetOrder(1) )
	VO1->( dbSeek( xfilial("VO1") + _cNumOsV ) )

	// Alterado para pegar o noem do vendedor da tabela VAI
	_cvend := Posicione("VAI",1,xFilial("VAI")+VO1->VO1_FUNABE,"VAI_NOMTEC")

	//cMensFis += Space(2) + "Numero OS: " + VO1->VO1_NUMOSV  + "Consultor: " +VO1->VO1_FUNABE 
	cMensFis += Space(2) + "Numero OS: " + VO1->VO1_NUMOSV  + " Chassi: " + VO1->VO1_CHASSI

	//Por oficina imprimir os campos VS1_NUMORC,   VO1_NUMOSV e VO1_FUNABE
	VS1->( dbSetOrder( 3 ) )                     
	VS1->( dbSeek( xFilial( "VS1" ) + SF2->F2_DOC + SF2->F2_SERIE ) )

	cMensFis += Space(2) + " Numero Orcamento: " + VS1->VS1_NUMORC           

//----- PECAS ----- Incluido Whilton - 07/11 - Por auto-pecas imprimir os campos VS1_NUMORC, VS1_CODVEN
elseif AllTrim( SF2->F2_PREFORI ) $ "BAL"                                 

	VS1->( dbSetOrder( 3 ) )
	VS1->( dbSeek( xFilial( "VS1" ) + SF2->F2_DOC + SF2->F2_SERIE ) )

	// cMensFis += Space(2) + "Numero Orcamento: " + VS1->VS1_NUMORC + " Cod. Vendedor: " + VS1->VS1_CODVEN  
	//_cvend := Posicione("SA3",1,xFilial("SA3")+VS1->VS1_CODVEN,"A3_NOME")	
	//cMensFis += Space(2) + "Numero Orcamento: " + VS1->VS1_NUMORC + " Vendedor: " + _cvend 

	// Alterado para pegar da tabela VAI - 28/01/15
	// cMensFis += Space(2) + "Numero Orcamento: " + VS1->VS1_NUMORC + " Cod. Vendedor: " + VS1->VS1_CODVEN  

	_cvend := Posicione("VAI",1,xFilial("VAI")+VS1->VS1_CODVEN,"VAI_NOMTEC") 
	//cMensFis += Space(2) + "Numero Orcamento: " + VS1->VS1_NUMORC + " Vendedor: " + _cvend

endif           					                     
//--- NFE TOTVS DMS - FIM

 	
//Msg VEICULOS
lVeic := .F.
VV0->( DbSetOrder(4) ) 	//FILIAL+VV0->VV0_NUMNFI+VV0->VV0_SERNFI  
if VV0->( DbSeek( xFIlial("VV0") + SF2->F2_DOC + SF2->F2_SERIE ) )
   lVeic := .T.

	//Vendedor
	if !Empty(VV0->VV0_CODVEND) //Trocado a solicitacao Romilda

	    SA3->( DbSetOrder(1) )		//FILIAL+COD
	    if SA3->( DbSeek( xFilial("SA3") + VV0->VV0_CODVEND ) )
			cMensCli += IIF(!Empty(cMensCli), "   ", "") + "Vendedor: " + AllTrim(VV0->VV0_CODVEND) + " " + SA3->A3_NOME
	    endif

	endif 

	VV9->( DbSetOrder(1) )	//FILIAL+NUMATE
	if VV9->( DbSeek( xFilial("VV9") + VV0->VV0_NUMTRA ) ) //.And. !Empty(VV9->VV9_USUARI)   //Trocado a solicitacao Romilda

		//Msg Itens Saidas
	    VVA->( DbSetOrder(1) ) 	//FILIAL+NUMTRA
   		VVA->( DbSeek( VV9->VV9_FILIAL + VV9->VV9_NUMATE ) )
		while !VVA->( Eof() ) .and. VVA->VVA_FILIAL == VV9->VV9_FILIAL .and. VVA->VVA_NUMTRA == VV9->VV9_NUMATE

			//Formulas VVA
			if VVA->(FieldPos("VVA_MENPAD")) > 0 .And. !Empty(VVA->VVA_MENPAD)

				cMsg := AllTrim(FORMULA(VVA->VVA_MENPAD))
				if !cMsg $ cMensCli
		     	  cMensCli += IIF(!Empty(cMensCli), "   ", "") + cMsg
				endif

    		endif

	    	 VVA->( DbSkip() )

    	enddo
     
	endif
   
	if Alltrim(VV9->VV9_NUMATE) $ cMensCli
  	  cMensCli += IIF(!Empty(cMensCli), "   ", "") + "Nro Atendimento: " + AllTrim(VV9->VV9_NUMATE)
    endif

endif
 
//Auto Pecas
VS1->( DbSetOrder(3) ) //VS1_FILIAL + VS1_NUMNFI + VS1_SERNFI
lAchouVS1 := VS1->( DbSeek(xFilial("VS1") + SF2->F2_DOC + SF2->F2_SERIE) )  //FATURAMENTO
if !lAchouVS1

	//Pesquisa Venda Direta
  	SL2->( DbSetOrder(3) ) //L2_FILIAL + L2_SERIE + L2_Doc
   if (lAchouVS1 := SL2->( DbSeek( xFilial("SL2") + SF2->F2_SERIE + SF2->F2_DOC) ) )  //FATURAMENTO

		nRecnoVS1 := U_PesqVS1(SL2->L2_NUM)
	    if (lAchouVS1 := nRecnoVS1 > 0)
	    	VS1->( DbGoTo(nRecnoVS1) )
		endif

	endif

endif

if lAchouVS1 //Fat ou Venda Direta

	lImpDsc := VS1->VS1_TIPORC $ "1/2" .And. VS1->VS1_VLBRNF == "1" //1=Sim
	if !Empty(VS1->VS1_CODVEN)

		//Vendedor
	    SA3->( DbSetOrder(1) ) 	//FILIAL+COD
		if SA3->( DbSeek( xFilial("SA3") + VS1->VS1_CODVEN ) )
			cMensCli += IIF(!Empty(cMensCli), "   ", "") + "Vendedor: " + AllTrim(VS1->VS1_CODVEN) + " " + AllTrim(SA3->A3_NOME)
		endif

	endif
   
	//Obs VS1
	if !Empty(VS1->VS1_MENPAD) 

		cMsg := AllTrim(FORMULA(VS1->VS1_MENPAD))
		if !cMsg $ cMensCli
	  	  cMensCli += IIF(!Empty(cMensCli), "   ", "") + cMsg
		endif

	endif
 	                 
	if !Empty(VS1->VS1_MENNOT) .And. !VS1->VS1_MENNOT $ cMensCli
		cMensCli += IIF(!Empty(cMensCli), "   ", "") + AllTrim(VS1->VS1_MENNOT)
	endif 
   
	if !VS1->VS1_NUMORC $ cMensCli
		cMensCli += IIF(!Empty(cMensCli), "   ", "") + " Nro Orcamento: " + AllTrim(VS1->VS1_NUMORC)
	endif 

endif
		
//Oficina
lAchouVOO := .F.
VOO->( DbSetOrder(4) ) //VOO_FILIAL + VOO_NUMNFI + VOO_SERNFI
lAchouVOO := VOO->( DbSeek( xFilial("VOO") + SF2->F2_DOC + SF2->F2_SERIE) )
if !lAchouVOO

	//Pesquisa Venda Direta - Servicos
	SL2->( DbSetOrder(3) ) //L2_FILIAL + L2_SERIE + L2_Doc
	if (lAchouVOO := SL2->( DbSeek( xFilial("SL2") + SF2->F2_SERIE + SF2->F2_DOC) ) )  //FATURAMENTO

		VFE->( DbSetOrder(1) ) //VFE_FILIAL + VFE_NUMORC
		VFE->( DbSeek(xFilial("VFE") + SL2->L2_NUM ) )

	    nRecnoVOO := U_PesqVOO(SL2->L2_NUM, VFE->VFE_NUMOSV, VFE->VFE_LIBVOO)
		if (lAchouVOO := nRecnoVOO > 0)
	    	VOO->( DbGoTo(nRecnoVOO) )
	    endif

 	 endif

endif

if lAchouVOO

	lImpDsc := .F.
	VS1->( DbSetOrder(6) ) //VS1_FILIAL + VS1_NUMOSV
	if VS1->( DbSeek(xFilial("VS1") + VOO->VOO_NUMOSV) ) .and. VS1->VS1_TIPORC $ "1/2" .And. VS1->VS1_VLBRNF == "1" //1=Sim
		lImpDsc := .T.
	endif
   
	//Menpad VOO
	if VOO->( FieldPos("VOO_MENPAD") ) > 0 .And. !Empty(VOO->VOO_MENPAD)

		cMsg := AllTrim(FORMULA(VOO->VOO_MENPAD))
		if !cMsg $ cMensCli
	  	  cMensCli += IIF(!Empty(cMensCli), "   ", "") + cMsg
		endif

	endif 
 	 
	//Obs VOO
	if !Empty(cMsg := Alltrim(MSMM(VOO->VOO_OBSMNF,80))) 

		if !cMsg $ cMensCli
			cMensCli += IIF(!Empty(cMensCli), "   ", "") + cMsg
		endif

	endif

	if !AllTrim(VOO->VOO_NUMOSV) $ cMensCli
		// cMensCli += IIF(!Empty(cMensCli), "   ", "") + "Nro Ordem Servio: " + AllTrim(VOO->VOO_NUMOSV)
	endif 

endif

//Ordem Servicos
lAchou := .F.
VEC->( DbSetOrder(4) ) //VEC_FILIAL + VEC_NUMNFI + VEC_SERNFI
if VEC->( DbSeek( xFilial("VEC") + SF2->F2_DOC + SF2->F2_SERIE ) )

	VO1->( DbSetOrder(1) )	//VO1_FILIAL + VO1_NUMOSV
	lAchou := VO1->( DbSeek( xFilial("VO1") + VEC->VEC_NUMOSV ) )

endif

if !lAchou

	VSC->( DbSetOrder(6) ) //VSC_FILIAL + VSC_NUMNFI + VSC_SERNFI
	if VSC->( DbSeek(xFilial("VSC") + SF2->F2_DOC + SF2->F2_SERIE ) )
	
  		VO1->( DbSetOrder(1) )	//VO1_FILIAL + VO1_NUMOSV
		lAchou := VO1->( DbSeek( xFilial("VO1") + VSC->VSC_NUMOSV ) )

	endif

endif 

if lAchou .And. !Empty(VO1->VO1_FUNABE)

	//Vendedor
	VAI->( DbSetOrder(1) )	//FILIAL+COD
	if VAI->(DbSeek(xFilial("VAI") + VO1->VO1_FUNABE ) )
		//cMensCli += IIF(!Empty(cMensCli), "   ", "") + "Técnico: " + AllTrim(VO1->VO1_FUNABE) + " " + VAI->VAI_NOMTEC
	endif

endif

cAliasD2 := GetNextAlias()
BeginSql Alias cAliasD2
				COLUMN D2_ENTREG AS DATE
		SELECT D2_FILIAL,D2_SERIE,D2_DOC,D2_CLIENTE,D2_LOJA,D2_COD,D2_TES,D2_NFORI,D2_SERIORI,D2_ITEMORI,D2_TIPO,D2_ITEM,D2_CF,
					D2_QUANT,D2_TOTAL,D2_DESCON,D2_VALFRE,D2_SEGURO,D2_PEDIDO,D2_ITEMPV,D2_DESPESA,D2_VALBRUT,D2_VALISS,D2_PRUNIT,
					D2_CLASFIS,D2_PRCVEN,D2_IDENTB6,D2_CODISS,D2_DESCZFR,D2_PREEMB,D2_DESCZFC,D2_DESCZFP,D2_LOTECTL,D2_NUMLOTE,D2_ICMSRET,D2_VALPS3,
					D2_ORIGLAN,D2_VALCF3,D2_VALIPI,D2_VALACRS,D2_PICM,D2_PDV
		FROM %Table:SD2% SD2
					WHERE
					SD2.D2_FILIAL  = %xFilial:SD2% AND
					SD2.D2_SERIE   = %Exp:SF2->F2_SERIE% AND
					SD2.D2_DOC     = %Exp:SF2->F2_DOC% AND
					SD2.D2_CLIENTE = %Exp:SF2->F2_CLIENTE% AND
					SD2.D2_LOJA    = %Exp:SF2->F2_LOJA% AND
					SD2.%NotDel%
		ORDER BY D2_FILIAL,D2_DOC,D2_SERIE,D2_CLIENTE,D2_LOJA,D2_ITEM,D2_COD
EndSql

nCont := 1
while !(cAliasD2)->( Eof() ) .and. xFilial("SD2") == (cAliasD2)->D2_FILIAL .And.;
		SF2->F2_SERIE == (cAliasD2)->D2_SERIE .And.;
		SF2->F2_DOC == (cAliasD2)->D2_DOC .And. SF2->F2_CLIENTE == (cAliasD2)->D2_CLIENTE .And.;
		SF2->F2_LOJA == (cAliasD2)->D2_LOJA

  	SB1->(dbSetOrder(1))             
  	SB1->(DbSeek(xFilial("SB1")+(cAliasD2)->D2_COD)) // posiciona SB1
		
  	SC5->(dbSetOrder(1))
  	SC5->(DbSeek(xFilial("SC5")+(cAliasD2)->D2_PEDIDO)) // Posiciona cabecalho do pedido

  	SC6->(dbSetOrder(1))
  	SC6->(DbSeek(xFilial("SC6")+(cAliasD2)->D2_PEDIDO+(cAliasD2)->D2_ITEMPV+(cAliasD2)->D2_COD))   // Posiciona Item do Pedido 07/08/2007

  	SF4->(dbSetOrder(1))
  	SF4->( DbSeek( xFilial("SF4")+(cAliasD2)->D2_TES))
               
	//--- Posiciona Item 
	nCont := val((cAliasD2)->D2_ITEM) 
	
	if (lAchouVS1 .And. lImpDsc) .Or. (lAchouVOO .And. lImpDsc) .Or. (lVeic)

		//Adiciona na TAG infadProd
		if (cAliasD2)->D2_DESCON > 0 .And. nCont > 0 .And. Len(aProd) > 0
		   	 aProd[nCont, 25] += IIF(!Empty(aProd[nCont, 25]), "  ", "") + "Desc: R$ " + AllTrim(Transform((cAliasD2)->D2_DESCON, "@E 999,999.99"))
   		endif

	endif

	//---	NFE TOTVS DMS - INICIO
	//------ MÁQUINAS / EQUIPAMENTOS ------
	if AllTrim( SF2->F2_PREFORI ) $ "VEI" .OR. SD2->D2_GRUPO $ "VEIC"

		cChaveV1 := xFilial("VV1")+SubStr( (cAliasD2)->D2_COD,6,6)

		VV1->( DbSetOrder(1) )							
		if VV1->( DbSeek(cChaveV1) )

			cDescProd := "Chassi: " + AllTrim( VV1->VV1_CHASSI ) + CRLF							
			cDescProd += "Marca: "  + AllTrim( Posicione( "VE1", 1, xFilial( "VE1" ) + VV1->VV1_CODMAR, "VE1_DESMAR" ) )  + CRLF
			cDescProd += "Modelo: " + AllTrim( Posicione( "VV2", 1, xFilial( "VV2" ) +VV1->VV1_CODMAR+VV1->VV1_MODVEI, "VV2_DESMOD" ) ) + CRLF

//			if AllTrim( VV1->VV1_ESTVEI ) == "1"    
//			  cDescProd += "Tipo: Usado " + " " + cSeparador1	
//			else                                                         
//			  cDescProd += "Tipo: Novo  " + " " + cSeparador1
//			endif 

			aProd[nCont][04] := cDescProd
	
		//----- OFINAS / PEÇAS ------
		elseif AllTrim( SF2->F2_PREFORI ) $ "OFI|BAL"
			cDescProd := iif( Empty(SC6->C6_DESCRI),SB1->B1_DESC,SC6->C6_DESCRI)
			aProd[nCont][04] := cDescProd

		else // alterado por Whilton em 02.01.2013 para gravar descricao de NF geradas pelo Faturamento. 
			cDescProd := IIF(Empty(SC6->C6_DESCRI),SB1->B1_DESC,SC6->C6_DESCRI)
			aProd[nCont][04] := cDescProd

		endif

	endif
	//--- NFE TOTVS DMS - FIM

	(cAliasD2)->( DbSkip() )

enddo
(cAliasD2)->( DbCloseArea() )

RestArea(aArea)
Return({aProd,cMensCli,cMensFis,aDest,aNota,aInfoItem,aDupl,aTransp,aEntrega,aRetirada,aVeiculo,aReboque,aNfVincRur})


//--
User Function PesqVS1(cL2_NUM)             
Local aArea := GetArea()
Local nRecno:= 0

cSql := "SELECT R_E_C_N_O_ RECNO_VS1"
	cSql += " FROM " + RetSQLName("VS1")
	cSql += " WHERE VS1_FILIAL = '" + xFilial("VS1") + "' AND D_E_L_E_T_ <> '*'"
	cSql += " AND VS1_PESQLJ = '" + cL2_NUM  + "'" 
cSql := ChangeQuery(cSql)
TcQuery cSql New Alias "QRYVS1"
	
if !QRYVS1->( Eof() )
	nRecno := QRYVS1->RECNO_VS1
endif
	
QRYVS1->(DbCloseArea())
RestaRea(aArea)
Return(nRecno)                    


//-- 
User Function PesqVOO(cL2_NUM, cNumOSV, cLibVOO)             
Local aArea := GetArea()
Local nRecno:= 0

Default cNumOSV := ""
Default cLibVOO := ""

//Pesquisa pelo Venda Direta
cSql := "SELECT R_E_C_N_O_ RECNO_VOO"
	cSql += " FROM " + RetSQLName("VOO")
	cSql += " WHERE VOO_FILIAL = '" + xFilial("VOO") + "' AND D_E_L_E_T_ <> '*'"
	cSql += " AND VOO_PESQLJ = '" + cL2_NUM  + "'" 

cSql := ChangeQuery(cSql)
TcQuery cSql New Alias "QRYVOO"

if !QRYVOO->( Eof() )
	nRecno := QRYVOO->RECNO_VOO

elseif !Empty(cNumOSV)

	 //-- Pesquisa pelo Nro OS + Lib OS
 	QRYVOO->( DbCloseArea() )
	
	cSql := "SELECT R_E_C_N_O_ RECNO_VOO"
	 	cSql += " FROM " + RetSQLName("VOO")
	 	cSql += " WHERE VOO_FILIAL = '" + xFilial("VOO") + "' AND D_E_L_E_T_ <> '*'"
	 	cSql += " AND VOO_NUMOSV = '" + cNumOSV  + "'" 
	 	cSql += " AND VOO_LIBVOO = '" + cLibVOO  + "'" 

 	cSql := ChangeQuery(cSql)
 	TcQuery cSql New Alias "QRYVOO"

 	if !QRYVOO->( Eof() )
 		nRecno := QRYVOO->RECNO_VOO
	endif

endif
	
QRYVOO->( DbCloseArea() )
RestaRea(aArea)
Return(nRecno)                    


//---
User Function RDadVO3(cNUMOSV, cCodPro)
Local aArea := GetArea()
Local cPedCom := "", cItemPC := ""

cSql := "SELECT VO3_PEDXML, VO3_ITEXML "
	cSql += " FROM " + RetSQLName("VO3")
	cSql += " WHERE VO3_FILIAL = '" + xFilial("VO3") + "' AND D_E_L_E_T_ <> '*'"
	cSql += " AND VO3_NUMOSV = '" + cNUMOSV  + "'" 
	cSql += " AND VO3_CODITE = '" + cCodPro  + "'" 

cSql := ChangeQuery(cSql)
TcQuery cSql New Alias "QRYVO3"
	
if !QRYVO3->( Eof() )
	cPedCom := Alltrim(QRYVO3->VO3_PEDXML)
	cItemPC := Alltrim(QRYVO3->VO3_ITEXML)
endif
	
QRYVO3->( DbCloseArea() )
RestaRea(aArea)
Return({cPedCom, cItemPC}) 



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ConvType  ºAutor  ³Microsiga           º Data ³  28/05/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ConvType(xValor,nTam,nDec)
Local cNovo := ""
DEFAULT nDec := 0                                     

Do Case
	Case ValType(xValor)=="N"
		If xValor <> 0
			cNovo := AllTrim(Str(xValor,nTam,nDec))	
		Else
			cNovo := "0"
		EndIf
	Case ValType(xValor)=="D"
		cNovo := FsDateConv(xValor,"YYYYMMDD")
		cNovo := SubStr(cNovo,1,4)+"-"+SubStr(cNovo,5,2)+"-"+SubStr(cNovo,7)
	Case ValType(xValor)=="C"
		If nTam==Nil
			xValor := AllTrim(xValor)
		EndIf
		DEFAULT nTam := 60
		cNovo := AllTrim(EnCodeUtf8(NoAcento(SubStr(xValor,1,nTam))))
EndCase
Return(cNovo)