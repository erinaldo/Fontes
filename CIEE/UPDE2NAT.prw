#Include 'Protheus.ch'

//Conexão Banco a Banco

User Function UPDE2NAT()
	// Exemplo de função que alterna entre conexão de dados de ERP e conexão adicional
	// com outro banco através do DBAccess. Deve ser executada a partir do Menu do ERP.
  	// Recupera handler da conexão atual com o DBAccess
  	// Esta conexão foi feita pelo Framework do AdvPL, usando TCLink()
  Local nHndERP := AdvConnection()
  Local cDBSql  := "MSSQL7/CDPRXC_PRDSP"
  Local cSrvSql := "192.168.5.236"
  Local nHndSql := -1
  Local cQuery  := ''
   
  alert( "ERP conectado - Handler = " + str( nHndERP, 4 ) )
   
  // Cria uma conexão com um outro banco, outro DBAcces
  nHndSql := TcLink( cDBSql, cSrvSql, 8112 )
  If nHndSql < 0
    alert( "Falha ao conectar com " + cDBSql + " em " + cSrvSql )
    UserException( "Falha ao conectar com " + cDBSql + " em " + cSrvSql )
  Endif
   
  alert( "Producao Conectada - Handler = " + str( nHndSql, 4 ) )
  alert( "Banco = " + TcGetDB() )
  alert( "PRODUCAO Identificador da conexao no SGDB: " + TCGetDBSID() )
   
  // Volta para conexão ERP
  tcSetConn( nHndERP )
  alert( "Banco = " + TcGetDB() )
  alert( "Identificador da conexao no SGDB: " + TCGetDBSID() )
   
  // Fecha a conexão com o Oracle
  TcUnlink( nHndSql )
  alert( "Producao desconectado" )
   
  // Mostra a conexão ativa
  alert( "Banco = " + TcGetDB() )
Return