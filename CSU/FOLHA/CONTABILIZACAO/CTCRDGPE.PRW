#INCLUDE "rwmake.ch"
                               
User Function CTCRDGPE()
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CTCRDGPE   |Autor � Sandra R. Prada    � Data �  05/08/03   ���
�������������������������������������������������������������������������͹��
��� 																	  ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAGPE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

// Declaracao das Variaveis
                                                    
SetPrvt("_cSitfolh,_TPCCUSTO,_CTACRED") 

_cSitfolh := " "    
_TPCCUSTO := " " 
_CTACRED  := " " 

 DbSelectArea("SRA")
 DbSetOrder(1)                              

 If DbSeek(SRZ->RZ_FILIAL + SRZ->RZ_MAT)
    _cSitfolh := SRA->RA_SITFOLH 
    _demissa  := SRA->RA_DEMISSA
 Endif 

 _dtperiodo := dDataBase //"31/"+subs(mv_par01,1,2)+"/"+subs(mv_par01,3,4)
 
 DbSelectArea("CTT")
 DbSetOrder(1) 
 
  If DbSeek("  "+SRZ->RZ_CC)                             
     _TPCCUSTO := CTT->CTT_GRUPO
  Endif 

If SRV->RV_LCTOP <> SPACE(3)
  If _cSitfolh <> 'D' .AND. _TPCCUSTO = "01"
       _CTACRED := SRV->RV_CTCRED1
  ElseIf _cSitfolh <> 'D' .AND. _TPCCUSTO = "02"
         _CTACRED := SRV->RV_CTCRED2
  ElseIf _cSitfolh == 'D' .AND._demissa > _dtperiodo .AND. _TPCCUSTO = "01"
         _CTACRED := SRV->RV_CTCRED1       
  ElseIf _cSitfolh == 'D' .AND._demissa > _dtperiodo .AND. _TPCCUSTO = "02"
         _CTACRED := SRV->RV_CTCRED2         
  ElseIf _cSitfolh == 'D' .AND. _demissa <= _dtperiodo .AND. _TPCCUSTO = "01"
         _CTACRED := SRV->RV_CTCRED3
  ElseIf _cSitfolh == 'D' .AND. _demissa <= _dtperiodo .AND. _TPCCUSTO = "02"
         _CTACRED := SRV->RV_CTCRED4       
//  Else 
//       _CTACRED := "ERRO"       
  Endif                      
Endif   
                                                  
Return _CTACRED