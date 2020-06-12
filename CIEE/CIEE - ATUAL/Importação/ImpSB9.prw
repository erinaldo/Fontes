#INCLUDE "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ImpSB9    � Autor � Felipe Raposo      � Data �  02/09/02   ���
�������������������������������������������������������������������������͹��
���Descricao �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CIEE                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function ImpSB9()
MSGBOX("NAO PODE")
RETURN

SB1->(dbGoTop())
Do While SB1->(!eof())
	RecLock("SB9", .T.)
	SB9->B9_FILIAL := xFilial("SB9")
	SB9->B9_COD    := SB1->B1_COD
	SB9->B9_LOCAL  := SB1->B1_LOCPAD
	SB9->(msUnLock())
	SB1->(dbSkip())
EndDo

MSGBOX("Finished")
RETURN









//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Private oLeTxt
Private cString := "SB9"
dbSelectArea("SB9")
dbSetOrder(1)

//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������
@ 200,1 TO 380,380 DIALOG oLeTxt TITLE OemToAnsi("Leitura de Arquivo Texto")
@ 02,10 TO 080,190
@ 10,018 Say "Este programa ira ler o conteudo de um arquivo texto, conforme   "
@ 18,018 Say "os parametros definidos pelo usuario, com os registros do arquivo"
@ 26,018 Say "SB9                                                              "
@ 70,128 BMPBUTTON TYPE 01 ACTION OkLeTxt()
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)
Activate Dialog oLeTxt Centered
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � OKLETXT  � Autor � AP6 IDE            � Data �  02/09/02   ���
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

//���������������������������������������������������������������������Ŀ
//� Abertura do arquivo texto                                           �
//�����������������������������������������������������������������������
Private cArqTxt := "\TEMP\MATERIAL.TXT"
Private nHdl    := fOpen(cArqTxt, 68)
Private cEOL    := CHR(13)+CHR(10)
Private _cDelim := "|"

If nHdl == -1
	MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser aberto! Verifique os parametros.","Atencao!")
	Return
Endif

//���������������������������������������������������������������������Ŀ
//� Inicializa a regua de processamento                                 �
//�����������������������������������������������������������������������
Processa({|| RunCont() },"Processando...")
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � RUNCONT  � Autor � AP5 IDE            � Data �  02/09/02   ���
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

//�����������������������������������������������������������������ͻ
//� Lay-Out do arquivo Texto gerado:                                �
//�����������������������������������������������������������������͹
//�Campo           �Tamanho � Decimal                               �
//�����������������������������������������������������������������Ķ
//� B9_CODANT (C)  � 07     � 00                                    �
//� B9_VINI1  (N)  �        � 04                                    �
//� B9_QINI   (N)  �        � 02                                    �
//�����������������������������������������������������������������ͼ
_aCpo := {"B9_CODANT", "", "B9_QINI", "B9_VINI1"}
_aValCpo := {}

SB1->(dbSetOrder(8))
SB9->(dbSetOrder(1))
nTamFile := fSeek(nHdl,0,2)
fSeek(nHdl,0,0)
nTamLin  := 17+Len(cEOL)
cBuffer  := Space(nTamLin) // Variavel para criacao da linha do registro para leitura.
ProcRegua(nTamFile) // Numero de caracteres a processar.
_lShowUp := .T.
_lShow2 := .T.
Do While fSeek(nHdl,0,1) < nTamFile
	
	_cLin := ""
	Do While !(cEOL $ _cLin) .and. fSeek(nHdl,0,1) < nTamFile
		//���������������������������������������������������������������������Ŀ
		//� Incrementa a regua                                                  �
		//�����������������������������������������������������������������������
		IncProc()
		fRead(nHdl, @cBuffer, 1)
		_cLin += cBuffer
	EndDo
	_cLin := IIf (fSeek(nHdl,0,1) < nTamFile, SubStr(_cLin, 1, len(_cLin) - 1), _cLin)
	_lShowUp := (_lShowUp .and. MsgYesNo(_cLin))
	
	_aValCpo := {}
	_nPos    := 1
	For _nAux1 := 1 to len(_aCpo)
		_cCpo   := ""
		cBuffer := ""
		Do While cBuffer != _cDelim .and. !(cBuffer $ cEOL)
			_cCpo += cBuffer
			cBuffer := SubStr(_cLin, _nPos, 1)
			_nPos ++
		EndDo
		// _nPos ++
		aAdd(_aValCpo, &(_cCpo))
	Next _nAux1
	
	If _aValCpo[3] != 0 .and. SB1->(dbSeek(xFilial("SB1") + _aValCpo[1], .F.))
		_cCOD   := SB1->B1_COD
		_cLOCAL := SB1->B1_LOCPAD
		If empty(SB1->B1_CONV)
			_cQINI    := _aValCpo[3]
			_cQISEGUM := 0
		Else
			_cQISEGUM := _aValCpo[3]
			_cQINI    := _cQISEGUM / SB1->B1_CONV
		Endif
		_cVINI1 := _aValCpo[4]
		//���������������������������������������������������������������������Ŀ
		//� Grava os campos obtendo os valores da linha lida do arquivo texto.  �
		//�����������������������������������������������������������������������
		dbSelectArea(cString)
		If !(dbSeek(xFilial("SB9") + _cCOD + _cLOCAL + dtos(ctod("27/08/02")), .F.))
			RecLock(cString, .T.)
			SB9->B9_FILIAL  := xFilial("SB9")
			SB9->B9_COD     := _cCOD
			SB9->B9_LOCAL   := _cLOCAL
			SB9->B9_DATA    := ctod("27/08/02")
		Else
			RecLock(cString, .F.)
		Endif
		SB9->B9_QINI    := _cQINI
		SB9->B9_QISEGUM := _cQISEGUM
		SB9->B9_VINI1   := _cVINI1
		MSUnLock()
	Else
		_lShow2 := _lShow2 .and. _aValCpo[3] != 0 .and. MsgYesNo(_aValCpo[1] + " not found!")
	Endif
EndDo

//���������������������������������������������������������������������Ŀ
//� O arquivo texto deve ser fechado, bem como o dialogo criado na fun- �
//� cao anterior.                                                       �
//�����������������������������������������������������������������������
fClose(nHdl)
Close(oLeTxt)
Return