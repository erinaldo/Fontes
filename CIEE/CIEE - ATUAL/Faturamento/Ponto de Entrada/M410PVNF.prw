/*
+-----------+-------------+-----------+----------------+------+-------------+
| Programa  | u_M410PVNF  | Autor     | Fabio Zanchim  | Data |    01/2014  |
+-----------+-------------+-----------+----------------+------+-------------+
| Descricao | Botao Prep. Doc. Saida via Pedido de Venda              		|
|           | 														 		|
+-----------+---------------------------------------------------------------+
| Uso       | CIEE   														|
+-----------+---------------------------------------------------------------+
*/
User Function M410PVNF()

If !LockByName("CIIntSOC")
	Aviso( "CIIntSOC", "Integração SOC (Cobrança) em processamento. Aguarde a finalização para liberação do Faturamento manual.", {"Ok"}, 2)
	Return(.F.)
EndIf

UnLockByName("CIIntSOC")

Return(.T.)