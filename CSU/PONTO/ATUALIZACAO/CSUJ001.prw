#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'  

// Teste de Importacao


/*
Codificacao de Erros
001 Funcionario Nao Encontrado
002 Turno Nao Encontrado
003 Nao foi possivel atualizar a tabela CSU de marca็๕es
004 Funcionario Demitido
005 Relogio de Ponto nao cadastrado
006 Nao foi possivel criar arquivo TXT de relogio
*/


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ CSUJ001  บAutor  ณ Ernani Forastieri  บ Data ณ  28/02/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina de Integracao das marcacoes de ponto eletronico     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CSUJ001(aParams)  
Local lManual    := IIf( aParams == NIL, .T., aParams[1] )
Local cEmpresa   := IIf( lManual, cEmpAnt, aParams[2] )
Local cFil       := IIf( lManual, cFilAnt, aParams[3] )
Local cTitulo    := 'Importacao das Marcacoes' 
Local cQuery     := ''
Local cCmd       := ''
Local cConString := ''
Local lSR6Compar := .F.
Local cBanco     := ''
Local cServer    := ''
Local cAux       := ''
Local nErro      := 0
Local cFilBkp    := ''
Local cEmpBlp    := ''
Local aAreaSM0   := {}
Local aArea      := {}
Local oDBIntermed
Local cPrxId     := ''
Local cSeq       := ''
Local lTeveErro  := .F.
Local lContinua  := .T.
Local cArquivo   := ''

Local aLayOut    := {}
Local nHandle    := 0
Local nI         := 0
Local nCt        := 0
Local lRFA       := .F.                                                                                                               	

Local cPONMES    := ''
Local cPONMESDe  := ''
Local cPONMESAte := ''
Local dMaxDtLida := CToD('  /  /  ')
Local dMinDtLida := CToD('  /  /  ')
Local _cPaPonta  := ''
Local _cdiaPonta := ''

Private cPaswd   := '%tvt49@opi'  //GETMV( 'CS_PONSENH' )   
Private cUserid	 := 'Administrador' //GETMV( 'CS_PASUSER' )  
Private cMinMat  := 'ZZZZZZ'
Private cMaxMat  := '      '
Private dMinDat  := CToD('  /  /  ')
Private dMaxDat  := CToD('  /  /  ')

Private cTmp     := ''
Private cRelogio := ''
Private nHdl_    := FCreate( '\MARCACAO\log\marcacao-'+Dtos(Date())+'-'+StrTran(Time(),":","_")+'.log',1 )
Private cLogMarc := 'Inicio do log da Marcacao '
Private cEol     := Chr(13)+Chr(10)

//
// Prepara ambiente se for JOB
//

/*If !lManual
	RpcSetType( 3 )
//	RpcSetEnv( cEmpresa, cFil,,,'PON' )         
	RpcSetEnv( "05",cFil, cUserid, cPaswd, "PON", , , , , ,  )
EndIf              */
FWrite( nHdl_, cLogMarc+cEol )


If !MayIUseCode( 'CSUJ01A' + cEmpresa + cFil )
	FWrite( nHdl_, "Entrei no !MayIUseCode"+cEol )
	
	u_MsgConMon( 'Job CSUJ01A - Empresa/Filial ' + cEmpresa + cFil + ' - Ja Esta Em Andamento' ,, .F. ) //
	
	//MeAvisa( cPrxId, 'Job CSUJ001 - Empresa ' + cEmpresa + ' - Ja Esta Em Andamento')
	Return NIL
	
EndIf

//
// Inicializando
//
//Private nHdl_   := FCreate( '\marcacao\log\marcacao-'+Dtos(Date())+'-'+StrTran(Time(),":","_")+'.log',1 )
aArea    := GetArea()
cRelogio := SuperGetMV( 'FS_INTREL',, '99' )
cSeq     := Replicate( '0', TamSX3('PA5_SEQ')[1] )
lRFA     := SuperGetMV( 'FS_USARFA',, .F. )
dMinDat  := CToD('31/12/49')
dMaxDat  := CToD('  /  /  ' )
cPONMES     := GetMV( 'MV_PONMES' )
cPONMESDe   := SToD( SubStr( cPONMES,  1, 8 ) )
cPONMESAte  := SToD( SubStr( cPONMES, 10, 8 ) )

Private _cPerg    := PADR("PNM010",LEN(SX1->X1_GRUPO))

FWrite( nHdl_, "Sai do RpcSetEnv"+cEol )
/*
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
ณ Ajuste da data base para que na virada do periodo de apontamento, nao aconteca o problema de nao      ณ
ณ  apontameto do ultimo dia do periodo anterior                                                         ณ
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/

_cPaPonta   := GetMV( 'MV_PAPONTA' )
_cPaPonta   := SubStr( _cPaPonta,  1, 2 )

_cdiaPonta := DToS( dDataBase ) //AAAAMMDD

_cdiaPonta := SubStr( _cdiaPonta,  7, 2 )

If _cdiaPonta == _cPaPonta
	dDataBase := dDataBase - 1
EndIf

aAdd( aLayOut, { 'Cracha                ', 001, 008, 008, '(cTmp)->RA_CRACHA'                     }  )
aAdd( aLayOut, { 'Relogio               ', 009, 010, 002, 'cRelogio'                              }  )
aAdd( aLayOut, { 'Dia                   ', 011, 012, 002, 'StrZero( Day( (cTmp)->PA1_DATA   ),2)' }  )
aAdd( aLayOut, { 'Mes                   ', 013, 014, 002, 'StrZero( Month( (cTmp)->PA1_DATA ),2)' }  )
aAdd( aLayOut, { 'Dia                   ', 015, 018, 004, 'StrZero( Year( (cTmp)->PA1_DATA  ),4)' }  )
aAdd( aLayOut, { 'Hora                  ', 019, 020, 002, 'StrZero( Int( (cTmp)->PA1_HORA   ),2)' }  )
aAdd( aLayOut, { 'Minuto                ', 021, 022, 002, 'StrZero( ((cTmp)->PA1_HORA-Int((cTmp)->PA1_HORA))*100,2)' }  )

SRA->( dbSetOrder( 1 ) )
SPA->( dbSetOrder( 1 ) )
SP0->( dbSetOrder( 1 ) )
PA4->( dbSetOrder( 1 ) )
PA5->( dbSetOrder( 1 ) )

//
// Id de Importacao Exportacao
//

FWrite( nHdl_, "Obtendo Id de Importacao / Exportacao"+cEol )

cPrxId := u_PrxInd()

//
// Gravando LOG
//
FWrite( nHdl_, "Gravando log"+cEol )
RecLock( 'PA4', .T. )
PA4->PA4_FILIAL := xFilial( 'PA4' )
PA4->PA4_ID     := cPrxId
PA4->PA4_IMPEXP := 'I'
PA4->PA4_DTINI  := Date()
PA4->PA4_HRINI  := Time()
MSUnlock()

//MeAvisa( cPrxId, 'INICIOU TODA A IMPORTACAO ')

//
// Conexใo com a tabela externa do Microsiga que contem as marca็๕es do sistema Web da CSU e Grava็ใo do PA1
//
nTipoConex := SuperGetMV( 'FS_TPCNIN',, 1 )
FWrite( nHdl_, "Conexใo com a tabela externa do Microsiga que contem as marca็๕es do sistema Web da CSU e Grava็ใo do PA1"+cEol )

If nTipoConex == 1
	FWrite( nHdl_, "Tipo de Conexao igual a 1"+cEol )
	cConString := SuperGetMV( 'FS_STRCON',, 'CSUD2' )
	cQuery := "SELECT * FROM OPENQUERY( " + cConString  +", '"
	
Else
	FWrite( nHdl_, "Tipo de Conexao diferente de 1"+cEol )
	cBanco  := SuperGetMV( 'FS_INTBAN',, 'ORACLE/CSUD2' )
	cServer := SuperGetMV( 'FS_INTSER',, '10.10.1.183'  )
	cQuery  := ""
EndIf

cQuery += "SELECT COD_FILIAL PA1_FILIAL, COD_MATRICULA PA1_MAT, to_char( DAT_MARCACAO, 'YYYYMMDD' ) PA1_DATA, HRR_MARCACAO PA1_HORA, COD_REGRA_TURNO PA1_TURNO, "
cQuery += " DSC_TIPO_MARCACAO PA1_TPMARC "
cQuery += "  FROM INT_MARCACAO "
cQuery += " WHERE FLG_LIDO = 0 "
cQuery += "   AND COD_FILIAL = '" + cFilAnt + "' "

If nTipoConex == 1
	cQuery += "' ) "
	
	cTmp       := GetNextAlias()
	FWrite( nHdl_, "Vai executar a query - "+cQuery+cEol )
	dbUseArea( .T., 'TOPCONN', TcGenQry( ,, cQuery ), cTmp, .F., .T. )
	FWrite( nHdl_, "Executou a query"+cEol )
	
Else
	
	oDBIntermed := ClsDBAccess():New(cBanco,cServer)
	
	FWrite( nHdl_, "Vai tentar abrir uma conexao "+cEol )
	If !oDBIntermed:AbreConexao()
		
		cAux := 'Sem conexao com banco CSU'
		FWrite( nHdl_, "Sem conexao com banco CSU"+cEol )
		
		lTeveErro  := .T.
		
		//
		// Existe uma Nao conformidade no Protheus que se o TCLINK nใo conectar a Thread atual
		// ้ perdida, por isso nใo ้ possivel gravar as tabelas de log
		//
		u_MsgConMon( cAux )
		
		//MeAvisa( cPrxId, cAux )
		
		lContinua  := .F.
		
		If !lManual
			RpcClearEnv()
			
		Else
			Final( cAux )
			
		EndIf
		
		Return NIL
		
	EndIf
	
	FWrite( nHdl_, "Conseguiu conexao com banco CSU"+cEol )
	
	cTmp := oDBIntermed:NewAlias( cQuery )
	
EndIf


If lContinua
	//
	// Gravacao da PA1
	//
	FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - Inicio da gravacao da PA1"+cEol )
	While !(cTmp)->( EOF() )
		
		FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - Incluindo registro na PA1 - Filial: "+(cTmp)->PA1_FILIAL+"/"+(cTmp)->PA1_MAT+cEol )
		Begin Transaction
		RecLock( 'PA1', .T. )
		PA1->PA1_FILIAL := (cTmp)->PA1_FILIAL
		PA1->PA1_MAT    := (cTmp)->PA1_MAT
		PA1->PA1_DATA   := SToD( (cTmp)->PA1_DATA )
		PA1->PA1_HORA   := HDecToHor( (cTmp)->PA1_HORA )
		PA1->PA1_TURNO  := (cTmp)->PA1_TURNO
		PA1->PA1_TPMARC := (cTmp)->PA1_TPMARC
		MSUnlock()
		
		If SRA->( dbSeek( (cTmp)->( PA1_FILIAL + PADR( PA1_MAT, 6 ) ) ) )
			
			If Empty( SRA->RA_DEMISSA )
				
				FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - Funcionario NAO Demitido"+cEol )
				If !SPA->( dbSeek( xFilial( 'SPA' ) + (cTmp)->PA1_TURNO ) )
					cAux := 'Regra nao encontrado - ' + (cTmp)->PA1_TURNO + ' - ' + (cTmp)->( PA1_FILIAL + ' ' + PA1_MAT )
					
					FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+cAux+cEol )
					lTeveErro  := .T.
					
					//
					// Grava LOG
					//
					cSeq := Soma1( cSeq )
					RecLock( 'PA5', .T. )
					PA5->PA5_FILIAL := xFilial( 'PA5' )
					PA5->PA5_ID     := cPrxId
					PA5->PA5_SEQ    := cSeq
					PA5->PA5_FILERR := (cTmp)->PA1_FILIAL
					PA5->PA5_MATERR := (cTmp)->PA1_MAT
					PA5->PA5_CODERR := '002'
					PA5->PA5_MENSAG := cAux
					MSUnlock()
					
					u_MsgConMon( cAux )
					
					//MeAvisa( cPrxId, cAux )
					
					RecLock( 'PA1', .F. )
					PA1->PA1_ERRO   := Date()
					PA1->PA1_LOG    := '002 ' + cAux
					PA1->PA1_LIDO   := Date()
					MSUnlock()
					
				EndIf
				
			Else
				cAux := 'Funcionario demitido - ' + (cTmp)->( PA1_FILIAL + ' ' + PA1_MAT )
				
				FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - Funcionario Demitido"+cEol )
				lTeveErro  := .T.
				
				//
				// Grava LOG
				//
				cSeq := Soma1( cSeq )
				RecLock( 'PA5', .T. )
				PA5->PA5_FILIAL := xFilial( 'PA5' )
				PA5->PA5_ID     := cPrxId
				PA5->PA5_SEQ    := cSeq
				PA5->PA5_FILERR := (cTmp)->PA1_FILIAL
				PA5->PA5_MATERR := (cTmp)->PA1_MAT
				PA5->PA5_CODERR := '004'
				PA5->PA5_MENSAG := cAux
				MSUnlock()
				
				u_MsgConMon( cAux )
				
				//MeAvisa( cPrxId, cAux )
				
				RecLock( 'PA1', .F. )
				PA1->PA1_ERRO   := Date()
				PA1->PA1_LOG    := '004 ' + cAux
				PA1->PA1_LIDO   := Date()
				MSUnlock()
				
			EndIf
			
		Else
			cAux := 'Funcionario nao encontrado - ' + (cTmp)->( PA1_FILIAL + ' ' + PA1_MAT )
			
			FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - "+cAux+cEol )
			lTeveErro  := .T.
			
			//
			// Grava LOG
			//
			cSeq := Soma1( cSeq )
			RecLock( 'PA5', .T. )
			PA5->PA5_FILIAL := xFilial( 'PA5' )
			PA5->PA5_ID     := cPrxId
			PA5->PA5_SEQ    := cSeq
			PA5->PA5_FILERR := (cTmp)->PA1_FILIAL
			PA5->PA5_MATERR := (cTmp)->PA1_MAT
			PA5->PA5_CODERR := '001'
			PA5->PA5_MENSAG := cAux
			MSUnlock()
			
			u_MsgConMon( cAux )
			
			//MeAvisa( cPrxId, cAux )
			
			RecLock( 'PA1', .F. )
			PA1->PA1_ERRO   := Date()
			PA1->PA1_LOG    := '001 ' + cAux
			PA1->PA1_LIDO   := Date()
			MSUnlock()
			
		EndIf
		
		//
		// Atualizacao da tabela CSU
		//
		FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - Inicio da tentativa de atualizacao da tabela CSU:"+cEol )
		If nTipoConex == 1
			cCmd := "UPDATE OPENQUERY("
			cCmd := cConString + ", 'SELECT * FROM INT_MARCACAO "
			cCmd += " WHERE COD_FILIAL    = '" + (cTmp)->PA1_FILIAL   + "' "
			cCmd += "   AND COD_MATRICULA = '" + (cTmp)->PA1_MAT + "' "
			cCmd += "   AND DAT_MARCACAO  = " + Str( (cTmp)->PA1_DATA, 8 ) + " "
			cCmd += "   AND HRR_MARCACAO  = " + Str( (cTmp)->PA1_HORA, 5, 2 ) + " "
			cCmd += "   ') SET FLG_LIDO = 1 "
			
			nErro := TcSqlExec( cCmd )
			
			FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - Verificacao de erro: "+IIF( nErro < 0, TcSqlError(),"Sem Erro!" )+cEol )
		Else
			cCmd := "UPDATE " + cConString + "INT_MARCACAO SET FLG_LIDO = 1 "
			cCmd += " WHERE COD_FILIAL    = '" + AllTrim( (cTmp)->PA1_FILIAL )  + "' "
			cCmd += "   AND COD_MATRICULA = '" + AllTrim( (cTmp)->PA1_MAT ) + "' "
			cCmd += "   AND DAT_MARCACAO  = TO_DATE( '" + Alltrim( (cTmp)->PA1_DATA ) + "', 'YYYYMMDD' ) "
			//cCmd += "   AND HRR_MARCACAO  = " + Str( (cTmp)->PA1_HORA, 5, 2 ) + " "
			cCmd += "   AND DSC_TIPO_MARCACAO = '" + AllTrim( (cTmp)->PA1_TPMARC ) + "' "
			
			nErro := oDBIntermed:ExecQuery( cCmd )
			
			FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - cConString: "+cConString+" - Query: "+cCmd+""+cEol )
			FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - Verificacao de erro: "+IIF( nErro < 0, u_ErSQLExec( nErro ),"Sem Erro!" )+cEol )
			
		EndIf
		
		If nErro < 0
			FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - Verificacao de erro: HOUVE Erro"+cEol )
			cAux := 'Nao foi possivel atualizar a tabela CSU de marca็๕es - ' + ;
			(cTmp)->( PA1_FILIAL + ' ' + PA1_MAT ) + ' / ' + ;
			AllTrim( Str( nErro ) ) + ' ' + u_ErSQLExec( nErro )
			
			lTeveErro  := .T.
			
			//
			// Grava LOG
			//
			cSeq := Soma1( cSeq )
			RecLock( 'PA5', .T. )
			PA5->PA5_FILIAL := xFilial( 'PA5' )
			PA5->PA5_ID     := cPrxId
			PA5->PA5_SEQ    := cSeq
			PA5->PA5_FILERR := (cTmp)->PA1_FILIAL
			PA5->PA5_MATERR := (cTmp)->PA1_MAT
			PA5->PA5_CODERR := '003'
			PA5->PA5_MENSAG := cAux
			PA5->PA5_COMPLE := cCmd
			MSUnlock()
			
			u_MsgConMon( cAux )
			
			//MeAvisa( cPrxId, cAux )
			
			RecLock( 'PA1', .F. )
			PA1->PA1_ERRO   := Date()
			PA1->PA1_LOG    := '003 ' + cAux
			PA1->PA1_LIDO   := Date()
			MSUnlock()
		Else
			
			FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - Verificacao de erro: NAO Houve Erro"+cEol )
			
		EndIf
		
		End Transaction
		
		(cTmp)->( dbSkip() )
		
	End // EOF
	
	
	If nTipoConex == 1
		(cTmp)->( dbCloseArea() )
	Else
		oDBIntermed:Finish()                             
	EndIf
	
	FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - Verifica se o relogio de ponto existe => "+cRelogio+cEol )
	If !SP0->( dbSeek( xFilial( 'SP0' ) + cRelogio ) )
		FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - Relogio de ponto nao existe => "+cRelogio+cEol )
		cAux := 'Relogio de Ponto nao cadastrado '
		
		lTeveErro  := .T.
		
		//
		// Grava LOG
		//
		cSeq := Soma1( cSeq )
		RecLock( 'PA5', .T. )
		PA5->PA5_FILIAL := xFilial( 'PA5' )
		PA5->PA5_ID     := cPrxId
		PA5->PA5_SEQ    := cSeq
		PA5->PA5_FILERR := (cTmp)->PA1_FILIAL
		PA5->PA5_MATERR := (cTmp)->PA1_MAT
		PA5->PA5_CODERR := '005'
		PA5->PA5_MENSAG := cAux
		MSUnlock()
		
		u_MsgConMon( cAux )
		
		//MeAvisa( cPrxId, cAux )
		
	Else
		
		FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - Relogio de ponto existe => "+cRelogio+cEol )
		
	EndIF
	
	u_MsgConMon( 'Job CSUJ01A - Empresa '  + cEmpresa + '/' + cFilant + ' - Iniciado   '  + cTitulo,.F., .F. )
	
	//MeAvisa( cPrxId, cAux )
	
	//
	// Verifica o periodo em aberto a ser apontado
	//
	cQuery  := ""
	cQuery  += "SELECT MIN( PA1_DATA ) DATAMENOR, MAX( PA1_DATA ) DATAMAIOR "
	cQuery  += "  FROM  " + RetSQLName( 'PA1' ) + " PA1 "
	cQuery  += " INNER JOIN " + RetSQLName( 'SRA' ) + " SRA "
	cQuery  += "    ON RA_FILIAL = PA1_FILIAL "
	cQuery  += "   AND RA_MAT    = PA1_MAT "
	cQuery  += "   AND SRA.D_E_L_E_T_ = ' ' "
	cQuery  += " WHERE PA1_FILIAL = '" + xFilial( 'PA1' ) + "'"
	cQuery  += "   AND PA1_LIDO   = ' ' "
	cQuery  += "   AND PA1.D_E_L_E_T_ = ' ' "
	
	cTmp    := GetNextAlias()
	FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - Verifica o periodo em aberto a ser apontado => "+cQuery+cEol )
	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cTmp, .F., .T. )
	FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - Verificacao executada."+cEol )
	
	dMaxDtLida := cPONMESDe
	dMinDtLida := cPONMESAte
	
	If !(cTmp)->( EOF() )
		dMinDtLida := SToD( (cTmp)->DATAMENOR )
		dMaxDtLida := SToD( (cTmp)->DATAMAIOR )
		FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - Existe periodo: "+(cTmp)->DATAMENOR+' / '+(cTmp)->DATAMAIOR+cEol )
	Else
		FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - NAO Existe periodo! "+cEol )
	EndIf
	
	(cTmp)->( dbCloseArea() )
	
	//
	// Este tratamento eh feito pois na rotina PONM010 o periodo a ser informado e a data  base nao podem ser
	// maiores que o parametro MV_PONMES
	//
	FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - MV_PONMES: o periodo a ser informado e a data  base nao podem ser maiores que o parametro MV_PONMES"+cEol )
	If  dMinDtLida <= cPONMESAte
		If dDataBase > cPONMESAte
			FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - A data base teve de ser ajustada de ["+Dtoc(dDataBase)+"] para ["+dtoc(cPONMESAte)+"]"+cEol )
			dDataBase := cPONMESAte
		EndIf
	EndIf
	
	//
	// Pega o movimetno a ser lido
	//
	cQuery  := ""
	cQuery  += "SELECT 	PA1_FILIAL, PA1_MAT, PA1_DATA, PA1_HORA, PA1_TURNO, PA1_TPMARC, PA1.R_E_C_N_O_ PA1RECNO "
	cQuery  += "      , RA_CC, RA_CODFUNC, RA_CRACHA "
	cQuery  += "  FROM  " + RetSQLName( 'PA1' ) + " PA1 "
	cQuery  += " INNER JOIN " + RetSQLName( 'SRA' ) + " SRA "
	cQuery  += "    ON RA_FILIAL = PA1_FILIAL "
	cQuery  += "   AND RA_MAT    = PA1_MAT "
	cQuery  += "   AND SRA.D_E_L_E_T_ = ' ' "
	cQuery  += " WHERE PA1_FILIAL = '" + xFilial( 'PA1' ) + "'"
	cQuery  += "   AND PA1_LIDO   = ' ' "
	cQuery  += "   AND PA1_DATA   <= '" + DToS( dDataBase ) +  "' "
	cQuery  += "   AND PA1.D_E_L_E_T_ = ' ' "
	cQuery  += " ORDER BY PA1_FILIAL, PA1_MAT "
	
	cTmp    := GetNextAlias()
	FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - Pega o movimetno a ser lido. Inicio de execucao: "+cQuery+cEol )
	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cTmp, .F., .T. )
	FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - Pega o movimetno a ser lido. Fim de execucao: "+cEol )
	TcSetField( cTmp, "PA1_DATA", "D", 8, 0)
	
	If !lRFA
		
		FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - Verificacao do parametro FS_USARFA: .f."+cEol )
		dbSelectArea( cTmp )
		cArquivo := AllTrim( SP0->P0_ARQUIVO )
		
		nHandle := FCreate( cArquivo )
		
		If nHandle < 0
			cAux := 'Nao foi possivel criar arquivo TXT de relogio '
			
			FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - "+cAux+cEol )
			lTeveErro  := .T.
			
			//
			// Grava LOG
			//
			cSeq := Soma1( cSeq )
			RecLock( 'PA5', .T. )
			PA5->PA5_FILIAL := xFilial( 'PA5' )
			PA5->PA5_ID     := cPrxId
			PA5->PA5_SEQ    := cSeq
			PA5->PA5_FILERR := (cTmp)->PA1_FILIAL
			PA5->PA5_MATERR := (cTmp)->PA1_MAT
			PA5->PA5_CODERR := '006'
			PA5->PA5_MENSAG := cAux
			MSUnlock()
			
			u_MsgConMon( cAux )
			
			//MeAvisa( cPrxId, cAux )
			
			lContinua := .F.
		Endif
	Else
		FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - Verificacao do parametro FS_USARFA: .t."+cEol )
		
	EndIf
	
	If lContinua
		//lGravouRFA := .T.
		FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - Tentativa de entrada no While:"+cEol )
		While !(cTmp)->( EOF() )
			
			If (cTmp)->PA1_MAT < cMinMat
				cMinMat := (cTmp)->PA1_MAT
			EndIf
			
			If (cTmp)->PA1_MAT > cMaxMat
				cMaxMat := (cTmp)->PA1_MAT
			EndIf
			
			If (cTmp)->PA1_DATA < dMinDat
				dMinDat := (cTmp)->PA1_DATA
			EndIf
			
			If (cTmp)->PA1_DATA > dMaxDat
				dMaxDat := (cTmp)->PA1_DATA
			EndIf
			
			
			Begin Transaction
			
			If lRFA
				RecLock( 'RFA', .T. )
				RFA->RFA_FILIAL := (cTmp)->PA1_FILIAL
				RFA->RFA_ORIG   := (cTmp)->PA1_FILIAL
				RFA->RFA_CRACHA := (cTmp)->RA_CRACHA
				RFA->RFA_DATA   := (cTmp)->PA1_DATA
				RFA->RFA_HORA   := (cTmp)->PA1_HORA
				RFA->RFA_CC     := (cTmp)->RA_CC
				RFA->RFA_RELOGI := cRelogio
				RFA->RFA_FUNCAO := SP0->P0_FUNCFOR
				RFA->RFA_GIRO   := SP0->P0_GIROFOR
				RFA->RFA_FLAG   := '0'
				MsUnlock()
				
			Else
				cAux := ''
				For nI := 1 To Len( aLayOut )
					cAux += PadR( &(AllTrim(aLayOut[nI][5])), aLayOut[nI][4] )
				Next
				
				FWrite( nHandle, cAux + Chr( 13 ) + Chr( 10 ) )
			EndIf
			
			//PA1->( dbGoTo( (cTmp)->PA1RECNO ) )
			//RecLock( 'PA1', .F. )
			//PA1->PA1_LIDO := Date()
			//MSUnlock()
			
			//lGravouRFA := .T.
			End Transaction
			
			(cTmp)->( dbSkip() )
		End // EOF
		
		FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - Fim do While:"+cEol )
		//(cTmp)->( dbCloseArea() )
		
		FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - Inicio da execucao da funcao AjustaParam"+cEol )
		AjustaParam( _cPerg, cRelogio )
		FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - Fim da execucao da funcao AjustaParam"+cEol )
		
		//MeAvisa( cPrxId, 'Iniciou importacao filial ' + cFilant )
		
		If lRFA
			FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - Inicio da execucao da funcao Ponm010"+cEol )
			U_Ponm010(;
			.T.       	,;	// 01 -> Se o "Start" foi via WorkFlow
			.T.      	,;	// 02 -> Se deve considerar as configuracoes dos parametros do usuario
			.F.    		,;	// 03 -> Se deve limitar a Data Final de Apontamento a Data Base
			cFilAnt    	,; 	// 04 -> Filial a Ser Processada
			.T.          ;  // 05 -> Processo por Filial
			)
			FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - Fim da execucao da funcao Ponm010"+cEol )
			
		Else
			
			If nHandle >= 0
				FClose( nHandle )
			EndIf
			
			FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - Inicio da execucao da funcao Ponm010"+cEol )
			//FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - Inicio da execucao da funcao PonScheduler"+cEol )
			/*
			Ponm010(;
			.T.       	,;	// 01 -> Se o "Start" foi via WorkFlow
			.T.      	,;	// 02 -> Se deve considerar as configuracoes dos parametros do usuario
			.F.    		,;	// 03 -> Se deve limitar a Data Final de Apontamento a Data Base
			cFilAnt    	,; 	// 04 -> Filial a Ser Processada
			.T.          ;  // 05 -> Processo por Filial
			)
			*/
			//			u_CSPonm010(;
			Ponm010(;
			.T.       	,;	// 01 -> Se o "Start" foi via WorkFlow
			.T.      	,;	// 02 -> Se deve considerar as configuracoes dos parametros do usuario
			.T.    		,;	// 03 -> Se deve limitar a Data Final de Apontamento a Data Base
			cFilAnt    	,; 	// 04 -> Filial a Ser Processada
			.T.         ,;  // 05 -> Processo por Filial
			.F.         ,;  // 06 -> Apontar quando nao Leu as Marcacoes para a Filial
			.F.          ;  // 07 -> Se deve Forcar o Reapontamento
			)
			
			
			/*
			If !lManual
			FWrite( nHdl_, "Fechando o Ambiente "+cEol )
			RpcClearEnv()
			EndIf
			u_PonScheduler(	"05",;	//01 -> Codigo da Empresa no SIGAMAT
			cFilAnt,;	//02 -> Codigo da Filial no SIGAMAT
			.T.,;	//03 -> Utilizar os Parametros do SX1 para Leitura / Apontamento
			.T.,;	//04 -> Limitar a Data Final do Apontamento aa DataBase do Sistema
			.T.,;	//05 -> Efetuar o Apontamento Por Filial
			.F.,; 	//06 -> Efetua Apontamento para Relogios nao Lidos
			.F.,;	//07 -> Forcar o Reapontamento das Marcacoes
			.T. ;   //08 -> Processa apenas a filial passada como parโmetro)
			)
			
			If !lManual
			FWrite( nHdl_, "Recriando o Ambiente "+cEol )
			RpcSetType( 3 )
			RpcSetEnv( cEmpresa, cFil,,,'FOL' )
			EndIf
			*/ 				
			FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - Fim da execucao da funcao Ponm010"+cEol )
			//FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - Fim da execucao da funcao PonScheduler"+cEol )
			If nHandle >= 0
				nCt := 0
				cArqRen := SubStr( cArquivo, 1, At( '.' , cArquivo ) - 1 ) + '_' + DToS( Date() ) + StrTran( Time() , ':', '' ) + '.TXT'
				FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - Inicio de execucao do While para Renomeacao de arquivos"+cEol )
				While !(FRename( cArquivo, cArqRen ) == 0 ) .AND. nCt < 3
					cArqRen := SubStr( cArquivo, 1, At( '.' , cArquivo ) - 1 ) + '_' + DToS( Date() ) + StrTran( Time() , ':', '' ) + '.TXT'
					//MeAvisa( cPrxId, 'problemas no rename do txt' )
					nCt++
				End
				FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - Fim de execucao do While para Renomeacao de arquivos"+cEol )
			EndIf
		EndIf
		
		(cTmp)->( dbGoTop() )
		
		FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - Inicio de execucao do While para alteracao da PA1 tendo como base o cTMP"+cEol )
		While !(cTmp)->( EOF() )
			Begin Transaction
			PA1->( MsGoTo( (cTmp)->PA1RECNO ) )
			RecLock( 'PA1', .F. )
			PA1->PA1_LIDO := Date()
			MSUnlock()
			End Transaction
			
			(cTmp)->( dbSkip() )
		End // EOF
		FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - Fim de execucao do While para alteracao da PA1 tendo como base o cTMP"+cEol )
		
		(cTmp)->( dbCloseArea() )
		
	Else
		FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - O processo nao prosseguiu."+cEol )
	EndIf
	
	FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - Inicio de execucao da rotina MsgConMon."+cEol )
	//MeAvisa( cPrxId, 'Terminou importacao filial ' + cFilant )
	
	u_MsgConMon( 'Job CSUJ01A - Empresa '  + cEmpresa + '/' + cFilant + ' - Finalizado ' + cTitulo,.F., .F. )
	FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - Fim de execucao da rotina MsgConMon."+cEol )
	
EndIf

FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - Sera alterado o parametro FS_IDINT com "+cPrxId+cEol )
If cPrxId > GetMV( 'FS_IDINT' )
	PutMv( 'FS_IDINT', cPrxId )
EndIf

//MeAvisa( cPrxId, 'FINALIZOU TODA A IMPORTACAO' )

FreeUsedCode()

FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - Geracao da PA4 "+cEol )
dbSelectArea( 'PA4' )
PA4->( dbSetOrder( 1 ) )
PA4->( dbSeek( xFilial( 'PA4' )  + cPrxId) )
RecLock( 'PA4', .F. )
PA4->PA4_DTFIM  := Date()
PA4->PA4_HRFIM  := Time()
PA4->PA4_STATUS := IIf( lTeveErro, '2', '1' )
MSUnlock()

FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - Fim da Geracao da PA4 "+cEol )
If lTeveErro
	Notifica( cPrxId )
EndIf

RestArea( aArea )
  /*
If !lManual
	RpcClearEnv()
EndIf   */  
FWrite( nHdl_, "Linha "+AllTrim(Str(ProcLine()))+" - Fim da rotina "+cEol )

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ Notifica บAutor  ณ Ernani Forastieri  บ Data ณ  28/02/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Notifica erro por email                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Notifica( cPrxId )
Local cMsg    := ''
Local cEmail  := SuperGetMV('FS_EMERINT' ,,'')
Local cLogo   := SuperGetMV('FS_LGERINT' ,,'')

cMsg := MemoRead( SuperGetMV( 'FS_MDERRIN',,'\workflow\modelo\intponto.htm' ) )
cMsg := StrTran( cMsg, '!INTID!'     , cPrxId )
cMsg := StrTran( cMsg, '!OPER!'      , 'IMPORTAวรO')
cMsg := StrTran( cMsg, '!LOGOTIPO!'  , cLogo )
cMsg := StrTran( cMsg, '!DATA!'      , DToC( Date() ) )
cMsg := StrTran( cMsg, '!HORA!'      , Time()  )
cMsg := StrTran( cMsg, CRLF          , '' )

u_EnvMail( , cEmail,, 'INTERFACE PONTO ELETRONICO - ID ' +  cPrxId,, cMsg )

Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ CSUJ001  บAutor  ณ Ernani Forastieri  บ Data ณ  28/02/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Ajusta os parametros da rotina de leitura do ponto         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AjustaParam( cPerg, cRelogio )
Local aArea  := GetArea()
Local nI     := 0
Local aPergs := {}

//PNM010
dbSelectArea( 'SX1' )
SX1->( dbSetOrder( 1 ) )

// Filial De
aAdd( aPergs, { '01', cFilAnt, 0 } )
// Filial Ate
aAdd( aPergs, { '02', cFilAnt, 0 } )
// Centro de Custo De
aAdd( aPergs, { '03', '', 0      } )
// Centro de Custo Ate
aAdd( aPergs, { '04', Replicate( 'Z', Len( SRA->RA_CC ) ), 0 } )
// Turno De
aAdd( aPergs, { '05', '', 0      } )
// Turno Ate
aAdd( aPergs, { '06', Replicate( 'Z', Len(SRA->RA_TNOTRAB) ), 0  } )

// Matricula De
//aAdd( aPergs, { '07', '', 0      } )
aAdd( aPergs, { '07', cMinMat, 0      } )
// Matricula Ate
//aAdd( aPergs, { '08', Replicate( 'Z', Len(SRA->RA_MAT) ), 0      } )
aAdd( aPergs, { '08', cMaxMat, 0      } )


// Nome De
aAdd( aPergs, { '09', '', 0      } )
// Nome Ate
aAdd( aPergs, { '10', Replicate( 'Z', Len(SRA->RA_NOME) ), 0      } )
// Relogio De
//aAdd( aPergs, { '11', ''      } )
aAdd( aPergs, { '11', cRelogio, 0  } )
// Relogio Ate
//aAdd( aPergs, { '12', Replicate( 'Z', Len(SP0->P0_RELOGIO) )      } )
aAdd( aPergs, { '12', cRelogio, 0  } )
//Periodo De
//aAdd( aPergs, { '13', DToC( SToD( Left( SuperGetMV( 'MV_PONMES' ), 8 ) ) ), 0 } )
//aAdd( aPergs, { '13', DToC(dDataBase - 3), 0 } ) // a ser considerado
aAdd( aPergs, { '13', DToC(dMinDat), 0 } ) // a ser considerado
//Periodo Ate
//aAdd( aPergs, { '14', DToC( SToD( SubStr( SuperGetMV( 'MV_PONMES'), 10, 8 ) ) ), 0 } )
//aAdd( aPergs, { '14', DToC(dDataBase + 2), 0 } ) // a ser considerado
aAdd( aPergs, { '14', DToC(dMaxDat), 0 } ) // a ser considerado

// Regra De
aAdd( aPergs, { '15', '', 0      } )
// Regra Ate
// Foi criada a Regra ZZ para quem nใo deve ser considerado.
aAdd( aPergs, { '16', Replicate('9', Len( SRA->RA_REGRA) ), 0      } )
// Tipo de Processamento 1=Leitura 2=Apontamento 3=Ambos
aAdd( aPergs, { '17', '3', 3     } )
// Leitura/Apontamento 1=Marcacoes 2=Refeicoes 3=Acesso 4=Marcacoes e Refeicoes 5=Todos
aAdd( aPergs, { '18', '4', 4     } )
// Reapontar 1= Marcacoes 2=Refeicoes 3=Ambos 4=Nenhum
aAdd( aPergs, { '19', '4', 4     } )
// Ler a Partir  1=Cad.Funcionario 2=Cad.Relogios
aAdd( aPergs, { '20', '2', 2     } )
// Categoria
aAdd( aPergs, { '21', 'ACDEGHMPST', 0  } )
//Situacoes a gerar
aAdd( aPergs, { '22', ' ADFT', 0  } )

For nI := 1 To Len( aPergs )
	If SX1->( dbSeek( cPerg + aPergs[nI][1] ) )
		RecLock( 'SX1', .F. )
		SX1->X1_CNT01 := aPergs[nI][2]
		If aPergs[nI][3] > 0
			SX1->X1_PRESEL := aPergs[nI][3]
		EndIf
		MsUnlock()
	EndIf
Next

RestArea(aArea)
Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ HDecToHorบAutor  ณ Ernani Forastieri  บ Data ณ  28/02/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Converte Hora Decimal para hora/minuto com ponto decimal   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function HDecToHor( nHorDec )
Local nTotMin  := nHorDec * 60
Local nHoras   := Int( nTotMin / 60 )
Local nTamHor  := Max( Len( LTrim( Str( nHoras ) ) ), 2 )
Return Val( StrZero( nHoras, nTamHor ) + '.' + StrZero( nTotMin % 60, 2 ) )

//// Temporario
Static Function MeAvisa( cPrxId, cMsg )
u_EnvMail( , 'alexandre.souza@csu.com.br',, ;
'INT. P. ELETRONICO - ID ' +  cPrxId + ' - ',,;
cMsg  + CRLF + CRLF + DToC( Date() ) + ' / ' + Time() )
Return NIL

/////////////////////////////////////////////////////////////////////////////
