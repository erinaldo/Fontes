/*
+-----------+-------------+-----------+----------------+------+-------------+
| Programa  | u_M460Num   | Autor     | Fabio Zanchim  | Data |    07/2013  |
+-----------+-------------+-----------+----------------+------+-------------+
| Descricao | Integração SOC x Protheus                              		|
|           | 														 		|
+-----------+---------------------------------------------------------------+
| Uso       | CIEE   														|
+-----------+---------------------------------------------------------------+
*/
User Function M460Num()
Local aInf:={}

If u_IsIntSoc()//Função em CIINTSOC.prw - verifica se é integração SOc X Protheus
	aInf:=u_GetSerNF()//Função em CIINTSOC.prw - retorna variaveis staticas de lá.
	cNumero	:= aInf[1]
	cSerie	:= aInf[2]
EndIf

Return