#INCLUDE "CCOMR01.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "_FixSX.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR440  � Autor � Eveli Morasco         � Data � 16/04/93 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Lista os itens que atingiram o ponto de pedido             ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���Marcelo P.S.�17/11/97�12601A� Incluir pergunta:para considerar C.Q.    ���
���Rogerio F.G.�02/12/97�13690A� Ajuste Utiliza. Cpo B1_QE, B1_LM         ���
���Marcelo P.  �13/02/98�xxxxxx� Ajuste no Campo B1_QE.                   ���
���Rodrigo     �19/02/98�11231A� Ajuste no Calculo da necessida qdo usa   ���
���            �        �      � Ponto de Pedido (B1_EMIN)                ���
���Eduardo     �21.05.98�16326A� Acerto para considerar Estoque de Seg.   ���
���Rodrigo Sart�11/09/98�6742A � Ajuste Utiliza. Cpo B1_QE, B1_LM         ���
���Rodrigo Sart�05/11/98�XXXXXX� Acerto p/ Bug Ano 2000                   ���
���Edson       �25.11.98�18720 � Correcao no calculo do saldo por almox.  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CCOMR01   �Autor  �Felipe Raposo       � Data �  11/11/02   ���
�������������������������������������������������������������������������͹��
���Desc.     � Emissao de relatorio de produtos em ponto de pedido.       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CIEE.                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CCOMR01()

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis.                                            �
//�����������������������������������������������������������������������
Local wnrel
Local Tamanho  := "G"
Local cDesc1   := STR0001	//"Emite uma relacao com os itens em estoque que atingiram o Ponto de"
Local cDesc2   := STR0002	//"Pedido, sugerimdo a quantidade a comprar."
Local cDesc3   := ""

//��������������������������������������������������������������Ŀ
//� Variaveis tipo Private padrao de todos os relatorios         �
//����������������������������������������������������������������
Private nomeprog := "MATR440"
Private cString  := "SB1"
Private aReturn  := {OemToAnsi(STR0003), 1, OemToAnsi(STR0004), 1, 2, 1, "", 1}		//"Zebrado"###"Administracao"
Private nLastKey := 0, cPerg
Private titulo   := OemToAnsi(STR0005)		//"Itens em Ponto de Pedido"
//��������������������������������������������������������������Ŀ
//� Contadores de linha e pagina                                 �
//����������������������������������������������������������������
Private li := 80, m_pag := 1

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01             // Produto de                           �
//� mv_par02             // Produto ate                          �
//� mv_par03             // Grupo de                             �
//� mv_par04             // Grupo ate                            �
//� mv_par05             // Tipo de                              �
//� mv_par06             // Tipo ate                             �
//� mv_par07             // Local de                             �
//� mv_par08             // Local ate                            �
//����������������������������������������������������������������
_aPerg := {}
cPerg := "MT170b    "
aAdd (_aPerg, {cPerg, "01", "Produto de         ?", "�De Producto       ?", "From Product       ?", "mv_ch1", "C", 15, 0, 0, "G", "", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SB1", "", ""})
aAdd (_aPerg, {cPerg, "02", "Produto at�        ?", "�A  Producto       ?", "To Product         ?", "mv_ch2", "C", 15, 0, 0, "G", "", "mv_par02", "", "", "", "ZZZZZZZZZZZZZZZ", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SB1", "", ""})
aAdd (_aPerg, {cPerg, "03", "Grupo de           ?", "�De Grupo          ?", "From Group         ?", "mv_ch3", "C", 4, 0, 0, "G", "", "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SBM", "", ""})
aAdd (_aPerg, {cPerg, "04", "Grupo at�          ?", "�A  Grupo          ?", "To Group           ?", "mv_ch4", "C", 4, 0, 0, "G", "", "mv_par04", "", "", "", "ZZZZ", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SBM", "", ""})
aAdd (_aPerg, {cPerg, "05", "Tipo de            ?", "�De Tipo           ?", "From Type          ?", "mv_ch5", "C", 2, 0, 0, "G", "", "mv_par05", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "02", "", ""})
aAdd (_aPerg, {cPerg, "06", "Tipo at�           ?", "�A  Tipo           ?", "To Type            ?", "mv_ch6", "C", 2, 0, 0, "G", "", "mv_par06", "", "", "", "ZZ", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "02", "", ""})
aAdd (_aPerg, {cPerg, "07", "Endereco de        ?", "�De Ubicacion      ?", "From Address       ?", "mv_ch7", "C", 2, 0, 0, "G", "", "mv_par07", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
aAdd (_aPerg, {cPerg, "08", "Endereco ate       ?", "�A  Ubicacion      ?", "To Address         ?", "mv_ch8", "C", 2, 0, 0, "G", "", "mv_par08", "", "", "", "ZZ", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
AjustaSX1(_aPerg)
Pergunte(cPerg, .F.)

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
wnrel := SetPrint(cString, NomeProg, cPerg, @titulo, cDesc1, cDesc2, cDesc3, .F., "", .F., Tamanho)

If nLastKey = 27
	Set Filter To
	Return
Endif
SetDefault(aReturn, cString)
If nLastKey = 27
	Set Filter To
	Return
Endif
RptStatus({|lEnd| R440Imp(@lEnd, tamanho, wnrel, cString)}, Titulo)
Return .T.


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � R440IMP  � Autor � Cristina M. Ogura     � Data � 09.11.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relatorio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR440                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function R440Imp(lEnd, tamanho, wnrel, cString)
Local nQuant := nSaldo := 0, nValUnit, nValor, nValTot, cTipoVal, nPrazo, _aAux1
Local nToler, nEstSeg, nNeces := 0
Local nCntImpr := 0
Local cRodaTxt := STR0006	//"PRODUTO(S)"
Local nTipo    := 0
Local cabec1, cabec2, cabec3
Local limite   := 132
Local cbCont   := 0
Local cLocCQ   := GetMV("MV_CQ")
//�������������������������������������������������������������������Ŀ
//� Inicializa os codigos de caracter Comprimido/Normal da impressora �
//���������������������������������������������������������������������
nTipo  := IIF(aReturn[4] == 1, 15, 18)

//��������������������������������������������������������������Ŀ
//� Monta os Cabecalhos                                          �
//����������������������������������������������������������������
cabec1 := STR0007
cabec2 := STR0008
***** "CODIGO          DESCRICAO                      TP GRP  UM  SALDO ATUAL     PONTO DE   ESTOQUE DE         LOTE ___TOLERANCIA___   QUANTIDADE QUANTIDADE A   VALOR ESTIMADO BASE  DATA DE   VALOR UNITARIO     PRAZO DE"
***** "                                                                             PEDIDO    SEGURANCA    ECONOMICO   %   QUANTIDADE   POR EMBAL.      COMPRAR        DA COMPRA      REFERENCIA      DA COMPRA      ENTREGA"
***** "123456789012345 123456789012345678901234567890 12 1234 12 9.999.999,99 9.999.999,99 9.999.999,99 9.999.999,99 999 9.999.999,99 9.999.999,99 9.999.999,99 9.999.999.999,99 XXXX 99/99/9999 999.999.999,99 99999 Dia(s)"
***** "0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21  "
***** "012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012"

dbSelectArea(cString)
Set Filter to B1_AUTOSC == "1" .and.;  // Gera SC por PP?  1 - Sim
(B1_GRUPO >= mv_par03 .and. B1_GRUPO <= mv_par04) .and.;
(B1_TIPO  >= mv_par05 .and. B1_TIPO  <= mv_par06) .and.;
SubStr(B1_COD, 1, 3) != "MOD" .and. B1_TIPO != "BN" .and. B1_CONTRAT != "S"

nValTot := 0
SetRegua(RecCount())

Set SoftSeek On
dbSeek(cFilial + mv_par01)
Set SoftSeek Off
Do While !Eof() .and. B1_FILIAL + B1_COD <= cFilial + mv_par02
	
	If lEnd
		@PROW() + 1, 001 PSAY STR0009		//"CANCELADO PELO OPERADOR"
		Exit
	Endif
	
	IncRegua()
	
	//�����������������������������������������������������������Ŀ
	//� Filtra grupos e tipos nao selecionados e tambem se for MOD�
	//�������������������������������������������������������������
	/*
	If	(B1_GRUPO < mv_par03 .or. B1_GRUPO > mv_par04) .or.;
		(B1_TIPO  < mv_par05 .or. B1_TIPO  > mv_par06) .or.;
		SubStr(B1_COD, 1, 3) == "MOD" .or. B1_TIPO == "BN" .or.;
		B1_CONTRAT == "S"
		dbSkip()
		Loop
	Endif
	*/
	
	//�����������������������������������������������������������Ŀ
	//� Direciona para funcao que calcula o necessidade de compra �
	//�������������������������������������������������������������
	//�������������������������������������������������Ŀ
	//� Calcula o saldo atual de todos os almoxarifados �
	//���������������������������������������������������
	/*
	dbSelectArea("SB2")
	dbSeek(cFilial + SB1->B1_COD)
	Do While !eof() .and. B2_FILIAL + B2_COD == cFilial + SB1->B1_COD
		//�������������������������������������������Ŀ
		//� Inclui os produtos que estao no C.Q.      �
		//���������������������������������������������
		If  (B2_LOCAL < mv_par07 .or. B2_LOCAL > mv_par08) .or.;
			(B2_LOCAL == cLocCQ .and. mv_par11 == 2)
			dbSkip()
			Loop
		Endif
		nSaldo += (SaldoSB2(nil, nil, nil, mv_par12 == 1, mv_par13 == 1) + B2_SALPEDI) - B2_QPEDVEN
		dbSkip()
	EndDo
	*/
	/*
	nEstSeg := CalcEstSeg(SB1->B1_ESTFOR)
	nSaldo -= nEstSeg
	If (Round(nSaldo, 4) != 0) .or. (mv_par09 == 1)
		Do Case
			Case (SB1->B1_EMIN != 0 .and. MV_PAR09 == 1)
				nNeces := IIf((nSaldo < 0), Abs(nSaldo) + SB1->B1_EMIN, (SB1->B1_EMIN - nSaldo))
			Case (SB1->B1_EMIN != 0 .and. MV_PAR09 == 2)
				nNeces := IIf((nSaldo < 0), Abs(nSaldo), (SB1->B1_EMIN - nSaldo))
			Case (SB1->B1_LE != 0 .and. (nSaldo < 0  .or. mv_par09 == 2))
				If (MV_PAR10 == 2 .and. nSaldo < 0)
					nNeces := Abs(nSaldo) + SB1->B1_LE
				Else
					nNeces := If(Abs(nSaldo) < SB1->B1_LE, SB1->B1_LE, IIf(nSaldo < 0, Abs(nSaldo), 0))
				Endif
			OtherWise
				nNeces := IF(MV_PAR09 == 1, IIf(nSaldo < 0, Abs(nSaldo), 0), 0)
		EndCase
	Else
		If SB1->B1_EMIN != 0
			nNeces := (SB1->B1_EMIN)
		Else
			nNeces := 0
		Endif
	Endif
	*/
	/*
	If nNeces > 0
		//�����������������������������������������������������������Ŀ
		//� Verifica se o produto tem estrutura                       �
		//�������������������������������������������������������������
		dbSelectArea("SG1")
		If dbSeek(xFilial() + SB1->B1_COD)
			aQtdes := CalcLote(SB1->B1_COD, nNeces, "F")
		Else
			aQtdes := CalcLote(SB1->B1_COD, nNeces, "C")
		Endif
		For nX := 1 to Len(aQtdes)
			nQuant += aQtdes[nX]
		Next
	Endif
	dbSelectArea("SB1")
	*/
	_aAux1 := U_GeraSC(.F.)
	nSaldo := _aAux1[1]
	nQuant := _aAux1[2]
	
	If nQuant > 0
		
		//���������������������������������������������Ŀ
		//� Pega o prazo de entrega do material         �
		//�����������������������������������������������
		nPrazo := CalcPrazo(SB1->B1_COD, nQuant)
		dbSelectArea("SB1")
		
		//���������������������������������������������Ŀ
		//� Calcula a tolerancia do item                �
		//�����������������������������������������������
		nToler   := (B1_LE * B1_TOLER) / 100
		
		If li > 55
			Cabec(titulo, cabec1, cabec2, nomeprog, Tamanho, nTipo)
		Endif
		
		//�������������������������������������������������������Ŀ
		//� Adiciona 1 ao contador de registros impressos         �
		//���������������������������������������������������������
		nCntImpr++
		
		//���������������������������������������������������������Ŀ
		//� Verifica qual dos precos e' mais recente servir de base �
		//�����������������������������������������������������������
		If B1_UCOM < B1_DATREF
			cTipoVal := "STD"
			dData    := B1_DATREF
			nValUnit := B1_CUSTD
		Else
			cTipoVal := "U.CO"
			dData    := B1_UCOM
			nValUnit := B1_UPRC
		Endif
		nValor := nQuant * nValUnit
		
		@ li, 000 PSAY B1_COD
		@ li, 016 PSAY SubStr(B1_DESC, 1, 30)
		@ li, 047 PSAY B1_TIPO
		@ li, 050 PSAY B1_GRUPO
		@ li, 055 PSAY B1_UM
		@ li, 058 PSAY nSaldo    Picture PesqPictQt("B2_QATU", 12)
		@ li, 071 PSAY B1_EMIN   Picture PesqPictQt("B1_EMIN", 12)
		@ li, 084 PSAY nESTSEG   Picture PesqPictQt("B1_ESTSEG", 12)
		@ li, 097 PSAY B1_LE     Picture PesqPictQt("B1_LE", 12)
		@ li, 110 PSAY B1_TOLER  Picture "999"
		@ li, 114 PSAY nToler    Picture PesqPictQt("B1_LE", 12)
		@ li, 127 PSAY B1_QE     Picture PesqPictQt("B1_LE", 12)
		@ li, 140 PSAY nQuant    Picture PesqPictQt("B1_LE", 12)
		@ li, 153 PSAY nValor    Picture TM(nValor, 16)
		@ li, 170 PSAY cTipoVal
		@ li, 175 PSAY dData
		@ li, 186 PSAY nValUnit  Picture TM(nValUnit, 14)
		@ li, 201 PSAY nPrazo    Picture "99999"
		@ li, 207 PSAY OemtoAnsi(STR0011)  //  "Dia(s)"
		nValTot += nValor
		li++
	Endif
	
	nSaldo := 0
	nQuant := 0
	dbSelectArea("SB1")
	dbSkip()
EndDo

If li != 80
	Li++
	@ li, 000 PSAY STR0010 + Replicate(".", 131)		//"TOTAL GERAL A COMPRAR"
	@ li, 153 PSAY nValTot Picture TM(nValTot, 16)
	Roda(nCntImpr, cRodaTxt, Tamanho)
Endif

//��������������������������������������������������������������Ŀ
//� Devolve a condicao original do arquivo principal             �
//����������������������������������������������������������������
dbSelectArea(cString)
Set Filter To
Set Order To 1
If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif
MS_FLUSH()
Return .T.