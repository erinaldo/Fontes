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

User Function IMP_CON()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private oLeTxt

dbSelectArea("SU5")
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

FT_FUSE("C:\Ap8\Protheus_Data\CSV\Contatos.txt")
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
	_cContat	:=	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),500)
	_cNome		:=	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),500)	
	_cSEXO		:=	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),500)
	_cEND  		:=	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),500)
	_cBAIRRO	:=	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),500)
	_cMUN		:= 	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),500)
	_cEST	  	:= 	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),500)
	_cCEP  		:= 	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),500)
	_cDDD 		:=	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),500)
	_cFONE 		:= 	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),500)
	_cFCOM1 	:= 	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),500)
	_cFAX  		:= 	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),500)
	_cEMAIL		:= 	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),500)
	_cDESC		:= 	Substr(cBuffer,1,(At(";",cBuffer)-1)) //CARGO

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),500)
	_cDTINCLU	:= 	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),500)
	_cDTALTER	:= 	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),500)
	_cDNIVEL 	:= 	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),500)
	_cTIPOEND	:= 	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),500)
	_cDGRUPO 	:= 	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),500)
	_cDECISAO	:= 	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),500)
	_cTITULO	:= 	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),500)
	_cPAIS		:= 	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),500)
	_cAC		:= 	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),500)
	_cAUTORIZ	:= 	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),500)
	_cMOTIVO 	:= 	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),500)
	_cMAILPAD	:= 	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer 	:=	Substr(cBuffer,(At(";",cBuffer)+1),500)
	_cID		:= 	alltrim(cBuffer)
	
	dbSelectArea("SU5")
	RecLock("SU5",.T.)
	SU5->U5_CODCONT	:= _cContat
	SU5->U5_CONTAT	:= _cNome
	SU5->U5_SEXO	:= IIF(_cSEXO=="M","1","2")
	SU5->U5_END  	:= _cEND
	SU5->U5_BAIRRO	:= _cBAIRRO
	SU5->U5_MUN		:= _cMUN
	SU5->U5_EST  	:= _cEST
	SU5->U5_CEP  	:= _cCEP
	SU5->U5_DDD 	:= _cDDD
	SU5->U5_FONE 	:= _cFONE
	SU5->U5_FCOM1 	:= _cFCOM1
	SU5->U5_FAX  	:= _cFAX 
	SU5->U5_EMAIL	:= _cEMAIL
	SU5->U5_DESC	:= _cDESC
	SU5->U5_DTINCLU	:= ctod(_cDTINCLU)
	SU5->U5_DTALTER	:= ctod(_cDTALTER)
	SU5->U5_DNIVEL 	:= _cDNIVEL
	SU5->U5_TIPOEND	:= IIF(SUBSTR(_cTIPOEND,1,1)=="R","1","2")
	SU5->U5_DGRUPO 	:= _cDGRUPO
	SU5->U5_DECISAO	:= _cDECISAO
	SU5->U5_TITULO	:= _cTITULO
	SU5->U5_PAIS	:= _cPAIS
	SU5->U5_AC		:= _cAC
	SU5->U5_AUTORIZ	:= IIF(SUBSTR(_cAUTORIZ,1,1)=="S","1","2")
	SU5->U5_MOTIVO 	:= _cMOTIVO
	SU5->U5_MAILPAD	:= _cMAILPAD
	SU5->U5_ID		:= _cID
	MSUnLock()

	FT_FSKIP()
EndDo

FT_FUSE()

Close(oLeTxt)

Return