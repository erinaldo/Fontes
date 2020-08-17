#INCLUDE "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PROR0001 º Autor ³ Totvs              º Data ³  11/02/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Cadastro de inventario do Ativo via coletor.               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Prodam                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function PROR0001

Private aCores   := {}
Private cCadastro := "Cadastro de Inventário via Coletor"
Private aRotina := {}
Private cString := "SZA"

aRotina := {;
{"Pesquisar","AxPesqui",0,1},;
{"Visualizar","AxVisual",0,2},;
{"Import. Arq. Inventariados","U_ProR01Arq",0,3},;
{"Import. Arq. Não Inventariados","U_ProR01NArq",0,3},;
{"Transferência Local","U_ProR01Loc",0,4},;
{"Deletar toda Importação","U_ProR01Del",0,5},;
{"Deletar apenas Bem posicionado","U_ProR01CDel",0,5},;
{"Gerar Arquivo p/ Inventario","U_ProR01IArq",0,3},;
{"Relatório da Importação","U_ProR01Imp",0,2},;
{"Gerar Inventário","U_ProR01Inv",0,4},;
{"Legenda","U_ProR01Leg",0,3,0,.F.}}

// deixar no array acores a seguinte prioridade dos campos
//ZA_INVENT / ZA_STATPRO / ZA_STATIMP   
aCores := {;
{"ZA_INVENT=='S'","BR_PRETO"},;
{"ZA_STATPRO=='1'","BR_BRANCO"},;
{"ZA_STATPRO=='2'","BR_LARANJA"},;
{"ZA_STATPRO=='3'","BR_AMARELO"},;
{"ZA_STATPRO=='4'","DISABLE"},;
{"ZA_STATIMP=='1'","BR_AZUL"},;
{"ZA_STATIMP=='2'","BR_PINK"},;
{"ZA_STATIMP=='3'","ENABLE"}}

dbSelectArea(cString)
dbSetOrder(1)

dbSelectArea(cString)
mBrowse(6,1,22,75,cString,,,,,,aCores)

Return


User Function ProR01Arq

Local oProcess  := NIL
Local cPathIni := "C:\" //GetSrvProfString("RootPath", "")+GetSrvProfString("Startpath", "")

Private cFile := cGetFile("Arquivo CSV | *.csv","Selecione o arquivo CSV",,cPathIni,.T.,GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE )

If !Empty(cFile)
	oProcess := MsNewProcess():New( { | lEnd | xImpCSV(@lEnd,oProcess,"1") }, 'Processando', 'Aguarde, processando...', .F. )
	oProcess:Activate()
Else
	Help(" ",1,"NOFILE")
Endif

Return


User Function ProR01NArq

Local oProcess  := NIL
Local cPathIni := "C:\" //GetSrvProfString("RootPath", "")+GetSrvProfString("Startpath", "")
Local cPerg := "PROR01NINV"

Private cFile := ""

ValidPerg(cPerg)
If Pergunte(cPerg,.T.)
	If Empty(mv_par01) // para importacao do arquivo de bens nao inventariados, o usuario precisa informar
	// a data do inventario, para a rotina poder localizar o codigo do inventario jah importado anteriormente
	// e preservar o mesmo codigo.
		MsgStop("Parâmetro de 'Data do Inventário' deve obrigatoriamente ser informado. Verifique!.")
		
		Return()
	Endif
		
	cFile := cGetFile("Arquivo CSV | *.csv","Selecione o arquivo CSV",,cPathIni,.T.,GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE )
	If !Empty(cFile)
		oProcess := MsNewProcess():New( { | lEnd | xImpCSV(@lEnd,oProcess,"2") }, 'Processando', 'Aguarde, processando...', .F. )
		oProcess:Activate()
	Else
		Help(" ",1,"NOFILE")
	Endif	
Endif

Return


Static Function xImpCSV(lEnd,oProcess,cTipo)

Local nX,nY
Local cLin		:=	""
Local aCampo	:= {}
Local aEstrut	:= {}
Local aTXT		:= {}
Local aPosCampos:= {}
Local cAliasTrb	:= GetNextAlias()
Local cArqTmp	:= ""
Local cChave	:= ""
Local dData := cTod("")
Local cCodigo := ""
Local cAliasTmp := GetNextAlias()

If cTipo == "2"
	// verifica inventario importado anteriormente, para carregar o codigo do inventario
	SZA->(dbSetOrder(3))
	If SZA->(!dbSeek(xFilial("SZA")+dTos(mv_par01)))
		MsgStop("Não foi localizado o inventário importado anteriormente, para se carregar o código do Inventário."+CRLF+;
		"Deve-se importar primeiro o arquivo de bens inventariados e em seguida o arquivo de bens não inventariados.")
		
		Return()
	Else
		cCodigo := SZA->ZA_COD	
	Endif
Endif		

aEstrut := {;
{ "EMISSAO" 	, "D", 	 8, 0 },;
{ "COD_BARRA"	, "C",  20, 0 },;
{ "DESCR"		, "C", 100, 0 },;
{ "LOCSN1"		, "C",   6, 0 },;
{ "LOCAL"		, "C",   6, 0 },;
{ "STATPRO"		, "C",   1, 0 }}

cArqTmp := CriaTrab(aEstrut, .T.)
dbUseArea( .T.,, cArqTmp, cAliasTrb, .F., .F. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Indice Temporario do Arquivo de Trabalho 1.             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cChave   := "DTOS(EMISSAO)+COD_BARRA"

IndRegua(cAliasTrb,cArqTmp,cChave,,,"Selecionando Registros...")
dbSelectArea(cAliasTrb)
dbSetIndex(cArqTmp+OrdBagExt())
dbSetOrder(1)

If cTipo == "1"
	// estrutura do arquivo texto dos bens inventariados
	aAdd(aCampo,"CÓDIGO DO BP")
	aAdd(aCampo,"DESCRIÇÃO DO BP")
	aAdd(aCampo,"NUMERO DE SÉRIE")
	aAdd(aCampo,"CENTRO DE CUSTO ANTERIOR")
	aAdd(aCampo,"CENTRO DE CUSTO ATUAL")
	aAdd(aCampo,"DESCRIÇÃ DO CENTRO DE CUSTO")
	aAdd(aCampo,"SECRETARIA")
	aAdd(aCampo,"LOCAL")
	aAdd(aCampo,"CEP")
	aAdd(aCampo,"RESPONSÁVEL")
	aAdd(aCampo,"NOME")
	aAdd(aCampo,"TELEFONE")
	aAdd(aCampo,"CONSERVAÇÃO")
	aAdd(aCampo,"DATA")
Elseif cTipo == "2"
	// estrutura do arquivo texto dos bens nao inventariados
	aAdd(aCampo,"CÓDIGO DO BP")
	aAdd(aCampo,"DESCRIÇÃO DO BP")
	aAdd(aCampo,"CENTRO DE CUSTO")
	aAdd(aCampo,"NUMERO DE SÉRIE")
Endif

//Define o valor do array conforme estrutura
aPosCampos:= Array(Len(aCampo))

If (nHandle := FT_FUse(AllTrim(cFile)))== -1
	Help(" ",1,"NOFILEIMPOR")
	(cAliasTrb)->(dbCloseArea())
	
	Return()
EndIf

//Verifica Estrutura do Arquivo
FT_FGOTOP()
cLinha := FT_FREADLN()
nPos	:=	0
nAt	:=	1

While nAt > 0
	nPos++
	nAt	:=	AT(";",cLinha)
	If nAt == 0
		cCampo := cLinha
	Else
		cCampo	:=	Substr(cLinha,1,nAt-1)
	Endif
	nPosCpo	:=	Ascan(aCampo,{|x| Alltrim(Upper(x))==Alltrim(Upper(cCampo))})
	If nPosCPO > 0
		aPosCampos[nPosCpo]:= nPos
	Endif
	cLinha	:=	Substr(cLinha,nAt+1)
Enddo

If (nPosNil:= Ascan(aPosCampos,Nil)) > 0
	Aviso("Estrutura de arquivo inválido.","O campo "+aCampo[nPosNil]+" nao foi encontrado na estrutura, verifique.",{"Sair"})
	Return .F.
Endif

// Inicia Importacao das Linhas
FT_FSKIP()
While !FT_FEOF()
	cLinha := FT_FREADLN()
	AADD(aTxt,{})
	nCampo := 1
	While At(";",cLinha)>0
		aAdd(aTxt[Len(aTxt)],Substr(cLinha,1,At(";",cLinha)-1))
		nCampo ++
		cLinha := StrTran(Substr(cLinha,At(";",cLinha)+1,Len(cLinha)-At(";",cLinha)),'"','')
	End
	If Len(AllTrim(cLinha)) > 0
		aAdd(aTxt[Len(aTxt)],StrTran(Substr(cLinha,1,Len(cLinha)),'"','') )
	Else
		aAdd(aTxt[Len(aTxt)],"")
	Endif
	FT_FSKIP()
End

// Gravacao dos Itens (TRB)
FT_FUSE()
For nX:=1 To Len(aTxt)
	For nY:=1 To Len(aCampo)
		dbSelectArea(cAliastrb)
		RecLock(cAliasTrb,.T.)
		For nY:=1 To Len(aCampo)
			If cTipo == "1"
				If AllTrim(aCampo[nY]) == "CÓDIGO DO BP"
					FieldPut(FieldPos("COD_BARRA"),aTxt[nX,aPosCampos[nY]])
				ElseIf AllTrim(aCampo[nY]) == "DESCRIÇÃO DO BP"
					FieldPut(FieldPos("DESCR"),aTxt[nX,aPosCampos[nY]])
				ElseIf AllTrim(aCampo[nY]) == "CENTRO DE CUSTO ANTERIOR"
					FieldPut(FieldPos("LOCSN1"),aTxt[nX,aPosCampos[nY]])
				ElseIf AllTrim(aCampo[nY]) == "CENTRO DE CUSTO ATUAL"
					FieldPut(FieldPos("LOCAL"),aTxt[nX,aPosCampos[nY]])
				ElseIf AllTrim(aCampo[nY]) == "DATA"
					ddata := cTod(Subs(aTxt[nX,aPosCampos[nY]],1,2)+"/"+Subs(aTxt[nX,aPosCampos[nY]],3,2)+"/"+Subs(aTxt[nX,aPosCampos[nY]],5,4))
					FieldPut(FieldPos("EMISSAO"),ddata)
				ElseIf AllTrim(aCampo[nY]) == "CONSERVAÇÃO" .and. aTxt[nX,aPosCampos[nY]] == "4" // bem descartado no arquivo do coletor, vem com 4
					FieldPut(FieldPos("STATPRO"),"4") // "4" eh o conteudo que deve ser gravado no campo ZA_STATPRO, referente ao status de bem descartado
				Endif
			Elseif cTipo == "2" 
				If AllTrim(aCampo[nY]) == "CÓDIGO DO BP"
					FieldPut(FieldPos("COD_BARRA"),aTxt[nX,aPosCampos[nY]])
				ElseIf AllTrim(aCampo[nY]) == "DESCRIÇÃO DO BP"
					FieldPut(FieldPos("DESCR"),aTxt[nX,aPosCampos[nY]])
				ElseIf AllTrim(aCampo[nY]) == "CENTRO DE CUSTO"
					FieldPut(FieldPos("LOCSN1"),aTxt[nX,aPosCampos[nY]])
				Endif	
			Endif
		Next
		If cTipo == "2" // para importacao do arquivo de bens nao inventariados, grava status "3"=nao encontrado
			FieldPut(FieldPos("STATPRO"),"3")
			FieldPut(FieldPos("EMISSAO"),mv_par01)
		Endif	
		MsUnLock()
	Next
Next

dbSelectArea(cAliasTrb)
dbGotop()

// grava na tabela SZA o inventario coletado via coletor de dados
If xAtuSZA(cAliasTrb,oProcess,@cCodigo,cAliasTmp,cTipo)
	If cTipo == "1"
		// grava na tabela SZA os bens nao inventariados
		SN1NInvent(dData,cCodigo,cAliasTmp)
	Endif	
Endif	

If Select(cAliasTrb) != 0
	dbSelectArea(cAliasTrb)
	dbCloseArea()
	FErase(cArqTmp+GetDBExtension())
	FErase(cArqTmp+OrdBagExt())
Endif

Aviso("Importação de Arquivo","Processo finalizado.",{"OK"})

Return


Static Function xAtuSZA(cAliastrb,oProcess,cCodigo,cAliasTmp,cTipo)

Local aEstrut	:= {}
//Local cAliasTmp := GetNextAlias()
Local cArqTmp	:= ""
Local cChave	:= ""
Local lErro		:= .F.
Local lGrava	:= .T.
Local cDescBem	:= ""
Local nTotRegs 	:= 0
Local nProcRegs := 0
Local cStatus 	:= ""
Local lTemErro 	:= .F.
Local cMsg 		:= ""

aEstrut :={;
{ "EMISSAO" 	, "D", 	 8, 0 },;
{ "COD_BARRA"	, "C",  20, 0 },;
{ "DESCR"		, "C",  30, 0 },;
{ "CONTEUDO"	, "C",  20, 0 },;
{ "MSG"			, "C", 100, 0 }}

cArqTmp := CriaTrab(aEstrut, .T.)
dbUseArea( .T.,, cArqTmp, cAliasTmp, .F., .F. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Indice Temporario do Arquivo de Trabalho.               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cChave   := "DTOS(EMISSAO)+COD_BARRA"

IndRegua(cAliasTmp,cArqTmp,cChave,,,"Criando Arquivo Temporário...")
dbSelectArea(cAliasTmp)
dbSetIndex(cArqTmp+OrdBagExt())
dbSetOrder(1)

dbSelectArea(cAliasTrb)

dbEval( {|x| nTotRegs++ },,{|| (cAliasTrb)->(!EOF())})
oProcess:SetRegua1(nTotRegs+2)
oProcess:IncRegua1("Iniciando processamento...")
oProcess:SetRegua2(nTotRegs+1)
oProcess:IncRegua2("")

Begin Transaction 

If cTipo == "1"
	cCodigo := CriaVar("ZA_COD")
	If __lSX8
		ConfirmSX8()
	EndIf
Endif	

// Processa o Arquivo e Grava
dbSelectArea(cAliasTrb)
dbGotop()
While (cAliasTrb)->(!Eof())
	If cTipo == "1"
		// valida se ativo jah foi importado
		SZA->(dbSetOrder(3))// ZA_FILIAL+ZA_DATA+ZA_CHAPA
		If SZA->(dbSeek(xFilial("SZA")+Dtos((cAliasTrb)->EMISSAO)+(cAliastrb)->COD_BARRA))
			MsgStop("Já existe informação para a data de "+Dtoc((cAliasTrb)->EMISSAO)+", Chapa "+(cAliastrb)->COD_BARRA+". Verifique!")
			DisarmTransaction()
			
			Return(.F.)
		Endif

		//Valida Localizacao
		SNL->(dbSetOrder(1))
		If !Empty((cAliasTrb)->LOCSN1) .and. SNL->(!dbSeek(xFilial("SNL")+(cAliasTrb)->LOCSN1))
			lErro := .T.
			//lGrava 	:= .F.
			dbSelectArea(cAliasTmp)
			RecLock(cAliasTmp,.T.)
			(cAliasTmp)->EMISSAO 	:= (cAliastrb)->EMISSAO
			(cAliasTmp)->COD_BARRA 	:= (cAliasTrb)->COD_BARRA
			(cAliasTmp)->DESCR		:= cDescBem
			(cAliasTmp)->CONTEUDO 	:= (cAliasTrb)->LOCSN1
			(cAliasTmp)->MSG	 	:= "Localização Atual (SN1) "+Alltrim((cAliasTrb)->LOCSN1)+" não localizada na base de dados."
			MsUnlock()
			cMsg := cMsg+IIf(Empty(cMsg),""," / ")+Alltrim((cAliasTmp)->MSG)
		Endif
	
		If !Empty((cAliasTrb)->LOCAL) .and. SNL->(!dbSeek(xFilial("SNL")+(cAliasTrb)->LOCAL))
			lErro := .T.
			//lGrava 	:= .F.
			dbSelectArea(cAliasTmp)
			RecLock(cAliasTmp,.T.)
			(cAliasTmp)->EMISSAO 	:= (cAliastrb)->EMISSAO
			(cAliasTmp)->COD_BARRA 	:= (cAliasTrb)->COD_BARRA
			(cAliasTmp)->DESCR		:= cDescBem
			(cAliasTmp)->CONTEUDO 	:= (cAliasTrb)->LOCAL
			(cAliasTmp)->MSG	 	:= "Localização Destino (Coletor) "+Alltrim((cAliasTrb)->LOCAL)+" não localizada na base de dados."
			MsUnlock()
			cMsg := cMsg+IIf(Empty(cMsg),""," / ")+Alltrim((cAliasTmp)->MSG)
		Endif
	Elseif cTipo == "2"
		// se o bem jah existir na SZA, nao importa novamente
		SZA->(dbSetOrder(3))// ZA_FILIAL+ZA_DATA+ZA_CHAPA
		If SZA->(dbSeek(xFilial("SZA")+Dtos((cAliasTrb)->EMISSAO)+(cAliastrb)->COD_BARRA))
			dbSelectArea(cAliasTrb)
			dbSkip()
			Loop
		Endif	
	Endif

	// valida chapa
	SN1->(dbSetOrder(2))
	If SN1->(!dbSeek(xFilial("SN1")+(cAliasTrb)->COD_BARRA))
		lErro := .T.
		//lGrava 	:= .F.
		cStatus := "2"
		dbSelectArea(cAliasTmp)
		RecLock(cAliasTmp,.T.)
		(cAliasTmp)->EMISSAO 	:= (cAliastrb)->EMISSAO
		(cAliasTmp)->COD_BARRA 	:= (cAliasTrb)->COD_BARRA
		(cAliasTmp)->DESCR		:= (cAliasTrb)->DESCR
		(cAliasTmp)->CONTEUDO 	:= (cAliasTrb)->COD_BARRA
		(cAliasTmp)->MSG	 	:= "Chapa "+Alltrim((cAliasTrb)->COD_BARRA)+" não cadastrada na base de dados."
		cMsg := cMsg+IIf(Empty(cMsg),""," / ")+Alltrim((cAliasTmp)->MSG)
		MsUnlock()
		cDescBem := (cAliasTrb)->DESCR
	Else
		cDescBem := SN1->N1_DESCRIC
		cStatus := "3"
	Endif	
	
	//If lGrava
		GrvSZA({xFilial("SZA"),cCodigo,cDescBem,(cAliasTrb)->EMISSAO,(cAliasTrb)->COD_BARRA,(cAliasTrb)->LOCSN1,;
		(cAliasTrb)->LOCAL,cStatus,IIf(lErro,cMsg,""),dDataBase,IIf(SN1->(Found()),SN1->N1_CBASE,""),;
		IIf(SN1->(Found()),SN1->N1_ITEM,""),(cAliasTrb)->STATPRO})
		
		nProcRegs++
		oProcess:IncRegua2("Codigo de Barra: "+(cAliasTrb)->COD_BARRA)
	//Endif
	
	oProcess:IncRegua1("Processando item: "+CValToChar(nProcRegs)+" / "+CValToChar(nTotRegs))
	
	dbSelectArea(cAliasTrb)
	dbSkip()
	
	If lErro .and. !lTemErro
		lTemErro := .T.
	Endif
		
	lGrava := .T.
	lErro := .F.
	cStatus := ""
	cMsg := ""
	cDescBem := ""
Enddo

End Transaction 

/*
If lTemErro
	//Chama Impressao do Relatorio de Inconsistencias
	If ApMsgYesNo("Ocorreram inconsistências durante a importação dos dados, deseja imprimir o log?","Log de Inconsistências")
		xRelInc(cAliasTmp,"Inconsistências da Importação")
	Endif
Endif
*/

Return(.T.)


Static Function SN1NInvent(dData,cCodigo,cAliasTmp) 

Local oProcess  := NIL

oProcess := MsNewProcess():New( { | lEnd | xSN1NInvent( @lEnd,oProcess,dData,cCodigo,cAliasTmp) }, 'Processando bens nao inventariados', 'Aguarde, processando...', .F. )
oProcess:Activate()
		
Return()


Static Function xSN1NInvent(lEnd,oProcess,dData,cCodigo,cAliasTmp)

Local cQ := ""
Local cAliasTrb := GetNextAlias()
Local nProcRegs	  := 0
Local nTotRegs	  := 0
		
cQ := "SELECT SN1.R_E_C_N_O_ AS RECNO_SN1 "
cQ += "FROM "+RetSqlName("SN1")+" SN1 "
cQ += "WHERE N1_FILIAL = '"+xFilial("SN1")+"' "
cQ += "AND N1_BAIXA = ' ' "
cQ += "AND N1_STATUS != '0' " // pendente de classificacao
cQ += "AND SN1.D_E_L_E_T_ = ' ' "
cQ += "AND NOT EXISTS "
cQ += "(SELECT 1 "
cQ += "FROM "+RetSqlName("SZA")+" SZA "
cQ += "WHERE ZA_FILIAL = '"+xFilial("SZA")+"' "
cQ += "AND ZA_COD = '"+cCodigo+"' "
cQ += "AND ZA_DATA = '"+dTos(dData)+"' "
cQ += "AND ZA_CHAPA = N1_CHAPA "
cQ += "AND SZA.D_E_L_E_T_ = ' ') "

cQ := ChangeQuery(cQ)

If Select(cAliasTrb) > 0
	dbSelectArea(cAliasTrb)
	dbCloseArea()
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.T.,.F.)

dbEval( {|x| nTotRegs++ },,{|| (cAliasTrb)->(!EOF())})
oProcess:SetRegua1(nTotRegs+2)
oProcess:IncRegua1("Iniciando processamento...")
oProcess:SetRegua2(nTotRegs+1)
oProcess:IncRegua2("")

dbGotop()

While (cAliasTrb)->(!Eof())
	SN1->(dbGoto((cAliasTrb)->RECNO_SN1))
	If SN1->(Recno()) == (cAliasTrb)->RECNO_SN1
		GrvSZA({xFilial("SZA"),cCodigo,SN1->N1_DESCRIC,dData,SN1->N1_CHAPA,SN1->N1_LOCAL,;
		"","1","Chapa "+Alltrim(SN1->N1_CHAPA)+" não cadastrada no inventário.",dDataBase,SN1->N1_CBASE,;
		SN1->N1_ITEM,""})
		
		(cAliasTmp)->(RecLock(cAliasTmp,.T.))
		(cAliasTmp)->EMISSAO 	:= dData
		(cAliasTmp)->COD_BARRA 	:= SN1->N1_CHAPA
		(cAliasTmp)->DESCR		:= SN1->N1_DESCRIC
		(cAliasTmp)->CONTEUDO 	:= SN1->N1_CHAPA
		(cAliasTmp)->MSG	 	:= "Chapa "+Alltrim(SN1->N1_CHAPA)+" não cadastrada no inventário."
		(cAliasTmp)->(MsUnlock())

		nProcRegs++
		oProcess:IncRegua1("Processando item: "+CValToChar(nProcRegs)+" / "+CValToChar(nTotRegs))
		oProcess:IncRegua2("Codigo de Barra: "+SN1->N1_CHAPA)
	Endif	

	(cAliasTrb)->(dbSkip())
Enddo	

(cAliasTrb)->(dbCloseArea())

Return()


Static Function GrvSZA(aMat)

dbSelectArea("SZA")
RecLock("SZA",.T.)
SZA->ZA_FILIAL 	:= aMat[1]
SZA->ZA_COD		:= aMat[2]
SZA->ZA_DESC	:= aMat[3]
SZA->ZA_DATA	:= aMat[4]
SZA->ZA_CHAPA 	:= aMat[5]
SZA->ZA_LOCSN1	:= aMat[6]
SZA->ZA_LOCAL	:= aMat[7]
SZA->ZA_STATIMP	:= aMat[8]
SZA->ZA_MSG		:= aMat[9]
SZA->ZA_EMISSAO	:= aMat[10]
SZA->ZA_CBASE  	:= aMat[11]
SZA->ZA_ITEM  	:= aMat[12]
SZA->ZA_STATPRO	:= aMat[13]
// tratamento para jah gravar o registro como processado, nos casos de :
// bens sem inconsistencia, encontrados no inventario e (bens descartados ou local origem/destino igual)
If Empty(SZA->ZA_MSG) .and. SZA->ZA_STATIMP == "3" .and. (SZA->ZA_STATPRO == "4" .or. (SZA->ZA_LOCSN1 == SZA->ZA_LOCAL))
	SZA->ZA_PROCESS := "S"
	// gravacao da legenda Local OK, quando nao ocorre troca de locais entre a origem e o destino
	If SZA->ZA_LOCSN1 == SZA->ZA_LOCAL
		SZA->ZA_STATPRO := "1"
	Endif			
Endif	  

MsUnlock()

Return()


User Function ProR01Del

Local cPerg := "PROR01DEL"
Local nRet := 0
Local cQuery := ""
Local cAliasTMP1 := GetNextAlias()

ValidPerg(cPerg)
If Pergunte(cPerg,.T.)
	
	cQuery := "SELECT 1 "
	cQuery += "FROM "+RetSqlName("SZA")+" "
	cQuery += "WHERE D_E_L_E_T_ = ' ' "
	cQuery += "AND ZA_FILIAL = '"+xFilial("SZA")+"' "
	cQuery += "AND ZA_DATA BETWEEN '"+dTos(mv_par01)+"' AND '"+dTos(mv_par02)+"' "
	cQuery += "AND ZA_CHAPA BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "
	cQuery += "AND ZA_INVENT = 'S' "
	cQuery := ChangeQuery(cQuery)

	If Select(cAliasTMP1) > 0
		dbSelectArea(cAliasTMP1)
		dbCloseArea()
	Endif
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTMP1,.T.,.F.)
	
	DbSelectArea(cAliasTMP1)
	dbGotop()
	
	If !Eof()
		If Select(cAliasTMP1) > 0
			dbSelectArea(cAliasTMP1)
			dbCloseArea()
		Endif
		MsgStop("Existem registros que já geraram dados para o Inventário. Importação não poderá ser excluída.")
		
		Return ()
	Endif

	If Select(cAliasTMP1) > 0
		dbSelectArea(cAliasTMP1)
		dbCloseArea()
	Endif
	
	If MsgYesNo("Confirma deleção dos registros?","Confirma estorno? Sim/Não")
		/*
		dbSelectArea("SZA")
		dbSetOrder(3)
		dbGotop()
		dbSeek(xFilial("SZA")+DTOS(MV_PAR01),.T.)
		
		While !Eof() .and. SZA->ZA_FILIAL == xFilial("SZA") .AND. SZA->ZA_DATA <= MV_PAR02
			RecLock("SZA",.F.)
			dbDelete()
			MsUnlock()
			dbSkip()
		EndDo
		*/
		nRet := tcSqlExec("DELETE FROM "+RetSqlName("SZA")+" WHERE D_E_L_E_T_ = ' ' AND ZA_FILIAL = '"+xFilial("SZA")+"' AND ZA_DATA BETWEEN '"+dTos(mv_par01)+"' AND '"+dTos(mv_par02)+"' AND ZA_CHAPA BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' ")
	    If nRet < 0
	    	MsgStop("Erro na exclusão dos dados."+CRLF+tcSqlError()+tcSqlError())
	    Endif                                                                                                                     
	Endif
Endif

Return


User Function ProR01CDel()

If SZA->ZA_INVENT == "S"
	MsgStop("Este registro já gerou dados para o Inventário. O registro não poderá ser excluído.")
	
	Return()
Endif	

If MsgYesNo("Confirma deleção do registro atual?","Confirma estorno? Sim/Não")
	dbSelectArea("SZA")
	RecLock("SZA",.F.)
	dbDelete()
	MsUnLock()
Endif

Return


// Relatorio de Inconsistencias (Importacao e Transferencia)
Static Function xRelInc(_cAlias,_cTitulo)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := _cTitulo
Local cPict       	:= ""
Local titulo       	:= _cTitulo
Local nLin         	:= 80
Local Cabec1       	:= "Emissão    Cod. Barra           Descrição                      Conteúdo            Mensagem"
//1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789123456789123456789123456789
//0        1         2         3         4         5         6         7         8         9         1
Local Cabec2       	:= ""
Local imprime      	:= .T.
Local aOrd 			:= {}

Private lEnd      	:= .F.
Private lAbortPrint	:= .F.
Private CbTxt     	:= ""
Private limite   	:= 132
Private tamanho  	:= "M"
Private nomeprog 	:= "PROR0001"
Private nTipo     	:= 18
Private aReturn  	:= { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey	:= 0
Private cbtxt      	:= Space(10)
Private cbcont     	:= 00
Private CONTFL     	:= 01
Private m_pag      	:= 01
Private wnrel      	:= "PROR0001"
Private cString		:= _cAlias

dbSelectArea(cString)
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return


Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem                                  
Local nTamLin := 50
Local lFirst := .T.

dbSelectArea(cString)
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(RecCount())

dbGoTop()
While !EOF()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o cancelamento pelo usuario...                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do cabecalho do relatorio. . .                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	@nLin,000 PSAY Dtoc((cString)->EMISSAO)
	@nLin,011 PSAY (cString)->COD_BARRA
	@nLin,032 PSAY (cString)->DESCR
	//@nLin,063 PSAY (cString)->CONTEUDO
	//@nLin,085 PSAY (cString)->MSG

    cAux1:= Dtoc((cString)->EMISSAO)
    cAux2:= (cString)->COD_BARRA
    cAux3:= (cString)->DESCR
    cAux4:= (cString)->CONTEUDO
    
    lFirst := .T.
    While cAux1 == Dtoc((cString)->EMISSAO) .And.;
		cAux2 == (cString)->COD_BARRA .and. ;
		cAux3 == (cString)->DESCR

		//cAux4 := (cString)->CONTEUDO
			
		//If lFirst
			@nLin,063 PSAY (cString)->CONTEUDO
			@nLin,085 PSAY (cString)->MSG
			lFirst := .F.
		//Else
		//	@nLin,063+1 PSAY (cString)->CONTEUDO
		//	@nLin,084+1 PSAY (cString)->MSG
		//Endif				    
		nLin := nLin + 1 // Avanca a linha de impressao
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif

		IncRegua()
		dbSkip()
     End
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return


// Relatorio de Importacao
User Function ProR01Imp()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := "Importação do arquivo do coletor"
Local cPict       	:= ""
Local titulo       	:= "Importação do arquivo do coletor"
Local nLin         	:= 80
                      //0         1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1         2
                      //01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Local Cabec1       	:= "Emissão    Cod.Inv.  Cod. Barra  Cod. Bem   Item Bem  Descrição Bem   Local(N1)  Desc.Loc.(N1)   Local(Co)  Desc.Loc.(Co)   Status Inv.                              Obs."
Local Cabec2       	:= ""
Local aOrd 			:= {}

Private lEnd      	:= .F.
Private lAbortPrint	:= .F.
Private CbTxt     	:= ""
Private limite   	:= 132
Private tamanho  	:= "G" //"M"
Private nomeprog 	:= "PROR0001"
Private nTipo     	:= 15 //18
Private aReturn  	:= { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey	:= 0
Private cbtxt      	:= Space(10)
Private cbcont     	:= 00
Private CONTFL     	:= 01
Private m_pag      	:= 01
Private wnrel      	:= "PROR0001"
Private cString		:= "SZA"
Private cPerg 		:= "PROR01IMP"

dbSelectArea(cString)
dbSetOrder(1)

ValidPerg(cPerg)
Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport1(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return


Static Function RunReport1(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem                                  
Local nTamLin := 50
Local cStatus := ""
Local cAux := ""
Local cStatusAux := "" 

dbSelectArea("SZA")
dbSetOrder(3)

SN1->(dbSetOrder(2))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(RecCount())

SZA->(dbSeek(xFilial("SZA")+dTos(mv_par01)+mv_par02,.T.))
While SZA->(!EOF()) .and. SZA->ZA_FILIAL+dTos(SZA->ZA_DATA)+SZA->ZA_CHAPA <= xFilial("SZA")+dTos(mv_par01)+mv_par03
	If mv_par04 == 1 // Listar somente inconsistencia
		If SZA->ZA_STATIMP == "3" .and. Empty(SZA->ZA_MSG) // registros importados sem inconsistencia
			SZA->(dbSkip())
			Loop
		Endif	 	
		If mv_par05 = 1 // somente divergencias de processamento do ativo x coletor
			If !SZA->ZA_STATIMP $ "1/2"
				SZA->(dbSkip())
				Loop
			Endif
		Elseif mv_par05 = 2 // outras inconsistencias 		
			If SZA->ZA_STATIMP $ "1/2" .or. Empty(SZA->ZA_MSG)	 
				SZA->(dbSkip())
				Loop
			Endif
		Endif
	Endif		
	
	If mv_par04 == 3 // nao listar inconsistencias
		If SZA->ZA_STATIMP $ "1/2" .or. !Empty(SZA->ZA_MSG)	 
			SZA->(dbSkip())
			Loop
		Endif
	Endif	
		
	SN1->(dbSeek(xFilial("SN1")+SZA->ZA_CHAPA))
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o cancelamento pelo usuario...                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do cabecalho do relatorio. . .                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	If SZA->ZA_STATIMP != "3" .or. (SZA->ZA_STATIMP == "3" .and. Empty(SZA->ZA_STATPRO)) // inconsistente ou (nao inconsistente e nao processando ainda => legenda Inventario OK)
		aCBox := RetSX3Box(Posicione("SX3",2,"ZA_STATIMP","X3CBox()"),,,1)
		cStatus := IIf((nPos:=aScan(aCBox,{|aBox| Subs(aBox[1],1,1)==SZA->ZA_STATIMP})) > 0,Alltrim(aCBox[nPos][3]),"")
	Else
		aCBox := RetSX3Box(Posicione("SX3",2,"ZA_STATPRO","X3CBox()"),,,1)
		cStatus := IIf((nPos:=aScan(aCBox,{|aBox| Subs(aBox[1],1,1)==SZA->ZA_STATPRO})) > 0,Alltrim(aCBox[nPos][3]),"")
	Endif

	@nLin,000 PSAY Dtoc(SZA->ZA_DATA)
	@nLin,011 PSAY SZA->ZA_COD
	@nLin,021 PSAY Subs(SZA->ZA_CHAPA,1,10)
	@nLin,033 PSAY SZA->ZA_CBASE
	@nLin,044 PSAY SZA->ZA_ITEM
	@nLin,054 PSAY IIf(SN1->(Found()),Subs(SN1->N1_DESCRIC,1,15),Subs(SZA->ZA_DESC,1,15))
	@nLin,070 PSAY IIf(SN1->(Found()),SN1->N1_LOCAL,SZA->ZA_LOCSN1)
	@nLin,081 PSAY Subs(Posicione("SNL",1,xFilial("SNL")+IIf(SN1->(Found()),SN1->N1_LOCAL,SZA->ZA_LOCSN1),"NL_DESCRIC"),1,15)
	@nLin,097 PSAY SZA->ZA_LOCAL
	@nLin,108 PSAY Subs(Posicione("SNL",1,xFilial("SNL")+SZA->ZA_LOCAL,"NL_DESCRIC"),1,15)
	cMsg := SZA->ZA_MSG
	
	While .T.
		cStatusAux := Subs(cStatus,1,40)
		cStatus := Subs(cStatus,41)
		@nLin,124 PSAY cStatusAux

		cAux := Subs(cMsg,1,54)
		cMsg := Subs(cMsg,55)
		@nLin,165 PSAY cAux

		nLin := nLin + 1 // Avanca a linha de impressao
		If Empty(cMsg) .and. Empty(cStatus)
			Exit
		Endif	
		If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
	Enddo
		
	IncRegua()
	SZA->(dbSkip())
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return


User Function ProR01Loc()

Local cPerg := "PROR01"
Local aArea := GetArea()
Local oProcess  := NIL

ValidPerg(cPerg)
If Pergunte(cPerg,.T.)
	If ApMsgYesNo("Confirma a transferência de locais?","Transferência")
		oProcess := MsNewProcess():New( { | lEnd | xTrfLoc( @lEnd,oProcess,cPerg) }, 'Processando', 'Aguarde, processando...', .F. )
		oProcess:Activate()
	Endif
Endif

Aviso("Transferência","Processo finalizado.",{"OK"})

RestArea(aArea)
Return


Static Function xTrfLoc(lEnd,oProcess,cPerg)

Local cQuery := ""
//Local cDescart := GetMv("MV_XLOCDES",,"")
Local cStatus := ""
Local cCodigo := ""
Local cAliasTMP := GetNextAlias()
Local cAliasTMP2 := GetNextAlias()
Local nProcRegs	:= 0
Local nTotRegs := 0
Local aDadosAuto := {} // Array com os dados a serem enviados pela MsExecAuto() para gravacao automatica
Local aEstrut := {}
Local lErro := .F.                 
Local nTamLin := 70
Local _cErroAuto := ""
//Local __cFilOri := cFilAnt

Private lMsHelpAuto := .f.        // Determina se as mensagens de help devem ser direcionadas para o arq. de log
Private lMsErroAuto := .f.        // Determina se houve alguma inconsistencia na execucao da rotina em relacao aos

aEstrut :={	{ "EMISSAO" 	, "D", 	 8, 0 },;
{ "COD_BARRA"	, "C",  20, 0 },;
{ "DESCR"		, "C",  30, 0 },;
{ "CONTEUDO"	, "C",  20, 0 },;
{ "MSG"			, "C", 100, 0 }}

cArqTmp := CriaTrab(aEstrut, .T.)
dbUseArea( .T.,, cArqTmp, cAliasTmp, .F., .F. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Indice Temporario do Arquivo de Trabalho.               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cChave   := "DTOS(EMISSAO)+COD_BARRA"

IndRegua(cAliasTmp,cArqTmp,cChave,,,"Criando Arquivo Temporário...")
dbSelectArea(cAliasTmp)
dbSetIndex(cArqTmp+OrdBagExt())
dbSetOrder(1)

cQuery := "SELECT ZA_COD, ZA_CHAPA, ZA_LOCSN1, ZA_LOCAL, N1_CBASE, N1_ITEM, ZA_DATA, ZA_DESC, SZA.R_E_C_N_O_ AS RECNO_SZA "
cQuery += "FROM "+RetSqlName("SZA")+" SZA "
cQuery += "JOIN "+RetSqlName("SN1")+" SN1 "
cQuery += "ON N1_FILIAL = '"+xFilial("SN1")+"' "
cQuery += "AND N1_CHAPA = ZA_CHAPA "
cQuery += "AND SN1.D_E_L_E_T_ = ' ' "
cQuery += "WHERE ZA_FILIAL = '"+xFilial("SZA")+"' "
cQuery += "AND ZA_DATA BETWEEN '"+dtos(MV_PAR01)+"' AND '"+dTos(MV_PAR02)+"' "
cQuery += "AND ZA_CHAPA BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cQuery += "AND ZA_STATIMP = '3' " // inventario OK
cQuery += "AND ZA_PROCESS <> 'S' " // nao processado
cQuery += "AND ZA_LOCAL <> ' ' " // tem que estar com o local destino preenchido
cQuery += "AND ZA_STATPRO <> '4' " // bens descartados nao transfere
cQuery += "AND ZA_MSG = ' ' " // nao pode ter nenhuma inconsistencia
cQuery += "AND ZA_LOCSN1 <> ZA_LOCAL " // somente transfere se os locais estiverem diferentes 
cQuery += "AND SZA.D_E_L_E_T_ = ' ' "

cQuery := ChangeQuery(cQuery)

If Select(cAliasTMP2) > 0
	dbSelectArea(cAliasTMP2)
	dbCloseArea()
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTMP2,.T.,.F.)

DbSelectArea(cAliasTMP2)

dbEval( {|x| nTotRegs++ },,{|| (cAliasTMP2)->(!EOF())})
oProcess:SetRegua1(nTotRegs+2)
oProcess:IncRegua1("Iniciando processamento...")
oProcess:SetRegua2(nTotRegs+1)
oProcess:IncRegua2("")

dbGotop()
cCodigo := (cAliasTMP2)->ZA_COD

If Eof()
	If Select(cAliasTMP2) > 0
		dbSelectArea(cAliasTMP2)
		dbCloseArea()
	Endif
	MsgStop("Não foram encontrados registros a serem processados (Transferência de locais). Verifique os parâmetros!")

	Return()
Endif	

While !Eof()
	aDadosAuto:= {  ;
	{'N3_FILIAL'	,xFilial("SN3")				, Nil},;        // Filial
	{'N3_CBASE'		,(cAliasTMP2)->N1_CBASE		, Nil},;        // Codigo base do ativo
	{'N3_ITEM'  	,(cAliasTMP2)->N1_ITEM		, Nil},;        // Item sequencial do codigo bas do ativo
	{'N4_DATA'  	,dDataBase					, Nil},;        // Data da Transferencia
	{'N1_LOCAL'	 	,(cAliasTMP2)->ZA_LOCAL  	, Nil}}	        // Local atual para transferencia
	
	// forca pergunte da atfa060, pois na rotina padrao, quando se usa rotina automatica, da error.log no parametro 1
	Pergunte("AFA060",.F.)
	mv_par01 := 2 // lancamento contabil OnLine = Nao
	mv_par02 := 2 // mostra lancamento contabil = Nao
	
	MSExecAuto({|x,y,z| AtfA060(x,y,z)},aDadosAuto,4)
	
	// restaura pergunte da rotina atual
	Pergunte(cPerg,.F.)
	
	If lMsErroAuto
		_cArqAuto 	:= NomeAutoLog()
		_cErroAuto 	:= ""
		_cErroAuto 	:= MemoRead(_cArqAuto)
		_cErroAuto 	:= Iif(Empty(_cErroAuto),"Erro na Execução do MsExecauto. Verificar log.",_cErroAuto)
		MostraErro("1","1") // passa qq parametro, pra nao mostrar tela do mostraerro()
		
		lErro := .T.
		dbSelectArea(cAliasTmp)
	
		nLinMsg := mlCount(_cErroAuto, nTamLin) //Total de linhas da Mensagem

   	    For nContador := 1 To nLinMsg
	   	    RecLock(cAliasTmp,.T.)
	   		(cAliasTmp)->EMISSAO 	:= Stod((cAliasTMP2)->ZA_DATA)
			(cAliasTmp)->COD_BARRA 	:= (cAliasTMP2)->ZA_CHAPA
			(cAliasTmp)->DESCR		:= (cAliasTMP2)->ZA_DESC
			(cAliasTmp)->CONTEUDO 	:= Memoline(_cErroAuto,nTamLin,1)
			(cAliasTmp)->MSG		:=  IIf(!Empty(Alltrim(Memoline(_cErroAuto,nTamlin,nContador))),Alltrim(Memoline(_cErroAuto,nTamlin,nContador)),' ') //)+Space(1)+Alltrim(Memoline(_cErroAuto,132,3))
			MsUnlock()
		Next
	Else
		If (cAliasTMP2)->ZA_LOCSN1 == (cAliasTMP2)->ZA_LOCAL
			cStatus := "1" //local OK
		Endif
		If Empty((cAliasTMP2)->ZA_LOCAL)
			cStatus := "3" //nao encontrado
		Endif
		If !Empty((cAliasTMP2)->ZA_LOCSN1) .and. !Empty((cAliasTMP2)->ZA_LOCAL) .and. (cAliasTMP2)->ZA_LOCSN1 != (cAliasTMP2)->ZA_LOCAL// .and. (cAliasTMP2)->ZA_LOCAL != cDescart 
			cStatus := "2" //transferido
		Endif
		//If !Empty((cAliasTMP2)->ZA_LOCSN1) .and. !Empty((cAliasTMP2)->ZA_LOCAL) .and. (cAliasTMP2)->ZA_LOCSN1 != (cAliasTMP2)->ZA_LOCAL .and. (cAliasTMP2)->ZA_LOCAL == cDescart
		//	cStatus := "4" //descartado
		//Endif
	
		SZA->(dbGoto((cAliasTMP2)->RECNO_SZA))
		SZA->(RecLock("SZA",.F.))
		SZA->ZA_STATPRO := IIf(SZA->ZA_STATPRO!="4",cStatus,SZA->ZA_STATPRO) // se jah estiver flegado como descartado="4", mantem este status, caso contrario atualiza o status
		SZA->(MsUnLock())		

		// marca registros como processados
		If !Empty(cCodigo)
			cQuery := "UPDATE "
			cQuery += RetSqlName("SZA")+ " "
			cQuery += "SET ZA_PROCESS = 'S' "
			cQuery += "WHERE D_E_L_E_T_ = ' ' " 
			cQuery += "AND ZA_FILIAL = '"+xFilial("SZA")+"' "
			cQuery += "AND ZA_DATA BETWEEN '"+dtos(MV_PAR01)+"' AND '"+dTos(MV_PAR02)+"' "
			cQuery += "AND ZA_CHAPA BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
			cQuery += "AND ZA_COD = '"+cCodigo+"' "
			cQuery += "AND ZA_STATIMP = '3' "
			cQuery += "AND ZA_LOCAL <> ' ' "
			cQuery += "AND ZA_STATPRO <> '4' "
			cQuery += "AND ZA_MSG = ' ' " 
			cQuery += "AND ZA_LOCSN1 <> ZA_LOCAL " 
			
			nRet := tcSqlExec(cQuery)
		    If nRet < 0
		    	MsgStop("Erro na atualização do campo de Processado."+CRLF+tcSqlError()+tcSqlError())
		    Endif                                                                                                                     
		Endif	
	EndIf
	
	oProcess:IncRegua1("Processando item: "+CValToChar(nProcRegs)+" / "+CValToChar(nTotRegs))
	oProcess:IncRegua2("Codigo de Barra: "+(cAliasTMP2)->ZA_CHAPA)
	
	DbSelectArea(cAliasTMP2)
	dbSkip()
	
	aDadosAuto  := {}
	lMsErroAuto := .f.
EndDo

If lErro
	//Chama Impressao do Relatorio de Inconsistencias
	If ApMsgYesNo("Ocorreram inconsistências durante a transferência dos dados, deseja imprimir o log?","Log de Inconsistências")
		xRelInc(cAliasTmp,"Inconsistências da Transferência")
	Endif
Endif

Return


User Function ProR01Inv()

Local cPerg := "PROR01INV"
Local aArea := GetArea()
Local oProcess  := NIL

ValidPerg(cPerg)
If Pergunte(cPerg,.T.)
	If ApMsgYesNo("Confirma a geração do inventário do Ativo Fixo?","Inventário")
		oProcess := MsNewProcess():New( { | lEnd | xInv( @lEnd,oProcess) }, 'Processando', 'Aguarde, processando...', .F. )
		oProcess:Activate()
	Endif
Endif

Aviso("Inventário","Processo finalizado.",{"OK"})

RestArea(aArea)
Return


Static Function xInv(lEnd,oProcess)

Local cQuery := ""
Local cAliasTMP2 := GetNextAlias()
Local nProcRegs	  := 0
Local nTotRegs	  := 0
Local cCodigo := ""

cQuery :=  "SELECT ZA_DATA, ZA_COD, ZA_CHAPA, ZA_LOCSN1, ZA_LOCAL, N1_CBASE, N1_ITEM, SZA.R_E_C_N_O_ AS RECNO_SZA "
cQuery +=  "FROM "+RetSqlName("SZA")+" SZA "
cQuery +=  "LEFT OUTER JOIN "+RetSqlName("SN1")+" SN1 ON N1_FILIAL = '"+xFilial("SN1")+"' AND N1_CHAPA = ZA_CHAPA AND SN1.D_E_L_E_T_ = ' ' "
cQuery +=  "WHERE ZA_FILIAL = '"+xFilial("SZA")+"' AND "
cQuery +=  "ZA_DATA = '"+dtos(MV_PAR01)+"' AND "
cQuery +=  "ZA_CHAPA BETWEEN '"+MV_PAR02+"' AND '"+MV_PAR03+"' AND "
cQuery +=  "ZA_STATIMP = '3' AND " // inventario ok
cQuery +=  "ZA_PROCESS = 'S' AND " // Processado
cQuery +=  "ZA_INVENT <> 'S' AND " // nao gerou inventario
cQuery +=  "SZA.D_E_L_E_T_ = ' ' "
cQuery := ChangeQuery(cQuery)

If Select(cAliasTMP2) > 0
	dbSelectArea(cAliasTMP2)
	dbCloseArea()
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTMP2,.T.,.F.)

DbSelectArea(cAliasTMP2)

dbEval( {|x| nTotRegs++ },,{|| (cAliasTMP2)->(!EOF())})
oProcess:SetRegua1(nTotRegs+2)
oProcess:IncRegua1("Iniciando processamento...")
oProcess:SetRegua2(nTotRegs+1)
oProcess:IncRegua2("")

dbGotop()
cCodigo := (cAliasTMP2)->ZA_COD

If Eof()
	If Select(cAliasTMP2) > 0
		dbSelectArea(cAliasTMP2)
		dbCloseArea()
	Endif
	MsgStop("Não foram encontrados registros a serem processados (Inventário). Verifique os parâmetros!")

	Return()
Endif	

SN1->(dbSetOrder(2))
SN3->(dbSetOrder(1))

While !Eof()
	If SN1->(dbSeek(xFilial("SN1")+(cAliasTMP2)->ZA_CHAPA))
		If SN3->(dbSeek(xFilial("SN3")+SN1->N1_CBASE+SN1->N1_ITEM))
			SN8->(RecLock("SN8",.T.))
			SN8->N8_FILIAL := xFilial("SN8")
			SN8->N8_CBASE := SN1->N1_CBASE  
			SN8->N8_ITEM := SN1->N1_ITEM  
			SN8->N8_TIPO := "01" //DEPRECIACAO FISCAL                                     
			SN8->N8_DTINV := sTod((cAliasTMP2)->ZA_DATA) 
			SN8->N8_QTDINV := 1
			SN8->N8_SEQ := SN3->N3_SEQ
			SN8->(MsUnLock())
		Endif
	Endif		   

	nProcRegs++
	oProcess:IncRegua1("Processando item: "+CValToChar(nProcRegs)+" / "+CValToChar(nTotRegs))
	oProcess:IncRegua2("Codigo de Barra: "+(cAliasTMP2)->ZA_CHAPA)
		
	DbSelectArea(cAliasTMP2)
	dbSkip()
EndDo

// marca registros como inventariados
If !Empty(cCodigo)
	cQuery := "UPDATE "
	cQuery += RetSqlName("SZA")+ " "
	cQuery += "SET ZA_INVENT = 'S' "
	cQuery += "WHERE D_E_L_E_T_ = ' ' AND " 
	cQuery += "ZA_FILIAL = '"+xFilial("SZA")+"' AND "
	cQuery += "ZA_DATA = '"+dtos(MV_PAR01)+"' AND "
	cQuery += "ZA_CHAPA BETWEEN '"+MV_PAR02+"' AND '"+MV_PAR03+"' AND "
	cQuery += "ZA_STATIMP = '3' AND " // inventario ok
	cQuery += "ZA_PROCESS = 'S' AND " // Processado
	cQuery += "ZA_INVENT <> 'S' AND " // nao gerou inventario	
	cQuery += "ZA_COD = '"+cCodigo+"' "
	
	nRet := tcSqlExec(cQuery)
    If nRet < 0
    	MsgStop("Erro na atualização do campo de Inventario."+CRLF+tcSqlError()+tcSqlError())
    Endif                                                                                                                     
Endif	

Return


User Function ProR01Leg()

Local aCores := {}

aCores := {;
{"BR_AZUL","Bem cadastrado no Ativo e nao inventariado"},;
{"BR_PINK","Bem inventariado e nao cadastrado no Ativo"},;
{"ENABLE","Inventario OK"},;
{"BR_BRANCO","Local OK"},;
{"BR_LARANJA","Transferido"},;
{"BR_AMARELO","Nao Encontrado"},;
{"DISABLE","Descartado"},;
{"BR_PRETO","Inventario Gerado"}}

BrwLegenda(cCadastro,"Legenda",aCores)

Return(.T.)


User Function ProR01IArq()

Local aArea := GetArea()
Local oProcess  := NIL
Local cArq := ""//"tabBP.txt"

If ApMsgYesNo("Confirma a geração do arquivo para inventário do Ativo Fixo?","Inventário")
	// arquivo de bens cadastrados
	oProcess := MsNewProcess():New( { | lEnd | xIArq( @lEnd,oProcess,@cArq) }, 'Processando', 'Aguarde, processando...', .F. )
	oProcess:Activate()
	Aviso("Arquivo para Inventário","Processo finalizado."+CRLF+"Gerado arquivo: "+cArq,{"OK"})
	
	cArq := ""
	// arquivo de locais cadastrados
	oProcess := MsNewProcess():New( { | lEnd | xILocArq( @lEnd,oProcess,@cArq) }, 'Processando', 'Aguarde, processando...', .F. )
	oProcess:Activate()
	Aviso("Arquivo para Inventário","Processo finalizado."+CRLF+"Gerado arquivo: "+cArq,{"OK"})
Endif

//Aviso("Arquivo para Inventário","Processo finalizado."+CRLF+"Gerado arquivo: "+cArq,{"OK"})

RestArea(aArea)

Return


Static Function xIArq(lEnd,oProcess,cArq)

Local cQuery := ""
Local cAliasTMP2 := GetNextAlias()
Local nProcRegs	  := 0
Local nTotRegs	  := 0
Local aCab := {}
Local aItens := {}

//cArq := cGetFile("*.txt","Textos (.TXT)",,,.F.,GETF_LOCALFLOPPY+GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY)
cArq := cGetFile("*.txt","Arquivo de Bens cadastrados",,,.F.,GETF_LOCALFLOPPY+GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY)

If Len(cArq) == 0 .or. Empty(Subs(cArq,rAt("\",cArq)+1))
	MsgStop("Nome do arquivo não informado. Nenhum arquivo será gerado.")
	
	Return()
Endif
	
If At(".",cArq) > 0
	cArq := Subs(cArq,1,At(".",cArq)-1)+".txt"
Else
	cArq := cArq+".txt" 	
Endif
	
cQuery := "SELECT SN1.R_E_C_N_O_ AS RECNO_SN1 "
cQuery += "FROM "+RetSqlName("SN1")+" SN1 "
cQuery += "WHERE N1_FILIAL = '"+xFilial("SN1")+"' "
cQuery += "AND N1_BAIXA = ' ' "
cQuery += "AND SN1.D_E_L_E_T_ = ' ' "
cQuery := ChangeQuery(cQuery)

If Select(cAliasTMP2) > 0
	dbSelectArea(cAliasTMP2)
	dbCloseArea()
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTMP2,.T.,.F.)

DbSelectArea(cAliasTMP2)

dbEval( {|x| nTotRegs++ },,{|| (cAliasTMP2)->(!EOF())})
oProcess:SetRegua1(nTotRegs+2)
oProcess:IncRegua1("Iniciando processamento...")
oProcess:SetRegua2(nTotRegs+1)
oProcess:IncRegua2("")

dbGotop()

While !Eof()
	SN1->(dbGoto((cAliasTMP2)->RECNO_SN1))
	If SN1->(Recno()) == (cAliasTMP2)->RECNO_SN1
		nProcRegs++
		oProcess:IncRegua1("Processando item: "+CValToChar(nProcRegs)+" / "+CValToChar(nTotRegs))
		oProcess:IncRegua2("Codigo de Barra: "+SN1->N1_CHAPA)

		aAdd(aItens,{Padr(SN1->N1_CHAPA,6),Padr(SN1->N1_DESCRIC,40),Padr(SN1->N1_LOCAL,6),IIf(SN1->(FieldPos("N1_XNSERIE"))>0,Padr(SN1->N1_XNSERIE,20),Padr("",20))})
	Endif	
		
	DbSelectArea(cAliasTMP2)
	dbSkip()
EndDo

If Select(cAliasTMP2) > 0
	dbSelectArea(cAliasTMP2)
	dbCloseArea()
Endif

If !Empty(aItens)
	GeraXls(cArq,aCab,aItens)
Endif	

Return


Static Function xILocArq(lEnd,oProcess,cArq)

Local cQuery := ""
Local cAliasTMP2 := GetNextAlias()
Local nProcRegs	  := 0
Local nTotRegs	  := 0
Local aCab := {}
Local aItens := {}

cArq := cGetFile("*.txt","Arquivo de Locais cadastrados",,,.F.,GETF_LOCALFLOPPY+GETF_LOCALHARD+GETF_NETWORKDRIVE+GETF_RETDIRECTORY)

If Len(cArq) == 0 .or. Empty(Subs(cArq,rAt("\",cArq)+1))
	MsgStop("Nome do arquivo não informado. Nenhum arquivo será gerado.")
	
	Return()
Endif
	
If At(".",cArq) > 0
	cArq := Subs(cArq,1,At(".",cArq)-1)+".txt"
Else
	cArq := cArq+".txt" 	
Endif
	
cQuery := "SELECT SNL.R_E_C_N_O_ AS RECNO_SNL "
cQuery += "FROM "+RetSqlName("SNL")+" SNL "
cQuery += "WHERE NL_FILIAL = '"+xFilial("SNL")+"' "
cQuery += "AND SNL.D_E_L_E_T_ = ' ' "
cQuery := ChangeQuery(cQuery)

If Select(cAliasTMP2) > 0
	dbSelectArea(cAliasTMP2)
	dbCloseArea()
Endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTMP2,.T.,.F.)

DbSelectArea(cAliasTMP2)

dbEval( {|x| nTotRegs++ },,{|| (cAliasTMP2)->(!EOF())})
oProcess:SetRegua1(nTotRegs+2)
oProcess:IncRegua1("Iniciando processamento...")
oProcess:SetRegua2(nTotRegs+1)
oProcess:IncRegua2("")

dbGotop()

While !Eof()
	SNL->(dbGoto((cAliasTMP2)->RECNO_SNL))
	If SNL->(Recno()) == (cAliasTMP2)->RECNO_SNL
		nProcRegs++
		oProcess:IncRegua1("Processando item: "+CValToChar(nProcRegs)+" / "+CValToChar(nTotRegs))
		oProcess:IncRegua2("Local: "+SNL->NL_CODIGO)

		aAdd(aItens,;
		{Padr(SNL->NL_CODIGO,6),;
		Padr(SNL->NL_DESCRIC,40),;
		IIf(SNL->(FieldPos("NL_XSECRET"))>0,Padr(SNL->NL_XSECRET,15),Padr("",15)),;
		IIf(SNL->(FieldPos("NL_XUNIDAD"))>0,Padr(SNL->NL_XUNIDAD,10),Padr("",10)),;
		IIf(SNL->(FieldPos("NL_XCEP"))>0 .and. !Empty(SNL->NL_XCEP),Padr(Transform(SNL->NL_XCEP,"@R 99999-999"),15),Padr("",15)),;
		IIf(SNL->(FieldPos("NL_XCONT"))>0,Padr(SNL->NL_XCONT,40),Padr("",40))})
	Endif	
		
	DbSelectArea(cAliasTMP2)
	dbSkip()
EndDo

If Select(cAliasTMP2) > 0
	dbSelectArea(cAliasTMP2)
	dbCloseArea()
Endif

If !Empty(aItens)
	GeraXls(cArq,aCab,aItens)
Endif	

Return


Static Function GeraXls(cArq,aCabec,aItens)

local cDirDocs  := MsDocPath()
Local cArquivo 	:= Subs(cArq,1,Len(cArq)-4)+".txt" //CriaTrab(,.F.)
Local cPath		:= "c:\temp\"
Local oExcelApp
Local nHandle
Local cCrLf 	:= Chr(13) + Chr(10)
Local nX
Local cArqDest := substr(cArq,1,len(carq)-4)+".txt"

MakeDir(cDirDocs)
//MakeDir(GetSrvProfString("RootPath","")+Subs(cDirDocs,2))
MakeDir(cPath)

//If File(cPath+cArquivo)
If File(cArquivo)
	fErase(cArquivo)
Endif	
//nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".txt",0)
//nHandle := MsfCreate(cPath+cArquivo,0)
nHandle := MsfCreate(cArquivo,0)

If nHandle > 0
	
	// Grava o cabecalho do arquivo
	If Len(aCabec) > 0
		for _na := 1 to len(ACABEC)
			fWrite(nHandle,ACABEC[_na]+";")
		next _na
		fWrite(nHandle, cCrLf ) // Pula linha
	Endif	
	
	for _ni := 1 to len(aItens)
		_aItem := aItens[_ni]
		for _nj := 1 to len(_aItem)
			//fWrite(nHandle,strtran(_aItem[_nj],".",",")+";")
			fWrite(nHandle,strtran(_aItem[_nj],".",","))
		next _nj
		fWrite(nHandle, cCrLf)
	next _ni
	fClose(nHandle)
	
	//__CopyFile( cDirDocs+"\"+cArquivo+".CSV",cPath+carqdest)
	
	//ferase(cDirDocs+"\"+cArquivo+".CSV")
	
Else
	MsgStop("Falha na criação do arquivo")
Endif

Return


Static Function ValidPerg(cPerg)

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
//cPerg := PADR(cPerg,10)

If cPerg = "PROR01DEL"
	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	aAdd(aRegs,{cPerg,"01","Data Inventario de  "			,"mv_ch1","D",08,0,0,"G","naovazio()","mv_par01","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"02","Data Inventario até "			,"mv_ch2","D",08,0,0,"G","naovazio() .and. mv_par02>=mv_par01","mv_par02","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"03","Codigo da Plaqueta de  "		,"mv_ch3","C",20,0,0,"G","","mv_par03","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"04","Codigo da Plaqueta até "		,"mv_ch4","C",20,0,0,"G","","mv_par04","","","","","","","","","","","","","","","",""})
Elseif cPerg = "PROR01INV"
	aAdd(aRegs,{cPerg,"01","Data Inventario  "				,"mv_ch1","D",08,0,0,"G","naovazio()","mv_par01","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"02","Codigo da Plaqueta de  "		,"mv_ch2","C",20,0,0,"G","","mv_par02","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"03","Codigo da Plaqueta até "		,"mv_ch3","C",20,0,0,"G","","mv_par03","","","","","","","","","","","","","","","",""})
Elseif cPerg = "PROR01IMP"
	aAdd(aRegs,{cPerg,"01","Data Inventario  "				,"mv_ch1","D",08,0,0,"G","naovazio()","mv_par01","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"02","Codigo da Plaqueta de  "		,"mv_ch2","C",20,0,0,"G","","mv_par02","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"03","Codigo da Plaqueta até "		,"mv_ch3","C",20,0,0,"G","","mv_par03","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"04","Listar somente inconsistencia"	,"mv_ch4","N",1 ,0,1,"C","","mv_par04","Sim","","","Nao","","","Nao Listar Inco","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"05","Tipo de inconsistencia"			,"mv_ch5","N",1 ,0,1,"C","","mv_par05","Proc. Atf X Col","","","Outros","","","Todos","","","","","","","","",""})
Elseif cPerg = "PROR01NINV"
	aAdd(aRegs,{cPerg,"01","Data Inventario  "				,"mv_ch1","D",08,0,0,"G","naovazio()","mv_par01","","","","","","","","","","","","","","","",""})
Else
	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	aAdd(aRegs,{cPerg,"01","Data Inventario de  "			,"mv_ch1","D",08,0,0,"G","naovazio()","mv_par01","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"02","Data Inventario até "			,"mv_ch2","D",08,0,0,"G","naovazio() .and. mv_par02>=mv_par01","mv_par02","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"03","Codigo da Plaqueta de  "		,"mv_ch3","C",20,0,0,"G","","mv_par03","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"04","Codigo da Plaqueta até "		,"mv_ch4","C",20,0,0,"G","","mv_par04","","","","","","","","","","","","","","","",""})
Endif

For i := 1 to Len(aRegs)
	PutSX1(aRegs[i,1],aRegs[i,2],aRegs[i,3],aRegs[i,3],aRegs[i,3],aRegs[i,4],aRegs[i,5],aRegs[i,6],aRegs[i,7],;
	aRegs[i,8],aRegs[i,9],aRegs[i,10],iif(len(aRegs[i])>=26,aRegs[i,26],""),aRegs[i,27],"",aRegs[i,11],aRegs[i,12],;
	aRegs[i,12],aRegs[i,12],aRegs[i,13],aRegs[i,15],aRegs[i,15],aRegs[i,15],aRegs[i,18],aRegs[i,18],aRegs[i,18],;
	aRegs[i,21],aRegs[i,21],aRegs[i,21],aRegs[i,24],aRegs[i,24],aRegs[i,24])
Next i

dbSelectArea(_sAlias)

Return
