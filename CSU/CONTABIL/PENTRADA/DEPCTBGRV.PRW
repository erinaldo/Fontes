#Include "Protheus.ch"
#Include "TopConn.ch" 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DEPCTBGRV �Autor  �Vin�cius Greg�rio   � Data �  20/01/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada ap�s a grava��o do lan�amento cont�bil.    ���
���          �                                                            ���
���          �Utilizado para a grava��o da chave dos lan�amentos para     ���
���          �o processamento de rateios externos de documentos de entrada���
���          �                                                            ���
���          �Utilizado tambem para gravar informacoes na tabela ZF1 que  ���
���          �sera lido na geracao do razario.                            ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function DEPCTBGRV()

Local aArea	:= GetArea()
Local _aAreaCT2 := CT2->(GetArea())
Local _dData    := PARAMIXB[2]
Local _cLote    := PARAMIXB[3]
Local _cSubL    := PARAMIXB[4]
Local _cDoc     := PARAMIXB[5]            
Local _cLinha   := ""
Local _cQuery   := ""
Local _cCodCli  := ""
Local _cCodFor  := ""
Local _cCodPrj  := ""
Local _cOrigem  := "" 
Local _lGrava

//������������������������������Ŀ
//�Verifica se a grava��o veio da�
//�rotina de processamento de    �
//�rateios externos.             �
//��������������������������������
If IsInCallStack("U_RCTBMA1") .and. PARAMIXB[1]==3
	dbSelectArea("SF1")
	RecLock("SF1",.F.)
	SF1->F1_XCHVCT2	:= xFilial("CT2")+DtoS(PARAMIXB[2])+PARAMIXB[3]+PARAMIXB[4]+PARAMIXB[5]
	SF1->(MsUnlock())
Endif

//������������������������������Ŀ
//�Apenas para contabilizacao TXT�
//��������������������������������
If IsInCallStack("CTBA500") .And. PARAMIXB[1] == 3
	_cQuery := "SELECT CT2.R_E_C_N_O_ AS RECNO FROM " + RetSqlName("CT2") + " CT2 WHERE "
	_cQuery += "CT2.CT2_FILIAL = '" + xFilial("CT2") + "' AND "
	_cQuery += "CT2.CT2_DATA = '" + Dtos(_dData) + "' AND "
	_cQuery += "CT2.CT2_LOTE = '" + _cLote + "' AND "
	_cQuery += "CT2.CT2_SBLOTE = '" + _cSubL + "' AND "
	_cQuery += "CT2.CT2_DOC = '" + _cDoc + "' AND "
	_cQuery += "CT2.D_E_L_E_T_ = ' ' "
	_cQuery += "ORDER BY CT2_LINHA"
	
	U_MontaView( _cQuery, "TCT2" )
	TCT2->(dbGoTop())
	While !TCT2->(EOF())
		dbSelectArea("CT2")
		dbGoTo(TCT2->RECNO)
		_cCodFor := SubStr(CT2->CT2_ORIGEM,11,6)
		_cCodCli := SubStr(CT2->CT2_ORIGEM,17,6)
		_cCodPrj := SubStr(CT2->CT2_ORIGEM,23,10)   // OS 0496/15 By Douglas David
		_cOrigem := Left(CT2->CT2_ORIGEM,10)
		_cLinha  := CT2->CT2_LINHA
		_lGrava  := CT2->CT2_DC <> "4"
		RecLock("CT2",.F.)
			CT2->CT2_ORIGEM := _cOrigem
		MsUnlock()
	
		If _lGrava
			dbSelectArea("ZF1")
			RecLock("ZF1",.T.)
				ZF1->ZF1_FILIAL  := xFilial("ZF1")
				ZF1->ZF1_DATA    := _dData
				ZF1->ZF1_LOTE    := _cLote
				ZF1->ZF1_SBLOTE  := _cSubL
				ZF1->ZF1_DOC     := _cDoc
				ZF1->ZF1_LINHA   := _cLinha
				ZF1->ZF1_CODFOR  := _cCodFor
				ZF1->ZF1_CODCLI  := _cCodCli   
				ZF1->ZF1_CODPRJ  := _cCodPrj // OS 0496/15 By Douglas David
			MsUnlock()
		EndIf
		TCT2->(dbSkip())
	EndDo
	TCT2->(dbCloseArea())
EndIf


RestArea(aArea)                  
RestArea(_aAreaCT2)

Return .T.