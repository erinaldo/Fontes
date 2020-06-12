#include "rwmake.ch"
#include "TOPCONN.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFINA70   ºAutor  ³Emerson Natali      º Data ³  31/05/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Contabilizacao Provisao/ Estorno Contas de Consumo         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CFINA70()

Private cPerg := "CFINA70   "
Private _cGrupo
Private _nTotGrp
Private aProvisao	:= {}
Private aEstorno	:= {}

_fCriaSX1()

If !(pergunte(cPerg,.T.))
	Return
Else
	Processa({|| RunCont() },"Processando...")
EndIf

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFINA70   ºAutor  ³Microsiga           º Data ³  05/31/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RunCont()

cMes		:= Val(Substr(mv_par01,1,2))
cAno		:= Val(Substr(mv_par01,4,4))

_DtIni		:= DTOS(FirstDay(ctod("01/"+Str(cMes,2)+"/"+Str(cAno,4))))
_DtFim		:= DTOS(LastDay(ctod("01/"+Str(cMes,2)+"/"+Str(cAno,4))))

//PROVISAO
_cMesCont	:= cMes//+1 //Tirado a soma do mes devido solicitacao do usuario, pois a provisao se refere ao movimento do mes anterior. Alteracao realizada dia 16/06/11 pelo analista Emerson Natali
_cAnoCont	:= cAno
_cMesCont	:= iif( _cMesCont >=13 , 01          , _cMesCont)
_cAnoCont	:= iif( _cMesCont >=13 , _cAnoCont+1 , _cAnoCont)
 // Data da Contabilizacao da PROVISAO. Ultimo dia Util
_DtCont		:= DataValida(LastDay(ctod("01/"+Str(_cMesCont,2)+"/"+Str(_cAnoCont,4))),.F.)//O parametro .F. (sexta-feira quando o dia for sabado/domingo/feriado)

//ESTORNO
_cProxMesUtil	:= _cMesCont+1
_cProxAnoUtil	:= _cAnoCont
_cProxMesUtil	:= iif( _cProxMesUtil >=13 , 01          , _cProxMesUtil)
_cProxAnoUtil	:= iif( _cProxMesUtil >=13 , _cAnoCont+1 , _cProxAnoUtil)
 // Data da Contabilizacao do Estorno. Primeiro dia Util com base da data da Contabilizacao.
_ProxDiaUtil	:= DataValida(FirstDay(ctod("01/"+Str(_cProxMesUtil,2)+"/"+Str(_cProxAnoUtil,4))),.T.) //O parametro .T. (segunda-feira quando o dia for sabado/domingo/feriado)


If fVerifCont(_DtCont,_ProxDiaUtil) //testar
	Return
EndIf

cQuery := " SELECT * "
cQuery += " FROM "
cQuery += RetSqlName("SZ5")+" SZ5,"
cQuery += RetSqlName("SZ7")+" SZ7 "
cQuery += " WHERE '"+ xFilial("SZ5") +"' = Z5_FILIAL"
cQuery += " AND   '"+ xFilial("SZ7") +"' = Z7_FILIAL"   
cQuery += " AND    SZ5.D_E_L_E_T_ <> '*'"
cQuery += " AND    SZ7.D_E_L_E_T_ <> '*'"
cQuery += " AND    Z5_PRESTA   = Z7_PRESTA"
cQuery += " AND    Z5_LANC BETWEEN '"+_DtIni+"' AND '"+_DtFim+"'"
cQuery += " AND    Z5_UNIDADE <> 'SAO PAULO' "
cQuery += " AND    Z7_GRUPO IN('A','C','D','F') "
cQuery += " ORDER BY Z7_GRUPO, Z7_DESCGR, Z5_CR, Z5_UNIDADE, Z5_LANC"

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TEMP',.T.,.T.)

//TCQUERY cQuery NEW ALIAS "TEMP"

TcSetField("TEMP","Z5_LANC","D",8, 0 )		

dbSelectArea("TEMP")
dbGoTop()
ProcRegua(RecCount())

_cGrupo_CR	:= TEMP->Z7_GRUPO+TEMP->Z5_CR
_cGrupo		:= TEMP->Z7_GRUPO
_nValor		:= TEMP->Z5_VALOR
_cCr		:= TEMP->Z5_CR
_cHist		:= alltrim(TEMP->Z7_DESCGR)
_nTotGrp	:= 0

Do While !EOF()

	IncProc("Processando.... ")

	If _cGrupo_CR <> TEMP->Z7_GRUPO+TEMP->Z5_CR
		Do Case
			Case _cGrupo = "A"	//TELEFONE FIXO
				_cDebito	:= "31805" 		//provisao
				_cCredito	:= "2121111"	//provisao
				_cDebEst	:= "2121111"	//estorno
				_cCredEst	:= "31805"		//estorno
			Case _cGrupo = "C"	//TELEFONE CELULAR
				_cDebito	:= "31808"		//provisao
				_cCredito	:= "2121111"	//provisao
				_cDebEst	:= "2121111"	//estorno
				_cCredEst	:= "31808"		//estorno
			Case _cGrupo = "D"	//ENERGIA ELETRICA
				_cDebito	:= "31803" 		//provisao
				_cCredito	:= "2120411"	//provisao
				_cDebEst	:= "2120411"	//estorno
				_cCredEst	:= "31803"		//estorno
			Case _cGrupo = "F"	//AGUA
				_cDebito	:= "31801" 		//provisao
				_cCredito	:= "2120511"	//provisao
				_cDebEst	:= "2120511"	//estorno
				_cCredEst	:= "31801" 		//estorno
		EndCase
		//              data        , debito   , credito , valor   , cr  , hist                                                             , cod hist, grupo
		aadd(aProvisao,{_DtCont     , _cDebito,_cCredito, _nTotGrp, _cCr,_cHist +" "+ alltrim(Str(cMes))+"/"+alltrim(Str(cAno))           , "755"  ,_cGrupo })
		aadd(aEstorno, {_ProxDiaUtil, _cDebEst,_cCredEst, _nTotGrp, _cCr,"EST. "+_cHist +" "+ alltrim(Str(cMes))+"/"+alltrim(Str(cAno)), "751"  ,_cGrupo })
		
		_cGrupo_CR	:= TEMP->Z7_GRUPO+TEMP->Z5_CR
		_nTotGrp	:= 0
	EndIf

	If _cGrupo <> TEMP->Z7_GRUPO
		_cGrupo		:= TEMP->Z7_GRUPO

		GeraLacto(aProvisao)
		GeraLacto(aEstorno)
		aProvisao	:= {}
		aEstorno	:= {}
	EndIf

	_cGrupo		:= TEMP->Z7_GRUPO
	_nValor		:= TEMP->Z5_VALOR
	_cCr		:= TEMP->Z5_CR
	_cHist		:= alltrim(TEMP->Z7_DESCGR)
	_nTotGrp 	+= TEMP->Z5_VALOR

	DbSelectArea("TEMP")
	TEMP->(DbSkip())
EndDo

DbSelectArea("TEMP")
TEMP->(DbCloseArea())

//Ultimo Registro
//              data        , debito   , credito , valor   , cr  , hist                                                             , cod hist , grupo
aadd(aProvisao,{_DtCont     , _cDebito,_cCredito, _nTotGrp, _cCr,_cHist +" "+ alltrim(Str(cMes))+"/"+alltrim(Str(cAno))           , "755"   ,_cGrupo })
aadd(aEstorno, {_ProxDiaUtil, _cDebEst,_cCredEst, _nTotGrp, _cCr,"EST. "+_cHist +" "+ alltrim(Str(cMes))+"/"+alltrim(Str(cAno)), "751"   ,_cGrupo })

GeraLacto(aProvisao)
GeraLacto(aEstorno)

aProvisao	:= {}
aEstorno	:= {}

MsgBox(OemToAnsi("Contabilização dos Lançamentos Efetuados!!!"), OemToAnsi("Contabilização"), "INFO")

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFINA70   ºAutor  ³Microsiga           º Data ³  06/06/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fVerifCont(_DtCont,_ProxDiaUtil)

cQuery := "SELECT CT2_DATA, CT2_LOTE, CT2_TPSALD "
cQuery += "FROM "
cQuery += RetSqlName("CT2")+" CT2 "
cQuery += "WHERE '"+ xFilial("CT2") +"' = CT2_FILIAL "
cQuery += "AND CT2.D_E_L_E_T_ = '' "
cQuery += "AND CT2.CT2_LOTE = '009300' "
cQuery += "AND (CT2.CT2_DATA = '"+DTOS(_DtCont)+"' OR CT2.CT2_DATA = '"+DTOS(_ProxDiaUtil)+"') "
cQuery += "GROUP BY CT2_DATA, CT2_LOTE, CT2_TPSALD "
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.T.,.T.)

DbSelectArea("TRB")
dbGoTop()

_lRetEfe	:= "V" //E-Efetivado; N-Nao Efetivado; V-Query Vazia.Novo Lancamento
_lRet		:= .F.

Do While !EOF()
	If TRB->CT2_TPSALD == "1" //Efetiva
		_lRetEfe	:= "E"
		Exit
	ElseIf TRB->CT2_TPSALD == "9" //Nao Efetivado
		_lRetEfe	:= "N"
	EndIf
	DbSelectArea("TRB")
	TRB->(DbSkip())
EndDo

If _lRetEfe == "E"
	MsgBox(OemToAnsi("Lançamento Contábil Provisão/Estorno já Efetivado!!!"), OemToAnsi("Contabilização"), "INFO")
	_lRet	:= .T.
	Return(_lRet)
ElseIf _lRetEfe == "N"
   _cQuery := " DELETE FROM "+RetSqlName("CT2")+" WHERE CT2_LOTE = '009300' AND (CT2_DATA = '"+DTOS(_DtCont)+"' OR CT2_DATA = '"+DTOS(_ProxDiaUtil)+"') "
   TCSQLEXEC(_cQuery)
EndIf

DbSelectArea("TRB")
TRB->(DbCloseArea())

Return(_lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CFINA70   ºAutor  ³Microsiga           º Data ³  05/31/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GeraLacto(aMatriz)

Local nDecs			:=	TamSX3('CT2_VALOR')[2]
Local nX			:=	1
Local nBase			:=	1
Local nMaxLanc		:=	99
Local aCab			:= {}
Local aItem			:= {}
Local aTotItem 		:= {}
Local dDataLanc 	:= CTOD("") 

Private lMsErroAuto := .F.
Private _cLoteCie	:= ALLTRIM(GETMV("CI_LOTEPRV"))  // Lote Determinado pelo usuario no parametro
Private _cSubLCie 	:= "001"

_dDtLancto	:= aMatriz[1,1] //Primeiro parametro do Array com a Data. Hora Provisao (_DtCont) Hora Estorno (1 Dia util do proximo mes)

aCab := {;
		{"dDataLanc", _dDtLancto,NIL},;
		{"cLote"	, _cLoteCie ,NIL},;
		{"cSubLote"	, _cSubLCie ,NIL}}

_cLinCie := 1

For _nI	:= 1 to Len(aMatriz)

	AADD(aItem,{	{"CT2_FILIAL"	, xFilial("CT2")								, NIL},;
					{"CT2_LINHA"	, StrZero(_cLinCie,3)							, NIL},;
					{"CT2_DC"		, "3"	 										, NIL},;
					{"CT2_ITEMD"	, aMatriz[_nI,2]								, NIL},;
					{"CT2_ITEMC"	, aMatriz[_nI,3]								, NIL},;
					{"CT2_CCD"		, IIF(aMatriz[_nI,7]=="755",aMatriz[_nI,5],"")	, NIL},;
					{"CT2_CCC"		, IIF(aMatriz[_nI,7]=="751",aMatriz[_nI,5],"")	, NIL},;
					{"CT2_DCD"		, "" 											, NIL},;
					{"CT2_DCC"		, "" 											, NIL},;
					{"CT2_VALOR"	, Round(aMatriz[_nI,4],nDecs)					, NIL},;
					{"CT2_HP"		, ""											, NIL},;
					{"CT2_HIST"		, aMatriz[_nI,6]	   							, NIL},;
					{"CT2_TPSALD"	, "9"											, NIL},;
					{"CT2_ORIGEM"	, aMatriz[_nI,7]+" "+aMatriz[_nI,6]			, NIL},;
					{"CT2_MOEDLC"	, "01"											, NIL},;
					{"CT2_EMPORI"	, Substr(cNumEmp,1,2)							, NIL},;
					{"CT2_ROTINA"	, "CFINA70"										, NIL},;
					{"CT2_LP"		, ""											, NIL},;
					{"CT2_KEY"		, ""											, NIL}})
	_cLinCie++
Next _nI

aadd(aTotItem,aItem)
MSExecAuto({|a,b,C| Ctba102(a,b,C)},aCab,aItem,3)
aTotItem	:=	{}
			
If lMsErroAuto
	DisarmTransaction()
	MostraErro()
	Return .F.
Endif
		
aCab	:= {}
aItem	:= {}

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SX1       ºAutor  ³Microsiga           º Data ³  08/03/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Parametros da rotina                                       º±±
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
             grupo ,ordem ,pergunt                ,perg spa ,perg eng , variav ,tipo,tam,dec,pres,gsc,valid ,var01     ,def01     ,defspa01,defeng01,cnt01 ,var02,def02      ,defspa02,defeng02,cnt02   ,var03,def03      ,defspa03,defeng03,cnt03  ,var04,def04     ,defspa04,defeng04,cnt04,var05,def05      ,defspa05,defeng05,cnt05,f3 ,pyme,grp,help ,picture
*/
aAdd(aRegs,{cPerg  ,"01" ,"Mes/Ano Referencia"   ,""       ,""       ,"mv_ch1","C" ,07 ,00 ,0  ,"G",""    ,"mv_par01",""        ,""      ,""      ,""    ,""   ,""        ,""      ,""      ,""       ,""   ,""        ,""      ,""     ,""     ,""   ,""        ,""      ,""      ,""   ,""   ,""         ,""      ,""     ,""   ,"" ,""  ,"" ,""  ,"@E 99/9999"})


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