#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "AP5MAIL.CH"

Static _lIsIntSOC:=.F.
Static _cNumNF	 :=''
Static _cSerNF	 :=''

/*
+-----------+-------------+-----------+----------------+------+-------------+
| Programa  | u_CIIntSOC  | Autor     | Fabio Zanchim  | Data |    07/2013  |
+-----------+-------------+-----------+----------------+------+-------------+
| Descricao | Integração SOC x Protheus                              		|
|           | 														 		|
+-----------+---------------------------------------------------------------+
| Uso       | CIEE   														|
+-----------+---------------------------------------------------------------+
*/
User Function CIIntSOC()

Local nTentativa:=0
Local lLock:=.F.
Private _lJob := IIf(GetRemoteType() == -1, .T., .F.) 

If _lJob                           
	//Nao processa antes das 22:00 e nem depois das 06:00
	If !(Substr(Time(),1,2)$"22/23/24/00/01/02/03/04/05/")
		Return
	EndIf

	RpcSetType(3)
	RpcSetEnv('01','01')
Else
	If !ApMsgYesNo('Confirma início da integração Soc x Protheus ?')
		Return
	EndIf
EndIf

While nTentativa<=3
	If !LockByName("CIIntSOC")
		nTentativa++
		If _lJob
			Conout("Integração SOC em processamento [Tentativa "+Str(nTentativa,1)+"]...")
			Sleep(7000)//7 Segundos
			Loop
		Else
			Aviso( "CIIntSOC", "Integração SOC em processamento.", {"Ok"}, 2)
			Return
		EndIF
	Else
		lLock:=.T.
		Exit
	EndIf
EndDo
If !lLock
	If _lJob
		RpcClearEnv()
	EndIf
	Return
EndIf
                         
If _lJob
	CIIntProc()
Else
	Processa( {|| CIIntProc()}, "Aguarde...","Importando arquivos SOC...", .F. )
EndIf

UnLockByName("CIIntSOC")

If _lJob
	RpcClearEnv()
EndIf



Return


Static Function CIIntProc()

Local lErroCli:=.F.
Local lErros2:=.F.
Local aArqs:={}
Local nX:=0
Local cPathArq:='\arq_txt\fiscal\importacao\'
Local lErroEstr:=.F.       

Private cStartPath:=alltrim(GetSrvProfString("Startpath",""))
Private cPV_Sem_NF:=''

//Pega todos os arquivos (Clientes e Pedidos)
aArqs:=Directory(cPathArq+"*.txt")

If !_lJob
	ProcRegua(Len(aArqs))
EndIf

//Importa Clientes
For nX:=1 to Len(aArqs)
	If Upper(Substr(aArqs[nX,1],1,3)) =='CLI'
		If !_lJob
			IncProc(aArqs[nX,1]+ ' ...' )
		EndIf
		
		lErroCli:=CIImpCli(cPathArq,aArqs[nX,1])
		If lErroCli
			lErros2:=.T.
		EndIf
	EndIf
Next nX

//Importa Pedidos
//If !lErros2 .and. Len(aArqs)>0
If Len(aArqs)>0
	
	
	//Limpa tabela de Log dos Pedidos 
	TcSqlExec('Delete From '+RetSqlName('PAF'))
	
	lErroEstr:=.F.       
	
	ConOut('Job Pedidos Inicio '+Dtoc(Date())+' '+ Time())
	
	For nX:=1 to Len(aArqs)
		If Upper(Substr(aArqs[nX,1],1,3)) =='PED'
			If !_lJob
				IncProc(aArqs[nX,1]+ ' ...' )
			EndIf
			
			lErroEstr:=CIImpPed(cPathArq,aArqs[nX,1])
		EndIf
	Next nX                                            
	
	ConOut('Job Pedidos Fim '+Dtoc(Date())+' '+ Time())

	If !lErroEstr
		// Cria lista de RPSs incluidos/inconsistentes
		lErros2:=fCriaLog(cPV_Sem_NF)
	Else
		lErros2:=.T.
	EndIf

EndIf

If !_lJob
	If Len(aArqs)>0
		IF lErros2 .Or. lErroCli
			Aviso( "CIIntSOC", "Houveram inconsistencias na importação de Clientes/RPS, verifique os logs do sistema.", {"Ok"}, 2)
		EndIf
	Else
		Aviso( "CIIntSOC", "Não há arquivos para importação.", {"Ok"}, 2)
	EndIf   
EndIf

If lErros2 .Or. lErroCli
	fEnvMail(lErroEstr,cPV_Sem_NF)
EndIf

Return()


/*
+-----------+-------------+-----------+----------------+------+-------------+
| Programa  | u_CIInpCli  | Autor     | Fabio Zanchim  | Data |    07/2013  |
+-----------+-------------+-----------+----------------+------+-------------+
| Descricao | Importa Clientes do SOC                                       |
|           | 														 		|
+-----------+---------------------------------------------------------------+
| Uso       | CIEE   														|
+-----------+---------------------------------------------------------------+
*/
Static Function CIImpCli(cPathArq,_cArquivo)

Local _nOpc		:=0
Local _cLin		:=''
Local _cCNPJ	:=''
Local _cCod		:=''
Local _cLoj		:=''
Local cNomeLog	:=''
Local nContLog	:=0
Local aMATA030 	:= {}

Local cDrive 	:=''
Local cDiretorio:=''
Local cNome   	:=''
Local cExtensao :=''
Local nStack	:=0 
Local nLenCNPJ:=Len(SA1->A1_CGC)

Private lMsErroAuto:=.F.

SplitPath(_cArquivo, @cDrive, @cDiretorio, @cNome, @cExtensao)

Ft_FUse(cPathArq+_cArquivo)
While !FT_FEof()
	_cLin:=FT_FReadLn()
	If Empty(_cLin)//ultima linha
		FT_FSkip()
		Loop
	EndIf
	_cLin:=Iif(Substr(_cLin,Len(_cLin),1)=='|',Substr(_cLin,1,Len(_cLin)-1),_cLin)//Remove Pipe do final
	
	_cCNPJ:=Alltrim(RetCpo(_cLin,14))
	_cCNPJ:=PadR(_cCNPJ,nLenCNPJ)
	
	dbSelectArea('SA1')
	dbSetOrder(3)
	If dbSeek(xFilial('SA1')+_cCNPJ)
		_nOpc:=4
		_cCod:=A1_COD
		_cLoj:=A1_LOJA
	Else
		_nOpc:=3      
	EndIf
	
	If ( Empty(RetCpo(_cLin,16))  .And. Alltrim(RetCpo(_cLin,8))=='50308') .Or. Empty(RetCpo(_cLin,19)) //Incr. Municipal de SP e CEP
		If Empty(RetCpo(_cLin,19))//CEP
			AutoGrLog('CEP invalido para o CNPJ '+_cCNPJ)
		EndIf
		If Empty(RetCpo(_cLin,16))
			AutoGrLog('Incricao Municipal nao foi informada para o CNPJ '+_cCNPJ)
		EndIF

		nContLog++
		cNomeLog:=NomeAutoLog()
//		__CopyFile( cStartPath+cNomeLog , cPathArq+'log\'+cNome+'_log_'+StrTran(Time(),':','')+'.txt')
		__CopyFile( cStartPath+cNomeLog , cPathArq+'log\'+cNome+'_log_'+_cCNPJ+'.txt')
		FErase(cStartPath+cNomeLog)
		
		FT_FSkip()
		Loop
	EndIf
	
	aMATA030:={}
	If _nOpc==4
		Aadd(aMATA030,{"A1_COD"       ,_cCod          	,Nil})
		Aadd(aMATA030,{"A1_LOJA"      ,_cLoj          	,Nil})
	EndIf
	Aadd(aMATA030,{"A1_NOME"      ,Alltrim(RetCpo(_cLin,1))	,Nil})
	Aadd(aMATA030,{"A1_PESSOA"    ,RetCpo(_cLin,2)	,Nil})
	Aadd(aMATA030,{"A1_NREDUZ"    ,RetCpo(_cLin,3)	,Nil})
	Aadd(aMATA030,{"A1_TIPO"      ,RetCpo(_cLin,4)	,Nil})
	Aadd(aMATA030,{"A1_TPCLI"     ,RetCpo(_cLin,5)	,Nil})
	Aadd(aMATA030,{"A1_END"       ,RetCpo(_cLin,6)	,Nil})
	Aadd(aMATA030,{"A1_EST"       ,RetCpo(_cLin,7)	,Nil})
	Aadd(aMATA030,{"A1_COD_MUN"   ,RetCpo(_cLin,8) 	,Nil})
	Aadd(aMATA030,{"A1_COMPLEM"   ,RetCpo(_cLin,9)	,Nil})
	Aadd(aMATA030,{"A1_BAIRRO"   ,RetCpo(_cLin,10)	,Nil})
	Aadd(aMATA030,{"A1_CODPAIS"  ,RetCpo(_cLin,11)	,Nil})
	Aadd(aMATA030,{"A1_DDD"   	,RetCpo(_cLin,12)	,Nil})
	Aadd(aMATA030,{"A1_TEL"   	,RetCpo(_cLin,13)	,Nil})
	Aadd(aMATA030,{"A1_CGC"		,Alltrim(RetCpo(_cLin,14)),Nil})
	Aadd(aMATA030,{"A1_INSCR"	,RetCpo(_cLin,15)	,Nil})
	Aadd(aMATA030,{"A1_INSCRM"	,RetCpo(_cLin,16)	,Nil})
	Aadd(aMATA030,{"A1_RECISS"	,RetCpo(_cLin,18)	,Nil})
	Aadd(aMATA030,{"A1_CEP"		,StrTran(RetCpo(_cLin,19),'-','')	,Nil})
		
		//{"A1_EMAIL"		,RetCpo(_cLin,17)	,Nil},;
	
	lMsErroAuto:=.F.
	MSExecAuto({|x,y| mata030(x,y)},aMATA030,_nOpc)
	
	If lMsErroAuto
		nContLog++
		cNomeLog:=NomeAutoLog()
//		__CopyFile( cStartPath+cNomeLog , cPathArq+'log\'+cNome+'_log_'+StrTran(Time(),':','')+'.txt')
		__CopyFile( cStartPath+cNomeLog , cPathArq+'log\'+cNome+'_log_'+_cCNPJ+'.txt')
		FErase(cStartPath+cNomeLog)
	EndIf
	
	FT_FSkip()
End
Ft_FUse()

If __CopyFile(cPathArq+_cArquivo , cPathArq+'backup\'+_cArquivo)
	FErase(cPathArq+_cArquivo)
EndIf

If nContLog>0
	If !_lJob
		//Aviso( "CIIntSOC", "Houveram inconsistencias na importação dos Clientes, verifique os logs do sistema.", {"Ok"}, 2)
	EndIf
EndIf

Return(nContLog>0)

/*
+-----------+-------------+-----------+----------------+------+-------------+
| Programa  | u_CIImpPed  | Autor     | Fabio Zanchim  | Data |    07/2013  |
+-----------+-------------+-----------+----------------+------+-------------+
| Descricao | Importa RPS do SOC como um Pedido de Venda no Protheus        |
|           | 														 		|
+-----------+---------------------------------------------------------------+
| Uso       | CIEE   														|
+-----------+---------------------------------------------------------------+
*/
Static Function CIImpPed(cPathArq,_cArquivo)

Local aCabPV	:={}
Local aItemPV 	:={}
Local cItemPV	:=StrZero(1,Len(SC6->C6_ITEM))
Local nQ		:=0
Local _cRPS_SOC :=''
Local lErroStru	:=.F.
Local lVerifica	:=.T.
Local aThreads 	:= {}
Local nContThread:=0
Local cDrive 	:=''
Local cDiretorio:=''
Local cNome   	:=''
Local cExtensao :=''

Local lCabec:=.T.
Local lItem:=.F.
Local cTES:=AllTrim(GetNewPar("MV_XTESSOC"," "))
Local cCond:=AllTrim(GetNewPar("MV_XCONSOC"," "))
Local cProd:=AllTrim(GetNewPar("MV_XPRDSOC"," "))
Local nLenCNPJ:=Len(SA1->A1_CGC)	
Local nLenThreads:=0
Local lIncNota:=.T.

Private lMsErroAuto:=.F.

SplitPath(_cArquivo, @cDrive, @cDiretorio, @cNome, @cExtensao)

//Valida se arquivo esta integro, com Cabec e Item
Ft_FUse(cPathArq+_cArquivo)
FT_FGOTOP()
lCabec:=.T.
lItem:=.F.
While !FT_FEof() .And. !lErroStru
	_cLin:=FT_FReadLn()
	
	cIni:=RetCpo(_cLin,1)
	If Empty(cIni)
		FT_FSkip()
		Loop
	EndIf
	
	If lCabec .And. Alltrim(cIni)<>'C'//Identificador nao é de Cabeçalho
		lErroStru:=.T.
		Loop
	EndIf
	
	If lItem .And. Alltrim(cIni)<>'I'
		lErroStru:=.T.
		Loop
	EndIf
	
	lCabec:=!lCabec
	lItem:=!lItem
	
	FT_FSkip()
End

//Problema na estrutura do arquivo
If lErroStru
	AutoGrLog('Problema na estrutura do arquivo '+cNome+CRLF+'Nenhum item foi processado.')
	cNomeLog:=NomeAutoLog()
	__CopyFile( cStartPath+cNomeLog , cPathArq+'log\'+cNome+'_log_'+StrTran(Time(),':','')+'.txt')
	FErase(cStartPath+cNomeLog)
EndIf

FT_FGOTOP()  
//__nContador:=0
While !FT_FEof() .And. !lErroStru
	//__nContador++
	//Conout('contador A'+Str(__nContador))
	
	_cLin:=FT_FReadLn()
	If Empty(_cLin)
		FT_FSkip()
		Loop
	EndIf
	
	_cLin:=Iif(Substr(_cLin,Len(_cLin),1)=='|',Substr(_cLin,1,Len(_cLin)-1),_cLin)//Remove Pipe do final
	
	_cRPS_SOC:=RetCpo(_cLin,2)			//RPS no sistema SOC
	//_cRPS_SOC:="Y"+sUBSTR(RetCpo(_cLin,2),2,8)
	dbSelectArea('SC5')
	dbOrderNickName('XRPSSOC')
	If dbSeek(xFilial('SC5')+_cRPS_SOC)
	      
		//12/09 Cristiano - Quando RPS ja existir, simplesmente desconsidera a linha do arquivo, nao gera log
		
		//fInputLog(_cRPS_SOC,'N')
		
		//AutoGrLog('RPS SOC '+_cRPS_SOC+' ja incluido.')
		
		//cNomeLog:=NomeAutoLog()
		//__CopyFile( cStartPath+cNomeLog , cPathArq+'log\'+cNome+'_log_'+_cRPS_SOC+'.txt')
		//FErase(cStartPath+cNomeLog)
		FT_FSkip()//Pula pro Item
		FT_FSkip()//Pula o Item e vai para o próximo RPS
		Loop
	EndIf

	_cCNPJ:=Alltrim(RetCpo(_cLin,3))
	_cCNPJ:=PadR(_cCNPJ,nLenCNPJ)
	dbSelectArea('SA1')
	dbSetOrder(3)
	If !dbSeek(xFilial('SA1')+_cCNPJ)

		fInputLog(_cRPS_SOC,'N',_cCNPJ)

		AutoGrLog('RPS SOC '+_cRPS_SOC+':'+CRLF+'Cliente não localizado, CNPJ: '+_cCNPJ)
		cNomeLog:=NomeAutoLog()
		__CopyFile( cStartPath+cNomeLog , cPathArq+'log\'+cNome+'_log_'+_cRPS_SOC+'.txt')
		FErase(cStartPath+cNomeLog)
		FT_FSkip()//Pula pro Item
		FT_FSkip()//Pula o Item e vai para o próximo RPS
		Loop
	EndIf
	
	//Veririca se Municipio de Prest. do servico existe
	dbSelectArea('CC2')
	dbSetOrder(1)
	If dbSeek(xFilial('CC2')+RetCpo(_cLin,5)+RetCpo(_cLin,6))
		lIncNota:=.T.
	Else
		lIncNota:=.F.//Inclui somente o Pedido (nao fatura)
		cPV_Sem_NF +=(_cRPS_SOC + CRLF)
	EndIf	
	
	aCabPV:={}
	Aadd(aCabPV,{"C5_TIPO"  ,"N"       	,Nil})
	Aadd(aCabPV,{"C5_CLIENTE",SA1->A1_COD ,Nil})
	Aadd(aCabPV,{"C5_LOJACLI",SA1->A1_LOJA   	,Nil})
	Aadd(aCabPV,{"C5_EMISSAO",dDatabase		,Nil})
	Aadd(aCabPV,{"C5_CONDPAG",PAdR(cCond,3)  ,Nil})
	Aadd(aCabPV,{"C5_MENNOTA",RetCpo(_cLin,4),Nil})
	If lIncNota
		Aadd(aCabPV,{"C5_ESTPRES",RetCpo(_cLin,5),Nil}) // Estado da Prest. do Servico
		Aadd(aCabPV,{"C5_MUNPRES",RetCpo(_cLin,6),Nil}) // Municipio da Prest. do Servico
	EndIf
	Aadd(aCabPV,{"C5_PESOL", 1				,Nil})
	Aadd(aCabPV,{"C5_PBRUTO",1				,Nil})
	Aadd(aCabPV,{"C5_INCISS" ,"N"    	   	,Nil}) // ISS Incluso
	Aadd(aCabPV,{"C5_MOEDA"  ,1        	 	,Nil}) // Moeda
	Aadd(aCabPV,{"C5_XRPSSOC",_cRPS_SOC		,Nil})  // Identificação no SOC (RPS)
			
	FT_FSkip()//Vai para o Item
	_cLin:=FT_FReadLn()
	_cLin:=Iif(Substr(_cLin,Len(_cLin),1)=='|',Substr(_cLin,1,Len(_cLin)-1),_cLin)//Remove Pipe do final
	
	//Items
	aItemPV:={{"C6_ITEM" ,cItemPV  							,Nil},; // Numero do Item no Pedido
			{"C6_PRODUTO",cProd		 						,Nil},; // Codigo do Produto
			{"C6_QTDVEN" ,fStrToVal(RetCpo(_cLin,2),7,2)    ,Nil},; // Quantidade Vendida
			{"C6_PRUNIT" ,fStrToVal(RetCpo(_cLin,3),10,4)   ,Nil},; // PRECO DE LISTA
			{"C6_PRCVEN" ,fStrToVal(RetCpo(_cLin,3),10,4)   ,Nil},; // Preco Unitario Liquido
			{"C6_VALOR"  ,fStrToVal(RetCpo(_cLin,4),10,2)   ,Nil},; // Valor Total do Item
			{"C6_ENTREG" ,dDataBase         				,Nil},; // Data da Entrega    
			{"C6_QTDLIB" ,fStrToVal(RetCpo(_cLin,2),7,2)   	,Nil}}  // Quantidade Liberada
//			{"C6_TES"    ,cTES           					,Nil},; // Tipo de Entrada/Saida do Item				
				

	// Verifica quantos processamentos paralelos ja estão ativos 
	lVerifica:=_lJob
	While lVerifica
		aThreads 	:= GetUserInfoArray()//Fabio - verificar se tem balance, se sim, configurar o Job no Ini de determinado server para conseguir controlar as threads
		nContThread	:=0    
		nLenThreads:=Len(aThreads)
		For nQ:=1 to nLenThreads
			If "U_INCPVSOC"$Upper(Alltrim(aThreads[nQ,5]))
				nContThread++
			EndIf
		Next nQ
		If nContThread < 8//Deixa processar no maximo 8 threads paralelas
			lVerifica:=.F.
		EndIF
		If lVerifica
			//Conout('[ CiIntSOC - '+Dtoc(dDataBase)+' - '+Time()+' ] - Aguardando finalização dos processos paralelos de U_INCPVSOC...')
			//Conout('[ CiIntSOC - '+Dtoc(dDataBase)+' - '+Time()+' ] - Maximo de threads permitidas = 4  /  Em processamento = '+Alltrim(Str(nContThread)))
			Sleep(3000) //Aguarda 5 segundos
		EndIF
	End
	
	//Inclui Pedido, Libera e Fatura
	If _lJob
		StartJob('u_INCPvSoc', GetEnvServer(), .F. , {aCabPv,{aItemPV},cStartPath,cPathArq,cNome,_cRPS_SOC,.T.,lIncNota,_cCNPJ} )
	Else 
		u_INCPvSoc({aCabPv,{aItemPV},cStartPath,cPathArq,cNome,_cRPS_SOC,.F.,lIncNota,_cCNPJ})
	EndIF
	
	FT_FSkip()
End
Ft_FUse()
                           
//Aguarda finalziar o processamento para mover o arquivo
lVerifica:=_lJob
While lVerifica
	Sleep(7000)//Ainda esta processando ou subindo a thread quando entra aqui a primeira vez
	aThreads 	:= GetUserInfoArray()
	nContThread	:=0
	For nQ:=1 to Len(aThreads)
		If "U_INCPVSOC"$Upper(Alltrim(aThreads[nQ,5]))
			nContThread++
		EndIf
	Next nQ
	If nContThread == 0
		lVerifica:=.F.
	EndIF
End
If __CopyFile(cPathArq+_cArquivo , cPathArq+'backup\'+_cArquivo)
	FErase(cPathArq+_cArquivo)
EndIf

Return(lErroStru)

User Function INCPvSoc(_aParam)

Local _aCab		 :=_aParam[1]
Local _aItens	 :=_aParam[2]
Local _cStartPath:=_aParam[3]
Local _cPathArq	 :=_aParam[4]
Local _cNome	 :=_aParam[5]
Local _cRPS_SOC	 :=_aParam[6]
Local _lJob		 :=_aParam[7]
Local _lIncNota	 :=_aParam[8]
Local _cCNPJ	 :=_aParam[9]
Local _cNomeLog	 :=''
Local aPvlNfs	 :={}
Local nRecSc9 	:=0
Local _cNotaInc	:=''
Local lTentando:=.T.
Local nVezes:=0

Private lMsErroAuto:=.F.

If _lJob
	RpcSetType(3)
	RpcSetEnv('01','01','Siga','2205','FAT')
EndIF
                          
//--------------------------------
// Inclui o Pedido de Venda
//--------------------------------
dbSelectArea('SC5')
dbOrderNickName('XRPSSOC')
If dbSeek(xFilial('SC5')+_cRPS_SOC)
     
	//12/09 Cristiano - Quando RPS ja existir, simplesmente desconsidera a linha do arquivo, nao gera log
	//fInputLog(_cRPS_SOC,'N')
	
	//AutoGrLog('RPS SOC '+_cRPS_SOC+' ja incluido.')
	
	//_cNomeLog:=NomeAutoLog()
	//__CopyFile( _cStartPath+_cNomeLog , _cPathArq+'log\'+_cNome+'_log_'+_cRPS_SOC+'.txt')
	//FErase(_cStartPath+_cNomeLog)
	
	lMsErroAuto:=.T.
Else

	MSExecAuto({|x,y,z|Mata410(x,y,z)},_aCab,_aItens,3)
	
	If lMsErroAuto
        
		//Solução para erro RELDIRR com Pedido de Venda incluído
		dbSelectArea('SC5')
		dbOrderNickName('XRPSSOC')
		If dbSeek(xFilial('SC5')+_cRPS_SOC)
			lMsErroAuto:=.F.
			If !_lIncNota//Nao inclui nota mas pedido Ok
				fInputLog(_cRPS_SOC,'S',_cCNPJ)	
			EndIf
		Else
			fInputLog(_cRPS_SOC,'N',_cCNPJ)
			_cNomeLog:=NomeAutoLog()
			__CopyFile( _cStartPath+_cNomeLog , _cPathArq+'log\'+_cNome+'_log_'+_cRPS_SOC+'.txt')
			FErase(_cStartPath+_cNomeLog)
		EndIf
	Else
		If !_lIncNota//Nao inclui nota mas pedido Ok
			fInputLog(_cRPS_SOC,'S',_cCNPJ)	
		EndIf
	EndIf
EndIf
If !lMsErroAuto .And. _lIncNota
	//Liberação do Pedido
	dbSelectArea('SC6')
	SC6->(dbSetOrder(1))
	SC6->( DbSeek( xFilial('SC6')+SC5->C5_NUM ) )
	dbSelectArea('SC9')
	SC9->(dbSetOrder(1))
	If SC9->( DbSeek( xFilial('SC9')+SC5->C5_NUM + SC6->C6_ITEM ) )
		While SC9->(!Eof()) .And. SC9->C9_FILIAL == xFilial('SC9') .And. SC9->C9_PEDIDO == SC5->C5_NUM
			nRecSc9 := SC9->(Recno())
			If !( (Empty(SC9->C9_BLCRED) .And. Empty(SC9->C9_BLEST)) .Or.;
				(SC9->C9_BLCRED=="10" .And. SC9->C9_BLEST=="10") .Or. SC9->C9_BLCRED=="09" )
				a450Grava(1,.T.,.T.,.F.)//Libera
			EndIf
			SC9->(MsGoto(nRecSc9))
			SC9->(dbskip())
		EndDo
	EndIf
	
	// Preparacao do array com itens a serem faturados
	SB1->(DbSetOrder(1))
	SB2->(DbSetOrder(1))
	SF4->(DbSetOrder(1))
	SC5->(DbSetOrder(1))
	SC5->(DbSeek( xFilial('SC5')+SC5->C5_NUM ))
	SE4->(DbSetOrder(1))
	SE4->(DbSeek(xFilial('SE4')+SC5->C5_CONDPAG) )
	SC6->(DbSetOrder(1) )
	SC6->(DbSeek( xFilial('SC6')+SC5->C5_NUM ) )
	
	aPvlNfs:={}
	While SC6->( !Eof() ) .And. SC6->( C6_FILIAL + C6_NUM ) = xFilial('SC5')+SC5->C5_NUM
		If SC9->( DbSeek( xFilial('SC9')+SC5->C5_NUM + SC6->C6_ITEM ) )  //FILIAL+NUMERO+ITEM
			SB1->(DbSeek(xFilial('SB1')+SC9->C9_PRODUTO) )               //FILIAL+PRODUTO
			SB2->(DbSeek(xFilial('SB2')+SC9->(C9_PRODUTO+C9_LOCAL)) )    //FILIAL+PRODUTO+LOCAL
			SF4->(DbSeek(xFilial('SF4')+SC6->C6_TES) )                //FILIAL+CODIGO
			
			aAdd(aPvlNfs,{ SC9->C9_PEDIDO,SC9->C9_ITEM,SC9->C9_SEQUEN,SC9->C9_QTDLIB,;
						SC9->C9_PRCVEN,SC9->C9_PRODUTO,SF4->F4_ISS=='S',SC9->(RecNo()),;
						SC5->(RecNo()),SC6->(RecNo()),SE4->(RecNo()),SB1->(RecNo()),;
						SB2->(RecNo()),SF4->(RecNo()),SB2->B2_LOCAL,0,SC9->C9_QTDLIB2})
		EndIf
		SC6->( dbSkip() )
	EndDo
	                              
	//--------------------------------	                                        
	// Staticas para M460NUM.prw
	//--------------------------------
	_lIsIntSOC:=.T.
	_cSerNF :=PadR("RPS",Len(SF2->F2_SERIE))
	_cNumNF	:=_cRPS_SOC               
	
	//--------------------------------
	// Inclui a nota                   
	//--------------------------------
	_cNotaInc	:= MaPvlNfs(aPvlNfs,_cSerNF, .F., .F., .F., .F., .F., 0, 0, .F., .F.,,,)
	_lIsIntSOC:=.F.
		
	dbSelectArea('SF2')
	SF2->(dbSetOrder(1))
	If dbSeek(xFilial('SF2')+PadR(_cNotaInc,Len(SF2->F2_DOC))+_cSerNF)
		fInputLog(_cRPS_SOC,'S',_cCNPJ)
	Else
		//Nao conseguiu faturar
		//Tenta fazer a inclusao novamente 
		//If nVezes==0
		//	nVezes++
		//	Sleep(500)
		//	Loop
		//EndIf
			//lTentando:=.F.
		
		fInputLog(_cRPS_SOC,'N',_cCNPJ)
	EndIf         

EndIF
If _lJob
	RpcclearEnv()
EndIf

Return
       
/*------------------------------------------------------------------------
* Informa ao M460Num que é processo de integração SOC
------------------------------------------------------------------------*/
User Function IsIntSoc()
Return(_lIsIntSOC)
        

/*------------------------------------------------------------------------
* Devolve numero e Serie da NF para P.E. M460NUM
------------------------------------------------------------------------*/
User Function GetSerNF()
Return({_cNumNF,_cSerNF})


/*--------------------------------------------------------------------------
* Transforma em numerico a string
--------------------------------------------------------------------------*/
Static Function fStrToVal(cVal,nInt,nDec)
cVal:=Substr(cVal,1,nInt)+'.'+Substr(cVal,nInt+1,nDec)
Return(Val(cVal))


/*------------------------------------------------------------------------
* Retorna campo de determinada linha na posição desejada
------------------------------------------------------------------------*/
Static Function RetCpo(cString,nPos)

Local nX:=0
Local nPosAnt:=0
Local nContPos:=0
Local cCpo:=""

For nX:=1 to Len(cString)
	
	If Substr(cString,nX,1)=='|' .Or. nX==(Len(cString))
		nContPos++
		If nContPos==nPos-1
			nPosAnt:=nX//Posicao inicial da posicao a ser pega
		EndIf
		If nContPos==nPos
			If nX==(Len(cString))//Esta pegando ultimo campo da linha
				cCpo:=Substr(cString,nPosAnt+1,nX-nPosAnt)
				Exit
			Else
				cCpo:=Substr(cString,nPosAnt+1,nX-nPosAnt-1)
				Exit
			EndIf
		EndIf
	EndIf
	
Next nX

Return(cCpo)

/*--------------------------------------------------------------------------
* Envia Email de erro de processamento
--------------------------------------------------------------------------*/
Static Function fEnvMail(lErroEstr,cPV_Sem_NF)

Local lResult	:=.T.
Local cMsg 		:=''
Local lHomolog	:= Iif('HOMOLOG'$Upper(GetEnvServer()),.T.,.F.)
Local cServer  	:= Trim(GetMV("MV_RELSERV")) // smtp
Local cEmail   	:= "wfmicrosiga@cieesp.org.br"
Local cPass    	:= "microsiga"
Local cPara	 	:= GetNewPar("MV_XMSGSOC"," ")
Local cAssunto 	:= "Inconsistencia na importação do RPS SOC"
                                  
Default lErroEstr:=.F.

If lHomolog
	cAssunto:='TESTE - '+cAssunto
EndIf
                                                
If lErroEstr
	cMsg := Repl('- ',30)+CRLF
	cMsg +="PROBLEMAS NA ESTRUTURA DOS ARQUIVOS. Verifique os logs do sistema em \arq_txt\fiscal\Importacao\Log\"+CRLF
Else
	cMsg := Repl('- ',30)+CRLF
	cMsg += "Houveram inconsistencias  na importação do Cliente/RPS SOC, verifique os logs do sistema em \arq_txt\fiscal\Importacao\Log\"+CRLF
EndIf
                      
If !Empty(cPV_Sem_NF)
	cMsg +=CRLF
	cMsg +=Repl('- ',30)+CRLF
	cMsg +="Houveram Pedidos não faturados, devido a falta do código do munícipio de prestação de serviço."+CRLF
	cMsg +="RPS pendente de faturamento no Protheus :"+CRLF
	cMsg +=cPV_Sem_NF+CRLF
EndIf                
cMsg +=Repl('- ',30)+CRLF
cMsg +="Ambiente: "+GetEnvServer()+CRLF
cMsg +="Data: "+DtoC(Date())+CRLF
cMsg +="Hora: "+Time()+CRLF
cMsg +=Repl('- ',30)+CRLF

CONNECT SMTP SERVER cServer ACCOUNT cEmail PASSWORD cPass RESULT lResult

If lResult
	SEND MAIL FROM cEmail TO cPara CC "sistemas@cieesp.org.br" SUBJECT cAssunto BODY cMsg RESULT lResult
Endif

DISCONNECT SMTP SERVER

Return
                      
/*------------------------------------------------------------------
* Inclui Registro do log dos RPS incluidos ou nao
------------------------------------------------------------------*/
Static Function fInputLog(_cRPS_SOC,cProc,cCNPJ)

dbSelectArea('PAF')
dbSetOrder(1)        
If !dbSeek(xFilial('PAF')+_cRPS_SOC)
	RecLock('PAF',.T.)
	PAF_FILIAL:=xFilial('PAF')
	PAF_RPSSOC:=_cRPS_SOC
	PAF_PROC:=cProc
	PAF_CNPJ:=cCNPJ
	msUnLock()
EndIf
Return

/*------------------------------------------------------------------
* Lista os RPSs gerados
------------------------------------------------------------------*/
Static Function fCriaLog(cPV_Sem_NF)
Local cPathArq	:='\arq_txt\fiscal\exportacao\'
Local cArq		:=cPathArq+'CONF_RPSSOC_'+Substr(DTos(Date()),5,4)+StrTran(Time(),':','')+'.txt' 
Local nHdl		:=0        
Local cQuery	:=''
Local cAlias	:=''
Local lProc		:=.F.
Local lErro:=.F.
                                                 
nHdl:=FCreate(cArq)

cQuery:="Select * From "+RetSqlName('PAF')+" Where D_E_L_E_T_=' '"
cQuery+=" And PAF_PROC='N'"//12/09 - Cristiano - Somente enviar nao processados
TcQuery cQuery New Alias (cAlias:=GetNextAlias())

While (cAlias)->(!Eof())
	lProc:=.T.  
	//If (cAlias)->PAF_PROC=='N'
	lErro:=.T.
	//EndIF
		
	FWrite(nHdl,(cAlias)->PAF_RPSSOC+(cAlias)->PAF_PROC+Space(1)+(cAlias)->PAF_CNPJ+CRLF)
	
(cAlias)->(dbSkip())
End                 
(cAlias)->(dbCloseArea())

FClose(nHdl)

If !lProc
	FErase(cArq)
EndIf

If !Empty(cPV_Sem_NF)
	lErro:=.T.
EndIf
Return(lErro)
