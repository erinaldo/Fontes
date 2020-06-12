#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

//-----------------------------------------------------------------------
/*/{Protheus.doc} MT103VPC()

Importação de Pedidos de Compra

LOCALIZAÇÃO : Funções A103ForF4() , a103procPC() , A103ItemPC()

EM QUE PONTO : EXECUTA FILTRO NAIMPORATACAO DO PEDIDO DE COMPRAS
O ponto é chamado após o acionamento das teclas F5 ou F6 para a importaçao dos 
pedidos de compra (pedido inteiro F5 ou pedidos por Item F6), o arquivo de pedidos 
de compra SC7 está posicionado, bastando que se aplique o filtro com as condiçoes 
desejadas para a apresentaçao dos registros ou nao nas janelas, o retorno do ponto 
devera ser uma variavel logica com valor .T. para registros válidos e valor .F. para 
registros a serem descartados.                                            

lRet(logico)
RETORNA VARIAVEL LOGICA COM VALOR .T. SE O REGISTRO FOR VALIDO OU .F. PARA SE 
DESCARTAR O REGISTRO.

Nao exibe pedidos bloqueados, reprovados ou cancelados na consulta F5/F6

@param		Nenhum 
@return		Lógico = Exibe ou não exibe o item do pedido na importação do pedido de compras
@author 	Fabio Cazarini
@since 		19/05/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------
USER FUNCTION MT103VPC()
	LOCAL lRet	:= .T.
	
	lRet := U_ASCOMA11()
	
//	U_ASTOP203()
		
RETURN lRet