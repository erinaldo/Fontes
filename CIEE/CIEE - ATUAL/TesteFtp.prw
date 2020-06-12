#Include 'Protheus.ch'

User Function TesteFtp()

//Local cServer	:='ftp://ftpdtc.totvs.com.br/cdprxc_origin'
//Local cServer	:='ftpdtc.totvs.com.br\cdprxc_origin'
Local cServer	:='ftpdtc.totvs.com.br'
Local cUser		:='cdprxc_origin@datacenter.local'
Local cPass		:='cdp@2014'//GetMv('MV_',,'')

If !FTPConnect(cServer,,cUser,cPass)
	Aviso('Tentativa 1','Falha de conexão com servidor FTP.',{"Ok"})	
Else
	MsgAlert('Conectou!')
	Ftpdirchange ('/cdprxc_origin/arq_txt')
    aRetDir := FTPDIRECTORY( "*.*" ,  "D")
	FTPDISCONNECT()
	Return
EndIf

If !FTPConnect(cServer,21,cUser,cPass)
	Aviso('Tentativa 2','Falha de conexão com servidor FTP.',{"Ok"})	
Else
	MsgAlert('Conectou!')
	FTPDISCONNECT()
	Return
EndIf

If !FTPConnect(cServer,20,cUser,cPass)
	Aviso('Tentativa 3','Falha de conexão com servidor FTP.',{"Ok"})	
Else
	MsgAlert('Conectou!')
	FTPDISCONNECT()
	Return
EndIf
      
Return