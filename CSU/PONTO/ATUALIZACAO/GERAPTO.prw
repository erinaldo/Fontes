#INCLUDE "rwmake.ch"
#DEFINE          cEol         CHR(13)+CHR(10)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GERAPTO  � Autor � Alessandro Lima    � Data � 24/02/2006  ���
�������������������������������������������������������������������������͹��
���Descricao � Tratamento em Arquivo Texto para Geracao das Marcacoes em  ���
���          � Novo Arquivo Texto Conforme Padrao do Ponto Eletronico.    ���
�������������������������������������������������������������������������͹��
���Uso       � MP8 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GERAPTO
//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Private cPerg     := PADR("GETPTO",LEN(SX1->X1_GRUPO))
Private cString   := "SRA"
Private oGeraTxt
fAsrPerg()
pergunte(cPerg,.F.)
dbSelectArea( "SRA" )
dbSetOrder(1)
//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������
@ 200,001 TO 410,480 DIALOG oGeraTxt TITLE OemToAnsi( "Atualizacao da Matrix" )
@ 002,010 TO 095,230
@ 010,018 Say " Este programa ira gerar o arquivo texto para leitura e         "
@ 018,018 Say " apontamento.                                                   "
@ 026,018 Say "                                                                "
@ 070,128 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)
@ 070,158 BMPBUTTON TYPE 01 ACTION OkGeraTxt()
@ 070,188 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
Activate Dialog oGeraTxt Centered
Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � OKGERATXT� Autor � AP5 IDE            � Data �  28/12/04   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao chamada pelo botao OK na tela inicial de processamen���
���          � to. Executa a geracao do arquivo texto.                    ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function OkGeraTxt
Processa({|| RunCont() },"Processando...")
Close(oGeraTxt)
Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � RUNCONT  � Autor � AP5 IDE            � Data �  28/12/04   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function RunCont
Local cArqOri, cArqDest
Local cLin , cAno
Private nHdl
Pergunte(cPerg,.F.)
cArqOri  := Alltrim(mv_par01)
cArqDest := Alltrim(mv_par02)
If !File( cArqOri )
	Aviso("ATENCAO","ARQUIVO " + cArqOri + " NAO ENCONTRADO",{"Sair"})
	Return
EndIf
nHdl := fCreate( cArqDest )
If nHdl == -1
	MsgAlert("O arquivo de nome "+cArqDest+" nao pode ser executado! Verifique os parametros.","Atencao!")
	Return
Endif
// Cria Arquivo Temporario
fAsCriaDbf()
CursorWait()
dbSelectArea( "ASR" )
Append From &cArqOri SDF
CursorArrow()
cAno := Right(StrZero(Year(dDataBase),4),2)
dbGoTop()
ProcRegua(RecCount())
Do While !Eof()
	IncProc()
	If SubStr( ASR->ASR_TXT,1,13 ) == "INICIO RELAT:"
		cAno := SubStr( ASR->ASR_TXT,21,2)
	ElseIf Val(SubStr( ASR->ASR_TXT,3,6 )) > 0 .And. SubStr(ASR->ASR_TXT,93,1) == "/"
		cLin := SubStr( ASR->ASR_TXT,3,6)		// Cracha
		cLin += SubStr( ASR->ASR_TXT,94,2)		// Dia
		cLin += SubStr( ASR->ASR_TXT,91,2)		// Mes
		cLin += cAno									// Ano
		cLin += SubStr( ASR->ASR_TXT,97,2)		// Hora Entrada
		cLin += SubStr( ASR->ASR_TXT,100,2)	// Minuto Entrada
		cLin += cEol									// Finalizador da Linha
		If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo.Continua?","Atencao!")
				Exit
			Endif
		Endif
		cLin := SubStr( ASR->ASR_TXT,3,6)		// Cracha
		cLin += SubStr( ASR->ASR_TXT,107,2)	// Dia
		cLin += SubStr( ASR->ASR_TXT,104,2)	// Mes
		cLin += cAno									// Ano
		cLin += SubStr( ASR->ASR_TXT,110,2)	// Hora Saida
		cLin += SubStr( ASR->ASR_TXT,113,2)	// Minuto Saida
		cLin += cEol									// Finalizador da Linha
		If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
			If !MsgAlert("Ocorreu um erro na gravacao do arquivo.Continua?","Atencao!")
				Exit
			Endif
		Endif
	EndIf
	dbSkip()
EndDo
dbSelectArea( "ASR" )
dbCloseArea()
fClose( nHdl )
Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fAsCriaDbf�Autor  �Microsiga           � Data �  02/10/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� 
*/
Static Function fAsCriaDbf()
Local cArqDbf, cArqNtx, cIndex
Local aCampos := {}
aCampos := { { "ASR_TXT",  "C",  150,  0 } }
// Cria Arquivo Dbf Temporario
cArqDbf := CriaTrab( aCampos,.T. )
dbUseArea(.T.,,cArqDbf,"ASR",.F.)
Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �VALIDPERG � Autor � AP5 IDE            � Data �  27/10/01   ���
�������������������������������������������������������������������������͹��
���Descri��o � Verifica a existencia das perguntas criando-as caso seja   ���
���          � necessario (caso nao existam).                             ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� 
*/
Static Function fAsrPerg()
Local aRegs := {}
//Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{ cPerg,'01','Arquivo de Origem?' ,'','','mv_ch1','C',30,0,0,'G','NaoVazio'   ,'mv_par01','','','','','','','','','','','','','','','','','','','','','','','','' ,'   ','' })
aAdd(aRegs,{ cPerg,'02','Arquivo de Destino?','','','mv_ch2','C',30,0,0,'G','NaoVazio'   ,'mv_par02','','','','','','','','','','','','','','','','','','','','','','','','' ,'   ','' })
ValidPerg(aRegs,cPerg)
Return
