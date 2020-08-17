#INCLUDE 'PROTHEUS.CH'

/*{Protheus.doc} SPDPCIMOB 
PE - Inclus�o do F200 na gera��o do EFD

@param		Nil
@return		aRet 
@author 	Adriano da Silva de Deus
@since 		07/04/2018
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
User Function SPDPCIMOB()

Local aRet := {}  

aRet := U_ASTAFA01(ParamIxb)                                                                  

Return(aRet)