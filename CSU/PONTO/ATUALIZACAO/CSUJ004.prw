#INCLUDE 'PROTHEUS.CH'
#Include 'TopConn.ch'

User Function TesteCSU4() // Teste de Envio WF
Return u_CSUJ004( { .F., '05', '01' }  )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ CSUJ002  ºAutor  ³ Ernani Forastieri  º Data ³  28/02/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina de Integracao dos afastamentos, demisseos ou        º±±
±±º          ³ admissoes da folha                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CSUJ004( aParams )
Local lManual     := IIf( aParams == NIL, .T., aParams[1] )
Local cEmpresa    := IIf( lManual, cEmpAnt, aParams[2] )
Local cFil        := IIf( lManual, cFilAnt, aParams[3] )
Local cTitulo     := 'Exportacoes dos dados das marcacoes'
Local cQuery      := ''
Local cQuery2     := ''
Local cCmd        := ''
Local cConString  := ''
Local cBanco      := ''
Local cServer     := ''
Local cAux        := ''
Local cFuncAnt    := ''
Local lFirst      := .T.
Local lContinua   := .T.
Local nErro       := 0
Local oDBIntermed
Local cPrxId      := ''
Local cSeq        := ''
Local lTeveErro   := .F.
Private nHdl_   := FCreate( '\marcacao\log\Exp-Faltas-'+Dtos(Date())+'-'+StrTran(Time(),":","_")+'.log',1 )
Private cLogMarc:= 'Inicio do log da Marcacao - '+cTitulo
Private cEol    := Chr(13)+Chr(10)
Private cTmp     := ''
Private cTmp2    := ''
Private cTmp3    := ''


//
// Prepara ambiente se for JOB
//
If !lManual
	RpcSetType( 3 )
	RpcSetEnv( cEmpresa, cFil,,,'FOL' )
EndIf

If !MayIUseCode( 'CSUJ004' + cEmpresa )
FWrite( nHdl_, 'Job CSUJ004 - Empresa/Filial ' + cEmpresa + cFil + ' - Ja Esta Em Andamento'+cEol )
	u_MsgConMon( 'Job CSUJ004 - Empresa ' + cEmpresa + ' - Ja Esta Em Andamento' ,, .F. ) //
	Return NIL
EndIf

SRD->( dbSetOrder( 1 ) )
PAA->( dbSetOrder( 1 ) )
PAB->( dbSetOrder( 1 ) )

cSeq     := Replicate( '0', TamSX3('PAB_SEQ')[1] )

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³ID de importacao/Exportacao       										   ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
FWrite( nHdl_, "Obtendo Id de Importacao / Exportacao"+cEol )
cPrxId := u_PrxInd()

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³Inicia a gravação do LOG.        										   ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
FWrite( nHdl_, "Gravando log"+cEol )
RecLock( 'PAA', .T. )
PAA->PAA_FILIAL := xFilial( 'PAA' )
PAA->PAA_ID     := cPrxId
PAA->PAA_IMPEXP := 'I'
PAA->PAA_DTINI  := Date()
PAA->PAA_HRINI  := Time()
MSUnlock()


/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³Inicia a a conexao               										   ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
//cBanco  := SuperGetMV( 'FS_INTBAN',, 'ORACLE/CSUD4' )
//cServer := SuperGetMV( 'FS_INTSER',, '10.10.1.183'  )

u_MsgConMon( 'Job CSUJ004 - Empresa '  + cEmpresa + '/' + cFilant + ' - Iniciado   '  + cTitulo,.F., .F. )


/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³Verifica o periodo anterior ao aberto para ser importado					  ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
cMes := SubStr(GetMv("MV_FOLMES"),5,6)
cAno := SubStr(GetMv("MV_FOLMES"),1,4)
cPeriodo := cAno + StrZero(Val(cMes) - 1,2)

if (Val(cMes) - 1) == 0
	cMes := "12"
	cAno := Str(Val(cAno) - 1)
	cPeriodo := cAno + cMes
Endif	

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³Filtra os dados da tabela de acumulados a serem importados                 ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
cQuery := ""
cQuery += " SELECT RD.RD_FILIAL, RD.RD_MAT,RD.RD_DATARQ, "
cQuery += " (SELECT  ISNULL(SUM(RD_HORAS),0) FROM  "+RetSQLName("SRD")+" "
cQuery += "  WHERE RD_DATARQ = '" + cPeriodo + "' "
cQuery += "  	AND RD_PD IN "+ FormatIn(GetMV("FS_PA9VERB"), "/") + " "
cQuery += "  	AND RD_FILIAL = RD.RD_FILIAL "
cQuery += "  	AND RD_MAT = RD.RD_MAT "
cQuery += "  	AND RD_DATARQ = RD.RD_DATARQ "
cQuery += "  	AND D_E_L_E_T_ = '') AS FALTAS "
cQuery += " FROM SRD050 RD "
cQuery += " WHERE RD.RD_DATARQ = '"+ cPeriodo +	 "' "
cQuery += "  	AND RD.D_E_L_E_T_ = '' "
cQuery += "  GROUP BY RD.RD_FILIAL, RD.RD_MAT, RD.RD_DATARQ "
cQuery += "  ORDER BY RD.RD_FILIAL, RD.RD_MAT, RD.RD_DATARQ "

cTmp   := GetNextAlias()
FWrite( nHdl_, "Inicio Geracao da Intermediaria PA9 Absenteismo => "+cQuery+cEol )
dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cTmp, .F., .T. )
FWrite( nHdl_, "Gerando registros dos funcionários com falta => "+cQuery+cEol )

	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  ³Inicio a gravacao da PA9 (Absenteismo)                                     ³
	  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - Inicio da gravacao da PA9"+cEol )

DbSelectarea("PA9")
DbSetOrder(1)
While !(cTmp)->( EOF() )
	Begin Transaction
		If PA9->(DbSeek((cTmp)->RD_FILIAL+(cTmp)->RD_MAT+(cTmp)->RD_DATARQ))
			FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - Registro já existe na tabela PA9 - Filial: "+(cTmp)->RD_FILIAL+"/"+(cTmp)->RD_MAT+cEol )
		Else
			FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - Incluindo registro na PA9 - Filial: "+(cTmp)->RD_FILIAL+"/"+(cTmp)->RD_MAT+cEol )
			RecLock( 'PA9', .T. )
				PA9->PA9_FILIAL := (cTmp)->RD_FILIAL
				PA9->PA9_MAT    := (cTmp)->RD_MAT
				PA9->PA9_FALTAS := (cTmp)->FALTAS
				PA9->PA9_PERIOD := (cTmp)->RD_DATARQ
			MSUnlock()

		Endif
	End Transaction
	(cTmp)->(dBsKIP())
EndDo

(cTmp)->(dBCloseArea())	
FWrite( nHdl_ , "Fim Geracao da Intermediaria PA9 Absenteismo => "+cEol )

/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  ³Conexao com banco de dados ORACLE                                          ³
  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
nTipoConex := SuperGetMV( 'FS_TPCNIN',, 1 )
lContinua  := .T.

If nTipoConex == 1
	cConString  := SuperGetMV( 'FS_STRCON',, 'CSUD4' )
FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - nTipoConex igual a 1"+cEol )		
Else
FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - nTipoConex igual a 2"+cEol )		
	cAux := 'Sem conexao com banco CSU'
	
	cBanco  := SuperGetMV( 'FS_INTBAN',, 'ORACLE/CSUD4' )
	cServer := SuperGetMV( 'FS_INTSER',, '10.10.1.183'  )
	oDBIntermed := ClsDBAccess():New(cBanco,cServer)

	If !(lContinua   := oDBIntermed:AbreConexao())
FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - "+cAux+cEol )		
		If !lManual
	 //		RpcClearEnv()
		Else
			Final( cAux )
		EndIf
	EndIf
	
EndIf

FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+cEol )		

If lContinua
	
	If nTipoConex == 1
		cCmd := " DELETE OPENQUERY( " + cConString + ", 'SELECT COD_FILIAL COD_MATRICULA FROM INT_ABS "
		cCmd += " WHERE FLG_LIDO = 1' ) "
		
		nErro := TcSqlExec( cCmd )
		
	Else
		cCmd := "DELETE FROM INT_ABS"
		cCmd += " WHERE FLG_LIDO = 1 "
		
		nErro := oDBIntermed:ExecQuery( cCmd )
		
	EndIf

	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 	  ³Verifica se houve erro para a gravacao do LOG.                             ³
	  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/	
	If  nErro < 0
		cAux := 'Nao deletado os lidos da INT_ABS /  ' +  ;
		AllTrim( Str( nErro ) ) + ' ' + ;
		u_ErSQLExec( nErro ) + ' [' + cCmd + ']'
		u_MsgConMon( cAux )
		
		FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - "+cAux+cEol )		
		lTeveErro  := .T.
		
		/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		  ³Grava LOG na tabela PAB                                                    ³
		  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		cSeq := Soma1( cSeq )
		RecLock( 'PAB', .T. )
		PAB->PAB_FILIAL := xFilial( 'PAB' )
		PAB->PAB_ID     := cPrxId
		PAB->PAB_SEQ    := cSeq
		PAB->PAB_FILERR := ''
		PAB->PAB_MATERR := ''
		PAB->PAB_CODERR := '001'
		PAB->PAB_MENSAG := 'Nao deletado os lidos da INT_ABS'
		PAB->PAB_COMPLE := cCmd
		MSUnlock()
		
	EndIf
	
	
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  ³Inicio a gravacao da PA9 (Absenteismo)                                     ³
	  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/

	cTmp3   := GetNextAlias()
	cQuery := ""
	cQuery += " SELECT  *  "
	cQuery += " FROM  " + RetSQLName( 'PA9' ) + " "
	cQuery += " WHERE PA9_LIDO = ' ' "
	cQuery += "   AND D_E_L_E_T_ = ' ' "
	
	FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - Inicio Geracao tabela CSU INT_ABS => "+cQuery+cEol )		

	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cTmp3, .F., .T. )
	FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - Fim Geracao tabela CSU INT_ABS"+cEol )		
	dbSelectArea( cTmp3 )
	

	While !(cTmp3)->( EOF() )
		
		/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		  ³Atualizacao da tabela CSU                                                  ³
		  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		If nTipoConex == 1
			nErro := TcSqlExec( cCmd )
			
			cCmd := "INSERT OPENQUERY( " + cConString + ", 'SELECT "
			cCmd += "COD_FILIAL, "
			cCmd += "COD_MATRICULA, "
			cCmd += "COD_FALTAS, "
			cCmd += "DAT_COMPETENCIA, "
			cCmd += "FROM INT_ABS "
			cCmd += "' )"
			cCmd += " VALUES "
			cCmd += "( "
			cCmd += "'" + (cTmp3)->PA9_FILIAL	+ "', "
			cCmd += "'" + (cTmp3)->PA9_MAT		+ "', "
			cCmd += "'" + (cTmp3)->PA9_FALTAS	+ "', "
			cCmd += "'" + (cTmp3)->PA9_PERIODO	+ "', "
			cCmd += " ) "
			
		Else
			cCmd := "INSERT INTO INT_ABS "
			cCmd += "( "
			cCmd += "COD_FILIAL, "
			cCmd += "COD_MATRICULA, "
			cCmd += "QTD_FALTAS, "
			cCmd += "DAT_COMPETENCIA "
			cCmd += " ) "
			cCmd += " VALUES "
			cCmd += "( "
			cCmd += " " + (cTmp3)->PA9_FILIAL	+ ", "
			cCmd += "'" + (cTmp3)->PA9_MAT		+ "', "
			cCmd += " " + AllTrim(STR((cTmp3)->PA9_FALTAS))	+ " , "
			cCmd += " " + (cTmp3)->PA9_PERIODO	+ " "
			cCmd += ") "
			
			nErro := oDBIntermed:ExecQuery( cCmd )
			
		EndIf

		If nErro < 0
		/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		  ³Grava erro na tabela PA9 para importar novamente.                          ³
		  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
			cAux := AllTrim( Str( nErro ) ) + ' - ' + u_ErSQLExec( nErro ) + ' [' + cCmd + ']'
			u_MsgConMon( cAux )
			PA9->( dbGoTo( (cTmp3)->R_E_C_N_O_ )  )
			RecLock( 'PA9', .F. )
			PA9->PA9_ERRO   := Date()
			PA9->PA9_LOG    := cAux
			MSUnlock()
  			
			FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - "+cAux+cEol )		
			lTeveErro  := .T.
			
		/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		  ³Grava regsitro na tabela de LOG.                                           ³
		  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
			//
			// Grava LOG
			//
			cSeq := Soma1( cSeq )
			RecLock( 'PAB', .T. )
			PAB->PAB_FILIAL := xFilial( 'PAB' )
			PAB->PAB_ID     := cPrxId
			PAB->PAB_SEQ    := cSeq
			PAB->PAB_FILERR := (cTmp3)->PA9_FILIAL
			PAB->PAB_MATERR := (cTmp3)->PA9_MAT
			PAB->PAB_CODERR := '103'
			PAB->PAB_MENSAG := 'Nao atualizou tabela CSU  '
			PAB->PAB_COMPLE := cCmd
			MSUnlock()
			
		Else
			PA9->(DbSeek((cTmp3)->PA9_FILIAL+(cTmp3)->PA9_MAT))
//			PA9->( dbGoTo( (cTmp)->PA2RECNO )  )
			RecLock( 'PA9', .F. )
			PA9->PA9_LIDO := date()
			MSUnlock()
		EndIf
		
		(cTmp3)->( dbSkip() )
	End
	
	(cTmp3)->( dbCloseArea() )
	
	FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - Fim do While"+cEol )					
	
Else
	u_MsgConMon( 'Nao abriu conexão com o banco' )
	FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - Nao abriu conexão com o banco"+cEol )		
	
EndIf

u_MsgConMon( 'Job CSUJ003 - Empresa '  + cEmpresa + '/' + cFilant + ' - Finalizado ' + cTitulo,.F., .F. )


FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - Gravando FS_IDINT com "+cPrxId+cEol )		
If cPrxId > GetMV( 'FS_IDINT' )
	PutMv( 'FS_IDINT', cPrxId )
EndIf

FreeUsedCode()

dbSelectArea( 'PAA' )
PAA->( dbSetOrder( 1 ) )
PAA->( dbSeek( xFilial( 'PAA' )  + cPrxId) )
RecLock( 'PAA', .F. )
PAA->PAA_DTFIM  := Date()
PAA->PAA_HRFIM  := Time()
PAA->PAA_STATUS := IIf( lTeveErro, '2', '1' )
MSUnlock()

FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - Fim da rotina."+cEol )

oDBIntermed:Finish()		
Return NIL