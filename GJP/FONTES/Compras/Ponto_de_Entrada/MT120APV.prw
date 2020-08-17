#INCLUDE 'Protheus.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT120APV  �Autor  �Lucas Riva Tsuda    � Data �  10/30/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Retorna o grupo de aprova��o para o Pedido de Compra.       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Especifico GJP                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT120APV

Local cRet    := ""
Local _cQuery := ""
Local cAlias  := GetNextAlias() 
Local aItens  := {}       
Local aRet    := {}
Local cMsg    := ""

//_cQuery :=  "SELECT C7_CC, B1_GRUPO, C7_PRODUTO "
_cQuery :=  "SELECT C7_CC, C7_PRODUTO "
//_cQuery +=  "FROM "+RetSqlName("SC7")+" SC7 INNER JOIN "+RetSqlName("SB1")+" SB1 "
_cQuery +=  "FROM "+RetSqlName("SC7")+" SC7 "
//_cQuery +=  "ON C7_FILIAL = B1_FILIAL AND C7_PRODUTO = B1_COD "
_cQuery +=  "WHERE SC7.C7_FILIAL = '"+cFilAnt+"' AND "
_cQuery +=  "SC7.C7_NUM = '"+SC7->C7_NUM+"' AND "  
//_cQuery +=  "SB1.D_E_L_E_T_ = '' "
_cQuery +=  "SC7.D_E_L_E_T_ = '' "
_cQuery := ChangeQuery(_cQuery)

If Select(cAlias) > 0
	dbSelectArea(cAlias)
	dbCloseArea()
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),cAlias,.T.,.F.)

DbSelectArea(cAlias)
(cAlias)->(dbGotop())
While (cAlias)->(!EOF()) 

	AADD(aItens, {(cAlias)->C7_PRODUTO, (cAlias)->C7_CC, SC7->C7_NUM})	                         
	(cAlias)->(DbSkip())

EndDo 

aRet    := U_MontaAlc(cFilAnt,aItens)  

If aRet[1][1] == "1"

	cRet := aRet[1][2]
	
Else
	
	cMsg += "Houve uma inconsist�ncia/div�rgencia no momento de selecionar o grupo de aprova��o deste PC. "
	cMsg += "O sistema ir� gerar a al�ada com o grupo default contido no parametro MV_PCAPROV."
	MsgAlert(cMsg)
	
	cRet := SuperGetMv("MV_PCAPROV")
	
EndIf

Return cRet