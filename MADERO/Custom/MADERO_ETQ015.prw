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
!Nome              ! ETQ015                                                  !
+------------------+---------------------------------------------------------+
!Descricao         ! Rotina Emissão etiqueta EXPEDICAO                       !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 20/05/18                                                !
+------------------+---------------------------------------------------------+
*/
User Function ETQ015(aEtqAuto)
Local oFont := TFont():New("Arial",0,-16,,.T.,,,,,.F.,.F.)
PRIVATE  _cSep:=SPACE(06) //SPACE(TamSX3("CB8_NUMSEP")[1])
PRIVATE  _nQtde:=SPACE(TamSX3("C2_QUANT")[1])
PRIVATE  _cImp:=SPACE(TamSX3("CB5_CODIGO")[1])
PRIVATE  _cPROD:=SPACE(100)
PRIVATE  _cOpcao:=SPACE(1)
PRIVATE  _lauto:=.F.

DEFAULT aEtqAuto := NIL

If !aEtqAuto == NIL
	//EXECUTAR IMPRIME ETIQUETA
	_CSEP    :=aETQAuto[1][1]
	_nQtde   :=aEtqAuto[1][2]
	_cImp    :=aEtqAuto[1][3]
	//	_LAUTO   :=.T.
	//	IF vSEP(_cSEP,_NQTDE,_cImp)
	//		fEtq015(_cSEP,_NQTDE,_cImp,_LAUTO)
	//	Endif
EndIf
//
DEFINE MSDIALOG oDlgETQ TITLE "Etq015 - Imprime Etiqueta Expedição " From 001,001 to 270,480 Pixel //of oMainWnd

oSayOP  := tSay():New(020,030,{|| "Ordem Separação: "   },oDlgETQ,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,100,15)
oGetOP  := tGet():New(020,125,{|u| if(PCount()>0,_cSep:=u,_cSep)}, oDlgETQ,60,9,,,,,,,,.T.,,, {|| .T. } ,,,,.F.,,"CB7",'_cSEP')
oSayPROD:= tSay():New(038,125,{|| _CPROD  },oDlgETQ,,,,,,.T.,CLR_BLACK,CLR_WHITE,100,15)

oSayQTD := tSay():New(040,065,{|| "Qtde Etiqueta: "   },oDlgETQ,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,100,15)
oGetQTD := tGet():New(040,125,{|u| if(PCount()>0,_nQtde:=u,_nQtde)}, oDlgETQ,60,9,'99999', ,,,,,,.T.,,, {|| .T. } ,,,,.F.,,,'_nQtde')

oSayIMP := tSay():New(060,075,{|| "Impressora: "   },oDlgETQ,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,100,15)
oGetIMP := tGet():New(060,125,{|u| if(PCount()>0,_cImp:=u,_cImp)}, oDlgETQ,60,9,PesqPict("CB5","CB5_CODIGO"), ,,,,,,.T.,,, {|| .T. } ,,,,.F.,,"CB5",'_cImp')

oBtnImp := tButton():New(080,100,'Imprimir'  ,oDlgETQ, {|| Processa( { || fEtq015(_cSEP,_nQtde,_cImp) },"[ETQ015] - AGUARDE...") },40,12,,,,.T.)
oBtnSair := tButton():New(080,150,'Sair'     ,oDlgETQ, {|| oDlgETQ:End() },40,12,,,,.T.)


ACTIVATE MSDIALOG oDlgETQ CENTERED
//EndIf

Return(nil)

*-------------------------------------*
static function fetq015(_cSEP,_nqtde,_cimp)
*-------------------------------------*
Local _fim := chr(13)+chr(10)
Local _oFile   := Nil
Local _cSaida  := CriaTrab("",.F.)
Local _cPorta  := "LPT1"
Local _CDESC   :=SB1->B1_DESC
Local _cLOTE   :=CB8->CB8_LOTECT
Local _cRota   :=""
Local _cVeiculo:=""
Local cModelo,lTipo,nPortIP,cServer,cEnv,cFila,lrvWin
Local cPorta :=Nil
Local _nY
Local _lRet  :=.T.
//
oDlgETQ:End()
//
dbSelectArea("CB7")
dbSetOrder(1)
dbGoTop()
If dbSeek(xFilial("CB7")+_CSEP)
	dbSelectArea("CB8")
	dbSetOrder(1)
	dbGoTop()
	If dbSeek(xFilial("CB8")+_CSEP)
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbGoTop()
		If !dbSeek(xFilial("SB1")+CB8->CB8_PROD)
			_lret:=.f.
			MsgStop("Produto n�o cadastrado - " + CB8->CB8_PROD + " !")
		Endif
		//cliente
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbGoTop()
		If !dbSeek(xFilial("SA1")+CB7->CB7_CLIENT+CB7->CB7_LOJA)
			_lret:=.f.
			MsgStop("Cliente n�o cadastrado - " + CB7->CB7_CLIENT+CB7->CB7_LOJA + " !")
		Endif
		//cliente
		dbSelectArea("SC9")
		dbSetOrder(6)
		dbGoTop() //C9_FILIAL+C9_SERIENF+C9_NFISCAL+C9_CARGA+C9_SEQCAR
		If !dbSeek(xFilial("SC9")+CB8->CB8_SERIE+CB8->CB8_NOTA)
			_lret:=.f.
		ELSE
			dbSelectArea("DAK")
			dbSetOrder(1)
			dbGoTop()
			If dbSeek(xFilial("DAK")+SC9->C9_CARGA+SC9->C9_SEQCAR)
				_cRota:=DAK->DAK_ROTEIR
				_cVeiculo:=DAK->DAK_CAMINH
			Endif
		EndIf
	EndIf
EndIf

//busca porta impressora
//
If Empty(_CIMP) .or. !_LRET
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
If _nQtde=0
	_nQtde   :=CB8->CB8_QTDORI
Endif

TEXTO:={}
//INICIO
_cMarca:="MADERO"
//aadd(texto,"^XA"+_fim)
//aadd(texto,"^FO20,100^IME:MADERO.BMP^FS"+_fim)
aadd(texto,"^FO040,020^A0N,45,60^FDMADERO^FS"+_fim)
aadd(texto,"^FO04,060"+_fim)
aadd(texto,"^GB650,0,5^FS"+_fim)
aadd(texto,"^FO340,100^A0N,25,30^FDCarga: "+ALLTRIM(SC9->C9_CARGA)+"  Rota: "+_cRota+"^FS"+_fim)
aadd(texto,"^FO340,150^A0N,25,30^FDVeiculo: "+_cVeiculo+"^FS"+_fim)
aadd(texto,"^FO340,200^A0N,25,30^FDNF_e:"+ALLTRIM(CB8->CB8_NOTA)+"/"+ALLTRIM(CB8->CB8_SERIE)+"^FS"+_fim)
aadd(texto,"^FO340,250^A0N,25,25^FDDest.:"+ALLTRIM(SA1->A1_NREDUZ)+"^FS"+_fim)
aadd(texto,"^FO340,300^A0N,25,30^FDPedido de Venda:"+ALLTRIM(CB8->CB8_PEDIDO)+"^FS"+_fim)
aadd(texto,"^FO040,060" +_fim)
aadd(texto,"^BQN,2,10"+_fim)
aadd(texto,"^FDA,"+SB1->B1_CODBAR+CB8->CB8_LOTECT+"01"+CB9->CB9_VOLUME+CB8->CB8_PEDIDO+CB8->CB8_NOTA+CB8->CB8_SERIE+SC9->C9_CARGA+"^FS"+_fim)
aadd(texto,"^FO040,380"+_fim)
aadd(texto,"^GB650,0,5^FS"+_fim)
aadd(texto,"^FO040,400^A0N,25,20^FD"+ALLTRIM(SB1->B1_COD)+"-"+SUBSTR(ALLTRIM(_CDESC),1,35)+" Lote:"+ALLTRIM(CB8->CB8_LOTECT)+" Val: "+DTOC(DDATABASE)+"^FS"+_fim)

MSCBPRINTER(cModelo,cPorta,,,lTipo,nPortIP,cServer,cEnv,nBuffer,cFila,lDrvWin,Trim(CB5->CB5_PATH)+"\Etq015")
MSCBCHKSTATUS(CB5->CB5_VERSTA =="1")

MSCBBEGIN(_nQtde,6)

For _nY := 1 To Len(texto)
	MSCBWRITE(texto[_nY])
Next _nY

MSCBEND()


MSCBCLOSEPRINTER() //Finaliza a impressão

//msginfo("etiqueta 015")

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
aAdd(aSX1,{"ETQ001","01","Ordem de Producao?"	,""			,""		,"MV_CH1","C",TamSX3("D3_OP")[1]     ,0  ,0   ,"G" ,""  ,"MV_PAR01",""		,""			,""			,"","",""			,""			,""			,"","","","","","","","","","","","","","","","","SC2ETQ"	,"S","","","",""})
aAdd(aSX1,{"ETQ001","02","Produto?"	   			,""			,""		,"MV_CH2","C",TamSX3("D3_COD")[1]    ,0  ,0   ,"G" ,""  ,"MV_PAR02",""		,""			,""			,"","",""			,""			,""			,"","","","","","","","","","","","","","","","","SB1"	,"S","","","",""})
aAdd(aSX1,{"ETQ001","03","Lote?"		   		,""			,""		,"MV_CH3","C",TamSX3("C2_XLOTE")[1]  ,0  ,0   ,"G" ,""  ,"MV_PAR03",""		,""			,""			,"","",""			,""			,""			,"","","","","","","","","","","","","","","","",""		,"S","","","",""})
aAdd(aSX1,{"ETQ001","04","Qtde Etiqueta?"		,""			,""		,"MV_CH4","N",04                     ,0  ,0   ,"G" ,""  ,"MV_PAR04",""		,""			,""			,"","",""			,""			,""			,"","","","","","","","","","","","","","","","",""		,"S","","","",""})
aAdd(aSX1,{"ETQ001","05","Impressora?"			,""			,""		,"MV_CH5","C",TamSX3("CB5_CODIGO")[1],0  ,0   ,"G" ,""  ,"MV_PAR05",""		,""			,""			,"","",""			,""			,""			,"","","","","","","","","","","","","","","","","CB5"	,"S","","","",""})

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
