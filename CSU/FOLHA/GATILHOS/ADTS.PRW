#INCLUDE "rwmake.ch"

User Function ADTS()
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ADTS      |Autor  � Sandra R. Prada    � Data �  06/10/03   ���
�������������������������������������������������������������������������͹��
��� 																	  ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAGPE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

// Declaracao das Variaveis
                                                    
SetPrvt("_cSindicato,_cTipoADTS,_cCategoria") 

_cSindicato := M->RA_SINDICA   
_cCategoria := M->RA_CATFUNC 

If _cSindicato$"01*21" .AND. !_cCategoria $ "A*E*G" 
   _cTipoADTS := "T" 
Elseif _cSindicato$"06" .AND. !_CCategoria $ "A*E*G" // RECIFE 
   _cTipoADTS := "A" 
Elseif _cSindicato$"07" .AND. !_CCategoria $ "A*E*G" //R. JANEIRO
   _cTipoADTS := "A" 
Else
   _cTipoADTS := "N" 
Endif                                           

Return _cTipoADTS