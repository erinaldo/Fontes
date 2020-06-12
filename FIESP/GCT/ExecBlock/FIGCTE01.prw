#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ FIGCTE01 ³Autor³ TOTVS                   ³ Data ³  Jul/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Ponto de entrada na inclusao do cronograma no momento da    ³±±
±±³          ³passagem para o painel das parcelas com o intuito de alterar³±±
±±³          ³o array aParcela.                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FIESP                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

/*
Estrutura do Array aParcela (PARAMIXB[1])
aExp01[x][1] - Numero da Parcela
aExp01[x][2] - Competencia
aExp01[x][3] - Valor Previsto
aExp01[x][4] - Valor Real
aExp01[x][5] - Saldo
aExp01[x][6] - Vencimento
aExp01[x][7] - Previsao de Medicao
aExp01[x][8] - Data real de Medicao
aExp01[x][9] - Moeda
aExp01[x][10] - False

*/

User Function FIGCTE01(_aParcela)

Local _nDiasP			:= 0
Local _nVlPro, _nVlDif	:= 0
Local _nI 				:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calcula proporcionalidade de dias no mes para primeira e ultima parcelas  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_nDiasP := (30 - Day(CN9->CN9_DTINIC)) + 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calcula valor proporcional das parcelas P=primeira, I=intermediarias, U=Ultima ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_nVlPro	:= round((_aParcela[1,3]/30)*_nDiasP,2)
_nVlDif :=  _aParcela[1,3] - _nVlPro

If _nVlDif > 0
	If _nVlDif < 0.01
		_nVlDif := 0.01
	EndIf
Else
	Return {_aParcela,,,}
EndIf
                      
If val(substr(_aparcela[len(_aparcela),2],1,2))+1 == 13
	_cCompet	:= "01/"+alltrim(str(val(substr(_aparcela[len(_aparcela),2],4,4))+1))
Else
	_cCompet	:= alltrim(strzero(val(substr(_aparcela[len(_aparcela),2],1,2))+1,2))+"/"+substr(_aparcela[len(_aparcela),2],4,4)
EndIf

nHandle := FT_FUSE(__CUSERID+".LOG")
if nHandle = -1

	_aParcela[1,3] := _nVlPro //Valor Previsto da Parcela
	_aParcela[1,5] := _nVlPro //Saldo da Parcela

	aadd(_aParcela,{soma1(_aparcela[len(_aparcela),1]),;
					_cCompet,;
					_nVlDif,;
					0,;
					_nVlDif,;
					CTOD(alltrim(str(Day(CN9->CN9_DTINIC)))+"/"+_cCompet),;
					CTOD(alltrim(str(Day(CN9->CN9_DTINIC)))+"/"+_cCompet),;
					ctod("//"),;
					1,;
					.F.}) 
Else
	FT_FGOTOP()
	xBuffer	:=	FT_FREADLN()
	_nPos 	:= AT(";",xBuffer)
	_cCond	:= Substr(xBuffer,_nPos+1,len(xBuffer))
	FT_FUSE()
	ferase("\system\"+__CUSERID+".LOG")
	
	_aCond := CONDICAO(_nVlDif,_cCond,,CTOD(SUBSTR(DTOC(CN9->CN9_DTINIC),1,2)+"/"+_cCompet))
	
	_cTipo 		:= Posicione("SE4",1,XFILIAL("SE4")+_cCond, "E4_XDIAUTL") //Dia Util
	_cProRat	:= Posicione("SE4",1,XFILIAL("SE4")+_cCond, "E4_XPRORAT") //Pro-Rata Sim ou Nao

	If _cProRat == "1" //Sim
	
		_aParcela[1,3] := _nVlPro //Valor Previsto da Parcela
		_aParcela[1,5] := _nVlPro //Saldo da Parcela
	
		For _nI := 1 to Len(_aCond)
			aadd(_aParcela,{soma1(_aparcela[len(_aparcela),1]),;
							_cCompet,;
							_aCond[_nI,2],;
							0,;
							_aCond[_nI,2],;
							_aCond[_nI,1],;
							_aCond[_nI,1],;
							ctod("//"),;
							1,;
							.F.}) 
		Next _nI
	EndIf

	If _cTipo <> "4"
		For _nI := 1 To Len(_aParcela)
			_aParcela[_nI,6] := u_FICOME01(_aParcela[_nI,6],month(_aParcela[_nI,6]),year(_aParcela[_nI,6]),_cCond)
			_aParcela[_nI,7] := _aParcela[_nI,6]
		Next _nI
	EndIf

endif

Return {_aParcela,,,}