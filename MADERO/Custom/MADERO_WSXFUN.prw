#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} WSXINI
//TODO Mensagens exibidas ao iniciar o processo
@author Mario L. B. Faria
@since 30/04/2018
@version 1.0
@param cMethod, characters, Metodo
@param cMetEnv, characters, Metodo de envio
/*/
User Function WSXINI(cMethod,cMetEnv)
	Conout("==========================================================================")
	Conout("Inicio do Processo: " + cMethod + "\" + cMetEnv)
	Conout("Filial..: " + cFilAnt + " - " + FWFilialName())
	Conout("Data....: " + DtoC(Date()))
	Conout("Hora....: " + Time())
Return

/*/{Protheus.doc} WSXFIM
//TODO Mensagens exibidas ao finalizar o processo
@author Mario L. B. Faria
@since 30/04/2018
@version 1.0
@param cMethod, characters, Metodo
@param cMetEnv, characters, Metodo de envio
/*/
User Function WSXFIM(cMethod,cMetEnv)
	Conout("Fim do Processo: " + cMethod + "\" + cMetEnv)
	Conout("Filial..: " + cFilAnt + " - " + FWFilialName())
	Conout("Data....: " + DtoC(Date()))
	Conout("Hora....: " + Time())
	Conout("==========================================================================")
Return

/*/{Protheus.doc} WSXPROC
//TODO Mensagens exibidas ao enviar dados processo
@author Mario L. B. Faria
@since 30/04/2018
@version 1.0
@param cMethod, characters, Metodo
@param cMetEnv, characters, Metodo de envio
@param cMsg, characters, Mensagem a exibir
/*/
User Function WSXPROC(cMethod,cMetEnv,cMsg)
//	Conout("[" + DtoC(date()) + " " + Time() + "] - " + cMsg)
	Conout(cMsg)
Return

/*/{Protheus.doc} CRSX01MD
//TODO Cria perguntas para chamar WS via Menu
@author Mario L. B. Faria
@since 15/05/2018
@version 1.0
/*/
User Function CRSX01MD()

	U_PutSX1(cPerg,"01","Método?" ,""	,"" ,"mv_ch1" ,"N" ,01 ,0 ,0 ,"C", "" ,"" ,"" ,"" ,"mv_par01" ,;
				   "Post"	,"Post"		,"Post","",;
				   "Put"	,"Put"		,"Put",;
				   "Delete"	,"Delete"	,"Delete")			   
Return

/*/{Protheus.doc} CRSX01MD
//TODO Cria perguntas para chamar WS Get's via Menu
@author Mario L. B. Faria
@since 15/05/2018
@version 1.0
/*/
User Function CRSX02MD()

	U_PutSx1(cPerg,"01","Data Inicial?"	,"","","mv_ch1","D",8,0,0,"G","",""			,"","","mv_par01")	
	U_PutSx1(cPerg,"02","Data Final?"	,"","","mv_ch2","D",8,0,0,"G","",""			,"","","mv_par02")	
	   
Return

/*/{Protheus.doc} CRSX03MD
//TODO Cria perguntas para chamar WS Get's via Menu
@author Marcos Aurélio Feijó
@since 27/06/2018
@version 1.0
/*/
User Function CRSX03MD()

	U_PutSx1(cPerg,"01","Data Caixa?"	,"","","mv_ch1","D",8,0,0,"G","",""			,"","","mv_par01")	
	   
Return

/*/{Protheus.doc} INITEK
//TODO Função inicializador padrão dos campo Empresa e Filial do Teknisa
@author Mario L. B. Faria
@since 14/05/2018
@version 1.0
@return cRet, retorno
@param cCpo, characters, Campo a  buscar
/*/
User Function INITEK(cCpo)

	Local cRet := ""

	dbSelectArea("ADK")
	ADK->( dbOrderNickName("ADKXFILI") )
	ADK->( dbGoTop() )
	If ADK->(dbseek(xFilial("ADK")+cFilAnt))
		cRet := ADK->&(cCpo)
		conout(ADK->ADK_NOME)
	EndIf
	
Return cRet


/*/{Protheus.doc} GrvLog
//TODO Função para gravar log de validação
@author Mario L. B. Faria
@since 17/05/2018
@version 1.0
/*/
User Function GRLOGTEK(aError)
	
	Local nX	:= 0

	RecLock("ZWS",.F.)
	ZWS->ZWS_STATUS := "E"
	For nX := 1 to Len(aError)
		ZWS->ZWS_ERROR += "[" + DtoC(Date()) + " - "  + Time() + "] - " + aError[nX] + CRLF	
		Conout(aError[nX])
	Next nX
	ZWS->(MsUnlock())

Return

/*/{Protheus.doc} DHtoD
//TODO função para retornar a data de um campo Date Time
@author Mario L. B. Faria
@since 16/05/2018
@version 1.0
@return data
@param cDH, characters, Date Time
/*/
User Function DHtoD(cDH)
	
	Local cRet	:= ""
	
	If !Empty(cDH)
		cRet := CtoD(SubStr(cDH,1,10))
	Else
		cRet := CtoD("  /  /    ")
	EndIf
	
Return cRet


/*/{Protheus.doc} CharToVal
//TODO Função para comverter Cracater em Valor com casas decimais do protheus
@author Mario L. B. Faria
@since 17/05/2018
@version 1.0
@return Valor convertido
@param cVal, characters, String com o valor
@param cCpo, characters, Campo a ser convertido
/*/
User Function CharToVal(cVal,cCpo)
Return Round(Val(StrTran(cVal,",",".")),TamSx3(cCpo)[02])