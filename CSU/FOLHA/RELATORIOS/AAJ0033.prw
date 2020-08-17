#include "topconn.ch"
#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AAJ0033   º Autor ³ ADALBERTO ALTHOFF  º Data ³  07/11/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado para atender a OS 3252/05                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function AAJ0033
Processa({|lEnd| AAJ0033A(),"(3252/05) Ajustando TM5 (Exames)..."})
Processa({|lEnd| AAJ0033B(),"(3252/05) Ajustando TNC (Acidentes)..."})

STATIC FUNCTION AAJ0033A()
aReg := {}
DBSELECTAREA("TM5")
ProcRegua(reccount())
tm5->(dbsetorder(1))
tm5->(dbgotop())

do while !eof()
	IncProc("(3252/05) montando array TM5 (Exames)...")
	if (TM5_FILIAL == '91' .and. TM5_FILFUN $ '01*13') .or. (TM5_FILIAL == '93' .and. TM5_FILFUN == '03')
		aadd(aReg,recno())
	endif
	dbskip()
enddo

ProcRegua(len(aReg))

for i=1 to len(aReg)
	dbgoto(aReg[i])
	IncProc("(3252/05) Ajustando TM5 (Exames)...")
	RecLock( "TM5" , .F. )
	TM5_FILIAL := TM5_FILFUN
	MsUnLock()
next

Return

STATIC FUNCTION AAJ0033B()
aReg := {}
DBSELECTAREA("TNC")
ProcRegua(reccount())
tnc->(dbsetorder(1))
SRA->(dbsetorder(1))
tnc->(dbgotop())
tm0->(dbsetorder(1))

do while !eof() // ENQUANTO TNC TIVER REGISTROS
	IncProc("(3252/05) montando array TNC (Acidentes)...")
	if TNC_FILIAL > '90'
		DBSELECTAREA("TM0")
		dbseek("0"+right(TNC->TNC_FILIAL,1)+TNC->TNC_NUMFIC)
		IF FOUND()
			DBSELECTAREA("TNC")
			aadd(aReg,recno())
		ELSE
			DBSELECTAREA("TM0")
			DBSEEK(TNC->TNC_FILIAL+TNC->TNC_NUMFIC)
			IF FOUND()
				DBSELECTAREA("SRA")
				DBSEEK(TM0->TM0_FILFUN+TM0->TM0_MAT)
				IF FOUND()
					IF RA_SITFOLH <> 'D'
						DBSELECTAREA("TM0")
						RECLOCK("TM0",.F.)
						TM0_FILIAL := SRA->RA_FILIAL
						MSUNLOCK()
						DBSELECTAREA("TNC")
						AADD(aReg,RECNO())
					ENDIF
				ENDIF
			ENDIF
		ENDIF
	endif 
	DBSELECTAREA("TNC")
	dbSkip()
enddo

ProcRegua(len(aReg))

for i=1 to len(aReg)
	dbgoto(aReg[i])
	IncProc("(3252/05) Ajustando TNC (Acidentes)...")
	RecLock( "TNC" , .F. )
	TNC_FILIAL := "0"+right(TNC->TNC_FILIAL,1)
	MsUnLock()
next

Return
