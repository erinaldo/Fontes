#Include 'Protheus.ch'
#Include 'Report.ch'

#DEFINE NOME_REL   'xTReport'
#DEFINE TITULO_REL 'Relat�rio de exemplo - TReport'
#DEFINE DESCRI_REL 'Este relat�rio � a utiliza��o do TReport, a ideia � exemplificar da maneitra simples.'
#DEFINE ABA_PLAN   'Exemplo - TReport'

//-----------------------------------------------------------------------
// Rotina | xTReport     | Autor | Robson Luiz - Rleg | Data | 04.04.2013
//-----------------------------------------------------------------------
// Descr. | Esta rotina exemplifica a utiliza��o do TReport.
//-----------------------------------------------------------------------
// Uso    | Oficina de Programa��o
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
    
        //A fun��o FormBatch mostrar uma mensagem na tela e as op��es dispon�veis para o usu�rio
        //(para saber mais sobre esta fun��o acesse o link http://tdn.totvs.com/pages/viewpage.action?pageId=24346908)
  FormBatch( cCadastro, aSay, aButton )
  
  If nOpcao==1
    xParam()
  Endif
Return
//-----------------------------------------------------------------------
// Rotina | xParam       | Autor | Robson Luiz - Rleg | Data | 04.04.2013
//-----------------------------------------------------------------------
// Descr. | Esta rotina solicita o preenchimento do par�metros.
//-----------------------------------------------------------------------
// Uso    | Oficina de Programa��o
//-----------------------------------------------------------------------
Static Function xParam()
  Local aPar := {}
  Local aRet := {}
  Local aModelos := {}
  
  Private cOpcRel := ''
  
  AAdd( aModelos, 'Dados em array.' )
  AAdd( aModelos, 'Dados em tabela padr�o.' )
  AAdd( aModelos, 'Dados em resultado de query.' )
  
  AAdd(aPar,{3,'Qual modelo quer executar',1,aModelos,99,"",.T.})
  AAdd(aPar,{1,"Tabela de" ,Space(Len(SX5->X5_TABELA)),"","","00","",0,.F.})
  AAdd(aPar,{1,"Tabela at�",Space(Len(SX5->X5_TABELA)),"","","00","",0,.T.})
  
  If !ParamBox(aPar,cCadastro,@aRet,,,,,,,,.F.,.F.)
    Return
   Endif
   
   cOpcRel := aModelos[ aRet[1] ] 
   
   If     aRet[1]==1 ; xArray( aRet[2], aRet[3] )
   Elseif aRet[1]==2 ; xPadrao( aRet[2], aRet[3] )
   Elseif aRet[1]==3 ; xQuery( aRet[2], aRet[3] )
   Else              ; MsgInfo('Op��o indispon�vel',cCadastro)
   Endif
Return
//-----------------------------------------------------------------------
// Rotina | xArray       | Autor | Robson Luiz - Rleg | Data | 04.04.2013
//-----------------------------------------------------------------------
// Descr. | Tratamento de impress�o dos dados por meio de um Array.
//-----------------------------------------------------------------------
// Uso    | Oficina de Programa��o
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
    MsgInfo('N�o foi poss�vel localizar os dados, verifique os par�metros.',cCadastro)
  Endif
Return
//-----------------------------------------------------------------------
// Rotina | xDefArray    | Autor | Robson Luiz - Rleg | Data | 04.04.2013
//-----------------------------------------------------------------------
// Descr. | Defini��o de impress�o dos dados do array.
//-----------------------------------------------------------------------
// Uso    | Oficina de Programa��o
//-----------------------------------------------------------------------
Static Function xDefArray( aCOLS, aHeader )
  Local oReport
  Local oSection 
  Local nLen := Len(aHeader)
  Local nX := 0
  /*
  +-------------------------------------+
  | M�todo construtor da classe TReport |
  +-------------------------------------+
  New(cReport,cTitle,uParam,bAction,cDescription,lLandscape,uTotalText,lTotalInLine,cPageTText,lPageTInLine,lTPageBreak,nColSpace)
  
  cReport      - Nome do relat�rio. Exemplo: MATR010
  cTitle      - T�tulo do relat�rio
  uParam      - Par�metros do relat�rio cadastrado no Dicion�rio de Perguntas (SX1). Tamb�m pode ser utilizado bloco de c�digo para par�metros customizados.
  bAction      - Bloco de c�digo que ser� executado quando o usu�rio confirmar a impress�o do relat�rio
  cDescription  - Descri��o do relat�rio
  lLandscape    - Aponta a orienta��o de p�gina do relat�rio como paisagem
  uTotalText    - Texto do totalizador do relat�rio, podendo ser caracter ou bloco de c�digo
  lTotalInLine  - Imprime as c�lulas em linha
  cPageTText    - Texto do totalizador da p�gina
  lPageTInLine  - Imprime totalizador da p�gina em linha
  lTPageBreak    - Quebra p�gina ap�s a impress�o do totalizador
  nColSpace    - Espa�amento entre as colunas
  
  Retorno  Objeto
  */
  oReport := TReport():New( NOME_REL, TITULO_REL, , {|oReport| xImprArray( oReport, aCOLS )}, DESCRI_REL + cOpcRel )
  
  DEFINE SECTION oSection OF oReport TITLE ABA_PLAN TOTAL IN COLUMN
  
  For nX := 1 To nLen
    DEFINE CELL NAME "CEL"+Alltrim(Str(nX-1)) OF oSection SIZE 20 TITLE aHeader[nX]
  Next nX
  
  /*
  +---------------------------------------+  
  | Define o espa�amento entre as colunas |
  +---------------------------------------+
  SetColSpace(nColSpace,lPixel)
  nColSpace  - Tamanho do espa�amento
  lPixel    - Aponta se o tamanho ser� calculado em pixel
  */
  oSection:SetColSpace(0)
  
  // Quantidade de linhas a serem saltadas antes da impress�o da se��o
  oSection:nLinesBefore := 2
  
  
  /*
  +--------------------------------------------------------------------------------------------------------------+
  | Define que a impress�o poder� ocorrer emu ma ou mais linhas no caso das colunas exederem o tamanho da p�gina |
  +--------------------------------------------------------------------------------------------------------------+
  SetLineBreak(lLineBreak)
  
  lLineBreak - Se verdadeiro, imprime em uma ou mais linhas
  */
  oSection:SetLineBreak(.T.)
Return( oReport )
//-----------------------------------------------------------------------
// Rotina | xImprArray   | Autor | Robson Luiz - Rleg | Data | 04.04.2013
//-----------------------------------------------------------------------
// Descr. | Impress�o dos dos dados do array.
//-----------------------------------------------------------------------
// Uso    | Oficina de Programa��o
//-----------------------------------------------------------------------
Static Function xImprArray( oReport, aCOLS )
  Local oSection := oReport:Section(1) // Retorna objeto da classe TRSection (se��o). Tipo Caracter: T�tulo da se��o. Tipo Num�rico: �ndice da se��o segundo a ordem de cria��o dos componentes TRSection.
  Local nX := 0
  Local nY := 0
  
  /*
  +-----------------------------------------------------+
  | Define o limite da r�gua de progress�o do relat�rio |
  +-----------------------------------------------------+
  SetMeter(nTotal)
  
  nTotal - Limite da r�gua
  */
  oReport:SetMeter( Len( aCOLS ) )  
  
  /*
  +---------------------------------------------------------------------+
  | Inicializa as configura��es e define a primeira p�gina do relat�rio |
  +---------------------------------------------------------------------+
  Init()
  
  N�o � necess�rio executar o m�todo Init se for utilizar o m�todo Print, j� que estes fazem o controle de inicializa��o e finaliza��o da impress�o.
  */
  oSection:Init()
  
  For nX := 1 To Len( aCOLS )
    // Retorna se o usu�rio cancelou a impress�o do relat�rio
    If oReport:Cancel()
      Exit
    EndIf
    
    For nY := 1 To Len(aCOLS[ nX ])
       If ValType( aCOLS[ nX, nY ] ) == 'D'
         // Cell() - Retorna o objeto da classe TRCell (c�lula) baseado. Tipo Caracter: Nome ou t�tulo do objeto. Tipo Num�rico: �ndice do objeto segundo a ordem de cria��o dos componentes TRCell.
         // SetBlock() - Define o bloco de c�digo que retornar� o conte�do de impress�o da c�lula. Definindo o bloco de c�digo para a c�lula, esta n�o utilizara mais o nome mais o alias para retornar o conte�do de impress�o.
         oSection:Cell("CEL"+Alltrim(Str(nY-1))):SetBlock( &("{ || '" + Dtoc(aCOLS[ nX, nY ]) + "'}") )
       Elseif ValType( aCOLS[ nX, nY ] ) == 'N'
         oSection:Cell("CEL"+Alltrim(Str(nY-1))):SetBlock( &("{ || '" + TransForm(aCOLS[ nX, nY ],'@E 999,999,999.99') + "'}") )
       Else
         oSection:Cell("CEL"+Alltrim(Str(nY-1))):SetBlock( &("{ || '" + aCOLS[ nX, nY ] + "'}") )
       Endif
    Next
    
    // Incrementa a r�gua de progress�o do relat�rio
    oReport:IncMeter()
    
    /*
    +------------------------------------------------+
    | Imprime a linha baseado nas c�lulas existentes |
    +------------------------------------------------+
    PrintLine(lEvalPosition,lParamPage,lExcel)
    
    lEvalPosition  - For�a a atualiza��o do conte�do das c�lulas 
    lParamPage    - Aponta que � a impress�o da p�gina de par�metros
    lExcel      - Aponta que � gera��o em planilha
    */
    oSection:PrintLine()
  Next
  
  /*
  Finaliza a impress�o do relat�rio, imprime os totalizadores, fecha as querys e �ndices tempor�rios, entre outros tratamentos do componente.
  N�o � necess�rio executar o m�todo Finish se for utilizar o m�todo Print, j� que este faz o controle de inicializa��o e finaliza��o da impress�o.
  */
  oSection:Finish()
Return
//-----------------------------------------------------------------------
// Rotina | xPadrao      | Autor | Robson Luiz - Rleg | Data | 04.04.2013
//-----------------------------------------------------------------------
// Descr. | Tratamento de impress�o dos dados por meio de tabela padr�o.
//-----------------------------------------------------------------------
// Uso    | Oficina de Programa��o
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
// Descr. | Defini��o de impress�o dos dados da tabela padr�o.
//-----------------------------------------------------------------------
// Uso    | Oficina de Programa��o
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
// Descr. | Impress�o dos dos dados da tabela padr�o.
//-----------------------------------------------------------------------
// Uso    | Oficina de Programa��o
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
    oSection:Cell("CEL0"):SetBlock( &("{ || DADOS N�O LOCALIZADOS, VERIFIQUE OS PAR�METROS }") )
    oSection:PrintLine()
  Endif
  
  oSection:Finish()
Return
//-----------------------------------------------------------------------
// Rotina | xQuery       | Autor | Robson Luiz - Rleg | Data | 04.04.2013
//-----------------------------------------------------------------------
// Descr. | Tratamento de impress�o dos dados por meio de query.
//-----------------------------------------------------------------------
// Uso    | Oficina de Programa��o
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
// Descr. | Defini��o de impress�o dos dados da query.
//-----------------------------------------------------------------------
// Uso    | Oficina de Programa��o
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
// Descr. | Impress�o dos dos dados da query.
//-----------------------------------------------------------------------
// Uso    | Oficina de Programa��o
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
    oSection:Cell("CEL0"):SetBlock( &("{ || DADOS N�O LOCALIZADOS, VERIFIQUE OS PAR�METROS }") )
    oSection:PrintLine()
  Endif
  oSection:Finish()
  (cTRB)->( dbCloseArea() )
Return