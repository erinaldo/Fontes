#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � CNTA300()  �Autor� Felipe Santos	 � Data � 03/10/2015      ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � INCLUS�O DE ROTINA NO OUTRAS A��ES			  ���
���          � MANUTEN��O DE CONTRATO					  ���
�������������������������������������������������������������������������Ĵ��
���Funcao    � PE MVC					                                  ���
�������������������������������������������������������������������������Ĵ��
*/


User Function CNTA300()
Local aParam     := PARAMIXB
Local xRet       := .T.
Local oObj       := ''
Local cIdPonto   := ''
Local cIdModel   := ''
Local oGrid
Local nX		 := 0
Local nY		 := 0 
Local nLicitante := 0   
Local lExclusi	 := .F.
Local cCodProduto:= ''
Local cCodFor	 := ''
Local cCodLoja	 := ''
Local cCodExclusi:= ''
Local oModProd 	 := Nil
Local oModLic 	 := Nil  


If aParam <> NIL

	oObj       := aParam[1]
	
	cIdPonto   := aParam[2]
	
	cIdModel   := aParam[3]
	
	If cIdPonto == 'BUTTONBAR'
	
		xRet := { {'Alt.Contrato', 'SALVAR', { || U_PROGA010() }, 'Este bot�o Salva' } }				
	EndIf              

EndIf


Return xRet