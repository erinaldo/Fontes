#include "rwmake.ch"      

User Function GFINA05()   

//POS 021 a 037 - Identificação da Empresa Cedente no Banco
//Deverá ser preenchido (esquerda para direita), da seguinte maneira:
//21 a 21 - Zero  - 0
//22 a 24 - código da carteira - 009
//25 a 29 - código da Agência Cedente, sem o dígito -
//30 a 36 - Conta Corrente
//37 a 37 - dígito da Conta
//"0009"+STRZERO(VAL(SEE->EE_AGENCIA),5)+STRZERO(VAL(SEE->EE_CONTA),7)+SEE->EE_DVCTA

_Cart := "0009"
_Agencia :=STRZERO(VAL(SEE->EE_AGENCIA),5)
_CtaCor := STRZERO(VAL(SEE->EE_CONTA),7)
_DigCta := SEE->EE_DVCTA

  _IdentBco := _Cart+_Agencia+_CtaCor+_DigCta 
	

Return(_IdentBco) 
