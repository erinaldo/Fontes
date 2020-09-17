#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �X7ATF1    �Autor  �Edivaldo/Douglas    � Data �  30/08/17   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Gatilho Ativo - OS 2218/17                                ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function X7ATF1()

Local cGrupo:= M->N1_GRUPO
Local cCUnid:= M->N1_CODUNID
Local cGat	:= " "

If (cGrupo $ "|1   |2   |3   |4   |13  |14  |15  |16  |17  |18  |21  |54  |56  |57  |66  |67  |68  |69  |70  |71  |" .AND. cCUnid $ "|02A|02 |03 |04 |05 |06 |07 |08 |09 |10 |")
	cGat := "2"
ElseIf (cGrupo $ "|5   |6   |7   |8   |9   |10  |11  |12  |19  |20  |22  |23  |24  |25  |26  |27  |28  |29  |30  |31  |58  |59  |60  |61  |62  |63  |64  |65  |72  |73  |74  |75  |76  |78  |" .AND. cCUnid $ "|02A|03 |04 |08 |09 |")
	cGat := "2"
ElseIf (cGrupo $ "|5   |6   |7   |8   |9   |10  |11  |12  |19  |20  |22  |23  |24  |25  |26  |27  |28  |29  |30  |31  |58  |59  |60  |61  |62  |63  |64  |65  |72  |73  |74  |75  |76  |78  |" .AND. cCUnid $ "|02 |05 |06 |07 |10 |")
	cGat := "1"
Else
	cGat := " "
Endif

Return(cGat)