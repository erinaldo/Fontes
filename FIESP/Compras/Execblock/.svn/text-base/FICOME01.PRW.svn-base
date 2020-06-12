
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FICOME01  ºAutor  ³Microsiga           º Data ³  06/28/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Alteracao do vencimento 5 dia util                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FICOME01(dOldVenc,_nMes,_nAno,cCondicao)

//Local aOldVenc := ACLONE(Paramixb[1])
Local _aSemana
Local _dNewVenc := dOldVenc
Local _cTipo 	:= Posicione("SE4",1,XFILIAL("SE4")+cCondicao, "E4_XDIAUTL") //Dia Util

If _cTipo == "4" //Mantem o Padrão da Condicao de Pagamento
	Return(dOldVenc)
EndIf

_dNewVenc := FirstDay(ctod("01/"+alltrim(str(_nMes))+"/"+alltrim(str(_nAno))))

_dDt      := dtoc(_dNewVenc)
_aSemana  := CalcSemana(_dDt)
	
_cData	:= _dDt //ex: 10/06/2013
_cMes	:= substr(_cData,4,2)
_cAno	:= substr(_cData,7,4)
	
_dDtIni	:= FirstDay(ctod("01/"+_cMes+"/"+_cAno))
_dDtFim	:= LastDay(ctod("01/"+_cMes+"/"+_cAno))
	
_nCont	:= 0
For _nY := 0 to Val(substr(dtoc(_dDtFim),1,2))
	If _nCont >= 5
		Exit
	Else
    	If alltrim(str(dow(_dDtIni+_nY))) $ "23456" //Segunda/Terça/Quarta/Quinta/Sexta
   			_nCont++
   			_dDtUtil := _dDtIni+_nY
   		EndIf
	EndIf
Next _nY
	
_dDtUtil  := DataValida(_dDtUtil,.T.) //O parametro .F. e para considerar a data util anterior (se cai no final de semana considera a sexta)
_nPosVcto := ascan(_aSemana,{|x| _dDtUtil >= x[1] .and. _dDtUtil <= x[2] })
	
If _cTipo == "1" //Mantem a Sexta-feira
	_dNewVenc := _aSemana[_nPosVcto,2]
ElseIf _cTipo == "2" //Proxima Sexta-feira
	If dow(_dDtUtil) == 6
		_dNewVenc := _aSemana[_nPosVcto+1,2]
	Else
		_dNewVenc := _aSemana[_nPosVcto,2]
	EndIf
ElseIf _cTipo == "3" //independete do dia da semana.
	_dNewVenc := _dDtUtil
EndIf

Return(_dNewVenc)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTCOLSE2  ºAutor  ³Microsiga           º Data ³  06/11/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CalcSemana(mv_par01)

Local _aMeses
Local _aSemana
Local _cDt
Local _nI 		:= 0

//Funcao abaixo retorna o numero do dia da semana
//1-Domingo
//2-Segunda
//3-Terca
//4-Quarta
//5-Quinta
//6-Sexta
//7-Sabado
//dow(ctod("09/08/2008"))

cMes		:= Val(Substr(mv_par01,4,2))
cAno		:= Val(Substr(mv_par01,7,4))

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
			If !(_cDia == 1 .or. _cDia == 7) // 1-Domingo ---- 7-Sabado
				_aSemana[len(_aSemana),2] := _cDt
			EndIf
		EndIf
	Next
EndIf
Return(_aSemana)