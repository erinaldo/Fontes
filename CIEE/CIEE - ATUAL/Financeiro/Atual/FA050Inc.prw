#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA050INC  ºAutor  ³Emerson             º Data ³  02/07/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FA050INC()

Local _cBcoFor	:= ""
Local _cCtaFor  := ""
Local _cDigFor  := ""
Local _cAgFor   := ""  
Local _cBco     := ""
Local _cAg      := ""
Local _cDig     := ""
Local _cConta   := "" 
Local _cRegra	:= ""   
Local _cLD		:= 	SUBSTR(ALLTRIM(IIF(M->E2_LD==NIL, CriaVar("E2_LD"), M->E2_LD)),1,3)  
Local _nValor	:= 	IIF(M->E2_VALOR==NIL, CriaVar("E2_VALOR"), M->E2_VALOR)

_cValid    := .T.
_nValEncar := 0
_aArea     := GetArea()  

// PATRICIA FONTANEZI 06/12/2012

M->E2_VALLIQ	:= (M->E2_VALOR + M->E2_ACRESC) - (M->E2_DECRESC)

If M->E2_TIPO=="AB-"
   M->E2_PREFIXO := SE2->E2_TIPO
EndIf

If M->E2_RATEIO == "S"
	DbSelectArea("TMP")
	DbGotop()
	Do While !EOF()
		If !TMP->CTJ_FLAG
			_nValEncar += TMP->CTJ_ENCARG
		EndIf
		DbSelectArea("TMP")
		DbSkip()
	EndDo

	If _nValEncar > 0
		If _nValEncar <> M->E2_ISS + M->E2_IRRF + M->E2_INSS + M->E2_PIS
			MsgBox("Total dos Encargos digitado nao confere")
			_cValid    := .F.
		EndIf
	EndIf
EndIf

//CHAMADA DA ROTINA DE AMORTIZACAO
If M->E2_TPAMORT == "S"
//	MsgBox("Rotina de amortizacao realizada!!!","Atencao")
	If Empty(M->E2_CNTD_AM).or.Empty(M->E2_PARC_AM).or.Empty(M->E2_HIST_AM).or.Empty(M->E2_CNTC_AM)
		MsgBox("Alguns dos campos nao esta preenchido. Verificar pasta Amortizacao!!!",OemToAnsi("Atenção"))
		_cValid    := .F.
		RestArea(_aArea)
		Return(_cValid)
	Else
		If Substr(M->E2_CNTD_AM,1,1) $ "1|2"
			If !Empty(M->E2_CCD_AM)
				MsgBox(OemToAnsi("Conta Contabil Grupo 1 e 2 Nao Permite Centro de Custo!!!"),OemToAnsi("Atenção"))
				_cValid    := .F.
				RestArea(_aArea)
				Return(_cValid)
			EndIf
		Else
			If Empty(M->E2_CCD_AM)
				MsgBox(OemToAnsi("Conta Contabil Grupo 3 e 4 Obrigatório Centro de Custo!!!"),OemToAnsi("Atenção"))
				_cValid    := .F.
				RestArea(_aArea)
				Return(_cValid)
			EndIf
		EndIf		

		If Substr(M->E2_CNTC_AM,1,1) $ "1|2"
			If !Empty(M->E2_CCC_AM)
				MsgBox(OemToAnsi("Conta Contabil Grupo 1 e 2 Nao Permite Centro de Custo!!!"),OemToAnsi("Atenção"))
				_cValid    := .F.
				RestArea(_aArea)
				Return(_cValid)
			EndIf
		Else
			If Empty(M->E2_CCC_AM)
				MsgBox(OemToAnsi("Conta Contabil Grupo 3 e 4 Obrigatório Centro de Custo!!!"),OemToAnsi("Atenção"))
				_cValid    := .F.
				RestArea(_aArea)
				Return(_cValid)
			EndIf
		EndIf		
	EndIf
	lEnd	:= .F.
	MsAguarde({|lEnd| RunProc(@lEnd)}, "Aguarde...", OemToAnsi("Processando Contabilização Amortização..."),.T.)
EndIf 

//**********************************************************************
//Inclusao Patricia Fontanezi - 13/11/2012 
//Inclusao automatica do banco fornecedor e banco bordero automatico
//********************************************************************** 
_cForn := M->E2_FORNECE 
IF _cValid
   	_cQry	:= " SELECT ZK_BANCO, ZK_AGENCIA, ZK_NUMCON, ZK_DVAG, ZK_FORNECE, ZK_NROPOP, ZK_TIPO "
	_cQry	+= " FROM "
	_cQry 	+= RetSqlName("SZK")
	_cQry 	+= " WHERE ZK_FORNECE = '"+M->E2_FORNECE+"' AND ZK_LOJA = '"+M->E2_LOJA+"' "
	_cQry 	+= " AND (ZK_TIPO = '1' OR ZK_TIPO = '2') "
	_cQry 	+= " AND ZK_PRINCIP = '1' AND ZK_STATUS = 'A' "
	_cQry 	+= " AND D_E_L_E_T_ <> '*' "
	_cQry 	+= " ORDER BY ZK_FORNECE, ZK_BANCO "     
	
	IF SELECT("TRB") > 0
		TRB->(DBCLOSEAREA())
	ENDIF	
	
	_cQry := ChangeQuery(_cQry)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQry), 'TRB', .T., .T.)  
	
	DBSELECTAREA("TRB") 
	WHILE !EOF()
		_cBcoFor	:= TRB->ZK_BANCO
		_cAgFor		:= TRB->ZK_AGENCIA  
		If TRB->ZK_TIPO = '1'
			_cCtaFor	:= TRB->ZK_NUMCON
		Else
			_cCtaFor	:= TRB->ZK_NROPOP
		EndIf
		_cDigFor	:= TRB->ZK_DVAG         
		TRB->(DBSKIP())
	ENDDO
	
	IF !EMPTY(_cBcoFor) 				
		IF ALLTRIM(_cBcoFor) == "001"    				// BANCO DO BRASIL
			_cBco	:= "001"
			_cAg    := "33367"
	 		_cConta	:= "299370-8"	
	 		_cRegra	:= "01"		
		ELSEIF ALLTRIM(_cBcoFor) $ "033|275|353|356"        // BANCO SANTANDER 
			_cBco	:= "033"
			_cAg    := "0214"
	 		_cConta	:= "2306-2"	
	 		_cRegra	:= "01"	
		ELSEIF ALLTRIM(_cBcoFor) == "237"			        // BANCO BRADESCO
			_cBco	:= "237"
			_cAg    := "33910"
	 		_cConta	:= "86437-4"   
	 		_cRegra	:= "01"		
		ELSEIF ALLTRIM(_cBcoFor) $ "341|409"        		// BANCO ITAU
			_cBco	:= "341"
			_cAg    := "0350"
	 		_cConta	:= "45420-3"
	 		_cRegra	:= "01"		
		ELSE                                                // QUALQUER OUTRO BANCO
			_cBco	:= "237"
			_cAg    := "33910"
	 		_cConta	:= "86437-4"  
	 		IF _nValor >= 5000
	 			_cRegra	:= "08"
	 		ELSE
	 		    _cRegra	:= "03"
	 		ENDIF
		ENDIF
			// BANCO FORNECEDOR
		M->E2_BANCO		:= _cBcoFor
		M->E2_AGEFOR	:= _cAgFor  
		M->E2_DVFOR		:= _cDigFor
		M->E2_CTAFOR	:= _cCtaFor
			// BANCO BORDERO
		M->E2_BCOBOR	:= _cBco
		M->E2_AGBOR		:= _cAg
		M->E2_CCBOR		:=_cConta	
		M->E2_MODELO	:= _cRegra
	ENDIF
ENDIF 

IF SELECT("TRB") > 0
	TRB->(DBCLOSEAREA())
ENDIF	

RestArea(_aArea)

Return(_cValid)

Static Function RunProc(lEnd)

	cMes		:= Val(Substr(DTOC(dDatabase),4,2))
	cAno		:= Val(Substr(DTOC(dDatabase),7,4))
	_cMesCont	:= cMes
	_cAnoCont	:= cAno
	// Data Ultimo dia Util
	_DtCont		:= DataValida(LastDay(ctod("01/"+Str(_cMesCont,2)+"/"+Str(_cAnoCont,4))),.F.)
	_aData		:= {}
	Aadd(_aData,_DtCont)

	For _nY	:= 1 to (M->E2_PARC_AM-1)
		_cMesCont	:= cMes+1
		_cAnoCont	:= iif( _cMesCont >=13 , _cAnoCont+1 , _cAnoCont)
		_cMesCont	:= iif( _cMesCont >=13 , 01          , _cMesCont)
		cMes		:= _cMesCont
		 // Data Ultimo dia Util
		_DtCont		:= DataValida(LastDay(ctod("01/"+Str(_cMesCont,2)+"/"+Str(_cAnoCont,4))),.F.)
		Aadd(_aData,_DtCont)
	Next

	For _nX	:= 1 To Len(_aData)
		_xValidDt	:= CtbValiDt(0,_aData[_nX])
		If !_xValidDt
			_cValid	:= .F.
			Return(lEnd)
		EndIf
	Next

	_nValor	:= M->(E2_VALOR+E2_INSS+E2_IRRF+E2_ISS+E2_PIS)
	u_xCntAmor(M->E2_CNTD_AM,M->E2_CCD_AM,M->E2_PARC_AM,M->E2_HIST_AM,M->E2_CNTC_AM,M->E2_CCC_AM,_nValor,xFilial("SE2")+M->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA))
	lEnd	:= .T.

Return(lEnd)    


