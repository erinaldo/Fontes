*------------------------------------------------------------------------------
user function PosSe2(_cValor)
* Ajusta a posicao dos registros em sev e sez antes de retornar o valor
* Usada para ajuste de nao conformidades observadas na contabilizacao off line
* Financeiro - Contas a pagar - Lancamentos 508 e 510
* Ricardo Luiz da Rocha - 05/10/2004 - GNSJC
*------------------------------------------------------------------------------
local _nReturn:=0,_cKeyTit:=se2->(e2_prefixo+e2_num+e2_parcela+e2_tipo+e2_fornece+e2_loja)
se2->(dbsetorder(1)) // ricardo 01/04/2006
se2->(dbseek(xfilial()+sev->(EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA),.f.))
//sev->(dbsetorder(1)) // EV_FILIAL+EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA+EV_NATUREZ
//sez->(dbsetorder(1)) // EZ_FILIAL+EZ_PREFIXO+EZ_NUM+EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA+EZ_NATUREZ+EZ_CCUSTO
//sez->(dbseek(xfilial()+_cKeyTit,.f.))
//sev->(dbseek(xfilial()+sez->(EZ_PREFIXO+EZ_NUM+EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA+EZ_NATUREZ),.f.))
_nReturn:=&_cValor

return _nReturn