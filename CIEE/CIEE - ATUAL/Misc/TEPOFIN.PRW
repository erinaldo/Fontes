#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO4     � Autor � AP6 IDE            � Data �  25/08/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/




USER FUNCTION F240OK


MSGINFO("Na rotina de cancelamento de bordero, apos verificar se o n�mero do bordero existe....","F240OK")


Return(.F.)


USER FUNCTION F240PCB
     MSGINFO("Apos procurar os registros que compoe o bordero a ser cancelado e antes de deletar os dados","F240PCB")
Return(.T.)                                                    

USER FUNCTION F240CAN
     MSGINFO("Apos deletar o registro no arquivo do SEA (Titulos enviados ao Banco) no cancelamento do bordero.","F240CAN")        
Return(.T.)

