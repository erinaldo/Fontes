#include "rwmake.ch"
#include "TOPCONN.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFINR55   ºAutor  ³Emerson Natali      º Data ³  22/08/2008 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio Fluxo Detalhado Acumulado Crystal                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CFINR55(_nOpc)

Private _aSemana
Private cParams		:= ""
Private cOpcoes		:= "1;0;1;Fluxo de Caixa"
Private _nxOpc 		:= _nOpc

Private	_nOrcVal03	:= 0

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

/*
**********************************************************************************************************************************
ORCAMENTO ---- TABELA SE7
**********************************************************************************************************************************
*/

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

		If !(Substr(SE7->E7_NATUREZ,1,4) $ "6.10|6.11|6.99")
			DbSelectArea("SE7")
			SE7->(DbSkip())
			Loop
		EndIf

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

		For _nI := Val(cMes) to 1 step -1
			_nVal	 := "_nVal"+strzero(_nI,2)
			_nValAcm += &_nVal
		Next

		_nVal	:= "_nVal"+cMes 

		If alltrim(SE7->E7_NATUREZ) == "6.99.99"
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
			ORC->ORC_NATU 	:= IIf(alltrim(SE7->E7_NATUREZ)=="6.99.99","0.X",SE7->E7_NATUREZ)
			ORC->ORC_DESC	:= SED->ED_DESORC
			ORC->ORC_SUP 	:= IIf(alltrim(SE7->E7_NATUREZ)=="6.99.99","0.X",_cNatSup)
			ORC->ORC_SUPORC	:= IIf(alltrim(SE7->E7_NATUREZ)=="6.99.99","0.X",_cNatSupOrc)
			ORC->ORC_GRP 	:= SUBSTR(SE7->E7_NATUREZ,1,1)
			ORC->ORC_VL01	:= IIF(_cTpMov == "P",&_nVal,&_nVal*-1)
			ORC->ORC_VL03	:= IIF(_cTpMov == "P",_nValAcm,_nValAcm*-1)
			ORC->ORC_DT		:= ctod("01/"+cMes+"/"+cAno+"")
			MsUnLock()
		EndIf
/*
		If Substr(_cNatSupOrc,1,4) == "5.01"
			_nOrcVal03	+= IIF(_cTpMov == "P",_nValAcm,_nValAcm*-1)
		EndIf
*/
		_nValAcm := 0
		DbSelectArea("SE7")
		SE7->(DbSkip())
	EndDo
EndIf

/*
**********************************************************************************************************************************
FLUXO ---- DETALHADO NATUREZAS ANALITICO (SEM VALOR)
**********************************************************************************************************************************
*/
DbSelectArea("SED")
DbSetOrder(1)
DbGotop()
ProcRegua(RecCount())

Do While !EOF()
	IncProc("Gravando registros Naturezas...")

	If !(Substr(SE7->E7_NATUREZ,1,4) $ "6.10|6.11|6.99") //TRATA SOMENTE GRUPO DE NATUREZA 6.10 E 6.11
		DbSelectArea("SED")
		SED->(DbSkip())
		Loop
	EndIf

	If SED->ED_CLASSE == "1" //Se for analitica nao traz
		DbSelectArea("SED")
		SED->(DbSkip())
		Loop
	EndIf

	If SED->ED_XFLUXO == "N"
		If alltrim(SE7->E7_NATUREZ) <> "6.99.99"
			dbSelectArea("SED")
			SED->(DbSkip())
			Loop
		EndIf
	EndIf

	RecLock("FLX",.T.)
	FLX->FLX_NATU 	:= SED->ED_CODIGO
	FLX->FLX_DESC 	:= SED->ED_DESCRIC
	FLX->FLX_SUP 	:= Substr(SED->ED_CODIGO,1,4)
	FLX->FLX_GRP	:= Substr(SED->ED_CODIGO,1,1)
	FLX->FLX_SUPORC	:= Substr(SED->ED_CODIGO,1,4)
	FLX->FLX_DESORC	:= SED->ED_DESORC
	FLX->FLX_ANO	:= mv_par01
	MsUnLock()
	DbSelectArea("SED")
	SED->(DbSkip())
EndDo

/*
**********************************************************************************************************************************
FLUXO DETALHADO COM VALOR (MOVIMENTO SZZ) (PROCESSADO DO SE5)
**********************************************************************************************************************************
*/

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

_cQuery	+= "AND (SUBSTRING(ED_CODIGO,1,4) = '6.10' OR SUBSTRING(ED_CODIGO,1,4) = '6.11' OR ED_CODIGO = '6.99.99') "

_cQuery	+= "AND YEAR(ZZ_DATA) = "+cAno+" "
_cQuery	+= "GROUP BY ZZ_NATUREZ, ZZ_DESCNAT, MONTH(ZZ_DATA), YEAR(ZZ_DATA),ED_SUP, ED_TPMOV, ED_SUPORC, ED_DESORC, ED_XFLUXO, ED_DESCRIC "
_cQuery	+= "ORDER BY ZZ_NATUREZ, ZZ_DESCNAT, MONTH(ZZ_DATA), YEAR(ZZ_DATA)"
TCQUERY _cQuery ALIAS "TMPSLD" NEW

dbSelectArea("TMPSLD")

Do While !EOF()
	IncProc("Gravando registros...")

	If TMPSLD->ED_XFLUXO == "N"
		If alltrim(TMPSLD->ED_CODIGO) <> "6.99.99"
			dbSelectArea("TMPSLD")
			TMPSLD->(DbSkip())
			Loop
		EndIf
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
		FLX->FLX_NATU 	:= TMPSLD->ZZ_NATUREZ
		FLX->FLX_DESC 	:= TMPSLD->ED_DESCRIC
		FLX->FLX_SUP 	:= Substr(TMPSLD->ZZ_NATUREZ,1,4)
		FLX->FLX_GRP	:= Substr(TMPSLD->ZZ_NATUREZ,1,1)
		FLX->FLX_SUPORC	:= Substr(TMPSLD->ZZ_NATUREZ,1,4)
		FLX->FLX_DESORC	:= TMPSLD->ED_DESORC
		&_cCampo 		:= IIF(TMPSLD->ED_TPMOV == "P",TMPSLD->ZZ_VALOR,TMPSLD->ZZ_VALOR*-1)
		FLX->FLX_ANO	:= mv_par01
		MsUnLock()
	EndIf
	
	Do Case
		Case Substr(TMPSLD->ZZ_NATUREZ,1,4) == "6.10"
			_xFLX_SUPORC	:= "1"
				If SUBSTR(TMPSLD->ZZ_NATUREZ,1,7) $ alltrim(Getmv("CI_NATAPR1")) //6.10.18; 6.10.19; 6.11.23; 6.11.24
					_xFLX_SUPORC	:= "3"
				EndIf

				If SUBSTR(TMPSLD->ZZ_NATUREZ,1,7) $ "6.10.21"
					_xFLX_SUPORC	:= "4"
				EndIf

				If SUBSTR(TMPSLD->ZZ_NATUREZ,1,7) $ "6.10.22"
					_xFLX_SUPORC	:= "5"
				EndIf

		Case Substr(TMPSLD->ZZ_NATUREZ,1,4) == "6.11"
			_xFLX_SUPORC	:= "2"

				If SUBSTR(TMPSLD->ZZ_NATUREZ,1,7) $ alltrim(Getmv("CI_NATAPR1")) //6.10.18; 6.10.19; 6.11.23; 6.11.24
					_xFLX_SUPORC	:= "3"
				EndIf

				If SUBSTR(TMPSLD->ZZ_NATUREZ,1,7) $ "6.11.21"
					_xFLX_SUPORC	:= "4"
				EndIf

		OtherWise
			_xFLX_SUPORC	:= "0" //SALDO INICIAL        //Substr(TMPSLD->ZZ_NATUREZ,1,1)
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
		AADD(_aSaldos,{"1.X",SUBSTR("PROGRAMA APRENDIZ REEMBOLSOS",1,40),"1.X","1.X",0,0,0,0,0,0,0,0,0,0,0,0})
		_n1X		:= ascan(_aSaldos,{|x| x[1] == "1.X"})
	Else
		_aSaldos[_n1X,02] := SUBSTR("PROGRAMA APRENDIZ REEMBOLSOS",1,40)
	EndIf
	If _n2X == 0
		AADD(_aSaldos,{"2.X",SUBSTR("PROGRAMA APRENDIZ DESEMBOLSOS DE ADIANTAMENTO DE DESPESAS",1,40),"2.X","2.X",0,0,0,0,0,0,0,0,0,0,0,0})
		_n2X		:= ascan(_aSaldos,{|x| x[1] == "2.X"})
	Else
		_aSaldos[_n2X,02] := SUBSTR("PROGRAMA APRENDIZ DESEMBOLSOS DE ADIANTAMENTO DE DESPESAS",1,40)
	EndIf
	If _n3X == 0
		AADD(_aSaldos,{"3.X",SUBSTR("RECURSOS RECEBIDOS DE PROVISAO DE FERIAS E 13",1,40),"3.X","3.X",0,0,0,0,0,0,0,0,0,0,0,0})
		_n3X		:= ascan(_aSaldos,{|x| x[1] == "3.X"})
	Else
		_aSaldos[_n3X,02] := SUBSTR("RECURSOS RECEBIDOS DE PROVISAO DE FERIAS E 13",1,40)
	EndIf
	If _n4X == 0
		AADD(_aSaldos,{"4.X",SUBSTR("ADIANTAMENTOS DE CONVENIO-RECEBIMENTOS/PAGAMENTOS",1,40),"4.X","4.X",0,0,0,0,0,0,0,0,0,0,0,0})
		_n4X		:= ascan(_aSaldos,{|x| x[1] == "4.X"})
	Else
		_aSaldos[_n4X,02] := SUBSTR("ADIANTAMENTOS DE CONVENIO-RECEBIMENTOS/PAGAMENTOS",1,40)
	EndIf
	If _n5X == 0
		AADD(_aSaldos,{"5.X",SUBSTR("AJUSTES DE CAIXA",1,40),"5.X","5.X",0,0,0,0,0,0,0,0,0,0,0,0})
		_n5X		:= ascan(_aSaldos,{|x| x[1] == "5.X"})
	Else
		_aSaldos[_n5X,02] := SUBSTR("AJUSTES DE CAIXA",1,40)
	EndIf
	If _nSalAnt == 0
		AADD(_aSaldos,{"0.X",SUBSTR("SALDO ANTERIOR",1,40),"0.X","0.X",0,0,0,0,0,0,0,0,0,0,0,0})
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

	DbSelectArea("FLX")
	If DbSeek("0.00")
		RecLock("FLX",.F.)
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

If _nxOpc == 5
/*
	_nOrcVal04	:= 0
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

		DbSelectArea("SED")
		DbSetOrder(1)
	    If DbSeek(xFilial("SED")+SUBSTR(FLX->FLX_NATU,1,4))
			_cDescNat	:= SED->ED_DESORC
	    Else
	    	_cDescNat	:= ""
	    EndIf

		DbSelectArea("ORC")
		If DbSeek(FLX->FLX_SUPORC)
			RecLock("ORC",.F.)
			ORC->ORC_DESC	:= _cDescNat
			ORC->ORC_VL02	+= &_nVal
			ORC->ORC_VL04	+= _nValAcm
			MsUnLock()
		Else
*/

		aSort(_aSaldos,,, {|x, y| x[1] < y[1]})

		_xMes	:= {}
		AADD(_xMes,{1,5})
		AADD(_xMes,{2,6})
		AADD(_xMes,{3,7})
		AADD(_xMes,{4,8})
		AADD(_xMes,{5,9})
		AADD(_xMes,{6,10})
		AADD(_xMes,{7,11})
		AADD(_xMes,{8,12})
		AADD(_xMes,{9,13})
		AADD(_xMes,{10,14})
		AADD(_xMes,{11,15})
		AADD(_xMes,{12,16})

		For _nX := 1 To len(_aSaldos)

			_nxMes		:= 0
			_nxMes		:= ascan(_xMes,{|x| x[1] == Val(cMes)})
			_nValAcm	:= 0
			If _nxMes > 0
				For _nY	:= _nxMes to 1 step -1
					_nValAcm += _aSaldos[_nX,_xMes[_nxMes,2]]
					_nxMes := _nxMes - 1
				Next _nY
			EndIf

			_nxMes		:= ascan(_xMes,{|x| x[1] == Val(cMes)})
			If _nxMes > 0
				_nxMes := _xMes[_nxMes,2]

				DbSelectArea("ORC")
				If DbSeek(_aSaldos[_nX,1])
					//Preparado para Acumular Saldo Anterior
				Else
					RecLock("ORC",.T.)
					ORC->ORC_NATU 	:= _aSaldos[_nX,1] // FLX->FLX_NATU
					ORC->ORC_DESC	:= _aSaldos[_nX,2] // _cDescNat
					ORC->ORC_SUP 	:= _aSaldos[_nX,3] // FLX->FLX_SUP
					ORC->ORC_SUPORC	:= _aSaldos[_nX,4] // FLX->FLX_SUPORC
					ORC->ORC_GRP 	:= _aSaldos[_nX,4] // FLX->FLX_GRP
					ORC->ORC_VL02	:= _aSaldos[_nX,_nxMes]	// &_nVal
					ORC->ORC_VL04	:= _nValAcm
					ORC->ORC_DT		:= ctod("01/"+cMes+"/"+cAno+"")
					MsUnLock()
				EndIf
			EndIf
		Next _nX
/*
		EndIf
		_nValAcm := 0
		DbSelectArea("FLX")
		FLX->(DbSkip())
	EndDo
*/
EndIF

ORC->(DbCloseArea())
FLX->(DbCloseArea())

CALLCRYS("CRY058", cParams, cOpcoes)

DbSelectArea("SZZ")
DbSetOrder(1) //FILIAL+DATA+CONTA+DOCUMENTO

Return

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