#Include "RWMAKE.CH"
#INCLUDE "AAJ003.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AAJ0003  ³ Autor ³ Adalberto Althoff Jr  ³ Data ³ 18.08.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Folha de Pagamento com o numero de linhas da página        ³±±   
±±³          ³ aumentado para 65                                          ³±±   
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ AAJ0003(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
USER Function AAJ0003()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDesc1 	:= STR0001		//"Folha de Pagamento"
Local cDesc2 	:= STR0002		//"Ser  impresso de acordo com os parametros solicitados pelo usuario."
Local cDesc3 	:= STR0003		//"Obs. Dever  ser impressa uma Folha/Resumo para cada Tipo de Contrato."
Local cString	:= "SRA"        				// alias do arquivo principal (Base)
Local aOrd      := {STR0004,STR0005,STR0006,STR0007,STR0008}		//"C.Custo do Cadastro"###"Matricula"###"Nome"###"C.Custo do Movto."###"C.Custo + Nome"
Local cMesAnoRef

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Private(Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aReturn := { STR0009, 1,STR0010, 2, 2, 1,"",1 }	//"Zebrado"###"Administra‡„o"
Private nomeprog:= "AAJ0003"
Private aLinha  := {},nLastKey := 0
Private cPerg   := PADR("GPR040",LEN(SX1->X1_GRUPO))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Utilizadas na funcao IMPR                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private Titulo	:= STR0011		//"IMPRESSO DA FOLHA DE PAGAMENTO"
Private AT_PRG  := "AAJ0003"
Private wCabec0 := 1
Private wCabec1 := ""
Private CONTFL  := 1
Private LI      := 0
Private nTamanho:= "M"
Private cCabec
Private nOrdem
Private aInfo   := {}
Private cTipCC, cRefOco

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("GPR040",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="AAJ0003"            //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,nTamanho)

If nLastKey = 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey = 27
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01        //  Data de Referencia para a impressao      ³
//³ mv_par02        //  Adto / Folha / 1¦ Parc. / 2¦ Parc.       ³
//³ mv_par03        //  Numero da Semana                         ³
//³ mv_par04        //  Filial  De                               ³
//³ mv_par05        //  Filial  Ate                              ³
//³ mv_par06        //  Centro de Custo De                       ³
//³ mv_par07        //  Centro de Custo Ate                      ³
//³ mv_par08        //  Matricula De                             ³
//³ mv_par09        //  Matricula Ate                            ³
//³ mv_par10        //  Nome De                                  ³
//³ mv_par11        //  Nome Ate                                 ³
//³ mv_par12        //  Situacao                                 ³
//³ mv_par13        //  Categoria                                ³
//³ mv_par14        //  Imprime C.C em outra Pagina              ³
//³ mv_par15        //  Folha Sintetica ou Analitica             ³
//³ mv_par16        //  Imprime Total Filial                     ³
//³ mv_par17        //  Imprime Total Empresa                    ³
//³ mv_par18        //  Imprime Niveis C.Custo                   ³
//³ mv_par19        //  Imprime Unico Nivel                      ³
//³ mv_par20        //  Imprime Apenas Totais Filial/Empresa     ³
//³ mv_par21        //  Imprime Codigo ou Descricao C.Custo      ³
//³ mv_par22        //  Imprime Referencia ou Ocorrencias        ³
//³ mv_par23        //  Tp Contrato                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carregando variaveis mv_par?? para Variaveis do Sistema.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOrdem   := aReturn[8]
dDataRef := mv_par01
nRelat   := mv_par02
Semana   := mv_par03
cFilDe   := mv_par04
cFilAte  := mv_par05
cCcDe    := mv_par06
cCcAte   := mv_par07
cMatDe   := mv_par08
cMatAte  := mv_par09
cNomDe   := mv_par10
cNomAte  := mv_par11
cSit     := mv_par12
cCat     := mv_par13
lSalta   := If(mv_par14 == 1,.T.,.F.)
cSinAna  := If(mv_par15 == 1,"A","S")
lImpFil  := If(mv_par16 == 1,.T.,.F.)
lImpEmp  := If(mv_par17 == 1,.T.,.F.)
lImpNiv  := If(mv_par18 == 1,.T.,.F.)
lUnicNV  := If(mv_par19 == 1,.T.,.F.)
lImpTot  := If(mv_par20 == 1,.T.,.F.)
cTipCC   := mv_par21
cRefOco  := mv_par22
nTpContr := mv_par23

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  Pega descricao da semana                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cDesOrdem:=If(nOrdem == 1,STR0012,If(nOrdem==2,STR0013,If(nOrdem==3,STR0014,If(nOrdem==4,STR0015,STR0016))))		//"  ORDEM: C.C. DO CADASTRO"###"  ORDEM: MATRICULA"###"  ORDEM: NOME"###"  C.C. DO MOVTO."###"  C.CUSTO + NOME"
If Semana # Space(2) .And. Semana # "99"
	cCabec := fRetPer( Semana,dDataRef )
Else
	cCabec := " / "+Upper(MesExtenso(Month(dDataRef)))+STR0017+STR(YEAR(dDataRef),4) + cDesOrdem	//" DE "
Endif

Titulo := STR0018+If(nRelat==1,STR0019,;				//"FOLHA "###"DO ADIANTAMENTO "
Iif(nRelat==2,STR0020,If(nRelat==3,STR0021,;	//"DE PAGAMENTO "###"DA 1a. PARCELA 13o SAL. "
STR0022))) + cCabec 							//"DA 2a. PARCELA 13o SAL."

NewHead    := Nil

cMesAnoRef := StrZero(Month(dDataRef),2) + StrZero(Year(dDataRef),4)

RptStatus({|lEnd| GR040Imp(@lEnd,wnRel,cString,cMesAnoRef,nTpContr,.F.)},Capital(Titulo))

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GPR040Imp³ Autor ³ R.H. - Ze Maria       ³ Data ³ 03.03.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Folha de Pagamanto                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ GPR040Imp(lEnd,wnRel,cString)                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd        - A‡ao do Codelock                             ³±±
±±³          ³ wnRel       - T¡tulo do relat¢rio                          ³±±
±±³          ³ cString     - Mensagem                                     ³±±
±±³          ³ lGeraLanc   - Indica se deve gerar o INSS (SRZ)            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Esta funcao tambem e utilizada a partir da impressao da GPS³±±
±±³          ³ e Contabilizacao(para gerar lancamentos), queira,ao altera-³±±
±±³          ³ la, testar ambas as rotinas.                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
static Function GR040Imp(lEnd,WnRel,cString,cMesAnoRef,nTpContr,lGeraLanc)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cMapa       := 0
Local nLaco       := nByte := 0
Local aOrdBag     := {}
Local cArqMov     := ""
Local cMesArqRef  
Local dChkDtRef   := CTOD("01/"+Left(cMesAnoRef,2)+"/"+Right(cMesAnoRef,4))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Private			                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cMascCus  := GetMv("MV_MASCCUS")
Private cCalcInf  := GetMv("MV_CALCINF")
Private cEncInss  := GetMv("MV_ENCINSS",,"N")
Private cQuebFun  := GetMv("MV_QUEBFUN",,"S") //quando for igual a nao, imprime funcionario sem quebrar pagina 
Private cFolMes   := cPeriodo //GetMv("MV_FOLMES",,Space(08) ) 
Private aNiveis   := {}
Private nDed      := 0.00   // Deducoes Inss
Private aCodFol   := {}
Private	cTpC      := ""
Private	cTpC1     := ""
Private aInssEmp[24][2]
Private aEmpP     := {}  // Empresa
Private aEmpD     := {}
Private aEmpB     := {}
Private aFilP     := {}  // Filial
Private aFilD     := {}
Private aFilB     := {}
Private aCcP      := {}  // Centro de Custo
Private aCcD      := {}
Private aCcB      := {}

Private cContribuicao := cContrProAuto := ""
Private cAnoMesRef    := Right(cMesAnoRef,4) + Left(cMesAnoRef,2)
Private cAliasMov     := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Verifica se deve gerar lancamentos ou imprimir folha.        |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private lGeraSRZ := lGeraLanc

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Verifica Paramentro Calculo INSS com Existencia campo SR->RZ_MAT |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SRZ")
If cEncInss == "S" .and. Type("SRZ->RZ_MAT") == "U"
	AVISO("Aviso","Quando o parametro MV_ENCINSS estiver com 'S' e necessario a criacao do campo RZ_MAT no arquivo SRZ",{"Enter"} ) 
   return
Endif              

If cPaisLoc $ "URU|ARG"
	If nRelat == 3
		cMesArqRef := "13" + Right(cMesAnoRef,4)	
	ElseIf nRelat == 4
		cMesArqRef := "23" + Right(cMesAnoRef,4)		
	Else
		cMesArqRef := cMesAnoRef
	Endif		
Else
	If nRelat == 4  
		cMesArqRef := "13" + Right(cMesAnoRef,4)
	Else
		cMesArqRef := cMesAnoRef
	Endif	              
Endif			

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Verifica se existe o arquivo de fechamento do mes informado  |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !OpenSrc( cMesArqRef, @cAliasMov, @aOrdBag, @cArqMov, dChkDtRef, lGeraSRZ )
	Return .f.
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ aNiveis -  Armazena as chaves de quebra.                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lImpNiv

	aNiveis:= MontaMasc(cMascCus)
	
	//--Criar os Arrays com os Niveis de Quebras
	For nQ = 1 to Len(aNiveis)
		cQ := STR(NQ,1)
		Private aCcP&cQ := {}    // Centro de Custo
		Private aCcD&cQ := {}
		Private aCcB&cQ := {}
		cCcAnt&cQ       := ""    //Variaveis c.custo dos niveis de quebra
		//--Totais dos Funcionarios dos Niveis de quebra
		nCnor&cQ := nCafa&cQ := nCdem&cQ := nCfer&cQ := 0
		nCexc&cQ := nCtra&cQ := nCadm&cQ := nCtot&cQ := 0
	Next nQ
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime folha ou gera SRZ para tipo de contrato INDETERMINADO³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nTpContr == 1 .Or. nTpContr == 3
	cTpC  := "1"
	cTpC1 := " *1"
	fImpGerFol(lEnd,cAnoMesRef)
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime folha ou gera SRZ para tipo de contrato DETERMINADO  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nTpContr == 2 .Or. nTpContr == 3
	cTpC  := "2"
	cTpC1 := "2"
	fImpGerFol(lEnd,cAnoMesRef)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seleciona arq. defaut do Siga caso Imp. Mov. Anteriores      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty( cAliasMov )
	fFimArqMov( cAliasMov , aOrdBag , cArqMov )
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorna ordem 1 dos arquivos processados                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SRC")
dbSetOrder(1)
dbSelectArea("SRI")
dbSetOrder(1)
dbSelectArea("SRA")
Set Filter to
dbSetOrder(1)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Termino do relatorio                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lGeraSRZ
	Li := 58
	Impr("","F")
	Set Device To Screen
	If aReturn[5] = 1
		Set Printer To
		Commit
		ourspool(wnrel)
	Endif
	MS_FLUSH()
EndIf

Return .T.

*---------------------------------------------*
Static Function fSoma(aMatriz,cArq,cCod,nValor)
*---------------------------------------------*
// 1- Matriz onde os dados estao sendo armazenados
// 2- Tipo de Arquivo "C" ou "I"
// 3- Prov/Desc/Base a ser gravado

Local nRet
Local nVal1 := nVal2 := nVal3 := 0

If	cCod == Nil                  // Caso o Codigo nao seja passado
	If	cArq == "C"               // o tratamento e feito de acordo
		cCod := SRC->RC_PD        // com o cArq (Arquivo usado).
	Elseif cArq == "I"
		cCod := SRI->RI_PD
	Endif
Endif

If nValor == Nil
	If	cArq == "C"               // o tratamento e feito de acordo
		nValor := SRC->RC_VALOR        // com o cArq (Arquivo usado).
	Elseif cArq == "I"
		nValor := SRI->RI_VALOR
	Endif
Endif

If	cArq == "C"
	nVal1 := If(SRC->RC_QTDSEM > 0, SRC->RC_QTDSEM, SRC->RC_HORAS)
	nVal2 := nValor
	nVal3 := SRC->RC_PARCELA
Elseif cArq == "I"                   // Carregando nVars de acordo
	nVal1 := If(SRI->RI_QTDSEM > 0, SRI->RI_QTDSEM, SRI->RI_HORAS)
	nVal2 := nValor
	nVal3 := 0
Endif

nRet := Ascan( aMatriz,{|X| x[1] == cCod } )   // Testa se ja existe
If	nRet == 0
	Aadd (aMatriz,{cCod,nVal1,nVal2,nVal3,1})  // se nao cria elemento
Else
	aMatriz[nRet,2] += nVal1                   // se ja so adiciona
	aMatriz[nRet,3] += nVal2
	aMatriz[nRet,4] += nVal3
	aMatriz[nRet,5] ++
Endif
Return Nil

*---------------------------*
Static Function fTestaTotal()      // Executa Quebras
*---------------------------*
Local cCusto

cFilAnterior := SRA->RA_FILIAL
If nOrdem # 4
	cCcAnt := SRA->RA_CC
	dbSelectArea( "SRA" )
	dbSkip()
Else
	If nRelat == 4 .or. If(cPaisLoc $ "URU|ARG",nRelat==3,.F.) 
		dbSelectArea("SRI")
	Else
		dbSelectArea( "SRC" )
	EndIf
	cCcAnt := cCcto
Endif

If lImpNiv .And. Len(aNiveis) > 0
	For nQ = 1 TO Len(aNiveis)
		cQ        := Str(nQ,1)
		cCcAnt&cQ := Subs(cCcAnt,1,aNiveis[nQ])
	Next nQ
Endif

If Eof() .Or. &cInicio > cFim
	cCusto := If (nOrdem # 4 ,SRA->RA_CC, if(nRelat==4,SRI->RI_CC,SRC->RC_CC))
	fImpCc()
	fImpNiv(cCcAnt,.T.)
	fImpFil()
	fImpEmp()
Elseif cFilAnterior # If (nOrdem # 4 ,SRA->RA_FILIAL,if(nRelat==4 , SRI->RI_FILIAL, SRC->RC_FILIAL)) 
	fImpCc()
	fImpNiv(cCcAnt,.T.)
	fImpFil()
Elseif cCcAnt # If (nOrdem # 4 ,SRA->RA_CC,if(nRelat==4 , SRI->RI_CC, SRC->RC_CC)) .And. !Eof()
	cCusto := If (nOrdem # 4 ,SRA->RA_CC, If(nRelat==4, SRI->RI_CC,SRC->RC_CC))
	fImpCc()
	fImpNiv(cCusto,.F.)
Endif

If nOrdem # 4
	dbSelectArea("SRA")
Else
	If nRelat == 4 .or. If(cPaisLoc $ "URU|ARG",nRelat==3,.F.)
		dbselectArea("SRI")
	Else
		dbSelectArea("SRC")
	EndIf
endif

Return Nil

*---------------------------------*
Static Function fImpFun(aFunP,aFunD,aFunB)            // Imprime um Funcionario
*---------------------------------*

If	Len(aFunP) == 0 .And. Len(aFunD) == 0 .And. Len(aFunB) == 0
	Return Nil
Endif

//-- Calculo % Acid. Trab. por Funcionario

If cEncInss == "N" .And. cPaisLoc == "BRA"
   fCalcAci(aFunB,aFunP,SRA->RA_FILIAL)
End   

If !lGeraSRZ .And. !lImpTot
	If cSinAna == "A"
		fImprime(aFunP,aFunD,aFunB,1)
	Endif              
EndIf

If lGeraSRZ .and. cEncInss == "S"
	fGrava(aFunP,aFunD,aFunB,1,SRA->RA_MAT)           // Gera Arquivo SRZ
Endif

aFunP := {}
aFunD := {}
aFunB := {}
Return Nil

*------------------*
Static Function fImpCc()             // Imprime Centro de Custo
*------------------*
Local nValBas := 0.00
Local nValAut := 0.00
Local nValPro := 0.00

If (Len(aCcP) == 0 .And. Len(aCcD) == 0 .And. Len(aCcB) == 0)
	
	// Zera variaveis do c.c. anterior
	aCcP := {}
	aCcD := {}
	aCcB := {}
	nCnor := nCafa := nCdem := nCfer := nCexc := nCtra := nCtot := nCinss := cCadm := 0
	
	Return Nil
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Resgata os valores utilizados na GPS         ³
//³que foram informados no parametro 15.        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if cTpc =="1"
	fCalcCompl("2",cCcAnt,.F.,nOrdem)
Endif

if cEncInss == "N"
	If nOrdem == 1 .Or. nOrdem == 4 .Or. nOrdem == 5
     	fCalcInss("2",cFilAnterior,cCcAnt)
	Endif
Endif
//--SomaToria para os Niveis de Quebra
If lImpNiv .And. Len(aNiveis) > 0
	For nQ:=1 To Len(aNiveis)
		cQ := Str(nQ,1)
		aEval(aCcP , { |X| fSomaNiv(aCcP&cQ,x[1],x[2],x[3],x[4],x[5]) } )
		aEval(aCcD , { |X| fSomaNiv(aCcD&cQ,x[1],x[2],x[3],x[4],x[5]) } )
		aEval(aCcB , { |X| fSomaNiv(aCcB&cQ,x[1],x[2],x[3],x[4],x[5]) } )
		nCnor&cQ  += nCnor
		nCafa&cQ  += nCafa
		nCdem&cQ  += nCdem
		nCfer&cQ  += nCfer
		nCexc&cQ  += nCexc
		nCtra&cQ  += nCtra
		nCtot&cQ  += nCtot
		nCadm&cQ  += nCadm		
	Next nQ
Endif

If lGeraSRZ
	fGrava(aCcP,aCcD,aCcB,2,"zzzzzz")           // Gera Arquivo SRZ
Else
	If !lUnicNV .And. !lImpTot
		If nOrdem == 1 .Or. nOrdem == 4 .Or. nOrdem == 5
			fImprime(aCcP,aCcD,aCcB,2) // Imprime
		Endif
	Endif
EndIf
aCcP := {}
aCcD := {}
aCcB := {}
nCnor := nCafa := nCdem := nCfer := nCexc := nCtra := nCtot := nCinss := nCadm := 0
Return Nil

*-----------------------------*
Static Function fImpNiv(cCusto,lGeral)             // Imprime Centro de Custo
*-----------------------------*
//-- Verifica se houve quebra dos Niveis de C.Custo
If nOrdem == 1 .Or. nOrdem == 4 .Or. nOrdem == 5
	If !lGeraSRZ .And. lImpNiv .And. Len(aNiveis) > 0
		For nQ := Len(aNiveis) to 1 Step -1
			cQ := Str(nQ,1)
			//-- Verifica se houve quebra dos Niveis de C.Custo
			If Subs(cCusto,1,aNiveis[nQ]) # cCcAnt&cQ .Or. lGeral
				If (Len(aCcP&cQ) # 0 .Or. Len(aCcD&cQ) # 0 .Or. Len(aCcB&cQ) # 0)
					fImprime(aCcP&cQ,aCcD&cQ,aCcB&cQ,5,cCcAnt&cQ,cQ)
					aCcP&cQ   := {}
					aCcD&cQ   := {}
					aCcB&cQ   := {}
					nCnor&cQ  := 0
					nCafa&cQ  := 0
					nCdem&cQ  := 0
					nCfer&cQ  := 0
					nCexc&cQ  := 0
					nCtra&cQ  := 0
					nCtot&cQ  := 0
					nCadm&cQ  := 0 
				Endif
			Endif
		Next nQ
	Endif
Endif

Return Nil

*-----------------------*
Static Function fImpFil()            // Imprime Filial
*-----------------------*
If	Len(aFilP) == 0 .And. Len(aFilD) == 0 .And. Len(aFilB) == 0
	Return Nil
Endif
               
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Resgata os valores utilizados na GPS         ³
//³que foram informados no parametro 15.        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if cTpc =="1"
	fCalcCompl("1","",.T.,nOrdem)
Endif

if cEncInss == "N"

	If nOrdem # 1 .And. nOrdem # 4 .And. nOrdem # 5
		fCalcInss("1",cFilAnterior)
	Endif
Endif
If lGeraSRZ
	fGrava(aFilP,aFilD,aFilB,3,"zzzzzz")
Else
	If lImpFil
		fImprime(aFilP,aFilD,aFilB,3)
	Endif
EndIf
aFilP := {}
aFilD := {}
aFilB := {}
nFnor := nFafa := nFdem := nFfer := nFexc := nFtra := nFtot := nFinss := nFAdm := 0
Return Nil

*------------------*
Static Function fImpEmp()            // Imprime Empresa
*------------------*
If Len(aEmpP) == 0 .And. Len(aEmpD) == 0 .And. Len(aEmpB) == 0
	Return Nil
Endif

If lGeraSRZ
	fGrava(aEmpP,aEmpD,aEmpB,4,"zzzzzz")
Else
	If lImpEmp
		fImprime(aEmpP,aEmpD,aEmpB,4)
	Endif
EndIf
aEmpP := {}
aEmpD := {}
aEmpB := {}
nEnor := nEafa := nEdem := nEfer := nEexc := nEtra := nEtot := nEinss := 0
nFuncs := 0
Return Nil

*-----------------------------------------------*
Static Function fImprime(aProv,aDesc,aBase,nTipo,cCt,cN)
*-----------------------------------------------*
// nTipo: 1- Funcionario
//        2- Centro de Custo
//        3- Filial
//        4- Empresa

Local nMaximo
Local nConta,nCon
Local nTVP := nTVD := nLIQ := 0   // Totais dos Valores
Local nTHP := nTHD := 0 		    // Referencias
Local cFil,cCc,cPd,nHrs,nVal,nOco
Local cCodFunc := ""
Local cDescFunc := ""

Private cNv := cN

aProv := ASort (aProv,,,{|x,y| x[1] < y[1] }) // Sorteando Arrays
aDesc := ASort (aDesc,,,{|x,y| x[1] < y[1] })
aBase := ASort (aBase,,,{|x,y| x[1] < y[1] })

nMaximo:= MAX(MAX(Len(aProv),Len(aDesc)),Len(aBase))
If	nTipo == 1
	If cQuebFun == "S"
	    If Li + nMaximo + 3 >= 65  // Testa somente quando e funcionario
			ImprFlh("","P")            // Salta Pagina caso nao caiba
		EndIf	
	Endif
Elseif nTipo == 2
	If lSalta
		ImprFlh("","P")
	Endif
Else
	ImprFlh("","P")
Endif

WCabec1 := STR0023+aInfo[3]+" "+If(nTipo#4,STR0027+cFilAnterior+" - "+aInfo[1],Space(26))+Space(23)+STR0024+If(cTpC$' *1',STR0025,STR0026)	//"Empresa: "###" Contrato do Tipo : "###"Indeterminado"###"Determinado"

If nTipo == 1
	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  ³ Carrega Funcao do Funcion. de acordo com a Dt Referencia     ³
	  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	fBuscaFunc(dDataRef,@cCodFunc, @cDescFunc ) // althoffe
	DET:= ALLTRIM(STR0028)		 //" C.CUSTO: "
	If cTipCC == 1              //-- Codigo
		Det:= Det + If (nOrdem # 4,Subs(SRA->RA_CC+Space(20),1,20),Subs(cCcto+Space(20),1,20))
	ElseIf cTipCC == 2          //-- Descricao
		Det:= Det + DescCc(If(nOrdem # 4,SRA->RA_CC,cCcto),cFilAnterior,18)
	ElseIf cTipCC == 3          //-- Ambos
		Det:= Det + AllTrim(Subs(If(nOrdem # 4,SRA->RA_CC,cCcto)+Space(20),1,20))+"-"+DescCc(If(nOrdem # 4,SRA->RA_CC,cCcto),cFilAnterior,20)
	Endif
	Det:= Det+STR0029+SRA->RA_MAT+STR0030+Subs(SRA->RA_NOME,1,30)+;									//" MAT.: "###" NOME: "
	      STR0031 + cCodFunc + " " + cDescFunc															 //" FUNCAO: "
Elseif nTipo == 2
	DET:= STR0032+cFilAnterior+STR0035+cCcAnt+DescCc(cCcAnt,cFilAnterior)		//"Filial: "###" C.CUSTO: "
Elseif nTipo == 3
	DET:= STR0033+cFilAnterior+" - "+aInfo[1]		//"Filial: "
Elseif nTipo == 4
	DET:= STR0034+aInfo[3]		//"Empresa: "
Elseif nTipo == 5
	If cCt # Nil
		DET:= STR0033+cFilAnterior+STR0035+cCt+" - "+DescCc(cCt,cFilAnterior)			//"Filial: "###" C.CUSTO: "
	Else
		DET:= STR0033+cFilAnterior+STR0035+cCcAnt+"-"+DescCc(cCcAnt,cFilAnterior)	//"Filial: "###" C.CUSTO: "
	Endif
Endif
ImprFlh(DET,"C")

If	nTipo == 1
	//--vERIFICA SE EXISTEW O CAMPO PARA IMPRESSAO
	If Type("SRA->RA_NOMECOM") # "U" .And. ! Empty(SRA->RA_NOMECOM)
		Det := 	STR0067+" "+SRA->RA_NOMECOM
		ImprFlh(DET,"C")	
	Endif	
	DET:= STR0036+Dtoc(SRA->RA_ADMISSA)+STR0037+fDesc("SX5","28"+SRA->RA_CATFUNC,"X5DESCRI()",12,SRA->RA_FILIAL)+" "
	If !Empty( cAliasMov )
		If cFolMes == MesAno( dDataRef )
			nValSal := SRA->RA_SALARIO
		Else
			nValSal := fBuscaSal(dDataRef,,,.f.)
		EndIf
	Else
		nValSal := SRA->RA_SALARIO
	EndIf
	DET+= STR0043+TRANSFORM(nValSal,"@E 999,999,999.99")+STR0044		//"SAL.: "###"  DEP.I.R.: "
	DET+= SRA->RA_DEPIR+STR0045+SRA->RA_DEPSF+Iif(nRelat<4,STR0046+StrZero(SRA->RA_PERCADT,3) + " %","")+" HR.MES: "	//"  DEP.SAL.FAM.: "###"  PERC.ADTO: "
	DET+= STR(SRA->RA_HRSMES,6,2)
Else
	Det:=" "
Endif
ImprFlh(DET,"C")
DET:= SPACE(15)+STR0047+SPACE(30)+STR0048+SPACE(30)+STR0049	//"P R O V E N T O S"###"D E S C O N T O S"###"B A S E S"
ImprFlh(DET,"C")

If cRefOco == 2 .And. cSinAna == "S"   //-- Ocorrencia
	Det := STR0050					//"COD DESCRICAO         OCOR.          VALOR PC|"
	Det += space(1)+STR0050		//"COD DESCRICAO         OCOR.          VALOR PC|"
	Det += space(1)+STR0051		//"COD DESCRICAO              VALOR OCOR."
Else
	Det := STR0052					//"COD DESCRICAO          REF.          VALOR PC|"
	Det += space(1)+STR0052		//"COD DESCRICAO          REF.          VALOR PC|"
	Det += space(1)+STR0053		//"COD DESCRICAO                VALOR"
Endif

ImprFlh(DET,"C")

If cRefOco == 2 .And. cSinAna == "S"   //-- Ocorrencia
	
	For nConta :=1 TO nMaximo
		Det:= If (nConta > Len(aProv),Space(45),aProv[nConta,1]+" "+Left(DescPd(aProv[nConta,1],If(nTipo = 1,SRA->RA_FILIAL,cFilAnterior)),14)+" "+;
		Transform(aProv[nConta,5],'99999999')+" "+Transform(aProv[nConta,3],'@E 999,999,999.99')+" "+StrZero(aProv[nConta,4],2))+"| "
		Det +=If (nConta > Len(aDesc),Space(45),aDesc[nConta,1]+" "+Left(DescPd(aDesc[nConta,1],If(nTipo = 1,SRA->RA_FILIAL,cFilAnterior)),14)+" "+;
		Transform(aDesc[nConta,5],'99999999')+" "+Transform(aDesc[nConta,3],'@E 999,999,999.99')+" "+StrZero(aDesc[nConta,4],2))+"| "
		Det +=If (nConta > Len(aBase),Space(36),aBase[nConta,1]+" "+Left(DescPd(aBase[nConta,1],If(nTipo = 1,SRA->RA_FILIAL,cFilAnterior)),14)+" "+;
		Transform(aBase[nConta,3],'@E 99,999,999.99')+" "+Transform(aBase[nConta,5],'@E 99999'))
		ImprFlh(Det,"C")
	Next
	
Else
	
	For nConta :=1 TO nMaximo
		Det:= If (nConta > Len(aProv),Space(46),aProv[nConta,1]+" "+Left(DescPd(aProv[nConta,1],If(nTipo = 1,SRA->RA_FILIAL,cFilAnterior)),14)+" "+;
				Transform(aProv[nConta,2],'999999.99')+" "+Transform(aProv[nConta,3],'@E 999,999,999.99')+" "+StrZero(aProv[nConta,4],2))+"| "
		Det +=If (nConta > Len(aDesc),Space(46),aDesc[nConta,1]+" "+Left(DescPd(aDesc[nConta,1],If(nTipo = 1,SRA->RA_FILIAL,cFilAnterior)),14)+" "+;
				Transform(aDesc[nConta,2],'999999.99')+" "+Transform(aDesc[nConta,3],'@E 999,999,999.99')+" "+StrZero(aDesc[nConta,4],2))+"| "
		Det +=If (nConta > Len(aBase),Space(37),aBase[nConta,1]+" "+Left(DescPd(aBase[nConta,1],If(nTipo = 1,SRA->RA_FILIAL,cFilAnterior)),14)+"  "+;
				Transform(aBase[nConta,3],'@E 999,999,999.99'))
		ImprFlh(Det,"C")
	Next
	
Endif

AeVal(aProv,{ |X| nTHP += X[2]})	// Acumula Referencias
AeVal(aDesc,{ |X| nTHD += X[2]})
AeVal(aProv,{ |X| nTVP += X[3]})	// Acumula Valores
AeVal(aDesc,{ |X| nTVD += X[3]})

nLIQ := nTVP - nTVD
DET  := REPLICATE("-",132)
ImprFlh(DET,"C")

DET :=STR0054+If(cRefOco == 2 .and. cSinAna == "S",SPACE(5) ,SPACE(06))             +TRANSFORM(nTHP,"9999999999.99")+" "+TRANSFORM(nTVP,"@E 999,999,999.99")+;	//"TOTAIS ->"
      SPACE(20)                                                                       +TRANSFORM(nTHD,"9999999999.99")+" "+TRANSFORM(nTVD,"@E 999,999,999.99")+;
              If(cRefOco ==2 .and. cSinAna == "S" ,SPACE(09),SPACE(12) )+STR0062+" "+TRANSFORM(nLIQ,"@E 999,999,999.99")					//"SALARIO LIQ."
ImprFlh(DET,"C")

DET:=REPLICATE("-",132)
ImprFlh(DET,"C")

If nTipo # 1
	Det:=STR0055+Strzero(If(nTipo==2,nCnor,If(nTipo==3,nFnor,If (nTipo==4,nEnor,nCnor&cNv))),5)		//"Sit.Normal: "
	Det+=STR0068+Strzero(If(nTipo==2,nCadm,If(nTipo==3,nFadm,If (nTipo==4,nEadm,nCadm&cNv))),5)		//" Admitidos: "	
	Det+=STR0056+Strzero(If(nTipo==2,nCafa,If(nTipo==3,nFafa,If (nTipo==4,nEafa,nCafa&cNv))),5)		//" Afastados: "
	Det+=STR0057+Strzero(If(nTipo==2,nCdem,If(nTipo==3,nFdem,If (nTipo==4,nEdem,nCdem&cNv))),5)		//" Demitidos:"
	Det+=STR0058+Strzero(If(nTipo==2,nCfer,If(nTipo==3,nFfer,If (nTipo==4,nEfer,nCfer&cNv))),5)		//" Ferias:"
	Det+=STR0059+Strzero(If(nTipo==2,nCtra,If(nTipo==3,nFtra,If (nTipo==4,nEtra,nCtra&cNv))),5)		//" Transferidos:"
	Det+=STR0060+Strzero(If(nTipo==2,nCexc,If(nTipo==3,nFexc,If (nTipo==4,nEexc,nCexc&cNv))),5)		//" Outros C.Custo:"
	Det+=STR0061+Strzero(If(nTipo==2,nCtot,If(nTipo==3,nFtot,If (nTipo==4,nEtot,nCtot&cNv))),5)		//" Total:"
	
	Impr (Det,"C")
	ImprFlh(REPL("=",132),"C")   // Salta Pagina apos Quebra Cc/Filial/Empresa
	If nTipo # 2 .Or. (nTipo == 2 .And. lSalta)
		ImprFlh("","P")
	Else
		ImprFlh("","C")
	Endif
Endif

Return Nil

*------------------------------------*
Static Function fGrava(aProv,aDesc,aBase,nTipo,cMat) // Grava Guia de Inss
*------------------------------------*
Local  nMaximo
Local  nConta,nCon
Local cFil,cCc,cPd,nHrs,nVal,nOco
Private aArray:={aProv,aDesc,aBase}  // Controlador de Arrays

nMaximo:= MAX(MAX(Len(aProv),Len(aDesc)),Len(aBase))

FOR nConta :=1 TO nMaximo
	dbSelectArea( "SRZ" )
	
	If nTipo == 1                  
		M->RZ_FILIAL := cFilAnterior
		M->RZ_CC     := cCcto
	Elseif nTipo == 2
		M->RZ_FILIAL := cFilAnterior
		M->RZ_CC     := cCcAnt
	Elseif nTipo == 3
		M->RZ_FILIAL := cFilAnterior
		M->RZ_CC     := "zzzzzzzzz"
	Elseif nTipo == 4
		M->RZ_FILIAL := "zz"
		M->RZ_CC     := "zzzzzzzzz"
	Endif
	
	For nCon := 1 To 3
		If nConta <= Len(aArray[nCon])
			RecLock("SRZ",.T.)
			SRZ->RZ_FILIAL  := M->RZ_FILIAL
			SRZ->RZ_CC      := M->RZ_CC
			SRZ->RZ_PD      := aArray[nCon,nConta,1] // usa o Controlador
			SRZ->RZ_HRS     := aArray[nCon,nConta,2]
			SRZ->RZ_VAL     := aArray[nCon,nConta,3]
			SRZ->RZ_OCORREN := aArray[nCon,nConta,5]
			SRZ->RZ_TPC     := cTpC
			SRZ->RZ_TIPO    := If(nRelat==4,"13","FL")
			If Type("SRZ->RZ_MAT") # "U"
				SRZ->RZ_MAT     := cMat
			Endif		
			MsUnlock()
		Endif
	Next
Next

If nTipo <> 1
	RecLock("SRZ",.T.)
	If nTipo == 2
		SRZ->RZ_FILIAL  := cFilAnterior
		SRZ->RZ_CC      := cCcAnt
		SRZ->RZ_OCORREN := nCinss
	Elseif nTipo == 3
		SRZ->RZ_FILIAL  := cFilAnterior
		SRZ->RZ_CC      := "zzzzzzzzz"
		SRZ->RZ_OCORREN := nFinss 
	Elseif nTipo == 4
		SRZ->RZ_FILIAL  := "zz"
		SRZ->RZ_CC      := "zzzzzzzzz"
		SRZ->RZ_OCORREN := nEinss 
	Endif
	SRZ->RZ_PD   := "zzz"
	SRZ->RZ_TPC  := cTpC					  // grava tipo de contrato
	SRZ->RZ_TIPO := If(nRelat==4,"13","FL") // grava tipo de lacto contabil
	If TYPE("SRZ->RZ_MAT") # "U"
		SRZ->RZ_MAT  := cMat
	Endif	
	MsUnlock()
Endif	
dbSelectArea( "SRA" )
Return Nil

*------------------------------------------*
Static Function fCalcInss(cTipo,cFil,cCusto)
*------------------------------------------*
Local nValBas  := 0.00
Local nValAut  := 0.00
Local nValPro  := 0.00
Local nValCus  := 0.00
Local nPercPro := 0.00
Local nPercAut := 0.00
Local lCct     := If (cCusto # Nil,.T.,.F.)
Local nPercFPAS:=0
Local nBasePis := 0.00
Local nValPis  := 0.00
Local nBsFisJur:= 0.00

// Verifica o % de Acidente do C.Custo
If lCct
	dbSelectArea("SI3")
	If ( cFil # Nil .And. cFilial == "  " ) .Or. cFil == Nil
		cFil := cFilial
	Endif
	nPercFPAS := 0
	If dbSeek( cFil + cCusto )
		nPercFPAS    := SI3->I3_PERFPAS / 100
	Endif
	
	If nPercFPAS > 0
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Deducao do percentual pago por convenios                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nDed := 0
		For nPerc = 9 TO 19
			nDed += aInssEmp[nPerc,Val(cTpc)]
		Next
		
		nDed += aInssEmp[22,Val(cTpc)]
		nDed += aInssEmp[23,Val(cTpc)]
		nDed += fP15Terc(cCusto,aGPSPer,"*") //Deduzir o % de terceiros do parametro 15
		
		nPercFPAS -= nDed
	Endif
	
Endif
//-- Montar a Base Total de Inss
If cTipo == "1"
	aEval(aFilB,{ |x| nValBas += If ( X[1]$ cContribuicao ,x[3],0.00) })
Else
	aEval(aCcB,{ |x| nValBas += If ( X[1]$ cContribuicao ,x[3],0.00) })
EndIf
//-- Montar a Base Total de Inss Diferenca Dissidio
//If cTipo == "1"
//	aEval(aFilP,{ |x| nValBas += If ( X[1]$ aCodFol[341,1]+"*"+aCodFol[402,1] ,x[3],0.00) })
//Else
//	aEval(aCcP,{ |x| nValBas += If ( X[1]$ aCodFol[341,1]+"*"+aCodFol[402,1] ,x[3],0.00) })
//EndIf
//--Inss s/Prolabore e Autonomo
If aCodfol[221,1] # Space(3)
	If cTipo == "1"
		aEval(aFilB,{ |x| nValPro += If ( X[1]$ aCodFol[221,1] ,x[3],0.00) })
	else
		aEval(aCcB,{ |x| nValPro += If ( X[1]$ aCodFol[221,1] ,x[3],0.00) })
	EndIf
	nPercPro := PosSrv( aCodFol[221,1],cFilAnterior,"RV_PERC") / 100
	If nPercPro = 1.00 .Or. (nPercPro = 0.00 .And. aInssemp[1,Val(cTpc)] > 0.00)
		nPercPro := 0.20
	Endif
	nValPro := Round(nValPro * nPercPro,2)
Endif
If aCodFol[225,1] # Space(3)
	If cTipo == "1"
		aEval(aFilB,{ |x| nValAut += If ( X[1]$ aCodfol[225,1] ,x[3],0.00) })
	else
		aEval(aCcB,{ |x| nValAut += If ( X[1]$ aCodfol[225,1] ,x[3],0.00) })
	EndIf	
	nPercAut	 := PosSrv( aCodFol[225,1],cFilAnterior,"RV_PERC") / 100
	If nPercAut = 1.00 .Or. (nPercAut = 0.00 .And. aInssemp[1,Val(cTpc)] > 0.00)
		nPercAut := 0.20
	Endif
	nValAut := Round(nValAut * nPercAut,2)
Endif
If aCodFol[350,1] # Space(3) //Base de INSS Ref. Servicos Prestados Pessoa Fisica
	nBsFisJur := 0.00
	If cTipo == "1"
		aEval(aFilB,{ |x| nBsFisJur += If ( X[1]$ aCodfol[350,1] ,x[3],0.00) })
	else
		aEval(aCcB,{ |x| nBsFisJur += If ( X[1]$ aCodfol[350,1] ,x[3],0.00) })
	EndIf	
	nPercAut	 := PosSrv( aCodFol[350,1],cFilAnterior,"RV_PERC") / 100
	If nPercAut = 1.00 .Or. (nPercAut = 0.00 .And. aInssemp[1,Val(cTpc)] > 0.00)
		nPercAut := 0.20
	Endif
	nValAut += Round(nBsFisJur * nPercAut,2)
Endif
If aCodFol[353,1] # Space(3) //Base de INSS Ref. Servicos Prestados Pessoa Juridica
	nBsFisJur := 0.00
	If cTipo == "1"
		aEval(aFilB,{ |x| nBsFisJur += If ( X[1]$ aCodfol[353,1] ,x[3],0.00) })
	else
		aEval(aCcB,{ |x| nBsFisJur += If ( X[1]$ aCodfol[353,1] ,x[3],0.00) })
	EndIf	
	nPercAut	 := PosSrv( aCodFol[353,1],cFilAnterior,"RV_PERC") / 100
	If nPercAut = 1.00 .Or. (nPercAut = 0.00 .And. aInssemp[1,Val(cTpc)] > 0.00)
		nPercAut := 0.20
	Endif
	nValAut += Round(nBsFisJur * nPercAut,2)
Endif
//--Gravar Inss Empresa Sobre Pro-Labore/Autonomo
If nValAut+nValPro > 0
	fSomaInss(cTipo,aCodFol[148,1],nValAut+nValPro )  // Inss Emp.
Endif

//-- Montar Base de Calculo do Pis Empresa
If aCodFol[229,1] # Space(3)
	aEval(aCcP,{ |x| nBasePis += If ( PosSrv(X[1],cFilAnterior,"RV_PIS")=="S",x[3],0.00) })
	aEval(aCcB,{ |x| nBasePis += If ( PosSrv(X[1],cFilAnterior,"RV_PIS")=="S" .and. PosSrv(X[1],cFilAnterior,"RV_TIPOCOD")=="3",x[3],0.00) } )
	aEval(aCcD,{ |x| nBasePis -= If ( PosSrv(X[1],cFilAnterior,"RV_PIS")=="S",x[3],0.00) })
	If nBasePis > 0
		nPercPis  := PosSrv( aCodFol[229,1],cFilAnterior,"RV_PERC") / 100
		nValPis   := nBasePis * nPercPis
	Endif
	//--Gerar Base e Valor Pis Empresa
	If nValPis > 0
		fSomaInss(cTipo,aCodFol[223,1],nBasePis)
		If aCodFol[229,1] # Space(3)
			fSomaInss(cTipo,aCodFol[229,1],nValPis)
		Endif
	Endif
Endif

//-- Calcular Inss Empresa
If nValBas > 0.00
	fSomaInss(cTipo,aCodFol[148,1],Round(nValBas * aInssemp[1,Val(cTpc)],2) )  // Inss Emp.
	fSomaInss(cTipo,aCodFol[149,1],Round(nValBas * If (nPercFPAS > 0, nPercFPAS ,aInssemp[2,Val(cTpc)]),2)  )  // Terceiros
	//	fSomaInss(cTipo,aCodFol[150,1],Round(nValBas * If (lCct,aInssEmp[21,Val(cTpc)],aInssEmp[3,Val(cTpc)]),2) )  // Ac.Trab.
	fSomaInss(cTipo,aCodFol[204,1],Round(nValBas * (aInssemp[09,Val(cTpc)]+fP15Terc(cCusto,aGPSPer,aCodFol[204,1])),2)  ) // Sal.Educ.
	fSomaInss(cTipo,aCodFol[184,1],Round(nValBas * (aInssemp[10,Val(cTpc)]+fP15Terc(cCusto,aGPSPer,aCodFol[184,1])),2) )  // Incra
	fSomaInss(cTipo,aCodFol[185,1],Round(nValBas * (aInssemp[11,Val(cTpc)]+fP15Terc(cCusto,aGPSPer,aCodFol[185,1])),2) )  // Senai
	fSomaInss(cTipo,aCodFol[186,1],Round(nValBas * (aInssemp[12,Val(cTpc)]+fP15Terc(cCusto,aGPSPer,aCodFol[186,1])),2) )  // Sesi
	fSomaInss(cTipo,aCodFol[187,1],Round(nValBas * (aInssemp[13,Val(cTpc)]+fP15Terc(cCusto,aGPSPer,aCodFol[187,1])),2) )  // Senac
	fSomaInss(cTipo,aCodFol[188,1],Round(nValBas * (aInssemp[14,Val(cTpc)]+fP15Terc(cCusto,aGPSPer,aCodFol[188,1])),2) )  // Sesc
	fSomaInss(cTipo,aCodFol[189,1],Round(nValBas * (aInssemp[15,Val(cTpc)]+fP15Terc(cCusto,aGPSPer,aCodFol[189,1])),2) )  // Sebrae
	fSomaInss(cTipo,aCodFol[190,1],Round(nValBas * (aInssemp[16,Val(cTpc)]+fP15Terc(cCusto,aGPSPer,aCodFol[190,1])),2) )  // Dpc
	fSomaInss(cTipo,aCodFol[191,1],Round(nValBas * (aInssemp[17,Val(cTpc)]+fP15Terc(cCusto,aGPSPer,aCodFol[191,1])),2) )  // Faer
	fSomaInss(cTipo,aCodFol[192,1],Round(nValBas * (aInssemp[18,Val(cTpc)]+fP15Terc(cCusto,aGPSPer,aCodFol[192,1])),2) )  // Senab
	fSomaInss(cTipo,aCodFol[193,1],Round(nValBas * (aInssemp[19,Val(cTpc)]+fP15Terc(cCusto,aGPSPer,aCodFol[193,1])),2) )  // Seconc
	fSomaInss(cTipo,aCodFol[200,1],Round(nValBas * (aInssemp[22,Val(cTpc)]+fP15Terc(cCusto,aGPSPer,aCodFol[200,1])),2) )  // Sest
	fSomaInss(cTipo,aCodFol[201,1],Round(nValBas * (aInssemp[23,Val(cTpc)]+fP15Terc(cCusto,aGPSPer,aCodFol[201,1])),2) )  // Senat
Endif

// Montar Base Para Provisao Simplificada Ferias /  13o / Rescisao
aEval(aCcP,{ |x| nValCus += If ( PosSrv( x[1],cFilAnterior,"RV_CUSTO")='S',x[3],0.00) })
aEval(aCcD,{ |x| nValCus -= If ( PosSrv( x[1],cFilAnterior,"RV_CUSTO")='S',x[3],0.00) })
aEval(aCcB,{ |x| nValCus += If ( PosSrv( x[1],cFilAnterior,"RV_CUSTO")='S',x[3],0.00) })

// Calcular Provisao Simplificada
If nValCus > 0.00
	fSomaInss(cTipo,aCodFol[194,1],nValCus * aInssemp[6,Val(cTpc)] )  // Prov. Ferias
	fSomaInss(cTipo,aCodFol[195,1],nValCus * aInssemp[5,Val(cTpc)] )  // Prov. 13o.
	fSomaInss(cTipo,aCodFol[196,1],nValCus * aInssemp[20,Val(cTpc)] )  // Prov. Rescisao
Endif
Return

*-----------------------------------------*
Static Function fSomaInss(cTipo,cCod,nVal2)
*-----------------------------------------*
If cCod # Space(3) .And. nVal2 # 0
	If cTipo = "2"
		// Array Centro de Custo
		nRet := aScan( aCcB,{|X| x[1] == cCod } )   // Testa se ja existe
		If nRet == 0
			Aadd(aCcB,{cCod,0.00,nVal2,0.00,1})      // se nao cria elemento
		Else
			aCcB[nRet,3] += nVal2
			aCcB[nRet,5] ++
		Endif
	Endif
	If cTipo = "2" .Or. cTipo = "1"
		//-- Array Filial
		nRet := aScan( aFilB,{|X| x[1] == cCod } )   // Testa se ja existe
		If nRet == 0
			Aadd(aFilB,{cCod,0.00,nVal2,0.00,1})      // se nao cria elemento
		Else
			aFilB[nRet,3] += nVal2
			aFilB[nRet,5] ++
		Endif
		//-- Array Empresa
		nRet := aScan( aEmpB,{|X| x[1] == cCod } )   // Testa se ja existe
		If nRet == 0
			Aadd(aEmpB,{cCod,0.00,nVal2,0.00,1})      // se nao cria elemento
		Else
			aEmpB[nRet,3] += nVal2
			aEmpB[nRet,5] ++
		Endif
	Endif
Endif
Return

*--------------------------------------*
static Function fSomaNiv(aMatriz,cVerba,nHorCc,nValCc,nParCc,nQtdCc)
*--------------------------------------*
// 1- Matriz onde os dados estao sendo armazenados
// 2- elemrnto a ser somado

Local nRet
nRet := Ascan( aMatriz,{|X| x[1] == cVerba } )   // Testa se ja existe
If	nRet == 0
	Aadd (aMatriz,{cVerba,nHorCc,nValCc,nParCc,nQtdCc})  // se nao cria elemento
Else
	aMatriz[nRet,2] += nHorCc                   // se ja so adiciona
	aMatriz[nRet,3] += nValCc
	aMatriz[nRet,4] += nParCc
	aMatriz[nRet,5] += nQtdCc
Endif
Return Nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao para Escolher o Arquivo Mensal                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*--------------------------------*
static Function fArquivoRC()
*--------------------------------*
Local MvRet,ni
Local nOpcao := 0, nOk := 2
Local oDlg, oWnd, oListbox
Local cVarq
Local nPosLis := 1
nLin1   := .5
nCol1   := 2
cFiltro := "RC*" + GetDBExtension()          //Filtro na procura do arquivo no Windows
cPesq   := "SRC"              //Arquivo de pesquisa no SX2
cPath   := ""
#IFDEF TOP
	Private aTables := {}
	Private oOk   := LoadBitmap( GetResources(), "LBOK" )  //Botao OK
	Private oNo   := LoadBitmap( GetResources(), "LBNO" )  //Botao CANCEL
#ELSE
	cAlias := Alias()
	dbSelectArea( "SX2" )
	dbSeek(cPesq)
	cPath := TRIM(Sx2->X2_PATH)
#ENDIF

MvRet:=Alltrim(ReadVar())      // Carrega Nome da Variavel do Get em Questao

#IFDEF TOP
	USE TOP_FILES ALIAS "TOP" VIA "TOPCONN" SHARED NEW
	nTables := 0
	While !Eof()
		If SubS(FNAMF1,1,4) # "TOP_" .AND. SubS(FNAMF1,1,2) == "RC"
			nTables++
			If nTables < 4096
				AADD(aTables,FNAMF1)
			Else
				Alert("Too many tables.","Attention")
				Exit
			Endif
		Endif
		dbSkip()
	EndDo
	dbCloseArea()
	ASORT(aTables,,, { |x, y| x > y })
	If Len(aTables) # 0
		DEFINE MSDIALOG oDlg FROM 5, 5 TO 16, 39 TITLE STR0065
		@ nLin1,nCol1 LISTBOX oListBox VAR cVarQ Fields HEADER STR0064 SIZE 102,60 ;
		ON DBLCLICK (nOk := 1,oDlg:End()) ENABLE OF oDlg
		oListBox:SetArray(aTables)
		oListBox:bLine := { ||{aTables[oListBox:nAt]}}
		DEFINE SBUTTON FROM 068,62 TYPE 1 ACTION (nOk := 1,nPosLis:=oListBox:nAt,oDlg:End()) ENABLE OF oDlg
		DEFINE SBUTTON FROM 068,90 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
		ACTIVATE MSDIALOG oDlg CENTERED
		If nOk == 1
			&MvRet := aTables[nPosLis]
		Else
			&MvRet := SPACE(30)  // Devolve Resultados
		EndIf
		DeleteObject(oOk)
		DeleteObject(oNo)
	Else
		Help(" " , 1 , "GPSARQM" )
		&MvRet := SPACE(30)  // Devolve Resultado
		Return .T.
	EndIf
#ELSE
	If cFiltro == Nil
		oWnd := GetWndDefault()
	Endif
	cFile := cGetFile(cFiltro,OemToAnsi(STR0065) ) //"Selecione o Arquivo"
	If Empty(cFile)
		Return(.F.)
	Elseif Len(Alltrim(cFile)) > 30
		Help(" " , 1 , "GP140TAMAN" )
	Endif
	&MvRet := cFile+SPACE(30-LEN(cFile))
	If oWnd != Nil
		GetdRefresh()
	Endif
#ENDIF

Return .T.

******************************
Static Function fCalcAci(aFunB,aFunP,cFil)
******************************
Local nBasAci := 0
Local nValAci := 0
Local lPercSRA := .F.

//-- Calculo do % Acid. de Trabalho Por Funcionario / C.Custo ou Filial
nPercAci := aInssEmp[3,Val(cTpc)]  //-- Ac.Trab.
If Type("SRA->RA_PERCSAT") # "U" .And. SRA->RA_PERCSAT > 0
	nPercAci := SRA->RA_PERCSAT / 100
	lPercSRA := .T.
Else
	//-- Verifica o % de Acidente do C.Custo
	dbSelectArea("SI3")
	If ( cFil # Nil .And. cFilial == "  " ) .Or. cFil == Nil
		cFil := cFilial
	Endif
	If dbSeek( cFil + cCCto ) .And. SI3->I3_PercAci > 0
		nPercAci := SI3->I3_PercAci / 100
	Endif
Endif

//--Montar a Base Total de Inss
If SRA->RA_CATFUNC $ "P*A" .And. lPercSRA
	aEval(aFunP,{ |x| nBasAci += If ( X[1]$ cContrProAuto ,x[3],0.00) })
Else
	aEval(aFunB,{ |x| nBasAci += If ( X[1]$ cContribuicao ,x[3],0.00) })
EndIf
nValAci := Round(nBasAci * nPercAci,2)

If nValAci # 0
	fSoma(@aFunB,"C",aCodFol[150,1],nValAci)
	fSoma(@aCcB ,"C",aCodFol[150,1],nValAci)
	fSoma(@aFilB,"C",aCodFol[150,1],nValAci)
	fSoma(@aEmpB,"C",aCodFol[150,1],nValAci)
Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fBuscaSlr ³ Autor ³ R.H. - Marina         ³ Data ³ 14.01.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica se houve aumento salarial em Movimentos Anteriores³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fBuscaSlr(Filial,Matricula,Data)                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
static Function fBuscaSlr(nValSal,cAnoMesRef)
Local cAlias := Alias()

dbSelectArea("SR3")
If dbSeek(SRA->RA_FILIAL + SRA->RA_MAT)
	While !Eof() .And. SR3->R3_FILIAL+SR3->R3_MAT == SRA->RA_FILIAL+SRA->RA_MAT .And.;
		MesAno(SR3->R3_DATA) <= cAnoMesRef
		nValSal := SR3->R3_VALOR
		dbSkip()
	Enddo
EndIf
dbSelectArea(cAlias)
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fImpGerFol³ Autor ³ R.H.                  ³ Data ³ 14.01.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime a folha ou gera o arquivo SRZ.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ 	fImpGerFol(lEnd,cAnoMesRef)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
static Function fImpGerFol(lEnd,cAnoMesRef)
Local lInssFun    := .F.
Local aFunP       := {}
Local aFunD   	  := {}
Local aFunB   	  := {}
Local aCodBenef   := {}
Local cBuscaSRA   := ""
Local cBuscaSRI   := ""
Local cAcessaSRA  := &("{ || " + ChkRH("GPER040","SRA","2") + "}")
Local cAcessaSRC  := &("{ || " + ChkRH("GPER040","SRC","2") + "}")
Local cAcessaSRI  := &("{ || " + ChkRH("GPER040","SRI","2") + "}")
Local cTipAfas    := " "
Local dDtAfas
Local dDtRet
Local dDtPesqAf
Local lCotFun	   := .F.

Private aGPSVal := {}
Private aGPSPer := {} // Carrega os percentuais de terceiros do parametro 15

dbSelectArea( "SRA" )
dbGoTop()

If nOrdem == 1
	dbSetOrder( 2 )
	dbSeek(cFilDe + cCcDe + cMatDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT"
	cFim     := cFilAte + cCcAte + cMatAte
ElseIf nOrdem == 2
	dbSetOrder( 1 )
	dbSeek(cFilDe + cMatDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_MAT"
	cFim     := cFilAte + cMatAte
ElseIf nOrdem == 3
	dbSetOrder( 3 )
	dbSeek(cFilDe + cNomDe + cMatDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_NOME + SRA->RA_MAT"
	cFim     := cFilAte + cNomAte + cMatAte
ElseIf nOrdem == 4
	If nRelat == 4 .or. If(cPaisLoc $ "URU|ARG",nRelat==3,.F.)
		dbSelectarea("SRI")
		dbSetOrder(2)
		dbSeek(cFilDe + cCcDe + cMatDe,.T.)
		cInicio := "SRI->RI_FILIAL + SRI->RI_CC+ SRI->RI_MAT"
		cFim    := cFilAte + cCcAte + cMatAte
	Else
		dbSelectArea("SRC")
		dbSetOrder( 2 )
		dbSeek(cFilDe + cCcDe + cMatDe,.T.)
		cInicio  := "SRC->RC_FILIAL + SRC->RC_CC + SRC->RC_MAT"
		cFim     := cFilAte + cCcAte + cMatAte
	EndIf
ElseIf nOrdem == 5
	dbSetOrder( 8 )
	dbSeek(cFilDe + cCcDe + cNomDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_NOME"
	cFim     := cFilAte + cCcAte + cNomAte
Endif

dbSelectArea( "SRA" )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega Regua de Processamento                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lGeraSRZ
	ProcRegua(SRA->(RecCount()))
Else
	SetRegua(SRA->(RecCount()))
EndIf

cFilAnterior := Space(02)
cCcAnt  	 := Space(09)

nEnor := nEafa := nEdem := nEfer := nEexc := nEtra := nEtot := nEadm := 0  // Totalizadores Empresa
nFnor := nFafa := nFdem := nFfer := nFexc := nFtra := nFtot := nFadm := 0  //               Filial
nCnor := nCafa := nCdem := nCfer := nCexc := nCtra := nCtot := nCadm := 0  //               Centro Custo
nCinss := nFinss := nEinss := 0      //-Totalizador dos func. con ret. Inss
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Estas variaveis nao devem, se declaradas, pois devem ser     ³
//³ declaradas na funcao chamadora.(pode ser externa).           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nFuncs 		:= 0
aFuncsBSE	:=	{}
If nOrdem # 4
	dbSelectArea( "SRA" )
Else // Encargos por  C.Custo
	If nRelat ==4 .or. If(cPaisLoc $ "URU|ARG",nRelat==3,.F.)
		dbselectArea("SRI")		// 2a parcela 13o Salario
	Else
		dbSelectArea( "SRC" )
	EndIf
Endif

While !EOF() .And. &cInicio <= cFim
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Movimenta Regua de Processamento                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lGeraSRZ
		IncProc()
	Else
		IncRegua()
	EndIf
	
	If lEnd
		@Prow()+1,0 PSAY cCancel
		Exit
	Endif
	
	If nOrdem == 4      // Encargos por C.Custo
		dbSelectArea( "SRA" )
		dbSetOrder(1)
		If nrelat ==4.or. If(cPaisLoc $ "URU|ARG",nRelat==3,.F.)
			dbSeek(SRI->RI_FILIAL + SRI->RI_MAT)
			cCcto :=  SRI->RI_CC
		else
			dbSeek( SRC->RC_FILIAL + SRC->RC_MAT )
			cCcto := SRC->RC_CC
		endif
		
		//-------------
		If Eof()
			cCcto := " "
			If nRelat == 4 .or. If(cPaisLoc $ "URU|ARG",nRelat==3,.F.)
				dbSelectArea("SRI")
			Else
				dbSelectArea("SRC")
			EndIf
			dbSkip()
			
			fTestaTotal()
			Loop
		Endif
		//-------------
	Else
		cCcto := SRA->RA_CC
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica Quebra de Filial                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SRA->RA_FILIAL # cFilAnterior
		If cPaisloc == "BRA"
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Resgata Valores utilizados na GPS que estao armazenados no Parametro 15 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
			fGPSVal(SRA->RA_FILIAL,cAnoMesRef,@aGPSVal)
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Resgata os percentuais de terceiros armazenados no parametro 15			³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
			fGPSVal(SRA->RA_FILIAL,"999999",@aGPSPer)
		Endif
		If cFilAnterior # "  " .And. nOrdem == 4
			fImpFil()    // Totaliza Filial
		Endif
		If !FP_CODFOL(@aCodFol,Sra->Ra_Filial) .Or. !fInfo(@aInfo,Sra->ra_Filial)
			Exit
		Endif
		If cFilAnterior # "  " .And. nOrdem # 4
			fImpFil()    // Totaliza Filial
		Endif
		cFilAnterior := SRA->RA_FILIAL
		
		If cPaisLoc == "BRA" .And. !fInssEmp(SRA->RA_FILIAL,@aInssEmp)
			Exit
		Endif
		cContribuicao := aCodFol[013,1]+"x"+aCodFol[014,1]+"x"+aCodFol[19,1]+"x"+aCodFol[20,1]+"x"+aCodFol[338,1]+"x"+aCodFol[399,1]
		cContrProAuto := aCodFol[217,1]+"x"+aCodFol[218,1]+"x"+aCodFol[349,1]+"x"+aCodFol[352,1]

	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste Parametrizacao do Intervalo de Impressao            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( SRA->RA_NOME < cNomDe )  .Or. ( SRA->RA_NOME > cNomAte ) .Or. ;
		( SRA->RA_MAT < cMatDe )   .Or. ( SRA->RA_MAT > cMatAte )
		If nOrdem = 4   // Ordem do Arquivo Movimento "SRC".
			If nRelat == 4 .or. If(cPaisLoc $ "URU|ARG",nRelat==3,.F.)
				dbSelectArea("SRI")
			Else
				dbSelectArea("SRC")
			EndIf
			dbSkip()
		Endif
		fTestaTotal()
		Loop
	Endif
	
	If (nOrdem # 4 .And. ((SRA->RA_CC < cCcDe) .Or. (SRA->RA_CC > cCcAte))) .Or.;
		(nOrdem == 4 .And. nRelat  # 4 .And. ((SRC->RC_CC < cCcDe) .Or. (SRC->RC_CC > cCcAte))).Or.;
		(nOrdem == 4 .And. nRelat == 4 .And. ((SRI->RI_CC < cCcDe) .Or. (SRI->RI_CC > cCcAte)))
		If nOrdem == 4   // Ordem do Arquivo Movto.
			If nRelat == 4 .or. If(cPaisLoc $ "URU|ARG",nRelat==3,.F.)
				dbSelectArea("SRI")
			Else
				dbSelectArea("SRC")
			EndIf
			dbSkip()
		Endif
		fTestaTotal()
		Loop
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o tipo de Afastamentono mes que esta sendo listado ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cTipAfas := " "
	dDtAfas  := dDtRet := ctod("")
	dDtPesqAf:= CTOD("01/" + Right(cAnoMesRef,2) + "/" + Left(cAnoMesRef,4),"DDMMYY")
	fChkAfas(SRA->RA_FILIAL,SRA->RA_MAT,dDtPesqAf,@dDtAfas,@dDtRet,@cTipAfas)
	If cTipAfas $"HIJKLMNSU234" .Or.;
		(!Empty(SRA->RA_DEMISSA) .And. MesAno(SRA->RA_DEMISSA)<= MesAno(dDtPesqAf))
		cTipAfas := "D"
	Elseif cTipAfas $"OPQRXYV8W1"
		cTipAfas := "A"
	ElseIf cTipAfas == "F"
		cTipAfas := "F"
	Else
		cTipAfas := " "
	EndIf
	If MesAno(dDtAfas) > MesAno(dDtPesqAf)
		cTipAfas := " "
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica Situacao e Categoria do Funcionario                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If	!(cTipAfas $ cSit) .Or. !(SRA->RA_CATFUNC $ cCat) .Or. !(SRA->RA_TPCONTR$ cTpC1 )
		If nOrdem == 4   // Ordem do Arquivo Movto.
			If nrelat == 4 .or. If(cPaisLoc $ "URU|ARG",nRelat==3,.F.)
				dbSelectArea("SRI")
			Else
				dbSelectArea( "SRC" )
			EndIf
			dbSkip()
		Endif
		fTestaTotal()
		Loop
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste controle de acessos e filiais validas				 |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !(SRA->RA_FILIAL $ fValidFil()) .Or. !Eval(cAcessaSRA)
		If nOrdem == 4   // Ordem do Arquivo Movto.
			If nrelat == 4 .or. If(cPaisLoc $ "URU|ARG",nRelat==3,.F.)
				dbSelectArea("SRI")
			Else
				dbSelectArea( "SRC" )
			EndIf
			dbSkip()
		Endif
		fTestaTotal()
		Loop
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se e Adiantamento e Folha                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nRelat == 1 .Or. nRelat == 2 .Or. If(!(cPaisLoc $ "URU|ARG"),nRelat == 3,.F.)
		lInssFun := .F.
		lCotFun := .F.
		dbSelectArea( "SRC" )
		If cCalcInf == "S"   //Verifica se deve listar so os Informados
			If ! dbSeek(SRA->RA_FILIAL + SRA->RA_MAT + aCodFol[64,1] ) .And. ;
				! dbSeek(SRA->RA_FILIAL + SRA->RA_MAT + acodFol[65,1] ) .And. ;
				! dbSeek(SRA->RA_FILIAL + SRA->RA_MAT + acodFol[70,1] ) .And. ;
				! dbSeek(SRA->RA_FILIAL + SRA->RA_MAT + acodFol[125,1] )
				fTestaTotal()
				Loop
			Else
				dbSelectArea("SRC")
				dbSeek( SRA->RA_FILIAL + SRA->RA_MAT )
			Endif
		ElseIf nOrdem # 4
			dbSeek(SRA->RA_FILIAL + SRA->RA_MAT )
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Busca os codigos de pensao definidos no cadastro beneficiario³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nRelat == 3
			fBusCadBenef(@aCodBenef, "131", {aCodfol[172,1]})
		EndIf

		While !Eof() .And. (nOrdem # 4 .And. SRC->RC_FILIAL+SRC->RC_MAT == SRA->RA_FILIAL+SRA->RA_MAT) .Or. ;
			(nOrdem = 4 .And. SRC->RC_FILIAL+SRC->RC_CC+SRC->RC_MAT == SRA->RA_FILIAL+cCCto+SRA->RA_MAT)
			If	SRC->RC_SEMANA # Semana .And. Semana # "99"
				dbSkip()
				Loop
			Endif
			
			If !Eval(cAcessaSRC)
				dbSkip()
				Loop
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Desconto de Adto Gera um provento                            ³
			//³ Arredondamento do Adto gera um Provento                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If	(nRelat == 1) .And. (SRC->RC_PD == aCodFol[7,1] .Or. SRC->RC_PD == aCodFol[8,1])
				cCodInv := If(SRC->RC_PD == aCodFol[7,1],aCodfol[6,1],aCodFol[8,1])
				fSoma(@aFunP,"C",cCodInv)
				fSoma(@aCcP ,"C",cCodInv)
				fSoma(@aFilP,"C",cCodInv)
				fSoma(@aEmpP,"C",cCodInv)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ I.R. do Adto. Codigo de Base gera IR do Adto.                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			ElseIf (nRelat == 1) .And. (SRC->RC_PD == aCodFol[12,1])
				cCodInv := aCodFol[9,1]
				fSoma(@aFunD,"C",cCodInv)
				fSoma(@aCcD ,"C",cCodInv)
				fSoma(@aFilD,"C",cCodInv)
				fSoma(@aEmpD,"C",cCodInv)
			ElseIf PosSrv(SRC->RC_PD,SRA->RA_FILIAL,"RV_TIPOCOD") == "1"
				If nRelat == 2 .Or. (nRelat == 1 .And. PosSrv(SRC->RC_PD,SRA->RA_FILIAL,"RV_ADIANTA") == "S")
					fSoma(@aFunP,"C")
					fSoma(@aCcP ,"C")
					fSoma(@aFilP,"C")
					fSoma(@aEmpP,"C")
				Endif
				If (nRelat == 3) .And. (SRC->RC_PD == aCodFol[022,1])
					fSoma(@aFunP,"C")
					fSoma(@aCcP ,"C")
					fSoma(@aFilP,"C")
					fSoma(@aEmpP,"C")
				Endif
			ElseIf PosSrv(SRC->RC_PD,SRA->RA_FILIAL,"RV_TIPOCOD") == "2"
				If	nRelat == 2 .Or. (nRelat == 1 .And. PosSrv(SRC->RC_PD,SRA->RA_FILIAL,"RV_ADIANTA") == "S")
					fSoma(@aFunD,"C")
					fSoma(@aCcD ,"C")
					fSoma(@aFilD,"C")
					fSoma(@aEmpD,"C")
					//--Verifica se Funcionario teve Retencao de Inss
					If SRC->RC_PD$ aCodFol[064,1]+'*'+aCodFol[065,1]+'*'+;
								   aCodFol[351,1]+'*'+aCodFol[354,1]
						lInssFun := .T.
					Endif
					If cPaisLoc == "URU" .And. SRC->RC_PD$ aCodFol[309,1]
						lCotFun := .T.
					Endif
				Endif
				If	nRelat == 3 .And. Ascan(aCodBenef, { |x| x[1] == SRC->RC_PD }) > 0
					fSoma(@aFunD,"C")
					fSoma(@aCcD ,"C")
					fSoma(@aFilD,"C")
					fSoma(@aEmpD,"C")
				Endif
			ElseIf PosSrv(SRC->RC_PD,SRA->RA_FILIAL,"RV_TIPOCOD") == "3"
				If	nRelat == 2 .Or. (nRelat == 1 .And. PosSrv(SRC->RC_PD,SRA->RA_FILIAL,"RV_ADIANTA") == "S")
					fSoma(@aFunB,"C")
					fSoma(@aCcB ,"C")
					fSoma(@aFilB,"C")
					fSoma(@aEmpB,"C")
				Endif
				If	nRelat == 3 .And. ( SRC->RC_PD == aCodFol[108,1] .Or. SRC->RC_PD == aCodFol[109,1] .Or. SRC->RC_PD == aCodFol[173,1] )
					fSoma(@aFunB,"C")
					fSoma(@aCcB ,"C")
					fSoma(@aFilB,"C")
					fSoma(@aEmpB,"C")
				Endif
			Endif
			dbSkip()
		Enddo
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ 2§ Parcela 13§ Salario                                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Elseif nRelat == 4 .or. If(cPaisLoc $ "URU|ARG",nRelat==3,.F.)
		lInssFun := .F.
		dbSelectArea( "SRI" )
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Se ordem for por CC do Movimento, imprimir baseado na chave  ³
		//³ de busca do SRI, caso contrario na chave de busca do SRA.    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nOrdem == 4
			cBuscaSRA := SRI->RI_FILIAL + SRI->RI_CC + SRI->RI_MAT
			cBuscaSRI := "SRI->RI_FILIAL + SRI->RI_CC + SRI->RI_MAT"
		Else
			cBuscaSRA := SRA->RA_FILIAL + SRA->RA_MAT
			cBuscaSRI := "SRI->RI_FILIAL + SRI->RI_MAT"
			dbSeek(cBuscaSRA)
		EndIf
		While !Eof() .And. (&cBuscaSRI == cBuscaSRA)
			If !Eval(cAcessaSRI)
				dbSkip()
				Loop
			EndIf
			If PosSrv(SRI->RI_PD,SRI->RI_FILIAL,"RV_TIPOCOD") == "1"
				fSoma(@aFunP,"I")
				fSoma(@aCcP ,"I")
				fSoma(@aFilP,"I")
				fSoma(@aEmpP,"I")
			ElseIf PosSrv(SRI->RI_PD,SRI->RI_FILIAL,"RV_TIPOCOD") == "2"
				fSoma(@aFunD,"I")
				fSoma(@aCcD ,"I")
				fSoma(@aFilD,"I")
				fSoma(@aEmpD,"I")
				//--Verifica se Funcionario teve Retencao de Inss
				If SRI->RI_PD$ aCodFol[070,1]
					lInssFun := .T.
				Endif
			ElseIf PosSrv(SRI->RI_PD,SRI->RI_FILIAL,"RV_TIPOCOD") == "3"
				fSoma(@aFunB,"I")
				fSoma(@aCcB ,"I")
				fSoma(@aFilB,"I")
				fSoma(@aEmpB,"I")
			Endif
			dbSkip()
		Enddo
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Nao considera funcionarios admitidos apos o periodo do movimento ³
	//³ e nem os demitidos anterior ao periodo.						     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If MesAno(SRA->RA_ADMISSA) <= MesAno(dDtPesqAf) .and.;
		(Empty(SRA->RA_DEMISSA) .or. MesAno(SRA->RA_DEMISSA) >= MesAno(dDtPesqAf))
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Somatorias de Situacoes dos Funcionarios                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SRA->RA_CC = cCcto
			If lInssFun
				nEinss ++ ; nFinss++ ; nCinss ++  //-- Total de Func. Ret. Inss
			Endif
            If mesano(SRA->RA_ADMISSA) = MesAno(dDtPesqAf)
				nEadm ++ ; nFadm ++ ; nCadm ++  //-- Total Admitidos      
			//	nEtot ++ ; nFtot ++ ; nCtot ++  //-- Total de Funcionarios
            Endif
 			If cTipAfas == " "
				nEnor ++ ; nFnor ++ ; nCnor ++  //-- Total Situacao Normal
				nEtot ++ ; nFtot ++ ; nCtot ++  //-- Total de Funcionarios
 
			Elseif cTipAfas == "A"
				nEafa ++ ; nFafa ++ ; nCafa ++  //-- Total Afastados
				nEtot ++ ; nFtot ++ ; nCtot ++  //-- Total de Funcionarios
				
			Elseif cTipAfas == "D"
				If Len(aFunP) > 0 .Or. Len(aFunD) > 0 .Or. Len(aFunB) > 0
					nEdem ++ ; nFdem ++ ; nCdem ++  // Demitidos
					nEtot ++ ; nFtot ++ ; nCtot ++  // Total de Funcionarios
				Endif
				
			Elseif cTipAfas == "F"
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Procura No Arquivo de Ferias o Periodo a Ser Listado         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea( "SRH" )
				If dbSeek( SRA->RA_FILIAL + SRA->RA_MAT )
					While !Eof() .And. SRA->RA_FILIAL + SRA->RA_MAT == SRH->RH_FILIAL + SRH->RH_MAT
						dbSkip()
					Enddo
					dbSkip(-1)
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica Se Esta Dentro Das Datas Selecionadas               ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If MesAno(SRH->RH_DATAINI) > cAnoMesRef
						nEnor ++ ; nFnor ++ ; nCnor ++  //-- Total Situacao Normal
					Else
						nEfer ++ ; nFfer ++ ; nCfer ++  //-- Ferias
					Endif
					nEtot ++ ; nFtot ++ ; nCtot ++  //-- Total de Funcionarios
				Endif
				dbSelectArea( "SRA" )
				
			Elseif cTipAfas == "T"
				nEtra ++ ; nFtra ++ ; nCtra ++  //-- Transferidos
				nEtot ++ ; nFtot ++ ; nCtot ++  //-- Total de Funcionarios				
			Endif
		Else
			If lInssFun
				nCinss ++
			Endif
			nEexc ++ ; nFexc ++ ; nCexc ++  //-- Outro C.Custo
			nEtot ++ ; nFtot ++ ; nCtot ++  //-- Outro C.Custo
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Testa Verbas de Provento / Descontos / Base                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If	Len(aFunP) == 0 .And. Len(aFunD) == 0 .And. Len(aFunB) == 0
			fTestaTotal()
			Loop
		Endif
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime Funcionarios                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	fImpFun(@aFunP,@aFunD,@aFunB)
	fTestaTotal()
Enddo

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³fCalcComplºAutor  ³Andreia dos Santos  º Data ³  07/03/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Calcula os Valores de Pro-Labore, Autonomo, Cooperativa e  º±±
±±º          ³ Vl. da Receita de acordo com as verbas cadastradas.        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ cExp1 => Tipo 1 - Filial                                   º±±
±±º          ³          Tipo 2 - Centro de Custo                          º±±
±±º          ³ cExp2 => Centro de Custo                                   º±±
±±º          ³ cExp3 => Se .T. nao foi informado o CC no cadastro de      º±±
±±º          ³          parametros e o valor so sera considerado na Filialº±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAGPE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static Function fCalcCompl(cTipo,cCCusto,lFilial,nOrdem)
Local nX := 1
Local nValor
Local lSoma := .F.

For nX := 1 to len(aGpsVal)
    if lFilial  
    	If ( StrZero(nOrdem,1) $ "1/4/5" .And. empty(alltrim(aGpsVal[nX,1])) ) .Or.;
    		StrZero(nOrdem,1) $ "2/3"
	       lSoma := .T.
	    Endif   
    ElseIF StrZero(nOrdem,1) $ "1/4/5" .And. alltrim(aGpsVal[nX,1]) ==alltrim(cCCusto)
    	lSoma := .T.
    Endif
    If lSoma	
		nValor := If(aGpsVal[nx,5] <> 0,aGpsVal[nx,5],round(aGpsVal[nx,3]*aGpsVal[nx,4]/100,2))
		if nValor <> 0
			fSomaInss(cTipo,aGpsVal[nx,2],nValor)  
		Endif
	EndIF	
    lSoma := .F.
Next
return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ImprFlh   ºAutor  ³Adalberto Althoff Jrº Data ³  17/08/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ salto de pagina com 65 linhas                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AAJ0003                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

static Function ImprFlh(	cDetalhe	,;	//01 -> Linha Detalhe a ser impressa.
		   					cFimFolha	,;	//02 -> "F" ou "P" Imprime Rodape e Salta de Pagina. Qualquer outro Ex.: "C" Imprime Detalhe e  Incrementa Li.
							nReg		,;	//03 -> Numero de Registros a Serem Impressos no Rodape.
							cRoda		,;	//04 -> Descritivo a Ser Impresso no Rodape apos nReg.
							nColuna		,;	//05 -> Coluna onde Iniciar Impressao do Detalhe.
							lSalta		,;	//06 -> Se deve ou nao Incrementar o salto de Linha.
							lMvImpSX1	,;	//07 -> Se Deve Considerar o Parametro MV_IMPSX1 ao inves do MV_PERGRH
							bCabec		,;	//08 -> Bloco com a Chamada de Funcao para Cabecalho Especifico
							bRoda		 ;	//09 -> Bloco com a Chamada de Funcao para Rodape Especifico
						  )

Local aCabec		:= {}
Local cDetCab		:= ""
Local cWCabec		:= ""
Local lbCabec		:= ( ValType( bCabec ) == "B" )
Local lbRoda        := ( ValType( bRoda  ) == "B" )
Local nCb			:= 0.00
Local nSpace		:= 0.00

Static lPerg
Static nNormal
Static nComp

if empty(lMvImpSX1)
	lMvImpSX1	:= .F.
endif
if empty(lPerg)
	lPerg  		:= ( GetMv( IF( lMvImpSX1 , "MV_IMPSX1" , "MV_PERGRH" ) ) == "S" )
endif
if empty(nNormal)	
	nNormal		:= GetMv("MV_NORM")
endif
if empty(nComp)	
	nComp		:= GetMv("MV_COMP")
endif
if empty(cFimFolha)	
	cFimFolha	:= ""
endif
if empty(cDetalhe)	
	cDetalhe	:= ""
endif	
if empty(nReg)
	nReg		:= 0.00
endif
if empty(nColuna)	
	nColuna 	:= 0.00
endif
if empty(lSalta)	
	lSalta		:= .T.
endif	

wnRel		:= IF( Type("wnRel")	== "U" , IF( Type("NomeProg") != "U" ,  NomeProg , "" ) , wnRel )
wCabec0		:= IF( Type("wCabec0")	== "U" , 0	, wCabec0	)
wCabec1 	:= IF( Type("wCabec1")	== "U" , "" , wCabec1	)
wCabec2 	:= IF( Type("wCabec2")	== "U" , "" , wCabec2	)
nChar		:= IF( Type("nChar")	== "U" , NIL , IF( nChar == 15 , nComp , nNormal ) ) // Quando nao for compactado nChar deve ser Nil para tratamento da Cabec.
ContFl		:= IF( Type("ContFl")   == "U" , 1   , ContFl   )
nTamanho	:= IF( Type("nTamanho") == "U" , "P" , nTamanho )
Li			:= IF( Type("Li")		== "U" , 0   , Li		)
Titulo		:= IF( Type("Titulo")   == "U" , ""  , Titulo   )
aReturn		:= IF( Type("aReturn")  == "U" , {"",1,"",2,1,"","",1} , aReturn )

m_pag		:= ContFl
nSpace		:= IF( nTamanho == "P" , 80 , IF( nTamanho == "G" , 220 , 132 ) )
cFimFolha	:= Upper( AllTrim( cFimFolha ) )

IF ( ( cFimFolha $ "FP" ) .or. ( Li >= 65 ) )
	IF ( Li != 0.00 )
		IF ( ( cFimFolha $ "F" ) .or. ( cRoda != NIL ) )
			IF !( lbRoda )
				IF ( ( nReg == 0.00 ) .or. ( cRoda == NIL ) )
					Roda( 0.00 , ""    , nTamanho )
				Else
					Roda( nReg , cRoda , nTamanho )
				EndIF
			Else
				Eval( bRoda )
			EndIF	
		EndIF
		Li := 0.00
	EndIF
	IF ( ( cFimFolha == "F" ) .or. ( ( cFimFolha == "P" ) .and. Empty( cDetalhe ) ) )
		Return( NIL )
	EndIF
EndIF

IF ( Li == 0.00 )
	IF !( lbCabec )
		IF ( wCabec0 <= 2 )
			Cabec( Titulo , wcabec1 , wcabec2 , wnrel , nTamanho , nChar , NIL , lPerg )
		Else
		    aCabec := SendCab(nSpace)
		    For nCb := 1 To wCabec0
		    	IF ( Type((cWCabec := "wCabec"+Alltrim(Str(nCb)))) != "U" )
			    	cDetCab := &(cWCabec)
			    	cDetCab += Space(nSpace - Len(cDetCab) -1)
		    		aAdd(aCabec,"__NOTRANSFORM__"+cDetCab)
		    	EndIF
		    Next nCb
		  	Cabec( Titulo , "" , "" , wnrel , nTamanho , nChar , aCabec , lPerg )
		EndIF
	Else
		Eval( bCabec )
	EndIF
	ContFl++
EndIF

IF ( Len( cDetalhe ) == nSpace )
	IF ( Empty(StrTran(cDetalhe,"-","")) .or. Empty(StrTran(cDetalhe,".","")) )
		cDetalhe := __PrtThinLine()
	ElseIF ( Empty(StrTran(cDetalhe,"=","")) .or. Empty(StrTran(cDetalhe,"*","")) )
		cDetalhe := __PrtFatLine()
	EndIF
EndIF

@ Li , nColuna PSAY cDetalhe

IF(lSalta,Li++,NIL)

Return( NIL )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fBuscaFuncºAutor  ³R.H. - Natie        º Data ³  16/03/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Carrega Funcoes de acordo com  a data de referencia        º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
static Function  fBuscaFunc(dDataDe,cCodFunc, cDescFunc )

If SR7->( dbSeek( SRA->(RA_FILIAL + RA_MAT) )  )
	While SR7->(!EOF()) .and. SR7->R7_DATA  	<= dDataDe  .AND.;
								SR7->R7_FILIAL 	== SRA->RA_FILIAL .AND. ;
								SR7->R7_MAT   	== SRA->RA_MAT
		cCodFunc 	:=	SR7->R7_FUNCAO
		cDescFunc 	:= 	SR7->R7_DESCFUN									//-- 20 Bytes 
		SR7->(dbSkip())
	EndDo
Else 
	cCodFunc 	:=	SRA->RA_CODFUNC
	cDescFunc	:=  LEFT(fDesc("SRJ",SRA->RA_CODFUNC,"RJ_DESC" ),20)	
EndIf
	
Return 