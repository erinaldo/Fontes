#include "rwmake.ch"      

User Function GFINA05()   

//POS 021 a 037 - Identifica��o da Empresa Cedente no Banco
//Dever� ser preenchido (esquerda para direita), da seguinte maneira:
//21 a 21 - Zero  - 0
//22 a 24 - c�digo da carteira - 009
//25 a 29 - c�digo da Ag�ncia Cedente, sem o d�gito -
//30 a 36 - Conta Corrente
//37 a 37 - d�gito da Conta
//"0009"+STRZERO(VAL(SEE->EE_AGENCIA),5)+STRZERO(VAL(SEE->EE_CONTA),7)+SEE->EE_DVCTA

_Cart := "0009"
_Agencia :=STRZERO(VAL(SEE->EE_AGENCIA),5)
_CtaCor := STRZERO(VAL(SEE->EE_CONTA),7)
_DigCta := SEE->EE_DVCTA

  _IdentBco := _Cart+_Agencia+_CtaCor+_DigCta 
	

Return(_IdentBco) 
