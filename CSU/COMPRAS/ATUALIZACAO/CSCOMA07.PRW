#INCLUDE 'RWMAKE.CH'
/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
��� Programa   � CSCOMA07.PRW � Autor � Flavio Novaes   � Data � 12/04/2007 ���
���������������������������������������������������������������������������Ĵ��
��� Descricao  � Validacao do Campo F1_DOC, nao permitindo digitacao do Nu- ���
���            � mero da Nota Fiscal de Entrada com menos de seis Digitos e ���
���            � mostrando mensagem.                                        ���
���������������������������������������������������������������������������Ĵ��
��� Uso        � Exclusivo CSU.                                             ���
���������������������������������������������������������������������������Ĵ��
��� Observacao �                                                            ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
USER FUNCTION CSCOMA07()
IF LEN(ALLTRIM(M->CNFISCAL)) < 9
	M->CNFISCAL := REPL('0',TAMSX3('F1_DOC')[1]-LEN(ALLTRIM(M->CNFISCAL)))+ALLTRIM(M->CNFISCAL)
//	GETREFRESH()   - Comentado devido a erro ap�s atualiza��o OS 0628/14 By Douglas David
ENDIF
RETURN(.T.)