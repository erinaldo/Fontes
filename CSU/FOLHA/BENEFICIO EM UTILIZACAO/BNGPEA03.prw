#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

/* 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BNGPEA03 บAutor  ณ Adilson Silva      บ Data ณ 06/06/2011  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta Calendario de Escalas p/ Vale Transporte e Vale      บฑฑ
ฑฑบ          ณ Refeicao/Alimentacao.                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGenerico                                                    บฑฑ
ฑฑบฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤบฑฑ
ฑฑบ         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             บฑฑ
ฑฑบฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤบฑฑ
ฑฑบAnalista  ณ Data   ณ BOPS ณMotivo da Alteracao                         บฑฑ
ฑฑบฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤลฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤบฑฑ
ฑฑบ          ณ        ณ      |                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function BNGPEA03()

Local aAreaZT4 := ZT4->( GetArea() ) 
Local aIndex   := {}
Local cFiltra  := ""

/*
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
ณ Define Array contendo as Rotinas a executar do programa      ณ
ณ ----------- Elementos contidos por dimensao ------------     ณ
ณ 1. Nome a aparecer no cabecalho                              ณ
ณ 2. Nome da Rotina associada                                  ณ
ณ 3. Usado pela rotina                                         ณ
ณ 4. Tipo de Transao a ser efetuada                          ณ
ณ    1 - Pesquisa e Posiciona em um Banco de Dados             ณ
ณ    2 - Simplesmente Mostra os Campos                         ณ
ณ    3 - Inclui registros no Bancos de Dados                   ณ
ณ    4 - Altera o registro corrente                            ณ
ณ    5 - Remove o registro corrente do Banco de Dados          ณ
ณ    6 - Copiar                                                ณ
ณ    7 - Legenda                                               ณ
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
Private aRotina := {{ "Pesquisar"  , "PesqBrw"        , 0 , 1 }  ,;
                    { "Visualizar" , "U_x03BNGPEA(2)" , 0 , 2 }  ,;
                    { "Incluir"    , "U_x03BNGPEA(3)" , 0 , 3 }  ,;
                    { "Alterar"    , "U_x03BNGPEA(4)" , 0 , 4 }  ,;
                    { "Excluir"    , "U_x03BNGPEA(5)" , 0 , 5 }  ,;
                    { "Replicar"   , "U_x03Replic(4)" , 0 , 5 }   }

Private bFiltraBrw := { || NIL }
Private cCadastro  := OemToAnsi( "Tabela de Escalas de Benefํcios" )
Private cPerg      := "BNGPEA03"
Private nTpBen     := 0
Private cCompDe    := ""
Private cCompAte   := ""
Private cPeriod    := ""

fAsrPerg()
Pergunte(cPerg,.T.)
 cCompDe  := Right(mv_par01,4) + Left(mv_par01,2)
 cCompAte := Right(mv_par02,4) + Left(mv_par02,2)
 cPeriod  := mv_par03

/*
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
ณ Inicializa o filtro utilizando a funcao FilBrowse                      ณ
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
cFiltra := "ZT4->ZT4_CODIGO == ZT3->ZT3_CODIGO"
If !Empty( cCompDe ) .And. !Empty( cCompAte )
   cFiltra += " .And. ZT4->(ZT4_ANO+ZT4_MES) >= cCompDe .And. ZT4->(ZT4_ANO+ZT4_MES) <= cCompAte"
EndIf
If !Empty( cPeriod )
   cFiltra += " .And. ZT4->ZT4_PERIOD == cPeriod"
EndIf
bFiltraBrw 	:= { || FilBrowse( "ZT4" , @aIndex , @cFiltra ) }
Eval( bFiltraBrw )

/*
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
ณ Chama a Funcao de Montagem do Browse                                   ณ
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
mBrowse( 6 , 1 , 22 , 75 , "ZT4" , , , , , , )
	
/*
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
ณ Deleta o filtro utilizando a funcao FilBrowse                     	 ณ
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
EndFilBrw( "ZT4" , aIndex )
	
/*
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
ณ Restaura os Dados de Entrada 											 ณ
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
RestArea( aAreaZT4 ) 

Return( NIL )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BNGPEA03 บAutor  ณMicrosiga           บ Data ณ  09/27/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function x03BNGPEA( nOpc )

Local cKey			:= ''
Local aFields		:= {}
Local aColsRec		:= {}
Local aAltera		:= {}
Local aNaoAltera	:= {}
Local aNotFields	:= {}
Local aVirtChoice	:= {}
Local aVirtGd		:= {}
Local aVisualChoice := {}
Local aVisualGD		:= {} 
Local aAdvSize		:= {}
Local aInfoAdvSize	:= {}
Local aObjSize		:= {}
Local aObjCoords	:= {}
Local bSet15		:= { || NIL }
Local bSet24		:= { || NIL }
Local nOpcAlt		:= 0.00
Local nUsado		:= 0.00
Local nX			:= 0.00
Local nXs			:= 0.00
Local nPosDiaMes	:= 0.00
Local nPosDesDia	:= ""
Local dData			:= ctod("//")

Private	oDlg		:= NIL
Private oEnchoice	:= NIL
Private oGetDados	:= NIL

Private aEnchoice	:= {}
Private aColsEnCho  := {}
Private aHeader		:= {}
Private aCols		:= {}
Private aSvCols		:= {}
Private aSvEnchoice	:= {}

Private cAlias      := "ZT4"
Private nReg        := If(ZT4->(RecCount()) >= 1, ZT4->(Recno()), 0)
Private aQuerySel   := Array(1)
Private bSkip

Begin Sequence

   // Quando For Inclusao Posiciona o ZT4 No Final do Arquivo
   If nOpc == 3
      If fSelRadio(@nTpBen,"Tipo do Beneficio" ,		;
                             "Escolha o Beneficio" ,	;
                             "Vale Transporte" ,		;
                             "Vale Refeicao" ,			;
                             "Vale Alimentacao" ) == 0
         Return
      EndIf
      fPosIncl( @nReg ) 
   EndIf 

   //Monta os Dados para a Enchoice
   aColsEnCho  := ZT4->(GdMontaCols(@aEnChoice,@nXs,@aVirtChoice,@aVisualChoice,NIL,{ "ZT4_FILIAL" })) 
   aSvEnchoice := aClone( aColsEnCho )

   //Cria as Variaveis de Memoria e Carrega os Dados Conforme o arquivo
   For nX := 1 To nXs
       Aadd(aFields, aEnchoice[nX,02])
       Private &( "M->"+aEnchoice[nX,02] ) := aColsEnCho[01,nX]
   Next
   
   If nOpc == 3 //Inclusao
      M->ZT4_CODIGO := ZT3->ZT3_CODIGO
      M->ZT4_TIPBEN := Str(nTpBen,1)
   EndIf
   M->ZT4_DESC := ZT3->ZT3_DESC
   
   //Define os Campos Editaveis na Enchoice Apenas na Inclusao( 3 ) ou Alteracao(4)
   If nOpc == 3 .Or. nOpc == 4
      //Define campos como nao editaveis na alteracao
      If nOpc == 4 
         Aadd(aVisualChoice,"ZT4_CODIGO" )
         Aadd(aVisualChoice,"ZT4_DESC"   )
         Aadd(aVisualChoice,"ZT4_MES"    )
         Aadd(aVisualChoice,"ZT4_ANO"    )	
         Aadd(aVisualChoice,"ZT4_PERIOD" )
         Aadd(aVisualChoice,"ZT4_TIPBEN" )
      Endif	
      nXs := Len( aVisualChoice )
      For nX := 1 To nXs
          Aadd(aNaoAltera, aVisualChoice[nX])
      Next nX
      nXs := Len( aFields ) 
      For nX := 1 To nXs
          If Ascan(aNaoAltera, { |x| x==aFields[nX] }) == 0
             Aadd(aAltera, aFields[nX])
          EndIf
      Next nX
   EndIf
	
   //Monta os Dados para a GetDados
   Aadd( aNotFields, "ZT5_FILIAL" )
   Aadd( aNotFields, "ZT5_CODIGO" )
   Aadd( aNotFields, "ZT5_PERIOD" )
   Aadd( aNotFields, "ZT5_TIPBEN" )
   Aadd( aNotFields, "ZT5_ANO"    )
   Aadd( aNotFields, "ZT5_MES"    )
   If M->ZT4_TIPBEN == "1"	// Vale Transporte
      Aadd( aNotFields, "ZT5_VR" )
      Aadd( aNotFields, "ZT5_VA" )
   ElseIf M->ZT4_TIPBEN == "2"	// Vale Refeicao
      Aadd( aNotFields, "ZT5_VT" )
      Aadd( aNotFields, "ZT5_DVT" )
      Aadd( aNotFields, "ZT5_VA" )
   ElseIf M->ZT4_TIPBEN == "3"	// Vale Alimentacao
      Aadd( aNotFields, "ZT5_VT" )
      Aadd( aNotFields, "ZT5_DVT" )
      Aadd( aNotFields, "ZT5_VR" )
   EndIf
   
   cKey  := xFilial("ZT5") + M->ZT4_CODIGO + M->ZT4_PERIOD + M->ZT4_TIPBEN + M->ZT4_ANO + M->ZT4_MES
   bSkip := { || .F. }
   aQuerySel[1] := "ZT5_FILIAL+ZT5_CODIGO+ZT5_PERIOD+ZT5_TIPBEN+ZT5_ANO+ZT5_MES = '" + cKey + "' AND D_E_L_E_T_ <> '*'"

   aCols   := GdMontaCols( @aHeader,	; 
                           @nUsado, 	;
                           @aVirtGd, 	;
                           @aVisualGd, 	;
                           "ZT5",      	;
                           aNotFields, 	;
                           @aColsRec, 	;
                           "ZT5", 		;
                           cKey, 		;
                           Nil,			;
                           bSkip,		;
                           Nil,			;
                           Nil,			;
                           Nil,			;
                           Nil,			;
                           Nil,			;
                           Nil,			;
                           aQuerySel	)
   aSvCols := aClone( aCols )
	
   If nOpc # 3	// Se nao for inclusao 
      nPosDiaMes := GdFieldPos( "ZT5_DATA" ,aHeader ) 
      nPosDesDia := GdFieldPos( "ZT5_DESC" ,aHeader ) 
      For nX := 1 To Len( aCols )
          //Carrega a Descricao Do Dia do Mes
          dData := aCols[nX,nPosDiaMes]
          aCols[nX,nPosDesDia] := GPEDiaSem( dData )
      Next nX
   EndIf
	                 
   // Monta as Dimensoes dos Objetos
   aAdvSize     := MsAdvSize() 
   aInfoAdvSize := { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 0 , 0 } 
   Aadd( aObjCoords , { 015 , 080 , .T. , .F. } )
   Aadd( aObjCoords , { 000 , 000 , .T. , .T. } )
   aObjSize     := MsObjSize( aInfoAdvSize , aObjCoords )
	
   //Monta o Dialogo Principal
   SetaPilha()
   DEFINE MSDIALOG oDlg TITLE OemToAnsi( cCadastro ) From aAdvSize[7],0 TO aAdvSize[6],aAdvSize[5] OF oMainWnd PIXEL 

   oEnchoice := MsmGet():New( "ZT4",			;
                               nReg,			;
                               nOpc,			;
                               NIL,				;
                               NIL,				;
                               NIL,				;
                               aFields,			;
                               aObjSize[1],		;
                               aAltera,			;
                               NIL,				;
                               NIL,				;
                               NIL,				;
                               oDlg,			;
                               NIL,				;
                               .F. 				;
                             )

   //oEnchoice:oBox:bLostFocus := { || fValidData() }
   //oEnchoice:oBox:bValid := { || fValidData() }

   oGetDados := MsGetDados():New( aObjSize[2,1],	;
                                   aObjSize[2,2],	;
                                   aObjSize[2,3],	;
                                   aObjSize[2,4],	;
                                   nOpc,			;
                                   "U_lOkBNGPEA03",	;
                                   "",				;
                                   "",				;
                                   .F.,				;
                                   NIL,				;
                                   2,				;
                                   NIL,				;
                                   Len(aCols)		;
                                  ) 

   oGetDados:oBrowse:bGotFocus := { || MontaCalend( nOpc ) }

   bSet15 := {||If( Obrigatorio( oEnchoice:aGets , oEnchoice:aTela ) .And. EnchoTudOk( oEnchoice ) ,( nOpcAlt := 1.00 , oDlg:End() ) , ( nOpcAlt := 0.00 , .F. ) ) }
   bSet24 := {||oDlg:End() } 

   ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar( oDlg , bSet15 , bSet24,  )
   SetaPilha()                          
	
   If nOpcAlt == 1 .And. nOpc # 2
      BNGPEA03Grava( nOpc , nReg , aEnchoice , aVirtChoice , aHeader , aCols )
   EndIf

End Sequence
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BNGPEA03 บAutor  ณMicrosiga           บ Data ณ  09/27/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
User Function lOkBNGPEA03( oBrowse ) 

 Local lRet := .T. 

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BNGPEA03 บAutor  ณMicrosiga           บ Data ณ  09/27/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function BNGPEA03Grava(	nOpc		,;	//Opcao de Acordo com aRotina
							 	nReg		,;	//Numero do Registro do Arquivo Pai ( ZT4 )
							 	aEnchoice	,;	//Campos do Arquivo Pai ( ZT4 ) Mesma Estrutura do aHeader
							 	aVirtChoice ,;	//Campos Virtuais do Arquivo Pai ( ZT4 )
							 	aHeader		,;	//Campos do Arquivo Filho ( ZT5 )
							 	aCols		 ;	//Itens do Arquivo Filho ( ZT5 )
							  )
							  
Local cCampo		:= ""
Local cKey			:= ""
Local nChoice		:= 0
Local nChoices		:= 0
Local nHeaders		:= 0
Local nCols			:= 0
Local nX			:= 0
Local nY			:= 0 
Local xConteudo 	:= ""
Local nDeleted		:= 0

DEFAULT nOpc		:= 0
DEFAULT nReg		:= 0
DEFAULT aEnchoice	:= {}
DEFAULT aVirtChoice	:= {}
DEFAULT aHeader		:= {}
DEFAULT aCols		:= {}

nChoices			:= Len( aEnchoice )
nHeaders			:= Len( aHeader )
nCols				:= Len( aCols )
nDeleted			:= Len( aHeader ) + 1 

If nOpc == 5		// Exclusao ( nOpc == 5 )
	Begin Transaction
		If nReg > 0
			ZT4->( dbGoto( nReg ) )
			cKey := ZT4->(ZT4_FILIAL + ZT4_CODIGO + ZT4_PERIOD + ZT4_TIPBEN + ZT4_ANO + ZT4_MES)
			RecLock("ZT4",.F.)
			fDeletaItens( cKey )
			ZT4->( dbDelete() )
			ZT4->( MsUnLock() )
		Endif
	End Transaction
ElseIf nOpc == 3 .Or. nOpc == 4		// Inclusao/Alteracao ( nOpc == 3 .or. nOpc == 4 )
	For nChoice := 1 To nChoices
		aColsEnCho[ 01 , nChoice ] := &( "M->"+aEnchoice[ nChoice , 02 ] )
	Next nChoice
    
	// Compara os arrays na alteracao caso nใo houve modificacao nao grava
	If nOpc == 4 .and. ( fCompArray( aCols , aSvCols ) )  .And. fCompArray( aColsEnCho , aSvEnchoice)
		Return
	Endif 

	Begin Transaction
	
		If nReg > 0
			ZT4->( dbGoto( nReg ) )
			RecLock("ZT4",.F.)
		Else
			RecLock("ZT4",.T.)
			 //ZT4->ZT4_FILIAL := SM0->M0_CODFIL
		EndIF

		For nChoice := 1 To nChoices
			IF ( Ascan( aVirtChoice , { |cCpo| ( cCpo == aEnchoice[ nChoice , 02 ] ) } ) == 0.00 )
				ZT4->( &( aEnchoice[ nChoice , 02 ] ) ) := &( "M->"+aEnchoice[ nChoice , 02 ] )
			EndIF
		Next nChoice

		cKey := ZT4->(ZT4_FILIAL+ZT4_CODIGO+ZT4_PERIOD+ZT4_TIPBEN+ZT4_ANO+ZT4_MES)
		ZT4->( MsUnLock() )

		fDeletaItens(cKey)	// Deleta Itens

		dbSelectArea( "ZT5" )
		For nX := 1 To nCols 
			If !aCols[nX,nDeleted] 
				RecLock("ZT5",.T.)
				//ZT5->ZT5_FILIAL	:= ZT4->ZT4_FILIAL
				ZT5->ZT5_CODIGO	:= ZT4->ZT4_CODIGO
				ZT5->ZT5_PERIOD	:= ZT4->ZT4_PERIOD
				ZT5->ZT5_TIPBEN	:= ZT4->ZT4_TIPBEN
				ZT5->ZT5_ANO	:= ZT4->ZT4_ANO
				ZT5->ZT5_MES	:= ZT4->ZT4_MES
				xConteudo := ""
				For nY := 1 To nHeaders 
					cCampo    := Trim(aHeader[ny][2])
					xConteudo := aCols[nX,ny]
					&cCampo   := xConteudo
				Next nY 
				ZT5->( MsUnlock() )
			EndIf
			
		Next nX
	End Transaction
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BNGPEA03 บAutor  ณMicrosiga           บ Data ณ  09/27/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fDeletaItens(cKey)

 Local aOld := GETAREA()
 
 dbSelectArea( "ZT5" )
 dbSeek( cKey )
 Do While !(ZT5->(Eof())) .And. ZT5->(ZT5_FILIAL+ZT5_CODIGO+ZT5_PERIOD+ZT5_TIPBEN+ZT5_ANO+ZT5_MES ) ==  cKey 
    RecLock("ZT5",.F.)
     dbDelete()
    MsUnLock()
    dbSkip()
 EndDo
 
 RESTAREA( aOld )	

Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BNGPEA03 บAutor  ณMicrosiga           บ Data ณ  09/27/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fPosIncl( nReg )

ZT4->( dbGoBottom() )
ZT4->( dbSkip() )
nReg := 0

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BNGPEA03 บAutor  ณMicrosiga           บ Data ณ  09/27/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fNewAcols(dDataIni, dDataFim, cCompet )

Local cAliasZT5	:= "ZT5"
Local nPrim_Dia	:= Day( dDataIni )
Local nUlt_Dia  := Day( dDataFim ) 
Local nDias 	:= dDataFim - dDataIni + 1		//Max( (nUlt_dia - nPrim_Dia ) + 1 ,0 ) 
Local nTam		:= Len( aHeader ) + 1 
Local dData		:= CtoD("//") 
Local aAReaZT4	:= ZT4->(GetArea()) 
Local aNotFields:= { "ZT5_FILIAL", "ZT5_CODIGO", "ZT5_ANO", "ZT5_MES", "ZT5_PERIOD", "ZT5_TIPBEN" }
Local nCnt		:= 0
Local cTipSem   := ""
//Local aFeriados := {}
//Local nPosFer   := 0
//Local cMesDia
//Local cQuery

Local nPosData  := GdFieldPos( "ZT5_DATA"  ,aHeader )
Local nPosDesc  := GdFieldPos( "ZT5_DESC"  ,aHeader )
Local nPosTpDia := GdFieldPos( "ZT5_TPDIA" ,aHeader )
Local nPosVT    := GdFieldPos( "ZT5_VT"    ,aHeader )
Local nPosDVT   := GdFieldPos( "ZT5_DVT"   ,aHeader )
Local nPosVR    := GdFieldPos( "ZT5_VR"    ,aHeader )
Local nPosVA    := GdFieldPos( "ZT5_VA"    ,aHeader )

M->ZT5_CODIGO := M->ZT4_CODIGO
M->ZT5_PERIOD := M->ZT4_PERIOD
M->ZT5_TIPBEN := M->ZT4_TIPBEN
M->ZT5_ANO    := M->ZT4_ANO
M->ZT5_MES    := M->ZT4_MES

// Monta Array com os Feriados
//cQuery := " SELECT SP3.P3_DATA, SP3.P3_MESDIA"
//cQuery += " FROM " + RetSqlName( "SP3" ) + " SP3"
//cQuery += " WHERE SP3.D_E_L_E_T_ <> '*'"
//cQuery += "   AND SP3.P3_DATA BETWEEN '" + Dtos( dDataIni ) + "' AND '" + Dtos( dDataFim ) + "'"
//cQuery += " UNION"
//cQuery += " SELECT SP3.P3_DATA, SP3.P3_MESDIA"
//cQuery += " FROM " + RetSqlName( "SP3" ) + " SP3"
//cQuery += " WHERE SP3.D_E_L_E_T_ <> '*'"
//cQuery += "   AND SP3.P3_FIXO = 'S'"

//TCQuery cQuery New Alias "WSP3"
//TcSetField( "WSP3" , "P3_DATA" , "D" , 08 , 00 )
//dbSelectArea( "WSP3" )
//dbGoTop()
//Do While !Eof()
//   Aadd(aFeriados,{WSP3->P3_DATA, WSP3->P3_MESDIA})
//   dbSkip()
//EndDo
//WSP3->(dbCloseArea())

aColsAux := Array(nDias, nTam )

For nCnt := 1 To nDias
    nUsado := 0
    If nCnt == 1
       dData := CtoD(Strzero(nPrim_Dia,2) + "/" + Substr(cCompet,5,2) + "/" + Substr(cCompet,1,4)  ,"DDMMYY")
    Else
       dData := dData + 1
    EndIf

    If     Dow( dData  ) == 1		; cTipSem := ZT3->ZT3_DOM
    ElseIf Dow( dData  ) == 2		; cTipSem := ZT3->ZT3_SEG
    ElseIf Dow( dData  ) == 3		; cTipSem := ZT3->ZT3_TER
    ElseIf Dow( dData  ) == 4		; cTipSem := ZT3->ZT3_QUA
    ElseIf Dow( dData  ) == 5		; cTipSem := ZT3->ZT3_QUI
    ElseIf Dow( dData  ) == 6		; cTipSem := ZT3->ZT3_SEX
    ElseIf Dow( dData  ) == 7		; cTipSem := ZT3->ZT3_SAB
    EndIf
    
    // Verifica se o Dia eh Feriado
    //If ( nPosFer := Ascan(aFeriados,{|x| x[1]==dData}) ) > 0
    //   cTipSem := "4"
    //Else
    //   cMesDia := StrZero(Month( dData ),2) + StrZero(Day( dData ),2)
    //   If ( nPosFer := Ascan(aFeriados,{|x| x[2]==cMesDia}) ) > 0
    //      cTipSem := "4"
    //   EndIf
    //EndIf

    dbSelectArea( "SX3" )
    dbSetOrder( 1 )
    dbSeeK( "ZT5" )
    Do While !Eof() .And. SX3->X3_ARQUIVO == cAliasZT5 
       If X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL  .And. !Ascan(aNotFields,AllTrim(SX3->X3_CAMPO)) > 0
          nUsado++
          If SX3->X3_CAMPO = "ZT5_DATA"
             aColsAux[nCnt,nPosData] := dData	// Dia do Mes 
          ElseIf SX3->X3_CAMPO = "ZT5_DESC"
             cRet := GPEDiaSem( dData )			// Descricao do dia da Semana
             aColsAux[nCnt,nPosDesc] := cRet
          ElseIf SX3->X3_CAMPO = "ZT5_TPDIA"
             cRet := cTipSem					// 1=Trabalhado;2=Nao Trabalhado;3=Dsr;4=Feriado	
             aColsAux[nCnt,nPosTpDia] := cRet							
          ElseIf SX3->X3_CAMPO = "ZT5_VT"		// Utiliza Vale Transporte (1=sim; 2=Nao)
             If M->ZT4_TIPBEN == "1"
                If cTipSem == "1"
                   aColsAux[nCnt,nPosVT] := "1"
                Else
                   aColsAux[nCnt,nPosVT] := "2"
                EndIf
             EndIf
          ElseIf SX3->X3_CAMPO = "ZT5_DVT"		// Dif de Vale Transporte (1=sim; 2=Nao) 
             If M->ZT4_TIPBEN == "1"
                If cTipSem == "1"
                   aColsAux[nCnt,nPosDVT] := "1"
                Else
                   aColsAux[nCnt,nPosDVT] := "2"
                EndIf	
             EndIf	
          ElseIf SX3->X3_CAMPO = "ZT5_VR"		// Utiliza Vale Refeicao (1=sim; 2=Nao)
             If M->ZT4_TIPBEN == "2"
                If cTipSem == "1"
                   aColsAux[nCnt,nPosVR] := "1"
                Else
                   aColsAux[nCnt,nPosVR] := "2"
                EndIf						
             EndIf						
          ElseIf SX3->X3_CAMPO = "ZT5_VA"		// Utiliza Vale Alimentacao (1=sim; 2=Nao)
             If M->ZT4_TIPBEN == "3"
                If cTipSem == "1"
                   aColsAux[nCnt,nPosVA] := "1"
                Else
                   aColsAux[nCnt,nPosVA] := "2"
                EndIf						
             EndIf						
          Else	
             aColsAux[nCnt,nUsado] := &(cAliasZT5+"->"+SX3->X3_CAMPO)
          EndIf
       EndIf	
       
       dbSkip()
    EndDo
    aColsAux[nCnt,nTam] := .F.  														//-- Se Linha Deletada 
Next 

RestArea( aAreaZT4 )

Return( aClone(aColsAux) ) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BNGPEA03 บAutor  ณMicrosiga           บ Data ณ  09/27/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function GPEDiaSem(dData)
 
 Local aDias := {}
 
 Aadd(aDias,OemToAnsi( "Domingo"       ))
 Aadd(aDias,OemToAnsi( "Segunda-Feira" ))
 Aadd(aDias,OemToAnsi( "Ter็a-Feira"   ))
 Aadd(aDias,OemToAnsi( "Quarta-Feira"  ))
 Aadd(aDias,OemToAnsi( "Quinta-Feira"  ))
 Aadd(aDias,OemToAnsi( "Sexta-Feira"   ))
 Aadd(aDias,OemToAnsi( "Sแbado"        ))

Return( aDias[Dow(dData)] )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BNGPEA03 บAutor  ณMicrosiga           บ Data ณ  09/27/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function RetTipoDia( dDataRef ) 

 Local cRet := "1" 		//- Tipo do Dia (1=Trabalhado;2=Nao Trabalhado;3=DSR;4=Feriado

 If Dow( dDataRef ) == 1
    cRet := "3"
 ElseIf Dow( dDataRef ) == 7
    cRet := "2"
 Endif

Return( cRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BNGPEA03 บAutor  ณMicrosiga           บ Data ณ  09/27/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
User Function fCDias( cCampo , cValor )

Local nPosData	:=  0
Local nPosTpDia	:=  0
Local nPosVT	:=  0
Local nPosDVT	:=  0
Local nPosVR	:=  0
Local nDiasVT	:=  0 
Local nDiasDVT	:=  0
Local nDiasVR	:=  0 
Local nDiasVA	:=  0 

If ValType(oEnchoice) = "O" .and. ValType(oGetDados) = "O" 

   nPosData  := GdFieldPos( "ZT5_DATA"  , aHeader )	
   nPosTpDia := GdFieldPos( "ZT5_TPDIA" , aHeader )		// Tipo do Dia
   nPosVT    := GdFieldPos( "ZT5_VT"    , aHeader )		// Dia de Utilizacao de VT
   nPosDVT   := GdFieldPos( "ZT5_DVT"   , aHeader )		// Dias de Dif de Vale Transporte
   nPosVR    := GdFieldPos( "ZT5_VR"    , aHeader )		// Dias de Vale Refeicao
   nPosVA    := GdFieldPos( "ZT5_VA"    , aHeader )		// Dias de Vale Alimentacao

   //Atualiza aCols com novos Valores p/ calcular
   If cCampo == "ZT5_TPDIA"
      aCols[oGetDados:oBrowse:nAt,nPosTpDia] := cValor 
      If M->ZT4_TIPBEN == "1"
         aCols[oGetDados:oBrowse:nAt,nPosVT]  := If(cValor $ "1/2",cValor,"2") //-- Atualiza  o Valor do Vale Transporte 	
      EndIf
      If M->ZT4_TIPBEN == "2"
         aCols[oGetDados:oBrowse:nAt,nPosVR]  := If(cValor $ "1/2",cValor,"2") //-- Atualiza  o Valor do Vale Refeicao
      EndIf
      If M->ZT4_TIPBEN == "3"
         aCols[oGetDados:oBrowse:nAt,nPosVA]  := If(cValor $ "1/2",cValor,"2") //-- Atualiza  o Valor do Vale Alimentacao
      EndIf
   ElseIf cCampo =="ZT5_VT"
      If M->ZT4_TIPBEN == "1"
         aCols[oGetDados:oBrowse:nAt,nPosVT]  := cValor 
         aCols[oGetDados:oBrowse:nAt,nPosDVT] := cValor
         //aCols[oGetDados:oBrowse:nAt,nPosVR]  := cValor
         //aCols[oGetDados:oBrowse:nAt,nPosVA]  := cValor
      EndIf
   ElseIf cCampo =="ZT5_DVT"
      If M->ZT4_TIPBEN == "1"
         aCols[oGetDados:oBrowse:nAt,nPosDVT] := cValor
      EndIf
   ElseIf cCampo =="ZT5_VR" 
      If M->ZT4_TIPBEN == "2"
         aCols[oGetDados:oBrowse:nAt,nPosVR]  := cValor
      EndIf
   ElseIf cCampo =="ZT5_VA" 
      If M->ZT4_TIPBEN == "3"
         aCols[oGetDados:oBrowse:nAt,nPosVA]  := cValor
      EndIf
   EndIf
   oGetDados:oBrowse:Refresh(.T.)

   //Efetua a Somatoria
   If M->ZT4_TIPBEN == "1"
      Aeval(aCols,{|x,y| nDiasVT += If(aCols[y,nPosVT] == "1", 1, 0)})
      Aeval(aCols,{|x,y| nDiasDVT += If(aCols[y,nPosDVT] == "1", 1, 0)})
      M->ZT4_DVT  := nDiasVT		// Dias Uteis V.T. 
      M->ZT4_DDVT := nDiasDVT		// Dias de Dif. Vale Transporte
   EndIf
   
   If M->ZT4_TIPBEN == "2"
      Aeval(aCols,{|x,y| nDiasVR += If(aCols[y,nPosVR] == "1", 1, 0)})
      M->ZT4_DVR := nDiasVR		// Dias de Vale Refeicao
   EndIf

   If M->ZT4_TIPBEN == "3"
      Aeval(aCols,{|x,y| nDiasVA += If(aCols[y,nPosVA] == "1", 1, 0)})
      M->ZT4_DVA := nDiasVA		// Dias de Vale Alimentacao
   EndIf
   
   oEnchoice:Refresh()

EndIf

Return( .T. ) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BNGPEA03 บAutor  ณMicrosiga           บ Data ณ  09/27/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
User Function fVldDtIni( dDtIni, dDtFim, cMes, cAno )

Local cAnoMesI	:= MesAno( dDtIni )
Local cAnoMesX	:= cAno+cMes
Local lEscMSeg  := GETMV( "GP_ESCMSEG",,"N" ) == "S"

/* 
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
ณValidacao do Campo Data Inicial                                                    |
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
If NaoVazio()
   If !lEscMSeg
      If !Empty(dDtIni)  .and.  cAnoMesX # cAnoMesI 
         Help(" ",1,"PERIMCOMPA")  		//Periodo digitado esta incompativel com  a Competencia ( Mes/Ano) informado.
         Return( .F. )
      Endif	
   Endif	
   If !Empty(dDtFim)  .and.  dDtIni > dDtFim 
      Help(" ",1,"DATA2INVAL")
      Return( .F. )
   Endif	
Endif

Return( .T. )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BNGPEA03 บAutor  ณMicrosiga           บ Data ณ  09/27/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
User Function fVldDtFim( dDtIni, dDtFim, cMes, cAno ) 

Local cAlias 	:= Alias()
Local cAnoMesF	:= MesAno( dDtFim )        
Local cAnoMesX	:= cAno+cMes
Local lEscMSeg  := GETMV( "GP_ESCMSEG",,"N" ) == "S"

If NaoVazio() .And. !Empty( dDtFim )
   If !lEscMSeg
      If cAnoMesX < cAnoMesF 
         Help(" ",1,"PERIMCOMPA")  		//Periodo digitado esta incompativel com  a Competencia ( Mes/Ano) informado.
         Return( .F. )
      EndIf
   EndIf
   If dDtFim < dDtIni
      Help(" ",1,"DATA2INVAL")
      Return( .F. ) 
   Endif
Endif
dbSelectArea( cAlias )

Return( .T. ) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BNGPEA03 บAutor  ณMicrosiga           บ Data ณ  09/27/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function MontaCalend( nOpc )

Local aLstEnchoice	:= aClone( aColsEnCho )
Local lRet			:= .T.

If nOpc == 3 .And. !fValidData()
   oEnChoice:SetFocus()
   oEnChoice:Refresh()
   Return( .F. )
EndIf

Begin Sequence

	//--Atualizar a DataIni e DataFim par comparacao	
	GdFieldPut( "ZT4_DTINI" 	,;
				GdFieldGet( "ZT4_DTINI" , 1 , .F. , aEnchoice , aColsEnCho ) ,;
				1				,;
				aEnchoice		,;
				aLstEnchoice	,;
			   )

	GdFieldPut( "ZT4_DTFIM" 	,;
				GdFieldGet( "ZT4_DTFIM" , 1 , .F. , aEnchoice , aColsEnCho ) ,;
				1				,;
				aEnchoice		,;
				aLstEnchoice	,;
			   )

	//--SALVA VARIAVEL DE MEMORIA EM ARRAY PARA COMPRAR SE HOUVE ALTERACAO
	GdFieldPut( "ZT4_DTINI" 	,;
				M->ZT4_DTINI	,;
				1				,;
				aEnchoice		,;
				aColsEnCho	,;
			   )

	GdFieldPut( "ZT4_DTFIM" 	,;
				M->ZT4_DTFIM	,;
				1				,;
				aEnchoice		,;
				aColsEnCho	,;
			   )

	//--Compara DataIni e DataFim e Verifica se Houve alteracao
	
	IF (;
			GdFieldGet( "ZT4_DTINI"  , 1 , .F. , aEnchoice , aColsEnCho ) == GdFieldGet( "ZT4_DTINI"  , 1 , .F. , aEnchoice , aLstEnchoice ) .and.	;
			GdFieldGet( "ZT4_DTFIM"  , 1 , .F. , aEnchoice , aColsEnCho ) == GdFieldGet( "ZT4_DTFIM"  , 1 , .F. , aEnchoice , aLstEnchoice )	   	;
		)			
		Break
	EndIF

	IF !( lRet := Obrigatorio( oEnchoice:aGets , oEnchoice:aTela ) )
		Break
	EndIF

	IF !( lRet := EnchoTudOk( oEnchoice ) )
		Break
	EndIF

	/* 
	ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	ณ Monta aCols com os dados de acordo com   competencia  e periodo Desejado          ณ
	ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
 	MsgRun(OemToAnsi("Montando Calendario ..."),OemToAnsi("Aguarde"),{|| aCols	:= fNewAcols( M->ZT4_DTINI, M->ZT4_DTFIM , M->ZT4_ANO+M->ZT4_MES )})
	aSvCols	:= aClone( aCols )
	oGetDados:oBrowse:nAt
	oGetDados:oBrowse:Refresh(.T.)
	
	/*
	ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	ณ Calcula os valores de Dias Trab/DSR/V.T./V.F                 ณ
	ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
	U_fCDias()

End Sequence
	
Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BNGPEA03 บAutor  ณMicrosiga           บ Data ณ  09/27/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fValidData()

 Local aOld    := GETAREA()
 Local nZT4Ord := ZT4->(IndexOrd())
 Local nZT4Rec := ZT4->(Recno())
 Local lRet    := .T.
 
 ZT4->(dbSetOrder( 1 ))

 // Valida Digitacao do Ano de Referencia
 If Empty( M->ZT4_ANO )
    Aviso( "ATENCAO", "Ano de Referencia Nใo Informado!!",{"Voltar"})
    lRet := .F.
 EndIf

 // Valida Digitacao do Mes de Referencia
 If lRet .And. Empty( M->ZT4_MES )
    Aviso( "ATENCAO", "Mes de Referencia Nใo Informado!!",{"Voltar"})
    lRet := .F.
 EndIf

 If lRet .And. ZT4->(dbSeek( xFilial("ZT4") + M->ZT4_CODIGO + M->ZT4_ANO + M->ZT4_MES ))
    Aviso( "ATENCAO", "Calendแrio Jแ Cadastrado!!",{"Voltar"})
    lRet := .F.
 EndIf
 
 ZT4->(dbSetOrder( nZT4Ord ))
 ZT4->(dbGoTo( nZT4Rec ))
 RESTAREA( aOld )

Return( lRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ BNGPEA03 บAutor  ณMicrosiga           บ Data ณ  10/10/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fSelRadio(nRet, cTitJan, cTitBox, cTitRad1, cTitRad2, cTitRad3)

 Local nOpcAux
 Local oRadio
 Local oDlg
 Local oGroup
 Local oFont

 nOpcAux := nRet
 nRet    := 0

 DEFINE FONT oFont NAME "Arial" SIZE 0,-11 BOLD
 DEFINE MSDIALOG oDlg FROM  094,001 TO 245,280 TITLE OemToAnsi(cTitJan) PIXEL

 @ 005,005 GROUP oGroup TO 055,135 LABEL OemToAnsi(cTitBox) OF oDlg PIXEL
 oGroup:oFont:=oFont

 @ 020,010 RADIO oRadio VAR nOpcAux ITEMS 	OemToAnsi(cTitRad1), OemToAnsi(cTitRad2), OemToAnsi(cTitRad3) SIZE 115,010 OF oDlg PIXEL

 DEFINE SBUTTON FROM 60, 070 TYPE 1 ENABLE OF oDlg ACTION ( nRet := nOpcAux, oDlg:End() )
 DEFINE SBUTTON FROM 60, 105 TYPE 2 ENABLE OF oDlg ACTION ( nRet := 0,       oDlg:End() )

 ACTIVATE MSDIALOG oDlg CENTERED

Return( nRet )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBNGPEA03  บAutor  ณMicrosiga           บ Data ณ  10/23/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP11                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function x03Replic()

 Local aOldAtu := GETAREA()
 Local aTipos  := {}
 Local aTabZt4 := {}
 Local aTabZt5 := {}
 Local cChave  := ""
 Local nDias   := 0
 Local nX, nY
  
 If Aviso("ATENCAO","Confirma replica deste calendแrio para os demais benefํcios?",{"Nใo","Sim"}) == 1
    Return
 EndIf
 
 ZT4->(dbSetOrder( 1 ))		// ZT4_FILIAL+ZT4_CODIGO+ZT4_PERIOD+ZT4_TIPBEN+ZT4_ANO+ZT4_MES
 ZT5->(dbSetOrder( 1 ))		// ZT5_FILIAL+ZT5_CODIGO+ZT5_PERIOD+ZT5_TIPBEN+ZT5_ANO+ZT5_MES+DTOS(ZT5_DATA)
 
 cChave  := ZT4->(ZT4_FILIAL+ZT4_CODIGO+ZT4_PERIOD+ZT4_TIPBEN+ZT4_ANO+ZT4_MES)
 Aadd(aTabZt4,{ZT4->ZT4_FILIAL,			; // 01 - Filial
               ZT4->ZT4_CODIGO,			; // 02 - Codigo
               ZT4->ZT4_TIPBEN,			; // 03 - Tipo Beneficio	1=Vale Transporte - 2=Refeicao - 3=Alimentacao
               ZT4->ZT4_PERIOD,			; // 04 - Periodo
               ZT4->ZT4_MES,			; // 05 - Mes
               ZT4->ZT4_ANO,			; // 06 - Ano
               ZT4->ZT4_DTINI,			; // 07 - Data Inicio do Periodo
               ZT4->ZT4_DTFIM}			) // 08 - Data Termino do Periodo
               
 nDias  := ZT4->ZT4_DVT
 aTipos := {"2","3"}
 If ZT4->ZT4_TIPBEN == "2"
    nDias  := ZT4->ZT4_DVR
    aTipos := {"1","3"}
 ElseIf ZT4->ZT4_TIPBEN == "3"
    nDias  := ZT4->ZT4_DVA
    aTipos := {"1","2"}
 EndIf
 
 dbSelectArea( "ZT5" )
 dbSeek( cChave )
 Do While !Eof() .And. ZT5_FILIAL+ZT5_CODIGO+ZT5_PERIOD+ZT5_TIPBEN+ZT5_ANO+ZT5_MES == cChave
    Aadd(aTabZt5,{ZT5->ZT5_FILIAL,			; // 01 - Filial
                  ZT5->ZT5_CODIGO,			; // 02 - Codigo
                  ZT5->ZT5_TIPBEN,			; // 03 - Tipo Beneficio	1=Vale Transporte - 2=Refeicao - 3=Alimentacao
                  ZT5->ZT5_PERIOD,			; // 04 - Periodo de Apuracao
                  ZT5->ZT5_MES,				; // 05 - Mes
                  ZT5->ZT5_ANO,				; // 06 - Ano
                  ZT5->ZT5_DATA,			; // 07 - Data
                  ZT5->ZT5_DESC,			; // 08 - Descricao da Semana
                  ZT5->ZT5_TPDIA,			; // 09 - Tipo do Dia
                  ZT5->ZT5_VT,	  			; // 10 - VT (Sim/Nao)
                  ZT5->ZT5_DVT,	   			; // 11 - Diferenca de VT (Sim/Nao)
                  ZT5->ZT5_VR,     		  	; // 12 - VR (Sim/Nao)
                  ZT5->ZT5_VA}				) // 13 - VA (Sim/Nao)

    If ZT5->ZT5_TIPBEN == "1"
       aTabZt5[Len(aTabZt5),10] := ZT5->ZT5_VT
       aTabZt5[Len(aTabZt5),11] := ZT5->ZT5_VT
       aTabZt5[Len(aTabZt5),12] := ZT5->ZT5_VT
       aTabZt5[Len(aTabZt5),13] := ZT5->ZT5_VT
    ElseIf ZT5->ZT5_TIPBEN == "2"
       aTabZt5[Len(aTabZt5),10] := ZT5->ZT5_VR
       aTabZt5[Len(aTabZt5),11] := ZT5->ZT5_VR
       aTabZt5[Len(aTabZt5),12] := ZT5->ZT5_VR
       aTabZt5[Len(aTabZt5),13] := ZT5->ZT5_VR
    ElseIf ZT5->ZT5_TIPBEN == "3"
       aTabZt5[Len(aTabZt5),10] := ZT5->ZT5_VA
       aTabZt5[Len(aTabZt5),11] := ZT5->ZT5_VA
       aTabZt5[Len(aTabZt5),12] := ZT5->ZT5_VA
       aTabZt5[Len(aTabZt5),13] := ZT5->ZT5_VA
    EndIf

    dbSkip()
 EndDo
 
 For nX := 1 To Len( aTipos )
     dbSelectArea( "ZT4" )
     For nY := 1 To Len( aTabZt4 )
         cChave  := aTabZt4[nY,01]+aTabZt4[nY,02]+aTabZt4[nY,04]+aTipos[nX]+aTabZt4[nY,06]+aTabZt4[nY,05]
         If !dbSeek( cChave )
            RecLock("ZT4",.T.)
         Else
            RecLock("ZT4",.F.)
         EndIf
          ZT4->ZT4_FILIAL := aTabZt4[nY,01]
          ZT4->ZT4_CODIGO := aTabZt4[nY,02]
          ZT4->ZT4_TIPBEN := aTipos[nX]
          ZT4->ZT4_PERIOD := aTabZt4[nY,04]
          ZT4->ZT4_MES    := aTabZt4[nY,05]
          ZT4->ZT4_ANO    := aTabZt4[nY,06]
          ZT4->ZT4_DTINI  := aTabZt4[nY,07]
          ZT4->ZT4_DTFIM  := aTabZt4[nY,08]
          If aTipos[nX] == "1"
             ZT4->ZT4_DVT    := nDias
             ZT4->ZT4_DDVT   := nDias
          ElseIf aTipos[nX] == "2"
             ZT4->ZT4_DVR    := nDias
          ElseIf aTipos[nX] == "3"
             ZT4->ZT4_DVA    := nDias
          EndIf
         MsUnlock()
     Next nY

     dbSelectArea( "ZT5" )
     For nY := 1 To Len( aTabZt5 )
         cChave  := aTabZt5[nY,01]+aTabZt5[nY,02]+aTabZt5[nY,04]+aTipos[nX]+aTabZt5[nY,06]+aTabZt5[nY,05]+Dtos(aTabZt5[nY,07])
         If !dbSeek( cChave )
            RecLock("ZT5",.T.)
         Else
            RecLock("ZT5",.F.)
         EndIf
          ZT5->ZT5_FILIAL := aTabZt5[nY,01]
          ZT5->ZT5_CODIGO := aTabZt5[nY,02]
          ZT5->ZT5_TIPBEN := aTipos[nX]
          ZT5->ZT5_PERIOD := aTabZt5[nY,04]
          ZT5->ZT5_MES    := aTabZt5[nY,05]
          ZT5->ZT5_ANO    := aTabZt5[nY,06]
          ZT5->ZT5_DATA   := aTabZt5[nY,07]
          ZT5->ZT5_DESC   := aTabZt5[nY,08]
          ZT5->ZT5_TPDIA  := aTabZt5[nY,09]
          If aTipos[nX] == "1"
             ZT5->ZT5_VT  := aTabZt5[nY,10]
             ZT5->ZT5_DVT := aTabZt5[nY,11]
          ElseIf aTipos[nX] == "2"
             ZT5->ZT5_VR  := aTabZt5[nY,12]
          ElseIf aTipos[nX] == "3"
             ZT5->ZT5_VA  := aTabZt5[nY,13]
          EndIf
         MsUnlock()
     Next nY
 Next nX

 RESTAREA( aOldAtu )
 
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณVALIDPERG บ Autor ณ AP5 IDE            บ Data ณ  27/10/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Verifica a existencia das perguntas criando-as caso seja   บฑฑ
ฑฑบ          ณ necessario (caso nao existam).                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fAsrPerg()

Local aRegs := {}
Local Fi    := FWSizeFilial()

 // Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
 aAdd(aRegs,{ cPerg,'01','Competencia De (MMAAAA) ?     ','','','mv_ch1','C',06,0,0,'G','            ','mv_par01',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'      ','' })
 aAdd(aRegs,{ cPerg,'02','Competencia Ate (MMAAAA) ?    ','','','mv_ch2','C',06,0,0,'G','            ','mv_par02',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'      ','' })
 aAdd(aRegs,{ cPerg,'03','Periodo  ?                    ','','','mv_ch3','C',01,0,0,'G','            ','mv_par03',''                 ,'','','','',''                 ,'','','','',''                    ,'','','','',''                 ,'','','','',''      ,'','','' ,'      ','' })
 U_fDelSx1( cPerg, "04" )

ValidPerg(aRegs,cPerg)

Return   
