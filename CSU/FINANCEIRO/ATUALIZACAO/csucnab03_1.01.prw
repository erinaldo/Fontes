#INCLUDE "rwmake.ch"
                        
// Pesquisa e retorna codigo do modelo de pagamento
// Data: 14/04/2004.
User Function CNABMP()

cMODEL	:=" "
cMODtp	:=" "
cMODtp	:=POSICIONE("SEA",1,XFILIAL("SEA")+MV_PAR01,"EA_MODELO")

IF cMODtp="41"
	cMODEL	:="03"
ElseIf cMODtp="43"
	cMODEL	:="03"
ELSE                       
	cMODEL	:=cMODtp
EndIF

/*
TABELA 58
01	CREDITO EM CONTA CORRENTE
02	CHEQUE PAGAMENTO/ADMINISTRATIVO
03	DOC
04	OP A DISPOSICAO COM AVISO PARA O FAVORECIDO
05	CREDITO EM CONTA POUPANCA
10	OP `A DISPOSICAO SEM AVISO PARA O FAVORECIDO
30	LIQUIDACAO DE TITULOS EM COBRANCA NO ITAU
31	PAGAMENTO DE TITULOS EM OUTRO BANCO
13	PAGAMENTO A CONCESSIONARIAS
16	PAGAMENTO DE TRIBUTOS - DARF NORMAL
17	PAGAMENTO DE TRIBUTOS - GPS
18	PAGAMENTO DE TRIBUTOS - DARF SIMPLES
21	PAGAMENTO DE TRIBUTOS - DARJ
41	TED - Outro Titular
43	TED - Mesmo titular
*/

Return(cMODEL)