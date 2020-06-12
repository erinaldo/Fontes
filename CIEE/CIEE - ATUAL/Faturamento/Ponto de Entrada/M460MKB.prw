/*
+-----------+-------------+-----------+----------------+------+-------------+
| Programa  | u_M460MKB   | Autor     | Fabio Zanchim  | Data |    01/2014  |
+-----------+-------------+-----------+----------------+------+-------------+
| Descricao | Faturamento via MATA460                                 		|
|           | 														 		|
+-----------+---------------------------------------------------------------+
| Uso       | CIEE   														|
+-----------+---------------------------------------------------------------+
*/

User Function M460MKB()
Return('u_460MkbVld()')


User Function 460MkbVld()

If !LockByName("CIIntSOC")
	Aviso( "CIIntSOC", "Integração SOC em processamento. Aguarde a finalização para liberação do Faturamento manual.", {"Ok"}, 2)
	Return(.F.)
EndIf

UnLockByName("CIIntSOC")
Return(.T.)