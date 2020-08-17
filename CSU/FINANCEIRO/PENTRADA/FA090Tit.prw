#Include "RwMake.ch"
#include "Protheus.ch"
#include "Topconn.ch"
/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Programa  � FA090TIT � Autor � Daniel G.Jr.TI1239  � Data � 26/12/2007  ���
��������������������������������������������������������������������������͹��
���Descricao � Faz verifica��o na confirma��o da baixa                     ���
��������������������������������������������������������������������������͹��
���Uso       � Csu CardSystem - PE da rotina FINA090-Bx.Pagar Automat.     ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
User Function FA090Tit()

local cQuery:=""
local _lNTemPA:=.T.

// Executa este PE somente para a empresa 05
If SM0->M0_CODIGO!="05"
	Return(.T.)
EndIf

// Verifica se h� t�tulo de PA para o PC da NF que originou este t�tulo; 
// Se houver a rotina impede que ele seja selecionado			** Inclu�do por Daniel G.Jr. em 21/12/07
cQuery := "SELECT COUNT(*) NREGS " 
cQuery +=   "FROM "+RetSqlName("SD1")+" SD1, "
cQuery +=           RetSqlName("SF1")+" SF1, "
cQuery += 			RetSqlName("SE2")+" BSE2 "
cQuery +=  "WHERE SD1.D_E_L_E_T_<>'*' AND SD1.D_E_L_E_T_<>'*' AND BSE2.D_E_L_E_T_<>'*' "
cQuery +=    "AND F1_DOC='"+SE2->E2_NUM+"' "
cQuery +=    "AND F1_PREFIXO='"+SE2->E2_PREFIXO+"' "
cQuery +=    "AND F1_FORNECE='"+SE2->E2_FORNECE+"' "
cQuery +=    "AND F1_LOJA='"+SE2->E2_LOJA+"' "
cQuery +=	 "AND D1_DOC=F1_DOC "
cQuery +=	 "AND D1_SERIE=F1_SERIE "
cQuery +=	 "AND D1_FORNECE=F1_FORNECE "
cQuery +=	 "AND D1_LOJA=F1_LOJA "                 
cQuery +=    "AND D1_PEDIDO<>' ' "
cQuery +=    "AND BSE2.E2_TIPO='PA' "
cQuery +=    "AND BSE2.E2_FORNECE+BSE2.E2_LOJA=D1_FORNECE+D1_LOJA "
cQuery +=    "AND BSE2.E2_NUMPC=D1_PEDIDO "
cQuery +=    "AND BSE2.E2_SALDO > 0 "
cQuery := ChangeQuery(cQuery)
//MemoWrite("C:\FA090TIT.sql",_cQuery)
	
If Select("E2PA")>0
	E2PA->(dbCloseArea())
EndIf
	
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"E2PA")
E2PA->(dbGoTop())
If E2PA->(!Eof().And.!Bof()).And.E2PA->NREGS>0
	Aviso("PA em Aberto","Existe(m) PA(s) a ser(em) compensado(s)!"+chr(10)+chr(10)+;
						 "Execute a compensa��o deste(s) PA(s) antes de baixar o(s) t�tulo(s)!",{'Ok'})
	_lNTemPA := .F.
EndIf   

If Select("E2PA")>0
	E2PA->(dbCloseArea())
EndIf
		
Return(_lNTemPa)
