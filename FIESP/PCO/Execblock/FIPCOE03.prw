#include "protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FIPCOE03  ºAutor  ³Ligia Sarnauskas    º Data ³  19/08/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para deletar os registros de orçamento ref. a       º±±
±±º          ³ viagens                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FIPCOE03()

cQuery := ""

If Select("TMP1") > 0     // Verificando se o alias esta em uso
	dbSelectArea("TMP1")
	dbCloseArea()
EndIf

cQuery := "SELECT Z1_FILIAL FILIAL, Z1_NUM NUMSV "
cQuery := cQuery + "FROM "+RetSqlName("SZ1")+" SZ1 "
cQuery := cQuery + "WHERE SZ1.D_E_L_E_T_ = ' ' "
cQuery := cQuery + "  AND SZ1.Z1_STATUS = 'W'"
cQuery := cQuery + "  ORDER BY Z1_FILIAL, Z1_NUM "
TCQUERY cQuery NEW ALIAS "TMP1"

Dbselectarea("TMP1")
Dbgotop()

While !EOF()
	_cChave:="SZ0"+ALLTRIM(TMP1->FILIAL)+ALLTRIM(TMP1->NUMSV)+"001"
	Dbselectarea("AKD")
	Dbsetorder(3)
	If Dbseek(SUBSTR(TMP1->FILIAL,1,4)+"    "+"900002"+"01"+_cChave)
		While !EOF() .and. SUBSTR(TMP1->FILIAL,1,4) == ALLTRIM(AKD->AKD_FILIAL) .and. ALLTRIM(AKD->AKD_PROCESS) == "900002" .AND. ALLTRIM(AKD->AKD_CHAVE) ==ALLTRIM(_cChave)
			RecLock("AKD",.F.)
			DbDelete()
			MsUnLock()
			Dbselectarea("AKD")
			Dbskip()
		Enddo
	Endif
	Dbselectarea("TMP1")
	Dbskip()
Enddo

ALERT("Processamento realizado!")
Return()
