#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F390TIT   � Autor �CLAUDIO BARROS      � Data �  26/08/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada acionado no momento da alteracao na sele- ���
���          � cao do Mark Browse.                                        ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAFIN - FINA390                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function F390TIT()


Local _lRet := .T.

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������


IF ALLTRIM(SE2->E2_NATUREZ) == "9.99.99"

		MsgAlert("Titulo(s) Classificado(s) com natureza 9.99.99, Reclassifique!!!")
		_lVer := "1"

	_lRet := .F.
	Reclock("SE2",.F.) // Trava o registro
	SE2->E2_OK:=" "
	Msunlock() // Destrava o registro
	
Endif


Return(_lRet)
