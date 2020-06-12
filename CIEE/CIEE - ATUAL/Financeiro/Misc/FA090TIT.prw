#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA090TIT  � Autor � CLAUDIO BARROS     � Data �  23/02/06   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada executado na rotina Baixa Automatica      ���
���          � por Bordero em Contas a Pagar FINA090                      ���
���          � Apos a confirmacao do MARKBROWSE                           ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAFIN - BAIXA AUTOMATICA                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function FA090TIT()

Local _cPref	:= SE2->E2_PREFIXO
_lRet 			:= .T. 
 

DbSelectArea("SE2")
        
IF ALLTRIM(FUNNAME()) <> 'AFIN050TP'
	If _cPref == 'FL '
		_lRet := .F.
		Alert("Baixa Autom�tica dos T�tulos FL n�o poder�o ser feitos por essa Rotina")    
		Return(_lRet)
	Endif   
ENDIF

If E2_PORTADO <> ParamIxb[1]
	_lRet := .F.
	MsgBox("O Titulo "+ALLTRIM(E2_NUM)+ " do Bordero "+Alltrim(E2_NUMBOR)+" nao pertence ao banco selecionado!!!")
	Return(_lRet)
EndIf


If E2_VENCREA <> dDataBase
	_lRet    :=.F.
	MsgAlert("Data Base Diferente com as datas de Vencimento dos T�tulos", "Aten��o")
	Return(_lRet)
EndIf   



Return(_lRet)