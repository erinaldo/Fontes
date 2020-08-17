#Include "RwMake.ch"
#include "Protheus.ch"
#include "Topconn.ch"                    
#define ENTER Chr(13)+Chr(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±			                                                               ±±
±± Funcao: FA080TIT  	Autor: Tatiana A. Barbosa	Data: 07/06/10   	   ±±
±±																		   ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±						  												   ±±
±±	Descricao: Faz verificação na confirmação da baixa 					   ±±
±± 				                                        				   ±±  
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±± 																		   ±±
±±			Alteracoes: 											 	   ±±
±±																		   ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±															  			   ±±
±±				Uso:  CSU 	                                               ±±
±±												  						   ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                                                                                       

User Function FA080Tit()

Local lFa080ta, lFa080tb, lFa080tit

If SM0->M0_CODIGO!="05"     

	lFa080ta := U_FA080TA() 
	lFa080tb := U_FA080TB()  
	
	If !lFa080ta .And. !lFa080tb
	   lFa080tit := .F.
	Else
	   lFa080tit := lFa080ta .And. lFa080tb
	EndIf   
	
Else
	lFa080tit := U_FA080TB()
EndIf

Return(lFa080tit)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FA080TA  º Autor ³ Daniel G.Jr.TI1239  º Data ³ 26/12/2007  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Faz verificação na confirmação da baixa                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Csu CardSystem - PE da rotina FINA080-Bx.Pagar Manual       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FA080TA()

local cQuery:=""
local _lNTemPA:=.T.

// Executa este PE somente para a empresa 05
If SM0->M0_CODIGO!="05"
	Return(.T.)
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
//MemoWrite("C:\FA080TIT.sql",_cQuery)
	
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
                                                         
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±			                                                               ±±
±± Funcao: FA080TB  	Autor: Tatiana A. Barbosa	Data: 07/06/10   	   ±±
±±																		   ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±						  												   ±±
±±	Descricao: Não permitir a baixa manual de títulos quando a data de     ±±
±± baixa for anterior a data de contabilização e a data de disponibilidade ±±
±± 				                                        				   ±±  
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±± 																		   ±±
±±			Alteracoes: 											 	   ±±
±±																		   ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±															  			   ±±
±±				Uso:  CSU 	                                               ±±
±±												  						   ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                                                                                       

User Function FA080TB()
                             
Local lRet		:= .T.

SE2->(DbSetOrder(1),DbSeek(xFilial("SE2")+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)))   //E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA

If M->DBaixa < SE2->E2_EMIS1 .Or. M->DBaixa < SE2->E2_DATALIB		// naturezas sintéticas e bloqueadas
		Aviso("Atenção !", "Data da Baixa: " +DtoC(M->DBaixa)+ENTER+ "A data de baixa não pode ser menor que as datas de contabilização (" +DtoC(SE2->E2_EMIS1)+ ") e de disponibilidade (" +DtoC(SE2->E2_DATALIB)+ ")." , {"Ok"}, 1 , "BAIXA NÃO PERMITIDA !" )
		lRet := .F. 
Endif 

                        
Return(lRet)