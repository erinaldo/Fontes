#INCLUDE "rwmake.ch"
#INCLUDE "ccomr03.ch"
#INCLUDE "_FixSX.ch" // "AddSX1.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CCOMR03   �Autor  � Felipe Raposo      � Data �  06/01/03   ���
�������������������������������������������������������������������������͹��
���Desc.     � Relatorio especifico de relacao de notas fiscais de entra- ���
���          � da.                                                        ���
���          � Esse relatorio foi adaptado porque o padrao nao filtra as  ���
���          � despesas e os descontos concedidos na nota. Ele utiliza os ���
���          � campos F1_VALDESC e F1_DESPESA e o CIEE precisa que seja   ���
���          � utilizado os campos D1_VALDESC e D1_DESPESA.               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CIEE.                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR080  � Autor � Alexandre Inacio Lemes� Data �10/05/2002���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Emiss�o da Rela��o de Notas Fiscais                        ���
�������������������������������������������������������������������������Ĵ��
���Observacao� Baseado no original de Claudinei M. Benzi  Data  05/09/1991���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CCOMR03()

LOCAL titulo     := STR0001	//"Rela��o de Notas Fiscais"
LOCAL cDesc1     := STR0002	//"Emiss�o da Rela��o de Notas de Compras"
LOCAL cDesc2     := STR0003	//"A op��o de filtragem deste relat�rio s� � v�lida na op��o que lista os"
LOCAL cDesc3     := STR0004	//"itens. Os par�metros funcionam normalmente em qualquer op��o."
LOCAL cString    := "SD1"
LOCAL wnrel      := "MATR080"
LOCAL nomeprog   := "MATR080"

PRIVATE Tamanho  := "M"
PRIVATE limite   := 132
PRIVATE aOrdem   := {OemToAnsi(STR0005),OemToAnsi(STR0006),OemToAnsi(STR0043),OemToAnsi(STR0059)}		//" Por Nota           "###" Por Produto        "###" Por Data Digitacao "###" Por Data Emissao "
PRIVATE cPerg    := "MTR080"
PRIVATE aReturn  := {OemToAnsi(STR0007), 1,OemToAnsi(STR0008), 2, 2, 1, "",1 }		//"Zebrado"###"Administracao"
PRIVATE lEnd     := .F.
PRIVATE m_pag    := 1
PRIVATE li       := 80
PRIVATE nLastKey := 0

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
Pergunte("MTR080    ",.F.)

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01 // Produto de                                       �
//� mv_par02 // Produto ate                                      �
//� mv_par03 // Data de                                          �
//� mv_par04 // Data ate                                         �
//� mv_par05 // Lista os itens da nota                           �
//� mv_par06 // Grupo de                                         �
//� mv_par07 // Grupo ate                                        �
//� mv_par08 // Fornecedor de                                    �
//� mv_par09 // Fornecedor ate                                   �
//� mv_par10 // Almoxarifado de                                  �
//� mv_par11 // Almoxarifado ate                                 �
//� mv_par12 // De  Nota                                         �
//� mv_par13 // Ate Nota                                         �
//� mv_par14 // De  Serie                                        �
//� mv_par15 // Ate Serie                                        �
//� mv_par16 // Do  Tes                                          �
//� mv_par17 // Ate Tes                                          �
//� mv_par19 // Moeda                                            �
//� mv_par20 // Otras moedas                                     �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
wnRel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrdem,,Tamanho)

If (nLastKey == 27)
	dbSelectArea(cString)
	dbSetOrder(1)
	Set Filter to
	Return
Endif
SetDefault(aReturn, cString)
If (nLastKey == 27)
	dbSelectArea(cString)
	dbSetOrder(1)
	Set Filter To
	Return
Endif
// Processamento com regua de progressao.
RptStatus({|lEnd| C080Imp(@lEnd,wnRel,cString,nomeprog,Titulo)},Titulo)
Return(.T.)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � C080IMP  � Autor � Alex Lemes            � Data �10/05/2002���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relatorio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR080			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function C080Imp(lEnd,WnRel,cString,nomeprog,Titulo)

LOCAL cCabec      := ""
LOCAL cabec1      := ""
LOCAL cabec2      := ""
LOCAL cQuery	  := ""
LOCAL cDocAnt     := ""
LOCAL cCodAnt     := ""
LOCAL cbText      := ""
LOCAL cQryAd      := ""
LOCAL cName       := ""
LOCAL cAliasSF1   := "SF1"
LOCAL cAliasSD1   := "SD1"
LOCAL cAliasSB1   := "SB1"
LOCAL cAliasSA1   := "SA1"
LOCAL cAliasSA2   := "SA2"
LOCAL cAliasSF4   := "SF4"
LOCAL cIndex 	  := CriaTrab("",.F.)
LOCAL cForCli     := ""
LOCAL cMuni       := ""
LOCAL cFornF1     := ""
LOCAL cLojaF1     := ""
LOCAL cDocF1      := ""
LOCAL cSerieF1    := ""
LOCAL cCondF1     := ""
LOCAL cTipoF1     := ""
LOCAL nMoedaF1    := 0
LOCAL nTxMoedaF1  := 0
LOCAL nFreteF1    := 0
LOCAL nDespesaF1  := 0
LOCAL nSeguroF1   := 0
LOCAL nIndex	  := 0
LOCAL nValMerc    := 0
LOCAL nValDesc    := 0
LOCAL nValIcm     := 0
LOCAL nValIpi     := 0
LOCAL nValImpInc  := 0
LOCAL nValImpNoInc:= 0
LOCAL nTotGeral   := 0
LOCAL nTotDesco   := 0
LOCAL nTotProd    := 0
LOCAL nTotQger    := 0
LOCAL nTotData    := 0
LOCAL nTotquant   := 0
LOCAL nTGerIcm    := 0
LOCAL nTGerIpi    := 0
LOCAL nTGImpInc   := 0
LOCAL nTGImpNoInc := 0
LOCAL nImpInc     := 0
LOCAL nImpNoInc   := 0
LOCAL nImpos      := 0
LOCAL nPosNome    := 0
LOCAL nTamNome    := 0
LOCAL cbCont      := 0
LOCAL nTaxa       := 1
LOCAL nMoeda      := 1
LOCAL nDecs       := Msdecimais(mv_par19)
LOCAL nOrdem 	  := aReturn[8]
LOCAL lQuery      := .F.
LOCAL lImp	      := .F.
LOCAL lFiltro     := .T.
LOCAL lDescLine   := .T.
LOCAL lPrintLine  := .F.
LOCAL aTamSXG     := TamSXG("001")
LOCAL aTamSXG2    := TamSXG("002")
LOCAL aImpostos   := {}
LOCAL aStrucSF1   := {}
LOCAL aStrucSD1   := {}
LOCAL dDtDig      := dDataBase
LOCAL dDataAnt    := dDataBase
LOCAL dEmissaoF1  := dDataBase
LOCAL dDtDigitF1  := dDataBase

PRIVATE nTipo  	 := IIF(aReturn[4]=1,15,18)

//��������������������������������������������������������������Ŀ
//� Define o Cabecalho em todas as Ordems do Relatorio           �
//����������������������������������������������������������������
// Regua                       1         2         3         4         5         6         7         8         9        10        11        12        13
//                   0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
If nOrdem == 1 .and. mv_par05 == 1
	nPosNome := 92
	nTamNome := 34
	cabec1   := STR0011	//"RELACAO DOS ITENS DAS NOTAS"
	cCabec   := IIF(cPaisLoc == "BRA",STR0012,STR0050)	//"CODIGO DO MATERIAL   D E S C R I C A O             CFO  TE  ICM  IPI  LOCAL             QUANTIDADE   VALOR UNITARIO      VALOR TOTAL"
Elseif nOrdem == 1 .and. mv_par05 == 2
	nPosNome := 35
	nTamNome := 30
	cabec2      :=STR0034	//"                  EMISSAO   FORNEC "
	If aTamSXG[1]  !=  aTamSXG[3] //"NUMERO       SER   DATA     CODIGO               RAZAO SOCIAL         PRACA       PGTO     ICM            IPI       TOTAL MERCADORIA"
		cabec1   :=STR0047        // 123456789012  123 99/99/9999 12345678901234567890 1234567890123456 123456789012345 XXX 999,999,999.99 999,999,999.99 9,999,999,999.99
	Else                                                       //"NUMERO       SER   DATA     CODIGO RAZAO SOCIAL                       PRACA       PGTO     ICM            IPI       TOTAL MERCADORIA"
		cabec1   := IIF(cPaisLoc == "BRA", STR0033, STR0053)  // 123456789012 123 99/99/9999 123456 123456789012345678901234567890 123456789012345 XXX 999,999,999.99 999,999,999.99 9,999,999,999.99
	Endif
Elseif nOrdem == 2
	nPosNome := 29
	nTamNome := 30
	cabec1   := STR0036	 //"RELACAO DAS NOTAS FISCAIS DE COMPRAS"
	If aTamSXG[1] != aTamSXG[3]			                     //"NUMERO       EMISSAO    FORNEC               RAZAO SOCIAL    LC CFO TE  ICM   IPI   TP    QUANTIDADE VALOR UNITARIO     VALOR TOTAL"
		cCabec  := IIF(cPaisLoc == "BRA", STR0048, STR0054) // 012345678901 99/99/9999 12345678901234567890 1234567890123456 12 123 123 12345 12345 1  1234567890123 12345678901234  12345678901234
	Else
		cCabec  :=STR0037	   //"NUMERO       EMISSAO    FORNEC RAZAO SOCIAL                  LC CFO TE  ICM   IPI   TP    QUANTIDADE VALOR UNITARIO     VALOR TOTAL"
		// 012345678901 99/99/9999 123456 12345679012345678901234567890  12 123 123 12345 12345 1  1234567890123 12345678901234   12345678901234
	Endif
Elseif (nOrdem == 3 .or. nOrdem == 4) .and. mv_par05 == 1
	nPosNome    := 35
	nTamNome    := 23
	cabec1      := STR0036	 //"RELACAO DAS NOTAS FISCAIS DE COMPRAS"
	If aTamSXG[1] != aTamSXG[3]                             //"NUMERO       PRODUTO         FORNEC              RAZAO SOCIAL LC CFO TE  ICM   IPI   TP    QUANTIDADE VALOR UNITARIO      VALOR TOTAL"
		cCabec  := IIF(cPaisLoc == "BRA", STR0049, STR0055) // 123456789012 123456789012345 12345678901234567890 12345678901 12 123 001 12345 12345 1  9,999,999,999 99,999,999,999 9999,999,999,999
	Else                         //"NUMERO       PRODUTO         FORNEC RAZAO SOCIAL              LC CFO TE  ICM   IPI   TP    QUANTIDADE VALOR UNITARIO      VALOR TOTAL"
		cCabec  :=STR0044	     // 123456789012 123456789012345 123456 1234567890123456789012345 12 123 001 12345 12345 1  9,999,999,999 99,999,999,999 9999,999,999,999
	Endif
Elseif (nOrdem == 3 .or. nOrdem == 4) .and. mv_par05 == 2
	nPosNome := 35
	nTamNome := 30
	cabec2   := Iif(nOrdem == 3,STR0058,STR0060)	//"                  DIGITAC   FORNEC "
	If aTamSXG[1] != aTamSXG[3]   //"NUMERO       SER   DATA     CODIGO               RAZAO SOCIAL         PRACA       PGTO     ICM            IPI       TOTAL MERCADORIA"
		cabec1 := STR0047         // 123456789012  123 99/99/9999 12345678901234567890 1234567890123456 123456789012345 XXX 999,999,999.99 999,999,999.99 9,999,999,999.99
	Else                                                     //"NUMERO       SER   DATA     CODIGO RAZAO SOCIAL                       PRACA       PGTO     ICM            IPI       TOTAL MERCADORIA"
		cabec1 := IIF(cPaisLoc == "BRA", STR0033, STR0053)  // 123456789012 123 99/99/9999 123456 123456789012345678901234567890 123456789012345 XXX 999,999,999.99 999,999,999.99 9,999,999,999.99
	Endif
Endif

//��������������������������������������������������������������Ŀ
//�Caso nao utilize tamanho min, considera tamanho max e altera  �
//�layout de impressao ref grupo 001                             �
//����������������������������������������������������������������
If aTamSXG[1] != aTamSXG[3]
	nPosNome += aTamSXG[4]-aTamSXG[3]
	nTamNome -= aTamSXG[4]-aTamSXG[3]
EndIf

If aTamSXG2[1] != aTamSXG2[3]
	nPosNome += aTamSXG2[4]-aTamSXG2[3]
	nTamNome -= aTamSXG2[4]-aTamSXG2[3]
EndIf

//��������������������������������������������������������������Ŀ
//� Posiciona a Ordem de todos os Arquivos usados no Relatorio   �
//����������������������������������������������������������������
dbSelectArea("SA1")
dbSetOrder(1)
dbSelectArea("SA2")
dbSetOrder(1)
dbSelectArea("SB1")
dbSetOrder(1)
dbSelectArea("SF4")
dbSetOrder(1)
dbselectarea("SF1")
dbsetorder(1)
dbSelectArea("SD1")
dbSetOrder(1)

If (TcSrvType() != 'AS/400')
	//��������������������������������Ŀ
	//� Query para SQL                 �
	//����������������������������������
	aStrucSF1 := SF1->(dbStruct())
	aStrucSD1 := SD1->(dbStruct())
	cALiasSF1 := "QRYSD1"
	cAliasSD1 := "QRYSD1"
	cALiasSB1 := "QRYSD1"
	cALiasSA1 := "QRYSD1"
	cALiasSA2 := "QRYSD1"
	cALiasSF4 := "QRYSD1"
	lQuery :=.T.
	
	cQuery := "SELECT "
	If nOrdem == 1
		cQuery += "SD1.D1_FILIAL,SD1.D1_DOC,SD1.D1_SERIE,SD1.D1_FORNECE,SD1.D1_LOJA,SD1.D1_COD,SD1.D1_ITEM,"
	ElseIf nOrdem == 2
		cQuery += "SD1.D1_FILIAL,SD1.D1_COD,SD1.D1_DOC,SD1.D1_SERIE,SD1.D1_FORNECE,SD1.D1_LOJA,"
	ElseIf nOrdem == 3
		cQuery += "SD1.D1_FILIAL,SD1.D1_DTDIGIT,SD1.D1_DOC,SD1.D1_SERIE,SD1.D1_FORNECE,SD1.D1_LOJA,"
	ElseIf nOrdem == 4
		cQuery += "SD1.D1_FILIAL,SD1.D1_EMISSAO,SD1.D1_DOC,SD1.D1_SERIE,SD1.D1_FORNECE,SD1.D1_LOJA,"
	Endif
	
	cQuery += "D1_DESPESA,D1_DTDIGIT,D1_COD,D1_QUANT,D1_VUNIT,D1_TOTAL,"
	If cPaisLoc == "BRA"
		cQuery += "D1_TES,D1_IPI,D1_PICM,D1_TIPO,D1_CF,D1_GRUPO,D1_LOCAL,D1_ITEM,D1_EMISSAO,D1_VALDESC,D1_ICMSRET,D1_VALICM,D1_VALIPI,"
	Else
		cQuery += "D1_TES,D1_IPI,D1_PICM,D1_TIPO,D1_CF,D1_GRUPO,D1_LOCAL,D1_ITEM,D1_EMISSAO,D1_VALDESC,D1_ICMSRET,"
		cQuery += "D1_VALICM,D1_VALIPI,D1_VALIMP1,D1_VALIMP2,D1_VALIMP3,D1_VALIMP4,D1_VALIMP5,D1_VALIMP6,"
	EndIf
	//�������������������������������������������������������������������Ŀ
	//�Esta rotina foi escrita para adicionar no select os campos         �
	//�usados no filtro do usuario quando houver, a rotina acrecenta      �
	//�somente os campos que forem adicionados ao filtro testando         �
	//�se os mesmo j� existem no select ou se forem definidos novamente   �
	//�pelo o usuario no filtro, esta rotina acrecenta o minimo possivel  �
	//�de campos no select pois pelo fato da tabela SD1 ter muitos campos |
	//�e a query ter UNION ao adicionar todos os campos do SD1 estava     |
	//�derrubando o TOP CONNECT e abortando o sistema.                    |
	//���������������������������������������������������������������������
	If !empty(aReturn[7])
		For nX := 1 To SD1->(FCount())
			cName := SD1->(FieldName(nX))
			If AllTrim( cName ) $ aReturn[7]
				If aStrucSD1[nX,2] <> "M"
					If !cName $ cQuery .and. !cName $ cQryAd
						cQryAd += cName +","
					Endif
				EndIf
			EndIf
		Next nX
	Endif
	
	cQuery += cQryAd
	
	cQuery += "F1_FILIAL,F1_MOEDA,F1_TXMOEDA,F1_DTDIGIT,F1_TIPO,F1_COND,F1_VALICM,F1_VALIPI,F1_VALIMP1,"
	cQuery += "F1_FRETE,F1_DESPESA,F1_SEGURO,F1_DESCONT,F1_VALMERC,F1_DOC,F1_SERIE,F1_EMISSAO,F1_FORNECE,F1_LOJA,"
	cQuery += "B1_DESC,B1_GRUPO,A1_NOME,A1_MUN,F4_AGREG,F4_IPI,SD1.R_E_C_N_O_ SD1RECNO "
	cQuery += "FROM "+RetSqlName("SF1")+" SF1 ,"+RetSqlName("SD1")+" SD1 ,"+RetSqlName("SB1")+" SB1 ,"+RetSqlName("SA1")+" SA1 ,"+RetSqlName("SF4")+" SF4 "
	cQuery += "WHERE "
	cQuery += "SF1.F1_FILIAL='"+xFilial("SF1")+"' AND "
	cQuery += "SF1.D_E_L_E_T_ <> '*' AND "
	cQuery += "SD1.D1_FILIAL = '"+xFilial("SD1")+"' AND "
	cQuery += "SD1.D1_DOC = SF1.F1_DOC AND "
	cQuery += "SD1.D1_SERIE = SF1.F1_SERIE AND "
	cQuery += "SD1.D1_FORNECE = SF1.F1_FORNECE AND "
	cQuery += "SD1.D1_LOJA = SF1.F1_LOJA AND "
	cQuery += "SD1.D1_TIPO IN ('D','B') AND "
	cQuery += "SD1.D_E_L_E_T_ <> '*' AND "
	cQuery += "SB1.B1_FILIAL ='"+xFilial("SB1")+"' AND "
	cQuery += "SB1.B1_COD = SD1.D1_COD AND "
	cQuery += "SB1.D_E_L_E_T_ <> '*' AND "
	cQuery += "SF4.F4_FILIAL ='"+xFilial("SF4")+"' AND "
	cQuery += "SF4.F4_CODIGO = SD1.D1_TES AND "
	cQuery += "SF4.D_E_L_E_T_ <> '*' AND "
	cQuery += "SA1.A1_FILIAL ='"+xFilial("SA1")+"' AND "
	cQuery += "SA1.A1_COD = SD1.D1_FORNECE AND "
	cQuery += "SA1.A1_LOJA = SD1.D1_LOJA AND "
	cQuery += "SA1.D_E_L_E_T_ <> '*' AND "               
	cQuery += "D1_COD >= '"  		    + MV_PAR01	+ "' AND "
	cQuery += "D1_COD <= '"  	        + MV_PAR02	+ "' AND "
	cQuery += "D1_DTDIGIT >= '" + DTOS(MV_PAR03)	+ "' AND "
	cQuery += "D1_DTDIGIT <= '" + DTOS(MV_PAR04)	+ "' AND "
	cQuery += "D1_GRUPO >= '"  		+ MV_PAR06	+ "' AND "
	cQuery += "D1_GRUPO <= '"  		+ MV_PAR07	+ "' AND "
	cQuery += "D1_FORNECE >= '"  		+ MV_PAR08	+ "' AND "
	cQuery += "D1_FORNECE <= '"  		+ MV_PAR09	+ "' AND "
	cQuery += "D1_LOCAL >= '"  		+ MV_PAR10	+ "' AND "
	cQuery += "D1_LOCAL <= '"  		+ MV_PAR11	+ "' AND "
	cQuery += "D1_DOC >= '"  	    	+ MV_PAR12	+ "' AND "
	cQuery += "D1_DOC <= '"  		    + MV_PAR13	+ "' AND "
	cQuery += "D1_SERIE >= '"  		+ MV_PAR14	+ "' AND "
	cQuery += "D1_SERIE <= '"  		+ MV_PAR15	+ "' AND "
	cQuery += "D1_TES >= '"  	        + MV_PAR16	+ "' AND "
	cQuery += "D1_TES <= '"  	        + MV_PAR17	+ "' "

	cQuery += "UNION "
	
	cQuery += "SELECT "
	If nOrdem == 1
		cQuery += "SD1.D1_FILIAL,SD1.D1_DOC,SD1.D1_SERIE,SD1.D1_FORNECE,SD1.D1_LOJA,SD1.D1_COD,SD1.D1_ITEM,"
	ElseIf nOrdem == 2
		cQuery += "SD1.D1_FILIAL,SD1.D1_COD,SD1.D1_DOC,SD1.D1_SERIE,SD1.D1_FORNECE,SD1.D1_LOJA,"
	ElseIf nOrdem == 3
		cQuery += "SD1.D1_FILIAL,SD1.D1_DTDIGIT,SD1.D1_DOC,SD1.D1_SERIE,SD1.D1_FORNECE,SD1.D1_LOJA,"
	ElseIf nOrdem == 4
		cQuery += "SD1.D1_FILIAL,SD1.D1_EMISSAO,SD1.D1_DOC,SD1.D1_SERIE,SD1.D1_FORNECE,SD1.D1_LOJA,"
	Endif
	
	cQuery += "D1_DESPESA,D1_DTDIGIT,D1_COD,D1_QUANT,D1_VUNIT,D1_TOTAL,"
	If cPaisLoc == "BRA"
		cQuery += "D1_TES,D1_IPI,D1_PICM,D1_TIPO,D1_CF,D1_GRUPO,D1_LOCAL,D1_ITEM,D1_EMISSAO,D1_VALDESC,D1_ICMSRET,D1_VALICM,D1_VALIPI,"
	Else
		cQuery += "D1_TES,D1_IPI,D1_PICM,D1_TIPO,D1_CF,D1_GRUPO,D1_LOCAL,D1_ITEM,D1_EMISSAO,D1_VALDESC,D1_ICMSRET,"
		cQuery += "D1_VALICM,D1_VALIPI,D1_VALIMP1,D1_VALIMP2,D1_VALIMP3,D1_VALIMP4,D1_VALIMP5,D1_VALIMP6,"
	EndIf
	cQuery += cQryAd
	cQuery += "F1_FILIAL,F1_MOEDA,F1_TXMOEDA,F1_DTDIGIT,F1_TIPO,F1_COND,F1_VALICM,F1_VALIPI,F1_VALIMP1,"
	cQuery += "F1_FRETE,F1_DESPESA,F1_SEGURO,F1_DESCONT,F1_VALMERC,F1_DOC,F1_SERIE,F1_EMISSAO,F1_FORNECE,F1_LOJA,"
	cQuery += "B1_DESC,B1_GRUPO,A2_NOME,A2_MUN,F4_AGREG,F4_IPI,SD1.R_E_C_N_O_ SD1RECNO "
	cQuery += "FROM "+RetSqlName("SF1")+" SF1 ,"+RetSqlName("SD1")+" SD1 ,"+RetSqlName("SB1")+" SB1 ,"+RetSqlName("SA2")+" SA2 ,"+RetSqlName("SF4")+" SF4 "
	cQuery += "WHERE "
	cQuery += "SF1.F1_FILIAL='"+xFilial("SF1")+"' AND "
	cQuery += "SF1.D_E_L_E_T_ <> '*' AND "
	cQuery += "SD1.D1_FILIAL = '"+xFilial("SD1")+"' AND "
	cQuery += "SD1.D1_DOC = SF1.F1_DOC AND "
	cQuery += "SD1.D1_SERIE = SF1.F1_SERIE AND "
	cQuery += "SD1.D1_FORNECE = SF1.F1_FORNECE AND "
	cQuery += "SD1.D1_LOJA = SF1.F1_LOJA AND "
	cQuery += "SD1.D1_TIPO NOT IN ('D','B') AND "
	cQuery += "SD1.D_E_L_E_T_ <> '*' AND "
	cQuery += "SB1.B1_FILIAL ='"+xFilial("SB1")+"' AND "
	cQuery += "SB1.B1_COD = SD1.D1_COD AND "
	cQuery += "SB1.D_E_L_E_T_ <> '*' AND "
	cQuery += "SF4.F4_FILIAL ='"+xFilial("SF4")+"' AND "
	cQuery += "SF4.F4_CODIGO = SD1.D1_TES AND "
	cQuery += "SF4.D_E_L_E_T_ <> '*' AND "
	cQuery += "SA2.A2_FILIAL ='"+xFilial("SA2")+"' AND "
	cQuery += "SA2.A2_COD = SD1.D1_FORNECE AND "
	cQuery += "SA2.A2_LOJA = SD1.D1_LOJA AND "
	cQuery += "SA2.D_E_L_E_T_ <> '*' AND "               
	cQuery += "D1_COD >= '"  		    + MV_PAR01	+ "' AND "
	cQuery += "D1_COD <= '"  	        + MV_PAR02	+ "' AND "
	cQuery += "D1_DTDIGIT >= '" + DTOS(MV_PAR03)	+ "' AND "
	cQuery += "D1_DTDIGIT <= '" + DTOS(MV_PAR04)	+ "' AND "
	cQuery += "D1_GRUPO >= '"  		+ MV_PAR06	+ "' AND "
	cQuery += "D1_GRUPO <= '"  		+ MV_PAR07	+ "' AND "
	cQuery += "D1_FORNECE >= '"  		+ MV_PAR08	+ "' AND "
	cQuery += "D1_FORNECE <= '"  		+ MV_PAR09	+ "' AND "
	cQuery += "D1_LOCAL >= '"  		+ MV_PAR10	+ "' AND "
	cQuery += "D1_LOCAL <= '"  		+ MV_PAR11	+ "' AND "
	cQuery += "D1_DOC >= '"  	    	+ MV_PAR12	+ "' AND "
	cQuery += "D1_DOC <= '"  		    + MV_PAR13	+ "' AND "
	cQuery += "D1_SERIE >= '"  		+ MV_PAR14	+ "' AND "
	cQuery += "D1_SERIE <= '"  		+ MV_PAR15	+ "' AND "
	cQuery += "D1_TES >= '"  	        + MV_PAR16	+ "' AND "
	cQuery += "D1_TES <= '"  	        + MV_PAR17	+ "' "
	
	If nOrdem == 1
		cQuery += " ORDER BY 1,2,3,4,5,6,7"
	ElseIf nOrdem == 2
		cQuery += " ORDER BY 1,2,3,4,5,6"
	ElseIf nOrdem == 3
		cQuery += " ORDER BY 1,2,3,4,5,6"
	ElseIf nOrdem == 4
		cQuery += " ORDER BY 1,2,3,4,5,6"
	Endif
	cQuery := ChangeQuery(cQuery)
	MsAguarde({|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),'QRYSD1', .T., .T.)},OemToAnsi(STR0010)) //"Selecionado registros"
	
	For nX := 1 to Len(aStrucSD1)
		If aStrucSD1[nX,2] != 'C' .and. FieldPos(aStrucSD1[nx,1]) > 0
			TCSetField('QRYSD1', aStrucSD1[nX,1], aStrucSD1[nX,2],aStrucSD1[nX,3],aStrucSD1[nX,4])
		EndIf
	Next nX
	
	For nX := 1 to Len(aStrucSF1)
		If aStrucSF1[nX,2] != 'C'.and. FieldPos(aStrucSF1[nx,1]) > 0
			TCSetField('QRYSD1', aStrucSF1[nX,1], aStrucSF1[nX,2],aStrucSF1[nX,3],aStrucSF1[nX,4])
		EndIf
	Next nX
Else
	cQuery 	+= "D1_FILIAL == '" + xFilial("SD1") + "' .and. " +;
	"D1_DOC   >= '" + mv_par12 + "' .and. D1_DOC   <= '" + mv_par13 + "' .and. " +;
	"D1_SERIE >= '" + mv_par14 + "' .and. D1_SERIE <= '" + mv_par15 + "' .and. " +;
	"D1_COD   >= '" + mv_par01 + "' .and. D1_COD   <= '" + mv_par02 + "' .and. " +;
	"DTOS(D1_DTDIGIT) >= '" + DTOS(mv_par03) + "' .and. DTOS(D1_DTDIGIT) <= '" + DTOS(mv_par04) + "'"
	
	If nOrdem == 1
		dbSetOrder(1)
		IndRegua("SD1",cIndex,IndexKey(),,cQuery)
	Elseif nOrdem == 2
		dbSetOrder(2)
		IndRegua("SD1",cIndex,IndexKey(),,cQuery)
	Elseif nOrdem == 3
		IndRegua("SD1",cIndex,"D1_FILIAL + DTOS(D1_DTDIGIT) + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA",, cQuery)
	Elseif nOrdem == 4
		dbSetOrder(3)
		IndRegua("SD1",cIndex,IndexKey(),,cQuery)
	Endif
	
	nIndex := RetIndex("SD1")
	
	#IFNDEF TOP
		dbSetIndex(cIndex+OrdBagExt())
	#ENDIF
	
	dbSetOrder(nIndex+1)
	
	If nOrdem == 2
		dbSeek(xFilial() + mv_par01, .T.)
	Else
		dbSeek(xFilial(), .T.)
	Endif
Endif

//��������������������������������������������������������������Ŀ
//� Posiciona o cabecalho da Nota Fiscal                         �
//����������������������������������������������������������������
If !lQuery
	(cAliasSF1)->(dbseek((cAliasSD1)->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)))
	nTaxa  := (cAliasSF1)->F1_TXMOEDA
	nMoeda := (cAliasSF1)->F1_MOEDA
	dDtDig := (cAliasSF1)->F1_DTDIGIT
Endif

//��������������������������������������������������������������Ŀ
//� Seleciona Area do While e retorna o total Elementos da regua �
//����������������������������������������������������������������
dbselectArea(cAliasSD1)
SetRegua(SD1->(RecCount()))

cDocAnt := (cAliasSD1)->(D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA)

While !eof() .and. (cAliasSD1)->D1_FILIAL == xFilial("SD1")
	
	//��������������������������������������������������������������Ŀ
	//� Se cancelado pelo usuario                            	     �
	//����������������������������������������������������������������
	If lEnd
		@PROW()+1,001 PSAY STR0013	//"CANCELADO PELO OPERADOR"
		Exit
	Endif
	
	//��������������������������������������������������������������Ŀ
	//� Executa a validacao dos filtros do usuario           	     �
	//����������������������������������������������������������������
	lFiltro := IIf((!Empty(aReturn[7]).and.!&(aReturn[7])) .or.;
	(D1_COD     < mv_par01 .or. D1_COD     > mv_par02) .or. ;
	(D1_DTDIGIT < mv_par03 .or. D1_DTDIGIT > mv_par04) .or. ;
	(D1_GRUPO   < mv_par06 .or. D1_GRUPO   > mv_par07) .or. ;
	(D1_FORNECE < mv_par08 .or. D1_FORNECE > mv_par09) .or. ;
	(D1_LOCAL   < mv_par10 .or. D1_LOCAL   > mv_par11) .or. ;
	(D1_DOC     < mv_par12 .or. D1_DOC     > mv_par13) .or. ;
	(D1_SERIE   < mv_par14 .or. D1_SERIE   > mv_par15) .or. ;
	(D1_TES     < mv_par16 .or. D1_TES     > mv_par17),.F.,.T.)
	
	//��������������������������������������������������������������Ŀ
	//�Verifica moeda nao imprimir com moeda diferente da escolhida  �
	//����������������������������������������������������������������
	if mv_par20 == 2
		if if((cAliasSF1)->F1_MOEDA == 0,1,(cAliasSF1)->F1_MOEDA) != mv_par19
			lFiltro := .F.
		Endif
	Endif 
/*	
	If !Empty(mv_par19)
		If (D1_TES $ mv_par17)
			lFiltro := .F.
		EndIf			
	EndIf
*/	
	//��������������������������������������������������������������Ŀ
	//� Despreza Nota Fiscal Cancelada.                              �
	//����������������������������������������������������������������
	#IFDEF SHELL
		If D1_CANCEL == "S"
			lFiltro := .F.
		EndIf
	#ENDIF
	
	If lFiltro
		
		If li > 56
			cabec(Titulo,cabec1,cabec2,nomeprog,Tamanho,nTipo)
		Endif
		
		lImp := .T.
		
		//��������������������������������������������������������������Ŀ
		//� Faz a Quebra da Linha de descricao para todas ordems do Rela.�
		//����������������������������������������������������������������
		If lDescLine == .T.
			
			If nOrdem == 1 .and. mv_par05 == 1
				li++
				@li,000 PSAY STR0026 + (cAliasSD1)->D1_DOC + " " + (cAliasSD1)->D1_SERIE		 //" NUMERO : "
				@li,026 PSAY STR0027 + Dtoc((cAliasSD1)->D1_EMISSAO)		                     //" EMISSAO: "
				@li,045 PSAY STR0028 + Dtoc((cAliasSD1)->D1_DTDIGIT)		                     //" DIG.:    "
				@li,061 PSAY STR0029 + (cAliasSD1)->D1_TIPO				                     //" TIPO:    "
				
				If (cAliasSD1)->D1_TIPO $ "BD"
					@li,68 PSAY STR0030 + (cAliasSD1)->D1_FORNECE + " " + (cAliasSD1)->D1_LOJA	 //" CLIENTE    : "
					If !lQuery
						(cAliasSA1)->(dbSeek(xFilial() + (cAliasSD1)->D1_FORNECE + (cAliasSD1)->D1_LOJA))
					Endif
					@li,nPosNome PSAY SUBSTR((cAliasSA1)->A1_NOME,1,nTamNome)
				Else
					@li,68 PSAY STR0031 + (cAliasSD1)->D1_FORNECE + " " + (cAliasSD1)->D1_LOJA	 //" FORNECEDOR : "
					If !lQuery
						(cAliasSA2)->(dbSeek(xFilial() + (cAliasSD1)->D1_FORNECE + (cAliasSD1)->D1_LOJA))
						@li,nPosNome PSAY SUBSTR((cAliasSA2)->A2_NOME,1,nTamNome)
					Else
						@li,nPosNome PSAY SUBSTR((cAliasSA1)->A1_NOME,1,nTamNome)
					Endif
				EndIf
				
				li++
				@li,000 PSAY cCabec
				li++
				
			Elseif nOrdem == 2
				@li,000 PSAY STR0038 + (cAliasSD1)->D1_COD		  //"PRODUTO : "
				@li,027 PSAY STR0039		                      //"DESCRICAO : "
				
				If !lQuery
					If (cAliasSB1)->(dbSeek(xFilial() + (cAliasSD1)->D1_COD))
						@li,40 PSAY SubStr((cAliasSB1)->B1_DESC,1,29)
					Endif
				Else
					@li,40 PSAY SubStr((cAliasSB1)->B1_DESC,1,29)
				Endif
				
				@li ,72 PSAY STR0040			                 //"GRUPO : "
				@li ,81 PSAY (cAliasSB1)->B1_GRUPO
				li++
				@li,000 PSAY cCabec
				cCodAnt   := (cAliasSD1)->D1_COD
				nTotProd  := 0
				nTotQuant := 0
				
			Elseif nOrdem == 3 .or. nOrdem == 4
				If mv_par05 == 1
					@li,000 PSAY IIf(nOrdem == 3,STR0045,STR0061) //"DATA DE DIGITACAO : "  ### "DATA DE EMISSAO : "
					@li,020 PSAY IIf(nOrdem == 3,(cAliasSD1)->D1_DTDIGIT,(cAliasSD1)->D1_EMISSAO)
					@li+1,0 PSAY cCabec
				Endif
				li++
				dDataAnt := IIf(nOrdem == 3,(cAliasSD1)->D1_DTDIGIT,(cAliasSD1)->D1_EMISSAO)
				nTotData := 0
			Endif
			lDescLine := .F.
		Endif
		
		//��������������������������������������������������������������Ŀ
		//�Posiciona o F4 para todas as ordens quando nao for query TES  �
		//����������������������������������������������������������������
		If !lQuery
			(cAliasSF4)->(dbSeek(xFilial() + (cAliasSD1)->D1_TES))
		Endif
		
		//��������������������������������������������������������������Ŀ
		//�Impressao do corpo do relatorio para todas as ordems          �
		//����������������������������������������������������������������
		If nOrdem == 1 .or. (nOrdem == 3 .and. mv_par05 == 2) .or. (nOrdem == 4 .and. mv_par05 == 2)
			
			If mv_par05 == 1
				
				@li,00 PSAY (cAliasSD1)->D1_COD
				If !lQuery
					If (cAliasSB1)->(dbSeek(xFilial() + (cAliasSD1)->D1_COD))
						@li,021 PSAY SubStr((cAliasSB1)->B1_DESC,1,29)
					Endif
				Else
					@li,021 PSAY SubStr((cAliasSB1)->B1_DESC,1,29)
				Endif
				
				If cPaisLoc <> "BRA"
					
					nImpInc	  := 0
					nImpNoInc := 0
					nImpos	  := 0
					
					aImpostos := TesImpInf((cAliasSD1)->D1_TES)
					For nY := 1 to Len(aImpostos)
						cCampImp := (cAliasSD1)+"->" + (aImpostos[nY][2])
						nImpos   := &cCampImp
						nImpos   := xmoeda(nImpos,nMoeda,mv_par19,dDtDig,nDecs+1,nTaxa)
						If ( aImpostos[nY][3] == "1" )
							nImpInc	+= nImpos
						Else
							nImpNoInc += nImpos
						EndIf
					Next
					
					@li,051 PSAY (cAliasSD1)->D1_TES
					@li,055 PSAY nImpNoInc   Picture TM(nImpNoInc,9)
					@li,065 PSAY nImpInc     Picture TM(nImpInc,9)
					@li,078 PSAY (cAliasSD1)->D1_LOCAL
					
					nValImpInc	+= nImpInc
					nValImpNoInc+= nImpNoInc
					nValMerc 	:= nValMerc + xmoeda((cAliasSD1)->D1_TOTAL,nMoeda,mv_par19,dDtDig,nDecs+1,nTaxa)
					
					nTgImpInc 	+= nImpInc
					nTgImpNoInc += nImpNoInc
					nTotGeral 	:= nTotGeral + xmoeda((cAliasSD1)->D1_TOTAL - (cAliasSD1)->D1_VALDESC,nMoeda,mv_par19,dDtDig,nDecs+1,nTaxa)
					
					nValMerc    += nImpInc
					nTotGeral   += nImpInc
				Else
					@li,050 PSAY (cAliasSD1)->D1_CF
					@li,056 PSAY (cAliasSD1)->D1_TES
					@li,060 PSAY (cAliasSD1)->D1_PICM    Picture PesqPict("SD1","D1_PICM")
					@li,066 PSAY (cAliasSD1)->D1_IPI     Picture PesqPict("SD1","D1_IPI")
					@li,072 PSAY (cAliasSD1)->D1_LOCAL
					
					nValIcm   += (cAliasSD1)->D1_VALICM
					nValIpi   += (cAliasSD1)->D1_VALIPI
					nTgerIcm  += (cAliasSD1)->D1_VALICM
					nTgerIpi  += (cAliasSD1)->D1_VALIPI
					
					If (cAliasSF4)->F4_AGREG != "N"
						nValMerc  := nValMerc + (cAliasSD1)->D1_TOTAL + (cAliasSD1)->D1_ICMSRET
						nTotGeral := nTotGeral + (cAliasSD1)->D1_TOTAL - (cAliasSD1)->D1_VALDESC + (cAliasSD1)->D1_ICMSRET
						If (cAliasSF4)->F4_AGREG = "I"
							nValMerc  += (cAliasSD1)->D1_VALICM
							nTotGeral += (cAliasSD1)->D1_VALICM
						Endif
					Else
						nTotGeral := nTotGeral - (cAliasSD1)->D1_VALDESC + (cAliasSD1)->D1_ICMSRET
					Endif
					
					//��������������������������������������������������������������Ŀ
					//� Soma valor do IPI caso a nota nao seja compl. de IPI    	 �
					//� e o TES Calcula IPI nao seja "R"                             �
					//����������������������������������������������������������������
					If !lQuery
						If (cAliasSF4)->(dbSeek(xFilial() + (cAliasSD1)->D1_TES))
							If (cAliasSD1)->D1_TIPO != "P" .and. (cAliasSF4)->F4_IPI != "R"
								nValMerc  += (cAliasSD1)->D1_VALIPI
								nTotGeral += (cAliasSD1)->D1_VALIPI
							EndIf
						Else
							If (cAliasSD1)->D1_TIPO != "P"
								nValMerc  += (cAliasSD1)->D1_VALIPI
								nTotGeral += (cAliasSD1)->D1_VALIPI
							EndIf
						EndIf
					Else
						If (cAliasSD1)->D1_TIPO != "P" .and. (cAliasSF4)->F4_IPI != "R"
							nValMerc  += (cAliasSD1)->D1_VALIPI
							nTotGeral += (cAliasSD1)->D1_VALIPI
						ElseIf (cAliasSD1)->D1_TIPO != "P"
							nValMerc  += (cAliasSD1)->D1_VALIPI
							nTotGeral += (cAliasSD1)->D1_VALIPI
						EndIf
					Endif
				EndIf
				
				@li,084 PSAY (cAliasSD1)->D1_QUANT		Picture tm((cAliasSD1)->D1_QUANT,14)
				@li,101 PSAY xmoeda((cAliasSD1)->D1_VUNIT,nMoeda,mv_par19,dDtDig,nDecs+1,nTaxa) Picture pesqpict("SD1","D1_VUNIT",14,mv_par19)
				@li,115 PSAY xmoeda((cAliasSD1)->D1_TOTAL,nMoeda,mv_par19,dDtDig,nDecs+1,nTaxa) Picture pesqpict("SD1","D1_TOTAL",17,mv_par19)
				li++
				
				nValDesc  += xmoeda((cAliasSD1)->D1_VALDESC,nMoeda,mv_par19,dDtDig,nDecs+1,nTaxa)
				nTotDesco += xmoeda((cAliasSD1)->D1_VALDESC,nMoeda,mv_par19,dDtDig,nDecs+1,nTaxa)
				
			ElseIf mv_par05 == 2
				
				If cPaisLoc <> "BRA"
					aImpostos := TesImpInf((cAliasSD1)->D1_TES)
					For nY := 1 to Len(aImpostos)
						cCampImp := (cAliasSD1)+"->" + (aImpostos[nY][2])
						nImpos   := &cCampImp
						nImpos   := xmoeda(nImpos,(cAliasSF1)->F1_MOEDA,mv_par19,(cAliasSF1)->F1_DTDIGIT,nDecs+1,(cAliasSF1)->F1_TXMOEDA)
						If ( aImpostos[nY][3] == "1" )
							nImpInc	+= nImpos
						Else
							nImpNoInc += nImpos
						EndIf
					Next
					nValMerc := nValMerc + xmoeda(D1_TOTAL - D1_VALDESC,(cAliasSF1)->F1_MOEDA,mv_par19,(cAliasSF1)->F1_DTDIGIT,nDecs+1,(cAliasSF1)->F1_TXMOEDA)
				Else
					
					nValIcm  += (cAliasSD1)->D1_VALICM
					nValIpi  += (cAliasSD1)->D1_VALIPI
					
					If (cAliasSF4)->F4_AGREG != "N"
						nValMerc := nValMerc + (cAliasSD1)->D1_TOTAL - (cAliasSD1)->D1_VALDESC + (cAliasSD1)->D1_ICMSRET
						If (cAliasSF4)->F4_AGREG = "I"
							nValMerc += (cAliasSD1)->D1_VALICM
						Endif
					Else
						nValMerc := nValMerc - (cAliasSD1)->D1_VALDESC + (cAliasSD1)->D1_ICMSRET
					Endif
					
					If !lquery
						If (cAliasSF4)->(dbSeek(xFilial() + (cAliasSD1)->D1_TES))
							nValMerc += IF((cAliasSF1)->F1_TIPO != "P" .and. (cAliasSF4)->F4_IPI != "R",(cAliasSD1)->D1_VALIPI,0)
						Else
							nValMerc += IF((cAliasSF1)->F1_TIPO != "P",(cAliasSD1)->D1_VALIPI,0)
						EndIf
					Else
						If !Empty((cAliasSF4)->F4_IPI)
							nValMerc += IF((cAliasSF1)->F1_TIPO != "P" .and. (cAliasSF4)->F4_IPI != "R",(cAliasSD1)->D1_VALIPI,0)
						Else
							nValMerc += IF((cAliasSF1)->F1_TIPO != "P",(cAliasSD1)->D1_VALIPI,0)
						EndIf
					Endif
				EndIf
			Endif
		Else
			li++
			@li,00 PSAY (cAliasSD1)->D1_DOC
			If nOrdem == 2
				@li,13 PSAY (cAliasSD1)->D1_EMISSAO
				@li,22 PSAY (cAliasSD1)->D1_FORNECE
			Elseif nOrdem == 3 .or. nOrdem == 4
				@li,13 PSAY (cAliasSD1)->D1_COD
				@li,28 PSAY (cAliasSD1)->D1_FORNECE
			Endif
			
			If (cAliasSD1)->D1_TIPO $ "BD"
				If !lquery
					(cAliasSA1)->(dbSeek(xFilial() + (cAliasSD1)->D1_FORNECE + (cAliasSD1)->D1_LOJA))
				Endif
				@li,nPosNome PSAY SUBSTR((cAliasSA1)->A1_NOME,1,nTamNome)
			Else
				If !lquery
					(cAliasSA2)->(dbSeek(xFilial() + (cAliasSD1)->D1_FORNECE + (cAliasSD1)->D1_LOJA))
					@li,nPosNome PSAY SUBSTR((cAliasSA2)->A2_NOME,1,nTamNome)
				Else
					@li,nPosNome PSAY SUBSTR((cAliasSA1)->A1_NOME,1,nTamNome)
				Endif
			EndIf
			
			@li,060 PSAY (cAliasSD1)->D1_LOCAL
			If cPaisLoc == "BRA"
				@li,063 PSAY (cAliasSD1)->D1_CF
				@li,069 PSAY (cAliasSD1)->D1_TES
				@li,073 PSAY (cAliasSD1)->D1_PICM	Picture PesqPict("SD1","D1_PICM",5)
			Else
				@li,069 PSAY (cAliasSD1)->D1_TES
			EndIf
			@li,079 PSAY (cAliasSD1)->D1_IPI		Picture PesqPict("SD1","D1_IPI",5)
			@li,085 PSAY (cAliasSD1)->D1_TIPO
			@li,088 PSAY (cAliasSD1)->D1_QUANT	    Picture TM((cAliasSD1)->D1_QUANT,13)
			@li,102 PSAY xmoeda((cAliasSD1)->D1_VUNIT,nMoeda,mv_par19,dDtDig,nDecs+1,nTaxa) Picture pesqpict("SD1","D1_VUNIT",14,mv_par19)
			@li,118 PSAY xmoeda((cAliasSD1)->D1_TOTAL - (cAliasSD1)->D1_VALDESC + (cAliasSD1)->D1_ICMSRET,nMoeda,mv_par19,dDtDig,nDecs+1,nTaxa) Picture pesqpict("SD1","D1_TOTAL",14,mv_par19)
			
			If (cAliasSF4)->F4_AGREG != "N"
				nTotProd  += xmoeda((cAliasSD1)->D1_TOTAL - (cAliasSD1)->D1_VALDESC + (cAliasSD1)->D1_ICMSRET,nMoeda,mv_par19,dDtDig,nDecs+1,nTaxa)
				nTotQuant += (cAliasSD1)->D1_QUANT
				nTotData  += xmoeda((cAliasSD1)->D1_TOTAL - (cAliasSD1)->D1_VALDESC + (cAliasSD1)->D1_ICMSRET,nMoeda,mv_par19,,nDecs+1,nTaxa)
				If (cAliasSF4)->F4_AGREG = "I"
					nTotProd  += xmoeda((cAliasSD1)->D1_VALICM,nMoeda,mv_par19,dDtDig,nDecs+1,nTaxa)
					nTotData  += xmoeda((cAliasSD1)->D1_VALICM,nMoeda,mv_par19,,nDecs+1,nTaxa)
				Endif
			Else
				nTotProd  -= xmoeda((cAliasSD1)->D1_VALDESC + (cAliasSD1)->D1_ICMSRET,nMoeda,mv_par19,dDtDig,nDecs+1,nTaxa)
				nTotData  -= xmoeda((cAliasSD1)->D1_VALDESC + (cAliasSD1)->D1_ICMSRET,nMoeda,mv_par19,,nDecs+1,nTaxa)
			Endif
			
			lPrintLine:= .T.
			
		Endif
		
		// SF1.
		cFornF1     := (cAliasSF1)->F1_FORNECE
		cLojaF1     := (cAliasSF1)->F1_LOJA
		cDocF1      := (cAliasSF1)->F1_DOC
		cSerieF1    := (cAliasSF1)->F1_SERIE
		cTipoF1     := (cAliasSF1)->F1_TIPO
		cCondF1     := (cAliasSF1)->F1_COND
		nMoedaF1    := (cAliasSF1)->F1_MOEDA
		nTxMoedaF1  := (cAliasSF1)->F1_TXMOEDA
		nFreteF1    := (cAliasSF1)->F1_FRETE
		//nDespesaF1  := (cAliasSF1)->F1_DESPESA
		nSeguroF1   := (cAliasSF1)->F1_SEGURO
		dEmissaoF1  := (cAliasSF1)->F1_EMISSAO
		dDtDigitF1  := (cAliasSF1)->F1_DTDIGIT
		
		// SD1.
		nDespesaF1  += (cAliasSD1)->D1_DESPESA
		
		If lQuery
			cForCli  := (cAliasSF1)->A1_NOME
			cMuni    := (cAliasSF1)->A1_MUN
		Endif
		
	Endif
	
	//��������������������������������������������������������������Ŀ
	//�Incrementa a Regua de processamento no salto do registro      �
	//����������������������������������������������������������������
	dbSelectArea(cAliasSD1)
	dbSkip()
	cbCont++
	IncRegua()
	
	If nOrdem == 1 .or. (nOrdem == 3 .and. mv_par05 == 2) .or. (nOrdem == 4 .and. mv_par05 == 2)
		
		If ((cAliasSD1)->(D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA) != cDocAnt)
			
			If (nValIcm + nValMerc + nValIpi + nValImpInc + nValImpNoInc) > 0
				
				If mv_par05 == 1
					
					li++
					@li,000 PSAY STR0014 + cCondF1		                 //"COND. PAGTO :"
					@li,029 PSAY IIF(cPaisLoc == "BRA",STR0015,STR0051) //"TOTAL ICM :"
					
					If ( cPaisLoc == "BRA" )
						@li,040 PSAY nValIcm   	Picture tm((cAliasSF1)->F1_VALICM,15)
						@li,056 PSAY STR0016							 //"TOTAL IPI :"
						@li,067 PSAY nValIpi    Picture tm((cAliasSF1)->F1_VALIPI,15)
						
					Else
						@li,045 PSAY nValImpNoInc Picture pesqpict("SF1","F1_VALIMP1",15,mv_par19)
						@li,061 PSAY STR0056							 //"TOTAL IPI :"
						@li,077 PSAY nValImpInc Picture pesqpict("SF1","F1_VALIMP1",15,mv_par19)
					EndIf
					
					li++
					@li,000 PSAY STR0017							    //"FRETE :"
					@li,010 PSAY xmoeda(nFreteF1,nMoeda,mv_par19,dDtDig,nDecs+1,nTaxa) Picture pesqpict("SF1","F1_FRETE",15,mv_par19)
					@li,029 PSAY STR0018							    //"DESP.:"
					@li,040 PSAY xmoeda(nDespesaF1 + nSeguroF1,nMoeda,mv_par19,dDtDig,nDecs+1,nTaxa)Picture pesqpict("SF1","F1_DESPESA",15,mv_par19)
					@li,056 PSAY STR0019							    //"DESC.:"
					@li,067 PSAY nValDesc Picture pesqpict("SF1","F1_DESCONT",15,mv_par19)
					@li,096 PSAY STR0020							    //"TOTAL NOTA   :"
					@li,115 PSAY (nValMerc - nValDesc) + xmoeda(nDespesaF1 + nFreteF1 + nSeguroF1 ,nMoeda,mv_par19,dDtDig,nDecs+1,nTaxa) Picture pesqpict("SF1","F1_VALMERC",17,mv_par19)
					
					nTotGeral := nTotGeral + xmoeda(nDespesaF1 + nFreteF1 + nSeguroF1 ,nMoeda,mv_par19,dDtDig,nDecs+1,nTaxa)
					
					li++
					@li,000 PSAY __PrtThinLine()
					
				ElseIf mv_par05 == 2
					
					//��������������������������������������������������������������Ŀ
					//� Imprime a linha da nota fiscal                               �
					//����������������������������������������������������������������
					@li,000 PSAY cDocF1
					@li,013 PSAY cSerieF1
					@li,017 PSAY Iif(nOrdem == 3,dDtDigitF1,dEmissaoF1)
					@li,028 PSAY cFornF1
					
					If cTipoF1 $ "BD"
						If !lQuery
							(cAliasSA1)->(dbSeek( xFilial() + (cAliasSF1)->F1_FORNECE + (cAliasSF1)->F1_LOJA ))
							@li,nPosNome PSAY SubStr((cAliasSA1)->A1_NOME,1,nTamNome)
							@li,066 PSAY SubStr((cAliasSA1)->A1_MUN,1,15)
						Else
							@li,nPosNome PSAY SubStr(cForCli,1,nTamNome)
							@li,066 PSAY SubStr(cMuni,1,15)
						Endif
					Else
						If !lQuery
							(cAliasSA2)->(dbSeek( xFilial() + (cAliasSF1)->F1_FORNECE + (cAliasSF1)->F1_LOJA))
							@li,nPosNome PSAY SubStr((cAliasSA2)->A2_NOME,1,nTamNome)
							@li,066 PSAY SubStr((cAliasSA2)->A2_MUN,1,15)
						Else
							@li,nPosNome PSAY SubStr(cForCli,1,nTamNome)
							@li,066 PSAY SubStr(cMuni,1,15)
						Endif
					EndIf
					@li,082 PSAY cCondF1 Picture "!!!"
					If ( cPaisLoc == "BRA" )
						@li,086 PSAY nValIcm    Picture tm((cAliasSF1)->F1_VALICM ,14)
						@li,101 PSAY nValIpi    Picture tm((cAliasSF1)->F1_VALIPI ,14)
						@li,115 PSAY (nValMerc + nDespesaF1 + nFreteF1 + nSeguroF1) Picture tm((cAliasSF1)->F1_VALMERC,17)
						nTgerIcm += nValIcm
						nTgerIpi += nValIpi
					Else
						@li,086 PSAY nImpNoInc Picture pesqpict("SF1","F1_VALIMP1",14,mv_par19)
						@li,101 PSAY nImpInc   Picture pesqpict("SF1","F1_VALIMP1",14,mv_par19)
						@li,115 PSAY (nValMerc + xmoeda(nDespesaF1 + nFreteF1,nMoedaF1,mv_par19,dDtDigitF1,nDecs+1,nTxMoedaF1)) Picture pesqpict("SF1","F1_VALMERC",17,mv_par19)
						nTgImpInc   += nImpInc
						nTgImpNoInc += nImpNoInc
					EndIf
					li++
					
					nTotGeral:= nTotGeral + nValMerc + xmoeda(nDespesaF1 + nFreteF1 + nSeguroF1,nMoedaF1,mv_par19,dDtDigitF1,nDecs+1,nTxMoedaF1 )
					
					nTotData := nTotData + nValMerc + xmoeda(nDespesaF1 + nFreteF1 + nSeguroF1,nMoedaF1,mv_par19,dDtDigitF1,nDecs+1,nTxMoedaF1 )
					
					If (dDataAnt != (cAliasSD1)->D1_DTDIGIT) .and. nOrdem == 3 .or. (dDataAnt != (cAliasSD1)->D1_EMISSAO) .and. nOrdem == 4
						lDescLine := .T.
						li++
						@li,000  PSAY STR0046		//"TOTAL NA DATA : "
						@li,115  PSAY  nTotData  Picture pesqpict("SD1","D1_TOTAL",17,mv_par19)
						li++
						@li,000 PSAY __PrtThinLine()
						li++
					Endif
					
				Endif
				
			Endif
			
			cDocAnt := (cAliasSD1)->(D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA)
			
			nValIpi     := 0
			nValMerc    := 0
			nValDesc    := 0
			nValIcm     := 0
			nValImpInc	:= 0
			nValImpNoInc:= 0
			nImpInc		:= 0
			nImpNoInc	:= 0
			nDespesaF1  := 0
			If nOrdem <> 3 .or. nOrdem <> 4
				lDescLine  := .T.
			Endif
		Endif
		
	Elseif nOrdem == 2
		
		If cCodant != (cAliasSD1)->D1_COD .and. lFiltro
			lDescLine := .T.
			li++
			@li,000  PSAY  STR0041		//"TOTAL DO PRODUTO : "
			@li,085  PSAY  nTotQuant Picture pesqpict("SD1","D1_TOTAL",16)
			@li,115  PSAY  nTotProd  Picture pesqpict("SD1","D1_TOTAL",17,mv_par19)
			li++
			@li,000 PSAY __PrtThinLine()
			li++
			nTotQger   += nTotQuant
			nTotGeral  += nTotProd
		Endif
		
	Elseif nOrdem == 3 .or. nOrdem == 4
		
		If dDataAnt != Iif(nOrdem == 3,(cAliasSD1)->D1_DTDIGIT,(cAliasSD1)->D1_EMISSAO) .and. lPrintLine // nTotData > 0
			lDescLine := .T.
			li++
			@li,000  PSAY STR0046		//"TOTAL NA DATA : "
			@li,115  PSAY  nTotData  Picture pesqpict("SD1","D1_TOTAL",17,mv_par19)
			li++
			@li,000 PSAY __PrtThinLine()
			li++
			nTotGeral += nTotData
			dDataAnt := Iif(nOrdem == 3,(cAliasSD1)->D1_DTDIGIT,(cAliasSD1)->D1_EMISSAO)
			nTotData := 0
			lPrintLine := .F.
		Endif
		
	Endif
	If !lquery
		(cAliasSF1)->(dbseek((cAliasSD1)->D1_FILIAL + (cAliasSD1)->D1_DOC + (cAliasSD1)->D1_SERIE + (cAliasSD1)->D1_FORNECE + (cAliasSD1)->D1_LOJA)) //posiciona o cabecalho da nota
	Endif
	nTaxa  := (cAliasSF1)->F1_TXMOEDA
	nMoeda := (cAliasSF1)->F1_MOEDA
	dDtDig := (cAliasSF1)->F1_DTDIGIT
EndDo

If lImp
	li++
	If li > 56
		cabec(Titulo,cabec1,cabec2,nomeprog,Tamanho,nTipo)
	Endif
	@li,000  PSAY STR0042	                                                 //"T O T A L  G E R A L : "
	If nOrdem == 1 .and. MV_PAR05 == 1
		If (nTgerIcm + nTgerIpi + nTotGeral + nTgImpInc + nTgImpNoInc) > 0
			@li,027 PSAY IIF(cPaisLoc == "BRA",STR0022,STR0052)	        //"ICM :"
			If ( cPaisLoc=="BRA" )
				@li,036 PSAY nTgerIcm		Picture tm(nTGerIcm,15)
				@li,052 PSAY STR0023			                            //"IPI :"
				@li,063 PSAY nTgerIpi		Picture tm(nTGerIpi,15)
			Else
				@li,036 PSAY nTgImpNoInc Picture tm(nTGImpNoInc,15,nDecs)
				@li,052 PSAY STR0057			                            //"IPI :"
				@li,063 PSAY nTgImpInc Picture tm(nTGImpInc,15,nDecs)
			EndIf
			@li,080 PSAY STR0024			                               //"DESC.:"
			@li,088 PSAY nTotDesco Picture tm(nTotDesco,13,nDecs)
			@li,105 PSAY STR0025			                               //"TOTAL :"
		Endif
	ElseIf (nOrdem == 1 .or. nOrdem == 3 .or. nOrdem == 4) .and. MV_PAR05 == 2
		If (cPaisLoc == "BRA")
			@li,086 PSAY nTgerIcm  Picture tm(nTGerIcm,14)
			@li,101 PSAY nTgerIpi  Picture tm(nTGerIpi,14)
		Else
			@li,086 PSAY nTgImpNoInc  Picture tm(nTGImpNoInc,14,nDecs)
			@li,101 PSAY nTgImpInc  Picture tm(nTGImpInc,14,nDecs)
		Endif
	ElseIf nOrdem == 2
		@li,087  PSAY  nTotQger  Picture pesqpict("SD1","D1_QUANT",14)
	Endif
	
	@li,115 PSAY nTotGeral Picture tm(nTotGeral,17,nDecs)
	
	Roda(cbcont,cbtext,Tamanho)
Endif

dbCloseArea(cAliasSD1)
dbSelectArea("SD1")
Set Filter To
dbSetOrder(1)
RetIndex("SD1")
If File(cIndex + OrdBagExt())
	Ferase(cIndex + OrdBagExt())
Endif
If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	ourspool(wnrel)
Endif
MS_FLUSH()
Return(.T.)