#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GJPSC010 º Autor ³ Carlos A. Queiroz  º Data ³  18/04/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Consulta especifica para mostrar os contratos vigentes e    º±±
±±º          ³com saldo para um dado produto.                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GJPSC010()

Local cTitulo	:= "Consulta Contratos Vigentes"					//Titulo da consulta
Local aArea		:= getArea()
Local aCampos	:= {"Filial","Contrato","Revisão","Fornecedor","Valor Unit.","Saldo","Planilha","Item Planilha","Descrição"} 	//Colunas da consulta
Local aItens	:= {}  												//Itens da consulta
Local nRet		:= 0                               					//Linha selecionada da lista

Local cTMP  	:= GetNextAlias()
Local cHoje		:= Date()
Local lRet      := .T.
Local nPosLog	:= aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_XLOGPRD'})

//Local nPosPrd	:= aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_PRODUTO'})
//Local nPosQtd	:= aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_QUANT'})
//Local nPosPrc   := aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_VUNIT'})
//Local nPosFil  	:= aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_XCONTFI'})
//Local nPosRevis	:= aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_XCONTRV'})
//Local nPosPl	:= aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_XCONTPL'})
//Local nPosIt	:= aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_XCONTIT'})
//Local nPosFor	:= aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_FORNECE'})
//Local nPosLoj	:= aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_LOJA'})

Local cQuery    := ""


//Verifica se a linha referente ao produto e a quantidade estao preenchidas na getdados
If !Empty(M->C1_PRODUTO)
	
	//	If ExistBlock("CN109QC")
	//		cQuery := ExecBlock("CN109QC",.F.,.F.,{aCols[n][nPosPrd],cHoje})
	//	EndIf
	
	If (Empty(cQuery))
		cQuery := " ORDER BY CN9.CN9_NUMERO "
		cQuery := '%' + cQuery + '%'
	EndIf
	
	BeginSQL Alias cTMP
		SELECT CN9.CN9_FILIAL, CN9.CN9_NUMERO, CN9.CN9_REVISA, CN9.CN9_DESCRI, CNA.CNA_FORNEC, CNA.CNA_LJFORN, CNB.CNB_VLUNIT, CNB.CNB_SLDREC, CNA.CNA_NUMERO, CNB.CNB_ITEM, CNB.CNB_SLDMED
		FROM	%Table:CNB% CNB, %Table:CN9% CN9, %Table:CNA% CNA, %Table:CN1% CN1
		WHERE	CN9.CN9_FILIAL  =   %xFilial:CN9%  			AND
		CNB.CNB_FILIAL  =   %xFilial:CNB% 			AND
		CNA.CNA_FILIAL  =   %xFilial:CNA% 			AND
		CN1.CN1_FILIAL  =   %xFilial:CN1% 			AND
		CNB.CNB_CONTRA	=	CN9.CN9_NUMERO			AND
		CNB.CNB_REVISA	=	CN9.CN9_REVISA			AND
		CNB.CNB_CONTRA	=	CNA.CNA_CONTRA			AND
		CNB.CNB_REVISA	=	CNA.CNA_REVISA			AND
		CNB.CNB_NUMERO	=	CNA.CNA_NUMERO			AND
		CN9.CN9_TPCTO	=	CN1.CN1_CODIGO			AND
		CN1.CN1_MEDEVE	=	'1'						AND
		CN1.CN1_ESPCTR	=	'1'						AND
		CNB.CNB_PRODUT	=	%Exp:M->C1_PRODUTO%	    AND
		CN9.CN9_DTFIM	>=	%Exp:cHoje%				AND
		CN9.CN9_SITUAC	=	'05'					AND
		//				CN9.CN9_XREGP	=	'1'						AND
		CNB.CNB_SLDMED  >   '0'                     AND
		CNB.%NotDel%								AND
		CNA.%NotDel%								AND
		CN9.%NotDel%
		
		//Query do ponto de entrada
		%exp:cQuery%
		
		
	EndSQL
	
	While (cTMP)->(!EOF())
		
		//		If ((cTMP)->CNB_SLDREC - aCols[n][nPosQtd]) >= 0
		
		AADD(aItens,{(cTMP)->CN9_FILIAL,(cTMP)->CN9_NUMERO,(cTMP)->CN9_REVISA,(cTMP)->CNA_FORNEC,(cTMP)->CNB_VLUNIT,;
		(cTMP)->CNB_SLDMED,(cTMP)->CNA_NUMERO,(cTMP)->CNB_ITEM,(cTMP)->CN9_DESCRI,(cTMP)->CNA_LJFORN})
		
		//		EndIf
		
		(cTMP)->(dbSkip())
		
	EndDo
	
	If Len(aItens) > 0
		if msgyesno("Este produto possui contrato vigente no sistema, para geração de um Pedido de Compras utilize a rotina de Medição de Contratos. Caso deseje continuar a solicitar sem usar o contrato, clique 'Sim'","Produto com Contrato existente!!!")
			//Funcao que cria uma tela para exibicao da consulta
//			nRet := TmsF3Array(aCampos,aItens,cTitulo,.T.,,aCampos)
			If msgyesno("Deseja selecionar o produto "+alltrim(M->C1_PRODUTO)+" - "+alltrim(Posicione("SB1",1,xFilial("SB1")+M->C1_PRODUTO,"B1_DESC"))+" para esta SC mesmo ele pertencendo a um contrato vigente?")
				aCols[n][nPosLog]	:= "Produto inserido na SC pertence a um Contrato Vigente."
				lRet := .T.
			Else
				aCols[n][nPosLog]	:= ""
				lRet := .F.
			EndIf
			/*
			If nRet > 0//nRet e o numero da linha selecionada na consulta
			
			VAR_IXB				:= aItens[nRet][2]//VAR_IXB e o campo que sera retornado na consulta especifica
			aCols[n][nPosPrc]	:= aItens[nRet][5]//atribui o valor ao item no aCols
			aCols[n][nPosFil]	:= aItens[nRet][1]//atribui a filial ao campo do aCols
			aCols[n][nPosRevis]	:= aItens[nRet][3]//atribui a revisao ao campo do aCols
			aCols[n][nPosPl]	:= aItens[nRet][7]//atribui a Planilha ao campo do aCols
			aCols[n][nPosIt]	:= aItens[nRet][8]//atribui a Item Planilha ao campo do aCols
			aCols[n][nPosFor]	:= aItens[nRet][4]//ATRIBUI O FORNECEDOR
			aCols[n][nPosLoj]	:= aItens[nRet][10]//ATRIBUI A LOJA DO FORNECEDOR
			
			Else
			VAR_IXB := CriaVar("C1_XCONTPR",.F.)
			aCols[n][nPosFil]	:= Space(7)//atribui a filial ao campo do aCols
			aCols[n][nPosRevis]	:= Space(3)//atribui a revisao ao campo do aCols
			aCols[n][nPosPl]	:= Space(6)//atribui a Planilha ao campo do aCols
			aCols[n][nPosIt]	:= Space(3)//atribui a Item Planilha ao campo do aCols
			
			EndIf
			
			Else
			
			MsgAlert("Nenhum Contrato Encontrado.")
			VAR_IXB := CriaVar("C1_XCONTPR",.F.)
			aCols[n][nPosFil]	:= Space(7)
			aCols[n][nPosRevis]	:= Space(3)
			aCols[n][nPosPl]	:= Space(6)
			aCols[n][nPosIt]	:= Space(3)
			*/
		Else
			lRet := .F.
		EndIf
	Else
		aCols[n][nPosLog]	:= ""
		lRet := .T.
	EndIf
	
	(cTMP)->(dbCloseArea())//Fecha a tabela temporaria
	
Else
	
	MsgAlert("Preencha o campo: "+AllTrim(RetTitle("C1_PRODUTO"))+".")
	
EndIf

restArea(aArea)

Return lRet