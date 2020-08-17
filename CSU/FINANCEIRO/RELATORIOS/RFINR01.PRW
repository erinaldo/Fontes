#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณ RFINR01 ณ Autor ณ Daniel G.Jr. TI1239   ณ Data ณ 15/03/07 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Emite Relat๓rio de NFs Emitidas/Gera planilha              ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso		 ณ Especifico CSU                			  				  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤมฤฤฤยฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function RFINR01()

private cPerg     := PADR("RFIR10",LEN(SX1->X1_GRUPO))
private nomeprog  := "RFINR01"
private lweb      := IsBlind()
private lPrimVez  := .t.
Private oPrn

//Fontes Arial
Private oFont1 := TFont():New( "Arial",,10,,.t.,,,,,.f. )
Private oFont3 := TFont():New( "Arial",,12,,.t.,,,,,.f. )

//Fontes Courier New (para campos numericos)
Private oFont1c := TFont():New( "Courier New",,10,,.t.,,,,,.f. )
Private oFont9c := TFont():New( "Courier New",,8,,.f.,,,,,.f. )

ValidPerg()
Pergunte(cPerg,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณ Variaveis utilizadas para parametros
//ณ mv_par01	Dt.Emissao   de  ?
//ณ mv_par02	Dt.Emissao   at้ ?
//ณ mv_par03	Cod.Cliente  de  ?
//ณ mv_par04	Cod.Cliente  at้ ?
//ณ mv_par05	Loja         de  ?             
//ณ mv_par06	Loja         at้ ?
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ

@ 200,1 TO 380,380 DIALOG o_dlg TITLE OemToAnsi("NFs Emitidas")
@ 02,10 TO 080,180
@ 10,018 Say OemToAnsi("Esta rotina gera planilha com a rela็ใo de")
@ 18,018 Say OemToAnsi("Notas Fiscais Emitidas")
@ 26,018 Say OemToAnsi("")
@ 34,018 Say OemToAnsi("")
@ 65,038 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)
@ 65,068 BMPBUTTON TYPE 01 ACTION OkProc()
@ 65,098 BMPBUTTON TYPE 02 ACTION Close(o_dlg)
@ 65,128 BMPBUTTON TYPE 07 ACTION oPrn:=Setup()
Activate Dialog o_dlg Centered

if Select( "TRB" ) > 0
	dbSelectArea( "TRB" )
	dbCloseArea()
endif

MS_FLUSH()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ OkProc   บAutor  ณMicrosiga           บ Data ณ  07/03/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function OkProc()

Private aCampos:={}
Private _cArqTMP:="", _cArqORD1:=""

aAdd(aCampos, { "DTEMIS" ,"D",008,0 } )
aAdd(aCampos, { "CODCLI" ,"C",TamSX3("E1_CLIENTE")[1], TamSX3("E1_CLIENTE")[2] } )
aAdd(aCampos, { "LOJA"   ,"C",TamSX3("E1_LOJA")[1]   , TamSX3("E1_LOJA")[2]    } )
aAdd(aCampos, { "DOC"    ,"C",TamSX3("E1_NUM")[1]    , TamSX3("E1_NUM")[2]     } )
aAdd(aCampos, { "RAZSOC" ,"C",TamSX3("A1_NOME")[1]   , TamSX3("A1_NOME")[2]    } )
aAdd(aCampos, { "VALOR"  ,"N",TamSX3("E1_VALOR")[1]  , TamSX3("E1_VALOR")[2]   } )
aAdd(aCampos, { "IR"     ,"N",TamSX3("E1_IRRF")[1]   , TamSX3("E1_IRRF")[2]    } )
aAdd(aCampos, { "PIS"    ,"N",TamSX3("E1_PIS")[1]    , TamSX3("E1_PIS")[2]     } )
aAdd(aCampos, { "COFINS" ,"N",TamSX3("E1_COFINS")[1] , TamSX3("E1_COFINS")[2]  } )
aAdd(aCampos, { "CSLL"   ,"N",TamSX3("E1_CSLL")[1]   , TamSX3("E1_CSLL")[2]    } )
_cArqTMP := CriaTrab(aCampos,.T.)
If Select("TMP")>0
	dbSelectArea("TMP")
	TMP->(dbCloseArea())
EndIf
DbUseArea( .T.,, _cArqTMP, "TMP", if(.F. .OR. .F., !.F., NIL), .F. )
_cArqORD1 := CriaTrab(Nil,.F.)
IndRegua("TMP",_cArqORD1,"RAZSOC+DtoS(DTEMIS)",,,"Selecionando Registros...")
SET INDEX TO &_cArqORD1

bProcessa := { |lFim| ProcRelato(@lFim) }
cTitulo   := "Processamento do Demonstrativo"
cMsg      := "Processando dados para a Planilha... Aguarde..."
lAborta   := .T.
Processa( bProcessa, cTitulo, cMsg, lAborta )

bProcessa := { |lFim| GeraPlani(@lFim) }
cTitulo   := "Gera็ใo das Planilhas"
cMsg      := "Gerando planilha... Aguarde..."
lAborta   := .T.
Processa( bProcessa, cTitulo, cMsg, lAborta )

If Select("TMP")>0
	TMP->(dbCloseArea())
EndIf
If File(_cArqTMP+GetDbExtension())
	Ferase(_cArqTmp+GetDbExtension())
EndIf
If File(_cArqORD1+OrdBagExt())
	Ferase(_cArqORD1+OrdBagExt())
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno	 ณPROCRELATOณ Autor ณ Daniel G.Jr.TI1239    ณ Data ณ 07/03/07 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณ Armazenamento e Tratamento dos dados 					  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ Especifico Academico              				          ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ProcRelato(lFim)

Local cQuery	:= ""

cQuery := "SELECT SE1.E1_EMISSAO DTEMIS, SE1.E1_CLIENTE CODCLI, SE1.E1_LOJA LOJA, SE1.E1_NUM DOC "
cQuery +=      " ,CASE SE1.E1_RSOCIAL "
cQuery +=         " WHEN ' ' THEN (SELECT SA1.A1_NOME FROM "+RetSqlName("SA1")+" SA1 "
cQuery +=                         " WHERE SA1.D_E_L_E_T_<>'*' "
cQuery +=		                    " AND SA1.A1_COD=E1_CLIENTE "
cQuery +=		                    " AND SA1.A1_LOJA=E1_LOJA) "
cQuery +=         " ELSE SE1.E1_RSOCIAL "
cQuery +=       " END RAZSOC, "
cQuery +=       " SUM(SE1.E1_VALOR) VALOR, SUM(E1_IRRF) IR, SUM(E1_PIS) PIS, SUM(E1_COFINS) COFINS, SUM(E1_CSLL) CSLL "
cQuery +=  " FROM "+RetSqlName("SE1")+" SE1 "
cQuery += " WHERE SE1.D_E_L_E_T_<>'*' "
cQuery +=   " AND E1_EMISSAO BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' "
cQuery +=	" AND E1_CLIENTE BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cQuery +=	" AND E1_LOJA    BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
cQuery +=   " AND E1_TIPO='NF' " 
cQuery += "GROUP BY SE1.E1_EMISSAO, E1_CLIENTE, E1_LOJA, E1_NUM, E1_RSOCIAL "

cQuery += "UNION "

cQuery += "SELECT F2_EMISSAO DTEMIS, F2_CLIENTE CODCLI, F2_LOJA LOJA, F2_DOC DOC, SA1B.A1_NOME RAZSOC, "
cQuery +=       " F2_VALBRUT VALOR, F2_VALIRRF IR, F2_VALPIS PIS, F2_VALCOFI COFINS, F2_VALCSLL CSLL "
cQuery +=  " FROM "+RetSqlName("SF2")+" SF2, "+RetSqlName("SA1")+" SA1B "
cQuery += " WHERE SF2.D_E_L_E_T_<>'*' AND SA1B.D_E_L_E_T_<>'*' "
cQuery +=   " AND F2_EMISSAO BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' "
cQuery +=	" AND F2_CLIENTE BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cQuery +=	" AND F2_LOJA    BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
cQuery +=   " AND F2_PREFIXO<>' ' "
cQuery +=   " AND F2_CLIENTE+F2_LOJA+F2_DOC+F2_EMISSAO NOT IN "
cQuery +=       "(SELECT E1_CLIENTE+E1_LOJA+E1_NUM+E1_EMISSAO "
cQuery +=         " FROM "+RetSqlName("SE1")+" SE1B "
cQuery +=        " WHERE SE1B.D_E_L_E_T_<>'*' "
cQuery +=          " AND SE1B.E1_EMISSAO BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' "
cQuery +=          " AND SE1B.E1_TIPO='NF') "
cQuery += 		   " AND A1_COD=F2_CLIENTE "
cQuery +=		   " AND A1_LOJA=F2_LOJA "

cQuery += "ORDER BY DTEMIS, CODCLI, LOJA "

//Memowrite("C:\RACAR010.sql",cQuery)

cQuery := ChangeQuery(cQuery)

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB", .F., .T.)

dbSelectArea("TRB")
TRB->(dbGoTop())
While TRB->(!Eof())
	dbSelectArea("TMP")
	RecLock("TMP",.T.)
	TMP->DTEMIS	:= StoD(TRB->DTEMIS)
	TMP->CODCLI	:= TRB->CODCLI
	TMP->LOJA	:= TRB->LOJA
	TMP->DOC	:= TRB->DOC
	TMP->RAZSOC	:= TRB->RAZSOC
	TMP->VALOR	:= TRB->VALOR
	TMP->IR		:= TRB->IR
	TMP->PIS	:= TRB->PIS
	TMP->COFINS	:= TRB->COFINS
	TMP->CSLL	:= TRB->CSLL
	TMP->(MsUnLock())
	TRB->(dbSkip())
End	
   
TRB->(dbCloseArea())

//__CopyFile(_cArqTmp+GetDbExtension(),"C:\DEMRECEITAS.DBF")

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o	 ณGERAPLANI ณ Autor ณ Daniel G.Jr.TI1239    ณ Data ณ 15/01/02 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Gera arquivos do tipo Excel (.xls)						  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso 	 ณ PADRAO												      ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GeraPlani(lFim)

Local cArq := CriaTrab(,.F.)
Local cPath := cGetFile("",OemtoAnsi( "Local para grava็ใo..."),1,,.F.,GETF_LOCALHARD + GETF_LOCALFLOPPY+GETF_NETWORKDRIVE+GETF_RETDIRECTORY )
Local _cCodCurso, _cPerLet, _nI:=0
Local _cPeriodos, _lCont:=.T.

dbSelectArea("TMP")
SET ORDER TO 1
TMP->(dbGoTop())

count to nCount

TMP->(dbGoTop())

if nCount == 0
	MsgAlert("Nใo hแ registros a serem processados!","Aten็ใo")
	Return
endif

cArqPesq := Upper(cPath + "Impostos2007.xls")

If File(cArqPesq)
	FErase(cArqPesq)
EndIf

ProcRegua(nCount)
cTabela := "<table border=1>"
cTabela += "<font face='Arial'>"
cTabela += "<tr><td>Dt.Emissใo</td><td>Cod.Cliente</td><td>Loja</td><td>Nome</td><td>Nr.Docto.</td>"
cTabela += "<td>Valor</td><td>IR</td><td>PIS</td><td>COFINS</td><td>CSLL</td>"
While TMP->(!Eof())
	
	IncProc()
	
	cTabela += "<tr><td>'"+DtoC(TMP->DTEMIS)+"</td>"
	cTabela += "<td>'"+TMP->CODCLI+"</td>"
	cTabela += "<td>'"+TMP->LOJA+"</td>"
	cTabela += "<td>"+TMP->RAZSOC+"</td>"
	cTabela += "<td>'"+TMP->DOC+"</td>"
	cTabela += "<td>"+TransForm(TMP->VALOR ,"@E 999999999.99")+"</td>"
	cTabela += "<td>"+TransForm(TMP->IR    ,"@E 999999999.99")+"</td>"
	cTabela += "<td>"+TransForm(TMP->PIS   ,"@E 999999999.99")+"</td>"
	cTabela += "<td>"+TransForm(TMP->COFINS,"@E 999999999.99")+"</td>"
	cTabela += "<td>"+TransForm(TMP->CSLL  ,"@E 999999999.99")+"</td>"
	cTabela += "</tr>"
	
	// Grava linha a linha no arquivo XLS
	xAddToFile( cTabela, cArqPesq )
	cTabela:=""                            
	
	TMP->(dbSkip())
	
End

cTabela += "</font>"
cTabela += "</table>"

// Grava linha a linha no arquivo XLS
xAddToFile( cTabela, cArqPesq )

If MsgYesNo(cArqPesq+". "+OemtoAnsi("O arquivo foi gerado no diret๓rio ")+Chr(10)+OemToAnsi("Exibe a planilha agora?"))
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Abre Excel                                                                       	ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If ApOleClient( 'MsExcel' )
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( cArqPesq ) // Abre uma planilha
		oExcelApp:SetVisible(.T.)
	Else
		Alert(OemtoAnsi( "Microsoft Excel nao encontrado !" ))
	EndIf
Endif

TMP->( dbCloseArea() )

If File(cArq)
	Ferase(cArq)
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxAddToFileบAutor  ณRafael Rodrigues    บ Data ณ  14/03/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAdiciona a linha de log ao fim de um arquivo.               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function xAddToFile( cLog, cToFile )
local nHdl	:= -1
local cBuff	:= cLog

if File( cToFile )
	nHdl := FOpen( cToFile, 1 )
	if nHdl >= 0
		FSeek( nHdl, 0, 2 )
	endif
else
	nHdl := FCreate( cToFile )
endif

if nHdl >= 0
	FWrite( nHdl,  cBuff, Len( cBuff ) )
endif

FClose( nHdl )

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณVALIDPERG บ Autor ณ AP5 IDE            บ Data ณ  16/08/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Verifica a existencia das perguntas criando-as caso seja   บฑฑ
ฑฑบ          ณ necessario (caso nao existam).                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function ValidPerg()

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,LEN(SX1->X1_GRUPO))

aAdd(aRegs,{cPerg,"01","Dt.Emissใo de    ?"		,""	,"" ,"mv_ch1","D",6,0,0,"G",""			  ,"MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"",""})
aAdd(aRegs,{cPerg,"02","Dt.Emissao at้   ?"		,""	,"" ,"mv_ch2","D",6,0,0,"G",""			  ,"MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"",""})
aAdd(aRegs,{cPerg,"03","Cod.Cliente de   ?"		,"" ,"" ,"mv_ch3","C",6,0,0,"G",""			  ,"MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","SA1","",""})
aAdd(aRegs,{cPerg,"04","Cod.Cliente at้  ?"		,"" ,"" ,"mv_ch4","C",6,0,0,"G",""			  ,"MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","SA1","",""})
aAdd(aRegs,{cPerg,"05","Loja de          ?"    	,"" ,"" ,"mv_ch5","C",2,0,0,"G",""            ,"MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"",""})
aAdd(aRegs,{cPerg,"06","Loja at้         ?"		,"" ,"" ,"mv_ch6","C",2,0,0,"G",""			  ,"MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return
