#INCLUDE 'PROTHEUS.CH'

User Function Test3CSU() // Teste de Envio WF
Return u_CSUCARG5( { .F., '01', '01' }  )

/*
Codificacao de Erros
101 Nao conseguiu deletar tabela intermediaria da CSU INT_FUNCIONARIOS
102 Nao conseguiu deletar tabela intermediaria da CSU INT_EQUIPE
103 Nao atualizou tabela intermediaria da CSU INT_FUNCIONARIOS
104 Nao atualizou tabela intermediaria da CSU INT_FUNCIONARIOS
*/

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � CSUCARG5  �Autor  � Ernani Forastieri  � Data �  28/02/08   ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina de Integracao dos afastamentos, demisseos ou        ���
���          � admissoes da folha                                         ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CSUCARG5( aParams )
Local lManual     := IIf( aParams == NIL, .T., aParams[1] )
Local cEmpresa    := IIf( lManual, cEmpAnt, aParams[2] )
Local cFil        := IIf( lManual, cFilAnt, aParams[3] )
Local cTitulo     := 'Exportacoes dos dados de Funcionario/Equipe'
Local cQuery      := ''
Local cTmp        := ''
Local cCmd        := ''
Local cConString  := ''
Local cBanco      := ''
Local cServer     := ''
Local cAux        := ''
Local dIniMes     := CToD( '  /  /  '  )
Local dFimMes     := CToD( '  /  /  '  )
Local cFuncAnt    := ''
Local lFirst      := .T.
Local lContinua   := .t.
Local nErro       := 0
Local oDBIntermed
Local cPrxId      := ''
Local cSeq        := ''
Local lTeveErro   := .F.
Local cSitFolha   := ''
Local dDataRef    := CToD( '  /  /  '  )
Local dIniAfas    := CToD( '  /  / '  )
Local dFimAfas    := CToD( '  /  / '  )

//
// Prepara ambiente se for JOB
//
If !lManual
	RpcSetType( 3 )
	RpcSetEnv( cEmpresa, cFil,,,'FOL' )
EndIf

If !MayIUseCode( 'CSUCARG5' + cEmpresa )
	u_MsgConMon( 'Job CSUCARG5 - Empresa ' + cEmpresa + ' - Ja Esta Em Andamento' ,, .F. ) //
	Return NIL
EndIf

PA4->( dbSetOrder( 1 ) )
PA5->( dbSetOrder( 1 ) )

cSeq     := Replicate( '0', TamSX3('PA5_SEQ')[1] )
dDataRef := Date()

//
// Id de Importacao Exportacao
//
cPrxId := u_PrxInd()

//
// Gravando LOG
//
RecLock( 'PA4', .T. )
PA4->PA4_FILIAL := xFilial( 'PA4' )
PA4->PA4_ID     := cPrxId
PA4->PA4_IMPEXP := 'E'
PA4->PA4_DTINI  := Date()
PA4->PA4_HRINI  := Time()
MSUnlock()

//
// Inicializando
//
//cBanco  := SuperGetMV( 'FS_INTBAN',, 'ORACLE/CSUD2' )
//cServer := SuperGetMV( 'FS_INTSER',, '10.10.1.183'  )

SRA->( dbSetOrder( 1 ) )
SR6->( dbSetOrder( 1 ) )

dIniMes    := FirstDay( dDataRef )
dFimMes    := LastDay( dDataRef )


u_MsgConMon( 'Job CSUCARG5 - Empresa '  + cEmpresa + '/' + cFilant + ' - Iniciado   '  + cTitulo,.F., .F. )



//
// Geracao da Intermediaria PA2 Admissoes
//
cQuery := ""
cQuery += "SELECT RA_FILIAL, RA_MAT, RA_NOME, RA_CIC, RA_NASC, RA_ADMISSA, RA_RG, RA_SITFOLH, "
cQuery += "       RA_TNOTRAB, RA_REGRA, RA_CODFUNC, RA_EQUIPE, RA_DEMISSA, R_E_C_N_O_ SRARECNO"
cQuery += "  FROM  " + RetSQLName( 'SRA' ) + " SRA "
cQuery += " WHERE RA_XENVADM = '' "
//cQuery += "   AND RA_ADMISSA BETWEEN '" + DToS( dIniMes ) + "' AND '" + DToS( dFimMes ) + "' "
cQuery += "   AND SRA.D_E_L_E_T_ = ' ' "
cQuery += "   ORDER BY RA_FILIAL, RA_MAT, R_E_C_N_O_ "

cTmp    := GetNextAlias()
dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cTmp, .F., .T. )
TcSetField( cTmp, "RA_NASC"   , "D", 8, 0)
TcSetField( cTmp, "RA_ADMISSA", "D", 8, 0)
TcSetField( cTmp, "RA_DEMISSA", "D", 8, 0)

dbSelectArea( cTmp )

While !(cTmp)->( EOF() )
	cAux  := StrTran( Time(), ':', '.' )
	
	Begin Transaction
	RecLock( 'PA2', .T. )
	PA2->PA2_NOME   := (cTmp)->RA_NOME
	PA2->PA2_FILIAL := (cTmp)->RA_FILIAL
	PA2->PA2_MAT    := (cTmp)->RA_MAT
	PA2->PA2_CIC    := (cTmp)->RA_CIC
	PA2->PA2_NASC   := (cTmp)->RA_NASC
	PA2->PA2_ADMISS := (cTmp)->RA_ADMISSA
	PA2->PA2_RG     := (cTmp)->RA_RG
	PA2->PA2_SITFOL := (cTmp)->RA_SITFOLH
	// Alterado para gravar a regra ao inves do turno a pedido de sergio da csu. 25/03/08
	PA2->PA2_REGRA  := (cTmp)->RA_REGRA
	PA2->PA2_TNOTRA := (cTmp)->RA_TNOTRAB
	PA2->PA2_CODFUN := (cTmp)->RA_CODFUNC
	PA2->PA2_EQUIPE := (cTmp)->RA_EQUIPE
	//PA2->PA2_DTINI  := (cTmp)->R8_DATAINI
	//PA2->PA2_DTFIM  := (cTmp)->R8_DATAFIM
	//PA2->PA2_DEMISS := (cTmp)->RA_DEMISSA
	PA2->PA2_DATA   := dDataRef
	PA2->PA2_HORA   := Val( SubStr( cAux, 1, 5 ) )
	
	PA2->PA2_OCORRE := '1'
	MsUnlock()
	
	SRA->( dbGoto( (cTmp)->SRARECNO ) )
	RecLock( 'SRA', .F. )
	SRA->RA_XENVADM := DtoS( dDataRef )
	SRA->RA_XENVALT := DtoS( dDataRef )
	MsUnlock()
	End Transaction
	
	(cTmp)->( dbSkip() )
End // EOF

(cTmp)->( dbCloseArea() )



//
// Geracao da Intermediaria PA2 Alteracoes Outras
//
cQuery := ""
cQuery += "SELECT RA_FILIAL, RA_MAT, RA_NOME, RA_CIC, RA_NASC, RA_ADMISSA, RA_RG, RA_SITFOLH, "
cQuery += "       RA_TNOTRAB, RA_REGRA, RA_CODFUNC,  RA_EQUIPE, RA_DEMISSA, R_E_C_N_O_ SRARECNO"
cQuery += "  FROM  " + RetSQLName( 'SRA' ) + " SRA "
cQuery += " WHERE SRA.D_E_L_E_T_ = ' ' "
cQuery += "   AND RA_XENVDEM = ' ' "
cQuery += "   AND RA_XENVALT = ' ' "
cQuery += "   AND RA_MSEXP   = '        ' "

cQuery += "   ORDER BY RA_FILIAL, RA_MAT, R_E_C_N_O_ "

cTmp    := GetNextAlias()
dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cTmp, .F., .T. )
TcSetField( cTmp, "RA_NASC"   , "D", 8, 0)
TcSetField( cTmp, "RA_ADMISSA", "D", 8, 0)
TcSetField( cTmp, "RA_DEMISSA", "D", 8, 0)

dbSelectArea( cTmp )

While !(cTmp)->( EOF() )
	cAux        := StrTran( Time(), ':', '.' )
	cSitFolha   := '1'
	
	If     !Empty( (cTmp)->RA_DEMISSA ) .OR. (cTmp)->RA_SITFOLH == 'D'
		cSitFolha   := '2'

	ElseIf (cTmp)->RA_SITFOLH == ' '
		cSitFolha   := '1'

	Else
		cSitFolha   := '2'

	EndIf
	
	Begin Transaction
	RecLock( 'PA2', .T. )
	PA2->PA2_NOME   := (cTmp)->RA_NOME
	PA2->PA2_FILIAL := (cTmp)->RA_FILIAL
	PA2->PA2_MAT    := (cTmp)->RA_MAT
	PA2->PA2_CIC    := (cTmp)->RA_CIC
	PA2->PA2_NASC   := (cTmp)->RA_NASC
	PA2->PA2_ADMISS := (cTmp)->RA_ADMISSA
	PA2->PA2_RG     := (cTmp)->RA_RG
	PA2->PA2_SITFOL := (cTmp)->RA_SITFOLH
	PA2->PA2_TNOTRA := (cTmp)->RA_TNOTRAB
	PA2->PA2_REGRA  := (cTmp)->RA_REGRA
	PA2->PA2_CODFUN := (cTmp)->RA_CODFUNC
	PA2->PA2_EQUIPE := (cTmp)->RA_EQUIPE
	
	If cSitFolha == '2' .and. Empty( (cTmp)->RA_DEMISSA )
		dIniAfas := CToD( '  /  / '  )
		dFimAfas := CToD( '  /  / '  )
		DataAfast( (cTmp)->RA_FILIAL, (cTmp)->RA_MAT, @dIniAfas, @dFimAfas, dDataRef)
		PA2->PA2_DTINI  := dIniAfas
		PA2->PA2_DTFIM  := dFimAfas
	EndIf
	
	//PA2->PA2_DEMISS := (cTmp)->RA_DEMISSA
	PA2->PA2_DATA   := dDataRef
	PA2->PA2_HORA   := Val( SubStr( cAux, 1, 5 ) )
	
	PA2->PA2_OCORRE := cSitFolha //iif( (cTmp)->RA_SITFOLH == ' ', '1', '2' )
	MsUnlock()
	
	SRA->( dbGoto( (cTmp)->SRARECNO ) )
	RecLock( 'SRA', .F. )
	SRA->RA_XENVALT   := DtoS( dDataRef )
	MsUnlock()
	End Transaction
	
	(cTmp)->( dbSkip() )
End // EOF

(cTmp)->( dbCloseArea() )



//
// Geracao da Intermediaria PA2 das demissoes
//
cQuery := ""
cQuery += "SELECT RA_FILIAL, RA_MAT, RA_NOME, RA_CIC, RA_NASC, RA_ADMISSA, RA_RG, RA_SITFOLH, "
cQuery += "       RA_TNOTRAB, RA_REGRA, RA_CODFUNC, RA_EQUIPE, RA_DEMISSA, SRA.R_E_C_N_O_ SRARECNO"
cQuery += "  FROM  " + RetSQLName( 'SRA' ) + " SRA "
cQuery += " WHERE RA_XENVDEM = '' "
//cQuery += "   AND RA_DEMISSA BETWEEN '" + DToS( dIniMes ) + "' AND '" + DToS( dFimMes ) + "' "
cQuery += "   AND SRA.D_E_L_E_T_ = ' ' "
cQuery += "   ORDER BY RA_FILIAL, RA_MAT, SRA.R_E_C_N_O_ "

cTmp    := GetNextAlias()
dbUseArea( .T., 'TOPCONN', TcGenQry( ,, cQuery ), cTmp, .F., .T. )
TcSetField( cTmp, 'RA_NASC'   , 'D', 8, 0)
TcSetField( cTmp, 'RA_ADMISSA', 'D', 8, 0)
TcSetField( cTmp, 'RA_DEMISSA', 'D', 8, 0)

dbSelectArea( cTmp )


//RA_RESCRAI$'30/31 - Transferido

While !(cTmp)->( EOF() )
	cAux  := StrTran( Time(), ':', '.' )
	Begin Transaction
	RecLock( 'PA2', .T. )
	PA2->PA2_NOME   := (cTmp)->RA_NOME
	PA2->PA2_FILIAL := (cTmp)->RA_FILIAL
	PA2->PA2_MAT    := (cTmp)->RA_MAT
	PA2->PA2_CIC    := (cTmp)->RA_CIC
	PA2->PA2_NASC   := (cTmp)->RA_NASC
	PA2->PA2_ADMISS := (cTmp)->RA_ADMISSA
	PA2->PA2_RG     := (cTmp)->RA_RG
	PA2->PA2_SITFOL := (cTmp)->RA_SITFOLH
	PA2->PA2_TNOTRA := (cTmp)->RA_TNOTRAB
	PA2->PA2_REGRA  := (cTmp)->RA_REGRA
	PA2->PA2_CODFUN	:= (cTmp)->RA_CODFUNC
	PA2->PA2_EQUIPE := (cTmp)->RA_EQUIPE
	//PA2->PA2_DTINI  := (cTmp)->R8_DATAINI
	//PA2->PA2_DTFIM  := (cTmp)->R8_DATAFIM
	PA2->PA2_DATA   := dDataRef
	PA2->PA2_HORA   := Val( SubStr( cAux, 1, 5 ) )
	PA2->PA2_DEMISS := (cTmp)->RA_DEMISSA
	PA2->PA2_OCORRE := '2'
	MsUnlock()
	
	SRA->( dbGoto( (cTmp)->SRARECNO ) )
	RecLock( 'SRA', .F. )
	SRA->RA_XENVDEM := DtoS( dDataRef )
	MsUnlock()
	End Transaction
	
	(cTmp)->( dbSkip() )
End // EOF

(cTmp)->( dbCloseArea() )


//
// Para for�ar a troca do minuto na grava��o dos afastados e assim o campo hora ( que faz parte da chave
// sera diferente dos outros movimentos forcando o afastamento a ser o ultima ocorrencia informada
//
Sleep( 65000 )


//
// Geracao da Intermediaria PA2 dos afastamentos
//
cQuery := ""
cQuery += "SELECT RA_FILIAL, RA_MAT, RA_NOME, RA_CIC, RA_NASC, RA_ADMISSA, RA_RG, RA_SITFOLH, "
cQuery += "       RA_TNOTRAB, RA_REGRA, RA_CODFUNC, RA_EQUIPE, RA_DEMISSA, "
cQuery += "       R8_DATAINI, R8_DATAFIM, SR8.R_E_C_N_O_ SR8RECNO"
cQuery += "  FROM  " + RetSQLName( 'SR8' ) + " SR8 "
cQuery += " INNER JOIN " + RetSQLName( 'SRA' ) + " SRA "
cQuery += "    ON RA_FILIAL = R8_FILIAL "
cQuery += "   AND RA_MAT    = R8_MAT    "
cQuery += "   AND SRA.D_E_L_E_T_ = ' ' "
cQuery += " WHERE R8_MSEXP = '        ' "
cQuery += "   AND R8_DATAINI <= '" + DToS( dDataRef ) + "' "
cQuery += "   AND R8_DATAFIM <= '" + DToS( dDataRef ) + "' "
cQuery += "   AND SR8.D_E_L_E_T_ = ' ' "
cQuery += "   ORDER BY R8_FILIAL, R8_MAT, R8_DATA DESC "

cTmp    := GetNextAlias()
dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cTmp, .F., .T. )
TcSetField( cTmp, 'RA_NASC'   , 'D', 8, 0)
TcSetField( cTmp, 'RA_ADMISSA', 'D', 8, 0)
TcSetField( cTmp, 'RA_DEMISSA', 'D', 8, 0)
TcSetField( cTmp, 'R8_DATAINI', 'D', 8, 0)
TcSetField( cTmp, 'R8_DATAFIM', 'D', 8, 0)

dbSelectArea( cTmp )

While !(cTmp)->( EOF() )
	
	cFuncAnt := (cTmp)->RA_FILIAL + (cTmp)->RA_MAT
	lFirst   := .T.
	
	While !(cTmp)->( EOF() ) .AND.  cFuncAnt == (cTmp)->RA_FILIAL + (cTmp)->RA_MAT
		
		Begin Transaction
		
		If lFirst
			cAux  := StrTran( Time(), ':', '.' )
			RecLock( 'PA2', .T. )
			PA2->PA2_NOME   := (cTmp)->RA_NOME
			PA2->PA2_FILIAL := (cTmp)->RA_FILIAL
			PA2->PA2_MAT    := (cTmp)->RA_MAT
			PA2->PA2_CIC    := (cTmp)->RA_CIC
			PA2->PA2_NASC   := (cTmp)->RA_NASC
			PA2->PA2_ADMISS := (cTmp)->RA_ADMISSA
			PA2->PA2_RG     := (cTmp)->RA_RG
			PA2->PA2_SITFOL := (cTmp)->RA_SITFOLH
			PA2->PA2_TNOTRA := (cTmp)->RA_TNOTRAB
			PA2->PA2_REGRA  := (cTmp)->RA_REGRA
			PA2->PA2_CODFUN := (cTmp)->RA_CODFUNC
			PA2->PA2_EQUIPE := (cTmp)->RA_EQUIPE
			PA2->PA2_DTINI  := (cTmp)->R8_DATAINI
			PA2->PA2_DTFIM  := (cTmp)->R8_DATAFIM
			PA2->PA2_DATA   := dDataRef
			PA2->PA2_HORA   := Val( SubStr( cAux, 1, 5 ) )
			//PA2->PA2_DEMISS := (cTmp)->RA_DEMISSA
			PA2->PA2_OCORRE := IIf( Empty((cTmp)->R8_DATAFIM), '2', '1' )
			MsUnlock()
			lFirst := .F.
			
		EndIf
		
		SR8->( dbGoto( (cTmp)->SR8RECNO ) )
		RecLock( 'SR8', .F. )
		SR8->R8_MSEXP := DtoS( dDataRef )
		MsUnlock()
		
		End Transaction
		
		(cTmp)->( dbSkip() )
	End // Funcioanrio
End // EOF

(cTmp)->( dbCloseArea() )



//
// Geracao da Intermediaria PA3
//
cQuery := ""
cQuery += "SELECT ZM_FILIAL, ZM_COD, ZM_DESCR, ZM_FSUPER, ZM_MSUPER, ZM_FCOOR, ZM_MCOOR, ZM_FGEREN, ZM_MGEREN, "
cQuery += "       ZM_ATIVO , R_E_C_N_O_ SZMRECNO "
cQuery += "  FROM  " + RetSQLName( 'SZM' ) + " SZM "
cQuery += " WHERE ZM_MSEXP = '        ' "
cQuery += "   AND SZM.D_E_L_E_T_ = ' ' "
//cQuery += " WHERE SZM.D_E_L_E_T_ = ' ' "


cTmp    := GetNextAlias()
dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cTmp, .F., .T. )

dbSelectArea( cTmp )

While !(cTmp)->( EOF() )
	cAux  := StrTran( Time(), ':', '.' )
	
	Begin Transaction
	RecLock( 'PA3', .T. )
	PA3->PA3_COD    := (cTmp)->ZM_COD
	PA3->PA3_DESCR  := (cTmp)->ZM_DESCR
	PA3->PA3_FSUPER := (cTmp)->ZM_FSUPER
	PA3->PA3_MSUPER := (cTmp)->ZM_MSUPER
	PA3->PA3_FCOOR  := (cTmp)->ZM_FCOOR
	PA3->PA3_MCOOR  := (cTmp)->ZM_MCOOR
	PA3->PA3_FGEREN := (cTmp)->ZM_FGEREN
	PA3->PA3_MGEREN := (cTmp)->ZM_MGEREN
	PA3->PA3_ATIVO  := (cTmp)->ZM_ATIVO 
	PA3->PA3_DATA   := dDataRef
	PA3->PA3_HORA   := Val( SubStr( cAux, 1, 5 ) )
	MsUnlock()
	
	SZM->( dbGoto( (cTmp)->SZMRECNO ) )
	RecLock( 'SZM', .F. )
	SZM->ZM_MSEXP := DtoS( dDataRef )
	MsUnlock()
	
	End Transaction
	
	(cTmp)->( dbSkip() )
	
End // EOF

(cTmp)->( dbCloseArea() )


//
// Apaga movimentos antigos
//
cQuery := ""
cQuery += " SELECT R_E_C_N_O_ PA2RECNO FROM " + RetSqlName( 'PA2' ) + " PA2 "
cQuery += "  WHERE D_E_L_E_T_ = ' ' "
cQuery += "    AND PA2_DATA < '" + DToS( Date() - 60 ) + "' "
cQuery += "    AND ( PA2_STATUS <> '' OR PA2_ERRO <> '' ) "

cTmp    := GetNextAlias()
dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cTmp, .F., .T. )

dbSelectArea( cTmp )

While !(cTmp)->( EOF() )
	
	Begin Transaction
	PA2->( dbGoto( (cTmp)->PA2RECNO ) )
	RecLock( 'PA2', .F. )
	dbDelete()
	MsUnlock()
	End Transaction
	
	(cTmp)->( dbSkip() )
	
End // EOF

(cTmp)->( dbCloseArea() )


cQuery := ""
cQuery += " SELECT R_E_C_N_O_ PA3RECNO FROM " + RetSqlName( 'PA3' ) + " PA3 "
cQuery += "  WHERE D_E_L_E_T_ = ' ' "
cQuery += "    AND PA3_DATA < '" + DToS( Date() - 60 ) + "' "
cQuery += "    AND ( PA3_STATUS <> '' OR PA3_ERRO <> '' )

cTmp    := GetNextAlias()
dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cTmp, .F., .T. )

dbSelectArea( cTmp )

While !(cTmp)->( EOF() )
	
	Begin Transaction
	PA3->( dbGoto( (cTmp)->PA3RECNO ) )
	RecLock( 'PA3', .F. )
	dbDelete()
	MsUnlock()
	End Transaction
	
	(cTmp)->( dbSkip() )
	
End // EOF

(cTmp)->( dbCloseArea() )





//
// Conex�o com a banco externo do Microsiga
//
nTipoConex := SuperGetMV( 'FS_TPCNIN',, 1 )
lContinua  := .T.

If nTipoConex == 1
	cConString  := SuperGetMV( 'FS_STRCON',, 'CSUD2' )
	
Else
	cAux := 'Sem conexao com banco CSU'
	
	cBanco  := SuperGetMV( 'FS_INTBAN',, 'ORACLE/CSUD2' )
	cServer := SuperGetMV( 'FS_INTSER',, '10.10.1.183'  )
	oDBIntermed := ClsDBAccess():New(cBanco,cServer)
	
	If !(lContinua   := oDBIntermed:AbreConexao())
		If !lManual
			RpcClearEnv()
		Else
			Final( cAux )
		EndIf
	EndIf
	
EndIf


If lContinua
	
	If nTipoConex == 1
		cCmd := " DELETE OPENQUERY( " + cConString + ", 'SELECT COD_FILIAL PA2_FILIAL FROM INT_FUNCIONARIO "
		cCmd += " WHERE FLG_LIDO = 1' ) "
		
		nErro := TcSqlExec( cCmd )
		
	Else
		cCmd := "DELETE FROM INT_FUNCIONARIO"
		cCmd += " WHERE FLG_LIDO = 1 "
		
		nErro := oDBIntermed:ExecQuery( cCmd )
		
	EndIf
	
	If  nErro < 0
		cAux := 'Nao deletado os lidos da INT_FUNCIONARIO /  ' +  ;
		AllTrim( Str( nErro ) ) + ' ' + ;
		u_ErSQLExec( nErro ) + ' [' + cCmd + ']'
		u_MsgConMon( cAux )
		
		lTeveErro  := .T.
		
		//
		// Grava LOG
		//
		cSeq := Soma1( cSeq )
		RecLock( 'PA5', .T. )
		PA5->PA5_FILIAL := xFilial( 'PA5' )
		PA5->PA5_ID     := cPrxId
		//PA5->PA5_TABELA := 'PA2'
		PA5->PA5_SEQ    := cSeq
		PA5->PA5_FILERR := ''
		PA5->PA5_MATERR := ''
		//PA5->PA5_NOME   := ''
		PA5->PA5_CODERR := '101'
		PA5->PA5_MENSAG := 'Nao deletado os lidos da INT_FUNCIONARIO'
		MSUnlock()
		
	EndIf
	
	If nTipoConex == 1
		cCmd := " DELETE OPENQUERY( " + cConString + ", 'SELECT COD_EQUIPE PA3_COD FROM INT_EQUIPE "
		cCmd += " WHERE FLG_LIDO = 1' ) "
		
		nErro := TcSqlExec( cCmd )
		
	Else
		cCmd := "DELETE FROM INT_EQUIPE "
		cCmd += " WHERE FLG_LIDO = 1 "
		
		nErro := oDBIntermed:ExecQuery( cCmd )
		
	EndIf
	
	If  nErro < 0
		cAux := 'Nao deletado os lidos da INT_EQUIPE /  ' +  ;
		AllTrim( Str( nErro ) ) + ' ' + ;
		u_ErSQLExec( nErro ) + ' [' + cCmd + ']'
		u_MsgConMon( cAux )
		
		lTeveErro := .T.
		
		//
		// Grava LOG
		//
		cSeq := Soma1( cSeq )
		RecLock( 'PA5', .T. )
		PA5->PA5_FILIAL := xFilial( 'PA5' )
		PA5->PA5_ID     := cPrxId
		//PA5->PA5_TABELA := 'PA2'
		PA5->PA5_SEQ    := cSeq
		PA5->PA5_FILERR := ''
		PA5->PA5_MATERR := ''
		//PA5->PA5_NOME   := ''
		PA5->PA5_CODERR := '102'
		PA5->PA5_MENSAG := 'Nao deletado os lidos da INT_EQUIPE'
		MSUnlock()
		
		
	EndIf
	
	//
	// Geracao tabela CSU INT_FUNCIONARIO
	//
	cQuery := ""
	cQuery += " SELECT  PA2_NOME, PA2_FILIAL, PA2_MAT,	PA2_CIC, PA2_NASC, PA2_ADMISS "
	cQuery += "       , PA2_RG, PA2_SITFOL, PA2_TNOTRA, PA2_EQUIPE, PA2_DTINI, PA2_DTFIM, PA2_DEMISS "
	cQuery += "       , PA2_OCORRE, PA2_DATA, PA2_HORA, PA2_CODFUN, PA2_REGRA, PA2.R_E_C_N_O_ PA2RECNO  "
	cQuery += "  FROM  " + RetSQLName( 'PA2' ) + " PA2 "
	//cQuery += " WHERE PA2_FILIAL = '" + xFilial( 'PA2' ) + "' "
	cQuery += " WHERE PA2_STATUS = '        ' "
	cQuery += "   AND PA2_ERRO   = '        ' "
	cQuery += "   AND PA2.D_E_L_E_T_ = ' ' "
	cQuery += "   ORDER BY PA2_FILIAL, PA2_MAT "
	
	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cTmp, .F., .T. )
	dbSelectArea( cTmp )
	
	While !(cTmp)->( EOF() )
		
		//
		// Atualizacao da tabela CSU
		//
		If nTipoConex == 1
			nErro := TcSqlExec( cCmd )
			
			cCmd := "INSERT OPENQUERY( " + cConString + ", 'SELECT "
			cCmd += "COD_FILIAL, "
			cCmd += "COD_MATRICULA, "
			cCmd += "COD_REGRA_TURNO, "
			cCmd += "NOM_USUARIO, "
			cCmd += "NUM_CPF, "
			cCmd += "DAT_NASCIMENTO, "
			cCmd += "DAT_ADMISSAO, "
			cCmd += "NUM_RG, "
			cCmd += "IND_SITUACAO_FOLHA, "
			cCmd += "COD_EQUIPE, "
			cCmd += "DAT_INICIO_SITUACAO, "
			cCmd += "DAT_FIM_SITUACAO, "
			cCmd += "DAT_DEMISSAO, "
			cCmd += "IND_STATUS_OCORRENCIA, "
			cCmd += "DAT_INCLUSAO, "
			cCmd += "HRR_INCLUSAO, "
			cCmd += "FLG_LIDO, "
			cCmd += "COD_FUNCAO "
			cCmd += "FROM INT_FUNCIONARIO "
			cCmd += "' )"
			cCmd += " VALUES "
			cCmd += "( "
			cCmd += "'" + (cTmp)->PA2_FILIAL + "', "
			cCmd += "'" + (cTmp)->PA2_MAT    + "', "
			cCmd += "'" + (cTmp)->PA2_REGRA  + "', "
			cCmd += "'" + IIf( "'" $ (cTmp)->PA2_NOME, StrTran( (cTmp)->PA2_NOME, "'", "" ), (cTmp)->PA2_NOME )  + "', "
			cCmd += "'" + (cTmp)->PA2_CIC               + "', "
			cCmd += " " + TrataData( (cTmp)->PA2_NASC   )  +  ", "
			cCmd += " " + TrataData( (cTmp)->PA2_ADMISS )  +  ", "
			cCmd += "'" + (cTmp)->PA2_RG                + "', "
			cCmd += "'" + (cTmp)->PA2_SITFOL            + "', "
			cCmd += "'" + (cTmp)->PA2_EQUIPE            + "', "
			cCmd += " " + TrataData( (cTmp)->PA2_DTINI  )  +  ", "
			cCmd += " " + TrataData( (cTmp)->PA2_DTFIM  )  +  ", "
			cCmd += " " + TrataData( (cTmp)->PA2_DEMISS )  +  ", "
			cCmd += "'" + (cTmp)->PA2_OCORRE            + "', "
			cCmd += " " + TrataData( (cTmp)->PA2_DATA  )   +  ", "
			cCmd += " " + Transform( (cTmp)->PA2_HORA, '99.99' ) + ", "
			cCmd += " 0, "
			cCmd += "'" + (cTmp)->PA2_CODFUN + "'  "
			cCmd += " ) "
			
		Else
			cCmd := "INSERT INTO INT_FUNCIONARIO "
			cCmd += "( "
			cCmd += "COD_FILIAL, "
			cCmd += "COD_MATRICULA, "
			cCmd += "COD_REGRA_TURNO, "
			cCmd += "NOM_USUARIO, "
			cCmd += "NUM_CPF, "
			cCmd += "DAT_NASCIMENTO, "
			cCmd += "DAT_ADMISSAO, "
			cCmd += "NUM_RG, "
			cCmd += "IND_SITUACAO_FOLHA, "
			cCmd += "COD_EQUIPE, "
			cCmd += "DAT_INICIO_SITUACAO, "
			cCmd += "DAT_FIM_SITUACAO, "
			cCmd += "DAT_DEMISSAO, "
			cCmd += "IND_STATUS_OCORRENCIA, "
			cCmd += "DAT_INCLUSAO, "
			cCmd += "HRR_INCLUSAO, "
			cCmd += "FLG_LIDO, "
			cCmd += "COD_FUNCAO "
			cCmd += " ) "
			cCmd += " VALUES "
			cCmd += "( "
			cCmd += "'" + (cTmp)->PA2_FILIAL + "', "
			cCmd += "'" + (cTmp)->PA2_MAT    + "', "
			cCmd += "'" + (cTmp)->PA2_REGRA  + "', "
			cCmd += "'" + IIf( "'" $ (cTmp)->PA2_NOME, StrTran( (cTmp)->PA2_NOME, "'", "" ), (cTmp)->PA2_NOME )  + "', "
			cCmd += "'" + (cTmp)->PA2_CIC    + "', "
			cCmd += " " + TrataData( (cTmp)->PA2_NASC   ) + ", "
			cCmd += " " + TrataData( (cTmp)->PA2_ADMISS ) + ", "
			cCmd += "'" + (cTmp)->PA2_RG     + "', "
			cCmd += "'" + (cTmp)->PA2_SITFOL + "', "
			cCmd += "'" + (cTmp)->PA2_EQUIPE + "', "
			cCmd += " " + TrataData( (cTmp)->PA2_DTINI  ) + ", "
			cCmd += " " + TrataData( (cTmp)->PA2_DTFIM  ) + ", "
			cCmd += " " + TrataData( (cTmp)->PA2_DEMISS ) + ", "
			cCmd += "'" + (cTmp)->PA2_OCORRE + "',  "
			cCmd += " " + TrataData( (cTmp)->PA2_DATA  ) + ", "
			cCmd += " " + Transform( (cTmp)->PA2_HORA, '99.99' ) + ",  "
			cCmd += " 0, "
			cCmd += "'" + (cTmp)->PA2_CODFUN + "'  "
			cCmd += ") "
			
			nErro := oDBIntermed:ExecQuery( cCmd )
			
		EndIf
		
		If nErro < 0
			cAux := 'Nao atualizou tabela CSU  ' + (cTmp)->( PA2_FILIAL + ' ' + PA2_MAT ) + ' / ' + ;
			AllTrim( Str( nErro ) ) + ' ' + ;
			u_ErSQLExec( nErro ) + ' [' + cCmd + ']'
			u_MsgConMon( cAux )
			PA2->( dbGoTo( (cTmp)->PA2RECNO )  )
			RecLock( 'PA2', .F. )
			PA2->PA2_ERRO   := DToS( dDataRef )
			PA2->PA2_LOG    := cAux
			MSUnlock()
			
			lTeveErro  := .T.
			
			//
			// Grava LOG
			//
			cSeq := Soma1( cSeq )
			RecLock( 'PA5', .T. )
			PA5->PA5_FILIAL := xFilial( 'PA5' )
			PA5->PA5_ID     := cPrxId
			//PA5->PA5_TABELA := 'PA2'
			PA5->PA5_SEQ    := cSeq
			PA5->PA5_FILERR := (cTmp)->PA2_FILIAL
			PA5->PA5_MATERR := (cTmp)->PA2_MAT
			//PA5->PA5_NOME   := ''
			PA5->PA5_CODERR := '103'
			PA5->PA5_MENSAG := 'Nao atualizou tabela CSU  '
			PA5->PA5_COMPLE := cCmd
			MSUnlock()
			
		Else
			PA2->( dbGoTo( (cTmp)->PA2RECNO )  )
			RecLock( 'PA2', .F. )
			PA2->PA2_STATUS := DToS( dDataRef )
			MSUnlock()
			
		EndIf
		
		(cTmp)->( dbSkip() )
	End // EOF
	
	(cTmp)->( dbCloseArea() )
	
	
	//
	// Geracao tabela CSU INT_EQUIPE
	//
	cQuery := ""
	cQuery += " SELECT PA3_FILIAL, PA3_COD, PA3_DESCR, PA3_FSUPER, PA3_MSUPER, PA3_FCOOR, PA3_MCOOR, "
	cQuery += "        PA3_ATIVO, PA3_FGEREN, PA3_MGEREN, PA3_DATA, PA3_HORA, R_E_C_N_O_ PA3RECNO "
	cQuery += "  FROM  " + RetSQLName( 'PA3' ) + " PA3 "
	//cQuery += " WHERE PA3_FILIAL = '" + xFilial( 'PA3' ) + "' "
	cQuery += " WHERE PA3_STATUS = '        ' "
	cQuery += "   AND PA3_ERRO   = '        ' "
	cQuery += "   AND PA3.D_E_L_E_T_ = ' ' "
	cQuery += " ORDER BY PA3_FILIAL, PA3_COD "
	
	cTmp   := GetNextAlias()
	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cTmp, .F., .T. )
	dbSelectArea( cTmp )
	
	While !(cTmp)->( EOF() )
		//
		// Atualizacao da tabela CSU
		//
		If nTipoConex == 1
			
			cCmd := "INSERT OPENQUERY( " + cConString + ", 'SELECT "
			cCmd += "COD_EQUIPE, "
			cCmd += "DSC_EQUIPE, "
			cCmd += "COD_FILIAL_SUPERVISOR, "
			cCmd += "COD_MATRICULA_SUPERVISOR, "
			cCmd += "COD_FILIAL_COORDENADOR, "
			cCmd += "COD_MATRICULA_COORDENADOR, "
			cCmd += "COD_FILIAL_GERENTE, "
			cCmd += "COD_MATRICULA_GERENTE, "
			cCmd += "DAT_INCLUSAO, "
			cCmd += "HRR_INCLUSAO, "
			cCmd += "FLG_LIDO, "
			cCmd += "FLG_ATIVO  "
			cCmd += "FROM INT_EQUIPE  "
			cCmd += "' ) "
			cCmd += " VALUES "
			cCmd += "( "
			cCmd += "'" + (cTmp)->PA3_COD    + "', "
			cCmd += "'" + IIf( "'" $ (cTmp)->PA3_DESCR, StrTran( (cTmp)->PA3_DESCR, "'", ""  ), (cTmp)->PA3_DESCR )  + "', "
			cCmd += "'" + (cTmp)->PA3_FSUPER + "', "
			cCmd += "'" + (cTmp)->PA3_MSUPER + "', "
			cCmd += "'" + (cTmp)->PA3_FCOOR  + "', "
			cCmd += "'" + (cTmp)->PA3_MCOOR  + "', "
			cCmd += "'" + (cTmp)->PA3_FGEREN + "', "
			cCmd += "'" + (cTmp)->PA3_MGEREN + "', "
			cCmd += " " + TrataData( (cTmp)->PA3_DATA    ) + ", "
			cCmd += " " + Transform( (cTmp)->PA3_HORA, '99.99' ) + ",  "
			cCmd += IIf( (cTmp)->PA3_ATIVO  == 'S', '1', '0' )+ ",  "
			cCmd += " 0 "
			cCmd += ") "
			
			nErro := TcSqlExec( cCmd )
			
		Else
			cCmd := "INSERT INTO INT_EQUIPE "
			cCmd += "( "
			cCmd += "COD_EQUIPE, "
			cCmd += "DSC_EQUIPE, "
			cCmd += "COD_FILIAL_SUPERVISOR, "
			cCmd += "COD_MATRICULA_SUPERVISOR, "
			cCmd += "COD_FILIAL_COORDENADOR, "
			cCmd += "COD_MATRICULA_COORDENADOR, "
			cCmd += "COD_FILIAL_GERENTE, "
			cCmd += "COD_MATRICULA_GERENTE, "
			cCmd += "DAT_INCLUSAO, "
			cCmd += "HRR_INCLUSAO, "
			cCmd += "FLG_LIDO, "
			cCmd += "FLG_ATIVO  "
			cCmd += ") "
			cCmd += " VALUES "
			cCmd += "( "
			cCmd += "'" + (cTmp)->PA3_COD    + "', "
			cCmd += "'" + IIf( "'" $ (cTmp)->PA3_DESCR, StrTran( (cTmp)->PA3_DESCR, "'", ""  ), (cTmp)->PA3_DESCR )  + "', "
			cCmd += "'" + (cTmp)->PA3_FSUPER + "', "
			cCmd += "'" + (cTmp)->PA3_MSUPER + "', "
			cCmd += "'" + (cTmp)->PA3_FCOOR  + "', "
			cCmd += "'" + (cTmp)->PA3_MCOOR  + "', "
			cCmd += "'" + (cTmp)->PA3_FGEREN + "', "
			cCmd += "'" + (cTmp)->PA3_MGEREN + "', "
			cCmd += " " + TrataData( (cTmp)->PA3_DATA    ) + ", "
			cCmd += " " + Transform( (cTmp)->PA3_HORA, '99.99' ) + ",  "
			cCmd += IIf( (cTmp)->PA3_ATIVO  == 'S', '1', '0' )+ ",  "
			cCmd += " 0 "
			cCmd += ") "
			
			nErro := oDBIntermed:ExecQuery( cCmd )
			
		EndIf
		
		If  nErro < 0
			cAux := 'Nao foi possivel atualizar a tabela CSU de equipes  ' + (cTmp)->( PA3_FILIAL + ' ' + PA3_COD  ) + ' / ' + ;
			AllTrim( Str( nErro ) ) + ' ' + ;
			u_ErSQLExec( nErro ) + ' [' + cCmd + ']'
			u_MsgConMon( cAux )
			PA3->( dbGoTo( (cTmp)->PA3RECNO )  )
			RecLock( 'PA3', .F. )
			PA3->PA3_ERRO   := DToS( dDataRef )
			PA3->PA3_LOG    := cAux
			MSUnlock()
			
			
			lTeveErro  := .T.
			
			//
			// Grava LOG
			//
			cSeq := Soma1( cSeq )
			RecLock( 'PA5', .T. )
			PA5->PA5_FILIAL := xFilial( 'PA5' )
			PA5->PA5_ID     := cPrxId
			//PA5->PA5_TABELA := 'PA2'
			PA5->PA5_SEQ    := cSeq
			PA5->PA5_FILERR := (cTmp)->PA3_FILIAL
			PA5->PA5_EQUERR := (cTmp)->PA3_COD
			//PA5->PA5_NOME   := ''
			PA5->PA5_CODERR := '104'
			PA5->PA5_MENSAG := 'Nao foi possivel atualizar a tabela CSU de equipes'
			PA5->PA5_COMPLE := cCmd
			MSUnlock()
			
		Else
			PA3->( dbGoTo( (cTmp)->PA3RECNO )  )
			RecLock( 'PA3', .F. )
			PA3->PA3_STATUS := DToS( dDataRef )
			MSUnlock()
			
		EndIf
		
		(cTmp)->( dbSkip() )
	End // EOF
	
	(cTmp)->( dbCloseArea() )
	
Else
	u_MsgConMon( 'Nao abriu conex�o com o banco' )
	
EndIf

u_MsgConMon( 'Job CSUCARG5 - Empresa '  + cEmpresa + '/' + cFilant + ' - Finalizado ' + cTitulo,.F., .F. )


If cPrxId > GetMV( 'FS_IDINT' )
	PutMv( 'FS_IDINT', cPrxId )
EndIf

FreeUsedCode()

dbSelectArea( 'PA4' )
PA4->( dbSetOrder( 1 ) )
PA4->( dbSeek( xFilial( 'PA4' )  + cPrxId) )
RecLock( 'PA4', .F. )
PA4->PA4_DTFIM  := Date()
PA4->PA4_HRFIM  := Time()
PA4->PA4_STATUS := IIf( lTeveErro, '2', '1' )
MSUnlock()

If lTeveErro
	Notifica( cPrxId )
EndIf

If !lManual
	RpcClearEnv()
EndIf

Return NIL


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    �TrataData �Autor  � Ernani Forastieri  � Data �  28/02/08   ���
�������������������������������������������������������������������������͹��
���Descricao � Funcao para tratar a data no INSERT                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function TrataData( cData )
Local cRet :=  "To_Date('"+cData+"', 'yyyymmdd')"

If Empty( cData )
	cRet := 'NULL'
EndIf

Return cRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � Notifica �Autor  � Ernani Forastieri  � Data �  28/02/08   ���
�������������������������������������������������������������������������͹��
���Descricao � Notifica erro por email                                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Notifica( cPrxId )
Local cMsg    := ''
Local cEmail  := SuperGetMV('FS_EMERINT' ,,'')
Local cLogo   := SuperGetMV('FS_LGERINT' ,,'')

cMsg := MemoRead( SuperGetMV( 'FS_MDERRIN',,'\workflow\modelo\intponto.htm' ) )
cMsg := StrTran( cMsg, '!INTID!'     , cPrxId )
cMsg := StrTran( cMsg, '!OPER!'      , 'EXPORTA��O')
cMsg := StrTran( cMsg, '!LOGOTIPO!'  , cLogo )
cMsg := StrTran( cMsg, '!DATA!'      , DToC( Date() ) )
cMsg := StrTran( cMsg, '!HORA!'      , Time()  )
cMsg := StrTran( cMsg, CRLF          , '' )

u_EnvMail( , cEmail,, 'INTERFACE PONTO ELETRONICO - ID ' +  cPrxId,, cMsg )

Return NIL


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � DataAfast�Autor  � Ernani Forastieri  � Data �  28/02/08   ���
�������������������������������������������������������������������������͹��
���Descricao � Retorna as datas de afastamento do funcionarios            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function DataAfast( cFilFunc, cMatFunc, dIni, dFim, dDataRef)
Local cQuery := ''
Local aArea  := GetArea() 

dIni := CToD( '  /  /  ' )
dFim := CToD( '  /  /  ' )

cQuery += "SELECT R8_DATAINI, R8_DATAFIM FROM " + RetSqlName('SR8') + " SR8 "
cQuery += " WHERE R8_FILIAL =  '" + cFilFunc + "' "
cQuery += "   AND R8_MAT = '" + cMatFunc + "' "
//cQuery += "   AND R8_TIPO <> 'F' "
cQuery += "   AND R8_DATAINI <= '" + DToS( dDataRef ) + "' "
cQuery += "   AND R8_DATAFIM <= '" + DToS( dDataRef ) + "' "
cQuery += "   AND SR8.D_E_L_E_T_ = ' ' "
cQuery += " ORDER BY R8_FILIAL, R8_MAT, R8_DATA DESC "

dbUseArea( .T., 'TOPCONN', TcGenQry( ,, cQuery ), 'AFAS', .F., .T. )

If !AFAS->( EOF() )
	AFAS->( dbGoTop() )
	
	dIni := SToD( AFAS->R8_DATAINI )
	dFim := SToD( AFAS->R8_DATAFIM )
	
	
EndIf

AFAS->( dbCloseArea() )

RestArea( aArea )
Return NIL