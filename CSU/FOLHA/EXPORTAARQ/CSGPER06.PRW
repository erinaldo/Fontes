#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "topconn.ch"
#DEFINE      cSep     ";"
#DEFINE      cEol     Chr(13) + Chr(10)

User Function WFGPER06()
Return u_CSGPER06()

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSGPER04  �Autor  �Isamu K.		     � Data �  19/10/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Gera informacoes da folha de pagamento em formato         ���
���          �  Microsoft Excel. OS 2756/16                               ���
�������������������������������������������������������������������������͹��
����������������������������������������������������������������������������*/

User Function CSGPER06
                      

PREPARE ENVIRONMENT EMPRESA "05" FILIAL "03" MODULO "GPE"

Private aArea := GetArea()
Private oGeraTxt
Private oHTML
Private cDirDocs := MsDocPath()            // Diretorio de docs do servidor
Private cTmpTxt  := CriaTrab(Nil,.f.)
Private cCmd     := cDirDocs+"\"+cTmpTxt+".txt"

fGeraArq(cCmd)

RESET ENVIRONMENT


RestArea(aArea)

Return


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � OKGERATXT� Autor � AP5 IDE            � Data �  08/05/07   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao chamada pelo botao OK na tela inicial de processamen���
���          � to. Executa a geracao do arquivo texto.                    ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function fGeraArq(cCmd)

Processa( { || OkProc() }, "Executando o Processamento..." )

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �OKPROC    �Autor  �Isamu K.	         � Data �  19/10/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Processa o relatorio excel.                               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CSGPER04                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
Static Function OkProc()

Local cSelekt, cQryCpos, nCntView
Local nConta  := 0
Local nCount 	:= 1  
Local cArquivo  := "\WFM\SRC\"
Local nBaseCal  := nVal783   := nVal809 := nVal955 := nVal810 := 0
Local nValInss  := nValFgts  := nValMed := nValFer := nVal13  := 0
Local cFolMes   := ""

Private cData     := dTos(dDataBase)

cArquivo := cArquivo+"folha_custo_price.csv"

nHdl  := fCreate( cArquivo )

If nHdl == -1
	MsgAlert("O arquivo de nome "+cArquivo+" nao pode ser executado! Verifique os parametros.","Atencao!")
	Return
EndIf

cQr := "SELECT MAX(RD_DATARQ) AS DATARQ "
cQr += "FROM "+RetSQLName("SRD")+" "
cQr += "WHERE D_E_L_E_T_ <> '*' "
 
DbUseArea( .T., 'TOPCONN', TCGENQRY(,, cQr), "TSRD", .T., .T. )

cFolMes := TSrd->Datarq
//���������������������������
//�Monta o cabecalho        �
//���������������������������
cLin := "FILIAL" + cSep
cLin += "MATRICULA" + cSep
cLin += "NOME" + cSep
cLin += "C.P.F." + cSep
cLin += "C.CUSTO" + cSep
cLin += "DESCRI��O C.C." + cSep
cLin += "PERIODO" + cSep
cLin += "BASE DE C�LCULO" + cSep
cLin += "VERBA 809" + cSep
cLin += "VERBA 955" + cSep
cLin += "INSS" + cSep
cLin += "FGTS" + cSep
cLin += "REFEI��O" + cSep
cLin += "ASS.M�DICA" + cSep
cLin += "F�RIAS" + cSep
cLin += "13o SAL�RIO" + cEol

fGravaTxt(cLin)
//��������������������������������������������������������������
//�Query com os dados dos funcionarios, conforme os parametros.�
//��������������������������������������������������������������
cSelekt := " SELECT	SRA.RA_FILIAL FILIAL, SRA.RA_MAT MAT, SRA.RA_NOME NOME, SRA.RA_CC CC, SRA.RA_CIC CPF, SRD.RD_PD CODFOL, SRD.RD_VALOR VALOR "
cSelekt += "  FROM "+RetSQLName("SRD")+" SRD, "+RetSQLName("SRA")+" SRA "
cSelekt += "  WHERE  SRD.RD_FILIAL  = SRA.RA_FILIAL "
cSelekt += "     AND SRD.RD_MAT 	   = SRA.RA_MAT "
cSelekt += "     AND SRD.RD_FILIAL  >= '00'	AND SRD.RD_FILIAL	<= '99' 	"
cSelekt += "     AND SRD.RD_MAT	   	>= '0'	AND SRD.RD_MAT		<= 'ZZZZZZ' 	"
cSelekt += "     AND SRD.RD_CC	   	>= '0'	AND SRD.RD_CC		<= 'ZZZZZZZZZZZZZZZZZZZZ'	"
cSelekt += "     AND SRD.RD_DATARQ  = '"+cFolMes+"' "
cSelekt += "     AND SRD.RD_PD IN('006','376','782','783','809','955','810') "
cSelekt += "     AND SRD.D_E_L_E_T_ =  ' ' "
cSelekt += "     AND SRA.D_E_L_E_T_ =  ' ' "
cSelekt += " ORDER BY SRD.RD_FILIAL, SRD.RD_CC, SRD.RD_MAT "

//�������������������������������������������
//�Gera o arquivo temporario da query acima.�
//�������������������������������������������
nCntView := U_MontaView( cSelekt, "QryMestre" ) 

If QryMestre->(Eof()) .and. QryMestre->(bof())
	
	Memowrite("\WFM\SRC\folha_custo_price.csv","NAO EXISTEM DADOS A SEREM GERADOS NESSE PERIODO.")
	
	RETURN

Endif   

ProcRegua( nCntView )

QryMestre->( DbGoTop() )

//�����������������������������������������������������
//�Alimenta o arquivo que sera gerado para o usuario. �
//�����������������������������������������������������
While !QryMestre->( Eof() )
	
	nConta ++                                                                                             '
	
	IncProc( "Processando "+AllTrim(Str(nConta))+" - De: "+AllTrim(Str(nCntView)) )
	
	cFilAtu := QryMestre->FILIAL
	cMatAtu := QryMestre->MAT
	cNomeAtu:= QryMestre->NOME 
	cCpfAtu := QryMestre->CPF 
	cCCAtu  := QryMestre->CC 
	
	While !QryMestre->( Eof() ) .and. cFilAtu == QryMestre->FILIAL .and. cMatAtu == QryMestre->MAT
		
		If QryMestre->CodFol == "783"
			nVal783 := QryMestre->VALOR
		Endif	
			
		If QryMestre->CodFol $ "782*783"
		   nBaseCal += QryMestre->VALOR
		ElseIf QryMestre->CodFol $ "006*376"
		   nBaseCal -= QryMestre->VALOR
		ElseIf QryMestre->CodFol == "809"
			nVal809 := QryMestre->VALOR
		ElseIf QryMestre->CodFol == "810"
			nVal810 := QryMestre->VALOR
		ElseIf QryMestre->CodFol == "955"
			nVal955 := QryMestre->VALOR
		Endif
		
		nValInss := nBaseCal*0.2825
		
		nValFgts := nBaseCal*0.08
		
		nValMed := nVal809+nVal955
		
		nValFer := ((nBaseCal/12)*1.33)*1.353
		
		nVal13 := (nBaseCal/12)*1.353
		
		QryMestre->( DbSkip() )
		
	EndDo
	
	// Grava o Arquivo Texto para o Excel
	cLin := "'"+cFilAtu+ cSep
	cLin += "'"+cMatAtu+ cSep
	cLin += cNomeAtu + cSep
	cLin += "'"+cCpfAtu+ cSep
	cLin += "'"+cCCAtu+ cSep
	cLin += Posicione("CTT", 1, xFilial("CTT")+cCCAtu, "CTT_DESC01" ) + cSep
	cLin += Subs(cFolMes,5,2)+Subs(cFolMes,1,4) + cSep
	
	If nBaseCal > 0
		cLin += Transform(nBaseCal,"@E 999,999,999.99") + cSep
	Else
		cLin += Transform(0,"@E 999,999,999.99") + cSep
	Endif
	
	If nVal809 > 0
		cLin += Transform(nVal809,"@E 999,999,999.99") + cSep
	Else
		cLin += Transform(0,"@E 999,999,999.99") + cSep
	Endif
	
	If nVal955 > 0
		cLin += Transform(nVal955,"@E 999,999,999.99") + cSep
	Else
		cLin += Transform(0,"@E 999,999,999.99") + cSep
	Endif
	
	If nValInss > 0
		cLin += Transform(nValInss,"@E 999,999,999.99") + cSep
	Else
		cLin += Transform(0,"@E 999,999,999.99") + cSep
	Endif
	
	If nValFgts > 0
		cLin += Transform(nValFgts,"@E 999,999,999.99") + cSep
	Else
		cLin += Transform(0,"@E 999,999,999.99") + cSep
	Endif
	
	If nVal810 > 0
		cLin += Transform(nVal810,"@E 999,999,999.99") + cSep
	Else
		cLin += Transform(0,"@E 999,999,999.99") + cSep
	Endif
	
	If nValMed > 0
		cLin += Transform(nValMed,"@E 999,999,999.99") + cSep
	Else
		cLin += Transform(0,"@E 999,999,999.99") + cSep
	Endif
	
	If nValFer > 0
		cLin += Transform(nValFer,"@E 999,999,999.99") + cSep
	Else
		cLin += Transform(0,"@E 999,999,999.99") + cSep
	Endif
	
	If nVal13 > 0
		cLin += Transform(nVal13,"@E 999,999,999.99") + cSep
	Else
		cLin += Transform(0,"@E 999,999,999.99") + cSep
	Endif
	
	nVal783  := 0
	nVal809  := 0
	nVal810  := 0
	nVal955  := 0
	nValInss := 0
	nValFgts := 0
	nValMed  := 0
	nValFer  := 0
	nVal13   := 0
   nBaseCal := 0 

	cLin += cEol
	
	fGravaTxt(cLin)
	
EndDo

fClose( nHdl )

__CopyFile( GetSrvProfString("StartPath","")+cArquivo, "folha_custo_price.csv" )


Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RGPEM02   �Autor  �Microsiga           � Data �  01/25/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
����������������������������������������������������������������������������� */
Static Function fGravaTxt( cLinha )

If fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)
	If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
		Return
	Endif
Endif

Return
