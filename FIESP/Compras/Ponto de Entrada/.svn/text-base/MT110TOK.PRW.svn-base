#include "rwmake.ch"
#include "protheus.ch"
#include "TOPCONN.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT110TOK  ºAutor  ³Lígia Sarnauskas    º Data ³  11/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada executado na confirmação do cadastro      º±±
±±º          ³ de solicitações de compras.                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function  MT110TOK()

lValido:=.t.
_cSolicit   :=cA110Num
_cCodUser	:=__CUSERID
_cNameUsr   :=space(40)
_cAprov	    :=space(40)
_cDepto		:=space(30)

If Select("TMP") > 0     // Verificando se o alias esta em uso
	dbSelectArea("TMP")
	dbCloseArea()
EndIf
// Filtra verificando se o solicitante tem aprovador vinculado
cQuery := "SELECT SZF.ZF_APROV APROV "
cQuery := cQuery + " FROM "
cQuery := cQuery + RetSQLname("SZF")+" SZF    "
cQuery := cQuery + " WHERE "
cQuery := cQuery + " SZF.D_E_L_E_T_ = ' ' "
cQuery := cQuery + " AND SZF.ZF_USERID = '"+_cCodUser+"'
cQuery := cQuery + " GROUP BY ZF_APROV "
TCQuery cQuery NEW ALIAS "TMP"

dbSelectArea("TMP")
dbGotop()

// Se tiver envia email para o aprovador informando que ele tem uma solicitação de compra pendente de aprovação.
If !EOF()        

// Dados Aprovador
PswOrder(1)	// ordena por user CODIGO
If PswSeek(TMP->APROV, .T. )  
	_aDados := PswRet() // Retorna vetor com informacoes do usuario
EndIf
_cAprov	:=_aDados[1][4]


// Dados solicitante
PswOrder(1)	// ordena por user CODIGO
If PswSeek(_cCodUser, .T. )  
	_aDados := PswRet() // Retorna vetor com informacoes do usuario
EndIf
_cNameUsr	:=_aDados[1][4]
_cDepto		:=_aDados[1][12] 

	    _cEMail := Alltrim(UsrRetMail(TMP->APROV))
		_cBody  := "Prezado(a) "+_cAprov+ ", " + Chr(13)+Chr(10)+Chr(13)+Chr(10)
		_cBody  += "Informamos que a solicitação de compra - "+_cSolicit+" incluida pelo usuário: " +_cNameUsr+"/"+_cDepto+", precisa ser aprovada."
		_cBody  += Chr(13)+Chr(10)+Chr(13)+Chr(10)
		_cBody  += "Favor acessar a Rotina de Solicitação de Compras e efetuar a Liberação da Solicitação "
		ACSendMail( ,,,,_cEMail,"Solicitacao de Compras: "+_cSolicit+" - NECESSARIA APROVACAO",_cBody)
Endif
Return(lValido) 