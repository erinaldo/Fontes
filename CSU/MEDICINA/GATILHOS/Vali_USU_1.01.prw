User Function val_usu()                  

valida:=.t.

DbselectArea("TMK")
DbSetOrder(1)
IF Dbseek(xfilial()+M->TMT_CODUSU)
	IF Subs(cUsuario,7,7)<>TMK->TMK_USUARI
		MsgAlert("Codigo do atendente n�o � igual ao usu�rio do sistema!!!!")
		valida:=.f.
	Endif     
Endif
	
Return valida