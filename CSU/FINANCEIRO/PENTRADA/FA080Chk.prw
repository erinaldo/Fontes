#Include "RwMake.ch"
#include "Protheus.ch"
#include "Topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FA080CHK º Autor ³ Daniel G.Jr.TI1239  º Data ³ 26/12/2007  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Faz verificação antes de baixar por lote                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Csu CardSystem - PE da rotina FINA080-Bx.Pagar Manual       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FA080Chk()

local cQuery:=""
local _lNTemPA:=.T.

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ OS 2136/08: Se a data base for superior a data do dia, nao permitir:       ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
If dDataBase > Date()
	cTxtBlq := "A data base é superior a data de Hoje. Operação não permitida. "
	Aviso("DATA BASE INVALIDA",cTxtBlq,;
	{"&Fechar"},3,"DataBase Superior",,;
	"PCOLOCK")
	Return( .f. )
EndIf

// Verifica se há título de PA para o PC da NF que originou este título; 
// Se houver a rotina impede que ele seja selecionado			** Incluído por Daniel G.Jr. em 21/12/07
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
MemoWrite("C:\FA080CHK.sql",cQuery)
	
If Select("E2PA")>0
	E2PA->(dbCloseArea())
EndIf
	
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"E2PA")
E2PA->(dbGoTop())
If E2PA->(!Eof().And.!Bof()).And.E2PA->NREGS>0
	Aviso("PA em Aberto","Existe(m) PA(s) a serem compensados!"+chr(10)+chr(10)+;
						 "Execute a compensação deste(s) PA(s) antes de baixar o(s) título(s)!",{'Ok'})
	_lNTemPA := .F.
EndIf   

If Select("E2PA")>0
	E2PA->(dbCloseArea())
EndIf
		
Return(_lNTemPa)