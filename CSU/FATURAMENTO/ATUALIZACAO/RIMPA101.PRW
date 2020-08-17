/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RIMPA100A  ºAutor  ³  Eduardo Dias    º Data ³  12/12/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para gerar Pedido de Venda de Complemente de ICMS   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RIMPA100A                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RIMPA101()
Local aBotoes	:= {}
Local aSays		:= {}
Local aPergunt	:= {}
Local nOpcao	:= 0

//Tela de aviso e acesso ao parametro de caminho
AAdd(aSays,"                 [ GERAÇÃO DE PEDIDO DE VENDA PARA COMPLEMENTO ICMS ] ")
AAdd(aSays,"           Esse programa irá importar os dados para geração de pedido de Venda " )
AAdd(aSays,"               de Complemento de ICMS das NFs existentes. " )
Pergunte("RIMPA081",.F.)

AAdd(aBotoes,{ 5,.T.,{|| Pergunte("RIMPA081",.T. ) } } )
AAdd(aBotoes,{ 1,.T.,{|| nOpcao := 1, FechaBatch() }} )
AAdd(aBotoes,{ 2,.T.,{|| FechaBatch() }} )
FormBatch( "  [ GERAÇÃO DE PEDIDO DE VENDA PARA COMPLEMENTO ICMS - SC5 & SC6 ]", aSays, aBotoes )

If nOpcao == 1
	Processa({|| RIMPA101a() })
EndIf

Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RIMPA101A  ºAutor  ³  Eduardo Dias    º Data ³  03/12/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para gerar Pedido de Venda de Complemente de ICMS   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RIMPA101A                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RIMPA101a() 
Local lGravaC5		:= .F.
Local lGravaC6		:= .F.
Local lGravaC9		:= .F.  
Local nLog			:= 0
Local aArquivo		:= {}               
Local _nErro   		:= 0
Local i   		   	:= 0 
Local cLinha   		:= ""      
Local _cPedido 		:= "" //GETSX8NUM("SC5", "C5_NUM")//GetSxeNum( "SC5", "C5_NUM" )     
Local nPrcVen		:= 0
Local nValTOT       := 0   
Local cCFOP			:= ""

If SM0->(M0_CODIGO<>'05'.or. M0_CODFIL<>'03')
	MsgStop("A execução dessa rotina so poderá ser feita na "+Chr(13)+Chr(10)+Chr(13)+Chr(10)+ "Empresa: 05 (CSU CARDSYSTEM)";
				+Chr(13)+Chr(10)+"Filial: 03 (ALPHAVILLE)")
	Return
Endif

If !File(mv_par01)
	MsgAlert("Atenção, o arquivo informado não foi localizado.")
	Return()
EndIf

FT_FUse(mv_par01)
FT_FGoTop()
ProcRegua(FT_FLastRec())
FT_FGoTop()

cLinha   := FT_FReadLn()
_cNomeArq := DToS(dDataBase)+".txt" // Nome do arquivo (data) que será gerado o LOG se necessário.
nLog := FCreate("C:\SIGA\LOG_PEDCOMPRA\"+_cNomeArq)

// Pula para próxima linha  
FT_FSkip() 

While !FT_FEof()
	IncProc("Formatando o Arquivo...")
	
	cLinha   := FT_FReadLn()

	AAdd(aArquivo,Array(18))
	aArquivo[Len(aArquivo),1]	:= SUBSTR(cLinha,1,6)	///  Numero do Pedido de Venda
	aArquivo[Len(aArquivo),2]	:= SUBSTR(cLinha,7,8)	///  C5_DATA1
	aArquivo[Len(aArquivo),3]	:= SUBSTR(cLinha,15,1) 	///  TIPO de Pedido de Venda
	aArquivo[Len(aArquivo),4]	:= SUBSTR(cLinha,16,4)	///  AREA - MARK
	aArquivo[Len(aArquivo),5]	:= SUBSTR(cLinha,20,6)	///  Cod. Cliente
	aArquivo[Len(aArquivo),6]	:= SUBSTR(cLinha,26,2)	///  Loja Cliente
	aArquivo[Len(aArquivo),7]	:= SUBSTR(cLinha,28,3) 	///  Cond Pagto	
	aArquivo[Len(aArquivo),8]	:= SUBSTR(cLinha,31,1) 	///  Tipo Cliente 
	
	aArquivo[Len(aArquivo),9]	:= SUBSTR(cLinha,32,2) 	///  item Pedido Venda
	aArquivo[Len(aArquivo),10]	:= SUBSTR(cLinha,34,9) 	///  Cod. Produto
	aArquivo[Len(aArquivo),11]	:= SUBSTR(cLinha,43,10) ///  Centro de Custo
	aArquivo[Len(aArquivo),12]	:= SUBSTR(cLinha,53,4) 	///  Item D
	aArquivo[Len(aArquivo),13]	:= SUBSTR(cLinha,57,9) 	///  Classe Valor
	aArquivo[Len(aArquivo),14]	:= SUBSTR(cLinha,66,6) 	///  NF Original
	aArquivo[Len(aArquivo),15]	:= SUBSTR(cLinha,72,2) 	///  Item NF Original
	aArquivo[Len(aArquivo),16]	:= SUBSTR(cLinha,74,3) 	///  Serie NF Original
	aArquivo[Len(aArquivo),17]	:= SUBSTR(cLinha,77,3) 	///  TES
	aArquivo[Len(aArquivo),18]	:= SUBSTR(cLinha,80,7) 	///  Preço Venda
   //aArquivo[Len(aArquivo),19]	:= SUBSTR(cLinha,92,6) 	///  Valor Total

	FT_FSkip()
EndDo                               
    	
ProcRegua(Len(aArquivo)-1)

For i := 1 To Len(aArquivo)        

	_cPedido := GETSX8NUM("SC5", "C5_NUM")  

	If Valtype(aArquivo[i,18]) == "C" 
		nPrcVen	:= cvaltochar(aArquivo[i,18])
		nPrcVen	:= val(nPrcVen)
	Else
		nPrcVen	:= aArquivo[i,18]
	EndIf

	If Valtype(aArquivo[i,18]) == "C" 
		nValTOT	:= cvaltochar(aArquivo[i,18])
		nValTOT	:= val(nValTOT) * 1
	Else
		nValTOT	:= aArquivo[i,18]
	EndIf
	
	IncProc("Gerando PV de Complemento de ICMS..."+STR(I))
	
	Dbselectarea("SF2")                                                                    
	cArqNtx  := CriaTrab(NIL,.f.)
	cIndCond :="F2_FILIAL + F2_DOC + F2_SERIE" // Chave de busca no BD SC7   
	DbSetOrder(1)
	IndRegua("SF2",cArqNtx,cIndCond,,," ")
	DBGOTOP()
	
	IF Dbseek(xFilial("SF2")+aArquivo[i,14]) .And. !Empty(aArquivo[i,5]+aArquivo[i,6]) 
		Begin Transaction

		If !Empty(aArquivo[i,5]+aArquivo[i,6]) 			
			RecLock("SC5", .T.) 
			C5_FILIAL	:= "03"  
			C5_NUM		:= _cPedido  
			C5_DATA1	:= dDatabase
			C5_TIPO		:= aArquivo[i,3]
			C5_AREA		:= aArquivo[i,4]
			C5_CLIENTE	:= aArquivo[i,5]
			C5_LOJACLI	:= aArquivo[i,6]
			C5_CONDPAG	:= aArquivo[i,7]
			C5_TIPOCLI	:= aArquivo[i,8]   
			C5_LOJAENT	:= "01"
			C5_PARC1	:= 100    
			C5_EMISSAO	:= dDatabase
			C5_MENNOT2	:= "COMPLEMENTO ICMS NF: " + aArquivo[i,14]
			C5_MOEDA	:= 1
			C5_LIBEROK	:= "S"
			C5_TXMOEDA	:= 1
			C5_TIPLIB	:= "2"
			C5_TPCARGA	:= "2"
			C5_CLIENT	:= aArquivo[i,5]
			C5_GERAWMS	:= "1" 
			C5_SOLOPC	:= "1"
			MsUnlock()
			lGravaC5 := .T.		
		EndIf
	
	    If lGravaC5
	    	cCFOP := IIf (Posicione("SA1",1,xFilial("SA1")+aArquivo[i,5]+aArquivo[i,6],"A1_EST") == "SP", "5949", "6949")
			RecLock("SC6", .T.)  
			C6_FILIAL	:= "03"
			C6_NUM		:= _cPedido
			C6_CALINSS	:= "N"
			C6_ITEM		:= aArquivo[i,9]
			C6_PRODUTO	:= aArquivo[i,10]
			C6_DESCRI	:= Posicione("SB1",1,xFilial("SB1")+aArquivo[i,10],"B1_DESC")
			C6_CCUSTO	:= aArquivo[i,11]
			C6_ITEMD	:= aArquivo[i,12]
			C6_CLVLDB	:= aArquivo[i,13]
			C6_NFORI	:= aArquivo[i,14]
			C6_ITEMORI	:= aArquivo[i,15]
			C6_SERIORI	:= aArquivo[i,16]
			C6_TES		:= aArquivo[i,17]                 
			C6_CF		:= cCFOP //IIf (Posicione("SA1",1,xFilial("SA1")+aArquivo[i,5]+aArquivo[i,6],"A1_EST") == "SP", "5949", "6949") //"6949"
			C6_ENTREG	:= dDatabase
			C6_CALCIRF	:= "N"
			C6_UM		:= "UN"
			C6_CLASFIS	:= "000"
			C6_SUGENTR	:= dDatabase
			C6_RATEIO	:= "2"
			C6_CLI		:= aArquivo[i,5]
			C6_LOJA		:= aArquivo[i,6]
			C6_LOCAL	:= aArquivo[i,6]
//			C6_CLASFIS	:= "060"
			C6_PRCVEN	:= nPrcVen //aArquivo[i,18]
			C6_VALOR	:= nValTOT //noround(VAL(aArquivo[i,19])/100,2)
			MsUnlock()     
			lGravaC6 := .T.
		EndIf
          
  		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Liberação dos Pedidos   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF	lGravaC6		
	  		RecLock("SC9", .T.)  
			C9_FILIAL	:= "03" 
			C9_PEDIDO	:=_cPedido
			C9_ITEM		:= aArquivo[i,9]
			C9_CLIENTE	:= aArquivo[i,5]
			C9_LOJA		:= aArquivo[i,6]
			C9_PRODUTO	:= aArquivo[i,10]
			C9_DATALIB	:= dDatabase
			C9_SEQUEN	:= "01"
			C9_PRCVEN	:= nValTOT 
			C9_LOCAL	:= "01"
			C9_TPCARGA	:= "2"
			C9_RETOPER	:= "2"
			MsUnlock()	 
			lGravaC9 := .T.	
		EndIf
				             
		lGravou := .T.

		End Transaction
						    
		If lGravou
			ConfirmSX8()
		Else
			RollBackSX8()
		EndIf		
								
  	EndIf	

	If !lGravaC5
    	FWrite(nLog,"Não gravou o cabeçalho do Pedido para Nota Fiscal do Cliente: " + aArquivo[i,5]+aArquivo[i,6] + "NF Original: " + aArquivo[i,14] +Chr(13)+Chr(10))	
    	_nErro++	
	ElseIf !lGravaC6 // Não gravou item do Pedido
    	FWrite(nLog,"Não gravou item do Pedido para Nota Fiscal do Cliente: " + aArquivo[i,5]+aArquivo[i,6] + "NF Original: " + aArquivo[i,14] +Chr(13)+Chr(10))	
    	_nErro++
	ElseIf !lGravaC9
    	FWrite(nLog,"Não gravou liberação do Pedido (SC9) Nota Fiscal: "+SF2->F2_DOC +Chr(13)+Chr(10))	
    	_nErro++	
	Else
    	FWrite(nLog,"Pedido de Complemento de ICMS gerado: "+SC5->C5_NUM +Chr(13)+Chr(10))
	EndIf
	
	lGravaC5	:= .F.
	lGravaC6	:= .F.
	lGravaC9	:= .F. 
	
Next i
                                     
FClose(nLog)

If _nErro > 0    
	Alert("Alguns registros não tiveram o numero do Pedido gravados, favor consultar o arquivo de log no caminho C:\SIGA\LOG_PEDCOMPRA\";
			+DToS(dDataBase)+".LOG")
Else
	MsgAlert("Processamento concluído.")
EndIf

// Fecha o Arquivo
FT_FUSE()

Return(Nil)               

