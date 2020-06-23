#INCLUDE "TOTVS.CH"
#INCLUDE "XMLXFUN.CH"

#Define _enter_ Chr(13)+Chr(10)

User Function RelAllUser()

Local oDlg
Local oSay1
Local oCombo
Local cCombo
Local aRet
Local nI
Local nY
Local aUsers := {}
Local cTexto := "ROTINA;FUNCAO;TIPO;CAMINHO"+ _enter_ // cRotina + ";" + cFunction + ";" + cType + ";" + cArq
Local cTexAx := ""
Local cMsg	 := ""

RpcSetType(3)

// RpcSetEnv("01", "01",,,'CFG',, {"SIX","SX1","SX2","SX3","SX5","SX6","SX7"})
RpcSetEnv("99", "01")
aRet := AllUsers()
cUsuario := '000000' //Administrador
PswOrder(1) //Busca por usuario
If PswSeek( cUsuario, .T. ) 
	cGrupo := PswRet()
EndIf

For nI := 1 to 1//Len(aRet)
	If !aRet[nI][1][17]
		Aadd(aUsers, aRet[nI][1][2])
		For nY := 1 to Len(aRet[nI][3])
			If !(SubStr(AllTrim(aRet[nI][3][nY]),3,1) == "X")
				//If !(AllTrim(Substr(aRet[nI][3][nY],Rat("\",aRet[nI][3][nY])+1)) $ cTexto)
					cTexto += SubStr(aRet[nI][3][nY],1,2) +";"+ StrTran(SubStr(aRet[nI][3][nY],4),Chr(13)+Chr(10),"") +";"+ aRet[nI][1][2] +";"+ aRet[nI][1][4]+ _enter_
				//EndIf
			EndIf
		Next
	EndIf
Next

//Aviso("Menus",cTexto,{"OK"})
MemoWrite("\menus.txt",cTexto)

DEFINE MSDIALOG oDlg TITLE "All Users" From 000,0 TO 100,300 PIXEL
@ 12, 05 SAY oSay1 VAR "Usuários: " OF oDlg PIXEL
@ 12, 30 COMBOBOX oCombo VAR cCombo ITEMS aUsers SIZE 100, 009 OF oDlg PIXEL
@ 25, 40 BUTTON "Menus" PIXEL SIZE 40,12 OF oDlg ACTION ShowMenuUsr(cCombo,aRet)
@ 25, 80 BUTTON "Fechar" PIXEL SIZE 40,12 OF oDlg ACTION oDlg:End()
ACTIVATE MSDIALOG oDlg CENTERED
nI := 1

While Len(cTexto) > 0
	cTexAx := substr(cTexto,1,at(Chr(13)+Chr(10),cTexto))
	//cTexAx := StrTran(cTexAx,Chr(10),"")
	//cTexAx := StrTran(cTexAx,Chr(13),"")
	//If !(Upper(SubStr(cTexAx,10,4)) == "SIGA")
	LerMenu(substr(StrTran(StrTran(cTexAx,Chr(13),""),Chr(10),""),4,At(";",cTexAx,4)-4),@cMsg)
	//nI++
	//EndIf
	cTexto := substr(cTexto,Len(AllTrim(cTexAx))+2)
EndDo

//Aviso("Funções de Menus",cMsg,{"OK"})
MemoWrite("\funcoes_menu.txt",cMsg)

//RpcClearEnv()

MsgInfo("Importacao Finalizada com Sucesso!!!")

RpcClearEnv()

Return

Static Function ShowMenuUsr(cCombo,aRet)
Local cTexto := ""
Local nI
Local nUser	 := AScan(aRet, {|x| AllTrim(x[1][2]) == cCombo})

If nUser > 0
	For nI := 1 to Len(aRet[nUser])
		cTexto += aRet[nUser][3][nI] + _enter_
	Next
	Aviso(cCombo+" | "+If(aRet[nUser][2][11],"Sim","Não"),cTexto,{"OK"})
Else
	Aviso(cCombo+" | "+If(aRet[nUser][2][11],"Sim","Não"),"Menu não encontrado",{"OK"})
EndIf

Return

Static Function LerMenu(cArq,cTexto)
// Abre o arquivo
Local nHandle := FT_FUse(cArq)
Local cLine	  := ""
Local lEnable := .F.
Local cFunction := ""
Local cType := ""
Local cRotina := ""

If nHandle = -1
	return
endif

// Posiciona na primeria linha
FT_FGoTop()

// Retorna o número de linhas do arquivo
nLast := FT_FLastRec()

While !FT_FEOF()
	cLine  := FT_FReadLn()
	//	FRead( nHandle, cLine, 512 )
	// Retorna a linha corrente
	nRecno := FT_FRecno()
	If SubStr(AllTrim(cLine),At("<",cLine),26) == '<MenuItem Status="Enable">'
		lEnable := .T.
	EndIf
	If lEnable .And. SubStr(cLine,At("<",cLine),10) == '<Function>'
		cLine := AllTrim(SubStr(cLine,At(">",cLine)+1))
		cFunction := SubStr(cLine,1,At("<",cLine)-1)
	EndIf
	If lEnable .And. SubStr(cLine,At("<",cLine),6) == '<Type>'
		cLine := AllTrim(SubStr(cLine,At(">",cLine)+1))
		cType := SubStr(cLine,1,At("<",cLine)-1)
	EndIf
	
	If lEnable .And. SubStr(cLine,At("<",cLine),17) == '<Title lang="pt">'
		cLine := AllTrim(SubStr(cLine,At(">",cLine)+1))
		cRotina := SubStr(cLine,1,At("<",cLine)-1)
	EndIf
	
	If lEnable .And. SubStr(cLine,At("<",cLine),11) == '</MenuItem>'
		//If SubStr(cFunction,1,1) $ "#" .Or. SubStr(Upper(cFunction),1,2) $ "U_" .Or. cType $ "03"
			//Alert( "Função: " + cFunction + " - Tipo: " + cType )
			If !("Função: " + cFunction + " - Tipo: " + cType $ cTexto)
				cTexto += cRotina + ";" + cFunction + ";" + cType + ";" + cArq + _enter_
			EndIf
		//EndIf
		lEnable := .F.
	EndIf
	// Pula para próxima linha
	FT_FSKIP()
End
// Fecha o Arquivo

FT_FUSE()

Return