#include "protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FIPCOE04  ºAutor  ³Ligia Sarnauskas    º Data ³  19/08/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para reprocessar os registros de orçamento ref. a   º±±
±±º          ³ viagens                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FIPCOE04()

cQuery := ""

If Select("TMP1") > 0     // Verificando se o alias esta em uso
	dbSelectArea("TMP1")
	dbCloseArea()
EndIf

cQuery := "SELECT Z1_FILIAL FILIAL, Z1_NUM NUMSV, Z0_ITEM ITEM, Z1_TOTAL TOTAL, Z0_CONTA CONTA, Z0_CCUSTO CC, Z0_ITEMCTA ITEMCTA, Z0_PERC PERC, Z1_DTLIB DTLIB "
cQuery := cQuery + "FROM "+RetSqlName("SZ1")+" SZ1, "+RetSqlName("SZ0")+" SZ0 "
cQuery := cQuery + "WHERE SZ1.D_E_L_E_T_ = ' ' "
cQuery := cQuery + "  AND (SZ1.Z1_STATUS = 'S' OR SZ1.Z1_STATUS = 'F' OR SZ1.Z1_STATUS = 'X' OR SZ1.Z1_STATUS = 'Q' OR SZ1.Z1_STATUS = 'Z')"
cQuery := cQuery + "  AND  SZ1.Z1_DTLIB  <> ''       "
cQuery := cQuery + "  AND  SZ1.Z1_TOTAL  > 0       "
cQuery := cQuery + "  AND  SZ0.Z0_FILIAL = SZ1.Z1_FILIAL "
cQuery := cQuery + "  AND  SZ0.Z0_NUMSV  = SZ1.Z1_NUM "
cQuery := cQuery + "  ORDER BY Z1_FILIAL, Z1_NUM "
TCQUERY cQuery NEW ALIAS "TMP1"

Dbselectarea("TMP1")
Dbgotop()   

_cLote:="0000000565"
_nItem:=2

While !EOF()
	_cChave:="SZ0"+ALLTRIM(TMP1->FILIAL)+ALLTRIM(TMP1->NUMSV)+ALLTRIM(TMP1->ITEM)
	Dbselectarea("AKD")
	Dbsetorder(3)
	If Dbseek(SUBSTR(TMP1->FILIAL,1,4)+"    "+"900002"+"01"+_cChave)
		Dbselectarea("TMP1")
		Dbskip()		
	Else			
			RecLock("AKD",.T.)
			AKD->AKD_FILIAL  := SUBSTR(TMP1->FILIAL,1,4)
			AKD->AKD_STATUS  := "1"
			AKD->AKD_LOTE    := _cLote
			AKD->AKD_ID      := STRZERO(_nItem,4)
			AKD->AKD_DATA    := STOD(TMP1->DTLIB)
			AKD->AKD_CO      := ALLTRIM(TMP1->CONTA)
			AKD->AKD_CLASSE  := "000001"
			AKD->AKD_OPER    := ALLTRIM(TMP1->FILIAL)
			AKD->AKD_TPSALD  := "EM"
			AKD->AKD_TIPO    := "1"
			AKD->AKD_HIST    := "SOLICITACAO DE VIAGENS - "+ALLTRIM(TMP1->NUMSV)
			AKD->AKD_PROCESS := "900002"
			AKD->AKD_CHAVE   := ALLTRIM(_cChave)
			AKD->AKD_ITEM    := "01"
			AKD->AKD_SEQ     := "01"
			AKD->AKD_USER    := "000000"
			AKD->AKD_COSUP   := ALLTRIM(SUBSTR(TMP1->CONTA,1,6))
			AKD->AKD_VALOR1  := TMP1->TOTAL
			AKD->AKD_CC      := TMP1->CC
			AKD->AKD_ITCTB   := TMP1->ITEMCTA
			AKD->AKD_FILORI  := SUBSTR(TMP1->FILIAL,1,4)
			MsUnLock()
			_nItem:=_nItem+1
			Dbselectarea("TMP1")
			Dbskip()
	Endif
Enddo
ALERT("Processamento realizado!")
Return()
