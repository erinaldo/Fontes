#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TBICONN.CH"
#define CMD_OPENWORKBOOK			1
#define CMD_CLOSEWORKBOOK			2   
#define CMD_ACTIVEWORKSHEET		3    
#define CMD_READCELL				4
/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa   �GetExcel  � Autor � Jaime Wikanski            �Data�04.11.2002���
����������������������������������������������������������������������������͹��
���Descricao  �Funcao para leitura e retorno em um array do conteudo         ���
���           �de uma planilha excel                                         ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
User Function GetExcel(cArqPlan,cPlan,cCelIni,cCelFim,nColChave /*Casa celula em branco para a leitura*/)
//�������������������������������������������������������������������������Ŀ
//� Declaracao de variaveis                             		     	    �
//���������������������������������������������`������������������������������
Local aReturn		:= {}

DEFAULT nColChave := 0

//��������������������������������������������������������������������������Ŀ
//� Processa a interface de leitura da planilha excel                        �
//����������������������������������������������������������������������������
Processa({|| aReturn := LeExcel(cArqPlan,cPlan,cCelIni,cCelFim,nColChave)} ,"Planilha Excel")
Return(aReturn)

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa   �LeExcel   � Autor � Jaime Wikanski            �Data�04.11.2002���
����������������������������������������������������������������������������͹��
���Descricao  �Funcao para leitura e retorno em um array do conteudo         ���
���           �de uma planilha excel                                         ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Static Function LeExcel(cArqPlan,cPlan,cCelIni,cCelFim,nColChave)

//�������������������������������������������������������������������������Ŀ
//� Declaracao de variaveis                             		     	    �
//���������������������������������������������������������������������������
Local aReturn		:= {}
Local nLin			:= 0
Local nCol			:= 0
Local nLinIni		:= 0
Local nLinFim		:= 0
Local nColIni		:= 0
Local nColFim		:= 0
Local nMaxLin		:= 0
Local nMaxCol		:= 0
Local cDigCol1		:= ""
Local cDigCol2		:= ""
Local nHdl 			:= 0
Local cBuffer		:= "'
Local cCell 		:= ""     
Local cFile			:= ""
Local nPosIni		:= 0
Local aNumbers		:= {"0","1","2","3","4","5","6","7","8","9"}
Local nX			:= 0
Local nColArr		:= 0
Default cArqPlan	:= ""
Default cPlan		:= ""
Default cCelIni		:= ""
Default cCelFim		:= ""

//�������������������������������������������������������������������������Ŀ
//� Valida os parametros informados pelo usuario        		     	    �
//���������������������������������������������������������������������������
If Empty(cArqPlan)
	Aviso("Inconsist�ncia","Informe o diret�rio e o nome da planilha a ser processada.",{"Sair"},,"Aten��o:")
	Return(aReturn)
Endif
If Empty(cPlan)
	Aviso("Inconsist�ncia","Informe nome do Folder da planilha a ser processada.",{"Sair"},,"Aten��o:")
	Return(aReturn)
Endif
If Empty(cCelIni)
	Aviso("Inconsist�ncia","Informe a refer�ncia da c�lula inicial a ser processada.",{"Sair"},,"Aten��o:")
	Return(aReturn)
Endif
If Empty(cCelFim)
	Aviso("Inconsist�ncia","Informe a refer�ncia da c�lula final a ser processada.",{"Sair"},,"Aten��o:")
	Return(aReturn)
Endif
If !File(cArqPlan)
	Aviso("Inconsist�ncia","N�o foi poss�vel localizar a planilha "+Alltrim(cArqPlan)+" especificada.",{"Sair"},,"Aten��o:")
	Return(aReturn)
Else
	cFile := Alltrim(cArqPlan)
Endif

//�������������������������������������������������������������������������Ŀ
//� Copia a DLL de interface com o excel                		     	    �
//���������������������������������������������������������������������������
If !CpDllXls()
	Return(aReturn)
Endif

//�������������������������������������������������������������������������Ŀ
//� Processa a coordenada inicial da celula             		     	    �
//���������������������������������������������������������������������������
nPosIni	:= 0
For nX := 1 to Len(Alltrim(cCelIni))
	If aScan(aNumbers, Substr(cCelIni,nX,1)) > 0
		nPosIni	:= nX
		Exit
	Endif
Next nX
If nPosIni == 0
	Aviso("Inconsist�ncia","N�o foi possivel determinar a refer�ncia num�rica da linha inicial a ser processada. Verifique a refer�ncia da c�lula inicial informada.",{"Sair"},,"Aten��o:")
	Return(aReturn)
Endif
nLinIni := Val(Substr(cCelIni,nPosIni,(Len(cCelIni)-nPosIni)+1))

cDigCol1 := Alltrim(Substr(cCelIni,1,nPosIni-1))
If Len(cDigCol1) == 2
	cDigCol1 	:= Substr(cCelIni,1,1)
	cDigCol2 	:= Substr(cCelIni,2,1)
	nColIni		:= ((Asc(cDigCol1)-64)*26) + (Asc(cDigCol2)-64) 
Else
	cDigCol1 	:= Substr(cCelIni,1,1)
	cDigCol2 	:= ""
	nColIni		:= Asc(cDigCol1)-64
Endif             

//�������������������������������������������������������������������������Ŀ
//� Processa a coordenada final   da celula             		     	    �
//���������������������������������������������������������������������������
nPosIni	:= 0
For nX := 1 to Len(Alltrim(cCelFim))
	If aScan(aNumbers, Substr(cCelFim,nX,1)) > 0
		nPosIni	:= nX
		Exit
	Endif
Next nX
If nPosIni == 0
	Aviso("Inconsist�ncia","N�o foi possivel determinar a refer�ncia num�rica da linha final a ser processada. Verifique a refer�ncia da c�lula final informada.",{"Sair"},,"Aten��o:")
	Return(aReturn)
Endif
nLinFim := Val(Substr(cCelFim,nPosIni,(Len(cCelFim)-nPosIni)+1))

cDigCol1 := Alltrim(Substr(cCelFim,1,nPosIni-1))
If Len(cDigCol1) == 2
	cDigCol1 	:= Substr(cCelFim,1,1)
	cDigCol2 	:= Substr(cCelFim,2,1)
	nColFim		:= ((Asc(cDigCol1)-64)*26) + (Asc(cDigCol2)-64) 
Else
	cDigCol1 	:= Substr(cCelFim,1,1)
	cDigCol2 	:= ""
	nColFim		:= Asc(cDigCol1)-64
Endif             

//�������������������������������������������������������������������������Ŀ
//� Determina o total de linhas e colunas               		     	    �
//���������������������������������������������������������������������������
nMaxLin := nLinFim - nLinIni + 1
nMaxCol := nColFim - nColIni + 1

//��������������������������������������������������������������������������Ŀ
//� Abre a DLL de interface excel                                            �
//����������������������������������������������������������������������������
nHdl := ExecInDLLOpen(Alltrim(GetMv("MV_DRDLLXLS",,"c:\apexcel"))+'\readexcel.dll')

If nHdl < 0
	Aviso("Inconsist�ncia","N�o foi poss�vel carregar a DLL de interface com o Excel (readexcel.dll).",{"Sair"},,"Aten��o:")
	Return(aReturn)
Endif

//��������������������������������������������������������������������������Ŀ
//� Carrega o excel e abre o arquivo                                         �
//����������������������������������������������������������������������������
cBuffer := cFile+Space(512)
nBytes  := ExeDLLRun2(nHdl, CMD_OPENWORKBOOK, @cBuffer)
	
//��������������������������������������������������������������������������Ŀ
//� Valida se abriu a planilha corretamente                                  �
//����������������������������������������������������������������������������
If nBytes < 0
	Aviso("Inconsist�ncia","N�o foi poss�vel abrir a planilha Excel solicitada ("+Alltrim(cFile)+").",{"Sair"},,"Aten��o:")
	Return(aReturn)
ElseIf nBytes > 0
	//��������������������������������������������������������������������������Ŀ
	//� Erro critico na abertura do arquivo com msg de erro						 �
	//����������������������������������������������������������������������������
	Aviso("Inconsist�ncia","N�o foi poss�vel abrir a planilha Excel solicitada ("+Alltrim(cFile)+"). "+Chr(13)+Chr(10)+"Erro interno: "+Subs(cBuffer, 1, nBytes),{"Sair"},,"Aten��o:")
	Return(aReturn)
EndIf                           
	
//��������������������������������������������������������������������������Ŀ
//� Seleciona a worksheet                                  					 �
//����������������������������������������������������������������������������
cBuffer := Alltrim(cPlan)+Space(512)
nBytes 	:= ExeDLLRun2(nHdl,CMD_ACTIVEWORKSHEET,@cBuffer)   

//��������������������������������������������������������������������������Ŀ
//� Valida se selecionou o worksheet solicitado                              �
//����������������������������������������������������������������������������
If nBytes < 0
	Aviso("Inconsist�ncia","N�o foi poss�vel selecionar a WorkSheet solicitada ("+Alltrim(cPlan)+") na planilha Excel ("+Alltrim(cFile)+").",{"Sair"},,"Aten��o:")
	cBuffer := Space(512)
	ExeDLLRun2(nHdl, CMD_CLOSEWORKBOOK, @cBuffer)
	ExecInDLLClose(nHdl)
	Return(aReturn)
ElseIf nBytes > 0
	//��������������������������������������������������������������������������Ŀ
	//� Erro critico na abertura do arquivo com msg de erro						 �
	//����������������������������������������������������������������������������
	Aviso("Inconsist�ncia","N�o foi poss�vel selecionar a WorkSheet solicitada ("+Alltrim(cPlan)+") na planilha Excel ("+Alltrim(cFile)+")."+Chr(13)+Chr(10)+"Erro interno: "+Subs(cBuffer, 1, nBytes),{"Sair"},,"Aten��o:")
	cBuffer := Space(512)
	ExeDLLRun2(nHdl, CMD_CLOSEWORKBOOK, @cBuffer)
	ExecInDLLClose(nHdl)
	Return(aReturn)
EndIf                           

//��������������������������������������������������������������������������Ŀ
//� Define a regua de processamento                                          �
//����������������������������������������������������������������������������
ProcRegua(nMaxLin*nMaxCol)

//�������������������������������������������������������������������������Ŀ
//� Gera o array com todas as coordenadas necessarias   		     	    �
//���������������������������������������������������������������������������
For nLin := nLinIni to nLinFim
	//��������������������������������������������������������������������������Ŀ
	//� Adiciona no array a linja a ser importada                                �
	//����������������������������������������������������������������������������
	Aadd(aReturn, Array(nMaxCol))
	
	//��������������������������������������������������������������������������Ŀ
	//� Processa as colunas da linha atual                                       �
	//����������������������������������������������������������������������������
	nColArr := 0
	For nCol := nColIni to nColFim
		nColArr++	
		If Int((nCol/26)-0.01) > 0
			cDigCol1 := Chr(Int((nCol/26)-0.01)+64)
		Else
			cDigCol1 := " "
		Endif
		If nCol - (Int((nCol/26)-0.01)*26) > 0
			cDigCol2 := Chr((nCol - (Int((nCol/26)-0.01)*26))+64)
		Else
			cDigCol2 := " "
		Endif
		//��������������������������������������������������������������������������Ŀ
		//� Incrementa a regua de processamento                                      �
		//����������������������������������������������������������������������������
		IncProc("Importando planilha...")                                

		//��������������������������������������������������������������������������Ŀ
		//� Compoe a coordenada da celula a ser importada                            �
		//����������������������������������������������������������������������������
		cCell := Alltrim(cDigCol1)+Alltrim(cDigCol2)+Alltrim(Str(nLin))

		//��������������������������������������������������������������������������Ŀ
		//� Realiza a leitura da celula no excel                                     �
		//����������������������������������������������������������������������������
		cBuffer := cCell+Space(1024)
		nBytes 	:= ExeDLLRun2(nHdl, CMD_READCELL, @cBuffer)
		//aReturn[nLin,nCol] := Subs(cBuffer, 1, nBytes)
		aReturn[Len(aReturn),nColArr] := Subs(cBuffer, 1, nBytes)
	Next nCol
	
	If nColChave > 0 .And. nColChave <= LEN(aReturn[Len(aReturn)])
	   If EMPTY(aReturn[Len(aReturn),nColChave])
	      Exit
	   EndIf
	EndIf
Next nLin

//��������������������������������������������������������������������������Ŀ
//� Fecha a interface com o excel                                            �
//����������������������������������������������������������������������������
cBuffer := Space(512)
ExeDLLRun2(nHdl, CMD_CLOSEWORKBOOK, @cBuffer)
ExecInDLLClose(nHdl)

Return(aReturn)
                
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CpDllXls  �Autor  �Jaime Wikanski      � Data �  05/17/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �Funcao para copiar a DLL para a esta��o do usuario          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CpDllXls()

//�������������������������������������������������������������������������������Ŀ
//�Declaracao de variaveis                                                        �
//���������������������������������������������������������������������������������
Local cDirDest	:= Alltrim(GetMv("MV_DRDLLXLS",,"c:\apexcel"))
Local nResult	:= 0
Local lReturn	:= .T.

//�������������������������������������������������������������������������������Ŀ
//�Cria o diretorio de destino da DLL na estacao do usuario                       �
//���������������������������������������������������������������������������������
If !lIsDir(cDirDest)
	nResult := MakeDir(cDirDest)
Endif
If nResult <> 0
	Aviso("Inconist�ncia","N�o foi poss�vel criar o diret�rio "+cDirDest+" para a DLL de leitura da planilha Excel.",{"Sair"},,"Aten��o:")
	lReturn := .F.
Else
	//�������������������������������������������������������������������������������Ŀ
	//�Copia a DLL para o diretorio na estacao do usuario                             �
	//���������������������������������������������������������������������������������
	If !File("ReadExcel.dll")
		Aviso("Inconist�ncia","N�o foi poss�vel localizar a DLL de leitura da planilha excel (ReadExcel.dll) no diret�rio SYSTEM ou SIGAADV.",{"Sair"},,"Aten��o:")
		lReturn := .F.
	Else		
		If !File(cDirDest+"\ReadExcel.dll")
			COPY FILE ("ReadExcel.dll") TO (cDirDest+"\ReadExcel.dll")
			If !File(cDirDest+"\ReadExcel.dll")
				Aviso("Inconist�ncia","N�o foi poss�vel copiar a DLL de leitura da planilha excel para o diret�rio "+cDirDest+".",{"Sair"},,"Aten��o:")
				lReturn := .F.
			Endif
		Endif
	Endif
Endif

Return(lReturn)


/*
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
��� Programa    � QryArr   � Executa uma query retornando os dados em um array com a ordem���
���             �          � pela sintaxe da select da query.                             ���
�����������������������������������������������������������������������������������������͹��
��� Solicitante � ??.??.?? � Ignorado                                                     ���
�����������������������������������������������������������������������������������������͹��
��� Autor       � ??.??.?? � Silvio Gazela                                                ���
�����������������������������������������������������������������������������������������͹��
��� Produ��o    � 99.99.99 � Ignorado                                                     ���
�����������������������������������������������������������������������������������������͹��
��� Par�metros  � ExpC1 = query a ser executada                                           ���
�����������������������������������������������������������������������������������������͹��
��� Retorno     � ExpA1 = array com o resultado da query                                  ���
�����������������������������������������������������������������������������������������͹��
��� Observa��es �                                                                         ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������͹��
��� Altera��es  � 99/99/99 - Consultor - Descricao da altera��o                           ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
*/
Static Function QryArr(cQuery,aRet)

Local aAreaAtu	:= GetArea()
Local aRet1		:= {}
Local nRegAtu	:= 0
Local x			:= 0

TCQUERY cQuery NEW ALIAS "_TRB"

DbSelectArea("_TRB")
aRet1	:= Array(fCount())
nRegAtu	:= 1

While !Eof()
	For x:=1 to fCount()
		aRet1[x] := FieldGet(x)
	Next
	AADD(aRet,aclone(aRet1))
	DbSkip()
	nRegAtu += 1
Enddo

DbSelectArea("_TRB")
_TRB->(DbCloseArea())

Return(aRet)