#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA050BCO  ºAutor  ³Emerson             º Data ³  02/07/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ CHAMADO PELO PROGRAMA MATA103 BOTAO OK                    º±±
±±º          ³ CHAMADO PELO PROGRAMA FINA050 BOTAO OK                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/            

USER FUNCTION FA050BCO()

Local _cLj		:= ""
Local _cCodFor	:= ""
Local _cBcoFor	:= ""
Local _cCtaFor  := ""
Local _cDigFor  := ""
Local _cAgFor   := ""  
Local _cBco     := ""
Local _cAg      := ""
Local _cDig     := ""
Local _cConta   := "" 
Local _cRegra	:= ""   
Local _cLD	
Local _nValor	:= 0

IF FUNNAME() $ 'MATA103' 
 	_cCodFor	:= SF1->F1_FORNECE //CA100FOR
	_cLj		:= SF1->F1_LOJA //CLOJA    
   	_nValor		:= 	IIF(SF1->F1_VALBRUT==NIL, CriaVar("D1_TOTAL"), SF1->F1_VALBRUT)
ENDIF

IF FUNNAME() $  'FINA050'
	_cCodFor	:= M->E2_FORNECE
	_cLj		:= M->E2_LOJA
	_cLD		:= 	SUBSTR(ALLTRIM(IIF(M->E2_LD==NIL, CriaVar("E2_LD"), M->E2_LD)),1,3)  
	_nValor		:= 	IIF(M->E2_VALOR==NIL, CriaVar("E2_VALOR"), M->E2_VALOR)
ENDIF 

_cQry	:= " SELECT ZK_BANCO, ZK_AGENCIA, ZK_NUMCON, ZK_DVAG, ZK_FORNECE, ZK_NROPOP, ZK_TIPO "
_cQry	+= " FROM "
_cQry 	+= RetSqlName("SZK")
_cQry 	+= " WHERE ZK_FORNECE = '"+_cCodFor+"' AND ZK_LOJA = '"+_cLj+"' "
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
	DBSELECTAREA("SE2")
	DBGOTOP()  
	DBSETORDER(6)
	IF DBSEEK(xFilial("SE2")+SF1->F1_FORNECE +SF1->F1_LOJA + "   " + SF1->F1_DOC)   
		RECLOCK("SE2",.F.)
   		// BANCO FORNECEDOR
		SE2->E2_BANCO		:= _cBcoFor
		SE2->E2_AGEFOR		:= _cAgFor
		SE2->E2_DVFOR		:= _cDigFor
		SE2->E2_CTAFOR		:= _cCtaFor
		// BANCO BORDERO
		SE2->E2_BCOBOR		:= _cBco
		SE2->E2_AGBOR		:= _cAg
		SE2->E2_CCBOR		:=_cConta
		SE2->E2_MODELO		:= _cRegra  
		MSUNLOCK() 
	ENDIF
ENDIF

IF SELECT("TRB") > 0
	TRB->(DBCLOSEAREA())
ENDIF	

RETURN

