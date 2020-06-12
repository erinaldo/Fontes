#include "rwmake.ch"

User Function GATCODBAR()


SetPrvt("_cRetorno")
SetPrvt("CSTR,I,NMULT,NMODULO,CCHAR")
SetPrvt("CDIGITO,CDV1,CDV2,CDV3,CCAMPO1,CCAMPO2")
SetPrvt("CCAMPO3,NVAL,NCALC_DV1,NCALC_DV2,NCALC_DV3,NREST")

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AFINM003 ³ Autor ³ Nadia C.D.Mamude      ³ Data ³ 08/03/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Transformacao da Linha digitavel em codigo de barra.       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/

_cRetorno := ''

//if ValType(M->E2_LD) == NIL
// Return(_cRetorno)
//Endif

cStr := M->E2_LD

i := 0
nMult := 2
nModulo := 0
cChar   := SPACE(1)
cDigito := SPACE(1)

cDV1    := SUBSTR(cStr,10, 1)
cDV2    := SUBSTR(cStr,21, 1)
cDV3    := SUBSTR(cStr,32, 1)

cCampo1 := SUBSTR(cStr, 1, 9)
cCampo2 := SUBSTR(cStr,11,10)
cCampo3 := SUBSTR(cStr,22,10)

nMult   := 2
nModulo := 0
nVal    := 0

// Calcula DV1

For i := Len(cCampo1) to 1 Step -1
	cChar := Substr(cCampo1,i,1)
	If isAlpha(cChar)
		Help(" ", 1, "ONLYNUM")
		Return(_cRetorno)
	endif
	nModulo := Val(cChar)*nMult
	If nModulo >= 10
		nVal := NVAL + 1
		nVal := nVal + (nModulo-10)
	Else
		nVal := nVal + nModulo
	EndIf
	nMult:= if(nMult==2,1,2)
Next
nCalc_DV1 := 10 - (nVal % 10)

//Calcula DV2

nMult   := 2
nModulo := 0
nVal    := 0

For i := Len(cCampo2) to 1 Step -1
	cChar := Substr(cCampo2,i,1)
	If isAlpha(cChar)
		Help(" ", 1, "ONLYNUM")
		Return(_cRetorno)
	endif
	nModulo := Val(cChar)*nMult
	If nModulo >= 10
		nVal := nVal + 1
		nVal := nVal + (nModulo-10)
	Else
		nVal := nVal + nModulo
	EndIf
	nMult:= if(nMult==2,1,2)
Next
nCalc_DV2 := 10 - (nVal % 10)

// Calcula DV3

nMult   := 2
nModulo := 0
nVal    := 0

For i := Len(cCampo3) to 1 Step -1
	cChar := Substr(cCampo3,i,1)
	if isAlpha(cChar)
		Help(" ", 1, "ONLYNUM")
		Return(_cRetorno)
	endif
	nModulo := Val(cChar)*nMult
	If nModulo >= 10
		nVal := nVal + 1
		nVal := nVal + (nModulo-10)
	Else
		nVal := nVal + nModulo
	EndIf
	nMult:= if(nMult==2,1,2)
Next
nCalc_DV3 := 10 - (nVal % 10)

If nCalc_DV1 == 10
	nCalc_DV1 := 0
EndIf
If nCalc_DV2 == 10
	nCalc_DV2 := 0
EndIf
If nCalc_DV3 == 10
	nCalc_DV3 := 0
EndIf

if !(nCalc_DV1 == Val(cDV1) .and. nCalc_DV2 == Val(cDV2) .and. nCalc_DV3 == Val(cDV3) )
	Help(" ",1,"INVALCODBAR")
	Return(_cRetorno)
endif

_cRetorno := SUBSTR(cStr, 1, 4)+SUBSTR(cStr, 33, 1)+iif(Len(alltrim(SUBSTR(cStr, 34, 14)))<14,StrZero(Val(Alltrim(SUBSTR(cStr, 34, 14))),14),SUBSTR(cStr, 34, 14))+SUBSTR(cStr, 5, 5)+SUBSTR(cStr, 11, 10)+SUBSTR(cStr, 22, 10)
Return(_cRetorno)