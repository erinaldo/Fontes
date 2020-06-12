#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA02()

Filtrar t�tulos enviados para o Fluig e ainda n�o aprovados.

Chamado pelo PE F090FIL

@param		nTipoBx		=	Tipo Baixa
			cBco		=	Banco
			cAge		=	Ag�ncia
			cCta		=	Conta
			cBord090I	=	Border� Inicial
			cBord090F	=	Border� Final
@return		cRet	=	Express�o caracter que ser� utilizada no filtro da 
						IndRegua. O filtro padr�o ser� anexado ao filtro 
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
	// N=N�o enviado Fluig;E=Enviado Fluig;I=Iniciada Aprov.Fluig;
	// A=Aprovado Fluig;R=Reprovado Fluig
	//-----------------------------------------------------------------------
	cRet := "E2_XSFLUIG $ ' |N|A' "	
	
RETURN cRet