#Include "RwMake.ch"
#include "Protheus.ch"
#include "Topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ F240Tit  º Autor ³ Ricardo Luiz Rocha  º Data ³ 07/07/2004  º±±
±±º          ³          º       ³ DTS Consulting      º        GNSJC       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ PE na marcacao de titulos do bordero de pagamentos          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Csu CardSystem                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function F240Tit()

local _bNovo:={|THIS|u_Fa240P(oMark)}
local cQuery:=""
local _lTemPA:=.F.

// Verificar PA somente para a empresa 05
If SM0->M0_CODIGO!="05"
	_lTemPA:=.F.
Else
	
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
	//MemoWrite("C:\F240TIT.sql",_cQuery)
	
	If Select("E2PA")>0
		E2PA->(dbCloseArea())
	EndIf
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"E2PA")
	E2PA->(dbGoTop())
	If E2PA->(!Eof().And.!Bof()).And.E2PA->NREGS>0
		Aviso("PA em Aberto","Existe(m) PA(s) a serem compensados!"+chr(10)+chr(10)+;
		"Execute a compensação deste(s) PA(s) antes de incluír este título no Borderô!",{'Ok'})
		_lTemPA := .T.
	EndIf
	
	If Select("E2PA")>0
		E2PA->(dbCloseArea())
	EndIf
EndIf
if type("ODlg1")=="O".and.oDlg1:aControls[16]:bAction<>_bNovo.and.!_lTemPA
	oDlg1:aControls[16]:bAction:=_bNovo
endif
return(Iif(_lTemPA,.F.,.T.))//paramixb - 20/07/04 - Retorna .T. possibilitando que o bordero venha selecionado.
*---------------------------------------------------------------------------------------------------------------
user Function Fa240P(oMark)
*---------------------------------------------------------------------------------------------------------------
Local cAliasAnt := Alias(),nRecno

DbSelectArea("SE2")
nRecno := Recno()
AxPesqui()

// Se o que foi digitado para pesquisa nao estiver dentro do filtro
// Continua no mesmo registro que estava antes de selecionar CTRL-P
If !&(Fa240ChecF())
	dbGoto(nRecNo)
Endif
oMark:oBrowse:Refresh(.T.)

DbSelectArea(cAliasAnt)

Return Nil
