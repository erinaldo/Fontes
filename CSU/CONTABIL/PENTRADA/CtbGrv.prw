#Include 'Rwmake.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CTBGRV   ºAutor  ³ Sergio Oliveira    º Data ³  Ago/2009   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de entrada no momento da gravacao de cada CT2 antes  º±±
±±º          ³ de efetuar o MsUnLock() - Generico. Esta sendo utilizado   º±±
±±º          ³ para gravar o campo referente a hora de inclusao (_X_HRIN) º±±
±±º          ³ e tambem hora de alteracao (_X_HRUP) para que no momento daº±±
±±º          ³ geracao do relatorio exporta razao esta informacao seja    º±±
±±º          ³ gravada no arquivo.                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CTBGrv()
Local _cQry,_cAlias,_aArea

// Inclusoes e Alteracoes:
If ParamIxb[1] == 3 .Or. ParamIxb[1] == 7 // 3 = Inclusao | 7 = Copia => Inclusao
	
	If IsInCallStack("GPEM110")
		CT2_X_USRI := "CTBGPE"
	Else
		CT2_X_USRI := Left(UsrFullName(__cUserID),30)
	EndIf
	CT2_X_DTIN := Date()
	CT2_X_HRIN := Time()
	CT2_X_HRUP := "  :  :  "
	CT2_X_USRA := " "
	CT2_X_DTAL := Ctod('')
Else                // Outros
	If IsInCallStack("GPEM110")
		CCT2_X_USRA := "CTBGPE"
	Else
		CT2_X_USRA := Left(UsrFullName(__cUserID),30)
	EndIf
	CT2_X_DTAL := Date()
	CT2_X_HRUP := Time()
EndIf	

If ParamIxb[1] == 6 .And. Select("TMP") > 0 .And. TMP->(FieldPos("CT2_RECNO")) > 0//-- Estorno
	_aArea := GetArea()
	_cQry := " SELECT ZF1_CODFOR,ZF1_CODCLI "
	_cQry += " FROM " + RetSQLName("ZF1") + " ZF1, " + RetSQLName("CT2") + "  CT2"
	_cQry += " WHERE CT2.R_E_C_N_O_ = " + Str(TMP->CT2_RECNO)
	_cQry += "	AND	ZF1.ZF1_FILIAL = '" + xFilial("ZF1") +"'"
	_cQry += "	AND	ZF1.ZF1_DATA   = CT2_DATA"
	_cQry += "	AND	ZF1.ZF1_LOTE   = CT2_LOTE"
	_cQry += "	AND	ZF1.ZF1_SBLOTE = CT2_SBLOTE"
	_cQry += "	AND	ZF1.ZF1_DOC    = CT2_DOC"
	_cQry += "	AND	ZF1.ZF1_LINHA  = CT2_LINHA"
	_cQry += "	AND	ZF1.D_E_L_E_T_ = ' '"
	
	_cAlias := GetNextAlias()
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQry),_cAlias,.T.,.T.)

	If (_cAlias)->(!Eof()) .And. !Empty((_cAlias)->ZF1_CODFOR+(_cAlias)->ZF1_CODCLI)
		dbSelectArea("ZF1")
		RecLock("ZF1",.T.)
			ZF1->ZF1_FILIAL := xFilial("ZF1")
			ZF1->ZF1_DATA   := CT2->CT2_DATA
			ZF1->ZF1_LOTE   := CT2->CT2_LOTE
			ZF1->ZF1_SBLOTE := CT2->CT2_SBLOTE
			ZF1->ZF1_DOC    := CT2->CT2_DOC
			ZF1->ZF1_LINHA  := CT2->CT2_LINHA
			ZF1->ZF1_CODFOR := (_cAlias)->ZF1_CODFOR
			ZF1->ZF1_CODCLI := (_cAlias)->ZF1_CODCLI
		MsUnlock()
	EndIf
	(_cAlias)->(DbCloseArea())
	RestArea(_aArea)
EndIf

Return