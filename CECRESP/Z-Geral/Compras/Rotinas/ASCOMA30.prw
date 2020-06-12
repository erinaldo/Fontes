#INCLUDE 'Rwmake.ch'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASCOMA30()

Adiciona cor no browse da rotina "Atualiza cotacao"

Chamado pelo PE MT150LEG

@param		nOp = {1 ou 2} (1 = Condição e Cor da Legenda a ser adcionada
                                e visualizada na mBrowse.
                            2 = Cor e Título a ser visualizada no
                                botão Legenda).
@return		aRet - Legendas adicionadas ou cor e titulos a ser visualizada
@author 	Fabiano Albuquerque
@since 		23/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------

USER FUNCTION ASCOMA30(_nOpc, _aRet)

If _nOpc == 1 // Cores
	Aadd( _aRet,{'C8_XWF="1" .and. Alltrim(C8_NUMPED) =""','BR_LARANJA'})
	Aadd( _aRet,{'C8_XWF="2" .and. Alltrim(C8_NUMPED) =""','BR_AZUL'   })
ElseIf _nOpc == 2  // Legenda
	Aadd( _aRet,{'BR_LARANJA','Enviado e-mail p/ fornec.'     } )
	Aadd( _aRet,{'BR_AZUL'   ,'E-mail respondido pelo fornec.'} )
Endif

Return _aRet


