#INCLUDE "rwmake.ch"
#include "topconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � AAJ0011  � Autor � Adalberto Althoff  � Data �  21/09/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Gera arquivo texto com dados das notas fiscais de saida p/ ���
���          � a prefeitura de Santo Andre                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function aaj0011


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private cPerg       := PADR("AJ0011",LEN(SX1->X1_GRUPO))
Private oGeraTxt

Private cString := "SF2"
Private cEndereco
Private cNumero
Private cNacao
Private cEstCiv
Private cConjuge

dbSelectArea("SF2")
dbSetOrder(1)

ValidPerg(cPerg)

//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������

@ 200,1 TO 380,400 DIALOG oGeraTxt TITLE OemToAnsi("Arquivo Texto Nota Control")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ir� gerar um arquivo texto, conforme os par�me- "
@ 18,018 Say " tros definidos  pelo usu�rio,  com  os  registros  do  arquivo  de "
@ 26,018 Say " Notas Fiscais de Sa�da, afim de ser importado no sistema    "
@ 34,018 Say " Nota Control, da Prefeitura Municipal de Santo Andr�.    "

@ 60,098 BMPBUTTON TYPE 01 ACTION (OkGeraTxt(),Close(oGeraTxt))
@ 60,128 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
@ 60,158 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oGeraTxt Centered

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � OKGERATXT� Autor � AP5 IDE            � Data �  21/09/04   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao chamada pelo botao OK na tela inicial de processamen���
���          � to. Executa a geracao do arquivo texto.                    ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function OkGeraTxt

//���������������������������������������������������������������������Ŀ
//� Cria o arquivo texto                                                �
//�����������������������������������������������������������������������

Private nHdl    := fCreate(mv_par01)

Private cEOL    := "CHR(13)+CHR(10)"
If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

If nHdl == -1
	MsgAlert("O arquivo de nome "+mv_par01+" nao pode ser executado! Verifique os parametros.","Atencao!")
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
���Fun��o    � RUNCONT  � Autor � AP5 IDE            � Data �  21/09/04   ���
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
                 
Local nTamLin, cLin, cCpo

_cQuery := " Select * From "+RETSQLNAME('SF2')+" Where "
_cQuery += " F2_FILIAL  Between '" + MV_PAR02       + "'  and '" + MV_PAR03       + "' and "
_cQuery += " F2_EMISSAO Between '" + DTOS(MV_PAR04) + "'  and '" + DTOS(MV_PAR05) + "' and "
_cQuery += " F2_DOC     Between '" + MV_PAR06       + "'  and '" + MV_PAR07       + "' and "
_cQuery += " F2_SERIE = '"+MV_PAR08        + "' and "
_cQuery += " D_E_L_E_T_ <> '*' "
_cQuery += " Order by F2_FILIAL,F2_DOC"

ProcRegua(050)

If Select("TRBAAJ") >0
	DBSelectArea("TRBAAJ")
	DBCloseArea()
EndIf

TCQUERY _cQuery NEW ALIAS "TRBAAJ"

DBSelectArea("TRBAAJ")

dbGoTop()
nContReg := 0
do while !eof()
	nContReg++
	dbSkip()
	IncProc("Selecionando Registros...")
enddo
dbGoTop()
ProcRegua(nContReg) // Numero de registros a processar

nSequenc := 0

While !EOF()
	
	nSequenc++         
	
	//���������������������������������������������������������������������Ŀ
	//� Incrementa a regua                                                  �
	//�����������������������������������������������������������������������
	
	IncProc("Gerando arquivo texto...")
	
	nTamLin := 65
	
	cLin    := Space(nTamLin)+cEOL // Variavel para criacao da linha do registros para gravacao
	
//  cLin := Stuff(cLin,<inicio>,<tamanho>,PADR(<string>,<tamanho>))
	cLin := Stuff(cLin,005,002,PADR("01",002))
//	cLin := Stuff(cLin,008,006,PADR(strzero(nSequenc,6),006))
	cLin := Stuff(cLin,008,006,PADR(TRBAAJ->F2_DOC,006))
	cLin := Stuff(cLin,024,002,PADR(strzero(day(stod(TRBAAJ->F2_EMISSAO)),2),002))
	cLin := Stuff(cLin,027,002,PADR(strzero(month(stod(TRBAAJ->F2_EMISSAO)),2),002))
	cLin := Stuff(cLin,030,004,PADR(strzero(year(stod(TRBAAJ->F2_EMISSAO)),4),004))
    cValor := strzero(TRBAAJ->F2_VALBRUT*100,11)
	cLin := Stuff(cLin,048,012,PADR(left(cValor,9)+"."+right(cValor,2),012))
	cLin := Stuff(cLin,035,012,PADR(left(cValor,9)+"."+right(cValor,2),012)	)
	cValor := strzero(TRBAAJ->F2_VALISS*10000/TRBAAJ->F2_BASEISS,5)
	cLin := Stuff(cLin,061,006,PADR(left(cValor,3)+"."+right(cValor,2),006))
//	cLin := Stuff(cLin,076,010,PADR(left(SM0->M0_NOMECOM,10),10))
	
	
	
	//���������������������������������������������������������������������Ŀ
	//� Gravacao no arquivo texto. Testa por erros durante a gravacao da    �
	//� linha montada.                                                      �
	//�����������������������������������������������������������������������
	
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
			Exit
		Endif
	Endif
	
	dbSkip()
EndDo


if nSequenc>0
	MsgStop("Foram geradas "+alltrim(str(nSequenc))+" notas em "+chr(13)+alltrim(mv_par01))
else 
	MsgStop("Verifique os par�metros, pois n�o existem dados a serem gerados em "	+chr(13)+alltrim(mv_par01))
endif	

//���������������������������������������������������������������������Ŀ
//� O arquivo texto deve ser fechado, bem como o dialogo criado na fun- �
//� cao anterior.                                                       �
//�����������������������������������������������������������������������

fClose(nHdl)
//Close(oGeraTxt)

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � VALIDPERG� Autor � Adalberto Althoff  � Data �  21/09/04   ���
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
_cPerg := PADR(Pg,LEN(SX1->X1_GRUPO))
aRegs:={}

aAdd(aRegs,{_cPerg,"01","Nome do Arquivo?","","","mv_ch1","C",60,0,0,"G","            ","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","          "})
aAdd(aRegs,{_cPerg,"02","Filial     De  ?","","","mv_ch2","C",02,0,0,"G","            ","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SM0","","",".RHFILDE. "})
aAdd(aRegs,{_cPerg,"03","Filial     Ate ?","","","mv_ch3","C",02,0,0,"G","            ","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SM0","","",".RHFILAT. "})
aAdd(aRegs,{_cPerg,"04","Emissao    De  ?","","","mv_ch4","D",08,0,0,"G","            ","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","          "})
aAdd(aRegs,{_cPerg,"05","Emissao    Ate ?","","","mv_ch5","D",08,0,0,"G","            ","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","          "})
aAdd(aRegs,{_cPerg,"06","Nota       De  ?","","","mv_ch6","C",06,0,0,"G","            ","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","          "})
aAdd(aRegs,{_cPerg,"07","Nota       Ate ?","","","mv_ch7","C",06,0,0,"G","            ","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","          "})
aAdd(aRegs,{_cPerg,"08","Serie          ?","","","mv_ch8","C",03,0,0,"G","            ","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","          "})

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


