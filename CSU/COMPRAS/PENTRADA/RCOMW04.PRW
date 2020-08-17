#include "rwmake.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Rcomw04  บAutor  ณ Sergio Oliveira    บ Data ณ  Out/2006   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processo de aprovacao de Solicitacao de Compras.           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function Rcomw04(_nOPC, oProcess)

Local _cIndex, _cFiltro, _cOrdem, _lProcesso := .F.
Local _cFilial, _cOPCao, _cObs

Local nSaldo 		:= 0 , 	nSalDif 	:= 0  ,	cTipoLim  	:= ""
Local aRetSaldo 	:={} ,	cAprov    	:= "" , cObs 		:= ""
Local nTotal    	:= 0 , 	cGrupo	 	:= "" , lLiberou	:= .F.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ1 - Prepara as Solicitacoes para aprovacao            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If _nOPC == 1
	
	U_CONSOLE("1 - Prepara as Solicitacoes a serem enviadas para aprovacao")
	
	CHKfile("SC1")	// Solicitacao de Compras
	CHKFile("SCR")  // Documentos com al็adas
	CHKFile("SCR",.F.,"TMP")
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Seleciona os registros do SCR - DBF / INDREGUA                         ณ
	//ณ Abre um novo Alias para evitar problemas com filtros ja existentes.    ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	_cIndex := CriaTrab(,.F.)
	
	_cFiltro := ""
	_cFiltro += " CR_FILIAL=='" + xFilial('SCR') + "' 	.AND."  // Filial
	_cFiltro += " CR_TIPO=='SC'   .AND. "				// Solicitacao de compra
	_cFiltro += " CR_STATUS=='02' .AND. "				// Em aprova็ใo
	_cFiltro += " CR_WF$' |3'           "				// ' '-Nao Enviado / 3-rejeitado por saldo insuficiente no retorno
	
	_cOrdem	 := "CR_FILIAL+CR_NUM+CR_NIVEL+CR_USER"
	
	dbSelectArea("TMP")
	
	IndRegua("TMP",_cIndex,_cOrdem,,_cFiltro,"") //"Selecionando Registros..."
	
	#IFNDEF TOP
		DbSetIndex(_cIndex+OrdBagExt())
	#ENDIF
	
	DbGotop()
	While !TMP->(Eof())
		
		_cWFId 	   := EnviaSC(TMP->CR_FILIAL, TMP->CR_NUM, TMP->CR_USER , TMP->CR_APROV, TMP->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER), TMP->CR_TOTAL, TMP->CR_WF)
		_lProcesso := .T.
		
		// Fazer o tratamento quando houver o mesmo usuario na
		// alcada de aprovacao:
		
		DBSelectarea("SCR")
		DBSetOrder(2)
		IF DBSeek(TMP->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER))
			
			While !Eof() .And. SCR->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER) == TMP->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER) .And.;
				SCR->CR_STATUS == '03'
				DbSkip()
			EndDo
			
			If SCR->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER) == TMP->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER)
				Reclock("SCR",.F.)
				SCR->CR_WF		:= "1"			// Status 1 - envio para aprovadores
				SCR->CR_WFID	:= _cWFId		// Rastreabilidade
				MSUnlock()
			EndIf
		ENDIF
		
		TMP->(DBSkip())
	EndDo
	
	dbSelectArea("TMP")
	dbClearFilter()
	dbCloseArea()
	Ferase(_cIndex+OrdBagExt())
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ2 - Processa O RETORNO DO EMAIL                       ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
ElseIf _nOPC == 2
	
	U_CONSOLE("2 - Processa O RETORNO DO EMAIL")
	U_CONSOLE("2 - Semaforo Vermelho" )
	
	ChkFile("SD1")
	ChkFile("SCR")
	ChkFile("SAL")
	ChkFile("SC1")
	ChkFile("SCS")
	ChkFile("SAK")
	ChkFile("SM2")
	
	IF oProcess <> NIL
		cFilAnt		:= alltrim(oProcess:oHtml:RetByName("CFILANT"))
		cChaveSCR	:= xFilial('SCR')+alltrim(oProcess:oHtml:RetByName("CHAVE"))
		cOPC     	:= alltrim(oProcess:oHtml:RetByName("OPC"))
		cObs     	:= alltrim(oProcess:oHtml:RetByName("OBS"))
		cWFID     	:= alltrim(oProcess:oHtml:RetByName("WFID"))
		cWF       	:= alltrim(oProcess:oHtml:RetByName("WF")) //cWF -> ' '-Nao Enviado / 3-rejeitado por saldo insuficiente no retorno
		
		oProcess:Finish() // FINALIZA O PROCESSO
		
		U_CONSOLE("2 - Chave :" + cChaveSCR)
		U_CONSOLE("2 - OPC   :" + cOPC)
		ConOut('cObs: '+cObs)
		
	Else
		cFilAnt		:= '03'
		cChaveSCR	:= '03SC000014'
		cOPC     	:= 'S'
		cObs     	:= ''
		cWFID     	:= '     '
		cWF       	:= '1' //cWF -> ' '-Nao Enviado / 3-rejeitado por saldo insuficiente no retorno
		cOPC2    	:= 'S'
		
	ENDIF
	
	If cOPC	$ "S|N"  // Aprovacao S-Sim N-Nao
		
		// Posiciona na tabela de Alcadas
		DBSelectArea("SCR")
		DBSetOrder(2)
		DBSeek(cChaveSCR)
		
		If !Found()
			Return .t.
		EndIf
		
		While !Eof() .And. SCR->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER) == cChaveSCR .And.;
			SCR->CR_STATUS == '03'
			DbSkip()
		EndDo
		
		IF TRIM(SCR->CR_WFID) <> TRIM(cWFID)
			//"Este processo nao foi encontrado e portanto deve ser descartado
			// abre uma notificacao a pessoa que respondeu
			
			_lFound := Found()
			
			U_CONSOLE("2 - Primeira Critica: "+IIF(!FOUND(),"Sim","Nao") )
			U_CONSOLE("2 - Segunda Critica: "+IIF(TRIM(SCR->CR_WFID) <> TRIM(cWFID),"Sim","Nao") )
			
			DbSelectArea('SC1')
			DbSetOrder(1)
			If DbSeek(SCR->CR_FILIAL+Trim(SCR->CR_NUM)) .And. _lFound
				cAssunto := "Erro na Aprovacao da SC: " + SCR->CR_FILIAL +'/'+ AllTrim(SCR->CR_NUM)
				cTitulo  := 'Resposta do E-Mail Errado Referente a S.Compras Nro. '+ SCR->CR_FILIAL +'/'+ AllTrim(SCR->CR_NUM)
				cDetalhe := 'Sr(a) '+UsrFullName(SCR->CR_USER)+', voce respondeu o e-mail errado referente a esta Solicitacao de Compras. '
				cDetalhe += 'DICA: Verifique qual a data e hora mais recente do ultimo e-Mail referente a este processo. '
				_cUsuario := SCR->CR_USER // Mandar para o Aprovador
				U_Rcomw06( cAssunto, cTitulo, cDetalhe, _cUsuario, Nil, SCR->CR_USER )
			EndIf
			
			Return .T.
		ENDIF
		
		If SCR->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER) <> cChaveSCR
			ConOut('2- Fim de Processo(Mesmo Aprovador)')
			Return // Fim de Processo
		EndIf
		
		Reclock("SCR",.F.)
		SCR->CR_WF		:= "2"			// Status 2 - respondido
		MSUnlock()
		
		If !Empty(SCR->CR_DATALIB) .And. SCR->CR_STATUS$"03#04#05"
			U_CONSOLE("2 - Semaforo Verde" )
			Return .T.
		EndIf
		
		// REPosiciona na tabela de Alcadas
		DBSelectArea("SCR")
		DBSetOrder(2)
		DBSeek(cChaveSCR)
		
		While !Eof() .And. SCR->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER) == cChaveSCR .And.;
			SCR->CR_STATUS == '03'
			DbSkip()
		EndDo
		
		lLiberou := U_MaAlcDoc({SCR->CR_NUM,"SC",nTotal,SCR->CR_APROV,,,,,,,cObs},dDataBase,If(cOPC=="S",4,6), cWF)
		
		_lProcesso := .T.
		
		If !lLiberou
			ConOut('Ainda Nao Liberou')
		Else
			ConOut('SC Liberada - FILIAL + SC: '+Left(cChaveSCR,2)+'/'+SubStr(cChaveSCR,5,6))
			// Flegar a liberacao para o Workflow enviar a notificacao de SC
			// aprovados:
			
			_cExec := " UPDATE "+RetSqlName('SC1')+" SET C1_CONAPRO = 'L', C1_APROV = 'L' "
			_cExec += " WHERE C1_FILIAL = '"+Left(cChaveSCR,2)+"' "
			_cExec += " AND   C1_NUM = '"+SubStr(cChaveSCR,5,6)+"' "
			_cExec += " AND   D_E_L_E_T_ = ' ' "
			
			TcSqlExec( _cExec )
			
			DbSelectArea('SC1')
			DbSetOrder(1)
			If  DbSeek(xFilial('SC1')+SubStr(cChaveSCR,5,6))
				
				_aResult := U_PedCom(SubStr(cChaveSCR,5,6))
				
				For _i := 1 To Len( _aResult )
					
					If _aResult[_i][1] == "F"  // Gerou Erro. Notificar.
						// Erros nao-fatais nao sao notificados automaticamente pelo
						// Workflow. Torna-se necessario esta notificacao nestas cir-
						// cunstancias:
						cAssunto := "Problema na S.Compras: " + SC1->C1_FILIAL +'/'+ SC1->C1_NUM
						cTitulo  := 'Problema com Relacao a S.Compras Nro. '+ SC1->C1_FILIAL +'/'+ SC1->C1_NUM
						cDetalhe := 'Houve um erro no momento da geracao do Pedido de Compras. '
						cDetalhe += 'Analise o Log em anexo e proceda com a correcao. '
						
						_cUsuario := GetMV("MV_WFADMIN") // Mandar para o Administrador do Workflow
						U_Rcomw06( cAssunto, cTitulo, cDetalhe, _cUsuario, GetSrvProfString('StartPath','')+_aResult[_i][2] )
					EndIf
					
				Next
				
			EndIf
			
		EndIf
		
	EndIf
	
	U_CONSOLE("2 - Semaforo Verde" )
	
ElseIf _nOPC == 3
	
	U_CONSOLE("3 - Envia resposta de Solicitacoes bloqueado para o Solicitante")
	
	CHKfile("SC1")	// P. de Compras
	CHKFile("SCR")  // Documentos com al็adas
	CHKFile("SCR",.F.,"TMP")
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Seleciona os registros do SCR - DBF / INDREGUA                         ณ
	//ณ Abre um novo Alias para evitar problemas com filtros ja existentes.    ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	_cIndex := CriaTrab(,.F.)
	
	_cFiltro := ""
	_cFiltro += " CR_FILIAL=='" + xFilial('SCR') + "' 	.AND."  // Filial
	_cFiltro += " CR_TIPO=='SC'   .AND. "				// Pedido de compra
	_cFiltro += " CR_STATUS=='04' .AND. "				// Reprovado
	_cFiltro += " !EMPTY(CR_LIBAPRO) .AND. "			// Seleciona o Aprovador que reprovou
	_cFiltro += " CR_WF$' |2'           "				// ' '-Reprovado manualmente / 2-reprovado via workflow
	
	_cOrdem	 := "CR_FILIAL+CR_NUM"
	
	dbSelectArea("TMP")
	
	IndRegua("TMP",_cIndex,_cOrdem,,_cFiltro,"") //"Selecionando Registros..."
	
	#IFNDEF TOP
		dbSetIndex(_cIndex+OrdBagExt())
	#ENDIF
	
	dbGotop()
	While !TMP->(Eof())
		_cWFId 	:= EnviaSC(TMP->CR_FILIAL, TMP->CR_NUM, TMP->CR_USER, TMP->CR_APROV, TMP->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER), TMP->CR_TOTAL, "4")
		
		DBSelectarea("SCR")
		DBSetOrder(2)
		IF DBSeek(TMP->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER))
			
			While !Eof() .And. SCR->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER) == TMP->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER) .And.;
				SCR->CR_STATUS # '04'
				DbSkip()
			EndDo
			
			Reclock("SCR",.F.)
			SCR->CR_WF		:= "1"			// Status 1 - envio email
			SCR->CR_WFID	:= _cWFId		// Rastreabilidade
			MSUnlock()
		ENDIF
		
		_lProcesso := .T.
		
		dbSelectArea("TMP")
		DBSkip()
	EndDo
	
	dbSelectArea("TMP")
	dbClearFilter()
	dbCloseArea()
	Ferase(_cIndex+OrdBagExt())
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ4 - Processa O RETORNO DO EMAIL DE SC REPROVADA       ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
ElseIf _nOPC == 4
	
	U_CONSOLE("4 - Processa O RETORNO DO EMAIL DE SC REPROVADA")
	
	U_CONSOLE("4 - Semaforo Vermelho" )
	
	ChkFile("SCR")
	ChkFile("SC1")
	ChkFile("SM2")
	
	DbSelectArea('SX3')
	DbSetOrder(2)
	
	if oprocess <> nil
		cFilAnt		:= alltrim(oProcess:oHtml:RetByName("CFILANT"))
		cChaveSCR	:= xFilial('SCR')+alltrim(oProcess:oHtml:RetByName("CHAVE"))
		cOPC     	:= alltrim(oProcess:oHtml:RetByName("OPC"))
		cWFID     	:= alltrim(oProcess:oHtml:RetByName("WFID"))
		cObs     	:= alltrim(oProcess:oHtml:RetByName("OBS"))
		
		U_CONSOLE("4 - Chave :" + cChaveSCR)
		U_CONSOLE("4 - OPC   :" + cOPC)
		oProcess:Finish() // FINALIZA O PROCESSO
	ENDIF
	
	// Posiciona na tabela de Alcadas
	DBSelectArea("SCR")
	DBSetOrder(2)
	DBSeek(cChaveSCR)
	
	If !Found()
		Return .t.
	EndIf
	
	While !Eof() .And. SCR->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER) == cChaveSCR .And.;
		SCR->CR_STATUS # '04'
		DbSkip()
	EndDo
	
	IF TRIM(SCR->CR_WFID) <> TRIM(cWFID)
		U_CONSOLE("4 - Semaforo Verde(ID Diferentes)" )
		Return .T.
	ENDIF
	
	Reclock("SCR",.F.)
	SCR->CR_WF	:= "3"	// Status 2 - respondido
	MSUnlock()
	
	DbSelectArea("SC1")
	DbSetOrder(1)
	DbSeek(xFilial('SC1')+Alltrim(SCR->CR_NUM))
	
	IF !FOUND()
		U_CONSOLE("4 - Semaforo Verde" )
		Return .T.
	ENDIF
	
	IF cOPC	== "S"  // Submete a SC de compra a nova aprova็ใo ?
		lEstorna := U_MaAlcDoc({SCR->CR_NUM,"SC",SCR->CR_TOTAL,SCR->CR_LIBAPRO,,,,,,,cObs},SC1->C1_EMISSAO,5)
		
		_lProcesso := .T.
		
		dbSelectArea("SC1")
		dbSetOrder(1)
		dbSeek(xFilial('SC1')+Alltrim(SCR->CR_NUM))
		
	Else  // Estornar o SC para eliminar o empenho Desnecessario:
		_lProcesso := .T.
		
		DbSelectArea("SC1")
		DbSetOrder(1)
		If DbSeek(xFilial('SC1')+Alltrim(SCR->CR_NUM))
			
			_cChave  := SC1->(C1_FILIAL+C1_NUM)
			_cSoli   := SC1->C1_USER
			_nRegSC1 := Recno()
			
			// Estornar a SC para eliminar o empenho desnecessario:
			
			aCabC1  := {{"C1_FILIAL" ,SC1->C1_FILIAL,Nil},;
			{"C1_NUM",SC1->C1_NUM, Nil},;
			{"C1_EMISSAO",SC1->C1_EMISSAO, Nil}}
			
			aItemC1 := {}
			
			_aStru := SC1->(DbStruct())
			
			While !Eof() .And. SC1->(C1_FILIAL+C1_NUM) == _cChave
				
				For _i := 1 To Len(_aStru)
					
					DbSelectArea('SX3')
					DbSeek(_aStru[_i][1])
					If X3USO(x3_usado) // Pegar apenas os campos usados
						aAdd(aItemC1, {{ _aStru[_i][1] ,SC1->&(_aStru[_i][1]) ,Nil} } )
					EndIf
					
				Next
				
				DbSelectArea('SC1')
				DbSkip()
				
			EndDo
			
			SC1->(DbGoTo(_nRegSC1))
			
			// Adequacao - Apenas para que o Workflow consiga excluir a SC:
			
			_cRestSol := GetMV("MV_RESTSOL")
			
			PutMv("MV_RESTSOL", "N")
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณExecuta a rotina automatica para o Estorno da Solicitacao de Compra.ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			
			lMsErroAuto := .f.
			
			MSExecAuto({|v,x,y,z| MATA110(v,x,y,z)},aCabC1,aItemC1,5,.F.)
			
			// Voltar ao que era antes:
			
			PutMv("MV_RESTSOL", _cRestSol)
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณEnvia  erro na geracao da rotina  automatica. ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If lMsErroAuto
				
				cAssunto := "Problema no SC: " + SC1->C1_NUM + ' / '+SC1->C1_FILIAL
				cTitulo  := 'Problema com Relacao a SC Nro. '+ SC1->C1_NUM + ' / '+SC1->C1_FILIAL
				cDetalhe := 'Houve um erro no momento da Exclusao da SC. '
				cDetalhe += 'Analise o Log em anexo e proceda com a correcao. '
				_cUsuario := GetMV("MV_WFMAIL") // Mandar para o Administrador do WF
				U_Rcomw06( cAssunto, cTitulo, cDetalhe, _cUsuario, GetSrvProfString('StartPath','')+NomeAutoLog() )
				
			EndIf
			
			// Estornar as alcadas:
			
			_cExec := " DELETE FROM "+RetSqlName('SCR')
			_cExec += " WHERE CR_FILIAL = '"+xFilial('SCR')+"' "
			_cExec += " AND   CR_TIPO   = 'SC' "
			_cExec += " AND   CR_NUM    = '"+Right(_cChave,6)+"' "
			_cExec += " AND   D_E_L_E_T_ = ' ' "
			
			TcSqlExec(_cExec)
			
			// Avisr ao usuario quando o Workflow exclui o Documento:
			
			cAssunto := "Solicitacao de Compras Excluida: " + Right(_cChave,6)
			cTitulo  := 'Foi solicitado a exclusao da SC Nro. '+ Right(_cChave,6) + ' / '+xFilial('SC1')
			cDetalhe := 'Esta SC foi rejeitada pelo(s) aprovador(es). '
			cDetalhe += Trim(UsrFullName(_cSoli))+', Voce solicitou a exclusao deste documento. '
			_cUsuario := Upper(UsrRetMail(_cSoli))
			U_Rcomw06( cAssunto, cTitulo, cDetalhe, _cUsuario, Nil )
			
		EndIf
		
	EndIf
	
	U_CONSOLE("4 - Semaforo Verde" )
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ5 - Envia resposta de pedido aprovado para o compradorณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
ElseIf _nOPC == 5
	
	U_CONSOLE("5 - Envia resposta de Solicitacao APROVADA para o Solicitante")
	
	CHKfile("SC1", .F., "TMP")	// Pedido de Compras
	CHKFile("SCR")              // Documentos com al็adas
	CHKFile("SC1")
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Seleciona os registros do SCR - DBF / INDREGUA                         ณ
	//ณ Abre um novo Alias para evitar problemas com filtros ja existentes.    ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	_cIndex := CriaTrab(,.F.)
	
	_cFiltro := ""
	_cFiltro += " C1_FILIAL=='" + xFilial('SC1') + "' 	.AND."  // Filial
	_cFiltro += " C1_CONAPRO == 'L' .AND. "	    // Solicitacao de compra(SC Aprovada)
	_cFiltro += " C1_WF == ' '"							// ' ' - Nao enviado
	
	_cOrdem	 := "C1_FILIAL+C1_NUM+C1_ITEM+C1_PEDIDO"
	
	DbSelectArea("TMP")
	
	IndRegua("TMP",_cIndex,_cOrdem,,_cFiltro,"") //"Selecionando Registros..."
	
	#IFNDEF TOP
		dbSetIndex(_cIndex+OrdBagExt())
	#ENDIF
	
	DbGotop()
	While !TMP->(Eof())
		
		_cNum	 := TMP->C1_NUM
		_cNumPed := TMP->C1_PEDIDO
		_cWFID   := ""
		
		DBSelectarea("SCR")
		DBSetOrder(1)
		If DBSeek(TMP->(C1_FILIAL+"SC"+C1_NUM),.T.)
			
			IF TMP->C1_FILIAL 	== SCR->CR_FILIAL 	.AND. ;
				SCR->CR_TIPO 	== "SC" 			.AND. ;
				TRIM(TMP->C1_NUM) == TRIM(SCR->CR_NUM)
				
				_cWFId 	:= EnviaSC(TMP->C1_FILIAL, TMP->C1_NUM, TMP->C1_USER,, SCR->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER), SCR->CR_TOTAL, "5")
				_lProcesso := .T.
			ENDIF
			
		Else
			_cWFId 	   := 'XXX'//EnviaSC(TMP->C1_FILIAL, TMP->C1_NUM, TMP->C1_USER,,'', 0, "5")
			_lProcesso := .T.
		EndIf
		
		While !TMP->(EOF()) .AND. _cNum == TMP->C1_NUM .And. TMP->C1_PEDIDO == _cNumPed .AND. !EMPTY(_cWFID)
			_cNum	:= TMP->C1_NUM
			
			DBSelectarea("SC1")
			DBSetOrder(1)
			IF DBSeek(TMP->(C1_FILIAL+C1_NUM+C1_ITEM))
				Reclock("SC1",.F.)
				SC1->C1_WF		:= "1"			// Status 1 - envio email
				SC1->C1_WFID	:= _cWFId		// Rastreabilidade
				MSUnlock()
			EndIf
			TMP->(DBSkip())
		EndDo
	EndDo
	
	dbSelectArea("TMP")
	dbClearFilter()
	dbCloseArea()
	Ferase(_cIndex+OrdBagExt())
	
ElseIf _nOPC == 6
	
	U_CONSOLE("6 - Processamento de TimeOut")
	
	CHKfile("SC1")	// Solicitacao de Compras
	CHKFile("SCR")  // Documentos com al็adas
	CHKFile("SCR",.F.,"TMP")
	
	_cSelect := " SELECT R_E_C_N_O_ REG "
	_cSelect += " FROM "+RetSqlName('SCR')
	_cSelect += " WHERE CR_FILIAL = '"+xFilial('SCR')+"' "
	_cSelect += " AND   CR_TIPO = 'SC' "
	_cSelect += " AND   CR_NUM  = '"+oProcess+"' "
	_cSelect += " AND   CR_STATUS = '02' "
	_cSelect += " AND   CR_WF = '1' "
	_cSelect += " AND   D_E_L_E_T_ = ' ' "
	
	U_MontaView( _cSelect, 'TTTMMMPPP' )
	
	TTTMMMPPP->(DbGoTop())
	
	If TTTMMMPPP->(Eof())
		ConOut('Time-Out sem prosseguimento')
		DbSelectArea("TMP")
		DbCloseArea()
		Return
	EndIf
	
	DbSelectArea('TMP')
	DbGoTo(TTTMMMPPP->REG)
	
	_cWFId 	:= EnviaSC(TMP->CR_FILIAL, TMP->CR_NUM, TMP->CR_USER , TMP->CR_APROV, TMP->(CR_FILIAL+CR_TIPO+CR_NUM+CR_USER), TMP->CR_TOTAL, "", _nOPC)
	_lProcesso := .T.
	
	DbSelectArea('TMP')
	DbGoTo(TTTMMMPPP->REG)
	Reclock("TMP",.F.)
	TMP->CR_WFID := _cWFId		// Rastreabilidade
	MsUnlock()
	
	DbSelectArea("TMP")
	DbCloseArea()
	
EndIf

If 	_lProcesso
	U_CONSOLE(" Mensagem processada " )
Else
	U_CONSOLE(" Nao houve processamento")
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณEnviaSC   บAutor  ณ Sergio Oliveira    บ Data ณ  Out/2006   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ _cWF ' ' - Envia email para aprovador                      บฑฑ
ฑฑบ          ณ _cWF '3' - Reenvia email para aprovador, foi rejeitado     บฑฑ
ฑฑบ          ณ            por insuficiencia de saldo				      บฑฑ
ฑฑบ          ณ _cWF '4' - Envia email para o comprador informando que o SCบฑฑ
ฑฑบ          ณ            estแ reprovado								  บฑฑ
ฑฑบ          ณ _cWF '5' - Envia email para o comprador informando que o SCบฑฑ
ฑฑบ          ณ            estแ aprovado								  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rcomw04                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function EnviaSC(_cFilial,_cNum, _cUser, _cAprov, _cChave, _nTotal, _cWF, _nOPC)

Local _cDesCon := '', _cEscolha := '', _cHora := '01', _cTemCt
Local _nPedAtu := 0, _y := 0, _nAchou := 0, _nTotSC := 0
Local _lEntrei := .f., _lAlcada := .f.
Local _nHora   := GetMV('MV_X_HINT')
Local _nDia    := GetMV('MV_X_DIAS')  // Tempo de Time-Out
lDetalhe := .F.
lObs	 := .F.

_cNum := PadR(_cNum,6,' ')

ChkFile("SC8")
ChkFile("SA2")
ChkFile("SB1")
ChkFile("SBM")
ChkFile("SAL")
ChkFile("CTT")

DbSelectArea('SB1')
DbSetOrder(1)

DBSelectArea("SAL")
DBSetOrder(3)

DBSelectArea("SC7")
DBSetOrder(1)

DBSelectArea("SC1")
DBSetOrder(1)
DBSeek(_cFilial+_cNum)

DBSELECTAREA("CTT")
DBSetOrder(1)
DBSeek(xFilial("CTT")+SC1->C1_CC)

DBSelectArea("SA2")
DBSetOrder(1)
DBSeek(xFilial("SA2")+SC1->(C1_FORNECE+C1_LOJA))

//--------------------------- 1 ENVIO DE EMAIL PARA APROVAวรO
IF EMPTY(TRIM(_cWF))
	oProcess          	:= TWFProcess():New( "000001", "Envio Aprovacao SC :" + _cFilial + "/" +  TRIM(_cNum) )
	oProcess          	:NewTask( "Envio SC : "+_cFilial + _cNum, "\workflow\html\SCAprovacao.htm" )
	oProcess:cSubject 	:= _cFilial + "/" +  TRIM(_cNum)+' Aprovacao S.Compras'
	oProcess:bReturn  	:= "U_Rcomw04(2)"
	oProcess:btimeout := {{"U_Rcomw04(6,'"+ SC1->C1_NUM +"')",_nDia, _nHora, 0}} // Tempo de TimeOutS
	oProcess:cTo      	:= UPPER(UsrRetMail(_cUser))
	oProcess:UserSiga	:= SC1->C1_USER
	oProcess:NewVersion(.T.)
	lObs		 := .T.
	oHtml     			:= oProcess:oHTML
	
	// Hidden Fields
	oHtml:ValByName( "CHAVE"	    , _cChave)
	oHtml:ValByName( "CFILANT"	    , cFilAnt)
	oHtml:ValByName( "WF"   		, Trim(_cWF))
	oHtml:ValByName( "WFID"			, oProcess:fProcessId)
	
	//Cabe็alho
	If _nOpc == 6 // TimeOut
		oHtml:ValByName( "TAIMAUT"	, "TIME-OUT DO PROCESSO" )
	Else
		oHtml:ValByName( "TAIMAUT"	, "" )
	EndIf
	oHtml:ValByName( "C1_FILIAL"	, SC1->C1_FILIAL )
	oHtml:ValByName( "C1_NUM"		, SC1->C1_NUM )
	oHtml:ValByName( "C1_EMISSAO"	, DTOC(SC1->C1_EMISSAO) )
	oHtml:ValByName( "C1_USER"		, UsrFullName(SC1->C1_USER) )
	oHtml:ValByName( "OBS"		    , "" )
	
ENDIF

//--------------------------- 3 RE-APROVACAO - RESPOSTA REJEITADA
IF TRIM(_cWF) == "3"
	oProcess          	:= TWFProcess():New( "000002", "Reenvio Aprovacao SC :" + _cFilial + "/" +  TRIM(_cNum) )
	oProcess          	:NewTask( "Reenvio SC : "+_cFilial + _cNum, "\workflow\HTML\SCAprovacao.HTM" )
	oProcess:cSubject 	:=  _cFilial + "/" +  TRIM(_cNum)+" - "+" Reaprovacao SC "
	oProcess:bReturn  	:= "U_Rcomw04(2)"
	oProcess:cTo      	:= UPPER(UsrRetMail(_cUser))
	oProcess:UserSiga	:= SC1->C1_USER
	oProcess:NewVersion(.T.)
	lDetalhe := .T.
	lObs		 := .T.
	
	oHtml     			:= oProcess:oHTML
	
	// Hidden Fields
	oHtml:ValByName( "CHAVE"	    , _cChave)
	oHtml:ValByName( "CFILANT"	    , cFilAnt)
	oHtml:ValByName( "WF"   		, Trim(_cWF))
	oHtml:ValByName( "WFID"			, oProcess:fProcessId)
	
	//Cabe็alho
	
	oHtml:ValByName( "C1_FILIAL"	, SC1->C1_FILIAL )
	oHtml:ValByName( "C1_NUM"		, SC1->C1_NUM )
	oHtml:ValByName( "C1_EMISSAO"	, DTOC(SC1->C1_EMISSAO) )
	oHtml:ValByName( "C1_USER"		, UsrFullName(SC1->C1_USER) )
	oHtml:ValByName( "OBS"		    , "" )
	
ENDIF

//--------------------------- 4 ENVIO DE EMAIL PARA SOLICITANTE - INFORMANDO SOBRE A SOLICITACAO REPROVADA
IF TRIM(_cWF) == "4"
	oProcess          	:= TWFProcess():New( "000003", "Envio p/comprador SC Peprovado : " + _cFilial + "/" +  TRIM(_cNum) )
	oProcess          	:NewTask( "Envio SC reprovada : "+_cFilial + _cNum, "\workflow\HTML\SCReprovada.HTM" )
	oProcess:cSubject 	:=  _cFilial + "/" +  TRIM(_cNum)+" - "+" Reprovacao da SC "
	oProcess:bReturn  	:= "U_Rcomw04(4)"
	oProcess:cTo      	:= UPPER(UsrRetMail(SC1->C1_USER))
	oProcess:UserSiga	:= SC1->C1_USER
	oProcess:NewVersion(.T.)
	
	oHtml     			:= oProcess:oHTML
	
	// Hidden Fields
	oHtml:ValByName( "CHAVE"	    , _cChave)
	oHtml:ValByName( "CFILANT"	    , cFilAnt)
	oHtml:ValByName( "WF"   		, TRIM(_cWF))
	oHtml:ValByName( "WFID"			, oProcess:fProcessId)
	
	//Cabe็alho
	oHtml:ValByName( "C1_FILIAL"	, SC1->C1_FILIAL )
	oHtml:ValByName( "C1_NUM"		, SC1->C1_NUM )
	oHtml:ValByName( "C1_EMISSAO"	, DTOC(SC1->C1_EMISSAO) )
	oHtml:ValByName( "C1_USER"		, UsrFullName(SC1->C1_USER) )
	oHtml:ValByName( "OBS"		    , "" )
	
ENDIF

//--------------------------- 5 ENVIO DE EMAIL PARA SOLICITANTE - INFORMANDO SOBRE A SOLICITACAO APROVADA
IF TRIM(_cWF) == "5"
	oProcess          	:= TWFProcess():New( "000004", "Envio p/comprador SC aprovado : " + _cFilial + "/" +  TRIM(_cNum) )
	oProcess          	:NewTask( "Envio SC aprovada : "+_cFilial + _cNum, "\workflow\HTML\SCAprovada.HTM" )
	If !Empty(SC1->C1_PEDIDO) 
	    DbSelectArea('SC7')
	    DbSeek( xFilial('SC7')+SC1->C1_PEDIDO )
		oProcess:cSubject 	:= "Gerado o PC "+ SC1->C1_PEDIDO + '/' + SC1->C1_FILIAL +" a Partir da SC "+ _cNum
		oProcess:cTo      	:= UPPER( UsrRetMail(SC7->C7_USER) )
	Else
		oProcess:cTo      	:= PegaCom()// UPPER( UsrRetMail(SC7->C7_USER) )
		oProcess:cSubject 	:=  _cFilial + "/" +  TRIM(_cNum)+" - "+" Solicitacao de Compras Aprovada "
	EndIf
	oProcess:cCc      	:= UPPER( UsrRetMail(SC1->C1_USER) )
	oProcess:UserSiga	:= SC1->C1_USER
	oProcess:NewVersion(.T.)
	
	oHtml     			:= oProcess:oHTML
	
	//Cabe็alho
	oHtml:ValByName( "C1_FILIAL"	, SC1->C1_FILIAL )
	oHtml:ValByName( "C1_NUM"		, SC1->C1_NUM )
	oHtml:ValByName( "C1_EMISSAO"	, DTOC(SC1->C1_EMISSAO) )
	oHtml:ValByName( "C1_USER"		, UsrFullName(SC1->C1_USER) )
	
ENDIF

//-------------------------------------------------------------
// ALIMENTA A TELA DE ITENS DO SOLICITACAO DE COMPRAS
//-------------------------------------------------------------

While !SC1->(EOF()) .AND. SC1->C1_FILIAL == _cFilial .AND. SC1->C1_NUM == _cNum
	
	DBSELECTAREA("SB1")
	DBSetOrder(1)
	DBSeek(xFilial('SB1')+SC1->C1_PRODUTO)
	
	DBSELECTAREA("SBM")
	DBSetOrder(1)
	DBSeek(xFilial('SBM')+SB1->B1_GRUPO)
	
	DBSELECTAREA("CTT")
	DBSetOrder(1)
	DBSeek(xFilial('CTT')+SC1->C1_CC)
	
	AAdd( (oHtml:ValByName( "t1.1"  )), SC1->C1_ITEM)
	AAdd( (oHtml:ValByName( "t1.2"  )), SB1->B1_COD)
	AAdd( (oHtml:ValByName( "t1.3"  )), SC1->C1_DESCRI)
	AAdd( (oHtml:ValByName( "t1.4"  )), SB1->B1_UM)
	AAdd( (oHtml:ValByName( "t1.5"  )), TRANSFORM(SC1->C1_QUANT,'@E 999,999.99'))
	AAdd( (oHtml:ValByName( "t1.6"  )), TRANSFORM(SB1->B1_UPRC,'@E 999,999.999'))
	AAdd( (oHtml:ValByName( "t1.7"  )), SC1->C1_DATPRF)
	AAdd( (oHtml:ValByName( "t1.8"  )), SC1->C1_CC )
	AAdd( (oHtml:ValByName( "t1.9"  )), Trim(CTT->CTT_DESC01))
	
	SC1->(dbSkip())
	
Enddo

//-------------------------------------------------------------
// ALIMENTA A TELA DE PROCESSO DE APROVACAOO DE SOLICITACAO DE COMPRAS
//-------------------------------------------------------------

_cCHAVESCR := SUBS(_cCHAVE, 1, 24)

DbSelectArea('SC1')
DbSetOrder(1)
DbSeek(xFilial('SC1')+_cNum)

DBSelectarea("SCR")
DBSetOrder(1)
DBSeek(_cCHAVESCR,.T.)

WHILE !SCR->(EOF()) .AND. AllTrim(SCR->(CR_FILIAL+CR_TIPO+CR_NUM)) == AllTrim(_cCHAVESCR)
	cSituaca := ""
	
	DbSelectArea('SCR')
	Do Case
		Case SCR->CR_STATUS == "01"
			IIF(SCR->CR_X_TPLIB == 'A', cSituaca := 'Aguardando Aprovacao', cSituaca := 'Aguardando Visto' )
		Case SCR->CR_STATUS == "02"
			IIF(SCR->CR_X_TPLIB == 'A', cSituaca := 'Em Aprovacao', cSituaca := 'Vistando' )
		Case SCR->CR_STATUS == "03"
			IIF(SCR->CR_X_TPLIB == 'A', cSituaca := 'Aprovado', cSituaca := 'Vistado' )
		Case SCR->CR_STATUS == "04"
			cSituaca := 'Bloqueado'
		Case SCR->CR_STATUS == "05"
			cSituaca := 'Nivel Liberado'
	EndCase
	
	_cT4 := UsrFullName(SCR->CR_USERLIB)
	If SCR->(FieldPos("CR_X_OBS")) > 0
		_cT6 := AllTrim(SCR->CR_X_OBS)
	Else
		_cT6 := AllTrim(SCR->CR_OBS)
	EndIf
	
	AAdd( (oHtml:ValByName( "t.1" )), SCR->CR_NIVEL)
	AAdd( (oHtml:ValByName( "t.2" )), UsrFullName(SCR->CR_USER))
	AAdd( (oHtml:ValByName( "t.3" )), cSituaca    )
	AAdd( (oHtml:ValByName( "t.4" )), IIF(EMPTY(_cT4),"", _cT4))
	AAdd( (oHtml:ValByName( "t.5" )), DTOC(SCR->CR_DATALIB))
	AAdd( (oHtml:ValByName( "t.6" )), IIF(EMPTY(_cT6),"", _cT6))
	
	_lAlcada := .t.
	
	SCR->(DBSkip())
	
ENDDO

// Se nao houver alcada, e porque a SC foi liberada automaticamente:
If !_lAlcada
	AAdd( (oHtml:ValByName( "t.1" )), "" )
	AAdd( (oHtml:ValByName( "t.2" )), "" )
	AAdd( (oHtml:ValByName( "t.3" )), "" )
	AAdd( (oHtml:ValByName( "t.4" )), "" )
	AAdd( (oHtml:ValByName( "t.5" )), "" )
	AAdd( (oHtml:ValByName( "t.6" )), "Liberado Automaticamente" )
EndIf

_cWFID := oProcess:fProcessId

If TRIM(_cWF) # "5" .And. GetNewPar('MV_X_LNKEM','L') == 'L'

    _cProcesso := "Queira por gentileza clicar no link ao lado para proceder com a aprovacao"
    _cProcesso  += " deste documento."    
	
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
	chtmltexto := wfloadfile("\workflow\emp"+cEmpAnt+"\temp05\" + chtmlfile )
	chtmltexto := strtran( chtmltexto, cmailto, "WFHTTPRET.APL" )
	wfsavefile("\workflow\csu\" + chtmlfile+'l', chtmltexto)
	
	//A fc abaixo faz a criacao e envio do link para resposta
	U_EnviaLink(chtmlfile,cOldTo,cOldCC,cOldBCC,oProcess:cSubject, cFilAnt, 'SC', _cNum, _cProcesso, UsrFullName(_cUser) )

Else

	oProcess:Start()  // Crio o processo e gravo o ID do processo de Workflow
	
EndIf

Return _cWFId

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ SomaSC   บAutor  ณ Sergio Oliveira    บ Data ณ  Out/2006   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Obtem o valor total da SC.                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rcomw04                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function SomaSC(_cNum)

Local _nSomaSC := 0
Local _nRecSC1 := SC1->(Recno())

DbSelectArea('SC1')
While !Eof() .And. SC1->(C1_FILIAL+C1_NUM) == xFilial('SC1')+PadR(_cNum,6)
	DBSELECTAREA("SB1")
	DBSeek(xFilial('SB1')+SC1->C1_PRODUTO)
	_nSomaSC += SC1->C1_QUANT * SC1->C1_X_PRCUN
	DbSelectArea('SC1')
	DbSkip()
EndDo
SC1->(DbGoTo(_nRecSC1))

Return(_nSomaSC)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Funcao   ณ PedCom   บAutor  ณ Sergio Oliveira    บ Data ณ  Out/2006   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Geracao do Pedido de Compras.                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rcomw04.prw                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TSTSC7()

WfPrepEnv('05','03')

ChkFile('SC1')
ChkFile('SA2')
ChkFile('SAJ')
ChkFile('SC7')
U_PedCom('000044')

Return

User Function PedCom(pcNumSC)

Local   nTamSC7 := TamSX3('C7_ITEM')[1], cBusca
Local   cMaisForCab,  cMaisForItm
Private aCab	:={}, aItem :={}, _aArea := GetArea(), _aReturn := {{"T","T"}}
Private _cChave := '', _cLog := '', cAchei := ''
Private _nItens := 0, _nRecno := 0
Private lMsErroAuto := .F.

DbSelectArea("SC1")
DbSetOrder(1)
DbSeek(xFilial('SC1')+pcNumSC)  // Para pegar o codigo do comprador

// Verificar quantos fornecedores existem em cada SC:

cMaisForCab := " SELECT DISTINCT C1_NUM, B1_PROC AS C1_FORNECE, B1_LOJPROC AS C1_LOJA "
//cMaisForCab += " , A2_COND AS C1_CPAG, C1_PRODUTO, C1_GRUPCOM "
cMaisForCab += " , A2_COND AS C1_CPAG, C1_GRUPCOM "
cMaisForCab += " FROM "+RetSqlName('SC1')+" SC1, "+RetSqlName('SB1')+" SB1, "+RetSqlName('SA2')+" SA2 "
cMaisForCab += " WHERE C1_FILIAL = '"+xFilial('SC1')+"' "
cMaisForCab += " AND   C1_NUM    = '"+pcNumSC+"' "
cMaisForCab += " AND   C1_PEDIDO = '      ' "
cMaisForCab += " AND   SC1.D_E_L_E_T_ = ' ' "
cMaisForCab += " AND   B1_FILIAL = '"+xFilial('SB1')+"' "
cMaisForCab += " AND   B1_COD    = C1_PRODUTO "
cMaisForCab += " AND   B1_XDTINEG <= C1_DATPRF AND B1_XDTFNEG >= C1_DATPRF "
cMaisForCab += " AND   B1_XPRVNEG  > 0 "
cMaisForCab += " AND   SB1.D_E_L_E_T_ = ' ' "
cMaisForCab += " AND   A2_FILIAL = '"+xFilial('SA2')+"' "
cMaisForCab += " AND   A2_COD    = B1_PROC "
cMaisForCab += " AND   A2_LOJA   = B1_LOJPROC "
cMaisForCab += " AND   A2_COND   <> ' ' "
cMaisForCab += " AND   SA2.D_E_L_E_T_ = ' ' "
cMaisForCab += " ORDER BY C1_NUM, B1_PROC, B1_LOJPROC, A2_COND, C1_GRUPCOM "   

//MEMOWRITE("C:\RCOMW04.SQL",cMaisForCab)

U_MontaView(cMaisForCab, 'VerForCab')

DbSelectArea('VerForCab')
DbGoTop()

While !Eof()
	
	DbSelectArea("SB1")
	DbSetOrder(1)
	
	DbSelectArea("SA2")
	DbSetOrder(1)
	DbSeek( xFilial("SA2") + VerForCab->(C1_FORNECE+C1_LOJA) )
	
	cNumPed := GetSXENum('SC7')
	
	aCab:={  {"C7_NUM", cNumPed ,Nil},; // Pedido
	{"C7_EMISSAO" ,dDataBase			  ,Nil},; // Data de Emissao
	{"C7_FORNECE" ,VerForCab->C1_FORNECE ,Nil},; // Fornecedor
	{"C7_LOJA"    ,VerForCab->C1_LOJA	  ,Nil},; // Loja do Fornecedor
	{"C7_COND"    ,VerForCab->C1_CPAG    ,Nil},; // Condicao de pagamento
	{"C7_CONTATO" ,SA2->A2_CONTATO ,Nil},; // Contato
	{"C7_FILENT"  ,xFilial("SC7")		  ,Nil} } // Filial Entrega
	
	cMaisForItm := " SELECT C1_PRODUTO, C1_UM, C1_QUANT, "
	cMaisForItm += " C1_DATPRF, C1_LOCAL, C1_ITEM, C1_OBS, C1_CONTA,  "
	cMaisForItm += " C1_ITEMCTA, C1_CLVL, C1_CC, C1_QUANT, C1_ITEM, B1_XPRVNEG AS B1_X_PRC "
	cMaisForItm += " FROM "+RetSqlName('SC1')+" SC1, "+RetSqlName('SB1')+" SB1, "+RetSqlName('SA2')+" SA2 "
	cMaisForItm += " WHERE C1_FILIAL  = '"+xFilial('SC1')+"' "
	cMaisForItm += " AND   C1_NUM     = '"+VerForCab->C1_NUM+"' "
	cMaisForItm += " AND   C1_GRUPCOM = '"+VerForCab->C1_GRUPCOM+"' "
    cMaisForItm += " AND   C1_PEDIDO = '      ' "
	cMaisForItm += " AND   SC1.D_E_L_E_T_ = ' ' "
	cMaisForItm += " AND   B1_FILIAL  = '"+xFilial('SB1')+"' "
	cMaisForItm += " AND   B1_COD     = C1_PRODUTO "
	cMaisForItm += " AND   B1_PROC    = '"+VerForCab->C1_FORNECE+"' "
	cMaisForItm += " AND   B1_LOJPROC = '"+VerForCab->C1_LOJA+"' "
	cMaisForItm += " AND   B1_XDTINEG <= C1_DATPRF AND B1_XDTFNEG >= C1_DATPRF "
	cMaisForItm += " AND   B1_XPRVNEG  > 0 "
	cMaisForItm += " AND   SB1.D_E_L_E_T_ = ' ' "
	cMaisForItm += " AND   A2_FILIAL = '"+xFilial('SA2')+"' "
	cMaisForItm += " AND   A2_COD    = B1_PROC "
	cMaisForItm += " AND   A2_LOJA   = B1_LOJPROC "
	cMaisForItm += " AND   A2_COND   <> ' ' "
	cMaisForItm += " AND   SA2.D_E_L_E_T_ = ' ' "
	
	U_MontaView(cMaisForItm, 'VerForItm')
	
	_nItens  := 0
	aItemAux := {}
	aItem    := {}
	
	DbSelectArea('VerForItm')
	DbGoTop()
	While !Eof()
		
		_nItens ++
		
		// Localizar o item do contrato para preencher o tes:
		DbSelectArea('SB1')
		DbSeek( xFilial("SB1") + VerForItm->C1_PRODUTO )

		AADD(aItemAux , {"C7_ITEM"   	,StrZero(_nItens,nTamSC7)		,Nil} ) //Numero do Item
		AADD(aItemAux , {"C7_PRODUTO"	,VerForItm->C1_PRODUTO			,Nil} ) //Codigo do Produto
		AADD(aItemAux , {"C7_UM"		,VerForItm->C1_UM					,Nil} ) //Unidade de Medida
		AADD(aItemAux , {"C7_QUANT"	,VerForItm->C1_QUANT				,Nil} ) //Quantidade
		AADD(aItemAux , {"C7_PRECO"	,VerForItm->B1_X_PRC			,Nil} ) //Preco
		AADD(aItemAux , {"C7_DATPRF"	,Stod(VerForItm->C1_DATPRF) ,Nil} ) //Data De Entrega
		AADD(aItemAux , {"C7_FLUXO"	,"S"			 			,Nil} ) //Fluxo de Caixa (S/N)
		AADD(aItemAux , {"C7_LOCAL" 	,VerForItm->C1_LOCAL				,Nil} ) //Localizacao
		If SC7->(FieldPos('C7_LOCALEN')) > 0
			AADD(aItemAux , {"C7_LOCALEN"	,VerForItm->C1_LOCAL				,Nil} ) //Local eNTREGA
		EndIf
		AADD(aItemAux , {"C7_TES"	,SB1->B1_TE		,Nil} ) //TES
		AADD(aItemAux , {"C7_NUMSC"	,pcNumSC					,Nil} ) //Numero S.C.
		AADD(aItemAux , {"C7_ITEMSC"	,VerForItm->C1_ITEM				,Nil} ) //Item S.C.
		AADD(aItemAux , {"C7_OBS"		,VerForItm->C1_OBS				,Nil} ) //Observacoes
		AADD(aItemAux , {"C7_CONTA"	,VerForItm->C1_CONTA				,Nil} ) //Conta Contabil
		AADD(aItemAux , {"C7_ITEMCTA"	,VerForItm->C1_ITEMCTA			,Nil} ) //Item Conta
		AADD(aItemAux , {"C7_CLVL"		,VerForItm->C1_CLVL				,Nil} ) //Classe Valor
		AADD(aItemAux , {"C7_CC"		,VerForItm->C1_CC					,Nil} ) //Centro Custo
		AADD(aItemAux , {"C7_TPFRETE"	,"C"						,Nil} ) //Tipo Frete
		AADD(aItemAux , {"C7_QTDSOL"	,VerForItm->C1_QUANT				,Nil} ) //Qtd. Solicitacao
		AADD(aItem, aItemAux )
		aItemAux	:= {}
		
		DbSelectArea('VerForItm')
		DbSkip()
		
	EndDo
	
	// Adequacao - Apenas para que o Workflow consiga Incluir o PC:
	// Obter o comprador para poder direcinar o PC para o mesmo:
	
	_cRestPEd := GetMV("MV_RESTPED")
	_cRestInc := GetMV("MV_RESTINC")
	
	PutMv("MV_RESTPED", "N")
	PutMv("MV_RESTINC", "N")
	
	MSExecAuto({|v,x,y,z| MATA120(v,x,y,z)},1,aCab,aItem,3)
	
	PutMv("MV_RESTPED", _cRestPed)
	PutMv("MV_RESTINC", _cRestInc)	

	If lMsErroAuto  
	    If 'MATA110' $ FunName()
		    //MostraErro()
	    EndIf
		RollBackSX8()
		RestArea(_aArea)
		_cLog := NomeAutoLog() // Obtem o nome do arquivo sc??????.log
		_aReturn[1][1] := "F"
		_aReturn[1][2] := _cLog
	Else
	    If 'MATA110' $ FunName()
		    Aviso('Pedido','Pedido de Compras Gerado!',{'Ok'})
	    EndIf
		ConfirmSX8()

		DbSelectArea('SC7')
		DbSetOrder(1)
		DbSeek(xFilial('SC7')+cNumPed)
		
		DbSelectArea('SAJ')
		DbSetOrder(1) // Codigo do Grupo
		DbSeek( xFilial('SAJ')+VerForCab->C1_GRUPCOM )
		
		cDestroi := " UPDATE "+RetSqlName('SC7')+" SET C7_USER = '"+SAJ->AJ_USER+"' "
		cDestroi += " WHERE C7_FILIAL = '"+xFilial('SC7')+"' "
		cDestroi += " AND   C7_NUM    = '"+SC7->C7_NUM+"' "
		TcSqlExec(cDestroi)

		_aReturn[1][1] := "T"
		_aReturn[1][2] := _cLog
		
	EndIf
	
	DbSelectArea('VerForCab')
	DbSkip()
	
EndDo           

RestArea(_aArea)

Return(_aReturn)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณPegaCom   บAutor  ณ Sergio Oliveira    บ Data ณ  Out/2006   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Obter os n e-mails dos n compradores relacionados a soli-  บฑฑ
ฑฑบ          ณ citacao de compras.                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rcomw04.prw                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function PegaCom()

Local cSelect
Local cReturn := ""

cSelect := " SELECT DISTINCT AJ_USER "
cSelect += " FROM "+RetSqlName('SC1')+" SC1, "+RetSqlName('SAJ')+" SAJ "
cSelect += " WHERE C1_FILIAL = '"+xFilial('SC1')+"' "
cSelect += " AND   C1_NUM    = '"+SC1->C1_NUM+"' "
cSelect += " AND   SC1.D_E_L_E_T_ = ' ' "
cSelect += " AND   AJ_FILIAL = '"+xFilial('SAJ')+"' "
cSelect += " AND   AJ_GRCOM  = C1_GRUPCOM "
cSelect += " AND   SAJ.D_E_L_E_T_ = ' ' " 

U_MontaView( cSelect, 'PegaCom' )

DbSelectArea('PegaCom')
DbGoTop()
While !Eof() 
      
      cReturn += Trim(UsrRetMail(PegaCom->AJ_USER))

      DbSkip()
      
      If !Eof()
          cReturn += ";"
      EndIf
      
EndDo

Return( IIF( Empty(cReturn), UsrRetMail(SC1->C1_USER), cReturn ) )