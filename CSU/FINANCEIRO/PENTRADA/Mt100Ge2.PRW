#include "rwmake.ch"
*------------------------------------------------------------------------------
user function Mt100GE2()
* Ponto de entrada na geracao de titulos a pagar via mata103
* MTdO & RLdR - 02/09/2004 - GNSJC - 
*REV. 15/09/04
*------------------------------------------------------------------------------
          // Atualiza SEV- cria registro com 100%
If ALLTRIM(SE2->E2_NATUREZ)=="2.9.99"
	RecLock("SEV",.T.)
    	      sev->ev_filial :=xfilial("SEV")
        	  sev->ev_prefixo:=se2->e2_prefixo
	          sev->ev_num    :=se2->e2_num
	          sev->ev_parcela:=se2->e2_parcela
	          sev->ev_clifor :=se2->e2_fornece
	          sev->ev_loja   :=se2->e2_loja
	          sev->ev_tipo   :=se2->e2_tipo
	          sev->ev_valor  :=se2->e2_valor
	          sev->ev_naturez:=se2->e2_NATUREZ
	          sev->ev_recpag :="P"
	          sev->ev_perc   :=1
	          sev->ev_rateicc:="1"
	SEV->(MsUnLock())

          // Atualiza SEZ - cria registro com 100%

	RecLock("SEZ",.T.)          
	          sez->ez_filial :=xfilial("SEZ")
	          sez->ez_prefixo:=se2->e2_prefixo
	          sez->ez_num    :=se2->e2_num
	          sez->ez_parcela:=se2->e2_parcela
	          sez->ez_clifor :=se2->e2_fornece
	          sez->ez_loja   :=se2->e2_loja
	          sez->ez_tipo   :=se2->e2_tipo
	          sez->ez_valor  :=se2->e2_valor
	          sez->ez_naturez:=se2->e2_NATUREZ
	          sez->ez_ccusto :="5.99.99.9"
	          sez->ez_recpag :="P"
	          sez->ez_perc   :=1
	SEZ->(MsUnLock())
	// ATUALIZA SE2 - campo multiplas naturezas = Sim
	//RecLock("SE2",.F.)          
	se2->E2_MULTNAT	:="1"
	SE2->E2_CCUSTO	:="5.99.99.9"
	se2->E2_NOMFOR	:=POSICIONE("SA2",1,XFILIAL("SA2")+SE2->(E2_FORNECE+E2_LOJA),"A2_NREDUZ")           
	se2->E2_RSOCIAL	:=POSICIONE("SA2",1,XFILIAL("SA2")+SE2->(E2_FORNECE+E2_LOJA),"A2_NOME")          
	se2->E2_ORIGEM	:="FINA050"
	//SE2->(MsUnLock())
ELSE
	se2->E2_MULTNAT	:="2"
	se2->E2_NOMFOR	:=POSICIONE("SA2",1,XFILIAL("SA2")+SE2->(E2_FORNECE+E2_LOJA),"A2_NREDUZ")           
	se2->E2_RSOCIAL	:=POSICIONE("SA2",1,XFILIAL("SA2")+SE2->(E2_FORNECE+E2_LOJA),"A2_NOME")          
EndIf

return 