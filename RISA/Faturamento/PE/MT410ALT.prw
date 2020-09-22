#Include "protheus.ch"

/*/

{Protheus.doc} MT410ALT
                 
Ponto de Entrada apos confirmacao da alteracao do pedido

@author  Milton J.dos Santos	
@since   15/07/20
@version 1.0

/*/

User Function MT410ALT()
Local lRet := .T.

// Chamadas de outros modulos que nao utilizam as regras de precos e descontos
If U_USAREGRA()

    If ExistBlock("BlocPed")
        ExecBlock( "BlocPed", .F., .F.)
    Endif
    If ExistBlock("AESS001")
        IF SC5->C5_BLQ <> "X"
            If MSGYESNO("Deseja imprimir o pedido?")
                ExecBlock( "AESS001", .F., .F.)
            Endif
        Endif
    Endif

Endif

Return(lRet)
