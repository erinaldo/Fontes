#Include "RwMake.ch"                            
/*                                
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  � RComA03  � Autor � Cesar Moura         � Data � 04/07/2006  ���
��������������������������������������������������������������������������͹��
���Descricao � Importacao de Pedido de Compra de E-Procurement da Hold     ���
��������������������������������������������������������������������������͹��
���Uso       � CSU - CardSystem S.A                                        ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/

User Function RComA03()

/*����������������������������������������������������������������������������Ŀ
  �                 Declara as Variaveis Utilizadas na Rotina                  �
  ������������������������������������������������������������������������������*/

Private cPerg	  := PADR("RCOMA3",LEN(SX1->X1_GRUPO))
Private cCadastro := "Importa��o de Pedido de Compras"
Private aSay      := {}
Private aButton   := {}
Private cFile1
Private cFile2
Private nErros    := 0
Private lErros    := .F.
Private oProcess  := Nil
Private aCabe     := {}
Private aItem     := {}
Private aBlqForn  := {}
Private nOpc	  := 0


/*����������������������������������������������������������������������������Ŀ
  �           Verifica se o Grupo de Perguntas existe ou nao                   �
  ������������������������������������������������������������������������������*/

ValidPerg( cPerg )

/*����������������������������������������������������������������������������Ŀ
  �               Carrega o Grupo de Perguntas na Tela                         �
  ������������������������������������������������������������������������������*/

Pergunte( cPerg , .T. )

/*����������������������������������������������������������������������������Ŀ
  �           Monta a Janela de Dialogo com as Mensagens Explicativas          �
  ������������������������������������������������������������������������������*/

aAdd ( aSay , "                                                                                        " )
aAdd ( aSay , "Esta rotina tem como objetivo a realizacao de Importa��o do Pedido de Compra do         " )
aAdd ( aSay , "                sistema da empresa Hold Tecnologia da Informacao.                       " )
aAdd ( aSay , "                                                                                        " )
aAdd ( aSay , "==> Sistemas Envolvidos : Protheus 8 / Hold                                             " )
aAdd ( aSay , "==> Formato do Arquivo  : Texto ( Asc II )                                              " )
aAdd ( aSay , "==> Nome do Arquivo     : PCAAMMDDHHMMSS.Txt                                            " )
aAdd ( aSay , "                                                                                        " )

/*����������������������������������������������������������������������������Ŀ
  �              Monta a os Botoes a serem Disponibilizados na Tela            �
  ������������������������������������������������������������������������������*/

aAdd ( aButton , { 1 , .T. , { || nOpc := 1  , FechaBatch() }} )
aAdd ( aButton , { 2 , .T. , { || FechaBatch()              }} )
aAdd ( aButton , { 5 , .T. , { || Pergunte( cPerg , .T. )   }} )

/*����������������������������������������������������������������������������Ŀ
  �              Abre a Tela para o Processamento das Opcoes                   �
  ������������������������������������������������������������������������������*/

FormBatch( cCadastro , aSay , aButton )

/*����������������������������������������������������������������������������Ŀ
  �              Caso o Usuario Tenha acessado o Botao de Ok                   �
  ������������������������������������������������������������������������������*/

If nOpc == 1
   Processa( { |lEnd| RComA03A() } ,  "Processando o Arquivo : " + MV_PAR01 , "Aguarde" , .F. )
Endif   

/*��������������������������������������������������������������������������������Ŀ
  � Fecha os Arquivos Temporarios e Restaura as Areas Antes da Execucao da Rotina  �
  ����������������������������������������������������������������������������������*/

If Select("PED") > 0
   DbSelectArea("PED")
   DbCloseArea()
Endif

If Select("INC")  > 0
   DbSelectArea("INC")
   DbCloseArea()
Endif

Return                      

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  � RComA03A � Autor � Cristiano Figueiroa � Data � 30/06/2006  ���
��������������������������������������������������������������������������͹��
���Descricao � Rotina Principal de Importacao de Pedido de Compras         ���
���          �                                                             ���
��������������������������������������������������������������������������͹��
���Uso       � CSU - CardSystem S.A                                        ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/

Static Function RComA03A()

/*����������������������������������������������������������������������������Ŀ
  �            Declara as Variaveis Locais Utilizadas na Rotina                �
  ������������������������������������������������������������������������������*/

/*����������������������������������������������������������������������������Ŀ
  �      Configura a Regua com a quantidade de Rotinas a ser Processadas       �
  ������������������������������������������������������������������������������*/

ProcRegua( 18 ) //alterar ainda parametro 18 divide  a regra em partes iguais

/*����������������������������������������������������������������������������Ŀ
  �          Verifica se o Arquivo Existe no Caminho Especificado              �
  ������������������������������������������������������������������������������*/

If !File( Alltrim(MV_PAR01)  ) 
   Aviso( "Aten��o !" , "O Arquivo : " + Alltrim(MV_PAR01) + " n�o foi encontrado !" , {"Ok"} , 1 , "Opera��o Cancelada" )
   Return   
Endif

/*����������������������������������������������������������������������������Ŀ
  �              Cria os Arquivos Temporarios a serem utilizados               �
  ������������������������������������������������������������������������������*/

MontaTrb()

/*����������������������������������������������������������������������������Ŀ
  �                   Abre o Arquivo TXT a ser Importado                       �
  ������������������������������������������������������������������������������*/

ImportaTrb() 

/*����������������������������������������������������������������������������Ŀ
  �             Inicia as Validacoes conforme Lay-Out e Necessidade            �
  ������������������������������������������������������������������������������*/

ValidTrb()

/*����������������������������������������������������������������������������Ŀ
  �               Realiza o Bloqueio dos Fornecedores                          �
  ������������������������������������������������������������������������������*/

u_BloqForn( aBlqForn )
IncProc("Bloqueando os Fornecedores inclu�dos pela Rotina" )

/*����������������������������������������������������������������������������Ŀ
  �               Caso haja Inconsistencias Exibe as Mesmas em Tela            �
  ������������������������������������������������������������������������������*/

If INC->( Reccount()) > 0

/*����������������������������������������������������������������������������������������Ŀ
  � Chama a Rotina que Copia o Arquivo Temporario de Inconsistencias para o Arquivo de Log �
  ������������������������������������������������������������������������������������������*/

   CopyLog()

 /*������������������������������������������������������������������������������Ŀ
   � Pergunta se o Usuario quer ou n�o Visualizar o Relatorio de Inconsistenacias �
   ��������������������������������������������������������������������������������*/

   If Aviso("Aten��o !" , "Deseja Visualizar o Relat�rio de Inconsistencias ? " , {"Sim","N�o"} , 1 , "Inconsistencias no Processo" ) ==  1 
      RelInco()
      Return
   Endif

Endif

    /*����������������������������������������������������������������������������Ŀ
      �                Exibe mensagem de processamento com sucesso                 �
      ������������������������������������������������������������������������������*/

      Aviso( "Aten��o !" , "Rotina Executada " , {"Ok"} , 1 , "" )


Return
/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  � MontaTrb � Autor � Cristiano Figueiroa � Data � 30/06/2006  ���
��������������������������������������������������������������������������͹��
���Descricao � Monta o Arquivo Temporario para Importacao dos Dados        ���
���          �                                                             ���
��������������������������������������������������������������������������͹��
���Uso       � CSU - CardSystem S.A                                        ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/

Static Function MontaTrb()

/*����������������������������������������������������������������������������Ŀ
  �                    Declara as variaveis utilizadas                         �
  ������������������������������������������������������������������������������*/

Local aFile1 := {}
Local aFile2 := {}

/*����������������������������������������������������������������������������Ŀ
  �                   Adiciona a Regua de Processamento                        �
  ������������������������������������������������������������������������������*/

IncProc("Preparando o Ambiente para Importacao")

/*����������������������������������������������������������������������������Ŀ
  �                Monta a Estrutura dos Arquivos Temporarios                  �   
  ������������������������������������������������������������������������������*/

aFile1 := { ;                                                                  // Arquivo de Pedidos de Compra
             {"FILIAL"  , "C" , 002 , 0 } , {"NUMPED"    , "C" , 006 , 0 } ,; 
             {"DATAE"   , "D" , 008 , 0 } , {"RAZAO"     , "C" , 040 , 0 } ,;
             {"NREDUZ"  , "C" , 020	, 0 } , {"ENDE"      , "C" , 040 , 0 } ,;
             {"BAIRRO"  , "C" , 020 , 0 } , {"MUNIC	"     , "C" , 015 , 0 } ,;          
             {"TIPO"    , "C" , 001 , 0 } , {"CNPJ"      , "C" , 014 , 0 } ,;          
             {"CONDPAG" , "C" , 003 , 0 } , {"CONTATO"   , "C" , 015 , 0 } ,;    
             {"FILENT"  , "C" , 002 , 0 } , {"MOEDA"     , "N" , 002 , 0 } ,;          
             {"ITEMPC"  , "C" , 004 , 0 } , {"CODPROD"   , "C" , 015 , 0 } ,;          
             {"DESCPROD", "C" , 030 , 0 } , {"UNID"      , "C" , 002 , 0 } ,;          
             {"TIPOPROD", "C" , 002 , 0 } , {"QUANT"     , "N" , 012 , 2 } ,;                                           
             {"VLUNIT"  , "N" , 014 , 2 } , {"VLTOTAL"   , "N" , 014 , 2 } ,;                                           
             {"ALIQIPI" , "N" , 014 , 2 } , {"VLFRETE"   , "N" , 012 , 2 } ,;                                            
             {"NUMSC"   , "C" , 006 , 0 } , {"ITEMSC"    , "C" , 004 , 0 } ,;                                           
             {"NUMREQ"  , "C" , 015 , 0 } , {"DTENT"     , "D" , 008 , 0 } ,;                                           
             {"ARMAZEM" , "C" , 002 , 0 } , {"OBS"       , "C" , 030 , 0 } ,;                                           
             {"CCUSTO"  , "C" , 009 , 0 } , {"CONTAC"    , "C" , 020 , 0 } ,;                                           
             {"ITEMC"   , "C" , 009 , 0 } , {"CLVL"      , "C" , 009 , 0 } ,;                                           
             {"VLDESC"  , "N" , 014 , 2 } , {"ALIQICM"   , "N" , 005 , 2 } ,; 
             {"ESTADO"  , "C" , 002 , 0 } }									

aFile2 := { {"LINHA"    , "C" , 006 , 0 } , {"SEQ" , "C" , 001 , 0 } ,;
            {"DESCRICAO " , "C" , 200 , 0 } }                                 // Arquivo de Inconsistencias

/*����������������������������������������������������������������������������Ŀ
  �                      Cria area Temporaria no Sistema                       �
  ������������������������������������������������������������������������������*/

cFile1 := CriaTrab( aFile1 )   // Arquivo de Trabalho
cFile2 := CriaTrab( aFile2 )   // Arquivo de Inconsistencias

/*����������������������������������������������������������������������������Ŀ
  �                     Cria o Arquivo Temporario no Sistema                   �
  ������������������������������������������������������������������������������*/

DbUseArea(.T. , , cFile1 , "PED" , .T. )    // Arquivo de Pedido de Compras
DbUseArea(.T. , , cFile2 , "INC"  , .T. )   // Arquivo de Inconsistencias

/*����������������������������������������������������������������������������Ŀ
  �                     Cria o Indice Temporario no Sistema                    �
  ������������������������������������������������������������������������������*/

IndRegua("PED" , cFile1 , "NUMPED"       ,,, "Criando Arquivo...")  
IndRegua("INC" , cFile2 , "LINHA"        ,,, "Criando Arquivo...")

Return

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  �ImportaTrb� Autor � Cristiano Figueiroa � Data � 30/06/2006  ���
��������������������������������������������������������������������������͹��
���Descricao � Importa o Arquivo Txt para o Arquivo Dbf Temporario         ���
���          �                                                             ���
��������������������������������������������������������������������������͹��
���Uso       � CSU CardSystem S.A                                          ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/

Static Function ImportaTrb()

/*����������������������������������������������������������������������������Ŀ
  �                   Adiciona a Regua de Processamento                        �
  ������������������������������������������������������������������������������*/

IncProc("Abrindo o Arquivo : " + Alltrim(MV_PAR01) )

/*����������������������������������������������������������������������������Ŀ
  �              Executa a Importacao do Txt para o Dbf temporario             �
  ������������������������������������������������������������������������������*/

DbSelectArea("PED")
Append From &( Alltrim(MV_PAR01) ) SDF

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ValidTrb � Autor � Cristiano Figueiroa � Data � 30/06/2006  ���
�������������������������������������������������������������������������͹��
���Descricao �Valida o Arquivo de Trabalho conforme Lay-Out fornecido     ���
�������������������������������������������������������������������������͹��
���Uso       �CSU CardSystem S.A                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ValidTrb()

/*����������������������������������������������������������������������������Ŀ
  �                Declara as Variaveis Utilizadas na Rotina                   �
  ������������������������������������������������������������������������������*/

Private aTemErro   := {}
Private nRecno     := 0
Private lTemErro   := .F.
Private lA2AutoErr := .F.
Private lC7AutoErr := .F.
Private lExistA2   := .F.
Private aDadosForn := {}
Private _cCodfil   := ""
Private _cCodForn  := ""
Private dDtEmissao := Ctod("  /  /  ")
Private dDtNessec  := Ctod("  /  /  ")
Private _cCodProd

         
/*����������������������������������������������������������������������������Ŀ
  �                   Adiciona a Regua de Processamento                        �
  ������������������������������������������������������������������������������*/

IncProc("Executando Validacoes no Arquivo")

/*����������������������������������������������������������������������������Ŀ
  �                  Abre o Arquivo Temporario para a Validacao                �
  ������������������������������������������������������������������������������*/

DbSelectArea("PED")
DbGoTop()

/*����������������������������������������������������������������������������Ŀ
  �                  Processa Todos os Registros do Arquivo                    �
  ������������������������������������������������������������������������������*/

Do While PED->( !Eof() )

/*����������������������������������������������������������������������������Ŀ
  �              Monta as Vari�veis do La�o                                    �
  ������������������������������������������������������������������������������*/

   cNumPC     := PED->NUMPED
   lTemErro   := .F. 
   aTemErro   := {}
   aItem      := {}
   aForn	  := {}
   dDtEmissao := Ctod( Substr ( Dtoc ( PED->DATAE ) , 7 , 2 ) + "/" + Substr ( Dtoc ( PED->DATAE ) , 4 , 2 ) + "/" + Substr ( Dtoc ( PED->DATAE ) , 1 , 2 ))  
   dDtNessec  := Ctod( Substr ( Dtoc ( PED->DTENT ) , 7 , 2 ) + "/" + Substr ( Dtoc ( PED->DTENT ) , 4 , 2 ) + "/" + Substr ( Dtoc ( PED->DTENT ) , 1 , 2 ))  	
   _CodProd	  := SUBSTR(PED->CODPROD,12,4)	   

/*����������������������������������������������������������������������������Ŀ
  �                 Monta as Informa��es do Fornecedor (p/ MSEXECAUTO)         �
  ������������������������������������������������������������������������������*/
       
 		aForn:={  	{ "A2_NOME"  , PED->RAZAO        , Nil },;
					{ "A2_LOJA"  , "01"              , Nil },;				    
				    { "A2_NREDUZ", PED->NREDUZ       , Nil },;
				    { "A2_TIPO"  , PED->TIPO		  , Nil },;
				    { "A2_END"   , PED->ENDE         , Nil },;
				    { "A2_MUN"   , PED->MUNIC        , Nil },;
				    { "A2_CGC"   , PED->CNPJ         , Nil },;
				    { "A2_MSBLQL", "2"               , Nil },;
                    { "A2_EST"   , PED->ESTADO       , Nil } }
       
/*����������������������������������������������������������������������������Ŀ
  �                 Monta o Cabecalho do Pedido de Compras (p/ MSEXECAUTO)     �
  ������������������������������������������������������������������������������*/

	   aCabe    := { 	{"C7_NUM"     , cNumPC         , Nil },;
	                 	{"C7_EMISSAO" , dDtEmissao     , Nil },;
	                    {"C7_FORNECE" , " "            , Nil },;                    
	                 	{"C7_LOJA"    , " "            , Nil },;
	                 	{"C7_CONTATO" , PED->CONTATO   , Nil },;
						{"C7_COND"    , PED->CONDPAG   , Nil },;
	                 	{"C7_FILENT"  , PED->FILENT    , Nil } }
	        
/*����������������������������������������������������������������������������Ŀ
  �              Processa todos os itens desse Pedido de Compras               �
  ������������������������������������������������������������������������������*/
   
   Do While PED->( !Eof() ) .And. PED->NUMPED == cNumPC
 
    /*����������������������������������������������������������������������������Ŀ
      �                 Atribui o Numero do Registro Atual                         �
      ������������������������������������������������������������������������������*/

      nRecno := PED->( Recno() )
   
   /*�������������������������������������������������������������������������������Ŀ
     �                    Abre o Cadastro de Solicitacoes de Compras                 �
     ���������������������������������������������������������������������������������*/

      DbSelectArea("SC1")
      DbSetOrder(1)
   
   /*�������������������������������������������������������������������������������Ŀ
     �                Posiciona no Cadastro de Solicitacoes de Compras               �
     �                Verifica se Existe a Solicita��o de Compras                    �
     ���������������������������������������������������������������������������������*/

      If ! DbSeek( xFilial("SC1") + PED->NUMSC + PED->ITEMSC )     //TRATAR ---1
      	  GeraLog( nRecno , "A Solicita��o de Compras N�mero : " + Alltrim( PED->NUMSC ) + " na filial" + PED->FILIAL + " n�o foi encontrado !" )
          lTemErro := .T.
      
      Else

    	  If  SC1->C1_QTDORIG - SC1->C1_QUJE  < PED->QUANT
              GeraLog( nRecno , "A Quantidade informada no " + PED->NUMPED + " � maior que a Quantidade dispon�vel na Solicita��o de Compras N�mero : " + Alltrim( PED->NUMSC ))              
              lTemErro := .T.
       	  EndIf	  

      Endif

   /*�������������������������������������������������������������������������������Ŀ
     �                        Abre o Cadastro de Produtos                            �
     ���������������������������������������������������������������������������������*/

      DbSelectArea("SB1")
      DbSetOrder(1)
   /*�������������������������������������������������������������������������������Ŀ
     �                        Posiciona no Cadastro de Produtos                      �
     �                        Verifica se o Produto Existe no SB1                    �
     ���������������������������������������������������������������������������������*/

      If ! DbSeek( xFilial("SB1") + _CodProd )
         GeraLog( nRecno , "O produto de c�digo : " + _CodProd + " n�o foi encontrado !" )
         lTemErro := .T.
      Endif

   /*�������������������������������������������������������������������������������Ŀ
     �                     Abre o Cadastro de Plano de Contas                        �
     ���������������������������������������������������������������������������������*/

      DbSelectArea("CT1")
      DbSetOrder(1)             
     
   /*�������������������������������������������������������������������������������Ŀ
     �                  Posiciona no Cadastro de Plano de Contas                     �
     ���������������������������������������������������������������������������������*/

      If ! DbSeek( xFilial("CT1") + PED->CONTAC ) .And. !Empty( PED->CONTAC )
         GeraLog( nRecno , "A conta cont�bil : " + Alltrim( PED->CONTAC ) + " n�o foi encontrada !" )
         lTemErro := .T.
      Endif

   /*�������������������������������������������������������������������������������Ŀ
     �                        Abre o Cadastro de Centro de Custo                     �
     ���������������������������������������������������������������������������������*/

      DbSelectArea("CTT")
      DbSetOrder(1)             
   
   /*�������������������������������������������������������������������������������Ŀ
     �                   Posiciona no Cadastro de Centro de Custo                    �
     ���������������������������������������������������������������������������������*/

      If ! DbSeek( xFilial("CTT") + PED->CCUSTO ) .And. !Empty( PED->CCUSTO )
         GeraLog( nRecno , "O centro de custo : " + Alltrim( PED->CCUSTO ) + " n�o foi encontrado !" )
         lTemErro := .T.      
      Endif

   /*�������������������������������������������������������������������������������Ŀ
     �                        Abre o Cadastro de Itens Contabeis                     �
     ���������������������������������������������������������������������������������*/

      DbSelectArea("CTD")
      DbSetOrder(1)             
     
   /*�������������������������������������������������������������������������������Ŀ
     �                   Posiciona no Cadastro de Itens Contabeis                    �
     ���������������������������������������������������������������������������������*/

      If ! DbSeek( xFilial("CTD") + PED->ITEMC ) .And. !Empty( PED->ITEMC )   //TRATAR ---1
         GeraLog( nRecno , "O item contabil : " + Alltrim( PED->ITEMC ) + " n�o foi encontrado !" )
         lTemErro := .T.
      Endif

   /*�������������������������������������������������������������������������������Ŀ
     �                       Abre o Cadastro de Classe de Valor                      �
     ���������������������������������������������������������������������������������*/

      DbSelectArea("CTH")
      DbSetOrder(1)             
   
   /*�������������������������������������������������������������������������������Ŀ
     �                   Posiciona no Cadastro de Classe de Valor                    �
     ���������������������������������������������������������������������������������*/

      If ! DbSeek( xFilial("CTH") + PED->CLVL ) .And. !Empty( PED->CLVL )
         GeraLog( nRecno , "A classe de valor : " + Alltrim( PED->CLVL ) + " n�o foi encontrada !" )
         lTemErro := .T.
      Endif
                    
   /*�������������������������������������������������������������������������������Ŀ
     �                       Valida a Quantidade Informada                           �
     ���������������������������������������������������������������������������������*/

      If PED->QUANT <= 0
         GeraLog( nRecno , "A quantidade n�o pode ser menor ou igual a zero !" )
         lTemErro := .T.
      Endif

   /*�������������������������������������������������������������������������������Ŀ
     �                       Valida o Valor Unit�rio                                 �
     ���������������������������������������������������������������������������������*/

      If PED->VLUNIT <= 0
         GeraLog( nRecno , "O Valor unit�rio n�o pode ser menor ou igual a zero !" )
         lTemErro := .T.
      Endif

   /*�������������������������������������������������������������������������������Ŀ
     �                       Valida o Valor Total                                    �
     ���������������������������������������������������������������������������������*/

      If PED->VLTOTAL <= 0
         GeraLog( nRecno , "O Valor Total do Pedido de Compra n�o pode ser menor ou igual a zero !" )
         lTemErro := .T.
      Endif

   /*�������������������������������������������������������������������������������Ŀ
     �                           Valida a Data de Emissao                            �
     ���������������������������������������������������������������������������������*/

      If Empty( PED->DATAE )
         GeraLog( nRecno , "A data de emissao est� em branco !" )
         lTemErro := .T.
      Endif

   /*�������������������������������������������������������������������������������Ŀ
     �                           Valida o Armazem Informado                          �
     ���������������������������������������������������������������������������������*/

      If Empty( PED->ARMAZEM )
         GeraLog( nRecno , "O Armaz�m est� em branco !" )
         lTemErro := .T.
      Endif

   /*�������������������������������������������������������������������������������Ŀ
     �                           Valida o Tipo do Fornecedor                         �
     ���������������������������������������������������������������������������������*/

      If !( PED->TIPO $ "FJX" )
         GeraLog( nRecno , "O tipo do Fornecedor deve ser F , J ou X !" )
         lTemErro := .T.
      Endif
   
   /*�������������������������������������������������������������������������������Ŀ
     �                           Valida o CNPJ do Fornecedor                         �
     ���������������������������������������������������������������������������������*/
      
      If !(Cgc(PED->CNPJ)) 
         GeraLog( nRecno , "CNPJ " + PED->CNPJ + " do Fornecedor " + PED->NREDUZ + " Inv�lido " )
         lTemErro := .T.
      Endif
   
   
   /*�������������������������������������������������������������������������������Ŀ
     �                       Abre o Cadastro de Fornecedores                         �
     ���������������������������������������������������������������������������������*/

      DbSelectArea("SA2")
      DbSetOrder(3)             
   
   /*�������������������������������������������������������������������������������Ŀ
     �                   Realiza Busca do Fornecedor pelo CNPJ/CPF                   �
     ���������������������������������������������������������������������������������*/

      If ! DbSeek( xFilial("SA2") + PED->CNPJ )
                  
      /*�������������������������������������������������������������������������������Ŀ
        �  Chama a Funcao que Inclui Fornecedores Novos e Retorna o Codigo , Loja e se  �
        �  a gravacao ocorreu com sucesso.                                              �
        ���������������������������������������������������������������������������������*/

         aDadosForn  := GeraForn( aForn , 3 )

      /*�������������������������������������������������������������������������������Ŀ
        �      Atualiza o Flag que avisa se a gravacao ocorreu ou nao com sucesso       �
        ���������������������������������������������������������������������������������*/

         lA2AutoErr  := aDadosForn[3]
         
      /*�������������������������������������������������������������������������������Ŀ
        �         Caso tenha existido algum tipo de erro , gera o log de erros          �
        ���������������������������������������������������������������������������������*/
         
         If lA2AutoErr
            GeraLog( nRecno , "Ocorreram erros na Inclus�o do Fornecedor" )
         	lTemErro := .T.
         Else

         /*�������������������������������������������������������������������������������Ŀ
           �         Caso o fornecedor tenha sido gravado com sucesso retorna o Codigo     �
           �         e Loja do Fornecedor e atualiza o Cabecalho do Pedido.                �
           ���������������������������������������������������������������������������������*/

            _cCodForn  := aDadosForn[1]
        	_cCodFil   := aDadosForn[2]

         	aCabe[3,2] := Alltrim(_cCodForn)
         	aCabe[4,2] := Alltrim(_cCodFil)         

         Endif
            
      Else
   /*�������������������������������������������������������������������������������Ŀ
     �        Caso encontre o Fornecedor , verifica se o mesmo esta bloqueado        �
     ���������������������������������������������������������������������������������*/
      
         If SA2->A2_MSBLQL == "1"
         	GeraLog( nRecno , "Fornecedor" + SA2->A2_COD + " Bloqueado, solicite o desbloqueio do cadastro !!!" )
         	lTemErro := .T.

		 Else

		 	aCabe[3,2] := SA2->A2_COD
         	aCabe[4,2] := SA2->A2_LOJA         

		 EndIf

	  EndIf      
      
   /*�������������������������������������������������������������������������������Ŀ
     �                           Valida a Data de Necessidade                        �
     ���������������������������������������������������������������������������������*/

      If Empty( PED->DTENT )
         GeraLog( nRecno , "A data da necessidade est� em branco !" )
         lTemErro := .T.
      Endif
   /*�������������������������������������������������������������������������������Ŀ
     �                           Abre Cadastro de Empresas                           �
     ���������������������������������������������������������������������������������*/

      DbSelectArea("SM0")
      DbSetOrder(1)             
   
   /*�������������������������������������������������������������������������������Ŀ
     �                           Valida a Filial de Entrega                          �
     ���������������������������������������������������������������������������������*/
      If ! DbSeek( SM0->M0_CODIGO + PED->FILIAL ) .And. !Empty( PED->FILIAL )
         GeraLog( nRecno , "A Filial informada no arquivo : " + Alltrim( PED->FILIAL ) + " n�o foi encontrada no Cadastro de Empresas " )
         lTemErro := .T.
      Endif
      
   /*�������������������������������������������������������������������������������Ŀ
     �                       Abre o Cadastro de Unidades de Medidas                  �
     ���������������������������������������������������������������������������������*/

      DbSelectArea("SAH")
      DbSetOrder(1)             
   
   /*�������������������������������������������������������������������������������Ŀ
     �                           Valida a Unidade de Medida                          �
     ���������������������������������������������������������������������������������*/

      If ! DbSeek( xFilial("SAH") + PED->UNID ) .And. !Empty( PED->UNID )
         GeraLog( nRecno , "A Unidade de Medida do Produto : " + Alltrim( PED->DESCPROD ) + " n�o foi encontrada no Cadastro de Unidades de Medidas (SAH) " )
         lTemErro := .T.
      Endif

   /*�������������������������������������������������������������������������������Ŀ
     �                       Abre o Cadastro de Tipos                                �
     ���������������������������������������������������������������������������������*/

	  DbSelectArea("SX5")
      DbSetOrder(1)

   /*�������������������������������������������������������������������������������Ŀ
     �                           Valida o Tipo de Produto                            �
     ���������������������������������������������������������������������������������*/
      
      If ! DbSeek(xFilial("SX5")+"02" + PED->TIPOPROD) .And. !Empty( PED->TIPOPROD)
         GeraLog( nRecno , "O Tipo de Produto : " + Alltrim( PED->TIPO ) + " n�o foi encontrada no Cadastro de Tipos (SX5 - Tabela 02) " )
         lTemErro := .T.	
      EndIf		
      		
      		
   /*�������������������������������������������������������������������������������Ŀ
     �                           Atualiza o Flag de Erro                             �
     ���������������������������������������������������������������������������������*/
  
      If lTemErro .Or. Ascan( aTemErro , PED->NUMPED ) > 0 
         Aadd ( aTemErro , PED->NUMPED )     
      Else

      /*���������������������������������������������������������������������Ŀ
        �             Monta os Itens do Pedido de Compras                     �
        �����������������������������������������������������������������������*/

         Aadd ( aItem,{{"C7_ITEM"    , Alltrim(PED->ITEMPC)	,Nil } ,;     //TRATAR ---1
                       {"C7_PRODUTO" , _CodProd	                ,Nil } ,;
                       {"C7_QUANT"   , PED->QUANT				,Nil } ,;
                       {"C7_PRECO"   , PED->VLUNIT				,Nil },;
                       {"C7_DATPRF"  , dDtNessec				,Nil } ,;
                       {"C7_FLUXO"   , "S"						,Nil } ,;
                       {"C7_NUMSC"   , Alltrim(PED->NUMSC)		,Nil } ,;     //TRATAR 0 A ESQUERDA
                       {"C7_ITEMSC"  , Alltrim(PED->ITEMSC)		,Nil } ,;     //TRATAR ---1
                       {"C7_QTDSOL"  , PED->QUANT				,Nil } ,;
                       {"C7_LOCAL"   , Alltrim(PED->ARMAZEM)	,Nil } ,;
                       {"C7_OBS"     , PED->OBS					,Nil } ,;
                       {"C7_CC"      , PED->CCUSTO				,Nil } ,;
                       {"C7_CONTA"   , PED->CONTAC				,Nil } ,;
                       {"C7_ITEMCTA" , PED->ITEMC				,Nil } ,;
                       {"C7_CLVL"    , PED->CLVL				,Nil } ,;
                       {"C7_VLDESC"  , PED->VLDESC				,Nil } ,;   
                       {"C7_IPI"     , PED->ALIQIPI				,Nil } ,;   
                       {"C7_PICM"    , PED->ALIQICM				,Nil } } )
 
      Endif

    /*����������������������������������������������������������������������������Ŀ
      �            Processa o Proximo Registro do Arquivo Temporario               �
      ������������������������������������������������������������������������������*/
 
      DbSelectArea("PED")
      DbSkip()
      Loop

   Enddo

 /*����������������������������������������������������������������������������Ŀ
   �        Vericando se existe cabecalho ou item do Pedido de compras          �
   ������������������������������������������������������������������������������*/
   
   If Len( aItem ) > 0 .And. Len( aCabe ) > 0 .And. Len( aTemErro) == 0

   /*����������������������������������������������������������������������������Ŀ
     �                        Gera a Pedido de Compras                            �
     ������������������������������������������������������������������������������*/
      
      lC7AutoErr := GeraPedExecAuto( aCabe , aItem )

   /*����������������������������������������������������������������������������Ŀ
     �                        Caso haja erros , gera o Log                        �
     ������������������������������������������������������������������������������*/
      
      If lC7AutoErr
         GeraLog( nRecno , "Ocorreram Erros na Grava��o do Pedido de Compras N�mero : " + cNumPC   )
         lTemErro := .T.
      EndIf
      	 
   Endif
   
Enddo

Return

/*
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������ͻ��
���Programa  � GeraForn        � Autor �Cesar Moura         � Data � 04/07/2006 ���
�������������������������������������������������������������������������������͹��
���Descricao � Cria Fornecedor via MsExecAuto  	                                ���
���          �                                                                  ���
�������������������������������������������������������������������������������͹��
���Uso       � CSU CardSystem S.A                                               ���
�������������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
*/
Static Function GeraForn( aForn, Opcao)                      

/*����������������������������������������������������������������������������Ŀ
  �                 Declara as Variaveis Utilizadas na Rotina                  �
  ������������������������������������������������������������������������������*/

Local aArea 	:= GetArea()
Local lComErro  := .F.
Local _cForn
Local _cLoja

/*���������������������������������������������������������������������Ŀ
  �           Adiciona no Array os Produtos a serem Bloqueados          �
  �����������������������������������������������������������������������*/
//MsgAlert(aforn[7,2])

If Ascan ( aBlqForn , aForn[7,2]) == 0
   Aadd  ( aBlqForn , aForn[7,2])
Endif   

/*����������������������������������������������������������������������������Ŀ
  �                 Limpa as Variaveis referentes a MsExec                     �
  ������������������������������������������������������������������������������*/

lMsErroAuto 	:= .F. 
lMsHelpAuto 	:= .F.	
		            
/*���������������������������������������������������������������������Ŀ
  �               Executa a Gravacao do Fornecedor                      �
  �����������������������������������������������������������������������*/
 
MsExecAuto( { |x,y| Mata020( x , y ) } , aForn , Opcao )
	 
/*���������������������������������������������������������������������Ŀ
  � Carrega o Grupo de Perguntas Especifico da Rotina                   �
  �����������������������������������������������������������������������*/

Pergunte( cPerg , .F. )

/*���������������������������������������������������������������������Ŀ
  � Caso exista erro de Gravacao                                        �
  �����������������������������������������������������������������������*/
						
If lMsErroAuto
   MostraErro()
   lComErro    := .T.   
   lMsErroAuto := .F. 
   lMsHelpAuto := .F.	
Endif         

/*���������������������������������������������������������������������Ŀ
  � Atribui valores as vari�veis                                        �
  �����������������������������������������������������������������������*/

_cForn := SA2->A2_COD
_cLoja := SA2->A2_LOJA

/*���������������������������������������������������������������������Ŀ
  � Restaura a Area Antes da Execucao da Rotina                         �
  �����������������������������������������������������������������������*/

RestArea( aArea )


Return { _cForn, _cLoja , lComErro} 
   
/*
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������ͻ��
���Programa  � GeraPedExecAuto � Autor �Cristiano Figueiroa � Data � 30/06/2006 ���
�������������������������������������������������������������������������������͹��
���Descricao � Gera Pedido de Compras via ExecAuto                              ���
���          �                                                                  ���
�������������������������������������������������������������������������������͹��
���Uso       � CSU CardSystem S.A                                               ���
�������������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
*/

Static Function GeraPedExecAuto( aCabe , aItem )

/*���������������������������������������������������������������������Ŀ
  �        Declara as Variaveis Internas das Rotinas Automaticas        �
  �����������������������������������������������������������������������*/

Local aArea 	:= GetArea()
Local lComErr   := .F.

/*���������������������������������������������������������������������Ŀ
  �                 Limpa as variaveis da MsExecAuto                    �
  �����������������������������������������������������������������������*/

lMsErroAuto 	:= .F. 
lMsHelpAuto 	:= .F.	

/*���������������������������������������������������������������������Ŀ
  � Chama a Rotina de Gravacao Automatica - ExecAuto                    �
  �����������������������������������������������������������������������*/

MSExecAuto( { |v,x,y,z| MATA120(v,x,y,z) } , 1 , aCabe , aItem , 3 )    

/*���������������������������������������������������������������������Ŀ
  � Carrega o Grupo de Perguntas Especifico da Rotina                   �
  �����������������������������������������������������������������������*/

Pergunte( cPerg , .F. )

/*���������������������������������������������������������������������Ŀ
  � Caso exista erro de Gravacao                                        �
  �����������������������������������������������������������������������*/
					
If lMsErroAuto
   MostraErro()
   lComErro    := .T.   
   lMsErroAuto := .F. 
   lMsHelpAuto := .F.	
Endif         


RestArea( aArea )

Return lComErr 

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  � BloqForn � Autor � Analistas Microsiga � Data � 29/08/2006  ���
��������������������������������������������������������������������������͹��
���Descricao � Rotina para Bloquear os Fornecedores Incluidos pela Rotina  ���
���          �                                                             ���
��������������������������������������������������������������������������͹��
���Parametros� Array com os Fornecedores a serem Bloqueados                ���
���          �                                                             ���
��������������������������������������������������������������������������͹��
���Uso       � CSU CardSystem S.A                                          ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/

User Function BloqForn( aMsBlqlForn )

/*���������������������������������������������������������������������Ŀ
  �                    Declara as Variaveis da Rotina                   �
  �����������������������������������������������������������������������*/

Local aArea    := GetArea()
Local e        := 1

/*�������������������������������������������������������������������������������Ŀ
  �                        Abre o Cadastro de Fornecedores                        �
  ���������������������������������������������������������������������������������*/

DbSelectArea("SA2")
DbSetOrder(3)

/*�������������������������������������������������������������������������������Ŀ
  �                    Bloqueia todos os Fornecedores do Array                    �
  ���������������������������������������������������������������������������������*/

For e := 1 to Len ( aMsBlqlForn )
  
/*�������������������������������������������������������������������������������Ŀ
  �                        Posiciona no Cadastro de Fornecedores                  �
  ���������������������������������������������������������������������������������*/
   
   If DbSeek( xFilial("SA2") + aMsBlqlForn[e]  )
                                    
   /*����������������������������������������������������������������������������Ŀ
     �                              Realiza o Bloqueio                            �
     ������������������������������������������������������������������������������*/

      Reclock("SA2" , .F. )     
      	SA2->A2_MSBLQL := "1"
      MsUnlock()   

   /*����������������������������������������������������������������������������Ŀ
     �    Chama a Funcao que ira Disparar o WorkFlow de Desbloqueio do Fornecedor �
     ������������������������������������������������������������������������������*/

      u_Rwfwa03()
      
   Else
   
   
   
   Endif
   
   
Next e   

/*��������������������������������������������������������������������������������Ŀ
  �         Restaura as Areas Utilizadas antes da Execucao da Rotina               �
  ����������������������������������������������������������������������������������*/

RestArea(aArea)



Return
     
/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  �ValidPerg � Autor � Analistas Microsiga � Data � 13/02/2006  ���
��������������������������������������������������������������������������͹��
���Descricao � Cria o Grupo de Perguntas conforme Array                    ���
���          �                                                             ���
��������������������������������������������������������������������������͹��
���Uso       � CSU 					                                       ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/

Static Function ValidPerg( cPerg )

/*����������������������������������������������������������������������������Ŀ
  �            Declara as Variaveis Locais Utilizadas na Rotina                �
  ������������������������������������������������������������������������������*/

Local aRegs := {}

/*����������������������������������������������������������������������������Ŀ
  �            Adiciona as Perguntas no Array a ser Gravado no SX1             �
  ������������������������������������������������������������������������������*/

aAdd( aRegs , { cPerg , "01" , "Arquivo de Importacao ?"      , "         	   " , "            " , "MV_CH1" , "C" , 24 , 0 , 0 , "G" , "u_SelArquivo()" , "MV_PAR01" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""})
aAdd( aRegs , { cPerg , "02" , "Caminho dos Arquivos de Log ?" , "            " , "            " , "MV_CH2" , "C" , 50 , 0 , 0 , "G" , "" , "MV_PAR02" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""})


/*����������������������������������������������������������������������������Ŀ
  �            Verifica se Ja Existe Registro no SX1 e Grava                   �
  ������������������������������������������������������������������������������*/

DbSelectArea("SX1")
DbSetOrder(1)

For i := 1 to Len( aRegs )
   If !SX1->(dbSeek(cPerg+aRegs[i,2]))
      RecLock("SX1",.T.)
	  For j:=1 to FCount()
	     If j <= Len(aRegs[i])
		    FieldPut(j,aRegs[i,j])
		 Endif
	  Next
	  SX1->(MsUnlock())
   Endif
Next  

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RelIncons � Autor � Cristiano Figueiroa� Data � 30/06/2006  ���
�������������������������������������������������������������������������͹��
���Descricao �Imprime o Relatorio de Inconsistencias do Processo de       ���
���          �Importacao dO Pedido de Compras.                            ���
�������������������������������������������������������������������������͹��
���Uso       �Protheus 8.11                                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/ 

Static Function RelInco()

/*����������������������������������������������������������������������Ŀ
  � Define as variaveis necessarias                                      �
  ������������������������������������������������������������������������*/

cString  := "PED"
cDesc1   := "Esta rotina tem como Objetivo Imprimir os Registros Inconsistentes "
cDesc2   := "do Processo de Importa�ao de Pedido de Compras existentes nos Arquivos "
cDesc3   := "Gerados pelo Sistema da Empresa Hold - Espec�fico CSU CardSystem S.A"
tamanho  := "G"
aReturn  := { "Zebrado", 1 , "Contabilidade" , 1 , 1 , 2 , "" , 1 }
Nomeprog := "Incons"
Wnrel    := "Incons"
nLastKey := 0
m_pag    := 1
nLin     := 80
cTitulo  := "Relatorio de Inconsistencias - Processo de Importa��o do Pedido de Compras do Sistema Hold "
cCabec2  := ""
cCabec1  := "Linha   Inconsistencia "

/*����������������������������������������������������������������������������Ŀ
  �                   Adiciona a Regua de Processamento                        �
  ������������������������������������������������������������������������������*/

 IncProc("Gerando Relat�rio de Inconsistencias")
 
/*�����������������������������������������������������������������������Ŀ
  �               Envia Controle para a Funcao SetPrint                   �
  �������������������������������������������������������������������������*/

wnrel := SetPrint( cString , Wnrel , , cTitulo , cDesc1 , cDesc2 , cDesc3 , .F. , "" , .F. , Tamanho )

/*�����������������������������������������������������������������������Ŀ
  �               Verifica o Cancelamento do Relatorio                    �
  �������������������������������������������������������������������������*/

If nLastKey == 27
   Return
Endif

/*�����������������������������������������������������������������������Ŀ
  �                           Chama a SetDefault                          �
  �������������������������������������������������������������������������*/

SetDefault(aReturn,cString)

/*�����������������������������������������������������������������������Ŀ
  �               Verifica o Cancelamento do Relatorio                    �
  �������������������������������������������������������������������������*/

If nLastKey == 27
   Return
Endif

/*�����������������������������������������������������������������������Ŀ
  �            Chama a Rotina de Processamento do Relatorio               �
  �������������������������������������������������������������������������*/

RptStatus( { || PrintInco() }, "Processando o Relatorio de Inconsistencias" )

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�Ao    �PrintInco � Autor � Cristiano Figueiroa   � Data �30/06/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Processa os Itens do Relatorio de Inconsistencias           ���
���			 � 														      ���
�������������������������������������������������������������������������Ĵ��
���Uso       � CSU CardSystem S.A                                         ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function PrintInco()

/*�����������������������������������������������������������������������Ŀ
  �                  Abre o Arquivo de Inconsistencias                    �
  �������������������������������������������������������������������������*/

DbSelectArea("INC")
DbGotop()
SetRegua(Reccount())

/*�����������������������������������������������������������������������Ŀ
  �               Processa as Inconsistencias no Relatorio                �
  �������������������������������������������������������������������������*/

Do While INC->( !Eof() )
	
  /*�������������������������������������������������������������������Ŀ
	� Imprime o cabecalho                                               �
	���������������������������������������������������������������������*/
	
	If nLin >= 60
	   nLin := Cabec( cTitulo, cCabec1, cCabec2, Nomeprog , Tamanho , 15 ) + 1
	   nLin ++
	Endif
	
  /*�������������������������������������������������������������������Ŀ
	� Imprime a Linha de Detalhe                                        �
	���������������������������������������������������������������������*/
	
	@ nLin , 000  PSay INC->LINHA
	@ nLin , 008  PSay INC->DESCRICAO
	nLin ++

  /*�������������������������������������������������������������������Ŀ
	�             Processa o Proximo Registro Inconsistente             �
	���������������������������������������������������������������������*/

	DbSelectarea("INC")
	IncRegua()
	DbSkip()
	
Enddo

/*�������������������������������������������������������������������Ŀ
  � Imprime o Rodape do Relatorio                                     �
  ���������������������������������������������������������������������*/

Roda( 0 , "" , Tamanho )

/*����������������������������������������������������������������������Ŀ
  � Caso a Impressao seja realizada em Disco , Exibe na Tela o Relatorio �
  ������������������������������������������������������������������������*/

If aReturn[5] == 1
   Set Printer To
   Commit
   OurSpool(Wnrel)
Endif

MS_FLUSH()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun�Ao    � CopyLog  � Autor � Cristiano Figueiroa   � Data �30/06/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Copia o Arquivo Temporario de Inconsistencias para o        ���
���			 �Diretorio de Log                    		                  ���
�������������������������������������������������������������������������Ĵ��
���Uso       � CSU CardSystem S.A                                         ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function CopyLog()

/*����������������������������������������������������������������������������Ŀ
  �                  Declara as Variaveis Utilizadas na Rotina                 �
  ������������������������������������������������������������������������������*/

Local cDiretorio := Alltrim(MV_PAR02)
Local cDestino   := DtoS(Date()) + StrTran( Time() , ":" , "" )  + ".XLS"

/*����������������������������������������������������������������������������Ŀ
  �                  Gera o Cabecalho do Arquivo de Log                        �
  ������������������������������������������������������������������������������*/
GeraLog( 0 , Replicate("=" , 220 )   , "0" )
GeraLog( 0 , "Arquivo : " + MV_PAR01 , "0" )
GeraLog( 0 , "Data    : " + Dtoc(Date()) , "0" )
GeraLog( 0 , "Hora    : " + Time() , "0" )
GeraLog( 0 , "Usuario : " + Substr(cUsuario , 7 , 15 ) , "0" )
GeraLog( 0 , "Empresa : " + SM0->M0_NOME + " - " + SM0->M0_FILIAL , "0" )
GeraLog( 0 , "" , "0" )
GeraLog( 0 , Replicate("=" , 220 ) , "0" )

/*����������������������������������������������������������������������������Ŀ
  �   Copia o Arquivo Temporario de Inconsistencias para o Diretorio de Log    �
  ������������������������������������������������������������������������������*/

DbSelectArea("INC")
Copy to &(Alltrim(cDiretorio) + Alltrim(cDestino)) SDF

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GeraLog � Autor � Cristiano Figueiroa � Data � 30/06/2006  ���
�������������������������������������������������������������������������͹��
���Descricao �Grava o Arquivo de Log a Inconsistencia encontrada no       ���
���          �Processamento.                                              ���
�������������������������������������������������������������������������͹��
���Uso       �CSU CardSystem S.A                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function GeraLog( nLinha , cDescricao , cSequencia )

/*������������������������������������������������������������������Ŀ
  �            Declara as Variaveis  Utilizadas na Rotina            �
  ��������������������������������������������������������������������*/

Local aArea := GetArea()

/*������������������������������������������������������������������Ŀ
  �               Abre a Tabela de Inconsistencias                   �
  ��������������������������������������������������������������������*/

DbSelectArea("INC")

/*������������������������������������������������������������������Ŀ
  �               Grava o Registro de Inconsistencias                �
  ��������������������������������������������������������������������*/

Reclock( "INC" , .T. )
INC->LINHA     := Iif ( nLinha == 0 , "" , StrZero( nLinha , 5 ) )
INC->DESCRICAO := cDescricao
INC->SEQ       := Iif ( cSequencia == Nil , "2" , cSequencia )
Msunlock()

/*������������������������������������������������������������������Ŀ
  �                 Restaura as Areas Utilizadas                     �
  ��������������������������������������������������������������������*/

RestArea(aArea)

Return