/*
+-----------+-------------+-----------+----------------+------+-------------+
| Programa  | u_PE_LOADSA6| Autor     | Fabio Zanchim  | Data |    11/2013  |
+-----------+-------------+-----------+----------------+------+-------------+
| Descricao | P.E. em Carrega SA6()                                       	|
|           |            											   		|
+-----------+---------------------------------------------------------------+
| Uso       | CIEE   														|
+-----------+---------------------------------------------------------------+
*/
User Function PE_LOADSA6()
Local _cNat:=CriaVar("E5_NATUREZ")

If IsInCallStack('FA100TRAN') .And. cEmpAnt=="01"//Trsnf Bancaria
	
	If cTipoTran=="TE"//TED
		_cNat:='33040101'
	EndIf
EndIf

Return(_cNat)	