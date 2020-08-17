#INCLUDE "Protheus.ch"

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  ЁGeraCtbRat╨ Autor Ё Cristiano Figueiroa╨ Data Ё  12/03/2006 ╨╠╠
╠╠лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Descricao ЁGera os Lancamentos Contabeis de Documentos de Entrada      ╨╠╠
╠╠╨          Ёquando a Nota Fiscal possuir Rateio de Multiplas Natureza   ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨ParametrosЁ                                                            ╨╠╠
╠╠╨          Ё                                                            ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё Csu CardSystem                                             ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/
User Function GeraCtbRat(cDocumento,cSerie,cFornece,cLoja,cPadrao)

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                    Declara as variaveis utilizadas                         Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

Local aArea     := GetArea()
Local aAreaSA2  := SA2->( GetArea() )
Local aAreaSEZ  := SEZ->( GetArea() )
Local aAreaCT5  := CT5->( GetArea() )

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё              Declara as variaveis utilizadas na Contabilizacao             Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

Local cLote     := 	Iif ( Empty( Tabela( "09" , "COM" , .F. )  ) , "888888" , Alltrim(SX5->X5_DESCRI) )
Local cNomProg  := Funname()
Local cUserName := Substr( cUsuario , 7 , 6 )
Local cArquivo  := ""
Local nHdlPrv   := 0
Local nValTotal := 0

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё               Verifica se eh um Titulo de Multiplas Naturezas              Ё
  Ё              Caso contrario nao Dispara o Lancamento em Questao            Ё
  Ё                            Retornando 0 ( Zero )                           Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

//If !( SF1->F1_RATESP == "1" )
//   Return 0   
//Endif

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё   Caso a Rotina nao tenha Recebido os Parametros atribui Automaticamente   Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

cDocumento := Iif ( cDocumento == Nil , "C00000"  , cDocumento )
cSerie     := Iif ( cSerie     == Nil , "UNI"     , cSerie     )
cFornece   := Iif ( cFornece   == Nil , "C00001"  , cFornece   )
cLoja      := Iif ( cLoja      == Nil , "01"      , cLoja      )
cPadrao    := Iif ( cPadrao    == Nil , "100"     , cPadrao    )

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                     Abre a Tabela de Fornecedores                          Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

DbSelectArea("SA2")
DbSetOrder(1)   // Codigo + Loja

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                   Posiciona no Registro do Fornecedor                      Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

If !DbSeek ( xFilial("SA2") + cFornece + cLoja )
   Aviso( "Atencao" , "O Fornecedor com o cСdigo " + cFornece + " loja " + cLoja + " nЦo foi encontrado !" , { "Ok" } , 2 ) 	
Endif

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁVG - 2011.02.17 - ValidaГЦo para contabilizaГЦo do rateio externoЁ
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If Alltrim(cPadrao) == "100" .or. Alltrim(cPadrao) == "101"

	/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	  Ё              Abre a Tabela de Rateio por Centro de Custo                   Ё
	  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

	DbSelectArea("SEZ")
	DbSetOrder(5)                  // Numero do Documento ( Numero da Nota + Serie + Fornecedor + Loja )


	/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	  Ё            Posiciona no Registro do Rateio por Natureza                    Ё
	  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

	If DbSeek ( xFilial("SEZ") + cDocumento + cSerie + cFornece + cLoja )

	/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	  Ё         Chama a HeadProva para montar o Cabecalho da Contabilizacao        Ё
	  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

	   nHdlPrv := HeadProva( cLote , cNomProg , cUserName , @cArquivo )

	 /*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	   Ё          Processa todos os Registros do Rateio por Centro de Custo         Ё
	   юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

	   Do While SEZ->( !Eof() ) .And. SEZ->EZ_NOTA == cDocumento + cSerie + cFornece + cLoja

    	/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	      Ё           Chama a DetProva para montar o Detalhe da Contabilizacao         Ё
    	  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

	      nValTotal += DetProva( nHdlPrv , cPadrao , cNomProg , "444" )
    
    	  DbSelectArea("SEZ")
	      DbSkip()
    	  Loop
                                 	
	   Enddo   
	   
	Endif

	 /*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	   Ё          Chama a RodaProva para montar o Rodape da Contabilizacao          Ё
	   юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

	//   RodaProva( nHdlPrv , nValTotal )
	//   Ca100Incl( cArquivo , nHdlPrv , 3 , cLote , .T. , .F.)       
ElseIf Alltrim(cPadrao) == "RLT" .or. Alltrim(cPadrao) == "RLE"        

	//зддддддддддддддддддддддддддддддддддддддддддд©
	//Ёseleciona a tabela de rateios por naturezasЁ
	//юддддддддддддддддддддддддддддддддддддддддддды
	dbSelectArea("SEV")                                                  
	//dbSetOrder(3)//EV_FILIAL+EV_NOTA                                     
	dbOrderNickName("EVNOTA")
	
	If DbSeek ( xFilial("SEV") + cDocumento + cSerie + cFornece + cLoja )

	/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	  Ё         Chama a HeadProva para montar o Cabecalho da Contabilizacao        Ё
	  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

	   nHdlPrv := HeadProva( cLote , cNomProg , cUserName , @cArquivo )

	 /*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	   Ё          Processa todos os Registros do Rateio por Centro de Custo         Ё
	   юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

	   Do While SEV->( !Eof() ) .And. SEV->EV_NOTA == cDocumento + cSerie + cFornece + cLoja

    	/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	      Ё           Chama a DetProva para montar o Detalhe da Contabilizacao         Ё
    	  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

	      nValTotal += DetProva( nHdlPrv , cPadrao , cNomProg , "444" )
    
    	  DbSelectArea("SEV")
	      DbSkip()
    	  Loop
                                 	
	   Enddo 
	   
	Endif  

Endif      

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                  Restaura as Areas Utilizadas no Processo                  Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

RestArea(aAreaSA2)
RestArea(aAreaSEZ)
RestArea(aAreaCT5)
RestArea(aArea)

Return 0