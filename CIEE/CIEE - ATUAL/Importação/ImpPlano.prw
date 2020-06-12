
User Function ImpPlano()

Processa({|| RunImp() },"Processando...")

Return

Static Function RunImp()

cDirect    := "\1TOTVS_HOMOLOG\IMPORT\"
If cEmpant == '01' //SP
	aDirect    := Directory(cDirect+"SP_*.TXT")
ElseIf cEmpant == '03' //RJ
	aDirect    := Directory(cDirect+"RJ_*.TXT")
EndIf

If Empty(adirect)
	MsgAlert("Nao existe nenhum arquivo para ser Importado!!!")
	Return
EndIf

_aNaoAcho	:= {}

For _nI := 1 to Len(adirect)
	FT_FUSE(cDirect+adirect[_nI,1])
	FT_FGOTOP()
	ProcRegua(FT_FLASTREC())

	Do While !FT_FEOF()

		If cEmpant == '01' //SP
			IncProc("Processando Leitura do Arquivo Texto...SAO PAULO")
		ElseIf cEmpant == '03' //RJ
			IncProc("Processando Leitura do Arquivo Texto...RIO DE JANEIRO")
		EndIf
		
		cBuffer 	:= Alltrim(FT_FREADLN())
		cContaNova	:= Substr(cBuffer,1,(At(";",cBuffer)-1))

		cBuffer	 	:= Substr(cBuffer,(At(";",cBuffer)+1),500)
		cContaSup 	:= Substr(cBuffer,1,(At(";",cBuffer)-1))

		cBuffer 	:= Substr(cBuffer,(At(";",cBuffer)+1),500)
		cDesc	 	:= Substr(cBuffer,1,(At(";",cBuffer)-1))

		cBuffer 	:= Substr(cBuffer,(At(";",cBuffer)+1),500)
		cClasse 	:= Substr(cBuffer,1,(At(";",cBuffer)-1))  //2-analitica **** 1-Sintetica

		cBuffer 	:= Substr(cBuffer,(At(";",cBuffer)+1),500)
		cDC		 	:= Substr(cBuffer,1,(At(";",cBuffer)-1))

		If Substr(cContaNova,1,1) == "1" .or. Substr(cContaNova,1,1) == "2"

			cBuffer 	:= Substr(cBuffer,(At(";",cBuffer)+1),500)
			cReduzida 	:= Substr(cBuffer,1,(At(";",cBuffer)-1))

			cBuffer 	:= Substr(cBuffer,(At(";",cBuffer)+1),500)
			cContaAnt	:= Alltrim(cBuffer)
		Else

			cBuffer 	:= Substr(cBuffer,(At(";",cBuffer)+1),500)
			cReduzida 	:= Alltrim(cBuffer)

			cContaAnt	:= ""

			If Len(Alltrim(cReduzida))>5
				FT_FSKIP()
				Loop
			EndIf

		EndIf

		DbSelectArea("CT1")
		DbSetOrder(2) //Codigo Reduzida
		If DbSeek(xFilial("CT1")+Alltrim(cReduzida))
			RecLock("CT1",.F.)
			CT1->CT1_CONTA		:= Alltrim(cContaNova)
			MsUnLock()
		Else
			AADD(_aNaoAcho,{cContaNova, cDesc, cReduzida})
		EndIf
		
		FT_FSKIP()
	EndDo
	FT_FUSE()
Next

MsgInfo("Importacao Finalizada com Sucesso!!!")

If !Empty(_aNaoAcho)
	RELIMPCN(_aNaoAcho)
EndIf

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO4     � Autor � AP6 IDE            � Data �  17/05/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RELIMPCN(_aNaoAcho)

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1 	:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2 	:= "de acordo com os parametros informados pelo usuario."
Local cDesc3 	:= ""
Local titulo 	:= "Contas Contabeis Nao Cadastrados"
Local nLin 		:= 80
Local Cabec1 	:= ""
Local Cabec2 	:= ""

Private lAbortPrint 	:= .F.
Private limite 			:= 80
Private tamanho			:= "P"
Private nomeprog 		:= "RELIMPCN"
Private nTipo 			:= 18
Private aReturn 		:= { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey 		:= 0
Private m_pag 			:= 01
Private wnrel 			:= "RELIMPCN" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString 		:= "SA1"
Private _aNaoAcho		:= _aNaoAcho

dbSelectArea(cString)
dbSetOrder(1)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)

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

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin, _aNaoAcho) },Titulo)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  17/05/10   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin, _aNaoAcho)

_aNaoAcho := aSort(_aNaoAcho,,, {|x, y| x[1] < y[1]})

For _nY := 1 to len(_aNaoAcho)

	If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif

	@ nLin, 00 PSAY _aNaoAcho[_nY,1]
	@ nLin, 22 PSAY Substr(_aNaoAcho[_nY,2],1,30)
	@ nLin, 55 PSAY _aNaoAcho[_nY,3]


	nLin++

Next _nY

//���������������������������������������������������������������������Ŀ
//� Finaliza a execucao do relatorio...                                 �
//�����������������������������������������������������������������������

SET DEVICE TO SCREEN

//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return