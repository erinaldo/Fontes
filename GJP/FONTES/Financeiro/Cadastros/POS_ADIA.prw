#INCLUDE 'Protheus.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �POS_ADIA  �Autor  �Lucas Riva Tsuda    � Data �  12/03/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Permite alterar o valor calculado pelo sistema no adiant.   ���
���          �de viagem.                                                  ���
�������������������������������������������������������������������������͹��
���Uso       �Especifico GJP                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function POS_ADIA

Local aRet := {}
Local oDlg1     := Nil    
Local oValor
Local nValor 	:= 0
Local nOpcA     := 0    

if IsInCallStack("ACAO")
While nOpcA <> 1   

	DEFINE MSDIALOG oDlg1 TITLE "Valor Adiantamento" OF oMainWnd PIXEL FROM 0,0 TO 150,300
	
    @ 020, 015 SAY "Valor R$" OF oDlg1 PIXEL
	@ 019, 050 MSGET oValor VAR nValor Picture '@E 999,999.99' When .T. Size 40,07 Valid nValor>0 OF oDlg1 PIXEL	
	oValor:bRClicked := {||AllwaysTrue()}
	    
	DEFINE SBUTTON FROM 50, 60 TYPE 1 ACTION (nOpcA:=1,oDlg1:End()) ENABLE OF oDlg1
	
	ACTIVATE MSDIALOG oDlg1 CENTERED
			
EndDo
endif

aadd(aRet,nValor)
aadd(aRet,0)
aadd(aRet,.T.)          

Return aRet