#include "rwmake.ch"        // incluido pelo assistente de conversao do AP6 IDE em 15/07/02
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³B237SLD   ºAutor  ³Claudio Barros      º Data ³  04/14/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para retornar o saldo do titulo a pagar, fazendo    º±±
±±º          ³ as verificações dos decrescimos e acrecismos.              º±±
±±º          ³ Foi utilizado o campo valor devido os titulos estarem      º±±
±±º          ³ baixados. E2_VALOR (O padrão utiliza o E2_SALDO            º±±
±±ÈÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico CIEE - SIGAFIN - CNAB 237.CPE                   º±±
±±                                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function b237SLD()        // incluido pelo assistente de conversao do AP6 IDE em 15/07/02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP6 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_SALDO,_nSalAp")  

_aArea := GetArea()  
_aAreaE2 := SE2->(GetArea())
_aAreaEA := SEA->(GetArea())

/// VALOR DO DOCUMENTO  DO CODIGO DE BARRA DA POSICAO 06 - 19, NO ARQUIVO E
/// DA POSICAO 190 - 204, QUANDO NAO FOR CODIGO DE BARRA VAI O VALOR DO SE2

    _Saldo :="000000000000000"
   
                                                                              
/*  // Retirado da funcçao por CFB 08/05/06 as 16H20

   IF SE2->E2_ACRESC > 0.00
     _Saldo := StrZero(((SE2->E2_VALOR + SE2->E2_ACRESC)*100),15)
   ELSEIF SE2->E2_DECRESC > 0.00
     _Saldo := StrZero(((SE2->E2_VALOR - SE2->E2_DECRESC)*100),15)  
   ELSE 
     _Saldo := StrZero((SE2->E2_VALOR*100),15)  
   ENDIF
*/

_Saldo := StrZero((SE2->E2_VALLIQ*100),15)  


SEA->(RestArea(_aAreaEA))
SE2->(RestArea(_aAreaE2))
RestArea(_aArea)

// Substituido pelo assistente de conversao do AP6 IDE em 15/07/02 ==> __Return(_Valor)
Return(_Saldo)        // incluido pelo assistente de conversao do AP6 IDE em 15/07/02

