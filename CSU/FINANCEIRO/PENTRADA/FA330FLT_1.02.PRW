#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA330FLT  �Autor  �                    � Data �  26/09/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �verificar a empresa que ira gerar a contabiliza��o          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FA330FLT()

Alert("Para compensar o titulo posicione-se na empresa correta onde o mesmo foi incluido")

Processa({|| _Filtra() })

Return

Static Function _Filtra()                               

ProcRegua(3)

Incproc("Filtrando Registros...")
DBSelectArea("SE1")
Incproc("Filtrando Registros...")
Set Filter to SUBSTR(ALLTRIM(SE1->E1_PREFIXO),1,2) == ALLTRIM(SM0->M0_CODIGO) .AND. SE1->E1_FILIAL == xFilial("SE1")
Incproc("Filtrando Registros...")

Return
