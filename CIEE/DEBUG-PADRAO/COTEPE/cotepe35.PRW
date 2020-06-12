#INCLUDE "PROTHEUS.CH"
#INCLUDE "COTEPE35.CH"

Static lCOTE140 := ExistBlock("COTE140")
Static lCOTD200 := ExistBlock("COTD200")
Static lCOTD030 := ExistBlock("COTD030")
Static lCOTD050 := ExistBlock("COTD050")
Static lCOTB440 := ExistBlock("COTB440")
Static lCOTEP02 := ExistBlock("COTEPE02")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ COTEPE35 ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Preparacao do meio-magnetico para atender a exigencia do    ³±±
±±³          ³ Ato Cotepe 35 de 17/06/2005. DOU(13/07/2005)               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Funcao inicial do processamento. Esta funcao apresenta ao   ³±±
±±³          ³ usuario o wizard de configuracao, recebe os parametros e   ³±±
±±³          ³ chama a funcao PrCotepe, responsavel pelo processamento    ³±±
±±³          ³ dos livros fiscais e geracao do meio magnetico.            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Tabelas   ³As tabelas abaixo devem estar alimentadas corretamente e re-³±±
±±³          ³ lacionadas entre si atraves dos campos chaves para manter a³±±
±±³          ³ integridade das informacoes extraidas para o meio-magnetico³±±
±±³          ³ em questao.                                                ³±±
±±³          ³SFT -> Livros Fiscais Por Item de documento Fiscal.         ³±±
±±³          ³SF3 -> Livros Fiscais Padrao                                ³±±
±±³          ³SF1 -> Cabecalho das notas fiscais de entrada               ³±±
±±³          ³SF2 -> Cabecalho das notas fiscais de saida                 ³±±
±±³          ³SD1 -> Itens das notas fiscais de entrada                   ³±±
±±³          ³SD2 -> Itens das notas fiscais de saida                     ³±±
±±³          ³SB1 -> Cadastro de Produtos                                 ³±±
±±³          ³SB5 -> Complemento do Cadastro de Produtos                  ³±±
±±³          ³SA1 -> Cadastro de Clientes                                 ³±±
±±³          ³SA2 -> Cadastro de fornecedores                             ³±±
±±³          ³SE4 -> Cadastro de Condicao de pagamento                    ³±±
±±³          ³SE2 -> Contas a Pagar                                       ³±±
±±³          ³SE1 -> Contas a Receber                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function COTEPE35()
Local	lEnd		:= .F.
Local	cPerg		:= PadR("COTEPE",Len(SX1->X1_GRUPO))
Local	cNomWiz		:= ""
Local	nI			:= 0
Local	aWizard		:= {}
Local	aRegra		:= {}
Local	aStrCmps	:= {}
Local	aTrbs		:= {}
Local	aTitulo		:= {}
Local	aListaFil	:= {}
Local	nArqVal		:= 0
Local	cFile		:= ""

Private lBloqCD		:= .T.
Private lSimples	:= .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Chamada para o Wizard da rotina³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Pergunte(cPerg,.T.)
	If MV_PAR01 == 2
		If MV_PAR04 == 2
			aListaFil := MatFilCalc(MV_PAR02 == 1)
		Else
			aListaFil := MatFilCalc(MV_PAR02 == 1,,,MV_PAR02 == 1 .AND. MV_PAR04 == 1, , 2 ) //Parametro Exp6 Valida apenas CNPJ+IE iguais
		Endif
		cNomWiz := "COTEPE35" + FWGrpCompany() + FWGETCODFILIAL
		If !(Cot35MontWiz (cNomWiz))
			Return	//Se o wizard for cancelado aborto o processamento.
		EndIf
		Processa({||PrCotepe(@lEnd, aWizard, aListaFil)})
	Else
		If FindFunction("TRepInUse")
			If TRepInUse()
				cNomWiz := "RCOTEPE35" + FWGrpCompany() + FWGETCODFILIAL
				If !(Cot35MontWiz (cNomWiz))
					Return	//Se o wizard for cancelado aborto o processamento.
				EndIf
				If (!xMagLeWiz (cNomWiz, @aWizard, .T.))
					Return	//Se por algum motivo a leitura do CFP falhar aborto a rotina.
				EndIf
				aTrbs := LeTxt(@aRegra,@aStrCmps,@aTitulo,aWizard,@nArqVal,@cFile)
				If nArqVal==0
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Interface de impressao                                                  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					oReport := ReportDef(aTrbs,aRegra,aStrCmps,aTitulo,cFile)
					oReport:PrintDialog()
				ElseIf nArqVal==1
					xMagHelpFis(STR0951,STR0949,STR0952)	//"Atenção"###"Arquivo texto base para a geração deste relatório de conferência é incompatível com a estrutura definida no ATO COTEPE N. 35/05, DE 17 DE JUNHO DE 2005."###"Selecione um arquivo válido para utilização desta rotina. Este arquivo deve ser gerado de acordo com as implementações do boletim técnico da rotina."
				ElseIf nArqVal==2
					xMagHelpFis(STR0951,STR0950,STR0952)	//"Atenção"###"Arquivo inexistente no diretório especificado."###"Selecione um arquivo válido para utilização desta rotina. Este arquivo deve ser gerado de acordo com as implementações do boletim técnico da rotina."
				EndIf
				For nI:= 1 To Len(aTrbs)
					If File(aTrbs[ni,1]+GetDBExtension())
						dbSelectArea(aTrbs[ni,2])
						dbCloseArea()
						Ferase(aTrbs[ni,1]+GetDBExtension())
						Ferase(aTrbs[ni,1]+OrdBagExt())
					Endif
				Next
			EndIf
		Else
			MsgInfo(STR0974) //"Opção somente disponível à partir da versão 8.11 Release 4."
		EndIf
	EndIf
EndIf
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ PrCotepe ³ Autor ³Gustavo Rueda/Liber Esteban ³ 28/08/2006 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Preparacao do meio-magnetico para atender a exigencia do    ³±±
±±³          ³ Ato Cotepe 35 de 17/06/2005. DOU(13/07/2005)               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Funcao principal de processamento. Esta funcao tem como     ³±±
±±³          ³ objetivo filtrar a tabela SFT(Livros Fiscais por item) e   ³±±
±±³          ³ montar os registros necessarios atraves de funcoes auxilia-³±±
±±³          ³ res.                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³aWizard -> Array com parametros informados pelo usuario no  ³±±
±±³          ³Wizard de configuracao do meio magnetico                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function PrCotepe(lEnd,aWizard,aListaFil, lJob)
Local	aAreaSM0		:=	SM0->(GetArea ())
Local	cFilDe			:=	""
Local	cFilAte			:=	""
Local	cFiltro			:=	""
Local	dDataDe			:=	CToD ("//")
Local	dDataAte		:=	CToD ("//")
Local	dDataInv		:=	CToD ("//")
Local	cAliasSFT		:=	"SFT"
Local	cAliasTrb		:=	""
Local	cAliasFIN		:=	""
Local	cNomeCfp		:=	"COTEPE35" + FWGrpCompany() + FWGETCODFILIAL
Local	cAlias			:=	""
Local	aMVCEINITS		:=	IIf(Empty(SuperGetMv("MV_CEINITS")),{},&(SuperGetMv("MV_CEINITS")))	//Array contendo campos da Tabela SA1/SA2 no seguinte formato: {"CAMPO CEI SA1","CAMPO CEI SA2","CAMPO NIT SA1","CAMPO NIT SA2","CAMPO SUFRAMA SA1","CAMPO SUFRAMA SA2","CAMPO COD PAIS SA1","CAMPO CODPAIS SA2"}
Local	aMVMUNIBGE		:=	IIf(Empty(SuperGetMv("MV_MUNIBGE")),{},&(SuperGetMv("MV_MUNIBGE")))	//Array contendo campos da Tabela SA1/SA2 no seguinte formato: {"COD MUIN SA1","COD MUN SA2"}
Local	aPartDoc		:=	{}
Local	aReg0400		:=	{}
Local	cAlsSF			:=	""
Local	cAlsSD			:=	""
Local	cAlsSA			:=	""
Local	cEntSai			:=	""
Local	cEspecie		:=	""
Local	cCmpCond		:=	""
Local	aTotaliza		:=	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
Local	aTotalISS		:=	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
Local	nRelacDoc		:=	0
Local	aCmpAntSFT		:=	{}
Local	aReg0450		:=	{}
Local	aRegA020		:=	{}
Local	aRegA300		:=	{}
//Local	aRegA025		:=	{"A025", 0, 0, 0, 0, 0, 0, 0, 0, 0}
//Local	aRegA035		:=	{"A035", 0, 0, 0, 0, 0, 0, 0, 0, 0}
Local	aRegA200		:=	{}
Local	aRegA310		:=	{}
Local	aRegB025		:=	{}
Local	aRegB030		:=	{}
Local	aRegB035		:=	{}
Local	aRegB040		:=	{}
Local	aRegB045		:=	{}
Local	aRegB050		:=	{}
Local	aRegB055		:=	{}
Local	aRegB350		:=	{}
Local	aRegB410		:=	{}
Local	aRegB420		:=	{}
Local	aRegB430		:=	{}
Local	aRegB440		:=	{}
Local	aRegB450		:=	{}
Local	aRegB460		:=	{}
Local	aRegB465		:=	{ Nil , 0 , 0 , 0	, 0 , 0	, 0 }
Local	aRegB470		:=	{"B470", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
Local	aRegB475		:=	{}
Local	aRegB480		:=	{}
Local	aRegB490		:=	{}
Local	aRegC020		:=	{}
Local	aRegC300		:=	{}
Local 	aRegC600		:=	{}
Local 	aRegE060		:=	{}
Local 	aRegE065		:=	{}
Local 	aRegE080		:=	{}
Local 	aRegE085		:=	{}
Local	aRegC050		:=	{"C050", 0, 0, 0, 0}
Local	cMVMEDICA		:=	SuperGetMv("MV_MEDICA") //Grupos de produtos separados por "/" que identifica Medicamentos
Local	cMVARMFOG		:=	SuperGetMv("MV_ARMFOG") //Grupos de produtos separados por "/" que identifica Armas de Fogo
Local	cMVVEICNV		:=	SuperGetMv("MV_VEICNV") //Grupos de produtos separados por "/" que identifica Veiculos Novos
Local	cMVRC320		:=	SuperGetMv("MV_RC320")
Local	aMVRC320		:=	Iif (Len (&(cMVRC320))<>4, {}, &(cMVRC320)) //Campos necessarios para o produto tipo Arma de fogo
Local	cMVRC325		:=	SuperGetMv("MV_RC325")
Local	aMVRC325		:=	Iif (Len (&(cMVRC325))<>1, {}, &(cMVRC325)) //Campos necessarios para o produto tipo Veiculo Novo
Local	aObs			:=	{}
Local	aReg0015		:=	{}
Local	aRegE365		:=	{}
Local	nX				:=	0
Local	nItem			:=	1
Local	cObs			:=	""
Local	aRegC750		:=	{}
//Local	aRegC760		:=	{}
Local	aRegC770		:=	{}
Local	aRegC775		:=	{}
//Local	aRegC575		:=	{}
//Local	aRegC500		:=	{}
//Local	aRegC570		:=	{}
Local	aRegC605		:=	{}
//Local	aRegC620		:=	{}
//Local	aRegC625		:=	{}
Local	aRegC700		:=	{}
Local	aRegD475		:=	{}
Local	aRegD470		:=	{}
//Local	aRegC580		:=	{}
//Local	aRegC640		:=	{}
Local	nZ				:=	0
Local	aRegD450		:=	{}
Local	aRegD400		:=	{}
Local	aRegE025		:=	{}
Local	nD450			:=	0
Local	cSituaDoc		:=	""
Local	aLeis			:=	{}
Local	aRegE050		:=	{}
Local	aRegE055		:=	{}
Local	aRegE310		:=	{}
Local	aRegE320		:=	{}
Local	aRegE510		:=	{}
Local	nAcImport		:=	0
Local	nAcRetEsta		:=	0 // ICMS substituto pelas saidas para o Estado.
Local	nAcRetInter		:=	0 // ICMS substituto pelas saidas para outros Estados.
Local	nDbCompIcm		:=	0
Local	nCrCompIcm		:=	0
Local	nIE340			:=	85
Local	cCmpCondP		:=	""
Local	aRegE105		:=	{}
Local	lAchouSFU		:=	.F.
Local	lAchouSFX		:=	.F.
Local	lAchouSE4		:=	.T.
Local	lAchouSB5		:=	.T.
Local	lAchouSB8		:=	.T.
Local	lCompIcm		:=	.F.
Local	lCompFre		:=	.F.
Local	lIss			:=	.F.
Local	lIcms			:=	.F.
Local	lB350			:=	.F.
Local	lB475			:=	.F.
Local	lBlocoE			:=	.F.
Local	lReg0150		:=	.T.
Local	aRegE120		:=	{}
Local	aRegD040		:=	{}
Local	cCmpFrete		:=	0
Local	lAchouDA3		:=	.F.
Local	cRecIss			:=	""
Local	cCmpRecIss		:=	cAlsSA+"->"+SubStr (cAlsSA, 2, 2)+"_RECISS"
Local	cClasFis		:=	""
Local	cLancam			:=	""
Local	cChaveF3		:=	""
Local	aRegC040		:=	{}
Local	cMVE020CF		:=	""
Local	aMVE020CF		:=	{"","","","","","",""}
Local	aAux			:=	{}
Local	nI				:=	1
Local	aEmpCorr		:=	{ cEmpAnt, cFilAnt, SM0->M0_CGC, SM0->M0_INSC, SM0->M0_INSCM }
Local	cEspAux			:=	""
Local	lDf				:=	SuperGetMv('MV_ESTADO')=="DF"
Local	lB350CLL		:=	SuperGetMv("MV_B350CLL",.F.,.F.)
Local	cCfps			:=	""
Local	cCmpLocal		:=	""
Local	cCmpLtCtl		:=	""
Local	cCmpNLote		:=	""
Local	lIssRet			:=	.F.
Local	aArq			:=	{}
Local	cMVSUBTRIB		:=	IIf(FindFunction("GETSUBTRIB"), GetSubTrib(), SuperGetMv("MV_SUBTRIB"))
Local	cMVCERTVEI		:=	SuperGetMv("MV_CERTVEI")
Local	aMVCERTVEI		:=	Iif (Len (&(cMVCERTVEI))<>2, {}, &(cMVCERTVEI))
Local	cMVCOMPFRT		:=	SuperGetMv("MV_COMPFRT")	//1-Valor do frete por peso/volume, 2-Valores do SEC/CAT, 3-Valores de despacho, 4-Valores de pedagio
Local	aMVCOMPFRT		:=	Iif (Len (&(cMVCOMPFRT))<>4, {}, &(cMVCOMPFRT))
Local	cMVRC315		:=	SuperGetMv("MV_RC315")		//Array com campo da tabela SB5 para identificar a referencia de base do medicamento
Local	aMVRC315		:=	Iif (Len (&(cMVRC315))<>3, {}, &(cMVRC315))
Local	cIndex			:=	""
Local	nIndex			:=	0
Local	lSm0			:=	.F.
Local	cMVITTARE		:=	SuperGetMv("MV_ITTARE")
Local	nMVITTARE		:=	SB5->(FieldPos (cMVITTARE))
Local	lAchouSF4		:=	.T.
Local	cCmpVlAcr		:=	""
Local	cCmpUm			:=	""
Local	aLog			:=	{}
Local	cDir			:=	""
Local	aConjugada		:=	{.F.,.F.}
Local	lContrTare		:=	GetNewPar("MV_TAREDF",.F.)	//Indica se o contribuinte responsavel pela geracao do meio-magnetico eh optante pelo regime especial de Atacadistas - TARE.
Local	nForFilial		:=	0
Local	cMvNfSS			:=	GetNewPar("MV_COTNFSS","")
Local	cEspeNFS		:=	" "
Local	nItemA200		:=	0
Local	aNfSubst		:=	{}
Local	aRegA320		:=	{}
Local	aRegA350		:=	{}
Local	aRegA360		:=	{}
Local	aReg02Aux		:=	{}       // Array auxiliar para a verificacao da nota fiscal Legal DF.    
Local	aRegC600Veri	:=	{.F.,"","1"}       // Varivel para auxiliar filtro do resgistro C600    
Local	lLoja			:=	.T.     // Valia a geracao de registros 0200 para os ECfs 
Local	cCodObs			:=	""
Local	cSelect			:=	""
Local	cFrom			:=	""
Local	nConjug			:=	0
Local	cFrom1			:=	""
Local	cWhere			:=	""
Local	cWhere1			:=	""
Local	cCot35ISS		:=	""
Local	cAliasISS		:=	"COTEPE35"
Local	cSF2Subs		:=	"SF2Subs"
Local	nTamFor			:=	TamSx3("E2_FORNECE")[1]
Local	nTamLj			:=	TamSx3("E2_LOJA")[1]
Local	nTamTit			:=	TamSx3("E2_PREFIXO")[1]+TamSx3("E2_NUM")[1]+TamSx3("E2_PARCELA")[1]+TamSx3("E2_TIPO")[1]+1
Local	lEmpPubl		:=	GetNewPar("MV_ISPPUBL","2") == "1"
Local	lGeraReg		:=	.F.
Local	n0200			:=	0
Local	nY				:=	0
Local	lSubsISS		:=	GetNewPar("MV_ISSUB35",.F.)
Local	lE300			:=	.F.
Local	cMunic			:=	PadR(SuperGetMv("MV_MUNIC"),TamSX3("E2_FORNECE")[1])
Local	cLoja			:=	PadR("00",TamSX3("A2_LOJA")[1],"0")
Local	lFTCpoDifal		:=	SFT->(ColumnPos("FT_DIFAL"))>0
Local	lISSTomador		:=	SuperGetMv("MV_ISSRETC",.F.,.F.) //-- ISS retido tomador uso COTEPE35
Local	lFldNfEltr		:= SFT->(ColumnPos("FT_NFELETR")) > 0
Local	cFtNfEletr		:= ""
Local	nTamCod			:= TamSx3("A1_COD")[1]
Local	nTamLoj			:= TamSx3("A1_LOJA")[1]
Local	cCliPad			:= AllTrim(Padr(SuperGetMv("MV_CLIPAD"),nTamCod))
Local	cLojPad			:= AllTrim(Padr(SuperGetMv("MV_LOJAPAD"),nTamLoj))
Local	cEspecol		:= ""
Local	cB1MepLes		:= ""
Local	cMunSgmt		:= ""
Local	aNatOper		:= {}
Local	cCodNat			:= ""
Local	cDscNat			:= ""
Local	lFtNatOper		:= SFT->(ColumnPos("FT_NATOPER"))>0
Local	cCmpAbtIss		:= ""
Local	lMvISSxMun		:= SuperGetMv("MV_ISSXMUN",.F.,.F.)
Local	cCmpCdEst		:= ""
Local	cCmpCdMun		:= ""
Local	cFileDest		:= "COTEPE35.TXT" //Conteudo Atualizado na funcao PrCotepe

Private cNrLivro		:= ""

Default lJob			:= .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Consideracao de mais de um parametro para o mesmo fim do parametro MV_E020CF ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea ("SX6")
SX6->(dbSetOrder (1))
SX6->(dbSeek( xFilial( "SX6" )+"MV_E020CF"))
Do While !SX6->(Eof ()) .And. xFilial ("SX6")==SX6->X6_FIL .And. "MV_E020CF"$SX6->X6_VAR
	aAdd (aAux, &(AllTrim (SX6->X6_CONTEUD)))
	For nX := 1 to 7
		aMVE020CF[nX] += IIf( nI == 1 , aAux[nI][nX] , IIf( nI > 1 .And. !Empty(aAux[nI][nX]) , "/"+aAux[nI][nX] , "") )
	Next nX
	nI++
	SX6->(DbSkip())
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do TRB para ser alimentado durante o processamento da rotina³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
GeraTrb (1, @aArq, @cAlias)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Atribuo o conteudo do CFP gerado pelo wizard no array aWizard³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lJob .AND. (!xMagLeWiz (cNomeCfp, @aWizard, .T.))
	GeraTrb (2, @aArq, @cAlias)			//Fecho TRB criado
	Return	//Se por algum motivo a leitura do CFP falhar aborto a rotina.
EndIf

dDataDe   := SToD (aWizard[1][1])
dDataAte  := SToD (aWizard[1][2])
dDataInv  := SToD (aWizard[1][10])
cNrLivro  := aWizard[1][3]
cDir      := AllTrim (aWizard[1][4])
cFileDest := AllTrim(aWizard[1][5])
DumpFile(1, @cDir, @cFileDest)

lBloqCD   := ("1"$aWizard[1][08])// Se selecionou "Sim" para bloco C e D
lSimples  := ("1"$aWizard[1][09])// Se selecionou "Sim" para Simples Nacional
lB350     := ("1"$aWizard[1][11])// Se selecionou "Sim" para gerar registro B350
lB475     := ("1"$aWizard[1][12])// Se selecionou "Sim" para gerar registro B475
lBlocoE   := ("1"$aWizard[1][13])// Se selecionou "Sim" para gerar bloco E
lRegTer   := ("1"$aWizard[1][14])// Se selecionou "Sim" para gerar RPS fornec autonomo.
If lSimples // Quando for Simples nao deve gerar blocos C e D
	lBloqCD := .F.
EndIf

If	(MV_PAR02 == 2)		.Or.;	//Se as perguntas Seleciona Filiais nao for preechida assumo como default somente o processamento para filial cadastrada no variavel cFilAnt
	("0"$aWizard[2][2])	.Or.;	//Sem centralizacao
	("2"$aWizard[2][2])			//Estabelecimento centralizado, portanto deve conter os dados do estabelecimento centralizador
	cFilDe	:=	cFilAnt
	cFilAte	:=	cFilAnt
EndIf

//Inventário
If ("1"$aWizard[1][6])
	//Verifica existencia da função criada por Materiais
	If !FindFunction("SPDBlOCH")
		MsgAlert("Para gerar o Bloco H, é necessário atualizar a Rotina MATXSPED.")
		Return .F.
	Endif		
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³DEFINICAO DE ORDEM DAS TABELAS³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SX5->(DbSetOrder (1))
//Cadastro do Cliente/Fornecedor
SA1->(DbSetOrder (1))
//Cadastro do Cliente/Fornecedor
SA2->(DbSetOrder (1))
//Cabecalho das Notas Fiscais de Entrada/Saida
SF1->(DbSetOrder (1))
//Cabecalho das Notas Fiscais de Entrada/Saida
SF2->(DbSetOrder (1))
//Condicao de pagamento
SE4->(DbSetOrder (1))
//Posicionando Livros Fiscais
SF3->(DbSetOrder (1))
//Informacoes complementares das NF de Energia Eletrica
SFU->(DbSetOrder (1))
//Informacoes complementares das NF de Comunicacao/Telecomunicacao
SFX->(DbSetOrder (1))
//Itens das NF´s de Entrada
SD1->(DbSetOrder (1))
//Itens das NF´s de Saida
SD2->(DbSetOrder (3))
//Cadastro de Produtos
SB1->(DbSetOrder (1))
//Complemento do cadastro de produto
SB5->(DbSetOrder (1))
//Cadastro de TES
SF4->(DbSetOrder (1))

If "1"$aWizard[1][7] // Se selecionou "Sim" para as notas de frete
	If IntTms ()
		//Notas Fiscais do Cliente
		DTC->(DbSetOrder (3))
		//Movimento da Viagem
		DUD->(DbSetOrder (1))
		//Viagem
		DTQ->(DbSetOrder (2))
		//Veiculos da viagem
		DTR->(DbSetOrder (1))
		//Composicao do frete
		DT8->(DbSetOrder (2))
	EndIf
	//Cadastro de Veiculos
	DA3->(DbSetOrder (1))
	//Aviso de recebimento de carga
	DB2->(DbSetOrder (1))
	//Cabecalho do documento de recebimento
	DB1->(DbSetOrder (1))
	//Itens do documento de recebimento
	DB3->(DbSetOrder (1))
EndIf
SL1->(dbSetorder(2))

//Saldos por Lote
SB8->(DbSetOrder (3))

SM0->(dbSeek(cEmpAnt+cFilAnt, .T.))
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³GRAVACAO - REGISTRO 0000 - ABERTURA DO ARQUIVO DIGITAL E IDENTIFICACAO DO CONTRIBUINTE³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Reg0000 (aWizard, cAlias, dDataDe, dDataAte,aListafil)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³GRAVACAO - REGISTRO 0005 - DADOS COMPLEMENTARES DO CONTRIBUINTE³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Reg0005 (aWizard, cAlias)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Somente para contribuintes TARE este registro deve ser enviado.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lContrTare
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³REGISTRO 0020 - BENEFICIO FISCAL³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Reg0020(cAlias)
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³GRAVACAO - REGISTRO 0100 - DADOS DO CONTABILISTA³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Reg0100 (aWizard, cAlias)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³GRAVACAO - REGISTRO 0125 - DADOS DO TECNICO/EMPRESA³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Reg0125 (aWizard, cAlias)

DbSelectArea ("SM0")

For nForFilial := 1 To Len( aListaFil )

	If  aListaFil [ nForFilial, 1 ]

		nY := 0 
		//alterado para ca, pois ao utilizar consolidação
		//não estaria sendo feito por causa da variavel que não é reinicializado

		cFilAnt := aListaFil[nForFilial][2]
		SM0->(DbSeek (cEmpAnt+cFilAnt, .T.))
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³GRAVACAO - REGISTRO 0010 - ESCRITURACAO CENTRALIZADA³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Reg0010 (aWizard,cAlias,aEmpCorr) //Filial somente eh utilizado para escrituracao consolidada.

		DbSelectArea (cAliasSFT)
		(cAliasSFT)->(DbSetOrder(2))

		If MV_PAR05 == 1
			//-- Query FINANCEIRO - Consulta titulos com Rec. ISS por data de emissao (FINXIMP.PRW)
			cAliasTrb := ISSFiscal(dDataDe, dDataAte, cMunic, cLoja, "00108")
			(cAliasTrb)->(DbGoTop ())
		EndIf

		cMunSgmt := Iif(Len(Alltrim(SM0->M0_CODMUN)) < 7,RetCodEst(SM0->M0_ESTENT)+SM0->M0_CODMUN, SM0->M0_CODMUN)

		//-- Executa 2x = 1o.passo - doctos em geral e 2o.passo - doctos NFS com Rec. ISS (data da baixa)
		While nY <= 1
			While nY == 0 .Or. (MV_PAR05 == 1 .And. !(cAliasTrb)->(EOF()))

				#IFDEF TOP
					If (TcSrvType ()<>"AS/400")
						cAliasSFT := GetNextAlias()
						cSelect := "%"
						cSelect += "SFT.FT_FILIAL,SFT.FT_TIPOMOV,SFT.FT_SERIE,SFT.FT_NFISCAL,SFT.FT_CLIEFOR,SFT.FT_LOJA,SFT.FT_ITEM,SFT.FT_PRODUTO,"
						cSelect += "SFT.FT_ENTRADA,SFT.FT_NRLIVRO,SFT.FT_CFOP,SFT.FT_ESPECIE,SFT.FT_TIPO,SFT.FT_EMISSAO,SFT.FT_DTCANC,SFT.FT_FORMUL,"
						cSelect += "SFT.FT_ALIQPIS,SFT.FT_VALPIS,SFT.FT_ALIQCOF,SFT.FT_VALCOF,SFT.FT_VALCONT,SFT.FT_BASEICM,SFT.FT_VALICM,SFT.FT_ISSST,"
						cSelect += "SFT.FT_BASERET,SFT.FT_ICMSRET,SFT.FT_VALIPI,SFT.FT_ISENICM,SFT.FT_QUANT,SFT.FT_DESCONT,SFT.FT_TOTAL,SFT.FT_FRETE,"
						cSelect += "SFT.FT_SEGURO,SFT.FT_DESPESA,SFT.FT_OUTRICM,SFT.FT_BASEIPI,SFT.FT_ISENIPI,SFT.FT_OUTRIPI,SFT.FT_ICMSCOM,SFT.FT_RECISS,"
						cSelect += "SFT.FT_BASEIRR,SFT.FT_ALIQICM,SFT.FT_ALIQIPI,SFT.FT_CTIPI,SFT.FT_POSIPI,SFT.FT_CLASFIS,SFT.FT_PRCUNIT,SFT.FT_CFPS,"
						cSelect += "SFT.FT_ESTADO,SFT.FT_CODISS,SFT.FT_ALIQIRR,SFT.FT_VALIRR,SFT.FT_BASEINS,SFT.FT_VALINS,SFT.FT_PDV,SFT.FT_ISSSUB,"
						cSelect += "SFT.FT_ISENRET,SFT.FT_OUTRRET,SFT.FT_OBSERV,SFT.FT_CONTA,SFT.FT_CSTISS"
						cSelect += Iif(!lFTCpoDifal,",0 AS FT_DIFAL",",SFT.FT_DIFAL")
						cSelect += Iif(lFldNfEltr,", SFT.FT_NFELETR","")
						cSelect += Iif(lFtNatOper,", SFT.FT_NATOPER","")

						cFrom := "%"
						cFrom += RetSqlName("SFT")+" SFT "

						cWhere := "%"
						cWhere += "SFT.FT_FILIAL='" + xFilial("SFT") + "' AND "
						If nY == 0
							//-- Doctos sem Recolhimento de ISS.
							cWhere  += "SFT.FT_ENTRADA>='" + DToS(dDataDe)  + "' AND "
							cWhere  += "SFT.FT_ENTRADA<='" + DToS(dDataAte) + "' AND "
						Else
							//-- Doctos com Recolhimento de ISS por data de baixa.
							If AllTrim((cAliasTrb)->(TIPOPR)) == 'R'
								SA1->(dbGoto((cAliasTrb)->(IDCLIFOR)))
							ElseIf AllTrim((cAliasTrb)->(TIPOPR)) == 'P'
								SA2->(dbGoto((cAliasTrb)->(IDCLIFOR)))
							EndIf
							cWhere  += "SFT.FT_NFISCAL = '" + (cAliasTrb)->(NUMERO)  + "' AND "
							cWhere  += "SFT.FT_SERIE   = '" + (cAliasTrb)->(PREFIXO) + "' AND "
							cWhere  += "SFT.FT_CLIEFOR = '" + (cAliasTrb)->(CLIFOR)  + "' AND "
							cWhere  += "SFT.FT_LOJA    = '" + (cAliasTrb)->(LOJA)    + "' AND "
							cWhere  += "FT_TIPO        = 'S' AND "
						EndIf
						cWhere  += "((SFT.FT_CFOP NOT LIKE '000%' AND SFT.FT_CFOP NOT LIKE '999%') OR SFT.FT_TIPO='S') AND "
						If cNrLivro <> "*"
							cWhere += "SFT.FT_NRLIVRO = '" +%Exp:(cNrLivro)% +"' AND "
						EndIf

						If lSubsISS .And. nY == 0
							cWhere += "SFT.D_E_L_E_T_='' OR "
							cWhere += "SFT.FT_NFISCAL IN((SELECT F2_DOC FROM "+RetSqlName("SF2")+" SF2 "+"WHERE F2_EMISSAO >='" +DToS(dDataDe)+"' AND F2_NFSUBST <> '' AND D_E_L_E_T_ <> '*' AND FT_OBSERV = '' AND SFT.FT_TIPO='S')) AND "
							cWhere += "SFT.FT_SERIE IN((SELECT F2_SERIE FROM "+RetSqlName("SF2")+" SF2 "+"WHERE F2_EMISSAO >='" +DToS(dDataDe)+"' AND F2_SERSUBS <> '' AND D_E_L_E_T_ <> '*' AND FT_OBSERV = '' AND SFT.FT_TIPO='S')) "
						Else
							cWhere += "SFT.D_E_L_E_T_=''"
						EndIf

						cWhere +=  "%"

						//Empresa publica (sigamat)
						If MV_PAR05 == 2 .And. lEmpPubl
							cSelect +=  ", SE2.E2_BAIXA	"
							cFrom += "LEFT JOIN "+RetSqlName("SE2")+" SE2 ON "
							cFrom += "(SE2.E2_FILIAL='"   + xFilial("SE2") + "' AND"
							cFrom += " SE2.E2_NUM=SFT.FT_NFISCAL AND"
							cFrom += " SE2.E2_PREFIXO=SFT.FT_SERIE AND"
							cFrom += " SUBSTRING(E2_TITPAI," + Str(nTamTit)+","+Str(nTamFor)+")=SFT.FT_CLIEFOR AND"
							cFrom += " SUBSTRING(E2_TITPAI," + Str(nTamTit+nTamFor)+","+Str(nTamLj)+")=SFT.FT_LOJA AND"
							cFrom += " SE2.E2_TIPO='ISS ' AND"
							cFrom += " SE2.E2_BAIXA>='" + DToS(dDataDe)  + "' AND"
							cFrom += " SE2.E2_BAIXA<='" + DToS(dDataAte) + "' AND"
							cFrom += " SE2.D_E_L_E_T_='')"

							cFrom1 := "%"
							cFrom1 += RetSqlName("SE2")+" SE2 "
							cFrom1 += "JOIN "+RetSqlName("SFT")+" SFT ON "
							cFrom1 += "(SFT.FT_FILIAL='"   + xFilial("SE2") + "' AND"
							cFrom1 += " SFT.FT_NFISCAL=SE2.E2_NUM AND"
							cFrom1 += " SFT.FT_SERIE=SE2.E2_PREFIXO AND"
							cFrom1 += " SFT.FT_CLIEFOR=SUBSTRING(E2_TITPAI," + Str(nTamTit)+","+Str(nTamFor)+") AND"
							cFrom1 += " SFT.FT_LOJA=SUBSTRING(E2_TITPAI," + Str(nTamTit+nTamFor)+","+Str(nTamLj)+") AND"
							cFrom1 += " SFT.D_E_L_E_T_='')"
							cFrom1 += "%"

							cWhere1 := "%"
							cWhere1 += "SE2.E2_FILIAL='" + xFilial("SE2") + "' AND "
							cWhere1 += "SE2.E2_BAIXA>='" + DToS(dDataDe)  + "' AND "
							cWhere1 += "SE2.E2_BAIXA<='" + DToS(dDataAte) + "' AND "
							cWhere1 += "SE2.D_E_L_E_T_=''"
							cWhere1 += "%"
						Else
							cSelect += ", '' as E2_BAIXA "
						Endif
						cSelect += "%"
						cFrom += "%"

						If MV_PAR05 == 2 .And. lEmpPubl

							BeginSql Alias cAliasSFT

								COLUMN FT_EMISSAO AS DATE
								COLUMN FT_ENTRADA AS DATE
								COLUMN FT_DTCANC AS DATE
								COLUMN E2_BAIXA AS DATE

								SELECT
									%Exp:cSelect%
								FROM
									%Exp:cFrom%
								WHERE
									%Exp:cWhere%

								UNION

								SELECT
									%Exp:cSelect%
								FROM
									%Exp:cFrom1%
								WHERE
									%Exp:cWhere1%

								ORDER BY
									1,2,3,4,5,6,7,8

							EndSql

						Else

							BeginSql Alias cAliasSFT

								COLUMN FT_EMISSAO AS DATE
								COLUMN FT_ENTRADA AS DATE
								COLUMN FT_DTCANC AS DATE
								COLUMN E2_BAIXA AS DATE

								SELECT
									%Exp:cSelect%
								FROM
									%Exp:cFrom%
								WHERE
									%Exp:cWhere%
								ORDER BY
									1,2,3,4,5,6,7,8

							EndSql
						EndIf
					Else
				#ENDIF
						cIndex  := CriaTrab(NIL,.F.)
						cFiltro := 'FT_FILIAL=="'+xFilial ("SFT")+'".And.'
						cFiltro += 'DToS (FT_ENTRADA)>="'+DToS (dDataDe)+'".And.DToS (FT_ENTRADA)<="'+DToS (dDataAte)+'" '
						cFiltro += '.And. (!SubStr (FT_CFOP,1,3)$"999/000" .Or. FT_TIPO=="S")'

						If (cNrLivro<>"*")
							cFiltro += '.And.FT_NRLIVRO ="'+cNrLivro+'" '
						EndIf

						IndRegua (cAliasSFT, cIndex, SFT->(IndexKey ()),, cFiltro)
						nIndex := RetIndex(cAliasSFT)

						#IFNDEF TOP
							DbSetIndex (cIndex+OrdBagExt ())
						#ENDIF

						DbSelectArea (cAliasSFT)
						DbSetOrder (nIndex+1)
				#IFDEF TOP
					Endif
				#ENDIF

				If lSubsISS .And. nY == 0
					//+===============================================================================================================================+
					//| Tratamento para NF-e referente à prestação de serviços, sujeita ao ISS, emitida com erro, e impossibilidade de cancelamento.  |
					//| O arquivo deve conter notas fiscais substitutas (F2_NFSUBST e F2_SERSUBS) mesmo emitidas em mês subsequente.                  |
					//| - A nota fiscal cancelada (errada) deve conter os valores zerados no arquivo.                                                 |
					//| - A nota fiscal substituta (correta) deve possuir data de emissão no ultimo dia do mês.                                       |
					//| Verificar parecer do fisco no chamado : TQ4884 / FNC : 00000022955/2014                                                       |
					//+===============================================================================================================================+
					// Cópia da tabela original para manipulação dos dados
					cCot35ISS := GetNextAlias()
					PCDelTmpDB(cCot35ISS,.F.)
					aStruct :=  (cAliasSFT)->(dbStruct())
					PCCriaTab(cCot35ISS,cAliasISS, aStruct,aStruct[1][1]+"+"+aStruct[4][1]+"+"+aStruct[3][1])

					Append From (cAliasSFT)

					cSelect := "%"
					cSelect += "F2_DOC ,F2_SERIE, F2_NFSUBST,F2_SERSUBS"
					cSelect += "%"

					cFrom := "%"
					cFrom += RetSqlName("SF2")+" SF2 "
					cFrom += "%"

					cWhere := "%"
					cWhere += "SF2.F2_EMISSAO>='" + DToS(dDataDe)  + "' AND "
					cWhere += "SF2.F2_NFSUBST <> '' AND "
					cWhere += "SF2.F2_SERSUBS <> '' AND "
					cWhere += "D_E_L_E_T_ <> '*' "
					cWhere += "%"

					// Procuro na tabela SF2 notas fiscais que possuem NF Subistituta 
					BeginSql Alias cSF2Subs
						SELECT
							%Exp:cSelect%
						FROM
							%Exp:cFrom%
						WHERE
							%Exp:cWhere%
					EndSQL

					dbSelectArea(cAliasISS)
					While !(cSF2Subs)->(Eof())
						//Procuro a nota fiscal substituída e zero os valores monetários.
						If MsSeek(xFilial("SFT")+(cSF2Subs)->F2_NFSUBST+(cSF2Subs)->F2_SERSUBS)
							RecLock(cAliasISS,.F.)
							(cAliasISS)->FT_BASEICM	:= 0
							(cAliasISS)->FT_VALICM	:= 0
							(cAliasISS)->FT_TOTAL	:= 0
							(cAliasISS)->FT_VALCONT	:= 0
							(cAliasISS)->FT_ISENICM	:= 0
							(cAliasISS)->FT_PRCUNIT	:= 0
							(cAliasISS)->FT_ALIQICM	:= 0
							MsUnLock()
							// Procuro a nota fiscal substituta e altero a data de emissão para o ultimo dia do mês.
							If (cAliasISS)->(MsSeek(xFilial("SFT")+(cSF2Subs)->F2_DOC+(cSF2Subs)->F2_SERIE))
								RecLock(cAliasISS,.F.)
								(cAliasISS)->FT_ENTRADA := LastDay(dDataDe)
								(cAliasISS)->FT_EMISSAO := LastDay(dDataDe)
								MsUnLock()
							Endif
						Else
							// Se não encontrar a nota através da sub-query, deleto a mesma para não ser considerada.
							If (cAliasISS)->( MsSeek(xFilial("SFT")+(cSF2Subs)->F2_DOC+(cSF2Subs)->F2_SERIE))
								RecLock(cAliasISS,.F.)
								(cAliasISS)->(dbDelete())
								MsUnLock()
							Endif
						Endif
						(cSF2Subs)->(DbSkip())
					EndDo
					//Adiciono os registros no alias temporário principal
					(cAliasSFT)->(DbCloseArea())
					cAliasSFT := cAliasISS
					(cSF2Subs)->(DbCloseArea())
					// Fim do Tratamento para notas fiscais substitutas de ISS	\\
				EndIf

				DbSelectArea (cAliasSFT)
				(cAliasSFT)->(DbGoTop ())
				ProcRegua ((cAliasSFT)->(RecCount ()))
				Do While !(cAliasSFT)->(Eof ())
					If Interrupcao(lEnd)
						Exit
					EndIf
					IncProc(STR0052+SM0->M0_CODFIL+" / "+AllTrim(SM0->M0_FILIAL))	//"Processando filial: "

					//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Tratamento para a Especie de cada documento fiscal ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ 

					cLancam  := ""
					cEspecie := cEspAux := AModNot ((cAliasSFT)->FT_ESPECIE)		//Modelo NF
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³FT_PDV somente estarah alimentado quando se referir a nota fiscais de saida ³
					//³   geradas pelo SIGALOJA.                                                   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If !Empty((cAliasSFT)->FT_PDV) .AND. AllTrim((cAliasSFT)->FT_ESPECIE)$"CF/ECF"
						cEspecie := "2D"
						cEspAux  := "2D"
					Else
						cEspecie   := Iif((cAliasSFT)->FT_TIPO=="S".And.Empty((cAliasSFT)->FT_PDV).And.!AllTrim((cAliasSFT)->FT_ESPECIE)$"CF", "03", cEspecie)
						aConjugada := {.F.,.F.}	//Posicao 1 indica se a nota fiscal tem servico e a posicao 2 indica se a nota fiscal possui produto.
						cChaveF3   := xFilial("SF3")+DToS((cAliasSFT)->FT_ENTRADA)+(cAliasSFT)->FT_NFISCAL+(cAliasSFT)->FT_SERIE+(cAliasSFT)->FT_CLIEFOR+(cAliasSFT)->FT_LOJA
						If SF3->(dbSeek (cChaveF3))

							cLancam := SF3->F3_LANCAM

							While !SF3->(Eof()) .And.;
								cChaveF3==xFilial("SF3")+DTOS(SF3->F3_ENTRADA)+SF3->F3_NFISCAL+SF3->F3_SERIE+SF3->F3_CLIEFOR+SF3->F3_LOJA
								If SF3->F3_TIPO=="S"
									aConjugada[1] := .T.
								Else
									aConjugada[2] := .T.
								EndIf

								//Se eu identificar que a NF eh conjugada, nao preciso continuar lendo o SF3.
								If aConjugada[1] .And. aConjugada[2]
									Exit
								EndIf
								SF3->(dbSkip())
							EndDo
						Else
							//--Nao encontrou SF3
							CriaLog(@aLog, 5, cAliasSFT)
							(cAliasSFT)->(DbSkip())
							Loop
						EndIf
						cEspecie := cEspAux := Iif(aConjugada[1] .And. aConjugada[2], "01", cEspecie)
						//-Atribuo pois do jeito que estava se atotaliss[2] fosse > 0, ele nao preenchia o C020
						//-Com esta variavel toda vez que mudar de nota eu zero e quando for nota conjugada ele ira passar apenas uma vez
						nConjug := 0
					EndIf
					//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ FIM ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

					//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Filtros ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³SOMENTE MODELOS:                               ³
					//³01 - NOTA FISCAL NORMAL                        ³
					//³02 - NOTA FISCAL DE VENDA A CONSUMIDOR FINAL   ³
					//³03 - NOTA FISCAL DE SERVICO                    ³
					//³04 - NOTA FISCAL PRODUTOR                      ³
					//³06 - NOTA FISCAL/CONTA DE ENERGIA ELETRICA     ³
					//³07 - NOTA FISCAL SERVICO DE TRANSPORTE         ³
					//³08 - CONHECIMENTO DE TRANSPORTE RODOVIARIO     ³
					//³09 - CONHECIMENTO DE TRANSPORTE AQUAVIARIO     ³
					//³10 - CONHECIMENTO DE TRANSPORTE AEREO          ³
					//³11 - CONHECIMENTO DE TRANSPORTE FERROVIARIO    ³
					//³13 - BILHETES DE PASSAGEM RODOVIARIO           ³
					//³15 - PASSAGEM E NOTA DE BAGAGEM                ³
					//³21 - NOTA FISCAL DE SERVICO DE COMUNICACAO     ³
					//³22 - NOTA FISCAL DE SERVICO DE TELECOMUNICACAO ³
					//³55 - NOTA FISCAL ELETRONICA                    ³
					//³57 - CONHECIMENTO DE TRANSPORTE ELETRONICO     ³
					//³65 - NOTA FISCAL DE CONSUMIDOR ELETRÔNICA NFC-e³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If !(cEspecie$"01#02#03#04#06#07#08#09#10#11#13#15#21#22#2D#55#57#65")
						CriaLog(@aLog, 1, cAliasSFT)
						(cAliasSFT)->(DbSkip ())
						Loop
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³As informacoes CTR e NFST necessarias para o SINTEGRA somente estao disponiveis           |
					//³ quando o TMS estiver envolvido (SAIDAS) ou ENTRADAS quando envolver aviso de recebimento.³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					/*If ((cEspecie$"07#08#57") .And. (!IntTms () .And. "S"$(cAliasSFT)->FT_TIPOMOV))
						(cAliasSFT)->(DbSkip ())
						Loop
					EndIf*/  //Ajuste realizado com a mesma tratativa do SEFII
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Para as notas fiscais de transportes vindas do TMS sempre deverah      ³
					//³   haver um DT6 correspondente, caso nao haja, montar o arquivo de     ³
					//³   log e saltar para a proxima nota. Instrucoes passadas pela equipe do³
					//³   TMS.                                                                ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If cEspecie$"#07#08#09#10#11#57" .And. "S"$(cAliasSFT)->FT_TIPOMOV .And. IntTms() 
						If !DT6->(DbSeek (xFilial ("DT6")+(cAliasSFT)->(FT_FILIAL+FT_NFISCAL+FT_SERIE))) .and. Empty((cAliasSFT)->(FT_DTCANC)) 
							CriaLog(@aLog, 2, cAliasSFT)
							(cAliasSFT)->(DbSkip ())
							Loop
						EndIf
					EndIf
					//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ FIM ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Inicializacao de variaveis utilizadas no processamento ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Determina o Alias para as Tabelas SF1/SF2 e SD1/SD2.³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cEntSai			:=	Iif ("E"$(cAliasSFT)->FT_TIPOMOV, "1", "2")
					cAlsSF			:=	"SF"+cEntSai //Determina o Alias para as Tabelas SF1/SF2
					cAlsSD			:=	"SD"+cEntSai //Determina o Alias para as Tabelas SD1/SD2
					cAlsSA			:=	"SA"+Iif ((cEntSai=="1" .And. !(cAliasSFT)->FT_TIPO$"BD") .or.;
												  (cEntSai=="2" .And.  (cAliasSFT)->FT_TIPO$"BD"), "2", "1")	//Determina o Alias para as Tabelas SA1/SA2
									//   1  2  3  4  5   6  7  8  9  10 11 12 13 14 15 16  17 18 19 20 21 22 23 24 25 26
					aTotaliza		:=	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
									//   1  2  3  4  5   6  7  8  9  10 11 12 13 14 15 16  17 18 19 20 21 22 23 24 25
					aTotalISS		:=	{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
					nRelacDoc++		//Utilizado para relacionar os documentos fiscais aos seus elementos inferiores/dependentes
					cObs			:=	""
					nItem			:=	1
					nItemA200		:=	0
					aRegC700		:=	{}
					aRegC750		:=	{}
					aRegC020		:=	{}
					aRegC050		:=	{"C050", 0, 0, 0, 0}
					aRegC040		:=	{"C040", 0, 0, 0, 0, 0, 0, 0, 0}
					//aRegA025		:=	{"A025", 0, 0, 0, 0, 0, 0, 0, 0, 0}
					//aRegA035		:=	{"A035", 0, 0, 0, 0, 0, 0, 0, 0, 0}
					aRegA200		:=	{}
					aRegA310		:=	{}
					aRegB025		:=	{}
					//aRegC500		:=	{}
					aRegC600		:=	{}
					aRegE025		:=	{}
					aRegE105		:=	{}
					aRegE120		:=	{}
					aRegD040		:=	{}
					aRegD400		:=	{}
					aRegD450		:=	{}
					lAchouSFU		:=	.F.
					lAchouSFX		:=	.F.
					lAchouSE4		:=	.F.
					lCompIcm		:=	.F.
					lCompFre		:=	.F.
					lAchouSB5		:=	.F.
					lAchouDA3		:=	.F.
					cSituaDoc		:=	RetSitDoc ((cAliasSFT)->FT_TIPO, cAliasSFT)
					nAcRetEsta		+=	Iif (Left ((cAliasSFT)->FT_CFOP, 1)=="5", (cAliasSFT)->FT_ICMSRET, 0)
					nAcRetInter		+=	Iif (Left ((cAliasSFT)->FT_CFOP, 1)=="6", (cAliasSFT)->FT_ICMSRET, 0)
					cCfps			:=	""
					lGeraReg		:=	.F.
					//Empresa publica (sigamat)
					If MV_PAR05 == 2 .And. lEmpPubl	
						lGeraReg := (cAliasSFT)->(DToS(E2_BAIXA)>=DToS(dDataDe) .And. DToS(E2_BAIXA)<=DToS(dDataAte) .And. DToS(E2_BAIXA)<>"  /  /  ") 
					Endif
					If lFldNfEltr
						cFtNfEletr := (cAliasSFT)->FT_NFELETR
					EndIF
					aCmpAntSFT		:=	{	(cAliasSFT)->FT_NFISCAL,;		//01
											(cAliasSFT)->FT_SERIE,;			//02
											(cAliasSFT)->FT_CLIEFOR,;		//03
											(cAliasSFT)->FT_LOJA,;			//04
											(cAliasSFT)->FT_ENTRADA,;		//05
											(cAliasSFT)->FT_EMISSAO,;		//06
											(cAliasSFT)->FT_DTCANC,;		//07
											(cAliasSFT)->FT_FORMUL,;		//08
											(cAliasSFT)->FT_CFOP,;			//09
											cLancam,;						//10
											(cAliasSFT)->FT_ALIQICM,;		//11
											(cAliasSFT)->FT_PDV,;			//12
											(cAliasSFT)->FT_BASEICM,;		//13
											(cAliasSFT)->FT_ALIQICM,;		//14
											(cAliasSFT)->FT_VALICM,;		//15
											(cAliasSFT)->FT_ISENICM,;		//16
											(cAliasSFT)->FT_OUTRICM,;		//17
											(cAliasSFT)->FT_ICMSRET,;		//18
											(cAliasSFT)->FT_TIPO,;			//19
											(cAliasSFT)->FT_FILIAL,;		//20
											(cAliasSFT)->FT_ESPECIE,;		//21
											cFtNfEletr}						//22
					cCmpCondP		:=	cAlsSF+"->"+SubStr (cAlsSF, 2, 2)+"_COND"
					cCmpFrete		:=	cAlsSF+"->"+SubStr (cAlsSF, 2, 2)+"_FRETE"
					cRecIss			:=	""
					cCmpRecIss		:=	cAlsSA+"->"+SubStr (cAlsSA, 2, 2)+"_RECISS"
					cCmpTes			:=	cAlsSD+"->"+SubStr (cAlsSD, 2, 2)+"_TES"
					cCmpLocal		:=	cAlsSD+"->"+SubStr (cAlsSD, 2, 2)+"_LOCAL"
					cCmpLtCtl		:=	cAlsSD+"->"+SubStr (cAlsSD, 2, 2)+"_LOTECTL"
					cCmpNLote		:=	cAlsSD+"->"+SubStr (cAlsSD, 2, 2)+"_NUMLOTE"
					cCmpVlAcr		:=	cAlsSD+"->"+SubStr (cAlsSD, 2, 2)+"_VALACRS"
					cCmpUm			:=	cAlsSD+"->"+SubStr (cAlsSD, 2, 2)+"_UM"
					cCmpAbtIss		:=	cAlsSD+"->"+SubStr (cAlsSD, 2, 2)+"_ABATISS"
					cCmpCdEst		:= Iif(cEntSai == "1",cAlsSF+"->"+SubStr (cAlsSF, 2, 2)+"_ESTPRES",cCmpCdEst)
					cCmpCdMun		:= Iif(cEntSai == "1",cAlsSF+"->"+SubStr (cAlsSF, 2, 2)+"_INCISS",cCmpCdMun)
					lSm0			:=	Iif( (cAliasSFT)->FT_FORMUL=="S" .And. cEntSai=="1",.T.,.F. )	//Quando a NF de Entrada for formulario proprio
																										//	o validador exige que os dados do remente 
																										//	seja o mesmo do declarante.
					lAchouSF4		:=	.F.
					// ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ FIM ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Posicionando tabelas³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					(cAlsSA)->(dbSeek (xFilial (cAlsSA)+(cAliasSFT)->FT_CLIEFOR+(cAliasSFT)->FT_LOJA))
					(cAlsSF)->(dbSeek (xFilial (cAlsSF)+(cAliasSFT)->FT_NFISCAL+(cAliasSFT)->FT_SERIE+(cAliasSFT)->FT_CLIEFOR+(cAliasSFT)->FT_LOJA))
					lCompIcm  := ( &(cAlsSF+"->"+SubStr (cAlsSF, 2, 2)+"_TIPO") == "I" ) // Indica se NF de complemento de ICMS
					lAchouSE4 := SE4->(DbSeek (xFilial ("SE4")+&(cCmpCondP)))
					lCompFre  := ( &(cAlsSF+"->"+SubStr (cAlsSF, 2, 2)+"_TIPO") == "C" ) // Indica se NF de complemento de Frete

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Processo todas as observacoes para o documento fiscal contidas na tabela SF3 (F3_OBSERV)³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If !cEspecie$"02/2D/65" .And. (lISS .Or. lBlocoE)	//O registro de observacao nao deve ser gerado para consumidor final, inclusive cupom fiscal 
						aObs := LivrObs (cAliasSFT, Val (cEntSai), 65536, @aLeis, cChaveF3,lCompFre)
						For nX := 1 To Len (aObs)
							cObs += aObs[nX]+", "
						Next (nX)
					EndIf

					//Informacoes complementares das NF de Energia Eletrica
					lAchouSFU := SFU->(DbSeek (xFilial ("SFU")+(cAliasSFT)->FT_TIPOMOV+(cAliasSFT)->FT_SERIE+(cAliasSFT)->FT_NFISCAL+(cAliasSFT)->FT_CLIEFOR+(cAliasSFT)->FT_LOJA+(cAliasSFT)->FT_ITEM+(cAliasSFT)->FT_PRODUTO))

					//Informacoes complementares das NF de Comunicacao/Telecomunicacao
					lAchouSFX := SFX->(DbSeek (xFilial ("SFX")+(cAliasSFT)->FT_TIPOMOV+(cAliasSFT)->FT_SERIE+(cAliasSFT)->FT_NFISCAL+(cAliasSFT)->FT_CLIEFOR+(cAliasSFT)->FT_LOJA+(cAliasSFT)->FT_ITEM+(cAliasSFT)->FT_PRODUTO))

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Segundo instrucoes da SEF-DF, as notas de complemento de ICMS deverao ser lancadas no    ³
					//³ registro de ajustes da apuracao de ICMS (E340)                                           ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lCompIcm
						If "S"$(cAliasSFT)->FT_TIPOMOV
							nDbCompIcm += (cAliasSFT)->FT_VALICM
						Else
							nCrCompIcm += (cAliasSFT)->FT_VALICM
						EndIf
						(cAliasSFT)->(DbSkip ())
						Loop
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Retornando dados do participante em um array³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					aPartDoc := InfPartDoc (cAlsSA, aMVCEINITS, aMVMUNIBGE, Nil, cAliasSFT)
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Caso o cliente utilize o Participante Padrão³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If cEspecie$"2D"   
						CorCliC600(cAliasSFT, @aPartDoc)
					ElseIf cEntSai='2' .And. !Empty(cCliPad) .And. !Empty(cLojPad) 
						GetCliPad(cCliPad, cLojPad, @aPartDoc, (cAlsSF)->F2_CGCCLI, nTamCod, nTamLoj)
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Processando os itens do documento fiscal.³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cChave := (cAliasSFT)->FT_FILIAL+(cAliasSFT)->FT_TIPOMOV+(cAliasSFT)->FT_SERIE+(cAliasSFT)->FT_NFISCAL+(cAliasSFT)->FT_CLIEFOR+(cAliasSFT)->FT_LOJA

					If !cEspecie$"02#65" .And. !Empty (cObs) .And. !(cSituaDoc$"02#03#04")
						cCodObs := (cAliasSFT)->FT_FILIAL+(cAliasSFT)->FT_TIPOMOV+(cAliasSFT)->FT_SERIE+(cAliasSFT)->FT_NFISCAL+(cAliasSFT)->FT_CLIEFOR+(cAliasSFT)->FT_LOJA
					Else
						cCodObs := ""
					EndIf

					// Tratamento da Lei 5005/2015
					If "5005VI" $ SM4->M4_DESCR
						cCodObs := Alltrim(SM4->M4_DESCR)
					Endif

					Do While !(cAliasSFT)->(Eof ()) .And.;
						cChave==(cAliasSFT)->FT_FILIAL+(cAliasSFT)->FT_TIPOMOV+(cAliasSFT)->FT_SERIE+(cAliasSFT)->FT_NFISCAL+(cAliasSFT)->FT_CLIEFOR+(cAliasSFT)->FT_LOJA 
						nAcImport += Iif (Left ((cAliasSFT)->FT_CFOP, 1)=="3" .And. Empty((cAliasSFT)->FT_CODISS), (cAliasSFT)->FT_VALICM, 0)
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Inicializacao de variaveis utilizadas no processamento do item³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						aRegC300 := {}
						aRegC605 := {}
						lReg0150 := .T.
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³verifica se este item da nota eh um servico e verifica se a nota e conjugada ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						lIss    := ((cAliasSFT)->FT_TIPO == "S")
						lIssRet := .F.

						If lIss
							If !Empty ((cAliasSFT)->FT_RECISS)
								cRecIss := (cAliasSFT)->FT_RECISS
							Else
								cRecIss := &(cCmpRecIss)
							EndIf

							If (cEntSai=="1" .And. cRecIss$"2N") .Or. (cEntSai=="2" .And. cRecIss$"1S")
								lIssRet := .T.
							EndIf
						Else
							lIcms := .T.
						EndIf

						//-- Documento com Rec. ISS será executado em seguida (2o.passo).
						If MV_PAR05 == 1 .And. ((nY == 0 .And. lIssRet) .Or. (nY >= 1 .And. !lIssRet)) .And. !lEmpPubl
							(cAliasSFT)->(DbSkip ())
							cCodObs := ''
							cObs    := ''
							Loop
						EndIf

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Posicionando tabelas de acordo com os itens dos documentos fiscais.³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If (cAlsSD)->(dbSeek (xFilial (cAlsSD)+(cAliasSFT)->FT_NFISCAL+(cAliasSFT)->FT_SERIE+(cAliasSFT)->FT_CLIEFOR+(cAliasSFT)->FT_LOJA+(cAliasSFT)->FT_PRODUTO+(cAliasSFT)->FT_ITEM))
							lAchouSF4 := SF4->(dbSeek (xFilial ("SF4")+&(cCmpTes)))
						Else
							lAchouSF4 := .F.
						EndIf
						SB1->(dbSeek (xFilial ("SB1")+(cAliasSFT)->FT_PRODUTO))
						lAchouSB5 := SB5->(dbSeek (xFilial ("SB5")+(cAliasSFT)->FT_PRODUTO))
						lAchouSB8 := .F.
						If Rastro((cAliasSFT)->FT_PRODUTO,"L")
							lAchouSB8 := SB8->(dbSeek(xFilial("SB8")+(cAliasSFT)->FT_PRODUTO+&(cCmpLocal)+&(cCmpLtCtl)))
						ElseIf Rastro((cAliasSFT)->FT_PRODUTO,"S")        
							lAchouSB8 := SB8->(dbSeek(xFilial("SB8")+(cAliasSFT)->FT_PRODUTO+&(cCmpLocal)+&(cCmpLtCtl)+&(cCmpNLote)))
						EndIf
						cClasFis := RetCodCst(cAliasSFT, cAlsSA, lAchouSF4)
						cEspecie := Iif((cAliasSFT)->FT_TIPO=="S".And.Empty((cAliasSFT)->FT_PDV).And.!AllTrim((cAliasSFT)->FT_ESPECIE )$"CF", "03", cEspAux)
						cEspecie := IIf( lDF .and. (cAliasSFT)->FT_TIPO=="S" .and. !AllTrim((cAliasSFT)->FT_ESPECIE )$"CF" .and. !(aConjugada[1] .And. aConjugada[2]),"03",cEspecie)
						cEspeNFS := AllTrim((cAliasSFT)->FT_ESPECIE )
						cCfps    := Iif(Empty(cCfps), AllTrim((cAliasSFT)->FT_CFPS), cCfps)
						
						aNatOper	:= GetNatOper(cAliasSFT, "SF4", lAchouSF4) 
						cCodNat	:= aNatOper[1] 
						cDscNat	:= aNatOper[2] 
						
						If lIss .And. !cCfps $	"8001#8002#8003#8004#8005#8006#8007" + ;
												"9001#9002#9003#9004#9005#9006#9007" + ;
												"9101#9102#9103#9104#9105#9106#9107" + ;
												"9201#9202#9203#9204"
							CriaLog(@aLog, 4, cAliasSFT) //4.2.3-Tabela Codigo Fiscal de Prestacoes de Servicos - CFPS (ISS)
						EndIf
						cB1MepLes := SB1->B1_MEPLES
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³SOMENTE MODELOS:                               ³
						//³01 - NOTA FISCAL NORMAL                        ³
						//³02 - NOTA FISCAL DE VENDA A CONSUMIDOR FINAL   ³
						//³03 - NOTA FISCAL DE SERVICO                    ³
						//³04 - NOTA FISCAL PRODUTOR                      ³
						//³06 - NOTA FISCAL/CONTA DE ENERGIA ELETRICA     ³
						//³21 - NOTA FISCAL DE SERVICO DE COMUNICACAO     ³
						//³22 - NOTA FISCAL DE SERVICO DE TELECOMUNICACAO ³
						//³55 - NOTA FISCAL ELETRONICA                    ³
						//³65 - NOTA FISCAL DE CONSUMIDOR ELETRÔNICA NFC-e³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If (cEspecie$"01#02#2D#03#04#06#21#22#55#65")

							lLoja := If(cEspecie$"2D" ,LojVerProd(cAliasSFT,aReg02Aux,dDataDe,dDataAte,cFilDe,cFilAte) , .T. )

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³REGISTRO 0015 - DADOS DO CONTRIBUINTE SUBSTITUTO              ³
							//³REGISTRO E365 - OBRIGACOES A RECOLHER POR UNIDADE DE FEDERACAO³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							Reg0015 (cAliasSFT, @aReg0015, @aRegE365,cMVSUBTRIB)

							If (cEspecie$"01#04#55") .Or. (MV_PAR05 == 2 .And. ACONJUGADA[1] .And. ACONJUGADA[2])

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³REGISTRO C300 - ITENS DO DOCUMENTO FISCAL³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								RegC300 (cAlias, nRelacDoc, nItem, @aRegC300, cEspecie, cAliasSFT, cAlsSD, cEntSai, lIss, cClasFis, nMVITTARE, lAchouSF4, @lContrTare, lGeraReg, aconjugada, cCmpUm)	//Processo para todos, mas somente gravo para os modelos 01 e 04

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³REGISTRO C050 - PIS/COFINS³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								RegC050 (cAliasSFT, @aRegC050)
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³REGISTRO C040 - ISS³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If lIss
									RegC040 (cAliasSFT, @aRegC040)
								EndIf
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³REGISTRO C305 - QUALIFICACAO DO ITEM³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								RegC305 (cAlias, nRelacDoc, nItem)
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³REGISTRO C500 - REGISTRO ANALITICO DO DOCUMENTO³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								//If !lDf	 // Registro C500 nao previsto para o Distrito Federal
								//	RegC500 (aRegC300, cAliasSFT, @aRegC500)
								//EndIf
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³REGISTRO E025 - REGISTRO ANALITICO DO DOCUMENTO FISCAL (MODELO 01 E 04)³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								RegE025 (cAliasSFT, @aRegE025, cSituaDoc, lIss)

								If (cEspecie$"01") .OR. (MV_PAR05 == 2 .And. ACONJUGADA[1] .AND. ACONJUGADA[2])	//Somente para o Modelo 01
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³REGISTRO C310 - OPERACOES COM ISS³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									If lIss
										RegC310 (cAlias, nRelacDoc, cAliasSFT, nItem)
									EndIf
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³REGISTRO C315 - OPERACOES COM MEDICAMENTOS³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									If (SB1->B1_GRUPO$cMVMEDICA)//Grupo que define operacoes com medicamentos
										RegC315 (cAlias, nRelacDoc, nItem, lAchouSB5, cAlsSD, lAchouSB8, aMVRC315)
									EndIf

									If (SB1->B1_GRUPO$cMVARMFOG)//Grupo que define operacoes com armas de fogo
										RegC320 (cAlias, nRelacDoc, aMVRC320, nItem, lAchouSB5)
									EndIf

									If (SB1->B1_GRUPO$cMVVEICNV)//Grupo que define operacoes com veiculos novos
										RegC325 (cAlias, nRelacDoc, aMVRC325, aPartDoc, nItem, lAchouSB5)
									EndIf
								EndIf

							ElseIf (cEspecie$"02#65")	//NFCF/CF/NFCE  
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³REGISTRO C555 - ITENS DO DOCUMENTO (MODELO 02)³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If !lIss
									RegC555 (cAlias, nRelacDoc, aRegC300, cAliasSFT, nItem, cClasFis, cCmpUm)
								EndIf
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³REGISTRO C580 - RESUMO MENSAL DOS ITENS DAS NOTAS FISCAIS DE VENDA CONSUMIDOR[MODELO 02)³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								//If !lDf	 // Registro C580 nao previsto para o Distrito Federal
								//	RegC580 (aRegC300, @aRegC580, cSituaDoc)
								//EndIf
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³REGISTRO E050 - REGISTRO MESTRE DE NOTA FISCAL DE VENDA A CONSUMIDOR (MODELO 02)³
								//³REGISTRO E055 - REGISTRO ANALITICO DO DOCUMENTO (MODELO 02)                     ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If !lIss
									E050E055 (@aRegE050, @aRegE055, aCmpAntSFT, cAliasSFT, cEspecie, cSituaDoc, cChaveF3)
								EndIf
							ElseIf (cEspecie$"2D")	//CF
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³REGISTRO C605 - ITENS DO DOCUMENTO (MODELO 2D)³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If !( cSituaDoc $ "02#03#04" )
									RegC605 (	cAlias   , nRelacDoc, aRegC300     , nItem    , ;
												lISS     , @aRegC605, cSituaDoc    , cCmpVlAcr, ;
												cAliasSFT, cClasFis , @aRegC600Veri,dDataDe   , ;
												dDataAte , cFilDe   , cFilAte      ,@aReg02Aux, ;
												cCmpUm  )
								EndIf
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³REGISTRO C640 - RESUMO MENSAL DOS ITENS DAS NOTAS FISCAIS DE VENDA CONSUMIDOR[MODELO 2D)³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								//If !lDf // Registro C640 nao previsto para o Distrito Federal
								//	RegC640 (	aRegC300	, @aRegC640, cSituaDoc, aRegC605, ;
								//				aCmpAntSFT )
								//EndIf

								E060E065(cAlias, nRelacDoc, aRegC020, @aRegE060, @aRegE065, nItem, aTotalISS, aTotaliza,;
										lISS, aCmpAntSFT, cSituaDoc, cAliasSFT, cCmpVlAcr, aRegC300)
								If !lIss .AND. !( cSituaDoc $ "02#03#04" )
									E080E085 (	cAlias   , nRelacDoc , aRegC020 , @aRegE080, ;
												@aRegE085, nItem     , aTotalISS, aTotaliza, ;
												lISS     , aCmpAntSFT, cSituaDoc, cAliasSFT, ;
												cCmpVlAcr, aRegC300  )
								EndIf
								If lIss .AND. !( cSituaDoc $ "02#03#04" )
									B050B055 (	cAlias   , nRelacDoc , aRegC020 , @aRegB050, ;
												@aRegB055, nItem     , aTotalISS, aTotaliza, ;
												lISS     , aCmpAntSFT, cSituaDoc, cAliasSFT, ;
												cCmpVlAcr, aRegC300  )
								EndIf
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³  REGISTRO B040: LANÇAMENTO - REDUÇÃO Z/ISS   ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If lIss
									B040B045(cAlias, nRelacDoc, @aRegB040, @aRegB045, nItem, lISS, aCmpAntSFT, cSituaDoc , cAliasSFT, cCmpVlAcr )
								Endif

							ElseIf (cEspecie$"06")	//Somente modelo 06
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³REGISTRO C750 - ITENS DO DOCUMENTO (MODELO 06)³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								RegC750 (cAlias, nRelacDoc, aRegC300, aPartDoc, @aRegC750, nItem, lAchouSFU, cEntSai, cAliasSFT, nItem, cClasFis, cCmpUm)
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³REGISTRO C760 - REGISTRO ANALITICO DOS DOCUMENTOS FISCAIS (MODELOS 06, 21 E 22)³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								//If cEntSai=="2" .AND. !lDf // Somente o prestador deve informar este registro // Registro nao previsto para o Distrito Federal
								//	RegC760 (cAlias, cAliasSFT, @aRegC760, cSituaDoc, cClasFis, cEntSai, nRelacDoc, nItem)
								//EndIf

							ElseIf (cEspecie$"21#22")	//Somente modelo 21 e 22
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³REGISTRO D450 - ITENS NOTA FISCAL DE SERVICO DE COMUNICACAO (MODELO 21) E NOTA FISCAL DE SERVICO DE TELECOMUNICACAO (MODELO 22)³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								RegD450 (cAlias, nRelacDoc, aRegC300, @aRegD450, aPartDoc, nItem, lAchouSFX, cEntSai, cAliasSFT, nItem, cClasFis, cCmpUm)
							EndIf

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³SOMENTE MODELOS:                                          ³
						//³07 - NOTA FISCAL SERVICO DE TRANSPORTE - SAIDA/ENTRADA    ³
						//³08 - CONHECIMENTO DE TRANSPORTE RODOVIARIO - SAIDA/ENTRADA³
						//³09 - CONHECIMENTO DE TRANSPORTE AQUAVIARIO - ENTRADA      ³
						//³10 - CONHECIMENTO DE TRANSPORTE AEREO - ENTRADA           ³
						//³11 - CONHECIMENTO DE TRANSPORTE FERROVIARIO - ENTRADA     ³
						//³13 - BILHETES DE PASSAGEM RODOVIARIO                      ³
						//³15 - PASSAGEM E NOTA DE BAGAGEM                           ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						ElseIf (cEspecie$"#07#08#09#10#11#13#15#57")
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³REGISTRO E120:                                          ³
							//³      - NOTA FISCAL DE SERVICO DE TRANSPORTE (MODELO 07)³
							//³      - CONHECIMENTO DE FRETE (MODELO 08)               ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							RegE120 (cAlias, nRelacDoc, @aRegE120, cEntSai, aPartDoc, cEspecie, cSituaDoc, aCmpAntSFT, cAliasSFT, cChave, cCodObs)
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³REGISTRO E140 - Ponto de Entrada                   ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If (cEspecie$"#08#09#11#13#15#57") .and. lBlocoE
								If lCOTE140
									ExecBlock("COTE140",.F.,.F.,{cAlias, cAliasSFT, nRelacDoc, aPartDoc, cSituaDoc, cEntSai})
								Endif
							Endif
							//
							If (cEspecie$"07") .And. cEntSai=="2" .And. ("1"$aWizard[1][7]) 	//Mesmo se tratando do item do registro D020, 
																								//  o validador somente aceita para prestacao de servico
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³REGISTRO D040 - NOTA FISCAL DE SERVICO DE TRANSPORTE (MODELO 07)³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								RegD040 (cAlias, @aRegD040, cAliasSFT)
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³REGISTRO 0200 - TABELA DE IDENTIFICACAO DO ITEM³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								//Dentro da funcao acima ja contem a chamada do cara abaixo para gravacao
								//Reg0200()

							EndIf
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³REGISTRO D200 - Ponto de Entrada                   ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If (cEspecie$"#08#09#11#13#15#57")
								If lCOTD200
									ExecBlock("COTD200",.F.,.F.,{cAlias, cAliasSFT, nRelacDoc, aPartDoc, cSituaDoc, cEntSai})
								Endif
							EndIf
						EndIf
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³SOMENTE MODELOS:                               ³
						//³01 - NOTA FISCAL NORMAL                        ³
						//³02 - NOTA FISCAL DE VENDA A CONSUMIDOR FINAL   ³
						//³03 - NOTA FISCAL DE SERVICO                    ³
						//³04 - NOTA FISCAL PRODUTOR                      ³
						//³06 - NOTA FISCAL/CONTA DE ENERGIA ELETRICA     ³
						//³07 - NOTA FISCAL SERVICO DE TRANSPORTE         ³
						//³08 - CONHECIMENTO DE TRANSPORTE RODOVIARIO     ³
						//³09 - CONHECIMENTO DE TRANSPORTE AQUAVIARIO     ³
						//³10 - CONHECIMENTO DE TRANSPORTE AEREO          ³
						//³11 - CONHECIMENTO DE TRANSPORTE FERROVIARIO    ³
						//³21 - NOTA FISCAL DE SERVICO DE COMUNICACAO     ³
						//³22 - NOTA FISCAL DE SERVICO DE TELECOMUNICACAO ³
						//³55 - NOTA FISCAL ELETRONICA                    ³
						//³57 - CONHECIMENTO DE TRANSPORTE ELETRONICO     ³
						//³65 - NOTA FISCAL DE CONSUMIDOR ELETRÔNICA NFC-e³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If (cEspecie$"01#02#2D#03#04#06#07#08#09#10#11#13#15#21#22#55#57#65")
							If cEspecie$"03" .Or. (cEspecie $ "2D" .AND. lIss)	// NFS/NFPS
								// Sendo um cupom com serviço deve gerar os registros de livro Fiscal de serviço municipal
								If cEspecie $ "2D#03" .AND. lIss
									lGeraReg := .T.
								EndIf
								If cEspecie$"03"
									If lDf .And. cEspeNFS == Alltrim(Substr(cMvNfSS,At("=",cMvNfSS)+1,5)) .And. cEntSai == "2"
										//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
										//³REGISTRO A310 - ITENS DO DOCUMENTO FISCAL/ISSQN (Modelo Simplificado) ³
										//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
										RegA310 (cAlias, nRelacDoc, nItem, @aRegA310, cAliasSFT, aRegC300, lGeraReg, cEspecie, cCmpUm)
									Else
										//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
										//³REGISTRO A200 - ITENS DO DOCUMENTO FISCAL/ISSQN³
										//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
										nItemA200 ++
										RegA200 (cAlias, nRelacDoc, nItem, @aRegA200, cAliasSFT, aRegC300, nItemA200, cEspecie, cAlsSD, cCmpUm)
									EndIf
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³REGISTRO A025 - Tributos federais³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									//If !lDf
									//	RegA025 (cAliasSFT, @aRegA025)
									//EndIf
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³REGISTRO A035 - ICMS (NOTA CONJUGADA)  ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									//If !(lIss .And. lDf)
									//	RegA035 (cAliasSFT, @aRegA035)
									//EndIf
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³REGISTRO B025 - REGISTRO ANALITICO DO DOCUMENTO FISCAL (MODELO 03)     ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									RegB025 (cAliasSFT, @aRegB025, cSituaDoc, lIssRet)
								EndIf
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³REGISTRO B410 - TOTALIZACAO DOS VALORES DE AQUISICAO E PRESTACAO³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If !(cSituaDoc$"02#03#04")
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³REGISTRO B350 - SERVICOS PRESTADOS POR INSTITUIÇÕES FINANCEIRAS ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									If aPartDoc[08] <> "EX" .And. lB350
										RegB350(cAliasSFT, @aWizard, @aRegB350, cSituaDoc, aPartDoc, lIssRet)
									Endif

									RegB410 (cAliasSFT, cEntSai, @aRegB410, aPartDoc, lIssRet, lGeraReg)

									If (cEntSai=="2")
										//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
										//³REGISTRO B420 - RELATORIO DOS VALORES POR ALIQUOTA              ³
										//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
										RegB420 (cAliasSFT, @aRegB420, lIssRet)
									EndIf
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³REGISTRO B430 - RELATORIO DOS VALORES POR CFPS                  ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									RegB430 (cAliasSFT, @aRegB430, lIssRet, cCfps)

									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³REGISTRO B440 - RELATORIO DOS VALORES RETIDOS                   ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									If lIssRet
										RegB440 (cAliasSFT, cEntSai, @aRegB440, aPartDoc)
									EndIf
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³REGISTRO B450 - RELATORIO DOS VALORES MUNICIPIO                 ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									If aPartDoc[08] <> "EX"
										RegB450 (cAliasSFT, cEntSai, @aRegB450, cSituaDoc, aPartDoc, lIssRet, cB1MepLes, lMvISSxMun, cCmpCdEst, cCmpCdMun)
									Endif

									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³REGISTRO - DEDUCOES DO ISSQN³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									If Empty( aRegB460 )
										RB460465(@aRegB460, dDataAte, cNrLivro, aRegB465, cAlias, @aReg0450)
										aRegB470[12] += aRegB465[4]
									Endif
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³REGISTRO B470 - SALDOS DO ISSQN A RECOLHER  ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									RegB470 (cAliasSFT, @aRegB470, cSituaDoc, aPartDoc, lIssRet, cEntSai, lGeraReg , cEspecie, cMunSgmt, cB1MepLes)

									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³REGISTRO B475 - RELATÓRIO DOS VALORES A RECOLHER POR FILIAL     ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									If aPartDoc[08] <> "EX" .And. lB475
										RegB475(cAliasSFT, cEntSai, @aRegB475, cSituaDoc, aPartDoc, lIssRet)
									Endif

									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³REGISTRO B480 - OBRIGAÇÕES A RECOLHER POR MUNICÍPIO             ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

									// Apenas para saidas pois nas entradas o campo 16 do registro B470 nao eh alimentado.									
									If aPartDoc[08] <> "EX" .And. cEntSai == "2"
										RegB480(cAliasSFT, cEntSai, @aRegB480, cSituaDoc, aPartDoc, lIssRet, cMunSgmt, cB1MepLes)
									Endif

									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³REGISTRO E310 - CONSOLIDACAO DOS VALORES DE ICMS POR CFOP       ³
									//³REGISTRO E320 - TOTALIZACAO DOS VALORES POR UNIDADE DE FEDERACAO³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									If (cEspecie $ "2D" .And. lIss)
										If lBlocoE
											E310E320 (cAliasSFT, cEntSai, @aRegE310, @aRegE320, cSituaDoc, lIss, cEspecie)
										Else
											lReg0150 := .F.
										EndIf
									EndIf
								EndIf
							Else
								If lBlocoE
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³REGISTRO E310 - CONSOLIDACAO DOS VALORES DE ICMS POR CFOP       ³
									//³REGISTRO E320 - TOTALIZACAO DOS VALORES POR UNIDADE DE FEDERACAO³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									E310E320 (cAliasSFT, cEntSai, @aRegE310, @aRegE320, cSituaDoc, lIss, cEspecie)
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³REGISTRO E510 - CONSOLIDACAO DOS VALORES DE IPI POR CFOP E CODIGO DE SITUACAO TRIBUTARIA³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									If (cAliasSFT)->FT_BASEIPI > 0 .And. (cAliasSFT)->FT_VALIPI > 0
										RegE510 (cAliasSFT, @aRegE510, cSituaDoc, cEntSai)
									EndIf
								Else
									lReg0150 := .F.
								EndIf
							EndIf
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³REGISTRO 0400 - TABELA DE NATUREZA DA OPERACAO/PRESTACAO³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If !Empty(cCodNat) .And. lBlocoE
								Reg0400(cCodNat, cDscNat, @aReg0400)
							EndIf
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³Como esta tabela possui escrituracao fiscal   ³
							//³ por item de documento fiscal, acumulo valores³
							//³ necessarios independente dos itens, ou seja, ³
							//³ por NF.                                      ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If lIss // Se eh servico
								aTotalISS[01] += (cAliasSFT)->FT_VALCONT
								aTotalISS[02] += (cAliasSFT)->FT_BASEICM
								aTotalISS[03] += (cAliasSFT)->FT_VALICM
								aTotalISS[04] += (cAliasSFT)->FT_BASERET
								aTotalISS[05] += (cAliasSFT)->FT_ICMSRET
								aTotalISS[07] += (cAliasSFT)->FT_ISENICM
								aTotalISS[06] += (cAliasSFT)->FT_VALIPI
								aTotalISS[08] += (cAliasSFT)->FT_QUANT
								aTotalISS[09] += (cAliasSFT)->FT_DESCONT
								aTotalISS[10] += (cAliasSFT)->FT_TOTAL
								aTotalISS[11] += (cAliasSFT)->FT_FRETE
								aTotalISS[12] += (cAliasSFT)->FT_SEGURO
								aTotalISS[13] += (cAliasSFT)->FT_DESPESA
								aTotalISS[14] += (cAliasSFT)->FT_OUTRICM
								aTotalISS[15] += (cAliasSFT)->FT_BASEIPI
								aTotalISS[16] += (cAliasSFT)->FT_ISENIPI
								aTotalISS[17] += (cAliasSFT)->FT_OUTRIPI
								aTotalISS[18] += (cAliasSFT)->FT_ICMSCOM
								aTotalISS[19] += (cAliasSFT)->FT_BASEICM	//	Base ISS
								aTotalISS[20] += (cAliasSFT)->FT_VALICM		//	Vlr ISS
								If lIssRet
									If lISSTomador
										//-- Busca os valores de ISS Ret. na nova funcionalidade ISSFISCAL - 15/02/2016
										cAliasFIN := ISSFiscal(dDataDe, dDataAte, (cAliasSFT)->FT_CLIEFOR, (cAliasSFT)->FT_LOJA, "00108")
										(cAliasFIN)->(DbGoTop ())
										aTotalISS[21] += (cAliasFIN)->BASEISS		//	Base ISS RET
										aTotalISS[22] += (cAliasFIN)->VALORISS		//	Vlr ISS RET
										(cAliasFIN)->(dbCloseArea())
									Else
										aTotalISS[21] += (cAliasSFT)->FT_BASEICM	//	Base ISS RET
										aTotalISS[22] += (cAliasSFT)->FT_VALICM		//	Vlr ISS RET
									EndIf
								EndIf
								aTotalISS[23] += (cAliasSFT)->FT_ISENICM
								aTotalISS[24] += (cAliasSFT)->FT_ISSSUB
								If cEntSai == "2" .And. cEspecie $ "2D"
									aTotalISS[25] += &(cCmpVlAcr)
								Else
									aTotalISS[25] := 0
								EndIf
							Else
								aTotaliza[01] += (cAliasSFT)->FT_VALCONT
								aTotaliza[02] += (cAliasSFT)->FT_BASEICM
								aTotaliza[03] += (cAliasSFT)->FT_VALICM
								aTotaliza[04] += (cAliasSFT)->FT_BASERET
								aTotaliza[05] += (cAliasSFT)->FT_ICMSRET+(cAliasSFT)->FT_DIFAL
								aTotaliza[06] += (cAliasSFT)->FT_VALIPI
								//Quando configuro a TES para escriturar o Livro de ICMS/ST como OUTROS, na tabela SF3 o valor do campo 
								//  F3_ICMSRET eh transportado para o campo F3_OUTRICM, ficando com os mesmos valores. Na tabela SFT, que
								//  possui o campo proprio FT_OUTRRET, recebe este valor deixando o campo FT_OUTRICM e FT_ICMSRET zerado.
								aTotaliza[07] += (cAliasSFT)->FT_ISENICM+(cAliasSFT)->FT_ISENRET
								aTotaliza[08] += (cAliasSFT)->FT_QUANT
								aTotaliza[09] += (cAliasSFT)->FT_DESCONT
								aTotaliza[10] += (cAliasSFT)->FT_TOTAL
								aTotaliza[11] += (cAliasSFT)->FT_FRETE
								aTotaliza[12] += (cAliasSFT)->FT_SEGURO
								aTotaliza[13] += (cAliasSFT)->FT_DESPESA
								//Quando configuro a TES para escriturar o Livro de ICMS/ST como OUTROS, na tabela SF3 o valor do campo 
								//  F3_ICMSRET eh transportado para o campo F3_OUTRICM, ficando com os mesmos valores. Na tabela SFT, que
								//  possui o campo proprio FT_OUTRRET, recebe este valor deixando o campo FT_OUTRICM e FT_ICMSRET zerado.
								aTotaliza[14] += (cAliasSFT)->FT_OUTRICM+(cAliasSFT)->FT_OUTRRET
								aTotaliza[15] += (cAliasSFT)->FT_BASEIPI
								aTotaliza[16] += (cAliasSFT)->FT_ISENIPI
								aTotaliza[17] += (cAliasSFT)->FT_OUTRIPI
								aTotaliza[18] += (cAliasSFT)->FT_ICMSCOM
								If cEntSai == "2" .And. cEspecie $ "2D"
									aTotaliza[19] += &(cCmpVlAcr)
									//Valor do ICMS ST qdo for do loja
									If Substr((cAliasSFT)->FT_CLASFIS,2,2)=="60"
										aTotaliza[20] += (cAliasSFT)->FT_VALCONT
									Endif
								Else
									aTotaliza[19] := 0
									aTotaliza[20] := 0
								EndIf
							EndIf
						EndIf
						nItem++
						(cAliasSFT)->(DbSkip ())
					EndDo
					//-- Não continuar se não encontrou itens.
					If nItem == 1
						Loop
					EndIf
					//Complemento do Registro E120
					If Len(aRegE120)>0 .And. !Empty(cObs) .And. !(cSituaDoc$"02#03#04") .and. lBlocoE
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³REGISTRO 0450 - TABELA DE INFORMACOES COMPLEMENTARES/OBSERVACOES³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						Reg0450(cAlias, nRelacDoc, cObs, cChave, cCodObs, @aReg0450)
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³REGISTRO 0455 - NORMA REFERENCIADA³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						Reg0455 (cAlias, nRelacDoc, aLeis)
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³REGISTRO 0460 - DOCUMENTO DE ARREADACAO REFERENCIADO³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						Reg0460 (aWizard, cAlias, dDataDe, dDataAte, nRelacDoc,aCmpAntSFT)
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³REGISTRO 0465 - DOCUMENTO FISCAL REFERENCIADO³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If (aCmpAntSFT[19] $ "D/B/I/P/C")
							Reg0465 (cAlias, nRelacDoc, aRegE120, cEntSai, aPartDoc, aTotalISS, lSm0, "E120", aTotaliza)
						EndIf
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Este tratamento se dah devido a troca da especie quando for nota fiscal de servico ou nota fiscal conjugada.³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//alteração petz	//cEspecie := cEspAux

					If Interrupcao(lEnd)
						Exit
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³SOMENTE MODELOS:                              ³
					//³01 - NOTA FISCAL NORMAL                       ³
					//³02 - NOTA FISCAL PRODUTOR                     ³
					//³03 - NOTA FISCAL DE SERVICOS                  ³
					//³04 - NOTA FISCAL DE VENDA A CONSUMIDOR FINAL  ³
					//³06 - NOTA FISCAL/CONTA DE ENERGIA ELETRICA    ³
					//³21 - NOTA FISCAL DE SERVICO DE COMUNICACAO    ³
					//³22 - NOTA FISCAL DE SERVICO DE TELECOMUNICACAO³
					//³55 - NOTA FISCAL ELETRONICA                   ³
					//³65 - NOTA FISCAL DE CONSUMIDOR ELETRÔNICA NFC-e³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If (cEspecie$"01#02#2D#03#04#06#21#22#55#65")
						If aTotalISS[24]<>0 .And. Empty(cObs)
							cCodObs	:= cChave
							cObs	:= "ISS SUBEMPREITADA"
						EndIf
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³REGISTRO C020 - NOTA FISCAL CODIGO 01, NOTA FISCAL PRODUTOR CODIGO 04, NOTA FISCAL ELETRONICA CODIGO 55³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//						If  aTotalISS[2]==0
//						Nao estava gerando o c20 para as demais notas apos preencher a primeira n conjug indica que ira passar apenas no primeiro item
//						os demais nao ira passar aqui
						If	(MV_PAR05 == 1 .And. aTotalISS[2] == 0) .Or. (MV_PAR05 == 2 .And. empty(nConjug))
							If (cAliasSFT)->FT_DIFAL>0 //se tiver valor do Difal indica na observação
								cCodObs	:= "DIFALEC87DF"
								cObs	:= "Operacoes sujeitas a diferenca de aliquota da EC 87/2015  "
							Endif
							//Somente sera gravado para os modelos 01/04/55, no outros casos, sera somente montado o array.
							RegC020(cEntSai,aPartDoc,cEspecie,cAlias,nRelacDoc,aCmpAntSFT,aTotaliza,@aRegC020,cChave,cSituaDoc,lAchouSE4,@lContrTare,cCodObs,aconjugada,cCodNat)
							nConjug := 1
						Endif
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Processanto geracao dos REGISTROS 0450, 0460 e 0465³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If !cEspecie$"02#65" .And.;
							!Empty (cObs) .And. !(cSituaDoc$"02#03#04")
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³REGISTRO 0450 - TABELA DE INFORMACOES COMPLEMENTARES/OBSERVACOES³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							Reg0450(cAlias, nRelacDoc, cObs, cChave, cCodObs, @aReg0450)
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³REGISTRO 0455 - NORMA REFERENCIADA³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							Reg0455 (cAlias, nRelacDoc, aLeis)
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³REGISTRO 0460 - DOCUMENTO DE ARREADACAO REFERENCIADO³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							Reg0460 (aWizard, cAlias, dDataDe, dDataAte, nRelacDoc,aCmpAntSFT)
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³REGISTRO 0465 - DOCUMENTO FISCAL REFERENCIADO³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If ("CF/SERIE:" $ cObs) .Or. (aCmpAntSFT[19] $ "D/B/I/P/C")
								Reg0465 (cAlias, nRelacDoc, aRegC020, cEntSai, aPartDoc, aTotalISS, lSm0, "C020", aTotaliza)
							EndIf
						EndIf

						If (cEspecie$"01#04#55")
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³REGISTRO C030 - FATURA e C035 - VENCIMENTO DA FATURA³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If  (MV_PAR05 == 1 .And. aTotalISS[2]==0) .Or. (MV_PAR05 == 2 .And. nConjug==1)
								C030C035 (cAlias, nRelacDoc, cEntSai, aCmpAntSFT, aRegC020)
							EndIf
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³GRAVACAO - REGISTRO C040 - ISS³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If (aRegC040[4]+aRegC040[7]+aRegC040[9]>0)
								If lBloqCD
									GrvRegTrb (cAlias, nRelacDoc, {aRegC040})
								EndIf
							EndIf
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³GRAVACAO - REGISTRO C050 - PIS/COFINS³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If (aRegC050[3]+aRegC050[5]>0)
								If lBloqCD	
									GrvRegTrb (cAlias, nRelacDoc, {aRegC050})
								EndIf
							EndIf
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³GRAVACAO - REGISTRO C500 - REGISTRO ANALITICO DO DOCUMENTO³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							//GrvRegTrb (cAlias, nRelacDoc, aRegC500)
							//
							If (cEspecie$"01")
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³REGISTRO C060 - DECLARACAO/BASE DE CALCULO DE IMPORTACAO (MODELO 01)³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If (cEntSai=="1")
									RegC060 (cAlsSF, cAlias, nRelacDoc, aCmpAntSFT)
								EndIf
							EndIf
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³GRAVACAO REGISTRO E020 - REGISTRO MESTRE NOTA FISCAL (MODELO 01) E NOTA FISCAL DE PRODUTOR (MODELO 04)      ³
							//³GRAVACAO REGISTRO E025 - REGISTRO ANALITICO DE NOTA FISCAL (MODELO 01) E NOTA FISCAL DE PRODUTOR (MODELO 04)³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If  (MV_PAR05 == 1 .And. (aTotalISS[2]==0 .Or. (aConjugada[1] .And. aConjugada[2]))) .Or. (MV_PAR05 == 2 .And. nConjug==1)
								If (cAliasSFT)->FT_DIFAL>0 //se tiver valor do Difal indica na observação
									cCodObs := "DIFALEC87DF"
									cObs    := "Operacoes sujeitas a diferenca de aliquota da EC 87/2015  "
								Endif
								RegE020 (cAlias, cEntSai, aCmpAntSFT, aPartDoc, aTotaliza, nRelacDoc, cChave, cEspecie, aRegE025, cSituaDoc, aMVE020CF, cCodObs, lBlocoE)
								nConjug := 2
							EndIf
						ElseIf (cEspecie$"02#65")	//Modelo 02 e 65
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³REGISTRO C550 - NOTA FISCAL DE VENDA A CONSUMIDOR(MODELO 02)³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							RegC550 (cAlias, nRelacDoc, aRegC020, nItem, aPartDoc)
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³REGISTRO C570 - RESUMO DIARIO DAS NOTAS FISCAIS DE VENDA A CONSUMIDOR(MODELO 02)³
							//³REGISTRO C575 - ITENS DO RESUMO DIARIO DOS DOCUMENTOS(MODELO 02)                ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							//If !lDf // Registro C570/C575 nao previsto para o Distrito Federal
							//	C570C575 (aRegC020, aRegC300, @aRegC570, @aRegC575)
							//EndIf

						ElseIf (cEspecie$"2D")	//Modelo 2D
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³REGISTRO C600 - NOTA FISCAL DE VENDA A CONSUMIDOR(MODELO 2D)³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If !( cSituaDoc $ "02#03#04" )
								RegC600 (	cAlias		, nRelacDoc, aRegC020	, @aRegC600	, ;
											nItem		, aTotalISS, aTotaliza	, lISS		, ;
											aCmpAntSFT	, cSituaDoc, cEspecie	, aPartDoc	, ;
											@aReg02Aux	, dDataDe  , dDataAte	,cFilDe		, ;
											cFilAte		, @aRegC600Veri, cAliasSFT )
							EndIf
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³REGISTRO C620 - RESUMO DIARIO DAS NOTAS FISCAIS DE VENDA A CONSUMIDOR(MODELO 02)³
							//³REGISTRO C625 - ITENS DO RESUMO DIARIO DOS DOCUMENTOS(MODELO 2D)                ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							//If !lDf // Registro C620/C625 nao previsto para o Distrito Federal
							//	C620C625 (	aRegC020	, aRegC300	, @aRegC620	, @aRegC625	, ;
							//				aTotalISS	, aTotaliza	, lISS		, aCmpAntSFT, ;
							//				aRegC605	, cAliasSFT)
							//EndIf
						EndIf

						If Len(aRegB025)>0	//Se o array aRegB025 estiver preenchido, indica que a NF possui servico
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³O registro 0150 deve acompanhar os registro B, C e D, como este registro nao eh gerado para o ³
							//³  modelo "02"(tramento do inicio do while do cabecalho da nota fiscal, devo efetuar este      ³
							//³	 tratamento neste momento, pois no caso de notas fiscais especie 02 CONJUGADA, este registro ³
							//³	 deve acompanhar o B020.                                                                     ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If cEspecie$"02#65"
								Reg0150 (aPartDoc)
							EndIf

							// Obtenho o modelo novamente pois NFEs (Mod.55) não deverão ser escrituradas como "03" nos registros A020 e B020.
							cEspecol := cEspecie
							cEspecie := IIf(AModNot(aCmpAntSFT[21]) == "55", "55", cEspecie)

							If lDf .And. cEspeNFS == Alltrim(Substr(cMvNfSS,At("=",cMvNfSS)+1,5)) .And. cEntSai == "2"
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³REGISTRO A300 - NOTA FISCAL DE SERVICOS (MODELO SIMPLIFICADO) ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								RegA300(cAlias, aTotalISS, aCmpAntSFT, cAliasSFT, cSituaDoc, cEspecie, cCfps, cChave, cMvNfSS, cCodObs, lGeraReg, nRelacDoc, aRegA310)
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³REGISTRO A320 - DOCUMENTOS - RESUMO DIARIO DE NOTA FISCAL DE SERVICOS (MODELO SIMPLIFICADO)³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								RegA320(aRegA320,aTotalISS,aCmpAntSFT,cAliasSFT,cSituaDoc,cEspecie,cCfps,cMvNfSS,nRelacDoc)
							Else
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³REGISTRO A020 - NOTA FISCAL DE SERVICOS ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								RegA020 (cEntSai, aPartDoc, cEspecie, cAlias, nRelacDoc, aCmpAntSFT, aTotalISS, @aRegA020, cChave, cSituaDoc, lAchouSE4, cCfps, cCodObs, cCmpAbtIss, cB1MepLes, lMvISSxMun, cCmpCdEst, cCmpCdMun, cCodNat)
							EndIf
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³GRAVACAO - REGISTRO A025 - TRIBUTOS FEDERAIS³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							//If (aRegA025[4]+aRegA025[6]+aRegA025[8]+aRegA025[10]>0)
							//	GrvRegTrb (cAlias, nRelacDoc, {aRegA025})
							//EndIf
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³GRAVACAO - REGISTRO A035 - ICMS      ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							//If (aRegA035[7]+aRegA035[9]+aRegA035[10]>0)
							//	GrvRegTrb (cAlias, nRelacDoc, {aRegA035})
							//EndIf
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³REGISTRO A050 - FATURA e A055 - VENCIMENTO DA FATURA³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							//If !lDf
							//	A050A055 (cAlias, nRelacDoc, cEntSai, aCmpAntSFT, aRegA020)
							//EndIf
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³GRAVACAO REGISTRO B020 - LANCAMENTO DE NOTA FISCAL DE SERVICOS (MODELO 03)  ³
							//³GRAVACAO REGISTRO B025 - VALORES PARCIAIS DO LANCAMENTO (MODELO 03)         ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							B020B025 (cAlias, cEntSai, aCmpAntSFT, aPartDoc, aTotalISS, nRelacDoc, cChave, cEspecie, aRegB025, cSituaDoc, cCfps, cCodObs, lGeraReg, cB1MepLes, lMvISSxMun, cCmpCdEst, cCmpCdMun)
							If lDf .And. cEspeNFS == Alltrim(Substr(cMvNfSS,At("=",cMvNfSS)+1,5)) .And. cEntSai == "2"
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³GRAVACAO REGISTRO B030 - LANCAMENTO DE NOTA FISCAL DE SERVICOS (MODELO SIMPLIFICADO)³
								//³GRAVACAO REGISTRO B035 - VALORES PARCIAIS DO LANCAMENTO                             ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								B030B035(aRegB030,aRegB035,aCmpAntSFT,aTotalISS,aCmpAntSFT,cSituaDoc,cCfps,cMvNfSS,cCodObs)
							EndIf
							cEspecie := cEspecol
						ElseIf (cEspecie$"06")
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³REGISTRO C700 - NOTA FISCAL/CONTA ENERGIA ELETRICA (MODELO 06)³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							RegC700 (cAlias, nRelacDoc, aRegC020, aTotaliza, @aRegC700, nItem, lAchouSFU)
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³REGISTRO C705 - IDENTIFICACAO DO TERMINAL FATURADO (MODELO 06)³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If cEntSai <> "1" 
								RegC705 (cAlias, nRelacDoc, nItem, lAchouSFU)
								//Conforme alteração do chamado TFGX62, os registros C770 e C775 não deverão ser gerados para operações de entradas.
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³REGISTRO C770 - CONSOLIDACAO DE NOTAS FISCAIS/CONTA DE ENERGIA ELETRICA (MODELO 06)|
								//³REGISTRO C775 - ITENS DO DOCUMENTO CONSOLIDADO (MODELO 06)                         ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								C770C775 (aRegC700, aRegC750, aTotaliza, aPartDoc, aCmpAntSFT, @aRegC770, @aRegC775, cAliasSFT)
							EndIf
							If lBlocoE
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³REGISTRO E100 - MESTRE DE NOTA FISCAL CONTA DE ENERGIA ELETRICA (MODELO 06), COMUNICACAO (MODELO 21) E TELECOMUNICACAO (MODELO 22)³
								//³REGISTRO E105 - REGISTRO ANALITICO POR CFOP DOS DOCUMENTOS (MODELOS 06, 21 E 22)                                                  ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								E100E105 (cAlias, cEntSai, aCmpAntSFT, aPartDoc, aTotaliza, nRelacDoc, cChave, cEspecie, aRegE105, cSituaDoc, lAchouSFU, lAchouSFX, cCodObs)
							Else
								lReg0150 := .F.
							EndIf
						ElseIf (cEspecie$"21#22")	//Somente para o Modelo 21 e 22
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³REGISTRO D400 - NOTA FISCAL DE SERVICO DE COMUNICACAO (MODELO 21) E NOTA FISCAL DE SERVICO DE TELECOMUNICACAO (MODELO 22)³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							RegD400 (cAlias, nRelacDoc, aRegC020, aTotaliza, aCmpAntSFT, @aRegD400, nItem, lAchouSFX)
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³TERMINAL FATURADO (MODELO 21 E 22)³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							RegD405 (cAlias, nRelacDoc, nItem, lAchouSFX)
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³REGISTRO D470 - CONSOLIDACAO DE NOTA FISCAL DE SERVICO DE COMUNICACAO (MODELO 21) E NOTA FISCAL DE SERVICO DE TELECOMUNICACAO (MODELO 22)     ³
							//³REGISTRO D475 - ITENS CONSOLIDADO DE NOTA FISCAL DE SERVICO DE COMUNICACAO (MODELO 21) E NOTA FISCAL DE SERVICO DE TELECOMUNICACAO (MODELO 22)³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							D470D475 (aRegD400, aTotaliza, aPartDoc, aCmpAntSFT, @aRegD470, aRegD450, @aRegD475)
							If lBlocoE
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³REGISTRO E100 - MESTRE DE NOTA FISCAL CONTA DE ENERGIA ELETRICA (MODELO 06), COMUNICACAO (MODELO 21) E TELECOMUNICACAO (MODELO 22)³
								//³REGISTRO E105 - REGISTRO ANALITICO POR CFOP DOS DOCUMENTOS (MODELOS 06, 21 E 22)                                                  ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								E100E105 (cAlias, cEntSai, aCmpAntSFT, aPartDoc, aTotaliza, nRelacDoc, cChave, cEspecie, aRegE105, cSituaDoc, lAchouSFU, lAchouSFX,cCodObs)
							Else
								lReg0150 := .F.
							EndIf
						EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³SOMENTE MODELOS:                                          ³
					//³07 - NOTA FISCAL SERVICO DE TRANSPORTE - SAIDA/ENTRADA    ³
					//³08 - CONHECIMENTO DE TRANSPORTE RODOVIARIO - SAIDA/ENTRADA³
					//³09 - CONHECIMENTO DE TRANSPORTE AQUAVIARIO - ENTRADA      ³
					//³10 - CONHECIMENTO DE TRANSPORTE AEREO - ENTRADA           ³
					//³11 - CONHECIMENTO DE TRANSPORTE FERROVIARIO - ENTRADA     ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					ElseIf (cEspecie$"#07#08#09#10#11#57")
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³As informacoes CTR e NFST necessarias para o SINTEGRA somente estao disponiveis           |
						//³ quando o TMS estiver envolvido (SAIDAS) ou ENTRADAS quando envolver aviso de recebimento.³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If (cEntSai=="1" .Or. (cEntSai=="2" .And. IntTms ())) .And. ("1"$aWizard[1][7])
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//|                       SAIDA                         |
							//|Quanto for NF de Saida e houver integracao com o TMS |
							//|  utilizo a regra do modulo TMS                      |
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If (cEntSai=="2")
								If DT6->DT6_DOCTMS <> (StrZero(8,Len(DT6->DT6_DOCTMS)))
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³Posicionando tabelas³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									//Faco um while no DTC no registro D180
									DTC->(DbSeek (xFilial ("DTC")+DT6->DT6_FILDOC+DT6->DT6_DOC+DT6->DT6_SERIE))
									//Somente para posicionar o DTQ
									DUD->(DbSeek (xFilial ("DUD")+DT6->DT6_FILDOC+DT6->DT6_DOC+DT6->DT6_SERIE+DT6->DT6_FILORI))
									//Posiciono na primeira viagem e utilizo no registro D020
									If DTQ->(DbSeek (xFilial ("DTQ")+DUD->DUD_FILORI+DUD->DUD_VIAGEM))
										//Somente para posicionar o DA3
										If DTR->(DbSeek (xFilial ("DTR")+DTQ->DTQ_FILORI+DTQ->DTQ_VIAGEM))
											//Utilizo informacoes nos registro D030, D050, D180
											lAchouDA3 := DA3->(DbSeek (xFilial ("DA3")+Iif (Empty (DTR->DTR_CODRB1), DTR->DTR_CODVEI, DTR->DTR_CODRB1)))
										EndIf
									EndIf
									//Utilizo no registro D050
									DT8->(DbSeek (xFilial ("DT8")+DT6->DT6_FILDOC+DT6->DT6_DOC+DT6->DT6_SERIE))
								Else	// CTRC COMPLEMENTAR
									//Faco um while no DTC no registro D180
									DTC->(DbSeek (xFilial ("DTC")+DT6->DT6_FILDCO+DT6->DT6_DOCDCO+DT6->DT6_SERDCO))
									//Somente para posicionar o DTQ
									DUD->(DbSeek (xFilial ("DUD")+DT6->DT6_FILDCO+DT6->DT6_DOCDCO+DT6->DT6_SERDCO+DT6->DT6_FILORI))
									//Posiciono na primeira viagem e utilizo no registro D020
									If DTQ->(DbSeek (xFilial ("DTQ")+DUD->DUD_FILORI+DUD->DUD_VIAGEM))
										//Somente para posicionar o DA3
										If DTR->(DbSeek (xFilial ("DTR")+DTQ->DTQ_FILORI+DTQ->DTQ_VIAGEM))
											//Utilizo informacoes nos registro D030, D050, D180
											lAchouDA3 := DA3->(DbSeek (xFilial ("DA3")+Iif (Empty (DTR->DTR_CODRB1), DTR->DTR_CODVEI, DTR->DTR_CODRB1)))
										EndIf
									EndIf
									//Utilizo no registro D050
									DT8->(DbSeek (xFilial ("DT8")+DT6->DT6_FILDCO+DT6->DT6_DOCDCO+DT6->DT6_SERDCO))					
								EndIf

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//|                     ENTRADA                         |
							//³                                                     ³
							//³Utilizo o aviso de recebimento do compras            ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							ElseIf (cEntSai=="1")
								DB2->(DbSeek (xFilial ("DB2")+aCmpAntSFT[1]+aCmpAntSFT[2]))
								DB1->(DbSeek (xFilial ("DB1")+DB2->DB2_NRAVRC))
								DB3->(DbSeek (xFilial ("DB3")+DB2->DB2_NRAVRC+DB2->DB2_ITEM))
								lAchouDA3 := DA3->(DbSeek (xFilial ("DA3")+DB1->DB1_IDVEI))
							EndIf

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³REGISTRO D020:                                 ³
							//³07 - NOTA FISCAL SERVICO DE TRANSPORTE         ³
							//³08 - CONHECIMENTO DE TRANSPORTE RODOVIARIO     ³
							//³09 - CONHECIMENTO DE TRANSPORTE AQUAVIARIO     ³
							//³10 - CONHECIMENTO DE TRANSPORTE AEREO          ³
							//³11 - CONHECIMENTO DE TRANSPORTE FERROVIARIO    ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							RegD020 (cAlias, cEntSai, aPartDoc, aTotaliza, nRelacDoc, cEspecie, aCmpAntSFT, cChave, cCmpFrete, cSituaDoc, cClasFis,cCodObs)

							If cEntSai=="2" // Somente o prestador deve informar estes registros
								If (cEspecie$"07")
									If lCOTD030
										ExecBlock("COTD030",.F.,.F.,{cAlias, nRelacDoc, aPartDoc})
									Else
										//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
										//³REGISTRO - D030 COMPLEMENTO DA NOTA FISCAL (MODELO 07)³
										//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
										RegD030 (cAlias, nRelacDoc, cEntSai, cAlsSA, lAchouDA3, aPartDoc, aMVCERTVEI)
									EndIf
								ElseIf (cEspecie$"08")
									If lCOTD050
										ExecBlock("COTD050",.F.,.F.,{cAlias, nRelacDoc, aPartDoc, cSituaDoc})
									Else
										//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
										//³REGISTRO D050 - COMPLEMENTO DO CONHECIMENTO (MODELO 08)³
										//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
										RegD050 (cAlias, nRelacDoc, cEntSai, cAlsSA, lAchouDA3, aPartDoc, cSituaDoc, aMVCEINITS, aMVMUNIBGE, aMVCOMPFRT)
									EndIf
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³REGISTRO D180 - CARGA TRANSPORTADA (MODELO 08)     ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									RegD180 (cAlias, nRelacDoc, cEntSai, aCmpAntSFT)
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³REGISTRO D200 - Ponto de Entrada                   ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									If lCOTD200
										ExecBlock("COTD200",.F.,.F.,{cAlias, cAliasSFT, nRelacDoc, aPartDoc, cSituaDoc, cEntSai})
									Endif
								EndIf
							EndIf
						EndIf
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³GRAVACAO - REGISTRO D040 - NOTA FISCAL DE SERVICO DE TRANSPORTE (MODELO 07)³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If lBloqCD
							GrvRegTrb (cAlias, nRelacDoc, aRegD040)
						EndIf
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³GRAVACAO - REGISTRO E120:                                ³
						//³       - NOTA FISCAL DE SERVICO DE TRANSPORTE (MODELO 07)³
						//³       - CONHECIMENTO DE TRASNPORTE (MODELO 08)          ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If lBlocoE
							GrvRegTrb (cAlias, nRelacDoc, aRegE120)
						Endif
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³SOMENTE MODELOS:                               ³
					//³01 - NOTA FISCAL NORMAL                        ³
					//³03 - NOTA FISCAL DE SERVICO                    ³
					//³04 - NOTA FISCAL PRODUTOR                      ³
					//³06 - NOTA FISCAL/CONTA DE ENERGIA ELETRICA     ³
					//³07 - NOTA FISCAL SERVICO DE TRANSPORTE         ³
					//³08 - CONHECIMENTO DE TRANSPORTE RODOVIARIO     ³
					//³09 - CONHECIMENTO DE TRANSPORTE AQUAVIARIO     ³
					//³10 - CONHECIMENTO DE TRANSPORTE AEREO          ³
					//³11 - CONHECIMENTO DE TRANSPORTE FERROVIARIO    ³
					//³13 - BILHETES DE PASSAGEM RODOVIARIO           ³
					//³15 - PASSAGEM E NOTA DE BAGAGEM                ³
					//³21 - NOTA FISCAL DE SERVICO DE COMUNICACAO     ³
					//³22 - NOTA FISCAL DE SERVICO DE TELECOMUNICACAO ³
					//³55 - NOTA FISCAL ELETRONICA                    ³
					//³57 - CONHECIMENTO DE TRANSPORTE  ELETRONICO    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If (cEspecie$"01#03#04#06#07#08#09#10#11#13#15#55#57" .And. !cSituaDoc$"02#03#04") .Or.; // Nao deve gravar p/ NF cancelada
						cEspecie$"21#22"
						If lReg0150
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³REGISTRO 0150 - TABELA DE CADASTRO DE PARTICIPANTES³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							Reg0150 (aPartDoc)
						EndIf
					EndIf
					n0200 ++
				EndDo	//ENDDO da NF

				If MV_PAR05 == 1 .And. nY > 0
					(cAliasTrb)->(Dbskip())
				EndIf
				nY ++

				#IFDEF TOP
					If (TcSrvType ()<>"AS/400")
						DbSelectArea (cAliasSFT)
						(cAliasSFT)->(DbCloseArea ())
					Else
				#ENDIF
						RetIndex("SFT")
						FErase(cIndex+OrdBagExt ())
				#IFDEF TOP
					EndIf
				#ENDIF

				cAliasSFT := "SFT"

			EndDo
			nY ++
		EndDo

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³REGISTRO B490 - OBRIGAÇÕES DO ISS A RECOLHER                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If len(aPartDoc) > 0 .and. aPartDoc[08] <> "EX"
			RegB490(cAliasSFT, cEntSai, @aRegB490, cSituaDoc, aPartDoc, lIssRet, aWizard)
		Endif

		If lRegTer
			//-- Processa Titulos RPA - Pagamento de Terceiros com recolhimento ISS.
			RegTerc(@aWizard, @aRegB410, @aRegB420, @aRegB430, @aRegB440, @aRegB450, @aRegB470, cAlias, cAliasTrb, nRelacDoc)
			//-- Query FINANCEIRO - Encerra consulta titulos Recolhimento ISS por data de emissao (FINXIMP.PRW)
			IIF(!Empty(cAliasTrb),(cAliasTrb)->(DbCloseArea()),.T.)
		EndIf

		If lB350CLL .And. lB350
			B350CLL(@aWizard, @aRegB350, @aRegB420, @aRegB440, @aRegB470, @aRegB475, @aRegB480, cAlias, cAliasSFT, @aReg0450)
			If (Len(aRegB350)>0)
				GrvRegTrb (cAlias,, aRegB350)
			Endif
		Endif

		SM0->(DbSkip ())
	EndIf
Next (nForFilial)
RestArea (aAreaSM0)
cFilAnt := SM0->M0_CODFIL
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Somente para contribuintes TARE este registro deve ser enviado.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lContrTare
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³REGISTRO C005 - BENEFICIO FISCAL - CAMPOS ADICIONAIS³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RegC005(cAlias, nRelacDoc)
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Geracao do REGISTRO A350: DOCUMENTO - CUPOM FISCAL/ISSQN   ³
//³Geracao do REGISTRO A360: ITENS DO DOCUMENTO               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
GrRgA350Rg360(dDataDe,dDataAte,cFilDe,cFilAte,cAlias,@aRegA350,@aRegA360,aReg02Aux )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³GRAVACAO - REGISTRO H020 - TOTAIS DO  INVENTARIO³
//³GRAVACAO - REGISTRO H025 - INVENTARIO           |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
H020H025 (cAlias,aMVCEINITS,aMVMUNIBGE,dDataDe,dDataAte,aWizard,dDatainv)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³GRAVACAO - REGISTRO 0015 - DADOS DO CONTRIBUINTE SUBSTITUTO³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
GrvRegTrb (cAlias,, aReg0015)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³GRAVACAO - REGISTRO 0150 - TABELA DE CADASTRO DE PARTICIPANTE ³
//|GRAVACAO - REGISTRO 0175 - ENDERECO DO PARTICIPANTE           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
R150R175 (cAlias)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Gravacao do REGISTRO 0200 - TABELA DE IDENTIFICACAO DO ITEM                                  ³
//³Gravacao do REGISTRO 0210 - MERCADORIA COMPONENTE/RELACAO INSUMO/PRODUTO                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If n0200>=1 // não gerar o 0200 quando a query acima estiver vazia
	R200R210 (cAlias, lIcms)
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Gravacao do REGISTRO A320: DOCUMENTOS - RESUMO DIARIO DE NOTA FISCAL DE SERVICOS (MODELO SIMPLIFICADO)³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
GrvRegTrb (cAlias,, aRegA320)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Gravacao do REGISTRO A350: DOCUMENTO - CUPOM FISCAL/ISSQN  ³
//³Gravacao do REGISTRO A350: ITENS DO DOCUMENTO              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RegA350(cAlias, aRegA350, aRegA360 )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³REGISTRO C570 - RESUMO DIARIO DAS NOTAS FISCAIS DE VENDA A CONSUMIDOR(MODELO 02)³
//³REGISTRO C575 - ITENS DO RESUMO DIARIO DOS DOCUMENTOS(MODELO 02)                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//GrRegDep (cAlias, aRegC570, aRegC575)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³REGISTRO C620 - RESUMO DIARIO DAS NOTAS FISCAIS DE VENDA A CONSUMIDOR(MODELO 2D)³
//³REGISTRO C625 - ITENS DO RESUMO DIARIO DOS DOCUMENTOS(MODELO 2D)                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//GrRegDep (cAlias, aRegC620, aRegC625)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Gravacao do REGISTRO C580 - RESUMO MENSAL DOS ITENS DAS NOTAS FISCAIS DE VENDA A CONSUMIDOR(MODELO 02)³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//GrvRegTrb (cAlias,, aRegC580)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Gravacao do REGISTRO C640 - RESUMO MENSAL DOS ITENS DAS NOTAS FISCAIS DE VENDA A CONSUMIDOR(MODELO 2D)³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//GrvRegTrb (cAlias,, aRegC640)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³GRAVACAO REGISTRO C770 - CONSOLIDACAO DE NOTAS FISCAIS/CONTA DE ENERGIA ELETRICA (MODELO 06)³
//³GRAVACAO REGISTRO C775 - ITENS DO DOCUMENTO CONSOLIDADO (MODELO 06)                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lBloqCD
	GrRegDep (cAlias, aRegC770, aRegC775)
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Gravacao do REGISTRO 0400 - TABELA DE NATUREZA DA OPERACAO/PRESTACAO³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
GrvRegTrb (cAlias,, aReg0400)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³GRAVACAO REGISTRO D470 - CONSOLIDACAO DE NOTA FISCAL DE SERVICO DE COMUNICACAO (MODELO 21) E NOTA FISCAL DE SERVICO DE TELECOMUNICACAO (MODELO 22)     ³
//³GRAVACAO REGISTRO D475 - ITENS CONSOLIDADO DE NOTA FISCAL DE SERVICO DE COMUNICACAO (MODELO 21) E NOTA FISCAL DE SERVICO DE TELECOMUNICACAO (MODELO 22)³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aSort(aRegD475,,,{|aX, aY| Str( aX[1],20 )+PadL( aX[3],10 )<Str( aY[1],20 )+PadL( aY[3],10 )})	//Ordenando o array filho pelo indice+item
If lBloqCD
	GrRegDep (cAlias, aRegD470, aRegD475)
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³GRAVACAO - REGISTRO E050 - REGISTRO MESTRE DE NOTA FISCAL DE VENDA A CONSUMIDOR (MODELO 02)³
//³GRAVACAO - REGISTRO E055 - REGISTRO ANALITICO DO DOCUMENTO (MODELO 02)                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lBlocoE
	GrRegDep (cAlias, aRegE050, aRegE055)
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Gravacao do REGISTRO B030 - DOCUMENTOS - LANCAMENTO DE NOTA FISCAL DE SERVICOS (MODELO SIMPLIFICADO)³
//³Gravacao do REGISTRO B035 - VALORES PARCIAIS DO LANCAMENTO                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
GrRegDepC(cAlias, aRegB030, aRegB035)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ B040 - LANCAMENTO - REDUCAO Z/ISS     ³
//³ B045 - VALORES PARCIAIS DO LANCAMENTO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
GrRegDepC (cAlias, aRegB040, aRegB045, , , , , , , .F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³E060 - LANCAMENTO - REDUCAO Z/ICMS   ³
//³E065 - VALORES PARCIAIS DO LANCAMENTO³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lBlocoE
	GrRegDepC (cAlias, aRegE060, aRegE065, , , , , , , .T.)
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³E080 - LANCAMENTO MAPA RESUMO - ECF/ICM  (MODELO 2D)³
//³E085 - VALORES PARCIAIS DO LANCAMENTO    (MODELO 2D)³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lBlocoE
	GrRegDepC (cAlias, aRegE080, aRegE085, , , , , , , .T.)
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³B050 - LANCAMENTO MAPA RESUMO - ECF/ISSQN(MODELO 2D)³
//³B055 - VALORES PARCIAIS DO LANCAMENTO    (MODELO 2D)³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lBloqCD
	GrRegDepC (cAlias, aRegB050, aRegB055)
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³GRAVACAO - REGISTRO E300 - PERIODO DA APURACAO DO ICMS³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (Len(aRegE310) > 0 .Or. ((Len(aRegE080) > 0 .Or. Len(aRegE085) > 0) .And. Len(aRegE310) == 0) .Or. Len(aRegE060) > 0) .and. lBlocoE
	lE300 := RegE300 (cAlias, dDataDe, dDataAte)
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³GRAVACAO - REGISTRO E310 - CONSOLIDACAO DOS VALORES DE ICMS POR CFOP       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lBlocoE
	GrvRegTrb (cAlias,, aRegE310)
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³GRAVACAO - REGISTRO E320 - TOTALIZACAO DOS VALORES POR UNIDADE DE FEDERACAO³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lBlocoE
	GrvRegTrb (cAlias,, aRegE320)
EndIf	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³GRAVACAO - REGISTRO E330 - TOTALIZACAO DOS VALORES DE ENTRADAS E SAIDAS³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lBlocoE
	RegE330 (cAlias, aRegE310)
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³GRAVACAO - REGISTRO E360 - APURACAO DO ICMS³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lBlocoE
	If RegE360(cAlias,dDataAte,cNrLivro,nAcImport,nAcRetInter,nDbCompIcm,nCrCompIcm,@aLog,nAcRetEsta,nRelacDoc,cCodObs,@aReg0450,dDataDe) .And. !lE300
		RegE300(cAlias, dDataDe, dDataAte)
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³REGISTRO 0450 - TABELA DE INFORMACOES COMPLEMENTARES/OBSERVACOES³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
GrvRegTrb (cAlias, , aReg0450)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³GRAVACAO - REGISTRO E530 - APURACAO DO IPI ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lBlocoE
	If (Len (aRegE510)>0)
		RegE530 (cAlias, dDataAte, cNrLivro)
	EndIf
EndIf

If (Len (aRegB410)>0)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³GRAVACAO - REGISTRO B410 - TOTAL DOS VALORES DE AQUISICOES E PRESTACOES³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	GrvRegTrb (cAlias,, aRegB410)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³GRAVACAO - REGISTRO B420 - RELATORIO DOS VALORES POR ALIQUOTA³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	GrvRegTrb (cAlias,, aRegB420)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³GRAVACAO - REGISTRO B430 - RELATORIO DOS VALORES POR CFPS³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	GrvRegTrb (cAlias,, aRegB430)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³GRAVACAO - REGISTRO B440 - RELATORIOS DOS VALORES RETIDOS³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lCOTB440
		aRegB440 := ExecBlock("COTB440",.F.,.F.,@aRegB440)
	Endif
	GrvRegTrb (cAlias,, aRegB440)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³GRAVACAO - REGISTRO B450 - RELATORIO DOS VALORES POR MUNICIPIO³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	GrvRegTrb (cAlias,, aRegB450)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³GRAVACAO - REGISTRO B460 - DEDUCAO DO ISSQN³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	GrvRegTrb (cAlias,, {aRegB460})
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³GRAVACAO - REGISTRO B465 - Compensação do ISSQN³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len(aRegB460)>0 .And. aRegB465[1] == "B465"
		GrvRegTrb (cAlias,, {aRegB465})
	Endif
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³GRAVACAO - REGISTRO B400 - PERIODO DA APURACAO DO ISSQN ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (Len (aRegB470)>0)
	GrvRegTrb (cAlias,, {aRegB470})
	RegB400 (cAlias, dDataDe, dDataAte, aRegB410)
	GrvRegTrb (cAlias,, aRegB475)
	GrvRegTrb (cAlias,, aRegB480)
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³GRAVACAO - REGISTRO B490 - OBRIGAÇÕES DO ISS A RECOLHER ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (Len (aRegB490)>0)
	GrvRegTrb (cAlias,, aRegB490)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³GRAVACAO - REGISTRO E365 - OBRIGACOES A RECOLHER POR UNIDADE DA FEDERACAO³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lBlocoE
	GrvRegTrb (cAlias,, aRegE365)
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³GRAVACAO - REGISTRO E500 - PERIODO DA APURACAO DO IPI ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lBlocoE
	If (Len (aRegE510)>0)
		RegE500 (cAlias, dDataDe, dDataAte)	
	EndIf
EndIf	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³GRAVACAO - REGISTRO E510 - CONSOLIDACAO DOS VALROES DE IPI POR CFOP E CODIGO DE TRIBUTACAO DO IPI³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lBlocoE
	GrvRegTrb (cAlias,, aRegE510)
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Gravacao dos indicadores de movimento dos registros ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
GrvIndMov (cAlias)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Organiza para Impressao Registros 0450 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
OrgSort450(cAlias)
//Gero meio-magnetico
OrgTxt (cAlias, cFileDest)

//Fecho TRB criado
GeraTrb (2, @aArq, @cAlias)	
//Geracao do arquivo de LOG(LOGCOTEPE.TXT)
GeraTxtLog (cDir, aLog)

DumpFile(2,,cFileDest)

Return (.T.)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Reg0000   ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³ABERTURA DO ARQUIVO DIGITAL E IDENTIFICACAO DO CONTRIBUINTE ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao do Registro 0000 e gravacao do mesmo              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³0(1 por arquivo)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³aWizard -> informacoes preenchidas no Wizard                ³±±
±±³          ³cAlias -> Alias do TRB que recebera as informacoes          ³±±
±±³          ³dDataDe -> Data incial do periodo de apuracao.              ³±±
±±³          ³dDataAte -> Data final do periodo de apuracao.              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Reg0000 (aWizard, cAlias, dDataDe, dDataAte)
Local	aReg := {}
Local	lRet := .T.
Local	nPos := 0

aAdd(aReg, {})
nPos	:=	Len (aReg)
aAdd (aReg[nPos], "0000")													//01 - REG
aAdd (aReg[nPos], "LFPD")													//02 - LFPD
aAdd (aReg[nPos], "003")													//03 - COD_VER
aAdd (aReg[nPos], "003")													//04 - COD_SRP
aAdd (aReg[nPos], SubStr (aWizard[2][1], 1, 2))								//05 - COD_FIN
aAdd (aReg[nPos], dDataDe)													//06 - DT_INI
aAdd (aReg[nPos], dDataAte)													//07 - DT_FIM
aAdd (aReg[nPos], "1")														//08 - IND_ED
aAdd (aReg[nPos], SubStr (aWizard[2][2], 1, 1))								//09 - IND_CENTR
aAdd (aReg[nPos], SM0->M0_NOMECOM)											//10 - NOME
aAdd (aReg[nPos], Iif (RetPessoa(SM0->M0_CGC) == "J", SM0->M0_CGC, ""))	//11 - CNPJ
aAdd (aReg[nPos], Iif (RetPessoa(SM0->M0_CGC) == "F", SM0->M0_CGC, ""))	//12 - CPF
aAdd (aReg[nPos], Iif(SM0->M0_TPINSC==1,SM0->M0_CGC,""))					//13 - NIT
aAdd (aReg[nPos], SM0->M0_ESTENT)											//14 - UF
aAdd (aReg[nPos], SM0->M0_INSC)												//15 - IE
aAdd (aReg[nPos], SM0->M0_CODMUN)											//16 - COD_MUN
aAdd (aReg[nPos], SM0->M0_INSCM)											//17 - IM
aAdd (aReg[nPos], SM0->M0_INS_SUF)											//18 - SUFRAMA

GrvRegTrb (cAlias,, aReg)
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Reg0005   ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³             DADOS COMPLEMENTARES DO CONTRIBUINTE           ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao do Registro 0005 e gravacao do mesmo              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³2(1 por arquivo)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³aWizard -> informacoes preenchidas no Wizard                ³±±
±±³          ³cAlias -> Alias do TRB que recebera as informacoes          ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Reg0005 (aWizard, cAlias)
Local	aReg := {}
Local	lRet := .T.
Local	nPos := 0

aAdd(aReg, {})
nPos	:=	Len (aReg)
aAdd (aReg[nPos], "0005")																					//01 - REG
aAdd (aReg[nPos], SM0->M0_NOME)																				//02 - FANTASIA
aAdd (aReg[nPos], SM0->M0_CEPENT)																			//03 - CEP
aAdd (aReg[nPos], Substr (SM0->M0_ENDENT, 1, At(",", SM0->M0_ENDENT)-1))									//04 - END
aAdd (aReg[nPos], Substr (SM0->M0_ENDENT, At(",", SM0->M0_ENDENT)+1, Len (AllTrim (SM0->M0_ENDENT))))		//05 - NUM
aAdd (aReg[nPos], SM0->M0_COMPENT)																			//06 - COMPL
aAdd (aReg[nPos], SM0->M0_BAIRENT)																			//07 - BAIRRO
aAdd (aReg[nPos], SM0->M0_CEPENT)																			//08 - CEP_CP
aAdd (aReg[nPos], SM0->M0_CAIXA)																			//09 - CP
aAdd (aReg[nPos], SM0->M0_TEL)																				//10 - FONE
aAdd (aReg[nPos], SM0->M0_FAX)																				//11 - FAX
aAdd (aReg[nPos], aWizard[2][3])																			//12 - EMAIL

GrvRegTrb (cAlias,, aReg)
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Reg0010   ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³                ESCRITURACAO CENTRALIZADA                   ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao do Registro 0010 e gravacao do mesmo              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³2(varios por arquivo) Relacionado com os estabelecimentos   ³±±
±±³          ³ consolidados.                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³aWizard -> informacoes preenchidas no Wizard                ³±±
±±³          ³cAlias -> Alias do TRB que recebera as informacoes          ³±±
±±³          ³cFilDe -> No caso de estabelecimento centralizador, esta    ³±±
±±³          ³ indicara a filial inicial dos estabelecimentos centrali-   ³±±
±±³          ³ zados, caso seja estabelecimento centralizado, esta indica-³±±
±±³          ³ ra a filial que sera a centralizadora, para isso a tanto a ³±±
±±³          ³ filial de quanto a filial ate devera apontar para a mesma  ³±±
±±³          ³ filial, pois so existe um estabelecimento centralizador.   ³±±
±±³          ³cFilAte -> Indica a filial ate nas mesmas condicoes do para-³±±
±±³          ³ acima(cFilDe)                                              ³±±
±±³          ³aEmpCorr -> Dados da empresa corrente                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Reg0010 (aWizard, cAlias, aEmpCorr)
Local	aReg		:= {}
Local	lRet		:= .T.
Local	nPos		:= 0
Local	aAreaSM0	:= SM0->(GetArea ())

If ("1"$aWizard[2][2]) .And.;								//Somente executo quando for centralizacao
	!(aEmpCorr[1]==cEmpAnt .And. aEmpCorr[2]==cFilAnt)		//Somente para empresas diferentes da centralizadora (empresa corrente).

	SM0->(DbSeek (cEmpAnt+cFilAnt, .T.))
	If ("1"$aWizard[2][2])			//Estabelecimento centralizador, portanto deve conter os dados de todos os estabelecimentos centralizados
		aAdd(aReg, {})
		nPos	:=	Len (aReg)
		aAdd (aReg[nPos], "0010")													//01 - REG
		aAdd (aReg[nPos], Iif (RetPessoa(SM0->M0_CGC) == "J", SM0->M0_CGC, ""))	//02 - CNPJ
		aAdd (aReg[nPos], Iif (RetPessoa(SM0->M0_CGC) == "F", SM0->M0_CGC, ""))	//03 - CPF
		aAdd (aReg[nPos], SM0->M0_ESTENT)											//04 - UF
		aAdd (aReg[nPos], SM0->M0_INSC)												//05 - IE
		aAdd (aReg[nPos], SM0->M0_CODMUN)											//06 - COD_MUN
		aAdd (aReg[nPos], SM0->M0_INSCM)											//07 - IM
	EndIf

	GrvRegTrb (cAlias,, aReg)
EndIf

RestArea (aAreaSM0)
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Reg0015   ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³          0015 - DADOS DO CONTRIBUINTE SUBSTITUTO           ³±±
±±³          ³   E365 - OBRIGACOES A RECOLHER POR UNIDADE DE FEDERACAO    ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao do Registro 0015.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb que sera efetuado no final do proces-  ³±±
±±³          ³ samento, pois depende de informacoes do movimento do periodo³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³2(varios por arquivo)                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAliasSFT -> Alias da tabela SFT posicionada                ³±±
±±³          ³aReg0015 -> Array com informacoes do contribuinte substituto³±±
±±³          ³ conforme parametro MV_SUBTRIB                              ³±±
±±³          ³cMVSUBTRIB -> Conteudo do parametro MV_SUBTRIB (idendifica- ³±±
±±³          ³ cao da insc. estadual do contribuinte em outro estado.     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Reg0015 (cAliasSFT, aReg0015, aRegE365, cMVSUBTRIB)
Local	lRet		:= .T.
Local	nPosI		:= 0
Local	nPosY		:= 0
Local	nX			:= 0

If ((cAliasSFT)->FT_ICMSRET>0)	//Se for substituto
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³REGISTRO 0015 - DADOS DO CONTRIBUINTE SUBSTITUTO³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If At ((cAliasSFT)->FT_ESTADO, cMVSUBTRIB)>0	//Se tiver inscricao em outro estado
		If (aScan (aReg0015, {|aX| aX[2]==(cAliasSFT)->FT_ESTADO})==0)
			aAdd(aReg0015, {})
			nPosY	:=	Len (aReg0015)
			aAdd (aReg0015[nPosY], "0015")								//01 - REG
			aAdd (aReg0015[nPosY], (cAliasSFT)->FT_ESTADO)				//02 - UF_ST
	
			nPosI	:=	At ((cAliasSFT)->FT_ESTADO, cMVSUBTRIB)
	
			aAdd (aReg0015[nPosY], SubStr (cMVSUBTRIB, nPosI, 2))		//03 - IE_ST
			aAdd (aReg0015[nPosY], "") 									//04 - DT_ALT
		EndIf
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³REGISTRO E365 - OBRIGACOES A RECOLHER POR UNIDADE DE FEDERACAO³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ((cAliasSFT)->FT_TIPOMOV == "S")
		If ((nPosY := aScan (aRegE365, {|aX| aX[3]==(cAliasSFT)->FT_ESTADO}))==0)
			aAdd(aRegE365, {})
			nPosY	:=	Len (aRegE365)
			aAdd (aRegE365[nPosY], "E365")						//01 - REG
			aAdd (aRegE365[nPosY], 0)							//02 - VL_OR_UF
			aAdd (aRegE365[nPosY], (cAliasSFT)->FT_ESTADO)		//03 - UF
		EndIf
		aRegE365[nPosY][2] += (cAliasSFT)->FT_ICMSRET			//02 - VL_OR_UF
	EndIf
EndIf
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Reg0020   ³ Autor ³Gustavo G. Rueda       ³ Data ³17.07.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³                  BENEFICIO FISCAL                          ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao do Registro 0020 e gravacao do mesmo              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb.                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³2(um por arquivo)                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAlias -> Alias do TRB que recebera as informacoes          ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Reg0020(cAlias)
Local	aReg := {}
Local	lRet := .T.
Local	nPos := 0

aAdd (aReg, {})
nPos := Len(aReg)
aAdd (aReg[nPos], "0020")					//01 - REG
aAdd (aReg[nPos], "DF001")					//02 - COD_BF_ICMS
aAdd (aReg[nPos], "")						//03 - COD_BF_ISSQN

GrvRegTrb (cAlias,, aReg)
Return(lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Reg0100   ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³                 DADOS DO CONTABILISTA                      ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao do Registro 0100 e gravacao do mesmo              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb.                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³2(um por arquivo)                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³aWizard -> informacoes preenchidas no Wizard                ³±±
±±³          ³cAlias -> Alias do TRB que recebera as informacoes          ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Reg0100 (aWizard, cAlias)
Local	aReg := {}
Local	lRet := .T.
Local	nPos := 0

aAdd (aReg, {})
nPos	:=	Len (aReg)
aAdd (aReg[nPos], "0100")					//01 - REG
aAdd (aReg[nPos], aWizard[3][1])			//02 - NOME
aAdd (aReg[nPos], aWizard[3][2])			//03 - CNPJ
aAdd (aReg[nPos], aWizard[3][3])			//04 - CPF
aAdd (aReg[nPos], aWizard[3][4])			//05 - CRC
aAdd (aReg[nPos], aWizard[3][5])			//06 - UF
aAdd (aReg[nPos], aWizard[3][6])			//07 - CEP
aAdd (aReg[nPos], aWizard[3][7])			//08 - END
aAdd (aReg[nPos], aWizard[3][8])			//09 - NUM
aAdd (aReg[nPos], aWizard[3][9])			//10 - COMPL
aAdd (aReg[nPos], aWizard[3][10])			//11 - BAIRRO
aAdd (aReg[nPos], aWizard[3][11])			//12 - CEP_CP
aAdd (aReg[nPos], aWizard[3][12])			//13 - CP
aAdd (aReg[nPos], aWizard[3][13])			//14 - FONE
aAdd (aReg[nPos], aWizard[3][14])			//15 - FAX
aAdd (aReg[nPos], aWizard[3][15])			//16 - EMAIL

GrvRegTrb (cAlias,, aReg)
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Reg0125   ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³                  DADOS DO TECNICO/EMPRESA                  ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao do Registro 0125 e gravacao do mesmo              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb.                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³2(um por arquivo)                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAlias -> Alias do TRB que recebera as informacoes          ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Reg0125 (aWizard, cAlias)
Local	aReg := {}
Local	lRet := .T.
Local	nPos := 0

aAdd (aReg, {})
nPos	:=	Len (aReg)
aAdd (aReg[nPos], "0125")				//01 - REG
aAdd (aReg[nPos], aWizard[4][1])		//02 - EMP_TEC
aAdd (aReg[nPos], aWizard[4][2])		//03 - CNPJ	
aAdd (aReg[nPos], aWizard[4][3])		//04 - CPF
aAdd (aReg[nPos], aWizard[4][4])		//05 - FONE
aAdd (aReg[nPos], aWizard[4][5])		//06 - FAX
aAdd (aReg[nPos], aWizard[4][6])		//07 - EMAIL

GrvRegTrb (cAlias,, aReg)
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Reg0150   ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³        0150 - TABELA DE CADASTRO DE PARTICIPANTES          ³±±
±±³          ³             0175 - ENDERECO DO PARTICIPANTE                ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao e gravacao dos Registro 150 e 175                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb.                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³0150 - 2(varios por arquivo) Relacionado com o Registro 0005³±±
±±³          ³0175 - 3(1:1) Relacionado com o Registro 0150               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³aPartDoc -> Array com todas as informacoes do Cliente/Forne-³±±
±±³          ³ cedor.                                                     ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Reg0150 (aPartDoc)
Local	lRet := .T.

If !PAR->(DbSeek (aPartDoc[01]))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³TRB PAR = Registro 0150 - Tabela de cadastro de participantes³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RecLock("PAR", .T.)
	PAR->PAR_REG		:=	"0150"
	PAR->PAR_CODPAR		:=	aPartDoc[01]	//01	-	COD_PART
	PAR->PAR_NOME		:=	aPartDoc[02]	//02	-	NOME
	PAR->PAR_CODPAI		:=	aPartDoc[03]	//03	-	COD_PAIS
	PAR->PAR_CNPJ		:=	aPartDoc[04]	//04	-	CNPJ
	PAR->PAR_CPF		:=	aPartDoc[05]	//05	-	CPF
	PAR->PAR_CEI		:=	aPartDoc[06]	//06	-	CEI
	PAR->PAR_NIT		:=	aPartDoc[07]	//07	-	NIT
	PAR->PAR_UF			:=	aPartDoc[08]	//08	-	UF
	PAR->PAR_IE			:=	aPartDoc[09]	//09	-	IE
	PAR->PAR_IEST		:=	aPartDoc[10]	//10	-	IE_ST
	PAR->PAR_CODMUN		:=	aPartDoc[11]	//11	-	COD_MUN
	PAR->PAR_IM			:=	aPartDoc[12]	//12	-	IM
	PAR->PAR_SUFRAM		:=	aPartDoc[13]	//13	-	Inscricao SUFRAMA
	MsUnLock()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³TRB END = Registro 0175 - Endereco do participante³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RecLock("EDP", .T.)
	EDP->EDP_REG		:=	"0175"
	EDP->EDP_CODPAR		:=	aPartDoc[01]
	EDP->EDP_CEP		:=	aPartDoc[14]	//14	-	CEP
	EDP->EDP_END		:=	aPartDoc[15]	//15	-	END
	EDP->EDP_NUM		:=	aPartDoc[16]	//16	-	NUM
	EDP->EDP_COMPL		:=	aPartDoc[17]	//17	-	COMPL
	EDP->EDP_BAIRRO		:=	aPartDoc[18]	//18	-	BAIRRO
	EDP->EDP_CEPCP		:=	aPartDoc[19]	//19	-	CEP_CP
	EDP->EDP_CP			:=	aPartDoc[20]	//20	-	CP
	EDP->EDP_FONE		:=	aPartDoc[21]	//21	-	TEL
	EDP->EDP_FAX		:=	aPartDoc[22]	//22	-	FAX
	MsUnLock()
EndIf
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³R150R175  ³ Autor ³Liber de Esteban       ³ Data ³28.08.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³             TABELA DE IDENTIFICACAO DO ITEM                ³±±
±±³          ³                                                            ³±±
±±³          ³- Gravacao dos Registros 0200 e 0210                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb.                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³2(varios por arquivo)                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAlias -> Alias do TRB que recebera as informacoes          ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function R150R175 (cAlias)
Local	lRet := .T.
Local	nPos := 1
Local	aReg := {}

PAR->(DbGoTop ())
Do While !PAR->(Eof ())
	aReg := {}
	aAdd( aReg, {PAR->PAR_REG, PAR->PAR_CODPAR, PAR->PAR_NOME, PAR->PAR_CODPAI, PAR->PAR_CNPJ,;
				 PAR->PAR_CPF, PAR->PAR_CEI, PAR->PAR_NIT, PAR->PAR_UF, PAR->PAR_IE, PAR->PAR_IEST,;
				 PAR->PAR_CODMUN, PAR->PAR_IM, PAR->PAR_SUFRAM})
	GrvRegTrb (cAlias,nPos,aReg)

	If (EDP->(DbSeek (PAR->PAR_CODPAR)))
		aReg := {}
		aAdd(aReg, {EDP->EDP_REG, EDP->EDP_CEP, EDP->EDP_END, EDP->EDP_NUM, EDP->EDP_COMPL,;
					EDP->EDP_BAIRRO, EDP->EDP_CEPCP, EDP->EDP_CP, EDP->EDP_FONE, EDP->EDP_FAX})
		GrvRegTrb (cAlias,nPos,aReg)
	EndIf
	
	PAR->(DbSkip ())
	nPos++
EndDo
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Reg0200  ³ Autor ³Liber de Esteban       ³ Data ³28.08.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³             TABELA DE IDENTIFICACAO DO ITEM                ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao do Registro 0200                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb.                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³2(varios por arquivo)                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAlias -> Alias do TRB que recebera as informacoes          ³±±
±±³          ³nRelac -> Flag de relacionamento com os sub-registros       ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Reg0200(cCodProd)
Local cDadosPrd := SuperGetMV("MV_ARQPROD",.F.,"SB1")

Default cCodProd := SB1->B1_COD

SB1->(dbSetOrder(1))
SB1->(dbSeek(xFilial("SB1")+cCodProd))

If !PRD->(DbSeek (cCodProd))
	RecLock ("PRD", .T.)
	PRD->PRD_CODITE := SB1->B1_COD
	PRD->PRD_DESC   := SB1->B1_DESC
	PRD->PRD_CODGEN := Iif(Empty(SB1->B1_CODISS), Left(SB1->B1_POSIPI, 2), "00")
	PRD->PRD_CODLST := Iif(Empty(SB1->B1_CODISS), "", StrZero(Val(strtran(SB1->B1_CODISS,'.','')),4))
	//Obtendo o codigo do ISS atraves do cadastro da tabela CDN.
	//Este codigo deverah estar conforme LC 116/03
	If CDN->(MsSeek(xFilial("CDN")+SB1->B1_CODISS))
		PRD->PRD_CODLST := StrZero(Val(strtran(CDN->CDN_CODLST,'.','')),4)
	ElseIf cDadosPrd == "SBZ"
		// Se existir registro no SBZ (Indicadores de Produtos) busca as informacoes desta tabela
		dbSelectArea("SBZ")
		SBZ->(dbSetOrder(1)) //BZ_FILIAL+BZ_PRODUTO
		If (SBZ->(dbSeek(xFilial("SBZ")+SB1->B1_COD))) .And. (SBZ->(FieldPos("BZ_CODISS")) > 0) .And. (Valtype(SBZ->(FieldGet(FieldPos("BZ_CODISS")))) == "C" .And. !Empty(SBZ->(FieldGet(FieldPos("BZ_CODISS")))))
			PRD->PRD_CODLST := Iif(!Empty(SBZ->(FieldGet(FieldPos("BZ_CODISS")))),StrZero(Val(strtran(SBZ->(FieldGet(FieldPos("BZ_CODISS"))),'.','')),4),"")
		Else
			PRD->PRD_CODLST := Iif(!Empty(SB1->B1_CODISS),StrZero(Val(strtran(SB1->B1_CODISS,'.','')),4),"")
		EndIf
	EndIf
	MsUnLock()
EndIf
Return .T.
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³R200R210  ³ Autor ³Liber de Esteban       ³ Data ³28.08.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³             TABELA DE IDENTIFICACAO DO ITEM                ³±±
±±³          ³                                                            ³±±
±±³          ³- Gravacao dos Registros 0200 e 0210                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb.                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³2(varios por arquivo)                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAlias -> Alias do TRB que recebera as informacoes          ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function R200R210 (cAlias, lIcms)
Local	nPos		:= 1
Local	aReg		:= {}
Local	aReg0210	:= {}

Default lIcms		:= .F.

PRD->(DbSetOrder(1))
PRD->(DbGoTop())
Do While !PRD->(Eof())
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³REGISTRO 0200 - TABELA DE IDENTIFICACAO DO ITEM³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aReg	:=	{}
	aAdd(aReg, {"0200", PRD->PRD_CODITE, PRD->PRD_DESC, PRD->PRD_CODGEN, PRD->PRD_CODLST})
	GrvRegTrb(cAlias,nPos,aReg)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³REGISTRO 0210 - MERCADORIA COMPONENTE/RELACAO INSUMO/PRODUTO³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aReg0210 := {}
	If SB1->(dbSeek(xFilial("SB1")+PRD->PRD_CODITE))
		ProcEstru(SB1->B1_COD, cAlias, nPos, SB1->B1_UM, lIcms,, aReg0210)
	EndIf
	ASort(aReg0210,,,{ |x, y| x[3] < y[3] })
	GrvRegTrb(cAlias, nPos, aReg0210, ,)
	PRD->(DbSkip())
	nPos++
EndDo
Return (.T.)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |ProcEstru ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³            PROCESSAMENTO DA ESTRUTURA PRODUTO              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Funcao recursiva para processamento da estrutura do produto.³±±
±±³          ³ Copiado da DCRE                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³lRet -> .T.                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cProd -> Codigo do produto a ser estruturado                ³±±
±±³          ³cAlias -> Alias do TRB para gravacao pela funcao GrvRegTrb  ³±±
±±³          ³nRelac -> codigo de relacionamento de registros             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ProcEstru(cProd, cAlias, nRelac, cUm, lIcms, lRegCompl, aReg0210)
	Local aArea		:= GetArea()

	Default lIcms	:= .F.

	DbSelectArea("SG1")
	aArea	:= GetArea()
	If (SG1->(DbSeek(xFilial("SG1")+cProd)))
		Do While !SG1->(Eof()) .And. (SG1->G1_FILIAL+SG1->G1_COD==xFilial("SG1")+cProd)
			ProcReg(cAlias, nRelac, cUm, lIcms, aReg0210)
			ProcEstru(SG1->G1_COMP, cAlias, nRelac, cUm, lIcms,, aReg0210)
			SG1->(DbSkip())
		Enddo
	Endif
	RestArea(aArea)
Return (.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |ProcReg   ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³              GRAVACAO DA ESTRUTURA PRODUTO                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Funcao para gravacao da estrutura do produto montada no TRB.³±±
±±³          ³ Copiado da DCRE                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³lRet -> .T.                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cAlias -> Alias do TRB para gravacao pela funcao GrvRegTrb  ³±±
±±³          ³nRelac -> codigo de relacionamento de registros             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ProcReg (cAlias, nRelac, cUm, lIcms, aReg0210)
	Local	lRet		:= .T.
	Local	aArea		:= GetArea()
	Local	cCodEstr	:= SG1->G1_COMP
	Local	nQtdEstr	:= SG1->G1_QUANT
	Local	nPerda		:= SG1->G1_PERDA
	Local	cDtIni		:= SG1->G1_INI
	Local	cDtFim		:= SG1->G1_FIM

	Default lIcms		:= .F.

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Valida o Componente da Estrutura                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (CheckComp(cCodEstr)) .And. lIcms
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Processa Cadastro de Produtos                                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("SB1")
		SB1->(DbSetOrder(1))
		If SB1->(DbSeek (xFilial("SB1")+cCodEstr))
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Grava Componentes do Produtos                                           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nPos := AScan(aReg0210,{ |x| x[3] == cCodEstr})
			If nPos == 0
				aAdd(aReg0210, {})
				nPos := Len(aReg0210)
				aAdd(aReg0210[nPos], "0210")										//01 - REG
				aAdd(aReg0210[nPos], cUm)											//02 - UNID_ITEM
				aAdd(aReg0210[nPos], cCodEstr)										//03 - COD_ITEM_COMP
				aAdd(aReg0210[nPos], Alltrim(StrTran(STR(nQtdEstr,,3),".",",")))	//04 - QTD_COMP
				aAdd(aReg0210[nPos], SB1->B1_UM)									//05 - UNID_COMP
				aAdd(aReg0210[nPos], nPerda)										//06 - PERDA_COMP
				aAdd(aReg0210[nPos], cDtIni)										//07 - DT_INI_COMP
				aAdd(aReg0210[nPos], cDtFim)										//08 - DT_FIM_COMP
			Else
				aReg0210[nPos][4] := Alltrim(StrTran(STR(Val(aReg0210[nPos][4])+nQtdEstr,,3),".",","))
				aReg0210[nPos][6] += nPerda
			Endif
		Endif
	Endif
	RestArea(aArea)
Return(lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |CheckComp ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³          VERIFICACAO DO COMPONENTE DA ESTRUTURA            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Verificacao do componente da estrutura, pois ocorre casos de³±±
±±³          ³ser componente e possuir outros componentes na estrutura tb.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³lRet -> .T.                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cComps -> Codigo do componente.                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CheckComp (cComp)
	Local aArea	:= GetArea()
	Local lRet	:= IIf(MV_PAR03<>3, .T., .F.)
	
	If MV_PAR03 <> 1 //Gera apenas os produtos comprados
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se o componente e produzido ou comprado                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("SG1")
		SG1->(DbSetOrder(1))
		If (SG1->(DbSeek(xFilial("SG1")+cComp)))
			lRet := IIf(MV_PAR03<>3, .F., .T.)
		Endif
	Endif
	
	RestArea(aArea)
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Reg0400   ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³        TABELA DE NATUREZA DA OPERACAO/PRESTACAO            ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao do Registro 0400                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com os CFOPs utilizados nos documentos.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³2(varios por arquivo)                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cCfop -> Cfop do documento fiscal                           ³±±
±±³          ³aReg0400 -> Array com o conteudo do registro para posteior  ³±±
±±³          ³ gravacao.                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Reg0400(cCodNat, cDscNat, aReg0400) 
Local nPos := aScan (aReg0400, {|aX| aX[2]==cCodNat})

If (nPos==0)
	aAdd (aReg0400, {})
	nPos	:=	Len (aReg0400)
	aAdd (aReg0400[nPos], "0400")							//REG
	aAdd (aReg0400[nPos], cCodNat)							//COD_NAT
	aAdd (aReg0400[nPos], cDscNat)							//DESCR_NAT
EndIf

Return .T.
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Reg0450   ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³        TABELA DE INFORMACAO COMPLEMENTAR/OBSERVACAO        ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao e gravacao do Registro 0450                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as observacoes do documeto referen-³±±
±±³          ³ ciado                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³2(varios por arquivo)                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAlias -> Alias do TRB que recebera as informacoes          ³±±
±±³          ³nRelac -> Flag de relacionamento com os sub-registro        ³±±
±±³          ³cObs -> Observacao do documento fiscal referenciado         ³±±
±±³          ³cChave -> Codigo de referencia entre o documento fiscal e   ³±±
±±³          ³ este registro.                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Reg0450 (cAlias, nRelac, cObs, cChave, cCodObs, aReg0450)

Local lRet := .T.
Local nPos := 0

DEFAULT aReg0450 := {}

cObs := Left(cObs, Len(cObs)-2)

If ((nPos := aScan(aReg0450, {|aX| aX[2]==cCodObs .And. aX[3]==cObs}))==0)
	aAdd(aReg0450, {})
	nPos := Len (aReg0450)
	aAdd(aReg0450[nPos], "0450")
	aAdd(aReg0450[nPos], cCodObs)
	aAdd(aReg0450[nPos], cObs)
EndIf

Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Reg0455   ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³                     NORMA REFERENCIADA                     ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao e gravacao do Registro 0455                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com o embasamento legal para tais      ³±±
±±³          ³ observacoes (NAO EH NECESSARIAMENTE OBRIGATORIO PARA CADA 0450)³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³3(1:N) Para cada 0450                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAlias -> Alias do TRB que recebera as informacoes          ³±±
±±³          ³nRelac -> Flag de relacionamento com os sub-registros       ³±±
±±³          ³aLeis -> Array contemdo o embasamento legal para cada       ³±±
±±³          ³ observacao do documento fiscal.                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Reg0455 (cAlias, nRelac, aLeis)
	Local	aReg0455	:=	{}
	Local	lRet		:=	.T.
	Local	nPos		:=	0
	Local	nX			:=	0

	For nX := 1 To Len (aLeis)
		aAdd(aReg0455, {})
		nPos	:=	Len (aReg0455)
		aAdd (aReg0455[nPos], "0455")
		aAdd (aReg0455[nPos], aLeis[nX])
	Next (nX)
	GrvRegTrb (cAlias, nRelac, aReg0455)
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Reg0460   ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³           DOCUMENTO DE ARRECADACAO REFERENCIADO            ³±±
±±³          ³                                                            ³±±
±±³Descri‡…o ³Geracao e gravacao do Registro 0460                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com todas as guias de recolhimento com ³±±
±±³          ³ a data de referencia no periodo apurado.                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³3(1:N) para cada Registro 450                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³aWizard -> Informacoes preenchidas no wizard da rotina      ³±±
±±³          ³cAlias -> Alias do TRB que recebera as informacoes          ³±±
±±³          ³dDataDe -> Periodo inicial de apuracao                      ³±±
±±³          ³dDataAte -> Periodo final de apuracao                       ³±±
±±³          ³nRelac -> Flag de relacionamento com os sub-registro        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Reg0460 (aWizard, cAlias, dDataDe, dDataAte, nRelac, aCmpAntSFT)
	Local aReg0460 := {}
	Local lRet := .T.
	Local nPos := 0
	Local aSf6 := {"SF6", ""}
	//
	FsQuery (aSf6, 1,	"F6_FILIAL='"+xFilial ("SF6")+"' AND F6_ANOREF="+StrZero (Year (dDataDe), 4)+" AND F6_MESREF="+StrZero (Month (dDataAte), 2)+" AND F6_TIPOIMP IN ('1', '3') AND F6_DOC='"+aCmpAntSFT[1]+"' AND F6_SERIE='"+aCmpAntSFT[2]+"'",;
						"F6_FILIAL='"+xFilial ("SF6")+"' .AND. StrZero (F6_ANOREF, 4)=='"+StrZero (Year (dDataDe), 4)+"' .AND. StrZero (F6_MESREF, 2)=='"+StrZero (Month (dDataAte), 2)+"' .AND. F6_TIPOIMP$'13' .AND. F6_DOC=='"+aCmpAntSFT[1]+"' .AND. F6_SERIE=='"+aCmpAntSFT[2]+"'", "F6_TIPOIMP+F6_CODREC")
	SF6->(DbGotop ())
	//
	Do While !SF6->(Eof ())
		//
		aAdd(aReg0460, {})
		nPos	:=	Len (aReg0460)
		aAdd (aReg0460[nPos], "0460")						//01 - REG
		aAdd (aReg0460[nPos], "23")							//02 - COD_DA
		aAdd (aReg0460[nPos], SF6->F6_NUMERO)				//03 - NUM_DA
		aAdd (aReg0460[nPos], SF6->F6_VALOR)				//04 - VL_DA
		aAdd (aReg0460[nPos], dDataDe)						//05 - DT_INI
		aAdd (aReg0460[nPos], dDataAte)						//06 - DT_FIN
		aAdd (aReg0460[nPos], SF6->F6_DTVENC)				//07 - DT_VCTO
		aAdd (aReg0460[nPos], SF6->F6_DTVENC)				//08 - DT_PGTO
		//
		SF6->(DbSkip ())
	EndDo	
	//
	FsQuery (aSf6, 2)
	//
	GrvRegTrb (cAlias, nRelac, aReg0460)
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Reg0465   ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³               DOCUMENTO FISCAL REFERENCIADO                ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao e gravacao do Registro 0465                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoes de todos os docu-   ³±±
±±³          ³ mentos fiscais processados.                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³3(1:N) Para cada Registro 0450                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAlias -> Alias do TRB que recebera as informacoes          ³±±
±±³          ³nRelac -> Flag de relacionamento com os sub-registros       ³±±
±±³          ³aRegC020 -> Informacoes sobre todos documentos fiscais pro- ³±±
±±³          ³ cessados no while da funcao principal.                     ³±±
±±³          ³cEntSai -> Flag de indicacao do documento fiscal, 1=Entrada/³±±
±±³          ³ 2=Saida.                                                   ³±±
±±³          ³aPartDoc -> Array com todas as informacoes do Cliente/Forne-³±±
±±³          ³ cedor.                                                     ³±±
±±³          ³aTotalISS -> Totalizador do ISS por NF                      ³±±
±±³          ³lSm0 -> Verifica se devo utilizar as informacoes do sigamat,³±±
±±³          ³ este tratamento se dah para notas fiscais de entrada com   ³±±
±±³          ³ formulario proprio igual SIM                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Reg0465 (cAlias, nRelac, aReg, cEntSai, aPartDoc, aTotalISS, lSm0, cReg, aTotaliza)
	Local	lRet		:= .T.
	Local	nPos		:= 0
	Local	aReg0465	:= {}
	Default	cReg		:= "C020"
	//
	aAdd(aReg0465, {})
	nPos	:=	Len (aReg0465)
	aAdd (aReg0465[nPos], "0465")							//01 - REG
	aAdd (aReg0465[nPos], STR(Val (cEntSai)-1,1))			//02 - IND_OPER
	aAdd (aReg0465[nPos], aReg[1][3])						//03 - IND_EMIT
	If lSm0
		If Len(SM0->M0_CGC)==14
			aAdd (aReg0465[nPos], SM0->M0_CGC)				//04 - CNPJ
			aAdd (aReg0465[nPos], "")						//05 - CPF
		Else
			aAdd (aReg0465[nPos], "")						//04 - CNPJ
			aAdd (aReg0465[nPos], SM0->M0_CGC)				//05 - CPF
		EndIf
		aAdd (aReg0465[nPos], SM0->M0_ESTENT)				//06 - UF
		aAdd (aReg0465[nPos], SM0->M0_INSC)					//07 - IE

		If(Len(SM0->M0_CODMUN)<=5)
			aAdd (aReg0465[nPos],RetCodEst(SM0->M0_ESTENT))//08 - COD_MUN
		Else
			aAdd (aReg0465[nPos],SM0->M0_CODMUN)			//08 - COD_MUN
		EndIf
		aAdd (aReg0465[nPos], SM0->M0_INSCM)				//09 - IM
	Else
		aAdd (aReg0465[nPos], aPartDoc[4])					//04 - CNPJ
		aAdd (aReg0465[nPos], aPartDoc[5])					//05 - CPF
		aAdd (aReg0465[nPos], aPartDoc[8])					//06 - UF
		aAdd (aReg0465[nPos], aPartDoc[9])					//07 - IE
		aAdd (aReg0465[nPos], aPartDoc[11])					//08 - COD_MUN
		aAdd (aReg0465[nPos], aPartDoc[12])					//09 - IM
	EndIf
	//Trata a chamada dos registros pais
	If cReg == "C020"
		aAdd (aReg0465[nPos], aReg[1][5])					//10 - COD_MOD
		aAdd (aReg0465[nPos], aReg[1][6])					//11 - COD_SIT
		aAdd (aReg0465[nPos], aReg[1][7])					//12 - SER
		aAdd (aReg0465[nPos], "")							//13 - SUB
		aAdd (aReg0465[nPos], aReg[1][8])					//14 - NUM_DOC
		aAdd (aReg0465[nPos], aReg[1][9])					//15 - DT_DOC
		aAdd (aReg0465[nPos], aReg[1][12])					//16 - VL_DOC
		aAdd (aReg0465[nPos], aTotalISS[20])				//17 - VL_ISS
		aAdd (aReg0465[nPos], aTotalISS[22])				//18 - VL_RT
		aAdd (aReg0465[nPos], aReg[1][21])					//19 - VL_ICMS
		aAdd (aReg0465[nPos], aReg[1][23])					//20 - VL_ST
		aAdd (aReg0465[nPos], aReg[1][24])					//21 - VL_IPI
	ElseIf cReg == "E120"
		aAdd (aReg0465[nPos], aReg[1][5])					//10 - COD_MOD
		aAdd (aReg0465[nPos], aReg[1][6])					//11 - COD_SIT
		aAdd (aReg0465[nPos], aReg[1][7])					//12 - SER
		aAdd (aReg0465[nPos], aReg[1][8])					//13 - SUB
		aAdd (aReg0465[nPos], aReg[1][9])					//14 - NUM_DOC
		aAdd (aReg0465[nPos], aReg[1][10])					//15 - DT_DOC
		aAdd (aReg0465[nPos], aTotaliza[01])				//16 - VL_DOC
		aAdd (aReg0465[nPos], aTotalISS[20])				//17 - VL_ISS
		aAdd (aReg0465[nPos], aTotalISS[22])				//18 - VL_RT
		aAdd (aReg0465[nPos], aTotaliza[03])				//19 - VL_ICMS
		aAdd (aReg0465[nPos], aTotaliza[05])				//20 - VL_ST
		aAdd (aReg0465[nPos], aTotaliza[06])				//21 - VL_IPI
	Endif
	GrvRegTrb (cAlias, nRelac, aReg0465)
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RegA020   ³ Autor ³ Liber de Esteban      ³ Data ³06/11/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³               NOTA FISCAL DE SERVICOS                      ³±±
±±³          ³                                                            ³±±
±±³          ³Geracao e gravacao do Registro A020                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoes de todos os docu-   ³±±
±±³          ³ mentos fiscais processados.                                ³±±
±±³          ³Somente sera gravado os documentos fiscais modelo 03        ³±±
±±³          ³ nos outros casos, sera utilizdo para gerar outros registros³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³A020 - 2(varios por arquivo)                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cEntSai -> Flag de indicacao do documento fiscal, 1=Entrada/³±±
±±³          ³ 2=Saida.                                                   ³±±
±±³          ³aPartDoc -> Array com todas as informacoes do Cliente/Forne-³±±
±±³          ³ cedor.                                                     ³±±
±±³          ³cEspecie -> Modelo do documento fiscal                      ³±±
±±³          ³cAlias -> Alias do TRB que recebera as informacoes          ³±±
±±³          ³nRelac -> Flag de relacionamento com os sub-registros       ³±±
±±³          ³aCmpAntSFT -> Informacoes de cabecalho do documento fiscal  ³±±
±±³          ³aTotaliza -> Totalizacao de valores da tabela SFT do docu-  ³±±
±±³          ³ mento fiscal do processamento atual no while               ³±±
±±³          ³aRegC020 -> Informacoes sobre todos documentos fiscais pro- ³±±
±±³          ³ cessados no while da funcao principal.                     ³±±
±±³          ³cChave -> Chave para gravacao das observacoes do documento  ³±±
±±³          ³ fiscal referenciado(Registro 0450).                        ³±±
±±³          ³cSituaDoc -> Situacao do documento fiscal conforme funcao   ³±±
±±³          ³ RetSitDoc                                                  ³±±
±±³          ³lAchouSE4 -> Flag de posicionamento da tabela SE4 para a NF ³±±
±±³          ³ em processamento.                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RegA020 (cEntSai, aPartDoc, cEspecie, cAlias, nRelac, aCmpAntSFT, aTotalISS, aRegA020, cChave, cSituaDoc, lAchouSE4, cCfps, cCodObs, cCmpAbtIss, cB1MepLes, lMvISSxMun, cCmpCdEst, cCmpCdMun, cCodNat)
	
Local nPos := 0
Local lRet := .T.

aRegA020	:=	{}
aAdd(aRegA020, {})
nPos	:=	Len (aRegA020)
aAdd (aRegA020[nPos], "A020")						//01 - REG
aAdd (aRegA020[nPos], STR(Val (cEntSai)-1,1)) 		//02 - IND_OPER

If (Empty (aCmpAntSFT[8])) .And. cEntSai=="1"
	aAdd (aRegA020[nPos], "1")						//03 - IND_EMIT
ElseIf (Empty (aCmpAntSFT[8])) .And. cEntSai=="2"
	aAdd (aRegA020[nPos], "0")						//03 - IND_EMIT
Else
	If ("S"$aCmpAntSFT[8])
		aAdd (aRegA020[nPos], "0")					//03 - IND_EMIT
	Else
		aAdd (aRegA020[nPos], "1")					//03 - IND_EMIT
	EndIf
EndIf

aAdd (aRegA020[nPos], IIf (cSituaDoc$"02#03", "", aPartDoc[1]))	//04 - COD_PART
aAdd (aRegA020[nPos], cEspecie)						//05 - COD_MOD
aAdd (aRegA020[nPos], cSituaDoc)					//06 - COD_SIT
aAdd (aRegA020[nPos], Iif(!Empty(aCmpAntSFT[22]),'',aCmpAntSFT[2]))				//07 - SER
aAdd (aRegA020[nPos], "")							//08 - SUB
aAdd (aRegA020[nPos], Iif(!Empty(aCmpAntSFT[22]),Alltrim(aCmpAntSFT[22]),aCmpAntSFT[1]))				//09 - NUM_DOC
aAdd (aRegA020[nPos], aCmpAntSFT[6])				//10 - DT_DOC
aAdd (aRegA020[nPos], cCfps)						//11 - CFPS
If lMvISSxMun .And. !Empty(&(cCmpCdEst)) .And. !Empty(&(cCmpCdMun)) .And. cB1MepLes == "2" .And. cEntSai=="1"
	aAdd (aRegA020[nPos], RetCodEst(&(cCmpCdEst)) + &(cCmpCdMun))					//12 - COD_MUN_SERV
Else
	aAdd (aRegA020[nPos], aPartDoc[11])				//12 - COD_MUN_SERV
EndIf
aAdd (aRegA020[nPos], cCodNat)						//13 - COD_NAT
aAdd (aRegA020[nPos], aTotalISS[1])					//14 - VL_DOC

//Para ser a vista, a condicao de pagamento deve ser tipo 1 e somente 00 no campo E4_COND.
If (lAchouSE4) .And. ("1" $ SE4->E4_TIPO) .And. "00" == AllTrim(SE4->E4_COND)
	aAdd (aRegA020[nPos], "0")						//15 - IND_PAGTO
Else
	aAdd (aRegA020[nPos], "1")						//15 - IND_PAGTO
EndIf

aAdd (aRegA020[nPos], Iif(&(cCmpAbtIss) > 0, &(cCmpAbtIss), 0))					//16 - VL_SUB_TOT
aAdd (aRegA020[nPos], aTotalISS[9])					//17 - VL_DESC
aAdd (aRegA020[nPos], aTotalISS[10])				//18 - VL_SERV
aAdd (aRegA020[nPos], 0 )							//19 - VL_MAT_PROP
aAdd (aRegA020[nPos], 0 )							//20 - VL_MAT_TERC
aAdd (aRegA020[nPos], 0 )							//21 - VL_DA
aAdd (aRegA020[nPos], aTotalISS[19])				//22 - VL_BC_ISSQN
aAdd (aRegA020[nPos], aTotalISS[20])				//23 - VL_ISSQN
aAdd (aRegA020[nPos], aTotalISS[21])				//24 - VL_BC_RT
aAdd (aRegA020[nPos], aTotalISS[22])				//25 - VL_ISSQN_RT
aAdd (aRegA020[nPos], cCodObs)						//26 - REF_INF_OBS

GrvRegTrb (cAlias, nRelac, aRegA020)

Return (lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RegA025   ³ Autor ³ Liber De Esteban      ³ Data ³06/11/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³                    TRIBUTOS FEDERAIS                       ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao e gravacao do Registro A025                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoes de IRRF/PIS/COFINS/ ³±±
±±³          ³ PREV documentos fiscais processados.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³3(1:1) Para cada Registro A020                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAliasSFT -> Alias da tabela SFT posicionada                ³±±
±±³          ³aRegA025  -> Informacoes sobre tributos federais para o     ³±±
±±³          ³ dosumento fiscal processado no while da funcao principal.  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
/*
Static Function RegA025 (cAliasSFT, aRegA025)
	Local lRet := .T.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³REGISTRO A025 - TRIBUTOS FEDERAIS³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aRegA025[2]	+=	(cAliasSFT)->FT_BASEIRR			//02 - VL_BC_IRRF
	aRegA025[3]	:=	(cAliasSFT)->FT_ALIQIRR			//03 - ALIQ_IRRF
	aRegA025[4]	+=	(cAliasSFT)->FT_VALIRR			//04 - VL_IRRF
	aRegA025[5]	:=	(cAliasSFT)->FT_ALIQPIS			//05 - ALIQ_PIS
	aRegA025[6]	+=	(cAliasSFT)->FT_VALPIS			//06 - VL_PIS
	aRegA025[7]	:=	(cAliasSFT)->FT_ALIQCOF			//07 - ALIQ_COFINS
	aRegA025[8]	+=	(cAliasSFT)->FT_VALCOF			//08 - VL_COFINS
	aRegA025[9]	+=	(cAliasSFT)->FT_BASEINS			//09 - VL_BC_PREV
	aRegA025[10]+=	(cAliasSFT)->FT_VALINS			//10 - VL_PREV
	
Return (lRet)
*/
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RegA035   ³ Autor ³Liber De Esteban       ³ Data ³06/11/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³                 ICMS (NOTAS DE SERVICO)                    ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao e gravacao do Registro A035                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoes de ISS/IRRF/PREV dos³±±
±±³          ³ documentos fiscais processados.                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³3(1:1) Para cada Registro A020                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAliasSFT -> Alias da tabela SFT posicionada                ³±±
±±³          ³aRegA035  -> Informacoes sobre ICMS para o documento fiscal ³±±
±±³          ³ processado no while da funcao principal.                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
/*
Static Function RegA035 (cAliasSFT, aRegA035)
	Local lRet := .T.
	//
	aRegA035[2]	+=	(cAliasSFT)->FT_VALCONT			//02 - VL_MERC
	aRegA035[3]	+=	(cAliasSFT)->FT_FRETE			//03 - VL_FRT
	aRegA035[4]	+=	(cAliasSFT)->FT_SEGURO			//04 - VL_SEG
	aRegA035[5]	+=	(cAliasSFT)->FT_DESPESA			//05 - VL_OUT_DA
	aRegA035[6]	+=	(cAliasSFT)->FT_BASEICM			//06 - VL_BC_ICMS
	aRegA035[7]	+=	(cAliasSFT)->FT_VALICM			//07 - VL_ICMS
	aRegA035[8]	+=	(cAliasSFT)->FT_BASERET			//08 - VL_BC_ST
	aRegA035[9]	+=	(cAliasSFT)->FT_ICMSRET			//09 - VL_ST
	aRegA035[10]+=	(cAliasSFT)->FT_VALIPI			//10 - VL_IPI
	
Return (lRet)
*/
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³A050A055  ³ Autor ³Liber de Esteban       ³ Data ³06/11/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³                   A050 - FATURA                            ³±±
±±³          ³              A055 - VENCIMENTO FATURA                      ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao e gravacao do Registro A050 e A055                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoes dos titulos e seus  ³±±
±±³          ³ vencimentos para cada documento fiscal processado.         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³A050 - 3(1:N) Para cada Registro A020                       ³±±
±±³          ³A055 - 4(1:N) Para cada Registro A050                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAlias -> Alias do TRB que recebera as informacoes          ³±±
±±³          ³nRelac -> Flag de relacionamento com os sub-registros       ³±±
±±³          ³cEntSai -> Flag de indicacao do documento fiscal, 1=Entrada/³±±
±±³          ³ 2=Saida.                                                   ³±±
±±³          ³aCmpAntSFT -> Informacoes de cabecalho do documento fiscal  ³±±
±±³          ³aRegA020 -> Cabeçalho de notas de ISS                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
/*
Static Function A050A055 (cAlias, nRelac, cEntSai, aCmpAntSFT, aRegA020)
	Local	lRet   		:=	.T.
	Local	aReg		:=	{}
	Local	aParc		:=	{}
	Local	nVlTit		:=	0
	Local	nX			:=	0
	Local	nPos		:=	0
	Local	nItem		:=	1
	//
	If aRegA020[1][15] != "0"	// Para pagamento a vista nao pode haver fatura.
		If ("1"$cEntSai)
			aParc	:=	ProcSE2 ()
		Else
			aParc	:=	ProcSE1 ()
		EndIf
		//
		aParc	:=	aSort (aParc,,,{|x, y| x[1]<y[1]})
		aEval (aParc, {|x| nVlTit += x[6]})
	EndIf
	//
	For nX := 1 To Len (aParc)
		//Somente a primeira vez para utilizar as informacoes do titulo.
		If nX==1
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³REGISTRO A050 - COMPLEMENTO DO DOCUMENTO - FATURA ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aReg	:=	{}
			aAdd(aReg, {})
			nPos	:=	Len (aReg)
			aAdd (aReg[nPos], "A050")							//01 - REG
			If (Empty (aCmpAntSFT[8])) .And. cEntSai=="1"
				aAdd (aReg[nPos], "1")							//02 - IND_EMIT
			ElseIf (Empty (aCmpAntSFT[8])) .And. cEntSai=="2"
				aAdd (aReg[nPos], "0")							//02 - IND_EMIT
			Else
				If ("S"$aCmpAntSFT[8])
					aAdd (aReg[nPos], "0") 						//02 - IND_EMIT
				Else
					aAdd (aReg[nPos], "1")		   				//02 - IND_EMIT
				EndIf
			EndIf
			//
			If (AllTrim (aParc[nX][1])$"BOL#DP#NF")			//03 - IND_TIT
				aAdd (aReg[nPos], "00")
			ElseIf (AllTrim (aParc[nX][1])$"CH")  				//03 - IND_TIT
				aAdd (aReg[nPos], "01")
			ElseIf (AllTrim (aParc[nX][1])$"NP")  				//03 - IND_TIT
				aAdd (aReg[nPos], "02")                	
			ElseIf (AllTrim (aParc[nX][1])$"RC")  				//03 - IND_TIT
				aAdd (aReg[nPos], "03")
			Else
				aAdd (aReg[nPos], "99")							//03 - IND_TIT
			EndIf
			//
			If "99"$aReg[nPos,3]
				If Empty( aParc[nX][2] )
					aAdd (aReg[nPos], "Titulo de Nota Fiscal")	//04 - TIT
				Else
					aAdd (aReg[nPos], aParc[nX][2])			//04 - TIT
				EndIf
			Else
				aAdd (aReg[nPos], "")							//04 - TIT
			EndIf
			//
			aAdd (aReg[nPos], aParc[nX][3])					//05 - NUM_TIT
			aAdd (aReg[nPos], Alltrim(STR(Len (aParc))))		//06 - QTD_PARC
			aAdd (aReg[nPos], nVlTit)		   					//07 - VL_TIT
			//
			GrvRegTrb (cAlias, nRelac, aReg, nItem)
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³REGISTRO A055 - VENCIMENTO DA FATURA³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aReg	:=	{}
		aAdd(aReg, {})
		nPos	:=	Len (aReg)
		aAdd (aReg[nPos], "A055")								//01 - REG
		aAdd (aReg[nPos], Alltrim(STR(nX)))					//02 - NUM_PARC
		aAdd (aReg[nPos], aParc[nX][5])						//03 - DT_VECTO
		aAdd (aReg[nPos], aParc[nX][6])						//04 - VL_PARC
		//
		GrvRegTrb (cAlias, nRelac, aReg, nItem)
	Next (nX)
Return (lRet)
*/
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RegA200   ³ Autor ³Liber De Esteban       ³ Data ³06/11/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³         ITENS DO DOCUMENTO (NF SERVICO)                    ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao e gravacao do Registro A200                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com a informacao de cada item do docu- ³±±
±±³          ³ mento fiscal processado no while da funcao principal.      ³±±
±±³          ³Somente sera gravado os documentos fiscais modelo 03        ³±±
±±³          ³ nos outros casos, sera utilizdo para gerar outros registros³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³3(1:N) Para cada Registro A020                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAlias -> Alias do TRB que recebera as informacoes          ³±±
±±³          ³nRelac -> Flag de relacionamento com os sub-registros       ³±±
±±³          ³nItem -> Contador do item para cada documento fiscal.       ³±±
±±³          ³aRegA200 -> Informacoes sobre os itens do documento fiscal  ³±±
±±³          ³ processado no while da funcao principal.                   ³±±
±±³          ³cAliasSFT -> Alias da tabela SFT posicionada                ³±±
±±³          ³cAlsSD -> Alias da tabela SD? posicionada                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RegA200 (cAlias, nRelac, nItem, aRegA200, cAliasSFT, aRegc300, nItemA200, cEspecie, cAlsSD, cCmpUm)
	Local lRet   := .T.
	Local nPos   := 0
//	Local cCmpUm := cAlsSD+"->"+SubStr (cAlsSD, 2, 2)+"_UM"		

	// Gereacao do item para Servico
	If cEspecie$"03"
		Reg0200()
	Endif

	aRegA200 := {}
	aAdd(aRegA200, {})
	nPos := Len(aRegA200)
	aAdd (aRegA200[nPos], "A200")											 		//01 - REG
	aAdd (aRegA200[nPos], AllTrim (STR (nItemA200)))							 	//02 - NUM_ITEM
	aAdd (aRegA200[nPos], (cAliasSFT)->FT_PRODUTO) 				//aRegC300[1][3])	//03 - COD_ITEM
	aAdd (aRegA200[nPos], {(cAliasSFT)->FT_PRCUNIT, "VLR3"})	//aRegC300[1][4])	//04 - VL_UNIT
	aAdd (aRegA200[nPos], {(cAliasSFT)->FT_QUANT  , "VLR3"})	//aRegC300[1][5])	//05 - QTD
	aAdd (aRegA200[nPos], &(cCmpUm))							//aRegC300[1][6])	//06 - UNID
	aAdd (aRegA200[nPos], (cAliasSFT)->FT_TOTAL)				//aRegC300[1][7])	//07 - VL_ITEM
	aAdd (aRegA200[nPos], (cAliasSFT)->FT_DESCONT)				//aRegC300[1][8])	//08 - VL_DESC_I
	aAdd (aRegA200[nPos], (cAliasSFT)->FT_CSTISS)									//09 - CTISS
	aAdd (aRegA200[nPos], (cAliasSFT)->FT_BASEICM)				//aRegC300[1][15])	//10 - VL_BC_ISSQN_I
	aAdd (aRegA200[nPos], (cAliasSFT)->FT_ALIQICM)				//aRegC300[1][16])	//11 - ALIQ_ISSQN
	aAdd (aRegA200[nPos], (cAliasSFT)->FT_VALICM)				//aRegC300[1][17])	//12 - VL_ISSQN_I
	//
	GrvRegTrb (cAlias, nRelac, aRegA200, nItem)
	//
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RegA310   ³ Autor ³Rodrigo Zatt           ³ Data ³16/11/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³         ITENS DO DOCUMENTO (NF SERVICO)                    ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao e gravacao do Registro A310                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com a informacao de cada item do docu- ³±±
±±³          ³ mento fiscal processado no while da funcao principal.      ³±±
±±³          ³Somente sera gravado os documentos fiscais modelo 03        ³±±
±±³          ³ nos outros casos, sera utilizdo para gerar outros registros³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³3(1:N) Para cada Registro A300                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAlias -> Alias do TRB que recebera as informacoes          ³±±
±±³          ³nRelac -> Flag de relacionamento com os sub-registros       ³±±
±±³          ³nItem -> Contador do item para cada documento fiscal.       ³±±
±±³          ³aRegA310 -> Informacoes sobre os itens do documento fiscal  ³±±
±±³          ³ processado no while da funcao principal.                   ³±±
±±³          ³cAliasSFT -> Alias da tabela SFT posicionada                ³±±
±±³          ³cAlsSD -> Alias da tabela SD? posicionada                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RegA310 (cAlias, nRelac, nItem, aRegA310, cAliasSFT, aRegc300, lGeraReg, cEspecie, cCmpUm)
	Local nPos := 0

	If cEspecie$"03"
		Reg0200()
	Endif

	aAdd(aRegA310, {})
	nPos := Len(aRegA310)
	aAdd (aRegA310[nPos], "A310")				//01 - REG
	aAdd (aRegA310[nPos], Str(nItem))			//02 - NUM_ITEM
	aAdd (aRegA310[nPos], (cAliasSFT)->FT_PRODUTO) 				//aRegC300[1][03])		//03 - COD_ITEM
	aAdd (aRegA310[nPos], {(cAliasSFT)->FT_PRCUNIT, "VLR3"})	//aRegC300[1][04])		//04 - VL_UNIT
	aAdd (aRegA310[nPos], {(cAliasSFT)->FT_QUANT  , "VLR3"})	//aRegC300[1][05])		//05 - QTD
	aAdd (aRegA310[nPos], &(cCmpUm))							//aRegC300[1][06])		//06 - UNID
	aAdd (aRegA310[nPos], (cAliasSFT)->FT_TOTAL)				//aRegC300[1][07])		//07 - VL_ITEM
	aAdd (aRegA310[nPos], (cAliasSFT)->FT_DESCONT)				//aRegC300[1][08])		//08 - VL_DESC_I
	aAdd (aRegA310[nPos], "00")					//09 - CTISS
	aAdd (aRegA310[nPos], (cAliasSFT)->FT_BASEICM)				//aRegC300[1][15])		//10 - VL_BC_ISSQN_I
	aAdd (aRegA310[nPos], (cAliasSFT)->FT_ALIQICM)				//aRegC300[1][16])		//11 - ALIQ_ISSQN
	aAdd (aRegA310[nPos], (cAliasSFT)->FT_VALICM)				//aRegC300[1][17])		//12 - VL_ISSQN_I
Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |B020B025  ³ Autor ³ Liber De Esteban      ³ Data ³07/11/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³B020 - REGISTRO MESTRE DE NOTA FISCAL DE SERVICO (MODELO 03)³±±
±±³          ³                                                            ³±±
±±³          ³       B025 - ANALITICO DO DOCUMENTO (MODELO 03)            ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao e gravacao do Registro B020 e B025                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoe contidas no array    ³±±
±±³          ³ aTotalISS/aPartDoc/aCmpAntSFT.                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³B020 - 2(varios por arquivo)                                ³±±
±±³          ³B025 - 3(1:N) Para cada B020                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cAlias -> Alias do TRB que recebera as informacoes          ³±±
±±³          |cEntSai -> Flag Entrada(1)/Saida(2).                        ³±±
±±³          |aCmpAntSFT -> Informacoes sobre o cabecalho dos documentos. ³±±
±±³          ³aPartDoc -> Array com informacoes sobre o participante do   ³±±
±±³          ³ documento fiscal, este array eh montado pela funcao princi-³±±
±±³          ³ pal.                                                       ³±±
±±³          |aTotalISS -> Totalizadores de valores para a tabela SFT.    ³±±
±±³          ³nRelac -> Flag de relacionamento.                           ³±±
±±³          ³cChave -> Codigo de referencia entre o documento fiscal e   ³±±
±±³          ³ este registro.                                             ³±±
±±³          ³cEspecie -> Modelo do documento fiscal                      ³±±
±±³          ³aRegB025 -> Array com informacoes analiticas do documento   ³±±
±±³          ³ fiscal processado na funcao principal para o documento.    ³±±
±±³          ³cSituaDoc -> Situacao do documento fiscal conforme funcao   ³±±
±±³          ³ RetSitDoc                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function B020B025 (cAlias, cEntSai, aCmpAntSFT, aPartDoc, aTotalISS, nRelac, cChave, cEspecie, aRegB025, cSituaDoc, cCfps, cCodObs, lGeraReg, cB1MepLes, lMvISSxMun, cCmpCdEst, cCmpCdMun)

Local	nPos	:=	0
Local	nCol	:=	0
Local	aReg	:=	{}

If !lGeraReg
	Return .T.
Endif

aAdd (aReg, {})
nPos	:=	Len (aReg)
aAdd (aReg[nPos], "B020")						//01 - REG
aAdd (aReg[nPos], STR(Val (cEntSai)-1,1))		//02 - IND_OPER

If (Empty (aCmpAntSFT[8])) .And. cEntSai=="1"
	aAdd (aReg[nPos], "1")						//03 - IND_EMIT
ElseIf (Empty (aCmpAntSFT[8])) .And. cEntSai=="2"
	aAdd (aReg[nPos], "0")						//03 - IND_EMIT
Else
	If ("S"$aCmpAntSFT[8])
		aAdd (aReg[nPos], "0") 					//03 - IND_EMIT
	Else
		aAdd (aReg[nPos], "1")					//03 - IND_EMIT
	EndIf
EndIf

aAdd (aReg[nPos], IIf (cSituaDoc$"02#03#04", "", aPartDoc[1]))	//04 - COD_PART
aAdd (aReg[nPos], cEspecie)  					//05 - COD_MOD
aAdd (aReg[nPos], cSituaDoc)					//06 - COD_SIT
aAdd (aReg[nPos], Iif(!Empty(aCmpAntSFT[22]),'',aCmpAntSFT[2]))  				//07 - SER
aAdd (aReg[nPos], "") 			 				//08 - SUB
aAdd (aReg[nPos], Iif(!Empty(aCmpAntSFT[22]),Alltrim(aCmpAntSFT[22]),aCmpAntSFT[1])) //09 - NUM_DOC
aAdd (aReg[nPos], aCmpAntSFT[6])				//10 - DT_DOC
aAdd (aReg[nPos], cCfps)						//11 - CFPS
aAdd (aReg[nPos], aCmpAntSFT[10]) 				//12 - NUM_LCTO
If lMvISSxMun .And. !Empty(&(cCmpCdEst)) .And. !Empty(&(cCmpCdMun)) .And. cB1MepLes == "2" .And. cEntSai=="1"
	aAdd (aReg[nPos], RetCodEst(&(cCmpCdEst)) + &(cCmpCdMun))					//13 - COD_MUN_SERV
Else
	aAdd (aReg[nPos], aPartDoc[11])					//13 - COD_MUN_SERV
EndIf
If cSituaDoc$"02#03#04"
	For nCol := 14 to 22
		aAdd (aReg[nPos], 0)					//Adiciona valores zerados para documento cancelado
	Next
Else
	aAdd (aReg[nPos], aTotalISS[1])				//14 - VL_CONT
	aAdd (aReg[nPos], 0)						//15 - VL_MAT_TERC
	aAdd (aReg[nPos], aTotalISS[24])			//16 - VL_SUB
	aAdd (aReg[nPos], aTotalISS[23])			//17 - VL_ISNT_ISSQN
	aAdd (aReg[nPos], 0)						//18 - VL_DED_BC 
	aAdd (aReg[nPos], aTotalISS[19])			//19 - VL_BC_ISSQN 
	aAdd (aReg[nPos], aTotalISS[21])			//20 - VL_BC_ISSQN_RT
	aAdd (aReg[nPos], aTotalISS[22])			//21 - VL_ISSQN_RT
	aAdd (aReg[nPos], aTotalISS[20])			//22 - VL_ISSQN
EndIf

aAdd (aReg[nPos], cCodObs)						//23 - REF_INF_OBS

GrvRegTrb (cAlias, nRelac, aReg)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³GRAVACAO REGISTRO B025 - ANALITICO DO DOCUMENTO (MODELO 3)³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
GrvRegTrb (cAlias, nRelac, aRegB025)

Return .T.

//-------------------------------------------------------------------
/*/{Protheus.doc}
@description geracao do registro
B030 - LANCAMENTO DE NOTA FISCAL DE SERVICOS (MODELO SIMPLIFICADO)
B035 - VALORES PARCIAIS DO LANCAMENTO
@author Flavio Luiz Vicco
@since 01/08/2017
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function B030B035(aRegB030,aRegB035,aCmpAntSFT,aTotalISS,aCmpAntSFT,cSituaDoc,cCfps,cMvNfSS,cCodObs)
Local nPos := 0

Default aRegB030 := {}

If ((nPos := aScan(aRegB030,{|aX| aX[03]==aCmpAntSFT[02] .And. aX[07]==aCmpAntSFT[06] .And. aX[08]==cCfps .And. aX[09]==aCmpAntSFT[10]}))==0)
	aAdd(aRegB030, {})
	nPos := Len(aRegB030)
	aAdd(aRegB030[nPos], "B030")								//01 - REG
	aAdd(aRegB030[nPos], Substr(cMvNfSS,At("=",cMvNfSS)-3,2))	//02 - COD_MOD
	aAdd(aRegB030[nPos], aCmpAntSFT[02])						//03 - SER
	aAdd(aRegB030[nPos], " ")									//04 - SUB
	aAdd(aRegB030[nPos], aCmpAntSFT[01])						//05 - NUM_DOC_INI
	aAdd(aRegB030[nPos], aCmpAntSFT[01])						//06 - NUM_DOC_FIN
	aAdd(aRegB030[nPos], aCmpAntSFT[06])						//07 - DT_DOC
	aAdd(aRegB030[nPos], cCfps)									//08 - CFPS
	aAdd(aRegB030[nPos], aCmpAntSFT[10])						//09 - NUM_LCTO
	aAdd(aRegB030[nPos], 0)										//10 - QTD_CANC
	aAdd(aRegB030[nPos], 0)										//11 - VL_CONT
	aAdd(aRegB030[nPos], 0)										//12 - VL_ISNT_ISSQN
	aAdd(aRegB030[nPos], 0)										//13 - VL_BC_ISSQN
	aAdd(aRegB030[nPos], 0)										//14 - VL_ISSQN
	aAdd(aRegB030[nPos], cCodObs)								//15 - COD_INF_OBS 
Else
	//-- Range de Numero de Documentos
	If (aCmpAntSFT[01] < aRegB030[nPos][05])
		aRegB030[nPos][05] := aCmpAntSFT[01]	//05 - NUM_DOC_INI
	EndIf
	//
	If (aCmpAntSFT[01] > aRegB030[nPos][06])
		aRegB030[nPos][06] := aCmpAntSFT[01]	//06 - NUM_DOC_FIN
	EndIf
EndIf

If (cSituaDoc $"02#03#04")	//02=Situacao de cancelada
	aRegB030[nPos][10] := aRegB030[nPos][10]+1	//10 - QTD_CANC
EndIf

aRegB030[nPos][11] += aTotalISS[10]				//11 - VL_CONT
aRegB030[nPos][12] += aTotalISS[23]				//12 - VL_ISNT_ISSQN
aRegB030[nPos][13] += aTotalISS[02]				//13 - VL_BC_ISSQN
aRegB030[nPos][14] += aTotalISS[03]				//14 - VL_ISSQN

//-- Registro B035
If ((nPos2 := aScan(aRegB035, {|aX| aX[01]==nPos .And. aX[06]==aCmpAntSFT[11]}))==0)
	aAdd(aRegB035, {})
	nPos2 := Len(aRegB035)
	aAdd(aRegB035[nPos2], nPos)					//00 - RELACIONAMENTO COM O CABECALHO B030
	aAdd(aRegB035[nPos2], "B035")				//01 - REG
	aAdd(aRegB035[nPos2], 0)					//02 - VL_CONT_P
 	aAdd(aRegB035[nPos2], 0)					//03 - VL_ISNT_ISSQN_P
	aAdd(aRegB035[nPos2], 0)					//04 - VL_BC_ISSQN_P
	aAdd(aRegB035[nPos2], aCmpAntSFT[11])		//05 - ALIQ_ISSQN
	aAdd(aRegB035[nPos2], 0)					//06 - VL_ISSQN_P
EndIf

aRegB035[nPos2][03] += aTotalISS[10]			//02 - VL_CONT_P
aRegB035[nPos2][04] += aTotalISS[23]			//03 - VL_ISNT_ISSQN_P
aRegB035[nPos2][05] += aTotalISS[02]			//04 - VL_BC_ISSQN_P
aRegB035[nPos2][07] += aTotalISS[03]			//06 - VL_ISSQN_P

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |RegB025   ³ Autor ³ Liber De Esteban	    ³ Data ³07/11/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³        VALORES PARCIAIS DO LANCAMENTO (MODELO 03)          ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao Registro B025                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoes da tabela SFT.      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³B025 - 3(1:N) Para cada B020                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cAliasSFT -> Alias da tabela SFT aberta no momento.         ³±±
±±³          ³aRegB025 -> Array com informacoes analiticas do documento   ³±±
±±³          ³ fiscal processado na funcao principal para o documento.    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RegB025 (cAliasSFT, aRegB025, cSituaDoc, lIssRet)
	Local nPos := 0
	Local lRet := .T.
	//
	If ((nPos := aScan (aRegB025, {|aX| aX[4]==(cAliasSFT)->FT_ALIQICM}))==0)
		aAdd(aRegB025, {})
		nPos	:=	Len (aRegB025)
		aAdd (aRegB025[nPos], "B025")						//01 - REG
		aAdd (aRegB025[nPos], 0)							//02 - VL_CONT_P
		aAdd (aRegB025[nPos], 0)							//03 - VL_BC_ISSQN_P
		aAdd (aRegB025[nPos], (cAliasSFT)->FT_ALIQICM)		//04 - ALIQ_ISSQN
		aAdd (aRegB025[nPos], 0)							//05 - VL_ISSQN_P
		aAdd (aRegB025[nPos], 0)							//06 - VL_ISNT_ISSQN_P
	EndIf
	If !(cSituaDoc$"02#03#04")
		aRegB025[nPos][2] += (cAliasSFT)->FT_VALCONT		//02 - VL_CONT_P
		aRegB025[nPos][3] += (cAliasSFT)->FT_BASEICM		//03 - VL_BC_ISSQN_P
		aRegB025[nPos][5] += (cAliasSFT)->FT_VALICM			//05 - VL_ISSQN_P
		aRegB025[nPos][6] += (cAliasSFT)->FT_ISENICM		//06 - VL_ISNT_ISSQN_P
	EndIf
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³B050B055  ³ Autor ³Marcio Lopes de Mello  ³ Data ³03.07.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³       LANCAMENTO MAPA RESUMO - ECF/ISSQN (MODELO 2D)       ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao e gravacao do Registro B050B055                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoe contidas no array    ³±±
±±³          ³ aRegE080 para o Modelo 2D.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³VARIOS POR ARQUIVO                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAlias -> Alias do TRB que recebera as informacoes          ³±±
±±³          ³nRelac -> Flag de relacionamento com os sub-registros       ³±±
±±³          ³aRegC020 -> Informacoes sobre todos documentos fiscais pro- ³±±
±±³          ³ cessados no while da funcao principal.                     ³±±
±±³          ³nItem -> Contador do item para cada documento fiscal.       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function B050B055 (	cAlias		, nRelac	, aRegC020	, aRegB050	, ;
							aRegB055	, nItem		, aTotalISS	, aTotaliza	, ;
							lISS		, aCmpAntSFT, cSituaDoc	, cAliasSFT	, ;
							cCmpVlAcr	, aRegC300)
	Local	lRet   		:=	.T.
	Local	nPos		:=	0
	Local	nPos2		:=	0
	Local 	nI			:= 	0
	Local 	lPosSFI		:= .F.
	Local   cNumero   	:= ""			// Numero da Reducao
	Local	cNumeroPDV  := ""           // Numero do PDV
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posiciona o registro no SFI³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SFI->( dbSetOrder(1) )             			// Data					// PDV
	lPosSFI := SFI->( dbSeek( xFilial("SFI") + DtoS(aCmpAntSFT[6]) + aCmpAntSFT[12] ) )

	cNumero    := AllTrim(SFI->FI_NUMERO)
	cNumeroPDV := AllTrim(SFI->FI_PDV)
	
	If ((nPos := aScan (aRegB050, {|aX| aX[2]=="0" .And. aX[3]==(cNumero + cNumeroPDV) .And. aX[4]== aCmpAntSFT[6]}))==0) .AND. lPosSFI
		aAdd(aRegB050, {})
		nPos	:=	Len (aRegB050)
		aAdd (aRegB050[nPos], "B050"						)		//01 - REG
		aAdd (aRegB050[nPos], "0"							)		//02 - IND_MR
		aAdd (aRegB050[nPos], cNumero + cNumeroPDV			)		//03 - NUM_MR-ECF
		aAdd (aRegB050[nPos], SFI->FI_DTMOVTO				)		//04 - DT_MR_ECF
		aAdd (aRegB050[nPos], (cAliasSFT)->FT_CFPS			)		//05 - CFPS
		aAdd (aRegB050[nPos], 0 							)		//06 - NUM_LCTO
		aAdd (aRegB050[nPos], SFI->FI_GTFINAL-SFI->FI_GTINI)		//07 - VL_BRT
		aAdd (aRegB050[nPos], 0								)		//08 - VL_CANC_ISSQN
		aAdd (aRegB050[nPos], 0								)	 	//09 - VL_CANC_ICMS
		aAdd (aRegB050[nPos], 0								)	 	//10 - VL_CANC
		aAdd (aRegB050[nPos], 0								)	 	//11 - VL_DESC_ISSQN
		aAdd (aRegB050[nPos], 0								)	 	//12 - VL_DESC_ICMS
		aAdd (aRegB050[nPos], 0								)	 	//13 - VL_DESC
		aAdd (aRegB050[nPos], 0								)	 	//14 - VL_ACMO_ISSQN
		aAdd (aRegB050[nPos], 0								)	 	//15 - VL_ACMO_ICMS
		aAdd (aRegB050[nPos], 0								)	 	//16 - VL_ACMO
		aAdd (aRegB050[nPos], 0								)		//17 - VL_BC_ISSQN
		aAdd (aRegB050[nPos], 0								)		//18 - VL_ISSQN
		aAdd (aRegB050[nPos], 0								)		//19 - VL_ISEN_ISSQN
		aAdd (aRegB050[nPos], 0								)		//20 - VL_NT_ISSQN
		aAdd (aRegB050[nPos], 0								)		//21 - VL_RT_ISSQN
		aAdd (aRegB050[nPos], 0								)		//22 - VL_CONT
		aAdd (aRegB050[nPos], 0								)		//22 - MR-ECF
	EndIf
	If cSituaDoc $ "02#03#04"
		If lIss
			aRegB050[nPos][08]	+= (cAliasSFT)->FT_TOTAL           //08 - VL_CANC_ISSQN
		Else
			aRegB050[nPos][09]	+= (cAliasSFT)->FT_TOTAL           //09 - VL_CANC_ICMS
		EndIf
		aRegB050[nPos][10]	+= (cAliasSFT)->FT_TOTAL               //10 - VL_CANC
	ElseIf lPosSFI
		If lIss
			aRegB050[nPos][11]	+= 	(cAliasSFT)->FT_DESCONT			 		//11 - VL_DESC_ISSQN
			aRegB050[nPos][14]	+= 	&(cCmpVlAcr)							//14 - VL_ACMO_ISSQN
			aRegB050[nPos][17]	+= 	(cAliasSFT)->FT_BASEICM					//17 - VL_BC_ISSQN
			aRegB050[nPos][18]	+= 	(cAliasSFT)->FT_VALICM					//18 - VL_ISSQN
			aRegB050[nPos][19]	+= 	(cAliasSFT)->FT_ISENICM					//19 - VL_ISEN_ISSQN
			aRegB050[nPos][20]	+=	(cAliasSFT)->FT_OUTRICM					//20 - VL_NT_ISSQN
		Else
			aRegB050[nPos][12]	+= (cAliasSFT)->FT_DESCONT			 		//12 - VL_DESC_ICMS
			aRegB050[nPos][15]	+= 	&(cCmpVlAcr)							//15 - VL_ACMO_ICMS
		EndIf

		aRegB050[nPos][13] += 	(cAliasSFT)->FT_DESCONT						//13 - VL_DESC
		aRegB050[nPos][16] :=	(aRegB050[nPos][14]	+ aRegB050[nPos][15])	//16 - VL_ACMO
		aRegB050[nPos][22] +=  (cAliasSFT)->FT_VALCONT						//22 - VL_CONT
	EndIF

	If ((nPos2 := aScan (aRegB055, {|aX| aX[01] == nPos .And. aX[11]==(cAliasSFT)->FT_ALIQICM}))==0)
		aAdd(aRegB055, {})
		nPos2	:=	Len (aRegB055)
		aAdd (aRegB055[nPos2], nPos)	 	   							//01 - RELACIONAMENTO COM O CABECALHO E050
		aAdd (aRegB055[nPos2], "B055")	 	   							//02 - REG					=> 01
		aAdd (aRegB055[nPos2], 0)										//03 - VL_CANC_ISSQN_P		=> 02
		aAdd (aRegB055[nPos2], 0)										//04 - VL_CANC_ICMS_P		=> 03
		aAdd (aRegB055[nPos2], 0)										//05 - VL_DESC_ISSQN_P		=> 04
		aAdd (aRegB055[nPos2], 0)										//06 - VL_DESC_ICMS_P		=> 05
		aAdd (aRegB055[nPos2], 0)										//07 - VL_ACMO_ISSQN_P		=> 06
		aAdd (aRegB055[nPos2], 0)										//08 - VL_ACMO_ICMS_P		=> 07
		aAdd (aRegB055[nPos2], 0)										//09 - VL_CONT_P			=> 08
		aAdd (aRegB055[nPos2], 0)										//10 - VL_BC_ISSQN_P		=> 09
		aAdd (aRegB055[nPos2], (cAliasSFT)->FT_ALIQICM)					//11 - ALIQ_ISSQN			=> 10
		aAdd (aRegB055[nPos2], 0)										//12 - VL_ISSQN_P			=> 11
		aAdd (aRegB055[nPos2], 0)										//13 - VL_ISEN_ISSQN_P		=> 12
		aAdd (aRegB055[nPos2], 0)										//14 - VL_NT_ISSQN_P		=> 13
		aAdd (aRegB055[nPos2], 0)										//15 - VL_RT_ISSQN_P		=> 14
	EndIf
	If ( cSituaDoc $ "02#03#04" )	//Documento cancelado
		If lIss
			aRegB055[nPos2][03]	+= (cAliasSFT)->FT_TOTAL				//03 - VL_CANC_ISSQN_P		=> 02
		Else
			aRegB055[nPos2][04]	+= (cAliasSFT)->FT_TOTAL				//04 - VL_CANC_ICMS_P		=> 03
		EndIf
	Else
		If lIss
			aRegB055[nPos2][05]	+= (cAliasSFT)->FT_DESCONT				//05 - VL_DESC_ISSQN_P		=> 04
			aRegB055[nPos2][07]	+= &(cCmpVlAcr)							//07 - VL_ACMO_ISSQN_P		=> 06
			aRegB055[nPos2][09]	+= (cAliasSFT)->FT_VALCONT				//09 - VL_CONT_P			=> 08
			aRegB055[nPos2][10]	+= (cAliasSFT)->FT_BASEICM				//10 - VL_BC_ISSQN_P		=> 09
			aRegB055[nPos2][12]	+= (cAliasSFT)->FT_VALICM				//12 - VL_ISSQN_P			=> 11
			aRegB055[nPos2][13]	+= (cAliasSFT)->FT_ISENICM				//13 - VL_ISEN_ISSQN_P		=> 12
			aRegB055[nPos2][14]	+= (cAliasSFT)->FT_OUTRICM				//14 - VL_NT_ISSQN_P		=> 13
		Else
			aRegB055[nPos2][06]	+= (cAliasSFT)->FT_DESCONT				//05 - VL_DESC_ICMS_P		=> 05
			aRegB055[nPos2][08]	+= &(cCmpVlAcr)							//08 - VL_ACMO_ICMS_P		=> 07
		EndIf
	EndIf
Return(lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |RegB400   ³ Autor ³Liber De Esteban       ³ Data ³08/11/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³               PERIODO DE APURACAO DO ISSQN                 ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao e gravacao do Registro B400                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb.                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³2(um por periodo)                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cAlias -> Alias do TRB que devera conter as informacoes do  ³±±
±±³          ³ meio-magnetico.                                            ³±±
±±³          ³dDataDe -> Data incial do periodo de apuracao.              ³±±
±±³          ³dDataAte -> Data final do periodo de apuracao.              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RegB400 (cAlias, dDataDe, dDataAte, aRegB410)
	Local aReg := {}
	Local lRet := .T.
	Local nPos := 0
	//
	//Indicador de conteudo:
	// 0 - Livro com dados informados;
	// 1 - Livro sem dados informados
	//
	aAdd (aReg, {})
	nPos := Len(aReg)
	aAdd (aReg[nPos], "B400")								//01 - REG
	aAdd (aReg[nPos], dDataDe)								//02 - DT_INI
	aAdd (aReg[nPos], dDataAte)								//03 - DT_FIN
	aAdd (aReg[nPos], IIf(Len(aRegB410)>0,"0","1"))		//04 - IND_DAD
	//
	GrvRegTrb (cAlias,, aReg)
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |RegB410   ³ Autor ³Liber De esteban       ³ Data ³08/11/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³     B410 - TOTALIZACAO DE AQUISICOES E PRESTACOES          ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao do Registros B410                                 |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoe contidas no array    ³±±
±±³          ³ aCmpAntSFT e na tabela SFT.                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³B410 - 3(varios por periodo)                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cAliasSFT -> Alias da tabela SFT aberta no momento.         ³±±
±±³          ³ funcao a ser retornado para gravacao pela funcao principal.³±±
±±³          |cEntSai -> Flag Entrada(1)/Saida(2).                        ³±±
±±³          |aRegB410 -> Array contendo as informacoes processadas pela  ³±±
±±³          ³ funcao a ser retornado para gravacao pela funcao principal.³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RegB410 (cAliasSFT, cEntSai, aRegB410, aPartDoc, lIssRet, lGeraReg)
	Local	nPos	:=	0
	Local	lRet	:=	.T.
	Local	cIndTot	:=	""

	If !lGeraReg
		Return .t.
	Endif
	//
	//Indicador do tipo de totalização:
	// 0- Subtotal das aquisições internas;
	// 1- Subtotal das aquisições de outros municípios;
	// 2- Subtotal das aquisições do exterior;
	// 3- Total das aquisições do período;
	// 4- Subtotal das prestações internas;
	// 5- Subtotal das prestações para outros municípios;
	// 6- Subtotal das prestações para o exterior;
	// 7- Total das prestações do período
	//
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³REGISTRO B410 - TOTALIZACAO DE AQUISICOES E PRESTACOES    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cEntsai == "1"
		cIndSubT := "0"
		cIndTot  := "3"
		If aPartDoc[11] != SM0->M0_CODMUN
			cIndSubT :=	"1"
		ElseIf aPartDoc[08] == "EX"
			cIndSubT :=	"2"
		EndIf
	Else
		cIndSubT := "4"
		cIndTot  := "7"
		If aPartDoc[11] != SM0->M0_CODMUN .and. aPartDoc[08] <> "EX"
			cIndSubT := "5"
		ElseIf aPartDoc[08] == "EX"
			cIndSubT := "6"
		EndIf
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Totalizando 0, 1, 2, 4, 5, 6 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ((nPos := aScan (aRegB410, {|aX| aX[2]==cIndSubT}))==0)
		aAdd(aRegB410, {})
		nPos	:=	Len (aRegB410)
		aAdd (aRegB410[nPos], "B410")					//01 - REG
		aAdd (aRegB410[nPos], cIndSubT)					//02 - IND_TOT
		aAdd (aRegB410[nPos], 0)						//03 - VL_CONT
		aAdd (aRegB410[nPos], 0)						//04 - VL_BC_ISSQN
		aAdd (aRegB410[nPos], 0)						//05 - VL_DED_BC
		aAdd (aRegB410[nPos], 0)						//06 - VL_RT
		aAdd (aRegB410[nPos], 0)						//07 - VL_ISNT_ISSQN
		aAdd (aRegB410[nPos], 0)						//08 - VL_ISSQN
	EndIf
	//
	aRegB410[nPos][3]	+= (cAliasSFT)->FT_VALCONT		//03 - VL_CONT
	aRegB410[nPos][4]	+= (cAliasSFT)->FT_BASEICM		//04 - VL_BC_ISSQN
	If lIssRet
		aRegB410[nPos][6]	+= (cAliasSFT)->FT_VALICM	//06 - VL_RT
	EndIf
	aRegB410[nPos][7]	+= (cAliasSFT)->FT_ISENICM		//07 - VL_ISNT_ISSQN
	aRegB410[nPos][8]	+= (cAliasSFT)->FT_VALICM 		//08 - VL_ISSQN
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Totalizando 3, 7³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ((nPos := aScan (aRegB410, {|aX| aX[2]==cIndTot}))==0)
		aAdd(aRegB410, {})
		nPos	:=	Len (aRegB410)
		aAdd (aRegB410[nPos], "B410")					//01 - REG
		aAdd (aRegB410[nPos], cIndTot)					//02 - IND_TOT
		aAdd (aRegB410[nPos], 0)						//03 - VL_CONT
		aAdd (aRegB410[nPos], 0)						//04 - VL_BC_ISSQN
		aAdd (aRegB410[nPos], 0)						//05 - VL_DED_BC
		aAdd (aRegB410[nPos], 0)						//06 - VL_RT
		aAdd (aRegB410[nPos], 0)						//07 - VL_ISNT_ISSQN
		aAdd (aRegB410[nPos], 0)						//08 - VL_ISSQN
	EndIf
	//
	aRegB410[nPos][3]	+= (cAliasSFT)->FT_VALCONT		//03 - VL_CONT
	aRegB410[nPos][4]	+= (cAliasSFT)->FT_BASEICM		//04 - VL_BC_ISSQN
	If lIssRet
		aRegB410[nPos][6]	+= (cAliasSFT)->FT_VALICM	//06 - VL_RT
	EndIf
	aRegB410[nPos][7]	+= (cAliasSFT)->FT_ISENICM		//07 - VL_ISNT_ISSQN
	aRegB410[nPos][8]	+= (cAliasSFT)->FT_VALICM		//08 - VL_ISSQN
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |RegB420   ³ Autor ³Liber De esteban       ³ Data ³08/11/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³     B420 - TOTALIZACAO POR ALIQUOTA                        ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao do Registro B420                                  |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoe contidas no array    ³±±
±±³          ³ aCmpAntSFT e na tabela SFT.                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³B420 - 3(varios por periodo)                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cAliasSFT -> Alias da tabela SFT aberta no momento.         ³±±
±±³          ³ funcao a ser retornado para gravacao pela funcao principal.³±±
±±³          |aRegB420 -> Array contendo as informacoes processadas pela  ³±±
±±³          ³ funcao a ser retornado para gravacao pela funcao principal.³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RegB420 (cAliasSFT, aRegB420, lIssRet)
	Local	nPos	:=	0
	Local	lRet	:=	.T.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³REGISTRO B420 - TOTALIZACAO POR ALIQUOTA    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ((nPos := aScan (aRegB420, {|aX| aX[4]==(cAliasSFT)->FT_ALIQICM}))==0)
		aAdd(aRegB420, {})
		nPos	:=	Len (aRegB420)
		aAdd (aRegB420[nPos], "B420")	 	   			//01 - REG
		aAdd (aRegB420[nPos], 0)						//02 - VL_CONT
		aAdd (aRegB420[nPos], 0)						//03 - VL_BC_ISSQN
		aAdd (aRegB420[nPos], (cAliasSFT)->FT_ALIQICM)	//04 - ALIQ_ISSQN
		aAdd (aRegB420[nPos], 0)						//05 - VL_BC_ISSQN_RT
		aAdd (aRegB420[nPos], 0)						//06 - VL_RT
		aAdd (aRegB420[nPos], 0)						//07 - VL_ISNT_ISSQN
		aAdd (aRegB420[nPos], 0)						//08 - VL_ISSQN
	EndIf
	//
	aRegB420[nPos][2]	+= (cAliasSFT)->FT_VALCONT		//02 - VL_CONT
	aRegB420[nPos][3]	+= (cAliasSFT)->FT_BASEICM		//03 - VL_BC_ISSQN
	If lIssRet
		aRegB420[nPos][5]	+= (cAliasSFT)->FT_BASEICM	//05 - VL_BC_ISSQN_RT
		aRegB420[nPos][6]	+= (cAliasSFT)->FT_VALICM	//06 - VL_RT
	EndIf
	aRegB420[nPos][7]	+= (cAliasSFT)->FT_ISENICM		//07 - VL_ISNT_ISSQN
	aRegB420[nPos][8]	+= (cAliasSFT)->FT_VALICM		//08 - VL_ISSQN
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |RegB430   ³ Autor ³Liber De esteban       ³ Data ³08/11/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³     B430 - TOTALIZACAO POR CFPS                            ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao do Registro B430                                  |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoe contidas no array    ³±±
±±³          ³ aCmpAntSFT e na tabela SFT.                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³B430 - 3(varios por periodo)                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cAliasSFT -> Alias da tabela SFT aberta no momento.         ³±±
±±³          ³ funcao a ser retornado para gravacao pela funcao principal.³±±
±±³          |aRegB430 -> Array contendo as informacoes processadas pela  ³±±
±±³          ³ funcao a ser retornado para gravacao pela funcao principal.³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RegB430 (cAliasSFT, aRegB430, lIssRet, cCfps)
	Local	nPos	:=	0
	Local	lRet	:=	.T.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³REGISTRO B430 - TOTALIZACAO POR CFPS        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ((nPos := aScan (aRegB430, {|aX| aX[2]==cCfps}))==0)
		aAdd(aRegB430, {})
		nPos	:=	Len (aRegB430)
		aAdd (aRegB430[nPos], "B430")	 	   			//01 - REG
		aAdd (aRegB430[nPos], cCfps)					//02 - CFPS
		aAdd (aRegB430[nPos], 0)						//03 - VL_CONT
		aAdd (aRegB430[nPos], 0)						//04 - VL_BC_ISSQN
		aAdd (aRegB430[nPos], 0)						//05 - VL_MAT_TERC
		aAdd (aRegB430[nPos], 0)						//06 - VL_SUB
		aAdd (aRegB430[nPos], 0)						//07 - VL_ISNT_ISSQN
		aAdd (aRegB430[nPos], 0)						//08 - VL_DED_BC
		aAdd (aRegB430[nPos], 0)						//09 - VL_BC_ISSQN_RT
		aAdd (aRegB430[nPos], 0)						//10 - VL_RT
		aAdd (aRegB430[nPos], 0)						//11 - VL_ISSQN
	EndIf
	//
	aRegB430[nPos][3]	+= (cAliasSFT)->FT_VALCONT		//03 - VL_CONT
	aRegB430[nPos][4]	+= (cAliasSFT)->FT_BASEICM		//04 - VL_BC_ISSQN
	aRegB430[nPos][6]	+= (cAliasSFT)->FT_ISSSUB		//06 - VL_SUB
	aRegB430[nPos][7]	+= (cAliasSFT)->FT_ISENICM		//07 - VL_ISNT_ISSQN
	If lIssRet
		aRegB430[nPos][9]	+= (cAliasSFT)->FT_BASEICM	//09 - VL_BC_ISSQN_RT
		aRegB430[nPos][10]	+= (cAliasSFT)->FT_VALICM	//10 - VL_RT
	EndIf
	aRegB430[nPos][11]	+= (cAliasSFT)->FT_VALICM		//11 - VL_ISSQN

Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |RegB440   ³ Autor ³Liber De esteban       ³ Data ³08/11/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³     B440 - RELATORIO DOS VALORES RETIDOS                   ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao do Registro B440                                  |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoe contidas no array    ³±±
±±³          ³ aCmpAntSFT e na tabela SFT.                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³B440 - 3(varios por periodo)                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cAliasSFT -> Alias da tabela SFT aberta no momento.         ³±±
±±³          ³ funcao a ser retornado para gravacao pela funcao principal.³±±
±±³          |aRegB440 -> Array contendo as informacoes processadas pela  ³±±
±±³          ³ funcao a ser retornado para gravacao pela funcao principal.³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RegB440 (cAliasSFT, cEntSai, aRegB440, aPartDoc)
	Local	nPos	:=	0
	Local	lRet	:=	.T.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³REGISTRO B440 - RELATORIO DOS VALORES RETIDOS ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ((nPos := aScan (aRegB440, {|aX| aX[2]==STR(Val (cEntSai)-1,1) .AND. aX[3]==aPartDoc[1] .AND. aX[6]==(cAliasSFT)->FT_ALIQICM}))==0)
		aAdd(aRegB440, {})
		nPos	:=	Len (aRegB440)
		aAdd (aRegB440[nPos], "B440")	 	   			//01 - REG
		aAdd (aRegB440[nPos], STR(Val (cEntSai)-1,1))	//02 - IND_OPER
		aAdd (aRegB440[nPos], aPartDoc[1])			   	//03 - COD_PART
		aAdd (aRegB440[nPos], 0)						//04 - VL_CONT_RT
		aAdd (aRegB440[nPos], 0)						//05 - VL_BC_ISSQN_RT
		aAdd (aRegB440[nPos], (cAliasSFT)->FT_ALIQICM)	//06 - ALIQ_ISSQN
		aAdd (aRegB440[nPos], 0)						//07 - VL_ISSQN_RT
	EndIf
	//
	aRegB440[nPos][4]	+= (cAliasSFT)->FT_VALCONT		//04 - VL_CONT_RT
	aRegB440[nPos][5]	+= (cAliasSFT)->FT_BASEICM		//05 - VL_BC_ISSQN_RT
	aRegB440[nPos][7]	+= (cAliasSFT)->FT_VALICM		//07 - VL_ISSQN_RT
	//
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |RegB450   ³ Autor ³Liber De esteban       ³ Data ³08/11/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³     B450 - TOTALIZACAO POR MUNICIPIO                       ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao do Registro B450                                  |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoe contidas no array    ³±±
±±³          ³ aCmpAntSFT e na tabela SFT.                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³B450 - 3(varios por periodo)                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cAliasSFT -> Alias da tabela SFT aberta no momento.         ³±±
±±³          ³ funcao a ser retornado para gravacao pela funcao principal.³±±
±±³          |aRegB450 -> Array contendo as informacoes processadas pela  ³±±
±±³          ³ funcao a ser retornado para gravacao pela funcao principal.³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RegB450 (cAliasSFT, cEntSai, aRegB450, cSituaDoc, aPartDoc, lIssRet, cB1MepLes, lMvISSxMun, cCmpCdEst, cCmpCdMun)
	Local	nPos	:=	0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³REGISTRO B450 - TOTALIZACAO POR MUNICIPIO   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ((nPos := aScan (aRegB450, {|aX| aX[2]==STR(Val (cEntSai)-1,1) .AND. aX[3]== Iif (lMvISSxMun .And. !Empty(&(cCmpCdEst)) .And. !Empty(&(cCmpCdMun)) .And. cB1MepLes == "2" .And. cEntSai=="1",RetCodEst(&(cCmpCdEst)) + &(cCmpCdMun),aPartDoc[11])}))==0)
		aAdd(aRegB450, {})
		nPos	:=	Len (aRegB450)
		aAdd (aRegB450[nPos], "B450")	 	   			//01 - REG
		aAdd (aRegB450[nPos], STR(Val (cEntSai)-1,1))	//02 - IND_OPER
		If lMvISSxMun .And. !Empty(&(cCmpCdEst)) .And. !Empty(&(cCmpCdMun)) .And. cB1MepLes == "2" .And. cEntSai=="1"
			aAdd (aRegB450[nPos], RetCodEst(&(cCmpCdEst)) + &(cCmpCdMun))					//03 - COD_MUN_SERV
		Else
			aAdd (aRegB450[nPos], aPartDoc[11])				//03 - COD_MUN_SERV
		EndIf
		aAdd (aRegB450[nPos], 0)						//04 - VL_CONT
		aAdd (aRegB450[nPos], 0)						//05 - VL_BC_ISSQN
		aAdd (aRegB450[nPos], 0)						//06 - VL_ISNT_ISSQN
		aAdd (aRegB450[nPos], 0)						//07 - VL_DED_BC
		aAdd (aRegB450[nPos], 0)						//08 - VL_RT
		aAdd (aRegB450[nPos], 0)						//09 - VL_ISSQN
	EndIf
	//
	aRegB450[nPos][4]	+= (cAliasSFT)->FT_VALCONT		//04 - VL_CONT
	aRegB450[nPos][5]	+= (cAliasSFT)->FT_BASEICM		//05 - VL_BC_ISSQN
	aRegB450[nPos][6]	+= (cAliasSFT)->FT_ISENICM		//06 - VL_ISNT_ISSQN
	If lIssRet
		aRegB450[nPos][8]	+= (cAliasSFT)->FT_VALICM	//08 - VL_RT
	EndIf
	aRegB450[nPos][9]	+= (cAliasSFT)->FT_VALICM		//09 - VL_ISSQN	
Return (.T.)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |RegB460   ³ Autor ³Liber De esteban       ³ Data ³08/11/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³              B460 - DEDUCAO DO ISSQN                       ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao do Registro B460                                  |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoes processadas de acor-³±±
±±³          ³ do com o item.                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³B460 - 3(varios por periodo)                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cAliasSFT -> Alias da tabela SFT aberta no momento.         ³±±
±±³          ³ funcao a ser retornado para gravacao pela funcao principal.³±±
±±³          ³cChave -> Chave de relacionento com o registro 0450.        ³±±
±±³          |aRegB460 -> Array contendo as informacoes processadas pela  ³±±
±±³          ³ funcao a ser retornado para gravacao pela funcao principal.³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RB460465( aRegB460 , dDataAte , cNrLivro , aRegB465 , cAlias , aReg0450 )
Local	nPos		:= 0
Local	nX			:= 0
Local	nY			:= 0
Local	nApuracao	:= GetSx1 (PadR("MTA954",10), "04", .T.)	//1-Decendial, 2-Quinzenal, 3-Mensal, 4-Semestral ou 5-Anual
Local	nPeriodo	:= 1								
Local	aApISS		:= {}
Local	cObs		:= ""
Local	cCodObs		:= "AUTO-DEDUCAOISS"

If ( nApuracao == 1 ) .Or. ( nApuracao == 2 )
	nApuracao := 3
Elseif ( nApuracao == 4 )
	nApuracao := 5
EndIf

aApISS := FisApur( "IS" , Year(dDataAte) , Month(dDataAte) , nApuracao , nPeriodo , cNrLivro , .F. , {} , 1 , .F. , "" )

If ( nY := aScan( aApISS, { |a| a[1] == "500" } ) ) > 0 

	For nX:=nY to Len( aApISS )

		If "OBSERVACAO" $ aApISS[ nX , 2 ]
			cObs += AllTrim( SubStr( aApISS[ nX , 2 ] , 12 , 50 ) ) + " "
		Endif

	Next

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³GRAVACAO - REGISTRO B460 - DEDUCAO DO ISS   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aRegB460 := { '' , 0 , 0 , '' , 0 , '' , '' }
	aRegB460[1] := "B460"								//01 - REG
	aRegB460[2] := "9"									//02 - IND_DED
	aRegB460[3] := Val(Substr(aApISS[nY+3][2],12,18))	//03 - VL_DED
	aRegB460[4] := ""									//04 - NUM_PROC
	aRegB460[5] := "9"									//05 - IND_PROC
	aRegB460[6] := "OUTROS"								//06 - PROC
	aRegB460[7] := cCodObs								//07 - COD_INF_OBS

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³REGISTRO 0450 - TABELA DE INFORMACOES COMPLEMENTARES/OBSERVACOES³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Reg0450 ( cAlias , 0 , "DEDUCAO DO ISS  " , Nil , cCodObs , @aReg0450 )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³GRAVACAO - REGISTRO B465 - COMPENSACAO ISS  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len( aRegB460 ) > 0 .And. Empty( aRegB465[ 1 ] );
	 .And. (Val(Substr(aApISS[nY+2][2],12,18)) > 0 .Or. Val(Substr(aApISS[nY+3][2],12,18)) > 0;
	   .Or. Val(Substr(aApISS[nY+4][2],12,18)) > 0)
		aRegB465[1] := "B465"								//01 - REG
		aRegB465[2] := Substr(aApISS[nY][2],12,1)			//02 - IND_COMP
		aRegB465[3] := Val(Substr(aApISS[nY+2][2],12,18))	//03 - VL_CRED
		aRegB465[4] := Val(Substr(aApISS[nY+3][2],12,18))	//04 - VL_COMP
		aRegB465[5] := Substr(aApISS[nY+1][2],12,18)		//05 - PER_FISCAL
		aRegB465[6] := Val(Substr(aApISS[nY+4][2],12,18))	//06 - VL_RES
		aRegB465[7] := cObs									//07 - COMENT
	Endif

Endif

Return (.T.)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |RegB465   ³ Autor ³Mauro A. Goncalves     ³ Data ³25.10.2012³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                COMPENSACAO DE ISS                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³B465 - 3(varios por periodo)                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cAlias -> Alias do TRB para gravacao.                       ³±±
±±³          ³dDataAte -> Data final do periodo de apuracao.              ³±±
±±³          ³cNrLivro -> Numero do livro selecionado no wizard.          ³±±
±±³          ³nAcImport -> Valor de ICMS da Importacao.                   ³±±
±±³          ³nAcRetInter -> Valor Substituicao Tributaria nas operacoes  ³±±
±±³          ³ interestaduais.                                            ³±±
±±³          ³nDbCompIcm -> Total das NFs de complemento de ICMS - saidas ³±±
±±³          ³nCrCompIcm ->Total das NFs de complemento de ICMS - entradas³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
/*Static Function RegB465(cAlias,dDataAte,cNrLivro,nAcImport,nAcRetInter,nDbCompIcm,nCrCompIcm,aLog,nAcRetEsta,nRelac,aRegB465)
	Local	nPos		:= 0
	Local	nX			:= 0
	Local	nY			:= 0
	Local	nApuracao	:= GetSx1 (PadR("MTA954",10), "04", .T.)	//1-Decendial, 2-Quinzenal, 3-Mensal, 4-Semestral ou 5-Anual
	Local	nPeriodo	:= 1
	Local	aApISS		:= {}
	Local	cObs		:= ""

	If (nApuracao==1) .Or. (nApuracao==2)
		nApuracao	:=	3
	ElseIf (nApuracao==4)
		nApuracao	:=	5
	EndIf

	aApISS := FisApur("IS", Year(dDataAte), Month(dDataAte), nApuracao, nPeriodo, cNrLivro, .F., {}, 1, .F., "")

	If (nY := aScan(aApISS, {|a| a[1]=="500"})) > 0
		For nX:=nY to Len(aApISS)
			If "OBSERVACAO"$aApISS[nX][2]
				cObs += AllTrim(Substr(aApISS[nX][2],12,50)) + " "
			Endif
		Next
		aRegB465[1] := "B465"	   	   						//01 - REG
		aRegB465[2] := Substr(aApISS[nY][2],12,1)			//02 - IND_COMP
		aRegB465[3] := Val(Substr(aApISS[nY+2][2],12,18)) //03 - VL_CRED
		aRegB465[4] := Val(Substr(aApISS[nY+3][2],12,18))	//04 - VL_COMP
		aRegB465[5] := Substr(aApISS[nY+1][2],12,18)		//05 - PER_FISCAL
		aRegB465[6] := Val(Substr(aApISS[nY+4][2],12,18)) //06 - VL_RES
		aRegB465[7] := cObs									//07 - COMENT
	Endif
Return (.T.)
*/
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |RegB470   ³ Autor ³Liber De esteban       ³ Data ³08/11/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³               SALDOS DO ISSQN A RECOLHER                   ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao e gravacao do Registro B470                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoe contidas na apuracao ³±±
±±³          ³ de ICMS.                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³B470 - 3(varios por periodo)                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cAlias -> Alias do TRB para gravacao.                       ³±±
±±³          ³dDataAte -> Data final do periodo de apuracao.              ³±±
±±³          ³cNrLivro -> Numero do livro selecionado no wizard.          ³±±
±±³          |cEntSai -> Flag Entrada(1)/Saida(2).                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RegB470 (cAliasSFT, aRegB470, cSituaDoc, aPartDoc, lIssRet, cEntSai, lGeraReg , cEspecie, cMunSgmt, cB1MepLes)

Local cMunRecIss := ""

// Regra B1_MEPLES p/ definicao do municipio no qual o ISS é devido:
// 1-EP: ISS devido no municipio do ESTABELECIMENTO PRESTADOR (SIGAMAT).
// 2-LES ou Branco: ISS devido no Local de Execucao do servico (Municipio do TOMADOR).
If cB1MepLes == "1"
	cMunRecIss := cMunSgmt
Else
	cMunRecIss := aPartDoc[11]
EndIf

If !lGeraReg
	Return .T.
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³REGISTRO B470 - SALDOS A RECOLHER           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aRegB470[12] += (cAliasSFT)->FT_ISSSUB 							//12 - VL_DED

If cEntSai=="1"	//	//Somente deverah ser acumulado para as retencoes na entrada
	If lIssRet
		aRegB470[14]	+= (cAliasSFT)->FT_VALICM			   		//14 - VL_ISSQN_ST
	EndIf
Else
	aRegB470[2]	+= (cAliasSFT)->FT_VALCONT							//02 - VL_CONT
	aRegB470[3]	+= 0												//03 - VL_MAT_TERC
	aRegB470[4]	+= 0												//04 - VL_MAT_PROP
	aRegB470[5]	+= (cAliasSFT)->FT_ISSSUB							//05 - VL_SUB
	aRegB470[6]	+= (cAliasSFT)->FT_ISENICM+(cAliasSFT)->FT_OUTRICM	//06 - VL_ISNT_ISSQN
	aRegB470[7]	:= aRegB470[3]+aRegB470[4]+aRegB470[5]+aRegB470[6]	//07 - VL_DED_BC
	aRegB470[8]	:= aRegB470[2]-aRegB470[7]							//08 - VL_BC_ISSQN

	If lIssRet
		aRegB470[9]		+= (cAliasSFT)->FT_BASEICM					//09 - VL_BC_ISSQN_RT
	EndIf

	aRegB470[10]	+= (cAliasSFT)->FT_VALICM						//10 - VL_ISSQN

	If lIssRet
		aRegB470[11]	+= (cAliasSFT)->FT_VALICM					//11 - VL_RT
	Else
		If !cEspecie $ "2D#03"
			aRegB470[14]	+= (cAliasSFT)->FT_VALICM				//14 - VL_ISSQN_ST
		EndIf
	EndIf

	If lIssRet .And. cEntSai == "1"
		aRegB470[14]	+= (cAliasSFT)->FT_VALICM					//14 - VL_ISSQN_ST
	EndIf

	aRegB470[13]	:= aRegB470[10]-aRegB470[11]-aRegB470[12]		//13 - VL_ISSQN_REC
	aRegB470[15]	+= 0											//15 - VL_ ISSQN_FIL
	
	// O campo 16 deve conter apenas o valor de ISS devido em outros municipios.
	// P/ qualquer alteracao nesta condicao verificar na funcao "RegB480" pois
	// eh feito o mesmo tratamento.
	If cMunRecIss <> cMunSgmt
		aRegB470[16]	+= (cAliasSFT)->FT_VALICM					//16 - VL_ ISSQN_RT_REC
	EndIf
Endif

Return (.T.)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RegC005   ³ Autor ³Gustavo G. Rueda       ³ Data ³08.05.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³            BENEFICIO FISCAL - DADOS ADICIONAIS             ³±±
±±³          ³                                                            ³±±
±±³          ³Geracao e gravacao do Registro C005                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoes de todos os docu-   ³±±
±±³          ³ mentos fiscais processados.                                ³±±
±±³          ³Este registro indica que o bloco "C" possui campos persona- ³±±
±±³          ³ lisaveis para o DF(C020 e C300).                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³2                                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAlias -> Alias do TRB que recebera as informacoes          ³±±
±±³          ³nRelac -> Flag de relacionamento com os sub-registros       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RegC005(cAlias, nRelac)
Local lRet     := .T.
Local aRegC005 := {}
Local nPos     := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Campos adicionados no registro C020³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd(aRegC005, {})
nPos	:=	Len (aRegC005)
aAdd (aRegC005[nPos], "C005")						//01 - REG
aAdd (aRegC005[nPos], "DF")							//02 - UF
aAdd (aRegC005[nPos], "C020")						//03 - REG_NOM
aAdd (aRegC005[nPos], "26")							//04 - CAMPO_INI
aAdd (aRegC005[nPos], "1")							//05 - QTD_CAMPO
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Campos adicionados no registro C300³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd(aRegC005, {})
nPos	:=	Len (aRegC005)
aAdd (aRegC005[nPos], "C005")						//01 - REG
aAdd (aRegC005[nPos], "DF")							//02 - UF
aAdd (aRegC005[nPos], "C300")						//03 - REG_NOM
aAdd (aRegC005[nPos], "25")							//04 - CAMPO_INI
aAdd (aRegC005[nPos], "3")							//05 - QTD_CAMPO

If lBloqCD
	GrvRegTrb (cAlias, nRelac, aRegC005)
Endif  

Return(lRet)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RegC020   ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³               NOTA FISCAL (MODELO 01 E 04)                 ³±±
±±³          ³                                                            ³±±
±±³          ³Geracao e gravacao do Registro C020                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoes de todos os docu-   ³±±
±±³          ³ mentos fiscais processados.                                ³±±
±±³          ³Somente sera gravado os documentos fiscais modelo 01 e 04   ³±±
±±³          ³ nos outros casos, sera utilizdo para gerar outros registros³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³2                                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cEntSai -> Flag de indicacao do documento fiscal, 1=Entrada/³±±
±±³          ³ 2=Saida.                                                   ³±±
±±³          ³aPartDoc -> Array com todas as informacoes do Cliente/Forne-³±±
±±³          ³ cedor.                                                     ³±±
±±³          ³cEspecie -> Modelo do documento fiscal                      ³±±
±±³          ³cAlias -> Alias do TRB que recebera as informacoes          ³±±
±±³          ³nRelac -> Flag de relacionamento com os sub-registros       ³±±
±±³          ³aCmpAntSFT -> Informacoes de cabecalho do documento fiscal  ³±±
±±³          ³aTotaliza -> Totalizacao de valores da tabela SFT do docu-  ³±±
±±³          ³ mento fiscal do processamento atual no while               ³±±
±±³          ³aRegC020 -> Informacoes sobre todos documentos fiscais pro- ³±±
±±³          ³ cessados no while da funcao principal.                     ³±±
±±³          ³cChave -> Chave para gravacao das observacoes do documento  ³±±
±±³          ³ fiscal referenciado(Registro 0450).                        ³±±
±±³          ³cSituaDoc -> Situacao do documento fiscal conforme funcao   ³±±
±±³          ³ RetSitDoc                                                  ³±±
±±³          ³lAchouSE4 -> Flag de posicionamento da tabela SE4 para a NF ³±±
±±³          ³ em processamento.                                          ³±±
±±³          ³lContrTare -> Flag que indica se trata-se de contribuinte   ³±±
±±³          ³ TARE para geracao do respectivo registro.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RegC020 (cEntSai, aPartDoc, cEspecie, cAlias, nRelac, aCmpAntSFT, aTotaliza, aRegC020, cChave, cSituaDoc, lAchouSE4, lContrTare, cCodObs, aconjugada, cCodNat)
	Local nPos := 0
	Local lRet := .T.
	//
	aAdd(aRegC020, {})
	nPos	:=	Len (aRegC020)
	aAdd (aRegC020[nPos], "C020")					   		//01 - REG
	aAdd (aRegC020[nPos], STR(Val (cEntSai)-1,1)) 			//02 - IND_OPER
	//
	If (Empty (aCmpAntSFT[8])) .And. cEntSai=="1"
		aAdd (aRegC020[nPos], "1")							//03 - IND_EMIT
	ElseIf (Empty (aCmpAntSFT[8])) .And. cEntSai=="2"
		aAdd (aRegC020[nPos], "0")							//03 - IND_EMIT
	Else
		If ("S"$aCmpAntSFT[8])
			aAdd (aRegC020[nPos], "0") 						//03 - IND_EMIT
		Else
			aAdd (aRegC020[nPos], "1")						//03 - IND_EMIT
		EndIf
	EndIf
	//
	aAdd (aRegC020[nPos], IIf (cSituaDoc$"02#03#04", "", aPartDoc[1]))	//04 - COD_PART
	aAdd (aRegC020[nPos], iif(MV_PAR05 == 2 .And. aconjugada[1] .And. aconjugada[2],AModNot(aCmpAntSFT[21]) ,cEspecie))  				 		//05 - COD_MOD
	aAdd (aRegC020[nPos], cSituaDoc)				  		//06 - COD_SIT
	aAdd (aRegC020[nPos], aCmpAntSFT[2])  			  		//07 - SER
	aAdd (aRegC020[nPos], aCmpAntSFT[1])  			   		//08 - NUM_DOC
	aAdd (aRegC020[nPos], aCmpAntSFT[6])			   		//09 - DT_DOC
	aAdd (aRegC020[nPos], aCmpAntSFT[5])			   		//10 - DT_E_S
	aAdd (aRegC020[nPos], cCodNat)							//11 - COD_NAT
	aAdd (aRegC020[nPos], aTotaliza[1])					//12 - VL_DOC	-	FT_VALCONT
	//
	//Para ser a vista, a condicao de pagamento deve ser tipo 1 e somente 00 no campo E4_COND.
	If (lAchouSE4) .And. ("1"$SE4->E4_TIPO) .And. "00"==AllTrim (SE4->E4_COND)
		aAdd (aRegC020[nPos], "0")	   			  			//13 - IND_PAGTO
	Else	
		aAdd (aRegC020[nPos], "1")	  			  			//13 - IND_PAGTO
	EndIf
	//
	aAdd (aRegC020[nPos], aTotaliza[9])					//14 - VL_DESC		-	
	aAdd (aRegC020[nPos], aTotaliza[10])					//15 - VL_MERC		-	FT_TOTAL
	//
	If (aTotaliza[11]>0)	//Se o vlr do frete for maio q ZERO, eh por conta do destinatario, senao do emitente.
		aAdd (aRegC020[nPos], "1")							//Destinatario	-	16 - IND_FRT
	Else
		aAdd (aRegC020[nPos], 0)							//Emitente	- 		16 - IND_FRT
	EndIf
	//
	aAdd (aRegC020[nPos], aTotaliza[11])					//17 - VL_FRT		-	FT_FRETE
	aAdd (aRegC020[nPos], aTotaliza[12])					//18 - VL_SEG		-	FT_SEGURO
	aAdd (aRegC020[nPos], aTotaliza[13]-aTotaliza[11]-aTotaliza[12])					//19 - VL_OUT_DA	-	FT_DESPESA
	aAdd (aRegC020[nPos], aTotaliza[2])						//20 - VL_BC_ICMS	-	FT_BASEICM
	aAdd (aRegC020[nPos], aTotaliza[3])						//21 - VL_ICMS		-	FT_VALICM
	aAdd (aRegC020[nPos], aTotaliza[4])						//22 - VL_BC_ST		-	FT_BASERET
	aAdd (aRegC020[nPos], aTotaliza[5])						//23 - VL_ST		-	FT_ICMSRET
	aAdd (aRegC020[nPos], aTotaliza[6])						//24 - VL_IPI		-	FT_VALIPI
	aAdd (aRegC020[nPos], IIf(cSituaDoc$"02#03#04", "", cCodObs))	//25 - REF_INF_OBS
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Somente para contribuintes TARE este registro deve ser enviado.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lContrTare
		aAdd (aRegC020[nPos], Iif(Empty(aPartDoc[9]),"0","1"))	//26 - DEST_NF		-	ADICIONADO PELO REG. C005
	EndIf
	//
	If (cEspecie$"01#04#55" .Or. (MV_PAR05 == 2 .And. aconjugada[1] .And. aconjugada[2]))
		If lBloqCD
			GrvRegTrb (cAlias, nRelac, aRegC020)
		Endif
	EndIf
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³C030C035  ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³             C030 - FATURA (MODELO 01 e 04)                 ³±±
±±³          ³         C035 - VENCIMENTO FATURA (MODELO 01 e 04)          ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao e gravacao do Registro C030 e C035                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoes dos titulos e seus  ³±±
±±³          ³ vencimentos para cada documento fiscal processado.         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³C030 - 3(1:N) Para cada Registro C020                       ³±±
±±³          ³C035 - 3(1:N) Para cada Registro C030                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAlias -> Alias do TRB que recebera as informacoes          ³±±
±±³          ³nRelac -> Flag de relacionamento com os sub-registros       ³±±
±±³          ³cEntSai -> Flag de indicacao do documento fiscal, 1=Entrada/³±±
±±³          ³ 2=Saida.                                                   ³±±
±±³          ³aCmpAntSFT -> Informacoes de cabecalho do documento fiscal  ³±±
±±³          ³aRegC020 -> Array contendo o cabecalho da nota fiscal modelo³±±
±±³          ³ 01 e 04.                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function C030C035 (cAlias, nRelac, cEntSai, aCmpAntSFT, aRegC020)
	Local	lRet		:= .T.
	Local	aReg		:= {}
	Local	aParc		:= {}
	Local	nVlTit		:= 0
	Local	nX			:= 0
	Local	nPos		:= 0
	Local	nItem		:= 1
	//

	If aRegC020[1][13]!="0"	// Para pagamento a vista nao pode haver fatura.
		If ("1"$cEntSai)
			aParc	:=	ProcSE2 ()
		Else
			aParc	:=	ProcSE1 ()
		EndIf
		aParc	:=	aSort (aParc,,,{|x, y| x[4]<y[4]})
		aEval (aParc, {|x| nVlTit += x[6]})
	EndIf

	For nX := 1 To Len (aParc)
		//Somente a primeira vez para utilizar as informacoes do titulo.
		If nX==1
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³REGISTRO C030 - COMPLEMENTO DO DOCUMENTO - FATURA ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aReg	:=	{}
			aAdd(aReg, {})
			nPos	:=	Len (aReg)
			aAdd (aReg[nPos], "C030")							//01 - REG
			If (Empty (aCmpAntSFT[8])) .And. cEntSai=="1"
				aAdd (aReg[nPos], "1")							//02 - IND_EMIT
			ElseIf (Empty (aCmpAntSFT[8])) .And. cEntSai=="2"
				aAdd (aReg[nPos], "0")							//02 - IND_EMIT
			Else
				If ("S"$aCmpAntSFT[8])
					aAdd (aReg[nPos], "0")						//02 - IND_EMIT
				Else
					aAdd (aReg[nPos], "1")						//02 - IND_EMIT
				EndIf
			EndIf
			//
			If (AllTrim (aParc[nX][1])$"BOL#DP#NF")				//03 - IND_TIT
				aAdd (aReg[nPos], "00")
			ElseIf (AllTrim (aParc[nX][1])$"CH")				//03 - IND_TIT
				aAdd (aReg[nPos], "01")
			ElseIf (AllTrim (aParc[nX][1])$"NP")				//03 - IND_TIT
				aAdd (aReg[nPos], "02")
			ElseIf (AllTrim (aParc[nX][1])$"RC")				//03 - IND_TIT
				aAdd (aReg[nPos], "03")
			Else
				aAdd (aReg[nPos], "99")							//03 - IND_TIT
			EndIf
			//
			If "99"$aReg[nPos,3]
				If Empty( aParc[nX][2] )
					aAdd (aReg[nPos], "Titulo de Nota Fiscal")	//04 - TIT
				Else
					aAdd (aReg[nPos], aParc[nX][2])				//04 - TIT
				EndIf
			Else
				aAdd (aReg[nPos], "")							//04 - TIT
			EndIf
			//
			aAdd (aReg[nPos], aParc[nX][3])						//05 - NUM_TIT
			aAdd (aReg[nPos], Alltrim(STR(Len (aParc))))		//06 - QTD_PARC
			aAdd (aReg[nPos], nVlTit)							//07 - VL_TIT
			//
			If lBloqCD
				GrvRegTrb (cAlias, nRelac, aReg, nItem)
			Endif		
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³REGISTRO C035 - VENCIMENTO DA FATURA³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aReg	:=	{}
		aAdd(aReg, {})
		nPos	:=	Len (aReg)
		aAdd (aReg[nPos], "C035")								//01 - REG
		aAdd (aReg[nPos], Alltrim(STR(nX)) )					//02 - NUM_PARC
		aAdd (aReg[nPos], aParc[nX][5])							//03 - DT_VECTO
		aAdd (aReg[nPos], aParc[nX][6])							//04 - VL_PARC
		//
		If lBloqCD
			GrvRegTrb (cAlias, nRelac, aReg, nItem)
		Endif
	Next (nX)

Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RegC040   ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³                  ISS (MODELO 01 E 04)                      ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao e gravacao do Registro C040                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoes de ISS/IRRF/PREV dos³±±
±±³          ³ documentos fiscais processados.                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³3(1:1) Para cada Registro C020                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAliasSFT -> Alias da tabela SFT posicionada                ³±±
±±³          ³aRegC040  -> Informacoes sobre ISS/IRRF/PREV para o documen-³±±
±±³          ³ to fiscal processado no while da funcao principal.         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RegC040 (cAliasSFT, aRegC040)
	Local lRet := .T.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³REGISTRO C040 - ISS³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aRegC040[2] += (cAliasSFT)->FT_VALCONT		//02 - VL_SERV_NT
	aRegC040[3] += (cAliasSFT)->FT_BASEICM		//03 - VL_BC_ISS
	aRegC040[4] += (cAliasSFT)->FT_VALICM		//04 - VL_ISS
	aRegC040[5] += (cAliasSFT)->FT_BASEIRR		//05 - VL_BC_IRRF
	aRegC040[6] := (cAliasSFT)->FT_ALIQIRR		//06 - ALIQ_IRRF
	aRegC040[7] += (cAliasSFT)->FT_VALIRR		//07 - VL_IRRF
	aRegC040[8] += (cAliasSFT)->FT_BASEINS		//08 - VL_BC_PREV
	aRegC040[9] += (cAliasSFT)->FT_VALINS		//09 - VL_PREV
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RegC050   ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³              PIS/COFINS (MODELO 01 E 04)                   ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao e gravacao do Registro C050                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoes de PIS/COFINS dos   ³±±
±±³          ³ documentos fiscais processados.                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³3(1:1) Para cada Registro C020                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAliasSFT -> Alias da tabela SFT posicionada                ³±±
±±³          ³aRegC050  -> Informacoes sobre PIS/COFINS para o documento  ³±±
±±³          ³ fiscal processado no while da funcao principal.            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RegC050 (cAliasSFT, aRegC050)
	Local lRet := .T.

	//
	aRegC050[2]	:=	(cAliasSFT)->FT_ALIQPIS		//02 - ALIQ_PIS
	aRegC050[3]	+=	(cAliasSFT)->FT_VALPIS		//03 - VL_PIS
	//
	aRegC050[4]	:=	(cAliasSFT)->FT_ALIQCOF		//04 - ALIQ_COFINS
	aRegC050[5]	+=	(cAliasSFT)->FT_VALCOF		//05 - VL_COFINS
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RegC060   ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³  DECLARACAO/BASE DE CALCULO DE IMPORTACAO (MODELO 01 e 04) ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao e gravacao do Registro C060                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoes de D.I. dos documen-³±±
±±³          ³ tos fiscais processados.                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³3(1:1) Para cada Registro C020                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAlsSF -> Alias para a tabela SF1 ou SF2 em processamento.  ³±±
±±³          ³cAlias -> Alias do TRB que recebera as informacoes          ³±±
±±³          ³nRelac -> Flag de relacionamento com os sub-registros       ³±±
±±³          ³aCmpAntSFT -> Informacoes de cabecalho do documento fiscal  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RegC060 (cAlsSF, cAlias, nRelac, aCmpAntSFT)
	Local	nPos		:=	0
	Local	lRet		:=	.T.
	Local	cCmpHawB	:=	cAlsSF+"->"+SubStr (cAlsSF, 2, 2)+"_HAWB"
	Local	cChave		:=	aCmpAntSFT[1]+aCmpAntSFT[2]+aCmpAntSFT[3]+aCmpAntSFT[4]
	Local	cCmpSyb		:=	"YB_ICMS_"+AllTrim (SuperGetMv ("MV_ESTADO"))	//Este campo define as despesas aduaneiros para o estado do emitente conforme configurado no cadastro.
	Local	aReg		:=	{}

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifico a existencia das tabelas utilizadas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !(AliasIndic ("SW6") .And. AliasIndic ("SWN") .And. AliasIndic ("SWW") .And. AliasIndic ("SWD") .And. AliasIndic ("SYB"))
		Return (lRet)
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posicionando o D.I. (CAPA)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea ("SW6")
		SW6->(DbSetOrder (1))
	If (SW6->(DbSeek (xFilial ("SW6")+&(cCmpHawB))))
		aReg	:=	{}
		aAdd(aReg, {})
		nPos	:=	Len (aReg)
		aAdd (aReg[nPos], "C060")						//01 - REG
		aAdd (aReg[nPos], SW6->W6_DI_NUM)				//02 - NUM_DI_DSI
		aAdd (aReg[nPos], SW6->W6_DTREG_D)				//03 - DT_REG
		aAdd (aReg[nPos], SW6->W6_DT_DESE)				//04 - DT_DES
		aAdd (aReg[nPos], 0)							//05 - VL_MERC
		aAdd (aReg[nPos], 0)							//06 - VL_PIS
		aAdd (aReg[nPos], 0)							//07 - VL_COFINS
		aAdd (aReg[nPos], 0)							//08 - VL_ADU
		aAdd (aReg[nPos], 0)							//09 - VL_ADU_ICMS
		aAdd (aReg[nPos], 0)							//10 - VL_IOF
		aAdd (aReg[nPos], 0)							//11 - VL_II
		aAdd (aReg[nPos], 0)							//12 - VL_BC_IMP_IPI
		aAdd (aReg[nPos], 0)							//13 - VL_IPI
		aAdd (aReg[nPos], 0)							//14 - VL_BC_IMP_ICMS
		aAdd (aReg[nPos], 0)							//15 - VL_ICMS	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Posicionando os itens da NF de Importacao³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea('SWN')
			SWN->(DbSetOrder (2))
		SWN->(DbSeek (xFilial ('SWN')+cChave), .F.)
		Do While !SWN->(Eof ()) .And.;
			(xFilial ("SWN")+cChave==SWN->WN_FILIAL+SWN->WN_DOC+SWN->WN_SERIE+SWN->WN_FORNECE+SWN->WN_LOJA)
			aReg[nPos][05]	+=	SWN->WN_CIF
			aReg[nPos][06]	+=	SWN->WN_VLRPIS
			aReg[nPos][07]	+=	SWN->WN_VLRCOF
			aReg[nPos][11]	+=	SWN->WN_IIVAL
			aReg[nPos][12]	+=	SWN->WN_IPIBASE
			aReg[nPos][13]	+=	SWN->WN_IPIVAL
			aReg[nPos][14]	+=	SWN->WN_BASEICM
			aReg[nPos][15]	+=	SWN->WN_VALICM
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Posicionando despesas por NF³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			DbSelectArea ("SWW")
				SWW->(DbSetOrder (1))
			If (SWW->(DbSeek (xFilial ("SWW")+SWN->WN_DOC+SWN->WN_SERIE+SWN->WN_FORNECE+SWN->WN_LOJA+SWN->WN_PO_EIC+SWN->WN_ITEM))) .And.;
				(SWW->WW_TIPO_NF==SWN->WN_TIPO_NF)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Posicionando a D.I. Despesas³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				DbSelectArea ("SWD")
					SWD->(DbSetOrder (1))
				If (SWD->(DbSeek (xFilial ("SWD")+&(cCmpHawB)+SubStr (SWW->WW_DESPESA, 1, 3))))
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Posicionando cadastro de despesas³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					DbSelectArea ("SYB")
						SYB->(DbSetOrder (1))
					If (SYB->(DbSeek (xFilial ("SYB")+SWD->WD_DESPESA))) .And.;
						(SYB->YB_BASECUS=="1" .And. SYB->YB_BASEIMP=="2" .And. SYB->YB_BASEICM=="2" .And. SYB->&(cCmpSyb)=="1")
						aReg[nPos][08]	+=	SWW->WW_VALOR
					EndIf
				EndIf
			EndIf
			//
			SWN->(DbSkip ())
		EndDo
	EndIf
	//    
	If lBloqCD
		GrvRegTrb (cAlias, nRelac, aReg)
	EndIf
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RegC300   ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³         ITENS DO DOCUMENTO (MODELO 01 E 04)                ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao e gravacao do Registro C300                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com a informacao de cada item do docu- ³±±
±±³          ³ mento fiscal processado no while da funcao principal.      ³±±
±±³          ³Somente sera gravado os documentos fiscais modelo 01 e 04   ³±±
±±³          ³ nos outros casos, sera utilizdo para gerar outros registros³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³3(1:N) Para cada Registro C020                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAlias -> Alias do TRB que recebera as informacoes          ³±±
±±³          ³nRelac -> Flag de relacionamento com os sub-registros       ³±±
±±³          ³nItem -> Contador do item para cada documento fiscal.       ³±±
±±³          ³aRegC300 -> Informacoes sobre os itens do documento fiscal  ³±±
±±³          ³ processado no while da funcao principal.                   ³±±
±±³          ³cEspecie -> Modelo do documento fiscal                      ³±±
±±³          ³cAliasSFT -> Alias da tabela SFT posicionada                ³±±
±±³          ³cAlsSD -> Alias da tabela SD? posicionada                   ³±±
±±³          |cEntSai -> Flag Entrada(1)/Saida(2).                        ³±±
±±³          |lIss -> Indica se o documento incide ISS.                   ³±±
±±³          |cClasFis -> Classificacao fiscal do ICMS.                   ³±±
±±³          |nMVITTARE -> Posicao do campo do ITEM TARE na tabela SB5.   ³±±
±±³          |lAchouSF4 -> Indicador do SEEK na tabela SF4.               ³±±
±±³          ³lContrTare -> Flag que indica se trata-se de contribuinte   ³±±
±±³          ³ TARE para geracao do respectivo registro.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RegC300 (cAlias, nRelac, nItem, aRegC300, cEspecie, cAliasSFT, cAlsSD, cEntSai, lIss, cClasFis, nMVITTARE, lAchouSF4, lContrTare, lGeraReg, aconjugada, cCmpUm)
	Local lRet		:= .T.
	Local nPos		:= 0
//	Local cCmpUm	:= cAlsSD+"->"+SubStr (cAlsSD, 2, 2)+"_UM"	
	Local cItTare	:= Iif(nMVITTARE>0,SB5->(FieldGet(nMVITTARE)),"")
	Local nRedBsICMS:= 0

	If (cEspecie$"01#04#55" .Or. (MV_PAR05 == 2 .And. aconjugada[1] .And. aconjugada[2]))
		If lBloqCD
			Reg0200()
		EndIf
	Endif

	If (SX5->(DbSeek (xFilial ("SX5")+"S3"+(cAliasSFT)->FT_CTIPI)))
		cCtipi := (cAliasSFT)->FT_CTIPI
	Else
		If cEntSai == "1"
			cCtipi := "49"
		Else
			cCtipi := "99"
		EndIf
	EndIf

	nRedBsICMS := Iif(lAchouSF4, SF4->F4_BASEICM, 0) //Base Redução ICMS
	If lCOTEP02
		nRedBsICMS := ExecBlock("COTEPE02",.f.,.f.,{cAliasSFT,cAlsSD,cEspecie,cEntSai,lIss,cClasFis,nRedBsICMS})
	Endif

	//
	aAdd(aRegC300, {})
	nPos :=	Len (aRegC300)
	aAdd (aRegC300[nPos], "C300")		   					  					//01 - REG
	aAdd (aRegC300[nPos], AllTrim (STR (nItem)))			  					//02 - NUM_ITEM
	aAdd (aRegC300[nPos], (cAliasSFT)->FT_PRODUTO)			  					//03 - COD_ITEM
	aAdd (aRegC300[nPos], {(cAliasSFT)->FT_PRCUNIT, "VLR3"}) 					//04 - VL_UNIT
	aAdd (aRegC300[nPos], {(cAliasSFT)->FT_QUANT, "VLR3"})						//05 - QTD
	aAdd (aRegC300[nPos], &(cCmpUm))						 					//06 - UNID
	aAdd (aRegC300[nPos], (cAliasSFT)->FT_TOTAL)		   						//07 - VL_ITEM
	aAdd (aRegC300[nPos], (cAliasSFT)->FT_DESCONT)		 						//08 - VL_DESC_I
	aAdd (aRegC300[nPos], 0)			   										//09 - IND_MOV
	aAdd (aRegC300[nPos], (cAliasSFT)->FT_POSIPI)								//10 - COD_NCM
	aAdd (aRegC300[nPos], Substr(SB1->B1_EX_NCM,1,2))					//11 - EX_NCM
	aAdd (aRegC300[nPos], Substr(SB1->B1_EX_NBM,1,2))					//12 - EX_II
	aAdd (aRegC300[nPos], cClasFis)												//13 - CST
	aAdd (aRegC300[nPos], (cAliasSFT)->FT_CFOP)  			   					//14 - CFOP
	aAdd (aRegC300[nPos], IIf(lIss,0,(cAliasSFT)->FT_BASEICM))					//15 - VL_BC_ICMS_I
	aAdd (aRegC300[nPos], IIf(lIss,0,(cAliasSFT)->FT_ALIQICM))					//16 - ALIQ_ICMS
	aAdd (aRegC300[nPos], IIf(lIss,0,(cAliasSFT)->FT_VALICM))                   //17 - VL_ICMS_I
	aAdd (aRegC300[nPos], IIf(lIss,0,(cAliasSFT)->FT_BASERET))					//18 - VL_BC_ST_I
	If ((cAliasSFT)->FT_ICMSRET>0) .and. !lIss
		aAdd (aRegC300[nPos], (cAliasSFT)->FT_ALIQICM)		 					//19 - ALIQ_ST
	Else
		aAdd (aRegC300[nPos], 0)	 	   										//19 - ALIQ_ST
	EndIf
	aAdd (aRegC300[nPos], IIf(lIss,0,(cAliasSFT)->FT_ICMSRET))					//20 - VL_ST_I
	aAdd (aRegC300[nPos], cCtipi)		 					  					//21 - CTIPI
	aAdd (aRegC300[nPos], (cAliasSFT)->FT_BASEIPI)	 							//22 - VL_BC_IPI
	aAdd (aRegC300[nPos], (cAliasSFT)->FT_ALIQIPI)								//23 - ALIQ_IPI
	aAdd (aRegC300[nPos], (cAliasSFT)->FT_VALIPI)								//24 - VL_IPI_I
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Somente para contribuintes TARE este registro deve ser enviado.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lContrTare
		aAdd (aRegC300[nPos], Iif(Empty(cItTare),"1","0"))	 						//25 - IND_IF		-	ADICIONADO PELO REG. C005
		aAdd (aRegC300[nPos], cItTare)												//26 - ITEM_PORT	-	ADICIONADO PELO REG. C005
		aAdd (aRegC300[nPos], nRedBsICMS)				                            //27 - RED_BC_ICMS	-	ADICIONADO PELO REG. C005
	EndIf
	//
	If (cEspecie$"01#04#55" .Or. (MV_PAR05 == 2 .And. aconjugada[1] .And. aconjugada[2]))
		If lBloqCD
			GrvRegTrb (cAlias, nRelac, aRegC300, nItem)
		endif
	EndIf
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RegC305   ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³          QUALIFICACAO DO ITEM (MODELO 01 e 04)             ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao e gravacao do Registro C305                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com a informacao de cada produto do    ³±±
±±³          ³ cadastro posicionado.                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³4(1:N) Para cada Registro C300                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAlias -> Alias do TRB que recebera as informacoes          ³±±
±±³          ³nRelac -> Flag de relacionamento com os sub-registros       ³±±
±±³          ³nItem -> Contador do item para cada documento fiscal.       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RegC305 (cAlias, nRelac, nItem)
	Local lRet := .T.
	Local aReg := {}
	Local nPos := 0

	aAdd(aReg, {})
	nPos := Len(aReg)
	aAdd (aReg[nPos], "C305")			//01 - REG
	aAdd (aReg[nPos], SB1->B1_DESC)		//02 - DESCR_COMPL
	If lBloqCD
		GrvRegTrb (cAlias, nRelac, aReg, nItem)
	endif
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RegC310   ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³              OPERACOES COM ISS (MODELO 01)                 ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao e gravacao do Registro C310                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com a informacao de ISS do Livro Fiscal³±±
±±³          ³ por item SFT posicionado no momento.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³4(1:1) Para cada Registro C300                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAlias -> Alias do TRB que recebera as informacoes          ³±±
±±³          ³nRelac -> Flag de relacionamento com os sub-registros       ³±±
±±³          ³cAliasSFT -> Alias da tabela SFT posicionada                ³±±
±±³          ³nItem -> Contador do item para cada documento fiscal.       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RegC310 (cAlias, nRelac, cAliasSFT, nItem)
	Local lRet := .T.
	Local aReg := {}
	Local nPos := 0
	//
	aAdd(aReg, {})
	nPos := Len(aReg)
	aAdd (aReg[nPos], "C310")					//01 - REG
	aAdd (aReg[nPos], (cAliasSFT)->FT_BASEICM)	//02 - VL_BC_ISS_I
	aAdd (aReg[nPos], (cAliasSFT)->FT_ALIQICM)	//03 - ALIQ_ISS
	aAdd (aReg[nPos], (cAliasSFT)->FT_VALICM)	//04 - VL_ISS_I
	//
	If lBloqCD
		GrvRegTrb (cAlias, nRelac, aReg, nItem)
	endif
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RegC315   ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³           OPERACOES COM MEDICAMENTOS (MODELO 01)           ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao e gravacao do Registro C315                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³da funcao GrvRegTrb com a informacao do lote do produto(SB8)³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³4(1:1) Para cada Registro C300                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAlias -> Alias do TRB que recebera as informacoes          ³±±
±±³          ³nRelac -> Flag de relacionamento com os sub-registros       ³±±
±±³          ³nItem -> Contador do item para cada documento fiscal.       ³±±
±±³          ³aMVRC315 -> Array com campo da tabela SB5 para identificar a³±±
±±³          ³ referencia de base do medicamento.                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RegC315 (cAlias, nRelac, nItem, lAchouSB5, cAlsSD, lAchouSB8, aMVRC315)
	Local lRet := .T.
	Local aReg := {}
	Local nPos := 0

	If Len (aMVRC315) > 0
		cCmpMed := aMVRC315[Len (aMVRC315)]
	Else
		cCmpMed := ""
	EndIf

	If lAchouSB8 .And. lAchouSB5
		aAdd(aReg, {})
		nPos := Len(aReg)
		aAdd (aReg[nPos], "C315")											//01 - REG
		aAdd (aReg[nPos], SB8->B8_LOTECTL )									//02 - LOTE_MED
		aAdd (aReg[nPos], SB8->B8_DTVALID )									//03 - DT_VAL
		aAdd (aReg[nPos], "0" )												//04 - IND_MED
		//
		If SB5->(FieldPos(cCmpMed)) > 0
			aReg[nPos][4]	:= SB5->(FieldGet (FieldPos (cCmpMed)))			//04 - IND_MED
		EndIf
		//
		aAdd (aReg[nPos], SB5->B5_PRV2)										//05 - VL_TAB_MAX
		If lBloqCD
			GrvRegTrb (cAlias, nRelac, aReg, nItem)
		endif
	EndIf
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RegC320   ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³          OPERACOES COM ARMAS DE FOGO (MODELO 01)           ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao e gravacao do Registro C320                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com a informacao de cada complemento   ³±±
±±³          ³ de produto (SB5) posicionado no momento.                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³4(1:1) Para cada Registro C300                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAlias -> Alias do TRB que recebera as informacoes          ³±±
±±³          ³nRelac -> Flag de relacionamento com os sub-registros       ³±±
±±³          ³aMVRC320 -> Campos da tabela SB5 para identificar o Tipo de ³±±
±±³          ³ arma de fogo[1], Serie de fabricacao da arma[2], Serie de  ³±±
±±³          ³ fabricacao do cano[3] e Descricao da arma[4].              ³±±
±±³          ³nItem -> Contador do item para cada documento fiscal.       ³±±
±±³          ³lAchouSB5 -> Flag de posicionamento da tabela SB5 para o item³±±
±±³          ³ em processamento.                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RegC320 (cAlias, nRelac, aMVRC320, nItem, lAchouSB5)
	Local lRet := .T.
	Local aReg := {}
	Local nPos := 0

	If (lAchouSB5) .And.;
		(Len (aMVRC320)==4) .And.;
		(SB5->(FieldPos (aMVRC320[1]))<>0 .And. SB5->(FieldPos (aMVRC320[2]))<>0 .And. SB5->(FieldPos (aMVRC320[3]))<>0) .And.;
		!Empty (SB5->(FieldGet (FieldPos (aMVRC320[1])))) .And. !Empty (SB5->(FieldGet (FieldPos (aMVRC320[2])))) .And.;
		!Empty (SB5->(FieldGet (FieldPos (aMVRC320[3])))) .And. !Empty (SB5->(FieldGet (FieldPos (aMVRC320[4]))))
		//
		aAdd(aReg, {})
		nPos	:=	Len (aReg)
		aAdd (aReg[nPos], "C320")											//01 - REG
		aAdd (aReg[nPos], SB5->(FieldGet (FieldPos (aMVRC320[1]))))		//02 - IND_ARM
		aAdd (aReg[nPos], SB5->(FieldGet (FieldPos (aMVRC320[2]))))		//03 - NUM_ARM
		aAdd (aReg[nPos], SB5->(FieldGet (FieldPos (aMVRC320[3]))))		//04 - NUM_CANO
		aAdd (aReg[nPos], SB5->(FieldGet (FieldPos (aMVRC320[4]))))		//05 - DESCR_COMPL
		//
		If lBloqCD
			GrvRegTrb (cAlias, nRelac, aReg, nItem)
		endif
	EndIf
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RegC325   ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³          OPERACOES COM VEICULOS NOVOS (MODELO 01)          ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao e gravacao do Registro C325                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com a informacao de cada complemento   ³±±
±±³          ³ de produto (SB5) posicionado no momento.                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³4(1:1) Para cada Registro C300                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAlias -> Alias do TRB que recebera as informacoes          ³±±
±±³          ³nRelac -> Flag de relacionamento com os sub-registros       ³±±
±±³          ³aMVRC325 -> Campos da tabela SB5 para identificar o Chassi  ³±±
±±³          ³ do veiculo[1].                                             ³±±
±±³          ³aPartDoc -> Informacoes sobre o participante do documento.  |±±
±±³          ³nItem -> Contador do item para cada documento fiscal.       ³±±
±±³          ³lAchouSB5 -> Flag de posicionamento da tabela SB5 para o item³±±
±±³          ³ em processamento.                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RegC325 (cAlias, nRelac, aMVRC325, aPartDoc, nItem, lAchouSB5)
	Local lRet := .T.
	Local aReg := {}
	Local nPos := 0
	//
	If (lAchouSB5) .And.;
		(Len (aMVRC325)==3) .And.;
		(SB5->(FieldPos (aMVRC325[1]))<>0) .And.;
		!Empty (SB5->(FieldGet (FieldPos (aMVRC325[1]))))
		//
		aAdd(aReg, {})
		nPos	:=	Len (aReg)
		aAdd (aReg[nPos], "C325")										//01 - REG
		aAdd (aReg[nPos], "")											//02 - IND_VEIC_OPER
		aAdd (aReg[nPos], aPartDoc[4])									//03 - CNPJ
		aAdd (aReg[nPos], aPartDoc[5])									//04 - CPF
		aAdd (aReg[nPos], aPartDoc[8])									//05 - UF
		aAdd (aReg[nPos], aPartDoc[9])									//06 - IE
		aAdd (aReg[nPos], SB5->(FieldGet (FieldPos (aMVRC325[1]))))	//07 - CHASSI_VEIC
		// 
		If lBloqCD
			GrvRegTrb (cAlias, nRelac, aReg, nItem)
		endif
	EndIf
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RegC500   ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³      REGISTRO ANALITICO DO DOCUMENTO (MODELO 01 E 04)      ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao do Registro C500                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoes contidas no array   ³±±
±±³          ³ aRegC300(Itens) aglutinados CFOP, CST e ALIQ.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³3(1:N) Para cada Registro C020                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³aRegC300 -> Informacoes dos Itens do documento fiscal       ³±±
±±³          ³cAliasSFT -> Alias da tabela SFT posicionada no momento     ³±±
±±³          ³aRegC500 -> Array contendo as informacoes aglutinadas do    ³±±
±±³          ³ do documento fiscal para posterior geracao na funcao prin- ³±±
±±³          ³ cipal.                                                     |±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
/*
Static Function RegC500 (aRegC300, cAliasSFT, aRegC500)
	Local	lRet   		:=	.T.
	Local	nPos		:=	0
	Local	nPosC300	:=	1
	//
	If ((nPos := aScan (aRegC500, {|aX| aX[2]==aRegC300[nPosC300][14] .And. aX[3]==aRegC300[nPosC300][13] .And. aX[4]==aRegC300[nPosC300][16]})))==0	//CHAVE CFOP, CST e ALIQ_ICMS
		aAdd(aRegC500, {})
		nPos	:=	Len (aRegC500)
		aAdd (aRegC500[nPos], "C500")	 	   				//01 - REG
		aAdd (aRegC500[nPos], aRegC300[nPosC300][13])		//02 - CST
		aAdd (aRegC500[nPos], aRegC300[nPosC300][14])		//03 - CFOP
		aAdd (aRegC500[nPos], 0)		 		 			//04 - VL_CONT_P
		aAdd (aRegC500[nPos], 0)							//05 - VL_BC_ICMS_P
		aAdd (aRegC500[nPos], aRegC300[nPosC300][16])		//06 - ALIQ_ICMS
		aAdd (aRegC500[nPos], 0)	 		  				//07 - VL_ICMS_P
		aAdd (aRegC500[nPos], 0)	 						//08 - VL_BC_ICMS_ST_P
		aAdd (aRegC500[nPos], 0)	 						//09 - VL_IPI_P
	EndIf
	//
	aRegC500[nPos][4]	+=	(cAliasSFT)->FT_VALCONT	 		//04 - VL_CONT_P
	aRegC500[nPos][5]	+=	aRegC300[nPosC300][15]			//05 - VL_BC_ICMS_P
	aRegC500[nPos][7]	+=	aRegC300[nPosC300][17]			//07 - VL_ICMS_P
	aRegC500[nPos][8]	+=	aRegC300[nPosC300][18]			//08 - VL_BC_ICMS_ST_P
	aRegC500[nPos][9]	+=	aRegC300[nPosC300][24]			//09 - VL_IPI_P
Return (lRet)
*/
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RegC550   ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³       NOTA FISCAL DE VENDA A CONSUMIDOR (MODELO 02)        ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao e gravacao do Registro C550                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoe contidas no array    ³±±
±±³          ³ aRegC020 para o Modelo 02.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³2(Varios por arquivo)                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAlias -> Alias do TRB que recebera as informacoes          ³±±
±±³          ³nRelac -> Flag de relacionamento com os sub-registros       ³±±
±±³          ³aRegC020 -> Informacoes sobre todos documentos fiscais pro- ³±±
±±³          ³ cessados no while da funcao principal.                     ³±±
±±³          ³nItem -> Contador do item para cada documento fiscal.       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RegC550 (cAlias, nRelac, aRegC020, nItem, aPartDoc)
	Local	lRet   		:=	.T.
	Local	nPos		:=	0
	Local	aRegC550	:=	{}
	//  
	aAdd(aRegC550, {})
	nPos	:=	Len (aRegC550)
	aAdd (aRegC550[nPos], "C550")	 	   			//01 - REG
	aAdd (aRegC550[nPos], aPartDoc[5])				//02 - CPF
	aAdd (aRegC550[nPos], aPartDoc[4])				//03 - CNPJ
	aAdd (aRegC550[nPos], aRegC020[1][5])	 		//04 - COD_MOD
	aAdd (aRegC550[nPos], aRegC020[1][6])	 		//05 - COD_SIT
	aAdd (aRegC550[nPos], aRegC020[1][7])	 		//06 - SER
	aAdd (aRegC550[nPos], "")						//07 - SUB
	aAdd (aRegC550[nPos], aRegC020[1][8])	 		//08 - NUM_DOC
	aAdd (aRegC550[nPos], aRegC020[1][9])	 		//09 - DT_DOC
	aAdd (aRegC550[nPos], aRegC020[1][12])	 		//10 - VL_DOC
	aAdd (aRegC550[nPos], aRegC020[1][14])	 		//11 - VL_DESC
	aAdd (aRegC550[nPos], aRegC020[1][15])	 		//12 - VL_MERC
	aAdd (aRegC550[nPos], aRegC020[1][20])	 		//13 - VL_BC_ICMS
	aAdd (aRegC550[nPos], aRegC020[1][21])	 		//14 - VL_ICMS
	aAdd (aRegC550[nPos], aRegC020[1][25])	 		//15 - REF_INF_OBS
	//
	If lBloqCD
		GrvRegTrb (cAlias, nRelac, aRegC550, nItem)
	endif	
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RegC555   ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³              ITENS DO DOCUMENTO (MODELO 02)                ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao e gravacao do Registro C555                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoe contidas no array    ³±±
±±³          ³ aRegC300 para o Modelo 02.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³3(1:N) Para cada C550                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAlias -> Alias do TRB que recebera as informacoes          ³±±
±±³          ³nRelac -> Flag de relacionamento com os sub-registros       ³±±
±±³          ³aRegC300 -> Informacoes sobre os itens dos documentos fis-  ³±±
±±³          ³ cais processados no while da funcao principal.             ³±±
±±³          ³nItem -> Contador do item para cada documento fiscal.       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RegC555 (cAlias, nRelac, aRegC300, cAliasSFT, nItem, cClasFis, cCmpUm)
	Local	lRet   		:=	.T.
	Local	nPos		:=	0
	Local	aRegC555	:=	{}
	Local	nPosC300	:=	1
	
		If lBloqCD
			Reg0200()
		EndIf	
	//
	aAdd(aRegC555, {})
	nPos	:=	Len (aRegC555)
	aAdd (aRegC555[nPos], "C555")	 	   					//01 - REG
	aAdd (aRegC555[nPos], AllTrim (STR (nItem)))				//aRegC300[nPosC300][2])			//02 - NUM_ITEM
	aAdd (aRegC555[nPos], (cAliasSFT)->FT_PRODUTO) 				//aRegC300[nPosC300][3])			//03 - COD_ITEM
	aAdd (aRegC555[nPos], {(cAliasSFT)->FT_PRCUNIT, "VLR3"})	//aRegC300[nPosC300][4])			//04 - VL_UNIT
	aAdd (aRegC555[nPos], {(cAliasSFT)->FT_QUANT  , "VLR3"})	//aRegC300[nPosC300][5])			//05 - QTD
	aAdd (aRegC555[nPos], &(cCmpUm))							//aRegC300[nPosC300][6])			//06 - UNID
	aAdd (aRegC555[nPos], (cAliasSFT)->FT_TOTAL)				//aRegC300[nPosC300][7])			//07 - VL_ITEM
	aAdd (aRegC555[nPos], (cAliasSFT)->FT_DESCONT)				//aRegC300[nPosC300][8])			//08 - VL_DESC_I
	aAdd (aRegC555[nPos], cClasFis)								//aRegC300[nPosC300][13])			//09 - CST
	aAdd (aRegC555[nPos], (cAliasSFT)->FT_CFOP)					//aRegC300[nPosC300][14])			//10 - CFOP
	aAdd (aRegC555[nPos], (cAliasSFT)->FT_BASEICM)				//aRegC300[nPosC300][15])			//11 - VL_BC_ICMS_I
	aAdd (aRegC555[nPos], (cAliasSFT)->FT_ALIQICM)				//aRegC300[nPosC300][16])			//12 - ALIQ_ICMS
	aAdd (aRegC555[nPos], (cAliasSFT)->FT_VALICM)				//aRegC300[nPosC300][17])			//13 - VL_ICMS_I
	//  
	If lBloqCD
		GrvRegTrb (cAlias, nRelac, aRegC555, nItem)
	endif	
	
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³C570C575  ³ Autor ³Gustavo G. Rueda                  ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                                       ³±±
±±³          ³C570 - RESUMO DIARIO DAS NOTAS FISCAIS DE VENDA A CONSUMIDOR(MODELO 02)³±±
±±³          ³       C575 - ITENS DO RESUMO DIARIO DOS DOCUMENTOS(MODELO 02)         ³±±
±±³          ³                                                                       ³±±
±±³          ³- Geracao e gravacao do Registro C570 e C575                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves da funcao  ³±±
±±³          ³ GrvRegTrb com as informacoe contidas no array aRegC020(Cabecalho) e   ³±±
±±³          ³ aRegC300(Itens) para o Modelo 02.                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³C570 - 2(varios por arquivo)                                           ³±±
±±³          ³C575 - 3(1:N) Para cada C570                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³aRegC020 -> Informacoes sobre todos documentos fiscais processados no  ³±±
±±³          ³ while da funcao principal.                                            ³±±
±±³          ³aRegC300 -> Informacoes sobre os itens dos documentos fiscais proces-  ³±±
±±³          ³ sados no while da funcao principal.                                   ³±±
±±³          ³aRegC570 -> Informacoes sobre o cabecalho dos documentos fiscais proces-³±±
±±³          ³ sados no while da funcao principal.                                   ³±±
±±³          ³aRegC575 -> Informacoes sobre os itens dos documentos fiscais proces-  ³±±
±±³          ³ sados no while da funcao principal.                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
/*
Static Function C570C575 (aRegC020, aRegC300, aRegC570, aRegC575)
	Local	lRet	:=	.T.
	Local	nPos	:=	0
	Local	nPos2	:=	0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³REGISTRO C570 - RESUMO DIARIO DAS NOTAS FISCAIS DE VENDA A CONSUMIDOR(MODELO 02)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ((nPos := aScan (aRegC570, {|aX| aX[2]==aRegC020[1][5] .And. aX[3]==aRegC020[1][7] .And. aX[8]==aRegC020[1][9]}))==0)
		aAdd(aRegC570, {})
		nPos	:=	Len (aRegC570)
		aAdd (aRegC570[nPos], "C570")	 	   			//01 - REG
		aAdd (aRegC570[nPos], aRegC020[1][5])			//02 - COD_MOD
		aAdd (aRegC570[nPos], aRegC020[1][7])			//03 - SER
		aAdd (aRegC570[nPos], "")						//04 - SUB
		aAdd (aRegC570[nPos], aRegC020[1][8])			//05 - NUM_DOC_INI
		aAdd (aRegC570[nPos], aRegC020[1][8])			//06 - NUM_DOC_FIN
		aAdd (aRegC570[nPos], "0")						//07 - QTD_CANC
		aAdd (aRegC570[nPos], aRegC020[1][9])			//08 - DT_DOC
		aAdd (aRegC570[nPos], 0)						//09 - VL_DOC
		aAdd (aRegC570[nPos], 0)						//10 - VL_BC_ICMS
		aAdd (aRegC570[nPos], 0)						//11 - VL_ICMS
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Range de Numero de Documentos³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (aRegC020[1][8]<aRegC570[nPos][5])
		aRegC570[nPos][5]	:=	aRegC020[1][8]			//05 - NUM_DOC_INI
	EndIf
	//
	If (aRegC020[1][8]>aRegC570[nPos][6])
		aRegC570[nPos][6]	:=	aRegC020[1][8]			//06 - NUM_DOC_FIN
	EndIf
    //
	If ("02"==aRegC020[1][6])	//02=Situacao de cancelada
		aRegC570[nPos][7]	:=	STR (Val (aRegC570[nPos][7]) + 1)	//QTD_CANC
	Else
		aRegC570[nPos][9]	+=	aRegC020[1][12]				//VL_DOC
		aRegC570[nPos][10]	+=	aRegC020[1][20]				//VL_BC_ICMS
		aRegC570[nPos][11]	+=	aRegC020[1][21]				//VL_ICMS
	EndIf
	//
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³REGISTRO C575 - ITENS DO RESUMO DIARIO DOS DOCUMENTOS(MODELO 02)                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ((nPos2 := aScan (aRegC575, {|aX| aX[1]==nPos .And. aX[3]==aRegC300[1][3]}))==0)
		aAdd(aRegC575, {})
		nPos2	:=	Len (aRegC575)
		aAdd (aRegC575[nPos2], nPos)	 	   					//01 - RELACIONAMENTO COM O CABECALHO C570
		aAdd (aRegC575[nPos2], "C575")	 	   					//02 - REG
		aAdd (aRegC575[nPos2], aRegC300[1][3])					//03 - COD_ITEM
		aAdd (aRegC575[nPos2], {0,"VLR3"})						//04 - QTD
		aAdd (aRegC575[nPos2], aRegC300[1][6])					//05 - UNID
		aAdd (aRegC575[nPos2], 0)								//06 - VL_ITEM
		aAdd (aRegC575[nPos2], aRegC300[1][13])				//07 - CST
		aAdd (aRegC575[nPos2], aRegC300[1][14])				//08 - CFOP
		aAdd (aRegC575[nPos2], 0)								//09 - VL_BC_ICMS_I
		aAdd (aRegC575[nPos2], aRegC300[1][16])	   			//10 - ALIQ_ICMS
		aAdd (aRegC575[nPos2], 0)					   			//11 - VL_ICMS_I
	EndIf
	//
	If !("02"==aRegC020[1][6])	//02=Situacao de cancelada
		aRegC575[nPos2][4][1]	+=	aRegC300[1][5][1]	   		//04 - QTD
		aRegC575[nPos2][6]		+=	aRegC300[1][7]				//06 - VL_ITEM
		aRegC575[nPos2][9]		+=	aRegC300[1][15]				//09 - VL_BC_ICMS_I
		aRegC575[nPos2][11]		+=	aRegC300[1][17]				//11 - VL_ICMS_I
	EndIf
Return (lRet)
*/
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RegC580   ³ Autor ³Gustavo G. Rueda                          ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                                               ³±±
±±³          ³C580 - RESUMO MENSAL DOS ITENS DAS NOTAS FISCAIS DE VENDA CONSUMIDOR[MODELO 02)³±±
±±³          ³                                                                               ³±±
±±³          ³- Geracao e gravacao do Registro C580                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves da funcao GrvRegTrb³±±
±±³          ³ com as informacoe contidas no array aRegC300 para o Modelo 02.                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³2(varios por arquivo)                                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³aRegC300 -> Informacoes sobre os itens dos documentos fiscais processados no   ³±±
±±³          ³ while da funcao principal.                                                    ³±±
±±³          ³aRegC580 -> Informacoes sobre o resumo que sera retornado para a funcao princi-³±±
±±³          ³ pal para ser gravado no final da mesma atraves da funcao GrvRegTrb.           ³±±
±±³          ³cSituaDoc -> Situacao do documento fiscal, caso esteja cancelado serah igual 2 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
/*
Static Function RegC580 (aRegC300, aRegC580, cSituaDoc)
	Local	lRet   		:=	.T.
	Local	nPos		:=	0
	//
	If ((nPos := aScan (aRegC580, {|aX| aX[2]==aRegC300[1][3]}))==0)
		aAdd(aRegC580, {})
		nPos	:=	Len (aRegC580)
		aAdd (aRegC580[nPos], "C580")	 	   				//01 - REG
		aAdd (aRegC580[nPos], aRegC300[1][3])				//02 - COD_ITEM
		aAdd (aRegC580[nPos], {0, "VLR3"})					//03 - QTD
		aAdd (aRegC580[nPos], "0")							//04 - QTD_CANC
		aAdd (aRegC580[nPos], aRegC300[1][6])				//05 - UNID
		aAdd (aRegC580[nPos], 0)							//06 - VL_ITEM
		aAdd (aRegC580[nPos], 0)							//07 - VL_DESC_I
		aAdd (aRegC580[nPos], 0)							//08 - VL_BC_ICMS_I
		aAdd (aRegC580[nPos], aRegC300[1][16])				//09 - ALIQ_ICMS
		aAdd (aRegC580[nPos], 0)							//10 - VL_ICMS_I
	EndIf
	//
	aRegC580[nPos][3][1]	+=	aRegC300[1][5][1]							//03 - QTD
	If (cSituaDoc=="02")	//Documento cancelado
		aRegC580[nPos][4]	:=	Alltrim (STR (Val (aRegC580[nPos][4])+1))	//04 - QTD_CANC
	Else
		aRegC580[nPos][6]	+=	aRegC300[1][7]				//06 - VL_ITEM
		aRegC580[nPos][7]	+=	aRegC300[1][8]				//07 - VL_DESC_I
		aRegC580[nPos][8]	+=	aRegC300[1][15]				//08 - VL_BC_ICMS_I
		aRegC580[nPos][10]	+=	aRegC300[1][17]				//10 - VL_ICMS_I
	EndIf
Return (lRet)
*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³E0Reg60   ³ Autor ³Mauro A. Goncalves     ³ Data ³11.10.2012³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³LANCAMENTO - REDUCAO Z/ICMS                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoe contidas no array    ³±±
±±³          ³ aRegE060 para o Modelo 2D.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³VARIOS POR ARQUIVO                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAlias -> Alias do TRB que recebera as informacoes          ³±±
±±³          ³nRelac -> Flag de relacionamento com os sub-registros       ³±±
±±³          ³aRegC020 -> Informacoes sobre todos documentos fiscais pro- ³±±
±±³          ³cessados no while da funcao principal.                      ³±±
±±³          ³nItem -> Contador do item para cada documento fiscal.       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function E060E065 (	cAlias		, nRelac	, aRegC020	, aRegE060	, ;
							aRegE065	, nItem		, aTotalISS	, aTotaliza	, ;
							lISS		, aCmpAntSFT, cSituaDoc	, cAliasSFT	, ;
							cCmpVlAcr	, aRegC300  )
	Local	nPos		:= 0
	Local	nPos2		:= 0
	Local	nI			:= 0
	Local	cNumero		:= ""
	Local	cNumeroPDV	:= ""
	Local	cPDV		:= ""
	Local	cSerPDV		:= ""
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posiciona o registro no SFI³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SFI->(dbSetOrder(1))
	If SFI->(dbSeek(xFilial("SFI") + DtoS(aCmpAntSFT[6]) + aCmpAntSFT[12])) //Data+PDV
		cPDV	:= SFI->FI_PDV
		cSerPDV	:= SFI->FI_SERPDV

		cNumero    := AllTrim(SFI->FI_NUMERO)
		cNumeroPDV := AllTrim(SFI->FI_PDV)

		If ((nPos := aScan (aRegE060, {|aX| aX[3]==cPDV .And. aX[4]==cSerPDV .And. aX[7]==SFI->FI_DTMOVTO}))==0) 
			aAdd(aRegE060, {})
			nPos	:=	Len (aRegE060)
			aAdd(aRegE060[nPos], "E060")								//01 - REG
			aAdd(aRegE060[nPos], "2D")									//02 - COD_MOD
			aAdd(aRegE060[nPos], SFI->FI_PDV)							//03 - ECF_CX
			aAdd(aRegE060[nPos], SFI->FI_SERPDV	)						//04 - ECF_FAB
			aAdd(aRegE060[nPos], SFI->FI_CRO)							//05 - CRO
			aAdd(aRegE060[nPos], SFI->FI_NUMREDZ)						//06 - CRZ
			aAdd(aRegE060[nPos], SFI->FI_DTMOVTO)						//07 - DT_DOC
			aAdd(aRegE060[nPos], SFI->FI_NUMINI)						//08 - DOC_INI
			aAdd(aRegE060[nPos], SFI->FI_NUMFIM)						//09 - DOC_FIM
			aAdd(aRegE060[nPos], SFI->FI_GTINI)							//10 - GT_INI
			aAdd(aRegE060[nPos], SFI->FI_GTFINAL)						//11 - GT_FINAL
			aAdd(aRegE060[nPos], SFI->FI_GTFINAL-SFI->FI_GTINI)			//12 - VL_BRT
			aAdd(aRegE060[nPos], 0)										//13 - VL_CANC_ISSQN
			aAdd(aRegE060[nPos], 0)										//14 - VL_CANC_ICMS
			aAdd(aRegE060[nPos], 0)										//15 - VL_CANC
			aAdd(aRegE060[nPos], 0)										//16 - VL_DESC_ISSQN
			aAdd(aRegE060[nPos], 0)										//17 - VL_DESC_ICMS
			aAdd(aRegE060[nPos], 0)										//18 - VL_DESC
			aAdd(aRegE060[nPos], 0)										//19 - VL_ACMO_ISSQN
			aAdd(aRegE060[nPos], 0)										//20 - VL_ACMO_ICMS
			aAdd(aRegE060[nPos], 0)										//21 - VL_ACMO
			aAdd(aRegE060[nPos], 0)										//22 - VL_ISSQN
			aAdd(aRegE060[nPos], 0)										//23 - VL_LIQ
			aAdd(aRegE060[nPos], 0)										//24 - VL_BC_ICMS
			aAdd(aRegE060[nPos], 0)										//25 - VL_ICMS
			aAdd(aRegE060[nPos], SFI->FI_ISENTO)						//26 - VL_ISEN
			aAdd(aRegE060[nPos], 0)										//27 - VL_NT
			aAdd(aRegE060[nPos], 0)										//28 - VL_ST
			aAdd(aRegE060[nPos], "")									//29 - COD_INF_OBS
			aAdd(aRegE060[nPos], nPos)									//30 - Posicao de Referencia E060
		EndIf
		If (cSituaDoc $ "02#03#04")	//Documento cancelado
			If lIss
				aRegE060[nPos][13] += (cAliasSFT)->FT_VALICM			//13 - VL_CANC_ISSQN
			Else
				aRegE060[nPos][14] += (cAliasSFT)->FT_VALICM			//14 - VL_CANC_ICMS
			EndIf
		Else
			If lIss
				aRegE060[nPos][16]	+= (cAliasSFT)->FT_DESCONT			//16 - VL_DESC_ISSQN
				aRegE060[nPos][19]	+= &(cCmpVlAcr)						//19 - VL_ACMO_ISSQN
				aRegE060[nPos][22]	+= (cAliasSFT)->FT_VALICM			//22 - VL_ISSQN      
				aRegE060[nPos][25]	+= (cAliasSFT)->FT_VALICM			//25 - VL_ICM
			Else
				aRegE060[nPos][17]	+= (cAliasSFT)->FT_DESCONT			//17 - VL_DESC_ICMS 
				aRegE060[nPos][20]	:= &(cCmpVlAcr)						//20 - VL_ACMO_ICMS 
				aRegE060[nPos][25]	+= (cAliasSFT)->FT_VALICM			//25 - VL_ICM
				aRegE060[nPos][27]	+= (cAliasSFT)->FT_OUTRICM			//27 - VL_NT   
				aRegE060[nPos][28]	+= (cAliasSFT)->FT_ICMSRET			//28 - VL_ST   			
			EndIf
			aRegE060[nPos][18]	:= aRegE060[nPos][16] + aRegE060[nPos][17]	//18 - VL_DESC
			aRegE060[nPos][21]	:= aRegE060[nPos][19] + aRegE060[nPos][20]	//21 - VL_ACMO
			aRegE060[nPos][24]	+= (cAliasSFT)->FT_BASEICM		   		//24 - VL_BC_ICMS
		EndIf
		aRegE060[nPos][23]	+= (cAliasSFT)->FT_VALCONT		   			//23 - VL_LIQ
		aRegE060[nPos][15]	:= aRegE060[nPos][13] + aRegE060[nPos][14] //15 - VL_CANC
		//Registro E065
		If ((nPos2 := aScan(aRegE065, {|aX| aX[01]==nPos .And. aX[11]==(cAliasSFT)->FT_ALIQICM}))==0)
			aAdd(aRegE065, {})
			nPos2	:=	Len(aRegE065)
			aAdd(aRegE065[nPos2], nPos)										//01 - RELACIONAMENTO COM O CABECALHO E060
			aAdd(aRegE065[nPos2], "E065")									//02 - REG
			aAdd(aRegE065[nPos2], 0)										//03 - VL_CANC_ISSQN_P
			aAdd(aRegE065[nPos2], 0)										//04 - VL_CANC_ICMS_P
			aAdd(aRegE065[nPos2], 0)										//05 - VL_DESC_ISSQN_P
			aAdd(aRegE065[nPos2], 0)										//06 - VL_DESC_ICMS_P
			aAdd(aRegE065[nPos2], 0)										//07 - VL_ACMO_ISSQN_P
			aAdd(aRegE065[nPos2], 0)										//08 - VL_ACMO_ICMS_P
			aAdd(aRegE065[nPos2], 0)										//09 - VL_ISSQN_P
			aAdd(aRegE065[nPos2], 0)										//10 - VL_BC_ICMS_P
			aAdd(aRegE065[nPos2], (cAliasSFT)->FT_ALIQICM)					//11 - ALIQ_ICMS
			aAdd(aRegE065[nPos2], 0)										//12 - VL_ICMS_P
			aAdd(aRegE065[nPos2], 0)										//13 - VL_ISEN_P
			aAdd(aRegE065[nPos2], 0)										//14 - VL_NT_P
			aAdd(aRegE065[nPos2], 0)										//15 - VL_ST_P
			aAdd(aRegE065[nPos2], nPos)										//16 - RELACIONAMENTO COM O CABECALHO E060
		EndIf
		If (cSituaDoc $ "02#03#04")	//Documento cancelado	
			If lIss
				aRegE065[nPos2][03]	+= (cAliasSFT)->FT_VALICM				//03 - VL_CANC_ISSQN_P
			Else
				aRegE065[nPos2][04]	+= (cAliasSFT)->FT_VALICM				//04 - VL_CANC_ICMS_P
			EndIf
		Else
			If lIss
				aRegE065[nPos2][05]	+= (cAliasSFT)->FT_DESCONT				//05 - VL_DESC_ISSQN_P
				aRegE065[nPos2][07]	+= &(cCmpVlAcr)							//07 - VL_ACMO_ISSQN_P
				aRegE065[nPos2][09]	+= (cAliasSFT)->FT_VALICM				//09 - VL_ISSQN_P 
				aRegE065[nPos2][10]	+= (cAliasSFT)->FT_BASEICM				//10 - VL_BC_ICMS_P     
				aRegE065[nPos2][12]	+= (cAliasSFT)->FT_VALICM				//12 - VL_ICMS_P
			Else
				aRegE065[nPos2][06]	+= (cAliasSFT)->FT_DESCONT				//06 - VL_DESC_ICMS_P		
				aRegE065[nPos2][08]	+= &(cCmpVlAcr)							//08 - VL_ACMO_ICMS_P
				aRegE065[nPos2][10]	+= (cAliasSFT)->FT_BASEICM				//10 - VL_BC_ICMS_P
				aRegE065[nPos2][12]	+= (cAliasSFT)->FT_VALICM				//12 - VL_ICMS_P
				aRegE065[nPos2][13]	+= (cAliasSFT)->FT_ISENICM				//13 - VL_ISEN_P
				aRegE065[nPos2][14]	+= (cAliasSFT)->FT_OUTRICM				//14 - VL_NT_P
				If (cAliasSFT)->FT_ICMSRET > 0
					//No loja eh grava do o vl contabil no campo de ST
					aRegE065[nPos2][15]	+= (cAliasSFT)->FT_ICMSRET			//15 - VL_ST_P				
					//Soma a base de icms pois o loja nao grava base qdo eh ST
				Endif
			EndIf
		EndIf
	EndIf
Return(.T.)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³E080E085  ³ Autor ³Marcio Lopes de Mello  ³ Data ³30.05.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³       LANCAMENTO MAPA RESUMO - ECF/ICM  (MODELO 2D)        ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao e gravacao do Registro E080                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoe contidas no array    ³±±
±±³          ³ aRegE080 para o Modelo 2D.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³VARIOS POR ARQUIVO                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAlias -> Alias do TRB que recebera as informacoes          ³±±
±±³          ³nRelac -> Flag de relacionamento com os sub-registros       ³±±
±±³          ³aRegC020 -> Informacoes sobre todos documentos fiscais pro- ³±±
±±³          ³ cessados no while da funcao principal.                     ³±±
±±³          ³nItem -> Contador do item para cada documento fiscal.       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function E080E085 (	cAlias		, nRelac	, aRegC020	, aRegE080	, ;
							aRegE085	, nItem		, aTotalISS	, aTotaliza	, ;
							lISS		, aCmpAntSFT, cSituaDoc	, cAliasSFT	, ;
							cCmpVlAcr	, aRegC300  )
	Local	lRet		:= .T.
	Local	nPos		:= 0
	Local	nPos2		:= 0
	Local	nI			:= 0
	Local	lPosSFI		:= .F.
	Local	cNumero		:= ""// Numero da Reducao
	Local	cNumeroPDV	:= ""// Numero do PDV

#IFDEF TOP
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posiciona o registro no SFI³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SFI->( dbSetOrder(1) )					// Data					// PDV
	lPosSFI := SFI->(dbSeek(xFilial("SFI") + DtoS(aCmpAntSFT[6]) + aCmpAntSFT[12]))

	cNumero    := AllTrim(SFI->FI_NUMERO)
	cNumeroPDV := AllTrim(SFI->FI_PDV)

	If ((nPos := aScan(aRegE080, {|aX| aX[3]==cNumero+cNumeroPDV .And. dtos(aX[5])==dtos(aCmpAntSFT[6])}))==0)
		If lPosSfi
			aAdd(aRegE080,{})
			nPos	:=	Len (aRegE080)
			aAdd(aRegE080[nPos], "E080")									//01 - REG
			aAdd(aRegE080[nPos], 0)											//02 - IND_MR
			aAdd(aRegE080[nPos], cNumero + cNumeroPDV)						//03 - NUM_MR-ECF
			aAdd(aRegE080[nPos], 0)											//04 - NUM_LCTO
			aAdd(aRegE080[nPos], SFI->FI_DTMOVTO)							//05 - DT_MR_ECF
			aAdd(aRegE080[nPos], SFI->FI_GTFINAL-SFI->FI_GTINI)				//06 - VL_BRT
			aAdd(aRegE080[nPos], 0)											//07 - VL_CANC_ISSQN
			aAdd(aRegE080[nPos], 0)											//08 - VL_CANC_ICMS
			aAdd(aRegE080[nPos], 0)											//09 - VL_CANC
			aAdd(aRegE080[nPos], 0)											//10 - VL_DESC_ISSQN
			aAdd(aRegE080[nPos], 0)											//11 - VL_DESC_ICMS
			aAdd(aRegE080[nPos], 0)											//12 - VL_DESC
			aAdd(aRegE080[nPos], 0)											//13 - VL_ACMO_ISSQN
			aAdd(aRegE080[nPos], 0)											//14 - VL_ACMO_ICMS
			aAdd(aRegE080[nPos], 0)											//15 - VL_ACMO
			aAdd(aRegE080[nPos], 0)											//16 - VL_ISSQN
			aAdd(aRegE080[nPos], 0)											//17 - VL_CONT
			aAdd(aRegE080[nPos], 0)											//18 - VL_BC_ICMS
			For nI:=1 to 30
				cCampo := "SFI->FI_BAS" + Alltrim(Str(nI))
				If SFI->(FieldPos(SUBS( cCampo, 6, Len(cCampo) ) )) > 0
					aRegE080[nPos][18] += &(cCampo)							//18 - VL_BC_ICMS
				EndIf
			Next
			aAdd(aRegE080[nPos], 0)											//19 - VL_ICMS
			aAdd(aRegE080[nPos], 0)											//20 - VL_ISEN
			aAdd(aRegE080[nPos], 0)											//21 - VL_NT
			aAdd(aRegE080[nPos], 0)											//22 - VL_ST
			aAdd(aRegE080[nPos], 0)											//23 - IND_OBS
			aAdd(aRegE080[nPos], nPos)										//24 - Posicao de Referencia E080
		EndIf
	EndIf

	If nPos > 0
		If (cSituaDoc $ "02#03#04")
			If lIss
				aRegE080[nPos][07] += (cAliasSFT)->FT_VALICM			//07 - VL_CANC_ISSQN
			Else
				aRegE080[nPos][08] := (cAliasSFT)->FT_VALICM			//08 - VL_CANC_ICMS
			EndIf
		Else
			If lIss
				aRegE080[nPos][10] += (cAliasSFT)->FT_DESCONT			//10 - VL_DESC_ISSQN
				aRegE080[nPos][13] += &(cCmpVlAcr)						//13 - VL_ACMO_ISSQN
				aRegE080[nPos][16] += (cAliasSFT)->FT_VALICM			//16 - VL_ISSQN
			Else
				aRegE080[nPos][11] += (cAliasSFT)->FT_DESCONT			//11 - VL_DESC_ICMS
				aRegE080[nPos][14] := &(cCmpVlAcr)						//14 - VL_ACMO_ICMS
				aRegE080[nPos][19] += (cAliasSFT)->FT_VALICM			//19 - VL_ICM
				aRegE080[nPos][20] += iif("41"$(cAliasSFT)->FT_CLASFIS,0,(cAliasSFT)->FT_ISENICM)	//20 - VL_ISEN
				aRegE080[nPos][21] += iif("41"$(cAliasSFT)->FT_CLASFIS,SFI->FI_NTRIB,0)			//21 - VL_NT
				aRegE080[nPos][22] += iif((cAliasSFT)->FT_ICMSRET>0, (cAliasSFT)->FT_ICMSRET,iif("60"$(cAliasSFT)->FT_CLASFIS,(cAliasSFT)->FT_VALCONT,0))			//22 - VL_ST
			EndIf
			aRegE080[nPos][12]	:= aRegE080[nPos][10] + aRegE080[nPos][11]	//12 - VL_DESC
			aRegE080[nPos][15]	:= aRegE080[nPos][13] + aRegE080[nPos][14]	//15 - VL_ACMO
		EndIf
		aRegE080[nPos][09]	:= aRegE080[nPos][07] + aRegE080[nPos][08] //09 - VL_CANC

		If ((nPos2 := aScan(aRegE085, {|aX| aX[01]==nPos .And. aX[11]==(cAliasSFT)->FT_CFOP .And. aX[13]==(cAliasSFT)->FT_ALIQICM}))==0)
			aAdd(aRegE085, {})
			nPos2	:=	Len (aRegE085)
			aAdd(aRegE085[nPos2], nPos)									//01 - RELACIONAMENTO COM O CABECALHO E080
			aAdd(aRegE085[nPos2], "E085")								//01 - REG
			aAdd(aRegE085[nPos2], 0)									//02 - VL_CANC_ISSQN_P
			aAdd(aRegE085[nPos2], 0)									//03 - VL_CANC_ICMS_P
			aAdd(aRegE085[nPos2], 0)									//04 - VL_DESC_ISSQN_P
			aAdd(aRegE085[nPos2], 0)									//05 - VL_DESC_ICMS_P
			aAdd(aRegE085[nPos2], 0)									//06 - VL_ACMO_ISSQN_P
			aAdd(aRegE085[nPos2], 0)									//07 - VL_ACMO_ICMS_P
			aAdd(aRegE085[nPos2], 0)									//08 - VL_ISSQN_P
			aAdd(aRegE085[nPos2], 0)									//09 - VL_CONT_P
			aAdd(aRegE085[nPos2], (cAliasSFT)->FT_CFOP)					//10 - CFOP
			aAdd(aRegE085[nPos2], 0)									//11 - VL_BC_ICMS_P
			aAdd(aRegE085[nPos2], (cAliasSFT)->FT_ALIQICM)				//12 - ALIQ_ICMS
			aAdd(aRegE085[nPos2], 0)									//13 - VL_ICMS_P
			aAdd(aRegE085[nPos2], 0)									//14 - VL_ISEN_P
			aAdd(aRegE085[nPos2], 0)									//15 - VL_NT_P
			aAdd(aRegE085[nPos2], 0)									//16 - VL_ST_P
			aAdd(aRegE085[nPos2], nPos)									//18 - RELACIONAMENTO COM O CABECALHO E080
		EndIf
		If nPos2 > 0
			If (cSituaDoc $ "02#03#04")	//Documento cancelado
				If lIss
					aRegE085[nPos2][03] += (cAliasSFT)->FT_TOTAL		//02 - VL_CANC_ISSQN_P
				Else
					aRegE085[nPos2][04] += (cAliasSFT)->FT_TOTAL		//03 - VL_CANC_ICMS_P
				EndIf
			Else
				If lIss
					aRegE085[nPos2][05] += (cAliasSFT)->FT_DESCONT		//04 - VL_DESC_ISSQN_P
					aRegE085[nPos2][07] += &(cCmpVlAcr)					//06 - VL_ACMO_ISSQN_P
					aRegE085[nPos2][09] += (cAliasSFT)->FT_VALICM		//08 - VL_ISSQN_P
				Else
					aRegE085[nPos2][06] += (cAliasSFT)->FT_DESCONT		//05 - VL_DESC_ICMS_P
					aRegE085[nPos2][08] += &(cCmpVlAcr)					//07 - VL_ACMO_ICMS_P
					aRegE085[nPos2][10] += (cAliasSFT)->FT_VALCONT		//09 - VL_CONT_P
					aRegE080[nPos][17]  += (cAliasSFT)->FT_VALCONT		//17  - VL_CONT E080 = soma do Campo 9 do E085
					aRegE085[nPos2][12] += (cAliasSFT)->FT_BASEICM		//11 - VL_BC_ICMS_P
					aRegE085[nPos2][14] += (cAliasSFT)->FT_VALICM		//13 - VL_ICMS_P
					aRegE085[nPos2][15] += iif("41"$(cAliasSFT)->FT_CLASFIS,0,(cAliasSFT)->FT_ISENICM)		//14 - VL_ISEN_
					aRegE085[nPos2][16] += iif("41"$(cAliasSFT)->FT_CLASFIS,(cAliasSFT)->FT_OUTRICM,0)		//15 - VL_NT_P
					aRegE085[nPos2][17] += iif((cAliasSFT)->FT_ICMSRET>0, (cAliasSFT)->FT_ICMSRET,iif("60"$(cAliasSFT)->FT_CLASFIS,(cAliasSFT)->FT_VALCONT,0))	//16 - VL_ST_P
				EndIf
			EndIf
		EndIf
	EndIf
#ENDIF
Return(lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RegC600   ³ Autor ³Marcio Lopes de Mello  ³ Data ³21.03.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³       NOTA FISCAL DE VENDA A CONSUMIDOR (MODELO 02)        ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao e gravacao do Registro C600                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoe contidas no array    ³±±
±±³          ³ aRegC020 para o Modelo 02.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³2(Varios por arquivo)                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAlias -> Alias do TRB que recebera as informacoes          ³±±
±±³          ³nRelac -> Flag de relacionamento com os sub-registros       ³±±
±±³          ³aRegC020 -> Informacoes sobre todos documentos fiscais pro- ³±±
±±³          ³ cessados no while da funcao principal.                     ³±±
±±³          ³nItem -> Contador do item para cada documento fiscal.       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/  
Static Function RegC600 (	cAlias		, nRelac	  , aRegC020	, aRegC600	, ;
							nItem		, aTotalISS	  , aTotaliza	, lISS		, ;
     						aCmpAntSFT	, cSituaDoc   , cEspecie	, aPartDoc	, ;
 							aReg02Aux	,dDataDe	  , dDataAte	,cFilDe		, ;
							cFilAte		,aRegC600Veri , cAliasSFT )
Local	lRet   		:=	.T.
Local	nPos		:=	0
Local 	lPosSFI		:= .F.
Local   cCGC_CPf    :=  If(!Empty(AllTrim(aPartDoc[4])),aPartDoc[4],aPartDoc[5])    
Local   lVer600     := .T.   
Local   aAliasSFT   := {aCmpAntSFT[20],aCmpAntSFT[1],aCmpAntSFT[2] } 


	SFI->( DbSetOrder(1) )             			// Data					// PDV
	lPosSFI := SFI->( dbSeek( xFilial("SFI") + DtoS(aCmpAntSFT[6]) + aCmpAntSFT[12] ) )   
	
	lVer600 := Reg600VlPrd("L",@aReg02Aux,dDataDe,dDataAte,aAliasSFT,cFilDe,cFilAte)     	
	//
	If ((nPos2 := aScan (aRegC600, {|aX| aX[5]==SFI->FI_SERPDV .And. aX[6]==SFI->FI_CRO .AND. aX[7]==SFI->FI_NUMREDZ .AND. ;
	     aX[8]==aRegC020[1][8] .AND. aX[9]==aRegC020[1][9] }))==0) .AND. aRegc600Veri[1]     
	                
		aAdd(aRegC600, {})
		nPos	:=	Len (aRegC600)
		aAdd (aRegC600[nPos], "C600")	 	   						//01 - REG
		aAdd (aRegC600[nPos], If(lVer600 ,aPartDoc[5],"")  ) 		//02 - CPF
		aAdd (aRegC600[nPos], If(lVer600 ,aPartDoc[4],"")	)		//03 - CNPJ
		aAdd (aRegC600[nPos], cEspecie)	 							//04 - COD_MOD
		aAdd (aRegC600[nPos], cSituaDoc)	 						//05 - COD_SIT
		aAdd (aRegC600[nPos], aCmpAntSFT[12])	 					//06 - ECF_CX
		aAdd (aRegC600[nPos], SFI->FI_SERPDV	)	 				//07 - ECF_FAB
		aAdd (aRegC600[nPos], SFI->FI_CRO	 	)	 				//08 - CRO
		aAdd (aRegC600[nPos], SFI->FI_NUMREDZ  )	 				//09 - CRZ
		aAdd (aRegC600[nPos], aCmpAntSFT[1])	 					//10 - NUM_DOC
		aAdd (aRegC600[nPos], aCmpAntSFT[6])	 					//11 - DT_DOC
		aAdd (aRegC600[nPos], aTotaliza[1])					 		//12 - VL_DOC
		If cSituaDoc $ "02#03#04"
			aAdd (aRegC600[nPos], 0 )								//13 - VL_CANC_ISSQN
			aAdd (aRegC600[nPos], 0)						   		//14 - VL_CANC_ICMS
			aAdd (aRegC600[nPos], aTotaliza[3] )					//15 - VL_CANC
		Else
			aAdd (aRegC600[nPos], 0)								//13 - VL_CANC_ISSQN
			aAdd (aRegC600[nPos], 0)								//14 - VL_CANC_ICMS
			aAdd (aRegC600[nPos], 0)								//15 - VL_CANC
		EndIf
		aAdd (aRegC600[nPos], 0 )							  		//16 - VL_DESC_ISSQN
		aAdd (aRegC600[nPos], aTotaliza[9] )				 		//17 - VL_DESC_ICMS
		aAdd (aRegC600[nPos], aTotaliza[9] )						//18 - VL_DESC
		aAdd (aRegC600[nPos], 0 )									//19 - VL_ACMO_ISSQN
		aAdd (aRegC600[nPos], aTotaliza[19])						//20 - VL_ACMO_ICMS
		aAdd (aRegC600[nPos], 0 )									//21 - VL_ACMO
		aAdd (aRegC600[nPos], 0 )									//22 - VL_ISSQN
		aAdd (aRegC600[nPos], aTotaliza[2])	 			   			//23 - VL_BC_ICMS
		aAdd (aRegC600[nPos], aTotaliza[3])	 			  			//24 - VL_ICMS
		aAdd (aRegC600[nPos], aTotaliza[7])				   			//25 - VL_ISEN
		aAdd (aRegC600[nPos], SFI->FI_NTRIB)						//26 - VL_NT
		aAdd (aRegC600[nPos], aTotaliza[20])						//27 - VL_ST
		If lBloqCD		
			GrvRegTrb (cAlias, nRelac, aRegC600, nItem)  
		endif	
		aRegc600Veri[1] := .F.
	EndIf
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RegC605   ³ Autor ³Marcio Lopes de Mello  ³ Data ³21.03.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³              ITENS DO DOCUMENTO (MODELO 02)                ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao e gravacao do Registro C555                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoe contidas no array    ³±±
±±³          ³ aRegC300 para o Modelo 02.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³3(1:N) Para cada C605                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAlias -> Alias do TRB que recebera as informacoes          ³±±
±±³          ³nRelac -> Flag de relacionamento com os sub-registros       ³±±
±±³          ³aRegC300 -> Informacoes sobre os itens dos documentos fis-  ³±±
±±³          ³ cais processados no while da funcao principal.             ³±±
±±³          ³nItem -> Contador do item para cada documento fiscal.       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RegC605 (	cAlias		, nRelac	, aRegC300	  , nItem		, ;
							lISS		, aRegC605	, cSituaDoc	  , cCmpVlAcr	, ;
							cAliasSFT	, cClasFis	,aRegC600Veri , dDataDe		, ;
							dDataAte	, cFilDe	,cFilAte      , aReg02Aux   , ;
							cCmpUm)
	Local lRet      := .T.
	Local nPos      := 0
	Local nPosC300  := 1
	Local cSitTrib  := LjSitTrib("SD2") // Retorna a situacao tributaria
	Local cAuxAlias := (cAliasSFT)->FT_FILIAL +(cAliasSFT)->FT_NFISCAL +(cAliasSFT)->FT_SERIE
	Local cCliente  := ""
	Local lSpdv     := .T.
	Local aAliasSFT := {(cAliasSFT)->FT_FILIAL,(cAliasSFT)->FT_NFISCAL,(cAliasSFT)->FT_SERIE }

	If !lIss
		If lBloqCD
			Reg0200()
		EndIf
	EndIf

	//
	SFI->( DbSetOrder(1) )
	If SFI->( DbSeek( xFilial("SFI") + DtoS((cAliasSFT)->FT_ENTRADA) + (cAliasSFT)->FT_PDV ) )
		lSpdv := If (Empty(AllTrim(SFI->FI_SERPDV)),.F.,.T. )
	EndIf
	If (cAliasSFT)->FT_TIPO <> "S" .AND. lSpdv

		If aRegC600Veri[2] <>  cAuxAlias
			aRegC600Veri[2] := cAuxAlias
			aRegC600Veri[3] := "1"
		Else
			aRegC600Veri[3] := AllTrim(Str(Val(aRegC600Veri[3])+1))
		EndIf
		aAdd(aRegC605, {})
		nPos	:=	Len (aRegC605)
		aAdd (aRegC605[nPos], "C605")									//01 - REG
		aAdd (aRegC605[nPos], aRegC600Veri[3])							//02 - NUM_ITEM
		aAdd (aRegC605[nPos], (cAliasSFT)->FT_PRODUTO)					//aRegC300[nPosC300][3])			//03 - COD_ITEM
		aAdd (aRegC605[nPos], {(cAliasSFT)->FT_PRCUNIT, "VLR3"})		//aRegC300[nPosC300][4])			//04 - VL_UNIT
		aAdd (aRegC605[nPos], {(cAliasSFT)->FT_QUANT  , "VLR3"})		//aRegC300[nPosC300][5])			//05 - QTD 
		If cSituaDoc $ "02#03#04"
			aAdd (aRegC605[nPos], {(cAliasSFT)->FT_QUANT  , "VLR3"})	//aRegC300[nPosC300][5])		//06 - QTD_CANC_I
		Else
			aAdd (aRegC605[nPos], 0)							//06 - QTD_CANC_I
		EndIf
		aAdd (aRegC605[nPos], &(cCmpUm))								//aRegC300[nPosC300][6])			//07 - UNID
		aAdd (aRegC605[nPos], (cAliasSFT)->FT_TOTAL)					//aRegC300[nPosC300][7])			//08 - VL_ITEM
		aAdd (aRegC605[nPos], (cAliasSFT)->FT_DESCONT)					//aRegC300[nPosC300][8])			//09 - VL_DESC_I
		If cSituaDoc $ "02#03#04"
			aAdd (aRegC605[nPos], {(cAliasSFT)->FT_PRCUNIT, "VLR3"})	//aRegC300[nPosC300][4])		//10 - VL_CANC_I
		Else
			aAdd (aRegC605[nPos], 0)							//10 - VL_CANC_I
		EndIf
		aAdd (aRegC605[nPos], &(cCmpVlAcr))						//11 - VL_ACMO_I
		If lISS
			aAdd (aRegC605[nPos], (cAliasSFT)->FT_VALICM)				//aRegC300[nPosC300][17])		//12 - VL_ISSQN_I
		Else
			aAdd (aRegC605[nPos], 0)							//12 - VL_ISSQN_I
		EndIf
		aAdd (aRegC605[nPos], cClasFis)							//13 - CST
		aAdd (aRegC605[nPos], (cAliasSFT)->FT_CFOP)						//aRegC300[nPosC300][14])			//14 - CFOP
		aAdd (aRegC605[nPos], (cAliasSFT)->FT_BASEICM)					//aRegC300[nPosC300][15])			//15 - VL_BC_ICMS_I
		aAdd (aRegC605[nPos], (cAliasSFT)->FT_ALIQICM)					//aRegC300[nPosC300][16])			//16 - ALIQ_ICMS
		If !lISS
			aAdd (aRegC605[nPos], (cAliasSFT)->FT_VALICM)				//aRegC300[nPosC300][17])		//17 - VL_ICMS_I
		Else
			aAdd (aRegC605[nPos], 0)							//17 - VL_ICMS_I
		EndIf
		
		aAdd (aRegC605[nPos], 0)								//18 - VL_ISEN_I
		aAdd (aRegC605[nPos], 0)								//19 - VL_NT_I
		aAdd (aRegC605[nPos], 0)								//20 - VL_ST_I
		
		SD2->(dbSeek(xFilial("SD2") + (cAliasSFT)->FT_NFISCAL + (cAliasSFT)->FT_SERIE + (cAliasSFT)->FT_CLIEFOR + ;
					(cAliasSFT)->FT_LOJA + (cAliasSFT)->FT_PRODUTO + (cAliasSFT)->FT_ITEM))
		If LjSitTrib("SD2") == "F"
			aRegC605[nPos][20] :=  SFT->FT_ICMSRET				//20 - VL_ST_I
		EndIf
		If lBloqCD
			GrvRegTrb (cAlias, nRelac, aRegC605, nItem) 
		endif
		aRegc600Veri[1] := .T.
	EndIf
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³C620C625  ³ Autor ³Marcio Lopes de Mello             ³ Data ³21.03.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                                       ³±±
±±³          ³C620 - RESUMO DIARIO DAS NOTAS FISCAIS DE VENDA A CONSUMIDOR(MODELO 02)³±±
±±³          ³       C575 - ITENS DO RESUMO DIARIO DOS DOCUMENTOS(MODELO 02)         ³±±
±±³          ³                                                                       ³±±
±±³          ³- Geracao e gravacao do Registro C570 e C575                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves da funcao  ³±±
±±³          ³ GrvRegTrb com as informacoe contidas no array aRegC020(Cabecalho) e   ³±±
±±³          ³ aRegC300(Itens) para o Modelo 02.                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³C620 - 2(varios por arquivo)                                           ³±±
±±³          ³C625 - 3(1:N) Para cada C620                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³aRegC020 -> Informacoes sobre todos documentos fiscais processados no  ³±±
±±³          ³ while da funcao principal.                                            ³±±
±±³          ³aRegC300 -> Informacoes sobre os itens dos documentos fiscais proces-  ³±±
±±³          ³ sados no while da funcao principal.                                   ³±±
±±³          ³aRegC620 -> Informacoes sobre o cabecalho dos documentos fiscais proces-³±±
±±³          ³ sados no while da funcao principal.                                   ³±±
±±³          ³aRegC625 -> Informacoes sobre os itens dos documentos fiscais proces-  ³±±
±±³          ³ sados no while da funcao principal.                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
/*
Static Function C620C625 (	aRegC020	, aRegC300	, aRegC620	, aRegC625	, ;
							aTotalISS	, aTotaliza	, lISS		, aCmpAntSFT, ;
							aRegC605	, cAliasSFT)
	Local	lRet	:=	.T.
	Local	nPos	:=	0
	Local	nPos2	:=	0
	Local 	nI		:= 	0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³REGISTRO C620 - RESUMO DIARIO DAS NOTAS FISCAIS DE VENDA A CONSUMIDOR(MODELO 2D)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ((nPos := aScan (aRegC620, {|aX| aX[3]==SFI->FI_PDV .And. aX[9]==aCmpAntSFT[6]}))==0)
		aAdd(aRegC620, {})
		nPos	:=	Len (aRegC620)
		aAdd (aRegC620[nPos], "C620")	 	   			//01 - REG
		aAdd (aRegC620[nPos], aRegC020[1][5])			//02 - COD_MOD
		SFI->( dbSetOrder(1) )
		If SFI->( dbSeek( xFilial("SFI") + DtoS(aCmpAntSFT[6]) + aCmpAntSFT[12] ) )
			aAdd (aRegC620[nPos], SFI->FI_PDV	   )	//03 - ECF_CX
			aAdd (aRegC620[nPos], SFI->FI_SERPDV  )		//04 - ECF_FAB
			aAdd (aRegC620[nPos], SFI->FI_CRO     )  	//05 - CRO
			aAdd (aRegC620[nPos], SFI->FI_NUMREDZ )		//06 - CRZ
			aAdd (aRegC620[nPos], SFI->FI_NUMINI  )		//07 - NUM_DOC_INI
			aAdd (aRegC620[nPos], SFI->FI_NUMFIM  )		//08 - NUM_DOC_FIN
			aAdd (aRegC620[nPos], SFI->FI_DTMOVTO )		//09 - DT_DOC
		Else
			aAdd (aRegC620[nPos], "0"				)	//03 - ECF_CX
			aAdd (aRegC620[nPos], 0 				)	//04 - ECF_FAB
			aAdd (aRegC620[nPos], 0					)  	//05 - CRO
			aAdd (aRegC620[nPos], 0 				)	//06 - CRZ
			aAdd (aRegC620[nPos], 0  				)	//07 - NUM_DOC_INI
			aAdd (aRegC620[nPos], 0  				)	//08 - NUM_DOC_FIN
			aAdd (aRegC620[nPos], CtoD("__/__/__")	)	//09 - DT_DOC
		EndIf
		aAdd (aRegC620[nPos], 0  					)	//10 - QTD_CANC
		aAdd (aRegC620[nPos], SFI->FI_VALCON)								//11 - VL_DOC
		aAdd (aRegC620[nPos], SFI->FI_CANCEL)								//12 - VL_CANC_ICMS
		aAdd (aRegC620[nPos], SFI->FI_CANCEL)								//13 - VL_CANC
		aAdd (aRegC620[nPos], SFI->FI_DESC)									//14 - VL_DESC_ICMS
		aAdd (aRegC620[nPos], SFI->FI_DESC)									//15 - VL_DESC_ICMS
		aAdd (aRegC620[nPos], 0)											//16 - VL_ACMO_ICMS
		aAdd (aRegC620[nPos], 0)											//17 - VL_ACMO
		aAdd (aRegC620[nPos], 0)	 										//18 - VL_BC_ICMS
		For nI:=1 to 9999
			cCampo := "SFI->FI_BAS" + Alltrim(Str(nI))
			If SFI->(FieldPos(SUBS( cCampo, 6, Len(cCampo) ) )) > 0
				aRegC620[nPos][18] += &(cCampo)	 						//18 - VL_BC_ICMS
			EndIf
		Next
		aAdd (aRegC620[nPos], SFI->FI_IMPDEBT)	 							//19 - VL_ICMS
		aAdd (aRegC620[nPos], SFI->FI_ISENTO )								//20 - VL_ISEN

		aAdd (aRegC620[nPos], SFI->FI_NTRIB )								//21 - VL_ISEN
		aAdd (aRegC620[nPos], SFI->FI_SUBTRIB )								//22 - VL_ISEN
	EndIf
	If ("02"==aRegC020[1][6])	//02=Situacao de cancelada
		aRegC620[nPos][10]	:=	STR (Val (aRegC620[nPos][10]) + 1)		//10 - QTD_CANC
	EndIf


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³REGISTRO C625 - ITENS DO RESUMO DIARIO DOS DOCUMENTOS(MODELO 2D)                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ((nPos2 := aScan (aRegC625, {|aX| aX[1]==nPos .And. aX[3]==aRegC300[1][3] .And. aX[6]==aRegC300[1][6]}))==0)
		aAdd(aRegC625, {})
		nPos2	:=	Len (aRegC625)
		aAdd (aRegC625[nPos2], nPos)	 	   							//00 - RELACIONAMENTO COM O CABECALHO C625
		aAdd (aRegC625[nPos2], "C625")	 	   							//01 - REG
		aAdd (aRegC625[nPos2], aRegC300[1][3])							//02 - COD_ITEM
		
		aAdd (aRegC625[nPos2], {0, "VLR3"})							//03 - QTD
		aRegC625[nPos2][04][01] += aRegC300[1][5][1]					//03 - QTD
		
		aAdd (aRegC625[nPos2], 0)										//04 - QTD_CANC_I
		aAdd (aRegC625[nPos2], aRegC300[1][6])							//05 - UNID
		aAdd (aRegC625[nPos2], aRegC300[1][7])							//06 - VL_ITEM
		aAdd (aRegC625[nPos2], aRegC300[1][8])							//07 - VL_DESC_I
		aAdd (aRegC625[nPos2], 0)										//08 - VL_CANC_I
		aAdd (aRegC625[nPos2], aRegC605[1][11])						//09 - VL_ACMO_I
		aAdd (aRegC625[nPos2], 0)										//10 - VL_BC_ICMS_I
		aAdd (aRegC625[nPos2], 0)										//11 - ALIQ_ICMS
		aAdd (aRegC625[nPos2], 0)										//12 - VL_ICMS_I
		aAdd (aRegC625[nPos2], 0)										//13 - VL_ISEN_I
		aAdd (aRegC625[nPos2], 0)										//14 - VL_NT_I
		aAdd (aRegC625[nPos2], 0)										//15 - VL_ST_I
		
		If !("02"==aRegC020[1][6])	//02=Situacao de cancelada
			aRegC625[nPos2][11]	:= aCmpAntSFT[13]						//10 - VL_BC_ICMS_I
			aRegC625[nPos2][12]	:= aCmpAntSFT[14]						//11 - ALIQ_ICMS
			aRegC625[nPos2][13]	:= aCmpAntSFT[15]						//12 - VL_ICMS_I
			aRegC625[nPos2][14]	:= aCmpAntSFT[16]						//13 - VL_ISEN_I
			aRegC625[nPos2][15]	:= aCmpAntSFT[17]						//14 - VL_NT_I
			aRegC625[nPos2][16]	:= aCmpAntSFT[18]						//15 - VL_ST_I
		Else
			aRegC625[nPos2][05]	:= aRegC300[1][5][1]					//04 - QTD_CANC_I
			aRegC625[nPos2][09] := aRegC300[1][7]						//08 - VL_CANC_I
		EndIf
	Else
		aRegC625[nPos2][04][01] += aRegC300[1][5][1]					//03 - QTD
		If !("02"==aRegC020[1][6])	//02=Situacao de cancelada
			aRegC625[nPos2][07]	+= aRegC300[1][7]						//06 - VL_ITEM
			aRegC625[nPos2][08]	+= aRegC300[1][8]						//07 - VL_DESC_I
			aRegC625[nPos2][10]	+= aRegC605[1][11]						//09 - VL_ACMO_I
			
			aRegC625[nPos2][11]	+= aCmpAntSFT[13]						//10 - VL_BC_ICMS_I
			aRegC625[nPos2][13]	+= aCmpAntSFT[15]						//12 - VL_ICMS_I
			aRegC625[nPos2][14]	+= aCmpAntSFT[16]						//13 - VL_ISEN_I
			aRegC625[nPos2][15]	+= aCmpAntSFT[17]						//14 - VL_NT_I
			aRegC625[nPos2][16]	+= aCmpAntSFT[18]						//15 - VL_ST_I
		Else               
			aRegC625[nPos2][05]	+= Str(aRegC300[1][5][1], 12, 3)		//04 - QTD_CANC_I
			aRegC625[nPos2][09]	+= aRegC300[1][7]						//08 - VL_CANC_I
		EndIf
	EndIf
Return (lRet)
*/
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RegC640   ³ Autor ³Marcio Lopes de Mello                     ³ Data ³21.03.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                                               ³±±
±±³          ³C640 - RESUMO MENSAL DOS ITENS DAS NOTAS FISCAIS DE VENDA CONSUMIDOR[MODELO 2D)³±±
±±³          ³                                                                               ³±±
±±³          ³- Geracao e gravacao do Registro C640                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves da funcao GrvRegTrb³±±
±±³          ³ com as informacoe contidas no array aRegC300 para o Modelo 02.                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³2(varios por arquivo)                                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³aRegC300 -> Informacoes sobre os itens dos documentos fiscais processados no   ³±±
±±³          ³ while da funcao principal.                                                    ³±±
±±³          ³aRegC640 -> Informacoes sobre o resumo que sera retornado para a funcao princi-³±±
±±³          ³ pal para ser gravado no final da mesma atraves da funcao GrvRegTrb.           ³±±
±±³          ³cSituaDoc -> Situacao do documento fiscal, caso esteja cancelado serah igual 2 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
/*
Static Function RegC640 (	aRegC300, aRegC640, cSituaDoc, aRegC605, ;
							aCmpAntSFT)
	Local	lRet   		:=	.T.
	Local	nPos		:=	0
	//
	If ((nPos := aScan (aRegC640, {|aX| aX[2]==aRegC300[1][3]}))==0)
		aAdd(aRegC640, {})
		nPos	:=	Len (aRegC640)
		aAdd (aRegC640[nPos], "C640")	 	   				//01 - REG
		aAdd (aRegC640[nPos], aRegC300[1][3])				//02 - COD_ITEM
		aAdd (aRegC640[nPos], {0, "VLR3"})					//03 - QTD
		aAdd (aRegC640[nPos], 0)							//04 - QTD_CANC_I
		aAdd (aRegC640[nPos], aRegC300[1][6])				//05 - UNID
		aAdd (aRegC640[nPos], 0)							//06 - VL_ITEM
		aAdd (aRegC640[nPos], 0)							//07 - VL_DESC_I
		aAdd (aRegC640[nPos], 0)							//08 - VL_CANC_I
		aAdd (aRegC640[nPos], 0)							//09 - VL_ACMO_I
		aAdd (aRegC640[nPos], 0)							//10 - VL_BC_ICMS_I
		aAdd (aRegC640[nPos], aRegC300[1][16])				//11 - ALIQ_ICMS
		aAdd (aRegC640[nPos], 0)							//12 - VL_ICMS_I
		aAdd (aRegC640[nPos], 0)							//13 - VL_ISEN_I
		aAdd (aRegC640[nPos], 0)							//14 - VL_NT_I
		aAdd (aRegC640[nPos], 0)							//15 - VL_ST_I
		
	EndIf
	aRegC640[nPos][3][1]	+=	aRegC300[1][5][1]							//03 - QTD
	If (cSituaDoc=="02")	//Documento cancelado
		aRegC640[nPos][4]	:=	Alltrim (STR (Val (aRegC640[nPos][4])+1))	//04 - QTD_CANC
		aRegC640[nPos][8]	+=	aRegC300[1][7]								//08 - VL_CANC_I
	Else
		aRegC640[nPos][6]	+=	aRegC300[1][7]				//06 - VL_ITEM
		aRegC640[nPos][7]	+=	aRegC300[1][8]				//07 - VL_DESC_I
		aRegC640[nPos][9]	+=	aRegC605[1][11]				//09 - VL_ACMO_I
		aRegC640[nPos][10]	+=	aRegC300[1][15]				//10 - VL_BC_ICMS_I
		aRegC640[nPos][12]	+=	aRegC300[1][17]				//12 - VL_ICMS_I
		aRegC640[nPos][13]	+=	aRegC605[1][18]				//13 - VL_ISEN_I
	EndIf
	aRegC640[nPos][14]		+= aCmpAntSFT[17]					//14 - VL_NT_I
	aRegC640[nPos][15] 		+= aCmpAntSFT[18]					//15 - VL_ST_I
Return (lRet)
*/
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RegC700   ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³     NOTA FISCAL CONTA DE ENERGIA ELETRICA (MODELO 06)      ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao e gravacao do Registro C700                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoe contidas no array    ³±±
±±³          ³ aRegC020 para o Modelo 06.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³2(varios por arquivo)                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAlias -> Alias do TRB que recebera as informacoes          ³±±
±±³          ³nRelac -> Flag de relacionamento com os sub-registros       ³±±
±±³          |aRegC020 -> Informacoes sobre todos documentos fiscais pro- ³±±
±±³          ³ cessados no while da funcao principal.                     ³±±
±±³          ³aTotaliza -> Totalizadores de valores para a tabela SFT.    ³±±
±±³          ³aRegC700 -> Conteudo gravado do registro C700 para utiliza- ³±±
±±³          ³ cao em outros registros da funcao principal.               ³±±
±±³          ³nItem -> Contador do item para cada documento fiscal.       ³±±
±±³          ³lAchouSFU -> Flag de localizacao do SFU para o NF em proces-³±±
±±³          ³ samento.                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RegC700 (cAlias, nRelac, aRegC020, aTotaliza, aRegC700, nItem, lAchouSFU)
	Local	lRet := .T.
	Local	nPos := 0
	//
	aAdd(aRegC700, {})
	nPos	:=	Len (aRegC700)
	aAdd (aRegC700[nPos], "C700")	 	   							//01 - REG
	aAdd (aRegC700[nPos], aRegC020[1][2])	   						//02 - IND_OPER
	aAdd (aRegC700[nPos], aRegC020[1][3])	   						//03 - IND_EMIT
	aAdd (aRegC700[nPos], aRegC020[1][4])	   						//04 - COD_PART
	aAdd (aRegC700[nPos], aRegC020[1][5])	   						//05 - COD_MOD
	aAdd (aRegC700[nPos], aRegC020[1][6])	   						//06 - COD_SIT
	aAdd (aRegC700[nPos], aRegC020[1][7])	   						//07 - SER
	aAdd (aRegC700[nPos], "")	   									//08 - SUB
	aAdd (aRegC700[nPos], IIF(lAchouSFU .AND. SFU->(FieldPos("FU_CLASCON"))>0 .And. !Empty(SFU->FU_CLASCON),SFU->FU_CLASCON,"99") )		//09 - COD_CONS
	aAdd (aRegC700[nPos], aRegC020[1][8])	   						//10 - NUM_DOC
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Por exigencia do GDF, a data da entrada nao pode ser maior que a data da emissao,³
	//³por isso eh repetida a mesma data nos campos 11 e 12                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aAdd (aRegC700[nPos], aRegC020[1][9])	   						//11 - DT_DOC
	aAdd (aRegC700[nPos], aRegC020[1][9])	   						//12 - DT_E_S
	aAdd (aRegC700[nPos], aRegC020[1][11])	   						//13 - COD_NAT
	aAdd (aRegC700[nPos], aRegC020[1][12])	   						//14 - VL_DOC
	aAdd (aRegC700[nPos], aRegC020[1][14])	   						//15 - VL_DESC
	aAdd (aRegC700[nPos], aRegC020[1][15])	   						//16 - VL_FORN
	aAdd (aRegC700[nPos], aTotaliza[7])  							//17 - VL_SERV_NT
	aAdd (aRegC700[nPos], 0)	   		  							//18 - VL_TERC
	aAdd (aRegC700[nPos], aRegC020[1][19])	   						//19 - VL_DA
	aAdd (aRegC700[nPos], aRegC020[1][20])	   						//20 - VL_BC_ICMS
	aAdd (aRegC700[nPos], aRegC020[1][21])	   						//21 - VL_ICMS
	aAdd (aRegC700[nPos], aRegC020[1][25])	   						//22 - REF_INF_OBS
	//
	If lBloqCD
		GrvRegTrb (cAlias, nRelac, aRegC700, nItem)
	endif
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RegC705   ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³       IDENTIFICACAO DO PONTO DE CONSUMO (MODELO 06)        ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao e gravacao do Registro C705                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoe contidas na tabela   ³±±
±±³          ³ SFU.                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³3(1:1)Para cada C700                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAlias -> Alias do TRB que recebera as informacoes          ³±±
±±³          ³nRelac -> Flag de relacionamento com os sub-registros       ³±±
±±³          ³nItem -> Contador do item para cada documento fiscal.       ³±±
±±³          ³lAchouSFU -> Flag de localizacao do SFU para o NF em proces-³±±
±±³          ³ samento.                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RegC705 (cAlias, nRelac, nItem, lAchouSFU)
	Local	lRet := .T.
	Local	nPos := 0
	Local	aReg := {}
	//
	If (lAchouSFU)
		aAdd(aReg, {})
		nPos := Len(aReg)
		aAdd (aReg[nPos], "C705")													//01 - REG
		aAdd (aReg[nPos], IIF(SFU->(FieldPos("FU_CODUNC" ))>0,SFU->FU_CODUNC ,""))	//02 - COD_UNC
		aAdd (aReg[nPos], IIF(SFU->(FieldPos("FU_TIPLIGA"))>0,SFU->FU_TIPLIGA,""))	//03 - IND_LIG
		aAdd (aReg[nPos], IIF(SFU->(FieldPos("FU_GRUPT"  ))>0,SFU->FU_GRUPT  ,""))	//04 - IND_KV
		aAdd (aReg[nPos], IIF(SFU->(FieldPos("FU_PERFIS" ))>0,SFU->FU_PERFIS ,""))	//05 - PER_FISCAL
		aAdd (aReg[nPos], IIF(SFU->(FieldPos("FU_DTINI"  ))>0,SFU->FU_DTINI  ,""))	//06 - DT_INI_CONS
		aAdd (aReg[nPos], IIF(SFU->(FieldPos("FU_DTFIM"  ))>0,SFU->FU_DTFIM  ,""))	//07 - DT_FIN_CONS
		aAdd (aReg[nPos], IIF(SFU->(FieldPos("FU_DTLEIT" ))>0,SFU->FU_DTLEIT ,""))	//08 - DT_LEIT
		aAdd (aReg[nPos], IIF(SFU->(FieldPos("FU_DEMCT"  ))>0,SFU->FU_DEMCT  ,""))	//09 - DEM_PTA
		aAdd (aReg[nPos], IIF(SFU->(FieldPos("FU_DEMCTP" ))>0,SFU->FU_DEMCTP ,""))	//10 - DEM_FPTA
		aAdd (aReg[nPos], IIF(SFU->(FieldPos("FU_CONSTOT"))>0,SFU->FU_CONSTOT,""))	//11 - CONS
		//
		If lBloqCD
			GrvRegTrb (cAlias, nRelac, aReg, nItem)
		endif
	EndIf
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RegC750   ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³               ITENS DO DOCUMENTO (MODELO 06)               ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao e gravacao do Registro C750                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoe contidas no array    ³±±
±±³          ³ aRegC300 para o Modelo 06.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³3(1:N) Para cada C700                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAlias -> Alias do TRB que recebera as informacoes          ³±±
±±³          ³nRelac -> Flag de relacionamento com os sub-registros       ³±±
±±³          |aRegC300 -> Informacoes sobre os itens dos documentos fiscais³±±
±±³          ³  processados no while da funcao principal.                 ³±±
±±³          ³aPartDoc -> Array com informacoes sobre o participante do   ³±±
±±³          ³ documento fiscal, este array eh montado pela funcao principal³±±
±±³          ³aRegC750 -> Conteudo gravado do registro C750 para utiliza- ³±±
±±³          ³ cao em outros registros da funcao principal.               ³±±
±±³          ³nItem -> Contador do item para cada documento fiscal.       ³±±
±±³          ³lAchouSB5 -> Flag de posicionamento da tabela SB5 para o item³±±
±±³          ³ em processamento.                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RegC750 (cAlias, nRelac, aRegC300, aPartDoc, aRegC750, nItem, lAchouSFU, cEntSai, cAliasSFT, nItem, cClasFis, cCmpUm)
	Local	lRet	:= .T.
	Local	nPos	:= 0
	Local	aRegAux	:= {}
	//
	aAdd(aRegC750, {})
	nPos := Len(aRegC750)
	aAdd (aRegC750[nPos], "C750")					//01 - REG
	aAdd (aRegC750[nPos], AllTrim (STR (nItem)))					//aRegC300[1][2])			//02 - NUM_ITEM
	aAdd (aRegC750[nPos], (cAliasSFT)->FT_PRODUTO) 					//aRegC300[1][3])			//03 - COD_ITEM
	aAdd (aRegC750[nPos], IIF(lAchouSFU .AND. SFU->(FieldPos("FU_CLASSIT"))>0 .AND. !Empty(SFU->FU_CLASSIT),SFU->FU_CLASSIT,"00"))	//04 - COD_CLASS
	aAdd (aRegC750[nPos], {(cAliasSFT)->FT_PRCUNIT, "VLR3"})		//aRegC300[1][4])			//05 - VL_UNIT
	aAdd (aRegC750[nPos], {(cAliasSFT)->FT_QUANT  , "VLR3"})		//aRegC300[1][5])			//06 - QTD
	aAdd (aRegC750[nPos], &(cCmpUm))								//aRegC300[1][6])			//07 - UNID
	aAdd (aRegC750[nPos], (cAliasSFT)->FT_TOTAL)					//aRegC300[1][7])			//08 - VL_ITEM
	aAdd (aRegC750[nPos], (cAliasSFT)->FT_DESCONT)					//aRegC300[1][8])			//09 - VL_DESC_I
	aAdd (aRegC750[nPos], cClasFis)									//aRegC300[1][13])			//10 - CST
	aAdd (aRegC750[nPos], (cAliasSFT)->FT_CFOP)						//aRegC300[1][14])			//11 - CFOP
	aAdd (aRegC750[nPos], (cAliasSFT)->FT_BASEICM)					//aRegC300[1][15])			//12 - VL_BC_ICMS
	aAdd (aRegC750[nPos], (cAliasSFT)->FT_ALIQICM)					//aRegC300[1][16])			//13 - ALIQ_ICMS
	aAdd (aRegC750[nPos], (cAliasSFT)->FT_VALICM)					//aRegC300[1][17])			//14 - VL_ICMS_I
	aAdd (aRegC750[nPos], 0)						//15 - IND_REC
	aAdd (aRegC750[nPos], aPartDoc[4])				//16 - CNPJ
	aAdd (aRegC750[nPos], aPartDoc[5])				//17 - CPF
	aAdd (aRegC750[nPos], aPartDoc[8])				//18 - UF
	aAdd (aRegC750[nPos], aPartDoc[9])				//19 - IE
	//
	If cEntSai=="2" // Somente o prestador deve informar este registro.
		aRegAux := {aRegC750[nPos]}
		If lBloqCD
			GrvRegTrb (cAlias, nRelac, aRegAux, nItem)
		endif
	EndIf
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |RegC760   ³ Autor ³Liber de Esteban       ³ Data ³28.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³C760 - REGISTRO ANALITICO DO DOCUMENTO (MODELOS 06, 21 E 22)³±±
±±³          ³                                                            ³±±
±±³          ³- Acumula valores para a gravacao do registro E105 junto com³±±
±±³          ³ a gravacao do registro E100.                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoe contidas na tabela   ³±±
±±³          ³ SFT.                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³E760 - 3(1:N) Para cada E700                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cAliasSFT -> Alias da tabela SFT aberta no momento.         ³±±
±±³          ³aRegC760 -> Array com as informacoes acumuladas             ³±±
±±³          ³cSituaDoc -> Situação do documento                          ³±±
±±³          ³cClasFis -> Codigo da Situação Tributaria                   ³±±
±±³          |cEntSai -> Flag Entrada(1)/Saida(2).                        ³±±
±±³          ³nRelac -> Flag de relacionamento com os sub-registros       ³±±
±±³          ³nItem -> Contador do item para cada documento fiscal.       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
/*
Static Function RegC760 (cAlias, cAliasSFT, aRegC760, cSituaDoc, cClasFis, cEntSai, nRelac, nItem)
	Local	lRet	:=	.T.
	Local	nPos	:=	0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³REGISTRO C760 - REGISTRO ANALITICO DOS DOCUMENTOS (MODELOS 06, 21 E 22)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ((nPos := aScan (aRegC760, {|aX| aX[2]==cClasFis .And. aX[3]==(cAliasSFT)->FT_CFOP .And. aX[6]==(cAliasSFT)->FT_ALIQICM}))==0)
		aAdd (aRegC760, {})
		nPos	:=	Len (aRegC760)
		aAdd (aRegC760[nPos], "C760")							//01 - REG
		aAdd (aRegC760[nPos], cClasFis)							//02 - CST
		aAdd (aRegC760[nPos], (cAliasSFT)->FT_CFOP)	   		//03 - CFOP
		aAdd (aRegC760[nPos], 0)						   		//04 - VL_CONT_P
		aAdd (aRegC760[nPos], 0)						   		//05 - VL_BC_ICMS_P
		aAdd (aRegC760[nPos], (cAliasSFT)->FT_ALIQICM)	   		//06 - ALIQ_ICMS
		aAdd (aRegC760[nPos], 0)						   		//07 - VL_ICMS_P
	EndIf
	If !("02"==cSituaDoc)
		aRegC760[nPos][4]	+=	(cAliasSFT)->FT_VALCONT			//04 - VL_CONT_P
		aRegC760[nPos][5]	+=	(cAliasSFT)->FT_BASEICM			//05 - VL_BC_ICMS_P
		aRegC760[nPos][7]	+=	(cAliasSFT)->FT_VALICM			//07 - VL_ICMS_P
	EndIf
	//
	GrvRegTrb (cAlias, nRelac, aRegC760, nItem)
Return (lRet)
*/
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³C770C775  ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³   C770 - CONSOLIDACAO DE NOTAS FISCAIS/CONTA DE ENERGIA    ³±±
±±³          ³                   ELETRICA (MODELO 06)                     ³±±
±±³          ³ C775 - ITENS DO DOCUMENTO CONSOLIDADO (MODELO 06)          ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao do Registro C770 e C775                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoe contidas no array    ³±±
±±³          ³ aRegC700/aRegC750/aTotaliza/aPartDoc/aCmpAntSFT para o     ³±±
±±³          ³ Modelo 06 que sera gravado no final da funcao principal.   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³C770 - 2(varios por arquivo)                                ³±±
±±³          ³C775 - 3(1:N) Para cada C770                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|aRegC700 -> Conteudo gravado do registro C700 para utiliza- ³±±
±±³          ³ cao em outros registros da funcao principal.               ³±±
±±³          ³aRegC750 -> Conteudo gravado do registro C750 para utiliza- ³±±
±±³          ³ cao em outros registros da funcao principal.               ³±±
±±³          |aTotaliza -> Totalizadores de valores para a tabela SFT.    ³±±
±±³          ³aPartDoc -> Array com informacoes sobre o participante do   ³±±
±±³          ³ documento fiscal, este array eh montado pela funcao princi-³±±
±±³          ³ pal.                                                       ³±±
±±³          |aCmpAntSFT -> Informacoes sobre o cabecalho dos documentos. ³±±
±±³          ³aRegC770 -> Array contendo as informacoes processadas pela  ³±±
±±³          ³ funcao a ser retornado para gravacao pela funcao principal.³±±
±±³          ³aRegC775 -> Array contendo as informacoes processadas pela  ³±±
±±³          ³ funcao a ser retornado para gravacao pela funcao principal.³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function C770C775 (aRegC700, aRegC750, aTotaliza, aPartDoc, aCmpAntSFT, aRegC770, aRegC775, cAliasSFT)
	Local	lRet		:= .T.
	Local	nPos		:= 0
	Local	nPos2		:= 0
	Local	nI			:= 0
	Local	lAcumulou	:= .F.
	Local	nItem		:= 0
	Local	aOrdC775	:= {}
	Local	nPosX		:= 0
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³REGISTRO C770 - CONSOLIDACAO DE NOTAS FISCAIS/CONTA DE ENERGIA ELETRICA (MODELO 06)|
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ((nPos := aScan (aRegC770, {|aX| aX[3]==aPartDoc[11] .And. aX[4]==aRegC700[1][7] .And. aX[5]==aRegC700[1][8] .And. aX[6]==aRegC700[1][9]}))==0)
		aAdd(aRegC770, {})
		nPos	:=	Len (aRegC770)
		aAdd (aRegC770[nPos], "C770")	 	 	  					//01 - REG
		aAdd (aRegC770[nPos], aRegC700[1][5]) 	   					//02 - COD_MOD
		aAdd (aRegC770[nPos], aPartDoc[11]) 	   					//03 - COD_MUN
		aAdd (aRegC770[nPos], aRegC700[1][7]) 	   					//04 - SER
		aAdd (aRegC770[nPos], aRegC700[1][8]) 	   					//05 - SUB
		aAdd (aRegC770[nPos], aRegC700[1][9]) 	   					//06 - COD_CONS
		aAdd (aRegC770[nPos], "0") 	   								//07 - QTD_CONS
		aAdd (aRegC770[nPos], "0") 	   								//08 - QTD_CANC
		aAdd (aRegC770[nPos], aRegC700[1][11])						//09 - DT_DOC
		aAdd (aRegC770[nPos], 0) 	   								//10 - VL_DOC
		aAdd (aRegC770[nPos], 0) 	   								//11 - VL_DESC
		aAdd (aRegC770[nPos], 0) 	   								//12 - VL_FORN
		aAdd (aRegC770[nPos], 0) 	   								//13 - VL_SERV_NT
		aAdd (aRegC770[nPos], 0) 	   								//14 - VL_TERC
		aAdd (aRegC770[nPos], 0) 	   								//15 - VL_DA
		aAdd (aRegC770[nPos], 0) 	   								//16 - VL_BC_ICMS
		aAdd (aRegC770[nPos], 0) 	   								//17 - VL_ICMS
		aAdd (aRegC770[nPos], 0) 	   								//18 - CONS
	Else
		lAcumulou	:=	.T.
	EndIf
	//
	aRegC770[nPos][7]	:=	Alltrim (STR (Val (aRegC770[nPos][7]) + 1))		//07 - QTD_CONS
	If !Empty (aCmpAntSFT[7]) //Documento cancelado
		aRegC770[nPos][8]	:=	Alltrim (STR (Val (aRegC770[nPos][8]) + 1))	//08 - QTD_CANC
	Else
		aRegC770[nPos][10]	+=	aRegC700[1][14]						//10 - VL_DOC
		aRegC770[nPos][11]	+=	aRegC700[1][15]						//11 - VL_DESC
		aRegC770[nPos][12]	+=	aRegC700[1][16]						//12 - VL_FORN
		aRegC770[nPos][13]	+=	aRegC700[1][17]						//13 - VL_SERV_NT
		aRegC770[nPos][14]	+=	aRegC700[1][18]						//14 - VL_TERC
		aRegC770[nPos][15]	+=	aRegC700[1][19]						//15 - VL_DA
		aRegC770[nPos][16]	+=	aRegC700[1][20]						//16 - VL_BC_ICMS
		aRegC770[nPos][17]	+=	aRegC700[1][21]						//17 - VL_ICMS
		aRegC770[nPos][18]	+=	aTotaliza[08]						//18 - CONS
	EndIf
	//
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³REGISTRO C775 - ITENS DO DOCUMENTO CONSOLIDADO (MODELO 06)                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nI := 1 To Len (aRegC750)
		If lAcumulou
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Ultima posicao para determinado item do array³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aOrdC775	:=	aSort(aRegC775,,,{|aX, aY| Str( aX[1],20 )+PadL( aX[3],10 )<Str( aY[1],20 )+PadL( aY[3],10 )})
			nPosX		:=	aScan(aOrdC775,{|aX| aX[1]==nPos})
			While nPosX<=Len(aOrdC775) .And. aOrdC775[nPosX][1]==nPos
				nItem	:=	Val (aOrdC775[nPosX][3])+1
				nPosX++
			End
		Else
			nItem	:=	nI
		EndIf
		//
		aAdd(aRegC775, {})
		nPos2	:=	Len (aRegC775)
		aAdd (aRegC775[nPos2], nPos)								//01 - CHAVE RELACIONAMENTO
		aAdd (aRegC775[nPos2], "C775")								//02 - REG
		aAdd (aRegC775[nPos2], AllTrim (Str (nItem)))				//03 - NUM_ITEM
		aAdd (aRegC775[nPos2], aRegC750[nI][3])						//04 - COD_ITEM
		aAdd (aRegC775[nPos2], aRegC750[nI][4])						//05 - COD_CLASS
		aAdd (aRegC775[nPos2], aRegC750[nI][6])						//06 - QTD
		aAdd (aRegC775[nPos2], aRegC750[nI][7])						//07 - UNID
		aAdd (aRegC775[nPos2], aRegC750[nI][8])						//08 - VL_ITEM
		aAdd (aRegC775[nPos2], aRegC750[nI][9])						//09 - VL_DESC_I
		aAdd (aRegC775[nPos2], aRegC750[nI][10])					//10 - CST
		aAdd (aRegC775[nPos2], aRegC750[nI][11])					//11 - CFOP
		aAdd (aRegC775[nPos2], aRegC750[nI][13])					//12 - ALIQ_ICMS
		aAdd (aRegC775[nPos2], aRegC750[nI][12])					//13 - VL_BC_ICMS_I
		aAdd (aRegC775[nPos2], aRegC750[nI][14])					//14 - VL_ICMS_I

	Next nI
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RegD020   ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³                         D020                               ³±±
±±³          ³     NOTA FISCAL DE SERVICO DE TRANSPORTE (MODELO 07)       ³±±
±±³          ³ CONHECIMENTO DE TRANSPORTE RODOVIARIO DE CARGAS (MODELO 08)³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao e gravacao do Registro D020                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoes contidas no array   ³±±
±±³          ³ aTotaliza/aPartDoc/aCmpAntSFT para os Modelos 07/08.       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³D020 - 2(varios por arquivo)                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAlias -> Alias do TRB que recebera as informacoes.         ³±±
±±³          |cEntSai -> Flag Entrada(1)/Saida(2).                        ³±±
±±³          ³aPartDoc -> Array com informacoes sobre o participante do   ³±±
±±³          ³ documento fiscal, este array eh montado pela funcao princi-³±±
±±³          ³ pal.                                                       ³±±
±±³          |aTotaliza -> Totalizadores de valores para a tabela SFT.    ³±±
±±³          ³nRelac -> Flag de relacionamento com os sub-registros       ³±±
±±³          ³cEspecie -> Modelo do documento fiscal                      ³±±
±±³          |aCmpAntSFT -> Informacoes sobre o cabecalho dos documentos. ³±±
±±³          ³cChave -> Chave para gravacao das observacoes do documento  ³±±
±±³          ³ fiscal referenciado(Registro 0450).                        ³±±
±±³          ³cCmpFrete -> Campo que contera o valor do frete no cabecalho³±±
±±³          ³ da NF, ou seja, pordera ser o campo F1_FRETE ou F2_FRETE.  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RegD020 (cAlias, cEntSai, aPartDoc, aTotaliza, nRelac, cEspecie, aCmpAntSFT, cChave, cCmpFrete, cSituaDoc, cClasFis, cCodObs, cCodNat)
	Local lRet := .T.
	Local aReg := {}
	//

	aAdd (aReg, {})
	nPos	:=	Len (aReg)
	aAdd (aReg[nPos], "D020")	 	   					//01 - REG
	aAdd (aReg[nPos], STR(Val (cEntSai)-1,1))			//02 - IND_OPER
	If (Empty (aCmpAntSFT[8])) .And. cEntSai=="1"
		aAdd (aReg[nPos], "1")							//03 - IND_EMIT
	ElseIf (Empty (aCmpAntSFT[8])) .And. cEntSai=="2"
		aAdd (aReg[nPos], "0")							//03 - IND_EMIT
	Else
		If ("S"$aCmpAntSFT[8])
			aAdd (aReg[nPos], "0") 						//03 - IND_EMIT
		Else
			aAdd (aReg[nPos], "1")						//03 - IND_EMIT
		EndIf
	EndIf
	aAdd (aReg[nPos], IIf (cSituaDoc$"02#03#04", "", aPartDoc[1]) )		//04 - COD_PART
	aAdd (aReg[nPos], cEspecie)		   					//05 - COD_MOD
	aAdd (aReg[nPos], cSituaDoc)		   				//06 - COD_SIT
	aAdd (aReg[nPos], aCmpAntSFT[2])					//07 - SER
	aAdd (aReg[nPos], "")								//08 - SUB
	aAdd (aReg[nPos], aCmpAntSFT[1])					//09 - NUM_DOC
	aAdd (aReg[nPos], aCmpAntSFT[6])					//10 - DT_DOC
	aAdd (aReg[nPos], aCmpAntSFT[5])					//11 - DT_A_P
	aAdd (aReg[nPos], IIf (cSituaDoc$"02#03#04", "", cCodNat) )		//12 - COD_NAT
	aAdd (aReg[nPos], aTotaliza[01])					//13 - VL_DOC
	aAdd (aReg[nPos], 0)								//14 - VL_DESC
	If (cEspecie$"07")
		//Layout pede para mandar 2 quando for modelo 07
		aAdd (aReg[nPos], "2")							//15 - IND_FRE
	Else
		If (&(cCmpFrete)>0)
			aAdd (aReg[nPos], "0")						//15 - IND_FRE
		Else
			aAdd (aReg[nPos], "1")						//15 - IND_FRE
		EndIf
	EndIf
	aAdd (aReg[nPos], aTotaliza[01])					//16 - VL_SERV
	aAdd (aReg[nPos], cClasFis)							//17 - CST
	aAdd (aReg[nPos], aCmpAntSFT[9])					//18 - CFOP
	aAdd (aReg[nPos], aTotaliza[02])					//19 - VL_BC_ICMS
	aAdd (aReg[nPos], aCmpAntSFT[11])					//20 - ALIQ_ICMS
	aAdd (aReg[nPos], aTotaliza[03])					//21 - VL_ICMS
	aAdd (aReg[nPos], cCodObs)							//22 - REF_INF_OBS
	//
	If lBloqCD
		GrvRegTrb (cAlias, nRelac, aReg)
	EndIf
Return (lRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RegD030   ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³                         D030                               ³±±
±±³          ³    COMPLEMENTO DA NOTA FISCAL DE SERVICO DE TRANSPORTE     ³±±
±±³          ³                     (MODELO 07)                            ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao e gravacao do Registro D030                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoes contidas nas tabelas³±±
±±³          ³ DT6/DA3/DUY/SA1 caso tenham integracao com o TMS.          ³±±
±±³          ³O DA3 utilizado nesta funcao pode estar posicionado de acor-³±±
±±³          ³ do com a tabela  DTR quando envolver TMS ou DB1 quando     ³±±
±±³          ³ envolver o recebimento no compras (MATR145).               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³D030 - 3(1:1) Para cada D020                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAlias -> Alias do TRB que recebera as informacoes.         ³±±
±±³          ³nRelac -> Flag de relacionamento com os sub-registros       ³±±
±±³          ³cEntSai -> Flag indicador de entrada(1)/saida(2).           ³±±
±±³          ³cAlsSA -> Alias para a tabela SA1 ou SA2 posicionada.       ³±±
±±³          ³lAchouDA3 -> Flag que identifica se a tabela DA3 foi posi-  ³±±
±±³          ³ cionada.                                                   ³±±
±±³          ³aPartDoc -> Array contendo as informacoes do participante do³±±
±±³          ³ documento fiscal.                                          ³±±
±±³          ³aMVCERTVEI -> Array com campos do DA3 necessários para      ³±±
±±³          ³ certidão de propriedade de veículo, no seguinte formato:   ³±±
±±³          ³ {"Certidão propriedade", "UF certidão"}.                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RegD030 (cAlias, nRelac, cEntSai, cAlsSA, lAchouDA3, aPartDoc, aMVCERTVEI)
	Local	lRet		:= .T.
	Local	aReg		:= {}
	Local	aAreaSM0	:= SM0->(GetArea ())
	//   
	
	aAdd (aReg, {})
	nPos	:=	Len (aReg)
	aAdd (aReg[nPos], "D030")	 	   											//01 - REG
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³SE FOR SAIDA POSSUO A INTEGRACAO COM O TMS³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (cEntSai=="2")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³OBASERVACAO PARA OS CAMPOS 2, 3, 4 e 5.                                                                                   ³
		//³- NOTAS FISCAIS DE SERVICO DE TRANSPORTE (MODELO 07) sao soh emitidas intramunicipal, ou seja, dentro do mesmo municipio. ³
		//³- CONHECIMENTO DE TRANSPORTE RODOVIARIO DE CARGA (MODELO 08) sao soh emitidos intermunicipal, interestadual ou exportacao.³
		//³                                                                                                                          ³
		//³Por isso esses campos recebem a mesma informacao do SIGAMAT, pois trata-se de operacao dentro do mesmo municipio.         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (SM0->(DbSeek (cEmpAnt+DT6->DT6_FILDOC)))
			aAdd (aReg[nPos], SM0->M0_CODMUN)				   				//02 - COD_MUN_ORIG
			aAdd (aReg[nPos], SM0->M0_CODMUN)								//03 - COD_MUN_DEST
		Else
			RestArea (aAreaSm0)
			aAdd (aReg[nPos], SM0->M0_CODMUN)				   				//02 - COD_MUN_ORIG
			aAdd (aReg[nPos], SM0->M0_CODMUN)								//03 - COD_MUN_DEST
		EndIf
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³SE FOR ENTRADA UTILIZO AS TABELAS DO RECEBIMENTO DB1, DB2 E DB3³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Else
		aAdd (aReg[nPos], aPartDoc[11])						   					//02 - COD_MUN_ORIG
		aAdd (aReg[nPos], SM0->M0_CODMUN)								   		//03 - COD_MUN_DEST	
	EndIf
	aAdd (aReg[nPos], Iif (lAchouDA3, DA3->DA3_PLACA, ""))						//04 - VEIC_ID
	aAdd (aReg[nPos], Iif (lAchouDA3, DA3->DA3_ESTPLA, ""))					//05 - UF_VEIC
	
	dbSelectArea("SX5")
	dbSeek(xFilial()+"M6"+DA3->DA3_MARVEI)
	aAdd (aReg[nPos], Iif (lAchouDA3, X5Descri(), ""))							//06 - MARCA
	
	aAdd (aReg[nPos], Iif (lAchouDA3, DA3->DA3_DESC, ""))						//07 - MODELO
	aAdd (aReg[nPos], Iif (lAchouDA3, DA3->DA3_ANOMOD, 0))						//08 - ANO
	//
	If (lAchouDA3) .And. (Len (aMVCERTVEI)==2) .And. !Empty (aMVCERTVEI[1]) .And.;
		!Empty (aMVCERTVEI[2]) .And. DA3->(FieldPos (aMVCERTVEI[1]))>0 .And.;
		DA3->(FieldPos (aMVCERTVEI[2]))>0
		//
		aAdd (aReg[nPos], DA3->(FieldPos (FieldGet (aMVCERTVEI[1]))))			//09 - CERT
		aAdd (aReg[nPos], DA3->(FieldPos (FieldGet (aMVCERTVEI[2]))))			//10 - UF_CERT
	Else
		aAdd (aReg[nPos], "")							   			   			//09 - CERT
		aAdd (aReg[nPos], "")										   			//10 - UF_CERT
	EndIf
	//  
	If lBloqCD
		GrvRegTrb (cAlias, nRelac, aReg)
	EndIf
	//
	RestArea (aAreaSM0)
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RegD040   ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³                         D040                               ³±±
±±³          ³  ITENS DA NOTA FISCAL DE SERVICO DE TRANSPORTE (MODELO 07) ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao e gravacao do Registro D040                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoes contidas na tabela  ³±±
±±³          ³ SFT.                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³D030 - 3(1:N) Para cada D020                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAlias -> Alias do TRB que recebera as informacoes.         ³±±
±±³          ³aRegD040 -> Array que armazena informacoes por item para    ³±±
±±³          ³ gerar por NF apos o while de ITEM.                         ³±±
±±³          ³cAliasSFT -> Alias da tabela SFT posicionada no momento do  ³±±
±±³          | processamento.                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RegD040 (cAlias, aRegD040, cAliasSFT)
	Local	lRet := .T.
	local	nPos := 0

	If lBloqCD
		Reg0200()
	EndIf
	//
	aAdd (aRegD040, {})
	nPos	:=	Len (aRegD040)
	aAdd (aRegD040[nPos], "D040")								//01 - REG
	aAdd (aRegD040[nPos], (cAliasSFT)->FT_ITEM)					//02 - NUM_ITEM
	aAdd (aRegD040[nPos], (cAliasSFT)->FT_PRODUTO)				//03 - COD_ITEM
	aAdd (aRegD040[nPos], (cAliasSFT)->FT_TOTAL)				//04 - VL_FRT
	aAdd (aRegD040[nPos], 0)									//05 - VL_OUT
	aAdd (aRegD040[nPos], 0)									//06 - VL_SERV
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RegD050   ³ Autor ³Liber de Esteban       ³ Data ³20.10.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³                         D050                               ³±±
±±³          ³           COMPLEMENTO DO DOCUMENTO (MODELO 08)             ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao e gravacao do Registro D050                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoes contidas nas tabelas³±±
±±³          ³ DT6/DA3/DT8 caso tenham integracao com o TMS.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³3(1:1) Para cada D020                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAlias -> Alias do TRB que recebera as informacoes.         ³±±
±±³          ³nRelac -> Flag de relacionamento com os sub-registros       ³±±
±±³          ³cEntSai -> Flag indicador de entrada(1)/saida(2).           ³±±
±±³          ³cAlsSA -> Alias para a tabela SA1 ou SA2 posicionada.       ³±±
±±³          ³lAchouDA3 -> Flag que identifica se a tabela DA3 foi posi-  ³±±
±±³          ³ cionada.                                                   ³±±
±±³          ³cSituaDoc -> Situacao do documento fiscal conforme funcao   ³±±
±±³          ³aMVCEINITS -> Array com campos do SA1/SA2 no seguinte       ³±±
±±³          ³ formato: {"CEI SA1", "CEI SA2", "NIT SA1", "NIT SA2",;     ³±±
±±³          ³ "SUFRAMA SA1","SUFRAMA SA2", "COD PAIS-BCB SA1", ;         ³±±
±±³          ³ "COD PAIS-BCB SA2"}                                        ³±±
±±³          ³aMVMUNIBGE -> Array com campos do SA1/SA2 para informar o   ³±±
±±³          ³ código do município, segundo tabela do IBGE:               ³±±
±±³          ³ {"COD MUN SA1", "COD MUN SA2"}                             ³±±
±±³          ³aMVCOMPFRT -> Array com os códigos de componentes que serão ³±±
±±³          ³ relacionados com registros do DT8, no seguinte formato:    ³±±
±±³          ³ {"FretePV","SEC/CAT","Despacho","Pedágio"}                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RegD050 (cAlias, nRelac, cEntSai, cAlsSA, lAchouDA3, aPartDoc, cSituaDoc, aMVCEINITS, aMVMUNIBGE, aMVCOMPFRT)
	Local	lRet		:= .T.
	Local	aAreaSM0	:= SM0->(GetArea ())
	Local	aReg		:= {}
	Local	aPartREM	:= {}
	Local	aPartDES	:= {}
	Local	aPartCON	:= {}
	Local	aPartDPC	:= {}

	aAdd (aReg, {})
	nPos	:=	Len (aReg)
	aAdd (aReg[nPos], "D050")	 	   													  		//01 - REG
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Para Saida busca informacoes do TMS       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (cEntSai=="2")
		
		If (cAlsSA)->(dbSeek (xFilial (cAlsSA)+DT6->DT6_CLIREM+DT6->DT6_LOJREM))
			aPartREM	:=	InfPartDoc (cAlsSA, aMVCEINITS, aMVMUNIBGE)
		Else
			aPartREM	:=	aPartDoc
		EndIf
		
		If (cAlsSA)->(dbSeek (xFilial (cAlsSA)+DT6->DT6_CLIDES+DT6->DT6_LOJDES))
			aPartDES	:=	InfPartDoc (cAlsSA, aMVCEINITS, aMVMUNIBGE)
		Else
			aPartDES	:=	aPartDoc
		EndIf
		
		If (cAlsSA)->(dbSeek (xFilial (cAlsSA)+DT6->DT6_CLICON+DT6->DT6_LOJCON))
			aPartCON	:=	InfPartDoc (cAlsSA, aMVCEINITS, aMVMUNIBGE)
			
			Reg0150 (aPartCON)
		Else
			aPartCON	:=	aPartDoc
		EndIf
		
		If (cAlsSA)->(dbSeek (xFilial (cAlsSA)+DT6->DT6_CLIDPC+DT6->DT6_LOJDPC))
			aPartDPC	:=	InfPartDoc (cAlsSA, aMVCEINITS, aMVMUNIBGE)

			Reg0150 (aPartDPC)
		Else
			aPartDPC	:=	aPartDoc
		EndIf
		
		aAdd (aReg[nPos], aPartREM[11])								   							//02 - COD_MUN_ORIG
		aAdd (aReg[nPos], aPartDES[11])															//03 - COD_MUN_DEST
		aAdd (aReg[nPos], IIf (cSituaDoc$"02#03#04", "", aPartCON[1]))						   	//04 - COD_PART_CONSG
		aAdd (aReg[nPos], IIf (cSituaDoc$"02#03#04", "", aPartDPC[1]))							//05 - COD_PART_RED
		
	Else
		aAdd (aReg[nPos], aPartDoc[11])							   								//02 - COD_MUN_ORIG
		aAdd (aReg[nPos], SM0->M0_CODMUN)								   						//03 - COD_MUN_DEST	
		aAdd (aReg[nPos], IIf (cSituaDoc$"02#03#04", "", aPartDoc[1]))							//04 - COD_PART_CONSG
		aAdd (aReg[nPos], IIf (cSituaDoc$"02#03#04", "", aPartDoc[1]))							//05 - COD_PART_RED
	EndIf
	
	aAdd (aReg[nPos], 0)																		//06 - IND_FRT_RED
	aAdd (aReg[nPos], Iif (lAchouDA3, DA3->DA3_PLACA, ""))										//07 - VEIC_ID
	aAdd (aReg[nPos], Iif (lAchouDA3, DA3->DA3_ESTPLA, ""))									//08 - UF_VEIC
	dbSelectArea("SX5")
	dbSeek(xFilial()+"M6"+DA3->DA3_MARVEI)
	aAdd (aReg[nPos], Iif (lAchouDA3, X5Descri(), ""))											//09 - MARCA
	aAdd (aReg[nPos], Iif (lAchouDA3, DA3->DA3_DESC, ""))										//10 - MODELO
	aAdd (aReg[nPos], Iif (lAchouDA3, DA3->DA3_ANOMOD, 0))										//11 - ANO
	aAdd (aReg[nPos], 0)																		//12 - VL_FRT_PV
	aAdd (aReg[nPos], 0)																		//13 - VL_SEC_CAT
	aAdd (aReg[nPos], 0)																		//14 - VL_DESP
	aAdd (aReg[nPos], 0)																		//15 - VL_PEDG
	aAdd (aReg[nPos], 0)																		//16 - VL_OUT
	aAdd (aReg[nPos], 0)																		//17 - VL_FRT

	If cEntSai=="2"
		cChaveDT8	:=	DT8->DT8_FILIAL+DT8->DT8_FILDOC+DT8->DT8_DOC+DT8->DT8_SERIE
		Do While !DT8->(Eof ()) .And.;
			cChaveDT8==DT8->DT8_FILIAL+DT8->DT8_FILDOC+DT8->DT8_DOC+DT8->DT8_SERIE
			
			If (Len (aMVCOMPFRT)==4)
				//Valor Total do frete
				If (DT8->DT8_CODPAS$"TF")
					aReg[nPos][17]	+=	DT8->DT8_VALTOT											//17 - VL_FRT
				
				//Valor do frete por peso/volume
				ElseIf (DT8->DT8_CODPAS$aMVCOMPFRT[1])
					aReg[nPos][12]	+=	DT8->DT8_VALTOT											//12 - VL_FRT_PV
		
				//Valores do SEC/CAT
				ElseIf (DT8->DT8_CODPAS$aMVCOMPFRT[2])
					aReg[nPos][13]	+=	DT8->DT8_VALTOT											//13 - VL_SEC_CAT
					
				//Valores de despacho
				ElseIf (DT8->DT8_CODPAS$aMVCOMPFRT[3])
					aReg[nPos][14]	+=	DT8->DT8_VALTOT											//14 - VL_DESP
		
				//Valores de pedagio
				ElseIf (DT8->DT8_CODPAS$aMVCOMPFRT[4])
					aReg[nPos][15]	+=	DT8->DT8_VALTOT											//15 - VL_PEDG
					
				//Outros valores
				Else
					aReg[nPos][16]	+=	DT8->DT8_VALTOT											//16 - VL_OUT
				EndIf
				
			//Valor Total do Frete
			ElseIf (DT8->DT8_CODPAS$"TF")
				aReg[nPos][17]	+=	DT8->DT8_VALTOT												//17 - VL_FRT
			//Outros valores
			Else
				aReg[nPos][16]	+=	DT8->DT8_VALTOT												//16 - VL_OUT
			EndIf
			
			DT8->(DbSkip ())
		EndDo
		
		If (DT6->DT6_TIPFRE$"1")	//1=CIF, 2=FOB
			aReg[nPos][06]	:= 0																//06 - IND_FRT_RED
		Else
			aReg[nPos][06]	:= "1"																//06 - IND_FRT_RED
		EndIf
	
	EndIf
	If lBloqCD	
		GrvRegTrb (cAlias, nRelac, aReg)
	EndIf	
	RestArea (aAreaSM0)
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RegD180   ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³                         D180                               ³±±
±±³          ³         CARGA TRANSPORTADA (MODELOS 07 e 08)               ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao e gravacao do Registro D180                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoes contidas nas tabelas³±±
±±³          ³ DT6/SA1/SFT caso tenham integracao com o TMS.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³D030 - 3(1:1) Para cada D020                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAlias -> Alias do TRB que recebera as informacoes.         ³±±
±±³          ³nRelac -> Flag de relacionamento com os sub-registros       ³±±
±±³          ³cEspecie -> Modelo do documento fiscal                      ³±±
±±³          |aCmpAntSFT -> Informacoes sobre o cabecalho dos documentos. ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RegD180 (cAlias, nRelac, cEspecie, aCmpAntSFT)
	Local	lRet		:= .T.
	Local	aReg		:= {}
	Local	cDesRem		:= ""
	Local	cChaveDTC	:= ""
	Local	lAchouSB1	:= .F.
	Local	aAreaSB1	:= SB1->(GetArea())
	//
	If (DT6->DT6_TIPFRE=="1")
		cDesRem	:=	DT6->DT6_CLIDES+DT6->DT6_LOJDES
	Else
		cDesRem	:=	DT6->DT6_CLIREM+DT6->DT6_LOJREM
	EndIf
	//
	If SA1->(DbSeek (xFilial ("SA1")+cDesRem))
		cChaveDTC	:=	DTC->DTC_FILIAL+DTC->DTC_FILDOC+DTC->DTC_DOC+DTC->DTC_SERIE
		Do While !DTC->(Eof ()) .And. cChaveDTC==DTC->DTC_FILIAL+DTC->DTC_FILDOC+DTC->DTC_DOC+DTC->DTC_SERIE
			aAdd (aReg, {})
			nPos := Len(aReg)
			aAdd (aReg[nPos], "D180")								//01 - REG
			If (!Empty(SA1->A1_CGC) .and. RetPessoa(SA1->A1_CGC) == "J") .OR. ("J"$SA1->A1_PESSOA)
				aAdd (aReg[nPos], SA1->A1_CGC)						//02 - CNPJ
				aAdd (aReg[nPos], 0)								//03 - CPF
			Else
				aAdd (aReg[nPos], 0)								//02 - CNPJ
				aAdd (aReg[nPos], SA1->A1_CGC)						//03 - CPF
			EndIf
			aAdd (aReg[nPos], SA1->A1_EST)							//04 - UF
			aAdd (aReg[nPos], SA1->A1_INSCR)						//05 - IE
			aAdd (aReg[nPos], cEspecie)								//06 - COD_MOD
			
			aAdd (aReg[nPos], DTC->DTC_NUMNFC)						//07 - SER
			aAdd (aReg[nPos], DTC->DTC_SERNFC)						//08 - NUM_DOC
			aAdd (aReg[nPos], DTC->DTC_DATENT)						//09 - DT_DOC
			aAdd (aReg[nPos], DTC->DTC_VALOR)						//10 - VL_DOC
			aAdd (aReg[nPos], DTC->DTC_VALOR)						//11 - VL_MERC
			
			If SB1->(dbSeek (xFilial ("SB1")+DTC->DTC_CODPRO))
				lAchouSB1 := .T.
			EndIf
			RestArea(aAreaSB1)
			
			aAdd (aReg[nPos], If(lAchouSB1,SB1->B1_GRUPO,"") )		//12 - NAT_VOL
			aAdd (aReg[nPos], Alltrim(STR(DTC->DTC_QTDVOL)))		//13 - QTD_VOL
			aAdd (aReg[nPos], If(lAchouSB1,SB1->B1_DESC,"") )		//14 - VOL
			aAdd (aReg[nPos], If(lAchouSB1,SB1->B1_ESPECIE,"") )	//15 - ESPECIE
			aAdd (aReg[nPos], If(lAchouSB1,SB1->B1_FABRIC,"") )	//16 - MARCA
			aAdd (aReg[nPos], 0)									//17 - NUM
			aAdd (aReg[nPos], {DTC->DTC_PESO,"VLR3"})				//18 - PESO_BRT
			aAdd (aReg[nPos], {DTC->DTC_PESO,"VLR3"})				//19 - PESO_LIQ
			//
			DTC->(DbSkip ())
		EndDo
	EndIf	
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RegD400   ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³  NOTA FISCAL DE SERVICO DE COMUNICACAO (MODELO 21) E NOTA  ³±±
±±³          ³      FISCAL DE SERVICO DE TELECOMUNICACAO (MODELO 22)      ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao e gravacao do Registro D400                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoe contidas no array    ³±±
±±³          ³ aRegC020/aTotaliza/aCmpAntSFT para os Modelos(21 e 22)     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³2(varios por arquivo)                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAlias -> Alias do TRB que recebera as informacoes          ³±±
±±³          ³nRelac -> Flag de relacionamento.                           ³±±
±±³          |aRegC020 -> Informacoes sobre todos documentos fiscais pro- ³±±
±±³          ³ cessados no while da funcao principal.                     ³±±
±±³          |aTotaliza -> Totalizadores de valores para a tabela SFT.    ³±±
±±³          |aCmpAntSFT -> Informacoes sobre o cabecalho dos documentos. ³±±
±±³          ³aRegD400 -> Array contendo as informacoes processadas pela  ³±±
±±³          ³ funcao a ser retornado para utilizacao pela funcao principal³±±
±±³          ³nItem -> Contador do item para cada documento fiscal.       ³±±
±±³          ³lAchouSFX -> Flag de localizacao do registro da NF na tabela³±±
±±³          ³ SFU.                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RegD400 (cAlias, nRelac, aRegC020, aTotaliza, aCmpAntSFT, aRegD400, nItem, lAchouSFX, cCodNat)
	Local lRet := .T.
	Local nPos := 0
	Local nSub := Iif(Len(aRegC020[1][7])-1 > 4, 4, Len(aRegC020[1][7]))
	//
	aAdd(aRegD400, {})
	nPos := Len(aRegD400)
	aAdd (aRegD400[nPos], "D400")					//01 - REG
	aAdd (aRegD400[nPos], aRegC020[1][2])			//02 - IND_OPER
	aAdd (aRegD400[nPos], aRegC020[1][3])			//03 - IND_EMIT
	aAdd (aRegD400[nPos], aRegC020[1][4])			//04 - COD_PART
	aAdd (aRegD400[nPos], aRegC020[1][5])			//05 - COD_MOD
	aAdd (aRegD400[nPos], aRegC020[1][6])			//06 - COD_SIT
	aAdd (aRegD400[nPos], Substr(aRegC020[1][7],1,1))		//07 - SER
	aAdd (aRegD400[nPos], Substr(aRegC020[1][7],2,nSub))	//08 - SUB
	aAdd (aRegD400[nPos], IIF(lAchouSFX .And. SFX->(FieldPos("FX_CLASCON"))>0 .AND. !Empty(SFX->FX_CLASCON),SFX->FX_CLASCON,"99") )	//09 - COD_CONS
	aAdd (aRegD400[nPos], aRegC020[1][8])			//10 - NUM_DOC
	aAdd (aRegD400[nPos], aRegC020[1][9])			//11 - DT_DOC
	aAdd (aRegD400[nPos], aRegC020[1][10])			//12 - DT_A_P
	aAdd (aRegD400[nPos], aRegC020[1][11])			//13 - COD_NAT
	aAdd (aRegD400[nPos], aRegC020[1][12])			//14 - VL_DOC
	aAdd (aRegD400[nPos], aRegC020[1][14])			//15 - VL_DESC
	aAdd (aRegD400[nPos], aRegC020[1][15])			//16 - VL_SERV
	aAdd (aRegD400[nPos], aTotaliza[07])			//17 - VL_SERV_NT
	aAdd (aRegD400[nPos], 0)						//18 - VL_TERC
	aAdd (aRegD400[nPos], aRegC020[1][19])			//19 - VL_DA
	aAdd (aRegD400[nPos], aRegC020[1][20])			//20 - VL_BC_ICMS
	aAdd (aRegD400[nPos], aRegC020[1][21])			//21 - VL_ICMS
	aAdd (aRegD400[nPos], aRegC020[1][25])			//22 - REF_INF_OBS
	//
	If lBloqCD
		GrvRegTrb (cAlias, nRelac, aRegD400, nItem)
	EndIf
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RegD405   ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³           TERMINAL FATURADO (MODELOS 21 E 22)              ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao e gravacao do Registro D405                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoes contidas na tabela  ³±±
±±³          ³ SFU posicionada.                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³3(1:1) Para cada D400                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAlias -> Alias do TRB que recebera as informacoes          ³±±
±±³          ³nRelac -> Flag de relacionamento.                           ³±±
±±³          ³nItem -> Contador do item para cada documento fiscal.       ³±±
±±³          ³lAchouSFX -> Flag de localizacao do registro da NF na tabela³±±
±±³          ³ SFU.                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RegD405 (cAlias, nRelac, nItem, lAchouSFX)
	Local lRet := .T.
	Local nPos := 0
	Local aReg := {}

	If (lAchouSFX)
		aAdd(aReg, {})
		nPos := Len(aReg)
		aAdd (aReg[nPos], "D405")													//01 - REG
		aAdd (aReg[nPos], IIF(SFX->(FieldPos("FX_TERMINA"))>0,SFX->FX_TERMINA,""))	//02 - TERMINAL
		aAdd (aReg[nPos], IIF(SFX->(FieldPos("FX_AREATER"))>0,SFX->FX_AREATER,""))	//03 - COD_AREA
		aAdd (aReg[nPos], IIF(SFX->(FieldPos("FX_TIPSERV"))>0,SFX->FX_TIPSERV,""))	//04 - IND_SERV
		aAdd (aReg[nPos], IIF(SFX->(FieldPos("FX_PERFIS" ))>0,SFX->FX_PERFIS ,""))	//05 - PER_FISCAL
		aAdd (aReg[nPos], IIF(SFX->(FieldPos("FX_DTINI"  ))>0,SFX->FX_DTINI  ,""))	//06 - DT_INI_SERV
		aAdd (aReg[nPos], IIF(SFX->(FieldPos("FX_DTFIM"  ))>0,SFX->FX_DTFIM  ,""))	//07 - DT_FIN_SERV
		//
		If lBloqCD
			GrvRegTrb (cAlias, nRelac, aReg, nItem)
		EndIf
	EndIf
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RegD450   ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³           ITENS DO DOCUMENTO (MODELOS 21 E 22)             ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao e gravacao do Registro D450                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoes contidas no array   ³±±
±±³          ³ aRegC300/aPartDoc para os Modelos(21 e 22) .               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³3(1:N) Para cada D400                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAlias -> Alias do TRB que recebera as informacoes          ³±±
±±³          ³nRelac -> Flag de relacionamento.                           ³±±
±±³          |aRegC300 -> Informacoes sobre os itens dos documentos fiscais³±±
±±³          ³  processados no while da funcao principal.                 ³±±
±±³          |aRegD450 -> Array contendo a estrutura do registro gravado  ³±±
±±³          | para utilizacao pelo funcao principal.                     ³±±
±±³          ³aPartDoc -> Array com informacoes sobre o participante do   ³±±
±±³          ³ documento fiscal, este array eh montado pela funcao principal³±±
±±³          ³nItem -> Contador do item para cada documento fiscal.       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RegD450 (cAlias, nRelac, aRegC300, aRegD450, aPartDoc, nItem, lAchouSFX, cEntSai, cAliasSFT, nItem, cClasFis, cCmpUm)
	Local	lRet		:= .T.
	Local	nPos		:= 0
	Local	aRegAux		:= {}
	Local	cCodClass	:= "000"
	Local	cIndRec		:= "0"

	If cEntSai == "2"
		If lBloqCD
			Reg0200()
		EndIf
	Endif

	If lAchouSFX
/*
	Alteracao inibida pois o validador atual nao aceita o campo com 4 caracteres
	Voltei da forma que era no layout anterior ate que o validador seja corrigido
	Mauro A. Goncalves
	
		If TamSx3("FX_GRPCLAS")[1] == 2
			cCodClass := SFX->FX_GRPCLAS+SFX->FX_CLASSIF
		Else
			cCodClass := Iif("A"$SFX->FX_GRPCLAS,"10","0"+SFX->FX_GRPCLAS)+SFX->FX_CLASSIF
		EndIf
*/

		cCodClass := IIF(SFX->(FieldPos("FX_CLASSIT"))>0 .AND. !Empty(SFX->FX_CLASSIT),SFX->FX_CLASSIT,"000")
		cIndRec   := SFX->FX_TIPOREC
	EndIf

	//
	aAdd(aRegD450, {})
	nPos := Len(aRegD450)
	aAdd (aRegD450[nPos], "D450")														//01 - REG
	aAdd (aRegD450[nPos], AllTrim (STR (nItem)))					//aRegC300[1][2])	//02 - NUM_ITEM
	aAdd (aRegD450[nPos], (cAliasSFT)->FT_PRODUTO)					//aRegC300[1][3])	//03 - COD_ITEM
	aAdd (aRegD450[nPos], cCodClass)													//04 - COD_CLASS
	aAdd (aRegD450[nPos], {(cAliasSFT)->FT_PRCUNIT, "VLR3"})		//aRegC300[1][4])	//05 - VL_UNIT
	aAdd (aRegD450[nPos], {(cAliasSFT)->FT_QUANT  , "VLR3"})		//aRegC300[1][5])	//06 - QTD
	aAdd (aRegD450[nPos], &(cCmpUm))								//aRegC300[1][6])	//07 - UNID
	aAdd (aRegD450[nPos], (cAliasSFT)->FT_TOTAL)					//aRegC300[1][7])	//08 - VL_ITEM
	aAdd (aRegD450[nPos], (cAliasSFT)->FT_DESCONT)					//aRegC300[1][8])	//09 - VL_DESC_I
	aAdd (aRegD450[nPos], cClasFis)									//aRegC300[1][13])	//10 - CST
	aAdd (aRegD450[nPos], (cAliasSFT)->FT_CFOP)						//aRegC300[1][14])	//11 - CFOP
	aAdd (aRegD450[nPos], (cAliasSFT)->FT_BASEICM)					//aRegC300[1][15])	//12 - VL_BC_ICMS
	aAdd (aRegD450[nPos], (cAliasSFT)->FT_ALIQICM)					//aRegC300[1][16])	//13 - ALIQ_ICMS
	aAdd (aRegD450[nPos], (cAliasSFT)->FT_VALICM)					//aRegC300[1][17])	//14 - VL_ICMS_I
	aAdd (aRegD450[nPos], cIndRec)														//15 - IND_REC
	aAdd (aRegD450[nPos], aPartDoc[4])													//16 - CNPJ
	aAdd (aRegD450[nPos], aPartDoc[5])													//17 - CPF
	aAdd (aRegD450[nPos], aPartDoc[8])													//18 - UF
	aAdd (aRegD450[nPos], aPartDoc[9])													//19 - IE
	//
	If cEntSai == "2"  // Somente o prestador deve informar este registro.
		aRegAux	:=	{aRegD450[nPos]}
		If lBloqCD
			GrvRegTrb (cAlias, nRelac, aRegAux, nItem)
		endif
	EndIf
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |D470D475  ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³D470 - CONSOLIDACAO DE NOTA FISCAL DE SERVICO DE COMUNICACAO³±±
±±³          ³  (MODELO 21) E NOTA FISCAL DE SERVICO DE TELECOMUNICACAO   ³±±
±±³          ³                           (MODELO 22)                      ³±±
±±³          ³                                                            ³±±
±±³          ³   D475 - ITENS CONSOLIDADO DE NOTA FISCAL DE SERVICO DE    ³±±
±±³          ³    COMUNICACAO (MODELO 21) E NOTA FISCAL DE SERVICO DE     ³±±
±±³          ³                TELECOMUNICACAO (MODELO 22)                 ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao do Registro D470 e D475                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoe contidas no array    ³±±
±±³          ³ aRegD400/aRegD450/aTotaliza/aPartDoc/aCmpAntSFT para os mo-³±±
±±³          ³ delos 21 e 22 que serao gravados no final da funcao principal³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³D470 - 2(varios por arquivo)                                ³±±
±±³          ³D475 - 3(1:N) Para cada D470                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|aRegD400 -> Informacoes ja gravadas no registro D400 para   ³±±
±±³          ³ utilizacao.                                                ³±±
±±³          |aTotaliza -> Totalizadores de valores para a tabela SFT.    ³±±
±±³          ³aPartDoc -> Array com informacoes sobre o participante do   ³±±
±±³          ³ documento fiscal, este array eh montado pela funcao princi-³±±
±±³          ³ pal.                                                       ³±±
±±³          |aCmpAntSFT -> Informacoes sobre o cabecalho dos documentos. ³±±
±±³          ³aRegD470 -> Array contendo as informacoes processadas pela  ³±±
±±³          ³ funcao a ser retornado para gravacao pela funcao principal.³±±
±±³          ³aRegD450 -> Informacoes ja gravadas no registro D450 para   ³±±
±±³          ³ utilizacao.                                                ³±±
±±³          ³aRegD475 -> Array contendo as informacoes processadas pela  ³±±
±±³          ³ funcao a ser retornado para gravacao pela funcao principal.³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function D470D475 (aRegD400, aTotaliza, aPartDoc, aCmpAntSFT, aRegD470, aRegD450, aRegD475)
	Local	lRet		:= .T.
	Local	nPos		:= 0
	Local	nPos2		:= 0
	Local	nI			:= 0
	Local	lAcumulou	:= .F.
	Local	nItem		:= 0
	Local	aOrdD475	:= {}
	Local	nPosX		:= 0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³REGISTRO D470 - CONSOLIDACAO DE NOTA FISCAL DE SERVICO DE COMUNICACAO (MODELO 21) E NOTA FISCAL DE SERVICO DE TELECOMUNICACAO (MODELO 22)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ((nPos := aScan (aRegD470, {|aX| aX[2]==aRegD400[1][5] .And. aX[3]==aPartDoc[11] .And. aX[4]==aRegD400[1][7] .And. aX[5]==aRegD400[1][8] .And. aX[6]==aRegD400[1][9] .And. aX[9]==aRegD400[1][12]}))==0)
		aAdd(aRegD470, {})
		nPos := Len(aRegD470)
		aAdd (aRegD470[nPos], "D470")								//01 - REG
		aAdd (aRegD470[nPos], aRegD400[1][5])						//02 - COD_MOD
		aAdd (aRegD470[nPos], IIf(aPartDoc[8]<>"EX",aPartDoc[11],SM0->M0_CODMUN))	//03 - COD_MUN
		aAdd (aRegD470[nPos], aRegD400[1][7])						//04 - SER
		aAdd (aRegD470[nPos], aRegD400[1][8])						//05 - SUB
		aAdd (aRegD470[nPos], aRegD400[1][9])						//06 - COD_CONS
		aAdd (aRegD470[nPos], "0")									//07 - QTD_CONS
		aAdd (aRegD470[nPos], "0")									//08 - QTD_CANC
		aAdd (aRegD470[nPos], aRegD400[1][12])						//09 - DT_DOC
		aAdd (aRegD470[nPos], 0)									//10 - VL_DOC
		aAdd (aRegD470[nPos], 0)									//11 - VL_DESC
		aAdd (aRegD470[nPos], 0)									//12 - VL_SERV
		aAdd (aRegD470[nPos], 0)									//13 - VL_SERV_NT
		aAdd (aRegD470[nPos], 0)									//14 - VL_TERC
		aAdd (aRegD470[nPos], 0)									//15 - VL_DA
		aAdd (aRegD470[nPos], 0)									//16 - VL_BC_ICMS
		aAdd (aRegD470[nPos], 0)									//17 - VL_ICMS
	Else
		lAcumulou := .T.
	EndIf
	aRegD470[nPos][7] := Alltrim (STR (Val (aRegD470[nPos][7]) + 1))		//07 - QTD_CONS
	If !Empty (aCmpAntSFT[7])		//Documento cancelado
		aRegD470[nPos][8] := Alltrim (STR (Val (aRegD470[nPos][8]) + 1))	//08 - QTD_CANC
	Else
		aRegD470[nPos][10] += aRegD400[1][14]									//10 - VL_DOC
		aRegD470[nPos][11] += aRegD400[1][15]									//11 - VL_DESC
		aRegD470[nPos][12] += aRegD400[1][16]									//12 - VL_SERV
		aRegD470[nPos][13] += aRegD400[1][17]									//13 - VL_SERV_NT
		aRegD470[nPos][14] += aRegD400[1][18]									//14 - VL_TERC
		aRegD470[nPos][15] += aRegD400[1][19]									//15 - VL_DA
		aRegD470[nPos][16] += aRegD400[1][20]									//16 - VL_BC_ICMS
		aRegD470[nPos][17] += aRegD400[1][21]									//17 - VL_ICMS
	EndIf
	//
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³REGISTRO D475 - ITENS CONSOLIDADO DE NOTA FISCAL DE SERVICO DE COMUNICACAO (MODELO 21) E NOTA FISCAL DE SERVICO DE TELECOMUNICACAO (MODELO 22)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nI := 1 To Len (aRegD450)
		If lBloqCD
			Reg0200(aRegD450[nI][3])
		EndIf
		If lAcumulou
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Ultima posicao para determinado item do array³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aOrdD475 := aSort(aRegD475,,,{|aX, aY| Str( aX[1],20 )+PadL( aX[3],10 )<Str( aY[1],20 )+PadL( aY[3],10 )})			
			nPosX    := aScan(aOrdD475,{|aX| aX[1]==nPos})
			While nPosX<=Len(aOrdD475) .And. aOrdD475[nPosX][1]==nPos
				nItem := Val (aOrdD475[nPosX][3])+1
				nPosX++
			End
		Else
			nItem := nI
		EndIf
		//
		aAdd(aRegD475, {})
		nPos2	:=	Len (aRegD475)
		aAdd (aRegD475[nPos2], nPos)							//01 - RELACIONAMENTO COM O REGISTRO D470
		aAdd (aRegD475[nPos2], "D475")							//02 - REG
		aAdd (aRegD475[nPos2], AllTrim (Str (nItem)))			//03 - NUM_ITEM
		aAdd (aRegD475[nPos2], aRegD450[nI][3])					//04 - COD_ITEM
		aAdd (aRegD475[nPos2], aRegD450[nI][4])					//05 - COD_CLASS
		aAdd (aRegD475[nPos2], aRegD450[nI][6])					//06 - QTD
		aAdd (aRegD475[nPos2], aRegD450[nI][7])					//07 - UNID
		aAdd (aRegD475[nPos2], aRegD450[nI][8])					//08 - VL_ITEM
		aAdd (aRegD475[nPos2], aRegD450[nI][9])					//09 - VL_DESC_I
		aAdd (aRegD475[nPos2], aRegD450[nI][10])				//10 - CST
		aAdd (aRegD475[nPos2], aRegD450[nI][11])				//11 - CFOP
		aAdd (aRegD475[nPos2], aRegD450[nI][13])				//12 - ALIQ_ICMS
		aAdd (aRegD475[nPos2], aRegD450[nI][12])				//13 - VL_BC_ICMS_I
		aAdd (aRegD475[nPos2], aRegD450[nI][14])				//14 - VL_ICMS_I

	Next nI
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |RegE020   ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³  E020 - REGISTRO MESTRE DE NOTA FISCAL (MODELO 01) E NOTA  ³±±
±±³          ³                FISCAL DE PRODUTOR (MODELO 04)              ³±±
±±³          ³                                                            ³±±
±±³          ³      E025 - ANALITICO DO DOCUMENTO (MODELO 01 E 04)        ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao e gravacao do Registro E020 e E025                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoe contidas no array    ³±±
±±³          ³ aTotaliza/aPartDoc/aCmpAntSFT para os modelos 01 E 04.     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³E020 - 2(varios por arquivo)                                ³±±
±±³          ³E025 - 3(1:N) Para cada E020                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cAlias -> Alias do TRB que recebera as informacoes          ³±±
±±³          |cEntSai -> Flag Entrada(1)/Saida(2).                        ³±±
±±³          |aCmpAntSFT -> Informacoes sobre o cabecalho dos documentos. ³±±
±±³          ³aPartDoc -> Array com informacoes sobre o participante do   ³±±
±±³          ³ documento fiscal, este array eh montado pela funcao princi-³±±
±±³          ³ pal.                                                       ³±±
±±³          |aTotaliza -> Totalizadores de valores para a tabela SFT.    ³±±
±±³          ³nRelac -> Flag de relacionamento.                           ³±±
±±³          ³cChave -> Codigo de referencia entre o documento fiscal e   ³±±
±±³          ³ este registro.                                             ³±±
±±³          ³cEspecie -> Modelo do documento fiscal                      ³±±
±±³          ³aRegE025 -> Array com informacoes analiticas do documento   ³±±
±±³          ³ fiscal processado na funcao principal para o documento.    ³±±
±±³          ³cSituaDoc -> Situacao do documento fiscal conforme funcao   ³±±
±±³          ³ RetSitDoc                                                  ³±±
±±³          ³aMVE020CF -> Indicador de complemento conforme conteudo do  ³±±
±±³          ³ parametro MV_E020CF para identifi o conteudo do campo 17   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RegE020 (cAlias, cEntSai, aCmpAntSFT, aPartDoc, aTotaliza, nRelac, cChave, cEspecie, aRegE025, cSituaDoc, aMVE020CF, cCodObs, lBlocoE)
	Local	nPos	:= 0
	Local	nCol	:= 0
	Local	lRet	:= .T.
	Local	aReg	:= {}
	Local	nI		:= 0
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³GRAVACAO REGISTRO E020 - REGISTRO MESTRE DE NOTA FISCAL (MODELO 01) E NOTA FISCAL DE PRODUTOR (MODELO 04)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aAdd (aReg, {})
	nPos	:=	Len (aReg)
	aAdd (aReg[nPos], "E020")						//01 - REG
	aAdd (aReg[nPos], STR(Val (cEntSai)-1,1))		//02 - IND_OPER
	//
	If (Empty (aCmpAntSFT[8])) .And. cEntSai=="1"
		aAdd (aReg[nPos], "1")						//03 - IND_EMIT
	ElseIf (Empty (aCmpAntSFT[8])) .And. cEntSai=="2"
		aAdd (aReg[nPos], "0")						//03 - IND_EMIT
	Else
		If ("S"$aCmpAntSFT[8])
			aAdd (aReg[nPos], "0")					//03 - IND_EMIT
		Else
			aAdd (aReg[nPos], "1")					//03 - IND_EMIT
		EndIf
	EndIf
	//			
	aAdd (aReg[nPos], IIf (cSituaDoc$"02#03#04", "", aPartDoc[1]))	//04 - COD_PART
	aAdd (aReg[nPos], cEspecie)						//05 - COD_MOD
	aAdd (aReg[nPos], cSituaDoc)					//06 - COD_SIT
	aAdd (aReg[nPos], aCmpAntSFT[2])				//07 - SER
	aAdd (aReg[nPos], aCmpAntSFT[1])				//08 - NUM_DOC
	aAdd (aReg[nPos], aCmpAntSFT[6])				//09 - DT_DOC
	aAdd (aReg[nPos], aCmpAntSFT[10])				//10 - NUM_LCTO
	aAdd (aReg[nPos], aCmpAntSFT[5])				//11 - DT_E_S
	If cSituaDoc$"02#03#04"
		For nCol := 12 to 23
			aAdd (aReg[nPos], 0)					//Adiciona valores zerados para documento cancelado
		Next
		aReg[nPos][17] := "00"
	Else
		aAdd (aReg[nPos], aTotaliza[01])			//12 - VL_CONT
		aAdd (aReg[nPos], aTotaliza[02])			//13 - VL_BC_ICMS
		aAdd (aReg[nPos], aTotaliza[03])			//14 - VL_ICMS
		aAdd (aReg[nPos], aTotaliza[05])			//15 - VL_ST
		aAdd (aReg[nPos], aTotaliza[18])			//16 - VL_COMPL
		aAdd (aReg[nPos], "00")						//17 - IND_COMPL
		If aTotaliza[18] > 0
			aReg[nPos][17] := "99"					//17 - IND_COMPL
			For nI := 1 To Len (aMVE020CF)
				If (AllTrim (aCmpAntSFT[9])$aMVE020CF[nI]) .AND. nI != 7
					aReg[nPos][17] := StrZero(nI,2)	//17 - IND_COMPL
				EndIf
			Next nI
		EndIf
		aAdd (aReg[nPos], aTotaliza[07])			//18 - VL_ISNT_ICMS
		aAdd (aReg[nPos], aTotaliza[14])			//19 - VL_OUT_ICMS
		aAdd (aReg[nPos], aTotaliza[15])			//20 - VL_BC_IPI
		aAdd (aReg[nPos], aTotaliza[06])			//21 - VL_IPI
		aAdd (aReg[nPos], aTotaliza[16])			//22 - VL_ISNT_IPI
		aAdd (aReg[nPos], aTotaliza[17])			//23 - VL_OUT_IPI
	EndIf
	aAdd (aReg[nPos],IIf (cSituaDoc$"02#03#04", "", cCodObs))	//24 - REF_INF_OBS
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Tratamento para o Simples Nacional.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ZerSimples(@aReg,nPos,{13,14,18,19})
	//
	If lBlocoE
		GrvRegTrb (cAlias, nRelac, aReg)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³GRAVACAO REGISTRO E025 - ANALITICO DO DOCUMENTO (MODELO 01 E 04)³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		GrvRegTrb (cAlias, nRelac, aRegE025)
	EndIf
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |RegE025   ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³          ANALITICO DO DOCUMENTO (MODELO 01 E 04)           ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao Registro E025                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoes da tabela SFT.      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³E025 - 3(1:N) Para cada E020                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cAliasSFT -> Alias da tabela SFT aberta no momento.         ³±±
±±³          ³aRegE025 -> Array com informacoes analiticas do documento   ³±±
±±³          ³ fiscal processado na funcao principal para o documento.    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RegE025 (cAliasSFT, aRegE025, cSituaDoc, lIss)
	Local nPos := 0
	Local lRet := .T.
	//
	If !liss
		If ((nPos := aScan (aRegE025, {|aX| aX[2]==(cAliasSFT)->FT_CFOP .And. aX[5]==(cAliasSFT)->FT_ALIQICM}))==0)
			aAdd(aRegE025, {})
			nPos	:=	Len (aRegE025)
			aAdd (aRegE025[nPos], "E025")					//01 - REG
			aAdd (aRegE025[nPos], (cAliasSFT)->FT_CFOP)		//02 - CFOP
			aAdd (aRegE025[nPos], 0)						//03 - VL_CONT_P
			aAdd (aRegE025[nPos], 0)						//04 - VL_BC_ICMS_P
			aAdd (aRegE025[nPos], IIf(lIss,0,(cAliasSFT)->FT_ALIQICM))	//05 - ALIQ_ICMS
			aAdd (aRegE025[nPos], 0)						//06 - VL_ICMS_P
			aAdd (aRegE025[nPos], 0)						//07 - VL_ST_P
			aAdd (aRegE025[nPos], 0)						//08 - VL_COMPL_P
			aAdd (aRegE025[nPos], 0)						//09 - VL_ISNT_ICMS_P
			aAdd (aRegE025[nPos], 0)						//10 - VL_OUT_ICMS_P
			aAdd (aRegE025[nPos], 0)						//11 - VL_BC_IPI_P
			aAdd (aRegE025[nPos], 0)						//12 - VL_IPI_P
			aAdd (aRegE025[nPos], 0)						//13 - VL_ISNT_IPI_P
			aAdd (aRegE025[nPos], 0)						//14 - VL_OUT_IPI_P
		EndIf
		If !(cSituaDoc$"02#03#04")
//			If !lIss
				aRegE025[nPos][3]	+=	(cAliasSFT)->FT_VALCONT		//03 - VL_CONT_P
				aRegE025[nPos][4]	+=	(cAliasSFT)->FT_BASEICM		//04 - VL_BC_ICMS_P
				aRegE025[nPos][6]	+=	(cAliasSFT)->FT_VALICM		//06 - VL_ICMS_P
				aRegE025[nPos][7]	+=	(cAliasSFT)->FT_ICMSRET+(cAliasSFT)->FT_DIFAL	//07 - VL_ST_P
				aRegE025[nPos][8]	+=	(cAliasSFT)->FT_ICMSCOM		//08 - VL_COMPL_P

				aRegE025[nPos][9]	+=	(cAliasSFT)->FT_ISENICM		//09 - VL_ISNT_ICMS_P
				//Quando configuro a TES para escriturar o Livro de ICMS/ST como ISENTO, na tabela SF3 o valor do campo 
				//  F3_ICMSRET eh transportado para o campo F3_ISENICM, ficando com os mesmos valores. Na tabela SFT, que
				//  possui o campo proprio FT_ISENRET, recebe este valor deixando o campo FT_ISENICM e FT_ICMSRET zerado.
				aRegE025[nPos][9]	+=	(cAliasSFT)->FT_ISENRET		//09 - VL_ISNT_ICMS_P
			
				aRegE025[nPos][10]	+=	(cAliasSFT)->FT_OUTRICM		//10 - VL_OUT_ICMS_P
				//Quando configuro a TES para escriturar o Livro de ICMS/ST como OUTROS, na tabela SF3 o valor do campo 
				//  F3_ICMSRET eh transportado para o campo F3_OUTRICM, ficando com os mesmos valores. Na tabela SFT, que
				//  possui o campo proprio FT_OUTRRET, recebe este valor deixando o campo FT_OUTRICM e FT_ICMSRET zerado.
				aRegE025[nPos][10]	+=	(cAliasSFT)->FT_OUTRRET		//10 - VL_OUT_ICMS_P
//			EndIf
			aRegE025[nPos][11]	+=	(cAliasSFT)->FT_BASEIPI		//11 - VL_BC_IPI_P
			aRegE025[nPos][12]	+=	(cAliasSFT)->FT_VALIPI		//12 - VL_IPI_P
			aRegE025[nPos][13]	+=	(cAliasSFT)->FT_ISENIPI		//13 - VL_ISNT_IPI_P
			aRegE025[nPos][14]	+=	(cAliasSFT)->FT_OUTRIPI		//14 - VL_OUT_IPI_P
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Tratamento para o Simples Nacional.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ZerSimples(@aRegE025,nPos,{4,6,9,10})
	Endif
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |E050E055  ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³E050 - REGISTRO MESTRE DE NOTA FISCAL DE VENDA A CONSUMIDOR ³±±
±±³          ³                         (MODELO 02)                        ³±±
±±³          ³                                                            ³±±
±±³          ³ E055 - REGISTRO ANALITICO DO DOCUMENTO FISCAL (MODELO 02)  ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao do Registro E050 e E055                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoe contidas no array    ³±±
±±³          ³ aCmpAntSFT e na tabela SFT.                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³E050 - 2(varios por arquivo)                                ³±±
±±³          ³E055 - 3(1:N) Para cada E050                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|aRegE050 -> Array contendo as informacoes processadas pela  ³±±
±±³          ³ funcao a ser retornado para gravacao pela funcao principal.³±±
±±³          |aRegE055 -> Array contendo as informacoes processadas pela  ³±±
±±³          ³ funcao a ser retornado para gravacao pela funcao principal.³±±
±±³          |aCmpAntSFT -> Informacoes sobre o cabecalho dos documentos. ³±±
±±³          ³cAliasSFT -> Alias da tabela SFT aberta no momento.         ³±±
±±³          ³cEspecie -> Modelo do documento fiscal                      ³±±
±±³          ³cSituaDoc -> Situacao do documento fiscal conforme funcao   ³±±
±±³          ³ RetSitDoc                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function E050E055 (aRegE050, aRegE055, aCmpAntSFT, cAliasSFT, cEspecie, cSituaDoc, cChaveF3)
	Local	nPos	:= 0
	Local	nPos2	:= 0
	Local	lRet	:= .T.
	Local	cDocFin	:= ""

	//Busca numero final do documento para notas em lote
	SF3->(dbSeek(cChaveF3))
	If SF3->F3_TIPO == "L"
		cDocFin := SF3->F3_DOCOR
	Else
		cDocFin := aCmpAntSFT[1]
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³REGISTRO E050 - REGISTRO MESTRE DE NOTA FISCAL DE VENDA A CONSUMIDOR (MODELO 02)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//Chave = COD_MOD+SER+DT_DOC+NUM_LCTO
	If ((nPos := aScan (aRegE050, {|aX| aX[2]==cEspecie .And. aX[3]==aCmpAntSFT[2] .And. aX[7]==aCmpAntSFT[6]}))==0)
		aAdd(aRegE050, {})
		nPos	:=	Len (aRegE050)
		aAdd (aRegE050[nPos], "E050")					//01 - REG
		aAdd (aRegE050[nPos], cEspecie)					//02 - COD_MOD
		aAdd (aRegE050[nPos], aCmpAntSFT[2])			//03 - SER
		aAdd (aRegE050[nPos], "")						//04 - SUB
		aAdd (aRegE050[nPos], aCmpAntSFT[1])			//05 - NUM_DOC_INI
		aAdd (aRegE050[nPos], cDocFin)					//06 - NUM_DOC_FIN
		aAdd (aRegE050[nPos], aCmpAntSFT[6])			//07 - DT_DOC
		aAdd (aRegE050[nPos], aCmpAntSFT[10])			//08 - NUM_LCTO
		aAdd (aRegE050[nPos], "0")						//09 - QTD_CANC
		aAdd (aRegE050[nPos], 0)						//10 - VL_CONT
		aAdd (aRegE050[nPos], 0)						//11 - VL_BC_ICMS
		aAdd (aRegE050[nPos], 0)						//12 - VL_ICMS
		aAdd (aRegE050[nPos], 0)						//13 - VL_ISNT_ICMS
		aAdd (aRegE050[nPos], 0)						//14 - VL_OUT_ICMS
		aAdd (aRegE050[nPos], "")						//15 - REF_INF_OBS
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Range de Numero de Documentos³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (aCmpAntSFT[1]<aRegE050[nPos][5])
		aRegE050[nPos][5]	:=	aCmpAntSFT[1]
	EndIf
	//
	If (aCmpAntSFT[1]>aRegE050[nPos][6])
		aRegE050[nPos][6]	:=	aCmpAntSFT[1]
	EndIf
	//
	If (cSituaDoc $ "02#03#04")	//02=Situacao de cancelada
		aRegE050[nPos][09] := Alltrim (STR (Val (aRegE050[nPos][9]) + 1))		//09 - QTD_CANC
	Else
		aRegE050[nPos][10] += (cAliasSFT)->FT_VALCONT		//10 - VL_CONT
		aRegE050[nPos][11] += (cAliasSFT)->FT_BASEICM		//11 - VL_BC_ICMS
		aRegE050[nPos][12] += (cAliasSFT)->FT_VALICM		//12 - VL_ICMS
		aRegE050[nPos][13] += (cAliasSFT)->FT_ISENICM		//13 - VL_ISNT_ICMS
		aRegE050[nPos][14] += (cAliasSFT)->FT_OUTRICM		//14 - VL_OUT_ICMS
	EndIf
	//
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³REGISTRO E055 - REGISTRO ANALITICO DO DOCUMENTO FISCAL (MODELO 02)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//Chave = Reg.E050 + CFOP + ALIQICM
	nPos2 := aScan (aRegE055, {|aX| aX[1]==nPos .And. aX[3]==(cAliasSFT)->FT_CFOP .And. aX[6]==(cAliasSFT)->FT_ALIQICM})
	If nPos2 == 0
		If lSimples
			nPos2 := aScan (aRegE055, {|aX| aX[1]==nPos .And. aX[3]==(cAliasSFT)->FT_CFOP .And. aX[6]==0 })
		EndIf
	EndIf
	
	If nPos2 == 0
		aAdd(aRegE055, {})
		nPos2	:=	Len (aRegE055)
		aAdd (aRegE055[nPos2], nPos)						//01 - RELACIONAMENTO COM O CABECALHO C420
		aAdd (aRegE055[nPos2], "E055")						//02 - REG
		aAdd (aRegE055[nPos2], (cAliasSFT)->FT_CFOP)		//03 - CFOP
		aAdd (aRegE055[nPos2], 0)							//04 - VL_CONT_P
		aAdd (aRegE055[nPos2], 0)							//05 - VL_BC_ICMS_P
		aAdd (aRegE055[nPos2], (cAliasSFT)->FT_ALIQICM)		//06 - ALIQ_ICMS
		aAdd (aRegE055[nPos2], 0)							//07 - VL_ICMS_P
		aAdd (aRegE055[nPos2], 0)							//08 - VL_ISNT_ICMS_P
		aAdd (aRegE055[nPos2], 0)							//09 - VL_OUT_ICMS_P
	EndIf
	If !(cSituaDoc $ "02#03#04")
		aRegE055[nPos2][4] += (cAliasSFT)->FT_VALCONT			//04 - VL_CONT_P
		aRegE055[nPos2][5] += (cAliasSFT)->FT_BASEICM			//05 - VL_BC_ICMS_P
		aRegE055[nPos2][7] += (cAliasSFT)->FT_VALICM			//07 - VL_ICMS_P
		aRegE055[nPos2][8] += (cAliasSFT)->FT_ISENICM			//08 - VL_ISNT_ICMS_P
		aRegE055[nPos2][9] += (cAliasSFT)->FT_OUTRICM			//09 - VL_OUT_ICMS_P
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Tratamento para o Simples Nacional.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ZerSimples(@aRegE050,nPos,{11,12,13,14})
	ZerSimples(@aRegE055,nPos2,{5,6,7,8,9})
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |RegE100   ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³         E100 - REGISTRO MESTRE DE NOTA FISCAL DE:          ³±±
±±³          ³              ENERGIA ELETRICA (MODELO 06)                  ³±±
±±³          ³            SERVICO DE COMUNICACAO (MODELO 21)              ³±±
±±³          ³          SERVICO DE TELECOMUNICACAO (MODELO 22)            ³±±
±±³          ³                                                            ³±±
±±³          ³     E105 - ANALITICO DO DOCUMENTO (MODELO 06, 21 E 22)     ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao e gravacao do Registro E100 e E105                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoe contidas no array    ³±±
±±³          ³ aTotaliza/aPartDoc/aCmpAntSFT para os modelos 06, 21 E 22. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³E100 - 2(varios por arquivo)                                ³±±
±±³          ³E105 - 3(1:N) Para cada E100                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cAlias -> Alias do TRB que recebera as informacoes          ³±±
±±³          |cEntSai -> Flag Entrada(1)/Saida(2).                        ³±±
±±³          |aCmpAntSFT -> Informacoes sobre o cabecalho dos documentos. ³±±
±±³          ³aPartDoc -> Array com informacoes sobre o participante do   ³±±
±±³          ³ documento fiscal, este array eh montado pela funcao princi-³±±
±±³          ³ pal.                                                       ³±±
±±³          |aTotaliza -> Totalizadores de valores para a tabela SFT.    ³±±
±±³          ³nRelac -> Flag de relacionamento.                           ³±±
±±³          ³cChave -> Codigo de referencia entre o documento fiscal e   ³±±
±±³          ³ este registro.                                             ³±±
±±³          ³cEspecie -> Modelo do documento fiscal                      ³±±
±±³          ³aRegE105 -> Array com informacoes analiticas do documento   ³±±
±±³          ³ fiscal processado na funcao principal para o documento.    ³±±
±±³          ³cSituaDoc -> Situacao do documento fiscal conforme funcao   ³±±
±±³          ³ RetSitDoc                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function E100E105 (cAlias, cEntSai, aCmpAntSFT, aPartDoc, aTotaliza, nRelac, cChave, cEspecie, aRegE105, cSituaDoc, lAchouSFU, lAchouSFX,cCodObs)
	Local nPos		:= 0
	Local nPos2		:= 0
	Local lRet		:= .T.
	Local aRegE100	:= {}
	Local cCodCons	:= "99"
	//
	// Busco o codigo do consumo para NFCEE(modelo 6) ou para NTST/NTSC(modelo 21/22)
	If lAchouSFU
		cCodCons := IIF(SFU->(FieldPos("FU_CODUNC"))>0,SFU->FU_CODUNC,"")
	ElseIf lAchouSFX
		cCodCons := IIF(SFX->(FieldPos("FX_CODUNC"))>0,SFX->FX_CODUNC,"")
	EndIf
	If Empty(cCodCons)
		cCodCons := "99"
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³GRAVACAO REGISTRO E100 - REGISTRO MESTRE DE NOTA FISCAL ENERGIA ELETRICA (MODELO 06), COMUNICACAO (MODELO 21) E TELECOMUNICACAO (MODELO 22)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aAdd (aRegE100, {})
	nPos := Len(aRegE100)
	aAdd (aRegE100[nPos], "E100")						//01 - REG
	aAdd (aRegE100[nPos], STR(Val (cEntSai)-1,1))		//02 - IND_OPER
	//
	If (Empty (aCmpAntSFT[8])) .And. cEntSai=="1"
		aAdd (aRegE100[nPos], "1")						//03 - IND_EMIT
	ElseIf (Empty (aCmpAntSFT[8])) .And. cEntSai=="2"
		aAdd (aRegE100[nPos], "0")						//03 - IND_EMIT
	Else
		If ("S"$aCmpAntSFT[8])
			aAdd (aRegE100[nPos], "0") 					//03 - IND_EMIT
		Else
			aAdd (aRegE100[nPos], "1")					//03 - IND_EMIT
		EndIf
	EndIf
	//
	aAdd (aRegE100[nPos], iif(cCodCons$"  99",aPartDoc[1],''))	   //04 - COD_PART
	aAdd (aRegE100[nPos], cEspecie)						//05 - COD_MOD
	aAdd (aRegE100[nPos], cSituaDoc)					//06 - COD_SIT
	aAdd (aRegE100[nPos], aCmpAntSFT[2])				//07 - SER
	aAdd (aRegE100[nPos], "")							//08 - SUB
	aAdd (aRegE100[nPos], cCodCons)						//09 - COD_CONS
	aAdd (aRegE100[nPos], iif(cCodCons$"  99",aCmpAntSFT[1],''))	//10 - NUM_DOC
	aAdd (aRegE100[nPos], aCmpAntSFT[6])				//11 - DT_DOC
	aAdd (aRegE100[nPos], aCmpAntSFT[10])				//12 - NUM_LCTO
	aAdd (aRegE100[nPos], aCmpAntSFT[5])				//13 - DT_E_S
	aAdd (aRegE100[nPos], "1")							//14 - QTD_DOC	--	SEMPRE 1 (O MESMO), POIS COMO PODEMOS VER EH POR DOCUMENTO
	aAdd (aRegE100[nPos], IIf (cSituaDoc $ "02#03#04", "1", "0"))		//15 - QTD_CANC
	aAdd (aRegE100[nPos], 0 )							//16 - VL_CONT
	aAdd (aRegE100[nPos], 0 )							//17 - VL_BC_ICMS
	aAdd (aRegE100[nPos], 0 )							//18 - VL_ICMS
	aAdd (aRegE100[nPos], 0 )							//19 - VL_ISNT_ICMS
	aAdd (aRegE100[nPos], 0 )							//20 - VL_OUT_ICMS
	aAdd (aRegE100[nPos], cCodObs)						//21 - REF_INF_OBS

	If !(cSituaDoc $ "02#03#04" )	//02=Situacao de cancelada		
		aRegE100[nPos][16] += aTotaliza[01]				//10 - VL_CONT
		aRegE100[nPos][17] += aTotaliza[02]				//11 - VL_BC_ICMS
		aRegE100[nPos][18] += aTotaliza[03]				//12 - VL_ICMS
		aRegE100[nPos][19] += aTotaliza[07]				//13 - VL_ISNT_ICMS
		aRegE100[nPos][20] += aTotaliza[14]				//14 - VL_OUT_ICMS
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³GRAVACAO REGISTRO E105 - ANALITICO DOS DOCUMENTOS (MODELO 06, 21 E 22)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !(cSituaDoc $ "02#03#04")
		aAdd (aRegE105, {})
		nPos2 := Len(aRegE105)
		aAdd (aRegE105[nPos2], "E105")					//01 - REG
		aAdd (aRegE105[nPos2], aCmpAntSFT[9])			//02 - CFOP
		aAdd (aRegE105[nPos2], aTotaliza[1])			//03 - VL_CONT_P
		aAdd (aRegE105[nPos2], aTotaliza[2])			//04 - VL_BC_ICMS_P
		aAdd (aRegE105[nPos2], aCmpAntSFT[11])			//05 - ALIQ_ICMS
		aAdd (aRegE105[nPos2], aTotaliza[3])			//06 - VL_ICMS_P
		aAdd (aRegE105[nPos2], aTotaliza[7])			//07 - VL_ISNT_ICMS_P
		aAdd (aRegE105[nPos2], aTotaliza[14])			//08 - VL_OUT_ICMS_P

		ZerSimples(@aRegE105,nPos2,{4,5,6,7,8})

	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Tratamento para o Simples Nacional.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ZerSimples(@aRegE100,nPos,{17,18,19,20})

	GrvRegTrb (cAlias, nRelac, aRegE100)
	If !(cSituaDoc $ "02#03#04")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³GRAVACAO REGISTRO E105 - ANALITICO DOS DOCUMENTOS (MODELO 06, 21 E 22)³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		GrvRegTrb (cAlias, nRelac, aRegE105)
	EndIf
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |RegE120   ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³  E120 - NOTA FISCAL DE SERVICO DE TRANSPORTE (MODELO 07)   ³±±
±±³          ³         CONHECIMENTO DE FRETE (MODELO 08)                  ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao do Registro E120                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoe contidas no array    ³±±
±±³          ³ aPartDoc/aCmpAntSFT para os modelos 07, 08.                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³E120 - 2(varios por arquivo)                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cAlias -> Alias do TRB que recebera as informacoes          ³±±
±±³          ³nRelac -> Flag de relacionamento.                           ³±±
±±³          ³aRegE120 -> Array passado por referencia para receber infor-³±±
±±³          ³ macoes a serem gravados posteriormente.                    ³±±
±±³          |cEntSai -> Flag Entrada(1)/Saida(2).                        ³±±
±±³          ³aPartDoc -> Array com informacoes sobre o participante do   ³±±
±±³          ³ documento fiscal, este array eh montado pela funcao princi-³±±
±±³          ³ pal.                                                       ³±±
±±³          ³cEspecie -> Modelo do documento fiscal                      ³±±
±±³          ³cSituaDoc -> Situacao do documento fiscal conforme funcao   ³±±
±±³          ³ RetSitDoc                                                  ³±±
±±³          |aCmpAntSFT -> Informacoes sobre o cabecalho dos documentos. ³±±
±±³          |cAliasSFT -> Alias da tabela SFT em processamento.          ³±±
±±³          ³cChave -> Codigo de referencia entre o documento fiscal e   ³±±
±±³          ³ este registro.                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RegE120 (cAlias, nRelac, aRegE120, cEntSai, aPartDoc, cEspecie, cSituaDoc, aCmpAntSFT, cAliasSFT, cChave, cCodObs)
	Local lRet := .T.
	Local nPos := 0

	nPos := aScan (aRegE120, {|aX| aX[13]==(cAliasSFT)->FT_CFOP .And. aX[16]== (cAliasSFT)->FT_ALIQICM })
	If nPos == 0
		If lSimples
			nPos := aScan (aRegE120, {|aX| aX[13]==(cAliasSFT)->FT_CFOP .And. aX[16]== 0 })
		EndIf
	EndIf

	If nPos == 0
		aAdd (aRegE120, {})
		nPos := Len(aRegE120)
		aAdd (aRegE120[nPos], "E120")						//01 - REG
		aAdd (aRegE120[nPos], STR(Val (cEntSai)-1,1))		//02 - IND_OPER
		//
		If (Empty (aCmpAntSFT[8])) .And. cEntSai=="1"
			aAdd (aRegE120[nPos], "1")						//03 - IND_EMIT
		ElseIf (Empty (aCmpAntSFT[8])) .And. cEntSai=="2"
			aAdd (aRegE120[nPos], "0")						//03 - IND_EMIT
		Else
			If ("S"$aCmpAntSFT[8])
				aAdd (aRegE120[nPos], "0")					//03 - IND_EMIT
			Else
				aAdd (aRegE120[nPos], "1")					//03 - IND_EMIT
			EndIf
		EndIf
		//
		aAdd (aRegE120[nPos], IIf (cSituaDoc$"02#03#04", "", aPartDoc[1]))	//04 - COD_PART
		aAdd (aRegE120[nPos], cEspecie)						//05 - COD_MOD
		aAdd (aRegE120[nPos], cSituaDoc)					//06 - COD_SIT
		aAdd (aRegE120[nPos], aCmpAntSFT[2])				//07 - SER
		aAdd (aRegE120[nPos], "")							//08 - SUB
		aAdd (aRegE120[nPos], aCmpAntSFT[1])				//09 - NUM_DOC
		aAdd (aRegE120[nPos], aCmpAntSFT[6])				//10 - DT_DOC
		aAdd (aRegE120[nPos], aCmpAntSFT[10])				//11 - NUM_LCTO
		aAdd (aRegE120[nPos], aCmpAntSFT[5])				//12 - DT_A_P
		aAdd (aRegE120[nPos], (cAliasSFT)->FT_CFOP)			//13 - CFOP
		aAdd (aRegE120[nPos], 0)							//14 - VL_CONT
		aAdd (aRegE120[nPos], 0)							//15 - VL_BC_ICMS
		aAdd (aRegE120[nPos], (cAliasSFT)->FT_ALIQICM)		//16 - ALIQ_ICMS
		aAdd (aRegE120[nPos], 0)							//17 - VL_ICMS
		aAdd (aRegE120[nPos], 0)							//18 - VL_ISNT_ICMS
		aAdd (aRegE120[nPos], 0)							//19 - VL_OUT_ICMS
		aAdd (aRegE120[nPos], cCodObs)						//20 - REF_INF_OBS
	EndIf
	If !(cSituaDoc$"02#03#04")
		aRegE120[nPos][14] += (cAliasSFT)->FT_VALCONT		//14 - VL_CONT
		aRegE120[nPos][15] += (cAliasSFT)->FT_BASEICM		//15 - VL_BC_ICMS
		aRegE120[nPos][17] += (cAliasSFT)->FT_VALICM		//17 - VL_ICMS
		aRegE120[nPos][18] += (cAliasSFT)->FT_ISENICM		//18 - VL_ISNT_ICMS
		aRegE120[nPos][19] += (cAliasSFT)->FT_OUTRICM		//19 - VL_OUT_ICMS
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Tratamento para o Simples Nacional.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ZerSimples(@aRegE120,nPos,{15,16,17,18,19})
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |RegE300   ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³               PERIODO DE APURACAO DO ICMS                  ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao e gravacao do Registro E300                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb.                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³2(um por periodo)                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cAlias -> Alias do TRB que devera conter as informacoes do  ³±±
±±³          ³ meio-magnetico.                                            ³±±
±±³          ³dDataDe -> Data incial do periodo de apuracao.              ³±±
±±³          ³dDataAte -> Data final do periodo de apuracao.              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RegE300 (cAlias, dDataDe, dDataAte)

Local aReg := {}
Local lRet := .T.
Local nPos := 0

aAdd (aReg, {})
nPos := Len(aReg)
aAdd (aReg[nPos], "E300")	//01 - REG
aAdd (aReg[nPos], dDataDe)	//02 - DT_INI
aAdd (aReg[nPos], dDataAte)	//03 - DT_FIN
	
GrvRegTrb (cAlias,, aReg)

Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |E310E320  ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³     E310 - CONSOLIDACAO DOS VALORES DE ICMS POR CFOP       ³±±
±±³          ³                                                            ³±±
±±³          ³  E320 - TOTALIZACAO DOS VALORES POR UNIDADE DE FEDERACAO   ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao do Registros E310 e E320                          |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoe contidas no array    ³±±
±±³          ³ aCmpAntSFT e na tabela SFT.                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³E310 - 3(varios por periodo)                                ³±±
±±³          ³E320 - 3(varios por periodo)                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cAliasSFT -> Alias da tabela SFT aberta no momento.         ³±±
±±³          ³ funcao a ser retornado para gravacao pela funcao principal.³±±
±±³          |cEntSai -> Flag Entrada(1)/Saida(2).                        ³±±
±±³          |aRegE310 -> Array contendo as informacoes processadas pela  ³±±
±±³          ³ funcao a ser retornado para gravacao pela funcao principal.³±±
±±³          |aRegE320 -> Array contendo as informacoes processadas pela  ³±±
±±³          ³ funcao a ser retornado para gravacao pela funcao principal.³±±
±±³          ³cSituaDoc -> Situacao do documento fiscal.                  ³±±
±±³          ³lIss -> Indicador de nota fiscal com incidencia do ISS      ³±±
±±³          ³cEspecie -> Especie do documento fiscal                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function E310E320 (cAliasSFT, cEntSai, aRegE310, aRegE320, cSituaDoc, lIss,cEspecie)
	Local	nPos	:= 0
	Local	nPos2	:= 0
	Local	lRet	:= .T.

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³REGISTRO E310 - CONSOLIDACAO DOS VALORES DE ICMS POR CFOP ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ((nPos := aScan (aRegE310, {|aX| aX[2]==(cAliasSFT)->FT_CFOP}))==0)
		aAdd(aRegE310, {})
		nPos := Len(aRegE310)
		aAdd (aRegE310[nPos], "E310")							//01 - REG
		aAdd (aRegE310[nPos], (cAliasSFT)->FT_CFOP)				//02 - CFOP
		aAdd (aRegE310[nPos], 0)								//03 - VL_CONT
		aAdd (aRegE310[nPos], 0)								//04 - VL_BC_ICMS
		aAdd (aRegE310[nPos], 0)								//05 - VL_ICMS
		aAdd (aRegE310[nPos], 0)								//06 - VL_ST
		aAdd (aRegE310[nPos], 0)								//07 - VL_COMPL
		aAdd (aRegE310[nPos], 0)								//08 - VL_ISNT_ICMS
		aAdd (aRegE310[nPos], 0)								//09 - VL_OUT_ICMS
	EndIf
	If !(cSituaDoc$"02#03#04")
		If !lIss
			aRegE310[nPos][3]	+=	(cAliasSFT)->FT_VALCONT		//03 - VL_CONT
			aRegE310[nPos][4]	+=	(cAliasSFT)->FT_BASEICM		//04 - VL_BC_ICMS
			aRegE310[nPos][5]	+=	(cAliasSFT)->FT_VALICM		//05 - VL_ICMS
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³* Para os modelos abaixo que tiverem DIFERENCIAL ALIQUOTA,   |
			//|  nao devo enviar neste campo, basta considerar nos ajustes. ³
			//³* Para os modelos abaixo que tiverem SUBSTITUICAO TRIBUTARIA,|
			//|  NAO devo enviar neste campo, pois o mesmo estah destinado  ³
			//|  aos registros C's(C020 - Campo 23 - modelo 01 e 04).       |
			//|                                                             |
			//³06 - NOTA FISCAL/CONTA DE ENERGIA ELETRICA                   ³
			//³21 - NOTA FISCAL DE SERVICO DE COMUNICACAO                   ³
			//³22 - NOTA FISCAL DE SERVICO DE TELECOMUNICACAO               ³
			//³07 - NOTA FISCAL SERVICO DE TRANSPORTE - SAIDA/ENTRADA       ³
			//³08 - CONHECIMENTO DE TRANSPORTE RODOVIARIO - SAIDA/ENTRADA   ³
			//³09 - CONHECIMENTO DE TRANSPORTE AQUAVIARIO - ENTRADA         ³
			//³10 - CONHECIMENTO DE TRANSPORTE AEREO - ENTRADA              ³
			//³11 - CONHECIMENTO DE TRANSPORTE FERROVIARIO - ENTRADA        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !(cEspecie$"2D#02#06#07#08#09#10#11#21#22#57#65")
				aRegE310[nPos][6]	+=	(cAliasSFT)->FT_ICMSRET + (cAliasSFT)->FT_DIFAL	//06 - VL_ST
				aRegE310[nPos][7]	+=	(cAliasSFT)->FT_ICMSCOM	//07 - VL_COMPL
			EndIf
			aRegE310[nPos][8]	+=	(cAliasSFT)->FT_ISENICM		//08 - VL_ISNT_ICMS_P
			//Quando configuro a TES para escriturar o Livro de ICMS/ST como ISENTO, na tabela SF3 o valor do campo 
			//  F3_ICMSRET eh transportado para o campo F3_ISENICM, ficando com os mesmos valores. Na tabela SFT, que
			//  possui o campo proprio FT_ISENRET, recebe este valor deixando o campo FT_ISENICM e FT_ICMSRET zerado.
			aRegE310[nPos][8]	+=	(cAliasSFT)->FT_ISENRET			//08 - VL_ISNT_ICMS_P
			If cEspecie<>"2D"
				aRegE310[nPos][9]	+=	(cAliasSFT)->FT_OUTRICM		//09 - VL_OUT_ICMS_P
			Else
				aRegE310[nPos][8]	+= iif("41"$(cAliasSFT)->FT_CLASFIS,(cAliasSFT)->FT_OUTRICM,0)	//08 - VL_ISNT_ICMS_P
			EndIf
			//Quando configuro a TES para escriturar o Livro de ICMS/ST como OUTROS, na tabela SF3 o valor do campo 
			//  F3_ICMSRET eh transportado para o campo F3_OUTRICM, ficando com os mesmos valores. Na tabela SFT, que
			//  possui o campo proprio FT_OUTRRET, recebe este valor deixando o campo FT_OUTRICM e FT_ICMSRET zerado.
			aRegE310[nPos][9]	+=	(cAliasSFT)->FT_OUTRRET		//09 - VL_OUT_ICMS_P
		EndIf
	EndIf
	//
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³REGISTRO E320 - TOTALIZACAO DOS VALORES POR UNIDADE DE FEDERACAO³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ((nPos2 := aScan (aRegE320, {|aX| aX[2]==(STR(Val (cEntSai)-1,1)) .And. aX[3]==(cAliasSFT)->FT_ESTADO}))==0)
		aAdd(aRegE320, {})
		nPos2	:=	Len (aRegE320)
		aAdd (aRegE320[nPos2], "E320")	 	   					//01 - REG
		aAdd (aRegE320[nPos2], STR(Val (cEntSai)-1,1))			//02 - IND_OPER
		aAdd (aRegE320[nPos2], (cAliasSFT)->FT_ESTADO)			//03 - UF
		aAdd (aRegE320[nPos2], 0)								//04 - VL_CONT
		aAdd (aRegE320[nPos2], 0)								//05 - VL_BC_ICMS
		aAdd (aRegE320[nPos2], 0)								//06 - VL_ICMS
		aAdd (aRegE320[nPos2], 0)								//07 - VL_ST
		aAdd (aRegE320[nPos2], 0)								//08 - VL_COMPL
		aAdd (aRegE320[nPos2], 0)								//09 - VL_ISNT_ICMS
		aAdd (aRegE320[nPos2], 0)								//10 - VL_OUT_ICMS
	EndIf
	If !(cSituaDoc$"02#03#04")
		aRegE320[nPos2][4]	+=	(cAliasSFT)->FT_VALCONT			//04 - VL_CONT
		If !lIss
			aRegE320[nPos2][5]	+=	(cAliasSFT)->FT_BASEICM		//05 - VL_BC_ICMS
			aRegE320[nPos2][6]	+=	(cAliasSFT)->FT_VALICM		//06 - VL_ICMS
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Quando se tratar de Transporte e houver DIFERENCIAL ALIQUOTA, nao devo enviar neste campo,|
			//|  basta considerar nos ajustes.                                                           ³
			//³Quando se tratar de Transporte e houver ST nao devo enviar neste campo, pois este somente |
			//|  se relaciona com os registro C's                                                        |
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !(cEspecie$"#07#08#09#10#11#57")
				aRegE320[nPos2][7]	+=	(cAliasSFT)->FT_ICMSRET	//07 - VL_ST
				aRegE320[nPos2][8]	+=	(cAliasSFT)->FT_ICMSCOM	//08 - VL_COMPL
			EndIf
			aRegE320[nPos2][9]	+=	(cAliasSFT)->FT_ISENICM		//09 - VL_ISNT_ICMS_P
			//Quando configuro a TES para escriturar o Livro de ICMS/ST como ISENTO, na tabela SF3 o valor do campo 
			//  F3_ICMSRET eh transportado para o campo F3_ISENICM, ficando com os mesmos valores. Na tabela SFT, que
			//  possui o campo proprio FT_ISENRET, recebe este valor deixando o campo FT_ISENICM e FT_ICMSRET zerado.
			aRegE320[nPos2][9]	+=	(cAliasSFT)->FT_ISENRET		//09 - VL_ISNT_ICMS_P

			If cEspecie<>"2D"
				aRegE320[nPos2][10]	+=	(cAliasSFT)->FT_OUTRICM		//10 - VL_OUT_ICMS_P
			EndIf	
			//Quando configuro a TES para escriturar o Livro de ICMS/ST como OUTROS, na tabela SF3 o valor do campo 
			//  F3_ICMSRET eh transportado para o campo F3_OUTRICM, ficando com os mesmos valores. Na tabela SFT, que
			//  possui o campo proprio FT_OUTRRET, recebe este valor deixando o campo FT_OUTRICM e FT_ICMSRET zerado.
			aRegE320[nPos2][10]	+=	(cAliasSFT)->FT_OUTRRET		//10 - VL_OUT_ICMS_P
		EndIf
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Tratamento para o Simples Nacional.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ZerSimples(@aRegE310,nPos,{4,5,8,9})
	ZerSimples(@aRegE320,nPos2,{5,6,9,10})
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |RegE330   ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³        TOTALIZACAO DOS VALORES DE ENTRADAS E SAIDAS        ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao e gravacao do Registro E330                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoe contidas no array    ³±±
±±³          ³ aRegE310.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³E330 - 3(varios por periodo)                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cAlias -> Alias do TRB para gravacao.                       ³±±
±±³          |aRegE310 -> Array contendo as informacoes por CFOP para     ³±±
±±³          ³ utilizacao.                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RegE330 (cAlias, aRegE310)
	Local	lRet	:= .T.
	Local	nPos	:= 0
	Local	aReg	:= {}
	Local	nX		:= 0
	//
	For nX := 1 To Len (aRegE310)
		cIndTot	:=	Left (aRegE310[nX][2], 1)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Consolidado CFOPs 1, 2, 3, 5, 6, 7.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ((nPos := aScan (aReg, {|aX| aX[2]==cIndTot}))==0)
			aAdd(aReg, {})
			nPos	:=	Len (aReg)
			aAdd (aReg[nPos], "E330")	   				//01 - REG
			aAdd (aReg[nPos], cIndTot)					//02 - IND_TOT
			aAdd (aReg[nPos], 0)						//03 - VL_CONT
			aAdd (aReg[nPos], 0)						//04 - VL_BC_ICMS
			aAdd (aReg[nPos], 0)						//05 - VL_ICMS
			aAdd (aReg[nPos], 0)						//06 - VL_ST
			aAdd (aReg[nPos], 0)						//07 - VL_COMPL
			aAdd (aReg[nPos], 0)						//08 - VL_ISNT_ICMS
			aAdd (aReg[nPos], 0)						//09 - VL_OUT_ICMS
		EndIf
		aReg[nPos][3]	+=	aRegE310[nX][3]				//03 - VL_CONT
		aReg[nPos][4]	+=	aRegE310[nX][4]				//04 - VL_BC_ICMS
		aReg[nPos][5]	+=	aRegE310[nX][5]				//05 - VL_ICMS
		aReg[nPos][6]	+=	aRegE310[nX][6]				//06 - VL_ST
		aReg[nPos][7]	+=	aRegE310[nX][7]				//07 - VL_COMPL
		aReg[nPos][8]	+=	aRegE310[nX][8]				//08 - VL_ISNT_ICMS
		aReg[nPos][9]	+=	aRegE310[nX][9]				//09 - VL_OUT_ICMS
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Totalizando 4, 8³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cIndTot	:=	Iif (Val(cIndTot)<4, "4", "8")
		If ((nPos := aScan (aReg, {|aX| aX[2]==cIndTot}))==0)
			aAdd(aReg, {})
			nPos	:=	Len (aReg)
			aAdd (aReg[nPos], "E330")	   				//01 - REG
			aAdd (aReg[nPos], cIndTot)					//02 - IND_TOT
			aAdd (aReg[nPos], 0)						//03 - VL_CONT
			aAdd (aReg[nPos], 0)						//04 - VL_BC_ICMS
			aAdd (aReg[nPos], 0)						//05 - VL_ICMS
			aAdd (aReg[nPos], 0)						//06 - VL_ST
			aAdd (aReg[nPos], 0)						//07 - VL_COMPL
			aAdd (aReg[nPos], 0)						//08 - VL_ISNT_ICMS
			aAdd (aReg[nPos], 0)						//09 - VL_OUT_ICMS
		EndIf
		aReg[nPos][3]	+=	aRegE310[nX][3]				//03 - VL_CONT
		aReg[nPos][4]	+=	aRegE310[nX][4]				//04 - VL_BC_ICMS
		aReg[nPos][5]	+=	aRegE310[nX][5]				//05 - VL_ICMS
		aReg[nPos][6]	+=	aRegE310[nX][6]				//06 - VL_ST
		aReg[nPos][7]	+=	aRegE310[nX][7]				//07 - VL_COMPL
		aReg[nPos][8]	+=	aRegE310[nX][8]				//08 - VL_ISNT_ICMS
		aReg[nPos][9]	+=	aRegE310[nX][9]				//09 - VL_OUT_ICMS
	Next (nX)
	//
	GrvRegTrb (cAlias,, aReg)
Return (lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |RegE360   ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³                   APURACAO DO ICMS                         ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao e gravacao do Registro E360                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoe contidas na apuracao ³±±
±±³          ³ de ICMS.                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³E360 - 3(varios por periodo)                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cAlias -> Alias do TRB para gravacao.                       ³±±
±±³          ³dDataAte -> Data final do periodo de apuracao.              ³±±
±±³          ³cNrLivro -> Numero do livro selecionado no wizard.          ³±±
±±³          ³nAcImport -> Valor de ICMS da Importacao.                   ³±±
±±³          ³nAcRetInter -> Valor Substituicao Tributaria nas operacoes  ³±±
±±³          ³ interestaduais.                                            ³±±
±±³          ³nDbCompIcm -> Total das NFs de complemento de ICMS - saidas ³±±
±±³          ³nCrCompIcm ->Total das NFs de complemento de ICMS - entradas³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RegE360 (cAlias,dDataAte,cNrLivro,nAcImport,nAcRetInter,nDbCompIcm,nCrCompIcm,aLog,nAcRetEsta,nRelac,cCodObs,aReg0450,dDataDe)
	Local	lRet		:= .T.
	Local	nPos		:= 0
	Local	aReg		:= {}
	Local	nX			:= 0
	Local	nY			:= 0
	Local	nApuracao	:= GetSx1 (PadR("MTA951",10), "04", .T.)	//1-Decendial, 2-Quinzenal, 3-Mensal, 4-Semestral ou 5-Anual
	Local	nPeriodo	:= 1								//GetSx1 ("MTA951", "05", .T.)	//1-1., 2-2., 3-3.	
	Local	aApICM		:= {}
	Local	aApST		:= {}
	Local	aApSIM		:= {}
	Local	nVL_01		:= 0
	Local	nVL_02		:= 0
	Local	nVL_03		:= 0
	Local	nVL_04		:= 0
	Local	nVL_05		:= 0
	Local	nVL_06		:= 0
	Local	nVL_07		:= 0
	Local	nVL_08		:= 0
	Local	nVL_09		:= 0
	Local	nVL_10		:= 0
	Local	nVL_11		:= 0
	Local	nVL_12		:= 0
	Local	nVL_13		:= 0
	Local	nVL_14		:= 0
	Local	nVL_15		:= 0
	Local	nVL_16		:= 0
	Local	nVL_17		:= 0
	Local	nVL_18		:= 0
	Local	nVL_19		:= 0
	Local	nVL_20		:= 0
	Local	nVL_99		:= 0
	Local	aRegE340	:= {}
	Local	cProc		:= ""
	Local	lUsaSped	:= SuperGetMv("MV_USASPED",,.T.)
	Local	cAliasCDH	:= "CDH"
	Local	lTop		:= .F.
	Local	cCodAju		:= ""
	Local	cObs		:= "Complemento de ICMS  "
	Local	nDifal87DF	:= 0

	#IFDEF TOP
		lTop := .T.
	#ENDIF

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Fixo que o periodo de geracao podera ser somente Mensal ou Anual.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (nApuracao==1) .Or. (nApuracao==2)
		nApuracao := 3
	ElseIf (nApuracao==4)
		nApuracao := 5
	EndIf

	If lSimples
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Leio o arquivo de apuracao do Simples Federal³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aApSIM	:=	FisApur ("SN", Year (dDataAte), Month (dDataAte), nApuracao, nPeriodo, cNrLivro, .F., {}, 1, .F., "")
		If len(aApSIM) > 0

			nVL_03 := nVL_04 := nVL_12 := nVL_14  := Iif (aScan (aApSIM, {|a| a[1]=="003"})<>0, aApSIM[aScan (aApSIM, {|a| a[1]=="003"})][3], 0)

			aAdd(aRegE340, {})
			nPos := Len(aRegE340)
			aAdd (aRegE340[nPos], "E340")				//01 - REG
			aAdd (aRegE340[nPos], "298")				//02 - COD_AJ
			aAdd (aRegE340[nPos], nVL_03)				//03 - VL_AJ
			aAdd (aRegE340[nPos], "")					//04 - NUM_DA
			aAdd (aRegE340[nPos], "")					//05 - NUM_PROC
			aAdd (aRegE340[nPos], "0")					//06 - IND_PROC
			aAdd (aRegE340[nPos], "SIMPLES NACIONAL")	//07 - PROC
			aAdd (aRegE340[nPos], cCodObs)				//08 - REF_INF_OBS

			aSort (aRegE340,,,{|x, y| x[2]<y[2]})
			GrvRegTrb (cAlias,, aRegE340)
		Else
			CriaLog(@aLog, 3)
		EndIf
	Else
		//Apuracao ICMS
		If lUsaSped .And. lTop
			//Com base na CHD
			ApuICMSCDH("CDH",@cAliasCDH,{"IC",STR(nApuracao,1),STR(nPeriodo,1),DTOS(dDataAte),cNrLivro})
			While !(cAliasCDH)->(EOF())
				AADD(aApICM,{AllTrim((cAliasCDH)->CDH_LINHA),(cAliasCDH)->CDH_DESC,(cAliasCDH)->CDH_VALOR,AllTrim((cAliasCDH)->CDH_SUBITEM),(cAliasCDH)->CDH_GNRE,(cAliasCDH)->CDO_DESCR2})
				(cAliasCDH)->(DbSkip())
			Enddo
			(cAliasCDH)->(DbCloseArea())
		Else
			//Com base no arquivo de apuracao ICMS
			aApICM	:=	FisApur ("IC", Year (dDataAte), Month (dDataAte), nApuracao, nPeriodo, cNrLivro, .F., {}, 1, .F., "")		
		Endif
		nVL_01	:=	Iif (aScan (aApICM, {|a| a[1]=="001"})<>0,		aApICM[aScan (aApICM, {|a| a[1]=="001"})][3], 0)
		nVL_02	:=	Iif (aScan (aApICM, {|a| a[4]=="002.00"})<>0,	aApICM[aScan (aApICM, {|a| a[4]=="002.00"})][3], 0)
		nVL_03	:=	Iif (aScan (aApICM, {|a| a[4]=="003.00"})<>0,	aApICM[aScan (aApICM, {|a| a[4]=="003.00"})][3], 0)
		nVL_04	:=	Iif (aScan (aApICM, {|a| a[1]=="004"})<>0,		aApICM[aScan (aApICM, {|a| a[1]=="004"})][3], 0)
		nVL_05	:=	Iif (aScan (aApICM, {|a| a[1]=="005"})<>0,		aApICM[aScan (aApICM, {|a| a[1]=="005"})][3], 0)
		nVL_06	:=	Iif (aScan (aApICM, {|a| a[4]=="006.00"})<>0,	aApICM[aScan (aApICM, {|a| a[4]=="006.00"})][3], 0)
		nVL_07	:=	Iif (aScan (aApICM, {|a| a[4]=="007.00"})<>0,	aApICM[aScan (aApICM, {|a| a[4]=="007.00"})][3], 0)
		nVL_08	:=	Iif (aScan (aApICM, {|a| a[1]=="008"})<>0,		aApICM[aScan (aApICM, {|a| a[1]=="008"})][3], 0)
		nVL_09	:=	Iif (aScan (aApICM, {|a| a[1]=="009"})<>0,		aApICM[aScan (aApICM, {|a| a[1]=="009"})][3], 0)
		nVL_10	:=	Iif (aScan (aApICM, {|a| a[1]=="010"})<>0,		aApICM[aScan (aApICM, {|a| a[1]=="010"})][3], 0)
		nVL_11	:=	Iif (aScan (aApICM, {|a| a[1]=="014"})<>0,		aApICM[aScan (aApICM, {|a| a[1]=="014"})][3], 0)
		nVL_12	:=	Iif (aScan (aApICM, {|a| a[1]=="011"})<>0,		aApICM[aScan (aApICM, {|a| a[1]=="011"})][3], 0)
		nVL_13	:=	Iif (aScan (aApICM, {|a| a[4]=="012.00"})<>0,	aApICM[aScan (aApICM, {|a| a[4]=="012.00"})][3], 0)
		nVL_14	:=	Iif (aScan (aApICM, {|a| a[1]=="013"})<>0,		aApICM[aScan (aApICM, {|a| a[1]=="013"})][3], 0)
		//Apuracao ICMS/ST
		aApST	:=	FisApur ("ST", Year (dDataAte), Month (dDataAte), nApuracao, nPeriodo, cNrLivro, .F., {}, 1, .F., "")
		nVL_15	:=	Iif (aScan (aApST, {|a| a[1]=="006"})<>0, aApST[aScan (aApST, {|a| a[1]=="006"})][3], 0)
		nVL_16	:=	nAcRetEsta  // ICMS substituto pelas saidas para o Estado.
		//Outros valores
		//Diferencial de aliquota(nVL_17) deve ser lancado com Ajuste na Apuracao de ICMS, pois conforme consulta este eh o procedimento correto.
		nVL_17	:=	0 //Iif (aScan (aApICM, {|a| a[1]=="016"})<>0, aApICM[aScan (aApICM, {|a| a[1]=="016"})][3], 0)
		nVL_18	:=	nAcImport
		nVL_19	:=	0
		nVL_20	:=	0
		nVL_99	:=	nAcRetInter
		//Este FOR verifica todos os ajustes lancados na Apuracao de ICMS
		For nX := 1 To Len (aApICM)
			If	("002"$aApICM[nX][1] .And. !"002.00"$aApICM[nX][4]) .Or.;
				("003"$aApICM[nX][1] .And. !"003.00"$aApICM[nX][4]) .Or.;
				("006"$aApICM[nX][1] .And. !"006.00"$aApICM[nX][4]) .Or.;
				("007"$aApICM[nX][1] .And. !"007.00"$aApICM[nX][4]) .Or.;
				("012"$aApICM[nX][1] .And. !"012.00"$aApICM[nX][4])

				cCodObs := "9"+strzero(nY++,3)+IIF(lUsaSped,aApICM[nX][6],cCodObs)
				cCodAju := AllTrim(aApICM[nX][4])

				If aApICM[nx][2] $ "ESTCRED5005" .Or. aApICM[nx][2] $ "ESTDEBI5005"
					cCodObs	:= aApICM[nx][2]
					cObs := IIF(aApICM[nx][2] $ "ESTCRED5005" .Or. aApICM[nx][2] $ "ESTDEBI5005",STR1001,STR1002)
                ElseIf aApICM[nx][2] $ "ICMSDEV5005"
                	cCodObs	:= aApICM[nx][2]
                	cObs := STR1003
				Endif

				aAdd(aRegE340, {})
				nPos :=	Len(aRegE340)
				aAdd (aRegE340[nPos], "E340")				//01 - REG
				aAdd (aRegE340[nPos], cCodAju)				//02 - COD_AJ
				aAdd (aRegE340[nPos], aApICM[nX][3])		//03 - VL_AJ
				aAdd (aRegE340[nPos], "")					//04 - NUM_DA
				aAdd (aRegE340[nPos], "")					//05 - NUM_PROC
				aAdd (aRegE340[nPos], "2")					//06 - IND_PROC
				aAdd (aRegE340[nPos], aApICM[nX][2])		//07 - PROC
				aAdd (aRegE340[nPos], cCodObs)				//08 - REF_INF_OBS				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³REGISTRO 0450 - TABELA DE INFORMACOES COMPLEMENTARES/OBSERVACOES³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If  lUsaSped .Or. aApICM[nx][2] $ "ESTCRED5005" .Or.  aApICM[nx][2] $ "ESTDEBI5005" .Or. aApICM[nx][2] $ "ICMSDEV5005"
					Reg0450(cAlias,nRelac,aApICM[nx][2],,cCodObs,@aReg0450)
					nRelac++
				Endif
			EndIf
		Next nI
		//Se houve notas de complemento de ICMS com Debito do imposto
		If nDbCompIcm > 0
			cCodObs := "9"+strzero(nY++,3)+"199"
			cProc := STR0056 //"TOTAL DE NOTAS DE COMPLEMENTO DE ICMS COM DEBITO DO IMPOSTO"
			aAdd(aRegE340, {})
			nPos := Len(aRegE340)
			aAdd (aRegE340[nPos], "E340")					//01 - REG
			aAdd (aRegE340[nPos], "199")					//02 - COD_AJ
			aAdd (aRegE340[nPos], nDbCompIcm)				//03 - VL_AJ
			aAdd (aRegE340[nPos], "")						//04 - NUM_DA
			aAdd (aRegE340[nPos], "")						//05 - NUM_PROC
			aAdd (aRegE340[nPos], "9")						//06 - IND_PROC
			aAdd (aRegE340[nPos], cProc)					//07 - PROC
			aAdd (aRegE340[nPos], cCodObs)					//08 - REF_INF_OBS
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³REGISTRO 0450 - TABELA DE INFORMACOES COMPLEMENTARES/OBSERVACOES³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !Empty(cCodObs)
				Reg0450(cAlias,nRelac,cObs,,cCodObs,@aReg0450)
				nRelac++
			Endif
		EndIf
		//Se houve notas de complemento de ICMS com Credito do imposto
		If nCrCompIcm > 0
			cCodObs := "9"+strzero(nY++,3)+"499"
			cProc := STR0057 //"TOTAL DE NOTAS DE COMPLEMENTO DE ICMS COM CREDITO DO IMPOSTO"
			aAdd(aRegE340, {})
			nPos := Len(aRegE340)
			aAdd (aRegE340[nPos], "E340")					//01 - REG
			aAdd (aRegE340[nPos], "499")					//02 - COD_AJ
			aAdd (aRegE340[nPos], nCrCompIcm)				//03 - VL_AJ
			aAdd (aRegE340[nPos], "")						//04 - NUM_DA
			aAdd (aRegE340[nPos], "")						//05 - NUM_PROC
			aAdd (aRegE340[nPos], "9")						//06 - IND_PROC
			aAdd (aRegE340[nPos], cProc)					//07 - PROC
			aAdd (aRegE340[nPos], cCodObs)					//08 - REF_INF_OBS
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³REGISTRO 0450 - TABELA DE INFORMACOES COMPLEMENTARES/OBSERVACOES³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !Empty(cCodObs)
				Reg0450(cAlias,nRelac,cObs,,cCodObs,@aReg0450)
				nRelac++
			Endif
		EndIf
		aSort (aRegE340,,,{|x, y| x[2]<y[2]})
		GrvRegTrb (cAlias,, aRegE340)	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Segundo instrucoes da SEF-DF, as notas de complemento de ICMS deverao ser totalizadas  |
		//³ como "Outros Debitos" no caso de saida e "Outros Creditos" no caso de entrada         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nVL_01	-=	nDbCompIcm
		nVL_02	+=	nDbCompIcm
		nVL_05	-=	nCrCompIcm
		nVL_06	+=	nCrCompIcm
	EndIf

	nDifal87DF := RegE350(cAlias, dDataDe, cNrLivro, nRelac, @aReg0450)

	aAdd(aReg, {})
	nPos := Len(aReg)
	aAdd (aReg[nPos], "E360")				//01 - REG
	aAdd (aReg[nPos], nVL_01)				//02 - VL_01
	aAdd (aReg[nPos], nVL_02)				//03 - VL_02
	aAdd (aReg[nPos], nVL_03)				//04 - VL_03 - Valor total de "Estornos de crédito
	aAdd (aReg[nPos], nVL_04)				//05 - VL_04 - Valor total dos "Débitos (01+02+03)
	aAdd (aReg[nPos], nVL_05)				//06 - VL_05
	aAdd (aReg[nPos], nVL_06)				//07 - VL_06
	aAdd (aReg[nPos], nVL_07)				//08 - VL_07 - Valor total de "Estornos de débito
	aAdd (aReg[nPos], nVL_08)				//09 - VL_08 - Valor subtotal dos "Créditos (05+06+07)
	aAdd (aReg[nPos], nVL_09)				//10 - VL_09
	aAdd (aReg[nPos], nVL_10)				//11 - VL_10
	aAdd (aReg[nPos], nVL_11)				//12 - VL_11
	aAdd (aReg[nPos], nVL_12)				//13 - VL_12
	aAdd (aReg[nPos], nVL_13)				//14 - VL_13
	aAdd (aReg[nPos], nVL_14)				//15 - VL_14
	aAdd (aReg[nPos], nVL_15)				//16 - VL_15
	aAdd (aReg[nPos], nVL_16)				//17 - VL_16
	aAdd (aReg[nPos], nVL_17+nDifal87DF)	//18 - VL_17
	aAdd (aReg[nPos], nVL_18)				//19 - VL_18
	aAdd (aReg[nPos], nVL_19)				//20 - VL_19
	aAdd (aReg[nPos], nVL_20)				//21 - VL_20
	aAdd (aReg[nPos], nVL_99)				//22 - VL_99
	GrvRegTrb (cAlias,, aReg)
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |RegE500   ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³               PERIODO DE APURACAO DO IPI                   ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao e gravacao do Registro E500                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb.                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³2(um por periodo)                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cAlias -> Alias do TRB que devera conter as informacoes do  ³±±
±±³          ³ meio-magnetico.                                            ³±±
±±³          ³dDataDe -> Data incial do periodo de apuracao.              ³±±
±±³          ³dDataAte -> Data final do periodo de apuracao.              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RegE500 (cAlias, dDataDe, dDataAte)	
	Local aReg := {}
	Local lRet := .T.
	Local nPos := 0
	//
	aAdd (aReg, {})
	nPos	:=	Len (aReg)
	aAdd (aReg[nPos], "E500")							//01 - REG
	aAdd (aReg[nPos], dDataDe)							//02 - DT_INI
	aAdd (aReg[nPos], dDataAte)							//03 - DT_FIN
	//
	GrvRegTrb (cAlias,, aReg)
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |RegE510   ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³    CONSOLIDACAO DOS VALORES DE IPI POR CFOP E CODIGO DE    ³±±
±±³          ³                   TRIBUTACAO DO IPI                        ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao do Registros E510                                 |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoe contidas na tabela   ³±±
±±³          ³ SFT somente para operacoes TRIBUTADAS                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³3(varios por periodo)                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cAliasSFT -> Alias da tabela SFT aberta no momento.         ³±±
±±³          ³ funcao a ser retornado para gravacao pela funcao principal.³±±
±±³          |aRegE510 -> Array contendo as informacoes processadas pela  ³±±
±±³          ³ funcao a ser retornado para gravacao pela funcao principal.³±±
±±³          ³cSituaDoc -> Situação do documento.                         ³±±
±±³          ³cEntSai -> Flag de indicacao do documento fiscal, 1=Entrada/³±±
±±³          ³ 2=Saida.                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RegE510 (cAliasSFT, aRegE510, cSituaDoc, cEntSai)
	Local lRet := .T.
	Local nPos := 0
	//
	If (SX5->(DbSeek (xFilial ("SX5")+"S3"+(cAliasSFT)->FT_CTIPI)))
		cCtipi := (cAliasSFT)->FT_CTIPI
	Else
		If cEntSai == "1"
			cCtipi := "49"
		Else
			cCtipi := "99"
		EndIf
	EndIf
	//
	If (nPos := aScan (aRegE510, {|aX| aX[2]==(cAliasSFT)->FT_CFOP .And. aX[3]==cCtipi}))==0
		aAdd(aRegE510, {})
		nPos	:=	Len (aRegE510)
		aAdd (aRegE510[nPos], "E510")	   				//01 - REG
		aAdd (aRegE510[nPos], (cAliasSFT)->FT_CFOP)	//02 - CFOP
		aAdd (aRegE510[nPos], cCtipi)					//03 - CTIPI
		aAdd (aRegE510[nPos], 0)						//04 - VL_CONT_IPI_P
		aAdd (aRegE510[nPos], 0)						//05 - VL_BC_IPI_P
		aAdd (aRegE510[nPos], 0)						//06 - VL_IPI_P
	EndIf
	If !(cSituaDoc $ "02#03#04")
		aRegE510[nPos][4]	+=	(cAliasSFT)->FT_VALCONT		//04 - VL_CONT_IPI_P
		aRegE510[nPos][5]	+=	(cAliasSFT)->FT_BASEIPI		//05 - VL_BC_IPI_P	
		aRegE510[nPos][6]	+=	(cAliasSFT)->FT_VALIPI		//06 - VL_IPI_P
	EndIf
Return (lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |RegE530   ³ Autor ³Liber De Esteban       ³ Data ³09/11/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³                   APURACAO DO IPI                          ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao e gravacao do Registro E530                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoe contidas na apuracao ³±±
±±³          ³ de IPI.                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³E530 - 3(varios por periodo)                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cAlias -> Alias do TRB para gravacao.                       ³±±
±±³          ³dDataAte -> Data final do periodo de apuracao.              ³±±
±±³          ³cNrLivro -> Numero do livro selecionado no wizard.          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RegE530 (cAlias, dDataAte, cNrLivro)
	Local	lRet		:=	.T.
	Local	nPos		:=	0
	Local	nX			:=	0
	Local	nApuracao	:=	GetSx1 (PadR("MTA951",10), "04", .T.)	//1-Decendial, 2-Quinzenal, 3-Mensal, 4-Semestral ou 5-Anual
	Local	nPeriodo	:=	1								//GetSx1 ("MTA951", "05", .T.)	//1-1., 2-2., 3-3.	
	Local	cIndAj		:=	""
	Local	aReg		:=	{}
	Local	aApIPI		:=	{}
	Local	nVLSdAnt	:=	0
	Local	nVLDbIpi	:=	0
	Local	nVLCdIpi	:=	0
	Local	nVLOdIpi	:=	0
	Local	nVLOcIpi	:=	0
	Local	nVLScIpi	:=	0
	Local	nVLSdIpi	:=	0
	Local	aRegE520	:=	{}
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Fixo que o periodo de geracao podera ser somente Mensal ou Anual.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (nApuracao==1) .Or. (nApuracao==2)
		nApuracao	:=	3
	ElseIf (nApuracao==4)
		nApuracao	:=	5
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Leio o arquivo de apuracao.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aApIPI	:=	FisApur ("IP", Year (dDataAte), Month (dDataAte), nApuracao, nPeriodo, cNrLivro, .F., {}, 1, .F., "")
	//
	For nX := 1 To Len (aApIPI)
		cIndAj := "X"
		If "005"$aApIPI[nX][1] .And. !(Upper("Outros Creditos") $ Upper(aApIPI[nX][2]))
			cIndAj := "1"
		ElseIf "012"$aApIPI[nX][1] .And. !(Upper("Outros Debitos") $ Upper(aApIPI[nX][2]))
			cIndAj := "0"
		EndIf
		If cIndAj != "X"
			aAdd(aRegE520, {})
			nPos	:=	Len (aRegE520)
			aAdd (aRegE520[nPos], "E520")	   	   				//01 - REG
			aAdd (aRegE520[nPos], cIndAj)						//02 - IND_AJ
			aAdd (aRegE520[nPos], dDataAte)						//03 - DT_AJ
			aAdd (aRegE520[nPos], aApIPI[nX][3])				//03 - VL_AJ
			aAdd (aRegE520[nPos], aApIPI[nX][2])				//04 - DESCR_DA
		EndIf
	Next nI
	aSort (aRegE520,,,{|x, y| x[2]<y[2]})
	GrvRegTrb (cAlias,, aRegE520)
    //
	nVLCdIpi	:=	Iif (aScan (aApIPI, {|a| a[1]=="001"})<>0, aApIPI[aScan (aApIPI, {|a| a[1]=="001"})][3], 0)
	nVLOcIpi	:=	Iif (aScan (aApIPI, {|a| a[1]=="005"})<>0, aApIPI[aScan (aApIPI, {|a| a[1]=="005"})][3], 0)
	nVLOcIpi 	+= 	Iif (aScan (aApIPI, {|a| a[1]=="004"})<>0, aApIPI[aScan (aApIPI, {|a| a[1]=="004"})][3], 0)
	nVLSdAnt	:=	Iif (aScan (aApIPI, {|a| a[1]=="007"})<>0, aApIPI[aScan (aApIPI, {|a| a[1]=="007"})][3], 0)
	nVLDbIpi	:=	Iif (aScan (aApIPI, {|a| a[1]=="009"})<>0, aApIPI[aScan (aApIPI, {|a| a[1]=="009"})][3], 0)
	nVLOdIpi	:=	Iif (aScan (aApIPI, {|a| a[1]=="012"})<>0, aApIPI[aScan (aApIPI, {|a| a[1]=="012"})][3], 0)
	nVLOdIpi 	+= 	Iif (aScan (aApIPI, {|a| a[1]=="010"})<>0, aApIPI[aScan (aApIPI, {|a| a[1]=="010"})][3], 0)
	nVLSdIpi	:=	Iif (aScan (aApIPI, {|a| a[1]=="016"})<>0, aApIPI[aScan (aApIPI, {|a| a[1]=="016"})][3], 0)
	nVLScIpi	:=	Iif (aScan (aApIPI, {|a| a[1]=="017"})<>0, aApIPI[aScan (aApIPI, {|a| a[1]=="017"})][3], 0)
	//
	aAdd(aReg, {})
	nPos	:=	Len (aReg)
	aAdd (aReg[nPos], "E530")	   				//01 - REG
	aAdd (aReg[nPos], nVLSdAnt)					//02 - VL_SD_ANT_IPI
	aAdd (aReg[nPos], nVLDbIPI)					//03 - VL_DEB_IPI
	aAdd (aReg[nPos], nVLCdIPI)					//04 - VL_CRED_IPI
	aAdd (aReg[nPos], nVLOdIPI)					//05 - VL_OD_IPI
	aAdd (aReg[nPos], nVLOcIPI)					//06 - VL_OC_IPI
	aAdd (aReg[nPos], nVLScIPI)					//07 - VL_SC_IPI
	aAdd (aReg[nPos], nVLSdIPI)					//08 - VL_SD_IPI
	//
	GrvRegTrb (cAlias,, aReg)
Return (lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |RegH025   ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³                       INVENTARIO                           ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao do Registros H025                                 |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoes obtidas pela funcao ³±±
±±³          ³ FsEstInv.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³2(um por data)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|aRegH025 -> Array cumulativo por filiais das informacoes de ³±±
±±³          ³ inventario.                                                ³±±
±±³          ³cAlias -> Alias do TRB que recebe a gravacao dos registros  ³±±
±±³          ³ para geracao do txt.                                       ³±±
±±³          ³aMVCEINITS -> Conteudo do parametro MV_CEINITS no formato de³±±
±±³          ³ array que identifica os campos da tabela SA1 e SA2 relacio-³±±
±±³          ³ nado as identificacoes abaixo:                             ³±±
±±³          ³ Posicao 1 = Campo da Tabela SA1 para identificacao do CEI. ³±±
±±³          ³ Posicao 2 = Campo da Tabela SA2 para identificacao do CEI. ³±±
±±³          ³ Posicao 3 = Campo da Tabela SA1 para identificacao do NIT. ³±±
±±³          ³ Posicao 4 = Campo da Tabela SA2 para identificacao do NIT. ³±±
±±³          ³ Posicao 5 = Campo da Tabela SA1 para identificacao do SUFRAMA³±±
±±³          ³ Posicao 6 = Campo da Tabela SA2 para identificacao do SUFRAMA³±±
±±³          ³ Ex: {"A1_CEI","A2_CEI","A1_NIT","A2_NIT","A1_SUF","A2_SUF"}³±±
±±³          ³nAcVlrEst -> Valor cumulativo para geracao do registro H020.³±±
±±³          ³dDataAte -> Data final da declaração                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function H020H025(cAlias,aMVCEINITS,aMVMUNIBGE,dDataDe,dDataAte,aWizard,dDataInv)
	Local	nPos		:= 0
	Local	nIND_INV	:= 0
	Local	aPartDoc	:= {}
	Local	aRegH025	:= {}
	Local	aRegH020	:= {}
	Local	nAcVlrEst	:= 0
	Local	cCodPart	:= ""
	Local	cAliBLH		:= "INV"
	Local	nTamProd	:=	TamSX3("B1_COD")[1]	
	Local	ntamCli		:=	TamSX3("A1_COD")[1]	
	Local	nTamLoj		:=	TamSX3("A1_LOJA")[1]
	Local	cAliasF0Q	:= ''
	Local	cPerF0Q		:= cValToChar(StrZero(Month(dDataDe),2)) + cValToChar(Year(dDataAte))
	Local	aPrdAltTri	:= {}
	Local	cClifor		:=	Space(ntamCli)
	Local	cLoja		:=	Space(nTamLoj)
	Local	cProd		:=	Space(nTamProd)
	Local	cUnid		:= ''
	Local	nQuant		:= 0
	Local	nValUnit	:= 0
	Local	nVlrIte		:= 0
	Local	cSituacao	:= ''
	Local	cIND_PROP	:= ''

	If ("1"$aWizard[1][6])

		//Verifica existencia da função criada por Materiais
		If !FindFunction("SPDBlOCH")
			MsgAlert("Para gerar o Bloco H, é necessário atualizar a Rotina MATXSPED.")
			Return
		Endif

		cAliasF0Q := GetNextAlias()
		BeginSql Alias cAliasF0Q
			COLUMN F0Q_DTFECH AS DATE

			SELECT F0Q.F0Q_CODIGO
			FROM %TABLE:F0Q% F0Q
			WHERE
				F0Q.F0Q_FILIAL=%xFilial:F0Q% AND
				F0Q.F0Q_PERIOD = %Exp:cPerF0Q% AND
				F0Q.%NOTDEL%
			ORDER BY F0Q_DTFECH
		EndSql

		While (cAliasF0Q)->(!Eof())
			aAdd(aPrdAltTri,(cAliasF0Q)->F0Q_CODIGO)
			(cAliasF0Q)->(dbSkip())
		Enddo
		(cAliasF0Q)->(DbCloseArea())

		IncProc(STR0054)	//"Filtrando base inventário..."
		//Processa a rotina SPDBlocH
		SPDBlocH(@cAliBLH,'',IIf(!Empty(dDataInv),dDataInv,dDataAte))
		If !Empty(cAliBLH)
			ProcRegua((cAliBLH)->(RecCount()))
			(cAliBLH)->(DbGotop())
			While !(cAliBLH)->(Eof())
				IncProc(STR0055+AllTrim((cAliBLH)->COD_ITEM))	//"Processando Inventário, Produto: "
				If ("02"$aWizard[1][15]) .AND. Ascan(aPrdAltTri,(cAliBLH)->COD_ITEM)==0 
					(cAliBLH)->(DbSkip())
					Loop
				Endif
				cClifor		:=	Space(ntamCli)
				cLoja		:=	Space(nTamLoj)
				cProd		:=	PadR(Alltrim((cAliBLH)->COD_ITEM),nTamProd)  	// Produto
				cUnid		:= (cAliBLH)->UNID      								// Unidade
				nQuant		:= (cAliBLH)->QTD 									// Quantidade
				nValUnit	:= (cAliBLH)->VL_UNIT								// Valor Unidade
				nVlrIte		:= (cAliBLH)->VL_ITEM   								// Valor Total
				cSituacao	:= (cAliBLH)->IND_PROP								// Situacao do estoque				
				//Tratamento cliente e loja para produtos Em/De terceiro				
				IF cSituacao <> '0'
					cClifor := SubsTring((cAliBLH)->COD_PART,4,ntamCli)
					cLoja   := SubsTring((cAliBLH)->COD_PART,4+ntamCli,nTamLoj)
				Endif

				DbSelectArea("SB1")
				SB1->(DbSetOrder(1))
				If (SB1->(DbSeek(xFilial("SB1")+cProd)))
					//GRAVACAO - REGISTRO 0200 PARA PRODUTOS DO INVENTARIO 
					Reg0200()
					//Cadastro do Cliente/Fornecedor
					If Empty(cClifor)
						aPartDoc := InfPartDoc("SM0", {}, {}, .T.)
					Else
						DbSelectArea("SA1")
						SA1->(DbSetOrder(1))
						If SA1->(MsSeek(xFilial("SA1")+cClifor+cLoja))
							aPartDoc := InfPartDoc("SA1", aMVCEINITS, aMVMUNIBGE)
						Else
							DbSelectArea("SA2")
							SA2->(DbSetOrder(1))
							If SA2->(MsSeek(xFilial("SA2")+cClifor+cLoja))
								aPartDoc := InfPartDoc("SA2", aMVCEINITS, aMVMUNIBGE)
							EndIf
						EndIf
					EndIf
					//Indicador de propriedade
					//0- Item de propriedade do informante e em seu poder
					//1- Item de propriedade do informante em posse de terceiros
					//2- Item de propriedade de terceiros em posse do informante
					cIND_PROP := cSituacao
					//Caso o produto esteja no estabelecimento do informante do arquivo cotepe
					//nao precisa informar o codigo do participante
					If cIND_PROP=="0"
						cCodPart := ""
					ElseIf len(aPartDoc) > 0
						cCodPart := aPartDoc[1]
						//REGISTRO 0150 - TABELA DE CADASTRO DE PARTICIPANTES
						Reg0150(aPartDoc)
					EndIf

					If ("ME"$SB1->B1_TIPO)
						nIND_INV := 0
					ElseIf ("MP"$SB1->B1_TIPO)
						nIND_INV := 1
					ElseIf ("PI"$SB1->B1_TIPO)
						nIND_INV := 2
					ElseIf ("PA"$SB1->B1_TIPO)
						nIND_INV := 4
					Else
						nIND_INV := 9
					EndIf
					//
					If !IVT->(MsSeek(cIND_PROP+cCodPart+STR(nIND_INV,1)+cProd))
						RecLock("IVT", .T.)
						IVT->IVT_REG	:= "H025"			//01 - REG
						IVT->IVT_INDP	:= cIND_PROP		//02 - IND_PROP
						IVT->IVT_CODPAR	:= cCodPart			//03 - COD_PART
						IVT->IVT_INDINV	:= STR(nIND_INV,1)	//04 - IND_INV
						IVT->IVT_NCM	:= SB1->B1_POSIPI	//05 - COD_NCM
						IVT->IVT_CODITE	:= cProd			//06 - COD_ITEM
						IVT->IVT_UM		:= cUnid			//09 - UNID
						IVT->IVT_OBS	:= ""				//11 - REF_INF_OBS
					Else
						RecLock("IVT", .F.)
					EndIf
					IVT->IVT_VLUNIT += nVlrIte/nQuant		//(INV->CUSTO / INV->QUANT)	//07 - VL_UNIT
					IVT->IVT_QTD    += nQuant				//08 - QTD
					IVT->IVT_VLITEM += nVlrIte				//INV->CUSTO	//10 - VL_ITEM
					MsUnLock()
				EndIf
				//
				(cAliBLH)->(DbSkip())
			EndDo
			(cAliBLH)->(dbCloseArea())
			Ferase(cAliBLH+GetDBExtension())
		EndIf
		IVT->(DbGoTop())
		Do While !IVT->(Eof())
			aRegH025	:=	IVT->({IVT_REG,IVT_INDP,IVT_CODPAR,IVT_INDINV,IVT_NCM,IVT_CODITE,{IVT_VLUNIT,"VLR3"},{IVT_QTD,"VLR3"},IVT_UM,IVT_VLITEM,IVT_OBS})
			nAcVlrEst	+=	IVT->IVT_VLITEM
			GrvRegTrb(cAlias,,{aRegH025})
			IVT->(DbSkip())
		EndDo
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³REGISTRO H020 - TOTAIS DO INVENTARIOS³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aAdd(aRegH020, {})
	nPos := Len(aRegH020)
	aAdd (aRegH020[nPos], "H020")									//01 - REG
	aAdd (aRegH020[nPos], IIF(!Empty(dDataInv),dDataInv,dDataAte))	//02 - DT_FIN  //SuperGetMv ("MV_ULMES"))
	aAdd (aRegH020[nPos], nAcVlrEst)								//03 - VL_INV
	//
	GrvRegTrb (cAlias,,aRegH020)
Return .T.
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Reg9900   ³ Autor ³Liber de Esteban       ³ Data ³20.08.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³                  REGISTROS DO ARQUIVO                      ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao e gravacao do Registro 9900                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb.                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³2(varios por arquivo)                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAlias   -> Alias do TRB que recebera as informacoes        ³±±
±±³          ³aReg9900 -> Array com informacoes que serao gravadas no TRB ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Reg9900 (cAlias, aReg9900)
	Local lRet := .T.
	//
	GrvRegTrb (cAlias,,aReg9900,)
	//
Return (lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Reg9999   ³ Autor ³Liber de Esteban       ³ Data ³20.08.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³              ENCERRAMENTO DO ARQUIVO DIGITAL               ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao e gravacao do Registro 9999                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb.                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³0(um por arquivo)                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAlias   -> Alias do TRB que recebera as informacoes        ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Reg9999 (cAlias)
	Local	lRet	:=	.T.
	Local	nPos	:=	0
	Local	aReg	:= {}
	//
	aAdd(aReg, {})
	nPos	:=	Len (aReg)
	nTotLin := (cAlias)->(RecCount()) + 1
	aAdd (aReg[nPos], "9999")					//01 - REG
	aAdd (aReg[nPos], Alltrim(STR(nTotLin)))	//02 - QTD_LIN
	GrvRegTrb (cAlias,,aReg,)
	//
Return (lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |BlAbEnc   ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³       GRAVACAO DO INDICADOR DE BLOCO COM MOVIMENTO         ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Funcao de gravacao do indicador de bloco com movimento(0) ou³±±
±±³          ³ sem movimento(1) conforme passagem de parametros. Utilizado³±±
±±³          ³ na funcao GrvIndMov.                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cAbEnt -> Indicador de Bloco de Abertura (A) ou Encerramento³±±
±±³          ³ (E).                                                       ³±±
±±³          ³cAlias -> Alias do TRB onde sera gravado as informacoes.    ³±±
±±³          ³cReg -> Codigo do registro                                  ³±±
±±³          ³cIndMov -> Indicador de movimento (0=Sim, 1=Nao)            ³±±
±±³          ³nQtdLin -> Quantidade de linha do registro                  ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static function BlAbEnc (cAbEnc, cAlias, cReg, cIndMov, nQtdLin)
	Local	lRet		:=	.T.
	Local	aBlAbEnc	:=	{}
	//
	aAdd(aBlAbEnc, {})
	nPos	:=	Len (aBlAbEnc)
	//
	If ("A"$cAbEnc)
		aAdd (aBlAbEnc[nPos], cReg)
		aAdd (aBlAbEnc[nPos], cIndMov)
		//
		If (Left (cReg, 1)$"A#B")
			aAdd (aBlAbEnc[nPos], AllTrim (SM0->M0_CODMUN))
		ElseIf (Left (cReg, 1)$"8")
			aAdd (aBlAbEnc[nPos], AllTrim (SM0->M0_ESTENT))
		EndIf
	Else
		aAdd (aBlAbEnc[nPos], cReg)
		aAdd (aBlAbEnc[nPos], Alltrim(STR(nQtdLin+2)))	// O +2 eh para somar o registro de abertura mais o registro de encerramento
	EndIf
	//
	GrvRegTrb (cAlias,,aBlAbEnc,)
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |InfPartDoc³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³       ATRIBUICAO DOS DADOS DO PARTICIPANTE NO ARRAY        ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Funcao que retorna um array com as informacoes necessarias  ³±±
±±³          ³ do participante do documento fiscal.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³aA1A2 -> Array com as informacoes do participante da documento³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cAlsSA -> Alias da tabela SA1 ou SA2.                       ³±±
±±³          ³aMVCEINITS -> Conteudo do parametro MV_CEINITS no formato de³±±
±±³          ³ array que identifica os campos da tabela SA1 e SA2 relacio-³±±
±±³          ³ nado as identificacoes abaixo:                             ³±±
±±³          ³ Posicao 1 = Campo da Tabela SA1 para identificacao do CEI. ³±±
±±³          ³ Posicao 2 = Campo da Tabela SA2 para identificacao do CEI. ³±±
±±³          ³ Posicao 3 = Campo da Tabela SA1 para identificacao do NIT. ³±±
±±³          ³ Posicao 4 = Campo da Tabela SA2 para identificacao do NIT. ³±±
±±³          ³ Posicao 5 = Campo da Tabela SA1 para identificacao do SUFRAMA³±±
±±³          ³ Posicao 6 = Campo da Tabela SA2 para identificacao do SUFRAMA³±±
±±³          ³ Ex: {"A1_CEI","A2_CEI","A1_NIT","A2_NIT","A1_SUF","A2_SUF"}³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function InfPartDoc (cAlsSA, aMVCEINITS, aMVMUNIBGE, lSm0,cAliasSFT)
	Local	aA1A2		:= {}
	Local	cA1A2		:= SubStr (cAlsSA, 3, 1)
	Local	cCodMun		:= ""
	Local	cCmpCod		:= cAlsSA+"->A"+cA1A2+"_COD"
	Local	cCmpLoja	:= cAlsSA+"->A"+cA1A2+"_LOJA"
	Local	cCmpNome	:= cAlsSA+"->A"+cA1A2+"_NOME"
	Local	cCmpTipo	:= cAlsSA+"->A"+cA1A2+Iif ("2"$cA1A2, "_TIPO", "_PESSOA")
	Local	cCmpCgc		:= cAlsSA+"->A"+cA1A2+"_CGC"
	Local	cCmpEst		:= cAlsSA+"->A"+cA1A2+"_EST"
	Local	cCmpInsc	:= cAlsSA+"->A"+cA1A2+"_INSCR"
	Local	cCmpCodM	:= cAlsSA+"->" + Iif((Valtype(aMVMUNIBGE)=="A" .And. Len(aMVMUNIBGE)==2) .And. ((cAlsSA)->(FieldPos(aMVMUNIBGE[Val(cA1A2)]))>0),aMVMUNIBGE[Val(cA1A2)],"A"+cA1A2+"_COD_MUN")
	Local	cCmpInscM	:= cAlsSA+"->A"+cA1A2+"_INSCRM"
	Local	cCmpCep		:= cAlsSA+"->A"+cA1A2+"_CEP"
	Local	cCmpEnd		:= cAlsSA+"->A"+cA1A2+"_END"
	Local	cCmpBairro	:= cAlsSA+"->A"+cA1A2+"_BAIRRO"
	Local	cCmpCxPost	:= cAlsSA+"->A"+cA1A2+Iif ("2"$cA1A2, "_CX_POST", "_CXPOSTA")
	Local	cCmpTel		:= cAlsSA+"->A"+cA1A2+"_TEL"
	Local	cCmpFax		:= cAlsSA+"->A"+cA1A2+"_FAX"
	Local	cCmpCompl	:= cAlsSA+"->A"+cA1A2+"_COMPLEM"
	Local	aArea		:= {}
	Local	cPais		:= cAlsSA+"->A"+cA1A2+"_CODPAIS"
	//
	Default lSm0      := .F.
	Default cAliasSFT := ""
	//
	If lSm0
		aAdd (aA1A2, "SM0"+SM0->(M0_CODIGO+M0_CODFIL))													//01	-	COD_PART
		aAdd (aA1A2, SM0->M0_NOME)																		//02	-	NOME
		aAdd (aA1A2, "01058")																			//03	-	COD_PAIS
		//Se pessoa Juridica armazeno o CNPJ no sua devida posicao
		If Len (AllTrim (SM0->M0_CGC))>=14
			aAdd (aA1A2, AllTrim (SM0->M0_CGC))										 					//04	-	CNPJ
			aAdd (aA1A2, "")																			//05	-	CPF
		//Se pessoa Fisica armazeno o CPF no sua devida posicao
		ElseIf Len (AllTrim (SM0->M0_CGC))<14
			aAdd (aA1A2, "")																			//04	-	CNPJ
			aAdd (aA1A2, AllTrim (SM0->M0_CGC))										 					//05	-	CPF
		Else
			aAdd (aA1A2, "")																			//04	-	CNPJ
			aAdd (aA1A2, "")																			//05	-	CPF
		EndIf
		//
		aAdd (aA1A2, "")																				//06	-	CEI
		aAdd (aA1A2, "")																				//07	-	NIT
		//
		aAdd (aA1A2, SM0->M0_ESTENT)																	//08	-	UF
		aAdd (aA1A2, SM0->M0_INSC)																		//09	-	IE
		aAdd (aA1A2, "")																				//10	-	IE_ST
		aAdd (aA1A2, IIF( Len(SM0->M0_CODMUN) <= 5 , RetCodEst(SM0->M0_ESTENT),"") + SM0->M0_CODMUN )	//11	-	COD_MUN
		aAdd (aA1A2, SM0->M0_INSCM)																		//12	-	IM
		aAdd (aA1A2, "")																				//13	-	Inscricao SUFRAMA
		//ÚÄÄÄÄÄÄÄÄ¿
		//³ENDERECO³
		//ÀÄÄÄÄÄÄÄÄÙ
		aAdd (aA1A2, SM0->M0_CEPENT)																	//14	-	CEP
		aAdd (aA1A2, Substr (SM0->M0_ENDENT, 1, At(",", SM0->M0_ENDENT)-1))							//15	-	END
		aAdd (aA1A2, Substr (SM0->M0_ENDENT, At(",", SM0->M0_ENDENT)+1, Len (AllTrim (SM0->M0_ENDENT))))//16	-	NUM
		aAdd (aA1A2, SM0->M0_COMPENT)																	//17	-	COMPL
		aAdd (aA1A2, SM0->M0_BAIRENT)																	//18	-	BAIRRO
		aAdd (aA1A2, "")																				//19	-	CEP_CP
		aAdd (aA1A2, "")																				//20	-	CP
		aAdd (aA1A2, SM0->M0_TEL)																		//21	-	TEL
		aAdd (aA1A2, SM0->M0_FAX)																		//22	-	FAX
	Else
		If !Empty(cAliasSFT) .AND. !Empty((cAliasSFT)-> FT_PDV)
			aArea := GetArea()
			DbSelectArea(cAlsSA)
			DbSetOrder(1)
			DbSeek(xFilial(cAlsSA)+(cAliasSFT)->FT_CLIEFOR+(cAliasSFT)->FT_LOJA)
			RestArea(aArea)
		EndIf
		aAdd (aA1A2, cAlsSA+FWGETCODFILIAL+&(cCmpCod)+&(cCmpLoja))						//01	-	COD_PART
		aAdd (aA1A2, &(cCmpNome))														//02	-	NOME
		If (Len (aMVCEINITS)==8)
			If ("2"$cA1A2) .AND. (cAlsSA)->(FieldPos (aMVCEINITS[8])) > 0
				aAdd (aA1A2, (cAlsSA)->(FieldGet (FieldPos (aMVCEINITS[8]))) )			//03	-	COD_PAIS
			ElseIf ("1"$cA1A2) .AND. (cAlsSA)->(FieldPos (aMVCEINITS[7])) > 0
				aAdd (aA1A2, (cAlsSA)->(FieldGet (FieldPos (aMVCEINITS[7]))) )			//03	-	COD_PAIS
			Else
				aAdd (aA1A2, &(cPais))													//03	-	COD_PAIS
			EndIf
		Else
			aAdd (aA1A2, &(cPais))														//03	-	COD_PAIS
		EndIf
		//Se pessoa Juridica armazeno o CNPJ no sua devida posicao
		If (!Empty(&(cCmpCgc)) .and. RetPessoa(&(cCmpCgc)) == "J") .OR. ("J"$(&(cCmpTipo)))
			aAdd (aA1A2, aRetDig(&(cCmpCgc),.F.))										//04	-	CNPJ
			aAdd (aA1A2, "")															//05	-	CPF
		//Se pessoa Fisica armazeno o CPF no sua devida posicao
		ElseIf (!Empty(&(cCmpCgc)) .and. RetPessoa(&(cCmpCgc)) == "F") .OR. ("F"$(&(cCmpTipo)))
			aAdd (aA1A2, "")															//04	-	CNPJ
			aAdd (aA1A2, aRetDig(&(cCmpCgc),.F.))										//05	-	CPF
		Else
			aAdd (aA1A2, "")															//04	-	CNPJ
			aAdd (aA1A2, "")															//05	-	CPF
		EndIf
		//
		If (Len (aMVCEINITS)==8)
			If ("2"$cA1A2) .AND. (cAlsSA)->(FieldPos (aMVCEINITS[2])) > 0
				aAdd (aA1A2, (cAlsSA)->(FieldGet (FieldPos (aMVCEINITS[2]))))			//06	-	CEI
			ElseIf ("1"$cA1A2) .AND. (cAlsSA)->(FieldPos (aMVCEINITS[1])) > 0
				aAdd (aA1A2, (cAlsSA)->(FieldGet (FieldPos (aMVCEINITS[1]))))			//06	-	CEI
			Else
				aAdd (aA1A2, "")														//06	-	CEI
			EndIf
		Else
			aAdd (aA1A2, "")															//06	-	CEI
		EndIf
		//
		If (Len (aMVCEINITS)==8)
			If ("2"$cA1A2) .AND. (cAlsSA)->(FieldPos (aMVCEINITS[4])) > 0
				aAdd (aA1A2, (cAlsSA)->(FieldGet (FieldPos (aMVCEINITS[4]))))			//07	-	NIT
			ElseIf ("1"$cA1A2) .AND. (cAlsSA)->(FieldPos (aMVCEINITS[3])) > 0
				aAdd (aA1A2, (cAlsSA)->(FieldGet (FieldPos (aMVCEINITS[3]))))			//07	-	NIT
			Else
				aAdd (aA1A2, "")														//07	-	NIT
			EndIf
		Else
			aAdd (aA1A2, "")															//07	-	NIT
		EndIf
		//
		aAdd (aA1A2, &(cCmpEst))														//08	-	UF
		aAdd (aA1A2, aRetDig(&(cCmpInsc),.F.))											//09	-	IE
		aAdd (aA1A2, "")																//10	-	IE_ST
		//
		IF aA1A2[03] == "01058"		// Se for Brasil
			IF Len(Alltrim(&(cCmpCodM))) <= 5		// Se nao tiver com o codigo do estado junto
				cCodMun := RetCodEst(&(cCmpEst)) + &(cCmpCodM)
			Else
				cCodMun := &(cCmpCodM)
			EndIf
		Else
			cCodMun := ""
		EndIf
		//
		aAdd (aA1A2, cCodMun )															//11	-	COD_MUN
		aAdd (aA1A2, aRetDig(&(cCmpInscM),.F.))										//12	-	IM
		//
		If (Len (aMVCEINITS)==8)
			If ("2"$cA1A2) .AND. (cAlsSA)->(FieldPos (aMVCEINITS[6])) > 0
				aAdd (aA1A2, (cAlsSA)->(FieldGet (FieldPos (aMVCEINITS[6]))))			//13	-	Inscricao SUFRAMA
			ElseIf ("1"$cA1A2) .AND. (cAlsSA)->(FieldPos (aMVCEINITS[5])) > 0
				aAdd (aA1A2, (cAlsSA)->(FieldGet (FieldPos (aMVCEINITS[5]))))			//13	-	Inscricao SUFRAMA
			Else
				aAdd (aA1A2, "")														//13	-	Inscricao SUFRAMA
			EndIf
		Else
			aAdd (aA1A2, "")															//13	-	Inscricao SUFRAMA
		EndIf
		//ÚÄÄÄÄÄÄÄÄ¿
		//³ENDERECO³
		//ÀÄÄÄÄÄÄÄÄÙ
		aAdd (aA1A2, &(cCmpCep))														//14	-	CEP
		aAdd (aA1A2, Substr (&(cCmpEnd), 1, At(",", &(cCmpEnd))-1))					//15	-	END
		aAdd (aA1A2, Substr (&(cCmpEnd), At(",", &(cCmpEnd))+1, Len (AllTrim (&(cCmpEnd)))))		//16	-	NUM
		aAdd (aA1A2, &(cCmpCompl))														//17	-	COMPL
		aAdd (aA1A2, &(cCmpBairro))														//18	-	BAIRRO
		aAdd (aA1A2, &(cCmpCep))														//19	-	CEP_CP
		aAdd (aA1A2, &(cCmpCxPost))														//20	-	CP
		aAdd (aA1A2, &(cCmpTel))														//21	-	TEL
		aAdd (aA1A2, &(cCmpfAX))														//22	-	FAX
	EndIf
Return (aA1A2)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |ZerSimples³ Autor ³Gustavo G. Rueda       ³ Data ³07.01.2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³  FUNCAO UTILIZADA PARA ZERAR VALORES DO SIMPLES NACIONAL   ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³O Simples Nacional exige zerar a BASE e VALOR dos tributos, ³±±
±±³          ³ pois os registros de notas fiscais nao sao enviados.       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³lRet -> .T.                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|aReg -> Registro passado por referencia para que se possa   ³±±
±±³          ³ zerar um determinado indice do array.                      ³±±
±±³          ³nPos -> Indice do campo que se deseja alterar               ³±±
±±³          ³aPos -> Array de posicoes de campos que se deseja alterar.  ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ZerSimples(aReg,nPos,aPos)
Local	lRet	:=	.T.
Local	nI		:=	0

If lSimples
	For nI := 1 To Len(aPos)
		If Len(aReg)>=nPos .And. Len(aReg[nPos])>=nI
			aReg[nPos,aPos[nI]]	:=	0
		EndIf
	Next nI
	Reg0200()
EndIf
Return(lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |MontWiz   ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³                    MONTAGEM DO WIZARD                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Funcao que monta o Wizard em tela para processamento.       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³lRet -> .T. se o wizard foi finalizado com sucesso ou .F. se³±±
±±³          ³ foi cancelado.                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function Cot35MontWiz (cNomWiz)
	Local	aTxtApre	:= {}
	Local	aPaineis	:= {}
	Local	aItens1		:= {}
	Local	aItens2		:= {}
	Local	aItens3		:= {}	
	Local	aItens4		:= {}
	Local	cTitObj1	:= ""
	Local	cTitObj2	:= ""
	Local	lRet		:= .T.
	//
	If cNomWiz=="COTEPE35" + FWGrpCompany() + FWGETCODFILIAL
		aAdd (aTxtApre, STR0004) //"Parametros necessarios."
		aAdd (aTxtApre, "")
		aAdd (aTxtApre, STR0005) //"Preencha corretamente as informacoes solicitadas."
		aAdd (aTxtApre, STR0006) //"Informacoes necessarias para a geração do meio-magnético que trata o ATO COTEPE N. 35/05, DE 17 DE JUNHO DE 2005."
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Painel 0³
		//ÀÄÄÄÄÄÄÄÄÙ
		aAdd (aPaineis, {})
		nPos	:=	Len (aPaineis)
		aAdd (aPaineis[nPos], STR0005) //"Preencha corretamente as informacoes solicitadas."
		aAdd (aPaineis[nPos], STR0007) //"Parametros para Geração"
		aAdd (aPaineis[nPos], {})
		//
		cTitObj1 := STR0008;								cTitObj2 := STR0009 //"Data de"###"Data até"
		aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});		aAdd (aPaineis[nPos][3], {1, cTitObj2,,,,,,})
		//
		aAdd (aPaineis[nPos][3], {2,,,3,,,,});				aAdd (aPaineis[nPos][3], {2,,,3,,,,}) 
		//
		aAdd (aPaineis[nPos][3], {0,"",,,,,,});			aAdd (aPaineis[nPos][3], {0,"",,,,,,})
		//
		cTitObj1 := STR0010 //"Livro"
		aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});		aAdd (aPaineis[nPos][3], {0,"",,,,,,})
		//
		cTitObj1 := Replicate ("X", 1)
		aAdd (aPaineis[nPos][3], {2,,cTitObj1,1,,,,1});	aAdd (aPaineis[nPos][3], {0,"",,,,,,})
		//
		aAdd (aPaineis[nPos][3], {0,"",,,,,,});			aAdd (aPaineis[nPos][3], {0,"",,,,,,})
		//
		cTitObj1 := STR0011;								cTitObj2 := STR0012 //"Diretório do Arquivo Destino"###"Nome do Arquivo Destino"
		aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});		aAdd (aPaineis[nPos][3], {1, cTitObj2,,,,,,})
		//
		cTitObj1 := Replicate ("X", 50);					cTitObj2 := Replicate ("X", 20)
		aAdd (aPaineis[nPos][3], {2,,cTitObj1,1,,,,50});	aAdd (aPaineis[nPos][3], {2,,cTitObj2,1,,,,20})
		//
		aAdd (aPaineis[nPos][3], {0,"",,,,,,});			aAdd (aPaineis[nPos][3], {0,"",,,,,,})
		//
		cTitObj1 := STR0058;								cTitObj2 := STR0061 // "Gera Inventário"#"Gera Registros Complentares de Frete"
		aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});		aAdd (aPaineis[nPos][3], {1, cTitObj2,,,,,,})
		//
		aItens1 := {};										aItens2 := {}
		aAdd (aItens1, STR0059);							aAdd (aItens2, STR0059) //"1-Sim"
		aAdd (aItens1, STR0060);							aAdd (aItens2, STR0060) //"2-Não"
		aAdd (aPaineis[nPos][3], {3,,,,,aItens1,,});		aAdd (aPaineis[nPos][3], {3,,,,,aItens2,,})
		//
		aAdd (aPaineis[nPos][3], {0,"",,,,,,});			aAdd (aPaineis[nPos][3], {0,"",,,,,,})
		//
		cTitObj1 := STR0989;								cTitObj2 := STR0990	//"Gera Detalhamento de Notas Fiscais (Blocos C e D)"###"Contribuinte Do Simples - Nacional"
		aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});		aAdd (aPaineis[nPos][3], {1, cTitObj2,,,,,,})
		//
		aAdd (aPaineis[nPos][3], {3,,,,,aItens1,,});		aAdd (aPaineis[nPos][3], {3,,,,,aItens2,,})
		//
		aAdd (aPaineis[nPos][3], {0,"",,,,,,});			aAdd (aPaineis[nPos][3], {0,"",,,,,,})
		//
		cTitObj1 := STR0999;								cTitObj2 := STR1004	//"Data Inventário"###"Gera Registro B350?"
		//
		aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});		aAdd (aPaineis[nPos][3], {1, cTitObj2,,,,,,})
		//
		aAdd (aPaineis[nPos][3], {2,,,3,,,,})
		//
		aItens3 := {}
		aAdd (aItens3, STR0060)
		aAdd (aItens3, STR0059)
		aAdd (aPaineis[nPos][3], {3,,,,,aItens3,,})
		//
		aAdd (aPaineis[nPos][3], {0,"",,,,,,});			aAdd (aPaineis[nPos][3], {0,"",,,,,,})
		//
		cTitObj1 := STR1005;								cTitObj2 := STR1006	//"Gera Registro B475?"###"Gera Bloco E?"
		aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});		aAdd (aPaineis[nPos][3], {1, cTitObj2,,,,,,})
		aAdd (aPaineis[nPos][3], {3,,,,,aItens1,,});		aAdd (aPaineis[nPos][3], {3,,,,,aItens2,,})
		//
		aAdd (aPaineis[nPos][3], {0,"",,,,,,});			aAdd (aPaineis[nPos][3], {0,"",,,,,,})
		//
		aItens4	:=	{}
		aAdd (aItens4, "01-Final do período")
		aAdd (aItens4, "02-Mudança de trib. da mercadoria (ICMS)")
		//aAdd (aItens4, "03-Solic. da baixa cad., paral. temp. e outras")
		//aAdd (aItens4, "04-Na alteração de regime de pagamento")
		//aAdd (aItens4, "05-Por determinação dos fiscos")
		//
		cTitObj1 := STR1007;	/*"Titulo RPS Autonomos?"*/		cTitObj2	:=	STR1008 //"Motivo do Inventário" 
		aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});		aAdd (aPaineis[nPos][3], {1,cTitObj2,,,,,,})
		aAdd (aPaineis[nPos][3], {3,,,,,aItens1,,});			aAdd (aPaineis[nPos][3], {3,,,,,aItens4,,})
		//
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Painel 1³
		//ÀÄÄÄÄÄÄÄÄÙ
		aAdd (aPaineis, {})
		nPos := Len (aPaineis)
		aAdd (aPaineis[nPos], STR0005) //"Preencha corretamente as informacoes solicitadas."
		aAdd (aPaineis[nPos], STR0013) //"Identificação do Contribuinte"
		aAdd (aPaineis[nPos], {})
		//
		cTitObj1 := STR0014;								cTitObj2 := STR0015 //"Cídigo da Finalidade do Arquivo"###"Indicador de Centralização de escrituração"
		aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});		aAdd (aPaineis[nPos][3], {1, cTitObj2,,,,,,})
		//
		aItens1 := {}
		aItens2 := {}
		aAdd (aItens1, STR0016);							aAdd (aItens2, STR0017) //"00-Remessa regularde arquivo"###"0-Estabelecimento sem centralização"
		aAdd (aItens1, STR0018);							aAdd (aItens2, STR0019) //"01-Remessa de arquivo substituto"###"1-Estabelecimento centralizador"
		aAdd (aItens1, STR0020);							aAdd (aItens2, STR0021) //"02-Rem. de arquivo com dados adicionais"###"2-Estabelecimento centralizado"
		aAdd (aItens1, STR0022) //"03-Rem. req. por intimação específica"
		aAdd (aItens1, STR0023) //"04-Rem. req. p/ correção do ind. part. Mun."
		aAdd (aItens1, STR0024) //"05-Rem. req. por ato pulicado DOU"
		aAdd (aItens1, STR0025) //"20-Sintegra-Rem. regular interestaduais"
		aAdd (aItens1, STR0026) //"21-Sintegra-Rem. regular interest. ST"
		aAdd (aItens1, STR0027) //"30-Emissão de documentos"
		aAdd (aItens1, STR0028) //"31-Emissao documento avulso por rep. faz."
		aAdd (aItens1, STR0029) //"61-Solicitação de auditor-fiscal pelo MPF"
		aAdd (aItens1, STR0030) //"62-Entrega na SRP, anual conf. intimação"
		aAdd (aItens1, STR0031) //"90-Rem. inf. compl. para SEFAZ da UF Origem"
		//
		aAdd (aPaineis[nPos][3], {3,,,,,aItens1,,});		aAdd (aPaineis[nPos][3], {3,,,,,aItens2,,})
		//
		aAdd (aPaineis[nPos][3], {0,"",,,,,,});			aAdd (aPaineis[nPos][3], {0,"",,,,,,})
		//
		aAdd (aPaineis[nPos][3], {0,"",,,,,,});			aAdd (aPaineis[nPos][3], {0,"",,,,,,})
		//
		aAdd (aPaineis[nPos][3], {0,"",,,,,,});			aAdd (aPaineis[nPos][3], {0,"",,,,,,})
		//
		cTitObj1 := STR0034 //"INFORMAÇÕES CADASTRAIS"
		aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});		aAdd (aPaineis[nPos][3], {0,"",,,,,,})
		//
		aAdd (aPaineis[nPos][3], {0,"",,,,,,});			aAdd (aPaineis[nPos][3], {0,"",,,,,,})
		//
		cTitObj1 := STR0035 //"E-Mail"
		aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});		aAdd (aPaineis[nPos][3], {0,"",,,,,,})
		//
		cTitObj1 := Replicate ("X", 50)
		aAdd (aPaineis[nPos][3], {2,,cTitObj1,1,,,,50});	aAdd (aPaineis[nPos][3], {0,"",,,,,,})
		//
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Painel 2³
		//ÀÄÄÄÄÄÄÄÄÙ
		aAdd (aPaineis, {})
		nPos	:=	Len (aPaineis)
		aAdd (aPaineis[nPos], STR0005) //"Preencha corretamente as informacoes solicitadas."
		aAdd (aPaineis[nPos], STR0036) //"Dados do contabilista"
		aAdd (aPaineis[nPos], {})
		//
		cTitObj1 := STR0037 //"Nome"
		aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});		aAdd (aPaineis[nPos][3], {0,"",,,,,,})
		//
		cTitObj1 := Replicate ("X", 40)
		aAdd (aPaineis[nPos][3], {2,,cTitObj1,1,,,,40});	aAdd (aPaineis[nPos][3], {0,"",,,,,,})
		//
		aAdd (aPaineis[nPos][3], {0,"",,,,,,});			aAdd (aPaineis[nPos][3], {0,"",,,,,,})
		//
		cTitObj1 := STR0038;								cTitObj2 := STR0039 //"CNPJ"###"CPF"
		aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});		aAdd (aPaineis[nPos][3], {1, cTitObj2,,,,,,})
		//
		cTitObj1 := Replicate ("X", 14);					cTitObj2 := Replicate ("X", 11)
		aAdd (aPaineis[nPos][3], {2,,cTitObj1,1,,,,14});	aAdd (aPaineis[nPos][3], {2,,cTitObj2,1,,,,11})
		//
		aAdd (aPaineis[nPos][3], {0,"",,,,,,});			aAdd (aPaineis[nPos][3], {0,"",,,,,,})
		//
		cTitObj1 := STR0040 //"CRC"
		aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});		aAdd (aPaineis[nPos][3], {0,"",,,,,,})
		//
		cTitObj1 := Replicate ("X", 11)
		aAdd (aPaineis[nPos][3], {2,,cTitObj1,1,,,,11});	aAdd (aPaineis[nPos][3], {0,"",,,,,,})
		//
		aAdd (aPaineis[nPos][3], {0,"",,,,,,});			aAdd (aPaineis[nPos][3], {0,"",,,,,,})
		//
		cTitObj1 := STR0041;								cTitObj2 := STR0042 //"UF"###"CEP"
		aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});		aAdd (aPaineis[nPos][3], {1, cTitObj2,,,,,,})
		//
		cTitObj1 := Replicate ("X", 2);						cTitObj2 := "@E 99999999"
		aAdd (aPaineis[nPos][3], {2,,cTitObj1,1,,,,2});	aAdd (aPaineis[nPos][3], {2,,cTitObj2,2,0,,,8})
		//
		aAdd (aPaineis[nPos][3], {0,"",,,,,,});			aAdd (aPaineis[nPos][3], {0,"",,,,,,})
		//
		cTitObj1 := STR0043;								cTitObj2 := STR0044 //"Endereço"###"Número"
		aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});		aAdd (aPaineis[nPos][3], {1, cTitObj2,,,,,,})
		//
		cTitObj1 := Replicate ("X", 50);					cTitObj2 := Replicate ("X", 5)
		aAdd (aPaineis[nPos][3], {2,,cTitObj1,1,,,,50});	aAdd (aPaineis[nPos][3], {2,,cTitObj2,1,,,,5})
		//
		aAdd (aPaineis[nPos][3], {0,"",,,,,,});			aAdd (aPaineis[nPos][3], {0,"",,,,,,})
		//
		cTitObj1 := STR0045;								cTitObj2 := STR0046 //"Complemento"###"Bairro"
		aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});		aAdd (aPaineis[nPos][3], {1, cTitObj2,,,,,,})
		//
		cTitObj1 := Replicate ("X", 20);					cTitObj1 := Replicate ("X", 15)
		aAdd (aPaineis[nPos][3], {2,,cTitObj1,1,,,,20});	aAdd (aPaineis[nPos][3], {2,,cTitObj1,1,,,,15})
		//
		aAdd (aPaineis[nPos][3], {0,"",,,,,,});			aAdd (aPaineis[nPos][3], {0,"",,,,,,})
		//
		cTitObj1 := STR0047;								cTitObj2 := STR0048 //"CEP Caixa Postal"###"Caixa Postal"
		aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});		aAdd (aPaineis[nPos][3], {1, cTitObj2,,,,,,})
		//
		cTitObj1 := "@E 99999999";							cTitObj2 := "@E 9999999999"
		aAdd (aPaineis[nPos][3], {2,,cTitObj1,2,0,,,8});	aAdd (aPaineis[nPos][3], {2,,cTitObj2,2,0,,,10})
		//
		aAdd (aPaineis[nPos][3], {0,"",,,,,,});			aAdd (aPaineis[nPos][3], {0,"",,,,,,})
		//
		cTitObj1 := STR0049;								cTitObj2 := STR0050 //"Fone"###"Fax"
		aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});		aAdd (aPaineis[nPos][3], {1, cTitObj2,,,,,,})
		//
		cTitObj1 := Replicate ("X", 15);					cTitObj2 := Replicate ("X", 15)
		aAdd (aPaineis[nPos][3], {2,,cTitObj1,1,,,,15});	aAdd (aPaineis[nPos][3], {2,,cTitObj2,1,,,,15})
		//
		aAdd (aPaineis[nPos][3], {0,"",,,,,,});			aAdd (aPaineis[nPos][3], {0,"",,,,,,})
		//
		cTitObj1 := STR0035 //"E-Mail"
		aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});		aAdd (aPaineis[nPos][3], {0,"",,,,,,})
		//
		cTitObj1 := Replicate ("X", 50)
		aAdd (aPaineis[nPos][3], {2,,cTitObj1,1,,,,50});	aAdd (aPaineis[nPos][3], {0,"",,,,,,})
		//
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Painel 3³
		//ÀÄÄÄÄÄÄÄÄÙ
		aAdd (aPaineis, {})
		nPos	:=	Len (aPaineis)
		aAdd (aPaineis[nPos], STR0005) //"Preencha corretamente as informacoes solicitadas."
		aAdd (aPaineis[nPos], STR0051) //"Dados do técnico/empresa"
		aAdd (aPaineis[nPos], {})
		//
		cTitObj1 := STR0037 //"Nome"
		aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});		aAdd (aPaineis[nPos][3], {0,"",,,,,,})
		//
		cTitObj1 := Replicate ("X", 40)
		aAdd (aPaineis[nPos][3], {2,,cTitObj1,1,,,,40});	aAdd (aPaineis[nPos][3], {0,"",,,,,,})
		//
		aAdd (aPaineis[nPos][3], {0,"",,,,,,});			aAdd (aPaineis[nPos][3], {0,"",,,,,,})
		//
		cTitObj1 := STR0038;								cTitObj2 := STR0039 //"CNPJ"###"CPF"
		aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});		aAdd (aPaineis[nPos][3], {1, cTitObj2,,,,,,})
		//
		cTitObj1 := Replicate ("X", 14);					cTitObj2 := Replicate ("X", 11)
		aAdd (aPaineis[nPos][3], {2,,cTitObj1,1,,,,14});	aAdd (aPaineis[nPos][3], {2,,cTitObj2,1,,,,11})
		//
		aAdd (aPaineis[nPos][3], {0,"",,,,,,});			aAdd (aPaineis[nPos][3], {0,"",,,,,,})
		//
		cTitObj1 := STR0049;								cTitObj2 := STR0050 //"Fone"###"Fax"
		aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});		aAdd (aPaineis[nPos][3], {1, cTitObj2,,,,,,})
		//
		cTitObj1 := Replicate ("X", 15);					cTitObj2 := Replicate ("X", 15)
		aAdd (aPaineis[nPos][3], {2,,cTitObj1,1,,,,15});	aAdd (aPaineis[nPos][3], {2,,cTitObj2,1,,,,15})
		//
		aAdd (aPaineis[nPos][3], {0,"",,,,,,});			aAdd (aPaineis[nPos][3], {0,"",,,,,,})
		//
		cTitObj1 := STR0035 //"E-Mail"
		aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});		aAdd (aPaineis[nPos][3], {0,"",,,,,,})
		//
		cTitObj1 := Replicate ("X", 50)
		aAdd (aPaineis[nPos][3], {2,,cTitObj1,1,,,,50});	aAdd (aPaineis[nPos][3], {0,"",,,,,,})
	Else
		aAdd (aTxtApre, STR0004)	//"Parametros necessarios."
		aAdd (aTxtApre, "")	
		aAdd (aTxtApre, STR0005)	//"Preencha corretamente as informacoes solicitadas."
		aAdd (aTxtApre, STR0947)	//"Informacoes necessarias para a impressão de um relatório de conferência do ATO COTEPE N. 35/05, baseado no arquivo texto já gerado através desta mesma rotina."
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Painel 0³
		//ÀÄÄÄÄÄÄÄÄÙ
		aAdd (aPaineis, {})
		nPos	:= Len (aPaineis)
		aAdd (aPaineis[nPos], STR0005)	//"Preencha corretamente as informacoes solicitadas."
		aAdd (aPaineis[nPos], STR0007)	//"Parametros para Geração"
		aAdd (aPaineis[nPos], {})
		//
		aAdd (aPaineis[nPos][3], {0,"",,,,,,});			aAdd (aPaineis[nPos][3], {0,"",,,,,,})
		//
		aAdd (aPaineis[nPos][3], {0,"",,,,,,});			aAdd (aPaineis[nPos][3], {0,"",,,,,,})
		//
		aAdd (aPaineis[nPos][3], {0,"",,,,,,});			aAdd (aPaineis[nPos][3], {0,"",,,,,,})
		//
		aAdd (aPaineis[nPos][3], {0,"",,,,,,});			aAdd (aPaineis[nPos][3], {0,"",,,,,,})
		//
		aAdd (aPaineis[nPos][3], {0,"",,,,,,});			aAdd (aPaineis[nPos][3], {0,"",,,,,,})
		//
		aAdd (aPaineis[nPos][3], {0,"",,,,,,});			aAdd (aPaineis[nPos][3], {0,"",,,,,,})
		//
		cTitObj1 := STR0948;								cTitObj2 := Replicate("X",100)	//"Informe o Arquivo origem"
		aAdd (aPaineis[nPos][3], {1, cTitObj1,,,,,,});		aAdd (aPaineis[nPos][3], {2,,cTitObj2,1,,,,100,,.T.})
	EndIf
	lRet := xMagWizard (aTxtApre, aPaineis, cNomWiz)
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |RetStr    ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³  RECEBE, TRANSFORMA E RETORNA A STRING NO FORMATO EXIGIDO  ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Transforma a string ou valor passado para o padrao exigido  ³±±
±±³          ³ pelo leyout.                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³xRet -> A string ou valor no padrao do layout               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|xValor -> Conteudo a ser padronizado                        ³±±
±±³          ³cEspecial -> Clausula para tratamentos especiais quando o   ³±±
±±³          ³ conteudo for do tipo string.                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RetStr (xValor, cEspecial)
	Local xRet
	//
	Default	cEspecial := ""
	//
	If (ValType (xValor)=="N")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Todas as variaveis numericas que nao tiverem formatacao especifica ("VLR3")  |
		//³serao convertidas para apresentarem 2 decimais. Portanto, se houver um campo |
		//|que tenha outra formatacao e o seu tipo seja numerico, deve-se converter     |
		//|para string antes da gravacao do mesmo, ou usar o "VLR3".                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (xValor==0)
			xRet := "0"
		ElseIf ("VLR3"$cEspecial)
			xRet := AllTrim (StrTran (Str (xValor,,3), ".", ","))
		Else
			xRet := AllTrim (StrTran (Str (xValor,,2), ".", ","))
		EndIf
		
	ElseIf (ValType (xValor)=="C")
		If ("COD"$cEspecial)
			xRet := ARetDig (AllTrim (xValor), .F.)
		Else
			xRet := AllTrim (xValor)
		EndIf
	
	ElseIf (ValType (xValor)=="D")
		xRet := StrZero (Day (xValor), 2)+StrZero (Month (xValor), 2)+StrZero (Year (xValor), 4)
	
	EndIf
Return (xRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |GrvRegTrb ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³              GRAVACAO DO REGISTRO NO TRB                   ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Gravacao do registro passado como parametro (aReg) no TRB   ³±±
±±³          ³ que sera posteiormente lido e gerado o TXT.                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³lRet -> .T.                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cAlias -> Alias do TRB gerado na funcao principal           ³±±
±±³          ³nRelac -> Codigo de indicacao de relacionamento com outros  ³±±
±±³          ³ registros.                                                 ³±±
±±³          ³aReg -> Registro a ser gravado no TRB.                      ³±±
±±³          ³nItem -> Identificador de itens para um mesmo relacionamento³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function GrvRegTrb(cAlias, nRelac, aReg, nItem, cSequ)
	Local	nX			:= 0
	Local	lRet		:= .T.
	Local	cDelimit	:= "|"
	Local	nZ			:= 0
	Local	cLinha		:= ""

	Default	nRelac		:= 0
	Default	cSequ		:= ""

	For nZ := 1 To Len(aReg)
		cLinha	:=	cDelimit
		//
		//Monto cLinha para gravar no TRB
		For nX := 1 To Len (aReg[nZ])
			If (ValType (aReg[nZ][nX])="A")
				cLinha	+=	RetStr (aReg[nZ][nX][1], aReg[nZ][nX][2])+cDelimit
			ElseIf !(ValType (aReg[nZ][nX])="U")
				cLinha	+=	RetStr (aReg[nZ][nX])+cDelimit
			EndIf
		Next (nX)
		//Tratamento para nao permitir gerar uma string maior que o tamanho do campo TRB_CONT. Se acontecer, somente serah no registro 0450.
		If Len(cLinha)>Len((cAlias)->TRB_CONT)
			cLinha	:=	AllTrim(Left(cLinha,Len((cAlias)->TRB_CONT)-1))+cDelimit
		EndIf
		//
		//Monto TRB 
		If Len(cLinha) > 1
			RecLock (cAlias, .T.)
				(cAlias)->TRB_TPREG := SubStr (cLinha, 2, 4)
				(cAlias)->TRB_RELAC := StrZero (nRelac, 9, 0)
				(cAlias)->TRB_CONT  := cLinha
				(cAlias)->TRB_ITEM  := nItem
				(cAlias)->TRB_SEQU  := cSequ
			MsUnLock()
		EndIf
		
	Next (nZ)
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |GeraTrb   ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³              GERACAO DA ESTRUTURA DO TRB                   ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Geracao da estrutura do TRB utilizado em todo o processamento³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³lRet -> .T.                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|nTipo -> 1=Gerar o TRB, 2=Fechar o TRB                      ³±±
±±³          ³cArq -> Nome fisico do TRB criado                           ³±±
±±³          ³cAlias -> Alias do TRB criado                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraTrb (nTipo, aArq, cAlias)
	Local	lRet	:= .T.
	Local	aCmp	:= {}
	Local	cArq	:= ""
	Local	nI		:= 0
	//
	If (nTipo==1)
		//ÚÄÄÄÄÄÄÄÄÄ¿
		//³TRB Geral³
		//ÀÄÄÄÄÄÄÄÄÄÙ
		cAlias	:=	"TRB"
		aAdd (aCmp, {"TRB_TPREG",	"C", 	004,		0})
		aAdd (aCmp, {"TRB_RELAC",	"C", 	009,		0})
		aAdd (aCmp, {"TRB_FLAG",	"C", 	001,		0})
		aAdd (aCmp, {"TRB_CONT",	"C", 	999,		0})
		aAdd (aCmp, {"TRB_ITEM",	"N", 	005,		0})
		aAdd (aCmp, {"TRB_SEQU",	"C", 	TamSx3("B1_COD")[1],	0}) //usado p/ ordenar  os produtos do registro 0210
		cArq	:=	CriaTrab (aCmp)
		DbUseArea (.T., __LocalDriver, cArq, cAlias)
		IndRegua (cAlias, cArq, "TRB_TPREG+TRB_RELAC+StrZero(TRB_ITEM,5)+TRB_SEQU")  
		aAdd (aArq, {cAlias, cArq})
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³TRB PRD = Registro 0200 - Tabela de identificacao do item³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aCmp	:=	{}
		cAlias	:=	"PRD"
		aAdd (aCmp, {"PRD_CODITE",	"C", 	TamSx3("B1_COD")[1],		0})
		aAdd (aCmp, {"PRD_DESC",	"C", 	TamSx3("B1_DESC")[1],		0})
		aAdd (aCmp, {"PRD_CODGEN",	"C", 	2,							0})
		aAdd (aCmp, {"PRD_CODLST",	"C", 	TamSx3("B1_CODISS")[1],		0})
		//
		cArq	:=	CriaTrab (aCmp)
		DbUseArea (.T., __LocalDriver, cArq, cAlias)
		IndRegua (cAlias, cArq, "PRD_CODITE")
		aAdd (aArq, {cAlias, cArq})
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³TRB PAR = Registro 0150 - Tabela de cadastro de participantes³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aCmp	:=	{}
		cAlias	:=	"PAR"
		aAdd (aCmp, {"PAR_REG",		"C", 	4,					0})
		nTam	:=	3+FWGETTAMFILIAL+TamSx3("A1_COD")[1]+TamSx3("A1_LOJA")[1]
		aAdd (aCmp, {"PAR_CODPAR",	"C", 	nTam,				0})
		nTam	:=	TamSx3("A1_NOME")[1]
		aAdd (aCmp, {"PAR_NOME",	"C", 	nTam,				0})
		aAdd (aCmp, {"PAR_CODPAI",	"C", 	5,					0})
		aAdd (aCmp, {"PAR_CNPJ",	"C", 	14,					0})
		aAdd (aCmp, {"PAR_CPF",		"C", 	11,					0})
		aAdd (aCmp, {"PAR_CEI",		"C", 	12,					0})
		aAdd (aCmp, {"PAR_NIT",		"C", 	11,					0})
		aAdd (aCmp, {"PAR_UF",		"C", 	02,					0})
		nTam	:=	TamSx3("A1_INSCR")[1]
		aAdd (aCmp, {"PAR_IE",		"C", 	nTam,				0})
		aAdd (aCmp, {"PAR_IEST",	"C", 	nTam,				0})	//NAO UTILIZADO
		aAdd (aCmp, {"PAR_CODMUN",	"C", 	7,					0})
		nTam	:=	TamSx3("A1_INSCRM")[1]
		aAdd (aCmp, {"PAR_IM",		"C", 	nTam,				0})
		aAdd (aCmp, {"PAR_SUFRAM",	"C", 	9,					0})
		//
		cArq	:=	CriaTrab (aCmp)
		DbUseArea (.T., __LocalDriver, cArq, cAlias)
		IndRegua (cAlias, cArq, "PAR_CODPAR")
		aAdd (aArq, {cAlias, cArq})
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³TRB END = Registro 0175 - Endereco do participante³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aCmp	:=	{}
		cAlias	:=	"EDP"
		aAdd (aCmp, {"EDP_REG",		"C", 	04,					0})
		nTam	:=	3+FWGETTAMFILIAL+TamSx3("A1_COD")[1]+TamSx3("A1_LOJA")[1]
		aAdd (aCmp, {"EDP_CODPAR",	"C", 	nTam,				0})
		aAdd (aCmp, {"EDP_CEP",		"C", 	08,					0})
		nTam	:=	TamSx3("A1_END")[1]
		aAdd (aCmp, {"EDP_END",		"C", 	nTam,				0})
		aAdd (aCmp, {"EDP_NUM",		"C", 	10,					0})
		aAdd (aCmp, {"EDP_COMPL",	"C", 	30,					0})	//NAO UTILIZADO
		nTam	:=	TamSx3("A1_BAIRRO")[1]
		aAdd (aCmp, {"EDP_BAIRRO",	"C", 	nTam,				0})
		aAdd (aCmp, {"EDP_CEPCP",	"C", 	08,					0})
		nTam	:=	TamSx3("A1_CXPOSTA")[1]
		aAdd (aCmp, {"EDP_CP",		"C", 	nTam,				0})
		nTam	:=	TamSx3("A1_DDD")[1]+TamSx3("A1_TEL")[1]
		aAdd (aCmp, {"EDP_FONE",	"C", 	nTam,				0})
		aAdd (aCmp, {"EDP_FAX",		"C", 	nTam,				0})
		//
		cArq	:=	CriaTrab (aCmp)
		DbUseArea (.T., __LocalDriver, cArq, cAlias)
		IndRegua (cAlias, cArq, "EDP_CODPAR")
		aAdd (aArq, {cAlias, cArq})
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³TRB END = Registro 0175 - Endereco do participante³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aCmp	:=	{}
		cAlias	:=	"IVT"
		aAdd (aCmp, {"IVT_REG",		"C", 	04,					0})
		aAdd (aCmp, {"IVT_INDP",	"C", 	01,					0})
		nTam	:=	3+FWGETTAMFILIAL+TamSx3("A1_COD")[1]+TamSx3("A1_LOJA")[1]
		aAdd (aCmp, {"IVT_CODPAR",	"C", 	nTam,				0})
		aAdd (aCmp, {"IVT_INDINV",	"C", 	01,					0})
		aAdd (aCmp, {"IVT_NCM",		"C", 	08,					0})
		nTam	:=	TamSx3("B1_COD")[1]
		aAdd (aCmp, {"IVT_CODITE",	"C", 	nTam,				0})
		aAdd (aCmp, {"IVT_VLUNIT",	"N", 	16,					3})
		aAdd (aCmp, {"IVT_QTD",		"N", 	16,					3})
		nTam	:=	TamSx3("B1_UM")[1]
		aAdd (aCmp, {"IVT_UM",		"C", 	nTam,				0})
		aAdd (aCmp, {"IVT_VLITEM",	"N", 	16,					3})
		aAdd (aCmp, {"IVT_OBS",		"C", 	20,					0})
		//
		cArq	:=	CriaTrab (aCmp)
		DbUseArea (.T., __LocalDriver, cArq, cAlias)
		IndRegua (cAlias, cArq, "IVT_INDP+IVT_CODPAR+IVT_INDINV+IVT_CODITE")
		aAdd (aArq, {cAlias, cArq})
	Else
		For nI := 1 To Len (aArq)
			DbSelectArea (aArq[nI][1])
			(aArq[nI][1])->(DbCloseArea ())
			Ferase (aArq[nI][2]+GetDBExtension ())
			Ferase (aArq[nI][2]+OrdBagExt ())
		Next nI
	EndIf
	cAlias := "TRB" //Devo sempre retornar para os casos que nao tiverem TRB proprio.
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |RetSitDoc ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³              SITUACAO DO DOCUMENTO FISCAL                  ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Retorna a situacao do documento fiscal em processamento,    ³±±
±±³          ³ onde:                                                      ³±±
±±³          ³ 5=Devolucao                                                ³±±
±±³          ³ 6=Complemento                                              ³±±
±±³          ³ 2=Cancelado                                                ³±±
±±³          ³ 3=Cupom Cancelado                                          ³±±
±±³          ³ o=Normal                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³cSituaDoc -> Situacao do documento                          ³±±
±±³          ³ onde:                                                      ³±±
±±³          ³ 5=Devolucao                                                ³±±
±±³          ³ 6=Complemento                                              ³±±
±±³          ³ 2=Cancelado                                                ³±±
±±³          ³ 3=Cupom Cancelado                                          ³±±
±±³          ³ o=Normal                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cTipo -> F3_TIPO                                            ³±±
±±³          ³cAliasSFT -> Alias da tabela SFT filtrada na funcao principal³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RetSitDoc (cTipo, cAliasSFT)
	Local	cSituaDoc	:=	""
	//
	//Situacao da NF
	If (cTipo$"D")
		cSituaDoc	:=	"05"	//Devolucao
	ElseIf (cTipo$"ICPB")
		cSituaDoc	:=	"06"	//Complemento de IPI, Complemento de ICMS, Complemento de Preco e Beneficiamento			
	EndIf

	If !(Empty ((cAliasSFT)->FT_DTCANC))
		If (Empty ((cAliasSFT)->FT_PDV))
			If ValType((cAliasSFT)->FT_EMISSAO) == "C"
				If Month(STOD((cAliasSFT)->FT_EMISSAO))<>Month(STOD((cAliasSFT)->FT_ENTRADA))
					cSituaDoc	:=	"04"	//Documento Extemporaneo Cancelado
				Else
					cSituaDoc	:=	"02"	//Documento Cancelado
				EndIf
			Else
				If Month((cAliasSFT)->FT_EMISSAO)<>Month((cAliasSFT)->FT_ENTRADA)
					cSituaDoc	:=	"04"	//Documento Extemporaneo Cancelado
				Else
					cSituaDoc	:=	"02"	//Documento Cancelado
				EndIf
			EndIf
		Else
			cSituaDoc	:=	"03"	//Documento Cupom Cancelado
		EndIf						
	ElseIf Empty(cSituaDoc)
		If ValType((cAliasSFT)->FT_EMISSAO) == "C"
				If Month(STOD((cAliasSFT)->FT_EMISSAO))<>Month(STOD((cAliasSFT)->FT_ENTRADA))
					cSituaDoc	:=	"01"	//Documento Extemporaneo
				ElseIf Substr((cAliasSFT)->FT_OBSERV,1,8) $ "CF/SERIE|NF/SERIE" 
					cSituaDoc 	:= "06" //Documento referenciado
				Else
					cSituaDoc	:=	"00"	//Documento Normal
				EndIf
		Else
			If Month((cAliasSFT)->FT_EMISSAO)<>Month((cAliasSFT)->FT_ENTRADA)
					cSituaDoc	:=	"01"	//Documento Extemporaneo
				ElseIf Substr((cAliasSFT)->FT_OBSERV,1,8) $ "CF/SERIE|NF/SERIE" 
					cSituaDoc	:= "06" //Documento referenciado
				Else
					cSituaDoc	:=	"00"	//Documento Normal
				EndIf
		EndIf
	EndIf
Return (cSituaDoc)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |ProcSE1   ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³            PROCESSAMENTO DO CONTAS A RECEBER               ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Filtro os titulos do documento fiscal                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³aParc -> Array com as parcelas do documento fiscal, onde:   ³±±
±±³          ³ [1]=Tipo                                                   ³±±
±±³          ³ [2]=Historico                                              ³±±
±±³          ³ [3]=Numero                                                 ³±±
±±³          ³ [4]=Parcela                                                ³±±
±±³          ³ [5]=Vencimento Real                                        ³±±
±±³          ³ [6]=Valor                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ProcSE1 ()
	Local	aParc		:= {}
	Local	aArea		:= GetArea ()
	Local	cPrefixo	:= Iif (Empty (SF2->F2_PREFIXO), &(SuperGetMV ("MV_1DUPREF")), SF2->F2_PREFIXO)	//Verifica o Prefixo correto da Nota fiscal de Entrada
	Local	cNum		:= SF2->F2_DUPL
	Local	cCli		:= SF2->F2_CLIENTE
	Local	cLoj		:= SF2->F2_LOJA
	Local	cAliasSE1	:= "SE1"

	#IFDEF TOP
		If TcSrvType()<>"AS/400"
			cAliasSE1	:=	GetNextAlias()

			BeginSql Alias cAliasSE1

			COLUMN E1_VENCREA AS DATE

			SELECT 
				SE1.E1_FILIAL,SE1.E1_PREFIXO,SE1.E1_NUM,SE1.E1_PARCELA,SE1.E1_TIPO,
				SE1.E1_CLIENTE,SE1.E1_LOJA,SE1.E1_HIST,SE1.E1_VENCREA,SE1.E1_VALOR
			FROM 
				%Table:SE1% SE1
			WHERE 
				SE1.E1_FILIAL=%xFilial:SE1% AND
				SE1.E1_PREFIXO=%Exp:cPrefixo% AND
				SE1.E1_NUM=%Exp:cNum% AND
				SE1.E1_CLIENTE=%Exp:cCli% AND
				SE1.E1_LOJA=%Exp:cLoj% AND
				SE1.%NotDel%
			ORDER BY
				1,2,3,4,5
			EndSql
		Else
	#ENDIF
			DbSelectArea ("SE1")
				SE1->(DbSetOrder (2))
			dbSeek (xFilial("SE1")+cCli+cLoj+cPrefixo+cNum)
	#IFDEF TOP
		EndIf
	#ENDIF

	Do While (!(cAliasSE1)->(Eof ()) .And.;
		xFilial("SE1")==(cAliasSE1)->E1_FILIAL .And.;
		cCli==(cAliasSE1)->E1_CLIENTE .And.;
		cLoj==(cAliasSE1)->E1_LOJA .And.;
		cPrefixo==(cAliasSE1)->E1_PREFIXO .And.;
		cNum==(cAliasSE1)->E1_NUM )

		If !(AllTrim ((cAliasSE1)->E1_TIPO)$MVTAXA+"|"+MVTXA+"|"+MVABATIM)
			aAdd (aParc, {(cAliasSE1)->E1_TIPO, (cAliasSE1)->E1_HIST, (cAliasSE1)->E1_NUM, (cAliasSE1)->E1_PARCELA, (cAliasSE1)->E1_VENCREA, (cAliasSE1)->E1_VALOR})
		EndIf

		DbSelectArea (cAliasSE1)
		(cAliasSE1)->(DbSkip ())
	EndDo
	
	#IFDEF TOP
		DbSelectArea (cAliasSE1)
		(cAliasSE1)->(DbCloseArea ())
	#ENDIF

	RestArea (aArea)
Return (aParc)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |ProcSE2   ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³            PROCESSAMENTO DO CONTAS A PAGAR                 ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Filtro os titulos do documento fiscal. Copiado do MATA103x  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³aParc -> Array com as parcelas do documento fiscal, onde:   ³±±
±±³          ³ [1]=Tipo                                                   ³±±
±±³          ³ [2]=Historico                                              ³±±
±±³          ³ [3]=Numero                                                 ³±±
±±³          ³ [4]=Parcela                                                ³±±
±±³          ³ [5]=Vencimento Real                                        ³±±
±±³          ³ [6]=Valor                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ProcSE2 ()	//Copiado do MATA103x
	Local	aParc		:= {}
	Local	aArea		:= GetArea ()
	Local	cPrefixo	:= Iif (Empty (SF1->F1_PREFIXO), &(SuperGetMV ("MV_2DUPREF")), SF1->F1_PREFIXO)	//Verifica o Prefixo correto da Nota fiscal de Entrada
	Local	cAliasSE2	:= "SE2"
	Local	cNum		:= SF1->F1_DUPL
	Local	cFor		:= SF1->F1_FORNECE
	Local	cLoj		:= SF1->F1_LOJA

	#IFDEF TOP
		If TcSrvType()<>"AS/400"
			cAliasSE2	:=	GetNextAlias()
			
			BeginSql Alias cAliasSE2
			
			COLUMN E2_VENCREA AS DATE
			
			SELECT 
				SE2.E2_FILIAL,SE2.E2_PREFIXO,SE2.E2_NUM,SE2.E2_PARCELA,SE2.E2_TIPO,SE2.E2_FORNECE,SE2.E2_LOJA,
				SE2.E2_HIST,SE2.E2_VENCREA,SE2.E2_VALOR
			FROM 
				%Table:SE2% SE2
			WHERE 
				SE2.E2_FILIAL=%xFilial:SE2% AND
				SE2.E2_FORNECE=%Exp:cFor% AND
				SE2.E2_LOJA=%Exp:cLoj% AND
				SE2.E2_PREFIXO=%Exp:cPrefixo% AND "
				SE2.E2_NUM=%Exp:cNum% AND "
				SE2.%NotDel%
			ORDER BY
				1,2,3,4,5,6,7
			EndSql
		Else
	#ENDIF
			DbSelectArea ("SE2")
				SE2->(DbSetOrder (6))
			dbSeek (xFilial("SE2")+cFor+cLoj+cPrefixo+cNum)
	#IFDEF TOP
		EndIf
	#ENDIF

	Do While (!(cAliasSE2)->(Eof ()) .And.;
		xFilial("SE2")==(cAliasSE2)->E2_FILIAL .And.;
		cFor==(cAliasSE2)->E2_FORNECE .And.;
		cLoj==(cAliasSE2)->E2_LOJA .And.;
		cPrefixo==(cAliasSE2)->E2_PREFIXO .And.;
		cNum==(cAliasSE2)->E2_NUM )

		If !(AllTrim ((cAliasSE2)->E2_TIPO)$MVTAXA+"|"+MVTXA+"|"+MVABATIM)
			aAdd (aParc, {(cAliasSE2)->E2_TIPO, (cAliasSE2)->E2_HIST, (cAliasSE2)->E2_NUM, (cAliasSE2)->E2_PARCELA, (cAliasSE2)->E2_VENCREA, (cAliasSE2)->E2_VALOR})
		EndIf

		DbSelectArea (cAliasSE2)
		(cAliasSE2)->(DbSkip())
	EndDo
	#IFDEF TOP
		DbSelectArea (cAliasSE2)
		(cAliasSE2)->(DbCloseArea ())
	#ENDIF

	RestArea (aArea)
Return (aParc)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |LivrObs   ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³          OBSERVACAO PARA OS DOCUMENTOS FISCAIS             ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Montagem das observacoes dos documentos fiscais com seus    ³±±
±±³          ³ embasamentos legais. Rotina copiada o MATR930              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³aColObs -> Observacoes escrituradas no Livro Fiscal para o  ³±±
±±³          ³ documento fiscal processado no momento.                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cAliasSFT -> Alias da tabela SFT aberta no momento.         ³±±
±±³          ³ funcao a ser retornado para gravacao pela funcao principal.³±±
±±³          ³nEntSai -> Flag indicador de entrada(1)/saida(2).           ³±±
±±³          ³nTamObs -> Len de quebra para o campo de Observacao         ³±±
±±³          ³aLeis -> Embasamento legal para tal observacao.             ³±±
±±³          ³lCompFre -> Indica se é complemento de Frete.               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function LivrObs (cAliasSFT, nEntSai, nTamObs, aLeis, cChaveF3,lCompFre)
	Local	xx			:=	0
	Local	aColObs		:=	{}
	Local	cTitLivro	:=	AvalFomentar ()
	Local	cMensagem	:=	""
	Local	lNfDivers	:=	.F.
	Local	nMlCt		:=	0
	//
	aLeis		:=	{}
	
	If SF3->(dbSeek (cChaveF3))
		Do While !SF3->(Eof ()) .And.;
			cChaveF3==SF3->(F3_FILIAL+DTos(F3_ENTRADA)+F3_NFISCAL+F3_SERIE+F3_CLIEFOR+F3_LOJA)
			//
		   	If !Empty (SF3->F3_OBSERV)
		   		If (nEntSai==1)
			   	   	If ("N.F.ORIG.: DIVERSAS"$SF3->F3_OBSERV)
				   		cMensagem := SubStr (SF3->F3_OBSERV, 1, At (":", SF3->F3_OBSERV)+1)
			   		    //
						SD1->(dbSeek (xFilial ("SD1")+SF3->(F3_NFISCAL+F3_SERIE+F3_CLIEFOR+F3_LOJA)))
						//
		   		   		Do While !SD1->(Eof ()) .And.;
		   		   			xFilial ("SD1")+SF3->(F3_NFISCAL+F3_SERIE+F3_CLIEFOR+F3_LOJA)==SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)
		   		   			//
		   	   				If !(AllTrim (SD1->D1_NFORI+"/"+SD1->D1_SERIORI)$cMensagem)
			   	   				cMensagem += AllTrim (SD1->D1_NFORI+"/"+SD1->D1_SERIORI)+", "
			   	   			EndIf
			   	   			SD1->(DbSkip ())
		   		   		EndDo
		   		   		//
				   		cMensagem 	:= SubStr (cMensagem, 1, Len (cMensagem)-2)
				   		lNfDivers	:=	.T.
				   	Else
						cMensagem := Trim (SF3->F3_OBSERV)
				    EndIf
		   	  	Else
			   	   	If (("Dev. terc. N.F.ORIG.: DIVERSAS"$SF3->F3_OBSERV) .Or. ("N.F.ORIG.: DIVERSAS"$SF3->F3_OBSERV))
				   		cMensagem := SubStr (SF3->F3_OBSERV, 1, At(":", SF3->F3_OBSERV)+1)
			   		    //
						SD2->(dbSeek (xFilial ("SD2")+SF3->(F3_NFISCAL+F3_SERIE+F3_CLIEFOR+F3_LOJA)))
			   		    //
		   		   		Do While !SD2->(Eof ()) .And.;
			   		   		xFilial ("SD2")+SF3->(F3_NFISCAL+F3_SERIE+F3_CLIEFOR+F3_LOJA)==SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA)
		   		   			//
		   	   				If !(AllTrim (SD2->D2_NFORI+"/"+SD2->D2_SERIORI)$cMensagem)
			   	   				cMensagem += AllTrim (SD2->D2_NFORI+"/"+SD2->D2_SERIORI)+", "
			   	   			EndIf
			   	   			SD2->(DbSkip ())
		   		   		EndDo
		   		   		//
				   		cMensagem 	:= SubStr (cMensagem, 1, Len (cMensagem)-2)
				   		lNfDivers	:=	.T.
				   	Else
						cMensagem := Trim (SF3->F3_OBSERV)
				    EndIf
		   	  	EndIf
		  		//
				If (lNfDivers)
				   	aAdd (aLeis, "Art. 454 do RICMS")
				EndIf
				//
				If !Empty(cMensagem)
					nMlCt	:=	MlCount (cMensagem, nTamObs)
					If nMlCt==0
						aAdd (aColObs, cMensagem)
					Else
						For xx:=1 to nMlCt
							aAdd (aColObs, MemoLine (cMensagem, nTamObs, xx))
						Next xx
					EndIf
			   	EndIf
			Endif
		 	If !Empty (SF3->F3_FORMULA) .And. !(OemToAnsi ("CANCELADA")$SF3->F3_OBSERV)
				If (cMensagem	:=	Formula (SF3->F3_FORMULA))<>Nil
					nMlCt	:=	MlCount (cMensagem, nTamObs)
					If nMlCt==0
						aAdd (aColObs, cMensagem)
					Else
						For xx:=1 to nMlCt
							aAdd (aColObs, MemoLine (cMensagem, nTamObs, xx))
						Next xx
					EndIf
				EndIf
			Endif
			If (SF3->F3_VALOBSE>0)
				cMensagem	:=	"DESCONTO..."+Alltrim (TransForm (SF3->F3_VALOBSE, PesqPict ("SF3","F3_VALOBSE")))
				nMlCt	:=	MlCount (cMensagem, nTamObs)
				If nMlCt==0
					aAdd (aColObs, cMensagem)
				Else
					For xx:=1 to nMlCt
						aAdd (aColObs, MemoLine (cMensagem, nTamObs, xx))
					Next xx
				EndIf
			Endif
			If (SF3->F3_IPIOBS>0)
				cMensagem	:=	"IPI....."+Alltrim (TransForm (SF3->F3_IPIOBS, PesqPict ("SF3","F3_IPIOBS")))
				nMlCt	:=	MlCount (cMensagem, nTamObs)
				If nMlCt==0
					aAdd (aColObs, cMensagem)
				Else
					For xx:=1 to nMlCt
						aAdd (aColObs, MemoLine (cMensagem, nTamObs, xx))
					Next xx
				EndIf
			Endif
			If Empty (cTitLivro) .And. (SF3->F3_ICMSRET-SF3->F3_OBSSOL)>0 .And. lCompFre
					cMensagem	:= "ICMS sobre frete retido por substituição tributária: " +Alltrim (TransForm (SF3->F3_BASERET, PesqPict ("SF3","F3_BASERET")))+" "+Alltrim (TransForm (SF3->F3_ICMSRET-SF3->F3_OBSSOL, PesqPict ("SF3","F3_ICMSRET")))
			   		aAdd (aLeis, "Decreto nº 18.955, de 22 de dezembro de 1997, Anexo IV, Caderno IV, item 1. (AC)")
			   		nMlCt	:=	MlCount (cMensagem, nTamObs)
					If nMlCt==0
						aAdd (aColObs, cMensagem)
					Else
						For xx:=1 to nMlCt
							aAdd (aColObs, MemoLine (cMensagem, nTamObs, xx))
						Next xx
					EndIf
			Else
				If Empty (cTitLivro) .And. (SF3->F3_ICMSRET-SF3->F3_OBSSOL)>0
					cMensagem	:=	"ICMS RETIDO..: "+Alltrim (TransForm (SF3->F3_ICMSRET-SF3->F3_OBSSOL, PesqPict ("SF3","F3_ICMSRET")))
					nMlCt	:=	MlCount (cMensagem, nTamObs)
					If nMlCt==0
						aAdd (aColObs, cMensagem)
					Else
						For xx:=1 to nMlCt
							aAdd (aColObs, MemoLine (cMensagem, nTamObs, xx))
						Next xx
					EndIf
				Endif
			EndIf	
			If (SF3->F3_ICMSCOM>0)
				cMensagem	:=	"ICMS DIF.ALIQ: "+Alltrim (TransForm (SF3->F3_ICMSCOM, PesqPict ("SF3", "F3_ICMSCOM")))
				nMlCt	:=	MlCount (cMensagem, nTamObs)
				If nMlCt==0
					aAdd (aColObs, cMensagem)
				Else
					For xx:=1 to nMlCt
						aAdd (aColObs, MemoLine (cMensagem, nTamObs, xx))
					Next xx
				EndIf
			Endif
			If (SF3->F3_VALTST>0)
				cMensagem	:=	"ICMSST FRET.AUT: "+Alltrim (TransForm (SF3->F3_VALTST, PesqPict ("SF3", "F3_VALTST")))
				nMlCt	:=	MlCount (cMensagem, nTamObs)
				If nMlCt==0
					aAdd (aColObs, cMensagem)
				Else
					For xx:=1 to nMlCt
						aAdd (aColObs, MemoLine (cMensagem, nTamObs, xx))
					Next xx
				EndIf
			Endif
			If (SF3->F3_ICMAUTO>0)
				cMensagem	:=	"ICMS FRET.AUT: "+Alltrim (TransForm (SF3->F3_ICMAUTO, PesqPict ("SF3", "F3_ICMAUTO")))
				nMlCt	:=	MlCount (cMensagem, nTamObs)
				If nMlCt==0
					aAdd (aColObs, cMensagem)
				Else
					For xx:=1 to nMlCt
						aAdd (aColObs, MemoLine (cMensagem, nTamObs, xx))
					Next xx
				EndIf
			Endif
			If (SF3->F3_OBSICM>0)
				cMensagem	:=	"ICMS NORMAL: "+Alltrim (TransForm (SF3->F3_OBSICM, PesqPict("SF3", "F3_OBSICM")))
				nMlCt	:=	MlCount (cMensagem, nTamObs)
				If nMlCt==0
					aAdd (aColObs, cMensagem)
				Else
					For xx:=1 to nMlCt
						aAdd (aColObs, MemoLine (cMensagem, nTamObs, xx))
					Next xx
				EndIf
			Endif
			If SF3->F3_OBSSOL>0
				cMensagem	:=	"ICMS ST. INT.: "+Alltrim (TransForm (SF3->F3_OBSSOL, PesqPict("SF3", "F3_OBSSOL")))
				nMlCt	:=	MlCount (cMensagem, nTamObs)
				If nMlCt==0
					aAdd (aColObs, cMensagem)
				Else
					For xx:=1 to nMlCt
						aAdd (aColObs, MemoLine (cMensagem, nTamObs, xx))
					Next xx
				EndIf
			Endif
			
			//
			SF3->(DbSkip ())
		EndDo
	EndIf
Return (aColObs)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |OrgTxt    ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³             GRAVACAO DO TRB EM MEIO-MAGNETICO              ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Funcao de gravacao do meio-magnetico de acordo com o TRB.   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³lRet -> .T.                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cAlias -> Alias do TRB gerado na funcao principal.          ³±±
±±³          |cFile -> Nome do meio-magnetico a ser gerado.               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function OrgTxt (cAlias, cFile)
	Local	lRet		:=	.T.
	Local	lGravaReg8	:=	.F.
	Local	lGravaReg9	:=	.F.
	Local	nHandle		:=	-1
	Local	cRelac		:=	""
	Local	cChave		:=	""
	//
	If (File (cFile))
		FErase (cFile)
	Endif
	nHandle	:=	MsFCreate (cFile)
	//
	DbSelectArea (cAlias)
		(cAlias)->(DbSetOrder (1))
	ProcRegua ((cAlias)->(RecCount ()))
	(cAlias)->(DbGoTop ())
	//
	Do While !(cAlias)->(Eof ())
	
		IncProc(STR0053) //"Gerando arquivo texto"
	
		If (Empty ((cAlias)->TRB_FLAG))
				//
			cRelac	:=	(cAlias)->TRB_RELAC
			aArea	:=	(cAlias)->(GetArea ())
			//
			If ("0150"$(cAlias)->TRB_TPREG)
				cChave	:=	"0150"+cRelac
				If ((cAlias)->(DbSeek (cChave)))
					Do While !(cAlias)->(Eof ()) .And. cChave==(cAlias)->TRB_TPREG+(cAlias)->TRB_RELAC
						GravaLinha (nHandle, cAlias)
						//
						RegPorNf (nHandle, cAlias, "0175", cRelac, (cAlias)->TRB_ITEM)
						//
						(cAlias)->(DbSkip ())
					EndDo
				EndIf
				
			ElseIf ("0200"$(cAlias)->TRB_TPREG)
				cChave	:=	"0200"+cRelac
				If ((cAlias)->(DbSeek (cChave)))
					Do While !(cAlias)->(Eof ()) .And. cChave==(cAlias)->TRB_TPREG+(cAlias)->TRB_RELAC
						GravaLinha (nHandle, cAlias)
						//
						RegPorNf (nHandle, cAlias, "0210", cRelac, (cAlias)->TRB_ITEM)
						//
						(cAlias)->(DbSkip ())
					EndDo
				EndIf

			ElseIf ("0450"$(cAlias)->TRB_TPREG)
					cChave	:=	"0450"+cRelac
					If ((cAlias)->(DbSeek (cChave)))
						Do While !(cAlias)->(Eof ()) .And. cChave==(cAlias)->TRB_TPREG+(cAlias)->TRB_RELAC
							GravaLinha (nHandle, cAlias)
							//
							RegPorNf (nHandle, cAlias, "0455", cRelac, (cAlias)->TRB_ITEM)
							//
							RegPorNf (nHandle, cAlias, "0460", cRelac, (cAlias)->TRB_ITEM)
							//
							RegPorNf (nHandle, cAlias, "0465", cRelac, (cAlias)->TRB_ITEM)
							//
							(cAlias)->(DbSkip ())
						EndDo
					EndIf
			
			ElseIf ("A020"$(cAlias)->TRB_TPREG)
				GravaLinha (nHandle, cAlias)
				//
				
				cChave	:=	"A025"+cRelac
				If ((cAlias)->(DbSeek (cChave)))
					RegPorNf (nHandle, cAlias, "A025", cRelac, (cAlias)->TRB_ITEM)
				EndIf
				//
				cChave	:=	"A035"+cRelac
				If ((cAlias)->(DbSeek (cChave)))
					RegPorNf (nHandle, cAlias, "A035", cRelac, (cAlias)->TRB_ITEM)
				EndIf
				//
				cChave	:=	"A050"+cRelac
				If ((cAlias)->(DbSeek (cChave)))
					Do While !(cAlias)->(Eof ()) .And. cChave==(cAlias)->TRB_TPREG+(cAlias)->TRB_RELAC
						GravaLinha (nHandle, cAlias)
						//
						RegPorNf (nHandle, cAlias, "A055", cRelac, (cAlias)->TRB_ITEM)
						//
						(cAlias)->(DbSkip ())
					EndDo
				EndIf
				//

				cChave	:=	"A200"+cRelac
				If ((cAlias)->(DbSeek (cChave)))
					Do While !(cAlias)->(Eof ()) .And. cChave==(cAlias)->TRB_TPREG+(cAlias)->TRB_RELAC
						GravaLinha (nHandle, cAlias)
						//
						//RegPorNf (nHandle, cAlias, "C305", cRelac, (cAlias)->TRB_ITEM)
						(cAlias)->(DbSkip ())
					EndDo
				EndIf

			ElseIf ("A350"$(cAlias)->TRB_TPREG)
				cChave	:=	"A350"+cRelac
				If ((cAlias)->(DbSeek (cChave)))
					Do While !(cAlias)->(Eof ()) .And. cChave==(cAlias)->TRB_TPREG+(cAlias)->TRB_RELAC
						GravaLinha (nHandle, cAlias)
						//
						RegPorNf (nHandle, cAlias, "A360", cRelac, (cAlias)->TRB_ITEM)

						(cAlias)->(DbSkip ())
					EndDo
				EndIf

			ElseIf ("A300"$(cAlias)->TRB_TPREG)
				GravaLinha (nHandle, cAlias)

				RegPorNf (nHandle, cAlias, "A310", cRelac,)

			ElseIf ("B020"$(cAlias)->TRB_TPREG)
				GravaLinha (nHandle, cAlias)

				RegPorNf (nHandle, cAlias, "B025", cRelac,)
			ElseIf ("B030"$(cAlias)->TRB_TPREG)
				GravaLinha (nHandle, cAlias)

				RegPorNf (nHandle, cAlias, "B035", cRelac,)

			ElseIf ("B040"$(cAlias)->TRB_TPREG)
				GravaLinha (nHandle, cAlias)

				RegPorNf (nHandle, cAlias, "B045", cRelac,)			
			ElseIf ("B050"$(cAlias)->TRB_TPREG)
				GravaLinha (nHandle, cAlias)

				RegPorNf (nHandle, cAlias, "B055", cRelac,)

			ElseIf ("C020"$(cAlias)->TRB_TPREG)
				GravaLinha (nHandle, cAlias)
				//
				cChave	:=	"C030"+cRelac
				If ((cAlias)->(DbSeek (cChave)))
					Do While !(cAlias)->(Eof ()) .And. cChave==(cAlias)->TRB_TPREG+(cAlias)->TRB_RELAC
						GravaLinha (nHandle, cAlias)
						//
						RegPorNf (nHandle, cAlias, "C035", cRelac, (cAlias)->TRB_ITEM)
						//
						(cAlias)->(DbSkip ())
					EndDo
				EndIf
				//
				cChave	:=	"C040"+cRelac
				If ((cAlias)->(DbSeek (cChave)))
					RegPorNf (nHandle, cAlias, "C040", cRelac, (cAlias)->TRB_ITEM)
				EndIf
				//
				cChave	:=	"C050"+cRelac
				If ((cAlias)->(DbSeek (cChave)))
					RegPorNf (nHandle, cAlias, "C050", cRelac, (cAlias)->TRB_ITEM)
				EndIf
				//
				cChave	:=	"C060"+cRelac
				If ((cAlias)->(DbSeek (cChave)))
					RegPorNf (nHandle, cAlias, "C060", cRelac, (cAlias)->TRB_ITEM)
				EndIf

				cChave	:=	"C300"+cRelac
				If ((cAlias)->(DbSeek (cChave)))
					Do While !(cAlias)->(Eof ()) .And. cChave==(cAlias)->TRB_TPREG+(cAlias)->TRB_RELAC
						GravaLinha (nHandle, cAlias)
						//
						RegPorNf (nHandle, cAlias, "C305", cRelac, (cAlias)->TRB_ITEM)
						//
						RegPorNf (nHandle, cAlias, "C310", cRelac, (cAlias)->TRB_ITEM)
						//
						RegPorNf (nHandle, cAlias, "C315", cRelac, (cAlias)->TRB_ITEM)
						//
						RegPorNf (nHandle, cAlias, "C320", cRelac, (cAlias)->TRB_ITEM)
						//
						RegPorNf (nHandle, cAlias, "C325", cRelac, (cAlias)->TRB_ITEM)
						//
						(cAlias)->(DbSkip ())
					EndDo
				EndIf
				//
				RegPorNf (nHandle, cAlias, "C500", cRelac)

			ElseIf ("C550"$(cAlias)->TRB_TPREG)
				GravaLinha (nHandle, cAlias)
				//
				RegPorNf (nHandle, cAlias, "C555", cRelac)
				
			ElseIf ("C570"$(cAlias)->TRB_TPREG)
				cChave	:=	"C570"+cRelac
				If ((cAlias)->(DbSeek (cChave)))
					Do While !(cAlias)->(Eof ()) .And. cChave==(cAlias)->TRB_TPREG+(cAlias)->TRB_RELAC
						GravaLinha (nHandle, cAlias)
						//
						RegPorNf (nHandle, cAlias, "C575", cRelac, (cAlias)->TRB_ITEM)
						//
						(cAlias)->(DbSkip ())
					EndDo
				EndIf
				//
			ElseIf ("C600"$(cAlias)->TRB_TPREG)
				GravaLinha (nHandle, cAlias)
				//
				RegPorNf (nHandle, cAlias, "C605", cRelac)
				
			ElseIf ("C620"$(cAlias)->TRB_TPREG)
				GravaLinha (nHandle, cAlias)
				//
				RegPorNf (nHandle, cAlias, "C625", cRelac)
				
			ElseIf ("C700"$(cAlias)->TRB_TPREG)
				GravaLinha (nHandle, cAlias)
				//
				RegPorNf (nHandle, cAlias, "C705", cRelac)
				//
				RegPorNf (nHandle, cAlias, "C750", cRelac)
				//
				RegPorNf (nHandle, cAlias, "C760", cRelac)
				
			ElseIf ("C770"$(cAlias)->TRB_TPREG)
				cChave	:=	"C770"+cRelac
				If ((cAlias)->(DbSeek (cChave)))
					Do While !(cAlias)->(Eof ()) .And. cChave==(cAlias)->TRB_TPREG+(cAlias)->TRB_RELAC
						GravaLinha (nHandle, cAlias)
						//
						RegPorNf (nHandle, cAlias, "C775", cRelac, (cAlias)->TRB_ITEM)
						//
						RegPorNf (nHandle, cAlias, "C780", cRelac, (cAlias)->TRB_ITEM)
						//
						(cAlias)->(DbSkip ())
					EndDo
				EndIf
				
			ElseIf ("D020"$(cAlias)->TRB_TPREG)
				GravaLinha (nHandle, cAlias)
				//
				cChave	:=	"D030"+cRelac
				If ((cAlias)->(DbSeek (cChave)))
					Do While !(cAlias)->(Eof ()) .And. cChave==(cAlias)->TRB_TPREG+(cAlias)->TRB_RELAC
						GravaLinha (nHandle, cAlias)
						//
						RegPorNf (nHandle, cAlias, "D040", cRelac, (cAlias)->TRB_ITEM)
						//
						(cAlias)->(DbSkip ())
					EndDo
				EndIf
				//
				cChave	:=	"D050"+cRelac
				If ((cAlias)->(DbSeek (cChave)))
					Do While !(cAlias)->(Eof ()) .And. cChave==(cAlias)->TRB_TPREG+(cAlias)->TRB_RELAC
						GravaLinha (nHandle, cAlias)
						//
						RegPorNf (nHandle, cAlias, "D180", cRelac, (cAlias)->TRB_ITEM)
						//
						(cAlias)->(DbSkip ())
					EndDo
				EndIf

			ElseIf ("D200"$(cAlias)->TRB_TPREG)
				GravaLinha (nHandle, cAlias)
				RegPorNf (nHandle, cAlias, "D210", cRelac,(cAlias)->TRB_ITEM)
				cChave	:=	"D240"+cRelac
				If ((cAlias)->(DbSeek (cChave)))
					Do While !(cAlias)->(Eof ()) .And. cChave==(cAlias)->TRB_TPREG+(cAlias)->TRB_RELAC
						GravaLinha (nHandle, cAlias)
						//
						RegPorNf (nHandle, cAlias, "D250", cRelac,)
						//
						(cAlias)->(DbSkip ())
					EndDo
				EndIf
			
			ElseIf ("D400"$(cAlias)->TRB_TPREG)
				GravaLinha (nHandle, cAlias)
				//
				RegPorNf (nHandle, cAlias, "D405", cRelac,)
				//
				RegPorNf (nHandle, cAlias, "D450", cRelac,)
				
			ElseIf ("D470"$(cAlias)->TRB_TPREG)
				cChave	:=	"D470"+cRelac
				If ((cAlias)->(DbSeek (cChave)))
					Do While !(cAlias)->(Eof ()) .And. cChave==(cAlias)->TRB_TPREG+(cAlias)->TRB_RELAC
						GravaLinha (nHandle, cAlias)
						//
						RegPorNf (nHandle, cAlias, "D475", cRelac,)
						//
						(cAlias)->(DbSkip ())
					EndDo
				EndIf
				
			ElseIf ("E020"$(cAlias)->TRB_TPREG)
				GravaLinha (nHandle, cAlias)
				
				RegPorNf (nHandle, cAlias, "E025", cRelac,)
				
			ElseIf ("E050"$(cAlias)->TRB_TPREG)
				GravaLinha (nHandle, cAlias)
				
				RegPorNf (nHandle, cAlias, "E055", cRelac,)
				
			ElseIf ("E060"$(cAlias)->TRB_TPREG)
				GravaLinha (nHandle, cAlias)
				
				RegPorNf (nHandle, cAlias, "E065", cRelac,)

			ElseIf ("E080"$(cAlias)->TRB_TPREG)
				GravaLinha (nHandle, cAlias)
				
				RegPorNf (nHandle, cAlias, "E085", cRelac,)
				
			ElseIf ("E100"$(cAlias)->TRB_TPREG)
				GravaLinha (nHandle, cAlias)
				
				RegPorNf (nHandle, cAlias, "E105", cRelac,)
			
			ElseIf ( "8" $ Substr((cAlias)->TRB_TPREG,1,1))
				lGravaReg8 := .T.
				
			ElseIf ( "9" $ Substr((cAlias)->TRB_TPREG,1,1))
				lGravaReg9 := .T.
			
			Else
				GravaLinha (nHandle, cAlias)
					
			EndIf
			RestArea (aArea)
		EndIf
		//
		(cAlias)->(DbSkip ())
	EndDo
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Pela ordem definida no layout, os registros comecando com "8" e "9" devem ser  ³
	//³impressos no final do arquivo magnetico                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	If lGravaReg8
		(cAlias)->(DbSeek("8"))
		Do While !(cAlias)->(Eof ()) .And. Substr((cAlias)->TRB_TPREG,1,1) == "8"
			GravaLinha (nHandle, cAlias)
			(cAlias)->(DbSkip ())
		EndDo
	EndIf
	If lGravaReg9
		(cAlias)->(DbSeek("9"))
		Do While !(cAlias)->(Eof ()) .And. Substr((cAlias)->TRB_TPREG,1,1) == "9"
			GravaLinha (nHandle, cAlias)
			(cAlias)->(DbSkip ())
		EndDo
	EndIf
	//
	If (nHandle>=0)
		FClose (nHandle)
	Endif
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |RegPorNf  ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³   GRAVACAO DE UM REGISTRO RELACIONADO COM SEU SUPERIOR     ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Posiciono no registro com a chave passada como parametro e  ³±±
±±³          ³ gero o TXT na funcao Gravalinha                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³lRet -> .T.                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|nHandle -> Handle do arquivo txt aberto.                    ³±±
±±³          |cAlias -> Alias do TRB criado atraves da funcao principal.  ³±±
±±³          |cTpReg -> Tipo de registro que compoe a chave de pesquisa.  ³±±
±±³          |cRelac -> Relacionamento do registro que compoe a chave de  ³±±
±±³          | pesquisa                                                   ³±±
±±³          |nItem -> Item por relacionamento.                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RegPorNf (nHandle, cAlias, cTpReg, cRelac, nItem)
	Local	lRet	:= .T.
	Local	cChave	:= cTpReg+cRelac
	Local	aArea	:= (cAlias)->(GetArea ())
	//
	If (nItem<>Nil .And. nItem>0)
		cChave	+=	StrZero (nItem, 5, 0)
	EndIf
	//
	If ((cAlias)->(DbSeek (cChave)))
		Do While !(cAlias)->(Eof()) .And. cChave==(cAlias)->TRB_TPREG+(cAlias)->TRB_RELAC+Iif(nItem<>Nil .And. nItem>0, StrZero((cAlias)->TRB_ITEM,5,0),"")
			GravaLinha (nHandle, cAlias)
			//
			(cAlias)->(DbSkip ())
		EndDo
	EndIf
	//
	RestArea (aArea)
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |GravaLinha³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³      GRAVACAO DE UM REGISTRO E MARCA COMO GRAVADO          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Gravo o registro posicionado do TRB e marco ele como ja gra-³±±
±±³          ³ vado evitanto duplicidade.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³lRet -> .T.                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|nHandle -> Handle do arquivo txt aberto.                    ³±±
±±³          |cAlias -> Alias do TRB criado atraves da funcao principal.  ³±±
±±³          |cTpReg -> Tipo de registro que compoe a chave de pesquisa.  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GravaLinha (nHandle, cAlias)
	Local cConteudo := AllTrim ((cAlias)->TRB_CONT)+Chr (13)+Chr (10)	//+"**"+(cAlias)->TRB_RELAC+"**"
	//
	FWrite (nHandle, cConteudo, Len (cConteudo))
	//
	RecLock (cAlias, .F.)
		(cAlias)->TRB_FLAG := "*"
	MsUnLock ()
Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |GrRegDep  ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³              GRAVO REGISTROS DEPENDENTES                   ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Suponhamos o cabecalho e os itens do documento fiscal, onde ³±±
±±³          ³ o cabecalho eh o pai e os itens eh o filho, portanto tenho ³±±
±±³          ³ varios itens para um pai. Para que esta funcao interprete  ³±±
±±³          ³ este caso, a primeira posicao do registro filho indica a   ³±±
±±³          ³ posicao do registro pai, ou seja, leio a primeira posicao  ³±±
±±³          ³ do array pai e procuro todos os registros itens que possuem³±±
±±³          ³ na primeira posicao a posicao lida do registro pai.        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³lRet -> .T.                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cAlias -> Alias do TRB criado atraves da funcao principal.  ³±±
±±³          |aRegPai -> Registro Pai.                                    ³±±
±±³          |aRegFilho -> Registro tipo filho (1:N) Varios para cada Pai.³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GrRegDep (cAlias, aRegPai, aRegFilho)
	Local	lRet	:=	.T.
	Local	aReg	:=	{}
	Local	nCtd	:=	1
	Local	nZ		:=	0
	Local	nCod	:=	0
	Local	nX		:=	0

	For nZ := 1 To Len (aRegPai)
		GrvRegTrb (cAlias, nZ, {aRegPai[nZ]})
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³nCod e a posicao lida do C420(Cabecalho) que se relaciona com o conteudo da posicao 1 do array c425(Itens)³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Len(aRegFilho)>=1 .AND. Len(aRegFilho) >= nCtd
			nCod := aRegFilho[nCtd][1]
			Do While (nCtd<=Len (aRegFilho)) .And. (nCod==aRegFilho[nCtd][1])
				aReg	:=	{}

				For nX := 2 To Len (aRegFilho[nCtd])
					aAdd (aReg, aRegFilho[nCtd][nX])
				Next (nX)

				GrvRegTrb (cAlias, nZ, {aReg}, nCtd)

				nCtd++
			EndDo
		EndIf
	Next (nZ)
Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |GrvIndMov ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³          GRAVACAO DOS INDICADORES DE MOVIMENTO             ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Gravo os indicadores de movimento para todos os registros   ³±±
±±³          ³ a serem gerados.                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³lRet -> .T.                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cAlias -> Alias do TRB criado atraves da funcao principal.  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GrvIndMov (cAlias)
	Local	lRet		:=	.T.
	Local	nQtd0990	:=	0
	Local	nQtdA990	:=	0
	Local	nQtdB990	:=	0
	Local	nQtdC990	:=	0
	Local	nQtdD990	:=	0
	Local	nQtdE990	:=	0
	Local	nQtdH990	:=	0
	Local	nQtdI990	:=	0
	Local	nQtdJ990	:=	0
	Local	nQtdK990	:=	0
	Local	nQtdL990	:=	0
	Local	nQtdZ990	:=	0
	Local	nQtd8990	:=	0
	Local 	nQtd9990	:=	0
	Local	nPos		:=	0
	Local	aReg9900	:=	{}
	//
	DbSelectArea (cAlias)
	(cAlias)->(DbSetOrder (1))
	(cAlias)->(DbGoTop ())
	//
	Do While !(cAlias)->(Eof ())
		
		If (nPos := aScan (aReg9900, {|aX| aX[2]==(cAlias)->TRB_TPREG}))==0
			aAdd (aReg9900, {"9900",(cAlias)->TRB_TPREG,"1"})
		Else
			aReg9900[nPos][3] := Alltrim(STR( Val( aReg9900[nPos][3] )+1))
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³REGISTROS - 0³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (Left ((cAlias)->TRB_TPREG, 1)$"0")
			nQtd0990++
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³REGISTROS - A³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ElseIf (Left ((cAlias)->TRB_TPREG, 1)$"A")
			nQtdA990++
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³REGISTROS - B³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ElseIf (Left ((cAlias)->TRB_TPREG, 1)$"B")
			nQtdB990++
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³REGISTROS - C³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ElseIf (Left ((cAlias)->TRB_TPREG, 1)$"C")
			nQtdC990++
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³REGISTROS - D³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ElseIf (Left ((cAlias)->TRB_TPREG, 1)$"D")
			nQtdD990++
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³REGISTROS - E³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ElseIf (Left ((cAlias)->TRB_TPREG, 1)$"E")
			nQtdE990++
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³REGISTROS - H³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ElseIf (Left ((cAlias)->TRB_TPREG, 1)$"H")
			nQtdH990++
//Retirado blocos I,J,K,L e Z de acordo com Diario Oficial da Uniao - Ato Cotepe 40 de 07 de outubro de 2009			
/*
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³REGISTROS - I³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ElseIf (Left ((cAlias)->TRB_TPREG, 1)$"I")
			nQtdI990++
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³REGISTROS - J³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ElseIf (Left ((cAlias)->TRB_TPREG, 1)$"J")
			nQtdJ990++
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³REGISTROS - K³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ElseIf (Left ((cAlias)->TRB_TPREG, 1)$"K")
			nQtdK990++
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³REGISTROS - L³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ElseIf (Left ((cAlias)->TRB_TPREG, 1)$"L")
			nQtdL990++
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³REGISTROS - Z³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ElseIf (Left ((cAlias)->TRB_TPREG, 1)$"Z")
			nQtdZ990++
*/
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³REGISTROS - 8³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ElseIf (Left ((cAlias)->TRB_TPREG, 1)$"8")
			nQtd8990++
		EndIf
		//
		(cAlias)->(DbSkip ())
	EndDo
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Gravacao do indicador de movimento do bloco 0.   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	BlAbEnc ("A", cAlias, "0001", Iif (nQtd0990>0, "0", "1"),)
	BlAbEnc ("E", cAlias, "0990",, nQtd0990)
	aAdd (aReg9900, {"9900","0001","1"})
	aAdd (aReg9900, {"9900","0990","1"})
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Gravacao do indicador de movimento do bloco A.   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	BlAbEnc ("A", cAlias, "A001", Iif (nQtdA990>0, "0", "1"),)
	BlAbEnc ("E", cAlias, "A990",, nQtdA990)
	aAdd (aReg9900, {"9900","A001","1"})
	aAdd (aReg9900, {"9900","A990","1"})
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Gravacao do indicador de movimento do bloco B.   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	BlAbEnc ("A", cAlias, "B001", Iif (nQtdB990>0, "0", "1"),)
	BlAbEnc ("E", cAlias, "B990",, nQtdB990)
	aAdd (aReg9900, {"9900","B001","1"})
	aAdd (aReg9900, {"9900","B990","1"})
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Gravacao do indicador de movimento do bloco C.   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	BlAbEnc ("A", cAlias, "C001", Iif (nQtdC990>0, "0", "1"),)
	BlAbEnc ("E", cAlias, "C990",, nQtdC990)
	aAdd (aReg9900, {"9900","C001","1"})
	aAdd (aReg9900, {"9900","C990","1"})
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Gravacao do indicador de movimento do bloco D.   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	BlAbEnc ("A", cAlias, "D001", Iif (nQtdD990>0, "0", "1"),)
	BlAbEnc ("E", cAlias, "D990",, nQtdD990)
	aAdd (aReg9900, {"9900","D001","1"})
	aAdd (aReg9900, {"9900","D990","1"})
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Gravacao do indicador de movimento do bloco E.   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	BlAbEnc ("A", cAlias, "E001", Iif (nQtdE990>0, "0", "1"),)
	BlAbEnc ("E", cAlias, "E990",, nQtdE990)
	aAdd (aReg9900, {"9900","E001","1"})
	aAdd (aReg9900, {"9900","E990","1"})
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Gravacao do indicador de movimento do bloco H.   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	BlAbEnc ("A", cAlias, "H001", Iif (nQtdH990>0, "0", "1"),)
	BlAbEnc ("E", cAlias, "H990",, nQtdH990)
	aAdd (aReg9900, {"9900","H001","1"})
	aAdd (aReg9900, {"9900","H990","1"})

	//Retirado blocos I,J,K,L e Z, conforme Diario Oficial da União - Ato Cotepe n 40  de 7 de Outubro de 2009.
	/*
	If .F.
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Gravacao do indicador de movimento do bloco I.   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		BlAbEnc ("A", cAlias, "I001", Iif (nQtdI990>0, "0", "1"),)
		BlAbEnc ("E", cAlias, "I990",, nQtdI990)
		aAdd (aReg9900, {"9900","I001","1"})
		aAdd (aReg9900, {"9900","I990","1"})
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Gravacao do indicador de movimento do bloco J.   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		BlAbEnc ("A", cAlias, "J001", Iif (nQtdJ990>0, "0", "1"),)
		BlAbEnc ("E", cAlias, "J990",, nQtdJ990)
		aAdd (aReg9900, {"9900","J001","1"})
		aAdd (aReg9900, {"9900","J990","1"})
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Gravacao do indicador de movimento do bloco K.   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		BlAbEnc ("A", cAlias, "K001", Iif (nQtdK990>0, "0", "1"),)
		BlAbEnc ("E", cAlias, "K990",, nQtdK990)
		aAdd (aReg9900, {"9900","K001","1"})
		aAdd (aReg9900, {"9900","K990","1"})
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Gravacao do indicador de movimento do bloco L.   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		BlAbEnc ("A", cAlias, "L001", Iif (nQtdL990>0, "0", "1"),)
		BlAbEnc ("E", cAlias, "L990",, nQtdL990)
		aAdd (aReg9900, {"9900","L001","1"})
		aAdd (aReg9900, {"9900","L990","1"})
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Gravacao do indicador de movimento do bloco Z.   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		BlAbEnc ("A", cAlias, "Z001", Iif (nQtdZ990>0, "0", "1"),)
		BlAbEnc ("E", cAlias, "Z990",, nQtdZ990)
		aAdd (aReg9900, {"9900","Z001","1"})
		aAdd (aReg9900, {"9900","Z990","1"})
	EndIf
	*/
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Gravacao do indicador de movimento do bloco 8.   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	BlAbEnc ("A", cAlias, "8001", Iif (nQtd8990>0, "0", "1"),)
	BlAbEnc ("E", cAlias, "8990",, nQtd8990)
	//
	aReg9900	:=	aSort (aReg9900,,,{|x, y| x[2]<y[2]})
	aAdd (aReg9900, {"9900","8001","1"})
	aAdd (aReg9900, {"9900","8990","1"})
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Gravacao do bloco 9 (Totalizacao dos registros)  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Reg9900 (cAlias, aReg9900)
	nQtd9990 := len(aReg9900) + 1
	BlAbEnc ("A", cAlias, "9001", Iif (nQtd9990>0, "0", "1"),)
	BlAbEnc ("E", cAlias, "9990",, nQtd9990)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Gravacao do registro 9999 (Encerramento do arquivo) ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Reg9999 (cAlias)

Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |GetSx1    ³ Autor ³Gustavo G. Rueda       ³ Data ³25.08.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³       RETORNO O CONTEUDO DE UMA DETERMINADA PERGUNTA       ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Gravo os indicadores de movimento para todos os registros   ³±±
±±³          ³ a serem gerados.                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³lRet -> .T.                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cGrupo -> Grupo de perguntas a pesquisar.                   ³±±
±±³          |cGrupo -> ordem da pergunta a pesquisar.                    ³±±
±±³          |lPreSel -> .T. para retornar o conteudo do X1_PRESEL(NUMER) ³±±
±±³          | ou .T. para retornar do X1_CONTEUD.                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GetSx1 (cGrupo, cOrdem, lPreSel)
	Local xRet := Iif (lPreSel, 0, "")
	//
	DbSelectArea ("SX1")
		SX1->(DbSetOrder (1))
	If (SX1->(DbSeek (cGrupo+cOrdem)))
		If lPreSel
			xRet := SX1->X1_PRESEL
		Else
			xRet := SX1->X1_CNT01
		EndIf
	EndIf
Return (xRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |RetCodEst ³ Autor ³ Liber de Esteban      ³ Data ³20.08.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao que retorna o codigo da UF do participante, de acordo³±±
±±³          ³com a tabela disponibilizada pelo IBGE.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³cCod -> Codigo da UF                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cUf  -> Sigla da UF do cliente/fornecedor                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RetCodEst (cUf)
	Local cCod := ""
	//
	Do Case
	Case cUf == "RO" ; cCod := "11" // Rondonia
	Case cUf == "AC" ; cCod := "12" // Acre
	Case cUf == "AM" ; cCod := "13" // Amazonas
	Case cUf == "RR" ; cCod := "14" // Roraima
	Case cUf == "PA" ; cCod := "15" // Para
	Case cUf == "AP" ; cCod := "16" // Amapa
	Case cUf == "TO" ; cCod := "17" // Tocantins
	Case cUf == "MA" ; cCod := "21" // Maranhao
	Case cUf == "PI" ; cCod := "22" // Piaui
	Case cUf == "CE" ; cCod := "23" // Ceara
	Case cUf == "RN" ; cCod := "24" // Rio Gde Norte
	Case cUf == "PB" ; cCod := "25" // Paraiba
	Case cUf == "PE" ; cCod := "26" // Pernambuco
	Case cUf == "AL" ; cCod := "27" // Alagoas
	Case cUf == "SE" ; cCod := "28" // Sergipe
	Case cUf == "BA" ; cCod := "29" // Bahia
	Case cUf == "MG" ; cCod := "31" // Minas Gerais
	Case cUf == "ES" ; cCod := "32" // Espitiro Santo
	Case cUf == "RJ" ; cCod := "33" // Rio de Janeiro
	Case cUf == "SP" ; cCod := "35" // Sao Paulo
	Case cUf == "PR" ; cCod := "41" // Parana
	Case cUf == "SC" ; cCod := "42" // Sta Catarina
	Case cUf == "RS" ; cCod := "43" // Rio Gde Sul
	Case cUf == "MS" ; cCod := "50" // Mato Grosso do Sul
	Case cUf == "MT" ; cCod := "51" // Mato Grosso
	Case cUf == "GO" ; cCod := "52" // GOias
	Case cUf == "DF" ; cCod := "53" // Distrito Federal
	EndCase
	//
Return(cCod)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |RetCodCst ³ Autor ³ Liber de Esteban      ³ Data ³20.08.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao que retorna a origem da mercadoria(importacao direta,³±±
±±³          ³indireta ou de origem nacinal) para preenchimento do codigo ³±±
±±³          ³da situação tributaria, quando esta nao vem preenchida      ³±±
±±³          ³corretamente.                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³cRet -> Codigo da origem da mercadoria                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cProd   -> Codigo do produto                                ³±±
±±³          |cFornec -> Codigo do fornecedor                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RetCodCst (cAliasSFT,cAlsSA, lAchouSF4)
	Local cRet		:= ""
	Local cA1A2		:= SubStr (cAlsSA, 3, 1)
	Local cCmpEst	:= cAlsSA+"->A"+cA1A2+"_EST"

	If Empty((cAliasSFT)->FT_CLASFIS) .Or. Len(Alltrim((cAliasSFT)->FT_CLASFIS))<>3

		If Empty(SB1->B1_ORIGEM)

			If Empty(SB1->B1_IMPORT) .Or. SB1->B1_IMPORT=="N" 
				cRet := "0"
			Else
				If &(cCmpEst)=="EX"
					cRet := "1"
				Else
					cRet := "2"
				EndIf
			EndIf
		Else
			cRet := SB1->B1_ORIGEM
		EndIf
		
		//Situacao Tributaria
		If lAchouSF4
			cRet += SF4->F4_SITTRIB
		Else
			cRet += "90"
		EndIf
	Else
		cRet := (cAliasSFT)->FT_CLASFIS
	EndIf
Return(cRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |ReportDef ³ Autor ³ Gustavo G. Rueda      ³ Data ³20.08.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao de definicao dos objetos do relatorio.               |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³oReport -> Objeto do TReport.                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|aTrbs -> Arquivos de trabalho utilizado na rotina.          ³±±
±±³          |aRegra -> Array contendo as regras para geracao dos registros³±±
±±³          |aStrCmps -> Array contendo a estrutura das celulas          ³±±
±±³          |aTitulos -> Array contendo os labels e pictures das celulas ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef(aTrbs,aRegra,aStrCmps,aTitulo,cFile)
Local	oReport
Local	aReg	:=	{}
Local	nI		:=	0
Local	nY		:=	0
Local	nX		:=	0
Local	nZ		:=	0
Local	nTam	:=	0
Local	nPos1	:=	0
Local	nPosPai	:=	0
Local	nPosReg	:=	0
Local	nPosReg2:=	0
Local	nPosReg3:=	0
Local	nPosPai2:=	0

oReport	:=	TReport():New("COTEPE35",OemToAnsi(STR0975),"", {|oReport| ReportPrint(oReport,aRegra,aTitulo,cFile,aTrbs,aStrCmps)},OemToAnsi(STR0973))	//"Conferência Ato Cotepe 35"###"Este relatório tem o objetivo de possibiliar de forma gráfica a conferência das informações que serão enviadas ao fisco."
oReport:SetLandscape()

For nX := 1 To Len(aTitulo)
	cAlias	:=	"T"+StrZero(nX,2)
	cReg	:=	SubStr(aTitulo[nX][1],1,4)

	dbSelectArea(cAlias)
	If (nPosReg	:=	aScan(aRegra,{|aX| aX[1]==cReg}))>0
		aAdd( aReg, TRSection():New(oReport,OemToAnsi(aTitulo[nX][1]),{cAlias},{STR0976},/*Campos do SX3*/,/*Campos do SIX*/))	//"Por Registro"
		aReg[Len(aReg)]:SetNoFilter({cAlias})
		
		// Para uso futuro - utilizado para imprimir por coluna.
		//
		//aReg[Len(aReg)]:SetLineStyle(.T.)
		//aReg[Len(aReg)]:SetCols(nCols)
		
		nPosPai	:=	Len(aReg)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³PRIMEIRO NIVEL³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nI := 1 To Len(aTitulo[nX][2])
			nPos1	:=	aScan(aStrCmps[nX], {|aX| aX[1]==FieldName(nI)})
	    	nTam	:=	aStrCmps[nX][nPos1][3]	
		    	                                      
	   	If FieldName(nI) == "T01_NOME"
		    	nTam := 30
			Endif	
		    	
	    	TRCell():New(aReg[Len(aReg)],FieldName(nI),cAlias,aTitulo[nX][2][nI][1],aTitulo[nX][2][nI][2],	nTam,/*lPixel*/,&("{|| "+SubStr( FieldName(nI),1,3 )+"->"+FieldName( nI )+"}"))
		Next nI
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³SEGUNDO NIVEL³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Len(aRegra[nPosReg])>1
			For nY := 2 To Len(aRegra[nPosReg])
				cReg	:=	aRegra[nPosReg][nY][1]
				
				If (nPosReg2 := aScan(aTitulo,{|aX| SubStr(aX[1],1,4)==cReg}))>0
					cAlias	:=	"T"+StrZero(nPosReg2,2)
	
					dbSelectArea(cAlias)
					
					aAdd( aReg, TRSection():New(aReg[nPosPai],OemToAnsi(aTitulo[nPosReg2][1]),{cAlias},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/))
					aReg[Len(aReg)]:NLEFTMARGIN := 4
					nPosPai2:=	Len(aReg)
	
					For nI := 1 To Len(aTitulo[nPosReg2][2])
						nPos1	:=	aScan(aStrCmps[nPosReg2], {|aX| aX[1]==FieldName(nI)})
				    	nTam	:=	aStrCmps[nPosReg2][nPos1][3]	

				    	TRCell():New(aReg[Len(aReg)],FieldName(nI),cAlias,aTitulo[nPosReg2][2][nI][1],aTitulo[nPosReg2][2][nI][2],	nTam,/*lPixel*/,&("{|| "+SubStr( FieldName(nI),1,3 )+"->"+FieldName( nI )+"}"))
					Next nI
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³TERCEIRO NIVEL³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If Len(aRegra[nPosReg][nY])>1
						For nZ := 2 To Len(aRegra[nPosReg][nY])
							cReg	:=	aRegra[nPosReg][nY][nZ][1]
							
							If (nPosReg3 := aScan(aTitulo,{|aX| SubStr(aX[1],1,4)==cReg}))>0
								cAlias	:=	"T"+StrZero(nPosReg3,2)
				
								dbSelectArea(cAlias)
								
								aAdd( aReg, TRSection():New(aReg[nPosPai2],OemToAnsi(aTitulo[nPosReg3][1]),{cAlias},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/))
								aReg[Len(aReg)]:NLEFTMARGIN := 8
				
								For nI := 1 To Len(aTitulo[nPosReg3][2])
									nPos1	:=	aScan(aStrCmps[nPosReg3], {|aX| aX[1]==FieldName(nI)})
							    	nTam	:=	aStrCmps[nPosReg3][nPos1][3]	
								    	
							    	TRCell():New(aReg[Len(aReg)],FieldName(nI),cAlias,aTitulo[nPosReg3][2][nI][1],aTitulo[nPosReg3][2][nI][2],	nTam,/*lPixel*/,&("{|| "+SubStr( FieldName(nI),1,3 )+"->"+FieldName( nI )+"}"))
								Next nI
							EndIf        	
						Next nZ
					EndIf
				EndIf
			Next nY
		EndIf
	EndIf
Next nX
Return oReport
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |ReportPrint³ Autor ³ Gustavo G. Rueda      ³ Data ³20.08.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao de processamento e armazenamento dos conteudos a serem|±±
±±³          ³ impressos.                                                 |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³oReport -> Objeto do TReport.                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|oReport -> Objeto do TReport.                               ³±±
±±³          |aRegra -> Array contendo as regras para geracao dos registros³±±
±±³          |aTitulos -> Array contendo os labels e pictures das celulas ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport,aRegra,aTitulo,cFile,aTrbs,aStrCmps)
Local	nX			:=	0
Local	nY			:=	0
Local	nZ			:=	0
Local	nPosReg		:=	0
Local	nPosReg2	:=	0
Local	nPosReg3	:=	0
Local	cAlias		:=	""
Local	cAlias2		:=	""
Local	cReg		:=	""
Local	b2Relation	:=	{||}
Local	b2ParFilter	:=	{||}
Local	b3Relation	:=	{||}
Local	b3ParFilter	:=	{||}

//Alimentacao dos arquivos de trabalho
AlimentTrb(cFile, aTrbs, aRegra, aStrCmps)

oReport:SetMeter(Len(aTitulo))
For nX := 1 To Len(aTitulo)
	If oReport:Cancel()
		Exit
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³PRIMEIRO NIVEL³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAlias := "T"+StrZero(nX,2)
	cReg   := SubStr(aTitulo[nX][1],1,4)

	dbSelectArea(cAlias)
	If (nPosReg := aScan(aRegra,{|aX| aX[1]==cReg}))>0
		If Len(aRegra[nPosReg])>1
			For nY := 2 To Len(aRegra[nPosReg])
				cReg := aRegra[nPosReg][nY][1]
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³SEGUNDO NIVEL³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If (nPosReg2 := aScan(aTitulo,{|aX| SubStr(aX[1],1,4)==cReg}))>0
					cAlias2 := "T"+StrZero(nPosReg2,2)
					dbSelectArea(cAlias2)
					b2Relation  := &("{||"+cAlias+ "->"+cAlias+ "_RELAC}")
					b2ParFilter := &("{||"+cAlias2+"->"+cAlias2+"_RELAC=="+cAlias+"->"+cAlias+"_RELAC}")

					oReport:Section(nPosReg):Section(nY-1):SetRelation(b2Relation,cAlias2,1,.T.)
					oReport:Section(nPosReg):Section(nY-1):SetParentFilter(b2ParFilter)

					If Len(aRegra[nPosReg][nY])>1
						For nZ := 2 To Len(aRegra[nPosReg][nY])
							cReg := aRegra[nPosReg][nY][nZ][1]
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³TERCEIRO NIVEL³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If (nPosReg3 := aScan(aTitulo,{|aX| SubStr(aX[1],1,4)==cReg}))>0
								cAlias3 := "T"+StrZero(nPosReg3,2)
								dbSelectArea(cAlias3)
								b3Relation  := &("{||"+cAlias2+"->"+cAlias2+"_RELAC2}")
								b3ParFilter := &("{||"+cAlias3+"->"+cAlias3+"_RELAC2=="+cAlias2+"->"+cAlias2+"_RELAC2}")

								oReport:Section(nPosReg):Section(nY-1):Section(nZ-1):SetRelation(b3Relation,cAlias3,1,.T.)
								oReport:Section(nPosReg):Section(nY-1):Section(nZ-1):SetParentFilter(b3ParFilter)
							EndIf
						Next nZ
					EndIf
				EndIf
			Next nY
		EndIf
		oReport:Section(nPosReg):Print()
		oReport:IncMeter()
	EndIf
Next nX
Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |LeTxt     ³ Autor ³ Gustavo G. Rueda      ³ Data ³20.08.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao de processamento e armazenamento dos conteudos a serem|±±
±±³          ³ impressos.                                                 |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³aTrbs -> Array contendo os temporarios criados na rotina.   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|aRegra -> Array contendo as regras para geracao dos registros³±±
±±³          |aStrCmps -> Array contendo a estrutura das celulas          ³±±
±±³          |aTitulos -> Array contendo os labels e pictures das celulas ³±±
±±³          |aWizard -> Array contendo as informacoes do assistente.     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function LeTxt(aRegra,aStrCmps,aTitulo,aWizard,nArqVal,cFile)
Local	aTrbs		:=	{}
Local	aStru		:=	{}
Local	cArq		:=	""
Local	nTam		:=	0
Local	cLinha		:=	""
Local	cMaskNum	:=	"@E 999,999,999,999,999,999.99"
Local	cMVRC320	:=	GetNewPar ("MV_RC320", "XXX")
Local	aMVRC320	:=	Iif ("XXX"$cMVRC320 .Or. Len (&(cMVRC320))<>4, {}, &(cMVRC320))	//Campos necessarios para o produto tipo Arma de fogo
Local	cMVRC325	:=	GetNewPar ("MV_RC325", "XXX")
Local	aMVRC325	:=	Iif ("XXX"$cMVRC325 .Or. Len (&(cMVRC325))<>1, {}, &(cMVRC325))	//Campos necessarios para o produto tipo Veiculo Novo
Local	aMVCERTVEI	:=	&(AllTrim (GetNewPar ("MV_CERTVEI", "{}")))
Local	nAlsTrb		:=	1
Local	cAls		:=	""
Local	lContrTare	:=	GetNewPar("MV_TAREDF",.F.)	//Indica se o contribuinte responsavel pela geracao do meio-magnetico eh optante pelo regime especial de Atacadistas - TARE.

cFile := aWizard[1][1]
If File( cFile )
	FT_FUSE(cFile)
	FT_FGOTOP()
	If !FT_FEOF()
		cLinha	:=	FT_FREADLN()
		If !"|0000|"$cLinha
			nArqVal	:= 1
			Return(aTrbs)
		EndIf
	EndIf
	//Regra para geracao do registro 0
	aAdd( aRegra,{"0000"} )													//N1
	aAdd( aRegra,{"0005"} )													//N1
	aAdd( aRegra,{"0010"} )													//N1
	aAdd( aRegra,{"0015"} )		 											//N1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Somente para contribuintes TARE este registro deve ser enviado.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lContrTare
		aAdd( aRegra,{"0020"} )		 										//N1
	EndIf 
	aAdd( aRegra,{"0100"} )													//N1
	aAdd( aRegra,{"0125"} )													//N1
	aAdd( aRegra,{"0150"} )													//N1
	aAdd( aRegra[Len( aRegra )],{"0175"} )									//N2
	aAdd( aRegra,{"0200"} )													//N1
	aAdd( aRegra[Len( aRegra )],{"0210"} )									//N2
	aAdd( aRegra,{"0400"} )													//N1
	aAdd( aRegra,{"0450"} )													//N1
	aAdd( aRegra[Len( aRegra )],{"0455"} )									//N2
	aAdd( aRegra[Len( aRegra )],{"0460"} )									//N2
	aAdd( aRegra[Len( aRegra )],{"0465"} )									//N2

	//Regra para geracao do registro B
	aAdd( aRegra,{"B020"} )													//N1
	aAdd( aRegra[Len( aRegra )],{"B025"} )									//N2
	aAdd( aRegra,{"B410"} )													//N1
	aAdd( aRegra,{"B420"} )													//N1
	aAdd( aRegra,{"B430"} )													//N1
	aAdd( aRegra,{"B440"} )													//N1
	aAdd( aRegra,{"B450"} )													//N1
	aAdd( aRegra,{"B460"} )													//N1
	aAdd( aRegra,{"B470"} )													//N1

	//Regra para geracao do registro C
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Somente para contribuintes TARE este registro deve ser enviado.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lContrTare
		aAdd( aRegra,{"C005"} )												//N1
	EndIf
	aAdd( aRegra,{"C020"} )													//N1
	aAdd( aRegra[Len( aRegra )],{"C030"} )									//N2
	aAdd( aRegra[Len( aRegra )][Len( aRegra[Len( aRegra )] )],{"C035"} )	//N3
	aAdd( aRegra[Len( aRegra )],{"C040"} )									//N2
	aAdd( aRegra[Len( aRegra )],{"C050"} )									//N2
	aAdd( aRegra[Len( aRegra )],{"C060"} )									//N2
	aAdd( aRegra[Len( aRegra )],{"C300"} )									//N2
	aAdd( aRegra[Len( aRegra )][Len( aRegra[Len( aRegra )] )],{"C305"} )	//N3
	aAdd( aRegra[Len( aRegra )][Len( aRegra[Len( aRegra )] )],{"C310"} )	//N3
	aAdd( aRegra[Len( aRegra )][Len( aRegra[Len( aRegra )] )],{"C315"} )	//N3
	aAdd( aRegra[Len( aRegra )][Len( aRegra[Len( aRegra )] )],{"C320"} )	//N3
	aAdd( aRegra[Len( aRegra )][Len( aRegra[Len( aRegra )] )],{"C325"} )	//N3
	aAdd( aRegra[Len( aRegra )],{"C500"} )									//N2
	aAdd( aRegra,{"C550"} )													//N1
	aAdd( aRegra[Len( aRegra )],{"C555"} )									//N2
	aAdd( aRegra,{"C570"} )													//N1
	aAdd( aRegra[Len( aRegra )],{"C575"} )									//N2
	aAdd( aRegra,{"C580"} )													//N1
	aAdd( aRegra,{"C600"} )													//N1
	aAdd( aRegra[Len( aRegra )],{"C605"} )	 								//N2
	aAdd( aRegra,{"C620"} )													//N1
	aAdd( aRegra[Len( aRegra )],{"C625"} )	 								//N2
	aAdd( aRegra,{"C640"} )													//N1
	aAdd( aRegra,{"C700"} )													//N1
	aAdd( aRegra[Len( aRegra )],{"C705"} )	 								//N2
	aAdd( aRegra[Len( aRegra )],{"C750"} )									//N2
	aAdd( aRegra[Len( aRegra )],{"C760"} )	 								//N2
	aAdd( aRegra,{"C770"} )					 								//N1
	aAdd( aRegra[Len( aRegra )],{"C775"} )	  								//N2

	//Regra para geracao do registro D
	aAdd( aRegra,{"D020"} )					   								//N1
	aAdd( aRegra[Len( aRegra )],{"D030"} )	   								//N2
	aAdd( aRegra[Len( aRegra )],{"D040"} )	   								//N2
	aAdd( aRegra[Len( aRegra )],{"D050"} )	  								//N2
	aAdd( aRegra[Len( aRegra )],{"D180"} )	  								//N2
	aAdd( aRegra,{"D400"} )													//N1
	aAdd( aRegra[Len( aRegra )],{"D405"} )									//N2
	aAdd( aRegra[Len( aRegra )],{"D450"} )									//N2
	aAdd( aRegra[Len( aRegra )],{"D460"} )	  								//N2
	aAdd( aRegra,{"D470"} )					 								//N1
	aAdd( aRegra[Len( aRegra )],{"D475"} )	 								//N2
	aAdd( aRegra[Len( aRegra )],{"D480"} )	 								//N2

	//Regra para geracao do registro E
	aAdd( aRegra,{"E020"} )					 								//N1
	aAdd( aRegra[Len( aRegra )],{"E025"} )	   								//N2
	aAdd( aRegra,{"E050"} )				   									//N1
	aAdd( aRegra[Len( aRegra )],{"E055"} )									//N2
	aAdd( aRegra,{"E100"} )													//N1
	aAdd( aRegra[Len( aRegra )],{"E105"} )									//N2
	aAdd( aRegra,{"E120"} )													//N1
	aAdd( aRegra,{"E300"} )													//N1
	aAdd( aRegra[Len( aRegra )],{"E310"} )									//N2
	aAdd( aRegra[Len( aRegra )],{"E320"} )									//N2
	aAdd( aRegra[Len( aRegra )],{"E330"} )									//N2
	aAdd( aRegra[Len( aRegra )],{"E340"} )									//N2
	aAdd( aRegra[Len( aRegra )],{"E360"} )									//N2
	aAdd( aRegra[Len( aRegra )][Len( aRegra[Len( aRegra )] )],{"E365"} )	//N3
	aAdd( aRegra,{"E500"} )					 								//N1
	aAdd( aRegra[Len( aRegra )],{"E510"} )									//N2
	aAdd( aRegra[Len( aRegra )],{"E520"} )									//N2
	aAdd( aRegra[Len( aRegra )],{"E530"} )	 								//N2

	//Regra para geracao do registro H
	aAdd( aRegra,{"H020"} )					 								//N1
	aAdd( aRegra[Len( aRegra )],{"H025"} )									//N2

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do registro 0000³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_LFPD",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_CODVER",	"C",	003,	0 } )
	aAdd( aStru,{ cAls+"_CODSRP",	"C",	003,	0 } )
	aAdd( aStru,{ cAls+"_CODFIN",	"C",	002,	0 } )
	aAdd( aStru,{ cAls+"_DTINI",	"D",	008,	0 } )
	aAdd( aStru,{ cAls+"_DTFIM",	"D",	008,	0 } )
	aAdd( aStru,{ cAls+"_INED",		"C",	001,	0 } )
	aAdd( aStru,{ cAls+"_INDCEN",	"C",	001,	0 } )
	aAdd( aStru,{ cAls+"_NOME",		"C",	050,	0 } )
	aAdd( aStru,{ cAls+"_CNPJ",		"C",	018,	0 } )
	aAdd( aStru,{ cAls+"_CPF",		"C",	014,	0 } )
	aAdd( aStru,{ cAls+"_NIT",		"C",	011,	0 } )
	aAdd( aStru,{ cAls+"_UF",		"C",	002,	0 } )
	aAdd( aStru,{ cAls+"_IE",		"C",	015,	0 } )
	aAdd( aStru,{ cAls+"_CODMUN",	"C",	007,	0 } )
	aAdd( aStru,{ cAls+"_IM",		"C",	015,	0 } )
	aAdd( aStru,{ cAls+"_SUFRA",	"C",	009,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_REG")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"0000" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)], OemToAnsi(STR0867))	//"0000 - Abertura do Arquivo Digital e Identificação do contribuinte"
	aAdd( aTitulo[Len(aTitulo)], {})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0062,"@!" })						//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0063,"@!" })						//"LFPD"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0064,"@!" })  						//"Versão Layout"	
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0065,"@!" })  						//"Versão layout Prev"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0066,"@!" })  						//"Finalidade Arquivo"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0067,"@!" }) 						//"Data inicial"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0068,"@!" }) 						//"Data final"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0069,"@!" })  						//"Tipo entrada"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0070,"@!" })  						//"Indic. Centralização"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0071,"@!" })						//"Nome Empresarial"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0072,"@R 99.999.999/9999-99" })	//"CNPJ"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0073,"@R 999.999.999-99" })   		//"CPF"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0074,"@!" })						//"NIT"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0075,"@!" }) 						//"UF"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0076,"@!" })						//"IE"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0077,"@!" })						//"Código Município"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0078,"@!" })						//"IM"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0079,"@!" })  						//"Inscrição SUFRAMA"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do registro 0005 - DADOS COMPLEMENTARES DO CONTRIBUINTE³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_FANTAS",	"C",	040,	0 } )
	aAdd( aStru,{ cAls+"_CEP",		"C",	008,	0 } )
	aAdd( aStru,{ cAls+"_END",		"C",	050,	0 } )
	aAdd( aStru,{ cAls+"_NUM",		"C",	010,	0 } )
	aAdd( aStru,{ cAls+"_COMPL",	"C",	020,	0 } )
	aAdd( aStru,{ cAls+"_BAIRR",	"C",	020,	0 } )
	aAdd( aStru,{ cAls+"_CEPCP",	"C",	008,	0 } )
	aAdd( aStru,{ cAls+"_CP",		"C",	010,	0 } )
	aAdd( aStru,{ cAls+"_FONE",		"C",	015,	0 } )
	aAdd( aStru,{ cAls+"_FAX", 		"C",	015,	0 } )
	aAdd( aStru,{ cAls+"_EMAIL",	"C",	050,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_REG")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"0005" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0868))	//"0005 - Dados Complementares do Contribuinte"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0062,"@!" })						//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0081,"@!" })						//"Nome Fantasia"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0082,"@!" })						//"CEP"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0083,"@!" })						//"Endereço"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0084,"@!" })						//"Número"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0085,"@!" })						//"Complemento"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0086,"@!" })						//"Bairro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0087,"@!" })						//"CEP CX Postal"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0088,"@!" })						//"CX Postal"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0089,"@!" })						//"Fone"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0090,"@!" })						//"FAX"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0091,"@!" })						//"E-Mail"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do registro 0010 - ESCRITURACAO CENTRALIZADA ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_CNPJ",		"C",	018,	0 } )
	aAdd( aStru,{ cAls+"_CPF",		"C",	014,	0 } )
	aAdd( aStru,{ cAls+"_UF",		"C",	002,	0 } )
	aAdd( aStru,{ cAls+"_IE",		"C",	015,	0 } )
	aAdd( aStru,{ cAls+"_CODMUN",	"C",	007,	0 } )
	aAdd( aStru,{ cAls+"_IM",		"C",	015,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_REG")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"0010" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0869))	//"0010 - Escrituração Centralizada"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0062,"@!" })  						//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0093,"@R 99.999.999/9999-99" })	//"CNPJ"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0094,"@R 999.999.999-99" })  		//"CPF"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0095,"@!" })						//"UF"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0096,"@!" })						//"IE"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0097,"@!" })						//"Código Município"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0098,"@!" })						//"IM"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do registro 0015 - DADOS DO CONTRIBUINTE SUBSTITUTO ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_UF_ST",	"C",	002,	0 } )
	aAdd( aStru,{ cAls+"_IE_ST",	"C",	015,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_REG")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"0015" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0870))	//"0015 - Dados do Contribuinte Substituto"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0099,"@!" })						//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0100,"@!" }) 						//"UF Contr Substituído"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0101,"@!" })						//"IE Contr Substituído"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Somente para contribuintes TARE este registro deve ser enviado.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lContrTare
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Montagem do registro 0020 - BENEFICIOS FISCAIS ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cAls	:=	"T"+StrZero(nAlsTrb++,2)
		aStru	:=	{}
		aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
		aAdd( aStru,{ cAls+"_CODICM",	"C",	005,	0 } )
		aAdd( aStru,{ cAls+"_CODISS",	"C",	005,	0 } )
		aAdd( aStrCmps,aStru )

		cArq	:=	CriaTrab(aStru)
		dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
		IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_REG")
		aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"0020" } )

		aAdd( aTitulo, {})
		aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0984))	//"0020 - Beneficio Fiscal"
		aAdd( aTitulo[Len(aTitulo)],{})
		aAdd( aTitulo[Len(aTitulo)][2],{ STR0099,"@!" })						//"Registro"
		aAdd( aTitulo[Len(aTitulo)][2],{ STR0985,"@!" }) 						//"Cod. Benef fiscal do ICMS"
		aAdd( aTitulo[Len(aTitulo)][2],{ STR0986,"@!" })						//"Cod. Benef fiscal do ISS"
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do registro 0100 - DADOS DO CONTABILISTA ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_NOME",		"C",	050,	0 } )
	aAdd( aStru,{ cAls+"_CNPJ",		"C",	018,	0 } )
	aAdd( aStru,{ cAls+"_CPF",		"C",	014,	0 } )
	aAdd( aStru,{ cAls+"_CRC",		"C",	011,	0 } )
	aAdd( aStru,{ cAls+"_UF",		"C",	002,	0 } )
	aAdd( aStru,{ cAls+"_CEP",		"C",	008,	0 } )
	aAdd( aStru,{ cAls+"_END",		"C",	050,	0 } )
	aAdd( aStru,{ cAls+"_NUM",		"C",	010,	0 } )
	aAdd( aStru,{ cAls+"_COMPL",	"C",	020,	0 } )
	aAdd( aStru,{ cAls+"_BAIRR",	"C",	020,	0 } )
	aAdd( aStru,{ cAls+"_CEPCP",	"C",	008,	0 } )
	aAdd( aStru,{ cAls+"_CP",		"C",	010,	0 } )
	aAdd( aStru,{ cAls+"_FONE",		"C",	015,	0 } )
	aAdd( aStru,{ cAls+"_FAX", 		"C",	015,	0 } )
	aAdd( aStru,{ cAls+"_EMAIL",	"C",	050,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_REG")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"0100" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0871))	//"0100 - Dados do Contabilista"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0102,"@!" })  						//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0103,"@!" }) 						//"Nome"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0104,"@R 99.999.999/9999-99" })	//"CNPJ"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0105,"@R 999.999.999-99" })		//"CPF"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0106,"@!" })						//"CRC"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0107,"@!" })						//"UF"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0108,"@!" })  						//"CEP"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0109,"@!" })						//"Endereço"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0110,"@!" })						//"Número"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0111,"@!" })  						//"Complemento"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0112,"@!" })  						//"Bairro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0113,"@!" })  						//"CEP CX Postal"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0114,"@!" })						//"CX Postal"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0115,"@!" })						//"Fone"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0116,"@!" })						//"FAX"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0117,"@!" })  						//"E-Mail"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do registro 0125 - DADOS DO TECNICO/EMPRESA ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_NOME",		"C",	050,	0 } )
	aAdd( aStru,{ cAls+"_CNPJ",		"C",	018,	0 } )
	aAdd( aStru,{ cAls+"_CPF",		"C",	014,	0 } )
	aAdd( aStru,{ cAls+"_FONE",		"C",	015,	0 } )
	aAdd( aStru,{ cAls+"_FAX",		"C",	015,	0 } )
	aAdd( aStru,{ cAls+"_EMAIL",	"C",	050,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_REG")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"0125" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0872))	//"0125 - Dados do Técnico/Empresa"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0118,"@!" })						//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0119,"@!" }) 						//"Nome"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0120,"@R 99.999.999/9999-99" })	//"CNPJ"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0121,"@R 999.999.999-99" })		//"CPF"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0122,"@!" })						//"Fone"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0123,"@!" })  						//"FAX"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0124,"@!" }) 						//"E-Mail"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do registro 0150 - CADASTRO DE PARTICIPANTE ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_COD",		"C",	013,	0 } )
	nTam	:=	TamSx3("A1_NOME")[1]
	aAdd( aStru,{ cAls+"_NOME",		"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_CODPAI",	"C",	005,	0 } )
	aAdd( aStru,{ cAls+"_CNPJ",		"C",	018,	0 } )
	aAdd( aStru,{ cAls+"_CPF",		"C",	014,	0 } )
	aAdd( aStru,{ cAls+"_CEI",		"C",	012,	0 } )
	aAdd( aStru,{ cAls+"_NIT",		"C",	011,	0 } )
	aAdd( aStru,{ cAls+"_UF",		"C",	002,	0 } )
	aAdd( aStru,{ cAls+"_IE",		"C",	015,	0 } )
	aAdd( aStru,{ cAls+"_IE_ST",	"C",	015,	0 } )
	aAdd( aStru,{ cAls+"_CODMUN",	"C",	007,	0 } )
	aAdd( aStru,{ cAls+"_IM",		"C",	015,	0 } )
	aAdd( aStru,{ cAls+"_SUFRA",	"C",	009,	0 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"0150" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0873))	//"0150 - Cadastro de Participante"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0125,"@!" })  						//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0126,"@!" })						//"Codigo"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0127,"@!" }) 						//"Nome"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0128,"@!" }) 						//"Cod. Pais"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0129,"@R 99.999.999/9999-99" })	//"CNPJ"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0130,"@R 999.999.999-99" })		//"CPF"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0131,"@!" })  						//"CEI"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0132,"@!" })  						//"NIT"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0133,"@!" })						//"UF"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0134,"@!" })  						//"IE"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0135,"@!" }) 						//"IE ST"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0136,"@!" }) 						//"Código Município"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0137,"@!" }) 						//"IM"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0138,"@!" })  						//"Inscrição SUFRAMA"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do registro 0175 - ENDERECO DO PARTICIPANTE ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",	"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_CEP",	"C",	008,	0 } )
	nTam	:=	TamSx3("A1_END")[1]
	aAdd( aStru,{ cAls+"_END",	"C",	050,	0 } )
	aAdd( aStru,{ cAls+"_NUM",	"C",	010,	0 } )
	aAdd( aStru,{ cAls+"_COMPL",	"C",	020,	0 } )
	aAdd( aStru,{ cAls+"_BAIRR",	"C",	020,	0 } )
	aAdd( aStru,{ cAls+"_CEPCP",	"C",	008,	0 } )
	aAdd( aStru,{ cAls+"_CP",		"C",	010,	0 } )
	aAdd( aStru,{ cAls+"_FONE",	"C",	015,	0 } )
	aAdd( aStru,{ cAls+"_FAX",	"C",	015,	0 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"0175" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0874))	//"0175 - Endereço do Participante"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0139,"@!" })	//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0140,"@!" })	//"CEP"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0141,"@!" })	//"Endereço"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0142,"@!" })	//"Número"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0143,"@!" })	//"Complemento"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0144,"@!" })	//"Bairro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0145,"@!" })	//"CEP CX Postal"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0146,"@!" })	//"CX Postal"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0147,"@!" })	//"Fone"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0148,"@!" })	//"FAX"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do registro 0200 - IDENTIFICACAO DO ITEM    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",	"C",	004,	0 } )
	nTam	:=	TamSx3("B1_COD")[1]
	aAdd( aStru,{ cAls+"_COD",	"C",	nTam,	0 } )
	nTam	:=	TamSx3("B1_DESC")[1]
	aAdd( aStru,{ cAls+"_DESC",	"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_CODGEN",	"C",	002,	0 } )
	aAdd( aStru,{ cAls+"_CODLST",	"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"0200" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0875))	//"0200 - Identificação do Item"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0149,"@!" })  				//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0150,"@!" })				//"Código Item"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0151,"@!" })				//"Descrição"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0152,"@!" })				//"Código Genêro Item"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0153,"@!" })  				//"Código Serviço"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do registro 0210 - COMPONENTE ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",	"C",	004,	0 } )
	nTam	:=	TamSx3("B1_UM")[1]
	aAdd( aStru,{ cAls+"_UNIT",	"C",	nTam,	0 } )
	nTam	:=	TamSx3("B1_COD")[1]
	aAdd( aStru,{ cAls+"_COD",	"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_QTD",	"N",	015,	3 } )
	nTam	:=	TamSx3("B1_UM")[1]
	aAdd( aStru,{ cAls+"_UNCOMP",	"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_PERDAC",	"N",	006,	2 } )
	aAdd( aStru,{ cAls+"_DTINI",	"D",	008,	0 } )
	aAdd( aStru,{ cAls+"_DTFIM",	"D",	008,	0 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"0210" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0876))	//"0210 - Mercadoria Componente/Relação Insumo/Produto"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0154,"@!" })			//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0155,"@!" })  			//"Un Produto"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0156, cMaskNum+"9" })	//"Qtd"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0157,"@!" })			//"Un Componente"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0158,"@E 999.99" })	//"Perda"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0159,"@!" })			//"Data Início"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0160,"@!" })  			//"Data Final"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do registro 0400 - NATUREZA DE OPERACAO/PRESTACAO ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",	"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_COD",	"C",	005,	0 } )
	aAdd( aStru,{ cAls+"_DESC",	"C",	200,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_REG")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"0400" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0877))	//"0400 - Natureza da Operação/Prestação"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0161,"@!" })	//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0162,"@!" })	//"Código"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0163,"" }) 	//"Descrição"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do registro 0450 - INFORMACAO COMPLEMENTAR/OBSERVACAO ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",	"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_COD",	"C",	020,	0 } )
	aAdd( aStru,{ cAls+"_TXT",	"C",	050,	0 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"0450" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0878))	//"0450 - Informação Complementar/Observação"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0164,"@!" })	//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0165,"@!" })	//"Código"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0166,"" })		//"Texto"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do registro 0455 - NORMA REFERENCIADA³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",	"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_NORMA",	"C",	050,	0 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"0455" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0879))	//"0455 - Norma Referenciada"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0714,"@!" })				//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0866,"@!" })				//"Norma"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do registro 0460 - DOCUMENTO ARRECADACAO REFERENCIADO³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",	"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_CODDA",	"C",	002,	0 } )
	nTam	:=	TamSx3("F6_NUMERO")[1]
	aAdd( aStru,{ cAls+"_NUMDA",	"C",	nTam,	0 } )
	nTam	:=	TamSx3("F6_VALOR")[1]
	aAdd( aStru,{ cAls+"_VLRDA",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_DTINI",	"D",	008,	0 } )
	aAdd( aStru,{ cAls+"_DTFIM",	"D",	008,	0 } )
	aAdd( aStru,{ cAls+"_VECTO",	"D",	008,	0 } )
	aAdd( aStru,{ cAls+"_PAGTO",	"D",	008,	0 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"0460" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0880))	//"0460 - Documento Arrecadação Referenciado"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0167,"@!" })  		//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0168,"@!" }) 		//"Código"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0169,"@!" })		//"Número"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0170,cMaskNum })	//"Valor"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0171,"" })			//"Data Inicial Período"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0172,"" })			//"Data Final Período"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0173,"" })			//"Data Vencimento"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0174,"" })	   		//"Data Pagamento"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do registro 0465 - DOCUMENTO FISCAL REFERENCIADO³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_INDOP",	"C",	001,	0 } )
	aAdd( aStru,{ cAls+"_INDEM",	"C",	001,	0 } )
	aAdd( aStru,{ cAls+"_CNPJ",		"C",	018,	0 } )
	aAdd( aStru,{ cAls+"_CPF",		"C",	014,	0 } )
	aAdd( aStru,{ cAls+"_UF",		"C",	002,	0 } )
	aAdd( aStru,{ cAls+"_IE",		"C",	015,	0 } )
	aAdd( aStru,{ cAls+"_CODMUN",	"C",	007,	0 } )
	aAdd( aStru,{ cAls+"_IM",		"C",	015,	0 } )
	aAdd( aStru,{ cAls+"_CODMOD",	"C",	002,	0 } )
	aAdd( aStru,{ cAls+"_CODSIT",	"C",	001,	0 } )
	aAdd( aStru,{ cAls+"_SER",		"C",	003,	0 } )
	aAdd( aStru,{ cAls+"_SUBSER",	"C",	002,	0 } )
	nTam	:=	TamSx3("F3_NFISCAL")[1]
	aAdd( aStru,{ cAls+"_NUMDOC",	"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_DTDOC",	"D",	010,	0 } )
	aAdd( aStru,{ cAls+"_VLDOC",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLISS",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRT",		"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLICM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLST",		"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLIPI",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	008,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"0465" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0881))	//"0465 - Documento Fiscal Referenciado"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0175,"@!" }) 						//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0176,"@!" }) 						//"Ind Op"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0177,"@!" }) 						//"Ind Emit"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0178,"@R 99.999.999/9999-99" })	//"CNPJ"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0179,"@R 999.999.999-99" })		//"CPF"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0180,"@!" })						//"UF"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0181,"@!" })  						//"IE"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0182,"@!" }) 						//"Código Município"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0183,"@!" })						//"IM"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0184,"@!" }) 						//"Modêlo"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0185,"@!" })						//"Situação"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0186,"@!" })  						//"Série"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0187,"@!" }) 						//"Sub"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0188,"@!" })						//"Número"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0189,"" })	  						//"Data"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0190,cMaskNum })	                //"Valor"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0191,cMaskNum })					//"Valor do ISS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0192,cMaskNum })					//"Valor do ISS Ret"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0193,cMaskNum })					//"Valor do ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0194,cMaskNum })					//"Valor do ICMS ST"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0195,cMaskNum })					//"Valor do IPI"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do registro B020 - NOTA FISCAL DE SERVICO³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",	"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_INDOP",	"C",	001,	0 } )
	aAdd( aStru,{ cAls+"_INDEM",	"C",	001,	0 } )
	aAdd( aStru,{ cAls+"_CODPAR",	"C",	013,	0 } )
	aAdd( aStru,{ cAls+"_CODMOD",	"C",	002,	0 } )
	aAdd( aStru,{ cAls+"_CODSIT",	"C",	002,	0 } )
	aAdd( aStru,{ cAls+"_SER",	"C",	003,	0 } )
	aAdd( aStru,{ cAls+"_SUBSER",	"C",	002,	0 } )
	nTam	:=	TamSx3("F3_NFISCAL")[1]
	aAdd( aStru,{ cAls+"_NUMDOC",	"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_DTDOC",	"D",	010,	0 } )
	aAdd( aStru,{ cAls+"_CFPS",	"C",	004,	0 } )
	nTam	:=	TamSx3("F3_LANCAM")[1]
	aAdd( aStru,{ cAls+"_LACTO",	"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_MUNSER",	"C",	007,	0 } )
	aAdd( aStru,{ cAls+"_VLCONT",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLMAT",	"N",	015,	3 } )
	aAdd( aStru,{ cAls+"_VLSUB",	"N",	016,	4 } )
	aAdd( aStru,{ cAls+"_ISSISE",	"N",	017,	5 } )
	aAdd( aStru,{ cAls+"_DEDBC",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_BCISS",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_BRISS",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRT",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLISS",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_CODOBS",	"C",	018,	0 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"B020" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0882))	//"B020 - Nota Fiscal de Serviço"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0196,"@!" })							//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0197,"@!" })							//"Ind Op"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0198,"@!" })							//"Ind Emit"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0199,"@!" })							//"Cód Participante"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0200,"@!" })							//"Modêlo"				
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0201,"@!" }) 							//"Situação"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0202,"@!" })							//"Serie"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0203,"@!" })							//"Sub"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0204,"@!" })							//"Número"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0205,"" })								//"Data"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0206,"@!" })							//"CFPS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0207,"@!" })							//"Lançamento"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0208,"@!" })							//"Cód Mun Prest"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0209,cMaskNum })						//"Valor Contábil"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0210,cMaskNum+"9" })					//"Valor Material"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0211,cMaskNum+"99" })					//"Valor Subempreitada"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0212,cMaskNum+"999" })					//"Valor Isento"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0213,cMaskNum })						//"Valor Deduções"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0214,cMaskNum })						//"Valor Base Calc"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0215,cMaskNum })						//"Valor Base RT"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0216,cMaskNum })   					//"Valor do ISS RT"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0217,cMaskNum })						//"Valor do ISS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0218,"@!" })							//"Código Inf Obs"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do registro B025 - VALORES PARCIAIS DO LANCAMEN0TO³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",	"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_VLCONT",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_BCISS",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_ALQISS",	"N",	006,	2 } )
	aAdd( aStru,{ cAls+"_VLISS",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_ISSISE",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"B025" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0883))	//"B025 - Valores Parciais do Lançamento"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0219,"@!" })				//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0220,cMaskNum })			//"Vlr Contábil"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0221,cMaskNum })			//"Vlr Base Calc"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0222,"@E 999.99" })		//"Aliq ISS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0223,cMaskNum })			//"Valor do ISS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0224,cMaskNum })			//"Valor Isento"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do registro B410 - TOTALIZACAO DOS VALORES DE AQUISICOES/PRESTACOES³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_INDTOT",	"C",	001,	0 } )
	aAdd( aStru,{ cAls+"_VLCONT",	"N",	016,	2 } )
	aAdd( aStru,{ cAls+"_BCISS",	"N",	016,	2 } )
	aAdd( aStru,{ cAls+"_DEDISS",	"N",	016,	2 } )
	aAdd( aStru,{ cAls+"_VLRT",		"N",	016,	2 } )
	aAdd( aStru,{ cAls+"_ISSISE",	"N",	016,	2 } )
	aAdd( aStru,{ cAls+"_VLISS",	"N",	016,	2 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_REG")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"B410" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0884))	//"B410 - Totalização dos Valores de Aquisições/Prestações"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0225,"@!" })					//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0226,"@!" })					//"Ind Tot"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0209,cMaskNum })				//"Valor Contábil"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0228,cMaskNum })				//"Valor Base Calc"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0229,cMaskNum })				//"Valor Deduções"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0230,cMaskNum })				//"Valor do ISS RT"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0231,cMaskNum })				//"Valor Isento"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0232,cMaskNum })				//"Valor do ISS"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do registro B420 - VALORES POR ALIQUOTA³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_VLCONT",	"N",	016,	2 } )
	aAdd( aStru,{ cAls+"_BCISS",	"N",	016,	2 } )
	aAdd( aStru,{ cAls+"_ALQISS",	"N",	005,	2 } )
	aAdd( aStru,{ cAls+"_BRISS",	"N",	016,	2 } )
	aAdd( aStru,{ cAls+"_VLRT",		"N",	016,	2 } )
	aAdd( aStru,{ cAls+"_ISSISE",	"N",	016,	2 } )
	aAdd( aStru,{ cAls+"_VLISS",	"N",	016,	2 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_REG")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"B420" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0885))	//"B420 - Valores por Alíquota"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0233,"@!" })				    //"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0209,cMaskNum })				//"Valor Contábil"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0235,cMaskNum })				//"Valor Base Calc"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0236,"@E 999.99" }) 			//"Aliq ISS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0237,cMaskNum })				//"Valor Base RT"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0238,cMaskNum })				//"Valor do ISS RT"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0239,cMaskNum })				//"Valor Isento"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0240,cMaskNum })				//"Valor do ISS"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do registro B430 - VALORES POR CFPS    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG", 		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_CFPS",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_VLCONT",	"N",	016,	2 } )
	aAdd( aStru,{ cAls+"_BCISS",	"N",	016,	2 } )
	aAdd( aStru,{ cAls+"_VLMAT",	"N",	016,	2 } )
	aAdd( aStru,{ cAls+"_VLSUB",	"N",	016,	2 } )
	aAdd( aStru,{ cAls+"_ISSISE",	"N",	016,	2 } )
	aAdd( aStru,{ cAls+"_DEDBC",	"N",	016,	2 } )
	aAdd( aStru,{ cAls+"_BRISS",	"N",	016,	2 } )
	aAdd( aStru,{ cAls+"_VLRT",		"N",	016,	2 } )
	aAdd( aStru,{ cAls+"_VLISS",	"N",	016,	2 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_REG")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"B430" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0886))	//"B430 - Valores por CFPS"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0241,"@!" })	                    //"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0242,"@!" })						//"CFPS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0209,cMaskNum })  					//"Valor Contábil"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0244,cMaskNum })					//"Valor Base Calc"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0245,cMaskNum })					//"Valor Material"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0246,cMaskNum })					//"Valor Subempreitada"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0247,cMaskNum })  					//"Valor Isento"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0248,cMaskNum })					//"Valor das Deduções"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0249,cMaskNum })					//"Valor da Base RT"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0250,cMaskNum })					//"Valor do ISS RT"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0251,cMaskNum }) 					//"Valor do ISS"'
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do registro B440 - VALORES RETIDOS     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_INDOP",	"C",	001,	0 } )
	aAdd( aStru,{ cAls+"_CODPAR",	"C",	013,	0 } )
	aAdd( aStru,{ cAls+"_VLCONT",	"N",	016,	2 } )
	aAdd( aStru,{ cAls+"_BRISS",	"N",	016,	2 } )
	aAdd( aStru,{ cAls+"_ALQISS",	"N",	005,	2 } )
	aAdd( aStru,{ cAls+"_VLRT",		"N",	016,	2 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_REG")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"B440" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0887))	//"B440 - Valores Retidos"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0252,"@!" })			        //"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0253,"@!" })					//"Ind Op"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0254,"@!" })					//"Cód Participante"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0209,cMaskNum })				//"Valor Contábil"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0256,cMaskNum })				//"Valor Base RT"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0257,"@E 999.99" })			//"Aliq ISS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0258,cMaskNum })				//"Valor do ISS RT"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do registro B450 - VALORES POR MUNICIPIO³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_INDOP",	"C",	001,	0 } )
	aAdd( aStru,{ cAls+"_CODMUN",	"C",	007,	0 } )
	aAdd( aStru,{ cAls+"_VLCONT",	"N",	016,	2 } )
	aAdd( aStru,{ cAls+"_BCISS",	"N",	016,	2 } )
	aAdd( aStru,{ cAls+"_ISSISE",	"N",	016,	2 } )
	aAdd( aStru,{ cAls+"_DEDBC",	"N",	016,	2 } )
	aAdd( aStru,{ cAls+"_VLRT",		"N",	016,	2 } )
	aAdd( aStru,{ cAls+"_VLISS",	"N",	016,	2 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_REG")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"B450" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0888))	//"B450 - Valores por Município"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0259,"@!" })	                //"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0260,"@!" })					//"Ind Op"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0261,"@!" })					//"Cód Município"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0209,cMaskNum })				//"Valor Contábil"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0263,cMaskNum })				//"Valor Base Calc"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0264,cMaskNum })				//"Valor Isento"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0265,cMaskNum })				//"Valor Deduções"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0266,cMaskNum })				//"Valor do ISS RT"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0267,cMaskNum })				//"Valor do ISS"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do registro B460 - DEDUCOES³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",	"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_INDDED",	"C",	001,	0 } )
	aAdd( aStru,{ cAls+"_VLDED",	"N",	016,	2 } )
	aAdd( aStru,{ cAls+"_NUMPRO",	"C",	020,	0 } )
	aAdd( aStru,{ cAls+"_INDPRO",	"C",	001,	0 } )
	aAdd( aStru,{ cAls+"_DESPRO",	"C",	050,	0 } )
	aAdd( aStru,{ cAls+"_CODOBS",	"C",	020,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_REG")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"B460" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0889))	//"B460 - Dedução do ISSQN"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0268,"@!" })						//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0269,"@!" })						//"Ind Ded"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0270,cMaskNum })					//"Valor Dedução"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0271,"@!" })						//"Nr Processo"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0272,"@!" })						//"Ind Orig"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0273,"@!" })						//"Descrição do Processo"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0274,"@!" })						//"Código Inf Obs"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do registro B470 - SALDOS ISS A RECOLHER³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_VLCONT",	"N",	016,	2 } )
	aAdd( aStru,{ cAls+"_VLMAT",	"N",	016,	2 } )
	aAdd( aStru,{ cAls+"_VLMATP",	"N",	016,	2 } )
	aAdd( aStru,{ cAls+"_VLSUB",	"N",	016,	2 } )
	aAdd( aStru,{ cAls+"_ISSISE",	"N",	016,	2 } )
	aAdd( aStru,{ cAls+"_DEDBC",	"N",	016,	2 } )
	aAdd( aStru,{ cAls+"_BCISS",	"N",	016,	2 } )
	aAdd( aStru,{ cAls+"_BRISS",	"N",	016,	2 } )
	aAdd( aStru,{ cAls+"_VLISS",	"N",	016,	2 } )
	aAdd( aStru,{ cAls+"_VLRT",		"N",	016,	2 } )
	aAdd( aStru,{ cAls+"_DED",		"N",	016,	2 } )
	aAdd( aStru,{ cAls+"_ISSREC",	"N",	016,	2 } )
	aAdd( aStru,{ cAls+"_ISSST",	"N",	016,	2 } )
	aAdd( aStru,{ cAls+"_ISSFIL",	"N",	016,	2 } )
	aAdd( aStru,{ cAls+"_ISSRTR",	"N",	016,	2 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_REG")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"B470" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0890))	//"B470 - Saldos do ISSQN a Recolher"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0275,"@!" })							//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0209,cMaskNum })			   			//"Valor Contábil"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0277,cMaskNum })						//"Valor Material"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0278,cMaskNum })						//"Valor Mat Próp"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0279,cMaskNum })						//"Valor Subempreitada"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0280,cMaskNum })						//"Valor Isento"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0281,cMaskNum })						//"Valor Deduções"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0282,cMaskNum })						//"Valor Base Calc"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0283,cMaskNum })						//"Valor Base RT"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0284,cMaskNum })						//"Valor do ISS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0285,cMaskNum })						//"Valor do ISS RT"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0286,cMaskNum })						//"Valor Tot Deduç~es"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0287,cMaskNum })						//"Valor Tot Recolher"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0288,cMaskNum })						//"Valor Tot Substituto"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0289,cMaskNum })						//"Valor Tot Filiais"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0290,cMaskNum })						//"Valor Tot Ded Out Munic"		

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Somente para contribuintes TARE este registro deve ser enviado.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lContrTare
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Montagem do registro C005 - BENEFICIOS FISCAIS - DADOS ADICIONAIS³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cAls	:=	"T"+StrZero(nAlsTrb++,2)
		aStru	:=	{}
		aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
		aAdd( aStru,{ cAls+"_UF",		"C",	002,	0 } )
		aAdd( aStru,{ cAls+"_REGNOM",	"C",	004,	0 } )
		aAdd( aStru,{ cAls+"_CMPINI",	"N",	002,	0 } )
		aAdd( aStru,{ cAls+"_QTDCMP",	"N",	001,	0 } )
		aAdd( aStrCmps,aStru )

		cArq	:=	CriaTrab(aStru)
		dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
		IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_REG")
		aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"C005" } )

		aAdd( aTitulo, {})
		aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0717))	//"C005 - Benefícios Fiscais - Dados Adicionais."
		aAdd( aTitulo[Len(aTitulo)],{})
		aAdd( aTitulo[Len(aTitulo)][2],{ STR0275,"@!" })							//"Registro"
		aAdd( aTitulo[Len(aTitulo)][2],{ STR0805,"@!" })							//"UF"
		aAdd( aTitulo[Len(aTitulo)][2],{ STR0680,"@!" })							//"Reg.Receptor"
		aAdd( aTitulo[Len(aTitulo)][2],{ STR0521,"99" })							//"Pos. Início"
		aAdd( aTitulo[Len(aTitulo)][2],{ STR0404,"9" })							//"Qtd Campos"
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro C020 - Nota Fiscal (Modelo 01 e 04)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_INDOP",	"C",	001,	0 } )
	aAdd( aStru,{ cAls+"_INDEM",	"C",	001,	0 } )
	aAdd( aStru,{ cAls+"_CODPAR",	"C",	013,	0 } )
	aAdd( aStru,{ cAls+"_CODMOD",	"C",	002,	0 } )
	aAdd( aStru,{ cAls+"_CODSIT",	"C",	002,	0 } )
	aAdd( aStru,{ cAls+"_SER",		"C",	003,	0 } )
	nTam	:=	TamSx3("F3_NFISCAL")[1]
	aAdd( aStru,{ cAls+"_NUMDOC",	"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_DTDOC",	"D",	010,	0 } )
	aAdd( aStru,{ cAls+"_DTES",		"D",	008,	0 } )
	aAdd( aStru,{ cAls+"_CODNAT",	"C",	005,	0 } )
	aAdd( aStru,{ cAls+"_VLRDOC",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_INDPAG",	"C",	001,	0 } )
	aAdd( aStru,{ cAls+"_VLRDES",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRMER",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_INDFRT",	"C",	001,	0 } )
	aAdd( aStru,{ cAls+"_VLRFRT",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRSEG",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRODP",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_BCICMS",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRICM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_BCST",		"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRST",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRIPI",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_CODOBS",	"C",	018,	0 } )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Somente para contribuintes TARE este registro deve ser enviado.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lContrTare
		aAdd( aStru,{ cAls+"_DESTNF",	"C",	001,	0 } )
	EndIf
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"C020" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0891))	//"C020 - Nota Fiscal (Modêlos 01 e 04)"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0291,"@!" })						//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0292,"@!" })						//"Op"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0293,"@!" })						//"Emit"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0294,"@!" })						//"Cod Participante"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0295,"@!" })						//"Mod"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0296,"@!" })						//"Sit"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0297,"@!" })						//"Série"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0298,"@!" })						//"Número Doc"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0299,"@!" })						//"Data Doc"					
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0300,"@!" })						//"Data Ent/Sa´da"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0301,"@!" })						//"Natureza"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0302,cMaskNum })					//"Valor Documento"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0303,"@!" })						//"Pag"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0304,cMaskNum })					//"Valor Desconto"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0305,cMaskNum })					//"Valor Mercadorias"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0306,"@!" })						//"Frt"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0307,cMaskNum })					//"Valor Frete"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0308,cMaskNum })					//"Valor Seguro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0309,cMaskNum })					//"Valor Despesas"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0310,cMaskNum })					//"Base Calculo ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0311,cMaskNum })					//"Valor ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0312,cMaskNum })					//"Base Calculo ST"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0313,cMaskNum }) 					//"Valor ST"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0314,cMaskNum })					//"Valor IPI"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0315,"@!" }) 						//"Código OBS"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Somente para contribuintes TARE este registro deve ser enviado.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lContrTare
		aAdd( aTitulo[Len(aTitulo)][2],{ STR0276,"@!" }) 						//"Ind. Dest."
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro C030 - FATURA³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_INDEM",	"C",	001,	0 } )
	aAdd( aStru,{ cAls+"_INTIT",	"C",	002,	0 } )
	nTam	:=	TamSx3("E2_HIST")[1]
	aAdd( aStru,{ cAls+"_TIT",		"C",	nTam,	0 } )
	nTam	:=	TamSx3("E2_NUM")[1]
	aAdd( aStru,{ cAls+"_NUMTIT",	"C",	nTam,	0 } )
	nTam	:=	TamSx3("E2_PARCELA")[1]
	aAdd( aStru,{ cAls+"_QTDPAR",	"N",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_VLRTIT",	"N",	022,	2 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStru,{ cAls+"_RELAC2",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"C030" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0892))	//"C030 - Fatura"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0316,"@!" })						//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0317,"@!" })						//"Emit"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0318,"@!" })						//"Tit"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0319,"@!" })						//"Descrição"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0320,"@!" })						//"Número"
	nTam	:=	TamSx3("E2_PARCELA")[1]
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0321,"@E"+Repli("9",nTam) })		//"Qtd Parc"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0322,cMaskNum })					//"Valor Título"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro C035 - Vencimentos³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	nTam	:=	TamSx3("E2_PARCELA")[1]
	aAdd( aStru,{ cAls+"_NUMPAR",	"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_DTVCTO",	"D",	008,	0 } )
	aAdd( aStru,{ cAls+"_VLRPAR",	"N",	022,	2 } )
	aAdd( aStru,{ cAls+"_RELAC2",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC2")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"C035" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0893))	//"C035 - Vencimentos da Fatura"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0323,"@!" })				//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0324,"@!" })				//"Parcela"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0325,"" })					//"Vencimento"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0326,cMaskNum })			//"Valor Parcela"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro C040 - Complemento ISS³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_VLRNT",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_BCISS",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRISS",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_BCIR",		"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_ALQIR",	"N",	006,	2 } )
	aAdd( aStru,{ cAls+"_VLRIR",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_BCINSS",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRINS",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"C040" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0894))	//"C040 - Complemento - ISSQN"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0327,"@!" })			//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0328,cMaskNum })		//"Valor Não-incidência"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0329,cMaskNum })		//"Base Calculo ISSQN"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0330,cMaskNum })		//"Valor ISSQN"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0331,cMaskNum })		//"Base Calculo IRRF"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0332,"@E 999.99" })	//"Aliq IRRF"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0333,cMaskNum })		//"Valor IRRF"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0334,cMaskNum })		//"Base Calculo INSS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0335,cMaskNum })		//"Valor INSS"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro C050 - Complemento - PIS/COFINS³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_ALQPIS",	"N",	006,	2 } )
	aAdd( aStru,{ cAls+"_VLRPIS",	"N",	022,	2 } )
	aAdd( aStru,{ cAls+"_ALQCOF",	"N",	006,	2 } )
	aAdd( aStru,{ cAls+"_VLRCOF",	"N",	022,	2 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"C050" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0895))	//"C050 - Complemento - PIS/COFINS"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0336,"@!" })				//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0337,"@E 999.99" })		//"Aliq PIS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0338,cMaskNum })			//"Valor PIS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0339,"@E 999.99" })		//"Aliq COFINS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0340,cMaskNum })			//"Valor COFINS"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro C060 - Complemento - Importação³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",	"C",	004,	0 } )
	nTam	:=	If( AliasIndic("SW6"),TamSx3("W6_DI_NUM")[1],6 )
	aAdd( aStru,{ cAls+"_NUMDI",	"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_DTREG",	"D",	008,	0 } )
	aAdd( aStru,{ cAls+"_DTDES",	"D",	008,	0 } )
	aAdd( aStru,{ cAls+"_VLRMER",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRPIS",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRCOF",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRADU",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_ADUICM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRIOF",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRII",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_BCIPI",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRIPI",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_BCICMS",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRICM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"C060" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0896))	//"C060 - Complemento - Importação"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0341,"@!" })				//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0342,"@!" })				//"Número DI"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0343,"" }) 				//"Data SISCOMEX"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0344,"" })					//"Data Desembaraço"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0345,cMaskNum })			//"Valor Mercadoria"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0346,cMaskNum })			//"Valor PIS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0347,cMaskNum })			//"Valor COFINS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0348,cMaskNum })			//"Valor Desp Aduaneiras"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0349,cMaskNum })			//"Valor ICMS Aduaneiras"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0350,cMaskNum })			//"Valor IOF"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0351,cMaskNum })			//"Valor Imp Importação"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0352,cMaskNum })			//"Base Cálculo IPI"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0353,cMaskNum })			//"Valor IPI"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0354,cMaskNum })			//"Base Cálculo ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0355,cMaskNum })			//"Valor ICMS"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro C300 - Itens Documento³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG", 		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_ITEM",		"C",	005,	0 } )
	nTam	:=	TamSx3("B1_COD")[1]
	aAdd( aStru,{ cAls+"_CODIT",	"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_VLRUN",	"N",	015,	3 } )
	aAdd( aStru,{ cAls+"_QTD",		"N",	015,	3 } )
	nTam	:=	TamSx3("D1_UM")[1]
	aAdd( aStru,{ cAls+"_UN",		"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_VLRIT",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_DESC",		"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_INDMOV",	"C",	001,	0 } )
	nTam	:=	TamSx3("B1_POSIPI")[1]
	aAdd( aStru,{ cAls+"_CODNCM",	"C",	nTam,	0 } )
	nTam	:=	TamSx3("B1_EX_NCM")[1]
	aAdd( aStru,{ cAls+"_EXNCM",	"C",	nTam,	0 } )
	nTam	:=	TamSx3("B1_EX_NBM")[1]
	aAdd( aStru,{ cAls+"_EXII",		"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_CST",		"C",	003,	0 } )
	aAdd( aStru,{ cAls+"_CFOP",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_BCICMS",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_ALQICM",	"N",	006,	2 } )
	aAdd( aStru,{ cAls+"_VLRICM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_BCST",		"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_ALQST",	"N",	006,	2 } )
	aAdd( aStru,{ cAls+"_VLRST",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_CTIPI",	"C",	002,	0 } )
	aAdd( aStru,{ cAls+"_BCIPI",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_ALQIPI",	"N",	006,	2 } )
	aAdd( aStru,{ cAls+"_VLRIPI",	"N",	014,	2 } )
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Somente para contribuintes TARE este registro deve ser enviado.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lContrTare
		aAdd( aStru,{ cAls+"_INDIF",	"N",	001,	0 } )
		aAdd( aStru,{ cAls+"_ITTARE",	"C",	002,	0 } )
		aAdd( aStru,{ cAls+"_REDBC",	"N",	014,	2 } )
	EndIf
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStru,{ cAls+"_RELAC2",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"C300" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0897))	//"C300 - Itens do documento"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0356,"@!" })					//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0357,"@!" })					//"Num It"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0358,"@!" })					//"Código Item"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0359,cMaskNum })				//"Valor Unitário"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0360,cMaskNum+"9" })			//"Quantidade"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0361,"@!" })					//"Unid"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0362,cMaskNum })				//"Valor Item"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0363,cMaskNum })				//"Valor Desconto"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0364,"@!" })					//"Mov"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0365,"@!" })					//"NCM"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0366,"@!" })					//"EX NCM"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0367,"@!" })					//"Ex II"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0368,"@!" })					//"CST"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0369,"@!" })					//"CFOP"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0370,cMaskNum })				//"Base Calculo ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0371,"@E 999.99" })			//"Aliq ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0372,cMaskNum }) 				//"Valor ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0373,cMaskNum })				//"Base Calculo ST"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0374,"@E 999.99" })			//"Aliq ST"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0375,cMaskNum }) 				//"Valor ST"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0376,"@!" })					//"CTIPI"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0377,cMaskNum })				//"Base Calculo IPI"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0378,"@E 999.99" })			//"Aliq IPI"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0379,cMaskNum })				//"Valor IPI"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Somente para contribuintes TARE este registro deve ser enviado.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lContrTare
		aAdd( aTitulo[Len(aTitulo)][2],{ STR0262,"9" })					//"Ind.Inc."
		aAdd( aTitulo[Len(aTitulo)][2],{ STR0255,"@!" })					//"It. Tare"
		aAdd( aTitulo[Len(aTitulo)][2],{ STR0243,cMaskNum })				//"%Red. ICMS"
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro C305 - Qualificacao³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	nTam	:=	TamSx3("B1_DESC")[1]
	aAdd( aStru,{ cAls+"_DESC",		"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_RELAC2",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC2")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"C305" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0898))	//"C305 - Qualificação Item"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ "Registro","@!" })
	aAdd( aTitulo[Len(aTitulo)][2],{ "Descrição","@!" })

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro C310 - Complemento - ISSQN³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_BCISS",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_ALQISS",	"N",	006,	2 } )
	aAdd( aStru,{ cAls+"_VLRISS",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_RELAC2",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC2")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"C310" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0899))	//"C310 - Complemento - ISSQN"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0380,"@!" })				//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0381, cMaskNum})			//"Base ISSQN"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0382, "@E 999.99"})		//"Aliq ISSQN"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0383, cMaskNum})			//"Valor ISSQN"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro C315 - Operacoes Medicamentos³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	nTam	:=	TamSx3("B8_LOTECTL")[1]
	aAdd( aStru,{ cAls+"_LOTE",		"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_DTVAL",	"D",	008,	0 } )
	aAdd( aStru,{ cAls+"_INDMED",	"C",	001,	0 } )
	aAdd( aStru,{ cAls+"_VALMAX",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_RELAC2",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC2")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"C315" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0900))	//"C315 - Operações Medicamentos"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0384,"@!" })				//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0385, "@!"})				//"Lote"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0386, ""})					//"Data Validade"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0387, "@!"})				//"Ind Med"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0388, cMaskNum})			//"Valor Tab Maximo"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro C320 - Operacoes Armas de Fogo³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_INDARM",	"C",	001,	0 } )
	nTam	:=	If( SB5->(FieldPos (aMVRC320[2]))>0,TamSx3(aMVRC320[2])[1],10 )
	aAdd( aStru,{ cAls+"_NUMARM",	"C",	nTam,	0 } )
	nTam	:=	If( SB5->(FieldPos (aMVRC320[3]))>0,TamSx3(aMVRC320[3])[1],10 )
	aAdd( aStru,{ cAls+"_NUMCAN",	"C",	nTam,	0 } )
	nTam	:=	If( SB5->(FieldPos (aMVRC320[4]))>0,TamSx3(aMVRC320[4])[1],20 )
	aAdd( aStru,{ cAls+"_DESC",		"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_RELAC2",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC2")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"C320" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0901))	//"C320 - Operações Armas Fogo"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0389, "@!"})		//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0390, "@!"})		//"Arm"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0391, "@!"})		//"Número"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0392, "@!"})		//"Cano"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0393, "@!"})		//"Descrição"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro C325 - Operacoes Veiculos novos³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_INDVEI",	"C",	001,	0 } )
	aAdd( aStru,{ cAls+"_CNPJ",		"C",	018,	0 } )
	aAdd( aStru,{ cAls+"_CPF",		"C",	014,	0 } )
	aAdd( aStru,{ cAls+"_UF",		"C",	002,	0 } )
	aAdd( aStru,{ cAls+"_IE",		"C",	002,	0 } )
	nTam	:=	If( SB5->(FieldPos (aMVRC325[1]))>0,TamSx3(aMVRC325[1])[1],20 )
	aAdd( aStru,{ cAls+"_CHASSI",	"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_RELAC2",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC2")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"C325" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0902))	//"C325 - Operações Veículos Novos"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0394,"@!" })		//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0395, "@!"})		//"Veic"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0396, "@!"})		//"CNPJ"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0397, "@!"})		//"CPF"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0398, "@!"})		//"UF"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0399, "@!"})		//"IE"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0400, "@!"})		//"Chassi"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro C500 - Analítico³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",	"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_CST",	"C",	003,	0 } )
	aAdd( aStru,{ cAls+"_CFOP",	"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_VLCONT",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_BCICMS",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_ALQICM",	"N",	006,	2 } )
	aAdd( aStru,{ cAls+"_VLRICM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRST",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRIPI",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"C500" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0903))	//"C500 - Analítico do documento"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0401,"@!" })			//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0402,"@!" })			//"CST"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0403,"@!" })			//"CFOP"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0209,cMaskNum })		//"Valor Contábil"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0405,cMaskNum })		//"Base Calculo ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0406,"@E 999.99" })  	//"Aliq ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0407,cMaskNum })		//"Valor ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0408,cMaskNum })  		//"Valor ST"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0409,cMaskNum })		//"Valor IPI"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro C550 - Nota Fiscal venda Consumidor(02)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_CODMOD",	"C",	002,	0 } )
	aAdd( aStru,{ cAls+"_CODSIT",	"C",	002,	0 } )
	aAdd( aStru,{ cAls+"_SER",		"C",	003,	0 } )
	aAdd( aStru,{ cAls+"_SUBSER",	"C",	002,	0 } )
	nTam	:=	TamSx3("F3_NFISCAL")[1]
	aAdd( aStru,{ cAls+"_NUMDOC",	"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_DTDOC",	"D",	010,	0 } )
	aAdd( aStru,{ cAls+"_VLRDOC",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRDES",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRMER",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_BCICMS",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRICM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_CODOBS",	"C",	018,	0 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"C550" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0904))	//"C550 - NF Consumidor(Modêlo 02)"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0410,"@!" })			//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0411,"@!" })			//"Mod"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0412,"@!" })			//"Sit"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0413,"@!" })			//"Série"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0414,"@!" })			//"Sub"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0415,"@!" })			//"Número"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0416,"" })				//"Data Doc"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0417,cMaskNum })		//"Valor Documento"	
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0418,cMaskNum })		//"Valor Desconto"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0419,cMaskNum })		//"Valor Mercadoria"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0420,cMaskNum }) 		//"Base Calculo ICMS" 
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0421,cMaskNum })		//"Valor ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0422,"@!" })			//"Código Obs"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro C555 - Itens Nota Fiscal venda Consumidor(02)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_ITEM",		"C",	005,	0 } )
	nTam	:=	TamSx3("B1_COD")[1]
	aAdd( aStru,{ cAls+"_CODIT",	"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_VLRUN",	"N",	015,	3 } )
	aAdd( aStru,{ cAls+"_QTD",		"N",	015,	3 } )
	nTam	:=	TamSx3("D1_UM")[1]
	aAdd( aStru,{ cAls+"_UN",		"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_VLRIT",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_DESC",		"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_CST", 		"C",	003,	0 } )
	aAdd( aStru,{ cAls+"_CFOP",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_BCICMS",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_ALQICM",	"N",	006,	2 } )
	aAdd( aStru,{ cAls+"_VLRICM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"C555" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0905))	//"C555 - Item NF Consumidor(Modêlo 02)"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0423,"@!" })				//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0424,"@!" })				//"Num It"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0425,"@!" })				//"Código Item"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0426,cMaskNum+"9" })		//"Valor Unitário"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0360,cMaskNum+"9" })		//"Quantidade"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0428,"@!" })				//"Unid"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0429,cMaskNum })			//"Valor Item"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0430,cMaskNum })			//"Valor Desconto"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0431,"@!" })				//"CST"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0432,"@!" })     			//"CFOP"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0433,cMaskNum })			//"Base Calculo ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0434,"@E 999.99" })		//"Aliq ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0435,cMaskNum }) 			//"Valor ICMS"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro C570 - Resumo Diario(02)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_CODMOD",	"C",	002,	0 } )
	aAdd( aStru,{ cAls+"_SER", 		"C",	003,	0 } )
	aAdd( aStru,{ cAls+"_SUBSER",	"C",	002,	0 } )
	nTam	:=	TamSx3("F3_NFISCAL")[1]
	aAdd( aStru,{ cAls+"_NUMINI",	"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_NUMFIM",	"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_QTDCAN",	"N",	006,	0 } )
	aAdd( aStru,{ cAls+"_DTDOC",	"D",	010,	0 } )
	aAdd( aStru,{ cAls+"_VLRDOC",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_BCICMS",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRICM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	008,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"C570" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0906))	//"C570 - Resumo Diario(Modêlo 02)"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0436,"@!" })				//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0437,"@!" })				//"Mod"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0438,"@!" })				//"Série"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0439,"@!" })				//"Sub"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0440,"@!" })				//"Número Inicial"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0441,"@!" })				//"Número Final"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0442,"@E 999999" })		//"Qtd Cancelada"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0443,"@!" })				//"Data Doc"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0444,cMaskNum })			//"Valor Documento"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0445,cMaskNum })			//"Base Calculo ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0446,cMaskNum })			//"Valor ICMS"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro C575 - Itens Resumo Diario(02)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG", 		"C",	004,	0 } )
	nTam	:=	TamSx3("B1_COD")[1]
	aAdd( aStru,{ cAls+"_CODIT",	"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_QTD",		"N",	015,	3 } )
	nTam	:=	TamSx3("B1_UM")[1]
	aAdd( aStru,{ cAls+"_UNID",		"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_VLRIT",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_CST",		"C",	003,	0 } )
	aAdd( aStru,{ cAls+"_CFOP",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_BCICMS",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_ALQICM",	"N",	006,	2 } )
	aAdd( aStru,{ cAls+"_VLRICM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"C575" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0907))	//"C575 - Item Resumo Diário(Modêlo 02)"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0447,"@!" })					//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0448,"@!" })					//"Código Item"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0360,cMaskNum+"9" })			//"Quantidade"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0428,"@!" })					//"Unid"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0450,cMaskNum })				//"Valor Item"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0451,"@!" })					//"CST"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0452,"@!" })					//"CFOP"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0453,cMaskNum })				//"Base Calculo ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0454,"@E 999.99" })			//"Aliq ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0455,cMaskNum })				//"Valor ICMS"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro C580 - Itens Resumo Mensal(02)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	nTam	:=	TamSx3("B1_COD")[1]
	aAdd( aStru,{ cAls+"_CODIT",	"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_QTD",		"N",	015,	3 } )
	aAdd( aStru,{ cAls+"_QTDCAN",	"N",	015,	3 } )
	nTam	:=	TamSx3("D1_UM")[1]
	aAdd( aStru,{ cAls+"_UN",		"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_VLRIT",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_DESC",		"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_BCICMS",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_ALQICM",	"N",	006,	2 } )
	aAdd( aStru,{ cAls+"_VLRICM",	"N",	014,	2 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_REG")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"C580" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0908))	//"C580 - Item Resumo Mensal(Modêlo 02)"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0456,"@!" })				//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0457,"@!" })				//"Código Item"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0360,cMaskNum+"9" })		//"Quantidade"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0459,cMaskNum+"9" })		//"Qtd Cancelada"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0460,"@!" })				//"UM"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0461,cMaskNum })  			//"Valor Item"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0462,cMaskNum })			//"Valor Desconto"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0463,cMaskNum })			//"Base Calculo ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0464,"@E 999.99" })		//"Aliq ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0465,cMaskNum })			//"Valor ICMS"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro C600 - Cupom Fiscal/ICMS (Modelo 2D)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_CODMOD",	"C",	002,	0 } )
	aAdd( aStru,{ cAls+"_CODSIT",	"C",	002,	0 } )
	nTam	:=	TamSx3("FT_PDV")[1]
	aAdd( aStru,{ cAls+"_ECFCX",	"C",	nTam,	0 } )
	nTam	:=	TamSx3("FI_SERPDV")[1]
	aAdd( aStru,{ cAls+"_ECFFAB",	"C",	nTam,	0 } )
	nTam	:=	TamSx3("FI_CRO")[1]
	aAdd( aStru,{ cAls+"_CRO",	"C",	nTam,	0 } )
	nTam	:=	TamSx3("FI_NUMREDZ")[1]
	aAdd( aStru,{ cAls+"_CRZ",	"C",	nTam,	0 } )
	nTam	:=	TamSx3("FT_NFISCAL")[1]
	aAdd( aStru,{ cAls+"_NUMDOC",	"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_DTDOC",	"D",	010,	0 } )
	aAdd( aStru,{ cAls+"_VLRDOC",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRCIS",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRCIC",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRCAN",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRDIS",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRDIC",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRDES",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRAIS",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRAIC",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRACR",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRISS",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_BCICMS",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRICM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRISE",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRNT",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRST",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	008,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"C600" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0953))	//"C600 - Cupom Fiscal/ICMS (Modelo 2D)"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0291,"@!" })						//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0295,"@!" })						//"Mod"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0296,"@!" })						//"Sit"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0954,"@!" })						//"Núm. ECF"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0955,"@!" })						//"Núm. Série"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0956,"@!" })						//"Cont. Reinício Op."
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0957,"@!" })						//"Cont. Redução Z"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0298,"@!" })						//"Número Doc"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0299,"" })							//"Data Doc"					
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0302,cMaskNum })					//"Valor Documento"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0958,cMaskNum })					//"Vlr Canc ISS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0959,cMaskNum })					//"Vlr Canc ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0960,cMaskNum })					//"Vlr Cancelamento"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0961,cMaskNum })					//"Vlr Desc ISS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0962,cMaskNum })					//"Vlr Desc ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0304,cMaskNum })					//"Valor Desconto"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0963,cMaskNum })					//"Vlr Acr ISS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0964,cMaskNum })					//"Vlr Acr ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0965,cMaskNum })					//"Valor Acréscimo"	
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0191,cMaskNum })					//"Valor de ISS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0310,cMaskNum })					//"Base Calculo ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0311,cMaskNum })					//"Valor ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0768,cMaskNum })					//"Valor ICMS Isento"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0966,cMaskNum })					//"Valor ICMS NT"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0313,cMaskNum }) 					//"Valor ST"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro C605 - Itens Cupom Fiscal/ICMS (Modelo 2D)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_ITEM",		"C",	005,	0 } )
	nTam	:=	TamSx3("B1_COD")[1]
	aAdd( aStru,{ cAls+"_CODIT",	"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_VLRUN",	"N",	015,	3 } )
	aAdd( aStru,{ cAls+"_QTD",		"N",	015,	3 } )
	aAdd( aStru,{ cAls+"_QTDCAN",	"N",	015,	3 } )
	nTam	:=	TamSx3("D1_UM")[1]
	aAdd( aStru,{ cAls+"_UN",		"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_VLRIT",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_DESC",		"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_CANC",		"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_ACRES",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRISS",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_CST",		"C",	003,	0 } )
	aAdd( aStru,{ cAls+"_CFOP",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_BCICMS",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_ALQICM",	"N",	006,	2 } )
	aAdd( aStru,{ cAls+"_VLRICM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRISE",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRNT",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRST",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"C605" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0967))	//"C605 - Itens Cupom Fiscal/ICMS (Modelo 2D)"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0356,"@!" })					//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0357,"@!" })					//"Num It"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0358,"@!" })					//"Código Item"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0359,cMaskNum })				//"Valor Unitário"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0360,cMaskNum+"9" })			//"Quantidade"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0442,cMaskNum+"9" })			//"Qtd Cancelamento"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0361,"@!" })					//"Unid"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0362,cMaskNum })				//"Valor Item"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0363,cMaskNum })				//"Valor Desconto"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0960,cMaskNum })				//"Vlr Cancelamento"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0965,cMaskNum })				//"Valor Acréscimo"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0191,cMaskNum })					//"Valor de ISS"	
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0368,"@!" })					//"CST"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0369,"@!" })					//"CFOP"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0370,cMaskNum })				//"Base Calculo ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0371,"@E 999.99" })			//"Aliq ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0372,cMaskNum }) 				//"Valor ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0768,cMaskNum })				//"Valor ICMS Isento"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0966,cMaskNum }) 				//"Valor ICMS NT"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0375,cMaskNum }) 				//"Valor ST"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro C620 - Resumo Diário Cupom Fiscal/ICMS (Modelo 2D)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_CODMOD",	"C",	002,	0 } )
	nTam	:=	TamSx3("FT_PDV")[1]
	aAdd( aStru,{ cAls+"_ECFCX",	"C",	nTam,	0 } )
	nTam	:=	TamSx3("FI_SERPDV")[1]
	aAdd( aStru,{ cAls+"_ECFFAB",	"C",	nTam,	0 } )	
	nTam	:=	TamSx3("FI_CRO")[1]
	aAdd( aStru,{ cAls+"_CRO",		"C",	nTam,	0 } )
	nTam	:=	TamSx3("FI_NUMREDZ")[1]
	aAdd( aStru,{ cAls+"_CRZ",		"C",	nTam,	0 } )
	nTam	:=	TamSx3("FT_NFISCAL")[1]
	aAdd( aStru,{ cAls+"_NDOCIN",	"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_NDOCFI",	"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_DTDOC",	"D",	010,	0 } )
	aAdd( aStru,{ cAls+"_QTDCAN",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRDOC",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRCIC",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRCAN",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRDIC",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRDES",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRAIC",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRACR",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_BCICMS",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRICM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRISE",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRNT",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRST",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	008,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"C620" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0970))	//"C620 - Resumo Diário Cupom Fiscal/ICMS (Modelo 2D)"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0291,"@!" })						//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0295,"@!" })						//"Mod"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0954,"@!" })						//"Núm. ECF"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0955,"@!" })						//"Núm. Série"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0956,"@!" })						//"Cont. Reinício Op."
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0957,"@!" })						//"Cont. Redução Z"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0968,"@!" })						//"Núm Doc Ini"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0969,"@!" })						//"Núm Doc Fim"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0299,"" })							//"Data Doc"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0442,cMaskNum })					//"Qtd Cancelamento"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0302,cMaskNum })					//"Valor Documento"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0959,cMaskNum })					//"Vlr Canc ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0960,cMaskNum })					//"Vlr Cancelamento"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0962,cMaskNum })					//"Vlr Desc ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0304,cMaskNum })					//"Valor Desconto"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0964,cMaskNum })					//"Vlr Acr ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0965,cMaskNum })					//"Valor Acréscimo"	
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0310,cMaskNum })					//"Base Calculo ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0311,cMaskNum })					//"Valor ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0768,cMaskNum })					//"Valor ICMS Isento"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0966,cMaskNum })					//"Valor ICMS NT"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0313,cMaskNum }) 					//"Valor ST"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro C625 - Reumo Itens Cupom Fiscal/ICMS (Modelo 2D)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	nTam	:=	TamSx3("B1_COD")[1]
	aAdd( aStru,{ cAls+"_CODIT",	"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_QTD",		"N",	015,	3 } )
	aAdd( aStru,{ cAls+"_QTDCAN",	"N",	015,	3 } )
	nTam	:=	TamSx3("D1_UM")[1]
	aAdd( aStru,{ cAls+"_UN",		"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_VLRIT",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_DESC",		"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_CANC",		"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_ACRES",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_BCICMS",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_ALQICM",	"N",	006,	2 } )
	aAdd( aStru,{ cAls+"_VLRICM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRISE",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRNT",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRST",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"C625" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0971))	//"C625 - Reumo Itens Cupom Fiscal/ICMS (Modelo 2D)"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0356,"@!" })					//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0358,"@!" })					//"Código Item"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0360,cMaskNum+"9" })			//"Quantidade"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0442,cMaskNum+"9" })			//"Qtd Cancelamento"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0361,"@!" })					//"Unid"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0362,cMaskNum })				//"Valor Item"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0363,cMaskNum })				//"Valor Desconto"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0960,cMaskNum })				//"Vlr Cancelamento"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0965,cMaskNum })				//"Valor Acréscimo"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0370,cMaskNum })				//"Base Calculo ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0371,"@E 999.99" })			//"Aliq ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0372,cMaskNum }) 				//"Valor ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0768,cMaskNum })				//"Valor ICMS Isento"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0966,cMaskNum }) 				//"Valor ICMS NT"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0375,cMaskNum }) 				//"Valor ST"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro C640 - Reumo Mensal Itens Cupom Fiscal/ICMS (Modelo 2D)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	nTam	:=	TamSx3("B1_COD")[1]
	aAdd( aStru,{ cAls+"_CODIT",	"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_QTD",		"N",	015,	3 } )
	aAdd( aStru,{ cAls+"_QTDCAN",	"N",	015,	3 } )
	nTam	:=	TamSx3("D1_UM")[1]
	aAdd( aStru,{ cAls+"_UN",		"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_VLRIT",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_DESC",		"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_CANC",		"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_ACRES",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_BCICMS",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_ALQICM",	"N",	006,	2 } )
	aAdd( aStru,{ cAls+"_VLRICM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRISE",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRNT",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRST",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"C640" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0972))	//"C640 - Reumo Mensal Itens Cupom Fiscal/ICMS (Modelo 2D)"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0356,"@!" })					//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0358,"@!" })					//"Código Item"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0360,cMaskNum+"9" })			//"Quantidade"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0442,cMaskNum+"9" })			//"Qtd Cancelamento"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0361,"@!" })					//"Unid"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0362,cMaskNum })				//"Valor Item"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0363,cMaskNum })				//"Valor Desconto"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0960,cMaskNum })				//"Vlr Cancelamento"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0965,cMaskNum })				//"Valor Acréscimo"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0370,cMaskNum })				//"Base Calculo ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0371,"@E 999.99" })			//"Aliq ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0372,cMaskNum }) 				//"Valor ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0768,cMaskNum })				//"Valor ICMS Isento"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0966,cMaskNum }) 				//"Valor ICMS NT"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0375,cMaskNum }) 				//"Valor ST"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro C700 - Cta Energia (Modelo 06)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG", 		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_INDOP",	"C",	001,	0 } )
	aAdd( aStru,{ cAls+"_INDEM",	"C",	001,	0 } )
	aAdd( aStru,{ cAls+"_CODPAR",	"C",	013,	0 } )
	aAdd( aStru,{ cAls+"_CODMOD",	"C",	002,	0 } )
	aAdd( aStru,{ cAls+"_CODSIT",	"C",	002,	0 } )
	aAdd( aStru,{ cAls+"_SER",		"C",	003,	0 } )
	aAdd( aStru,{ cAls+"_SUB",		"C",	002,	0 } )
	aAdd( aStru,{ cAls+"_CODCON",	"C",	002,	0 } )
	nTam	:=	TamSx3("F3_NFISCAL")[1]
	aAdd( aStru,{ cAls+"_NUMDOC",	"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_DTDOC",	"D",	010,	0 } )
	aAdd( aStru,{ cAls+"_DTES",	"D",	008,	0 } )
	aAdd( aStru,{ cAls+"_CODNAT",	"C",	005,	0 } )
	aAdd( aStru,{ cAls+"_VLRDOC",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRDES",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRFOR",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_SERVNT",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRTER",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRDA",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_BCICMS",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRICM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_CODOBS",	"C",	018,	0 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"C700" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0909))	//"C700 - Cta Energia (Modelo 06)"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0466,"@!" })			//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0467,"@!" })			//"Op"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0468,"@!" })			//"Emit"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0469,"@!" })			//"Cod Participante"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0470,"@!" })			//"Mod"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0471,"@!" })			//"Sit"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0472,"@!" })			//"Série"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0473,"@!" })			//"Sub"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0474,"@!" })			//"Cód Cons"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0475,"@!" })			//"Número Doc"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0476,"@!" })			//"Data Doc"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0477,"@!" })			//"Data Ent/Sa´da"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0478,"@!" })			//"Natureza"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0479,cMaskNum })		//"Valor Documento"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0480,cMaskNum })		//"Valor Desconto"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0481,cMaskNum })		//"Valor Fornecimento"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0482,cMaskNum })		//"Serviço Não-Trib"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0483,cMaskNum }) 		//"Valor Terceiros"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0484,cMaskNum })		//"Valor Descp Acess"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0485,cMaskNum })  		//"Base Calculo ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0486,cMaskNum })		//"Valor ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0487,"@!" })   		//"Código OBS"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro C705 - Complemento do Documento - Identificacao do ponto de consumo (Modelo 06)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	nTam	:=	Iif(SFU->(FieldPos("FU_CODUNC"))>0,TamSx3("FU_CODUNC")[1],5)
	aAdd( aStru,{ cAls+"_CODUNC",	"C",	nTam,	0 } )
	nTam	:=	Iif(SFU->(FieldPos("FU_TIPLIGA"))>0,TamSx3("FU_TIPLIGA")[1],1)
	aAdd( aStru,{ cAls+"_INDLIG",	"C",	nTam,	0 } )
	nTam	:=	Iif(SFU->(FieldPos("FU_GRUPT"))>0,TamSx3("FU_GRUPT")[1],2)
	aAdd( aStru,{ cAls+"_INDKV",	"C",	nTam,	0 } )
	nTam	:=	Iif(SFU->(FieldPos("FU_PERFIS"))>0,TamSx3("FU_PERFIS")[1],6)
	aAdd( aStru,{ cAls+"_PERFIS",	"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_DTINI",	"D",	008,	0 } )
	aAdd( aStru,{ cAls+"_DTFIM",	"D",	008,	0 } )
	aAdd( aStru,{ cAls+"_DTLEI",	"D",	008,	0 } )
	nTam	:=	Iif(SFU->(FieldPos("FU_DEMCT"))>0,TamSx3("FU_DEMCT")[1],10)
	aAdd( aStru,{ cAls+"_DEMPTA",	"N",	nTam,	0 } )
	nTam	:=	Iif(SFU->(FieldPos("FU_DEMCTP"))>0,TamSx3("FU_DEMCTP")[1],10)
	aAdd( aStru,{ cAls+"_DEMFPT",	"N",	nTam,	0 } )
	nTam	:=	Iif(SFU->(FieldPos("FU_CONSTOT"))>0,TamSx3("FU_CONSTOT")[1],10)
	aAdd( aStru,{ cAls+"_CONS",	"N",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"C705" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0910))	//"C705 - Ident. Ponto Consumo (Modelo 06)"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0488,"@!" })				//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0489,"@!" })    			//"Un Cons"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0490,"@!" }) 				//"Ind Lig"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0491,"@!" })				//"Ind KV"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0492,"@E 99/9999" })		//"Per Fiscal"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0493,"" })					//"Dt Inicial"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0494,"" }) 				//"Dt Final"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0495,"" }) 				//"Dt Leitura"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0496,"@E 9999999999" })	//"Dem Ponta"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0497,"@E 9999999999" })	//"Dem Fora-Ponta"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0498,"@E 9999999999" })	//"Cons Total"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro C750 - Itens Nota Fiscal (Modelo 06)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_ITEM",		"C",	005,	0 } )
	nTam	:=	TamSx3("B1_COD")[1]
	aAdd( aStru,{ cAls+"_CODIT",	"C",	nTam,	0 } )
	nTam	:=	Iif(SFU->(FieldPos("FU_CLASSIT"))>0,TamSx3("FU_CLASSIT")[1],2)
	aAdd( aStru,{ cAls+"_CODCL",	"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_VLRUN",	"N",	015,	3 } )
	aAdd( aStru,{ cAls+"_QTD",		"N",	015,	3 } )
	nTam	:=	TamSx3("D1_UM")[1]
	aAdd( aStru,{ cAls+"_UN",		"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_VLRIT",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_DESC",		"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_CST",		"C",	003,	0 } )
	aAdd( aStru,{ cAls+"_CFOP",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_BCICMS",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_ALQICM",	"N",	006,	2 } )
	aAdd( aStru,{ cAls+"_VLRICM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_INDREC",	"C",	001,	0 } )
	aAdd( aStru,{ cAls+"_CNPJ",		"C",	018,	0 } )
	aAdd( aStru,{ cAls+"_CPF",		"C",	014,	0 } )
	aAdd( aStru,{ cAls+"_UF",		"C",	002,	0 } )
	aAdd( aStru,{ cAls+"_IE",		"C",	011,	0 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"C750" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0911))	//"C750 - Itens documento (Modelo 06)"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0499,"@!" })				   		//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0500,"@!" })				   		//"Num Item"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0501,"@!" })				   		//"Cod Item"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0502,"@!" })				   		//"Cod Clas"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0503,cMaskNum+"9" })		   		//"Vlr Unitário"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0360,cMaskNum+"9" })		   		//"Quantidade"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0505,"" })				  			//"Unidade"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0506,cMaskNum })			   		//"Valor Item"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0507,cMaskNum })		   			//"Desconto"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0508,"@!" })						//"CST"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0509,"@!" })				 		//"CFOP"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0510,cMaskNum }) 			 		//"Base Calc ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0511,"@E 999.99" }) 		  		//"Aliq ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0512,cMaskNum })					//"Valor ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0513,"@!" })				   		//"Ind Rec"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0514,"@R 99.999.999/9999-99" })	//"CNPJ"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0515,"@R 999.999.999-99" })		//"CPF"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0516,"@!" })						//"UF"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0517,"@!" })						//"IE"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro C760 - Analitico Documento (Modelo 06)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_CST",		"C",	003,	0 } )
	aAdd( aStru,{ cAls+"_CFOP",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_VLRCON",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_BCICMS",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_ALQICM",	"N",	006,	2 } )
	aAdd( aStru,{ cAls+"_VLRICM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"C760" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0912))	//"C760 - AnalÍtico Documento (Modelo 06)"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0518,"@!" })				//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0519,"@!" })				//"CST"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0520,"@!" })				//"CFOP"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0209,cMaskNum })			//"Valor Contábil"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0522,cMaskNum })			//"Base Calc ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0523,"@E 999.99" })		//"Aliq ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0524,cMaskNum })			//"Valor ICMS"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro C770 - Documento Consolidado (Modelo 06)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_CODMOD",	"C",	002,	0 } )
	aAdd( aStru,{ cAls+"_CODMUN",	"C",	007,	0 } )
	aAdd( aStru,{ cAls+"_SER",		"C",	003,	0 } )
	aAdd( aStru,{ cAls+"_SUB",		"C",	002,	0 } )
	nTam	:=	Iif(SFU->(FieldPos("FU_CLASSIT"))>0,TamSx3("FU_CLASSIT")[1],2)
	aAdd( aStru,{ cAls+"_CODCL",	"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_QTDCON",	"C",	010,	0 } )
	aAdd( aStru,{ cAls+"_QTDCAN",	"C",	010,	0 } )
	aAdd( aStru,{ cAls+"_DTDOC",	"D",	010,	0 } )
	aAdd( aStru,{ cAls+"_VLRDOC",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRDES",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRFOR",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRSER",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRTER",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRDA",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_BCICMS",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRICM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_CONS",		"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	008,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"C770" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0913))	//"C770 - Documento Consolidado (Modelo 06)"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0525,"@!" })			//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0526,"@!" }) 			//"Modêlo"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0527,"@!" })			//"Cod Município"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0528,"@!" })			//"Série"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0529,"@!" })			//"Sub"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0530,"@!" })			//"Classe Cons"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0531,"@!" })			//"Qtd Doc"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0532,"@!" })			//"Qtd Doc Canc"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0533,"" })				//"Data Documento"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0534,cMaskNum })		//"Valor Documento"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0535,cMaskNum })		//"Valor Desconto"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0536,cMaskNum })		//"Vlr Fornecimento"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0537,cMaskNum })		//"Vlr Serv N-Trib"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0538,cMaskNum })		//"Valor Terceiros"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0539,cMaskNum })		//"Valor Base ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0540,cMaskNum })		//"Valor ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0541,cMaskNum })		//"Valor Consumo"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro C775 - Itens Concolidados (Modelo 06)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_ITEM",		"C",	005,	0 } )
	nTam	:=	TamSx3("B1_COD")[1]
	aAdd( aStru,{ cAls+"_CODIT",	"C",	nTam,	0 } )
	nTam	:=	Iif(SFU->(FieldPos("FU_CLASSIT"))>0,TamSx3("FU_CLASSIT")[1],2)
	aAdd( aStru,{ cAls+"_CODCL",	"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_QTD",		"N",	015,	3 } )
	nTam	:=	TamSx3("D1_UM")[1]
	aAdd( aStru,{ cAls+"_UN",		"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_VLRIT",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_DESC",		"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_CST", 		"C",	003,	0 } )
	aAdd( aStru,{ cAls+"_CFOP",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_ALQICM",	"N",	006,	2 } )
	aAdd( aStru,{ cAls+"_BCICMS",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRICM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"C775" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0914))	//"C775 - Itens Consolidados (Modelo 06)"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0542,"@!" })				//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0543,"@!" })				//"Num Item"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0544,"@!" })				//"Cod Item"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0545,"@!" })				//"Cod Clas"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0360,cMaskNum+"9" })		//"Quantidade"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0547,"" })					//"Unidade"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0548,cMaskNum })			//"Valor Item"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0549,cMaskNum })			//"Desconto"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0550,"@!" })				//"CST"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0551,"@!" })				//"CFOP"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0552,"@E 999.99" })		//"Aliq ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0553,cMaskNum })			//"Base Calc ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0554,cMaskNum })			//"Valor ICMS"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro D020 - Nota Fiscal de Servico Transporte (Modelo 07, 08, 09, 10 e 11)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_INDOP",	"C",	001,	0 } )
	aAdd( aStru,{ cAls+"_INDEM",	"C",	001,	0 } )
	aAdd( aStru,{ cAls+"_CODPAR",	"C",	013,	0 } )
	aAdd( aStru,{ cAls+"_CODMOD",	"C",	002,	0 } )
	aAdd( aStru,{ cAls+"_CODSIT",	"C",	002,	0 } )
	aAdd( aStru,{ cAls+"_SER",		"C",	003,	0 } )
	aAdd( aStru,{ cAls+"_SUB",		"C",	002,	0 } )
	nTam	:=	TamSx3("F3_NFISCAL")[1]
	aAdd( aStru,{ cAls+"_NUMDOC",	"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_DTDOC",	"D",	010,	0 } )
	aAdd( aStru,{ cAls+"_DTES",		"D",	008,	0 } )
	aAdd( aStru,{ cAls+"_CODNAT",	"C",	005,	0 } )
	aAdd( aStru,{ cAls+"_VLRDOC",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRDES",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_INDFRT",	"C",	001,	0 } )
	aAdd( aStru,{ cAls+"_VLRFRT",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_CST",		"C",	003,	0 } )
	aAdd( aStru,{ cAls+"_CFOP",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_BCICMS",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_ALQICM",	"N",	006,	2 } )
	aAdd( aStru,{ cAls+"_VLRICM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_CODOBS",	"C",	018,	0 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"D020" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0915))	//"D020 - Nota Fiscal Transporte (Modêlos 07, 08, 09, 10 e 11)"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0555,"@!" })				//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0556,"@!" })				//"Op"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0557,"@!" })				//"Emit"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0558,"@!" })				//"Cod Participante"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0559,"@!" }) 				//"Mod"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0560,"@!" })				//"Sit"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0561,"@!" })				//"Série"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0562,"@!" })				//"Sub"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0563,"@!" })				//"Número Doc"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0564,"" })					//"Data Doc"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0565,"@!" }) 				//"Data Ent/Sa´da"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0566,"@!" })				//"Natureza"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0567,cMaskNum })			//"Valor Documento"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0568,cMaskNum }) 			//"Valor Desconto"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0569,"@!" }) 				//"Frt"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0570,cMaskNum })			//"Valor Frete"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0571,"@!" })   			//"CST"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0572,"@!" })  				//"CFOP"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0573,cMaskNum }) 			//"Base Calc ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0574,"@E 999.99" })  		//"Aliq ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0575,cMaskNum })  			//"Valor ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0576,"@!" })  				//"Código OBS"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro D030 - Complemento (Modelo 07)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_MUNORI",	"C",	007,	0 } )
	aAdd( aStru,{ cAls+"_MUNDES",	"C",	007,	0 } )
	nTam	:=	TamSx3("DA3_PLACA")[1]
	aAdd( aStru,{ cAls+"_PLAVEI",	"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_UFVEIC",	"C",	002,	0 } )
	aAdd( aStru,{ cAls+"_MARCA",	"C",	055,	0 } )
	nTam	:=	TamSx3("DA3_DESC")[1]
	aAdd( aStru,{ cAls+"_MODELO",	"C",	055,	0 } )
	aAdd( aStru,{ cAls+"_ANO", 		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_CERT",		"C",	055,	0 } )
	aAdd( aStru,{ cAls+"_UFCERT",	"C",	002,	0 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"D030" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0916))	//"D030 - Complemento (Modêlos 07)"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0577,"@!" })			//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0578,"@!" })			//"Mun Origem"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0579,"@!" }) 			//"Mun Destino"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0580,"@!" })			//"Placa"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0581,"@!" }) 			//"UF Placa"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0582,"@!" }) 			//"Marca"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0583,"@!" })        	//"Modêlo"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0584,"@!" }) 			//"Ano"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0585,"@!" })			//"Certificado"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0586,"@!" }) 			//"UF Certificado"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro D040 - Itens Nota Fiscal (Modelo 07)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_ITEM",		"C",	005,	0 } )
	nTam	:=	TamSx3("B1_COD")[1]
	aAdd( aStru,{ cAls+"_CODIT",	"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_VLRFRT",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLROUT",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRSER",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"D040" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0917))	//"D040 - Itens Documento (Modêlo 07)"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0587,"@!" })				//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0588,"@!" })				//"Num Item"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0589,"@!" })				//"Código Item"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0590,cMaskNum })  			//"Valor do Frete"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0591,cMaskNum })  			//"Outros Valores"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0592,cMaskNum })  			//"Valor do Serviço"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro D050 - Complemento (Modelo 08)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_MUNORI",	"C",	007,	0 } )
	aAdd( aStru,{ cAls+"_MUNDES",	"C",	007,	0 } )
	aAdd( aStru,{ cAls+"_PARCON",	"C",	013,	0 } )
	aAdd( aStru,{ cAls+"_PARRED",	"C",	013,	0 } )
	aAdd( aStru,{ cAls+"_INDFRT",	"C",	001,	0 } )
	nTam	:=	TamSx3("DA3_PLACA")[1]
	aAdd( aStru,{ cAls+"_PLAVEI",	"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_UFVEIC",	"C",	002,	0 } )
	aAdd( aStru,{ cAls+"_MARCA",	"C",	055,	0 } )
	nTam	:=	TamSx3("DA3_DESC")[1]
	aAdd( aStru,{ cAls+"_MODELO",	"C",	055,	0 } )
	aAdd( aStru,{ cAls+"_ANO",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_FRTPV",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_SECCAT",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRDES",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_PEDG",		"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLROUT",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_FRT",		"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"D050" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0918))	//"D050 - Complemento (Modêlos 08)"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0593,"@!" })				//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0594,"@!" })				//"Mun Origem"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0595,"@!" })     			//"Mun Destino"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0596,"@!" })  				//"Consignatário"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0597,"@!" })    			//"Redespachante"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0598,"@!" })  				//"Ind Frt"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0599,"@!" })  				//"Placa"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0600,"@!" })				//"UF Placa"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0601,"@!" })  				//"Marca"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0602,"@!" })  				//"Modêlo"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0603,"@!" }) 				//"Ano"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0604,cMaskNum }) 			//"Valor Frt Peso/Vol"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0605,cMaskNum })   		//"Valores Sec/Cat"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0606,cMaskNum })			//"Valor Despesas"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0607,cMaskNum })			//"Valor Pedágio"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0608,cMaskNum })   		//"Outros Valores"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0609,cMaskNum })  			//"Valor Tot Frt"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro D180 - Carga Transportada (Modelos 08, 09, 10 e 11))³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_CNPJ",		"C",	018,	0 } )
	aAdd( aStru,{ cAls+"_CPF",		"C",	014,	0 } )
	aAdd( aStru,{ cAls+"_UF",		"C",	002,	0 } )
	aAdd( aStru,{ cAls+"_IE",		"C",	011,	0 } )
	aAdd( aStru,{ cAls+"_CODMOD",	"C",	002,	0 } )
	aAdd( aStru,{ cAls+"_SER",		"C",	003,	0 } )
	nTam	:=	TamSx3("F3_NFISCAL")[1]
	aAdd( aStru,{ cAls+"_NUMDOC",	"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_DTDOC",	"D",	010,	0 } )
	aAdd( aStru,{ cAls+"_VLRDOC",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRMER",	"N",	014,	2 } )
	nTam	:=	Iif(SB1->(FieldPos("B1_BRUPO"))>0,TamSx3("B1_BRUPO")[1],4)
	aAdd( aStru,{ cAls+"_NATVOL",	"C",	nTam,	0 } )
	nTam	:=	TamSx3("DTC_QTDVOL")[1]
	aAdd( aStru,{ cAls+"_QTDVOL",	"N",	nTam,	0 } )
	nTam	:=	TamSx3("B1_DESC")[1]
	aAdd( aStru,{ cAls+"_VOLUME",	"C",	nTam,	0 } )
	nTam	:=	TamSx3("B1_ESPECIE")[1]
	aAdd( aStru,{ cAls+"_ESPECI",	"C",	nTam,	0 } )
	nTam	:=	TamSx3("B1_FABRIC")[1]
	aAdd( aStru,{ cAls+"_MARCA",	"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_NUM", 		"N",	10,		0 } )
	nTam	:=	TamSx3("DTC_PESO")[1]
	aAdd( aStru,{ cAls+"_PESBRT",	"N",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_PESLIQ",	"N",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	008,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"D180" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0919))	//"D180 - Carga Transportada (Modêlos 08, 09, 10 e 11)"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0610,"@!" })						//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0611,"@R 99.999.999/9999-99" })		//"CNPJ"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0612,"@R 999.999.999-99" })			//"CPF"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0613,"@!" })						//"UF"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0614,"@!" })						//"IE"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0615,"@!" })						//"Modêlo"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0616,"@!" })						//"Ser"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0617,"@!" })						//"Num Doc"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0618,"" })							//"Data Doc"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0619,cMaskNum })					//"Valor Documento"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0620,cMaskNum })					//"Valor Mercadorias"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0621,"@!" })						//"Natureza Vol"
	nTam	:=	TamSx3("DTC_QTDVOL")[1]
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0622,"@E "+Repl("9",nTam) })		//"Qtd Vol "
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0623,"@!" })						//"Volume"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0624,"@!" })						//"Espécie"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0625,"@!" })						//"Marca"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0626,"@E 9999999999" })				//"Num Volumes"
	nTam	:=	TamSx3("DTC_PESO")[1]
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0627,"@E "+Repl("9",nTam) })		//"Peso Bruto "
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0628,"@E "+Repl("9",nTam) })		//"Peso Líquido "

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro D400 - Nota Fiscal (Modêlos 21 e 22)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_INDOP",	"C",	001,	0 } )
	aAdd( aStru,{ cAls+"_INDEM",	"C",	001,	0 } )
	aAdd( aStru,{ cAls+"_CODPAR",	"C",	013,	0 } )
	aAdd( aStru,{ cAls+"_CODMOD",	"C",	002,	0 } )
	aAdd( aStru,{ cAls+"_CODSIT",	"C",	002,	0 } )
	aAdd( aStru,{ cAls+"_SER",		"C",	003,	0 } )
	aAdd( aStru,{ cAls+"_SUB",		"C",	002,	0 } )
	aAdd( aStru,{ cAls+"_CODCON",	"C",	002,	0 } )
	nTam	:=	TamSx3("F3_NFISCAL")[1]
	aAdd( aStru,{ cAls+"_NUMDOC",	"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_DTDOC",	"D",	010,	0 } )
	aAdd( aStru,{ cAls+"_DTES",		"D",	008,	0 } )
	aAdd( aStru,{ cAls+"_CODNAT",	"C",	005,	0 } )
	aAdd( aStru,{ cAls+"_VLRDOC",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRDES",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRSER",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_SERVNT",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_TERC",		"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_DA",		"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_BCICMS",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRICM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_CODOBS",	"C",	018,	0 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"D400" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0920))	//"D400 - Nota Fiscal (Modêlos 21 e 22)"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0629,"@!" }) 						//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0630,"@!" })						//"Op"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0631,"@!" })						//"Emit"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0632,"@!" })  						//"Cod Participante"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0633,"@!" }) 						//"Mod"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0634,"@!" })   					//"Sit"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0635,"@!" }) 						//"Série"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0636,"@!" })  						//"Sub"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0637,"@!" })  						//"Class Cons"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0638,"@!" }) 						//"Número Doc"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0639,"" })    						//"Data Doc"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0640,"@!" })						//"Data Ent/Sa´da"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0641,"@!" })						//"Natureza"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0642,cMaskNum })   				//"Valor Documento"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0643,cMaskNum })  					//"Valor Desconto"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0644,cMaskNum })   				//"Valor Serviço"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0645,cMaskNum })					//"Valor Serviço NT"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0646,cMaskNum })   				//"Valor Terceiros"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0647,cMaskNum })					//"Valor Desp Acess"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0648,cMaskNum })   				//"Base Calc ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0649,cMaskNum })   				//"Valor ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0650,"@!" })						//"Código OBS"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro D405 - Complemento - Terminal (Modelo 21 e 22)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	nTam	:=	Iif(SFX->(FieldPos("FX_TERMINA"))>0,TamSx3("FX_TERMINA")[1],10)
	aAdd( aStru,{ cAls+"_TERM",		"C",	nTam,	0 } )
	nTam	:=	Iif(SFX->(FieldPos("FX_AREATER"))>0,TamSx3("FX_AREATER")[1],10)
	aAdd( aStru,{ cAls+"_CODARE",	"C",	nTam,	0 } )
	nTam	:=	Iif(SFX->(FieldPos("FX_TIPSERV"))>0,TamSx3("FX_TIPSERV")[1],1)
	aAdd( aStru,{ cAls+"_INDSER",	"C",	nTam,	0 } )
	nTam	:=	Iif(SFX->(FieldPos("FX_PERFIS"))>0,TamSx3("FX_PERFIS")[1],7)
	aAdd( aStru,{ cAls+"_PERFIS",	"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_DTINI",	"D",	008,	0 } )
	aAdd( aStru,{ cAls+"_DTFIM",	"D",	008,	0 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"D405" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0921))	//"D405 - Complemento - Terminal (Modelo 21 e 22)"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0651,"@!" })   			//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0652,"@!" })				//"Terminal"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0653,"@!" })				//"Cód Área"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0654,"@!" }) 				//"Ind Serv"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0655,"@!" })				//"Período Fiscal"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0656,"" })      			//"Data Início"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0657,"" })  				//"Data Final"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro D450 - Itens (Modelo 21 e 22)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_ITEM",		"C",	004,	0 } )
	nTam	:=	TamSx3("B1_COD")[1]
	aAdd( aStru,{ cAls+"_CODIT",	"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_CODCLA",	"C",	003,	0 } )
	aAdd( aStru,{ cAls+"_VLRUNI",	"N",	015,	3 } )
	aAdd( aStru,{ cAls+"_QTD",		"N",	015,	3 } )
	nTam	:=	TamSx3("B1_UM")[1]
	aAdd( aStru,{ cAls+"_UNID",		"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_VLRIT",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRDES",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_CST",		"C",	003,	0 } )
	aAdd( aStru,{ cAls+"_CFOP",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_BCICMS",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_ALQICM",	"N",	006,	2 } )
	aAdd( aStru,{ cAls+"_VLRICM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_INDREC",	"C",	001,	0 } )
	aAdd( aStru,{ cAls+"_CNPJ",		"C",	018,	0 } )
	aAdd( aStru,{ cAls+"_CPF",		"C",	014,	0 } )
	aAdd( aStru,{ cAls+"_UF",		"C",	002,	0 } )
	aAdd( aStru,{ cAls+"_IE",		"C",	011,	0 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"D450" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0922))	//"D450 - Itens (Modelo 21 e 22)"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0658,"@!" })  						//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0659,"@!" })						//"Num Item"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0660,"@!" })						//"Cod Item"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0661,"@!" })  						//"Cod Clas"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0662,cMaskNum+"9" })				//"Vlr Unitário"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0360,cMaskNum+"9" })				//"Quantidade"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0664,"" })   						//"Unidade"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0665,cMaskNum })					//"Valor Item"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0666,cMaskNum })					//"Desconto"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0667,"@!" })   					//"CST"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0668,"@!" }) 						//"CFOP"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0669,cMaskNum })   				//"Base Calc ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0670,"@E 999.99" })  				//"Aliq ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0671,cMaskNum })					//"Valor ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0672,"@!" })						//"Ind Rec"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0673,"@R 99.999.999/9999-99" })	//"CNPJ"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0674,"@R 999.999.999-99" })		//"CPF"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0675,"@!" })						//"UF"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0676,"@!" })						//"IE"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro D460 - Registro Analítico (Modelo 21 e 22)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_CST",		"C",	003,	0 } )
	aAdd( aStru,{ cAls+"_CFOP",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_VALCON",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_BCICMS",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_ALQICM",	"N",	006,	2 } )
	aAdd( aStru,{ cAls+"_VLRICM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"D460" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0923))	//"D460 - Registro Analítico (Modelo 21 e 22)"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0677,"@!" })					//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0678,"@!" }) 					//"CST"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0679,"@!" })   				//"CFOP"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0209,cMaskNum })				//"Valor Contábil"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0681,cMaskNum })    			//"Base Calc ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0682,"@E 999.99" })      		//"Aliq ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0683,cMaskNum })     			//"Valor ICMS"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro D470 - Consolidado (Modêlos 21 e 22)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_CODMOD",	"C",	002,	0 } )
	aAdd( aStru,{ cAls+"_CODMUN",	"C",	007,	0 } )
	aAdd( aStru,{ cAls+"_SER",		"C",	003,	0 } )
	aAdd( aStru,{ cAls+"_SUB",		"C",	002,	0 } )
	aAdd( aStru,{ cAls+"_CODCON",	"C",	002,	0 } )
	aAdd( aStru,{ cAls+"_QTDCON",	"N",	009,	0 } )
	aAdd( aStru,{ cAls+"_QTDCAN",	"N",	009,	0 } )
	aAdd( aStru,{ cAls+"_DTDOC",	"D",	010,	0 } )
	aAdd( aStru,{ cAls+"_VLRDOC",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRDES",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRSER",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_SERVNT",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_TERC",		"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_DA",		"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_BCICMS",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRICM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	008,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"D470" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0924))	//"D470 - Consolidado (Modêlos 21 e 22)"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0684,"@!" }) 					//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0685,"@!" }) 					//"Modêlo"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0686,"@!" })					//"Cod Município"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0687,"@!" })   				//"Série"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0688,"@!" })					//"Sub"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0689,"@!" })					//"Class Cons"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0690,"@E 999999999" })			//"Qtd Cons"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0691,"@E 999999999" })			//"Qtd Cancel"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0692,"" })						//"Data Doc"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0693,cMaskNum })				//"Valor Documento"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0694,cMaskNum })				//"Valor Desconto"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0695,cMaskNum }) 				//"Valor Serviço"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0696,cMaskNum })  				//"Valor Serviço NT"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0697,cMaskNum }) 				//"Valor Terceiros"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0698,cMaskNum })				//"Valor Desp Acess"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0699,cMaskNum })				//"Base Calc ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0700,cMaskNum })      			//"Valor ICMS"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro D475 - Itens (Modelo 21 e 22)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_ITEM",		"C",	004,	0 } )
	nTam	:=	TamSx3("B1_COD")[1]
	aAdd( aStru,{ cAls+"_CODIT",	"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_CODCLA",	"C",	003,	0 } )
	aAdd( aStru,{ cAls+"_QTD",		"N",	015,	3 } )
	nTam	:=	TamSx3("B1_UM")[1]
	aAdd( aStru,{ cAls+"_UNID",		"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_VLRIT",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRDES",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_CST",		"C",	003,	0 } )
	aAdd( aStru,{ cAls+"_CFOP",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_ALQICM",	"N",	006,	2 } )
	aAdd( aStru,{ cAls+"_BCICMS",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRICM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"D475" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0925))	//"D475 - Itens (Modelo 21 e 22)"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0701,"@!" })  					//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0702,"@!" })					//"Num Item"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0703,"@!" })					//"Cod Item"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0704,"@!" })					//"Cod Clas"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0360,cMaskNum+"9" })			//"Quantidade"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0706,"" })						//"Unidade"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0707,cMaskNum })				//"Valor Item"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0708,cMaskNum })     			//"Desconto"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0709,"@!" })					//"CST"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0710,"@!" })					//"CFOP"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0711,"@E 999.99" })			//"Aliq ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0712,cMaskNum })    			//"Base Calc ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0713,cMaskNum })				//"Valor ICMS"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro D480 - Registro Analítico (Modelo 21 e 22)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_CST",		"C",	003,	0 } )
	aAdd( aStru,{ cAls+"_CFOP",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_VALCON",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_BCICMS",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_ALQICM",	"N",	006,	2 } )
	aAdd( aStru,{ cAls+"_VLRICM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"D480" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0926))	//"D480 - Registro Analítico (Modelo 21 e 22)"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0714,"@!" })				//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0715,"@!" })				//"CST"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0716,"@!" })				//"CFOP"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0209,cMaskNum })			//"Valor Contábil"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0718,cMaskNum })			//"Base Calc ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0719,"@E 999.99" })		//"Aliq ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0720,cMaskNum })			//"Valor ICMS"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro E020 - Lançamentos (Modelo 01 e 04)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_INDOP",	"C",	001,	0 } )
	aAdd( aStru,{ cAls+"_INDEM",	"C",	001,	0 } )
	aAdd( aStru,{ cAls+"_CODPAR",	"C",	013,	0 } )
	aAdd( aStru,{ cAls+"_CODMOD",	"C",	002,	0 } )
	aAdd( aStru,{ cAls+"_CODSIT",	"C",	002,	0 } )
	aAdd( aStru,{ cAls+"_SER",		"C",	003,	0 } )
	nTam	:=	TamSx3("F3_NFISCAL")[1]
	aAdd( aStru,{ cAls+"_NUMDOC",	"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_DTDOC",	"D",	010,	0 } )
	nTam	:=	TamSx3("F3_LANCAM")[1]
	aAdd( aStru,{ cAls+"_NUMLCT",	"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_DTES",		"D",	008,	0 } )
	aAdd( aStru,{ cAls+"_VLRCON",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_BCICMS",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRICM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRST",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRCOM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_INDCOM",	"C",	002,	0 } )
	aAdd( aStru,{ cAls+"_ISEICM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_OUTICM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_BCIPI",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRIPI",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_ISEIPI",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_OUTIPI",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_CODOBS",	"C",	018,	0 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"E020" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0927))	//"E020 - Lançamentos (Modelo 01 e 04)"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0714,"@!" })				//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0721,"@!" })				//"Op"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0722,"@!" })				//"Emit"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0723,"@!" })				//"Cod Participante"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0724,"@!" })				//"Mod"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0725,"@!" })				//"Sit"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0726,"@!" })				//"Série"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0727,"@!" })				//"Número Doc"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0728,"@!" })				//"Data Doc"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0729,"@!" })				//"Num Lanc"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0730,"@!" })				//"Data Ent/Sa´da"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0209,cMaskNum })			//"Valor Contábil"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0732,cMaskNum })			//"Base Calc ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0733,cMaskNum })			//"Valor ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0734,cMaskNum })			//"Valor ICMS/ST"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0735,cMaskNum })			//"Valor Complementar"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0736,"@!" })				//"Ind Compl"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0737,cMaskNum })			//"Valor ICMS Isento"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0738,cMaskNum })    		//"Valor ICMS Outros"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0739,cMaskNum })			//"Base Calc IPI"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0740,cMaskNum })			//"Valor IPI"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0741,cMaskNum })			//"Valor IPI Isento"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0742,cMaskNum })			//"Valor IPI Outros"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0743,"@!" })     			//"Código OBS"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro E025 - Valores Parciais (Modelo 01 e 04)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_CFOP",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_VLRCON",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_BCICMS",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_ALIICM",	"N",	006,	2 } )
	aAdd( aStru,{ cAls+"_VLRICM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRST",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRCOM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_ISEICM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_OUTICM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_BCIPI",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRIPI",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_ISEIPI",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_OUTIPI",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"E025" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0928))	//"E025 - Valores Parciais (Modelo 01 e 04)"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0714,"@!" })					//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0744,"@!" })					//"CFOP"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0209,cMaskNum })				//"Valor Contábil"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0746,cMaskNum })				//"Base Calc ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0747,"@E 999.99" })			//"Aliq ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0748,cMaskNum })				//"Valor ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0749,cMaskNum })				//"Valor ICMS/ST"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0750,cMaskNum })				//"Valor Complementar"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0751,cMaskNum })				//"Valor ICMS Isento"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0752,cMaskNum })				//"Valor ICMS Outros"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0753,cMaskNum })				//"Base Calc IPI"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0754,cMaskNum })				//"Valor IPI"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0755,cMaskNum })				//"Valor IPI Isento"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0756,cMaskNum })				//"Valor IPI Outros"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro E050 - Lançamentos (Modelo 02)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_CODMOD",	"C",	002,	0 } )
	aAdd( aStru,{ cAls+"_SER",		"C",	003,	0 } )
	aAdd( aStru,{ cAls+"_SUB",		"C",	003,	0 } )
	nTam	:=	TamSx3("F3_NFISCAL")[1]
	aAdd( aStru,{ cAls+"_DOCINI",	"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_DOCFIM",	"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_DTDOC",	"D",	010,	0 } )
	nTam	:=	TamSx3("F3_LANCAM")[1]
	aAdd( aStru,{ cAls+"_NUMLCT",	"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_QTDCAN",	"N",	009,	0 } )
	aAdd( aStru,{ cAls+"_VLRCON",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_BCICMS",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRICM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_ISEICM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_OUTICM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_CODOBS",	"C",	018,	0 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"E050" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0929))	//"E050 - Lançamentos (Modelo 02)"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0714,"@!" })				//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0757,"@!" })				//"Mod"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0758,"@!" })				//"Série"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0759,"@!" })				//"Sub"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0760,"@!" })				//"Doc Inicial"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0761,"@!" })				//"Doc Final"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0762,"@!" })  				//"Data Doc"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0763,"@!" })  				//"Num Lanc"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0764,"@E 999999999" })		//"Qtd Cancelados"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0209,cMaskNum })  			//"Valor Contábil"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0766,cMaskNum })			//"Base Calc ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0767,cMaskNum })			//"Valor ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0768,cMaskNum })			//"Valor ICMS Isento"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0769,cMaskNum })			//"Valor ICMS Outros"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0770,"@!" })				//"Código OBS"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro E055 - Valores Parciais (Modelo 02)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_CFOP",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_VLRCON",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_BCICMS",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_ALIICM",	"N",	006,	2 } )
	aAdd( aStru,{ cAls+"_VLRICM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_ISEICM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_OUTICM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"E055" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0930))	//"E055 - Valores Parciais (Modelo 02)"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0714,"@!" })					//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0679,"@!" })     				//"CFOP"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0209,cMaskNum })				//"Valor Contábil"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0681,cMaskNum })				//"Base Calc ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0682,"@E 999.99" })			//"Aliq ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0683,cMaskNum })				//"Valor ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0768,cMaskNum })				//"Valor ICMS Isento"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0769,cMaskNum })    			//"Valor ICMS Outros"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro E100 - Lançamentos (Modelo 06, 21 e 22)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_INDOP",	"C",	001,	0 } )
	aAdd( aStru,{ cAls+"_INDEM",	"C",	001,	0 } )
	aAdd( aStru,{ cAls+"_CODPAR",	"C",	013,	0 } )
	aAdd( aStru,{ cAls+"_CODMOD",	"C",	002,	0 } )
	aAdd( aStru,{ cAls+"_CODSIT",	"C",	002,	0 } )
	aAdd( aStru,{ cAls+"_SER",		"C",	003,	0 } )
	aAdd( aStru,{ cAls+"_SUB",		"C",	003,	0 } )
	aAdd( aStru,{ cAls+"_CODCON",	"C",	002,	0 } )
	nTam	:=	TamSx3("F3_NFISCAL")[1]
	aAdd( aStru,{ cAls+"_NUMDOC",	"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_DTDOC",	"D",	010,	0 } )
	nTam	:=	TamSx3("F3_LANCAM")[1]
	aAdd( aStru,{ cAls+"_NUMLCT",	"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_DTES",		"D",	008,	0 } )
	aAdd( aStru,{ cAls+"_QTDDOC",	"N",	009,	0 } )
	aAdd( aStru,{ cAls+"_QTDCAN",	"N",	009,	0 } )
	aAdd( aStru,{ cAls+"_VLRCON",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_BCICMS",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRICM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_ISEICM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_OUTICM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_CODOBS",	"C",	018,	0 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"E100" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0931))	//"E100 - Lançamentos (Modelo 06, 21 e 22)"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0714,"@!" })						//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0721,"@!" })						//"Op"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0722,"@!" })						//"Emit"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0723,"@!" })						//"Cod Participante"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0724,"@!" })						//"Mod"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0725,"@!" })						//"Sit"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0726,"@!" })						//"Série"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0688,"@!" }) 						//"Sub"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0771,"@!" })						//"Cod Cons"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0772,"@!" })						//"Número Doc"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0773,"" })					   		//"Data Doc"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0774,"@!" })						//"Num Lanc"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0775,"@!" })						//"Data Ent/Sa´da"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0209,cMaskNum })					//"Valor Contábil"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0777,cMaskNum })					//"Base Calc ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0778,cMaskNum })					//"Valor ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0779,cMaskNum })					//"Valor ICMS Isento"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0780,cMaskNum })  					//"Valor ICMS Outros"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0781,"@!" })						//"Código OBS"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro E105 - Valores Parciais (Modelo 06, 21 e 22)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_CFOP",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_VLRCON",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_BCICMS",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_ALIICM",	"N",	006,	2 } )
	aAdd( aStru,{ cAls+"_VLRICM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_ISEICM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_OUTICM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"E105" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0932))	//"E105 - Valores Parciais (Modelo 06, 21 e 22)"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0714,"@!" })						//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0782,"@!" })						//"CFOP"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0209,cMaskNum })					//"Valor Contábil"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0784,cMaskNum })					//"Base Calc ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0785,"@E 999.99" })				//"Aliq ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0786,cMaskNum })					//"Valor ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0787,cMaskNum })					//"Valor ICMS Isento"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0788,cMaskNum })					//"Valor ICMS Outros"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro E120 - Lançamentos (Modelo 07, 08, 09, 10 e 11)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_INDOP",	"C",	001,	0 } )
	aAdd( aStru,{ cAls+"_INDEM",	"C",	001,	0 } )
	aAdd( aStru,{ cAls+"_CODPAR",	"C",	013,	0 } )
	aAdd( aStru,{ cAls+"_CODMOD",	"C",	002,	0 } )
	aAdd( aStru,{ cAls+"_CODSIT",	"C",	002,	0 } )
	aAdd( aStru,{ cAls+"_SER",		"C",	003,	0 } )
	aAdd( aStru,{ cAls+"_SUB",		"C",	003,	0 } )
	nTam	:=	TamSx3("F3_NFISCAL")[1]
	aAdd( aStru,{ cAls+"_NUMDOC",	"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_DTDOC",	"D",	010,	0 } )
	nTam	:=	TamSx3("F3_LANCAM")[1]
	aAdd( aStru,{ cAls+"_NUMLCT",	"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_DTES",		"D",	008,	0 } )
	aAdd( aStru,{ cAls+"_CFOP",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_VLRCON",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_BCICMS",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_ALIICM",	"N",	006,	2 } )
	aAdd( aStru,{ cAls+"_VLRICM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_ISEICM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_OUTICM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_CODOBS",	"C",	018,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_REG")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"E120" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0933))	//"E120 - Lançamentos (Modelo 07, 08, 09, 10 e 11)"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0714,"@!" })							//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0721,"@!" }) 							//"Op"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0722,"@!" })							//"Emit"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0723,"@!" })							//"Cod Participante"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0724,"@!" })							//"Mod"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0725,"@!" })							//"Sit"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0726,"@!" })   						//"Série"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0789,"@!" })							//"Sub"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0790,"@!" })							//"Número Doc"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0791,"" })								//"Data Doc"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0792,"@!" })							//"Num Lanc"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0793,"@!" })							//"Data Aq/Pres"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0794,"@!" })							//"CFOP"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0209,cMaskNum }) 						//"Valor Contábil"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0796,cMaskNum }) 						//"Base Calc ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0797,"@E 999.99" })					//"Aliq ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0798,cMaskNum })  						//"Valor ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0799,cMaskNum })						//"Valor ICMS Isento"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0800,cMaskNum })						//"Valor ICMS Outros"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0801,"@!" })							//"Código OBS"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro E300 - Período de Apuração do ICMS³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_DTINI",	"D",	008,	0 } )
	aAdd( aStru,{ cAls+"_DTFIM",	"D",	008,	0 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"E300" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0934))	//"E300 - Período de Apuração do ICMS"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0714,"@!" })					//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0760,"" })						//"Data Inicial"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0761,"" })						//"Data Final"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro E310 - Resumo por CFOP³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_CFOP",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_VLRCON",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_BCICMS",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRICM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRST",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRCOM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_ISEICM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_OUTICM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"E310" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0935))	//"E310 - Resumo por CFOP"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0714,"@!" })							//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0782,"@!" })							//"CFOP"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0209,cMaskNum })    					//"Valor Contábil"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0784,cMaskNum })						//"Base Calc ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0786,cMaskNum })						//"Valor ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0802,cMaskNum })          				//"Valor ICMS/ST" 
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0803,cMaskNum }) 						//"ICMS Complementar"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0787,cMaskNum })						//"Valor ICMS Isento"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0788,cMaskNum })						//"Valor ICMS Outros"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro E320 - Resumo por UF³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_INDOP",	"C",	001,	0 } )
	aAdd( aStru,{ cAls+"_UF",		"C",	002,	0 } )
	aAdd( aStru,{ cAls+"_VLRCON",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_BCICMS",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRICM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRST",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_VLRCOM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_ISEICM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_OUTICM",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"E320" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0936))	//"E320 - Resumo por UF"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0714,"@!" })						//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0804,"@!" })						//"Op"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0805,"@!" })						//"UF"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0209,cMaskNum })					//"Valor Contábil"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0807,cMaskNum })					//"Base Calc ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0808,cMaskNum })					//"Valor ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0802,cMaskNum })					//"Valor ICMS/ST"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0803,cMaskNum })					//"ICMS Complementar"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0799,cMaskNum }) 					//"Valor ICMS Isento"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0800,cMaskNum })					//"Valor ICMS Outros"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro E330 - Totalização³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_INDTOT",	"C",	001,	0 } )
	aAdd( aStru,{ cAls+"_VLRCON",	"N",	022,	2 } )
	aAdd( aStru,{ cAls+"_BCICMS",	"N",	022,	2 } )
	aAdd( aStru,{ cAls+"_VLRICM",	"N",	022,	2 } )
	aAdd( aStru,{ cAls+"_VLRST",	"N",	022,	2 } )
	aAdd( aStru,{ cAls+"_VLRCOM",	"N",	022,	2 } )
	aAdd( aStru,{ cAls+"_ISEICM",	"N",	022,	2 } )
	aAdd( aStru,{ cAls+"_OUTICM",	"N",	022,	2 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"E330" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0937))	//"E330 - Totalização"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0714,"@!" })  							//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0809,"@!" })							//"Tip Tot"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0209,cMaskNum })						//"Valor Contábil"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0796,cMaskNum })						//"Valor Contábil"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0798,cMaskNum })						//"Valor ICMS"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0802,cMaskNum })  						//"Valor ICMS/ST"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0803,cMaskNum }) 						//"ICMS Complementar"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0799,cMaskNum }) 						//"Valor ICMS Isento"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0800,cMaskNum }) 						//"Valor ICMS Outros"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro E340 - Ajustes Apuração|
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_CODAJ",	"C",	003,	0 } )
	aAdd( aStru,{ cAls+"_VLRAJ",	"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_NUMARR",	"C",	010,	0 } )
	aAdd( aStru,{ cAls+"_NUMPRO",	"C",	010,	0 } )
	aAdd( aStru,{ cAls+"_INDPRO",	"C",	001,	0 } )
	aAdd( aStru,{ cAls+"_PROC",		"C",	040,	0 } )
	aAdd( aStru,{ cAls+"_CODOBS",	"C",	020,	0 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"E340" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0938))	//"E340 - Ajustes Apuração"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0714,"@!" })							//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0810,"@!" })							//"Cód Ajuste"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0811,cMaskNum })						//"Valor Ajuste"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0812,"@!" })							//"Núm Doc Arrecadação"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0813,"@!" })							//"Número Processo"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0814,"@!" })							//"Ind Proc"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0815,"@!" })							//"Descrição Processo"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0816,"@!" })							//"Código OBS"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro E350 - OBRIGAÇÕES DO ICMS A RECOLHER|
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_CODOR",	"C",	003,	0 } )
	aAdd( aStru,{ cAls+"_VLOR",		"N",	014,	2 } )
	aAdd( aStru,{ cAls+"_DTVCTO",	"C",	008,	0 } )
	aAdd( aStru,{ cAls+"_CODREC",	"C",	010,	0 } )
	aAdd( aStru,{ cAls+"_UFOR",		"C",	002,	0 } )
	aAdd( aStru,{ cAls+"_NUMPRO",	"C",	010,	0 } )
	aAdd( aStru,{ cAls+"_INDPRO",	"C",	001,	0 } )
	aAdd( aStru,{ cAls+"_PROC",		"C",	040,	0 } )
	aAdd( aStru,{ cAls+"_CODOBS",	"C",	020,	0 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"E350" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0994))	//"E350 - Obrigações do ICMS a Recolher" *
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0714,"@!" })							//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0993,"@!" })							//"Cód Obrig" *
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0992,cMaskNum })						//"Valor Obrig" *
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0325,"@!" })							//"Vencimento"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0991,"@!" })							//"Cód Receita" *
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0805,"@!" })							//"UF"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0813,"@!" })							//"Número Processo"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0814,"@!" })							//"Ind Proc"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0815,"@!" })							//"Descrição Processo"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0816,"@!" })							//"Código OBS"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro E360 - Apuração ICMS|
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_VL01",		"N",	022,	2 } )
	aAdd( aStru,{ cAls+"_VL02",		"N",	022,	2 } )
	aAdd( aStru,{ cAls+"_VL03",		"N",	022,	2 } )
	aAdd( aStru,{ cAls+"_VL04",		"N",	022,	2 } )
	aAdd( aStru,{ cAls+"_VL05",		"N",	022,	2 } )
	aAdd( aStru,{ cAls+"_VL06",		"N",	022,	2 } )
	aAdd( aStru,{ cAls+"_VL07",		"N",	022,	2 } )
	aAdd( aStru,{ cAls+"_VL08",		"N",	022,	2 } )
	aAdd( aStru,{ cAls+"_VL09",		"N",	022,	2 } )
	aAdd( aStru,{ cAls+"_VL10",		"N",	022,	2 } )
	aAdd( aStru,{ cAls+"_VL11",		"N",	022,	2 } )
	aAdd( aStru,{ cAls+"_VL12",		"N",	022,	2 } )
	aAdd( aStru,{ cAls+"_VL13",		"N",	022,	2 } )
	aAdd( aStru,{ cAls+"_VL14",		"N",	022,	2 } )
	aAdd( aStru,{ cAls+"_VL15",		"N",	022,	2 } )
	aAdd( aStru,{ cAls+"_VL16",		"N",	022,	2 } )
	aAdd( aStru,{ cAls+"_VL17",		"N",	022,	2 } )
	aAdd( aStru,{ cAls+"_VL18",		"N",	022,	2 } )
	aAdd( aStru,{ cAls+"_VL19",		"N",	022,	2 } )
	aAdd( aStru,{ cAls+"_VL20",		"N",	022,	2 } )
	aAdd( aStru,{ cAls+"_VL99",		"N",	022,	2 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStru,{ cAls+"_RELAC2",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"E360" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0939))	//"E360 - Apuração de ICMS"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0714,"@!" })								//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0817,cMaskNum })							//"1=Débitos"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0818,cMaskNum })							//"2=Out Débitos"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0819,cMaskNum })							//"3=Estornos Crédito"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0820,cMaskNum })							//"4=Total Débitos(1+2+3)"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0821,cMaskNum })							//"5=Créditos"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0822,cMaskNum })							//"6=Out Créditos"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0823,cMaskNum })							//"7=Est Débitos"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0824,cMaskNum })							//"8=Créditos(5+6+7)"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0825,cMaskNum })							//"9=Sld Cr Anterior"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0826,cMaskNum })							//"10=Tot Créditos(8+9)"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0827,cMaskNum })							//"11=Crédito À Transp(10-4)"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0828,cMaskNum })   						//"12=Sld Devedor(4-10)"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0829,cMaskNum })							//"13=Deduções"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0830,cMaskNum })							//"14=ICMS Recolher(12-13)"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0831,cMaskNum })							//"15=ICMS Subst Entrada"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0832,cMaskNum })                          	//"16=ICMS Subst Saída"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0833,cMaskNum })							//"17=Dif Alíquota"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0834,cMaskNum })							//"18=ICMS Importação"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0835,cMaskNum })							//"19=Outras Obrigações"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0836,cMaskNum })							//"20=ICMS Total Rec"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0837,cMaskNum })							//"99=ICMS/ST Saídas"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro E365 - Obrigações por UF|
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_VLR",		"N",	022,	2 } )
	aAdd( aStru,{ cAls+"_UF",		"C",	002,	0 } )
	aAdd( aStru,{ cAls+"_RELAC2",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC2")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"E365" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0940))	//"E365 - Obrigações por UF"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0714,"@!" })						//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0802,cMaskNum })					//"Valor ICMS/ST"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0805,"@!" })						//"UF"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro E500 - Período de Apuração do IPI ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_DTINI",	"D",	008,	0 } )
	aAdd( aStru,{ cAls+"_DTFIM",	"D",	008,	0 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"E500" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0941))	//"E500 - Período de Apuração do IPI"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0714,"@!" })					//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0838,"" })						//"Data Inicial"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0839,"" })						//"Data Final"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro E510 - Resumo por CFOP³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_CFOP",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_CTIPI",	"C",	002,	0 } )
	aAdd( aStru,{ cAls+"_VLRCON",	"N",	022,	2 } )
	aAdd( aStru,{ cAls+"_BCIPI",	"N",	022,	2 } )
	aAdd( aStru,{ cAls+"_VLRIPI",	"N",	022,	2 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"E510" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0942))	//"E510 - Resumo por CFOP"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0714,"@!" })						//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0794,"@!" })    					//"CFOP"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0840,"@!" })						//"CTIPI"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0209,cMaskNum })					//"Valor Contábil"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0841,cMaskNum })					//"Base Calc IPI"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0842,cMaskNum })  					//"Valor IPI"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro E520 - Ajustes Apuração|
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_INDAJ",	"C",	001,	0 } )
	aAdd( aStru,{ cAls+"_DTAJ",		"D",	008,	0 } )
	aAdd( aStru,{ cAls+"_VLRAJ",	"N",	022,	2 } )
	aAdd( aStru,{ cAls+"_DESC",		"C",	040,	0 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"E520" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0943))	//"E520 - Ajustes Apuração"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0714,"@!" })						//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0843,"@!" })						//"Ind Aj"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0844,"" })							//"Data Ajuste"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0845,cMaskNum })					//"Valor Ajuste"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0846,"@!" }) 						//"Descrição"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro E530 - Apuração IPI|
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_SLDANT",	"N",	022,	2 } )
	aAdd( aStru,{ cAls+"_DEBSAI",	"N",	022,	2 } )
	aAdd( aStru,{ cAls+"_CREENT",	"N",	022,	2 } )
	aAdd( aStru,{ cAls+"_OUTDEB",	"N",	022,	2 } )
	aAdd( aStru,{ cAls+"_OUTCRE",	"N",	022,	2 } )
	aAdd( aStru,{ cAls+"_SLDCRE",	"N",	022,	2 } )
	aAdd( aStru,{ cAls+"_SLDDEV",	"N",	022,	2 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"E530" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0944))	//"E530 - Apuração IPI"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0714,"@!" })							//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0847,cMaskNum })						//"Saldo Anterior"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0848,cMaskNum })						//"Débitos"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0849,cMaskNum })						//"Créditos"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0850,cMaskNum })						//"Outros Débitos"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0851,cMaskNum })						//"Outros Créditos"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0852,cMaskNum })						//"Sld Cr período seguinte"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0853,cMaskNum })						//"Imposto Recolher"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro H020 - Totais Inventário³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_DTINV",	"D",	008,	0 } )
	aAdd( aStru,{ cAls+"_TOTAL",	"N",	022,	2 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"H020" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0945))	//"H020 - Totais Inventário"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0714,"@!" })						//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0854,"" })							//"Data Inventário"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0855,cMaskNum })					//"Total Estoque"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do Registro H025 - Inventário³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cAls	:=	"T"+StrZero(nAlsTrb++,2)
	aStru	:=	{}
	aAdd( aStru,{ cAls+"_REG",		"C",	004,	0 } )
	aAdd( aStru,{ cAls+"_INDPRO",	"C",	001,	0 } )
	aAdd( aStru,{ cAls+"_CODPAR",	"C",	001,	0 } )
	aAdd( aStru,{ cAls+"_INDINV",	"C",	001,	0 } )
	nTam	:=	TamSx3("B1_POSIPI")[1]
	aAdd( aStru,{ cAls+"_NCM",		"C",	nTam,	0 } )
	nTam	:=	TamSx3("B1_COD")[1]
	aAdd( aStru,{ cAls+"_CODIT",	"C",	nTam,	0 } )
	aAdd( aStru,{ cAls+"_VLRUNI",	"N",	022,	2 } )
	aAdd( aStru,{ cAls+"_QTD", 		"N",	009,	0 } )
	nTam	:=	TamSx3("B1_UM")[1]
	aAdd( aStru,{ cAls+"_UM",		"C",	nTam,	2 } )
	aAdd( aStru,{ cAls+"_VLRIT",	"N",	022,	2 } )
	aAdd( aStru,{ cAls+"_CODOBS",	"C",	020,	0 } )
	aAdd( aStru,{ cAls+"_RELAC",	"C",	010,	0 } )
	aAdd( aStrCmps,aStru )

	cArq	:=	CriaTrab(aStru)
	dbUseArea(.T.,__LocalDriver,cArq,SubStr(aStru[1][1],1,3))
	IndRegua(SubStr(aStru[1][1],1,3),cArq,SubStr(aStru[1][1],1,3)+"_RELAC")
	aAdd( aTrbs,{ cArq,SubStr(aStru[1][1],1,3),"H025" } )

	aAdd( aTitulo, {})
	aAdd( aTitulo[Len(aTitulo)],OemToAnsi(STR0946))	//"H025 - Inventário"
	aAdd( aTitulo[Len(aTitulo)],{})
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0714,"@!" })						//"Registro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0856,"@!" })						//"Ind Pro"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0857,"@!" })						//"Cód Participante"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0858,"@!" })						//"Ind Inv"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0859,"@!" })						//"NCM"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0860,"@!" })						//"Código Item"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0861,cMaskNum })					//"Valor Unitário"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0360,"@E 999999999" })				//"Quantidade"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0863,"@!" })						//"UM"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0864,cMaskNum })					//"Valor Item"
	aAdd( aTitulo[Len(aTitulo)][2],{ STR0865,"@!" })						//"Código OBS"
Else
	nArqVal := 2
EndIf
Return( aTrbs )
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |RetCntCmp ³ Autor ³ Gustavo G. Rueda      ³ Data ³20.08.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao utilizada para montar um array com os campos de cada |±±
±±³          ³ registro.                                                  |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³aRet -> Array na estrutura do registro alimentado.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cLinha -> Linha do arquivo texto a ser estruturado.         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RetCntCmp( cLinha )
Local	nX		:=	2
Local	aRet	:=	{}
Local	cCmp	:=	""

For nX := 2 To Len( cLinha )
	If SubStr( cLinha,nX,1 )=="|"
		aAdd( aRet, cCmp )
		cCmp	:=	""
	Else
		cCmp	+=	SubStr( cLinha,nX,1 )
	EndIf
Next nX
Return( aRet )
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |AlimentTrb³ Autor ³ Gustavo G. Rueda      ³ Data ³20.08.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao utilizada para alimentar os TRBs criados de acordo   |±±
±±³          ³ o arquivo texto gerado anteriormente.                      |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cFile -> Nome do arquivo texto gerado anteriormente.        ³±±
±±³          |aTrbs -> Array contendo os nomes dos TRBs gerados.          ³±±
±±³          |aRegra -> Regra de nivel dos registros.                     ³±±
±±³          |aStrCmps -> Estrutura de campos dos TRBs criados.           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AlimentTrb(cFile, aTrbs, aRegra, aStrCmps)
Local	cLinha		:= ""
Local	aCmps		:= {}
Local	nCmp		:= 0
Local	nX			:= 1
Local	nI			:= 1
Local	nRecPai		:= 0
Local	nRecFilho	:= 0
Local	cReg		:= ""
Local	cRegPai		:= ""
Local	nPosReg		:= 0
Local	nPosReg2	:= 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Alimentacao dos TRBs acima³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FT_FUSE(cFile)
FT_FGOTOP()
Do While !FT_FEOF()
	cLinha	:= FT_FREADLN()
	aCmps	:= RetCntCmp( cLinha )
	nCmp	:= 1
	cReg	:= SubStr(cLinha,2,4)

	If (nPos	:= aScan(aTrbs, {|aX| aX[3]==cReg}))>0
		cAlias	:= aTrbs[nPos][2]
		nX		:= Val(SubStr(cAlias,2,2))

		dbSelectArea(cAlias)
		RecLock(cAlias,.T.)

		If (nPosReg	:= aScan(aRegra,{|aX| aX[1]==cReg}))>0
			cRegPai	:= cReg
			nRecPai	:= (cAlias)->(Recno())
		Else
			If (nPosReg := aScan(aRegra,{|aX| aX[1]==cRegPai}))>0
				If Len(aRegra[nPosReg])>1
					For nI := 2 To Len(aRegra[nPosReg])
						If aRegra[nPosReg][nI][1]==cReg
							If Len(aRegra[nPosReg][nI])>1
								nRecFilho := (cAlias)->(Recno())
							EndIf
						EndIf
					Next nI
				EndIf
			EndIf
		EndIf
		For nI := 1 To Len(aStrCmps[nX])
			If nI<=Len(aCmps) .Or. "_RELAC"$aStrCmps[nX][nI][1]
				If !"_RELAC"$aStrCmps[nX][nI][1]
					If aStrCmps[nX][nI][2]=="D"
						(cAlias)->(FieldPut(nI, CToD( Transform( aCmps[nCmp++],"@R 99/99/9999" ))))
					ElseIf aStrCmps[nX][nI][2]=="N"
						(cAlias)->(FieldPut(nI, Val(StrTran(aCmps[nCmp++],",","."))))
					Else
						(cAlias)->(FieldPut(nI, aCmps[nCmp++]))
					EndIf
				ElseIf "_RELAC2"$aStrCmps[nX][nI][1]
					(cAlias)->(FieldPut(nI, StrZero(nRecFilho,10)))
				ElseIf "_RELAC"$aStrCmps[nX][nI][1]
					(cAlias)->(FieldPut(nI, StrZero(nRecPai,10)))
				EndIf
			EndIf
		Next nI
		MsUnLock()
	EndIf
	FT_FSKIP()
EndDo
Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |CriaLog   ³ Autor ³ Gustavo G. Rueda      ³ Data ³23.05.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao que cria registros de logs em pontos estrategicos do |±±
±±³          ³ do fonte para auxilio na analise de eventuais inconsisten- |±±
±±³          ³ cias.                                                      |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|aLog -> Array contendo as informacoes do log que serao gra- ³±±
±±³          |  vados ao final do processamento da rotina.                ³±±
±±³          |nOpc -> Identifica qual o ponto de chamada da funcao.       ³±±
±±³          |cAliasSFT -> Alias da tabela SFT em processamento.          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CriaLog(aLog, nOpc, cAliasSFT)
Local cEspecie := ""

Default cAliasSFT := ""

cEspecie := IIf(!Empty(cAliasSFT), aModNot((cAliasSFT)->FT_ESPECIE), "")

aAdd(aLog, {"",""})
If nOpc==1
	aLog[Len(aLog),1]	:=	STR0427+STR0449+(cAliasSFT)->FT_FILIAL+STR0458+(cAliasSFT)->FT_NFISCAL+"/"+(cAliasSFT)->FT_SERIE	//"ERRO: "###"Nota Fiscal [Filial:"###", Número:"
	aLog[Len(aLog),1]	+=	STR0504+(cAliasSFT)->FT_CLIEFOR+"/"+(cAliasSFT)->FT_LOJA+STR0546+(cAliasSFT)->FT_ESPECIE+STR0663	//", Participante:"###", Especie:"###"] retornou modêlo ["
	aLog[Len(aLog),1]	+=	cEspecie+STR0705	//"] e não será enviado na apuração do período, por não corresponder à um dos modêlos válidos para o layout contemplado pelo Protheus."
	
	aLog[Len(aLog),2]	:=	STR0862+STR0080	//"SOLUÇÃO: "###"Verificar qual a classificação correta da espécie desta nota fiscal para que o Ato Cotepe a considere nos registros apropriados durante a geração do meio-magnético."
ElseIf nOpc==2
	aLog[Len(aLog),1]	:=	STR0427+STR0449+(cAliasSFT)->FT_FILIAL+STR0458+(cAliasSFT)->FT_NFISCAL+"/"+(cAliasSFT)->FT_SERIE	//"ERRO: "###"Nota Fiscal [Filial:"###", Número:"
	aLog[Len(aLog),1]	+=	STR0504+(cAliasSFT)->FT_CLIEFOR+"/"+(cAliasSFT)->FT_LOJA+STR0546+(cAliasSFT)->FT_ESPECIE+STR0663	//", Participante:"###", Especie:"###"] retornou modêlo ["
	aLog[Len(aLog),1]	+=	cEspecie+STR0227	//"] e não será enviado na apuração do período, por não encontrar nenhum Documento de Transporte (tabela DT6) correspondente."
	
	aLog[Len(aLog),2]	:=	STR0862+STR0234	//"SOLUÇÃO: "###"Verificar consistência da base de dados, pois esta nota fiscal de transporte originou-se no módulo TMS escriturando o Livro Fiscal que é a base para geração deste meio-magnético; diante desta situação, não foi identificado nenhuma correspondência para este documento fiscal na tabela DT6 (Documento de Transporte) utilizando a pesquisa pela chave 1 do cadastro de índice: DT6_FILIAL+DT6_FILDOC+DT6_DOC+DT6_SERIE"
ElseIf nOpc==3
	aLog[Len(aLog),1]	:=	STR0427+STR0987		//"ERRO: "###"Não foi encontrada Apuração de Simples - Federal para o periodo informado."
	
	aLog[Len(aLog),2]	:=	STR0862+STR0988		//"SOLUÇÃO: "###"Execute a Apuração do Simples Federal com o mesmo periodo informado nos parametros de geração do Ato Cotepe 35"
ElseIf nOpc==4
	//-- 4.2.3-Tabela Codigo Fiscal de Prestacoes de Servicos - CFPS (ISS)
	aLog[Len(aLog),1]	:=	STR0427+STR0449+(cAliasSFT)->FT_FILIAL+STR0458+(cAliasSFT)->FT_NFISCAL+"/"+(cAliasSFT)->FT_SERIE	//"ERRO: "###"Nota Fiscal [Filial:"###", Número:"
	aLog[Len(aLog),1]	+=	STR0504+(cAliasSFT)->FT_CLIEFOR+"/"+(cAliasSFT)->FT_LOJA+STR0546+(cAliasSFT)->FT_ESPECIE+STR0663	//", Participante:"###", Especie:"###"] retornou modêlo ["
	aLog[Len(aLog),1]	+=	cEspecie+"]"

	aLog[Len(aLog),2]	:=	STR0862+"Verificar qual o Código Fiscal de Prestações de Serviços (CFPS) válido conforme tabela 4.2.3"
ElseIf nOpc==5
	aLog[Len(aLog),1]	:=	STR0427+STR0449+(cAliasSFT)->FT_FILIAL+STR0458+(cAliasSFT)->FT_NFISCAL+"/"+(cAliasSFT)->FT_SERIE	//"ERRO: "###"Nota Fiscal [Filial:"###", Número:"
	aLog[Len(aLog),1]	+=	STR0504+(cAliasSFT)->FT_CLIEFOR+"/"+(cAliasSFT)->FT_LOJA+STR0546+(cAliasSFT)->FT_ESPECIE+STR0663	//", Participante:"###", Especie:"###"] retornou modêlo ["
	aLog[Len(aLog),1]	+=	cEspecie+"] e não será enviado na apuração do período, por não encontrar nenhuma informação nos Livors Fiscais (tabela SF3) correspondente."

	aLog[Len(aLog),2]	:=	STR0862+"Verificar consistência da base de dados, pois esta nota fiscal de transporte originou-se no módulo TMS escriturando o Livro Fiscal que é a base para geração deste meio-magnético; diante desta situação, não foi identificado nenhuma correspondência para este documento fiscal na tabela SF3 (Livros Fiscais)."
EndIf
Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |GeraTxtLog³ Autor ³ Gustavo G. Rueda      ³ Data ³23.05.2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao que gera as informacoes do array ALOG em um arquivo  |±±
±±³          ³ texto de nome fixo LOGCOTEPE.TXT no mesmo diretorio do ar- |±±
±±³          ³ quivo magnetico.                                           |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cDir -> Diretorio de geracao do arquivo magnetico.          ³±±
±±³          |aLog -> Array base das informacoes para geracao do arquivo  ³±±
±±³          |  texto correspondente ao log.                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraTxtLog (cDir, aLog)
Local	lRet	:=	.T.
Local	cTxt	:=	AllTrim (cDir)+"LOGCOTEPE.TXT"
Local	nHandle	:=	0
Local	cTxtBkp	:=	""
Local	nI		:=	0

If !(File (cTxt))
	nHandle	:=	MsFCreate (cTxt)
Else
	cTxtBkp	:=	StrTran	(cTxt,	".TXT",	".#XT")
	If File (cTxtBkp)
		FErase (cTxtBkp)
	Endif
	FRename (cTxt, cTxtBkp)
	nHandle	:=	MsFCreate (cTxt)
Endif

If (Len (aLog)==0)
	cRegistro	:=	STR0092	//"Nenhuma ocorrência conhecida foi constatada."
	FWrite (nHandle, cRegistro)
Else
	For nI := 1 To Len (aLog)
			FWrite (nHandle, aLog[nI][1]+CHR(13)+CHR(10))
			FWrite (nHandle, aLog[nI][2]+CHR(13)+CHR(10))
			FWrite (nHandle, ""+CHR(13)+CHR(10))
	Next (nI)
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fecha arquivo texto                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (nHandle>=0)
	FClose (nHandle)
Endif

Return (lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |RegA300   ³ Autor ³Rodrigo zatt           ³ Data ³04/11/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³     RegA300 - Itens da NF de Servico Mod simplificada      ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao do Registro B430                                  |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoe contidas no array    ³±±
±±³          ³ aCmpAntSFT e na tabela SFT.                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³RegA300 - 2(varios por Nota)                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cAliasSFT -> Alias da tabela SFT aberta no momento.         ³±±
±±³          ³ funcao a ser retornado para gravacao pela funcao principal.³±±
±±³          |aRegB300 -> Array contendo as informacoes processadas pela  ³±±
±±³          ³ funcao a ser retornado para gravacao pela funcao principal.³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/ 
Static Function RegA300 (cAlias,aTotalISS, aCmpAntSFT, cAliasSFT, cSituaDoc,cEspecie, cCfps, cChave, cMvNfSS,cCodObs,lGeraReg,nRelac,aRegA310)
	Local	nPos		:= 0
	Local	cAlSA1SA2	:= ""
	Local	cIndA1A2	:= ""
	Local	aRegA300	:= {}

	If ((nPos := aScan(aRegA300,{|aX| aX[6]==aCmpAntSFT[2] .And. aX[8]==aCmpAntSFT[1] .And. aX[9]==aCmpAntSFT[6]}))==0)
		aAdd(aRegA300, {})
		nPos	:=	Len (aRegA300)
		aAdd (aRegA300[nPos], "A300")					//01 - REG

		cAlSA1SA2	:= IIf((cAliasSFT)->FT_CFOP>= "5000","SA1","SA2")  //verifico o CLiente e fornecedor referente ao documento posicionado    
		cIndA1A2 	:= SubStr(cAlSA1SA2,2,2)+"_CGC"
		If !Empty(cAlSA1SA2)
			DbSelectArea (cAlSA1SA2)
			(cAlSA1SA2)->(DbSetOrder(1))
			If (cAlSA1SA2)->(DbSeek (xFilial (cAlSA1SA2)+aCmpAntSFT[03]+aCmpAntSFT[04]))
				aAdd (aRegA300[nPos], IIF(len(Alltrim((cAlSA1SA2)->(&(cIndA1A2)))) > 11,"",(cAlSA1SA2)->(&(cIndA1A2))))        	//02 - CPF  do tomador
				aAdd (aRegA300[nPos], IIF(len(Alltrim((cAlSA1SA2)->(&(cIndA1A2)))) > 11,(cAlSA1SA2)->(&(cIndA1A2)),""))	     	//03 - CNPJ do tomador		
			Else
				aAdd (aRegA300[nPos], "")				//02 - CPF Inscricao do tomador
				aAdd (aRegA300[nPos], "")				//03 - CNPF do tomador
			EndIf
		EndIf
		aAdd (aRegA300[nPos], Substr(cMvNfSS,At("=",cMvNfSS)-3,2))	//04 - COD_MOD Tabela 4.1.2 documentos fiscais ISS
		aAdd (aRegA300[nPos], cSituaDoc)				//05 - COD_SIT Tabela 4.1.3 Situacao do documento
		aAdd (aRegA300[nPos], aCmpAntSFT[02])			//06 - SER
		aAdd (aRegA300[nPos], " ")						//07 - SUB
		aAdd (aRegA300[nPos], aCmpAntSFT[01])			//08 - NUM_DOC
		aAdd (aRegA300[nPos], aCmpAntSFT[06])			//09 - DT_DOC
		aAdd (aRegA300[nPos], cCfps)					//10 - CFPS
		aAdd (aRegA300[nPos], aTotalISS[10])			//11 - VL_DOC
		aAdd (aRegA300[nPos], aTotalISS[09])			//12 - VL_DESC
		aAdd (aRegA300[nPos], aTotalISS[01])			//13 - VL_SERV
		aAdd (aRegA300[nPos], 0)						//14 - VL_MAT_PROP
		aAdd (aRegA300[nPos], 0)						//15 - VL_DA
		aAdd (aRegA300[nPos], aTotalISS[02])			//16 - VL_BC_ISSQN
		aAdd (aRegA300[nPos], aTotalISS[03])			//17 - VL_ISSQN
		aAdd (aRegA300[nPos], cCodObs)					//18 - COD_INF_OBS
	Endif

	GrvRegTrb (cAlias, nRelac, aRegA300)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³GRAVACAO REGISTRO A310³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	GrvRegTrb (cAlias, nRelac, aRegA310)
Return .T.

//-------------------------------------------------------------------
/*/{Protheus.doc}
@description geracao do registro A320 - DOCUMENTOS - RESUMO DIARIO DE NOTA FISCAL DE SERVICOS (MODELO SIMPLIFICADO)
@author Flavio Luiz Vicco
@since 01/08/2017
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function RegA320(aRegA320,aTotalISS,aCmpAntSFT,cAliasSFT,cSituaDoc,cEspecie,cCfps,cMvNfSS)
Local nPos := 0

Default aRegA320 := {}

If ((nPos := aScan(aRegA320,{|aX| aX[03]==aCmpAntSFT[02] .And. aX[07]==aCmpAntSFT[06] .And. aX[08]==cCfps}))==0)
	aAdd(aRegA320, {})
	nPos := Len(aRegA320)
	aAdd(aRegA320[nPos], "A320")								//01 - REG
	aAdd(aRegA320[nPos], Substr(cMvNfSS,At("=",cMvNfSS)-3,2))	//02 - COD_MOD
	aAdd(aRegA320[nPos], aCmpAntSFT[02])						//03 - SER
	aAdd(aRegA320[nPos], " ")									//04 - SUB
	aAdd(aRegA320[nPos], aCmpAntSFT[01])						//05 - NUM_DOC_INI
	aAdd(aRegA320[nPos], aCmpAntSFT[01])						//06 - NUM_DOC_FIN
	aAdd(aRegA320[nPos], aCmpAntSFT[06])						//07 - DT_DOC
	aAdd(aRegA320[nPos], cCfps)									//08 - CFPS
	aAdd(aRegA320[nPos], 0)										//09 - QTD_CANC
	aAdd(aRegA320[nPos], 0)										//10 - VL_DOC
	aAdd(aRegA320[nPos], 0)										//11 - VL_DESC
	aAdd(aRegA320[nPos], 0)										//12 - VL_SERV
	aAdd(aRegA320[nPos], 0)										//13 - VL_MAT_PROP
	aAdd(aRegA320[nPos], 0)										//14 - VL_DA
	aAdd(aRegA320[nPos], 0)										//15 - VL_BC_ISSQN
	aAdd(aRegA320[nPos], 0)										//16 - VL_ISSQN
Else
	//-- Range de Numero de Documentos
	If (aCmpAntSFT[01] < aRegA320[nPos][05])
		aRegA320[nPos][05] := aCmpAntSFT[01]	//05 - NUM_DOC_INI
	EndIf
	//
	If (aCmpAntSFT[01] > aRegA320[nPos][06])
		aRegA320[nPos][06] := aCmpAntSFT[01]	//06 - NUM_DOC_FIN
	EndIf
EndIf

If (cSituaDoc $"02#03#04")	//02=Situacao de cancelada
	aRegA320[nPos][09] := aRegA320[nPos][09]+1	//09 - QTD_CANC
EndIf

aRegA320[nPos][10] += aTotalISS[10]				//10 - VL_DOC
aRegA320[nPos][11] += aTotalISS[09]				//11 - VL_DESC
aRegA320[nPos][12] += aTotalISS[01]				//12 - VL_SERV
aRegA320[nPos][15] += aTotalISS[02]				//15 - VL_BC_ISSQN
aRegA320[nPos][16] += aTotalISS[03]				//16 - VL_ISSQN

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |CorCliC600³ Autor ³ Vendas CRM            ³ Data ³13/01/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica se o cliente e o cliente padrao caso seja feita   |±±
±±³          ³ venda para ele vai buscar o CGC na tabela SL1 para pegar o |±±
±±³          ³ cgc do cliente que foi feita a venda.                      |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|PARAM01 - Alias do SFT filtrado com os perguntes            ³±±
±±³          |PARAM02 - Array com os dados do cliente para gravacao  da   ³±±
±±³          |  		Tabela C600			                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function CorCliC600(cAliasSFT,aPartDoc)
Local aArea   := GetArea()
Local cCodCli := ""     //Codigo do cliente removido do aPartDoc
Local clojCli := ""     //Codigo da Loja Removimdo do aPartDoc
Local cCliPad := Padr(SuperGetMv("MV_CLIPAD"),TamSx3("A1_COD")[1] )
Local cLojPad := Padr(SuperGetMv("MV_LOJAPAD"), TamSx3("A1_LOJA")[1] )
Local lCGCCLI := SL1->(FieldPos("L1_CGCCLI")) >0

Default aPartDoc := {}
Default cAliasSFT := ""

If Len(aPartDoc) > 0 .AND. !Empty(cAliasSFT)

	cCodCli := SUBSTR(APARTDOC[1] , 6, TAMSX3("A1_COD")[1] )  // Codigo do cliente SA1
	clojCli := Substr(APARTDOC[1] , Len(APARTDOC[1]) - TamSx3("A1_LOJA")[1] +1 ,Len(APARTDOC[1]) )

	DbSelectArea("SL1")
	DbSetorder(2)
	If DbSeek( (cAliasSFT)->FT_FILIAL + (cAliasSFT)->FT_SERIE + (cAliasSFT)->FT_NFISCAL + (cAliasSFT)->FT_PDV )
		If AllTrim(cCodCli + clojCli) <> AllTrim(cCliPad + cLojPad) .And. (lCGCCLI .AND. Empty(AllTrim(SL1->L1_CGCCLI)))
			aPartDoc[5] := ""
			aPartDoc[4] := ""
		Else
			If lCGCCLI
				If Len(ALLTRIM(SL1->L1_CGCCLI)) == 14
					aPartDoc[5] := ""
					aPartDoc[4] := SL1->L1_CGCCLI
				Else
					aPartDoc[5] := SL1->L1_CGCCLI
					aPartDoc[4] := ""
				EndIf
			EndIf
		EndIf
	EndIf
	RestArea(aArea)
EndIf
Return(Nil)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |RegA350   ³ Autor ³ Vendas CRM            ³ Data ³08/04/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gera os Dados para a criacao dp Registro A350 -            |±±
±±³          ³ Geracao dos registros de (ISS)Servico emitidos pelo cupom  |±±
±±³          ³ fiscal                                                     |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|PARAM01 - Tipo de Documento conforme tabela item 4.1.1      ³±±
±±³          |PARAM02 - Data inicial para a geracao do arquivo do Cotepe  ³±±
±±³          |PARAM03 - Data Final para a geracao do arquivo do Cotepe    ³±±
±±³          |PARAM04 - Filial inicial para a geracao dos registros       ³±±
±±³          |PARAM05 - Filial final para a geracao dos registros         ³±±
±±³          |PARAM06 - Alias para a gravacao do registro principal       ³±±
±±³          |PARAM07 - Array com os dados do Registro A350               ³±±
±±³          |PARAM08 - Array com os dados do Registro a360               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GrRgA350Rg360(dDataDe,dDataAte,cFilDe,cFilAte,cAliasa,aRegA350,aRegA360,aReg02Aux  ) // somente para servico  RegA350
Local aArea       := GetArea()
Local nCount      := 0
Local nC          := 0
Local nFI_PDV     := 0    // Valor do campo FI_PDV
Local cFI_SERPDV  := ""   // Campo FI_SERPDV
Local nFI_CRO     := 0    // Valor do campo FI_CRO
Local nFI_NUMREDZ := 0    // Valor do campo FI_NUMREDZ
Local cFT_NFISCAL := ""   // Numero do documento Fiscal
Local dFT_EMISSAO := 0    // Data de Emissao do Documento
Local cFT_CFPS    := ""   // Codigo Fiscal de Prestacoes de Servicos, conforme a tabela indicada no item 4.2.3
Local nFT_TOTAL   := 0    // Valor do documento fiscal
Local nISS_CANCEL := 0    // Valor dos cancelamentos referentes ao ISSQN
Local nICM_CANCEL := 0    // Valor dos cancelamentos referentes ao ICMS
Local nTOTAL_CANC := 0    // Valor dos cancelamentos registrados
Local nISS_DESC   := 0    // Valor dos descontos referentes ao ISSQN
Local nICM_DESC   := 0    // Valor dos descontos referentes ao ICMS
Local nDESC_TOT   := 0    // Valor dos descontos registrados
Local nISS_TBASE  := 0    // Valor da base de calculo do ISSQN
Local nISS_VALOR  := 0    // Valor do ISSQN
Local nISS_ISEN   := 0    // Valor das prestacoes isentas do ISSQN
Local nISEN_RET   := 0    // Valor das prestacoes com ISSQN retido por substituicao tributaria
Local cChave      := ""   // Chave para verificacao de alteracao dos registros
Local cAliasTrb   := ""
Local cQueryAux   := ""   // Query auxiliar para buscar os documentos com servico na venda.
Local cQuery      := ""   // Query para geracao dos registros A350: DOCUMENTO - CUPOM FISCAL/ISSQN
Local nI          := 0    // Numero sequencial para garacao do registro A360
Local cCST_ISS    := ""   // Campo para a o item conforme a tabela 4.3.3 do Ato Cotepe
Local cVlrunt     := "0"  // Valor unitario do item
Local cQuant      := "0"  // Quantidade do item
Local cCpf        := ""	  // Numero de inscricao do tomador do servico no CPF
Local cCnpj       := ""   // Numero de inscricao do tomador do servico no CNPJ
Local nContador   := 1    //
Local aReg0200    := {}  // Array para a gravacao dos itens para o registro 0200
Local nP          := 0   // contador para o array de itens do produto
Local cCodGen     := ""  // Campo do item do Produto
Local aAliasTrb   := {}
Local lValidCGC   := .F.
Local lCGCCLI     := SL1->(FieldPos("L1_CGCCLI"))>0
Local cSituaDoc   := ""
Default aRegA350    := {}
Default aRegA360    := {}

#IFDEF TOP
If SFI->(RecCount()) > 0
	cQueryAux := "SELECT FT_NFISCAL FROM " + RetSQLTab('SFT')
	cQueryAux += " WHERE FT_EMISSAO BETWEEN '" + DtoS(dDataDe) + "' AND '" + DtoS(dDataAte) + "' AND "
	cQueryAux += " FT_FILIAL BETWEEN '" + cFilDe + "' AND '" + cFilAte + "' AND FT_TIPO = 'S' "

	cQuery := " SELECT FT_FILIAL,SFT.FT_TIPO,SFI.FI_PDV,SFI.FI_SERPDV,SFI.FI_CRO,SFI.FI_NUMREDZ,"
	cQuery += " SFT.FT_NFISCAL,SFT.FT_EMISSAO,SFT.FT_CFPS,SFT.FT_CSTISS, "
	cQuery += " SFT.FT_PRODUTO,SFT.FT_PRCUNIT,SFT.FT_QUANT,SFT.FT_DESCONT,SFT.FT_VALCONT,SFT.FT_TOTAL, "
	cQuery += " SFT.FT_BASEICM,SFT.FT_ALIQICM,SFT.FT_VALICM,SFT.FT_ISENICM,SFT.FT_ISENRET,SFT.FT_ITEM,SFT.FT_SERIE,SFT.FT_DTCANC,FT_ENTRADA,FT_OBSERV,FT_PDV, "
	cQuery += " SB1.B1_UM,SB1.B1_DESC,SB1.B1_CODISS,SB1.B1_POSIPI,SB1.B1_CODISS,SA1.A1_CGC,SL2.L2_PRCTAB "
	If lCGCCLI
		cQuery += ",SL1.L1_CGCCLI "
	Endif
	cQuery += " FROM " + RetSQLTab('SFT')
	cQuery += " LEFT JOIN " + RetSQLTab('SFI') + " ON SFT.FT_FILIAL = SFI.FI_FILIAL  AND SFT.FT_EMISSAO = SFI.FI_DTMOVTO AND SFT.FT_PDV = SFI.FI_PDV "
	cQuery += " LEFT JOIN " + RetSQLTab('SL1') + " ON SFT.FT_FILIAL = SL1.L1_FILIAL  AND SFT.FT_NFISCAL = SL1.L1_DOC AND SFT.FT_EMISSAO = SL1.L1_EMISNF "
	cQuery += " LEFT JOIN " + RetSQLTab('SL2') + " ON SFT.FT_FILIAL  = SL2.L2_FILIAL AND SFT.FT_PRODUTO = SL2.L2_PRODUTO AND SFT.FT_NFISCAL = SL2.L2_DOC  AND SFT.FT_SERIE = SL2.L2_SERIE AND SFT.FT_ITEM = SL2.L2_ITEM "
	cQuery += " LEFT JOIN " + RetSQLTab('SB1') + " ON SFT.FT_PRODUTO = SB1.B1_COD "
	cQuery += " LEFT JOIN " + RetSQLTab('SA1') + " ON SFT.FT_CLIEFOR  = SA1.A1_COD AND SFT.FT_LOJA = SA1.A1_LOJA "
	cQuery += " WHERE SFT.FT_EMISSAO BETWEEN '" + DtoS(dDataDe) + "' AND '" + DtoS(dDataAte) + "' AND "
	cQuery += " FT_FILIAL BETWEEN '" + cFilDe + "' AND '" + cFilAte + "' AND FT_TIPO = 'S' AND "
	cQuery += " SFT.D_E_L_E_T_ <> '*'  AND "
	cQuery += " FT_NFISCAL  IN (" + cQueryAux + ") "
	cQuery += " ORDER BY SFT.FT_FILIAL,SFT.FT_NFISCAL,SFT.FT_SERIE,SFT.FT_ITEM "

	cAliasTrb := GetNextAlias()
	cQuery    := ChangeQuery( cQuery )
	DbUseArea( .T., 'TOPCONN', TcGenQry(,,cQuery), cAliasTrb, .T., .F. )

	(cAliasTrb)->(DbGoTop() )
	cChave := (cAliasTrb)->FT_FILIAL + (cAliasTrb)->FT_NFISCAL  + (cAliasTrb)->FT_SERIE
	While !(cAliasTrb)->( Eof() )
		aAliasTrb := {(cAliasTrb)->FT_FILIAL,(cAliasTrb)->FT_NFISCAL,(cAliasTrb)->FT_SERIE }
		If !Empty ( AllTrim ((cAliasTrb)->FI_SERPDV ) )

			lValidCGC := Reg600VlPrd("S", aReg02Aux,dDataDe,dDataAte,aAliasTrb,cFilDe,cFilAte)
			If cChave ==  (cAliasTrb)->FT_FILIAL + (cAliasTrb)->FT_NFISCAL + (cAliasTrb)->FT_SERIE .OR.  Len (aRegA360 ) == 0
				nFI_PDV     := Val( (cAliasTrb)->FI_PDV )
				nFI_CRO     := Val( (cAliasTrb)->FI_CRO )
				cFI_SERPDV  := (cAliasTrb)->FI_SERPDV
				nFI_NUMREDZ := Val((cAliasTrb)->FI_NUMREDZ )
				cCST_ISS    := (cAliasTrb)->FT_CSTISS
				cCnpj       := ""
				cCpf        := ""

				If lCGCCLI
					If lValidCGC  .AND. Len(Alltrim((cAliasTrb)->L1_CGCCLI )) > 11
						cCnpj :=   AllTrim((cAliasTrb)->L1_CGCCLI )
					ElseIf lValidCGC .AND. Len(Alltrim((cAliasTrb)->L1_CGCCLI )) <= 11
						cCpf  := AllTrim((cAliasTrb)->L1_CGCCLI )
					EndIf
				EndIf

				cFT_NFISCAL := PadL( AllTrim(STR( Val((cAliasTrb)->FT_NFISCAL ) ) ) ,TamSX3("FT_NFISCAL")[1], "0" )
				dFT_EMISSAO := STOD( (cAliasTrb)->FT_EMISSAO )
				cFT_CFPS    := Padr((cAliasTrb)->FT_CFPS ,4 )
				nFT_TOTAL   += (cAliasTrb)->FT_VALCONT
				nISS_DESC   += If((cAliasTrb)->FT_TIPO == "S", (cAliasTrb)->FT_DESCONT, 0 )
				nICM_DESC   += If((cAliasTrb)->FT_TIPO == "L", (cAliasTrb)->FT_DESCONT, 0 )
				nDESC_TOT   += (cAliasTrb)->FT_DESCONT
				nISS_TBASE  += If((cAliasTrb)->FT_TIPO == "S", (cAliasTrb)->FT_BASEICM, 0 )
				nISS_VALOR  += If((cAliasTrb)->FT_TIPO == "S", (cAliasTrb)->FT_VALICM , 0 )
				nISS_ISEN   += If((cAliasTrb)->FT_TIPO == "S", (cAliasTrb)->FT_ISENICM, 0 )
				nISEN_RET   += If((cAliasTrb)->FT_TIPO == "S", (cAliasTrb)->FT_ISENRET, 0 )
				cSituaDoc   := RetSitDoc ((cAliasTrb)->FT_TIPO, cAliasTrb)
			Else
				AADD(aRegA350,{} )
				nCount := Len (aRegA350 )
				AAdd(aRegA350[nCount], "A350"					) //01 - C - Texto Fixo do registro
				AAdd(aRegA350[nCount], cCpf						) //02 - N - Numero de inscricao do tomador do servico no CPF
				AAdd(aRegA350[nCount], cCnpj					) //03 - N - Numero de inscricao do tomador do servico no CNPJ
				AAdd(aRegA350[nCount], "2D"						) //04 - C - Tabela 4.1.1 Tipo - Cupom Fiscal emitido por ECF			
				AAdd(aRegA350[nCount], cSituaDoc				) //05 - N - tabela 4.1.3 Tipo - Documento regular
				AAdd(aRegA350[nCount],AllTrim(str(nFI_PDV))		) //06 - N - Numero do caixa atribuído ao ECF
				AAdd(aRegA350[nCount],cFI_SERPDV				) //07 - C - Numero de serie de fabricacao do ECF
				AAdd(aRegA350[nCount],AllTrim(str(nFI_CRO))		) //08 - N - Posicao do Contador de Reinicio de Operacao
				AAdd(aRegA350[nCount],AllTrim(str(nFI_NUMREDZ))	) //09 - N - Posição do Contador de Redução Z
				AAdd(aRegA350[nCount],cFT_NFISCAL				) //10 - N - Numero do documento fiscal
				AAdd(aRegA350[nCount],dFT_EMISSAO				) //11 - N - Data da emissão do documento fiscal
				AAdd(aRegA350[nCount],cFT_CFPS					) //12 - N - Codigo Fiscal de Prestacoes de Servicos, conforme a tabela indicada no item 4.2.3
				AAdd(aRegA350[nCount],nFT_TOTAL					) //13 - N - Valor do documento fiscal
				AAdd(aRegA350[nCount],nISS_CANCEL				) //14 - N - Valor dos cancelamentos referentes ao ISSQN
				AAdd(aRegA350[nCount],nICM_CANCEL				) //15 - N - Valor dos cancelamentos referentes ao ICMS
				AAdd(aRegA350[nCount],nTOTAL_CANC				) //16 - N - Valor dos cancelamentos registrados
				AAdd(aRegA350[nCount],nISS_DESC					) //17 - N - Valor dos descontos referentes ao ISSQN
				AAdd(aRegA350[nCount],nICM_DESC					) //18 - N - Valor dos descontos referentes ao ICMS
				AAdd(aRegA350[nCount],nDESC_TOT					) //19 - N - Valor dos descontos registrados
				AAdd(aRegA350[nCount],0							) //20 - N - Valor dos acréscimos referentes ao ISSQN
				AAdd(aRegA350[nCount],0							) //21 - N - Valor dos acréscimos referentes ao ICMS
				AAdd(aRegA350[nCount],0							) //22 - N - Valor dos acréscimos registrados
				AAdd(aRegA350[nCount],nFT_TOTAL					) //23 - N - Valor da base de calculo do ISSQN
				AAdd(aRegA350[nCount],nISS_VALOR				) //24 - N - Valor do ISSQN
				AAdd(aRegA350[nCount],nISS_ISEN					) //25 - N - Valor das prestacoes isentas do ISSQN
				AAdd(aRegA350[nCount],0							) //26 - N - Valor das prestacoes sob nao-incidencia ou nao-tributadas pelo ISSQN
				AAdd(aRegA350[nCount],nISEN_RET					) //27 - N - Valor das prestacoes com ISSQN retido por substituicao tributaria

				nFT_TOTAL   := 0
				nISS_DESC   := 0
				nICM_DESC   := 0
				nDESC_TOT   := 0
				nISS_TBASE  := 0
				nISS_VALOR  := 0
				nISS_ISEN   := 0
				nISEN_RET   := 0
				nContador   := Len (aRegA350 ) + 1
				nI          := 0
				nFI_PDV     := Val( (cAliasTrb)->FI_PDV )
				nFI_CRO     := Val( (cAliasTrb)->FI_CRO )
				cFI_SERPDV  := (cAliasTrb)->FI_SERPDV
				nFI_NUMREDZ := Val((cAliasTrb)->FI_NUMREDZ )
				cCST_ISS    := (cAliasTrb)->FT_CSTISS
				cCpf  :=   AllTrim(If(lCGCCLI .AND. !Empty((cAliasTrb)->L1_CGCCLI) ,(cAliasTrb)->L1_CGCCLI ,(cAliasTrb)->A1_CGC) )
				cCnpj :=   AllTrim(If(lCGCCLI .AND. !Empty((cAliasTrb)->L1_CGCCLI) ,(cAliasTrb)->L1_CGCCLI ,(cAliasTrb)->A1_CGC) )
				If Len(cCpf) > 11
					cCpf  := ""
				Else
					cCnpj := ""
				EndIf
				cFT_NFISCAL := PadL( AllTrim(STR( Val((cAliasTrb)->FT_NFISCAL ) ) ) ,TamSX3("FT_NFISCAL")[1], "0" )
				cFT_CFPS    := AllTrim(STR(Val((cAliasTrb)->FT_CFPS ) ) )
				nFT_TOTAL   += (cAliasTrb)->FT_VALCONT
				nISS_DESC   += If((cAliasTrb)->FT_TIPO == "S", (cAliasTrb)->FT_DESCONT, 0 )
				nICM_DESC   += If((cAliasTrb)->FT_TIPO == "L", (cAliasTrb)->FT_DESCONT, 0 )
				nDESC_TOT   += (cAliasTrb)->FT_DESCONT
				nISS_TBASE  += If((cAliasTrb)->FT_TIPO == "S", (cAliasTrb)->FT_VALCONT, 0 )
				nISS_VALOR  += If((cAliasTrb)->FT_TIPO == "S", (cAliasTrb)->FT_VALICM , 0 )
				nISS_ISEN   += If((cAliasTrb)->FT_TIPO == "S", (cAliasTrb)->FT_ISENICM, 0 )
				nISEN_RET   += If((cAliasTrb)->FT_TIPO == "S", (cAliasTrb)->FT_ISENRET, 0 )
				cSituaDoc   := RetSitDoc ((cAliasTrb)->FT_TIPO, cAliasTrb)
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Gravacao do REGISTRO A360: ITENS DO DOCUMENTO              ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			nI++
			AADD(aRegA360,{} )
			nC := Len (aRegA360 )

			cVlrunt := ConvNum((cAliasTrb)->L2_PRCTAB , 3 , "0" )
			cQuant  := ConvNum((cAliasTrb)->FT_QUANT  , 3 , "0" )
			AAdd(aRegA360[nC], nContador				) //00 - N - Registro Pai
			AAdd(aRegA360[nC], "A360"					) //01 - C - Texto Fixo do registro
			AAdd(aRegA360[nC], AllTrim(Str(nI ))		) //02 - N - Número seqüencial do item no documento fiscal
			AAdd(aRegA360[nC], (cAliasTrb)->FT_PRODUTO	) //03 - C - Codigo do item (campo 02 do Registro 0200)
			AAdd(aRegA360[nC], cVlrunt					) //04 - N - Valor unitario
			AAdd(aRegA360[nC], cQuant					) //05 - C - Quantidade do item
			AAdd(aRegA360[nC], 0						) //06 - N - Quantidade cancelada, no caso de cancelamento parcial de item
			AAdd(aRegA360[nC], (cAliasTrb)->B1_UM		) //07 - N - Unidade do item
			AAdd(aRegA360[nC], (cAliasTrb)->FT_VALCONT	) //08 - N - Valor do item
			AAdd(aRegA360[nC], (cAliasTrb)->FT_DESCONT	) //09 - N - Valor do desconto
			AAdd(aRegA360[nC], 0						) //10 - N - Valor cancelado, no caso de cancelamento parcial de item
			AAdd(aRegA360[nC], 0						) //11 - N - Valor do acréscimo
			AAdd(aRegA360[nC], cCST_ISS					) //12 - N - Codigo de Tributacao do ISSQN, conforme a tabela indicada no item 4.3.3
			AAdd(aRegA360[nC], (cAliasTrb)->FT_BASEICM	) //13 - N - Valor da base de calculo do ISSQN
			AAdd(aRegA360[nC], (cAliasTrb)->FT_ALIQICM	) //14 - N - Aliquota do ISSQN
			AAdd(aRegA360[nC], (cAliasTrb)->FT_VALICM	) //15 - N - Valor do ISSQN
			AAdd(aRegA360[nC], (cAliasTrb)->FT_ISENICM	) //16 - N - Valor da prestacao isenta do ISSQN
			AAdd(aRegA360[nC], (cAliasTrb)->FT_ISENRET	) //17 - N - Valor da prestacoo sob nao-incidencia ou nao-tributada pelo ISSQN
			AAdd(aRegA360[nC], 0						) //18 - N - Valor dos acréscimos referentes ao ISSQN

			//so ira gerar se tiver o A360
			cCODGEN := Iif ( Empty((cAliasTrb)->B1_CODISS), Left ((cAliasTrb)->B1_POSIPI, 2), "00" )
			AADD(aReg0200,{})
			nP :=Len(aReg0200)
			AAdd(aReg0200[nP], (cAliasTrb)->FT_PRODUTO	)
			AAdd(aReg0200[nP], (cAliasTrb)->B1_DESC		)
			AAdd(aReg0200[nP], cCODGEN					)
			AAdd(aReg0200[nP], (cAliasTrb)->B1_CODISS	)
		EndIf
		cChave := (cAliasTrb)->FT_FILIAL + (cAliasTrb)->FT_NFISCAL + (cAliasTrb)->FT_SERIE
		(cAliasTrb)->(DbSkip())

	EndDo
	If Len(aRegA360) > 0 .AND. aRegA360[Len(aRegA360)][1] == Len(aRegA350) + 1
		AADD(aRegA350,{})
		nCount := Len (aRegA350)
		AAdd(aRegA350[nCount], "A350"					) //01 - C - Texto Fixo do registro
		AAdd(aRegA350[nCount], cCpf						) //02 - N - Numero de inscricao do tomador do servico no CPF
		AAdd(aRegA350[nCount], cCnpj					) //03 - N - Numero de inscricao do tomador do servico no CNPJ
		AAdd(aRegA350[nCount], "2D"						) //04 - C - Tabela 4.1.1 Tipo - Cupom Fiscal emitido por ECF
		AAdd(aRegA350[nCount], cSituaDoc				) //05 - N - tabela 4.1.3 Tipo - Documento regular
		AAdd(aRegA350[nCount],AllTrim(str(nFI_PDV))		) //06 - N - Numero do caixa atribuído ao ECF
		AAdd(aRegA350[nCount],cFI_SERPDV				) //07 - C - Numero de serie de fabricacao do ECF
		AAdd(aRegA350[nCount],AllTrim(str(nFI_CRO))		) //08 - N - Posicao do Contador de Reinicio de Operacao
		AAdd(aRegA350[nCount],AllTrim(str(nFI_NUMREDZ))	) //09 - N - Posição do Contador de Redução Z
		AAdd(aRegA350[nCount],cFT_NFISCAL				) //10 - N - Numero do documento fiscal
		AAdd(aRegA350[nCount],dFT_EMISSAO				) //11 - N - Data da emissão do documento fiscal
		AAdd(aRegA350[nCount],cFT_CFPS					) //12 - N - Codigo Fiscal de Prestacoes de Servicos, conforme a tabela indicada no item 4.2.3
		AAdd(aRegA350[nCount],nFT_TOTAL					) //13 - N - Valor do documento fiscal
		AAdd(aRegA350[nCount],nISS_CANCEL				) //14 - N - Valor dos cancelamentos referentes ao ISSQN
		AAdd(aRegA350[nCount],nICM_CANCEL				) //15 - N - Valor dos cancelamentos referentes ao ICMS
		AAdd(aRegA350[nCount],nTOTAL_CANC				) //16 - N - Valor dos cancelamentos registrados
		AAdd(aRegA350[nCount],nISS_DESC					) //17 - N - Valor dos descontos referentes ao ISSQN
		AAdd(aRegA350[nCount],nICM_DESC					) //18 - N - Valor dos descontos referentes ao ICMS
		AAdd(aRegA350[nCount],nDESC_TOT					) //19 - N - Valor dos descontos registrados
		AAdd(aRegA350[nCount],0							) //20 - N - Valor dos acréscimos referentes ao ISSQN
		AAdd(aRegA350[nCount],0							) //21 - N - Valor dos acréscimos referentes ao ICMS
		AAdd(aRegA350[nCount],0							) //22 - N - Valor dos acréscimos registrados
		AAdd(aRegA350[nCount],nISS_ISEN					) //23 - N - Valor da base de calculo do ISSQN
		AAdd(aRegA350[nCount],nISS_VALOR				) //24 - N - Valor do ISSQN
		AAdd(aRegA350[nCount],nISS_ISEN					) //25 - N - Valor das prestacoes isentas do ISSQN
		AAdd(aRegA350[nCount],0							) //26 - N - Valor das prestacoes sob nao-incidencia ou nao-tributadas pelo ISSQN
		AAdd(aRegA350[nCount],nISEN_RET					) //27 - N - Valor das prestacoes com ISSQN retido por substituicao tributaria
	EndIf

	PRD->(DbGoTop())
	For nP := 1 To Len(aReg0200)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Gerando REGISTRO 0200 - TABELA DE IDENTIFICACAO DO ITEM    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !PRD->(DbSeek(aReg0200[nP][1] ) ) .AND. !Empty(AllTrim(aReg0200[nP][1]))
			RecLock ("PRD", .T.)
			PRD->PRD_CODITE := aReg0200[nP][1]
			PRD->PRD_DESC   := aReg0200[nP][2]
			PRD->PRD_CODGEN := aReg0200[nP][3]
			PRD->PRD_CODLST := aReg0200[nP][4]
			PRD->(MsUnLock() )
		EndIf
	Next nP
	(cAliasTrb)->(DbCloseArea())
EndIf
#ENDIF
RestArea(aArea)
Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |RegA350   ³ Autor ³ Vendas CRM            ³ Data ³08/04/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Grava o Registro A350 e o Registro A360                    |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|PARAM01 - Tipo de Documento conforme tabela item 4.1.1      ³±±
±±³          |PARAM02 - Data inicial para a geracao do arquivo do Cotepe  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RegA350 (cAlias,aRegA350, aRegA360 )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Gerando REGISTRO A350: DOCUMENTO - CUPOM FISCAL/ISSQN      ³
//³Gerando REGISTRO A360: ITENS DO DOCUMENTO                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If Len(aRegA350) > 0  .AND. Len(aRegA360) > 0
	GrRegDep (cAlias, aRegA350 , aRegA360)
EndIf

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |RegA350   ³ Autor ³ Vendas CRM            ³ Data ³08/04/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao para Auxiliar a formatacao da qunatidades  de       |±±
±±³          ³ Decimais                                                   |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|PARAM01 - Valor a ser alterado                              ³±±
±±³          |PARAM02 - Quantidade de decimais a ser adicionada           ³±±
±±³          |PARAM03 - Caracter de preenchimento                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static function ConvNum(nVal, nDec ,cTip)
Local cRet    := "" // Valor alterado com as quantidades de casas decimais
Local cRetAux := ""  //Variavel auxiliar 

Default nVal := 0
Default nDec := 0
Default cTip := ""
cRetAux  := Alltrim(Str(nVal))

If nVal = 0 .OR. nDec = 0  .OR. cTip = ""
	cRet := cRetAux
	Return (cRet)
EndIf

//Verifica se existe casas decimais no Valor
If At("." , Alltrim(Str(nVal)) ) > 0
	cRet := SubStr( cRetAux , 1 , At("." , cRetAux )- 1 ) + "," + Padr( SubStr( cRetAux , At("." , cRetAux ) +1, Len(cRetAux ) ) , nDec ,cTip )
Else
	cRet := SubStr( cRetAux , 1 , Len(cRetAux ) ) + "," + Padr(cTip, nDec ,cTip )
EndIf
Return(cRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |Reg600VlPrd³ Autor ³ Vendas CRM            ³ Data ³08/04/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica se sera gerado registro para esse produto          |±±
±±³          ³                                                             |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Verdadeiro ou Falso                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|PARAM01 - CGC ou CPF do cliente                              ³±±
±±³          |PARAM02 - indica se eh "S" servico ou "L" produto            ³±±
±±³          |PARAM03 - Array com as vendas que nao serao contabilizadas   ³±±
±±³          |PARAM04 - Data inicial                                       ³±±
±±³          |PARAM05 - Data final                                         ³±±
±±³          |PARAM06 - Tablela do SFT                                     ³±±
±±³          |PARAM07 - Filial inicial                                     ³±±
±±³          |PARAM08 - Filial Final                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function Reg600VlPrd(cServ,aReg02Aux,dDataDe,dDataAte,aAliasSFT,cFilDe,cFilAte)

Local lRet        := .F.
Local aArea       := GetArea()
Local cQuery      := ""
Local cAliasTrb   := ""
Local cCampos     := ""
Local cFilSB1     := If(!Empty(AllTrim(xFilial("SB1"))),"SB1.B1_FILIAL = SFT.FT_FILIAL AND ","")
Local cVerCamp    := ""
Local aRegAux     := {}

cVerCamp := aAliasSFT[1] + aAliasSFT[2] + aAliasSFT[3]

//-- Campo B1_CRNFLG (updloj57) - Adesao a nota fiscal legal (NAO ESTA NO ATUSX)
If SB1->(FieldPos("B1_CRNFLG")) > 0
	If Len(aReg02Aux) == 0
		cQuery := "SELECT SFT.FT_FILIAL,SFT.FT_NFISCAL,SFT.FT_SERIE,SFT.FT_TIPO,SB1.B1_CRNFLG FROM " + RetSQLTab('SFT') 
		cQuery += " LEFT JOIN " + RetSQLTab('SB1') + " ON " + cFilSB1 + "B1_COD = FT_PRODUTO "
		cQuery += " WHERE SB1.B1_CRNFLG <> '2' AND SFT.FT_FILIAL BETWEEN '" + cFilDe + "' AND '" + cFilAte + "' AND "
		cQuery += " SFT.FT_EMISSAO BETWEEN '" + DtoS(dDataDe) + "' AND '" + DtoS(dDataAte) + "'"
		cAliasTrb := GetNextAlias()
		cQuery    := ChangeQuery( cQuery )
		DbUseArea( .T., 'TOPCONN', TcGenQry(,,cQuery), cAliasTrb, .T., .F. )
		aReg02Aux := {{} , {} }
		(cAliasTrb)->(DbGoTop() )
		While !(cAliasTrb)->( Eof() )
			If (cAliasTrb)->FT_TIPO <> "S"
				cCampos := (cAliasTrb)->FT_FILIAL + (cAliasTrb)->FT_NFISCAL + (cAliasTrb)->FT_SERIE
				AAdd(aReg02Aux[1], cCampos )
			Else
				cCampos := (cAliasTrb)->FT_FILIAL + (cAliasTrb)->FT_NFISCAL + (cAliasTrb)->FT_SERIE
				AAdd(aReg02Aux[2], cCampos )
			EndIf
			(cAliasTrb)->(DbSkip())
		EndDo
		(cAliasTrb)->(DbCloseArea())
	EndIf
	If cServ <> "S"
		aRegAux := aClone(aReg02Aux[1] )
	Else
		aRegAux := aClone(aReg02Aux[2] )
	EndIf
	If aScan(aRegAux, bSeek := {|x| x == cVerCamp}) > 0
		lRet := .T.
	EndIf
Else
	lRet := .T.
EndIf
RestArea(aArea)
Return(lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |Reg600VlPrd³ Autor ³ Vendas CRM            ³ Data ³08/04/2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica se sera gerado registro para esse produto          |±±
±±³          ³                                                             |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Verdadeiro ou Falso                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|PARAM01 - Tablela do SFT                                     ³±±
±±³          |PARAM02 - Array com as vendas que nao serao contabilizadas   ³±±
±±³          |PARAM03 - Data inicial                                       ³±±
±±³          |PARAM04 - Data final                                         ³±±
±±³          |PARAM05 - Filial inicial                                     ³±±
±±³          |PARAM06 - Filial Final                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function LojVerProd(cAliasSFT,aReg02Aux,dDataDe,dDataAte,cFilDe,cFilAte)
Local lRet := .T.
Local aAliasSFT := {(cAliasSFT)->FT_FILIAL,(cAliasSFT)->FT_NFISCAL,(cAliasSFT)->FT_SERIE}

lRet := Reg600VlPrd((cAliasSFT)->FT_TIPO,aReg02Aux,dDataDe,dDataAte,aAliasSFT,cFilDe,cFilAte)

Return(lRet)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |GrRegDep  ³ Autor ³Totvs                  ³ Data ³16.03.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³              GRAVO REGISTROS DEPENDENTES                   ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Suponhamos o cabecalho e os itens do documento fiscal, onde ³±±
±±³          ³ o cabecalho eh o pai e os itens eh o filho, portanto tenho ³±±
±±³          ³ varios itens para um pai. Para que esta funcao interprete  ³±±
±±³          ³ este caso, a primeira posicao do registro filho indica a   ³±±
±±³          ³ posicao do registro pai, ou seja, leio a primeira posicao  ³±±
±±³          ³ do array pai e procuro todos os registros itens que possuem³±±
±±³          ³ na primeira posicao a posicao lida do registro pai.        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³lRet -> .T.                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cAlias -> Alias do TRB criado atraves da funcao principal.  ³±±
±±³          |aRegPai -> Registro Pai.                                    ³±±
±±³          |aRegFilho -> Registro tipo filho (1:N) Varios para cada Pai.³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function GrRegDepC(cAlias,aRegPai,aRegFilho,lRegPaiDup,nRegEcf,lCtdtem,nFlag,lOrdena,cMensagem,lOrdPai)
Local	aReg		:= {}
Local	nCtd		:= 1
Local	nZ			:= 0
Local	nX			:= 0
Local	bRblSort	:= ""
Local	bRblSortP	:= ""
Local	nPos		:= 0
Local	nPosPai		:= 24 //Posicao registro E080
Local	nPosFil		:= 18 //Posicao registro E085
Local	nBasICMS	:= 0
Local	nIseICMS	:= 0

DEFAULT lRegPaiDup	:= .F.
DEFAULT nRegEcf		:= 0
DEFAULT lCtdtem		:= .T.	//Tratamento para quando se tem mais de uma ocorrencia no subnivel. Ex. Registro 1100, 1105 e 1110
DEFAULT nFlag		:= Nil
DEFAULT lOrdena		:= .T.
DEFAULT cMensagem	:= ""
DEFAULT lOrdPai		:= .F.

If !Len(aRegPai)>0
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratamento incluido para ordenacao dos registros E080/E085, como a query principal             ³
//³nao ordena os registros por data de emissao este tratamento eh necessario para impor esta ordem³
//³e gerar o arquivo corretamente                                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//Registro 060/065
If aRegPai[1][1]=="E060"
	nPosPai		:= 30
	nPosFil		:= 16
	bRblSort	:= { |x,y|  x[2] + strzero(x[1],5) < y[2] + strzero(y[1],5) }
	bRblSortP	:= { |x,y| (DtoS(x[7]) + x[3] + x[4]) < (DtoS(y[7]) + y[3] + y[4]) }
Else
	bRblSort	:= { |x,y|  x[1] < y[1] }
	bRblSortP	:= { |x,y| (DtoS(x[5]) + x[3] ) < (DtoS(y[5]) + y[3]) }
Endif

If lOrdPai
	aRegFilho  := Asort(aRegFilho,,,{ |x,y|  x[nPosFil] < y[nPosFil] })
	aRegPai    := Asort(aRegPai,,,bRblSortP)
	For nX:=1 To Len(aRegPai)
		If (nPos := Ascan(aRegFilho,{|x| x[nPosFil] == aRegPai[nX][nPosPai] })) > 0
			nBasICMS := 0
			nIseICMS := 0
			While aRegFilho[nPos][nPosFil] == aRegPai[nX][nPosPai]
				//Totalizar corretamente o registro E060
				If aRegFilho[nPos][2]=="E065"
					nIseICMS += aRegFilho[nPos][13]
				Endif
				//Totalizar corretamente o registro E080
				If aRegFilho[nPos][2]=="E085"
					nBasICMS += aRegFilho[nPos][12]
				Endif
				aRegFilho[nPos][1] := nX
				nPos++
				If nPos > Len(aRegFilho)
					Exit
				EndIf
			EndDo
			//Move o novo valor para o registro E060
			If aRegPai[nX][1]=="E060"
				aRegPai[nX][26] := nIseICMS
			Endif
			//Move o novo valor para o registro E080
			If aRegPai[nX][1]=="E080"
				aRegPai[nX][18] := nBasICMS
			Endif
		EndIf
		aDel(aRegPai[nX], nPosPai)
		aSize(aRegPai[nX],Len(aRegPai[nX]) - 1)
	Next
	For nz:= 1 To Len(aRegFilho)
		aDel(aRegFilho[nz], nPosFil)
		aSize(aRegFilho[nz],Len(aRegFilho[nz]) - 1)
	Next
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se o registro PAI tiver somente 1 item, nao precisa ordenar, pois o filho somente terah ³
//³ um codigo de relacionamento, o que corresponde ao PAI                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lOrdena
	aRegFilho  := Asort(aRegFilho,,,bRblSort)
EndIf

For nZ := 1 To Len(aRegPai)
	If !lRegPaiDup
		GrvRegTrSC(cAlias,nZ,{aRegPai[nZ]},,nFlag)
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³nCod e a posicao lida do C420(Cabecalho) que se relaciona com o conteudo da posicao 1 do array c425(Itens)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len(aRegFilho)>=1  .AND. nCtd <= Len(aRegFilho)
		Do While nCtd<=Len (aRegFilho) .And. (aRegFilho[nCtd][1]==nZ)
			aReg	:=	{}
			For nX := 2 To Len (aRegFilho[nCtd])
				aAdd (aReg, aRegFilho[nCtd][nX])
			Next (nX)
			GrvRegTrSC(cAlias,nZ,{aReg},Iif(lCtdtem,nCtd,aRegFilho[nCtd][1]),nFlag)
			nCtd++
		EndDo
	EndIf
Next (nZ)

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |GrvRegTrS ³ Autor ³Totvs                  ³ Data ³16.03.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³              GRAVACAO DO REGISTRO NO TRB                   ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Gravacao do registro passado como parametro (aReg) no TRB   ³±±
±±³          ³ que sera posteiormente lido e gerado o TXT.                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³lRet -> .T.                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cAlias -> Alias do TRB gerado na funcao principal           ³±±
±±³          ³nRelac -> Codigo de indicacao de relacionamento com outros  ³±±
±±³          ³ registros.                                                 ³±±
±±³          ³aReg -> Registro a ser gravado no TRB.                      ³±±
±±³          ³nItem -> Identificador de itens para um mesmo relacionamento³±±
±±³          ³nFlag -> Flag de controle de grupo que antecede o           ³±±
±±³          ³ relacionamento entre registros. Ex:                        ³±±
±±³          ³ Se o FLAG nao for passado o codigo fica ...2...2, se for   ³±±
±±³          ³ passado por exemplo 3, o codigo fiscal ...3...2            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Function GrvRegTrSC(cAlias,nRelac,aReg,nItem,nFlag)
Local	nX			:=	0
Local	lRet		:=	.T.
Local	cDelimit	:=	"|"
Local	nZ			:=	0
Local	cLinha		:=	""
Local	cReg		:=	""
Local	nTamTRBIt	:=	Len((cAlias)->TRB_RELAC)/2	//Efetuo divisao por dois porque faco dois controles em um mesmo campo. O relacionamento e sequencia. Ex: ...0001...1, ...0001...2

Default	nRelac	:=	0
Default	nFlag	:=	Nil

If nFlag==Nil
	cFlag	:=	Iif(Valtype(nRelac)=="N",StrZero (nRelac, nTamTRBIt, 0),nRelac)
Else
	cFlag	:=	StrZero (nFlag, nTamTRBIt, 0)
EndIf

For nZ := 1 To Len (aReg)
	cLinha	:=	cDelimit
	//
	//Monto cLinha para gravar no TRB
	For nX := 1 To Len (aReg[nZ])
		If (ValType (aReg[nZ][nX])="A")
			cLinha	+=	RetStr (aReg[nZ][nX][1], aReg[nZ][nX][2])+cDelimit
		Else
			cLinha	+=	RetStr (aReg[nZ][nX])+cDelimit
		EndIf
	Next (nX)

	cReg := SubStr (cLinha, 2, 4)

	//Tratamento para nao permitir gerar uma string maior que o tamanho do campo TRB_CONT. Se acontecer, somente serah no registro 0450.
	If Len(cLinha)>Len((cAlias)->TRB_CONT)
		cLinha	:=	AllTrim(Left(cLinha,Len((cAlias)->TRB_CONT)-1))+cDelimit
	EndIf
	//
	//Monto TRB
	RecLock (cAlias, .T.)
		(cAlias)->TRB_TPREG := cReg
		(cAlias)->TRB_RELAC := cFlag+Iif(Valtype(nRelac)=="N",StrZero (nRelac, nTamTRBIt, 0),nRelac)
		(cAlias)->TRB_CONT  := cLinha
		(cAlias)->TRB_ITEM  := nItem
	MsUnLock ()
Next nZ
Return(lRet)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |ApuICMSCDH³ Autor ³Mauro A. Goncalves     ³ Data ³12.09.2012³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Le a tabela CDH apuracao de icms quando MV_USASPED=.T.      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cTabela -> Para uso em DBF                                  ³±±
±±³          ³cAlias  -> Para uso no select                               ³±±
±±³          ³aPar    -> Parametros para selecao                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ApuICMSCDH(cTabela,cAlias,aPar)
Local nIndex	:= 1
Local cFiltro	:= ""
Local cSelect	:= ""
Local cFrom		:= ""
Local cWhere	:= ""

	DbSelectArea("CDH")
	CDH->(DbSetOrder(1))

	#IFDEF TOP
		If (TcSrvType()<>"AS/400")
			cSelect:= "%A.*, B.CDO_DESCR2%"
			cFrom  := "%"+RetSqlName("CDH")+" A "
			cFrom  += " LEFT JOIN "+RetSqlName("CDO")+" B ON B.CDO_FILIAL='"+xFilial("CDO")+"' AND A.CDH_CODLAN=B.CDO_CODAJU AND B.D_E_L_E_T_=' '%"
			cWhere := "%A.CDH_FILIAL='"+xFilial("CDH")+"' AND "
			cWhere += "A.CDH_TIPOIP='"+aPar[1]+"' AND "
			cWhere += "A.CDH_TIPOPR='"+aPar[2]+"' AND "
			cWhere += "A.CDH_PERIOD='"+aPar[3]+"' AND "
			cWhere += "A.CDH_DTFIM='"+aPar[4]+"' AND "
			cWhere += "A.CDH_LIVRO='"+aPar[5]+"' AND "
			cWhere += "A.CDH_SEQUEN=(SELECT MAX(CDH_SEQUEN) FROM "+RetSqlName("CDH")+" WHERE CDH_FILIAL=A.CDH_FILIAL AND CDH_TIPOIP=A.CDH_TIPOIP AND CDH_TIPOPR=A.CDH_TIPOPR AND CDH_PERIOD=A.CDH_PERIOD AND CDH_DTINI=A.CDH_DTINI AND CDH_LIVRO=A.CDH_LIVRO AND D_E_L_E_T_='') AND "
			cWhere += "A.D_E_L_E_T_=''%"

			cAlias := GetNextAlias()

			BeginSql Alias cAlias
				SELECT
					%Exp:cSelect%
				FROM
					%Exp:cFrom%
				WHERE
					%Exp:cWhere%
			EndSql
		Else
	#ENDIF
			cFiltro := "CDH_FILIAL=='"+xFilial("CDH")+"' .AND. "
			cFiltro += "CDH_TIPOIP=='"+aPar[1]+"' .AND. "
			cFiltro += "CDH_TIPOPR=='"+aPar[2]+"' .AND. "
			cFiltro += "CDH_PERIOD=='"+aPar[3]+"' .AND. "
			cFiltro += "DToS(CDH_DTFIM)=='"+aPar[4]+"' .AND. "
			cFiltro += "CDH_LIVRO=='"+aPar[5]

			cIndex  := CriaTrab(Nil,.F.)
			cTabela := SubStr(cTabela,1,3)

			IndRegua (cAlias,cIndex,CDH->(IndexKey()),,cFiltro,"Selecionando Registros",.F.)
			nIndex := RetIndex(cAlias)

			DbSelectArea(cAlias)
			(cAlias)->(DbGoTop())
	#IFDEF TOP
		EndIf
	#ENDIF
Return(.T.)

/*
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Programa  |OrgSort450³ Autor ³Telso Carneiro         ³ Data ³14/10/2013³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡…o ³Organiza o registro 0450 em ordem crescente para impressao  ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Retorno   ³NIL                                                         ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³Parametros|cAlias  -> Para uso no select                               ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
Static Function OrgSort450(cAlias)
Local aOrg450 := {}
Local aOrg455 := {}
Local aOrg460 := {}
Local aOrg465 := {}
Local c0450   := "0450"
Local c0455   := "0455"
Local c0460   := "0460"
Local c0465   := "0465"
Local nrelac	:= ""
Local nI := 0
Local nA := 0

If ((cAlias)->(DbSeek (c0450)))
	While !(cAlias)->(Eof ()) .And. c0450==(cAlias)->TRB_TPREG
		Aadd(aOrg450, {TRB_CONT,(cAlias)->(RECNO())})
		(cAlias)->(DbSkip ())
	EndDo
EndIf

If ((cAlias)->(DbSeek (c0455)))
	While !(cAlias)->(Eof ()) .And. c0450==(cAlias)->TRB_TPREG
		Aadd(aOrg455, {TRB_CONT,TRB_RELAC,(cAlias)->(RECNO())})
		(cAlias)->(DbSkip ())
	EndDo
EndIf

If ((cAlias)->(DbSeek (c0460)))
	While !(cAlias)->(Eof ()) .And. c0460==(cAlias)->TRB_TPREG
		Aadd(aOrg460, {TRB_CONT,TRB_RELAC,(cAlias)->(RECNO())})
		(cAlias)->(DbSkip ())
	EndDo
EndIf

If ((cAlias)->(DbSeek (c0465)))
	While !(cAlias)->(Eof ()) .And. c0465==(cAlias)->TRB_TPREG
		Aadd(aOrg465, {TRB_CONT,TRB_RELAC,(cAlias)->(RECNO())})
		(cAlias)->(DbSkip ())
	EndDo
EndIf

If Len(aOrg450) > 0
	//alimento primeiro com a ordem correta
	For nI:= 1 To Len(aOrg450)
		(cAlias)->(DbGoto(aOrg450[nI,2]))
		RecLock(cAlias,.F.)
		TRB_RELAC := StrZero(nI, 9, 0)
		MsUnLock()
	Next

	aSort(aOrg450,,,{|x,y| x[1]<y[1] })
	For nI:= 1 To Len(aOrg450)
		(cAlias)->(DbGoto(aOrg450[nI,2]))
		cRelac	:=	(cAlias)->TRB_RELAC
		
		For nA :=1 to Len(aOrg455)
			If cRelac ==aOrg455[nA,2]
				(cAlias)->(DbGoto(aOrg455[nA,3]))	
				RecLock(cAlias,.F.)
				TRB_RELAC := StrZero(nI, 9, 0)
				MsUnLock()
			EndIf
		Next	
		For nA :=1 to Len(aOrg460)
			If cRelac ==aOrg460[nA,2]
				(cAlias)->(DbGoto(aOrg460[nA,3]))	
				RecLock(cAlias,.F.)
				TRB_RELAC := StrZero(nI, 9, 0)
				MsUnLock()
			EndIf
		Next	
		For nA :=1 to Len(aOrg465)
			If cRelac ==aOrg465[nA,2]
				(cAlias)->(DbGoto(aOrg465[nA,3]))	
				RecLock(cAlias,.F.)
				TRB_RELAC := StrZero(nI, 9, 0)
				MsUnLock()
			EndIf
		Next			
		
		(cAlias)->(DbGoto(aOrg450[nI,2]))		
		RecLock(cAlias,.F.)
		TRB_RELAC := StrZero(nI, 9, 0)
		MsUnLock()
	Next	
EndIf

Return(NiL)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ PAFCot35 ³ Autor ³Gustavo Rueda/Liber Esteban ³ 28/08/2006 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Preparacao do meio-magnetico para atender a exigencia do    ³±±
±±³          ³ Ato Cotepe 35 de 17/06/2005. DOU(13/07/2005)               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Funcao principal de processamento. Esta funcao tem como     ³±±
±±³          ³ objetivo filtrar a tabela SFT(Livros Fiscais por item) e   ³±±
±±³          ³ montar os registros necessarios atraves de funcoes auxilia-³±±
±±³          ³ res.                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³aWizard -> Array com parametros informados pelo usuario no  ³±±
±±³          ³Wizard de configuracao do meio magnetico                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function PAFCot35(lEnd, aWizard, cFileDest, aFiliais, lJob)
Local cPerg				:= PadR("COTEPE",Len(SX1->X1_GRUPO))   //Grupo de Perguntas  

Default lEnd			:= .F.  //Endereço do arquivo
Default aWizard			:= {}   //Wizard
Default cFileDest		:= "COTEPE35.TXT"	//Conteudo Atualizado na funcao PrCotepe 
Default aFiliais		:= {}  //Filiais
Default lJob			:= .F. //Job
	
	Pergunte(cPerg, .F.)
	mv_par01 := 2
	mv_par02 := 2
	mv_par03 := 1
	
	PrCotepe(@lEnd, aWizard, @cFileDest,aFiliais, lJob)
	
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |RegB475   ³ Autor ³ Cleber Maldonado      ³ Data ³31/02/2014³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³     B475 - RELATÓRIO DOS VALORES A RECOLHER POR FILIAL     ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao do Registro B475                                  |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoe contidas no array    ³±±
±±³          ³ aCmpAntSFT e na tabela SFT.                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³B475 - 4( 1:N )                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cAliasSFT -> Alias da tabela SFT aberta no momento.         ³±±
±±³          ³ funcao a ser retornado para gravacao pela funcao principal.³±±
±±³          |aRegB475 -> Array contendo as informacoes processadas pela  ³±±
±±³          ³ funcao a ser retornado para gravacao pela funcao principal.³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RegB475(cAliasSFT, cEntSai, aRegB475, cSituaDoc, aPartDoc, lIssRet)

Local nPos    := 0
Local cCodfil := "SM0"+SM0->(M0_CODIGO+M0_CODFIL)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³REGISTRO B475 - VALORES A RECOLHER POR FILIAL   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ((nPos := aScan (aRegB475, {|aX| aX[2]==cCodFil}))==0)
	IIF(nPos == 0,nPos := (nPos + 1),nPos)
	aAdd(aRegB475, {})
	nPos	:=	Len(aRegB475)
	aAdd(aRegB475[nPos], "B475")							// 01 - REG
	aAdd(aRegB475[nPos], "SM0"+SM0->(M0_CODIGO+M0_CODFIL))	// 02 - COD_PART
	If lIssRet
		aAdd(aRegB475[nPos], (cAliasSFT)->FT_VALICM)		// 03 - VL_FIL
	Else
		aAdd(aRegB475[nPos], 0 )
	Endif
	/*If lIssRet - aguardando a liberacao do validador
		aAdd(aRegB475[nPos], (cAliasSFT)->FT_VALICM)		// 04 - VL_ ISS_ST
	Else
		aAdd(aRegB475[nPos], 0 )
	EndIf
	*/
	// Carrego dados da filial no array e gero um registro 0150
	aSM0Fil := InfPartDoc ("", {}, {},.T.,"")
	Reg0150 (aSM0Fil)
Else
	If lIssRet
		aRegB475[nPos][3] += (cAliasSFT)->FT_VALICM			// 03 - VL_FIL
	EndIf
	/*If lIssRet - aguardando a liberacao do validador
		aRegB475[nPos][4] += (cAliasSFT)->FT_VALICM			// 04 - VL_ISS_ST
	Endif
	*/
Endif	
Return (.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  |RegB480   ³ Autor ³ Cleber Maldonado      ³ Data ³31/02/2014³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±³          ³     B480 - OBRIGAÇÕES A RECOLHER POR MUNICÍPIO             ³±±
±±³          ³                                                            ³±±
±±³          ³- Geracao do Registro B480                                  |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoe contidas no array    ³±±
±±³          ³ aCmpAntSFT e na tabela SFT.                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³B480 - 4( 1:N )                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros|cAliasSFT -> Alias da tabela SFT aberta no momento.         ³±±
±±³          ³ funcao a ser retornado para gravacao pela funcao principal.³±±
±±³          |aRegB480 -> Array contendo as informacoes processadas pela  ³±±
±±³          ³ funcao a ser retornado para gravacao pela funcao principal.³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RegB480(cAliasSFT, cEntSai, aRegB480, cSituaDoc, aPartDoc, lIssRet, cMunSgmt, cB1MepLes)

Local	nPos	:= 0
Local cMunRecIss := ""

// Regra B1_MEPLES p/ definicao do municipio no qual o ISS é devido:
// 1-EP: ISS devido no municipio do ESTABELECIMENTO PRESTADOR (SIGAMAT).
// 2-LES ou Branco: ISS devido no Local de Execucao do servico (Municipio do TOMADOR).
If cB1MepLes == "1"
	cMunRecIss := cMunSgmt
Else
	cMunRecIss := aPartDoc[11]
EndIf

// Regra do validador:
// A somatoria dos registros B480 deve corresponder ao campo 16 do registro B470 - 
// "Valor total apurado do ISSQN a recolher para outros municípios".
// Portanto, nao gerar o registro B480 se nao houver ISS devido em outros municipios.
If cMunRecIss <> cMunSgmt

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³REGISTRO B480 - TOTALIZACAO POR MUNICIPIO   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ((nPos := aScan (aRegB480, {|aX| aX[2]==(cAliasSFT)->FT_ALIQICM .AND. aX[4]==cMunRecIss}))==0)
		aAdd(aRegB480, {})
		nPos	:=	Len(aRegB480)
		aAdd(aRegB480[nPos], "B480")										//01 - REG
		aAdd(aRegB480[nPos], (cAliasSFT)->FT_ALIQICM)						//02 - ALIQ_ISS
		// Se houve retencao o responsavel pelo recolhimento eh o tomador do servico,
		// logo nao posso considerar o valor de ISS como "devido" nestes casos.
		aAdd(aRegB480[nPos], Iif(lIssRet, 0, (cAliasSFT)->FT_VALICM))	//03 - VL_MUN
		aAdd(aRegB480[nPos], cMunRecIss)									//04 - COD_MUN
	Else
		aRegB480[nPos][3] += IIf(lIssRet, 0, (cAliasSFT)->FT_VALICM)	//03 - VL_MUN
	EndIf

EndIf

Return (.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Programa | RegB350  ³ Autor ³ Cleber Maldonado      ³ Data ³ 31/02/2014        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                                     ³±±
±±³          ³ B350 - LANÇAMENTO - SERVIÇOS PRESTADOS POR INSTITUIÇÕES FINANCEIRAS ³±±
±±³          ³                                                                     ³±±
±±³          ³ - Geracao do Registro B350                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves da função³±±
±±³          ³ GrvRegTrb com as informacoe contidas no array aCmpAntSFT e na tabela³±±
±±³          ³ SFT.                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³B350 - 2 ( 1:N )                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAliasSFT -> Alias da tabela SFT aberta no momento.                  ³±±
±±³          ³ funcao a ser retornado para gravacao pela funcao principal.         ³±±
±±³          ³aRegB480 -> Array contendo as informacoes processadas pela           ³±±
±±³          ³ funcao a ser retornado para gravacao pela funcao principal.         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RegB350(cAliasSFT, aWizard, aRegB350, cSituaDoc, aPartDoc, lIssRet)

Local nPos     := 0
Local cDescCTA := ""
Local cCtaRef  := ""
Local aArea    := GetArea()
Local cDataDe  := aWizard[1][1]
Local cCodObs  := "" //(cAliasSFT)->FT_FILIAL+(cAliasSFT)->FT_TIPOMOV+(cAliasSFT)->FT_SERIE+(cAliasSFT)->FT_NFISCAL+(cAliasSFT)->FT_CLIEFOR+(cAliasSFT)->FT_LOJA

// Procuro a conta do plano de contas referencial - COSIF
dbSelectArea("CVD")
dbSetOrder(1)
If MsSeek(xFilial("CVD")+(cAliasSFT)->FT_CONTA)
	cCtaRef := CVD->CVD_CTAREF
Endif
dbSelectArea("CT1")
dbSetOrder(1)
If MsSeek(xFilial("CT1")+(cAliasSFT)->FT_CONTA)
	cDescCTA := CT1->CT1_DESC01
Endif

If SUBSTRING((cAliasSFT)->FT_CFOP,1,1)$"5|6|7"
	If ((nPos := aScan (aRegB350, {|aX| aX[3]==(cAliasSFT)->FT_CONTA}))==0)
		aAdd(aRegB350, {})
		nPos := Len(aRegB350)
		IIF(nPos == 0,nPos := (nPos + 1),nPos)
		aAdd(aRegB350[nPos], "B350")									//01 - REG
		aAdd(aRegB350[nPos], Substr(cDataDe,5,2)+Substr(cDataDe,1,4))	//02 - PERIODO
		aAdd(aRegB350[nPos], (cAliasSFT)->FT_CONTA)						//03 - COD_CTA
		aAdd(aRegB350[nPos], cDescCTA)									//04 - CTA_ISS
		aAdd(aRegB350[nPos], cCtaRef)									//05 - COD_CTA_COSIF
		aAdd(aRegB350[nPos], "1")										//06 - QTD_LCTO
		aAdd(aRegB350[nPos], (cAliasSFT)->FT_CODISS)					//07 - COD_LST
		aAdd(aRegB350[nPos], (cAliasSFT)->FT_VALCONT)					//08 - VL_CONT
		aAdd(aRegB350[nPos], (cAliasSFT)->FT_BASEICM)					//09 - VL_BC_ISS
		aAdd(aRegB350[nPos], (cAliasSFT)->FT_ALIQICM)					//10 - ALIQ_ISS
		aAdd(aRegB350[nPos], (cAliasSFT)->FT_VALICM)					//11 - VL_ISS
		aAdd(aRegB350[nPos], cCodObs)									//12 - COD_INF_OBS
	Else
		aRegB350[nPos,06] := Soma1(aRegB350[nPos,6])					//06 - QTD_LCTO	
		aRegB350[nPos,08] += (cAliasSFT)->FT_VALCONT					//08 - VL_CONT  
		aRegB350[nPos,09] += (cAliasSFT)->FT_BASEICM					//09 - VL_BC_ISS
		aRegB350[nPos,11] += (cAliasSFT)->FT_VALICM						//11 - VL_ISS	
	Endif
Endif	
RestArea(aArea)
Return (.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Programa | B350CLL  ³ Autor ³ Cleber Maldonado      ³ Data ³ 31/02/2014        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                                     ³±±
±±³          ³ B350 - LANÇAMENTO - SERVIÇOS PRESTADOS POR INSTITUIÇÕES FINANCEIRAS ³±±
±±³          ³                                                                     ³±±
±±³          ³ - Geracao do Registro B350                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves da função³±±
±±³          ³ GrvRegTrb com as informacoe contidas no array aCmpAntSFT e na tabela³±±
±±³          ³ SFT.                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³B350 - 2 ( 1:N )                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros| aWizard -> Array com as perguntas do assistente de geração.         ³±±
±±³          | aRegB350 -> Array contendo as informacoes processadas pela          ³±±
±±³          ³ funcao a ser retornado para gravacao pela funcao principal.         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function B350CLL(aWizard, aRegB350, aRegB420, aRegB440, aRegB470, aRegB475, aRegB480, cAlias, cAliasSFT, aReg0450)

Local cNomeCTA		:= ""
Local cAliasCLL		:= ""
Local cPeriodo		:= aWizard[1][1]
Local nPos			:= 0
Local nAliq			:= 0
Local aReg			:= {}
Local aPartDoc		:= {}
Local dDataDe		:= SToD (aWizard[1][1])
Local dDataAte		:= SToD (aWizard[1][2])
Local cCodfil		:= "SM0"+SM0->(M0_CODIGO+M0_CODFIL)
Local aMVCEINITS	:=	IIf(Empty(SuperGetMv("MV_CEINITS")),{},&(SuperGetMv("MV_CEINITS")))
Local aMVMUNIBGE	:=	IIf(Empty(SuperGetMv("MV_MUNIBGE")),{},&(SuperGetMv("MV_MUNIBGE")))

dbSelectArea("CT1")
dbSetOrder(1)
dbSelectArea("CLL")
dbSetOrder(1)

If (TcSrvType ()<>"AS/400")
	cAliasCLL	:=	GetNextAlias()

	cSelect	:= "%CLL.*%"

	cFrom := "%"
	cFrom += RetSqlName("CLL")+" CLL %"

	cWhere := "%"
	cWhere += "CLL.CLL_FILIAL='" + xFilial("CLL") + "' AND "
	cWhere += "CLL.CLL_PERIOD='" + Substr(cPeriodo,5,2)+Substr(cPeriodo,1,4)+"' AND "
	cWhere += "CLL.D_E_L_E_T_=''%"

	BeginSql Alias cAliasCLL
		SELECT
			%Exp:cSelect%
		FROM
			%Exp:cFrom%
		WHERE
			%Exp:cWhere%
	EndSql
	DbSelectArea(cAliasCLL)
	While !(cAliasCLL)->(Eof())
		aAdd(aRegB350, {})
		nPos := Len(aRegB350)
		IIF(nPos == 0,nPos := (nPos + 1),nPos)
		CT1->(dbSeek(xFilial("CT1")+(cAliasCLL)->CLL_CODCTA))
		cNomeCTA := CT1->CT1_DESC01
		aAdd(aRegB350[nPos], "B350")							//01 - REG
		aAdd(aRegB350[nPos], (cAliasCLL)->CLL_PERIOD)			//02 - PERIODO
		aAdd(aRegB350[nPos], (cAliasCLL)->CLL_CODCTA)			//03 - COD_CTA
		aAdd(aRegB350[nPos], cNomeCTA)							//04 - CTA_ISS
		aAdd(aRegB350[nPos], (cAliasCLL)->CLL_COSIF)			//05 - COD_CTA_COSIF
		aAdd(aRegB350[nPos], (cAliasCLL)->CLL_QUANT)			//06 - QTD_LCTO
		aAdd(aRegB350[nPos], (cAliasCLL)->CLL_CODLST)			//07 - COD_LST
		aAdd(aRegB350[nPos], (cAliasCLL)->CLL_VALCON)			//08 - VL_CONT
		aAdd(aRegB350[nPos], (cAliasCLL)->CLL_BASISS)			//09 - VL_BC_ISS
		aAdd(aRegB350[nPos], (cAliasCLL)->CLL_ALQISS)			//10 - ALIQ_ISS
		aAdd(aRegB350[nPos], (cAliasCLL)->CLL_VALISS)			//11 - VL_ISS
		aAdd(aRegB350[nPos], (cAliasCLL)->CLL_OBS)				//12 - COD_INF_OBS
		//+============================+
		//|  Atualiza o registro B420  |
		//+============================+
		If ((nPos := aScan (aRegB420, {|aX| aX[4]==(cAliasCLL)->CLL_ALQISS}))==0)
			aAdd(aRegB420, {})
			nPos := Len(aRegB420)
			aAdd(aRegB420[nPos], "B420")						//01 - REG
			aAdd(aRegB420[nPos], (cAliasCLL)->CLL_VALCON)		//02 - VL_CONT
			aAdd(aRegB420[nPos], (cAliasCLL)->CLL_BASISS)		//03 - VL_BC_ISSQN
			aAdd(aRegB420[nPos], (cAliasCLL)->CLL_ALQISS)		//04 - ALIQ_ISSQN
			aAdd(aRegB420[nPos], (cAliasCLL)->CLL_BASISS)		//05 - VL_BC_ISSQN_RT
			aAdd(aRegB420[nPos], 0)								//06 - VL_RT
			aAdd(aRegB420[nPos], 0)								//07 - VL_ISNT_ISSQN
			aAdd(aRegB420[nPos], (cAliasCLL)->CLL_VALISS)		//08 - VL_ISSQN
		Else
			aRegB420[nPos][02] += (cAliasCLL)->CLL_VALCON		//02 - VL_CONT
			aRegB420[nPos][03] += (cAliasCLL)->CLL_BASISS		//03 - VL_BC_ISSQN
			aRegB420[nPos][05] += (cAliasCLL)->CLL_BASISS		//05 - VL_BC_ISSQN_RT
			aRegB420[nPos][08] += (cAliasCLL)->CLL_VALISS		//08 - VL_ISSQN
		Endif
		//+============================+
		//|  Atualiza o registro 0450  |
		//+============================+
		If !Empty((cAliasCLL)->CLL_OBS)
			Reg0450 ( "TRB", 0, (cAliasCLL)->CLL_OBS, Nil, (cAliasCLL)->CLL_OBS, @aReg0450 )
		Endif
		//+============================+
		//|  Atualiza o registro B470  |
		//+============================+
		aRegB470[02] += (cAliasCLL)->CLL_VALCON							//02 - VL_CONT
		aRegB470[03] += 0												//03 - VL_MAT_TERC
		aRegB470[04] += 0												//04 - VL_MAT_PROP
		aRegB470[05] += 0												//05 - VL_SUB
		aRegB470[06] += 0												//06 - VL_ISNT_ISSQN
		aRegB470[07] += 0												//07 - VL_DED_BC
		aRegB470[08] += (cAliasCLL)->CLL_BASISS							//08 - VL_BC_ISSQN
		aRegB470[09] += 0												//09 - VL_BC_ISSQN_RT
		aRegB470[10] += (cAliasCLL)->CLL_VALISS							//10 - VL_ISSQN
		aRegB470[11] += 0												//11 - VL_RT
		aRegB470[12] += 0												//12 - VL_DED
		aRegB470[13] += (cAliasCLL)->CLL_VALISS							//13 - VL_ISSQN_REC
		aRegB470[14] += 0												//14 - VL_ISSQN_ST
		aRegB470[15] += 0												//15 - VL_ISSQN_FIL
		aRegB470[16] += 0												//16 - VL_ISS
		(cAliasCLL)->(dbSkip())
	End
	(cAliasCLL)->(DbCloseArea())
Endif
Return (.T.)

//----------------------------------------------------------------------------
/*/{Protheus.doc} RegTerc
	Processamento do titulos de pagamento de terceiros RPA / ISS
@author Vicco
@since 20/08/2015
@version 1.0
@return Nenhum
@example
(examples)
@see (links_or_references)
/*/
//----------------------------------------------------------------------------
Static Function RegTerc(aWizard, aRegB410, aRegB420, aRegB430, aRegB440, aRegB450, aRegB470, cAlias, cAliasTrb, nRelac)

Local cNfTerc		:= ""
Local cIndSubT		:= "0"
Local cIndTot		:= "3"
Local nPos			:= 0
Local aReg			:= {}
Local aPartDoc		:= {}
Local dDataDe		:= SToD (aWizard[1][1])
Local dDataAte		:= SToD (aWizard[1][2])
Local aMVCEINITS	:= IIf(Empty(SuperGetMv("MV_CEINITS")),{},&(SuperGetMv("MV_CEINITS")))
Local aMVMUNIBGE	:= IIf(Empty(SuperGetMv("MV_MUNIBGE")),{},&(SuperGetMv("MV_MUNIBGE")))
Local cMunic		:= PadR(SuperGetMv("MV_MUNIC"),TamSX3("E2_FORNECE")[1])
Local cLoja			:= PadR("00",TamSX3("A2_LOJA")[1],"0")

Default cAliasTrb	:= ""
Default nRelac	:= 0

	SA1->(DbSetOrder(1))
	SA2->(DbSetOrder(1))

	//-- Query FINANCEIRO - Consulta titulos com Rec. ISS por data de emissao (FINXIMP.PRW)
	If Empty(cAliasTrb)
		//-- Excuta Query somente se 1a. vez.
		cAliasTrb := ISSFiscal(dDataDe, dDataAte, cMunic, cLoja, "00108")
	EndIf
	(cAliasTrb)->(DbGoTop ())
	While !(cAliasTrb)->(EOF())
		If AllTrim((cAliasTrb)->(TIPO)) == 'RPA'
			nRelac++
			cEntSai  := Iif('P'$(cAliasTrb)->(TIPOPR),'1','2')
			cAlsSA   := 'SA'+Iif(cEntSai=='1','2','1')
			(cAlsSA)->(dbSeek(xFilial(cAlsSA)+(cAliasTrb)->(CLIFOR)+(cAliasTrb)->(LOJA)))
			aPartDoc := InfPartDoc (cAlsSA, aMVCEINITS, aMVMUNIBGE)
			cNfTerc  := AllTrim((cAliasTrb)->(CLIFOR))+DTOS((cAliasTrb)->(DATAPARC))+StrZero(nRelac,3,0)
			//+====================================================+
			//| Registro 0150 - TABELA DE CADASTRO DE PARTICIPANTES|
			//+====================================================+
			Reg0150(aPartDoc)
			//+=====================================================+
			//| Registro B020 - LANÇAMENTO - NOTA FISCAL DE SERVIÇOS|
			//+=====================================================+
			aReg := {}
			aAdd(aReg, {})
			nPos := Len(aReg)
			aAdd(aReg[nPos], "B020")						//01 - REG
			aAdd(aReg[nPos], "0")							//02 - IND_OPER
			aAdd(aReg[nPos], "1")							//03 - IND_EMIT
			aAdd(aReg[nPos], aPartDoc[1])					//04 - COD_PART
			aAdd(aReg[nPos], "03")							//05 - COD_MOD
			aAdd(aReg[nPos], "00")							//06 - COD_SIT
			aAdd(aReg[nPos], "")							//07 - SER
			aAdd(aReg[nPos], "")							//08 - SUB
			aAdd(aReg[nPos], cNfTerc)						//09 - NUM_DOC
			aAdd(aReg[nPos], (cAliasTrb)->(DATAPARC))		//10 - DT_DOC
			aAdd(aReg[nPos], "9101")						//11 - CFPS
			aAdd(aReg[nPos], "")							//12 - NUM_LCTO
			aAdd(aReg[nPos], SM0->M0_CODMUN)				//13 - COD_MUN_SERV
			aAdd(aReg[nPos], (cAliasTrb)->(BASEISS))		//14 - VL_CONT
			aAdd(aReg[nPos], 0)								//15 - VL_MAT_TERC
			aAdd(aReg[nPos], 0)								//16 - VL_SUB
			aAdd(aReg[nPos], 0)								//17 - VL_ISNT_ISS
			aAdd(aReg[nPos], 0)								//18 - VL_DED_BC 
			aAdd(aReg[nPos], (cAliasTrb)->(BASEISS))		//19 - VL_BC_ISS
			aAdd(aReg[nPos], (cAliasTrb)->(BASEISS))		//20 - VL_BC_ISS_RT
			aAdd(aReg[nPos], (cAliasTrb)->(VALORISS))		//21 - VL_ISS_RT
			aAdd(aReg[nPos], (cAliasTrb)->(VALORISS))		//22 - VL_ISS
			aAdd(aReg[nPos], "")							//23 - REF_INF_OBS
			GrvRegTrb (cAlias, nRelac, aReg)
			//+=====================================================+
			//| REGISTRO B025 - LANÇAMENTO - NOTA FISCAL DE SERVIÇOS|
			//+=====================================================+
			aReg := {}
			aAdd(aReg,{})
			nPos := Len (aReg)
			aAdd(aReg[nPos], "B025")						//01 - REG
			aAdd(aReg[nPos], (cAliasTrb)->(BASEISS))		//02 - VL_CONT_P
			aAdd(aReg[nPos], (cAliasTrb)->(BASEISS))		//03 - VL_BC_ISS_P
			aAdd(aReg[nPos], (cAliasTrb)->(ALIQUOTA)*100)	//04 - ALIQ_ISS
			aAdd(aReg[nPos], (cAliasTrb)->(VALORISS))		//05 - VL_ISS_P
			aAdd(aReg[nPos], 0)								//06 - VL_ISNT_ISS_P
			GrvRegTrb (cAlias, nRelac, aReg)
			//+=====================================================+
			//| REGISTRO B410 - TOTALIZACAO AQUISICOES E PRESTACOES |
			//+=====================================================+
			cIndSubT := "0"
			cIndTot  := "3"
			If aPartDoc[11] != SM0->M0_CODMUN
				cIndSubT := "1"
			ElseIf aPartDoc[08] == "EX"
				cIndSubT := "2"
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Totalizando 0, 1, 2, 4, 5, 6 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ((nPos := aScan(aRegB410, {|aX| aX[2]==cIndSubT}))==0)
				aAdd(aRegB410, {})
				nPos := Len (aRegB410)
				aAdd (aRegB410[nPos], "B410")					//01 - REG
				aAdd(aRegB410[nPos], cIndSubT)					//02 - IND_TOT
				aAdd(aRegB410[nPos], 0)							//03 - VL_CONT
				aAdd(aRegB410[nPos], 0)							//04 - VL_BC_ISS
				aAdd(aRegB410[nPos], 0)							//05 - VL_DED_BC
				aAdd(aRegB410[nPos], 0)							//06 - VL_RT
				aAdd(aRegB410[nPos], 0)							//07 - VL_ISNT_ISS
				aAdd(aRegB410[nPos], 0)							//08 - VL_ISS
			EndIf
			//
			aRegB410[nPos][03] += (cAliasTrb)->(BASEISS)		//03 - VL_CONT
			aRegB410[nPos][04] += (cAliasTrb)->(BASEISS)		//04 - VL_BC_ISS
			aRegB410[nPos][05] += 0								//05 - VL_DED_BC
			aRegB410[nPos][06] += (cAliasTrb)->(VALORISS)		//06 - VL_RT
			aRegB410[nPos][07] += 0								//07 - VL_ISNT_ISS
			aRegB410[nPos][08] += (cAliasTrb)->(VALORISS)		//08 - VL_ISS
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Totalizando 3, 7³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ((nPos := aScan(aRegB410, {|aX| aX[2]==cIndTot}))==0)
				aAdd(aRegB410, {})
				nPos := Len (aRegB410)
				aAdd(aRegB410[nPos], "B410")					//01 - REG
				aAdd(aRegB410[nPos], cIndTot)					//02 - IND_TOT
				aAdd(aRegB410[nPos], 0)							//03 - VL_CONT
				aAdd(aRegB410[nPos], 0)							//04 - VL_BC_ISS
				aAdd(aRegB410[nPos], 0)							//05 - VL_DED_BC
				aAdd(aRegB410[nPos], 0)							//06 - VL_RT
				aAdd(aRegB410[nPos], 0)							//07 - VL_ISNT_ISS
				aAdd(aRegB410[nPos], 0)							//08 - VL_ISS
			EndIf
			//
			aRegB410[nPos][03] += (cAliasTrb)->(BASEISS)		//03 - VL_CONT
			aRegB410[nPos][04] += (cAliasTrb)->(BASEISS)		//04 - VL_BC_ISS
			aRegB410[nPos][05] += 0								//05 - VL_DED_BC
			aRegB410[nPos][06] += (cAliasTrb)->(VALORISS)		//06 - VL_RT
			aRegB410[nPos][07] += 0								//07 - VL_ISNT_ISS
			aRegB410[nPos][08] += (cAliasTrb)->(VALORISS)		//08 - VL_ISS
			//+====================================================+
			//| REGISTRO B430 - TOTALIZACAO POR CFPS               |
			//+====================================================+
			If ((nPos := aScan(aRegB430, {|aX| aX[2]=="9101"}))==0)
				aAdd(aRegB430, {})
				nPos := Len (aRegB430)
				aAdd(aRegB430[nPos], "B430")						//01 - REG
				aAdd(aRegB430[nPos], "9101")						//02 - CFPS
				aAdd(aRegB430[nPos], 0)								//03 - VL_CONT
				aAdd(aRegB430[nPos], 0)								//04 - VL_BC_ISS
				aAdd(aRegB430[nPos], 0)								//05 - VL_MAT_TERC
				aAdd(aRegB430[nPos], 0)								//06 - VL_SUB
				aAdd(aRegB430[nPos], 0)								//07 - VL_ISNT_ISS
				aAdd(aRegB430[nPos], 0)								//08 - VL_DED_BC
				aAdd(aRegB430[nPos], 0)								//09 - VL_BC_ISS_RT
				aAdd(aRegB430[nPos], 0)								//10 - VL_RT
				aAdd(aRegB430[nPos], 0)								//11 - VL_ISS
			EndIf
			//
			aRegB430[nPos][03] += (cAliasTrb)->(BASEISS)			//03 - VL_CONT
			aRegB430[nPos][04] += (cAliasTrb)->(BASEISS)			//04 - VL_BC_ISS
			aRegB430[nPos][05] += 0									//05 - VL_MAT_TERC
			aRegB430[nPos][06] += 0									//06 - VL_SUB
			aRegB430[nPos][07] += 0									//07 - VL_ISNT_ISS
			aRegB430[nPos][08] += 0									//08 - VL_DED_BC
			aRegB430[nPos][09] += (cAliasTrb)->(BASEISS)			//09 - VL_BC_ISS_RT
			aRegB430[nPos][10] += (cAliasTrb)->(VALORISS)			//10 - VL_RT
			aRegB430[nPos][11] += (cAliasTrb)->(VALORISS)			//11 - VL_ISS
			//+====================================================+
			//| Registro B440 - RELATORIO DOS VALORES RETIDOS      |
			//+====================================================+
			If ((nPos := aScan(aRegB440, {|aX| aX[2]==STR(Val(cEntSai)-1,1) .AND. aX[3]==aPartDoc[1] .AND. aX[6]==(cAliasTrb)->(ALIQUOTA)*100}))==0)
				aAdd(aRegB440, {})
				nPos := Len(aRegB440)
				aAdd(aRegB440[nPos], 'B440')						//01 - REG
				aAdd(aRegB440[nPos], STR(Val(cEntSai)-1,1))		//02 - IND_OPER
				aAdd(aRegB440[nPos], aPartDoc[1])					//03 - COD_PART
				aAdd(aRegB440[nPos], 0)								//04 - VL_CONT_RT
				aAdd(aRegB440[nPos], 0)								//05 - VL_BC_ISS_RT
				aAdd(aRegB440[nPos], (cAliasTrb)->(ALIQUOTA)*100)	//06 - ALIQ_ISS
				aAdd(aRegB440[nPos], 0)								//07 - VL_ISS_RT
			EndIf
			//
			aRegB440[nPos][04] += (cAliasTrb)->(BASEISS)			//04 - VL_CONT_RT
			aRegB440[nPos][05] += (cAliasTrb)->(BASEISS)			//05 - VL_BC_ISS_RT
			aRegB440[nPos][07] += (cAliasTrb)->(VALORISS)			//07 - VL_ISS_RT
			//+====================================================+
			//| Registro B450 - RELATORIO DOS VALORES POR MUNICIPIO|
			//+====================================================+
			If ((nPos := aScan(aRegB450, {|aX| aX[2]==STR(Val (cEntSai)-1,1) .AND. aX[3]==aPartDoc[11]}))==0)
				aAdd(aRegB450, {})
				nPos := Len (aRegB450)
				aAdd(aRegB450[nPos], "B450")						//01 - REG
				aAdd(aRegB450[nPos], STR(Val (cEntSai)-1,1))		//02 - IND_OPER
				aAdd(aRegB450[nPos], aPartDoc[11])					//03 - COD_MUN_SERV
				aAdd(aRegB450[nPos], 0)								//04 - VL_CONT
				aAdd(aRegB450[nPos], 0)								//05 - VL_BC_ISS
				aAdd(aRegB450[nPos], 0)								//06 - VL_ISNT_ISS
				aAdd(aRegB450[nPos], 0)								//07 - VL_DED_BC
				aAdd(aRegB450[nPos], 0)								//08 - VL_RT
				aAdd(aRegB450[nPos], 0)								//09 - VL_ISS
			EndIf
			//
			aRegB450[nPos][04] += (cAliasTrb)->(BASEISS)			//04 - VL_CONT
			aRegB450[nPos][05] += (cAliasTrb)->(BASEISS)			//05 - VL_BC_ISS
			aRegB450[nPos][06] += 0									//06 - VL_ISNT_ISS
			aRegB450[nPos][08] += (cAliasTrb)->(VALORISS)			//08 - VL_RT
			aRegB450[nPos][09] += (cAliasTrb)->(VALORISS)			//09 - VL_ISS
			//+====================================================+
			//| Registro B470 - SALDOS DO ISS A RECOLHER           |
			//+====================================================+
			aRegB470[02] += 0														//02 - A-VL_CONT
			aRegB470[03] += 0														//03 - B-VL_MAT_TERC
			aRegB470[04] += 0														//04 - C-VL_MAT_PROP
			aRegB470[05] += 0														//05 - D-VL_SUB
			aRegB470[06] += 0														//06 - E-VL_ISNT
			aRegB470[07] := aRegB470[03]+aRegB470[04]+aRegB470[05]+aRegB470[06]	//07 - F-VL_DED_BC
			aRegB470[08] := aRegB470[02]-aRegB470[07]								//08 - G-VL_BC_ISS
			aRegB470[09] += (cAliasTrb)->(BASEISS)									//09 - H-VL_BC_ISS_RT
			aRegB470[10] += 0														//10 - I-VL_ISS
			aRegB470[11] += 0														//11 - J-VL_ISS_RT
			aRegB470[12] += 0														//12 - K-VL_DED
			aRegB470[13] := aRegB470[10]-aRegB470[11]-aRegB470[12]					//13 - L-VL_ISS_REC
			aRegB470[14] += (cAliasTrb)->(VALORISS)									//14 - M-VL_ISS_ST
			aRegB470[15] += 0														//15 - N-VL_ISS_FIL
			aRegB470[16] += 0														//16 - O-VL_ISS_RT_RC
			//
		EndIf
		(cAliasTrb)->(Dbskip())
	EndDo

Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Regb040  ³ Autor ³ Cleber Maldonado      ³ Data ³15.05.2015³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ LANCAMENTO - REDUCAO Z/ISS                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoe contidas no array    ³±±
±±³          ³ aRegB040 para o Modelo 2D.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³VARIOS POR ARQUIVO                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAlias -> Alias do TRB que recebera as informacoes          ³±±
±±³          ³nRelac -> Flag de relacionamento com os sub-registros       ³±±
±±³          ³aRegB040 -> Informacoes sobre todos documentos fiscais pro- ³±±
±±³          ³cessados no while da funcao principal.                      ³±±
±±³          ³nItem -> Contador do item para cada documento fiscal.       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function B040B045(cAlias, nRelac, aRegB040, aRegB045, nItem, lISS, aCmpAntSFT, cSituaDoc , cAliasSFT, cCmpVlAcr )
Local	nPos		:= 0
Local	nPos2		:= 0
Local	nI			:= 0
Local	cNumero		:= ""
Local	cNumeroPDV	:= ""
Local	cPDV		:= ""
Local	cSerPDV		:= ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona o registro no SFI³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SFI->(dbSetOrder(1))
If SFI->(dbSeek(xFilial("SFI") + DtoS(aCmpAntSFT[6]) + aCmpAntSFT[12])) //Data+PDV
	cPDV       := SFI->FI_PDV
	cSerPDV    := SFI->FI_SERPDV
	cNumero    := AllTrim(SFI->FI_NUMERO)
	cNumeroPDV := AllTrim(SFI->FI_PDV)
	If ((nPos := aScan (aRegB040, {|aX| aX[3]==cPDV .And. aX[4]==cSerPDV .And. aX[9]==SFI->FI_DTMOVTO}))==0)
		aAdd(aRegB040, {})
		nPos := Len(aRegB040)
		aAdd(aRegB040[nPos], "B040")								//01 - REG
		aAdd(aRegB040[nPos], "2D")									//02 - COD_MOD
		aAdd(aRegB040[nPos], SFI->FI_PDV)							//03 - ECF_CX
		aAdd(aRegB040[nPos], SFI->FI_SERPDV	)						//04 - ECF_FAB
		aAdd(aRegB040[nPos], SFI->FI_CRO)							//05 - CRO
		aAdd(aRegB040[nPos], SFI->FI_NUMREDZ)						//06 - CRZ
		aAdd(aRegB040[nPos], SFI->FI_NUMINI)						//07 - NUM_DOC_INI
		aAdd(aRegB040[nPos], SFI->FI_NUMFIM)						//08 - NUM_DOC_FIN
		aAdd(aRegB040[nPos], SFI->FI_DTMOVTO)						//09 - DT_DOC
		aAdd(aRegB040[nPos], SFI->FI_GTINI)							//10 - GT_INI
		aAdd(aRegB040[nPos], SFI->FI_GTFINAL)						//11 - GT_FINAL
		aAdd(aRegB040[nPos], SFI->FI_GTFINAL-SFI->FI_GTINI)			//12 - VL_BRT
		aAdd(aRegB040[nPos], 0)										//13 - VL_CANC_ISS
		aAdd(aRegB040[nPos], 0)										//14 - VL_CANC_ICMS
		aAdd(aRegB040[nPos], 0)										//15 - VL_CANC
		aAdd(aRegB040[nPos], 0)										//16 - VL_DESC_ISSQN
		aAdd(aRegB040[nPos], 0)										//17 - VL_DESC_ICMS
		aAdd(aRegB040[nPos], 0)										//18 - VL_DESC
		aAdd(aRegB040[nPos], 0)										//19 - VL_ACMO_ISSQN
		aAdd(aRegB040[nPos], 0)										//20 - VL_ACMO_ICMS
		aAdd(aRegB040[nPos], 0)										//21 - VL_ACMO
		aAdd(aRegB040[nPos], 0)										//22 - VL_BC_ISS
		aAdd(aRegB040[nPos], 0)										//23 - VL_ISS
		aAdd(aRegB040[nPos], 0)										//24 - VL_ISEN_ISS
		aAdd(aRegB040[nPos], 0)										//25 - VL_NT_ISS
		aAdd(aRegB040[nPos], 0)										//26 - VL_RT_ISS
		aAdd(aRegB040[nPos], 0)										//27 - VL_LIQ
		aAdd(aRegB040[nPos], "")									//28 - COD_INF_OBS
	EndIf
	If (cSituaDoc $ "02#03#04")	//Documento cancelado
		If lIss
			aRegB040[nPos][13] += (cAliasSFT)->FT_VALICM				//13 - VL_CANC_ISSQN
		Else
			aRegB040[nPos][14] += (cAliasSFT)->FT_VALICM				//14 - VL_CANC_ICMS
		EndIf
	Else
		If lIss
			aRegB040[nPos][16] += (cAliasSFT)->FT_DESCONT				//16 - VL_DESC_ISSQN
			aRegB040[nPos][19] += &(cCmpVlAcr)							//19 - VL_ACMO_ISSQN
			aRegB040[nPos][22] += (cAliasSFT)->FT_BASEICM				//22 - VL_BC_ISS
			aRegB040[nPos][24] += (cAliasSFT)->FT_ISENICM				//24 - VL_ISEN_ISS
			aRegB040[nPos][25] += (cAliasSFT)->FT_OUTRICM				//25 - VL_NT_ISS
			If (cAliasSFT)->FT_RECISS == "1"
				aRegB040[nPos][26] += (cAliasSFT)->FT_VALICM			//26 - VL_RT_ISS
			Else
				aRegB040[nPos][23] += (cAliasSFT)->FT_VALICM			//23 - VL_ISS
			Endif
			aRegB040[nPos][27] += (cAliasSFT)->FT_VALCONT				//27 - VL_LIQ
		Else
			aRegB040[nPos][17] += (cAliasSFT)->FT_DESCONT				//17 - VL_DESC_ICMS
			aRegB040[nPos][20] := &(cCmpVlAcr)							//20 - VL_ACMO_ICMS
		EndIf
	EndIf
	//Registro B045
	If ((nPos2 := aScan(aRegB045, {|aX| aX[01]==nPos .And. aX[10]==(cAliasSFT)->FT_ALIQICM}))==0)
		aAdd(aRegB045, {})
		nPos2	:=	Len(aRegB045)
		aAdd(aRegB045[nPos2], nPos)							//01 - RELACIONAMENTO COM O CABECALHO B040
		aAdd(aRegB045[nPos2], "B045")						//02 - REG
		aAdd(aRegB045[nPos2], 0)							//03 - VL_CANC_ISS_P
		aAdd(aRegB045[nPos2], 0)							//04 - VL_CANC_ICMS_P
		aAdd(aRegB045[nPos2], 0)							//05 - VL_DESC_ISS_P
		aAdd(aRegB045[nPos2], 0)							//06 - VL_DESC_ICMS_P
		aAdd(aRegB045[nPos2], 0)							//07 - VL_ACMO_ISS_P
		aAdd(aRegB045[nPos2], 0)							//08 - VL_ACMO_ICMS_P
		aAdd(aRegB045[nPos2], 0)							//09 - VL_BC_ISS_P
		aAdd(aRegB045[nPos2], (cAliasSFT)->FT_ALIQICM)		//10 - ALIQ_ISS
		aAdd(aRegB045[nPos2], 0)							//11 - VL_ISS_P
		aAdd(aRegB045[nPos2], 0)							//12 - VL_ISEN_ISS_P
		aAdd(aRegB045[nPos2], 0)							//13 - VL_NT_ISS_P
		aAdd(aRegB045[nPos2], 0)							//14 - VL_ISS_RT_P
	EndIf
	If (cSituaDoc $ "02#03#04")	//Documento cancelado
		If lIss
			aRegB045[nPos2][03] += (cAliasSFT)->FT_VALICM		//03 - VL_CANC_ISS_P
		Else
			aRegB045[nPos2][04] += (cAliasSFT)->FT_VALICM		//04 - VL_CANC_ICMS_P
		EndIf
	Else
		If lIss
			aRegB045[nPos2][05] += (cAliasSFT)->FT_DESCONT		//05 - VL_DESC_ISSQN_P
			aRegB045[nPos2][07] += &(cCmpVlAcr)					//07 - VL_ACMO_ISSQN_P
			aRegB045[nPos2][09] += (cAliasSFT)->FT_BASEICM		//09 - VL_BC_ISS_P
			aRegB045[nPos2][12] += (cAliasSFT)->FT_ISENICM		//12 - VL_ISEN_ISS_P
			aRegB045[nPos2][13] += (cAliasSFT)->FT_OUTRICM		//13 - VL_NT_ISS_P
		Else
			aRegB045[nPos2][06] += (cAliasSFT)->FT_DESCONT		//06 - VL_DESC_ICMS_P
			aRegB045[nPos2][08] += &(cCmpVlAcr)					//08 - VL_ACMO_ICMS_P
		Endif
		If (cAliasSFT)->FT_RECISS == "1"
			aRegB045[nPos][14] += (cAliasSFT)->FT_VALICM		//14 - VL_ISS_RT_P
		Else
			aRegB045[nPos2][11] += (cAliasSFT)->FT_VALICM		//11 - VL_ISS_P
		Endif
	EndIf
EndIf
Return(.T.)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Regb490  ³ Autor ³ Cleber Maldonado      ³ Data ³15.05.2015³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ OBRIGAÇÕES DO ISS A RECOLHER                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³Atribui em um array o conteudo a ser gravado no TRB atraves ³±±
±±³          ³ da funcao GrvRegTrb com as informacoe contidas no array    ³±±
±±³          ³ aRegB040 para o Modelo 2D.                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Nivel Hier³VARIOS POR ARQUIVO                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³.T.                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³cAlias -> Alias do TRB que recebera as informacoes          ³±±
±±³          ³nRelac -> Flag de relacionamento com os sub-registros       ³±±
±±³          ³aRegB490 -> Informacoes sobre todos documentos fiscais pro- ³±±
±±³          ³cessados no while da funcao principal.                      ³±±
±±³          ³nItem -> Contador do item para cada documento fiscal.       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RegB490(cAliasSFT, cEntSai, aRegB490, cSituaDoc, aPartDoc, lIssRet, aWizard)
Local	nPos		:= 0
Local	cAliasSF6	:= ""
Local	cSelect		:= ""
Local	cFrom		:= ""
Local	cWhere		:= ""
Local	cPerFis		:= ""
Local	dDataDe		:= SToD (aWizard[1][1])
Local	dDataAte	:= SToD (aWizard[1][2])

dbSelectArea("SF6")
dbSetOrder(2)

If (TcSrvType()<>"AS/400")
	cAliasSF6 := GetNextAlias()

	cSelect := "%SF6.*%"

	cFrom := "%"
	cFrom += RetSqlName("SF6")+" SF6 %"

	cWhere := "%"
	cWhere += "SF6.F6_FILIAL='" + xFilial("SF6") + "' AND "
	cWhere += "SF6.F6_DTARREC>='" + DToS(dDataDe)  + "' AND "
	cWhere += "SF6.F6_DTARREC<='" + DToS(dDataAte) + "' AND "
	cWhere += "SF6.F6_TIPOIMP=" + "'2'" + " AND "
	cWhere += "SF6.D_E_L_E_T_ = '"+"'%"

	BeginSql Alias cAliasSF6
		COLUMN F6_DTARREC AS DATE
		SELECT
			%Exp:cSelect%
		FROM
			%Exp:cFrom%
		WHERE
			%Exp:cWhere%
	EndSql
	dbSelectArea(cAliasSF6)
	cPerFis := IIF(Len(Alltrim(Str((cAliasSF6)->F6_MESREF)))+Len(Alltrim(Str((cAliasSF6)->F6_ANOREF)))=5,;
				"0"+Alltrim(Str((cAliasSF6)->F6_MESREF))+Alltrim(Str((cAliasSF6)->F6_ANOREF)),;
				Alltrim(Str((cAliasSF6)->F6_MESREF))+Alltrim(Str((cAliasSF6)->F6_ANOREF)))
	While !(cAliasSF6)->(Eof())
		aAdd(aRegB490, {})
		nPos := Len(aRegB490)
		aAdd(aRegB490[nPos], "B490")								//01 - REG
		aAdd(aRegB490[nPos], (cAliasSF6)->F6_ISSOR)					//02 - COD_OR
		aAdd(aRegB490[nPos], (cAliasSF6)->F6_VALOR)					//03 - VL_OR
		aAdd(aRegB490[nPos], Substr((cAliasSF6)->F6_DTVENC,7,2)+;
							 Substr((cAliasSF6)->F6_DTVENC,5,2)+;
							 Substr((cAliasSF6)->F6_DTVENC,1,4))	//04 - DT_VCTO
		aAdd(aRegB490[nPos], (cAliasSF6)->F6_CODREC)				//05 - COD_REC
		aAdd(aRegB490[nPos], RetCodEst((cAliasSF6)->F6_EST)+(cAliasSF6)->F6_CODMUN)	//06 - COD_MUN_SERV	
		aAdd(aRegB490[nPos], (cAliasSF6)->F6_NUMPROC)				//07 - NUM_PROC
		aAdd(aRegB490[nPos], (cAliasSF6)->F6_INDPROC)				//08 - IND_PROC
		aAdd(aRegB490[nPos], (cAliasSF6)->F6_DESCOMP)				//09 - DESCR_PROC
		aAdd(aRegB490[nPos], "")									//10 - COD_INF_OBS
		(cAliasSF6)->(dbSkip())
	EndDo
	(cAliasSF6)->(DbCloseArea())
Endif
Return

//-------------------------------------------------------------------
/*/{Protheus.doc}
@description Obrigações do ICMS a Recolher
@author Mauro A. Gonçalves
@since 11/02/2016
@version 11.80
/*/
//-------------------------------------------------------------------
Static Function RegE350(cAlias, dPer, cLivro, nRelac, aReg0450)
Local aReg        := {}
Local nPos        := 0
Local cAliasF0I   := ""
Local nDifal87DF  := 0

//Verifica se a tabela existe
If !AliasIndic("F0I")
	Return 0
Endif

dbSelectArea("F0I")
dbSetOrder(2) //F0I_FILIAL+DTOS(F0I_PER)+F0I_LIVRO+F0I_UF

If (TcSrvType()<>"AS/400")
	cAliasF0I := GetNextAlias()

	BeginSql Alias cAliasF0I
		COLUMN F0J_DTVENC AS DATE
		SELECT
			F0I.F0I_UF, F0J.F0J_VALOR, F0J.F0J_DTVENC,SF6.F6_CODREC
		FROM
			%Table:F0I% F0I
		RIGHT JOIN
			%Table:F0J% F0J
		ON
			F0J.F0J_FILIAL=%xFilial:F0J% AND
			F0J.F0J_PER=F0I.F0I_PER AND
			F0J.F0J_LIVRO=F0I.F0I_LIVRO AND
			F0J.F0J_UF=F0I.F0I_UF AND
			F0J.F0J_TIPO IN ('1','2') AND
			F0J.%NotDel%
		LEFT JOIN
			%Table:SF6% SF6
		ON 
			SF6.F6_FILIAL=%xFilial:SF6% AND
			F6_NUMERO = F0J_GNRE AND 
			F6_EST = F0J_UF AND
			SF6.%NotDel%

		WHERE
			F0I.F0I_FILIAL=%xFilial:F0I% AND
			F0I.F0I_PER= %Exp:DToS(dPer)% AND
			F0I.F0I_LIVRO=%Exp:cLivro% AND
			F0I.%NotDel%
	EndSql

	dbSelectArea(cAliasF0I)
	While !(cAliasF0I)->(Eof())
		If ((nPos := aScan(aReg, {|aX| aX[6]==(cAliasF0I)->F0I_UF}))==0)
			aAdd(aReg, {})
			nPos := Len(aReg)
			aAdd(aReg[nPos], "E350")										//01 - REG
			aAdd(aReg[nPos], IIf((cAliasF0I)->F0I_UF=="DF","020","999"))	//02 - COD_OR
			aAdd(aReg[nPos], (cAliasF0I)->F0J_VALOR)						//03 - VL_OR
			aAdd(aReg[nPos], (cAliasF0I)->F0J_DTVENC)						//04 - DT_VCTO
			aAdd(aReg[nPos], (cAliasF0I)->F6_CODREC )						//05 - COD_REC
			aAdd(aReg[nPos], (cAliasF0I)->F0I_UF)							//06 - UF_OR
			aAdd(aReg[nPos], "")											//07 - NUM_PROC
			aAdd(aReg[nPos], "0")											//08 - IND_PROC
			aAdd(aReg[nPos], "")											//09 - DESCR_PROC
			aAdd(aReg[nPos], IIf((cAliasF0I)->F0I_UF=="DF","DIFALEC87DF","DIFALEC87DESTINO"))	//10 - COD_INF_OBS
		Else
			aReg[nPos][3] += (cAliasF0I)->F0J_VALOR							//03 - VL_OR
		Endif
		//REGISTRO 0450 - TABELA DE INFORMACOES COMPLEMENTARES/OBSERVACOES
		If (cAliasF0I)->F0I_UF=="DF"
			nDifal87DF += aReg[nPos][3] //deve ser informado no campo 18 do registro E360
			Reg0450(cAlias, nRelac, "Operacoes sujeitas a diferenca de aliquota da EC 87/2015  ", "", "DIFALEC87DF", @aReg0450)
		Else
			Reg0450(cAlias, nRelac, "Operacoes sujeitas a diferenca de aliquota da EC 87/2015 devida a unidade federada de destino  ", "", "DIFALEC87DESTINO", @aReg0450)
		Endif
		(cAliasF0I)->(dbSkip())
	EndDo
	(cAliasF0I)->(DbCloseArea())
Endif
	
GrvRegTrb(cAlias,, aReg)

Return nDifal87DF

//-------------------------------------------------------------------
/*/{Protheus.doc}
@description Retorna o CNPJ/CPF do Cliente Padrão caso seja utilizado 
@author Mauro A. Gonçalves
@since 11/01/2017
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function GetCliPad(cCliPad,cLojPad,aPartDoc,cCGCF2,nTamCod,nTamLoj)

If Len(aPartDoc) > 0 .AND. !Empty(cCGCF2) 

	If AllTrim(Right(aPartDoc[1],nTamCod+nTamLoj)) == cCliPad+cLojPad  
		If Len(ALLTRIM(cCGCF2)) == 14
			aPartDoc[4] := cCGCF2
			aPartDoc[5] := ""
		Else
			aPartDoc[4] := ""
			aPartDoc[5] := cCGCF2
		EndIf
	EndIf
	
EndIf

Return .T.

//-------------------------------------------------------------------
/*/{Protheus.doc} GetNatOper
Funcao responsavel por retornar o codigo e a descricao da natureza da operacao/prestacao configuradas no ambiente. Existem varias formas de
obter essas informacoes, entre elas: Tabela CD1, campo F4_TEXTO ou tabela SX5.
Utilizado pelas rotinas do SPED: SPEDFISCAL, NFESEFAZ...

Similar a Função utilizada no SPED

@param	cAliasSFT	-	Alias da tabela SFT
@param	cAliasSF4	-	Alias da tabela SF4
@param	lSeekSF4	-	Indica que a tabela SF4 esta posicionada e podera utilizar as informacoes dessa tabela no retorno se necessario

@return	aNatOper	-	Array com duas informacoes: 1 - Codigo da natureza da operacao/prestacao ; 2 - Descricao da natureza da operacao/prestacao

@author Mauro A. Gonçalves
@since 03/04/2017
@version 11.8
/*/
//-------------------------------------------------------------------
Static Function GetNatOper(cAliasSFT, cAliasSF4, lSeekSF4)

local aNatOper	:= { "" , "" }
Local lSpedNat	:= GetNewPar("MV_SPEDNAT",.F.)
Local lNatOpCD1	:= AliasIndic("CD1") .And. (cAliasSFT)->(FieldPos("FT_NATOPER"))>0 .And. CD1->(dbSeek(xFilial("CD1")+(cAliasSFT)->FT_NATOPER))

//utiliza a tabela CD1
if lNatOpCD1
	aNatOper[1]	:=	(cAliasSFT)->FT_NATOPER
	aNatOper[2]	:=	AllTrim(CD1->CD1_DESCR)
//Se encontrar TES e MV_SPEDNAT = F
elseif !lSpedNat .And. lSeekSF4
	aNatOper[1]	:=	allTrim((cAliasSF4)->F4_CODIGO)
	aNatOper[2]	:=	allTrim((cAliasSF4)->F4_TEXTO)
//MV_SPEDNAT = T
elseif SX5->(dbSeek(xFilial("SX5")+"13"+(cAliasSFT)->FT_CFOP))
	aNatOper[1]	:=	(cAliasSFT)->FT_CFOP
	aNatOper[2]	:=	allTrim(SX5->X5_DESCRI)
endif

Return aNatOper

//-------------------------------------------------------------------
/*/{Protheus.doc}
@description geracao do arquivo texto
@author Flavio Luiz Vicco
@since 15/08/2017
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function DumpFile(nAcao, cDir, cFileDest)
Local cLib       := ""
Local cStartPath := AllTrim(GetSrvProfString("StartPath",""))
Local nRemType   := GetRemoteType(@cLib)
Local lHtml      := IIf("HTML" $ cLib,.T.,.F.)
Local nRet       := 0

Default nAcao    := 1
Default cDir     := ""
Default cFileDest:= ""

If nAcao == 1
	If Empty(cDir) .Or. lHtml
		cDir := cStartPath
	EndIf
	If !SubStr(cDir,Len(cDir),1)$"\/"
		cDir += "\"
	EndIf
	cFileDest := AllTrim(cFileDest)
	cFileDest := cDir+cFileDest
	If IsSrvUnix() .Or. nRemType == 2
		cFileDest := StrTran(cFileDest,"\","/")
		cFileDest := StrTran(StrTran(StrTran(Alltrim(cFileDest)," ","_"),chr(13),""),chr(10),"")
	Else
		//Se o drive nao existir, pergunto ao usuario se deseja cria-lo atraves da funcao LjDirect()
		If !ExistDir(cDir)
			LjDirect(cDir,.T.)
		Endif
	EndIf
Else
	If File(cFileDest)
		If lHtml
			MsgAlert("Em função do acesso ao sistema ser via SmartClient HTML, o caminho informado para salvar o arquivo será desconsiderado, e será processado conforme configuração do navegador.")
			nRet := CPYS2TW(cFileDest)
			If nRet == 0
				FErase(cFileDest)
				MsgInfo(OemToAnsi(STR0001 + cFileDest + STR0002)) //"Arquivo "###" gerado com sucesso!"
			EndIf
		Else
			MsgInfo(OemToAnsi(STR0001 + cFileDest + STR0002)) //"Arquivo "###" gerado com sucesso!"
		EndIf
	Else
		MsgAlert(OemToAnsi(STR0003)) //"Não foi possível gerar o arquivo!"
	EndIf
EndIf

Return Nil
