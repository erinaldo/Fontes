#include "rwmake.ch"
#include "protheus.ch"
#include "TOPCONN.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT110TOK  �Autor  �L�gia Sarnauskas    � Data �  11/11/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada executado na confirma��o do cadastro      ���
���          � de solicita��es de compras.                                ���
�������������������������������������������������������������������������͹��
���Uso       � FIESP                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

// Se tiver envia email para o aprovador informando que ele tem uma solicita��o de compra pendente de aprova��o.
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
		_cBody  += "Informamos que a solicita��o de compra - "+_cSolicit+" incluida pelo usu�rio: " +_cNameUsr+"/"+_cDepto+", precisa ser aprovada."
		_cBody  += Chr(13)+Chr(10)+Chr(13)+Chr(10)
		_cBody  += "Favor acessar a Rotina de Solicita��o de Compras e efetuar a Libera��o da Solicita��o "
		ACSendMail( ,,,,_cEMail,"Solicitacao de Compras: "+_cSolicit+" - NECESSARIA APROVACAO",_cBody)
Endif
Return(lValido) 