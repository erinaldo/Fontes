#Include 'Rwmake.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT120FIL  �Autor  � Sergio Oliveira    � Data �  Out/2006   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada que filtra lizacao da base de dados no    ���
���          �pedido de compras para gerar a alcada de aprovacao.         ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT120FIL()

Local _cFilter 	:= ""
Local aGrupo 	:= UsrGrComp(RetCodUsr())
Local cUsers    := U_GetUsrPc()
Local cEol      := Chr(13)+Chr(10)

If !(Len(aGrupo) > 0) // Caso o usuario NAO possua grupo de compras, fazer o teste abaixo:
    If !AllTrim( Upper(cUserName) ) $ Upper( GetNewPar( 'MV_X_MASTR','MICROSIGA' ) )	
		If !(AllTrim(Upper( cUserName )) $ UPPER(cUsers)) 
			_cFilter := "C7_USER == '"+__cUserId+"'"	
		Endif
	EndIf
Endif

Return _cFilter     