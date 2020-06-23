#include "rwmake.ch"

User Function GERA_PRO()

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP6 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("CPERG,NRESP,NHDL,MV_PAR06,CLIN,_SALIAS")
SetPrvt("AREGS,I,J,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa �GERATXT � Autor �Ronaldo Manoel da Silva � Data �   15/10/02���
�������������������������������������������������������������������������͹��
���Descri��o � Programa para geracao de arquivo .TXT                      ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico para Symbol                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

//���������������������������������������������������������������������Ŀ
//� Verifica as perguntas                                               �
//���������������������������������������������������������������������Ĵ
//� mv_par01    Nome do Arquivo   -  Nome do arquivo texto para geracao �
//� mv_par02    Final de Linha    -  Caracter(es) para final de linha   �
//�����������������������������������������������������������������������

cPerg := "GERTXT"

ValidPerg()

Pergunte(cPerg,.F.)

//���������������������������������������������������������������������Ŀ
//� Montagem da tela                                                    �
//�����������������������������������������������������������������������

#IFNDEF WINDOWS
	
	ScreenDraw("SMT250",3,0,0,0)
	
	@03,06 Psay "Gera��o de Arquivo Texto           " Color "B/W"
	
	@11,08 PSay " Este programa ir� gerar um arquivo texto, conforme os parame- " Color "B/BG"
	@12,08 PSay " tros definidos  pelo usuario.                                 " Color "B/BG"
	@13,08 PSay "                                                               " Color "B/BG"
	@14,08 PSay "                                                               " Color "B/BG"
	@17,04 PSay Space(53) Color "B/W"
	
	While .T.
		nResp := MenuH({"Confirma","Abandona","Par�metros"},17,04,"b/w,w+/n,r/w","CAP","",1)
		If nResp == 1
			Continua()
			Exit
		ElseIf nResp == 3
			Pergunte(cPerg,.T.)
			Loop
		Else
			Return
		Endif
	EndDo
	
#ELSE
	
	@ 200,1 TO 380,380 DIALOG oDlg TITLE OemToAnsi("Gera��o de Arquivo Texto")
	@ 02,10 TO 080,190
	@ 10,018 PSay " Este programa ir� gerar um arquivo texto, conforme os parame- "
	@ 18,018 PSay " tros definidos  pelo usuario.                                 "
	@ 26,018 PSay " "
	@ 34,018 PSay " "
	
	@ 70,108 BMPBUTTON TYPE 01 ACTION Continua()// Substituido pelo assistente de conversao do AP6 IDE em 15/10/02 ==>     @ 70,128 BMPBUTTON TYPE 01 ACTION Execute(Continua)
	@ 70,138 BMPBUTTON TYPE 02 ACTION Close(oDlg)
	@ 70,158 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)
	
	Activate Dialog oDlg Centered
	
#ENDIF

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Fun��o   � CONTINUA � Autor � Ronaldo Manoel Silva � Data �   15/10/02���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao para continuacao do processamento (na confirmacao)  ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico para Symbol                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/


Static Function Continua()


//���������������������������������������������������������������������Ŀ
//� Cria o arquivo texto                                                �
//�����������������������������������������������������������������������

nHdl  := fCreate(mv_par01)
CodUN := ""

If Empty(mv_par02)
	mv_par02 := CHR(13)+CHR(10)
Else
	mv_par02 := AllTrim(mv_par02)
	mv_par02 := &mv_par02
Endif

If nHdl == -1
	#IFNDEF WINDOWS
		Alert("O arquivo de nome "+mv_par01+" n�o p�de ser executado! Verifique os par�metros.")
	#ELSE
		MsgAlert("O arquivo de nome "+mv_par02+" n�o p�de ser executado! Verifique os par�metros.","Aten��o!")
	#ENDIF
	Return
Endif

//���������������������������������������������������������������������Ŀ
//� Inicio da pesquisa no arquivo de dados                              �
//�����������������������������������������������������������������������

dbSelectArea("SB1")
dbgotop()
dbSetOrder(1)

//���������������������������������������������������������������������Ŀ
//� Inicializa a regua de processamento                                 �
//�����������������������������������������������������������������������


#IFDEF WINDOWS
	Processa({|| RunCont()},"Processando...")// Substituido pelo assistente de conversao do AP6 IDE em 15/10/02 ==>     Processa({|| Execute(RunCont)},"Processando...")
	Return
	// Substituido pelo assistente de conversao do AP6 IDE em 15/10/02 ==>     Function RunCont
	Static Function RunCont()
	ProcRegua(RecCount())
#ELSE
	SetRegua(RecCount())
#ENDIF

//���������������������������������������������������������������������Ŀ
//� Processamento                                                       �
//�����������������������������������������������������������������������

While !EOF()
	
	//���������������������������������������������������������������������Ŀ
	//� Incrementa a regua                                                  �
	//�����������������������������������������������������������������������

	#IFNDEF WINDOWS
		IncRegua()
	#ELSE
		IncProc()
	#ENDIF

	//���������������������������������������������������������������������Ŀ
	//� Filtra os parametros                                                �
	//�����������������������������������������������������������������������
	
	
	
	//���������������������������������������������������������������������ͻ
	//� Lay-Out do arquivo Texto gerado:                                    �
	//���������������������������������������������������������������������͹
	//�Campo       � Inicio � Tamanho � Formato                             �
	//���������������������������������������������������������������������Ķ
	//� B1_COD     � 001    � 15      �                                     �
	//� B1_DESC    � 016    � 45     �                                     �
	//� B1_COD.UN. � 061    � 2       �                                     �
	//� B1_POSIPI  � 063    � 8       �                                     �
	//���������������������������������������������������������������������ͼ
	_cCod:=" "
	Dbselectarea("SA5")
	Dbsetorder(2)
	Dbseek(xfilial("SA5")+SB1->B1_COD)
	If found ()
		_cCod:=Substr(alltrim(SA5->A5_CODPRF),1,18)
	Endif
	
	if SB1->B1_UM == "KG "
		CodUN:= "10"
	elseIF SB1->B1_UM == "UN".or.SB1->B1_UM == "PC"
		CodUN:= "11"
	elseIF SB1->B1_UM == "P "
		CodUN:= "13"
	elseIF SB1->B1_UM == "MT"
		CodUN:= "14"
	elseIF SB1->B1_UM == "M2"
		CodUN:= "15"
	elseIF SB1->B1_UM == "M3"
		CodUN:= "16"
	elseIF SB1->B1_UM == "L "
		CodUN:= "17"
	elseIF SB1->B1_UM == "DZ"
		CodUN:= "20"
	elseIF SB1->B1_UM == "TL"
		CodUN:= "21"
	elseIF SB1->B1_UM == "G "
		CodUN:= "22"
	endif
	_ccod:=" "          
	
	
	//	cLin := PADR(SB1->B1_COD,15)+PADR(SB1->B1_DESC,45)+PADR(CODUN,2)
	cLin := PADR(_cCod,18)+PADR(SB1->B1_DESC,45)+PADR(CODUN,2)
	cLin := cLin +PADR(SB1->B1_POSIPI,8)+mv_par02
	
	If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		#IFNDEF WINDOWS
			If Alert("Ocorreu um erro na grava��o do arquivo "+mv_par01+";;Continua?",{"Sim","N�o"}) == 2
				Exit
			Endif
		#ELSE
			If !MsgAlert("Ocorreu um erro na grava��o do arquivo "+mv_par01+".   Continua?","Aten��o!")
				Exit
			Endif
		#ENDIF
	Endif
	
	dbSkip()
EndDo

fClose(nHdl)

#IFDEF WINDOWS
	Close(oDlg)
#ENDIF

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �VALIDPERG � Autor �  Ronaldo Manoel Silva � Data � 15/10/02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica as perguntas inclu�ndo-as caso n�o existam        ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fico para SYmbol                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/


Static Function ValidPerg()

Local aRegs := {}
LOCAL _nIndex := IndexOrd(), I, J
cPerg    := PADR(cPerg,6)

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Nome do Arquivo    ?","","","mv_ch1","C",12,0,0,"G","","mv_par01","","DEFAULT.TXT    ","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Final de Linha     ?","","","mv_ch2","C",30,0,0,"G","","mv_par02","","CHR(13)+CHR(10)","","","","","","","","","","","","","","","","","","","","","","","","",""})

LValidPerg(aRegs)

Return