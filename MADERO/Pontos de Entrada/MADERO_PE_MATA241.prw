#include "protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"

/*                                                    
+------------------+-------------------------------------------------------------------------------+
! Nome             ! MT241LOK                                                                      !
+------------------+-------------------------------------------------------------------------------+
! Descrição        ! Ponto de entrada executado no 'linok'                                         !
!                  !                                                                               !
+------------------+-------------------------------------------------------------------------------+
! Autor            ! Márcio Zaguetti                                                               !
+------------------+-------------------------------------------------------------------------------+
! Data             ! 24/06/2018                                                                    !
+------------------+-------------------------------------------------------------------------------+
*/                                                                                
User Function MT241LOK()
Local _lRet := .T.

	If u_IsBusiness()  
		If !aCols[N][Len(aCols[N])]
			// -> Verifica as regras para movimentação
			_lRet := U_EST200VL(.F.,.T.)
		Endif
	Endif	
	
Return(_lRet)


/*/{Protheus.doc} MT241CAB
//TODO Ponto-de-Entrada: MT241CAB - Inclus„o de campos no cabeÁalho da rotina Movimentos Internos Mod2
@author Mario L. B. Faria
@since 02/07/2018
/*/
User Function MT241CAB()

	Local nOpcx := ParamIxb[02]
	
	If nOpcx == 3
		@ 0.3,27.9  MSGET cCC F3 'ZA0' Picture PesqPict("SD3","D3_CC") Valid &(GetValid("D3_CC")) .And. VldUser('D3_CC') WHEN If(GetSx3Cache("D3_CC","X3_VISUAL") == "V",.F.,&(GetSx3Cache("D3_CC","X3_WHEN"))) OF oPanel1
	EndIf
	
Return

/*/{Protheus.doc} MT241SD3
//TODO LOCALIZAÇÃO : Função A241Inclui (Inclusão de Movimentação Interna).
EM QUE PONTO : É executado logo após a gravação dos movimentos internos (SD3), na inclusão e tem como finalidade a atualização de algum arquivo ou campo.
@author Mario L. B. Faria
@since 13/07/2018
/*/
User Function MT241SD3()

	//Verifica se o controle do saldo é na tabela customizada
	//*******************************************************
	If !IsInCallStack("U_A10001")
		U_APCP03MT()
	EndIf
	//*******************************************************

Return