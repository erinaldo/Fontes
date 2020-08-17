#Include "protheus.ch"
#Include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RIMPA25 บAutor  ณDouglas David		  บ Data ณ  24/12/15  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Importa็ใo de dados para cria็ใo de pedido de vendas       บฑฑ
ฑฑบ          ณ Opera็ใo Opte+ MarketSystem                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RIMPA25()

Local aBotoes	:= {}
Local aSays		:= {}
Local aPergunt	:= {}
Local nOpcao	:= 0
Local oRegua    := Nil

// Prepara็ใo para chamada Via Schedule

Local cRPCEmp    := "05"
Local cRPCFil    := "03"
Local cRPCUsr    := "000000"
Local bParam     := {|aPar, nPos, uDef| IIf(len(aPar) < nPos, uDef, aPar[nPos])}
Local lSchedule  := .F.
Local cUserIdBkp := IIf(Type("__cUserId") == "C", __cUserId, nil)
Local aParam     := {}

//Public _cTE:="201"
//Public _cTS:=""
Public cLoja:='01'
Public cCodCli:=''
Public _cCpfCgc

//Parametros da rotina
PutSx1("RIMPA25","01","Tipo de Arquivo ?","","","mv_ch1","N", 1,0,1,"C","","","","","mv_par01","CSV","","","","TXT","","","","","","","","","","","","","","","")
PutSX1("RIMPA25","02","Arquivo"		  ,"","","mv_ch2","C",50,0,0,"G","","","","","mv_par02",""   ,"","","*",""   ,"","","","","","","","","","","",{},{},{})
PutSX1("RIMPA25","03","Local do Arquivo" ,"","","mv_ch3","C",50,0,0,"G","","","","","mv_par03",""   ,"","","",""   ,"","","","","","","","","","","",{},{},{})
PutSx1("RIMPA25","04","Reprocessa PV ?"  ,"","","mv_ch4","N", 1,0,1,"C","","","","","mv_par04","Sim","","","","Nใo","","","","","","","","","","","","","","","")
//PutSx1("RIMPA25","05","TES:           "  ,"","","mv_ch5","C",03,0,0,"G","","","","","mv_par05",""   ,"","","",""   ,"","","","","","","","","","","","","","","SF4")

_nLarglog := 200
Pergunte("RIMPA25",.F.)

// Se a rotina foi chamada via schedule, abre o ambiente.
If Type("oMainWnd") <> "O"
	// Pega os parametros passados.
	// Default aParam := {}
	cRPCEmp := Eval(bParam, aParam, 1, cRPCEmp)
	cRPCFil := Eval(bParam, aParam, 2, cRPCFil)
	cRPCUsr := Eval(bParam, aParam, 3, cRPCUsr)
	lSchedule := .T.
	
	// Prepara o ambiente.
	RPCSetType(3) 				// Nao consome licenca.
	WfPrepEnv(cRPCEmp, cRPCFil)
	
	// Posiciona o usuario.
	PswOrder(1)  // Por ID.
	If PswSeek(cRPCUsr, .T.)  	// Posiciona o usuario.
		__cUserId := PswRet()[1, 1]  // Codigo do usuario.
	Endif
Endif

// Efetua o processamento.
If !empty(__cUserId) .and. lSchedule
	
	// Define o nome do arquivo.
	cArqImp := mv_par03 + "CSU" + StrZero(month(dDataBase), 2) + StrZero(day(dDataBase), 2) + right(Str(year(dDataBase), 4), 2) + ".01"
	If (nHandle := FT_FUse(cArqImp))== -1
		conout("Erro ao tentar abrir arquivo " + MV_PAR02,"Aten็ใo")
		Return
	EndIf
	
	Processa({|| RIMPA25A(cArqImp) })
Endif

if lSchedule
	// Renomeia arquivo Lido
	fRename(cArqImp, Substr(cArqImp,1,Len(cArqImp)-7)+"_OK.CSV")
	
	// Finaliza o ambiente.
	If lSchedule
		RpcClearEnv()
		__cUserId := cUserIdBkp
	Endif
	Return
Endif

//Tela de aviso e acesso aos parametros
AAdd(aSays,"Sr(a)." + ALLTRIM(Substr(cUsuario,7,15)+ "."))
AAdd(aSays,"Esse programa irแ efetuar a leitura de arquivo - Opera็ใo Opte+")
AAdd(aSays," e irแ gerar o Pedido de Venda Liberado no Protheus..")

AAdd(aBotoes,{ 5,.T.,{|| Pergunte("RIMPA25",.T. ) } } )
AAdd(aBotoes,{ 1,.T.,{|| nOpcao := 1, FechaBatch() }} )
AAdd(aBotoes,{ 2,.T.,{|| FechaBatch() }} )
FormBatch( "Gera็ใo de Pedido de Vendas", aSays, aBotoes )

cProcessa:=mv_par04

If nOpcao == 1
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Busca o arquivo para leitura.											 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	if mv_par01 = 1 // Arquivo CSV
		cArqImp := cGetFile("Arquivo .CSV |"+alltrim(MV_PAR02)+".CSV","Selecione o Arquivo CSV",0,mv_par03,.T.,GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE)
	else
		cArqImp := cGetFile("Arquivo .TXT |"+alltrim(MV_PAR02)+".TXT","Selecione o Arquivo TXT",0,mv_par03,.T.,GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE)
	endif
	
	If (nHandle := FT_FUse(cArqImp))== -1
		MsgInfo("Erro ao tentar abrir arquivo " + MV_PAR02,"Aten็ใo")
		Return
	EndIf
	
	Processa({|| RIMPA25A(cArqImp) })
EndIf

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RIMPA25A บAutor  ณCSU                 บ Data ณ  13/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณProcessamento da rotina de importacao                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RIMPA25A(cArqImp)
Local i      := 0
Local j      := 0
Local nContLi:= 0
Local _CRLF  := CHR(13)+CHR(10)
Local cCodiGC:=SM0->M0_CODIGO
Local nLinha := 0
Local cCodFil:=SM0->M0_CODFIL 

PRIVATE _cCodigoProd:=''
PRIVATE _cCodCli:=''

If (cCodiGC<>'05' .or. cCodFil<>'03')
	
	AVISO('*** Aten็ใo - ' + cModulo,'Checagem de Empresas !' + _CRLF + "Sr(a)."+ALLTRIM(Substr(cUsuario,7,15))+;
	", esta rotina apenas pode ser executada na empresa:"+ _CRLF + ;
	"05 (CSU CARDSYSTEM) - Filial: 03 (ALPHAVILLE)",{'OK'},2,"Rotina Abandonada !!")
	
	Return
Endif

nPosicao := nColuna := nLog := 0
cLinha   := cMenErro:= cItem:= cNumPC:= TmpNumPC := _cNaturez:= ""

aCab      := {}
aItem     := {}
aItens    := {}
aLayout   := {}
aArquivo  := {}
aProc 	  := {}
uConteudo := Nil
_nErro    := 0

// Parametros utilizados atualmente, verificar se serแ necessแrio utilizar ou se terแ no arquivo

private _cArea   := GetNewPar("MV_XFFAREA","MARK")			// Area de Negocios padrใo Ped Vendas
//private _cTS	 := MV_PAR05 // TES para o pedido 

//private _cCustPv := GetNewPar("MV_XFFCUST","0701020000")  	// Centro de Custos padrใo Ped Vendas
//private _cNegoPv := GetNewPar("MV_XFFNEGO","0703")		 	// Unidade Negocios padrใo Ped Vendas
//private _cOperPv := GetNewPar("MV_XFFOPER","999999999")		// Operacao padrใo Ped Vendas

_cNomeArq := Alltrim(SUBSTR(cLinha,3,20))+"-"+alltrim(Substr(cLinha,41,6))+".txt"   /////  nome do arquivo de LOG
nLog := FCreate("C:\tmp\CSU\LOG_PEDV\"+_cNomeArq)

if mv_par01 = 1 // Arquivo CSV
	
	// A1_CGC	A1_NOME	A1_NREDUZ	A1_END	A1_BAIRRO	A1_MUN	A1_EST	A1_CEP	A1_CONTATO	A1_DDD	A1_TEL	A1_EMAIL	NOM_PRG	C5_CC	C5_ITEM	C5_CLVL	C5_X_RESG	C6_PRUNIT
	
	aadd(aProc,"Iniciando processo no arquivo: "+cArqImp+" as: "+Time())
	
	// Abre o arquivo do banco
	
	FT_FUSE(cArqImp)
	FT_FGOTOP()
	
	aadd(aProc,"     Carregando arquivo em memoria...")
	
	// Carrega o arquivo no array
	
	FT_FGOTOP()
	While !FT_FEOF()
		nLinha++
		IncProc("Validando arquivo. Linha " + ltrim(str(nLinha)))
		ProcessMessages()  // Atualiza a pintura da janela.
		
		If !Empty(FT_FREADLN())
			
			cLinha := FT_FREADLN()
			cLinha := Upper(NoAcento(AnsiToOem(cLinha)))
			AADD(aArquivo,{})
			While At(";",cLinha) > 0
				aAdd(aArquivo[Len(aArquivo)],Substr(cLinha,1,At(";",cLinha)-1))
				cLinha := StrTran(Substr(cLinha,At(";",cLinha)+1,Len(cLinha)-At(";",cLinha)),'"','')
			EndDo
			aAdd(aArquivo[Len(aArquivo)],StrTran(Substr(cLinha,1,Len(cLinha)),'"',''))
			
		ENDIF
		FT_FSKIP()
	EndDo
	// Fecha o Arquivo
	FT_FUSE()
else
	AAdd(aLayOut,{"A1_CGC"		, 1,.F.," !xACChkCGC(uConteudo)","1-cnpj nao informado ou invalido ","C"}) // Campo com nome errado
	AAdd(aLayOut,{"A1_NOME"		, 2,.F.,"Empty(uConteudo)","2-Nome nใo informado","C"})
	AAdd(aLayOut,{"A1_NREDUZ"	, 3,.F.,"Empty(uConteudo)","3-Nome Fantasia nใo informado","C"})
	AAdd(aLayOut,{"A1_END"		, 4,.F.,"Empty(uConteudo)","4-endereco nao informado","C"})
	AAdd(aLayOut,{"A1_BAIRRO"	, 5,.F.,"Empty(uConteudo)","5-Bairro nao informado","C"})
	AAdd(aLayOut,{"A1_MUN"		, 6,.F.,"Empty(uConteudo)","6-Cod.municipio invalido ou nao informado","C"})
	AAdd(aLayOut,{"A1_EST"		, 7,.F.,"Empty(uConteudo)","7-estado nao informado","C"})
	AAdd(aLayOut,{"A1_CEP"		, 8,.F.,"Empty(uConteudo)","8- CEP nใo informado","C"})
	AAdd(aLayOut,{"A1_CONTATO"	, 9,.F.,.F.,"9 - Contato  nใo informado","C"})
	AAdd(aLayOut,{"A1_DDD"		,10,.F.,.F.,"10- DDD nใo informado","C"})
	AAdd(aLayOut,{"A1_TEL"		,11,.F.,.F.,"11- Telefone nใo informado","C"})
	AAdd(aLayOut,{"A1_EMAIL"	,12,.F.,.F.,"12- EMAIL nใo informado","C"})
	
	AAdd(aLayOut,{"C5_CC"		,13,.F.,.F.,"!Valarq('CTD',1,uConteudo)","14- Centro de custo invalido ou nao informado"})
	AAdd(aLayOut,{"C5_ITEM"		,14,.F.,"Empty(uConteudo)","15- Unidade de Neg๓cio nใo informado","C"})
	AAdd(aLayOut,{"C5_CLVL"		,15,.F.,"Empty(uConteudo)","15- Opera็ao do PC  nใo informado","C"})
	AAdd(aLayOut,{"C5_EMISSAO"	,16,.F.,"Empty(uConteudo)","16- emissao  nใo informado","D"})
	AAdd(aLayOut,{"C5_X_RESG"	,17,.F.,"Empty(uConteudo)","17- Resgate nใo informado","C"})
	
	AAdd(aLayOut,{"C6_PRODUTO"	,18,.F.,"Empty(uConteudo)","19- codigo do produto nใo informado","C"})
	AAdd(aLayOut,{"C6_QUANT"	,19,.F.,"Empty(uConteudo)","20- quantidade  nใo informado","N"})
	AAdd(aLayOut,{"C6_PRUNIT"	,20,.F.,"Empty(uConteudo)","21- preco UNITมRIO de venda nใo informado","N"})
	AAdd(aLayOut,{"C6_PRUNIT"	,21,.F.,"Empty(uConteudo)","22- preco Total de venda nใo informado","N"})
	AAdd(aLayOut,{"B1_DESC"     ,22,.F.,"Empty(uConteudo)","19- descricao do produto nใo informado","C"})

	If !File(cArqImp)
		MsgStop("Arquivo: "+cArqImp+" nใo encontrado.","Aten็ใo")
		Return()
	Endif
	
	FT_FUse(cArqImp)
	FT_FGoTop()
	ProcRegua(FT_FLastRec())
	FT_FGoTop()
	
	cLinha   := FT_FReadLn()
	
	FT_FSkip() //Primeira linha com cabe็alho
	
	While !FT_FEof()
		IncProc("Formatando Arquivo...")
		
		cLinha   := FT_FReadLn()
		nColuna  := 0
		nPosicao := 1
		AAdd(aArquivo,Array(29))
		
		aArquivo[Len(aArquivo),1]    := SUBSTR(cLinha,01,14)  ///   CPF/CNPJ do Cliente		A1_CGC		Numerico
		aArquivo[Len(aArquivo),2]    := SUBSTR(cLinha,15,30)  ///   Nome do cliente
		aArquivo[Len(aArquivo),3]    := SUBSTR(cLinha,45,20)  ///   Nome fantasia
		aArquivo[Len(aArquivo),4]    := SUBSTR(cLinha,65,100) ///   Endere็o Completo 		A1_END		Alfanumerico
		aArquivo[Len(aArquivo),5]    := SUBSTR(cLinha,165,20) ///   Bairro					A1_BAIRRO	Alfanumerico
		aArquivo[Len(aArquivo),6]    := SUBSTR(cLinha,185,20) ///   Cidade					A1_MUN		Alfanumerico
		aArquivo[Len(aArquivo),7]    := SUBSTR(cLinha,205,02) ///   Estado					A1_EST 		Alfanumerico
		aArquivo[Len(aArquivo),8]    := SUBSTR(cLinha,207,08) ///   CEP						A1_CEP 		NumericoCEP
		aArquivo[Len(aArquivo),9]    := SUBSTR(cLinha,215,15) ///   Contato					A1_CONTATO	Alfanumerico
		aArquivo[Len(aArquivo),10]   := SUBSTR(cLinha,230,03) ///   DDD						A1_DDD		Numerico
		aArquivo[Len(aArquivo),11]   := SUBSTR(cLinha,233,09) ///   Telefone Contato Dest.	A1_TEL		Numerico
		aArquivo[Len(aArquivo),12]   := SUBSTR(cLinha,242,80) ///   Email do destinatario	A1_EMAIL	Alfanumerico

		aArquivo[Len(aArquivo),13]   := SUBSTR(cLinha,322,20) ///  	Centro de Custo			C5_CC		Numerico
		aArquivo[Len(aArquivo),14]   := SUBSTR(cLinha,342,09) ///  	Unidade de Negocio		C5_ITEM		Numerico
		aArquivo[Len(aArquivo),15]   := SUBSTR(cLinha,351,20) /// 	Opera็ใo				C5_CLVL		Numerico
		aArquivo[Len(aArquivo),16]   := SUBSTR(cLinha,371,10) ///   Data de Emissใo 		C5_EMISSAO	Data
		aArquivo[Len(aArquivo),17]   := SUBSTR(cLinha,381,10) ///   Numero do resgate		C5_X_RESG	Numerico
		aArquivo[Len(aArquivo),18]   := SUBSTR(cLinha,391,08) ///   C๓digo do Produto		C6_PRODUTO	Numerico
		aArquivo[Len(aArquivo),19]   := SUBSTR(cLinha,399,03) ///   Quantidade				C6_QTDVEN	Numerico
		aArquivo[Len(aArquivo),20]   := SUBSTR(cLinha,402,14) ///   Vlr.Unit.-Sem Separ 	C6_PRUNIT	Numerico	
		aArquivo[Len(aArquivo),21]   := SUBSTR(cLinha,416,12) ///   Vlr.Unit.-Sem Separ 	C6_PRUNIT	Numerico
	   	aArquivo[Len(aArquivo),22]   := SUBSTR(cLinha,428,40) ///  Descricao do Produto    
				
		FT_FSkip()
	EndDo
	
Endif

//Valida a importa็ใo do arquivo

ProcRegua(Len(aArquivo)-1)

For i := 2 To Len(aArquivo)
	
	IncProc("Importando Dados ..."+STR(I))
	
	cMenErro := ""
	_Continua := .T.
	
	For j := 1 To Len(aLayOut)
		uConteudo := aArquivo[i,aLayout[j,2]]
		IF Alltrim(uConteudo) != '99'
			Exit    ///// Final de arquivo Texto
		Endif
		
		If !Empty(aLayout[j,4]) .and.  &(aLayout[j,4])
			cMenErro += " - " + aLayout[j,5] + Chr(13) + Chr(10)
		EndIf
	Next j
	
	If !Empty(cMenErro) //////.AND. 1==2
		FWrite(nLog,"LOG Registro: " + STRZERO(I,3) +Chr(13)+Chr(10))         /////  ver aarquivo
		FWrite(nLog,cMenErro+Chr(13)+Chr(10))
		_nErro++
	Else
	
		// *********************************************** CLIENTE ******************************************************
		nContLi++ //CONTADOR PARA ESPECIFICAR A LINHA NO ERROR LOG.
		Dbselectarea("SA1")
		Dbsetorder(3)

		IF (LEN(alltrim(aArquivo[i] [01]))  > 11) 
		_cCpfCgc := Strzero(Val(Alltrim(aArquivo[i,01])),14)
         else
		_cCpfCgc := Strzero(Val(Alltrim(aArquivo[i,01])),11)
		endif
		
		IF   _Continua
			
			if Dbseek(xFilial("SA1")+_cCpfCgc)   ////////////////// encontrou o cliente
				_Continua  := AtuSA1(i,.T.) // Passa com parametro devido ao escopo Local
			else
				_Continua  := AtuSA1(i,.F.) // Passa com parametro devido ao escopo Local
			endif
			
			IF !_Continua
				//	FWrite(nLog,"LOG Registro: " + STRZERO(I,3)+Chr(13)+Chr(10))         /////  ver aarquivo
				nContLi:=cvaltochar(nContLi)
				FWrite(nLog,"Problema na Cria็ใo e/ou Altera็ใo do Cliente CPF: "+_cCpfCgc+", Linha: "+nContLi+ "do arquivo de importa็ใo." +Chr(13)+Chr(10))
				nContLi:=val(nContLi)
				_Continua := .F.
				_nErro++
			endif
		Endif
		
		// *********************************************** PRODUTO ******************************************************
		
		
		cB1COD := ALLTRIM(aArquivo[i,18]) +SPACE((TamSX3("B1_COD")[1])- LEN(ALLTRIM(aArquivo[i,18])))
		Dbselectarea("SB1")
		Dbsetorder(1)
		
		IF  _Continua
			
			IF  Dbseek(xFilial("SB1")+Alltrim(cB1COD))    ////////////////// encontrou o Produto, cria o Produto
				_Continua  := AtuSB1(i,.T.)// Passa com parametro devido ao escopo Local
			Else
				_Continua  := AtuSB1(i,.F.)// Passa com parametro devido ao escopo Local
			endif
			IF !_Continua
				nContLi:=cvaltochar(nContLi)
				FWrite(nLog,"Problema na cria็ใo do Produto  " + cB1COD, "- Linha: "+nContLi+ " do arquivo de importa็ใo." +Chr(13)+Chr(10))
				nContLi:=val(nContLi)
				_Continua := .F.
				_nErro++
			endif
			
		Endif
		
		
		// *********************************************** PEDIDO DE VENDA ******************************************************
		
		if _Continua      /////////////////  cria o pedido de vendas
			
			Dbselectarea("SC5")
			Dbsetorder(8)
			
			IF !empty(aArquivo[i,1]) .and. Dbseek(xFilial("SC5")+aArquivo[i,1]) //////////.and. 1==2  ////  1==2 esta assim para nunca encontrar o pedido
				Dbselectarea("SC6")
				cArqNtx  := CriaTrab(NIL,.f.)
				cIndCond :="C6_FILIAL + C6_PRODUTO + C6_CLI + C6_CLVLDB"
				IndRegua("SC6",cArqNtx,cIndCond,,,"")
				
				cProduto:= cB1COD
				
				IF !empty(aArquivo[i,1]) .and. Dbseek(xFilial("SC6")+cProduto+SA1->A1_COD+_cOperPv)        /////  ver aarquivo
					FWrite(nLog,"Pedido de Vendas ja existe, portanto esse item nao foi alterado nem regravado. Resgate Numero "+_cCpfCgc+Chr(13)+Chr(10))
					_Continua := .F.
					_nErro++
				Else
					if cProcessa = 1 //// Chamada da Gera็ao do PV
						_Continua  := CriaPV(i)
					endif
					IF !_Continua
						nContLi:=cvaltochar(nContLi)
						FWrite(nLog,"Problema na criacao do Pedido de venda para o CPF: "+_cCpfCgc+", Linha: "+nContLi+ " do arquivo de importacao."+Chr(13)+Chr(10))
						nContLi:=val(nContLi)
						_Continua := .F.
						_nErro++
					else
						ConOut("LOG Registro do Pedido: " + SC5->C5_NUM )
					endif
				endif
			else
				if cProcessa = 1 //// Chamada da Gera็ao do PV
					_Continua  := CriaPV(i)// Passa com parametro devido ao escopo Local
				Endif
				IF !_Continua
					nContLi:=cvaltochar(nContLi)
					FWrite(nLog,"Problema na criacao do Pedido de venda  para o CPF: "+_cCpfCgc+", Linha: "+nContLi+ " do arquivo de importacao."+Chr(13)+Chr(10))
					nContLi:=val(nContLi)
					_Continua := .F.
					_nErro++
				else
					ConOut("LOG Registro do Pedido: " + SC5->C5_NUM )
				endif
			endif
		endif
	endif
	
Next i

FClose(nLog)

If _nErro > 0
	MsgAlert("Houveram erros na rotina, favor consultar o arquivo de log no caminho C:\tmp\CSU\LOG_PEDV\"+DToS(dDataBase)+".LOG")
Else
	MsgAlert("Processamento concluํdo.")
EndIf

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ AtuSA1   บ Autor ณ TOTVS              บ Data ณ 13/10/2014  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Grava/Atualiza Clientes (SA1)						      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AtuSA1(i,_Encontrou)

Local cCodMun:=""
Public cEst:=""

if _Encontrou           /////  Encontrou o cliente nao troca numero
	nOpcAuto := 4
	cCodCli := SA1->A1_COD
	cLoja   := "01"
Else
	nOpcAuto := 3
	//cCodCli := NextNumero("SA1",1,"A1_COD",.T.)    
	cCodCli :=	GetSxeNum( "SA1", "A1_COD" )
	cLoja   := "01"
Endif

//// Corre็ใo para Descri็ใo de Estado
cEst:=UPPER(ALLTRIM(aArquivo[i,07]))
if len(cEst) > 2
	dbSelectArea("SX5")
	dbSetOrder(1)
	If dbSeek(xFilial("SX5")+"12")
		Do While !Eof() .and. SX5->X5_FILIAL == xFilial("SX5") .and. SX5->X5_TABELA == "12"
			if aArquivo[i,7] == ALLTRIM(SX5->X5_DESCRI)
				cEst := ALLTRIM(SX5->X5_CHAVE)
				exit
			endif
			dbSkip()
		EndDo
	EndIf
endIf
//
// Pesquisa C๓digo NCM
cCCMun:=BuscaMun( aArquivo[i,6] )
//if empty(cCCMun)
//	Alert('cCCMun vazio')
//endif

aDadoscli := {}

IIF (LEN(alltrim(aArquivo[i] [01]))  > 11, cTipo:="J",cTipo:="F") 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMontando Lay-Out para execucao do MSEXECAUTO                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

aadd(aDadosCli,{"A1_COD"       	,cCodCli         		,nil})
aadd(aDadosCli,{"A1_LOJA"      	,cLoja            		,nil})
aadd(aDadosCli,{"A1_TIPO"      	,"F"              		,nil}) // Consumidor Final
aadd(aDadosCli,{"A1_PESSOA"    	,cTipo             	    ,nil})
aadd(aDadosCli,{"A1_CGC"       	,_cCpfCgc               ,nil})
aadd(aDadosCli,{"A1_INSCR"     	," "					,nil})
aadd(aDadosCli,{"A1_NOME"      	,aArquivo[i,02]			,nil})
aadd(aDadosCli,{"A1_NREDUZ"    	,aArquivo[i,03]			,nil})
aadd(aDadosCli,{"A1_END"       	,aArquivo[i,04]			,nil})
aadd(aDadosCli,{"A1_BAIRRO"    	,aArquivo[i,05]			,nil})
aadd(aDadosCli,{"A1_MUN"       	,aArquivo[i,06]			,nil})
aadd(aDadosCli,{"A1_EST"       	,cEst					,nil}) //cEst
aadd(aDadosCli,{"A1_CEP"       	,aArquivo[i,08]			,nil})
aadd(aDadosCli,{"A1_PAIS"      	,"105"  		    	,nil})
aadd(aDadosCli,{"A1_CODPAIS"   	,"01058"       			,nil})
aadd(aDadosCli,{"A1_GRPTRIB"   ,"001"       			,nil})

dbSelectArea("CC2")
dbSetOrder(1)
If dbSeek(xFilial("CC2")+cEst+cCCMun)
	aadd(aDadosCli,{"A1_COD_MUN",cCCMun,nil})
EndIf

aadd(aDadosCli,{"A1_CONTATO"	,aArquivo[i,08]				,nil})
aadd(aDadosCli,{"A1_DDD"		,aArquivo[i,09]				,nil})
aadd(aDadosCli,{"A1_TEL"    	,aArquivo[i,10]				,nil})
aadd(aDadosCli,{"A1_EMAIL"  	," "	                    ,nil})
aadd(aDadosCli,{"A1_TPCLI"  	,'N'           		    	,nil})  // Campo obrigatorio para a CSU  
aadd(aDadosCli,{"A1_CONTRIB"   ,"2"       	   				,nil})

lMSHelpAuto := .t.
lMSErroAuto := .f.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณGera cliente automatico: MsExecAuto({|x,y|Mata030(x,y)},aDadosCli,nOpcAuto) ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

MsExecAuto({|x,y|Mata030(x,y)},aDadosCli,nOpcAuto)

If lMsErroAuto
	//MostraErro()
	While ( __lSx8 )
		RollBackSx8()
	EndDo
	_cErro:=criatrab(,.f.)
	_cErro:="PV"+strzero(val(substr(_cErro,3,5))-1,5)+"0.log"
	_cMsLog:=alltrim(strtran(memoread(_cErro),"  "," "))
	_cMsLog:=padr(left(_cMsLog,_nLargLog),_nLargLog)
	
	lRetorno := .F.
	FErase(_cErro+ordbagext())
	_nErro++
Else
	While ( __lSx8 )
		ConfirmSX8()
	EndDo
	lRetorno := .T.
EndIf


Return(lRetorno)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ AtuSB1บ  Autor  ณ TOTVS                บ Data ณ 13/10/2014 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Grava/Atualiza Produtos (SB1)						      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AtuSB1(i,_Encontrou)

if _Encontrou
	nOpcAuto := 4
	_cCodigoProd:=SB1->B1_COD
Else
	nOpcAuto := 3
	_cCodigoProd:=aArquivo[i,20]+"G"
Endif


aIncSB1 := {}
aAdd(aIncSB1,{"B1_COD"      ,_cCodigoProd         	,Nil}) // Codigo
aAdd(aIncSB1,{"B1_CODITE"   ,_cCodigoProd         	,Nil}) // Codigo
aAdd(aIncSB1,{"B1_DESC"     ,aArquivo[i,22]      	,Nil}) // Fixo
aAdd(aIncSB1,{"B1_TIPO"     ,'PA'                 	,Nil}) // Tipo do Produto
aAdd(aIncSB1,{"B1_UM"       ,'UN'			      	,Nil}) //
aAdd(aIncSB1,{"B1_LOCPAD"   ,"01"                 	,Nil}) //
//aAdd(aIncSB1,{"B1_PICM"     ,""                 	,Nil}) //
aAdd(aIncSB1,{"B1_IPI"      ,0                    	,Nil}) //
//aAdd(aIncSB1,{"B1_ORIGEM"   ,aArquivo[i,64]       ,Nil}) //
aAdd(aIncSB1,{"B1_MSBLQL"   ,"2"                  ,Nil}) //Inclui Desbloqueado
aAdd(aIncSB1,{"B1_CTAPCO" 	,"3050101"            ,Nil})
aAdd(aIncSB1,{"B1_X_APROV" 	,"400100"             ,Nil})
aAdd(aIncSB1,{"B1_PCOFINS" 	,7.6           		  ,Nil})
aAdd(aIncSB1,{"B1_PPIS" 	,1.65         		  ,Nil})
aAdd(aIncSB1,{"B1_IRRF" 	,"N"          		  ,Nil})
aAdd(aIncSB1,{"B1_TPREG" 	,"1"          		  ,Nil})
aAdd(aIncSB1,{"B1_GARANT" 	,"2"          		  ,Nil})
aAdd(aIncSB1,{"B1_GRTRIB" 	,"001"         		  ,Nil}) 
aAdd(aIncSB1,{"B1_LOCALIZ" 	,"N"          		  ,Nil})

//cTes:=substr(aArquivo[i,23],2,2)
//cQuery2:="SELECT ZYZ_TS,ZYZ_TE FROM "+RetSqlName('ZYZ')+" ZYZ WHERE ZYZ_CST='"+cTes+"' AND ZYZ.D_E_L_E_T_=''"
/*
U_MontaView(cQuery2,"CONS2")
DBSELECTAREA("CONS2")
CONS2->(dbGoTop())
_cTS :=ALLTRIM(CONS2->ZYZ_TS)
_cTE :=ALLTRIM(CONS2->ZYZ_TE)
DBCLOSEAREA("CONS2")
aAdd(aIncSB1,{"B1_TE" ,_cTE ,Nil}) //Inclui Tes de entrada com base na amarra็ใo
aAdd(aIncSB1,{"B1_TS" ,_cTS ,Nil}) //Inclui Tes de entrada com base na amarra็ใo
*/

lMSHelpAuto := .t.
lMSErroAuto := .f.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณGera Produto: MSExecAuto({|x,y| mata010(x,y)},aIncSB1,nOpcAuto)    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

MSExecAuto({|x,y| mata010(x,y)},aIncSB1,nOpcAuto)

if lMSErroAuto
	
	_cErro:=criatrab(,.f.)
	_cErro:="SB"+strzero(val(substr(_cErro,3,5))-1,5)+"0.log"
	_cMsLog:=alltrim(strtran(memoread(_cErro),"  "," "))
	_cMsLog:=strtran(_cMsLog,CHR(13)+CHR(10),CHR(10))
	_cMsLog:=padr(left(_cMsLog,_nLargLog),_nLargLog)
	
	lRetorno := .F.
	
	_nErro++
Else
	lRetorno := .T.
EndIf


Return(	lRetorno)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณGera Pedido de Venda: MSExecAuto( { |x, y, z| mata410(x, y, z) }, aCabec, aItens, 3 )  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Static Function CriaPV(i)

// Cabecalho do pedido

_cPedido := GetSxeNum( "SC5", "C5_NUM" )

aCabec   := {}
aPvlNfs  := {}
aBloqueio:= {}
aItens   := {}

RollBAckSx8()


DBSELECTAREA("SA1")
DBSETORDER(1)
Dbseek(xFilial("SA1") + cCodCli + cLoja)

//    2        3        4         5          6       7        8       9          10       11      12        13        14       15       16        17        18          19
// A1_CGC	A1_NOME	 A1_NREDUZ	A1_END	A1_BAIRRO  A1_MUN	A1_EST	A1_CEP	A1_CONTATO	A1_DDD	A1_TEL	A1_EMAIL	NOM_PRG   C5_CC	 C5_ITEM	C5_CLVL	 C5_X_RESG	C6_PRUNIT

aAdd( aCabec, { "C5_NUM"     , _cPedido             					, Nil })
aAdd( aCabec, { "C5_TIPO"    , "N"                  					, Nil })
aAdd( aCabec, { "C5_CLIENTE" , SA1->A1_COD      						, Nil })
aAdd( aCabec, { "C5_LOJACLI" , cLoja		        					, Nil })
aAdd( aCabec, { "C5_LOJAENT" , cLoja 		     						, Nil })
aAdd( aCabec, { "C5_CONDPAG" , "030"			 						, Nil })
aAdd( aCabec, { "C5_PESOL"   , 0 						 	            , Nil })
aAdd( aCabec, { "C5_CC"      , Strzero(Val(Alltrim(aArquivo[i,13])),10)	, Nil })
aAdd( aCabec, { "C5_ITEM"    , Strzero(Val(Alltrim(aArquivo[i,14])),4) 	, Nil })  
aAdd( aCabec, { "C5_CLVL"    , Strzero(Val(Alltrim(aArquivo[i,15])),9) 	, Nil })  
aAdd( aCabec, { "C5_AREA"    , _cArea                 					, Nil })  // Campo Obrigatorio
aAdd( aCabec, { "C5_TIPLIB"  , "1"             	    					, Nil })
aAdd( aCabec, { "C5_TPCARGA" , "2"             	   					 	, Nil })
aAdd( aCabec, { "C5_FILIAL"  , xfilial("SC5")							, Nil })
aAdd( aCabec, { "C5_EMISSAO" , dDataBase			 					, Nil })   // Data da Importa็ใo
aAdd( aCabec, { "C5_MOEDA"   , 1				    					, Nil })
aAdd( aCabec, { "C5_LIBEROK" , "S"				    					, Nil })
aAdd( aCabec, { "C5_TIPOCLI" , "F"										, Nil })
aAdd( aCabec, { "C5_X_RESG"  , Strzero(Val(Alltrim(aArquivo[i,17])),10)	, Nil })


// Contador dos itens
nx     	:= 0
aLinha	:= {}
// Senao encontrou nenhum valor assume 1
nX++

aAdd( aLinha, { "C6_ITEM"	 , StrZero( nx, 2 )											    , Nil } )
aAdd( aLinha, { "C6_UM"      , "UN" 								   	            		, Nil } )
aAdd( aLinha, { "C6_PRODUTO" , _cCodigoProd					    							, Nil } )
aAdd( aLinha, { "C6_QTDVEN"	 , val(aArquivo[i,19]) 											, Nil } )
aAdd( aLinha, { "C6_PRCVEN"	 , Val(StrTran(StrTran(aArquivo[i,20],".",""),",","."))			, Nil } )
aAdd( aLinha, { "C6_PRUNIT"	 , Val(StrTran(StrTran(aArquivo[i,20],".",""),",","."))			, Nil } )
aAdd( aLinha, { "C6_VALOR"	 , Val(StrTran(StrTran(aArquivo[i,21],".",""),",","."))		 	, Nil } ) 
aAdd( aLinha, { "C6_CALINSS" , 'N'	            		   									, Nil } )
aAdd( aLinha, { "C6_CCUSTO"  , Strzero(Val(Alltrim(aArquivo[i,13])),10)						, Nil } )
aAdd( aLinha, { "C6_ITEMD"   , Strzero(Val(Alltrim(aArquivo[i,14])),4)  					, Nil } ) 
aAdd( aLinha, { "C6_CLVLDB"  , Strzero(Val(Alltrim(aArquivo[i,15])),9)						, Nil } ) 
aAdd( aLinha, { "C6_QTDEMP"  , val(aArquivo[i,19])											, Nil } )
aAdd( aLinha, { "C6_ENTREG"  , dDataBase			      									, Nil } )
aAdd( aLinha, { "C6_QTDLIB"  , val(aArquivo[i,19]) 								 			, Nil } )
aAdd( aLinha, { "C6_TES"	 , SB1->B1_TS   			    								, Nil } )
aAdd( aLinha, { "C6_LOCAL"   , "01"					            							, Nil } )
aAdd( aLinha, { "C6_QTDLIB"  , val(aArquivo[i,19])  		  				     			, Nil } )

aAdd( aItens, aLinha )

lMSErroAuto := .f.
nSaveSX8 := GetSx8Len()

// Inclusao do pedido
MSExecAuto( { |x, y, z| mata410(x, y, z) }, aCabec, aItens, 3 ) //Inclusao

// Checa erro de rotina automatica
If lMsErroAuto
	MostraErro()
	If __lSX8
		Rollbacksx8()
	endif
	
	_cErro:=criatrab(,.f.)
	_cErro:="SC"+strzero(val(substr(_cErro,3,5))-1,5)+"0.log"
	_cMsLog:=alltrim(strtran(memoread(_cErro),"  "," "))
	_cMsLog:=strtran(_cMsLog,CHR(13)+CHR(10),CHR(10))
	_cMsLog:=padr(left(_cMsLog,_nLargLog),_nLargLog)
	
	lRetorno   :=.F.
	
	_nErro++
Else
	
	If __lSX8
		ConfirmSX8()
	endif
	
	//Libera็ao do Pedido
	
	Dbselectarea("SC9")
	Dbsetorder(1)
	IF	Dbseek(xFilial("SC9")+SC5->C5_NUM)
		While !eof() .AND. SC5->C5_NUM == SC9->C9_PEDIDO
			
			If ( SC9->C9_BLCRED $ "01/02/04/05/06/09"  .And. SC9->C9_BLEST $ "02/03" )
				Begin Transaction
				a460Estorna(.T.)
				End Transaction
			endif
			Dbselectarea("SC9")
			Dbskip()
		ENDDO
	ENDIF
	lRetorno := .T.
endif

Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxACChkCGC บAutor  ณFernando Lima       บ Data ณ  09/12/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica a validade do CNPJ/CPF sem exibir mensagem de erro บฑฑ
ฑฑบ          ณcaso o CNPJ/CPF seja invalido.                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGenerico                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function xACChkCGC( cCGC )
Local nTam, nCnt, i, j, nSum, nDIG
Local cCPF := ""
Local cDVC := ""
Local cDIG := ""
Local lRet := .F.


nTam := Len( AllTrim( cCGC ) )

cDVC := SubStr( cCGC, 13, 02 )
cCGC := SubStr( cCGC, 01, 12 )

for j := 12 to 13
	nCnt := 1
	nSum := 0
	for i := j to 1 Step -1
		nCnt++
		if nCnt > 9
			nCnt := 2
		endif
		nSum += ( val( substr( cCGC,i,1) ) * nCnt )
	next i
	nDIG := if( ( nSum % 11 ) < 2, 0, 11 - ( nSum % 11 ) )
	cCGC := cCGC + STR( nDIG, 1 )
	cDIG := cDIG + STR( nDIG, 1 )
next j

lRet := cDIG == cDVC

if !lRet
	if nTam < 14
		cDVC := SubStr( cCGC, 10, 2 )
		cCPF := SubStr( cCGC, 01, 9 )
		cDIG := ""
		
		for j := 10 to 11
			nCnt := j
			nSum := 0
			for i:= 1 to len( trim( cCPF ) )
				nSum += ( Val( SubStr( cCPF, i, 1 ) ) * nCnt )
				nCnt--
			next i
			nDIG := if( ( nSum % 11 ) < 2, 0, 11 - ( nSum % 11 ) )
			cCPF := cCPF + STR( nDIG, 1 )
			cDIG := cDIG + STR( nDIG, 1 )
		next j
		
		lRet := cDIG == cDVC
	endif
endif

Return lRet

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVALARQ: Valida o Arquivo											  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Static  Function Valarq(_Arq, _Ordem, _Chave)

_Retorno := .F.

Dbselectarea(_arq)
Dbsetorder(_Ordem)
IF dbseek(xFilial(_arq)+_Chave)
	_Retorno := .T.
ENDIF

Return(_Retorno)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณBUSCAMUN: Busca o C๓digo do Municipio							  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Static Function BuscaMun(cMun)

Local _aArea  := GetArea()
Local cCodMuni:= ''

dbSelectArea("CC2")
dbSetOrder(4)
If dbSeek(xFilial("CC2") +cEst+cMun)
	cCodMuni:= CC2->CC2_CODMUNI
EndIf

RestArea(_aArea)

RETURN (cCodMuni)

