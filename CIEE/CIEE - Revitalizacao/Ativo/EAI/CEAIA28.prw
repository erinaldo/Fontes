#INCLUDE "TOTVS.CH"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CEAIA28
Integração Fluig x Protheus - Transferência de ativo
@author  	Carlos Henrique
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
USER FUNCTION CEAIA28(cXml) 
local cXmlRet		:= {}
LOCAL oXml			:= NIL 
LOCAL cXmlRet		:= "" 
LOCAL cError		:= ""   
LOCAL cWarning	:= ""
Local nOpc			:= 0
Local aRet			:= {.F.,""} 
local cData		:= Dtos(Date())
local cHora		:= Time()
Local cCodForm	:= ""
Local cIDForm		:= ""
Local cCodSol		:= ""
Local dDatSol		:= dDataBase
Local dHorSol		:= Left(TIME(),5)
Local cUsrSol		:= TRIM(GetMv("CI_USERFLU",.F.,"000000"))
Local cNmUsSol	:= USRFULLNAME( cUsrSol )
Local cHistSol	:= ""
Local cCBase		:= ""
Local cItem		:= ""
Local cCCustoDst	:= ""
Local cLocalDst	:= ""			

//Verifica se controle de solicitações está ativado
If SuperGetMv( "MV_ATFSOLD", .F., "2" ) == "2"
	aRet[1]	:= .T.
	aRet[2]	:= "Controle de solicitações desativado, verifique parâmetro 'MV_ATFSOLD'."
EndIf 

if !aRet[1]
	oXml := XmlParser(cXml, "_", @cError, @cWarning)
	
	if !Empty(cError) 
		aRet[1]	:= .T.
		aRet[2]	:= "Erro no xml: "+cError
	 endif
	
	if !aRet[1] .and. !Empty(cWarning)                        
		aRet[1]	:= .T.
		aRet[2]	:= "Erro no xml: "+cWarning
	endif  
endif

nOpc:= Val(oXml:_CEAIA28:_OPERATION:TEXT)

If nOpc != 5 
	aRet[1]	:= .T.
	aRet[2]	:= "O valor do atributo Operation não é válido: "+cvaltochar(nOpc)
Endif	

if !aRet[1] 

	cIDForm	:= STRZERO(VAL(oXml:_CEAIA28:_SNMMASTER:_NM_XCODFOR:TEXT),6)
	cCBASE		:= oXml:_CEAIA28:_SNMMASTER:_NM_CBASE:TEXT
	cItem		:= AllTrim(oXml:_CEAIA28:_SNMMASTER:_NM_ITEM:TEXT)
	cCCustoDst	:= oXml:_CEAIA28:_SNMMASTER:_NM_CCUSTO:TEXT 
	cLOCALDst	:= oXml:_CEAIA28:_SNMMASTER:_NM_LOCAL:TEXT 
	cHistSol	:= oXml:_CEAIA28:_SNMMASTER:_NM_CDHSOL:TEXT
	cMatSol	:= oXml:_CEAIA28:_SNMMASTER:_NM_XMATRIC:TEXT
		

	dbSelectArea( "SN1" )
	SN1->( dbSetOrder(1) )
	
	If SN1->( dbSeek( xFilial( "SN1" ) + cCBASE +  cItem  ) )
		
		dbSelectArea( "SN3" )
		SN3->( dbSetOrder(1) )
		SN3->( dbSeek( xFilial( "SN3" ) + cCBASE +  cItem ) )
			
	
		Begin Transaction
		
			DBSELECTAREA("ZAB")
			DBSETORDER(2)
			If !ZAB->(dbSeek( xFilial("ZAB")+cIDForm))
				
				cCodForm := GetSxENum( "ZAB", "ZAB_COD" )
				ConfirmSX8()
							
				RECLOCK("ZAB",.T.)
					ZAB->ZAB_FILIAL	:= XFILIAL("ZAB")
					ZAB->ZAB_COD		:= cCodForm
					ZAB->ZAB_IDFLG	:= cIDForm
					ZAB->ZAB_MATRIC	:= cMatSol
					ZAB->ZAB_NOMSOL	:= POSICIONE('ZAA',1,xFilial('ZAA')+cMatSol,'ZAA_NOME')
					ZAB->ZAB_STATUS	:= "1"
				MSUNLOCK()	
			ELSE
				cCodForm:= ZAB->ZAB_COD 								
			Endif				
	
			cCodSol := GetSxENum( "SNM", "NM_CODIGO" )
			ConfirmSx8()
			
			RecLock( "SNM", .T. )
			SNM->NM_FILIAL	:= xFilial( "SNM" )
			SNM->NM_CODIGO	:= cCodSol
			SNM->NM_DATSOL	:= dDatSol
			SNM->NM_HORSOL	:= StrTran( Left( dHorsol, 5 ), ":", "" )
			SNM->NM_CBASE		:= cCBase
			SNM->NM_ITEM		:= cItem
			SNM->NM_TIPO		:= SN3->N3_TIPO
			SNM->NM_SITSOL	:= "1" //Pendente
			SNM->NM_USRSOL	:= cUsrSol
			SNM->NM_TIPOSOL	:= "2" //Transferencia
			SNM->NM_FILDEST 	:= cFilAnt
			SNM->NM_GRUPO		:= SN1->N1_GRUPO
			SNM->NM_CCUSTO	:= SN3->N3_CCUSTO
			SNM->NM_LOCAL		:= cLocalDst
			SNM->NM_CCONTAB	:= SN3->N3_CCONTAB
			SNM->NM_CCORREC	:= SN3->N3_CCORREC
			SNM->NM_CDEPREC	:= SN3->N3_CDEPREC
			SNM->NM_CDDEPR	:= SN3->N3_CCDEPR	
			SNM->NM_CDESP		:= SN3->N3_CDESP
			SNM->NM_CUSTBEM	:= cCCustoDst 
			SNM->NM_CCCORR	:= SN3->N3_CCCORR
			SNM->NM_CCDESP	:= SN3->N3_CCDESP
			SNM->NM_CCCDEP	:= SN3->N3_CCCDEP
			SNM->NM_CCCDES	:= SN3->N3_CCCDES
			SNM->NM_ITBEM		:= SN3->N3_SUBCCON
			SNM->NM_ITCORR	:= SN3->N3_SUBCCOR
			SNM->NM_ITDESP	:= SN3->N3_SUBCDEP
			SNM->NM_ITCDEP	:= SN3->N3_SUBCCDE
			SNM->NM_ITCDES	:= SN3->N3_SUBCDES
			SNM->NM_CLVLBEM	:= SN3->N3_CLVLCON
			SNM->NM_CLVLCOR	:= SN3->N3_CLVLCOR
			SNM->NM_CLVLDEP	:= SN3->N3_CLVLDEP
			SNM->NM_CLVLCDE	:= SN3->N3_CLVLCDE
			SNM->NM_CLVLDES	:= SN3->N3_CLVLDES
			SNM->NM_GERANF	:= "1" 
			SNM->NM_NOTA		:= CriaVar( "NM_NOTA" )
			SNM->NM_SERIE		:= SuperGetMv("CI_SERIETR",.F., "1" )  
			SNM->NM_TESNFS	:= SuperGetMv("CI_TESNFST",.F., "501" ) 
			SNM->NM_CLASNFE	:= "1" 
			SNM->NM_TESNFE	:= SuperGetMv("CI_TESNFET",.F., "001" )
			SNM->NM_CONDPG	:= SuperGetMv("CI_CONDPGT",.F., "002" )
			
			// Campos especificos
			SNM->NM_XCODFOR	:= cCodForm
		
			MSMM( SNM->NM_CDHSOL, , , cHistSol, 1, , , "SNM", "NM_CDHSOL" )
			SNM->( MsUnlock() )					
			
		
		End Transaction
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ponto de entrada executado apÃ³s a gravaÃ§Ã£o da solicitaÃ§Ã£o transferÃªncia	³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ				
		If ExistBlock( "AF125GRT" )
			ExecBlock( "AF125GRT", .F., .F. )
		EndIf		
	
	Else          
		aRet[1] := .T.
		aRet[2] := "Código não cadastrado"							
	EndIf
ENDIF
 
cXmlRet+= '<TOTVSIntegrator>'+CRLF
cXmlRet+= '	<DATA>'+cData+'</DATA>'+CRLF
cXmlRet+= '	<HORA>'+cHora+'</HORA>'+CRLF
cXmlRet+= '	<ID>'+cCodForm+'</ID>'+CRLF
cXmlRet+= '	<LOGMASTER modeltype="FIELDS">'+CRLF
cXmlRet+= '		<RETORNO>'+iif(!aRet[1],"0","1")+'</RETORNO>'+CRLF	    	       
cXmlRet+= '		<MOTIVO>'+iif(!aRet[1],"",aRet[2])+'</MOTIVO>'+CRLF
cXmlRet+= '	</LOGMASTER>'+CRLF
cXmlRet+= '	<GlobalDocumentFunctionCode>CEAIA28</GlobalDocumentFunctionCode>'+CRLF
cXmlRet+= '	<GlobalDocumentFunctionDescription>Integracao Fluig x Protheus - Transferencia</GlobalDocumentFunctionDescription>'+CRLF
cXmlRet+= '</TOTVSIntegrator>'+CRLF

RETURN cXmlRet 