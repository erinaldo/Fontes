#include "Protheus.ch"
#include "TopConn.ch"
                             
/*---------------------------------------------------------------------------------------
{Protheus.doc} F240Bord
P.E. após gravação do Bordero - Gera alçada de aprovação.

@class		Nenhum
@from 		Nenhum
@param    	Nenhum
@attrib    	Nenhum
@protected  Nenhum
@author     AF Custom
@version    P.11
@since      01/10/2014
@return    	Nenhum
@sample   	Nenhum
@obs      	Nenhum
@project    CIEE - Revitalização
@menu    	Nenhum
@history    Nenhum
---------------------------------------------------------------------------------------*/
User Function F240Bord()
    
Local cDoc:=cNumBor//-- Private FINA240  
Local nValBord:=nValor//--Private FINA240
Local aArea:=GetArea()
Local cGrpAprov:=GetMv('CI_GRPFIWF',,'')

If Empty(cGrpAprov)
	MsgAlert('Não há Grupo de Aprovação definido para geração de alçada.')
	Return()
EndIf         
                                    
cDoc+='_1'//--Primeira aprovação
cDoc:=PadR(cDoc,TamSx3('CR_NUM')[1])

Begin Transaction
//-- Gera alçada de aprovação      	
MaAlcDoc({;
		cDoc,			;	//[1] Numero do documento
		'BP',			;   //[2] Tipo de Documento --> BP=Bordero Pagamento
		nValBord,  		;   //[3] Valor do Documento
		"",				; 	//[4] Codigo do Aprovador
		__cUserId,		;   //[5] Codigo do Usuario
		cGrpAprov,		;	//[6] Grupo do Aprovador
		"",				;   //[7] Aprovador Superior
		,				;   //[8] Moeda do Documento		
		,				;   //[9] Taxa da Moeda
		dDataBase,		;   //[10] Data de Emis.Doc.
		""}				;	//[11] Grupo de Compras
		,dDataBase,1,"",.F.)
	      
//-- Atualiza Contas a Pagar  
cQuery:=" Update "+RetSqlName('SE2')
cQuery+=" Set "
cQuery+=" E2_XSOLAPV='"+__cUserID+"',"//Solicitante da aprovação
cQuery+=" E2_XSTSAPV='0'"//Status da Aprovação
cQuery+=" Where E2_FILIAL='"+xFilial('SE2')+"' AND E2_NUMBOR='"+cNumBor+"' AND D_E_L_E_T_=''"
TcSqlExec(cQuery)

//-- Envio do WF para aprovação pelo Job TES006WF().
End Transaction

RestArea(aArea)
Return