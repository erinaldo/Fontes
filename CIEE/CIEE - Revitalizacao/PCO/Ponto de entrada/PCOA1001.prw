#INCLUDE "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � PCOA1001 �Autor  �TOTVS               � Data �  01/07/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Adiciona botoes na tela de PLANILHA ORCAMENTARIA            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PCOA1001()
Local _nNivel    := GetNewPar("FI_PCONIV",0)
Local aRetorno   := {}
Local aPlanning  :=	{	{"Finaliza Orc"		,"MsgRun('Finalizando Or�amento. Aguarde...',, {|| U_CPCOA11() } )",0,3},;
						{"Reabre Orc"		,"MsgRun('Reabrindo Or�amento. Aguarde...',, {|| U_CPCOA23() } )"	,0,3},;
						{"Aprova Orc"		,"U_CPCOA22(1)"													,0,3},;
						{"Est. Aprovacao"	,"U_CPCOA22(2)"													,0,3},;
						{"Consulta CC"		,"MsgRun('Consultando CRs. Aguarde...',, {|| U_CPCOA13() } )"		,0,3}}

Local aImpPlan  := {{ "Exp. Planilha","U_CPCOA15",0,4},{ "Imp. Planilha","U_CPCOA16",0,4}}
						
// Verifica se usu�rio tem nivel para acessar rotina
IF cNivel >= _nNivel
	aAdd(aRetorno,{"Planning",aPlanning,0,6})
	aAdd(aRetorno,{"Importacao",aImpPlan,0,6})
ENDIF

Return(aRetorno)