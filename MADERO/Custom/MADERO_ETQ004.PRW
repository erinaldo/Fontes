#include "protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"
// Constantes definidas em prconst.ch
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
!Nome              ! ETQ004                                                  !
+------------------+---------------------------------------------------------+
!Descricao         ! Rotina Emissão etiqueta 5 CM ADESIVA                    !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 20/05/18                                                !
+------------------+---------------------------------------------------------+
*/
User Function ETQ004(aEtqAuto)
Local  _aArea := GetArea()
Local  _cperg :="ETQ004    "
Local  _cOP:=""
Local  _nQtde:=0
Local  _cImp:=""
Local  _cPROD:=""
Local  _cTpEtq:="004" //Etiqueta 5 cm ADESIVA
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
	fEtq004(_cop,_nqtde,_cImp)
Endif

RestArea(_aArea)

Return(nil)
//
*----------------------------------------*
static function fetq004(_cop,_nqtde,_cimp)
*----------------------------------------*
Local _fim     := chr(13)+chr(10)
Local _nY       :=0
Local _oFile   := Nil
Local _cSaida  := CriaTrab("",.F.)
Local _cPorta  := "LPT1"
Local _CDESC   := IIF(!Empty((_cAliasSC2)->B1_PACAMAP), ALLTRIM(POSICIONE("SX5",1,XFILIAL("SX5")+"Z6"+(_cAliasSC2)->B1_PACAMAP,"X5_DESCRI")), (_cAliasSC2)->B1_DESC)
Local _dPROD   :=DTOC(STOD((_cAliasSC2)->C2_XDTFIR))
Local _dVALID  :=DTOC(STOD((_cAliasSC2)->C2_XDTVAL))
Local _cINGRED := ALLTRIM(MSMM((_cAliasSC2)->B1_CODPROC))
Local _cCons   := IIF(!Empty((_cAliasSC2)->B1_XCONS), ALLTRIM(POSICIONE("SX5",1,XFILIAL("SX5")+"W1"+(_cAliasSC2)->B1_XCONS,"X5_DESCRI")), "")
Local _cAlerg  := IIF(!Empty((_cAliasSC2)->B1_XALERG), ALLTRIM(POSICIONE("SX5",1,XFILIAL("SX5")+"W2"+(_cAliasSC2)->B1_XALERG,"X5_DESCRI")), "")
Local _cGluten := IIF((_cAliasSC2)->B1_XGLUT="1","CONTÉM GLUTEN",IIF((_cAliasSC2)->B1_XGLUT="2","NÃO CONTÉM GLUTEN",""))
Local _cLOTE   := Alltrim(Str(Val((_cAliasSC2)->C2_XLOTE)))
Local _cPESOE  :=TRANSFORM((_cAliasSC2)->B1_XPEMB,PesqPict("SB1","B1_XPEMB")) + "Kg"
Local _CDESCD  := ALLTRIM(POSICIONE("SB5",1,XFILIAL("SB5")+(_cAliasSC2)->B1_COD,"B5_CEME"))
Local _CSIF    :="Registro no Ministério da Agricultura SIF/DIPOA sob No." + ALLTRIM(POSICIONE("SB5",1,XFILIAL("SB5")+(_cAliasSC2)->B1_COD,"B5_DES"))
Local _cRecoCons    := "Recomendacões para consumo: Produto exclusivo para preparo nas filiais do Grupo Durski, conforme procedimentos operacionais padrão estabelecido para cada produto, respeitando tempo e temperatura."

//busca porta impressora
//
Local cModelo,lTipo,nPortIP,cServer,cEnv,cFila,lrvWin 
Local cPorta :=Nil
Local i := 0

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
TEXTO:={}
//INICIO
//aadd(texto,"^XA"+_fim)
//DESCRIÇÃO PRODUTO
// aadd(texto,"^FO30,30"+_fim)
// aadd(texto,"^GB760,115,5,,3^FS"+_fim)
// IF EMPTY(_CDESCD) .OR. ALLTRIM(_CDESC)=ALLTRIM(_CDESCD)
// 	aadd(texto,"^CF55,65,100^FO30,30"+_fim)
// 	aadd(texto,"^FB700,3,,"+_fim)
// 	aadd(texto,"^FO55,55^A0N,30,30^FD"+ALLTRIM(_CDESC)+"^FS"+_fim)
// ELSE
// 	aadd(texto,"^CF0,65,100^FO30,30"+_fim)
// 	aadd(texto,"^FB700,2,,"+_fim)
// 	aadd(texto,"^FO55,45^A0N,30,30^FD"+SUBSTR(ALLTRIM(_CDESCD),1,80)+"^FS"+_fim)
// 	//
//     aadd(texto,"^CF55,95,100^FO30,30"+_fim)
// 	aadd(texto,"^FB700,1,,"+_fim)
// 	aadd(texto,"^FO55,105^A0N,30,30^FD"+SUBSTR(ALLTRIM(_CDESC),1,40)+"^FS"+_fim)
// ENDIF
// //FABRICAÇÃO-------------------------------------------------------------
// aadd(texto,"^FO30,165"+_fim)
// aadd(texto,"^GB250,95,5,,3^FS"+_fim)
// //aadd(texto,"^FWR"+_fim)
// aadd(texto,"^FO40,175^A0N,25,20^FDPRODUCAO/EMBALAGEM^FS"+_fim)                               
// aadd(texto,"^FO85,215^A0N,25,25^FD"+_dPROD+"^FS"+_fim)
// //VALIDADE---------------------------------------------------------------
// aadd(texto,"^FO300,165"+_fim)
// aadd(texto,"^GB250,95,5,,3^FS"+_fim)
// //aadd(texto,"^FWR"+_fim)
// aadd(texto,"^FO345,175^A0N,25,20^FDDATA DE VALIDADE^FS"+_fim)
// aadd(texto,"^FO355,215^A0N,25,25^FD"+_dVALID+"^FS"+_fim)
// //LOTE-------------------------------------------------------------------
// aadd(texto,"^FO570,165"+_fim)
// aadd(texto,"^GB220,95,5,,3^FS"+_fim)
// //aadd(texto,"^FWR"+_fim)
// aadd(texto,"^FO630,175^A0N,25,20^FDLOTE^FS"+_fim)
// aadd(texto,"^FO620,215^A0N,25,25^FD"+_cLOTE+"^FS"+_fim)
// //PESO EMBALAGEM-----------------------------------------------------
// aadd(texto,"^FO30,280"+_fim)
// aadd(texto,"^GB250,90,5,,3^FS"+_fim)
// //aadd(texto,"^FWR"+_fim)
// aadd(texto,"^FO65,295^A0N,25,20^FDPESO EMBALAGEM^FS"+_fim)
// aadd(texto,"^FO85,330^A0N,25,25^FD"+_cPESOE+"^FS"+_fim)
// //CONSERVAÇÃO---------------------------------------------------------
// aadd(texto,"^FO300,280"+_fim)
// aadd(texto,"^GB490,90,5,,3^FS"+_fim)
// //aadd(texto,"^FWR"+_fim)
// aadd(texto,"^FO360,295^A0N,25,20^FDMODO DE CONSERVACAO^FS"+_fim)
// aadd(texto,"^FO305,330^A0N,25,25^FD"+_cCONS+"^FS"+_fim)
// //MESAGEM SIF
// aadd(texto,"^FO45,400^A0N,30,25^FD"+ALLTRIM(_CSIF)+"^FS"+_fim)
// //aadd(texto,	'^PQ' + cValToChar(_nQtde) + ',0,1,Y^XZ'+_fim	)
// //
// //aadd(texto,"^XZ"+_fim)

// //
// //
MSCBPRINTER(cModelo,cPorta,,,lTipo,nPortIP,cServer,cEnv,nBuffer,cFila,lDrvWin,Trim(CB5->CB5_PATH)+"\ETQ002")
MSCBCHKSTATUS(CB5->CB5_VERSTA =="1")

 MSCBBEGIN(_nQtde,6, 127.8)  

// For _nY := 1 To Len(texto)
// 	MSCBWRITE(texto[_nY])     
// Next _nY

/*---------------------------------BOX01---------------------------------------------*/     
    nLeft   := 05   //Margem em milímetros a esquerda
    nBottom := 110  //Margem em milímetros do topo
    nRight  := 95   //Margem em milímetros a direita
    nTop    := 120  //Margem em milímetros do final
    nExpess := 1    //Expessura da borda          
    MSCBBOX(nLeft,nBottom,nRight,nTop,nExpess) //Monta Box

    nFTitle         := 2 //Tamanho Fonte Titulo
                        
    cTitle          := ALLTRIM(_CDESC)    //String Titulo
    cInitTitle      := CalcInit(cTitle,nFTitle,nLeft, nRight, "CENTER") //Calcula posicao inicio titulo - CENTRO
    MSCBSAY(cInitTitle,115.5,cTitle     ,"N",cValToChar(nFTitle),"1,1")   //Imprime Titulo

    cTitle          := ALLTRIM(_CDESCD)                     //String Subtitulo
    cInitTitle      := CalcInit(cTitle,nFTitle,nLeft, nRight, "CENTER") //Calcula posicao inicio titulo - CENTRO
    MSCBSAY(cInitTitle,nBottom+1,cTitle     ,"N",cValToChar(nFTitle),"1,1")   //Subtitulo
    /*---------------------------------FIM BOX01-----------------------------------------*/      


    /*---------------------------------BOX02.01---------------------------------------------*/                        
    nLeft   := 05   //Margem em milímetros a esquerda
    nBottom := 100   //Margem em milímetros do topo
    nRight  := 45   //Margem em milímetros a direita
    nTop    := 109  //Margem em milímetros do final
    nExpess := 1    //Expessura da borda    
    MSCBBOX(nLeft,nBottom,nRight,nTop,nExpess) //Monta Box

    nFTitle         := 1 //Tamanho Fonte Titulo
    nFDesc          := 3 //Tamanho Fonte Descricão

    cTitle := "DATA PRODUCAO/EMBALAGEM"     
    cInitTitle      := CalcInit(cTitle,nFTitle,nLeft, nRight, "CENTER")    //Calcula posicao inicio titulo - ESQUERDA

    nPos := (nTop - ((nTop - nBottom)/2))+1.5
    MSCBSAY(cInitTitle,nPos,cTitle,"N",cValToChar(nFTitle),"1,1")     //Titulo

    cDesc := ALLTRIM(_dPROD)
    cInitTitle      := CalcInit(cDesc,nFDesc,nLeft, nRight, "CENTER")
    nPos := nBottom + 1
    MSCBSAY(cInitTitle,nPos,cDesc,"N",cValToChar(nFDesc),"1,1")     //Subtitulo


    /*---------------------------------FIM BOX03.01-----------------------------------------*/

    /*---------------------------------BOX02.02---------------------------------------------*/                        
    nLeft   := 46 //Margem em milímetros a esquerda
    nBottom := 100  //Margem em milímetros do topo
    nRight  := 74   //Margem em milímetros a direita
    nTop    := 109  //Margem em milímetros do final
    nExpess := 1    //Expessura da borda          
    MSCBBOX(nLeft,nBottom,nRight,nTop,nExpess) //Monta Box

    nFTitle         := 1 //Tamanho Fonte Titulo
    nFDesc          := 3 //Tamanho Fonte Descricão

    cTitle := "DATA DE VALIDADE:" 
    cInitTitle      := CalcInit(cTitle,nFTitle,nLeft, nRight, "LEFTBOX")    //Calcula posicao inicio titulo - ESQUERDA

    nPos := (nTop - ((nTop - nBottom)/2))+1.5
    MSCBSAY(cInitTitle,nPos,cTitle     ,"N",cValToChar(nFTitle),"1,1")     //Titulo

    cDesc := ALLTRIM(_dVALID)
    cInitTitle      := CalcInit(cDesc,nFDesc,nLeft, nRight, "CENTER")
    nPos := nBottom + 1
    MSCBSAY(cInitTitle,nPos,cDesc     ,"N",cValToChar(nFDesc),"1,1")     //Subtitulo


    /*---------------------------------FIM BOX03.02-----------------------------------------*/

    /*---------------------------------BOX02.03---------------------------------------------*/                        
    nLeft   := 75   //Margem em milímetros a esquerda
    nBottom := 100  //Margem em milímetros do topo
    nRight  := 95   //Margem em milímetros a direita
    nTop    := 109  //Margem em milímetros do final
    nExpess := 1    //Expessura da borda          
    MSCBBOX(nLeft,nBottom,nRight,nTop,nExpess) //Monta Box

    nFTitle         := 1 //Tamanho Fonte Titulo
    nFDesc          := 3 //Tamanho Fonte Descricão
    
    cTitle := "LOTE:"
    cInitTitle      := CalcInit(cTitle,nFTitle,nLeft, nRight, "CENTER")    //Calcula posicao inicio titulo - ESQUERDA
    nPos := (nTop - ((nTop - nBottom)/2))+1.5
    MSCBSAY(cInitTitle,nPos,cTitle     ,"N",cValToChar(nFTitle),"1,1")     //Titulo


    cDesc := ALLTRIM(_cLOTE)
    cInitTitle      := CalcInit(cDesc,nFDesc,nLeft, nRight, "CENTER")
    nPos := nBottom + 1
    MSCBSAY(cInitTitle,nPos,cDesc,"N",cValToChar(nFDesc),"1,1")     //Subtitulo


    /*---------------------------------FIM BOX03.03-----------------------------------------*/

    /*---------------------------------BOX04.01---------------------------------------------*/                        
    nLeft   := 05   //Margem em milímetros a esquerda
    nBottom := 90  //Margem em milímetros do topo
    nRight  := 45   //Margem em milímetros a direita
    nTop    := 99  //Margem em milímetros do final
    nExpess := 1    //Expessura da borda          
    MSCBBOX(nLeft,nBottom,nRight,nTop,nExpess) //Monta Box

    nFTitle         := 1 //Tamanho Fonte Titulo
    nFDesc          := 3 //Tamanho Fonte Descricão

    cTitle := "PESO DA EMBALAGEM:"
    cInitTitle      := CalcInit(cTitle,nFTitle,nLeft, nRight, "CENTER")    //Calcula posicao inicio titulo - ESQUERDA

    nPos := (nTop - ((nTop - nBottom)/2))+1.5
    MSCBSAY(cInitTitle,nPos,cTitle,"N",cValToChar(nFTitle),"1,1")     //Titulo

    cDesc := ALLTRIM(_cPESOE)
    cInitTitle      := CalcInit(cDesc,nFDesc,nLeft, nRight, "CENTER")
    nPos := nBottom + 1
    MSCBSAY(cInitTitle,nPos,cDesc,"N",cValToChar(nFDesc),"1,1")     //Subtitulo


    /*---------------------------------FIM BOX04.01-----------------------------------------*/

    /*---------------------------------BOX04.02---------------------------------------------*/                        
    nLeft   := 46  //Margem em milímetros a esquerda
    nBottom := 90  //Margem em milímetros do topo
    nRight  := 95   //Margem em milímetros a direita
    nTop    := 99  //Margem em milímetros do final
    nExpess := 1    //Expessura da borda          
    MSCBBOX(nLeft,nBottom,nRight,nTop,nExpess) //Monta Box

    nFTitle         := 1 //Tamanho Fonte Titulo
    nFDesc          := 1 //Tamanho Fonte Descricão

    cTitle := "MODO DE CONSERVACAO:"
    cInitTitle      := CalcInit(cTitle,nFTitle,nLeft, nRight, "CENTER")    //Calcula posicao inicio titulo - ESQUERDA

    nPos := (nTop - ((nTop - nBottom)/2))+1.5
    MSCBSAY(cInitTitle,nPos,cTitle     ,"N",cValToChar(nFTitle),"1,1")     //Titulo

    cDesc := ALLTRIM(_cCONS)
    cInitTitle      := CalcInit(cDesc,nFTitle,nLeft, nRight, "CENTER")    //Calcula posicao inicio titulo - ESQUERDA
    //nPos := nTop - (((nTop - nBottom)/3)*3)+0.3
    //MSCBSAY(cInitTitle,nPos,"MANTENHA CONGELADO A -12oC OU MAIS FRIO"     ,"N",cValToChar(nFTitle),"1,1")     //Subtitulo

    If (Len(cDesc)*nFDesc) > nRight - nLeft
        nTamMax := (nRight - nLeft)/(nFDesc*0.5)
        nLin    := mlcount(cDesc,nTamMax)
        nPosIni := nPos
        For i := 1 to nLin
            nPos := (nPos - (nPosIni - nBottom)/nLin)
            If nPos == nBottom 
                MSCBSAY(cInitTitle,nPos+1,memoline(cDesc,nTamMax,i)     ,"N",cValToChar(nFDesc),"1,1")     //Subtitulo
            Else
                MSCBSAY(cInitTitle,nPos,memoline(cDesc,nTamMax,i)     ,"N",cValToChar(nFDesc),"1,1")     //Subtitulo
            EndIf
        Next
    Else
        nPos := nBottom + 1
        MSCBSAY(cInitTitle,nPos,cDesc    ,"N",cValToChar(nFDesc),"1,1")     //Subtitulo
    EndIf

    /*---------------------------------FIM BOX04.02-----------------------------------------*/

    /*---------------------------------BOX05---------------------------------------------*/                        
    nLeft   := 05   //Margem em milímetros a esquerda
    nBottom := 77  //Margem em milímetros do topo
    nRight  := 95   //Margem em milímetros a direita
    nTop    := 89  //Margem em milímetros do final
    nExpess := 1    //Expessura da borda    
    MSCBBOX(nLeft,nBottom,nRight,nTop,nExpess) //Monta Box

    nFDesc          := 2 //Tamanho Fonte Descricão

    cInitTitle      := CalcInit(cDesc,nFDesc,nLeft, nRight, "LEFTBOX")    //Calcula posicao inicio titulo - ESQUERDA

    cDesc := ALLTRIM(_cRecoCons)

    If (Len(cDesc)*nFDesc) > nRight - nLeft
        nTamMax := (nRight - nLeft)/(nFDesc*0.6)
        nLin    := mlcount(cDesc,nTamMax)
        nPos    := nTop
        For i := 1 to nLin
            nPos := (nPos - (nTop - nBottom)/nLin)
            If nPos == nBottom 
                MSCBSAY(cInitTitle,nPos+0.6,memoline(cDesc,nTamMax,i)     ,"N",cValToChar(nFDesc),"1,1")     //Subtitulo
            Else
                MSCBSAY(cInitTitle,nPos,memoline(cDesc,nTamMax,i)     ,"N",cValToChar(nFDesc),"1,1")     //Subtitulo
            EndIf
        Next
    Else
        nPos    := nTop - (((nTop - nBottom)/3)*3)
        MSCBSAY(cInitTitle,nPos,cDesc    ,"N",cValToChar(nFDesc),"1,1")     //Subtitulo
    EndIf

    /*---------------------------------FIM BOX05-----------------------------------------*/

    /*---------------------------------BOX06---------------------------------------------*/                        
    nLeft   := 05   //Margem em milímetros a esquerda
    nBottom := 71  //Margem em milímetros do topo
    nRight  := 95   //Margem em milímetros a direita
    nTop    := 74  //Margem em milímetros do final
    nExpess := 1    //Expessura da borda          
    //MSCBBOX(nLeft,nBottom,nRight,nTop,nExpess) //Monta Box

    nFDesc          := 2 //Tamanho Fonte Descricão

    cInitTitle      := CalcInit(cDesc,nFDesc,nLeft, nRight, "LEFT")    //Calcula posicao inicio titulo - ESQUERDA

    cDesc := ALLTRIM(_CSIF)

    MSCBSAY(cInitTitle,nBottom + 0.1,cDesc     ,"N",cValToChar(nFDesc),"1,1")   //Imprime Titulo


    /*---------------------------------FIM BOX06-----------------------------------------*/

    /*---------------------------------BOX07---------------------------------------------*/                        
    nLeft   := 60   //Margem em milímetros a esquerda
    nBottom := 0  //Margem em milímetros do topo
    nRight  := 99   //Margem em milímetros a direita
    nTop    := 10  //Margem em milímetros do final
    nExpess := 1    //Expessura da borda          
    //MSCBBOX(nLeft,nBottom,nRight,nTop,nExpess) //Monta Box

    nFDesc          := 2 //Tamanho Fonte Descricão

    cInitTitle      := CalcInit(cDesc,nFDesc,nLeft, nRight, "LEFT")    //Calcula posicao inicio titulo - ESQUERDA

    cDesc := ALLTRIM(_cGluten)

    MSCBSAY(cInitTitle,nBottom + 0.1,cDesc     ,"N",cValToChar(nFDesc),"1,1")   //Imprime Titulo


    /*---------------------------------FIM BOX07-----------------------------------------*/
MSCBEND()  
          

MSCBCLOSEPRINTER() //Finaliza a impressão
//msginfo("etiqueta 004")

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
aAdd(aSX1,{"ETQ004","01","Ordem de Producao?"	,""			,""		,"MV_CH1","C",TamSX3("D3_OP")[1]     ,0  ,0   ,"G" ,""  ,"MV_PAR01",""		,""			,""			,"","",""			,""			,""			,"","","","","","","","","","","","","","","","","SC2ETQ"	,"S","","","",""})
aAdd(aSX1,{"ETQ004","02","Produto?"	   			,""			,""		,"MV_CH2","C",TamSX3("D3_COD")[1]    ,0  ,0   ,"G" ,""  ,"MV_PAR02",""		,""			,""			,"","",""			,""			,""			,"","","","","","","","","","","","","","","","","SB1"	,"S","","","",""})
aAdd(aSX1,{"ETQ004","03","Lote?"		   		,""			,""		,"MV_CH3","C",TamSX3("C2_XLOTE")[1]  ,0  ,0   ,"G" ,""  ,"MV_PAR03",""		,""			,""			,"","",""			,""			,""			,"","","","","","","","","","","","","","","","",""		,"S","","","",""})
aAdd(aSX1,{"ETQ004","04","Qtde Etiqueta?"		,""			,""		,"MV_CH4","N",04                     ,0  ,0   ,"G" ,""  ,"MV_PAR04",""		,""			,""			,"","",""			,""			,""			,"","","","","","","","","","","","","","","","",""		,"S","","","",""})
aAdd(aSX1,{"ETQ004","05","Impressora?"			,""			,""		,"MV_CH5","C",TamSX3("CB5_CODIGO")[1],0  ,0   ,"G" ,""  ,"MV_PAR05",""		,""			,""			,"","",""			,""			,""			,"","","","","","","","","","","","","","","","","CB5"	,"S","","","",""})

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


static function CalcInit(cTitle,nFontSize,nLeft, nRight, cPosition)

Local nInit := 0

    DO CASE
    CASE UPPER(cPosition) == "CENTER"
        If nFontSize == 3
            nInit := nLeft + (((nRight - nLeft)-Len(cTitle)*2)/2)
        Elseif nFontSize == 2
            nInit := nLeft +  (((nRight - nLeft)-Len(cTitle)*1.6)/2)
        Elseif nFontSize == 1
            nInit := nLeft +  (((nRight - nLeft)-Len(cTitle)*1.1)/2)
        EndIf
    CASE UPPER(cPosition) == "LEFTBOX"
        nInit := nLeft + 2
    CASE UPPER(cPosition) == "LEFT"
    nInit := nLeft + 0.5
    OTHERWISE
        nInit := nLeft + 0.5
    ENDCASE
return nInit