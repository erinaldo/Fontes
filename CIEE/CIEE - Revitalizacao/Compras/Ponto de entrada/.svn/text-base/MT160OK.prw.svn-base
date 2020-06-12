#Include 'Protheus.ch'
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} MT160OK
Ponto de entrada no final da analise cotacao
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function MT160OK()
Local aAreaSC8	:= SC8->(GETAREA())
Local lRet			:= .t. 

DbSelectArea("SC8")
DbSetOrder(1)
DbGotop()
IF DbSeek(xFilial("SC8")+cA160num)	
	IF !EMPTY(SC8->C8_XGCT) // Este campo será preenchido quando for gerado o contrato pela rotina CCOME15
		lRet:= .F.	
	ENDIF
Endif	

RESTAREA(aAreaSC8)
Return lRet

