User Function ACB004()
Local cQuery := ""
Local nOk 	:= 0
Local lRet  := .T.

cQuery := "Update " + RetSqlName("SRA") + " SET "
cQuery += "RA_MSEXP = '20070319', "
cQuery += "RA_ENVAS = 'S' "
cQuery += "Where RA_MSEXP = ' ' "
cQuery += "AND D_E_L_E_T_ = ' ' "
cQuery += "AND RA_MEDMAT <> ' ' "
cQuery += "AND RA_SITFOLH <> 'D' "

nOk := TcSqlExec(cQuery)

lRet :=  nOk >= 0 

cQuery := "Update " + RetSqlName("SRA") + " SET "
cQuery += "RA_MSEXP = '20070320', "
cQuery += "RA_ENVAS = 'S' "
cQuery += "Where RA_MSEXP = ' ' "
cQuery += "AND D_E_L_E_T_ = ' ' "
cQuery += "AND RA_MEDMAT <> ' ' "
cQuery += "AND RA_SITFOLH = 'D' "

nOk := TcSqlExec(cQuery)

lRet :=  nOk >= 0 

cQuery := "Update " + RetSqlName("SRA") + " SET "
cQuery += "RA_MSEXP = '20070321', "
cQuery += "RA_ENVAS = 'S' "
cQuery += "Where RA_MSEXP = ' ' "
cQuery += "AND D_E_L_E_T_ = ' ' "
cQuery += "AND RA_MEDMAT = ' ' "
cQuery += "AND RA_SITFOLH = 'D' "
cQuery += "AND RA_DEMISSA <= '20070228' "

nOk := TcSqlExec(cQuery)

lRet :=  nOk >= 0 

if lRet
	dbSelectArea("SRB")
	dbGotop()
	While !eof()
		dbSelectArea("SRA")
		dbSetOrder(1)
		if dbSeek(SRB->RB_FILIAL + SRB->RB_MAT)
			If !Empty(SRA->RA_MSEXP)
				RecLock("SRB", .F.)
				SRB->RB_MSEXP := SRA->RA_MSEXP
				SRB->RB_ENVAS := SRA->RA_ENVAS
				MsUnlock()
			Endif
		Endif
	    dbSelectArea("SRB")
		dbSkip()
	End
	
Endif
  
If lRet	
	ApmsgAlert("Processo ok.")
Else
	ApmsgAlert("Erro na atualização de base.")
Endif

Return(lRet)


