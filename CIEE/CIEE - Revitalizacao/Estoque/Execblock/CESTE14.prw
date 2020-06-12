#INCLUDE "rwmake.ch"    
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CESTE14
Valida a exclusão da Nota de entrada quando o movimento contabil for Real ou efetivado 
@author     Totvs
@since     	01/01/2014
@version  	P.11      
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum
Alterações Realizadas desde a Estruturação Inicial
------------+-----------------+----------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                                                                                 
------------+-----------------+----------------------------------------------------------
		  	|				  | 
------------+-----------------+----------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
User Function CESTE14()    
Local _cAlias 	:= GetArea()
Local _cQuery	:= ""
Local _cFl 		:= CHR(13)+CHR(10)
Local _lRet 	:= .T. 
Local cTab		:= GetNextAlias() 


dbSelectArea("CT2")
dbSetOrder(1)


_cQuery := " SELECT CT2_DATA, CT2_LOTE, CT2_SBLOTE, CT2_DOC, CT2_LINHA,CT2_TPSALD "+_cFl
_cQuery += " FROM "+RetSqlName("CT2")+"  "+_cFl
_cQuery += " WHERE D_E_L_E_T_ = ''  "+_cFl
_cQuery += " AND CT2_KEY = '"+xFilial("SF1")+SF1->F1_SERIE+SF1->F1_DOC+SF1->F1_FORNECE+SF1->F1_LOJA+"' "+_cFl

_cQuery := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),cTab,.T.,.T.)


TcSetField(cTab,"CT2_DATA","D",8, 0 )

If (cTab)->CT2_TPSALD == "9"
	Dbselectarea("CT2")
	CT2->(DbSetorder(1))
	CT2->(Dbgotop())
	
	CT2->(Dbseek(xFilial("CT2")+Dtos((cTab)->CT2_DATA)+(cTab)->CT2_LOTE+(cTab)->CT2_SBLOTE+(cTab)->CT2_DOC))	

    _cData   := (cTab)->CT2_DATA
    _cLote   := (cTab)->CT2_LOTE
    _cSblote := (cTab)->CT2_SBLOTE
    _cDoc    := (cTab)->CT2_DOC
    _cLinha  := (cTab)->CT2_LINHA
		

	While CT2->CT2_FILIAL == xFilial("CT2") .AND. CT2->CT2_DATA == _cData .AND. CT2->CT2_LOTE == _cLote .AND.;
	      CT2->CT2_SBLOTE == _cSblote .AND. CT2->CT2_DOC == _cDoc 
	      
		RecLock("CT2",.F.)
		CT2->CT2_XUSER	:= cUserName
		CT2->CT2_XDTEXL	:= dDataBase
		CT2->(DbDeLete())
		CT2->(MsUnlock())
		CT2->(DBSKIP())
	End  
	
EndIf

(cTab)->(DbcloseArea())
   
RestArea(_cAlias)
Return(_lRet)