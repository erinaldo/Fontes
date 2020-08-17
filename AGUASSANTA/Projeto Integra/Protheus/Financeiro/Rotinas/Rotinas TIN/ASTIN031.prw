#INCLUDE "PROTHEUS.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} ASTIN031
Gera um titulo a receber parcial a partir de um titulo selecionado
Parcialização
@return	Nenhum			
@author	Carlos Gorgulho
@since		20/02/2017
@version	12.1.7
/*/
//-------------------------------------------------------------------
User Function ASTIN031() //F0103001()

Local cQuery		:= ""
Local cAliasSE1		:= ""
Local lRet			:= .T.
Local nValParcial	:= 0
Local lMsHelpAuto	:= .T.
Local _aTitParc		:= {}			
Local _aBaixaOri	:= {}
Local cNumTit		:= ""
Local dVenci		:= ctod("  /  /  ")
Local dData			:= ctod("  /  /  ")
Local nTamPref		:= TamSx3("E1_PREFIXO")[1]
Local nTamNum		:= TamSx3("E1_NUM")[1]
Local nTamParc		:= TamSx3("E1_PARCELA")[1]
Local cPrefOri		:= SE1->E1_PREFIXO
Local cNumOri		:= SE1->E1_NUM
Local cParcOri		:= SE1->E1_PARCELA
Local cTipoOri		:= SE1->E1_TIPO                           
Local cCliOri		:= SE1->E1_CLIENTE
Local cLojaOri		:= SE1->E1_LOJA
Local cPrefixo		:= SE1->E1_PREFIXO
Local cNum			:= ''

Private lMsErroAuto := .F.


If	SE1->E1_SALDO <= 0
	MsgAlert("Titulo já baixado. Não possui saldo para geração de título parcial a receber.")
	lRet := .F.
EndIf	

If	!Empty(SE1->E1_XVINCP)
	MsgAlert("Titulo parcial, operação inválida")
	lRet := .F.
EndIf

	//Chama função para atualizar os dados do titulo no TIN(RM)
/*	If 	 !u_ASTIN011() //!u_F0101001()
		lRet := .F.
	EndIf
*/

//Verifica se possui algum titulo parcial em aberto
If lRet	
	cQuery := "SELECT * FROM "
	cQuery += RetSqlName("SE1") + " SE1 "
	cQuery += " WHERE "                                    
	cQuery += "E1_FILIAL  ='" + XFilial("SE1")+ "' AND "
	cQuery += "E1_XVINCP  ='" +SE1->E1_NUM +"' AND "
	cQuery += "E1_PREFIXO ='" +SE1->E1_PREFIXO  +"' AND "
	cQuery += "E1_TIPO    ='" +SE1->E1_TIPO +"' AND "
	cQuery += "E1_CLIENTE ='" +SE1->E1_CLIENTE +"' AND "
	cQuery += "E1_LOJA    ='" +SE1->E1_LOJA +"' AND "
	cQuery += "E1_SALDO > 0 AND "
	cQuery += "SE1.D_E_L_E_T_ = ' ' "
	
	cQuery := ChangeQuery(cQuery)
	cAliasSE1 	:= GetNextAlias()
	DBUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cAliasSE1,.F.,.T.)
	
	If (cAliasSE1)->(!EOF())  
		MsgAlert("O titulo selecionado possui titulos parciais em aberto. Verifique!")
		lRet := .F.
	EndIf 
		
	(cAliasSE1)->(DbCloseArea())								
EndIf

If lRet	
	//Abre a tela para digita o valor do titulo parcial
	lRet := TelaValor(@nValParcial, @dVenci)
EndIF
	

If	lRet

	dData 	  := ddatabase
	ddatabase := dVenci
	//Chama função para atualizar os dados do titulo no TIN(RM)
	If 	!u_ASTIN011() //!u_F0101001()
		lRet := .F.
	EndIf
	ddatabase := dData

	If	lRet
		//Gera o titulo parcial conforme o valor informado
		lMsErroAuto := .F.
		lMsHelpAuto := .T.
		
		BEGIN TRANSACTION
			_aTitParc	:= {}			
			cNumTit		:= ProxTitulo("SE1",cPrefixo)
			cNum		:= PadR(cNumTit,nTamNum)
			
			AADD(_aTitParc , {"E1_NUM"    	,cNum							,NIL})
			AADD(_aTitParc , {"E1_PREFIXO"	,SE1->E1_PREFIXO				,NIL})
			AADD(_aTitParc , {"E1_PARCELA"	,Space(nTamParc)				,NIL})
			AADD(_aTitParc , {"E1_TIPO"   	,SE1->E1_TIPO					,NIL})
			AADD(_aTitParc , {"E1_NATUREZ"	,SE1->E1_NATUREZ				,NIL})
			AADD(_aTitParc , {"E1_CLIENTE"	,SE1->E1_CLIENTE				,NIL})
			AADD(_aTitParc , {"E1_LOJA"   	,SE1->E1_LOJA					,NIL})
			AADD(_aTitParc , {"E1_PARCELA" 	,SE1->E1_PARCELA				,NIL})
			AADD(_aTitParc , {"E1_EMISSAO"	,dDatabase						,NIL})
			AADD(_aTitParc , {"E1_VENCTO" 	,dVenci							,NIL})
			AADD(_aTitParc , {"E1_VENCREA"	,dVenci							,NIL})	
			AADD(_aTitParc , {"E1_EMIS1"  	,dDatabase						,NIL})
			AADD(_aTitParc , {"E1_MOEDA" 	,1								,NIL})               
			AADD(_aTitParc , {"E1_VALOR" 	,nValParcial 					,NIL})			
			AADD(_aTitParc , {"E1_HIST"		,"Parc Ref Tit: "+SE1->E1_NUM	,Nil})
			AADD(_aTitParc , {"E1_XVINCP"	,SE1->E1_NUM					,NIL})
		
			//Chamada da rotina automatica
			MSExecAuto({|x,y| FINA040(x,y)},_aTitParc,3) //Inclusao do Titulo
					
			If 	lMsErroAuto .Or. ( SE1->E1_NUM <> cNum )
				lRet := .F.
				AutoGrLog( "Problema na Inclusão do Titulo.." )
				MostraErro()
	           	DisarmTransaction()
				Break 
			Endif											
	
			//Baixa parcial o titulo origem conforme titulo parcial gerado	    		    
			If 	lRet
	
		   		_aBaixaOri := {}
	       		Aadd(_aBaixaOri, {"E1_PREFIXO" , cPrefOri 	, nil})
	       		Aadd(_aBaixaOri, {"E1_NUM"     , cNumOri	, nil})
	       		Aadd(_aBaixaOri, {"E1_PARCELA" , cParcOri 	, nil})
	       		Aadd(_aBaixaOri, {"E1_TIPO"    , cTipoOri 	, nil})                           
	       		Aadd(_aBaixaOri, {"E1_CLIENTE" , cCliOri 	, nil})
	       		Aadd(_aBaixaOri, {"E1_LOJA"    , cLojaOri 	, nil})
	       		Aadd(_aBaixaOri, {"AUTVALREC"  , nValParcial, nil})
	       		Aadd(_aBaixaOri, {"AUTMOTBX"   , "REN"      , nil})
	       		Aadd(_aBaixaOri, {"AUTDTBAIXA" , dVenci  	, nil})
	       		Aadd(_aBaixaOri, {"AUTDTCREDITO",dVenci		, nil})
	       		Aadd(_aBaixaOri, {"AUTHIST"    , "B Parc/Tit Parc "+SE1->E1_NUM , nil})                   
	
	       		lMsErroAuto := .F.
	       		lMsHelpAuto := .T.
	       
	       		If	valType(ALTERA) <> "U"
		   			ALTERA := .T.
		   		EndIf
	       
	       		MSExecAuto({|a,b| FINA070(a,b)},_aBaixaOri,3) //3 - Baixa de Título
	       		dbSelectArea("SE5")
	       		
	       		If 	lMsErroAuto .Or. (SE5->E5_NUMERO <> cNumOri)
					lRet := .F.
					AutoGrLog( 'Problema na baixa do título de origem.')
					MostraErro()
	           		DisarmTransaction()
					Break 
	       		EndIf
	    	EndIf
	            	
			//Marca o titulo origem como parcializado
			If	lRet
	
				SE1->(DbSetOrder(1))
				If	SE1->(DbSeek(FWxFilial("SE1")+PadR(cPrefOri,nTamPref)+PadR(cNumOri,nTamNum)+PadR(cParcOri,nTamParc)))
					Reclock("SE1")
					SE1->E1_XPARCL := "1"
					SE1->(MsUnlock())
				EndIf
	
				SE1->(DbSetOrder(1))
				If 	SE1->(DbSeek(FWxFilial("SE1")+PadR(cPrefOri,nTamPref)+PadR(cNum,nTamNum)+PadR(cParcOri,nTamParc)))
					Reclock("SE1")
					SE1->E1_XSEQ   := SE5->E5_SEQ
					SE1->(MsUnlock())
				EndIf	
		
			EndIf	
	
		END TRANSACTION		
	EndIf		
EndIf

If lRet
	MsgAlert("Título Nr: "+cNumTit+" parcial gerado com sucesso!")
	
	//Geração do Bordero
	FINA060(3)

EndIf

Return Nil

//Monta tela para o usuario digitar o valor para geração do titulo parcial
Static Function TelaValor(nValParcial, dVenci)

Local oMainPanel	:= Nil
Local oDlg			:= Nil
Local lRet			:= .F.

Local bOk     	:= {|| If(FSValida(nValParcial, dVenci ), (lRet := .T.,oDlg:End()),)}  
Local bCancel 	:= {||oDlg:End()}  

DEFINE MSDIALOG oDlg TITLE "Digite o valor do titulo parcial" FROM 0,0 TO 200,332  PIXEL 

	@ 41 ,020 Say "Valor do Titulo Parcial:" PIXEL of oDLG 
	@ 40 ,100 MSGET nValParcial SIZE 55,10  PIXEL of oMainPanel Picture "@E 9,999,999,999,999.99"

	@ 61 ,020 Say "Data Vencimento do Titulo:" PIXEL of oDLG 
	@ 60 ,100 MSGET dVenci SIZE 45,10  PIXEL of oMainPanel Picture "@D"
	
	@ 81 ,020 Say "Saldo do Titulo R$:" PIXEL of oDLG 
	@ 80 ,100 Say Alltrim(TRANSFORM(SE1->E1_SALDO, '@E 999,999.99')) PIXEL of oDLG 
	

ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,bOk,bCancel)

Return (lRet)


Static Function FSValida(nValParcial, dVenci  )
Local lRet	:= .T.

	If 	nValParcial <= 0
		MsgAlert("É permitido somente valor maior que 0(zero).")
		lRet := .F.
	EndIf

	If	lRet
		If 	nValParcial > SE1->E1_SALDO
			MsgAlert("Valor informado é maior que o saldo atual do título a receber.")
			lRet := .F.
		EndIf	
	EndIf	
		
	If	lRet
		If	Empty(dVenci)
			MsgAlert("Data de Vencimento deve ser informada.")
			lRet := .F.
		EndIf
	EndIf
		
	If	lRet
		If	dVenci < Ddatabase 
			MsgAlert("Data de Vencimento invalida.")
			lRet := .F.
		EndIf	
	EndIf

Return(lRet)

