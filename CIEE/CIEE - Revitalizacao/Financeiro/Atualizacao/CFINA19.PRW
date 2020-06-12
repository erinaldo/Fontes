#include "rwmake.ch"
#include "protheus.ch"
#include "TOPCONN.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#include "fileio.ch"
#DEFINE _EOL chr(13) + chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA19 บAutor  ณPatricia Fontanezi  บ Data ณ  05/03/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina para Geracao de WorkFlow Cartao Empresa Itau        บฑฑ
ฑฑบ          ณ (Aviso)- Vencimento do Cartao                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CFINA19()

Local cQuery	 := ""
Local _cEmail	 := ""
Local _cTitulo   := ""
Local _cTexto    := ""

Private oProcess
Private oHtml

_cTexto 	:= ""
_cEOL     	:= CHR(13) + CHR(10)
_lFirst		:= .T.
_nCont		:= 0
_Cor		:= 0
_Cor1		:= "#B4BAC6"
_Cor2		:= "#9397A0"
//_dVencto	:= DDATABASE + GetMv("CI_DTVENC")  // AVISO DE WF 3 MESES ANTES DO VENCIMENTO DO CARTรO

wfPrepENV( "01", "01")

ChkFile("SZK")

//A Abertura de qualquer variavel ou parametros do sistema devem vir sempre depois do wfPrepEnv()
_dVencto	:= DDATABASE + GetMv("CI_DTVENC")  // AVISO DE WF 3 MESES ANTES DO VENCIMENTO DO CARTรO

cQuery := "SELECT * "
cQuery += "FROM "+RetSQLname('SZK')+" "
cQuery += "WHERE D_E_L_E_T_ = '' "
cQuery += "AND ZK_VENCTO <> '' " 
cQuery += "AND ZK_TIPO = '4' "
cQuery += "AND ZK_STATUS = 'A' "

IF SELECT("SZKTMP") > 0
	SZKTMP->(DBCLOSEAREA())
ENDIF

TcQuery cQuery New Alias "SZKTMP"

//TcSetField("SZKTMP","ZK_E_DTENV","D",8, 0 )
//TcSetField("SZKTMP","ZK_E_DTBLQ","D",8, 0 )

DbSelectArea("SZKTMP")
Do While !EOF() 
		IF SZKTMP->ZK_VENCTO == SUBSTR(DTOC(_dVencto),4,3) + "20"+SUBSTR(DTOC(_dVencto),7,2)   		
//		   	_lFirst		:= .T.
//		   	_Cor		:= 0
			
		    DbSelectArea("SZK")
			DbSetOrder(2) 
			If DbSeek(xFilial("SZK")+ SZKTMP->ZK_NUMCON + SZKTMP->ZK_FORNECE + SZKTMP->ZK_LOJA)
				_cEmail		:= 'tesouraria@cieesp.org.br'
			Else
				DbSelectArea("SZKTMP")
				SZKTMP->(DbSkip())
				Loop
			EndIf
		 
			_nCont++	
		 
			If !Empty (_cEmail) .and. _lFirst
				oProcess:= TWFProcess():New("000001", "Workflow Aviso Vencimento de Cartao")
				oProcess:NewVersion(.T.)
			    oProcess:NewTask( "Workflow vencimento Cartao", "\Workflow\WFCIEE001.htm")
				oProcess:bReturn	:= ""
				oProcess:cSubject	:= "Cart๕es com Vencimento para daqui 3 meses"	//Assunto
				oProcess:cTo  		:= _cEmail
				_lFirst	:= .F.
				oHtml	:= oProcess:oHTML
			EndIf
			
			If _Cor % 2 == 0
				_Cor3 := _Cor1
			Else
				_Cor3 := _Cor2
			EndIf
			
			AAdd( (oHtml:ValByName( "t.1"    )), ALLTRIM(SZKTMP->ZK_NROCRT))
			AAdd( (oHtml:ValByName( "t.2"    )), ALLTRIM(SZKTMP->ZK_NOME))
			AAdd( (oHtml:ValByName( "t.3"    )), ALLTRIM(SZKTMP->ZK_UNIDADE))
			AAdd( (oHtml:ValByName( "t.4"    )), ALLTRIM(SZKTMP->ZK_VENCTO))
		  	AAdd( (oHtml:ValByName( "t.6"    )), _Cor3 )
		  	
			_Cor++		
			
		ENDIF	

	DbSelectArea("SZKTMP")
  	SZKTMP->(DbSkip())
EndDo 

If _nCont > 0
	oProcess:Start()
EndIf
                
DbSelectArea("SZKTMP")
DbCloseArea()

Return()