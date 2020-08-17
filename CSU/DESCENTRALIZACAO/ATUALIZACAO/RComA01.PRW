#Include "RwMake.ch"                             
/*                                                                     
ээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммямммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  Ё RComA01  ╨ Autor Ё Cristiano Figueiroa ╨ Data Ё 30/06/2006  ╨╠╠
╠╠лммммммммммьммммммммммймммммммомммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Descricao Ё Importacao de Solicitacao de Compras Geradas no Sistema     ╨╠╠
╠╠╨          Ё de E-Procurement da Hold.                                   ╨╠╠
╠╠лммммммммммьммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё CSU - CardSystem S.A                                        ╨╠╠
╠╠хммммммммммоммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/

User Function RComA01()

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддLддддддддддддддддддддддд©
  Ё                 Declara as Variaveis Utilizadas na Rotina                  Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

Local   aArea     := GetArea()
Local   aAreaSB1  := SB1->( GetArea() )
Local   aAreaSA2  := SA2->( GetArea() )
Local   aAreaCTT  := CTT->( GetArea() )
Local   aAreaCT1  := CT1->( GetArea() )
Local   aAreaCTD  := CTD->( GetArea() )
Local   aAreaCTH  := CTH->( GetArea() )
Local   aAreaSC1  := SC1->( GetArea() )

Private cPerg     := PADR("RCOMA1",LEN(SX1->X1_GRUPO))
Private nOpc      := 0
Private cCadastro := "ImportaГЦo de SolicitaГЦo de Compras"
Private aSay      := {}
Private aButton   := {}
Private aCabe     := {}
Private aItem     := {}
Private aBlqProd  := {}
Private cFile1
Private cFile2
Private cFile3
Private _CodProd


/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё           Verifica se o Grupo de Perguntas existe ou nao                   Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

ValidPerg( cPerg )

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                   Cria os Parametros Necessarios a Rotina                  Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

CriaSX6()

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё               Carrega o Grupo de Perguntas na Tela                         Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

Pergunte( cPerg , .T. )

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё           Monta a Janela de Dialogo com as Mensagens Explicativas          Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

aAdd ( aSay , "                                                                                        " )
aAdd ( aSay , "Esta rotina tem como objetivo a realizacao de ImportaГЦo de SolicitaГУes de Compras do  " )
aAdd ( aSay , "                sistema da empresa Hold Tecnologia da Informacao.                       " )
aAdd ( aSay , "                                                                                        " )
aAdd ( aSay , "==> Sistemas Envolvidos : Protheus 8 / Hold                                             " )
aAdd ( aSay , "==> Formato do Arquivo  : Texto ( Asc II )                                              " )
aAdd ( aSay , "==> Nome do Arquivo     : SCAAMMDDHHMMSS.Txt                                            " )
aAdd ( aSay , "                                                                                        " )

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё              Monta a os Botoes a serem Disponibilizados na Tela            Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

aAdd ( aButton , { 1 , .T. , { || nOpc := 1  , FechaBatch() }} )
aAdd ( aButton , { 2 , .T. , { || FechaBatch()              }} )
aAdd ( aButton , { 5 , .T. , { || Pergunte( cPerg , .T. )   }} )

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё              Abre a Tela para o Processamento das Opcoes                   Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

FormBatch( cCadastro , aSay , aButton )

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё              Caso o Usuario Tenha acessado o Botao de Ok                   Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

If nOpc == 1
   Processa( { |lEnd| RComA01A() } ,  "Processando o Arquivo : " + MV_PAR01 , "Aguarde" , .F. )
Endif   

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё Fecha os Arquivos Temporarios e Restaura as Areas Antes da Execucao da Rotina  Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

If Select("SOL") > 0
   DbSelectArea("SOL")
   DbCloseArea()
Endif

If Select("INC")  > 0
   DbSelectArea("INC")
   DbCloseArea()
Endif

If Select("PRO")  > 0
   DbSelectArea("PRO")
   DbCloseArea()
Endif

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё         Restaura as Areas Utilizadas antes da Execucao da Rotina               Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

RestArea(aAreaSB1)
RestArea(aAreaSA2)
RestArea(aAreaCTT)
RestArea(aAreaCT1)
RestArea(aAreaCTD)
RestArea(aAreaCTH)
RestArea(aAreaSC1)
RestArea(aArea   )

Return                      

/*
ээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммямммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  Ё RComA01a ╨ Autor Ё Cristiano Figueiroa ╨ Data Ё 30/06/2006  ╨╠╠
╠╠лммммммммммьммммммммммймммммммомммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Descricao Ё Rotina Principal de Importacao de Solicitacoes de Compras   ╨╠╠
╠╠╨          Ё                                                             ╨╠╠
╠╠лммммммммммьммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё CSU - CardSystem S.A                                        ╨╠╠
╠╠хммммммммммоммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/

Static Function RComA01a()

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё            Declara as Variaveis Locais Utilizadas na Rotina                Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё      Configura a Regua com a quantidade de Rotinas a ser Processadas       Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

ProcRegua( 5 )

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё          Verifica se o Arquivo Existe no Caminho Especificado              Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

If !File( Alltrim(MV_PAR01)  ) 
   Aviso( "AtenГЦo !" , "O Arquivo : " + Alltrim(MV_PAR01) + " nЦo foi encontrado !" , {"Ok"} , 1 , "OperaГЦo Cancelada" )
   Return   
Endif

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё              Cria os Arquivos Temporarios a serem utilizados               Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

MontaTrb()
IncProc("Preparando o Arquivo de Trabalho")

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                   Abre o Arquivo TXT a ser Importado                       Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

ImportaTrb()         
IncProc("Importando o Arquivo : " + Alltrim(MV_PAR01) )

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё             Inicia as Validacoes conforme Lay-Out e Necessidade            Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

ValidTrb()
IncProc("Validando o Arquivo de Trabalho" )

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё          Gera o Arquivo de Solicitacoes Processadas com Sucesso            Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

CopyProc()
IncProc("Gerando o Arquivo de S.C processadas" )

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё               Realiza o Bloqueio dos Produtos Incluidos                    Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

u_BloqProd( aBlqProd )
IncProc("Bloqueando os Produtos incluМdos pela Rotina" )

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё             Exibe mensagem do final do processo de importacao              Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

Aviso( "AtenГЦo !" , "Final do Processo de Importacao !" , {"Ok"} , 1 , "OperaГЦo Realizada" )

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё               Caso haja Inconsistencias Exibe as Mesmas em Tela            Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

If INC->( Reccount()) > 0

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё Chama a Rotina que Copia o Arquivo Temporario de Inconsistencias para o Arquivo de Log Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

   CopyLog()

 /*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
   Ё Pergunta se o Usuario quer ou nЦo Visualizar o Relatorio de Inconsistenacias Ё
   юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

   If Aviso("AtenГЦo !" , "Deseja Visualizar o RelatСrio de Inconsistencias ? " , {"Sim","NЦo"} , 1 , "Inconsistencias no Processo" ) ==  1 
      RelInco()
      Return
   Endif

Endif

Return

/*
ээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммямммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  Ё MontaTrb ╨ Autor Ё Cristiano Figueiroa ╨ Data Ё 30/06/2006  ╨╠╠
╠╠лммммммммммьммммммммммймммммммомммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Descricao Ё Monta o Arquivo Temporario para Importacao dos Dados        ╨╠╠
╠╠╨          Ё                                                             ╨╠╠
╠╠лммммммммммьммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё CSU - CardSystem S.A                                        ╨╠╠
╠╠хммммммммммоммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/

Static Function MontaTrb()

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                    Declara as variaveis utilizadas                         Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

Local aFile1 := {}
Local aFile2 := {}
Local aFile3 := {}

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                Monta a Estrutura dos Arquivos Temporarios                  Ё   
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

aFile1 := {  {"FILIAL " , "C" , 002 , 0 } , {"NUM      " , "C" , 006 , 0 } ,;
             {"ITEM   " , "C" , 004 , 0 } , {"PRODUTO  " , "C" , 015 , 0 } ,;
             {"UM     " , "C" , 002 , 0 } , {"QUANT    " , "N" , 012 , 2 } ,;
	    	 {"SEGUM  " , "C" , 002 , 0 } , {"QTSEGUM  " , "N" , 012 , 2 } ,;
             {"DATPRF " , "D" , 008 , 0 } , {"LOCPAD   " , "C" , 002 , 0 } ,;          
             {"OBS    " , "C" , 030 , 0 } , {"CC       " , "C" , 009 , 0 } ,;          
             {"CONTA  " , "C" , 020 , 0 } , {"ITEMCTA  " , "C" , 009 , 0 } ,;          
             {"EMISSAO" , "D" , 008 , 0 } , {"FORNECE  " , "C" , 006 , 0 } ,;          
             {"LOJA   " , "C" , 002 , 0 } , {"SOLICIT  " , "C" , 014 , 0 } ,;          
             {"USUARIO" , "C" , 006 , 0 } , {"CLVL     " , "C" , 009 , 0 } ,;                                           
             {"FILENT " , "C" , 002 , 0 } , {"DESCRIC  " , "C" , 030 , 0 } ,;
	     	 {"TIPO   " , "C" , 002 , 0 } , {"TPREGIS  " , "C" , 001 , 0 }  }          
           

aFile2 := { {"LINHA     " , "C" , 006 , 0 } , {"SEQ" , "C" , 001 , 0 } ,;
            {"DESCRICAO " , "C" , 200 , 0 } }                                 // Arquivo de Inconsistencias

aFile3 := { ;                                                                 // Arquivo de Solicitacoes de Compras
             {"FILIAL " , "C" , 002 , 0 } , {"NUM      " , "C" , 006 , 0 } ,;
             {"ITEM   " , "C" , 004 , 0 } , {"PRODUTO  " , "C" , 015 , 0 } ,;
             {"ACEITE " , "C" , 001 , 0 } }          

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                      Cria area Temporaria no Sistema                       Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

cFile1 := CriaTrab( aFile1 )   // Arquivo de Trabalho
cFile2 := CriaTrab( aFile2 )   // Arquivo de Inconsistencias
cFile3 := CriaTrab( aFile3 )   // Arquivo de Solicitacoes Processadas

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                     Cria o Arquivo Temporario no Sistema                   Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

DbUseArea(.T. , , cFile1 , "SOL" , .T. )  // Arquivo de Solicitacoes de Compras
DbUseArea(.T. , , cFile2 , "INC"  , .T. ) // Arquivo de Inconsistencias
DbUseArea(.T. , , cFile3 , "PRO"  , .T. ) // Arquivo de Solicitacoes Processadas

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                     Cria o Indice Temporario no Sistema                    Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

IndRegua("SOL" , cFile1 , "NUM + ITEM" ,,, "Criando Arquivo...")  
IndRegua("INC" , cFile2 , "LINHA"      ,,, "Criando Arquivo...")
IndRegua("PRO" , cFile3 , "NUM + ITEM" ,,, "Criando Arquivo...")

Return

/*
ээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммямммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  ЁImportaTrb╨ Autor Ё Cristiano Figueiroa ╨ Data Ё 30/06/2006  ╨╠╠
╠╠лммммммммммьммммммммммймммммммомммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Descricao Ё Importa o Arquivo Txt para o Arquivo Dbf Temporario         ╨╠╠
╠╠╨          Ё                                                             ╨╠╠
╠╠лммммммммммьммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё CSU CardSystem S.A                                          ╨╠╠
╠╠хммммммммммоммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/

Static Function ImportaTrb()

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё              Executa a Importacao do Txt para o Dbf temporario             Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

DbSelectArea("SOL")
Append From &( Alltrim(MV_PAR01) ) SDF

Return

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммямммммммммкмммммммямммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  ЁValidTrb ╨ Autor Ё Cristiano Figueiroa ╨ Data Ё 30/06/2006  ╨╠╠
╠╠лммммммммммьмммммммммймммммммомммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Descricao ЁValida o Arquivo de Trabalho conforme Lay-Out fornecido     ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       ЁCSU CardSystem S.A                                          ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/

Static Function ValidTrb()

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                Declara as Variaveis Utilizadas na Rotina                   Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

Private aTemErro   := {}
Private nRecno     := 0
Private lTemErro   := .F.
Private cNumSC     := ""
Private lB1AutoErr := .F.
Private lC1AutoErr := .F.
Private dDtEmissao := Ctod("  /  /  ")
Private dDtNessec  := Ctod("  /  /  ")

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                  Abre o Arquivo Temporario para a Validacao                Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

DbSelectArea("SOL")
DbGoTop()

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё            Configura a Regua com a Registros a serem Processados           Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

ProcRegua( SOL->(Reccount()) )

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                  Processa Todos os Registros do Arquivo                    Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

Do While SOL->( !Eof() )

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                   Adiciona a Regua de Processamento                        Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

   IncProc("Processando a SolicitaГЦo de Compras : " + SOL->NUM )
            
/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё              Atribui o numero da solicitacao de compras a variavel         Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

   cNumSC     := SOL->NUM
   lTemErro   := .F. 
   aTemErro   := {}
   aItem      := {}
   dDtEmissao := Ctod( Substr ( Dtoc ( SOL->EMISSAO) , 7 , 2 ) + "/" + Substr ( Dtoc ( SOL->EMISSAO) , 4 , 2 ) + "/" + Substr ( Dtoc ( SOL->EMISSAO) , 1 , 2 ))  
   dDtNessec  := Ctod( Substr ( Dtoc ( SOL->DATPRF ) , 7 , 2 ) + "/" + Substr ( Dtoc ( SOL->DATPRF ) , 4 , 2 ) + "/" + Substr ( Dtoc ( SOL->DATPRF ) , 1 , 2 ))  	
   _CodProd	  := SUBSTR(SOL->PRODUTO,12,4)	   

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                 Monta o Cabecalho da Solicitacao de Compras                Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

//   aCabe    := {{"C1_NUM    " , SOL->NUM , Nil } , {"C1_SOLICIT" , SOL->SOLICIT   , Nil } , {"C1_EMISSAO" , dDtEmissao , Nil }}  
   aCabe    := {{"C1_NUM    " , SOL->NUM , Nil } , {"C1_SOLICIT" , SOL->SOLICIT   , Nil } , {"C1_EMISSAO" , dDtEmissao , Nil },{"C1_USER" , SOL->USUARIO , Nil } }  
                            
/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё              Processa todos os itens dessa solicitacao de compras          Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
   
   Do While SOL->( !Eof() ) .And. SOL->NUM == cNumSC
 
    /*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
      Ё                 Atribui o Numero do Registro Atual                         Ё
      юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

      nRecno := SOL->( Recno() )
   
   /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
     Ё                    Abre o Cadastro de Solicitacoes de Compras                 Ё
     юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

      DbSelectArea("SC1") 
      DbSetOrder(1)
   
   /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
     Ё                Posiciona no Cadastro de Solicitacoes de Compras               Ё
     юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

      If DbSeek( SOL->FILIAL + SOL->NUM  )
                                   
      /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
        Ё   Caso o tipo de registro seja inclusao e ja exista Solicitacao de Compras    Ё
        Ё   na Filial , gera inconsistencia.                                            Ё
        юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

         If SOL->TPREGIS $ "I"
            GeraLog( nRecno , "A SolicitaГЦo de Compras NЗmero : " + Alltrim( SOL->NUM ) + " na filial : " + SOL->FILIAL + " jА existe !" )
            lTemErro := .T.
         Else
         
         /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
           Ё   Caso o tipo de registro seja alteracao ou exclusao e ja exista Solicitacao  Ё
           Ё   de Compras na Filial , veifica se ja existe Pedido de Compras vinculado ou  Ё
           Ё   Quantidade ja entregue , caso positivo , gera inconsistencia.               Ё
           юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

            If ! Empty( SC1->C1_PEDIDO ) .Or. ! Empty( SC1->C1_ITEMPED )
               GeraLog( nRecno , "A SolicitaГЦo de Compras NЗmero : " + Alltrim( SOL->NUM ) + " na filial : " + SOL->FILIAL + " jА possui o Pedido de Compras ( NЗmero : " + SC1->C1_PEDIDO + " ) vinculado !" )
               lTemErro := .T.
            Endif                        
          
            If ! Empty( SC1->C1_QUJE )
               GeraLog( nRecno , "A SolicitaГЦo de Compras NЗmero : " + Alltrim( SOL->NUM ) + " na filial : " + SOL->FILIAL + " jА possui entregas parciais !" )
               lTemErro := .T.
            Endif                        

         Endif

      Else

      /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
        Ё   Caso o tipo de registro seja alteracao ou exclusao e nao exista Solicitacao Ё
        Ё   de Compras na Filial , gera inconsistencia.                                 Ё
        юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

         If SOL->TPREGIS $ "A/E"
            GeraLog( nRecno , "A SolicitaГЦo de Compras NЗmero : " + Alltrim( SOL->NUM ) + " na filial : " + SOL->FILIAL + " nЦo foi encontrada !" )
            lTemErro := .T.
         Endif

      Endif

   /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
     Ё  Verifica se o Usuario esta Cadastrado , caso contrario gera inconsistencia   Ё
     юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

      If !UsrExist(SOL->USUARIO) 
         GeraLog( nRecno , "O Usuario CСdigo : " + Alltrim(SOL->USUARIO) + " nЦo foi encontrado !" )
         lTemErro := .T.
      Endif

   /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
     Ё                    Abre o Cadastro de Unidades de Medidas                     Ё
     юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

      DbSelectArea("SAH")
      DbSetOrder(1)             
   
   /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
     Ё                  Posiciona no Cadastro de Unidades de Medida                  Ё
     юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

      If ! DbSeek( xFilial("SAH") + SOL->UM )
         GeraLog( nRecno , "A Unidade de Medida : " + Alltrim( SOL->UM ) + " nЦo foi encontrada !" )
         lTemErro := .T.
      Endif

      If ! DbSeek( xFilial("SAH") + SOL->SEGUM ) .And. !Empty( SOL->SEGUM )
         GeraLog( nRecno , "A Segunda Unidade de Medida : " + Alltrim( SOL->SEGUM ) + " nЦo foi encontrada !" )
         lTemErro := .T.
      Endif

   /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
     Ё                        Abre o Cadastro de Produtos                            Ё
     юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

      DbSelectArea("SB1")
      DbSetOrder(1)

   /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
     Ё                        Posiciona no Cadastro de Produtos                      Ё
     юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
	  If DbSeek( xFilial("SB1") + _CodProd ) //_cCodProd

         If SB1->B1_MSBLQL == "1"
	  		GeraLog( nRecno , "Produto : " + Alltrim( _CodProd ) + " Bloqueado para uso " + Alltrim( SOL->DESCRIC )  + ". A SolicitaГЦo de Compras : " + SOL->NUM + " nЦo serА Importada !" )
            lTemErro := .T.
      	 EndIf           
      	 
      /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
        Ё               Caso nao Exista , Chama a ExecAuto e Cria o Produto             Ё
        юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
      Else
        
         lB1AutoErr := u_IncluiProd( _CodProd , SOL->DESCRIC   , SOL->TIPO , SOL->UM , Iif ( Empty( SOL->LOCPAD ) , GetMv("MV_LPPROD") , SOL->LOCPAD ) )
      
      /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
        Ё            Verifica se a inclusao do Produto deu Erro ou nao                  Ё
        юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
         If lB1AutoErr
            GeraLog( nRecno , "Ocorreram erros na InclusЦo do Produto : " + Alltrim( _CodProd ) + " " + Alltrim( SOL->DESCRIC )  + ". A SolicitaГЦo de Compras : " + SOL->NUM + " nЦo serА Importada !" )
            lTemErro := .T.
         Endif   
      
      Endif

   /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
     Ё                     Abre o Cadastro de Plano de Contas                        Ё
     юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

      DbSelectArea("CT1")
      DbSetOrder(1)             
     
   /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
     Ё                  Posiciona no Cadastro de Plano de Contas                     Ё
     юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

      If ! DbSeek( xFilial("CT1") + SOL->CONTA ) .And. !Empty( SOL->CONTA )
         GeraLog( nRecno , "A conta contАbil : " + Alltrim( SOL->CONTA ) + " nЦo foi encontrada !" )
         lTemErro := .T.
      Endif

   /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
     Ё                        Abre o Cadastro de Centro de Custo                     Ё
     юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

      DbSelectArea("CTT")
      DbSetOrder(1)             
   
   /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
     Ё                   Posiciona no Cadastro de Centro de Custo                    Ё
     юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

      If ! DbSeek( xFilial("CTT") + SOL->CC ) .And.!Empty( SOL->CC )
      
         GeraLog( nRecno , "O centro de custo : " + Alltrim( SOL->CC ) + " nЦo foi encontrado. A SolicitaГЦo de Compras : " + SOL->NUM + " nЦo serА Importada !" )
         lTemErro := .T.      
 
   /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
     Ё                   Verifica se Centro de Custo esta bloqueado                  Ё
     юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

      ElseIf CTT_BLOQ == "1"
      
         GeraLog( nRecno , "O centro de custo : " + Alltrim( SOL->CC ) + " esta bloqueado para uso. A SolicitaГЦo de Compras : " + SOL->NUM + " nЦo serА Importada !" )
         lTemErro := .T. 
      
      Endif


   /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
     Ё                        Abre o Cadastro de Itens Contabeis                     Ё
     юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

      DbSelectArea("CTD")
      DbSetOrder(1)             
     
   /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
     Ё                   Posiciona no Cadastro de Itens Contabeis                    Ё
     юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

      If ! DbSeek( xFilial("CTD") + SOL->ITEMCTA ) .And. !Empty( SOL->CONTA )
         GeraLog( nRecno , "O item contabil : " + Alltrim( SOL->ITEMCTA ) + " nЦo foi encontrado !" )
         lTemErro := .T.
      Endif

   /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
     Ё                       Abre o Cadastro de Classe de Valor                      Ё
     юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

      DbSelectArea("CTH")
      DbSetOrder(1)             
   
   /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
     Ё                   Posiciona no Cadastro de Itens Contabeis                    Ё
     юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

      If ! DbSeek( xFilial("CTH") + SOL->CLVL ) .And. !Empty( SOL->CLVL )
         GeraLog( nRecno , "A classe de valor : " + Alltrim( SOL->CLVL ) + " nЦo foi encontrada !" )
         lTemErro := .T.
      Endif
                    
   /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
     Ё                       Valida a Quantidade Informada                           Ё
     юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

      If SOL->QUANT <= 0
         GeraLog( nRecno , "A quantidade nЦo pode ser menor ou igual a zero !" )
         lTemErro := .T.
      Endif

   /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
     Ё                           Valida a Data de Emissao                            Ё
     юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

      If Empty( SOL->EMISSAO )
         GeraLog( nRecno , "A data de emissao estА em branco !" )
         lTemErro := .T.
      Endif

   /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
     Ё                           Valida a Data de Emissao                            Ё
     юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

      If Empty( SOL->LOCPAD )
         GeraLog( nRecno , "O ArmazИm estА em branco !" )
         lTemErro := .T.
      Endif

   /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
     Ё                       Abre o Cadastro de Fornecedores                         Ё
     юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

      DbSelectArea("SA2")
      DbSetOrder(1)             
   
   /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
     Ё                   Posiciona no Cadastro de Fornecedores                       Ё
     юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

      If ! DbSeek( xFilial("SA2") + SOL->FORNECE + SOL->LOJA ) .And. !Empty( Alltrim( SOL->FORNECE + SOL->LOJA ) )
         GeraLog( nRecno , "O fornecedor : " + Alltrim( SOL->FORNECE ) + " / " + Alltrim( SOL->LOJA ) + " nЦo foi encontrada !" )
         lTemErro := .T.
      Endif
                                                                             
   /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
     Ё                           Valida a Data de Necessidade                        Ё
     юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

      If Empty( SOL->DATPRF )
         GeraLog( nRecno , "A data da necessidade estА em branco !" )
         lTemErro := .T.
      Endif

   /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
     Ё                           Valida o Tipo de Registro                           Ё
     юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

      If !( SOL->TPREGIS $ "IAE" )
         GeraLog( nRecno , "O tipo de registro deve ser I , A ou E !" )
         lTemErro := .T.
      Endif
               
   /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
     Ё                           Atualiza o Flag de Erro                             Ё
     юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
  
      If lTemErro .Or. Ascan( aTemErro , SOL->NUM ) > 0
         Aadd ( aTemErro , SOL->NUM )     
      Else
      
      /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
        Ё             Monta os Itens da Solicitacao de Compras                Ё
        юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

         Aadd ( aItem	, { {"C1_FILIAL"	, SOL->FILIAL                 , Nil } ,;
                            {"C1_NUM" 		, SOL->NUM                    , Nil } ,;
                            {"C1_ITEM" 		, StrZero(Val(SOL->ITEM),4)  , Nil } ,;
                            {"C1_PRODUTO" 	, _CodProd                    , Nil } ,;
                            {"C1_UM" 		, SOL->UM                     , Nil } ,;
                            {"C1_QUANT" 	, SOL->QUANT                  , Nil } ,;
                            {"C1_SEGUM" 	, SOL->SEGUM                  , Nil } ,;
                            {"C1_QTSEGUM" 	, SOL->QTSEGUM                , Nil } ,;
                            {"C1_DATPRF" 	, dDtNessec                   , Nil } ,;
                            {"C1_LOCAL" 	, SOL->LOCPAD                 , Nil } ,;
                            {"C1_OBS" 		, SOL->OBS                    , Nil } ,;
                            {"C1_CC" 		, SOL->CC                     , Nil } ,;
                            {"C1_CONTA" 	, SOL->CONTA                  , Nil } ,;
                            {"C1_ITEMCTA" 	, SOL->ITEMCTA                , Nil } ,;
                            {"C1_EMISSAO" 	, dDtEmissao                  , Nil } ,;
                            {"C1_SOLICIT" 	, SOL->SOLICIT                , Nil } ,;
                            {"C1_USER" 		, SOL->USUARIO                , Nil } ,;
                            {"C1_CLVL" 		, SOL->CLVL                   , Nil } ,;
                            {"C1_TPREGIS" 	, SOL->TPREGIS                , Nil } ,;
                            {"C1_FILENT" 	, SOL->FILENT                 , Nil } } )
     
      Endif

    /*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
      Ё            Processa o Proximo Registro do Arquivo Temporario               Ё
      юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
 
      DbSelectArea("SOL")
      DbSkip()
      Loop

   Enddo

 /*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
   Ё        Vericando se existe cabecalho ou item das solicitacoes de compras   Ё
   юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
   
   
   If Len( aItem ) > 0 .And. Len( aCabe ) > 0 .And. Len( aTemErro) == 0

   /*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
     Ё                        Gera a Solicitacao de Compras                       Ё
     юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

//    GeraSolRecLock  ( aCabe , aItem )

   /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
     Ё               Chama a Geracao da Solicitacao de Compras Via ExecAuto          Ё
     юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

      lC1AutoErr := GeraSolExecAuto( aCabe , aItem )

   /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
     Ё            Verifica se a inclusao do Produto deu Erro ou nao                  Ё
     юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

      If lC1AutoErr
         GeraLog( nRecno , "Ocorreram erros na GravaГЦo da SolicitaГЦo de Compras NЗmero : " + aCabe[ 1 , 2 ] + " !" )
         lTemErro := .T.
      Else

      /*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
        Ё           Atualiza o Arquivo de Solicitacoes de Compras Processadas        Ё
        юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

         For k := 1 to Len( aItem )
            GeraProc( aItem[ k , 1 , 2 ] ,  aItem[ k , 2 , 2 ] ,  aItem[ k , 3 , 2 ] ,  aItem[ k , 4 , 2 ] , "A" )
         Next k   
        
      Endif   

   Endif
   
Enddo

Return


/*
ээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммямммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  Ё CopyProc ╨ Autor Ё Cristiano Figueiroa ╨ Data Ё 04/07/2006  ╨╠╠
╠╠лммммммммммьммммммммммймммммммомммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Descricao Ё Gera o Arquivo Txt com as Solicitacoes de Compras ja        ╨╠╠
╠╠╨          Ё Processadas                                                 ╨╠╠
╠╠лммммммммммьммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё CSU CardSystem S.A                                          ╨╠╠
╠╠хммммммммммоммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/

Static Function CopyProc()

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                  Declara as Variaveis Utilizadas na Rotina                 Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
                                         	
Local cDiretorio := Alltrim(MV_PAR02)
Local cDestino   := "SC1" + DtoS(Date()) + StrTran( Time() , ":" , "" )  + ".txt" //txt

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё              Executa a Importacao do Txt para o Dbf temporario             Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

DbSelectArea("PRO")
Copy to &( Alltrim(MV_PAR02) + cDestino ) SDF

Return

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммямммммммммммммммммкмммммммяммммммммммммммммммммкммммммямммммммммммм╩╠╠
╠╠╨Programa  Ё GeraSolExecAuto ╨ Autor ЁCristiano Figueiroa ╨ Data Ё 30/06/2006 ╨╠╠
╠╠лммммммммммьмммммммммммммммммймммммммоммммммммммммммммммммйммммммомммммммммммм╧╠╠
╠╠╨Descricao Ё Gera Solicitacoes de Compras via ExecAuto                        ╨╠╠
╠╠╨          Ё                                                                  ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё CSU CardSystem S.A                                               ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/

Static Function GeraSolExecAuto( aCabe , aItem )

/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё        Declara as Variaveis Internas das Rotinas Automaticas        Ё
  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

Local   aArea     := GetArea()
Local   lComErro  := .F.
Local   _cNumSC   := aCabe[1,2]
Local   aSaveArea

/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                 Limpa as variaveis da MsExecAuto                    Ё
  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

lMsErroAuto := .F. 
lMsHelpAuto := .F.	

/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё          Chama a Rotina de Gravacao Automatica - ExecAuto           Ё
  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

MSExecAuto({ | x , y , z | MATA110( x , y , z ) } , aCabe , aItem , 3 )


/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                      Atualiza o Flag de Erro                        Ё
  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
If lMsErroAuto
   lComErro    := .T.   
   lMsErroAuto := .F. 
   lMsHelpAuto := .F.	

Else

/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                      Salva Area                                     Ё
  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

	aSaveArea	:= GetArea()	   
	
	DbSelectArea("SC1")
	DbSetOrder(1)
    If DbSeek(xFilial("SC1") + _cNumSC)

/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                      Atualiza o UsuАrio da SC                       Ё
  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
  
		Do While SC1->( !Eof() ) .And. SC1->C1_NUM ==  _cNumSC
	        RecLock("SC1" , .F.)
        		SC1->C1_USER  		:= aCabe[4,2]
        		SC1->C1_SOLICIT    	:= UsrRetName(aCabe[4,2])
    	    MsunLock()
			DbSkip()
    		Loop
		Enddo
     
     EndIf
/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                      Restaura Area                                  Ё
  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
	RestArea(aSaveArea)

Endif   


   
/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё               Carrega o Grupo de Perguntas na Tela                         Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

Pergunte( cPerg , .F. )

/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё Restaura a Area Antes da Execucao da Rotina                         Ё
  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

RestArea( aArea )

/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё    Retorna a Ocorrencia ou Nao de erros no Processo de Gravacao     Ё
  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

Return lComErro
     
/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммямммммммммммммммммкмммммммяммммммммммммммммммммкммммммямммммммммммм╩╠╠
╠╠╨Programa  Ё GeraSolRecLock  ╨ Autor ЁCristiano Figueiroa ╨ Data Ё 04/07/2006 ╨╠╠
╠╠лммммммммммьмммммммммммммммммймммммммоммммммммммммммммммммйммммммомммммммммммм╧╠╠
╠╠╨Descricao Ё Gera Solicitacoes de Compras via RecLock                         ╨╠╠
╠╠╨          Ё                                                                  ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё CSU CardSystem S.A                                               ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/

Static Function GeraSolRecLock( aCabe , aItem )

/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                        Declara as Variaveis                         Ё
  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

Local w     := 0
Local aArea := GetArea()

/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё Inicia a Transacao                                                  Ё
  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

Begin Transaction

/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё Inicia a Gravacao dos Dados                                         Ё
  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

   For w := 1 to Len( aItem )

   /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
     Ё                 Abre a Tabela de Solicitacao de Compras             Ё
     юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

      DbSelectArea("SC1")
      DbSetOrder(1)

   /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
     Ё         Verifica se o tipo de registro e alteracao ou exclusao      Ё
     юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

      If aItem[ w , 21 , 2 ] $ "A/E"

      /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
        Ё         Chama a rotina de delecao passando a filial e o numero      Ё
        Ё         da Solicitacao de Compras.                                  Ё
        юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

         DeletaSol( aItem[ w , 1 , 2] , aItem[ w , 2 , 2] )`

      Endif

   /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
     Ё Verifica se o tipo de registro nao e exclusao e grava a Solicitacao Ё
     Ё de Compra                                                           Ё
     юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

      If ! ( aItem[ w , 21 , 2 ] $ "E" )

      /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
        Ё               Executa a Gravacao ds Solitacao de Compras            Ё
        юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
      
         RecLock("SC1" , .T. )

         SC1->C1_FILIAL  := aItem[ w , 1 , 2]
         SC1->C1_NUM     := aItem[ w , 2 , 2]
         SC1->C1_ITEM    := aItem[ w , 3 , 2]
         SC1->C1_PRODUTO := aItem[ w , 4 , 2]
         SC1->C1_DESCRI  := Posicione("SB1" , 1 , xFilial("SB1") + aItem[ w , 4 , 2] , "B1_DESC" )
         SC1->C1_UM      := aItem[ w , 5 , 2]
         SC1->C1_QUANT   := aItem[ w , 6 , 2]
         SC1->C1_SEGUM   := aItem[ w , 7 , 2]
         SC1->C1_QTSEGUM := aItem[ w , 8 , 2]
         SC1->C1_DATPRF  := aItem[ w , 9 , 2]
         SC1->C1_LOCAL   := aItem[ w , 10, 2]
         SC1->C1_OBS     := aItem[ w , 11, 2]
         SC1->C1_CC      := aItem[ w , 12, 2]
         SC1->C1_CONTA   := aItem[ w , 13, 2]
         SC1->C1_ITEMCTA := aItem[ w , 14, 2]
         SC1->C1_EMISSAO := aItem[ w , 15, 2]
         SC1->C1_SOLICIT := aItem[ w , 16, 2]
         SC1->C1_FORNECE := aItem[ w , 17, 2]
         SC1->C1_LOJA    := aItem[ w , 18, 2]
         SC1->C1_USER    := aItem[ w , 19, 2]
         SC1->C1_CLVL    := aItem[ w , 20, 2]
         SC1->C1_TPREGIS := aItem[ w , 21, 2]
         SC1->C1_FILENT  := aItem[ w , 22, 2]

         MsunLock()

      /*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
        Ё            Atualiza o Arquivo de Solicitacoes de Compras Processadas       Ё
        юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

         GeraProc( SC1->C1_FILIAL , SC1->C1_NUM , SC1->C1_ITEM , SC1->C1_PRODUTO , "A" )
         
      Endif   
      
   Next w

End Transaction      

/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё Restaura a Area Antes da Execucao da Rotina                         Ё
  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

RestArea( aArea )

Return 

/*
ээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммммкмммммммяммммммммммммммммммммкммммммямммммммммммм╩╠╠
╠╠╨Programa  Ё  GeraProc  ╨ Autor ЁCristiano Figueiroa ╨ Data Ё 04/07/2006 ╨╠╠
╠╠лммммммммммьммммммммммммймммммммоммммммммммммммммммммйммммммомммммммммммм╧╠╠
╠╠╨Descricao Ё Gera as Solicitacoes de Compras Processadas com Sucesso.    ╨╠╠
╠╠лммммммммммьммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨ParametrosЁ Filial , Numero , Item , Produto , Aceite ( A / N )         ╨╠╠
╠╠лммммммммммьммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё CSU CardSystem S.A                                          ╨╠╠
╠╠хммммммммммоммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/

Static Function GeraProc( cFilPro , cNumPro , cItePro , cProdPro , cAceite )

/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                        Declara as Variaveis                         Ё
  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

Local aArea := GetArea()

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                      Abre o Arquivo de Itens Processados                   Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

DbSelectArea("PRO")
Reclock("PRO" , .T. )

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                      Grava os Itens Processados                            Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

PRO->FILIAL := cFilPro
PRO->NUM    := cNumPro
PRO->ITEM   := cItePro
PRO->PRODUTO:= cProdPro
PRO->ACEITE := cAceite 
MsunLock()

/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                     Restaura as Areas Utilizadas                    Ё
  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

RestArea( aArea )

Return
/*
ээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммммкмммммммяммммммммммммммммммммкммммммямммммммммммм╩╠╠
╠╠╨Programa  Ё DeletaSol  ╨ Autor ЁCristiano Figueiroa ╨ Data Ё 04/07/2006 ╨╠╠
╠╠лммммммммммьммммммммммммймммммммоммммммммммммммммммммйммммммомммммммммммм╧╠╠
╠╠╨Descricao Ё Deleta as Solicitacoes de Compras                           ╨╠╠
╠╠╨          Ё                                                             ╨╠╠
╠╠лммммммммммьммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё CSU CardSystem S.A                                          ╨╠╠
╠╠хммммммммммоммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/

Static Function DeletaSol( cFilSol , cNumSol )

/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё            Abre o Arquivo de Solicitacoes de Compras                Ё
  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

DbSelectArea("SC1")
DbSetOrder(1)

/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                Posiciona na Solicitacao de Compras                  Ё
  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

If DbSeek ( cFilSol + cNumSol )

/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё           Processa e Deleta todos os Itens da Solicitacao           Ё
  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

   Do While SC1->( !Eof() ) .And. SC1->C1_FILIAL == cFilSol .And. ;
                                   SC1->C1_NUM    == cNumSol

   /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
     Ё                          Deleta o Registro                          Ё
     юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

      RecLock("SC1" , .F. )
      DbDelete()
      MsUnlock()   
   
   /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
     Ё                  Proximo Registro a ser Excluido                    Ё
     юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
 
      DbSkip()
      Loop
                                           
   Enddo                                   

Endif

Return

/*/
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  ЁRelIncons ╨ Autor Ё Cristiano Figueiroa╨ Data Ё 30/06/2006  ╨╠╠
╠╠лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Descricao ЁImprime o Relatorio de Inconsistencias do Processo de       ╨╠╠
╠╠╨          ЁImportacao das Solicitacoes de Compras.                     ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       ЁProtheus 8.11                                               ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/ 

Static Function RelInco()

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё Define as variaveis necessarias                                      Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

cString  := "SOL"
cDesc1   := "Esta rotina tem como Objetivo Imprimir os Registros Inconsistentes "
cDesc2   := "do Processo de ImportaГao de Solicitacoes de Compras existentes nos Arquivos "
cDesc3   := "Gerados pelo Sistema da Empresa Hold - EspecМfico CSU CardSystem S.A"
tamanho  := "G"
aReturn  := { "Zebrado", 1 , "Contabilidade" , 1 , 1 , 2 , "" , 1 }
Nomeprog := "Incons"
Wnrel    := "Incons"
nLastKey := 0
m_pag    := 1
nLin     := 80
cTitulo  := "Relatorio de Inconsistencias - Processo de ImportaГЦo das SolicitaГУes de Compras do Sistema Hold "
cCabec2  := ""
cCabec1  := "Linha   Inconsistencia "

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                   Adiciona a Regua de Processamento                        Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

 IncProc("Gerando RelatСrio de Inconsistencias")
 
/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё               Envia Controle para a Funcao SetPrint                   Ё
  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

wnrel := SetPrint( cString , Wnrel , , cTitulo , cDesc1 , cDesc2 , cDesc3 , .F. , "" , .F. , Tamanho )

/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё               Verifica o Cancelamento do Relatorio                    Ё
  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

If nLastKey == 27
   Return
Endif

/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                           Chama a SetDefault                          Ё
  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

SetDefault(aReturn,cString)

/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё               Verifica o Cancelamento do Relatorio                    Ё
  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

If nLastKey == 27
   Return
Endif

/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё            Chama a Rotina de Processamento do Relatorio               Ё
  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

RptStatus( { || PrintInco() }, "Processando o Relatorio de Inconsistencias" )

Return

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFun┤Ao    ЁPrintInco Ё Autor Ё Cristiano Figueiroa   Ё Data Ё30/06/2006Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤┘o ЁProcessa os Itens do Relatorio de Inconsistencias           Ё╠╠
╠╠Ё			 Ё 														      Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁUso       Ё CSU CardSystem S.A                                         Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/

Static Function PrintInco()

/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                  Abre o Arquivo de Inconsistencias                    Ё
  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

DbSelectArea("INC")
DbGotop()
SetRegua(Reccount())

/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё               Processa as Inconsistencias no Relatorio                Ё
  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

Do While INC->( !Eof() )
	
  /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Imprime o cabecalho                                               Ё
	юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
	
	If nLin >= 60
	   nLin := Cabec( cTitulo, cCabec1, cCabec2, Nomeprog , Tamanho , 15 ) + 1
	   nLin ++
	Endif
	
  /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё Imprime a Linha de Detalhe                                        Ё
	юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
	
	@ nLin , 000  PSay INC->LINHA
	@ nLin , 008  PSay INC->DESCRICAO
	nLin ++

  /*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	Ё             Processa o Proximo Registro Inconsistente             Ё
	юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

	DbSelectarea("INC")
	IncRegua()
	DbSkip()
	
Enddo

/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё Imprime o Rodape do Relatorio                                     Ё
  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

Roda( 0 , "" , Tamanho )

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё Caso a Impressao seja realizada em Disco , Exibe na Tela o Relatorio Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

If aReturn[5] == 1
   Set Printer To
   Commit
   OurSpool(Wnrel)
Endif

MS_FLUSH()

Return

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFun┤Ao    Ё CopyLog  Ё Autor Ё Cristiano Figueiroa   Ё Data Ё30/06/2006Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤┘o ЁCopia o Arquivo Temporario de Inconsistencias para o        Ё╠╠
╠╠Ё			 ЁDiretorio de Log                    		                  Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁUso       Ё CSU CardSystem S.A                                         Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/

Static Function CopyLog()

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                  Declara as Variaveis Utilizadas na Rotina                 Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

Local cDiretorio := Alltrim(MV_PAR02)
Local cDestino   := DtoS(Date()) + StrTran( Time() , ":" , "" )  + ".XLS"

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                  Gera o Cabecalho do Arquivo de Log                        Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
GeraLog( 0 , Replicate("=" , 220 )   , "0" )
GeraLog( 0 , "Arquivo : " + MV_PAR01 , "0" )
GeraLog( 0 , "Data    : " + Dtoc(Date()) , "0" )
GeraLog( 0 , "Hora    : " + Time() , "0" )
GeraLog( 0 , "Usuario : " + Substr(cUsuario , 7 , 15 ) , "0" )
GeraLog( 0 , "Empresa : " + SM0->M0_NOME + " - " + SM0->M0_FILIAL , "0" )
GeraLog( 0 , "" , "0" )
GeraLog( 0 , Replicate("=" , 220 ) , "0" )

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё   Copia o Arquivo Temporario de Inconsistencias para o Diretorio de Log    Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

DbSelectArea("INC")
Copy to &(Alltrim(cDiretorio) + Alltrim(cDestino)) SDF

Return

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммямммммммммкмммммммямммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  Ё GeraLog ╨ Autor Ё Cristiano Figueiroa ╨ Data Ё 30/06/2006  ╨╠╠
╠╠лммммммммммьмммммммммймммммммомммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Descricao ЁGrava o Arquivo de Log a Inconsistencia encontrada no       ╨╠╠
╠╠╨          ЁProcessamento.                                              ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       ЁCSU CardSystem S.A                                          ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/

Static Function GeraLog( nLinha , cDescricao , cSequencia )

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё            Declara as Variaveis  Utilizadas na Rotina            Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

Local aArea := GetArea()

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё               Abre a Tabela de Inconsistencias                   Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

DbSelectArea("INC")

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё               Grava o Registro de Inconsistencias                Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

Reclock( "INC" , .T. )
INC->LINHA     := Iif ( nLinha == 0 , "" , StrZero( nLinha , 5 ) )
INC->DESCRICAO := cDescricao
INC->SEQ       := Iif ( cSequencia == Nil , "2" , cSequencia )
Msunlock()

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                 Restaura as Areas Utilizadas                     Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

RestArea(aArea)

Return

/*
ээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммямммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  ЁSelArquivo╨ Autor Ё Cristiano Figueiroa ╨ Data Ё 27/03/2006  ╨╠╠
╠╠лммммммммммьммммммммммймммммммомммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Descricao ЁAbre a Janela para a Selecao do Arquivo e seu Caminho de     ╨╠╠
╠╠╨          ЁGravacao.                                                    ╨╠╠
╠╠лммммммммммьммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       ЁCSU                                                          ╨╠╠
╠╠хммммммммммоммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/

User Function SelArquivo()

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                 Declara as Variaveis Utilizadas na Rotina                  Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

Local MvRet     := Alltrim( ReadVar() )
Local cExtensao := "TXT"

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                 Executa a Funcao caso o parametro esteja em Branco         Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

If Empty( MV_PAR01 )
   
   oWnd := GetWndDefault()

   While .T.
      cFile := cGetFile( "*."+cExtensao+"|"+"*."+cExtensao, OemToAnsi("Selecione o Diretorio")) //##"Selecione Diretorio"

      If Empty(cFile)
		 Return .F.
  	  Endif

      If "."$cFile
	     cFile := Substr(cFile,1,rat(".", cfile)-1)
      Endif

	  cFile += "." + cExtensao
	  &mvRet := cFile
	  Exit
   EndDo

   If oWnd != Nil
      GetdRefresh()
   Endif

Endif   

Return .t.
/*
ээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммямммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  ЁValidPerg ╨ Autor Ё Analistas Microsiga ╨ Data Ё 13/02/2006  ╨╠╠
╠╠лммммммммммьммммммммммймммммммомммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Descricao Ё Cria o Grupo de Perguntas conforme Array                    ╨╠╠
╠╠╨          Ё                                                             ╨╠╠
╠╠лммммммммммьммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё CSU                                                         ╨╠╠
╠╠хммммммммммоммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/

Static Function ValidPerg( cPerg )

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё            Declara as Variaveis Locais Utilizadas na Rotina                Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

Local aRegs := {}

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё            Adiciona as Perguntas no Array a ser Gravado no SX1             Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

aAdd( aRegs , { cPerg , "01" , "Arquivo de Importacao ?"      , "         	   " , "            " , "MV_CH1" , "C" , 50 , 0 , 0 , "G" , "u_SelArquivo()" , "MV_PAR01" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""})
aAdd( aRegs , { cPerg , "02" , "Caminho dos Arquivos de Log ?" , "            " , "            " , "MV_CH2" , "C" , 50 , 0 , 0 , "G" , "" , "MV_PAR02" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" , ""})

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё            Verifica se Ja Existe Registro no SX1 e Grava                   Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

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

/*
ээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммямммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  ЁIncluiProd╨ Autor Ё Analistas Microsiga ╨ Data Ё 06/07/2006  ╨╠╠
╠╠лммммммммммьммммммммммймммммммомммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Descricao Ё ExecAuto para a Gravacao de Novos Produtos                  ╨╠╠
╠╠╨          Ё                                                             ╨╠╠
╠╠лммммммммммьммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨ParametrosЁ Codigo , Descricao , Tipo , Unidade e Local Padrao          ╨╠╠
╠╠╨          Ё                                                             ╨╠╠
╠╠лммммммммммьммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё CSU CardSystem S.A                                          ╨╠╠
╠╠хммммммммммоммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/

User Function IncluiProd( cCodigo , cDescricao , cTipo , cUM , cLocPad )

/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                    Declara as Variaveis da Rotina                   Ё
  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

Local aArea    := GetArea()
Local aProduto := {}
Local lComErro := .F.   

/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё        Declara as Variaveis Internas das Rotinas Automaticas        Ё
  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

lMsErroAuto    := .F. 
lMsHelpAuto    := .F.	

/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё              Carrega o Array com os Dados do Produto                Ё
  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

aProduto:= {  { "B1_COD"    , cCodigo    , Nil },;
	          { "B1_DESC"   , cDescricao , Nil },;
	          { "B1_TIPO"   , cTipo      , Nil },;
	          { "B1_UM"     , cUM        , Nil },;
	          { "B1_LOCPAD" , cLocPad    , Nil },;
	          { "B1_MSBLQL" , "2"        , Nil }}

/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё           Adiciona no Array os Produtos a serem Bloqueados          Ё
  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

If Ascan ( aBlqProd , cCodigo ) == 0
   Aadd  ( aBlqProd , cCodigo )
Endif   

/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё              Chama a ExecAuto que Inclui os Produtos                Ё
  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

MSExecAuto( { |x , y | Mata010( x , y ) } , aProduto , 3 ) 

/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                      Atualiza o Flag de Erro                        Ё
  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

If lMsErroAuto
   lComErro    := .T.   
   lMsErroAuto := .F. 
   lMsHelpAuto := .F.	
   mostraerro() //desabilitar essa funГЦo em produГЦo
Endif   

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё               Carrega o Grupo de Perguntas na Tela                         Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

Pergunte( cPerg , .F. )

/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё    Retorna a Ocorrencia ou Nao de erros no Processo de Gravacao     Ё
  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

Return lComErro

/*
ээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммяммммммммммммммммммммкммммммямммммммммммм╩╠╠
╠╠╨Programa  Ё CriaSX6  ╨ Autor ЁCristiano Figueiroa ╨ Data Ё 06/07/2006 ╨╠╠
╠╠лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммомммммммммммм╧╠╠
╠╠╨Descricao Ё Inclui um Novo Parametro no SX6                           ╨╠╠
╠╠лммммммммммьммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё CSU CardSystem S.A                                        ╨╠╠
╠╠хммммммммммоммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/

Static Function CriaSX6()

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                Abre a tabela de parametros do sistema                      Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

DbSelectArea("SX6")
DbSetOrder(1)


/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё        Verifica se o parametro existe , caso contrario grava o mesmo       Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

If !DbSeek( "  " + "MV_LPPROD" )
   CriarSX6( "MV_LPPROD" , "C" , "Determina o Local Padrao a ser Gravado nas Interfaces de Importacao do Cadastro de Produtos " , "01" , "" )
Endif

Return

/*
ээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммямммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  Ё BloqProd ╨ Autor Ё Analistas Microsiga ╨ Data Ё 29/08/2006  ╨╠╠
╠╠лммммммммммьммммммммммймммммммомммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Descricao Ё Rotina para Blquear os Produtos Incluidos pela Rotina       ╨╠╠
╠╠╨          Ё                                                             ╨╠╠
╠╠лммммммммммьммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨ParametrosЁ Array com os Produtos a serem Bloqueados                    ╨╠╠
╠╠╨          Ё                                                             ╨╠╠
╠╠лммммммммммьммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё CSU CardSystem S.A                                          ╨╠╠
╠╠хммммммммммоммммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/

User Function BloqProd( aMsBlqlProd )

/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                    Declara as Variaveis da Rotina                   Ё
  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

Local aArea    := GetArea()
Local e        := 1

/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                        Abre o Cadastro de Produtos                            Ё
  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

DbSelectArea("SB1")
DbSetOrder(1)

/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                    Bloqueia todos os Produtos do Array                        Ё
  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

For e := 1 to Len ( aMsBlqlProd )

/*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё                        Posiciona no Cadastro de Produtos                      Ё
  юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/
   
   If DbSeek( xFilial("SB1") + aMsBlqlProd[e]  )

   /*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
     Ё                              Realiza o Bloqueio                            Ё
     юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

      Reclock("SB1" , .F. )     
      SB1->B1_MSBLQL := "1"
      MsUnlock()   
      
   /*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
     Ё    Chama a Funcao que ira Disparar o WorkFlow de Desbloqueio do Produto    Ё
     юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

      u_Rwfwa01()

   Endif

   
Next e   

/*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
  Ё         Restaura as Areas Utilizadas antes da Execucao da Rotina               Ё
  юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды*/

RestArea(aArea)

Return