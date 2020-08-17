#Include "Topconn.ch"
#Include "Protheus.ch"

User Function CUST_ENV() 

Local	_cTeste := " "
If Alltrim(ProcName(8))<> "T_AE_FV001"
	_xOpcao  := PARAMIXB[1]
	oProcess := PARAMIXB[2]
	_cTo:= oProcess:cTo
	If _xOpcao == 1 
		oProcess:cTo      		:= nil
		oProcess:NewVersion(.T.)
		oHtml     				:= oProcess:oHTML
		oProcess:nEncodeMime := 0
		_aReturn := {}
		AADD(_aReturn, oProcess:fProcessId)
//		cMailID := oProcess:Start("\workflow\cdv\")   //Faz a gravacao do e-mail no cPath
		cMailID := oProcess:Start("\workflow\emp"+cEmpAnt+"\cdv\")   //Faz a gravacao do e-mail no cPath
		
		chtmlfile  := cmailid + ".htm"
		cmailto    := "mailto:" + AllTrim( GetMV('MV_WFMAIL') )

		chtmltexto := wfloadfile("\workflow\emp"+cEmpAnt+"\cdv\" + chtmlfile )
//		chtmltexto := wfloadfile("\workflow\temp\" + chtmlfile )
		chtmltexto := strtran( chtmltexto, cmailto, "WFHTTPRET.APL" )
		wfsavefile("\workflow\emp"+cEmpAnt+"\cdv\" + chtmlfile+"l", chtmltexto)

		csubj := "Aprovação Solicitacao Viagem"
		oProcess:newtask("Link", "\workflow\modelo\AprovLink.htm")  //Cria um novo processo de workflow que informara o Link ao usuario
		
		oProcess:oHtml:ValByName("cDocto"	  	,"Solicitação de viagem")
		oProcess:oHtml:ValByName("descproc"	  	,"A solicitação de viagem abaixo aguarda sua aprovação:")
		oProcess:oHtml:ValByName("cNomeProcesso", Alltrim(GetMv("MV_WFDHTTP"))+"/workflow/emp"+cEmpAnt+"/cdv/"+chtmlfile+"l" ) // envia o link onde esta o arquivo html
		
		oProcess:cTo 	   := _cTo
		oProcess:cSubject := cSubj
		
		oProcess:Start()
		fErase("\workflow\emp"+cEmpAnt+"\cdv\" + chtmlfile)
	Endif
Endif
Return











                            



