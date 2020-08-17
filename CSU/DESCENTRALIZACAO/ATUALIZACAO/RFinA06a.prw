#Include "Rwmake.ch"
#Include "Protheus.ch"

#DEFINE c_BR Chr(13)+Chr(10)
/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  Ё RFinA06a ╨ Autor Ё Cristiano Figueiroa╨ Data Ё  16/01/2006 ╨╠╠
╠╠лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Descricao Ё Tela de Rateio por Centro de Custo                         ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨ParametrosЁ Prefixo                                                    ╨╠╠
╠╠╨          Ё Numero                                                     ╨╠╠
╠╠╨          Ё Parcela                                                    ╨╠╠
╠╠╨          Ё Tipo                                                       ╨╠╠
╠╠╨          Ё Fornecedor                                                 ╨╠╠
╠╠╨          Ё Loja                                                       ╨╠╠
╠╠╨          Ё Valor a ser Rateado para a Natureza                        ╨╠╠
╠╠╨          Ё Opcao (2-Visualiza ; 3-Inclusao ; 4-Alteracao ; 5-Delecao) ╨╠╠
╠╠╨          Ё Natureza a ser Rateada por Centro de Custo                 ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё Csu CardSystem                                             ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/

User Function RFinA06A( cPreTit , cNumTit , cParTit , cTipTit , cForTit , cLojTit , nVlRat , nOpc , cNatTit )

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё              Declara as Variaveis Locais Utilizadas na Rotina              Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

Local   cPic	    := PesqPict("SE2" , "E2_VALOR" , 19 )
Local   oDlg
Local   oGet
Local   aButton     := {}
Local   aHeadOld    := aClone( aHeader)
Local   aColsOld    := aClone( aCols  )                                          

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁVG - 2011.02.28 - VariАveis para a rotina de rateio externo.Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
Local cAnoMes		:= ""
Local cUltRev		:= ""

Local   nOldPos     := n 
n := 1 // Incluido por Flavio Novaes em 04/04/07 - Chamado 000000000923.
/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё              Declara as Variaveis Private Utilizadas na Rotina             Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
Private cNaturez    := cNatTit
Private cNatTela    := "Natureza : ( " + Alltrim(cNaturez) + " ) - " +  Alltrim(Posicione("SED" , 1 , xFilial("SED") + cNaturez , "ED_DESCRIC"))
Private oValDRat
Private oPerDRat
Private nValRat     := nVlRat
Private nValDRat    := 0
Private nPerDRat    := 0
Private nPosCusEZ   := 0
Private nPosPerEZ   := 0
Private nPosValEZ   := 0
Private nPosDesEZ   := 0
Private nPosClaEZ   := 0
Private nPosIteEZ   := 0
Private nUsadoII    
Private aCols		:= {}
Private aHeader		:= {}
Private nRegs       := 0

Private cChave		:= cPreTit+cNumTit+cParTit+cTipTit+cForTit+cLojTit+cNatTit

//зддддддддддддддддддддддддддддддддддд©
//ЁVG - 2011.02.28                    Ё
//ЁCaso seja um documento com         Ё
//Ёrateio externo, verifica se existemЁ
//Ёitens preenchidos para a tabela    Ё
//Ёde rateio utilizada.               Ё
//юддддддддддддддддддддддддддддддддддды
If SF1->F1_XTABRAT == '1'

	//здддддддддддддддддддддддддддддддддддддддд©
	//ЁVerifica na SEV qual a tabela de rateio.Ё
	//юдддддддддддддддддддддддддддддддддддддддды
	dbSelectArea("SEV")
	dbSetOrder(1)//EV_FILIAL+EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA+EV_NATUREZ
	If dbSeek(xFilial("SEV")+cPreTit+cNumTit+cParTit+cTipTit+cForTit+cLojTit+cNatTit,.F.)

		//здддддддддддддддддддддддддддддддддддддддддд©
		//ЁVG - 2011.06.06 - alteraГЦo para utilizar Ё
		//Ёa data de competЙncia.                    Ё
		//юдддддддддддддддддддддддддддддддддддддддддды
		//cAnoMes	:= SUBSTR(DTOS(SF1->F1_EMISSAO),1,6)
		cAnoMes	:= U_GetCompetencia(SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
		cUltRev	:= U_RZB7ULTR(SEV->EV_XCODRAT,cAnoMes,.T.)
		
		//здддддддддддддддддддддддддд©
		//ЁProcura a tabela de rateioЁ
		//юдддддддддддддддддддддддддды
		dbSelectArea("ZB8")
		dbSetOrder(1)//ZB8_FILIAL+ZB8_CODRAT+ZB8_ANOMES+ZB8_REVISA+ZB8_SEQUEN
		If !dbSeek(xFilial("ZB8")+SEV->EV_XCODRAT+cAnoMes+cUltRev,.F.)
		
			Aviso("Aviso","A tabela de rateios utilizada ainda nЦo teve"+c_BR+;
				          "seus itens preenchidos. Por favor, entre em "+c_BR+;
				          "contato com o responsАvel pela manutenГЦo "+c_BR+;
				          "da tabela de rateio.",{"OK"},,"AtenГЦo",,"NOCHECKED")			
			Return .T.
		Endif
	Endif
Endif

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                    Adicao de Botoes na Enchoice Bar                        Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

If Inclui .Or. Altera	
	Aadd( aButton , {'PESQUISA'	, { || TrazRateio()  } , "Externo" } )
   	SetKey(VK_F7,{||TrazRateio()})
	If SF1->F1_XTABRAT <> '1'
		Aadd( aButton , {"DBG06" 	, { || U_FinA06aImp()}, "Importar cadastro", "Importar" }) 
		Aadd( aButton , {"PMSEXCEL"	, { || U_FinA06aExp()}, "Exportar cadastro", "Exportar" })
		Aadd( aButton , {"EXCLUIR"	, { || U_FinA06aDel()}, "Excluir Todos", "Exc. Todos" })
	   	SetKey(VK_F6,{||U_FinA06aImp()})
	   	SetKey(VK_F5,{||U_FinA06aExp()})
	   	SetKey(VK_F4,{||U_FinA06aDel()})
	 EndIf
Endif

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                  Monta o Aheader conforme a Tabela SEZ                     Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

GerAheSEZ()

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                  Monta o Acols conforme a Tabela SEZ                       Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

GerAcoSEZ()

If lMostraTela	

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                 Monta a Tela das Naturezas por Titulos                     Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

   Define MsDialog oDlg Title "Multipla Natureza por Centro de Custo" From 09.0 , 00.0 To 39.2 , 95.00 Of oMainWnd
   
   @ 027.6 , 010.0  Get cRazTela              	                   				Font oBold   Pixel  COLOR CLR_BLUE  Size 358 , 005 When .F.
   @ 039.6 , 010.0  Get cPreTela               	 	               	   			Font oBold   Pixel  COLOR CLR_BLUE  Size 070 , 005 When .F.
   @ 039.6 , 105.6  Get cNumTela                                   				Font oBold   Pixel  COLOR CLR_BLUE  Size 070 , 005 When .F.
//   @ 039.6 , 203.0  Get cParTela                                   	 			Font oBold   Pixel  COLOR CLR_BLUE  Size 070 , 005 When .F.
   @ 039.6 , 300.0  Get cTipTela                                   	 	  		Font oBold   Pixel  COLOR CLR_BLUE  Size 068 , 005 When .F.
                                                                     	
   @ 013.6 , 000.5  To 16.08  , 23.00 Of oDlg
   @ 013.6 , 023.4  To 16.08  , 46.05 Of oDlg 
   @ 001.0 , 000.5  To 03.85  , 46.50 Of oDlg
	
   @ 017.0 , 010.0  Say "Dados do Titulo"                          	   			Font oBoldIII Pixel COLOR CLR_BLUE
   
   @ 197.6 , 046.4  Say "Valor a Ratear "                       	   			Font oBoldIV  Pixel COLOR CLR_HBLUE 
   @ 197.6 , 086.6  Say nValRat Picture cPic                       	   			Font oBoldIV  Pixel COLOR CLR_HBLUE 

   @ 209.6 , 046.0  Say "Valor Rateado  "                       	   			Font oBoldIV  Pixel COLOR CLR_HBLUE 
   @ 209.6 , 086.6  Say oValDRat Var nValDRat Picture cPic      	   			Font oBoldIV  Pixel COLOR CLR_HBLUE 

   @ 197.6 , 200.0  Say "Percentual Distribuido:                           %"  	Font oBoldIV  Pixel COLOR CLR_HBLUE 
   @ 197.6 , 290.6  Say oPerDRat Var nPerDRat Picture "@E 999.999999"  			Font oBoldIV  Pixel COLOR CLR_HBLUE

   @ 209.6 , 200.0  Say cNatTela                                	   			Font oBoldIV  Pixel COLOR CLR_HBLUE 

 /*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
   Ё         Chama a Funcao que Atualiza o Campo do Valor Distribuido           Ё
   юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

   RecValSEZ()

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё             Chama a GetDados para Receber as Linhas do Acols               Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

   oGet := MSGetDados():New( 60 , 4 , 188 , 371 , nOpcao ,"U_VldLinCC", .T. ,, nOpcao # 2 ,,,,9999 )       
   
/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё             Ativa a Janela de Dialogo da Multipla Natureza                 Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
	
   Activate MsDialog oDlg On Init EnchoiceBar( oDlg , {||nOpca := 1 , If( VldTudCC() , oDlg:End() , nOpca := 0 )},{||nOpca:=0,oDlg:End()},, aButton ) Center 

Endif

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё Caso nao tenha ocorrido o Rateio por Centro de Custo volta o Flag para "Nao" Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

If nRegs == 0
   M->EV_RATEICC := "2"
Endif

/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                  Retorna as Variaveis Originais                     Ё
  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

aHeader := aHeadOld
aCols   := aColsOld
n       := nOldPos

Return .T.

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммямммммммммммкмммммммяммммммммммммммммммммкммммммямммммммммммм╩╠╠
╠╠╨Programa  Ё GerAheSEZ ╨ Autor Ё Cristiano Figueiroa╨ Data Ё 16/01/2006 ╨╠╠
╠╠лммммммммммьмммммммммммймммммммоммммммммммммммммммммйммммммомммммммммммм╧╠╠
╠╠╨Descricao Ё Gera o aHeader para a Tela de Centro de Custo              ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё Csu CardSystem                                             ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/

Static Function GerAheSEZ()

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                     Zera as Variaveis                        Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

nUsadoII  := 0
aHeader   := {}

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                     Monta o aHeader                          Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("SEZ")

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                     Monta o aHeader                          Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

Do While !Eof() .And. ( X3_ARQUIVO == "SEZ" )

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  ЁIgnora alguns campos que nao deverao ser adicionados no aHeader Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

   If  !( Alltrim(X3_CAMPO) $ ( "EZ_CCUSTO;EZ_PERC;EZ_VALOR;EZ_DESCRIC;EZ_ITEMCTA;EZ_CLVL" ) )
	   DbSkip()
	   Loop
   EndIf

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё               Adiciona os Campos no aHeader                    Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

   If X3Uso(X3_USADO) .And. cNivel >= X3_NIVEL
      Aadd( aHeader , { TRIM(X3_TITULO) , X3_CAMPO , X3_PICTURE , X3_TAMANHO , X3_DECIMAL , X3_VLDUSER , X3_USADO , X3_TIPO , X3_ARQUIVO , X3_CONTEXT } )
   Endif

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё               Adiciona algumas Validacoes                      Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

   If     Alltrim(aHeader[Len(aHeader)][2]) == "EZ_PERC" 
      aHeader[Len(aHeader)][6] := 'u_CalValEZ() .And. M->EZ_PERC > 0 .And. M->EZ_PERC < 100.01'
      aHeader[Len(aHeader)][3] := '@E 999.999999'
   ElseIf Alltrim(aHeader[Len(aHeader)][2]) == "EZ_VALOR"
      aHeader[Len(aHeader)][6] := 'u_CalPerEZ() .And. M->EZ_VALOR > 0'
   ElseIf Alltrim(aHeader[Len(aHeader)][2]) == "EZ_CCUSTO"
      //aHeader[Len(aHeader)][6] := 'ExistCpo("CTT") .And. u_VerCCBloq(M->EZ_CCUSTO) .And. Ctb105CC()'
      aHeader[Len(aHeader)][6] := 'ExistCpo("CTT") .And. u_VerCCBloq(M->EZ_CCUSTO)'
   ElseIf Alltrim(aHeader[Len(aHeader)][2]) == "EZ_ITEMCTA"
      //aHeader[Len(aHeader)][6] := 'ExistCpo("CTD") .And. Ctb105Item()'
      aHeader[Len(aHeader)][6] := 'ExistCpo("CTD")'
   ElseIf Alltrim(aHeader[Len(aHeader)][2]) == "EZ_CLVL"
      //aHeader[Len(aHeader)][6] := 'ExistCpo("CTH") .And. Ctb105ClVl()'
      aHeader[Len(aHeader)][6] := 'ExistCpo("CTH")'
   Endif   

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё            Processa o Proximo Registro do SX3                  Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

   DbSkip()
   Loop

EndDo

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё           Verifica a Quantidade de Itens no AHeader          Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

nUsadoII := Len(aHeader)

Return                        

/*
ээээээээээээээээээээээээээээъэээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммямммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  Ё GerAcoSEZ ╨ Autor Ё Cristiano Figueiroa╨ Data Ё  16/01/2006 ╨╠╠
╠╠лммммммммммьмммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Descricao Ё Gera o aCols de Acordo a Tela de Centro de Custos           ╨╠╠
╠╠лммммммммммьммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё Csu CardSystem                                              ╨╠╠
╠╠хммммммммммоммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/

Static Function GerAcoSEZ()

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё              Declara as Variaveis Locais Utilizadas na Rotina              Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

Local c := 1

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё         Verifica a Posicao dos Campos no aHeader             Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

VerPosSez()

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё   Caso seja Inclusao inclui uma linha em Branco no Acols     Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

If nOpcao == 3 .And. CUS->( Reccount() ) == 0

   N := 1

  /*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
    Ё    Chama a funcao que adiciona uma nova linha no Acols       Ё
    юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
   
   AdicCols()
   
Else

	//зддддддддддддддддддддддддддддддддддддддддддддд©
	//ЁVG - 2011.02.28                              Ё
	//ЁVerificar se utiliza tabela de rateio externoЁ
	//юддддддддддддддддддддддддддддддддддддддддддддды
	If SF1->F1_XTABRAT == '1'
		//здддддддддддддддддддддддддддддддддддддддд©
		//ЁVerifica na SEV qual a tabela de rateio.Ё
		//юдддддддддддддддддддддддддддддддддддддддды
		dbSelectArea("SEV")
		dbSetOrder(1)//EV_FILIAL+EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA+EV_NATUREZ
		If dbSeek(xFilial("SEV")+cChave,.F.)
	
			//здддддддддддддддддддддддддддддддддддддддддд©
			//ЁVG - 2011.06.06 - alteraГЦo para utilizar Ё
			//Ёa data de competЙncia.                    Ё
			//юдддддддддддддддддддддддддддддддддддддддддды
			//cAnoMes	:= SUBSTR(DTOS(SF1->F1_EMISSAO),1,6)
			cAnoMes	:= U_GetCompetencia(SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
			cUltRev	:= U_RZB7ULTR(SEV->EV_XCODRAT,cAnoMes,.T.)
		
			//здддддддддддддддддддддддддд©
			//ЁProcura a tabela de rateioЁ
			//юдддддддддддддддддддддддддды
			dbSelectArea("ZB8")
			dbSetOrder(1)//ZB8_FILIAL+ZB8_CODRAT+ZB8_ANOMES+ZB8_REVISA+ZB8_SEQUEN
			If dbSeek(xFilial("ZB8")+SEV->EV_XCODRAT+cAnoMes+cUltRev,.F.)
		
				//здддддддддддддддддддддддддддддддддддддддддд©
				//ЁCarregar o aCols com base nos itens da ZB8Ё
				//юдддддддддддддддддддддддддддддддддддддддддды
				Do While ZB8->(ZB8_FILIAL+ZB8_CODRAT+ZB8_ANOMES+ZB8_REVISA)==xFilial("ZB8")+SEV->EV_XCODRAT+cAnoMes+cUltRev
				
					Aadd ( aCols , Array( nUsadoII + 1) )

					/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
					  Ё                 Atribui as Colunas os Valores Ja Existentes                 Ё
					  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
					aCols[Len(aCols)][nPosCusEZ    ] := ZB8->ZB8_CCDBTO
					aCols[Len(aCols)][nPosDesEZ    ] := Posicione("CTT",1,xFilial("CTT")+ZB8->ZB8_CCDBTO,"CTT_DESC01")
					aCols[Len(aCols)][nPosClaEZ    ] := ZB8->ZB8_CLVLDB          
					aCols[Len(aCols)][nPosIteEZ    ] := ZB8->ZB8_ITDBTO            
					aCols[Len(aCols)][nPosValEZ    ] := (nValRat*ZB8->ZB8_PERCEN)/100
					aCols[Len(aCols)][nPosPerEZ    ] := ZB8->ZB8_PERCEN
//					aCols[Len(aCols)][nUsadoII + 1 ] := CUS->FLAG					
				     
					dbSelectArea("ZB8")
					dbSkip()
				EndDo
		
			Endif
		Endif
		
	Else

		/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		  Ё     Abre a Tabela Temporaria de Rateio de Centro de Custo    Ё
		  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

		DbSelectArea("CUS")       
		DbGoTop()

		/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		  Ё               Pesquisa no Temporario de ja existe a Natureza               Ё
		  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

		If DbSeek ( cNaturez  )

		/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		  Ё    Carrega no Acols todos os Centros de Custos Rateados para a Natureza    Ё
		  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

			Do While CUS->( !Eof() ) .And. CUS->NATUREZ == cNaturez

				If CUS->FLAG
					DbSkip()   
					Loop
				EndIf	
				/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				  |   Adiciona um Array no aCols Contendo o Numero de Colunas Usadas na Rotina  Ё
				  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

				Aadd ( aCols , Array( nUsadoII + 1) )

				/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				  Ё                 Atribui as Colunas os Valores Ja Existentes                 Ё
				  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

				aCols[c][nPosCusEZ    ] := CUS->CCUSTO
				aCols[c][nPosDesEZ    ] := CUS->DESCUS 
				aCols[c][nPosClaEZ    ] := CUS->CLASSE          
				aCols[c][nPosIteEZ    ] := CUS->ITEM            
				aCols[c][nPosValEZ    ] := CUS->VALOR 
				aCols[c][nPosPerEZ    ] := CUS->PERC
				aCols[c][nUsadoII + 1 ] := CUS->FLAG
        
				c++

				DbSkip()   
				Loop
			Enddo

		Endif   
  	Endif
         
Endif

Return

/*
ээээээээээээээээээээээээээээъээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  Ё VerPosCpoSez ╨ Autor Ё Cristiano Figueiroa╨ Data Ё  26/12/2005 ╨╠╠
╠╠лммммммммммьммммммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Descricao Ё Ver a Posicao dos Campos no aHeader do Centro de Custo         ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё Csu CardSystem                                                 ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/

Static Function VerPosSez()

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё         Verifica a Posicao dos Campos no aHeader             Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

nPosCusEZ   := aScan( aHeader , { |x| Upper( Trim ( x[2] ) ) == "EZ_CCUSTO"  })
nPosPerEZ   := aScan( aHeader , { |x| Upper( Trim ( x[2] ) ) == "EZ_PERC"    })
nPosValEZ   := aScan( aHeader , { |x| Upper( Trim ( x[2] ) ) == "EZ_VALOR"   })
nPosDesEZ   := aScan( aHeader , { |x| Upper( Trim ( x[2] ) ) == "EZ_DESCRIC" })
nPosClaEZ   := aScan( aHeader , { |x| Upper( Trim ( x[2] ) ) == "EZ_CLVL"    })
nPosIteEZ   := aScan( aHeader , { |x| Upper( Trim ( x[2] ) ) == "EZ_ITEMCTA" })

Return

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  ЁRecValSEZ ╨ Autor Ё Cristiano Figueiroa╨ Data Ё  12/01/2006 ╨╠╠
╠╠лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Descricao Ё Recalcula o Valor Distribuido no Acols                     ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё Csu CardSystem                                             ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/

Static Function RecValSEZ()

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё              Declara as Variaveis Locais Utilizadas na Rotina              Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

Local i

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                   Zera a Variavel do Valor Distribuido                     Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

nValDRat := 0
nPerDRat := 0

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                 Zera a Variavel da Quantidade de Registros                 Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

nRegs    := 0 

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                        Calcula o Valor Distribuido                         Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

For i := 1 To Len(aCols)

   /*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
     Ё       Se a linha nao estiver deletada , acumula o valor digitado           Ё
     юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

   If !aCols[i][nUsadoII + 1]
      nValDRat += aCols[i][nPosValEZ ]
      nPerDRat += aCols[i][nPosPerEZ ]

      If aCols [ i , nPosValEZ ] <> 0
         nRegs  ++
      Endif   

   EndIf

Next

nPerDRat := Round(nPerDRat,2)

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                        Atualiza o Objeto na Tela                           Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

oValDRat:Refresh() 
oPerDRat:Refresh() 

Return
/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  ЁCalValEZ  ╨ Autor Ё Cristiano Figueiroa╨ Data Ё  11/01/2006 ╨╠╠
╠╠лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Descricao Ё Calcula o Valor com Base no Percentual Informado           ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё Csu CardSystem                                             ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/

User Function CalValEZ()

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё              Declara as Variaveis Locais Utilizadas na Rotina              Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

Local lRet   := .F. 
Local cAlias := Alias()

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё            Calcula o Valor de Acordo com o Percentual Digitado             Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

If !Empty( M->EZ_PERC )

   aCols[n][nPosValEZ] := Round( ( M->EZ_PERC / 100 ) * nValRat , 2 )
   aCols[n][nPosPerEZ] := Round( M->EZ_PERC,6 )
   
 /*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
   Ё         Chama a Funcao que Atualiza o Campo do Valor Distribuido           Ё
   юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

   RecValSEZ()
   lRet := .T.

Endif

Return lRet

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  ЁCalPerEZ  ╨ Autor Ё Cristiano Figueiroa╨ Data Ё  11/01/2006 ╨╠╠
╠╠лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Descricao Ё Calcula o Percentual com Base no Valor Informado           ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё Csu CardSystem                                             ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/

User Function CalPerEZ()

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё              Declara as Variaveis Locais Utilizadas na Rotina              Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

Local lRet   := .F. 
Local cAlias := Alias()

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё            Calcula o Valor de Acordo com o Percentual Digitado             Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

If !Empty( M->EZ_VALOR )

   aCols[n][nPosPerEZ]  := Round( M->EZ_VALOR / nValRat * 100 , 6 )
   aCols[n][nPosValEZ]  := Round( ( aCols[n][nPosPerEZ] / 100 ) * nValRat , 2 )

 /*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
   Ё         Chama a Funcao que Atualiza o Campo do Valor Distribuido           Ё
   юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

   RecValSEZ()
   lRet := .T.

Endif

Return lRet

/*
ээээээээээээээээээээээээээээъэээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммямммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  Ё VldLinCC  ╨ Autor Ё Cristiano Figueiroa╨ Data Ё  16/01/2006 ╨╠╠
╠╠лммммммммммьмммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Descricao Ё Valida a Linha Digitada no Rateio por Centro de Custo       ╨╠╠
╠╠лммммммммммьммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё Csu CardSystem                                              ╨╠╠
╠╠хммммммммммоммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/

User Function VldLinCC()

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё              Declara as Variaveis Utilizadas na Rotina                     Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

Local cObrig     := "EZ_PERC╧EZ_VALOR╧EZ_CCUSTO╧EZ_ITEMCTA╧EZ_CLVL" // Campos Obrigatorios
Local cContCC    := ""
Local nContPerc  := 0
Local nContVlr   := 0 
Local cItemCta   := "" // validar a unidade de negocio contra o CC

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё         Chama a Funcao que Atualiza o Campo do Valor Distribuido           Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

RecValSEZ()

/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё      Caso a linha esteja deletada nao efetua qualquer validacao     Ё
  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

If aCols[ n , Len(aHeader) + 1 ]
   Return .T.
Endif

/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё Inicia a Validacao da Linha Atual na Tela Rateio de Natureza        Ё
  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

For x := 1 to Len(aHeader)

 /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
   Ё Valida as linhas nao deletadas e obrigatorias                       Ё
   юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

   If Trim(aHeader[x , 2] ) $ cObrig 
	
   /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
     Ё Valida os campos obrigatorios e numericos                           Ё
     юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

      If Trim(aHeader[ x , 8 ]) == "N" .And. aCols[ n , x ] == 0
	     ApMsgInfo("O Campo : " + Trim(aHeader[ x , 1 ]) + " И obrigatСrio !" , "AtenГЦo !" )
	     Return .F.
	  Endif				

   /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
     Ё Valida os campos obrigatorios e caractere                           Ё
     юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

      If Trim(aHeader[ x , 8 ]) == "C" .and. Trim(aCols[ n , x ]) == ""
	     ApMsgInfo("O Campo : " + Trim(aHeader[ x , 1 ]) + " И obrigatСrio !" , "AtenГЦo !" )
         Return .F.     
      Endif				

   Endif
 
 /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
   Ё         Verifica o conteudo dos campos digitados                    Ё
   юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

   If     Trim(aHeader[ x , 2]) == "EZ_PERC"
          nContPerc    := aCols[ n, x ]
   ElseIf Trim(aHeader[ x , 2]) == "EZ_VALOR"
          nContVlr     := aCols[ n, x ]
   ElseIf Trim(aHeader[ x , 2]) == "EZ_CCUSTO"
          cContCC      := aCols[ n , x ]
   ElseIf Trim(aHeader[ x , 2]) == "EZ_ITEMCTA" // unidade de negocio
          cItemCta     := aCols[ n , x ]          
   Endif  

Next

/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё               Valida as informacoes digitadas                       Ё
  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

If nContVlr > nValRat
   MsgInfo("O Valor informado nao pode ser Maior que o Valor a ser Rateado !" , "AtenГЦo !" )
   Return .F.
Endif

//CVerneque 17/Jan
If SubStr(cContCC,1,2) <> SubStr(cItemCta,1,2)
   MsgInfo("Unidade de negocio nao pertence ao centro de custo informado !" , "AtenГЦo !" )
   Return .F.
Endif


Return .T.

/*
ээээээээээээээээээээээээээээъэээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммямммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  Ё VldTudCC  ╨ Autor Ё Cristiano Figueiroa╨ Data Ё  16/01/2006 ╨╠╠
╠╠лммммммммммьмммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Descricao Ё Valida todos os Dados digitados no Rateio                   ╨╠╠
╠╠лммммммммммьммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё Csu CardSystem                                              ╨╠╠
╠╠хммммммммммоммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/

Static Function VldTudCC()

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё              Declara as Variaveis Utilizadas na Rotina                     Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

Local nValTotal  := 0 
Local nValPerc   := 0              
Local cCCusto    := ""
Local cItemCta   := ""
Local cObrig     := "EZ_PERC╧EZ_VALOR╧EZ_CCUSTO╧EZ_ITEMCTA╧EZ_CLVL" // Campos Obrigatorios

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё         Chama a Funcao que Aglutina os Registros iguais do Acols           Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

SomaAcols()

/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё   Caso seja Visualizacao ou Exclusao nao valida as informacoes      Ё
  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

If nOpcao == 2 .Or. nOpcao == 5
   Return .T.
Endif
   
/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё Inicia a Validacao da Linha Atual na Tela Rateio de Natureza        Ё
  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

For x := 1 to Len(aCols) 

 /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
   Ё Soma o Valor Total dos Movimentos                                   Ё
   юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

   If ! aCols[ x , Len(aHeader) + 1 ]

   /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
     Ё         Verifica se o Item e a Classe de Valor estao em Branco      Ё
     юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

      If Empty( Acols [x][nPosIteEZ] )
         Aviso("Campo ObrigatСrio" , "O Campo Unidade de NegСcio ( Item ContАbil ) И ObrigatСrio ! Preencha a Unidade de NegСcio para antes de realizar a GravaГЦo !" , {"Ok"} , 1 , "Campo ObrigatСrio !" )      
         Return .F.         
      Endif
      
      If Empty( Acols [x][nPosClaEZ] )
         Aviso("Campo ObrigatСrio" , "O Campo OperaГЦo ( Classe de Valor ) И ObrigatСrio ! Preencha a OperaГЦo antes de realizar a GravaГЦo !" , {"Ok"} , 1 , "Campo ObrigatСrio !" )
         Return .F.         
      Endif


   /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
     Ё         Verifica se o Item e o Centro de Custo estao em sincronia   Ё
     юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

      If SubStr( Acols [x][nPosIteEZ],1,2 ) <> SubStr( Acols [x][nPosCusEZ],1,2 )
         Aviso("Unidade de Negocio" , "A unidade de negocio nao pertence ao centro de custo informado !" , {"Ok"} , 1 , "Campo Incorreto !" )      
         Return .F.         
      Endif
      
    /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
      Ё Soma o Valor Total dos Movimentos                                   Ё
      юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

      nValTotal += Acols [x][nPosValEZ]
      nValPerc  += Acols [x][nPosPerEZ]

      // Sergio em Jan/2009: 0069/09 - No rateio da NFE nao permitir a utilizacao de entidades invalidas
            
      If !U_VldCTBg( aCols[x][nPosIteEz], aCols[x][nPosCusEz], aCols[x][nPosClaEz], Str(x) )
         Return .f.
      EndIf
      
    /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
      Ё          Valida as Linhas Duplicadas dentro do Rateio               Ё
      юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

      For v := 1 to Len(aCols)

         If !aCols[ v , Len(aHeader) + 1 ]

            If v <> x .And. aCols[x][nPosCusEz] + aCols[x][nPosIteEz] + aCols[x][nPosClaEz] == aCols[v][nPosCusEz] + aCols[v][nPosIteEz] + aCols[v][nPosClaEz]
               MsgInfo("JА existe uma linha rateada com o mesmo Centro de Custo + Unidade de Negocio + Operacao Cadastrado !" ,  "AtenГЦo ! " )
               Return .f.
            EndIf
            
         Endif  
                                  
      Next v

   Endif   
 
Next x

/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё               Valida as informacoes digitadas                       Ё
  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

If Round( nValPerc,2 ) <> 100.00
   MsgInfo("O Percentual Rateado devera ser 100 % !" , "AtenГЦo !" )
   Return .F.
Else

/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё Caso o Rateio seja 100 % e houver divergencia de valores , chama a rotina Ё
  Ё que ajusta a Diferenca encontrada.                                        Ё
  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

   If Round( nValRat,2) <> Round( nValTotal,2 )
//      AjustaDif ( nValRat , nValTotal )
//Alterado por Tatiana A. Barbosa em 08/02/10
//      Aviso("Arredondamento de Valores" , "Por questУes de arredondamento nos percentuais distribuМdos o Зltimo Мtem do rateio sofreu um ajuste automАtico !" , {"Ok"} , 1 , "InformaГЦo !! " )
	MsgInfo("Por questУes de arredondamento nos percentuais distribuМdos o valor rateado И diferente do valor a ratear. и necessАrio ajustar os valores para gravaГЦo do rateio!" , "AtenГЦo !" )
	Return .F.
   Endif

Endif

/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё              Chama a Funcao de Gravacao do Rateio                   Ё
  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

GrvTmpMulCC()

Return .T.

/*
ээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммммммкмммммммяммммммммммммммммммммкммммммямммммммммммм╩╠╠
╠╠╨Programa  Ё GrvTmpMulCC  ╨ Autor Ё Cristiano Figueiroa╨ Data Ё 18/01/2006 ╨╠╠
╠╠лммммммммммьммммммммммммммймммммммоммммммммммммммммммммйммммммомммммммммммм╧╠╠
╠╠╨Descricao Ё Grava o  Arquivo Temporario de Rateio de Centro de Custo      ╨╠╠
╠╠лммммммммммьммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё Csu CardSystem                                                ╨╠╠
╠╠хммммммммммоммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/

Static Function GrvTmpMulCC()

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                    Declara as variaveis utilizadas                         Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

Local l

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё            Abre a Tabela Temporaria do Rateio por Centro de Custo          Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

DbSelectArea("CUS")

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё             Processa todos os Registros do Acols do Rateio                 Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

For l := 1 to Len(aCols)

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё      Pesquisa no Temporario de ja existe a Natureza e o Centro de Custo    Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

   If DbSeek ( cNaturez + aCols[l][nPosCusEz] + aCols[l][nPosIteEz]  + aCols[l][nPosClaEz] )
      Reclock("CUS" , .F.)
   Else
      Reclock("CUS" , .T.)      
   Endif   

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                 Grava as Informacoes no Arquivo Temporario                 Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
         
   CUS->NATUREZ := cNaturez
   CUS->CCUSTO  := aCols[l][nPosCusEz]
   CUS->DESCUS  := Posicione("CTT" , 1 , xFilial("CTT") + CUS->CCUSTO , "CTT_DESC01") 
   CUS->ITEM    := aCols[l][nPosIteEz]
   CUS->CLASSE  := aCols[l][nPosClaEz]
   CUS->VALOR   := aCols[l][nPosValEz]
   CUS->PERC    := aCols[l][nPosPerEz]
   CUS->FLAG    := aCols[l][nUsadoII + 1]
   MsUnLock()

Next l   


Return

/*
ээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммммммкмммммммяммммммммммммммммммммкммммммямммммммммммм╩╠╠
╠╠╨Programa  Ё  TrazRateio  ╨ Autor Ё Cristiano Figueiroa╨ Data Ё 23/01/2006 ╨╠╠
╠╠лммммммммммьммммммммммммммймммммммоммммммммммммммммммммйммммммомммммммммммм╧╠╠
╠╠╨Descricao Ё Traz o Rateio Externo conforme codigo informado               ╨╠╠
╠╠лммммммммммьммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё Csu CardSystem                                                ╨╠╠
╠╠хммммммммммоммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/

Static Function TrazRateio()

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                    Declara as variaveis utilizadas                         Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

Local   oDlg2
Local   cCodRateio	:= CriaVar("CTJ_RATEIO")
Local   nOpca 		:= 0
Local   cItem	    := "00"
Private nPercent  	:= 100

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                Solicita o Posicionamento na Linha Superior                 Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

If aCols[Len(aCols)][nPosValEZ] == 0 .And. Len(aCols) > 1
   Alert("NЦo И possivel a execuГЦo da Rotina de Rateio Externo em Linhas em Branco !!!")
   Return .T.
Endif

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                Monta a Tela para Receber o Codigo do Rateio                Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

Define MsDialog oDlg2 From  094 , 001 To 240 , 226 Title "Selecione o Rateio Externo" Pixel

@ 005 , 003 To 040 , 110 Of oDlg2 Pixel
@ 042 , 003 To 072 , 110 Of oDlg2 Pixel

@ 010 , 005 Say "Rateio"       Font oBoldIII Pixel COLOR CLR_HBLUE
@ 025 , 005 Say "Percentual"   Font oBoldIII Pixel COLOR CLR_HBLUE

@ 010 , 055 MsGet cCodRateio F3 "CTJ" Picture "@!"        Size 040 , 010 Of oDLG2 Pixel Valid VldCodRat( cCodRateio )
@ 025 , 055 MsGet nPercent            Picture "@E 999.99" Size 040 , 010 Of oDLG2 Pixel Valid VldPerRat( cCodRateio , nPercent )

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                Monta a Tela para Receber o Codigo do Rateio                Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

Define SButton From 051 , 025 Type 1 Enable Of oDlg2 Action (nOpca := 1 , Iif( CarregaRat( cCodRateio , nPercent ) , oDlg2:End(),nOpca := 0))
Define SButton From 051 , 067 Type 2 Enable Of oDlg2 Action (oDlg2:End() , nOpca := 0)
			
/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                Monta a Tela para Receber o Codigo do Rateio                Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

Activate MsDialog oDlg2 Centered

Return

/*
ээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммммммкмммммммяммммммммммммммммммммкммммммямммммммммммм╩╠╠
╠╠╨Programa  Ё CarregaRat   ╨ Autor Ё Cristiano Figueiroa╨ Data Ё 23/01/2006 ╨╠╠
╠╠лммммммммммьммммммммммммммймммммммоммммммммммммммммммммйммммммомммммммммммм╧╠╠
╠╠╨Descricao Ё Traz o Rateio Externo conforme codigo informado               ╨╠╠
╠╠лммммммммммьммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё Csu CardSystem                                                ╨╠╠
╠╠хммммммммммоммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/

Static Function CarregaRat( cCodRat , nPerRat )

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё              Declara as Variaveis Locais Utilizadas na Rotina              Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

Local nCols  := 1
Local nValor := 0

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё       Calcula o Valor a ser Rateado com Base no Percentual Informado       Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

nValor := Round( nValRat * (nPerRat / 100 ),2 )

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  ЁCarrega Todos os Registros no Acols de acordo com o codigo do Rateio digitado Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

Do While !Eof() .And. CTJ->CTJ_RATEIO == cCodRat
      
/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё             Verifica se o Centro de Custo esta Bloqueado               Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

   If U_VerCCBloq(CTJ->CTJ_CCD) .And. U_VerCCBloq(CTJ->CTJ_CCC)

    /*здддддддддддддддддддддддддддддддддддддддддддддддддддддд©
      Ё           Adiciona mais uma Linha no Acols           Ё
      юдддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

      If aCols[Len(aCols)][nPosValEZ] == 0
         nCols := Len(aCols)
      Else

       /*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
         Ё    Chama a funcao que adiciona uma nova linha no Acols       Ё
         юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
   
         AdicCols()

         nCols := Len(aCols)
  
      Endif

   /*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
     Ё               Atribui os Dados do Rateio no Acols                      Ё
     юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

      If !Empty( CTJ->CTJ_CCD )
         aCols[nCols][nPosCusEZ]  := CTJ->CTJ_CCD
      Else   
         aCols[nCols][nPosCusEZ]  := CTJ->CTJ_CCC
      Endif

      If !Empty( CTJ->CTJ_ITEMD )
         aCols[nCols][nPosIteEZ]  := CTJ->CTJ_ITEMD
      Else   
         aCols[nCols][nPosIteEZ]  := CTJ->CTJ_ITEMC
      Endif


      If !Empty( CTJ->CTJ_CLVLDB )
         aCols[nCols][nPosClaEZ]  := CTJ->CTJ_CLVLDB
      Else   
         aCols[nCols][nPosClaEZ]  := CTJ->CTJ_CLVLCR
      Endif

      aCols[nCols][nPosValEZ]     := Round( nValor * (CTJ->CTJ_PERCEN / 100),2 )
      aCols[nCols][nPosPerEZ]     := Round( CTJ->CTJ_PERCEN,6 )
      aCols[nCols][nPosDesEZ]     := Posicione("CTT" , 1 , xFilial("CTT") +  aCols[nCols][nPosCusEZ] , "CTT_DESC01") 
      aCols[nCols][nUsadoII + 1 ] := .F.

   /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
     Ё               Processa o Proximo Registro                       Ё
     юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
   
   EndIf
  
   DbSkip()
   Loop

Enddo

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё         Chama a Funcao que Aglutina os Registros iguais do Acols           Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

SomaAcols()

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё         Chama a Funcao que Atualiza o Campo do Valor Distribuido           Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

RecValSEZ()


Return .T.

/*
ээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммммммкмммммммяммммммммммммммммммммкммммммямммммммммммм╩╠╠
╠╠╨Programa  Ё   VldCodRat  ╨ Autor Ё Cristiano Figueiroa╨ Data Ё 27/01/2006 ╨╠╠
╠╠лммммммммммьммммммммммммммймммммммоммммммммммммммммммммйммммммомммммммммммм╧╠╠
╠╠╨Descricao Ё Valida o Codigo do Rateio Informado                           ╨╠╠
╠╠лммммммммммьммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё Csu CardSystem                                                ╨╠╠
╠╠хммммммммммоммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/

Static Function VldCodRat( cCodRat )

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё              Declara as Variaveis Locais Utilizadas na Rotina              Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

Local lRet := .T.

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                    Abre a Tabela de Rateios Externos                       Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

DbSelectArea("CTJ")
DbSetOrder(1)

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё        Pesquisa o Codigo informado na Tabela de Rateios Externos           Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

If !DbSeek( xFilial("CTJ") + cCodRat ) .And. !Empty(cCodRat)
   MsgInfo("O CСdigo de Rateio Informado nЦo existe !" , "AtenГЦo !")
   lRet := .F.
Else
   If !Empty( CTJ->CTJ_QTDTOTAL )
      nPercent := CTJ->CTJ_QTDTOTAL
   Endif   
Endif

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё              Verifica se o Codigo do Rateio Esta Preenchido                Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

If Empty(cCodRat)
   MsgInfo("O Codigo do Rateio deverА ser informado !!" , "AtenГЦo !")   
   lRet := .F.
Endif

Return lRet

/*
ээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммммммкмммммммяммммммммммммммммммммкммммммямммммммммммм╩╠╠
╠╠╨Programa  Ё   VldPerRat  ╨ Autor Ё Cristiano Figueiroa╨ Data Ё 27/01/2006 ╨╠╠
╠╠лммммммммммьммммммммммммммймммммммоммммммммммммммммммммйммммммомммммммммммм╧╠╠
╠╠╨Descricao Ё Valida o Percentual Informado na Tela do Rateio               ╨╠╠
╠╠лммммммммммьммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё Csu CardSystem                                                ╨╠╠
╠╠хммммммммммоммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/

Static Function VldPerRat( cCodRat , nPerRat )

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё              Declara as Variaveis Locais Utilizadas na Rotina              Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

Local lRet := .T.

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                    Abre a Tabela de Rateios Externos                       Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

If nPerRat <= 0
   MsgInfo("O Percentual de Rateio deve ser Maior que 0 e Menor que 100 !" , "AtenГЦo !")
   lRet := .F.
Endif   

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                    Abre a Tabela de Rateios Externos                       Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

DbSelectArea("CTJ")
DbSetOrder(1)

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё        Pesquisa o Codigo informado na Tabela de Rateios Externos           Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

If !DbSeek( xFilial("CTJ") + cCodRat )
   MsgInfo("O CСdigo de Rateio Informado nЦo existe !" , "AtenГЦo !")
   lRet := .F.
Else

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё Caso a quantidade total seja diferente de 0 pergunta se deseja efetuar a aplicacao de um Ё
  Ё percentual sobre o percentual jА configurado para o Rateio                               Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

/*   If CTJ->CTJ_QTDTOTAL <> 0 .And. nPerRat <> 100
      If !MsgYesNo("Confirma a AplicaГЮo de " + Alltrim(Str(nPerRat)) + "% sobre " + Alltrim(Str(CTJ->CTJ_QTDTOTAL)) + " %" ) 
         lRet := .F.
      Endif
   Endif*/

Endif

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё              Verifica se o Codigo do Rateio Esta Preenchido                Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

If Empty(cCodRat)
   MsgInfo("O Codigo do Rateio deverА ser informado !!" , "AtenГЦo !")   
   lRet := .F.
Endif

Return lRet

/*
ээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммммммкмммммммяммммммммммммммммммммкммммммямммммммммммм╩╠╠
╠╠╨Programa  Ё  SomaAcols   ╨ Autor Ё Cristiano Figueiroa╨ Data Ё 27/01/2006 ╨╠╠
╠╠лммммммммммьммммммммммммммймммммммоммммммммммммммммммммйммммммомммммммммммм╧╠╠
╠╠╨Descricao Ё Aglutina as Colunas do Acols com o mesmo Codigo               ╨╠╠
╠╠лммммммммммьммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё Csu CardSystem                                                ╨╠╠
╠╠хммммммммммоммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/

Static Function SomaAcols()

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё              Declara as Variaveis Locais Utilizadas na Rotina              Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

Local aColsNew := {}
Local aNewProc := {}
Local nValCus  := 0
Local nPerCus  := 0
Local e        := 1

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё              Declara as Variaveis Locais Utilizadas na Rotina              Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

aCols := aSort(aCols,,,{|x,y| x[nPosCusEZ] + x[nPosIteEZ] + x[nPosClaEZ]  <   y[nPosCusEZ] + y[nPosIteEZ] + y[nPosClaEZ]  } )

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё              Declara as Variaveis Locais Utilizadas na Rotina              Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/


For j := 1 to Len(aCols)

   nValCus := 0
   nPerCus := 0

   If !aCols[ j , Len(aHeader) + 1 ]
   
      For m := 1 to Len(aCols)
      
         If !aCols[ j , Len(aHeader) + 1 ] .And. aCols[ j , nPosCusEZ ] + aCols[ j , nPosIteEZ ] + aCols[ j , nPosClaEZ ]  ==  aCols[ m , nPosCusEZ ]  + aCols[ m , nPosIteEZ ] + aCols[ m , nPosClaEZ ] .And. !aCols[ m , Len(aHeader) + 1 ]
            nValCus += Round(aCols[ m , nPosValEZ ],2)
            nPerCus := Round(nValCus * 100 / nValRat,6)
         Endif

      Next m
   
  /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
    Ё   Verifica se o Centro de Custo + Item + Classe ja foram Aglutinados. Caso  Ё
    Ё   ja tenham sido aglutinados nao adiciona no novo Acols                     Ё
    юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

      If Ascan ( aNewProc , aCols[ j , nPosCusEZ ] + aCols[ j , nPosIteEZ ] + aCols[ j , nPosClaEZ ] ) == 0
      
      /*If Ascan( AcolsNew , {|x| x[nPosCusEZ] == aCols[ j , nPosCusEZ ] }) == 0  .Or. ; 
         Ascan( AcolsNew , {|x| x[nPosClaEZ] == aCols[ j , nPosClaEZ ] }) == 0  .Or. ;       
         Ascan( AcolsNew , {|x| x[nPosIteEZ] == aCols[ j , nPosIteEZ ] }) == 0          
         
      /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
        Ё   Adiciona um Array no aCols Contendo o Numero de Colunas Usadas na Rotina  Ё
        юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

         Aadd ( aColsNew , Array( nUsadoII + 1 ) )

      /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
        Ё                 Atribui as Colunas os Valores Ja Existentes                 Ё
        юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

         aColsNew[e][nPosCusEZ    ] := aCols [ j , nPosCusEZ ]
         aColsNew[e][nPosPerEZ    ] := nPerCus
         aColsNew[e][nPosValEZ    ] := nValCus 
         aColsNew[e][nPosDesEZ    ] := aCols [ j , nPosDesEZ ]
         aColsNew[e][nPosIteEZ    ] := aCols [ j , nPosIteEZ ]
         aColsNew[e][nPosClaEZ    ] := aCols [ j , nPosClaEZ ]         
         aColsNew[e][nUsadoII + 1 ] := .F.
         
         e++
      
      /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
        Ё       Adiciona no Array o Centro de Custo + Item + Classe ja processados    Ё
        юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

         Aadd ( aNewProc , aCols[ j , nPosCusEZ ] + aCols[ j , nPosIteEZ ] + aCols[ j , nPosClaEZ ] )
      
      Endif   
      
   Else

      DbSelectArea("CUS")

    /*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
      Ё             Processa todos os Registros do Acols do Rateio                 Ё
      юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

      If DbSeek ( cNaturez + aCols[j][nPosCusEz] + aCols[j][nPosIteEz]  + aCols[j][nPosClaEz]  )
         Reclock("CUS" , .F.)
         CUS->FLAG  := aCols[j][nUsadoII + 1]
         MSUnLock()
      Endif   

   
   Endif

Next j

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё    Atribui ao Acols o AcolsNew com as colunas aglutinadas    Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

aCols := aColsNew

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё    Caso o novo acols esteja vazio , adiciona nova linha      Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

If Len(aCols) == 0
   AdicCols()
Endif


Return

/*
ээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммммммкмммммммяммммммммммммммммммммкммммммямммммммммммм╩╠╠
╠╠╨Programa  Ё  AdicCols    ╨ Autor Ё Cristiano Figueiroa╨ Data Ё 30/01/2006 ╨╠╠
╠╠лммммммммммьммммммммммммммймммммммоммммммммммммммммммммйммммммомммммммммммм╧╠╠
╠╠╨Descricao Ё Adiciona linha em branco no Acols                             ╨╠╠
╠╠лммммммммммьммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё Csu CardSystem                                                ╨╠╠
╠╠хммммммммммоммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/

Static Function AdicCols

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё              Declara as Variaveis Locais Utilizadas na Rotina              Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

Local nNum 

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                     Adiciona Nova Linha no Acols                           Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

Aadd( aCols , Array( nUsadoII + 1) )

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                     Adiciona Nova Linha no Acols                           Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

For nNum := 1 to nUsadoII
   aCols[ Len( aCols ) , nNum        ] :=  CriaVar( aHeader [ nNum , 2 ] )
   aCols[ Len( aCols ) , nUsadoII + 1] := .F.
Next 

Return

/*
ээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммммммкмммммммяммммммммммммммммммммкммммммямммммммммммм╩╠╠
╠╠╨Programa  Ё  AjustaDif   ╨ Autor Ё Cristiano Figueiroa╨ Data Ё 15/03/2006 ╨╠╠
╠╠лммммммммммьммммммммммммммймммммммоммммммммммммммммммммйммммммомммммммммммм╧╠╠
╠╠╨Descricao Ё Efetua um ajuste na ultima linha do Rateio caso haja          ╨╠╠
╠╠╨          Ё divergencia entr eo Valor a Ratear e Valor Rateado.           ╨╠╠
╠╠╨          Ё Vale apontar que tal rotina somente devera ser disparado      ╨╠╠
╠╠╨Descricao Ё quando o Percentual Rateado ja tiver atingido os 100 %        ╨╠╠
╠╠лммммммммммьммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё Csu CardSystem                                                ╨╠╠
╠╠хммммммммммоммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/

Static Function AjustaDif( _nValRat , _nValTotal )

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё              Declara as Variaveis Locais Utilizadas na Rotina              Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

Local q    
Local nNumColunas := Len( aCols )
Local lAjuste     := .F.
Local nValAjuste  := _nValRat - _nValTotal 

/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё Inicia a Validacao da Linha Atual na Tela Rateio de Natureza        Ё
  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

For q := Len( aCols ) to 1 Step -1

/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё       Executa o ajuste enquando o Flag estiver igual a Falso        Ё
  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

   If !lAjuste

   /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
     Ё             Desconsidera os Itens do Acols Deletados                Ё
     юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

      If ! aCols[ q , Len(aHeader) + 1 ]

      /*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
        Ё   Caso o Ajuste seja Negativo Verifica se Tenho Valor Disponivel para Subtrair   Ё
        юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

         If nValAjuste < 0
 
            If aCols[q][nPosValEZ ] > nValAjuste * -1 
               aCols[q][nPosValEZ ] += nValAjuste
               lAjuste := .T.
            Endif   
         
         Else

      /*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
        Ё   Caso o Ajuste seja Positivo soma o Valor na Ultima Linha do Rateio             Ё
        юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

            aCols[q][nPosValEZ ] += nValAjuste
            lAjuste := .T.         
         
         Endif   

		 aCols[q][nPosPerEZ ] := ( aCols[q][nPosValEZ ] / _nValTotal ) * 100
      Endif

   Endif   

Next q

Return

/*
ээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммммммкмммммммяммммммммммммммммммммкммммммямммммммммммм╩╠╠
╠╠╨Programa  Ё  VerCCBloq   ╨ Autor Ё Cristiano Figueiroa╨ Data Ё 13/04/2006 ╨╠╠
╠╠лммммммммммьммммммммммммммймммммммоммммммммммммммммммммйммммммомммммммммммм╧╠╠
╠╠╨Descricao Ё Verifica se o Centro de Custo Utilizado esta ou nao Bloqueado ╨╠╠
╠╠╨          Ё para uso ou esta fora da Data de Vigencia                     ╨╠╠
╠╠лммммммммммьммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё Csu CardSystem                                                ╨╠╠
╠╠хммммммммммоммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/

User Function VerCCBloq( cCusto )

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё              Declara as Variaveis Locais Utilizadas na Rotina              Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

Local lRet      := .T.
Local aArea     := GetArea()
Local aAreaCTT  := CTT->( GetArea() )

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                 Abre o Cadastro de Centros de Custos                       Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

DbSelectArea("CTT")
DbSetOrder(1)       // Filial + Centro de Custo

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                 Posiciona no Cadastro de Centros de Custos                 Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

If DbSeek ( xFilial("CTT") + cCusto )

 /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
   Ё     Verifica se o Centro de Custo esta ou nao  Bloqueado    Ё
   юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

   If CTT->CTT_BLOQ == "1" 
      Aviso("Atencao" , "O Centro de Custo (" + AllTrim(cCusto) + ") nao pode ser utilizado por estar bloqueado !" , {"Ok"} , 1 , "Centro de Custo Invalido" )
      lRet := .F.
   Endif   

 /*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
   Ё     Verifica a Data Inicial de Existencia do Centro de Custo   Ё
   юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

   If !Empty( CTT->CTT_DTEXIS )
      If dDatabase < CTT->CTT_DTEXIS
         Aviso("Atencao" , "O Centro de Custo (" + AllTrim(cCusto) + ") nao pode ser utilizado pois a Data Inicial de Existencia e " + DtoC(CTT->CTT_DTEXIS) + " !" , {"Ok"} , 1 , "Centro de Custo Invalido" )
         lRet := .F.
      Endif   
   Endif   

 /*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
   Ё      Verifica a Data Final de Existencia do Centro de Custo    Ё
   юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

   If !Empty( CTT->CTT_DTEXSF )
      If dDatabase < CTT->CTT_DTEXSF
         Aviso("Atencao" , "O Centro de Custo (" + AllTrim(cCusto) + ") nao pode ser utilizado pois o mesmo expirou no dia " + DtoC(CTT->CTT_DTEXSF) + " !" , {"Ok"} , 1 , "Centro de Custo Invalido" )
         lRet := .F.
      Endif   
   Endif   

Endif

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                 Restaura as Areas utilizadas Anteriormente                 Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

RestArea(aAreaCTT)
RestArea(aArea)

Return lRet
