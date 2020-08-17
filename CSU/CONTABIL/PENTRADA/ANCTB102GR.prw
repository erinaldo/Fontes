/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Program   �ANCTB102GR� Autor � Daniel G.Jr.TI1239    � Data � 24.10.08 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de Entrada da rotina CTBA102, antes de gravar o TMP  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ANCTB102GR(nOpc,dDataEst,cLoteEst,cSubLtEst,cDocEst)       ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fico CSU                                             ���
�������������������������������������������������������������������������Ĵ��
���Parametros�  ExpN1 = Numero da opcao escolhida                         ���
���          �  ExpD1 = Data do lancamento                                ���
���          �  ExpC1 = Numero do Lote  	                              ���
���          �  ExpC2 = Numero do Sub-Lote 	                              ���
���          �  ExpC3 = Numero do Documento		                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function ANCTB102GR()
//ExecBlock("ANCTB102GR",.F.,.F.,{ nOpc,dDataEst,cLoteEst,cSubLtEst,cDocEst }  )

Private nOpc 		:= PARAMIXB[1]
Private dDataEst	:= PARAMIXB[2]
Private cLoteEst	:= PARAMIXB[3]
Private cSubLtEst	:= PARAMIXB[4]
Private cDocEst		:= PARAMIXB[5]
Private cLinhaAlt	:= "001"


If nOpc == 6	//Se for estorno de lan�amento contabil por lote
	
	// RECRIA O ARQUIVO TMP COM TODAS AS LINHAS DE HIST�RICO
	TMP->(dbGoTop())
	If !TMP->(Eof())
		CT2->(dbGoTo(TMP->CT2_RECNO))
		dbSelectArea("TMP")
		ZAP			// Elimina registros da tabela TMP
		lContinua := Ctb102CEst(nOpc,@dDataEst,cLoteEst,cSubLtEst,cDocEst,@cLinhaAlt)
	EndIf
	
EndIf

Return(.T.)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Program   �CTB102Carr� Autor � Pilar S. Albaladejo   � Data � 24.07.00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Carrega arq. temporario com dados para MSGETDB             ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � CTB102Carr(nOpc,dDataLanc,cLote,cSubLote,cDoc)             ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
���Parametros�  ExpN1 = Numero da opcao escolhida                         ���
���          �  ExpD1 = Data do lancamento                                ���
���          �  ExpC1 = Numero do Lote  	                              ���
���          �  ExpC2 = Numero do Sub-Lote 	                              ���
���          �  ExpC3 = Numero do Documento		                          ���
���          �  ExpC4 = Numero da Linha    		                          ���
���          �  ExpC5 = Nome da Rotina que esta executando     		      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function CTB102CEst(nOpc,dLanc,cPLote,cPSubLote,cPDoc,cLinhaAlt,cProg)

Local aSaveArea	:= GetArea()
Local aAreaCT2	:= CT2->(GetArea())
Local cAlias	:= "CT2"
Local cCritConv	:= ""
Local nPos
Local cMoeda
Local nVezes	:= 1
Local nC		:= 0
Local nTamCrit	:= Len(CriaVar("CT2_CONVER"))
Local nCont
Local lContinua	:= .T.
Local dDataLanc := dLanc
Local cLote 	:= cPLote
Local cSubLote	:= cPSubLote
Local cDoc		:= cPDoc
Local cHistSobra:= "", cHS := ""

cLinhaAlt := "001"
cProg	:= ""

dDataLanc 	:= CT2->CT2_DATA
cLote 	 	:= CT2->CT2_LOTE
cSubLote	:= CT2->CT2_SBLOTE
cDoc		:= CT2->CT2_DOC
dbSelectArea("CT2")
dbSetOrder(1)

cLinhaAlt := FieldGet(FieldPos("CT2_LINHA"))


If MsSeek(xFilial()+Dtos(dDataLanc)+cLote+cSubLote+cDoc)
	
	While !Eof().And. lContinua .And. CT2->CT2_FILIAL == xFilial() 	.And.;
		CT2->CT2_DATA   == dDataLanc	.And.;
		CT2->CT2_LOTE   == cLote 		.And.;
		CT2->CT2_SBLOTE == cSubLote 	.And.;
		CT2->CT2_DOC    == cDoc
		
		//So ira mostrar na Getdb os lancamentos da moeda 01
		If CT2->CT2_MOEDLC <> '01'
			dbSkip()
			Loop
		EndIf
		
		dbSelectArea("TMP")
		dbAppend()
		For nCont := 1 To Len(aHeader)
			nPos := FieldPos(aHeader[nCont][2])
			If (aHeader[nCont][08] <> "M" .And. aHeader[nCont][10] <> "V" )
				FieldPut(nPos,(cAlias)->(FieldGet(FieldPos(aHeader[nCont][2]))))
			EndIf
		Next nCont
		TMP->CT2_FLAG 		:= .F.
		TMP->CT2_SEQLAN		:= CT2->CT2_SEQLAN
		TMP->CT2_SEQHIS		:= CT2->CT2_SEQHIS
		TMP->CT2_EMPORI		:= CT2->CT2_EMPORI
		TMP->CT2_FILORI		:= CT2->CT2_FILORI
		TMP->CT2_KEY		:= CT2->CT2_KEY
		TMP->CT2_RECNO		:= CT2->(Recno())
		cCritConv			:= CT2->CT2_CRCONV
		cMoeda				:= CT2->CT2_MOEDLC
		
		If CT2->CT2_DC <> "4"		// Se n�o for linha de hist�rico
			
			If CT2->CT2_DC == "1"	// Debito eh trocado pelo credito e vice-versa
				TMP->CT2_DC	:= "2"
			ElseIf CT2->CT2_DC == "2"
				TMP->CT2_DC	:= "1"
			Else
				TMP->CT2_DC	:= "3"
			EndIf
			TMP->CT2_CREDIT	:= CT2->CT2_DEBITO
			TMP->CT2_DEBITO	:= CT2->CT2_CREDIT
			TMP->CT2_CCC	:= CT2->CT2_CCD
			TMP->CT2_CCD	:= CT2->CT2_CCC
			TMP->CT2_ITEMC	:= CT2->CT2_ITEMD
			TMP->CT2_ITEMD	:= CT2->CT2_ITEMC
			TMP->CT2_CLVLCR	:= CT2->CT2_CLVLDB
			TMP->CT2_CLVLDB	:= CT2->CT2_CLVLCR   
			cHistSobra 		:= Iif( Len(Trim(CT2->CT2_HIST))>36, Right(CT2->CT2_HIST,4), "")
			TMP->CT2_HIST 	:= "EST."+CT2->CT2_HIST
			TMP->CT2_ORIGEM	:= "ESTORNO "+DTOC(CT2->CT2_DATA)+" "+;
							   CT2->CT2_LOTE+" "+CT2->CT2_SBLOTE+" "+CT2->CT2_DOC+" "+CT2->CT2_LINHA
			
		Else

			cHS:=""
			If !Empty(cHistSobra)
				cHS := cHistSobra
				cHistSobra := Iif( Len(Trim(CT2->CT2_HIST)) > (40-Len(Trim(cHS))), Right(CT2->CT2_HIST,Len(Trim(cHS))), "")
				TMP->CT2_HIST := cHS + CT2->CT2_HIST
			Endif
			
		EndIf
		
		dbSelectArea("CT2")
		dbSkip()
		
		While !Eof().And. lContinua .And. CT2->CT2_FILIAL == xFilial() 					.And.;
			CT2->CT2_DATA   == dDataLanc					.And.;
			CT2->CT2_LOTE   == cLote 						.And.;
			CT2->CT2_SBLOTE == cSubLote 					.And.;
			CT2->CT2_DOC 	  == cDoc						.And.;
			CT2->CT2_TPSALD == TMP->CT2_TPSALD 			.And.;
			CT2->CT2_EMPORI == TMP->CT2_EMPORI 			.And.;
			CT2->CT2_FILORI == TMP->CT2_FILORI			.And.;
			CT2->CT2_LINHA  == TMP->CT2_LINHA  			.And.;
			CT2->CT2_MOEDLC <> cMoeda
			
			If CT2->CT2_DC <> "4"
				&("TMP->CT2_VALR"+CT2->CT2_MOEDLC) := CT2->CT2_VALOR
				
				If CtbUso("CT2_DTTX"+CT2->CT2_MOEDLC)
					&("TMP->CT2_DTTX"+CT2->CT2_MOEDLC)	:= CT2->CT2_DATATX
				EndIf
				
				If Len(cCritConv) <> Val(CT2->CT2_MOEDLC)-1
					nMoeAtu	:= Val(CT2->CT2_MOEDLC)-1
					For nC := Len(cCritConv)+1 to nMoeAtu
						cCritConv += "5"
					Next
				Endif
				
				cCritConv += CT2->CT2_CRCONV
				nVezes ++
			EndIf
			dbSkip()
		EndDo
		
		If Len(cCritConv) < nTamCrit
			For nC	:= Len(cCritConv)+1 to nTamCrit
				cCritConv += "5"
			Next
		EndIf
		
		TMP->CT2_CONVER	:= cCritConv
		
	EndDo
EndIf

dbSelectArea("TMP")
dbSetOrder(2)
dbGoTop()

RestArea(aAreaCT2)
RestArea(aSaveArea)

Return lContinua
