#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �  GPEM    � Autor �Isamu K.               � Data � 17/09/14 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Ponto de Entrada na Geracao do CNAB                        ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � Chamada padr�o para programas em RDMake.                   ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
User Function GP410DES  

Local lRet := .T.

If lAdianta  //adiantamento
   If Sra->Ra_BloqLiq $ "2*8" 
      lRet := .F.
   Endif
ElseIf lFolha //Folha
   If Sra->Ra_BloqLiq $ "1*8"
      lRet := .F.
   Endif
ElseIf lPrimeira //1a parcela
   If Sra->Ra_BloqLiq $ "5*8"
      lRet := .F.
   Endif
ElseIf lSegunda //2a parcela
   If Sra->Ra_BloqLiq $ "6*8"
      lRet := .F.
   Endif
ElseIf lFerias //Ferias
   If Sra->Ra_BloqLiq $ "3*8"
      lRet := .F.
   Endif
ElseIf lExtras //Extras
   If Sra->Ra_BloqLiq $ "7*8"
      lRet := .F.
   Endif
ElseIf lRescisao //Rescisao
   If Sra->Ra_BloqLiq $ "4*8"
      lRet := .F.
   Endif
Endif      


Return(lRet)