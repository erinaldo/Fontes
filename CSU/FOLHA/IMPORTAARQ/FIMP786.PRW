#INCLUDE "protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FIMP786  � Autor � Isamu K.           � Data � 26/03/2014  ���
�������������������������������������������������������������������������͹��
���Descricao � Importacao dos valores do evento 786 para a tabela SRR     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Exclusivo da CSU                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function fImp786

Local bProcesso := {|oSelf| fProcessa( oSelf )}

Private cCadastro  := "IMPORTA��O DOS VALORES DO EVENTO 786"
Private cStartPath := GetSrvProfString("StartPath","")
Private cDescricao

cDescricao := "Este programa ir� importar de um arquivo CSV contendo     " + Chr(13) + Chr(10)
cDescricao += "os valores da verba 786.                                  " + Chr(13) + Chr(10)
cDescricao += "Preencha os Par�metros e, ap�s confirmar a opera��o, ser� " + Chr(13) + Chr(10)
cDescricao += "aberta uma tela para para escolher o local e o arquivo a  " + Chr(13) + Chr(10)
cDescricao += "ser importado.                                            "

tNewProcess():New( "SRR" , cCadastro , bProcesso , cDescricao ,,,,,,.T.,.F. )

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
Private nPosImpDem := 3
Private nPosImpAfa := 4
Private nPosImpSub := 5
Private nPosImpFil := 6
Private nExc       := 0 


Aadd(aLogTitle, "Log de Importa��o da Co-Participa��o da Assist�ncia M�dica - REGISTROS IMPORTADOS" )
Aadd(aLogDetail,{})
Aadd(aLogTitle, "Log de Importa��o da Co-Participa��o da Assist�ncia M�dica - REGISTROS NAO IMPORTADOS" )
Aadd(aLogDetail,{})
Aadd(aLogTitle, "Log de Importa��o da Co-Participa��o da Assist�ncia M�dica - FUNCION�RIOS DEMITIDOS" )
Aadd(aLogDetail,{})
Aadd(aLogTitle, "Log de Importa��o da Co-Participa��o da Assist�ncia M�dica - FUNCION�RIOS AFASTADOS" )
Aadd(aLogDetail,{})

SRR->(dbSetOrder( 6 ))

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
	nPos3 := at(";",subs(cBuffer,nPos2+1)) + nPos2 //data demissao
	nPos4 := at(";",subs(cBuffer,nPos3+1)) + nPos3 //valor
	
	cFilTxt   := StrZero(Val(subs(cBuffer,01,nPos1-1)),2)
	cMatTxt   := StrZero(Val(subs(cBuffer,nPos1+1,nPos2-nPos1-1)),6)
	dDemTxt   := cTod(subs(cBuffer,nPos2+1,nPos3-nPos2-1))
	nValTxt   := Val(subs(cBuffer,nPos3+1))
	cNomeTxt  := Posicione("SRA",1,cFilTxt+cMatTxt,"RA_NOME") 
	
	// Posiciona o Funcionario
	If !(SRR->(dbSeek( cFilTxt + cMatTxt )))
		fGeraLog( @aLogDetail, nPosImpNo, cFilTxt, cMatTxt, "Registro N�o Encontrado no Cadastro de Funcion�rios ! Valor: " + Transform(nValTxt,'@E 999,999.99'))
		FT_FSKIP()
		LOOP
	EndIf
	
    If Srr->(dbSeek(cFilTxt+cMatTxt+"R"+Dtos(dDemTxt)+"786"))
    
       RecLock("SRR",.F.)
       Srr->RR_Valor := nValTxt
       MsUNlock()
       
    Endif   

	fGeraLog( @aLogDetail, nPosImpOk, cFilTxt, cMatTxt, cNomeTxt + " - Registro Importado com Sucesso. Valor: " +  Transform(nValTxt,'@E 999,999.99')  )
	
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

