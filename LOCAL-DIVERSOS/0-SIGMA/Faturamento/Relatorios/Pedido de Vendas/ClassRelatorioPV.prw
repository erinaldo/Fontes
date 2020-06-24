#Include "TOTVS.CH"
#Include "TOPCONN.CH"

#DEFINE RELATORIO_PV_CODE	"000000987A"

/*/{Protheus.doc} ClassRelatorioPV

Classe do Acelerador do Relatório do Pedido de Venda

@type class
@author Carlos Eduardo Niemeyer Rodrigues
@since 21/06/2016
/*/
Class ClassRelatorioPV
	
	Data cTitle
	Data cVersao	
	
	Method newClassRelatorioPV() Constructor

EndClass

/*/{Protheus.doc} newClassRelatorioPV

Método Construtor

@type method
@author Carlos Eduardo Niemeyer Rodrigues
@since 18/06/2016
/*/
Method newClassRelatorioPV() Class ClassRelatorioPV

	::cTitle		:= "Relatório de Pedido de Vendas"
	::cVersao		:= "V1.02-20160621"
	
	//If !( checkIPLicense() )
	//	Break
	//Endif
				
Return Self

/*
	Verifica o Licenciamento da TOTVS IP 
*/
Static Function checkIPLicense()
	Local oIPLicense 					:= Nil
	Local cCodeArtifact					:= RELATORIO_PV_CODE
	Local cNameArtifact					:= Nil
	Local lOnlyTestCompany				:= Nil
	Local lNoCheckLicenseInTestCompany	:= Nil
	Local nLimitCheck					:= 20
	Local lBreakInFail					:= .F.   
	Local cMotivo						:= ""
	Local lRet							:= .F.

	If ExistBlock("IPLicense")
		oIPLicense 	:= IPLicense():newIPLicense()
		lRet 		:= oIPLicense:useLicense(cCodeArtifact,cNameArtifact,lOnlyTestCompany,lNoCheckLicenseInTestCompany,nLimitCheck,lBreakInFail,@cMotivo)		
	Else
		MsgStop("Objeto (IPLicense) de Licenciamento da TOTVS IP não encontrado.","TOTVS IP")
	Endif
	
Return lRet