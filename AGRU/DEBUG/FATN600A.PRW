#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "FATA600.CH"
#INCLUDE "DBTREE.CH"

#DEFINE DEF_TFJ_ATIVO '1'			//TFJ_STATUS
#DEFINE CAMPO_PROD 	1
#DEFINE VALOR_PROD 	2
#DEFINE CAMPO_ITEM 	3
#DEFINE VALOR_ITEM 	4
#DEFINE MUDOU_PROD 	5

Static lRemOrcServ  := .F.
Static aPosItensOrc := {}
Static aItOrcSerRem := {}
Static oMdlProp		:= Nil
Static aCOTot		:= {}
Static cPrcOrc		:= Nil
Static cRevPrc		:= Nil
Static lVist		:= Nil
Static oMdlVist		:= Nil
Static _lFT600CRO	:= ExistBlock("FT600CRO") //Ponto de entrada para filtrar produtos a serem considerados no Cronograma Financeiro
Static _lFt600Tot	:= ExistBlock('FT600TOT')
Static _lAlterCron	:= SuperGetMv("MV_ALTERCR",,.F.)	// Parametro que define se a condição de pagamento parte do ADZ_DT1VEN

//-------------------------------------------------------------------
/*/{Protheus.doc} At600Orc
Geracao do orcamento de venda

@author luiz.jesus
@since 18/03/2014
@version 12
/*/
//-------------------------------------------------------------------
Function At600Orc(cProposta, cOportunida, cRevisao, cEntidade, cCodEnt, cLojEnt, cDescEnt, nOpc, cTabPrc, oModel)

Local aArea			:= (GetArea())																							//Salva o posicionamento do TR1
Local aOrcamentos		:= {}																										//Array que armazena todos os orcamentos antes de grava-los
Local aOrcXPgto		:= {}																							 			//Array que vincula o codigo do orcamento para cada cond. pagto.
Local aCabOrc 		:= {}																							 			//Array usado para Cabecalho do orcamento
Local aItemDel		:= {}																										//Itens que devem ser excluidos
Local aRegs			:= {}																										//Array copia
Local cCodPag			:= Space(GetSX3Cache("E4_CODIGO","X3_TAMANHO"))														//Guarda a condicao de pagamento
Local cOrcamento		:= If(nOpc == MODEL_OPERATION_INSERT, Space(GetSX3Cache("CJ_NUM","X3_TAMANHO")), SCJ->CJ_NUM)	//Numero do orcamento
Local lRet				:= .T.																						   				//Utilizada para retorno (.T./.F.)
Local nX				:= 0																						   				//Contador de loop
Local nY				:= 0																							  			//Contador de loop
Local nZ				:= 0																							  			//Contador de loop
Local nItem			:= 0																										//Contador de itens
Local nPos				:= 0																							 			//Indice de busca em vetores
Local nCab				:= 0																										//Numero do Cabecalho utilizado
Local nTp09			:= 0
Local nPosOrc			:= 0																							 			//Posicao do codigo do orcamento no item da execauto
Local nPosItem		:= 0																							  			//Posicao do item do orcamento no vetor de itens da ExecAuto
Local nPosDel			:= 0																							   			//Posicao do campo AUTDELETA no item do execauto
Local nNumItem 		:= 0																										//Total de itens (produtos)
Local cProxParc		:= "0"
Local cItem			:= ""																							   			//Item do orcamento
Local nTamCKItem		:= GetSX3Cache("CK_ITEM",    "X3_TAMANHO")
Local nTamCli			:= GetSX3Cache("CJ_CLIENTE", "X3_TAMANHO")
Local nTamLoj			:= GetSX3Cache("CJ_LOJA",    "X3_TAMANHO")
Local nTamB1LcPd		:= GetSX3Cache("B1_LOCPAD",  "X3_TAMANHO")
Local nTamTabPrc		:= GetSX3Cache("CJ_TABELA",  "X3_TAMANHO")
Local nTamADZPrd		:= GetSX3Cache("ADZ_PRODUT", "X3_TAMANHO")
Local nDecCJParc		:= 0
Local cCodCli			:= Space(nTamCli)
Local cLojCli			:= Space(nTamLoj)
Local cCodPro			:= Space(GetSX3Cache("CJ_PROSPE",  "X3_TAMANHO"))
Local cLojPro			:= Space(GetSX3Cache("CJ_LOJPRO",  "X3_TAMANHO"))
Local cClEntr       	:= Space(GetSX3Cache("CJ_CLIENT",  "X3_TAMANHO"))													// Variavel que recebe o codigo do cliente de entrega
Local cLojEntr     	:= Space(GetSX3Cache("CJ_LOJAENT", "X3_TAMANHO"))													// Variavel que recebe o codigo da loja de entrega do cliente
Local cCliOrc			:= ""																										// Cliente salvo no orcamento
Local cLojOrc			:= ""																										// Loja salva no orcamento
Local nRecDel			:= 0
Local nNumParc		:= SuperGetMv("MV_NUMPARC")																				// Numero de parcelas permitidas para tipo 9
Local nRec				:= 0
Local lIncDel			:= .T.																							  			//Indica se deve ser incluido o registro removido no execauto
Local lDelOrc			:= .F.																							  			//Indica se todo o orcamento deve ser excluido
Local lOrcBloq		:= .F.																							   			//Indica se todos os orcamentos devem ser bloqueados
Local aRecSCJ			:= {}																							  			//Lista de registros do SCJ
Local cFilAD1			:= {}																							   			//Filtro existente na AD1
Local nCodTp9			:= 0
Local nRecLidos 		:= 0
Local nProxItem		:= 0
Local nTotPercent		:= 0
Local nUltItPerc		:= 0
Local cMoedaPr 		:= "1"
Local dDiaPrim		:= Ctod("")
Local nVlrGravar		:= 0																										//Recebe o preco unitario do produto
Local cCliPad			:= SuperGetMv("MV_ORCLIPD",,"00000101")																//Codigo do cliente padrao do MV_ORCLIPD
Local aDadosPro		:= {}																										//Codigo e loja do cliente gravados no prospect
Local aProdutos		:= {}																										//Produtos vendidos na proposta
Local cCmpVend    	:= "CJ_VEND1"																								//Este campo não existe no dicionario, deve ser criado pelo adm do sistema para atender necessidade do orçamento de vendas
Local cLocal			:= ""																										//Este campo irá informar o armazen padrão do produto para o orçamento.
Local nAba				:= 0
Local cFolder			:= ""
Local oMdlOpor		:= FT600MdlOport()
Local oMdlAD1			:= oMdlOpor:GetModel("AD1MASTER")
Local cProxItem 		:= StrZero(0, nTamCKItem)
Local cItemAtu		:= ""
Local cCdPgTab		:= ""
Local cTabPrcCJ		:= ""
Local aTipo09			:= {}
Local cFilSA1			:= xFilial("SA1")
Local cFilSB1			:= xFilial("SB1")
Local cFilSCJ			:= xFilial("SCJ")
Local cFilSCK			:= xFilial("SCK")
Local cFilSE4			:= xFilial("SE4")
Local cFilSUS			:= xFilial("SUS")
Local cFilDA0			:= xFilial("DA0")
Local nLenSX8			:= GetSX8Len()
Local lPosTCli		:= SCJ->(ColumnPos("CJ_TIPOCLI")) > 0
Local cTipoCli		:= ""
Local cTipoCliP		:= ""
Local aOrcDCab		:= {}
Local cNomeEn			:= ""

Local aOrcOrdem			:= {}
Local aColsModel		:= {}
Local nLenOrc			:= 0
Local nLenOrcIt			:= 0
Local nPosCond			:= 0
Local nPosMoeda			:= 0
Local nPos1Venc			:= 0

Private lMsErroAuto	:= .F.

If	nOpc == MODEL_OPERATION_VIEW
	Return(.T.)
Endif

nNumItem 		:= oModel:GetModel('ADZPRODUTO'):Length() + oModel:GetModel('ADZACESSOR'):Length()

SCK->(DbSetOrder(5))	//CK_FILIAL+CK_PROPOST
SCK->(DbSeek(cFilSCK + cProposta))
//Armazena o codigo de cada orcamento e sua condicao de pagamento
While	SCK->(! Eof())                .And.;
		SCK->CK_FILIAL  == cFilSCK    .And.;
		SCK->CK_PROPOST == cProposta
	aAdd(aOrcXPgto,{SCK->CK_NUM,;
	                Posicione("SCJ", 1, cFilSCJ + SCK->CK_NUM, "CJ_CONDPAG"),;
	                SCK->CK_DT1VEN,;
	                Posicione("SCJ", 1, cFilSCJ + SCK->CK_NUM, "CJ_MOEDA"),;
	                SCK->CK_CLIENTE,;
	                SCK->CK_LOJA})
	SCK->(DbSkip())
EndDo

SA1->(DBSetOrder(1))

//Ajusta o indice correto das tabelas utilizadas nesta rotina
SCJ->(DbSetOrder(1))	//CJ_FILIAL+CJ_NUM+CJ_CLIENTE+CJ_LOJA
SE4->(dbSetOrder(1))	//E4_FILIAL+E4_CODIGO
SB1->(dbSetOrder(1))	//B1_FILIAL+B1_COD

For nAba := 1 to 2

	If nAba == 1
		cFolder := 'ADZPRODUTO'
	Else
		cFolder := 'ADZACESSOR'
	EndIf

	aOrcOrdem	:= {}
	If	!( oModel:GetModel(cFolder):IsEmpty() )
		aColsModel	:= oModel:GetModel(cFolder):aCols
		nPosCond	:= aScan(oModel:GetModel(cFolder):aHeader,{|x| AllTrim(x[2]) == "ADZ_CONDPG"})
		nPosMoeda	:= aScan(oModel:GetModel(cFolder):aHeader,{|x| AllTrim(x[2]) == "ADZ_MOEDA"})
		nPos1Venc	:= aScan(oModel:GetModel(cFolder):aHeader,{|x| AllTrim(x[2]) == "ADZ_DT1VEN"})

		For nX := 1 To Len(aColsModel)
			cChvItem	:= aColsModel[nX][nPosCond] + aColsModel[nX][nPosMoeda] + DtoS(aColsModel[nX][nPos1Venc])
			nPos := aScan( aOrcOrdem, {|x| x[1] == cChvItem })
			If nPos == 0
				aAdd(aOrcOrdem,{cChvItem,{nX}})
			Else
				aAdd(aOrcOrdem[nPos][2],nX)
			EndIf
		Next nX
	EndIf

	nLenOrc 	:= Len(aOrcOrdem)
	For nZ := 1 To nLenOrc

		nLenItOrde := Len(aOrcOrdem[nZ][2])

		For nY := 1 To nLenItOrde

			cCdPgTab	:= ""
			cTabPrcCJ	:= ""
			cItemAtu	:= cProxItem

			oModel:GetModel(cFolder):GoLine(aOrcOrdem[nZ][2][nY])

			If	Empty(oModel:GetModel(cFolder):GetValue('ADZ_PRODUT'))                                              .AND.;
				(oModel:GetModel(cFolder):IsDeleted() .AND. Empty(oModel:GetModel(cFolder):GetValue("ADZ_ORCAME")))
				Loop
			Endif

			SE4->(DbSeek(cFilSE4 + oModel:GetModel(cFolder):GetValue("ADZ_CONDPG")))

			If 	oModel:GetModel(cFolder):GetValue("ADZ_CONDPG") <> cCodPag .OR.;
				SE4->E4_TIPO == "9"                                        .OR.;
				oModel:GetModel(cFolder):GetValue("ADZ_MOEDA") <> cMoedaPr .OR.;
				oModel:GetModel(cFolder):GetValue("ADZ_DT1VEN") <> dDiaPrim

				//Busca algum orcamento ja existente para a mesma condicao de pagamento
				If	SE4->E4_TIPO == "9"
					If !( Empty(oModel:GetModel(cFolder):GetValue("ADZ_ORCAME")) )
						nPos	:= aScan(aOrcXPgto,{|x| x[1] == oModel:GetModel(cFolder):GetValue("ADZ_ORCAME")})	//Pesquisa pelo orcamento existente
						//Se o item passou a ser tipo 9 e nao era tipo 9 antes, cria um novo Cabecalho
						If (nPos > 0) .AND. (oModel:GetModel(cFolder):GetValue("ADZ_CONDPG") <> aOrcXPgto[nPos][2])
							nPos := 0
						EndIf
					Else
						nPos := 0
					EndIf
				Else
					nPos := aScan(aOrcXPgto,{|x| x[1] == oModel:GetModel(cFolder):GetValue("ADZ_ORCAME") .AND.;
												x[3] == oModel:GetModel(cFolder):GetValue("ADZ_DT1VEN") .AND.;
												Alltrim(Str(x[4])) == oModel:GetModel(cFolder):GetValue("ADZ_MOEDA")})	//Pesquisa pela condicao de pagamento
				EndIf

				If nPos == 0
					nOpc := 3
					cOrcamento		:= GetSXENum("SCJ", "CJ_NUM")
				Else
					nOpc := 4
					cOrcamento 	:= aOrcXPgto[nPos][1]
					cCliOrc		:= aOrcXPgto[nPos][5]
					cLojOrc		:= aOrcXPgto[nPos][6]
					If	Empty(oModel:GetModel(cFolder):GetValue("ADZ_PROPOS")) .AND.;
						SE4->E4_TIPO == "9"                                    .AND.;
						oModel:GetModel(cFolder):GetValue("ADZ_MOEDA") <> "1"
						cOrcamento	:= GetSXENum("SCJ", "CJ_NUM")
					Endif
				EndIf

				cProxItem := StrZero(0, nTamCKItem)

				If	SubsTr(cEntidade,1,1) == "1" //Cliente
					cCodCli	:= cCodEnt
					cLojCli	:= cLojEnt
					If SA1->( MSSeek(cFilSA1 + cCodCli + cLojCli) )
						cNomeEn	:= SA1->A1_NOME
						If lPosTCli
							cTipoCli := SA1->A1_TIPO
						EndIf
					Else
						lRet := .F.
						Help(" ", 1, STR0429, NIL, STR0430, 1, 1,,,,,,{STR0431})	// #"Código do Cliente" #"O código do cliente/loja informado na proposta comercial não existe no cadastro de clientes, e não poderá ser utilizado no orçamento desta proposta." #"Favor informar na oportunidade/proposta comercial um código de cliente/loja válido."
						Exit
					EndIf
				Else
					cCodPro	:= cCodEnt
					cLojPro	:= cLojEnt

					aDadosPro	:= GetAdvFVal("SUS", {"US_CODCLI", "US_LOJACLI"}, cFilSUS + cCodPro + cLojPro, 1, {"", ""})

					If Empty(cCliOrc)
						cCodCli		:= aDadosPro[1]
						cLojCli		:= aDadosPro[2]
					Else
						cCodCli		:= cCliOrc
						cLojCli		:= cLojOrc
					EndIf

					If	Empty(cCodCli) //Grava como cliente padrao
						cCodCli	:= SubStr(cCliPad, 1,           nTamCli)
						cLojCli	:= SubStr(cCliPad, nTamCli + 1, nTamLoj)
					Endif

					//Cliente padrao ou convertido.
					If SA1->( MSSeek(cFilSA1 + cCodCli + cLojCli) )
						cNomeEn	:= SA1->A1_NOME
						If lPosTCli
							cTipoCli := SA1->A1_TIPO
						EndIf
					Else
						lRet := .F.
						Do Case
							Case !Empty(cCliOrc)
								Help(" ", 1, STR0429, NIL, STR0432, 1, 1,,,,,,{STR0433 + cOrcamento + "."})	//#"Código do Cliente" #"O código do cliente/loja informado no orçamento relacionado a esta proposta não existe no cadastro de clientes, e não poderá ser utilizado no orçamento desta proposta." #"Favor digitar um código de cliente/loja válido no orçamento "
							Case (Iif(Empty(aDadosPro), .F., !Empty(aDadosPro[1])))
								Help(" ", 1, STR0429, NIL, STR0434, 1, 1,,,,,,{STR0435 + cCodPro + STR0436})	//#"Código do Cliente" #"O código do cliente/loja relacionado ao prospect informado não existe no cadastro de clientes, e não poderá ser utilizado no orçamento desta proposta." #"Favor incluir no cadastro do prospect " #" um código de cliente/loja válido."							
							Otherwise
								Help(" ", 1, STR0429, NIL, STR0437, 1, 1,,,,,,{STR0438})	//#"Código do Cliente" # "O código do cliente/loja padrão informado no parâmetro (MV_ORCLIPD) não existe no cadastro de clientes, e não poderá ser utilizado no orçamento desta proposta." #"Favor cadastrar no parâmetro MV_ORCLIPD um código de cliente/loja válido."	
						End Case
						Exit
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Se for inclusao de orcamento para um prospect ja convertido³
					//³para cliente, grava apenas informacoes do cliente          ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If !Empty(cCodCli) .AND. (cCodCli <> SubStr(cCliPad, 1, nTamCli))
						cCodPro		:= ""
						cLojPro		:= ""
					EndIf
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica se existe campo de cliente e loja de entrega,³
				//³senao utiliza o codigo e loja do cliente              ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If !( Empty(oModel:GetValue("ADYMASTER", "ADY_CLIENT")) )
					cClEntr  := oModel:GetValue("ADYMASTER", "ADY_CLIENT")
					cLojEntr := oModel:GetValue("ADYMASTER", "ADY_LOJENT")
				Else
					cClEntr  := cCodCli
					cLojEntr := cLojCli
				EndIF

				nCab := aScan(aOrcamentos,{|x| x[1][1][2] == cOrcamento})

				If nCab == 0
					cTabPrcCJ	:= cTabPrc
					If	! Empty(cTabPrc)
						cCdPgTab	:= Posicione("DA0", 1, cFilDA0 + cTabPrc, "DA0_CONDPG")
						If !( Empty(cCdPgTab) ) .AND. oModel:GetModel(cFolder):GetValue("ADZ_CONDPG") <> cCdPgTab
							cTabPrcCJ	:= Space(nTamTabPrc)
						EndIf
					EndIf
					//Cabecalho do orcamento
					aCabOrc	:= {{"CJ_NUM",     cOrcamento,                                          Nil},;
								{"CJ_EMISSAO", dDataBase,                                           Nil},;
								{"CJ_CLIENTE", cCodCli,                                             Nil},;
								{"CJ_LOJA",    cLojCli,                                             Nil},;
								{"CJ_NOMCLI",  cNomeEn,                                             Nil},;
								{"CJ_PROSPE",  cCodPro,                                             Nil},;
								{"CJ_LOJPRO",  cLojPro,                                             Nil},;
								{"CJ_CLIENT",  cClEntr,                                             Nil},;
								{"CJ_LOJAENT", cLojEntr,                                            Nil},;
								{"CJ_CONDPAG", oModel:GetModel(cFolder):GetValue("ADZ_CONDPG"),     Nil},;
								{"CJ_TABELA",  cTabPrcCJ,                                           Nil},;
								{"CJ_DESC1",   0,                                                   Nil},;
								{"CJ_DESC2",   0,                                                   Nil},;
								{"CJ_DESC3",   0,                                                   Nil},;
								{"CJ_DESC4",   0,                                                   Nil},;
								{"CJ_STATUS",  "A",                                                 Nil},;
								{"CJ_FRETE",   0,                                                   Nil},;
								{"CJ_SEGURO",  0,                                                   Nil},;
								{"CJ_DESPESA", 0,                                                   Nil},;
								{"CJ_FRETAUT", 0,                                                   Nil},;
								{"CJ_MOEDA",   Val(oModel:GetModel(cFolder):GetValue("ADZ_MOEDA")), Nil},;
								{"CJ_TIPLIB",  "1",                                                 Nil},;
								{"CJ_TPCARGA", "2",                                                 Nil},;
								{"CJ_DESCONT", 0,                                                   Nil},;
								{"CJ_PDESCAB", 0,                                                   Nil},;
								{"CJ_PROPOST", cProposta,                                           Nil},;
								{"CJ_TXMOEDA", 1,                                                   Nil},;
								{"CJ_NROPOR",  cOportunida,                                         Nil},;
								{"CJ_REVISA",  cRevisao,                                            Nil}}

					If lPosTCli
						aAdd(aCabOrc,{"CJ_TIPOCLI",cTipoCli,Nil})
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Acrescenta vendedor se existir campo na tabela SCJ                      ³
					//³Foi considerado somente o Vendedor 1 visto que a oportunidade utiliza   ³
					//³somente um vendedor                                                     ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If SCJ->(ColumnPos(cCmpVend)) > 0 .And. AD1->(ColumnPos("AD1_VEND")) > 0
						aAdd(aCabOrc, {cCmpVend, oMdlAD1:GetValue("AD1_VEND"), Nil})
					EndIf
				EndIf

				SE4->(dbSeek(cFilSE4 + oModel:GetModel(cFolder):GetValue("ADZ_CONDPG")))
				If	SE4->E4_TIPO == "9"

					aTipo09 := Ft600GetTipo09() //Get do valor da variável estática
					aSort(aTipo09,,,{|x,y| x[5] < y[5] .AND. x[6] == y[6]})

					If	Len(aTipo09) > 0

						nCodTp9 := aScan(aTipo09,{|x| AllTrim(x[1]) == AllTrim(oModel:GetModel(cFolder):GetValue("ADZ_PRODUT"))	.AND.;
													AllTrim(x[5]) == AllTrim(oModel:GetModel(cFolder):GetValue("ADZ_ITEM"))		.AND.;
													AllTrim(x[6]) == AllTrim(Str(nAba,1))})
						If	nCodTp9 <> 0

							nProxItem		:= 0
							nRecLidos		:= 1
							nTotPercent	:= 0
							nUltItPerc		:= 0
							For nTp09 := 1 To nNumParc
								If	nRecLidos > nNumParc
									Exit
								Endif
								cProxParc := Soma1(cProxParc)
								If	nTp09 == 1
									nProxItem := nCodTp9
								Endif
								nRecLidos += 1
								If nProxItem                             <= Len(aTipo09)											.AND.;
								   PadR(aTipo09[nProxItem,1],nTamADZPrd) == oModel:GetModel(cFolder):GetValue("ADZ_PRODUT")	.AND.;
								   aTipo09[nProxItem,5]                  == oModel:GetModel(cFolder):GetValue("ADZ_ITEM")		.AND.;
								   aTipo09[nProxItem,6]                  == AllTrim(Str(nAba,1))									.AND.;
								   aTipo09[nProxItem,3]                  >  0
								   If AllTrim(SE4->E4_COND) = "0"
										aAdd(aCabOrc,{"CJ_PARC" + cProxParc, aTipo09[nProxItem,3], Nil})
									ElseIf AllTrim(SE4->E4_COND) = "%"
										nDecCJParc	:= GetSx3Cache("CJ_PARC" + cProxParc, "X3_DECIMAL")
										aAdd(aCabOrc,{"CJ_PARC" + cProxParc, Round(((aTipo09[nProxItem,3] / oModel:GetModel(cFolder):GetValue("ADZ_TOTAL")) * 100), nDecCJParc), Nil})
										nUltItPerc		:= Len(aCabOrc)
										nTotPercent	+= aCabOrc[nUltItPerc][02]
									EndIf
									aAdd(aCabOrc,{"CJ_DATA" + cProxParc, aTipo09[nProxItem,2], Nil})
								Else
									aAdd(aCabOrc,{"CJ_PARC" + cProxParc, 0,             Nil})
									aAdd(aCabOrc,{"CJ_DATA" + cProxParc, Ctod(" / / "), Nil})
								Endif
								nProxItem += 1
							Next nTp09
							If nUltItPerc <> 0 .AND. nTotPercent <> 100
								aCabOrc[nUltItPerc][02] += (100 - nTotPercent)
							EndIf

						Endif

						cProxParc := "0"
					Endif

				Endif

				If 	Len(aCabOrc) > 0
					aAdd(aOrcamentos,{aCabOrc,{},nOpc})
					nCab		:= Len(aOrcamentos)
					cItemAtu	:= StrZero(0, nTamCKItem)
				EndIf
				aCabOrc	:= {}
				cProxParc 	:= "0"
			Endif

			//Posiciona no cadasto de produtos
			SB1->(dbSeek(cFilSB1 + oModel:GetModel(cFolder):GetValue("ADZ_PRODUT")))
			cProxItem	:= cItemAtu
			If ValType(aOrcamentos[nCab][2]) == "A"
				aEval(aOrcamentos[nCab][2], {|x| If(Val(x[1][2]) > Val(cProxItem), cProxItem := x[1][2], "")})
			EndIf
			cProxItem		:= Soma1(cItemAtu)

			nVlrGravar		:= oModel:GetModel(cFolder):GetValue("ADZ_PRCVEN") + (oModel:GetModel(cFolder):GetValue("ADZ_VALDES") / oModel:GetModel(cFolder):GetValue("ADZ_QTDVEN"))

			cLocal			:= PadR(AllTrim(SB1->B1_LOCPAD), nTamB1LcPd)

			If nOpc == 3 .OR. (oModel:GetModel(cFolder):GetValue("ADZ_ORCAME") <> cOrcamento)
				cItem	:= cProxItem
			Else
				cItem	:= oModel:GetModel(cFolder):GetValue("ADZ_ITEMOR")
				While aScan(aOrcamentos[nCab][2], {|x| x[1][2] == cItem}) > 0
					cItem := Soma1(cItem)
				EndDo
			EndIf

			aRegs := {{"CK_ITEM",    cItem,                                           Nil},;
					{"CK_PRODUTO", oModel:GetModel(cFolder):GetValue("ADZ_PRODUT"), Nil},;
					{"CK_PROSP",   cCodPro,                                         Nil},;
					{"CK_LJPRO",   cLojPro,                                         Nil},;
					{"CK_UM",      SB1->B1_UM,                                      Nil},;
					{"CK_ITEMPRO", oModel:GetModel(cFolder):GetValue("ADZ_ITEM"),   Nil},;
					{"CK_PROPOST", cProposta,                                       Nil},;
					{"CK_NORCPMS", oModel:GetModel(cFolder):GetValue("ADZ_PMS"),    Nil},;
					{"CK_NVERPMS", oModel:GetModel(cFolder):GetValue("ADZ_PMSVER"), NIL},;
					{"CK_DT1VEN",  oModel:GetModel(cFolder):GetValue("ADZ_DT1VEN"), Nil},;
					{"CK_LOCAL",   cLocal,                                          Nil},;
					{"CK_CLIENTE", cCodCli,                                         Nil},;
					{"CK_LOJA",    cLojCli,                                         Nil},;
					{"CK_NUM",     cOrcamento,                                      Nil},;
					{"CK_DESCRI",  oModel:GetModel(cFolder):GetValue("ADZ_DESCRI"), Nil},;
					{"CK_ENTREG",  dDataBase,                                       Nil},;
					{"CK_PRUNIT",  oModel:GetModel(cFolder):GetValue("ADZ_PRCTAB"), Nil},;
					{"CK_QTDVEN",  oModel:GetModel(cFolder):GetValue("ADZ_QTDVEN"), Nil},;
					{"CK_FOLDER",  oModel:GetModel(cFolder):GetValue("ADZ_FOLDER"), Nil}}

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Se há desconto, uma ordem diferente deve ser adicionada, para³
			//³que o desconto seja considerado.                             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If oModel:GetModel(cFolder):GetValue("ADZ_VALDES") > 0 .Or. oModel:GetModel(cFolder):GetValue("ADZ_DESCON") > 0
				aAdd(aRegs,{"CK_PRCVEN",  nVlrGravar,                                      Nil})
				aAdd(aRegs,{"CK_DESCONT", oModel:GetModel(cFolder):GetValue("ADZ_DESCON"), Nil})
				aAdd(aRegs,{"CK_VALDESC", oModel:GetModel(cFolder):GetValue("ADZ_VALDES"), Nil})
				aAdd(aRegs,{"CK_TES",     oModel:GetModel(cFolder):GetValue("ADZ_TES"),    Nil})
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Em outros casos, ou no caso de alteração manual do preço³
				//³unitário, a ordem dos campos deve ser essa.             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Else
				aAdd(aRegs,{"CK_DESCONT", oModel:GetModel(cFolder):GetValue("ADZ_DESCON"), Nil})
				aAdd(aRegs,{"CK_VALDESC", oModel:GetModel(cFolder):GetValue("ADZ_VALDES"), Nil})
				aAdd(aRegs,{"CK_TES",     oModel:GetModel(cFolder):GetValue("ADZ_TES"),    Nil})
				aAdd(aRegs,{"CK_PRCVEN",  nVlrGravar,                                      Nil})
			EndIf

			aAdd(aRegs,{"AUTDELETA", If(oModel:GetModel(cFolder):IsDeleted(),"S",""),	 Nil})

			//Soma os itens deletados
			nRec += 1

			If	aRegs[aScan(aRegs, {|x| AllTrim(x[1]) == "AUTDELETA"}), 2] == "S"
				nRecDel += 1
			Endif

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica se o item deve ser apagado no orcamento de origem³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !( Empty(oModel:GetModel(cFolder):GetValue("ADZ_ORCAME")) ) .AND. ( oModel:GetModel(cFolder):GetValue("ADZ_ORCAME") <> cOrcamento )

				//Copia o registro a ser apagado
				aAdd(aItemDel, aClone(aRegs))
				nPos	:= Len(aItemDel)

				//Forca a delecao da linha
				If (nX := aScan(aItemDel[nPos], {|x| x[1]=="AUTDELETA"})) > 0
					aItemDel[nPos][nX][2] := "S"
				Else
					aAdd(aItemDel[nPos],{"AUTDELETA","S",Nil})
				EndIf

				//Grava o codigo do orcamento original
				If (nX := aScan(aItemDel[nPos],{|x|x[1]=="CK_NUM"})) >0
					aItemDel[nPos][nX][2] := oModel:GetModel(cFolder):GetValue("ADZ_ORCAME")
				Else
					aAdd(aItemDel[nPos], {"CK_NUM", oModel:GetModel(cFolder):GetValue("ADZ_ORCAME"), Nil})
				EndIf

				//Grava o item do orcamento original
				If (nX := aScan(aItemDel[nPos],{|x|x[1]=="CK_ITEM"})) >0
					aItemDel[nPos][nX][2] := oModel:GetModel(cFolder):GetValue("ADZ_ITEMOR")
				Else
					AAdd(aItemDel[nPos], {"CK_ITEM", oModel:GetModel(cFolder):GetValue("ADZ_ITEMOR"), Nil})
				EndIf

			EndIf

			cCodPag 	:= oModel:GetModel(cFolder):GetValue("ADZ_CONDPG")
			cMoedaPr	:= oModel:GetModel(cFolder):GetValue("ADZ_MOEDA")
			dDiaPrim	:= oModel:GetModel(cFolder):GetValue("ADZ_DT1VEN")

			SE4->(dbSeek(cFilSE4 + oModel:GetModel(cFolder):GetValue("ADZ_CONDPG")))
			aAdd(aOrcamentos[nCab][2], aClone(aRegs))
			aSort(aOrcamentos[nCab][2],,, {|a,b| a[1,2] < b[1,2]}) //Ordena os itens do orcamento
			aRegs := {}

			//Atualiza o orcamento de destino do produto
			oModel:GetModel(cFolder):SetValue("ADZ_ORCAME", cOrcamento)
			oModel:GetModel(cFolder):SetValue("ADZ_ITEMOR", cItem)

		Next nY

	Next nZ
	
	If !lRet
		Exit
	EndIf

Next nAba

If lRet

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Ordena os itens do orcamento³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSort(aOrcamentos[nCab][2],,,{|a,b| a[1,2] < b[1,2] })

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Inclui os registros que devem ser apagados nos itens da³
	//³execauto                                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nX := 1 to Len(aItemDel)

		//Posicao do codigo do orcamento
		nPosOrc	:= aScan(aItemDel[nX],{|x|x[1]=="CK_NUM"})
		nPosItem 	:= aScan(aItemDel[nX],{|x|x[1]=="CK_ITEM"})
		cOrcamento	:= aItemDel[nX][nPosOrc][2]
		cItem		:= aItemDel[nX][nPosItem][2]
		lIncDel	:= .T.

		//Pesquisa o orcamento a ter o item incluido
		nCab		:= aScan(aOrcamentos,{|x| x[1][1][2] == cOrcamento })

		If nCab > 0

			//Verifica se existe um item valido com o mesmo numero do item a ser deletado
			For nY := 1 to Len(aOrcamentos[nCab][2])
				nPosItem 	:= aScan(aOrcamentos[nCab][2][nY],{|x|x[1]=="CK_ITEM"})
				If aOrcamentos[nCab][2][nY][nPosItem][2] == cItem
					lIncDel	:= .F.
					Exit
				EndIf
			Next nY

			//Inclui o item que deve ser removido
			If lIncDel
				AAdd(aOrcamentos[nCab][2],aClone(aItemDel[nX]))
			EndIf

		Else

			//Exclui todo o orcamento
			aAdd(aOrcDCab,{"CJ_NUM",  cOrcamento	,Nil})
			//Devido o campo ser obrigatorio na copia da proposta o orçamento nao era excluido
			If lPosTCli
				//Da preferencia para o tipo de cliente gravado no orcamento
				cTipoCliP := Posicione("SCJ", 1, cFilSCJ + cOrcamento, "CJ_TIPOCLI")
				If !Empty( cTipoCliP )
					cTipoCli := cTipoCliP
				EndIf
				aAdd(aOrcDCab,{"CJ_TIPOCLI",cTipoCli,Nil})
			EndIf

			aAdd(aOrcamentos,{aOrcDCab,{},5})

			If lIncDel
				AAdd(aOrcamentos[Len(aOrcamentos)][2],aClone(aItemDel[nX]))
			EndIf

		EndIf

	Next nX

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se todos os itens do orcamento serao apagados³
	//³Se sim, executa a exclusao de todo o orcamento        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nX := 1 to Len(aOrcamentos)

		lDelOrc := .T.

		//Pula os orcamentos que ja serao apagados
		If aOrcamentos[nX][3] <> 5
			For nY := 1 to Len(aOrcamentos[nX][2])
				nPosDel := aScan(aOrcamentos[nX][2][nY],{|x|x[1]=="AUTDELETA"})
				If nPosDel > 0 .AND. aOrcamentos[nX][2][nY][nPosDel][2] <> "S"
					lDelOrc := .F.
				EndIf
			Next nY
		EndIf

		//Se todos os itens estao deletados, deleta o orcamento
		If lDelOrc
			aOrcamentos[nX][3] := 5
		EndIf

	Next nX

	Begin Transaction
		nX := 1
		While  nX <= Len(aOrcamentos) .AND.  !lMsErroAuto
			//Valida se todos os itens estao deletados
			If	nRecDel == nNumItem
				DisarmTransaction()
				MsgAlert(STR0053,STR0019) //"Não é permitida a exclusão de todos os itens da proposta !"###"Atenção"
				nRecDel	:= 0
				Return(.F.)
			Endif

			aCols := Nil
			MSExecAuto({|x,y,z| Mata415(x,y,z)}, aOrcamentos[nX][1], aOrcamentos[nX][2], aOrcamentos[nX][3])

			If	lMsErroAuto
				lRet := .F.
				DisarmTransaction()
				MostraErro()
			Else
				If	Len(aOrcamentos[nX][2]) > 0
					A600VdOp(cOportunida, cRevisao, aOrcamentos[nX][1][1][2], aOrcamentos[nX][2], aProdutos, oModel, cProposta)
				Endif
			EndIf
			nX++
		EndDo

		If 	lRet .AND. !Empty(cProposta)

			If	(IsInCallStack("FATA300") .OR. IsInCallStack("CRMA110"))
				cVend		:= oMdlAD1:GetValue("AD1_VEND")
				cProsp		:= oMdlAD1:GetValue("AD1_PROSPE")
				cLojPro	:= oMdlAD1:GetValue("AD1_LOJPRO")
			Else
				cFilAD1 := AD1->(DbFilter())
				AD1->(DbClearFilter())
				AD1->(DbSetOrder(1))//AD1_FILIAL+AD1_NROPOR+AD1_REVISA
				AD1->(DbSeek(xFilial("AD1") + cOportunida))
				cVend		:= AD1->AD1_VEND
				cProsp		:= AD1->AD1_PROSPE
				cLojPro	:= AD1->AD1_LOJPRO
				If !Empty(cFilAD1)
					DbSelectArea("AD1")
					Set Filter To &cFilAD1
				EndIf
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Cria o vinculo de amarracao de orcamento do cliente para o³
			//³vendedor(Tabela ADL)                                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Ft520InsPr(nOpc, cVend, "SUS", cProsp, cLojPro, cProposta, cOportunida + cRevisao)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica o status dos orcamentos - Se um orcamento ficar³
			//³bloqueado por regra, bloqueia todos os outros           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			SCJ->(DbSetOrder(4))//CJ_FILIAL+CJ_PROPOST
			SCJ->(DbSeek(cFilSCJ + cProposta))
			While SCJ->(! Eof()) .AND. SCJ->CJ_FILIAL	== cFilSCJ .AND. SCJ->CJ_PROPOST	== cProposta .AND. !lOrcBloq
				If SCJ->CJ_STATUS == "F"
					lOrcBloq := .T.
				EndIf
				aAdd(aRecSCJ, SCJ->(Recno()))
				SCJ->(DbSkip())
			EndDo

			If lOrcBloq
				For nX := 1 to Len(aRecSCJ)
					SCJ->(DbGoTo(aRecSCJ[nX]))
					RecLock("SCJ",.F.)
					SCJ->CJ_STATUS := "F"
					MsUnLock()
				Next nX
			EndIf
		EndIf

	End Transaction

EndIf

While GetSX8Len() > nLenSX8
	If lRet
		ConfirmSX8()
	Else
		RollBackSX8()
	EndIf
EndDo

RestArea(aArea)
Return(lRet)

//-------------------------------------------------------------------
/*/{Protheus.doc} A600CroFinance
Atualiza o cronograma financeiro

@author luiz.jesus
@since 18/03/2014
@version 1.0
/*/
//-------------------------------------------------------------------
Function A600CroFinance( oModel, lLoad, aLoadCro )

Local aArea			:= GetArea()
Local aVencto 		:= {}
Local aCronoAtu		:= {}
Local nC			:= 0
Local nA			:= 0
Local nS			:= 0
Local nI			:= 0
Local nPosData		:= 0
Local cSequencia	:= SuperGetMv("MV_1DUP")
Local nPosProd 		:= 0
Local nPosTot 		:= 0
Local nPosCond 		:= 0
Local nPos1Venc		:= 0
Local nProd			:= 0
Local nPosMoeda		:= 0
Local nNewTotal		:= 0
Local aProdutos		:= {}
Local lAdCronograma	:= .T.
Local oMdlPrd		:= Nil
Local aModelPrd 	:= {}
Local oMdlAces		:= Nil
Local aModelAces 	:= {}
Local dDayOne		:= dDataBase
Local aTipo09		:= {}
Local aCronoFin		:= {}
Local aIsInCrono	:= {}
Local cFilSE4		:= xFilial("SE4")

Default lLoad		:= .F.
Default oModel		:= Nil
Default aLoadCro	:= {}

//Precisa ativar o model quando não está no load do model
If !lLoad
	oModel 		:= FwModelActive()
EndIf

oMdlPrd		:= oModel:GetModel('ADZPRODUTO')
aModelPrd	:= oMdlPrd:GetOldData()

nPosProd 	:= aScan( aModelPrd[1], { |x| Alltrim(x[2]) == "ADZ_PRODUT" } )
nPosTot 	:= aScan( aModelPrd[1], { |x| Alltrim(x[2]) == "ADZ_TOTAL" } )
nPosCond 	:= aScan( aModelPrd[1], { |x| Alltrim(x[2]) == "ADZ_CONDPG" } )
nPos1Venc	:= aScan( aModelPrd[1], { |x| Alltrim(x[2]) == "ADZ_DT1VEN" } )
nPosMoeda	:= aScan( aModelPrd[1], { |x| Alltrim(x[2]) == "ADZ_MOEDA" } )

aadd(aProdutos,A600Pack(oModel) )

For nS := 1 TO Len(aProdutos)	//Folder Produto(s)

	For nI := 1 To Len(aProdutos[nS])

		lAdCronograma := .T.

		dbSelectArea("SE4")
		dbSetOrder(1)
		IF	dbSeek(cFilSE4+aProdutos[nS][nI][nPosCond])

			//---------------------------------------------------------------------------------
			// Ponto de Entrada para tratar produtos a serem considerados no Cronograma
			// Financeiro.
			//---------------------------------------------------------------------------------
			If	( _lFT600CRO )
				lAdCronograma := ExecBlock( 'FT600CRO', .F., .F., { aProdutos[nS][nI][nPosProd], oModel, nS, nI } )

				If 	( ValType( lAdCronograma ) <> 'L' )
					lAdCronograma := .T.
				Else
					AAdd(aIsInCrono, {aProdutos[nS][nI][nPosProd], lAdCronograma} )
				EndIf
			Endif

			//Converte o valor de acordo com a moeda escolhida
			nNewTotal := A600CroTot(aProdutos[nS][nI][nPosTot], aProdutos[nS][nI][nPosMoeda] )

			If	SE4->E4_TIPO <> "9" .AND. lAdCronograma

				//Se MV_ALTERCR .T. considerar 1° Vencimento como data para calcular parcelas
				If _lAlterCron .And. !Empty(aProdutos[nS][nI][nPos1Venc])
					dDayOne := DataValida( aProdutos[nS][nI][nPos1Venc], .T. )
				EndIf
				//Atualiza cronograma financeiro para condicao diferente do tipo 9
				aVencto := Condicao(nNewTotal,aProdutos[nS][nI][nPosCond],0,dDayOne,0)

				For nA := 1 To Len(aVencto)

					If	!Empty(aProdutos[nS][nI][nPos1Venc]) .AND. aProdutos[nS][nI][nPos1Venc] <> dDataBase .AND. nA == 1
						aVencto[nA,1] := aProdutos[nS][nI][nPos1Venc]
					Endif

					nPosData := aScan( aCronoAtu, { |x| x[1] == aVencto[nA,1] } )

					If	nPosData == 0
						aadd(aCronoAtu,{aVencto[nA,1],aVencto[nA,2]})
					Else
						aCronoAtu[nPosData,2] += aVencto[nA,2]
					Endif

				Next nA

			Endif

		Endif

	Next nI

Next nS

//Atualiza cronograma financeiro para condicao de pagamento tipo 9
aTipo09 := Ft600GetTipo09() //Get do valor da variável estática

If	Len(aTipo09) > 0

	For nA := 1 To Len(aTipo09)
		nProd := aScan(  aIsInCrono, { |x| x[1] == aTipo09[nA,1] } )
		If nProd > 0
			lAdCronograma := aIsInCrono[nProd,2]
		Else
			lAdCronograma := .T.
		EndIf

		If	lAdCronograma
			IF	Len(aCronoAtu) > 0
				nPosData := aScan( aCronoAtu, { |x| x[1] == aTipo09[nA,2] } )
			Else
				nPosData := 0
			Endif

			If	nPosData == 0
				aadd(aCronoAtu,{aTipo09[nA,2],aTipo09[nA,3]})
			Else
				aCronoAtu[nPosData,2] += aTipo09[nA,3]
			Endif
		Endif

	Next nA

Endif

aCronoAtu := FT600VENCATU(aCronoAtu)

//Ordena as parcelas pela data de vencimento
aCronoAtu := ASort(aCronoAtu,,,{|parc1,parc2|parc1[1]<parc2[1]})

//Atualiza cronograma financeiro
For nC := 1 To Len(aCronoAtu)

	If	nC == 1
		aadd(aCronoFin,{"",CtoD(Space(8)),0})
		aCronoFin[nC,1] := cSequencia
		aCronoFin[nC,2] := aCronoAtu[nC,1]
		aCronoFin[nC,3] := aCronoAtu[nC,2]
	Else
		cSequencia := MaParcela(cSequencia)
		AAdd(aCronoFin,{cSequencia,aCronoAtu[nC,1],aCronoAtu[nC,2] })
	Endif

Next nC

//Atualiza a tela
A600Total(aCronoFin,oModel,lLoad,@aLoadCro)

RestArea(aArea)

Return Nil

//-------------------------------------------------------------------
/*/{Protheus.doc} A600Total
Atualiza na tela as parcelas do cronograma financeiro

@author luiz.jesus

@since 18/03/2014
@version 1.0
/*/
//-------------------------------------------------------------------
Function A600Total(aCronoFin, oModel, lLoad, aLoadCro)

Local oMdlCron	:= Nil
Local oMdlProd	:= Nil
Local oMdlAces	:= Nil
Local nX			:= 0
Local nLine		:= 0
Local aRetPE		:= {}
Local nOperation	:= 0
Local nPosition	:= 0
Local nTmE1PARCEL	:= GetSX3Cache("E1_PARCELA","X3_TAMANHO")

Default aCronoFin	:= {}
Default oModel	:= FwModelActive()
Default lLoad		:= .F.
Default aLoadCro	:= {}

nOperation	:= oModel:GetOperation()

If nOperation <> MODEL_OPERATION_DELETE

	If ( _lFt600Tot )
		aRetPE	:= ExecBlock('FT600TOT', .F., .F., {oModel, aCronoFin})
		If ( ValType(aRetPE) == 'A' )
			aCronoFin	:= aClone(aRetPE)
		EndIf
	EndIf

	oMdlProd	:= oModel:GetModel("ADZPRODUTO")
	oMdlAces	:= oModel:GetModel("ADZACESSOR")
	oMdlCron	:= oModel:GetModel("CRONOFIN")
	nPosition	:= oMdlCron:GetLine()

	If Empty(aCronoFin)

		If !( oMdlCron:IsEmpty() )                                                                              .AND.;
		   ( ( oMdlProd:IsEmpty() .AND. oMdlAces:IsEmpty() )                                                    .OR.;
		     ( !( oMdlProd:IsEmpty() ) .AND. oMdlProd:Length() == 1 .AND. oMdlProd:GetValue("ADZ_TOTAL") == 0 ) .OR.;
		     ( !( oMdlAces:IsEmpty() ) .AND. oMdlAces:Length() == 1 .AND. oMdlAces:GetValue("ADZ_TOTAL") == 0 ) .OR.;
		     IsInCallStack('Ft600Folcg') )
			// Caso o Cronograma Financeiro possua parcelas, e não existam produtos/acessórios informados com valores, o cronograma é eliminado do modelo.

			//Habilito a edição
			oMdlCron:SetNoInsertLine(.F.)
			oMdlCron:SetNoDeleteLine(.F.)
			oMdlCron:SetNoUpdateLine(.F.)

			//Deleta todas as linhas para evitar duplicação
			For nX := oMdlCron:Length() To 1 Step -1
				If nX > 1
					oMdlCron:GoLine(nX)
					oMdlCron:DeleteLine(.T.,.T.)
				Else
					oMdlCron:LoadValue('ZYY_PARCE', Space(nTmE1PARCEL))
					oMdlCron:LoadValue('ZYY_VENC',  CtoD(Space(08)))
					oMdlCron:LoadValue('ZYY_TOTAL', 0)
				EndIf
			Next nX

			//Desabilito a Edição
			oMdlCron:SetNoInsertLine(.T.)
			oMdlCron:SetNoDeleteLine(.T.)
			oMdlCron:SetNoUpdateLine(.T.)

		EndIf

	Else

		//Habilito a Edição
		oMdlCron:SetNoInsertLine(.F.)
		oMdlCron:SetNoDeleteLine(.F.)
		oMdlCron:SetNoUpdateLine(.F.)

		If	! lLoad
			//Deleta todas as linhas para evitar duplicação
			For nX := oMdlCron:Length() To 1 Step -1
				If nX > 1
					oMdlCron:GoLine(nX)
					oMdlCron:DeleteLine(.T.,.T.)
				EndIf
			Next nX
		EndIf

		//Atualiza as Linhas do CRONOFIN Financeiro
		For nX := 1 To Len(aCronoFin)
			nLine := If( nX == 1, nX, oMdlCron:AddLine(.T.) )
			oMdlCron:GoLine(nLine)
			oMdlCron:LoadValue('ZYY_PARCE', aCronoFin[nX][1])
			oMdlCron:LoadValue('ZYY_VENC',  aCronoFin[nX][2])
			oMdlCron:LoadValue('ZYY_TOTAL', aCronoFin[nX][3])
		Next nX

		//Desabilito a Edição
		oMdlCron:SetNoInsertLine(.T.)
		oMdlCron:SetNoDeleteLine(.T.)
		oMdlCron:SetNoUpdateLine(.T.)

	EndIf
	oMdlCron:GoLine(nPosition)

EndIf
Return(.T.)

//------------------------------------------------------------------------------
/*/{Protheus.doc} IsItOrcServ
	 Identifica se há algum orçamento de serviço vinculado ao item da proposta

@sample		IsItOrcServ()

@since		30/09/2013
@version	P11.90

@param 		cItem, Char, código do item a ser validado

@return 	lRet, Logico, indica se o item é ou não vinculado a um orçamento de serviços
/*/
//------------------------------------------------------------------------------
Function IsItOrcServ( cItem )

Local aCposItem 	:= { 'TFJ_ITEMRH', 'TFJ_ITEMMI', 'TFJ_ITEMMC', 'TFJ_ITEMLE' }
Local nX 			:= 0
Local lRet 		:= .F.
Local cProp 		:= FwFldGet( "ADY_PROPOS" )
Local cPRev 		:= FwFldGet( "ADY_PREVIS" )

Default cItem 	:= ''

TFJ->(DbSetOrder(2))  // TFJ_FILIAL + TFJ_PROPOS + TFJ_PREVIS
If !Empty(cItem) .And. !IsInCallStack("DelDadosOrc") .And. TFJ->( DbSeek( xFilial("TFJ")+cProp+cPRev ) )
	For nX := 1 To Len( aCposItem )
		If TFJ->(&(aCposItem[nX])) == cItem
			lRet := .T.
			Exit
		EndIf
	Next nX
EndIf

Return lRet

//------------------------------------------------------------------------------
/*/{Protheus.doc} At600OrcView
	Função para exibir o orçamento de serviços

@sample			At600OrcView

@since			14/11/2013
@version		P11.90
/*/
//------------------------------------------------------------------------------
Function At600OrcView( nOpc, lVistoria, lAutomato, bSemTela, cCodVis)

Local lSeekOrc := .F.
Local lOrcPrc	 := SuperGetMv("MV_ORCPRC",,.F.)
Local cOrcMod	 := If( lOrcPrc, "TECA740F", "TECA740" )

Default lVistoria := .F.
Default lAutomato	:= .F.
Default bSemTela	:= {|| .T.}
Default cCodVis		:= ""

If lAutomato

	If lVistoria
		DbSelectArea('TFJ')
		TFJ->( DbSetOrder( 6 ) ) //TFJ_FILIAL + TFJ_CODVIS
		lSeekOrc := TFJ->( DbSeek( xFilial('TFJ')+cCodVis ) )
	Else
		TFJ->( DbSetOrder( 2 ) ) //TFJ_FILIAL + TFJ_PROPOS + TFJ_REVIS
		lSeekOrc := TFJ->( DbSeek( xFilial('TFJ')+FwFldGet("ADY_PROPOS")+FwFldGet("ADY_PREVIS") ) )
	Endif

		At600STabPrc( TFJ->TFJ_CODTAB, TFJ->TFJ_TABREV )

		oModel := FwLoadModel(cOrcMod)
		oModel:SetOperation(MODEL_OPERATION_VIEW)
		oModel:Activate()

	If lSeekOrc
		lRet := Eval( bSemTela, oModel )
	EndIf
Else
	If lVistoria
		DbSelectArea('TFJ')
		TFJ->( DbSetOrder( 6 ) ) //TFJ_FILIAL + TFJ_CODVIS
		lSeekOrc := TFJ->( DbSeek( xFilial('TFJ')+M->AAT_CODVIS ) )
	Else
		TFJ->( DbSetOrder( 2 ) ) //TFJ_FILIAL + TFJ_PROPOS + TFJ_REVIS
		lSeekOrc := TFJ->( DbSeek( xFilial('TFJ')+FwFldGet("ADY_PROPOS")+FwFldGet("ADY_PREVIS") ) )
	Endif

	At600STabPrc( TFJ->TFJ_CODTAB, TFJ->TFJ_TABREV )

	If lSeekOrc

		At740FMsg( .F. )
		FWExecView( STR0209,"VIEWDEF." + cOrcMod, MODEL_OPERATION_VIEW, /*oDlg*/, {||.T.} /*bCloseOk*/, ;  // 'Orçamento Serviços'
										{||.T.}/*bOk*/,/*nPercRed*/,/*aButtons*/, {||.T.}/*bCancel*/ )
		At740FMsg( .T. )

	Else
		MsgInfo( STR0210, STR0069 )  // 'Não existe Orçamento de Serviços para essa Proposta/Revisão' ### 'Atenção!'
	EndIf
EndIf

Return

//------------------------------------------------------------------------------
/*/{Protheus.doc} At600SeAtu

Exclusão do Orçamento de Serviços

@sample			At600SeAtu

@since			19/09/2013
@version		P11.90
/*/
//------------------------------------------------------------------------------
Function At600SeAtu( nOpc, lVistoria, oMdlVis )

Local lRet       := .T.
Local lSeekOrc   := .F.
Local aErro      := {}
Local lConfirm   := .F.
Local lAltBkp    := Altera
Local lIncBkp    := Inclui
Local lCpyDados  := .F.
Local lConPrc    := .F.
Local xAux       	:= Nil
Local lOrcPrc	  	:= SuperGetMv("MV_ORCPRC",,.F.)
Local lGSRH := GSGetIns("RH")
Local lExeOrc		:= !lOrcPrc	// Verifica se executa o modelo antigo
Local cOrcMod
Local oOrcServico 	:= Nil
Local lContinua 	:= .T.
Local lOk			:= .T.
Local lHasOrcSmp := HasOrcSimp()

Private nSaveSx8Len := GetSx8Len()  // controle dos locks de sxe/sxf

Default nOpc		 := 0
Default lVistoria := .F.
Default oMdlVis   := Nil

If lOrcPrc 
	cOrcMod := "TECA740F" 	// Orçamento com novo modelo de precificação
Else
	cOrcMod := "TECA740" 	// Orçamento de serviços comum
EndIf

//Ativa o model para recupera-lo depois
oMdlProp	:= FwModelActive()

// -------------------------------
//  Inicializa o conteúdo sempre que a janela for chamada
aSize( aPosItensOrc, 0)
aPosItensOrc := {}

At740FMsg( .F. ) // Desabilita as mensagens para o novo modelo de precificação

DbSelectArea('TFJ')

If lVistoria
	TFJ->( DbSetOrder( 6 ) ) //TFJ_FILIAL + TFJ_CODVIS
	lSeekOrc := TFJ->( DbSeek( xFilial('TFJ')+M->AAT_CODVIS ) )
Else
	TFJ->( DbSetOrder( 2 ) ) //TFJ_FILIAL + TFJ_PROPOS + TFJ_REVIS
	lSeekOrc := TFJ->( DbSeek( xFilial('TFJ')+FwFldGet("ADY_PROPOS") + FwFldGet("ADY_PREVIS") ) )
Endif

If lSeekOrc
	nOpc 		:= MODEL_OPERATION_UPDATE
	lCpyDados 	:= .T.
	At600STabPrc( TFJ->TFJ_CODTAB, TFJ->TFJ_TABREV )
ElseIf lHasOrcSmp .And. SuperGetMV('MV_ORCSIMP',,'2') == '1' .AND. !IsInCallStack("TECA270")
	MsgInfo(STR0426, STR0069)
	lOk := .F.
Else
	nOpc := MODEL_OPERATION_INSERT
EndIf

// Atualiza as informações para o novo modelo de precificação
// Informando o codigo da tabela e sua revisão
If lOk
	If lOrcPrc 
		If (!Empty(TFJ->TFJ_CODTAB) .Or. nOpc == 3)
			If Empty(cPrcOrc) .And. Empty(cRevPrc)  .and. lGSRH
				lConPrc := Conpad1( NIL, NIL, NIL, "TV6" )
				If lConPrc
					If At740fchk( TV6->TV6_NUMERO, TV6->TV6_REVISA )
						At600STabPrc( TV6->TV6_NUMERO, TV6->TV6_REVISA )
					Else
						lContinua := .F.
					EndIf
				EndIf
			EndIf
			If lGSRH
				lExeOrc := (!Empty(cPrcOrc) .Or. !Empty(cRevPrc))  // Verifica tabela e revisao para execução
			Else
				lExeOrc := .T.
			EndIf
			If !lExeOrc
				Help(,,"TABPRCINVLD",,STR0314,1,0) // "Tabela de precificação invalida! Não sera possivel carregar o orçamento de serviços."
			EndIf
		Else
			Help(,,"FT600VTPC1",,STR0427,1,0)  // "Orçamento gerado sem tabela de precificação, desabilite o parametro MV_ORCPRC para abrir o orçamento desta proposta!"
		EndIf
	Else
		
		// caso tenha criado o orçamento com tabela de precificação e esteja tentanto alterá-lo com tabela
		If lSeekOrc .And. !Empty(TFJ->TFJ_CODTAB)
			lContinua := .F.
			Help(,,"FT600VTPC2",,STR0428,1,0)  // "Orçamento gerado com tabela de precificação, habilite o parametro MV_ORCPRC para abrir o orçamento desta proposta!"
		EndIf
	EndIf

	//-------------------------------------------------------------------------------------------------
	//  Condiciona a abertura do orçamento de serviços
	// com a opção selecionada no menu para oportunidade e proposta (visualizar, alterar, incluir, etc)
	//-------------------------------------------------------------------------------------------------
	If !lCpyDados
		oOrcServico := FwLoadModel(cOrcMod)
	//------------------------------------------------------------------------------------------------
	//  Caso o model esteja ativo, é pq está sendo realizada uma segunda abertura da interface
	// sem ter ocorrido a gravação dos dados do modelo, por isso executa uma cópia dos dados
	// para um outro modelo e ao final voltará a preencher os dados com
	//------------------------------------------------------------------------------------------------
	Else
		If oOrcServico == Nil
			oOrcServico := FwLoadModel(cOrcMod)
			oOrcServico:SetOperation( nOpc )
			lRet := oOrcServico:Activate()
		ElseIf !oOrcServico:lActivate
			oOrcServico:Destroy()
			oOrcServico := FwLoadModel(cOrcMod)
			oOrcServico:SetOperation( nOpc )
			lRet := oOrcServico:Activate()
		EndIf

		If !lVistoria
			If lRet
				//---------------------------------------------------------
				//  Captura as informações atuais dos itens já atualizados na proposta
				// aPosItensOrc[ campoProd, Prod, campoItem, Item, mudou? ]
				aAdd( aPosItensOrc, { 'TFJ_GRPRH', oOrcServico:GetModel('TFJ_REFER'):GetValue('TFJ_GRPRH'), 'TFJ_ITEMRH', oOrcServico:GetModel('TFJ_REFER'):GetValue('TFJ_ITEMRH'), .F. } )
				aAdd( aPosItensOrc, { 'TFJ_GRPMI', oOrcServico:GetModel('TFJ_REFER'):GetValue('TFJ_GRPMI'), 'TFJ_ITEMMI', oOrcServico:GetModel('TFJ_REFER'):GetValue('TFJ_ITEMMI'), .F. } )
				aAdd( aPosItensOrc, { 'TFJ_GRPMC', oOrcServico:GetModel('TFJ_REFER'):GetValue('TFJ_GRPMC'), 'TFJ_ITEMMC', oOrcServico:GetModel('TFJ_REFER'):GetValue('TFJ_ITEMMC'), .F. } )
				aAdd( aPosItensOrc, { 'TFJ_GRPLE', oOrcServico:GetModel('TFJ_REFER'):GetValue('TFJ_GRPLE'), 'TFJ_ITEMLE', oOrcServico:GetModel('TFJ_REFER'):GetValue('TFJ_ITEMLE'), .F. } )
				At740SLoad( oOrcServico ) // atribui o model com o conteúdo copiado para carga na view da rotina
			Else
				Ft600ErroMvc( oOrcServico )
			EndIf
		EndIf
	EndIf

	nOpcOrc := 0

	If oOrcServico <> Nil
		If lRet
			At740SCmt( .T. )
			If oOrcServico:lActivate .And. (lVistoria .Or. lOrcPrc)
				If lSeekOrc
					nOpcOrc := MODEL_OPERATION_UPDATE
				Else
					nOpcOrc := MODEL_OPERATION_INSERT
				EndIf
			Else
				nOpcOrc := MODEL_OPERATION_INSERT
			EndIf

			At740FMsg( .T. )
			If nOpc == MODEL_OPERATION_INSERT
				If !oOrcServico:lActivate
					oOrcServico:SetOperation(nOpcOrc)
					oOrcServico:Activate()
				EndIf

				If lVistoria
					lRet := lRet .And. oOrcServico:SetValue( 'TFJ_REFER', 'TFJ_ENTIDA', M->AAT_ENTIDA )
					lRet := lRet .And. oOrcServico:SetValue( 'TFJ_REFER', 'TFJ_CODENT', M->AAT_CODENT )
					lRet := lRet .And. oOrcServico:SetValue( 'TFJ_REFER', 'TFJ_LOJA'  , M->AAT_LOJENT )
					lRet := lRet .And. oOrcServico:SetValue( 'TFJ_REFER', 'TFJ_CODVIS', M->AAT_CODVIS )
					If lHasOrcSmp .AND.  SuperGetMv("MV_ORCSIMP",,"2") == "1"
						lRet := lRet .And. oOrcServico:SetValue( 'TFJ_REFER', 'TFJ_VEND', M->AAT_VEND )
					EndIf
				Else
					
					lRet := lRet .And. oOrcServico:SetValue( 'TFJ_REFER', 'TFJ_PROPOS', oMdlProp:GetModel('ADYMASTER'):GetValue("ADY_PROPOS") )
					lRet := lRet .And. oOrcServico:SetValue( 'TFJ_REFER', 'TFJ_PREVIS', oMdlProp:GetModel('ADYMASTER'):GetValue("ADY_PREVIS") )

					lRet := lRet .And. oOrcServico:SetValue( 'TFJ_REFER', 'TFJ_ENTIDA', oMdlProp:GetModel('ADYMASTER'):GetValue("ADY_ENTIDA") )
					lRet := lRet .And. oOrcServico:SetValue( 'TFJ_REFER', 'TFJ_CODENT', oMdlProp:GetModel('ADYMASTER'):GetValue("ADY_CODIGO") )
					lRet := lRet .And. oOrcServico:SetValue( 'TFJ_REFER', 'TFJ_LOJA'  , oMdlProp:GetModel('ADYMASTER'):GetValue("ADY_LOJA") )

					lRet := lRet .And. oMdlProp:GetModel('ADYMASTER'):SetValue("ADY_TPCONT","4")
				EndIf
			EndIf

			At740SLoad( oOrcServico )

			If lExeOrc 
				N600SetVis(lVistoria,oMdlVis)

				lConfirm := ( FWExecView( STR0209, "VIEWDEF." + cOrcMod, nOpcOrc, /*oDlg*/, {||.T.} /*bCloseOk*/, ;  // 'Orçamento Serviços'
										{||.T.}/*bOk*/,/*nPercRed*/,/*aButtons*/, {||.T.}/*bCancel*/ ,,,) == 0 )
			EndIf

			At740FMsg( .F. )
			At740SLoad( Nil )
			// devolve o modelo da proposta comercial como o ativo
			FwModelActive(oMdlProp)

			If lConfirm
				At740SCmt( .T. )
				lRemOrcServ := .F.
			EndIf
		EndIf
	EndIf
EndIf

Altera    := lAltBkp // bkp é necessário por que a execview altera o conteúdo
Inclui    := lIncBkp

Return


//------------------------------------------------------------------------------
/*/{Protheus.doc} At600SeExc
	Ação do botão para chamada da interface do orçamento de serviços,
faz a carga dos dados do model para só realizar a gravação quando a proposta
também estiver sendo gravada.

@sample			At600OrcSer

@since			19/09/2013
@version		P11.90
/*/
//------------------------------------------------------------------------------
Function At600SeExc( nOpc, lVistoria, oModel )

Local lRet 	 	:= .T.
Local lMsg 	 	:= .T.
Local lSeekOrc 	:= .F.
Local lOrcPrc	:= SuperGetMv("MV_ORCPRC",,.F.)
Local cOrcMod	:= If( lOrcPrc, "TECA740F", "TECA740" )
Local lHasOrcSmp := HasOrcSimp()
Local lOrcSimp	:= lHasOrcSmp .And. SuperGetMv("MV_ORCSIMP",,"2") == "1"
Local lVisOrc	:= .F.

Default nOpc	 	:= 0
Default lVistoria 	:= .F.

oModel 				:= FwModelActive()

DbSelectArea('TFJ')

If lVistoria
	TFJ->( DbSetOrder( 6 ) ) //TFJ_FILIAL + TFJ_CODVIS
	lSeekOrc := TFJ->( DbSeek( xFilial('TFJ')+M->AAT_CODVIS ) )
Else
	TFJ->( DbSetOrder( 2 ) ) //TFJ_FILIAL + TFJ_PROPOS + TFJ_REVIS
	lSeekOrc := TFJ->( DbSeek( xFilial('TFJ')+FwFldGet("ADY_PROPOS")+FwFldGet("ADY_PREVIS") ) )
Endif

If lOrcSimp .And. !Empty(AAT->AAT_CODORC)
	lVisOrc := .T.
	lRet := .F.
EndIf

At740FMsg( .F. ) // Desabilita as mensagens para o novo modelo de precificação

If !lVisOrc
	If lRet
		//-------------------------------------------------------
		//   Chama rotina para excluir as linhas do grid
		DelDadosOrc( lVistoria, oModel )
		lRemOrcServ := .T.

	ElseIf lMsg

		Help(,,'REMORCSER02',, STR0207,1,0) // 'Não foi possível remover o Orçamento de Serviços'
	EndIf

	If lRet .And. lSeekOrc
		If lVistoria
			// Carrega o model do orçamento de serviços se for necessario
			lRet := A600LOrc( M->AAT_CODVIS )
		Else
			lRet := At740Del( TFJ->( Recno() ) )
		Endif
	Else
		lMsg := .F.
		Help(,,'REMORCSER01',, STR0206,1,0) // 'Não existe orçamento de serviço vinculado à proposta'
	EndIf
Else
	Help(,,'REMORC03',, STR0410,1,0) //Vistoria com orçamento de serviços já gerado, não será possível remover o orçamento da vistoria.
EndIf

At740FMsg( .T. )
// reativa o modelo da proposta como o principal
FwModelActive(oModel)

Return

//------------------------------------------------------------------------------
/*/{Protheus.doc} SetDadosOrc()
	 Faz a inclusão dos valores do orçamento de serviços na proposta comercial

@sample			SetDadosOrc()

@since			27/09/2013
@version		P11.90
/*/
//------------------------------------------------------------------------------
Function SetDadosOrc( lVistoria, oMdlVis, oOrcServico )

Local aRefs     		:= {  { 'TFJ_GRPRH', /*cProduto*/, 'TFJ_TOTRH', /*nValor*/, 'TFJ_ITEMRH',oOrcServico:GetValue('TFJ_REFER', 'TFJ_TES'), /*lCortesia*/ }, ;
								{ 'TFJ_GRPMI', /*cProduto*/, 'TFJ_TOTMI', /*nValor*/, 'TFJ_ITEMMI',oOrcServico:GetValue('TFJ_REFER', 'TFJ_TESMI'), /*lCortesia*/ }, ;
								{ 'TFJ_GRPMC', /*cProduto*/, 'TFJ_TOTMC', /*nValor*/, 'TFJ_ITEMMC',oOrcServico:GetValue('TFJ_REFER', 'TFJ_TESMC'), /*lCortesia*/ }, ;
							{ 'TFJ_GRPLE', /*cProduto*/, 'TFJ_TOTLE', /*nValor*/, 'TFJ_ITEMLE',oOrcServico:GetValue('TFJ_REFER', 'TFJ_TESLE'), /*lCortesia*/  } }
Local lSomaImp 		:= SuperGetMv("MV_ATOPIMP",,.T.) .And. oOrcServico:HasField('TOTAIS', 'TOT_TOTIMP') // verifica o parâmetro de incorporação do valor do imposto
Local lOrcPrc 		:= SuperGetMv("MV_ORCPRC",,.F.)
Local lGsDsGCN 		:=  .F.//SuperGetMv("MV_GSDSGCN",,"2") == "1"
Local xAux      		:= Nil
Local aPosDel    	:= {}
Local aRet			:= {}
Local nI        		:= 0
Local nX       	 	:= 0
Local nY			:= 0
Local nZ			:= 0
Local nJ			:= 0
Local nItem     	:= 0
Local nTotal		:= 0
Local lItUsado    	:= .F.
Local lAtuDadosFin 	:= .F.
Local lExiste := .F.
Local cItemImport   := ""
Local cCondPg		:= ""
Local oTFLDetail	:= oOrcServico:GetModel('TFL_LOC')
Local oTFFDetail	:= oOrcServico:GetModel('TFF_RH')
Local oTFGDetail	:= oOrcServico:GetModel('TFG_MI')
Local oTFHDetail	:= oOrcServico:GetModel('TFH_MC')
Local oTFIDetail	:= oOrcServico:GetModel('TFI_LE')
Local oTEVDetail	:= oOrcServico:GetModel('TEV_ADICIO')
Local oMdlImport	:= Nil
Local cFilSB1		:= xFilial('SB1')

Default lVistoria := .F.

//Recupera o Model da Proposta
FwModelActive(oMdlProp)

If ! lVistoria
	nItem    := oMdlProp:GetModel("ADZPRODUTO"):Length()
Endif

lGsDsGCN := oOrcServico:GetValue( 'TFJ_REFER', 'TFJ_DSGCN' ) == '1'

// identifica os produtos e os valores gerais dos agrupamentos
For nI := 1 To Len( aRefs )

	aRefs[nI, 2] := oOrcServico:GetValue( 'TFJ_REFER', aRefs[nI,1] ) // captura o código do produto referência
	aRefs[nI, 4] := oOrcServico:GetValue( 'TFJ_REFER', aRefs[nI,3] )  // inserido para
	aRefs[nI, 7] := At600Cort( aRefs[nI,1], oOrcServico )

Next nI

// Agrupa os valores caso seja necessário
xAux := {}
For nI := 1 To Len( aRefs )

	// verifica se o produto já existe na referências para somar o valor
	If ( nX := aScan( xAux, {|x| x[1] == aRefs[nI, 2] } ) ) == 0
					//  produto     , valor
		aAdd( xAux, { aRefs[nI, 2], aRefs[nI, 4], {aRefs[nI,5]} , aRefs[nI,6], aRefs[nI,7]  } )
	Else
		xAux[nX, 2] += aRefs[ nI, 4]
		aAdd( xAux[nX, 3], aRefs[nI, 5] )
	EndIf

Next nI

aRefs := aClone( xAux )

aSize( xAux, 0)
xAux := Nil

//-----------------------------------------------
//  Adiciona na primeira linha da importaçaõ o valor de imposto dos itens
// item necessário avaliar se realmente deverá ser executado
If lOrcPrc .And. oOrcServico:Getmodel('TOTAIS'):GetStruct():Hasfield('TOT_TOTIMP')
	// captura o conteúdo do valor total de impostos somado pelo calc
	xAux := oOrcServico:GetValue( 'TOTAIS', 'TOT_TOTIMP' )
	aRefs[1,2] += xAux

	xAux := Nil
EndIf

//----------------------------------------------
//  Realiza os acertos para atualizar os itens corretos da proposta
//  verifica: itens e produtos da tfj antes e dps da atualização do orçamento de serviços
If Len( aPosItensOrc ) > 0

	For nI := 1 To Len( aPosItensOrc )

		// ------------------------
		//   verifica se mudou o código do produto
		If aPosItensOrc[nI,VALOR_PROD] <> oOrcServico:GetValue( 'TFJ_REFER', aPosItensOrc[nI,CAMPO_PROD] )

			aPosItensOrc[nI,MUDOU_PROD] := .T.

			//-------------------------
			//  verifica se tem algum item com este mesmo produto
			//  e atribui o item correto para o item da TFJ
			If ( nItem := aScan( aPosItensOrc, {|x| x[2] == oOrcServico:GetValue( 'TFJ_REFER', aPosItensOrc[nI,CAMPO_PROD] ) } ) ) > 0

				nItem := aPosItensOrc[ nItem, VALOR_ITEM ]
				oOrcServico:SetValue( 'TFJ_REFER', aPosItensOrc[nI,CAMPO_ITEM], nItem )
			Else

				oOrcServico:SetValue( 'TFJ_REFER', aPosItensOrc[nI,CAMPO_ITEM], ' ' )
			EndIf

		EndIf

	Next nI

	//--------------------------------
	//  Verifica se é necessário apagar as linhas anteriores
	For nI := 1 To Len( aPosItensOrc )

		xAux := .F.
		// avalia se o item sofreu alteração do produto
		If aPosItensOrc[nI,MUDOU_PROD]

			// itera sobre os itens registrados no model para saber quais estão sendo utilizados ainda
			For nX := 1 To Len( aPosItensOrc )

				xAux := ( aPosItensOrc[nI,VALOR_PROD] == oOrcServico:GetValue( 'TFJ_REFER', aPosItensOrc[nX,CAMPO_PROD] ) )

				If xAux
					Exit
				EndIf
			Next nX

			If !xAux .And. aScan( aPosDel, {|x| x[1] == aPosItensOrc[nI,VALOR_ITEM] } ) == 0
				aAdd( aPosDel, { aPosItensOrc[nI,VALOR_ITEM], .T. } )
			EndIf

		EndIf
	Next nI

	xAux := {}
	//--------------------------------
	//  Avalia se há algum item pode ser reaproveitado com algum outro
	// produto a ser importado
	For nX := 1 To Len(aPosDel)

		If aPosDel[nX,2]

			lItUsado := .F.

			For nI := 1 To Len( aPosItensOrc )

				//  quando encontrar produto sem item para atualizar
				// insere o código do item que seria deletado
				If Empty( oOrcServico:GetValue( 'TFJ_REFER', aPosItensOrc[nI,CAMPO_ITEM] ) )

					//  verifica se é um produto em que já foi realizada a alteração
					// do item para importar a informação
					If ( nItem := aScan( xAux, {|x| x[1] == oOrcServico:GetValue( 'TFJ_REFER', aPosItensOrc[nI,CAMPO_PROD] ) } ) ) > 0

						oOrcServico:SetValue( 'TFJ_REFER', aPosItensOrc[nI,CAMPO_ITEM], xAux[nItem,2] )

					// garante que não seja usado o mesmo código de item para um produto diferente
					ElseIf !lItUsado
						lItUsado := .T.

						aAdd( xAux, { 	oOrcServico:GetValue( 'TFJ_REFER', aPosItensOrc[nI,CAMPO_PROD] ) ,; // código produto
										oOrcServico:GetValue( 'TFJ_REFER', aPosItensOrc[nI,CAMPO_ITEM] ) } ) // código do item

						oOrcServico:SetValue( 'TFJ_REFER', aPosItensOrc[nI,CAMPO_ITEM], aPosDel[nX,1] )

						aPosDel[nX,2] := .F.
					EndIf
				EndIf

			Next nI
		EndIf

	Next nX

	// Deleta os produtos referências que não serão utilizados
	For nX := 1 To Len( aPosDel )
		If aPosDel[nX,2]
			For nI := 1 to oMdlProp:GetModel('ADZPRODUTO'):Length()
				oMdlProp:GetModel('ADZPRODUTO'):GoLine(nI)
				If aPosDel[nX,1] == oMdlProp:GetModel('ADZPRODUTO'):GetValue('ADZ_ITEM')
					oMdlProp:GetModel('ADZPRODUTO'):DeleteLine()  // remover comentário
					aAdd( aItOrcSerRem, aPosDel[nX,1] )
				EndIf
			Next nI
		EndIf
	Next nX

	xAux := Nil
EndIf

DbSelectArea( 'SB1' )
SB1->( DbSetOrder( 1 ) ) //B1_FILIAL+B1_COD

If !lVistoria
	nItem := oMdlProp:GetModel('ADZPRODUTO'):Length()
EndIf

// Forma o conteúdo para incorporação nas linhas da Proposta
For nI := 1 To Len( aRefs )

	If aRefs[nI, 2] <> 0.00  // somente insere a linha caso tenha valor

		SB1->( DbSeek(cFilSB1+aRefs[nI,1] ) )
		cItemImport := ''

		If lVistoria
			oMdlImport := oMdlVis:GetModel("PRDDETAIL")

			If lGsDsGCN
				//Deleta a informação da ADZ
				If !oMdlImport:IsEmpty()
					For nX := oMdlImport:Length() To 1 Step -1
						oMdlImport:GoLine(nX)
						If !Empty( oMdlImport:GetValue('AAU_PRODUT')) .And. !(oMdlImport:IsDeleted())
							oMdlImport:DeleteLine()
						EndIf
					Next nX
				EndIf

				For nJ := 1 To oTFLDetail:Length()
					oTFLDetail::GoLine(nJ)
					If !oTFLDetail:IsDeleted()
						If !oTFFDetail:IsEmpty()
							For nX := 1 To oTFFDetail:Length()
								oTFFDetail::GoLine(nX)
								If !oTFFDetail:IsDeleted()


									If !oMdlImport:IsEmpty()
										oMdlImport:AddLine()
									EndIf

									If Empty( ( cItemImport := oMdlImport:GetValue("AAU_ITEM")) )
										cItemImport := Soma1( oMdlImport:GetValue("AAU_ITEM", oMdlImport:GetLine() - 1 ) )
										oMdlImport:SetValue("AAU_ITEM", cItemImport )
									EndIf

									oMdlImport:SetValue( "AAU_PRODUT"	, oTFFDetail:GetValue('TFF_PRODUT'))	// Produto.
									oMdlImport:SetValue( "AAU_DESCRI"	, oTFFDetail:GetValue('TFF_DESCRI'))	// Produto.
									oMdlImport:SetValue( "AAU_UM"		, oTFFDetail:GetValue('TFF_UM'))	// Produto.
									oMdlImport:SetValue( "AAU_MOEDA"	, "1" 				)	// Moeda.
									oMdlImport:SetValue( "AAU_QTDVEN"	, oTFFDetail:GetValue('TFF_QTDVEN'))
									oMdlImport:SetValue( "AAU_PRCVEN"	, oTFFDetail:GetValue('TFF_PRCVEN'))
									oMdlImport:SetValue( "AAU_PRCTAB"	, 0.00)	// Produto.
									If !Empty(oOrcServico:GetValue('TFJ_REFER', 'TFJ_CODTAB'))
										oMdlImport:SetValue( "AAU_VLRTOT"	, oTFFDetail:GetValue('TFF_TOTAL'))	// Produto.
									Else
										oMdlImport:SetValue( "AAU_VLRTOT"	, oTFFDetail:GetValue('TFF_SUBTOT')   )	// Produto.
									EndIf
									oMdlImport:SetValue( "AAU_FOLDER"	, "1" 				) 	// Folder.

									//-- Se NÃO usar precificação
									If Empty(oOrcServico:GetValue('TFJ_REFER', 'TFJ_CODTAB'))
										If !oTFGDetail:IsEmpty()
											For nZ := 1 To oTFGDetail:Length()
												oTFGDetail::GoLine(nZ)
												If !oTFGDetail:IsDeleted()

													If !oMdlImport:IsEmpty()
														oMdlImport:AddLine()
													EndIf

													If Empty( ( cItemImport := oMdlImport:GetValue("AAU_ITEM")) )
														cItemImport := Soma1( oMdlImport:GetValue("AAU_ITEM", oMdlImport:GetLine() - 1 ) )
														oMdlImport:SetValue("AAU_ITEM", cItemImport )
													EndIf


													oMdlImport:SetValue( "AAU_PRODUT"	, oTFGDetail:GetValue('TFG_PRODUT'))	// Produto.
													oMdlImport:SetValue( "AAU_DESCRI"	, oTFGDetail:GetValue('TFG_DESCRI'))	// Produto.
													oMdlImport:SetValue( "AAU_UM"		, oTFGDetail:GetValue('TFG_UM'))	// Produto.
													oMdlImport:SetValue( "AAU_MOEDA"	, "1" 				)	// Moeda.
													oMdlImport:SetValue( "AAU_QTDVEN"	, oTFGDetail:GetValue('TFG_QTDVEN'))
													oMdlImport:SetValue( "AAU_PRCVEN"	, oTFGDetail:GetValue('TFG_PRCVEN'))
													oMdlImport:SetValue( "AAU_PRCTAB"	, 0.00)	// Produto.
													oMdlImport:SetValue( "AAU_VLRTOT"	, oTFGDetail:GetValue('TFG_TOTAL'))	// Produto.
													oMdlImport:SetValue( "AAU_FOLDER"	, "1" 				) 	// Folder.
												EndIf
											Next nZ
										EndIf

										If !oTFHDetail:IsEmpty()
											For nZ := 1 To oTFHDetail:Length()
												oTFHDetail::GoLine(nZ)
												If !oTFHDetail:IsDeleted()
													If !oMdlImport:IsEmpty()
														oMdlImport:AddLine()
													EndIf

													If Empty( ( cItemImport := oMdlImport:GetValue("AAU_ITEM")) )
														cItemImport := Soma1( oMdlImport:GetValue("AAU_ITEM", oMdlImport:GetLine() - 1 ) )
														oMdlImport:SetValue("AAU_ITEM", cItemImport )
													EndIf

													oMdlImport:SetValue( "AAU_PRODUT"	, oTFHDetail:GetValue('TFH_PRODUT'))	// Produto.
													oMdlImport:SetValue( "AAU_DESCRI"	, oTFHDetail:GetValue('TFH_DESCRI'))	// Produto.
													oMdlImport:SetValue( "AAU_UM"		, oTFHDetail:GetValue('TFH_UM'))	// Produto.
													oMdlImport:SetValue( "AAU_MOEDA"	, "1" 				)	// Moeda.
													oMdlImport:SetValue( "AAU_QTDVEN"	, oTFHDetail:GetValue('TFH_QTDVEN'))
													oMdlImport:SetValue( "AAU_PRCVEN"	, oTFHDetail:GetValue('TFH_PRCVEN'))
													oMdlImport:SetValue( "AAU_PRCTAB"	, 0.00)	// Produto.
													oMdlImport:SetValue( "AAU_VLRTOT"	, oTFHDetail:GetValue('TFH_TOTAL'))	// Produto.
													oMdlImport:SetValue( "AAU_FOLDER"	, "1" 				) 	// Folder.
												EndIf
											Next nZ
										EndIf
									EndIf
								EndIf
							Next nX
						EndIf

						//-- Se usar precificação
						If !Empty(oOrcServico:GetValue('TFJ_REFER', 'TFJ_CODTAB'))
							If !oTFGDetail:IsEmpty()
								For nZ := 1 To oTFGDetail:Length()
									oTFGDetail::GoLine(nZ)
									If !oTFGDetail:IsDeleted()
										If !oMdlImport:IsEmpty()
											oMdlImport:AddLine()
										EndIf

										If Empty( ( cItemImport := oMdlImport:GetValue("AAU_ITEM")) )
											cItemImport := Soma1( oMdlImport:GetValue("AAU_ITEM", oMdlImport:GetLine() - 1 ) )
											oMdlImport:SetValue("AAU_ITEM", cItemImport )
										EndIf


										oMdlImport:SetValue( "AAU_PRODUT"	, oTFGDetail:GetValue('TFG_PRODUT'))	// Produto.
										oMdlImport:SetValue( "AAU_DESCRI"	, oTFGDetail:GetValue('TFG_DESCRI'))	// Produto.
										oMdlImport:SetValue( "AAU_UM"		, oTFGDetail:GetValue('TFG_UM'))	// Produto.
										oMdlImport:SetValue( "AAU_MOEDA"	, "1" 				)	// Moeda.
										oMdlImport:SetValue( "AAU_QTDVEN"	, oTFGDetail:GetValue('TFG_QTDVEN'))
										oMdlImport:SetValue( "AAU_PRCVEN"	, oTFGDetail:GetValue('TFG_PRCVEN'))
										oMdlImport:SetValue( "AAU_PRCTAB"	, 0.00)	// Produto.
										oMdlImport:SetValue( "AAU_VLRTOT"	, oTFGDetail:GetValue('TFG_TOTAL'))	// Produto.
										oMdlImport:SetValue( "AAU_FOLDER"	, "1" 				) 	// Folder.
									EndIf
								Next nZ
							EndIf

							If !oTFHDetail:IsEmpty()
								For nZ := 1 To oTFHDetail:Length()
									oTFHDetail::GoLine(nZ)
									If !oTFHDetail:IsDeleted()


										If !oMdlImport:IsEmpty()
											oMdlImport:AddLine()
										EndIf

										If Empty( ( cItemImport := oMdlImport:GetValue("AAU_ITEM")) )
											cItemImport := Soma1( oMdlImport:GetValue("AAU_ITEM", oMdlImport:GetLine() - 1 ) )
											oMdlImport:SetValue("AAU_ITEM", cItemImport )
										EndIf

										oMdlImport:SetValue( "AAU_PRODUT"	, oTFHDetail:GetValue('TFH_PRODUT'))	// Produto.
										oMdlImport:SetValue( "AAU_DESCRI"	, oTFHDetail:GetValue('TFH_DESCRI'))	// Produto.
										oMdlImport:SetValue( "AAU_UM"		, oTFHDetail:GetValue('TFH_UM'))	// Produto.
										oMdlImport:SetValue( "AAU_MOEDA"	, "1" 				)	// Moeda.
										oMdlImport:SetValue( "AAU_QTDVEN"	, oTFHDetail:GetValue('TFH_QTDVEN'))
										oMdlImport:SetValue( "AAU_PRCVEN"	, oTFHDetail:GetValue('TFH_PRCVEN'))
										oMdlImport:SetValue( "AAU_PRCTAB"	, 0.00)	// Produto.
										oMdlImport:SetValue( "AAU_VLRTOT"	, oTFHDetail:GetValue('TFH_TOTAL'))	// Produto.
										oMdlImport:SetValue( "AAU_FOLDER"	, "1" 				) 	// Folder.
									EndIf
								Next nZ
							EndIf
						EndIf

						If !oTFIDetail:IsEmpty()
							For nX := 1 To oTFIDetail:Length()
								oTFIDetail:GoLine(nX)
								If !oTFIDetail:IsDeleted()
									/*nTotTEV := 0
									For nZ := 1 To oTEVDetail:Length()
										oTEVDetail:GoLine(nZ)
										If !oTFIDetail:IsDeleted()
											nTotTEV += oTEVDetail:GetValue('TEV_VLRUNI')
										EndIf
									Next nZ*/
									If !oMdlImport:IsEmpty()
										oMdlImport:AddLine()
									EndIf

									If Empty( ( cItemImport := oMdlImport:GetValue("AAU_ITEM")) )
										cItemImport := Soma1( oMdlImport:GetValue("AAU_ITEM", oMdlImport:GetLine() - 1 ) )
										oMdlImport:SetValue("AAU_ITEM", cItemImport )
									EndIf


									oMdlImport:SetValue( "AAU_PRODUT"	, oTFIDetail:GetValue('TFI_PRODUT'))	// Produto.
									oMdlImport:SetValue( "AAU_DESCRI"	, oTFIDetail:GetValue('TFI_DESCRI'))	// Produto.
									oMdlImport:SetValue( "AAU_UM"		, oTFIDetail:GetValue('TFI_UM'))	// Produto.
									oMdlImport:SetValue( "AAU_MOEDA"	, "1" 				)	// Moeda.
									oMdlImport:SetValue( "AAU_QTDVEN"	, oTFIDetail:GetValue('TFI_QTDVEN'))
									oMdlImport:SetValue( "AAU_PRCVEN"	, Round( oTFIDetail:GetValue('TFI_TOTAL') / oTFIDetail:GetValue('TFI_QTDVEN'), 2),;
									oMdlImport:SetValue( "AAU_PRCTAB"	, 0.00))	// Produto.
									oMdlImport:SetValue( "AAU_VLRTOT"	, oTFIDetail:GetValue('TFI_TOTAL'))	// Produto.
									oMdlImport:SetValue( "AAU_FOLDER"	, "1" 				) 	// Folder.

								EndIf
							Next nX
						EndIf

					EndIf
				Next nJ
			Else

			// Verifica se o model da vistoria tecnica necessita de inclusao ou atualizacao de linha
				xAux := oOrcServico:GetValue( 'TFJ_REFER', aRefs[nI, 3, 1] )
				lExiste := oMdlImport:SeekLine({{ "AAU_ITEM", xAux }})



				If ! lExiste
				    If oMdlImport:GetLine() <> 1 .Or. ;
				    	! Empty(oMdlImport:GetValue("AAU_PRODUT"))
						oMdlImport:AddLine()
					EndIf
				Endif

				If oMdlImport:IsDeleted()
					oMdlImport:UnDeleteLine()
				EndIf

				If Empty( ( cItemImport := oMdlImport:GetValue("AAU_ITEM") ) )
					cItemImport := Soma1( oMdlImport:GetValue("AAU_ITEM", oMdlImport:GetLine() - 1 ) )
					oMdlImport:SetValue("AAU_ITEM", cItemImport )
				EndIf

				oMdlImport:SetValue( "AAU_PRODUT"	, aRefs[nI, 1]	)	// Produto.
				oMdlImport:SetValue( "AAU_DESCRI"	, SB1->B1_DESC 	)	// Descricao.
				oMdlImport:SetValue( "AAU_UM"		, SB1->B1_UM 		)  	// Unidade primaria.
				oMdlImport:SetValue( "AAU_MOEDA"		, "1" 				)	// Moeda.
				oMdlImport:SetValue( "AAU_QTDVEN"	, 1 				)	// Quantidade.
				oMdlImport:SetValue( "AAU_PRCVEN"	, aRefs[nI, 2] 	)	// Preco de venda.
				oMdlImport:SetValue( "AAU_PRCTAB"	, 0.00 			) 	// Preco de tabela.
				oMdlImport:SetValue( "AAU_VLRTOT"	, aRefs[nI, 2] 	)	// Valor total.
				oMdlImport:SetValue( "AAU_FOLDER"	, "1" 				) 	// Folder.

				// Atribui a numeração dos itens para controlar o posicionamento do produtos de referência
				For nX := 1 To Len( aRefs[nI, 3] )
					oOrcServico:SetValue( 'TFJ_REFER', aRefs[nI, 3, nX], cItemImport)
				Next nX
			EndIf

		Else
		 	oMdlImport := oMdlProp:GetModel('ADZPRODUTO')
		 	xAux := oOrcServico:GetValue( 'TFJ_REFER', aRefs[nI, 3, 1] )

			If !Empty( xAux )

				lExiste := oMdlImport:SeekLine({{'ADZ_ITEM',xAux}})
				cItemImport := xAux
				If ! lExiste
				    If oMdlImport:GetLine() <> 1 .Or. ;
				    	! Empty(oMdlImport:GetValue("ADZ_PRODUT"))

							// identifica próximo item da proposta
							cItemImport := Ft600IncItem(oMdlImport, 'ADZ_ITEM')

							// posiciona na última linha do grid para o AddLine funcionar
							nItem := oMdlImport:Length()
							oMdlImport:GoLine(nItem)

							// adiciona a nova linha para o item
							nItem := oMdlImport:AddLine()
							oMdlImport:GoLine(nItem)

							// Preenche o item do grid
							oMdlImport:SetValue('ADZ_ITEM',cItemImport)
					EndIf
				Endif

			ElseIf !Empty(oMdlImport:GetValue("ADZ_PRODUT")) .Or. oMdlImport:IsDeleted()

				// identifica próximo item da proposta
				cItemImport := Ft600IncItem(oMdlImport, 'ADZ_ITEM')

				// posiciona na última linha do grid para o AddLine funcionar
				nItem := oMdlImport:Length()
				oMdlImport:GoLine(nItem)

				// adiciona a nova linha para o item
				nItem := oMdlImport:AddLine()
				oMdlImport:GoLine(nItem)

				// Preenche o item do grid
				oMdlImport:SetValue('ADZ_ITEM',cItemImport)
			Else
				cItemImport := oMdlImport:GetValue("ADZ_ITEM")
			EndIf

			cCondPg := oOrcServico:GetValue('TFJ_REFER', 'TFJ_CONDPG')

			//Adicionar os produtos do orçamento (TFF,TFG,TFH,TFI)na proposta quando o Parametro MV_GSDSGCN estiver como 1-Sim
			If lGsDsGCN
				For nJ := 1 To oTFLDetail:Length()
					oTFLDetail::GoLine(nJ)
					If !oTFLDetail:IsDeleted()
						If !oTFFDetail:IsEmpty()
							For nX := 1 To oTFFDetail:Length()
								oTFFDetail::GoLine(nX)
								If !oTFFDetail:IsDeleted()
									aadd(aRet, {oTFFDetail:GetValue('TFF_PRODUT'),;
												oTFFDetail:GetValue('TFF_DESCRI'),;
												oTFFDetail:GetValue('TFF_UM'),;
												oTFFDetail:GetValue('TFF_TESPED'),;
												Round( oTFFDetail:GetValue('TFF_SUBTOT ') / oTFFDetail:GetValue('TFF_QTDVEN'), 2),;
												oTFFDetail:GetValue('TFF_SUBTOT'),;
												oTFFDetail:GetValue('TFF_QTDVEN')})
									//-- Se NÃO usar precificação
									If Empty(oOrcServico:GetValue('TFJ_REFER', 'TFJ_CODTAB'))
										If !oTFGDetail:IsEmpty()
											For nZ := 1 To oTFGDetail:Length()
												oTFGDetail::GoLine(nZ)
												If !oTFGDetail:IsDeleted()
													aadd(aRet, {oTFGDetail:GetValue('TFG_PRODUT'),;
														oTFGDetail:GetValue('TFG_DESCRI'),;
														oTFGDetail:GetValue('TFG_UM'),;
														oTFGDetail:GetValue('TFG_TESPED'),;
														Round( oTFGDetail:GetValue('TFG_TOTAL ') / oTFGDetail:GetValue('TFG_QTDVEN'), 2),;
														oTFGDetail:GetValue('TFG_TOTAL'),;
														oTFGDetail:GetValue('TFG_QTDVEN')})
												EndIf
											Next nZ
										EndIf

										If !oTFHDetail:IsEmpty()
											For nZ := 1 To oTFHDetail:Length()
												oTFHDetail::GoLine(nZ)
												If !oTFHDetail:IsDeleted()
													aadd(aRet, {oTFHDetail:GetValue('TFH_PRODUT'),;
														oTFHDetail:GetValue('TFH_DESCRI'),;
														oTFHDetail:GetValue('TFH_UM'),;
														oTFHDetail:GetValue('TFH_TESPED'),;
														Round( oTFHDetail:GetValue('TFH_TOTAL ') / oTFHDetail:GetValue('TFH_QTDVEN'), 2),;
														oTFHDetail:GetValue('TFH_TOTAL'),;
														oTFHDetail:GetValue('TFH_QTDVEN')})
												EndIf
											Next nZ
										EndIf
									EndIf
								EndIf
							Next nX
						EndIf

						//-- Se usar precificação
						If !Empty(oOrcServico:GetValue('TFJ_REFER', 'TFJ_CODTAB'))
							If !oTFGDetail:IsEmpty()
								For nZ := 1 To oTFGDetail:Length()
									oTFGDetail::GoLine(nZ)
									If !oTFGDetail:IsDeleted()
										aadd(aRet, {oTFGDetail:GetValue('TFG_PRODUT'),;
													oTFGDetail:GetValue('TFG_DESCRI'),;
													oTFGDetail:GetValue('TFG_UM'),;
													oTFGDetail:GetValue('TFG_TESPED'),;
													Round( oTFGDetail:GetValue('TFG_TOTAL ') / oTFGDetail:GetValue('TFG_QTDVEN'), 2),;
													oTFGDetail:GetValue('TFG_TOTAL'),;
													oTFGDetail:GetValue('TFG_QTDVEN')})
									EndIf
								Next nZ
							EndIf

							If !oTFHDetail:IsEmpty()
								For nZ := 1 To oTFHDetail:Length()
									oTFHDetail::GoLine(nZ)
									If !oTFHDetail:IsDeleted()
										aadd(aRet, {oTFHDetail:GetValue('TFH_PRODUT'),;
											oTFHDetail:GetValue('TFH_DESCRI'),;
											oTFHDetail:GetValue('TFH_UM'),;
											oTFHDetail:GetValue('TFH_TESPED'),;
											Round( oTFHDetail:GetValue('TFH_TOTAL ') / oTFHDetail:GetValue('TFH_QTDVEN'), 2),;
											oTFHDetail:GetValue('TFH_TOTAL'),;
											oTFHDetail:GetValue('TFH_QTDVEN')})
									EndIf
								Next nZ
							EndIf
						EndIf

						If !oTFIDetail:IsEmpty()
							For nX := 1 To oTFIDetail:Length()
								oTFIDetail:GoLine(nX)
								If !oTFIDetail:IsDeleted()
									nTotTEV := 0
									For nZ := 1 To oTEVDetail:Length()
										oTEVDetail:GoLine(nZ)
										If !oTFIDetail:IsDeleted()
											nTotTEV += oTEVDetail:GetValue('TEV_VLRUNI')
										EndIf
									Next nZ

									aadd(aRet, {oTFIDetail:GetValue('TFI_PRODUT'),;
												oTFIDetail:GetValue('TFI_DESCRI'),;
												oTFIDetail:GetValue('TFI_UM'),;
												oTFIDetail:GetValue('TFI_TESPED'),;
												Round( oTFIDetail:GetValue('TFI_TOTAL ') / oTFIDetail:GetValue('TFI_QTDVEN'), 2),;
												oTFIDetail:GetValue('TFI_TOTAL '),;
												oTFIDetail:GetValue('TFI_QTDVEN')})

								EndIf
							Next nX
						EndIf

					EndIf
				Next nJ
				//Deleta a informação da ADZ
				For nX := oMdlImport:Length() To 1 Step -1
					oMdlImport:GoLine(nX)
					If !Empty( oMdlImport:GetValue('ADZ_PRODUT')) .And. !(oMdlImport:IsDeleted())
						oMdlImport:DeleteLine()
					EndIf
				Next nX
				// vai para a última linha do grid
				oMdlImport:GoLine( oMdlImport:Length()	)
				//Popula a rotina da proposta com as informações do orçamento
				For nX := 1 To Len(aRet)
					If aRet[nx][5] > 0
						If !Empty( oMdlImport:GetValue('ADZ_PRODUT')) .Or. oMdlImport:IsDeleted()
							oMdlImport:AddLine()
						EndIf
						oMdlImport:SetValue('ADZ_PRODUT'	,aRet[nx][1])	// Código do Produto
						oMdlImport:SetValue('ADZ_DESCRI'	,aRet[nx][2])	// Descrição do Produto
						oMdlImport:SetValue('ADZ_UM'	 	,aRet[nx][3])	// Unidade de medida do Produto
						oMdlImport:SetValue('ADZ_MOEDA' 	,"1")			// moeda padrão para o item
						oMdlImport:SetValue('ADZ_CONDPG'	,cCondPg)		// condição de pagamento
						oMdlImport:SetValue('ADZ_TES'	 	,aRet[nx][4])	// TES do item na ADZ
						oMdlImport:SetValue('ADZ_QTDVEN'	,aRet[nx][7])	// quantidade do item
						oMdlImport:SetValue('ADZ_PRCVEN'	,aRet[nx][5])	// Valor total do Agrupamento
						oMdlImport:SetValue('ADZ_PRCTAB'	,0.00)			// não deve ter valor de tabela por padrão
						oMdlImport:SetValue('ADZ_TOTAL' 	,aRet[nx][6])	// Valor total do item
						oMdlImport:SetValue('ADZ_FOLDER'	,"1")			// Aba de Produto
					EndIf
				Next nX
			Else
				If aRefs[nI, 2] > 0
					oMdlImport:SetValue('ADZ_PRODUT', aRefs[nI, 1])    // Código do Produto
					oMdlImport:SetValue('ADZ_DESCRI' , SB1->B1_DESC )  // Descrição do Produto
					oMdlImport:SetValue('ADZ_UM',SB1->B1_UM)           // Unidade de medida do Produto
					oMdlImport:SetValue('ADZ_MOEDA',"1")               // moeda padrão para o item
					oMdlImport:SetValue('ADZ_CONDPG'	,cCondPg)		// condição de pagamento
					oMdlImport:SetValue('ADZ_TES', aRefs[nI, 4] )       // TES do item na ADZ
					oMdlImport:SetValue('ADZ_QTDVEN',1)  							// quantidade do item
					oMdlImport:SetValue('ADZ_PRCVEN',aRefs[nI, 2])      // Valor total do Agrupamento
					oMdlImport:SetValue('ADZ_PRCTAB',0.00)              // não deve ter valor de tabela por padrão
					oMdlImport:SetValue('ADZ_TOTAL',aRefs[nI, 2])		 // Valor total do item
					oMdlImport:SetValue('ADZ_FOLDER',"1")				 // Aba de Produto

					// Atribui a numeração dos itens para controlar o posicionamento do produtos de referência
					For nX := 1 To Len( aRefs[nI, 3] )
						oOrcServico:SetValue( 'TFJ_REFER', aRefs[nI, 3, nX], cItemImport)
					Next nX
				EndIf
			EndIf
		EndIf

		lAtuDadosFin := .T.

	EndIf

Next nI

If lAtuDadosFin .And. ! lVistoria
	oMdlProp:GetModel("ADZPRODUTO"):GoLine(1)
	A600CroFinance()	//Atualiza cronograma financeiro
EndIf

Return

//------------------------------------------------------------------------------
/*/{Protheus.doc} DelDadosOrc
	 Deleta os itens do orçamento de serviços do grid de produtos da proposta comercial

@sample			DelDadosOrc()

@since			27/09/2013
@version		P11.90
/*/
//------------------------------------------------------------------------------
Static Function DelDadosOrc( lVistoria, oModel )

Local aRefs     := { 'TFJ_ITEMRH', 'TFJ_ITEMMI', 'TFJ_ITEMMC', 'TFJ_ITEMLE' }
Local nI        := 0
Local nLinha     := 0
Local nPosDel
Local lAtuDados := .F.
Local cChave 		:= ""
Local lDesagrup		:= .F.
Local oMdlPrds		:= Nil
Default lVistoria := .F.


If lVistoria
	oMdlPrds := oModel:GetModel("PRDDETAIL")
	DbSelectArea("TFJ")
	TFJ->( DbSetOrder( 6 ) ) // TFJ_FILIAL + TFJ_CODVIS

	cChave := xFilial("TFJ")+M->AAT_CODVIS

	If TFJ->( DbSeek( cChave ) )
		lDesagrup := TFJ->TFJ_DSGCN == '1'
	EndiF

	If !lDesagrup
		If TFJ->( DbSeek( cChave ) )
			// Verifica os itens da vistoria e deleta os itens que fazem parte do orçamento de vendas
			For nI := 1 To Len( aRefs )
				If oMdlPrds:SeekLine( { { "AAU_ITEM", TFJ->(&(aRefs[nI]) ) } } )
					oMdlPrds:DeleteLine()
				EndIf
			Next nI
		EndIf
	Else
		For nI := oMdlPrds:Length() To 1 Step -1
			oMdlPrds:GoLine(nI)
			oMdlPrds:DeleteLine()
		Next nX
	EndIf
Else
	oMdlPrds := oModel:GetModel("ADZPRODUTO")
	DbSelectArea("TFJ")
	TFJ->( DbSetOrder( 2 ) ) // TFJ_FILIAL + TFJ_PROPOS + TFJ_PREVIS

	cChave := xFilial("TFJ")+M->ADY_PROPOS+ADY_PREVIS

	If TFJ->( DbSeek( cChave ) )
		lDesagrup := TFJ->TFJ_DSGCN == '1'
	EndiF

	If !lDesagrup
		For nI := 1 To Len( aRefs )

			If oMdlPrds:SeekLine( { { "ADZ_ITEM", TFJ->(&(aRefs[nI]) ) } } )
				If !oMdlPrds:DeleteLine()
					Ft600ErroMvc( oModel )
				EndIf
				lAtuDadosFin := .T.
			EndIf

		Next nI
	Else
		For nI := oMdlPrds:Length() To 1 Step -1
			oMdlPrds:GoLine(nI)
			oMdlPrds:DeleteLine()
		Next nX
	EndIf
	If lAtuDados
		A600CroFinance()	//Atualiza cronograma financeiro
		A600Total()
	EndIf
EndIf

Return

//------------------------------------------------------------------------------
/*/{Protheus.doc} Ft600ErroMvc
	 Captura e Exibe o Erro em MVC na carga dos dados do orçamento de serviços

@sample			Ft600ErroMvc()

@since			30/09/2013
@version		P11.90
/*/
//------------------------------------------------------------------------------
Function Ft600ErroMvc( oObjMdl )

Local aErro := {}

DEFAULT oObjMdl := FwModelActive()

aErro := oObjMdl:GetErrorMessage()

If Len(aErro) > 0
	AutoGrLog( '[' + AllToChar( aErro[MODEL_MSGERR_IDFORMERR] ) + ']' )
	AutoGrLog( '[' + AllToChar( aErro[MODEL_MSGERR_IDFIELDERR] ) + ']' )
	AutoGrLog( '[' + AllToChar( aErro[MODEL_MSGERR_ID] ) + ']' )
	AutoGrLog( '[' + AllToChar( aErro[MODEL_MSGERR_MESSAGE] ) + '|' + AllToChar( aErro[MODEL_MSGERR_SOLUCTION] ) + ']' )

	MostraErro()
EndIf

Return

//------------------------------------------------------------------------------
/*/{Protheus.doc} A600Clean
	 Faz a limpeza do objeto

@sample		A600Clean()

@since		30/09/2013
@version	P11.90

@param 		cItem, Char, código do item a ser validado

@return 	lRet, Logico, indica se o item é ou não vinculado a um orçamento de serviços
/*/
//------------------------------------------------------------------------------
Function A600Clean()

lRemOrcServ := .F.

Return

//------------------------------------------------------------------------------
/*/{Protheus.doc} A600GrvOrc
	 Efetua a gravação do orçamento de vendas

@sample		A600GrvOrc()

@since		19/03/2014
@version	P12

/*/
//------------------------------------------------------------------------------
Function A600GrvOrc(cVistoria, oModel)

Local oMdlVis 	:= oModel:GetModel("PRDDETAIL")
Local lOrcPrc	  	:= SuperGetMv("MV_ORCPRC",,.F.)
Local cOrcMod		:= If( lOrcPrc, "TECA740F", "TECA740" )
Local lContinua 	:= .F.

DbSelectArea("TFJ")
TFJ->( DbSetOrder( 6 ) ) // TFJ_FILIAL + TFJ_CODVIS
lContinua := TFJ->( DbSeek( xFilial("TFJ") + cVistoria ) )

If lContinua .And. ( lRemOrcServ .Or. oModel:GetOperation() == MODEL_OPERATION_DELETE )

	If oModel:GetOperation() == MODEL_OPERATION_DELETE
		A600LOrc( oModel:GetModel("AATMASTER"):GetValue("AAT_CODVIS") )
	EndIf

	At740Del( TFJ->(Recno()) )

EndIf // -> condição de remoção do orçamento de serviço

Return


//------------------------------------------------------------------------------
/*/{Protheus.doc} A600LOrc
@description	Efetua o load do orçamento de serviços
@sample		A600LOrc( cVistoria, cProposta, cRevisao, cNameCargo, oMdlVis, aPrpXOrc )
@param 			cVistoria - Código da vistoria tecnica
@param 			cProposta - Código da proposta comercial
@param 			cRevisao - Revisão da proposta comercial
@param			cNameCargo - Rotina chamadora
@param			oMdlVis - Modelo da vistoria
@param			aPrpXOrc - Relacionamento entre os itens da Proposta x itens do orçamento de serviços para a montagem do novo orçamento de serviços
@since			21/03/2014
@version		P12
/*/
//------------------------------------------------------------------------------
Function A600LOrc( cVistoria, cProposta, cRevisao, cNameCargo, oMdlVis, aPrpXOrc )

Local lIncBkp		:= INCLUI				// Backup das variaveis INCLUI e ALTERA
Local lAltBkp		:= ALTERA				// Backup das variaveis INCLUI e ALTERA
Local lRet	 		:= .F.
Local lOrcPrc		:= SuperGetMv("MV_ORCPRC",,.F.)
Local cOrcMod		:= If( lOrcPrc, "TECA740F", "TECA740" )
Local oOrcServico	:= Nil
Local nPPrpXOrc		:= 0
Local cItPrpOrc		:= ""

Default cVistoria 	:= ""
Default cProposta 	:= ""
Default cRevisao  	:= ""
Default cNameCargo 	:= ""
Default oMdlVis 	:= Nil

lRemOrcServ := .F.
aItOrcSerRem := {}

DbSelectArea('TFJ')

At740FMsg( .F. )

If !Empty( cVistoria )

	TFJ->( DbSetOrder( 6 ) ) //TFJ_FILIAL+TFJ_CODVIS

	If TFJ->( DbSeek( xFilial('TFJ')+cVistoria ) )

		n := 0 // necessário para PROTHEUSFUNCTIONMVC.PRX no cadastro MVC
		// quando não identifica tabela inicializa a posicionada
		If lOrcPrc .And. Empty( At600GetTab()[1] )
			At600STabPrc( TFJ->TFJ_CODTAB, TFJ->TFJ_TABREV )
		EndIf

		At740Del( TFJ->(Recno()) )
	EndIf

Else

	TFJ->( DbSetOrder( 4 ) ) // TFJ_FILIAL+TFJ_STATUS+TFJ_PROPOS+TFJ_PREVIS

	If TFJ->( DbSeek( xFilial('TFJ') + DEF_TFJ_ATIVO + cProposta + cRevisao ) )

		n := 0 // necessário para PROTHEUSFUNCTIONMVC.PRX no cadastro MVC

		lIncBkp	:= INCLUI				// Backup das variaveis INCLUI e ALTERA
		lAltBkp	:= ALTERA				// Backup das variaveis INCLUI e ALTERA

		// quando não identifica tabela inicializa a posicionada
		If lOrcPrc .And. Empty( At600GetTab()[1] )
			At600STabPrc( TFJ->TFJ_CODTAB, TFJ->TFJ_TABREV )
		EndIf

		oOrcServico := FwLoadModel( cOrcMod )
		oOrcServico:SetOperation( MODEL_OPERATION_INSERT )

		If !Empty( cNameCargo )
			If (nX:=aScan(oOrcServico:Cargo,{|x| x[1] == "FUNNAME"})) > 0
				oOrcServico:Cargo[nX][2]:=cNameCargo
			Else
				aAdd(oOrcServico:Cargo,{"FUNNAME",cNameCargo})
			Endif
		EndIf

		oMdlOrcSer := FwLoadModel( cOrcMod )
		oMdlOrcSer:SetOperation( MODEL_OPERATION_UPDATE )
		lRet := oMdlOrcSer:Activate() .And. oOrcServico:Activate() .And. At740CpyMdl( oMdlOrcSer, oOrcServico )
		// preenche os dados nos modelos para cálculo da tabela de precificação
		If lOrcPrc
			AT740FCPY( oOrcServico )
		EndIf

		If lRet
			lRet := lRet .And. oOrcServico:SetValue("TFJ_REFER", "TFJ_PROPOS", "" )
			lRet := lRet .And. oOrcServico:SetValue("TFJ_REFER", "TFJ_PREVIS", "" )
			If	lRet
				If	( nPPrpXOrc := aScan(aPrpXOrc,{|x| x[01] == oOrcServico:GetValue("TFJ_REFER", "TFJ_GRPRH") .AND. x[03] == oOrcServico:GetValue("TFJ_REFER", "TFJ_ITEMRH")}) ) > 0
					cItPrpOrc	:= aPrpXOrc[nPPrpXOrc,04]
				Else
					cItPrpOrc	:= ""
				EndIf
				lRet := oOrcServico:SetValue("TFJ_REFER", "TFJ_ITEMRH", cItPrpOrc )
			EndIf
			If	lRet
				If	( nPPrpXOrc := aScan(aPrpXOrc,{|x| x[01] == oOrcServico:GetValue("TFJ_REFER", "TFJ_GRPMI") .AND. x[03] == oOrcServico:GetValue("TFJ_REFER", "TFJ_ITEMMI")}) ) > 0
					cItPrpOrc	:= aPrpXOrc[nPPrpXOrc,04]
				Else
					cItPrpOrc	:= ""
				EndIf
				lRet := oOrcServico:SetValue("TFJ_REFER", "TFJ_ITEMMI", cItPrpOrc )
			EndIf
			If	lRet
				If	( nPPrpXOrc := aScan(aPrpXOrc,{|x| x[01] == oOrcServico:GetValue("TFJ_REFER", "TFJ_GRPMC") .AND. x[03] == oOrcServico:GetValue("TFJ_REFER", "TFJ_ITEMMC")}) ) > 0
					cItPrpOrc	:= aPrpXOrc[nPPrpXOrc,04]
				Else
					cItPrpOrc	:= ""
				EndIf
				lRet := oOrcServico:SetValue("TFJ_REFER", "TFJ_ITEMMC", cItPrpOrc )
			EndIf
			If	lRet
				If	( nPPrpXOrc := aScan(aPrpXOrc,{|x| x[01] == oOrcServico:GetValue("TFJ_REFER", "TFJ_GRPLE") .AND. x[03] == oOrcServico:GetValue("TFJ_REFER", "TFJ_ITEMLE")}) ) > 0
					cItPrpOrc	:= aPrpXOrc[nPPrpXOrc,04]
				Else
					cItPrpOrc	:= ""
				EndIf
				lRet := oOrcServico:SetValue("TFJ_REFER", "TFJ_ITEMLE", cItPrpOrc )
			EndIf

			If Type("M->AAT_CODVIS") == "C"
				lRet := lRet .And. oOrcServico:SetValue("TFJ_REFER", "TFJ_CODVIS", M->AAT_CODVIS )
				N600SetVis( .T./*lVistoria*/, oMdlVis)
			EndIf
		EndIf
		At740SCmt(.T.)
		// grava os dados da importação da proposta comercial
		lRet := lRet .And. oOrcServico:VldData()
		lRet := lRet .And. oOrcServico:CommitData()

		oMdlOrcSer:DeActivate()
		oMdlOrcSer:Destroy()

		oOrcServico:Destroy()
		At740SCmt(.F.)
		N600SetVis( Nil, Nil)
		oOrcServico := Nil

		INCLUI := lIncBkp
		ALTERA := lAltBkp
	EndIf

EndIf

At740FMsg( .T. )

Return(lRet)

//------------------------------------------------------------------------------
/*/{Protheus.doc} A600CombOrc
	Efetua a substituição ou combina as informações do orçamento de serviços

@sample	A600CombOrc()

@param 		cVistoria - Código da vistoria tecnica
@param 		cProposta - Código da proposta comercial
@param 		cRevisao - Revisão da proposta comercial

@since		26/03/2014
@version	P12

/*/
//------------------------------------------------------------------------------
Function A600CombOrc( lSubItem, cCodVis, cCodPro, oMdlProp1 )

Local lIncBkp	 := INCLUI				// Backup das variaveis INCLUI e ALTERA
Local lAltBkp	 := ALTERA				// Backup das variaveis INCLUI e ALTERA
Local lRet	 	 := .F.
Local nTotRH   := 0
Local nTotMI   := 0
Local nTotMC   := 0
Local nTotLE   := 0
Local nLinha   := 0
Local nTotal	 := 0
Local aTotItem := {}
Local lAtuTot  := .F.
Local lSeekOrc := .F.
Local lItemOrc := .F.
Local lOrcPrc	 := SuperGetMv("MV_ORCPRC",,.F.)
Local cOrcMod	 := If( lOrcPrc, "TECA740F", "TECA740" )
Local oOrcServico 	:= Nil
Local aArea
Local oMdlADY
Local aNoCpos := {  'TFJ_CODIGO', 'TFJ_PREVIS', 'TFL_CODIGO', 'TFL_CODPAI', 'TFF_COD', 'TFF_CODPAI', 'TFF_LOCAL', 'TFG_COD', 'TFG_CODPAI', 'TFG_LOCAL', ;
					  'TFH_COD', 'TFH_CODPAI', 'TFH_LOCAL','TFI_COD', 'TFI_CODPAI', 'TFI_LOCAL','ABP_ITRH', 'TEV_CODLOC', 'TFU_CODIGO', 'TFU_CODTFF', 'TFU_LOCAL' }
Local nI, nJ, nK, nL

Default cCodPro := ""
Default oMdlProp1	:= FwModelActive()

If ( ValType(oMdlProp)== "U" ) .Or. !oMdlProp:IsActive()
	oMdlProp := oMdlProp1
EndIf
oMdlADY := oMdlProp:GetModel("ADYMASTER")

lRemOrcServ := .F.
aItOrcSerRem := {}

DbSelectArea('TFJ')

At740FMsg( .F. )

If lSubItem // Efetua a substituição de todo o orçamento de serviços na proposta

	// Pesquisa o orçamento cadastrado na vistoria tecnica
	TFJ->( DbSetOrder( 6 ) ) //TFJ_FILIAL+TFJ_CODVIS

	If TFJ->( DbSeek( xFilial('TFJ') + cCodVis ) )

		n := 0 // necessário para PROTHEUSFUNCTIONMVC.PRX no cadastro MVC

		lIncBkp	:= INCLUI				// Backup das variaveis INCLUI e ALTERA
		lAltBkp	:= ALTERA				// Backup das variaveis INCLUI e ALTERA

		If lOrcPrc
			// limpa a variável static aFwSheet do TECA740F
			AT740FCAFW()
			// inclui a tabela de precificação utilizada
			At600STabPrc( TFJ->TFJ_CODTAB, TFJ->TFJ_TABREV )
		EndIf

		oOrcServico := FwLoadModel( cOrcMod )
		oOrcServico:SetOperation( MODEL_OPERATION_INSERT )

		lRet := oOrcServico:Activate(.T.)

	 	If lRet
			oOrcServico:SetValue( "TFJ_REFER", "TFJ_PREVIS", oMdlADY:GetValue("ADY_PREVIS") )
			oOrcServico:SetValue( "TFJ_REFER", "TFJ_PROPOS", oMdlADY:GetValue("ADY_PROPOS") )
			oOrcServico:SetValue( "TFJ_REFER", "TFJ_CODVIS", "" 	)

			At740SCmt(.T.)
			If !(oOrcServico:VldData() .And. oOrcServico:CommitData())
				AtErroMvc( oOrcServico )
				MostraErro()
			Else
				// limpa a variável com os arrays dos objetos de cálculo
				AT740FCAFW()
			EndIf
			At740SCmt(.F.)

		EndIf

		INCLUI := lIncBkp
		ALTERA := lAltBkp

	EndIf

Else

	// Pesquisa o orçamento cadastrado para a proposta comercial
	TFJ->( DbSetOrder( 4 ) ) // TFJ_FILIAL+TFJ_STATUS+TFJ_PROPOS+TFJ_PREVIS
	lSeekOrc := TFJ->( DbSeek( xFilial('TFJ') + DEF_TFJ_ATIVO + oMdlADY:GetValue("ADY_PROPOS") + oMdlADY:GetValue("ADY_PREVIS") ) )

	n := 0 // necessário para PROTHEUSFUNCTIONMVC.PRX no cadastro MVC

	lIncBkp	:= INCLUI				// Backup das variaveis INCLUI e ALTERA
	lAltBkp	:= ALTERA				// Backup das variaveis INCLUI e ALTERA

	oOrcServico := FwLoadModel( cOrcMod )
	oOrcServico:SetOperation( MODEL_OPERATION_INSERT )

	If lSeekOrc


	 	lRet := oOrcServico:Activate(.T.)

	 	If lRet

			oOrcServico:SetValue( "TFJ_REFER", "TFJ_PREVIS", oMdlADY:GetValue("ADY_PREVIS") )
			oOrcServico:SetValue( "TFJ_REFER", "TFJ_PROPOS", oMdlADY:GetValue("ADY_PROPOS") 	)
			oOrcServico:SetValue( "TFJ_REFER", "TFJ_CODVIS", "" 					)

		EndIf

	Else

		lRet := oOrcServico:Activate()

	EndIf

	If lRet

		// Posiciona o grid para o orçamento de serviços da vistoria
		TFJ->( DbSetOrder( 6 ) ) //TFJ_FILIAL+TFJ_CODVIS

		If TFJ->( DbSeek( xFilial('TFJ') + cCodVis ) )

			aTotItem := {}

			If !Empty(cCodPro)
				If TFJ->TFJ_GRPRH == cCodPro
					aAdd( aTotItem, { "TFL_TOTRH", 0 } )
				ElseIf TFJ->TFJ_GRPMI == cCodPro
					aAdd( aTotItem, { "TFL_TOTRH", 0 } )
					aAdd( aTotItem, { "TFL_TOTMI", 0 } )
				ElseIf TFJ->TFJ_GRPMC == cCodPro
					aAdd( aTotItem, { "TFL_TOTRH", 0 } )
					aAdd( aTotItem, { "TFL_TOTMC", 0 } )
				ElseIf TFJ->TFJ_GRPLE == cCodPro
					aAdd( aTotItem, { "TFL_TOTLE", 0 } )
				EndIf
			EndIf

			oMdlOrcSer := FwLoadModel( cOrcMod )
			oMdlOrcSer:SetOperation( MODEL_OPERATION_UPDATE )

			lRet := oMdlOrcSer:Activate()

			If !lSeekOrc
				AtCpyData( oMdlOrcSer:GetModel("TFJ_REFER"), @oOrcServico:GetModel("TFJ_REFER"), aNoCpos ) //realiza copia da linha do model
				oOrcServico:SetValue( "TFJ_REFER", "TFJ_PROPOS", oMdlADY:GetValue("ADY_PROPOS") )
				oOrcServico:SetValue( "TFJ_REFER", "TFJ_PREVIS", Soma1(oMdlADY:GetValue("ADY_PREVIS")) )
				oOrcServico:SetValue( "TFJ_REFER", "TFJ_CODVIS", "" 				)
			EndIf

	 		If lRet

				// Grid de Locais
				For nI := 1 To oMdlOrcSer:GetModel( "TFL_LOC" ):Length()

					lAtuTot := .F.

					oMdlOrcSer:GetModel( "TFL_LOC" ):GoLine(nI)

					If ! Empty(cCodPro)
						For nL := 1 To Len(aTotItem)
							lRet := lRet .And. (oMdlOrcSer:GetValue( "TFL_LOC", aTotItem[nL][1] ) > 0)
						Next nL
					EndIf

					If lRet

						If oOrcServico:GetModel("TFL_LOC"):SeekLine( { { "TFL_LOCAL", oMdlOrcSer:GetValue( "TFL_LOC", "TFL_LOCAL" ) } } )

							If Empty(cCodPro)

								nTotRH := oMdlOrcSer:GetValue( "TFL_LOC", "TFL_TOTRH" ) + oOrcServico:GetValue( "TFL_LOC", "TFL_TOTRH" )
								nTotMI := oMdlOrcSer:GetValue( "TFL_LOC", "TFL_TOTMI" ) + oOrcServico:GetValue( "TFL_LOC", "TFL_TOTMI" )
								nTotMC := oMdlOrcSer:GetValue( "TFL_LOC", "TFL_TOTMC" ) + oOrcServico:GetValue( "TFL_LOC", "TFL_TOTMC" )
								nTotLE := oMdlOrcSer:GetValue( "TFL_LOC", "TFL_TOTLE" ) + oOrcServico:GetValue( "TFL_LOC", "TFL_TOTLE" )

								oOrcServico:SetValue( "TFL_LOC", "TFL_TOTRH", nTotRH )
								oOrcServico:SetValue( "TFL_LOC", "TFL_TOTMI", nTotMI )
								oOrcServico:SetValue( "TFL_LOC", "TFL_TOTMC", nTotMC )
								oOrcServico:SetValue( "TFL_LOC", "TFL_TOTLE", nTotLE )

							Else

								For nL := 1 To Len(aTotItem)
									aTotItem[nL][2] := oMdlOrcSer:GetValue( "TFL_LOC", aTotItem[nL][1] ) + oOrcServico:GetValue( "TFL_LOC", aTotItem[nL][1] )
									oOrcServico:SetValue( "TFL_LOC", aTotItem[nL][1], aTotItem[nL][2] )
								Next nL

							EndIf

						Else

							oOrcServico:GetModel("TFL_LOC"):AddLine()

							nLinha := 	oOrcServico:GetModel( "TFL_LOC" ):Length()
							oOrcServico:GetModel( "TFL_LOC" ):GoLine(nLinha)
							AtCpyData( oMdlOrcSer:GetModel( "TFL_LOC" ), @oOrcServico:GetModel("TFL_LOC"), aNoCpos ) //realiza copia da linha do model

							For nL := 1 To Len(aTotItem)
								aTotItem[nL][2] := oMdlOrcSer:GetValue( "TFL_LOC", aTotItem[nL][1] )
							Next nL

							lAtuTot := !Empty(cCodPro)

						EndIf

						lItemOrc := ( aScan( aTotItem, { |x| x[1] == "TFL_TOTRH" } ) > 0 ) .Or. ;
								     ( aScan( aTotItem, { |x| x[1] == "TFL_TOTMI" } ) > 0 ) .Or. ;
								     ( aScan( aTotItem, { |x| x[1] == "TFL_TOTMC" } ) > 0 )

						If Empty(cCodPro) .Or. lItemOrc

							// **** Grid de Recursos Humanos ****
							For nJ := 1 To oMdlOrcSer:GetModel( "TFF_RH" ):Length()

								oMdlOrcSer:GetModel( "TFF_RH" ):GoLine(nJ)

								If Empty( oMdlOrcSer:GetModel("TFF_RH"):GetValue("TFF_PRODUT") )
									Loop
								EndIf

								If !( nJ == 1 .And. Empty(oOrcServico:GetValue( "TFF_RH", "TFF_PRODUT" ) ) )
									oOrcServico:GetModel( "TFF_RH" ):AddLine()
								EndIf

								nLinha := oOrcServico:GetModel( "TFF_RH" ):Length()
								oOrcServico:GetModel( "TFF_RH" ):GoLine(nLinha)
								AtCpyData( oMdlOrcSer:GetModel( "TFF_RH" ), @oOrcServico:GetModel("TFF_RH"), aNoCpos ) //realiza copia da linha do model
								oOrcServico:SetValue( "TFF_RH", "TFF_ITEM", StrZero(nLinha,2) )

								// Grid de Beneficios
								For nK := 1 To oMdlOrcSer:GetModel( "ABP_BENEF" ):Length()

									oMdlOrcSer:GetModel( "ABP_BENEF" ):GoLine(nK)

									If Empty( oMdlOrcSer:GetModel("ABP_BENEF"):GetValue("ABP_BENEFI") )
										Loop
									EndIf

									If !( nK == 1 .And. Empty(oOrcServico:GetValue( "ABP_BENEF", "ABP_BENEFI" ) ) )
										oOrcServico:GetModel( "ABP_BENEF" ):AddLine()
									EndIf

									nLinha := oOrcServico:GetModel( "ABP_BENEF" ):Length()
									oOrcServico:GetModel( "ABP_BENEF" ):GoLine(nLinha)
									AtCpyData( oMdlOrcSer:GetModel( "ABP_BENEF" ), @oOrcServico:GetModel("ABP_BENEF"), aNoCpos ) //realiza copia da linha do model

								Next nK

								// Grid de Hora Extra
								For nK := 1 To oMdlOrcSer:GetModel( "TFU_HE" ):Length()

									oMdlOrcSer:GetModel( "TFU_HE" ):GoLine(nK)

									If Empty( oMdlOrcSer:GetModel("TFU_HE"):GetValue("TFU_CODABN") )
										Loop
									EndIf

									If !( nK == 1 .And. Empty(oOrcServico:GetValue( "TFU_HE", "TFU_CODABN" ) ) )
										oOrcServico:GetModel( "TFU_HE" ):AddLine()
									EndIf
									nLinha := oOrcServico:GetModel( "TFU_HE" ):Length()

									oOrcServico:GetModel( "TFU_HE" ):GoLine(nLinha)
									AtCpyData( oMdlOrcSer:GetModel( "TFU_HE" ), @oOrcServico:GetModel("TFU_HE"), aNoCpos ) //realiza copia da linha do model

								Next nK

								If Empty(cCodPro) .Or. aScan( aTotItem, { |x| x[1] == "TFL_TOTMI" } ) > 0

									// Grid de Material de Implantação
									For nK := 1 To oMdlOrcSer:GetModel( "TFG_MI" ):Length()

										oMdlOrcSer:GetModel( "TFG_MI" ):GoLine(nK)

										If Empty( oMdlOrcSer:GetModel("TFG_MI"):GetValue("TFG_PRODUT") )
											Loop
										EndIf

										If !( nK == 1 .And. Empty(oOrcServico:GetValue( "TFG_MI", "TFG_PRODUT" ) ) )
											oOrcServico:GetModel( "TFG_MI" ):AddLine()
										EndIf
										nLinha := oOrcServico:GetModel( "TFG_MI" ):Length()

										oOrcServico:GetModel( "TFG_MI" ):GoLine(nLinha)
										AtCpyData( oMdlOrcSer:GetModel( "TFG_MI" ), @oOrcServico:GetModel("TFG_MI"), aNoCpos ) //realiza copia da linha do model
										oOrcServico:SetValue( "TFG_MI", "TFG_ITEM", StrZero(nLinha,2) )

									Next nK

								Else

									oOrcServico:SetValue( "TFF_RH", "TFF_TOTMI", 0 )

								EndIf

								If Empty(cCodPro) .Or. aScan( aTotItem, { |x| x[1] == "TFL_TOTMC" } ) > 0

									// Grid de Material de Consumo
									For nK := 1 To oMdlOrcSer:GetModel( "TFH_MC" ):Length()

										oMdlOrcSer:GetModel( "TFH_MC" ):GoLine(nK)

										If Empty( oMdlOrcSer:GetModel("TFH_MC"):GetValue("TFH_PRODUT") )
											Loop
										EndIf

										If !( nK == 1 .And. Empty(oOrcServico:GetValue( "TFH_MC", "TFH_PRODUT" ) ) )
											oOrcServico:GetModel( "TFH_MC" ):AddLine()
										EndIf
										nLinha := oOrcServico:GetModel( "TFH_MC" ):Length()

										oOrcServico:GetModel( "TFH_MC" ):GoLine(nLinha)
										AtCpyData( oMdlOrcSer:GetModel( "TFH_MC" ), @oOrcServico:GetModel("TFH_MC"), aNoCpos ) //realiza copia da linha do model
										oOrcServico:SetValue( "TFH_MC", "TFH_ITEM", StrZero(nLinha,2) )

									Next nK

								Else

									oOrcServico:SetValue( "TFF_RH", "TFF_TOTMC", 0 )

								EndIf

							Next nJ

						EndIf

						If Empty(cCodPro) .Or. aScan( aTotItem, { |x| x[1] == "TFL_TOTLE" } ) > 0

							// **** Grid de Locação de Equipamentos ****
							For nJ := 1 To oMdlOrcSer:GetModel( "TFI_LE" ):Length()

								oMdlOrcSer:GetModel( "TFI_LE" ):GoLine(nJ)

								If Empty(oMdlOrcSer:GetModel( "TFI_LE" ):GetValue("TFI_PRODUT"))
									Loop
								EndIf

								If !( nJ == 1 .And. Empty(oOrcServico:GetValue( "TFI_LE", "TFI_PRODUT" ) ) )
									oOrcServico:GetModel( "TFI_LE" ):AddLine()
								EndIf

								nLinha := oOrcServico:GetModel( "TFI_LE" ):Length()

								oOrcServico:GetModel( "TFI_LE" ):GoLine(nLinha)
								AtCpyData( oMdlOrcSer:GetModel( "TFI_LE" ), @oOrcServico:GetModel("TFI_LE"), aNoCpos ) //realiza copia da linha do model
								oOrcServico:SetValue( "TFI_LE", "TFI_ITEM", StrZero(nLinha,2) )

								// Grid de Cobrança de Locação
								For nK := 1 To oMdlOrcSer:GetModel( "TEV_ADICIO" ):Length()

									oMdlOrcSer:GetModel( "TEV_ADICIO" ):GoLine(nK)

									If !( nK == 1 .And. Empty(oOrcServico:GetValue( "TEV_ADICIO", "TEV_MODCOB" ) ) )
										oOrcServico:GetModel( "TEV_ADICIO" ):AddLine()
									EndIf
									nLinha := oOrcServico:GetModel( "TEV_ADICIO" ):Length()

									oOrcServico:GetModel( "TEV_ADICIO" ):GoLine(nLinha)
									AtCpyData( oMdlOrcSer:GetModel( "TEV_ADICIO" ), @oOrcServico:GetModel("TEV_ADICIO"), aNoCpos ) //realiza copia da linha do model
									oOrcServico:SetValue( "TEV_ADICIO", "TEV_ITEM", StrZero(nLinha,2) )

								Next nK

							Next nJ

						EndIf

					EndIf

					If lAtuTot .And. !Empty(cCodPro)

						oOrcServico:SetValue( "TFL_LOC", "TFL_TOTRH", 0 )
						oOrcServico:SetValue( "TFL_LOC", "TFL_TOTMI", 0 )
						oOrcServico:SetValue( "TFL_LOC", "TFL_TOTMC", 0 )
						oOrcServico:SetValue( "TFL_LOC", "TFL_TOTLE", 0 )

						For nL := 1 To Len(aTotItem)
							oOrcServico:SetValue( "TFL_LOC", aTotItem[nL][1], aTotItem[nL][2] )
						Next nL

					EndIf

				Next nI

				If !(oOrcServico:VldData() .And. oOrcServico:CommitData())
					lRet := .F.
					AtErroMvc( oOrcServico )
					MostraErro()
				EndIf

	 		EndIf

		EndIf

		If oMdlOrcSer != Nil
			oMdlOrcSer:DeActivate()
			oMdlOrcSer:Destroy()
		EndIf

	EndIf

	INCLUI := lIncBkp
	ALTERA := lAltBkp

EndIf

At740FMsg( .T. )

If lRet
	A600CroFinance( oMdlProp, .T. ) 	//Atualiza cronograma financeiro
	A600Total( Nil, oMdlProp )			//Atualiza total geral
EndIf

Return(lRet)

//------------------------------------------------------------------------------
/*/{Protheus.doc} A600AtuNItem
	Atualiza a referencia do item da proposta dentro do orçamento de serviços

@sample	A600AtuNItem()

@param 		cCodPro - Código do grupo do produto a ser atualizado
@param 		cNumItem - Numero do item da proposta comercial

@since		02/04/2014
@version	P12

/*/
//------------------------------------------------------------------------------
Function A600AtuNItem( cCodPro, cNumItem )

Local lRet    := .F.
Local aArea   := GetArea()
Local lIncBkp := INCLUI				// Backup das variaveis INCLUI e ALTERA
Local lAltBkp := ALTERA				// Backup das variaveis INCLUI e ALTERA
Local lHasOrcServ := .F.

DbSelectArea("TFJ")
TFJ->( DbSetOrder( 2 ) )  // TFJ_FILIAL+TFJ_PROPOS+TFJ_PREVIS

lHasOrcServ := TFJ->( DbSeek( xFilial("TFJ") + M->ADY_PROPOS + M->ADY_PREVIS ) )

If lHasOrcServ
	If TFJ->TFJ_GRPRH == cCodPro
		Reclock("TFJ",.F.)
			TFJ->TFJ_ITEMRH = cNumItem
		TFJ->( MsUnlock() )
	EndIf
	If TFJ->TFJ_GRPMI == cCodPro
		Reclock("TFJ",.F.)
			TFJ->TFJ_ITEMMI = cNumItem
		TFJ->( MsUnlock() )
	EndIf
	If TFJ->TFJ_GRPMC == cCodPro
		Reclock("TFJ",.F.)
			TFJ->TFJ_ITEMMC = cNumItem
		TFJ->( MsUnlock() )
	EndIf
	If TFJ->TFJ_GRPLE == cCodPro
		Reclock("TFJ",.F.)
			TFJ->TFJ_ITEMLE = cNumItem
		TFJ->( MsUnlock() )

	EndIf
EndIf

RestArea(aArea)

INCLUI	:= lIncBkp
ALTERA	:= lAltBkp

Return(lRet)

//------------------------------------------------------------------------------
/*/{Protheus.doc} A600GeraOrc
	Efetua a substituição ou combina as informações do orçamento de serviços

@sample	A600GeraOrc()

@param 		cCodProp   - Código da proposta comercial
@param 		cCodPrevis - Revisão da proposta comercial
@param 		cCodVis    - Código da vistoria tecnica

@since		02/04/2014
@version	P12

/*/
//------------------------------------------------------------------------------
Function A600GeraOrc( cCodProp, cCodPrevis, cCodVis )

Local lIncBkp	 := INCLUI				// Backup das variaveis INCLUI e ALTERA
Local lAltBkp	 := ALTERA				// Backup das variaveis INCLUI e ALTERA
Local lRet	 	 := .F.
Local lOrcPrc	 := SuperGetMv("MV_ORCPRC",,.F.)
Local cOrcMod	 := If( lOrcPrc, "TECA740F", "TECA740" )
Local oOrcServico 	:= Nil

DbSelectArea('TFJ')
TFJ->( DbSetOrder( 2 ) ) //TFJ_FILIAL + TFJ_PROPOS + TFJ_REVIS

If TFJ->( DbSeek( xFilial('TFJ') + cCodProp + cCodPrevis ) )

	At740FMsg( .F. ) // Desabilita as mensagens para o novo modelo de precificação

	n := 0 // necessário para PROTHEUSFUNCTIONMVC.PRX no cadastro MVC

	oOrcServico := FwLoadModel( cOrcMod )
	oOrcServico:SetOperation( MODEL_OPERATION_INSERT )

	oMdlOrcSer := FwLoadModel( cOrcMod )
	oMdlOrcSer:SetOperation( MODEL_OPERATION_UPDATE )

 	lRet := oMdlOrcSer:Activate() .And. oOrcServico:Activate() .And. At740CpyMdl( oMdlOrcSer, oOrcServico )

 	If lRet
 		oMdlOrcSer:DeActivate()
		oMdlOrcSer:Destroy()

		oOrcServico:SetValue( "TFJ_REFER", "TFJ_PREVIS", "" )
		oOrcServico:SetValue( "TFJ_REFER", "TFJ_PROPOS", "" )
		oOrcServico:SetValue( "TFJ_REFER", "TFJ_CODVIS", cCodVis	)

		At740SCmt( .T. )

		lRet := oOrcServico:VldData() .And. oOrcServico:CommitData()

		If ! lRet
			Help(,,'AT600ORCSER',, STR0196,1,0) // 'Não foi possível gravar o orçamento de serviços. Orçamento não será vinculado à Proposta'
		EndIf
		oOrcServico:DeActivate()
		oOrcServico:Destroy()
		oOrcServico := NIL

		At740SCmt( .F. )
	EndIf

	At740FMsg( .T. )
EndIf

INCLUI := lIncBkp
ALTERA := lAltBkp

Return(lRet)

//-----------------------------------------------------------------------------------------
/*/{Protheus.doc} A600EXCORC

Rotina responsavel por excluir os Orçamentos vinculados a proposta comercial

@sample	A600EXCORC(oModel,cId,cAlias)

@param		ExpO1 - Modelo de dados
			ExpC2 - Id do Modelo

@return	ExpL  - Verdadeiro / Falso

@author     Victor Bitencourt
@since      10/10/2014
@version    P12
/*/
//-----------------------------------------------------------------------------------------
Function A600EXCORC(oModel,cId)

Local nOperation	:= oModel:GetOperation()
Local cCodPropos 	:= ""
Local cOport	  	:= ""
Local cOportRev  	:= ""
Local aOrcItens  	:= {}
Local aOrcamento 	:= {}
Local nX         	:= 0
Local nY			:= 0
Local lRet       	:= .T.
Local oMdlOpor		:= FT600MdlOport()
Local oMdlADJ	   	:= oMdlOpor:GetModel("ADJDETAIL")
Local oStructADJ 	:= oMdlADJ:GetStruct()
Local aCamposADJ 	:= oStructADJ:GetFields()
Local cCodPSinc  	:= ""
Local lExistProp 	:= .F.
Local lForceLin  	:= .T.
Local nLinha		:= 0
Local nCount		:= 0
Local aAreaADY		:= {}
Local nOpcADJ		:= SuperGetMv( "MV_FATMNTP",, 1 )
Local cFilSA1		:= xFilial("SA1")
Local cFilADJ		:= xFilial("ADJ")
Local cFilADY		:= xFilial("ADY")
Local cFields		:= ""
Local lPosTCli		:= SCJ->(ColumnPos("CJ_TIPOCLI")) > 0
Local cTipoCli		:= ""

Default oModel := Nil
Default cId	 := ""

If cId == "ADYMASTER" .AND. nOperation == MODEL_OPERATION_DELETE

	SA1->( DBSetOrder(1) )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Permissao para Grid de Produtos da Oportunidade de Venda. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oStructADJ:SetProperty("*",MODEL_FIELD_WHEN,{||.T.})

	cOport	  	:= oModel:GetValue("ADY_OPORTU")
	cOportRev	  	:= oModel:GetValue("ADY_REVISA")
	cCodPropos	:= oModel:GetValue("ADY_PROPOS")//pegando numero da proposta

	cFields := 	"ADY.ADY_PROPOS, SCJ.CJ_FILIAL, SCJ.CJ_NUM "

	If lPosTCli
		cFields += ", SCJ.CJ_TIPOCLI, SCJ.CJ_CLIENTE, SCJ.CJ_LOJA "
	EndIf

	cFields := "%" + cFields + "%"


	 //procurando orçamentos relacionados a proposta comercial e seus itens
	BeginSql Alias "TMPALIAS"
	  SELECT DISTINCT %Exp:cFields%
	  FROM %Table:SCJ% SCJ
	  	LEFT JOIN %Table:ADY% ADY ON (ADY.ADY_PROPOS = SCJ.CJ_PROPOST)
	  WHERE
	  	ADY.ADY_FILIAL = %xFilial:ADY%
	  	AND ADY.ADY_PROPOS = %Exp:cCodPropos%
		AND SCJ.CJ_FILIAL = %xFilial:SCJ%
		AND	SCJ.%NotDel%
		AND	ADY.%NotDel%
	 EndSql

	While TMPALIAS->(!Eof())
    	//cabeçalho do orçamento
   		aAdd(aOrcamento,{	{"CJ_FILIAL"  ,TMPALIAS->CJ_FILIAL 	,Nil}   ,;
							{"CJ_NUM"     ,TMPALIAS->CJ_NUM 		,Nil}   })

		If lPosTCli
			cTipoCli := TMPALIAS->CJ_TIPOCLI
			//Da preferencia para o tipo de cliente gravado no orcamento
			If Empty( cTipoCli )
				//Cliente padrao ou convertido.
				If SA1->( MSSeek(cFilSA1 + TMPALIAS->CJ_CLIENTE + TMPALIAS->CJ_LOJA ) )
					cTipoCli := SA1->A1_TIPO
				EndIf
			EndIf
			aAdd(aOrcamento,{"CJ_TIPOCLI",cTipoCli,Nil})
		EndIf

		TMPALIAS->(DbSkip())
	End

	TMPALIAS->(DbCloseArea())

	If !Empty(aOrcamento)
	 	For nX := 1 To Len(aOrcamento)// excluindo orçamentos
	 		 MATA415(aOrcamento[nX],aOrcItens,5)
	 	Next nX
	EndIf

	DbSelectArea("ADJ")
	ADJ->(DbSetOrder(4)) //ADJ_FILIAL+ADJ_NROPOR+ADJ_REVISA+ADJ_PROPOS+ADJ_NUMORC+ADJ_ITEM
	If DbSeek(cFilADJ + cOport +  cOportRev + cCodPropos )

		While ADJ->(!Eof()) .AND. (ADJ->ADJ_FILIAL + ADJ->ADJ_NROPOR + ADJ->ADJ_REVISA + ADJ_PROPOS == cFilADJ + cOport + cOportRev + cCodPropos)
			RecLock("ADJ",.F.)
			ADJ->(DbDelete())
			MsUnlock()
			ADJ->(DbSkip())
		End

	EndIf

	aAreaADY := ADY->(GetArea())
	DbSelectArea("ADY")
	ADY->(DbSetOrder(2))

	If ADY->(DbSeek(cFilADY+AD1->AD1_NROPOR+AD1->AD1_REVISA))
		While ( ADY->(!Eof()) .AND. ADY->ADY_FILIAL == cFilADY .AND.;
				 ADY->ADY_OPORTU == AD1->AD1_NROPOR .AND. ADY->ADY_REVISA == AD1->AD1_REVISA )
			If ADY->ADY_SINCPR
				cCodPSinc := ADY->ADY_PROPOS
			EndIf
			nCount++
			lExistProp := .T.
			ADY->(DbSkip())
		End
	EndIf

	If nCount == 1
		ADY->(DbSetOrder(2))
		If ADY->(DbSeek(cFilADY+AD1->AD1_NROPOR+AD1->AD1_REVISA))
			cCodPSinc := ADY->ADY_PROPOS
			RecLock("ADY",.F.)
				ADY->ADY_SINCPR := .T.
			MsUnlock()
		EndIf
	EndIf

	RestArea(aAreaADY)

	If nOpcADJ <> 4 //Agrupadores
		oMdlADJ:ClearData()
		oMdlADJ:SetOnlyView(.T.)

		If lExistProp .AND. !Empty(cCodPSinc)

			ADJ->(DbSetOrder(4)) //ADJ_FILIAL+ADJ_NROPOR+ADJ_REVISA+ADJ_PROPOS+ADJ_NUMORC+ADJ_ITEM
			If ADJ->(DbSeek(cFilADJ + cOport +  cOportRev + cCodPSinc ))

				While ADJ->(!Eof()) .AND. (ADJ->ADJ_FILIAL + ADJ->ADJ_NROPOR + ADJ->ADJ_REVISA + ADJ->ADJ_PROPOS == cFilADJ + cOport + cOportRev + cCodPSinc)
					// Sempre inclui novas linhas no ModelGrid de Produtos da Oportunidade.
					If !oMdlADJ:IsEmpty() .OR. oMdlADJ:IsDeleted()
						nLinha := oMdlADJ:AddLine(lForceLin)
						oMdlADJ:GoLine(nLinha)
					EndIf
					For nY := 1 To Len(aCamposADJ)
						If !aCamposADJ[nY][MODEL_FIELD_VIRTUAL]
							oMdlADJ:SetValue(aCamposADJ[nY][3]	,&("ADJ->"+aCamposADJ[nY][3]))
						EndIf
					Next nY
					ADJ->(DbSkip())
				End

			EndIf

		Else

			ADJ->(DbSetOrder(4)) //ADJ_FILIAL+ADJ_NROPOR+ADJ_REVISA+ADJ_PROPOS+ADJ_NUMORC+ADJ_ITEM
			If ADJ->(DbSeek(cFilADJ+cOport+cOportRev))

				While ADJ->(!Eof()) .AND. (ADJ->ADJ_FILIAL + ADJ->ADJ_NROPOR + ADJ->ADJ_REVISA == cFilADJ + cOport + cOportRev )

					If !Empty(ADJ->ADJ_PROPOS)
						// Sempre inclui novas linhas no ModelGrid de Produtos da Oportunidade.
						If !oMdlADJ:IsEmpty() .OR. oMdlADJ:IsDeleted()
							nLinha := oMdlADJ:AddLine(lForceLin)
							oMdlADJ:GoLine(nLinha)
						EndIf
						For nY := 1 To Len(aCamposADJ)
							If !aCamposADJ[nY][MODEL_FIELD_VIRTUAL]
								oMdlADJ:SetValue(aCamposADJ[nY][3]	,&("ADJ->"+aCamposADJ[nY][3]))
							EndIf
						Next nY
					EndIf

					ADJ->(DbSkip())
				End

			EndIf

		EndIf
	Else
		//-------------------------------------------------------------------------------------------------------
		// Quando o tipo do folder de produtos for de Agrupador, não precisa deletar os registros e recriá-los
		// 	tendo em vista que a exclusão de uma proposta não afeta as informações do folder.
		//-------------------------------------------------------------------------------------------------------
		If !Empty( cCodPSinc )
			For nY := 1 To oMdlADJ:Length()
				oMdlADJ:SetValue( "ADJ_PROPOS", cCodPSinc )
			Next( nY )
		EndIf
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Permissao para Grid de Produtos da Oportunidade de Venda. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oStructADJ:SetProperty("*",MODEL_FIELD_WHEN,{||.F.})
	oMdlADJ:GoLine(1)

EndIf

Return lRet

//-----------------------------------------------------------------------------------------
/*/{Protheus.doc} At600GetTab / At600STabPrc

Retorna o codigo e revisão da tabela de precificação selecionada

@sample	At600GetTab()

@return	Array - Lista com os valores

@author     Serviços
@since      24/02/2015
@version    P12
/*/
//-----------------------------------------------------------------------------------------
Function At600GetTab()
Local aRet := {}

If !IsInCallStack('TECA745') .And. !IsInCallStack('At270Orc')
	Aadd(aRet, cPrcOrc)
	Aadd(aRet,cRevPrc)
Else
	aRet := a745GetTab()
EndIf

Return( aRet )


Function At600STabPrc( cTabela, cRevisao )

cPrcOrc := cTabela
cRevPrc := cRevisao
Return( Nil )

//-----------------------------------------------------------------------------------------
/*/{Protheus.doc} A600PROD
 Valida se o produto está habilitado para uso ou se existe na tabela de preços informada.

@sample	A600PROD( cAliasCab, cAliasIt )

@param		cAliasCab - Tabela do cabecalho
			cAliasIt  - Tabela do Item

@return 	lRet -  Indica se o produto existe ou não ou está ativo na tabela de preços.

@author	Thamara Villa Jacomo
@since		03/02/2014
@version	11.90
/*/
//-----------------------------------------------------------------------------------------
Function A600PROD( cAliasCab, cAliasIt )

Local aArea		  := GetArea()
Local lRet		  := .T.
Local cPfxCab	  := ""
Local cPfxItem	  := ""
Local cCpProd	  := ""
Local cCpTabel 	  := ""
Local cCampo	  := ""

Default cAliasCab := ""
Default cAliasIt  := ""

//-------------------------------
// Proposta, Pedido e Orçamento
//-------------------------------
If cAliasIt $ ( "ADZ|SC6|SCK" )

	If cAliasIt == "ADZ"
		cCpProd := "_PRODUT"
	Else
		cCpProd := "_PRODUTO"
	EndIf

	cPfxCab  := Iif( Subs( cAliasCab, 1, 1 ) == "S", Subs( cAliasCab, 2, 3 ), cAliasCab )
	cPfxItem := Iif( Subs( cAliasIt, 1, 1 ) == "S", Subs( cAliasIt, 2, 3 ), cAliasIt )

	cCpTabel := "_TABELA"

	If !Empty( Alltrim( M->&( cPfxCab+cCpTabel ) ) )
		DbSelectArea( "DA1" )
		DbSetOrder( 1 )
		If DbSeek( xFilial( "DA1" ) + Alltrim( M->&( cPfxCab+cCpTabel ) ) + Alltrim( M->&( cPfxItem+cCpProd ) ) )
			If DA1->DA1_ATIVO <> "1" //Sim
				Aviso( STR0019, STR0225, { STR0065 }, 2 )//"Atenção"###"Produto informado não está ativo na tabela de preços, sendo assim, não será possível utiliza-lo." # "ok"
				lRet := .F.
				M->&( cPfxItem+cCpProd ) := Space( TamSX3( cPfxItem+cCpProd )[1] )
		    EndIf
		 Else
			Aviso( STR0019, STR0226, { STR0065 }, 2 ) //"Atenção", "O produto não existe na tabela de preços informada. Verifique!" # "OK"
			lRet := .F.
			M->&( cPfxItem+cCpProd ) := Space( TamSX3( cPfxItem+cCpProd )[1] )
		EndIf
	EndIf
EndIf

RestArea( aArea )

Return( lRet )

//------------------------------------------------------------------------------
/*/{Protheus.doc} At600ARROS
	Le e/ou Grava a partir da variável estática oOrcServico


@sample 	At600ARROS(lValor)
@param		[lValor],logica,Referência a ser atribuida à variável estática lRemOrcServ

@since		23/09/2013
@version	P11.90

/*/
//------------------------------------------------------------------------------
Function At600ARROS( lValor )

If lValor <> nil
	lRemOrcServ := lValor
EndIf

Return lRemOrcServ

//------------------------------------------------------------------------------
/*/{Protheus.doc} At600ARIOS
	Le e/ou Grava a partir da variável estática oOrcServico


@sample 	At600ARIOS(aRef)
@param		[aRef],array,Referência a ser atribuida à variável estática aItOrcSerRem

@since		23/09/2013
@version	P11.90

/*/
//------------------------------------------------------------------------------
Function At600ARIOS( aRef )

If !Empty(aRef)
	aItOrcSerRem := AClone(aRef)
EndIf

Return aItOrcSerRem

//------------------------------------------------------------------------------
/*/	{Protheus.doc} MyFata600
Exemplo para utilizacao da Rotina Automatica para Proposta Comercial.
@sample		MyFata600
@param		Nenhum
@return		ExpL - Rotina Automatica Executada com Sucesso.
@author	Thamara Villa Jacomo
@since		12/08/2015
@version	P12
/*/
//-----------------------------------------------------------------------------
// User Function MyFata600()
//
// Local nOperation		:= 3
// Local aADZProduto		:= {}
// Local aADYMaster		:= {}
// Local aADZAcessor		:= {}
// Local lRetorno		:= .T.
//
// Private lMsErroAuto := .F.
//
// RpcSetEnv( "T1", "D MG 01", "Admin", "",,, )
//
// //-----------------------------------------------
// // Cabeçalho da Proposta Comercial
// //----------------------------------------------
// aAdd( aADYMaster, {"ADY_OPORTU", cCodOport, Nil } )
// aAdd( aADYMaster, {"ADY_REVISA", "01", Nil } )
// aAdd( aADYMaster, {"ADY_DATA", dDatabase, Nil } )
// aAdd( aADYMaster, {"ADY_ENTIDA", "1", Nil } ) //1=Cliente; 2=Prospect
// aAdd( aADYMaster, {"ADY_CODIGO", "000001", Nil } )
// aAdd( aADYMaster, {"ADY_LOJA", "00", Nil } )
// aAdd( aADYMaster, {"ADY_TABELA", "001", Nil } )
//
// //-----------------------------------------------
// // Itens da Proposta Comercial - Folder Produtos
// //-----------------------------------------------
// aAdd( aADZProduto,{ {"ADZ_PRODUT", "CRM001", Nil } ,;
// 					 	{"ADZ_CONDPG", "001", Nil }   ,;
// 					 	{"ADZ_TES", "502", Nil }		  ,;
// 						{"ADZ_QTDVEN", 2, Nil }		  ,;
// 						{"ADZ_CODAGR", "000004", Nil },;
// 						{"ADZ_CODNIV", "001", Nil } } )
//
// //-------------------------------------------------
// // Itens da Proposta Comercial - Folder Acessórios
// //-------------------------------------------------
// aAdd( aADZAcessor, { {"ADZ_PRODUT", "CRM002", Nil },;
// 						{"ADZ_CONDPG", "001", Nil }   ,;
// 						{"ADZ_TES", "502", Nil }		  ,;
// 						{"ADZ_QTDVEN", 4, Nil } } )
//
//
// FATA600( /*oMdlFt300*/, nOperation, aADYMaster, aADZProduto, aADZAcessor )
//
// If lMsErroAuto
//        lRetorno := .F.
//        DisarmTransaction()
//        MostraErro()
// Else
//        Conout( "Proposta incluída com sucesso.!" )
// EndIf
//
// RpcClearEnv()
//
// Return(lRetorno)

//------------------------------------------------------------------------------
/*/{Protheus.doc} N600SetVis
Set das variáveis relacionadas com vistoría.


@sample 	N600SetVis(lVistoria,oMdlVis)
@param		lVistoria	Definição se utilizará vistoria
@param		oMdlVis	Modelo de Vistoria

@since		31/01/2011
@version	P12

/*/
//------------------------------------------------------------------------------
Function N600SetVis(lVistoria,oMdlVis)

lVist		:= lVistoria
oMdlVist	:= oMdlVis

Return Nil

//------------------------------------------------------------------------------
/*/{Protheus.doc} N600SetVis
Set das variáveis relacionadas com vistoría.

@sample 	N600GetVis(lVistoria,oMdlVis)

@since		31/01/2011
@version	P12
@Return 	Array com as informações de vistoria
/*/
//------------------------------------------------------------------------------
Function N600GetVis()

Local aRet := {}

aAdd(aRet,lVist)
aAdd(aRet,oMdlVist)

Return aRet

/*/{Protheus.doc} n600MdProp
@description 	Definição do modelo a ser usado
@since			25.07.2017
@version		P12
/*/
Function n600MdProp( oMdlTmp )

If ValType(oMdlTmp) == "O"
	oMdlProp := oMdlTmp
EndIf

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} FT600VENCATU
@description	Atualiza as datas de vecimentos do cronograma financeiro para
              	garantir que todos os vencimentos correspondam ao vencimento real
@param			aCronoAtu - Array com parecela e vencimento
@return		aCronoAtu - Array ajustado com as datas dentro do venc. real
@author		Renato da Cunha
@since			11/07/2016
@version		12.1.17
/*/
//-------------------------------------------------------------------
Static Function Ft600VencAtu(aCronoAtu)

Local nPos		:= 0

Default aCronoAtu		:= {}

If ! Empty(aCronoAtu)
	For nPos := 1 to Len (aCronoAtu)
		aCronoAtu[nPos][1] := DataValida(aCronoAtu[nPos][1], .T.)
	Next nPos
EndIf
Return (aCronoAtu)

//-------------------------------------------------------------------
/*/{Protheus.doc} Ft600Folcg - Folder Change
Atualiza o cronograma quando trocar o Folder para o Cronograma

@param		Void
@return		.T.
@author		Squad CRM
@since		15/12/2017
@version	12.1.17
/*/
//-------------------------------------------------------------------
Function Ft600Folcg()
	Local oView		:= FwViewActive()
	Local oModel	:= FwModelActive()
	Local aFolder	:= {}

	If oView <> Nil  .And. !IsBlind() .And. ( oModel:GetOperation() <> MODEL_OPERATION_VIEW .And. oModel:GetOperation() <> MODEL_OPERATION_DELETE )
		aFolder := oView:GetFolderActive('ABAS',2 )
		If !Empty(aFolder)
			If Upper(Alltrim(aFolder[2])) $ 'PRODUTO' .OR. Upper(Alltrim(aFolder[2])) $ 'ACESSORIO' //Ultimo folder antes da troca
				A600CroFinance( oModel, .F. )
				oView:Refresh('CRONOFIN')
			EndIf
		EndIf
	EndIf

Return .T.

//-------------------------------------------------------------------
/*/{Protheus.doc} A600CroTot
Atualiza o valor total do cronograma, quando o produto possui moeda
diferente de 1.

Obs.: Escopo mantido como Function pois será utilizada no futuro para
condição de pagamento tipo 09 (FATN600/FATV600).

@param		nValtot, Numérico, conteúdo do campo ADZ_TOTAL
			cMoeda, Caracter, conteúdo do campo ADZ_MOEDA
@return		nValtot, Numérico, conteúdo do campo ADZ_TOTAL com tratamento de moeda

@author		Squad CRM
@since		30/05/2018
@version	12.1.17+
/*/
//-------------------------------------------------------------------
Function A600CroTot(nValtot, cMoeda)
	Local nMoeda 	:= Val(cMoeda)
	Default nValtot := 0
	Default cMoeda 	:= '1'

	If  nMoeda > 1
		nValtot := xMoeda( nValtot,  nMoeda, 1 , dDatabase, GetSX3Cache("ADZ_TOTAL","X3_DECIMAL") )
	EndIf
Return nValtot