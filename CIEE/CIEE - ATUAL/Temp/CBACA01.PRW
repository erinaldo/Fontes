#Include "PROTHEUS.CH"
#Include 'Rwmake.ch'
#Include 'TopConn.ch'
#define STR0011 "Aten��o"
#define STR0025 "O CNPJ informado j� foi utilizado no fornecedor "
#define STR0026 "O CPF informado j� foi utilizado no fornecedor "
#define STR0027 "Aceitar"
#define STR0028 "Cancelar"
#define STR0035 "A base do CNPJ informado j� foi utilizada no fornecedor "

// Gera relatorio e planilha com dados inconsistentes para SPED Fiscal
User Function CBACA01()

//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
Local cDesc1    := "Este relatorio ira imprimir inconsistencias na base de "
Local cDesc2    := "dados, para facilitar a identifica��o de registros que "
Local cDesc3    := "deverao ser saneados"
Local wnrel
Local cString   := "SA2"
Local Tamanho   := "G"

Private titulo  := "Rela��o de Inconsistencias na Base de Dados"
Private cabec1
Private cabec2
Private aReturn := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 2, 2, 1, "",1 }
Private nomeprog:= "CBACA01"
Private aLinha  := { },nLastKey := 0
Private cPerg   := "CBACA01"

//��������������������������������������������������������������Ŀ
//� Definicao dos Cabecalhos                                     �
//����������������������������������������������������������������
titulo := OemToAnsi("Relacao de Inconsistencias na Base de Dados")

cabec1 := OemToAnsi("CODIGO  LOJA  NOME                  CNPJ/CPF            ENDERECO                                      MUNICIPIO        COD.MUN.   UF  PAIS")
//                   0         10        20        30        40        50        60        70        80        90        100       110       120
//                   0123456789,123456789,123456789,123456789,123456789,123456789,123456789,123456789,123456789,123456789,123456789,123456789,123456789,123456789,1234567
//                   00      08    14                    36                  56                                            102              119        130 134
//                   999999  99    123456789.123456789.  123456789,1234 <==  123456789.123456789.123456789.123456789. <==  123456789.12345  99999 <==  XX  999 <==
cabec2 := " "

ValidPerg(cPerg)
Pergunte(cPerg,.F.)

//�����������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                      �
//� mv_par01			xxxxxxxxxxxxxxx						  �
//�������������������������������������������������������������

//�����������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                     �
//�������������������������������������������������������������
wnrel:= "CBACA01"            //Nome Default do relatorio em Disco
aOrd := {}
wnrel:= SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If nLastKey = 27
	Return
EndIf

SetDefault(aReturn,cString)

If nLastKey = 27
	Return
EndIf

RptStatus({|lEnd| CBACA01Imp(@lEnd,wnRel,cString)},titulo)
Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �CFATR01IMP� Autor � Daniel G.Jr.TI1239    � Data � Abr/2013 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relacao de NFs por CR                                      ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � CFATR01Imp(lEnd,wnRel,cString)                             ���
�������������������������������������������������������������������������Ĵ��
���Parametros� lEnd        - A�ao do Codelock                             ���
���          � wnRel       - T�tulo do relat�rio                          ���
���Parametros� cString     - Mensagem			                          ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CIEE                                                       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function CBACA01Imp(lEnd,wnRel,cString)

Local CbCont,CbTxt
Local tamanho   := "G"
Local limite    := 132
Local nOrdem
Local nTotch:=0,nTotVal:=0,nTotchg:=0,nTotValg:=0,nFirst:=0
Local lContinua := .T.,nTipo
Local cDepto	:= ""
Local nLocal	:= 0
Local aNFCR		:= {}
Local cChave	:= ""
Local _nI		:= 0
Local lCNPJ, lEnd, lMun, lPais
Local cMun		:= ""
Local cTMun		:= ""

Private cDirDocs	:= MsDocPath()
Private cArquivo	:= CriaTrab(,.F.)
Private cTempPath	:= Alltrim(GetTempPath())
Private cCmd		:= cDirDocs+"\"+cArquivo+".xls"
Private cPlan		:= ""

Store .F. To lCNPJ, lEnd, lMun, lPais
nTipo:=Iif(aReturn[4]==1,15,18)

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape    �
//����������������������������������������������������������������
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
m_pag    := 1
nOrdem   := aReturn[8]

// Cria cabecalho html da planilha
CabPlan()
           
dbSelectArea("SA2")
SA2->(dbSetOrder(1))
SA2->(dbGoTop())

SetRegua(RecCount())

While SA2->(!Eof())

	IncRegua()

	If SA2->A2_DATAREF < mv_par01
		SA2->(dbSkip())
		Loop
	EndIf
		
	If li > 60
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		nFirst:=0
	Endif
	
	cMun	:= ""
	lCNPJ 	:= Iif(SA2->A2_TIPO<>"X",.T., ( CGC(SA2->A2_CGC).And.xA020CGC(SA2->A2_TIPO, SA2->A2_CGC) ) )
	lEnd	:= Iif(At(",",SA2->A2_END)>0,.T.,.F.)
	lMun	:= Iif(Empty(SA2->A2_COD_MUN).Or.AT((SA2->A2_EST+SA2->A2_COD_MUN),cTMun)>0,.F.,!Empty(cMun:=Posicione("CC2",1,xFilial("CC2")+SA2->A2_EST+SA2->A2_COD_MUN,"CC2_CODMUN")) )
	lPais	:= Iif(SA2->A2_PAIS=="105",.T.,Iif(Empty(SA2->A2_PAIS),.F.,!Empty(Posicione("SYA",1,xFilial("SYA")+SA2->A2_PAIS,"YA_CODGI")) ) )
	cTMun	+= Iif(Empty(cMun),SA2->A2_EST+SA2->A2_COD_MUN,"")
	
	If !(lCNPJ .And. lEnd .And. lMun .And. lPais )
	
		@li , 000 Psay SA2->A2_COD
		@li , 008 Psay SA2->A2_LOJA
		@li , 014 Psay SA2->A2_NREDUZ
		@li , 036 Psay SA2->A2_CGC 		+ Iif(!lCNPJ," <--","")
		@li , 056 Psay SA2->A2_END 		+ Iif(!lEnd ," <--","")
		@li , 102 Psay SA2->A2_MUN
		@li , 119 Psay SA2->A2_COD_MUN 	+ Iif(!lMun ," <--","")
		@li , 130 Psay SA2->A2_EST
		@li , 134 Psay SA2->A2_PAIS 	+ Iif(!lPais," <--","")
	
		cPlan += '  <TR style="HEIGHT: 15.75pt" height=21>'
		cPlan += "<TD style='BORDER-LEFT: medium none; BORDER-TOP: medium none' class=xl68>"+RetCpo(SA2->A2_COD)	+"</td>"
		cPlan += "<TD style='BORDER-LEFT: medium none; BORDER-TOP: medium none' class=xl68>"+RetCpo(SA2->A2_LOJA)	+"</td>"
		cPlan += "<TD style='BORDER-LEFT: medium none; BORDER-TOP: medium none' class=xl68>"+SA2->A2_NREDUZ			+"</td>"
		cPlan += "<TD style='BORDER-LEFT: medium none; BORDER-TOP: medium none' class=xl68>"+SA2->A2_TIPO			+"</td>"
		cPlan += "<TD style='BORDER-LEFT: medium none; BORDER-TOP: medium none' class=xl68>"+RetCpo(SA2->A2_CGC)	+"</td>"
		cPlan += "<TD style='BORDER-LEFT: medium none; BORDER-TOP: medium none' class=xl68>"+SA2->A2_END			+"</td>"
		cPlan += "<TD style='BORDER-LEFT: medium none; BORDER-TOP: medium none' class=xl68>"+SA2->A2_MUN			+"</td>"
		cPlan += "<TD style='BORDER-LEFT: medium none; BORDER-TOP: medium none' class=xl68>"+RetCpo(SA2->A2_COD_MUN)+"</td>"
		cPlan += "<TD style='BORDER-LEFT: medium none; BORDER-TOP: medium none' class=xl68>"+SA2->A2_EST			+"</td>"
		cPlan += "<TD style='BORDER-LEFT: medium none; BORDER-TOP: medium none' class=xl69>"+SA2->A2_PAIS			+"</td>"
		cPlan += "<TD style='BORDER-LEFT: medium none; BORDER-TOP: medium none' class=xl68>"+Iif(!lCNPJ,"X","")		+"</td>"
		cPlan += "<TD style='BORDER-LEFT: medium none; BORDER-TOP: medium none' class=xl68>"+Iif(!lEnd ,"X","")		+"</td>"
		cPlan += "<TD style='BORDER-LEFT: medium none; BORDER-TOP: medium none' class=xl68>"+Iif(!lMun ,"X","")		+"</td>"
		cPlan += "<TD style='BORDER-LEFT: medium none; BORDER-TOP: medium none' class=xl68>"+Iif(!lPais,"X","")		+"</td>"
		cPlan += '  </TR>'
		xAddToFile( cPlan, cCmd )
		cPlan := ""
			
		li++
	EndIf
	
	SA2->(dbSkip())
	
End

cPlan += '  <TR style="HEIGHT: 15.75pt" height=21>'
cPlan += '    <TD style="WIDTH: 871pt; HEIGHT: 15.75pt" class=xl67 height=21 width=1162 colSpan=14>'
cPlan += '      <P align=center>Legenda: C=NPJ, E=ndere�o, M=unicipio, P=ais</P></TD></TR>'
cPlan += '</TBODY></TABLE></BODY></HTML>'
xAddToFile( cPlan, cCmd )

If li != 80
	roda(cbcont,cbtxt,"M")
EndIf

Set Device To Screen

If aReturn[5] = 1
	Set Printer To
	Commit
	ourspool(wnrel)
EndIf
MS_FLUSH()

GeraPlan()

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcion   �GeraPlan  � Autor � Daniel G.Jr.TI1239    � Data � Fev/2013 ���
�������������������������������������������������������������������������Ĵ��
���Descrip.  �Gera planilha do relatorio                                  ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Estapar                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function GeraPlan()

// Grava linha a linha no arquivo XLS
xAddToFile( cPlan, cCmd )

IncProc('Gerando Planilha....')

CpyS2T(cDirDocs+"\"+cArquivo+".xls",cTempPath,.T.)

oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open(cTempPath+cArquivo+".xls")
oExcelApp:SetVisible(.T.)

If MsgYesNo("Deseja fechar a planilha do excel?")
	oExcelApp:Quit()
	oExcelApp:Destroy()
EndIf

Ferase( cDirDocs+"\"+cArquivo+".xls" )

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CabPlan   �Autor  � Daniel G.Jr.TI1239    � Data � Fev/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     �Cria cabecalho da planilha                                  ���
�������������������������������������������������������������������������͹��
���Uso       � Estapar                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CabPlan()

cPlan := '<HTML><HEAD><TITLE></TITLE>'
cPlan += '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">'
cPlan += '<META content="text/html; charset=windows-1252" http-equiv=Content-Type>'
cPlan += '<META name=GENERATOR content="MSHTML 9.00.8112.16457"></HEAD>'
cPlan += '<BODY>'
cPlan += '<TABLE style="WIDTH: 871pt; BORDER-COLLAPSE: collapse; TABLE-LAYOUT: fixed" '
cPlan += 'border=1 cellSpacing=0 cellPadding=0 width=1162>'
cPlan += '<TBODY>'
cPlan += '  <TR style="HEIGHT: 15.75pt" height=21>'
cPlan += '    <TD style="WIDTH: 871pt; HEIGHT: 15.75pt" class=xl67 height=21 width=1162 colSpan=14>'
cPlan += '      <P align=center>Rela��o de Fornecedores com Inconsistencias</P></TD></TR>'
cPlan += '  <TR style="HEIGHT: 15.75pt" height=21>'
cPlan += '    <TD style="HEIGHT: 15.75pt; BORDER-TOP: medium none" class=xl71 height=21>Codigo</TD>'
cPlan += '    <TD style="BORDER-LEFT: medium none; BORDER-TOP: medium none" class=xl71>Loja</TD>'
cPlan += '    <TD style="BORDER-LEFT: medium none; BORDER-TOP: medium none" class=xl71>Nome</TD>'
cPlan += '    <TD style="BORDER-LEFT: medium none; BORDER-TOP: medium none" class=xl71>Tipo</TD>'
cPlan += '    <TD style="BORDER-LEFT: medium none; BORDER-TOP: medium none" class=xl71>CNPJ/CPF</TD>'
cPlan += '    <TD style="BORDER-LEFT: medium none; BORDER-TOP: medium none" class=xl68>Endereco</TD>'
cPlan += '    <TD style="BORDER-LEFT: medium none; BORDER-TOP: medium none" class=xl70>Municipio</TD>'
cPlan += '    <TD style="BORDER-LEFT: medium none; BORDER-TOP: medium none" class=xl70>Cod.Municipio</TD>'
cPlan += '    <TD style="BORDER-LEFT: medium none; BORDER-TOP: medium none" class=xl70>UF</TD>'
cPlan += '    <TD style="BORDER-LEFT: medium none; BORDER-TOP: medium none" class=xl70>Pais</TD>'
cPlan += '    <TD style="BORDER-LEFT: medium none; BORDER-TOP: medium none" class=xl70>C</TD>'
cPlan += '    <TD style="BORDER-LEFT: medium none; BORDER-TOP: medium none" class=xl70>E</TD>'
cPlan += '    <TD style="BORDER-LEFT: medium none; BORDER-TOP: medium none" class=xl70>M</TD>'
cPlan += '    <TD style="BORDER-LEFT: medium none; BORDER-TOP: medium none" class=xl70>P</TD>'
cPlan += '  </TR>'
//cPlan += '  <TR style="HEIGHT: 15.75pt" height=21>'

// Grava linha a linha no arquivo XLS
xAddToFile( cPlan, cCmd )

cPlan := ""

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xAddToFile�Autor  � Daniel G.Jr.TI1239    � Data � Fev/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     �Adiciona a linha de log ao fim de um arquivo.               ���
�������������������������������������������������������������������������͹��
���Uso       � Rcomr04.prw                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function xAddToFile( cLog, cToFile )

Local nHdl  := -1
Local cBuff := cLog

If File( cToFile )
	
	nHdl := FOpen( cToFile, 1 )
	
	If nHdl >= 0
		
		FSeek( nHdl, 0, 2 )
		
	EndIf
	
Else
	
	nHdl := FCreate( cToFile )
	
EndIf

If nHdl >= 0
	
	FWrite( nHdl,  cBuff, Len( cBuff ) )
	
EndIf

FClose( nHdl )

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RetCpo   �Autor  � Daniel G.Jr.TI1239    � Data � Fev/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     �Retorna campo no formato correto para planilha              ���
�������������������������������������������������������������������������͹��
���Uso       � Rcomr04.prw                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function RetCpo(cCpo)

If ValType(cCpo)=="D"
	If Empty(cCpo)
		cCpo := ""
	Else
		cCpo := DtoC(cCpo)
	EndIf
Else
	If !Empty(cCpo)
		If !IsAlpha(cCpo)
			cCpo := "'"+cCpo
		EndIf
	EndIf
EndIf

Return(cCpo)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �A020CGC   � Autor � Eduardo Riera         � Data � 17.04.06 ���
�������������������������������������������������������������������������Ĵ��
���Descricao �Validacao do campo A2_CGC.                                  ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Cadastro de clientes                                       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function xA020CGC(cTipPes,cCNPJ)

Local aArea     	:= GetArea()
Local aAreaSA2  	:= SA2->(GetArea())
Local lRetorno  	:= .T.
Local cCNPJBase 	:= ""
Local cMv_ValCNPJ 	:= GetNewPar("MV_VALCNPJ","1")
Local cMv_ValCPF 	:= GetNewPar("MV_VALCPF","1")
Local cCod          := ""
Local cLoja         := ""
Local nCad          := 0

//��������������������������������������������������������������Ŀ
//� Valida o tipo de pessoa                                      �
//����������������������������������������������������������������
If cTipPes == "F" .And. !(Len(AllTrim(cCNPJ))==11)
	Help(" ",1,"CPFINVALID")
	lRetorno := .F.
ElseIf cTipPes == "J" .And. !(Len(AllTrim(cCNPJ))==14)
	Help(" ",1,"CGC")
	lRetorno := .F.
EndIf

If Type("lCGCValido") == "U" // Protecao caso esta funcao seja invocada por outra rotina diferente da Inclusao/Alteracao
	Private lCGCValido := .F.
EndIf

//��������������������������������������������������������������Ŀ
//� Valida a duplicidade do CGC                                  �
//����������������������������������������������������������������
If lRetorno .And. Pcount() > 1
	If cTipPes == "J"  // Valida��o pessoa f�sica
	
	    //Verifica quantidade de Fornecedores cadastrados com o mesmo c�digo e obt�m o 1a c�digo 
	    //de cadastro diferente do fornecedor que est� sendo alterado ou inclu�do
		dbSelectArea("SA2")
		dbSetOrder(3)
		MsSeek(xFilial("SA2")+cCNPJ)
		Do While !Eof() .And. SA2->A2_FILIAL == xFilial("SA2") .AND. SA2->A2_CGC == cCNPJ
		    If (SA2->A2_COD+SA2->A2_LOJA <> SA2->A2_COD+SA2->A2_LOJA) .And. Empty(cCod)
		    	 cCod:=SA2->A2_COD
		    	 cLoja:=SA2->A2_LOJA
		    EndIf      
	    	nCad++
			DbSkip()
		EndDo
		
		If nCad>0
			//��������������������������������������������������������������������������������������������������Ŀ
			//�O parametro MV_VALCNPJ verifica se a validacao do CNPJ deve ser feita:                            �
			//�1 = informando ao usuario que ja existe o CNPJ na base e verificando se deseja incluir mesmo assim�
			//�2 = nao permitindo que o usuario insira o mesmo CNPJ                                              �
			//����������������������������������������������������������������������������������������������������
			If !Empty(cCod)
			    //Posiciona no c�digo de fornecedor
				dbSelectArea("SA2")
				dbSetOrder(1)
				MsSeek(xFilial("SA2")+cCod+cLoja)
				If cMv_ValCNPJ == "1"
					If !_SetAutoMode()
						If Aviso(STR0011,STR0025+SA2->A2_COD+"/"+SA2->A2_LOJA+" - "+SA2->A2_NOME+" - "+AllTrim(RetTitle("A2_INSCR"))+": "+SA2->A2_INSCR,{STR0027,STR0028},2)<>1//"Aten��o"###"O CNPJ informado j� foi utilizado no fornecedor "###"Aceitar"###"Cancelar"
							lRetorno := .F.
							lCGCValido := .F.
						Else
							lCGCValido := .T. // Indica que ja validou o CNPJ e nao devera validar novamente na confirmacao da inclusao
						EndIf
					EndIf
				Else
					If !_SetAutoMode()
						Aviso(STR0011,STR0025+SA2->A2_COD+"/"+SA2->A2_LOJA+" - "+SA2->A2_NOME+".",{"Ok"})//"Aten��o"###"O CNPJ informado j� foi utilizado no fornecedor "###
					EndIf
					lRetorno := .F.
				Endif
			EndIf
		ElseIf lRetorno
			cCNPJBase := SubStr(cCNPJ,1,8)
			dbSelectArea("SA2")
			dbSetOrder(3)
			If MsSeek(xFilial("SA2")+cCNPJBase) .And.  (SA2->A2_COD+SA2->A2_LOJA <> SA2->A2_COD+SA2->A2_LOJA)
				If !_SetAutoMode()
					If Aviso(STR0011,STR0035+" "+SA2->A2_COD+"/"+SA2->A2_LOJA+" - "+SA2->A2_NOME+".",{STR0027,STR0028},2)<>1//"Aten��o"###"A base do CNPJ informado j� foi utilizada no fornecedor "###"Aceitar"###"Cancelar"
						lRetorno := .F.
						lCGCValido := .F.
					Else
						lCGCValido := .T. // Indica que ja validou o CNPJ e nao devera validar novamente na confirmacao da inclusao
					EndIf
				EndIf
			EndIf
		EndIf
	Else
		dbSelectArea("SA2")
		dbSetOrder(3)
		If MsSeek(xFilial("SA2")+cCNPJ) .And. SA2->A2_COD+SA2->A2_LOJA <> SA2->A2_COD+SA2->A2_LOJA
			//�������������������������������������������������������������������������������������������������Ŀ
			//�O parametro MV_VALCPF verifica se a validacao do CPF deve ser feita:                             �
			//�1 = informando ao usuario que ja existe o CPF na base e verificando se deseja incluir mesmo assim�
			//�2 = nao permitindo que o usuario insira o mesmo CPF                                              �
			//���������������������������������������������������������������������������������������������������
			If cMv_ValCPF == "1"
				If !_SetAutoMode()
					If Aviso(STR0011,STR0026+SA2->A2_COD+"/"+SA2->A2_LOJA+" - "+SA2->A2_NOME+".",{STR0027,STR0028},2)<>1//"Aten��o"###"O CPF informado j� foi utilizado fornecedor "###"Aceitar"###"Cancelar"
						lRetorno := .F.
						lCGCValido := .F.
					Else
						lCGCValido := .T. // Indica que ja validou o CNPJ e nao devera validar novamente na confirmacao da inclusao
					EndIf
				EndIf
			Else
				If !_SetAutoMode()
					Aviso(STR0011,STR0026+SA2->A2_COD+"/"+SA2->A2_LOJA+" - "+SA2->A2_NOME+".",{"Ok"})//"Aten��o"###"O CPF informado j� foi utilizado no fornecedor "###
				EndIf
				lRetorno := .F.
			Endif
		EndIf
	EndIf
EndIf

RestArea(aAreaSA2)
RestArea(aArea)
Return lRetorno

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcion   �ValidPerg � Autor � Daniel G.Jr.TI1239    � Data � Fev/2013 ���
�������������������������������������������������������������������������Ĵ��
���Descrip.  �Gera SX1 da rotina                                          ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Estapar                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ValidPerg( cPerg )
Local aArea := GetArea(),;
aRegs := {},;
i, j

DbSelectArea( "SX1" )
DbSetOrder( 1 )

cPerg := PadR( cPerg,10 )
AAdd( aRegs, { cPerg,"01","A partir da data ?","","","mv_ch1","D",8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"","","","","" } )

For i := 1 TO Len( aRegs )
	If !DbSeek( cPerg + aRegs[i,2] )
		RecLock( "SX1", .T. )
		For j := 1 TO FCount()
			If j <= Len( aRegs[i] )
				FieldPut( j, aRegs[i,j] )
			EndIf
		Next
		MsUnlock()
	EndIf
Next

RestArea( aArea )

Return
