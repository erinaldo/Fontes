#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'       
#INCLUDE 'TOPCONN.CH'
//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA58()

Movimentações do Banco Mútuo
PAGAMENTO
	- Gera movimento bancário a receber na empresa que efetuou o desembolso
	- Gera movimento bancário a pagar na empresa beneficária do mutuo

Executado nas rotinas que geram movimentação do mútuo:

@param		pFilPag - Empresa que efetuou o pagemento do mutuo
			pFilRec - Empresa que recebeu o mutuo   
			pLoteMut - Lote de mutuo
			pOPC	 - Opcoes P - Pagar, R-Receber

@return		Nenhum
@author 	Zema
@since 		15/05/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASFINA58(pFilPag,pFilRec,pLoteMut,pOpc, pValor)
LOCAL aArea			:= GETAREA()
LOCAL nRegSM0		:= SM0->(RECNO())
LOCAL cFilAux		:= cFilAnt
PRIVATE cBco		:= GETNEWPAR( "AS_BCOMUT", "MUT", pFilPag )
PRIVATE cAgenPag	:= ""
PRIVATE cCtaPag		:= ""                              
PRIVATE cAgenRec	:= ""
PRIVATE cCtaRec		:= ""                              
PRIVATE cNatur		:= GETNEWPAR( "AS_NATMUT", "0000000004", pFilPag )
PRIVATE nValorTran	:= pValor
PRIVATE cBenefPag	:= ""
PRIVATE cBenefRec	:= ""
PRIVATE cHistPag	:= ""
PRIVATE cHistRec	:= ""
PRIVATE cFilPag		:= ""
PRIVATE cFilRec		:= ""
PRIVATE cTipoTran	:= "MN"
PRIVATE cLoteMut	:= pLoteMut
PRIVATE cDocTran	:= ""                  
PRIVATE cOpcao		:= pOpc

cFilPag		:= pFilPag					// Empresa que fez o emprestimo do pagameto
cFilRec		:= pFilRec					// Empresa que tomou o emprestimo


// Localiza os bancos de mutuo pagar e receber

cFilAnt := cFilPag
SA6->(DBSETORDER(1))
IF SA6->(!DBSEEK(XFILIAL("SA6")+cBco))
	ApMsgAlert("Banco Mútuo não cadastrado para empresa : "+cFilPag)
   RETURN                                                          
ENDIF

cAgenPag	:= SA6->A6_AGENCIA
cCtaPag		:= SA6->A6_NUMCON

cFilAnt := cFilRec
SA6->(DBSETORDER(1))
IF SA6->(!DBSEEK(XFILIAL("SA6")+cBco))
	ApMsgAlert("Banco Mútuo não cadastrado para empresa : "+cFilRec)
   RETURN                                                          
ENDIF

cAgenRec	:= SA6->A6_AGENCIA
cCtaRec		:= SA6->A6_NUMCON

cFilAnt := cFilAux
  
// Atualiza os historicos e beneficiarios pagar e receber

SM0->(DBSETORDER(1))
SM0->(MsSeek(cEmpAnt+cFilRec)) 
cHistPag  	:= "PAG. MUTUO P/"+ALLTRIM(SM0->M0_NOMECOM) // No historico a empresa que tomou o emprestimo
cBenefPag	:= ALLTRIM(SM0->M0_NOMECOM) // Beneficiario do mutuo - a empresa que teve o titulo pago

SM0->(MsSeek(cEmpAnt+cFilPag)) 
cHistRec  	:= "REC. MUTUO DE: "+ALLTRIM(SM0->M0_NOMECOM) // No historico a empresa que efetuou o emprestimo
cBenefRec	:= ALLTRIM(SM0->M0_NOMECOM)  						// No destino não possui beneficiario

SM0->(DBGOTO(nRegSM0))

ExecTransf()                                                             

RestArea(aArea)
RETURN


//-----------------------------------------------------------------------
/*/{Protheus.doc} ExecTransf()
Realiza a transferência via ExecAuto FINA100
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		15/05/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
STATIC FUNCTION ExecTransf()
LOCAL lRet 			:= .T.
LOCAL cFilAux		:= cFilAnt
LOCAL aFINP100		:= {}
LOCAL aFINR100		:= {}	
LOCAL nOpcPag		:= 3
LOCAL nOpcRec		:= 4	
LOCAL nOpcExc		:= 5
LOCAL nRegSE5		:= 0

PRIVATE lMsErroAuto := .F.     
PRIVATE cHist100	:= cHistPag    

IF "P" $ cOpcao

	cDocTran := "MUTUO-"+cLoteMut+"/"+cFilPag
	
	//-----------------------------------------------------------------------
	// Movimento bancário na filial de pagamento
	//-----------------------------------------------------------------------
	cFilAnt := cFilPag
	
	aFINP100 := {;
				{"E5_DATA"		, dDataBase		, NIL},;
				{"E5_DOCUMEN" 	, cDocTran		, NIL},;
				{"E5_MOEDA"		, cTipoTran		, NIL},;
				{"E5_VALOR"		, nValorTran	, NIL},;
				{"E5_NATUREZ"	, cNatur		, NIL},;
				{"E5_BANCO"		, cBco			, NIL},;
				{"E5_AGENCIA"	, cAgenPag		, NIL},;
				{"E5_CONTA"		, cCtaPag		, NIL},;
				{"E5_BENEF"		, cBenefPag		, NIL},;
				{"E5_HISTOR"	, cHistPag		, NIL},;
				{"E5_ORIGEM"	, "ASFINA58"	, NIL},;					        
				{"E5_XLOTMUT"	, cLoteMut		, NIL},;					
				{"E5_XBCOFIL"	, cFilRec		, NIL};  					
				}
	
	MSExecAuto({|x,y,z| FinA100(x,y,z)},0,aFINP100,nOpcPag)
	
	IF lMsErroAuto
		MostraErro()
		lRet := .F.
	ELSE
		nRegSE5	:= SE5->( Recno() ) // guarda o numero de registro, se for necessária a exclusão do movimento
	ENDIF     
ENDIF
	
//-----------------------------------------------------------------------
// Movimento bancário na filial que recebeu o mutuo
//-----------------------------------------------------------------------

IF "R" $ cOpcao


	IF lRet
		cFilAnt 	:= cFilRec
		cHist100	:= cHistRec
	                
		cDocTran := "MUTUO-"+cLoteMut+"/"+cFilRec
	
	
		aFINR100 := {;
					{"E5_DATA"		, dDataBase		, NIL},;
					{"E5_DOCUMEN" 	, cDocTran		, NIL},;
					{"E5_MOEDA"		, cTipoTran		, NIL},;
					{"E5_VALOR"		, nValorTran	, NIL},;
					{"E5_NATUREZ"	, cNatur		, NIL},;
					{"E5_BANCO"		, cBco			, NIL},;
					{"E5_AGENCIA"	, cAgenRec		, NIL},;
					{"E5_CONTA"		, cCtaRec		, NIL},;
					{"E5_BENEF"		, cBenefRec		, NIL},;
					{"E5_HISTOR"	, cHistRec		, NIL},;     
					{"E5_ORIGEM"	, "ASFINA58"	, NIL},;					        
					{"E5_XLOTMUT"	, cLoteMut		, NIL},;											
					{"E5_XBCOFIL"	, cFilPag		, NIL};  					
					}
		
		MSExecAuto({|x,y,z| FinA100(x,y,z)},0,aFINR100,nOpcRec)
		
		IF lMsErroAuto
			MostraErro()
			lRet := .F.
			
			IF "P" $ cOpcao	 
			
				//-----------------------------------------------------------------------
				// Exclui movimento bancário de pagamento
				//-----------------------------------------------------------------------
				cFilAnt := cFilPag
				
				DbSelectArea("SE5")
				SE5->( DbGoTo( nRegSE5 ) )  // restaura a posição do numero de registro
				
				MSExecAuto({|x,y,z| FinA100(x,y,z)},0,aFINP100,nOpcExc)
					
				IF lMsErroAuto
					MostraErro()
					MsgAlert("Não foi possível excluir o movimento bancário a pagar gerado na transferência. Exclua o movimento manualmente!","Atenção") // não deve ocorrer, mas como eu tenho TOC
				ENDIF
			ENDIF
		ENDIF     
	ENDIF
ENDIF	
//-----------------------------------------------------------------------
// Retorna a filial
//-----------------------------------------------------------------------
cFilAnt := cFilAux

RETURN lRet  