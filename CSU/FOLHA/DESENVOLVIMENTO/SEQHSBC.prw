#Include "rwmake.ch"

  
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fSeqHSBC  �Autor  �Isamu Kawakami      � Data �  17/06/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Numeracao Sequencial de Remessa de Arquivo CNAB            ���
���          � modelo 2 do Banco HSBC                                     ���
�������������������������������������������������������������������������͹��
���Uso       � CNAB mod 2 - LiqHSBC.2RE                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */
User Function fSeqHSBC()

 Local xSeq
 
   aOld := GETAREA()
   xSeq := StrZero( Val(GETMV( "MV_SEQHSBC" )),6 )

   dbSelectArea("SX6")
   If dbSeek( "  "+"MV_SEQHSBC" ) 
      RecLock("SX6",.F.)                    
       SX6->X6_CONTEUD := StrZero( Val(GETMV( "MV_SEQHSBC" ))+1,6 )              
       SX6->X6_CONTSPA := StrZero( Val(GETMV( "MV_SEQHSBC" ))+1,6 )              
       SX6->X6_CONTENG := StrZero( Val(GETMV( "MV_SEQHSBC" ))+1,6 )
      MsUnlock()
   EndIf
   RESTAREA( aOld )


Return( xSeq )

