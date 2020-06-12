#INCLUDE "rwmake.ch"
#include "_FixSX.ch"
#include "TOPCONN.CH"
#include "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA72   บ Autor ณ Patricia Fontanezi บ Data ณ  29/01/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Importacao de Extrato Bancario - BCO DO BRASIL E ITAU      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/    

USER FUNCTION CFINA72()   

// TELA DE SELEวรO DO BANCO A SER IMPORTADO
Local lRet  := .F.
Local oOk   := LoadBitmap( GetResources(), "LBOK" )
Local oNo   := LoadBitmap( GetResources(), "LBNO" )

aBanco	:= {}

aAdd(aBanco,{.F.,"001","Banco do Brasil"	})
aAdd(aBanco,{.F.,"341","Banco Itau"			})

DEFINE MSDIALOG oDlg FROM  31,58 TO 300,500 TITLE "Qual Banco Deseja Importar o Extrato?" PIXEL
@ 05,05 LISTBOX oLbx1 FIELDS HEADER "","Banco","Nome" SIZE 215, 85 OF oDlg PIXEL ON DBLCLICK (U_MARKIMP())
	
oLbx1:SetArray(aBanco)
oLbx1:bLine := { || {If(aBanco[oLbx1:nAt,1],oOk,oNo),aBanco[oLbx1:nAt,2],aBanco[oLbx1:nAt,3] } }
oLbx1:nFreeze  := 1
	
DEFINE SBUTTON FROM 94, 150 TYPE 1  ENABLE OF oDlg ACTION Processa({||  U_ImpBancos() },"Processando Registros...")
DEFINE SBUTTON FROM 94, 190 TYPE 2  ENABLE OF oDlg ACTION (lRet :=.F.,oDlg:End())
	
ACTIVATE MSDIALOG oDlg CENTERED


RETURN 



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImpBancos บ Autor ณ Patricia Fontanezi บ Data ณ  29/01/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Leitura do Arquivo para Importacao do Banco Brasil e Itau  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
     
USER FUNCTION IMPBANCOS()

Private _nI	:= 0  

If aBanco[oLbx1:nAt,2] == "001"
	U_IMPBRASIL()
ENDIF

If aBanco[oLbx1:nAt,2] == "341"
	U_IMPITAU()
ENDIF

RETURN

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIMPITAU   บ Autor ณ Patricia Fontanezi บ Data ณ  29/01/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Leitura do Arquivo para Importacao ITAU                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
USER FUNCTION IMPITAU()

Local _nSZM	:= 0

If cEmpant == '01' //SP 
  	cDirect    := "\arq_txt\tesouraria\Importacao\Itau\Debito\"
	cDirectImp := "\arq_txt\tesouraria\Importacao\Itau\Backup\" 
ElseIf cEmpant == '03' //RJ
  	cDirect    := "\arq_txtrj\tesouraria\Importacao\Itau\Debito\"
	cDirectImp := "\arq_txtrj\tesouraria\Importacao\Itau\Backup\" 
EndIf

aDirect    := Directory(cDirect+"*.RET")

If Empty(adirect)
	MsgAlert("Nao existe nenhum arquivo para ser Importado!!!")
	Return
EndIf

For _nI := 1 to Len(adirect)
	FT_FUSE(cDirect+adirect[_nI,1])
	FT_FGOTOP()
	cBuffer 	:=	Alltrim(FT_FREADLN())
	If Substr(cBuffer,77,3) <> aBanco[oLbx1:nAt,2] 
		alert("Arquivo nao Pertence ao Banco" + aBanco[oLbx1:nAt,3]+"!")
		Return
	EndIf
	If Len(cBuffer)< 200 .or. Len(cBuffer)> 200
		alert("Formato do arquivo Invalido!")
		Return
	EndIf
	/*|-----------------------------------------------|
	| Pula o primeiro registro                      |
	| Cabecalho                                     |
	|-----------------------------------------------|*/
	FT_FSKIP()
	ProcRegua(FT_FLASTREC())
	_lFirst := .T.
	
	Do While !FT_FEOF()
		IncProc("Processando Leitura do Arquivo Texto...")  
		
		cBuffer 	:=	Alltrim(FT_FREADLN())
		_cID	    := Substr(cBuffer,001,1) // 0-Cabecalho; 1-Detalhes; 9-Rodape
		_cCategoria := Substr(cBuffer,043,1) // Definicao de Credito/ Debito. 1-Debito, 2-Credito. Codigo da Categoria de Lancamento. EX: 102 Encargos
		_cTarifa	:= Substr(cBuffer,107,3) // Tem que ser tarifa 105
		_cTpBlq		:= Substr(cBuffer,110,04) 
		_cHist		:= Substr(cBuffer,050,25) // Historico do lancamento pelo Banco
		_cAgencia	:=	Substr(cBuffer,018,04)
		_cConta  	:=	Substr(cBuffer,032,9)  //Sem o Digito. OBS: Posicao completa seria Substr(cBuffer,30,12)
		_cDocument	:=	Substr(cBuffer,151,07) // Numero do Documento
		_cEmissao	:=	Substr(cBuffer,081,06)
		_cData 		:= ctod(SUBSTR(_cEmissao,1,2)+"/"+SUBSTR(_cEmissao,3,2)+"/"+SUBSTR(_cEmissao,5,2))
		_cValor  	:=	Substr(cBuffer,087,18)
		_dAntServ	:= DATE() - 1
								
		If _cData < DataValida(_dAntServ,.F.)
			FT_FSKIP()
			Loop
		EndIf        

			//GERACAO DO SE5                                                                   
		If _cCategoria == "1" .AND. _cTarifa $ "105|202"      //07/03/2013 - Patricia Fontanezi

			cQuery := "SELECT COUNT(*) AS NREG "
			cQuery += "FROM "+RetSQLname('SE5')+" "
			cQuery += "WHERE D_E_L_E_T_ <> '*' "
			cQuery += "AND E5_VALOR = '"+ALLTRIM(STR((VAL(_cValor)/100),20,2))+"' "
			cQuery += "AND E5_DOCUMEN = '"+_cDocument+"' "
			cQuery += "AND E5_DATA = '"+DTOS(_cData)+"' "
			TcQuery cQuery New Alias "SE5PESQ"

			If SE5PESQ->NREG > 0
				FT_FSKIP()
				SE5PESQ->(DbCloseArea())
				Loop
			Else
				SE5PESQ->(DbCloseArea())
			EndIf
            // 07/03/2013 - patricia fontanezi
			cQuery 		:= " SELECT * "
			cQuery 		+= " FROM "+RetSQLname('SZM')+" "
			cQuery 		+= " WHERE D_E_L_E_T_ <> '*' "
			cQuery 		+= " AND ZM_TIPOIMP LIKE '%"+_cTpBlq+"%' "   
			TcQuery cQuery New Alias "SZMTRB"

			If SZMTRB->(!EOF())
				_cCod		:= SZMTRB->ZM_COD
				_cMoeda		:= SZMTRB->ZM_MOEDA
				_cNaturez	:= SZMTRB->ZM_NATUREZ
				_cBenef		:= SZMTRB->ZM_BENEF
				_cHist		:= SZMTRB->ZM_HISTOR
				_cItemD		:= SZMTRB->ZM_ITEMD
				_cDebito	:= SZMTRB->ZM_DEBITO
				_cCCD		:= SZMTRB->ZM_CCD
				SZMTRB->(DbCloseArea())  
				_nSZM++
			Else
				_cCod		:= ""
				_cMoeda		:= ""
				_cNaturez	:= ""
				_cBenef		:= ""
				_cHist		:= ""
				_cItemD		:= ""
				_cDebito	:= ""
				_cCCD		:= "" 
				FT_FSKIP()
				SZMTRB->(DbCloseArea())
				Loop
			EndIf

			DbSelectArea("SA6")
			DbSetOrder(5) // FILIAL+CONTA
		   //	If DbSeek(xFilial("SA6")+alltrim(str(val(_cConta),10)),.T.)  
		   	If DbSeek(xFilial("SA6")+alltrim(str(val(_cconta))))
				If SA6->A6_COD == "341"
					RecLock("SE5",.T.)
					SE5->E5_FILIAL 		:= xFilial("SE5")
					SE5->E5_DATA 		:= _cData
					SE5->E5_XTIPO 		:= _cCod
					SE5->E5_MOEDA 		:= _cMoeda
					SE5->E5_VALOR 		:= VAL(_cValor)/100
					SE5->E5_NATUREZ		:= _cNaturez
					SE5->E5_BANCO		:= "341"
					SE5->E5_AGENCIA		:= SA6->A6_AGENCIA
					SE5->E5_CONTA		:= SA6->A6_NUMCON
					SE5->E5_DOCUMEN		:= _cDocument
					SE5->E5_BENEF		:= _cBenef
					SE5->E5_HISTOR		:= _cHist
					SE5->E5_ITEMD		:= _cItemD
					SE5->E5_DEBITO		:= _cDebito
					SE5->E5_CCD			:= _cCCD
					SE5->E5_RECPAG		:= "P"
					SE5->E5_DTDISPO		:= _cData
					SE5->E5_VENCTO		:= _cData
					SE5->E5_LA			:= "S"
					SE5->E5_DTDIGIT		:= _cData
					SE5->E5_RATEIO		:= "N"
					SE5->E5_FILORIG		:= xFilial("SE5")
					SE5->E5_MODSPB		:= "1"
					SE5->E5_CODORCA		:= "PADRAOPR"
					MsUnLock()
				EndIf
			EndIf

			//*************************************************
			//Contabiliza Lancamento Cartao
			//*************************************************
			aCab		:= {}
			aItem		:= {}
			aTotItem	:=	{}
			lMsErroAuto := .f.

			aCab := {	{"dDataLanc", _cData	,NIL},;
						{"cLote"	, "008850"	,NIL},;
						{"cSubLote"	, "001"		,NIL}}

			AADD(aItem,{	{"CT2_FILIAL"	, xFilial("CT2")											, NIL},;
							{"CT2_LINHA"	, "001"														, NIL},;
							{"CT2_DC"		, "3"	 													, NIL},;
							{"CT2_ITEMD"	, _cItemD													, NIL},;
							{"CT2_CCD"		, _cCCD														, NIL},;
							{"CT2_ITEMC"	, SA6->A6_CONTABI											, NIL},;
							{"CT2_VALOR"	, val(_cValor)/100											, NIL},;
							{"CT2_HP"		, ""														, NIL},;
							{"CT2_HIST"		, _cHist													, NIL},;
							{"CT2_TPSALD"	, "9"														, NIL},;
							{"CT2_ORIGEM"	, "210"+"                                  "+"LP 562/001"	, NIL},;
							{"CT2_MOEDLC"	, "01"														, NIL},;
							{"CT2_EMPORI"	, ""														, NIL},;
							{"CT2_ROTINA"	, ""														, NIL},;
							{"CT2_LP"		, ""														, NIL},;
							{"CT2_KEY"		, ""														, NIL}})

            U_fContab(aCab,aItem)

		EndIf
	
		FT_FSKIP()
	EndDo
	FT_FUSE()
Next

//Copia e Deleta o arquivo da pasta Origem para a pasta Importado. De qualquer Banco
For _nI := 1 to Len(adirect)
	__copyfile(cDirect+adirect[_nI,1],cDirectImp+adirect[_nI,1])
	ferase(cDirect+adirect[_nI,1])
Next

IF _nSZM == 0
	MSGINFO("Nใo houve arquivo Importado !!!")
ELSE
	MsgInfo("Importacao Finalizada com Sucesso!!!")
ENDIF

RETURN

 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIMPIBRASILบ Autor ณ Patricia Fontanezi บ Data ณ  29/01/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Leitura do Arquivo para Importacao  BANCO DO BRASIL        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
USER FUNCTION IMPBRASIL()

Local _nSZM	:= 0

If cEmpant == '01' //SP 
  	cDirect    := "\arq_txt\tesouraria\Importacao\Banco do Brasil\Debito\"
	cDirectImp := "\arq_txt\tesouraria\Importacao\Banco do Brasil\Backup\" 
ElseIf cEmpant == '03' //RJ
  	cDirect    := "\arq_txtrj\tesouraria\Importacao\Banco do Brasil\Debito\"
	cDirectImp := "\arq_txtrj\tesouraria\Importacao\Banco do Brasil\Debito\"	
EndIf

aDirect    := Directory(cDirect+"*.RET")

If Empty(adirect)
	MsgAlert("Nao existe nenhum arquivo para ser Importado!!!")
	Return
EndIf

For _nI := 1 to Len(adirect)
	FT_FUSE(cDirect+adirect[_nI,1])
	FT_FGOTOP()
	cBuffer 	:=	Alltrim(FT_FREADLN())
	If Substr(cBuffer,77,3) <> aBanco[oLbx1:nAt,2] 
		alert("Arquivo nao Pertence ao Banco" + aBanco[oLbx1:nAt,3]+"!")
		Return
	EndIf
	If Len(cBuffer)< 200 .or. Len(cBuffer)> 200
		alert("Formato do arquivo Invalido!")
		Return
	EndIf
	/*|-----------------------------------------------|
	| Pula o primeiro registro                      |
	| Cabecalho                                     |
	|-----------------------------------------------|*/
	FT_FSKIP()
	ProcRegua(FT_FLASTREC())
	_lFirst := .T.
	
	Do While !FT_FEOF()
		IncProc("Processando Leitura do Arquivo Texto...")  
		//FALTA COLOCAR AS POSICOES CONFORME LAYOUT DO BANCO DO BRASIL
		cBuffer 	:=	Alltrim(FT_FREADLN())
		_cID	    := Substr(cBuffer,001,01) // 0-Cabecalho; 1-Detalhes; 9-Rodape
		_cTpSaldo   := Substr(cBuffer,042,01) // 0-Saldo Anterior; 2-Saldo Atual
		_cCategoria := Substr(cBuffer,043,01) // Definicao de Credito/ Debito. 1-Debito, 2-Credito. Codigo da Categoria de Lancamento. EX: 201 Deposito
		_cTpBlq		:= Substr(cBuffer,046,04) // Utilizado para detectar codigo 0911 para itens Bloqueados
		_cHist		:= Substr(cBuffer,050,25) // Historico do lancamento pelo Banco        
		_cTarifa	:= Substr(cBuffer,043,3)  // Categoria do Lan็amento  
			/*|--------------------------------------------------------------------|
			  | Pula os registros de Saldo Anterior e Atual (_cTpSaldo)            |
			  |                      Rodape - 9 (_cID)                             |
			  | registros de Debito tambem nao sao importados - 1xx (_cCategoria)  |
			  |--------------------------------------------------------------------|*/
		If _cTpSaldo $ "0|2" .or. _cID == "9" .or. _cCategoria == "2" 
			FT_FSKIP()
			Loop
		EndIf

	  	If _cTpBlq == "0911" //Codigo para Lancamentos Bloqueados pelo Banco
			FT_FSKIP()
			Loop
		EndIf   

		_cAgencia	:=	Substr(cBuffer,018,04)
		_cConta  	:=	Substr(cBuffer,032,9)  // Sem o Digito. OBS: Posicao completa seria Substr(cBuffer,30,12)
	   //	_cTipo   	:=	Substr(cBuffer,043,03)
		_cDeposit	:=	ALLTRIM(STR(VAL(Substr(cBuffer,136,15)),30))  // CNPJ do Depositante
		_cDocument	:=	Substr(cBuffer,75,06)   // Numero do Documento 
		_cEmissao	:=	Substr(cBuffer,081,06)
		_cData 		:= ctod(SUBSTR(_cEmissao,1,2)+"/"+SUBSTR(_cEmissao,3,2)+"/"+SUBSTR(_cEmissao,5,2))
		_cValor  	:=	Substr(cBuffer,087,18) 		
		_dAntServ	:= DATE() - 1
								
		If _cData < DataValida(_dAntServ,.F.) 
			FT_FSKIP()
			Loop
		EndIf
			//GERACAO DO SE5                                                                   
		If _cCategoria == "1" .AND. _cTarifa $ "105|214|104|205"   // 07/03/2013 - PATRICIA FONTANEZI

			cQuery := "SELECT COUNT(*) AS NREG "
			cQuery += "FROM "+RetSQLname('SE5')+" "
			cQuery += "WHERE D_E_L_E_T_ <> '*' "
			cQuery += "AND E5_VALOR = '"+ALLTRIM(STR((VAL(_cValor)/100),20,2))+"' "
			cQuery += "AND E5_DOCUMEN = '"+_cDocument+"' "
			cQuery += "AND E5_DATA = '"+DTOS(_cData)+"' "
			TcQuery cQuery New Alias "SE5PESQ"

			If SE5PESQ->NREG > 0
				FT_FSKIP()
				SE5PESQ->(DbCloseArea())
				Loop
			Else
				SE5PESQ->(DbCloseArea())
			EndIf  
			
		// 07/03/2013 - PATRICIA FONTANEZI

			cQuery 		:= " SELECT * "
			cQuery 		+= " FROM "+RetSQLname('SZM')+" "
			cQuery 		+= " WHERE D_E_L_E_T_ <> '*' "
			cQuery 		+= " AND ZM_TIPOIMP LIKE '%"+_cTpBlq+"%' "    
			TcQuery cQuery New Alias "SZMTRB"

			If SZMTRB->(!EOF())
				_cCod		:= SZMTRB->ZM_COD
				_cMoeda		:= SZMTRB->ZM_MOEDA
				_cNaturez	:= SZMTRB->ZM_NATUREZ
				_cBenef		:= SZMTRB->ZM_BENEF
				_cHist		:= SZMTRB->ZM_HISTOR
				_cItemD		:= SZMTRB->ZM_ITEMD
				_cDebito	:= SZMTRB->ZM_DEBITO
				_cCCD		:= SZMTRB->ZM_CCD
				SZMTRB->(DbCloseArea()) 
				_nSZM++
			Else
				_cCod		:= ""
				_cMoeda		:= ""
				_cNaturez	:= ""
				_cBenef		:= ""
				_cHist		:= ""
				_cItemD		:= ""
				_cDebito	:= ""
				_cCCD		:= ""    				
				FT_FSKIP()
				SZMTRB->(DbCloseArea())
				Loop
			EndIf

			DbSelectArea("SA6")
			DbSetOrder(5) // FILIAL+CONTA
		   //	If DbSeek(xFilial("SA6")+alltrim(str(val(_cConta),10)),.T.)  
		   	If DbSeek(xFilial("SA6")+alltrim(str(val(_cconta))))
				If SA6->A6_COD == "001"
					RecLock("SE5",.T.)
					SE5->E5_FILIAL 		:= xFilial("SE5")
					SE5->E5_DATA 		:= _cData
					SE5->E5_XTIPO 		:= _cCod
					SE5->E5_MOEDA 		:= _cMoeda
					SE5->E5_VALOR 		:= VAL(_cValor)/100
					SE5->E5_NATUREZ		:= _cNaturez
					SE5->E5_BANCO		:= "001"
					SE5->E5_AGENCIA		:= SA6->A6_AGENCIA
					SE5->E5_CONTA		:= SA6->A6_NUMCON
					SE5->E5_DOCUMEN		:= _cDocument
					SE5->E5_BENEF		:= _cBenef
					SE5->E5_HISTOR		:= _cHist
					SE5->E5_ITEMD		:= _cItemD
					SE5->E5_DEBITO		:= _cDebito
					SE5->E5_CCD			:= _cCCD
					SE5->E5_RECPAG		:= "P"
					SE5->E5_DTDISPO		:= _cData
					SE5->E5_VENCTO		:= _cData
					SE5->E5_LA			:= "S"
					SE5->E5_DTDIGIT		:= _cData
					SE5->E5_RATEIO		:= "N"
					SE5->E5_FILORIG		:= xFilial("SE5")
					SE5->E5_MODSPB		:= "1"
					SE5->E5_CODORCA		:= "PADRAOPR"
					MsUnLock()
				EndIf
			EndIf

			//*************************************************
			//Contabiliza Lancamento Cartao
			//*************************************************
			aCab		:= {}
			aItem		:= {}
			aTotItem	:=	{}
			lMsErroAuto := .f.

			aCab := {	{"dDataLanc", _cData	,NIL},;
						{"cLote"	, "008850"	,NIL},;
						{"cSubLote"	, "001"		,NIL}}

			AADD(aItem,{	{"CT2_FILIAL"	, xFilial("CT2")											, NIL},;
							{"CT2_LINHA"	, "001"														, NIL},;
							{"CT2_DC"		, "3"	 													, NIL},;
							{"CT2_ITEMD"	, _cItemD													, NIL},;
							{"CT2_CCD"		, _cCCD														, NIL},;
							{"CT2_ITEMC"	, SA6->A6_CONTABI											, NIL},;
							{"CT2_VALOR"	, val(_cValor)/100											, NIL},;
							{"CT2_HP"		, ""														, NIL},;
							{"CT2_HIST"		, _cHist													, NIL},;
							{"CT2_TPSALD"	, "9"														, NIL},;
							{"CT2_ORIGEM"	, "210"+"                                  "+"LP 562/001"	, NIL},;
							{"CT2_MOEDLC"	, "01"														, NIL},;
							{"CT2_EMPORI"	, ""														, NIL},;
							{"CT2_ROTINA"	, ""														, NIL},;
							{"CT2_LP"		, ""														, NIL},;
							{"CT2_KEY"		, ""														, NIL}})

            U_fContab(aCab,aItem)

		EndIf
	
		FT_FSKIP()
	EndDo
	FT_FUSE()
Next

//Copia e Deleta o arquivo da pasta Origem para a pasta Importado. De qualquer Banco
For _nI := 1 to Len(adirect)
	__copyfile(cDirect+adirect[_nI,1],cDirectImp+adirect[_nI,1])
	ferase(cDirect+adirect[_nI,1])
Next

IF _nSZM == 0
	MSGINFO("Nใo houve arquivo Importado !!!")
ELSE
	MsgInfo("Importacao Finalizada com Sucesso!!!")
ENDIF



RETURN
