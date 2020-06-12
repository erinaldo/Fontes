#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 15/07/02

User Function CTACOMPL        // incluido pelo assistente de conversao do AP6 IDE em 15/07/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_CTA,")

_aArea := GetArea() 
_aAreaE2 := SE2->(GetArea())
_aAreaEA := SEA->(GetArea())

DbSelectArea("SA6")
DbSetOrder(1)

_Cta := "0000000"
_cConta	:= Alltrim(SA6->A6_NUMCON)
_cCta	:= SubStr(_cConta,1,Len(_cConta)-1)

If !empty(SA6->A6_NUMCON).and. SA6->A6_COD == "237"

	_Cta := Strzero(Val(_cCta),7,0)
	         
Endif

SEA->(RestArea(_aAreaEA))
SE2->(RestArea(_aAreaE2))
RestArea(_aArea)

Return(_Cta)