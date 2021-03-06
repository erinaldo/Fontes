#include "rwmake.ch"        

User Function LP660_RET()                                  

SetPrvt("cFornec,cLoja,cPrefixo,cNum,cTipo,nValor,_aArea,_aAreaSE2,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � LP660_RET  � Autor � EDNEI C. MAURIZ   � Data � 08/12/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Execblock para pocionar no titulo principal e retornar o   ���
���          � valor liquido  e soma do PIS/COFINS/CSL retido "retencoes" ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � LANCAMENTOS  PADROES  660-002 / 660-006                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
����������������������������������������������������������������������������
/*/

cFornece := SF1->F1_FORNECE
cLoja    := SF1->F1_LOJA
cNum     := SF1->F1_DOC
//cPrefixo := SUBSTR(SF1->F1_ESPECIE,1,3) // OS 2697/14 By Douglas David
cPrefixo := SF1->F1_PREFIXO  
cTipo    := SF1->F1_TIPO

_aArea    := GetArea()
_aAreaSE2 := GetArea("SE2")

dbSelectArea("SE2")
dbSetOrder(6)
If dbSeek(xFilial("SE2")+cFornece+cLoja+cPrefixo+cNum)
//If dbSeek(xFilial("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+ALLTRIM(SF1->F1_ESPECIE)+SF1->F1_DOC)   
		nValor := (SE2->E2_VRETPIS+SE2->E2_VRETCOF+SE2->E2_VRETCSL)
Else
      nValor := 0
Endif    

RestArea(_aAreaSE2)
RestArea(_aArea)

Return(nValor)


