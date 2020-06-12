/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณFechaAliasบAutor  ณFelipe Raposo       บ Data ณ  27/11/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fecha os arquivos abertos, apaga os arquivos temporarios e บฑฑ
ฑฑบ          ณ os indices, de acordo com a listagem da matriz passada por บฑฑ
ฑฑบ          ณ parametro.                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบSintaxe   ณFechaAlias(_aAlias)                                         บฑฑ
ฑฑบ          ณOnde _aAlias eh uma matriz, de quatro colunas, que contem:  บฑฑ
ฑฑบ          ณ1a col - Alias aberto.                                      บฑฑ
ฑฑบ          ณ2a col - Arquivo desse alias.                               บฑฑ
ฑฑบ          ณ3a col - Indice desse alias                                 บฑฑ
ฑฑบ          ณ4a col - .T. se o alias estiver aberto ou .F. se nao for ne-บฑฑ
ฑฑบ          ณ         cessaria nenhuma mudanca.                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณAlias com 3 itens:                                          บฑฑ
ฑฑบesperado  ณ1a item - numero de aliases fechados.                       บฑฑ
ฑฑบ          ณ2a item - numero de arquivos apagados.                      บฑฑ
ฑฑบ          ณ3a item - numero de indices apagados.                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Hospital Samaritano                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FechaAlias(_aAlias)
Local _aRetorno := {}
Processa({|| _aRetorno := FuncProc(_aAlias) },"Apagando arquivos temporarios . . .")
Return (_aRetorno)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Static Function para a regua de progressao.  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Static Function FuncProc(_aAlias)
Local _aRetorno := {0, 0, 0, 0}, _cMsg
ProcRegua(len(_aAlias))
For iAux := 1 to len(_aAlias)
	_cMsg := _aAlias[iAux, 2] +;
	IIf(!empty(_aAlias[iAux, 3]), " / " + _aAlias[iAux, 3], "") + " . . ."
	IncProc(_cMsg)
	// Verifica se o alias esta ativo ainda.
	If _aAlias[iAux, 4]
		// Fecha o alias.
		dbSelectArea(_aAlias[iAux, 1])
		dbCloseArea()
		_aRetorno[1] ++
		
		// Apaga o arquivo, caso ele exista.
		If File(_aAlias[iAux, 2])
			If fErase (_aAlias[iAux, 2]) == 0
				_aRetorno[2] ++
			Else
				_cMsg := "O alias " + _aAlias[iAux, 1] + " nao pode liberar o arquivo " +;
				_aAlias[iAux, 2] + " para exclusao. " + chr(10) + chr(13) +;
				"Favor, deleta-lo manualmente apos o encerramento do programa."
				MsgAlert (_cMsg)
			Endif
		ElseIf !Empty(_aAlias[iAux, 2])
			_cMsg := "O arquivo " + _aAlias[iAux, 2] + " nao pode ser encontrado para exclusao!!!"
			MsgAlert (_cMsg)
		Endif
		
		// Apaga o indice temporario, caso exista.
		If File(_aAlias[iAux, 3])
			If fErase (_aAlias[iAux, 3]) == 0
				_aRetorno[3] ++
			Else
				_cMsg := "O alias " + _aAlias[iAux, 1] + " nao pode liberar o arquivo de indice " +;
				_aAlias[iAux, 3] + " para exclusao. " + chr(10) + chr(13) +;
				"Favor, deleta-lo manualmente apos o encerramento do programa."
				MsgAlert (_cMsg)
			Endif
		ElseIf !Empty(_aAlias[iAux, 3])
			_cMsg := "O arquivo de indice " + _aAlias[iAux, 3] + " nao pode ser encontrado para exclusao!!!"
			MsgAlert (_cMsg)
		Endif
		
		// Marca o alias como desativado.
		_aAlias[iAux, 4] := .F.
	Endif
Next iAux
Return (_aRetorno)