# include "rwmake.ch"
# include "PROTHEUS.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CATFA01  º Autor ³ Daniel G.Jr.TI1239 º Data ³ Abril/2013  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Carga de dados para o arquivo customizado de Bens do Ativo º±±
±±º          ³ Fixo (PAD)                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CATFA01()

Private oLeTxt

dbSelectArea("PAD")
dbSetOrder(1)

Processa({|| RunAtfa() },"Processando...")

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ RUNATFA  º Autor ³ AP5 IDE            º Data ³  11/10/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RunAtfa()

Local nTamFile, nTamLin, cBuffer, nBtLidos, cArqDest, _cLocali, _cKitLan
Local cDirect, cDirectImp, aDirect, _cCodAtf, _cVlNf, _cGrupo, _cDesGrp
Local _nIx, nTamCodAtf := TamSX3("PAD_CODATF")[1]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abertura do arquivo texto                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

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
