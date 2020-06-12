#include "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ccoma01   º Autor ³ Felipe Raposo      º Data ³  14/08/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Atualiza o campo D1_TOTAL (total do item da nota fiscal de º±±
±±º          ³ entrada) e executa as validacoes padrao do sistema.        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE.                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºObs.      ³ Esse programa nao pode ser continuado pois as validacoes   º±±
±±º          ³ no SX3 passam algumas variaveis como parametro que nao     º±±
±±º          ³ podem ser lidas por aqui.                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ccoma01()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis.                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _lRet, _cValid, _nPsVUnit, _nPsQuant, _nPsTotal, _aAreaX3, _cMsg

// Armazena a area do dicionario de dados antes de processar.
_aAreaX3 := SX3->(GetArea())

// Verifica as posicoes de cada campo no formulario.
_nPsTotal := aScan(aHeader, {|x| AllTrim(x[2]) == "D1_TOTAL"})
_nPsVUnit := aScan(aHeader, {|x| AllTrim(x[2]) == "D1_VUNIT"})
_nPsQuant := aScan(aHeader, {|x| AllTrim(x[2]) == "D1_QUANT"})

// Atualiza o campo "Total" do item da nota fiscal de entrada.
aCols[n, _nPsTotal] := aCols[n, _nPsVUnit] * aCols[n, _nPsQuant]

// Executa as validacoes do dicionario de dados.
_lRet := .F.
SX3->(dbSetOrder(2))
If SX3->(dbSeek("D1_TOTAL"))
	_cValid := "(" + SX3->X3_VALID + ") .and. (" + SX3->X3_VLDUSER + ")"
	_lRet := &_cValid
Endif

// Verifica se o programa foi executado corretamente.
If ValType(_lRet) != "L"
	_cMsg := "Erro na validação ccoma01" + chr(10) + chr(13) +;
	"Informe um administrador do sistema - " + ValType(_lRet)
	MsgBox(OemToAnsi(_cMsg), OemToAnsi("Protheus AP6 - Atenção"), "INFO")
	_lRet := .F.
Endif

// Retorna a area do dicionario de dados apos processar.
SX3->(RestArea(_aAreaX3))
Return (_lRet)