#include "rwmake.ch"
#include "TOPCONN.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFINR024  บAutor  ณEmerson Natali      บ Data ณ  08/08/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑณDescri…o ณ Provisao de Contas de Consumo por Periodo - SZ5            ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ CIEE - Financeiro                                          ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CFINR024

Private Titulo   := ""
Private wnrel    := "CFINR024"
Private cDesc1   := "Este programa tem como objetivo imprimir relatorio "
Private cDesc2   := "de acordo com os parametros informados pelo usuario."
Private cDesc3   := "Relatorio Provisao de Contas de Consumo"
Private cString  := "SZ5"
Private lRet     := .F.
Private nomeprog := "CFINR024"
Private Tamanho  := "G"    
Private Limite   := 220
Private nTipo    := 18
Private m_pag    := 1
Private CbCont   := 0
Private CbTXT    := Space(10)
Private aReturn  := { "Zebrado", 1,"Administracao", 2, 1, 1, "",1 }
Private nLastKey := 0
Private cPerg    := "FINR24"
Private nLin     := 0

Titulo   := "Relatorio Provisao de Contas de Consumo"

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

_aMatriz := {}
aadd(_aMatriz,{"","",0,0,0,0,0,0,0,0,0,0,0,0,0,0,""})

/*
_cMeses :=_Mes[1,2]+"          "+_Mes[2,2]+"          "+_Mes[3,2]+"          "+_Mes[4,2]+"          "+_Mes[5,2]+"          "+_Mes[6,2]+"          "+_Mes[7,2]+"          "+_Mes[8,2]+"          "+_Mes[9,2]+"          "+_Mes[10,2]+"          "+_Mes[11,2]+"          "+_Mes[12,2]
cabec1  := "Unidades " + _cMeses + "Total          Media"
*/

cabec2  := ""

_xFilSZ5:=xFilial("SZ5")
_xFilSZ7:=xFilial("SZ7")

cQuery := " SELECT *"
cQuery += " FROM "
cQuery += RetSqlName("SZ5")+" SZ5,"
cQuery += RetSqlName("SZ7")+" SZ7"
cQuery += " WHERE '"+ _xFilSZ5 +"' = Z5_FILIAL"
cQuery += " AND   '"+ _xFilSZ7 +"' = Z7_FILIAL"   
cQuery += " AND    SZ5.D_E_L_E_T_ <> '*'"
cQuery += " AND    SZ7.D_E_L_E_T_ <> '*'"
cQuery += " AND    Z5_PRESTA   = Z7_PRESTA"
cQuery += " AND    Z5_LANC BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'"
cQuery += " AND    Z7_GRUPO BETWEEN '"+mv_par03+"'  AND '"+mv_par04+"' "
cQuery += " AND    Z5_PRESTA BETWEEN '"+mv_par05+"'  AND '"+mv_par06+"' "
cQuery += " AND    Z5_UNIDADE BETWEEN '"+mv_par07+"'  AND '"+mv_par08+"' "
cQuery += " ORDER BY Z7_DESCGR, Z5_CR, Z5_UNIDADE, Z5_LANC"

TCQUERY cQuery NEW ALIAS "TEMP"

TcSetField("TEMP","Z5_LANC","D",8, 0 )		

dbSelectArea("TEMP")
dbGoTop()

_cUnidade := TEMP->Z5_UNIDADE
_cGrupo   := TEMP->Z7_DESCGR
_nLin	  := Len(_aMatriz)
_nTotal   := 0
_nMedia	  := (Month(mv_par02)-Month(mv_par01))+1

Do While !Eof()

	If TEMP->Z5_UNIDADE <> _cUnidade
		_aMatriz[_nLin,15]	:= _nTotal
		_aMatriz[_nLin,16]	:= _nTotal / _nMedia
		aadd(_aMatriz,{"","",0,0,0,0,0,0,0,0,0,0,0,0,0,0,""})
		_nLin     := Len(_aMatriz)
		_nTotal   := 0
		_cUnidade := TEMP->Z5_UNIDADE
	EndIf

	_nMes := Month(TEMP->Z5_LANC)
	_nPos := aScan(_Mes, {|x| x[1] == _nMes})
	_aMatriz[_nLin,1] 		:= TEMP->Z5_CR
	_aMatriz[_nLin,2] 		:= TEMP->Z5_UNIDADE
	_aMatriz[_nLin,_nPos+2]	:= _aMatriz[_nLin,_nPos+2] + TEMP->Z5_VALOR
	_aMatriz[_nLin,17] 		:= TEMP->Z7_DESCGR
	_nTotal  :=	_nTotal + TEMP->Z5_VALOR
	TEMP->(DbSkip())

EndDo

//Atualiza a Media da ultima linha da Matriz
_aMatriz[_nLin,15]	:= _nTotal
_aMatriz[_nLin,16]	:= _nTotal / _nMedia

_nMes1 := Month(mv_par01)
_nMes2 := Month(mv_par02)
_nPos1 := aScan(_Mes, {|x| x[1] == _nMes1})
_nPos2 := aScan(_Mes, {|x| x[1] == _nMes2})

//cabec1 := "CR  Unidades               Janeiro  Fevereiro      Marco      Abril       Maio      Junho      Julho     Agosto   Setembro    Outubro   Novembro   Dezembro        Total      Media"
cabec1 := " CR  Unidades                  Janeiro    Fevereiro        Marco        Abril         Maio        Junho        Julho       Agosto     Setembro      Outubro     Novembro     Dezembro          Total        Media"

Do Case
	Case cEmpant == '01'
		Titulo   := "Provisao de Contas de Consumo - "+alltrim(_cGrupo)+" - Periodo de "+_Mes[_nPos1,2]+" a "+_Mes[_nPos2,2]+" de " +alltrim(str(Year(mv_par02)))+" - CIEE / SP"
	Case cEmpant == '03'
		Titulo   := "Provisao de Contas de Consumo - "+alltrim(_cGrupo)+" - Periodo de "+_Mes[_nPos1,2]+" a "+_Mes[_nPos2,2]+" de " +alltrim(str(Year(mv_par02)))+" - CIEE / RJ"
	Case cEmpant == '05'
		Titulo   := "Provisao de Contas de Consumo - "+alltrim(_cGrupo)+" - Periodo de "+_Mes[_nPos1,2]+" a "+_Mes[_nPos2,2]+" de " +alltrim(str(Year(mv_par02)))+" - CIEE / NACIONAL"
EndCase

//Titulo   := "Relatorio Provisao de Contas de Consumo - "+alltrim(_cGrupo)+" - Periodo de "+_Mes[_nPos1,2]+" a "+_Mes[_nPos2,2]+" de " +alltrim(str(Year(mv_par02)))+" - CIEE / SP"

Cabec (titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
nLin      := 08
_nTotMes1 := 0 
_nTotMes2 := 0 
_nTotMes3 := 0 
_nTotMes4 := 0 
_nTotMes5 := 0 
_nTotMes6 := 0 
_nTotMes7 := 0 
_nTotMes8 := 0 
_nTotMes9 := 0 
_nTotMes10:= 0 
_nTotMes11:= 0 
_nTotMes12:= 0 
_nTotGer  := 0 
_nMedGer  := 0 

For _nI := 1 to len(_aMatriz)
	If nLin > 58
		Cabec (titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		nLin  := 08
	EndIf
	
	If _aMatriz[_nI,17] <> _cGrupo
		nLin++
		@ nLin,000 PSAY __PrtThinLine()
		nLin++
		@ nLin, 005 Psay "TOTAL GERAL"
		@ nLin, 028 Psay _nTotMes1 picture "@E 999,999.99"
		@ nLin, 041 Psay _nTotMes2 picture "@E 999,999.99"
		@ nLin, 054 Psay _nTotMes3 picture "@E 999,999.99"
		@ nLin, 067 Psay _nTotMes4 picture "@E 999,999.99"
		@ nLin, 080 Psay _nTotMes5 picture "@E 999,999.99"
		@ nLin, 093 Psay _nTotMes6 picture "@E 999,999.99"
		@ nLin, 106 Psay _nTotMes7 picture "@E 999,999.99"
		@ nLin, 119 Psay _nTotMes8 picture "@E 999,999.99"
		@ nLin, 132 Psay _nTotMes9 picture "@E 999,999.99"
		@ nLin, 145 Psay _nTotMes10 picture "@E 999,999.99"
		@ nLin, 158 Psay _nTotMes11 picture "@E 999,999.99"
		@ nLin, 171 Psay _nTotMes12 picture "@E 999,999.99"
		@ nLin, 184 Psay _nTotGer picture "@E 9,999,999.99"
		@ nLin, 199 Psay _nMedGer picture "@E 999,999.99"
		_cGrupo := _aMatriz[_nI,17]
		nLin    := 08
		_nTotMes1 := 0 
		_nTotMes2 := 0 
		_nTotMes3 := 0 
		_nTotMes4 := 0 
		_nTotMes5 := 0 
		_nTotMes6 := 0 
		_nTotMes7 := 0 
		_nTotMes8 := 0 
		_nTotMes9 := 0 
		_nTotMes10:= 0 
		_nTotMes11:= 0 
		_nTotMes12:= 0 
		_nTotGer := 0 
		_nMedGer := 0 
		Titulo  := "Relatorio Provisao de Contas de Consumo - "+alltrim(_cGrupo)+	" - Periodo de "+_Mes[_nPos1,2]+" a "+_Mes[_nPos2,2]+" de " +alltrim(str(Year(mv_par02)))
		Cabec (titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIf
/*        1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
 CR  Unidades                  Janeiro    Fevereiro        Marco        Abril         Maio        Junho        Julho       Agosto     Setembro      Outubro     Novembro     Dezembro          Total        Media
 xxx xxxxxxxxxxxxxxxxxxxxx  999,999.99   999,999.99   999,999.99   999,999.99   999,999.99   999,999.99   999,999.99   999,999.99   999,999.99   999,999.99   999,999.99   999,999.99   9,999,999.99   999,999.99
*/
	@ nLin, 001 Psay _aMatriz[_nI,1]
	@ nLin, 005 Psay substr(_aMatriz[_nI,2],1,21)
	@ nLin, 028 Psay _aMatriz[_nI,3] picture "@E 999,999.99"
	@ nLin, 041 Psay _aMatriz[_nI,4] picture "@E 999,999.99"
	@ nLin, 054 Psay _aMatriz[_nI,5] picture "@E 999,999.99"
	@ nLin, 067 Psay _aMatriz[_nI,6] picture "@E 999,999.99"
	@ nLin, 080 Psay _aMatriz[_nI,7] picture "@E 999,999.99"
	@ nLin, 093 Psay _aMatriz[_nI,8] picture "@E 999,999.99"
	@ nLin, 106 Psay _aMatriz[_nI,9] picture "@E 999,999.99"
	@ nLin, 119 Psay _aMatriz[_nI,10] picture "@E 999,999.99"
	@ nLin, 132 Psay _aMatriz[_nI,11] picture "@E 999,999.99"
	@ nLin, 145 Psay _aMatriz[_nI,12] picture "@E 999,999.99"
	@ nLin, 158 Psay _aMatriz[_nI,13] picture "@E 999,999.99"
	@ nLin, 171 Psay _aMatriz[_nI,14] picture "@E 999,999.99"
	@ nLin, 184 Psay _aMatriz[_nI,15] picture "@E 9,999,999.99"
	@ nLin, 199 Psay _aMatriz[_nI,16] picture "@E 999,999.99"
	_nTotMes1 := _nTotMes1 + _aMatriz[_nI,3]
	_nTotMes2 := _nTotMes2 + _aMatriz[_nI,4]
	_nTotMes3 := _nTotMes3 + _aMatriz[_nI,5]
	_nTotMes4 := _nTotMes4 + _aMatriz[_nI,6]
	_nTotMes5 := _nTotMes5 + _aMatriz[_nI,7]
	_nTotMes6 := _nTotMes6 + _aMatriz[_nI,8]
	_nTotMes7 := _nTotMes7 + _aMatriz[_nI,9]
	_nTotMes8 := _nTotMes8 + _aMatriz[_nI,10]
	_nTotMes9 := _nTotMes9 + _aMatriz[_nI,11]
	_nTotMes10:= _nTotMes10 + _aMatriz[_nI,12]
	_nTotMes11:= _nTotMes11 + _aMatriz[_nI,13]
	_nTotMes12:= _nTotMes12 + _aMatriz[_nI,14]
	_nTotGer  := _nTotGer + _aMatriz[_nI,15]
	_nMedGer  := _nMedGer + _aMatriz[_nI,16]
	nLin++
Next

nLin++
@ nLin,000 PSAY __PrtThinLine()
nLin++
@ nLin, 005 Psay "TOTAL GERAL"
@ nLin, 028 Psay _nTotMes1 picture "@E 999,999.99"
@ nLin, 041 Psay _nTotMes2 picture "@E 999,999.99"
@ nLin, 054 Psay _nTotMes3 picture "@E 999,999.99"
@ nLin, 067 Psay _nTotMes4 picture "@E 999,999.99"
@ nLin, 080 Psay _nTotMes5 picture "@E 999,999.99"
@ nLin, 093 Psay _nTotMes6 picture "@E 999,999.99"
@ nLin, 106 Psay _nTotMes7 picture "@E 999,999.99"
@ nLin, 119 Psay _nTotMes8 picture "@E 999,999.99"
@ nLin, 132 Psay _nTotMes9 picture "@E 999,999.99"
@ nLin, 145 Psay _nTotMes10 picture "@E 999,999.99"
@ nLin, 158 Psay _nTotMes11 picture "@E 999,999.99"
@ nLin, 171 Psay _nTotMes12 picture "@E 999,999.99"
@ nLin, 184 Psay _nTotGer picture "@E 9,999,999.99"
@ nLin, 199 Psay _nMedGer picture "@E 999,999.99"

DbSelectArea("TEMP")
DbCloseArea()

Return

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

cPerg := Left(cPerg,6)

/*
     grupo ,ordem  ,pergunt                    ,perg spa,perg eng , variav ,tipo,tam,dec ,pres,gsc,valid ,var01     ,def01,defspa01,defeng01,cnt01,var02,def02,defspa02,defeng02,cnt02,var03,def03,defspa03,defeng03,cnt03,var04,def04,defspa04,defeng04,cnt04,var05,def05,defspa05,defeng05,cnt05,f3   ,"","","",""
*/
aAdd(aRegs,{cPerg  ,"01" ,"Data Lancto de ?  ","      ","       ","mv_ch1","D" ,08 ,00 ,0    ,"G",""   ,"mv_par01",""   ,""      ,""      ,""   ,""   ,""  ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,"","","",""})
aAdd(aRegs,{cPerg  ,"02" ,"Data Lancto ate?  ","      ","       ","mv_ch2","D" ,08 ,00 ,0    ,"G",""   ,"mv_par02",""   ,""      ,""      ,""   ,""   ,""  ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,"","","",""})
aAdd(aRegs,{cPerg  ,"03" ,"Grupo de       ?  ","      ","       ","mv_ch3","C" ,03 ,00 ,0    ,"G",""   ,"mv_par03",""   ,""      ,""      ,""   ,""   ,""  ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,"BZV","","","",""})
aAdd(aRegs,{cPerg  ,"04" ,"Grupo ate      ?  ","      ","       ","mv_ch4","C" ,03 ,00 ,0    ,"G",""   ,"mv_par04",""   ,""      ,""      ,""   ,""   ,""  ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,"BZV","","","",""})
aAdd(aRegs,{cPerg  ,"05" ,"Prestadora de  ?  ","      ","       ","mv_ch5","C" ,15 ,00 ,0    ,"G",""   ,"mv_par05",""   ,""      ,""      ,""   ,""   ,""  ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,"BZ7","","","",""})
aAdd(aRegs,{cPerg  ,"06" ,"Prestadora ate ?  ","      ","       ","mv_ch6","C" ,15 ,00 ,0    ,"G",""   ,"mv_par06",""   ,""      ,""      ,""   ,""   ,""  ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,"BZ7","","","",""})
aAdd(aRegs,{cPerg  ,"07" ,"Unidade de     ?  ","      ","       ","mv_ch7","C" ,25 ,00 ,0    ,"G",""   ,"mv_par07",""   ,""      ,""      ,""   ,""   ,""  ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,"BZU","","","",""})
aAdd(aRegs,{cPerg  ,"08" ,"Unidade ate    ?  ","      ","       ","mv_ch8","C" ,25 ,00 ,0    ,"G",""   ,"mv_par08",""   ,""      ,""      ,""   ,""   ,""  ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,""   ,""   ,""      ,""      ,""   ,""   ,""   ,""      ,""     ,""   ,"BZU","","","",""})

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