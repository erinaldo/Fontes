#include "rwmake.ch"
#include "TOPCONN.ch"

User Function AJUS_CV4()

cQuery	:=	"SELECT CV4_FILIAL,CV4_SEQUEN, CV4_DTSEQ, COUNT(CV4_DTSEQ) AS NUMREG "
cQuery	+=	"FROM "+RetSQLName("CV4")+" "
cQuery	+=	"WHERE D_E_L_E_T_ <> '*' "
cQuery	+=	"GROUP BY  CV4_FILIAL,CV4_SEQUEN, CV4_DTSEQ "
cQuery	+=	"HAVING  COUNT(CV4_DTSEQ) > 1 "
cQuery	+=	"ORDER BY CV4_FILIAL, CV4_DTSEQ, CV4_SEQUEN "
//TcQuery cQuery New Alias "REGTMP"
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'REGTMP',.T.,.T.)

Processa({|| RunCont() },"Processando...")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AJUS_CV4  ºAutor  ³Microsiga           º Data ³  01/29/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RunCont()

DbSelectArea("REGTMP")
ProcRegua(RecCount())

Do While !EOF()
	IncProc()
	nCont := 1
	DbSelectArea("CV4")
	DbSetOrder(1)
	If DbSeek(xFilial("CV4")+REGTMP->CV4_DTSEQ+REGTMP->CV4_SEQUEN)
		ProcRegua(RecCount())	
		Do While nCont<= REGTMP->NUMREG .and. REGTMP->CV4_DTSEQ+REGTMP->CV4_SEQUEN == DTOS(CV4->CV4_DTSEQ)+CV4->CV4_SEQUEN
			IncProc()		
			RecLock("CV4",.F.)
			CV4->CV4_ITSEQ := strzero(nCont,6)
			MsUnLock()
			nCont++
			DbSelectArea("CV4")
			DbSkip()
		EndDo
	EndIf
	
	DbSelectArea("REGTMP")
	DbSkip()
EndDo

DbCloseArea("REGTMP")

Return