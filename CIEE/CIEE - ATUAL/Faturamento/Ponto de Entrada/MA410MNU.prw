#include "rwmake.ch"
#include "protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA410MNU  �Autor  �Daniel G.Jr.TI1239  � Data �  Abril/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada da rotina MATA410-Pedido de Vendas        ���
���          � Incluir op��es no menu da rotina (aRotina)                 ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MA410MNU()

Local cDirect := ""
Local aDirect := {}

If alltrim(FunName()) == "MATA410"

	// Verifica se h� carga de bens do Ativo Fixo do SOE para ser feita
	If ExistBlock("CATFA01")
		If cEmpant == '01' //SP
			cDirect    := "arq_txt\contabilidade\Ativo\"
		ElseIf cEmpant == '03' //RJ
			cDirect    := "\arq_txtrj\contabilidade\Ativo\"
		EndIf
		aDirect    := Directory(cDirect+"*.TXT")

		If Len(aDirect)>0
			ExecBlock("CATFA01",.F.,.F.)
		EndIf
	EndIf
	
	// Inclui op��o de Altera��o de cabe�alho do Pedido de Vendas
	If ExistBlock("CFATA01")
		aAdd(aRotina, { "Altera Cabe�alho PV", 'ExecBlock("CFATA01",.F.,.F.)' , 0, 4, 0, NIL})
	EndIf
EndIf

Return