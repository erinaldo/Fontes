#Include 'Protheus.ch'

/*-----------------+---------------------------------------------------------+
!Nome              ! A710PAR - Cliente: Madero                               !
+------------------+---------------------------------------------------------+
!Descrição         ! PE para definir parametros do MRP                       !
+------------------+---------------------------------------------------------+
!Autor             ! Pedro A. de Souza                                       !
+------------------+---------------------------------------------------------!
!Data              ! 30/05/2018                                              !
+------------------+--------------------------------------------------------*/
User Function A710PAR()
Local aRet       := {}
Local nParm1     := PARAMIXB[1]
Local nParm2     := PARAMIXB[2]
Local aParm3     := PARAMIXB[3]
Local aParm4     := PARAMIXB[4]
Local lParm5     := PARAMIXB[5]
Local aArea710PAR:=GetArea()
		
	If AllTrim(FunName()) <> "EST100"
		aadd(aRet,{nParm1,nParm2,aParm3,aParm4,lParm5})
		RestArea(aArea710PAR)
		return aRet	
	EndIf 

    MV_PAR01 := 1  // Executa o MRP considerando a previsão de vendas
	MV_PAR02 := 1  // Gera SCs pela necessidade 
	MV_PAR03 := 1  // Gera OPs dos produtos intermediários por necessidade
	MV_PAR04 := 2  // Gera OPs e SCs utilizando o mesmo período (1 = Junto)
	MV_PAR05 := dDataBase // Data inicial da previsão de vendas 
	MV_PAR06 := dDataBase + ADK->ADK_XNDES  // Data final da previsão de vendas 
	MV_PAR07 := 2  // Incrementa OPs por número 
	MV_PAR08 := "  " // Armazém inicial 
	MV_PAR09 := "ZZ" // Armazém Final
	MV_PAR10 := 2  // Tipo da OP a ser gerada  (2 = Prevista)
	MV_PAR11 := 1  // Apaga ordens de produção previstas (1 = Sim)
	MV_PAR12 := 1  // Considera sábados e domingos(1 = Sim)
	MV_PAR13 := 1  // Considera OPs suspensas(1 = Sim) 
	MV_PAR14 := 1  // Considera OPs sacramentadas (1 = Sim)
	MV_PAR15 := 1  // Recalcula níveis das estruturas (1 = Sim)
	MV_PAR16 := 2  // Gera OPs Aglutinadas (2 = Nao)
	MV_PAR17 := 2  // Não exclui pedidos de venda  (2 = Nao Subtrai)
	MV_PAR18 := 1  // Considera o saldo atual em estoque (1 = Saldo Atual) 
	MV_PAR19 := 1  // Se atingir o estoque máximo, considera a quantidade original(1 = Qtde Original)
	MV_PAR20 := 2  // Não considera saldo em poder de terceiros (2 = Ignora)
	MV_PAR21 := 2  // Não considera saldo de terceiros em nosso poder (2 = Ignora)
	MV_PAR22 := 2  // Não subtrai saldos rejeitados pelo CQ  (2 = Nao Subtrai Rej)
	MV_PAR23 := "         "   // Documento inicial 
	MV_PAR24 := "ZZZZZZZZZ"   // Documento Final
	MV_PAR25 := 2  //  Não subtrai saldos bloqueados por lote ("2" = Nao Subtrai )
	MV_PAR26 := 1  //  Considera estoque de segurança                        ( 1 = Sim )
	MV_PAR27 := 2  //  Não considera pedidos de vendas bloqueados por crédito  ( 2 = Não )
	MV_PAR28 := 2  //  Não resume dados                                      ( 2 = Não )
	MV_PAR29 := 2  //  Não detalha lotes vencidos                            ( 2 = Não )
	MV_PAR30 := 1  //  Pedidos de Venda  faturados ?                 ( 2 = Nao Subtrai  )
	MV_PAR31 := 1  //  Considera Ponto de Pedido ?                            ( 1 = Sim )
	MV_PAR32 := 1  //  Gera base de dados com o cálculo da necessidade       ( 1 = Sim )
	MV_PAR33 := "  "
	MV_PAR34 := "  "
	MV_PAR35 := 1  // Exibe resultados em lista
//	conOut('Alterando os parametros do MATA712 '+varinfo('PARAMIXB', PARAMIXB,,,.f.))
//	conOut('Parametros 5 e 6 '+dtoc(MV_PAR05)+ ' a '+dtoc(MV_PAR06))
	nParm1 := 1
	nParm2 := ADK->ADK_XNDES
	aParm3 := {}
    dbSelectArea("SX5")
    SX5->(dbSetOrder(1))
    SX5->(dbSeek(xFilial("SX5")+"ZC"))
    Do While (SX5->X5_FILIAL == xFilial("SX5")) .AND. (SX5->X5_TABELA == "ZC") .and. !SX5->(Eof())
        cCapital := OemToAnsi(Capital(X5Descri()))        
        AADD(aParm3,{.T.,SubStr(SX5->X5_chave,1,2)+" - "+cCapital})
        SX5->(dbSkip())
    EndDo
	lParm5 := .T.
	aadd(aRet, {nParm1,nParm2,aParm3,aParm4,lParm5})
	
	RestArea(aArea710PAR)

return aRet