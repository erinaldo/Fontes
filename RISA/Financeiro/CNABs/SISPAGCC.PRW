#include "rwmake.ch"        

User Function SISPAGCC()  

// SISPAG - Posicaoes( 024 - 043 )
If !EMPTY(SA2->A2_BANCO)
    If SA2->A2_BANCO =="341"
        _Conta :="0"+STRZERO(VAL(SA2->A2_AGENCIA),4)+" "+"0000000"+STRZERO(VAL(SA2->A2_NUMCON),5)+" "+STRZERO(VAL(SA2->A2_DVCTA),1)
    else  
        If SA2->A2_BANCO !="341"
            _Conta := STRZERO(VAL(SA2->A2_AGENCIA),5)+" "+STRZERO(VAL(SA2->A2_NUMCON),12)+" "+SA2->A2_DVCTA
        Endif
    Endif
ELSE
    MSGALERT( "Atenção", "Banco NÃO informado no cadastro do Fornecedor: "+SA2->A2_COD+"-"+SA2->A2_LOJA+": "+SA2->A2_NOME )
    _Conta := "0ERRO"
    
ENDIF
Return(_Conta)
/*
Quando o banco favorecido for 341 (Banco Itaú) ou 409 (Unibanco) este campo deverá ser preenchido da seguinte forma:
   Nome do Campo
ZEROS BRANCOS CONTA
DAC
Significado
COMPLEMENTO DE REGISTRO COMPLEMENTO DE REGISTRO NÚMERO DE C/C CREDITADA
DAC DA AGÊNCIA/CONTA CREDITADA
Posição
024 024
029 029
036 041
043 043
Picture Conteúdo
9(01) x(01) 9(06) 9(01)
     
AGÊNCIA
NÚMERO AGÊNCIA CREDITADA
025 028 9(04)
ZEROS
COMPLEMENTO DE REGISTRO
030 035 9(06)
BRANCOS
COMPLEMENTO DE REGISTRO
042 042 X(01)
 Os campos Conta e DAC devem ser preenchidos com zeros quando a forma de pagamento for 02 ou 10 (cheque ou Ordem de Pagamento), porque neste caso a OP ou o cheque ficarão à disposição do favorecido na agência indicada.
b) Quando o banco favorecido não for 341 ou 409 (portanto as formas de pagamento são 03-DOC C, 07- DOC D, 41-TED/outro titular e 43-TED/mesmo titular) os campos deverão ser preenchidos da seguinte forma:
     Nome do Campo
Agência
Significado
Número agência CREDITADA
Posição
024 028
Picture
9(05)
Conteúdo
     
brancos
Complemento de registro 029 029 X(01)
Novembro 2018
SISPAG Febraban 240
44
Conta Número de C/C CREDITADA 030 041 9(12) 042 X(01) DAC DAC DA AGÊNCIA/Conta CREDITADA 043 043 X(01)
*/