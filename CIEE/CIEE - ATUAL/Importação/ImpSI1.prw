#INCLUDE "rwmake.ch"
#INCLUDE "DelAlias.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณImpSI1    บ Autor ณ NADIA C.D.MAMUDE   บ Data ณ  07/06/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Importa o arquivo de Plano de Contas                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE.                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function ImpSI1()
// Declaracao das variaveis.
Local _cPath, _cMsg
_cPath := "\TEMP\"  // Caminho no servidor onde ficarao os arquivos DBFs.
_cMsg := "Esse programa ira importar o arquivo de Plano de Contas no " +;
"diretorio " + _cPath + " no servidor. Confirma?"
If MsgBox(_cMsg, "ATENCAO", "YESNO")
	ProcSI1(_cPath)
Endif
Return


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณStatic Function apos a confirmacao do usuario.        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Static Function ProcSI1(_cPath)

// Declaracao das variaveis.
Local _lAbrOK := .T., _cMsg
Private lAbortPrint := .F., lEnd := .F.
Public _aAliases
_aAliases := {}

// Abre os arquivos DBFCDX de consumo.
_lAbrOK := AbreArqs (_cPath, "PLCONTAS", "TRB", "CODIGO")

// Processa os meses.
If _lAbrOK
	msAguarde({|lEnd| !(lAbortPrint) .and. ProcSI1("TRB")}, "Importando SI1...", "Aguarde", .T.)
Else
	_cMsg := "Erro ao abrir os arquivos!!!"
	MsgBox(_cMsg, "ATENCAO", "ALERT")
Endif
// Fecha os alias abertos e apaga os arquivos (DBFs e indices temporarios).
FechaAlias(_aAliases)  // DelAlias.ch
Return


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Abre os alias, consistindo os dados.         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Static Function AbreArqs(_cPath, _cArq, _cAlias, _cInd)
// _cPath   - Caminho dos arquivos (DBFs e indices temporarios).
// _cArq    - Arquivo a ser aberto.
// _cAlias  - Alias que ele recebera.
// _cInd    - Indice que sera usado.
// Declaracao das variaveis.
Local _cMsg, _cArqInd, _aAls
// Salva as condicoes atuais.
Local _cAlsAtu := Alias(), _aArea := GetArea()
Local _lRet := .T., _PL

_PL := chr(10) + chr(13) // Salto de linha.
_cPath := AllTrim(_cPath)
_cPath += If (rat("\", _cPath) < len(_cPath), "\", "")
_cArq := _cPath + _cArq + ".DBF"

If File(_cArq)  // Verifica a existencia do arquivo.
	dbUseArea(.T., "DBFCDX", _cArq, _cAlias, .F., .F.)
	// Parametros da funcao dbUseArea
	// 1 - Logico - Abrir nova area.
	// 2 - Char   - "DBFCDX", "TOPCONN"
	// 3 - Char   - Arquivo
	// 4 - Char   - Alias
	// 5 - Logico - Compartilhado
	// 6 - Logico - Apenas leitura.
	// Cria o indice temporario.
	dbSelectArea(_cAlias)
	_cArqInd := _cPath + CriaTrab(nil, .F.)
	IndRegua(_cAlias,_cArqInd,_cInd,,,"Criando indice...", .T.)
	_aAls := {_cAlias, "", _cArqInd + OrdBagExt(), .T.}
	If Type("_aAliases") == "A"  // Verifica a existencia da variavel.
		aAdd (_aAliases, _aAls)
	Endif
Else
	_lRet := .F.
	_cMsg := "O arquivo " + AllTrim(_cArq) + " nao existe." + _PL +;
	"Favor verificar!"
	MsgBox(_cMsg, "ATENCAO", "ALERT")
Endif
// Restaura as condicoes de antes do processamento.
dbSelectArea(_cAlsAtu); RestArea(_aArea)
Return (_lRet)


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณStatic Function que pocessa o alias passado por parametro.       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Static Function ProcSI1(_cAlias)
DbSelectarea(_cAlias)
DbGoTop()
While !eof()               
    
    IncProc()
	ProcRegua("Importando.... ")
	
	Reclock ("SI1", .F.)
	SI1->I1_CODIGO := TRB->CODIGO
    SI1->I1_RES    := TRB->REDUZ
    SI1->I1_DESC   := TRB->DESC
    SI1->I1_NIVEL  := TRB->NIVEL
    SI1->I1_CLASSE := TRB->CLASSE
    SI1->I1_DC     := TRB->DC
    MsUnlock()

	DbSelectarea(_cAlias)
	DbSkip()
Enddo	
Return _lRet