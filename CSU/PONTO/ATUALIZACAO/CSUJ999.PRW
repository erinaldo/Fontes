#INCLUDE "PROTHEUS.CH"
#INCLUDE 'TBICONN.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ CSUJ999  บAutor  ณ Ernani Forastieri  บ Data ณ  28/02/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotinad Genericas                                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณMsgConMon บAutor  ณ Ernani Forastieri  บ Data ณ  16/10/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para gerar mensagem no console e no monitor do      บฑฑ
ฑฑบ          ณ sistema                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MsgConMon( cMsg, lFrame, lEmail )
Local nTamUtil := 75
Local nTamMens := 0
Local cStamp   := ''
Local nLinhas  := 0
Local nZ       := 0
Local cRotina  := ''
Local cMsgOri  := ''

cMsg     := IIf( cMsg   == NIL,  '', cMsg )
lFrame   := IIf( lFrame == NIL, .T., lFrame )
lEmail   := IIf( lEmail == NIL, .T., lEmail )
nTamMens := Len( cMsg )
cMsgOri  := cMsg

nLinhas  := Int( nTamMens / 75 ) + IIf( Mod( nTamMens, 75 ) == 0, 0, 1 )
cRotina  := ProcName( 1 )
cRotina  := IIf( SubStr( cRotina, 1, 2 ) $ 'u_/U_', SubStr( cRotina, 3 ), cRotina )
cStamp   := '[' + cRotina + ' ' + SubStr( DtoC( Date() ), 1, 5 ) + ' ' + SubStr( Time(), 1, 5 ) + ']'

If lFrame
	//ConOut( PadC( ' ' + cStamp + ' ', nTamBarr, '-' ) )
	ConOut( ' ' )
	AutoGrLog( ' ' )
	ConOut( '+-' + PadC( ' ' + cStamp + ' ', nTamUtil, '-' )  + '-+')
	AutoGrLog( '+-' + PadC( ' ' + cStamp + ' ', nTamUtil, '-' )  + '-+')
	
	If nTamMens <= nTamUtil
		ConOut( '| ' + PadR( cMsg, nTamUtil ) + ' |' )
		AutoGrLog( '| ' + PadR( cMsg, nTamUtil ) + ' |' )
	Else
		For nZ := 1 to nLinhas
			ConOut( '| ' + SubStr( PadR( cMsg, nTamUtil ), 1, nTamUtil ) + ' |' )
			AutoGrLog( '| ' + SubStr( PadR( cMsg, nTamUtil ), 1, nTamUtil ) + ' |' )
			cMsg := LTrim( SubStr( cMsg, nTamUtil + 1 ) )
			
		Next
	EndIf
	//ConOut( PadC( '', nTamBarr, '-' ) )
	ConOut( '+-' + PadC( '', nTamUtil, '-' )  + '-+')
	AutoGrLog( '+-' + PadC( '', nTamUtil, '-' )  + '-+')
	
Else
	ConOut( '* ' + cStamp + ' ' + cMsg )
	AutoGrLog( '* ' + cStamp + ' ' + cMsg )
	
EndIf

PtInternal( 1, cMsg )

Return NIL



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบClasse    ณClsDBAccess บAutorณRodrigo Antonio     บ Data ณ  11/02/08   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออุออออออออัอออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบLocacao   ณ Fab.Tradicional  ณContato ณrodrigo.antonio@microsiga.com.brบฑฑ
ฑฑฬออออออออออุออออออออออออออออออฯออออออออฯออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDescricao ณ Classe de layer para acesso a banco de dados diferentes    บฑฑ
ฑฑบ          ณao do Protheus                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Nao se aplica                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Nao se aplica.                                             บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                      	  บฑฑ
ฑฑบ          ณ        ณ      ณ                                            บฑฑ
ฑฑศออออออออออฯออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Class ClsDBAccess
Data cBanco       
Data cServer
Data aAliasAberta 
Data nHandle
Data nHandleOld
Method New() Constructor 
Method AbreConexao()
Method FechaConexao()
Method Finish()
Method NewAlias(cAlias)
Method ExecQuery(cQuery)
EndClass


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณConstrutor da Classe, aqui ainda nao abrimos ณ
//ณa conexao propriamente .                     ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Method New(cPBanco,cPServer) Class ClsDBAccess
::aAliasAberta := {}
::cBanco := cPBanco
::cServer := cPServer
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSalva a conexao atual.                      ณ
//ณVale lembrar que a AdvConnection retorna Nilณ
//ณcaso nao tenha nenhuma conexao.             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
::nHandleOld := AdvConnection()
::nHandle    := -1
Return Self



//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณE' DE INDISPENSAVEL IMPORTANCIA CHAMAR O METODO Finishณ
//ณDESSA CLASSE,POIS AS CONEXOES DEVEM SER FECHADAS      ณ
//ณE A Tabelas abertas fechadas tambem.                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Method Finish() Class ClsDBAccess
Local nX
// Fecha as tabelas/query abertas
For nX := 1 to Len(::aAliasAberta)
	If Select(::aAliasAberta[nX]) >0
		DbSelectArea(::aAliasAberta[nX])
		DBCloseArea()
	Endif
Next nX
::FechaConexao()
Return


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMetodo:AbreConexao()                      ณ
//ณUsado para abrir a conexao.               ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Method AbreConexao()Class ClsDBAccess
If ::nHandle == -1
	::nHandle := TcLink(Alltrim(::cBanco),Alltrim(::cServer))
Endif
If ::nHandleOld != Nil
	TCSETCONN(::nHandleOld)
Endif
Return !(::nHandle < 0)




//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMetodo: FechaConexao        ณ
//ณUsado para fechar a conexao.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Method FechaConexao() Class ClsDBAccess
Local lRet := .F.
If ::nHandle >= 0
	lRet:= TCUNLINK(::nHandle)
	::nHandle := -1
Endif
If ::nHandleOld != Nil
	TCSETCONN(::nHandleOld)
Endif
Return lRet



//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMetodo NewAlias                                           ณ
//ณ                                                          ณ
//ณCria uma Alias de Trabalho temporaria baseado em uma Queryณ
//ณna conexao do objeto.Caso seja informada um nome de alias ณ
//ณabre nessa alias, caso contrario gera um alias automatica ณ
//ณde qualquer forma ela retorna a alias aberta, ou vazio    ณ
//ณcaso contrario                                            ณ
//ณVale lembrar que voc๊ jแ deve ter aberto a conexao com o  ณ
//ณmetodo AbreConexao do seu Fonte.                          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Method NewAlias(cQuery,cAlias,aSetField,lShare,lReadOnly) Class ClsDBAccess
Local cRet := ""
Local cNovaAlias
Local nX
Default lShare := .T.
Default lReadOnly := .T.
Default aSetField :={}
//Verifica se a Conexao esta Aberta
If ::nHandle < 0
	Return cRet
Endif
//Verica se o cara mandou a Query
If cQuery == Nil
	Return cRet
Endif
If cAlias == Nil
	cNovaAlias := GetNextAlias()
Else
	If Select(cAlias) > 0
		Return cRet
	Endif
	cNovaAlias := cAlias
Endif
TCSETCONN(::nHandle)
dbUseArea( .T., "TOPCONN",TcGenQry(,,cQuery), cNovaAlias, .T.,.T. )
If Select(cNovaAlias) >0
	For nX := 1 to Len (aSetField)
		TCSETFIELD ( cNovaAlias, aSetField[nX][1] ,aSetField[nX][2])
	Next nX
	cRet := cNovaAlias
Endif
If ::nHandleOld != Nil
	TCSETCONN(::nHandleOld)
Endif
aAdd(::aAliasAberta,cNovaAlias)

Return cRet



//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMethod ExecQuery              ณ
//ณRoda um Query direto no Banco.ณ
//ณRetorna True se conseguiu.    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Method ExecQuery(cQuery) Class ClsDBAccess
Local NRet
If ::nHandle < 0
	Return NRet
Endif
TCSETCONN(::nHandle)
//lRet := Iif (TcSqlExec(cQuery)==0,.T.,.F.)
NRet := TcSqlExec(cQuery)
If ::nHandleOld != Nil
	TCSETCONN(::nHandleOld)
Endif
Return NRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ ErSQLExecบAutor  ณ Ernani Forastieri  บ Data ณ  16/10/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Trata codigo de erro do TCSqlExec                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ErSQLExec( nErro )
Local cRet := ''

If     nErro == 0
	cRet := 'TC_NO_ERROR         '
ElseIf nErro == -1
	cRet := 'NO_ROUTER_INSTALLED '
ElseIf nErro == -2
	cRet := 'NO_CONNECTION       '
ElseIf nErro == -4
	cRet := 'NO_USER_SECURITY    '
ElseIf nErro == -5
	cRet := 'PASSTHRU_FAILED     '
ElseIf nErro == -6
	cRet := 'NO_MORE_CONNECTIONS '
ElseIf nErro == -8
	cRet := 'INVALID_TOP_KEY     '
ElseIf nErro == -9
	cRet := 'INVALID_ENVIRONMENT '
ElseIf nErro == -10
	cRet := 'INVALID_FILE        '
ElseIf nErro == -11
	cRet := 'UNKNOWN_FILE        '
ElseIf nErro == -12
	cRet := 'EXCLUSIVE_REQUIRED  '
ElseIf nErro == -13
	cRet := 'INVALID_OPERATION   '
ElseIf nErro == -14
	cRet := 'INVALID_KEY_NUM     '
ElseIf nErro == -15
	cRet := 'FILE_IN_USE         '
ElseIf nErro == -16
	cRet := 'TOO_MANY_FILES      '
ElseIf nErro == -17
	cRet := 'INVALID_NUMRECS     '
ElseIf nErro == -18
	cRet := 'CALL_FAILED         '
ElseIf nErro == -19
	cRet := 'COMMAND_FAILED      '
ElseIf nErro == -20
	cRet := 'OVERRIDE_FAILED     '
ElseIf nErro == -21
	cRet := 'QUERY_FAILED        '
ElseIf nErro == -22
	cRet := 'CREATION_FAILED     '
ElseIf nErro == -23
	cRet := 'OPEN_FAILED         '
ElseIf nErro == -24
	cRet := 'NOT_OPENED          '
ElseIf nErro == -25
	cRet := 'NO_RECORD_FOUND     '
ElseIf nErro == -26
	cRet := 'END_OF_RECORDS      '
ElseIf nErro == -27
	cRet := 'NO_WRITE_POSIBLE    '
ElseIf nErro == -28
	cRet := 'NO_RECORD_EQUAL     '
ElseIf nErro == -29
	cRet := 'UPDATE_FAILED       '
ElseIf nErro == -30
	cRet := 'DELETE_FAILED       '
ElseIf nErro == -31
	cRet := 'RECORD_LOCKED       '
ElseIf nErro == -32
	cRet := 'FILE_LOCKED         '
ElseIf nErro == -33
	cRet := 'NO_AUTORIZATION     '
ElseIf nErro == -34
	cRet := 'TOO_MANY_USERS      '
ElseIf nErro == -35
	cRet := 'NO_DB_CONNECTION    '
ElseIf nErro == -36
	cRet := 'NO_CONN_ALLOWED     '
ElseIf nErro == -37
	cRet := 'INTEGRITY_FAILURE   '
ElseIf nErro == -40
	cRet := 'BUFFER_OVERFLOW     '
ElseIf nErro == -50
	cRet := 'NO_AUDIT_CONNECTION '
ElseIf nErro == -99
	cRet := 'INVALID_BUILD       '
EndIf

Return AllTrim( cRet )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ EnvMail  บ Autor ณErnani Forastieri   บ Data ณ  26/05/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina Generica de Envio de E-mail                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ UNIP Universidade Paulista                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function EnvMail( cDe, cPara, cCc, cAssunto, cAnexo, cMsg )
Local lResulConn := .T.
Local lResulsend := .T.
Local cError     := ''
Local cServer    := Trim( SuperGetMV( 'MV_RELSERV',, '' ) )  // smtp.ig.com.br ou 200.181.100.51
Local cEmail     := Trim( SuperGetMV( 'MV_RELACNT',, '' ) )  // fulano@ig.com.br
Local cPass      := Trim( SuperGetMV( 'MV_RELPSW' ,, '' ) )  // 123abc
Local lAuth      :=       SuperGetMV( 'MV_RELAUTH',, .F.  )  // Tem Autenticacao ?
Local cContAuth  := Trim( SuperGetMV( 'MV_RELACNT',, '' ) )  // Conta Autenticacao
Local cPswAuth   := Trim( SuperGetMV( 'MV_RELAPSW',, '' ) )  // Senha Autenticacao
Local lRet       := .T.
Local nA         := 0

//conout( 'nOpera   ' , str( nO3pera ) )
//conout( 'cDe      ' , cDe )
//conout( 'cPara    ' , cPara  )
//conout( 'cCc      ' , cCc )
//conout( 'cAssunto ' , cAssunto )
//conout( 'cAnexo   ' , cAnexo )
//conout( 'cMsg     ' , cMsg  )

If Empty( cServer ) .AND. Empty( cEmail ) .AND. Empty( cPass )
	lRet := .F.
	ApMsgStop( 'Nใo foram definidos os parโmetros no server do Protheus para envio de e-mail', cAssunto )
	u_MsgConMon( 'Nใo foram definidos os parโmetros no server do Protheus para envio de e-mail - ' + cAssunto )
	Return lRet
EndIf

If Empty( cPara )
	lRet := .F.
	ApMsgStop( 'Nใo foram definidos detinatario para envio de e-mail', cAssunto )
	u_MsgConMon( 'Nใo foram definidos detinatario para envio de e-mail - ' + cAssunto )
	Return lRet
EndIf

cDe      := IIf( cDe == NIL, Trim( SuperGetMV( 'MV_RELFROM',, '' ) ), AllTrim( cDe ) )
cDe      := IIf( Empty( cDe ), 'WorkFlow by Microsiga' , cDe  )
cPara    := AllTrim( cPara )
cCC      := AllTrim( cCC )
cAssunto := AllTrim( cAssunto )
cAnexo   := AllTrim( cAnexo )


CONNECT SMTP SERVER cServer ACCOUNT cEmail PASSWORD cPass RESULT lResulConn

If !lResulConn
	lRet := .F.
	
	GET MAIL ERROR cError
	u_MsgConMon( 'Falha na conexใo para envio de e-mail ( ' + cError + ' ) ',, .F. )
	
	If !IsBlind()
		ApMsgStop( 'Falha na conexใo para envio de e-mail ( ' + cError + ' ) ' )
	EndIf
	
	Return lRet
EndIf

If lAuth
	//
	// Primeiro tenta fazer a Autenticacao de E-mail utilizando o e-mail completo
	//
	If !( lRet := MailAuth( cContAuth, cPswAuth )   )
		//
		// Se nao conseguiu fazer a Autenticacao usando o E-mail completo,
		// tenta fazer a autenticacao usando apenas o nome de usuario do E-mail
		//
		If !lRet
			nA        := At( '@', cContAuth )
			cContAuth := If( nA > 0, SubStr( cContAuth, 1, nA - 1 ), cContAuth )
			
			If !( lRet  := MailAuth( cContAuth, cPswAuth ) )
				lRet := .F.
				
				u_MsgConMon( 'Nใo conseguiu autenticar conta de e-mail ( ' + cContAuth + ' ) ',, .F.)
				
				If !IsBlind()
					ApMsgAlert( 'Nใo conseguiu autenticar conta de e-mail ( ' + cContAuth + ' ) ')
				EndIf
				
				DISCONNECT SMTP SERVER
				
				Return lRet
			EndIf
			
		EndIf
	EndIf
EndIf

//
// Verifica e-mails substitutos
//
//cPara := MailSubst( cPara )

If      Empty( cCc ) .AND.  Empty( cAnexo )
	SEND MAIL FROM cDe TO cPara SUBJECT cAssunto BODY cMsg RESULT lResulSend
	
ElseIf  Empty( cCc ) .AND. !Empty( cAnexo )
	SEND MAIL FROM cDe TO cPara SUBJECT cAssunto BODY cMsg ATTACHMENT cAnexo RESULT lResulSend
	
ElseIf !Empty( cCc ) .AND.  Empty( cAnexo )
	SEND MAIL FROM cDe TO cPara CC cCc SUBJECT cAssunto BODY cMsg RESULT lResulSend
	
Else
	SEND MAIL FROM cDe TO cPara CC cCc SUBJECT cAssunto BODY cMsg ATTACHMENT cAnexo RESULT lResulSend
	
EndIf

If !lResulSend
	GET MAIL ERROR cError
	lRet := .F.
	
	u_MsgConMon( 'Falha no envio do e-mail ( ' + cError + ' ) ',, .F. )
	
	If !IsBlind()
		ApMsgStop( 'Falha no envio do e-mail ( ' + cError + ' ) ' )
	EndIf
	
Else
	u_MsgConMon( 'Enviado e-mail Para: [' + cPara    + ']' ,.F., .F. )
	u_MsgConMon( '            Assunto: [' + cAssunto + ']' ,.F., .F. )
	
EndIf

DISCONNECT SMTP SERVER

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ PrxInd   บAutor  ณ Ernani Forastieri  บ Data ณ  16/10/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Retorna proxima sequencia de numeracao do LOG              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function PrxInd()
Local cRet     := Soma1( GetMV( 'FS_IDINT' ) )
Local aArea    := GetArea()
Local aAreaPA4 := PA4->( GetArea() )
//
// Id de Importacao Exportacao
//
cRet := Soma1( GetMV( 'FS_IDINT' ) )

While .T.
	
	If !PA4->( dbSeek( xFilial( 'PA4' )  + cRet ) )
		
		If MayIUseCode(  'INTPONTO' + cRet )
			Exit
			
		Else
			cRet := Soma1( cRet )
			cCod    := cRet
		End
		
	Else
		cRet := Soma1( cRet )
		cCod    := cRet
	EndIf
	
End

RestArea( aAreaPA4 )
RestArea( aArea )

Return cRet