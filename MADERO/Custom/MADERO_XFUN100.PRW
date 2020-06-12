/*                                                    
+------------------+-------------------------------------------------------------------------------+
! Nome             ! XFUN100                                                                       !
+------------------+-------------------------------------------------------------------------------+
! Descrição        ! Funções customizadas utilizadas no projeto                                    !
!                  !                                                                               !
+------------------+-------------------------------------------------------------------------------+
! Autor            ! Márcio Zaguetti                                                               !
+------------------+-------------------------------------------------------------------------------+
! Data             ! 14/05/2018                                                                    !
+------------------+-------------------------------------------------------------------------------+
! Parametros       ! N/A                                                                           !
+------------------+-------------------------------------------------------------------------------+
! Retorno          ! N/A                                                                           !
+------------------+-------------------------------------------------------------------------------+
*/                                                                                
#Include 'Protheus.ch'
#Include "topconn.ch"

/*                                                    
+------------------+-------------------------------------------------------------------------------+
! Nome             ! xSB1SC7                                                                       !
+------------------+-------------------------------------------------------------------------------+
! Descrição        ! Atualiza os campos do pedido de acordo com gatilho e funções de validação dos !
!                  ! campos da tabela SC7                                                          !
+------------------+-------------------------------------------------------------------------------+
*/                                                                                
User Function xSB1SC7(cFld,cTp)
Local aArea     :=GetArea()
Local axRet     :={}
Local lxCont    :=.F.
Local xAux      
Local nAux      :=0
Local nA5XCVUNF :=0
Local cA5XCVUNF :=""
Local cA5CODTAB :=""
Local nC7PRODUTO:=AScan(aHeader,{|x| AllTrim(x[2])=="C7_PRODUTO"})
Local nC7QUANT  :=AScan(aHeader,{|x| AllTrim(x[2])=="C7_QUANT"}  )
Local cC7PRODUTO:=aCols[n,nC7PRODUTO]
Local cQuery    := ""
Local cAliasQry	:= GetNextAlias( )

   Aadd(axRet,{"C7_PRODUTO","C7_CODTAB","C7_OPER","C7_XCODPRF","C7_PRECO","C7_CC","C7_XQTDPRF","C7_XUNPRF"})   
   Aadd(axRet,{.T.         ,.T.        ,.T.      ,.T.         ,.T.       ,.T.    ,.T.         ,.T.        })
   Aadd(axRet,{cC7PRODUTO  ,""         ,""       ,""          ,0.00      ,""     ,0.00        ,""         })
   	   	
   // -> Pesquisa item no cadastro de produtos x fornecedor
   cQuery :="SELECT A5_XCVUNF, A5_XTPCUNF, A5_PRODUTO, A5_FORNECE, A5_LOJA, A5_CODTAB, A5_XOPER, A5_CODPRF " + CRLF 
   cQuery +="FROM " + RetSQLName("SA5") + " SA5 "          + CRLF 
   cQuery +="WHERE A5_FILIAL  = '" + xFilial("SA5") + "' AND " + CRLF  
   cQuery +="      A5_FORNECE = '" + CA120FORN      + "' AND " + CRLF
   cQuery +="      A5_LOJA    = '" + CA120LOJ       + "' AND " + CRLF
   cQuery +="      A5_PRODUTO = '" + cC7PRODUTO     + "' AND " + CRLF
   cQuery +="      A5_XATIVO  = 'S'                          " + CRLF
   dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)	   
   (cAliasQry)->(DbGoTop())
   While !(cAliasQry)->(Eof())
	  nA5XCVUNF:=(cAliasQry)->A5_XCVUNF
	  cA5XCVUNF:=(cAliasQry)->A5_XTPCUNF
	  axRet[2,3]:=.T.
	  axRet[3,3]:=(cAliasQry)->A5_XOPER
	  axRet[2,4]:=.T.
	  axRet[3,4]:=(cAliasQry)->A5_CODPRF 
	  axRet[2,7]:=.T.
	  axRet[3,7]:=u_C104PRF(aCols[n,nC7QUANT],CA120FORN,CA120LOJ,cC7PRODUTO,.T.)[1]
	  axRet[2,8]:=.T.
	  axRet[3,8]:=u_C104PRF(aCols[n,nC7QUANT],CA120FORN,CA120LOJ,cC7PRODUTO,.T.)[3]
	  cA5CODTAB:=(cAliasQry)->A5_CODTAB
   	  lxCont:=.T.   
   	  Exit
   	  (cAliasQry)->(DbSkip())
   EndDo
   (cAliasQry)->(DbCloseArea())
   // ->  Se continua
   If lxCont
      // -> Verifica tabela de preço
      DbSelectArea("AIA")
      AIA->(DbSetOrder(1))
      If AIA->(DbSeek(xFilial("AIA")+CA120FORN+CA120LOJ+cA5CODTAB))
         // -> Verifica se a tabela é válida
         If AIA->AIA_DATDE <= dDataBase .and.  (AIA->AIA_DATATE >= dDataBase .or. Empty(AIA->AIA_DATATE)) 
            // -> Verifica a condição de Pagamento utilizada na tabela e no pedido. Se for igual ou vazia, continua
            If (AllTrim(CCONDICAO) == AllTrim(AIA->AIA_CONDPG)) .or. Empty(AIA->AIA_CONDPG)
               cA5CODTAB:=AIA->AIA_FILIAL+AIA->AIA_CODFOR+AIA->AIA_LOJFOR+AIA->AIA_CODTAB
               // -> Pesquisa no item da tabela de preço
               DbSelectArea("AIB")
               AIB->(DbSetOrder(2))
               If AIB->(DbSeek(cA5CODTAB+cC7PRODUTO))
                  // -> Valida o item na tabela de preço
                  If AIB->AIB_DATVIG <= dDataBase
                     axRet[2,2]:=.F.
                     axRet[3,2]:=AIA->AIA_CODTAB
                     axRet[2,5]:=.F.
                     axRet[3,5]:=AIB->AIB_PRCCOM
                  EndIf
               EndIf         
            EndIf                        
         EndIf
      EndIf   
   EndIf
   // -> Pesquisa Centro de custo
   DbSelectArea("ZA0")
   ZA0->(DbSetOrder(1))
   If ZA0->(DbSeek(xFilial("ZA0")+cFilAnt))
      axRet[2,6]:=.T.
      axRet[3,6]:=ZA0->ZA0_CUSTO
   Else
      axRet[2,6]:=.F.
      axRet[3,6]:=""
   EndIf   
   RestArea(aArea)
   
   xAux:=IIF(cTp=="G",axRet[3,AScan(axRet[1],cFld)],IIF(cTp=="V",axRet[2,AScan(axRet[1],cFld)],""))
   
Return(xAux)                                





/*                                                    
+------------------+-------------------------------------------------------------------------------+
! Nome             ! xSB1SC1                                                                       !
+------------------+-------------------------------------------------------------------------------+
! Descrição        ! Atualiza os campos da solicitação de compra de acordo com gatilho e funções de!
!                  ! validação dos campos da tabela SC1                                            !
+------------------+-------------------------------------------------------------------------------+
// Parametros
// cFld -> campo do SC1 a procurar (C1_XCODTAB, C1_FORNECE, C1_LOJA, C1_VUNIT, C1_CC) 
// cTp  -> 'G' -> Gatilho (retorno o valor do campo)
//      -> 'V' -> Visual  (retorna se é visual)
//      -> 'F' -> Se encontrou o campo (retorna se existe nas pesquisas)
// Variáveis privadas de outros fontes que esta função é dependente.
// 	aHeader --> array de header de browse
// 	aCols   --> array conteudo de browse
// 	n       --> linha do array de conteudo posicionada
*/                                                                                
User Function xSB1SC1(cFld,cTp,lAtivo)
Local aArea099  :=GetArea()
Local axRet     :={}
Local lxCont    :=.F.
Local xAux      
Local nAux      :=0
Local nA5XCVUNF :=0
Local cA5XCVUNF :=""
Local cA5CODTAB :=""
Local nC1PRODUTO:=AScan(aHeader,{|x| AllTrim(x[2])=="C1_PRODUTO"})
Local cC1PRODUTO:=aCols[n,nC1PRODUTO]
Local cQuery    :=""
Local cAliasQry	:= GetNextAlias()
Default lAtivo  := .F.

   Aadd(axRet,{"C1_PRODUTO","C1_XCODTAB","C1_FORNECE","C1_LOJA","C1_VUNIT","C1_CC","C1_CODCOMP","C1_XGRUPO"})
   Aadd(axRet,{.T.         ,.T.        ,.T.      ,.T.          ,.T.       ,.T.    ,.T.         ,.T.        })
   Aadd(axRet,{cC1PRODUTO  ,""         ,""       ,""           ,0.00      ,""     ,""          ,""         })
   Aadd(axRet,{.F.         ,.F.        ,.F.      ,.F.          ,.F.       ,.F.    ,.F.         ,.F.        })
   	
   // -> Posiciona no Produto
   SB1->(DbSetOrder(1))
   SB1->(DbSeek(xFilial("SB1")+cC1PRODUTO))   
   
   axRet[2,8]:=.T.
   axRet[3,8]:=SB1->B1_GRUPO
   axRet[4,8]:=.T.  

   // -> Pesquisa item no cadastro de produtos x fornecedor
   cQuery :="SELECT A5_XCVUNF, A5_XTPCUNF, A5_PRODUTO, A5_FORNECE, A5_LOJA, A5_CODTAB, R_E_C_N_O_ REC " + CRLF 
   cQuery +="FROM " + RetSQLName("SA5") + " SA5 "          + CRLF 
   cQuery +="WHERE A5_FILIAL  = '" + xFilial("SA5") + "' AND " + CRLF  
   cQuery +="      A5_PRODUTO = '" + cC1PRODUTO     + "' AND " + CRLF
   cQuery +="      A5_XATIVO  = 'S'                          " + CRLF
   dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)	
   
   (cAliasQry)->(DbGoTop())
   While !(cAliasQry)->(Eof())
	  // -> Posiciona na tabela SA5
	  SA5->(DbGoTo((cAliasQry)->REC))
	  
	  nA5XCVUNF:=(cAliasQry)->A5_XCVUNF
	  cA5XCVUNF:=(cAliasQry)->A5_XTPCUNF
	  axRet[2,1]:=.T.
	  axRet[3,1]:=(cAliasQry)->A5_PRODUTO
	  axRet[4,1]:=.T.	// Existe Produto
	  axRet[2,3]:=.T.
	  axRet[3,3]:=(cAliasQry)->A5_FORNECE
	  axRet[4,3]:=.T.	// Existe fornecedor
	  axRet[2,4]:=.T.
	  axRet[3,4]:=(cAliasQry)->A5_LOJA
	  axRet[4,4]:=.T.	// Existe loja
	  cA5CODTAB:=(cAliasQry)->A5_CODTAB
   	  If !lAtivo
   	  	 lxCont:=.T.   
         Exit
   	  Else
   	     If Upper(SA5->A5_XATIVO) == "S"
   	     	lxCont:=.T.   
   	     	Exit   	     	
   	     EndIf 
   	  EndIf
   	  (cAliasQry)->(DbSkip())
   EndDo
   (cAliasQry)->(DbCloseArea())
   // ->  Se continua
   If lxCont
      // -> Verifica tabela de preço
      AIA->(DbSetOrder(1))
      If AIA->(DbSeek(xFilial("AIA")+axRet[3,3]+axRet[3,4]+cA5CODTAB))
         // -> Verifica se a tabela é válida
         If AIA->AIA_DATDE <= dDataBase .and.  (AIA->AIA_DATATE >= dDataBase .or. Empty(AIA->AIA_DATATE))
            // -> Pesquisa no item da tabela de preço
            AIB->(DbSetOrder(2))
            If AIB->(DbSeek(AIA->AIA_FILIAL+AIA->AIA_CODFOR+AIA->AIA_LOJFOR+AIA->AIA_CODTAB+cC1PRODUTO))
               // -> Valida o item na tabela de preço
               If AIB->AIB_DATVIG <= dDataBase
                  axRet[2,2]:=.F.
                  axRet[3,2]:=AIA->AIA_CODTAB
                  axRet[4,2]:=.t.   // Existe tabela
                  axRet[2,5]:=.F.
                  axRet[3,5]:=AIB->AIB_PRCCOM
                  axRet[4,5]:=.t.   // Existe preco
               EndIf         
            EndIf                        
         EndIf
      EndIf   
   EndIf

   // -> Pesquisa Centro de custo
   ZA0->(DbSetOrder(1))
   If ZA0->(DbSeek(xFilial("ZA0")+cFilAnt))
      axRet[2,6]:=.T.
      axRet[3,6]:=ZA0->ZA0_CUSTO
      axRet[4,6]:=.t.   // Existe centro de custo
   Else
      axRet[2,6]:=.F.
      axRet[3,6]:=""
   EndIf   

   // -> Pesquisa Comprador
   //DbSelectArea("SAJ")
   SAJ->(DbSetOrder(1))
   If SAJ->(DbSeek(xFilial("SAJ")+SB1->B1_GRUPCOM))
      // -> Pesquisa comprador
      SY1->(DbSetOrder(3))
      If SY1->(DbSeek(xFilial("SY1")+SAJ->AJ_USER))
         axRet[2,7]:=.T.
         axRet[3,7]:=SY1->Y1_COD
         axRet[4,7]:=.T.
      Else
         axRet[2,7]:=.F.
         axRet[3,7]:=""
         axRet[4,7]:=.F.        
      EndIf     
   Else
      axRet[2,7]:=.F.
      axRet[3,7]:=""
      axRet[4,7]:=.F.  
   EndIf   

   RestArea(aArea099)
   If     cTp == "G"
      xAux:=axRet[3,AScan(axRet[1],cFld)]
   ElseIf cTp == "V"
      xAux:=axRet[2,AScan(axRet[1],cFld)]
   ElseIf cTp == "F"
   	  xAux:=axRet[4,AScan(axRet[1],cFld)]
   EndIf         
      
Return(xAux)                                
                     
                     
                     

/*-----------------+---------------------------------------------------------+
!Nome              ! C104PRF                                                 !
+------------------+---------------------------------------------------------+
!Descrição         ! Calcula quantidade do pedido conforme unidade de compra !
!                  ! cadastrada na tabela de produto x fornecedores          !
+------------------+---------------------------------------------------------+
!Autor             ! Marcio Zaguetti                                         !
+------------------+---------------------------------------------------------!
!Data              ! 28/05/2018                                              !
+------------------+--------------------------------------------------------*/
User Function C104PRF(nQUNSB1,cForn,cLoj,cProd,lGatilho)
Local a104PRF	:=GetArea()
Local nAux   	:=nQUNSB1
Local nAux1  	:=0
Local cAux   	:=""
Local cAux1  	:=""
Local cAux2  	:=""	
Local nFator 	:= 0 
Local cFator 	:= ""
Local nLoteM 	:= 0
Local cUnidF 	:= ""
Local cAliasQry	:= GetNextAlias( )
Default lGatilho:=.F.		

   	// -> Pesquisa dados no cadastro de produtos x Fornecedor
	If !lGatilho 
	    // -> Pesquisa item no cadastro de produtos x fornecedor
	    cQuery :="SELECT A5_XTPCUNF, A5_LOTEMUL, A5_XCVUNF, A5_LOTEMIN, A5_UNID " + CRLF 
	    cQuery +="FROM " + RetSQLName("SA5") + " SA5 "          + CRLF 
	    cQuery +="WHERE A5_FILIAL  = '" + xFilial("SA5") + "' AND " + CRLF  
	    cQuery +="      A5_FORNECE = '" + cForn     + "' AND " + CRLF
	    cQuery +="      A5_LOJA    = '" + cLoj      + "' AND " + CRLF
	    cQuery +="      A5_PRODUTO = '" + cProd     + "' AND " + CRLF
	    cQuery +="      A5_XATIVO  = 'S'                          " + CRLF
	    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)	
	    (cAliasQry)->(DbGoTop())
	    While !(cAliasQry)->(Eof())
	       cFator:=(cAliasQry)->A5_XTPCUNF
		   nFator:=IIF((cAliasQry)->A5_LOTEMUL>0,(cAliasQry)->A5_LOTEMUL,(cAliasQry)->A5_XCVUNF)
		   nLoteM := (cAliasQry)->A5_LOTEMIN
 		   cUnidF := (cAliasQry)->A5_UNID				
	   	   Exit
   		   (cAliasQry)->(DbSkip())
   	    EndDo
       (cAliasQry)->(DbCloseArea())
	Else
		cFator:=SA5->A5_XTPCUNF
		nFator:=IIF(SA5->A5_LOTEMUL>0,SA5->A5_LOTEMUL,SA5->A5_XCVUNF)
		nLoteM := SA5->A5_LOTEMIN
		cUnidF := SA5->A5_UNID				
	EndIf

	// -> Se possuir lote múltiplo cadastrado 
	If nFator > 0		
		// -> Aplica fator de conversão do lote do fornecedor
		nAux  :=0
		If cFator == "M"
			nAux :=nQUNSB1/nFator
		ElseIf cFator == "D"
			nAux :=nQUNSB1*nFator						
		EndIf	
		
		// -> Arredonda apenas se for executado pela rotina de MRP
		If !lGatilho
			cAux :=StrZero(nAux,16,4)
			cAux1:=StrTokArr(cAux,".")[1]
			cAux2:=StrTokArr(cAux,".")[2]
			nAux:=IIF(Val(cAux2)>0,Val(cAux1)+1,Val(cAux))		
		EndIf
		
		// -> Aplica Fator de conversao na unidade de medida do restaurante
		If cFator == "M"
			nAux1:=nAux*nFator
		ElseIf cFator == "D"
			nAux1:=nAux/nFator						
		EndIf			
		
	EndIf	
					
	// -> Verifica o lote mínimo	
	If nAux < nLoteM .and. nLoteM > 0 .and. nFator > 0
		nAux :=nLoteM
		// -> Aplica fator de conversão do lote do fornecedor
		If cFator == "M"
			nAux1 :=nAux1*nFator
		ElseIf cFator == "D"
			nAux1 :=nAux1/nFator							
		EndIf
	EndIf	

	RestArea(a104PRF)

Return({nAux,nAux1,cUnidF,nFator,cFator,nLoteM})

                                            

/*                                                    
+------------------+-------------------------------------------------------------------------------+
! Nome             ! xGetUn                                                                        !
+------------------+-------------------------------------------------------------------------------+
! Descrição        ! Busca unidades de negócio                                                     !
!                  !                                                                               !
+------------------+-------------------------------------------------------------------------------+
*/                                                                                
//User Function xGetUn( cGrpNeg )
//Local lRet		:= .F.
//Local cQuery	:= ""
//Local cAliasQry	:= GetNextAlias( )
//Default cGrpNeg	:= ""

  //If Empty(cGrpNeg)
    //cQuery += "  SELECT " + CRLF 
    //cQuery += "    ADK.ADK_XGEMP XGEMP " + CRLF
    //cQuery += "   ,ADK.ADK_XFILI CODFIL " + CRLF 
    //cQuery += "   ,ADK.ADK_NOME  NOME " + CRLF 
    //cQuery += "   FROM " + RetSQLName( "ADK" ) + " ADK " + CRLF 
    //cQuery += "  WHERE ADK.ADK_FILIAL = '" + xFilial( "ADK" ) + "' " + CRLF 
    //cQuery += "    AND ADK.ADK_XFILI <> ' ' " + CRLF
    //cQuery += "    AND ADK.ADK_XFILI <> '" + cFilAnt + "' " + CRLF  
    //cQuery += "    AND ADK.ADK_XEMP  <> ' ' " + CRLF
    //cQuery += "    AND ADK.ADK_XGEMP <> ' ' " + CRLF
    //cQuery += "    AND ADK.D_E_L_E_T_ = ' ' " + CRLF        
    //cQuery += "  GROUP BY " + CRLF
    //cQuery += "    ADK.ADK_XGEMP " + CRLF 
    //cQuery += "   ,ADK.ADK_XFILI " + CRLF 
    //cQuery += "   ,ADK.ADK_NOME " + CRLF 
    //cQuery += "  ORDER BY " + CRLF 
    //cQuery += "    ADK.ADK_XGEMP " + CRLF
    //cQuery += "   ,ADK.ADK_XFILI " + CRLF 
    //cQuery += "   ,ADK.ADK_NOME " + CRLF 
  //Else
    //cQuery += "  SELECT " + CRLF 
    //cQuery += "    ADK.ADK_XGEMP XGEMP " + CRLF
    //cQuery += "   ,ADK.ADK_XFILI CODFIL " + CRLF 
    //cQuery += "   ,ADK.ADK_NOME  NOME " + CRLF 
    //cQuery += "   FROM " + RetSQLName( "ADK" ) + " ADK " + CRLF 
    //cQuery += "  WHERE ADK.ADK_FILIAL = '" + xFilial( "ADK" ) + "' " + CRLF 
    //cQuery += "    AND ADK.ADK_XFILI <> ' ' "               + CRLF
    //cQuery += "    AND ADK.ADK_XFILI <> '" + cFilAnt + "' " + CRLF  
    //cQuery += "    AND ADK.ADK_XEMP  <> ' ' " + CRLF
    //cQuery += "    AND ADK.ADK_XGNEG  = '" + cGrpNeg + "' " + CRLF
    //cQuery += "    AND ADK.ADK_XGEMP <> ' ' " + CRLF
    //cQuery += "    AND ADK.D_E_L_E_T_ = ' ' " + CRLF
    //cQuery += "  GROUP BY " + CRLF
    //cQuery += "    ADK.ADK_XGEMP " + CRLF 
    //cQuery += "   ,ADK.ADK_XFILI " + CRLF 
    //cQuery += "   ,ADK.ADK_NOME " + CRLF 
    //cQuery += "  ORDER BY " + CRLF 
    //cQuery += "    ADK.ADK_XGEMP " + CRLF
    //cQuery += "   ,ADK.ADK_XFILI " + CRLF 
    //cQuery += "   ,ADK.ADK_NOME " + CRLF 
  //EndIf
  //dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)	


                                                                                
User Function xGetUn( cGrpNeg )
Local lRet		:= .F.
Local cQuery	:= ""
Local cAliasQry	:= GetNextAlias( )
Default cGrpNeg	:= ""

cQuery += "  SELECT " + CRLF 
cQuery += "    ADK.ADK_XGEMP XGEMP " + CRLF
cQuery += "   ,ADK.ADK_XFILI CODFIL " + CRLF 
cQuery += "   ,ADK.ADK_NOME  NOME " + CRLF 
cQuery += "   FROM " + RetSQLName( "ADK" ) + " ADK " + CRLF 
cQuery += "  WHERE ADK.ADK_FILIAL = '" + xFilial( "ADK" ) + "' " + CRLF 
cQuery += "    AND ADK.ADK_XFILI <> ' ' " + CRLF
cQuery += "    AND ADK.ADK_XFILI <> '" + cFilAnt + "' " + CRLF  

If Type( "__cFilDe" ) == "C" .And. !Empty( __cFilDe )
	cQuery += "    AND ADK.ADK_XFILI = '" + __cFilDe + "' " + CRLF	
EndIf

If Type( "__cNegDe" ) == "C" .And. !Empty( __cNegDe )
	cQuery += "    AND ADK.ADK_XNEGOC = '" + __cNegDe + "' " + CRLF	
EndIf

If Type( "__cSegDe" ) == "C" .And. !Empty( __cSegDe )
	cQuery += "    AND ADK.ADK_XSEGUI = '" + __cSegDe + "' " + CRLF	
EndIf

If !Empty( cGrpNeg )
	If ADK->( FieldPos( "ADK_XGNEG" ) ) > 0
		cQuery += "    AND ADK.ADK_XGNEG  = '" + cGrpNeg + "' " + CRLF
	EndIf
	If ADK->( FieldPos( "ADK_XGEMP" ) ) > 0
		cQuery += "    AND ADK.ADK_XGEMP <> ' ' " + CRLF
	EndIf
EndIf

cQuery += "    AND ADK.D_E_L_E_T_ = ' ' " + CRLF
cQuery += "  GROUP BY " + CRLF
cQuery += "    ADK.ADK_XGEMP " + CRLF 
cQuery += "   ,ADK.ADK_XFILI " + CRLF 
cQuery += "   ,ADK.ADK_NOME " + CRLF 
cQuery += "  ORDER BY " + CRLF 
cQuery += "    ADK.ADK_XGEMP " + CRLF
cQuery += "   ,ADK.ADK_XFILI " + CRLF 
cQuery += "   ,ADK.ADK_NOME " + CRLF 
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)	

Return(cAliasQry)                  



/*---------------------------------------------------------------------------+
|Função            | GetDirIni                                               |
+------------------+---------------------------------------------------------+
|Descricao         | Pega diretório de execução do Smartclient               |
|                  |                                                         |
+------------------+---------------------------------------------------------+
|Autor             | Márcio Zaguetti                                         |
+------------------+---------------------------------------------------------+
|Data de Criacao   | 17/09/2016                                              |
+------------------+---------------------------------------------------------+
|  Informações     |                                                         |
|   Adicionais     |                                                         |
+---------------------------------------------------------------------------*/
User Function GetDirIni()
Local cIniName:=GetRemoteIniName() 
Local lUnix   :=IsSrvUnix()
Local nPos    :=Rat(IIF(lUnix,"/","\"),cIniName)
Local cPathRmt
   
  If !( nPos == 0 )
    cPathRmt := SubStr( cIniName, 1, nPos - 1 )
  Else
    cPathRmt := ""
  Endif
   
Return(cPathRmt)



/*---------------------------------------------------------------------------+
|Função            | IsBusiness                                              |
+------------------+---------------------------------------------------------+
|Descricao         | Verifica se a unidade corrente é um restaurante         |
|                  |                                                         |
+------------------+---------------------------------------------------------+
|Autor             | Márcio Zaguetti                                         |
+------------------+---------------------------------------------------------+
|Data de Criacao   | 24/06/2018                                              |
+------------------+---------------------------------------------------------+
|  Informações     |                                                         |
|   Adicionais     |                                                         |
+---------------------------------------------------------------------------*/
*/                                                    
User Function IsBusiness()
Local lRet    := .F. 
Local aAreaADK:= GetArea()
Local cFilADK := Space(TamSx3("ADK_FILIAL")[1])
	
	DbSelectArea("ADK")
	ADK->( dbOrderNickName("ADKXFILI") )
	If ADK->(dbseek(cFilADK+cFilAnt)) 
    lRet := ADK->ADK_XNEGOC <> "GD"
	EndIf	
	                      
	RestArea(aAreaADK)	
	 
Return(lRet)                  


/*---------------------------------------------------------------------------+
|Função            | xGetUser                                                |
+------------------+---------------------------------------------------------+
|Descricao         | Retorna o nome do usuário conforme código do usuário    |
|                  | passado como parâmetro                                  |
+------------------+---------------------------------------------------------+
|Autor             | Márcio Zaguetti                                         |
+------------------+---------------------------------------------------------+
|Data de Criacao   | 29/06/2018                                              |
+------------------+---------------------------------------------------------+
|  Informações     |                                                         |
|   Adicionais     |                                                         |
+---------------------------------------------------------------------------*/
*/                                                    
User Function xGetUser(cXCod)
Local cRet:=" "
	If AllTrim(cxCod) <> "" 
		cRet:=IIF(AllTrim(cXCod)=="*","TODOS",UsrRetName(cXCod))
	EndIf	
Return(cRet)  


/*---------------------------------------------------------------------------+
|Função            | xGetUsrG                                                |
+------------------+---------------------------------------------------------+
|Descricao         | Retorna a descrição do grupo de usuário conforme código |
|                  | passado como parâmetro                                  |
+------------------+---------------------------------------------------------+
|Autor             | Márcio Zaguetti                                         |
+------------------+---------------------------------------------------------+
|Data de Criacao   | 29/06/2018                                              |
+------------------+---------------------------------------------------------+
|  Informações     |                                                         |
|   Adicionais     |                                                         |
+---------------------------------------------------------------------------*/
*/                                                    
User Function xGetUsrG(cXCod)
Local cRet:=" "
	If AllTrim(cxCod) <> "" 
		cRet:=IIF(AllTrim(cXCod)=="*","TODOS",GrpRetName(cXCod))
	EndIf	
Return(cRet)  



/*---------------------------------------------------------------------------+
|Função            | PutSx1                                                  |
+------------------+---------------------------------------------------------+
|Descricao         | Grava perguntas na SX1                                  |
|                  | passado como parâmetro                                  |
+------------------+---------------------------------------------------------+
|Autor             | Mário Araújo                                            |
+------------------+---------------------------------------------------------+
|Data de Criacao   | 22/07/2018                                              |
+------------------+---------------------------------------------------------+
|  Informações     |                                                         |
|   Adicionais     |                                                         |
+---------------------------------------------------------------------------*/
*/                                                    
User Function PutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,;
				cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,;
				cF3, cGrpSxg,cPyme,;
				cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,;
				cDef02,cDefSpa2,cDefEng2,;
				cDef03,cDefSpa3,cDefEng3,;
				cDef04,cDefSpa4,cDefEng4,;
				cDef05,cDefSpa5,cDefEng5,;
				aHelpPor,aHelpEng,aHelpSpa,cHelp)

	Local aArea := GetArea()
	Local cKey
	Local lPort := .f.
	Local lSpa  := .f.
	Local lIngl := .f.

	cKey  := "P." + AllTrim( cGrupo ) + AllTrim( cOrdem ) + "."

	cPyme    := Iif( cPyme 		== Nil, " ", cPyme		)
	cF3      := Iif( cF3 		== NIl, " ", cF3		)
	cGrpSxg  := Iif( cGrpSxg	== Nil, " ", cGrpSxg	)
	cCnt01   := Iif( cCnt01		== Nil, "" , cCnt01 	)
	cHelp	 := Iif( cHelp		== Nil, "" , cHelp		)

	dbSelectArea( "SX1" )
	dbSetOrder( 1 )

	// Ajusta o tamanho do grupo. Ajuste emergencial para validação dos fontes.
	// RFC - 15/03/2007
	cGrupo := PadR( cGrupo , Len( SX1->X1_GRUPO ) , " " )

	If !( DbSeek( cGrupo + cOrdem ))

	    cPergunt:= If(! "?" $ cPergunt .And. ! Empty(cPergunt),Alltrim(cPergunt)+" ?",cPergunt)
		cPerSpa	:= If(! "?" $ cPerSpa  .And. ! Empty(cPerSpa) ,Alltrim(cPerSpa) +" ?",cPerSpa)
		cPerEng	:= If(! "?" $ cPerEng  .And. ! Empty(cPerEng) ,Alltrim(cPerEng) +" ?",cPerEng)

		Reclock( "SX1" , .T. )

		Replace X1_GRUPO   With cGrupo
		Replace X1_ORDEM   With cOrdem
		Replace X1_PERGUNT With cPergunt
		Replace X1_PERSPA  With cPerSpa
		Replace X1_PERENG  With cPerEng
		Replace X1_VARIAVL With cVar
		Replace X1_TIPO    With cTipo
		Replace X1_TAMANHO With nTamanho
		Replace X1_DECIMAL With nDecimal
		Replace X1_PRESEL  With nPresel
		Replace X1_GSC     With cGSC
		Replace X1_VALID   With cValid

		Replace X1_VAR01   With cVar01

		Replace X1_F3      With cF3
		Replace X1_GRPSXG  With cGrpSxg

		If Fieldpos("X1_PYME") > 0
			If cPyme != Nil
				Replace X1_PYME With cPyme
			Endif
		Endif

		Replace X1_CNT01   With cCnt01
		If cGSC == "C"			// Mult Escolha
			Replace X1_DEF01   With cDef01
			Replace X1_DEFSPA1 With cDefSpa1
			Replace X1_DEFENG1 With cDefEng1

			Replace X1_DEF02   With cDef02
			Replace X1_DEFSPA2 With cDefSpa2
			Replace X1_DEFENG2 With cDefEng2

			Replace X1_DEF03   With cDef03
			Replace X1_DEFSPA3 With cDefSpa3
			Replace X1_DEFENG3 With cDefEng3

			Replace X1_DEF04   With cDef04
			Replace X1_DEFSPA4 With cDefSpa4
			Replace X1_DEFENG4 With cDefEng4

			Replace X1_DEF05   With cDef05
			Replace X1_DEFSPA5 With cDefSpa5
			Replace X1_DEFENG5 With cDefEng5
		Endif

		Replace X1_HELP  With cHelp

		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

		MsUnlock()
	Else

	   lPort := ! "?" $ X1_PERGUNT .And. ! Empty(SX1->X1_PERGUNT)
	   lSpa  := ! "?" $ X1_PERSPA  .And. ! Empty(SX1->X1_PERSPA)
	   lIngl := ! "?" $ X1_PERENG  .And. ! Empty(SX1->X1_PERENG)

	   If lPort .Or. lSpa .Or. lIngl
			RecLock("SX1",.F.)
			If lPort
	         SX1->X1_PERGUNT:= Alltrim(SX1->X1_PERGUNT)+" ?"
			EndIf
			If lSpa
				SX1->X1_PERSPA := Alltrim(SX1->X1_PERSPA) +" ?"
			EndIf
			If lIngl
				SX1->X1_PERENG := Alltrim(SX1->X1_PERENG) +" ?"
			EndIf
			SX1->(MsUnLock())
		EndIf
	Endif

	RestArea( aArea )

Return