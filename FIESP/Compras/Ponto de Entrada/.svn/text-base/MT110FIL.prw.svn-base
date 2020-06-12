#include "rwmake.ch"
#include "protheus.ch"
#include "TOPCONN.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT110FIL  ºAutor  ³Lígia Sarnauskas    º Data ³  11/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada executado para aplicar filtro nas         º±±
±±º          ³ solicitações de compras carregadas no browse.              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT110FIL()

Local cFiltro := ''
Local _cItem := "" 
Local _cItemcom := ""
_nCont:=0

_cCodUser	:=__CUSERID

// Verifica se o usuário que está acessando é aprovador, se for permite ver todas as solicitações usuários em que ele for o aprovador
If Select("TMP") > 0     // Verificando se o alias esta em uso
	dbSelectArea("TMP")
	dbCloseArea()
EndIf

cQuery := "SELECT SZF.ZF_USERID USERID "
cQuery := cQuery + " FROM "
cQuery := cQuery + RetSQLname("SZF")+" SZF    "
cQuery := cQuery + " WHERE "
cQuery := cQuery + " SZF.D_E_L_E_T_ = ' ' "
cQuery := cQuery + " AND SZF.ZF_APROV = '"+_cCodUser+"'
TCQuery cQuery NEW ALIAS "TMP"

dbSelectArea("TMP")
dbGotop()

While !EOF()
	If _nCont > 1
		_cItem += "|"
	EndIf
	_cItem += (TMP->USERID)
	_nCont++
	dbSelectArea("TMP")
	DbSkip()
Enddo

// Verifica se o usuário faz parte de um grupo de compras se fizer permite ver as solicitações de todos os usuários qur fizerem parte do mesmo grupo de compras.
If Select("TMP1") > 0     // Verificando se o alias esta em uso
	dbSelectArea("TMP1")
	dbCloseArea()
EndIf
          
cQuery := "SELECT SAJ.AJ_USER USERCOM "
cQuery := cQuery + " FROM "
cQuery := cQuery + RetSQLname("SAJ")+" SAJ,    "
cQuery := cQuery + "(SELECT SAJ.AJ_GRCOM CODGRUP FROM SAJ010 SAJ WHERE SAJ.D_E_L_E_T_ = '  ' AND SAJ.AJ_USER = '"+_cCodUser+"' GROUP BY AJ_GRCOM) ALUSER
cQuery := cQuery + " WHERE "
cQuery := cQuery + " SAJ.D_E_L_E_T_ = ' ' "
cQuery := cQuery + " AND SAJ.AJ_GRCOM = ALUSER.CODGRUP "
TCQuery cQuery NEW ALIAS "TMP1"

dbSelectArea("TMP1")
dbGotop()

While !EOF()
	If _nCont > 1
		_cItemCom += "|"
	EndIf
	_cItemCom += (TMP1->USERCOM)
	_nCont++
	dbSelectArea("TMP1")
	DbSkip()
Enddo            

// Verifica quais centros de custo o usuário pode visualizar
_cCusto:=""
If Select("TMP2") > 0     // Verificando se o alias esta em uso
	dbSelectArea("TMP2")
	dbCloseArea()
EndIf
          
cQuery := "SELECT SZF.ZF_CUSTO CUSTO "
cQuery := cQuery + " FROM "
cQuery := cQuery + RetSQLname("SZF")+" SZF    "
cQuery := cQuery + " WHERE "
cQuery := cQuery + " SZF.D_E_L_E_T_ = ' ' "
cQuery := cQuery + " AND SZF.ZF_USERID = '"+_cCodUser+"'
TCQuery cQuery NEW ALIAS "TMP2"

dbSelectArea("TMP2")
dbGotop()
             
_nCont:=1
While !EOF()
	If _nCont > 1
		_cCusto += "|"
	EndIf
	_cCusto += (TMP2->CUSTO)
	_nCont++
	dbSelectArea("TMP2")
	DbSkip()
Enddo       


// Para carregar as solicitações na tela o usuário deve ser o solicitante (Filtro 1a linha) ou o aprovador da soloicitação (Filtro 2a linha)
// Se o usuário não tiver nenhuma solicitação incluída por ele ou não for aprovador trará o browse vazio.
cFiltro :=  '  C1_USER  == "'+_cCodUser+'"  '
cFiltro += '   .OR. C1_USER $ "'+_cItem+'" '
cFiltro += '   .OR. C1_USER $ "'+_cItemCom+'" '
cFiltro += '   .OR. C1_CC   $ "'+_cCusto+'" '

Return (cFiltro)
