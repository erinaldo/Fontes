#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ FINR940	³ Autor ³ Nilton Pereira        ³ Data ³ 02.08.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relacao de titulos a receber com rentencao PIS/Cofins/CSLL ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FINR940(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ ESPECIFICO CSU                                             ³±±
±±³ 		 ³ DESENVOLVIDO POR ROBERTO R.MEZZALIRA     12/06/06          ³±±
±±³ 		 ³ BASEADO NO PADRAO INCLUSO FILTRO PARA TITULOS BAIXADOS     ³±±
±±³ 		 ³ CONF.ORDEM SERVICO 0814/06                                 ³±±  
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
USER Function CSUR814()

Local cDesc1    := "Imprime a relacao dos titulos a receber que sofreram retencao de Impostos"
Local cDesc2    := ""
Local cDesc3    := ""
Local wnrel
Local cString   := "SE1" //Contas a Receber
Local nRegEmp   := SM0->(RecNo())
Local aTam	    := TAMSX3("E1_NUM")

Private titulo  := ""
Private cabec1  := ""
Private cabec2  := ""
Private aLinha  := {}
Private aReturn := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 } 
Private aOrd    := { "Por Codigo Cliente+Prefixo+Numero","Por Nome Cliente"} //"Por Codigo Cliente"###"Por Nome Cliente"
Private cPerg	 := PADR("CSU814",LEN(SX1->X1_GRUPO))
Private nJuros  := 0
Private nLastKey:= 0
Private nomeprog:= "CSUR814"
Private tamanho := "G"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetKey (VK_F12,{|a,b| AcessaPerg("CSU814",.T.)})
			
CriaSX1(cPerg)

pergunte("CSU814",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Defini‡„o dos cabe‡alhos ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF  MV_PAR09 == 1
    titulo := "Títulos Recebidos com retenção de impostos"
ELSE
    titulo := "Titulos a Receber com retencao de Impostos"
ENDIF
cabec1 := "Codigo         Nome do Cliente                CGC"
cabec2 := "     Prf Numero      Pc  Tipo  Dt Emissao Dt.Vencto  Dt.Baixa    Valor Original           Valor IRFF       Valor ISS      Valor INSS       Valor PIS    Valor COFINS      Valor CSLL   Valor Liquido  Fil."
//         123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.123456789.12
//                  1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20        21
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros ³
//³ mv_par01		 // Do cliente?      ³
//³ mv_par02		 // Ate o Cliente?   ³
//³ mv_par03		 // Da loja?         ³
//³ mv_par04		 // Ate a loja?      ³
//³ mv_par05		 // Da Emissao?	     ³
//³ mv_par06		 // Ate Emissao?     ³
//³ mv_par07		 // Do Vencto?		 ³
//³ mv_par08		 // Ate Vencto?      ³ 
//³ mv_par09		 // Só Tit.Recebidos ³ 
//³ mv_par10		 // Data Baixa de?	 ³
//³ mv_par11		 // Data Baixa Ate ? ³
//³ mv_par12		 // Filial de      ? ³
//³ mv_par13		 // Filial ate     ? ³
//Andre , acrescentei esses dois parametros, de e ate
//talvez seja necessario voce deletar no sx1 o nome "CSU814", assim ele cria de novo
//e ja inclui o parametro que eu adicionei no progrma la em baixo.
//³ mv_par14		 // UUNN   de      ? ³
//³ mv_par15		 // UUNN  ate      ? ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a fun‡„o SETPRINT ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="CSUR814"            //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,"",.F.)

If nLastKey == 27
	Return
Endif
SetDefault(aReturn,cString)
If nLastKey == 27
	Return
Endif
RptStatus({|lEnd| FA814Imp(@lEnd,wnRel,cString)},titulo)  // Chamada do Relatorio

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ FA940Imp ³ Autor ³ Nilton Pereira        ³ Data ³ 29.07.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rotina de impressao dos titulos com rentecao de impostos   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FA940Imp(lEnd,WnRel,cString)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd	  - A‡Æo do Codeblock                                ³±±
±±³			 ³ wnRel   - T¡tulo do relat¢rio                              ³±±
±±³			 ³ cString - Mensagem                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FA814Imp(lEnd,WnRel,cString)

Local CbCont
Local CbTxt
Local cCGCAnt
Local cChaveSe1
Local lContinua	:= .T.
Local nTitCli	:= 0
Local nTitRel	:= 0
Local nVlCliOri	:= 0
Local nVlCliIns	:= 0
Local nVlCliLiq	:= 0
Local nVlTotOri	:= 0
Local nVlTotIns	:= 0
Local nVlTotPis	:= 0
Local nVlTotCof	:= 0
Local nVlTotCsl	:= 0
Local nVlTotIrf	:= 0 
Local nVlCliIrf	:= 0
Local nVlTotIss	:= 0 
Local nVlCliIss	:= 0
Local nVlTotSes	:= 0 
Local nVlCliSes	:= 0
Local nVlCliPis	:= 0
Local nVlCliCof	:= 0
Local nVlCliCsl	:= 0
Local nVlTotLiq	:= 0
Local aCampos	:= {}                                   
Local cCodCli	:= ""
Local cLojCli	:= ""
Local cNomCli	:= ""                       
Local aTamNum	:= TAMSX3("E1_NUM")
Local nOrdem	:= aReturn[8]   
Local nValBase := 0
Local lAbatImp := .F.
Local lContrAbt := !Empty( SE1->( FieldPos( "E1_SABTPIS" ) ) ) .And. !Empty( SE1->( FieldPos( "E1_SABTCOF" ) ) ) .And. ; 
						 !Empty( SE1->( FieldPos( "E1_SABTCSL" ) ) ) 
Local nValorLiq := 0
Local nVLPIS    := 0
Local nVLCOF    := 0
Local nVLCSLL   := 0
        
aCampos	:= {	{"CODIGO"	,"C",06,0 },;
				{"LOJA"	,"C",02,0 },;
				{"NOMECLI"	,"C",40,0 },;
				{"CGC"		,"C",14,0 },;
				{"PREFIXO"	,"C",03,0 },;
				{"NUM"		,"C",aTamNum[1],0 },;
				{"PARCELA"	,"C",TamSx3("E1_PARCELA")[1],0 },;
				{"RECISS"	,"C",03,0 },;
				{"TIPO"		,"C",03,0 },;
				{"EMISSAO"	,"D",08,0 },;
				{"VENCTO"	,"D",08,0 },;
  			    {"BAIXA"	,"D",08,0 },;
				{"VALBASE"  ,"N",17,2 },;
				{"VALINSS"	,"N",17,2 },;
				{"VALPIS"	,"N",17,2 },;
				{"VALCOF"	,"N",17,2 },;
				{"VALCSLL"	,"N",17,2 },;
				{"VALIRRF"	,"N",17,2 },;
				{"VALISS"	,"N",17,2 },;
				{"SABTCOF"	,"N",17,2 },;
				{"SABTCSL"	,"N",17,2 },;
				{"SABTPIS"	,"N",17,2 },;
				{"VALLIQ"	,"N",17,2 },;
               	{"FILIAL"	,"C",2,0 }}
				
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Vari veis utilizadas para Impress„o do Cabe‡alho e Rodap‚ ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt 	:= ""
cbcont	:= 1
li 		:= 80
m_pag 	:= 1

dbSelectArea("SE1")

If nOrdem == 1  //Por Codigo +Prefixo+Documento
	dbSetOrder(2)
Else            //Por Nome
	dbSetOrder(2)
Endif

cChaveSe1 := IndexKey()

	If nOrdem == 1  //Por Codigo
		cOrder := "CODIGO,LOJA,PREFIXO,NUM"
	Else            //Por Nome
		cOrder := "NOMECLI"
	Endif
	
	cQuery := "SELECT A1_COD CODIGO,A1_LOJA LOJA,A1_NOME NOMECLI,A1_CGC CGC,A1_RECISS RECISS,E1_PREFIXO PREFIXO,"
	cQuery += " E1_NUM NUM,E1_PARCELA PARCELA,E1_TIPO TIPO,E1_EMISSAO EMISSAO,E1_VENCREA VENCTO,E1_BAIXA BAIXA,"
//	cQuery += " E1_IRRF VALIRRF,E1_ISS VALISS,E1_INSS VALINSS,"
  	cQuery += " E1_IRRF VALIRRF,E1_INSS VALINSS,"
  	cQuery += " E1_PIS VALPIS,E1_COFINS VALCOF,E1_CSLL VALCSLL,"	
	cQuery += " E1_VALOR VALBASE,"
//Andre
//Eu nao estou mais deduzindo o valor F2_VALISS do liquido, pois ja esta fazendo isso na linha 302
    cQuery += "(E1_VALOR-E1_IRRF-E1_INSS-E1_PIS-E1_COFINS-E1_CSLL ) VALLIQ,"
//	cQuery += "(E1_VALOR-E1_IRRF-F2_VALISS-E1_INSS-E1_PIS-E1_COFINS-E1_CSLL ) VALLIQ,"
	cQuery += " F2_VALISS VALISS,F2_FILIAL FILIAL"
	If lContrAbt
		cQuery += " ,E1_SABTPIS SABTPIS,E1_SABTCOF SABTCOF, E1_SABTCSL SABTCSL"
	Endif
	cQuery += " FROM "+RetSqlName("SE1")+" SE1,"
	cQuery +=          RetSqlName("SA1")+" SA1, "
	cQuery +=          RetSqlName("SF2")+" SF2 "
	cQuery += " WHERE SE1.E1_FILIAL = '" + xFilial("SE1") + "'"
	cQuery += " AND SA1.A1_FILIAL   = '" + xFilial("SA1") + "'"
	cQuery += " AND SE1.D_E_L_E_T_  <> '*' "
	cQuery += " AND SA1.D_E_L_E_T_  <> '*' "
	cQuery += " AND SE1.E1_CLIENTE  =  SA1.A1_COD"
	cQuery += " AND SE1.E1_LOJA	  =  SA1.A1_LOJA"
	cQuery += " AND SE1.E1_CLIENTE  between '" + mv_par01 + "' AND '" + mv_par02 + "'"
	cQuery += " AND SE1.E1_LOJA     between '" + mv_par03 + "' AND '" + mv_par04 + "'"
	cQuery += " AND (E1_PIS > 0 OR E1_COFINS > 0"
	cQuery += " OR E1_CSLL > 0 OR E1_IRRF > 0 "
	cQuery += " OR E1_INSS > 0 OR E1_ISS > 0)"
	cQuery += " AND SE1.E1_VENCREA  between '" + DTOS(mv_par07)  + "' AND '" + DTOS(mv_par08) + "'"
	cQuery += " AND SE1.E1_EMISSAO  between '" + DTOS(mv_par05)  + "' AND '" + DTOS(mv_par06) + "'"
	cQuery += " AND SE1.E1_EMISSAO  <= '"      + DTOS(dDataBase) + "'"
	cQuery += " AND SE1.E1_CLIENTE  =  SF2.F2_CLIENTE"
	cQuery += " AND SE1.E1_LOJA	    =  SF2.F2_LOJA"
	cQuery += " AND SE1.E1_NUM      =  SF2.F2_DOC"
    cQuery += " AND SE1.E1_PREFIXO	=  SF2.F2_SERIE"
    cQuery += " AND SE1.E1_AREAN  between '" + mv_par14 + "' AND '" + mv_par15 + "' "
	cQuery += " AND SF2.F2_FILIAL between '" + mv_par12 + "' AND '" + mv_par13 + "' "		// Incluido por Daniel G.Jr. em 08/10/2007
	cQuery += " AND SF2.D_E_L_E_T_  <> '*' "

    IF MV_PAR09 == 1
       cQuery += " AND SE1.E1_BAIXA  between '" + DTOS(mv_par10)  + "' AND '" + DTOS(mv_par11) + "'"
    ENDIF
	cQuery += " ORDER BY "+ cOrder
	cQuery := ChangeQuery(cQuery)

	dbSelectArea("SE1")
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TRB', .F., .T.)
SetRegua(TRB->(Reccount()))

While !Eof() 
	IF lEnd
		@PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
		lContinua := .F.
		Exit
	EndIF
	IncRegua()
	IF li > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	EndIF

	nTitCli		:= 0
	nVlCliOri	:= 0
	nVlCliIns	:= 0
	nVlCliLiq	:= 0
	nVlCliPis	:= 0
	nVlCliCof	:= 0
	nVlCliCsl	:= 0
	nVlCliSes	:= 0
	nVlCliIrf	:= 0
	nVlCliIss	:= 0
	nValBase	:= 0

	@li,  0 PSAY Alltrim(TRB->CODIGO)+" - "+Alltrim(TRB->LOJA)
	@li, 15 PSAY Substr(TRB->NOMECLI,1,30)
	@li, 46 PSAY TRB->CGC Picture IIF(Len(Alltrim(TRB->CGC)) == 11 , "@R 999.999.999-99","@R 99.999.999/9999-99")
	li++

	cCodCli		:= TRB->CODIGO
	cLojCli		:= TRB->LOJA
	cNomCli		:= TRB->NOMECLI                       
	cCGCAnt		:= TRB->CGC    
		
	li++
	While !EOF() .And. cCodCli+cLojCli == TRB->(CODIGO+LOJA) .And. 	cNomCli == TRB->NOMECLI                       
		
		nValorLiq	:= TRB->VALLIQ
//Andre
//Andre, deixei aqui novamente habilitado porque tirei o VALISS do valor liquido la de cima, no select
		
		If TRB->RECISS == "1" .And. GetNewPar("MV_DESCISS",.F.) == .T.
			nValorLiq -= TRB->VALISS
		EndIf

		lAbatImp := .F.
		
		IF li > 58
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
		EndIF
	
		@li, 05 PSAY TRB->PREFIXO
		@li, 09 PSAY TRB->NUM
		
		@LI, 021 PSAY TRB->PARCELA
		@li, 025 PSAY TRB->TIPO

		@li, 031 PSAY STOD(TRB->EMISSAO)
		@li, 042 PSAY STOD(TRB->VENCTO) 
		@li, 053 PSAY STOD(TRB->BAIXA) 
		@li, 064 PSAY TRB->VALBASE		Picture tm (TRB->VALBASE ,15)			
		
		If	lContrAbt .And. (TRB->SABTCOF + TRB->SABTCSL +	TRB->SABTPIS) > 0
			lAbatImp := .T.
		    
		    nVLPIS  := 0
	        nVLCOF  := 0
		    nVLCSLL := 0
        
		ELSE	                    
		  	nVLPIS  := TRB->VALPIS		
	        nVLCOF  := TRB->VALCOF		
		    nVLCSLL := TRB->VALCSLL	
        Endif			
		
		@li, 085 PSAY TRB->VALIRRF		Picture tm (TRB->VALIRRF ,15)

//Andre
//Aqui eu coloquei a condicao se caso o RECISS == 1 e mais essa condicao que ja tinha
//nas linhas de cima, eu deixei tambem, mas so imprime o valor de reciss == 1
//ate acho que a linha de cima, que eu comentei talvez o cara quisesse exatamente isso
//que eu fiz aqui em baixo.

		If TRB->RECISS == "1" .And. GetNewPar("MV_DESCISS",.F.) == .T.
		   @li, 101 PSAY TRB->VALISS		Picture tm (TRB->VALISS  ,15)
        EndIf

		@li, 117 PSAY TRB->VALINSS  	Picture tm (TRB->VALINSS ,15)
        /*  original
        @li, 133 PSAY TRB->VALPIS		Picture tm (TRB->VALPIS  ,15)
	    @li, 149 PSAY TRB->VALCOF		Picture tm (TRB->VALCOF  ,15)
		@li, 165 PSAY TRB->VALCSLL		Picture tm (TRB->VALCSLL ,15)
          */        
        @li, 133 PSAY nVLPIS		Picture tm (TRB->VALPIS  ,15)
	    @li, 149 PSAY nVLCOF		Picture tm (TRB->VALCOF  ,15)
		@li, 165 PSAY nVLCSLL		Picture tm (TRB->VALCSLL ,15)
        
		If lAbatImp
    		@li, 181 PSAY nValorLiq + TRB->VALPIS + TRB->VALCOF + TRB->VALCSLL Picture tm (TRB->VALLIQ  ,15)		
			@li, 197 PSAY "A"
		Else
    	    @li, 181 PSAY nValorLiq		Picture tm (TRB->VALLIQ  ,15)
		Endif
   	    @li, 200 PSAY TRB->FILIAL

		li++
		nTitCli++
		nVlCliOri += TRB->VALBASE
		nVlCliLiq += nValorLiq
		nVlCliIns += TRB->VALINSS
		/* ORIGINAL
		nVlCliPis += TRB->VALPIS
		nVlCliCof += TRB->VALCOF
		nVlCliCsl += TRB->VALCSLL                  
		  */
		nVlCliIrf += TRB->VALIRRF                  
//Andre
//Nao estou somando valor do iss se condicao falsao, so soma se condicao verdadeira
		If TRB->RECISS == "1" .And. GetNewPar("MV_DESCISS",.F.) == .T.
           nVlCliIss += TRB->VALISS 
        EndIf

//		nVlCliIss += TRB->VALISS 
	    
	    dbSelectArea("SFQ")			
		dbSetOrder(1)
		IF dbSeek(TRB->Filial+"SE1"+TRB->PREFIXO+TRB->NUM+TRB->PARCELA+TRB->TIPO+TRB->CODIGO+TRB->LOJA)
			nVlCliPis += nVLPIS
	    	nVlCliCof += nVLCOF 
	    	nVlCliCsl += nVLCSLL 
	    ELSE
	      dbSelectArea("SFQ")			
		  dbSetOrder(2)
		  IF dbSeek(TRB->Filial+"SE1"+TRB->PREFIXO+TRB->NUM+TRB->PARCELA+TRB->TIPO+TRB->CODIGO+TRB->LOJA).AND. TRB->VALBASE < 5000
		    
	      ELSE  
		
	          IF !lAbatImp .AND. TRB->VALBASE < 5000
	              nVlCliPis += nVLPIS
	    	      nVlCliCof += nVLCOF 
	    	      nVlCliCsl += nVLCSLL 
	          ELSE
	              IF TRB->VALBASE > 5000
        	          nVlCliPis += nVLPIS
	        	      nVlCliCof += nVLCOF 
	    	          nVlCliCsl += nVLCSLL 
	              ENDIF
	          ENDIF
	        
	      ENDIF
	    ENDIF
	    dbSelectArea("TRB")			
		dbSkip()
	Enddo	
	li++
	IF nVlCliOri > 0 
		SubTot940(nTitCli,nVlCliOri,nVlCliIns,nVlCliLiq,cNomCli,cCgcAnt,nVlCliPis,nVlCliCof,nVlCliCsl,nVlCliSes,nVlCliIrf,nVlCliIss)
	Endif

	nTitRel	  += nTitCli
	nVlTotOri += nVlCliOri
	nVlTotLiq += nVlCliLiq
	nVlTotIns += nVlCliIns       
	nVlTotPis += nVlCliPis
	nVlTotCof += nVlCliCof
	nVlTotCsl += nVlCliCsl
	nVlTotIrf += nVlCliIrf
    nVlTotIss += nVlCliIss
Enddo


IF li != 80
	IF li > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	EndIF
	TotGeR940(nVlTotOri,nVlTotIns,nVlTotPis,nVlTotCof,nVlTotCsl,nVlTotLiq,nTitRel,nVlTotIrf,nVlTotIss,nVlTotSes)

	If lAbatImp
		IF li > 58
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
		EndIF
		@li, 001 PSAY "A = Os valores de Pis,Cofins e Csll deste titulo foram retidos em outro titulo."
		@li++
	Endif
	Roda(cbcont,cbtxt,"G")
EndIF

Set Device To Screen

dbSelectArea("SE1")
dbCloseArea()
ChKFile("SE1")
dbSelectArea("SE1")
dbSetOrder(1)
TRB->(dbCloseArea())

If aReturn[5] = 1
	Set Printer TO
	dbCommitAll()
	Ourspool(wnrel)
Endif
MS_FLUSH()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³SubTot940 ³ Autor ³ Nilton Pereira        ³ Data ³ 02.08.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Imprimir SubTotal do Relatorio                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ SubTot940()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function SubTot940(nTitCli,nVlCliOri,nVlCliIns,nVlCliLiq,cNomCli,cCgcAnt,nVlCliPis,nVlCliCof,nVlCliCsl,nVlCliSes,nVlCliIrf,nVlCliIss)

@li,000 PSAY Replicate("-",220)                              
li+=1     
@li,000 PSAY "Total Cliente  - " + Substr(cNomCli,1,09) 

@li,030 PSAY " ("+ALLTRIM(STR(nTitCli))+" "+IiF(nTitCli > 1,"TITULOS","TITULO")+")" //"TITULOS"###"TITULO"

@li,053 PSAY nVlCliOri		Picture TM(nVlCliOri,15)
@li,085 PSAY nVlCliIrf		Picture TM(nVlCliIrf,15)
//ARRUMAR AQUI NAO É PARA SAIR SE == 1
//@li,101 PSAY nVlCliIss		Picture TM(nVlCliIss,15)
@li,117 PSAY nVlCliIns		Picture TM(nVlCliIns,15)
@li,133 PSAY nVlCliPis		Picture TM(nVlCliLiq,15)
@li,149 PSAY nVlCliCof		Picture TM(nVlCliLiq,15)
@li,165 PSAY nVlCliCsl		Picture TM(nVlCliLiq,15)
@li,181 PSAY nVlCliLiq		Picture TM(nVlCliLiq,15)

li++
@li,000 PSAY Replicate("-",220)
li++
Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ TotGeR940³ Autor ³ Nilton Pereira        ³ Data ³ 02.08.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprimir total do relatorio                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ TotGeR940()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Finr940                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function TotGeR940(nVlTotOri,nVlTotIns,nVlTotPis,nVlTotCof,nVlTotCsl,nVlTotLiq,nTitRel,nVlTotIrf,nVlTotIss,nVlTotSes)

@li,000 PSAY Replicate("_",220)
li+= 2
@li,000 PSAY "TOTAL GERAL      ----> "
@li,030 PSAY "("+ALLTRIM(STR(nTitRel))+" "+IIF(nTitRel > 1,"TITULOS","TITULO")+")"	 //"TITULOS"###"TITULO"
@li,053 PSAY nVlTotOri	   Picture TM(nVlTotOri,15)
@li,085 PSAY nVlTotIrf		Picture TM(nVlTotIrf,15)
@li,101 PSAY nVlTotIss		Picture TM(nVlTotIss,15)
@li,117 PSAY nVlTotIns	   Picture TM(nVlTotIns,15)
@li,133 PSAY nVlTotPis		Picture TM(nVlTotPis,15)
@li,149 PSAY nVlTotCof		Picture TM(nVlTotCof,15)
@li,165 PSAY nVlTotCsl		Picture TM(nVlTotCsl,15)
@li,181 PSAY nVlTotLiq	   Picture TM(nVlTotLiq,15)
li++
@li,000 PSAY Replicate("_",220)
li++
Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³CriaSX1   ³ Autor ³ Nilton Pereira        ³ Data ³ 01.08.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Faz verificacao e cria as perguntas para execucao do rel.	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Finr940                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/	
Static Function CriaSX1(cPerg)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros ³
//³ mv_par01		 // Do cliente?      ³
//³ mv_par02		 // Ate o Cliente?   ³
//³ mv_par03		 // Da loja?         ³
//³ mv_par04		 // Ate a loja?      ³
//³ mv_par05		 // Da Emissao?	     ³
//³ mv_par06		 // Ate Emissao?     ³
//³ mv_par07		 // Do Vencto?		 ³
//³ mv_par08		 // Ate Vencto?      ³ 
//³ mv_par09		 // Só Tit.Recebidos ³ 
//³ mv_par10		 // Data Baixa de?	 ³
//³ mv_par11		 // Data Baixa Ate ? ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DbSelectArea("SX1")
//If MsSeek("FIN94008") // Se encontrar a pergunta 08, não faz nada, pois ja foi criada
//	Return
//Endif	                 

aPergs := {}
aHelpPor := {}
aHelpSpa := {}
aHelpEng := {}
AADD(aHelpPor,"Selecione o código inicial do intervalo ")
AADD(aHelpPor,"considerados na geração do relatório. "  )
AADD(aHelpPor,"Tecla [F3] disponível para consultar o " )
AADD(aHelpPor,"Cadastro de Clientes. "              )
AADD(aHelpSpa,"Selecione o código inicial do intervalo ")
AADD(aHelpSpa,"considerados na geração do relatório. "  )
AADD(aHelpSpa,"Tecla [F3] disponível para consultar o " )
AADD(aHelpSpa,"Cadastro de Clientes. "              )
AADD(aHelpEng,"Selecione o código inicial do intervalo ")
AADD(aHelpEng,"considerados na geração do relatório. "  )
AADD(aHelpEng,"Tecla [F3] disponível para consultar o " )
AADD(aHelpEng,"Cadastro de Clientes. "              )
Aadd(aPergs  ,{ "Do Cliente ?","Do Cliente ?","Do Cliente ?","mv_ch1","C",6,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA1","S","001","",aHelpPor,aHelpEng,aHelpSpa})

aHelpPor := {}
aHelpSpa := {}
aHelpEng := {}                                          
AADD(aHelpPor,"Selecione o código final do intervalo "  )
AADD(aHelpPor,"considerados na geração do relatório. "  )
AADD(aHelpPor,"Tecla [F3] disponível para consultar o " )
AADD(aHelpPor,"Cadastro de Clientes. "              )
AADD(aHelpSpa,"Selecione o código final do intervalo "  )
AADD(aHelpSpa,"considerados na geração do relatório. "  )
AADD(aHelpSpa,"Tecla [F3] disponível para consultar o " )
AADD(aHelpSpa,"Cadastro de Clientes. "              )
AADD(aHelpEng,"Selecione o código final do intervalo "  )
AADD(aHelpEng,"considerados na geração do relatório. "  )
AADD(aHelpEng,"Tecla [F3] disponível para consultar o " )
AADD(aHelpEng,"Cadastro de Clientes. "              )
Aadd(aPergs,{ "Ate o Cliente ?","Ate o Cliente ?","Ate o Cliente ?","mv_ch2","C",6,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SA1","S","001","",aHelpPor,aHelpEng,aHelpSpa})
              
aHelpPor := {}
aHelpSpa := {}
aHelpEng := {}
AADD(aHelpPor,"Informe a loja inicial do intervalo "    )
AADD(aHelpPor,"considerados na geração do relatório. "  )
AADD(aHelpSpa,"Informe a loja inicial do intervalo "    )
AADD(aHelpSpa,"considerados na geração do relatório. "  )
AADD(aHelpEng,"Informe a loja inicial do intervalo "    )
AADD(aHelpEng,"considerados na geração do relatório. "  )
Aadd(aPergs,{ "Da Loja ?","¿De Tienda ?","From Unit ?","mv_ch3","C",2,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","S","002","",aHelpPor,aHelpEng,aHelpSpa})
              
aHelpPor := {}
aHelpSpa := {}
aHelpEng := {}
AADD(aHelpPor,"Informe a loja final do intervalo "    )
AADD(aHelpPor,"considerados na geração do relatório. "  )
AADD(aHelpSpa,"Informe a loja final do intervalo "    )
AADD(aHelpSpa,"considerados na geração do relatório. "  )
AADD(aHelpEng,"Informe a loja final do intervalo "    )
AADD(aHelpEng,"considerados na geração do relatório. "  )
Aadd(aPergs,{ "Ate a Loja ?","¿A Tienda ?","To Unit ?","mv_ch4","C",2,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","S","002","",aHelpPor,aHelpEng,aHelpSpa})
              
aHelpPor := {}
aHelpSpa := {}
aHelpEng := {}
AADD(aHelpPor,"Informe a data inicial do intervalo de " )
AADD(aHelpPor,"datas de emissão dos títulos a receber " )
AADD(aHelpPor,"a Tecla [F3] disponível para consultar." )
AADD(aHelpSpa,"Informe a data inicial do intervalo de " )
AADD(aHelpSpa,"datas de emissão dos títulos a receber " )
AADD(aHelpSpa,"a Tecla [F3] disponível para consultar." )
AADD(aHelpEng,"Informe a data inicial do intervalo de " )
AADD(aHelpEng,"datas de emissão dos títulos a receber " )
AADD(aHelpEng,"a Tecla [F3] disponível para consultar." )
Aadd(aPergs,{ "Da Emissao ?","¿De Emision ?","From Issue Date ?","mv_ch5","D",8,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","S","","",aHelpPor,aHelpEng,aHelpSpa})
              
aHelpPor := {}
aHelpSpa := {}
aHelpEng := {}
AADD(aHelpPor,"Informe a data final do intervalo de "   )
AADD(aHelpPor,"datas de emissão dos títulos a receber " )
AADD(aHelpPor,"a Tecla [F3] disponível para consultar." )
AADD(aHelpSpa,"Informe a data final do intervalo de "   )
AADD(aHelpSpa,"datas de emissão dos títulos a receber " )
AADD(aHelpSpa,"a Tecla [F3] disponível para consultar." )
AADD(aHelpEng,"Informe a data final do intervalo de "   )
AADD(aHelpEng,"datas de emissão dos títulos a receber " )
AADD(aHelpEng,"a Tecla [F3] disponível para consultar." )
Aadd(aPergs,{ "Ate a Emissao ?","¿A  Emision ?","To Issue Date ?","mv_ch6","D",8,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","S","","",aHelpPor,aHelpEng,aHelpSpa})

Aadd(aPergs,{ "Do Vencimento ?","¿De Vencto. ?","From Due Date ?","mv_ch7","D",8,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","S","",""})
Aadd(aPergs,{ "Ate Vencimento?","¿A  Vencto. ?","To Due Date   ?","mv_ch8","D",8,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","S","",""})

Aadd(aPergs,{ "So Tit.Recebido?","So Tit.Recebido?","So Tit.Recebido","mv_ch9","N",1,0,0,"C","","mv_par09","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","","S","",""})
Aadd(aPergs,{ "Data Baixa de  ?","Data Baixa de  ?","Data Baixa de  ?","mv_cha","D",8,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","","S","",""})
Aadd(aPergs,{ "Data Baixa Ate ?","Data Baixa Ate ?","Data Baixa Ate ?","mv_chb","D",8,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","","S","",""})
///////////////////////////////////////////
// Incluido por Daniel G.Jr. em 08/10/2007
///////////////////////////////////////////
Aadd(aPergs,{ "Filial de      ?","Filial de      ?","Filial de      ?","mv_chc","C",2,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","","S","",""})
Aadd(aPergs,{ "Filial ate     ?","Filial ate     ?","Filial ate     ?","mv_chd","C",2,0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","","","S","",""})
//Andre, adicionei aqui essas duas linhas para serem inseridas automaicamente no sx1
//como disse, talvez tenha que apagar o sx1 com o nome "CSU814".
Aadd(aPergs,{ "UUNN  de       ?","UUNN   de      ?","UUNN   de      ?","mv_che","C",4,0,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","","","S","",""})
Aadd(aPergs,{ "UUNN ate       ?","UUNN   ate     ?","UUNN   ate     ?","mv_chf","C",4,0,0,"G","","mv_par15","","","","","","","","","","","","","","","","","","","","","","","","","","S","",""})
AjustaSx1("CSU814", aPergs)

Return