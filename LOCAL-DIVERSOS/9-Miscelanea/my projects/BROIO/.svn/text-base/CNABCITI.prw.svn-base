#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CNABCITI    º Autor ³ TOTVS            º Data ³  14/06/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Generacion de archivo TXT para CNABCITI                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CNABCITI()

Private cPerg       := "CNABCITI  "
Private nLastKey    := 0
Private aFields     := { }
Private lNormal		:= .T.
//Private nCheckSum	:= 0

VldPerg(cPerg)

If !Pergunte(cPerg,.T.)
	Return
EndIf
                                                                 
If nLastKey == 27
	Return
Endif

dbSelectArea("SA6") //Bancos
dbSetOrder(1)
If !DbSeek(xFilial("SA6") + mv_par01 + mv_par02 + mv_par03)
	MsgStop(OemToAnsi("No exists bank in the Archive of Banks"),OemToAnsi("Impossible Continue"))
	Return
EndIf    

//nCheckSum += VAL(SUBSTR(STRTRAN(SA6->A6_NUMCON,"-",""),4,10))

cFile := Alltrim(mv_par08) + '.txt'
nHnd  := FCreate( cFile )

AAdd( aFields, { "EK_OK"       ,   "C",  2, 0 } )
AAdd( aFields, { "EK_ORDPAGO"  ,   "C",  6, 0 } )
AAdd( aFields, { "EK_TIPO"     ,   "C",  3, 0 } )
AAdd( aFields, { "EK_NUM"      ,   "C", 12, 0 } )
AAdd( aFields, { "EK_EMISSAO"  ,   "D",  8, 0 } )
AAdd( aFields, { "EK_VENCTO"   ,   "D",  8, 0 } )
AAdd( aFields, { "E2_BAIXA"    ,   "D",  8, 0 } )
AAdd( aFields, { "EK_VALOR"    ,   "N", 17, 2 } )
AAdd( aFields, { "EK_FORNECE"  ,   "C",  6, 0 } )
AAdd( aFields, { "EK_LOJA"     ,   "C",  3, 0 } )
AAdd( aFields, { "A2_NOME"     ,   "C", 50, 0 } )
AAdd( aFields, { "EK_MOEDA"    ,   "C",  1, 0 } )
AAdd( aFields, { "NROREG"      ,   "N", 10, 0 } )

cDbfTmp := CriaTrab( aFields, .t. )
cNtxTmp := CriaTrab( , .f. )

QryDtos() //Executa a Query

DbSelectArea("TRB")
DbGoTop()
If EOF() .AND. BOF()
	MsgStop( OemToAnsi( "did not find registers" ) )
	DbUnlockAll()
	DbSelectArea( 'TRB' )
	DbCloseArea()
	FErase( cDbfTmp + GetDBExtension() )
	FErase( cNtxTmp + OrdBagExt() )
	FClose( nHnd )
	Return
EndIf

IndRegua("TRB",cNtxTmp,'EK_ORDPAGO',,,"Indexando Registros...")

cCadastro := OemToAnsi("File generation for CITI")

DbSelectArea("TRB")
DbSetOrder(1)
DbGoTop()

GenBcp()

DbUnlockAll()
DbSelectArea( 'TRB' )
DbCloseArea()
FErase( cDbfTmp + GetDBExtension() )
FErase( cNtxTmp + OrdBagExt() )

FClose( nHnd )
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄ-ÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³  GenBcp   ³ Autor ³TOTVS                  ³ Data ³ 21/09/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄ-ÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.   ³ Generacion del archivo para enviar al Banco.                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄ-ÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso        ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄ-ÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GenBcp
Local cFilSA2  := xFilial('SA2')
Local aArea    := GetArea()
Local lGenPay  := .F.
Local aProv	   := {}
//Local cSig     := "+"

Private nTotPag := 0
Private cTipo   := " "
Private aTotRegs:= {}

dbSelectArea("SA2") //Fornecedores
dbSetOrder(1)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida os dados do Fornecedor antes de gerar o TXT.  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !ValidSA2()
	Return
EndIf

DbSelectArea("TRB")
DbGoTop()

While !EOF()

	If !Empty(TRB->E2_BAIXA)   // Debitado
		DbSkip()
		loop
	Endif
	
	SA2->(MsSeek(cFilSA2+TRB->EK_FORNECE+TRB->EK_LOJA))

	DbSelectArea("SEK")
	DbSetOrder( 1 )
	DbSeek( xFilial() + TRB->EK_ORDPAGO, .t. )
	While !EOF() .And. EK_ORDPAGO == TRB->EK_ORDPAGO
		
		If EK_CANCEL .or. EK_VALOR == 0
			DbSkip()
			Loop
		EndIf

		Grava01()

		DbSelectArea("SEK")
		DbSkip()
	EndDo
	
	lGenPay := .T.
	DbSelectArea("TRB")
	DbSkip()
EndDo

If !lGenPay
	MsgStop( "Movements did not match" )
	FClose( nHnd )
	FClose( nHnd2 )
Else
	MsgInfo( "Proceso terminado con exito" )
	FClose( nHnd )
	FClose( nHnd2 )
EndIf

RestArea(aArea)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄ-ÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ VldPerg  ³ Autor ³ TOTVS                  ³ Data ³ 28/09/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄ-ÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.   ³ Validacao do SX1                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄ-ÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso        ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄ-ÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function VldPerg(cPerg)
Local _sAlias := Alias() 
Local aRegs := { }
Local i
Local j
dbSelectArea("SX1")
dbSetOrder(1)

aAdd(aRegs,{cPerg,"01","Banco ?"            ,"Banco ?"            ,"Banco ?"            ,"mv_ch1","C",03,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA6"	,"",""})
aAdd(aRegs,{cPerg,"02","Agencia ?"          ,"Agencia ?"          ,"Agencia ?"          ,"mv_ch2","C",05,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""		,"",""})
aAdd(aRegs,{cPerg,"03","Cuenta ?"           ,"Cuenta ?"           ,"Cuenta ?"           ,"mv_ch3","C",20,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""		,"",""})
aAdd(aRegs,{cPerg,"04","Desde Orden Pago ?" ,"Desde Orden Pago ?" ,"Desde Orden Pago ?" ,"mv_ch4","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""		,"",""})
aAdd(aRegs,{cPerg,"05","Hasta Orden Pago ?" ,"Hasta Orden Pago ?" ,"Hasta Orden Pago ?" ,"mv_ch5","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""		,"",""})
aAdd(aRegs,{cPerg,"06","Desde Fecha ?"      ,"Desde Fecha ?"      ,"Desde Fecha ?"      ,"mv_ch6","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""		,"",""})
aAdd(aRegs,{cPerg,"07","Hasta Fecha ?"      ,"Hasta Fecha ?"      ,"Hasta Fecha ?"      ,"mv_ch7","D",08,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","",""		,"",""})
aAdd(aRegs,{cPerg,"08","Nombre del Archivo?","Nombre del Archivo?","Nombre del Archivo?","mv_ch8","C",80,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","DIR"	,"",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next
dbSelectArea(_sAlias)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funci¢n     ³ GrabaLog³ Autor ³ TOTVS                ³ Data ³ 28/09/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descripci¢n ³ Genera el Log de las migraciones...                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GrabaLog( cString )

FWrite( nHnd, cString + Chr(13) + Chr(10) )

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³ QryDtos  ³ Autor ³ Alejandro Perret      ³ Data ³ 22/04/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³ Ejecuta la Consulta que trae los datos necesarios.         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function QryDtos()

Local cSEK := RetSqlName('SEK')
Local cSE2 := RetSqlName('SE2')
Local cSA2 := RetSqlName('SA2')
cQuery := ""

#IFDEF TOP
	
	DbUseArea( .T.,__cRDDNTTS, cDbfTmp, "TRB", .f., .f., IIF(.F. .or. .f., !.f., NIL ), .F.)
	
	cQuery := "SELECT ' ' EK_OK,EK_ORDPAGO,EK_TIPO,EK_NUM,EK_EMISSAO,EK_VENCTO,E2_BAIXA,ROUND(EK_VALOR,2) EK_VALOR,EK_FORNECE,EK_LOJA,A2_NOME,EK_MOEDA, "
	cQuery += cSEK + ".R_E_C_N_O_ NROREG "
	cQuery += "FROM " + cSEK + " LEFT JOIN "+ cSE2 + " ON " + cSEK + ".EK_ORDPAGO = " + cSE2 + ".E2_ORDPAGO AND "
	cQuery += cSEK + ".EK_TIPO = " + cSE2 + ".E2_TIPO AND "
	cQuery += cSEK + ".EK_NUM = " + cSE2 + ".E2_NUM "
	cQuery += " INNER JOIN "+ cSA2 + " ON " + cSEK + ".EK_FORNECE = " + cSA2 + ".A2_COD AND "
	cQuery += cSEK + ".EK_LOJA = " + cSA2 + ".A2_LOJA "
	cQuery += "WHERE " +cSEK+".EK_FILIAL = '" + xFilial("SEK") + "' AND EK_CANCEL <> 'T' AND "
	cQuery += cSEK+".EK_ORDPAGO BETWEEN '" + mv_par04 + "' AND '" + mv_par05 + "' AND "
	cQuery += cSEK+".EK_BANCO = '" + mv_par01 + "' AND "
	cQuery += cSEK+".EK_AGENCIA = '" + mv_par02 + "' AND "+cSEK+".EK_CONTA = '" + mv_par03 + "' AND "
	cQuery += cSEK+".EK_EMISSAO BETWEEN '"+dTos(mv_par06)+"' AND '"+dTos(mv_par07) + "' AND "
	cQuery += cSA2+".A2_BANCO = 'BCP' AND "
	
	cQuery += cSEK+".D_E_L_E_T_ <> '*' AND "
	cQuery += cSA2+".D_E_L_E_T_ <> '*' "
	
	cQuery   := ChangeQuery( cQuery )
	SqlToTrb( cQuery, aFields, 'TRB' )
	TCSetField( 'TRB', 'EK_EMISSAO'  , 'D',8, 0 )
	TCSetField( 'TRB', 'EK_VENCTO'   , 'D',8, 0 )
	TCSetField( 'TRB', 'E2_BAIXA'    , 'D',8, 0 )
	TCSetField( 'TRB', 'EK_VALOR'    , 'N',15, 2 )
	
#ELSE
	MsgStop( 'Este programa esta desarrollado solo para TopConnect' )
#ENDIF

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Grava01  ³ Autor ³ Francisco Lagatta     ³ Data ³ 21/09/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrip.  ³ Grava os arquivos tipo 01 (CABECALHO DO ARQUIVO)           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Grava01()

Local nNumPre:=POSICIONE("SE2",8,xFilial("SE2")+SEK->EK_ORDPAGO,"E2_PREFIXO")
Local nNumTit:=POSICIONE("SE2",8,xFilial("SE2")+SEK->EK_ORDPAGO,"E2_NUM")

Local cArchivo 	:= SubStr(cFile,RAt("\",cFile)+1,Len(cFile))
Local nTotRegs 	:= aTotRegs[1][1]
Local nTotPag	:= aTotRegs[1][3]

cString := 	"#" 															+ ;					//01  - PlaceHolder
			"WL" 	   														+ ;					//02  - Country Code - Codigo do Pais
			"TRN" 	   														+ ;					//03  - Payment Method - Metodo de Pagamento
			"DTOS(SE2->E2_BAIXA)" 											+ ;					//04  - Value Date - Data de Pagamento
			"#" 															+ ;					//05  - PlaceHolder
			"#" 	   														+ ;					//06  - PlaceHolder
			"#" 															+ ;					//07  - PlaceHolder
			"#"    															+ ;					//08  - PlaceHolder
			IIF(SEK->EK_MOEDA="1","BRL","USD") 								+ ;					//09  - Payment Currency - Moeda de Pagamento
			STRZERO(VAL(TransForm(SEK->EK_VALOR,"@R 99999999.99" )),11,2) 	+ ;					//10  - Payment Amount - Valor de Pagamento
			"#"		   														+ ;					//11  - PlaceHolder
			STRTRAN(SA6->A6_NUMCON,"-","") 	   								+ ;					//12  - Debit Account - Conta de Debito
			"#"																+ ;					//13  - PlaceHolder
			"#"																+ ;					//14  - PlaceHolder
			"#" 															+ ;					//15  - PlaceHolder
			"#" 															+ ;					//16  - PlaceHolder
			"#" 															+ ;					//17  - PlaceHolder
			"#" 															+ ;					//18  - PlaceHolder
			"#" 															+ ;					//19  - PlaceHolder
			"" 	   															+ ;					//20  - Equivalent Amount - Valor Equivalente (CAMPO 10 PREENCHIDO ESTE FICA EM BRANCO)
			"#" 															+ ;					//21  - PlaceHolder
?????		"" 																+ ;					//22  - Charges Indicator - Indicador de Encargos (OUR ou BEM) Encargos do Emissor ou Encargos do Beneficario
			"#" 															+ ;					//23  - PlaceHolder
			"#" 															+ ;					//24  - PlaceHolder
?????		IIF(SA2->A2_TIPDOC="06",SA2->A2_CGC + SPACE(1),SUBSTR(SA2->A2_PFISICA,1,12))+ ;		//25  - Transaction Reference Number - Numero de Referencia da Transacao
?????		"" 																+ ;					//26  - Customer Reference Number - Numero de Referencia do Cliente
			"Y" 															+ ;					//27  - Confidential - Pagamento Confidencial
			"#" 															+ ;					//28  - PlaceHolder
			"#" 															+ ;					//29  - PlaceHolder
			"#" 	   														+ ;					//30  - PlaceHolder
			"#" 															+ ;					//31  - PlaceHolder
????		SM0->M0_NOMECOM 												+ ;					//32  - Company Name (Individual Company ID) - Nome da Empresa (ID Individual da Empresa)
			"#" 															+ ;					//33  - PlaceHolder
			"#" 															+ ;					//34  - PlaceHolder
			"#" 															+ ;					//35  - PlaceHolder
			"#" 															+ ;					//36  - PlaceHolder
			SM0->M0_NOMECOM 												+ ;					//37  - Ordering Party Name - Nome da Parte Solicitante
			SUBSTR(SM0->M0_ENDCOD,1,35) 		   							+ ;					//38  - Ordering Party Adress (Line 1) - Endereco da Parte do Solicitante (Linha 1)
			SUBSTR(SM0->M0_ENDCOD,36,35) 									+ ;					//39  - Ordering Party Adress (Line 2) - Endereco da Parte do Solicitante (Linha 2)
			"" 																+ ;					//40  - Ordering Party Adress (Line 3) - Endereco da Parte do Solicitante (Linha 3)
			"#" 															+ ;					//41  - PlaceHolder
			"#" 	   														+ ;					//42  - PlaceHolder
			"#" 	   														+ ;					//43  - PlaceHolder
			SUBSTR(SA2->A2_AGENCIA,1,3) + SUBSTR(STRTRAN(SA2->A2_NUMCON,"-",""),1,17)+ ;		//44  - Beneficiary Account or Other ID - Conta do Beneficiario
			SA2->A2_NOME 													+ ;					//45  - Beneficiary Name -  Nome do Beneficiario
			"#" 	   														+ ;					//46  - PlaceHolder
			SUBSTR(SA2->A2_END,1,35) 										+ ;					//47  - Beneficiary Adress (Line 1) - Endereco do Beneficiario (Linha 1)
			SUBSTR(SA2->A2_END,36,35) 										+ ;					//48  - Beneficiary Adress (Line 2) - Endereco do Beneficiario (Linha 2)
			"" 																+ ;					//49  - Beneficiary Adress (Line 3) - Endereco do Beneficiario (Linha 3)
?????		"" 																+ ;					//50  - Beneficiary Bank Rountig Method - Metodo de Roteamento do Banco Beneficiario
			"" 																+ ;					//51  - Beneficiary Bank Routing Code - Codigo de Roteamento
			"#" 															+ ;					//52  - PlaceHolder
			"#" 															+ ;					//53  - PlaceHolder
			"#" 															+ ;					//54  - PlaceHolder
			"" 																+ ;					//55  - Beneficiary Bank Name - Nome do Banco Beneficiario
			"" 																+ ;					//56  - Beneficiary Bank Adress (Line 1) - Endereco do Banco Beneficiario (Linha 1)
			"" 																+ ;					//57  - Beneficiary Bank Adress (Line 2) - Endereco do Banco Beneficiario (Linha 2)
			"" 																+ ;					//58  - Beneficiary Bank Adress (Line 3) - Endereco do Banco Beneficiario (Linha 3)
?????		"" 																+ ;					//59  - First Intermediary Bank Routing Method - Metodo de Roteamento do Primeiro Banco Intermediario
			"" 																+ ;					//60  - First Intermediary Bank Routing Code - Codigo de Roteamento do Primeiro Banco Intermediario
			"" 	 															+ ;					//61  - First Intermediary Bank Name - Nome do Primeiro Banco Intermediario
			"" 	  															+ ;					//62  - First Intermediary Bank Adress (Line 1) - Endereco do Primeiro Banco Intermediario (Linha 1)
			"" 	 															+ ;					//63  - First Intermediary Bank Adress (Line 2) - Endereco do Primeiro Banco Intermediario (Linha 2)
			"" 	 															+ ;					//64  - First Intermediary Bank Adress (Line 3) - Endereco do Primeiro Banco Intermediario (Linha 3)
			"#" 															+ ;					//65  - PlaceHolder
			"#" 															+ ;					//66  - PlaceHolder
			"#" 															+ ;					//67  - PlaceHolder
			"#" 															+ ;					//68  - PlaceHolder
			"#" 															+ ;					//69  - PlaceHolder
			"#" 															+ ;					//70  - PlaceHolder
			"#" 															+ ;					//71  - PlaceHolder
			"" 	 															+ ;					//72  - Payment Details (Line 1) - Detalhes do Pagamento (Linha 1)
			"" 																+ ;					//73  - Payment Details (Line 2) - Detalhes do Pagamento (Linha 2)
			"" 																+ ;					//74  - Payment Details (Line 3) - Detalhes do Pagamento (Linha 3)
			"" 																+ ;					//75  - Payment Details (Line 4) - Detalhes do Pagamento (Linha 4)
			"" 																+ ;					//76  - Bank Details (Line 1) - Detalhes do Banco (Linha 1)
			"" 																+ ;					//77  - Bank Details (Line 2) - Detalhes do Banco (Linha 2)
			"" 																+ ;					//78  - Bank Details (Line 3) - Detalhes do Banco (Linha 3)
			"" 																+ ;					//79  - Bank Details (Line 4) - Detalhes do Banco (Linha 4)
			"" 																+ ;					//80  - Bank Details (Line 5) - Detalhes do Banco (Linha 5)
			"" 																+ ;					//81  - Bank Details (Line 6) - Detalhes do Banco (Linha 6)
			"#" 															+ ;					//82  - PlaceHolder
			"#" 															+ ;					//83  - PlaceHolder
			"#" 															+ ;					//84  - PlaceHolder
			"" 	  															+ ;					//85  - Memo Details 1 - Campo de Detalhes 1
			"" 	  															+ ;					//86  - Memo Details 2 - Campo de Detalhes 2
			"" 	  															+ ;					//87  - Memo Details 3 - Campo de Detalhes 3
			"" 	  															+ ;					//88  - Memo Details 4 - Campo de Detalhes 4
			"#" 															+ ;					//89  - PlaceHolder
			"#" 															+ ;					//90  - PlaceHolder
			"#" 															+ ;					//91  - PlaceHolder
			"#" 															+ ;					//92  - PlaceHolder
			"#"																					//93  - PlaceHolder

GrabaLog( cString )

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³ RetDoc   ³ Autor ³ Francisco Lagatta     ³ Data ³ 28/09/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri.   ³ Retorna o tipo de documento do Fornecedor. ( Grava02() )   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RetDoc()
Local cDocSA2:= ""

IF SA2->A2_TIPDOC = "01"
	cDocSA2:= "1"
ElseIF SA2->A2_TIPDOC = "04"
	cDocSA2:= "3"
ElseIF SA2->A2_TIPDOC = "07"
	cDocSA2:= "4"
ElseIF SA2->A2_TIPDOC = "06"
	cDocSA2:= "6"
EndIF

Return(cDocSA2)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcion   ³ ValidSA2 ³ Autor ³ TOTVS                 ³ Data ³ 07/10/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri.   ³ Valida os dados dos Fornecedores, antes de gerar o TXT     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ValidSA2()
Local cFilSA2  	:= xFilial('SA2')
Local lRet 		:= .T.

DbSelectArea("TRB")
DbGoTop()

While !EOF()
	
	DbSelectArea( "SEK" )
	MsGoTo(TRB->NROREG)
	
	DbSelectArea("TRB")
	If !SA2->(MsSeek(cFilSA2+TRB->EK_FORNECE+TRB->EK_LOJA))
		AutoGrLog( "Proveedor no encontrado: "+TRB->EK_FORNECE+" - "+TRB->EK_LOJA )
		lRet := .F.
	Else
		If Empty(SA2->A2_AGENCIA)
			AutoGrLog( "Proveedor sin Agencia: "+TRB->EK_FORNECE+" - "+TRB->EK_LOJA + " ->(A2_AGENCIA)" )
			lRet := .F.
		Endif
		If Empty(SA2->A2_NUMCON)
			AutoGrLog( "Proveedor sin Cuenta Corriente: "+TRB->EK_FORNECE+" - "+TRB->EK_LOJA + " ->(A2_NUMCON)" )
			lRet := .F.
		EndIf
		If Empty(SA2->A2_TIPDOC)
			AutoGrLog( "Proveedor sin tipo de documento: "+TRB->EK_FORNECE+" - "+TRB->EK_LOJA + " ->(A2_TIPDOC)" )
			lRet := .F.
		Else
			IF SA2->A2_TIPDOC="06" .and. Empty(SA2->A2_CGC)
				AutoGrLog( "Proveedor sin el numero de RUC informado: "+TRB->EK_FORNECE+" - "+TRB->EK_LOJA + " ->(A2_CGC)" )
				lRet := .F.
			EndIF
			IF SA2->A2_TIPDOC<>"06" .and. Empty(SA2->A2_PFISICA)
				AutoGrLog( "Proveedor sin el numero de DNI/Cerd. Extr. informado: "+TRB->EK_FORNECE+" - "+TRB->EK_LOJA + " ->(A2_PFISICA)" )
				lRet := .F.
			EndIF
		EndIF
	EndIF
	DbSelectArea("TRB")
	DbSkip()
Enddo

If !lRet
	AutoGrLog( "Fecha Fin..........: " + Dtoc(MsDate()) )
	AutoGrLog( "Hora Fin...........: " + Time() )
	
	cPath    := ""
	cFileLog := NomeAutoLog()
	
	If cFileLog <> ""
		nX := 1
		While .t.
			If File( Lower( Dtos( MSDate() ) + StrZero( nX, 3 ) + '.log' ) )
				nX++
				If nX == 999
					Exit
				EndIf
				Loop
			Else
				Exit
			EndIf
		EndDo
		__CopyFile( cPath + Alltrim( cFileLog ), Lower( Dtos( MSDate() ) + StrZero( nX, 3 ) + '.log' ) )
		MostraErro(cPath,cFileLog)
		FErase( cFileLog )
	Endif
EndIf

Return(lRet)