#include "rwmake.ch"
#include "protheus.ch"
#include "TOPCONN.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT160QRY  บAutor  ณLํgia Sarnauskas    บ Data ณ  25/11/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de entrada executado para aplicar filtro na Analise  บฑฑ
ฑฑบ          ณ de Cota็๕es carregadas no browse.                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MT160QRY()

Local cFiltraSC8
Local cCRLF			:= CRLF

_cCodUser	:=__CUSERID

cFiltraSC8	:= "C8_GRUPCOM "
cFiltraSC8	+= "			IN" + cCRLF
cFiltraSC8	+= "			(" + cCRLF
cFiltraSC8	+= "				SELECT"+ cCRLF
cFiltraSC8	+= "					SAJ.AJ_GRCOM "+cCRLF
cFiltraSC8	+= "				FROM                                      " + cCRLF
cFiltraSC8	+= "					" + RetSqlName( "SAJ" ) + " SAJ       " + cCRLF
cFiltraSC8	+= "				WHERE                                     " + cCRLF 
cFiltraSC8	+= "					SAJ.D_E_L_E_T_ = ' '                  " + cCRLF 
cFiltraSC8	+= "					AND SAJ.AJ_USER = '"+_cCodUser+"'    )" + cCRLF 


Return(cFiltraSC8)
