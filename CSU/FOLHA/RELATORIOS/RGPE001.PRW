#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RGPE001   º Autor ³Ricardo Duarte Costaº Data ³  26/08/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Relatorio de Reajustes salariais.                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU CARDSYSTEM S/A                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RGPE001

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "REAJUSTES SALARIAIS"
Local cPict          := ""
Local titulo       := "REAJUSTES SALARIAIS"
Local nLin         := 80
Local aOld			:= getarea()
Local Cabec2		:= "Fil Matric Nome                                              Admissao Funcao                                       Sal.Ant      Salario GS  Reaj.% Motivo do Aumento            Dt.Aumento Sit  Secao               Jornada"
Local Cabec1       := ""
Local imprime      := .T.                           
Local aOrd := {}     
Private cMat          :=" "


Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 220
Private tamanho          := "G"
Private nomeprog         := "RGPE001" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 15
Private aReturn          := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey        := 0
Private cperg       := PADR("RGP077",LEN(SX1->X1_GRUPO))
Private cbtxt		:= Space(10)
Private cbcont		:= 00
Private CONTFL		:= 01
Private m_pag		:= 01
Private wnrel      := "RGPE001" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cDet		:= ""
Private nTotSal		:= 0
Private nTotFunc	:= 0
Private nTotSalG	:= 0
Private nTotFuncG	:= 0
Private vReajAnt	:= 0 
Private nMatricula  := ""
PRIVATE  lRet		:= .F.
PRIVATE nSalAnt	:= 0
PRIVATE nSalAtu	:= 0
PRIVATE nPerc		:= 0
Private cFilAnt		:= ""
Private aInfo		:= {}
Private wnrel		:= "RGPE001" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SR3"
fPerg()
pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,CPERG,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

RESTAREA( aOld )

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  26/08/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem

// Carrega os parametros
dDataDe		:= mv_par01		//	Filial De
dDataAte	:= mv_par02		//	Filial Ate
cFilde		:= mv_par03		//	Filial De
cFilAte		:= mv_par04		//	Filial Ate
cCCDe		:= mv_par05		//	Centro de Custos De
cCCAte		:= mv_par06		//	Centro de Custos Ate
cMatDe		:= mv_par07		//	Matricula De
cMatAte		:= mv_par08 	//	Matricula Ate
cSitFolha	:= mv_par09		//	Situacoes a imprimir
cCategoria	:= mv_par10		//	Categorias a imprimir
cCodDiss	:= mv_par11		//	Codigo do dissidio coletivo

// Ajusta o titulo do relatorio
set century on
titulo	:= titulo + " " + substr(dtoc(dDataDe),4,7) + " " + substr(dtoc(dDataAte),4,7)
set century off

dbSelectArea(cString)
dbSetOrder(2)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// Obtem os registros a serem processados relacionando Tquery - Funcionarios com Tquery - Reajuste Salarial
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cQuery := "SELECT SRA.RA_FILIAL,SRA.RA_MAT,SRA.RA_NOME,SRA.RA_CODFUNC,SRA.RA_CC,SRA.RA_GS,SRA.RA_SITFOLH,SRA.RA_CATFUNC,SRA.RA_ADMISSA,SRA.RA_HRSMES,SRA.RA_HRSEMAN,SRA.RA_TIPOPGT,SRA.RA_SALARIO,SRA.RA_ANTEAUM,SR3.R3_FILIAL,SR3.R3_MAT,SR3.R3_DATA,SR3.R3_TIPO,SR3.R3_VALOR,SR3.R3_DESCPD,SR3.R3_ANTEAUM " 
cQuery +=  "FROM "+RetSqlName('SRA')+ " SRA (NOLOCK), "+RetSqlName('SR3')+ " SR3 (NOLOCK) "


cQuery += " where RA_FILIAL    between '"+(mv_par03)+"' AND '"+(mv_par04)+"' AND" 
cQuery += " RA_MAT             between '"+(mv_par07)+"' AND '"+(mv_par08)+"' AND"  
cQuery += " RA_CC              between '"+(mv_par05)+"' AND '"+(mv_par06)+"' AND" 
cQuery += " R3_FILIAL      =   RA_FILIAL     AND"      //-----------------------cQuery += " AND E1_PORTADO IN "+FormatIn(mv_par29,";") 
cQuery += " R3_MAT         =   RA_MAT        AND"    
//cQuery += " R3_TIPO	      IN "+FormatIn(cCodDiss,",")+"           AND "    
cQuery += " SRA.D_E_L_E_T_ <> '*'                       AND "
cQuery += " SR3.D_E_L_E_T_ <> '*' 				            "
cQuery +=  " ORDER BY RA_FILIAL,RA_MAT,R3_DATA"     

memowrite ("cQuery.sql",cQuery) // GRAVA NO SIGAADV A ESTRUTURA DA QUERY 

cQuery	:= ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), "TQUERY", .T., .F. )

cFilAnt := Tquery->RA_FILIAL
fInfo(@aInfo,Tquery->RA_FILIAL)
cabec1	:= padc(Tquery->RA_FILIAL + " - " + aInfo[2] + " - " + aInfo[1],220)
 
dbSelectArea("Tquery")
While !Tquery->(Eof()) .and. Tquery->RA_FILIAL <= cFilAte   

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o cancelamento pelo usuario...                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressao do cabecalho do relatorio. . .                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,wnrel,Tamanho,nTipo)
		nLin := 9
	Endif
	
	
	   
	   
	If cFilAnt <> Tquery->RA_FILIAL 
	    nLin := nLin + 1
		@nLin,17 PSAY	"Filial: "+transform(nTotFunc,"@E 99,999") + " Funcionario(s) " + space(57) +;
		"Diferença total : " + transform(nTotSal,"@E 999,999,999.99")
		nTotFunc	:= 0
		nTotSal		:= 0
		nLin		:= 80
		fInfo(@aInfo,Tquery->RA_FILIAL)
		cFilAnt		:= Tquery->RA_FILIAL
		cabec1	:= padc(Tquery->RA_FILIAL + " - " + aInfo[2] + " - " + aInfo[1],220)
	Endif
	
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Busca as informacoes a imprimir no relatorio de reajustes           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
     
    	nSalAtu		:= Tquery->R3_VALOR   //IF(Tquery->RA_CATFUNC $"M,G,H",Tquery->R3_VALOR*Tquery->RA_HRSMES,Tquery->R3_VALOR)
	
        
        // ALIMENTA O VALOR ANTERIOR PARA CALCULO DO REAJUSTE 
//        nSalAnt := vReajAnt
 
	If ! Tquery->R3_TIPO $ cCodDiss   
  		nSalAnt :=  Tquery->R3_VALOR
      dbskip()
      loop	
	Endif
   
// 	if  Tquery->R3_MAT <> nMatricula   
//  		nSalAnt :=  Tquery->R3_VALOR
// 	Endif
	     
	
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Filtra os parametros selecionados......                             ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

 	
	if	(Tquery->R3_DATA) < DTOS(dDataDe) .or. (Tquery->R3_DATA) > DTOS(dDataAte)
        vReajAnt     := Tquery->R3_VALOR        
   		nMatricula   := Tquery->R3_MAT
 		dbskip()
	   	loop
 	Endif  
 	
 	If  ! Tquery->RA_SITFOLH $cSitFolha .or. ! Tquery->RA_CATFUNC $cCategoria 
        vReajAnt     := Tquery->R3_VALOR  
   		nMatricula   := Tquery->R3_MAT
      dbskip()
      loop
    Endif
	
	nPerc		:= noround( ( ( nSalAtu / nSalAnt ) - 1 ) * 100, 2 )
	
	if nPerc < 0
	   nPerc = 0
	Endif
	
	cDet	:= Tquery->RA_FILIAL + "  " + Tquery->R3_MAT+ " " + Tquery->RA_NOME
	cDet	:= cDet + DtoC(StoD(Tquery->RA_ADMISSA))+ " "
   	cDet	:= cDet + POSICIONE("SRJ",1,xfilial("SRJ")+Tquery->RA_CODFUNC,"RJ_DESC")
	cDet	:= cDet + transform(nSalAnt,"@E 9,999,999.99")
	cDet	:= cDet + " " + transform(nSalAtu,"@E 9,999,999.99")
	cDet	:= cDet + " " + Tquery->RA_GS 
	cDet	:= cDet + " " + transform(nPerc,"@E 999.99")
	cDet	:= cDet + "  " + SUBSTR(tabela("41",Tquery->R3_TIPO,.F.)+SPACE(25),1,30)
	set century on
	cDet	:= cDet + " " + DtoC(StoD(Tquery->R3_DATA)) + "  " + if(Tquery->RA_SITFOLH==" ","N",Tquery->RA_SITFOLH) + "   "
	set century off
	cDet	:= cDet + Tquery->RA_CC + " " + transform(Tquery->RA_HRSMES,"@E 999.99")
	
	nLin := nLin + 1
	@nLin,00 PSAY cDet
	cDet	:= ""
	nLin := nLin + 1 // Avanca a linha de impressao
	
// Impressao dos totais de funcionarios	
	nTotFunc	:= nTotFunc + 1
	nTotFuncG	:= nTotFuncG + 1
	nTotSal		:= nTotSal + (nSalAtu - nSalAnt)
	nTotSalG	:= nTotSalG + (nSalAtu - nSalAnt)
	
	vReajAnt     := Tquery->R3_VALOR
	nMatricula   := Tquery->R3_MAT
	
	Tquery->(dbskip())
Enddo
 
nLin := nLin + 1 // Avanca a linha de impressao
@nLin,17 PSAY	"Filial: "+transform(nTotFunc,"@E 99,999") + " Funcionario(s) " + space(57) +;
				"Diferença total : " + transform(nTotSal,"@E 999,999,999.99")

    //  nLin := nLin + 2 // Avanca a linha de impressao

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do cabecalho do relatorio. . .                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nLin > 60 // Salto de Página. Neste caso o formulario tem 55 linhas...
   Cabec(Titulo,Cabec1,Cabec2,wnrel,Tamanho,nTipo)
   nLin := 9
Endif

nLin := nLin + 2 // Avanca a linha de impressao
@nLin,17 PSAY	"Geral:  "+transform(nTotFuncG,"@E 99,999") + " Funcionario(s) " + space(57) +;
				"Diferença total : " + transform(nTotSalG,"@E 999,999,999.99")      

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()
Tquery->(dbclosearea())
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ fPerg    º Autor ³                    º Data ³  11/03/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao para criar o grupo de perguntas no SX1              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
± 11/03/2010 ³ Substituição da função ValidPerg() para função fPerg()      ±±
±            ³ corrigindo a duplicidade na criação das perguntas no SX1    ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function fPerg()
_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
aRegs:={}  


AADD(aRegs, {cPerg, "01", "Data de 		        ? ", "",	"", "mv_ch1", "D", 08, 0, 0, "G", "		     ", "mv_par01", "", "", "", "         ",	"", "", "",	"", "", "", "", "", "",	"", "", "",	"", "", "",	"", "", "",	"", "", "   ",	""})
AADD(aRegs, {cPerg, "02", "Data ate             ? ", "",	"", "mv_ch2", "D", 08, 0, 0, "G", "			 ", "mv_par02", "", "", "", "         ",	"", "", "",	"", "", "", "", "", "",	"", "", "",	"", "", "",	"", "", "",	"", "", "   ",	""})
AADD(aRegs, {cPerg, "03", "Filial De            ? ", "",	"", "mv_ch3", "C", 02, 0, 0, "G", "			 ", "mv_par03", "", "", "", "         ",	"", "", "",	"", "", "", "", "", "",	"", "", "",	"", "", "",	"", "", "",	"", "", "SM0",	""})
AADD(aRegs, {cPerg, "04", "Filial Ate           ? ", "",	"", "mv_ch4", "C", 02, 0, 0, "G", "			 ", "mv_par04", "", "", "", "ZZ       ",	"", "", "",	"", "", "", "", "", "",	"", "", "",	"", "", "",	"", "", "",	"", "", "SM0",	""})
AADD(aRegs, {cPerg, "05", "Centro de Custo De   ? ", "",	"", "mv_ch5", "C", 20, 0, 0, "G", "			 ", "mv_par05", "", "", "", "         ",	"", "", "",	"", "", "", "", "", "",	"", "", "",	"", "", "",	"", "", "",	"", "", "CTT",	""})
AADD(aRegs, {cPerg, "06", "Centro de Custo Ate  ? ", "",	"", "mv_ch6", "C", 20, 0, 0, "G", "			 ", "mv_par06", "", "", "", "ZZZZZZZZZ",	"", "", "",	"", "", "", "", "", "",	"", "", "",	"", "", "",	"", "", "",	"", "", "CTT",	""})
AADD(aRegs, {cPerg, "07", "Matricula De         ? ", "",	"", "mv_ch7", "C", 06, 0, 0, "G", "			 ", "mv_par07", "", "", "", "         ",	"", "", "",	"", "", "", "", "", "",	"", "", "",	"", "", "",	"", "", "",	"", "", "SRA",	""})
AADD(aRegs, {cPerg, "08", "Matricula Ate        ? ", "",	"", "mv_ch8", "C", 06, 0, 0, "G", "		     ", "mv_par08", "", "", "", "ZZZZZZ   ",	"", "", "",	"", "", "", "", "", "",	"", "", "",	"", "", "",	"", "", "",	"", "", "SRA",	""})
AADD(aRegs, {cPerg, "09", "Situa‡”es  a Impr.   ? ", "",	"", "mv_ch9", "C", 05, 0, 0, "G", "fSituacao ", "mv_par09", "", "", "", "         ",	"", "", "",	"", "", "", "", "", "",	"", "", "",	"", "", "",	"", "", "",	"", "", "   ",	""})
AADD(aRegs, {cPerg, "10", "Categorias a Impr.   ? ", "",	"", "mv_chA", "C", 12, 0, 0, "G", "fCategoria", "mv_par10", "", "", "", "         ",	"", "", "",	"", "", "", "", "", "",	"", "", "",	"", "", "",	"", "", "",	"", "", "   ",	""})
AADD(aRegs, {cPerg, "11", "Codigo do Dissidio   ? ", "",	"", "mv_chB", "C", 30, 0, 0, "G", "naovazio  ", "mv_par11", "", "", "", "         ",	"", "", "",	"", "", "", "", "", "",	"", "", "",	"", "", "",	"", "", "",	"", "", "   ",	""})

ValidPerg(aRegs,cPerg)

Return    
