#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRGPE01AFT บ Autor ณ AP6 IDE            บ Data ณ  05/04/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio de Funcionarios afastados                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑ Alteracoes: 10/09/07: Claudinei E.N.-inclusใo do campo CTT->CTT_CCONTD, ฑฑ
ฑฑ                       sob solicita็ใo da Sra.Monica - cham: 000000001044ฑฑ
ฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function RGPE01AFT()
//Declaracao de Variaveis
Local cDesc1 := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2 := "de acordo com os parametros informados pelo usuario."
Local cDesc3 := "relatorio"
Local cPict := ""
Local titulo := "CSU - Relatorio de Funcionarios Afastados"
Local nLin := 80
Local Cabec1 := "Filial    Matric.   Nome                                  Data afastamento        Centro de custo      Descricao centro de custo                  Cod.CC Novo   Desc.CC Novo"
Local Cabec2 := ""
Local imprime := .T.
Local aOrd := {}
Private lEnd := .F.
Private lAbortPrint := .F.
Private CbTxt := ""
Private limite := 80
Private tamanho := "G"
Private nomeprog := "RGpe01Aft"
Private nTipo := 18
Private aReturn := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey := 0
Private cPerg := "RGPEAFT"
Private cbtxt := Space(10)
Private cbcont := 00
Private CONTFL := 01
Private m_pag := 01
Private wnrel := "RGpe01Aft" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString := "SR8"
Private nTot := 0

ValidPerg(cPerg)

dbSelectArea("SR8")
dbSetOrder(1)

pergunte(cPerg,.F.)

//Monta a interface padrao com o usuario...
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//Processamento. RPTSTATUS monta janela com a regua de processamento
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  05/04/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Local nOrdem
Public cNome
Public cDescCC
Public cCC  
Public cFil  
Public cArea
Public cCCNovo
Public cCCNDes

dbSelectArea(cString)
DbSetOrder(1)
DBSEEK(xFilial("SR8"))

//SETREGUA -> Indica quantos registros serao processados para a regua
SetRegua(RecCount())

While !EOF() .AND. SR8->R8_FILIAL >= MV_PAR03 .AND. SR8->R8_FILIAL<=MV_PAR04
   //Verifica o cancelamento pelo usuario...
   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //Impressao do cabecalho do relatorio. . .
   If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif
    If SR8->R8_DATAINI >= MV_PAR01 .AND. SR8->R8_DATAINI<= MV_PAR02 .AND. SR8->R8_DATAFIM==CtoD("  /  /  ")
    	cFil := SR8->R8_FILIAL
	    Funcionario(cFil)
    
   		@nLin,002 PSAY SR8->R8_FILIAL
			@nLin,010 PSAY SR8->R8_MAT
			@nLin,020 PSAY cNome
			@nLin,064 PSAY SR8->R8_DATAINI
			@nLin,084 PSAY cCC
			@nLin,104 PSAY cDescCC
			@nLin,147 PSAY cCCNovo
			@nLIn,161 PSAY cCCNDes

			nLin := nLin + 1 // Avanca a linha de impressao
			nTot := nTot+1
   EndIf
   dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo                                
		@nLin,00 PSAY __PrtThinLine()
  	nLin++	
    @nLin,15 PSAY "TOTAL:  "
    @nLin,25 PSAY nTot

//Finaliza a execucao do relatorio...
SET DEVICE TO SCREEN

//Se impressao em disco, chama o gerenciador de impressao...
If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return        

Static Function Funcionario(cFil)

  cArea:=GetArea()
	DbSelectArea("SRA") 
	DbSetOrder(1)
	DbSeek(cFil+SR8->R8_MAT)
	cNome 		:= SRA->RA_NOME
	cCC			:= SRA->RA_CC
	cDescCC	:= POSICIONE("CTT",1,xFILIAL("CTT")+cCC,"CTT_DESC01")
	cCCNovo := POSICIONE("CTT",1,xFILIAL("CTT")+cCC,"CTT_CCONTD") //10/08/07-Claudinei E.N.: incluํdo centro de custo novo
	cCCNDes := POSICIONE("CTT",1,xFILIAL("CTT")+cCCNovo,"CTT_DESC01") //10/08/07-Claudinei E.N.: incluido descricao do centro de custo novo

	RestArea(cArea)
Return  
       

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบFuno  ValidPerg(cPerg) Autor ณ AP6 IDE          บ Data ณ  05/04/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Criar perguntas																						บฑฑ
ฑฑบ          ณ                																						บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValidPerg(cPerg)
cArea  := getArea()

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,6)
aRegs:={}

aAdd(aRegs,{cPerg,"01","Afastados desde:","","","mv_ch1","D",01,0,0,"G","            ","mv_par01"," ","","","","","","","","","","","","","","","","","","","","","","","","   ","","",""})
aAdd(aRegs,{cPerg,"02","Afastados at้:","","","mv_ch2","D",01,0,0,"G","            ","mv_par02"," ","","","","","","","","","","","","","","","","","","","","","","","","   ","","",""})
aAdd(aRegs,{cPerg,"03","Filial de       ","","","mv_ch3","C",02,0,0,"G","            ","mv_par03","         ","","","","","         ","","","","","","","","","","","","","","","","","","","SM0","","","          "})
aAdd(aRegs,{cPerg,"04","Filial ate      ","","","mv_ch4","C",02,0,0,"G","            ","mv_par04","         ","","","","","         ","","","","","","","","","","","","","","","","","","","SM0","","","          "})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)     //RESERVA DENTRO DO BANCO DE PERGUNTAS
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()    //SALVA O CONTEUDO DO ARRAY NO BANCO
	Endif
Next

RestArea(cArea)

Pergunte(cPerg,.F.)

Return