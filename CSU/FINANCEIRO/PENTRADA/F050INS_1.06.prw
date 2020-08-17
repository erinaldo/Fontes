#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F050INS   �Autor  �Daniel Paiva        � Data �  06/24/02   ���
�������������������������������������������������������������������������͹��
���Desc.     � PE F050INS E F050IRF p/ alimentar campos dos titulos       ���
���          � de IRRF , INSS e ISS                                       ���
�������������������������������������������������������������������������͹��
���Uso       � AP6                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � PE F050PIS, F050COF E F050CSL p/alimentar campos dos titulos��
���02/03/04  � de PIS, COFINS E CSLL                                      ���
�������������������������������������������������������������������������͹��

�����������������������������������������������������������������������������
*/

User Function F050INS()

_nRec := ParaMixb
_aArea := GetArea()

DBSelectArea("SE2")
DBGoto(_nRec)

_cCusto   := SE2->E2_CCUSTO
_cNaturez := SE2->E2_NATUREZ 
_cHist    := SE2->E2_TIPO+"/ "+SE2->E2_NUM+" - "+SE2->E2_RSOCIAL
_cKey     := E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA


RestArea(_aArea)

Reclock("SE2",.F.)
SE2->E2_CCUSTO  := _cCusto
SE2->E2_HIST    := _cHist
SE2->E2_CSUKEY  := _cKey

MsUnlock()

Return

User Function F050IRF()

_nRec := ParaMixb
_aArea := GetArea()

DBSelectArea("SE2")
DBGoto(_nRec)

_cCusto := SE2->E2_CCUSTO   
_cNaturez := SE2->E2_NATUREZ  
_cHist    := SE2->E2_TIPO+"/ "+SE2->E2_NUM+" - "+SE2->E2_RSOCIAL
_cKey     := E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA


RestArea(_aArea)

Reclock("SE2",.F.)
SE2->E2_CCUSTO := _cCusto   
SE2->E2_HIST   :=_cHist
SE2->E2_CSUKEY := _cKey  

MsUnlock()

Return

User Function F050ISS()

_nRec := ParaMixb
_aArea := GetArea()

DBSelectArea("SE2")
DBGoto(_nRec)

_cCusto := SE2->E2_CCUSTO   
_cNaturez := SE2->E2_NATUREZ  
_cHist    := SE2->E2_TIPO+"/ "+SE2->E2_NUM+" - "+SE2->E2_RSOCIAL
_cKey     := E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA


RestArea(_aArea)

Reclock("SE2",.F.)
SE2->E2_CCUSTO := _cCusto   
SE2->E2_HIST   :=_cHist
SE2->E2_CSUKEY := _cKey  

MsUnlock()

Return
//MTdO - PIS
User Function F050PIS()

_nRec := ParaMixb
_aArea := GetArea()

DBSelectArea("SE2")
DBGoto(_nRec)

_cCusto := SE2->E2_CCUSTO   
_cNaturez := SE2->E2_NATUREZ  
_cHist    := "PIS "+SE2->E2_TIPO+"/ "+SE2->E2_NUM+" - "+SE2->E2_RSOCIAL
_cKey     := E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
_cEmpr	:= SE2->E2_EMPR_CP

RestArea(_aArea)

Reclock("SE2",.F.)
SE2->E2_CCUSTO := _cCusto   
SE2->E2_HIST   :=_cHist
SE2->E2_CSUKEY := _cKey  
SE2->E2_EMPR_CP:=_cEmpr
SE2->E2_RSOCIAL:="IMPOSTOS - LEI 10.833/03"
MsUnlock()

Return 

//MTdO - COFINS
User Function F050COF()

_nRec := ParaMixb
_aArea := GetArea()

DBSelectArea("SE2")
DBGoto(_nRec)

_cCusto := SE2->E2_CCUSTO   
_cNaturez := SE2->E2_NATUREZ  
_cHist    := "LEI 10.833 "+SE2->E2_TIPO+"/ "+SE2->E2_NUM+" - "+SE2->E2_RSOCIAL
_cKey     := E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
_cEmpr	:= SE2->E2_EMPR_CP

RestArea(_aArea)

Reclock("SE2",.F.)
SE2->E2_CCUSTO := _cCusto   
SE2->E2_HIST   :=_cHist
SE2->E2_CSUKEY := _cKey  
SE2->E2_EMPR_CP:=_cEmpr
SE2->E2_RSOCIAL:="IMPOSTOS - LEI 10.833/03"
MsUnlock()

Return 

//MTdO - CSLL
User Function F050CSL()

_nRec := ParaMixb
_aArea := GetArea()

DBSelectArea("SE2")
DBGoto(_nRec)

_cCusto := SE2->E2_CCUSTO   
_cNaturez := SE2->E2_NATUREZ  
_cHist    := "CSLL "+SE2->E2_TIPO+"/ "+SE2->E2_NUM+" - "+SE2->E2_RSOCIAL
_cKey     := E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
_cEmpr	:= SE2->E2_EMPR_CP

RestArea(_aArea)

Reclock("SE2",.F.)
SE2->E2_CCUSTO := _cCusto   
SE2->E2_HIST   :=_cHist
SE2->E2_CSUKEY := _cKey  
SE2->E2_EMPR_CP:=_cEmpr
SE2->E2_RSOCIAL:="IMPOSTOS - LEI 10.833/03"
MsUnlock()

Return