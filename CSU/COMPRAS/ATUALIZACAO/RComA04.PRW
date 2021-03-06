#Include "RwMake.ch"
#include "Protheus.ch"
#include "Topconn.ch"

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  � RComA04  � Autor � Cristiano Figueiroa � Data � 25/07/2006  ���
��������������������������������������������������������������������������͹��
���Descricao � Monta a Tela de Dados Adicionais do Documento de Entrada    ���
��������������������������������������������������������������������������͹��
���Uso       � Csu CardSystem                                              ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
User Function RComA04()

/*����������������������������������������������������������������������������Ŀ
�                 Declara as Variaveis Utilizadas na Rotina                  �
������������������������������������������������������������������������������*/

Local    bCampo 	:= {|nCPO| Field(nCPO)}
Local    aArea 	    := GetArea()
Local    aAreaSE2   := SE2->( GetArea() )

Private  lClose 	:= .F.
Private  cPrefixo   := SF1->F1_PREFIXO
Private  cNum		:= SF1->F1_DUPL
Private  cEspecie   := SF1->F1_ESPECIE
Private  cParcela	:= SuperGetMV("MV_1DUP")
Private  cTipo	    := MVNOTAFIS
Private  cFornece	:= SF1->F1_FORNECE
Private  cLoja	    := SF1->F1_LOJA
Private  cRazao     := Alltrim( Posicione( "SA2" , 1 , xFilial("SA2") + cFornece + cLoja ,"A2_NOME" ) )
Private  cContFor   := Posicione("SA2", 1 , xFilial("SA2") + cFornece + cLoja , "A2_CONTA" )
Private  dEmissao   := SF1->F1_EMISSAO
Private  cHist      := Space(Len(SF1->F1_DADADIC))
Private  cCC        := CriaVar("CTT_CUSTO")
Private  cItem      := CriaVar("CTD_ITEM")
Private  cClasse    := CriaVar("CTH_CLVL")
Private  cConta     := CriaVar("CT1_CONTA")
Private  cNaturPA   := CriaVar("ED_CODIGO")
Private  nPosCC     := aScan( aHeader , { |x| Upper( Trim ( x[2] ) ) == "D1_CC" })
Private  nPosIT     := aScan( aHeader , { |x| Upper( Trim ( x[2] ) ) == "D1_ITEMCTA" })
Private  nPosCLVL   := aScan( aHeader , { |x| Upper( Trim ( x[2] ) ) == "D1_CLVL" })
Private  cPict      := PesqPict("SE2" , "E2_VALOR" , 19 )
Private  nDescCsu   := 0
Private  nMultCsu   := 0
Private  aCombo1	:= {"1=Sim","2=N�o"}
Private  cCombo1    := "2"
Private  aCombo2	:= {"1=Sim","2=N�o"}
Private  cCombo2    := "2"

//���������������������������������������Ŀ
//�VG - 2011.01.14                        �
//�Op��o de utiliza��o de tabela de rateio�
//�����������������������������������������
Private  aXCmbTR	:= {"1=Sim","2=N�o"}
Private  cXCmbTR    := "2"

Private	 aButton    := {}
Private  nReg 	    := 0
Private  nOpcE 	    := 4
Private  nOpcG 	    := 3
Private  ni 	    := 0
Private  cUniao     := GETMV("MV_UNIAO")
Private  cCofins    := GETMV("MV_COFINS")
Private  cPis       := GETMV("MV_PISNAT")
Private  cCSLL      := GETMV("MV_CSLL")
Private  cIrrf      := Substr( GetMv("MV_IRF")  , 2 , 9 )
Private  cAliasEnchoice := "SE2"
Private  cAliasGetd     := "SE2"
Private  cLinOk         := ""
Private  cTudOk         := ""
Private  cFieldOk       := "AllwaysTrue()"
Private  nOpca          := 0
Private _lTemPa		:= .F.
Private  cQuery 	:= ""
Private cPedidos := ""
Private lGravaRateio	:= .F.

/*����������������������������������������������������������������������������Ŀ
�                     Caso seja Inclusao ou Classificacao                    �
������������������������������������������������������������������������������*/

If Inclui .Or. Altera

	/*��������������������������������������������������������������Ŀ
	�             Busca a Conta Contabil do Fornecedor             �
	����������������������������������������������������������������*/
	DbSelectArea("SA2")
	DbSetOrder(1)
	
	If DbSeek( xFilial("SA2") + cFornece + cLoja )
		cConta := SA2->A2_CONTA
	EndIf
	// Verifica se h� algum PA para o PC utilizado nesta NF		** inclu�do por Daniel G.Jr. em 21/12/2007
	cQuery := "SELECT DISTINCT E2_FILIAL, E2_PREFIXO, E2_NUM, E2_PARCELA, " 
	cQuery +=        "E2_TIPO, E2_FORNECE, E2_LOJA, E2_NUMPC "
	cQuery +=   "FROM "+RetSqlName("SD1")+" SD1, "+RetSqlName("SE2")+" SE2 "
	cQuery +=  "WHERE SD1.D_E_L_E_T_<>'*' AND SE2.D_E_L_E_T_<>'*' "
	cQuery +=    "AND D1_FILIAL='"+SF1->F1_FILIAL+"' "
	cQuery +=	 "AND D1_SERIE='"+SF1->F1_SERIE+"' "
	cQuery +=    "AND D1_DOC='"+SF1->F1_DOC+"' " 
	cQuery +=    "AND D1_PEDIDO<>' ' "
	cQuery +=    "AND D1_FORNECE+D1_LOJA='"+SF1->(F1_FORNECE+F1_LOJA)+"' "
	cQuery +=    "AND D1_EMISSAO='"+DtoS(SF1->F1_EMISSAO)+"' " 
	cQuery +=    "AND E2_TIPO='PA' "
	cQuery +=    "AND E2_FORNECE=D1_FORNECE AND E2_LOJA=D1_LOJA "
	cQuery +=    "AND E2_NUMPC=D1_PEDIDO "
	cQuery +=    "AND E2_SALDO > 0 "
	cQuery := ChangeQuery(cQuery)
	
	If Select("E2PA")>0
		E2PA->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"E2PA")
	dbSelectArea("E2PA")
	E2PA->(dbGoTop())
	If E2PA->(!Eof().And.!Bof())
		_lTemPA := .T.
		cCombo2	:= "1" 
	EndIf
	
	/*����������������������������������������������������������������������������Ŀ
	�  Atribui a Tela de Informacoes Complementares o Centro de Custo , Item e   �
	�  a Classe do primeiro Item do Documento de Entrada.                        �
	������������������������������������������������������������������������������*/
	
	cCC     := aCols[1][nPosCC]
	cItem   := aCols[1][nPosIT]
	cClasse := aCols[1][nPosClvl]
	
	/*����������������������������������������������������������������������������Ŀ
	�               Nao sai da Tela enquando o usuario nao gravar                �
	������������������������������������������������������������������������������*/
	
	Do While !lClose
		
		/*����������������������������������������������������������������������������Ŀ
		�                    Monta a Tela de Dados Complementares   .                 �
		������������������������������������������������������������������������������*/
		
		Define MsDialog oDlg Title "Informa��es Complementares - Documento de Entrada" From 009 , 000 To 039 , 095 Of oMainWnd
		Define Font oFnt Name "Arial" Size 10 , 15
		
		oBmp3:= TBITMAP():Create(oDlg)
		oBmp3:cName           := "oBmp3"
		oBmp3:cCaption        := "oBmp3"
		oBmp3:nLeft           := 550
		oBmp3:nTop            := 35
		oBmp3:nWidth          := 10
		oBmp3:nHeight         := 05
		oBmp3:lShowHint       := .F.
		oBmp3:lReadOnly       := .F.
		oBmp3:Align           := 0
		oBmp3:lVisibleControl := .T.
		oBmp3:cBmpFile        := "CSU.BMP"
		oBmp3:lStretch        := .T.
		oBmp3:lAutoSize       := .T.
		
		/*����������������������������������������������������������������������������Ŀ
		�                    Exibe os Dados do Documento de Entrada                  �
		������������������������������������������������������������������������������*/
		
;		@ 015 , 005 To 070 , 372 Label OemToAnsi("Dados do Documento de Entrada") Of oDlg Pixel COLOR CLR_RED
		
		@ 015 , 270 To 070 , 372 Of oDlg Pixel COLOR CLR_RED
		
		@ 025 , 010 Get "N�mero da Nota : "     When .F. Pixel Color CLR_BLUE Size 050 , 010
		@ 025 , 055 Get (cPrefixo + "/" + cNum) When .F. Pixel Size 050 , 010
		
		@ 038 , 010 Get "Fornecedor : "         When .F. Pixel Color CLR_BLUE Size 050 , 010
		@ 038 , 055 Get (cFornece + " - " + Posicione( "SA2" , 1 , xFilial("SA2") + cFornece + cLoja , "A2_NOME" )) When .F. Pixel Size 150 , 010
		
		@ 051 , 010 Get "Data de Emissao : "    When .F. Pixel Color CLR_BLUE Size 050 , 010
		@ 051 , 055 Get dEmissao                When .F. Pixel Size 050 , 010
		
		/*����������������������������������������������������������������������������Ŀ
		�                Solicita a Digitacao dos Dados Complementares               �
		������������������������������������������������������������������������������*/
		
		@ 075 , 005 To 105 , 372 Label OemToAnsi("Informe os Dados Complementares do Titulo a Pagar - Usu�rio Respons�vel pela Entrada") Of oDlg Pixel COLOR CLR_RED
		
		@ 086 , 010 Say OemToAnsi("Rateia ?")          Pixel Color CLR_BLUE
		@ 085 , 040 ComboBox cCombo1 Items aCombo1     Size 30 , 10 Of oDlg Pixel

		//�����������������������������������Ŀ
		//�VG - 2011.01.14 - inclus�o da op��o�
		//�de rateio pelas Tabelas de Rateio  �
		//�������������������������������������
		@ 086 , 075 Say OemToAnsi("Utiliza Tabela de Rateio ?")	Pixel Color CLR_BLUE
		@ 085 , 140 ComboBox cXCmbTR Items aXCmbTR	Size 30 , 10 Of oDlg Pixel When cCombo1=='1'
		
		//    @ 086 , 095 Say OemToAnsi("Conta Contabil")    Pixel	Color CLR_BLUE
		//    @ 085 , 136 Msget cConta Picture "@!" F3 "CT1" Size 50 , 10 Valid Vazio() .OR. ExistCpo("CT1") OF oDlg Pixel
		
		//      @ 086 , 085 Say OemToAnsi("Centro de Custo ")  Pixel	Color CLR_BLUE
		//      @ 085 , 126 MsGet cCC Picture "@!" F3 "SZI"    Size 50 , 10 Valid Ctb105CC() .Or. U_UsrCCVldLin( __cUserId , cCC ) When .F. Of oDlg Pixel
		
		//      @ 086 , 180 Say OemToAnsi("Unidade de Negocio ")  Pixel	Color CLR_BLUE
		//	    @ 085 , 232 MsGet cItem Picture "@!" F3 "CTD"    Size 50 , 10 Valid Ctb105Item() When .F. Of oDlg Pixel
		
		//      @ 086 , 287 Say OemToAnsi("Operacao ")         Pixel	Color CLR_BLUE
		//      @ 085 , 317 MsGet cClasse Picture "@!" F3 "CTH"    Size 50 , 10 Valid Ctb105CLVL() When .F. Of oDlg Pixel
		
		/*����������������������������������������������������������������������������Ŀ
		�                Solicita a Digitacao do Historico do Documento              �
		������������������������������������������������������������������������������*/
		
		@ 120 , 005 To 155 , 372 Label OemToAnsi("Informacoes Financeiras Adicionais") Of oDlg Pixel COLOR CLR_RED
		
		@ 131 , 010 Say OemToAnsi("Tipo PA")  Pixel
		@ 130 , 040 ComboBox cCombo2 Items aCombo2 When !_lTemPa Size 30 , 10 Of oDlg Pixel
		
		@ 131 , 073 Say OemToAnsi("Natureza de Adiantamento ")  Pixel
		@ 130 , 141 MsGet cNaturPA   Picture "@!" F3 "SZH" Size 50 , 10 Valid u_CSUFIN03( cNaturPA ).and. u_VldNatFor( cNaturPA , cFornece, cLoja ) Of oDlg Pixel
		
		@ 131 , 203 Say OemToAnsi("Desconto")  Pixel
		@ 130 , 235 Msget nDescCsu Picture cPict Size 050 , 010 Of oDlg Pixel
		
		//      @ 131 , 300 Say OemToAnsi("Multa")  Pixel
		//      @ 130 , 317 Msget nMultCsu Picture cPict Size 050 , 010 Of oDlg Pixel
		
		@ 175	, 005 To 205 , 372	Label OemToAnsi("Informe o Historico do Documento") Of oDlg Pixel COLOR CLR_RED
		@ 185 , 010 Msget cHist Size 180 , 010 Of oDlg Pixel
		
		/*����������������������������������������������������������������������������Ŀ
		�                       Exibe a Janela de Dialogo                            �
		������������������������������������������������������������������������������*/
		
		Activate MsDialog oDlg Centered On Init EnchoiceBar(oDlg , {||nOpca := 1 , If( u_VldDadComp() , oDlg:End() , nOpca := 0 )},{||nOpca:=0,oDlg:End()},, aButton )

 		
		/*����������������������������������������������������������������������������Ŀ
		�                       Verifica a opcao do usuario                          �
		������������������������������������������������������������������������������*/
		
		If nOpca == 0
			Aviso("Aten��o !", "N�o ser� poss�vel fechar a tela sem gravar o conte�do!", {"Ok"} )
			lClose := .F.
		Else
			lClose := .T.
		EndIf
		
	EndDo

	
	/*�����������������������������������������������������������������Ŀ
	�  Verifica se o Rateio eh Igual a Sim e chama a Rotina do Rateio �
	�������������������������������������������������������������������*/
	
	If cCombo1 == "1"
		//��������������������������������Ŀ
		//�VG - 2011.01.14                 �
		//�Utiliza ou n�o Tabela de Rateio?�
		//����������������������������������
//		u_RFinA06( SF1->F1_PREFIXO , SF1->F1_DUPL , ""  ,  "NF" ,  SF1->F1_FORNECE ,  SF1->F1_LOJA ,  SF1->F1_VALBRUT , 3 , n )
		If cXCmbTR=='1'
			u_RFinA06( SF1->F1_PREFIXO , SF1->F1_DUPL , ""  ,  "NF" ,  SF1->F1_FORNECE ,  SF1->F1_LOJA ,  SF1->F1_VALBRUT , 3 , n, .T. )
		Else
			u_RFinA06( SF1->F1_PREFIXO , SF1->F1_DUPL , ""  ,  "NF" ,  SF1->F1_FORNECE ,  SF1->F1_LOJA ,  SF1->F1_VALBRUT , 3 , n, .F. )
		Endif
		If lMulNatRet = .T.
			lGravaRateio = .T.             //  Alterado por Tatiana Barbosa em 20/09/10 - OS 2201/10
		EndIf
	Endif                     
	
GrvDadComp() // Alterado por Tatiana Barbosa em 20/09/10 - OS 2201/10

EndIf

RestArea(aArea)
RestArea(aAreaSE2)

Return(.T.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GrvDadComp� Autor � Cristiano Figueiroa� Data �  26/07/2006 ���
�������������������������������������������������������������������������͹��
���Descricao � Grava os dados complementares do Documento de              ���
���          � Entrada.                                                   ���
�������������������������������������������������������������������������͹��
���Uso       � CSU CardSystem S.A                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function GrvDadComp()

/*����������������������������������������������������������������������������Ŀ
�                 Declara as Variaveis Utilizadas na Rotina                  �
������������������������������������������������������������������������������*/

Local cTipo	   := MVNOTAFIS
Local aArea    := GetArea()
Local aAreaSE2 := SE2->( GetArea() )
Local cChave   := ""
Local cRSocial := ""

/*����������������������������������������������������������������������������Ŀ
�               Atualiza o Historico do Documento de Entrada                 �
������������������������������������������������������������������������������*/

Reclock( "SF1" , .F.)
SF1->F1_DADADIC := cHist
//SF1->F1_XDECRES := nDescCsu

	If lGravaRateio          // Alterado por Tatiana Barbosa em 20/09/10 - OS 2201/10

		If cXCmbTR=='1'//VG - 2011.02.17
			SF1->F1_XTABRAT		:= "1"
		Endif

		SF1->F1_RATESP  	:= "1"		
		
	Else                              

		SF1->F1_RATESP  	:= "2"
		SF1->F1_XTABRAT		:= "2"
		
	EndIf
	
SF1->F1_CLVL    := cClasse
SF1->F1_ITEMCTA := cItem
SF1->F1_TIPOPA  := cCombo2
SF1->F1_NATURPA := cNaturPA
SF1->F1_CCUSTO  := cCC

MsunLock()

/*����������������������������������������������������������������������������Ŀ
�                     Abre a Tabela de Titulos a Pagar                       �
������������������������������������������������������������������������������*/

DbSelectArea("SE2")
DbSetOrder(1)

/*����������������������������������������������������������������������������Ŀ
�                     Posiciona no  de Titulos a Pagar                       �
������������������������������������������������������������������������������*/

If DbSeek ( xFilial("SE2") + cPrefixo + cNum )
	
	/*����������������������������������������������������������������������������Ŀ
	�         Processa todos os Titulos referentes ao Documento de Entrada       �
	������������������������������������������������������������������������������*/
	
	Do While SE2->( !Eof() ) .And. SE2->E2_PREFIXO == cPrefixo ;
		.And. SE2->E2_NUM     == cNum
		
		/*����������������������������������������������������������������������������Ŀ
		�           Ignora os Titulos que nao se refiram a essa Nota Fiscal          �
		������������������������������������������������������������������������������*/
		
	//	If dEmissao <> SE2->E2_EMISSAO .Or. SE2->E2_ORIGEM <> "MATA100" .Or. Alltrim( cEspecie ) <> Alltrim( SE2->E2_PREFIXO ) .Or. !Empty( SE2->E2_ITEMD ) 
		If dEmissao <> SE2->E2_EMISSAO .Or. SE2->E2_ORIGEM <> "MATA100" .Or. Alltrim( cPrefixo ) <> Alltrim( SE2->E2_PREFIXO ) .Or. !Empty( SE2->E2_ITEMD ) //OS 2295/14 By Douglas David
			DbSelectArea("SE2")
			DbSkip()
			Loop
		Endif
		
		/*����������������������������������������������������������������������������Ŀ
		�                  Atualiza o Historico do Titulo a Pagar                    �
		������������������������������������������������������������������������������*/
		
		cChave   :=  SE2->E2_TIPO   + " / " + SE2->E2_NUM + " - " + cRSocial
		cRSocial := cRazao
		
		/*����������������������������������������������������������������������������Ŀ
		�                  Calcula o Historico dependendo do Tipo                    �
		������������������������������������������������������������������������������*/
		
		If SE2->E2_TIPO == "INS"
			cHist := "INSS - " + cChave
		ElseIf SE2->E2_TIPO == "ISS"
			cHist := "ISS - "  + cChave
		ElseIf SE2->E2_TIPO == "TX " .And. Alltrim(SE2->E2_FORNECE) == cUniao
			
			If Alltrim(SE2->E2_NATUREZ) == Alltrim(cIrrf)
				cHist    := "IRRF - " + cChave
			ElseIf Alltrim(SE2->E2_NATUREZ) == cCofins
				cHist    := "LEI 10.833 - Cofins - "  + cChave
			ElseIf Alltrim(SE2->E2_NATUREZ) == cPis
				cHist    := "LEI 10.833 - Pis - "  + cChave
			ElseIf  Alltrim(SE2->E2_NATUREZ) == cCsll
				cHist    := "LEI 10.833 - Csll - "  + cChave
			Endif
			
		Endif
		
		/*����������������������������������������������������������������������������Ŀ
		�              Grava os Dados Complementares nos Titulos a Pagar             �
		������������������������������������������������������������������������������*/
		
		Reclock("SE2" , .F. )
		SE2->E2_HIST	 := cHist
		SE2->E2_NOMFOR := Posicione("SA2", 1 , xFilial("SA2") + cFornece + cLoja , "A2_NREDUZ" )
		SE2->E2_CCUSTO := cCC
		SE2->E2_CCD    := cCC
		SE2->E2_ITEMD  := cItem
		SE2->E2_CLVLDB := cClasse
		SE2->E2_RSOCIAL:= cRSocial
		SE2->E2_CSUKEY := SE2->E2_FILIAL + cPrefixo + cNum + cParcela + cTipo + cFornece + cLoja
		
		If Alltrim(SE2->E2_TIPO) == Alltrim(cTipo)
			SE2->E2_CONTA   := cContFor
			SE2->E2_TIPOPA  := cCombo2
			SE2->E2_NATURPA := cNaturPA
			// SE2->E2_DESCCSU := nDescCsu			// alterado by Daniel G.Jr. em 29/02/08
			SE2->E2_DECRESC := nDescCsu				// incluido by Daniel G.Jr. em 29/02/08
			SE2->E2_SDDECRE := nDescCsu				// incluido by Tatiana A. Barbosa em 07/10/11 - OS 2348/11
			SE2->E2_CSMULTA := nMultCsu
				If lGravaRateio     // Alterado por Tatiana Barbosa em 20/09/10 - OS 2201/10
					SE2->E2_RATESP  := cCombo1
					SE2->E2_MULTNAT := cCombo1
				Else
					SE2->E2_RATESP   := "2"
					SE2->E2_MULTNAT := "2"
				Endif
		Endif
		
		MsUnlock()
		
		/*����������������������������������������������������������������������������Ŀ
		�                  Processa o Proximo Registro da Tabela                     �
		������������������������������������������������������������������������������*/
		
		DbSkip()
		Loop
		
	Enddo
	
Endif

/*����������������������������������������������������������������������������Ŀ
�                          Restaura a Area Utilizada                         �
������������������������������������������������������������������������������*/

RestArea(aAreaSE2)
RestArea(aArea)

Return(.T.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa �VldDadComp� Autor � Cristiano Figueiroa� Data �  26/07/2006 ���\
�������������������������������������������������������������������������͹��
���Descricao � Valida a tela de dados complementares do Documento de      ���
���          � Entrada.                                                   ���
�������������������������������������������������������������������������͹��
���Uso       � CSU CardSystem S.A                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function VldDadComp()

/*����������������������������������������������������������������������������Ŀ
�              Declara as Variaveis Locais Utilizadas na Rotina              �
������������������������������������������������������������������������������*/
Local lRet := .T.
Local _cNatAdt := ''
LOCAL _cMsg := ''
/*���������������������������������������������������������������������������������Ŀ
�    Valida os campos obrigatorios caso seja um Documento de Entrada sem Rateio   �
�    Caso o Documento possua Rateio , a Rorina de Rateio obrigara a digitacao dos �
�    campos abaixo.                                                               �
�����������������������������������������������������������������������������������*/

If cCombo1 <> "1"  // Rateia = Nao
	
	If Empty(cCC)
		Aviso( "Aten��o " + Alltrim(cUserName) + "!" , "O campo Centro de Custo � obrigat�rio. Preencha o campo antes de continuar." , {"Ok"} , 1 , "Centro de Custo Obrigat�rio !" )
		lRet := .F.
	EndIf
	
	If Empty(cItem)
		Aviso( "Aten��o " + Alltrim(cUserName) + "!" , "O campo Centro de Unidade de Neg�cio � obrigat�rio. Preencha o campo antes de continuar." , {"Ok"} , 1 , "Unidade de Negocio Obrigat�rio !" )
		lRet := .F.
	EndIf
	
	If Empty(cClasse)
		Aviso( "Aten��o " + Alltrim(cUserName) + "!" , "O campo Opera��o � obrigat�rio. Preencha o campo antes de continuar." , {"Ok"} , 1 , "Operacao Obrigat�ria !" )
		lRet := .F.
	EndIf
	
Endif

If cCombo2 == "1"  // Tipo PA = Sim
	
	If Empty( cNaturPA )
		Aviso( "Aten��o " + Alltrim(cUserName) + "!" , "O campo Natureza de Adiantamento � obrigat�rio quando o campo Tipo PA � igual a Sim. Preencha o campo antes de continuar." , {"Ok"} , 1 , "Natureza de Adiantamento !" )
		lRet := .F.
	Endif
	//����������������������������������������������������������������Ŀ
	//� Incluido por Flavio Novaes em 10/05/07, conforme chamado 1305. �
	//������������������������������������������������������������������
	IF lRet
		_cNatAdt := IIF(EMPTY(GETMV('MV_XNATADT')),'',ALLTRIM(GETMV('MV_XNATADT')))
		IF !ALLTRIM(cNaturPA) $ _cNatAdt
			_cMsg := '� Obrigat�ria a utiliza��o de uma Natureza de Adiantamento, conforme '
			_cMsg += 'par�metro MV_XNATADT. Caso essa Natureza N�O esteja cadastrada, '
			_cMsg += 'solicitar a amarra��o para M�rcia Dias do Contas a Pagar.     '
			AVISO('Aten��o '+ALLTRIM(cUserName)+'!',_cMsg,{'Ok'},1,'Natureza de Adiantamento !')
			lRet := .F.
		ENDIF
	ENDIF
Endif

If Empty(cHist)
	Aviso( "Aten��o " + Alltrim(cUserName) + "!" , "O campo hist�rico � obrigat�rio. Preencha o campo antes de continuar." , {"Ok"} , 1 , "Hist�rico Obrigat�rio !" )
	lRet := .F.
EndIf

Return(lRet)
