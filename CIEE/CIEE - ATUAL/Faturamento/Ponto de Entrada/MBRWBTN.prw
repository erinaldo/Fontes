/*
+-----------+-------------+-----------+----------------+------+-------------+
| Programa  | u_MBRWBTN   | Autor     | Fabio Zanchim  | Data |    03/2014  |
+-----------+-------------+-----------+----------------+------+-------------+
| Descricao | P.E na execucao das rotinas do mBrowse	              		|
|           | 														 		|
+-----------+---------------------------------------------------------------+
| Uso       | CIEE   														|
+-----------+---------------------------------------------------------------+
*/
User Function MBRWBTN()

Local lRet:=.T.
Local nBotao:=Paramixb[3]

If FunName()=='FISA022' .And. nBotao==4//Transmissão de NFS-e (Prefeitura)                                                                                                     
	If !LockByName("CIIntSOC")	
		lRet:=.F.
		Aviso( "CIIntSOC", "Integração SOC (Cobrança) em processamento. Aguarde a finalização para liberação do Faturamento manual.", {"Ok"}, 2)
	Else 
		UnLockByName("CIIntSOC")
	EndIF
EndIf
Return(lRet)