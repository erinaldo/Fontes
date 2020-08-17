#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � CSUCLISS � Autor � Daniel G.Jr. TI1239   � Data � 26/06/07 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Gera relatorio/planilha com dados do ISS de clientes       ���
�������������������������������������������������������������������������Ĵ��
���Uso		 � Especifico CSU                  							  ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function CSUCLISS()

private cPerg     := PADR("ISSCLI",LEN(SX1->X1_GRUPO))
private nomeprog  := "CSUCLISS"
private lweb      := IsBlind()
private lPrimVez  := .t.
Private oPrn

//Fontes Arial
Private oFont1 := TFont():New( "Arial",,10,,.t.,,,,,.f. )
Private oFont3 := TFont():New( "Arial",,12,,.t.,,,,,.f. )

//Fontes Courier New (para campos numericos)
Private oFont1c := TFont():New( "Courier New",,10,,.t.,,,,,.f. )
Private oFont9c := TFont():New( "Courier New",,8,,.f.,,,,,.f. )

ValidPerg(cPerg)
Pergunte(cPerg,.F.)

//���������������������������������������������������������������
//� Variaveis utilizadas para parametros
//� mv_par01	Cliente de       ?
//� mv_par02	Filial de        ?
//� mv_par03	Cliente ate      ?
//� mv_par04	Filial ate       ?
//� mv_par05	Dt.Emissao de    ?
//� mv_par06	Dt.Emissao ate   ?
//� mv_par07	Processamento de ? Relat�rio / Planilha
//���������������������������������������������������������������

@ 200,1 TO 380,380 DIALOG o_dlg TITLE OemToAnsi("Rela�ao de ISS por Cliente")
@ 02,10 TO 080,180
@ 10,018 Say OemToAnsi("Esta rotina imprime a Rela�ao de ISS por Cliente")
@ 18,018 Say OemToAnsi("")
@ 26,018 Say OemToAnsi("")
@ 34,018 Say OemToAnsi("")
@ 65,038 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)
@ 65,068 BMPBUTTON TYPE 01 ACTION OkProc()
@ 65,098 BMPBUTTON TYPE 02 ACTION Close(o_dlg)
@ 65,128 BMPBUTTON TYPE 07 ACTION oPrn:=Setup()
Activate Dialog o_dlg Centered

if Select( "TRB" ) > 0
	dbSelectArea( "TRB" )
	dbCloseArea()
endif

MS_FLUSH()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � OkProc   �Autor  �Microsiga           � Data �  07/03/07   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function OkProc()

Private bProcessa, cTitulo, cMsg, lAborta
Close(o_dlg)

cQuery := "SELECT A1_COD,A1_LOJA,A1_NOME,F2_FILIAL,F2_CLIENTE,F2_LOJA,F2_DOC,F2_SERIE,F2_EMISSAO,F2_VALBRUT,F2_BASEISS,F2_VALISS "
cQuery += "FROM "+RetSQLName("SA1")+" A1, "+RetSQLName("SF2")+" F2 "
cQuery += "WHERE A1.D_E_L_E_T_<>'*' AND F2.D_E_L_E_T_<>'*' "
cQuery +=   "AND A1_COD+A1_LOJA BETWEEN '"+mv_par01+mv_par02+"' AND '"+mv_par03+mv_par04+"' "
cQuery +=   "AND F2_CLIENTE+F2_LOJA=A1_COD+A1_LOJA "
cQuery +=   "AND F2_EMISSAO BETWEEN '"+DtoS(mv_par05)+"' AND '"+DtoS(mv_par06)+"' "
cQuery += "ORDER BY A1_COD, A1_LOJA, F2_DOC "

cQuery := ChangeQuery(cQuery)

//MemoWrite("C:\CSUCLISS.sql",cQuery)

If Select("TRB")>0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.F.,.T.)

TCSetField("TRB","F2_EMISSAO","D",8,0)

If mv_par07==1
	bProcessa := { |lFim| ImpRelato(@lFim) }
	cTitulo   := "Impress�o do Relat�rio"
	cMsg      := "Imprimindo... Aguarde..."
	lAborta   := .T.
	Processa( bProcessa, cTitulo, cMsg, lAborta )
Else
	bProcessa := { |lFim| GeraPlani(@lFim) }
	cTitulo   := "Gera��o das Planilhas"
	cMsg      := "Gerando planilha... Aguarde..."
	lAborta   := .T.
	Processa( bProcessa, cTitulo, cMsg, lAborta )
EndIf

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO6     � Autor � AP6 IDE            � Data �  26/06/07   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ImpRelato(lFim)


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Rela��o de ISS por Cliente"
Local cPict          := ""
Local titulo       := "Rela��o de ISS por Cliente"
Local nLin         := 80

Local Cabec1       := "CLIENTE      NR.DOC  SERIE  DT.EMISSAO      VAL.BRUTO        BASE ISS               VALOR ISS"
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 132
Private tamanho          := "M"
Private nomeprog         := "CSUCLISS" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "ISSCLI" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SF2"
//Private cPerg   := "ISSCLI"

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  26/06/07   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem

dbSelectArea(cString)
dbSetOrder(1)

dbSelectArea("TRB")
//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

SetRegua(RecCount())

TRB->(dbGoTop())
If TRB->(Eof().And.Bof())
	MsgAlert("N�o h� dados para este relat�rio!")
	Return()
EndIf

cChave:=""
aTot:={0,0}
While TRB->(!EOF())
	
	//���������������������������������������������������������������������Ŀ
	//� Verifica o cancelamento pelo usuario...                             �
	//�����������������������������������������������������������������������
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	If cChave!=TRB->(A1_COD+A1_LOJA)
		If aTot[1]>0
			nLin++
			If nLin>55
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			EndIf
			
			@nLin,36 PSAY aTot[1] PICTURE "---------------"
			@nLin,78 PSAY aTot[2] PICTURE "---------------"
			nLin++
			@nLin,00 PSAY "Total do Cliente "+Left(cChave,6)+"/"+Right(cChave,2)
			@nLin,36 PSAY aTot[1] PICTURE "@E 9999,999,999.99"
			@nLin,78 PSAY aTot[2] PICTURE "@E 9999,999,999.99"
			nLin+=3
			aTot:={0,0}
		EndIf
		
		If nLin>58
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		EndIf
		
		@nLin,00 PSAY TRB->A1_COD+"/"+TRB->A1_LOJA+"-"+TRB->A1_NOME
		cChave := TRB->(A1_COD+A1_LOJA)
	EndIf
	
	nLin++
	If nLin > 58 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	@nLin,00 PSAY TRB->A1_COD
	@nLin,08 PSAY TRB->A1_LOJA
	@nLin,12 PSAY TRB->F2_DOC
	@nLin,20 PSAY TRB->F2_SERIE
	@nLin,26 PSAY TRB->F2_EMISSAO
	@nLin,36 PSAY TRB->F2_VALBRUT	PICTURE "@E 9999,999,999.99"
	@nLin,52 PSAY TRB->F2_BASEISS	PICTURE "@E 9999,999,999.99"
	@nLin,78 PSAY TRB->F2_VALISS	PICTURE "@E 9999,999,999.99"
	
	aTot[1]+=TRB->F2_VALBRUT
	aTot[2]+=TRB->F2_VALISS
	
	TRB->(dbSkip())
End

If aTot[1]>0
	nLin++
	If nLin>53
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	EndIf
	@nLin,36 PSAY aTot[1] PICTURE "---------------"
	@nLin,78 PSAY aTot[2] PICTURE "---------------"
	nLin++
	@nLin,00 PSAY "Total do Cliente "+Left(cChave,6)+"/"+Right(cChave,2)
	@nLin,36 PSAY aTot[1] PICTURE "@E 9999,999,999.99"
	@nLin,78 PSAY aTot[2] PICTURE "@E 9999,999,999.99"
	aTot:={0,0}
EndIf

//���������������������������������������������������������������������Ŀ
//� Finaliza a execucao do relatorio...                                 �
//�����������������������������������������������������������������������

SET DEVICE TO SCREEN

//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �GERAPLANI � Autor � Daniel G.Jr.TI1239    � Data � 15/01/02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Gera arquivos do tipo Excel (.xls)						  ���
�������������������������������������������������������������������������Ĵ��
��� Uso 	 � PADRAO												      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GeraPlani(lFim)

Local cArq := CriaTrab(,.F.)
Local cPath := cGetFile("",OemtoAnsi( "Local para grava��o..."),1,,.F.,GETF_LOCALHARD + GETF_LOCALFLOPPY+GETF_NETWORKDRIVE+GETF_RETDIRECTORY )
Local _cCodCurso, _cPerLet, _nI:=0
Local _cPeriodos, _lCont:=.T.

dbSelectArea("TRB")

TRB->(dbGoTop())
If TRB->(Eof().And.Bof())
	MsgAlert("N�o h� dados para este relat�rio!")
	Return()
EndIf

cArqPesq := Upper(cPath + "Relat�rio_ISS_Clientes.xls")
_cAluno:=""

If File(cArqPesq)
	FErase(cArqPesq)
EndIf

ProcRegua(500)
cTabela := "<table border=1>"
cTabela += "<font face='Arial'>"
cTabela += "<tr><td>Cliente</td><td>Loja</td><td>Razao Social</td><td>Nr.Dcomento</td><td>S�rie</td><td>Dt.Emiss�o</td><td>Val.Bruto</td><td>Base ISS</td><td>Valor ISS</td></tr>"
cTabela += "<tr><td>XXXXXX</td><td>XX</td><td>XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX</td><td>XXXXXX</td><td>XXX</td><td>DD/MM/AAAA</td><td>9999999999.99</td><td>9999999999.99</td><td>9999999999.99</td></tr>"
_cChavAnt:=""
While TRB->(!Eof())
	
	IncProc()
	
	cTabela += "<tr><td>'"+TRB->A1_COD+"</td>"
	cTabela += "<td>'"+TRB->A1_LOJA+"</td>"
	cTabela += "<td>"+TRB->A1_NOME+"</td>"
	cTabela += "<td>'"+TRB->F2_DOC+"</td>"
	cTabela += "<td>'"+TRB->F2_SERIE+"</td>"
	cTabela += "<td>"+DtoC(TRB->F2_EMISSAO)+"</td>"
	cTabela += "<td>"+TransForm(TRB->F2_VALBRUT,"@E 9999,999,999.99")+"</td>"
	cTabela += "<td>"+TransForm(TRB->F2_BASEISS,"@E 9999,999,999.99")+"</td>"
	cTabela += "<td>"+TransForm(TRB->F2_VALISS ,"@E 9999,999,999.99")+"</td>"
	cTabela += "</tr>"
	
	// Grava linha a linha no arquivo XLS
	xAddToFile( cTabela, cArqPesq )
	cTabela:=""
	                         
	TRB->(dbSkip())
End

cTabela += "</font>"
cTabela += "</table>"

// Grava linha a linha no arquivo XLS
xAddToFile( cTabela, cArqPesq )
/*/
//If MsgYesNo(cArqPesq+". "+OemtoAnsi("O arquivo foi gerado no diret�rio "))
	//�������������������������������������������������������������������������������������Ŀ
	//� Abre Excel                                                                       	�
	//���������������������������������������������������������������������������������������
	If ApOleClient( 'MsExcel' )
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( cArqPesq ) // Abre uma planilha
		oExcelApp:SetVisible(.T.)
	Else
		Alert(OemtoAnsi( "Microsoft Excel nao encontrado !" ))
	EndIf
Endif
/*/
MsgAlert(cArqPesq+". "+OemtoAnsi("O arquivo foi gerado no diret�rio "))

TMP->( dbCloseArea() )

If File(cArq)
	Ferase(cArq)
EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �xAddToFile�Autor  �Rafael Rodrigues    � Data �  14/03/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Adiciona a linha de log ao fim de um arquivo.               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function xAddToFile( cLog, cToFile )
local nHdl	:= -1
local cBuff	:= cLog

if File( cToFile )
	nHdl := FOpen( cToFile, 1 )
	if nHdl >= 0
		FSeek( nHdl, 0, 2 )
	endif
else
	nHdl := FCreate( cToFile )
endif

if nHdl >= 0
	FWrite( nHdl,  cBuff, Len( cBuff ) )
endif

FClose( nHdl )

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcion   �          � Autor �                       � Data �   /  /   ���
�������������������������������������������������������������������������Ĵ��
���Descrip.  �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       �                                                            ���
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

cPerg := Padr( cPerg,LEN(SX1->X1_GRUPO))
AAdd( aRegs, { cPerg, "01", "Cliente de      ?", " ", " ", "mv_ch1", "C", 6 , 00, 0, "G", "", "mv_par01", "", "", "",  "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","","" } )
AAdd( aRegs, { cPerg, "02", "Loja de         ?", " ", " ", "mv_ch2", "C", 2 , 00, 0, "G", "", "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","","" } )
AAdd( aRegs, { cPerg, "03", "Cliente ate     ?", " ", " ", "mv_ch3", "C", 6 , 00, 0, "G", "", "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","","" } )
AAdd( aRegs, { cPerg, "04", "Loja de         ?", " ", " ", "mv_ch4", "C", 2 , 00, 0, "G", "", "mv_par04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","","" } )
AAdd( aRegs, { cPerg, "05", "Dt.Emissao de   ?", " ", " ", "mv_ch5", "D", 8 , 00, 0, "G", "", "mv_par05", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","","" } )
AAdd( aRegs, { cPerg, "06", "Dt.Emissao ate  ?", " ", " ", "mv_ch6", "D", 8 , 00, 0, "G", "", "mv_par06", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","","" } )
aAdd( aRegs, { cPerg, "07", "Processamento de?"	, " ", " ", "mv_ch7", "N", 1 , 00, 2, "C", "", "mv_par07", "Relat�rio","","","","","Planilha Excel","","","","","","","","","","","","","","","","","","","","",""})

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
