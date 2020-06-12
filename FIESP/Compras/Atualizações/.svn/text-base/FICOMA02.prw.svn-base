#include "rwmake.ch"
#include "protheus.ch"
#include "TOPCONN.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FICOMA02  ºAutor  ³Lígia Sarnauskas    º Data ³  02/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa utilizado na Consulta Padrao FILSF1 (especifico)  º±±
±±º          ³ utilizado para filtrar as pre notas referentes ao grupo de º±±
±±º          ³ compras que o usuario está vinculado                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FICOMA02()

Local aArea	     := GetArea()
Local _cItem := ""
Local _nCont := 1
Local cFiltraSF1 :="" 
Local cCRLF			:= CRLF
_cCodUser	:=__CUSERID

// Verifica se o usuário faz parte de algum grupo de compras
If Select("TMP") > 0     // Verificando se o alias esta em uso
	dbSelectArea("TMP")
	dbCloseArea()
EndIf

cQuery := "SELECT SAJ.AJ_GRCOM GRCOM "
cQuery := cQuery + " FROM "
cQuery := cQuery + RetSQLname("SAJ")+" SAJ    "
cQuery := cQuery + " WHERE "
cQuery := cQuery + " SAJ.D_E_L_E_T_ = ' ' "
cQuery := cQuery + " AND SAJ.AJ_USER = '"+_cCodUser+"'
TCQuery cQuery NEW ALIAS "TMP"

dbSelectArea("TMP")
dbGotop()

If !EOF()
 _cGrupCom:=TMP->GRCOM
Else
_cGrupCom:=""
Endif           

cFiltraSF1	:= " (F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO"
cFiltraSF1	+= "			IN" + cCRLF
cFiltraSF1	+= "			(" + cCRLF
cFiltraSF1	+= "				SELECT"+ cCRLF
cFiltraSF1	+= "					SF1.F1_FILIAL+SF1.F1_DOC+SF1.F1_SERIE+SF1.F1_FORNECE+SF1.F1_LOJA+SF1.F1_TIPO"+cCRLF
cFiltraSF1	+= "				FROM                                      " + cCRLF
cFiltraSF1	+= "					" + RetSqlName( "SF1" ) + " SF1,      " + cCRLF
cFiltraSF1	+= "					" + RetSqlName( "SD1" ) + " SD1,      " + cCRLF
cFiltraSF1	+= "					" + RetSqlName( "SC7" ) + " SC7       " + cCRLF
cFiltraSF1	+= "				WHERE                                     " + cCRLF 
cFiltraSF1	+= "					SF1.D_E_L_E_T_ = ' '                  " + cCRLF 
cFiltraSF1	+= "					AND SD1.D1_FILIAL = SF1.F1_FILIAL     " + cCRLF 
cFiltraSF1	+= "					AND SD1.D1_DOC    = SF1.F1_DOC        " + cCRLF 
cFiltraSF1	+= "					AND SD1.D1_SERIE = SF1.F1_SERIE       " + cCRLF 
cFiltraSF1	+= "					AND SD1.D_E_L_E_T_ = '  '             " + cCRLF 
cFiltraSF1	+= "					AND SC7.C7_FILIAL = SD1.D1_FILIAL     " + cCRLF 
cFiltraSF1	+= "					AND SC7.C7_NUM = SD1.D1_PEDIDO        " + cCRLF 
cFiltraSF1	+= "					AND SC7.C7_GRUPCOM = '"+_cGrupCom+"'  " + cCRLF 
cFiltraSF1	+= "				GROUP BY SF1.F1_FILIAL+SF1.F1_DOC+SF1.F1_SERIE+SF1.F1_FORNECE+SF1.F1_LOJA+SF1.F1_TIPO  ))" + cCRLF  

RestArea(aArea)

return (cFiltraSF1)
