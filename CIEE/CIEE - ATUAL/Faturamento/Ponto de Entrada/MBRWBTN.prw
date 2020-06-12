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

If FunName()=='FISA022' .And. nBotao==4//Transmiss�o de NFS-e (Prefeitura)                                                                                                     
	If !LockByName("CIIntSOC")	
		lRet:=.F.
		Aviso( "CIIntSOC", "Integra��o SOC (Cobran�a) em processamento. Aguarde a finaliza��o para libera��o do Faturamento manual.", {"Ok"}, 2)
	Else 
		UnLockByName("CIIntSOC")
	EndIF
EndIf
Return(lRet)