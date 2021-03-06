#include "rwmake.ch"

User Function efata001()

SetPrvt("_VlrLiq")
SetPrvt("_VlrBru")
SetPrvt("_VlrImp")
_VlrLiq:=0
_VlrBru:=0
_VlrImp:=0
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � Efat001  � Autor � Antonio Carlos        � Data �20/07/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Valor liquido de nota de cliente p/ contabiliza��o         ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Lan�amento Padr�o c/ Lei 10925                             ���
��������������������������������������������������������������������������ٱ�
��� Atualiza��o : 17/01/07 - Ednei C. Mauriz- Alterado:                   ���    
��� "If SA1->A1_RECISS=="2"" para "If SA1->A1_RECISS=="1"                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

DbselectArea("SE1")
SE1->(dbSetOrder(2))
SE1->( dbSeek(xFilial("SE1")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_PREFIXO+SF2->F2_DOC) )

DO WHILE !EOF() .AND. xFilial("SE1")=SE1->E1_FILIAL .AND. SF2->F2_CLIENTE=SE1->E1_CLIENTE .AND. SF2->F2_LOJA=SE1->E1_LOJA .AND. SF2->F2_PREFIXO=SE1->E1_PREFIXO .AND. SF2->F2_DOC=SE1->E1_NUM
	
	IF SE1->E1_TIPO="NF "
		_VlrBru := SE1->E1_valor
	Elseif SE1->E1_TIPO $ "CF-/CS-/IN-/IR-/PI-"
		_VlrImp += SE1->E1_valor
	ElseIf SE1->E1_TIPO = "IS-" 
		dbSelectArea("SA1")
		dbSetorder(1)
		dbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
		If SA1->A1_RECISS <> "1" //Ajustado para <> - OS 1072/10
			_VlrImp += SE1->E1_valor			
		Endif              
		dbSelectArea("SE1")
	Endif
	
	DbSkip()
	
EndDo

_VlrLiq  :=  _VlrBru - _VlrImp

Return(_VlrLiq)
