#include 'protheus.ch'
#include 'parmtype.ch'
//-----------------------------------------------------------------------
/*{Protheus.doc} ASCTBA01
@Cadastro de Eventos de Equivalência 
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------
user function ASCTBA02()
Private cTitulo := OEMTOANSI("Eventos de Equivalência")    
Private cCadastro := cTitulo
Private aRotina := MenuDef()         
Private cDelFunc := "U_ASCTB02E()" // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private cString  := "SZ1"                         
Private CMOEDA	 := ""

dbSelectArea(cString)         
(cString)->(dbSetOrder(1))

mBrowse( 6,1,22,75,cString)

Return        
//-----------------------------------------------------------------------
/*{Protheus.doc} MenuDef
@Definição de aRotina 
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------            
Static Function MenuDef()
Local aRotina :=  { {"Pesquisar","AxPesqui" ,0,1},;
					{"Visualizar","AxVisual",0,2},;
					{"Incluir"   ,"AxInclui",0,3},;
					{"Alterar"   ,"AxAltera",0,4},;
					{"Excluir"   ,"AxDeleta",0,5}}
Return aRotina       
//-----------------------------------------------------------------------
/*{Protheus.doc} ASCTB02E
@Valida a exclusão 
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------                                                                                                 
USER FUNCTION ASCTB02E
Local lRet := .T.

// Verifica se o evento está vinculado a algum relacionamento de equivalência

IF !MsgYesNo("Confirma a exclusão do evento?")
	lRet := .F.
ENDIF

Return(lRet)
//-----------------------------------------------------------------------
/*{Protheus.doc} ASCTB02V
@Valida a Fórmula digitada
@param		Nenhum
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------
USER FUNCTION ASCTB02V(pForm)    
Local lRet       := .T.
Local bError     := ErrorBlock( { |e| AvaliaErro(e) } )
xRet             := ""
BEGIN SEQUENCE
	xRet := &(pForm)
	Recover
    lRet := .F.
END SEQUENCE
IF !lRet
	MSGALERT("Erro na formula.")
ENDIF                                              
RETURN(lRet)      
STATIC FUNCTION AvaliaErro(e)
cMenErro := e:Description
If !Empty(cMenErro)
	Break
	Return(.F.)
EndIf
RETURN(.T.)
//-----------------------------------------------------------------------
/*{Protheus.doc} VC
@Identifica nos LP´s de equivalencia, se a conta selecionada
@aceita ou não centro de custos
@param		Conta, Centro de Custos
@return		Centro de Custos
@author 	Zema
@since 		28/08/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------
USER FUNCTION VC(pConta,pCC)
Local cConta	:= pConta   
Local cCC		:= pCC   
Local cRet      := ""
Local aArea		:= GetArea()
IF !EMPTY(cConta)
	CT1->(DBSETORDER(1))
	IF CT1->(DBSEEK(XFILIAL("CT1")+cConta))
		IF CT1->CT1_ACCUST=="1"
			cRet := cCC
		ENDIF
	ENDIF	
ENDIF
RestArea(aArea)
RETURN(cRet)
//-----------------------------------------------------------------------
/*{Protheus.doc} VIT
@Identifica nos LP´s de equivalencia, se a conta selecionada
@aceita ou não item contábil
@param		Conta, Item Ctb
@return		Item contábil
@author 	Zema
@since 		28/08/2017
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------
USER FUNCTION VIT(pConta,pItem)
Local cConta	:= pConta   
Local cItem		:= pItem
Local cRet      := ""
Local aArea		:= GetArea()
IF !EMPTY(cConta)
	CT1->(DBSETORDER(1))
	IF CT1->(DBSEEK(XFILIAL("CT1")+cConta))
		IF CT1->CT1_ACITEM=="1"
			cRet := cItem
		ENDIF
	ENDIF	
ENDIF
RestArea(aArea)
RETURN(cRet)