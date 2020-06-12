#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#include "ap5mail.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFIPCOA10  บAutor  ณTOTVS               บ Data ณ  10/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para executar a finalizacao da Digitacao			  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico FIESP(GAPID048)                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FIPCOA10
Local lRet		:= .T.
Local lAchou	:= .F.
Local aVet		:= {}
Local nPosRespCC:= 0
Local _aArea	:= GetArea()
Local _aAreaCTT	:= CTT->(GetArea())
Local aPergs	:= {}
Local nTamCC	:= Space(TamSx3("CTT_CUSTO")[1])
Local _aRet 	:= {}
Local CTG    	:= '' 
Private _aCTT   := {}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณExecuta validacao para prosseguir finalizacao da Digitacaoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica se Acols dos itens AK2 nao esta em modo de edicaoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Eval(oWrite:bWhen)
	MsgStop("Existe itens que nใo foram gravados, grave os itens para Finaliza็ใo da Digita็ใo","Atencao")
	lRet:= .F.
Else
	aAdd(aPergs,{1,"CC De : ",nTamCC,"@!","","CTT","",nTamCC,.F.})
	aAdd(aPergs,{1,"CC At้: ",Replicate("Z",TamSx3("CTT_CUSTO")[1]),"@!","","CTT","",nTamCC,.T.})
	
	If  ParamBox(aPergs,"Selecione a CC para finaliza็ใo",@_aRet)		
		/*
		lRet:= .F.		
	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณPosiciona na CTT para verificar se usuario e resp. de C.Custo   ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		CTT->(DBCloseArea())
		dbSelectArea('CTT')
		CTT->(dbSetOrder(1))
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณCarrega o Vetor do LISTBOX  ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		CTT->(dbEval({|| AADD(aVet, {CTT->(CTT_CUSTO),;
		CTT->(CTT_DESC01),;
		CTT->(CTT_XUSER)})},, {|| !EOF() }))
		CTT->(dbCloseArea())
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณValida se existe registros como responsavel de um CTT |
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		nPosRespCC:= aScan(aVet,{|x| AllTrim(x[3])==__CUSERID})
		
		If nPosRespCC == 0 .and. __CUSERID <> "000000"
			MsgStop("Somente o usuario responsavel por Centro de Custo poderแ executar a rotina para Finalizar Digita็ใo!","Atencao")
			lRet:= .F.
			Return
		Endif     
		*/
		
		IF SELECT("TRB1")>0
			DbSelectArea("TRB1")
			DbCloseArea()
		EndIf                
		
		CTG  := " Select CTT_CUSTO  "
		CTG  += " FROM " + RetSqlName("CTT")
		CTG  += "   Where CTT_XUSER   = '" + __CUSERID  +"' "
		CTG  += "   and   CTT_CUSTO >= '" + _aRet[1]   +"' "
		CTG  += "   and   CTT_CUSTO <= '" + _aRet[2]   +"' "
		CTG  += "   and   D_E_L_E_T_ = ' '     "
		DBUseArea(.T.,"TOPCONN",TCGENQRY(,,CTG),"TRB1",.F.)          
		
		If Empty(TRB1->CTT_CUSTO)
			MsgAlert("Conforme Faixa de Centro de Custo mencionada, foi identificado que o seu Usuแrio nใo ้ o resposแvel por nenhum dos Centros de Custos. A rotina para Finalizar Digita็ใo, nใo poderแ ser executada!","Atencao")
			lRet:= .F.
			Return    
		Else
		    	DbGoTop("TRB1")
				While !TRB1->(Eof())				   	  
			        aAdd(_aCTT,{TRB1->CTT_CUSTO})				    
					TRB1->(DBSkip())
				EndDO   	
				TRB1->(Dbclosearea())		  	
		Endif
		 
	Endif    
	
		
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณExecuta Gravacao para finalizar item da Planilhaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If lRet
		Processa({|| GrvFlzDig(_aRet) },"Aguarde","Processando itens...")
	Endif
	
Endif

RestArea(_aAreaCTT)
RestArea(_aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGrvFlzDig บAutor  ณTOTVS               บ Data ณ  15/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGrava campo AK2_XSTS=1 (Finalizado) conforme acesso 		  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico FIESP(GAP   )                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GrvFlzDig(_aRet)
//Local lAcessOk		:= .F.
Local lVisualiza	:= .T.
Local _aArea		:= GetArea()
Local _aAreaAK2		:= AK2->(GetArea())
Local _aAreaCTT		:= CTT->(GetArea())
Local aUOFim		:= {}
Local cDescCC		:= ""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica se usuario possui acesso ao C.Custo e finaliza item    ณ
//ณconforme os parametros informado de Centro de Custo			   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea('AK2')
AK2->(dbSetOrder(1))
AK2->(dbSeek(xFilial('AK2')+AK1->(AK1_CODIGO+AK1_VERSAO)))

Begin Transaction

While !Eof() .and. AK2->(AK2_FILIAL+AK2_ORCAME+AK2_VERSAO) = AK1->(AK1_FILIAL+AK1_CODIGO+AK1_VERSAO)
	
  	If  aScan(_aCTT,{|x| AllTrim(x[1])==AllTrim(AK2->(AK2_CC))}) > 0 
		
		RecLock("AK2", .F.)
		AK2->AK2_XSTS := '1'
		AK2->(MsUnLock())
		
		nPos := Ascan(aUOFim,{|x| AllTrim(x[1])==AllTrim(AK2->(AK2_CC))})
		
		If nPos == 0
			cDescCC:= Posicione('CTT',1,xFilial('CTT')+AK2->AK2_CC,'CTT_DESC01')
			AADD(aUOFim,{AK2->AK2_CC,cDescCC})
		Endif
		
	Endif
	AK2->(dbSkip())
Enddo

End Transaction

If !Empty(aUOFim)
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณEnviar email para o responsavel da planilha com a finalizacao do C.Custo    ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	EmailRPlan(aUOFim)
	
	MsgAlert("CC(s) Finalizada(s) com sucesso !", "Processamento concluํdo")
Endif

// Somente para visualiza็ใo completa
IF MV_PAR01 == "1"
	For i := 1 to Len(oGD[1]:aCols)
		_cCC  := GDFieldGet("AK2_CC",i,,oGD[1]:aHeader,oGD[1]:aCols)
		_cID  := GDFieldGet("AK2_ID",i,,oGD[1]:aHeader,oGD[1]:aCols)
		_cOpc := Posicione("AK2",8,XFilial("AK2")+AK1->(AK1_CODIGO+AK1_VERSAO)+_cCC+_cID,"AK2_XSTS")
		GDFieldPut("AK2_XSTS",_cOpc,i,oGD[1]:aHeader,oGD[1]:aCols)
	Next
ENDIF

RestArea(_aAreaAK2)
RestArea(_aAreaCTT)
RestArea(_aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออออหออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFIVldAK2_CC_CV_IC บTOTVS               บ Data ณ  15/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออสออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFuncao para validar acesso do usuario conforme registro AK2 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico FIESP(GAP   )                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FIVldAK2_CC_CV_IC(lVisualiza)
Local lRet    := .T.
Local cCtaOrc := AK2->AK2_CO
Local cCCusto := AK2->AK2_CC
Local cItCtb  := AK2->AK2_ITCTB
Local cClVlr  := AK2->AK2_CLVLR
Local cRevisa := AK1->AK1_VERSAO
Local lMore

If !Empty(cCtaOrc)
	dbSelectArea("AK3")
	dbSetOrder(1)
	If MsSeek(xFilial()+AK1->AK1_CODIGO+cRevisa+cCtaOrc)
		lMore := .T.
		While lMore
			// verifica centro de custo
			lRet := !Empty(cCCusto)
			If lRet
				lRet := PcoCC_User(AK1->AK1_CODIGO,AK3->AK3_CO,AK3->AK3_PAI,2,"CCUSTO",cRevisa,cCCusto,If(lVisualiza, 1, 2) )
				If ! lRet
					Exit
				EndIf
			EndIf
			//verifica item contabil
			lRet := !Empty(cItCtb)
			If lRet
				lRet := PcoIC_User(AK1->AK1_CODIGO,AK3->AK3_CO,AK3->AK3_PAI,2,"ITMCTB",cRevisa,cItCtb,If(lVisualiza, 1, 2) )
				If ! lRet
					Exit
				EndIf
			EndIf
			//verifica classe de valor
			lRet := !Empty(cClVlr)
			If lRet
				lRet := PcoCV_User(AK1->AK1_CODIGO,AK3->AK3_CO,AK3->AK3_PAI,2,"CLAVLR",cRevisa,cClVlr,If(lVisualiza, 1, 2) )
				If 	! lRet
					Exit
				EndIf
			EndIf
			//Se nao sair em nenhum if encerra o laco e retorna .T.
			lRet  := .T.
			lMore := .F.
		End
	EndIf
EndIf

Return(lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออหออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEmailRespPlan   บTOTVS                 บ Data ณ  22/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออออออออสออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEnvia email para o responsavel da planilha referente ao  	  บฑฑ
ฑฑบ          ณao fechamento de um C.Custo (CC)							  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico FIESP(GAP   )                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function EmailRPlan(aUOFim)
Local cEmailRPlan:= ""

cEmailRPlan:=UsrRetMail(AK1->(AK1_XRESPP))

if !VldMail(cEmailRPlan)
	MsgStop("E-Mail do responsavel pela planilha invแlido " + ALLTRIM(cEmailRPlan),"Aten็ใo")
Else
	SendMail(cEmailRPlan,aUOFim)
endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVldMail   บAutor  ณTOTVS               บ Data ณ  23/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida o E-mail do responsavel pela planilha				  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico FIESP(GAP   )                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VldMail(cEMail)
Local nI
Local cChar      := ""
Local lOK 		 := .F.
Local nQtdArrba  := 0
Local aPto       := {}
Local cConteudo  := AllTrim(LOWER(cEMail))
Local nP1Arrba   := At('@',cConteudo)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCarrega Vetor com caracteres especiais nao permitidos ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aNoChar    := {",","\","/","*","+","=","(",")","[","]",;
"{","}",";",":","?","!","&","%","#","$","%","จ",;
"'",'"',"|","<",">","~","^"}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCarrega Vetor aChar com as LETRAS ALFABETO exigida 	 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aChar    := {"a","b","c","d","e","f","g","h","i","j","k","l","m",;
"n","o","p","q","r","s","t","u","v","w","x","y","z",;
"0",'1',"2","3","4","5","6","7","8","9"}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica se o campo esta em branco ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Empty(cConteudo)
	Return .F.
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณValida se a String eh menor do que 7  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Len(cConteudo) < 7
	Return .F.
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica se possui caracter especial preenchido ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For nI:=1 to Len(AllTrim(cConteudo))
	cChar := SubStr(cConteudo,nI,1)
	If aScan(aNoChar, cChar) > 0
		Return .F.
	Endif
Next nI

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica a QTD de pontos e arrobas na string ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For nI:=1 to Len(cConteudo)
	// Soma a QTD de Pontos
	If SubStr(cConteudo,nI,1) == '.'
		AADD(aPto, nI)
		Loop
	Endif
	
	// Valida a QTD de @
	If SubStr(cConteudo,nI,1) == '@'
		If nQtdArrba == 0
			nQtdArrba++
			Loop
		Else
			Return .F.
		Endif
	Endif
Next nI

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณValida a posicao do ARROBA na STRING  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For nI:=1 to Len(SubStr(cConteudo,1,nP1Arrba))
	cChar := SubStr(cConteudo,nI,1)
	If aScan(aChar, cChar) > 0
		lOK := .T.
		Exit
	Endif
Next nI
If !lOK
	Return .F.
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณValida a posicao dos pontos na STRING ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For nI:=1 to Len(aPto)
	If aPto[nI] <= 1
		Loop
	Endif
	
	cChar := SubStr(cConteudo,aPto[nI]-1,1)
	If aScan(aChar, cChar) == 0
		lOK := .F.
		Exit
	Endif
Next nI
If SubStr(cConteudo,Len(cConteudo),1) == '.'
	lOk := .F.
Endif

If !lOK
	Return .F.
Endif

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSendmail  บAutor  ณTOTVS               บ Data ณ  23/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Envia o e-mail para o responsavel pela planilha			  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico FIESP(GAP   )                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Sendmail(cEmail,aUOFim)

Local cMensagem		:= ""
Local lOk			:= .F.
Local lSendOk		:= .T.
Local cError		:= ""
Local cPassword 	:= AllTrim(GetNewPar("MV_RELPSW"," "))
Local lAutentica	:= GetMv("MV_RELAUTH",,.F.)         //Determina se o Servidor de Email necessita de Autentica็ใo
Local cAccount  	:= AllTrim(GetNewPar("MV_RELACNT"," ")) //Space(50)
Local cUserAut  	:= Alltrim(GetNewPar("MV_RELAUSR",cAccount))//Usuario para Autentica็ใo no Servidor de Email
Local cPassAut  	:= Alltrim(GetNewPar("MV_RELAPSW",cPassword))//Senha para Autentica็ใo no Servidor de Email
Local cServer   	:= AllTrim(GetNewPar("MV_RELSERV",""))
Local nTimeOut  	:= GetNewPar("MV_RELTIME",120)
Local cMailConta	:= ""
Local cSubject  	:= ""
Local cMailTo 		:= ""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณGera HTML com todos os itens da planilha foram finalizadoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cMensagem:= Geramail(aUOFim)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณEnvia Email ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤู
If !Empty(cServer) .And. !Empty(cAccount) .And. (!Empty(cPassword) .OR. !Empty(cPassAut))
	
	// Conecta uma vez com o servidor de e-mails
	CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword TIMEOUT nTimeOut Result lOk
	
	If !lOK
		//Erro na conexao com o SMTP Server
		GET MAIL ERROR cError
		MsgStop("Nใo foi possํvel efetuar a conexใo com o servidor de e-mail !" + cError,"Aten็ใo")
	Else		//Envio de e-mail HTML
		cSubject	:="CC Finalizada: "+AllTrim(AK1->AK1_CODIGO) +'/'+ AK1->AK1_VERSAO
		cMailConta	:= UsrRetMail(__CUSERID)
		
		If lAutentica
			If !MailAuth(cAccount,cPassword)
				GET MAIL ERROR cError
				MsgStop("Erro de autentica็ใo no servidor SMTP:" + cError,"Aten็ใo")
			Endif
		Endif
		
		SEND MAIL FROM cMailConta to cEMail SUBJECT cSubject BODY cMensagem RESULT lSendOk
		
		If !lSendOk
			//Erro no Envio do e-mail
			GET MAIL ERROR cError
			MsgStop("Erro ao enviar e-mail para Responsแavel da Planilha!" + cError,"Aten็ใo")
		EndIf
	EndIf
EndIf

// Desconecta com o servidor de e-mails
If lOk
	DISCONNECT SMTP SERVER
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGeramail  บAutor  ณTOTVS               บ Data ณ  23/01/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera o e-mail para o responsavel pela planilha avisando	  บฑฑ
ฑฑบ          ณ finalizacao da digitacao de um C.Custo (CC)                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico FIESP(GAP   )                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Geramail(aUOFim)

Local nI
Local cMsg      := ""

// Texto
cMsg := "<HTML><TABLE BORDER=0>"+CRLF
cMsg += "<TR><TD>A(s) CC(s) abaixo finalizou(aram) seu or็amento "
cMsg += "<TR><TD>&nbsp</TD></TR>" + CRLF
cMsg += "</TABLE>"+CRLF

//Cabecalho
cMsg += '<table id="" style="border-collapse: collapse" cellSpacing="1" borderColorDark="#000000" width="450" borderColorLight="#000000" border="1">'
cMsg += '    <tr><th colspan="8"><font face="Verdana" size="2"><b>Planilha: ' + AK1->AK1_CODIGO + ' - Revisใo: ' + AK1->AK1_VERSAO + ' </b></font></th></tr>'
cMsg += '      <td bgcolor="#99ccff" align="Left" ><font face="Verdana" size="1"><b>CC</b></font></td>'
cMsg += '      <td bgcolor="#99ccff" align="Left" ><font face="Verdana" size="1"><b>Descri็ใo</b></font></td>'

//Adiciona Itens na tabela
For nI := 1 to Len(aUOFim)
	cMsg += '<tr>'
	cMsg += '<td align=left><font face="Arial" size="2">' + aUOFim[nI,01] + '</td>'
	cMsg += '<td align=left><font face="Arial" size="2">' + aUOFim[nI,02] + '</td>'
	cMsg += '</tr>'
Next nI

cMsg += "</TABLE/HTML>"

Return(cMsg)
