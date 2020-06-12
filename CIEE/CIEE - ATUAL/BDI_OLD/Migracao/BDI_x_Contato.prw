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

User Function IMP_BDI()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private oLeTxt

dbSelectArea("AC8") 
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

FT_FUSE("C:\Ap8\Protheus_Data\CSV\Contatos BDI x Contatos.txt")
FT_FGOTOP()

nRec := 0
While !FT_FEOF()
	nRec++
	FT_FSKIP()
End

ProcRegua(nRec) 

FT_FGOTOP()

FT_FSKIP()

_cCodigo := "" 
_cCodSA2 := ""
_nItem   := 0

While !FT_FEOF()

    IncProc()
    _nItem++
	
	If _nItem > 5000
		_nItem   := 0	
	EndIf

	cBuffer := Alltrim(FT_FREADLN())
	_cID    	:=	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),500)
	_cBDI	:= 	alltrim(cBuffer)
	
	dbSelectArea("SU5")
	dbSetOrder(9) //ID
	If dbSeek(xFilial("SU5")+_cID)
		_cCodigo := SU5->U5_CODCONT
	Else
		_cCodigo := ""
	EndIf
	
	dbSelectArea("SA2")
	dbSetOrder(2) //NOME
	If dbSeek(xFilial("SA2")+_cBDI)
		_cCodSA2 := SA2->A2_COD
	Else
		_cCodSA2 := ""
	EndIf

	dbSelectArea("AC8")
	RecLock("AC8",.T.)
	AC8->AC8_ENTIDA := "SA2"
	AC8->AC8_CODENT := _cCodSA2+"01"
	AC8->AC8_CODCON := _cCodigo
	AC8->AC8_NOME   := _cBDI
	AC8->AC8_ITEM   := STRZERO(_nItem,4)
	AC8->AC8_COD    := _cCodSA2
	AC8->AC8_LOJA   := "01"
	AC8->AC8_ID     := _cID
	MSUnLock()

	FT_FSKIP()
EndDo

FT_FUSE()

Close(oLeTxt)

Return