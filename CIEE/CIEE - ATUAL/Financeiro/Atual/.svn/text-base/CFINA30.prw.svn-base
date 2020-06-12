#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFINA30   º Autor ³ Claudio Barros     º Data ³  01/07/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para tratar a contabilizacao das baixas, contas     º±±
±±º          ³ a pagar.                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAFIN - FINA080 - Especifico CIEE                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CFINA30(pOpcao)



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local lRET 
Local _cContaD
Local _cContaC
Local _cItemD
Local _cItemC
Local _cRet := " "
Local cAlias := GetArea()

Private cString := "SE2"


dbSelectArea("SE2")
/*
DbSetOrder(1)
SE2->(DBGOTOP())
*/

_aRetCont := CFINA30A(SE5->E5_PREFIXO,SE5->E5_NUMERO,SE5->E5_PARCELA,SE5->E5_TIPO,SE5->E5_CLIFOR,SE5->E5_LOJA,SE5->E5_DOCUMEN) // alterado por cg em 24/08/05



//SE2->(DBSEEK(xFILIAL("SE2")+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Lancamento na Baixa a Debito³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

IF pOpcao == "E2_CCONTCR"
   IF !EMPTY(_aRetCont[1][1])           
   _cContaD := _aRetCont[1][1]
ELSE   
   _cContaD := SA2->A2_CONTA
   ENDIF  
ENDIF

IF pOpcao == "E2_RED_CRE"
   IF !EMPTY(_aRetCont[1][2])
       _cItemD := _aRetCont[1][2]
   ELSE                           
       _cItemD := SA2->A2_REDUZ
   ENDIF      
ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Lancamento na Baixa a Credito³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

IF pOpcao == "E2_CCONTAB"
_cContaC := SA6->A6_CONTA 
ENDIF

IF pOpcao == "E2_REDUZ"
_cItemC := SA6->A6_CONTABI
ENDIF


Do Case 
   Case pOpcao == "E2_CCONTCR"
        _cRet := _cContaD
   Case pOpcao == "E2_CCONTAB"
        _cRet := _cContaC
   Case pOpcao == "E2_RED_CRE"
        _cRet := _cItemD
   Case pOpcao == "E2_REDUZ"
        _cRet := _cItemC
EndCase        
        
RestArea(cAlias)

Return(_cRet)                    


Static Function CFINA30A(pPar01,pPar02,pPar03,pPar04,pPar05,pPar06,pPar07) // alterado por cg em 24/08/05


Local _cQuery := " "
Local _cOfl   := CHR(13)+CHR(10)
Local _lRet   
Local _cConta := {}

// SE2->(DBSEEK(xFILIAL("SE2")+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA))


_cQuery := " SELECT E2_CCONTCR , E2_RED_CRE FROM "+ RetSqlName("SE2")+" "+ _cOfl
_cQuery += " WHERE D_E_L_E_T_ = ' ' AND  E2_FILIAL = '"+xFilial("SE2")+"' " + _cOfl
_cQuery += " AND E2_PREFIXO = '"+pPar01+"' AND E2_NUM = '"+pPar02+"' "+ _cOfl
_cQuery += " AND E2_PARCELA  = '"+pPar03+"' AND E2_TIPO = '"+pPar04+"' "+ _cOfl
_cQuery += " AND E2_FORNECE = '"+pPar05+"' AND E2_LOJA = '"+pPar06+"'  "+ _cOfl
_cQuery += " AND E2_NUMBOR = '"+pPar07+"'  "+ _cOfl //alterado por cg em 24/08/05
_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),'TRB',.T.,.T.)

DbSelectArea("TRB")

AADD(_cConta,{TRB->E2_CCONTCR,TRB->E2_RED_CRE})


If Select("TRB") > 0
   TRB->(DbCloseArea())
Endif
   

Return(_cConta)



