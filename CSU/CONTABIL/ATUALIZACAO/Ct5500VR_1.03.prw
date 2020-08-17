/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �CT5550VR_1.01�Autor  �MTdO			   � Data �  03/02/04    ���
����������������������������������������������������������������������������͹��
���Desc.     �Objetivo: Verificar se o titulo em questao � tipo "NF" ou outro��� 
���          �(implantado manualmente no contas a receber			         ���
���			 �Verifica ainda se n�o � de tipo abatimento (??-) ou taxa       ���
����������������������������������������������������������������������������͹��
���Uso       � AP6 710                                                       ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
������������������������������������������������������������������������������*/

User Function CT5500VR()
_nVal	:=0.0

IF SM0->M0_CODIGO==SUBSTR(SE1->E1_PREFIXO,1,2).and.ALLTRIM(SE1->E1_TIPO)<>"NF"
	IF ALLTRIM(SE1->E1_TIPO)=="AB-"  
	  _nVal	:=0.0
	ELSEIF ALLTRIM(SE1->E1_TIPO)=="CF-" 
	  _nVal	:=0.0
	ELSEIF ALLTRIM(SE1->E1_TIPO)=="PI-"
	  _nVal	:=0.0
	ELSEIF ALLTRIM(SE1->E1_TIPO)=="IN-"
	  _nVal	:=0.0
	ELSEIF ALLTRIM(SE1->E1_TIPO)=="IR-"
	  _nVal	:=0.0
	ELSEIF ALLTRIM(SE1->E1_TIPO)=="TX-"
	  _nVal	:=0.0
	ELSEIF ALLTRIM(SE1->E1_TIPO)=="NDC"
		_nVal :=SE1->E1_VALOR	     
	ELSE
		_nVal :=SE1->E1_VALOR	     
	ENDIF
ELSE
	_nVal	:=0.0
ENDIF
Return nVal