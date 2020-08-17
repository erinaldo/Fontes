#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASFINA68()

Chamado pelo PE FT560CPC na manutenção da prestação de contas do caixinha

--> Devolve os campos adicionais da tabela SEU

@param		Nenhum
@return		Array com os campos adicionais da tabela SEU
@author 	Zema
@since 		05/09/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
User Function FT560CPC
Local aRet := {}
aadd(aRet,"EU_NATUREZ")
Return aRet