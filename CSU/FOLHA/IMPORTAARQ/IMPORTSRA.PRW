#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �IMPORTSRA � Autor � Isamu Kawakami     � Data �  21/06/2011 ���
�������������������������������������������������������������������������͹��
���Descricao � Importar campos do cadastro de funcionarios, a partir de   ���
���          � um arquivo texto                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function ImportSRA


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Private lPis   
Private lBcoAg                              
Private cPerg       := "IMPORTSRA"
Private oLeTxt


ValidPerg(cPerg)

//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������
@ 200,1 TO 380,380 DIALOG oLeTxt TITLE OemToAnsi("Importacao de campos - cadastro de funcionarios")
@ 02,10 TO 080,190
@ 10,010 Say " Este programa fara a importacao de campos do cadastro de funcionarios,    "
@ 18,010 Say " a partir de um arquivo texto, de acordo com os parametros definidos pelo  "
@ 26,010 Say " usuario.                                                                  "

@ 70,098 BMPBUTTON TYPE 01 ACTION OkLeTxt()
@ 70,128 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)
@ 70,158 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oLeTxt Centered

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � OKLETXT  � Autor � AP6 IDE            � Data �  18/05/06   ���
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

Private nHdl    := fOpen(mv_par01,68)

Private cEOL    := "CHR(13)+CHR(10)"

If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

If nHdl == -1
	MsgAlert("O arquivo de nome "+mv_par01+" nao pode ser aberto! Verifique os parametros.","Atencao!")
	Return
Endif

If Mv_Par02 == 1
   lPis   := .T.
ElseIf Mv_Par02 == 2
   lBcoAg := .T.
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
���Fun��o    � RUNCONT  � Autor � AP5 IDE            � Data �  18/05/06   ���
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
//�Campo           � Inicio � Tamanho                               �
//�����������������������������������������������������������������Ķ
//� P.I.S.         �        �                                       �
//� Filial         � 01     � 02                                    �
//� Matricula      � 03     � 06                                    �
//� PIS            � 09     � 11                                    �
//�����������������������������������������������������������������Ķ
//� Bco/Agencia/CC �        �                                       �
//� Filial         � 01     � 02                                    �
//� Matricula      � 03     � 06                                    �
//� Banco          � 09     � 03                                    �
//� Agencia        � 12     � 05                                    �
//� Conta Corrente � 17     � 12                                    �
//�����������������������������������������������������������������ͼ

nTamFile := fSeek(nHdl,0,2)
fSeek(nHdl,0,0)

If lPis //PIS
   nTamLin  := 19+Len(cEOL)
ElseIf lBcoAg  //Banco/Agencia/CC
   nTamLin  := 27+Len(cEOL)
Endif
   
cBuffer  := Space(nTamLin) // Variavel para criacao da linha do registro para leitura

nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da primeira linha do arquivo texto

ProcRegua(nTamFile) // Numero de registros a processar

While nBtLidos >= nTamLin
	
	//���������������������������������������������������������������������Ŀ
	//� Incrementa a regua                                                  �
	//�����������������������������������������������������������������������
	
	Fil  := Substr(cBuffer,01,2)
	Mat  := Substr(cBuffer,03,6) 
	
	If lPis //PIS
	   PIS := Substr(cBuffer,09,11)  
	ElseIf lBcoAg //Bco/Ag/CC
	   Banco   := Substr(cBuffer,09,03)
	   Agencia := Substr(cBuffer,12,04)
	   Conta   := Substr(cBuffer,17,12)
	Endif
	    
    IncProc( "Processando "+"Filial: "+Fil+"-"+"Matricula: "+Mat )

	//���������������������������������������������������������������������Ŀ
	//� Grava os campos obtendo os valores da linha lida do arquivo texto.  �
	//�����������������������������������������������������������������������
	dbSelectArea("SRA")
	dbSetOrder(1)
	dbSeek(Fil+Mat)

	IF FOUND()
	   
		  If lPis		  
			RecLock("SRA",.F.)
		     SRA->RA_PIS := PIS
		    MsUnlock()
		  Endif
		  
		  If lBcoAg
			RecLock("SRA",.F.)
		     SRA->RA_BCDEPSA := StrZero(Val(Banco),3)+StrZero(Val(Agencia),4)
		     SRA->RA_CTDEPSA := StrZero(Val(Conta),12)
		    MsUnlock()
		  Endif
		     
	ENDIF
	
	//���������������������������������������������������������������������Ŀ
	//� Leitura da proxima linha do arquivo texto.                          �
	//�����������������������������������������������������������������������
	
	nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da proxima linha do arquivo texto
	
	dbSkip()

EndDo

//���������������������������������������������������������������������Ŀ
//� O arquivo texto deve ser fechado, bem como o dialogo criado na fun- �
//� cao anterior.                                                       �
//�����������������������������������������������������������������������

fClose(nHdl)
Close(oLeTxt)

Return
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � VALIDPERG� Autor � Adalberto Althoff  � Data �  20/03/06   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar, VALIDADA PARA AP7                         ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function ValidPerg(Pg)

_sAlias := Alias()

dbSelectArea("SX1")
dbSetOrder(1)

_cPerg := PADR(Pg,10)
aRegs:={}

aAdd(aRegs,{_cPerg,"01","Arquivo:          ","","","mv_ch1","C",60,0,0,"G","            ","mv_par01","   ","","","","","             ","","","","","     ","","","","","","","","","","","","","","   ","","","          "})
aAdd(aRegs,{_cPerg,"02","Campo a Importar: ","","","mv_ch2","N",07,0,0,"C","            ","mv_par02","PIS","PIS","PIS","","","Banco/Agencia/CC","Banco/Agencia/CC","Banco/Agencia/CC","","","     ","","","","","","","","","","","","","","   ","","","          "}) 

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
