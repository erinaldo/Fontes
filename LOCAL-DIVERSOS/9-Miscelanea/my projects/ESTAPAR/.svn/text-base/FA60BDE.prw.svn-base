#INCLUDE 'Protheus.ch'
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ FA060SE5 ³ Autor ³ Daniel G.Jr.TI1239  ³ Data ³Maio/2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ponto de entrada da rotina FINA060 - TRANSF/BORDERO        ³±±
±±³          ³ Utilizado para gravar E1_NUMBCO                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Estapar                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function FA60BDE()

Local cNroDoc 	  	:=  " "
Local aDadosBanco	:= {}
Local aCB_RN_NN    	:= {}
Local cIdCnab      	:= ""
Local aArea			:= GetArea()
Local aAreaSE1		:= SE1->(GetArea())
Local aAreaSA6		:= SA6->(GetArea())
Local aAreaSEE		:= SEE->(GetArea())
Local cMarca   		:= GetMark( )

Private cBanco     := SE1->E1_PORTADO
Private cAgencia   := SE1->E1_AGEDEP
Private cConta     := SE1->E1_CONTA
Private cSubCt     := Iif(cBanco="237","09",Iif(cBanco="033","RCR",""))


// Se já houver Nosso Número não executa
If TRB->E1_OK<>cMarca.Or.!Empty(SE1->E1_NUMBCO).Or.Empty(cBanco)
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona o SA6 (Bancos)    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SA6")
DbSetOrder(1)
	
If !DbSeek(FWXFILIAL("SA6")+cBanco+cAgencia+cConta)
	Aviso(OemToAnsi("ATENÇÃO"),OemToAnsi("Banco não localizado"),{"OK"})
	Alert('Banco (SA6): ' + FWXFILIAL("SA6")+cBanco+cAgencia+cConta)
EndIf
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona na Arq de Parametros CNAB   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SEE")
DbSetOrder(1)
	
If !DbSeek(FWXFILIAL("SEE")+cBanco+cAgencia+cConta+cSubCt)
	Aviso(OemToAnsi("ATENÇÃO"),OemToAnsi("Não localizado banco no cadastro de parâmetros para envio"),{"OK"})
	Alert('Parametros CNAB (SEE) ' + FWXFILIAL("SEE")+cBanco+cAgencia+cConta+cSubCt)
EndIf
	
cPrefix := SE1->E1_PREFIXO
cNumTit := SE1->E1_NUM
cParcel := SE1->E1_PARCELA
cTipo   := SE1->E1_TIPO

IF SEE->EE_CODIGO=="341"
	cNroDoc	:= Substr(SEE->EE_FAXATU,3,8)
Else
	cNroDoc	:= SEE->EE_FAXATU
Endif

IF EMPTY(SEE->EE_ULTDSK) .OR. !("COB"$ALLTRIM(SEE->EE_OPER).AND."REGISTR"$ALLTRIM(SEE->EE_OPER))
		cNroDoc := IIF (!EMPTY(cIdCnab),cIdCnab,IIF(SEE->EE_CODIGO=="399",SUBSTR(SE1->E1_NUMBCO,1,8),SE1->E1_NUMBCO))	// Incluído em 21/02/13 por Daniel G.Jr.
Endif
		
aDadosBanco  := {SEE->EE_CODIGO  			    									,;	//	[1]	Numero do Banco
				SA6->A6_NREDUZ														,;	//	[2]	Nome Reduzido Banco
				SUBSTR(SEE->EE_AGENCIA,1,4)	   										,;	//	[3]	Agência
				SUBSTR(SA6->A6_NUMCON,1,Len(AllTrim(SA6->A6_NUMCON)))				,;	//	[4]	Conta Corrente
				SUBSTR(SA6->A6_DVCTA,1,Len(AllTrim(SA6->A6_DVCTA)))	  				,;	//	[5]	Dígito da conta corrente
				Alltrim(SEE->EE_SUBCTA)}	  											//	[6]	Dígito da conta corrente
		
//Monta codigo de barras FIM DA PAGINA
aCB_RN_NN  :=   RetcNNum(Subs(aDadosBanco[1],1,3)+"9"		,;//Banco
						Subs(aDadosBanco[3],1,4)			,;//Agencia
						aDadosBanco[4]						,;//Conta
						aDadosBanco[5]						,;//Digito da Conta
						aDadosBanco[6]						,;//Carteira
						cNroDoc								,;//Documento
						SE1->E1_VALOR						,;//Valor do Titulo
						SE1->E1_VENCTO						,;//Vencimento
						SEE->EE_CODEMP						,;//Convenio
						cNroDoc  							,;//Sequencial
						.F.									,;//Se tem desconto
						Space(TamSx3("E1_PARCELA")[1])		,;//Parcela
						aDadosBanco[3])				    	  //Agencia Completa
		
// Grava Nosso Numero
IF !EMPTY(SEE->EE_ULTDSK) .AND. ("COB"$ALLTRIM(SEE->EE_OPER).AND."REGISTR"$ALLTRIM(SEE->EE_OPER)) .AND. EMPTY(SE1->E1_NUMBCO)
	RecLock("SEE",.F.)
	SEE->EE_FAXATU := StrZero(Val(SEE->EE_FAXATU) + 1,10)  //INCREMENTA P/ TODOS OS BANCOS
	MsUnlock()
Endif
		
Reclock("SE1",.F.)
if aDadosBanco[1] $ "104|033|353|399"
	SE1->E1_NUMBCO := aCB_RN_NN[1]
Else
	SE1->E1_NUMBCO := aCB_RN_NN[2]
Endif
SE1->(MsUnlock())
		
RestArea(aAreaSEE)
RestArea(aAreaSA6)
RestArea(aAreaSE1)
RestArea(aArea)

Return nil


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ RetcBarra³ Autor ³ Everton Balbino       ³ Data ³ 19/09/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function RetcNNum(cBanco,cAgencia,cConta,cDacCC,cCarteira,cNroDoc,nValor,dvencimento,cConvenio,cSequencial,_lTemDesc,_cParcela,_cAgCompleta)

Local blvalorfinal := strzero(nValor*100,10)
Local cNNumSDig := ""
Local cCpoLivre := ""
Local cCBSemDig := ""
Local cCodBarra := ""
Local cNNum 	:= ""
Local cFatVenc  := ""
Local cNossoNum := ""
Local cLinDig	:= ""

If Left(cBanco,3) == "422"
	
	//Nosso Numero sem digito
	cNNumSDig := strzero(val(cSequencial),8)
	
	//Nosso Numero para gravacao
	cNNum := cNNumSDig + modulo11(cNNumSDig)
	
ElseIf Left(cBanco,3) == "399"
	
	cSeqzero  := strzero(val(cSequencial),8)

	cCedente := Alltrim(cConvenio)
	cNroBco	:= strzero(val(cSequencial),13)
	
	//Fator de Vencimento
	cDtVencto := DtoC(dVencimento)
	cFatVenc := dvencimento
	if valtype(dvencimento) == "D"
		cFatVenc := STRZERO(dvencimento - CtoD("07/10/1997"),4)
	Endif
	
	//Nosso Numero sem digito
	cNNumSDig := cSeqzero + U_Modulo11CNR(cSeqzero,SubStr(cBanco,1,3),2) + "4"
	
	//Nosso Numero HSBC
	if valtype(dvencimento) == "D"
		cNNum := Val(cNNumSDig) + Val(cConvenio) + VAL(SUBSTR(cDtVencto,1,2)+SUBSTR(cDtVencto,4,2)+SUBSTR(cDtVencto,9,2))
	Else
		cDVB := "5"
		cAux := Str( Val(cNNumSDig+cDVA+cDVB) + Val(cCedente) )
	Endif                                                                            tot
	cNNum := U_Modulo11CNR(strzero(cNNum,13),SubStr(cBanco,1,3),2)
	
	//Nosso Numero para gravacao
	cNossoNum := cNNumSDig + cNNum
	
ElseIf Left(cBanco,3) == "341"
	
	//Nosso Numero sem digito
	cNNumSDig := cCarteira+strzero(val(cSequencial),8)

	//Nosso Numero
	cNNum := cCarteira+strzero(val(cSequencial),8) + AllTrim( Str( U_modulo10cr( StrZero(Val(cAgencia),4) + StrZero(Val(cConta),5)+cNNumSDig ) ) )
	
ElseIf Left(cBanco,3) == "356"

	//Fator Vencimento - POSICAO DE 06 A 09
	cFatVenc := dvencimento
	if valtype(dvencimento) == "D"
		cFatVenc := STRZERO(dvencimento - CtoD("07/10/1997"),4)
	Endif
	//Nosso Numero sem digito
	cNNumSDig := strzero(val(cSequencial),13)
	
	cNNum := strzero(val(cSequencial),13)
	
	//Nosso Numero para gravacao
	cDig := U_Modu10Es(cNNumSDig + StrZero(Val(cAgencia),4) + StrZero(Val(cConta),7))
	
	//Nosso Numero para impressao
	cNossoNum := strzero(val(cNNumSDig),13)
	
Elseif Substr(cBanco,1,3) == "104" // Banco Caixa
	
	cCodEmp := StrZero(Val(cConvenio),12)   
	
	//Nosso Numero sem digito
	cNNumSDig := strzero(val(cSequencial),8)
	
	//Nosso Numero
	_cDigito := U_Modulo11CNR("82"+cNNumSDig,SubStr(cBanco,1,3))
	cNNum := cAgencia + "." + Substr(cCodEmp,1,3) + "." + Substr(cCodEmp,4,8) + "-" + Substr(cCodEmp,12,1)
	
	//Nosso Numero para impressao
	cNossoNum := "82" + cNNumSDig + "-" + _cDigito
	
Elseif Substr(cBanco,1,3) == "353" // Banco Santander
	
	cCodEmp := StrZero(Val(SubStr(cConvenio,1,9)),7)
	
	//Nosso Numero sem digito
	cNNumSDig := strzero(val(cSequencial),10)
	
	//Nosso Numero
	_cDigito := U_Modulo11CNR(cNNumSDig,SubStr(cBanco,1,3))
	cNossoNum := cNNumSDig + _cDigito
	
	cNNum := cAgencia + "/" + cCodEmp
	
Elseif Substr(cBanco,1,3) == "033" // Banco Santander

	cNumSeq := strzero(val(cSequencial),10)
	cCodEmp := StrZero(Val(SubStr(cConvenio,1,9)),7)
	//Nosso Numero sem digito
	cNNumSDig := strzero(val(cSequencial),10)
	//Nosso Numero
	_cDigito := U_Modulo11CNR(cNNumSDig,SubStr(cBanco,1,3))
	cNossoNum := cNNumSDig + _cDigito
	
	cNNum := cAgencia + "/" + cCodEmp

ElseIf Left(cBanco,3) == "237"

	//Montagem no NOSSO NUMERO
	snn := StrZero( Val(cSequencial),11 )
	dvnn := modulo12cnr( cCarteira + snn , Left(cBanco,3) )   //Digito verificador no Nosso Numero
	
	//Nosso Numero para gravacao
	cNNum     := cCarteira + snn + dvnn
	
EndIf

Return({cNossoNum,cNNum})

//------------------------------------------
//
//------------------------------------------
Static Function Modulo12CNR(cData,cBanc)

Local L, D, P := 0
Local D1 := ""
If cBanc == "237"  // Bradesco
	L := Len(cData)
	D := 0
	P := 1
	While L > 0
		P := P + 1
		D := D + (Val(SubStr(cData, L, 1)) * P)
		If P = 7
			P := 1
		Endif
		L := L - 1
	End
	D := 11 - (mod(D,11))
	If (D == 11)
		D1 := "0"
	ElseIf (D == 10)
		D1 := "P"
	Else
		D1 := str(D)
	Endif
Endif

Return(Alltrim(D1))
