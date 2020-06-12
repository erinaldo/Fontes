#INCLUDE "rwmake.ch"
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} MT110CON
Valida se o usuario pode alterar a solicitacao de compra. Ponto de entrada executado 
antes de gravar solicitacao de compra (mata110 - SC1)
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function MT110CON()
Local lRet 		:= .F.
Local lVerUsr	:= .F.
Local cMsg 		:= ""
Local cUsrAdm 	:= ""

If Alltrim(cUserName) $ GetMV("CI_USERSC")
	cUsrAdm:=cUserName
Else
	cUsrAdm:=""
EndIf                           

lVerUsr := (empty(upper(SC1->C1_SOLICIT)) .or. AllTrim(upper(cUserName)) $ AllTrim(upper(SC1->C1_SOLICIT  + "," + cUsrAdm)))

// Nao verifica no caso de inclusao, somente de alteracao.
If !(lRet := (CA110NUM != SC1->C1_NUM .or. lVerUsr))
	cMsg := "Somente o próprio solicitante ou um usuário com esse privilégio " +;
	"podem alterar a solicitação de compra."
	MsgBox(OemToAnsi(cMsg), OemToAnsi("Atenção"))
Endif     

Return (lRet)