#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO2     � Autor � AP6 IDE            � Data �  11/10/06   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function IMP_CAR()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private oLeTxt

dbSelectArea("SUM")
dbSetOrder(1)

//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������

@ 200,1 TO 380,380 DIALOG oLeTxt TITLE OemToAnsi("Leitura de Arquivo Texto")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira ler o conteudo de um arquivo texto, conforme"
@ 18,018 Say " os parametros definidos pelo usuario, com os registros do arquivo"
@ 26,018 Say "                                                            "

@ 70,128 BMPBUTTON TYPE 01 ACTION OkLeTxt()
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)

Activate Dialog oLeTxt Centered

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � OKLETXT  � Autor � AP6 IDE            � Data �  11/10/06   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao chamada pelo botao OK na tela inicial de processamen���
���          � to. Executa a leitura do arquivo texto.                    ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function OkLeTxt

Processa({|| RunCont() },"Processando...")

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � RUNCONT  � Autor � AP5 IDE            � Data �  11/10/06   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunCont

Local nTamFile, nTamLin, cBuffer, nBtLidos

//���������������������������������������������������������������������Ŀ
//� Abertura do arquivo texto                                           �
//�����������������������������������������������������������������������

FT_FUSE("C:\Ap8\Protheus_Data\CSV\Cargo.txt")
FT_FGOTOP()

nRec := 0
While !FT_FEOF()
	nRec++
	FT_FSKIP()
End

ProcRegua(nRec) 

FT_FGOTOP()

FT_FSKIP()

While !FT_FEOF()

    IncProc()
	cBuffer := Alltrim(FT_FREADLN())
	_cCargo :=	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer	:=	Substr(cBuffer,(At(";",cBuffer)+1),500)
	_cDesc	:=	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer	:=	Substr(cBuffer,(At(";",cBuffer)+1),500)
	_cSexo	:=	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer	:=	Substr(cBuffer,(At(";",cBuffer)+1),500)
	_cTrat	:=	Alltrim(cBuffer)

	dbSelectArea("SUM")
	RecLock("SUM",.T.)
	SUM->UM_FILIAL   := ""
	SUM->UM_CARGO    := _cCargo
	SUM->UM_DESC     := _cDesc
	SUM->UM_SEXO     := iif(_cSexo=="M","1","2") //1-Masculimo / 2-Feminino / 3-Ambos
	SUM->UM_TRTCARGO := _cTrat  //tratamento Cargo
	MSUnLock()
	
	FT_FSKIP()
EndDo

FT_FUSE()

Close(oLeTxt)

Return