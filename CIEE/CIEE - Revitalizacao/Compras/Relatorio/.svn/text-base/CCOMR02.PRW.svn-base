#INCLUDE "rwmake.ch"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CCOMR02
Emissao de relatorio de produtos em ponto de pedido
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------

#IFDEF SPANISH
         #define STR0001  "Emite una relacion con los itemes en stock que llegaron al punto de"
         #define STR0002  "pedido, sugiriendo la cantidad a comprar."
         #define STR0003  "A Rayas"
         #define STR0004  "Administracion"
         #define STR0005  "Itemes en Punto de Pedido"
         #define STR0006  "PRODUCTO(S)"
         #define STR0007  "CODIGO          DESCRIPCION                    TP GRP  UM SALDO ACTUAL     PUNTO DE     STOCK DE         LOTE ___TOLERANCIA___     CANTIDAD   CANTIDAD A   VALOR ESTIMADO BASE FECHA DE   VALOR UNITARIO     PLAZO DE"
         #define STR0008  "                                                                             PEDIDO    SEGUIRDAD    ECONOMICO   %     CANTIDAD   POR EMBAL.      COMPRAR     DE LA COMPRA      REFERENCIA   DE LA COMPRA      ENTREGA"
         #define STR0009  "ANULADO POR EL OPERADOR"
         #define STR0010  "TOTAL GENERAL A COMPRAR"
		 #define STR0011  "Dia(s)"
#ELSE
   #IFDEF ENGLISH
         #define STR0001  "Prints a list of Inventory items that have reached the Point of"
         #define STR0002  "Order, suggesting the quantity to purchase"
         #define STR0003  "Z.Form "
         #define STR0004  "Management   "
         #define STR0005  "Items in Point of Order"
         #define STR0006  "PRODUCT(S)"
         #define STR0007  "CODE            DESCRIPT.                      TP GRP  UM  CURR.BALANCE   POINT OF      SECURITY      ECONOMIC___TOLERANCE ___   QUANTITY    QUANTITY TO   VALUE  ESTIMAT BASE  DATE OF   UNIT VALUE OF      DELIVERY"
         #define STR0008  "                                                                             ORDER         STOCK          LOT  %      QUANTITY   PER PACK.      PURCHASE      OF PURCHASE       REFERENC       PURCHASE          TERM"
         #define STR0009  "CANCELLED BY OPERATOR  "
         #define STR0010  "TOTAL TO PURCHASE"
		 #define STR0011  "Day(s)"
   #ELSE
         #define STR0001  "Emite uma relacao com os itens em estoque que atingiram o Ponto de"
         #define STR0002  "Pedido ,sugerimdo a quantidade a comprar."
         #define STR0003  "Zebrado"
         #define STR0004  "Administracao"
         #define STR0005  "Itens em Ponto de Pedido"
         #define STR0006  "PRODUTO(S)"
         #define STR0007  "CODIGO          DESCRICAO                      TP GRP  UM  SALDO ATUAL     PONTO DE   ESTOQUE DE         LOTE ___TOLERANCIA___   QUANTIDADE QUANTIDADE A   VALOR ESTIMADO BASE  DATA DE   VALOR UNITARIO     PRAZO DE"
         #define STR0008  "                                                                             PEDIDO    SEGURANCA    ECONOMICO   %   QUANTIDADE   POR EMBAL.      COMPRAR        DA COMPRA      REFERENCIA      DA COMPRA      ENTREGA"
         #define STR0009  "CANCELADO PELO OPERADOR"
         #define STR0010  "TOTAL GERAL A COMPRAR"
         #define STR0011  "Dia(s)"
   #ENDIF
#ENDIF

USER FUNCTION CCOMR02()
Local wnrel
Local Tamanho  := "G"
Local cDesc1   := STR0001	//"Emite uma relacao com os itens em estoque que atingiram o Ponto de"
Local cDesc2   := STR0002	//"Pedido, sugerimdo a quantidade a comprar."
Local cDesc3   := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis tipo Private padrao de todos os relatorios         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private nomeprog := "MATR440"
Private cString  := "SB1"
Private aReturn  := {OemToAnsi(STR0003), 1, OemToAnsi(STR0004), 1, 2, 1, "", 1}		//"Zebrado"###"Administracao"
Private nLastKey := 0, cPerg
Private titulo   := OemToAnsi(STR0005)		//"Itens em Ponto de Pedido"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Contadores de linha e pagina                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private li := 80, m_pag := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // Produto de                           ³
//³ mv_par02             // Produto ate                          ³
//³ mv_par03             // Grupo de                             ³
//³ mv_par04             // Grupo ate                            ³
//³ mv_par05             // Tipo de                              ³
//³ mv_par06             // Tipo ate                             ³
//³ mv_par07             // Local de                             ³
//³ mv_par08             // Local ate                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   
cPerg := "CCOMR02"
CriaSX1(cPerg)

Pergunte(cPerg, .F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cString, NomeProg, cPerg, @titulo, cDesc1, cDesc2, cDesc3, .F., "", .F., Tamanho)

If nLastKey = 27
	Set Filter To
	Return
Endif
SetDefault(aReturn, cString)
If nLastKey = 27
	Set Filter To
	Return
Endif
RptStatus({|lEnd| C2R02IMP(@lEnd, tamanho, wnrel, cString)}, Titulo)
Return .T.
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ C2R02IMP   ºAutor  ³ Totvs       	   º Data ³01/01/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Chamada do Relatorio  								      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
Static Function C2R02IMP(lEnd, tamanho, wnrel, cString)
Local nQuant := nSaldo := 0, nValUnit, nValor, nValTot, cTipoVal, nPrazo, _aAux1
Local nToler, nEstSeg, nNeces := 0
Local nCntImpr := 0
Local cRodaTxt := STR0006	//"PRODUTO(S)"
Local nTipo    := 0
Local cabec1, cabec2, cabec3
Local limite   := 132
Local cbCont   := 0
Local cLocCQ   := GetMV("MV_CQ")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa os codigos de caracter Comprimido/Normal da impressora ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nTipo  := IIF(aReturn[4] == 1, 15, 18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta os Cabecalhos                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cabec1 := STR0007
cabec2 := STR0008
***** "CODIGO          DESCRICAO                      TP GRP  UM  SALDO ATUAL     PONTO DE   ESTOQUE DE         LOTE ___TOLERANCIA___   QUANTIDADE QUANTIDADE A   VALOR ESTIMADO BASE  DATA DE   VALOR UNITARIO     PRAZO DE"
***** "                                                                             PEDIDO    SEGURANCA    ECONOMICO   %   QUANTIDADE   POR EMBAL.      COMPRAR        DA COMPRA      REFERENCIA      DA COMPRA      ENTREGA"
***** "123456789012345 123456789012345678901234567890 12 1234 12 9.999.999,99 9.999.999,99 9.999.999,99 9.999.999,99 999 9.999.999,99 9.999.999,99 9.999.999,99 9.999.999.999,99 XXXX 99/99/9999 999.999.999,99 99999 Dia(s)"
***** "0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21  "
***** "012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012"

dbSelectArea(cString)
Set Filter to B1_XAUTSC == "1" .and.;  // Gera SC por PP?  1 - Sim
(B1_GRUPO >= mv_par03 .and. B1_GRUPO <= mv_par04) .and.;
(B1_TIPO  >= mv_par05 .and. B1_TIPO  <= mv_par06) .and.;
SubStr(B1_COD, 1, 3) != "MOD" .and. B1_TIPO != "BN" .and. B1_CONTRAT != "S"

nValTot := 0
SetRegua(RecCount())

Set SoftSeek On
dbSeek(cFilial + mv_par01)
Set SoftSeek Off
Do While !Eof() .and. B1_FILIAL + B1_COD <= cFilial + mv_par02
	
	If lEnd
		@PROW() + 1, 001 PSAY STR0009		//"CANCELADO PELO OPERADOR"
		Exit
	Endif
	
	IncRegua()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra grupos e tipos nao selecionados e tambem se for MOD³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	/*
	If	(B1_GRUPO < mv_par03 .or. B1_GRUPO > mv_par04) .or.;
		(B1_TIPO  < mv_par05 .or. B1_TIPO  > mv_par06) .or.;
		SubStr(B1_COD, 1, 3) == "MOD" .or. B1_TIPO == "BN" .or.;
		B1_CONTRAT == "S"
		dbSkip()
		Loop
	Endif
	*/
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Direciona para funcao que calcula o necessidade de compra ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calcula o saldo atual de todos os almoxarifados ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	/*
	dbSelectArea("SB2")
	dbSeek(cFilial + SB1->B1_COD)
	Do While !eof() .and. B2_FILIAL + B2_COD == cFilial + SB1->B1_COD
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inclui os produtos que estao no C.Q.      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If  (B2_LOCAL < mv_par07 .or. B2_LOCAL > mv_par08) .or.;
			(B2_LOCAL == cLocCQ .and. mv_par11 == 2)
			dbSkip()
			Loop
		Endif
		nSaldo += (SaldoSB2(nil, nil, nil, mv_par12 == 1, mv_par13 == 1) + B2_SALPEDI) - B2_QPEDVEN
		dbSkip()
	EndDo
	*/
	/*
	nEstSeg := CalcEstSeg(SB1->B1_ESTFOR)
	nSaldo -= nEstSeg
	If (Round(nSaldo, 4) != 0) .or. (mv_par09 == 1)
		Do Case
			Case (SB1->B1_EMIN != 0 .and. MV_PAR09 == 1)
				nNeces := IIf((nSaldo < 0), Abs(nSaldo) + SB1->B1_EMIN, (SB1->B1_EMIN - nSaldo))
			Case (SB1->B1_EMIN != 0 .and. MV_PAR09 == 2)
				nNeces := IIf((nSaldo < 0), Abs(nSaldo), (SB1->B1_EMIN - nSaldo))
			Case (SB1->B1_LE != 0 .and. (nSaldo < 0  .or. mv_par09 == 2))
				If (MV_PAR10 == 2 .and. nSaldo < 0)
					nNeces := Abs(nSaldo) + SB1->B1_LE
				Else
					nNeces := If(Abs(nSaldo) < SB1->B1_LE, SB1->B1_LE, IIf(nSaldo < 0, Abs(nSaldo), 0))
				Endif
			OtherWise
				nNeces := IF(MV_PAR09 == 1, IIf(nSaldo < 0, Abs(nSaldo), 0), 0)
		EndCase
	Else
		If SB1->B1_EMIN != 0
			nNeces := (SB1->B1_EMIN)
		Else
			nNeces := 0
		Endif
	Endif
	*/
	/*
	If nNeces > 0
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se o produto tem estrutura                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SG1")
		If dbSeek(xFilial() + SB1->B1_COD)
			aQtdes := CalcLote(SB1->B1_COD, nNeces, "F")
		Else
			aQtdes := CalcLote(SB1->B1_COD, nNeces, "C")
		Endif
		For nX := 1 to Len(aQtdes)
			nQuant += aQtdes[nX]
		Next
	Endif
	dbSelectArea("SB1")
	*/
	_aAux1 := U_GeraSC(.F.)
	nSaldo := _aAux1[1]
	nQuant := _aAux1[2]
	
	If nQuant > 0
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Pega o prazo de entrega do material         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nPrazo := CalcPrazo(SB1->B1_COD, nQuant)
		dbSelectArea("SB1")
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Calcula a tolerancia do item                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nToler   := (B1_LE * B1_TOLER) / 100
		
		If li > 55
			Cabec(titulo, cabec1, cabec2, nomeprog, Tamanho, nTipo)
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Adiciona 1 ao contador de registros impressos         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nCntImpr++
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica qual dos precos e' mais recente servir de base ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If B1_UCOM < B1_DATREF
			cTipoVal := "STD"
			dData    := B1_DATREF
			nValUnit := B1_CUSTD
		Else
			cTipoVal := "U.CO"
			dData    := B1_UCOM
			nValUnit := B1_UPRC
		Endif
		nValor := nQuant * nValUnit
		
		@ li, 000 PSAY B1_COD
		@ li, 016 PSAY SubStr(B1_DESC, 1, 30)
		@ li, 047 PSAY B1_TIPO
		@ li, 050 PSAY B1_GRUPO
		@ li, 055 PSAY B1_UM
		@ li, 058 PSAY nSaldo    Picture PesqPictQt("B2_QATU", 12)
		@ li, 071 PSAY B1_EMIN   Picture PesqPictQt("B1_EMIN", 12)
		@ li, 084 PSAY nESTSEG   Picture PesqPictQt("B1_ESTSEG", 12)
		@ li, 097 PSAY B1_LE     Picture PesqPictQt("B1_LE", 12)
		@ li, 110 PSAY B1_TOLER  Picture "999"
		@ li, 114 PSAY nToler    Picture PesqPictQt("B1_LE", 12)
		@ li, 127 PSAY B1_QE     Picture PesqPictQt("B1_LE", 12)
		@ li, 140 PSAY nQuant    Picture PesqPictQt("B1_LE", 12)
		@ li, 153 PSAY nValor    Picture TM(nValor, 16)
		@ li, 170 PSAY cTipoVal
		@ li, 175 PSAY dData
		@ li, 186 PSAY nValUnit  Picture TM(nValUnit, 14)
		@ li, 201 PSAY nPrazo    Picture "99999"
		@ li, 207 PSAY OemtoAnsi(STR0011)  //  "Dia(s)"
		nValTot += nValor
		li++
	Endif
	
	nSaldo := 0
	nQuant := 0
	dbSelectArea("SB1")
	dbSkip()
EndDo

If li != 80
	Li++
	@ li, 000 PSAY STR0010 + Replicate(".", 131)		//"TOTAL GERAL A COMPRAR"
	@ li, 153 PSAY nValTot Picture TM(nValTot, 16)
	Roda(nCntImpr, cRodaTxt, Tamanho)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Devolve a condicao original do arquivo principal             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cString)
Set Filter To
Set Order To 1
If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif
MS_FLUSH()
Return .T.
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CriaSX1    ºAutor  ³ Totvs       	   º Data ³01/01/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Parametros da rotina									      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/ 
Static Function CriaSX1(cPerg)  
LOCAL aArea    	:= GetArea()
LOCAL aAreaDic 	:= SX1->( GetArea() )
LOCAL aEstrut  	:= {}
LOCAL aStruDic 	:= SX1->( dbStruct() )
LOCAL aSX1		:= {}
LOCAL nXa       := 0
LOCAL nXb       := 0
LOCAL nXc		:= 0
LOCAL nTam1    	:= Len( SX1->X1_GRUPO )
LOCAL nTam2    	:= Len( SX1->X1_ORDEM )
LOCAL lAtuHelp 	:= .F.            
LOCAL aHelp		:= {}	

aEstrut := { 'X1_GRUPO'  , 'X1_ORDEM'  , 'X1_PERGUNT', 'X1_PERSPA' , 'X1_PERENG' , 'X1_VARIAVL', 'X1_TIPO'   , ;
             'X1_TAMANHO', 'X1_DECIMAL', 'X1_PRESEL' , 'X1_GSC'    , 'X1_VALID'  , 'X1_VAR01'  , 'X1_DEF01'  , ;
             'X1_DEFSPA1', 'X1_DEFENG1', 'X1_CNT01'  , 'X1_VAR02'  , 'X1_DEF02'  , 'X1_DEFSPA2', 'X1_DEFENG2', ;
             'X1_CNT02'  , 'X1_VAR03'  , 'X1_DEF03'  , 'X1_DEFSPA3', 'X1_DEFENG3', 'X1_CNT03'  , 'X1_VAR04'  , ;
             'X1_DEF04'  , 'X1_DEFSPA4', 'X1_DEFENG4', 'X1_CNT04'  , 'X1_VAR05'  , 'X1_DEF05'  , 'X1_DEFSPA5', ;
             'X1_DEFENG5', 'X1_CNT05'  , 'X1_F3'     , 'X1_PYME'   , 'X1_GRPSXG' , 'X1_HELP'   , 'X1_PICTURE', ;
             'X1_IDFIL'   }

aAdd( aSX1, {cPerg,'01','Produto de         ?','¨De Producto       ?','From Product       ?','mv_ch1','C',15,0,0,'G','','mv_par01','','','','','','','','','','','','','','','','','','','','','','','','','SB1','','','','',''} )
aAdd( aSX1, {cPerg,'02','Produto at‚        ?','¨A  Producto       ?','To Product         ?','mv_ch2','C',15,0,0,'G','','mv_par02','','','','ZZZZZZZZZZZZZZZ','','','','','','','','','','','','','','','','','','','','','SB1','','','','',''} )
aAdd( aSX1, {cPerg,'03','Grupo de           ?','¨De Grupo          ?','From Group         ?','mv_ch3','C',4,0,0,'G','','mv_par03','','','','01','','','','','','','','','','','','','','','','','','','','','SBM','','','','',''} )
aAdd( aSX1, {cPerg,'04','Grupo at‚          ?','¨A  Grupo          ?','To Group           ?','mv_ch4','C',4,0,0,'G','','mv_par04','','','','12','','','','','','','','','','','','','','','','','','','','','SBM','','','','',''} )
aAdd( aSX1, {cPerg,'05','Tipo de            ?','¨De Tipo           ?','From Type          ?','mv_ch5','C',2,0,0,'G','','mv_par05','','','','ME','','','','','','','','','','','','','','','','','','','','','02','','','','',''} )
aAdd( aSX1, {cPerg,'06','Tipo at‚           ?','¨A  Tipo           ?','To Type            ?','mv_ch6','C',2,0,0,'G','','mv_par06','','','','ME','','','','','','','','','','','','','','','','','','','','','02','','','','',''} )
aAdd( aSX1, {cPerg,'07','Endereco de        ?','¨De Ubicacion      ?','From Address       ?','mv_ch7','C',2,0,0,'G','','mv_par07','','','','','','','','','','','','','','','','','','','','','','','','','','','','','',''} )
aAdd( aSX1, {cPerg,'08','Endereco ate       ?','¨A  Ubicacion      ?','To Address         ?','mv_ch8','C',2,0,0,'G','','mv_par08','','','','ZZ','','','','','','','','','','','','','','','','','','','','','','','','','',''} )

//
// Atualizando dicionário
//
dbSelectArea( 'SX1' )
SX1->( dbSetOrder( 1 ) )

For nXa := 1 To Len( aSX1 )
	If !SX1->( dbSeek( PadR( aSX1[nXa][1], nTam1 ) + PadR( aSX1[nXa][2], nTam2 ) ) )
		lAtuHelp:= .T.
		RecLock( 'SX1', .T. )
		For nXb := 1 To Len( aSX1[nXa] )
			If aScan( aStruDic, { |aX| PadR( aX[1], 10 ) == PadR( aEstrut[nXb], 10 ) } ) > 0
				SX1->( FieldPut( FieldPos( aEstrut[nXb] ), aSX1[nXa][nXb] ) )
			EndIf
		Next nXb
		MsUnLock()
	EndIf		
Next nXa

// Atualiza Helps
IF lAtuHelp        
	AADD(aHelp, {'01',{'Range inicial do produto.'},{''},{''}}) 
	AADD(aHelp, {'02',{'Range final do produto.'},{''},{''}}) 
	AADD(aHelp, {'03',{'Range inicial do grupo.'},{''},{''}}) 
	AADD(aHelp, {'04',{'Range final do grupo.'},{''},{''}}) 
	AADD(aHelp, {'05',{'Range inicial do tipo.'},{''},{''}}) 
	AADD(aHelp, {'06',{'Range final do tipo.'},{''},{''}}) 
	AADD(aHelp, {'07',{'Range inicial do endereco.'},{''},{''}})
	AADD(aHelp, {'08',{'Range final do endereco.'},{''},{''}})                                                          
			
	For nXc:=1 to Len(aHelp)
		PutHelp( 'P.'+cPerg+aHelp[nXc][1]+'.', aHelp[nXc][2], aHelp[nXc][3], aHelp[nXc][4], .T. )
	Next nXc 	

EndIf	

RestArea( aAreaDic )
RestArea( aArea )   
RETURN

User Function GeraSC(_lGeraSC, _nQuant)
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calcula o saldo atual de todos os almoxarifados.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
nSaldo += U_GetSld(SB1->B1_COD, .T., .T.)

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
//_nSldAux := nSaldo - SB1->B1_XPEQ //(SB1->B1_PE * U_GetConsMed(SB1->B1_COD)/30)
//_nSldAux := IIf (_nSldAux < 0, 0, _nSldAux)
_nSldAux := IIf (nSaldo < 0, 0, nSaldo)

// Calculo da necessidade.
nNeces := IIf (_nSldAux <= SB1->B1_EMIN, SB1->(B1_LE + B1_EMIN) - _nSldAux, 0)

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
Endif
OtherWise
nNeces := IF(MV_PAR09 == 1,IIf(nSaldo<0,Abs(nSaldo),0),0)
EndCase
Else
If SB1->B1_EMIN != 0
nNeces := SB1->B1_EMIN
Else
nNeces := 0
Endif
Endif
*/

If nNeces > 0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se produto tem estrutura.                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Pega o prazo de entrega do material         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nPrazo := CalcPrazo(SB1->B1_COD, nQuant)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gera solicitacao de compra                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cNumSolic := GetNumSC1(.T.)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ PDE para gravacao de fornecedor na solicitacao de compra. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ExistBlock("MS170FOR")
		aFornepad := Execblock("MS170FOR", .F., .F.)
		If ValType(aFornepad) == "A"
			cFornece := aFornepad[1]
			cLoja    := aFornepad[2]
		Endif
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Arredonda o valor da necessidade, de acordo com os        ³
	//³ parametros informados no cad. de produto.                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
		SC1->C1_XNUCIEE := cNumSolic		
		SC1->C1_ITEM    := "01"
		SC1->C1_EMISSAO := dDataBase
		SC1->C1_PRODUTO := SB1->B1_COD
		SC1->C1_LOCAL   := SB1->B1_LOCPAD
		SC1->C1_UM      := SB1->B1_UM
		SC1->C1_SEGUM   := SB1->B1_SEGUM
		SC1->C1_DESCRI  := SB1->B1_DESC
		SC1->C1_QUANT   := _nQtdeArre
		SC1->C1_XQTDCAL := nQuant  // Campo especifico CIEE.
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
		SC1->C1_XESPEC	:= SB1->B1_XESPEC
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