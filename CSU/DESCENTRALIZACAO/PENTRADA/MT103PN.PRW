#Include "Rwmake.ch"
#Include "TopConn.ch"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³  MT103PN ³ Autor ³ Leonardo Soncin       ³ Data ³28/11/2006 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Esta rotina valida a database para incluir a NFE.            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Especifico CSU                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
		cTxtBlq := "A data base do sistema é superior à data do dia de hoje. Operação não permitida!"
		Aviso("Data Base do Sistema",cTxtBlq,{"&Fechar"},3,"MAIOR QUE A DATA DO DIA",,"PCOLOCK")
	Else
		If dDEmissao > Date() // Teoricamente o proprio sistema nao permite esta opcao. Mas para garantir....
			lRet := .f.
			cTxtBlq := "A data de emissão é superior à data do dia de hoje. Operação não permitida!"
			Aviso("Data Base do Sistema",cTxtBlq,{"&Fechar"},3,"MAIOR QUE A DATA DO DIA",,"PCOLOCK")
		EndIf  
	EndIf
EndIf

Return lRet