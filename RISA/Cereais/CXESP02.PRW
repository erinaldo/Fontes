#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CXESP02   ºAutor  ³Marcelo Joner        º Data ³ 12/03/2018 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável pela carga da tabela de classificação na º±±
±±º          ³pesagem conforme definições do contrato selecionado.        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Risa S/A                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CXESP02()

Local lRet			:= .T.
Local lUpdCla		:= .T.
Local lUpdSub		:= .F.
Local nI			:= 0
Local aArea			:= GetArea()
Local cCliFor		:= cCodCliFor
Local cCodLoj		:= cLojCliFor
Local cCodOpe		:= ""
Local cCodPrd		:= ""
Local cCodTab		:= ""
Local cTpCt			:= SUBSTR(cDocumento, 1, 2)
Local cTpRoma		:= IIF(ALLTRIM(UPPER(aOperacoes[oCbOperacao:nAt])) == "ENTRADA", "1", "2")
Local cTpOper		:= IIF(cTpCt == "CC", "G3", IIF(cTpCt == "CV", "G8", "G7"))
Local cCodFil		:= SUBSTR(cDocumento, 3, TAMSX3("ZDA_FILIAL")[1])
Local nQtdDesCla	:= aScan(aHeaderClas,{|x| ALLTRIM(x[2]) == 'ZCC_QUANT'})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Executa regras caso seja Abertura\Inclusão de nova pesagem³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
If nOpc == 3
	Do Case
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Executa regras quando trata-se de Ct. Compra³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		Case cTpCt == "CC"
			dbSelectArea("ZDA")
			ZDA->(dbSetOrder(1))
			ZDA->(dbGoTop())
			If ZDA->(dbSeek(xFilial("ZDA", cCodFil) + PADR(cDocumento, TAMSX3("ZDA_NUM")[1])))
				cCodOpe := "G3"
				cCodTab := ZDA->ZDA_TBCLAS
				cCodPrd := ZDA->ZDA_PRODUT
			Else
				lRet := .F.
				ShowHelpDlg("Atenção", {"O Ct. Compra " + ALLTRIM(TRANSFORM(cDocumento, PESQPICT("ZDA", "ZDA_NUM"))) + " não foi localizado."}, 5, {"Favor verificar se o contrato informado é válido."}, 5)
			EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Executa regras quando trata-se de Ct. Venda³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		Case cTpCt == "CV"
			dbSelectArea("ZDP")
			ZDP->(dbSetOrder(1))
			ZDP->(dbGoTop())
			If ZDP->(dbSeek(xFilial("ZDP", cCodFil) + PADR(cDocumento, TAMSX3("ZDP_NUM")[1])))
				cCodOpe := "G8"
				cCodTab := ZDP->ZDP_TBCLAS
				cCodPrd := ZDP->ZDP_PROD
			Else
				lRet := .F.
				ShowHelpDlg("Atenção", {"O Ct. Venda " + ALLTRIM(TRANSFORM(cDocumento, PESQPICT("ZDP", "ZDP_NUM"))) + " não foi localizado."}, 5, {"Favor verificar se o contrato informado é válido."}, 5)
			EndIf
			
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Executa regras quando trata-se de Ct. Serviço³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		Case cTpCt == "CS"
			dbSelectArea("ZEG")
			ZEG->(dbSetOrder(1))
			ZEG->(dbGoTop())
			If ZEG->(dbSeek(xFilial("ZEG", cCodFil) + PADR(cDocumento, TAMSX3("ZEG_NUM")[1])))
				cCodOpe := "G7"
				cCodPrd := ZEG->ZEG_PROD1
				If cTpRoma == "1"
					cCodTab := ZEG->ZEG_CLAENT
				Else
					cCodTab := ZEG->ZEG_CLASAI
				EndIf
			Else
				lRet := .F.
				ShowHelpDlg("Atenção", {"O Ct. Serviço " + ALLTRIM(TRANSFORM(cDocumento, PESQPICT("ZEG", "ZEG_NUM"))) + " não foi localizado."}, 5, {"Favor verificar se o contrato informado é válido."}, 5)
			EndIf
			
	EndCase
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Valida Produto X Tab. Classificação obtida no contrato³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	dbSelectArea("SB1")
	SB1->(dbSetOrder(1))
	SB1->(dbGoTop())
	SB1->(dbSeek(xFilial("SB1") + cCodPrd))
	If SB1->B1_GCCLASS == "1" .AND. EMPTY(cCodTab)
		lRet := .F.
		ShowHelpDlg("Atenção", {"Não foi definida à tabela de classificação no contrato  " + ALLTRIM(TRANSFORM(cDocumento, PESQPICT("ZEG", "ZEG_NUM"))) + "."}, 5, {"Favor verificar se o contrato informado é válido."}, 5)
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Executa demais regras, caso tenha validado o contrato corretamente³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If lRet
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Executa função do Addon Gestão de Cereais para carga das regras de classificação da pesagem³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		lRet := U_MOV01ZCJ(cCodFil, cTpRoma, cCliFor, cCodLoj, cCodOpe, cCodPrd, cCodTab, .F.,, .T.)
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Executa regras de calculo dos totais da pesagem³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
ElseIf nOpc == 4

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Atualiza os totais da pesagem com base na classificação³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	nPesoDesconto := 0
	For nI := 1 To Len(aColsClas)
		dbSelectArea("ZCH")
		ZCH->(dbSetOrder(1))
		ZCH->(dbGoTop())
		ZCH->(dbSeek(xFilial("ZCH") + aColsClas2[nI][1])) 
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Desconto do item de classificação compõe o total de descontos da carga³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If ZCH->ZCH_CARGA != "2"
			nPesoDesconto += ROUND(aColsClas[nI][nQtdDesCla], 0) 
		EndIf
	Next nI
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Recalcula totais da pesagem³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ	
	nPesoBalanca := nPesoBruto - nPesoTara
	nPesoLiquido := nPesoBalanca - nPesoDesconto
EndIf

RestArea(aArea)

Return lRet
