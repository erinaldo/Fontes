#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
    
//---------------------------------------------------------------------------------------
/*/{Protheus.doc} CFINA01
Manuten็ใo de extrato bancario
@author     Andy
@since     	05/06/03
@version  	P.11      
@return    	Nenhum
@obs        Nenhum
Altera็๕es Realizadas desde a Estrutura็ใo Inicial
------------+-----------------+----------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                                                                                 
------------+-----------------+----------------------------------------------------------
01/09/2014	|Carlos Henrique  | Padroniza็ใo do fonte para projeto de revitaliza็ใo 
------------+-----------------+----------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
User Function CFINA01() 
LOCAL aCores		:= {}
LOCAL aXIncImp		:= {	{"Incluir"		, "axinclui"  ,0,3},;
							{"Importar"		, "U_C6A02SEL"  ,0,3}}
Private cCadastro 	:= "Manuten็ใo de extratos"  
Private aRotina 	:= {	{"Pesquisar" 	, "AxPesqui"    ,0,1},;
							{"Visualizar"	, "axvisual"  	,0,2},;							
							{"Incluir"		, aXIncImp		,0,3},;
							{"Alterar"		, "axaltera"  	,0,4},;
							{"Excluir"		, "axdeleta" 	,0,5},;
							{"Legenda"      , 'U_C6A02LEG'  ,0,6},;
							{"Relatorio"	, "U_CFINR01" 	,0,7}}  
							
Aadd( aCores, { " Empty(Z8_RDR) .AND. Empty(Z8_IDENT)										"	, "BR_VERDE" 	 	} )
Aadd( aCores, { " !Empty(Z8_IDENT) .AND. Empty(Z8_RDR)										"	, "BR_AZUL" 	 	} )
Aadd( aCores, { " Empty(Z8_IRRDR).AND. Z8_IR<>0												"	, "BR_AMARELO" 	 	} )
Aadd( aCores, { "(!Empty(Z8_RDR) .AND. !Empty(Z8_IRRDR) .AND. Z8_IR<>0).OR. !Empty(Z8_RDR)	"	, "BR_VERMELHO"		} )							

dbSelectArea("SZ8")
dbSetOrder(1)
dbGoTop()
mBrowse(6,1,22,74,"SZ8",,,,,2, aCores)

Return  
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ C6A02SEL   บAutor  ณ Totvs		       บ Data ณ01/08/2014 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Tela de sele็ใo do banco a ser exportado 				  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
USER FUNCTION C6A02SEL()
Local oOk   := LoadBitmap( GetResources(), "LBOK" )
Local oNo   := LoadBitmap( GetResources(), "LBNO" )

aBanco	:= {}

aAdd(aBanco,{.F.,"001","Banco do Brasil"	})
aAdd(aBanco,{.F.,"237","Banco Bradesco"		})
aAdd(aBanco,{.F.,"341","Banco Itau"			})
aAdd(aBanco,{.F.,"356","ABN AMRO Real"		})
aAdd(aBanco,{.F.,"104","Caixa Economica"	})
aAdd(aBanco,{.F.,"033","Santander Banespa"	})


DEFINE MSDIALOG oDlg FROM  31,58 TO 300,500 TITLE "Qual Banco Deseja Importar o Extrato?" PIXEL
@ 05,05 LISTBOX oLbx1 FIELDS HEADER "","Banco","Nome" SIZE 215, 85 OF oDlg PIXEL ON DBLCLICK (C6A02MRK(@oLbx1))
	
oLbx1:SetArray(aBanco)
oLbx1:bLine := { || {If(aBanco[oLbx1:nAt,1],oOk,oNo),aBanco[oLbx1:nAt,2],aBanco[oLbx1:nAt,3] } }
oLbx1:nFreeze  := 1
	
DEFINE SBUTTON FROM 94, 150 TYPE 1  ENABLE OF oDlg ACTION Processa({||  C6A02IMP(oLbx1,aBanco) },"Processando Registros...")
DEFINE SBUTTON FROM 94, 190 TYPE 2  ENABLE OF oDlg ACTION (lRet :=.F.,oDlg:End())
	
ACTIVATE MSDIALOG oDlg CENTERED

Return     
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ C6A02MRK   บAutor  ณ Totvs		       บ Data ณ01/08/2014 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Importacao de Extrato Bancario            				  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
STATIC FUNCTION C6A02MRK(oLbx1)

If aBanco[oLbx1:nAt,1]
	aBanco[oLbx1:nAt,1] := .F.
Else
	For _nI := 1 to Len(aBanco)
		aBanco[_nI,1] := .F.	
	Next _nI
	aBanco[oLbx1:nAt,1] := .T.
EndIf
oLbx1:Refresh(.T.) 

Return
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ C6A02IMP   บAutor  ณ Totvs		       บ Data ณ01/08/2014 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Importacao de Extrato Bancario            				  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
STATIC FUNCTION C6A02IMP(oLbx1,aBanco)
LOCAL _nI	:= 0

For _nI := 1 to Len(aBanco)
	If aBanco[_nI,1]
		oLbx1:nAt := _nI
	EndIf
Next _nI

Do Case
	Case aBanco[oLbx1:nAt,2] == "001" .and. aBanco[oLbx1:nAt,1]
		
		cDirect    := "arq_txt"+cEmpant+"\tesouraria\Importacao\Banco do Brasil\"
		cDirectImp := "arq_txt"+cEmpant+"\tesouraria\Importacao\Banco do Brasil\Debito\"
			
		aDirect    := Directory(cDirect+"*.RET")

		If Empty(adirect)
			MsgAlert("Nao existe nenhum arquivo para ser Importado!!!")
			Return
		EndIf

		For _nI := 1 to Len(adirect)
			FT_FUSE(cDirect+adirect[_nI,1])
			FT_FGOTOP()
			cBuffer 	:=	Alltrim(FT_FREADLN())

			If Substr(cBuffer,77,3) <> "001"
				alert("Arquivo nao Pertence ao Banco do Brasil!")
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
				_cID	    := Substr(cBuffer,001,01) // 0-Cabecalho; 1-Detalhes; 9-Rodape
				_cTpSaldo   := Substr(cBuffer,042,01) // 0-Saldo Anterior; 2-Saldo Atual
				_cCategoria := Substr(cBuffer,043,01) // Definicao de Credito/ Debito. 1-Debito, 2-Credito. Codigo da Categoria de Lancamento. EX: 201 Deposito
				_cTpBlq		:= Substr(cBuffer,046,04) // Utilizado para detectar codigo 0911 para itens Bloqueados
				_cHist		:= Substr(cBuffer,050,25) // Historico do lancamento pelo Banco
			/*|--------------------------------------------------------------------|
			  | Pula os registros de Saldo Anterior e Atual (_cTpSaldo)            |
			  |                      Rodape - 9 (_cID)                             |
			  | registros de Debito tambem nao sao importados - 1xx (_cCategoria)  |
			  |--------------------------------------------------------------------|*/
				If _cTpSaldo $ "0|2" .or. _cID == "9" .or. _cCategoria == "1" 
					FT_FSKIP()
					Loop
				EndIf

				If _cTpBlq == "0911" //Codigo para Lancamentos Bloqueados pelo Banco
					FT_FSKIP()
					Loop
				EndIf

				_cAgencia	:=	Substr(cBuffer,018,04)
				_cConta  	:=	Substr(cBuffer,030,11)  // Sem o Digito. OBS: Posicao completa seria Substr(cBuffer,30,12)
				_cTipo   	:=	Substr(cBuffer,043,03)
				_cDeposit	:=	ALLTRIM(STR(VAL(Substr(cBuffer,136,15)),30))  // CNPJ do Depositante
				_cDocument	:=	Substr(cBuffer,75,06)   // Numero do Documento 
				_cEmissao	:=	Substr(cBuffer,081,06)
				_cData 		:= ctod(SUBSTR(_cEmissao,1,2)+"/"+SUBSTR(_cEmissao,3,2)+"/"+SUBSTR(_cEmissao,5,2))
				_cValor  	:=	Substr(cBuffer,087,18) 
				_dAntServ	:= DATE() - 1
			   
				
				// 07/03/2013 - Patricia Fontanezi
				IF _cTipo == "213" .AND. _cTpBlq == "0870"
					_cTipo	:= "45"
				ENDIF
															
			 	If _cData < DataValida(_dAntServ,.F.) 
					FT_FSKIP()
					Loop
				EndIf    
				
			/*|--------------------------------------------------------------------------------|
			  | Pesquisa registros do arquivo TXT na base SZ8 com a chave                      |
			  | EMISSAO+DOCUMENTO+VALOR+DEPOSITANTE se achou nao importa o registro novamente  |
			  |--------------------------------------------------------------------------------|*/
				cQuery 		:= " SELECT COUNT(*) AS NREG"
				cQuery 		+= " FROM "+RetSQLname('SZ8')+" "
				cQuery 		+= " WHERE D_E_L_E_T_ <> '*' "
				cQuery 		+= " AND Z8_IMPFLAG = 'S' "
				cQuery 		+= " AND Z8_EMISSAO = '"+DTOS(_cData)+"' "
				cQuery 		+= " AND Z8_NDOC  = '"+_cDocument+"' "
				cQuery 		+= " AND Z8_DEPOS = '"+Upper(Substr(_cDeposit,1,30))+"' "
				cQuery 		+= " AND Z8_VALOR = '"+ALLTRIM(STR((VAL(_cValor)/100),20,2))+"' "
				TcQuery cQuery New Alias "SZ8PESQ"

				If SZ8PESQ->NREG > 0
					FT_FSKIP()
					SZ8PESQ->(DbCloseArea())
					Loop
				Else
					SZ8PESQ->(DbCloseArea())
				EndIf

				/*
				//Alterado pelo analista Emerson dia 17/11/11.
				//Acrescentado no campo Z8_REGISTR o comando GETSXENUM("SZ8","Z8_REGISTR") para que o sistema gere automaticamente a numeracao

				cQuery := "SELECT Z8_REGISTR, SUBSTRING(Z8_REGISTR,3,15) AS NREG "
				cQuery += "FROM "+RetSQLname('SZ8')+" "
				cQuery += "ORDER BY Z8_REGISTR DESC "
				TcQuery cQuery New Alias "REGTMP"
				*/

				DbSelectArea("SA6")
				DbSetOrder(5) // FILIAL+CONTA
				If DbSeek(xFilial("SA6")+alltrim(str(val(_cConta),10)),.T.)
					If SA6->A6_COD == "001"
						RecLock("SZ8",.T.)
						SZ8->Z8_FILIAL  := xFilial("SZ8")
						SZ8->Z8_BANCO   := "001"
						SZ8->Z8_AGENCIA := SA6->A6_AGENCIA
						SZ8->Z8_CONTA   := SA6->A6_NUMCON
						SZ8->Z8_EMISSAO := _cData
						SZ8->Z8_TIPO    := _cTipo
						SZ8->Z8_DEPOS   := Upper(_cDeposit)
						SZ8->Z8_VALOR   := VAL(_cValor)/100
						SZ8->Z8_NDOC    := _cDocument
						SZ8->Z8_CCONT   := SA6->A6_CONTABI //Conta Contabil do Banco (Reduzida)
						SZ8->Z8_REGISTR := GETSXENUM("SZ8","Z8_REGISTR") //Right(Str(Year(dDataBase)),2)+strzero((val(REGTMP->NREG)+1),13) //Alterado dia 10/10/07 pelo analista Emerson 
						SZ8->Z8_IMPFLAG := "S" //Flag para definir registros Importados
						SZ8->Z8_HIST    := _cHist
						MsUnLock()				
						ConfirmSX8()
					EndIf
				EndIf
				
				/*
				DbSelectArea("REGTMP")
				DbCloseArea("REGTMP")
				*/

				FT_FSKIP()
			EndDo
			FT_FUSE()
		Next
	Case aBanco[oLbx1:nAt,2] == "237" .and. aBanco[oLbx1:nAt,1]

		cDirect    := "arq_txt"+cEmpant+"\tesouraria\Importacao\Bradesco\" 
		cDirectImp := "arq_txt"+cEmpant+"\tesouraria\Importacao\Bradesco\Backup\"
		aDirect    := Directory(cDirect+"*.RET")

		If Empty(adirect)
			MsgAlert("Nao existe nenhum arquivo para ser Importado!!!")
			Return
		EndIf

		For _nI := 1 to Len(adirect)
			FT_FUSE(cDirect+adirect[_nI,1])
			FT_FGOTOP()
			cBuffer 	:=	Alltrim(FT_FREADLN())

			If Substr(cBuffer,77,3) <> "237"
				alert("Arquivo nao Pertence ao Banco Bradesco!")
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
				_cTpSaldo   := Substr(cBuffer,042,1) // 0-Saldo Anterior; 2-Saldo Atual
				_cCategoria := Substr(cBuffer,043,1) // Definicao de Credito/ Debito. 1-Debito, 2-Credito. Codigo da Categoria de Lancamento. EX: 201 Deposito
				_cTipo   	:= Substr(cBuffer,043,3) // Pula Tipo 213 - Transferencia entre CC - Realizado via Movimento Bancario
				_cTpBlq		:= Substr(cBuffer,046,04) // Utilizado para detectar codigo 0911 para itens Bloqueados
				_cHist		:= Substr(cBuffer,050,25) // Historico do lancamento pelo Banco
			/*|--------------------------------------------------------------------|
			  | Pula os registros de Saldo Anterior e Atual (_cTpSaldo)            |
			  |                      Rodape - 9 (_cID)                             |
			  | registros de Debito tambem nao sao importados - 1xx (_cCategoria)  |
			  |--------------------------------------------------------------------|*/
				If _cTpSaldo $ "0|2" .or. _cID == "9" .or. _cCategoria == "1" .or. _cTipo $ "213|205|206"
					FT_FSKIP()
					Loop
				EndIf

				_cAgencia	:=	Substr(cBuffer,018,04)
				_cConta  	:=	Substr(cBuffer,030,11)  //Sem o Digito. OBS: Posicao completa seria Substr(cBuffer,30,12)
				_cTipo   	:=	Substr(cBuffer,043,03)
				_cDocument	:=	Substr(cBuffer,151,07) // Numero do Documento
				If _cTipo == "214" //Deposito Identificado (dinheiro/ cheque)
					_cNAGE		:= 	Substr(cBuffer,154,04) // Numero da Agencia Colhedora
					_cDeposit	:=	ALLTRIM(STR(VAL(Substr(cBuffer,106,32)),30)) // Depositante
				Else
					_cNAGE		:= 	""
					_cDeposit	:=	Substr(cBuffer,106,32) // Depositante
				EndIf
				_cEmissao	:=	Substr(cBuffer,081,06)
				_cData 		:= ctod(SUBSTR(_cEmissao,1,2)+"/"+SUBSTR(_cEmissao,3,2)+"/"+SUBSTR(_cEmissao,5,2))
				_cValor  	:=	Substr(cBuffer,087,18) 
				_dAntServ	:= DATE() - 1  				
				
				// 07/03/2013 - Patricia Fontanezi
				IF _cTipo == "209" .AND. _cTpBlq == "0051"
					_cTipo	:= "77"
				ENDIF
								
				If _cData < DataValida(_dAntServ,.F.) 
					FT_FSKIP()
					Loop
				EndIf    

			/*|--------------------------------------------------------------------------------|
			  | Pesquisa registros do arquivo TXT na base SZ8 com a chave                      |
			  | EMISSAO+DOCUMENTO+VALOR+DEPOSITANTE se achou nao importa o registro novamente  |
			  |--------------------------------------------------------------------------------|*/
				cQuery 		:= " SELECT COUNT(*) AS NREG"
				cQuery 		+= " FROM "+RetSQLname('SZ8')+" "
				cQuery 		+= " WHERE D_E_L_E_T_ <> '*' "
				cQuery 		+= " AND Z8_IMPFLAG = 'S' "
				cQuery 		+= " AND Z8_EMISSAO = '"+DTOS(_cData)+"' "
				cQuery 		+= " AND Z8_NDOC  = '"+_cDocument+"' "
				cQuery 		+= " AND Z8_DEPOS = '"+Upper(Substr(_cDeposit,1,30))+"' "
				cQuery 		+= " AND Z8_VALOR = '"+ALLTRIM(STR((VAL(_cValor)/100),20,2))+"' "
				TcQuery cQuery New Alias "SZ8PESQ"

				If SZ8PESQ->NREG > 0
					FT_FSKIP()
					SZ8PESQ->(DbCloseArea())
					Loop
				Else
					SZ8PESQ->(DbCloseArea())
				EndIf

				/*
				//Alterado pelo analista Emerson dia 17/11/11.
				//Acrescentado no campo Z8_REGISTR o comando GETSXENUM("SZ8","Z8_REGISTR") para que o sistema gere automaticamente a numeracao
				
				cQuery := "SELECT Z8_REGISTR, SUBSTRING(Z8_REGISTR,3,15) AS NREG "
				cQuery += "FROM "+RetSQLname('SZ8')+" "
				cQuery += "ORDER BY Z8_REGISTR DESC "
				TcQuery cQuery New Alias "REGTMP"
				*/

				DbSelectArea("SA6")
				DbSetOrder(5) // FILIAL+CONTA
				If DbSeek(xFilial("SA6")+alltrim(str(val(_cConta),10)),.T.)
					If SA6->A6_COD == "237"
						RecLock("SZ8",.T.)
						SZ8->Z8_FILIAL  := xFilial("SZ8")
						SZ8->Z8_BANCO   := "237"
						SZ8->Z8_AGENCIA := SA6->A6_AGENCIA
						SZ8->Z8_CONTA   := SA6->A6_NUMCON
						SZ8->Z8_EMISSAO := _cData
						SZ8->Z8_TIPO    := _cTipo
						SZ8->Z8_DEPOS   := Upper(_cDeposit)
						SZ8->Z8_VALOR   := VAL(_cValor)/100
						SZ8->Z8_NDOC    := _cDocument
						SZ8->Z8_NAGE    := _cNAGE
						SZ8->Z8_CCONT   := SA6->A6_CONTABI //Conta Contabil do Banco (Reduzida)
						SZ8->Z8_REGISTR := GETSXENUM("SZ8","Z8_REGISTR") //Right(Str(Year(dDataBase)),2)+strzero((val(REGTMP->NREG)+1),13) //Alterado dia 10/10/07 pelo analista Emerson 
						SZ8->Z8_IMPFLAG := "S" //Flag para definir registros Importados
						SZ8->Z8_HIST    := _cHist
						MsUnLock()
						ConfirmSX8()				
					EndIf
				EndIf
					
				/*
				DbSelectArea("REGTMP")
				DbCloseArea("REGTMP")
				*/

				FT_FSKIP()
			EndDo
			FT_FUSE()
		Next
	Case aBanco[oLbx1:nAt,2] == "341" .and. aBanco[oLbx1:nAt,1]

		cDirect    := "arq_txt"+cEmpant+"\tesouraria\Importacao\Itau\" 
		cDirectImp := "arq_txt"+cEmpant+"\tesouraria\Importacao\Itau\Cartao\"
		aDirect    := Directory(cDirect+"*.RET")

		If Empty(adirect)
			MsgAlert("Nao existe nenhum arquivo para ser Importado!!!")
			Return
		EndIf

		For _nI := 1 to Len(adirect)
			FT_FUSE(cDirect+adirect[_nI,1])
			FT_FGOTOP()
			cBuffer 	:=	Alltrim(FT_FREADLN())

			If Substr(cBuffer,77,3) <> "341"
				alert("Arquivo nao Pertence ao Banco Itau!")
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
				_cTpSaldo   := Substr(cBuffer,042,1) // 0-Saldo Anterior; 2-Saldo Atual
				_cCategoria := Substr(cBuffer,107,1) // Definicao de Credito/ Debito. 1-Debito, 2-Credito. Codigo da Categoria de Lancamento. EX: 201 Deposito
				_cTipo   	:= Substr(cBuffer,107,3) // Pula Tipo 213 - Transferencia entre CC - Realizado via Movimento Bancario
				_cTpBlq		:= Substr(cBuffer,110,04) // Utilizado para detectar codigo 0911 para itens Bloqueados
//				_cHist		:= Substr(cBuffer,050,25) // Historico do lancamento pelo Banco
				_cHist		:= ""
			/*|--------------------------------------------------------------------|
			  | Pula os registros de Saldo Anterior e Atual (_cTpSaldo)            |
			  |                      Rodape - 9 (_cID)                             |
			  | registros de Debito tambem nao sao importados - 1xx (_cCategoria)  |
			  |--------------------------------------------------------------------|*/
			  
				If _cTpSaldo $ "0|2" .or. _cID == "9" .or. _cCategoria == "1" .or. _cTipo $ "213"   //"209"
					FT_FSKIP()
					Loop
				EndIf

				_cAgencia	:=	Substr(cBuffer,018,04)
				_cConta  	:=	Substr(cBuffer,036,05)  //Sem o Digito. OBS: Posicao completa seria Substr(cBuffer,36,06)
				_cTipo   	:=	Substr(cBuffer,107,03)
				_cDocument	:=	Substr(cBuffer,161,04) // Numero do Documento
				_cNAGE		:= 	""
				_cDeposit	:=	Substr(cBuffer,050,25) // Depositante
				_cEmissao	:=	Substr(cBuffer,081,06)
				_cData 		:= ctod(SUBSTR(_cEmissao,1,2)+"/"+SUBSTR(_cEmissao,3,2)+"/"+SUBSTR(_cEmissao,5,2))
				_cValor  	:=	Substr(cBuffer,087,18)
 				_dAntServ	:= DATE() - 1
				
				// 07/03/2013 - Patricia Fontanezi
				IF _cTipo == "202" .AND. _cTpBlq == "0038"
					_cTipo	:= "22"
				ENDIF
								
				If _cData < DataValida(_dAntServ,.F.) 
					FT_FSKIP()
					Loop
				EndIf    
			/*|--------------------------------------------------------------------------------|
			  | Pesquisa registros do arquivo TXT na base SZ8 com a chave                      |
			  | EMISSAO+DOCUMENTO+VALOR+DEPOSITANTE se achou nao importa o registro novamente  |
			  |--------------------------------------------------------------------------------|*/
				cQuery 		:= " SELECT COUNT(*) AS NREG"
				cQuery 		+= " FROM "+RetSQLname('SZ8')+" "
				cQuery 		+= " WHERE D_E_L_E_T_ <> '*' "
				cQuery 		+= " AND Z8_IMPFLAG = 'S' "
				cQuery 		+= " AND Z8_EMISSAO = '"+DTOS(_cData)+"' "
				cQuery 		+= " AND Z8_NDOC  = '"+_cDocument+"' "
				cQuery 		+= " AND Z8_DEPOS = '"+Upper(Substr(_cDeposit,1,30))+"' "
				cQuery 		+= " AND Z8_VALOR = '"+ALLTRIM(STR((VAL(_cValor)/100),20,2))+"' "
				TcQuery cQuery New Alias "SZ8PESQ"

				If SZ8PESQ->NREG > 0
					FT_FSKIP()
					SZ8PESQ->(DbCloseArea())
					Loop
				Else
					SZ8PESQ->(DbCloseArea())
				EndIf

				/*
				//Alterado pelo analista Emerson dia 17/11/11.
				//Acrescentado no campo Z8_REGISTR o comando GETSXENUM("SZ8","Z8_REGISTR") para que o sistema gere automaticamente a numeracao

				cQuery := "SELECT Z8_REGISTR, SUBSTRING(Z8_REGISTR,3,15) AS NREG "
				cQuery += "FROM "+RetSQLname('SZ8')+" "
				cQuery += "ORDER BY Z8_REGISTR DESC "
				TcQuery cQuery New Alias "REGTMP"
				*/

				DbSelectArea("SA6")
				DbSetOrder(5) // FILIAL+CONTA
				If DbSeek(xFilial("SA6")+alltrim(str(val(_cConta),10)),.T.)
					If SA6->A6_COD == "341"
						RecLock("SZ8",.T.)
						SZ8->Z8_FILIAL  := xFilial("SZ8")
						SZ8->Z8_BANCO   := "341"
						SZ8->Z8_AGENCIA := SA6->A6_AGENCIA
						SZ8->Z8_CONTA   := SA6->A6_NUMCON
						SZ8->Z8_EMISSAO := _cData
						SZ8->Z8_TIPO    := _cTipo
						SZ8->Z8_DEPOS   := Upper(_cDeposit)
						SZ8->Z8_VALOR   := VAL(_cValor)/100
						SZ8->Z8_NDOC    := _cDocument
						SZ8->Z8_NAGE    := _cNAGE
						SZ8->Z8_CCONT   := SA6->A6_CONTABI //Conta Contabil do Banco (Reduzida)
						SZ8->Z8_REGISTR := GETSXENUM("SZ8","Z8_REGISTR") //Right(Str(Year(dDataBase)),2)+strzero((val(REGTMP->NREG)+1),13) //Alterado dia 10/10/07 pelo analista Emerson 
						SZ8->Z8_IMPFLAG := "S" //Flag para definir registros Importados
						SZ8->Z8_HIST    := _cHist
						MsUnLock()
						ConfirmSX8()
					EndIf
				EndIf
					
				/*
				DbSelectArea("REGTMP")
				DbCloseArea("REGTMP")
				*/

				FT_FSKIP()
			EndDo
			FT_FUSE()
		Next
	Case aBanco[oLbx1:nAt,2] == "356" .and. aBanco[oLbx1:nAt,1]

		cDirect    := "arq_txt"+cEmpant+"\tesouraria\Importacao\Real ABN\" 
		cDirectImp := "arq_txt"+cEmpant+"\tesouraria\Importacao\Real ABN\Backup\"
		aDirect    := Directory(cDirect+"*.TXT")

		If Empty(adirect)
			MsgAlert("Nao existe nenhum arquivo para ser Importado!!!")
			Return
		EndIf

		For _nI := 1 to Len(adirect)
			FT_FUSE(cDirect+adirect[_nI,1])
			FT_FGOTOP()
			cBuffer 	:=	Alltrim(FT_FREADLN())

			If Substr(cBuffer,77,3) <> "356"
				alert("Arquivo nao Pertence ao Banco Real!")
				Return
			EndIf

			If Len(cBuffer)< 200 .or. Len(cBuffer)> 200
				alert("Formato do arquivo Invalido!")
				Return
			EndIf
		//|-----------------------------------------------|
		//| Pula o primeiro registro                      |
		//| Cabecalho                                     |
		//|-----------------------------------------------|
			FT_FSKIP()
			ProcRegua(FT_FLASTREC())
			_lFirst := .T.

			Do While !FT_FEOF()
				IncProc("Processando Leitura do Arquivo Texto...")
				cBuffer 	:=	Alltrim(FT_FREADLN())
				_cID	    := Substr(cBuffer,001,1) // 0-Cabecalho; 1-Detalhes; 9-Rodape
				_cTpSaldo   := Substr(cBuffer,042,1) // 0-Saldo Anterior; 2-Saldo Atual
				_cCategoria := Substr(cBuffer,105,1) // Definicao de Credito/ Debito. D-Debito, C-Credito.
				_cTipo   	:= Substr(cBuffer,043,3) // Pula Tipo 213 - Transferencia entre CC - Realizado via Movimento Bancario
//				_cTpBlq		:= Substr(cBuffer,046,04) // Utilizado para detectar codigo 0911 para itens Bloqueados
				_cHist		:= ""
			//|--------------------------------------------------------------------|
			//| Pula os registros de Saldo Anterior e Atual (_cTpSaldo)            |
			//|                      Rodape - 9 (_cID)                             |
			//| registros de Debito tambem nao sao importados - 1xx (_cCategoria)  |
			//|--------------------------------------------------------------------|
			  
				If _cTpSaldo $ "0|2" .or. _cID == "9" .or. _cCategoria == "D"
					FT_FSKIP()
					Loop
				EndIf

				_cAgencia	:=	Substr(cBuffer,018,04)
				_cConta  	:=	Substr(cBuffer,023,06)  //OBS: Posicao completa seria Substr(cBuffer,22,07) Nao traz o digito.
				_cTipo   	:=	Substr(cBuffer,043,03)
				_cDocument	:=	Substr(cBuffer,075,06) // Numero do Documento
				_cNAGE		:= 	""
				_cHist		:= Substr(cBuffer,050,25)
				_cDeposit	:= ""
				_cEmissao	:=	Substr(cBuffer,081,06)
				_cData 		:= ctod(SUBSTR(_cEmissao,1,2)+"/"+SUBSTR(_cEmissao,3,2)+"/"+SUBSTR(_cEmissao,5,2))
				_cValor  	:=	Substr(cBuffer,087,18)   
				_dAntServ	:= DATE() - 1
								
				If _cData < DataValida(_dAntServ,.F.) 
					FT_FSKIP()
					Loop
				EndIf    

			//|--------------------------------------------------------------------------------|
			//| Pesquisa registros do arquivo TXT na base SZ8 com a chave                      |
			//| EMISSAO+DOCUMENTO+VALOR+DEPOSITANTE se achou nao importa o registro novamente  |
			//|--------------------------------------------------------------------------------|
				cQuery 		:= " SELECT COUNT(*) AS NREG"
				cQuery 		+= " FROM "+RetSQLname('SZ8')+" "
				cQuery 		+= " WHERE D_E_L_E_T_ <> '*' "
				cQuery 		+= " AND Z8_IMPFLAG = 'S' "
				cQuery 		+= " AND Z8_EMISSAO = '"+DTOS(_cData)+"' "
				cQuery 		+= " AND Z8_NDOC  = '"+_cDocument+"' "
				cQuery 		+= " AND Z8_DEPOS = '"+Upper(Substr(_cDeposit,1,30))+"' "
				cQuery 		+= " AND Z8_VALOR = '"+ALLTRIM(STR((VAL(_cValor)/100),20,2))+"' "
				TcQuery cQuery New Alias "SZ8PESQ"

				If SZ8PESQ->NREG > 0
					FT_FSKIP()
					SZ8PESQ->(DbCloseArea())
					Loop
				Else
					SZ8PESQ->(DbCloseArea())
				EndIf

				/*
				//Alterado pelo analista Emerson dia 17/11/11.
				//Acrescentado no campo Z8_REGISTR o comando GETSXENUM("SZ8","Z8_REGISTR") para que o sistema gere automaticamente a numeracao

				cQuery := "SELECT Z8_REGISTR, SUBSTRING(Z8_REGISTR,3,15) AS NREG "
				cQuery += "FROM "+RetSQLname('SZ8')+" "
				cQuery += "ORDER BY Z8_REGISTR DESC "
				TcQuery cQuery New Alias "REGTMP"
				*/

				DbSelectArea("SA6")
				DbSetOrder(5) // FILIAL+CONTA
				If DbSeek(xFilial("SA6")+alltrim(str(val(_cConta),10)),.T.)
					If SA6->A6_COD == "356"
						RecLock("SZ8",.T.)
						SZ8->Z8_FILIAL  := xFilial("SZ8")
						SZ8->Z8_BANCO   := "356"
						SZ8->Z8_AGENCIA := SA6->A6_AGENCIA
						SZ8->Z8_CONTA   := SA6->A6_NUMCON
						SZ8->Z8_EMISSAO := _cData
						SZ8->Z8_TIPO    := _cTipo
						SZ8->Z8_DEPOS   := Upper(_cDeposit)
						SZ8->Z8_VALOR   := VAL(_cValor)/100
						SZ8->Z8_NDOC    := _cDocument
						SZ8->Z8_NAGE    := _cNAGE
						SZ8->Z8_CCONT   := SA6->A6_CONTABI //Conta Contabil do Banco (Reduzida)
						SZ8->Z8_REGISTR := GETSXENUM("SZ8","Z8_REGISTR") //Right(Str(Year(dDataBase)),2)+strzero((val(REGTMP->NREG)+1),13) //Alterado dia 10/10/07 pelo analista Emerson 
						SZ8->Z8_IMPFLAG := "S" //Flag para definir registros Importados
						SZ8->Z8_HIST    := _cHist
						MsUnLock()
						ConfirmSX8()
					EndIf
				EndIf
					
				/*
				DbSelectArea("REGTMP")
				DbCloseArea("REGTMP")
				*/

				FT_FSKIP()
			EndDo
			FT_FUSE()
		Next
	Case aBanco[oLbx1:nAt,2] == "104" .and. aBanco[oLbx1:nAt,1]

		cDirect    := "arq_txt"+cEmpant+"\tesouraria\Importacao\Banco CEF\"
		cDirectImp := "arq_txt"+cEmpant+"\tesouraria\Importacao\Banco CEF\Backup\"
		aDirect    := Directory(cDirect+"*.RET")

		If Empty(adirect)
			MsgAlert("Nao existe nenhum arquivo para ser Importado!!!")
			Return
		EndIf

		For _nI := 1 to Len(adirect)
			FT_FUSE(cDirect+adirect[_nI,1])
			FT_FGOTOP()
			cBuffer 	:=	FT_FREADLN()

			If Substr(cBuffer,1,3) <> "104"
				alert("Arquivo nao Pertence ao Banco CEF!")
				Return
			EndIf

			If Len(cBuffer)< 240 .or. Len(cBuffer)> 240
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
				_cID	    := Substr(cBuffer,008,01) // 0-Cabecalho; 1-Cabecalho Lote (saldo anterior); 3-Detalhes; 5-Rodape Lote (saldo atual); 9-Rodape Arquivo
				_cTpLanc    := Substr(cBuffer,169,01) // Definicao do Tipo de Lancamento Credito/ Debito. D-Debito, C-Credito.
				_cHist		:= Substr(cBuffer,177,25) // Historico do lancamento pelo Banco
			/*|--------------------------------------------------------------------|
			  | Pula Cabecalho e Rodape (Arquivo e Lote)                           |
			  | Registros de Debito tambem nao sao importados - D                  |
			  |--------------------------------------------------------------------|*/
				If _cID $ "0|1|5|9" .or. _cTpLanc == "D" 
					FT_FSKIP()
					Loop
				EndIf

				_cAgencia	:=	Substr(cBuffer,054,04)
				_cConta  	:=	Substr(cBuffer,065,06) // Sem o Digito.
				_cTipo		:=	Substr(cBuffer,170,03) // Codigos de Categoria
				_cEmissao	:=	Substr(cBuffer,143,08)
				_cData 		:=	ctod(SUBSTR(_cEmissao,1,2)+"/"+SUBSTR(_cEmissao,3,2)+"/"+SUBSTR(_cEmissao,7,2))
				_cValor  	:=	Substr(cBuffer,151,18)                
   				_dAntServ	:= DATE() - 1
								
				If _cData < DataValida(_dAntServ,.F.) 
					FT_FSKIP()
					Loop
				EndIf      
				
				_cDeposit	:=	""
				_cDocument	:=	""

//				_cDeposit	:=	ALLTRIM(STR(VAL(Substr(cBuffer,136,15)),30))  // CNPJ do Depositante
				_cDocument	:=	Substr(cBuffer,202,15)   // Numero do Documento 

			/*|--------------------------------------------------------------------------------|
			  | Pesquisa registros do arquivo TXT na base SZ8 com a chave                      |
			  | EMISSAO+DOCUMENTO+VALOR+DEPOSITANTE se achou nao importa o registro novamente  |
			  |--------------------------------------------------------------------------------|*/
				cQuery 		:= " SELECT COUNT(*) AS NREG"
				cQuery 		+= " FROM "+RetSQLname('SZ8')+" "
				cQuery 		+= " WHERE D_E_L_E_T_ <> '*' "
				cQuery 		+= " AND Z8_IMPFLAG = 'S' "
				cQuery 		+= " AND Z8_EMISSAO = '"+DTOS(_cData)+"' "
				cQuery 		+= " AND Z8_NDOC  = '"+_cDocument+"' "
				cQuery 		+= " AND Z8_DEPOS = '"+Upper(Substr(_cDeposit,1,30))+"' "
				cQuery 		+= " AND Z8_VALOR = '"+ALLTRIM(STR((VAL(_cValor)/100),20,2))+"' "
				TcQuery cQuery New Alias "SZ8PESQ"

				If SZ8PESQ->NREG > 0
					FT_FSKIP()
					SZ8PESQ->(DbCloseArea())
					Loop
				Else
					SZ8PESQ->(DbCloseArea())
				EndIf

				/*
				//Alterado pelo analista Emerson dia 17/11/11.
				//Acrescentado no campo Z8_REGISTR o comando GETSXENUM("SZ8","Z8_REGISTR") para que o sistema gere automaticamente a numeracao

				cQuery := "SELECT Z8_REGISTR, SUBSTRING(Z8_REGISTR,3,15) AS NREG "
				cQuery += "FROM "+RetSQLname('SZ8')+" "
				cQuery += "ORDER BY Z8_REGISTR DESC "
				TcQuery cQuery New Alias "REGTMP"
				*/

				DbSelectArea("SA6")
				DbSetOrder(5) // FILIAL+CONTA
				If DbSeek(xFilial("SA6")+alltrim(str(val(_cConta),10)),.T.)
					If SA6->A6_COD == "104"
						RecLock("SZ8",.T.)
						SZ8->Z8_FILIAL  := xFilial("SZ8")
						SZ8->Z8_BANCO   := "104"
						SZ8->Z8_AGENCIA := SA6->A6_AGENCIA
						SZ8->Z8_CONTA   := SA6->A6_NUMCON
						SZ8->Z8_EMISSAO := _cData
						SZ8->Z8_TIPO    := _cTipo
						SZ8->Z8_DEPOS   := Upper(_cDeposit)
						SZ8->Z8_VALOR   := VAL(_cValor)/100
						SZ8->Z8_NDOC    := _cDocument
						SZ8->Z8_CCONT   := SA6->A6_CONTABI //Conta Contabil do Banco (Reduzida)
						SZ8->Z8_REGISTR := GETSXENUM("SZ8","Z8_REGISTR") //Right(Str(Year(dDataBase)),2)+strzero((val(REGTMP->NREG)+1),13)
						SZ8->Z8_IMPFLAG := "S" //Flag para definir registros Importados
						SZ8->Z8_HIST    := _cHist
						MsUnLock()
						ConfirmSX8()
					EndIf
				EndIf
				
				/*
				DbSelectArea("REGTMP")
				DbCloseArea("REGTMP")
				*/

				FT_FSKIP()
			EndDo
			FT_FUSE()
		Next
	Case aBanco[oLbx1:nAt,2] == "033" .and. aBanco[oLbx1:nAt,1]

		cDirect    := "arq_txt"+cEmpant+"\tesouraria\Importacao\Banco Santander Banespa\"
		cDirectImp := "arq_txt"+cEmpant+"\tesouraria\Importacao\Banco Santander Banespa\Backup\"
		aDirect    := Directory(cDirect+"*.TXT")

		If Empty(adirect)
			MsgAlert("Nao existe nenhum arquivo para ser Importado!!!")
			Return
		EndIf

		For _nI := 1 to Len(adirect)
			FT_FUSE(cDirect+adirect[_nI,1])
			FT_FGOTOP()
			cBuffer 	:=	FT_FREADLN()

			If Substr(cBuffer,1,3) <> "033"
				alert("Arquivo nao Pertence ao Banco Santander Banespa!")
				Return
			EndIf

			If Len(cBuffer)< 240 .or. Len(cBuffer)> 240
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
				_cID	    := Substr(cBuffer,008,01) // 0-Cabecalho; 1-Cabecalho Lote (saldo anterior); 3-Detalhes; 5-Rodape Lote (saldo atual); 9-Rodape Arquivo
				_cTpLanc    := Substr(cBuffer,169,01) // Definicao do Tipo de Lancamento Credito/ Debito. D-Debito, C-Credito.
				_cHist		:= Substr(cBuffer,177,25) // Historico do lancamento pelo Banco
			/*|--------------------------------------------------------------------|
			  | Pula Cabecalho e Rodape (Arquivo e Lote)                           |
			  | Registros de Debito tambem nao sao importados - D                  |
			  |--------------------------------------------------------------------|*/
				If _cID $ "0|1|5|9" .or. _cTpLanc == "D" 
					FT_FSKIP()
					Loop
				EndIf

				_cAgencia	:=	Substr(cBuffer,054,04)
				_cConta  	:=	Substr(cBuffer,065,06) // Sem o Digito.
				_cTipo		:=	Substr(cBuffer,170,03) // Codigos de Categoria
				_cEmissao	:=	Substr(cBuffer,143,08)
				_cData 		:=	ctod(SUBSTR(_cEmissao,1,2)+"/"+SUBSTR(_cEmissao,3,2)+"/"+SUBSTR(_cEmissao,7,2))
				_cValor  	:=	Substr(cBuffer,151,18)
   				_dAntServ	:= DATE() - 1
								
				If _cData < DataValida(_dAntServ,.F.) 
					FT_FSKIP()
					Loop
				EndIf  
				  
				_cDeposit	:=	""
				_cDocument	:=	""

//				_cDeposit	:=	ALLTRIM(STR(VAL(Substr(cBuffer,136,15)),30))  // CNPJ do Depositante
				_cDocument	:=	Substr(cBuffer,202,15)   // Numero do Documento 

			/*|--------------------------------------------------------------------------------|
			  | Pesquisa registros do arquivo TXT na base SZ8 com a chave                      |
			  | EMISSAO+DOCUMENTO+VALOR+DEPOSITANTE se achou nao importa o registro novamente  |
			  |--------------------------------------------------------------------------------|*/
				cQuery 		:= " SELECT COUNT(*) AS NREG"
				cQuery 		+= " FROM "+RetSQLname('SZ8')+" "
				cQuery 		+= " WHERE D_E_L_E_T_ <> '*' "
				cQuery 		+= " AND Z8_IMPFLAG = 'S' "
				cQuery 		+= " AND Z8_EMISSAO = '"+DTOS(_cData)+"' "
				cQuery 		+= " AND Z8_NDOC  = '"+_cDocument+"' "
				cQuery 		+= " AND Z8_DEPOS = '"+Upper(Substr(_cDeposit,1,30))+"' "
				cQuery 		+= " AND Z8_VALOR = '"+ALLTRIM(STR((VAL(_cValor)/100),20,2))+"' "
				TcQuery cQuery New Alias "SZ8PESQ"

				If SZ8PESQ->NREG > 0
					FT_FSKIP()
					SZ8PESQ->(DbCloseArea())
					Loop
				Else
					SZ8PESQ->(DbCloseArea())
				EndIf

				/*
				//Alterado pelo analista Emerson dia 17/11/11.
				//Acrescentado no campo Z8_REGISTR o comando GETSXENUM("SZ8","Z8_REGISTR") para que o sistema gere automaticamente a numeracao

				cQuery := "SELECT Z8_REGISTR, SUBSTRING(Z8_REGISTR,3,15) AS NREG "
				cQuery += "FROM "+RetSQLname('SZ8')+" "
				cQuery += "ORDER BY Z8_REGISTR DESC "
				TcQuery cQuery New Alias "REGTMP"
				*/

				DbSelectArea("SA6")
				DbSetOrder(5) // FILIAL+CONTA
				If DbSeek(xFilial("SA6")+alltrim(str(val(_cConta),10)),.T.)
					If SA6->A6_COD == "033"
						RecLock("SZ8",.T.)
						SZ8->Z8_FILIAL  := xFilial("SZ8")
						SZ8->Z8_BANCO   := "033"
						SZ8->Z8_AGENCIA := SA6->A6_AGENCIA
						SZ8->Z8_CONTA   := SA6->A6_NUMCON
						SZ8->Z8_EMISSAO := _cData
						SZ8->Z8_TIPO    := _cTipo
						SZ8->Z8_DEPOS   := Upper(_cDeposit)
						SZ8->Z8_VALOR   := VAL(_cValor)/100
						SZ8->Z8_NDOC    := _cDocument
						SZ8->Z8_CCONT   := SA6->A6_CONTABI //Conta Contabil do Banco (Reduzida)
						SZ8->Z8_REGISTR := GETSXENUM("SZ8","Z8_REGISTR") //Right(Str(Year(dDataBase)),2)+strzero((val(REGTMP->NREG)+1),13)
						SZ8->Z8_IMPFLAG := "S" //Flag para definir registros Importados
						SZ8->Z8_HIST    := _cHist
						MsUnLock()
						ConfirmSX8()
					EndIf
				EndIf
				
				/*
				DbSelectArea("REGTMP")
				DbCloseArea("REGTMP")
				*/

				FT_FSKIP()
			EndDo
			FT_FUSE()
		Next
EndCase

//Copia e Deleta o arquivo da pasta Origem para a pasta Importado. De qualquer Banco
For _nI := 1 to Len(adirect)
	If aBanco[oLbx1:nAt,2] == "341"
		__copyfile(cDirect+adirect[_nI,1],cDirectImp+adirect[_nI,1])
		cDirecCartao:= "arq_txt"+cEmpant+"\tesouraria\Importacao\Itau\Debito\"
		__copyfile(cDirect+adirect[_nI,1],cDirecCartao+adirect[_nI,1])
		ferase(cDirect+adirect[_nI,1])
	ElseIf aBanco[oLbx1:nAt,2] == "237"
		__copyfile(cDirect+adirect[_nI,1],cDirectImp+adirect[_nI,1])
		cDirecCartao:= "arq_txt"+cEmpant+"\tesouraria\Importacao\Bradesco\Debito\"
		__copyfile(cDirect+adirect[_nI,1],cDirecCartao+adirect[_nI,1])
		ferase(cDirect+adirect[_nI,1])
	ElseIf aBanco[oLbx1:nAt,2] == "001"      // PATRICIA FONTANEZI - 01/2013 INCLUSAO DO BANCO DO BRASIL PARA TRATAMENTO
		__copyfile(cDirect+adirect[_nI,1],cDirectImp+adirect[_nI,1])
		cDirecCartao:= "arq_txt"+cEmpant+"\tesouraria\Importacao\Banco do Brasil\Debito\"  
		__copyfile(cDirect+adirect[_nI,1],cDirecCartao+adirect[_nI,1])
		ferase(cDirect+adirect[_nI,1])
	Else
		__copyfile(cDirect+adirect[_nI,1],cDirectImp+adirect[_nI,1])
		ferase(cDirect+adirect[_nI,1])
	EndIf
Next

MsgInfo("Importacao Finalizada com Sucesso!!!")

Return
/*
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณ C6A02LEG   บAutor  ณ Totvs		       บ Data ณ01/08/2014 บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDesc.     ณ Legenda                                  				  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ
*/
USER FUNCTION C6A02LEG() 
local aLeg:= {	{"BR_VERDE","Aberto"},;
				{"BR_AZUL","Identificado"},;
				{"BR_AMARELO","Irregularidade"},;
				{"BR_VERMELHO","Conciliado"}}

BrwLegenda(cCadastro,"Legenda",aLeg)

RETURN