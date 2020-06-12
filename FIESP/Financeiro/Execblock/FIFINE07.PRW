#Include "rwmake.Ch" 
#Include "Protheus.Ch" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFIFINE07  บAutor  ณTOTVS               บ Data ณ  09/03/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Movimentacao das Aplicacoes CDB/ Fundo de Aplicacao        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณ CONTABILIZACAO                                             บฑฑ
ฑฑบ          ณ RELATORIO                                                  บฑฑ
ฑฑบ          ณ COME COTAS (TODO MES DE MAIO E NOVEMBRO) DE CADA ANO.      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FIFINE07()
Local aCores    := {	{ 'ZI_STATUS=="1"' , 'BR_PRETO'},;
						{ 'ZI_STATUS<>"1"' , 'BR_VERDE'}}
					

Private aRotina
Private _cString   := "SZI"
Private cCadastro  := "MOVIMENTAวรO DE APLICAวรO FINANCEIRA"

aRotina := {	{"Pesquisar" ,"AxPesqui"	,0,1},;
				{"Visualizar","AxVisual"	,0,2},;
				{"Calcular"  ,"u_FIFINE73"	,0,3},;
				{"Incluir"   ,'AxInclui("SZI", , , , , ,"U_FI07TOK()")'	,0,3},;
				{"Alterar"   ,"u_FIFINE74"	,0,4},;
				{"Excluir"   ,"u_FIFINE72"	,0,5},;
				{"Legenda"   ,"u_FIFINE71"	,0,6}}

mBrowse(06, 01, 22, 75, _cString,,,,,,aCores,,, )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFIFINE07  บAutor  ณMicrosiga           บ Data ณ  09/03/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FIFINE73

Local aSays    := {}
Local aButtons := {}
Local nOpca    := 0

cPerg := "FIFINE07"

_fCriaSX1() //Cria SX1 Perguntas (parametros)

AADD(aSays, " Este Programa tem o objetivo de Calcular diariamente as         ")
AADD(aSays, " Aplicacoes conforme parametros definidos pelo usuario           ")
AADD(aSays, "                                                                 ")

AADD(aButtons,{1,.T.,{|o| nOpca:=1,o:oWnd:End()	}})
AADD(aButtons,{2,.T.,{|o| nOpca:=0,o:oWnd:End()	}})
AADD(aButtons,{5,.T.,{|| _fCriaSX1()}})

FormBatch("Calculo de Aplica็๕es",aSays,aButtons)

If nOpca == 1
	

	If mv_par01 <= GetMv("FI_XFECHAP")
		Aviso("Data Informado nao permitida","Mes ja encerrado... Ultimo fechamento "+dtoc(GetMv("FI_XFECHAP")),{"Sair"},2)
		RETURN
	EndIf

	_aTabIrr	:= {}
	DbSelectArea("SX5")
	SX5->(DbSetOrder(1))
	If SX5->(DbSeek(xFilial("SX5")+"AR",.T.)) //Tabela de Percentuasi de IRRF da Aplicaco
		Do While !EOF() .and. Alltrim(SX5->X5_TABELA) == "AR"
			aadd(_aTabIrr,{val(SX5->X5_CHAVE),val(SX5->X5_DESCRI)})
			DbSelectArea("SX5")
			SX5->(DbSkip())
		EndDo
	EndIf
	
	_dData		:= mv_par01
	
	DbSelectArea("SZH") //Cadastro de Aplicacoes
	DbSetOrder(1)
	DbGotop()
	If !Empty(mv_par03)
		DbSeek(xFilial("SZH")+mv_par03)
	EndIf
	Do While !EOF() .AND. SZH->ZH_FILIAL == xFilial("SZH") .AND. (mv_par03 <= SZH->ZH_NUMERO .AND. SZH->ZH_NUMERO <= mv_par04)
		_dDtAnt		:= mv_par01
		
		If SZH->ZH_TIPO == "C" //CDB
			_nSldIni	:= IIF(_dDtAnt<=SZH->ZH_DTSALDO, SZH->ZH_SALDINI, SZH->ZH_SLDATU)
			_nTxCDI		:= SZH->ZH_TXCDI
			_cIndice	:= SZH->ZH_MOEDA //SZH->ZH_NUMERO
			_nDiasUteis	:= GetMv("FI_DUTEAPL") //252 - VALOR PADRAO DE DIAS UTEIS
		ElseIf SZH->ZH_TIPO == "F"	//Fundo de Aplica็ใo
			_nSldIni	:= IIF(_dDtAnt<=SZH->ZH_DTSALDO, SZH->ZH_SALDINI, SZH->ZH_SLDATU)
			_nQtdCotas	:= SZH->ZH_QTDCOT
			_cIndice	:= SZH->ZH_MOEDA //SZH->ZH_NUMERO
		EndIf
		
		DbSelectArea("SZJ") //Cadastro de Moedas (Indices)
		DbSetOrder(1)
		DbGotop()
		DbSeek(xFilial("SZJ")+_cIndice+dtoS(_dData),.t.) //Numero do Indice amarrado ao cadastro de Aplicacao + Data de Calculo
		_cIndIni	:= IIF(SZH->ZH_TIPO == "C",SZJ->ZJ_CDI,SZJ->ZJ_INDICE)
		
		Do While !EOF() .and. SZJ->ZJ_NUMERO == SZH->ZH_MOEDA .and. SZJ->ZJ_DATA <= mv_par02
			
			If !(SZJ->ZJ_DATA > SZH->ZH_DATAINI)
				DbSelectArea("SZJ")
				_nSldIni	:= IIF(SZJ->ZJ_DATA<=SZH->ZH_DTSALDO, SZH->ZH_SALDINI, SZH->ZH_SLDATU)
				SZJ->(DbSkip())
				Loop
			EndIf

			If SZJ->ZJ_STATUS == "C" // Se um Dia ja estiver sido calculado Nใo pode Executar novamente
				SZJ->(DbSkip())
				_dDtAnt 	:= SZJ->ZJ_DATA
				_cIndIni	:= IIF(SZH->ZH_TIPO == "C",SZJ->ZJ_CDI,SZJ->ZJ_INDICE)
				Loop
			EndIf
			
			If SZH->ZH_ENCERR == "1"
				If SZJ->ZJ_DATA > SZH->ZH_DTENCER
					Exit //Loop
				EndIf
			EndIf

			_aAreaSZJ := GetArea()
			DbSelectArea("SZI")
			DbSetOrder(1)
			If DbSeek(xFilial("SZI")+SZH->ZH_NUMERO+DTOS(DATAVALIDA(SZJ->ZJ_DATA-1,.F.)))
				Do While !EOF() .and. SZI->ZI_DATA == DATAVALIDA(SZJ->ZJ_DATA-1,.F.)
					If SZI->ZI_STATUS <> "1"
						_nSldIni := SZI->ZI_SALDO
					EndIf
					DbSelectArea("SZI")
					SZI->(DbSkip())
				EndDo
			EndIf
			RestArea(_aAreaSZJ)
			// A Data de Inicio da Aplica็ใo menos (-)  o ultimo dia de calculo (selecionado pelo usuario)
			// analisa a regra da tabela AR do SX5 (tabela com percentuais de IR conforme o numero de dias da Aplica็ใo)
			_dDtIRRF	:= iif(SZJ->ZJ_DATA - SZH->ZH_DATAINI == 0, 1, SZJ->ZJ_DATA - SZH->ZH_DATAINI)
			
			_nPosPercIr := ascan(_aTabIrr,{|x| x[1] >= _dDtIRRF})
			_cPercIR 	:= _aTabIrr[_nPosPercIr,2]
			
			If SZH->ZH_TIPO == "C"	//CDB
				_nTxCalc	:= ((1+(_cIndIni/100))^(1/_nDiasUteis))-1
				_nFator		:= (_nTxCalc * (_nTxCDI/100))+1
			EndIf

			If SZH->ZH_TIPO == "C"	//CDB
				_nSaldo	:= round(_nSldIni * _nFator,2)
			Else
				_nSaldo	:= round(_nQtdCotas * _cIndIni,2)
			EndIf
			_nRend		:= _nSaldo - _nSldIni
			_nValIrrf	:= (_nRend * (_cPercIR/100))
			
			_aAreaSZJ := GetArea()
			DbSelectArea("SZI")
			DbSetOrder(1)
			If !DbSeek(xFilial("SZI")+SZH->ZH_NUMERO+dtoS(SZJ->ZJ_DATA))
				RecLock("SZI",.T.)
				SZI->ZI_FILIAL	:= xFilial("SZI")
				SZI->ZI_DATA  	:= SZJ->ZJ_DATA
				SZI->ZI_TIPO  	:= SZH->ZH_TIPO 		//CDB
				SZI->ZI_NUMERO	:= SZH->ZH_NUMERO 		//Numero da Aplica็ใo
				SZI->ZI_BANCO 	:= SZH->ZH_BANCO
				SZI->ZI_AGENCI	:= SZH->ZH_AGENCI
				SZI->ZI_CONTA 	:= SZH->ZH_CONTA
				SZI->ZI_SALDOAN	:= _nSldIni
				SZI->ZI_STATUS	:= "1" 					//Calculado
				SZI->ZI_HIST  	:= "RENDIMENTO"
				SZI->ZI_VALIRF	:= _nValIrrf
				SZI->ZI_SALDO 	:= _nSaldo
				SZI->ZI_DATARE	:= CTOD("//")
				SZI->ZI_VALREG	:= 0
				SZI->ZI_LA		:= ""
				SZI->ZI_FATOR 	:= iif(SZH->ZH_TIPO == "C",_nFator,_cIndIni)
				SZI->ZI_VALOR 	:= _nRend
				MsUnLock()
			Else
				RecLock("SZI",.F.)
				SZI->ZI_FILIAL	:= xFilial("SZI")
				SZI->ZI_DATA  	:= SZJ->ZJ_DATA
				SZI->ZI_TIPO  	:= SZH->ZH_TIPO 		//CDB
				SZI->ZI_NUMERO	:= SZH->ZH_NUMERO 		//Numero da Aplica็ใo
				SZI->ZI_BANCO 	:= SZH->ZH_BANCO
				SZI->ZI_AGENCI	:= SZH->ZH_AGENCI
				SZI->ZI_CONTA 	:= SZH->ZH_CONTA
				SZI->ZI_SALDOAN	:= _nSldIni
				SZI->ZI_STATUS	:= "1" 					//Calculado
				SZI->ZI_HIST  	:= "RENDIMENTO"
				SZI->ZI_VALIRF	:= _nValIrrf
				SZI->ZI_SALDO 	:= _nSaldo
				SZI->ZI_DATARE	:= CTOD("//")
				SZI->ZI_VALREG	:= 0
				SZI->ZI_LA		:= ""
				SZI->ZI_FATOR 	:= iif(SZH->ZH_TIPO == "C",_nFator,_cIndIni)
				SZI->ZI_VALOR 	:= _nRend
				MsUnLock()
			EndIf
			RestArea(_aAreaSZJ)
	
			RecLock("SZH",.F.)
			SZH->ZH_SLDATU	:= _nSaldo
			SZH->ZH_DTSALDO	:= SZJ->ZJ_DATA
			MsUnLock()
			_nSldIni := SZH->ZH_SLDATU
			
			DbSelectArea("SZJ")
			SZJ->(DbSkip())
			_dDtAnt 	:= SZJ->ZJ_DATA
			_cIndIni	:= IIF(SZH->ZH_TIPO == "C",SZJ->ZJ_CDI,SZJ->ZJ_INDICE)
			
		EndDo
		DbSelectArea("SZH")
		SZH->(DbSkip())
	EndDo
EndIf

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFIFINE07  บAutor  ณMicrosiga           บ Data ณ  11/13/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Alteracao                                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FIFINE74()

_opcao := AxAltera(_cString,Recno(),4,,,,,"U_FINE74TOK()")

If _opcao == 1 // botao <OK> da Tela de Alteracao
	//Alert("Funcionou")
EndIf

Return

User Function FINE74TOK

Local lRet := .T.

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFIFINE07  บAutor  ณMicrosiga           บ Data ณ  09/03/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FIFINE71()
Local aCor := {}

aAdd(aCor,{"BR_VERDE" 		,"MANUAL" })
aAdd(aCor,{"BR_PRETO"		,"CALCULADO"})

BrwLegenda(cCadastro,OemToAnsi("Movimentos"),aCor)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFIFINE07  บAutor  ณMicrosiga           บ Data ณ  09/03/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FIFINE72(cAlias,nReg,nOpc)

Local nOpcA := 0

//IF SZI->ZI_STATUS == "1"
//	Aviso("Lan็amento com Status - Calculado","Nใo Pode ser excluํdo Manualmente...",{"Sair"},2)
//	RETURN .F.
//ENDIF

nOpcA := AxVisual(cAlias,nReg,2)

If nOpcA == 1

lDelFIN :=.T.

   If lDelFIN 
      Begin Transaction
      DbSelectArea(cAlias)
      RecLock(cAlias,.F.)
      dbDelete()
      MsUnLock()
      End Transaction
   Else
      Help("",1,"","mBrowDel","Nใo ้ possํvel a exclusใo, nใo hแ registros.",1,0)
   Endif
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFIFINE07  บAutor  ณMicrosiga           บ Data ณ  09/04/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _fCriaSX1()

aRegs     := {}
nSX1Order := SX1->(IndexOrd())

SX1->(dbSetOrder(1))

cPerg := Padr(cPerg,10)

/*
             grupo ,ordem,pergunt    ,perg spa       ,perg eng        , variav ,tipo ,tam,dec,pres,gsc,valid                      ,var01     ,def01    ,defspa01 ,defeng01 ,cnt01,var02,def02      ,defspa02  ,defeng02  ,cnt02,var03,def03        ,defspa03     ,defeng03     ,cnt03 ,var04,def04,defspa04,defeng04,cnt04,var05,def05,defspa05,defeng05,cnt05,f3   ,"","","",""
*/
aAdd(aRegs,{cPerg  ,"01" ,"Data De   ","             ","              ","mv_ch1","D" ,08 ,00 ,0  ,"C"  ,""                         ,"mv_par01",""       ,""       ,""       ,""   ,""   ,""        ,""        ,""        ,""   ,""   ,""           ,""           ,""           ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""       ,""   ,""   ,"","","",""  })
aAdd(aRegs,{cPerg  ,"02" ,"Data Ate  ","             ","              ","mv_ch2","D" ,08 ,00 ,0  ,"C"  ,"(MV_PAR02 >= MV_PAR01)"   ,"mv_par02",""       ,""       ,""       ,""   ,""   ,""        ,""        ,""        ,""   ,""   ,""           ,""           ,""           ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""       ,""   ,""   ,"","","",""  })
aAdd(aRegs,{cPerg  ,"03" ,"Aplic. De ","             ","              ","mv_ch3","C" ,06 ,00 ,0  ,"C"  ,""                         ,"mv_par03",""       ,""       ,""       ,""   ,""   ,""        ,""        ,""        ,""   ,""   ,""           ,""           ,""           ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""       ,""   ,"SZHREL","","","",""  })
aAdd(aRegs,{cPerg  ,"04" ,"Aplic. Ate","             ","              ","mv_ch4","C" ,06 ,00 ,0  ,"C"  ,""                         ,"mv_par04",""       ,""       ,""       ,""   ,""   ,""        ,""        ,""        ,""   ,""   ,""           ,""           ,""           ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""       ,""   ,"SZHREL","","","",""  })

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

pergunte(cperg,.T.)

Return

User Function FI07TOK

Local lRet := .T.
Local _aAreaSZH := GetArea()

DbSelectArea("SZH")
DbSetOrder(1)
If DbSeek(xFilial("SZH")+M->ZI_NUMERO)
	RecLock("SZH",.F.)
	SZH->ZH_SLDATU := M->ZI_SALDO
	MsUnLock()
EndIf

RestArea(_aAreaSZH)
Return(lRet)