#Include 'Rwmake.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DPCTB102GRºAutor  ³ Sergio Oliveira    º Data ³  Set/2009   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³ Ponto de entrada no momento da gravacao do estorno ou da   º±±
±±ºDescricao ³ exclusao do lancamento contabil. Esta sendo utilizado para º±±
±±º          ³ informar a hora para que no momento da execucao do relato- º±±
±±º          ³ rio exporta razao esta informacao devera ser incluida.     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DPCTB102GR()

Local cTxtBlq, cExec, nExec
Local cEol := Chr(13)+Chr(10)
Local _cArea := GetArea()

//                 1     2        3       4      5
// ParamIxb => { nOpc,dDatalanc,cLote,cSubLote,cDoc }

If ParamIxb[1] # 3 .And. ParamIxb[1] # 7
	
	DbSelectArea("CT2")

	cExec := " UPDATE "+RetSqlName('CT2')+" SET CT2_X_HRUP = '"+Time()+"', CT2_X_USRA = '"+Left(UsrFullName(__cUserID),30)+"', "
	cExec += " CT2_X_DTAL = '"+Dtos(Date())+"' "
	cExec += " WHERE CT2_FILIAL = '"+xFilial('CT2')+"' "
	cExec += " AND   CT2_DATA   = '"+Dtos(ParamIxb[2])+"' "
	cExec += " AND   CT2_LOTE   = '"+ParamIxb[3]+"' "
	cExec += " AND   CT2_SBLOTE = '"+ParamIxb[4]+"' "
	cExec += " AND   CT2_DOC    = '"+ParamIxb[5]+"' "
	//cExec += " AND   D_E_L_E_T_ = ' ' "
	
	nExec := TcSqlExec( cExec )
	
	If nExec # 0
		cTxtBlq := "Ocorreu um problema no momento da gravacao do campo referente a hora deste "
		cTxtBlq += "evento. Entre em contato com a area de Sistemas ERP informando a mensagem "
		cTxtBlq += "a seguir: "+cEol+cEol+TcSqlError()
		Aviso("Gravacao da Ocorrencia",cTxtBlq,;
		{"&Fechar"},3,"Campos de LOG",,;
		"PCOLOCK")
	EndIf
	
	CT2->(DbCloseArea())
	
EndIf

RestArea(_cArea)

Return