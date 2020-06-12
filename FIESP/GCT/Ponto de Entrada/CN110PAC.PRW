#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CN110PAC ³Autor³ TOTVS                   ³ Data ³  Jul/13  ³±±
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

User Function CN110PAC()

Local _aArea			:= GetArea()
Local _aParcela			:= PARAMIXB[1]	//Parcelas
Local dDtFimInd  		:= GetNewPar("MV_CNVIGCP", CTOD("31/12/2049"))

If Empty(_aParcela) .or. CN1->CN1_CROFIS == "1" // Valida se existe Cronograma Fisico -- Cronograma Físico ? 1= Sim.
	Return
EndIf

// Verifica o numero da Vigencia do Contrato (quando o contrato passa pelo mes de FEVEREIRO (que possue menos de 30 dias) o sistema sempre
//calcula 1 mes menos no NUMERO DE PARCELAS
// as linhas abaixo refazem  numero de parcela quando é Diferente da VIGENCIA
nCompet    := GetNewPar("MV_CNCOMCP", 30)
dFimCondPG := Iif(CN9->CN9_UNVIGE=='4',dDtFimInd,CN9->CN9_DTFIM )
nVgContrato:= int(round((dFimCondPG - ddatabase) / nCompet,0)) // Esta chamado no fonte Padrao não tem a função ROUND()
nVlCompet  := nTotPlan / nVgContrato

If nVgContrato > 0
	If Len(_aParcela) <> nVgContrato
		_aParcela1 	:= {}
		_nNumPar	:= "00"
		_dDtIni		:= strzero(day(CN9->CN9_DTINIC),2)
		_dMesIni	:= strzero(month(CN9->CN9_DTINIC),2)
		_dAnoIni	:= strzero(year(CN9->CN9_DTINIC),4)
		For _nX := 1 to nVgContrato
			aCondComp := {}
			nHandle := FT_FUSE(__CUSERID+".LOG")
			If nHandle >= 1
				FT_FGOTOP()
				xBuffer	:=	FT_FREADLN()
				_nPos 	:= AT(";",xBuffer)
				_cCond	:= Substr(xBuffer,_nPos+1,len(xBuffer))
				FT_FUSE()
			EndIf
			_nNumPar := soma1(_nNumPar)
			_cMesParc := strzero((val(_dMesIni)),2)
			_cAnoParc := _dAnoIni
			If nHandle >= 1
				//If Alltrim(Posicione("SE4", 1, xFilial("SE4") + _cCond, "E4_DDD")) == "F" //Fora o Mes
				//	_cMesParc := strzero((val(_dMesIni)+1),2)
				//Else
				//	_cMesParc := strzero((val(_dMesIni)),2)
				//EndIf
				aCondComp := Condicao(nVlCompet,_cCond,, CTOD(_dDtIni+"/"+_cMesParc+"/"+_cAnoParc))
			Else
				_cMesParc := strzero((val(_dMesIni)+1),2)
			EndIf

			If Val(_cMesParc) > 12
				_cMesParc := "01"
				_cAnoParc := strzero((Val(_dAnoIni)+1),4)
			EndIf
		
			If !Empty(aCondComp)
				aadd(_aParcela1,{_nNumPar,_dMesIni+"/"+_dAnoIni,nVlCompet,0,nVlCompet,;
								 aCondComp[1,1],aCondComp[1,1],CTOD("//"),1,.F.})
			Else
				aadd(_aParcela1,{_nNumPar,_dMesIni+"/"+_dAnoIni,nVlCompet,0,nVlCompet,;
								 CTOD(_dDtIni+"/"+_cMesParc+"/"+_cAnoParc),CTOD(_dDtIni+"/"+_cMesParc+"/"+_cAnoParc),CTOD("//"),1,.F.})
			EndIf
			_dMesIni := strzero(Val(_dMesIni) + 1,2)
			If val(_dMesIni) > 12
				_dMesIni := "01"
				_dAnoIni := strzero(Val(_dAnoIni) + 1,4)
			EndIf
		Next
		_aParcela := _aParcela1
	EndIf
EndIf
	
//Chamada Funcao que faz o tratamento da PRO-Rata alterando a 1 e a ultima parcela conforme data de Inicio do Contrato.
_aParcRet	:= U_FIGCTE01(_aParcela)

RestArea(_aArea)

Return(_aParcRet)