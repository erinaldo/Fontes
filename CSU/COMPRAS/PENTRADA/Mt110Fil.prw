#Include 'Rwmake.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT110FIL  ºAutor  ³ Sergio Oliveira    º Data ³  Out/2006   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para filtrar somente as Solicitacoes do   º±±
±±º          ³ usuario logado/aprovador/comprador.                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Mt110Fil()

//Define variaveis
Local _aArea    := GetArea()
Local _nCall    := 1
Local _cString  := " "
Local _cFiltro  := " "

//Carrega em variavel a pilha de chamada de funcoes
While !Empty(ProcName(_nCall))
	_cString +=AllTrim(ProcName(_nCall)) + "/"
	_nCall ++
EndDo

//Verifica se a chamada nao tem origem no system tracker.
If !("MATRKSHOW" $ Upper(_cString))
	//Se nao tiver origem no system tracker e o usuario logado for comprador, nao precisa existir filtro.
	//Inserido em 21/11/2011 por Jose Maria - OS3010/11
	dBSelectArea("ZYY")
	dBSetOrder(1)         //ZW_FILIAL+ZW_NOME
	_lUserSC1    := .F.   //Se Falso filtra pelo SY1  
//	If dBSeek( xFilial("ZYY")+ Substr( cUsuario, 7, 15 ) , .F. )
	If dBSeek( xFilial("ZYY")+ cUserName)
		If ZYY->ZYY_ACESSO == "S"  .And. ZYY->ZYY_MSBLOQ <> "S"
			_lUserSC1  := .T.  //Se Verdadeira nao faz filtro
		Endif
	Endif
	If !_lUserSC1
	//------------------Ate aqui OS3010/11 Jose Maria
		DbSelectArea('SY1')
		DbSetOrder(3)
	 	If !DbSeek( xFilial('SY1')+__cUserId )
			//Filtra os registros do usuario logado X solicitante X aprovador
			_cFiltro := "C1_USER == '"+__cUserID+"'.Or. C1_XAPROV == '"+__cUserId+"' "
		Endif  
	Endif
Endif

RestArea(_aArea)

Return(_cFiltro)