#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CXESP05   ºAutor  ³Marcelo Joner        º Data ³ 09/04/2018 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada executado no ato da finalização da pesagem.º±±
±±º          ³Utilizado para integração com o Addon Gestão de Cereais.    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Risa S/A                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CXESP05()

Local lRet			:= .F.
Local aDefZCB		:= {}
Local aDefZCC		:= {}
Local aDefZCD		:= {}
Local aDefZCE		:= {}
Local aColsClas		:= {}
Local aColsClas2	:= {}
Local nX			:= 0
Local cTpCt			:= SUBSTR(Z01->Z01_DOCUME, 1, 2)
Local cTpRom		:= IIF(Z01->Z01_OPERAC == "E", "1", "2")
Local cNumCt 		:= PADR(Z01->Z01_DOCUME, TAMSX3("ZCB_NUMCC")[1])
Local cFilCt		:= SUBSTR(Z01->Z01_DOCUME, 3, TAMSX3("ZCB_FILIAL")[1])
Local cTpOper		:= IIF(cTpCt == "CC", "G3", IIF(cTpCt == "CV", "G8", "G7"))
Local cPrdTransg	:= "" //IIF(Z01->Z01_TRANSG == "S", "1", "2")
Local cTstTransg	:= "" //IIF(!EMPTY(Z01->Z01_TRANSG), "1", "2")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Composição à respeito do Produto Ser Transgênico (1-SIM\2-NÃO)³
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Do Case
	Case ALLTRIM(Z01->Z01_TRANSG) $ "1/3"
		cPrdTransg := "2"
	OtherWise
		cPrdTransg := "1"
EndCase

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Composição do resultado de Transgênia (1-POSITIVO\2-NEGATIVO)³
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Do Case
	Case ALLTRIM(Z01->Z01_TRANSG) $ "2/4"
		cTstTransg := "1"
	OtherWise
		cTstTransg := "2"
EndCase

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Composição das informações do Romaneio - ZCB³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
AADD(aDefZCB, {"ZCB_FILIAL"	, xFilial("ZCB"), Nil})
AADD(aDefZCB, {"ZCB_TPROMA"	, cTpRom        , Nil})

dbSelectArea("ZCT")
ZCT->(dbSetOrder(1))
ZCT->(dbGoTop())
ZCT->(dbSeek(xFilial("ZCT") + cTpOper))
AADD(aDefZCB, {"ZCB_OPERAC"	, ZCT->ZCT_OPERAC, Nil})
AADD(aDefZCB, {"ZCB_DOPERA"	, ZCT->ZCT_DESC  , Nil})

dbSelectArea("SB1")
SB1->(dbSetOrder(1))
SB1->(dbGoTop())
SB1->(dbSeek(xFilial("SB1") + Z01->Z01_PRODUT))
AADD(aDefZCB, {"ZCB_PROD"	, Z01->Z01_PRODUT, Nil})
AADD(aDefZCB, {"ZCB_DESPRO"	, SB1->B1_DESC   , Nil})
AADD(aDefZCB, {"ZCB_TRANSG" , cPrdTransg     , Nil})
AADD(aDefZCB, {"ZCB_TESTAD" , cTstTransg     , Nil})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Informações do Cliente\Fornecedor³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
AADD(aDefZCB, {"ZCB_CLIFOR"	, Z01->Z01_CLIFOR, Nil})
AADD(aDefZCB, {"ZCB_LOJA"	, Z01->Z01_LJCLFR, Nil})

dbSelectArea("ZCT")
ZCT->(dbSetOrder(1))
ZCT->(dbGoTop())
ZCT->(dbSeek(xFilial("ZCT") + cTpOper))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Tratamento do Cliente\Fornecedor quando é Ct. Serviços³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
If ZCT->ZCT_CONTS == "1"
	dbSelectArea("ZEG")
	ZEG->(dbSetOrder(1))
	ZEG->(dbGoTop())
	If ZEG->(dbSeek(xFilial("ZEG", cFilCt) + cNumCt))
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Executa regras quando é Ct. Serviço - NORMAL³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If ZEG->ZEG_TIPO == "1"
			dbSelectArea("SA2")
			SA2->(dbSetOrder(1))
			SA2->(dbGoTop())
			SA2->(dbSeek(xFilial("SA2") + Z01->Z01_CLIFOR + Z01->Z01_LJCLFR))
			AADD(aDefZCB, {"ZCB_NOME"	, SA2->A2_NOME, Nil})
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Executa regras quando é Ct. Serviço - BENEFICIAMENTO³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			dbSelectArea("SA1")
			SA1->(dbSetOrder(1))
			SA1->(dbGoTop())
			SA1->(dbSeek(xFilial("SA1") + Z01->Z01_CLIFOR + Z01->Z01_LJCLFR))
			AADD(aDefZCB, {"ZCB_NOME"	, SA1->A1_NOME, Nil})
		EndIf
	EndIf
	
Else

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Tratamento do Cliente\Fornecedor nos demais casos³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If cTpRom == "1"
		If "SA1" $ ZCT->ZCT_CPRENT
			dbSelectArea("SA1")
			SA1->(dbSetOrder(1))
			SA1->(dbGoTop())
			SA1->(dbSeek(xFilial("SA1") + Z01->Z01_CLIFOR + Z01->Z01_LJCLFR))
			AADD(aDefZCB, {"ZCB_NOME"	, SA1->A1_NOME, Nil})
		Else
			dbSelectArea("SA2")
			SA2->(dbSetOrder(1))
			SA2->(dbGoTop())
			SA2->(dbSeek(xFilial("SA2") + Z01->Z01_CLIFOR + Z01->Z01_LJCLFR))
			AADD(aDefZCB, {"ZCB_NOME"	, SA2->A2_NOME, Nil})
		EndIf
	Else
		If "SA1" $ ZCT->ZCT_CPRSAI
			dbSelectArea("SA1")
			SA1->(dbSetOrder(1))
			SA1->(dbGoTop())
			SA1->(dbSeek(xFilial("SA1") + Z01->Z01_CLIFOR + Z01->Z01_LJCLFR))
			AADD(aDefZCB, {"ZCB_NOME"	, SA1->A1_NOME, Nil})
		Else
			dbSelectArea("SA2")
			SA2->(dbSetOrder(1))
			SA2->(dbGoTop())
			SA2->(dbSeek(xFilial("SA2") + Z01->Z01_CLIFOR + Z01->Z01_LJCLFR))
			AADD(aDefZCB, {"ZCB_NOME"	, SA2->A2_NOME, Nil})
		EndIf
	EndIf
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Informação do Contrato vinculado à pesagem³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Do Case
	Case cTpCt == "CC"
		dbSelectArea("ZDA")
		ZDA->(dbSetOrder(1))
		ZDA->(dbGoTop())
		ZDA->(dbSeek(xFilial("ZDA", cFilCt) + cNumCt))
		cSafra := ZDA->ZDA_SAFRA
		AADD(aDefZCB, {"ZCB_FILCV"	, cFilCt, Nil})
		AADD(aDefZCB, {"ZCB_NUMCC"	, cNumCt, Nil})
		
	Case cTpCt == "CS"
		dbSelectArea("ZEG")
		ZEG->(dbSetOrder(1))
		ZEG->(dbGoTop())
		ZEG->(dbSeek(xFilial("ZEG", cFilCt) + cNumCt))
		cSafra := ZEG->ZEG_SAFRA
		AADD(aDefZCB, {"ZCB_FILCV"	, cFilCt, Nil})
		AADD(aDefZCB, {"ZCB_NUMCS"	, cNumCt, Nil})
		
	Case cTpCt == "CV"
		dbSelectArea("ZDP")
		ZDP->(dbSetOrder(1))
		ZDP->(dbGoTop())
		ZDP->(dbSeek(xFilial("ZDP", cFilCt) + cNumCt))
		cSafra := ZDP->ZDP_SAFRA
		AADD(aDefZCB, {"ZCB_FILCV"	, cFilCt, Nil})
		AADD(aDefZCB, {"ZCB_NUMCV"	, cNumCt, Nil})
EndCase


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Safra vinculada à pesagem³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
dbSelectArea("ZC0")
ZC0->(dbSetOrder(1))
ZC0->(dbGoTop())
ZC0->(dbSeek(xFilial("ZC0") + cSafra))
AADD(aDefZCB, {"ZCB_SAFRA"	, ZC0->ZC0_COD , Nil})
AADD(aDefZCB, {"ZCB_DSAFRA"	, ZC0->ZC0_DESC, Nil})


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Informações de transporte da pesagem³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
dbSelectArea("SA4")
SA4->(dbSetOrder(1))
SA4->(dbGoTop())
SA4->(dbSeek(xFilial("SA4") + Z01->Z01_TRANSP))
AADD(aDefZCB, {"ZCB_TRANSP"	, Z01->Z01_TRANSP, Nil})
AADD(aDefZCB, {"ZCB_DTRANS"	, SA4->A4_NOME   , Nil})

dbSelectArea("DA3")
DA3->(dbSetOrder(1))
DA3->(dbGoTop())
DA3->(dbSeek(xFilial("DA3") + Z01->Z01_VEICUL))
AADD(aDefZCB, {"ZCB_VEICUL"	, Z01->Z01_VEICUL, Nil})
AADD(aDefZCB, {"ZCB_PLACA"	, Z01->Z01_PLCVEI, Nil})

dbSelectArea("DUT")
DUT->(dbSetOrder(1))
DUT->(dbGoTop())
DUT->(dbSeek(xFilial("DUT") + DA3->DA3_TIPVEI))
AADD(aDefZCB, {"ZCB_TPVEIC"	, DUT->DUT_TIPVEI, Nil})
AADD(aDefZCB, {"ZCB_DTPVEI"	, DUT->DUT_DESCRI, Nil})

dbSelectArea("DA4")
DA4->(dbSetOrder(1))
DA4->(dbGoTop())
DA4->(dbSeek(xFilial("DA4") + Z01->Z01_MOTORI))
AADD(aDefZCB, {"ZCB_CODMOT"	, Z01->Z01_MOTORI, Nil})
AADD(aDefZCB, {"ZCB_NOMEMO" , DA4->DA4_NOME  , Nil})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Informações dos pesos vinculados à pesagem³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
nKgBrt := Z01->Z01_PBRUTO - Z01->Z01_PTARA
nKgLiq := nKgBrt - Z01->Z01_DESCON
If cTpRom == "1"
	AADD(aDefZCB, {"ZCB_KGINI"	, Z01->Z01_PBRUTO, Nil})
	AADD(aDefZCB, {"ZCB_DTINI"	, Z01->Z01_DTBRUT, Nil})
	AADD(aDefZCB, {"ZCB_HRINI"	, Z01->Z01_HRBRUT, Nil})
	AADD(aDefZCB, {"ZCB_KGFIN"	, Z01->Z01_PTARA , Nil})
	AADD(aDefZCB, {"ZCB_DTFIN"	, Z01->Z01_DTTARA, Nil})
	AADD(aDefZCB, {"ZCB_HRFIN"	, Z01->Z01_HRTARA, Nil})
Else
	AADD(aDefZCB, {"ZCB_KGINI"	, Z01->Z01_PTARA , Nil})
	AADD(aDefZCB, {"ZCB_DTINI"	, Z01->Z01_DTTARA, Nil})
	AADD(aDefZCB, {"ZCB_HRINI"	, Z01->Z01_HRTARA, Nil})
	AADD(aDefZCB, {"ZCB_KGFIN"	, Z01->Z01_PBRUTO, Nil})
	AADD(aDefZCB, {"ZCB_DTFIN"	, Z01->Z01_DTBRUT, Nil})
	AADD(aDefZCB, {"ZCB_HRFIN"	, Z01->Z01_HRBRUT, Nil})
EndIf

AADD(aDefZCB, {"ZCB_KGBRT"	, nKgBrt         , Nil})
AADD(aDefZCB, {"ZCB_KGDESC"	, Z01->Z01_DESCON, Nil})
AADD(aDefZCB, {"ZCB_KGLIQ"	, nKgLiq         , Nil})
AADD(aDefZCB, {"ZCB_PESQUA"	, "2"            , Nil})
AADD(aDefZCB, {"ZCB_STATUS" , "2"            , Nil})



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Prepara array referente as definições de classificação³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
aHeaderClas := U_MONTAHEADER("ZCC")
dbSelectArea("Z02")
Z02->(dbSetOrder(1)) 
Z02->(dbGoTop()) 
If Z02->(dbSeek(xFilial("Z02") + Z01->Z01_NUM))
	While Z02->(!EOF()) .AND. Z02->Z02_FILIAL == xFilial("Z02") .AND. Z02->Z02_NUM == Z01->Z01_NUM
		AADD(aColsClas, ARRAY(Len(aHeaderClas) + 1))
		For nX := 1 To Len(aHeaderClas)
			If !EMPTY(nPosZ02 := FieldPos(STRTRAN(aHeaderClas[nX][2], "ZCC_", "Z02_")))
				aColsClas[Len(aColsClas)][nX] := Z02->(FieldGet(nPosZ02))
			EndIf  
		Next
		aColsClas[Len(aColsClas)][Len(aHeaderClas) + 1] := .F.        
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Carrega o array auxiliar aColsClas2                                                                                                                                                               ³
		//³Tabela de Classificacao, Padrao de recebimento, Codigo do Tipo de Desconto, Fator de Calculo utilizado, Tipo Desconto Obrigatorio (1=SIM / 2=NAO), Desconto PH, Nível de Calculo, Filial da Tabela³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		AADD(aColsClas2, {Z02->Z02_CODTAB, Z02->Z02_PADRAO, Z02->Z02_CODDES, Z02->Z02_FATOR, POSICIONE("ZCG", 1, xFilial("ZCG") + Z02->Z02_CODDES, "ZCG_OBRIGAT"), Z02->Z02_DESCPH, Z02->Z02_NIVEL, Z02->Z02_FILTAB})
		
		Z02->(dbSkip())
	End
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Adiciona os arrays de classificação ao array de integração³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	AADD(aDefZCC, aColsClas)
	AADD(aDefZCC, aColsClas2)
EndIf



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Prepara array referente ao teste de transgenia³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
AADD(aDefZCD, {STRZERO(1, TAMSX3("ZCD_ITEM")[1]), cTstTransg})



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Prepara array referente ao rateio de renda³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
AADD(aDefZCE, {Z01->Z01_NUMNF, Z01->Z01_SERIE, Z01->Z01_PESONF, Z01->Z01_VLRNF})



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Executa rotina automática de ABERTURA do Romaneio - Addon Gestão de Cereais³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
lRet := U_MOV01AUT(aDefZCB, aDefZCC, aDefZCD, aDefZCE, 3)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Após execução com sucesso da ABERTURA DO ROMANEIO, executa o FECHAMENTO DO ROMANEIO³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
If lRet

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Executa rotina automática de FECHAMENTO do Romaneio - Addon Gestão de Cereais³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	lRet := U_MOV01AUT(aDefZCB, aDefZCC, aDefZCD, aDefZCE, 4)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Após execução com sucesso do FECHAMENTO DO ROMANEIO, atualiza campos de vinculo entre à Pesagem e Romaneio³
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If lRet
		dbSelectArea("ZCB")
		RECLOCK("ZCB", .F.)
			ZCB->ZCB_X_NPES := Z01->Z01_NUM
		ZCB->(MSUNLOCK())
		
		dbSelectArea("Z01")
		RECLOCK("Z01", .F.)
			Z01->Z01_ROMGC  := ZCB->ZCB_NUM
		Z01->(MSUNLOCK())
	EndIf
EndIf

Return lRet
