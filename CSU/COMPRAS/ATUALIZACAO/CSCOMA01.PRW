#INCLUDE "Protheus.ch"
#INCLUDE "Rwmake.ch"  
#include "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CSCOMA01 บ Autor ณ Leonardo Soncin    บ Data ณ  18/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Pedidos de Compras                                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico CSU                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CSCOMA01(nFuncao,xAutoCab,xAutoItens,nOpcAuto,lWhenGet)

Local aFixe  := { {"C7_OK"       ,"","  ",""},;
            {"C7_NUM"      ,"","Pedido",""},;
            {"C7_EMISSAO"  ,"","Emissao",""},;
            {"C7_FORNECE"  ,"","Fornecedor",""},;
            {"C7_LOJA"     ,"","Loja",""},;
            {"C7_DESCRI"  ,"","Descricao do Produto",""} }
Local aGrupo 	:= {}
Local cFiltro	:= ""
Local aIndexSC7	:= {}
Private aEntrega  := {}
Private _cMarca   := GetMark()
PRIVATE l120Auto  := ( ValType(xAutoCab)=="A" .And. ValType(xAutoItens) == "A" )
Private cCadastro := "Pedidos de Compras"
PRIVATE bFiltraBrw:= {|| Nil }
PRIVATE aRotina   := menudef()
//						{ { "Pesquisar"   ,'AXPESQUI()' , 0 , 4},;
//						{"Mark/Desmk"      ,'U_MarkD()' , 0 , 4},;
//						{"Visualizar"      ,"A120Pedido",0,2},;
//						{"Elimina Residuo" ,"U_CSC01Res",0,4},;
//						{"Obs. Pedido"     ,"U_CSC01Obs",0,4},;
//						{"Alt. Cond. Pag." ,"U_CSC01ACP",0,4},;
//						{"Informa Entrega" ,"U_CSC01Ent",0,4},;
//						{"Envia p/ Fornec.","U_CSC01Env",0,4} }

PRIVATE nTipoPed  := 1
Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private cString := "SC7"

dbSelectArea("SC7")
dbSetOrder(1)

// Sergio Oliveira em Jan/2007: De acordo com o chamado 202, deve-se filtrar os Pedidos do 
//                              usuario que o gerou:

/*
If nTipoPed==1 //.And. MV_PAR03 == 1
	aGrupo := UsrGrComp(RetCodUsr())
	If ( Ascan(aGrupo,"*") == 0 )
		cFiltro := "C7_FILIAL=='"+xFilial("SC7")+"'.And.(C7_GRUPCOM=='"+Space(Len(SC7->C7_GRUPCOM))+"' "
		aEval(aGrupo,{|x| cFiltro+= ".Or.C7_GRUPCOM=='"+x+"'"})
		cFiltro += ") .And. C7_CONAPRO =='L' .and. C7_ENCER <> 'E' "
	EndIf
EndIf

If !Empty(cFiltro)
	bFiltraBrw := {|| FilBrowse("SC7",@aIndexSC7,@cFiltro) }
	Eval(bFiltraBrw)
EndIf

mBrowse( 6, 1,22,75,"SC7",aFixe,"C7_X_ENVFR",,,,)

*/

If !AllTrim(cUserName) $ GetMV('MV_X_USRPC') // Parametro de excessao de compradores
//	MELHORIA - OS 0295/13	- FILTRO PARA TRAZER O GESTOR PROCUREMENT
	cFiltro := " C7_FILIAL == '"+xFilial('SC7')+"' .And. (C7_USER == '"+__cUserId+"' .OR. C7_X_GPRO== '"+__cUserId+"' ) .And. "
EndIf

DbSelectArea('SC7')
If 'CSCOMA01' $ FunName() // Envia
	cFiltro += " C7_X_ENVFR == ' ' .And. C7_CONAPRO =='L' .And. C7_ENCER <> 'E' .And. C7_QUJE == 0 .And. Empty(C7_RESIDUO) "  
	Set Filter To &cFiltro
	SC7->(DbGoTop())
	While SC7->(!Eof())
		RecLock("SC7",.F.)
		SC7->C7_OK:="  "
		SC7->(MsUnLock())
		SC7->(dbSkip())
	End
	SC7->(DbGoTop())
	MarkBrow("SC7","C7_OK",,aFixe,.f.,_cMarca)
Else                      // Reenvia
	cFiltro += " C7_X_ENVFR # ' ' .And. C7_CONAPRO =='L' .And. C7_ENCER <> 'E' .And. C7_QUJE == 0 .And. Empty(C7_RESIDUO) "  
	Set Filter To &cFiltro
	SC7->(dbGoTop())
	While SC7->(!Eof())
		RecLock("SC7",.F.)
		SC7->C7_OK:="  "
		SC7->(MsUnLock())
		SC7->(dbSkip())
	End
	SC7->(dbGoTop())
	MarkBrow("SC7","C7_OK",,aFixe,.f.,_cMarca)
EndIf

DbSelectArea('SC7')
Set Filter To

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ COM01Lgd บ Autor ณ Leonardo Soncin    บ Data ณ  18/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Legenda                                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa Principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function COM01Lgd()
Local aCor := {}

aAdd(aCor,{"BR_VERDE"   ,"PC Nใo enviado ao fornecedor"})
aAdd(aCor,{"BR_VERMELHO","PC Enviado ao fornecedor"    })

BrwLegenda(cCadastro,OemToAnsi("Legenda"),aCor)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CSC01ACP บ Autor ณ Leonardo Soncin    บ Data ณ  18/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Alteracao da Condicao de Pagamento do Pedido de Compras    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa Principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CSC01ACP()

Local nOpcX := 0
Local aArea := GetArea()
Local cPedido := SC7->C7_NUM  
Local oDlg                    
Private cDescCpA	:= Space(20)
Private cDescCp		:= Space(20)
Private cCondPagAt 	:= CriaVar("C7_COND")
Private cCondPag 	:= CriaVar("C7_COND")

If Empty(SC7->C7_X_ENVFR)
	// Altera CP
	cCondPagAt 	:= SC7->C7_COND
	cDescCpa 	:= Posicione("SE4",1,xFilial("SE4")+SC7->C7_COND,"E4_DESCRI")
	
	DEFINE MSDIALOG oDlg FROM 102 ,43  TO 255,350 TITLE "Altera็ใo - Condi็ใo de Pagamento" Of oMainWnd PIXEL
	
	@ 16,2 TO 40,133 OF oDlg PIXEL LABEL "Cond. Pag. Atual"
	@ 23 ,04  MSGET cCondPagAt Picture PesqPict("SC7","C7_COND") F3 CpoRetF3('C7_COND') Valid CheckSX3('C7_COND',cCondPagAt) When .F. OF oDlg PIXEL SIZE 20,9
	@ 25 ,35  SAY cDescCpA OF oDlg PIXEL SIZE 30,9
	
	@ 46,2 TO 70,133 OF oDlg PIXEL LABEL "Cond. Pag. Nova"
	@ 53 ,04  MSGET cCondPag Picture PesqPict("SC7","C7_COND") F3 CpoRetF3('C7_COND') Valid CheckSX3('C7_COND',cCondPag) OF oDlg PIXEL SIZE 20,9
	@ 55 ,35  SAY cDescCp OF oDlg PIXEL SIZE 30,9
	
	ACTIVATE MSDIALOG oDlg Centered ON INIT EnchoiceBar(oDlg,{|| nOpcX := 1,oDlg:End()},{|| nOpcX := 0,ODlg:End()})
	
	If nOpcX == 1
		
		dbSelectArea("SC7")
		dbSetorder(1)
		//	dbGotop()
		dbSeek(xFilial("SC7")+SC7->C7_NUM)
		While !Eof() .and. SC7->C7_FILIAL == xFilial("SC7") .AND. SC7->C7_NUM == cPedido
			
			// Atualiza SC7
			RecLock("SC7",.F.)
			SC7->C7_COND 	:= cCondPag
			MsUnlock()
			
			dbSkip()
		Enddo
	Endif
	
Else
	// Nao pode alterar CP
	Help(' ', 1, 'NAOPODE',,"Este pedido nใo pode ser alterado."+Chr(13)+Chr(10)+"O mesmo jแ foi enviado ao fornecedor.",1,0)
Endif

RestArea(aArea)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CSC01Obs บ Autor ณ Leonardo Soncin    บ Data ณ  18/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Edicao das Observacoes do Pedido de Compras          	  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa Principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CSC01Obs()

Local oDlg                               
Local nOpcX := 0         
Local cPedido := SC7->C7_NUM          
Local aArea := GetArea()
Private cObs := Criavar("C7_MENOBS")

If Empty(SC7->C7_X_ENVFR)
	// Altera OBS
	
	cObs:= SC7->C7_MENOBS
	
	DEFINE MSDIALOG oDlg FROM 102 ,43  TO 198,380 TITLE "Altera็ใo - Mensagem do Pedido de Compra" Of oMainWnd PIXEL
	
	@ 16,2 TO 40,167 OF oDlg PIXEL LABEL "Mensagem do Pedido"
	@ 25 ,04  MSGET cObs Picture PesqPict("SC7","C7_MENOBS") F3 CpoRetF3('C7_MENOBS') Valid CheckSX3('C7_MENOBS',cObs) OF oDlg PIXEL SIZE 160,09	
	ACTIVATE MSDIALOG oDlg Centered ON INIT EnchoiceBar(oDlg,{|| nOpcX := 1,oDlg:End()},{|| nOpcX := 0,ODlg:End()})
	
	If nOpcX == 1
		
		dbSelectArea("SC7")
		dbSetorder(1)
		dbSeek(xFilial("SC7")+SC7->C7_NUM)
		While !Eof() .and. SC7->C7_FILIAL == xFilial("SC7") .AND. SC7->C7_NUM == cPedido
			
			// Atualiza SC7
			RecLock("SC7",.F.)
			SC7->C7_MENOBS 	:= cObs
			MsUnlock()
			
			dbSkip()
		Enddo
	Endif
	
	
Else
	// Nao pode alterar CP
	Help(' ', 1, 'NAOPODE',,"Este pedido nใo pode ser alterado."+Chr(13)+Chr(10)+"O mesmo jแ foi enviado ao fornecedor.",1,0)
Endif
                        
RestArea(aArea)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CSC01Env บ Autor ณ Leonardo Soncin    บ Data ณ  18/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Envio do Pedido para o Fornecedor (e-mail).          	  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa Principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CSC01Env(paEntreg)
Local cTmp :='cTmp'
Local cPergunta := IIF( 'CSCOMA01' $ FunName(), "Enviar","Reenviar" )
Local aPididus  := {}	

If MsgYesNo("Deseja "+cPergunta+" o(s) Pedido(s)?","Aten็ใo")
 /*  DbSelectArea('SC7')
    DbGoTop()
    While !SC7->(Eof())
        Aadd( aPididus, { SC7->C7_FILIAL, SC7->C7_NUM } )
	    If !Empty( SC7->C7_OK )
			U_Rcomw03()
        Else
			SC7->(DbSkip())
		EndIf
	EndDo			
Endif      */
 
    //INCLUSAO DE QUERY PARA MELHOR PERFORMANCE - OS-3711/12
    DBCLOSEAREA("cTmp")    	
    cQuery:="SELECT DISTINCT C7_NUM FROM SC7050 "
	cQuery+=" WHERE C7_OK!='' "
	cQuery+=" AND C7_ENCER ='' "                //By Douglas - OS 0173/15
	cQuery+=" AND C7_RESIDUO = '' "             //By Douglas - OS 0173/15
	cQuery+=" AND D_E_L_E_T_='' "  
	dbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), cTmp, .F., .T. )
    DBSELECTAREA("cTmp")
	cTmp->(dbGoTop()) 
	//FIM DA QUERY 
	 	
    While !cTmp->(Eof())  
    	cNum:=cTmp->C7_NUM    	
    	DbSelectArea('SC7')  
    	DBSETORDER(1)
    	DBGOTOP()
        DbSeek(xFilial('SC7')+cNum)           
	   	Aadd( aPididus, { SC7->C7_FILIAL, SC7->C7_NUM } )
		U_Rcomw03()  
  	 	DBSELECTAREA("cTmp")            		 
		cTmp->(DbSkip())	
	EndDo
	DBCLOSEAREA("cTmp")			
Endif    // fim da melhoria de perfomance - OS-3711/12    

For _i := 1 To Len( aPididus )
    cExec := " UPDATE " +RetSqlName('SC7')
    cExec += " SET C7_OK = '"+Space( TamSX3('C7_OK')[1] )+"' "
    cExec += " WHERE C7_FILIAL = '"+aPididus[_i][1]+"' "
    cExec += " AND   C7_NUM    = '"+aPididus[_i][2]+"' "
    TcSqlExec( cExec )
Next
oMBrow := GetMBrowse()
//oMBrow:End()
DbSelectArea('SC7')

Return
       
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ CSC01Ent บ Autor ณ Sergio Oliveira    บ Data ณ  Jan/2007   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Permite informar o endereco de entrega no momento do envio บฑฑ
ฑฑบ          ณ do Pedido ao Fornecedor.                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa Principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CSC01Ent()

Local oFont  := TFont():New("Tahoma",9,,,.T.,,,,,.F.) // Com Negrito
Local oMens, oMkwDlg
Private cCodFor   := Space(6), cLoja := Space(02)
Private cNomeFor  := Space(TamSX3('A2_NOME')[1])
Private cEndereco := Space(TamSX3('A2_END')[1])
Private cCidade   := Space(TamSX3('A2_MUN')[1])
Private cUF       := Space(2)
Private cCEP      := Space(TamSX3('A2_CEP')[1])

Define MsDialog oMkwDlg Title cCadastro From 170,072 To 442,734 Of oMainWnd Pixel
@ 002,004 To 130,323 // "Moldura Principal")
@ 028,004 To 130,323 // "Moldura Secundaria")
@ 028,269 To 130,323 // "Moldura Botoes")
@ 049,272 To 113,319 // "Ok - Abandonar")
@ 015,098 Say "Selecao do Endereco de Entrega" Color 8388608 Object oMens SIZE 145,20
@ 038,012 Say "Fornecedor"         Size 45,8
@ 038,066 Say "Nome do Fornecedor" Size 69,8
@ 061,012 Say "Endereco"           Size 47,8
@ 075,012 Say "Cidade"             Size 46,8
@ 076,204 Say "UF"                 Size 11,8
@ 089,012 Say "CEP"                Size 47,8
@ 048,012 Get cCodFor Picture "@!" F3 "SA2" Valid( ValidaFor(cCodFor, cLoja) ) Size 33,10
@ 048,046 Get cLoja  Valid( ValidaFor(cCodFor, cLoja) )  Size 15,10
@ 048,064 Get cNomeFor  Size 189,010 When .f.
@ 061,064 Get cEndereco Size 189,010 When .f.
@ 074,064 Get cCidade   Size 133,010 When .f.
@ 074,222 Get cUF       Size 030,010 When .f.
@ 088,064 Get cCEP      Size 053,010 When .f.
@ 065,277 Button "_Confirmar" Size 36,16 Action( VaiCsu( cCodFor, cLoja, SC7->C7_NUM ), Close( oMkwDlg ) ) 
@ 087,277 Button "_Abandonar" Size 36,16 Action( Close( oMkwDlg ) )

oMens:ofont:=ofont

Activate Dialog oMkwDlg Centered

DbSelectArea('SC7')

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ MarcaBrw ณ Autor ณ Sergio Oliveira       ณ Data ณJan/2007  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescriao ณ Marcar os Pedidos  a serem enviadas.                        ฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ Cscoma01.prw                                               ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function MarcaBrw()

Local _cSelect := "", _cArqDBF := CriaTrab(Nil,.f.)
Private _lVai := .f.

DbSelectArea('SC7')
DbGoTop()
If Eof()
	Aviso('Sem Dados','Nao ha Dados a Serem Enviados.',{'Ok'})
	//_lVai - Retirado para poder compilar na P12
EndIf

Return(_lVai)

User Function MarkD()

aOp  := {"Todos","Atual","Cancelar"}
cTit := "Marcacao x Remarcacao"
cMsg := 'Escolha uma das Opcoes abaixo:'
nOp  := Aviso(cTit,cMsg,aOp)

DbSelectArea('SC7')
IncProc('Estabelecendo Selecao...')
If nOp == 1      // Marcar/Desmarcar todos
    SC7->( DbGoTop() )
	DbGoTop()
	While !Eof()
		RecLock('SC7',.f.)
		If !Empty(SC7->C7_OK)  // Esta Marcado. Desmarcar.
			SC7->C7_OK := '  '
		Else                  // Nao esta Marcado. Marcar.
			SC7->C7_OK := _cMarca
		EndIf
		MsUnLock()
		DbSkip()
	EndDo
ElseIf nOp == 2  // Marcar/Desmarcar somente o Atual
	RecLock('SC7',.f.)
	If !Empty(SC7->C7_OK)  // Esta Marcado. Desmarcar.
		SC7->C7_OK := '  '
	Else                  // Nao esta Marcado. Marcar.
		SC7->C7_OK := _cMarca
	EndIf
	MsUnLock()
Else             // Cancelar
	Return
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณValidaFor ณ Autor ณ Sergio Oliveira       ณ Data ณJan/2007  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescriao ณ Validar o fornecedor escolhido.                             ฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ Cscoma01.prw                                               ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function ValidaFor(pcCodFor, pcLoja)

Local _xChave

SA2->(DbSetOrder(1))

If Empty( pcLoja )
   _xChave := xFilial('SA2')+pcCodFor
Else
   _xChave := xFilial('SA2')+pcCodFor+pcLoja
EndIf 

If SA2->A2_COD # pcCodFor
	If !SA2->( DbSeek( _xChave ) ) .And. !SA2->( DbSeek( xFilial('SA2')+pcCodFor ) )
	   Aviso('Codigo Incorreto','Codigo de fornecedor incorreto.',{'Voltar'})
	   Return( .f. )
	Else
	   If !Empty( SA2->A2_LOJA )
	      cLoja := SA2->A2_LOJA
	   EndIf
	EndIf
Else
	If !Empty( SA2->A2_LOJA )
	   cLoja := SA2->A2_LOJA
	EndIf
EndIf

cNomeFor  := SA2->A2_NOME
cEndereco := SA2->A2_END
cCidade   := SA2->A2_MUN
cUF       := SA2->A2_EST
cCEP      := SA2->A2_CEP

Return( .t. )

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ VaiCSU   ณ Autor ณ Sergio Oliveira       ณ Data ณJan/2007  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescriao ณ Adicionar na matriz o fornecedor + loja escolhido p/ Entre-ณฑฑ
ฑฑณ          ณ ga.                                                        ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ Cscoma01.prw                                               ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function VaiCSU(pcCodFor, pcLoja, pcNum)

If !Empty( pcCodFor )
   _cExec := " UPDATE " +RetSqlName('SC7')
   _cExec += " SET C7_X_FOREN  = '"+pcCodFor+"', C7_X_LJENT = '"+pcLoja+"' "
   _cExec += " WHERE C7_FILIAL = '"+xFilial('SC7')+"' "
   _cExec += " AND   C7_NUM    = '"+pcNum+"' "
   TcSqlExec( _cExec )
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ CSC01RES ณ Autor ณ Sergio Oliveira       ณ Data ณAgo/2007  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescriao ณ Eliminar residuo especifico.                               ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ Cscoma01.prw                                               ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function CSC01Res()

Local aAreaAnt   := GetArea()
Local cTxtBlq    := "Todos os itens dos pedidos selecionados serao eliminados. Deseja prosseguir? "
Private lVai     := .f.
Private lMT235G1 := ExistBlock("MT235G1")

If Aviso("Eliminacao de Residuo",cTxtBlq,;
	{"&Fechar","Prosseguir"},3,"Eliminacao de Residuo",,;
	"PCOLOCK") == 2
	
	ConfSeg()

EndIf

If lVai
				
    SC7->( DbGoTop() )
    While !SC7->( Eof() )
    
         If !Empty(SC7->C7_OK)

			 MA235PC(100, 1, SC7->C7_EMISSAO, SC7->C7_EMISSAO, SC7->C7_NUM, SC7->C7_NUM, "  ", "ZZZZZZZZZZZZZZZ", SC7->C7_FORNECE, SC7->C7_FORNECE, SC7->C7_DATPRF, SC7->C7_DATPRF)
		 
		 EndIf
	     
	     SC7->( DbSkip() )
	
	EndDo
    
	Aviso("Eliminacao de Residuo","Processo executado!",;
	{"&Fechar"},3,"Eliminacao de Residuo",,;
	"PMSAPONT")

EndIf

RestArea(aAreaAnt)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณConfSeg   บAutor  ณ Sergio Oliveira    บ Data ณ  Ago/2007   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Validar se o codigo de seguranca foi digitado corretamente.บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Cscoma01.prw                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ConfSeg()

Local cCodSeg  := Right( CriaTrab( Nil,.f. ),6 )
Local cConfSeg := Space(6)
Local cTxtMens := "Eliminacao de Residuos"
Local oMens1
Local oFont  := TFont():New("Tahoma",8,,,.T.,,,,,.F.) // Com Negrito

Define MsDialog MkwDlg Title "" From 173,165 To 380,565 Of oMainWnd Pixel
@ 000,001 To 104,194
@ 000,001 To 023,194
@ 057,010 To 099,134 Title "Confirme o Codigo de Seguran็a Abaixo:"
@ 020,141 To 104,194
@ 027,147 To 098,190 Title "Op็๕es"
@ 009,013 Say cTxtMens Color 8388608 Object oMens1 Size 174,8
@ 028,008 Say "Se voc๊ deseja eliminar o residuo de todos estes Pedidos"  Size 130,8
@ 035,008 Say "redigite no quadro abaixo o codigo de seguranca que" Size 130,8
@ 042,008 Say "esta sendo exibido ao lado:" Size 69,8
@ 044,082 Get cCodSeg  Picture "@!" Size 45,10 When .f.
@ 073,034 Get cConfSeg Picture "@!" Size 45,10
@ 044,150 Button "_Confirmar" Size 36,16 Action( ConfSeg01(MkwDlg, cCodSeg, cConfSeg) )
@ 066,150 Button "_Abandonar" Size 36,16 Action( lVai := .f., Close( Mkwdlg ) )

oMens1:ofont:=ofont

Activate MsDialog Mkwdlg Centered

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณRctbM01d  บAutor  ณ Sergio Oliveira    บ Data ณ  Ago/2007   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Validar se o codigo de seguranca foi digitado corretamente.บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Cscoma01.prw                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ConfSeg01( poDialogo, pcCodSeg, pcConfSeg, pcCodRateio, pcBusca )

Local cTxtBlq := "Codigo de seguranca invalido. Verifique a sua digitacao."
Local cExec

If pcCodSeg # pcConfSeg
	Aviso("Codigo de Seguranca",cTxtBlq,{"&Fechar"},3,"Confirma็ใo Invแlida",,"PCOLOCK")   
	lVai := .f.
Else
    Close( poDialogo )
    lVai := .t.
EndIf

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MenuDEF  บ Autor ณEduardo de Souza    บ Data ณ12/Jan/2007  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Implementa menu funcional                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Menus                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define Array contendo as Rotinas a executar do programa      ณ
//ณ ----------- Elementos contidos por dimensao ------------     ณ
//ณ 1. Nome a aparecer no cabecalho                              ณ
//ณ 2. Nome da Rotina associada                                  ณ
//ณ 3. Usado pela rotina                                         ณ
//ณ 4. Tipo de Transao a ser efetuada                          ณ
//ณ    1 - Pesquisa e Posiciona em um Banco de Dados             ณ
//ณ    2 - Simplesmente Mostra os Campos                         ณ
//ณ    3 - Inclui registros no Bancos de Dados                   ณ
//ณ    4 - Altera o registro corrente                            ณ
//ณ    5 - Remove o registro corrente do Banco de Dados          ณ
//ณ    3 - Duplica o registro corrente do Banco de Dados         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Static Function MenuDef()
Local aRotina :=		{ { "Pesquisar"   ,'AXPESQUI()' ,0,4},;
						{"Visualizar"      ,"A120Pedido",0,2},;
						{"Mark/Desmk"      ,'U_MarkD()' ,0,4},;
						{"Elimina Residuo" ,"U_CSC01Res",0,4},;
						{"Obs. Pedido"     ,"U_CSC01Obs",0,4},;
						{"Alt. Cond. Pag." ,"U_CSC01ACP",0,4},;
						{"Informa Entrega" ,"U_CSC01Ent",0,4},;
						{"Envia p/ Fornec.","U_CSC01Env",0,4} }

Return aRotina
