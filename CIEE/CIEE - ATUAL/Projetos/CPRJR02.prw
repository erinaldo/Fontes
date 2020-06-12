#include "rwmake.ch"
#include "TOPCONN.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCPRJR02   บAutor  ณEmerson Natali      บ Data ณ  01/02/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑณDescri…o ณ Relatorio Detalhe de Projetos                              ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ CIEE - Financeiro                                          ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CPRJR02()

Private Titulo   := ""
Private wnrel    := "CPRJR02"
Private cDesc1   := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2   := "de acordo com os parametros informados pelo usuario."
Private cDesc3   := "Relatorio Detalhe de Projetos"
Private cString  := "SZP"
Private lRet     := .F.
Private nomeprog := "CPRJR02"
Private Tamanho  := "G"    
Private Limite   := 220
Private nTipo    := 18
Private m_pag    := 1
Private aReturn  := { "Zebrado", 1,"Administracao", 2, 1, 1, "",1 }
Private nLastKey := 0
Private cPerg    := "CPRJR02   "
Private nLin     := 0
Private Cabec1   := ""
Private Cabec2   := ""
Private _aArray  := {}
Private nCol, nLin

_fCriaSX1() // Verifica as perguntas e cria caso seja necessario


/*ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
  ณ Envia controle para a funcao SETPRINT                        ณ
  ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู*/

wnrel :=  SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,,.F.,Tamanho,,.F.)

Pergunte(cPerg,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

If mv_par03 == 1 // Projeto
	_cTit := "Projeto"
ElseIf mv_par03 == 2 // Tarefa
	_cTit := "Tarefa"
Else
	_cTit := "Projeto/Tarefa"
EndIf

Titulo   := "Cronograma Desenvolvimento de Sistemas - " + Substr(Dtos(DDATABASE),1,4) + " ("+_cTit+")"

RptStatus({||C070Impa()})

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

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

Return ()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ C070IMPA ณ Autor ณ Amauri Bailon         ณ Data ณ 20.07.03 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Chamada do Relatorio                                       ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ FATR070                                                    ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function C070Impa()

Local _nCont, _nCnt

_Mes := {}
aadd (_Mes,	{1,"Janeiro"	})
aadd (_Mes,	{2,"Fevereiro"	})
aadd (_Mes,	{3,"Marco"		})
aadd (_Mes,	{4,"Abril"		})
aadd (_Mes,	{5,"Maio"		})
aadd (_Mes,	{6,"Junho"		})
aadd (_Mes,	{7,"Julho"		})
aadd (_Mes,	{8,"Agosto"		})
aadd (_Mes,	{9,"Setembro"	})
aadd (_Mes,	{10,"Outubro"	})
aadd (_Mes,	{11,"Novembro"	})
aadd (_Mes,	{12,"Dezembro"	})

_nMesIni := Val(Substr(mv_par01,1,2))
_nMesFim := Val(Substr(mv_par02,1,2))

_nQtdMes := (_nMesFim - _nMesIni) + 1 //Quantos colunas de meses gerar
_aMatriz := {}
_aArray  := {}

If _nQtdMes >= 1
//	_aMatriz := aadd(_aMatriz,{"Cod.SSI","Desc.Servico",{array(_nQtdMes,array(5))},"Lider","Grp.Trab."})
	_aMatriz := aadd(_aMatriz,{{"Cod.SSI",""},{"Desc.Servico",""},{array(_nQtdMes,array(5))},{"Lider",""},{"Grp.Trab.",""}})

EndIf

cQuery := " SELECT SZP.R_E_C_N_O_ ZPRECNO, * "
cQuery += " FROM "+RetSqlName("SZP")+" SZP "
cQuery += " WHERE D_E_L_E_T_ = '' "
If !Empty(mv_par04)// <> "99"
	cQuery += " AND ZP_CODANAL = '"+mv_par04+"' "
EndIf
cQuery += " AND ZP_CONCLUS = '' "
cQuery += " AND ZP_CANCEL = '2' "
cQuery += " AND SUBSTRING(ZP_DTPREV,1,6) BETWEEN '"+Substr(mv_par01,4,4)+Substr(mv_par01,1,2)+"' AND '"+Substr(mv_par02,4,4)+Substr(mv_par02,1,2)+"' "
If mv_par03 == 1 // Projeto
	cQuery += " AND ZP_TIPO = '1' "
ElseIf mv_par03 == 2 // Tarefa
	cQuery += " AND ZP_TIPO = '2' "
EndIf
cQuery += " ORDER BY ZP_DTPREV, ZP_NRSSI "
TCQUERY cQuery NEW ALIAS "TMPSZP"

dbSelectArea("TMPSZP")
dbGoTop()

_nCont 	:= 1

Do While !EOF()
	_nCnt 		:= 1
	_nMesIni 	:= Val(Substr(mv_par01,1,2))
	aadd(_aArray,aclone(_aMatriz))

	//Bloco para gravar cabecalho dentro da posicao 3 com o nome dos Meses selecionados.
	For _nY1 := _nCont to _nCont
		For _nI := 1 to _nQtdMes
			_nPos := aScan(_Mes , {|x| x[1] == _nMesIni})
			If _nPos > 0
				_aArray[_nY1, 3, 1, _nI , 1] := _Mes[_nPos,2]
			EndIf
			_nMesIni++
		Next _nI
	Next _nY1

	_aArray[_nCont, 1, 2] :=  TMPSZP->ZP_NRSSI
	
	SZP->(DbGoTo(TMPSZP->ZPRECNO))

	For _nMens := 1 to MlCount(SZP->ZP_SERVICO, 40)
		_aArray[_nCont, 2, 2] +=  MemoLine(SZP->ZP_SERVICO,40,_nMens)
	Next

/*
Inicio do bloco que grava o "X" dentro da Semana (meses)
_aArray [3]
*/
	_cDt 		:= Substr(TMPSZP->ZP_DTPREV,5,2) + "/" + Substr(TMPSZP->ZP_DTPREV,1,4) 
	_dDtValid 	:= DATAVALIDA(STOD(TMPSZP->ZP_DTPREV),.F.) //Falso dia util anterior (sexta)
	_xSemana 	:= CalcSemana(_cDt)
	//Pesquisa a data Prevista para saber em qual semana esta.
	For _nS	:= 1 to len(_xSemana)
		If _dDtValid >= _xSemana[_nS,1] .and. _dDtValid <= _xSemana[_nS,2]
			//Dentro do _aArray so temos 4 semanas (fixo sempre) e dentro da _xSemana o numero real da semana
			// somamos mais 1 para casar a posicao do _aArray. Sendo que a posicao 1 sempre e cabecalho
			_nQualSemana := _xSemana[_nS,3] + 1 
			_nQualSemana := iif(_nQualSemana > 5 , 5, _nQualSemana)
		EndIf
	Next _nS

	_nPos1 := aScan(_Mes , {|x| x[1] == Val(Substr(DtoS(_dDtValid),5,2)) })
	If _nPos > 0
		_cMes 	:= _Mes[_nPos,2]
	EndIf

	For _nY2 := 1 to len(_aArray[_nCont,3,1])
		If _aArray[_nCont, 3, 1, _nY2 , 1] == _cMes
			_nCnt := _nY2
		EndIf
	Next _nY2
		
	_aArray[_nCont, 3, 1, _nCnt , _nQualSemana] :=  "X"
/*
Fim do bloco que grava o "X" dentro da Semana (meses)
*/
	_aArray[_nCont, 4, 2] :=  TMPSZP->ZP_ANALIST	//Lider
	_aArray[_nCont, 5, 2] :=  ""					//Grupo de Trabalho de Analistas.

	dbSelectArea("TMPSZP")
	TMPSZP->(DbSkip())
	_nCont++

EndDo

dbSelectArea("TMPSZP")
TMPSZP->(DbCloseArea())

/*        1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
 Cod.SSI Desc.Servico                                                  Janeiro    Fevereiro  Marco       Abril       Maio        Junho       Julho       Agosto      Setembro    Outubro     Novembro    Dezembro
 xxxxx   xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx     
*/

nLin := 80

If nLin > 65 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 07

	fCabecalho()
	@ nLin, 000 PSAY __PrtThinLine()
	nLin++
Endif

For _nImprime := 1 to Len(_aArray)

	If nLin > 65 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 07
		
		fCabecalho()
		@ nLin, 000 PSAY __PrtThinLine()
		nLin++
	Endif

	@ nLin, 01 PSAY _aArray[_nImprime,1,2] //Cod SSI
	
	nLinhas	:= MlCount(_aArray[_nImprime,2,2], 40)
	
	If nLinhas > 0
		@ nLin, 09 PSAY Substr(_aArray[_nImprime,2,2],1,40) //Descricao SSI

		nCol := 52
		For _nImpMes := 1 to Len(_aArray[_nImprime,3,1])

			If nLin > 65 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 07
				
				fCabecalho()
				@ nLin, 000 PSAY __PrtThinLine()
				nLin++
			Endif

			@ nLin, nCol 	PSAY "|"
			@ nLin, pcol() 	PSAY _aArray[_nImprime, 3, 1, _nImpMes, 2] //Descricao Meses
			nCol+=3
			@ nLin, nCol 	PSAY "|"
			@ nLin, pcol() 	PSAY _aArray[_nImprime, 3, 1, _nImpMes, 3] //Descricao Meses
			nCol+=3
			@ nLin, nCol 	PSAY "|"
			@ nLin, pcol() 	PSAY _aArray[_nImprime, 3, 1, _nImpMes, 4] //Descricao Meses
			nCol+=3
			@ nLin, nCol 	PSAY "|"
			@ nLin, pcol() 	PSAY _aArray[_nImprime, 3, 1, _nImpMes, 5] //Descricao Meses
			nCol+=3
		Next _nImpMes

		@ nLin, nCol 	PSAY "|"
		@ nLin, pcol() PSAY Substr(_aArray[_nImprime, 4, 2],1,10) //Lider
		nCol+=12
		@ nLin, nCol 	PSAY "|"
		@ nLin, pcol() PSAY _aArray[_nImprime, 5, 2] //Grp Trabalho
		nCol+=12
		nLin++
		
		nxMens	:= 41
		For _nLi := 2 to nLinhas

			If nLin > 65 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 07
				
				fCabecalho()
				@ nLin, 000 PSAY __PrtThinLine()
				nLin++
			Endif

			nCol 	:= 52
			_cMens := iif(Empty(Substr(_aArray[_nImprime,2,2],nxMens,40)),Space(40),Substr(_aArray[_nImprime,2,2],nxMens,40))
			@ nLin, 09 PSAY _cMens //Descricao SSI

			For _nXMes := 1 to Len(_aArray[_nImprime,3,1])
				@ nLin, nCol 	PSAY "|"
				nCol+=12
			Next
			@ nLin, nCol 	PSAY "|"
			nCol+=12
			@ nLin, nCol 	PSAY "|"
			nCol+=12
			nLin++
			nxMens+=40
		Next

	EndIf
		
	nCol 	:= 52
	For _nXMes1 := 1 to Len(_aArray[_nImprime,3,1])
		@ nLin, nCol 	PSAY "|"
		nCol+=12
	Next
	@ nLin, nCol 	PSAY "|"
	nCol+=12
	@ nLin, nCol 	PSAY "|"
	nCol+=12
	nLin++
	
Next _nImprime

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSX1       บAutor  ณMicrosiga           บ Data ณ  08/03/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Parametros da rotina                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _fCriaSX1()

aRegs     := {}
nSX1Order := SX1->(IndexOrd())

SX1->(dbSetOrder(1))

cPerg := Left(cPerg,10)

/*
     grupo ,ordem  ,pergunt                        ,perg spa,perg eng , variav ,tipo,tam,dec ,pres,gsc,valid ,var01    ,def01     ,defspa01,defeng01,cnt01,var02,def02      ,defspa02,defeng02,cnt02,var03,def03     ,defspa03,defeng03,cnt03,var04,def04,defspa04,defeng04,cnt04,var05,def05,defspa05,defeng05,cnt05,f3   ,"","","",""
*/
aAdd(aRegs,{cPerg  ,"01" ,"Mes/Ano Previsto De ?" ,"      ","       ","mv_ch1","C" ,07 ,00 ,0   ,"G",""   ,"mv_par01",""        ,""      ,""      ,""   ,""   ,""        ,""      ,""      ,""   ,""   ,""        ,""      ,""     ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,"","","","@E 99/9999"})
aAdd(aRegs,{cPerg  ,"02" ,"Mes/Ano Previsto Ate?" ,"      ","       ","mv_ch2","C" ,07 ,00 ,0   ,"G",""   ,"mv_par02",""        ,""      ,""      ,""   ,""   ,""        ,""      ,""      ,""   ,""   ,""        ,""      ,""     ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,"","","","@E 99/9999"})
aAdd(aRegs,{cPerg  ,"03" ,"Tipo?  "               ,"      ","       ","mv_ch3","C" ,01 ,00 ,0   ,"C",""   ,"mv_par03","Projeto" ,""      ,""      ,""   ,""   ,"Tarefa"  ,""      ,""      ,""   ,""   ,"Ambos"   ,""      ,""     ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,"","","",""})
aAdd(aRegs,{cPerg  ,"04" ,"Analista ?  "          ,"      ","       ","mv_ch4","C" ,02 ,00 ,0   ,"G",""   ,"mv_par04",""        ,""      ,""      ,""   ,""   ,""        ,""      ,""      ,""   ,""   ,""        ,""      ,""     ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,"SI" ,"","","",""})

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


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCPRJR02   บAutor  ณMicrosiga           บ Data ณ  02/03/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CalcSemana(mv_par01)

Local _aMeses
Local _aSemana
Local _nCont

//Funcao abaixo retorna o numero do dia da semana
//1-Domingo
//2-Segunda
//3-Terca
//4-Quarta
//5-Quinta
//6-Sexta
//7-Sabado
//dow(ctod("09/08/08"))

cMes		:= Val(Substr(mv_par01,1,2))
cAno		:= Val(Substr(mv_par01,4,4))

_aMeses	:=	{	{01, "Janeiro"		,FirstDay(ctod("01/01/"+Str(cAno,4))),LastDay(ctod("01/01/"+Str(cAno,4))) },;
				{02, "Fevereiro"	,FirstDay(ctod("01/02/"+Str(cAno,4))),LastDay(ctod("01/02/"+Str(cAno,4))) },;
				{03, "Marco"		,FirstDay(ctod("01/03/"+Str(cAno,4))),LastDay(ctod("01/03/"+Str(cAno,4))) },;
				{04, "Abril"		,FirstDay(ctod("01/04/"+Str(cAno,4))),LastDay(ctod("01/04/"+Str(cAno,4))) },;
				{05, "Maio"			,FirstDay(ctod("01/05/"+Str(cAno,4))),LastDay(ctod("01/05/"+Str(cAno,4))) },;
				{06, "Junho"		,FirstDay(ctod("01/06/"+Str(cAno,4))),LastDay(ctod("01/06/"+Str(cAno,4))) },;
				{07, "Julho"		,FirstDay(ctod("01/07/"+Str(cAno,4))),LastDay(ctod("01/07/"+Str(cAno,4))) },;
				{08, "Agosto"		,FirstDay(ctod("01/08/"+Str(cAno,4))),LastDay(ctod("01/08/"+Str(cAno,4))) },;
				{09, "Setembro"		,FirstDay(ctod("01/09/"+Str(cAno,4))),LastDay(ctod("01/09/"+Str(cAno,4))) },;
				{10, "Outubro"		,FirstDay(ctod("01/10/"+Str(cAno,4))),LastDay(ctod("01/10/"+Str(cAno,4))) },;
				{11, "Novembro"		,FirstDay(ctod("01/11/"+Str(cAno,4))),LastDay(ctod("01/11/"+Str(cAno,4))) },;
				{12, "Dezembro"		,FirstDay(ctod("01/12/"+Str(cAno,4))),LastDay(ctod("01/12/"+Str(cAno,4))) }}

_nPos	:= ascan(_aMeses, {|x| x[1] == cMes })

_aSemana := {{"","",""}}

If _nPos > 0
	_nFor := Val(Substr(DtoC(_aMeses[_nPos,4]),1,2))
	_nCont := 1
	For _nI := 1 to _nFor

		_cDia := dow(ctod(Str(_nI,2)+"/"+Str(cMes,2)+"/"+Str(cAno,4)))
		_cDt  := ctod(Str(_nI,2)+"/"+Str(cMes,2)+"/"+Str(cAno,4))

		If  _cDia == 2 //Segunda
			If _nCont == 1
				_aSemana := {}
			EndIf
			AADD(_aSemana,{_cDt,,_nCont})
		ElseIf  _cDia == 3 //Terca
			If Empty(_aSemana[_nCont,1])
				_aSemana[_nCont,1] := _cDt
			EndIf
		ElseIf  _cDia == 4 //Quarta
			If Empty(_aSemana[_nCont,1])
				_aSemana[_nCont,1] := _cDt
			EndIf
		ElseIf  _cDia == 5 //Quinta
			If Empty(_aSemana[_nCont,1])
				_aSemana[_nCont,1] := _cDt
			EndIf
		ElseIf _cDia == 6 //Sexta
			If Empty(_aSemana[_nCont,1])
				_aSemana[_nCont,1] := _cDt
			EndIf
			_aSemana[_nCont,2] := _cDt
			_aSemana[_nCont,3] :=_nCont
			_nCont++
		EndIf
		If _nI == _nFor
			If !(_cDia == 1 .or. _cDia == 6 .or. _cDia == 7) // 1-Domingo --- 6-Sexta --- 7-Sabado
				_aSemana[_nCont,2] := _cDt
			EndIf
		EndIf
	Next
EndIf

Return(_aSemana)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCPRJR02   บAutor  ณMicrosiga           บ Data ณ  02/08/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fCabecalho()

For _nCabec := 1 to 1
	@ nLin, 01 PSAY _aArray[_nCabec,1,1] //Cod SSI
	@ nLin, 09 PSAY _aArray[_nCabec,2,1] //Descricao SSI

	nCol := 52
	For _nCabecMes := 1 to Len(_aArray[_nCabec,3,1])
		@ nLin, nCol   PSAY "|"
		@ nLin, pcol() PSAY _aArray[_nCabec, 3, 1, _nCabecMes, 1] //Descricao Meses
		nCol+=12
	Next _nCabecMes

	@ nLin, nCol   PSAY "|"
	@ nLin, pcol() PSAY _aArray[_nCabec, 4, 1] //Cod SSI
	nCol+=12
	@ nLin, nCol   PSAY "|"
	@ nLin, pcol() PSAY _aArray[_nCabec, 5, 1] //Cod SSI
	nLin++

Next _nCabec

Return