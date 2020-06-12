#include "protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"
/*
+----------------------------------------------------------------------------+
!                         FICHA TECNICA DO PROGRAMA                          !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Tipo              ! Atualização                                             !
+------------------+---------------------------------------------------------+
!Modulo            ! PCP - PRODUÇÃO                                          !
+------------------+---------------------------------------------------------+
!Nome              ! ETQ011                                                  !
+------------------+---------------------------------------------------------+
!Descricao         ! Rotina Emissão etiqueta INGREDIENTES VERDES - MADERO    !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 20/05/18                                                !
+------------------+---------------------------------------------------------+
*/
User Function ETQ011(aEtqAuto)
Local  _aArea := GetArea()
Local  _cperg :="ETQ011    "
Local  _cOP:=""
Local  _nQtde:=0
Local  _cImp:=""
Local  _cPROD:=""
Local  _cTpEtq:="011" //Etiqueta INGREDIENTES VERDES
Local  _lret:=.T.
Local  _lrimp:=.F.
//
Private _cAliasSC2 := ""
//
DEFAULT aEtqAuto := NIL
//
AJUSTASX1()
//
If !aEtqAuto == NIL
	_COP    :=aETQAuto[1][1]
	_CPROD  :=aETQAuto[1][2]
	_CLOTE  :=aETQAuto[1][3]
	_nQtde  :=aEtqAuto[1][4]
	_cImp   :=aEtqAuto[1][5]
	_lRIMP  :=aEtqAuto[1][6]
	//EXECUTAR IMPRIME ETIQUETA
	//valida Ordem de Producao
Else
	IF Pergunte(_cPerg,.T.)
		_cOp  :=MV_PAR01
		_cProd:=MV_PAR02
		_clote:=MV_PAR03
		_nQtde:=MV_PAR04
		_cImp :=MV_PAR05
	ELSE
		_LRET:=.F.
	Endif
EndIf
//

IF _LRET
	IF (!EMPTY(_COP) .OR. (!EMPTY(_CPROD) .AND. !EMPTY(_CLOTE)))
		//
		_cAliasSC2 := GetNextAlias()
		_cLote:=strzero(val(_cLote),TamSX3("C2_XLOTE")[1])
		//
		cQuery := "SELECT * "
		cQuery += "FROM " + RETSQLNAME("SC2") + " SC2, " + RETSQLNAME("SB1") + " SB1 "
		cQuery += "LEFT JOIN " + RETSQLNAME("SB5") + " SB5 ON SB1.B1_COD = SB5.B5_COD "
		cQuery += "WHERE SC2.D_E_L_E_T_ = '' "
		cQuery += "AND SC2.C2_FILIAL = '" + xFilial("SC2") + "' "
		cQuery += "AND SB1.D_E_L_E_T_ = '' "
		cQuery += "AND SB1.B1_FILIAL = '" + xFilial("SB1") + "' "
		cQuery += "AND SC2.C2_PRODUTO = SB1.B1_COD "
		If !empty(_cop)
			cQuery += "AND SC2.C2_NUM = '" + substr(_cOP,1,TamSX3("C2_NUM")[1])    + "' "
			cQuery += "AND sc2.C2_ITEM= '" + substr(_cOP,TamSX3("C2_NUM")[1]+1,TamSX3("C2_ITEM")[1])    + "' "
			cQuery += "AND SC2.C2_SEQUEN = '" + substr(_cOP,TamSX3("C2_NUM")[1]+TamSX3("C2_ITEM")[1]+1,TamSX3("C2_SEQUEN")[1])+ "' "
		Else
			cQuery += "AND SC2.C2_PRODUTO = '" + _cPROD + "' "
			cQuery += "AND SC2.C2_XLOTE = '" + _cLOTE + "' "
		Endif
		
		If (Select(_cAliasSC2) <> 0)
			dbSelectArea(_cAliasSC2)
			dbCloseArea()
		EndIf
		
		cQuery := ChangeQuery(cQuery)
		
		TCQUERY cQuery NEW ALIAS &(_cAliasSC2)
		
		dbSelectArea(_cAliasSC2)
		(_cAliasSC2)->(dbGoTop())
		If (_cAliasSC2)->(Eof())
			MSGINFO("Ordem de Producao/Produto/Lote não Cadastrado !!!")
			_lret:=.F.
		Else
			DBSELECTAREA("ZIB")
			DBSETORDER(1)
			ZIB->(DBSEEK(XFILIAL("ZIB")+(_cAliasSC2)->B1_COD+_cTpEtq))
			IF !ZIB->(FOUND())
				MSGINFO("Etiqueta não Cadastrada para este Produto!!")
				_lret:=.F.
			ElseIf !_lRImp
				IF EMPTY(_nQtde)
					_nQtde:=(_cAliasSC2)->C2_QUANT
				Endif
				_nQtde:=_nQtde*ZIB->ZIB_QTDE
			EndIf
		EndIf
		//
	Else
		MSGINFO("Parametros Invalido para Emissao de Etiqueta...Verifique!!")
	EndIf
EndIf

If _LRET
	fEtq011(_cop,_nqtde,_cImp)
Endif

RestArea(_aArea)

Return(nil)
//
*----------------------------------------*
Static Function fEtq011(_cop,_nqtde,_cimp)
*----------------------------------------*
Local _fim      := chr(13)+chr(10)
Local _n        :=0
Local _oFile    := Nil
Local _cSaida   := CriaTrab("",.F.)
Local _cPorta   := "LPT1"
Local _CDESC    :=IIF(Empty((_cAliasSC2)->B5_CEME),(_cAliasSC2)->B1_DESC,(_cAliasSC2)->B5_CEME )
Local _dPROD    :=DTOC(STOD((_cAliasSC2)->C2_XDTFIR))
Local _dVALID   :=DTOC(STOD((_cAliasSC2)->C2_XDTVAL))
Local _cINGRED  := "INGREDIENTES: " + ALLTRIM(MSMM((_cAliasSC2)->B1_CODPROC))
Local _CINFNUT  :=""+substr(ALLTRIM(POSICIONE("SB1",1,XFILIAL("SB1")+(_cAliasSC2)->B1_COD,"B1_XINFNUT")),1,800)
Local _cLOTE   := Alltrim(Str(Val((_cAliasSC2)->C2_XLOTE)))
Local _cCons   := ALLTRIM(POSICIONE("SX5",1,XFILIAL("SX5")+"W1"+(_cAliasSC2)->B1_XCONS,"X5_DESCRI"))
Local _cGluten  :=IIF((_cAliasSC2)->B1_XGLUT="1","CONTÉM GLUTEN",IIF((_cAliasSC2)->B1_XGLUT="2","NAO CONTÉM GLUTEN",""))
Local _cLactos := IIF((_cAliasSC2)->B1_XLACTOS="1","CONTÉM LACTOSE",IIF((_cAliasSC2)->B1_XLACTOS="2","NÃO CONTÉM LACTOSE",""))
Local _cPESO    :=STRZERO((_cAliasSC2)->B1_XPEMB,4)
Local _CSIF     :="Registro no Ministério da Agricultura SIF/DIPOA sob No." + ALLTRIM(POSICIONE("SB5",1,XFILIAL("SB5")+(_cAliasSC2)->B1_COD,"B5_DES"))
Local _cInfComp1:="DESTINADO EXCLUSIVAMENTE AO USO INSTITUCIONAL"
Local _cInfComp2:="PROIBIDA A VENDA NO VAREJO"
Local _cInfComp3:="PROIBIDA A VENDA FRACIONADA"
Local _cInfComp4:="INDUSTRIA BRASILEIRA"
Local _cInfComp5:="PRODUZIDO POR: " + alltrim(SM0->M0_NOMECOM)
Local _cInfComp6:="CNPJ "+Transform(SM0->M0_CGC,PesqPict("SA2","A2_CGC"))
Local _cInfComp7:=ALLTRIM(SM0->M0_ENDENT)+", "+ ALLTRIM(SM0->M0_BAIRENT)+", "+ alltrim(SM0->M0_CIDENT) + "/" + SM0->M0_ESTENT
Local _cInfComp8:="CEP: "+SM0->M0_CEPENT
Local _nY
//busca porta impressora
//
Local cModelo,lTipo,nPortIP,cServer,cEnv,cFila,lrvWin
Local cPorta :=Nil

If Empty(_CIMP)
	Return .f.
EndIf
//
If ! CB5->(DbSeek(xFilial("CB5")+_CIMP))
	Return .f.
EndIf
cModelo :=Trim(CB5->CB5_MODELO)
If cPorta ==NIL
	If CB5->CB5_TIPO == '4'
		cPorta:= "IP"
	Else
		IF CB5->CB5_PORTA $ "12345"
			cPorta  :='COM'+CB5->CB5_PORTA+':'+CB5->CB5_SETSER
		EndIf
		IF CB5->CB5_LPT $ "12345"
			cPorta  :='LPT'+CB5->CB5_LPT //+':'
		EndIf
	EndIf
EndIf
lTipo   :=CB5->CB5_TIPO $ '12'
nPortIP :=Val(CB5->CB5_PORTIP)
cServer :=Trim(CB5->CB5_SERVER)
cEnv    :=Trim(CB5->CB5_ENV)
cFila   := NIL

If CB5->CB5_TIPO=="3"
	cFila := Alltrim(Tabela("J3",CB5->CB5_FILA,.F.))
EndIf

nBuffer := CB5->CB5_BUFFER
lDrvWin := (CB5->CB5_DRVWIN =="1")

//
//
// TEXTO:={}
// //INICIO
// IF _CIMP="000001" .OR._CIMP="000002"
// 	aadd(texto,"^JMB^FS"+_fim)    
// ENDIF
// //DESCRIÇÃO PRODUTO
// aadd(texto,"^FO20,30^A0N,50,30^FD"+ALLTRIM(_CDESC)+"^FS"+_fim)
// //INGREDIENTES----------------------------------------------------------
// aadd(texto,"^CF0,020,100^FO15,20"+_fim)
// aadd(texto,"^FB650,5,,"+_fim)
// aadd(texto,"^FO020,100^A0N,15,20^FD"+substr(_CINGRED,1,300)+"^FS"+_fim)
// aadd(texto,"^FS"+_fim)
// //INFORMAÇOES NUTRICIONAIS--------------------------------------------------
// aadd(texto,"^CF0,020,180^FO15,20"+_fim)
// aadd(texto,"^FB650,4,,"+_fim)
// aadd(texto,"^FO020,180^A0N,15,20^FD"+substr(_CINFNUT,1,150)+"^FS"+_fim)
// aadd(texto,"^FS"+_fim)
// //aadd(texto,"^FO20,180^A0N,15,20^FD"+ALLTRIM(_CINFNUT)+"^FS"+_fim)
// //CONSERVAÇÃO---------------------------------------------------------
// aadd(texto,"^FO20,230^A0N,15,20^FDMODO CONSERVACAO: "+ALLTRIM(_cCONS)+"^FS"+_fim)
// //FABRICAÇÃO-------------------------------------------------------------
// aadd(texto,"^FO20,255^A0N,25,25^FDDATA FABRICACAO: "+_dProd+"^FS"+_fim)
// //VALIDADE---------------------------------------------------------------
// aadd(texto,"^FO20,280^A0N,25,25^FDDATA VALIDADE: "+_dVALID+"^FS"+_fim)
// //LOTE-------------------------------------------------------------------
// aadd(texto,"^FO370,265^A0N,45,45^FDLOTE:"+_CLOTE+"^FS"+_fim)
// //INFORMAÇÕES COMPLEMENTARES----------------------------------------------
// aadd(texto,"^FO155,310^A0N,15,20^FD"+ALLTRIM(_CINFCOMP1)+"^FS"+_fim)
// aadd(texto,"^FO255,325^A0N,15,20^FD"+ALLTRIM(_CINFCOMP2)+"^FS"+_fim)   
// aadd(texto,"^FO250,340^A0N,15,20^FD"+ALLTRIM(_CINFCOMP3)+"^FS"+_fim)
// aadd(texto,"^FO270,355^A0N,15,20^FD"+ALLTRIM(_CINFCOMP4)+"^FS"+_fim)
// aadd(texto,"^FO150,370^A0N,15,20^FD"+ALLTRIM(_CINFCOMP5)+"^FS"+_fim)
// aadd(texto,"^FO275,385^A0N,15,20^FD"+ALLTRIM(_CINFCOMP6)+"^FS"+_fim)
// aadd(texto,"^FO195,400^A0N,15,20^FD"+ALLTRIM(_CINFCOMP7)+"^FS"+_fim)
// aadd(texto,"^FO315,415^A0N,15,20^FD"+ALLTRIM(_CINFCOMP8)+"^FS"+_fim)
// //
MSCBPRINTER(cModelo,cPorta,,,lTipo,nPortIP,cServer,cEnv,nBuffer,cFila,lDrvWin,Trim(CB5->CB5_PATH)+"\ETQ011")
MSCBCHKSTATUS(CB5->CB5_VERSTA =="1")

MSCBLOADGRF("\images\logoetiqueta.bmp")
MSCBBEGIN(_nQtde,6)

// For _nY := 1 To Len(texto)
// 	MSCBWRITE(texto[_nY])
// Next _nY

	MSCBGRAFIC(17,48,"logoetiqueta")
	cProd := ALLTRIM(_CDESC)//SUBSTR(ALLTRIM(_CDESC),1,35)
    cTamFontIn := 4
    nLeft   := 17
    nRight  := 75
    nTop    := 48.5
    nBottom := 35.5
    If (Len(cProd)*cTamFontIn) > nRight - nLeft
        nTamMax := (nRight - nLeft)/(cTamFontIn*0.6)
        nLin    := mlcount(cProd,nTamMax)
        nPos := nTop -1
        nPosIni := nPos
        For _nY := 1 to nLin
            nPos := (nPos - (nPosIni - nBottom)/nLin)
            If nPos == nBottom
                MSCBSAY(nLeft,nPos,memoline(cProd,nTamMax,_nY)     ,"N",cValToChar(cTamFontIn),"1,1")     //Subtitulo
            Else
                MSCBSAY(nLeft,nPos,memoline(cProd,nTamMax,_nY)     ,"N",cValToChar(cTamFontIn),"1,1")     //Subtitulo
            EndIf
        Next
    Else
        nPos := nTop - 1
        MSCBSAY(nLeft,nPos,cProd    ,"N",cValToChar(cTamFontIn),"1,1")     //Subtitulo
    EndIf
	//MSCBSAY(17,40,ALLTRIM(_CDESC),"N","4","1,1")


    cIngr := ALLTRIM(_CINGRED)
    cTamFontIn := 1
    nLeft   := 17
    nRight  := 80
    nTop    := 36.5
    nBottom := 28.5
    If (Len(cIngr)*cTamFontIn) > nRight - nLeft
        nTamMax := (nRight - nLeft)/(cTamFontIn*1.2)
        nLin    := mlcount(cIngr,nTamMax)
        nPos := nTop -1
        nPosIni := nPos
        For _nY := 1 to nLin
            nPos := (nPos - (nPosIni - nBottom)/nLin)
            If nPos == nBottom
                MSCBSAY(nLeft,nPos,memoline(cIngr,nTamMax,_nY)     ,"N",cValToChar(cTamFontIn),"1,1")     //Subtitulo
            Else
                MSCBSAY(nLeft,nPos,memoline(cIngr,nTamMax,_nY)     ,"N",cValToChar(cTamFontIn),"1,1")     //Subtitulo
            EndIf
        Next
    Else
        nPos := nTop - 1
        MSCBSAY(nLeft,nPos,cIngr    ,"N",cValToChar(cTamFontIn),"1,1")     //Subtitulo
    EndIf


    

    MSCBSAY(17,25.5,"MODO DE CONSERVACAO: ","N","1","1,1")
    MSCBSAY(42,25.5,ALLTRIM(_cCONS),"N","1","1,1")

	MSCBSAY(17,23.5,ALLTRIM(_cGluten),"N","1","1,1")
    MSCBSAY(45,23.5,ALLTRIM(_cLactos),"N","1","1,1")
	
    MSCBSAY(17,20.5,"DATA FABRICACAO: ","N","2","1,1")
    MSCBSAY(42,20.5,_dProd,"N","2","1,1")

    MSCBSAY(17,17.5,"DATA VALIDADE: ","N","2","1,1")
    MSCBSAY(42,17.5,_dVALID,"N","2","1,1")

    MSCBSAY(57,17.5,"LOTE: ","N","4","1,1")
    MSCBSAY(67,17.5,_CLOTE,"N","4","1,1")

    MSCBSAY(20,15,_CINFCOMP1,"N","1","1,1")
    MSCBSAY(30,13,_CINFCOMP2,"N","1","1,1")
    MSCBSAY(28,11,_CINFCOMP3,"N","1","1,1")
    MSCBSAY(32,9,_CINFCOMP4,"N","1","1,1")
    MSCBSAY(20,7,_CINFCOMP5,"N","1","1,1")
    MSCBSAY(32,5,_CINFCOMP6,"N","1","1,1")
    MSCBSAY(22,3,_CINFCOMP7,"N","1","1,1")
    MSCBSAY(35,1,_CINFCOMP8,"N","1","1,1")

MSCBEND()


MSCBCLOSEPRINTER() //Finaliza a impressão

//msginfo("etiqueta 011")


return nil
//
//Ajusta SX1
Static Function AjustaSX1()
Local aSX1   := {}
Local aEstrut	:= {}
Local i      := 0
Local j      := 0
Local lSX1	 := .F.

aEstrut:= { "X1_GRUPO"  ,"X1_ORDEM"  ,"X1_PERGUNT","X1_PERSPA","X1_PERENG" ,"X1_VARIAVL","X1_TIPO"   ,"X1_TAMANHO","X1_DECIMAL","X1_PRESEL",;
"X1_GSC"    ,"X1_VALID"  ,"X1_VAR01"  ,"X1_DEF01" ,"X1_DEFSPA1","X1_DEFENG1","X1_CNT01"  ,"X1_VAR02"  ,"X1_DEF02"  ,;
"X1_DEFSPA2","X1_DEFENG2","X1_CNT02"  ,"X1_VAR03" ,"X1_DEF03"  ,"X1_DEFSPA3","X1_DEFENG3","X1_CNT03"  ,"X1_VAR04"  ,"X1_DEF04",;
"X1_DEFSPA4","X1_DEFENG4","X1_CNT04"  ,"X1_VAR05" ,"X1_DEF05"  ,"X1_DEFSPA5","X1_DEFENG5","X1_CNT05"  ,"X1_F3"     ,"X1_PYME","X1_GRPSXG",;
"X1_HELP","X1_PICTURE","X1_IDFIL"}

//Exemplo:
// AADD(aSX1,{})
//			"01"	,"02","03"					,"04"		,"05"	,"06"	,"07","08"                  ,"09","10","11","12","13"	   ,"14"	,"15"	,"16"	,"17"	,"18","19"	,"20"	,"21","22"	,"23","24"	,"25","26"	,"27","28"	,"29","30"	,"31","32"	,"33","34"	,"35","36"	,"37","38"	,"39","40"	,"41","42"	,"43"
aAdd(aSX1,{"ETQ011","01","Ordem de Producao?"	,""			,""		,"MV_CH1","C",TamSX3("D3_OP")[1]     ,0  ,0   ,"G" ,""  ,"MV_PAR01",""		,""			,""			,"","",""			,""			,""			,"","","","","","","","","","","","","","","","","SC2ETQ"	,"S","","","",""})
aAdd(aSX1,{"ETQ011","02","Produto?"	   			,""			,""		,"MV_CH2","C",TamSX3("D3_COD")[1]    ,0  ,0   ,"G" ,""  ,"MV_PAR02",""		,""			,""			,"","",""			,""			,""			,"","","","","","","","","","","","","","","","","SB1"	,"S","","","",""})
aAdd(aSX1,{"ETQ011","03","Lote?"		   		,""			,""		,"MV_CH3","C",TamSX3("C2_XLOTE")[1]  ,0  ,0   ,"G" ,""  ,"MV_PAR03",""		,""			,""			,"","",""			,""			,""			,"","","","","","","","","","","","","","","","",""		,"S","","","",""})
aAdd(aSX1,{"ETQ011","04","Qtde Etiqueta?"		,""			,""		,"MV_CH4","N",04                     ,0  ,0   ,"G" ,""  ,"MV_PAR04",""		,""			,""			,"","",""			,""			,""			,"","","","","","","","","","","","","","","","",""		,"S","","","",""})
aAdd(aSX1,{"ETQ011","05","Impressora?"			,""			,""		,"MV_CH5","C",TamSX3("CB5_CODIGO")[1],0  ,0   ,"G" ,""  ,"MV_PAR05",""		,""			,""			,"","",""			,""			,""			,"","","","","","","","","","","","","","","","","CB5"	,"S","","","",""})

ProcRegua(Len(aSX1))

dbSelectArea("SX1")
dbSetOrder(1)
For i:= 1 To Len(aSX1)
	If !Empty(aSX1[i][1])
		
		if ! dbSeek( Padr( aSX1[i,1] , Len( X1_GRUPO ) , ' ' ) + aSX1[i,2] )
			
			lSX1 := .T.
			RecLock("SX1",.T.)
			
			For j:=1 To Len(aSX1[i])
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSX1[i,j])
				EndIf
			Next j
			
			dbCommit()
			MsUnLock()
			IncProc("Atualizando Perguntas Etiquetas....")
		EndIf
	EndIf
Next i

Return
//

