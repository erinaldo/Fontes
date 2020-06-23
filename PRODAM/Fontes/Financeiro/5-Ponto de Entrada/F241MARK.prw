#Include 'Protheus.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � F241MARK  � Autor � TOTVS                � Data � 12/09/15 ���
�������������������������������������������������������������������������Ĵ��
��� Descri��o � O ponto entrada F240MARK altera as posi��es dos            ��
��� campos de tela MarkBrowse fonte                                        ��
�����������������������������������������������������������������������������
���Sintaxe   �							           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function F241MARK()
Local aArea := GetArea()
Local aRet  := PARAMIXB
Local cTitulo := ""
Local aRetReturn := {}

If !Empty(aRet)

	AADD(aRetReturn,aRet[1]) //E2_OK - Tem que ser sempre o primeiro Campo 
	
	DbSelectArea("SX3")
	DbSetOrder(2)
	If DbSeek("E2_XORDLIB")
		cTitulo := X3Titulo()
	EndIf
	AADD(aRetReturn,{"E2_XORDLIB","",cTitulo,""})
	
	If DbSeek("E2_DATALIB")
		cTitulo := X3Titulo()
	EndIf
	AADD(aRetReturn,{"E2_DATALIB","",cTitulo,""})
	
	For _nY := 2 to len(aRet)
		AADD(aRetReturn,aRet[_nY])
	Next _nY

Else
	Return aRet
EndIf

RestArea(aArea)

Return aRetReturn