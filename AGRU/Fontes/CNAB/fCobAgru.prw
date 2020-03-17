#include "protheus.ch"
#include "rwmake.ch"
#include "totvs.ch"

/*{Protheus.doc} MORA
Função que carrega o percentual da MORA para CNAB a RECEBER

@author Leandro.Moura
@since 23/09/2013
@Modificação Paulo Henrique - TNU
*/
User Function MORA()

Local nPerc   := iif(valtype(SuperGetMv("AG_JUROS",.F.,0))=="C",val(SuperGetMv("AG_JUROS",.F.,0)),SuperGetMv("AG_JUROS",.F.,0) ) //GetMV("AG_JUROS") //0,33
Local cPerJur := ""

cPerJur := StrZero((nPerc*100),13) 

Return(cPerJur)

/*{Protheus.doc} MULTA
Função que calcula o valor da MULTA para CNAB a RECEBER

@author Leandro.Moura
@since 23/09/2013
@Modificação Paulo Henrique - TNU
*/
User Function MULTA()

Local nPerc  := iif(valtype(SuperGetMv("AG_MULTA",.F.,0))=="C",val(SuperGetMv("AG_MULTA",.F.,0)),SuperGetMv("AG_MULTA",.F.,0) ) // GetMV("AG_MULTA") //2
Local cMulta := ""

cMulta := StrZero(nPerc,4) //STRZERO((SE1->E1_SALDO*(nPerc/100)),13)

Return(cMulta)