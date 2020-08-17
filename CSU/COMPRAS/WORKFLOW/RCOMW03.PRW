#Include "Rwmake.ch"
#Include "TopConn.ch"
#Include "TbiCode.ch"
#Include "TbiConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Rcomw03  บAutor  ณ Sergio Oliveira    บ Data ณ  Ago/2006   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Envia aos Pedidos Aprovados ao Fornecedor.                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU.                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function AcPed()

U_Rcomw03({"05","03"},"  000409")

Return

User Function Rcomw03(aParam, pcChave, oProcess, plTimeOut)

If ValType(aParam) == 'A'
	WfPrepEnv( aParam[1], aParam[2] )
	cFilAnt   := aParam[2]
	_lViaMenu := .f.
	ConOut("1 - Envia Pedido APROVADO para o Fornecedor")
	CHKFile("SC7")
	CHKFile("SC1")
	CHKFile("SCR")
	OkProc(aParam, pcChave, oProcess, plTimeOut)
Else
	_lViaMenu := .t.
	aParam    := { cEmpAnt, cFilAnt }
	MV_PAR01 := SC7->C7_FILIAL
	MV_PAR02 := SC7->C7_NUM
	Processa( { || OkProc(aParam, pcChave, oProcess, plTimeOut) }, 'Enviando Pedidos ao Fornecedor' )
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ OkProc   บAutor  ณ Sergio Oliveira    บ Data ณ  Ago/2006   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processamento do programa.                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rcomw03.prw                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function OkProc(aParam, pcChave, oProcess, plTimeOut)

ChkFile('ZA9')
ZA9->( DbSetOrder(1) )
ConOut('------------------ Inicio do Processamento('+FunName()+') --------------------')

DbSelectArea('SC1')
DbSetOrder(1)

_cPididu := SC7->C7_NUM

_lTimeOut  := .f.
_lProcesso := .f.
_lReenv    := .f.
_cIndex    := CriaTrab(,.F.)

If !_lViaMenu
	MV_PAR01 := Left(pcChave,2)
	MV_PAR02 := Right(pcChave,6)
Else
	//If !VldPed()
	//   Return    ==>> Colocar um memo de notificacao - Fazer por ultimo
	//EndIf
EndIf

If Select('TMP') > 0
	TMP->(DbCloseArea())
EndIf

// Retorno do Fornecedor

_cFiltro := " SELECT DISTINCT C7_FILIAL, C7_NUM, C7_USER "+Chr(13)+Chr(10)
_cFiltro += " FROM "+RetSqlName('SC7')+Chr(13)+Chr(10)
_cFiltro += " WHERE C7_FILIAL = '"+MV_PAR01+"' "+Chr(13)+Chr(10)
_cFiltro += " AND   C7_NUM    = '"+MV_PAR02+"' "+Chr(13)+Chr(10)
_cFiltro += " AND  D_E_L_E_T_ = ' ' "

TCQUERY _cFiltro NEW ALIAS "TMP"

DbSelectArea('TMP')
DbGotop()
While !Eof()
	
	DbSelectArea('SC7')
	DbSeek(xFilial('SC7')+TMP->C7_NUM)
	
	DbSelectArea('TMP')
	
	If pcChave # Nil .And. _lTimeOut == .f.
		_cWFId 	:= EnviaPc(TMP->C7_FILIAL, TMP->C7_NUM, TMP->C7_USER,, "",Nil , "6", oProcess, aParam)
	Else
		_cWFId 	:= EnviaPc(TMP->C7_FILIAL, TMP->C7_NUM, TMP->C7_USER,, "",Nil , "5", plTimeOut, aParam)
	EndIf
	_lProcesso := .T.
	
	If !Empty(_cWFId)
		DbSelectArea('SC7')
		DbSetOrder(1)
		DbSeek(TMP->(C7_FILIAL+C7_NUM),.t.)
		While !Eof() .AND. SC7->(C7_FILIAL+C7_NUM) == TMP->(C7_FILIAL+C7_NUM)
			
			Reclock("SC7",.F.)
			SC7->C7_WF		:= "1"			// Status 1 - envio email
			SC7->C7_WFID	:= _cWFId		// Rastreabilidade
			SC7->C7_X_ENVFR := '1'
			MSUnlock()
			
			DbSkip()
			
		EndDo
	EndIf
	
	DbSelectArea('TMP')
	DbSkip()
	
EndDo

DbSelectArea("TMP")
DbCloseArea()

If _lProcesso
	ConOut('Fim de Processamento')
Else
	ConOut('Nao Houve Processamento')
EndIf

Ferase(_cIndex+OrdBagExt())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ CalcData บAutor  ณ Sergio Oliveira    บ Data ณ  Mai/2010   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Obter as datas de entrega atraves dos tipos de entregas in-บฑฑ
ฑฑบ          ณ formados diretamente nos Pedidos de Compras.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rcomw03.prw                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CalcData()

Local dReturn := SC7->C7_DATPRF

If ZA9->( DbSeek( xFilial('ZA9')+SC7->C7_X_TENT ) )
   dReturn := dDataBase + ZA9->ZA9_FATOR
EndIf

Return( dReturn )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณEnviaPC   บAutor  ณ Sergio Oliveira    บ Data ณ  Ago/2006   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Notificar o comprador juntamente com o fornecedor a respei-บฑฑ
ฑฑบ          ณ to do Pedido de Compras aprovado.                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rcomw03.prw                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function EnviaPC(_cFilial,_cNum, _cUser, _cAprov, _cChave, _nTotal, _cWF, oProcess, aParam)

Local cGrava
Local lObs     := .t.
Local cSituaca := '', cObs := '', cOpc := '', _cStPed := '', cObs2 := ''
Local _aItens  := {}, aItensPC := {}, _aAreaSM0 := SM0->(GetArea())
Local _nTotPed := 0, _nTotImp := 0, _nTotIPI := 0, _nTotICMS := 0, _nTotFrete := 0,;
_nTotDesp := 0, _nTotSeg := 0, _nTotDesc := 0

ChkFile("SE4")
ChkFile("SC8")
ChkFile("SA2")
ChkFile("SB1")
ChkFile("SBM")

DbSelectArea("SC7")
DbSetOrder(1)
DbSeek(_cFilial+_cNum)

_cStPed := IIF( SC7->C7_TIPO == 1, 'Pedido de Compras ','Autorizacao de Entrega ' )

// Sergio em Jan/2007: Tratamento para o fornecedor de entrega:

DbSelectArea("SA2")
DbSetOrder(1)
DbSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA)
_nRegSA2 := SA2->(Recno())
If !Empty( SC7->(C7_X_FOREN+C7_X_LJENT) )
	DbSeek(xFilial("SA2")+SC7->(C7_X_FOREN+C7_X_LJENT))
	_nRegSC7 := SA2->(Recno())
EndIf

DbSelectArea("SE4")
DbSetOrder(1)
DbSeek(xFilial("SE4")+SC7->C7_COND)

If Empty(SA2->A2_EMAIL) .And. Trim(_cWF) == "5"
	cAssunto := "Pedido: "+SC7->C7_FILIAL+'/'+SC7->C7_NUM+" - Forn. S/ E-Mail"
	cTitulo  := 'Problema com o Pedido Nro. '+SC7->C7_FILIAL+'/'+SC7->C7_NUM
	cDetalhe := 'Houve um erro quanto ao envio do e-mail ao fornecedor '
	cDetalhe += 'referente o Pedido de Compras '+SC7->C7_FILIAL+'/'+SC7->C7_NUM+'. O fornecedor '+Trim(SA2->A2_NOME)+' / '
	cDetalhe += 'loja '+SA2->A2_LOJA+' NAO POSSUI E-MAIL PREENCHIDO.'
	_cUsuario := SC7->C7_USER
	U_Rcomw06(cAssunto, cTitulo, cDetalhe, _cUsuario)
	Return('X')
EndIf

//--------------------------- 5 ENVIO DE EMAIL PARA FORNECEDOR
If Trim(_cWF) == "5"
	oProcess          	:= TWFProcess():New( "000004", "Envio p/ Fornecedor PC aprovado : " + _cFilial + "/" +  TRIM(_cNum) )
	oProcess          	:NewTask( "Envio PC aprovado : "+_cFilial + _cNum, "\workflow\html\PCForneceII.HTM" )
	//oProcess          	:NewTask( "Envio PC aprovado : "+_cFilial + _cNum, "\htm2\PCForneceII.HTM" )
	If !_lTimeOut
		oProcess:cSubject 	:= _cStPed+Trim(SM0->M0_NOMECOM)+'/'+Trim(SM0->M0_FILIAL)+": " + _cFilial + "/" +  _cNum
	Else
		oProcess:cSubject 	:= "Time-Out / "+_cStPed+Trim(SM0->M0_NOMECOM)+'/'+Trim(SM0->M0_FILIAL)+": " + _cFilial + "/" +  _cNum
	EndIf
	oProcess:cTo      	:= Upper(Trim(SA2->A2_EMAIL))
	oProcess:UserSiga	:= _cUser
	oProcess:bReturn  := "U_Rcomw03({'"+aParam[1]+"','"+aParam[2]+"'},'"+_cFilial+_cNum+"')"
	//oProcess:btimeout := {{"U_Rcomw03({'"+aParam[1]+"','"+aParam[2]+"'},'"+_cFilial+_cNum+"',Nil,.t.)",0, GetMV('MV_X_HORA'), GetMV('MV_X_MINUT')}} // Tempo de TimeOutS
	oProcess:NewVersion(.T.)
	oHtml   := oProcess:oHTML
	oHtml:ValByName( "TIPOPED"	, _cStPed )
EndIf

//--------------------------- 6 ENVIO DE EMAIL PARA COMPRADOR - INFORMANDO SOBRE O PEDIDO CONFIRMADO PELO FORNECEDOR
If Trim(_cWF) == "6"
	
	If Type('oProcess') # Nil
		cFilAnt      := oProcess:oHtml:RetByName("C7_FILIAL"  )
		_cNumero     := oProcess:oHtml:RetByName("C7_NUM"     )
		ConOut("----------- Valores recebidos no retorno ")
		ConOut(" Filial     " + cFilAnt      )
		ConOut(" Numero     " + _cNumero     )
		cOpc := alltrim(oProcess:oHtml:RetByName("OPC"))
		cObs := alltrim(oProcess:oHtml:RetByName("OBS"))
		oProcess:Finish() // FINALIZA O PROCESSO		
	Else
		cFilAnt      := "  "
		_cNumero     := "000004"
		cOpc := "S"
		cObs := "Teste"
	EndIf
	
	DbSelectArea("SC7")
	DbSetOrder(1)  // C7_FILIAL+C7_NUM+C7_ITEM
	
	DbSelectArea("SC7")
	If DbSeek( xFilial("SC7") +  PadR(_cNumero,6) )
		_lProcesso := .t.
		// Flegar a liberacao para o Workflow enviar a notificacao de pedidos
		// aprovados:
		
		_cExec := " UPDATE "+RetSqlName('SC7')+" SET C7_X_DTACT = '"+Dtos(dDataBase)+"', C7_X_ENVFR = '"+cOpc+"' "
		_cExec += " WHERE C7_FILIAL = '"+xFilial('SC7')+"' "
		_cExec += " AND   C7_NUM = '"+PadR(_cNumero,6)+"' "
		_cExec += " AND   D_E_L_E_T_ = ' ' "
		
		TcSqlExec( _cExec )
		
	EndIf
	
	cAssunto := _cStPed+": "+SC7->C7_FILIAL+'/'+SC7->C7_NUM+IIF( cOpc == "S", '  -  ACEITO',' - RECUSADO' )
	If cOpc # 'S'
		cTitulo  := _cStPed+' RECUSADO - Nro. '+SC7->C7_FILIAL+'/'+SC7->C7_NUM
	Else
		cTitulo  := _cStPed+' ACEITO Nro. '+SC7->C7_FILIAL+'/'+SC7->C7_NUM
	EndIf
	cDetalhe := 'Este '+_cStPed+' acabou de ser respondido pelo fornecedor '
	cDetalhe += Trim(SA2->A2_NOME)+' / Loja '+SA2->A2_LOJA+'. '
	cDetalhe += 'Resposta do Fornecedor: '+cObs
	_cUsuario := Upper(UsrRetMail(_cUser))
	
	U_Rcomw06(cAssunto, cTitulo, cDetalhe, _cUsuario)
	
	Return( 'T' )
	
EndIf

DbSelectArea('SC1')
DbSetOrder(1)
If DbSeek( xFilial('SC1')+SC7->(C7_NUMSC+C7_ITEMSC) )
	DbSelectArea('SM0')
	DbSeek(cEmpAnt+SC1->C1_FILENT)
EndIf

SA2->(DbGoTo( _nRegSA2 ))

oHtml:ValByName( "C7_FILIAL"	, SC7->C7_FILIAL )
oHtml:ValByName( "C7_NUM"		, SC7->C7_NUM )
//Cabe็alho - Dados do Fornecedor:
oHtml:ValByName( "A2_NOME"		, Trim(SA2->A2_NOME) )
oHtml:ValByName( "A2_CODLOJA"   , SA2->A2_COD+' / '+SA2->A2_LOJA)
oHtml:ValByName( "A2_END"       , "Endereco: "+SA2->A2_END)
oHtml:ValByName( "A2_BAIRRO"    , "Bairro: "+SA2->A2_BAIRRO)
oHtml:ValByName( "A2_MUN"       , "Municipio: "+SA2->A2_MUN)
oHtml:ValByName( "A2_EST"       , "UF: "+SA2->A2_EST)
oHtml:ValByName( "A2_CEP"       , "CEP: "+SA2->A2_CEP)
oHtml:ValByName( "A2_CGC"       , "CGC: "+SA2->A2_CGC)
oHtml:ValByName( "A2_IE"        , "IE: "+SA2->A2_INSCR)
oHtml:ValByName( "A2_CONTATO"   , "Contato: "+SA2->A2_CONTATO)
oHtml:ValByName( "A2_TEL"       , "Tel: "+SA2->A2_TEL)
oHtml:ValByName( "A2_FAX"       , "Fax: "+SA2->A2_FAX)
//Cabe็alho - CSU / Entrega:

// Sergio em Jan/2007: Tratamento para o fornecedor de entrega:

DbSelectArea("SA2")
If !Empty( SC7->(C7_X_FOREN+C7_X_LJENT) )
	SA2->(DbGoTo( _nRegSC7 ))
	oHtml:ValByName( "M0_NOMECOMENT" , SA2->A2_NOME)
	oHtml:ValByName( "M0_ENDENT"    , "Endereco: "+SA2->A2_END )
	oHtml:ValByName( "M0_CEPENT"    , "CEP: "+SA2->A2_CEP )
	oHtml:ValByName( "M0_CIDENT"    , "Cidade: "+SA2->A2_MUN )
	oHtml:ValByName( "M0_ESTENT"    , "UF: "+SA2->A2_EST )
	oHtml:ValByName( "M0_TELENT"    , "Tel: "+SA2->A2_TEL )
	oHtml:ValByName( "M0_FAXENT"    , "Fax: "+SA2->A2_FAX )
	oHtml:ValByName( "M0_CGCENT"    , "CGC: "+SA2->A2_FAX )
	oHtml:ValByName( "M0_INSCENT"   , "IE: "+SA2->A2_INSCR )
Else
	oHtml:ValByName( "M0_NOMECOMENT"   , SM0->M0_NOMECOM )
	oHtml:ValByName( "M0_ENDENT"    , "Endereco: "+SM0->M0_ENDENT )
	oHtml:ValByName( "M0_CEPENT"    , "CEP: "+SM0->M0_CEPENT )
	oHtml:ValByName( "M0_CIDENT"    , "Cidade: "+SM0->M0_CIDENT )
	oHtml:ValByName( "M0_ESTENT"    , "UF: "+SM0->M0_ESTENT )
	oHtml:ValByName( "M0_TELENT"    , "Tel: "+SM0->M0_TEL )
	oHtml:ValByName( "M0_FAXENT"    , "Fax: "+SA2->A2_FAX )
	oHtml:ValByName( "M0_CGCENT"    , "CGC: "+SM0->M0_CGC )
	oHtml:ValByName( "M0_INSCENT"   , "IE: "+SM0->M0_INSC )
EndIf

SA2->(DbGoTo( _nRegSA2 ))
//Cabe็alho - ป CSU / Cobran็a:
// Tratamento da condicao de pagamento Leasing:
If SC7->C7_COND $ GetMV('MV_X_WFCND')
	DbSelectArea('SE4')
	DbSetOrder(1)
	DbSeek( xFilial('SE4')+SC7->C7_COND )
	
	DbSelectArea('SA6')
	DbSetORder(1)
	DbSeek( xFilial('SA6')+SE4->(E4_XBANCO+E4_XAGENCI+E4_XCONTA) )
	
	oHtml:ValByName( "M0_NOMECOMCOB", SA6->A6_NOME )
	oHtml:ValByName( "M0_ENDCOB"    , "Endereco: "+SA6->A6_END )
	oHtml:ValByName( "M0_CIDCOB"    , "Cidade: "+SA6->A6_MUN )
	oHtml:ValByName( "M0_ESTCOB"    , "Estado: "+SA6->A6_EST )
	oHtml:ValByName( "M0_CEPCOB"    , "Cep: "+SA6->A6_CEP )
	
	oHtml:ValByName( "M0_ESTENTCOB", SA6->A6_EST )
	oHtml:ValByName( "M0_TELCOB"    , "Tel: "+SA6->A6_TEL )
	oHtml:ValByName( "M0_FAXCOB"    , "Fax: "+SA6->A6_FAX )
	oHtml:ValByName( "M0_CGCCOB"    , "CNPJ: "+SA6->A6_CGC )
	
	//Cabe็alho - CSU / Faturamento:
	oHtml:ValByName( "M0_NOMECOMFAT", SA6->A6_NOME )
	oHtml:ValByName( "M0_ENDENTFAT" , "Endereco: "+SA6->A6_END )
	oHtml:ValByName( "M0_CEPENTFAT" , "CEP: "+SA6->A6_CEP )
	oHtml:ValByName( "M0_CIDENTFAT" , "Cidade: "+SA6->A6_MUN )
	oHtml:ValByName( "M0_ESTENTFAT" , "UF: "+SA6->A6_EST )
	oHtml:ValByName( "M0_TELFAT"    , "Tel: "+SA6->A6_TEL )
	oHtml:ValByName( "M0_FAXFAT"    , "Fax: "+SA6->A6_FAX )
	oHtml:ValByName( "M0_CGCFAT"    , "CGC: "+SA6->A6_CGC )
	oHtml:ValByName( "M0_INSCFAT"   , " " )
	
Else
	
	//Cabe็alho - CSU / Faturamento:
	oHtml:ValByName( "M0_NOMECOMFAT", SM0->M0_NOMECOM )
	oHtml:ValByName( "M0_ENDENTFAT" , "Endereco: "+SM0->M0_ENDENT )
	oHtml:ValByName( "M0_CEPENTFAT" , "CEP: "+SM0->M0_CEPENT )
	oHtml:ValByName( "M0_CIDENTFAT" , "Cidade: "+SM0->M0_CIDENT )
	oHtml:ValByName( "M0_ESTENTFAT" , "UF: "+SM0->M0_ESTENT )
	oHtml:ValByName( "M0_TELFAT"    , "Tel: "+SM0->M0_TEL )
	oHtml:ValByName( "M0_FAXFAT"    , "Fax: "+GetMv('MV_X_TELCP') )
	oHtml:ValByName( "M0_CGCFAT"    , "CGC: "+SM0->M0_CGC )
	oHtml:ValByName( "M0_INSCFAT"   , "IE: "+SM0->M0_INSC )
	
	oHtml:ValByName( "M0_NOMECOMCOB", SM0->M0_NOMECOM )
	oHtml:ValByName( "M0_ENDCOB"    , "Endereco: Rua Piaui, 136 - 3o andar - A/C: Tesouraria" )
	oHtml:ValByName( "M0_CIDCOB"    , "Nova Aldeinha - Barueri" )
	oHtml:ValByName( "M0_ESTCOB"    , "SP" )
	oHtml:ValByName( "M0_CEPCOB"    , "Cep: 06440-182" )
	oHtml:ValByName( "M0_ESTENTCOB" , "")
	oHtml:ValByName( "M0_TELCOB"    , "Tel: (55 11) 2627-8500" )
	//oHtml:ValByName( "M0_FAXCOB"    , "Fax: (55 11) 2627-8500" )
	oHtml:ValByName( "M0_CGCCOB"    , "CNPJ: 01.896.779/0001-38" )
EndIf

// Dados do Pedido:
oHtml:ValByName( "C7_EMISSAO"   , SC7->C7_EMISSAO )
oHtml:ValByName( "E4_DESCRI"    , SE4->E4_DESCRI )
oHtml:ValByName( "C7_USER"      , UsrFullName(SC7->C7_USER) )

//-------------------------------------------------------------
// ALIMENTA A TELA DE ITENS DO PEDIDO DE COMPRA
//-------------------------------------------------------------

DbSelectArea('SC7')
DbSeek(xFilial('SC7')+_cNum,.t.)
cObs2 := SC7->C7_MSG
While !SC7->(Eof()) .AND. SC7->C7_FILIAL == _cFilial .AND. SC7->C7_NUM == _cNum
	
	DbSelectarea("SB1")
	DbSetOrder(1)
	DbSeek(xFilial('SB1')+SC7->C7_PRODUTO)
	
	DbSelectArea("SBM")
	DbSetOrder(1)
	DbSeek(xFilial('SBM')+SB1->B1_GRUPO)
	/*
	ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	ณ Sergio em Mai/2010: Atendimento a OS 0248/10 onde no momento do envio do pedido ao fornecedor, a data   ณ
	ณ                     de entrega devera ser modificada de acordo com as opcoes de entregas (se informado) ณ
	ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/
	SC7->( RecLock('SC7',.f.) )
	SC7->C7_DATPRF := CalcData()
	SC7->( MsUnLock() )
	
	AAdd( (oHtml:ValByName( "t1.1"  )), SC7->C7_ITEM)
	AAdd( (oHtml:ValByName( "t1.2"  )), SB1->B1_COD)
	AAdd( (oHtml:ValByName( "t1.3"  )), SC7->C7_DESCRI)
	// Sergio em Mar/2008: Chamado 003723 - Inclusao das especificacoes tecnicas:
	AAdd( (oHtml:ValByName( "t1.12" )), SB1->B1_X_ESPEC)
	AAdd( (oHtml:ValByName( "t1.4"  )), SB1->B1_UM)
	AAdd( (oHtml:ValByName( "t1.5"  )), TRANSFORM(SC7->C7_QUANT,'@E 999,999.999'))
	AAdd( (oHtml:ValByName( "t1.6"  )), TRANSFORM(SC7->C7_PRECO,'@E 999,999.999'))
	AAdd( (oHtml:ValByName( "t1.7"  )), TRANSFORM(SC7->C7_IPI,'@E 9,999.99'))
	AAdd( (oHtml:ValByName( "t1.8"  )), TRANSFORM(SC7->C7_QUANT * SC7->C7_PRECO,'@E 999,999.99'))
	AAdd( (oHtml:ValByName( "t1.9"  )), SC7->C7_DATPRF)
	AAdd( (oHtml:ValByName( "t1.10" )), SC7->C7_CC)
	AAdd( (oHtml:ValByName( "t1.11" )), SC7->C7_NUMCOT)
	
	_nTotPed   += SC7->C7_TOTAL
	_nTotDesc  += SC7->C7_VLDESC
	_nTotImp   += ( SC7->C7_TOTAL+SC7->C7_VALIPI+SC7->C7_SEGURO+SC7->C7_DESPESA+SC7->C7_VALFRE )
	_nTotIPI   += SC7->C7_VALIPI
	_nTotICMS  += SC7->C7_VALICM
	_nTotFrete += SC7->C7_VALFRE
	_nTotDesp  += SC7->C7_DESPESA
	_nTotSeg   += SC7->C7_SEGURO
	
//	cObs += ' - '+Trim(SC7->C7_OBS)
	cObs += ' - '+Trim(SC7->C7_X_OBS) // OS-0189/13 - FERNANDO BARRETO
	
	AAdd( aItensPc, { SB1->B1_COD , SC7->C7_DESCRI, TRANSFORM(SC7->C7_QUANT,'@E 999,999.999'), SC7->C7_DATPRF } )
	
	SC7->(dbSkip())
	
Enddo

SM0->(RestArea(_aAreaSM0))

oHtml:ValByName( "TOTPED"       , TRANSFORM(_nTotPed,'@E 999,999.99') )
oHtml:ValByName( "TOTDESC"      , TRANSFORM(_nTotDesc,'@E 999,999.99') )
oHtml:ValByName( "TOTIMP"       , TRANSFORM(_nTotImp,'@E 999,999.99') )
oHtml:ValByName( "TOTIPI"       , TRANSFORM(_nTotIPI,'@E 999,999.99') )
oHtml:ValByName( "TOTICMS"      , TRANSFORM(_nTotICMS,'@E 999,999.99') )
oHtml:ValByName( "TOTFRETE"     , TRANSFORM(_nTotFrete,'@E 999,999.99') )
oHtml:ValByName( "TOTDESP"      , TRANSFORM(_nTotDesp,'@E 999,999.99') )
oHtml:ValByName( "TOTSEG"       , TRANSFORM(_nTotSeg,'@E 999,999.99') )
oHtml:ValByName( "TOTGER"       , TRANSFORM(_nTotImp - _nTotDesc,'@E 999,999.99') )
_cSolicits := PegaSol()
oHtml:ValByName( "SOLICITANTES" , _cSolicits )

_xFormula := Formula(cObs2)
If ValType(_xFormula) == 'C'
	_xFormula += IIF( Empty(_xFormula),"",";" )
Else
	_xFormula := " "
EndIf

oHtml:ValByName( "OBSPED", cObs+" ;" )
oHtml:ValByName( "OBSFORM", _xFormula )

_cWFID := oProcess:fProcessId

If GetNewPar('MV_X_LNKEM','L') == 'L'
	_cProcesso := "Queira por gentileza clicar no link ao lado para proceder com o aceite"
	_cProcesso  += " aceite do Pedido."
	
	cOldTo  := oProcess:cTo
	cOldCC  := oProcess:cCC
	cOldBCC := oProcess:cBCC
	
	//Uso um endereco invalido, apenas para criar o processo de workflow, mas sem envia-lo
	oProcess:cTo  := NIL
	oProcess:cCC  := NIL
	oProcess:cBCC := NIL
	
   //	cMailId    := oProcess:Start()  // Crio o processo e gravo o ID do processo de Workflow
   	cMailId    := oProcess:Start('workflow\emp'+cEmpAnt+'\temp05')  
	chtmlfile  := cmailid + ".htm"
	cmailto    := "mailto:" + AllTrim( GetMV('MV_WFMAIL') )
//	chtmltexto := wfloadfile("\workflow\emp"+cEmpAnt+"\temp\" + chtmlfile )
	chtmltexto := wfloadfile("\workflow\emp"+cEmpAnt+"\temp05\" +alltrim(chtmlfile))
	chtmltexto := strtran( chtmltexto, cmailto, "WFHTTPRET.APL" )
	wfsavefile("\workflow\csu\" + chtmlfile+'l', chtmltexto)
	
	//A fc abaixo faz a criacao e envio do link para resposta
	
	U_EnviaLink(chtmlfile+'l ',cOldTo,cOldCC,cOldBCC,oProcess:cSubject, cFilAnt, 'PC', _cNum, _cProcesso, SA2->A2_CONTATO )
	
	/*
	ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	ณ # Chamado 003829: Avisar aos aprovadores sobre o pedido de compras aprovadoณ
	ณ                   enviado ao fornecedor:                                   ณ
	ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	*/
	oProcess      	:= TWFProcess():New( "000001", "Notificacao Avulsa" )
	oProcess       	:NewTask( "Notificacao Avulsa", "\workflow\HTML\PCForneceNotif.htm" )
	oProcess:UserSiga	:= '000000'  // Fixo Administrador
	oProcess:NewVersion(.T.)
	oHtml   := oProcess:oHTML
	
	oHtml:valbyname("c7_num"            , TMP->C7_NUM )
	oHtml:valbyname("fornecedor"        , SA2->(A2_COD+'/'+A2_LOJA)+'-'+SA2->A2_NOME )
	oHtml:valbyname("cond"              , SE4->E4_DESCRI )
	oHtml:valbyname("total"             , Transform( _nTotImp - _nTotDesc, '@E 999,999,999.99' ) )
	oHtml:valbyname("contatofor"        , SA2->A2_CONTATO )
	oHtml:valbyname("telefonefor"       , '('+SA2->A2_DDD+')'+SA2->A2_TEL )
	oHtml:valbyname("emailfor"          , SA2->A2_EMAIL )
	
	oHtml:valbyname("contatoprocurement", Posicione('SY1',3,xFilial('SY1')+TMP->C7_USER,'Y1_TEL') )
	oHtml:valbyname("nomeprocurement"   , UsrFullName( TMP->C7_USER ) )
	oHtml:valbyname("emailproc"         , Posicione('SY1',3,xFilial('SY1')+TMP->C7_USER,'Y1_EMAIL') )
	
	// Alimentar os itens:
	For xp := 1 To Len( aItensPC )
		AAdd( (oHtml:ValByName( "t1.1"  )), aItensPC[xp][1] )
		AAdd( (oHtml:ValByName( "t1.2"  )), aItensPC[xp][2] )
		AAdd( (oHtml:ValByName( "t1.3"  )), aItensPC[xp][3] )
		AAdd( (oHtml:ValByName( "t1.4"  )), aItensPC[xp][4] )
	Next
	oProcess:cTo      := TrazAprov()
	oProcess:csubject := "Pedido Nro. "+_cNum+" enviado ao fornecedor "
	
	oProcess:Start()
	
Else
	
	oProcess:Start()
	
EndIf

Return _cWFId

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ VldPed   บAutor  ณ Sergio Oliveira    บ Data ณ  Mar/2005   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Efetua as validacoes no pedido escolhido.                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rcomw03.prw                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VldPed()

Local _lConf := .f.

DbSelectArea('SC7')
DbSetOrder(1)
If !DbSeek(MV_PAR01+MV_PAR02)
	Aviso('Erro','Este pedido nao existe.',{'Ok'})
Else
	If SC7->C7_QUJE > 0
		Aviso('Ja Entregue','Este pedido ja foi entregue.',{'Ok'})
	ElseIf SC7->C7_RESIDUO # ' '
		Aviso('Eliminado','Este pedido foi eliminado por residuo.',{'Ok'})
	ElseIf SC7->C7_CONAPRO # 'L'
		Aviso('Bloqueado','Este pedido Esta Bloqueado.',{'Ok'})
	EndIf
EndIf

Return(_lConf)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณPegaSol   บAutor  ณ Sergio Oliveira    บ Data ณ  Out/2006   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Obter os n solicitantes relacionados ao Pedido de Compras. บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rcomw03.prw                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PegaSol()

Local cSelect
Local cReturn := "Solicitantes: "

cSelect := " SELECT DISTINCT C1_USER "
cSelect += " FROM "+RetSqlName('SC7')+" SC7, "+RetSqlName('SC1')+" SC1 "
cSelect += " WHERE C7_FILIAL = '"+xFilial('SC7')+"' "
cSelect += " AND   C7_NUM    = '"+TMP->C7_NUM+"' "
cSelect += " AND   SC7.D_E_L_E_T_ = ' ' "
cSelect += " AND   C1_FILIAL = '"+xFilial('SC1')+"' "
cSelect += " AND   C1_NUM    = C7_NUMSC "
cSelect += " AND   C1_ITEM   = C7_ITEMSC "
cSelect += " AND   SC1.D_E_L_E_T_ = ' ' "

U_MontaView( cSelect, 'PegaSol' )

DbSelectArea('PegaSol')
DbGoTop()
While !Eof()
	
	cReturn += Trim(UsrFullName(PegaSol->C1_USER))
	
	DbSkip()
	
	If !Eof()
		cReturn += " / "
	EndIf
	
EndDo

Return( IIF( Empty(cReturn), UsrRetMail(TMP->C7_USER), cReturn ) )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ TrazAprovบAutor  ณ Sergio Oliveira    บ Data ณ  Mai/2008   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Obter os aprovadores deste pedido de compras.              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rcomw03.prw                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function TrazAprov()

Local cEmails, cSelect
Local cNextAlias := GetNextAlias()

cSelect := " SELECT TOP 2 CR_USER FROM "+RetSqlName('SCR')
cSelect += " WHERE CR_FILIAL  = '"+xFilial('SCR')+"' "
cSelect += " AND   CR_TIPO    = 'PC' "
cSelect += " AND   CR_NUM     = '"+_cPididu+"' "
cSelect += " AND   CR_X_TPLIB <> 'S' "
cSelect += " AND   D_E_L_E_T_ = ' ' "

U_MontaView( cSelect, cNextAlias )

(cNextAlias)->( DbGoTop() )

cEmails := UsrRetMail( (cNextAlias)->CR_USER )

(cNextAlias)->( DbSkip() )

If !(cNextAlias)->( Eof() )

	cEmails += ';'+UsrRetMail( (cNextAlias)->CR_USER )
	
EndIf

If 'HOMOLOGACAO' $ GetEnvServer() .Or. 'DESENVOLVIMENTO' $ GetEnvServer()
	MsgBox( "Serao enviados e-mails para: "+cEmails,'E-mails','Info' )
EndIf                                                           

Return( cEmails )
