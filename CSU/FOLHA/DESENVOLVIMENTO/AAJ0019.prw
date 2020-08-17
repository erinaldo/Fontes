#INCLUDE "rwmake.ch"
#include "topconn.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � AAJ0019  � Autor � Adalberto Althoff  � Data �  20/01/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Relatorio de funcoes com campos memo                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function AAJ0019

//�������������������������Ŀ
//� Declaracao de Variaveis �
//���������������������������

Local cDesc1         := "Este programa ira gerar relat�rio onde ser� poss�vel"
Local cDesc2         := "visualizar e conferir os dados de fun��es.          "
Local cDesc3         := "                                  "
Local cPict          := ""
Local titulo       := "Relat�rio de Fun��es"
Local nLin         := 80

Local Cabec1       := "Filial Matr�cula Nonme                              Carga hor�ria Admiss�o"
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {"Alfab�tica","C�digo"}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 80
Private tamanho          := "P"
Private nomeprog         := "AAJ0019"
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := PADR("AJ0019",LEN(SX1->X1_GRUPO))
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "AAJ0019"

Private cString := "SRA"

ValidPerg(cPerg)

//������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...�
//��������������������������������������������

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  20/01/05   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

//��������������������Ŀ
//� Query de consulta. �
//����������������������

_cQuery := " select RJ_FUNCAO,RJ_DESC,Q3_DESCDET,RJ_DESCREQ,Q3_DHABILI "
_cQuery += " from "+RETSQLNAME("SQ3")+","+RETSQLNAME("SRJ")+" "
_cQuery += " WHERE Q3_CARGO = RJ_CARGO AND RJ_FUNCAO "
IF MV_PAR03 == 2
	_cQuery += " NOT "
endif	        
IF MV_PAR03 != 3
	_cQuery += " IN (SELECT DISTINCT RA_CODFUNC FROM "+RETSQLNAME("SRA")+" WHERE RA_SITFOLH <> 'D')"
	_cQuery += " AND RJ_FUNCAO "
endif	
_cQuery += " IN (SELECT DISTINCT RA_CODFUNC FROM "+RETSQLNAME("SRA")+" "
_cQuery += " WHERE RA_FILIAL BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "')"

do case
	case aReturn[8] == 2
		_cQuery += " ORDER BY RJ_FUNCAO"
	case aReturn[8] == 1
		_cQuery += " ORDER BY RJ_DESC"
endcase

//�������������������������������������Ŀ
//� Verifica se nao esta aberto o alias �
//���������������������������������������

If Select("TR0019") >0
	DBSelectArea("TR0019")
	DBCloseArea()
EndIf

//���������������������������������������Ŀ
//� Cria alias conforme query de consulta �
//�����������������������������������������

TCQUERY _cQuery NEW ALIAS "TR0019"
dbSelectArea("TR0019")

DO WHILE !EOF()
	
	//�����������������������������������������Ŀ
	//� Verifica o cancelamento pelo usuario... �
	//�������������������������������������������
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//��������������������������������������������Ŀ
	//� Impressao do cabecalho do relatorio. . .   �
	//����������������������������������������������
	If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	          
	aDESCDET := fQuebLin(MSMM(Q3_DESCDET,,,,3),57)
	aDESCREQ := fQuebLin(MSMM(RJ_DESCREQ,,,,3),53)
	aDHABILI := fQuebLin(MSMM(Q3_DHABILI,,,,3),52)

	@ nlin,1 psay "Funcao " + RJ_FUNCAO + ", " +RJ_DESC
	
	nLin := nLin + 2 // Avanca a linha de impressao    
	
	IF LEN(aDESCDET)>0
		@ nlin,1 psay "Descricao Detalhada: " + aDESCDET[1]
		for i=2 to len(aDESCDET)
			nlin++

			//��������������������������������������������Ŀ
			//� Impressao do cabecalho do relatorio. . .   �
			//����������������������������������������������
			If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif

			@ nlin,1 psay "                     " + aDESCDET[i]
		next
	nLin := nLin + 2 // Avanca a linha de impressao    
	endif
	
	//��������������������������������������������Ŀ
	//� Impressao do cabecalho do relatorio. . .   �
	//����������������������������������������������
	If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif

	
	IF LEN(aDESCREQ)>0
		@ nlin,1 psay "Descricao De Requisitos: " + aDESCREQ[1]
		for i=2 to len(aDESCREQ)
			nlin++              
			
			//��������������������������������������������Ŀ
			//� Impressao do cabecalho do relatorio. . .   �
			//����������������������������������������������
			If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif
			
			@ nlin,1 psay "                         " + aDESCREQ[i]
		next
	nLin := nLin + 2 // Avanca a linha de impressao    
	endif

	//��������������������������������������������Ŀ
	//� Impressao do cabecalho do relatorio. . .   �
	//����������������������������������������������
	If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif

	
	IF LEN(aDHABILI)>0
		@ nlin,1 psay "Descricao De Habilidades: " + aDHABILI[1]
		for i=2 to len(aDHABILI)
			nlin++
			
			//��������������������������������������������Ŀ
			//� Impressao do cabecalho do relatorio. . .   �
			//����������������������������������������������
			If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif

			@ nlin,1 psay "                          " + aDHABILI[i]
		next
	nLin := nLin + 2 // Avanca a linha de impressao    
	endif


	@ nlin,1 psay replicate("=",78)
	nLin := nLin + 2 // Avanca a linha de impressao    	
	
	DBSKIP()
	
ENDDO

//�������������������������������������Ŀ
//� Finaliza a execucao do relatorio... �
//���������������������������������������

SET DEVICE TO SCREEN

//������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao... �
//��������������������������������������������������������������

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � VALIDPERG� Autor � Adalberto Althoff  � Data �  20/01/05   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar, VALIDADA PARA AP7                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function ValidPerg(Pg)

_sAlias := Alias()

dbSelectArea("SX1")
dbSetOrder(1)
_cPerg := PADR(Pg,LEN(SX1->X1_GRUPO)) 
aRegs:={}

aAdd(aRegs,{_cPerg,"01","Filial De       ","","","mv_ch1","C",02,0,0,"G","            ","mv_par01","            ","","","","","             ","","","","","     ","","","","","","","","","","","","","","SM0","","","          "})
aAdd(aRegs,{_cPerg,"02","Filial Ate      ","","","mv_ch2","C",02,0,0,"G","            ","mv_par02","            ","","","","","             ","","","","","     ","","","","","","","","","","","","","","SM0","","","          "})
aAdd(aRegs,{_cPerg,"03","Cargos de:      ","","","mv_ch3","N",01,0,0,"C","            ","mv_par03","Ativos       ","","","","","Inativos     ","","","","","Ambos","","","","","","","","","","","","","","   ","","","          "})

For i:=1 to Len(aRegs)
	If !dbSeek(_cPerg+aRegs[i,2])
		RecLock("SX1",.T.)     //RESERVA DENTRO DO BANCO DE PERGUNTAS
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()    //SALVA O CONTEUDO DO ARRAY NO BANCO
	Endif
Next

dbSelectArea(_sAlias)

Pergunte(Pg,.F.)

Return
   

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � fQuebLin � Autor � Adalberto Althoff  � Data �  20/01/05   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao que quebra uma string em varias linhas de um deter- ���
���          � minado tamanho, sem dividir palavras. Exemplo:             ���
���          �                                                            ���
���          � cVar = "pode ser que sim pode ser que nao ou quem sabe"    ���
���          � nTam = 20                                                  ���
���          �                                                            ���
���          � a funcao retornara quantas linhas forem necessarias, de no ���
���          � maximo 20 posicoes cada: [1] "pode ser que sim"            ���
���          �                          [2] "pode ser que nao ou"         ���
���          �                          [3] "quem sabe"                   ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
static function fQuebLin(cVar,nTam)

aRet  := {}
nLixo := at(chr(13),cVar) // poscao do chr(13)

do while nLixo>0
	cVar  := subs(cVar,1,nLixo-1)+" "+subs(cVar,nLixo+1) // troca chr(13) por " "
	nLixo := at(chr(10),cVar) // poscao do chr(10)
	cVar  := subs(cVar,1,nLixo-1)+" "+subs(cVar,nLixo+1) // troca chr(10) por " "
	nLixo := at(chr(13),cVar) // poscao do chr(13)
enddo

do while len(cVar)>nTam
	nCont := nTam
	do while .t. // localiza o ultimo espaco para fazer a quebra 
		if subs(cVar,nCont,1) == " "
			exit
		else
			nCont--
		endif
	enddo
	aadd(aRet,subs(cVar,1,nCont)) // inclui a linha "quebrada" no array
	cVar := subs(cVar,nCont+1)    // tira o qe foi incluso da string
enddo // continua ate a srting ficar menor que a linha.
if len(alltrim(cVar))>0
	aadd(aRet,cVar)
endif

return(aRet)
