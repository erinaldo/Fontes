#Include 'Rwmake.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NFEINICC  �Autor  � Sergio Oliveira    � Data �  Abr/2010   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada executado ao clicar no botao de rateio na ���
���          � nota fiscal de entrada pra nao permitir a utilizacao de    ���
���          � rateios padrao do sistema.                                 ���
�������������������������������������������������������������������������͹��
���Uso       � MATA103 - NF de Entrada                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function NFEINICC()

Local cTxtBlq
Local cEol := Chr(13)+Chr(10)

cTxtBlq := "Este bot�o n�o poder� ser utilizado para criar o rateio das notas fiscais. "+cEol+cEol
cTxtBlq += "Solu��o: Insira os dados desta nota fiscal e confirme a operacao. Na pr�xima tela o sistema "
cTxtBlq += "solicitar� informar quais ser�o os rateios referentes a esta nota."
Aviso("RATEIO NA NOTA FISCAL",cTxtBlq,{"&Fechar"},3,"Momento Correto",,"PCOLOCK")

Return(.f.)