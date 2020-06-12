#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F050RAT   �Autor  �Emerson             � Data �  02/07/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�� Alteracao: Emerson Natali : Dia:01/03/12                                ��
�� Na versao 10 a tabela de rateio era TMP1                                ��
�� AGORA NA VERSAO 11 ESTA SOMENTE COMO TMP                               ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function F050RAT()
_lRet      := .T.
_aArea     := GetArea()
_nValEncar := 0
_nValor    := 0

If M->E2_ISS > 0 .or. M->E2_IRRF > 0 .or. M->E2_INSS > 0 .or. M->E2_PIS > 0
	DbSelectArea("TMP")
	DbGotop()
	Do While !EOF()
		If !TMP->CTJ_FLAG
			_nValEncar += TMP->CTJ_ENCARG
		EndIf
		DbSelectArea("TMP")
		DbSkip()
	EndDo
	If _nValEncar <> M->E2_ISS + M->E2_IRRF + M->E2_INSS + M->E2_PIS
		MsgBox("Total dos Encargos digitado nao confere")
		_lRet := .F.
	EndIf
EndIf

DbSelectArea("TMP")
DbGotop()

Do While !EOF()
	If !TMP->CTJ_FLAG
		_nValor += TMP->CTJ_VALOR
	EndIf
	DbSelectArea("TMP")
	DbSkip()
EndDo

If _nValor <> M->E2_VALOR + M->E2_ISS + M->E2_IRRF + M->E2_INSS + M->E2_PIS
	Help("",1,"FA050RATEI")
	_lRet := .F.
EndIf

DbSelectArea("TMP")
DbGotop()

Restarea(_aArea)

Return(_lRet)
