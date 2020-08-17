#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FinA06aImp�Autor  �Carlos Tagliaferri	 � Data �  Jul/11     ���
�������������������������������������������������������������������������͹��
���Desc.     � Importacao dos itens do excel para o aCols                 ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FinA06aImp()

Local aImport	:= {}
Local nI		:= 0
Local nJ		:= 0
Local nK		:= 0
Local aNCols    := {}

aImport := U_RCTBMA0() 

If Empty(aImport)
	Return
Endif

If Empty(aCols[1][1])
	aCols := {}
	For nI := 1 to Len(aImport)
		Aadd(aCols,Array(Len(aHeader)+1))
		For nK := 1 To Len(aHeader)
			aCols[nI][nK]	:= CriaVar(aHeader[nK,2],.F.)
		Next nK
	   	
		For nJ := 1 to Len(aCols[nI]) - 2                 			
	    	If nJ == 1
	    		aCols[nI][nJ] := If(VALTYPE(aImport[nI][nJ])=="C",STRTRAN(aImport[nI][nJ],CHR(160),""),aImport[nI][nJ])	
	    	ElseIf nJ == 2
	    		aCols[nI][nJ] := Posicione("CTT",1,xFilial("CTT")+aCols[nI,1],"CTT_DESC01")
	    		aCols[nI][nJ+1] := If(VALTYPE(aImport[nI][nJ])=="C",STRTRAN(aImport[nI][nJ],CHR(160),""),aImport[nI][nJ])	
	    		aCols[nI][nJ+2] := (aCols[nI][nJ+1] * nValRat) / 100
	    	Else
	    		aCols[nI][nJ+2] := If(VALTYPE(aImport[nI][nJ])=="C",STRTRAN(aImport[nI][nJ],CHR(160),""),aImport[nI][nJ])	
	    	EndIf
		Next nJ
	Next nI	
Else
	For nI := 1 to Len(aImport)
		Aadd(aCols,Array(Len(aHeader)+1))
		For nK := 1 To Len(aHeader)
			aCols[Len(aCols)][nK]	:= CriaVar(aHeader[nK,2],.F.)
		Next nK
	   	
		For nJ := 1 to Len(aCols[nI]) - 2                 			
	    	If nJ == 1
	    		aCols[Len(aCols)][nJ] := If(VALTYPE(aImport[nI][nJ])=="C",STRTRAN(aImport[nI][nJ],CHR(160),""),aImport[nI][nJ])	
	    	ElseIf nJ == 2
	    		aCols[Len(aCols)][nJ] := Posicione("CTT",1,xFilial("CTT")+aCols[Len(aCols)][1],"CTT_DESC01")
	    		aCols[Len(aCols)][nJ+1] := If(VALTYPE(aImport[nI][nJ])=="C",STRTRAN(aImport[nI][nJ],CHR(160),""),aImport[nI][nJ])	
	    		aCols[Len(aCols)][nJ+2] := (aCols[Len(aCols)][nJ+1] * nValRat) / 100
	    	Else
	    		aCols[Len(aCols)][nJ+2] := If(VALTYPE(aImport[nI][nJ])=="C",STRTRAN(aImport[nI][nJ],CHR(160),""),aImport[nI][nJ])	
	    	EndIf
		Next nJ
	Next nI	
EndIf

nValDRat := 0
nPerDRat := 0
For nW := 1 to Len(aCols)
	If aCols[nW][Len(aHeader)+1]
		nValDRat += aCols[nW][4]
		nPerDRat += aCols[nW][3]
	EndIf
Next nW

nPerDRat := Round(nPerDRat,2)

/*����������������������������������������������������������������������������Ŀ
  �                        Atualiza o Objeto na Tela                           �
  ������������������������������������������������������������������������������*/

oValDRat:Refresh() 
oPerDRat:Refresh() 


Return 
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FinA06aExp�Autor  �Carlos Tagliaferri	 � Data �  Jul/11     ���
�������������������������������������������������������������������������͹��
���Desc.     � Exportacao dos itens para excel                            ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FinA06aExp()

Local aItensEx 	:= {} 
Local nI		:= 0
Local nJ		:= 0

aItensEx := aClone(aCols)
  
MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",{||GeraExcel({{"GETDADOS","CONTAS DE RATEIO",aHeader,aItensEx}})})

Return      
/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o    � GeraExcel� Autor �  Rafael Gama          � Data � 04/01/2011 ���
���������������������������������������������������������������������������Ĵ��
���Descri��o �Funcao que exporta os valores da tela para o Microsoft Excel  ���
���          �no formato .CSV                                               ���
���������������������������������������������������������������������������Ĵ��
���Par�metros� Array contendo os objetos a serem exportados                 ���
���������������������������������������������������������������������������Ĵ��
���Retorno   � Nil                                                          ���
���������������������������������������������������������������������������Ĵ��
��� Uso      � CSU			                                                ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/
Static Function GeraExcel(aExport)

Local aArea		:= GetArea()
Local cDirDocs	:= MsDocPath() 
Local cPath		:= AllTrim(GetTempPath())
Local aCampos	:= {}
Local oExcelApp := Nil
Local cArquivo  := "Rateio"+DtoS(dDataBase)
Local _cArquivo	:= ""

aTamSX3 := TAMSX3("EZ_CCUSTO")
Aadd(aCampos, { "CCUSTO"		,aTamSX3[3],aTamSX3[1],aTamSX3[2]})

aTamSX3 := TAMSX3("EZ_PERC")
Aadd(aCampos, { "PERCENT"		,aTamSX3[3],aTamSX3[1],aTamSX3[2]})

aTamSX3 := TAMSX3("EZ_VALOR")
Aadd(aCampos, { "VALOR"		,aTamSX3[3],aTamSX3[1],aTamSX3[2]})

aTamSX3 := TAMSX3("EZ_ITEMCTA")
Aadd(aCampos, { "UNNEGOC"		,aTamSX3[3],aTamSX3[1],aTamSX3[2]})

aTamSX3 := TAMSX3("EZ_CLVL")
Aadd(aCampos, { "OPERACA"		,aTamSX3[3],aTamSX3[1],aTamSX3[2]})

cArq := CriaTrab(aCampos,.T.)
dbUseArea(.T.,"DBFCDX",cArq,"TMPTRB",.f.)
DbSelectArea("TMPTRB")                                           

//���������������������������������������������������������Ŀ
//� Cria os indices temporarios								�
//�����������������������������������������������������������
aInd	:= {}
Aadd(aInd,{CriaTrab(Nil,.F.),"CCUSTO","C.Custo"})

For nA := 1 to Len(aInd)
	IndRegua("TMPTRB",aInd[nA,1],aInd[nA,2],,,OemToAnsi("Criando �ndice Tempor�rio...") )
Next nA
DbClearIndex()

For nA := 1 to Len(aInd)
	dbSetIndex(aInd[nA,1]+OrdBagExt())
Next nA

For nLoop := 1 to Len(aExport[1,4])
	RecLock("TMPTRB",.T.)
		TMPTRB->CCUSTO	:= aExport[1,4,nLoop,BuscaHeader(aHeader,"EZ_CCUSTO")]
		TMPTRB->PERCENT	:= aExport[1,4,nLoop,BuscaHeader(aHeader,"EZ_PERC")]
		TMPTRB->VALOR	:= aExport[1,4,nLoop,BuscaHeader(aHeader,"EZ_VALOR")]
		TMPTRB->UNNEGOC	:= aExport[1,4,nLoop,BuscaHeader(aHeader,"EZ_ITEMCTA")]
		TMPTRB->OPERACA	:= aExport[1,4,nLoop,BuscaHeader(aHeader,"EZ_CLVL")]
	MsUnlock()
Next nLoop
                                  
_cArquivo := cDirDocs+ "\" +cArquivo+".xls"

Copy to &_cArquivo
dbCloseArea("TMPTRB")

CpyS2T( _cArquivo , cPath, .T. )
If ! ApOleClient( 'MsExcel' )
	MsgStop( "MsExcel nao instalado" )
	Return
EndIf
oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open( cPath+cArquivo+".xls" ) // Abre uma planilha
oExcelApp:SetVisible(.T.)

RestArea(aArea)
Return

/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o    �BuscaHeader� Autor �Jaime Wikanski        � Data �            ���
���������������������������������������������������������������������������Ĵ��
���Descri��o �Pesquisa a posicao do campo no aheader                        ���
���������������������������������������������������������������������������Ĵ��
���Uso       �                                                              ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/
Static Function BuscaHeader(aArrayHeader,cCampo)

Return(AScan(aArrayHeader,{|aDados| AllTrim(Upper(aDados[2])) == Alltrim(Upper(cCampo))}))

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FinA06Del �Autor  �Carlos Tagliaferri  � Data �  Jul/11     ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para deletar todos os itens.                        ���
�������������������������������������������������������������������������͹��
���Uso       � CSU                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FinA06aDel()
//�����������������������Ŀ
//�Declara��o de vari�veis�
//�������������������������                       
Local nLoop	:= 0

//����������������������������������������������������Ŀ
//�Marcar todos os registros da GetDados como deletados�
//������������������������������������������������������
For nLoop := 1 to Len(aCols)
	aCols[nLoop][Len(aHeader)+1] := .T.
Next nLoop

Return 