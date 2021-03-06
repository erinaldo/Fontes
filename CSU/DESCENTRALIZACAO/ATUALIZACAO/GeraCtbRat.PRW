#INCLUDE "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GeraCtbRat� Autor � Cristiano Figueiroa� Data �  12/03/2006 ���
�������������������������������������������������������������������������͹��
���Descricao �Gera os Lancamentos Contabeis de Documentos de Entrada      ���
���          �quando a Nota Fiscal possuir Rateio de Multiplas Natureza   ���
�������������������������������������������������������������������������͹��
���Parametros�                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Csu CardSystem                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GeraCtbRat(cDocumento,cSerie,cFornece,cLoja,cPadrao)

/*����������������������������������������������������������������������������Ŀ
  �                    Declara as variaveis utilizadas                         �
  ������������������������������������������������������������������������������*/

Local aArea     := GetArea()
Local aAreaSA2  := SA2->( GetArea() )
Local aAreaSEZ  := SEZ->( GetArea() )
Local aAreaCT5  := CT5->( GetArea() )

/*����������������������������������������������������������������������������Ŀ
  �              Declara as variaveis utilizadas na Contabilizacao             �
  ������������������������������������������������������������������������������*/

Local cLote     := 	Iif ( Empty( Tabela( "09" , "COM" , .F. )  ) , "888888" , Alltrim(SX5->X5_DESCRI) )
Local cNomProg  := Funname()
Local cUserName := Substr( cUsuario , 7 , 6 )
Local cArquivo  := ""
Local nHdlPrv   := 0
Local nValTotal := 0

/*����������������������������������������������������������������������������Ŀ
  �               Verifica se eh um Titulo de Multiplas Naturezas              �
  �              Caso contrario nao Dispara o Lancamento em Questao            �
  �                            Retornando 0 ( Zero )                           �
  ������������������������������������������������������������������������������*/

//If !( SF1->F1_RATESP == "1" )
//   Return 0   
//Endif

/*����������������������������������������������������������������������������Ŀ
  �   Caso a Rotina nao tenha Recebido os Parametros atribui Automaticamente   �
  ������������������������������������������������������������������������������*/

cDocumento := Iif ( cDocumento == Nil , "C00000"  , cDocumento )
cSerie     := Iif ( cSerie     == Nil , "UNI"     , cSerie     )
cFornece   := Iif ( cFornece   == Nil , "C00001"  , cFornece   )
cLoja      := Iif ( cLoja      == Nil , "01"      , cLoja      )
cPadrao    := Iif ( cPadrao    == Nil , "100"     , cPadrao    )

/*����������������������������������������������������������������������������Ŀ
  �                     Abre a Tabela de Fornecedores                          �
  ������������������������������������������������������������������������������*/

DbSelectArea("SA2")
DbSetOrder(1)   // Codigo + Loja

/*����������������������������������������������������������������������������Ŀ
  �                   Posiciona no Registro do Fornecedor                      �
  ������������������������������������������������������������������������������*/

If !DbSeek ( xFilial("SA2") + cFornece + cLoja )
   Aviso( "Atencao" , "O Fornecedor com o c�digo " + cFornece + " loja " + cLoja + " n�o foi encontrado !" , { "Ok" } , 2 ) 	
Endif

//�����������������������������������������������������������������Ŀ
//�VG - 2011.02.17 - Valida��o para contabiliza��o do rateio externo�
//�������������������������������������������������������������������
If Alltrim(cPadrao) == "100" .or. Alltrim(cPadrao) == "101"

	/*����������������������������������������������������������������������������Ŀ
	  �              Abre a Tabela de Rateio por Centro de Custo                   �
	  ������������������������������������������������������������������������������*/

	DbSelectArea("SEZ")
	DbSetOrder(5)                  // Numero do Documento ( Numero da Nota + Serie + Fornecedor + Loja )


	/*����������������������������������������������������������������������������Ŀ
	  �            Posiciona no Registro do Rateio por Natureza                    �
	  ������������������������������������������������������������������������������*/

	If DbSeek ( xFilial("SEZ") + cDocumento + cSerie + cFornece + cLoja )

	/*����������������������������������������������������������������������������Ŀ
	  �         Chama a HeadProva para montar o Cabecalho da Contabilizacao        �
	  ������������������������������������������������������������������������������*/

	   nHdlPrv := HeadProva( cLote , cNomProg , cUserName , @cArquivo )

	 /*����������������������������������������������������������������������������Ŀ
	   �          Processa todos os Registros do Rateio por Centro de Custo         �
	   ������������������������������������������������������������������������������*/

	   Do While SEZ->( !Eof() ) .And. SEZ->EZ_NOTA == cDocumento + cSerie + cFornece + cLoja

    	/*����������������������������������������������������������������������������Ŀ
	      �           Chama a DetProva para montar o Detalhe da Contabilizacao         �
    	  ������������������������������������������������������������������������������*/

	      nValTotal += DetProva( nHdlPrv , cPadrao , cNomProg , "444" )
    
    	  DbSelectArea("SEZ")
	      DbSkip()
    	  Loop
                                 	
	   Enddo   
	   
	Endif

	 /*����������������������������������������������������������������������������Ŀ
	   �          Chama a RodaProva para montar o Rodape da Contabilizacao          �
	   ������������������������������������������������������������������������������*/

	//   RodaProva( nHdlPrv , nValTotal )
	//   Ca100Incl( cArquivo , nHdlPrv , 3 , cLote , .T. , .F.)       
ElseIf Alltrim(cPadrao) == "RLT" .or. Alltrim(cPadrao) == "RLE"        

	//���������������������������������������������
	//�seleciona a tabela de rateios por naturezas�
	//���������������������������������������������
	dbSelectArea("SEV")                                                  
	//dbSetOrder(3)//EV_FILIAL+EV_NOTA                                     
	dbOrderNickName("EVNOTA")
	
	If DbSeek ( xFilial("SEV") + cDocumento + cSerie + cFornece + cLoja )

	/*����������������������������������������������������������������������������Ŀ
	  �         Chama a HeadProva para montar o Cabecalho da Contabilizacao        �
	  ������������������������������������������������������������������������������*/

	   nHdlPrv := HeadProva( cLote , cNomProg , cUserName , @cArquivo )

	 /*����������������������������������������������������������������������������Ŀ
	   �          Processa todos os Registros do Rateio por Centro de Custo         �
	   ������������������������������������������������������������������������������*/

	   Do While SEV->( !Eof() ) .And. SEV->EV_NOTA == cDocumento + cSerie + cFornece + cLoja

    	/*����������������������������������������������������������������������������Ŀ
	      �           Chama a DetProva para montar o Detalhe da Contabilizacao         �
    	  ������������������������������������������������������������������������������*/

	      nValTotal += DetProva( nHdlPrv , cPadrao , cNomProg , "444" )
    
    	  DbSelectArea("SEV")
	      DbSkip()
    	  Loop
                                 	
	   Enddo 
	   
	Endif  

Endif      

/*����������������������������������������������������������������������������Ŀ
  �                  Restaura as Areas Utilizadas no Processo                  �
  ������������������������������������������������������������������������������*/

RestArea(aAreaSA2)
RestArea(aAreaSEZ)
RestArea(aAreaCT5)
RestArea(aArea)

Return 0