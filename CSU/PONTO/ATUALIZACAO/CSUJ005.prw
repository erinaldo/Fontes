#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � CSUJ005  �Autor  � Silvano Franca     � Data �  17/12/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Monitor de exportacoes de absenteismo                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CSUJ005() 
Private nUsado     := 0
Private cCadastro  := 'Monitor Interface Exporta��o de Absenteismo'
Private aRotina    := {} 
Private aCores     := {} 
Private cPula      := Chr( 13 ) + Chr( 10 ) 
Private oTimer     := NIL
Private cFilPAA    := ''
Private cFilPAB    := ''

//aAdd( aRotina , { 'Pesquisar'   , 'AxPesqui'     , 0, 1 } )
aAdd( aRotina , { 'Visualizar'  , 'u_PAAVisual'  , 0, 2 } )
aAdd( aRotina , { 'Legenda'     , 'u_PAALegend'  , 0, 2 } )

dbSelectArea( 'PAB' ) 
dbSetOrder( 1 ) 
cFilPAB := xFilial( 'PAB' ) 

dbSelectArea( 'PAA' ) 
dbSetOrder( 1 ) 
cFilPAA := xFilial( 'PAA' ) 

dbSelectArea( 'PAA' ) 
mBrowse( ,,,, 'PAA',, 'PAA_STATUS=="2"',,,,,,,, { | x | u_PAATimer( @oTimer, x ) } ) 
Return NIL


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � PAAVISUAL�Autor  � Silvano Franca     � Data �  17/12/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina para visualizacao do cadastro                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PAAVisual( cAlias, nRecNo, nOpc ) 
Local   nX        := 0
Local   nCols     := 0
Local   nOpcTela  := 0
Local   cChave    := ''
Local   bCampo    := { | nField | Field( nField ) } 
Private oGet      := NIL
Private aHeader   := {} 
Private aCols     := {} 
Private aTela     := {} 
Private aGets     := {} 

/*
������������������������������������������������������������������������������������������������������������������������������������Ŀ
�Inicia as variaveis para enchoice																									 �
��������������������������������������������������������������������������������������������������������������������������������������
*/
dbSelectArea( 'PAA' ) 
dbSetOrder( 1 ) 
dbGoTo( nRecNo ) 
cChave := PAA->PAA_ID

For nX := 1 To FCount() 
	M->&( EVal( bCampo, nX ) ):= FieldGet( nX ) 
Next nX

/*
������������������������������������������������������������������������������������������������������������������������������������Ŀ
�Monta aHeader                   																									 �
��������������������������������������������������������������������������������������������������������������������������������������
*/
CriaHeader() 

/*
������������������������������������������������������������������������������������������������������������������������������������Ŀ
�Monta o aCols dos itens         																									 �
��������������������������������������������������������������������������������������������������������������������������������������
*/
dbSelectArea( 'PAB' ) 
dbSetOrder( 1 ) 
dbSeek( cFilPAB + cChave ) 

While !EOF() .AND. ( cFilPAB + cChave ) == PAB->( PAB_FILIAL + PAB->PAB_ID ) 
	aAdd( aCols, Array( nUsado + 1 ) ) 
	nCols++ 
	
	For nX := 1 To nUsado
		If ( aHeader[nX][10] != 'V' ) 
			aCols[nCols][nX] := FieldGet( FieldPos( aHeader[nX][2] ) ) 
		Else
			aCols[nCols][nX] := CriaVar( aHeader[nX][2], .T. ) 
		EndIf
	Next nX
	
	aCols[nCols][nUsado + 1] := .F.
	dbSelectArea( 'PAB' ) 
	dbSkip() 
End

PAATela( cAlias, nRecNo, nOpc, cCadastro, aCols, aHeader ) 

Return NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    �CriaHeader�Autor  � Silvano Franca     � Data �  17/12/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina para criacao do aHeader                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CriaHeader() 
nUsado  := 0
aHeader := {} 

dbSelectArea( 'SX3' ) 
dbSetOrder( 1 ) 
dbSeek( 'PAB' ) 
While ( !EOF() .AND. SX3->X3_ARQUIVO == 'PAB' ) 
	If ( X3USO( SX3->X3_USADO ) .AND. cNivel >= SX3->X3_NIVEL ) 
		aAdd( aHeader, { Trim( X3Titulo() ) , ;
		SX3->X3_CAMPO   , ;
		SX3->X3_PICTURE , ;
		SX3->X3_TAMANHO , ;
		SX3->X3_DECIMAL , ;
		SX3->X3_VALID   , ;
		SX3->X3_USADO   , ;
		SX3->X3_TIPO    , ;
		SX3->X3_ARQUIVO , ;
		SX3->X3_CONTEXT } ) 
		nUsado++ 
	EndIf
	dbSkip() 
End

Return NIL


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � PaaLinOk �Autor  � Silvano Franca     � Data �  17/12/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina para validacao da Linha da GetDados                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PAALinOk() 
Local aArea    := GetArea() 
Local aAreaSX3 := SX3->( GetArea() ) 
//Local cMsg     := ''
Local lRet     := .T.
//Local nI       := 0

RestArea( aAreaSX3 ) 
RestArea( aArea ) 

Return lRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � PaaCanDel�Autor  � Silvano Franca     � Data �  17/12/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina para validacao da Linha da GetDados                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PAACanDel() 
Local aArea    := GetArea() 
Local aAreaSX3 := SX3->( GetArea() ) 
//Local cMsg     := ''
Local lRet     := .T.
//Local nI       := 0
Local nPosOri := aScan( aHeader, { | X | AllTrim( x[2] ) == 'PAB_ORIGEM' } ) 
Static lFirst  := .T.
Static lret2   := .T.

If !lFirst
	lFirst  := .T.
	Return lRet2
EndIf

//.....

RestArea( aAreaSX3 ) 
RestArea( aArea ) 

If lFirst
	lFirst  := .F.
EndIf
Return lRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � PaaTudOk �Autor  � Silvano Franca     � Data �  17/12/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina para validacao da Geral da GetDados                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Importacao/Exportacao de Tabelas                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PAATudOk() 
Local aArea      := GetArea() 
Local aAreaPAA   := PAA->( GetArea() ) 
Local lRet       := .T.
//Local cMsg       := ''
//Local nCount     := 0
//Local nI         := 0


//...

RestArea( aAreaPAA ) 
RestArea( aArea   ) 

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � PaaLegend�Autor  � Silvano Franca     � Data �  17/12/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina para exibicao da legenda                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PAALegend() 
Local aCores := { ;
 { 'BR_VERDE'     , 'Processo Ok'     } , ;
 { 'BR_VERMELHO'  , 'Processo N�o OK' } } 

BrwLegenda( cCadastro, 'Legenda', aCores ) //'Legenda'

Return NIL


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � PaaTela  �Autor  � Silvano Franca     � Data �  17/12/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina para montagek da tela da Enchoice /Getdados         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function PAATela( cAlias, nRecNo, nOpc, cCadastro, aCols, aHeader ) 
Local lOpcA    := .F.
Local oDlg     := NIL
Local aButtons := {} 
Local oGetD    := NIL
Local lSoExibe := ( nOpc == 2 .OR. nOpc == 5 ) 
Local aSize    := {} 
Local aObjects := {} 
Private oGet

aSize   := MsAdvSize() 
aAdd( aObjects, { 100, 030, .T., .T. } ) 
aAdd( aObjects, { 100, 070, .T., .T. } ) 
aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 } 
aPosObj := MsObjSize( aInfo, aObjects, .T. ) 

Define Font oFontBold  Name 'Arial' Size 0, -11 Bold
Define MsDialog oDlg Title cCadastro From aSize[7], 0 To aSize[6], aSize[5]  Of oMainWnd Pixel

Enchoice( cAlias, nRecNo, nOpc,,,,, aPosObj[1],, 3 ) 
oGetD := MsGetDados():New( aPosObj[2, 1], aPosObj[2, 2], aPosObj[2, 3], aPosObj[2, 4], nOpc, 'u_PAALinOk() ', 'u_PAATudOk() ', '', .T.,,,,,,,, 'u_PAACanDel() ', ) 

If lSoExibe
	Activate MsDialog oDlg Centered On Init EnchoiceBar( oDlg, { || lOpcA := .T., IIf( oGetD:TudoOk() , oDlg:End() , lOpcA := .F. ) } , { || oDlg:End() } ) 
Else
	Activate MsDialog oDlg Centered On Init EnchoiceBar( oDlg, { || lOpcA := .T., IIf( oGetD:TudoOk() .AND. u_PAATudok() .AND. u_PAALinok() .AND. Obrigatorio( aGets, aTela ) , oDlg:End() , lOpcA := .F. ) } , { || lOpcA := .F., oDlg:End() } ,, aButtons ) 
EndIf

Return lOpcA

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � PaaTimer �Autor  � Silvano Franca     � Data �  17/12/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina para montagem do Timer do mBrowse                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PAATimer( oTimer, omBrowse ) 
_nSeg := SuperGetMV( 'ES_RFSMON',, 10000 ) 
Define Timer oTimer Interval _nSeg Action RfBrowse( GetObjBrow() , oTimer ) Of omBrowse
oTimer:Activate() 
Return NIL


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � RFBrowse �Autor  � Silvano Franca     � Data �  17/12/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina para Refresh de tela chamando do timer              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function RfBrowse( oObjBrow, oTimer ) 
PAA->( dbGoBottom() )
oTimer:DeActivate()
oObjBrow:GoBottom()  
oObjBrow:Refresh() 
oTimer:Activate() 
Return NIL