User Function val_usu()                  

valida:=.t.

DbselectArea("TMK")
DbSetOrder(1)
IF Dbseek(xfilial()+M->TMT_CODUSU)
	IF Subs(cUsuario,7,7)<>TMK->TMK_USUARI
		MsgAlert("Codigo do atendente não é igual ao usuário do sistema!!!!")
		valida:=.f.
	Endif     
Endif
	
Return valida