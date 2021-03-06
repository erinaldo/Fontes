/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RIMPA100A  �Autor  �  Eduardo Dias    � Data �  12/12/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para importar o n� do Resgate dos pedidos da        ���
���          � Marketsystem na tabela SD1 e SC7 dos eventos ocorridos     ���
���          � nos meses retroativos.                                     ���
�������������������������������������������������������������������������͹��
���Uso       � RIMPA100A                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RIMPA100()
Local aBotoes	:= {}
Local aSays		:= {}
Local aPergunt	:= {}
Local nOpcao	:= 0

//Tela de aviso e acesso ao parametro de caminho
AAdd(aSays,"       [ IMPORTA��O DO CODIGO DOS PEDIDOS DA MARKETSYSTEM ] ")
AAdd(aSays," Esse programa ir� importar o numero do Pedidos gerado no MarktSystem para as" )
AAdd(aSays,"     tabelas de Pedido de Compras (SC7) e Documento de Enttrada (SD1) " )
Pergunte("RIMPA081",.F.)

AAdd(aBotoes,{ 5,.T.,{|| Pergunte("RIMPA081",.T. ) } } )
AAdd(aBotoes,{ 1,.T.,{|| nOpcao := 1, FechaBatch() }} )
AAdd(aBotoes,{ 2,.T.,{|| FechaBatch() }} )
FormBatch( "  [ IMPORTA��O DO NUMERO DOS PEDIDOS DA MARKETSYSTEM PARA SC7 & SD1 ]", aSays, aBotoes )

If nOpcao == 1
	Processa({|| RIMPA100a() })
EndIf

Return(Nil)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RIMPA100A  �Autor  �  Eduardo Dias    � Data �  12/12/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para importar o n� do Resgate dos pedidos da        ���
���          � Marketsystem na tabela SD1 e SC7 dos eventos ocorridos     ���
���          � nos meses retroativos.                                     ���
�������������������������������������������������������������������������͹��
���Uso       � RIMPA100A                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function RIMPA100a()
Local lGravaC7		:= .F.
Local lGravaD1		:= .F.
Local nLog			:= 0
Local aArquivo		:= {}               
Local _nErro   		:= 0
Local i   		   	:= 0 
Local cLinha   		:= ""

If SM0->(M0_CODIGO<>'05'.or. M0_CODFIL<>'03')
	MsgStop("A execu��o dessa rotina so poder� ser feita na "+Chr(13)+Chr(10)+Chr(13)+Chr(10)+ "Empresa: 05 (CSU CARDSYSTEM)";
				+Chr(13)+Chr(10)+"Filial: 03 (ALPHAVILLE)")
	Return
Endif

If !File(mv_par01)
	MsgAlert("Aten��o, o arquivo informado n�o foi localizado.")
	Return()
EndIf

FT_FUse(mv_par01)
FT_FGoTop()
ProcRegua(FT_FLastRec())
FT_FGoTop()

cLinha   := FT_FReadLn()
_cNomeArq := DToS(dDataBase)+".txt" // Nome do arquivo (data) que ser� gerado o LOG se necess�rio.
nLog := FCreate("C:\SIGA\LOG_PEDCOMPRA\"+_cNomeArq)

// Pula para pr�xima linha  
FT_FSkip() 

While !FT_FEof()
	IncProc("Formatando o Arquivo...")
	
	cLinha   := FT_FReadLn()

	AAdd(aArquivo,Array(6))
	aArquivo[Len(aArquivo),1]	:= SUBSTR(cLinha,13,10)		///  Numero do resgate
	aArquivo[Len(aArquivo),2]	:= SUBSTR(cLinha,382,08)	///  Codigo do Produto
	aArquivo[Len(aArquivo),3]	:= SUBSTR(cLinha,439,09) 	///  Numero da NF
	aArquivo[Len(aArquivo),4]	:= SUBSTR(cLinha,448,03) 	///  SERIE da NF
	aArquivo[Len(aArquivo),5]	:= SUBSTR(cLinha,457,05) 	///  Especie da NF
	aArquivo[Len(aArquivo),6]	:= SUBSTR(cLinha,636,16) 	///  N�mero do Pedido Marketsystem // OS 3425/16 Ajuste para 16 digitos-Pedido do Fornecedor - Douglas

	FT_FSkip()
EndDo
    	
ProcRegua(Len(aArquivo)-1)

For i := 1 To Len(aArquivo)-1
	
	IncProc("Importando N� do Resgate para o Pedido e NF..."+STR(I))
	
	//Verifica se existe Pedido de Compra da MarketSystem sem o numero do resgate. E atualiza o campo
	Dbselectarea("SC7")
	cArqNtx  := CriaTrab(NIL,.f.)
	cIndCond :="C7_FILIAL + C7_PRODUTO + C7_X_RESG" // Chave de busca no BD SC7
	IndRegua("SC7",cArqNtx,cIndCond,,," ")
	DBGOTOP()
	cProduto := ALLTRIM(aArquivo[i,2])+"G"+SPACE((TamSX3("B1_COD")[1])- LEN(ALLTRIM(aArquivo[i,2]+"G")))
	IF !empty(aArquivo[i,1]) .and. Dbseek(xFilial("SC7")+cProduto+aArquivo[i,1])
		If Empty(SC7->C7_X_RESGP)
			RecLock("SC7", .F.)
			SC7->C7_X_RESGP	:= aArquivo[i,6]
			MsUnlock()
			lGravaC7 := .T.				
		EndIf         	
  	EndIf
	     
	//Verifica se existe Documento de Entrada gerado sem o numero do resgate. E atualiza o campo "D1_X_RESGP"
	Dbselectarea("SD1")
	cArqNtx  := CriaTrab(NIL,.f.)
	cIndCond :="D1_FILIAL + D1_DOC + D1_X_RESG" // Chave de busca no BD SD1
	IndRegua("SD1",cArqNtx,cIndCond,,," ")
	DBGOTOP()
	IF !empty(aArquivo[i,1]) .and. Dbseek(xFilial("SD1")+aArquivo[i,3]+aArquivo[i,1])
		If Empty(SD1->D1_X_RESGP)
			RecLock("SD1", .F.)
			SD1->D1_X_RESGP	:= aArquivo[i,6]
			MsUnlock()
			lGravaD1 := .T.					
		EndIf         
  	EndIf	

	If !lGravaC7 .And. !lGravaD1 // Se n�o contrado PC com o campo C7_X_RESGP vazio, envia MSG para arquivo de .LOG
    	FWrite(nLog,"O Pedido de Compras N�: "+SC7->C7_NUM +" e a Nota Fiscal N�: "+ALLTRIM(aArquivo[i,3])+;
    				" j� possuem o N�mero de Resgate do Marketsystem "+Chr(13)+Chr(10))	
    	_nErro++
	ElseIf lGravaC7 .And. !lGravaD1 //Se encontrado PC na tabela SC7, mas, nao encontrar a Nota Fiscal atrelada ao Pedido, enviar MSG para o arquivo de LOG
    	FWrite(nLog,"N�o houve entrada de NF para o Pedido de Compras N�: "+SC7->C7_NUM +Chr(13)+Chr(10))
    	_nErro++
	EndIf
Next i
                                     
FClose(nLog)

If _nErro > 0    
	Alert("Alguns registros n�o tiveram o numero do Pedido da Marketsystem gravados, favor consultar o arquivo de log no caminho C:\SIGA\LOG_PEDCOMPRA\";
			+DToS(dDataBase)+".LOG")
Else
	MsgAlert("Processamento conclu�do.")
EndIf

// Fecha o Arquivo
FT_FUSE()

Return(Nil)