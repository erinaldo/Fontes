#Include "PROTHEUS.Ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ ECSU001  ³ Autor ³ ROBERTO R.MEZZALIRA  ³ Data ³ 13.01.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ EXECBLOCK PARA GATILHO PARA VALICAO DE VALOR DO TITULO     ³±± 
±±³          ³ DO CONTAS A PAGAR x CODIGO DE BARRAS                       ³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ECSU001()

Local   _aArea   :=  getarea()
Local   _cBco    :=  Substr(M->E2_CODBAR,1,3) //IDENTIFICA O BANCO DO CODIGO DE BARRA
LOCAL   _nVlr    :=  0  // RETORNA O VALOR DO CODIGO DE BARRA
LOCAL   _cVlr    :=  "" 
LOCAL 	_cVlrtit :=  ""
Private _Lok   := .F. 
DO Case
   Case _cBco = "000"  //BRADESCO OK MANUAL COBRANCA INTERNA
      _nVlr := (VAL(Substr(M->E2_CODBAR,10,10))/100)
   Case _cBco = "001"  //BRASIL
      _nVlr := (VAL(Substr(M->E2_CODBAR,10,10))/100)
   Case _cBco = "237"  //BRADESCO OK MANUAL
      _nVlr := (VAL(Substr(M->E2_CODBAR,10,10))/100)
   Case _cBco = "341"  //ITAU OK MANUAL
      _nVlr := (VAL(Substr(M->E2_CODBAR,10,10))/100)
   Case _cBco = "356"  // REAL
      _nVlr := (VAL(Substr(M->E2_CODBAR,10,10))/100) 
   Case _cBco = "399"  //HSBC OK MANUAL
      _nVlr := (VAL(Substr(M->E2_CODBAR,10,10))/100) 
   Case _cBco = "353" //SANTANDER
      _nVlr := (VAL(Substr(M->E2_CODBAR,10,10))/100) 
   OTHERWISE
      _nVlr := (VAL(Substr(M->E2_CODBAR,10,10))/100) 
ENDCASE
IF  SE2->E2_VALOR <> _nVLR  
	_cVlr    := PADR(transform(_nVlr,"@E 99,999,999.99"),18)        
	_cVlrtit := PADR(transform(SE2->E2_VALOR,"@E 99,999,999.99"),18)        	
    MsgInfo("Valor do Boleto R$ "+_cVlr+CHR(13)+" Difere do Titulo R$ "+_cVlrtit+CHR(13)+CHR(13)+"Cancele a operacao e ache o titulo correto"+CHR(13),"Boleto invalido")
    _Lok   := .F.

ELSE
    _Lok   := .T. 
ENDIF       

Restarea(_aArea)
RETURN(_Lok)
