/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CT5550VR_1.01ºAutor  ³MTdO			   º Data ³  03/02/04    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Objetivo: Verificar se o titulo em questao é tipo "NF" ou outroº±± 
±±º          ³(implantado manualmente no contas a receber			         º±±
±±º			 ³Verifica ainda se não é de tipo abatimento (??-) ou taxa       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 710                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

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