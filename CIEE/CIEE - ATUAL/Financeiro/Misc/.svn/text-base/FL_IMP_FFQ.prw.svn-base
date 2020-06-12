#include "rwmake.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMP_FFQ   ºAutor  ³Emerson Natali      º Data ³  15/05/2007 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Programa para realizar a importacao do FFQ                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³CIEE                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function IMP_FFQ()

Local aSays		:= {}
Local aButtons	:= {}
Local _aTitulo, _aRateio

Private lMsErroAuto := .F.		
Private _cCPF, _cNome, _cCC, _cNR, _nValor, _cContKM, _nValKM, _cContTaxi, _nValTaxi
//Private _nVCPMF // Alteracao feita em 21/01/08 por Cristiano, conforme SSI 08/015
Private _cContRef, _nValRef, _cContEst, _nValEst, _cContPed, _nValPed
Private _cCodFor := ""
Private _cLojFor := ""
Private _nCont
Private nOpca	:= 0
Private nOpc	:= 3
Private _CPREFIXO, _CNUM, _CPARCELA, _CTIPO, _CFORNECE, _CLOJA
Private	_cBco 	:= ""
Private	_cAg 	:= ""
Private	_cDAg 	:= ""
Private	_cConta := ""
Private _aArea
//Private	_cCPMF 	:= .T. // Alteracao feita em 21/01/08 por Cristiano, conforme SSI 08/015

_aErro := {}

AADD(aSays, " Este Programa tem o objetivo importar dados referentes ao  ")
AADD(aSays, " relatorio de Despesas conforme parametros definidos pelo   ")
AADD(aSays, " usuario               ")

AADD(aButtons,{1,.T.,{|o| nOpca:=1,o:oWnd:End()	}})
AADD(aButtons,{2,.T.,{|o| nOpca:=0,o:oWnd:End()	}})

FormBatch("Importacao de Dados ",aSays,aButtons)

If nOpca == 1
	Processa( {|| Import() }, "Processando Arquivos..." )
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMP_FFQ   ºAutor  ³Microsiga           º Data ³  05/16/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Import()

Do Case
	Case nOpca == 1 // Se confirmar para importacao do arquivo

	/*
	Muda o Parametro MV_PRELAN para N-Nunca.
	Todos os lancamentos que forem importados (FFQ) sao contabilizados de maneira definitiva. 
	*/
	DbSelectArea("SX6")
	DbSetOrder(1)
	If DbSeek(xFilial("SX6")+"MV_PRELAN")
		RecLock("SX6",.F.)
		SX6->X6_CONTEUD := "N"
		MsUnLock()
	EndIf

	_aTmp := {}
	aAdd(_aTmp,{"xPREFIXO"	,"C", 03,0})
	aAdd(_aTmp,{"xNUM"   	,"C", 09,0})
	aAdd(_aTmp,{"xPARCELA"	,"C", 01,0})
	aAdd(_aTmp,{"xTIPO"		,"C", 03,0})
	aAdd(_aTmp,{"xFORNECE"	,"C", 06,0})
	aAdd(_aTmp,{"xLOJA"		,"C", 01,0})
	aAdd(_aTmp,{"xNATUREZ"	,"C", 10,0})
	aAdd(_aTmp,{"xEMISSAO"	,"D", 08,0})
	aAdd(_aTmp,{"xVALOR"   	,"N", 14,2})

	dbCreate("TRA",_aTmp)
	dbUseArea(.T.,,"TRA","TRA",.F.)
	_cIndTMP := CriaTrab(NIL,.F.)
	_cChave  := "xPREFIXO+xNUM+xPARCELA+xTIPO+xFORNECE+xLOJA"
	IndRegua("TRA",_cIndTMP,_cChave,,,"Indice Temporario...")

	If cEmpant == '01' //SP
		cDirect    := "\arq_txt\contabilidade\FFQ\" 
		cDirectImp := "\arq_txt\contabilidade\FFQ\Importado\"
	ElseIf cEmpant == '03' //RJ
		cDirect    := "\arq_txtrj\contabilidade\FFQ\"
		cDirectImp := "\arq_txtrj\contabilidade\FFQ\Importado\"
	EndIf
	aDirect    := Directory(cDirect+"*.TXT")

	If Empty(adirect)
		msgbox("Nao existe nenhum arquivo para ser Importado!!!")
		TRA->(DbCloseArea())
		fErase("TRA.DBF")
		
		/*
		Volta o Parametro MV_PRELAN para S-Sempre.
		Todos os lancamentos volta a gerar Sempre Pre-Lancamento
		*/
		DbSelectArea("SX6")
		DbSetOrder(1)
		If DbSeek(xFilial("SX6")+"MV_PRELAN")
			RecLock("SX6",.F.)
			SX6->X6_CONTEUD := "S"
			MsUnLock()
		EndIf
		
		Return
	EndIf

	For _nIx := 1 to Len(adirect)

		FT_FUSE(cDirect+adirect[_nIx,1])
		FT_FGOTOP()
		ProcRegua(FT_FLASTREC())
	
		_nCont := 0

		Do While !FT_FEOF()

			_aArea := GetArea()
			
			/*
			Muda o Parametro MV_PRELAN para N-Nunca.
			Todos os lancamentos que forem importados (FFQ) sao contabilizados de maneira definitiva. 
			*/
			DbSelectArea("SX6")
			DbSetOrder(1)
			If DbSeek(xFilial("SX6")+"MV_PRELAN")
				RecLock("SX6",.F.)
				SX6->X6_CONTEUD := "N"
				MsUnLock()
			EndIf

			RestArea(_aArea)

			IncProc("Processando Leitura do Arquivo Texto...")
			_nCont++
			cBuffer 	:=	Alltrim(FT_FREADLN())
			_cCPF		:=	Substr(cBuffer,1,(At(";",cBuffer)-1))

			cBuffer		:=	Substr(cBuffer,(At(";",cBuffer)+1),500)
			_cNome		:=	Substr(cBuffer,1,(At(";",cBuffer)-1))

			cBuffer		:=	Substr(cBuffer,(At(";",cBuffer)+1),500)
			_cCC  		:=	Substr(cBuffer,1,(At(";",cBuffer)-1))

			cBuffer		:=	Substr(cBuffer,(At(";",cBuffer)+1),500)
			_cNR  		:=	Substr(cBuffer,1,(At(";",cBuffer)-1))

			cBuffer		:=	Substr(cBuffer,(At(";",cBuffer)+1),500)
			_nValor		:=	Substr(cBuffer,1,(At(";",cBuffer)-1))

			cBuffer		:=	Substr(cBuffer,(At(";",cBuffer)+1),500)
			_cContKM  	:=	Substr(cBuffer,1,(At(";",cBuffer)-1))

			cBuffer		:=	Substr(cBuffer,(At(";",cBuffer)+1),500)
			_nValKM  	:=	Substr(cBuffer,1,(At(";",cBuffer)-1))

			cBuffer		:=	Substr(cBuffer,(At(";",cBuffer)+1),500)
			_cContTaxi	:=	Substr(cBuffer,1,(At(";",cBuffer)-1))

			cBuffer		:=	Substr(cBuffer,(At(";",cBuffer)+1),500)
			_nValTaxi	:=	Substr(cBuffer,1,(At(";",cBuffer)-1))

			cBuffer		:=	Substr(cBuffer,(At(";",cBuffer)+1),500)
			_cContRef 	:=	Substr(cBuffer,1,(At(";",cBuffer)-1))

			cBuffer		:=	Substr(cBuffer,(At(";",cBuffer)+1),500)
			_nValRef 	:=	Substr(cBuffer,1,(At(";",cBuffer)-1))

			cBuffer		:=	Substr(cBuffer,(At(";",cBuffer)+1),500)
			_cContEst 	:=	Substr(cBuffer,1,(At(";",cBuffer)-1))

			cBuffer		:=	Substr(cBuffer,(At(";",cBuffer)+1),500)
			_nValEst 	:=	Substr(cBuffer,1,(At(";",cBuffer)-1))

			cBuffer		:=	Substr(cBuffer,(At(";",cBuffer)+1),500)
			_cContPed 	:=	Substr(cBuffer,1,(At(";",cBuffer)-1))

			cBuffer		:=	Substr(cBuffer,(At(";",cBuffer)+1),500)
			_nValPed	:=	Alltrim(cBuffer)

			_nValor 	:= Val(_nValor)/100
			_nValKM  	:= Val(_nValKM)/100
			_nValTaxi	:= Val(_nValTaxi)/100
			_nValRef	:= Val(_nValRef)/100
			_nValEst	:= Val(_nValEst)/100
			_nValPed	:= Val(_nValPed)/100
		
			DbSelectArea("SA2")
			DbSetOrder(3)
			If DbSeek(xFilial("SA2")+Alltrim(_cCPF),.F.)
				_cCodFor := SA2->A2_COD
				_cLojFor := SA2->A2_LOJA
			Else
				AADD(_aErro,{_cCPF,_cNome, "Nao Cadastrado no Sistema"}) // Novos Registros
				FT_FSKIP()
				Loop
			EndIf

			//Verifica se o registro ja foi importado
			DbSelectArea("SE2")
			DbSetOrder(1)
			If DbSeek(xFilial("SE2")+"FFQ"+_cNR+" "+"FFQ"+_cCodFor+_cLojFor,.F.)
				FT_FSKIP()
				Loop
			EndIf

			DbSelectArea("SZK") //Conta Corrente
			DbSetOrder(5)
			If DbSeek(xFilial("SZK")+_cCodFor+_cLojFor,.F.)
				Do While SZK->ZK_FORNECE+SZK->ZK_LOJA == _cCodFor+_cLojFor
					Do Case
						Case SZK->ZK_STATUS == "A" .and. SZK->ZK_TIPO == "1" //Conta Corrente
							_cBco 	:= SZK->ZK_BANCO
							_cAg 	:= SZK->ZK_AGENCIA
							_cDAg 	:= SZK->ZK_DVAG
							_cConta	:= SZK->ZK_NUMCON // CONTA CORRENTE
//							_cCPMF  := .T. // Alteracao feita em 21/01/08 por Cristiano, conforme SSI 08/015
							Exit
						Case SZK->ZK_STATUS == "A" .and. SZK->ZK_TIPO == "2" //CONTA POUPANCA
							_cBco 	:= SZK->ZK_BANCO
							_cAg 	:= SZK->ZK_AGENCIA
							_cDAg 	:= SZK->ZK_DVAG
							_cConta	:= SZK->ZK_NROPOP // CONTA POUPANCA
//							_cCPMF  := .T. // Alteracao feita em 21/01/08 por Cristiano, conforme SSI 08/015
						Case SZK->ZK_STATUS == "A" .and. SZK->ZK_TIPO == "3" // Conta Cartao
							_cBco 	:= SZK->ZK_BANCO
							_cAg 	:= SZK->ZK_AGENCIA
							_cDAg 	:= SZK->ZK_DVAG
							_cConta	:= SZK->ZK_NROCRT // CONTA CARTAO
//							_cCPMF  := .F. // Alteracao feita em 21/01/08 por Cristiano, conforme SSI 08/015
					EndCase
					DbSelectArea("SZK")
					DbSkip()
				EndDo
			EndIf

/*
			If _cCPMF // Alteracao feita em 21/01/08 por Cristiano, conforme SSI 08/015
				_nVCPMF := Round((_nValor * 0.38)/100,2)
				_nValor := Round(_nValor * 1.0038,2)
			EndIf
*/		
			_CPREFIXO 	:= 'FFQ'
			_CNUM 		:= _cNR
			_CPARCELA 	:= ' '
			_CTIPO 		:= 'FFQ'
			_CFORNECE 	:= _cCodFor
			_CLOJA 		:= _cLojFor
			_aTitulo := {		{"E2_PREFIXO", 'FFQ' 	   			, NIL},; //FIXO
								{"E2_NUM"    , _cNR					, NIL},; //Numero do Relatorio
								{"E2_PARCELA", ' '					, NIL},; //FIXO
								{"E2_TIPO"   , 'FFQ'				, NIL},; //FIXO
								{"E2_HIST"   , 'REEMB DE FFQ'		, NIL},; //FIXO
								{"E2_NATUREZ", '9.99.99'			, NIL},;
								{"E2_FORNECE", _cCodFor				, NIL},; 
								{"E2_LOJA"   , _cLojFor				, NIL},;
								{"E2_RED_CRE", '1180211'			, NIL},; //FIXO
								{"E2_EMISSAO", dDataBase			, NIL},;
								{"E2_VENCTO" , dDataBase+1			, NIL},; 
								{"E2_RATEIO" , 'S'					, NIL},; //FIXO
								{"E2_VALOR"  , _nValor				, NIL},;
								{"E2_BANCO"  , _cBco				, NIL},;
								{"E2_AGEFOR" , _cAg					, NIL},;
								{"E2_DVFOR"  , _cDAg				, NIL},;
								{"E2_DATALIB", dDATABASE			, NIL},;
								{"E2_USUALIB", SUBS(CUSUARIO,7,15)	, NIL},;
								{"E2_CTAFOR" , _cConta				, NIL}}

			Begin Transaction

			MsExecAuto({|x,y,z| FINA050(x,y,z)},_aTitulo,,3)

			If lMsErroAuto
				_aArea := GetArea()

				/*
				Volta o Parametro MV_PRELAN para S-Sempre.
				Todos os lancamentos volta a gerar Sempre Pre-Lancamento
				*/
				DbSelectArea("SX6")
				DbSetOrder(1)
				If DbSeek(xFilial("SX6")+"MV_PRELAN")
					RecLock("SX6",.F.)
					SX6->X6_CONTEUD := "S"
					MsUnLock()
				EndIf
				
				RestArea(_aArea)
				
				DisarmTransaction()
				MostraErro()
				break
			EndIf
			End Transaction
	
			FT_FSKIP()


			_aArea := GetArea()

			/*
			Volta o Parametro MV_PRELAN para S-Sempre.
			Todos os lancamentos volta a gerar Sempre Pre-Lancamento
			*/
			DbSelectArea("SX6")
			DbSetOrder(1)
			If DbSeek(xFilial("SX6")+"MV_PRELAN")
				RecLock("SX6",.F.)
				SX6->X6_CONTEUD := "S"
				MsUnLock()
			EndIf

			RestArea(_aArea)

		EndDo

		FT_FUSE()
	Next _nIx

EndCase

/*
Volta o Parametro MV_PRELAN para S-Sempre.
Todos os lancamentos volta a gerar Sempre Pre-Lancamento
*/
DbSelectArea("SX6")
DbSetOrder(1)
If DbSeek(xFilial("SX6")+"MV_PRELAN")
	RecLock("SX6",.F.)
	SX6->X6_CONTEUD := "S"
	MsUnLock()
EndIf

//Copia e Deleta o arquivo da pasta Origem para a pasta Importado. De qualquer Banco
For _nIy := 1 to Len(adirect)
	__copyfile(cDirect+adirect[_nIy,1],cDirectImp+adirect[_nIy,1])
	ferase(cDirect+adirect[_nIy,1])
Next

MsgInfo("Importacao Finalizada com sucesso!!!","Informativo")

TRA->(DbCloseArea())
fErase("TRA.DBF")

If Len(_aErro)>0
	RELERRO() // Relatorio de Divergencias
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MIGRASGV  ºAutor  ³Microsiga           º Data ³  05/15/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RELERRO()

Local cDesc1 := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2 := "de Divergencias na Importacao dos Titulos FFQ       "
Local cDesc3 := ""
Local titulo := "Divergencias na importacao dos Titulos FFQ"
Local nLin   := 80
Local Cabec1 := "    CPF             Nome"
Local Cabec2 := ""

Private lAbortPrint := .F.
Private limite      := 80
Private tamanho     := "P"
Private nomeprog    := "IMPFFQ"
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private m_pag       := 01
Private wnrel       := "IMPFFQ"
Private cString     := "SA2"

dbSelectArea("SA2")
dbSetOrder(8)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  15/05/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem

Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)

nLin := 8

For _nIw := 1 to Len(_aErro)
/*
          1         2         3         4         5         6         7         8
012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
    CPF             Nome
    XXXXXXXXX-XX    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  Nao Cadastrado no Sistema
*/
	@ nLin, 04 PSAY _aErro[_nIw,1] picture "@R 999999999-99" 	//CPF
	@ nLin, 20 PSAY Substr(_aErro[_nIw,2],1,30) 				//NOME
	@ nLin, 52 PSAY _aErro[_nIw,3] 								//Mensagem
	nLin++
	If nLin > 55
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
Next

nLin++

SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return