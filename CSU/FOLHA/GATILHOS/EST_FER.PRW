#INCLUDE "rwmake.ch"

User Function EST_FER()
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EST_FER   |Autor  � Sandra R. Prada    � Data �  30/10/03   ���
�������������������������������������������������������������������������͹��
��� 																	  ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAGPE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

// Declaracao das Variaveis
                                                    
SetPrvt("_dDataFim,_dDataEstab,_dDataValida,_dDtEstAtu") 

_dDataFim 	 := M->RH_DATAFIM 
_dDataEstab  := (M->RH_DATAFIM + M->RH_DFERIAS)
_dDataValida := CTOD(" ") 
_dDtEstAtu   := SRA->RA_DTVTEST 
  
If _dDataEstab > _dDtEstAtu
   _dDataValida := _dDataEstab
Else 
   _dDataValida := _dDtEstAtu
Endif               

If _dDataValida <> CTOD(" ")

   RECLOCK("SRA",.F.)           
     SRA->RA_DTVTEST := _dDataValida 
   MSUNLOCK()     
   
Endif    
    
Return _dDataValida 