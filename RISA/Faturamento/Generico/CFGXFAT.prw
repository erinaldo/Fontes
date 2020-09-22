#INCLUDE "TOTVS.CH"

/*/

{Protheus.doc} CFGXFAT
                 
Funções genéricas

@author  Milton J.dos Santos	
@since   15/07/20
@version 1.0

/*/

// ValidReg - Validações das Consultas especifica
// Valida Registros na tabela SC5 e SC6 ( CAMPOS: C5_VEND1,C5_TABELA, C5_CONDPAG, C5_XOPER, C6_PRODUTO) 

User Function ValidReg()
Local bRetorno  := { || .T. }
Local aArea 	:= GetArea()
Local cCampo	:= ReadVar()
Local lRet      := .T.

If IsInCallStack('MATA410')
//  Para evitar imcompatilidade com outros modulos
    If l410Auto     // Ignora as regras se for um EXECAUTO
        Return( Eval( bRetorno ) )
    Endif
    If Empty( M->C5_XOPER )
        MsgStop("Obrigatorio o preenchimento do campo Tipo de Operacao!","Campo Obrigatorio")
        lRet := .F.
    Else
        If cCampo == 'M->C5_XOPER'
            If U_CampObr( cCampo )
                lRet := Iif(GetMV('FS_REGRATB',,.F.),ValOper(), .T. )
            Else
                lRet := .F.
            Endif
        Endif
    Endif
    If ! lRet
        bRetorno  := { || .F. }
        Return( Eval( bRetorno ) )
    Endif
    If GetMV('FS_REGRATB',,.F.) 
        If Alltrim(M->C5_XOPER) $ GetMV('FS_OPERVEN',,"01/02/04")
            Do Case 
                Case cCampo == 'M->C5_VEND1'
                    If U_CampObr( cCampo )
                        bRetorno 	:= { || Iif(GetMV('FS_REGRATB',,.F.),ValVend(),.T.) }
                    Endif
                Case cCampo == 'M->C5_TABELA'
                    If U_CampObr( cCampo )
                        bRetorno 	:= { || Iif(GetMV('FS_REGRATB',,.F.),ValTabP(),.T.) }
                    Endif
                Case cCampo == 'M->C5_CONDPAG'
                    If U_CampObr( cCampo )
                        bRetorno 	:= { || Iif(GetMV('FS_REGRATB',,.F.),ValCond(),.T.) }
                    Endif
                Case cCampo == 'M->C6_PRODUTO'
                    If U_CampObr( cCampo )
                       bRetorno 	:= { || Iif(GetMV('FS_REGRATB',,.F.),ValProd(),.T.) }
                    Endif
            EndCase
         Else
            bRetorno  := { || .T. }
        Endif
    Else
        bRetorno  := { || .T. }
    Endif
Endif

RestArea(aArea)

Return( Eval( bRetorno ) )

// ValOper - Valida operacoes do pedido de venda

Static Function ValOper()
Local lRet := .T.


lRet := ExistCPO("SX5","DJ" + M->C5_XOPER)

Return( lRet )

Static Function ValOperV()
Local lRet := .T.

If Type("l410Auto") == "U" .OR. l410Auto     // Ignora se não identificar a origem do cadastro ou se for um EXECAUTO
    Return(lRet)   
Endif

If ! U_USAREGRA()
    Return(lRet)   
Endif

If Empty(M->C5_XOPER)
    MsgStop("Campo de Operacao e Obrigatorio !")
ELSE
    If M->C5_XOPER $ GetMV('FS_OPERVEN',,"01/02/04")
        If EMPTY(M->C5_VEND1)
            MsgStop("Campo vendedor e Obrigatorio para operacao de venda !")
        Endif
        If EMPTY(M->C5_CONDPAG)
            MsgStop("Campo condicao de pagamento e Obrigatorio para operacao de venda !")
        Endif
    Else
        lRet := ExistCPO("SX5","DJ" + M->C5_XOPER)
    Endif
Endif

Return( lRet )

// ValVend - Regras de vendedor

Static Function ValVend()
Local lRet  := .T.
Local lSZA  := .F.
Local lSZB  := .F.
Local lSZC  := .F.
Local lSZE  := .F.

DbSelectArea("SZA")
DbSetOrder(1)
IF DbSeek( xFilial("SZA") + M->C5_VEND1 )
	lSZA    := .T.
EndIf
SZA->( DbCloseArea() )
DbSelectArea("SZB")
DbSetOrder(1)
IF DbSeek( xFilial("SZB") + M->C5_VEND1 )
	lSZB    := .T.
EndIf
SZB->( DbCloseArea() )
DbSelectArea("SZC")
DbSetOrder(1)
IF DbSeek( xFilial("SZC") + M->C5_VEND1 )
    lSZC    := .T.
EndIf
SZC->( DbCloseArea() )
DbSelectArea("SZE")
DbSetOrder(1)
IF DbSeek( xFilial("SZE") + M->C5_VEND1 + M->C5_XOPER )
	lSZE    := .T.
Else
    MsgStop("Vendedor nao autorizado para esta Operação.")
EndIf
SZE->( DbCloseArea() )

If !lSZA .OR. !lSZB .OR. !lSZC .OR. !lSZE
    lRet := .F.
    MsgStop("Vendedor nao possui Regras Cadastradas ou divergentes, falar com responsavel !")
EndIf

Return lRet

// ValTabP - Regras de Tabelas de Preco
// Filtra as tabelas do vendedor

Static Function ValTabP()
Local cQuery   := ""
Local cTabVend := GetNextAlias()
Local lRet     := .T.

If !Empty(M->C5_VEND1) .AND. !Empty(M->C5_CLIENTE) 

    cQuery := "SELECT * " 
    cQuery += " FROM "
    cQuery += "	    " + RetSQLName("SZA") + " SZA "
    cQuery += " WHERE SZA.D_E_L_E_T_ <> '*'"
    cQuery += "     AND SZA.ZA_FILIAL = '" + xFilial( "SZA" ) + "'" 
    cQuery += "     AND SZA.ZA_VEND = '" + M->C5_VEND1 + "' "
    cQuery += "	    AND SZA.ZA_CODMUN+SZA.ZA_UF IN (SELECT SA1.A1_COD_MUN+SA1.A1_EST FROM " + RetSQLName("SA1") + " SA1 WHERE SA1.D_E_L_E_T_ <> '*' AND SA1.A1_COD + SA1.A1_LOJA = '" + M->C5_CLIENTE+M->C5_LOJACLI + "')"
    cQuery += "     AND SZA.ZA_TABELA = '" + M->C5_TABELA + "' "

    Memowrite('ValTabP.SQL',cQuery)

    ChangeQuery(cQuery)
    DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTabVend,.F.,.T.)
    dbSelectArea(cTabVend)
    (cTabVend)->(dbGoTop())
    If (cTabVend)->( Eof() )
        lRet := .F.
    Endif
    (cTabVend )->( DbCloseArea() )
EndIf

If !lRet
    MsgStop("Tabela nao autorizada para este vendedor na regiao do cliente!","Bloqueio da tabela")
Endif

Return (lRet)

// ValCond - Regras de Condicao de Pagamento
// Filtra as condicoes de pagamento do vendedor do vendedor

Static Function ValCond()
Local lRet     := .F.
Local cQuery   := ""
Local cTabCond := GetNextAlias()

lRet := ValOperV()        // Valida Operacao de venda

If !EMPTY(M->C5_VEND1) .and. !EMPTY(M->C5_CONDPAG)

    cQuery := "SELECT * " 
    cQuery += " FROM "
    cQuery += "	    " + RetSQLName("SZB") + " SZB "
    cQuery += " WHERE SZB.D_E_L_E_T_ <> '*'"
    cQuery += "     AND SZB.ZB_FILIAL = '" + xFilial( "SZB" ) + "'" 
    cQuery += "     AND SZB.ZB_VEND = '" + M->C5_VEND1 + "' "
    cQuery += "     AND SZB.ZB_COND = '" + M->C5_CONDPAG + "' "

    Memowrite('ValidCond.SQL',cQuery)

	ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTabCond,.F.,.T.)
	dbSelectArea(cTabCond)
	(cTabCond)->(dbGoTop())
    If ! (cTabCond)->( Eof() )
        lRet := .T.
    EndIf
    (cTabCond )->( DbCloseArea() )
EndIf

If !lRet
    MsgStop("Condicao nao autorizada para este vendedor!")
Endif

Return (lRet)

// ValProd - Regras de Produtos
// Filtra os produtos do vendedor

Static Function ValProd()
Local aArea    := GetArea()
Local cQuery   := ""
Local cTabProd := GetNextAlias()
Local lRet     := .F.

lRet := ValOperV()

If !EMPTY(M->C5_VEND1) .AND. !EMPTY(M->C5_TABELA) .AND. !EMPTY(M->C6_PRODUTO) 

    cQuery := "SELECT DA1.DA1_CODPRO "
    cQuery += " FROM " + RetSQLName("DA1") + " DA1 "
    cQuery += "       INNER JOIN " + RetSQLName("SB1") + " SB1 ON SB1.D_E_L_E_T_ <> '*' AND SB1.B1_COD = DA1.DA1_CODPRO "
    cQuery += "       INNER JOIN " + RetSQLName("SZC") + " SZC ON SZC.D_E_L_E_T_ <> '*' AND SZC.ZC_GRPROD = SB1.B1_GRUPO AND SZC.ZC_VEND = '" + M->C5_VEND1 + "' "
    cQuery += " WHERE DA1.D_E_L_E_T_ <> '*' AND DA1.DA1_CODTAB = '" + M->C5_TABELA + "' AND DA1.DA1_CODPRO = '" + M->C6_PRODUTO + "' "

	Memowrite('ValProd.SQL',cQuery)

	ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTabProd,.F.,.T.)
	dbSelectArea(cTabProd)
    (cTabProd)->(dbGoTop())
    If (cTabProd)->( Eof() )
        lRet := .F.
    EndIf
    (cTabProd )->( DbCloseArea() )
EndIf

If !lRet
    MsgStop("Produto nao autorizado ou nao existe na tabela deste vendedor!")
Endif
RestArea(aArea)

Return (lRet)

// GatPromo - Regras de Produtos Promocionais
// Valida utilização dos produtos promocionais cadastrados

User Function GatPromo()
Local aArea    := GetArea()
Local cRet     := "1"       // M->C6_XOFERTA 
Local lTemProm := .F.
Local nPreco   := M->C6_PRCVEN
Local nPosPreco:= aScan( aHeader, {|x| Alltrim(x[2]) == 'C6_PRCVEN'})
Local nPosDescP:= aScan( aHeader, {|x| Alltrim(x[2]) == 'C6_DESCONT'})
Local nPosDescV:= aScan( aHeader, {|x| Alltrim(x[2]) == 'C6_VALDESC'})
//Local nPosComis:= aScan( aHeader, {|x| Alltrim(x[2]) == 'C6_COMIS1'})

If ! GetMV('FS_REGRATB',,.F.) .OR. l410Auto 
    Return( cRet )
ENDIF

If !EMPTY(M->C6_PRODUTO)
   DbSelectArea("SZD")
    DbSetOrder(1)
    If DbSeek( xFilial("SZD") + M->C5_TABELA + SA1->A1_EST + M->C6_PRODUTO )
        IF SZD->ZD_DTVLD <= DATE()
            lTemProm := .T.
        EndIf
    EndIf
EndIf
If lTemProm
    nPreco:=SZD->ZD_VLRPROM
    If MsgYesNo("Deseja utilizar o preço promocional de R$" + TRANSFORM(nPreco,"@E 999,999.99") + " ?","PREÇO PROMOCIONAL")
        cRet := "2" 
        aCols[n,nPosPreco] := nPreco
        aCols[n,nPosDescP] := 0
        aCols[n,nPosDescV] := 0
        //aCols[n,nPosComis] := 0
    Endif
Endif

RestArea(aArea)

Return (cRet)

// ValDesC - Verifica limite de desconto e preço mínimo
// Valida o limite de desconto dos itens do pedido (C6_DESCONT ou C6_VALDESC)

User Function ValDesc(cValPer)
Local aArea     := GetArea()
Local lRet      := .F.
Local nPosPrd   := aScan( aHeader, {|x| x[2] == 'C6_PRODUTO'})
Local nPosDescP := aScan( aHeader, {|x| Alltrim(x[2]) == 'C6_DESCONT'})
Local nPosPrcV  := aScan( aHeader, {|x| Alltrim(x[2]) == 'C6_PRCVEN'})
Local cGRPPRD   := ''
Local cProduto  := acols[n,nPosPrd] 
Local nDesc     := Iif(cValPer == "P", M->C6_DESCONT, aCols[n,nPosDescP])
Local nPrcVen   := aCols[n,nPosPrcV]
//Local nCustoMrk := 0

If ! GetMV('FS_REGRATB',,.F.) .OR. l410Auto 
    Return( .T. )
ENDIF

lRet := ValOperV()

If lRet 
    If nDesc > 0
        If EMPTY( cProduto )
            MsgStop("FALTA CODIGO DO PRODUTO")
        Else
            DbSelectARea("SB1")
            SB1->( dbSetOrder(1) )
            If DbSEEK( xFilial("SB1") + cProduto ) 
                cGRPPRD := SB1->B1_GRUPO
                DbSelectARea("SZC")
                DbSetOrder(1)
                // validação de margem de desconto
                IF DBSEEK( xFilial("SZC") + M->C5_VEND1 + cGRPPRD )
                    IF nDesc > SZC->ZC_DESMAX
                        MsgStop("Desconto acima do limite do vendedor ( " + Transform(SZC->ZC_DESMAX,"99%") + " ) !")
                        // Validação de Preço Mínimo.
                        lRet := U_ValPrcMin(nPrcVen) //nPrcVen já esta com o desconto aplicado. //,nDesc)
                    ELSEIF nDesc < SZC->ZC_DESMIN
                        MsgStop("Desconto abaixo do limite do vendedor ( " + Transform(SZC->ZC_DESMIN,"99%") + " ) !")
                    ELSE
                        lRet := .T.
                    ENDIF
                Else
                    MsgStop("Vendedor nao autorizado para esse grupo de produtos")
                ENDIF
            ENDIF
        ENDIF
    EndIf
Endif
RestArea(aArea)
Return( lRet )

//Função para validação do preço minimo

User Function ValPrcMin( _nPrcVen ) //, _nDesc)
Local aArea     := GetArea()
Local lRet      := .F.
Local nPrcVen   := _nPrcVen //_nPrcVen - (_nPrcVen * _nDesc / 100 )
Local nCustoMrk := SB1->B1_CUSTD    // Preço Stand conforme orientacao do Silas

DbSelectARea("SB2")
DbSetOrder(1)
If DbSEEK( xFilial("SB2") + SB1->B1_COD ) 
    nCustoMrk := SB2->B2_CM1
    DbSelectARea("SBZ")
    DbSetOrder(1)
    If DbSEEK( xFilial("SBZ") + SB1->B1_COD )
        nCustoMrk := (SB2->B2_CM1 + ((SB2->B2_CM1*SBZ->BZ_MARKUP)/100))
    Else
        MsgStop("Sem percentual de MarkUp, sera utilizado custo STANDARD pra calcular o preco minimo de venda  !")
    EndIf
Else
    MsgStop("Nao foi possivel identificar o preco minimo de venda pela tabela SB2, sera utilizado a SB1 !")
EndIf

RestArea(aArea)

If nPrcVen < nCustoMrk
    MsgStop("O valor minimo de venda deve ser maior ou igual ao valor de custo + índice markup, sendo R$" + TRANSFORM(nCustoMrk,"@E 999,999.99") + " !")
ELSE
   lRet := .T.
Endif

Return( lRet )

// Libera edição dos campos C6_PRCVEN, C6_VALOR, C6_DESCONT, C6_VALDESC, C6_COMIS1 se C6_XOFERTA for igual a 1 ou 3

User Function Oferta()
Local lRet := .T.
Local nPosXofer:= aScan( aHeader, {|x| Alltrim(x[2]) == 'C6_XOFERTA'})

    lRet := ( aCols[n][nPosXofer] == '1' .or. aCols[n][nPosXofer] == '3')

Return( lRet)

// GatDesC - Gatilha os campos C6_XOFERTA e C6_XBLQ
// De acordo com o limite de desconto dos itens do pedido (C6_DESCONT ou C6_VALDESC)

User Function GatDesc()
Local nPosPrd  := aScan( aHeader, {|x| x[2] == 'C6_PRODUTO'})
Local nPosXofer:= aScan( aHeader, {|x| Alltrim(x[2]) == 'C6_XOFERTA'})
Local nPosDescP:= aScan( aHeader, {|x| Alltrim(x[2]) == 'C6_DESCONT'})
Local nPosXblq := aScan( aHeader, {|x| Alltrim(x[2]) == 'C6_XBLQ'})
Local nPosComis:= aScan( aHeader, {|x| Alltrim(x[2]) == 'C6_COMIS1'})
Local cGRPPRD  := ''
Local cProduto := acols[n,nPosPrd] 
Local cRet     := aCols[n,nPosXofer]
Local nDesc    := aCols[n,nPosDescP]
Local nComis   := aCols[n,nPosComis]

If ! GetMV('FS_REGRATB',,.F.) .OR. l410Auto 
    Return( cRet )
ENDIF

lRet := ValOperV()

If lRet 
    If nDesc > 0
        If EMPTY( cProduto )
            MsgStop("FALTA CODIGO DO PRODUTO")
        Else
            DbSelectARea("SB1")
            SB1->( dbSetOrder(1) )
            If DbSEEK( xFilial("SB1") + cProduto ) 
                cGRPPRD := SB1->B1_GRUPO
                DbSelectARea("SZC")
                DbSetOrder(1)
                If DBSEEK( xFilial("SZC") + M->C5_VEND1 + cGRPPRD )
                    If nDesc > SZC->ZC_DESMAX // .or. nDesc < SZC->ZC_DESMIN
                        aCols[n,nPosXofer] := '3' // Oferta passa a ser fora alçada de desconto.
                        aCols[n,nPosXblq ] := '1' // Bloqueio o pedido.
                        aCols[n,nPosComis] := SZC->ZC_COMIS
                        cRet := '3'
                    ENDIF
                ENDIF
            ENDIF
        ENDIF
    Else
        // Caso os campos C6_DESCONT ou C6_VALDESC estejam zerado volta o pedido para normal e desbloqueia o mesmo
        aCols[n,nPosXofer] := '1' // Volto a oferta para normal.
        aCols[n,nPosXblq ] := '2' // Desbloqueio o pedido.
        aCols[n,nPosComis] := nComis
        cRet := '1'
    EndIf
Endif
Return( cRet )

// ConsReg - Semaforo de Campos obrigatorios nas regras

User Function ConsReg()
Local bRetorno  := { || .F. }
Local aArea 	:= GetArea()
Local cCampo	:= ReadVar()
Local lRegra    := U_USAREGRA()

If lRegra
    IF Empty( M->C5_CLIENTE )
        MsgStop("Falta preencher o codigo do cliente","Campo obrigatorio")
        Return( Eval( bRetorno ) )
    ElseIf Empty( M->C5_XOPER )
        MsgStop("Falta preencher o campo de Tp.operacao","Campo obrigatorio")
        Return( Eval( bRetorno ) )
    ElseIf Empty( M->C6_TABELA )
        If Empty( M->C5_VEND1 )
            MsgStop("Falta preencher o campo de Vendedor","Campo obrigatorio")
            Return( Eval( bRetorno ) )
        Endif
    ElseIf Empty( M->C6_PRODUTO )
        If Empty( M->C5_VEND1 )
            MsgStop("Falta preencher o campo de Vendedor","Campo obrigatorio")
            Return( Eval( bRetorno ) )
        ElseIf Empty( M->C5_TABELA )
            MsgStop("Falta preencher o tabela de preco","Campo obrigatorio")
            Return( Eval( bRetorno ) )
        Endif
    Endif
Endif

Do Case 
    Case cCampo == 'M->C5_TABELA'
        bRetorno 	:= { || Conpad1(,,,'DA0',,,.F.) }
    Case cCampo == 'M->C5_CONDPAG'
        bRetorno 	:= { || Conpad1(,,,'SE4',,,.F.) }
    Case cCampo == 'M->C6_PRODUTO'
        bRetorno 	:= { || Conpad1(,,,'SB1',,,.F.) }
EndCase

If IsInCallStack('MATA410')
    If lRegra .and. AllTrim( M->C5_XOPER ) $ GetMV('FS_OPERVEN',,"01/02/04")
        Do Case 
            Case cCampo == 'M->C5_TABELA'
                bRetorno 	:= { || Iif(GetMV('FS_REGRATB',,.F.),Conpad1(,,,'DA0X',,,.F.),Conpad1(,,,'DA0',,,.F.)) }
            Case cCampo == 'M->C5_CONDPAG'
                bRetorno 	:= { || Iif(GetMV('FS_REGRATB',,.F.),Conpad1(,,,'SE4X',,,.F.),Conpad1(,,,'SE4',,,.F.)) }
            Case cCampo == 'M->C6_PRODUTO'
                bRetorno 	:= { || Iif(GetMV('FS_REGRATB',,.F.),Conpad1(,,,'SB1X',,,.F.),Conpad1(,,,'SB1',,,.F.)) }
        EndCase
    Endif
Endif

RestArea(aArea)

Return( Eval( bRetorno ) )

User Function FiltraDA0()
Local cQuery
Local cSQL := "@DA0_CODTAB IN ('')" 
Local cTab := GetNextAlias()

If !Empty(M->C5_CLIENTE) .AND. !Empty(M->C5_VEND1)
    cQuery := "SELECT DA0.DA0_CODTAB" 
    cQuery += " FROM  " + RetSQLName("SZA") + " SZA "
    cQuery += "	    INNER JOIN " + RetSQLName("DA0") + " DA0 ON DA0.DA0_CODTAB = SZA.ZA_TABELA AND DA0.D_E_L_E_T_ <> '*'"
    cQuery += " WHERE   SZA.D_E_L_E_T_ <> '*'"
    cQuery += "     AND SZA.ZA_FILIAL = '" + xFilial( "SZA" ) + "'" 
    cQuery += "     AND SZA.ZA_VEND = '" + M->C5_VEND1 + "' "
    cQuery += "	    AND SZA.ZA_CODMUN+SZA.ZA_UF IN (SELECT SA1.A1_COD_MUN+SA1.A1_EST FROM " + RetSQLName("SA1") + " SA1 WHERE SA1.D_E_L_E_T_ <> '*' AND SA1.A1_COD + SA1.A1_LOJA = '" + M->C5_CLIENTE+M->C5_LOJACLI + "')"

    Memowrite('FiltraDA0.SQL',cQuery)
    ChangeQuery(cQuery)
    DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTab,.F.,.T.)
    dbSelectArea(cTab)
    (cTab)->(dbGoTop())
    If ! (cTab)->( Eof() )
        cSQL := "@DA0_CODTAB IN (" 
        While !(cTab)->( Eof() )
            cSQL += "'" + AllTrim((cTab)->DA0_CODTAB) + "',"
            (cTab)->( DbSkip() )
        EndDo
        cSQL := Substr(cSQL,1,len(cSQL)-1) + ")"
    Endif
    (cTab )->( DbCloseArea() )
EndIf

Return cSQL

User Function FiltraSE4()
Local cQuery:= ""
Local cSQL  := "@E4_CODIGO IN ('')" 
Local cTab  := GetNextAlias()

If !Empty(M->C5_VEND1)

    cQuery := "SELECT SE4.E4_CODIGO " 
    cQuery += " FROM "
    cQuery += "	    " + RetSQLName("SZB") + " SZB "
    cQuery += "	    INNER JOIN " + RetSQLName("SE4") + " SE4 ON SE4.E4_CODIGO = SZB.ZB_COND AND SE4.D_E_L_E_T_ <> '*'"
    cQuery += " WHERE SZB.D_E_L_E_T_ <> '*'"
    cQuery += "     AND SZB.ZB_FILIAL = '" + xFilial( "SZB" ) + "'" 
    cQuery += "     AND SZB.ZB_VEND = '" + M->C5_VEND1 + "' "

    Memowrite('FiltraSE4.SQL',cQuery)
    ChangeQuery(cQuery)
    DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTab,.F.,.T.)
    dbSelectArea(cTab)
    (cTab)->(dbGoTop())
    If !(cTab)->( Eof() )
        cSQL := "@E4_CODIGO IN (" 
        While !(cTab)->( Eof() )
            cSQL += "'" + AllTrim((cTab)->E4_CODIGO) + "',"
            (cTab)->( DbSkip() )
        EndDo
        (cTab )->( DbCloseArea() )
        cSQL := Substr(cSQL,1,len(cSQL)-1) + ")"
    Endif
EndIf

Return cSQL

User Function FiltraSB1()
Local cQuery
Local cSQL  := "@B1_COD IN ('')" 
Local cTab  := GetNextAlias()

If !Empty(M->C5_TABELA) .AND. !Empty(M->C5_VEND1)
 
    cQuery := "SELECT DA1.DA1_CODPRO "
    cQuery += " FROM " + RetSQLName("DA1") + " DA1 "
    cQuery += "       INNER JOIN " + RetSQLName("SB1") + " SB1 ON SB1.D_E_L_E_T_ <> '*' AND SB1.B1_COD = DA1.DA1_CODPRO "
    cQuery += "       INNER JOIN " + RetSQLName("SZC") + " SZC ON SZC.D_E_L_E_T_ <> '*' AND SZC.ZC_GRPROD = SB1.B1_GRUPO AND SZC.ZC_VEND = '" + M->C5_VEND1 + "' "
    cQuery += " WHERE DA1.D_E_L_E_T_ <> '*' AND DA1.DA1_CODTAB = '" + M->C5_TABELA + "' "

    Memowrite('VerTab.SQL',cQuery)
    ChangeQuery(cQuery)
    DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cTab,.F.,.T.)
    dbSelectArea(cTab)
    (cTab)->(dbGoTop())
    If !(cTab)->( Eof() )
        cSQL  := "@B1_COD IN ("
        While !(cTab)->( Eof() )
            cSQL += "'" + AllTrim((cTab)->DA1_CODPRO) + "',"
            (cTab)->( DbSkip() )
        EndDo
        (cTab )->( DbCloseArea() )
        cSQL := Substr(cSQL,1,len(cSQL)-1) + ")"
    Endif
Else
    cSQL := "" 
EndIf

Return cSQL

// CAMPO WHEN DA C5_CONDPG

User Function Feira() 
Local lRet := .T.

IF DA0->( FieldPos("DA0_XFEIRA") ) > 0 
    IF ! Empty( M->C5_TABELA)
        IF ! Empty( POSICIONE("DA0",1, xFilial("DA0") + M->C5_TABELA,"DA0_CONDPG") )
            IF DA0->DA0_XFEIRA == "1"
                M->C5_CONDPAG := DA0->DA0_CONDPG
                lRet := .F.
            Endif
        Endif
    Endif
Endif

Return lRet

// VALIDAÇÃO PARA USO NO CAMPO DA0_COND

User Function TabFeira( _cCond ) 
Local lRet := .T.

IF DA0->( FieldPos("DA0_XFEIRA") )> 0 
    IF M->DA0_XFEIRA == "1" .AND. EMPTY( _cCond )
        lRet := .F.
        MsgStop("Condicao de pagamento obrigatorio para tabela de feira !")
    Endif
Endif

Return lRet

// VALIDAÇÃO PARA USO NO CAMPO C5_CONDPAG

User Function PedFeira() 
Local lRet := .T.

IF ! EMPTY( M->C5_TABELA ) 
    IF DA0->( FieldPos("DA0_XFEIRA") ) > 0 
        IF DA0->DA0_XFEIRA == "1" 
            If  EMPTY( M->C5_TABELA )
                lRet := .F.
                MsgStop("Condicao de pagamento obrigatorio para tabela de feira !")
            Else
                M->C5_TABELA := DA0->DA0_CONDPG
            Endif
        Endif
    Endif
ENDIF

Return lRet

User Function GatComis()
Local nRet     := 0
Local cGRPPRD  := ''

If ! GetMV('FS_REGRATB',,.F.)
    Return( nRet )
ENDIF

If ! AllTrim( M->C5_XOPER ) $ GetMV('FS_OPERVEN',,"01/02/04")
    Return( nRet )
Endif

IF EMPTY( M->C5_VEND1 )
    MsgStop("FALTA CODIGO DO VENDEDOR")
Elseif EMPTY( M->C6_PRODUTO )
    MsgStop("FALTA CODIGO DO PRODUTO")
Else
    DBSELECTAREA('SB1')
    SB1->( dbSetOrder(1) )
    If DbSEEK( xFilial("SB1") + M->C6_PRODUTO ) 
        cGRPPRD := SB1->B1_GRUPO
        DBSELECTAREA('SZC')
        SZC->( dbSetOrder(1) )
        If SZC->( DbSEEK( xFilial("SZC") + M->C5_VEND1 + cGRPPRD )) // ESTAVA BUSCANDO FILIAL SB1 MAS O MODO DE COMP É # DA SZC
            nRet := SZC->ZC_COMIS
        Else
            MsgStop("Nao achou a regra!")
        ENDIF
    ELSE
        MsgStop("Nao achou o produto!")
    Endif
Endif

Return( nRet )

User Function SC6Oper
Local lRet := .T.

lRet := ! GetMV('FS_REGRATB',,.F.)

Return( lRet )

User Function BlocPed()
Local aArea     := GetArea()
Local nLinha    := 0
Local nPosXBLQ  := aScan( aHeader, {|x| Alltrim(x[2]) == 'C6_XBLQ'  })
Local nPosTOT   := aScan( aHeader, {|x| Alltrim(x[2]) == 'C6_VALOR' })
Local cBloq     := ""
Local lEmailOK  := .F.
Local nTotal    := 0

If Type("l410Auto") == "U" .OR. l410Auto     // Ignora se não identificar a origem do cadastro ou se for um EXECAUTO
    Return    
Endif

If Alltrim(M->C5_XOPER) $ GetMV('FS_REGRAGA',,"01/02/04")
    Return    
Endif

For nLinha := 1 TO Len(aCols) //Vare os itens do Pedido para saber se deve bloquear por Regra de Desconto (gatilho preenche o campo C6_XBLQ)
    nTotal += aCols[nLinha,nPosTOT]
    If aCols[nLinha,nPosXBLQ] == "1"
        cBloq   := "X"
    EndIf
Next

If Empty( cBloq ) //cBloq verifica a Regra de Preços e Descontos - quando vazio passa para Bloqueio em Garantia
    If M->C5_TIPO == "N"
        If nTotal > GetMV('FS_VLRGAR',,0)
            cBloq     := "Y"
        Endif
    Endif
Endif

dbSelectArea("SC5")
RecLock("SC5",.F.)

If cBloq == "X"
    MsgAlert("Bloqueio Comercial !","Bloqueio de Pedido")
    If M->C5_XAPROVA == "N"
        lEmailOK := U_WFBlqVen()
    Else
        If MsgYesNo("E-mail Já enviado anteriormente, deseja enviar novamente?","Envio de Email de Aprovação")
            lEmailOK := U_WFBlqVen()
        Endif
    EndIf
EndIf
If lEmailOK
    SC5->C5_XAPROVA := "S"
    MsgInfo("E-mail de Solicitação de Aprovação Enviado Com Sucesso!")
EndIf

SC5->C5_BLQ := cBloq
MsUnlock()

RestArea(aArea)

Return

User Function CampObr( _cCampo )
Local lRet   := .T.
Local aLista := {}
Local aCampos:= {}
Local i      := 0

aAdd( aLista, { "1","C5_XOPER"    ,"Tipo de Operacao"}  )
aAdd( aLista, { "2","C5_CLIENTE"  ,"Cliente"         }  )
aAdd( aLista, { "3","C5_VEND1"    ,"Vendedor"        }  )
aAdd( aLista, { "4","C5_TABELA"   ,"Tabela de Preco" }  )
aAdd( aLista, { "5","C6_PRODUTO"  ,"Produto"         }  )

Do Case 
    Case _cCampo == "M->C5_XOPER"
        aCampos := {"1"}
    Case _cCampo == "M->C5_VEND1"
        aCampos := {"1","2","3"}
    Case _cCampo == "M->C5_CONDPAG"
        aCampos := {"1","3"}
    Case _cCampo == 'M->C5_TABELA'
        aCampos := {"1","2","3","4"}
    Case _cCampo == 'M->C6_PRODUTO'
        aCampos := {"1","2","3","4","5"}
EndCase

For i := 1 to Len( aCampos )
    nPos := aScan( aLista, {|x| x[1] == aCampos[i] })
    cCampo := "M->" + aLista[ nPos ][2]
    If Empty( &cCampo )
        MsgStop("Este campo necessita da informacao do " + aLista[nPos,3] + " !","Bloqueio de campo")
        lRet := .F.
    Endif
Next

Return( lRet )

// Validacao de campos para Regras de Precos e descontos
User Function CMPREGRA
Local lRet := .T.
Local nLinha    := 0

// Ignora se não identificar a origem do cadastro ou se for um EXECAUTO
If Type("l410Auto") == "U" .OR. l410Auto     
    Return(lRet)   
Endif

// Nao valida as regras se for uma EXCLUSAO
IF ! ALTERA .AND. ! INCLUI
    Return(lRet)   
Endif

// Condicoes que nao validam as regras de precos e descontos 
If ! U_USAREGRA()
    Return(lRet)   
Endif

If Empty(M->C5_XOPER)
    MsgStop("Campo de Operacao e Obrigatorio !")
    lRet := .F.
EndIf

If lRet 
    If M->C5_XOPER $ GetMV('FS_OPERVEN',,"01/02/04")
        If ! GetMV('FS_REGRATB',,.F.)
            MsgAlert("Operacao nao permitida para esta filial !")
            lRet := .F. 
        Endif
        If lRet 
            If EMPTY(M->C5_VEND1)
                MsgStop("Campo vendedor e Obrigatorio para operacao de venda !")
                lRet := .F.
            Endif
            If EMPTY(M->C5_CONDPAG)
                MsgStop("Campo condicao de pagamento e Obrigatorio para operacao de venda !")
                lRet := .F.
            Endif
            If EMPTY(M->C5_TABELA)
                MsgStop("Campo Tabela de Preco e Obrigatorio para operacao de venda !")
                lRet := .F.
            Endif
        Endif
    Endif
Endif

For nLinha := 1 TO Len(aCols) //Vare os itens do Pedido para saber se deve bloquear por Regra de Desconto (gatilho preenche o campo C6_XBLQ)
    aCols[nLinha,aScan( aHeader, {|x| Alltrim(x[2]) == 'C6_QTDLIB'  })] := 0
Next

Return( lRet )

// Chamadas de Outros Modulos que nao devem utilizar as regras de precos e descontos
User Function USAREGRA()
Local lRet  := .T.

// Ignora se não identificar a origem do cadastro ou se for um EXECAUTO
If Type("l410Auto") == "U" .OR. l410Auto 
    lRet := .F.   
Endif

If       IsInCallStack("VEIXA018")      ;   // VEICULOS       - Função que não obriga o preenchimento de campos
    .OR. IsInCallStack("OFIXA100")      ;   // OFICINA        - Função que não obriga o preenchimento de campos
    .OR. IsInCallStack("OFIXA011")      ;   // OFICINA BALCAO - Função que não obriga o preenchimento de campos
    .OR. IsInCallStack("GCSC5BRW")      ;   // P.E. Gestao de Cereais
    .OR. IsInCallStack("MOV01ADEV")     ;   // P.E. Gestao de Cereais
    .OR. IsInCallStack("AUT001NFS")     ;   // P.E. Gestao de Cereais
    .OR. IsInCallStack("AUT004NFS")     ;   // P.E. Gestao de Cereais
    .OR. IsInCallStack("AUT004DOCS")    ;   // P.E. Gestao de Cereais
    .OR. IsInCallStack("AUT005DOCS")    ;   // P.E. Gestao de Cereais
    .OR. IsInCallStack("CTS01GRDEV")    ;   // P.E. Gestao de Cereais
    .OR. IsInCallStack("CTV01NFEXP")    ;   // P.E. Gestao de Cereais
    .OR. IsInCallStack("U_CTV01NFMAN")  ;   // P.E. Gestao de Cereais
    .OR. IsInCallStack("CTC01ENFGH")    ;   // P.E. Gestao de Cereais
    .OR. IsInCallStack("CTC01ENFF7")    ;   // P.E. Gestao de Cereais
    .OR. IsInCallStack("CTS01BENPR")    ;   // P.E. Gestao de Cereais
    .OR. IsInCallStack("CTT01GERPV")    ;   // P.E. Gestao de Cereais
    .OR. IsInCallStack("CTT01EXCPV")    ;   // P.E. Gestao de Cereais
    .OR. IsInCallStack("CTT001SWCT")    ;   // P.E. Gestao de Cereais
    .OR. IsInCallStack("CTV01NFCMP")    ;   // P.E. Gestao de Cereais
    .OR. IsInCallStack("MONTADOCDEV")   ;   // P.E. Gestao de Cereais
    .OR. IsInCallStack("AUT001EXCDOCS") ;   // P.E. Gestao de Cereais
    .OR. IsInCallStack("AUT004EXCDOCS") ;   // P.E. Gestao de Cereais
    .OR. IsInCallStack("AUT005EXCDOCS") ;   // P.E. Gestao de Cereais
    .OR. IsInCallStack("MONTADOCSAIDA")     // P.E. Gestao de Cereais
    lRet := .F.
Endif

Return( lRet )

//Ajusta menu Pedido de VEndas
User Function CFXGMNUPV()

//Rotina de preparação Documento de Saida ("Ma410PvNfs")
aRotina[ascan(arotina,{|x| alltrim(x[2]) == "Ma410PvNfs"}),2] := "u_CFXGBLOQ()"

Return()

//Nao permite acessar rotina se pedido bloqueadp
User Function CFXGBLOQ()

If SC5->C5_BLQ == "Y" //Bloqueado em Garantia
    MsgStop("Pedido Bloqueado em Garantia")
ElseIf SC5->C5_BLQ == "Y" //Bloqueado Regras de Preços e Descontos
    MsgStop("Pedido Bloqueado por Regras de Preços e Descontos")
Else
    Ma410PvNfs()
EndIf

Return
