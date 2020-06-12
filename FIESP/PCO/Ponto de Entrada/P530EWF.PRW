#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณP530EWF   บAutor  ณMicrosiga           บ Data ณ  23/04/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ PE para envio de e-mail de aprovacao/reprovacao de conting.บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ P11 - FIESP                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function P530EWF()
Local _aDados  := ParamIXB[1]
Local _aEmail  := ParamIXB[2]

IF Len(_aDados) == 0
	Return()
ENDIF

_cFilial := _aDados[1,2]
_cCodCTG := _aDados[1,3]
_cCodUSR := _aDados[1,8]
_cDtTime := Dtoc(_aDados[1,10])+" - Hora: "+_aDados[1,11]

For i := 1 to Len(_aEmail)
	_cBody := "Prezado Colaborador,"+Chr(13)+Chr(10)+Chr(13)+Chr(10)
	_cBody += "Foi gerada na empresa/filial "+_cFilial+" a conting๊ncia Nr. "+_cCodCTG+" para sua aprova็ใo."+Chr(13)+Chr(10)+Chr(13)+Chr(10)
	_cBody += "Data da Solicita็ใo : "+_cDtTime+Chr(13)+Chr(10)+Chr(13)+Chr(10)
	_cBody += "Solicitante : ("+_cCodUSR+") "+Alltrim(UsrRetName(_cCodUSR))+" - "+UsrFullName(_cCodUSR)
	ACSendMail( ,,,,_aEmail[i],"Aviso de Contingencia",_cBody)
Next

Return()
