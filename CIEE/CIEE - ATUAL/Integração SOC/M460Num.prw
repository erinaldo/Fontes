/*
+-----------+-------------+-----------+----------------+------+-------------+
| Programa  | u_M460Num   | Autor     | Fabio Zanchim  | Data |    07/2013  |
+-----------+-------------+-----------+----------------+------+-------------+
| Descricao | Integra��o SOC x Protheus                              		|
|           | 														 		|
+-----------+---------------------------------------------------------------+
| Uso       | CIEE   														|
+-----------+---------------------------------------------------------------+
*/
User Function M460Num()
Local aInf:={}

If u_IsIntSoc()//Fun��o em CIINTSOC.prw - verifica se � integra��o SOc X Protheus
	aInf:=u_GetSerNF()//Fun��o em CIINTSOC.prw - retorna variaveis staticas de l�.
	cNumero	:= aInf[1]
	cSerie	:= aInf[2]
EndIf

Return