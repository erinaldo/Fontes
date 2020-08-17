#Include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CSGPEA21 บ Autor ณ Adilson Silva      บ Data ณ 06/03/2014  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Cadastro e Calculo do Anuenio - CSU.                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CSGPEA21( nOpcAuto )                                    

Local aIndexSRA  := {}
Local cFiltraSRA

Private bFiltraBrw := {|| Nil}
Private cCadastro := OemToAnsi( "Cแlculo do Anu๊nio" )
Private cPerg     := "CSGPEA21"

Private aRotina := { { "Pesquisar"   , "AxPesqui"  		  	, 0 , 1},;
					 { "Visualizar"  , "U_x11CSGPEA(,,2)"	, 0 , 2},;
					 { "Incluir"     , "U_x11CSGPEA(,,3)"	, 0 , 3},;
					 { "Alterar"     , "U_x11CSGPEA(,,4)"	, 0 , 4},;
					 { "Excluir"     , "U_x11CSGPEA(,,5)"	, 0 , 5},;
					 { "Cแlculo"     , "U_CSGPEM21(,,4)"	, 0 , 4} }

If nOpcAuto # Nil
   If nOpcAuto == 3
      INCLUI := .T.
      ALTERA := .F.
   ElseIf nOpcAuto == 4
      INCLUI := .F.
      ALTERA := .T.
   Else
      INCLUI := .F.
      ALTERA := .F.
   EndIf

	dbSelectArea( "SRA" )
	nPos := Ascan(aRotina,{|x| x[4]== nOpcAuto})
	If ( nPos <> 0 )
		bBlock := &( "{ |a,b,c,d,e| " + aRotina[ nPos,2 ] + "(a,b,c,d,e) }" )
		Eval( bBlock, Alias(), (Alias())->(Recno()),nPos)
	EndIf
Else
   If !ChkVazio( "SRA" )
      Return
   Endif
	
   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
   //ณ Inicializa o filtro utilizando a funcao FilBrowse                      ณ
   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
   cFiltraRh  := CHKRH("CSGPEA21","SRA","1")
   bFiltraBrw := {|| FilBrowse("SRA",@aIndexSRA,@cFiltraRH)}
   Eval( bFiltraBrw ) 
	
   dbSelectArea( "SRA" )
   mBrowse( 6, 1,22,75,"SRA",,,,,,fCriaCor() )
	
   EndFilBrw("SRA",aIndexSRA)
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CSGPEA21 บAutor  ณMicrosiga           บ Data ณ  04/24/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Substituicao de Funcao.                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function x11CSGPEA(cAlias,nReg,nOpcx)

Local aArea := GetArea()
Local nX    := 0
Local nPosRecno := 0

// Objetos Visuais
Local aAdvSize     := {}
Local aInfoAdvSize := {}
Local aObjSize     := {}
Local aObjCoords   := {}
Local aButtons     := {}
Local bSet15
Local bSet24
Local oDlg
Local oFont
Local oGroup

// Objetos da Pesquisa
Local aPesqIdx     := {}
Local aPesqOrd     := {}
Local lSeeAll      := .T.
Local cPesqCampo   := Space( 40 )
Local cPesqFiltro  := Space( 07 )
Local lAxPesqui    := .F. 
Local cPesqOrd      
  
// Blocos de Codigo usados para os objetos primeiro, ultimo, proximo e anterior
Local bRetrocOne
Local bRetrocAll
Local bAvancaOne
Local bAvancaAll
Local bFica

Local nOpca        := 0.00 

// Alias Utilizado
Private cAliasPai := "ZXC"

// arrays usados no GDMONTACOLS para o alias ZXC
// Campos Nao Mostrados
Private aNoCpoPai := { "ZXC_FILIAL" , "ZXC_MAT" }

// Campos Editaveis
Private aGdAltPai := {}

// Campos Virtuais
Private aVirtPai := {}
                            
// Campos Visuais
Private aVisuaPai := {}

// Guarda o Recno() dos Registros
Private aColRPai := {}

//Campos que nao Serao Alterados
Private aNAltPai := {}

// Cabecalho dos Campos
Private aHeadPai    := {}
Private aHeadPaiAll := {}

// Colunas do Objeto
Private aColsPai   := {}
Private aColsPaiAll := {}

// Guarda os Dados Originais para Comparacao na Gravacao
Private aColAntPai  := {}
Private aColsInclui := {}

// Guarda a Quantidade de Campos Editaveis
Private nUsadoPai := 0

// Variaveis para Montagem das Querys
Private aQueryPai := {}

// Variaveis Chave Usadas em Todo o Programa
Private cFil := SRA->RA_FILIAL
Private cMat := SRA->RA_MAT

// Objetos da GetDados
Private oGetPai

//Monta Block para Skip em GdMontaCols
Private bSkip      := { || .F. }
Private cSeekPai   := ""
Private lDaRefresh := .F.

DEFAULT cAlias := "SRA"
DEFAULT nReg   := SRA->(Recno())

ZXC->(dbSetOrder( 1 ))

// Monta os Blocos de Navegacao
bRetrocOne := {|| SRA->( dbskip(-1)), fGetDados(cAlias,nOpcX,SRA->RA_FILIAL,@cMat,@aVirtPai,@aColRPai,.T.,.F.),oGetPai:oBrowse:Refresh(),oDLG:Refresh()}
bRetrocAll := {|| SRA->( dbGoTop()), fGetDados(cAlias,nOpcX,SRA->RA_FILIAL,@cMat,@aVirtPai,@aColRPai,.T.,.F.),oGetPai:oBrowse:Refresh(),oDLG:Refresh()}
bAvancaOne := {|| SRA->( dbskip()),Ver_SRA_Eof(),fGetDados(cAlias,nOpcX,SRA->RA_FILIAL,@cMat,@aVirtPai,@aColRPai,.T.,.F.),oGetPai:oBrowse:Refresh(),oDLG:Refresh()}
bAvancaAll := {|| SRA->( dbGoBottom()),fGetDados(cAlias,nOpcX,SRA->RA_FILIAL,@cMat,@aVirtPai,@aColRPai,.T.,.F.),oGetPai:oBrowse:Refresh(),oDLG:Refresh()}
bFica      := {|| fGetDados(cAlias,nOpcX,SRA->RA_FILIAL,@cMat,@aVirtPai,@aColRPai,.T.,.F.),If(lDaRefresh,(oGetPai:oBrowse:Refresh(),oDLG:Refresh()),.T.)}

Begin Sequence
   
	dbSelectArea( cAliasPai )
                                                
	cSeekPai := ( cFil + cMat )

    // Monta Querys Para TopConnect
    QrysTop()
                                               
    // Monta Array aColsPai dos Objetos
    MontaCols()
   
	IF ( nOpcX == 3 ) .and. ( Len( aColRPai ) > 0 ) // Inclusao com lancamentos
		Help(" ",1,"A040CLANC")
		Break
	ElseIf ( nOpcX # 3 ) .and. ( Len( aColRPai ) == 0 ) // Alteracao sem lancamentos
		Help(" ",1,"A040SLANC")
		Break
	EndIF

	// monta campos virtuais
	MontaVirtuais()

   // carrega campos Editaveis
   MontaEditaveis()


   // Monta as Dimensoes dos Objetos

   aAdvSize	    := MsAdvSize()
   aInfoAdvSize := { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4], 0, 0 }
   aAdd( aObjCoords , { 015 , 020 , .T. , .F. } )	// Matricula + Nome + Admissao
   aAdd( aObjCoords , { 015 , 015 , .T. , .F. } )	// Vale Refeicao - Titulo
   aAdd( aObjCoords , { 000 , 070 , .T. , .F. } )	// Vale Refeicao - Dados
   aAdd( aObjCoords , { 015 , 015 , .T. , .F. } )	// Historico - Titulo
   aAdd( aObjCoords , { 000 , 110 , .T. , .F. } )	// Historico - Dados
   aAdd( aObjCoords , { 000 , 030 , .T. , .F. } )	// Navegacao
   aObjSize := MsObjSize( aInfoAdvSize , aObjCoords )

   nOpcA      := 0
   nPosRecno  := GdFieldPos( "ZXC_REC_WT"   , aHeadPai )

   For nX := 1 To Len( aColsPai )
       If aColsPai[nX,nPosRecno] > 0
          Aadd(aColAntPai, Aclone( aColsPai[nX] ) )
       EndIf
   Next nX
   
   DEFINE FONT oFont NAME "Arial" SIZE 0,-11 BOLD
    
   DEFINE MSDIALOG oDlg TITLE cCadastro From aAdvSize[7],0 TO aAdvSize[6],aAdvSize[5] OF oMainWnd PIXEL

   // Matricula
   @ aObjSize[1,1] , aObjSize[1,2] GROUP oGroup TO ( aObjSize[1,3] ),( ( aObjSize[1,4]/100*10 - 2 ) )	LABEL OemToAnsi( "Matrํcula:" ) OF oDlg PIXEL
   oGroup:oFont:= oFont
   // Nome
   @ aObjSize[1,1] , ( ( aObjSize[1,4]/100*10 ) ) GROUP oGroup TO ( aObjSize[1,3] ),( aObjSize[1,4]/100*80 - 2 ) LABEL OemToAnsi( "Nome:" ) OF oDlg PIXEL
   oGroup:oFont:= oFont
   // Admissao
   @ aObjSize[1,1] , ( aObjSize[1,4]/100*80 ) GROUP oGroup TO ( aObjSize[1,3] ),aObjSize[1,4]						LABEL OemToAnsi( "Admissใo" ) OF oDlg PIXEL
   oGroup:oFont:= oFont

   // Matricula
	@ ( ( aObjSize[1,3] ) - ( aObjSize[1,1] ) - 10 ) , ( aObjSize[1,2] + 5 ) SAY StrZero(Val(SRA->RA_MAT),Len(SRA->RA_MAT)) SIZE 050,10 OF oDlg PIXEL FONT oFont
   // Nome
   @ ( ( aObjSize[1,3] ) - ( aObjSize[1,1] ) - 10 ) , ( ( aObjSize[1,4]/100*10 ) + 5 ) SAY OemToAnsi(SRA->RA_NOME) SIZE 146,10 OF oDlg PIXEL FONT oFont
   // Admissao
   @ ( ( aObjSize[1,3] ) - ( aObjSize[1,1] ) - 10 ) , ( ( aObjSize[1,4]/100*80 ) + 5 ) SAY Dtoc(SRA->RA_ADMISSA) SIZE 050,10 OF oDlg PIXEL FONT oFont

   // Salario Substituicao
   @ aObjSize[2,1] , aObjSize[2,2] GROUP oGroup TO ( aObjSize[4,3] ), ( aObjSize[4,4] )	LABEL ""	OF oDlg PIXEL
   oGroup:oFont:= oFont
   @ ( ( ( ( aObjSize[2,3] ) - ( aObjSize[2,1] ) ) / 2 ) + ( aObjSize[2,1] - 3 ) ) , ( ( aObjSize[2,2] ) + 180 )		SAY OemToAnsi( "Cadastro de Anu๊nios" )		SIZE 150,10 OF oDlg PIXEL FONT oFont

   oGetPai := MsNewGetDados():New(											;
                                   aObjSize[3,1],							;
		                           aObjSize[3,2],							;
    		                       aObjSize[5,3],							;
		                           aObjSize[5,4],							;
		                           If(										;
		                              nOpcx == 2 .Or. nOpcx == 5,			;
		                              0, 									;
		                              GD_INSERT+GD_UPDATE+GD_DELETE			;	// GD_INSERT+GD_UPDATE+GD_DELETE
		                           ),										; 	// Controle do que Podera ser Realizado na GetDado - nstyle
		                           "U_CSPA11LOk()",							;
		                           "U_CSPA11TOk()",							;
		                           Nil,										;
		                           Nil,										;
		                           0,										;
		                           99999,									;
		                           Nil,										;
		                           Nil,										;
		                           Nil,										;
		                           oDlg,									;
		                           aHeadPai,								;
		                           aColsPai									)

   //Define grupo do rodape
   @ (aObjSize[6,1] + 6) , ( ( aObjSize[6,2]+2 ) ) 		GROUP oGroup TO ( aObjSize[6,3] +05 ),( (aObjSize[6,4]/100*78)	  ) LABEL OemToAnsi( "Pesquisar Funcionarios" ) OF oDlg PIXEL	 //
   oGroup:oFont:= oFont 
   @ (aObjSize[6,1] + 6) , ( ( aObjSize[6,4]/100*78 ) ) 	GROUP oGroup TO ( aObjSize[6,3] +05 ),( (aObjSize[6,4])	  ) 		LABEL OemToAnsi( "" ) OF oDlg PIXEL	 //
   oGroup:oFont:= oFont 

   //Lista Botoes de posicionamento do funcionario
   @ ( ( aObjSize[6,1] ) +17 ) , ( ( aObjSize[6,2] )+08.96) 	BUTTON oBtnPgPrev 	PROMPT OemToAnsi("<<")	 SIZE 021.5,009 DESIGN ACTION U_CSPA11Mov(bRetrocAll) OF oDlg PIXEL
   @ ( ( aObjSize[6,1] ) +17 ) , ( ( aObjSize[6,2] )+29.96)	BUTTON oBtnPrev		PROMPT OemToAnsi("<")	 SIZE 021.5,009 DESIGN ACTION U_CSPA11Mov(bRetrocOne) OF oDlg PIXEL
   @ ( ( aObjSize[6,1] ) +17 ) , ( ( aObjSize[6,2] )+50.96)	BUTTON oBntNext  	PROMPT OemToAnsi(">")	 SIZE 021.5,009 DESIGN ACTION U_CSPA11Mov(bAvancaOne) OF oDlg PIXEL
   @ ( ( aObjSize[6,1] ) +17 ) , ( ( aObjSize[6,2] )+71.96)	BUTTON oBtnPgNext 	PROMPT OemToAnsi(">>")	 SIZE 021.5,009 DESIGN ACTION U_CSPA11Mov(bAvancaALL) OF oDlg PIXEL

   AxPesqOrd("SRA",@aPesqIdx,,lSeeAll,@aPesqOrd)
   cPesqOrd := aPesqOrd[1]

   @ ((aObjSize[6,1])+17),((aObjSize[6,4])*0.22) 			COMBOBOX oPesqCbx 	VAR cPesqOrd ITEMS aPesqOrd SIZE 100,36 	PIXEL OF oDlg ON CHANGE If(lAxPesqui,(DbSelectArea(cAliasPai),DbSetOrder(aPesqIdx[oPesqCbx:nAt][1]), MbrSetAllCols(cAliasPai,aIdxCol,,__oObjBrow),__oObjBrow:Refresh()),)
   @ ((aObjSize[6,1])+17),((aObjSize[6,4])*0.22 + 110) 	MSGET    oPesqGet 	VAR cPesqCampo 	SIZE 100,09 	PIXEL OF oDlg 
   @ ((aObjSize[6,1])+17),((aObjSize[6,4])*0.22 + 220) 	BUTTON   "Ok" 			SIZE 021.5,009 	PIXEL OF oDlg ACTION (AxPesqSeek("SRA",.F.,cPesqCampo,,aPesqIdx,oPesqCbx:nAt,lSeeAll,),U_CSPA11Mov(bFica))

   //Pesquisar Competencia
   //@ ((aObjSize[6,1])+17),((aObjSize[6,4])/100*82)  		MSGET    oFiltraGet	VAR cPesqFiltro	SIZE 040,09 	PIXEL OF oDlg PICTURE "@R 99/9999"   	VALID ( VAL(SubStr(cPesqFiltro,1,2)) > 0 .And. VAL(SubStr(cPesqFiltro,1,2)) < 13 )
   //@ ((aObjSize[6,1])+17),((aObjSize[6,4])/100*92)  		BUTTON   "Ok" 			SIZE 021.5,009 	PIXEL OF oDlg ACTION ( fPosZZ1(cPesqFiltro) )

   bSet15 := {|| nOpca:=If(nOpcx=5,2,1), If(oGetPai:TudoOk(),oDlg:End(), nOpca:= 0)}
   bSet24 := {|| nOpca:= 0, oDlg:End() }

   //aButtons :=	{{ "EDIT"     ,{ ||U_FRGPER03() } ,"Impressao do Contrato","Contrato" },;
   //              { "NOTE"     ,{ ||U_FRGPER04() } ,"Impressao do Demonstrativo","Demonstr" },;
   //              { "BUDGETY"  ,{ ||U_FRGPER05() } ,"Impressao da Nota Promissoria","Promissoria" }}

   ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg, bSet15, bSet24, Nil, aButtons )

   If nOpca # 0
      If ( nOpca == 1 .And. nOpcX <> 2 ) .Or. nOpcx == 5
         fAuxGrava( cAliasPai , cFil , cMat , aVirtPai , aColRPai , nOpcx )
      EndIf
   EndIf

End Sequence

RestArea( aArea )
If nOpcX == 3
   MBrChgLoop(.F.)
EndIf	

Return( Nil )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CSGPEA21 บAutor  ณMicrosiga           บ Data ณ  04/24/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function QrysTop()

#IFDEF TOP
   // Query Para ZXC
   aQueryPai    := Array( 1 )
   aQueryPai[1] := "ZXC_FILIAL = '" + cFil + "'"
   aQueryPai[1] += " AND ZXC_MAT = '" + cMat + "'"
   aQueryPai[1] += " AND D_E_L_E_T_ <> '*'"
#ENDIF


Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CSGPEA21 บAutor  ณMicrosiga           บ Data ณ  04/24/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function MontaEditaveis()

 Local nX := 0
 aGdAltPai := {}

 For nX := 1 To nUsadoPai
     If (( aScan(aVirtPai,   aHeadPai[nX,02]) == 0 ) .And. 			;
         ( aScan(aVisuaPai,  aHeadPai[nX,02]) == 0 ) .And. 			;
         ( aScan(aNoCpoPai,  aHeadPai[nX,02]) == 0 ) .And. 			;
         ( aScan(aNAltPai,   aHeadPai[nX,02]) == 0 ) 				   )
         aAdd( aGdAltPai, aHeadPai[nX,02] )
     EndIf
 Next

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CSGPEA21 บAutor  ณMicrosiga           บ Data ณ  04/24/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function MontaVirtuais( nOpcX )

 Local aOld      := GETAREA()
 Local nSRAOrd   := SRA->(IndexOrd())
 Local nSRARec   := SRA->(Recno())
 //Local cFilSrv   := xFilial( "SRV" )
 //Local nX
 
 SRV->(dbSetOrder( 1 ))

 //If ( nOpcX <> 3 ) //Quando Nao for Inclusao
 //   For nX := 1 To Len( aColsPai )
 //   Next nX
 //EndIf
 
 SRA->(dbSetOrder( nSRAOrd ))
 SRA->(dbGoTo( nSRARec ))
 RESTAREA( aOld )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CSGPEA21 บAutor  ณMicrosiga           บ Data ณ  04/24/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function MontaCols()  

 Local aOldAtu  := GETAREA()
 Local nPosDatq := 0
 
 aColsPai:= GdMontaCols(@aHeadPai,		; //01 -> Array com os Campos do Cabecalho da GetDados
 								@nUsadoPai,		; //02 -> Numero de Campos em Uso
							   @aVirtPai,		; //03 -> [@]Array com os Campos Virtuais
							   @aVisuaPai,		; //04 -> [@]Array com os Campos Visuais
							   "ZXC",			; //05 -> Opcional, Alias do Arquivo Carga dos Itens do aCols
							   aNoCpoPai,		; //06 -> Opcional, Campos que nao Deverao constar no aHeader
							   @aColRPai,		; //07 -> [@]Array unidimensional contendo os Recnos
							   "ZXC",			; //08 -> Alias do Arquivo Pai
							   cSeekPai,		; //09 -> Chave para o Posicionamento no Alias Filho
							   NIL,				; //10 -> Bloco para condicao de Loop While
							   bSkip,			; //11 -> Bloco para Skip no Loop While
							   NIL,				; //12 -> Se Havera o Elemento de Delecao no aCols
							   NIL,				; //13 -> Se cria variaveis Publicas
							   NIL,				; //14 -> Se Sera considerado o Inicializador Padrao
							   NIL,				; //15 -> Lado para o inicializador padrao
							   NIL,				; //16 -> Opcional, Carregar Todos os Campos
							   NIL,				; //17 -> Opcional, Nao Carregar os Campos Virtuais
							   aQueryPai,		; //18 -> Opcional, Utilizacao de Query para Selecao de Dados
							   .F.,				; //19 -> Opcional, Se deve Executar bKey  ( Apenas Quando TOP )
							   .F.,				; //20 -> Opcional, Se deve Executar bSkip ( Apenas Quando TOP )
							   .T.,				; //21 -> Carregar Coluna Fantasma e/ou BitMap ( Logico ou Array )
							   NIL,				; //22 -> Inverte a Condicao de aNotFields carregando apenas os campos ai definidos
							   NIL,				; //23 -> Verifica se Deve Checar se o campo eh usado
							   NIL,				; //24 -> Verifica se Deve Checar o nivel do usuario
							   NIL,				; //25 -> Verifica se Deve Carregar o Elemento Vazio no aCols
							   NIL,				; //26 -> [@]Array que contera as chaves conforme recnos
							   NIL,				; //27 -> [@]Se devera efetuar o Lock dos Registros
							   NIL,				; //28 -> [@]Se devera obter a Exclusividade nas chaves dos registros
							   NIL,				; //29 -> Numero maximo de Locks a ser efetuado
							   .F.			   ) //30 -> Utiliza Numeracao na GhostCol

 aColsPaiAll := Aclone( aColsPai )
 aHeadPaiAll := Aclone( aHeadPai )
 
 nPosDatq  := GdFieldPos( "ZXC_DATARQ"  , aHeadPai )
 Aeval(aColsPai,{|x| x[nPosDatq] := Right(x[nPosDatq],2) + Left(x[nPosDatq],4)})
 
 RESTAREA( aOldAtu )
 
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CSGPEA21 บAutor  ณMicrosiga           บ Data ณ  04/24/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
User Function CSPA11LOk()

 Local lRet      := .T.
 Local nPosDel   := GdFieldPos( "GDDELETED" , aHeadPai )
 Local aColsAnt  := Aclone( oGetPai:aCols )

 Local cTexto    := ""
 Local nX

 If !aCols[n,nPosDel]
    If n <= Len( aColsPaiAll )
       If !fCompArray( aCols[n] , aColsPaiAll[n] )
          //aCols[n,nPosSinc] := "1"
       EndIf
    EndIf
 EndIf

/*
 If !aCols[n,nPosDel]
    For nX := 1 To Len( aCols )
        If nX == n .Or. aCols[nX,nPosDel]
           Loop
        EndIf
        
        // Verifica Duplicidade nos Lancamentos
        If aCols[n,nPosTipo] == aCols[nX,nPosTipo] .And. aCols[n,nPosDtIni] == aCols[nX,nPosDtIni]
           If aCols[n,nPosTipo] == "1"
              cTexto := "Jแ existe advert๊ncia para esta data!"
           ElseIf aCols[n,nPosTipo] == "2"
              cTexto := "Jแ existe suspensใo para esta data!"
           EndIf
           
           Aviso("ATENCAO",cTexto,{"Retornar"})
           lRet := .F.
        EndIf
    Next nX
 EndIf
*/
  
Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CSGPEA21 บAutor  ณMicrosiga           บ Data ณ  04/24/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
User Function CSPA11TOk()

 Local lRet := .T.


Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CSGPEA21 บAutor  ณMicrosiga           บ Data ณ  04/25/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
User Function CSPA11Mov( bFunc )

Eval(bFunc)

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CSGPEA21 บAutor  ณMicrosiga           บ Data ณ  04/25/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fAuxGrava( cAlias , cFil , cMat , aVirtual , aRegAltera , nOpc )

Local aHeaderAux := Aclone( oGetPai:aHeader )
Local aColsAux   := Aclone( oGetPai:aCols )
Local aColsAnt   := Aclone( aColAntPai )
Local cPrefixo   := ( PrefixoCpo( cAlias ) + "_" )
Local cCampo     := ""
Local lTudoIgual := .F.
Local nX         := 0
Local nY         := 0
Local nLenHeader := Len( aHeaderAux )
Local nLenCols   := Len( aColsAux )
Local nLenAlt    := Len( aRegAltera	)
Local nPosDel    := GdFieldPos( "GDDELETED"  , aHeaderAux)
Local nPosDatarq := GdFieldPos( "ZXC_DATARQ" , aHeaderAux)

nLenCols := Len( aColsAux )

//Ajusta campos ZXC_DATARQ no Formato AAAAMM
nPosDatarq := GdFieldPos( "ZXC_DATARQ", oGetPai:aHeader )
If nPosDatarq > 0
   Aeval(oGetPai:aCols,{|x| x[nPosDatarq] := Right(x[nPosDatarq],4) + Left(x[nPosDatarq],2)})
   Aeval(aColsAux,{|x| x[nPosDatarq] := Right(x[nPosDatarq],4) + Left(x[nPosDatarq],2)})
EndIf

Begin Transaction 

If nOpc == 5  //Exclusao
   DelRecnos( cAlias , @aRegAltera )
   ( cAlias )->( EvalTrigger() )
Else //Inclusao ou Alteracao
   If !fCompArray( aColsAux , aColsAnt )
      If nLenAlt > 0
         For nX := 1 To nLenAlt
             lTudoIgual := fCompArray( aColsAux[ nX ] , aColsAnt[nX] )
             If lTudoIgual .and. !( aColsAux[nX,nPosDel] )
                Loop
             EndIf
             ( cAlias )->( dbGoto( aRegAltera[nX] ) )
             ( cAlias )->( RecLock( cAlias , .F. , .T. ) )
             If ( aColsAux[nX,nPosDel] )
                (cAlias)->( dbDelete() )
             Else
                (cAlias)->(&(cPrefixo+"FILIAL"))  := cFil
                (cAlias)->(&(cPrefixo+"MAT"))     := cMat
                For nY := 1 To nLenHeader

                    //Obtem o Campo para Gravacao
                    cCampo := aHeaderAux[nY,2]

                    //Nao Grava Campo Virtual
                    If aScan(aVirtual,cCampo) # 0
                       Loop
                    EndIf
							
                    (cAlias)->( &cCampo ) := aColsAux[nX,nY]
														
                Next nY           
             EndIf

             //Destrava o Registro
             ( cAlias )->( MsUnLock() )
         Next nX

         If ( nLenCols > nLenAlt ) // Se Trata de Inclusao de Itens
            fAuxGrInc( cAlias , cPrefixo , cFil , cMat , aVirtual , ( nLenAlt + 1 ) )
         EndIf
      Else
         fAuxGrInc( cAlias , cPrefixo , cFil , cMat , aVirtual , 1 )
      EndIf

      ( cAlias )->( EvalTrigger() )
   EndIf

EndIf

End Transaction

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CSGPEA21 บAutor  ณMicrosiga           บ Data ณ  04/25/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fAuxGrInc( cAlias , cPrefixo , cFil , cMat , aVirtual , nIniciar )

Local aHeaderAux := Aclone( oGetPai:aHeader )
Local aColsAux   := Aclone( oGetPai:aCols )
Local cCampo     := ""
Local nLenHeader := Len( aHeaderAux )
Local nLenCols   := Len( aColsAux )
Local nPosDel    := GdFieldPos( "GDDELETED", aHeaderAux )
Local nX         := 0
Local nY         := 0

For nX := nIniciar To nLenCols

    If !( aColsAux[nX,nPosDel] )
       (cAlias)->( RecLock(cAlias,.T.) )
       (cAlias)->(&(cPrefixo+"FILIAL")) := cFil
       (cAlias)->(&(cPrefixo+"MAT"))    := cMat

       For nY := 1 To nLenHeader

           //Obtem o Campo para Gravacao
           cCampo := aHeaderAux[nY,2]

           //Nao Grava Campo Virtual
           If aScan(aVirtual,cCampo) # 0
              Loop
           EndIf

           (cAlias)->( &cCampo ) := aColsAux[nX,nY]

       Next nY              
       //Destrava o Registro
       ( cAlias )->( MsUnLock() )
    EndIf

Next nX

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CSGPEA21 บAutor  ณMicrosiga           บ Data ณ  04/25/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fGetDados(cAlias, nOpcX, cFil, cMat, aVirtual1, aColsRec1, lGravarAntes, lEntrada)

Default lEntrada 	:= .F.

// Antes de montar a tela, verifica se deseja gravar ... caso tenha tido alguma alteracao.
If lGravarAntes 
   MsAguarde( { || fAuxGrava( "ZXC" , cFil , cMat , aVirtual1 , aColsRec1 , nOpcx ) },;
                   OemToAnsi( "Gravando Registros..." ))
EndIf
	
cFil := SRA->RA_FILIAL
cMat := SRA->RA_MAT

// Monta Query para a Selecao das Informacoes em GdMontaCols
QrysTop()

// Se esta entrando na tela, verifica se existe algum lancamento, independente do periodo, 
// para o funcionario selecionado. Se for inclusao, nao deve ter nenhum registro. Se for
// alteracao, deve ter pelo menos um registro. 
If lEntrada
   cKeySeek := ( cFil + cMat )

   // Monta array aColsPai dos objetos
   MontaCols()

   If ( ( nOpcX == 3 ) .and. ( Len( aColsRec ) > 0 ) ) //Quando for Inclusao
      Help(" ",1,"A040CLANC")
      Break
   ElseIf ( nOpcX <> 3 ) .and. ( Len( aColsRec ) == 0 ) //Quando Nao for Inclusao
      Help(" ",1,"A040SLANC")
      Break
   EndIf
EndIf
	
cKeySeek := ( cFil + cMat )

//Monta os Detalhes
ZXC->(dbSetOrder( 1 ))

// Monta array aColsPai dos objetos
MontaCols()
// monta campos virtuais
MontaVirtuais()
// carrega campos Editaveis
MontaEditaveis()
                
// Salva o acols antes da alteracao
aColAntPai	:= aClone( aColsPai )

// atualiza a getdados
If !(oGetPai == nil)
   oGetPai:aCols := aClone(aColsPai)
   oGetPai:Refresh()
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCSGPEA21  บAutor  ณMicrosiga           บ Data ณ  01/16/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Ver_SRA_EOF()

 Local lSkip:= .T.
          
 If SRA->(EOF())
    lSkip       := .F.
    aColsPai    := {}
    aColsPaiAll := {}
 EndIf   

Return( lSkip )
