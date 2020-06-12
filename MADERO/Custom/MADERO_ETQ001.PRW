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
!Nome              ! ETQ001                                                  !
+------------------+---------------------------------------------------------+
!Descricao         ! Rotina Emissão etiqueta 3 CM ADESIVA                    !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 20/05/18                                                !
+------------------+---------------------------------------------------------+
*/
User Function ETQ001(aEtqAuto)
Local  _aArea := GetArea()
Local  _cperg :="ETQ001    "
Local  _cOP:=""
Local  _nQtde:=0
Local  _cImp:=""
Local  _cPROD:=""
Local  _cTpEtq:="001" //Etiqueta 3 cm ADESIVA
Local  _lret:=.T.
Local  _lauto:=.F.
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
				ZIB->(DBSEEK(XFILIAL("ZIB")+(_CALIASSC2)->B1_COD+_cTpEtq))
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
	fEtq001(_cop,_nqtde,_cImp)
Endif

RestArea(_aArea)

Return(nil)
//
*----------------------------------------*
Static function fetq001(_cop,_nqtde,_cimp)
*----------------------------------------*
Local _fim     := chr(13)+chr(10)
Local _nY      :=0
Local _oFile   := Nil
Local _cSaida  := CriaTrab("",.F.)
Local _cPorta  := "LPT1"
Local _CDESC   := IIF(!Empty((_cAliasSC2)->B1_PACAMAP), ALLTRIM(POSICIONE("SX5",1,XFILIAL("SX5")+"Z6"+(_cAliasSC2)->B1_PACAMAP,"X5_DESCRI")), (_cAliasSC2)->B1_DESC)
Local _dPROD   := DTOC(STOD((_cAliasSC2)->C2_XDTFIR))
Local _dVALID  := DTOC(STOD((_cAliasSC2)->C2_XDTVAL))
Local _cINGRED := ALLTRIM(MSMM((_cAliasSC2)->B1_CODPROC))
Local _CINFNUT := ""+ALLTRIM(POSICIONE("SB1",1,XFILIAL("SB1")+(_cAliasSC2)->B1_COD,"B1_XINFNUT"))
Local _cLOTE   := Alltrim(Str(Val((_cAliasSC2)->C2_XLOTE)))
Local _cCons   := IIF(!Empty((_cAliasSC2)->B1_XCONS), ALLTRIM(POSICIONE("SX5",1,XFILIAL("SX5")+"W1"+(_cAliasSC2)->B1_XCONS,"X5_DESCRI")), "")
Local _cGluten := IIF((_cAliasSC2)->B1_XGLUT="1","CONTÉM GLUTEN",IIF((_cAliasSC2)->B1_XGLUT="2","NÃO CONTÉM GLUTEN",""))
Local _cQTDE   := (_cAliasSC2)->B1_TALLA
Local _CDESCD  := ALLTRIM(POSICIONE("SB5",1,XFILIAL("SB5")+(_cAliasSC2)->B1_COD,"B5_CEME"))
Local _CSIF    :="Registro no Ministério da Agricultura SIF/DIPOA sob No." + ALLTRIM(POSICIONE("SB5",1,XFILIAL("SB5")+(_cAliasSC2)->B1_COD,"B5_DES"))
Local _cPESOE  := alltrim(TRANSFORM((_cAliasSC2)->B1_XPEMB, PesqPict("SB1","B1_XPEMB"))) + "Kg"
Local _cRecoCons    := "Recomendações para consumo: Produto exclusivo para preparo nas filiais do Grupo Durski, conforme procedimentos operacionais padrão estabelecido para cada produto, respeitando tempo e temperatura."
    
//
Local cModelo,lTipo,nPortIP,cServer,cEnv,cFila,lrvWin 
Local cPorta :=Nil
Local i

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
// //aadd(texto,"^XA"+_fim)
// //DESCRI??O PRODUTO
// aadd(texto,"^FO20,20"+_fim)
// aadd(texto,"^GB95,650,5,,3^FS"+_fim)
// IF EMPTY(_CDESCD) .or. alltrim(_CDESC)=ALLTRIM(_CDESCD)
// //	aadd(texto,"^CF0,105,105,^FO30,30"+_fim)
// 	aadd(texto,"^FB650,2,,"+_fim)
// 	aadd(texto,"^FO115,650^A0B,30,30^FD"+ALLTRIM(_CDESC)+"^FS"+_fim)
// ELSE
// 	aadd(texto,"^CF0,95,95,^FO25,25"+_fim)
// 	aadd(texto,"^FB650,2,,"+_fim)
// 	aadd(texto,"^FO80,650^A0B,25,25^FD"+ALLTRIM(_CDESCD)+"^FS"+_fim)
// 	//
// 	//aadd(texto,"^CF0,95,95,^FO25,25"+_fim)
// 	//aadd(texto,"^FB650,1,,"+_fim)
// 	aadd(texto,"^FO80,100^A0B,25,25^FD"+SUBSTR(ALLTRIM(_CDESC),1,45)+"^FS"+_fim)
// ENDIF

// //INGREDIENTES------------------------------------------------------
// aadd(texto,"^FO125,20"+_fim)
// aadd(texto,"^GB60,650,5,,3^FS"+_fim)
// aadd(texto,"^CF0,30,30,^FO20,15"+_fim)
// aadd(texto,"^FB650,2,,"+_fim)
// aadd(texto,"^FO175,650^A0B,20,15^FD"+SUBSTR(ALLTRIM(_CINGRED),1,150)+"^FS"+_fim)
// aadd(texto,"^FS"+_fim)
// //FABRICA??O--------------------------------------------------------
// aadd(texto,"^FO195,420"+_fim)
// aadd(texto,"^GB65,260,5,,3^FS"+_fim)
// aadd(texto,"^FO205,460^A0B,25,20^FDPRODUCAO/EMBALAGEM^FS"+_fim)
// aadd(texto,"^FO230,530^A0B,25,20^FD"+_dPROD+"^FS"+_fim)
// //VALIDADE----------------------------------------------------------
// aadd(texto,"^FO195,210"+_fim)
// aadd(texto,"^GB65,200,5,,3^FS"+_fim)
// aadd(texto,"^FO205,235^A0B,25,20^FDDATA DE VALIDADE^FS"+_fim)
// aadd(texto,"^FO230,275^A0B,25,20^FD"+_dVALID+"^FS"+_fim)
// //LOTE--------------------------------------------------------------
// aadd(texto,"^FO195,20"+_fim)
// aadd(texto,"^GB65,180,5,,3^FS"+_fim)
// aadd(texto,"^FO205,105^A0B,25,20^FDLOTE^FS"+_fim)
// aadd(texto,"^FO230,110^A0B,25,20^FD"+_cLOTE+"^FS"+_fim)
// //PESO EMBALAGEM----------------------------------------------------
// aadd(texto,"^FO270,470"+_fim)
// aadd(texto,"^GB70,200,5,,3^FS"+_fim)
// aadd(texto,"^FO280,505^A0B,25,20^FDPESO EMBALAGEM^FS"+_fim)
// aadd(texto,"^FO310,520^A0B,25,20^FD"+_cPESOE+"^FS"+_fim)
// //CONSERVA??O-------------------------------------------------------
// aadd(texto,"^FO270,20"+_fim)
// aadd(texto,"^GB70,440,5,,3^FS"+_fim)
// aadd(texto,"^FO280,155^A0B,25,20^FDMODO DE CONSERVACAO^FS"+_fim)
// aadd(texto,"^FO310,55^A0B,25,20^FD"+_cCONS+"^FS"+_fim)
// //INFORMA??ES NUTRICIONAIS------------------------------------------
// aadd(texto,"^CF0,40,100^FO16,16"+_fim)
// aadd(texto,"^FB660,8,,"+_fim)
// aadd(texto,"^FO375,660^A0B,16,16^FD"+UPPER(_cINFNUT)+"^FS"+_fim)
// aadd(texto,"^FS"+_fim)
// //MENSAGEM SIF-------------------------------------------------------
// aadd(texto,"^FO475,35^A0B,22,22^FD"+ALLTRIM(_CSIF)+"^FS"+_fim)
// //MESAGEM SIF-------------------------------------------------------
// aadd(texto,"^FO790,95^A0B,25,20^FD"+_cGluten+"^FS"+_fim)
// //aadd(texto,	'^PQ' + cValToChar(_nQtde) + ',0,1,Y^XZ'+_fim	)
// //
// //aadd(texto,"^XZ"+_fim)
// //
MSCBPRINTER(cModelo,cPorta,,,lTipo,nPortIP,cServer,cEnv,nBuffer,cFila,lDrvWin,Trim(CB5->CB5_PATH)+"\Etq001")
MSCBCHKSTATUS(CB5->CB5_VERSTA =="1")

MSCBBEGIN(_nQtde,6)  

// For _nY := 1 To Len(texto)
// 	MSCBWRITE(texto[_nY])     
// Next _nY

/*---------------------------------BOX01---------------------------------------------*/     
    // nLeft   := 05   //Margem em mil?metros a esquerda
    // nBottom := 110  //Margem em mil?metros do topo
    // nRight  := 95   //Margem em mil?metros a direita
    // nTop    := 120  //Margem em mil?metros do final
    nLeft   := 02   //Margem em mil?metros a esquerda
    nBottom := 00  //Margem em mil?metros do topo
    nRight  := 12   //Margem em mil?metros a direita
    nTop    := 80  //Margem em mil?metros do final
    nExpess := 1    //Expessura da borda
    MSCBBOX(nLeft,nBottom,nRight,nTop,nExpess) //Monta Box

    nFTitle         := 2 //Tamanho Fonte Titulo
                        
    cTitle          := ALLTRIM(_CDESC)    //String Titulo
    cInitTitle      := CalcInit(cTitle,nFTitle,nBottom, nTop, "CENTER") //Calcula posicao inicio titulo - CENTRO
    MSCBSAY(nRight-4.5,cInitTitle,cTitle     ,"B",cValToChar(nFTitle),"1,1")   //Imprime Titulo

    cTitle          := ALLTRIM(_CDESCD)                    //String Subtitulo
    cInitTitle      := CalcInit(cTitle,nFTitle,nBottom, nTop, "CENTER") //Calcula posicao inicio titulo - CENTRO
    MSCBSAY(nRight-1,cInitTitle,cTitle     ,"B",cValToChar(nFTitle),"1,1")   //Subtitulo
    /*---------------------------------FIM BOX01-----------------------------------------*/      


    /*---------------------------------BOX02---------------------------------------------*/                        
    nLeft   := 13   //Margem em mil?metros a esquerda
    nBottom := 00  //Margem em mil?metros do topo
    nRight  := 20   //Margem em mil?metros a direita
    nTop    := 80  //Margem em mil?metros do final 
    nExpess := 1    //Expessura da borda          
    MSCBBOX(nLeft,nBottom,nRight,nTop,nExpess) //Monta Box

    nFTitle         := 1 //Tamanho Fonte Titulo
    nFDesc          := 1 //Tamanho Fonte Descric?o
 
    cDesc          := ALLTRIM(_CINGRED)
    cInitTitle      := CalcInit(cDesc,nFDesc,nBottom, nTop, "LEFTBOX")    //Calcula posicao inicio titulo - ESQUERDA

    If (Len(cDesc)*nFDesc) > nTop - nBottom
        nTamMax := (nTop - nBottom)/(nFDesc*0.9)
        nLin    := mlcount(cDesc,nTamMax)
        nPos    := nLeft
        For i := 1 to nLin
            nPos := (nPos - (nLeft - nRight)/nLin)
            If nPos == nRight 
                MSCBSAY(nPos-1,cInitTitle,memoline(cDesc,nTamMax,i)     ,"B",cValToChar(nFDesc),"1,1")     //Subtitulo
            Else
                MSCBSAY(nPos-0.3,cInitTitle,memoline(cDesc,nTamMax,i)     ,"B",cValToChar(nFDesc),"1,1")     //Subtitulo
            EndIf
        Next
    Else
        nPos    := nLeft - (((nLeft - nRight)/3)*2)
        MSCBSAY(nPos,cInitTitle,cDesc     ,"B",cValToChar(nFDesc),"1,1")     //Subtitulo
    EndIf
    /*---------------------------------FIM BOX02-----------------------------------------*/

    /*---------------------------------BOX03.01---------------------------------------------*/                        
    nLeft   := 21   //Margem em mil?metros a esquerda
    nBottom := 00   //Margem em mil?metros do topo
    nRight  := 27   //Margem em mil?metros a direita
    nTop    := 25  //Margem em mil?metros do final
    nExpess := 1    //Expessura da borda    
    MSCBBOX(nLeft,nBottom,nRight,nTop,nExpess) //Monta Box

    nFTitle         := 1 //Tamanho Fonte Titulo
    nFDesc          := 2 //Tamanho Fonte Descric?o

    cTitle := "DATA DE PRODUCAO"     
    cInitTitle      := CalcInit(cTitle,nFTitle,nBottom, nTop, "CENTER") //Calcula posicao inicio titulo - CENTRO

    nPos := (nLeft - ((nLeft - nRight)/2))-0.5
    MSCBSAY(nPos,cInitTitle,cTitle,"B",cValToChar(nFTitle),"1,1")     //Titulo

    cDesc := ALLTRIM(_dPROD)
    cInitTitle      := CalcInit(cDesc,nFDesc,nBottom, nTop, "CENTER")
    nPos := nRight - 0.5
    MSCBSAY(nPos,cInitTitle,cDesc,"B",cValToChar(nFDesc),"1,1")     //Subtitulo


    /*---------------------------------FIM BOX03.01-----------------------------------------*/

    /*---------------------------------BOX03.02---------------------------------------------*/                        
    nLeft   := 21   //Margem em mil?metros a esquerda
    nBottom := 26   //Margem em mil?metros do topo
    nRight  := 27   //Margem em mil?metros a direita
    nTop    := 51  //Margem em mil?metros do final
    nExpess := 1    //Expessura da borda    
    MSCBBOX(nLeft,nBottom,nRight,nTop,nExpess) //Monta Box

    nFTitle         := 1 //Tamanho Fonte Titulo
    nFDesc          := 2 //Tamanho Fonte Descric?o

    cTitle := "DATA DE VALIDADE"     
    cInitTitle      := CalcInit(cTitle,nFTitle,nBottom, nTop, "CENTER") //Calcula posicao inicio titulo - CENTRO

    nPos := (nLeft - ((nLeft - nRight)/2))-0.5
    MSCBSAY(nPos,cInitTitle,cTitle,"B",cValToChar(nFTitle),"1,1")     //Titulo

    cDesc := ALLTRIM(_dVALID)
    cInitTitle      := CalcInit(cDesc,nFDesc,nBottom, nTop, "CENTER")
    nPos := nRight - 0.5
    MSCBSAY(nPos,cInitTitle,cDesc,"B",cValToChar(nFDesc),"1,1")     //Subtitulo


    /*---------------------------------FIM BOX03.02-----------------------------------------*/

    /*---------------------------------BOX03.03---------------------------------------------*/                        
    nLeft   := 21   //Margem em mil?metros a esquerda
    nBottom := 52   //Margem em mil?metros do topo
    nRight  := 27   //Margem em mil?metros a direita
    nTop    := 80  //Margem em mil?metros do final
    nExpess := 1    //Expessura da borda    
    MSCBBOX(nLeft,nBottom,nRight,nTop,nExpess) //Monta Box

    nFTitle         := 1 //Tamanho Fonte Titulo
    nFDesc          := 2 //Tamanho Fonte Descric?o

    cTitle := "LOTE"     
    cInitTitle      := CalcInit(cTitle,nFTitle,nBottom, nTop, "CENTER") //Calcula posicao inicio titulo - CENTRO

    nPos := (nLeft - ((nLeft - nRight)/2))-0.5
    MSCBSAY(nPos,cInitTitle,cTitle,"B",cValToChar(nFTitle),"1,1")     //Titulo

    cDesc := ALLTRIM(_cLOTE)
    cInitTitle      := CalcInit(cDesc,nFDesc,nBottom, nTop, "CENTER")
    nPos := nRight - 0.5
    MSCBSAY(nPos,cInitTitle,cDesc,"B",cValToChar(nFDesc),"1,1")     //Subtitulo


    /*---------------------------------FIM BOX03.03-----------------------------------------*/


    /*---------------------------------BOX03.01---------------------------------------------*/                        
    nLeft   := 28   //Margem em mil?metros a esquerda
    nBottom := 00   //Margem em mil?metros do topo
    nRight  := 34   //Margem em mil?metros a direita
    nTop    := 25  //Margem em mil?metros do final
    nExpess := 1    //Expessura da borda    
    MSCBBOX(nLeft,nBottom,nRight,nTop,nExpess) //Monta Box

    nFTitle         := 1 //Tamanho Fonte Titulo
    nFDesc          := 2 //Tamanho Fonte Descric?o

    cTitle := "PESO EMBALAGEM"     
    cInitTitle      := CalcInit(cTitle,nFTitle,nBottom, nTop, "CENTER") //Calcula posicao inicio titulo - CENTRO

    nPos := (nLeft - ((nLeft - nRight)/2))-0.5
    MSCBSAY(nPos,cInitTitle,cTitle,"B",cValToChar(nFTitle),"1,1")     //Titulo

    cDesc := ALLTRIM(_cPESOE)
    cInitTitle      := CalcInit(cDesc,nFDesc,nBottom, nTop, "CENTER")
    nPos := nRight - 0.5
    MSCBSAY(nPos,cInitTitle,cDesc,"B",cValToChar(nFDesc),"1,1")     //Subtitulo


    /*---------------------------------FIM BOX03.01-----------------------------------------*/

    /*---------------------------------BOX03.02---------------------------------------------*/                        
    nLeft   := 28   //Margem em mil?metros a esquerda
    nBottom := 26   //Margem em mil?metros do topo
    nRight  := 34   //Margem em mil?metros a direita
    nTop    := 80  //Margem em mil?metros do final
    nExpess := 1    //Expessura da borda    
    MSCBBOX(nLeft,nBottom,nRight,nTop,nExpess) //Monta Box

    nFTitle         := 1 //Tamanho Fonte Titulo
    nFDesc          := 1 //Tamanho Fonte Descric?o

    cTitle := "MODO DE CONSERVACAO"     
    cInitTitle      := CalcInit(cTitle,nFTitle,nBottom, nTop, "CENTER") //Calcula posicao inicio titulo - CENTRO

    nPos := (nLeft - ((nLeft - nRight)/2))-0.5
    MSCBSAY(nPos,cInitTitle,cTitle,"B",cValToChar(nFTitle),"1,1")     //Titulo

    cDesc := ALLTRIM(_cCONS)
    cInitTitle      := CalcInit(cDesc,nFDesc,nBottom, nTop, "CENTER")
    nPos := nRight - 0.5
    MSCBSAY(nPos,cInitTitle,cDesc,"B",cValToChar(nFDesc),"1,1")     //Subtitulo


    /*---------------------------------FIM BOX03.02-----------------------------------------*/

/*---------------------------------BOX04---------------------------------------------*/                        
    nLeft   := 35   //Margem em mil?metros a esquerda
    nBottom := 00   //Margem em mil?metros do topo
    nRight  := 41   //Margem em mil?metros a direita
    nTop    := 80  //Margem em mil?metros do final
    nExpess := 1    //Expessura da borda    
    MSCBBOX(nLeft,nBottom,nRight,nTop,nExpess) //Monta Box

    nFTitle         := 1 //Tamanho Fonte Titulo
    nFDesc          := 1 //Tamanho Fonte Descric?o
 
    cDesc          := ALLTRIM(_cRecoCons)
    cInitTitle      := CalcInit(cDesc,nFDesc,nBottom, nTop, "LEFTBOX")    //Calcula posicao inicio titulo - ESQUERDA

    If (Len(cDesc)*nFDesc) > nTop - nBottom
        nTamMax := (nTop - nBottom)/(nFDesc*0.9)
        nLin    := mlcount(cDesc,nTamMax)
        nPos    := nLeft
        For i := 1 to nLin
            nPos := (nPos - (nLeft - nRight)/nLin)
            If nPos == nRight 
                MSCBSAY(nPos-0.2,cInitTitle,memoline(cDesc,nTamMax,i)     ,"B",cValToChar(nFDesc),"1,1")     //Subtitulo
            Else
                MSCBSAY(nPos+0.1,cInitTitle,memoline(cDesc,nTamMax,i)     ,"B",cValToChar(nFDesc),"1,1")     //Subtitulo
            EndIf
        Next
    Else
        nPos    := nLeft - (((nLeft - nRight)/3)*2)
        MSCBSAY(nPos,cInitTitle,cDesc     ,"B",cValToChar(nFDesc),"1,1")     //Subtitulo
    EndIf


    /*---------------------------------FIM BOX04-----------------------------------------*/

    /*---------------------------------BOX06---------------------------------------------*/                        
    nLeft   := 42   //Margem em mil?metros a esquerda
    nBottom := 00  //Margem em mil?metros do topo
    nRight  := 56   //Margem em mil?metros a direita
    nTop    := 80  //Margem em mil?metros do final 
    nExpess := 1    //Expessura da borda          
    //MSCBBOX(nLeft,nBottom,nRight,nTop,nExpess) //Monta Box

    nFTitle         := 1 //Tamanho Fonte Titulo
    nFDesc          := 1 //Tamanho Fonte Descric?o
 
    cDesc          := ALLTRIM(_cINFNUT)
    cInitTitle      := CalcInit(cDesc,nFDesc,nBottom, nTop, "LEFTBOX")    //Calcula posicao inicio titulo - ESQUERDA

    If (Len(cDesc)*nFDesc) > nTop - nBottom
        nTamMax := (nTop - nBottom)/(nFDesc*0.9 )
        nLin    := mlcount(cDesc,nTamMax)
        nPos    := nLeft
        For i := 1 to nLin
            nPos := (nPos - (nLeft - nRight)/nLin)
            If nPos == nRight 
                MSCBSAY(nPos-0.5,nBottom+1,memoline(cDesc,nTamMax,i)     ,"B",cValToChar(nFDesc),"1,1")     //Subtitulo
            Else
                MSCBSAY(nPos-0.5,nBottom+1,memoline(cDesc,nTamMax,i)     ,"B",cValToChar(nFDesc),"1,1")     //Subtitulo
            EndIf
        Next
    Else
        nPos    := nLeft - (((nLeft - nRight)/3)*2)
        MSCBSAY(nPos,nBottom+1,cDesc     ,"B",cValToChar(nFDesc),"1,1")     //Subtitulo
    EndIf
    /*---------------------------------FIM BOX06-----------------------------------------*/

    /*---------------------------------BOX08---------------------------------------------*/                        
        nLeft   := 57  //Margem em mil?metros a esquerda
        nBottom := 00  //Margem em mil?metros do topo
        nRight  := 59   //Margem em mil?metros a direita
        nTop    := 80  //Margem em mil?metros do final
        nExpess := 1    //Expessura da borda          

        nFTitle         := 2 //Tamanho Fonte Titulo
        nFDesc          := 2 //Tamanho Fonte Descric?o

        cDesc := ALLTRIM(_CSIF)
        cInitTitle      := CalcInit(cDesc,nFTitle,nBottom, nTop, "LEFTBOX")    //Calcula posicao inicio titulo - ESQUERDA
        nPos := nLeft - (((nLeft - nRight)/3)*3)-0.5
        MSCBSAY(nPos,cInitTitle,cDesc,"B",cValToChar(nFTitle),"1,1")     //Subtitulo
    /*---------------------------------FIM BOX08-----------------------------------------*/

    /*---------------------------------BOX08---------------------------------------------*/                        
        nLeft   := 95  //Margem em mil?metros a esquerda
        nBottom := 47  //Margem em mil?metros do topo
        nRight  := 99   //Margem em mil?metros a direita
        nTop    := 80  //Margem em mil?metros do final
        nExpess := 1    //Expessura da borda      

        nFTitle         := 2 //Tamanho Fonte Titulo
        nFDesc          := 2 //Tamanho Fonte Descric?o

        cDesc := ALLTRIM(_cGluten)
        cInitTitle      := CalcInit(cDesc,nFTitle,nBottom, nTop, "LEFTBOX")    //Calcula posicao inicio titulo - ESQUERDA
        nPos := nLeft - (((nLeft - nRight)/3)*3)-0.5
        MSCBSAY(nPos,cInitTitle,cDesc,"B",cValToChar(nFTitle),"1,1")     //Subtitulo
    /*---------------------------------FIM BOX08-----------------------------------------*/




MSCBEND()  
          

MSCBCLOSEPRINTER() //Finaliza a impress?o

//msginfo("etiqueta 001")

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

static function CalcInit(cTitle,nFontSize,nLeft, nRight, cPosition)

Local nInit := 0

    DO CASE
    CASE UPPER(cPosition) == "CENTER"
        If nFontSize == 3
            nInit := nLeft + (((nRight - nLeft)-Len(cTitle)*2)/2)
        Elseif nFontSize == 2
            nInit := nLeft +  (((nRight - nLeft)-Len(cTitle)*1.4)/2)
        Elseif nFontSize == 1
            nInit := nLeft +  (((nRight - nLeft)-Len(cTitle)*1.2)/2)
        EndIf
    CASE UPPER(cPosition) == "LEFTBOX"
        nInit := nLeft + 2
    CASE UPPER(cPosition) == "LEFT"
    nInit := nLeft + 0.5
    OTHERWISE
        nInit := nLeft + 0.5
    ENDCASE
return nInit