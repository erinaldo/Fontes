#Include 'Protheus.ch'
#Include 'Ap5Mail.ch'

#Define _DOWN_ 1
#Define _UP_   2

/*
+-----------+-----------+-------------+----------------+------+-------------+
| Programa  | FilesFtp  | Autor       | Fabio Zanchim  | Data | 06/2014     |
+-----------+-----------+-------------+----------------+------+-------------+
| Descricao | Troca de arquivos entre ambiente CIEE e FTP datacenter Totvs. |
|           |                                                               |
+-----------+---------------------------------------------------------------+
| Uso       | Especifico CIEE                                               |
+-----------+---------------------------------------------------------------+
|                  Modificacoes desde a construcao inicial                  |
+--------------+-----------+------------------------------------------------+
| Responsavel  | Data      | Motivo                                         |
+--------------+-----------+------------------------------------------------+
+--------------+-----------+------------------------------------------------+
*/

User Function FilesFtp()

Local _cLog		:='LOG DE INTEGRAÇÃO FTP DATACENTER TOTVS'+CRLF+CRLF
Local nX		:=0
Local nY		:=0
Local cDirLocal	:=''
Local cDirFTP	:=''
Local cDrive	:=''
Local cDiretorio:=''
Local cNome		:=''
Local cExtensao	:=''
Local lRet1		:=.T.
Local lRet2		:=.T.
Local lFez		:=.F.
Local aFiles	:={}
Local aPath		:={}
Local cServer	:=''
Local cUser		:=''
Local cPass		:=''
Local lErro		:=.F.
Local cDirIni	:='/cdprxc_origin'
Local dDtCorte:= (date() -= 7 )//Download de arquivos com data de 7 dias
Private _lJob := .T.
          
_lJob := IIf(GetRemoteType() == -1, .T., .F.)
If _lJob
	RpcSetType(3)
	RpcSetEnv('01','01')
EndIf

If !LockByName("FTPCiee")
	_cLog+='Troca de arquivos em processamento. Aguardar...'
	If !_lJob
		MostraText(_cLog)
	Else
		RpcClearEnv()
	EndIf
	Return()
End

cServer	:=GetMv('CI_FTPTEND',,'')
cUser	:=GetMv('CI_FTPTUSR',,'')
cPass	:=GetMv('CI_FTPTPSW',,'')  

If !FTPConnect(cServer,,cUser,cPass)
	_cLog+='Falha de conexão com servidor FTP.'
	If !_lJob
		MostraText(_cLog)
	EndIf
	EnvMail(_cLog)
	If _lJob
		RpcClearEnv()
	endIf
	Return()
EndIf

//-----------------------------------------------------------------------------------------
// Estrutura de pastas para troca de arquivos.
//-----------------------------------------------------------------------------------------
//Caminho , Download/Upload , Deleta ou não
Aadd(aPath,{'\ARQ_TXT\ALMOXARIFADO\ReqMaterial\'					 	,_UP_		,.T.})  //OK   (Backup)
//-----------------------------------------------------------------------------------------
Aadd(aPath,{'\ARQ_TXT\CONTABILIDADE\'								 	,_DOWN_		,.F.})	//OK   (Backup)
Aadd(aPath,{'\ARQ_TXT\CONTABILIDADE\Ativo\'	   						 	,_UP_		,.T.})  //OK   (Backup)
Aadd(aPath,{'\ARQ_TXT\CONTABILIDADE\FFQ\'	 					  	 	,_UP_		,.T.})  //OK   (Backup)
//-----------------------------------------------------------------------------------------
Aadd(aPath,{'\ARQ_TXT\FISCAL\Exportacao\'	   						 	,_DOWN_		,.F.}) 	//OK   (Backup)
Aadd(aPath,{'\ARQ_TXT\FISCAL\Importacao\'	   						 	,_UP_		,.T.})  //OK   (Backup)
Aadd(aPath,{'\ARQ_TXT\FISCAL\Importacao\Log\'   					 	,_DOWN_		,.F.}) 	//OK   (Backup)
Aadd(aPath,{'\ARQ_TXT\FISCAL\Importacao\Retorno\'					 	,_UP_		,.T.})  //OK   (Backup)
//-----------------------------------------------------------------------------------------
Aadd(aPath,{'\ARQ_TXT\TESOURARIA\cnab\Nacional\PagFor\'				 	,_DOWN_		,.F.}) 	//OK   (Backup)
Aadd(aPath,{'\ARQ_TXT\TESOURARIA\cnab\PagFor\'						 	,_DOWN_		,.F.})	//OK   (Backup)
Aadd(aPath,{'\ARQ_TXT\TESOURARIA\cnab\Sispag\'						 	,_DOWN_		,.F.}) 	//OK   (Backup)
Aadd(aPath,{'\ARQ_TXT\TESOURARIA\cnab\SispagBrasil\' 				 	,_DOWN_		,.F.}) 	//OK   (Backup)
Aadd(aPath,{'\ARQ_TXT\TESOURARIA\cnab\SispagCEF\'					 	,_DOWN_		,.F.}) 	//OK   (Backup)
Aadd(aPath,{'\ARQ_TXT\TESOURARIA\cnab\SispagSantander\'				 	,_DOWN_		,.F.}) 	//OK   (Backup)
//-----------------------------------------------------------------------------------------
Aadd(aPath,{'\ARQ_TXT\TESOURARIA\Fiba\'								 	,_UP_		,.T.})  //OK   (Backup)
//-----------------------------------------------------------------------------------------
Aadd(aPath,{'\ARQ_TXT\TESOURARIA\Fluxo\'							 	,_DOWN_		,.F.}) 	//OK   (Backup)
//-----------------------------------------------------------------------------------------
Aadd(aPath,{'\ARQ_TXT\TESOURARIA\Importacao\Banco do Brasil\'	 	 	,_UP_		,.T.})  //OK   (Backup)
Aadd(aPath,{'\ARQ_TXT\TESOURARIA\Importacao\Banco do Brasil\Retorno\'	,_UP_		,.T.})  //OK   (Backup)
Aadd(aPath,{'\ARQ_TXT\TESOURARIA\Importacao\Banco CEF\'			 	 	,_UP_		,.T.})  //OK   (Backup)
Aadd(aPath,{'\ARQ_TXT\TESOURARIA\Importacao\Banco Santander Banespa\'	,_UP_		,.T.})  //OK   (Backup)
Aadd(aPath,{'\ARQ_TXT\TESOURARIA\Importacao\Bradesco\'				 	,_UP_		,.T.})  //OK   (Backup)
Aadd(aPath,{'\ARQ_TXT\TESOURARIA\Importacao\Bradesco\Retorno\'		 	,_UP_		,.T.})  //OK   (Backup)
Aadd(aPath,{'\ARQ_TXT\TESOURARIA\Importacao\Itau\'					 	,_UP_		,.T.})  //OK   (Backup)
Aadd(aPath,{'\ARQ_TXT\TESOURARIA\Importacao\Itau\Remessa\'		 	 	,_DOWN_		,.F.}) 	//OK   (Backup)
Aadd(aPath,{'\ARQ_TXT\TESOURARIA\Importacao\Itau\Retorno\'			 	,_UP_		,.T.})  //OK   (Backup)
Aadd(aPath,{'\ARQ_TXT\TESOURARIA\Importacao\Real ABN\'				 	,_UP_		,.T.})  //OK   (Backup)
//-----------------------------------------------------------------------------------------
Aadd(aPath,{'\ARQ_TXT\TESOURARIA\TED\'								 	,_DOWN_		,.F.}) 	//OK   (Backup)
//-----------------------------------------------------------------------------------------
Aadd(aPath,{'\ARQ_TXTRJ\ALMOXARIFADO\ReqMaterial\'					 	,_UP_		,.T.})  //OK   (Backup)
Aadd(aPath,{'\ARQ_TXTRJ\CONTABILIDADE\'								 	,_DOWN_		,.F.}) 	//OK   (Backup)
Aadd(aPath,{'\ARQ_TXTRJ\CONTABILIDADE\FFQ\'							 	,_UP_		,.T.})  //OK   (Backup)
//-----------------------------------------------------------------------------------------
Aadd(aPath,{'\ARQ_TXTRJ\TESOURARIA\Cnab\CartaoBB\'					 	,_DOWN_		,.F.}) 	//OK   (Backup)
Aadd(aPath,{'\ARQ_TXTRJ\TESOURARIA\Cnab\PagFor\'					 	,_DOWN_		,.F.}) 	//OK   (Backup)
Aadd(aPath,{'\ARQ_TXTRJ\TESOURARIA\Cnab\Sispag\'					 	,_DOWN_		,.F.}) 	//OK   (Backup)
Aadd(aPath,{'\ARQ_TXTRJ\TESOURARIA\Cnab\SispagBrasil\'				 	,_DOWN_		,.F.}) 	//OK   (Backup)
//----------------------------------------------------------------------------------------- 
Aadd(aPath,{'\ARQ_TXTRJ\TESOURARIA\Fiba\'							 	,_UP_		,.T.})  //OK   (Backup)
//-----------------------------------------------------------------------------------------  
Aadd(aPath,{'\ARQ_TXTRJ\TESOURARIA\Fluxo\'							 	,_DOWN_		,.F.}) 	//OK   (Backup)
//-----------------------------------------------------------------------------------------
Aadd(aPath,{'\ARQ_TXTRJ\TESOURARIA\Importacao\Banco do Brasil\'	 	 	,_UP_		,.T.})  //OK   (Backup)
Aadd(aPath,{'\ARQ_TXTRJ\TESOURARIA\Importacao\Banco do Brasil\Retorno\'	,_UP_		,.T.})  //OK   (Backup)
Aadd(aPath,{'\ARQ_TXTRJ\TESOURARIA\Importacao\Bradesco\'				,_UP_		,.T.})  //OK   (Backup)
Aadd(aPath,{'\ARQ_TXTRJ\TESOURARIA\Importacao\Bradesco\Retorno\'		,_UP_		,.T.})  //OK   (Backup)
Aadd(aPath,{'\ARQ_TXTRJ\TESOURARIA\Importacao\Itau\'					,_UP_		,.T.})  //OK   (Backup)
Aadd(aPath,{'\ARQ_TXTRJ\TESOURARIA\Importacao\Itau\Retorno\'			,_UP_		,.T.})  //OK   (Backup)
Aadd(aPath,{'\ARQ_TXTRJ\TESOURARIA\Importacao\Real ABN\'				,_UP_		,.T.})  //OK   (Backup)
//-----------------------------------------------------------------------------------------    
Aadd(aPath,{'\ARQ_TXTRJ\TESOURARIA\TED\'							 	,_DOWN_		,.F.}) 	//OK   (Backup)
//-----------------------------------------------------------------------------------------
Aadd(aPath,{'\IMAGENS\ATUALIZACAO\'							   			,_UP_		,.T.}) 	//OK   (Backup)
//-----------------------------------------------------------------------------------------

For nX:=1 to Len(aPath)
	cDirLocal:=aPath[nX,1]
	cDirFTP:=cDirIni+cDirLocal
	cDirFTP:=StrTran(cDirFTP,'\','/')
	
	//---------------------------------------------------------------
	// Verifica se o diretório existe na origem e destino
	//---------------------------------------------------------------
	lRet1:=FTPDirChange(cDirFTP)
	If !lRet1
		_cLog+="Endereço FTP < "+cDirFTP+" > não existe."+CRLF
		lErro:=.T.
	EndIf
	lRet2:=ExistDir(cDirLocal)
	If !lRet2
		_cLog+="Endereço Local < "+cDirLocal+" > não existe."+CRLF
		lErro:=.T.
	EndIF
	If !lRet1 .Or. !lRet2
		Loop
	EndIF
	
	aFiles:={}
	If aPath[nX,2]==_UP_//UpLoad
		aFiles:=Directory(cDirLocal+'*.*')
		For nY:=1 to Len(aFiles)
			cDrive:='';cDiretorio:='';cNome:='';cExtensao:=''
			SplitPath(cDirLocal+aFiles[nY,1], @cDrive, @cDiretorio, @cNome, @cExtensao)
			//File Local , File FTP
			If !FtpUpload(cDiretorio+cNome+cExtensao,cNome+cExtensao )
				_cLog+="Falha no UPLOAD para < "+cDirFTP+" > ."+CRLF
				lErro:=.T.
			Else
				//If aPath[nX,3]
				If 	__CopyFile(cDiretorio+cNome+cExtensao , cDiretorio+'backup\'+cNome+cExtensao)
					FErase(cDiretorio+cNome+cExtensao)
				EndIF
			EndIF
			lFez:=.T.
		Next nY
		
	Else//Download
		aFiles:=FTPDirectory ('*.*')
		For nY:=1 to Len(aFiles)
			cDrive:='';cDiretorio:='';cNome:='';cExtensao:=''
			//IF aFiles[nY,3] > dDtCorte//Só copia os arquivos recentes
				SplitPath(aFiles[nY,1], @cDrive, @cDiretorio, @cNome, @cExtensao)
				
				//File Local , File FTP
				If !FTPDownload ( cDirLocal+cNome+cExtensao , aFiles[nY,1] )
					_cLog+="Falha no DOWNLOAD para < "+cDirLocal+" > ."+CRLF
					lErro:=.T.
				Else
					If lDir:=FTPDirChange(cDirFTP+'backup/')//-- Vai jogar o arquivo que baixou para a pasta de backup do FTP
						If FtpUpload(cDirLocal+cNome+cExtensao,cNome+cExtensao )//Local -> FTP
							If lDir:=FTPDirChange(cDirFTP)//fez upload para backup entao apaga na origem do FTP
								FTPErase(aFiles[nY,1])
							EndIf
						EndIf
						If !lDir
							_cLog+="Falha na mudança de pastas  < "+cDirFTP+" > ."+CRLF
							lErro:=.T.
							Exit
						EndIf
					EndIf
				EndIF
				lFez:=.T.
			//EndIf
		Next nY
	EndIF
	
Next nX

FTPDISCONNECT()

If !lErro
	_cLog+='Processamento sem inconsistências.'
EndIf
_cLog+=CRLF+'FIM DO LOG.'
UnLockByName("FTPCiee")

If !_lJob
	MostraText(_cLog)
EndIF
//If lFez
//	EnvMail(_cLog)
//EndIf
If _lJob
	RpcClearEnv()
EndIf

Return


/*------------------------------------------------------------------------------
*
* MostraText()
* Mostra o log do processamento
*
------------------------------------------------------------------------------*/
Static Function MostraText(cTexto)

Local oDlg, oMemo, oFont
Local cFile:=''
Local cMask:="Arquivos Texto (*.TXT) |*.txt|"

__cFileLog := MemoWrite(Criatrab(,.f.)+".LOG",cTexto)
DEFINE FONT oFont NAME "Mono AS" SIZE 5,12   //6,15
DEFINE MSDIALOG oDlg TITLE '' From 3,0 to 340,417 PIXEL
@ 5,5 GET oMemo  VAR cTexto MEMO SIZE 200,145 OF oDlg PIXEL
oMemo:bRClicked := {||AllwaysTrue()}
oMemo:oFont:=oFont

DEFINE SBUTTON  FROM 153,175 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga
DEFINE SBUTTON  FROM 153,145 TYPE 13 ACTION (cFile:=cGetFile(cMask,""),If(cFile="",.t.,MemoWrite(cFile,cTexto))) ENABLE OF oDlg PIXEL //Salva e Apaga //"Salvar Como..."

ACTIVATE MSDIALOG oDlg CENTER
Return


/*------------------------------------------------------------------------------
*
* EnvMail()
*
------------------------------------------------------------------------------*/
Static Function EnvMail(cTexto)

Local lResult	:=.T.
Local cMsg 		:=''
Local lHomolog	:= Iif('HOMOLOG'$Upper(GetEnvServer()),.T.,.F.)
Local cServer  	:= Trim(GetMV("MV_RELSERV")) // smtp
Local cEmail   	:= "wfmicrosiga@cieesp.org.br"
Local cPass    	:= "microsiga"
Local cPara	 	:= "sistemas@cieesp.org.br"
Local cAssunto 	:= 'LOG DE INTEGRAÇÃO FTP DATACENTER TOTVS'

If lHomolog
	cAssunto:='TESTE - '+cAssunto
EndIf

cMsg :="Ambiente: "+GetEnvServer()+CRLF
cMsg +="Data: "+DtoC(Date())+CRLF
cMsg +="Hora: "+Time()+CRLF
cMsg +=Repl('- ',30)+CRLF
cMsg +=CRLF+cTExto

CONNECT SMTP SERVER cServer ACCOUNT cEmail PASSWORD cPass RESULT lResult

If lResult
	SEND MAIL FROM cEmail TO cPara SUBJECT cAssunto BODY cMsg RESULT lResult
Endif

DISCONNECT SMTP SERVER

Return