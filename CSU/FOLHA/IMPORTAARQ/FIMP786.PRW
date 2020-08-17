#INCLUDE "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FIMP786  บ Autor ณ Isamu K.           บ Data ณ 26/03/2014  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Importacao dos valores do evento 786 para a tabela SRR     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Exclusivo da CSU                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function fImp786

Local bProcesso := {|oSelf| fProcessa( oSelf )}

Private cCadastro  := "IMPORTAวรO DOS VALORES DO EVENTO 786"
Private cStartPath := GetSrvProfString("StartPath","")
Private cDescricao

cDescricao := "Este programa irแ importar de um arquivo CSV contendo     " + Chr(13) + Chr(10)
cDescricao += "os valores da verba 786.                                  " + Chr(13) + Chr(10)
cDescricao += "Preencha os Parโmetros e, ap๓s confirmar a opera็ใo, serแ " + Chr(13) + Chr(10)
cDescricao += "aberta uma tela para para escolher o local e o arquivo a  " + Chr(13) + Chr(10)
cDescricao += "ser importado.                                            "

tNewProcess():New( "SRR" , cCadastro , bProcesso , cDescricao ,,,,,,.T.,.F. )

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ RUNCONT  บ Autor ณ AP5 IDE            บ Data ณ  15/08/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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


Aadd(aLogTitle, "Log de Importa็ใo da Co-Participa็ใo da Assist๊ncia M้dica - REGISTROS IMPORTADOS" )
Aadd(aLogDetail,{})
Aadd(aLogTitle, "Log de Importa็ใo da Co-Participa็ใo da Assist๊ncia M้dica - REGISTROS NAO IMPORTADOS" )
Aadd(aLogDetail,{})
Aadd(aLogTitle, "Log de Importa็ใo da Co-Participa็ใo da Assist๊ncia M้dica - FUNCIONมRIOS DEMITIDOS" )
Aadd(aLogDetail,{})
Aadd(aLogTitle, "Log de Importa็ใo da Co-Participa็ใo da Assist๊ncia M้dica - FUNCIONมRIOS AFASTADOS" )
Aadd(aLogDetail,{})

SRR->(dbSetOrder( 6 ))

cFileOpen := cGetFile(cExtens,cTitulo1,2,,.T.,GETF_LOCALHARD+GETF_NETWORKDRIVE,.T.)

If !File(cFileOpen)
	MsgAlert("Arquivo texto: "+cFileOpen+" nใo localizado",cCadastro)
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
		fGeraLog( @aLogDetail, nPosImpNo, cFilTxt, cMatTxt, "Registro Nใo Encontrado no Cadastro de Funcionแrios ! Valor: " + Transform(nValTxt,'@E 999,999.99'))
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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Mostra os Logs gerados                                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
fMakeLog( aLogDetail, aLogTitle, NIL, NIL, FunName(), NIL, NIL, NIL, NIL, .F. )


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfgeralog  บAutor  ณMicrosiga           บ Data ณ  06/26/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fGeraLog( aLogDetail, nPos, c_Filial, c_Matric, cOcorrencia )

Aadd(aLogDetail[nPos],c_Filial + " - " + c_Matric + " - " + cOcorrencia )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFDEPAFIL  บAutor  ณMicrosiga           บ Data ณ  08/20/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP10                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
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

