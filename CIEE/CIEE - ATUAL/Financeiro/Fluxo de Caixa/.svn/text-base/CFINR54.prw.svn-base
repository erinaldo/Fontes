#include "rwmake.ch"
#include "TOPCONN.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFINR54   ºAutor  ³Emerson Natali      º Data ³  22/08/2008 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio Fluxo Detalhado Acumulado Crystal                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CFINR54(_nOpc)

Private _aSemana
Private cParams		:= ""
Private cOpcoes		:= "1;0;1;Fluxo de Caixa"
Private _nxOpc 		:= _nOpc

Private	_nOrcVal03	:= 0
Private	_nOrcVal04	:= 0

If _nxOpc == 5
	Private cPerg := "CFIN56    "
Else
	Private cPerg := "CFIN55    "
EndIf

_fCriaSX1()

If pergunte(cPerg,.T.)

	IF File("FLXACM.DBF")
		dbUseArea (.T.,,"FLXACM","FLX",NIL,.F.)
		FLX->(DbCloseArea())
		FERASE("FLXACM"+GetDBExtension())
		Ferase("FLXACM"+OrdBagExt())
	EndIf

	IF File("ORCACM.DBF")
		dbUseArea (.T.,,"ORCACM","ORC",NIL,.F.)
		ORC->(DbCloseArea())
		FERASE("ORCACM"+GetDBExtension())
		Ferase("ORCACM"+OrdBagExt())
	EndIf

	Processa({|| _fExec() },"Processando...")
Else
	Return
EndIf

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFINR53   ºAutor  ³Microsiga           º Data ³  08/18/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function _fExec()

//_aSemana := CalcSemana(mv_par01)

/*
----------------------------------------------------------------------------------
Cria arquivo Temporario FLXACM para montar os itens do relatorio Crystal (valores)
----------------------------------------------------------------------------------
*/
aCampUser := {	{"FLX_NATU" 	, "C", 10, 0, OemToAnsi("Natureza" 		)},;
				{"FLX_DESC" 	, "C", 40, 0, OemToAnsi("Descrição"		)},;
				{"FLX_SUP"  	, "C", 10, 0, OemToAnsi("Nat. Sup" 		)},;
				{"FLX_GRP"  	, "C", 10, 0, OemToAnsi("Grp. Nat" 		)},;
				{"FLX_SUPORC"	, "C", 10, 0, OemToAnsi("Nat Sup Orc"	)},;
				{"FLX_DESORC"	, "C", 40, 0, OemToAnsi("Desc Sup Orc"	)},;
				{"FLX_VL01"  	, "N", 14, 2, OemToAnsi("Valor01" 		)},;
				{"FLX_VL02"  	, "N", 14, 2, OemToAnsi("Valor02" 		)},;
				{"FLX_VL03"  	, "N", 14, 2, OemToAnsi("Valor03" 		)},;
				{"FLX_VL04"  	, "N", 14, 2, OemToAnsi("Valor04" 		)},;
				{"FLX_VL05"  	, "N", 14, 2, OemToAnsi("Valor05" 		)},;
				{"FLX_VL06"  	, "N", 14, 2, OemToAnsi("Valor06" 		)},;
				{"FLX_VL07"  	, "N", 14, 2, OemToAnsi("Valor07" 		)},;
				{"FLX_VL08"  	, "N", 14, 2, OemToAnsi("Valor08" 		)},;
				{"FLX_VL09"  	, "N", 14, 2, OemToAnsi("Valor09" 		)},;
				{"FLX_VL10"  	, "N", 14, 2, OemToAnsi("Valor10"		)},;
				{"FLX_VL11"  	, "N", 14, 2, OemToAnsi("Valor11"		)},;
				{"FLX_VL12"  	, "N", 14, 2, OemToAnsi("Valor12"		)},;
				{"FLX_ANO"      , "C", 07, 0, OemToAnsi("Ano"  			)}}

dbCreate("FLXACM",aCampUser) // Fluxo Detalhado
dbUseArea (.T.,,"FLXACM","FLX",NIL,.F.)
IndRegua("FLX","FLXACM","FLX_NATU",,,OemToAnsi("Selecionando Registros..."), .T.)

aCampUser := {	{"ORC_NATU"  , "C", 10, 0, OemToAnsi("Natureza"			)},;
				{"ORC_DESC"  , "C", 40, 0, OemToAnsi("Descição"			)},;
				{"ORC_SUP"   , "C", 10, 0, OemToAnsi("Nat. Sup"			)},;
				{"ORC_GRP"   , "C", 10, 0, OemToAnsi("Grp. Nat"			)},;
				{"ORC_VL01"  , "N", 14, 2, OemToAnsi("Valor Orcado" 	)},;
				{"ORC_VL02"  , "N", 14, 2, OemToAnsi("Valor Realizado" 	)},;
				{"ORC_VL03"  , "N", 14, 2, OemToAnsi("Valor Orc Acm" 	)},;
				{"ORC_VL04"  , "N", 14, 2, OemToAnsi("Valor Real Acm"	)},;
				{"ORC_DT"    , "D", 08, 0, OemToAnsi("Data" 			)},;
				{"ORC_SUPORC", "C", 10, 0, OemToAnsi("Nat Sup Orc"		)}}

dbCreate("ORCACM",aCampUser) // Fluxo Detalhado
dbUseArea (.T.,,"ORCACM","ORC",NIL,.F.)
IndRegua("ORC","ORCACM","ORC_SUPORC",,,OemToAnsi("Selecionando Registros..."), .T.)

If _nxOpc == 5
	DbSelectArea("SE7")
	DbSetOrder(1)
	DbGotop()
	ProcRegua(RecCount())

	cMes 	:= Substr(mv_par01,1,2)
	cAno 	:= Substr(mv_par01,6,2)
	_nValAcm := 0
	_nVal01	:= 0
	_nVal02	:= 0
	_nVal03	:= 0
	_nVal04	:= 0
	_nVal05	:= 0
	_nVal06	:= 0
	_nVal07	:= 0
	_nVal08	:= 0
	_nVal09	:= 0
	_nVal10	:= 0
	_nVal11	:= 0
	_nVal12	:= 0

	Do While !EOF()
		IncProc("Gravando registros Orçamento...")
		DbSelectArea("ORC")

		_nVal01 := SE7->E7_VALJAN1
		_nVal02 := SE7->E7_VALFEV1
		_nVal03 := SE7->E7_VALMAR1
		_nVal04 := SE7->E7_VALABR1
		_nVal05 := SE7->E7_VALMAI1
		_nVal06 := SE7->E7_VALJUN1
		_nVal07 := SE7->E7_VALJUL1
		_nVal08 := SE7->E7_VALAGO1
		_nVal09 := SE7->E7_VALSET1
		_nVal10 := SE7->E7_VALOUT1
		_nVal11 := SE7->E7_VALNOV1
		_nVal12 := SE7->E7_VALDEZ1

		DbSelectArea("SED")
		DbSetOrder(1)
		If DbSeek(xFilial("SED")+SE7->E7_NATUREZ)
    	   	_cNatSup 	:= SED->ED_SUP
	       	_cNatSupOrc	:= SED->ED_SUPORC
	       	_cTpMov		:= SED->ED_TPMOV
		Else
	       	_cNatSup 	:= ""
	       	_cNatSupOrc	:= ""
	       	_cTpMov		:= ""
		EndIf

		If SED->ED_XFLUXO == "N"
			DbSelectArea("SE7")
			SE7->(DbSkip())
			Loop
		EndIf

		For _nI := Val(cMes) to 1 step -1
			_nVal	 := "_nVal"+strzero(_nI,2)
			_nValAcm += &_nVal
		Next

		_nVal	:= "_nVal"+cMes 
		
		If alltrim(SE7->E7_NATUREZ) == "0.00"
			_nValAcm := &("_nVal"+cMes)
		EndIf
		
		DbSelectArea("ORC")
		If DbSeek(_cNatSupOrc)
			RecLock("ORC",.F.)
			ORC->ORC_VL01	+= IIF(_cTpMov == "P",&_nVal,&_nVal*-1)
			ORC->ORC_VL03	+= IIF(_cTpMov == "P",_nValAcm,_nValAcm*-1)
			MsUnLock()
		Else
			RecLock("ORC",.T.)
			ORC->ORC_NATU 	:= IIF(alltrim(SE7->E7_NATUREZ)=="6.10",SED->ED_SUPORC,SE7->E7_NATUREZ)
			ORC->ORC_DESC	:= SED->ED_DESORC
			ORC->ORC_SUP 	:= _cNatSup
			ORC->ORC_SUPORC	:= _cNatSupOrc
			ORC->ORC_GRP 	:= SUBSTR(SE7->E7_NATUREZ,1,1)
			ORC->ORC_VL01	:= IIF(_cTpMov == "P",&_nVal,&_nVal*-1)
			ORC->ORC_VL03	:= IIF(_cTpMov == "P",_nValAcm,_nValAcm*-1)
			ORC->ORC_DT		:= ctod("01/"+cMes+"/"+cAno+"")
			MsUnLock()
		EndIf

		If Substr(_cNatSupOrc,1,4) == "5.01"
			_nOrcVal03	+= IIF(_cTpMov == "P",_nValAcm,_nValAcm*-1)
//			_nOrcVal04	+= IIF(_cTpMov == "P",_nValAcm,_nValAcm*-1)
		EndIf

		_nValAcm := 0
		DbSelectArea("SE7")
		SE7->(DbSkip())
	EndDo
EndIf

DbSelectArea("SED")
DbSetOrder(1)
DbGotop()
ProcRegua(RecCount())

Do While !EOF()
	IncProc("Gravando registros Naturezas...")
	If SED->ED_CLASSE == "1" //Se for analitica nao traz
		DbSelectArea("SED")
		SED->(DbSkip())
		Loop
	EndIf

	If SED->ED_XFLUXO == "N"
		dbSelectArea("SED")
		SED->(DbSkip())
		Loop
	EndIf

	RecLock("FLX",.T.)
	FLX->FLX_NATU 	:= IIF(alltrim(SED->ED_CODIGO)=="6.10",SED->ED_SUPORC,SED->ED_CODIGO) 
	FLX->FLX_DESC 	:= SED->ED_DESCRIC
	FLX->FLX_SUP 	:= SED->ED_SUP
	Do Case
		Case Substr(SED->ED_CODIGO,1,4) == "6.10"
			_xFLX_GRP	:= Substr(SED->ED_SUPORC,1,1)
		Case Substr(SED->ED_CODIGO,1,4) == "6.11"
			_xFLX_GRP	:= Substr(SED->ED_SUPORC,1,1)
		OtherWise
			_xFLX_GRP	:= Substr(SED->ED_CODIGO,1,1)
	EndCase
	FLX->FLX_GRP	:= _xFLX_GRP
	FLX->FLX_SUPORC	:= SED->ED_SUPORC
	FLX->FLX_DESORC	:= SED->ED_DESORC
	FLX->FLX_ANO	:= mv_par01
	MsUnLock()
	DbSelectArea("SED")
	SED->(DbSkip())
EndDo

DbSelectArea("SZZ")
DbSetOrder(2) //FILIAL+DATA+NATUREZ
ProcRegua(RecCount())

_aSaldos	:= {}

If _nxOpc == 5
	cAno := Substr(mv_par01,4,4)
Else
	cAno := mv_par01
EndIf

_cQuery := "SELECT ZZ_NATUREZ, ZZ_DESCNAT, SUM(ZZ_VALOR) AS ZZ_VALOR, MONTH(ZZ_DATA) AS MES, YEAR(ZZ_DATA) AS ANO, ED_SUP, ED_TPMOV, ED_SUPORC, ED_DESORC,ED_XFLUXO, ED_DESCRIC "
_cQuery	+= "FROM "+RetSqlName("SZZ")+" SZZ, "+RetSqlName("SED")+" SED "
_cQuery += "WHERE SZZ.D_E_L_E_T_ = '' AND SED.D_E_L_E_T_ = '' "
_cQuery	+= "AND ZZ_DATA BETWEEN '' AND 'ZZZZZZZZZZ' "
_cQuery	+= "AND ZZ_DEL = '' "
_cQuery	+= "AND ZZ_NATUREZ = ED_CODIGO "
_cQuery	+= "AND YEAR(ZZ_DATA) = "+cAno+" "
_cQuery	+= "GROUP BY ZZ_NATUREZ, ZZ_DESCNAT, MONTH(ZZ_DATA), YEAR(ZZ_DATA),ED_SUP, ED_TPMOV, ED_SUPORC, ED_DESORC, ED_XFLUXO, ED_DESCRIC "
_cQuery	+= "ORDER BY ZZ_NATUREZ, ZZ_DESCNAT, MONTH(ZZ_DATA), YEAR(ZZ_DATA)"
TCQUERY _cQuery ALIAS "TMPSLD" NEW

dbSelectArea("TMPSLD")

Do While !EOF()
	IncProc("Gravando registros...")

	If TMPSLD->ED_XFLUXO == "N"
		dbSelectArea("TMPSLD")
		TMPSLD->(DbSkip())
		Loop
	EndIf

	_nI := Strzero(TMPSLD->MES,2)
	_cCampo	:= "FLX->FLX_VL"+_nI

	DbSelectArea("FLX")
	If DbSeek(TMPSLD->ZZ_NATUREZ)
		RecLock("FLX",.F.)
		&_cCampo	 	+= IIF(TMPSLD->ED_TPMOV == "P",TMPSLD->ZZ_VALOR,TMPSLD->ZZ_VALOR*-1)
		MsUnLock()
	Else
		RecLock("FLX",.T.)
		FLX->FLX_NATU 	:= IIF(alltrim(TMPSLD->ZZ_NATUREZ)=="6.10",TMP->ED_SUPORC,TMPSLD->ZZ_NATUREZ) 
		FLX->FLX_DESC 	:= TMPSLD->ED_DESCRIC //TMPSLD->ZZ_DESCNAT
		FLX->FLX_SUP 	:= TMPSLD->ED_SUP
		Do Case
			Case Substr(TMPSLD->ZZ_NATUREZ,1,4) == "6.10"
				_xFLX_GRP	:= Substr(TMPSLD->ED_SUPORC,1,1)
			Case Substr(TMPSLD->ZZ_NATUREZ,1,4) == "6.11"
				_xFLX_GRP	:= Substr(TMPSLD->ED_SUPORC,1,1)
			OtherWise
				_xFLX_GRP	:= Substr(TMPSLD->ZZ_NATUREZ,1,1)
		EndCase
		FLX->FLX_GRP	:= _xFLX_GRP
		FLX->FLX_SUPORC	:= TMPSLD->ED_SUPORC
		FLX->FLX_DESORC	:= TMPSLD->ED_DESORC
		&_cCampo 		:= IIF(TMPSLD->ED_TPMOV == "P",TMPSLD->ZZ_VALOR,TMPSLD->ZZ_VALOR*-1)
		FLX->FLX_ANO	:= mv_par01
		MsUnLock()
	EndIf
	
	Do Case
		Case Substr(TMPSLD->ZZ_NATUREZ,1,4) == "6.10"
			_xFLX_SUPORC	:= "1"
		Case Substr(TMPSLD->ZZ_NATUREZ,1,4) == "6.11"
			_xFLX_SUPORC	:= "2"
		OtherWise
			_xFLX_SUPORC	:= Substr(TMPSLD->ZZ_NATUREZ,1,1)
	EndCase

	_nPos := ascan(_aSaldos,{|x| x[1] == _xFLX_SUPORC+".X"})
	If _nPos > 0
		_aSaldos[_nPos,05] += IIF(_nI=="01",IIF(TMPSLD->ED_TPMOV == "P",TMPSLD->ZZ_VALOR,TMPSLD->ZZ_VALOR*-1),0)	//Janeiro
		_aSaldos[_nPos,06] += IIF(_nI=="02",IIF(TMPSLD->ED_TPMOV == "P",TMPSLD->ZZ_VALOR,TMPSLD->ZZ_VALOR*-1),0)	//Fevereiro
		_aSaldos[_nPos,07] += IIF(_nI=="03",IIF(TMPSLD->ED_TPMOV == "P",TMPSLD->ZZ_VALOR,TMPSLD->ZZ_VALOR*-1),0)	//Marco
		_aSaldos[_nPos,08] += IIF(_nI=="04",IIF(TMPSLD->ED_TPMOV == "P",TMPSLD->ZZ_VALOR,TMPSLD->ZZ_VALOR*-1),0)	//Abril
		_aSaldos[_nPos,09] += IIf(_nI=="05",IIF(TMPSLD->ED_TPMOV == "P",TMPSLD->ZZ_VALOR,TMPSLD->ZZ_VALOR*-1),0)	//Maio
		_aSaldos[_nPos,10] += IIf(_nI=="06",IIF(TMPSLD->ED_TPMOV == "P",TMPSLD->ZZ_VALOR,TMPSLD->ZZ_VALOR*-1),0)	//Junho
		_aSaldos[_nPos,11] += IIf(_nI=="07",IIF(TMPSLD->ED_TPMOV == "P",TMPSLD->ZZ_VALOR,TMPSLD->ZZ_VALOR*-1),0)	//Julho
		_aSaldos[_nPos,12] += IIf(_nI=="08",IIF(TMPSLD->ED_TPMOV == "P",TMPSLD->ZZ_VALOR,TMPSLD->ZZ_VALOR*-1),0)	//Agosto
		_aSaldos[_nPos,13] += IIf(_nI=="09",IIF(TMPSLD->ED_TPMOV == "P",TMPSLD->ZZ_VALOR,TMPSLD->ZZ_VALOR*-1),0)	//Setembro
		_aSaldos[_nPos,14] += IIf(_nI=="10",IIF(TMPSLD->ED_TPMOV == "P",TMPSLD->ZZ_VALOR,TMPSLD->ZZ_VALOR*-1),0)	//Outubro
		_aSaldos[_nPos,15] += IIf(_nI=="11",IIF(TMPSLD->ED_TPMOV == "P",TMPSLD->ZZ_VALOR,TMPSLD->ZZ_VALOR*-1),0)	//Novembro
		_aSaldos[_nPos,16] += IIf(_nI=="12",IIF(TMPSLD->ED_TPMOV == "P",TMPSLD->ZZ_VALOR,TMPSLD->ZZ_VALOR*-1),0)	//Dezembro
	Else
		AADD( _aSaldos, { 	_xFLX_SUPORC+".X"										,;				//Natureza
							"TOTAL "+_xFLX_SUPORC+".X"							,;				//Descricao Natureza
							_xFLX_SUPORC+".X"										,;				//Natureza Superior
							STR(VAL(SUBSTR(TMPSLD->ZZ_NATUREZ,1,1))+1,1)							,;				//Grupo Natureza
							IIF(_nI=="01",IIF(TMPSLD->ED_TPMOV == "P",TMPSLD->ZZ_VALOR,TMPSLD->ZZ_VALOR*-1),0),; //Janeiro
							IIF(_nI=="02",IIF(TMPSLD->ED_TPMOV == "P",TMPSLD->ZZ_VALOR,TMPSLD->ZZ_VALOR*-1),0),; //Fevereiro
							IIF(_nI=="03",IIF(TMPSLD->ED_TPMOV == "P",TMPSLD->ZZ_VALOR,TMPSLD->ZZ_VALOR*-1),0),; //Marco
							IIF(_nI=="04",IIF(TMPSLD->ED_TPMOV == "P",TMPSLD->ZZ_VALOR,TMPSLD->ZZ_VALOR*-1),0),; //Abril
							IIF(_nI=="05",IIF(TMPSLD->ED_TPMOV == "P",TMPSLD->ZZ_VALOR,TMPSLD->ZZ_VALOR*-1),0),; //Maio
							IIF(_nI=="06",IIF(TMPSLD->ED_TPMOV == "P",TMPSLD->ZZ_VALOR,TMPSLD->ZZ_VALOR*-1),0),; //Junho
							IIF(_nI=="07",IIF(TMPSLD->ED_TPMOV == "P",TMPSLD->ZZ_VALOR,TMPSLD->ZZ_VALOR*-1),0),; //Julho
							IIF(_nI=="08",IIF(TMPSLD->ED_TPMOV == "P",TMPSLD->ZZ_VALOR,TMPSLD->ZZ_VALOR*-1),0),; //Agosto
							IIF(_nI=="09",IIF(TMPSLD->ED_TPMOV == "P",TMPSLD->ZZ_VALOR,TMPSLD->ZZ_VALOR*-1),0),; //Setembro
							IIF(_nI=="10",IIF(TMPSLD->ED_TPMOV == "P",TMPSLD->ZZ_VALOR,TMPSLD->ZZ_VALOR*-1),0),; //Outubro
							IIF(_nI=="11",IIF(TMPSLD->ED_TPMOV == "P",TMPSLD->ZZ_VALOR,TMPSLD->ZZ_VALOR*-1),0),; //Novembro
							IIF(_nI=="12",IIF(TMPSLD->ED_TPMOV == "P",TMPSLD->ZZ_VALOR,TMPSLD->ZZ_VALOR*-1),0)}) //Dezembro
	EndIf
	dbSelectArea("TMPSLD")
	TMPSLD->(DbSkip())
EndDo

TMPSLD->(dbCloseArea())

If !Empty(_aSaldos)
	_nSalAnt	:= ascan(_aSaldos,{|x| x[1] == "0.X"})
	_n1X		:= ascan(_aSaldos,{|x| x[1] == "1.X"})
	_n2X		:= ascan(_aSaldos,{|x| x[1] == "2.X"})
	_n3X		:= ascan(_aSaldos,{|x| x[1] == "3.X"})
	_n4X		:= ascan(_aSaldos,{|x| x[1] == "4.X"})
	_n5X		:= ascan(_aSaldos,{|x| x[1] == "5.X"})
	If _n1X == 0
		AADD(_aSaldos,{"1.X","TOTAL 1.X","1.X","1.X",0,0,0,0,0,0,0,0,0,0,0,0})
		_n1X		:= ascan(_aSaldos,{|x| x[1] == "1.X"})
	EndIf
	If _n2X == 0
		AADD(_aSaldos,{"2.X","TOTAL 2.X","2.X","2.X",0,0,0,0,0,0,0,0,0,0,0,0})
		_n2X		:= ascan(_aSaldos,{|x| x[1] == "2.X"})
	EndIf
	If _n3X == 0
		AADD(_aSaldos,{"3.X","TOTAL 3.X","3.X","3.X",0,0,0,0,0,0,0,0,0,0,0,0})
		_n3X		:= ascan(_aSaldos,{|x| x[1] == "3.X"})
	EndIf
	If _n4X == 0
		AADD(_aSaldos,{"4.X","TOTAL 4.X","4.X","4.X",0,0,0,0,0,0,0,0,0,0,0,0})
		_n4X		:= ascan(_aSaldos,{|x| x[1] == "4.X"})
	EndIf
	If _n5X == 0
		AADD(_aSaldos,{"5.X","TOTAL 5.X","5.X","5.X",0,0,0,0,0,0,0,0,0,0,0,0})
		_n5X		:= ascan(_aSaldos,{|x| x[1] == "5.X"})
	EndIf
/*
	If _nSalAnt == 0
		AADD(_aSaldos,{"0.X","TOTAL 0.X","0.X","0.X",0,0,0,0,0,0,0,0,0,0,0,0})
		_nSalAnt	:= ascan(_aSaldos,{|x| x[1] == "0.X"})
		If _nSalAnt > 0
			_aSaldos[_nSalAnt,06] := (((_aSaldos[_nSalAnt,05]	+(_aSaldos[_n1X,05]-_aSaldos[_n2X,05]))+_aSaldos[_n3X,05])-_aSaldos[_n4X,05])+_aSaldos[_n5X,05]
			_aSaldos[_nSalAnt,07] := (((_aSaldos[_nSalAnt,06]	+(_aSaldos[_n1X,06]-_aSaldos[_n2X,06]))+_aSaldos[_n3X,06])-_aSaldos[_n4X,06])+_aSaldos[_n5X,06]
			_aSaldos[_nSalAnt,08] := (((_aSaldos[_nSalAnt,07]	+(_aSaldos[_n1X,07]-_aSaldos[_n2X,07]))+_aSaldos[_n3X,07])-_aSaldos[_n4X,07])+_aSaldos[_n5X,07]
			_aSaldos[_nSalAnt,09] := (((_aSaldos[_nSalAnt,08]	+(_aSaldos[_n1X,08]-_aSaldos[_n2X,08]))+_aSaldos[_n3X,08])-_aSaldos[_n4X,08])+_aSaldos[_n5X,08]
			_aSaldos[_nSalAnt,10] := (((_aSaldos[_nSalAnt,09]	+(_aSaldos[_n1X,09]-_aSaldos[_n2X,09]))+_aSaldos[_n3X,09])-_aSaldos[_n4X,09])+_aSaldos[_n5X,09]
			_aSaldos[_nSalAnt,11] := (((_aSaldos[_nSalAnt,10]	+(_aSaldos[_n1X,10]-_aSaldos[_n2X,10]))+_aSaldos[_n3X,10])-_aSaldos[_n4X,10])+_aSaldos[_n5X,10]
			_aSaldos[_nSalAnt,12] := (((_aSaldos[_nSalAnt,11]	+(_aSaldos[_n1X,11]-_aSaldos[_n2X,11]))+_aSaldos[_n3X,11])-_aSaldos[_n4X,11])+_aSaldos[_n5X,11]
			_aSaldos[_nSalAnt,13] := (((_aSaldos[_nSalAnt,12]	+(_aSaldos[_n1X,12]-_aSaldos[_n2X,12]))+_aSaldos[_n3X,12])-_aSaldos[_n4X,12])+_aSaldos[_n5X,12]
			_aSaldos[_nSalAnt,14] := (((_aSaldos[_nSalAnt,13]	+(_aSaldos[_n1X,13]-_aSaldos[_n2X,13]))+_aSaldos[_n3X,13])-_aSaldos[_n4X,13])+_aSaldos[_n5X,13]
			_aSaldos[_nSalAnt,15] := (((_aSaldos[_nSalAnt,14]	+(_aSaldos[_n1X,14]-_aSaldos[_n2X,14]))+_aSaldos[_n3X,14])-_aSaldos[_n4X,14])+_aSaldos[_n5X,14]
			_aSaldos[_nSalAnt,16] := (((_aSaldos[_nSalAnt,15]	+(_aSaldos[_n1X,15]-_aSaldos[_n2X,15]))+_aSaldos[_n3X,15])-_aSaldos[_n4X,15])+_aSaldos[_n5X,16]
		EndIf
	Else
		_aSaldos[_nSalAnt,06] := (((_aSaldos[_nSalAnt,05]	+(_aSaldos[_n1X,05]-_aSaldos[_n2X,05]))+_aSaldos[_n3X,05])-_aSaldos[_n4X,05])+_aSaldos[_n5X,05]
		_aSaldos[_nSalAnt,07] := (((_aSaldos[_nSalAnt,06]	+(_aSaldos[_n1X,06]-_aSaldos[_n2X,06]))+_aSaldos[_n3X,06])-_aSaldos[_n4X,06])+_aSaldos[_n5X,06]
		_aSaldos[_nSalAnt,08] := (((_aSaldos[_nSalAnt,07]	+(_aSaldos[_n1X,07]-_aSaldos[_n2X,07]))+_aSaldos[_n3X,07])-_aSaldos[_n4X,07])+_aSaldos[_n5X,07]
		_aSaldos[_nSalAnt,09] := (((_aSaldos[_nSalAnt,08]	+(_aSaldos[_n1X,08]-_aSaldos[_n2X,08]))+_aSaldos[_n3X,08])-_aSaldos[_n4X,08])+_aSaldos[_n5X,08]
		_aSaldos[_nSalAnt,10] := (((_aSaldos[_nSalAnt,09]	+(_aSaldos[_n1X,09]-_aSaldos[_n2X,09]))+_aSaldos[_n3X,09])-_aSaldos[_n4X,09])+_aSaldos[_n5X,09]
		_aSaldos[_nSalAnt,11] := (((_aSaldos[_nSalAnt,10]	+(_aSaldos[_n1X,10]-_aSaldos[_n2X,10]))+_aSaldos[_n3X,10])-_aSaldos[_n4X,10])+_aSaldos[_n5X,10]
		_aSaldos[_nSalAnt,12] := (((_aSaldos[_nSalAnt,11]	+(_aSaldos[_n1X,11]-_aSaldos[_n2X,11]))+_aSaldos[_n3X,11])-_aSaldos[_n4X,11])+_aSaldos[_n5X,11]
		_aSaldos[_nSalAnt,13] := (((_aSaldos[_nSalAnt,12]	+(_aSaldos[_n1X,12]-_aSaldos[_n2X,12]))+_aSaldos[_n3X,12])-_aSaldos[_n4X,12])+_aSaldos[_n5X,12]
		_aSaldos[_nSalAnt,14] := (((_aSaldos[_nSalAnt,13]	+(_aSaldos[_n1X,13]-_aSaldos[_n2X,13]))+_aSaldos[_n3X,13])-_aSaldos[_n4X,13])+_aSaldos[_n5X,13]
		_aSaldos[_nSalAnt,15] := (((_aSaldos[_nSalAnt,14]	+(_aSaldos[_n1X,14]-_aSaldos[_n2X,14]))+_aSaldos[_n3X,14])-_aSaldos[_n4X,14])+_aSaldos[_n5X,14]
		_aSaldos[_nSalAnt,16] := (((_aSaldos[_nSalAnt,15]	+(_aSaldos[_n1X,15]-_aSaldos[_n2X,15]))+_aSaldos[_n3X,15])-_aSaldos[_n4X,15])+_aSaldos[_n5X,16]
	EndIf
*/
	DbSelectArea("FLX")
	If DbSeek("0.00")
		RecLock("FLX",.F.)
		FLX->FLX_VL01 	:= _aSaldos[_nSalAnt,05] //tira dia 12/02/09 pelo analista Emerson. Estava dobrando o valor de Saldo Inicial mudamos de += para :=
		FLX->FLX_VL02 	:= _aSaldos[_nSalAnt,06]
		FLX->FLX_VL03 	:= _aSaldos[_nSalAnt,07]
		FLX->FLX_VL04 	:= _aSaldos[_nSalAnt,08]
		FLX->FLX_VL05 	:= _aSaldos[_nSalAnt,09]
		FLX->FLX_VL06 	:= _aSaldos[_nSalAnt,10]
		FLX->FLX_VL07 	:= _aSaldos[_nSalAnt,11]
		FLX->FLX_VL08 	:= _aSaldos[_nSalAnt,12]
		FLX->FLX_VL09 	:= _aSaldos[_nSalAnt,13]
		FLX->FLX_VL10 	:= _aSaldos[_nSalAnt,14]
		FLX->FLX_VL11 	:= _aSaldos[_nSalAnt,15]
		FLX->FLX_VL12 	:= _aSaldos[_nSalAnt,16]
		MsUnLock()
	Else
		RecLock("FLX",.T.)
		FLX->FLX_NATU 	:= "0.00"
		FLX->FLX_DESC 	:= "SALDO INICIAL"
		FLX->FLX_DESORC	:= "SALDO INICIAL"
		FLX->FLX_SUP 	:= "0.00"
		FLX->FLX_SUPORC	:= "0.00"
		FLX->FLX_GRP	:= "0"
		FLX->FLX_VL01 	:= _aSaldos[_nSalAnt,05]
		FLX->FLX_VL02 	:= _aSaldos[_nSalAnt,06]
		FLX->FLX_VL03 	:= _aSaldos[_nSalAnt,07]
		FLX->FLX_VL04 	:= _aSaldos[_nSalAnt,08]
		FLX->FLX_VL05 	:= _aSaldos[_nSalAnt,09]
		FLX->FLX_VL06 	:= _aSaldos[_nSalAnt,10]
		FLX->FLX_VL07 	:= _aSaldos[_nSalAnt,11]
		FLX->FLX_VL08 	:= _aSaldos[_nSalAnt,12]
		FLX->FLX_VL09 	:= _aSaldos[_nSalAnt,13]
		FLX->FLX_VL10 	:= _aSaldos[_nSalAnt,14]
		FLX->FLX_VL11 	:= _aSaldos[_nSalAnt,15]
		FLX->FLX_VL12 	:= _aSaldos[_nSalAnt,16]
		FLX->FLX_ANO	:= mv_par01
		MsUnLock()
	EndIf
EndIf

_nVal01	:= 0
_nVal02	:= 0
_nVal03	:= 0
_nVal04	:= 0
_nVal05	:= 0
_nVal06	:= 0
_nVal07	:= 0
_nVal08	:= 0
_nVal09	:= 0
_nVal10	:= 0
_nVal11	:= 0
_nVal12	:= 0

If !Empty(_aSaldos)
	/*--------------------------------------------------------------------------------------------------------------
	INICIO - Bloco para calcular o Saldo Recebimentos - Pagamentos
	--------------------------------------------------------------------------------------------------------------*/
	_nPos1 := ascan(_aSaldos,{|x| x[1] == "1.X"})
	If _nPos1 >0
		_nVal01	+= _aSaldos[_nPos1,05]	//Janeiro
		_nVal02	+= _aSaldos[_nPos1,06]	//Fevereiro
		_nVal03	+= _aSaldos[_nPos1,07]	//Marco
		_nVal04	+= _aSaldos[_nPos1,08]	//Abril
		_nVal05	+= _aSaldos[_nPos1,09]	//Maio
		_nVal06	+= _aSaldos[_nPos1,10]	//Junho
		_nVal07	+= _aSaldos[_nPos1,11]	//Julho
		_nVal08	+= _aSaldos[_nPos1,12]	//Agosto
		_nVal09	+= _aSaldos[_nPos1,13]	//Setembro
		_nVal10	+= _aSaldos[_nPos1,14]	//Outubro
		_nVal11	+= _aSaldos[_nPos1,15]	//Novembro
		_nVal12	+= _aSaldos[_nPos1,16]	//Dezembro
	EndIf

	_nPos2 := ascan(_aSaldos,{|x| x[1] == "2.X"})
	If _nPos2 >0
		_nVal01	-= _aSaldos[_nPos2,05]	//Janeiro
		_nVal02	-= _aSaldos[_nPos2,06]	//Fevereiro
		_nVal03	-= _aSaldos[_nPos2,07]	//Marco
		_nVal04	-= _aSaldos[_nPos2,08]	//Abril
		_nVal05	-= _aSaldos[_nPos2,09]	//Maio
		_nVal06	-= _aSaldos[_nPos2,10]	//Junho
		_nVal07	-= _aSaldos[_nPos2,11]	//Julho
		_nVal08	-= _aSaldos[_nPos2,12]	//Agosto
		_nVal09	-= _aSaldos[_nPos2,13]	//Setembro
		_nVal10	-= _aSaldos[_nPos2,14]	//Outubro
		_nVal11	-= _aSaldos[_nPos2,15]	//Novembro
		_nVal12	-= _aSaldos[_nPos2,16]	//Dezembro
	EndIf

	RecLock("FLX",.T.)
	FLX->FLX_NATU 	:= "2.X"
	FLX->FLX_DESC 	:= "A) Saldo de Caixa Operacional (01 - 02)"
	FLX->FLX_DESORC	:= "A) Saldo de Caixa Operacional (01 - 02)"
	FLX->FLX_SUP 	:= "2.X"
	FLX->FLX_SUPORC	:= "2.X"
	FLX->FLX_GRP	:= "2.X"
	FLX->FLX_VL01 	:= _nVal01
	FLX->FLX_VL02 	:= _nVal02
	FLX->FLX_VL03 	:= _nVal03
	FLX->FLX_VL04 	:= _nVal04
	FLX->FLX_VL05 	:= _nVal05
	FLX->FLX_VL06 	:= _nVal06
	FLX->FLX_VL07 	:= _nVal07
	FLX->FLX_VL08 	:= _nVal08
	FLX->FLX_VL09 	:= _nVal09
	FLX->FLX_VL10 	:= _nVal10
	FLX->FLX_VL11 	:= _nVal11
	FLX->FLX_VL12 	:= _nVal12
	FLX->FLX_ANO	:= mv_par01
	MsUnLock()

	/*--------------------------------------------------------------------------------------------------------------
	FIM - Bloco para calcular o Saldo Recebimentos - Pagamentos
	--------------------------------------------------------------------------------------------------------------*/

	/*--------------------------------------------------------------------------------------------------------------
	INICIO - Bloco para calcular o Saldo Parcial Caixa - B
	--------------------------------------------------------------------------------------------------------------*/
	_nPos3 := ascan(_aSaldos,{|x| x[1] == "0.X"})			//SALDO INICIAL
	If _nPos3 >0
		_nVal01	+= _aSaldos[_nPos3,05]	//Janeiro
		_nVal02	+= _aSaldos[_nPos3,06]	//Fevereiro
		_nVal03	+= _aSaldos[_nPos3,07]	//Marco
		_nVal04	+= _aSaldos[_nPos3,08]	//Abril
		_nVal05	+= _aSaldos[_nPos3,09]	//Maio
		_nVal06	+= _aSaldos[_nPos3,10]	//Junho
		_nVal07	+= _aSaldos[_nPos3,11]	//Julho
		_nVal08	+= _aSaldos[_nPos3,12]	//Agosto
		_nVal09	+= _aSaldos[_nPos3,13]	//Setembro
		_nVal10	+= _aSaldos[_nPos3,14]	//Outubro
		_nVal11	+= _aSaldos[_nPos3,15]	//Novembro
		_nVal12	+= _aSaldos[_nPos3,16]	//Dezembro
	EndIf

	_nPos4 := ascan(_aSaldos,{|x| x[1] == "3.X"})
	If _nPos4 >0
		_nVal01	+= _aSaldos[_nPos4,05]	//Janeiro
		_nVal02	+= _aSaldos[_nPos4,06]	//Fevereiro
		_nVal03	+= _aSaldos[_nPos4,07]	//Marco
		_nVal04	+= _aSaldos[_nPos4,08]	//Abril
		_nVal05	+= _aSaldos[_nPos4,09]	//Maio
		_nVal06	+= _aSaldos[_nPos4,10]	//Junho
		_nVal07	+= _aSaldos[_nPos4,11]	//Julho
		_nVal08	+= _aSaldos[_nPos4,12]	//Agosto
		_nVal09	+= _aSaldos[_nPos4,13]	//Setembro
		_nVal10	+= _aSaldos[_nPos4,14]	//Outubro
		_nVal11	+= _aSaldos[_nPos4,15]	//Novembro
		_nVal12	+= _aSaldos[_nPos4,16]	//Dezembro
	EndIf

	RecLock("FLX",.T.)
	FLX->FLX_NATU 	:= "3.X"
	FLX->FLX_DESC 	:= "B) Saldo Parcial de Caixa (00 + A + 03)"
	FLX->FLX_DESORC	:= "B) Saldo Parcial de Caixa (00 + A + 03)"
	FLX->FLX_SUP 	:= "3.X"
	FLX->FLX_SUPORC	:= "3.X"
	FLX->FLX_GRP	:= "3.X"
	FLX->FLX_VL01 	:= _nVal01
	FLX->FLX_VL02 	:= _nVal02
	FLX->FLX_VL03 	:= _nVal03
	FLX->FLX_VL04 	:= _nVal04
	FLX->FLX_VL05 	:= _nVal05
	FLX->FLX_VL06 	:= _nVal06
	FLX->FLX_VL07 	:= _nVal07
	FLX->FLX_VL08 	:= _nVal08
	FLX->FLX_VL09 	:= _nVal09
	FLX->FLX_VL10 	:= _nVal10
	FLX->FLX_VL11 	:= _nVal11
	FLX->FLX_VL12 	:= _nVal12
	FLX->FLX_ANO	:= mv_par01
	MsUnLock()
	/*--------------------------------------------------------------------------------------------------------------
	FIM - Bloco para calcular o Saldo Parcial Caixa - B
	--------------------------------------------------------------------------------------------------------------*/

	/*--------------------------------------------------------------------------------------------------------------
	INICIO - Bloco para calcular o Saldo Parcial Caixa - C
	--------------------------------------------------------------------------------------------------------------*/
	_nPos5 := ascan(_aSaldos,{|x| x[1] == "4.X"})

	If _nPos5 >0
		_nVal01	-= _aSaldos[_nPos5,05]	//Janeiro
		_nVal02	-= _aSaldos[_nPos5,06]	//Fevereiro
		_nVal03	-= _aSaldos[_nPos5,07]	//Marco
		_nVal04	-= _aSaldos[_nPos5,08]	//Abril
		_nVal05	-= _aSaldos[_nPos5,09]	//Maio
		_nVal06	-= _aSaldos[_nPos5,10]	//Junho
		_nVal07	-= _aSaldos[_nPos5,11]	//Julho
		_nVal08	-= _aSaldos[_nPos5,12]	//Agosto
		_nVal09	-= _aSaldos[_nPos5,13]	//Setembro
		_nVal10	-= _aSaldos[_nPos5,14]	//Outubro
		_nVal11	-= _aSaldos[_nPos5,15]	//Novembro
		_nVal12	-= _aSaldos[_nPos5,16]	//Dezembro
	EndIf

	RecLock("FLX",.T.)
	FLX->FLX_NATU 	:= "4.X"
	FLX->FLX_DESC 	:= "C) Saldo Parcial de Caixa (B - 04)"
	FLX->FLX_DESORC	:= "C) Saldo Parcial de Caixa (B - 04)"
	FLX->FLX_SUP 	:= "4.X"
	FLX->FLX_SUPORC	:= "4.X"
	FLX->FLX_GRP	:= "4.X"
	FLX->FLX_VL01 	:= _nVal01
	FLX->FLX_VL02 	:= _nVal02
	FLX->FLX_VL03 	:= _nVal03
	FLX->FLX_VL04 	:= _nVal04
	FLX->FLX_VL05 	:= _nVal05
	FLX->FLX_VL06 	:= _nVal06
	FLX->FLX_VL07 	:= _nVal07
	FLX->FLX_VL08 	:= _nVal08
	FLX->FLX_VL09 	:= _nVal09
	FLX->FLX_VL10 	:= _nVal10
	FLX->FLX_VL11 	:= _nVal11
	FLX->FLX_VL12 	:= _nVal12
	FLX->FLX_ANO	:= mv_par01
	MsUnLock()

	/*--------------------------------------------------------------------------------------------------------------
	FIM - Bloco para calcular o Saldo Parcial Caixa - C
	--------------------------------------------------------------------------------------------------------------*/

	/*--------------------------------------------------------------------------------------------------------------
	INICIO - Bloco para calcular o Saldo Parcial Caixa - D
	--------------------------------------------------------------------------------------------------------------*/
	_nPos6 := ascan(_aSaldos,{|x| x[1] == "5.X"})

	If _nPos6 >0
		_nVal01	+= _aSaldos[_nPos6,05]	//Janeiro
		_nVal02	+= _aSaldos[_nPos6,06]	//Fevereiro
		_nVal03	+= _aSaldos[_nPos6,07]	//Marco
		_nVal04	+= _aSaldos[_nPos6,08]	//Abril
		_nVal05	+= _aSaldos[_nPos6,09]	//Maio
		_nVal06	+= _aSaldos[_nPos6,10]	//Junho
		_nVal07	+= _aSaldos[_nPos6,11]	//Julho
		_nVal08	+= _aSaldos[_nPos6,12]	//Agosto
		_nVal09	+= _aSaldos[_nPos6,13]	//Setembro
		_nVal10	+= _aSaldos[_nPos6,14]	//Outubro
		_nVal11	+= _aSaldos[_nPos6,15]	//Novembro
		_nVal12	+= _aSaldos[_nPos6,16]	//Dezembro
	EndIf

	RecLock("FLX",.T.)
	FLX->FLX_NATU 	:= "5.X"
	FLX->FLX_DESC 	:= "D) Saldo Final de Caixa (C + 05)"
	FLX->FLX_DESORC	:= "D) Saldo Final de Caixa (C + 05)"
	FLX->FLX_SUP 	:= "5.X"
	FLX->FLX_SUPORC	:= "5.X"
	FLX->FLX_GRP	:= "5.X"
	FLX->FLX_VL01 	:= _nVal01
	FLX->FLX_VL02 	:= _nVal02
	FLX->FLX_VL03 	:= _nVal03
	FLX->FLX_VL04 	:= _nVal04
	FLX->FLX_VL05 	:= _nVal05
	FLX->FLX_VL06 	:= _nVal06
	FLX->FLX_VL07 	:= _nVal07
	FLX->FLX_VL08 	:= _nVal08
	FLX->FLX_VL09 	:= _nVal09
	FLX->FLX_VL10 	:= _nVal10
	FLX->FLX_VL11 	:= _nVal11
	FLX->FLX_VL12 	:= _nVal12
	FLX->FLX_ANO	:= mv_par01
	MsUnLock()

	/*--------------------------------------------------------------------------------------------------------------
	FIM - Bloco para calcular o Saldo Parcial Caixa - D
	--------------------------------------------------------------------------------------------------------------*/

	_nPos8 := ascan(_aSaldos,{|x| x[1] == "5.X"})

	If _nPos8 >0

		_nVal01y	:= 0
		_nVal02y	:= 0
		_nVal03y	:= 0
		_nVal04y	:= 0
		_nVal05y	:= 0
		_nVal06y	:= 0
		_nVal07y	:= 0
		_nVal08y	:= 0
		_nVal09y	:= 0
		_nVal10y	:= 0
		_nVal11y	:= 0
		_nVal12y	:= 0

		_nVal01y	+= _aSaldos[_nPos8,05]	//Janeiro
		_nVal02y	+= _aSaldos[_nPos8,06]	//Fevereiro
		_nVal03y	+= _aSaldos[_nPos8,07]	//Marco
		_nVal04y	+= _aSaldos[_nPos8,08]	//Abril
		_nVal05y	+= _aSaldos[_nPos8,09]	//Maio
		_nVal06y	+= _aSaldos[_nPos8,10]	//Junho
		_nVal07y	+= _aSaldos[_nPos8,11]	//Julho
		_nVal08y	+= _aSaldos[_nPos8,12]	//Agosto
		_nVal09y	+= _aSaldos[_nPos8,13]	//Setembro
		_nVal10y	+= _aSaldos[_nPos8,14]	//Outubro
		_nVal11y	+= _aSaldos[_nPos8,15]	//Novembro
		_nVal12y	+= _aSaldos[_nPos8,16]	//Dezembro
	EndIf


	RecLock("FLX",.T.)
	FLX->FLX_NATU 	:= "8.X"
	FLX->FLX_DESC 	:= "Saldo Aplicacoes Provisao de Caixa"
	FLX->FLX_DESORC	:= "Saldo Aplicacoes Provisao de Caixa"
	FLX->FLX_SUP 	:= "8.X"
	FLX->FLX_SUPORC	:= "8.X"
	FLX->FLX_GRP	:= "8.X"
	FLX->FLX_VL01 	:= _nVal01y * -1
	FLX->FLX_VL02 	:= _nVal02y * -1
	FLX->FLX_VL03 	:= _nVal03y * -1
	FLX->FLX_VL04 	:= _nVal04y * -1
	FLX->FLX_VL05 	:= _nVal05y * -1
	FLX->FLX_VL06 	:= _nVal06y * -1
	FLX->FLX_VL07 	:= _nVal07y * -1
	FLX->FLX_VL08 	:= _nVal08y * -1
	FLX->FLX_VL09 	:= _nVal09y * -1
	FLX->FLX_VL10 	:= _nVal10y * -1
	FLX->FLX_VL11 	:= _nVal11y * -1
	FLX->FLX_VL12 	:= _nVal12y * -1
	FLX->FLX_ANO	:= mv_par01
	MsUnLock()

	/*--------------------------------------------------------------------------------------------------------------
	FIM - Bloco para calcular o Saldo 09.Saldo aplicacacao Provisao igual ao TOTAL APLICACAO RESGATE
	--------------------------------------------------------------------------------------------------------------*/

	/*--------------------------------------------------------------------------------------------------------------
	INICIO - Bloco para calcular o Saldo Final Caixa (Saldo Caixa Mes + Aplicacao Provisao
	--------------------------------------------------------------------------------------------------------------*/

	_nVal01	+= (_nVal01y * -1)
	_nVal02	+= (_nVal02y * -1)
	_nVal03	+= (_nVal03y * -1)
	_nVal04	+= (_nVal04y * -1)
	_nVal05	+= (_nVal05y * -1)
	_nVal06	+= (_nVal06y * -1)
	_nVal07	+= (_nVal07y * -1)
	_nVal08	+= (_nVal08y * -1)
	_nVal09	+= (_nVal09y * -1)
	_nVal10	+= (_nVal10y * -1)
	_nVal11	+= (_nVal11y * -1)
	_nVal12	+= (_nVal12y * -1)

	RecLock("FLX",.T.)
	FLX->FLX_NATU 	:= "9.X"
	FLX->FLX_DESC 	:= "Saldo Final de Caixa"
	FLX->FLX_DESORC	:= "Saldo Final de Caixa"
	FLX->FLX_SUP 	:= "9.X"
	FLX->FLX_SUPORC	:= "9.X"
	FLX->FLX_GRP	:= "9.X"
	FLX->FLX_VL01 	:= _nVal01
	FLX->FLX_VL02 	:= _nVal02
	FLX->FLX_VL03 	:= _nVal03
	FLX->FLX_VL04 	:= _nVal04
	FLX->FLX_VL05 	:= _nVal05
	FLX->FLX_VL06 	:= _nVal06
	FLX->FLX_VL07 	:= _nVal07
	FLX->FLX_VL08 	:= _nVal08
	FLX->FLX_VL09 	:= _nVal09
	FLX->FLX_VL10 	:= _nVal10
	FLX->FLX_VL11 	:= _nVal11
	FLX->FLX_VL12 	:= _nVal12
	FLX->FLX_ANO	:= mv_par01
	MsUnLock()

	/*--------------------------------------------------------------------------------------------------------------
	FIM - Bloco para calcular o Saldo Final Caixa (Saldo Caixa Mes + Aplicacao Provisao
	--------------------------------------------------------------------------------------------------------------*/

EndIf

If _nxOpc == 5
	DbSelectArea("FLX")
	DbGotop()
	ProcRegua(RecCount())
	cMes 	:= Substr(mv_par01,1,2)
	cAno 	:= Substr(mv_par01,6,2)
	_nVal	:= ""
	_nValAcm := 0
	Do While !EOF()
		IncProc("Gravando registros Orçamento x Fluxo...")
		DbSelectArea("ORC")

		_nVal01	:= FLX->FLX_VL01
		_nVal02	:= FLX->FLX_VL02
		_nVal03	:= FLX->FLX_VL03
		_nVal04	:= FLX->FLX_VL04
		_nVal05	:= FLX->FLX_VL05
		_nVal06	:= FLX->FLX_VL06
		_nVal07	:= FLX->FLX_VL07
		_nVal08	:= FLX->FLX_VL08
		_nVal09	:= FLX->FLX_VL09
		_nVal10	:= FLX->FLX_VL10
		_nVal11	:= FLX->FLX_VL11
		_nVal12	:= FLX->FLX_VL12

		For _nI := Val(cMes) to 1 step -1
			_nVal	 := "_nVal"+strzero(_nI,2)
			_nValAcm += &_nVal
		Next

		_nVal	:= "_nVal"+cMes
	
		If alltrim(FLX->FLX_NATU) == "0.00"
			_nValAcm := &("_nVal01")
		EndIf

		If ALLTRIM(FLX->FLX_SUPORC) == "2.05" //Natureza grupo DESCONTO
			DbSelectArea("FLX")
			FLX->(DbSkip())
		EndIf

		DbSelectArea("SED")
		DbSetOrder(1)
	    If DbSeek(xFilial("SED")+SUBSTR(FLX->FLX_NATU,1,4))
			_cDescNat	:= SED->ED_DESORC
	    Else
			If SUBSTR(FLX->FLX_NATU,1,3) $ "8.X"
				_cDescNat	:= "SALDO APLICACAO PROVISAO CAIXA"
			ElseIf SUBSTR(FLX->FLX_NATU,1,3) $ "9.X"
				_cDescNat	:= "SALDO FINAL CAIXA"
			Else
		    	_cDescNat	:= ""
		 	EndIf
	    EndIf

		/*
		If SUBSTR(FLX->FLX_NATU,1,7) == "5.01.03"
			_cDescNat	:= SED->ED_DESORC
		Else
			If SUBSTR(FLX->FLX_NATU,1,7) == "5.02.03"
				_cDescNat	:= SED->ED_DESORC
			Else
				If SUBSTR(FLX->FLX_NATU,1,4) $ "5.01"
					_cDescNat	:= "(APLICACAO)/ RESGATE - PROVISAO DE CAIXA"
				ElseIf SUBSTR(FLX->FLX_NATU,1,4) $ "5.02"
					_cDescNat	:= "(APLICACAO)/ RESGATE - RESERVAS FINANCEIRAS"
				Else
					_cDescNat	:= SED->ED_DESORC
				EndIf
			EndIf
		EndIf
		*/

		If SUBSTR(FLX->FLX_NATU,1,7) == "5.01.03" .or. SUBSTR(FLX->FLX_NATU,1,7) == "5.02.03"
			DbSelectArea("SED")
			DbSetOrder(1)
		    If DbSeek(xFilial("SED")+SUBSTR(FLX->FLX_NATU,1,7))
				_cDescNat	:= SED->ED_DESORC
			EndIf
		EndIf

		If Substr(FLX->FLX_SUPORC,1,4) == "5.01"
			_nOrcVal04	+= _nValAcm//&_nVal
		EndIf

		DbSelectArea("ORC")
		If DbSeek(FLX->FLX_SUPORC)
			RecLock("ORC",.F.)
			ORC->ORC_DESC	:= _cDescNat
			ORC->ORC_VL02	+= &_nVal
			ORC->ORC_VL04	+= _nValAcm
			MsUnLock()
		Else
			RecLock("ORC",.T.)
			ORC->ORC_NATU 	:= IIF(alltrim(FLX->FLX_NATU)=="6.10",SED->ED_SUPORC,FLX->FLX_NATU)
			ORC->ORC_DESC	:= _cDescNat
			ORC->ORC_SUP 	:= FLX->FLX_SUP
			ORC->ORC_SUPORC	:= FLX->FLX_SUPORC
			ORC->ORC_GRP 	:= FLX->FLX_GRP
			ORC->ORC_VL02	:= &_nVal
			ORC->ORC_VL04	:= _nValAcm
			If alltrim(FLX->FLX_NATU) == "8.X"
				ORC->ORC_VL01	:= _nOrcVal03 *-1
				ORC->ORC_VL03	:= _nOrcVal03 *-1
				ORC->ORC_VL02	:= _nOrcVal04 *-1
				ORC->ORC_VL04	:= _nOrcVal04 *-1
			EndIf
			ORC->ORC_DT		:= ctod("01/"+cMes+"/"+cAno+"")
			MsUnLock()
		EndIf
		_nValAcm := 0
		DbSelectArea("FLX")
		FLX->(DbSkip())
	EndDo

	DbSelectArea("ORC")
	DbGotop()
	If ORC->(!EOF())
		RecLock("ORC",.T.)
		ORC->ORC_NATU 	:= "6.X"
		ORC->ORC_DESC	:= "SALDO CAIXA MES"
		ORC->ORC_SUP 	:= "6.X"
		ORC->ORC_SUPORC	:= "6.X"
		ORC->ORC_GRP 	:= "6.X"
		ORC->ORC_VL02	:= 0
		ORC->ORC_DT		:= ctod("01/"+cMes+"/"+cAno+"")
		MsUnLock()
	EndIF
EndIF

ORC->(DbCloseArea())
FLX->(DbCloseArea())

if _nxOpc == 3
	CALLCRYS("CRY056", cParams, cOpcoes)
ElseIf _nxOpc == 4
	CALLCRYS("CRY055", cParams, cOpcoes)
ElseIf _nxOpc == 5
	CALLCRYS("CRY057", cParams, cOpcoes)
EndIf

DbSelectArea("SZZ")
DbSetOrder(1) //FILIAL+DATA+CONTA+DOCUMENTO

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFINR53   ºAutor  ³Microsiga           º Data ³  08/18/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao que calcula a quantidade de semanas independente do º±±
±±º          ³ mes. No parametro passar MES e ANO. Ex: "092008"           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CalcSemana(mv_par01)

Local _aMeses
Local _aSemana

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
			If !(_cDia == 1 .or. _cDia == 7) // 1-Domingo ---- 7-Sabado
				_aSemana[_nCont,2] := _cDt
			EndIf
		EndIf
	Next
EndIf

Return(_aSemana)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFINR53   ºAutor  ³Microsiga           º Data ³  08/18/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function _fCriaSX1()

aRegs     := {}
nSX1Order := SX1->(IndexOrd())

SX1->(dbSetOrder(1))

cPerg := Left(cPerg,10)

/*
                 grupo ,ordem ,pergunt                ,perg spa ,perg eng , variav ,tipo,tam,dec,pres,gsc,valid ,var01     ,def01     ,defspa01,defeng01,cnt01 ,var02,def02      ,defspa02,defeng02,cnt02   ,var03,def03      ,defspa03,defeng03,cnt03  ,var04,def04     ,defspa04,defeng04,cnt04,var05,def05      ,defspa05,defeng05,cnt05,f3 ,pyme,grp,help,picture
*/
If _nxOpc == 5
	aAdd(aRegs,{cPerg  ,"01" ,"Mes/Ano Referencia"   ,""       ,""       ,"mv_ch1","C" ,07 ,00 ,0  ,"G",""    ,"mv_par01",""        ,""      ,""      ,""    ,""   ,""        ,""      ,""      ,""       ,""   ,""        ,""      ,""     ,""     ,""   ,""        ,""      ,""      ,""   ,""   ,""         ,""      ,""     ,""   ,"" ,""  ,"" ,""  ,"@E 99/9999"})
Else
	aAdd(aRegs,{cPerg  ,"01" ,"Ano Referencia"       ,""       ,""       ,"mv_ch1","C" ,04 ,00 ,0  ,"G",""    ,"mv_par01",""        ,""      ,""      ,""    ,""   ,""        ,""      ,""      ,""       ,""   ,""        ,""      ,""     ,""     ,""   ,""        ,""      ,""      ,""   ,""   ,""         ,""      ,""     ,""   ,"","","","",""})
EndIf

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