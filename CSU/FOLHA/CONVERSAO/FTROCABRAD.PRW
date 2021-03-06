#INCLUDE "protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FTROCABRAD� Autor � Isamu K.           � Data � 24/01/2017  ���
�������������������������������������������������������������������������͹��
���Descricao � Efetua DEPARA dos numeros de contrato de consignado do     ���
���          � HSBC para Bradesco.                                        ���
�������������������������������������������������������������������������͹��
���Uso       � Exclusivo da CSU                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function fTrocaBrad

Local bProcesso := {|oSelf| fProcessa( oSelf )}

Private cCadastro  := "EFETUA ATROCA DOS NUMEROS DE CONTRATO DE EMPR�STIMO CONSIGNADO"
Private cStartPath := GetSrvProfString("StartPath","")
Private cDescricao

cDescricao := "Este programa ir� importar de um arquivo texto contendo os  " + Chr(13) + Chr(10)
cDescricao += "numeros de contrato de Empr�stimo Consignado HSBC e Bradesco" + Chr(13) + Chr(10)
cDescricao += "e efetuandp o DEPARA dentro da tabela de Valores Futuros    " 

tNewProcess():New( "SRK" , cCadastro , bProcesso , cDescricao ,,,,,,.T.,.F. )

Return

/*/
�����������������������������������������������������������������������������
����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � RUNCONT  � Autor � AP5 IDE            � Data �  15/08/07   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function fProcessa( oSelf )

Local cPath    := ""
Local cArquivo := ""
Local nTamFile := 0
Local nTamLin  := 0
Local cBuffer  := ""
Local nBtLidos := 0
Local lImport  := .F.
Local dDtMov   := Ctod( "" )
Local cTitulo1  := "Selecione o arquivo"
Local cExtens	:= "Arquivo CSV | *.csv"
Local cFileOpen := ""
Local nContad   := 0  
Local nConta2   := 0
Local cSeqTxt   := ""
Local aLogTitle  := {}
Local aLogDetail := {}      
Local aStru := {}
Local nVTitGrv  := 0
Local nVDepGrv  := 0 

Private nPosImpOk  := 1
Private nPosImpNo  := 2
Private nExc       := 0 

Aadd(aLogTitle, "Log de Importa��o do DEPARA dos contratos de Consignado - REGISTROS IMPORTADOS" )
Aadd(aLogDetail,{})
Aadd(aLogTitle, "Log de Importa��o do DEPARA dos contratos de Consignado - REGISTROS NAO IMPORTADOS" )
Aadd(aLogDetail,{})

//INDEXANDO SRK POR FILIAL,MAT,COntrato
cIndCond:= "SRK->RK_FILIAL + SRK->RK_MAT + SRK->RK_DOCUMEN"
cArqNtx  := CriaTrab(Nil,.F.)
IndRegua("SRK",cArqNtx,cIndCond,,,"Selecionando Registros...")  //"Selecionando Registros..."

cFileOpen := cGetFile(cExtens,cTitulo1,2,,.T.,GETF_LOCALHARD+GETF_NETWORKDRIVE,.T.)

If !File(cFileOpen)
	MsgAlert("Arquivo texto: "+cFileOpen+" n�o localizado",cCadastro)
	Return(.F.)
EndIf

nRegs := fContaReg(cFileOpen)

oSelf:SetRegua1(nRegs)//( nTamFile/(nTamLin) )

FT_FUSE(cFileOpen)   //ABRIR
FT_FGOTOP()          //PONTO NO TOPO

While !FT_FEOF()  //FACA ENQUANTO NAO FOR FIM DE ARQUIVO
	
	nContad++
	
	oSelf:IncRegua1( "Processando Registros -> " + StrZero(nContad,8) + " de " + StrZero(nRegs,8) )
	
	// Capturar dados
	cBuffer := FT_FREADLN() //LENDO LINHA
	
	nPos1 := at(";",cBuffer)              //filial
	nPos2 := at(";",subs(cBuffer,nPos1+1)) + nPos1 //matricula
	nPos3 := at(";",subs(cBuffer,nPos2+1)) + nPos2 //numero para
	nPos4 := at(";",subs(cBuffer,nPos3+1)) + nPos3 //numero de
	
	cFilTxt   := StrZero(Val(subs(cBuffer,01,nPos1-1)),2)
	cMatTxt   := StrZero(Val(subs(cBuffer,nPos1+1,nPos2-nPos1-1)),6)
	cNumPara  := StrZero(Val(Alltrim(subs(cBuffer,nPos2+1,nPos3-nPos2-1))),12)
	cNumDe    := StrZero(Val(Alltrim(subs(cBuffer,nPos4+1))),12)
	
	
	// Posiciona o Funcionario
	If SRK->(dbSeek( cFilTxt + cMatTxt + cNumDe ))
       
       RecLock("SRK",.F.)
       Srk->Rk_Documen := StrZero(Val(cNumPara),12)
       Srk->(MsUnlock())
  	   
  	   fGeraLog( @aLogDetail, nPosImpOk, cFilTxt, cMatTxt, cNumDe + " --> " + cNumPara + " - Registro Importado com Sucesso."   )
      
	Else
		
		fGeraLog( @aLogDetail, nPosImpNo, cFilTxt, cMatTxt, cNumDe + "--> " + " - Registro N�o Encontrado no arquivo de Valores Futuros ! ! " )

		FT_FSKIP()
		LOOP

	EndIf
	
	FT_FSKIP()   //proximo registro no arquivo txt
	
EndDo

FT_FUSE() //fecha o arquivo txt


//���������������������������������������������������������������������Ŀ
//� Mostra os Logs gerados                                              �
//�����������������������������������������������������������������������
fMakeLog( aLogDetail, aLogTitle, NIL, NIL, FunName(), NIL, NIL, NIL, NIL, .F. )


Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fgeralog  �Autor  �Microsiga           � Data �  06/26/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP10                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */
Static Function fGeraLog( aLogDetail, nPos, c_Filial, c_Matric, cOcorrencia )

Aadd(aLogDetail[nPos],c_Filial + " - " + c_Matric + " - " + cOcorrencia )

Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FDEPAFIL  �Autor  �Microsiga           � Data �  08/20/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP10                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */
Static Function fContaReg(cFileX)

Local nNumX  := 0
Local nCount := 0

FT_FUSE(cFileX)   //ABRIR
FT_FGOTOP()       //PONTO NO TOPO


While !FT_FEOF()  //FACA ENQUANTO NAO FOR FIM DE ARQUIVO
	IncProc("Aguarde, efetuando contagem dos registros ......")
	nCount++
	
	FT_FSKIP()   //proximo registro no arquivo txt
	
EndDo

nNumX := nCount

Return(nNumX)
