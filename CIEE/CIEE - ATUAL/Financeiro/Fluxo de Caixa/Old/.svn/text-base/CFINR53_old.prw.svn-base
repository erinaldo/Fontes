#include "rwmake.ch"
#include "TOPCONN.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFINR53   ºAutor  ³Emerson Natali      º Data ³  18/08/2008 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio Fluxo Detalhado Crystal                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CFINR53(_nOpc)

Private _aSemana
Private cParams		:= ""
Private cOpcoes		:= "1;0;1;Fluxo de Caixa"
Private _nxOpc := _nOpc
If _nxOpc == 1
	Private cPerg := "CFIN53"
Else
	Private cPerg := "CFIN54"
EndIf

_fCriaSX1()

If pergunte(cPerg,.T.)

	IF File("FLXDTL.DBF")
		dbUseArea (.T.,,"FLXDTL","FLX",NIL,.F.)
		FLX->(DbCloseArea())
		FERASE("FLXDTL"+GetDBExtension())
		Ferase("FLXDTL"+OrdBagExt())
	EndIf

	IF File("ORCFLX.DBF")
		dbUseArea (.T.,,"ORCFLX","ORC",NIL,.F.)
		ORC->(DbCloseArea())
		FERASE("ORCFLX"+GetDBExtension())
		Ferase("ORCFLX"+OrdBagExt())
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

_aSemana := CalcSemana(mv_par01)

/*
----------------------------------------------------------------------------------
Cria arquivo Temporario FLXDTL para montar os itens do relatorio Crystal (valores)
----------------------------------------------------------------------------------
*/
aCampUser := {	{"FLX_NATU" 	, "C", 10, 0, OemToAnsi("Natureza" 		)},;
				{"FLX_DESC" 	, "C", 40, 0, OemToAnsi("Descrição"		)},;
				{"FLX_VL1"  	, "N", 14, 2, OemToAnsi("Valor1" 		)},;
				{"FLX_VL2"  	, "N", 14, 2, OemToAnsi("Valor2" 		)},;
				{"FLX_VL3"  	, "N", 14, 2, OemToAnsi("Valor3" 		)},;
				{"FLX_VL4"  	, "N", 14, 2, OemToAnsi("Valor4" 		)},;
				{"FLX_VL5"  	, "N", 14, 2, OemToAnsi("Valor5" 		)},;
				{"FLX_SUP"  	, "C", 10, 0, OemToAnsi("Nat. Sup" 		)},;
				{"FLX_GRP"  	, "C", 10, 0, OemToAnsi("Grp. Nat" 		)},;
				{"FLX_DT1"  	, "D", 08, 0, OemToAnsi("Data1"  		)},;
				{"FLX_DT2"  	, "D", 08, 0, OemToAnsi("Data2"  		)},;
				{"FLX_DT3"  	, "D", 08, 0, OemToAnsi("Data3"  		)},;
				{"FLX_DT4"  	, "D", 08, 0, OemToAnsi("Data4"  		)},;
				{"FLX_DT5"  	, "D", 08, 0, OemToAnsi("Data5"  		)},;
				{"FLX_SUPORC"	, "C", 10, 0, OemToAnsi("Nat Sup Orc"	)}}

dbCreate("FLXDTL",aCampUser) // Fluxo Detalhado
dbUseArea (.T.,,"FLXDTL","FLX",NIL,.F.)
IndRegua("FLX","FLXDTL","FLX_NATU",,,OemToAnsi("Selecionando Registros..."), .T.)

aCampUser := {	{"ORC_NATU"  , "C", 10, 0, OemToAnsi("Natureza"			)},;
				{"ORC_DESC"  , "C", 40, 0, OemToAnsi("Descição"			)},;
				{"ORC_SUP"   , "C", 10, 0, OemToAnsi("Nat. Sup"			)},;
				{"ORC_GRP"   , "C", 10, 0, OemToAnsi("Grp. Nat"			)},;
				{"ORC_VL01"  , "N", 14, 2, OemToAnsi("Valor Orcado" 	)},;
				{"ORC_VL02"  , "N", 14, 2, OemToAnsi("Valor Realizado" 	)},;
				{"ORC_VL03"  , "N", 14, 2, OemToAnsi("Valor Nominal" 	)},;
				{"ORC_VL04"  , "N", 14, 2, OemToAnsi("Percentual"		)},;
				{"ORC_DT"    , "D", 08, 0, OemToAnsi("Data" 			)},;
				{"ORC_SUPORC", "C", 10, 0, OemToAnsi("Nat Sup Orc"		)}}

dbCreate("ORCFLX",aCampUser) // Fluxo Detalhado
dbUseArea (.T.,,"ORCFLX","ORC",NIL,.F.)
IndRegua("ORC","ORCFLX","ORC_SUPORC",,,OemToAnsi("Selecionando Registros..."), .T.)

If _nxOpc == 2
	DbSelectArea("SE7")
	DbSetOrder(1)
	DbGotop()
	ProcRegua(RecCount())

	cMes 	:= Substr(mv_par01,1,2)
	_nVal	:= 0

	Do While !EOF()
		IncProc("Gravando registros Orçamento...")
		DbSelectArea("ORC")

		Do Case
			Case cMes == "01"
				_nVal := SE7->E7_VALJAN1
			Case cMes == "02"
				_nVal := SE7->E7_VALFEV1
			Case cMes == "03"
				_nVal := SE7->E7_VALMAR1
			Case cMes == "04"
				_nVal := SE7->E7_VALABR1
			Case cMes == "05"
				_nVal := SE7->E7_VALMAI1
			Case cMes == "06"
				_nVal := SE7->E7_VALJUN1
			Case cMes == "07"
				_nVal := SE7->E7_VALJUL1
			Case cMes == "08"
				_nVal := SE7->E7_VALAGO1
			Case cMes == "09"
				_nVal := SE7->E7_VALSET1
			Case cMes == "10"
				_nVal := SE7->E7_VALOUT1
			Case cMes == "11"
				_nVal := SE7->E7_VALNOV1
			Case cMes == "12"
				_nVal := SE7->E7_VALDEZ1
		EndCase

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

		DbSelectArea("ORC")
		If DbSeek(_cNatSupOrc)
			RecLock("ORC",.F.)
			ORC->ORC_VL01	+= IIF(_cTpMov == "P",_nVal,_nVal*-1)
			MsUnLock()
		Else
			RecLock("ORC",.T.)
			ORC->ORC_NATU 	:= SE7->E7_NATUREZ
			ORC->ORC_SUP 	:= _cNatSup
			ORC->ORC_SUPORC	:= _cNatSupOrc
			ORC->ORC_GRP 	:= SUBSTR(SE7->E7_NATUREZ,1,1)
			ORC->ORC_VL01	:= IIF(_cTpMov == "P",_nVal,_nVal*-1)
			If !Empty(_aSemana)
				ORC->ORC_DT	:= _aSemana[MV_PAR02,2]
			Else
				ORC->ORC_DT	:= ctod("  /  /  ")
			EndIf
	
			MsUnLock()
		EndIf
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
	RecLock("FLX",.T.)
	FLX->FLX_NATU 	:= SED->ED_CODIGO
	FLX->FLX_DESC 	:= SED->ED_DESCRIC
	FLX->FLX_SUP 	:= SED->ED_SUP
	FLX->FLX_GRP	:= Substr(SED->ED_CODIGO,1,1)
	FLX->FLX_SUPORC	:= SED->ED_SUPORC
	If !Empty(_aSemana)
		FLX->FLX_DT1	:= _aSemana[1,2]
		FLX->FLX_DT2	:= _aSemana[2,2]
		FLX->FLX_DT3	:= _aSemana[3,2]
		FLX->FLX_DT4	:= _aSemana[4,2]
		FLX->FLX_DT5	:= IIf(Len(_aSemana)>4,_aSemana[5,2],Ctod("  /  /    "))
	EndIf
	MsUnLock()
	DbSelectArea("SED")
	SED->(DbSkip())
EndDo

DbSelectArea("SZZ")
DbSetOrder(2) //FILIAL+DATA+NATUREZ
ProcRegua(RecCount())

_aSaldos	:= {}

For _nI := 1 to Len(_aSemana)

	_cQuery := "SELECT ZZ_NATUREZ, ZZ_DESCNAT, ZZ_VALOR "
	_cQuery	+= "FROM " + RetSqlName("SZZ")+" "
	_cQuery += "WHERE D_E_L_E_T_ = '' "
	_cQuery	+= "AND ZZ_DATA BETWEEN '"+DTOS(_aSemana[_nI,1])+"' AND '"+DTOS(_aSemana[_nI,2])+"'
	_cQuery	+= "AND ZZ_DEL = ''
	_cQuery	+= "ORDER BY ZZ_NATUREZ"
	TCQUERY _cQuery ALIAS "TMPSLD" NEW

	dbSelectArea("TMPSLD")

	_cCampo	:= "FLX->FLX_VL"+Str(_nI,1)
	
	Do While !EOF()

		IncProc("Gravando registros...")

		DbSelectArea("SED")
		DbSetOrder(1)
        If DbSeek(xFilial("SED")+TMPSLD->ZZ_NATUREZ)
        	_cNatSup 	:= SED->ED_SUP
        	_cTpMov		:= SED->ED_TPMOV
        	_cNatSupOrc	:= SED->ED_SUPORC
        EndIf

		DbSelectArea("FLX")
		If DbSeek(TMPSLD->ZZ_NATUREZ)
			RecLock("FLX",.F.)
			&_cCampo	 	+= IIF(_cTpMov == "P",TMPSLD->ZZ_VALOR,TMPSLD->ZZ_VALOR*-1)
			MsUnLock()
		Else
			RecLock("FLX",.T.)
			FLX->FLX_NATU 	:= TMPSLD->ZZ_NATUREZ
			FLX->FLX_DESC 	:= TMPSLD->ZZ_DESCNAT
			&_cCampo	 	:= IIF(_cTpMov == "P",TMPSLD->ZZ_VALOR,TMPSLD->ZZ_VALOR*-1)
			FLX->FLX_SUP 	:= _cNatSup
			FLX->FLX_GRP	:= Substr(TMPSLD->ZZ_NATUREZ,1,1)
			FLX->FLX_DT1	:= _aSemana[1,2]
			FLX->FLX_DT2	:= _aSemana[2,2]
			FLX->FLX_DT3	:= _aSemana[3,2]
			FLX->FLX_DT4	:= _aSemana[4,2]
			FLX->FLX_DT5	:= IIf(Len(_aSemana)>4,_aSemana[5,2],Ctod("  /  /    "))
			FLX->FLX_SUPORC	:= _cNatSupOrc
			MsUnLock()
		EndIf

		_nPos := ascan(_aSaldos,{|x| x[1] == SUBSTR(TMPSLD->ZZ_NATUREZ,1,1)+".X"})
		If _nPos > 0
			_aSaldos[_nPos,03] += IIF(_nI==1,IIF(_cTpMov == "P",TMPSLD->ZZ_VALOR,TMPSLD->ZZ_VALOR*-1),0)		//Valor 1 Semana
			_aSaldos[_nPos,04] += IIF(_nI==2,IIF(_cTpMov == "P",TMPSLD->ZZ_VALOR,TMPSLD->ZZ_VALOR*-1),0)		//Valor 2 Semana
			_aSaldos[_nPos,05] += IIF(_nI==3,IIF(_cTpMov == "P",TMPSLD->ZZ_VALOR,TMPSLD->ZZ_VALOR*-1),0)		//Valor 3 Semana
			_aSaldos[_nPos,06] += IIF(_nI==4,IIF(_cTpMov == "P",TMPSLD->ZZ_VALOR,TMPSLD->ZZ_VALOR*-1),0)		//Valor 4 Semana
			_aSaldos[_nPos,07] += IIf(Len(_aSemana) > 4,IIF(_nI==5,IIF(_cTpMov == "P",TMPSLD->ZZ_VALOR,TMPSLD->ZZ_VALOR*-1),0),0)	//Valor 5 Semana
		Else
			AADD( _aSaldos, { 	SUBSTR(TMPSLD->ZZ_NATUREZ,1,1)+".X"										,;		//Natureza
								"TOTAL ?.X"																,;		//Descricao Natureza
								IIF(_nI==1,IIF(_cTpMov == "P",TMPSLD->ZZ_VALOR,TMPSLD->ZZ_VALOR*-1),0),;		//Valor 1 Semana
								IIF(_nI==2,IIF(_cTpMov == "P",TMPSLD->ZZ_VALOR,TMPSLD->ZZ_VALOR*-1),0),;		//Valor 2 Semana
								IIF(_nI==3,IIF(_cTpMov == "P",TMPSLD->ZZ_VALOR,TMPSLD->ZZ_VALOR*-1),0),;		//Valor 3 Semana
								IIF(_nI==4,IIF(_cTpMov == "P",TMPSLD->ZZ_VALOR,TMPSLD->ZZ_VALOR*-1),0),;		//Valor 4 Semana
								IIf(Len(_aSemana) > 4,IIF(_nI==5,IIF(_cTpMov == "P",TMPSLD->ZZ_VALOR,TMPSLD->ZZ_VALOR*-1),0),0),; //Valor 5 Semana
								SUBSTR(TMPSLD->ZZ_NATUREZ,1,1)+".X"										,;		//Natureza Superior
								STR(VAL(SUBSTR(TMPSLD->ZZ_NATUREZ,1,1))+1,1)							,;		//Grupo Natureza
								_aSemana[1,2]															,;		//Data 1 Semana
								_aSemana[2,2]															,;		//Data 2 Semana
								_aSemana[3,2]															,;		//Data 3 Semana
								_aSemana[4,2]															,;		//Data 4 Semana
								IIf(Len(_aSemana) > 4,_aSemana[5,2],Ctod("  /  /  "))					})		//Data 5 Semana
		EndIf

		dbSelectArea("TMPSLD")
		TMPSLD->(DbSkip())
	EndDo

	TMPSLD->(dbCloseArea())

Next

If !Empty(_aSemana)
	If !Empty(_aSaldos)
		_nSalAnt	:= ascan(_aSaldos,{|x| x[1] == "0.X"})
		_n1X		:= ascan(_aSaldos,{|x| x[1] == "1.X"})
		_n2X		:= ascan(_aSaldos,{|x| x[1] == "2.X"})
		_n3X		:= ascan(_aSaldos,{|x| x[1] == "3.X"})
		_n4X		:= ascan(_aSaldos,{|x| x[1] == "4.X"})
		_n5X		:= ascan(_aSaldos,{|x| x[1] == "5.X"})
		If _n1X == 0
			AADD(_aSaldos,{"1.X","",0,0,0,0,0,"1.X","1.X",_aSemana[1,2],_aSemana[2,2],_aSemana[3,2],_aSemana[4,2],IIf(Len(_aSemana) > 4,_aSemana[5,2],Ctod("  /  /  "))})
			_n1X		:= ascan(_aSaldos,{|x| x[1] == "1.X"})
		EndIf
		If _n2X == 0
			AADD(_aSaldos,{"2.X","",0,0,0,0,0,"2.X","2.X",_aSemana[1,2],_aSemana[2,2],_aSemana[3,2],_aSemana[4,2],IIf(Len(_aSemana) > 4,_aSemana[5,2],Ctod("  /  /  "))})
			_n2X		:= ascan(_aSaldos,{|x| x[1] == "2.X"})
		EndIf
		If _n3X == 0
			AADD(_aSaldos,{"3.X","",0,0,0,0,0,"3.X","3.X",_aSemana[1,2],_aSemana[2,2],_aSemana[3,2],_aSemana[4,2],IIf(Len(_aSemana) > 4,_aSemana[5,2],Ctod("  /  /  "))})
			_n3X		:= ascan(_aSaldos,{|x| x[1] == "3.X"})
		EndIf
		If _n4X == 0
			AADD(_aSaldos,{"4.X","",0,0,0,0,0,"4.X","4.X",_aSemana[1,2],_aSemana[2,2],_aSemana[3,2],_aSemana[4,2],IIf(Len(_aSemana) > 4,_aSemana[5,2],Ctod("  /  /  "))})
			_n4X		:= ascan(_aSaldos,{|x| x[1] == "4.X"})
		EndIf
		If _n5X == 0
			AADD(_aSaldos,{"5.X","",0,0,0,0,0,"5.X","5.X",_aSemana[1,2],_aSemana[2,2],_aSemana[3,2],_aSemana[4,2],IIf(Len(_aSemana) > 4,_aSemana[5,2],Ctod("  /  /  "))})
			_n5X		:= ascan(_aSaldos,{|x| x[1] == "5.X"})
		EndIf
		If _nSalAnt == 0
			AADD(_aSaldos,{"0.X","",0,0,0,0,0,"0.X","0.X",_aSemana[1,2],_aSemana[2,2],_aSemana[3,2],_aSemana[4,2],IIf(Len(_aSemana) > 4,_aSemana[5,2],Ctod("  /  /  "))})
			_nSalAnt	:= ascan(_aSaldos,{|x| x[1] == "0.X"})
			If _nSalAnt > 0
				_aSaldos[_nSalAnt,4] := (((0+(_aSaldos[_n1X,3]-_aSaldos[_n2X,3]))+_aSaldos[_n3X,3])-_aSaldos[_n4X,3])+_aSaldos[_n5X,3]
				_aSaldos[_nSalAnt,5] := (((_aSaldos[_nSalAnt,4]+(_aSaldos[_n1X,4]-_aSaldos[_n2X,4]))+_aSaldos[_n3X,4])-_aSaldos[_n4X,4])+_aSaldos[_n5X,4]
				_aSaldos[_nSalAnt,6] := (((_aSaldos[_nSalAnt,5]+(_aSaldos[_n1X,5]-_aSaldos[_n2X,5]))+_aSaldos[_n3X,5])-_aSaldos[_n4X,5])+_aSaldos[_n5X,5]
				_aSaldos[_nSalAnt,7] := (((_aSaldos[_nSalAnt,6]+(_aSaldos[_n1X,6]-_aSaldos[_n2X,6]))+_aSaldos[_n3X,6])-_aSaldos[_n4X,6])+_aSaldos[_n5X,6]
			EndIf
		Else
			_aSaldos[_nSalAnt,4] := (((_aSaldos[_nSalAnt,3]+(_aSaldos[_n1X,3]-_aSaldos[_n2X,3]))+_aSaldos[_n3X,3])-_aSaldos[_n4X,3])+_aSaldos[_n5X,3]
			_aSaldos[_nSalAnt,5] := (((_aSaldos[_nSalAnt,4]+(_aSaldos[_n1X,4]-_aSaldos[_n2X,4]))+_aSaldos[_n3X,4])-_aSaldos[_n4X,4])+_aSaldos[_n5X,4]
			_aSaldos[_nSalAnt,6] := (((_aSaldos[_nSalAnt,5]+(_aSaldos[_n1X,5]-_aSaldos[_n2X,5]))+_aSaldos[_n3X,5])-_aSaldos[_n4X,5])+_aSaldos[_n5X,5]
			_aSaldos[_nSalAnt,7] := (((_aSaldos[_nSalAnt,6]+(_aSaldos[_n1X,6]-_aSaldos[_n2X,6]))+_aSaldos[_n3X,6])-_aSaldos[_n4X,6])+_aSaldos[_n5X,6]
		EndIf

		DbSelectArea("FLX")
		If DbSeek("0.00")
			RecLock("FLX",.F.)
			FLX->FLX_VL2 	:= _aSaldos[_nSalAnt,4]
			FLX->FLX_VL3 	:= _aSaldos[_nSalAnt,5]
			FLX->FLX_VL4 	:= _aSaldos[_nSalAnt,6]
			FLX->FLX_VL5 	:= _aSaldos[_nSalAnt,7]
			MsUnLock()
		Else
			RecLock("FLX",.T.)
			FLX->FLX_NATU 	:= "0.00"
			FLX->FLX_DESC 	:= "SALDO INICIAL"
			FLX->FLX_VL1 	:= _aSaldos[_nSalAnt,3]
			FLX->FLX_VL2 	:= _aSaldos[_nSalAnt,4]
			FLX->FLX_VL3 	:= _aSaldos[_nSalAnt,5]
			FLX->FLX_VL4 	:= _aSaldos[_nSalAnt,6]
			FLX->FLX_VL5 	:= _aSaldos[_nSalAnt,7]
			FLX->FLX_SUP 	:= "0.00"
			FLX->FLX_SUPORC	:= "0.00"
			FLX->FLX_GRP	:= "0"
			FLX->FLX_DT1	:= _aSaldos[1,10]
			FLX->FLX_DT2	:= _aSaldos[1,11]
			FLX->FLX_DT3	:= _aSaldos[1,12]
			FLX->FLX_DT4	:= _aSaldos[1,13]
			FLX->FLX_DT5	:= _aSaldos[1,14]
			MsUnLock()
		EndIf
	EndIf
EndIf

_nVal1	:= 0
_nVal2	:= 0
_nVal3	:= 0
_nVal4	:= 0
_nVal5	:= 0

If !Empty(_aSaldos)
	/*--------------------------------------------------------------------------------------------------------------
	INICIO - Bloco para calcular o Saldo Recebimentos - Pagamentos
	--------------------------------------------------------------------------------------------------------------*/
	_nPos1 := ascan(_aSaldos,{|x| x[1] == "1.X"})
	If _nPos1 >0
		_nVal1	+= _aSaldos[_nPos1,03]	//Valor Semana 1
		_nVal2	+= _aSaldos[_nPos1,04]	//Valor Semana 2
		_nVal3	+= _aSaldos[_nPos1,05]	//Valor Semana 3
		_nVal4	+= _aSaldos[_nPos1,06]	//Valor Semana 4
		_nVal5	+= _aSaldos[_nPos1,07]	//Valor Semana 5
	EndIf

	_nPos2 := ascan(_aSaldos,{|x| x[1] == "2.X"})
	If _nPos2 >0
		_nVal1	-= _aSaldos[_nPos2,03]	//Valor Semana 1
		_nVal2	-= _aSaldos[_nPos2,04]	//Valor Semana 2
		_nVal3	-= _aSaldos[_nPos2,05]	//Valor Semana 3
		_nVal4	-= _aSaldos[_nPos2,06]	//Valor Semana 4
		_nVal5	-= _aSaldos[_nPos2,07]	//Valor Semana 5
	EndIf

	RecLock("FLX",.T.)
	FLX->FLX_NATU 	:= "2.X"
	FLX->FLX_DESC 	:= "A) Saldo de Caixa Operacional (01 - 02)"
	FLX->FLX_VL1 	:= _nVal1
	FLX->FLX_VL2 	:= _nVal2
	FLX->FLX_VL3 	:= _nVal3
	FLX->FLX_VL4 	:= _nVal4
	FLX->FLX_VL5 	:= _nVal5
	FLX->FLX_SUP 	:= "2.X"
	FLX->FLX_SUPORC	:= "2.X"
	FLX->FLX_GRP	:= "2.X"
	FLX->FLX_DT1	:= _aSaldos[1,10]
	FLX->FLX_DT2	:= _aSaldos[1,11]
	FLX->FLX_DT3	:= _aSaldos[1,12]
	FLX->FLX_DT4	:= _aSaldos[1,13]
	FLX->FLX_DT5	:= _aSaldos[1,14]
	MsUnLock()

	/*--------------------------------------------------------------------------------------------------------------
	FIM - Bloco para calcular o Saldo Recebimentos - Pagamentos
	--------------------------------------------------------------------------------------------------------------*/

	/*--------------------------------------------------------------------------------------------------------------
	INICIO - Bloco para calcular o Saldo Parcial Caixa - B
	--------------------------------------------------------------------------------------------------------------*/
	_nPos3 := ascan(_aSaldos,{|x| x[1] == "0.X"})			//SALDO INICIAL
	If _nPos3 >0
		_nVal1	+= _aSaldos[_nPos3,03]	//Valor Semana 1
		_nVal2	+= _aSaldos[_nPos3,04]	//Valor Semana 2
		_nVal3	+= _aSaldos[_nPos3,05]	//Valor Semana 3
		_nVal4	+= _aSaldos[_nPos3,06]	//Valor Semana 4
		_nVal5	+= _aSaldos[_nPos3,07]	//Valor Semana 5
	EndIf

	_nPos4 := ascan(_aSaldos,{|x| x[1] == "3.X"})
	If _nPos4 >0
		_nVal1	+= _aSaldos[_nPos4,03]	//Valor Semana 1
		_nVal2	+= _aSaldos[_nPos4,04]	//Valor Semana 2
		_nVal3	+= _aSaldos[_nPos4,05]	//Valor Semana 3
		_nVal4	+= _aSaldos[_nPos4,06]	//Valor Semana 4
		_nVal5	+= _aSaldos[_nPos4,07]	//Valor Semana 5
	EndIf

	RecLock("FLX",.T.)
	FLX->FLX_NATU 	:= "3.X"
	FLX->FLX_DESC 	:= "B) Saldo Parcial de Caixa (00 + A + 03)"
	FLX->FLX_VL1 	:= _nVal1
	FLX->FLX_VL2 	:= _nVal2
	FLX->FLX_VL3 	:= _nVal3
	FLX->FLX_VL4 	:= _nVal4
	FLX->FLX_VL5 	:= _nVal5
	FLX->FLX_SUP 	:= "3.X"
	FLX->FLX_SUPORC	:= "3.X"
	FLX->FLX_GRP	:= "3.X"
	FLX->FLX_DT1	:= _aSaldos[1,10]
	FLX->FLX_DT2	:= _aSaldos[1,11]
	FLX->FLX_DT3	:= _aSaldos[1,12]
	FLX->FLX_DT4	:= _aSaldos[1,13]
	FLX->FLX_DT5	:= _aSaldos[1,14]
	MsUnLock()
	/*--------------------------------------------------------------------------------------------------------------
	FIM - Bloco para calcular o Saldo Parcial Caixa - B
	--------------------------------------------------------------------------------------------------------------*/

	/*--------------------------------------------------------------------------------------------------------------
	INICIO - Bloco para calcular o Saldo Parcial Caixa - C
	--------------------------------------------------------------------------------------------------------------*/
	_nPos5 := ascan(_aSaldos,{|x| x[1] == "4.X"})

	If _nPos5 >0
		_nVal1	-= _aSaldos[_nPos5,03]	//Valor Semana 1
		_nVal2	-= _aSaldos[_nPos5,04]	//Valor Semana 2
		_nVal3	-= _aSaldos[_nPos5,05]	//Valor Semana 3
		_nVal4	-= _aSaldos[_nPos5,06]	//Valor Semana 4
		_nVal5	-= _aSaldos[_nPos5,07]	//Valor Semana 5
	EndIf

	RecLock("FLX",.T.)
	FLX->FLX_NATU 	:= "4.X"
	FLX->FLX_DESC 	:= "C) Saldo Parcial de Caixa (B - 04)"
	FLX->FLX_VL1 	:= _nVal1
	FLX->FLX_VL2 	:= _nVal2
	FLX->FLX_VL3 	:= _nVal3
	FLX->FLX_VL4 	:= _nVal4
	FLX->FLX_VL5 	:= _nVal5
	FLX->FLX_SUP 	:= "4.X"
	FLX->FLX_SUPORC	:= "4.X"
	FLX->FLX_GRP	:= "4.X"
	FLX->FLX_DT1	:= _aSaldos[1,10]
	FLX->FLX_DT2	:= _aSaldos[1,11]
	FLX->FLX_DT3	:= _aSaldos[1,12]
	FLX->FLX_DT4	:= _aSaldos[1,13]
	FLX->FLX_DT5	:= _aSaldos[1,14]
	MsUnLock()

	/*--------------------------------------------------------------------------------------------------------------
	FIM - Bloco para calcular o Saldo Parcial Caixa - C
	--------------------------------------------------------------------------------------------------------------*/

	/*--------------------------------------------------------------------------------------------------------------
	INICIO - Bloco para calcular o Saldo Parcial Caixa - D
	--------------------------------------------------------------------------------------------------------------*/
	_nPos6 := ascan(_aSaldos,{|x| x[1] == "5.X"})

	If _nPos6 >0
		_nVal1	+= _aSaldos[_nPos6,03]	//Valor Semana 1
		_nVal2	+= _aSaldos[_nPos6,04]	//Valor Semana 2
		_nVal3	+= _aSaldos[_nPos6,05]	//Valor Semana 3
		_nVal4	+= _aSaldos[_nPos6,06]	//Valor Semana 4
		_nVal5	+= _aSaldos[_nPos6,07]	//Valor Semana 5
	EndIf

	RecLock("FLX",.T.)
	FLX->FLX_NATU 	:= "5.X"
	FLX->FLX_DESC 	:= "D) Saldo Final de Caixa (C + 05)"
	FLX->FLX_VL1 	:= _nVal1
	FLX->FLX_VL2 	:= _nVal2
	FLX->FLX_VL3 	:= _nVal3
	FLX->FLX_VL4 	:= _nVal4
	FLX->FLX_VL5 	:= _nVal5
	FLX->FLX_SUP 	:= "5.X"
	FLX->FLX_SUPORC	:= "5.X"
	FLX->FLX_GRP	:= "5.X"
	FLX->FLX_DT1	:= _aSaldos[1,10]
	FLX->FLX_DT2	:= _aSaldos[1,11]
	FLX->FLX_DT3	:= _aSaldos[1,12]
	FLX->FLX_DT4	:= _aSaldos[1,13]
	FLX->FLX_DT5	:= _aSaldos[1,14]
	MsUnLock()

	/*--------------------------------------------------------------------------------------------------------------
	FIM - Bloco para calcular o Saldo Parcial Caixa - D
	--------------------------------------------------------------------------------------------------------------*/
EndIf

If _nxOpc == 2
	DbSelectArea("FLX")
	DbGotop()
	ProcRegua(RecCount())
	Do While !EOF()
		IncProc("Gravando registros Orçamento x Fluxo...")
		DbSelectArea("ORC")

		Do Case
			Case mv_par02 == 1
				_nVal 	:= FLX->FLX_VL1
				_dDat	:= FLX->FLX_DT1
			Case mv_par02 == 2
				_nVal 	:= FLX->FLX_VL1+FLX->FLX_VL2
				_dDat	:= FLX->FLX_DT2
			Case mv_par02 == 3
				_nVal 	:= FLX->FLX_VL1+FLX->FLX_VL2+FLX->FLX_VL3
				_dDat	:= FLX->FLX_DT3
			Case mv_par02 == 4
				_nVal 	:= FLX->FLX_VL1+FLX->FLX_VL2+FLX->FLX_VL3+FLX->FLX_VL4
				_dDat	:= FLX->FLX_DT4
			Case mv_par02 == 5
				_nVal 	:= FLX->FLX_VL1+FLX->FLX_VL2+FLX->FLX_VL3+FLX->FLX_VL4+FLX->FLX_VL5
				_dDat	:= FLX->FLX_DT5
		EndCase

		If ALLTRIM(FLX->FLX_SUPORC) == "2.05" //Natureza grupo DESCONTO
			DbSelectArea("FLX")
			FLX->(DbSkip())
		EndIf

		DbSelectArea("SED")
		DbSetOrder(1)
	    If DbSeek(xFilial("SED")+SUBSTR(FLX->FLX_NATU,1,4))
//	    	_cDescNat	:= SED->ED_DESCRIC
	    	_cDescNat	:= SED->ED_DESORC
	    Else
	    	_cDescNat	:= ""
	    EndIf

		DbSelectArea("ORC")
		If DbSeek(FLX->FLX_SUPORC)
			RecLock("ORC",.F.)
			ORC->ORC_DESC	:= _cDescNat
			ORC->ORC_VL02	+= _nVal
			MsUnLock()
		Else
			RecLock("ORC",.T.)
			ORC->ORC_NATU 	:= FLX->FLX_NATU
			ORC->ORC_DESC	:= _cDescNat
			ORC->ORC_SUP 	:= FLX->FLX_SUP
			ORC->ORC_SUPORC	:= FLX->FLX_SUPORC
			ORC->ORC_GRP 	:= FLX->FLX_GRP
			ORC->ORC_VL02	:= _nVal
			ORC->ORC_DT		:= _dDat
			MsUnLock()
		EndIf
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
		ORC->ORC_DT		:= iif(_dDat==NIL,CTOD("  /  /  "),_dDat)
		MsUnLock()
	EndIF
EndIF

ORC->(DbCloseArea())
FLX->(DbCloseArea())

if _nxOpc == 1
	CALLCRYS("CRY053", cParams, cOpcoes)
ElseIf _nxOpc == 2
	CALLCRYS("CRY054", cParams, cOpcoes)
EndIF

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
			If !(_cDia == 1 .or. _cDia == 6 .or. _cDia == 7) // 1-Domingo --- 6-Sexta --- 7-Sabado
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

cPerg := Left(cPerg,6)

/*
             grupo ,ordem ,pergunt                ,perg spa ,perg eng , variav ,tipo,tam,dec,pres,gsc,valid ,var01     ,def01     ,defspa01,defeng01,cnt01 ,var02,def02      ,defspa02,defeng02,cnt02   ,var03,def03      ,defspa03,defeng03,cnt03  ,var04,def04     ,defspa04,defeng04,cnt04,var05,def05      ,defspa05,defeng05,cnt05,f3 ,pyme,grp,help,picture
*/
aAdd(aRegs,{cPerg  ,"01" ,"Mes/Ano Referencia"   ,""       ,""       ,"mv_ch1","C" ,07 ,00 ,0  ,"G",""    ,"mv_par01",""        ,""      ,""      ,""    ,""   ,""        ,""      ,""      ,""       ,""   ,""        ,""      ,""     ,""     ,""   ,""        ,""      ,""      ,""   ,""   ,""         ,""      ,""     ,""   ,"" ,""  ,"" ,""  ,"@E 99/9999"})
If _nxOpc == 2
	aAdd(aRegs,{cPerg  ,"02" ,"Semana"               ,""       ,""       ,"mv_ch2","C" ,01 ,00 ,0  ,"C",""    ,"mv_par02","1 Semana",""      ,""      ,""    ,""   ,"2 Semana",""      ,""      ,""       ,""   ,"3 Semana",""      ,""     ,""     ,""   ,"4 Semana",""      ,""      ,""   ,""   ,"5 Semana" ,""      ,""     ,""   ,"" ,""  ,"" ,""  ,""})
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