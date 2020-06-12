#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} ASCOMA08()

Adiciona novas regras para a legenda do browse do pedido de compras
Chamado pelo PE MT120COR

@param		aPadrao = Regras para a apresentação das cores do status do pedido de compras na mbrowse 
@return		aRet = Regras alteradas
@author 	Fabio Cazarini
@since 		19/05/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASCOMA08(aPadrao)
	LOCAL aRet		:= Array(LEN(aPadrao)+2,2)
	LOCAL nX		:= 0

	FOR nX := 1 TO LEN(aRet)
		IF nX == 1	// adiciona a legenda customizada na 1a. posicao, para ser avaliada antes das legendas do padrao
			aRet[nX][1] := 'C7_XSFLUIG = "R"' // Pedido Reprovado
			aRet[nX][2] := 'BR_PINK'
		ELSEIF nX == 2
			aRet[nX][1] := 'C7_XCNTTOP <> SPACE(20)' // Pedido Enviado ao TOP
			aRet[nX][2] := 'PMSEDT4'
		ELSE
			aRet[nX][1] := aPadrao[nX-2][1]
			aRet[nX][2] := aPadrao[nX-2][2]
		ENDIF                       
	NEXT nX

RETURN aRet