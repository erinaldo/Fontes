#include "totvs.ch"
#include "protheus.ch"
#include "Topconn.ch"

//////////////////////////////////////////////////////////
// VARIAVEL RETIRADAS DO FONTE DANFEII - ESPECIFICO RISA /
//////////////////////////////////////////////////////////

#DEFINE MAXMENLIN  097			// M�ximo de caracteres por linha de dados adicionais
#DEFINE MAXITEMC   052			// M�xima de caracteres por linha de produtos/servi�os

/*/

{Protheus.doc} PE01NFESEFAZ
                 
Ponto de entrada para alterar itens de nota fiscal

@author  Milton J.dos Santos	
@since   22/07/20
@version 1.0

/*/

User Function PE01NFESEFAZ()

Local aProd   		:= PARAMIXB[1]
Local cMensCli		:= PARAMIXB[2]
Local cMensFis		:= PARAMIXB[3]
Local aDest   		:= PARAMIXB[4]
Local aNota   		:= PARAMIXB[5]
Local aInfoItem		:= PARAMIXB[6]
Local aDupl	  		:= PARAMIXB[7]
Local aTransp		:= PARAMIXB[8]
Local aEntrega		:= PARAMIXB[9]
Local aRetirada		:= PARAMIXB[10]
Local aVeiculo		:= PARAMIXB[11]
Local aReboque		:= PARAMIXB[12]
Local aNfVincRur    := PARAMIXB[13]
Local aEspVol       := PARAMIXB[14]
Local aNfVinc       := PARAMIXB[15]
Local aDetPag       := PARAMIXB[16]
Local aObsCont      := PARAMIXB[17]
Local aProcRef		:= PARAMIXB[18]

Local aRetorno		:= {}
Local I             := 0
Local aArea         := GetArea()
Local cCodCli       := " "
Local cLoja         := " "
Local cGrupo        := GetMv("MV_GRUVEI")
Local cGrpPrd       := ""
Local cItem         := ""
Local cCodM         := ""
Local cMarca        := ""	
Local lVeic         := .F.

Local hQuebraCpl	:= "#"
Local nI			:= 0

SF2->(DbSetOrder(1))
CD9->(DbSetOrder(1))
SD2->(DbSetOrder(3))
SC6->(DbSetOrder(1)) // C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
SC5->(DbSetOrder(1))
SF4->(DbSetOrder(1))
SM4->(DbSetOrder(1))
SD1->(DbSetOrder(1))
SA1->(DbSetOrder(1))
SA2->(DbSetOrder(1))
VV1->(DbSetOrder(2)) // Por Chassi
VV2->(DbSetOrder(1)) // VV2_FILIAL+VV2_CODMAR+VV2_MODVEI+VV2_SEGMOD
SF1->(DbSetOrder(1)) // F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
SW6->(DbSetOrder(1)) // W6_FILIAL+W6_HAWB
EIH->(DbSetOrder(1)) // EIH_FILIAL+EIH_HAWB+EIH_CODIGO
SJF->(DbSetOrder(1)) // JF_FILIAL+JF_CODIGO
SW9->(DbSetOrder(3)) // W9_FILIAL+W9_HAWB
SWV->(DbSetOrder(2)) // WV_FILIAL+WV_HAWB+WV_INVOICE+WV_PGI_NUM+WV_PO_NUM+WV_POSICAO
SWD->(DbSetOrder(1)) // WD_FILIAL+WD_HAWB+WD_DESPESA+DTOS(WD_DES_ADI)
SYB->(DbSetOrder(1)) // YB_FILIAL+YB_DESP
VV0->(DbSetOrder(4)) // VV0_FILIAL+VV0_NUMNFI+VV0_SERNFI

If Alltrim(aNota[4]) == "1" .Or. (aNota[5] $ "B/D" .And. Alltrim(aNota[4]) == "0") 
	cCodCli       := Posicione("SA1",3,xFilial("SA1")+aDest[1],"A1_COD")
	cLoja         := Posicione("SA1",3,xFilial("SA1")+aDest[1],"A1_LOJA")
ElseIf aNota[5] $ "N" .And. Alltrim(aNota[4]) == "0" .And. aDest[7] == "99999"
	cCodCli       := Posicione("SA2",3,xFilial("SA2")+aDest[1],"A2_COD")
	cLoja         := Posicione("SA2",3,xFilial("SA2")+aDest[1],"A2_LOJA")
Endif

//Verifica se � Nota de Veiculo SIGAVEI
VV0->(Dbgotop())
If VV0->(DbSeek(xFilial("VV0")+aNota[2]+aNota[1]))
	lVeic := .T.
Endif

If aNota[5] == "N" .And. lVeic 
	For I:= 1 to Len(aProd)
		cGrpPrd := Posicione("SB1",1,xFilial("SB1")+aProd[I][2]	,"B1_GRUPO"	)
		cItem   := Strzero(aProd[I][1],2)
		
//		Tratativa para colocar os dados abaixo em Informa��es adicionais do Produto
//      e ser Impresso na DANFE, incluindo espa�os na descri��o para impress�o da Danfe ficar colunado
// 		Deixamos com 35 pois a Variav�l na Impress�o da DANFE MAXITEMC est� com 35
		
		If cGrpPrd $ cGrupo    
			cCodM   := Posicione("VV1",2,xFilial("VV1")+aProd[I][4]	,"VV1_CODMAR")
			cCodV   := Posicione("VV1",2,xFilial("VV1")+aProd[I][4]	,"VV1_MODVEI")
			cMarca  := Posicione("VE1",1,xFilial("VE1")+cCodM		,"VE1_DESMAR")

			cAux1 := " Marca: "		+ Alltrim(cMarca)
			cAux2 := " Chassi: "	+ Alltrim(aProd[I][4])
			IF VV2->( DbSeek( xFilial("VV2") + cCodM + cCodV ))
				cAux3 := " Modelo: " 	+ Alltrim(VV2->VV2_DESMOD)
			ELSE
				cAux3 := ""
			Endif

			cAux4 := " Serie No.: "	+ Alltrim(VV1->VV1_SERMOT)
			cAux5 := " Ano/Modelo: "+ Alltrim(Substr(VV1->VV1_FABMOD,1,4))+"/"+Alltrim(Substr(VV1->VV1_FABMOD,5,4))
			cAux6 := " Motor No.: " + Alltrim(VV1->VV1_NUMMOT)

//			aProd[i][ 4] := cAux1+Space(39-Len(cAux1))+cAux2+Space(39-Len(cAux2))+cAux3+Space(39-Len(cAux3))
//			aProd[i][25] := cAux4+Space(39-Len(cAux4))+cAux5+Space(39-Len(cAux5))+cAux6+Space(39-Len(cAux6))
			aProd[i][ 4] := PadR( cAux1, MAXITEMC ) + PadR( cAux2, MAXITEMC )
			aProd[i][25] := PadR( cAux3, MAXITEMC ) + PadR( cAux4, MAXITEMC ) + PadR( cAux5, MAXITEMC ) + PadR( cAux6, MAXITEMC )
				
		Endif
	Next
Endif

//��������������������������������������������������������
//�Executa regras quando se trata de nota fiscal de sa�da�
//��������������������������������������������������������
If aNota[4] == "1"

	//��������������������������������������������������������
	//�Obt�m c�digo do fornecedor\cliente do documento fiscal�
	//��������������������������������������������������������
	If aNota[5] $ "B\D"
		dbSelectArea("SA2")
		SA2->(dbSetOrder(1))
		SA2->(dbGoTop())
		If SA2->(dbSeek(xFilial("SA2") + SF2->F2_CLIENTE + SF2->F2_LOJA))
			cCliFor	:= SA2->A2_COD
			cLoja	:= SA2->A2_LOJA  
		EndIf                      
	Else                           
		dbSelectArea("SA1")
		SA1->(dbSetOrder(1))
		SA1->(dbGoTop())
		If SA1->(dbSeek(xFilial("SA1") + SF2->F2_CLIENTE + SF2->F2_LOJA))
	    	cCliFor	:= SA1->A1_COD
	    	cLoja	:= SA1->A1_LOJA   
		EndIf
	EndIf
	
	//����������������������������������������������
	//�Garante posicionamento do documento de sa�da�
	//����������������������������������������������
	dbSelectArea("SF2")
	SF2->(dbSetOrder(1))
	SF2->(dbGoTop())
	If SF2->(dbSeek(xFilial("SF2") + aNota[2] + aNota[1] + cCliFor + cLoja))
	
		//���������������������������������������������������������������������
		//�Executa la�o de processamento de todos os itens do documento fiscal�
		//���������������������������������������������������������������������
		For nI := 1 To Len(aInfoItem)
	
			//������������������������������������������������������
			//�Posiciona no item do documento fiscal conforme array�
			//������������������������������������������������������
			dbSelectArea("SD2")
			SD2->(dbSetOrder(3))
			SD2->(dbGoTop())
			If SD2->(dbSeek(xFilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA + aProd[nI][2] + aInfoItem[nI][4]))
				
				//�������������������������������������������
				//�Posiciona no cabe�alho do pedido de venda�
				//�������������������������������������������
				dbSelectArea("SC5")
				SC5->(dbSetOrder(1))
				SC5->(dbGoTop())
				SC5->(dbSeek(xFilial("SC5") + SD2->D2_PEDIDO))
				
				//��������������������������������������
				//�Posiciona no item do pedido de venda�
				//��������������������������������������
				dbSelectArea("SC6")
				SC6->(dbSetOrder(1))
				SC6->(dbGoTop())
				SC6->(dbSeek(xFilial("SC6") + SD2->D2_PEDIDO + SD2->D2_ITEMPV))
				
				//�������������������������������������������������
				//�Verifica se trata-se de remessa de venda futura�
				//�������������������������������������������������
				If !EMPTY(SC6->C6_CONTRAT) .AND. SC6->C6_CONTRAT != SC6->C6_NUM
					dbSelectArea("ADB")
					ADB->(dbSetOrder(1))
					ADB->(dbGoTop())
					If ADB->(dbSeek(xFilial("ADB") + SC6->C6_CONTRAT))
						If !EMPTY(ADB->ADB_PEDCOB)
							dbSelectArea("SC5")
							SC5->(dbSetOrder(1))
							SC5->(dbGoTop())
							If SC5->(dbSeek(xFilial("SC5") + ADB->ADB_PEDCOB))
								If !EMPTY(SC5->C5_NOTA) .AND. SC5->C5_NOTA != SF2->F2_DOC
									dbSelectArea("SF2")
									SF2->(dbSetOrder(1))
									SF2->(dbGoTop())
									If SF2->(dbSeek(xFilial("SF2") + SC5->C5_NOTA + SC5->C5_SERIE + SC5->C5_CLIENTE + SC5->C5_LOJACLI))
										cMsgVdFut := "NF Venda Futura: " + ALLTRIM(SC5->C5_NOTA) + "\" + ALLTRIM(SC5->C5_SERIE) + " - " + DTOC(SF2->F2_EMISSAO) + " - R$ " + ALLTRIM(TRANSFORM(SF2->F2_VALBRUT, PESQPICT("SF2", "F2_VALBRUT"))) + hQuebraCpl
										
										//�����������������������������������������������������������
										//�Adiciona a mensagem da venda futura caso ainda n�o exista�
										//�����������������������������������������������������������
										If !ALLTRIM(cMsgVdFut) $ cMensCli
											cMensCli += cMsgVdFut
										EndIf
									EndIf
								EndIf							
							EndIf
						EndIf
					EndIf
					
					//������������������������������������������������������������
					//�Garante posicionamento no item do pedido referente � venda�
					//������������������������������������������������������������
					dbSelectArea("SC6")
					SC6->(dbSetOrder(1))
					SC6->(dbGoTop())
					SC6->(dbSeek(xFilial("SC6") + SD2->D2_PEDIDO + SD2->D2_ITEMPV))
					
					//�����������������������������������������������������������
					//�Garante posicionamento no cabe�alho do documento de sa�da�
					//�����������������������������������������������������������
					dbSelectArea("SF2")
					SF2->(dbSetOrder(1))
					SF2->(dbGoTop())
					SF2->(dbSeek(xFilial("SF2") + aNota[2] + aNota[1] + cCliFor + cLoja))
				EndIf
			EndIf
		Next nI
	EndIf

Else

	//����������������������������������������������������������
	//�Executa regras quando se trata de nota fiscal de entrada�
	//����������������������������������������������������������

	
	//��������������������������������������������������������
	//�Obt�m c�digo do fornecedor\cliente do documento fiscal�
	//��������������������������������������������������������
	If !aNota[5] $ "B\D"
		dbSelectArea("SA2")
		SA2->(dbSetOrder(1))
		SA2->(dbGoTop())
		If SA2->(dbSeek(xFilial("SA2") + SF1->F1_FORNECE + SF1->F1_LOJA))
			cCliFor	:= SA2->A2_COD
			cLoja	:= SA2->A2_LOJA  
		EndIf                      
	Else                           
		dbSelectArea("SA1")
		SA1->(dbSetOrder(1))
		SA1->(dbGoTop())
		If SA1->(dbSeek(xFilial("SA1") + SF1->F1_FORNECE + SF1->F1_LOJA))
	    	cCliFor	:= SA1->A1_COD
	    	cLoja	:= SA1->A1_LOJA   
		EndIf
	EndIf
	
	//������������������������������������������������
	//�Garante posicionamento do documento de entrada�
	//������������������������������������������������
	dbSelectArea("SF1")
	SF1->(dbSetOrder(1))
	SF1->(dbGoTop())
	If SF1->(dbSeek(xFilial("SF2") + aNota[2] + aNota[1] + cCliFor + cLoja))
	
		//���������������������������������������������������������������������
		//�Executa la�o de processamento de todos os itens do documento fiscal�
		//���������������������������������������������������������������������
		For nI := 1 To Len(aInfoItem)
	
			//������������������������������������������������������
			//�Posiciona no item do documento fiscal conforme array�
			//������������������������������������������������������
			dbSelectArea("SD1")
			SD1->(dbSetOrder(1))
			SD1->(dbGoTop())
			If SD1->(dbSeek(xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA + aProd[nI][2] + aInfoItem[nI][4]))
				
				//���������������������������������������
				//�Atualiza array de NFP vinculada � NFE�
				//���������������������������������������
				If !EMPTY(SD1->D1_GCSRPRO) .AND. !EMPTY(SD1->D1_GCNFPRO)
					If SA2->A2_TIPO == "F" .AND. !aNota[5] $ "B\D"
						AADD(aNfVincRur, {SD1->D1_EMISSAO, SD1->D1_GCSRPRO, SD1->D1_GCNFPRO, "NFP", SA2->A2_CGC, SA2->A2_EST, SA2->A2_INSCR})
					EndIf
				EndIf
			EndIf
		Next nI
	EndIf
EndIf

//������������������������������������������������������������������������������������
//�Tratamento para remover CHR(13) caso exista na mensagem - Dados Adicionais Cliente�
//������������������������������������������������������������������������������������
If !EMPTY(cMensCli)
	cMensCli := STRTRAN(cMensCli, CHR(13), " ")
EndIf

//����������������������������������������������������������������������������������
//�Tratamento para remover CHR(13) caso exista na mensagem - Dados Adicionais Fisco�
//����������������������������������������������������������������������������������
If !EMPTY(cMensFis)
	cMensFis := STRTRAN(cMensFis, CHR(13), " ")
EndIf

RestArea(aArea)

aAdd(aRetorno,aProd)
aAdd(aRetorno,cMensCli)
aAdd(aRetorno,cMensFis)
aAdd(aRetorno,aDest)
aAdd(aRetorno,aNota)
aAdd(aRetorno,aInfoItem)
aAdd(aRetorno,aDupl)
aAdd(aRetorno,aTransp)
aAdd(aRetorno,aEntrega)
aAdd(aRetorno,aRetirada)
aAdd(aRetorno,aVeiculo)
aAdd(aRetorno,aReboque)
aAdd(aRetorno,aNfVincRur)
aAdd(aRetorno,aEspVol)
aAdd(aRetorno,aNfVinc)
aAdd(aRetorno,aDetPag)
aAdd(aRetorno,aObsCont)
aAdd(aRetorno,aProcRef)

//                                            ^
//                                            |
/*Implemente o ponto de entrada antes da chamada do Bloco de Fun��o do Gest�o de Cereais....*/
//*************************************************************************************************************************************
//�������������������������������������������������������������������������������������������������������������������������������������
//� Espec�fico para ser utilizado pelo Gest�o de Cereais                                                                              �
//�������������������������������������������������������������������������������������������������������������������������������������   
If ExistBlock("GCNFE001")
	aRetorno := ExecBlock( "GCNFE001", .F., .F., {aRetorno, hQuebraCpl})
EndIf

Return( aRetorno )


