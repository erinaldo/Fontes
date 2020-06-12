#INCLUDE "TOTVS.CH"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CEAIA27
Integração Fluig x Protheus - Baixa de ativo
@author  	Carlos Henrique
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
USER FUNCTION CEAIA27(cXml) 
LOCAL oXml		:= NIL 
LOCAL cXmlRet	:= "" 
LOCAL cError	:= ""   
LOCAL cWarning:= ""
Local nOpc		:= 0
Local aRet		:= {.F.,""} 
local cData	:= Dtos(Date())
local cHora	:= Time()
Local cCodForm:= ""
Local cIDForm:= ""
Local cCBASE	:= ""
Local cITEM	:= ""
Local cTIPO	:= ""
Local cDESCBEM:= ""
Local nN1_QTDE:= 0
Local nQTDBX	:= 0
Local cMOTBX	:= ""
Local cCONDPG	:= ""
Local cGERANF	:= "2"
Local cCLIENTE:= ""
Local cLOJA	:= ""
Local cNOTA	:= ""
Local cSERIE	:= ""
Local cTESNFS	:= ""
Local dDATSOL	:= dDataBase
Local dHORSOL	:= Left(TIME(),5)
Local cUSRSOL	:= TRIM(GetMv("CI_USERFLU",.F.,"000000")) 
Local cNMUSSOL:= USRFULLNAME( cUSRSOL )
Local cHistSol:= "" 
Local cNomEnt	:= ""	
Local cCGCEnt	:= ""

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

nOpc		:= Val(oXml:_CEAIA27:_OPERATION:TEXT)

If nOpc != 3 
	aRet[1]	:= .T.
	aRet[2]	:= "O valor do atributo Operation não é válido: "+cvaltochar(nOpc)
Endif	
	

if !aRet[1] 
	cIDForm	:= STRZERO(VAL(oXml:_CEAIA27:_SNMMASTER:_NM_XCODFOR:TEXT),6)
	cCBASE		:= PADR(oXml:_CEAIA27:_SNMMASTER:_NM_CBASE:TEXT,TAMSX3("NM_CBASE")[1])
	cITEM		:= TRIM(oXml:_CEAIA27:_SNMMASTER:_NM_ITEM:TEXT)
	cTIPO		:= ""
	cDESCBEM	:= ""
	nN1_QTDE	:= 0
	cMOTBX		:= oXml:_CEAIA27:_SNMMASTER:_NM_MOTBX:TEXT		
	nQTDBX		:= val(oXml:_CEAIA27:_SNMMASTER:_NM_QTDBX:TEXT)
	dDATSOL	:= DDATABASE
	dHORSOL	:= Left(TIME(),5)
	cHistSol	:= oXml:_CEAIA27:_SNMMASTER:_NM_CDHSOL:TEXT
	cMatSol	:= TRIM(oXml:_CEAIA27:_SNMMASTER:_NM_XMATRIC:TEXT)	
	cNomEnt	:= oXml:_CEAIA27:_SNMMASTER:_NM_XNOMENT:TEXT	
	cCGCEnt	:= oXml:_CEAIA27:_SNMMASTER:_NM_XCGCENT:TEXT	
	
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
					ZAB->ZAB_NOMENT	:= cNomEnt
					ZAB->ZAB_CGCENT	:= cCGCEnt
					ZAB->ZAB_STATUS	:= "1"
				MSUNLOCK()	
			ELSE
				cCodForm:= ZAB->ZAB_COD 				
			Endif				
	
			cCodSol := GetSxENum( "SNM", "NM_CODIGO" )
			ConfirmSX8()
			
			RecLock( "SNM", .T. )
			SNM->NM_FILIAL	:= xFilial( "SNM" )
			SNM->NM_CODIGO	:= cCodSol
			SNM->NM_DATSOL	:= dDatSol
			SNM->NM_HORSOL	:= StrTran( Left( dHorsol, 5), ":", "" )
			SNM->NM_CBASE		:= cCBase
			SNM->NM_ITEM		:= cITEM
			SNM->NM_TIPO		:= SN3->N3_TIPO
			SNM->NM_SITSOL	:= "1" 		//Pendente
			SNM->NM_USRSOL	:= cUSRSOL
			SNM->NM_TIPOSOL	:= "1" 		//Baixa
			SNM->NM_MOTBX		:= SubStr( cMOTBX, 1, 2 )
			SNM->NM_QTDBX		:= nQTDBX
			SNM->NM_PERCBX	:= 0
			SNM->NM_VLRBAIX	:= 0
			SNM->NM_VLVENDA	:= 0
			SNM->NM_GERANF	:= "2"
			SNM->NM_NOTA		:= ""
			SNM->NM_SERIE		:= ""
			SNM->NM_TESNFS	:= ""
			SNM->NM_CONDPG	:= ""
			SNM->NM_CLIENTE	:= ""
			SNM->NM_LOJA		:= ""
			SNM->NM_CCUSTO	:= SN3->N3_CCUSTO
			SNM->NM_LOCAL		:= SN1->N1_LOCAL
			SNM->NM_GRUPO		:= SN1->N1_GRUPO
			
			// Campos especificos
			SNM->NM_XCODFOR	:= cCodForm		
			
			MSMM( SNM->NM_CDHSOL, , ,cHistSol, 1, , , "SNM", "NM_CDHSOL" )												
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
cXmlRet+= '	<GlobalDocumentFunctionCode>CEAIA27</GlobalDocumentFunctionCode>'+CRLF
cXmlRet+= '	<GlobalDocumentFunctionDescription>Integracao Fluig x Protheus - Baixa de ativo</GlobalDocumentFunctionDescription>'+CRLF
cXmlRet+= '</TOTVSIntegrator>'+CRLF

RETURN cXmlRet 
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CCA27VWF   ºAutor  ³ Totvs       	   º Data ³01/01/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida e-mail responsável		    			  		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/ 
User Function CCA27VWF(cCBase, cItem )
Local aArea     := GetArea()
Local aRet  	:= {.F.,""} 
Local cVarSX6

aEmailSol := {} //Zerar vetor para adicionar novos aprovadores

dbSelectArea( "SND" )	//Tabela de cadastro de ResponsÃ¡veis pelos bens
SND->(dbSetOrder(2))

If SND->( dbSeek( xFilial( "SND" ) + cCBase + cItem ) )
	
	dbSelectArea( "RD0" )	//Tabela de cadastro de participantes
	RDO->(dbSetOrder(1))
	
	While ( SND->(!Eof()) ) .And. ( SND->ND_CBASE == cCBase ) .And. ( SND->ND_ITEM  == cItem )
		
		//Se responsÃ¡vel estÃ¡ Ativo
		If	SND->ND_STATUS == "1"
			If RD0->( MsSeek( xFilial( "RD0" ) + SND->ND_CODRESP ) )
				If !Empty( RD0->RD0_EMAIL )
					aAdd( aEmailSol, { RD0->RD0_EMAIL, RD0->RD0_CODIGO, .T. } )
				Endif
			End
		Endif
		
		SND->(DbSkip())
	End
	
	If Empty( aEmailSol )
		aRet[1]	:= .T.
		aRet[2] := "AusÃªncia do endereÃ§o de e-mail no cadastro do responsÃ¡vel pelo Ativo." 
	EndIf
	
Else    
	aRet[2] := "AusÃªncia de responsÃ¡vel pelo Ativo para envio de e-mail de solicitaÃ§Ã£o de aprovaÃ§Ã£o."
EndIf

If !aRet[1]
	
	
	If !EMPTY(aRet[2])
			
		cVarSX6 := SuperGetMV( "MV_ATFRESP", .F., "" )
		If !Empty(cVarSX6)
			PswOrder(1)
			If PswSeek(cVarSX6)
				If Alltrim( PswRet()[1,14] ) == ""
					aRet[1]	:= .T.                                      
					aRet[2] 	:= "E-mail do responsavel padrÃ£o do ativo nÃ£o preenchido."
				Else
					aEmailSol := { { PswRet()[1,14], cVarSX6, .F. } }
				EndIf
			Endif
		Else			
			aRet[1]	:= .T.
			aRet[2] 	:= "Responsavel padrÃ£o dos Ativos nÃ£o preenchido." 			
		Endif   
		
	EndIf
EndIf

RestArea( aArea )
Return aRet 