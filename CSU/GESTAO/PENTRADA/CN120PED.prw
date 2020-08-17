#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH" 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CN120PED ³ Autor ³ Carlos Tagliaferri Jr ³ Data ³ 21.12.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Ponto de entrada executado no momeno do encerramento da     ³±±
±±³          ³medicao, quando o sistema gera o pedido de compras.         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico CSU                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³			   ³		³	   ³										  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CN120PED()

Local aCab 		:= PARAMIXB[1]	//Cabecalho
Local aItm 		:= PARAMIXB[2]  //Itens
Local nx
Local nPosCpo
Local cNatur	:= ""
Local nTotLinha
Local ny
Local cObjeto	:=""
Local cCompMed 	:= CND->CND_COMPET
Local cContra   := CND->CND_CONTRA  //MELHORIA - OS 0295/13
Local cFil		:= cnd->CND_FILIAL  //MELHORIA - OS 0295/13
dbSelectArea("CN9") //Tabela de contratos
dbSetOrder(1)

//Posiciona no contrato com base na medicao selecionada
dbSeek(xFilial("CN9")+CND->CND_CONTRA+CND->CND_REVISA)
 
//Varre os itens
For nx:=1 to len(aItm)
	If(nPosCpo:=aScan(aItm[nx],{|x|x[1]=="C7_XJUSTIF"}))>0		//Verifica se o campo ja existe no array
		nTotLinha := MlCount(MSMM(CN9->CN9_CODOBJ))
		If nTotLinha > 0
			For ny:=1 to nTotLinha
				cObjeto+=MemoLine(MSMM(CN9->CN9_CODOBJ),,ny)
			Next
			aItm[nx,nPosCpo,2]:=cObjeto		   							//Altera informacao
		Endif
	Else
		nTotLinha := MlCount(MSMM(CN9->CN9_CODOBJ))
		If nTotLinha > 0
			For ny:=1 to nTotLinha
				cObjeto+=MemoLine(MSMM(CN9->CN9_CODOBJ),,ny)
			Next
			aAdd(aItm[nx],{"C7_XJUSTIF",cObjeto,Nil})					//Inclui o campo
		Endif
	Endif
Next

dbSelectArea("CNE")		//Tabela de itens de medicoes
dbSetOrder(1)

//Posiciona nos itens da medicao
dbSeek(xFilial("CNE")+CND->CND_CONTRA+CND->CND_REVISA+CND->CND_NUMERO+CND->CND_NUMMED)

cNatur   := CNE->CNE_XNATUR                   

//Varre o array de itens
For nx:=1 to Len(aItm)
	If(nPosCpo:=aScan(aItm[nx],{|x|x[1]=="C7_CC"}))>0   		//Verifica se o campo ja existe no array
		aItm[nx,nPosCpo,2]:=CNE->CNE_X_SOLI					//Altera informacao
	Else
		aAdd(aItm[nx],{"C7_CC",CNE->CNE_X_SOLI,Nil})			//Inclui o campo
	Endif

	If(nPosCpo:=aScan(aItm[nx],{|x|x[1]=="C7_ITEMCTA"}))>0	//Verifica se o campo ja existe no array
		aItm[nx,nPosCpo,2]:=CNE->CNE_X_UNNE					//Altera informacao
	Else
		aAdd(aItm[nx],{"C7_ITEMCTA",CNE->CNE_X_UNNE,Nil})		//Inclui o campo
	Endif
	
	If(nPosCpo:=aScan(aItm[nx],{|x|x[1]=="C7_CLVL"}))>0		//Verifica se o campo ja existe no array
		aItm[nx,nPosCpo,2]:=CNE->CNE_X_OPER					//Altera informacao
	Else
		aAdd(aItm[nx],{"C7_CLVL",CNE->CNE_X_OPER,Nil})			//Inclui o campo
	Endif

	If(nPosCpo:=aScan(aItm[nx],{|x|x[1]=="C7_XNATURE"}))>0	//Verifica se o campo ja existe no array
		aItm[nx,nPosCpo,2]:=cNatur								//Altera informacao
	Else
		aAdd(aItm[nx],{"C7_XNATURE",cNatur,Nil})				//Inclui o campo
	Endif       

	If(nPosCpo:=aScan(aItm[nx],{|x|x[1]=="C7_XCOMPMD"}))>0	//Verifica se o campo ja existe no array
		aItm[nx,nPosCpo,2]:=cCompMed								//Altera informacao
	Else
		aAdd(aItm[nx],{"C7_XCOMPMD",cCompMed,Nil})				//Inclui o campo
	Endif      
	
/*	 ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	 ±± MELHORIA - OS 0295/13			±±
	 ±± TITULO: WORFLOW SGC Vs. Pedido	±±
	 ±± AUTOR: FERNANDO BARRETO			±±
	 ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±     */  
	 
	DBSELECTAREA('CNB')
	DBSETORDER(1)
	if DBSEEK(cFil+cContra)
		cGestor:=CNB->CNB_X_GPRO
	ENDIF     
	DBSELECTAREA('SAK')
	DBSETORDER(1)
	IF DBSEEK(xFilial("SAK")+cGestor)
		cID:=SAK->AK_USER
	ENDIF  
	If(nPosCpo:=aScan(aItm[nx],{|x|x[1]=="C7_X_GPRO"}))>0	//Verifica se o campo ja existe no array
		aItm[nx,nPosCpo,2]:=cID								//Altera informacao
	Else
		aAdd(aItm[nx],{"C7_X_GPRO",cID,Nil})				//Inclui o campo      		
	Endif                                                                         
/*	 ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	 ±± FIM MELHORIA - OS 0295/13		±±
	 ±± TITULO: WORFLOW SGC Vs. Pedido	±±
	 ±± AUTOR: FERNANDO BARRETO			±±
	 ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±     */  
	
Next


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza o saldo estimado do contrato                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RecLock("CN9",.F.)
	CN9->CN9_XSDEST -= CND->CND_VLTOT
MsUnlock()


Return {aCab,aItm}