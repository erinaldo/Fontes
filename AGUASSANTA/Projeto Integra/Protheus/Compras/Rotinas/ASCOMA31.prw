#INCLUDE 'Rwmake.ch'
#INCLUDE 'AP5Mail.ch'
#INCLUDE "Protheus.Ch"

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASCOMA31()

Adiciona o botao no browse da rotina "Atualiza cotacao" Enviar e-mail
Chamado pelo PE MT150ROT

@param		Nenhum
@return		aRotina (Rotinas adicionadas)	
@author 	Fabiano Albuquerque
@since 		23/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------

USER FUNCTION ASCOMA31()
	aAdd(aRotina,{"Enviar e-mail","U_MT150EM", 0 , 4})
Return aRotina

User Function MT150EM()
	U_ListBoxMar(SC8->C8_NUM) 
Return .T.


//-----------------------------------------------------------------------
/*/{Protheus.doc} ListBoxMar()

Abre uma janela com os fornecedores da cotacao posicionada na 
rotina "Atualiza cotacao" e permite selecionar os fornecedores
para envio da cotação

@param		cCotacao
@return		Nenhum
@author 	Fabiano Albuquerque
@since 		23/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------

User Function ListBoxMar(cCotacao)

Local cVar      := Nil
Local oDlg      := Nil
Local cTitulo   := "Selecionar Fornecedores para envio"
Local lMark     := .F.
Local oOk       := LoadBitmap( GetResources(), "CHECKED" )   //CHECKED    //LBOK  //LBTIK
Local oNo       := LoadBitmap( GetResources(), "UNCHECKED" ) //UNCHECKED  //LBNO
Local oChk      := Nil
Local aAreaSC8	:= GetArea("SC8")
Local _cFornece := ""
Local _cLoja    := ""
Local i         := 1

Private lChk     := .F.
Private oLbx := Nil
Private aVetor := {}               
Private cLink := AllTrim(GetMV( "MV_XLKEXT",,"http://geek:10050/web/messenger/emp" ))+cEmpAnt


dbSelectArea("SC8")
dbSetOrder(1) //C8_FILIAL+C8_NUM+C8_FORNECE+C8_LOJA+C8_ITEM+C8_NUMPRO+C8_ITEMGRD 
dbSeek(xFilial("SC8") + cCotacao)

//+-------------------------------------+
//| Carrega o vetor conforme a condicao |
//+-------------------------------------+

While !Eof() .And. C8_FILIAL == xFilial("SC8") .AND. C8_NUM == cCotacao	
	If SC8->C8_FORNECE + SC8->C8_LOJA <> _cFornece + _cLoja
   		aAdd( aVetor, { lMark, 	C8_NUM, ;
   								C8_FORNECE, ;
   								C8_LOJA, ;
   								Posicione("SA2",1,xFilial("SA2")+SC8->(C8_FORNECE+C8_LOJA),"A2_NOME"),;
   								Posicione("SA2",1,xFilial("SA2")+SC8->(C8_FORNECE+C8_LOJA),"A2_EMAIL") })
		_cFornece := SC8->C8_FORNECE
		_cLoja    := SC8->C8_LOJA
		   		
   	Endif	
	dbSkip()
End

//+-----------------------------------------------+
//| Monta a tela para usuario visualizar consulta |
//+-----------------------------------------------+
If Len( aVetor ) == 0
   Aviso( cTitulo, "Nao existe Fornecedores a consultar", {"Ok"} )
   Return
Endif

DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 240,500 PIXEL
   
@ 10,10 LISTBOX oLbx VAR cVar FIELDS HEADER ;
   " ", "Numero","Fornecedor", "Loja", "Nome Fornecedor", "E-mail Fornecedor" ;
   SIZE 230,095 OF oDlg PIXEL ON dblClick(aVetor[oLbx:nAt,1] := !aVetor[oLbx:nAt,1],oLbx:Refresh())

oLbx:SetArray( aVetor )
oLbx:bLine := {|| {Iif(aVetor[oLbx:nAt,1],oOk,oNo),;
                       aVetor[oLbx:nAt,2],;
                       aVetor[oLbx:nAt,3],;
                       aVetor[oLbx:nAt,4],;
                       aVetor[oLbx:nAt,5],;
                       aVetor[oLbx:nAt,6]}}
	 
@ 110,10 CHECKBOX oChk VAR lChk PROMPT "Marca/Desmarca" SIZE 60,007 PIXEL OF oDlg ;
         ON CLICK(aEval(aVetor,{|x| x[1]:=lChk}),oLbx:Refresh())

DEFINE SBUTTON FROM 107,213 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg CENTER

// Enviar e-mail para os elementos do aVetor que estejam TRUE //

If Len(aVetor) <> 0
	For i = 1 to Len(aVetor)
        If aVetor[i][1] == .T.
			IF EMPTY(aVetor[i][6])
				cTitle  := "Administrador do Workflow : NOTIFICACAO" 
				aMsg	:= {}
				AADD(aMsg, Dtoc(MSDate()) + " - " + Time() )
				AADD(aMsg, "Cotação No: " + aVetor[i][2] + " Filial : " + cFilAnt + " Fornecedor : " + aVetor[i][5] + " (" + aVetor[i][3] +"-" + aVetor[i][4] + ")")
			ELSE
				U_EnviaCT(aVetor[i][2],aVetor[i][3],aVetor[i][4]) // elementos do array: 	C8_NUM, C8_FORNECE, C8_LOJA
			ENDIF
		Endif	
	Next i
Endif


//-----------------------------------------------------------------------
/*/{Protheus.doc} EnviaCT()

Rotina de envio de e-mail com a cotacao para os fornecedores da rotina 
"Atualiza cotacao"

@param		_cNum, _cFornece, _cLoja
@return		Nenhum
@author 	Fabiano Albuquerque
@since 		23/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------

User Function EnviaCT(_cNum, _cFornece, _cLoja)
	Local    _cUser
	Private _aCond := {} 
	Private _aFrete:= {} 

	DBSelectArea("SC8")
	DBSetOrder(1)
	DBSeek(xFilial("SC8")+_cNum + _cFornece + _cLoja)
	_cUser := SC8->C8_XUSER

   	DbSelectArea("SA2")
   	DbSetOrder(1)
   	DbSeek(xFilial("SA2") + _cFornece + _cLoja)

	// CONDIÇÃO DE PAGAMENTO
	dbSelectArea("SE4")
	dbSetOrder(1)
	dbGoTop()
	
	while !SE4->(Eof()) .and. xFilial("SE4") == SE4->E4_FILIAL
		IF SE4->E4_MSBLQL == "2"
			aAdd( _aCond, SE4->E4_CODIGO + " - " + SE4->E4_DESCRI )
		ENDIF
			SE4->(dbSkip())
	enddo

	aAdd( _aFrete, "C=CIF" )
	aAdd( _aFrete, "F=FOB" )
	aAdd( _aFrete, "T=Terceiros" )
	aAdd( _aFrete, "S=Sem frete" )

	oProcess:= TWFProcess():New( "000001", "Cotacao Eletronica" )
	oProcess:NewTask( "Cotacao de Precos", "\WORKFLOW\HTML\CTFORN.HTM" )
	oProcess:bReturn  		:= "U_RecCT()"
	oProcess:nEncodeMime 	:= 0
	oProcess:cSubject 		:= "Cotação Eletrônica de Precos No." + _cNum
	oProcess:cTo      		:= _cUser
	oProcess:NewVersion(.T.)            
	
 	oHtml:= oProcess:oHTML

	oHtml:ValByName( "C8_NUM"		, _cNum 			)
	oHtml:ValByName( "A2_NREDUZ"	, SA2->A2_NOME 		)
	oHtml:ValByName( "A2_COD"		, SA2->A2_COD 		)
	oHtml:ValByName( "A2_LOJA"		, SA2->A2_LOJA 		)
	oHtml:ValByName( "A2_END"		, SA2->A2_END 		)
	oHtml:ValByName( "A2_BAIRRO"	, SA2->A2_BAIRRO 	)
	oHtml:ValByName( "A2_MUN"		, SA2->A2_MUN 		)
	oHtml:ValByName( "A2_EST"		, SA2->A2_EST 		)
	oHtml:ValByName( "A2_TEL"		, SA2->A2_TEL 		)	
	oHtml:ValByName( "A2_FAX"		, SA2->A2_FAX 		)	  
	oHtml:ValByName( "E4_COND"   	, _aCond      		)
	oHtml:ValByName( "C8_VALIDA"   	, SC8->C8_VALIDA	)
	oHtml:ValByName( "TPFRETE" 		, _aFrete     		)
	oHtml:ValByName( "CONTATO"   	, SC8->C8_CONTATO   )
	oHtml:ValByName( "FRETE"   		, ""   				)
	
	oHtml:ValByName( "Y1_NOME"   	, SY1->Y1_NOME  	)
	
	// ALIMENTA A TELA DE ITENS DA COTACAO

	While !SC8->(EOF()) .AND. SC8->(C8_FILIAL +  C8_NUM + C8_FORNECE + C8_LOJA) == xFilial("SC8") + _cNum + _cFornece + _cLoja   

		DBSELECTAREA("SB1")
		DBSetOrder(1)
		DBSeek(xFilial()+SC8->C8_PRODUTO)

		DBSELECTAREA("SBM")
		DBSetOrder(1)
		DBSeek(xFilial()+SB1->B1_GRUPO)      

		DBSELECTAREA("SB5")
		dbSetOrder(1)
		If SB5->(dbSeek( xFilial("SB5") + SC8->C8_PRODUTO ))
			_cDescPro := SB5->B5_CEME   
		Else                                                        
			If Empty(SB1->B1_DESC)
				_cDescPro := SB1->B1_DESC
			Else
				_cDescPro := SB1->B1_DESC
			EndIf
		EndIf
		
		aAdd( (oHtml:ValByName( "t.1"    )), SC8->C8_ITEM	)
		AAdd( (oHtml:ValByName( "t.2"    )), SC8->C8_PRODUTO)
		AAdd( (oHtml:ValByName( "t.3"    )), _cDescPro		) 
		AAdd( (oHtml:ValByName( "t.4"    )), SC8->C8_OBS	)
		AAdd( (oHtml:ValByName( "t.5"    )), SC8->C8_UM		)
		AAdd( (oHtml:ValByName( "t.6"    )), TRANSFORM(SC8->C8_QUANT,'@E 9,999,999.99'))
		AAdd( (oHtml:ValByName( "t.7"    )), ""				)
		AAdd( (oHtml:ValByName( "t.9"    )), ""				)
		AAdd( (oHtml:ValByName( "t.10"   )), ""				)
		AAdd( (oHtml:ValByName( "t.11"   )), TRANSFORM(SC8->C8_PRAZO,'@E 999'))
	
		SC8->(dbSkip()) 
	Enddo


	aAdd( oProcess:aParams, xFilial("SC8"))						
	aAdd( oProcess:aParams, _cNum)                     
	aAdd( oProcess:aParams, _cFornece)                     
	aAdd( oProcess:aParams, _cLoja)                     
			
//	oHtml:ValByName( "datetime"     , DTOC(MSDATE()) + " às " + left(time(),5) )
//	oHtml:ValByName( "procid"       , oProcess:fProcessID  )
	       
	oProcess:nEncodeMime := 0
	cMailId    := oProcess:Start("\workflow\emp"+cEmpAnt+"\wfct\")  // Crio o processo e gravo o ID do processo de Workflow
//	cMailId    := oProcess:Start("/web/messenger/emp"+cEmpAnt+"/wfct/")  // Crio o processo e gravo o ID do processo de Workflow
	         
	// ARRAY DE RETORNO
	_aReturn := {}
	AADD(_aReturn, oProcess:fProcessId)

	chtmlfile  := cmailid + ".htm"

	oProcess:= TWFProcess():New( "000002", "Cotacao Eletronica" )
	oProcess:NewTask( "Cotacao de Precos", "\WORKFLOW\HTML\CVFORN.HTM" )
	oProcess:cSubject 		:= "Cotação Eletrônica de Precos No." + _cNum
	oProcess:nEncodeMime 	:= 0
	oProcess:cTo      		:= SA2->A2_EMAIL
	oProcess:NewVersion(.T.)            
	
 	oHtml     				:= oProcess:oHTML
    // Preencher os campos do convite : CVFORN_SITEL.HTM //
 
 	oHtml:ValByName( "C8_NUM"		, _cNum )
	oHtml:ValByName( "A2_NOME"		, SA2->A2_NOME )
	oHtml:ValByName( "C8_FORNECE"	, SA2->A2_COD )
	oHtml:ValByName( "C8_LOJA"		, SA2->A2_LOJA )  
	oHtml:ValByName( "datetime"     , DTOC(MSDATE()) + " às " + left(time(),5) )
	oHtml:ValByName( "cMailID"		, Alltrim(GetMV("MV_WFDHTTP"))+"\workflow\emp"+cEmpAnt+"\wfct\"+chtmlfile)
//	oHtml:ValByName( "cMailID"		, cLink+"/wfct/"+chtmlfile)
    
	oProcess:Start()

	If Len(_aReturn) > 0 
		_lProcesso 	:= .T.
		DBSELECTAREA("SC8")
		DBSetOrder(1)
		DBSeek(xFilial("SC8")+_cNum + _cFornece + _cLoja)
		While !SC8->(EOF()) .AND. SC8->(C8_FILIAL +  C8_NUM + C8_FORNECE + C8_LOJA) == xFilial("SC8") + _cNum + _cFornece + _cLoja   

			Reclock("SC8",.F.)
			SC8->C8_XWF			:= IIF(EMPTY(_aReturn[1])," ","1")  	// Status 1 - envio para aprovadores / branco-nao houve envio
// 			SC8->C8_XWFID		:= _aReturn[1]							// Rastreabilidade
			MSUnlock()
			SC8->(dbSkip()) 
			 
		Enddo	
	Endif	

	Return 

//-----------------------------------------------------------------------
/*/{Protheus.doc} RecCT()

Rotina de tratamento do retorno com a cotacao para os fornecedores da 
rotina "Atualiza cotacao"

@param		oProcess
@return		Nenhum
@author 	Fabiano Albuquerque
@since 		23/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------

User function RecCT(oProcess)     
	Local _cUser := ""
	Local _nTOTCOT:= 0
	Local _nQUANT := 0
	Local _nPRECO := 0
	Local _nInd   := 1
	
	ChkFile("SC8")
	ChkFile("SE4")
		
	U_CONSOLE("2 - Processa O RETORNO DO EMAIL")

	_cNUM    	:= oProcess:aParams[2]
	_cFORNECE	:= oProcess:aParams[3]
	_cLOJA 		:= oProcess:aParams[4]
	_cEMAIL 	:= ALLTRIM(oProcess:cTo)
	_cWFID		:= oProcess:fProcessID

	U_CONSOLE("2 - Cotacao : " + _cNum + " - Forn.: " + _cFornece +  " - WFID: " + _cWFID)
	
	_cOPC	     := oProcess:oHtml:RetByName("OPC")
	_cOBS	     := oProcess:oHtml:RetByName("OBS")
	_cContato    := oProcess:oHtml:RetByName("CONTATO")
	_cCond  	 := oProcess:oHtml:RetByName("E4_COND")
	_cTpFrete  	 := Substr(oProcess:oHtml:RetByName("TPFRETE"),1,1)
	_nFrete  	 := Iif(_cTpFrete="C", U_TrataValor(oProcess:oHtml:RetByName("FRETE")) ,0 )
	_lOk 		:= .F.
	_lEncerrado	:= .F.
//	aProd		:= {}

	if valtype(oProcess:oHtml:RetByName("t.1")) <> "U"
		nQuant := LEN(oProcess:oHtml:RetByName("t.1"))
	endif
			
	// Somente para calcular o C8_FRETE
	FOR _nInd := 1 TO nQuant
		_nQUANT  :=   iif(valtype(oProcess:oHtml:RetByName("t.6" )) <>"U", U_TrataValor(oProcess:oHtml:RetByName("t.6" )[_nind]), 0)
		_nPRECO  :=   iif(valtype(oProcess:oHtml:RetByName("t.7" )) <>"U", U_TrataValor(oProcess:oHtml:RetByName("t.7" )[_nind]), 0)
		_nTOTCOT +=   _nQUANT*_nPRECO
// 		u_console("_nQUANT : "+ Str(_nQUANT))
// 		u_console("_nPRECO : "+ Str(_nPRECO))
// 		u_console("_nTOTCOT: "+ Str(_nTOTCOT))
	NEXT            
//	u_console("_nTOTCOT: "+ Str(_nTOTCOT))

	// Rateio do frete:
	// (valor total do item / valor total da cotacao) * valor total do frete       
	
	FOR _nInd := 1 TO nQuant
		_cITEM  	:=   iif(valtype(oProcess:oHtml:RetByName("t.1"))  <>"U", 		       oProcess:oHtml:RetByName("t.1" )[_nind] 		,"")
		_nQUANT 	:=   iif(valtype(oProcess:oHtml:RetByName("t.6" )) <>"U", U_TrataValor(oProcess:oHtml:RetByName("t.6" )[_nind])		, 0)
		_nPRECO 	:=   iif(valtype(oProcess:oHtml:RetByName("t.7" )) <>"U", U_TrataValor(oProcess:oHtml:RetByName("t.7" )[_nind])		, 0)
		_nDESC		:=   iif(valtype(oProcess:oHtml:RetByName("t.9" )) <>"U", U_TrataValor(oProcess:oHtml:RetByName("t.9" )[_nind])		, 0)
		_nVLDESC	:=   iif(valtype(oProcess:oHtml:RetByName("t.9" )) <>"U", 			  ((_nPRECO*_nQUANT)*_nDESC/100)				, 0)
		_nALIIPI	:=   iif(valtype(oProcess:oHtml:RetByName("t.10")) <>"U", U_TrataValor(oProcess:oHtml:RetByName("t.10")[_nind])		, 0)
		_nVALIPI	:=   iif(valtype(oProcess:oHtml:RetByName("t.10")) <>"U", 			  ((_nPRECO*_nQUANT)-_nVLDESC)*(_nALIIPI/100) 	, 0)  
		_nPRAZO 	:=   iif(valtype(oProcess:oHtml:RetByName("t.11")) <>"U", U_TrataValor(oProcess:oHtml:RetByName("t.11")[_nind])		, 0)
		_nItVrFrete :=   ((_nQUANT*_nPRECO)/_nTOTCOT)*_nFrete
//		u_console("_nItVrFrete: "+ Str(_nItVrFrete))
		dbSelectArea("SC8")

		dbSetOrder(1)
		IF SC8->(dbSeek( xFilial("SC8") + _cNUM + _cFORNECE + _cLOJA + _cITEM))  
			_cUser := SC8->C8_XUSER
			IF Alltrim(SC8->C8_NUMPED) == "" 
				CONOUT("Atualizando dados do item: " + _cItem )
				RecLock("SC8",.F.)                              
				If _cOpc == "N" // Recusa de participacao
					SC8->C8_OBS  	:= "Recusou participar: "+_cOBS
				Else
					SC8->C8_PRECO  	:= _nPRECO
					SC8->C8_TOTAL  	:= Round(_nQUANT * _nPRECO,2)
					SC8->C8_ALIIPI 	:= _nALIIPI
					SC8->C8_PRAZO  	:= _nPRAZO
					SC8->C8_COND   	:= _cCOND
					SC8->C8_OBS    	:= LEFT(_cOBS,30)
					SC8->C8_CONTATO	:= LEFT(_cCONTATO,15)
					SC8->C8_TPFRETE	:= _cTpFrete
//					SC8->C8_VALFRE	:= Iif(_nInd=1,_nFrete,0)
					SC8->C8_VALFRE	:= _nItVrFrete
					SC8->C8_TOTFRE	:= _nFrete
					SC8->C8_DESC 	:= _nDESC
					SC8->C8_VLDESC 	:= _nVLDESC
					SC8->C8_VALIPI 	:= _nVALIPI
				Endif  
				
				SC8->C8_XWF := "2"
				MsUnlock()
				
/*
				aItem := {}
				aAdd( aItem , SC8->C8_ITEM    )
				aAdd( aItem , SB1->B1_DESC )
				aAdd( aItem , TRANSFORM( SC8->C8_QUANT		,'@R 9,999,999.99' ) )
				aAdd( aItem , TRANSFORM( SC8->C8_PRECO		,'@R 9,999,999.99' ) )  
				aAdd( aItem , TRANSFORM( _nVLDESC			,'@R 9,999,999.99' ) )
				aAdd( aItem , TRANSFORM( SC8->C8_ALIIPI		,'@R 9,999,999.99' ) )
				aAdd( aItem , TRANSFORM( SC8->C8_VALIPI		,'@R 9,999,999.99' ) )
				aAdd( aItem , TRANSFORM( SC8->C8_PRAZO  	,'@R 9999' 	       ) )
				aAdd( aItem , TRANSFORM( _nQUANT * _nPRECO	,'@R 9,999,999.99' ) ) 
				aADD( aProd, aItem )
*/
			ELSE
				CONOUT("Item: " + _cItem + " nao processado, verifique cotacao... ")
			ENDIF
		Endif
	NEXT
	oProcess:Finish() // FINALIZA O PROCESSO

	U_EnviaAV(_cNUM, _cFORNECE, _cLOJA, _cUser) // elementos do array: 	C8_NUM, C8_FORNECE, C8_LOJA
 
	RETURN

//-----------------------------------------------------------------------
/*/{Protheus.doc} EnviaAV()

Apos o processamento da resposta do fornecedor dispara aviso ao usuario 
protheus (C8_XUSER)

@param		_cNum, _cFornece, _cLoja, _cUser
@return		Nenhum
@author 	Fabiano Albuquerque
@since 		23/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------

User Function EnviaAV(_cNum, _cFornece, _cLoja, _cUser)

   	DbSelectArea("SA2")
   	DbSetOrder(1)
   	DbSeek(xFilial("SA2") + _cFornece + _cLoja)

	oProcess:= TWFProcess():New( "000003", "Aviso - Cotacao de Precos respondida" )
	oProcess:NewTask( "Aviso - Cotacao de Precos respondida", "\workflow\HTML\AVforn.HTM" )
	oProcess:nEncodeMime 	:= 0
	oProcess:cSubject 		:= "Aviso - Cotacao Eletrônica de Precos No." + _cNum + " respondida."
	oProcess:cTo      		:= UsrRetMail(_cUser) ///// -> Mandar para o usuario que gerou a cotacao /////////////////////////////////////
	oProcess:NewVersion(.T.)            
	
 	oHtml     				:= oProcess:oHTML
 
	oHtml:ValByName( "A2_NOME"		, SA2->A2_NOME )
 	oHtml:ValByName( "C8_NUM"		, _cNum )
	oHtml:ValByName( "C8_FORNECE"   , SA2->A2_COD )
	oHtml:ValByName( "C8_LOJA"		, SA2->A2_LOJA )  
	oHtml:ValByName( "datetime"     , DTOC(MSDATE()) + " às " + left(time(),5) )
    
	oProcess:Start()

Return 


//-----------------------------------------------------------------------
/*/{Protheus.doc} Console()

@param		cTexto
@return		Nenhum
@author 	Fabiano Albuquerque
@since 		23/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
	

User Function Console(cTexto)

Local cEOL		:= Chr(13)+Chr(10)
Local nHdl2
Local aLogBody  := {}
Local nW		:= 0

Set Date To British

If cTexto == NIL
	cTexto := "["+DtoC(Date()) + ' ' + Time()+"] ** Texto não recebido **"
Else
	cTexto := "["+DtoC(Date()) + ' ' + Time()+"] " + cTexto
Endif

ConOut(cTexto)

Return

//-----------------------------------------------------------------------
/*/{Protheus.doc} TrataValor()

@param		nValor
@return		nValor - Formatado
@author 	Fabiano Albuquerque
@since 		05/04/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------

User Function TrataValor(nValor)

nValor := StrTran(nValor, ".", "")
nValor := StrTran(nValor, ",", ".")
nValor := Val(nValor)

Return nValor                  
