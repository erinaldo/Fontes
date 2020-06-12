# include "rwmake.ch"
# include "PROTHEUS.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CATFA01  � Autor � Daniel G.Jr.TI1239 � Data � Abril/2013  ���
�������������������������������������������������������������������������͹��
���Descricao � Carga de dados para o arquivo customizado de Bens do Ativo ���
���          � Fixo (PAD)                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function CATFA01()

Private oLeTxt

dbSelectArea("PAD")
dbSetOrder(1)

Processa({|| RunAtfa() },"Processando...")

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � RUNATFA  � Autor � AP5 IDE            � Data �  11/10/06   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function RunAtfa()

Local nTamFile, nTamLin, cBuffer, nBtLidos, cArqDest, _cLocali, _cKitLan
Local cDirect, cDirectImp, aDirect, _cCodAtf, _cVlNf, _cGrupo, _cDesGrp
Local _nIx, nTamCodAtf := TamSX3("PAD_CODATF")[1]

//���������������������������������������������������������������������Ŀ
//� Abertura do arquivo texto                                           �
//�����������������������������������������������������������������������

If cEmpant == '01' //SP
	cDirect    := "arq_txt\contabilidade\Ativo\"
	cDirectImp := "arq_txt\contabilidade\Ativo\Backup\"
ElseIf cEmpant == '03' //RJ
	cDirect    := "\arq_txtrj\contabilidade\Ativo\"
	cDirectImp := "\arq_txtrj\contabilidade\Ativo\Backup\"
EndIf
aDirect    := Directory(cDirect+"*.TXT")

If Len(aDirect)>0
	For _nIx := 1 to Len(adirect)
		FT_FUSE(cDirect+adirect[_nIx,1])
		FT_FGOTOP()
		ProcRegua(FT_FLASTREC())
		
		While !FT_FEOF()
			
			IncProc("Processando Leitura do Arquivo Texto...")
			
			/*
			PAD_CODATF,5
			PAD_VLNF,14,3 (DECIMAL INTEGRADO)
			PAD_GRUPO,5
			PAD_DESGRP,40
			*/
			
			cBuffer  := Alltrim(FT_FREADLN())
			_cCodAtf :=	PadR(Substr(cBuffer,1,(At(";",cBuffer)-1)),nTamCodAtf)
			
			cBuffer	 :=	Substr(cBuffer,(At(";",cBuffer)+1),500)
			_cVlNf   :=	Substr(cBuffer,1,(At(";",cBuffer)-1))
			
			cBuffer	 :=	Substr(cBuffer,(At(";",cBuffer)+1),500)
			_cGrupo  :=	Substr(cBuffer,1,(At(";",cBuffer)-1))
			
			cBuffer	 :=	Substr(cBuffer,(At(";",cBuffer)+1),500)
			_cDesGrp :=	Substr(cBuffer,1)
			
			dbSelectArea("PAD")
			dbSetOrder(1) //FILIAL + REQUISICAO + PRODUTO
			If !DbSeek(xFilial("PAD")+_cCodAtf)
				RecLock("PAD",.T.)
				PAD->PAD_FILIAL		:= xFilial("PAD")
				PAD->PAD_CODATF		:= _cCodAtf
				PAD->PAD_VLNF		:= Round(Val(_cVlNf)*0.01,2)
				PAD->PAD_GRUPO		:= _cGrupo
				PAD->PAD_DESGRP		:= _cDesGrp
				PAD->(MSUnLock())
			Else
				RecLock("PAD",.F.)
				PAD->PAD_FILIAL		:= xFilial("PAD")
				PAD->PAD_CODATF		:= _cCodAtf
				PAD->PAD_VLNF		:= Round(Val(_cVlNf)*0.01,2)
				PAD->PAD_GRUPO		:= _cGrupo
				PAD->PAD_DESGRP		:= _cDesGrp
				PAD->(MSUnLock())							
			EndIf
			FT_FSKIP()
		EndDo
		
		FT_FUSE()
		
	Next _nIx
	
	//Copia e Deleta o arquivo da pasta Origem para a pasta Importado. De qualquer Banco
	For _nIy := 1 to Len(adirect)
		K := SubStr(aDirect[_nIy,1],1,At(".",aDirect[_nIy,1])-1)+"_"+DtoS(DDATABASE)+".TXT"
		__copyfile(cDirect+adirect[_nIy,1],cDirectImp+cArqDest)
		ferase(cDirect+adirect[_nIy,1])
	Next
	
EndIf

Return
