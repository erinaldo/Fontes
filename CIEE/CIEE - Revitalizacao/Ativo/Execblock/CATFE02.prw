#Include 'Protheus.ch'
#INCLUDE "TOPCONN.CH"


static cCodForm:= ""

//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CATFE02
Monta tela de parametros para preenchimento de matricula e nome da entidade na solicitação de baixa e transferencia
@author  	Carlos henrique
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function CATFE02(lTela,nTipo)
Local lRetorno:= .T.
Local aParam	:= {}
Local aParRet	:= {}

if lTela		
	aAdd(aParam,{1,"Solicitante",Space(TAMSX3("ZAB_MATRIC")[1]),"","","ZAA","",0,.T.}) 
	
	if nTipo == 1
		aAdd(aParam,{1,"Nome Entidade",Space(TAMSX3("ZAB_NOMENT")[1]),"",'',"","",0,.F.}) 
		aAdd(aParam,{1,"CPF/CNPJ Entidade",Space(TAMSX3("ZAB_CGCENT")[1]),"",'',"","",0,.F.})
	endif 
	
	If ParamBox(aParam,"Parâmetros",@aParRet) 
		
		cCodForm := GetSxENum( "ZAB", "ZAB_COD" )
		ConfirmSX8()	
		
		RECLOCK("ZAB",.T.)
			ZAB->ZAB_FILIAL	:= XFILIAL("ZAB")
			ZAB->ZAB_COD		:= cCodForm
			ZAB->ZAB_IDFLG	:= ""
			ZAB->ZAB_MATRIC	:= aParRet[1]
			ZAB->ZAB_NOMSOL	:= POSICIONE('ZAA',1,xFilial('ZAA')+aParRet[2],'ZAA_NOME')
			if nTipo == 1
				ZAB->ZAB_NOMENT	:= aParRet[2]
				ZAB->ZAB_CGCENT	:= aParRet[3]
			endif				
			ZAB->ZAB_STATUS	:= "1"
		MSUNLOCK()			
	Else
		msgalert("Obrigatório o preenchimento dos campos para continuar!")
		lRetorno:= .f.
	ENDIF
Else
	RecLock("SNM",.f.)
	SNM->NM_XCODFOR	:= cCodForm													
	SNM->( MsUnlock() )	
		
	U_C1A02EWF(1,SNM->NM_SITSOL,SNM->NM_XCODFOR)
Endif	

Return lRetorno