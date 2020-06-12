#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT130FOR  บAutor  ณAndy / Emerson      บ Data ณ  13/10/2009 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Na versao 8.11 este ponto de entrada estava funcionando c/ บฑฑ
ฑฑบ          ณ um tipo de configuracao de DIALOG na versao 10 comecou a   บฑฑ
ฑฑบ          ณ dar conflito entao o Andy alterou para MSDIALOG            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ Emerson: Ajustes no layout da tela browse e botoes         บฑฑ
ฑฑบ          ณ          Alteracao no processo corrigindo a geracao do     บฑฑ
ฑฑบ          ณ          retorno de Fornecedores para gravar corretamente  บฑฑ
ฑฑบ          ณ          a informacao na Cotacao                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MT130FOR()

Local _nOpc
Local _nI        
Local aArea:=GetArea()                                      

Private _aCmps     := {}
Private _aRet := {}

_aSelFor	:= {}

If ValType(_PARAMIXB2) == "U"

	_aCmps:= {}
	
	For _nI := 1 to Len(PARAMIXB)
		DbSelectArea("SA2")
		DbSetOrder(1)
		DbSeek(xFilial("SA2")+PARAMIXB[_nI,1]+PARAMIXB[_nI,2])
		If SA2->A2_MSBLQL <> "1" //Diferente de 1-Sim, nao esta bloqueado
			aAdd(_aCmps,{.F.,PARAMIXB[_nI,1], alltrim(SA2->A2_NOME), SA2->(Recno()) })
		EndIf
	Next _nI

	aSort(_aCmps,,, { |x, y| x[2] < y[2] })

	_nOpc := MontaBrowse("TRB", _aCmps, _aRet)
	
	_PARAMIXB2 := _aSelFor

	//Verificando consulta gerada pelo Fonte Padrao para identificarmos quando solicitar ao usuario a tela de Fornecedores novamente
	If empty(a130proces->c1_num)
		_PARAMIXB2 := NIL
	EndIf

	/*
	Alterado pelo analista Emerson dia 13/10/09
	Atraves do retorno (_aRet = Codigo e Nome do Fornecedor) e criado uma ARRAY com o mesmo conteudo do ARRAY PADRAO
	CODIGO/LOJA
	*/
	For _nY := 1 to Len(_aRet)
		ax := aScan (ParamIXB, {|x| AllTrim(x[1])  == _aret[_nY,1] })
		If ax > 0
			aadd(_aSelFor, {ParamIXB[ax,1], ParamIXB[ax,2], ParamIXB[ax,3], ParamIXB[ax,4], ParamIXB[ax,5]})
		EndIf
	Next
ElseIf !(ValType(_PARAMIXB2) == "C" .and. _PARAMIXB2 == "Cancelado")
	_aSelFor := _PARAMIXB2
	//Verificando consulta gerada pelo Fonte Padrao para identificarmos quando solicitar ao usuario a tela de Fornecedores novamente
	If empty(a130proces->c1_num)
		_PARAMIXB2 := NIL
	EndIf
Endif

RestArea(aArea)
Return (_aSelFor)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณMontaBrowseบAutor ณFelipe Raposo       บ Data ณ  24/06/02   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MontaBrowse(_cAlias, _aCmps, _aRet)

Local _nLin, _nLinTam, _nRetorno
Local _cCadastro
Private  oOk   		:= LoadBitmap( GetResources(), "LBOK" )
Private oNo   		:= LoadBitmap( GetResources(), "LBNO" )

Private _cCmpMark, _aOpc, _oMark

Private aAreaMnt		:= GetArea()
_cCmpMark 	:= _aCmps[1][1]
_aOpc 		:= {_cAlias, _aCmps}

aSort(_aCmps,,, { |x, y| x[2] < y[2] })

	DEFINE MSDIALOG oDlg FROM  200, 001 to 455, 588 TITLE _cCadastro PIXEL
	@ 006, 005 LISTBOX oLbx1 FIELDS HEADER "","Codigo","Razao Social" SIZE 225, 115 OF oDlg PIXEL ON DBLCLICK (U_MARKFOR())
	
	oLbx1:SetArray(_aCmps)
	oLbx1:bLine := { || {If(_aCmps[oLbx1:nAt,1],oOk,oNo),_aCmps[oLbx1:nAt,2], _aCmps[oLbx1:nAt,3]} }
	oLbx1:nFreeze  := 1

	@ 006,235 BUTTON "Ok" 				SIZE 55,15 ACTION  MarkOpc(_nRetorno := 01, .T., _aRet)
	@ 026,235 BUTTON "Cancelar" 		SIZE 55,15 ACTION (MarkOpc(_nRetorno := 99, .T., _aRet),oDlg:End())
	@ 046,235 BUTTON "Visualizar" 		SIZE 55,15 ACTION  MarkOpc(_nRetorno := 05, .T., _aRet)
	@ 066,235 BUTTON "Inclui Fornec."	SIZE 55,15 ACTION (MarkOpc(_nRetorno := 02, .T., _aRet),oDlg:End())
	@ 086,235 BUTTON "Pesq.Fornecedor"	SIZE 55,15 ACTION MarkOpc(_nRetorno := 06, .T., _aRet)

/*
	@ 066,235 BUTTON "Marcar Tudo" 		SIZE 55,15 ACTION MarkOpc(_nRetorno := 02, .T., _aRet)
	@ 086,235 BUTTON "Desmarcar Tudo" 	SIZE 55,15 ACTION MarkOpc(_nRetorno := 03, .T., _aRet)
	@ 106,235 BUTTON "Inverter Sele็ใo"	SIZE 55,15 ACTION MarkOpc(_nRetorno := 04, .T., _aRet)
*/

	ACTIVATE MSDIALOG oDlg CENTERED
                 
If ValType(_nRetorno) == "U"       
	_nRetorno := 1
EndIf

RestArea(aAreaMnt)
Return (_nRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณMarkOpc   บAutor  ณ Felipe Raposo      บ Data ณ  24/06/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Executa uma funcao de acordo com o parametro passado:      บฑฑ
ฑฑบ          ณ 1 - Confirma processamento.                                บฑฑ
ฑฑบ          ณ 2 - Marca todos os itens da MarkBrowse.                    บฑฑ
ฑฑบ          ณ 3 - Desmarca todos os itens da MarkBrowse.                 บฑฑ
ฑฑบ          ณ 4 - Inverter a selecao.                                    บฑฑ
ฑฑบ          ณ 5 - Visualizar.                                            บฑฑ
ฑฑบ          ณ 99 - Cancelar processamento.                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MarkOpc(_nOpc, _lRefresh, _aRet)

Local _nPos, _cMarca, _cDesmarca
Local _cAlias, _lOk

//If alias() <> "TRB"
//	Return
//EndIf

_cAlias    := _aOpc[1]
_cMarca    := GetMark()
_cDesmarca := ThisMark()

//dbSelectArea(_cAlias)
Do Case
	Case _nOpc == 1  // Ok.
		If _nOpc == 1 
			For _nI := 1 to Len(_aCmps)
				If _aCmps[_nI,1]
					aAdd(_aRet, {_aCmps[_nI,2], _aCmps[_nI,3], ""})
				EndIf
			Next _nI
			_PARAMIXB2 := _aRet
		Endif
   		oDlg:End()
	Case _nOpc == 99  // Cancelar.
//		U_MT130WF()  // Desmarca as solicitacoes de compra.
		_PARAMIXB2 := "Cancelado"
		oDlg:End()		
	Case _nOpc == 2  // Inclui Fornecedor
/*	// Marca tudo.
		For _nI := 1 to Len(_aCmps)
			_aCmps[_nI,1] := .T.
		Next _nI
		oLbx1:Refresh(.T.)
*/
		RestArea(aAreaMnt)
		A020SXB()
		Return
	Case _nOpc == 3  // Desmarca tudo.
		For _nI := 1 to Len(_aCmps)
			_aCmps[_nI,1] := .F.
		Next _nI
		oLbx1:Refresh(.T.)
	Case _nOpc == 4  // Inverter.
		For _nI := 1 to Len(_aCmps)
			If _aCmps[_nI,1]
				_aCmps[_nI,1] := .F.
			Else
				_aCmps[_nI,1] := .T.
			EndIf
		Next _nI
		oLbx1:Refresh(.T.)
	Case _nOpc == 5  // Visualizar
		For _nI := 1 to Len(_aCmps)
			If _aCmps[_nI,1]
				_xRecno := _aCmps[_nI,4]
				DbSelectArea("SA2")
				DbGoto(_xRecno)
				If AxVisual("SA2", Recno() , 2) <> 1
					exit
				EndIf
			EndIf
		Next _nI
	Case  _nOpc == 6  // Pesquisar Nome Fornecedor

		_cNome	:= Space(40)

		@ 33,25 TO 110,349 Dialog oDlg01 Title "Pesquisa por Fornecedor"
		@ 01,05 TO 035, 128
		@ 08,08 Say "Nome"
		@ 08,35 Get _cNome PICTURE "@!" VALID .T.
		@ 05, 132  BMPBUTTON TYPE 1 Action CLOSE (oDlg01)

		Activate Dialog oDlg01 CENTERED

		If !Empty(alltrim(_cNome))
			_nTamNom := LEN(ALLTRIM(_cNome))
			_nPosFor := ascan(_aCmps,{|x| Substr(alltrim(x[3]),1,_nTamNom) == alltrim(_cNome)})
			If _nPosFor > 0
				oLbx1:nAt	:= _nPosFor
				oLbx1:Refresh(.T.)
			EndIf
		EndIf
EndCase

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT130WF   บAutor  ณ Felipe Raposo      บ Data ณ  11/09/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de entrada  -  Programa: MATA130                     บฑฑ
ฑฑบ          ณ Apos a geracao das cotacoes.                               บฑฑ
ฑฑบ          ณ Executado apos atualizacao de arquivos na geracao de cota- บฑฑ
ฑฑบ          ณ coes                                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ Nenhum.                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Nenhum.                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE.                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
//User Function MT130WF()
//Private _aOpc, _cCmpMark

//_PARAMIXB2 	:= nil
//_cCmpMark 	:= "C1_OK"
//_aOpc 		:= {"SC1"}

//MarkOpc(3, .F.)   // desmarca as solicitacoes antes de exibi-las.

//Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT130FOR  บAutor  ณMicrosiga           บ Data ณ  10/13/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MARKFOR()

If _aCmps[oLbx1:nAt,1]
	_aCmps[oLbx1:nAt,1] := .F.
Else
	_aCmps[oLbx1:nAt,1] := .T.
EndIf
oLbx1:Refresh(.T.)

Return