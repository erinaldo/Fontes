#INCLUDE "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³cmisc01   º Autor ³ Felipe Raposo      º Data ³  07/08/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Valida a digitacao do tipo do titulo.                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObs.      ³ Esse programa foi desenvolvido de acordo com a solicitacao º±±
±±º          ³ do coordenador Roberto Ayusso.                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function cmisc01(_cTipoTit, _cPR)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _cPar, _cTpPar, _lRet, _cMsg

// tramento para integração
if ISINCALLstack("U_CORIGA01")  
	return .t.
Endif

_aArea := SX6->(GetArea())
_cPar   := IIF(_cPR == "R", "MV_TPTITCR", "MV_TPTITCP")
_cTpPar := GetMV(_cPar)
If !(_lRet := (AllTrim(_cTipoTit) $ _cTpPar))
	_cMsg := "O tipo de título informado não é previsto para utilização no CIEE." + CHR(13) + CHR(10) +;
	"Favor vefiricar o parâmetro " + _cPar
	MsgAlert(OemToAnsi(_cMsg), OemToAnsi("Atenção"))
Endif        

IF cEmpAnt == '01' 	// Somente CIEE-SP tem o novo controle das FLs
	If Alltrim(FunName()) <> "AFIN050TP"
		If AllTrim(_cTipoTit)=="FL"
			MsgBox("Não é permitida a inclusão do tipo FL pela rotina de Contas a Pagar!!! Utilize a rotina adequada!!!",OemToAnsi("Atenção"))	
			SX6->(RestArea(_aArea))
		//	oMainWnd:oWnd:End() //Para o SIGAADV ou direto no modulo ex. SIGAFIN apresenta a tela de FINALIZAR o sistema.
		//	U_AFIN050TP()
		//	Closebrowse() //Funcao para fechar o BROWSE ativo.
			_lRet    := .F.
			Return(_lRet)
		EndIf
	EndIf
ENDIF

SX6->(RestArea(_aArea))
Return (_lRet)