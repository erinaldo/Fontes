#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} F090FIL()

Filtro de dados

O ponto de entrada F090FIL sera utilizado para filtrar dados para a baixa 
automatica.

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
@since 		05/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION F090FIL()
	LOCAL cRet		:= ""
	LOCAL nTipoBx	:= PARAMIXB[1]
	LOCAL cBco		:= PARAMIXB[2]
	LOCAL cAge		:= PARAMIXB[3]
	LOCAL cCta		:= PARAMIXB[4]
	LOCAL cBord090I	:= ""
	LOCAL cBord090F	:= ""

	IF LEN(PARAMIXB) >= 5 // chamada pela rotina FINA090 (a FINA091 n�o envia os par�metros 5 e 6)
		cBord090I	:= PARAMIXB[5]
		cBord090F	:= PARAMIXB[6]
	ENDIF	

	//-----------------------------------------------------------------------
	// Filtrar t�tulos enviados para o Fluig e ainda n�o aprovados
	//-----------------------------------------------------------------------
	cRet := U_ASFINA02(nTipoBx, cBco, cAge, cCta, cBord090I, cBord090F)
	
RETURN cRet