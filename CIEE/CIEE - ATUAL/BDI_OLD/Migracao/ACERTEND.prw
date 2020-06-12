#include "rwmake.ch"
#include "TOPCONN.CH"

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


User Function ACERTEND()
                                                         	
dbSelectArea("SZT")
dbSetOrder(1)

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

Static Function OkLeTxt()

Processa({|| RunCont() },"Processando...")

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

Static Function RunCont()

_cQuery := ""

DbSelectArea("SZT")
DbSetOrder(3)
DbGotop()
ProcRegua(RecCount())

Do While !EOF()
	
	IncProc()
	
	DbSelectArea("SZS")
	DbSetOrder(2)
	If DbSeek(xFilial("SZS")+"J"+SZT->ZT_CODENT)
		If alltrim(SZT->ZT_END) == alltrim(SZS->ZS_END)
			RecLock("SZT",.F.)
			SZT->ZT_BAIRRO 	:= SZS->ZS_BAIRRO
			SZT->ZT_MUN 	:= SZS->ZS_MUN
			SZT->ZT_EST		:= SZS->ZS_EST
			SZT->ZT_CEP		:= SZS->ZS_CEP
			MsUnLock()
		Else
			DbSetOrder(1)
			If DbSeek(xFilial("SZS")+"F"+SZT->ZT_CODCONT)
				If alltrim(SZT->ZT_END) == alltrim(SZS->ZS_END)
					RecLock("SZT",.F.)
					SZT->ZT_BAIRRO 	:= SZS->ZS_BAIRRO
					SZT->ZT_MUN 	:= SZS->ZS_MUN
					SZT->ZT_EST		:= SZS->ZS_EST
					SZT->ZT_CEP		:= SZS->ZS_CEP
					MsUnLock()				
				Else
					_cQuery := "SELECT * "
					_cQuery += "FROM SZS020 "
					_cQuery += "WHERE D_E_L_E_T_ <> '*' "
					_cQuery += "AND ZS_END = '"+alltrim(SZT->ZT_END)+"'"
					TcQuery _cQuery New Alias "TMP"

					DbSelectArea("TMP")
					DbGotop()
					RecLock("SZT",.F.)
					SZT->ZT_BAIRRO 	:= TMP->ZS_BAIRRO
					SZT->ZT_MUN 	:= TMP->ZS_MUN
					SZT->ZT_EST		:= TMP->ZS_EST
					SZT->ZT_CEP		:= TMP->ZS_CEP
					MsUnLock()
					TMP->(DbCloseArea())
				EndIf
			EndIf
		EndIf
	EndIf
	
	DbSelectArea("SZT")
	DbSkip()
EndDo

Return