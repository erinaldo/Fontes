#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} SE5FI080()

Gravação de dados complementares da tabela SE5

O ponto de entrada SE5FI080 sera executado para gravar dados 
complementares da tabela SE5. A chamada ocorre apos gravar cada uma das 
seguintes movimentacoes bancarias.
1) Desconto
2) Juros
3) Multa
4) Correção monetária
5) Imposto substituição
6) Valor Pagamento

No momento da chamada a tabela SE5 está posicionada na última movimentação gravada.

@param		Nenhum
@return		Nenhum
@author 	Fabio Cazarini
@since 		25/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION SE5FI080()   
Local cRet := PARAMIXB
	
	//-----------------------------------------------------------------------
	// Mútuo de pagamentos:
	// - Gera movimento bancário a receber na filial original do mútuo 
	// - Gera movimento bancário a pagar na filial pagadora do mútuo
	//-----------------------------------------------------------------------
//	U_ASFINA42()
	
RETURN(cRet)