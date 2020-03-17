#INCLUDE "FATA070.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH" 

#DEFINE NTAMCOD 2

//Campos de Filtros do CRM.
#DEFINE NFILIAL         1
#DEFINE NVEND         2
#DEFINE NIDESTN         3
#DEFINE NNVESTN         4

Static aCodInt    := {}    // Controle de codigo inteligente

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Array contendo as Rotinas a executar do programa      ³
//³ ----------- Elementos contidos por dimensao ------------     ³
//³ 1. Nome a aparecer no cabecalho                              ³
//³ 2. Nome da Rotina associada                                  ³        
//³ 3. Usado pela rotina                                         ³
//³ 4. Tipo de Transacao a ser efetuada                          ³
//³    1 - Pesquisa e Posiciona em um Banco de Dados             ³
//³    2 - Simplesmente Mostra os Campos                         ³
//³    3 - Inclui registros no Bancos de Dados                   ³
//³    4 - Altera o registro corrente                            ³
//³    5 - Remove o registro corrente do Banco de Dados          ³
//³    6 - Alteracao sem inclusao de registro                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³FATA070   ³ Autor ³ Vendas CRM            ³ Data ³13/02/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Manutencao da Estrutura de Vendas                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FATA070( ExpL1, [ ExpC1 ], [ ExpC2 ] )                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpL1 -> Indica se e visualizacao                          ³±±
±±³          ³ ExpC1 -> Indica o grupo de inicio ( visualizacao parcial ) ³±±
±±³          ³ ExpC2 -> Representante a posicionar                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function FATA070( lVis, cStartGroup, cTreeSeek )
      
Private cCadastro     := OemToAnsi(STR0010)    //"Estrutura de Vendas"
Private lVisual       := .F.

Static  lPrcDgt                                //Indica se houve manutencao na estrutura
Static     aVendProc                            //Vendedores que serao reprocessados na ADL
Static     aVendExc                            //Vendedores que serao excluidos da ADL

lPrcDgt        := .F.
aVendProc    := {}
aVendExc    := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o start da visualizacao e padrao ou eh visualizacao parcial  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ValType( cStartGroup ) == "C"
    lVis := .T.
Else     
    cStartGroup := "MAINGR" 
EndIf 

lVisual := If( ValType( lVis ) == "L", lVis, .F. ) 

FT070Cons( cStartGroup, cTreeSeek ) 

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³Ft070Cons ³ Autor ³ Vendas CRM            ³ Data ³13/02/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Consulta as Metas de Venda por data.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .t.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 : Alias                                              ³±±
±±³          ³ ExpN1 : Registro                                           ³±±
±±³          ³ ExpN2 : Opcao                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function Ft070Cons( cStartGroup, cTreeSeek )

Local aArea         := GetArea()
Local aSizeAut      := MsAdvSize( .F. )
Local aObjects      := {}
Local aInfo         := {}
Local aObj          := {}
Local aUnVenAtu     := {}
Local aUnVendaExc    := {}
Local cDesc         := ""
Local cChave        := ""
Local cLast         := ""
Local cQuery        := ""
Local cVar          := ""
Local cMainPref    := ""
Local nX            := 0
Local nY            := 0
Local nOpca        := 0
Local oDlg
Local oTree
Local oMenu
Local oCombo
Local oOpc
Local lNewBntUsr    := ExistBlock("FT70NEWBTN")
Local cHoraIn        := ""                                //Hora de inicio do processamento
Local dDataIn        := CtoD("")                              //Data de inicio do processamento
Local lRpAdl        := SuperGetMV("MV_FTRPEST",,.T.)    //Indica se deve processar as contas ao alterar a estrutura

cTreeSeek := If( ValType( cTreeSeek ) == "C", cTreeSeek, "" ) 

PRIVATE aGrupoAtu    := {}
PRIVATE aGrupoExc    := {}                   
PRIVATE aGrupoBmp    := { "FOLDER5", "FOLDER6" }
PRIVATE lMoved       := .F. 
PRIVATE aGrupoVen    := {}
PRIVATE aGrupoVenExc := {}   

cStartGroup := If( ValType( cStartGroup ) == "C", cStartGroup, "MAINGR" ) 
cMainPref  := If( cStartGroup == "MAINGR", "0MA", "2GR" ) 

aGrupoBmp := { "BMPGROUP", "BMPGROUP" } 

AAdd( aObjects, { 100, 100, .T., .T. } ) 
AAdd( aObjects, {  70, 100, .F., .T. } ) 

aInfo := { aSizeAut[1], aSizeAut[2], aSizeAut[3], aSizeAut[4], 3, 3 } 
aObj  := MsObjSize( aInfo, aObjects, , .T. ) 

DEFINE MSDIALOG oDlg FROM aSizeAut[7],00 TO aSizeAut[6],aSizeAut[5] TITLE cCadastro OF oMainWnd PIXEL 

oTree := DbTree():New( aObj[1,1], aObj[1,2], aObj[1,3], aObj[1,4],oDlg,,,.T.)                   

If cMainPref == "0MA"
    oTree:AddItem( PADR( STR0010, 100 ), "0MA-MAINGR", "FOLDER5","FOLDER5",,,2) //"Estrutura de vendas"
Else
    oTree:AddItem( PADR( STR0010, 100 ), "2GR-"+cStartGroup, "FOLDER5","FOLDER5",,,2) //"Estrutura de vendas"
EndIf

@ aObj[2,1] - 1, aObj[2,2] TO aObj[2,3], aObj[2,4] PIXEL 
         
nLin := aObj[2,1] +  8 
nCol := aObj[2,2] + 10 
 
MENU oMenu POPUP 
    MENUITEM STR0011 Action FT070Menu( @oTree, "INCRP", oMenu, @aUnVenAtu,@aUnVendaExc )      //"Anexa representante"
    MENUITEM STR0012 Action FT070Menu( @oTree, "EXCRP", oMenu, @aUnVenAtu,@aUnVendaExc )      //"Exclui representante"
    MENUITEM STR0013 Action FT070Menu( @oTree, "VISUA", oMenu, @aUnVenAtu,@aUnVendaExc )      //"Visualiza"
    MENUITEM STR0014 Action FT070Menu( @oTree, "INCGR", oMenu, @aUnVenAtu,@aUnVendaExc )      //"Anexa grupo"
    MENUITEM STR0015 Action FT070Menu( @oTree, "EXCGR", oMenu, @aUnVenAtu,@aUnVendaExc )      //"Exclui grupo"
      MENUITEM STR0040 Action FT070Menu( @oTree, "UNIVE", oMenu, @aUnVenAtu,@aUnVendaExc )      //"Unidade de Vendas"
    MENUITEM STR0041 Action FT070Menu( @oTree, "EXUNIVEN", oMenu, @aUnVenAtu,@aUnVendaExc )   //"Exclui Unidade de Vendas"
    MENUITEM STR0016 Action FT070Pesq( @oTree )       //"Pesquisa"
    
    If lNewBntUsr
         ExecBlock("FT70NEWBTN",.F.,.F.,{oMenu,oTree})
    EndIf
    
ENDMENU

oTree:bRClicked  := { |o,x,y| FT070MAct( o, x, y, oMenu ) } // Posição x,y em relação a Dialog 

@ aObj[2,1] + 24, aObj[2,4] - 32 BUTTON oOpc PROMPT STR0017 ACTION FT070MAct( oTree, oOpc:nRight - 5, oOpc:nTop - 118, oMenu ) SIZE 27, 12 OF oDlg PIXEL  //"Opcoes"

DEFINE SBUTTON FROM aObj[2,1] + 7, aObj[2,4] - 65 TYPE 1 ENABLE OF oDlg ACTION ( nOpca := 1, oDlg:End() )
DEFINE SBUTTON FROM aObj[2,1] + 7, aObj[2,4] - 33 TYPE 2 ENABLE OF oDlg ACTION ( nOpca := 0, oDlg:End() )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chama a rotina de construcao do Tree                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Processa( { || FT070Monta( @oTree, cStartGroup,@aUnVenAtu,@aUnVendaExc ) }, ,STR0018 )  //"Construindo estrutura..."

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona no usuario desejado                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty( cTreeSeek ) 
    oTree:TreeSeek( "1US-" + cTreeSeek ) 
EndIf     

ACTIVATE MSDIALOG oDlg ON INIT Eval(oTree:bChange)

If nOpca == 1 .AND. !lVisual .AND. lPrcDgt
    
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³Gravacao da estrutura de vendas ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    FT070Grava(@aUnVenAtu,@aUnVendaExc) 
    
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³Geração do código inteligente  ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    Ft70CodInt()
        
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³Sincroniza as entidades do sistema com a estrutura de negocios     ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
    Ft70SEntCI(.F.)
    
    If nModulo == 73
        lRpAdl := .F. //Nao processa a ADL no SIGACRM
    EndIf
        
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³Se o parametro MV_FTRPEST estiver como falso, nao processa         ³
    //³a tabela ADL apos a manutencao na estrutura, deixando este processo³
    //³por conta do usuario, pela rotina FATA520                          ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If lRpAdl 
        
        cHoraIn        := Time()
        dDataIn        := Date()
        
        A070AtuADL()
        
        cHoraFi := Time()
        dDataFi := Date()
        
        cMensagem :=STR0048 + cHoraIn+ STR0049 + cHoraFi + CRLF +; //"Processamento finalizado. Inicio: "###" Final: "
                     STR0050 + ATTotHora(dDataIn,cHoraIn,dDataFi,cHoraFi)
    
         MsgInfo(cMensagem)  
         MemoWrite("FATA070.TXT", cMensagem)
    
    EndIf
    
EndIf    

RestArea(aArea)
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³Ft070Menu ³ Autor ³ Vendas CRM            ³ Data ³13/02/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Acoes efetuadas pelo menu                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FT070Menu( ExpO1, ExpC1, ExpO2 )                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Logico                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 -> Objeto Tree / ExpC1 -> Acao a ser efetuada        ³±±
±±³          ³ ExpO2 -> Objeto Menu                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function Ft070Menu( oTree, cAction, oMenu, aUnVenAtu, aUnVendaExc )

Local cDesc            := ""
Local cCargo           := ""
Local nScan            := 0     
Local nDeleted         := 0     
Local nLoop            := 0 
Local lFound           := .F.
Local cUndVendRef      := ""
Local nCont
Local lFt070ESP        := FindFunction("U_FT070ESP")    //Ponto de entrada para funcoes especificas do usuario
Local lActUsrMnu        := ExistBlock("FT70ACTMNU")
Local lRetorno        := .T.
                                                 
PRIVATE aRotina 
PRIVATE aGrpTmpExc  := {} 
PRIVATE INCLUI      := .T. // Nao retirar
Private cCadastro   := ""

Do Case 
Case cAction == "INCRP"

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Inclusao do representante                                    ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
     
    If ConPad1( , , , "SA3" , , , .F. ) 
    
        cCargo := oTree:GetCargo()
        cTpSup := Substr(cCargo,1,3)
        cCargo := SubStr( cCargo, 5, GetSX3Cache("ACA_GRPREP","X3_TAMANHO") ) 
        DbSelectArea("ACA")
        DbSetOrder(1)
        If Dbseek(xFilial("ACA")+cCargo)

            lFound := oTree:TreeSeek( "1US-" + SA3->A3_COD )

            If lFound
                Aviso( STR0019, STR0020 + AllTrim( SA3->A3_COD + "-" + ; //"Atencao"###"O representante '"
                         SA3->A3_NOME ) + STR0021, { STR0022 }, 2 ) //"' ja esta na estrutura !"###"Ok"
            Else
                If Empty(SA3->A3_CODUSR)
                    Aviso( STR0019, STR0020 + AllTrim( SA3->A3_COD + "-" + ; //"Atencao"###"O representante '"
                         SA3->A3_NOME ) + STR0055, { STR0022 }, 2)              //" não está relacionando a um usuário do sistema!"
                Else
                    If lActUsrMnu
                        lRetorno := ExecBlock("FT70ACTMNU",.F.,.F.,{oTree,cAction})
                        If ValType(lRetorno) <> "L"
                            lRetorno := .T.
                        EndIf
                    EndIf
                    If lRetorno .AND. Aviso(    STR0019, STR0023 + AllTrim( SA3->A3_COD + "-" + ; //"Atencao"###"Confirma a inclusao do representante '"
                                                 SA3->A3_NOME ) + "' ?", { STR0024, STR0025 }, 2 ) == 1  //"Sim"###"Nao"

                        cDesc := PadR( SA3->A3_COD + "-" + Capital( SA3->A3_NOME ), 100 )
                           oTree:AddItem( cDesc, "1US-" + SA3->A3_COD,"BMPUSER","BMPUSER",,,3)
                        oTree:Refresh()

                        cGrupo := ACA->ACA_GRPREP

                        If Empty(ACA->ACA_GRPSUP)
                            For nCont:=1 to Len(aGrupoAtu)
                                If aGrupoAtu[nCont][1]=ACA->ACA_GRPREP
                                    cUnidVen := aGrupoAtu[nCont][3][1]
                                EndIf
                            Next nCont
                        Else
                            cUnidVen := ACA->ACA_GRPSUP
                         EndIf

                        FT070IncRep(cGrupo, SA3->A3_COD, cUnidVen, cTpSup, .T.)

                        If    lFt070ESP
                            U_FT070ESP("SA3",SA3->A3_COD,Recno(),"INCRP")
                        EndIf

                        lPrcDgt := .T.
                    EndIf        

                EndIf
            EndIf
        EndIf
    EndIf

Case cAction == "VISUA"    

    cCargo := oTree:GetCargo()                       

    If Left( cCargo, 3 ) == "1US"
        cCadastro := STR0053 
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Visualizacao do representante                                ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        aRotina := { { STR0002,"AxPesqui"  , 0 , 1},;  // //"Pesquisar"
                    { STR0003,"AxVisual"  , 0 , 2} }  // //"Visualizar"
                        
        SA3->( dbSetOrder( 1 ) ) 
    
        If SA3->( MsSeek( xFilial("SA3") + SubStr( cCargo, 5, GetSX3Cache("A3_COD","X3_TAMANHO") ) ) )  
            AxVisual( "SA3", SA3->( Recno() ), 2 )    
        EndIf 
        
    ElseIf Left( cCargo, 3 ) == "2GR"
        
        ACA->( dbSetOrder( 1 ) ) 
        If ACA->( MsSeek( xFilial("ACA") + SubStr( cCargo, 5, GetSX3Cache("ACA_GRPREP","X3_TAMANHO") ) ) )  
            FWExecView(STR0003, "VIEWDEF.FATA060", MODEL_OPERATION_VIEW)
        EndIf 
    
    EndIf         
            
Case cAction == "EXCRP"

    cCargo := oTree:GetCargo() 
    SA3->( dbSetOrder( 1 ) ) 
    SA3->( MsSeek( xFilial("SA3") + SubStr( cCargo, 5, GetSX3Cache("A3_COD","X3_TAMANHO") ) ) )   
    
    If Aviso( STR0019, STR0026 + AllTrim( SA3->A3_COD + "-" + ; //"Atencao"###"Confirma a exclusao do representante '"
         SA3->A3_NOME ) + "' ?", { STR0024, STR0025 }, 2 ) == 1  //"Sim"###"Nao"
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Exclusao do representante                                    ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        oTree:DelItem()     
        oTree:Refresh()                            
        
        FT070ExcRep( cCargo, SA3->A3_COD )  
        
        If    lFt070ESP
            U_FT070ESP("SA3",SA3->A3_COD,Recno(),"EXCRP")
        EndIf
        
        lPrcDgt := .T.
        
    EndIf    
    
Case cAction == "EXCGR"                                              

    cCargo := oTree:GetCargo() 
    ACA->( dbSetOrder( 1 ) ) 
    
    cGrupoExc := SubStr( cCargo, 5, GetSX3Cache("ACA_GRPREP","X3_TAMANHO") ) 
    ACA->( MsSeek( xFilial("ACA") + cGrupoExc ) )   

    If Aviso( STR0019, STR0027 + AllTrim( ACA->ACA_GRPREP + "-" + ; //"Atencao"###"Confirma a exclusa do Grupo '"
             ACA->ACA_DESCRI ) + STR0028, { STR0024, STR0025 }, 2 ) == 1  //"' ?"###"Sim"###"Nao"
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Exclusao do Grupo                                            ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        oTree:DelItem()     
        oTree:Refresh()        
                         
        aGrpTmpExc := {}                              
        
        FT070ExcGrp( cGrupoExc ) 
        
        nDeleted := 0
        
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Exclui do grupo atual os grupos do array de exclusao         ³
        //³ temporario                                                   ³        
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        For nLoop := 1 To Len( aGrpTmpExc ) 
            If !( Empty( nScan := AScan( aGrupoAtu, { |x| x[1] == aGrpTmpExc[ nLoop ] } ) ) ) 
                ADel( aGrupoAtu, nScan )         
                nDeleted++ 
            EndIf         
        Next nLoop
        
        ASize( aGrupoAtu, Len( aGrupoAtu ) - nDeleted ) 
        aGrpTmpExc := {} 
        
        If    lFt070ESP
            U_FT070ESP("ACA",ACA->ACA_GRPREP,Recno(),"EXCGR")
        EndIf
        
        lPrcDgt := .T.
        
    EndIf        
    
Case cAction == "INCGR" 
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Inclusao do Grupo                                            ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    
    If ConPad1( ,,,"ACA", , , .F. ) 
    
        cCargo := oTree:GetCargo()                           
        cUndVendRef:=cCargo
        lFound := oTree:TreeSeek( "2GR-" + ACA->ACA_GRPREP ) 
        
        oTree:TreeSeek( cCargo )
                                
        If lFound
            Aviso( STR0019, STR0029 + AllTrim( ACA->ACA_GRPREP + "-" + ; //"Atencao"###"O grupo '"
                     ACA->ACA_DESCRI ) + STR0021, { STR0022 }, 2 )  //"' ja esta na estrutura !"###"Ok"
        Else 
        
            If Aviso( STR0019, STR0030 + AllTrim( ACA->ACA_GRPREP + "-" + ; //"Atencao"###"Confirma a inclusao do Grupo '"
                     ACA->ACA_DESCRI ) + "' ?", { STR0024, STR0025 }, 2 ) == 1  //"Sim"###"Nao"
                cDesc := PadR( ACA->ACA_GRPREP + "-" + Capital( ACA->ACA_DESCRI ), 100 ) 
                oTree:AddItem( cDesc, "2GR-" + ACA->ACA_GRPREP, aGrupoBmp[1],aGrupoBmp[2],,,2)  
                oTree:TreeSeek( "2GR-" + ACA->ACA_GRPREP ) 
                oTree:Refresh() 
                
                FT070IncGrp( cCargo, ACA->ACA_GRPREP ) 
                
                If    lFt070ESP
                    U_FT070ESP("ACA",ACA->ACA_GRPREP,Recno(),"INCGR")
                EndIf
                
                lPrcDgt := .T.
                
            EndIf
        EndIf
    
    EndIf 
    
Case cAction == "VISGR"              
    cCadastro := STR0054  
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Visualizacao do Grupo                                        ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    aRotina := { { STR0002,"AxPesqui"  , 0 , 1},;  // //"Pesquisar"
                { STR0003,"AxVisual"  , 0 , 2} }  // //"Visualizar"
                    
    ACA->( dbSetOrder( 1 ) ) 
    cCargo := oTree:GetCargo() 
    If ACA->( MsSeek( xFilial("ACA") + SubStr( cCargo, 5, GetSX3Cache("ACA_GRPREP","X3_TAMANHO") ) ) )  
        AxVisual( "ACA", ACA->( Recno() ), 2 )    
    EndIf         
    
Case cAction == "UNIVE"

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Inclusao da Unidade de Vendas                                    ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    
    If ConPad1( , , , "ADK" , , , .F. ) 
        
        If ADK->ADK_MSBLQL == '1'
            HELP(" ",1,"REGBLOQ") //"Registro bloqueado para uso."
        Else    
            cCargo := oTree:GetCargo()
            oTree:TreeSeek( cCargo )
            lFound := oTree:TreeSeek( "1UV-" + ADK->ADK_COD )    
        
            If lFound
                Aviso( STR0037, STR0037 + AllTrim( ADK->ADK_COD + "-" + ; //"Atencao"###"O representante '"
                         ADK->ADK_NOME ) +STR0021, { STR0022 }, 2 ) //"' ja esta na estrutura !"###"Ok"
            Else                       
            
                If Aviso( STR0037, STR0043 + AllTrim( ADK->ADK_COD + "-" + ; //"Atencao"###"Confirma a inclusao do representante '"
                         ADK->ADK_NOME ) + "' ?", { STR0024, STR0025 }, 2 ) == 1  //"Sim"###"Nao"
        
                    cDesc := PadR( ADK->ADK_COD + "-" + ADK->ADK_NOME, 100 ) 
                    oTree:TreeSeek( cCargo )
                    oTree:AddItem( cDesc, "1UV-" + ADK->ADK_COD,"CLIENTE","CLIENTE",,,2)   
                    oTree:Refresh()
                    
                    FT070IncUnidVen( cCargo, ADK->ADK_COD,@aUnVenAtu )
                    
                    If    lFt070ESP
                        U_FT070ESP("ADK",ADK->ADK_COD,Recno(),"UNIVE")
                    EndIf
    
                    lPrcDgt := .T.
                    
                EndIf            
            EndIf 
        EndIf
    EndIf
    
    Case cAction == "EXUNIVEN"

    cCargo := oTree:GetCargo()
    cCargo := SubStr( cCargo, 5, GetSX3Cache("ADK_COD","X3_TAMANHO") ) 
    ADK->( dbSetOrder( 1 ) ) 
    ADK->( MsSeek( xFilial("ADK") +cCargo ) )   
  
    If Aviso( STR0037, STR0044 + AllTrim( ADK->ADK_COD + " - " + ; //"Atencao"###"Confirma a exclusa da Unida de Venda'"
             ADK->ADK_NOME ) + STR0028, { STR0024, STR0025 }, 2 ) == 1  //"' ?"###"Sim"###"Nao"
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Exclusao do Grupo                                            ³            
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        oTree:DelItem()     
        oTree:Refresh()        
                                   
        
        FT070ExcUnidVen( cCargo,@aUnVenAtu,@aUnVendaExc ) 
        
        nDeleted := 0    
        
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Exclui a Unidade de Venda atual do array de exclusao         ³
        //³ temporario                                                   ³        
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        For nLoop := 1 To Len( aUnVendaExc ) 
            If !( Empty( nScan := AScan( aUnVenAtu, { |x| x[2] == aUnVendaExc[ nLoop ] } ) ) ) 
                ADel( aUnVenAtu, nScan )         
                nDeleted++ 
            EndIf         
        Next nLoop
        
        ASize( aUnVenAtu, Len( aUnVenAtu ) - nDeleted ) 
        
        aGrpTmpExc := {} 

        
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Exclui do grupo atual os grupos do array de exclusao         ³
        //³ temporario                                                   ³        
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        For nLoop := 1 To Len( aGrpTmpExc ) 
            If !( Empty( nScan := AScan( aGrupoAtu, { |x| x[1] == aGrpTmpExc[ nLoop ] } ) ) ) 
                ADel( aGrupoAtu, nScan )         
                nDeleted++ 
            EndIf         
        Next nLoop
        
        ASize( aGrupoAtu, Len( aGrupoAtu ) - nDeleted ) 
        aGrpTmpExc := {} 

        If    lFt070ESP
            U_FT070ESP("ADK",ADK->ADK_COD,Recno(),"EXUNIVEN")
        EndIf
        
        lPrcDgt := .T.
        
    EndIf        
Case cAction == "RESET"    
    oTree:Reset()
EndCase 

Return( .T. ) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³Ft070Chang³ Autor ³ Vendas CRM            ³ Data ³13/02/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Validacao da TudoOk                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Logico                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function Ft070Change( oTree ) 

cLast := oTree:GetCargo() 

Return( .T. )         
                                       
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³FT070MAct ³ Autor ³ Vendas CRM            ³ Data ³13/02/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de chamada do menu                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FT070MAct( ExpO1, ExpN1, ExpN2, ExpO2 )                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Logico                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 -> Objeto Tree / ExpN1 -> Dimensao X                 ³±±
±±³          ³ ExpN2 -> Dimensao Y  / ExpO2 -> Objeto Menu                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                              
Function FT070MAct( oTree, nX, nY, oMenu )                               

Local lWhenBtUsr := ExistBlock("FT70ENABTN")                              

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Desabilita todos os itens do menu                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AEval( oMenu:aItems, { |x| x:Disable() } ) 

cCargo := oTree:GetCargo() 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Habilita as opcoes de acordo com a entidade do tree          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Left( cCargo, 3 ) == "1US"
    oMenu:aItems[3]:enable()  
    If !lVisual
        oMenu:aItems[2]:enable()  
    EndIf     
ElseIf Left( cCargo, 3 ) == "2GR"
    
    oMenu:aItems[3]:enable()      
    If !lVisual                
           oMenu:aItems[4]:enable()
        oMenu:aItems[1]:enable()  
        oMenu:aItems[5]:enable()  
    EndIf                             
ElseIf Left( cCargo, 3 ) == "1UV"
    oMenu:aItems[4]:enable() 
    oMenu:aItems[7]:enable()      
       oMenu:aItems[6]:enable()  
ElseIf Left( cCargo, 3 ) == "0MA"
    If !lVisual              
        oMenu:aItems[4]:enable() 
        oMenu:aItems[6]:enable()  
    EndIf     
EndIf 

oMenu:aItems[8]:enable() 

If lWhenBtUsr
    ExecBlock("FT70ENABTN",.F.,.F.,{oMenu,oTree,lVisual})
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ativa o Menu PopUp                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oMenu:Activate( nX-150, nY-150, oTree )
                                   
Return()   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³FT070Pesq ³ Autor ³ Vendas CRM            ³ Data ³14/02/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Pesquisa por entidades no Tree                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oTree: Objeto Tree                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function FT070Pesq( oTree )                                                       

Local aItems        := {} 
Local aSeek        := {} 
Local cChavePesq    := Space(20)        
Local cChave        := Space(20)                
Local cVar            := ""
Local nCombo        := 1 
Local nOpca        := 0 
Local oCombo        := NIL
Local oDlg            := NIL
Local oBmp            := NIL   
Local oBut1        := NIL
Local oBut2        := NIL
Local oGetPesq    := NIL

AAdd( aItems, STR0031 ) // "Chamado Tecnico" //"Representante"
AAdd( aItems, "Grupo"         ) // "Ordem de Servico" 

AAdd( aSeek, { "1US", 1, "@R XXXXXX", STR0031, "SA3" } )  //"Representante" //"Representante"
AAdd( aSeek, { "2GR", 1, "@R XXXXXX", STR0032        , "ACA" } )  //"Grupo" //"Grupo"

DEFINE MSDIALOG oDlg TITLE cCadastro FROM 09,0 TO 21.2,43.5 OF oMainWnd

DEFINE FONT oBold NAME "Arial" SIZE 0, -13 BOLD
@   0, 0 BITMAP oBmp RESNAME "LOGIN" oF oDlg SIZE 30, 120 NOBORDER WHEN .F. PIXEL

@ 03, 40 SAY STR0033 FONT oBold PIXEL // "Pesquisar entidade" 

@ 14, 30 TO 16 ,400 LABEL '' OF oDlg   PIXEL

@ 23, 40 SAY STR0034 SIZE 40, 09 PIXEL //"Entidade"
@ 23, 80 COMBOBOX oCombo VAR cVar ITEMS aItems SIZE 80, 10 OF oDlg PIXEL 
                                                      
@ 35, 40 SAY STR0035  SIZE 40, 09    PIXEL //"Chave "
@ 35, 80 MSGET oGetPesq1 VAR cChave WHEN .F. SIZE 80, 10 VALID .T. PIXEL 

@ 48, 40 SAY STR0036 SIZE 40, 09    PIXEL //"Pesquisa "
@ 48, 80 MSGET oGetPesq VAR cChavePesq SIZE 80, 10 VALID .T. PIXEL F3 "XYZZYZ"

oGetPesq:bGotFocus := { || oGetPesq:oGet:Picture := aSeek[ oCombo:nAt, 3 ],;
         cChave := aSeek[ oCombo:nAt, 4 ], oGetPesq:cF3 := aSeek[ oCombo:nAt, 5 ],;
         oGetPesq1:Refresh() }   

DEFINE SBUTTON oBut1 FROM 67,  99  TYPE 1 ACTION ( nOpca := 1, nCombo := oCombo:nAt,;
        oDlg:End() ) ENABLE of oDlg

DEFINE SBUTTON oBut2 FROM 67, 132   TYPE 2 ACTION ( nOpca := 0,;
        oDlg:End() ) ENABLE of oDlg

ACTIVATE MSDIALOG oDlg CENTERED  
 
If nOpca == 1
    cChavePesq := RTRIM( cChavePesq ) 
    If !oTree:TreeSeek( aSeek[ nCombo, 1 ] + "-" + cChavePesq ) 
        Aviso( STR0037, STR0038, { STR0022 } )  //"Atencao !"###"Entidade nao encontrada !"###"Ok"
    EndIf 
EndIf 

Return( .T. ) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³FT070IncGrp³ Autor ³ Vendas CRM           ³ Data ³15/02/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Inclui um grupo nos arrays de controle                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oTree: Objeto Tree                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function FT070IncGrp( cCargo, cGrupoNovo )

Local cGrupoSup := SubStr( cCargo, 5, GetSX3Cache("ACA_GRPREP","X3_TAMANHO") ) 
Local nScan     := 0 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adiciona ao array de grupos atuais                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty( nScan := AScan( aGrupoAtu, { |x| x[1] == cGrupoNovo } )  ) 
    AAdd( aGrupoAtu, { cGrupoNovo, , {cGrupoSup}, {If(Substr(cCargo,1,3)="1UV",Substr(cCargo,1,3),Substr(cCargo,1,3))}, {} } ) 
Else
    Aviso( STR0037, STR0039, { STR0022 } )    //"Atencao !"###"Inconsistencia no Array de Trabalho !"###"Ok"
EndIf 

Return( .T. ) 
                                                             
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³FT070IncUnidVen³ Autor ³ Vendas CRM       ³ Data ³14/01/2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Inclui a Unidade de Vendas nos arrays de controle          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oTree: Objeto Tree                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function FT070IncUnidVen( cCargo, cGrupoNovo,aUnVenAtu )

Local cGrupoSup := SubStr( cCargo, 5, GetSX3Cache("ADK_GRUNVE","X3_TAMANHO") ) 
Local nScan     := 0 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adiciona ao array de grupos atuais                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty( nScan := AScan( aUnVenAtu, { |x| x[1] == cGrupoNovo } )  ) 
    AAdd( aUnVenAtu, { cGrupoNovo, cGrupoSup, {cCargo}, {}, {} } ) 
Else
    Aviso( STR0037, STR0039, { STR0022 } )    //"Atencao !"###"Inconsistencia no Array de Trabalho !"###"Ok"
EndIf 

Return( .T. )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³FT070ExcGrp³ Autor ³ Vendas CRM           ³ Data ³15/02/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Exclui grupos dos arrays de controle                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oTree: Objeto Tree                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function FT070ExcGrp( cGrupoExc )

Local cGrpSupRec := ""
Local nScanGrp  := 0 
Local nScanSup  := 0
Local nLoop     := 0
Local cGrpExc    := ""
Local nX        := 0
  

nScanGrp := AScan( aGrupoAtu, { |x| x[1] == cGrupoExc } ) 

If nScanGrp > 0

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Adiciona ao grupo de excluidos                               ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If Empty( AScan( aGrupoExc, cGrupoExc ) ) 
        AAdd( aGrupoExc, cGrupoExc )     
    EndIf

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³Remove os grupos pertencentes ao grupo excluido³
    //³do grupo de vendedores da tela.                ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
     cGrpExc := ""
     For nLoop := 1 to Len(aGrupoAtu)
        If aGrupoAtu[nLoop,3,1] == cGrupoExc .Or. aGrupoAtu[nLoop,3,1] == cGrpExc
              If aGrupoAtu[nLoop,4,1] <> "1UV"
                  AAdd( aGrupoExc, aGrupoAtu[nLoop,1] )
                  cGrpExc := aGrupoAtu[nLoop,1]
              EndIf
        EndIf
     Next nLoop
    
    For nLoop := 1 to Len(aGrupoExc) 
        nScan := AScan( aGrupoAtu, { |x| x[1] == aGrupoExc[nLoop]} ) 
          If nScan > 0
              ADel( aGrupoAtu,nScan ) 
            ASize( aGrupoAtu, Len( aGrupoAtu) - 1 )    
        EndIf
    Next nLoop
    
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Remove os vendedores pertencentes ao grupo excluido³
//³do grupo de vendedores da tela.                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nLoop := 1 to Len(aGrupoExc) 
    cGrpExc := aGrupoExc[nLoop]
    For nX := 1 to Len(aGrupoVen)
        If aGrupoVen[nX,2] == cGrpExc
            AAdd(aGrupoVenExc,aGrupoVen[nX,1])
        EndIf
    Next nX
Next nLoop

For nLoop := 1 to Len(aGrupoVenExc) 
    nScanSup := AScan( aGrupoVen, { |x| x[1] == aGrupoVenExc[nLoop]} ) 
    If nScanSup > 0
        ADel( aGrupoVen,nScanSup ) 
        ASize( aGrupoVen, Len( aGrupoVen) - 1 )    
    EndIf
Next nLoop

Return( .T. ) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³FT070ExcUnidVen³ Autor ³ Vendas CRM       ³ Data ³14/01/2008³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Exclui as Unidade de Venda dos arrays de controle          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oTree: Objeto Tree                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function FT070ExcUnidVen( cUnidVenda, aUnVenAtu, aUnVendaExc )

Local cGrpSupRec         := ""
Local nScanGrp           := 0 
Local nScanSup           := 0
Local nLoop              := 0  
Local nDeletado          := 0
Local cGrpExc            := ""
Local nX                := 0

nScanUnVenda := AScan( aUnVenAtu, { |x| x[1] == cUnidVenda } )  

If nScanUnVenda == 0
   nScanUnVenda := AScan( aUnVenAtu, { |x| x[2] == "MAINGR" } )
   If nScanUnVenda > 0  // Iniciando a Estrutura sem Gravação                                       
      nScanUnVenda := AScan( aUnVenAtu, { |x| x[1] == cUnidVenda } )
   EndIf
EndIf

If Empty( nScanUnVenda ) 
    Aviso( "Atencao !", "Inconsistencia no Array de Trabalho !", { "Ok" } )    //"Atencao !"###"Inconsistencia no Array de Trabalho !"###"Ok"
Else                         

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Inclui no array de exclusao temporaria                       ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    For nLoop := 1 to Len(aUnVenAtu)
        If aUnVenAtu[nLoop,1] == cUnidVenda .Or. aUnVenAtu[nLoop,2] == cGrpExc
              AAdd( aUnVendaExc, aUnVenAtu[nLoop,1])
              cGrpExc := aUnVenAtu[nLoop,1]
        EndIf
    Next nLoop

    For nLoop := 1 to Len(aUnVendaExc) 
        nScanUnVenda := AScan( aUnVenAtu, { |x| x[1] == aUnVendaExc[nLoop]} ) 
        If nScanUnVenda > 0
            ADel( aUnVenAtu, nScanUnVenda ) 
            ASize( aUnVenAtu, Len( aUnVenAtu) - 1 )    
        EndIf
    Next nLoop

    If Len(aGrupoAtu) > 0
         cGrpExc := ""
         For nLoop := 1 to Len(aGrupoAtu)
            If aGrupoAtu[nLoop,3,1] == cUnidVenda .Or. aGrupoAtu[nLoop,3,1] == cGrpExc
                  AAdd( aGrupoExc, aGrupoAtu[nLoop,1] )
                  cGrpExc := aGrupoAtu[nLoop,1]
            Else
                nScanUnVenda := AScan( aUnVendaExc, { |x| x == aGrupoAtu[nLoop,3,1]} )
                If nScanUnVenda > 0
                    AAdd( aGrupoExc, aUnVendaExc[nScanUnVenda] )
                EndIf
            EndIf
         Next nLoop                                

        For nLoop := 1 to Len(aGrupoAtu)
            nScanGrp := AScan( aGrupoExc, { |x| x == aGrupoAtu[nLoop,3,1] } )
            nScanSup := AScan( aGrupoExc, { |x| x == aGrupoAtu[nLoop,1] } )
            If nScanGrp > 0 .And. nScanSup == 0
                AAdd( aGrupoExc, aGrupoAtu[nLoop,1] )
            EndIf
        Next nLoop

         For nLoop := 1 to Len(aGrupoExc) 
              nScanUnVenda := AScan( aGrupoAtu, { |x| x[1] == aGrupoExc[nLoop]} ) 
              If nScanUnVenda > 0
                 ADel( aGrupoAtu,nScanUnVenda ) 
                 ASize( aGrupoAtu, Len( aGrupoAtu) - 1 )    
              EndIf
         Next nLoop
     EndIf    
     
     nDeletado := 0
                                    
    If Len(aGrupoVen) > 0
        cGrpExc := ""
        For nLoop := 1 to Len(aGrupoExc) 
            cGrpExc := aGrupoExc[nLoop]
            For nX := 1 to Len(aGrupoVen)
                If aGrupoVen[nX,2] == cGrpExc
                    AAdd(aGrupoVenExc,aGrupoVen[nX,1])
                EndIf
            Next nX
        Next nLoop
        For nLoop := 1 to Len(aGrupoVenExc)
            nScanUnVenda := AScan( aGrupoVen, { |x| x[1] == aGrupoVenExc[nLoop]} ) 
            If nScanUnVenda > 0
                ADel( aGrupoVen,nScanUnVenda ) 
                ASize( aGrupoVen, Len( aGrupoVen) - 1 )    
            EndIf
        Next nLoop
    EndIf    
EndIf    

Return( .T. ) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³FT070IncRep³ Autor ³ Vendas CRM           ³ Data ³15/02/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Inclui os representantes nos arrays de controle            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oTree: Objeto Tree                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function FT070IncRep( cGrupo, cRepres,cUnidVen, cTpSup, lNewRep ) 

AAdd(aGrupoVen, {cRepres, cGrupo, cUnidVen, cTpSup, lNewRep}) 
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³FT070ExcRep³ Autor ³ Vendas CRM           ³ Data ³15/02/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Exclui os representantes dos arrays de controle            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oTree: Objeto Tree                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function FT070ExcRep( cCargo, cRepres ) 
                        
Local nScanGrp     := 0                  

aadd(aGrupoVenExc,cRepres)

nScan := AScan( aGrupoVen, { |x| x[1] == cRepres } )

If nScan > 0              
   ADEL( aGrupoVen, nScan )     
   ASize( aGrupoVen, Len( aGrupoVen ) - 1 )
EndIf   

Return( .T. ) 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³Ft070Grava³ Autor ³ Vendas CRM            ³ Data ³16/02/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gravacao da Estrutura de vendas                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ft070Grava(aUnVenAtu,aUnVendaExc)

Local aArea      := GetArea()  
Local cGrpBranco := Space( GetSX3Cache("A3_GRPREP","X3_TAMANHO") ) 
Local cTipSupBco := Space( GetSX3Cache("A3_TIPSUP","X3_TAMANHO") ) 
Local nLoop      := 0                             
Local nLoop2     := 0
Local nLoop3     := 0
Local nScan         := 0
Local aRdzVen    := {}
Local cFilADK        := xFilial("ADK")
Local cFilSA3        := xFilial("SA3")
Local cFilACA        := xFilial("ACA")

Begin Transaction

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processa as Unidades de Venda excluidos                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

For nLoop := 1 To Len( aUnVendaExc )

    cUnidVendaExc := aUnVendaExc[ nLoop ]

    If ValType( cUnidVendaExc ) == "C"
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Atualiza a unidade de Venda                                  ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        cSeekADK := cFilADK + cUnidVendaExc
        ADK->( dbSetOrder( 1 ) )
        If ADK->( dbSeek( cSeekADK ) ) 
            RecLock("ADK", .F.)
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Grava o grupo superior                                       ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            ADK->ADK_GRUNVE := cGrpBranco
            ADK->ADK_TIPSUP := cTipSupBco
            ADK->( MsUnlock() )
            ADK->( dbSkip() )
        EndIf
    EndIf
Next nLoop

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processa as Unidade de Vendas incluidos                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nLoop := 1 To Len( aUnVenAtu ) 

    cUnVenAtu := aUnVenAtu[ nLoop, 1 ]

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Atualiza a tabela de Unidade de Vendas                   ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    cSeekADK := cFilADK + cUnVenAtu
    ADK->( dbSetOrder( 1 ) )
    If ADK->( dbSeek( cSeekADK ) ) 
        RecLock("ADK", .F.) 
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Grava o grupo superior                                       ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        ADK->ADK_GRUNVE := aUnVenAtu[ nLoop, 2 ]
        ADK->ADK_TIPSUP    := aUnVenAtu[ nLoop, 3,1 ]
        ADK->( MsUnlock() )
        ADK->( dbSkip() )
    EndIf
Next nLoop

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processa os grupos excluidos                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aRecno := {}

For nLoop := 1 To Len( aGrupoExc ) 
    cGrupoExc := aGrupoExc[ nLoop ]
    If ValType( cGrupoExc ) == "C"
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Atualiza os usuarios excluidos                               ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        cSeekSA3 := cFilSA3 + cGrupoExc
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Obtem a lista de recnos                                      ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        SA3->( dbSetOrder( 6 ) ) 
        If SA3->( dbSeek( cSeekSA3 ) )                 
            While !SA3->( Eof() ) .And. cSeekSA3 == SA3->A3_FILIAL + SA3->A3_GRPREP
                AAdd( aRecno, {SA3->A3_COD,SA3->A3_GRPREP,SA3->A3_TIPSUP} ) 
                SA3->( dbSkip() ) 
            EndDo                                        
        EndIf                                                    

        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Atualiza a tabela de grupos                                  ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                                                  
        cSeekACA := cFilACA + cGrupoExc 
        ACA->( dbSetOrder( 1 ) ) 
        If ACA->( dbSeek( cSeekACA ) ) 
            RecLock("ACA", .F.) 
            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³ Grava o grupo superior                                       ³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            ACA->ACA_GRPSUP := cGrpBranco
            ACA->ACA_TIPSUP := cTipSupBco
        
            ACA->( MsUnlock() ) 
            ACA->( dbSkip() ) 
        EndIf     
    EndIf 
Next nLoop 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processa a lista                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ       
DbSelectAreA("SA3")
DbSetOrder(1)
DbGoTop()

For nLoop2 := 1 To Len( aRecno )     
    If DbSeek(cFilSA3+aRecno[ nLoop2,1] ) 
        RecLock("SA3", .F.)                                  
        SA3->(A3_GRPREP) := cGrpBranco
        SA3->(A3_TIPSUP) := cTipSupBco                 
        SA3->(MsUnlock())
        If aScan(aVendExc,{|x|x[1]==SA3->A3_COD}) == 0
            AAdd(aVendExc,{SA3->A3_COD,Ft520Sup(SA3->A3_NVLSTR)})
        EndIf
    EndIf    
Next nLoop2 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processa os grupos incluidos                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nLoop := 1 To Len( aGrupoAtu ) 

    cGrupoAtu := aGrupoAtu[ nLoop, 1 ]

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Atualiza a tabela de grupos                                  ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

    cSeekACA := cFilACA + cGrupoAtu 
    ACA->( dbSetOrder( 1 ) ) 
    If ACA->( dbSeek( cSeekACA ) )  
              
        RecLock("ACA", .F.)
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Grava o grupo superior                                       ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        ACA->ACA_GRPSUP := aGrupoAtu[ nLoop, 3, 1 ]                         
        ACA->ACA_TIPSUP := aGrupoAtu[ nLoop, 4, 1 ]                         
        ACA->( MsUnlock() ) 
        ACA->( dbSkip() ) 
        
    EndIf     
    
Next nLoop 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza os VENDEDORES excluidos                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

For nLoop2 := 1 To Len( aGrupoVenExc )        
    cUserExc := aGrupoVenExc[ nLoop2 ]                                       
    If ValType( cUserExc ) == "C"        
        cSeekSA3 := cFilSA3 + cUserExc
        SA3->( dbSetOrder( 1 ) ) 
        If SA3->( dbSeek( cSeekSA3 ) )                 
            RecLock("SA3", .F.) 
            SA3->A3_GRPREP  := cGrpBranco
            SA3->A3_UNIDAD   := cTipSupBco    
            SA3->A3_TIPSUP  := cTipSupBco
            //Retira a permissao do vendedor na transferencia de contas.
            SA3->A3_MODTRF := "3"    
            SA3->( MsUnlock() )   
            If aScan(aVendExc,{|x|x[1]==SA3->A3_COD}) == 0
                AAdd(aVendExc,{SA3->A3_COD,Ft520Sup(SA3->A3_NVLSTR)})
            EndIf

            //-- Array para ponto de entrada FT070RDZ --
            AAdd(aRdzVen,{SA3->A3_FILIAL,SA3->A3_COD,'EXC'})
        EndIf                
    EndIf                                       
Next nLoop2

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza os VENDEDORES incluidos                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

For nLoop3 := 1 To Len( aGrupoVen )        
    cUserAtu := aGrupoVen[ nLoop3, 1 ]                                       
    If ValType( cUserAtu ) == "C"        
        cSeekSA3 := cFilSA3 + cUserAtu
        SA3->( dbSetOrder( 1 ) ) 
        If SA3->( dbSeek( cSeekSA3 ) )                 
        
            //Ao incluir/alterar um representante, este deve ser reprocessado na ADL
            If SA3->A3_GRPREP <> aGrupoVen[ nLoop3, 2 ] 
                If aScan(aVendProc,{|x| x[1] == SA3->A3_COD} ) == 0
                    AAdd(aVendProc,{SA3->A3_COD,Ft520Sup(SA3->A3_NVLSTR)})
                EndIf    
                If (nScan := aScan(aVendExc,{|x|x[1]==SA3->A3_COD})) > 0
                    aDel(aVendExc,nScan)
                    aSize(aVendExc,Len(aVendExc)-1)
                EndIf
            EndIf
        
            RecLock( "SA3", .F. ) 
            SA3->A3_GRPREP  := aGrupoVen[ nLoop3, 2 ] 
            SA3->A3_UNIDAD   := aGrupoVen[ nLoop3, 3 ] 
            SA3->A3_TIPSUP  := aGrupoVen[ nLoop3, 4 ]
            SA3->( MsUnlock() )  

            //-- Array para ponto de entrada FT070RDZ --
            AAdd(aRdzVen, {SA3->A3_FILIAL, SA3->A3_COD, 'INC', aGrupoVen[nLoop3,5]})
            
        EndIf                
    EndIf                                       
Next nLoop3 

End Transaction 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz a tratativa do rodízio                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("FT070RDZ")
    ExecBlock( "FT070RDZ",.F.,.F.,{aRdzVen})
EndIf  

RestArea(aArea)
Return( .T. ) 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³FT070Monta³ Autor ³ Vendas CRM            ³ Data ³16/02/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Faz a chamada da montagem do Tree                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FT070Monta( ExpO1, [ ExpC1 ] )                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 ->Objeto Tree                                        ³±±
±±³          ³ ExpC1 -> Grupo de inicio ( visualizacao parcial )          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function FT070Monta( oTree, cStartGroup,aUnVenAtu )
 
Local cCargo    :=    ""
Local cMainPref :=    ""     
Local aForaOrd    :=    {}
Local aUnidade    :=    {}
Local nCont        :=    0
Local nDeleted    :=    0
Local nPos        := 0
Local nStart    := 0
Local nAddedItens := 0
Local lAtualiza := .F. 
Local cDescGrp    :=    ""   
Local lImgUsrVen     := ExistBlock("FT70IMGVEN")
Local cImgVend    := "BMPUSER"
Local cFilADK        := xFilial("ADK")
Local cFilACA        := xFilial("ACA")
Local cFilSA3        := xFilial("SA3")
     
cStartGroup := If( ValType( cStartGroup ) == "C", cStartGroup, "MAINGR" ) 

cMainPref := If( cStartGroup == "MAINGR", "0MA", "2GR" ) 
    
oTree:TreeSeek( cMainPref + "-" + cStartGroup ) 
cCargo := oTree:GetCargo() 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inclui os grupos que tem este grupo como superior            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                                           
aRecnoADK := {}                     
aRecnoACA := {}                     
aUnVenAtu := {}

dbSelectArea( "ADK") 
DbSetOrder(4)//ADK_FILIAL+ADK_GRUNVE
DbGoTop()
ADK->(dbSeek(cFilADK))

While !Eof() .And. ADK->ADK_FILIAL == cFilADK
    If !Empty(ADK->ADK_GRUNVE)
         lFound := oTree:TreeSeek( cMainPref + "-" + ADK->ADK_GRUNVE ) 
         If lFound
              AAdd( aRecnoADK, ADK->( RecNo() ) )    
            AAdd( aUnVenAtu, { ADK->ADK_COD, ADK->ADK_GRUNVE, {ADK->ADK_TIPSUP}, {}, {} } )
             cDesc := PadR( ADK->ADK_COD + "-" + Capital( ADK->ADK_NOME ), 100 ) 
               oTree:AddItem( cDesc, "1UV-" + ADK->ADK_COD,"CLIENTE","CLIENTE",,,2)   
          Else                              
             If !Empty(ADK->ADK_GRUNVE)
                 AAdd( aForaOrd,{ ADK->( RecNo()),.F.} )    
             EndIf 
         EndIf                 
    EndIf
    ADK->( dbSkip() )          
Enddo

If Len(aForaOrd) > 0
    Do While .T.
        For nCont:=1 to Len(aForaOrd)
           ADK->(DbGoTo(aForaOrd[nCont][1]))         
           lFound := oTree:TreeSeek( ADK->(Alltrim(ADK_TIPSUP))+"-"+ ADK->ADK_GRUNVE )    
           If lFound
                  AAdd( aRecnoADK, ADK->( RecNo() ) )    
                AAdd( aUnVenAtu, { ADK->ADK_COD, ADK->ADK_GRUNVE, {ADK->ADK_TIPSUP}, {}, {} } ) 
                 cDesc := PadR( ADK->ADK_COD + "-" + Capital( ADK->ADK_NOME ), 100 ) 
                   oTree:AddItem( cDesc, "1UV-" + ADK->ADK_COD,"CLIENTE","CLIENTE",,,2)   
            Else
                AAdd( aUnidade, {ADK->ADK_COD, ADK->( RecNo() ), ADK->ADK_GRUNVE })
            EndIf
            aForaOrd[nCont][2]:=.T.
        Next nCont                  
        
        For nCont=1 to Len(aForaOrd)
            iF Valtype(aForaOrd[1])=="A"
                If aForaOrd[1][2] == .T.
                    ADel( aForaOrd,1 )         
                    nDeleted++ 
                   EndIf
           EndIf
        Next nCont                  
        ASize( aForaOrd, Len( aForaOrd)-nDeleted)

        If Len(aForaOrd) == 0
           aForaOrd    := {}
           Exit
           EndIf    
    Enddo           
EndIf

aForaOrd:={}

dbSelectArea( "ACA") 
DbSetOrder(2)
DbGoTop()
ACA->(dbSeek(cFilACA))

While !ACA->(Eof()) .And. ACA->ACA_FILIAL == cFilACA
    If !Empty(ACA->ACA_GRPREP)                                                              
        lFound := oTree:TreeSeek( ACA->(Alltrim(ACA_TIPSUP))+"-"+ ACA->ACA_GRPSUP )            
        If lFound 
            If AScan( aGrupoAtu, { |x| x[1] == ACA->ACA_GRPREP }) == 0
                AAdd( aGrupoAtu, { ACA->ACA_GRPREP, , {ACA->ACA_GRPSUP},{ACA->(Alltrim(ACA_TIPSUP))}, {} } )                
            EndIf
            cDesc := PadR(  ACA->ACA_GRPREP+"-"  + Capital( ACA->ACA_DESCRI ), 100 ) 
            cDescGrp := "2GR-" + ACA->ACA_GRPREP
               oTree:AddItem( cDesc,  "2GR-" + ACA->ACA_GRPREP,aGrupoBmp[1],aGrupoBmp[2],,,2)   
            oTree:TreeSeek("2GR-" + ACA->ACA_GRPREP)
            nStart := 1
            While((nPos    := AScan( aUnidade, { |x| x[3] == ACA->ACA_GRPREP },nStart)) > 0)
                ADK->(DbGoTo(aUnidade[nPos][2]))
                AAdd( aGrupoAtu, { ADK->ADK_COD, , {ADK->ADK_GRUNVE},{ADK->(Alltrim(ADK_TIPSUP))}, {} } )
                cDesc := PadR( ADK->ADK_COD + "-" + Capital( ADK->ADK_NOME ), 100 )
                   oTree:AddItem( cDesc, "1UV-" + ADK->ADK_COD,"CLIENTE","CLIENTE",,,2)
                   FT070IncUnidVen( cDescGrp, ADK->ADK_COD,@aUnVenAtu )
                   nStart := nPos+1
            End
         Else                              
             If !Empty(ACA->ACA_GRPSUP)
                 If AScan( aForaOrd, { |x| x[1] == ACA->( RecNo()) }) == 0
                    AAdd( aForaOrd,{ ACA->( RecNo()),.F.,ACA->ACA_GRPSUP, ACA->(Alltrim(ACA_TIPSUP)), ACA->ACA_GRPREP, ACA->ACA_DESCRI} )
                    //1 - RECNO()
                    //2 - LOGICO
                    //3 - ACA->ACA_GRPSUP
                    //4 - ACA->ACA_TIPSUP     
                    //5 - ACA->ACA_GRPREP
                    //6 - ACA->ACA_DESCRI
                EndIf
             EndIf 
         EndIf              
     EndIf    
     ACA->( dbSkip() )
Enddo               

aForaOrd := ASort(aForaOrd,,,{|x,y| x[5]<y[3]})

If Len(aForaOrd) > 0
    Do While .T.
        nAddedItens := 0
        For nCont:=1 to Len(aForaOrd)        
           lFound := oTree:TreeSeek( Alltrim(aForaOrd[nCont][4])+"-"+ aForaOrd[nCont][3] )    
           If lFound          
                If AScan( aGrupoAtu, { |x| x[1] == aForaOrd[nCont][5] }) == 0
                    AAdd( aGrupoAtu, { aForaOrd[nCont][5], , {aForaOrd[nCont][3]},{aForaOrd[nCont][4]}, {} } )
                    cDesc := PadR(  aForaOrd[nCont][5]+"-"  + Capital( aForaOrd[nCont][6] ), 100 ) 
                    oTree:AddItem( cDesc,  "2GR-" + aForaOrd[nCont][5],aGrupoBmp[1],aGrupoBmp[2],,,2)                                                                                    
                    oTree:TreeSeek("2GR-" + aForaOrd[nCont][5])
                    nStart := 1
                    While((nPos    := AScan( aUnidade, { |x| x[3] == aForaOrd[nCont][5] },nStart)) > 0)
                        ADK->(DbGoTo(aUnidade[nPos][2]))
                        AAdd( aGrupoAtu, { ADK->ADK_COD, , {ADK->ADK_GRUNVE},{ADK->(Alltrim(ADK_TIPSUP))}, {} } )
                        cDesc := PadR( ADK->ADK_COD + "-" + Capital( ADK->ADK_NOME ), 100 )
                           oTree:AddItem( cDesc, "1UV-" + ADK->ADK_COD,"CLIENTE","CLIENTE",,,2)
                           nStart := nPos+1
                    End
                 Else
                      AAdd( aGrupoAtu, { aForaOrd[nCont][5], , {aForaOrd[nCont][3]},{aForaOrd[nCont][4]}, {} } )
                    cDesc := PadR(  aForaOrd[nCont][5]+"-"  + Capital( aForaOrd[nCont][6] ), 100 )
                    If!(oTree:TreeSeek("2GR-" + aForaOrd[nCont][5])) 
                        oTree:AddItem( cDesc,  "2GR-" + aForaOrd[nCont][5],aGrupoBmp[1],aGrupoBmp[2],,,3) 
                    EndIf                                                                                   
                    oTree:TreeSeek("2GR-" + aForaOrd[nCont][5])
                    nStart := 1
                    While((nPos    := AScan( aUnidade, { |x| x[3] == aForaOrd[nCont][5] },nStart)) > 0)
                        ADK->(DbGoTo(aUnidade[nPos][2]))
                        AAdd( aGrupoAtu, { ADK->ADK_COD, , {ADK->ADK_GRUNVE},{ADK->(Alltrim(ADK_TIPSUP))}, {} } )
                        cDesc := PadR( ADK->ADK_COD + "-" + Capital( ADK->ADK_NOME ), 100 )
                           If!(oTree:TreeSeek("1UV-" + ADK->ADK_COD))
                               oTree:AddItem( cDesc, "1UV-" + ADK->ADK_COD,"CLIENTE","CLIENTE",,,3)
                           EndIf
                           nStart := nPos+1
                    End
                 EndIf
                aForaOrd[nCont][2]:=.T.
                nAddedItens++
            EndIf
        Next nCont                  
                    
        lAtualiza := .F.
        nDeleted := 0
        For nCont:=1 to Len(aForaOrd)
            If Valtype(aForaOrd[nCont])=="A"
                If (aForaOrd[nCont][2]== .T.)  
                    ADel( aForaOrd,nCont )         
                    nDeleted++ 
                    lAtualiza := .T.
                   Endif
               eNDIF
        Next nCont                              
        ASize( aForaOrd, Len( aForaOrd)-nDeleted)

        If Len(aForaOrd) == 0 .OR. !lAtualiza
           Exit
           EndIf    
           
           If nAddedItens <= 0
              Exit
           EndIf  
    Enddo                                    
    aForaOrd    := {}           
EndIf

dbSelectArea("SA3") 
DbSetOrder(6)
DbGoTop()
SA3->(dbSeek(cFilSA3))

While !SA3->(Eof()) .And. SA3->A3_FILIAL == cFilSA3
    If !Empty(SA3->A3_GRPREP)
        lFound := oTree:TreeSeek(SA3->(Alltrim(A3_TIPSUP))+"-"+ SA3->A3_GRPREP) 
        If lFound 
            cDesc := PadR( SA3->A3_COD + "-" + Capital( SA3->A3_NOME ), 100 ) 
            If lImgUsrVen
                   cImgVend := ExecBlock("FT70IMGVEN",.F.,.F.,{SA3->A3_COD})
                   If ValType(cImgVend) <> "C" 
                       cImgVend := "BMPUSER"
                   EndIf
               EndIf
            oTree:AddItem( cDesc, "1US-" + SA3->A3_COD,cImgVend,cImgVend,,,2)   
           AAdd( aGrupoVen, { SA3->A3_COD,SA3->A3_GRPREP, SA3->A3_UNIDAD, SA3->A3_TIPSUP, .F. } )
         Else      
            If !Empty(SA3->A3_GRPREP)
                AAdd( aForaOrd,{SA3->( RecNo() ),.F. })    
            EndIf 
        EndIf
    EndIf    
    SA3->(dbSkip())
Enddo  

If Len(aForaOrd) > 0
   For nCont:=1 to Len(aForaOrd)
       SA3->(DbGoTo(aForaOrd[nCont][1]))
       lFound := oTree:TreeSeek(SA3->(Alltrim(A3_TIPSUP))+"-"+ SA3->A3_GRPREP) 
        If lFound 
            cDesc := PadR( SA3->A3_COD + "-" + Capital( SA3->A3_NOME ), 100 ) 
               If lImgUsrVen
                   cImgVend := ExecBlock("FT70IMGVEN",.F.,.F.,{SA3->A3_COD})
                   If ValType(cImgVend) <> "C" 
                       cImgVend := "BMPUSER"
                   EndIf
               EndIf
            oTree:AddItem( cDesc, "1US-" + SA3->A3_COD,cImgVend,cImgVend,,,2)   
           AAdd( aGrupoVen, { SA3->A3_COD,SA3->A3_GRPREP, SA3->A3_UNIDAD, SA3->A3_TIPSUP, .F. } )
        EndIf      
   Next nCont   
EndIf

If Len(aForaOrd) > 0
    Do While .T.
        For nCont:=1 to Len(aForaOrd)
            SA3->(DbGoTo(aForaOrd[nCont][1]))
            lFound := oTree:TreeSeek(SA3->(Alltrim(A3_TIPSUP))+"-"+ SA3->A3_GRPREP) 
            If lFound 
                cDesc := PadR( SA3->A3_COD + "-" + Capital( SA3->A3_NOME ), 100 ) 
                If lImgUsrVen
                       cImgVend := ExecBlock("FT70IMGVEN",.F.,.F.,{SA3->A3_COD})
                       If ValType(cImgVend) <> "C" 
                           cImgVend := "BMPUSER"
                       EndIf
                   EndIf
                oTree:AddItem( cDesc, "1US-" + SA3->A3_COD,cImgVend,cImgVend,,,2)   
                  AAdd( aGrupoVen, { SA3->A3_COD,SA3->A3_GRPREP, SA3->A3_UNIDAD, SA3->A3_TIPSUP, .F. } )
                   aForaOrd[nCont][2]:=.T.
            EndIf
        Next nCont                  
        nDeleted := 0
        For nCont:=1 to Len(aForaOrd)
            If aForaOrd[nCont][2]== .T. 
                ADel( aForaOrd,nCont )         
                nDeleted++ 
               EndIf
        Next nCont                  
        ASize( aForaOrd, Len( aForaOrd)-nDeleted)

        If Len(aForaOrd) == 0 .OR. nDeleted <= 0
           aForaOrd    := {}
           Exit
           EndIf    
    Enddo           
EndIf

oTree:Refresh()
Return( .T. )       

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³FT070MonGr³ Autor ³ Vendas CRM            ³ Data ³16/02/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta o Tree na entrada                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FT070MonGr( ExpO1, ExpC1, ExpC2 )                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 -> Objeto Tree / ExpC1 -> Cargo / ExpC2 -> Grupo a   ³±±
±±³          ³ Incluir                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function FT070MonGr( oTree, cCargo, cGrupoInc, cRaiz ) 

Local aUserAtu       := {}
Local aRecnoACA      := {}
Local cSeekSA3       := ""
Local cQuery         := ""
Local cAliasQry      := ""
Local cFilACA        := xFilial("ACA")
Local cFilSA3        := xFilial("SA3")

ADK->( dbSetOrder( 4 ) )
 
aUserAtu := {}

oTree:TreeSeek( cCargo )

If !Empty(ADK->ADK_COD) .and. cRaiz = .T.
    cDesc := PadR( ADK->ADK_COD + "-" + Capital( ADK->ADK_NOME ), 100 )
    oTree:AddItem( cDesc, "1UV-" + ADK->ADK_COD,"CLIENTE","CLIENTE",,,2)
EndIf

dbSelectArea( "ACA" )
DbSetOrder(2)
    
cQuery := ""
cQuery += "SELECT ACA_GRPREP, ACA_DESCRI,ACA_GRPSUP,ACA_TIPSUP FROM " + RetSqlName("ACA") + " ACA "
cQuery += "WHERE "
cQuery += "ACA_FILIAL = '" + cFilACA + "' AND "
cQuery += "ACA_GRPSUP <> '' AND "
cQuery += "ACA.D_E_L_E_T_ = ' ' ORDER BY ACA_TIPSUP,ACA_GRPSUP,ACA_GRPREP"
dbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery ), 'cAliasQry', .F., .T. )
While !cAliasQry->(Eof())
    lFound := oTree:TreeSeek( cAliasQry->(Alltrim(ACA_TIPSUP))+"-"+ cAliasQry->ACA_GRPSUP )
    If lFound
        cDesc := PadR(  cAliasQry->ACA_GRPREP+"-"  + Capital( cAliasQry->ACA_DESCRI ), 100 )
        oTree:AddItem( cDesc,  "2GR-" + cAliasQry->ACA_GRPREP,aGrupoBmp[1],aGrupoBmp[2],,,2)
        oTree:Refresh()
    EndIf
    cAliasQry->( dbSkip() )
EndDo
dbSelectArea('cAliasQry')
dbCloseArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inclui os representantes                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := ""
cQuery += "SELECT A3_COD, A3_NOME, A3_GRPREP, A3_UNIDAD, A3_TIPSUP FROM " + RetSqlName("SA3") + " SA3 "
cQuery += "WHERE "
cQuery += "A3_FILIAL = '" + cFilSA3 + "' AND "
cQuery += "A3_GRPREP <> '' AND "
cQuery += "SA3.D_E_L_E_T_ = ' ' ORDER BY A3_TIPSUP,A3_GRPREP,A3_COD"
dbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery ), 'cAliasQry', .F., .T. )
        
While !cAliasQry->(Eof())
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Inclui no array de atuais ( ja existentes )                       ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    AAdd( aUserAtu, A3_COD )
    lFound := oTree:TreeSeek(cAliasQry->(Alltrim(A3_TIPSUP))+"-"+ cAliasQry->A3_GRPREP)
    If lFound
        cDesc := PadR( A3_COD + "-" + Capital( A3_NOME ), 100 )
        oTree:AddItem( cDesc, "1US-" + A3_COD,"BMPUSER","BMPUSER",,,2)
        AAdd( aGrupoVen, { cAliasQry->A3_COD,cAliasQry->A3_GRPREP, cAliasQry->A3_UNIDAD, cAliasQry->A3_TIPSUP, .F. } )
    EndIf
    cAliasQry->(dbSkip())
EndDo
dbSelectArea("cAliasQry")
dbCloseArea()
dbSelectArea("SA3")
            
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inclui os grupos que tem este grupo como superior            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ       
aRecnoACA := {}
            
cAliasQry := GetNextAlias()
cQuery    := ""

cQuery += "SELECT R_E_C_N_O_ ACARECNO FROM " + RetSqlName("ACA") + " "
cQuery += "WHERE "
cQuery += "ACA_FILIAL = '" + cFilACA + "' AND "
cQuery += "ACA_GRPSUP = '" + ADK->ADK_COD + "' AND "
cQuery += "D_E_L_E_T_ = ' ' ORDER BY ACA_GRPREP"

dbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery ), cAliasQry, .F., .T. )

If Alias() == cAliasQry
    While !Eof()
        AAdd( aRecnoACA, (cAliasQry)->ACARECNO )
        dbSkip()
    EndDo
    dbCloseArea()
    dbSelectArea( "ACA" )
EndIf

Return( .T. )            

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Ft70CodIntºAutor  ³Vendas CRM          º Data ³  25/11/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Geracao do codigo inteligente para os vendedores da estrutu-º±±
±±º          ³ra de vendas.                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³FATA070                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function Ft70CodInt()

Local aArea        := GetArea()                            // Salva o posicionamento atual
Local aTree        := {}                                  // Array da estrutura de vendas
Local cFilterBk    := ""                                     // Filtro da tabela SA3
Local cCodIni    := StrZero(0,NTAMCOD)                  // Codigo inicial para a estrutura
Local nX        := 0                                   // Auxiliar de loop

Private aNiveis    := {}                                   // Lista de campos com niveis

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Sai da rotina se a base nao for TopConnect³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Limpa os codigos atuais³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Ft70LimpCI() 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Indica que nao ha estrutura de negocio implantada³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PutMv("MV_CRMESTN",.F.)


DbSelectArea("SA3")  
cFilterBk    := DbFilter()
DbClearFilter()                                  

Processa({|| Ft70TreeEV(@aTree, "MAINGR")}    , STR0046) //"Processando Estrutura de Vendas"

SA3->(DbSetOrder(1))

aCodInt := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Processa todos os grupos abaixo do grupo obrigatorio MAINGR³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aTree) > 0 .AND. Len(aTree[1][4]) > 0
    
    For nX := 1 to Len(aTree)
        cCodIni    := Soma1(cCodIni)
        Processa({|| Ft70GeraCI(@aTree[nX][4], cCodIni)}, STR0047 ) //"Gerando o codigo inteligente"
    Next nX
     
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³Indica que estrutura de negocio esta implantada ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

    PutMv("MV_CRMESTN",.T.)
    
EndIf

aCodInt := {}

If !Empty(cFilterBk)
    DbSelectArea("SA3")
    Set Filter To &cFilterBk
EndIf                       

RestArea(aArea)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Ft70GeraCIºAutor  ³Vendas CRM          º Data ³  25/11/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gravacao do codigo inteligente a partir da estrutura de     º±±
±±º          ³vendas, de forma recursiva                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ExpA1 - Array contendo a estrutura de vendas                º±±
±±º          ³ExpC2 - Codigo inteligente do nivel atual.                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³FATA070                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Ft70GeraCI(aTree,cCodIntAtu)

Local nX         := 1
Local nMax        := Len(aTree)
Local cNextCI    := ""

While nX <= nMax
    
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³Atribui o codigo inteligente ao vendedor³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ    
    If aTree[nX,3] == "SA3" .AND. SA3->(DbSeek(xFilial("SA3")+aTree[nX][1]))
 
        //Atualiza o cadastro do vendedor
        RecLock("SA3",.F.)
        SA3->A3_NVLSTR    := cCodIntAtu 
        SA3->A3_NIVEL    := Len(AllTrim(cCodIntAtu))/NTAMCOD
        MsUnLock() 
        
    EndIf
    
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³Verifica se ha mais elementos no proximo nivel³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If (Len(aTree[nX]) > 3) .AND. (Len(aTree[nX,4]) > 0)
        If aTree[nX,3]=="ADK"
            cNextCI    := cCodIntAtu
        Else 
            cNextCI    := Ft70NextCI(cCodIntAtu)
        EndIf
        Ft70GeraCI(aTree[nX,4],cNextCI)
    EndIf         
    
    nX++

EndDo
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Ft70NextCIºAutor  ³Vendas CRM          º Data ³  25/11/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Busca o proximo codigo livre para utilizacao no codigo inte-º±±
±±º          ³ligente.                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ExpC1 - Codigo inteligente do nivel atual                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³FATA070                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Ft70NextCI(cPrefixo)

Local cRet        := StrZero(0,NTAMCOD)
Local cMax        := ""   
Local nX        := 0
Local nTamPre    := 0
Local nPos        := 0

Default cPrefixo    := ""

cPrefixo := AllTrim(cPrefixo)
nTamPre := Len(cPrefixo)

For nX := 1 to Len(aCodInt)
    If (Left(aCodInt[nX],nTamPre) == cPrefixo) .AND. (aCodInt[nX] > cMax) .AND. Len(aCodInt[nX]) = nTamPre+NTAMCOD
        cMax := aCodInt[nX]
        nPos := nX
    EndIf
Next nX        

If !Empty(cMax)
    cRet := cMax
EndIf

If Empty(cPrefixo)
    cRet := Soma1(cRet,NTAMCOD)
    AAdd(aCodInt,cRet)
Else
    cRet := cPrefixo + Soma1(Right(cRet,NTAMCOD))
    AAdd(aCodInt,cRet)
EndIf

Return cRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Ft70LimpCIºAutor  ³Vendas CRM          º Data ³  25/11/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Limpa o codigo inteligente atual dos vendedores             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³FATA070                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Ft70LimpCI()

TCSQLEXEC( "UPDATE " + RetSqlName("SA3") + " SET A3_NVLSTR = '', A3_NIVEL = 0 WHERE A3_FILIAL = '"+xFilial("SA3")+"'" )

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Ft70TreeEVºAutor  ³Vendas CRM          º Data ³  25/11/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Criacao da estrutura de vendas em um array recursivo        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ExpA1 - Array que armazenara a estrutura (referencia)       º±±
±±º          ³ExpC2 - Codigo da raiz da estrutura de vendas               º±±
±±º          ³ExpL3 - Indica se foi referenciada pela unid. de vendas     º±±
±±º          ³ExpN4 - Recno do ultimo registro do ACA processado          º±±
±±º          ³ExpN5 - Nivel de recursao atual                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³FATA070                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºObs       ³Ao ser alterada esta funcao deve ser replicada para:        º±±
±±º          ³Ft70TreEV1 e Ft70TreEV2 para que a recursividade nao seja   º±±
±±º          ³executada com a mesma function.                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function Ft70TreeEV(aTree, cRaiz, lUnidVda, nRecACA, nNivRec )

Local aAreaACA         := ACA->(GetArea())
Local aAreaADK         := ADK->(GetArea())
Local aTemp               := {}
Local aAreaTMP        := {}
Local cFilACA            := xFilial("ACA")
Local cFilADK            := xFilial("ADK")

Default lUnidVda    := .F.
Default nRecACA        := 0
Default nNivRec        := 0    

DbSelectArea("ADK") 
DbSetOrder(4)

DbSelectArea("ACA") 
DbSetOrder(2)

ProcRegua( Reccount() )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Processa os grupos de representantes da estrutura³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ACA->(DbSeek(cFilACA+cRaiz))
    
While ACA->(!Eof()) .AND. ACA->ACA_FILIAL == cFilACA .AND. ACA->ACA_GRPSUP == cRaiz

    IncProc( STR0046 ) //"Processando Estrutura de Vendas"
    
    If ((lUnidVda .AND. (AllTrim(ACA->ACA_TIPSUP) == "1UV")) .OR. (!lUnidVda .AND. (AllTrim(ACA->ACA_TIPSUP) <> "1UV"))) .AND. nRecACA <> ACA->(Recno())
        AAdd( aTree, {ACA->ACA_GRPREP,ACA->ACA_GRPSUP,"ACA",{}}) 

        If    ADK->(DbSeek(cFilADK+ACA->ACA_GRPREP))

            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³Verifica se ha unidades de venda abaixo do grupo atual³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
             While ADK->(!Eof()) .AND. ADK->ADK_FILIAL == cFilADK .AND. ADK->ADK_GRUNVE == ACA->ACA_GRPREP
             
                aTemp := aTree[Len(aTree),4]
                AAdd( aTemp, {ADK->ADK_COD,ACA->ACA_GRPSUP,"ADK",{}})
                aAreaTMP := ADK->(GetArea())
            
                Ft70TreEV1(@aTemp[Len(aTemp),4], ADK->ADK_COD, .T.,,nNivRec+1 )    
            
                RestArea(aAreaTMP)
                ADK->(DbSkip())
                
             EndDo
    
        EndIf                             
                                                               
        Ft70TreEV1(@aTree[Len(aTree),4], ACA->ACA_GRPREP, .F. , ACA->(Recno()), nNivRec+1 ) 
        
        aTemp := aTree[Len(aTree),4]
        Ft70TreeVe(@aTemp,ACA->ACA_GRPREP)

    EndIf

    ACA->(DbSkip())

End  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Caso a estrutura comece por uma unidade de vendas, utiliza ³
//³esta parte do codigo                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nNivRec == 0 .AND. ADK->(DbSeek(cFilADK+cRaiz))

    ProcRegua( Reccount() )
    
    While ADK->(!Eof()) .AND. ADK->ADK_FILIAL == cFilADK  .AND. ADK->ADK_GRUNVE == cRaiz
        IncProc( STR0046 ) //"Processando Estrutura de Vendas"

        AAdd( aTree, {ADK->ADK_COD,ADK->ADK_GRUNVE,"ADK",{}}) 

        Ft70TreEV1(@aTree[Len(aTree),4], ADK->ADK_COD, .T.,,nNivRec+1)

        ADK->(DbSkip())
    EndDo
    
EndIf

RestArea(aAreaADK)
RestArea(aAreaACA)
   
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Ft70TreEV1ºAutor  ³Vendas CRM          º Data ³  25/11/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Criacao da estrutura de vendas em um array recursivo        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ExpA1 - Array que armazenara a estrutura (referencia)       º±±
±±º          ³ExpC2 - Codigo da raiz da estrutura de vendas               º±±
±±º          ³ExpL3 - Indica se foi referenciada pela unid. de vendas     º±±
±±º          ³ExpN4 - Recno do ultimo registro do ACA processado          º±±
±±º          ³ExpN5 - Nivel de recursao atual                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³FATA070                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function Ft70TreEV1(aTree, cRaiz, lUnidVda, nRecACA, nNivRec )

Local aAreaACA         := ACA->(GetArea())
Local aAreaADK         := ADK->(GetArea())
Local aTemp               := {}
Local aAreaTMP        := {}
Local cFilACA            := xFilial("ACA")
Local cFilADK            := xFilial("ADK")

Default lUnidVda    := .F.
Default nRecACA        := 0
Default nNivRec        := 0    

DbSelectArea("ADK") 
DbSetOrder(4)

DbSelectArea("ACA") 
DbSetOrder(2)

ProcRegua( Reccount() )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Processa os grupos de representantes da estrutura³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ACA->(DbSeek(cFilACA+cRaiz))
    
While ACA->(!Eof()) .AND. ACA->ACA_FILIAL == cFilACA .AND. ACA->ACA_GRPSUP == cRaiz

    IncProc( STR0046 ) //"Processando Estrutura de Vendas"
    
    If ((lUnidVda .AND. (AllTrim(ACA->ACA_TIPSUP) == "1UV")) .OR. (!lUnidVda .AND. (AllTrim(ACA->ACA_TIPSUP) <> "1UV"))) .AND. nRecACA <> ACA->(Recno())
        AAdd( aTree, {ACA->ACA_GRPREP,ACA->ACA_GRPSUP,"ACA",{}}) 

        If    ADK->(DbSeek(cFilADK+ACA->ACA_GRPREP))

            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³Verifica se ha unidades de venda abaixo do grupo atual³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
             While ADK->(!Eof()) .AND. ADK->ADK_FILIAL == cFilADK .AND. ADK->ADK_GRUNVE == ACA->ACA_GRPREP
             
                aTemp := aTree[Len(aTree),4]
                AAdd( aTemp, {ADK->ADK_COD,ACA->ACA_GRPSUP,"ADK",{}})
                aAreaTMP := ADK->(GetArea())
            
                Ft70TreEV2(@aTemp[Len(aTemp),4], ADK->ADK_COD, .T.,,nNivRec+1 )    
            
                RestArea(aAreaTMP)
                ADK->(DbSkip())
                
             EndDo
    
        EndIf                             
                                                               
        Ft70TreEV2(@aTree[Len(aTree),4], ACA->ACA_GRPREP, .F. , ACA->(Recno()), nNivRec+1 ) 
        
        aTemp := aTree[Len(aTree),4]
        Ft70TreeVe(@aTemp,ACA->ACA_GRPREP)

    EndIf

    ACA->(DbSkip())

EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Caso a estrutura comece por uma unidade de vendas, utiliza ³
//³esta parte do codigo                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nNivRec == 0 .AND. ADK->(DbSeek(cFilADK+cRaiz))

    ProcRegua( Reccount() )
    
    While ADK->(!Eof()) .AND. ADK->ADK_FILIAL == cFilADK  .AND. ADK->ADK_GRUNVE == cRaiz
    
        IncProc( STR0046 ) //"Processando Estrutura de Vendas"
    
        AAdd( aTree, {ADK->ADK_COD,ADK->ADK_GRUNVE,"ADK",{}}) 
                                                       
        Ft70TreEV2(@aTree[Len(aTree),4], ADK->ADK_COD, .T.,,nNivRec+1)
        
        ADK->(DbSkip())
    
    EndDo
    
EndIf

RestArea(aAreaADK)
RestArea(aAreaACA)
   
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Ft70TreEV2ºAutor  ³Vendas CRM          º Data ³  25/11/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Criacao da estrutura de vendas em um array recursivo        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ExpA1 - Array que armazenara a estrutura (referencia)       º±±
±±º          ³ExpC2 - Codigo da raiz da estrutura de vendas               º±±
±±º          ³ExpL3 - Indica se foi referenciada pela unid. de vendas     º±±
±±º          ³ExpN4 - Recno do ultimo registro do ACA processado          º±±
±±º          ³ExpN5 - Nivel de recursao atual                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³FATA070                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function Ft70TreEV2(aTree, cRaiz, lUnidVda, nRecACA, nNivRec )

Local aAreaACA         := ACA->(GetArea())
Local aAreaADK         := ADK->(GetArea())
Local aTemp               := {}
Local aAreaTMP        := {}
Local cFilACA            := xFilial("ACA")
Local cFilADK            := xFilial("ADK")

Default lUnidVda    := .F.
Default nRecACA        := 0
Default nNivRec        := 0    

DbSelectArea("ADK") 
DbSetOrder(4)

DbSelectArea("ACA") 
DbSetOrder(2)

ProcRegua( Reccount() )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Processa os grupos de representantes da estrutura³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ACA->(DbSeek(cFilACA+cRaiz))
    
While ACA->(!Eof()) .AND. ACA->ACA_FILIAL == cFilACA .AND. ACA->ACA_GRPSUP == cRaiz

    IncProc( STR0046 ) //"Processando Estrutura de Vendas"
    
    If ((lUnidVda .AND. (AllTrim(ACA->ACA_TIPSUP) == "1UV")) .OR. (!lUnidVda .AND. (AllTrim(ACA->ACA_TIPSUP) <> "1UV"))) .AND. nRecACA <> ACA->(Recno())
        AAdd( aTree, {ACA->ACA_GRPREP,ACA->ACA_GRPSUP,"ACA",{}}) 

        If    ADK->(DbSeek(cFilADK+ACA->ACA_GRPREP))

            //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
            //³Verifica se ha unidades de venda abaixo do grupo atual³
            //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
             While ADK->(!Eof()) .AND. ADK->ADK_FILIAL == cFilADK .AND. ADK->ADK_GRUNVE == ACA->ACA_GRPREP
             
                aTemp := aTree[Len(aTree),4]
                AAdd( aTemp, {ADK->ADK_COD,ACA->ACA_GRPSUP,"ADK",{}})
                aAreaTMP := ADK->(GetArea())
            
                Ft70TreeEV(@aTemp[Len(aTemp),4], ADK->ADK_COD, .T.,,nNivRec+1 )    
            
                RestArea(aAreaTMP)
                ADK->(DbSkip())
                
             EndDo
    
        EndIf
                                                               
        Ft70TreeEV(@aTree[Len(aTree),4], ACA->ACA_GRPREP, .F. , ACA->(Recno()), nNivRec+1 ) 
        
        aTemp := aTree[Len(aTree),4]
        Ft70TreeVe(@aTemp,ACA->ACA_GRPREP)

    EndIf

    ACA->(DbSkip())

EndDo  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Caso a estrutura comece por uma unidade de vendas, utiliza ³
//³esta parte do codigo                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nNivRec == 0 .AND. ADK->(DbSeek(cFilADK+cRaiz))

    ProcRegua( Reccount() )
    
    While ADK->(!Eof()) .AND. ADK->ADK_FILIAL == cFilADK  .AND. ADK->ADK_GRUNVE == cRaiz
    
        IncProc( STR0046 ) //"Processando Estrutura de Vendas"
    
        AAdd( aTree, {ADK->ADK_COD,ADK->ADK_GRUNVE,"ADK",{}}) 
                                                       
        Ft70TreeEV(@aTree[Len(aTree),4], ADK->ADK_COD, .T.,,nNivRec+1)
        
        ADK->(DbSkip())
    
    EndDo
    
EndIf

RestArea(aAreaADK)
RestArea(aAreaACA)
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Ft70TreeVeºAutor  ³Vendas CRM          º Data ³  25/11/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Adiciona a tree principal os vendedores associados ao no    º±±
±±º          ³corrente.                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ExpA1 - Array que contem a estrutura de vendas (referencia) º±±
±±º          ³ExpC2 - Codigo do grupo de representantes                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³FATA070                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Ft70TreeVe(aTree,cCodSup)

Local aArea        := GetArea()
Local cFilSA3        := xFilial("SA3")

DbSelectArea("SA3")
DbSetOrder(6)
DbSeek(cFilSA3+cCodSup)
While !SA3->(Eof()) .AND. SA3->A3_FILIAL == cFilSA3 .AND. SA3->A3_GRPREP == cCodSup
    AAdd(aTree, {SA3->A3_COD,cCodSup,"SA3"})
    DbSkip()
EndDo
RestArea(aArea)
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³A070AtuADL  ³ Autor ³Vendas CRM             ³ Data ³ 25/11/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Atualiza nivel de estrutura do vendedor na tabela ADL -         ³±±
±±³             ³ Controle de contas do vendedor.                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 - Codigo do vendedor                                     ³±±
±±³             ³ ExpC2 - Codigo do nivel gerado                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A070AtuADL(cCodVen,cSeqInicio)

Local aArea        := GetArea()
Local aNovoSup    := {}
Local nX             := 0 
Local nY            := 0
Local nPos            := 0
Local cQuery        := ""
Local cFilADL        := xFilial("ADL")
Local cFilSA3        := xFilial("SA3")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratamento para nova versao da workarea³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SA3")
DbSetOrder(1)

For nX := 1 to Len(aVendProc)

    SA3->(DbSeek(cFilSA3+aVendProc[nX][1]))
    
    //Obtem lista dos novos superiores
    aNovoSup := Ft520Sup(SA3->A3_NVLSTR)
    
    For nY := 1 to Len(aNovoSup)
        If (nPos := aScan(aVendProc[nX][2],aNovoSup[nY])) > 0
            aDel(aVendProc[nX][2],nPos)
            aSize(aVendProc[nX][2],Len(aVendProc[nX][2])-1)
        EndIf
    Next nY
 
    LjMsgRun( STR0051 + SA3->A3_NOME,, { || A070LibSup(SA3->A3_COD,aVendProc[nX][2]) }) //"Removendo acessos do superior antigo para o vendedor "
    LjMsgRun( STR0052 + SA3->A3_NOME,, { || Ft520Proc(Nil,aVendProc[nX][1], aVendProc[nX][1]) }) //"Processando vendedor "

Next nX

For nX := 1 to Len(aVendExc)

    LjMsgRun( STR0051 + aVendExc[nX][1],, { || A070LibSup(aVendExc[nX][1],aVendExc[nX][2]) }) //"Removendo acessos do superior antigo para o vendedor "
    
    cQuery := "DELETE FROM " + RetSqlName("ADL")
    cQuery += " WHERE ADL_FILIAL = '" + cFilADL + "'"
    cQuery += " WHERE ADL_VEND = '" + aVendExc[nX][1] + "'"
    TCSQLEXEC(cQuery)
    
Next nX
    
RestArea(aArea)
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A070LibSupºAutor  ³Vendas CRM          º Data ³  14/07/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Remove relacionamentos do vendedor excluido com seus superi-º±±
±±º          ³ores                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³FATA070                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A070LibSup(cVend,aGrpSup)

Local aArea         := GetArea()
Local cFilADL        := xFilial("ADL")
Local nX            := 0
Local cQuery        := ""
Local cAliasTmp    := GetNextAlias()

cQuery    := "SELECT ADL_ENTIDA,ADL_CODENT,ADL_LOJENT FROM " + RetSqlName("ADL")
cQuery    += " WHERE ADL_FILIAL = '"+cFilADL+"' AND ADL_VEND = '"+cVend+"' AND D_E_L_E_T_ = ' '"

If Select(cAliasTmp) > 0
    (cAliasTmp)->(DbCloseArea())
EndIf

dbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery ), cAliasTmp, .F., .T. ) 

DbSelectArea(cAliasTmp)

While !(cAliasTmp)->(Eof())

    For nX := 1 To Len(aGrpSup)
        Ft520Del(aGrpSup[nX][1],(cAliasTmp)->ADL_ENTIDA,(cAliasTmp)->ADL_CODENT,(cAliasTmp)->ADL_LOJENT,.F.)
    Next nX

    (cAliasTmp)->(DbSkip())

End

(cAliasTmp)->(DbCloseArea())

RestArea(aArea)
Return Nil

//------------------------------------------------------------------------------
/*/{Protheus.doc} Ft70SEntCI

Pergunta para usuario se o mesmo deseja sincronizar as entidades com a estrutura
de vendas.

@sample     Ft70SEntCI(lPerg)

@param        ExpL1 Pergunta para usuario?

@return       Nenhum

@author    Anderson Silva
@since        28/10/2013
@version    11.90
/*/
//------------------------------------------------------------------------------
Function Ft70SEntCI(lPerg)

Local lRetorno          := .T.  
Local lConfirma     := .T.
Local lExtEstNeg    := GetMv("MV_CRMESTN",.F.,.F.) 
     
Default lPerg := .T.

If lPerg
    If lExtEstNeg  
        lConfirma := MsgYesNo(STR0056+Chr(13)+Chr(10)+STR0057)            // "Deseja sincronizar as entidades do sistema com a estrutura de negócios?"
    Else
        MsgStop(STR0062,STR0063)                                             // "Identificamos que não há estrutura de negócio implantada neste ambiente, por favor entre em contato com administrador do CRM."    
        lRetorno := .F. 
    EndIf
EndIf                                                                            // "Esta sincronização poderá demorar alguns minutos..."

If lConfirma .AND. lRetorno
    Processa( { || lRetorno := Ft70EntXCI() },STR0058,STR0059 )      // "Aguarde"##"Sincronizando as entidades do sistema com a estrutura de negócio..."
    If lRetorno .AND. lPerg
        MsgInfo(STR0060,STR0063)                                        // "Sincronização realizada com sucesso!"
    EndIf     
EndIf

Return( lRetorno )

//------------------------------------------------------------------------------
/*/{Protheus.doc} Ft70CIXEnt

Sincroniza o codigo inteligente da estrutura de negocios nas entidades (AD1 - Oportunidades, AD2 - Time de Vendas, AD7 - Agenda, AD8 - Tarefas,
ACH - Suspects, SUS - Prospects, SA1 - Clientes e AD5 - Apontamentos). 

@sample     CRMXCodInt(cCodVend, cCodInt, lAllSA3)

@param        ExpC1 Codigo do Vendedor.
            ExpC2 Codigo inteligente da estrutura de negocio.
            ExpL3 Processa as entidades de todos os vendedores.

@return       Nenhum

@author    Anderson Silva
@since        28/10/2013
@version    11.90
/*/
//------------------------------------------------------------------------------
Static Function Ft70EntXCI()

Local cQuery        := ""
Local cAlias        := GetNextAlias()
Local aEntidad        := {"ACH","SUS","SA1","SU5","AD1","AD2","AD5","AD7","AD8"} 
Local aCpoFiltro    := {}
Local cPrxCpo        := ""
Local nX            := 0
Local nRetorno        := 0
Local lRetorno     := .T.

BeginSql Alias cAlias
         
    SELECT 
        A3_COD, A3_NVLSTR, A3_NIVEL
    FROM
        %Table:SA3% SA3
    WHERE 
        SA3.A3_FILIAL = %xFilial:SA3% AND SA3.%NotDel%
    ORDER BY 
        A3_COD ASC

EndSql 
            
ProcRegua(0)
    
Begin Transaction
    
While (cAlias)->(!Eof())
        
    For nX := 1 To Len(aEntidad) 
        
        aCpoFiltro    := CRMXCpoFil(aEntidad[nX])
            
        If Len(aCpoFiltro) > 0
            
            cPrxCpo    := IIF(Subs(aEntidad[nX],1,1)=="S",SubStr(aEntidad[nX],2,3),aEntidad[nX]) 
                
            IncProc(STR0059)    // "Sincronizando as entidades do sistema com a estrutura de negócio..."
                    
            cQuery := " UPDATE "+RetSqlName(aEntidad[nX])+" SET "+cPrxCpo+aCpoFiltro[NIDESTN]+" = '"+(cAlias)->A3_NVLSTR+"', "+cPrxCpo+aCpoFiltro[NNVESTN]+" = "+cValToChar((cAlias)->A3_NIVEL)"
            cQuery += " WHERE "+cPrxCpo+aCpoFiltro[NFILIAL]+" = '"+xFilial(aEntidad[nX])+"' AND "+cPrxCpo+aCpoFiltro[NVEND]+" = '"+(cAlias)->A3_COD+"' "  
            cQuery += " AND "+cPrxCpo+aCpoFiltro[NIDESTN]+" <> '"+(cAlias)->A3_NVLSTR+"' AND "+cPrxCpo+aCpoFiltro[NNVESTN]+" <> "+cValToChar((cAlias)->A3_NIVEL)+"  AND D_E_L_E_T_ = ' ' " 
                
            // Só sincroniza as oportunidades em aberto e suspensa.
            If aEntidad[nX] == "AD1"
                cQuery += " AND AD1_STATUS IN ('1','3') " 
            EndIf
                 
            nRetorno := TCSqlExec(cQuery)
                     
            If nRetorno < 0
                Exit 
            EndIf 
            
        EndIf 
                 
    Next nX
        
    If nRetorno < 0
        Exit
    EndIf
            
    (cAlias)->(DbSkip())
    
End 
      
If nRetorno < 0 
    DisarmTransaction()
    lRetorno := .F. 
    MsgStop(STR0061,STR0063)    // "Houve um erro durante a sincronização das entidades, por favor entre em contado com administrador do CRM."
EndIf

End Transaction
Return( lRetorno )