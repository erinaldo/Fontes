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
!Nome              ! ETQ013                                                  !
+------------------+---------------------------------------------------------+
!Descricao         ! Rotina Emissão etiqueta Recebimento                     !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 20/05/18                                                !
+------------------+---------------------------------------------------------+
*/
User Function ETQ013(_cRID)
Local  _nQtde   := 1
Local  _cImp    := Posicione("ZIA",1,XFILIAL("ZIA")+"013","ZIA_IMPPAD")
Local  cPerg    := PADR("ETQ013",10)
Local  _lret    := .T.
//
//
DEFAULT _cRID := NIL
//
If _cRID = NIL
	AjustaSX1()
	If Pergunte(cPerg,.T.)
		_cMID:=MV_PAR01
		_nMQt:=MV_PAR02
		_cMIM:=MV_PAR03
		//
		dbSelectArea("ZI3")
		dbSetOrder(1)
		ZI3->(dbSeek(xFilial("ZI3")+_cMID,.T.))
		WHILE !ZI3->(EOF()) .AND. _cMID=ZI3->ZI3_ID //.AND. ZI2->ZI2_PROD=ZI3->ZI3_PROD
			FEtq013(_cMID,_nMQt,_cMIm)
			ZI3->(DBSKIP())
		End
	Else
		_lret:=.f.
	ENDIF
Else
	FEtq013(_cRID,_nQtde,_cImp)

EndIf
//

//
Return(nil)

*-----------------------------------------*
Static function FEtq013(_cID,_nQtde,_cImp)
*-----------------------------------------*
Local _fim     := chr(13)+chr(10)
Local _n       :=0
Local cModelo,lTipo,nPortIP,cServer,cEnv,cFila,lrvWin
Local cPorta :=Nil
Local _lRet:=.T.
Local _nY
Local nPontoMM := 0
Local QRCODE := "" //Alltrim(Z13->ZI3_PROD)+";"+Alltrim(Z13->ZI3_PALLET)+";"+Alltrim(Z13->ZI3_QUANT)
//
dbSelectArea("ZI1")
dbSetOrder(2)
If !dbSeek(xFilial("ZI1")+_CID)
	_lret:=.f.
	MsgStop("ID não cadastrado - (ZI1) - " + _cID+"!")
EndIf
//fornecedor
dbSelectArea("SA2")
dbSetOrder(1)
If !dbSeek(xFilial("SA2")+ZI1->ZI1_FORN+ZI1->ZI1_LOJA)
	_lret:=.f.
	MsgStop("Fornecedor não cadastrado - (SA2) - " + ZI1->ZI1_FORN+ZI1->ZI1_LOJA + " !")
Endif
//
dbSelectArea("ZI2")
dbSetOrder(1)
If !dbSeek(xFilial("ZI2")+_CID)
	_lret:=.f.
	MsgStop("ID/Produto não cadastrado - (ZI2) - " + _cID+ "!")
EndIf
//PRODUTO
dbSelectArea("SB1")
dbSetOrder(1)
If !dbSeek(xFilial("SB1")+ZI2->ZI2_PROD)
	_lret:=.f.
	MsgStop("Produto não cadastrado - (SB1) - " + ZI2->ZI2_PROD + "!")
EndIf
//
If !_LRET .or. Empty(_cImp)
	Return
EndIf
//
//busca porta impressora
//
If ! CB5->(DbSeek(xFilial("CB5")+_CIMP))
	Return
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
IF _nQtde=0
	_nQtde:=1
EndIf
dbSelectArea("ZI4")
dbSetOrder(1)
IF dbSeek(xFilial("ZI4")+ZI3->ZI3_ID+ZI3->ZI3_PROD+ZI3->ZI3_SIF)
	//
	// TEXTO:={}
	// //INICIO      
	// IF _CIMP="000001" .OR._CIMP="000002" 
	// 	aadd(texto,"^JMB^FS"+_fim)    
	// ENDIF

	// //DESCRIÇÃO PRODUTO------------------------------------------------------
	// aadd(texto,"^FO130,015^A0N,40,40^FDRECEBIMENTO - "+IIF(ZI3->ZI3_CONDIC=="R","REPROVADO",IIF(ZI3->ZI3_CONDIC=="Q","QUARENTENA","APROVADO"))+"^FS"+_fim)
	// aadd(texto,"^FO040,050"+_fim)
	// aadd(texto,"^GB650,0,5^FS"+_fim)
	// aadd(texto,"^FO040,050" +_fim)
	// aadd(texto,"^BQN,2,10"+_fim)
	// aadd(texto,"^FDMM,A"+SB1->B1_COD+ZI3->ZI3_PALLET+"^FS"+_fim)
	// aadd(texto,"^FS"+_fim)
	// aadd(texto,"^FO360,060"+_fim)
	// aadd(texto,"^FO360,080^A0N,30,30^FDSIF: "+ZI4->ZI4_SIF+"^FS"+_fim)
	// aadd(texto,"^FO360,120^A0N,30,30^FDVALIDADE: "+DTOC(ZI4->ZI4_VALID)+"^FS"+_fim)
	// aadd(texto,"^FO360,160^A0N,30,30^FDQTDE: "+Transform(ZI3->ZI3_QUANT, PesqPict("ZI3","ZI3_QUANT"))+"^FS"+_fim)
	// aadd(texto,"^FO360,200^A0N,30,30^FDUNIDADE: "+ZI2->ZI2_UM+"^FS"+_fim)
	// aadd(texto,"^CF0,40,340,^FO30,30"+_fim)
	// aadd(texto,"^FB360,2,,"+_fim)
	// aadd(texto,"^FO360,240^A0N,30,30^FDFORN:"+ALLTRIM(SA2->A2_NREDUZ)+"^FS"+_fim)
	
	// aadd(texto,"^FO360,275^A0N,30,30^FDLote^FS"+_fim)
	// aadd(texto,"^FO360,310^A0N,25,25^FD"+Alltrim(ZI3->ZI3_PALLET)+"^FS"+_fim)
	
	// aadd(texto,"^FO040,360"+_fim)
	// aadd(texto,"^GB650,0,5^FS"+_fim)
	// aadd(texto,"^CF0,60,355,^FO30,30"+_fim)
	// aadd(texto,"^FB600,2,,"+_fim)
	// aadd(texto,"^FO060,365^A0N,30,30^FD"+ALLTRIM(SB1->B1_COD)+"-"+SUBSTR(ALLTRIM(SB1->B1_DESC),1,35)+"^FS"+_fim)
	// aadd(texto,"^FO060,410^A0N,25,25^FDDATA RECEB:"+DTOC(ZI1->ZI1_DTINIC)+"^FS"+_fim)
	// aadd(texto,"^FO450,410^A0N,25,25^FDN.NF:"+ALLTRIM(ZI1->ZI1_DOC)+"/"+ALLTRIM(ZI1->ZI1_SERIE)+"^FS"+_fim)
	// //
	MSCBPRINTER(cModelo,cPorta,,,lTipo,nPortIP,cServer,cEnv,nBuffer,cFila,lDrvWin,Trim(CB5->CB5_PATH))
	MSCBCHKSTATUS(CB5->CB5_VERSTA =="1")

	cCodigo := CBGrvEti('01',{SB1->B1_COD,_nQtde,,,,,,,,,,,,,,ZI3->ZI3_PALLET,,,,,,,,,})

	// If !empty(_cop)
		QRCODE := cCodigo+";"+SB1->B1_COD
	// EndIf

	
	MSCBBEGIN(_nQtde,6)

	MSCbModelo('DPL',cModelo,@nPontoMM)

    nXPixel    := nPontoMM *if(15==NIL,0,15)
    nYPixel    := nPontoMM *if(5==NIL,0,5)
    nXPixel     := Strzero(val(str(nXPixel,5,3))*100,4)
    nYPixel     := strzero(val(str(nYPixel,5,3))*100,4)

    TEXTO:={}
    MSCBSAY(20,46,"RECEBIMENTO - "+IIF(ZI3->ZI3_CONDIC=="R","REPROVADO",IIF(ZI3->ZI3_CONDIC=="Q","QUARENTENA","APROVADO")),"N","4","1,1")
    
    MSCBLineH(05,44,87,2,"B")

	aadd(texto,"<STX>KcDE300" +_fim)
    aadd(texto,"D11" +_fim)
    If nPontoMM == 0.03937008
        aadd(texto,"1W1D99000"+nXPixel+nYPixel+"2HM,"+QRCODE +_fim) //300DPI
    Else
        aadd(texto,"1W1D77000"+nXPixel+nYPixel+"2HM,"+QRCODE +_fim) //200DPI
    EndIf
    //aadd(texto,"binary,B0003<0xfe><0xca><0x83><0x0D>" +_fim)
    aadd(texto,"E" +_fim)

    MSCBLineH(05,10,87,2,"B")


    MSCBSAY(40,39,"SIF: "+ZI4->ZI4_SIF,"N","3","1,1")

    MSCBSAY(40,34,"VALIDADE: "+DTOC(ZI4->ZI4_VALID),"N","3","1,1")

    MSCBSAY(40,29,"QTDE: "+Transform(ZI3->ZI3_QUANT, PesqPict("ZI3","ZI3_QUANT")),"N","3","1,1")

    MSCBSAY(40,24,"UN: "+ZI2->ZI2_UM,"N","3","1,1")

    MSCBSAY(40,19,"FORN: "+ALLTRIM(SA2->A2_NREDUZ),"N","3","1,1")

    MSCBSAY(40,14,"LOTE","N","3","1,1")

    MSCBSAY(40,11,Alltrim(ZI3->ZI3_PALLET),"N","2","1,1")


    MSCBSAY(3,5,ALLTRIM(SB1->B1_COD)+"-"+SUBSTR(ALLTRIM(SB1->B1_DESC),1,35),"N","3","1,1")

    MSCBSAY(3,0,"DATA RECEB: "+DTOC(ZI1->ZI1_DTINIC),"N","2","1,1")

    MSCBSAY(43,0,"N NF: "+ALLTRIM(ZI1->ZI1_DOC)+"/"+ALLTRIM(ZI1->ZI1_SERIE),"N","2","1,1")

	For _nY := 1 To Len(texto)
		MSCBWRITE(texto[_nY])     
    Next _nY

   MSCBEND() 

	MSCBCLOSEPRINTER() //Finaliza a impressão
	//msginfo("etiqueta 013")
ENDIF

return nil

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
aAdd(aSX1,{"ETQ013","01","ID?"	               ,""			,""		,"MV_CH1","C",TamSX3("ZI1_ID")[1]      ,0  ,0   ,"G" ,""  ,"MV_PAR01",""		,""			,""			,"","",""			,""			,""			,"","","","","","","","","","","","","","","","","ZI1","S","","","",""})
aAdd(aSX1,{"ETQ013","02","Qtde?"			    ,""			,""		,"MV_CH2","N",5                        ,0  ,0   ,"G" ,""  ,"MV_PAR02",""		,""			,""			,"","",""			,""			,""			,"","","","","","","","","","","","","","","","",""	  ,"S","","","",""})
aAdd(aSX1,{"ETQ013","03","Impressora?"	        ,""			,""		,"MV_CH3","C",TamSX3("CB5_CODIGO")[1]  ,0  ,0   ,"G" ,""  ,"MV_PAR03",""		,""			,""			,"","",""			,""			,""			,"","","","","","","","","","","","","","","","","CB5","S","","","",""})

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


