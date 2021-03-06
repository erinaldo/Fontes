#Include 'Protheus.ch'
#INCLUDE "TBICONN.CH"
#INCLUDE "CNTA180.CH"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � PROCC010  � Autor � Felipe Santos        � Data � 12/06/15 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Consulta especifica de posi��o de fornecedor x contrato    ��� 
�� Ref. item B da Tabela 8 (Compras) da Lista de Requisitos)			  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ExpX1 := FINC030( ExpC1 )                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function PROCC010(nPosArotina,cxFor,cxLoj)

Local aCores := {	{ "Alltrim(CN9->CN9_SITUAC) == '01'", "BR_VERMELHO" },;		// Cancelado
					{ "Alltrim(CN9->CN9_SITUAC) == '02'", "BR_AMARELO"	 },;	// Elaboracao
					{ "Alltrim(CN9->CN9_SITUAC) == '03'", "BR_AZUL"		 },;	// Emitido
					{ "Alltrim(CN9->CN9_SITUAC) == '04'", "BR_LARANJA"	 },;	// Em Aprovacao
					{ "Alltrim(CN9->CN9_SITUAC) == '05'", "BR_VERDE"	 },;	// Vigente
					{ "Alltrim(CN9->CN9_SITUAC) == '06'", "BR_CINZA"	 },;	// Paralisado
					{ "Alltrim(CN9->CN9_SITUAC) == '07'", "BR_MARRON"	 },;	// Sol. Finalizacao
					{ "Alltrim(CN9->CN9_SITUAC) == '08'", "BR_PRETO"	 },;	// Finalizado
					{ "Alltrim(CN9->CN9_SITUAC) == '09'", "BR_PINK"		 },;	// Revisao   
					{ "Alltrim(CN9->CN9_SITUAC) == '10'", "BR_BRANCO"	 }}		// Revisado

Private cCadastro	:= "Avalia��o de Contratos"
Private cFiltro		:= ""//EncCon(cxFor,cxLoj)
Private aAcho		:= {}
Private aRotina 	:= MenuDef()
Private	lVisAval	:= .F.
//Private _cCpo  	    := "CN9_TPCTO/CN9_NUMERO/CN9_DTINIC"

DEFAULT nPosArotina := 0
DEFAULT cxFor := ""
DEFAULT cxLoj := ""
//Array com os campos que irao aparecer na enchoice
AADD(aAcho, "COA_CONCEI")
AADD(aAcho, "COA_OCORRE")
AADD(aAcho, "COA_DESOCO")
AADD(aAcho, "COA_DTAVAL")
AADD(aAcho, "COA_OBSERV")

If nPosArotina > 0 // Sera executada uma opcao diretamento de aRotina, sem passar pela mBrowse
	dbSelectArea("CN9")
	bBlock := &( "{ |a,b,c| " + aRotina[ nPosArotina,2 ] + "(a,b,c) }" )
	Eval( bBlock, Alias(), (Alias())->(Recno()),nPosArotina)

Else
	// ��������������������������������������������Ŀ
	// �Cria indice condicianal para a Localizacoes �
	// ����������������������������������������������
	DbSelectArea("CN9")                       
	dbSetOrder(1)
	//��������������������������������������������������������������Ŀ
	//� Endereca a Funcao de BROWSE                                  �
	//����������������������������������������������������������������
	mBrowse(6,1,22,75,"CN9",,,,,,aCores,,,,,,,,,,,,cFiltro)

	//��������������������������������������������������������������Ŀ
	//� Recupera a Integridade dos dados                             �
	//����������������������������������������������������������������
	RetIndex("CN9")
	dbSetOrder(1)
	Set Filter to

	If nPosArotina == 0
		dbSeek(xFilial())
	Endif
EndIf

Return

Static Function MenuDef()
Local aRotina := {	{ "Pesquisar" 	,"AxPesqui"		, 0 , 1,,.F.},;		//"Pesquisar"
	 				{ "Visualizar"	,"CN180Vis"		, 0 , 2, 0, NIL},;	//"Visualizar"
					{ "Avaliar"		,"CN180Aval"	, 0 , 3, 0, NIL},;	//"Avaliar"
					{ "Relatorio"	,"CN180Imp"		, 0 , 6, 0, NIL},;	//"Relatorio"
					{ "Legenda"		,"CN180Leg"		, 0 , 2, 0, NIL}}		//"Legenda"

Return(aRotina)
Static Function EncCon(cFo,cLj)

Local cFil := ""
local cAlias := GetNextAlias()

If !Empty(cFo)
	BeginSQL Alias cAlias

 	%noparser% 
 
	SELECT CNC_NUMERO
	FROM %Table:CNC% CNC 
	   WHERE CNC.%notDel%
	   AND CNC_CODIGO=%Exp:cFo%
	   AND CNC_LOJA=%Exp:cLj%
	   ORDER BY CNC_NUMERO
	
	EndSQL

	While (cAlias)->(!EOF())
		
		If(!empty(cFil))
			cFil+=".OR.CN9_NUMERO=='" + (cAlias)->CNC_NUMERO + "'"
		Else
			cFil:="CN9_NUMERO=='" + (cAlias)->CNC_NUMERO + "'"
		EndIf
		
		(cAlias)->(dbSkip())
		
	EndDo
EndIf

Return cFil
