#INCLUDE "rwmake.ch"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} A100DEL
Ponto de Entrada para validar a exclusão da Nota de entrada quando o movimento contabil 
for Real ou efetivado 
@author     Totvs
@since     	01/01/2015
@version  	P.11.8      
@param 		Nenhum
@return    	Nenhum
@obs        Ele atualiza alguns campos da aba Compras e Ultima Compra do cadastro de fornecedores
Alterações Realizadas desde a Estruturação Inicial
------------+-----------------+----------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                                                                                 
------------+-----------------+----------------------------------------------------------
		  	|				  | 
------------+-----------------+----------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
User Function A100DEL()
Local aArea 	:= GetArea()
Local cQuery 	:= " "
Local lRet 	:= .T. 
Local cTab		:= GetNextAlias()  


cQuery := " SELECT CT2_DATA, CT2_LOTE, CT2_SBLOTE, CT2_DOC, CT2_LINHA,CT2_TPSALD FROM "+RetSqlName("CT2")
cQuery += " WHERE D_E_L_E_T_ =''"
cQuery += " AND CT2_KEY = '"+xFilial("SF1")+SF1->F1_SERIE+SF1->F1_DOC+SF1->F1_FORNECE+SF1->F1_LOJA+"'"
cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTab,.T.,.T.)
TcSetField(cTab,"CT2_DATA","D",8, 0 )

If (cTab)->CT2_TPSALD == "1"
	MsgAlert("Exclusão não permitida, contabilização efetivada, Informe a contabilidade!!")
    lRet := .F.	
EndIf

(cTab)->(DbcloseArea())
   
RestArea(aArea)
Return(lRet)