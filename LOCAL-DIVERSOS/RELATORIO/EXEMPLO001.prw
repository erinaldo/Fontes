#Include 'Protheus.ch'
#Include 'Report.ch'

#DEFINE NOME_REL   'xTReport'
#DEFINE TITULO_REL 'Relatório de exemplo - TReport'
#DEFINE DESCRI_REL 'Este relatório é a utilização do TReport, a ideia é exemplificar da maneitra simples.'
#DEFINE ABA_PLAN   'Exemplo - TReport'

//-----------------------------------------------------------------------
// Rotina | xTReport     | Autor | Robson Luiz - Rleg | Data | 04.04.2013
//-----------------------------------------------------------------------
// Descr. | Esta rotina exemplifica a utilização do TReport.
//-----------------------------------------------------------------------
// Uso    | Oficina de Programação
//-----------------------------------------------------------------------
User Function xTReport()
  Local aSay := {}
  Local aButton := {}
  
  Local nOpcao := 0
  
  Private cCadastro := ABA_PLAN
  
  AAdd(aSay,DESCRI_REL)
  AAdd(aSay,'')
  AAdd(aSay,'Clique em OK para prosseguir....')
  
  AAdd(aButton, { 1,.T.,{|| nOpcao := 1, FechaBatch() }})
  AAdd(aButton, { 2,.T.,{|| FechaBatch()              }})
    
        //A função FormBatch mostrar uma mensagem na tela e as opções disponíveis para o usuário
        //(para saber mais sobre esta função acesse o link http://tdn.totvs.com/pages/viewpage.action?pageId=24346908)
  FormBatch( cCadastro, aSay, aButton )
  
  If nOpcao==1
    xParam()
  Endif
Return
//-----------------------------------------------------------------------
// Rotina | xParam       | Autor | Robson Luiz - Rleg | Data | 04.04.2013
//-----------------------------------------------------------------------
// Descr. | Esta rotina solicita o preenchimento do parâmetros.
//-----------------------------------------------------------------------
// Uso    | Oficina de Programação
//-----------------------------------------------------------------------
Static Function xParam()
  Local aPar := {}
  Local aRet := {}
  Local aModelos := {}
  
  Private cOpcRel := ''
  
  AAdd( aModelos, 'Dados em array.' )
  AAdd( aModelos, 'Dados em tabela padrão.' )
  AAdd( aModelos, 'Dados em resultado de query.' )
  
  AAdd(aPar,{3,'Qual modelo quer executar',1,aModelos,99,"",.T.})
  AAdd(aPar,{1,"Tabela de" ,Space(Len(SX5->X5_TABELA)),"","","00","",0,.F.})
  AAdd(aPar,{1,"Tabela até",Space(Len(SX5->X5_TABELA)),"","","00","",0,.T.})
  
  If !ParamBox(aPar,cCadastro,@aRet,,,,,,,,.F.,.F.)
    Return
   Endif
   
   cOpcRel := aModelos[ aRet[1] ] 
   
   If     aRet[1]==1 ; xArray( aRet[2], aRet[3] )
   Elseif aRet[1]==2 ; xPadrao( aRet[2], aRet[3] )
   Elseif aRet[1]==3 ; xQuery( aRet[2], aRet[3] )
   Else              ; MsgInfo('Opção indisponível',cCadastro)
   Endif
Return
//-----------------------------------------------------------------------
// Rotina | xArray       | Autor | Robson Luiz - Rleg | Data | 04.04.2013
//-----------------------------------------------------------------------
// Descr. | Tratamento de impressão dos dados por meio de um Array.
//-----------------------------------------------------------------------
// Uso    | Oficina de Programação
//-----------------------------------------------------------------------
Static Function xArray( cPar1, cPar2 )
  Local aCpo := {}
  Local aCab := {}
  Local aDados := {}
  
  Local nI := 0
  
  Local oReport
  
  aCpo := {'X5_TABELA','X5_CHAVE','X5_DESCRI'}
  
  SX3->( dbSetOrder( 2 ) )
  For nI := 1 To Len( aCpo )
    SX3->( dbSeek( aCpo[ nI ] ) )
    AAdd( aCab, RTrim( SX3->X3_TITULO ) )
  Next nI
  
  SX5->( dbSetOrder( 1 ) )
  SX5->( dbSeek( xFilial( "SX5" ) + cPar1 ) )
  While ! SX5->(EOF()) .And. SX5->( X5_FILIAL + X5_TABELA ) <= xFilial("SX5") + cPar2
    SX5->( AAdd( aDados, { X5_TABELA, X5_CHAVE, X5_DESCRI } ) )
    SX5->( dbSkip() )
  End
  
  If Len( aDados ) > 0
    oReport := xDefArray( aDados, aCab )
    oReport:PrintDialog()
  Else
    MsgInfo('Não foi possível localizar os dados, verifique os parâmetros.',cCadastro)
  Endif
Return
//-----------------------------------------------------------------------
// Rotina | xDefArray    | Autor | Robson Luiz - Rleg | Data | 04.04.2013
//-----------------------------------------------------------------------
// Descr. | Definição de impressão dos dados do array.
//-----------------------------------------------------------------------
// Uso    | Oficina de Programação
//-----------------------------------------------------------------------
Static Function xDefArray( aCOLS, aHeader )
  Local oReport
  Local oSection 
  Local nLen := Len(aHeader)
  Local nX := 0
  /*
  +-------------------------------------+
  | Método construtor da classe TReport |
  +-------------------------------------+
  New(cReport,cTitle,uParam,bAction,cDescription,lLandscape,uTotalText,lTotalInLine,cPageTText,lPageTInLine,lTPageBreak,nColSpace)
  
  cReport      - Nome do relatório. Exemplo: MATR010
  cTitle      - Título do relatório
  uParam      - Parâmetros do relatório cadastrado no Dicionário de Perguntas (SX1). Também pode ser utilizado bloco de código para parâmetros customizados.
  bAction      - Bloco de código que será executado quando o usuário confirmar a impressão do relatório
  cDescription  - Descrição do relatório
  lLandscape    - Aponta a orientação de página do relatório como paisagem
  uTotalText    - Texto do totalizador do relatório, podendo ser caracter ou bloco de código
  lTotalInLine  - Imprime as células em linha
  cPageTText    - Texto do totalizador da página
  lPageTInLine  - Imprime totalizador da página em linha
  lTPageBreak    - Quebra página após a impressão do totalizador
  nColSpace    - Espaçamento entre as colunas
  
  Retorno  Objeto
  */
  oReport := TReport():New( NOME_REL, TITULO_REL, , {|oReport| xImprArray( oReport, aCOLS )}, DESCRI_REL + cOpcRel )
  
  DEFINE SECTION oSection OF oReport TITLE ABA_PLAN TOTAL IN COLUMN
  
  For nX := 1 To nLen
    DEFINE CELL NAME "CEL"+Alltrim(Str(nX-1)) OF oSection SIZE 20 TITLE aHeader[nX]
  Next nX
  
  /*
  +---------------------------------------+  
  | Define o espaçamento entre as colunas |
  +---------------------------------------+
  SetColSpace(nColSpace,lPixel)
  nColSpace  - Tamanho do espaçamento
  lPixel    - Aponta se o tamanho será calculado em pixel
  */
  oSection:SetColSpace(0)
  
  // Quantidade de linhas a serem saltadas antes da impressão da seção
  oSection:nLinesBefore := 2
  
  
  /*
  +--------------------------------------------------------------------------------------------------------------+
  | Define que a impressão poderá ocorrer emu ma ou mais linhas no caso das colunas exederem o tamanho da página |
  +--------------------------------------------------------------------------------------------------------------+
  SetLineBreak(lLineBreak)
  
  lLineBreak - Se verdadeiro, imprime em uma ou mais linhas
  */
  oSection:SetLineBreak(.T.)
Return( oReport )
//-----------------------------------------------------------------------
// Rotina | xImprArray   | Autor | Robson Luiz - Rleg | Data | 04.04.2013
//-----------------------------------------------------------------------
// Descr. | Impressão dos dos dados do array.
//-----------------------------------------------------------------------
// Uso    | Oficina de Programação
//-----------------------------------------------------------------------
Static Function xImprArray( oReport, aCOLS )
  Local oSection := oReport:Section(1) // Retorna objeto da classe TRSection (seção). Tipo Caracter: Título da seção. Tipo Numérico: Índice da seção segundo a ordem de criação dos componentes TRSection.
  Local nX := 0
  Local nY := 0
  
  /*
  +-----------------------------------------------------+
  | Define o limite da régua de progressão do relatório |
  +-----------------------------------------------------+
  SetMeter(nTotal)
  
  nTotal - Limite da régua
  */
  oReport:SetMeter( Len( aCOLS ) )  
  
  /*
  +---------------------------------------------------------------------+
  | Inicializa as configurações e define a primeira página do relatório |
  +---------------------------------------------------------------------+
  Init()
  
  Não é necessário executar o método Init se for utilizar o método Print, já que estes fazem o controle de inicialização e finalização da impressão.
  */
  oSection:Init()
  
  For nX := 1 To Len( aCOLS )
    // Retorna se o usuário cancelou a impressão do relatório
    If oReport:Cancel()
      Exit
    EndIf
    
    For nY := 1 To Len(aCOLS[ nX ])
       If ValType( aCOLS[ nX, nY ] ) == 'D'
         // Cell() - Retorna o objeto da classe TRCell (célula) baseado. Tipo Caracter: Nome ou título do objeto. Tipo Numérico: Índice do objeto segundo a ordem de criação dos componentes TRCell.
         // SetBlock() - Define o bloco de código que retornará o conteúdo de impressão da célula. Definindo o bloco de código para a célula, esta não utilizara mais o nome mais o alias para retornar o conteúdo de impressão.
         oSection:Cell("CEL"+Alltrim(Str(nY-1))):SetBlock( &("{ || '" + Dtoc(aCOLS[ nX, nY ]) + "'}") )
       Elseif ValType( aCOLS[ nX, nY ] ) == 'N'
         oSection:Cell("CEL"+Alltrim(Str(nY-1))):SetBlock( &("{ || '" + TransForm(aCOLS[ nX, nY ],'@E 999,999,999.99') + "'}") )
       Else
         oSection:Cell("CEL"+Alltrim(Str(nY-1))):SetBlock( &("{ || '" + aCOLS[ nX, nY ] + "'}") )
       Endif
    Next
    
    // Incrementa a régua de progressão do relatório
    oReport:IncMeter()
    
    /*
    +------------------------------------------------+
    | Imprime a linha baseado nas células existentes |
    +------------------------------------------------+
    PrintLine(lEvalPosition,lParamPage,lExcel)
    
    lEvalPosition  - Força a atualização do conteúdo das células 
    lParamPage    - Aponta que é a impressão da página de parâmetros
    lExcel      - Aponta que é geração em planilha
    */
    oSection:PrintLine()
  Next
  
  /*
  Finaliza a impressão do relatório, imprime os totalizadores, fecha as querys e índices temporários, entre outros tratamentos do componente.
  Não é necessário executar o método Finish se for utilizar o método Print, já que este faz o controle de inicialização e finalização da impressão.
  */
  oSection:Finish()
Return
//-----------------------------------------------------------------------
// Rotina | xPadrao      | Autor | Robson Luiz - Rleg | Data | 04.04.2013
//-----------------------------------------------------------------------
// Descr. | Tratamento de impressão dos dados por meio de tabela padrão.
//-----------------------------------------------------------------------
// Uso    | Oficina de Programação
//-----------------------------------------------------------------------
Static Function xPadrao( cPar1, cPar2 )
  Local aCpo := {}
  Local aCab := {}
  
  Local nI := 0
  
  Local oReport
  
  aCpo := {'X5_TABELA','X5_CHAVE','X5_DESCRI'}
  
  SX3->( dbSetOrder( 2 ) )
  For nI := 1 To Len( aCpo )
    SX3->( dbSeek( aCpo[ nI ] ) )
    AAdd( aCab, RTrim( SX3->X3_TITULO ) )
  Next nI
  
  oReport := xDefPadrao( aCpo, aCab, cPar1, cPar2 )
  oReport:PrintDialog()
Return
//-----------------------------------------------------------------------
// Rotina | xDefPadrao   | Autor | Robson Luiz - Rleg | Data | 04.04.2013
//-----------------------------------------------------------------------
// Descr. | Definição de impressão dos dados da tabela padrão.
//-----------------------------------------------------------------------
// Uso    | Oficina de Programação
//-----------------------------------------------------------------------
Static Function xDefPadrao( aCpo, aHeader, cPar1, cPar2 )
  Local oReport
  Local oSection 
  Local nLen := Len(aHeader)
  Local nX := 0
  
  oReport := TReport():New( NOME_REL, TITULO_REL, , {|oReport| xImprPadrao( oReport, aCpo, cPar1, cPar2 )}, DESCRI_REL + cOpcRel )
  
  DEFINE SECTION oSection OF oReport TITLE ABA_PLAN TOTAL IN COLUMN
  
  For nX := 1 To nLen
    DEFINE CELL NAME "CEL"+Alltrim(Str(nX-1)) OF oSection SIZE 20 TITLE aHeader[nX]
  Next nX
  
  oSection:SetColSpace(0)
  oSection:nLinesBefore := 2
  oSection:SetLineBreak()
Return( oReport )
//-----------------------------------------------------------------------
// Rotina | xImprPadrao  | Autor | Robson Luiz - Rleg | Data | 04.04.2013
//-----------------------------------------------------------------------
// Descr. | Impressão dos dos dados da tabela padrão.
//-----------------------------------------------------------------------
// Uso    | Oficina de Programação
//-----------------------------------------------------------------------
Static Function xImprPadrao( oReport, aCpo, cPar1, cPar2 )
  Local oSection := oReport:Section(1)
  Local nI := 0
  
  oReport:SetMeter( 0 )  
  oSection:Init()
  
  SX5->( dbSetOrder( 1 ) )
  If SX5->( dbSeek( xFilial( "SX5" ) + cPar1 ) )
    While ! SX5->(EOF()) .And. SX5->( X5_FILIAL + X5_TABELA ) <= xFilial("SX5") + cPar2
      If oReport:Cancel()
        Exit
      EndIf
      
      For nI := 1 To Len( aCpo )
        If ValType( SX5->&( aCpo[ nI ] ) ) == 'D"
          oSection:Cell("CEL"+Alltrim(Str(nI-1))):SetBlock( &("{ || '" + Dtoc( SX5->&( aCpo[ nI ] ) ) + "'}") )
        Elseif ValType( SX5->&( aCpo[ nI ] ) ) == 'N"
          oSection:Cell("CEL"+Alltrim(Str(nI-1))):SetBlock( &("{ || '" + TransForm( SX5->&( aCpo[ nI ] ), '@E 999,999,999.99' ) + "'}") )      
        Else
          oSection:Cell("CEL"+Alltrim(Str(nI-1))):SetBlock( &("{ || '" + SX5->&( aCpo[ nI ] ) + "'}") )
        Endif
      Next nI
  
      oReport:IncMeter()
      oSection:PrintLine()
  
      SX5->( dbSkip() )
    End  
  Else
    oSection:Cell("CEL0"):SetBlock( &("{ || DADOS NÃO LOCALIZADOS, VERIFIQUE OS PARÂMETROS }") )
    oSection:PrintLine()
  Endif
  
  oSection:Finish()
Return
//-----------------------------------------------------------------------
// Rotina | xQuery       | Autor | Robson Luiz - Rleg | Data | 04.04.2013
//-----------------------------------------------------------------------
// Descr. | Tratamento de impressão dos dados por meio de query.
//-----------------------------------------------------------------------
// Uso    | Oficina de Programação
//-----------------------------------------------------------------------
Static Function xQuery( cPar1, cPar2 )
  Local aCpo := {}
  Local aCab := {}
  
  Local nI := 0
  
  Local oReport
  
  aCpo := {'X5_TABELA','X5_CHAVE','X5_DESCRI'}
  
  SX3->( dbSetOrder( 2 ) )
  For nI := 1 To Len( aCpo )
    SX3->( dbSeek( aCpo[ nI ] ) )
    AAdd( aCab, RTrim( SX3->X3_TITULO ) )
  Next nI
  
  oReport := xDefQuery( aCpo, aCab, cPar1, cPar2 )
  oReport:PrintDialog()
Return
//-----------------------------------------------------------------------
// Rotina | xDefQuery    | Autor | Robson Luiz - Rleg | Data | 04.04.2013
//-----------------------------------------------------------------------
// Descr. | Definição de impressão dos dados da query.
//-----------------------------------------------------------------------
// Uso    | Oficina de Programação
//-----------------------------------------------------------------------
Static Function xDefQuery( aCpo, aHeader, cPar1, cPar2 )
  Local oReport
  Local oSection 
  Local nLen := Len(aHeader)
  Local nX := 0
  
  oReport := TReport():New( NOME_REL, TITULO_REL, , {|oReport| xImprQuery( oReport, aCpo, cPar1, cPar2 )}, DESCRI_REL + cOpcRel )
  
  DEFINE SECTION oSection OF oReport TITLE ABA_PLAN TOTAL IN COLUMN
  
  For nX := 1 To nLen
    DEFINE CELL NAME "CEL"+Alltrim(Str(nX-1)) OF oSection SIZE 20 TITLE aHeader[nX]
  Next nX
  
  oSection:SetColSpace(0)
  oSection:nLinesBefore := 2
  oSection:SetLineBreak()
Return( oReport )
//-----------------------------------------------------------------------
// Rotina | xImprQuery   | Autor | Robson Luiz - Rleg | Data | 04.04.2013
//-----------------------------------------------------------------------
// Descr. | Impressão dos dos dados da query.
//-----------------------------------------------------------------------
// Uso    | Oficina de Programação
//-----------------------------------------------------------------------
Static Function xImprQuery( oReport, aCpo, cPar1, cPar2 )
  Local nI := 0
  
  Local cTRB := ''
  Local cSQL := ''
  
  Local oSection := oReport:Section(1)
  
  oReport:SetMeter( 0 )  
  oSection:Init()
  
  cSQL := "SELECT X5_FILIAL,
  cSQL += "       X5_TABELA, "
  cSQL += "       X5_CHAVE, "
  cSQL += "       X5_DESCRI "
  cSQL += "FROM   "+RetSqlName("SX5")+" SX5 "
  cSQL += "WHERE  X5_FILIAL = "+ValToSql(xFilial("SX5"))+" "
  cSQL += "       AND X5_TABELA BETWEEN "+ValToSql(cPar1)+" AND "+ValToSql(cPar2)+" "
  cSQL += "       AND SX5.D_E_L_E_T_ = ' ' "
  cSQL += "ORDER  BY X5_TABELA, "
  cSQL += "          X5_CHAVE "
  
  cTRB := GetNextAlias()
  
  cSQL := ChangeQuery( cSQL )
  PLSQuery( cSQL, cTRB )
  
  If !(cTRB)->(EOF())
    While ! (cTRB)->(EOF()) .And. (cTRB)->( X5_FILIAL + X5_TABELA ) <= xFilial("SX5") + cPar2
      If oReport:Cancel()
        Exit
      EndIf
      For nI := 1 To Len( aCpo )
        If ValType( (cTRB)->&( aCpo[ nI ] ) ) == 'D"
          oSection:Cell("CEL"+Alltrim(Str(nI-1))):SetBlock( &("{ || '" + Dtoc( (cTRB)->&( aCpo[ nI ] ) ) + "'}") )
        Elseif ValType( SX5->&( aCpo[ nI ] ) ) == 'N"
          oSection:Cell("CEL"+Alltrim(Str(nI-1))):SetBlock( &("{ || '" + TransForm( (cTRB)->&( aCpo[ nI ] ), '@E 999,999,999.99' ) + "'}") )      
        Else
          oSection:Cell("CEL"+Alltrim(Str(nI-1))):SetBlock( &("{ || '" + (cTRB)->&( aCpo[ nI ] ) + "'}") )
        Endif
      Next nI
  
      oReport:IncMeter()
      oSection:PrintLine()
  
      (cTRB)->( dbSkip() )
    End
  Else
    oSection:Cell("CEL0"):SetBlock( &("{ || DADOS NÃO LOCALIZADOS, VERIFIQUE OS PARÂMETROS }") )
    oSection:PrintLine()
  Endif
  oSection:Finish()
  (cTRB)->( dbCloseArea() )
Return