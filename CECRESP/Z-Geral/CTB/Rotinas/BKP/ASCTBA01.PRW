#include 'protheus.ch'
#include 'parmtype.ch'
//-----------------------------------------------------------------------
/*{Protheus.doc} ASCTBA01
@Cadastro de Empresas investidas e quantidade de ações 
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------
user function ASCTBA01()  
Local lAtuAuto := GETNEWPAR("AS_SZ0EMP",.T.) // Informa se atualiza automático a tabela SZ0 apartir do sigamat.emp 
Local aFieldFill	:= {}
Local aFields		:= {}
Local aAlterFields	:= {}
Local nX			:= 0                                 
Local lOk			:= .F.
Local bOk       	:= {|| IF(MsgYesNo("Confirma dados? "), (lOk	:= .T., oDlg:End()), (lOk	:= .F., oDlg:End()) ) }
Local bCancel   	:= {|| (lOk	:= .F., oDlg:End()) }
Private cTitulo := OEMTOANSI("Cadastro de Empresas & Quotas")    
Private cCadastro := cTitulo
Private aHeader       := {}
Private aCols         := {}
Static  oMSNewGe
Static  oDlg

// Verifica se Atualiza a tabela SZ0 a partir do sigamat.emp
IF lAtuAuto
	Processa( { || AtuSZ0EMP() }, "Atualizando empresas . . .")   
ENDIF


DEFINE MSDIALOG oDlg TITLE cTitulo FROM 000, 000  TO 600, 1000 COLORS 0, 16777215 PIXEL
                        
AADD(aFields,"Z0_EMPRESA")
AADD(aFields,"Z0_RAZAO")                                                                                   
AADD(aFields,"Z0_CONTA")                                                                                    
AADD(aFields,"Z0_ITEMCTA")                                                                                    
AADD(aFields,"Z0_CNPJ")                                                                                    
AADD(aFields,"Z0_QTACOES") 
         
AADD(aAlterFields,"Z0_CONTA")
AADD(aAlterFields,"Z0_ITEMCTA")
AADD(aAlterFields,"Z0_QTACOES")

// Define field properties
DbSelectArea("SX3")
SX3->(DbSetOrder(2))
For nX := 1 to Len(aFields)
	If SX3->(DbSeek(aFields[nX]))
		Aadd(aHeader, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
    Endif
Next nX

SZ0->(DBGOTOP())
WHILE SZ0->(!EOF())
	aFieldFill := {}
	Aadd(aFieldFill, SZ0->Z0_EMPRESA)
	AADD(aFieldFill, SZ0->Z0_RAZAO) 
	AADD(aFieldFill, SZ0->Z0_CONTA)  	
	AADD(aFieldFill, SZ0->Z0_ITEMCTA)  	
	AADD(aFieldFill, SZ0->Z0_CNPJ)  
	AADD(aFieldFill, SZ0->Z0_QTACOES)  				
	Aadd(aFieldFill, .F.)
	Aadd(aCols, aFieldFill)
    SZ0->(DBSKIP())
END
     
IF EMPTY(aCols)     
	For nX := 1 to Len(aFields)
		If SX3->(DbSeek(aFields[nX]))
      		Aadd(aFieldFill, CriaVar(SX3->X3_CAMPO))
    	Endif
  	Next nX
  	Aadd(aFieldFill, .F.)
  	Aadd(aCols, aFieldFill)
ENDIF

oMSNewGe := MsNewGetDados():New( 032, 005, 297, 500, GD_UPDATE,"AllwaysTrue", "AllwaysTrue", , aAlterFields,, 999, "AllwaysTrue", "AllwaysTrue", , , aHeader, aCols)

ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg, bOk, bCancel)
IF lOK
	FOR nX := 1 TO LEN(oMSNewGe:aCols)
		IF SZ0->(DBSEEK(XFILIAL("SZ0")+oMSNewGe:aCols[nX][aScan(aHeader,{|x| AllTrim(x[2]) == "Z0_EMPRESA"})]))
			RECLOCK("SZ0",.F.)                                                                       
			SZ0->Z0_CONTA   := oMSNewGe:aCols[nX][aScan(aHeader,{|x| AllTrim(x[2]) == "Z0_CONTA"})]			
			SZ0->Z0_ITEMCTA := oMSNewGe:aCols[nX][aScan(aHeader,{|x| AllTrim(x[2]) == "Z0_ITEMCTA"})]						
			SZ0->Z0_QTACOES := oMSNewGe:aCols[nX][aScan(aHeader,{|x| AllTrim(x[2]) == "Z0_QTACOES"})]
			SZ0->(MsUnlock())
		ENDIF
	NEXT nX

ENDIF
	
return


//-----------------------------------------------------------------------
/*{Protheus.doc} AtuSZ0EMP
@Atualiza a tabela SZ0 com os dados da tabela SIGAMAT.EMP
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------
STATIC FUNCTION AtuSZ0EMP
Local nRegSM0 := SM0->(RECNO())
Local nRegsSM0:= SM0->(RECCOUNT())

ProcRegua(nRegsSM0)

SZ0->(DBSETORDER(1))
SM0->(DBGOTOP())   
WHILE SM0->(!EOF())
	IncProc() 
	IF ALLTRIM(SM0->M0_CODIGO) <> "99"
		IF SZ0->(!DBSEEK(XFILIAL("SZ0")+SUBSTR(SM0->M0_CODIGO,1,2)+SUBSTR(SM0->M0_CODFIL,1,7)))
			RECLOCK("SZ0",.T.)
			SZ0->Z0_FILIAL := XFILIAL("SZ0")
			SZ0->Z0_EMPRESA:= SUBSTR(SM0->M0_CODIGO,1,2)+SUBSTR(SM0->M0_CODFIL,1,7)
		ELSE
			RECLOCK("SZ0",.F.)
		ENDIF
		SZ0->Z0_RAZAO  := SM0->M0_NOMECOM
		SZ0->Z0_CNPJ   := SM0->M0_CGC
		SZ0->(MsUnlock())
	ENDIF
	SM0->(DBSKIP())
END          

SM0->(DBGOTO(nRegSM0))

RETURN