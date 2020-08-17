#Include "Protheus.ch"
//-----------------------------------------------------------------------
/*/{Protheus.doc} ASCTBA19()
Retorna a conta na natureza na compensação do RA com titulo
@param		pAlias - Alias do cadastro (cliente ou fornecedor)
            nOpc   - Opção de acordo com o cadastro
@return		Nenhum
@author 	Zema
@since 		26/07/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra                             
/*/
//-----------------------------------------------------------------------
USER FUNCTION ASCTBA19(pPar,pCampo)     
LOCAL aAREASE5 	:= SE5->(GETAREA())
LOCAL aAREASE1 	:= SE1->(GETAREA())
LOCAL aAREASED 	:= SED->(GETAREA())
Local xRET 		:= ""

SED->(DBSETORDER(1))

IF pPar $ "RA#NCC"
	If ALLTRIM(SE5->E5_TIPO) == pPar 
		SED->(DBSEEK(XFILIAL("SED")+SE5->E5_NATUREZ))
		xRet := &pCampo.
 	Else
		If SUBSTR(SE5->E5_DOCUMEN,16,2) == pPar
			DbSelectArea("SE1")
			DbSetOrder(2)
			If Msseek(XFILIAL("SE5")+cCliente+cLoja+SUBSTR(SE5->E5_DOCUMEN,1,17))
				If ALLTRIM(SE1->E1_TIPO) == pPar
					SED->(DBSEEK(XFILIAL("SED")+SE1->E1_NATUREZ))
					xRet := &pCampo.			
				Endif
			Endif   
		Endif
	Endif		
ElseIf pPar == "TIT"
	If ALLTRIM(SE5->E5_TIPO)$"RA#NCC" 
		DbSelectArea("SE1")
		DbSetOrder(2)
		If Msseek(XFILIAL("SE5")+cCliente+cLoja+SUBSTR(SE5->E5_DOCUMEN,1,17))
			SED->(DBSEEK(XFILIAL("SED")+SE1->E1_NATUREZ))
			xRet := &pCampo.			
		Endif
 	Else
		SED->(DBSEEK(XFILIAL("SED")+SE5->E5_NATUREZ))
		xRet := &pCampo.
    Endif
EndIf

SE5->(RESTAREA(aAREASE5))
SE1->(RESTAREA(aAREASE1))
SE1->(RESTAREA(aAREASED))

Return(xRET)

