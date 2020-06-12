/*/{Protheus.doc} NFEPE
Ponto de Entrada para o DocFis
@type function
 
@author Leandro Favero
@since 30/05/2018
@version 1.0
/*/

#INCLUDE "PROTHEUS.CH"

/*--------------------------------------------------------------------------+
|  DOCFISPE - Ponto de Entrada do DocFis                                      |
----------------------------------------------------------------------------*/
User function DOCFISPE()
	Local xRet:= nil //Retorna vários formatos	
		
	DO CASE
	//  CASE (PARAMIXB=='INSTALL')	
	  //	 Install()
	  CASE (PARAMIXB=='BEFORE_INVOICE')	
	     xRet:=TreatInv()  //Executa antes de gerar a Pre-nota
	ENDCASE
	
Return xRet
		

/*--------------------------------------------------------------------------+
|  TreatInv                                                                 |
|   - Converte as Unidades de Medida                                        |
|   - Preenche campos customizados                                          |
----------------------------------------------------------------------------*/
Static function TreatInv()
	Local nI
	Local lRet:=.T.
	Local nQuant, nQtdXML
	Local nPosProd:= aScan(aItens[1], {|x| AllTrim(x[1]) == "D1_COD"})
	Local nPosUm  := aScan(aItens[1], {|x| AllTrim(x[1]) == "D1_UM"})
	Local nPosQtd := aScan(aItens[1], {|x| AllTrim(x[1]) == "D1_QUANT"})
	Local nPosVal := aScan(aItens[1], {|x| AllTrim(x[1]) == "D1_VUNIT"})
	Local nPosTot := aScan(aItens[1], {|x| AllTrim(x[1]) == "D1_TOTAL"})
		
	//Somente para NFE
	if Alltrim(ZT0->ZT0_ESPECI)=='SPED'			
		DBSelectArea('SB1') //Produtos
		SB1->(DBSetOrder(1))//B1_FILIAL+B1_COD
			
		DBSelectArea('SA5')              //Produto x Fornecedores
		SA5->(DBOrderNickname('A5UNID')) //A5_FILIAL+A5_FORNECE+A5_LOJA+A5_PRODUTO+A5_UNID
		for nI:=1 to len(aItens)
			if SA5->(DBSeek(xFilial('SA5')+ZT0->ZT0_FORNEC+ZT0->ZT0_FORLOJ+aItens[nI][nPosProd][2]+aItens[nI][nPosUm][2]))
				nQtdXML:=aItens[nI][nPosQtd][2]
				if !Empty(SA5->A5_XTPCUNF)
					if SA5->A5_XCVUNF==0
						alert('O Fator de conversão de Unidade de medida no Produto X Fornecedor está zerado. Corrija para poder gerar a Pré-Nota')
						lRet:=.F.
					else
						//Tipo de Conversão
						if SA5->A5_XTPCUNF=='M' //M=Multiplicador;D=Divisor
							nQuant:=nQtdXML*SA5->A5_XCVUNF	//Fator de Conversão
						else
							nQuant:=nQtdXML/SA5->A5_XCVUNF //Fator de Conversão
						endif
						
						SB1->(DBSeek(xFilial('SB1')+aItens[nI][nPosProd][2]))
						if SB1->B1_XARRED=='1' //Arredonda produto = SIM
							nQuant:= Ceiling(nQuant) //Arredonda sempre para cimma
						endif
						
						aItens[nI][nPosQtd][2]:=nQuant
						aItens[nI][nPosVal][2]:=aItens[nI][nPosTot][2]/nQuant
						
						if Empty(SA5->A5_UMNFE) .OR. SA5->A5_UMNFE=='1'
							aItens[nI][nPosUm][2]:=SB1->B1_UM
						else
							aItens[nI][nPosUm][2]:=SB1->B1_SEGUM
						endif
					endif
				endif				
				
				if SA5->A5_XATIVO == "S"
				    aAdd(aItens[nI],{"D1_XCODPR" ,SA5->A5_CODPRF,Nil,Nil})	
				    aAdd(aItens[nI],{"D1_XCODBA" ,SA5->A5_CODBAR,Nil,Nil})    
				    aAdd(aItens[nI],{"D1_XCVUNF" ,SA5->A5_XCVUNF,Nil,Nil})
				    aAdd(aItens[nI],{"D1_XTPCUNF",SA5->A5_XTPCUNF,Nil,Nil})
				    aAdd(aItens[nI],{"D1_XQTDXML",nQTDXML,Nil,Nil})
				endif
			endif	
		next
	endif
return lRet


/*--------------------------------------------------------------------------+
|  Install -                                                                |
----------------------------------------------------------------------------*/
Static function Install()
	SX3->(DBSetOrder(2)) //X3_CAMPO
	if !SX3->(DBSeek('B1_XARRED'))	
		UpdSIX()
	    UpdSB1()    
	endif
Return

//+--------------------------------------------------------------+
//¦ UpdSIX - Cria novos indices                            ¦
//+--------------------------------------------------------------+
Static Function UpdSIX()	
	DBSelectArea('SIX')//Indices
	SIX->(DBSetOrder(1)) //INDICE+ORDEM     
	if !SIX->(DBSeek('SA5'+'Z'))      
        RecLock('SIX',.T.)
           SIX->INDICE   := 'SA5'
           SIX->ORDEM    := 'Z'
           SIX->NICKNAME := 'A5UNID'
           SIX->CHAVE    := 'A5_FILIAL+A5_FORNECE+A5_LOJA+A5_PRODUTO+A5_UNID'	
           SIX->DESCRICAO:= 'Fornecedor + Loja + Produto + Unidade'
           SIX->DESCSPA  := 'Supplier + Store + Product + Unit'
           SIX->DESCENG  := 'Proveedor + Tienda + Producto + Unidad'
           SIX->PROPRI   := 'U'
           SIX->SHOWPESQ := 'S'
        MsUnlock()
    endif    
Return


//+--------------------------------------------------------------+
//¦ UpdSB1 - Cria novos campos na SB1                            ¦
//+--------------------------------------------------------------+
Static Function UpdSB1()	

	                 //Campo, Tipo, Tamanho, Decimal, F3, Usado, Titulo, Descrição
	Local aFields:={ { "B1_XARRED ", "C" , 1 , 0, '   ','S', 'Arredonda' , 'Arredonda na NFE' }}															

	CriaCampos('SB1',aFields)
	
	SX3->(DBSetOrder(2)) //X3_CAMPO
	SX3->(DBSeek('B1_XARRED'))
	RecLock('SX3',.F.)
		SX3->X3_CBOX    := '1=Sim;2=Não'
		SX3->X3_CBOXSPA := '1=Si;2=No'
	    SX3->X3_CBOXENG := '1=Yes;2=No'
	MsUnlock('SX3')	
Return


//+--------------------------------------------------------------+
//¦ CriaCampos                                                   ¦
//+--------------------------------------------------------------+
Static Function CriaCampos(cAlias,aFieldList)
	local nCnt
	local cOrdem
	local lUpd:=.F.
	SX3->(DBSetOrder(2)) //X3_CAMPO
	
	for nCnt:=1 to len(aFieldList)			
		if !SX3->(DBSeek(aFieldList[nCnt,1],.T.))
			if (cOrdem==nil)
				cOrdem:= nxtSeq(cAlias) //Pega a ordem mais alta
			endif
			cOrdem:=Soma1(cOrdem)		
			RecLock('SX3',.T.)
				SX3->X3_ARQUIVO:= cAlias
				SX3->X3_ORDEM  := cOrdem
				SX3->X3_CAMPO  := aFieldList[nCnt,1]
				SX3->X3_TIPO   := aFieldList[nCnt,2]
				SX3->X3_TAMANHO:= aFieldList[nCnt,3]
			 	SX3->X3_DECIMAL:= aFieldList[nCnt,4]
			 	SX3->X3_F3     := aFieldList[nCnt,5]
				SX3->X3_TITULO := aFieldList[nCnt,7]
				SX3->X3_TITSPA := aFieldList[nCnt,7]
				SX3->X3_TITENG := aFieldList[nCnt,7]
				SX3->X3_DESCRIC:= aFieldList[nCnt,8]
				SX3->X3_DESCSPA:= aFieldList[nCnt,8]
				SX3->X3_DESCENG:= aFieldList[nCnt,8]
				if (aFieldList[nCnt,6]=='S')
					SX3->X3_USADO := Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
								 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
								 Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)
				endif
				SX3->X3_RESERV := Chr(254) + Chr(192)
				SX3->X3_CONTEXT:= 'R' //Real
				SX3->X3_VISUAL := 'A' //Altera
				SX3->X3_BROWSE := 'S' //Mostrar no Browser
				SX3->X3_PROPRI := 'U' //Campo customizado pelo usuário
			MsUnlock()
			lUpd:=.T. //Marca para atualizar a tabela
		endif
	Next
	
	if lUpd
		X31UPDTABLE(cAlias) //Efetua a atualização da tabela
	endif 
return



//+--------------------------------------------------------------+
//¦ nxtSeq - Pega a ordem mais alta no SX3                       ¦
//+--------------------------------------------------------------+
Static Function nxtSeq(cAlias)
	Local cOrdem:='01'
	
	SX3->(DBSetOrder(1)) //X3_ARQUIVO+X3_ORDEM
	SX3->(DBSeek(cAlias))
	
	while !SX3->(eof()) .AND. SX3->X3_ARQUIVO==cAlias
		cOrdem:=SX3->X3_ORDEM
		SX3->(DBSkip())	
	EndDo
	
return cOrdem