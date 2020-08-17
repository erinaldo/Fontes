#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PAGFOR    ºAutor  ³   Eduardo Dias     º Data ³  29/09/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gera informações para o PagFor                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico CSU       	                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PAGFOR(cOp)

Local cReturn  		:= ""
Local nReturn  		:= 0
Local cAgencia		:= " "
Local cDvAgencia	:= " "
Local cRETDIG 		:= " "
Local cDIG1   		:= " "
Local cDIG2   		:= " "
Local cDIG3   		:= " "
Local cDIG4   		:= " "
Local cMULT   		:= 0
Local cRESUL 		:= 0
Local cRESTO  		:= 0
Local cDIGITO 		:= 0
Local cRetCar		:= " "
Local cRetNos		:= " "
Local nTamCpf		:= " "
Local cCPF   		:= " "
Local cCtlCpf		:= " "
Local cNum			:= " "
Local nVltit		:= 0
Local nAbat			:= 0
Local cConta		:= " "
Local cDigCta		:= " "
Local nLote         := 0
Local _lReg         := .F.

_nLote        := 0   
_nTotReg      := 0
_nSeq         := 0

If cOp == "1"    // obter código do banco
	
	if Alltrim(SEA->EA_MODELO) $ "30/31"
		cReturn:= SubStr(SE2->E2_CODBAR,1,3)
	ElseIf Alltrim(SEA->EA_MODELO) $ "01/03/05/08/41/43"		// Credito em C/C, Doc, Credito em cta poupanca/ted -outro titular/ted-mesmo titular
		cReturn:= SA2->A2_BANCO
	Else
		cReturn:= " "
	EndIf
	
ElseIf cOp == "2"
	
	If 	Alltrim(SEA->EA_MODELO) $ "01/03/05/08/30/31/41/43"		// Credito em C/C, Doc, Credito em cta poupanca/ted -outro titular/ted-mesmo titular
		cAgencia := Strzero(Val(Substr(SA2->A2_AGENCIA,1,4)),5,0)
		cAgencia := STRTRAN(cAgencia,".","")
		cAgencia := STRTRAN(cAgencia,"-","")		
		///
		/*cCDAgencia := Substr(cAgencia,1,Len(cAgencia)-1)*/
		/*cDVAgencia := Substr(cAgencia,Len(cAgencia),1)*/
		cDVAgencia := Substr(SA2->A2_AGENCIA,5,1)
		///
        cReturn := cAgencia + cDVAgencia
		/*cReturn := cCDAgencia + Space(5 - Len(cCDAgencia))+ cDVAgencia*/
				
	ElseIf SEA->EA_MODELO =="31" .or. Substr(SE2->E2_CODBAR,1,3) == "237"
		If !EMPTY(ALLTRIM(SE2->E2_CODBAR))
			cAgencia  :=  "0" + SUBSTR(SE2->E2_CODBAR,20,4)
			cRETDIG := " "
			cDIG1   := SUBSTR(SE2->E2_CODBAR,20,1)
			cDIG2   := SUBSTR(SE2->E2_CODBAR,21,1)
			cDIG3   := SUBSTR(SE2->E2_CODBAR,22,1)
			cDIG4   := SUBSTR(SE2->E2_CODBAR,23,1)
			
			cMULT   := (VAL(cDIG1)*5) +  (VAL(cDIG2)*4) +  (VAL(cDIG3)*3) +   (VAL(cDIG4)*2)
			cRESUL  := INT(cMULT /11 )
			cRESTO  := INT(cMULT % 11)
			cDIGITO := 11 - cRESTO
			
			cRETDIG := IF( cRESTO == 0,"0",IF(cRESTO == 1,"0",ALLTRIM(STR(cDIGITO))))
			
			cAgencia:= cAgencia + cRETDIG
			cReturn:= cAgencia
		EndIf
	Else
		cAgencia:= replicate("0",5)
		cReturn:= cAgencia
	EndIf
	
ElseIf cOp == "3"  // CONTA CORRENTE DO FORNECEDOR
	
	If Alltrim(SEA->EA_MODELO) $ "01/03/05/08/30/31/41/43"		// Credito em C/C, Doc, Credito em cta poupanca/ted -outro titular/ted-mesmo titular
		
		cNumCC := StrZero(Val(Substr(SA2->A2_NUMCON,1,9)),13,0)
		cNumCC := STRTRAN(cNumCC,".","")
		cNumCC := STRTRAN(cNumCC,"-","")
		///                     
		/*cCDNumCC := Substr(cNumCC,13,Len(cNumCC)-1)*/
		cDVNumCC := Substr(SA2->A2_NUMCON,10,2)
        ///
		cReturn:= cNumCC + cDVNumCC
		
		
	ElseIf Alltrim(SEA->EA_MODELO) == "31" .or. Substr(SE2->E2_CODBAR,1,3) == "237"
		
		cCtaced  :=  STRZERO(VAL(SUBSTR(SE2->E2_CODBAR,37,7)),13,0)
		
		cRETDIG := " "
		cDIG1   := SUBSTR(SE2->E2_CODBAR,37,1)
		cDIG2   := SUBSTR(SE2->E2_CODBAR,38,1)
		cDIG3   := SUBSTR(SE2->E2_CODBAR,39,1)
		cDIG4   := SUBSTR(SE2->E2_CODBAR,40,1)
		cDIG5   := SUBSTR(SE2->E2_CODBAR,41,1)
		cDIG6   := SUBSTR(SE2->E2_CODBAR,42,1)
		cDIG7   := SUBSTR(SE2->E2_CODBAR,43,1)
		
		cMULT   := (VAL(cDIG1)*2) +  (VAL(cDIG2)*7) +  (VAL(cDIG3)*6) +   (VAL(cDIG4)*5) +  (VAL(cDIG5)*4) +  (VAL(cDIG6)*3)  + (VAL(cDIG7)*2)
		cRESUL  := INT(cMULT /11 )
		cRESTO  := INT(cMULT % 11)
		cDIGITO := STRZERO((11 - cRESTO),1,0)
		
		cRETDIG := IF( cresto == 0,"0",IF(cresto == 1,"P",cDIGITO))
		cCtaced:= cCtaced + cRETDIG
		cReturn:= cCtaCed
	Else
		cCtaced:= replicate("0",15)
		cReturn:= cCtaCed
	EndIf
	
	
ElseIf cOP == "4"   // carteira
	
	cRetCar:= "000"
	
	If SubStr(SE2->E2_CODBAR,1,3) == "237"
		
		cRetCar := StrZero(Val(SubStr(SE2->E2_CODBAR,24,2)),3)
		
	EndIf
	
	cReturn := StrZero(Val(cRetCar),3)
	
ElseIf cOP ==  "5"  // nosso numero
	
	cRetNos:= REPLICATE("0",12)
	
	If Alltrim(SEA->EA_MODELO) =="30" .or. Substr(SE2->E2_CODBAR,1,3) == "237"
		cRetNos := StrZero(Val(SubStr(SE2->E2_CODBAR,26,11)),12)
	Else
		cRetNos:= REPLICATE("0",12)
	EndIf
	
	cReturn:= cRetNos
	
ElseIf cOP == "6"  // fator de vencimento
	
	cFtVen:= "0000"
	
	If Alltrim(SEA->EA_MODELO) $ "30/31"
		cFtVen:= SubStr(SE2->E2_CODBAR,6,4)
	Else
		cFtVen:= "0000"
	EndIf
	
	cReturn:= cFtVen
	
ElseIf cOP == "7"  // Valor do Documento
	
	nValor:= Replicate("0",10)
	
	If Alltrim(SEA->EA_MODELO) $ "30/31"
		nVltit := SubStr(SE2->E2_CODBAR,10,10)
	ElseIf Alltrim(SEA->EA_MODELO) $ "01/03/05/08/41/43"		// Credito em C/C, Doc, Credito em cta poupanca/ted -outro titular/ted-mesmo titular
		nAbat	:= SumAbatPag(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_FORNECE,1,"S",dDataBase,SE2->E2_LOJA)
		nVlTit:= SE2->E2_SALDO+SE2->E2_SDACRES-SE2->E2_SDDECRE-nAbat
		nVltit := Strzero((nVlTit*100),10)
	Endif
	
	cReturn:= nVltit
	
ElseIf cOP == "8"  //Valor do Pagamento
	
	nVlTit:= Replicate("0",15)
	nAbat	:= SumAbatPag(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_FORNECE,1,"S",dDataBase,SE2->E2_LOJA)
	
	If Alltrim(SEA->EA_MODELO) $ "30/31"
//		nVltit := Val(SubStr(SE2->E2_CODBAR,38,10))
		nVltit := Val(SubStr(SE2->E2_CODBAR,10,10))
		If nVlTit == 0			// Existem boletos que nao possuem valor
		nVlTit:= SE2->E2_SALDO+SE2->E2_SDACRES-SE2->E2_SDDECRE
			nVltit := Strzero((nVlTit*100),15)
		Else
			nVlTit	:= StrZero(nVlTit,15)	
		EndIf                        
		
	ElseIf Alltrim(SEA->EA_MODELO) $ "01/03/05/08/41/43"		// Credito em C/C, Doc, Credito em cta poupanca/ted -outro titular/ted-mesmo titular
		nVlTit:= SE2->E2_SALDO+SE2->E2_ACRESC-SE2->E2_DECRESC-nAbat
		nVltit := Strzero((nVlTit*100),15)
	Endif
	
	cReturn:= nVltit
	
ElseIf cOP == "9"
	
	cMod  := "                        "
	
	If Alltrim(SEA->EA_MODELO) $ "01/03/05/41/43"		// Credito em C/C, Doc, Credito em cta poupanca/ted -outro titular/ted-mesmo titular
		cMod := "C000000"
		/*
		If SA2->A2_TPCON == "1"
		_cTpCred:= "01"    // DOC para conta corrente
		Else
		_cTpCred:= "11"    // DOC para poupança
		EndIf
		*/
		cTpCred	:="01"
		
		cReturn := cMod + cTpCred
		
	ElseIf Alltrim(SEA->EA_MODELO) = "01"    // SE FOR CREDITO EM C/C
		cReturn := Space(40)		
	ElseIf Alltrim(SEA->EA_MODELO) $ "30/31"	  // BOLETOS
		cCpoLiv:= SubStr(SE2->E2_CODBAR,20,25)
		cDvBar:= SubStr(SE2->E2_CODBAR,5,1)
		cMoeda:= SubStr(SE2->E2_CODBAR,4,1)
		cReturn := cCpoLiv + cDvBar + cMoeda
	EndIf
	
ElseIf cOP == "10"
	
	If Alltrim(SEA->EA_MODELO) $ "01/05"       // Credito em C/C
		cReturn := "01"
	ElseIF Alltrim(SEA->EA_MODELO) = "03"  // DOC Comp
		cReturn := "03"
	ElseIF Alltrim(SEA->EA_MODELO) = "08"  // TED BRADESCO
		cReturn := "08"	
	ElseIf Alltrim(SEA->EA_MODELO) = "30"   // Boleto Bradesco
		cReturn := "30"
	ElseIf Alltrim(SEA->EA_MODELO) = "31"   // Boleto Outros Bancos
		cReturn := "31"
	/*ElseIf Alltrim(SEA->EA_MODELO) = "41"   // TED CIP
		cReturn := "08"
	ElseIf Alltrim(SEA->EA_MODELO) = "43"   // TED CIP
		cReturn := "08"*/     
	Else	
		cReturn := " "	
	EndIf
	
ElseIf cOP == "11"
	
	If SA2->A2_TIPO <>'F'
		cReturn:= Strzero(val(SA2->A2_CGC),15)
	Else
		nTamCpf:= len(Alltrim(SA2->A2_CGC))
		cNum:= Alltrim(SA2->A2_CGC)
		cCPF   := Substr(cNum,1,nTamCpf-2)  // -2 para tirar o controle do CPF
		cCtlCpf:= RIGHT(alltrim(SA2->A2_CGC),2)
		// base                + filial   + controle
		cReturn:= Strzero(val(cCPF),9) + "0000" + cCtlCpf
	EndIf

ElseIf cOP == "12" 		// Conta corrente da empresa

		cConta :=  Alltrim(SA6->A6_NUMCON)
		
		If AT("-",cConta) > 0
			cConta := Substr(cConta,1,AT("-",cConta)-1)
		Endif
		cReturn:= StrZero(Val(cConta),7)
	
ElseIf cOP == "13"  // Data para desconto
	
	IF SUBSTR(SE2->E2_CODBAR,6,14) == "00000000000000" .AND. SUBSTR(SE2->E2_CODBAR,1,3) # "   "
		cReturn := "00000000"
	Else
		cReturn := IF((SE2->E2_VALOR-SE2->E2_SALDO+SE2->E2_DESCONT) = 0,"00000000",DTOS(SE2->E2_VENCREA))
	END

ElseIf cOP == "14"  // Vou guardando o numero do lote, pois se mudar deverei colocar no proximo registro
	nLote:= Val(SEE->EE_LOTE)
	nLote:= _nLote + 1
	RecLock("SEE",.F.)
	SEE->EE_LOTE  := StrZero(_nLote,4)     // nTotCnab2 foi retirado
	MsUnlock()
	cReturn:= " "

ElseIf cOP == "15"  // Volto o numero de lote
	RecLock("SEE",.F.)
	SEE->EE_LOTE := '0001'
	MsUnlock()
	cReturn:= " "

ElseIf cOP == "16" // Totais no Trailer de lote
	If SEA->EA_TIPOPAG == "22"    // Somatoria para tributos SEA->EA_TIPOPAG
		If SEE->EE_CODIGO = "341" .and. SEA->EA_MODELO = '19' // O itau trata IPTU Diferente
			cReturn:= STRZERO((SEE->EE_VALTOT*100),18)+"000000000000000"
		Else
			cReturn:= Iif(_cModelo $ '17',STRZERO((_nTotGPS*100),14),STRZERO((_nTotDar*100),14) )
			cReturn+= STRZERO((_nTotEnt*100),14)
			cReturn+= STRZERO((_nSubdar*100),14)
			cReturn+= STRZERO((_nTotDar+_nSubDar)*100,14)
		End
	Else
		cReturn:= STRZERO((SEE->EE_VALTOT*100),18)
		If SEA->EA_MODELO $ "13/16/17/18/21" .AND. SEE->EE_CODIGO <> "341" //SEA->EA_MODELO
			cReturn+=SPACE(15)
		Else
			If SEA->EA_MODELO $ "13" .and. SEE->EE_CODIGO = "341" // SEA->EA_MODELO  Concessionarias
				cReturn:= _cReturn+"000000000000000"
			ElseIf SEE->EE_CODIGO = "399" .and. SEA->EA_MODELO $ "01/03/41/43"
				cReturn:= Space(3)+STRZERO((SEE->EE_VALTOT*100),15)
			Else
				cReturn:= cReturn+"000000000000000000"
			End
		End
	End
	_nSeq:= _nSeq + (nSeq+1)
	nSeq:= 1
	_nTotReg:= 0 // Zero o contator TED/DOC
	_lReg:= .F.  // coloco falço para o contatdo de TED/DOC/CC
	
ElseIf cOP == "17"
	_lJaSoma:= .F.  // Esta varial logica é usada no ponto de entrada favor não mudar
	cReturn:= ' '

ElseIf cOP == "18"	 // Usado para trazer melhor os campos agencia e c/c para Itau e Brasil DOC/TED
	If SEE->EE_CODIGO = '341'
		cReturn := strzero(val(SA2->A2_agencia),5)+" "
		cReturn += strzero(val(Left(Alltrim(SA2->A2_NumCon),Len(AllTrim(SA2->A2_NumCon))-1)),12,0)+" "+Right(alltrim(SA2->A2_NUMCON),1)
	ElseIf SEE->EE_CODIGO = '399'
		cReturn := strzero(val(SA2->A2_agencia),5)+" "
		cReturn += strzero(val(Left(Alltrim(SA2->A2_NumCon),Len(AllTrim(SA2->A2_NumCon))-1)),11,0)+Right(alltrim(SA2->A2_NUMCON),1)+" "
	Else
		cReturn := strzero(val(SA2->A2_agencia),6)
		cReturn += strzero(val(Left(Alltrim(SA2->A2_NumCon),Len(AllTrim(SA2->A2_NumCon))-1)),12,0)+Right(alltrim(SA2->A2_NUMCON),1)+" "
	End
	
ElseIF cOP == "19"
	IF SEA->EA_MODELO $ "03/41/43" .AND. SA2->A2_BANCO # SEE->EE_CODIGO // TED/DOC para outros bancos deverão ser borderos separados
		cReturn:= SEA->EA_MODELO
	ElseIF SEA->EA_MODELO $ "03/41/43" .And. SA2->A2_BANCO = SEE->EE_CODIGO // TED/DOC para mesmo banco deverá ser borderô separados
		cReturn:= "01"
	ElseIF SEA->EA_MODELO = '30' .and. SEE->EE_CODIGO # SUBSTR(SE2->E2_CODBAR,1,3) // Pagamento Boletos para outro banco
		cReturn:= '31'
	ElseIf SEA->EA_MODELO $ '31' .and. SEE->EE_CODIGO = SUBSTR(SE2->E2_CODBAR,1,3) // Pagamentos Boletos para o mesmo banco
		cReturn:= '30'
	Else
		cReturn:= SEA->EA_MODELO
	End 
	
ElseIf cOP == "20"
	IF SEE->EE_CODIGO = "001"
		cReturn:= STRZERO(VAL(SEE->EE_CODEMP),9,0)+"0126"
	ElseIf SEE->EE_CODIGO $ '275/279/399' // Real / HSBC
		cReturn:= SEE->EE_CODEMP
	Else
		cReturn:= ' '
	End
	
ElseIf cOP == "21"	
    If SEE->EE_CODIGO = '353' // Especifico para bancos que usam historio no pagamento.
    	cReturn:= SUBS(TIME(), 1, 2) + SUBS(TIME(), 4, 2)+Space(11)+'00183'
    Else
    	cReturn:= ' '
    End          

ElseIf cOP == "22"  // zerar o campo que acumula o valor total dos pagamentos para o proximo arquivo de remessa.
	
	RecLock("SEE",.F.)
		SEE->EE_VALTOT := 0
	MsUnlock()
	// Zero as variaveis publicas, pois é trailer de lote
	_nTotEnt   := 0
	_nTotAcres := 0
	_nTotGps   := 0
	_nSubDar   := 0
	_nTotDar   := 0
	_cReturn:= ""

EndIf

Return(cReturn)