#Include "rwmake.Ch" 
#Include "Protheus.Ch" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FIFINE07  ºAutor  ³TOTVS               º Data ³  09/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Movimentacao das Aplicacoes CDB/ Fundo de Aplicacao        º±±
±±º          ³                                                            º±±
±±º          ³ CALCULAR IR POR PERIODO                                    º±±
±±º          ³ CALCULAR FUNDO                                             º±±
±±º          ³ CONTABILIZACAO                                             º±±
±±º          ³ RELATORIO                                                  º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FIFINE07()

Local aCores    := {	{ 'ZI_STATUS=="A"' , 'BR_VERMELHO'},;
						{ 'ZI_STATUS=="C"' , 'BR_PRETO'},;
						{ 'ZI_STATUS=="P"' , 'BR_VERDE'}}

Private aRotina
Private _cString   := "SZI"
Private cCadastro  := "MOVIMENTAÇÃO DE APLICAÇÃO FINANCEIRA"

aRotina := {	{"Pesquisar" ,"AxPesqui"	,0,1},;
				{"Visualizar","AxVisual"	,0,2},;
				{"Calcular"  ,"u_FIFINE73"	,0,3},;
				{"Incluir"   ,"AxInclui"	,0,3},;
				{"Alterar"   ,"AxAltera"	,0,4},;
				{"Excluir"   ,"u_FIFINE72"	,0,5},;
				{"Legenda"   ,"u_FIFINE71"	,0,6}}


mBrowse(06, 01, 22, 75, _cString,,,,,,aCores,,, )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FIFINE07  ºAutor  ³Microsiga           º Data ³  09/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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

FormBatch("Calculo de Aplicações",aSays,aButtons)

Do Case
	Case nOpca == 1
		_dData		:= mv_par01

		DbSelectArea("SZH") //Cadastro de Aplicacoes
		DbSetOrder(1)
		DbGotop()
		Do While !EOF()
			_dDtAnt		:= mv_par01
		
			If SZH->ZH_TIPO == "C" //CDB
				_nSldIni	:= SZH->ZH_SALDO
				_nTxCDI		:= SZH->ZH_TXCDI
				_cIndice	:= SZH->ZH_INDICE
				_nDiasUteis	:= 252 //criar parametro configurador
					
				DbSelectArea("SZJ") //Cadastro de Moedas (Indices)
				DbSetOrder(1)
				DbGotop()
				If DbSeek(xFilial("SZJ")+_cIndice+dtoS(_dData)) //Numero do Indice amarrado ao cadastro de Aplicacao + Data de Calculo
					_cIndIni	:= SZJ->ZJ_CDI

					Do While !EOF() .and. SZJ->ZJ_NUMERO == SZH->ZH_INDICE .and. SZJ->ZJ_DATA <= mv_par02

						If SZJ->ZJ_STATUS == "C" // Se um Dia ja estiver sido calculado Não pode Executar novamente
							SZJ->(DbSkip())
							_dDtAnt 	:= SZJ->ZJ_DATA
							_cIndIni	:= SZJ->ZJ_CDI
							Loop
						EndIf

						// A Data de Inicio da Aplicação mesmo (-)  o ultimo dia de calculo (selecionado pelo usuario)
						// analisa a regra da tabela AR do SX5 (tabela com percentuais de IR conforme o numero de dias da Aplicação)
						_dDtIRRF	:= SZJ->ZJ_DATA - SZH->ZH_DATAINI
						SX5->(DbSetOrder(1))
						If SX5->(DbSeek(xFilial("SX5")+"AR"+ALLTRIM(STR(_dDtIRRF)),.T.)) //Tabela de Percentuasi de IRRF da Aplicaco
							_cPercIR	:= Alltrim(SX5->X5_DESCRI)
						Else
							_cPercIR	:= 0
						EndIf
						
						_nTxCalc	:= ((1+(_cIndIni/100))^(1/_nDiasUteis))-1
						_nFator		:= (_nTxCalc * (_nTxCDI/100))+1

						_dDtAnt := DataValida((_dDtAnt - 1),.F.)
						DbSelectArea("SZI")
						DbSetOrder(1)
						If DbSeek(xFilial("SZI")+SZH->ZH_NUMERO+dtoS(_dDtAnt)+"C")
							_nSldIni := SZI->ZI_SALDO
						EndIf

						_nSalCDB	:= round(_nSldIni * _nFator,2)
				
						_nRend		:= _nSalCDB - _nSldIni
						_nValIrrf	:= (_nRend * (_cPercIR/100))
		
						RecLock("SZI",.T.)
						SZI->ZI_FILIAL	:= xFilial("SZI")
						SZI->ZI_DATA  	:= SZJ->ZJ_DATA
						SZI->ZI_TIPO  	:= SZH->ZH_TIPO 		//CDB
						SZI->ZI_NUMERO	:= SZH->ZH_NUMERO 		//Numero da Aplicação
						SZI->ZI_BANCO 	:= SZH->ZH_BANCO
						SZI->ZI_AGENCI	:= SZH->ZH_AGENCI
						SZI->ZI_CONTA 	:= SZH->ZH_CONTA
						SZI->ZI_SALDOAN	:= _nSldIni
						SZI->ZI_STATUS	:= "C" 					//Calculado
						SZI->ZI_HIST  	:= "CALCULADO"
						SZI->ZI_VALIRF	:= _nValIrrf
						SZI->ZI_QTDCOTA	:= 0
						SZI->ZI_SLDCOT	:= 0
						SZI->ZI_SALDO 	:= _nSalCDB
						SZI->ZI_DATARE	:= CTOD("//")
						SZI->ZI_VALREG	:= 0
						SZI->ZI_LA		:= ""
						SZI->ZI_FATOR 	:= _nFator
						MsUnLock()


						RecLock("SZJ",.F.)
						SZJ->ZJ_STATUS := "C" //Calculado
						MsUnLock()

						DbSelectArea("SZJ")
						SZJ->(DbSkip())
						_dDtAnt 	:= SZJ->ZJ_DATA
						_cIndIni	:= SZJ->ZJ_CDI
					EndDo
				EndIf
			ElseIf SZH->ZH_TIPO == "F"	//Fundo de Aplicação
				_nSldIni	:= SZH->ZH_SALDO
				_nQtdCotas	:= SZH->ZH_QTDCOT
				_cIndice	:= SZH->ZH_INDICE
				
				DbSelectArea("SZJ") //Cadastro de Moedas (Indices)
				DbSetOrder(1)
				DbGotop()
				If DbSeek(xFilial("SZJ")+_cIndice+dtoS(_dData)) //Numero do Indice amarrado ao cadastro de Aplicacao + Data de Calculo
					_cIndIni	:= SZJ->ZJ_INDICE

					Do While !EOF() .and. SZJ->ZJ_NUMERO == SZH->ZH_INDICE .and. SZJ->ZJ_DATA <= mv_par02

						_dDtAnt := DataValida((_dDtAnt - 1),.F.)
						DbSelectArea("SZI")
						DbSetOrder(1)
						If DbSeek(xFilial("SZI")+SZH->ZH_NUMERO+dtoS(_dDtAnt)+"C")
							_nSldIni := SZI->ZI_SALDO
						EndIf
		
						_nSalFundo	:= round(_nQtdCotas * _cIndIni,2)
		
						_nRend		:= _nSalFundo - _nSldIni
		
						RecLock("SZI",.T.)
						SZI->ZI_FILIAL	:= xFilial("SZI")
						SZI->ZI_DATA  	:= SZJ->ZJ_DATA
						SZI->ZI_TIPO  	:= SZH->ZH_TIPO 		//FUNDO
						SZI->ZI_NUMERO	:= SZH->ZH_NUMERO 		//Numero da Aplicação
						SZI->ZI_BANCO 	:= SZH->ZH_BANCO
						SZI->ZI_AGENCI	:= SZH->ZH_AGENCI
						SZI->ZI_CONTA 	:= SZH->ZH_CONTA
						SZI->ZI_SALDOAN	:= _nSldIni
						SZI->ZI_STATUS	:= "C" 					//Calculado
						SZI->ZI_HIST  	:= "CALCULADO"
						SZI->ZI_VALIRF	:= 0
						SZI->ZI_QTDCOTA	:= 0
						SZI->ZI_SLDCOT	:= 0
						SZI->ZI_SALDO 	:= _nSalFundo
						SZI->ZI_DATARE	:= CTOD("//")
						SZI->ZI_VALREG	:= 0
						SZI->ZI_LA		:= ""
						SZI->ZI_FATOR 	:= _cIndIni
						MsUnLock()

						DbSelectArea("SZJ")
						SZJ->(DbSkip())
						_dDtAnt 	:= SZJ->ZJ_DATA
						_cIndIni	:= SZJ->ZJ_CDI
					EndDo
				EndIf
			EndIf
			DbSelectArea("SZH")
			SZH->(DbSkip())
		EndDo
EndCase

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FIFINE07  ºAutor  ³Microsiga           º Data ³  09/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FIFINE71()
Local aCor := {}

aAdd(aCor,{"BR_VERDE" 		,"PROVISÃO" })
aAdd(aCor,{"BR_VERMELHO"	,"AJUSTADO"	})
aAdd(aCor,{"BR_PRETO"		,"CALCULADO"})

BrwLegenda(cCadastro,OemToAnsi("Movimentos"),aCor)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FIFINE07  ºAutor  ³Microsiga           º Data ³  09/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FIFINE72(cAlias,nReg,nOpc)

Local nOpcA := 0

IF SZI->ZI_STATUS == "C"
	Aviso("Lançamento com Status - Calculado","Não Pode ser excluído Manualmente...",{"Sair"},2)
	RETURN .F.
ENDIF

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
      Help("",1,"","mBrowDel","Não é possível a exclusão, não há registros.",1,0)
   Endif
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FIFINE07  ºAutor  ³Microsiga           º Data ³  09/04/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function _fCriaSX1()

aRegs     := {}
nSX1Order := SX1->(IndexOrd())

SX1->(dbSetOrder(1))

cPerg := Padr(cPerg,10)

/*
             grupo ,ordem,pergunt    ,perg spa       ,perg eng        , variav ,tipo ,tam,dec,pres,gsc,valid,var01     ,def01    ,defspa01 ,defeng01 ,cnt01,var02,def02      ,defspa02  ,defeng02  ,cnt02,var03,def03        ,defspa03     ,defeng03     ,cnt03 ,var04,def04,defspa04,defeng04,cnt04,var05,def05,defspa05,defeng05,cnt05,f3,"","","",""
*/
aAdd(aRegs,{cPerg  ,"01" ,"Data De  ","Data Calculo ","Data Calculo  ","mv_ch1","D" ,08 ,00 ,0  ,"C",""   ,"mv_par01",""       ,""       ,""       ,""   ,""   ,""        ,""        ,""        ,""   ,""   ,""           ,""           ,""           ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,"","","","",""  })
aAdd(aRegs,{cPerg  ,"02" ,"Data Ate ","Data Calculo ","Data Calculo  ","mv_ch2","D" ,08 ,00 ,0  ,"C",""   ,"mv_par02",""       ,""       ,""       ,""   ,""   ,""        ,""        ,""        ,""   ,""   ,""           ,""           ,""           ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,"","","","",""  })
//aAdd(aRegs,{cPerg  ,"02" ,"Nome         ","Nome         ","Nome          ","mv_ch2","C" ,50 ,00 ,0  ,"G",""   ,"mv_par02",""       ,""       ,""       ,""   ,""   ,""        ,""        ,""        ,""   ,""   ,""           ,""           ,""           ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,"","","","","@!"})
//aAdd(aRegs,{cPerg  ,"03" ,"Ativos       ","Ativos       ","Ativos        ","mv_ch3","C" ,01 ,00 ,0  ,"C",""   ,"mv_par03","Sim"    ,"Sim"    ,"Sim"    ,""   ,""   ,"Nao"     ,"Nao"     ,"Nao"     ,""   ,""   ,""           ,""           ,""           ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,"","","","",""  })

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