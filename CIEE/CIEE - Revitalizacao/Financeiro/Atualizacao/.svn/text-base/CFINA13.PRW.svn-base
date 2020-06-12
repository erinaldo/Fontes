#include "rwmake.ch"
#include "protheus.ch"
#include "TOPCONN.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA13   บAutor  ณEmerson Natali      บ Data ณ  23/03/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio Analise arquivo Retorno                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CFINA13()

//ณ Declaracao de Variaveis
Local cDesc1 	:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2 	:= "de acordo com os parametros informados pelo usuario."
Local cDesc3 	:= "Analise Arquivo REtorno"
Local titulo 	:= "Analise Arquivo Retorno"
Local nLin 		:= 80
Local Cabec1 	:= "Nr.Cartao    Nome Portador                     Status"
Local Cabec2 	:= ""

Private lAbortPrint 	:= .F.
Private limite 			:= 80
Private tamanho 		:= "P"
Private nomeprog 		:= "CFINA13"
Private nTipo 			:= 18
Private aReturn 		:= { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey 		:= 0
Private m_pag 			:= 01
Private wnrel 			:= "CFINA13"
Private cString 		:= "SA1"

Private _aErro			:= {}
Private cPerg			:= "CFIN57    "

_fCriaSx1()

//ณ Monta a interface padrao com o usuario...
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,Tamanho,,.F.)

Pergunte(cPerg,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ณ Processamento. RPTSTATUS monta janela com a regua de processamento.

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  23/03/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

_fCarregaArq()

If Len(_aErro) > 0

	_xnCartao	:= _aErro[1, 2]

	For _nI := 1 to Len(_aErro)

		//ณ Verifica o cancelamento pelo usuario...
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Return
		Endif

		//ณ Impressao do cabecalho do relatorio. . .
		If nLin > 58
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif

/*
         1         2         3         4         5         6         7         8         9
123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Nr.Reg Nr.Cartao       Limite1       Limite2  Msg Erro
XXX    XXXXXX    99,999,999.99 99,999,999.99  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

Nr.Cartao Nome Portador                   Status
XXXXXX    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

*/

		If _xnCartao <> _aErro[_nI, 2]
			nLin++
			@ nLin,000 PSAY __PrtThinLine()
			nLin++
			_xnCartao	:= _aErro[_nI, 2]
		EndIf

//		@nLin,00 PSAY _aErro[_nI, 1] 								//Numero do Registro
		@nLin,00 PSAY _aErro[_nI, 2]								//Numero Cartao
		@nLin,13 PSAY Substr(Posicione("SZK",4,xFilial("SZK")+alltrim(_aErro[_nI, 2]),"SZK->ZK_NOME"),1,30)
//		@nLin,19 PSAY _aErro[_nI, 3] picture "@E 99,999,999.99"		//Limite 1
//		@nLin,33 PSAY _aErro[_nI, 4] picture "@E 99,999,999.99"		//Limite 2
		@nLin,47 PSAY _aErro[_nI, 5]								//Mensagem Erro

		//So atualiza o Saldo no arquivo Retorno quando for
		//processo de Desbloqueio de cartao
		//Alterado 18/05/09 - analista Emerson Natali
		If _aErro[_nI, 5] == "Processado Sem Inconsistencia"
//			If Empty(_aErro[_nI, 6]) //X = Bloqueado -- branco = Desbloqueado
			If _aErro[_nI, 3] <> 0 // Valor Limite = 0 Bloqueado <> 0 Atualiza Saldo. Arquivo Retorno de Bloqueio nao Atualiza o Saldo Disponivel
				_aArea := GetArea()
				DbSelectArea("SZK")
				DbSetOrder(4)
				If DbSeek(xFilial("SZK")+alltrim(_aErro[_nI, 2]))
					RecLock("SZK",.F.)
					SZK->ZK_E_DTENV := CtoD(" / / ")
					SZK->ZK_E_DTBLQ := CtoD(" / / ")
					SZK->ZK_E_SLDAT := SZK->ZK_E_LIMIT
				EndIf
				RestArea(_aArea)
			EndIf
//		Else
		EndIf

		nLin++
	Next

EndIf

//ณ Finaliza a execucao do relatorio...

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA13   บAutor  ณMicrosiga           บ Data ณ  03/23/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _fCarregaArq()

Local _nReg := 1


	If cEmpant == '01' //SP
		cDirect 	:= "\arq_txt\tesouraria\Importacao\Itau\retorno\"
		cDirectImp  := "\arq_txt\tesouraria\Importacao\Itau\Backup\"
	EndIf
	aDirect    := Directory(cDirect+"*.*")

	If Empty(adirect)
		MsgAlert("Nao existe nenhum arquivo para ser Importado!!!")
		Return
	EndIf

	For _nI := 1 to Len(adirect)
		FT_FUSE(cDirect+adirect[_nI,1])
		FT_FGOTOP()
		cBuffer 	:= 	Alltrim(FT_FREADLN())
		_dData		:= 	STOD(Substr(cBuffer,1,8))
		If _dData <> mv_par01 		//Verifica a data parametro e le os arquivos desta data
			FT_FUSE()				//Fecha o arquivo e vai para o proximo
		Else
			FT_FSKIP()				//Pula primeira linha HEADER
			ProcRegua(FT_FLASTREC())

			Do While !FT_FEOF()
				_nReg 	:= 1
				_cErro 	:= "Processado Sem Inconsistencia"
				IncProc("Processando Leitura do Arquivo Texto...")
				cBuffer 	:=	Alltrim(FT_FREADLN())

				_cTpReg :=	Substr(cBuffer, 17,2) //Tipo de Registro
				If _cTpReg == "99" //Se for TRAILER
					FT_FSKIP()
					Loop
				EndIf

				_cConsDT := Substr(cBuffer,009,1)		//Consistencia Data 	009 - 009(01) (somente arquivo Retorno)
				_cConsHR := Substr(cBuffer,016,1)		//Consistencia Hora 	016 - 016(01) (somente arquivo Retorno)
				_cConsTP := Substr(cBuffer,019,1)		//Consistencia Tipo 	019 - 019(01) (somente arquivo Retorno)
				_cConsCD := Substr(cBuffer,021,1)		//Consistencia Codigo	021 - 021(01) (somente arquivo Retorno)
				_cConsBC := Substr(cBuffer,025,1)		//Consistencia Banco 	025 - 025(01) (somente arquivo Retorno)
				_cConsCL := Substr(cBuffer,036,1)		//Consistencia Cliente	036 - 036(01) (somente arquivo Retorno)
				_cConsCN := Substr(cBuffer,051,1)		//Consistencia CNPJ 	051 - 051(01) (somente arquivo Retorno)
				_cConsNR := Substr(cBuffer,058,1)		//Consistencia Numero	058 - 058(01) (somente arquivo Retorno)
				_cConsPD := Substr(cBuffer,069,1)		//Consistencia Periodo	069 - 069(01) (somente arquivo Retorno)
				_cConsDI := Substr(cBuffer,080,1)		//Consistencia Dia		080 - 080(01) (somente arquivo Retorno)
				_cConsZE := Substr(cBuffer,082,1)		//Consistencia Zera Saq	082 - 082(01) (somente arquivo Retorno)
				_cConsRE := Substr(cBuffer,084,1)		//Consistencia Restabel	084 - 084(01) (somente arquivo Retorno)
				_cConsRG := Substr(cBuffer,085,1)		//Consistencia Registro	085 - 085(01) (somente arquivo Retorno)

				_cZeraSld 	:= Substr(cBuffer,81,01)		//Zera Saques			081 - 081(01) //X - Bloqueio/ branco - Desblq
				_cNrCartao 	:= Substr(cBuffer,52,06) 		//Nr Portador(Cartao)	052 - 057(06)
				_cLimite1 	:= Substr(cBuffer,59,10)		//Limite no Periodo		059 - 068(08,02)
				_cLimite2 	:= Substr(cBuffer,70,10)		//Limite no Periodo		070 - 079(08,02)
				
				_lConsDT := _lConsHR := _lConsTP := _lConsCD := _lConsBC := _lConsCL := _lConsCN := _lConsNR := .F.
				_lConsPD := _lConsDI := _lConsZE := _lConsRE := _lConsRG := .F.


				If _cConsDT == "1"		//Consistencia Data
					_cErro	:= "Invalido Consistencia Data"
					AADD(_aErro,{	Strzero(_nReg,3),_cNrCartao,Val(_cLimite1)/100,Val(_cLimite2)/100,	_cErro,_cZeraSld})
					_lConsDT := .T.
				EndIf

				If _cConsHR == "1"		//Consistencia Hora
					_cErro	:= "Invalido Consistencia Hora"
					AADD(_aErro,{	Strzero(_nReg,3),_cNrCartao,Val(_cLimite1)/100,Val(_cLimite2)/100,	_cErro,_cZeraSld})
					_lConsHR := .T.
				EndIf

				If _cConsTP == "1"		//Consistencia Tipo
					_cErro	:= "Invalido Consistencia Tipo"
					AADD(_aErro,{	Strzero(_nReg,3),_cNrCartao,Val(_cLimite1)/100,Val(_cLimite2)/100,	_cErro,_cZeraSld})
					_lConsTP := .T.
				EndIf

				If _cConsCD == "1"		//Consistencia Codigo
					_cErro	:= "Invalido Consistencia Codigo"
					AADD(_aErro,{	Strzero(_nReg,3),_cNrCartao,Val(_cLimite1)/100,Val(_cLimite2)/100,	_cErro,_cZeraSld})
					_lConsCD := .T.
				EndIf

				If _cConsBC == "1"		//Consistencia Banco
					_cErro	:= "Invalido Consistencia Banco"
					AADD(_aErro,{	Strzero(_nReg,3),_cNrCartao,Val(_cLimite1)/100,Val(_cLimite2)/100,	_cErro,_cZeraSld})
					_lConsBC := .T.
				EndIf

				If _cConsCL == "1"		//Consistencia Cliente
					_cErro	:= "Invalido Consistencia Cliente"
					AADD(_aErro,{	Strzero(_nReg,3),_cNrCartao,Val(_cLimite1)/100,Val(_cLimite2)/100,	_cErro,_cZeraSld})
					_lConsCL := .T.
				EndIf

				If _cConsCN == "1"		//Consistencia CNPJ
					_cErro	:= "Invalido Consistencia CNPJ"
					AADD(_aErro,{	Strzero(_nReg,3),_cNrCartao,Val(_cLimite1)/100,Val(_cLimite2)/100,	_cErro,_cZeraSld})
					_lConsCN := .T.
				EndIf

				If _cConsNR == "1"		//Consistencia Numero
					_cErro	:= "Invalido Consistencia Numero"
					AADD(_aErro,{	Strzero(_nReg,3),_cNrCartao,Val(_cLimite1)/100,Val(_cLimite2)/100,	_cErro,_cZeraSld})
					_lConsNR := .T.
				EndIf

				If _cConsPD == "1"		//Consistencia Periodo
					_cErro	:= "Invalido Consistencia Periodo"
					AADD(_aErro,{	Strzero(_nReg,3),_cNrCartao,Val(_cLimite1)/100,Val(_cLimite2)/100,	_cErro,_cZeraSld})
					_lConsPD := .T.
				EndIf

				If _cConsDI == "1"		//Consistencia Dia
					_cErro	:= "Invalido Consistencia Dia"
					AADD(_aErro,{	Strzero(_nReg,3),_cNrCartao,Val(_cLimite1)/100,Val(_cLimite2)/100,	_cErro,_cZeraSld})
					_lConsDI := .T.
				EndIf

				If _cConsZE == "1"		//Consistencia Zera Saq
					_cErro	:= "Invalido Consistencia Zera Saque"
					AADD(_aErro,{	Strzero(_nReg,3),_cNrCartao,Val(_cLimite1)/100,Val(_cLimite2)/100,	_cErro,_cZeraSld})
					_lConsZE := .T.
				EndIf

				If _cConsRE == "1"		//Consistencia Restabel
					_cErro	:= "Invalido Consistencia Restabelecimento"
					AADD(_aErro,{	Strzero(_nReg,3),_cNrCartao,Val(_cLimite1)/100,Val(_cLimite2)/100,	_cErro,_cZeraSld})
					_lConsRE := .T.
				EndIf

				If _cConsRG == "1"		//Consistencia Registro
					_cErro	:= "Invalido Consistencia Registro"
					AADD(_aErro,{	Strzero(_nReg,3),_cNrCartao,Val(_cLimite1)/100,Val(_cLimite2)/100,	_cErro,_cZeraSld})
					_lConsRG := .T.
				EndIf

				If !(_lConsDT .or. _lConsHR .or. 	_lConsTP .or. _lConsCD .or. _lConsBC .or. 	_lConsCL .or. _lConsCN .or. _lConsNR .or. _lConsPD  .or. 	_lConsDI .or. _lConsZE .or. _lConsRE .or. _lConsRG)
					AADD(_aErro,{	Strzero(_nReg,3),_cNrCartao,Val(_cLimite1)/100,Val(_cLimite2)/100,	_cErro,_cZeraSld})
				EndIf

				FT_FSKIP()
				_nReg++
			EndDo
			FT_FUSE()
		EndIf
	Next

//Copia e Deleta o arquivo da pasta Origem para a pasta Importado. De qualquer Banco
For _nI := 1 to Len(adirect)
	__copyfile(cDirect+adirect[_nI,1],cDirectImp+adirect[_nI,1])
	ferase(cDirect+adirect[_nI,1])
Next

Return(_aErro)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINA13   บAutor  ณMicrosiga           บ Data ณ  03/23/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function _fCriaSx1()

aRegs     := {}
nSX1Order := SX1->(IndexOrd())

SX1->(dbSetOrder(1))

cPerg := Left(cPerg,10)

/*
             grupo ,ordem ,pergunt     ,perg spa ,perg eng , variav ,tipo,tam,dec,pres,gsc,valid ,var01     ,def01    ,defspa01,defeng01,cnt01 ,var02,def02 ,defspa02,defeng02,cnt02   ,var03,def03      ,defspa03,defeng03,cnt03  ,var04,def04           ,defspa04,defeng04,cnt04,var05,def05  ,defspa05,defeng05,cnt05,f3 ,"","","",""
*/
aAdd(aRegs,{cPerg,"01","Data arq.    ?","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For nX := 1 to Len(aRegs)
	If !SX1->(dbSeek(cPerg+aRegs[nX,2]))
		RecLock('SX1',.T.)
		For nY:=1 to FCount()
			If nY <= Len(aRegs[nX])
				SX1->(FieldPut(nY,aRegs[nX,nY]))
			Endif
		Next nY
		MsUnlock()
	Endif
Next nX

SX1->(dbSetOrder(nSX1Order))

Return