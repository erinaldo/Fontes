#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 15/07/02

User Function B237CPF  // incluido pelo assistente de conversao do AP6 IDE em 15/07/02

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

DbSelectArea("SA2")
DbSetOrder(1)

_CPF := "000000000000000"

/*
posicao 03 a 11 - preencher 9 posicoes com zero a esquerda do CPF (147862298) e CNPJ (61600839);
posicao 12 a 15 - preencher 4 posicoes exclusivamente do CNPJ (0001), se for CPF preencher os campos com zero;
posicao 16 a 17 - preencher 2 posicoes do digito de controle do CPF (90) e CNPJ (55).
*/ 

If SA2->A2_TPFOR == "2"       
  _CPF := Strzero(Val(Substr(SA2->A2_CGC,1,9)),9,0)+Strzero(Val(Substr(SA2->A2_CGC,10,2)),6,0)
//ElseIf Len(alltrim(SA2->A2_CGC)) < 14 .and. SA2->A2_TPFOR == "1"
ElseIf Len(alltrim(SA2->A2_CGC)) < 14 .and. SA2->A2_TPFOR $ "1/9"
  _CPF := Strzero(Val(Substr(SA2->A2_CGC,1,9)),9,0)+ Strzero(Val(Substr(SA2->A2_CGC,10,2)),6,0)
else
  _CPF := Strzero(Val(Substr(SA2->A2_CGC,1,8)),9,0)+Strzero(Val(Substr(SA2->A2_CGC,9,4)),4,0)+ Strzero(Val(Substr(SA2->A2_CGC,13,2)),2,0)
//  _CPF := Strzero(Val(SA2->A2_CGC),15)                                 			 
Endif

SEA->(RestArea(_aAreaEA))
SE2->(RestArea(_aAreaE2))
RestArea(_aArea)
Return(_CPF)