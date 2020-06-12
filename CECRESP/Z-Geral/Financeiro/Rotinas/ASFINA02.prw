#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA02()

Filtrar títulos enviados para o Fluig e ainda não aprovados.

Chamado pelo PE F090FIL

@param		nTipoBx		=	Tipo Baixa
			cBco		=	Banco
			cAge		=	Agência
			cCta		=	Conta
			cBord090I	=	Borderô Inicial
			cBord090F	=	Borderô Final
@return		cRet	=	Expressão caracter que será utilizada no filtro da 
						IndRegua. O filtro padrão será anexado ao filtro 
						gerado por este ponto de entrada.
@author 	Fabio Cazarini
@since 		06/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASFINA02(nTipoBx, cBco, cAge, cCta, cBord090I, cBord090F)
	LOCAL cRet	:= ""

	//-----------------------------------------------------------------------	
	// N=Não enviado Fluig;E=Enviado Fluig;I=Iniciada Aprov.Fluig;
	// A=Aprovado Fluig;R=Reprovado Fluig
	//-----------------------------------------------------------------------
	cRet := "E2_XSFLUIG $ ' |N|A' "	
	
RETURN cRet