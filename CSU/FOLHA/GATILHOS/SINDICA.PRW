#INCLUDE "rwmake.ch"

User Function SINDICA()
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SINDICA   |Autor  � Sandra R. Prada    � Data �  06/10/03   ���
�������������������������������������������������������������������������͹��
��� 																	  ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAGPE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

// Declaracao das Variaveis
                                                    
SetPrvt("_cFilial,_cSindicato") 

_cFilial	:= xFilial("SRA") 
_cSindicato := " "          

//_nHrsMensais:= M->RA_HRSMES      
//_CodFuncao  := M->RA_CODFUNC

/* desabilitado pela OS 0463/15 By Isamu K.
If _nHrsMensais <= 125  // SAO PAULO
	_cSindicato := "30"
ElseIf _cFilial $"02*03*04"  .and. _nHrsMensais > 125 // SAO PAULO
	_cSindicato := "01"          
Elseif _cFilial $"01*13"  .AND. _nHrsMensais > 125 .and. _CodFuncao <> "0350"// SANTO ANDRE
	_cSindicato := "21"          	
Elseif _cFilial $"06/12" .AND. _nHrsMensais > 125 .and. _CodFuncao <> "0350"// RECIFE
	_cSindicato := "06"
Elseif _cFilial $"05" .AND. _nHrsMensais > 125 .and. _CodFuncao <> "0350"// SALVADOR
	_cSindicato := "11"	
Elseif _cFilial $"07" .AND. _nHrsMensais > 125 .and. _CodFuncao <> "0350" // B. HORIZONTE 
	_cSindicato := "12"	
Elseif _cFilial $"10" .AND. _nHrsMensais >= 125 .and. _CodFuncao <> "0350" // R. JANEIRO 
	_cSindicato := "07"		
Elseif _cFilial $"11" .AND. _nHrsMensais >= 125 .and. _CodFuncao <> "0350" // CURITIBA
	_cSindicato := "24"		
Endif    
*/

//Alterado pela OS 0463/15  By Isamu K.
If _cFilial $"02*03"   // SAO PAULO
	_cSindicato := "01"          
Elseif _cFilial $"06/12" // RECIFE
	_cSindicato := "08"
Elseif _cFilial $"07"  // B. HORIZONTE 
	_cSindicato := "12"	
Elseif _cFilial $"18"  // Alpha 
	_cSindicato := "25"		
Endif                                       

Return _cSindicato 