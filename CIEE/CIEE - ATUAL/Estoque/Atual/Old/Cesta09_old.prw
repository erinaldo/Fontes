# include "rwmake.ch"
# include "Topconn.ch"
# include "PROTHEUS.CH"

//Trazer na tela da Versao 10 o menu padrao para a rotina
//Static Function MenuDef()
//Return StaticCall(MATXATU,MENUDEF)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CESTA09   �Autor  �Emerson Natali      � Data �  21/08/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para Gerar Requisicoes de Estoque                   ���
���          � Integrada com a INTRANET                                   ���
�������������������������������������������������������������������������͹��
���Uso       � CIEE                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CESTA09()

Private aRotina 	:= {}
Private aCores	 	:= {}
Private cCadastro 	:= "Requisicao de Material"

aAdd(aRotina, {"Pesquisar" 		, "AxPesqui"					, 0, 1})
aAdd(aRotina, {"Visualizar"		, "u_VALREQ('SZN', Recno(), 2)"	, 0, 2})
aAdd(aRotina, {"vAlida"			, "u_VALREQ('SZN', Recno(), 3)"	, 0, 4}) //Deixando a letra maiuscula a letra serve de tecla de atalho
aAdd(aRotina, {"Elim.Residuo"	, "u_VALREQ('SZN', Recno(), 4)"	, 0, 4})
aAdd(aRotina, {"Legenda"   		, "u_LEGREQ()"					, 0, 5})

/*
''- branco		= 	Verde
1 - Processado	=	Azul
2 - Pendente	=	Amarelo
3 - Cancelado	=	Vermelho
*/

aCores	:= {	{'ZN_STATUS == " " .AND. Empty(ZN_OBS)'													, 'BR_VERDE'	},;
				{'ZN_STATUS == "1"'																		, 'BR_AZUL'		},;
				{'ZN_STATUS == "2" .OR. (ZN_QTENTRE == 0 .AND. !Empty(ZN_OBS) .AND. ZN_STATUS == " ")'	, 'BR_AMARELO'	},;
				{'ZN_STATUS == "3"'																		, 'BR_CANCEL'	}}

//FAZ CARGA NA TABELA SZN COM O CONTEUDO DO ARQUIVO TXT GERADO PELA ROTINA DE INTRANET (REQUISICAO DE MATERIAL)
CARGA_REQMAT()

dbSelectArea("SZN")
dbSetOrder(1)
dbGoTop()

mBrowse(6,1,22,74,"SZN",,,,,,aCores)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CESTA09   �Autor  �Emerson Natali      � Data �  21/08/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function VALREQ(cAlias, nReg, nOpc)

Local cChave := ""
Local nCols  := 0
Local i      := 0
Local lRet   := .F.

// Parametros da funcao Modelo2().
Private cTitulo  := cCadastro
Private aC       := {}                     // Campos do Enchoice.
Private aR       := {}                     // Campos do Rodape.
Private aCGD     := {}                     // Coordenadas do objeto GetDados.
//Private cLinOK   := "u_AllwaysTrue("+alltrim(str(nOpc))+")"  // Funcao para validacao de uma linha da GetDados.
Private cLinOK   := ""
Private cAllOK   := "u_Md2TudOK("+alltrim(str(nOpc))+")"
Private aGetsGD  := {}
Private bF4      := {|| }                  // Bloco de Codigo para a tecla F4.
Private aHeader  := {}                     // Cabecalho de cada coluna da GetDados.
Private aCols    := {}                     // Colunas da GetDados.
Private nCount   := 0
Private bCampo   := {|nField| FieldName(nField)}
Private dData    := CtoD("  /  /  ")
Private cNumero  := Space(6)
Private aAlt     := {}

Private lMsErroAuto := .F.

// Cria variaveis de memoria: para cada campo da tabela, cria uma variavel de memoria com o mesmo nome.
dbSelectArea(cAlias)

For i := 1 To FCount()
	M->&(Eval(bCampo, i)) := CriaVar(FieldName(i), .T.)
	// Assim tambem funciona: M->&(FieldName(i)) := CriaVar(FieldName(i), .T.)
Next
/////////////////////////////////////////////////////////////////////
// Cria vetor aHeader.                                             //
/////////////////////////////////////////////////////////////////////

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek(cAlias)

While !SX3->(EOF()) .And. SX3->X3_Arquivo == cAlias
	If X3Uso(SX3->X3_Usado)    .And.;                  // O Campo � usado.
		cNivel >= SX3->X3_Nivel .And.;                  // Nivel do Usuario � maior que o Nivel do Campo.
		!Trim(SX3->X3_Campo) $ "ZN_NUMSOC|ZN_USEREQ|ZN_EMAIL|ZN_CR|ZN_DESCCR|ZN_DATA|ZN_EMAIL2|ZN_RAMAL|ZN_LOCALI|ZN_KITLAN"   // Campos que ficarao na parte da Enchoice.
		If (nOpc == 3 .or. nOpc == 2) .and. Trim(SX3->X3_Campo) <> "ZN_FLAGCAN" // Validacao
			AAdd(aHeader, {		Trim(SX3->X3_Titulo),;
								SX3->X3_Campo       ,;
								SX3->X3_Picture     ,;
								SX3->X3_Tamanho     ,;
								SX3->X3_Decimal     ,;
								SX3->X3_Valid       ,;
								SX3->X3_Usado       ,;
								SX3->X3_Tipo        ,;
								SX3->X3_Arquivo     ,;
								SX3->X3_Context})
		ElseIf nOpc == 4 .and. Trim(SX3->X3_Campo) <> "ZN_QTDE" // Quantidade
			AAdd(aHeader, {		Trim(SX3->X3_Titulo),;
								SX3->X3_Campo       ,;
		   						SX3->X3_Picture     ,;
		   						SX3->X3_Tamanho     ,;
		   						SX3->X3_Decimal     ,;
								SX3->X3_Valid       ,;
								SX3->X3_Usado       ,;
								SX3->X3_Tipo        ,;
								SX3->X3_Arquivo     ,;
								SX3->X3_Context})
		EndIf
	EndIf
	SX3->(dbSkip())
End

/////////////////////////////////////////////////////////////////////
// Cria o vetor aCols: contem os dados dos campos da tabela.       //
// Cada linha de aCols � uma linha da GetDados e as colunas sao as //
// colunas da GetDados.                                            //
/////////////////////////////////////////////////////////////////////

dbSelectArea(cAlias)
dbSetOrder(1)

cNumero		:= (cAlias)->ZN_NUMSOC
cUserReq 	:= (cAlias)->ZN_USEREQ
cEmail  	:= (cAlias)->ZN_EMAIL //Nao esta sendo utilizada
cCR			:= (cAlias)->ZN_CR
cDescCR 	:= (cAlias)->ZN_DESCCR
cRamal 		:= (cAlias)->ZN_RAMAL
dData 		:= (cAlias)->ZN_DATA
cEmail2 	:= (cAlias)->ZN_EMAIL2 //Nao esta sendo utilizada
cLocali 	:= (cAlias)->ZN_LOCALI
cKitLan 	:= (cAlias)->ZN_KITLAN
_nSaldo		:= 0

//dbSeek(xFilial(cAlias) + dtos(dData) + cCR +cNumero)
dbSeek(xFilial(cAlias) + cNumero)

If nOpc == 3 //So para situacoes igual Validacao
	//Limpa campo MEMO.
	//Este bloco foi acrescentado para que o campo OBS seja obrigatorio quando o Status do ITEM for PENDENTE.
	_cQuery	:= "UPDATE "+ RetSqlName("SZN")+" SET ZN_OBS = '' "
	_cQuery += "WHERE D_E_L_E_T_ <> '*' AND ZN_NUMSOC = '"+cNumero+"' "
	_cQuery += "AND ZN_STATUS = '2' "
	TcSQLExec(_cQuery)
EndIf

_nQuant := 0
_nQtde  := 0
While !EOF() .And. (cAlias)->(ZN_FILIAL+ZN_NUMSOC) == xFilial(cAlias)+cNumero
	
	If nOpc <> 2
		If (cAlias)->(ZN_STATUS) == "1" .or. (cAlias)->(ZN_STATUS) == "3" //Processado ou Cancelado
			dbSelectArea(cAlias)
			dbSkip()
			Loop
		EndIf
	EndIf
	
	AAdd(aCols, Array(Len(aHeader)+1))   // Cria uma linha vazia em aCols.
	nCols++
	
	// Preenche a linha que foi criada com os dados contidos na tabela.
	For i := 1 To Len(aHeader)
		If aHeader[i][10] <> "V"    // Campo nao � virtual.
			Do Case
				Case alltrim(aHeader[i][01]) == "Dt WKF"
					aCols[nCols][i] := dDataBase
				Case alltrim(aHeader[i][02]) == "ZN_QUANT"
					aCols[nCols][i] := FieldGet(FieldPos(aHeader[i][2]))   // Carrega o conteudo do campo.				
					_nQuant := aCols[nCols][i]
				Case alltrim(aHeader[i][02]) == "ZN_QTDE"
					aCols[nCols][i] := FieldGet(FieldPos(aHeader[i][2]))   // Carrega o conteudo do campo.
					_nPsSaldo   := aScan(aHeader, {|x| AllTrim(x[2]) == "ZN_QTENTRE"})
					aCols[nCols][_nPsSaldo] := FieldGet(FieldPos(aHeader[_nPsSaldo][2]))
					_nSld		:= aCols[nCols][_nPsSaldo]
					If nOpc <> 2
						If !Empty(_nSaldo)
							If _nSaldo[1] > _nQuant
								_nPerc := _nSaldo[1]-(_nSaldo[1] * 0.20)//20%
								If _nPerc >= _nQuant
									aCols[nCols][i] := _nQuant - _nSld
								EndIf
							EndIf
						EndIf
						_nQtde := aCols[nCols][i]
					EndIf
				Case alltrim(aHeader[i][02]) == "ZN_SALDO"
					aCols[nCols][i] := FieldGet(FieldPos(aHeader[i][2]))   // Carrega o conteudo do campo.
					aCols[nCols][i] := aCols[nCols][i] - _nQtde
				Case alltrim(aHeader[i][02]) == "ZN_OBS"
					aCols[nCols][i] := FieldGet(FieldPos(aHeader[i][2]))   // Carrega o conteudo do campo.
					If nOpc == 3 //So para situacoes igual Validacao
						aCols[nCols][i] := ""
					EndIf
				OtherWise
					aCols[nCols][i] := FieldGet(FieldPos(aHeader[i][2]))   // Carrega o conteudo do campo.
			EndCase
		Else
			// A funcao CriaVar() le as definicoes do campo no dic.dados e carrega a variavel de acordo com
			// o Inicializador-Padrao, que, se nao foi definido, assume conteudo vazio.
			aCols[nCols][i] := CriaVar(aHeader[i][2], .T.)
			DbSelectArea("SB1")
			DbSetOrder(1)
			DbSeek(xFilial("SB1")+(cAlias)->ZN_COD,.F.)
			_nSaldo :=CalcEst(SB1->B1_COD, SB1->B1_LOCPAD, ctod("31/12/49"))
			aCols[nCols][i] := iif(!Empty(_nSaldo),_nSaldo[1],0)
			dbSelectArea(cAlias)
		EndIf
	Next
	
	// Cria a ultima coluna para o controle da GetDados: deletado ou nao.
	aCols[nCols][Len(aHeader)+1] := .F.
	
	// Atribui o numero do registro neste vetor para o controle na gravacao.
	AAdd(aAlt, Recno())
	dbSelectArea(cAlias)
	dbSkip()
End

If Empty(aCols)
	msgBox("Requisicao Totalmente Atendida!!")
	Return
EndIf

// aC[n][1] = Nome da variavel. Ex.: "cCliente"
// aC[n][2] = Array com as coordenadas do Get [x,y], em Pixel.
// aC[n][3] = Titulo do campo
// aC[n][4] = Picture
// aC[n][5] = Validacao
// aC[n][6] = F3
// aC[n][7] = Se o campo � editavel, .T., senao .F.

AAdd(aC, {"cNumero"		, {15,010}, "N�mero				", "@!"     	, , , .F.})
AAdd(aC, {"dData"  		, {15,100}, "Data de Emissao	", "99/99/99"	, , , .F.})
AAdd(aC, {"cUserReq"	, {30,010}, "Solicitante		", ""			, , , .F.})
AAdd(aC, {"cRamal"  	, {30,350}, "Ramal				", ""			, , , .F.})
AAdd(aC, {"cCR"  		, {45,010}, "CR					", ""			, , , .F.})
AAdd(aC, {"cDescCR"  	, {45,100}, "Descri��o CR		", ""			, , , .F.})
AAdd(aC, {"cLocali"  	, {60,010}, "Localizacao 		", ""			, , , .F.})
AAdd(aC, {"cKitLan"  	, {60,150}, "Kit Lanche Aprediz ", ""			, , , .F.})

// Coordenadas do objeto GetDados.
aCGD 	:= {120,5,128,315}

// Executa a funcao Modelo2().
/*
lRet := Modelo2(cTitulo, aC, aR, aCGD, 6, cLinOK, cAllOK, , , , , ,.F.)
*/
If nOpc == 2 //Visualizar
	_nOpcao := 2
Else
	_nOpcao := 6 //Altera mas nao inclui itens
EndIf

lRet := Modelo2(cTitulo, aC, aR, aCGD, _nOpcao, , cAllOK, , , , , ,.F.)

If lRet  // Confirmou.
	Processa({||Md2Alter(cAlias,nOpc,cCR)}, cTitulo, "Validacao dos dados, aguarde...")
EndIf

Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CESTA09   �Autor  �Emerson Natali      � Data �  21/08/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Md2Alter(cAlias,nOpc,cCR)

Local i := 0
Local y := 0

ProcRegua(Len(aCols))

dbSelectArea(cAlias)
dbSetOrder(1)

aCab	:= {}
aItens 	:= {}
_nQtde	:= 0

aCab:={	{"D3_TM"		,"501"		,NIL},;
		{"D3_CC"		,cCR		,NIL},;
		{"D3_EMISSAO"	,dDataBase	,NIL}}

For i := 1 To Len(aCols)
	
	If i <= Len(aAlt)
		// aAlt contem os Recno() dos registros originais.
		// O usuario pode ter incluido mais registros na GetDados (aCols).
		DbSelectArea(cAlias)
		dbGoTo(aAlt[i])                 // Posiciona no registro.
		RecLock(cAlias, .F.)
		If aCols[i][Len(aHeader)+1]     // A linha esta deletada.
			dbDelete()                   // Deleta o registro correspondente.
		Else
			// Regrava os dados.
			For y := 1 To Len(aHeader)
				FieldPut(FieldPos(Trim(aHeader[y][2])), aCols[i][y])
			Next
			
			(cAlias)->ZN_QTENTRE 	:= (cAlias)->ZN_QTENTRE+(cAlias)->ZN_QTDE //Acumulado de Entrega
			_nQtde					:= (cAlias)->ZN_QTDE

			If (cAlias)->ZN_DTATEND == DDATABASE .AND. (cAlias)->ZN_STATUS  == "2"
				(cAlias)->ZN_QTWKF		:= (cAlias)->ZN_QTWKF
			Else
				(cAlias)->ZN_QTWKF		:= (cAlias)->ZN_QTDE
			EndIf

			(cAlias)->ZN_QTDE		:= 0

			If !Empty(_nQtde)
				If iif(Empty((cAlias)->ZN_SALDO),.F.,(cAlias)->ZN_SALDO < (cAlias)->ZN_QUANT) // Saldo e menor que Quantidade Solicitada
					(cAlias)->ZN_STATUS  := "2" //Pendente
					If Empty((cAlias)->ZN_DTATEND)
						(cAlias)->ZN_DTATEND := dDataBase //Data 1 Atendimento
					Else
						If Empty((cAlias)->ZN_SALDO)
							(cAlias)->ZN_DTREGUL := dDataBase //Data 2 Atendimento
						EndIf
					EndIf
				ElseIf Empty((cAlias)->ZN_SALDO)
					(cAlias)->ZN_STATUS  := "1" //Processado
					If Empty((cAlias)->ZN_DTATEND)
						(cAlias)->ZN_DTATEND := dDataBase //Data 1 Atendimento
						(cAlias)->ZN_DTREGUL := dDataBase //Data 2 Atendimento
					Else
						(cAlias)->ZN_DTREGUL := dDataBase //Data 2 Atendimento
					EndIf
				EndIf
			ElseIf Empty(_nQtde) .and. nOpc == 4 //Elimina Residuo
				If (cAlias)->ZN_FLAGCAN = 'S'
					(cAlias)->ZN_STATUS  := "3" //Cancelado
					(cAlias)->ZN_QTRESID := (cAlias)->ZN_SALDO
					(cAlias)->ZN_SALDO   := 0
					(cAlias)->ZN_DTREGUL := dDataBase //Data 2 Atendimento
				EndIf
			EndIf
			
		EndIf
		MSUnlock()
	EndIf
	
	If !Empty(_nQtde)
		_nPsProd   := aScan(aHeader, {|x| AllTrim(x[2]) == "ZN_COD"})
		_nPsUM     := aScan(aHeader, {|x| AllTrim(x[2]) == "ZN_UM"})
		AADD(aItens,{	{"D3_FILIAL"	,"01"				, NIL},;
						{"D3_COD"		,aCols[i][_nPsProd]	, NIL},;
						{"D3_QUANT"		,_nQtde				, NIL},;
						{"D3_UM"		,aCols[i][_nPsUM]	, NIL},;
						{"D3_LOCAL"		,"01"				, NIL}})
	EndIf
Next i

If len(aItens) > 0
	Begin Transaction
	MSEXECAUTO({|x,y,z| MATA241(x,y,z)}, aCab, aItens,3)
	If lMsErroAuto
		DisarmTransaction()
			MostraErro()
		break
	EndIf

/*
	_axArea := GetArea()
	
	cQuery	:= "SELECT MAX(D3_DOC) AS D3_DOC FROM "
	cQuery	+= RetSqlName('SD3') + " D3 "
	cQuery	+= "WHERE D_E_L_E_T_ <> '*' AND "
	cQuery	+= "SUBSTRING (D3.D3_DOC,1,1) IN ('0','1','2','3','4','5','6','7','8','9') AND " 	
	cQuery	+= "D3.D3_FILIAL = '"+xFilial("SD3")+"' "
	TCQuery cQuery Alias TD3 New

	cNewnum := TD3->D3_DOC
	cNewnum := Soma1(cNewnum)

	TD3->(DbCloseArea())

	For _nX := 1 to Len(aItens)
		DbSelectArea("SB2")
		DbSetOrder(1)
		If DbSeek(xFilial("SB2")+alltrim(aItens[_nX,2,2]))
			nCusto	:= 0
			If SB2->B2_QATU > 0
				nCusto	:= aItens[_nX,3,2] * SB2->B2_CM1
			EndIf

			DbSelectArea("SD3")
			RecLock("SD3",.T.)
   	
			SD3->D3_DOC		:=cNewnum
			
			//cabec
			SD3->D3_TM		:= "501"
			SD3->D3_CC		:= cCR
			SD3->D3_EMISSAO	:= dDataBase
			//itens
			SD3->D3_FILIAL	:= "01"
			SD3->D3_COD		:= aItens[_nX,2,2]
			SD3->D3_CF		:= "RE0"
			SD3->D3_QUANT	:= aItens[_nX,3,2]
			SD3->D3_UM		:= aItens[_nX,4,2]
			SD3->D3_LOCAL	:= "01" 
			SD3->D3_GRUPO	:= Alltrim(SubString(aItens[_nX,2,2],1,2))
			SD3->D3_TIPO	:= "ME"
			SD3->D3_CUSTO1	:= nCusto
			MsUnLock()
   	
			DbSelectArea("SB2")
			DbSetOrder(1)
			If DbSeek(xFilial("SB2")+alltrim(aItens[_nX,2,2]))
				If SB2->B2_QATU > 0
					RecLock("SB2",.F.)
					SB2->B2_QATU -= aItens[_nX,3,2]
					MsUnLock()
				EndIf
			EndIf
		EndIf       	
	Next
	
	RestArea(_axArea)
*/	
	End Transaction
EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CESTA09   �Autor  �Microsiga           � Data �  08/22/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function Md2TudOK(nOpc)

Local lRet1 := .T.
Local i     := 0
Local nObs1 := 0
Local nQtde := 0

For i := 1 To Len(aCols)

	If nOpc == 3 // Valida
		_nPsQtde   := aScan(aHeader, {|x| AllTrim(x[2]) == "ZN_QTDE"})
		_nPsSaldo  := aScan(aHeader, {|x| AllTrim(x[2]) == "ZN_SALDO"})
		_nPsOBS    := aScan(aHeader, {|x| AllTrim(x[2]) == "ZN_OBS"})

		If aCols[i][_nPsQtde] <> 0 .AND. aCols[i][_nPsSaldo] <> 0 //Quantidade e Saldo diferente de Zero.
			If Empty(aCols[i][_nPsOBS])
				nObs1++
			EndIf
		Else
//			If Empty(aCols[i][_nPsQtde])
			If aCols[i][_nPsSaldo] <> 0
				If Empty(aCols[i][_nPsOBS])
					nQtde++
				EndIf
			EndIf
		EndIf
	ElseIf nOpc == 4 //Elimina Residuo
		_nPsCanc   := aScan(aHeader, {|x| AllTrim(x[2]) == "ZN_FLAGCAN"})
		_nPsOBS    := aScan(aHeader, {|x| AllTrim(x[2]) == "ZN_OBS"})

		If aCols[i][_nPsCanc] == 'S' //Cancela Item
			If Empty(aCols[i][_nPsOBS])
				nObs1++
			EndIf
		EndIf
	EndIf
Next

If nObs1 > 0
	MsgStop(OemToAnsi("Existem itens sem Observa��o!!!"), cTitulo)
	lRet1 := .F.
	Return lRet1
EndIf

If nQtde > 0
	MsgStop(OemToAnsi("Existem itens sem Observa��o!!!"), cTitulo)
	lRet1 := .F.
	Return lRet1
/*
	If MsgYesNo(OemToAnsi("Existem itens sem Quantidade de Entrega"+CHR(13) + CHR(10)+"Deseja continuar?"), OemToAnsi("Requisi��o de Material"))
		lRet1 := .T.
	Else
		lRet1 := .F.
	EndIf
*/
EndIf

//VALIDACAO DE CR
//ALTERADO PELO EMERSON DIA 03/09/10
_xArea	:= GetArea()
DbSelectArea("CTT")
DbSetOrder(1)
If !DbSeek(xFilial("CTT")+alltrim(cCR),.F.)
	msgbox(OemToAnsi("CR n�o cadastrado!!! "+alltrim(cCR)+" Verificar com a Contabilidade"))
	lRet1 := .F.
EndIf
RestArea(_xArea)

Return lRet1


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CESTA09   �Autor  �Microsiga           � Data �  08/22/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function AllwaysTrue(nOpc)

_nPsQtde   := aScan(aHeader, {|x| AllTrim(x[2]) == "ZN_QTDE"})

If aCols[n][_nPsQtde] == 0
	MsgAlert("Qt. nao pode ser zero.", "Aten�ao!")
	Return .F.
EndIf

Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CESTA09   �Autor  �Emerson Natali      � Data �  21/08/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function LEGREQ()

_aLeg := {	{"BR_VERDE"		, "Em Aberto"	},;
			{"BR_AZUL"    	, "Encerrada"	},;
			{"BR_AMARELO"	, "Pendente"	},;
			{"BR_CANCEL"	, "Cancelada"	}}

BrwLegenda(cCadastro, "Legenda", _aLeg)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CESTA09   �Autor  �Microsiga           � Data �  09/04/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Validacao para nao digitar a Quantidade Entrega maior que  ���
���          � saldo disponivel                                           ���
�������������������������������������������������������������������������͹��
���Uso       � CIEE                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function fValQtde()

lRet := .T.

_nPsSlEst  := aScan(aHeader, {|x| AllTrim(x[2]) == "ZN_SLDEST"})

If M->ZN_QTDE > aCols[n,_nPsSlEst]
	msgbox("Quantidade maior que o Disponivel em Estoque!!!")
	lRet := .F.
	Return(lRet)
EndIf

_nPsSaldo  := aScan(aHeader, {|x| AllTrim(x[2]) == "ZN_SALDO"})

If M->ZN_QTDE > aCols[n,_nPsSaldo]
	msgbox("Quantidade maior que o Saldo Disponivel p/ Entrega!!!")
	lRet := .F.
	Return(lRet)
EndIf

Return(lRet)

/*
---------------------------------------------------------------------------------------------------------------
*/


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO2     � Autor � AP6 IDE            � Data �  11/10/06   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function CARGA_REQMAT()

Private oLeTxt

dbSelectArea("SZN")
dbSetOrder(1)

Processa({|| RunCont() },"Processando...")

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � RUNCONT  � Autor � AP5 IDE            � Data �  11/10/06   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunCont

Local nTamFile, nTamLin, cBuffer, nBtLidos

//���������������������������������������������������������������������Ŀ
//� Abertura do arquivo texto                                           �
//�����������������������������������������������������������������������

If cEmpant == '01' //SP
	cDirect    := "\arq_txt\almoxarifado\ReqMaterial\" 
	cDirectImp := "\arq_txt\almoxarifado\ReqMaterial\Backup\"
ElseIf cEmpant == '03' //RJ
	cDirect    := "\arq_txtrj\almoxarifado\ReqMaterial\"
	cDirectImp := "\arq_txtrj\almoxarifado\ReqMaterial\Backup\"
EndIf
aDirect    := Directory(cDirect+"*.TXT")

_cLocali 	:= ""
_cKitLan 	:= ""

For _nIx := 1 to Len(adirect)
	FT_FUSE(cDirect+adirect[_nIx,1])
	FT_FGOTOP()
	ProcRegua(FT_FLASTREC())

	While !FT_FEOF()

		IncProc("Processando Leitura do Arquivo Texto...")
		cBuffer  := Alltrim(FT_FREADLN())
		_cNumReq :=	Substr(cBuffer,1,(At(";",cBuffer)-1))

		cBuffer	 :=	Substr(cBuffer,(At(";",cBuffer)+1),500)
		_cUseReq :=	Substr(cBuffer,1,(At(";",cBuffer)-1))

		cBuffer	 :=	Substr(cBuffer,(At(";",cBuffer)+1),500)
		_cEmail  :=	Substr(cBuffer,1,(At(";",cBuffer)-1))

		cBuffer	 :=	Substr(cBuffer,(At(";",cBuffer)+1),500)
		_cCR     :=	Substr(cBuffer,1,(At(";",cBuffer)-1))

		cBuffer	 :=	Substr(cBuffer,(At(";",cBuffer)+1),500)
		_cDesUnid:=	Substr(cBuffer,1,(At(";",cBuffer)-1))

		cBuffer	 :=	Substr(cBuffer,(At(";",cBuffer)+1),500)
		_cRamal  :=	Substr(cBuffer,1,(At(";",cBuffer)-1))

		cBuffer	 :=	Substr(cBuffer,(At(";",cBuffer)+1),500)
		_cData   :=	Substr(cBuffer,1,(At(";",cBuffer)-1))

		cBuffer	 :=	Substr(cBuffer,(At(";",cBuffer)+1),500)
		_cEmail2 :=	Substr(cBuffer,1,(At(";",cBuffer)-1))

		cBuffer	 :=	Substr(cBuffer,(At(";",cBuffer)+1),500)
		_cCod    :=	Substr(cBuffer,1,(At(";",cBuffer)-1))

		cBuffer	:=	Substr(cBuffer,(At(";",cBuffer)+1),500)
		_cDescr :=	Substr(cBuffer,1,(At(";",cBuffer)-1))

		cBuffer	:=	Substr(cBuffer,(At(";",cBuffer)+1),500)
		_cUM    :=	Substr(cBuffer,1,(At(";",cBuffer)-1))

		cBuffer	:=	Substr(cBuffer,(At(";",cBuffer)+1),500)
		_cQuant :=	Substr(cBuffer,1,(At(";",cBuffer)-1))

		cBuffer	 :=	Substr(cBuffer,(At(";",cBuffer)+1),500)
		_cSaldo  :=	Alltrim(cBuffer)

		dbSelectArea("CTT")
		dbSetOrder()
		If DbSeek(xFilial("CTT")+_cCR,.F.)
			Do Case
				Case CTT->CTT_LOCALI == "1"
					_cLocali := "SEDE"
				Case CTT->CTT_LOCALI == "2"
					_cLocali := "UNIDADE"
				Case CTT->CTT_LOCALI == "3"
					_cLocali := "NAO GERA"
			EndCase

			Do Case
				Case CTT->CTT_KITLAN == "1"
					_cKitLan := "CR01"
				Case CTT->CTT_KITLAN == "2"
					_cKitLan := "CR02"
			EndCase

		EndIf

		dbSelectArea("SZN")
		dbSetOrder(1) //FILIAL + REQUISICAO + PRODUTO
		If !DbSeek(xFilial("SZN")+_cNumReq+_cCod)
			RecLock("SZN",.T.)
			SZN->ZN_FILIAL   := xFilial("SZN")
			SZN->ZN_NUMSOC   := _cNumReq
			SZN->ZN_USEREQ   := _cUseReq
			SZN->ZN_EMAIL    := _cEmail
			SZN->ZN_CR       := _cCR
			SZN->ZN_DESCCR   := _cDesUnid
			SZN->ZN_RAMAL    := _cRamal
			SZN->ZN_DATA     := ctod(_cData)
			SZN->ZN_EMAIL2   := _cEmail2
			SZN->ZN_COD      := _cCod
			SZN->ZN_DESCR    := _cDescr
			SZN->ZN_UM       := _cUM
			SZN->ZN_QUANT    := val(_cQuant)
			SZN->ZN_SALDO    := val(_cSaldo)
			SZN->ZN_LOCALI   := _cLocali
			SZN->ZN_KITLAN   := _cKitLan
			MSUnLock()
		EndIf
		FT_FSKIP()
	EndDo
	
	FT_FUSE()

Next _nIx

//Copia e Deleta o arquivo da pasta Origem para a pasta Importado. De qualquer Banco
For _nIy := 1 to Len(adirect)
	__copyfile(cDirect+adirect[_nIy,1],cDirectImp+adirect[_nIy,1])
	ferase(cDirect+adirect[_nIy,1])
Next

Return