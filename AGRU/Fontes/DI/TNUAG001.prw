#include "PROTHEUS.CH"
#include "TOTVS.CH"
#include "RWMAKE.CH"
#include "TOPCONN.CH"
#include "FILEIO.CH"

//#################
//# Programa      # TNUAG001
//# Data          # 02/10/2019
//# Descrição     # Importação do TXT das notas fiscais do despachante
//#               # Tratamento com registro N02 e N04 com a TES diferencial
//# Desenvolvedor # Ricardo Pinheiro - Totvs Nacoes Unidas
//# Cliente       # AGRU
//# Observação    # 
//#===============#
//# Atualizações  # 
//#===============#-
//#################

User Function TNUAG001()
	Local btnCancel
	Local btnImp
	Local oFont1 := TFont():New("Arial",,020,,.T.,,,,,.F.,.F.)
	Local oSay2
	Local oTxtArq
	Private _aRet       := {}
	Private _aParambox  := {}
	Private lRet        := .F.
	Private oTipoImp
	Private oSay1
	Private cTxtArq 	:= space(100)
	Private cSerie 		:= PADR(SuperGetMv("FS_IMPSER",.F.,"3  "),TamSX3("F1_SERIE")[1])   
	Private nTipoImp	:= 1
	Private cCPag 		:= PADR(SuperGetMv("FS_IMPCPG",.F.,"000"),TamSx3("F1_COND")[1])   
	//Private cArm		:= PADR(SuperGetMv("FS_IMPARM",.F.,"G3"),TamSx3("D1_LOCAL")[1]) 
	
	Private oSay6
	Private oVDespe
	Private nVDespe		:= 0

	Static oDlg

	//  Parambox
	aAdd(_aParambox,{3,"Tipo ICM", Iif(Set(_SET_DELETED),1,2), {"N02-Icm normal","N04-Icm com reducao" }, 70, "", .F.})

	If Len(_aParambox) > 0
		lRet := ParamBox(_aParambox, "Escolha tipo de registro com N02 ou N04", @_aRet,,,,,,,, .T., .T. )	// Executa funcao PARAMBOX p/ obter os parametros
	Endif

	If !lRet
		MsgInfo("Cancelado pelo usuário")
		Return lRet
	Endif 

	DEFINE MSDIALOG oDlg TITLE "Importação de Arquivos" FROM 000, 000  TO 300, 300 COLORS 0, 16777215 PIXEL

	@ 008, 016 SAY oSay1 PROMPT "Importação de Arquivos Texto" SIZE 117, 011 OF oDlg FONT oFont1 COLORS 16711680, 16777215 PIXEL
	@ 025, 007 SAY oSay2 PROMPT "Selecione a pasta que está o arquivo texto:" SIZE 129, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 032, 007 MSGET oTxtArq VAR cTxtArq SIZE 123, 010 OF oDlg COLORS 0, 16777215 F3 "DIR" PIXEL

	@ 054, 007 SAY oSay6	PROMPT "Valor Despesas:"	SIZE 054, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 064, 007 MSGET oVDespe VAR nVDespe 	SIZE 049, 010 OF oDlg COLORS 0, 16777215 PIXEL PICTURE "@E 999,999,999.99"

	
	@ 133, 066 BUTTON btnImp PROMPT "&Importar" SIZE 037, 012 OF oDlg PIXEL ACTION (MsAguarde({|| ImpArq()},"Importação","Aguarde a finalização da importação..."),oDlg:End())
	@ 133, 105 BUTTON btnCancel PROMPT "&Cancelar" SIZE 037, 012 OF oDlg PIXEL ACTION oDlg:End()

	ACTIVATE MSDIALOG oDlg CENTERED


Return

// Fonte da importação.

Static Function ImpArq()

	Local cLinha 		:= ""
	Local aLinhas 		:= {}
	Local BcUf			:= ""
	Local BnNf			:= ""
	Local Bserie		:= ""
	Local BindPag		:= ""
	Local BdEmi			:= ""
	Local IcProd		:= ""
	Local IuCom			:= ""
	Local IqCom			:= ""
	Local IvUnCom		:= ""
	Local IvProd		:= ""
	Local IvFrete		:= ""
	Local IvSeg			:= ""
	Local IvDesc		:= ""
	Local ICfOp			:= ""
	Local I18nDI		:= ""
	Local I18dDI		:= ""
	Local I18xLocDesemb	:= ""
	Local I18UFDesemb	:= ""
	Local I18dDesmb		:= ""
	Local I18cExportador:= ""
	Local I25nAdicao	:= ""
	Local I25nSeqAdic	:= ""
	Local I25cFabricante:= ""
	Local I25vDescDI	:= ""
	Local N02vBC		:= ""
	Local N02pICMS		:= ""
	Local N02vICMS		:= ""
	Local O08CST		:= ""
	Local O07vIPI		:= ""
	Local O010vBC		:= ""
	Local O010pIPI		:= ""
	Local PvII			:= ""
	Local PvBC			:= ""
	Local PvDespAdu		:= ""
	Local PvIOF			:= ""
	Local PvAliqII		:= ""
	Local W02vBC		:= ""
	Local W02vICMS		:= ""
	Local W02vICMSD		:= ""
	Local W02vIFCP		:= ""
	Local W02vBCST		:= ""
	Local W02vST		:= ""
	Local W02vFCPST		:= ""
	Local W02vFCPSTR	:= ""   // W02vFCPSTRet
	Local W02vProd		:= ""
	Local W02vFrete		:= ""
	Local W02vSeg 		:= ""
	Local W02vDesc		:= ""
	Local W02vII		:= ""
	Local W02vIPI		:= ""
	Local W02vPIS		:= ""
	Local W02vCOFINS	:= ""
	Local W02vOutro		:= ""
	Local W02vNF		:= ""
	Local XmodFrete		:= ""
	Local X04CNPJ		:= ""
	Local X26qVol		:= ""
	Local X26esp		:= ""
	Local X26pesoL		:= ""
	Local X26pesoB		:= ""
	Local ZMenNota		:= ""
	Local cTes			:= ""
	Local cMsg			:= ""
	Local aCabec		:= {}
	Local aItens		:= {}
	Local aLinha		:= {}
	Local aDI			:= {}
	Local nX			:= 0
	Local nAux			:= 0
	Local ix			:= 0
	Local N04vICMS      := ""
	Local _cSerie		:= ""
	Local _cNumero		:= ""	
	Local _nPedido      := 0
	Local _nItemped     := 0
	Local nHandle		:= 0

	// Lote e Data de Validade
	Local KnLote		:= 0
	Local KDtLote		:= 0
	Local nPosH			:= 0
	Local nPos			:= 0
	Local nLH			:= 0
	Local nCont 	    := 0
	Local nQtdC			:= 0

	Local lVldLayout	:= .T.
	
	Private lMsErroAuto := .F.
	Private cMsgErro    := ""

	lVldLayout:= U_AGVLDDI(AllTrim(cTxtArq)) //Programa para
	If !(lVldLayout)
		Alert("Problema no Layout do Arquivo")
		Return
	EndIf

	nHandle := FT_FUSE (AllTrim(cTxtArq))

	If nHandle < 0
		Alert("Não foi possível abrir o arquivo especificado.")
		Return .F.
	Endif

	// Validar se é um arquivo texto da NFE pela primeira Linha
	FT_FGOTOP()
	cLinha := FT_FREADLN()
	If !("NOTA FISCAL" $ cLinha) 
		If !("NOTAFISCAL" $ cLinha)
			Alert ("Arquivo não é de nota fiscal!")
			Return .F.
		Endif
	EndIf

	FT_FSKIP()
	While !FT_FEOF()

		cLinha :=	FT_FREADLN()
		aAdd(aLinhas,Separa(cLinha,"|",.T.))
		FT_FSKIP()
		If SUBSTR(cLinha, 1,1) == "H"   
			nLH  := nCont
		Endif
	EndDo

	FT_FUSE()

	If AllTrim(aLinhas[1][2]) != "4.00"
		Alert ("Layout de arquivo diferente de 4.00!"  + chr(10) + chr(13) + "Por favor verifique a arquivo.")
		Return .F.
	Endif

	// Alimentando os campos do cabeçalho
	nPos  		:= ASCAN(aLinhas, { |x| AllTrim(UPPER(x[1])) == "B" })

	If nPos > 0
		BcUf		:= iif(Len(aLinhas[nPos])>=2,aLinhas[nPos][2],"")
		BnNf		:= iif(Len(aLinhas[nPos])>=3,aLinhas[nPos][3],"")
		BindPag 	:= iif(Len(aLinhas[nPos])>=5,aLinhas[nPos][5],"")
		Bserie		:= iif(Len(aLinhas[nPos])>=6,aLinhas[nPos][7],"")
		BdEmi		:= iif(Len(aLinhas[nPos])>=9,aLinhas[nPos][9],"")			
	Endif

	aAdd(aCabec, {"F1_FORMUL","S"}) 
	aAdd(aCabec, {"F1_EMISSAO", dDataBase }) 
	aAdd(aCabec, {"F1_TIPO", "N"}) // ok
	aAdd(aCabec, {"F1_DTDIGIT", dDataBase})
	aAdd(aCabec, {"F1_ESPECIE", "SPED" })

	nPos  		:= ASCAN(aLinhas, { |x| AllTrim(UPPER(x[1])) == "W02" })
	If nPos > 0	
		W02vBC		:= iif(Len(aLinhas[nPos])>=2,aLinhas[nPos][2],"")
		W02vICMS	:= iif(Len(aLinhas[nPos])>=3,aLinhas[nPos][3],"")
		W02vICMSD	:= iif(Len(aLinhas[nPos])>=4,aLinhas[nPos][4],"")    // vICMSDeson
		W02vIFCP	:= iif(Len(aLinhas[nPos])>=5,aLinhas[nPos][5],"")  
		W02vBCST	:= iif(Len(aLinhas[nPos])>=6,aLinhas[nPos][6],"")
		W02vST		:= iif(Len(aLinhas[nPos])>=7,aLinhas[nPos][7],"") 
		W02vFCPST	:= iif(Len(aLinhas[nPos])>=8,aLinhas[nPos][8],"") 
		W02vFCPSTR	:= iif(Len(aLinhas[nPos])>=9,aLinhas[nPos][9],"")	// vFCPSTRet
		W02vProd	:= iif(Len(aLinhas[nPos])>=10,aLinhas[nPos][10],"")
		W02vFrete	:= iif(Len(aLinhas[nPos])>=11,aLinhas[nPos][11],"")
		W02vSeg		:= iif(Len(aLinhas[nPos])>=12,aLinhas[nPos][12],"")
		W02vDesc	:= iif(Len(aLinhas[nPos])>=13,aLinhas[nPos][13],"")
		W02vII		:= iif(Len(aLinhas[nPos])>=14,aLinhas[nPos][14],"")
		W02vIPI		:= iif(Len(aLinhas[nPos])>=15,aLinhas[nPos][15],"")
		W02vDEVIPI	:= iif(Len(aLinhas[nPos])>=16,aLinhas[nPos][16],"")
		W02vPIS		:= iif(Len(aLinhas[nPos])>=17,aLinhas[nPos][17],"")
		W02vCOFINS	:= iif(Len(aLinhas[nPos])>=18,aLinhas[nPos][18],"")
		W02vOutro	:= iif(Len(aLinhas[nPos])>=19,aLinhas[nPos][19],"")
		W02vNF		:= iif(Len(aLinhas[nPos])>=20,aLinhas[nPos][20],"")
	Endif

	aAdd(aCabec,{"F1_FRETE",   Val(W02vFrete)})
	aAdd(aCabec,{"F1_SEGURO",  Val(STR(Val(W02vSeg),TamSx3("F1_SEGURO")[1],TamSx3("F1_SEGURO")[2]))})
	aAdd(aCabec,{"F1_DESCONT", Val(STR(Val(W02vDesc),TamSx3("F1_DESCONT")[1],TamSx3("F1_DESCONT")[2]))})
	aAdd(aCabec,{"F1_DESPESA", Val(W02vOutro)+nVDespe})


	nPos  		:= ASCAN(aLinhas, { |x| AllTrim(UPPER(x[1])) == "X" })

	If nPos > 0	
		xmodFrete	:= iif(Len(aLinhas[nPos])>=2,aLinhas[nPos][2],"")
		nPos  		:= ASCAN(aLinhas, { |x| AllTrim(UPPER(x[1])) == "X04" })
		x04cnpj		:= iif(Len(aLinhas[nPos])>=2,aLinhas[nPos][2],"")
		nPos  		:= ASCAN(aLinhas, { |x| AllTrim(UPPER(x[1])) == "X26" })
		x26qVol		:= iif(Len(aLinhas[nPos])>=2,aLinhas[nPos][2],"")
		x26esp		:= iif(Len(aLinhas[nPos])>=3,aLinhas[nPos][3],"")
		x26pesoL	:= iif(Len(aLinhas[nPos])>=6,aLinhas[nPos][6],"")
		x26pesoB	:= iif(Len(aLinhas[nPos])>=7,aLinhas[nPos][7],"")
	Endif

	//Mensagem para nota.	
	nPos	:= ASCAN(aLinhas, { |x| AllTrim(UPPER(x[1])) == "Z" })

	If nPos > 0 
		If Len(aLinhas[nPos]) >= 3
			ZMenNota := iif(Len(aLinhas[nPos])>=3,PADR(aLinhas[nPos][3],254),PADR("",254))
		Endif	
	Endif

	// Dialog para o usuário poder mudar a mensagem para nota.
	cMsg := PADR(zMenNota,TamSx3("F1_MENNOTA")[1])	
	DEFINE MSDIALOG oDlgx TITLE "Mensagem para nota" FROM 000, 000  TO 100, 400 COLORS 0, 16777215 PIXEL
	@ 028, 154 BUTTON oBtnOK PROMPT "&Confirmar" SIZE 037, 012 OF oDlgx PIXEL ACTION (Close(oDlgx))
	@ 014, 008 MSGET oMsg VAR cMsg SIZE 254, 010 OF oDlgx COLORS 0, 16777215 PIXEL
	@ 006, 008 SAY oSay1x PROMPT "Mensagem para nota:" SIZE 119, 007 OF oDlgx COLORS 0, 16777215 PIXEL 
	ACTIVATE MSDIALOG oDlgx CENTERED

	
	aAdd(aCabec,{"F1_TRANSP", Posicione("SA4",3,xFilial("SA4")+X04CNPJ,"A4_COD") })
	aAdd(aCabec,{"F1_MENNOTA",cMsg}) 
	aAdd(aCabec,{"F1_VOLUME1", Val(X26qVol) })
	aAdd(aCabec,{"F1_ESPECI1", X26esp })
	aAdd(aCabec,{"F1_PLIQUI", Val(X26pesoL) })
	aAdd(aCabec,{"F1_PESOL",Val(X26pesoL) })
	aAdd(aCabec,{"F1_PBRUTO",Val(X26pesoB) })

	// Fornecedor, Condição de Pagto pelo pedido de compras
	nPos	:= ASCAN(aLinhas, { |x| AllTrim(UPPER(x[1])) == "I" })
	If nPos == 0
		Alert ("Não foi encontrado linha de itens." + chr(10) + chr(13) + "Nao será possível continuar")
		Return .F.
	Else
		cPedCom 	:= iif (Len(aLinhas[nPos])>=21,aLinhas[nPos][21],"")
		cnItemPed	:= iif (Len(aLinhas[nPos])>=22,aLinhas[nPos][22],"")
	Endif

	If !Empty(cPedCom) .and. !Empty(cnItemPed)
		SC7->(DbSetOrder(1))
		If !SC7->(DbSeek(xFilial("SC7")+StrZero(Val(cPedCom),6)+StrZero(Val(cnItemPed),4)+'    '))   
			Alert ("Não foi possível encontrar o pedido de compras " + cPedCom +"-"+ cnItemPed )
			Return .F.
		Else
			cCPag   := SC7->C7_COND	
		Endif	
	Else
		Alert("Não foi encontrado numero do pedido de compra no 1° item do pedido.")
		Return .F.
	Endif	
	

	lRet := Sx5NumNota()

	If lRet
		_cSerie 	:= cSerie
		_cNumero	:= NxtSX5Nota(_cSerie) 
	Else
		Return .F.
	Endif


	SA2->(DbSetOrder(1))
	SA2->(DbSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA))

	aAdd(aCabec, 	{"F1_DOC"		,	_cNumero }) 		 
	aAdd(aCabec, 	{"F1_SERIE"		,	_cSerie }) 			 
	aAdd(aCabec,	{"F1_FORNECE"	,	SA2->A2_COD })
	aAdd(aCabec,	{"F1_LOJA"		,	SA2->A2_LOJA })
	aAdd(aCabec, 	{"F1_COND"		,	cCpag }) 		     

	// Vamos começar os itens
	nPos 	:= ASCAN(aLinhas, { |x| AllTrim(UPPER(x[1])) == "H" })
	nPosW	:= ASCAN(aLinhas, { |x| AllTrim(UPPER(x[1])) == "W" })


	For ix := nPos To nPosW
		aLinha := {}
		If !Alltrim(aLinhas[nPos][1]) == "H"
			// Ir até o H 
			While Alltrim(aLinhas[nPos][1]) <> "H" .and. nPos < nPosW
				nPos++
			EndDo
		Endif

		If nPos >= nPosW
			Exit
		Endif

		nPos++    

		If nPos > 0 		
			IcProd		:= iif (Len(aLinhas[nPos])>=2,aLinhas[nPos][2]		,"")
			iCFOP		:= iif (Len(aLinhas[nPos])>=7,aLinhas[nPos][7]		,"")
			IuCom		:= iif (Len(aLinhas[nPos])>=8,aLinhas[nPos][8]		,"")
			IqCom		:= iif (Len(aLinhas[nPos])>=9,aLinhas[nPos][9]		,"")
			IvUnCom		:= iif (Len(aLinhas[nPos])>=10,aLinhas[nPos][10]	,"")
			IvProd		:= iif (Len(aLinhas[nPos])>=11,aLinhas[nPos][11]	,"")
			IvFrete		:= iif (Len(aLinhas[nPos])>=16,aLinhas[nPos][16]	,"")
			IvSeg		:= iif (Len(aLinhas[nPos])>=17,aLinhas[nPos][17]	,"")                     
			IvDesc		:= iif (Len(aLinhas[nPos])>=18,aLinhas[nPos][18]	,"")
			IxPed		:= iif (Len(aLinhas[nPos])>=21,aLinhas[nPos][21]	,"")
			InItemPed	:= iif (Len(aLinhas[nPos])>=22,aLinhas[nPos][22]	,"")						
		Endif

	
		_nPedido  := StrZero(Val(IxPed),6)
		_nItemped := StrZero(Val(InItemPed),4)
		
		// Existe um proximo H?
		nAux 	:= nPos
		If nPos < nLH
			nPosH	:= ASCAN(aLinhas, { |x| AllTrim(UPPER(x[1])) == "H" },nPos)
		Endif
		If nPos > nLH   // Se ultimo registro H for maior da posicao atual, percorrer apartir do resultado nQtdC
			nQtdC	:= nPosW - nPos
		ElseIf nPosH > 0 
			nQtdC	:= nPosH - nPos
		Else 
			nQtdC  := 0
		Endif
				
		nPos 	:= ASCAN(aLinhas, { |x| AllTrim(UPPER(x[1])) == "I18" },nPos,IIf(nQtdC > 0, nQtdC, Nil))

		If nPos > 0
			I18nDI			:= iif (Len(aLinhas[nPos])>=2,aLinhas[nPos][2]		,"")
			I18dDI			:= iif (Len(aLinhas[nPos])>=3,aLinhas[nPos][3]		,"")
			I18xLocDesemb	:= iif (Len(aLinhas[nPos])>=4,aLinhas[nPos][4]		,"")
			I18UFDesemb		:= iif (Len(aLinhas[nPos])>=5,aLinhas[nPos][5]		,"")
			I18dDesmb		:= iif (Len(aLinhas[nPos])>=6,aLinhas[nPos][6]		,"")
			I18cExportador	:= iif (Len(aLinhas[nPos])>=12,aLinhas[nPos][12]	,"")
		Else
			nPos := nAux
		Endif

		nAux := nPos
		If nPos < nLH
			nPosH	:= ASCAN(aLinhas, { |x| AllTrim(UPPER(x[1])) == "H" },nPos)
		Endif
		If nPos > nLH   // Se ultimo registro H for maior da posicao atual, percorrer apartir do resultado nQtdC
			nQtdC	:= nPosW - nPos
		ElseIf nPosH > 0  
			nQtdC	:= nPosH - nPos
		Else 
			nQtdC  := 0
		Endif
		
		nPos :=	ASCAN(aLinhas, { |x| AllTrim(UPPER(x[1])) == "I25" },nPos,IIf(nQtdC > 0, nQtdC, Nil))
		
		If nPos > 0
			I25nAdicao		:= iif (Len(aLinhas[nPos])>=2,aLinhas[nPos][2],"")
			I25nSeqAdic		:= iif (Len(aLinhas[nPos])>=3,aLinhas[nPos][3],"")
			I25cFabricante	:= iif (Len(aLinhas[nPos])>=4,aLinhas[nPos][4],"")
			I25vDescDI		:= iif (Len(aLinhas[nPos])>=5,aLinhas[nPos][5],"")
		Else
			nPos := nAux
		Endif

		// Ir até o proxima N02 
		nAux := nPos
		If nPos < nLH		
			nPosH	:= ASCAN(aLinhas, { |x| AllTrim(UPPER(x[1])) == "H" },nPos)
		Endif
		If nPos > nLH   // Se ultimo registro H for maior da posicao atual, percorrer apartir do resultado nQtdC
			nQtdC	:= nPosW - nPos
		ElseIf nPosH > 0 
			nQtdC	:= nPosH - nPos
		Else 
			nQtdC  := 0
		Endif
		
		nPos := ASCAN(aLinhas, { |x| AllTrim(UPPER(x[1])) == "N02" },nPos,IIf(nQtdC > 0, nQtdC, Nil))

		If nPos > 0
			N02vBC		:= iif (Len(aLinhas[nPos])>=5,aLinhas[nPos][5],"")
			N02pICMS	:= iif (Len(aLinhas[nPos])>=6,aLinhas[nPos][6],"")
			N02vICMS	:= iif (Len(aLinhas[nPos])>=7,aLinhas[nPos][7],"")
		Else
			nPos := nAux
		Endif

		// Ir até o proxima N04
		nAux := nPos
		If nPos < nLH		
			nPosH	:= ASCAN(aLinhas, { |x| AllTrim(UPPER(x[1])) == "H" },nPos)
		Endif
		If nPos > nLH   // Se ultimo registro H for maior da posicao atual, percorrer apartir do resultado nQtdC
			nQtdC	:= nPosW - nPos
		Elseif nPosH > 0 
			nQtdC	:= nPosH - nPos
		Else 
			nQtdC  := 0
		Endif
		
		nPos := ASCAN(aLinhas, { |x| AllTrim(UPPER(x[1])) == "N04" },nPos,IIf(nQtdC > 0, nQtdC, Nil))		 

		If nPos > 0
			N04vBC		:= iif (Len(aLinhas[nPos])>=6,aLinhas[nPos][6],"")
			N04pICMS	:= iif (Len(aLinhas[nPos])>=7,aLinhas[nPos][7],"")
			N04vICMS	:= iif (Len(aLinhas[nPos])>=8,aLinhas[nPos][8],"")
		Else
			nPos := nAux
		Endif

		// Ir até o proxima P 
		nAux := nPos 
		If nPos < nLH
			nPosH	:= ASCAN(aLinhas, { |x| AllTrim(UPPER(x[1])) == "H" },nPos)	
		Endif			
		If nPos > nLH   // Se ultimo registro H for maior da posicao atual, percorrer apartir do resultado nQtdC
			nQtdC	:= nPosW - nPos
		ElseIf nPosH > 0  
			nQtdC	:= nPosH - nPos
		Else 
			nQtdC  := 0
		Endif
		
		nPos := ASCAN(aLinhas, { |x| AllTrim(UPPER(x[1])) == "P" },nPos,IIf(nQtdC > 0, nQtdC, Nil))
		
		If nPos > 0
			PvBC		:= iif (Len(aLinhas[nPos])>=4,aLinhas[nPos][2],"")
			PvDespAdu	:= iif (Len(aLinhas[nPos])>=4,aLinhas[nPos][3],"")
			PvII		:= iif (Len(aLinhas[nPos])>=4,aLinhas[nPos][4],"")
			PvIOF		:= iif (Len(aLinhas[nPos])>=4,aLinhas[nPos][5],"")
			PvAliqII	:= iif (Len(aLinhas[nPos])>=6,aLinhas[nPos][6],"")
		Else
			nPos := nAux
		Endif

		// Ir até o proxima Q02 
		nAux := nPos
		If nPos < nLH
			nPosH	:= ASCAN(aLinhas, { |x| AllTrim(UPPER(x[1])) == "H" },nPos)	
		Endif			
		If nPos > nLH   // Se ultimo registro H for maior da posicao atual, percorrer apartir do resultado nQtdC
			nQtdC	:= nPosW - nPos
		ElseIf nPosH > 0  
			nQtdC	:= nPosH - nPos
		Else 
			nQtdC  := 0
		Endif
		
		nPos := ASCAN(aLinhas, { |x| AllTrim(UPPER(x[1])) == "Q02" },nPos,IIf(nQtdC > 0, nQtdC, Nil))	
		
		If nPos > 0 
			Q02CST	:= iif (Len(aLinhas[nPos])>=2,aLinhas[nPos][2],"")
			Q02vBC	:= iif (Len(aLinhas[nPos])>=3,aLinhas[nPos][3],"")
			Q02pPIS	:= iif (Len(aLinhas[nPos])>=4,aLinhas[nPos][4],"")
			Q02vPIS	:= iif (Len(aLinhas[nPos])>=5,aLinhas[nPos][5],"")
		Else
			nPos := nAux
		Endif


		// Ir até o proxima S02
		nAux := nPos
		If nPos < nLH
			nPosH	:= ASCAN(aLinhas, { |x| AllTrim(UPPER(x[1])) == "H" },nPos)
		Endif				
		If nPos > nLH   // Se ultimo registro H for maior da posicao atual, percorrer apartir do resultado nQtdC
			nQtdC	:= nPosW - nPos
		ElseIf nPosH > 0 
			nQtdC	:= nPosH - nPos
		Else 
			nQtdC  := 0
		Endif
		
		nPos := ASCAN(aLinhas, { |x| AllTrim(UPPER(x[1])) == "S02" },nPos,IIf(nQtdC > 0, nQtdC, Nil))
		
		If nPos > 0  			
			S02CST		:= iif (Len(aLinhas[nPos])>=3,aLinhas[nPos][2],"")
			S02vBC		:= iif (Len(aLinhas[nPos])>=3,aLinhas[nPos][3],"")
			S02pCOFINS 	:= iif (Len(aLinhas[nPos])>=2,aLinhas[nPos][4],"")
			S02vCOFINS 	:= iif (Len(aLinhas[nPos])>=2,aLinhas[nPos][5],"")
		Else
			nPos := nAux
		Endif

		aLinha := {}
		nX++		
		SB1->(DbSetOrder(1))
		SB1->(DbSeek(xFilial("SB1")+ PADR(IcProd,15 ) ) )	
//AJUSTE DAS POSIÇÕES DOS CAMPOS NO EXECAUTO DO DOCUMENTO DE ENTRADA
//ABAIXO ESTÃO AS POSIÇÕES ORIGINAIS
////      #Tratamento N02 Icm normal e N04 Icm com reducao 
//		If _aRet[1] 	== 1      // N02-Icm normal 
//			cTes := '301'
//			aAdd(aLinha,{"D1_BASEICM",Val(N02vBC), Nil }) 
//			aAdd(aLinha,{"D1_PICM",Val(N02pICMS), Nil }) 
//			aAdd(aLinha,{"D1_VALICM",Val(N02vICMS), Nil }) 	
//		ElseIf _aRet[1] == 2  	  // N04-Icm com reducao
//			cTes := '302'
//			aAdd(aLinha,{"D1_BASEICM",Val(N04vBC), Nil }) 
//			aAdd(aLinha,{"D1_PICM",Val(N04pICMS), Nil }) 
//			aAdd(aLinha,{"D1_VALICM",Val(N04vICMS), Nil }) 	
//		EndIf
//
//
//		aAdd(aLinha,{"D1_ITEM", StrZero(nX,TamSx3("D1_ITEM")[1])/*HnItem*/, Nil })
//		aAdd(aLinha,{"D1_COD",IcProd, Nil })
//		If !Empty(_nPedido) .and. !Empty(_nItemped)
//			aAdd(aLinha,{"D1_PEDIDO",_nPedido, Nil })
//			aAdd(aLinha,{"D1_ITEMPC",_nItemped, Nil })		
//		Endif
//
//		//aAdd(aLinha,{"D1_LOCAL",cArm,Nil }) // Local
//		aAdd(aLinha,{"D1_UM", Posicione("SB1",1,xFilial("SB1")+PADR(IcProd,15),"B1_UM") /*PADR(IuCom,2)*/, Nil})
//
//		aAdd(aLinha,{"D1_QUANT",Val(STR(Val(IqCom),TamSx3("D1_VUNIT")[1],TamSx3("D1_VUNIT")[2])), Nil})
//		aAdd(aLinha,{"D1_VUNIT",Val(STR(Val(IvUnCom),TamSx3("D1_VUNIT")[1],TamSx3("D1_VUNIT")[2])), Nil})
//		aAdd(aLinha,{"D1_TOTAL",Val(STR(Val(IvProd),TamSx3("D1_TOTAL")[1],TamSx3("D1_TOTAL")[2])), Nil})
//		aAdd(aLinha,{"D1_TES",cTes/*GetMv("MV_TESIMP")*/, Nil })
//
//		SC7->(DbSetOrder(1))
//		If !SC7->(DbSeek(xFilial("SC7")+StrZero(Val(cPedCom),6)+StrZero(Val(cnItemPed),4)+'    '))   
//			aAdd(aLinha,{"D1_VALFRE",SC7->C7_VALFRE, Nil})
//		endif	
//
//		If !Empty(KnLote) .and. AllTrim(Posicione("SB1",1,xFilial("SB1")+PADR(IcProd,15),"B1_RASTRO")) != "N"
//			aAdd(aLinha,{"D1_LOTEFOR",KnLote, Nil})
//		Endif		
//		If !Empty(KDtLote) .and. AllTrim(Posicione("SB1",1,xFilial("SB1")+PADR(IcProd,15),"B1_RASTRO")) != "N"
//			aAdd(aLinha,{"D1_DTVALID",STOD(Substr(StrTran(KDtLote,"-",""),1,8)), Nil})
//		Endif
//
//		aAdd(aLinha,{"D1_II",Val(STR(Val(PvII),TamSx3("D1_II")[1],TamSx3("D1_II")[2])), Nil })
//		aAdd(aLinha,{"D1_ALIQII",Round(Val(PvII)/Val(PvBC)*100,2) ,Nil })

//ABAIXO ESTÃO AS POSIÇÕES AJUSTADAS

		If _aRet[1] 	== 1      // N02-Icm normal 
			cTes := '301'
		ElseIf _aRet[1] == 2  	  // N04-Icm com reducao
			cTes := '302'
		EndIf

		aAdd(aLinha,{"D1_ITEM", StrZero(nX,TamSx3("D1_ITEM")[1]), Nil })
		aAdd(aLinha,{"D1_COD",IcProd, Nil })
		If !Empty(_nPedido) .and. !Empty(_nItemped)
			aAdd(aLinha,{"D1_PEDIDO",_nPedido, Nil })
			aAdd(aLinha,{"D1_ITEMPC",_nItemped, Nil })		
		Endif

		aAdd(aLinha,{"D1_UM", Posicione("SB1",1,xFilial("SB1")+PADR(IcProd,15),"B1_UM"), Nil})
		aAdd(aLinha,{"D1_QUANT",Val(STR(Val(IqCom),TamSx3("D1_VUNIT")[1],TamSx3("D1_VUNIT")[2])), Nil})
		aAdd(aLinha,{"D1_VUNIT",Val(STR(Val(IvUnCom),TamSx3("D1_VUNIT")[1],TamSx3("D1_VUNIT")[2])), Nil})
		aAdd(aLinha,{"D1_TOTAL",Val(STR(Val(IvProd),TamSx3("D1_TOTAL")[1],TamSx3("D1_TOTAL")[2])), Nil})
		aAdd(aLinha,{"D1_TES",cTes, Nil })

		SC7->(DbSetOrder(1))
		If !SC7->(DbSeek(xFilial("SC7")+StrZero(Val(cPedCom),6)+StrZero(Val(cnItemPed),4)+'    '))   
			aAdd(aLinha,{"D1_VALFRE",SC7->C7_VALFRE, Nil})
		endif	

		If !Empty(KnLote) .and. AllTrim(Posicione("SB1",1,xFilial("SB1")+PADR(IcProd,15),"B1_RASTRO")) != "N"
			aAdd(aLinha,{"D1_LOTEFOR",KnLote, Nil})
		Endif		

		If !Empty(KDtLote) .and. AllTrim(Posicione("SB1",1,xFilial("SB1")+PADR(IcProd,15),"B1_RASTRO")) != "N"
			aAdd(aLinha,{"D1_DTVALID",STOD(Substr(StrTran(KDtLote,"-",""),1,8)), Nil})
		Endif

		aAdd(aLinha,{"D1_ALIQII",Round(Val(PvII)/Val(PvBC)*100,2) ,Nil })
		aAdd(aLinha,{"D1_II",Val(STR(Val(PvII),TamSx3("D1_II")[1],TamSx3("D1_II")[2])), Nil })

//      #Tratamento N02 Icm normal e N04 Icm com reducao 
		If _aRet[1] 	== 1      // N02-Icm normal 
			cTes := '301'
			aAdd(aLinha,{"D1_BASEICM",Val(N02vBC), Nil }) 
			aAdd(aLinha,{"D1_PICM",Val(N02pICMS), Nil }) 
			aAdd(aLinha,{"D1_VALICM",Val(N02vICMS), Nil }) 	
		ElseIf _aRet[1] == 2  	  // N04-Icm com reducao
			cTes := '302'
			aAdd(aLinha,{"D1_BASEICM",Val(N04vBC), Nil }) 
			aAdd(aLinha,{"D1_PICM",Val(N04pICMS), Nil }) 
			aAdd(aLinha,{"D1_VALICM",Val(N04vICMS), Nil }) 	
		EndIf


		aadd(aItens,aLinha)


		aLinha := {}
		aAdd(aLinha, StrZero(nX,TamSx3("D1_ITEM")[1]))
		aAdd(aLinha,I18nDI)
		aAdd(aLinha,I18dDI)
		aAdd(aLinha,I18xLocDesemb)
		aAdd(aLinha,I18UFDesemb)
		aAdd(aLinha,I18dDesmb)
		aAdd(aLinha,I18cExportador)
		aAdd(aLinha,I25nAdicao)
		aAdd(aLinha,I25nSeqAdic)
		aAdd(aLinha,I25cFabricante)
		aAdd(aLinha,I25vDescDI)
		aAdd(aLinha,PvBC)
		aAdd(aLinha,PvDespAdu)
		aAdd(aLinha,PvIOF)
		aAdd(aDI, aLinha)

	Next ix

	If IncDoc(aCabec,aItens)
		IncDI(SF1->F1_DOC,SF1->F1_SERIE,SA2->A2_COD,SA2->A2_LOJA,aDI)    
		MsgInfo ("Importação concluída.")
	Else
		MsgInfo ("Importação não realizada.")
	Endif

Return


Static Function IncDoc(aC,aIt)

	Local aCabec 		:= aC
	Local aItens 		:= aIt
	Private lMsHelpAuto := .T.
	PRIVATE lMsErroAuto := .F.

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Abertura do ambiente                                         |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	aCabec 	:= FSAceArr(aCabec,"SF1")
	Begin TRANSACTION
		MSExecAuto({|x,y,z| MATA103(x,y,z)}, aCabec, aItens, 3)

		If !lMsErroAuto			
			cMsg := "Importação de Nota Fiscal concluída com sucesso." + Chr(13) + Chr(10) +;
			"Nota Gerada : " + SF1->F1_DOC + " Série: "  + SF1->F1_SERIE
			MsgInfo(cMsg,"Importação de Notas")
			ConfirmSX8()
		Else
			RollBackSX8()
			MostraErro()
			DisarmTransaction()
		EndIf
	End TRANSACTION

Return(!lMsErroAuto)


Static Function IncDI(cDoc,cSerie,cForn,cLoja,aDI)
	Local aAreaSF1 	:= SF1->(GetArea())
	Local aAreaCD5 	:= CD5->(GetArea())
	Local nPos		:= 0
	Local cQry		:= ""

	cQry := "SELECT D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA,D1_ITEM,D1_BASIMP6,D1_ALQIMP6,D1_VALIMP6,"
	cQry += "       D1_BASIMP5,D1_ALQIMP5,D1_VALIMP5, D1_BASEPIS, D1_ALQPIS,D1_VALPIS, D1_BASECOF, D1_ALQCOF,  "
	cQry += "       D1_VALCOF, D1_TOTAL, D1_II "
	cQry += " FROM "+RetSqlName("SD1") + " D1 "
	cQry += " WHERE D_E_L_E_T_ = ' ' "
	cQry += "   AND D1_LOJA = '"+SF1->F1_LOJA+"' "
	cQry += "   AND D1_FORNECE = '"+SF1->F1_FORNECE+"' "
	cQry += "   AND D1_SERIE = '"+SF1->F1_SERIE+"' "
	cQry += "   AND D1_DOC = '"+SF1->F1_DOC+"' "
	cQry += "   AND D1_FILIAL = '"+xFilial("SD1")+"' "

	If Select("QSD1") > 0
		QSD1->(DbCloseArea())
	Endif

	TCQUERY cQry NEW ALIAS "QSD1"

	While !Eof()

		nPos :=	ASCAN(aDI, { |x| Val(AllTrim(UPPER(x[1]))) == Val(AllTrim(QSD1->D1_ITEM)) })

		If nPos > 0

			If !Empty(aDI[nPos][2])
				DbSelectArea("CD5")
				DbSetOrder(4) //CD5_FILIAL, CD5_DOC, CD5_SERIE, CD5_FORNEC, CD5_LOJA, CD5_ITEM
				If DbSeek(xFilial("CD5")+QSD1->D1_DOC+QSD1->D1_SERIE+QSD1->D1_FORNECE+QSD1->D1_LOJA+QSD1->D1_ITEM)
					RecLock("CD5",.F.) // Alterar
				Else
					RecLock("CD5",.T.) // Inserir
				Endif

				CD5->CD5_FILIAL   := xFilial("CD5")
				CD5->CD5_DOC      := QSD1->D1_DOC
				CD5->CD5_SERIE    := QSD1->D1_SERIE
				CD5->CD5_ITEM     := QSD1->D1_ITEM
				CD5->CD5_ESPEC    := SF1->F1_ESPECIE
				CD5->CD5_FORNEC   := SF1->F1_FORNECE
				CD5->CD5_LOJA     := SF1->F1_LOJA
				CD5->CD5_TPIMP	  := "0"                
				CD5->CD5_NDI	  := aDI[nPos][2] // I18nDI
				CD5->CD5_DOCIMP	  := STRTRAN(STRTRAN(aDI[nPos][2],"/",""),"-","") // I18nDI
				CD5->CD5_LOCAL	  := "0"
				CD5->CD5_DTDI	  := STOD(Substr(StrTran(aDI[nPos][3],"-",""),1,8)) // I18dDI
				CD5->CD5_LOCDES	  := aDI[nPos][4] // I18xLocDesemb
				CD5->CD5_UFDES	  := aDI[nPos][5] // I18UFDesemb
				CD5->CD5_DTDES	  := STOD(Substr(StrTran(aDI[nPos][6],"-",""),1,8))  // I18dDesmb
				CD5->CD5_CODEXP	  := aDI[nPos][7] // I18cExportador
				CD5->CD5_NADIC	  := aDI[nPos][8] // I25nAdicao
				CD5->CD5_SQADIC	  := aDI[nPos][9] // I25nSeqAdic
				CD5->CD5_CODFAB	  := aDI[nPos][10] // I25cFabricante
				CD5->CD5_VDESDI	  := Val(aDI[nPos][11]) // I25vDescDI
				CD5->CD5_BCIMP	  := Val(aDI[nPos][12]) // PvBC
				CD5->CD5_DSPAD	  := Val(aDI[nPos][13]) // PvDespAdu
				CD5->CD5_VLRIOF	  := Val(aDI[nPos][14]) // PvIOF
				CD5->CD5_LOJFAB	  := SF1->F1_LOJA
				CD5->CD5_LOJEXP	  := SF1->F1_LOJA
				CD5->CD5_VTRANS	  := "4"
				CD5->CD5_INTERM	  := "1"
				CD5->CD5_BSPIS 	  := QSD1->D1_BASIMP6 //(Base Pis)
				CD5->CD5_ALPIS	  := QSD1->D1_ALQIMP6 //(Aliquota PIS)
				CD5->CD5_VLPIS	  := QSD1->D1_VALIMP6 //(Valor PIS)
				CD5->CD5_BSCOF	  := QSD1->D1_BASIMP5 //(Base Cofins)
				CD5->CD5_ALCOF	  := QSD1->D1_ALQIMP5 //(Aliquota Cofins)
				CD5->CD5_VLCOF	  := QSD1->D1_VALIMP5 //(Valor Cofins)
				CD5->CD5_DTPPIS	  := STOD(Substr(StrTran(aDI[nPos][3],"-",""),1,8)) //(Dta de Pg PIS)
				CD5->CD5_DTPCOF	  := STOD(Substr(StrTran(aDI[nPos][3],"-",""),1,8)) //(Dta de Pg Cof)
				CD5->CD5_BCIMP	  := IIF(QSD1->D1_II > 0 ,(QSD1->D1_TOTAL - QSD1->D1_II),0) //(Base de Calculo do Imposto de Importação) 
				CD5->CD5_VLRII	  := QSD1->D1_II //(Valor do II)
				MsUnlock()
			Endif
		Endif                   

		DbSelectArea("QSD1")
		DbSkip()
	Enddo

	QSD1->(DbCloseArea())
	RestArea(aAreaSF1)
	RestArea(aAreaCD5)
Return

// Acerta a Array de acordo com a SX3.

Static Function FSAceArr(aArrPar, cAliasSX3) 

	Local nPos       := 0 
	Local aArrAux    := {} 

	dbSelectArea("SX3") 
	dbSetOrder(1) 
	dbSeek(cAliasSX3,.T.) 
	While !Eof() .And. (SX3->X3_ARQUIVO==cAliasSX3) 

		//Acerta array com somente uma linha 
		If (nPos:= aScan(aArrPar,{|x| Alltrim(x[1]) == Alltrim(SX3->X3_CAMPO) })) <> 0 
			aadd(aArrAux,aClone(aArrPar[nPos])) 
		EndIf 

		dbSkip() 

	EndDo 

Return(aArrAux)