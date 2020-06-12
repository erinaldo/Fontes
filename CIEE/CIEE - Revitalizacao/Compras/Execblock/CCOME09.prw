#INCLUDE "rwmake.ch"    
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CCOME09
Retorna o nome dos usuarios
@author  	Totvs
@since     	01/01/2015
@version  	P.11.8      
@return   	Nenhum 
/*/
//---------------------------------------------------------------------------------------
User Function CCOME09(cUser) 
Local aArea 	:= GetArea()
Local cNomeVal	:= ""
Local Ret 		:= .T.

PswOrder(2)
If PswSeek(cUser)
	cNomeVal  := PswRet(1)[1][2]
EndIf

If Alltrim(cUser) <> Alltrim(cNomeVal)
   MsgAlert("Usuario Nao Cadastrado!!","Atenção "+Alltrim(Subs(cUsuario,7,15)))
   Ret:= .F.
ENDIF
   
RestArea(aArea)
Return(Ret)