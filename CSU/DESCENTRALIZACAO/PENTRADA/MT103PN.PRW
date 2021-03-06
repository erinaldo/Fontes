#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪目北
北矲un噮o    �  MT103PN � Autor � Leonardo Soncin       � Data �28/11/2006 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪拇北
北�          矱sta rotina valida a database para incluir a NFE.            潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砋so       矱specifico CSU                                               潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
*/

User Function MT103PN()

Local lRet	   := .t.
Local dDatFech := GetNewPar("MV_XMESNFE","")

If dDataBase < dDatFech
	lRet := .f.
	cTxtBlq := "Incluir este documento a partir de "+Dtoc( dDatFech )
	Aviso("Data Base do Sistema",cTxtBlq,{"&Fechar"},3,"CONTROLE DE FECHAMENTO",,"PCOLOCK")
EndIf

If lRet
	If dDataBase > Date()
		lRet := .f.
		cTxtBlq := "A data base do sistema � superior � data do dia de hoje. Opera玢o n鉶 permitida!"
		Aviso("Data Base do Sistema",cTxtBlq,{"&Fechar"},3,"MAIOR QUE A DATA DO DIA",,"PCOLOCK")
	Else
		If dDEmissao > Date() // Teoricamente o proprio sistema nao permite esta opcao. Mas para garantir....
			lRet := .f.
			cTxtBlq := "A data de emiss鉶 � superior � data do dia de hoje. Opera玢o n鉶 permitida!"
			Aviso("Data Base do Sistema",cTxtBlq,{"&Fechar"},3,"MAIOR QUE A DATA DO DIA",,"PCOLOCK")
		EndIf  
	EndIf
EndIf

Return lRet