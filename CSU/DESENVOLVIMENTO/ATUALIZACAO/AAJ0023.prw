#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AAJ0023   � Autor � ADALBERTO ALTHOFF  � Data �  15/02/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado para atender a OS 0370/05 (hist. salarial)   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function AAJ0023

Processa({|lEnd| AAJ0023Processa(),"(SR3) Processando a altera��o dos tipos..."})

STATIC FUNCTION AAJ0023Processa()

ProcRegua( SR3->(RecCount()))

dbSelectArea("SR3")
dbSetOrder(1)
dbGoTop()

do while !eof()        

	IncProc("(SR3) Processando a altera��o dos tipos...")

	if r3_tipo == "005"
		RecLock( "SR3" , .F. )
		r3_tipo := "105"
		MsUnLock()
	endif	

	dbSkip()

enddo

Return