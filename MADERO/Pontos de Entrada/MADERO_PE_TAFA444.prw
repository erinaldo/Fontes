#Include "Protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � TAFA444  �Autor  � Vin�cius Moreira   � Data � 27/06/2018  ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada MVC da rotina de Evento Tributario.       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function TAFA444

Local aParam		:= PARAMIXB
Local xRet			:= .T.
Local oModel		:= ""
Local cIdPonto		:= ""
Local cIdModel		:= ""
Local lIsGrid		:= .F.
Local cTipoEfe		:= ""
Local cCodTrib		:= ""
Local aArea			:= { }
Local nTipo			:= 0

If aParam <> NIL
	oModel		:= aParam[1]
	cIdPonto	:= AllTrim(aParam[2])
	cIdModel	:= aParam[3]
	lIsGrid		:= (Len(aParam) > 3)
	
	If cIdPonto == "BUTTONBAR"
		xRet := { {'Titulo Efetivo', 'SALVAR', { || U_RTAFM01C( ) }, 'Titulo Efetivo' } }
	ElseIf cIdPonto == "FORMPRE"
		If IsInCallStack( "TAF444Open" )
			aArea 		:= CWV->( GetArea( ) )
			cTipoEfe	:= PadR( SuperGetMV( "ES_TEFTAF"	,, "TX" )	, Len( SE2->E2_TIPO ), " " )
			cCodTrib 	:= Posicione("T0J",1,xFilial("T0J")+CWV->CWV_IDTRIB,"T0J_CODIGO")
			If cCodTrib == "000001"
				nTipo 	:= 1
			ElseIf cCodTrib == "000002"
				nTipo 	:= 2
			EndIf
			If nTipo > 0 
				xRet := U_RTAFM01( nTipo, 5, 0, CWV->CWV_FIMPER, , cTipoEfe, , .F. )
			EndIf
			RestArea( aArea )
		EndIf
	EndIf
EndIf

Return xRet