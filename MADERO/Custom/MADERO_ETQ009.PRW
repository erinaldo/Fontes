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
!Nome              ! ETQ009                                                  !
+------------------+---------------------------------------------------------+
!Descricao         ! Rotina Emissão etiqueta HAMBURGUER - SIF                !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 20/05/18                                                !
+------------------+---------------------------------------------------------+
*/
User Function ETQ009(aEtqAuto)
Local  _aArea := GetArea()
Local  _cperg :="ETQ009    "
Local  _cOP:=""
Local  _nQtde:=0
Local  _cImp:=""
Local  _cPROD:=""
Local  _cTpEtq:="009" //Etiqueta HAMBURGUER
Local  _lret:=.T.
Local  _lrimp:=.F.
Local i
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
			MSGINFO("Ordem de Producao/Produto/Lote no Cadastrado !!!")
			_lret:=.F.
		Else
			DBSELECTAREA("ZIB")
			DBSETORDER(1)
			ZIB->(DBSEEK(XFILIAL("ZIB")+(_cAliasSC2)->B1_COD+_cTpEtq))
			IF !ZIB->(FOUND())
				MSGINFO("Etiqueta no Cadastrada para este Produto!!")
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
	fEtq009(_cop,_nqtde,_cImp)
Endif

RestArea(_aArea)

Return(nil)
//
*----------------------------------------*
Static function fetq009(_cop,_nqtde,_cimp)
*----------------------------------------*
Local _fim     := chr(13)+chr(10)
Local _n       :=0
Local _oFile   := Nil
Local _cSaida  := CriaTrab("",.F.)
Local _cPorta  := "LPT1"
Local _CDESC   := IIF(!Empty((_cAliasSC2)->B1_PACAMAP), ALLTRIM(POSICIONE("SX5",1,XFILIAL("SX5")+"Z6"+(_cAliasSC2)->B1_PACAMAP,"X5_DESCRI")), (_cAliasSC2)->B1_DESC)
Local _dPROD   :=DTOC(STOD((_cAliasSC2)->C2_XDTFIR))
Local _dVALID  :=DTOC(STOD((_cAliasSC2)->C2_XDTVAL))
Local _cINGRED :=ALLTRIM(MSMM((_cAliasSC2)->B1_CODPROC))
Local _CINFNUT :=""+substr(ALLTRIM(POSICIONE("SB1",1,XFILIAL("SB1")+(_cAliasSC2)->B1_COD,"B1_XINFNUT")),1,800)
Local _cCons   := ALLTRIM(POSICIONE("SX5",1,XFILIAL("SX5")+"W1"+(_cAliasSC2)->B1_XCONS,"X5_DESCRI"))
Local _cGluten :=IIF((_cAliasSC2)->B1_XGLUT="1","CONTM GLUTEN",IIF((_cAliasSC2)->B1_XGLUT="2","NAO CONTM GLUTEN",""))
Local _cLOTE   := Alltrim(Str(Val((_cAliasSC2)->C2_XLOTE)))
Local _cPESOE  :=TRANSFORM((_cAliasSC2)->B1_XPEMB,PesqPict("SB1","B1_XPEMB")) + "Kg"
Local _cPESOL  :=TRANSFORM((_cAliasSC2)->B1_PESO, PesqPict("SB1","B1_PESO"))+ "Kg"
Local _cPESOB  :=TRANSFORM((_cAliasSC2)->B1_PESBRU,PesqPict("SB1","B1_PESBRU"))+"Kg"
Local _cQTDE   := (_cAliasSC2)->B1_TALLA
Local _CDESCD  := ALLTRIM(POSICIONE("SB5",1,XFILIAL("SB5")+(_cAliasSC2)->B1_COD,"B5_CEME"))
Local _CSIF    :="Registro no Ministerio da Agricultura SIF/DIPOA sob No." + ALLTRIM(POSICIONE("SB5",1,XFILIAL("SB5")+(_cAliasSC2)->B1_COD,"B5_DES"))
Local _CDES    := ALLTRIM(POSICIONE("SB5",1,XFILIAL("SB5")+(_cAliasSC2)->B1_COD,"B5_DES"))
Local i
Local _cRecoCons    := "Recomendacões para consumo: Produto exclusivo para preparo nas filiais do Grupo Durski, conforme procedimentos operacionais padrão estabelecido para cada produto, respeitando tempo e temperatura."

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
//
// TEXTO:={}
// //INICIO
// //DESCRIÇÃO PRODUTO
// aadd(texto,"^FO50,40"+_fim)
// aadd(texto,"^GB105,650,5,,3^FS"+_fim)
// //aadd(texto,"^CF0,125,95,^FO35,30"+_fim)
// IF EMPTY(_CDESCD)
// 	aadd(texto,"^CF0,95,95,^FO30,30"+_fim)
// 	aadd(texto,"^FB680,2,,"+_fim)
// 	aadd(texto,"^FO115,680^A0B,30,30^FD"+SUBSTR(ALLTRIM(_CDESC),1,40)+"^FS"+_fim)
// ELSE
// 	aadd(texto,"^CF0,95,95,^FO30,30"+_fim)
// 	aadd(texto,"^FB680,2,,"+_fim)
//  	aadd(texto,"^FO115,680^A0B,30,30^FD"+SUBSTR(ALLTRIM(_CDESCD),1,80)+"^FS"+_fim)
// 	//
//     aadd(texto,"^FO125,65^A0B,30,30^FD"+SUBSTR(ALLTRIM(_CDESC),1,40)+"^FS"+_fim)
// ENDIF  
// //INGREDIENTES------------------------------------------------------
// aadd(texto,"^FO165,40"+_fim)
// aadd(texto,"^GB80,650,5,,3^FS"+_fim)
// aadd(texto,"^CF0,30,30,^FO18,18"+_fim)
// aadd(texto,"^FB680,3,,"+_fim)
// aadd(texto,"^FO215,680^A0B,18,18^FD"+SUBSTR(ALLTRIM(_CINGRED),1,200)+"^FS"+_fim)
// aadd(texto,"^FS"+_fim)
// //CONSERVAÇÃO-------------------------------------------------------
// aadd(texto,"^FO250,95^A0B,25,25^FD"+_cCONS+"^FS"+_fim)
// //FABRICAÇÃO--------------------------------------------------------
// aadd(texto,"^FO295,495^A0B,25,20^FDDATA DE PRODUCAO^FS"+_fim)
// aadd(texto,"^FO320,470"+_fim)
// aadd(texto,"^GB60,220,5,,3^FS"+_fim)
// aadd(texto,"^FO335,500^A0B,30,30^FD"+_dPROD+"^FS"+_fim)
// //VALIDADE----------------------------------------------------------
// aadd(texto,"^FO295,255^A0B,25,20^FDDATA DE VALIDADE^FS"+_fim)
// aadd(texto,"^FO320,235"+_fim)
// aadd(texto,"^GB60,220,5,,3^FS"+_fim)
// aadd(texto,"^FO335,275^A0B,30,30^FD"+_dVALID+"^FS"+_fim)
// //LOTE--------------------------------------------------------------
// aadd(texto,"^FO295,125^A0B,25,20^FDLOTE^FS"+_fim)
// aadd(texto,"^FO320,40"+_fim)
// aadd(texto,"^GB60,180,5,,3^FS"+_fim)
// aadd(texto,"^FO335,160^A0B,30,30^FD"+_cLOTE+"^FS"+_fim)
// //QUANTIDADE----------------------------------------------------
// aadd(texto,"^FO385,535^A0B,25,20^FDQUANTIDADE^FS"+_fim)
// aadd(texto,"^FO410,500"+_fim)
// aadd(texto,"^GB60,190,5,,3^FS"+_fim)
// aadd(texto,"^FO430,540^A0B,30,30^FD"+_cQTDE+"^FS"+_fim)
// //PESO BRUTO--------------------------------------------------------
// aadd(texto,"^FO385,315^A0B,25,20^FDPESO BRUTO^FS"+_fim)
// aadd(texto,"^FO410,270"+_fim)
// aadd(texto,"^GB60,215,5,,3^FS"+_fim)
// aadd(texto,"^FO430,300^A0B,30,30^FD"+_cPESOB+"^FS"+_fim)
// //PESO LIQUIDO-------------------------------------------------------
// aadd(texto,"^FO385,80^A0B,25,20^FDPESO LIQUIDO^FS"+_fim)
// aadd(texto,"^FO410,40"+_fim)
// aadd(texto,"^GB60,215,5,,3^FS"+_fim)
// aadd(texto,"^FO430,80^A0B,30,30^FD"+_cPESOL+"^FS"+_fim)
// //INFORMAÇÕES NUTRICIONAIS------------------------------------------
// aadd(texto,"^CF0,40,100^FO20,25"+_fim)
// aadd(texto,"^FB680,10,,"+_fim)
// aadd(texto,"^FO510,680^A0B,18,18^FD"+_cINFNUT+"^FS"+_fim)
// //QRCODE
// //aadd(texto,"^FS"+_fim)
// //aadd(texto,"^FO520,400" +_fim)
// //aadd(texto,"^BQN,2,10"+_fim)
// //aadd(texto,"^FDMM,A"+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SB1->B1_COD+SC2->C2_XLOTE+"^FS"+_fim)
// //aadd(texto,"^FS"+_fim)
// //MESAGEM COMP-------------------------------------------------------
// aadd(texto,"^FO650,45^A0B,25,25^FD"+_cGluten+"^FS"+_fim)
// //CODIGO DO PRODUTO
// aadd(texto,"^FO700,45^A0B,25,25^FDPRODUTO:"+ALLTRIM((_cAliasSC2)->B1_COD)+"^FS"+_fim)
// //MESAGEM SIF-------------------------------------------------------
// aadd(texto,"^FO760,45^A0B,25,22^FD"+ALLTRIM(_CSIF)+"^FS"+_fim)
// //
//
MSCBPRINTER(cModelo,cPorta,,,lTipo,nPortIP,cServer,cEnv,nBuffer,cFila,lDrvWin,Trim(CB5->CB5_PATH)+"\ETQ009")
MSCBCHKSTATUS(CB5->CB5_VERSTA =="1")

MSCBBEGIN(_nQtde,6)  

// For _nY := 1 To Len(texto)
// 	MSCBWRITE(texto[_nY])     
// Next _nY

/*---------------------------------BOX01---------------------------------------------*/     
    // nLeft   := 05   //Margem em milímetros a esquerda
    // nBottom := 110  //Margem em milímetros do topo
    // nRight  := 95   //Margem em milímetros a direita
    // nTop    := 120  //Margem em milímetros do final
    nLeft   := 07   //Margem em milímetros a esquerda
    nBottom := 70  //Margem em milímetros do topo
    nRight  := 17   //Margem em milímetros a direita
    nTop    := 150  //Margem em milímetros do final
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
    nLeft   := 18   //Margem em milímetros a esquerda
    nBottom := 70  //Margem em milímetros do topo
    nRight  := 28   //Margem em milímetros a direita
    nTop    := 150  //Margem em milímetros do final 
    nExpess := 1    //Expessura da borda          
    MSCBBOX(nLeft,nBottom,nRight,nTop,nExpess) //Monta Box

    nFTitle         := 2 //Tamanho Fonte Titulo
    nFDesc          := 2 //Tamanho Fonte Descricão
 
    cDesc          := ALLTRIM(_CINGRED)
    cInitTitle      := CalcInit(cDesc,nFDesc,nBottom, nTop, "LEFTBOX")    //Calcula posicao inicio titulo - ESQUERDA

    If (Len(cDesc)*nFDesc) > nTop - nBottom
        nTamMax := (nTop - nBottom)/(nFDesc*0.58)
        nLin    := mlcount(cDesc,nTamMax)
        nPos    := nLeft
        For i := 1 to nLin
            nPos := (nPos - (nLeft - nRight)/nLin)
            If nPos == nRight 
                MSCBSAY(nPos-1,cInitTitle,memoline(cDesc,nTamMax,i)     ,"B",cValToChar(nFDesc),"1,1")     //Subtitulo
            Else
                MSCBSAY(nPos-0.5,cInitTitle,memoline(cDesc,nTamMax,i)     ,"B",cValToChar(nFDesc),"1,1")     //Subtitulo
            EndIf
        Next
    Else
        nPos    := nLeft - (((nLeft - nRight)/3)*2)
        MSCBSAY(nPos,cInitTitle,cDesc     ,"B",cValToChar(nFDesc),"1,1")     //Subtitulo
    EndIf
    /*---------------------------------FIM BOX02-----------------------------------------*/

    /*---------------------------------BOX03---------------------------------------------*/                        
    nLeft   := 29  //Margem em milímetros a esquerda
    nBottom := 70  //Margem em milímetros do topo
    nRight  := 32   //Margem em milímetros a direita
    nTop    := 150  //Margem em milímetros do final
    nExpess := 1    //Expessura da borda          

    nFTitle         := 2 //Tamanho Fonte Titulo
    nFDesc          := 2 //Tamanho Fonte Descricão

    cDesc := _cCons
    cInitTitle      := CalcInit(cDesc,nFTitle,nBottom, nTop, "CENTER")    //Calcula posicao inicio titulo - ESQUERDA
    nPos := nLeft - (((nLeft - nRight)/3)*3)-0.5
    MSCBSAY(nPos,cInitTitle,cDesc,"B",cValToChar(nFTitle),"1,1")     //Subtitulo
    /*---------------------------------FIM BOX03-----------------------------------------*/

    /*---------------------------------BOX04.01---------------------------------------------*/                        
    nLeft   := 33   //Margem em milímetros a esquerda
    nBottom := 70   //Margem em milímetros do topo
    nRight  := 40   //Margem em milímetros a direita
    nTop    := 95  //Margem em milímetros do final
    nExpess := 1    //Expessura da borda    
    MSCBBOX(nLeft,nBottom,nRight,nTop,nExpess) //Monta Box

    nFTitle         := 1 //Tamanho Fonte Titulo
    nFDesc          := 2 //Tamanho Fonte Descricão

    cTitle := "DATA DE PRODUCAO"     
    cInitTitle      := CalcInit(cTitle,nFTitle,nBottom, nTop, "CENTER") //Calcula posicao inicio titulo - CENTRO

    nPos := (nLeft - ((nLeft - nRight)/2))-0.5
    MSCBSAY(nPos,cInitTitle,cTitle,"B",cValToChar(nFTitle),"1,1")     //Titulo

    cDesc := ALLTRIM(_dPROD)
    cInitTitle      := CalcInit(cDesc,nFDesc,nBottom, nTop, "CENTER")
    nPos := nRight - 1
    MSCBSAY(nPos,cInitTitle,cDesc,"B",cValToChar(nFDesc),"1,1")     //Subtitulo


    /*---------------------------------FIM BOX04.01-----------------------------------------*/

    /*---------------------------------BOX04.02---------------------------------------------*/                        
    nLeft   := 33   //Margem em milímetros a esquerda
    nBottom := 96   //Margem em milímetros do topo
    nRight  := 40   //Margem em milímetros a direita
    nTop    := 121  //Margem em milímetros do final
    nExpess := 1    //Expessura da borda    
    MSCBBOX(nLeft,nBottom,nRight,nTop,nExpess) //Monta Box

    nFTitle         := 1 //Tamanho Fonte Titulo
    nFDesc          := 2 //Tamanho Fonte Descricão

    cTitle := "DATA DE VALIDADE"     
    cInitTitle      := CalcInit(cTitle,nFTitle,nBottom, nTop, "CENTER") //Calcula posicao inicio titulo - CENTRO

    nPos := (nLeft - ((nLeft - nRight)/2))-0.5
    MSCBSAY(nPos,cInitTitle,cTitle,"B",cValToChar(nFTitle),"1,1")     //Titulo

    cDesc := ALLTRIM(_dVALID)
    cInitTitle      := CalcInit(cDesc,nFDesc,nBottom, nTop, "CENTER")
    nPos := nRight - 1
    MSCBSAY(nPos,cInitTitle,cDesc,"B",cValToChar(nFDesc),"1,1")     //Subtitulo


    /*---------------------------------FIM BOX04.02-----------------------------------------*/

    /*---------------------------------BOX04.03---------------------------------------------*/                        
    nLeft   := 33   //Margem em milímetros a esquerda
    nBottom := 122   //Margem em milímetros do topo
    nRight  := 40   //Margem em milímetros a direita
    nTop    := 150  //Margem em milímetros do final
    nExpess := 1    //Expessura da borda    
    MSCBBOX(nLeft,nBottom,nRight,nTop,nExpess) //Monta Box

    nFTitle         := 1 //Tamanho Fonte Titulo
    nFDesc          := 2 //Tamanho Fonte Descricão

    cTitle := "LOTE"     
    cInitTitle      := CalcInit(cTitle,nFTitle,nBottom, nTop, "CENTER") //Calcula posicao inicio titulo - CENTRO

    nPos := (nLeft - ((nLeft - nRight)/2))-0.5
    MSCBSAY(nPos,cInitTitle,cTitle,"B",cValToChar(nFTitle),"1,1")     //Titulo

    cDesc := ALLTRIM(_cLOTE)
    cInitTitle      := CalcInit(cDesc,nFDesc,nBottom, nTop, "CENTER")
    nPos := nRight - 1
    MSCBSAY(nPos,cInitTitle,cDesc,"B",cValToChar(nFDesc),"1,1")     //Subtitulo


    /*---------------------------------FIM BOX04.03-----------------------------------------*/


/*---------------------------------BOX05.01---------------------------------------------*/                        
    nLeft   := 41   //Margem em milímetros a esquerda
    nBottom := 70   //Margem em milímetros do topo
    nRight  := 48   //Margem em milímetros a direita
    nTop    := 95  //Margem em milímetros do final
    nExpess := 1    //Expessura da borda    
    MSCBBOX(nLeft,nBottom,nRight,nTop,nExpess) //Monta Box

    nFTitle         := 1 //Tamanho Fonte Titulo
    nFDesc          := 2 //Tamanho Fonte Descricão

    cTitle := "QUANTIDADE"     
    cInitTitle      := CalcInit(cTitle,nFTitle,nBottom, nTop, "CENTER") //Calcula posicao inicio titulo - CENTRO

    nPos := (nLeft - ((nLeft - nRight)/2))-0.5
    MSCBSAY(nPos,cInitTitle,cTitle,"B",cValToChar(nFTitle),"1,1")     //Titulo

    cDesc := ALLTRIM(_cQTDE)
    cInitTitle      := CalcInit(cDesc,nFDesc,nBottom, nTop, "CENTER")
    nPos := nRight - 1
    MSCBSAY(nPos,cInitTitle,cDesc,"B",cValToChar(nFDesc),"1,1")     //Subtitulo


    /*---------------------------------FIM BOX05.01-----------------------------------------*/

    /*---------------------------------BOX05.02---------------------------------------------*/                        
    nLeft   := 41   //Margem em milímetros a esquerda
    nBottom := 96   //Margem em milímetros do topo
    nRight  := 48   //Margem em milímetros a direita
    nTop    := 121  //Margem em milímetros do final
    nExpess := 1    //Expessura da borda    
    MSCBBOX(nLeft,nBottom,nRight,nTop,nExpess) //Monta Box

    nFTitle         := 1 //Tamanho Fonte Titulo
    nFDesc          := 2 //Tamanho Fonte Descricão

    cTitle := "PESO BRUTO"     
    cInitTitle      := CalcInit(cTitle,nFTitle,nBottom, nTop, "CENTER") //Calcula posicao inicio titulo - CENTRO

    nPos := (nLeft - ((nLeft - nRight)/2))-0.5
    MSCBSAY(nPos,cInitTitle,cTitle,"B",cValToChar(nFTitle),"1,1")     //Titulo

    cDesc := ALLTRIM(_cPESOB)
    cInitTitle      := CalcInit(cDesc,nFDesc,nBottom, nTop, "CENTER")
    nPos := nRight - 1
    MSCBSAY(nPos,cInitTitle,cDesc,"B",cValToChar(nFDesc),"1,1")     //Subtitulo


    /*---------------------------------FIM BOX05.02-----------------------------------------*/

    /*---------------------------------BOX05.03---------------------------------------------*/                        
    nLeft   := 41   //Margem em milímetros a esquerda
    nBottom := 122   //Margem em milímetros do topo
    nRight  := 48   //Margem em milímetros a direita
    nTop    := 150  //Margem em milímetros do final
    nExpess := 1    //Expessura da borda    
    MSCBBOX(nLeft,nBottom,nRight,nTop,nExpess) //Monta Box

    nFTitle         := 1 //Tamanho Fonte Titulo
    nFDesc          := 2 //Tamanho Fonte Descricão

    cTitle := "PESO LIQUIDO"     
    cInitTitle      := CalcInit(cTitle,nFTitle,nBottom, nTop, "CENTER") //Calcula posicao inicio titulo - CENTRO

    nPos := (nLeft - ((nLeft - nRight)/2))-0.5
    MSCBSAY(nPos,cInitTitle,cTitle,"B",cValToChar(nFTitle),"1,1")     //Titulo

    cDesc := ALLTRIM(_cPESOL)
    cInitTitle      := CalcInit(cDesc,nFDesc,nBottom, nTop, "CENTER")
    nPos := nRight - 1
    MSCBSAY(nPos,cInitTitle,cDesc,"B",cValToChar(nFDesc),"1,1")     //Subtitulo


    /*---------------------------------FIM BOX05.03-----------------------------------------*/

    /*---------------------------------BOX06---------------------------------------------*/                        
    nLeft   := 49   //Margem em milímetros a esquerda
    nBottom := 70  //Margem em milímetros do topo
    nRight  := 69   //Margem em milímetros a direita
    nTop    := 150  //Margem em milímetros do final 
    nExpess := 1    //Expessura da borda          
    //MSCBBOX(nLeft,nBottom,nRight,nTop,nExpess) //Monta Box

    nFTitle         := 1 //Tamanho Fonte Titulo
    nFDesc          := 1 //Tamanho Fonte Descricão
 
    cDesc          := ALLTRIM(_cINFNUT)
    cInitTitle      := CalcInit(cDesc,nFDesc,nBottom, nTop, "LEFTBOX")    //Calcula posicao inicio titulo - ESQUERDA

    If (Len(cDesc)*nFDesc) > nTop - nBottom
        nTamMax := (nTop - nBottom)/(nFDesc*0.9 )
        nLin    := mlcount(cDesc,nTamMax)
        nPos    := nLeft
        For i := 1 to nLin
            nPos := (nPos - (nLeft - nRight)/nLin)
            If nPos == nRight 
                MSCBSAY(nPos-1,nBottom+1,memoline(cDesc,nTamMax,i)     ,"B",cValToChar(nFDesc),"1,1")     //Subtitulo
            Else
                MSCBSAY(nPos-0.5,nBottom+1,memoline(cDesc,nTamMax,i)     ,"B",cValToChar(nFDesc),"1,1")     //Subtitulo
            EndIf
        Next
    Else
        nPos    := nLeft - (((nLeft - nRight)/3)*2)
        MSCBSAY(nPos,nBottom+1,cDesc     ,"B",cValToChar(nFDesc),"1,1")     //Subtitulo
    EndIf
    /*---------------------------------FIM BOX06-----------------------------------------*/

    /*---------------------------------BOX07---------------------------------------------*/                        
        nLeft   := 80  //Margem em milímetros a esquerda
        nBottom := 105  //Margem em milímetros do topo
        nRight  := 84   //Margem em milímetros a direita
        nTop    := 150  //Margem em milímetros do final
        nExpess := 1    //Expessura da borda          

        nFTitle         := 2 //Tamanho Fonte Titulo
        nFDesc          := 2 //Tamanho Fonte Descricão

        cDesc := "PRODUTO: "+ ALLTRIM((_cAliasSC2)->B1_COD) 
        cInitTitle      := CalcInit(cDesc,nFTitle,nBottom, nTop, "LEFTBOX")    //Calcula posicao inicio titulo - ESQUERDA
        nPos := nLeft - (((nLeft - nRight)/3)*3)-0.5
        MSCBSAY(nPos,cInitTitle,cDesc,"B",cValToChar(nFTitle),"1,1")     //Subtitulo
    /*---------------------------------FIM BOX07-----------------------------------------*/

    /*---------------------------------BOX08---------------------------------------------*/                        
        nLeft   := 90  //Margem em milímetros a esquerda
        nBottom := 70  //Margem em milímetros do topo
        nRight  := 94   //Margem em milímetros a direita
        nTop    := 150  //Margem em milímetros do final
        nExpess := 1    //Expessura da borda          

        nFTitle         := 2 //Tamanho Fonte Titulo
        nFDesc          := 2 //Tamanho Fonte Descricão

        cDesc := ALLTRIM(_CSIF)
        cInitTitle      := CalcInit(cDesc,nFTitle,nBottom, nTop, "LEFTBOX")    //Calcula posicao inicio titulo - ESQUERDA
        nPos := nLeft - (((nLeft - nRight)/3)*3)-0.5
        MSCBSAY(nPos,cInitTitle,cDesc,"B",cValToChar(nFTitle),"1,1")     //Subtitulo
    /*---------------------------------FIM BOX08-----------------------------------------*/


MSCBEND()  
          

MSCBCLOSEPRINTER() //Finaliza a impressão

//msginfo("etiqueta 009")


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
aAdd(aSX1,{"ETQ009","01","Ordem de Producao?"	,""			,""		,"MV_CH1","C",TamSX3("D3_OP")[1]     ,0  ,0   ,"G" ,""  ,"MV_PAR01",""		,""			,""			,"","",""			,""			,""			,"","","","","","","","","","","","","","","","","SC2ETQ"	,"S","","","",""})
aAdd(aSX1,{"ETQ009","02","Produto?"	   			,""			,""		,"MV_CH2","C",TamSX3("D3_COD")[1]    ,0  ,0   ,"G" ,""  ,"MV_PAR02",""		,""			,""			,"","",""			,""			,""			,"","","","","","","","","","","","","","","","","SB1"	,"S","","","",""})
aAdd(aSX1,{"ETQ009","03","Lote?"		   		,""			,""		,"MV_CH3","C",TamSX3("C2_XLOTE")[1]  ,0  ,0   ,"G" ,""  ,"MV_PAR03",""		,""			,""			,"","",""			,""			,""			,"","","","","","","","","","","","","","","","",""		,"S","","","",""})
aAdd(aSX1,{"ETQ009","04","Qtde Etiqueta?"		,""			,""		,"MV_CH4","N",04                     ,0  ,0   ,"G" ,""  ,"MV_PAR04",""		,""			,""			,"","",""			,""			,""			,"","","","","","","","","","","","","","","","",""		,"S","","","",""})
aAdd(aSX1,{"ETQ009","05","Impressora?"			,""			,""		,"MV_CH5","C",TamSX3("CB5_CODIGO")[1],0  ,0   ,"G" ,""  ,"MV_PAR05",""		,""			,""			,"","",""			,""			,""			,"","","","","","","","","","","","","","","","","CB5"	,"S","","","",""})

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