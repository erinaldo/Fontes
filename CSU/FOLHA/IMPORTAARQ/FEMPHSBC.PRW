#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#DEFINE          cEol         CHR(13)+CHR(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FEMPHSBC บ Autor ณ Isamu K.           บ Data ณ 11/11/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Gera็ใo/importa็ใo de empr้stimo Consignado HSBC           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Exclusivo da CSU                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function fEmpHsbc


Private	bProcesso := {|oArq| fProc1( oArq )}

Private cCadastro  := "IMPORTAวรO / GERAวรO EMPRษSTIMO CONSIGNADO DO H.S.B.C "
Private cDescricao
Private nContad    := 0
Private cPerg      := "FEMPHSBC"
Private cFolMes    := cPeriodo //GetMv("MV_FOLMES")

cDescricao := "Este programa irแ importar de um arquivo texto ou gerar um  " + Chr(13) + Chr(10)
cDescricao += "arquivo texto no formato CNAB a ser enviado/recebido do     " + Chr(13) + Chr(10)
cDescricao += "banco H.S.B.C. , conforme parametros definidos pelo usuario."

tNewProcess():New( "SRA" , cCadastro , bProcesso , cDescricao , cPerg,,,,,.T.,.F. )

fPerg()
Pergunte(cPerg,.F.)


Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
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
Static Function fProc1()


cOpera   := mv_par01
dDtRef   := mv_par02
cCaminho := mv_par03
cFilDe   := mv_par04
cFilAte  := mv_Par05
cMatDe   := mv_par06
cMatAte  := mv_par07
cSit     := mv_par08


If cOpera == 2 //importa
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicializa a regua de processamento                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

   Processa({|| fProcess1() },"Processando...")

Else  //Cnab

   Processa({|| fProcess2() },"Processando...")

Endif
           

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
Static Function fProcess1

Local cPath    := ""
Local cArquivo := ""
Local cTitulo1 := "Selecione o arquivo"
Local cExtens  := "Arquivo TXT | *.txt"
Local nTamFile := 0
Local nTamLin  := 0
Local cBuffer  := ""
Local nBtLidos := 0
Local lImport  := .F.
Local dDtMov   := Ctod( "" )
Local cFileOpen := ""
Local nContad   := 0
Local nConta2   := 0
Local cSeqTxt   := ""
Local aLogTitle  := {}
Local aLogDetail := {}
Local aStru := {}
Local nVTitGrv  := 0
Local nVDepGrv  := 0
Local aDemix    := {}
Local aAfasx    := {}
Local aNormx    := {}

Private nPosImpOk  := 1
Private nPosImpNo  := 2
Private nPosImpDem := 3
Private nPosImpAfa := 4
Private nPosImpSub := 5
Private nPosImpFil := 6

Aadd(aLogTitle, "Log de Importa็ใo do Empr้stimo Consignado HSBC - REGISTROS IMPORTADOS" )
Aadd(aLogDetail,{})
Aadd(aLogTitle, "Log de Importa็ใo do Empr้stimo Consignado HSBC - REGISTROS NAO IMPORTADOS" )
Aadd(aLogDetail,{})
Aadd(aLogTitle, "Log de Importa็ใo do Empr้stimo Consignado HSBC - FUNCIONมRIOS DEMITIDOS" )
Aadd(aLogDetail,{})
Aadd(aLogTitle, "Log de Importa็ใo do Empr้stimo Consignado HSBC - FUNCIONมRIOS AFASTADOS" )
Aadd(aLogDetail,{})

//INDEXANDO RHO POR FILIAL,MAT,COMPET, ORIGEM
cIndCond:= "SRK->RK_FILIAL + SRK->RK_MAT + SRK->RK_PD + SRK->RK_DOCUMEN"
cArqNtx  := CriaTrab(Nil,.F.)
IndRegua("SRK",cArqNtx,cIndCond,,,"Selecionando Registros...")  //"Selecionando Registros..."

cFileOpen := cGetFile(cExtens,cTitulo1,2,,.T.,GETF_LOCALHARD+GETF_NETWORKDRIVE,.T.)

If !File(cFileOpen)
	MsgAlert("Arquivo texto: "+cFileOpen+" nใo localizado")
	Return(.F.)
EndIf

nRegs := fContaReg(cFileOpen)

ProcRegua(nRegs)


FT_FUSE(cFileOpen)   //ABRIR
FT_FGOTOP()          //PONTO NO TOPO

While !FT_FEOF()  //FACA ENQUANTO NAO FOR FIM DE ARQUIVO
	
	nContad++
	
	IncProc( "Proc Funcionarios -> " + StrZero(nContad,8) + " de " + StrZero(nRegs,8) )
	
	// Capturar dados
	cBuffer := FT_FREADLN() //LENDO LINHA
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ S๓ irei importar registros Detalhe (funcionarios)                   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If Subs(cBuffer,4,5) <> "00013"
		FT_FSKIP()
		LOOP
	Endif
	
	cCpf    := Subs(cBuffer,52,11)
	cDoc    := Subs(cBuffer,162,20)
	cDoc    := StrZero(Val(cDoc),12)
	cValParc:= Subs(cBuffer,144,9)
	cParc   := Subs(cBuffer,108,2)
	cInicio := Subs(cBuffer,98,2)+"/"+Subs(cBuffer,100,2)+"/"+Subs(cBuffer,102,4)
	
	fBuscaFun(cCpf,@aDemix,@aAfasx,@aNormx)
	
	If Len(aDemix) == 0 .and. Len(aAfasx) == 0 .and. Len(aNormx) == 0
		fGeraLog( @aLogDetail, nPosImpNo,,, "Registro Nใo Encontrado no Cadastro de Funcionแrios ! C.P.F. : " + Transform(cCpf,'@R 999,999,999-99'))
		FT_FSKIP()
		LOOP
	EndIf
	
	If Len(aNormx) > 0
		
		For n := 1 to Len(aNormx)
			
			If Srk->(dbSeek(aNormx[n,1]+aNormx[n,2]+'653'+cDoc))
				RecLock("SRK",.F.)
				Srk->Rk_ValorTo := Val(cParc)*(Val(cValParc)/100)
				Srk->Rk_Parcela := Val(cParc)
				Srk->Rk_ValorPa := Val(cValParc)/100
				Srk->Rk_DtVenc  := Ctod(cInicio)
				MsUnlock()
			Else
				RecLock("SRK",.T.)
				Srk->Rk_Filial  := aNormx[n,1]
				Srk->Rk_Mat     := aNormx[n,2]
				Srk->Rk_Pd      := "653"
				Srk->Rk_ValorTo := Val(cParc)*(Val(cValParc)/100)
				Srk->Rk_Parcela := Val(cParc)
				Srk->Rk_ValorPa := Val(cValParc)/100
				Srk->Rk_DtVenc  := Ctod(cInicio)
				Srk->Rk_DtMovi  := Ctod(cInicio)
				Srk->Rk_Documen := cDoc
				Srk->Rk_CC      := aNormx[n,3]
				Srk->Rk_RegraDs := "1"
				Srk->Rk_EmpCons := "S"
				MsUnlock()
			Endif
			
			fGeraLog( @aLogDetail, nPosImpOk, aNormx[n,1], aNormx[n,2], Posicione("SRA",1,aNormx[n,1]+aNormx[n,2],"RA_NOME") + " - Registro Importado com Sucesso. Valor: " +  Transform(Val(cParc)*(Val(cValParc)/100),'@E 999,999.99')   )
			
		Next
		
	ElseIf Len(aAfasx) > 0
		
		For n := 1 to Len(aAfasx)
			
			If Srk->(dbSeek(aAfasx[n,1]+aAfasx[n,2]+'653'+cDoc))
				RecLock("SRK",.F.)
				Srk->Rk_ValorTo := Val(cParc)*(Val(cValParc)/100)
				Srk->Rk_Parcela := Val(cParc)
				Srk->Rk_ValorPa := Val(cValParc)/100
				Srk->Rk_DtVenc  := Ctod(cInicio)
				MsUnlock()
			Else
				RecLock("SRK",.T.)
				Srk->Rk_Filial  := aAfasx[n,1]
				Srk->Rk_Mat     := aAfasx[n,2]
				Srk->Rk_Pd      := "653"
				Srk->Rk_ValorTo := Val(cParc)*(Val(cValParc)/100)
				Srk->Rk_Parcela := Val(cParc)
				Srk->Rk_ValorPa := Val(cValParc)
				Srk->Rk_DtVenc  := Ctod(cInicio)
				Srk->Rk_DtMovi  := Ctod(cInicio)
				Srk->Rk_Documen := cDoc
				Srk->Rk_CC      := aAfasx[n,3]
				Srk->Rk_RegraDs := "1"
				Srk->Rk_EmpCons := "S"
				MsUnlock()
			Endif
			
			fGeraLog( @aLogDetail, nPosImpAfa, aAfasx[n,1], aAfasx[n,2], Posicione("SRA",1,aAfasx[n,1]+aAfasx[n,2],"RA_NOME") + " - Registro Importado para Funcionแrio Afastado. Valor: " + Transform(Val(cParc)*(Val(cValParc)/100),'@E 999,999.99')   )
			
		Next
		
	Else
		
			
			fGeraLog( @aLogDetail, nPosImpDem, aDemix[1,1], aDemix[1,2], Posicione("SRA",1,aDemix[1,1]+aDemix[1,2],"RA_NOME") + " - Registro nใo Importado para Funcionแrio Demitido. Valor: " + Transform(Val(cParc)*(Val(cValParc)/100),'@E 999,999.99')   )
			
		
	Endif
	
	
	FT_FSKIP()   //proximo registro no arquivo txt
	
EndDo

FT_FUSE() //fecha o arquivo txt

RetIndex( "SRK" )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Mostra os Logs gerados                                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
fMakeLog( aLogDetail, aLogTitle, NIL, NIL, FunName(), NIL, NIL, NIL, NIL, .F. )


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
Static Function fProcess2

Local aLogTitle  := {}
Local aLogDetail := {}
Local nSeq       := 0
Local nTot       := 0
Local dDtMov     := Ctod("//")
Local dDtVenc    := Ctod("//")
Local nParcPaga  := 0
Local nParcelas  := 0
Local nValParc   := 0
Local nParcTot   := 0
Local cOcorr             
Local cComprom  
Local nValSrc    := 0

Private nPosImpOk  := 1
Private nPosImpNo  := 2
Private nPosImpDem := 3
Private nPosImpAfa := 4
Private nPosImpSub := 5
Private nPosImpFil := 6
Private nTotReg    := 0
Private nHdl       := 0
Private lSrk       := .F.
Private aSRK       := {}

Aadd(aLogTitle, "Log de Gera็ใo do Arquivo de Empr้stimo Consignado HSBC - REGISTROS GERADOS" )
Aadd(aLogDetail,{})
Aadd(aLogTitle, "Log de Gera็ใo do Arquivo de Empr้stimo Consignado HSBC - FUNCIONมRIOS DEMITIDOS" )
Aadd(aLogDetail,{})
Aadd(aLogTitle, "Log de Gera็ใo do Arquivo de Empr้stimo Consignado HSBC - FUNCIONมRIOS AFASTADOS" )
Aadd(aLogDetail,{})

// Cria Arquivo Texto
cHora    := SubStr(Time(),1,2)+"."+SubStr(Time(),4,2)+"."+SubStr(Time(),7,2)
//cCaminho := Alltrim(cCaminho) + If(Right(cCaminho,1) # "\","","\")
//cArqTxt := cCaminho + "CONSIGHSBC" + Dtos( dDataBase ) + "_" + cHora
//cArqTxt += ".TXT"
cArqTxt := Alltrim(cCaminho)

If nHdl > 0
	fClose(nHdl)
Endif

nHdl := fCreate( cArqTxt )

If nHdl == -1
	MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
	Return
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta o Header de arquivo                                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cLin := '399' + '0000' + '0' + Space(9) + '2' + Padr(Sm0->M0_Cgc,14) + Replicate('0',20) + Replicate('0',5) + '0' 
cLin += Replicate('0',12) + '00' + Padr(Sm0->M0_NomeCom,30) + 'HSBC BANK BRASIL S/A          '
cLin += Space(10) + '2' + GravaData(dDataBase,.F.,5) + SubStr(Time(),1,2)+SubStr(Time(),4,2)+SubStr(Time(),7,2)
cLin += Replicate('0',6) + '080' + Replicate('0',5) + 'CSHREM              ' + Space(49)
cLin += cEol

nTot++

fGravaTxt(cLin)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta o Header de Lote                                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cLin := '399' + '0000' + '1' + '0' + '11' + '020' + StrZero(Month(dDtRef),2) + StrZero(Year(dDtRef),4) + '0001'
cLin += Replicate('0',7) + '2' + Padr(Sm0->M0_Cgc,14) + Replicate('0',6) + Replicate('0',20) + Replicate('0',5)
cLin += '0' + Replicate('0',12) + '00' + Padr(Sm0->M0_NomeCom,30) + '00' + Space(116)
cLin += cEol

nTot++

fGravaTxt(cLin)

// Monta a Query Principal
MsAguarde( {|| fMtaQuery( @nTotReg ) }, "Processando...", "Selecionado Registros no Banco de Dados..." )

ProcRegua(nTotReg)

dbSelectArea( "WSRA" )
dbGoTop()

While WSra->(!Eof())
	
	nContad++
	
	IncProc( "Proc Funcionarios -> " + StrZero(nContad,8) + " de " + StrZero(nTotReg,8) )
	
	fProcEmp(Wsra->Filial,Wsra->Matric,@nValSRC,@lSRK,@aSRK)
	
	If Len(aSrk) == 0
		Wsra->(dbSkip())
		Loop
	Endif  
	
	For nT := 1 to Len(aSrk)
		
        cValParc := StrTran(StrZero(aSrk[nT,5],10,2),".","")
        nValParc := aSrk[nT,5]
        cDataIni := Stod(aSrk[nT,1])
        cDataIni := GravaData(cDataIni,.F.,5)
        cDataFim := Stod(aSrk[nT,1])+365
		cDataFim := GravaData(cDataFim,.F.,5)

		If WSra->SitFun == "A" .And. !(nValSrc > 0)
		   cOcorr  := "02"      
		   cValParc:= "000000000"
		   cComprom := "0"
		ElseIf WSra->SitFun == "A" .And. nValSrc > 0
		   cOcorr  := "02"      
		   cValParc:= StrTran(StrZero(nValParc,10,2),".","")		
		   cComprom := "0"
		ElseIf WSra->SitFun == "D" .And. nValSrc > 0
		   cOcorr  := "08"
		   cComprom:= "1"
		   cValParc:= StrTran(StrZero(nValParc,10,2),".","")
		ElseIf WSra->SitFun == "D" .And. !(nValSrc > 0)
		   cOcorr  := "08"
		   cComprom:= "2"
		   cValParc:= "000000000"
		Else
		   cOcorr := "00"  
		   cValParc:= StrTran(StrZero(nValParc,10,2),".","")
		   cComprom := "0"
		Endif    

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Monta o Registro de Detalhe                                         ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cLin := '399' + '0001' + '3' + StrZero(nSeq,5) + 'H' + '0' + Padr(WSRA->NOME,30) + Replicate('0',6) 
		cLin += StrZero(Val(WSRA->CPF),11) + StrZero(Val(WSRA->MATRIC),12) + '000' + cComprom  
		cLin += If(cOcorr=="08",cValParc,"000000000") + Replicate('0',9) + '2' + Subs(aSrk[nT,2],7,2) + Subs(aSrk[nT,2],5,2)
		cLin += Subs(aSrk[nT,2],1,4) + StrZero(aSrk[nT,3]+1,2) + StrZero(aSrk[nT,4],2) + cDataIni
		cLin += cDataFim + Replicate('0',9) + Replicate('0',9) + cValParc
		cLin += Replicate('0',9) + StrZero(Val(aSrk[nT,6]),20) + Replicate('0',2)  
		cLin += Replicate('0',9) + Replicate('0',9) + '0' + Replicate('0',5) + '0' + Replicate('0',12) + '0' + Space(9) + cOcorr
		cLin += Space(8)
		cLin += cEol
		                                                                           
		fGravaTxt(cLin)
		
		nSeq++
		nTot++
		nParcTot += nValParc  
		
	Next
	
	WSra->(dbSkip())
	
EndDo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta o Trailer de Lote                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cLin := '399' + '0001' + '5' + '0000001' + StrZero(nSeq,6) + '00000' + StrTran(StrZero(nParcTot,16,2),".","") + '00000'
cLin += '000000000000000' + '00000' + '000000000000000' + '00000' + '000000000000000' + '000000000' + Space(130)
cLin += cEol

nSeq++
ntot++

nParcTot   := 0

fGravaTxt(cLin)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta o Trailer de Arquivo                                          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cLin := '399' + '9999' + '9' + Space(9) + '000001' + StrZero(nTot+1,6) + '000000' + Space(205)
cLin += cEol

fGravaTxt(cLin)

fClose( nHdl )

MsgAlert("Arquivo gravado no diretorio : "+cArqTxt)

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
ฑฑบPrograma  ณfCriaPerg บAutor  ณMicrosiga           บ Data ณ  11/21/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Perguntas do Sistema.                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fPerg()

Local aRegs := {}

aAdd(aRegs,{cPerg,'01','Opera็ใo ?                   ','','','mv_ch1','C',01,0,0,'C','Naovazio   ','mv_par01','Gera็ใo CNAB   ','','','','','Importa็ใo  ','','','','','         ','','','','','            ','','','','','           ','','','','   ',''})
aAdd(aRegs,{cPerg,'02','Data de Refer๊ncia ?         ','','','mv_ch2','D',08,0,0,'G','Naovazio   ','mv_par02','               ','','','','','            ','','','','','         ','','','','','            ','','','','','           ','','','','   ',''})
aAdd(aRegs,{cPerg,'03','Diret.Grava็ใo(Gera็ใo CNAB) ','','','mv_ch3','C',30,0,0,'G','naovazio   ','mv_par03','               ','','','','','        	   ','','','','','         ','','','','','            ','','','','','           ','','',''	,'   ',''})
aAdd(aRegs,{cPerg,'04','Filial de ?                  ','','','mv_ch4','C',02,0,0,'G','NaoVazio   ','mv_par03','               ','','','','','            ','','','','','         ','','','','','            ','','','','','           ','','','','   ',''})
aAdd(aRegs,{cPerg,'05','Filial ate ?                 ','','','mv_ch5','C',02,0,0,'G','NaoVazio   ','mv_par04','               ','','','','','            ','','','','','         ','','','','','            ','','','','','           ','','','','   ',''})
aAdd(aRegs,{cPerg,'06','Matricula de ?               ','','','mv_ch6','C',06,0,0,'G','NaoVazio   ','mv_par05','               ','','','','','            ','','','','','         ','','','','','            ','','','','','           ','','','','   ',''})
aAdd(aRegs,{cPerg,'07','Matricula ate ?              ','','','mv_ch7','C',06,0,0,'G','NaoVazio   ','mv_par06','               ','','','','','            ','','','','','         ','','','','','            ','','','','','           ','','','','   ',''})
aAdd(aRegs,{cPerg,'08','Situa็๕es ?                  ','','','mv_ch8','C',05,0,0,'G','fSituacao  ','mv_par07','               ','','','','','            ','','','','','         ','','','','','            ','','','','','           ','','','','   ',''})

ValidPerg(aRegs,cPerg)

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

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRGPEM02   บAutor  ณMicrosiga           บ Data ณ  01/25/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fGravaTxt( cLin )

If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
		Return
	Endif
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFEMPHSBC  บAutor  ณMicrosiga           บ Data ณ  04/26/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ */
Static Function fMtaQuery( nTotReg )

Local cDataRef := Subs(Dtos(dDtRef),1,6)
Local cQr        := ""
Local cVarSit    := "("

For ni := 1 to Len(cSit) Step 1
	cVarSit += "'"+Subs(cSit,ni,1)+"',"
Next ni

cVarSit := Left(cVarSit,Len(cVarSit)-1)+")"

cQr := "SELECT DISTINCT SRA.RA_FILIAL AS FILIAL, SRA.RA_MAT AS MATRIC, SRA.RA_NOME AS NOME, SRA.RA_CIC AS CPF, SRA.RA_SITFOLH AS SITFUN "
cQr += "FROM "+RetSQLName("SRA")+" SRA,"+RetSQLName("SRK")+" SRK "
cQr += "WHERE SRA.RA_FILIAL = SRK.RK_FILIAL "
cQr += "AND SRA.RA_MAT = SRK.RK_MAT "
cQr += "AND SRA.RA_FILIAL BETWEEN '" + cFilDe + "' AND '" + cFilAte + "'"
cQr += "AND SRA.RA_MAT BETWEEN '" + cMatDe + "' AND '" + cMatAte + "'"
cQr += "AND SRA.RA_SITFOLH IN " + Upper(cVarSit) + " "
cQr += "AND RK_PD = '653' "
cQr += "AND SUBSTRING(RK_DTVENC,1,6) = '"+cDataRef+"' "    //OS 2603/16 By Isamu K.
cQr += "AND RK_VLRPAGO < RK_VALORTO "
cQr += "AND SRA.D_E_L_E_T_ <> '*'"     
cQr += "AND SRK.D_E_L_E_T_ <> '*'"     

If Select("WSRA") > 0
	WSra->(dbCloseArea())
Endif

dbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQr),"WSRA",.T.,.F.)

Count To nTotReg

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณfBuscaFun บ Autor ณ Isamu K.           บ Data ณ  05/10/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar, VALIDADA PARA AP7                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function fBuscaFun(cCic,aDemx,aAfax,aNormx)

Local cQry    := ""
Local aDem  := {}
Local aAfa  := {}
Local aNorm := {}


cQry := " SELECT RA_FILIAL, RA_MAT, RA_CC, RA_SITFOLH "
cQry += " FROM "+RetSqlName("SRA")+ " "
cQry += " WHERE RA_CIC = '"+cCic+"' "
cQry += " AND "+RETSQLNAME("SRA")+".D_E_L_E_T_ <> '*' "

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFecha alias caso esteja aberto ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Select("TMA") > 0
	DBSelectArea("TMA")
	DBCloseArea()
EndIf

dbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQry),"TMA",.F.,.T.)

TMA->(dBGotop())

While !Eof()
	
	If Tma->Ra_SitFolh == "D"
		Aadd(aDem,{ RA_FILIAL, RA_MAT, RA_CC, RA_SITFOLH })
	ElseIf Tma->Ra_SitFolh == "A"
		Aadd(aAfa,{ RA_FILIAL, RA_MAT, RA_CC, RA_SITFOLH })
	ElseIf Tma->Ra_SitFolh $ "F, "
		Aadd(aNorm,{ RA_FILIAL, RA_MAT, RA_CC, RA_SITFOLH })
	Endif
	
	Tma->(dbSkip())
	
EndDo

aDemx := aClone(aDem)
aAfax := aClone(aAfa)
aNormx:= aClone(aNorm)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณfProcEmp  บ Autor ณ Isamu K.           บ Data ณ  05/10/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar, VALIDADA PARA AP7                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function fProcEmp(cFilFun,cMatFun,nValSRC,lSRK,aSRK)


Local cQSrk
Local cDataRef := Subs(Dtos(dDtRef),1,6)

aSrk := {}

cQSrk := " SELECT * "
cQSrk += " FROM "+RetSqlName("SRK")+ " "
cQSrk += " WHERE RK_FILIAL = '"+cFilFun+"' "
cQSrk += " AND RK_MAT = '"+cMatFun+"' "
cQSrk += " AND RK_PD = '653' "
cQSrk += " AND SUBSTRING(RK_DTVENC,1,6) = '"+cDataRef+"' " //OS 2603/16 By Isamu K.
cQSrk += " AND RK_VLRPAGO < RK_VALORTO "
cQSrk += " AND "+RETSQLNAME("SRK")+".D_E_L_E_T_ <> '*' "

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFecha alias caso esteja aberto ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Select("TMK") > 0
	DBSelectArea("TMK")
	DBCloseArea()
EndIf

dbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQSrk),"TMK",.F.,.T.)

dbSelectArea("TMK")
dbGotop()

While !Eof()
	
	aAdd( aSrk, {Tmk->Rk_DtMovi,Tmk->Rk_DtVenc,Tmk->Rk_ParcPag,Tmk->Rk_Parcela,Tmk->Rk_ValorPa,Tmk->Rk_Documen})
	
	nValSrc := Posicione("SRC",1,Tmk->Rk_Filial+Tmk->Rk_Mat+"653","RC_VALOR") 
	lSrk    := .T.
	
	Tmk->(dbSkip())
	
EndDo


Return    
