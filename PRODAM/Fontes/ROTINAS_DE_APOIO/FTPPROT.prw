#Include 'Protheus.ch'


///----------------------------------------------------------------------------------------------------
///----------------------------------------------------------------------------------------------------
/// Rotina que permite a copia de arquivos entre pastas do disco local e pastas da instalação Protheus
///----------------------------------------------------------------------------------------------------
///----------------------------------------------------------------------------------------------------
User Function FTPPROT()
///----------------------------------------------------------------------------------------------------
	Private oLbImp		:= Nil
	Private cDirOrig	:= Space(200)
	Private cDirDest 	:= Space(200)
	Private cTitDlg	:= "FTP - Protheus"
	Private aCpoImp 	:= {}
	Private aTitImp 	:= {}
	Private aVetImp 	:= {}
	Private aCpoPV 	:= {}
	Private aTitPV 	:= {}
	Private lMark 	  	:= .F.
	Private oOk   		:= LoadBitmap( GetResources(), "LBOK" )
	Private oNo   		:= LoadBitmap( GetResources(), "LBNO" )
	Private aDirect	:= {}
	Private lUnix		:= IsSrvUnix()
	Private cChar		:= IIf(lUnix,"/","\")
	Private cBusca		:= Space(50)
	Private	 nArqs		:= 0
///------------------------------------------------------------------------------------------------

//-------------------------------------------------------------------------------------------------
// Cria vetor para controlar as Colunas do ListBox
//-------------------------------------------------------------------------------------------------
// Posição 1 = identificador do campo
// Posição 2 = Título do ListBox
// Posição 3 = Variável ou campo a ser listado na coluna
// Posição 4 = Formato da coluna C=Caractere, N=Numerica, D=Data
// Posição 5 = .T. ou .F. (indica se a coluna será exibida no ListBox
//-------------------------------------------------------------------------------------------------
	AADD(aCpoImp,{"MRK"		,""						,""						,"C",.T.})
	AADD(aCpoImp,{"ARQ"		,"Arquivo"	    		,'xcArq'				,"C",.T.})
	AADD(aCpoImp,{"DATA"		,"Data"					,'xcData'				,"C",.T.})
	AADD(aCpoImp,{"TAM"		,"Tamanho"				,'xcTam'				,"C",.T.})
	AADD(aCpoImp,{"FILLER"	,""						,""						,"C",.T.})
	AADD(aCpoImp,{"_MRK"		,""						,".F."					,"C",.F.})
//-------------------------------------------------------------------------------------------------
// Cria vetor para cabeçalho do ListBox
//-------------------------------------------------------------------------------------------------
	For j:=1 to Len(aCpoImp)
		If aCpoImp[j,5] // Verifica se é para exibir no ListBox
			AADD(aTitImp, aCpoImp[j,2])
		EndIf
	Next
//-------------------------------------------------------------------------------------------------


//-------------------------------------------------------------------------------------------------
/// MONTA VETOR INICIAL EM BRANCO
//-------------------------------------------------------------------------------------------------
	MONT_VET("0")
//-------------------------------------------------------------------------------------------------


//-------------------------------------------------------------------------------------------------
// Define as fontes a serem utilizadas na montagemd as telas
//-------------------------------------------------------------------------------------------------
	DEFINE FONT oFnt00 	NAME "Arial" 				SIZE 14, - 24 BOLD
	DEFINE FONT oFntb01   NAME "Arial" 				SIZE 8, - 13 BOLD
	DEFINE FONT oFnt01 	NAME "Arial" 				SIZE 8, - 13
	DEFINE FONT oFntBt1 	NAME "Arial" 				SIZE 6, - 11 BOLD
	DEFINE FONT oFntTW 	NAME "Arial" 				SIZE 7, - 12
//------------------------------------------------------------------------------------------------
	
//---------------------------------------------------------------------------------------------------
// JANELA : Selecionar arquivos de origem
//---------------------------------------------------------------------------------------------------
	oDlg := MSDIALOG():New(000,000,500,800, cTitDlg ,,,,,,,,,.T.)
	@ 010,010 Say OemToAnsi("FTP - Seleção de Arquivos")		SIZE 300,020 OF oDlg PIXEL FONT oFnt00 COLOR CLR_BLUE
	@ 030,005 To 032,393 OF oDlg PIXEL
	///----------------------------------
	@ 040,010 Say OemToAnsi("Selecione a pasta de ORIGEM dos arquivos:")		SIZE 400,010 OF oDlg PIXEL FONT oFnt01
	@ 053,010 GET cDirOrig  SIZE 350,10 Picture "@!" OF oDlg When .T. PIXEL  FONT oFnt01
	oSpdBt2 	:= tButton():New(038,180, "Pasta Servidor", oDlg, {|| MONT_VET("1",1)}, 075,012,,oFnt01,,.T.)
	oSpdBt4 	:= tButton():New(038,260, "Pasta Local", oDlg, {|| MONT_VET("1",2)}, 055,012,,oFnt01,,.T.)
	///----------------------------------
	@ 069,005 To 071,393 OF oDlg PIXEL
	@ 076,010 Say OemToAnsi("Busca:")		SIZE 400,010 OF oDlg PIXEL FONT oFnt01
	@ 074,040 GET cBusca  SIZE 100,10 Picture "@!" OF oDlg When .T. PIXEL  FONT oFnt01
	oSpdBt6 	:= tButton():New(075,150, "Buscar", oDlg, {|| BUSCAR()}, 035,012,,oFnt01,,.T.)
	oSpdBt7 	:= tButton():New(075,190, "Filtrar", oDlg, {|| MONT_VET("2",0) }, 035,012,,oFnt01,,.T.)
	oSpdBt8 	:= tButton():New(075,230, "Todos", oDlg, {|| MONT_VET("3",0) }, 035,012,,oFnt01,,.T.)
	@ 076,315 Say OemToAnsi("Arquivos =>")		SIZE 050,010 OF oDlg PIXEL FONT oFnt01
	@ 074,360 GET nArqs SIZE 20,10 Picture "@E 99999" OF oDlg When .F. PIXEL  FONT oFnt01
	oLbImp := TwBrowse():New(90,10,380,90,,aTitImp,,oDlg,,,,,{|| Recalc(),oLbImp:Refresh()},,oFntTW,,,,,.F.,,.T.,,.F.,,,)
	oLbImp:SetArray( aVetImp )
	oLbImp:bLine := {|| RetVt(oLbImp:nAt)}
		///----------------------------------
	@ 185,005 To 187,393 OF oDlg PIXEL
	@ 195,010 Say OemToAnsi("Selecione a pasta de DESTINO dos arquivos:")		SIZE 400,010 OF oDlg PIXEL FONT oFnt01
	@ 208,010 GET cDirDest  SIZE 350,10 Picture "@!" OF oDlg When .T. PIXEL  FONT oFnt01
	oSpdBt3 	:= tButton():New(193,180, "Pasta Servidor", oDlg, {|| GET_DIR("S")}, 075,012,,oFnt01,,.T.)
	oSpdBt5 	:= tButton():New(193,260, "Pasta Local", oDlg, {|| GET_DIR("L")}, 055,012,,oFnt01,,.T.)
	//oSpdBt9 	:= tButton():New(193,320, "Criar Pasta", oDlg, {|| INC_DIR()}, 055,012,,oFnt01,,.T.)
		///----------------------------------
	@ 228,005 To 230,393 OF oDlg PIXEL
	oSpdBt0 	:= tButton():New(235,325, "C O P I A R", 	oDlg, {|| lOkVld := FTPCopia(), IIF(lOkVld , Inkey(1) , .T.),IIF(lOkVld , oDlg:End() , .T.) }, 	065, 013,,oFntBt1,,.t.)
	oSpdBt1 	:= tButton():New(235,010 ,"S A I R",	 		oDlg, {|| oDlg:End()}, 	065, 013,,oFntBt1,,.t.)
	Activate MsDialog oDlg Center
//---------------------------------------------------------------------------------------------------

Return()





///---------------------------------------------------------------------------------------------------
/// ABRE OS ARQUIVOS A SEREM IMPORTADOS NA PASTA DE ORIGEM, VALIDA OS DADOS E GERA A TABELA "SZ3"
///---------------------------------------------------------------------------------------------------
Static Function FTPCopia()
///---------------------------------------------------------------------------------------------------
	Local lCopia 	:= .F.
	Local j			:= 0
	Local nCopia	:= 0

	If Empty(cDirOrig) .or. Empty(cDirDest)
		ApMsgStop("Pasta de origem ou destino não informada !")
	Return(.F.)
	EndIf

	If !ExistDir(AllTrim(cDirOrig))
		ApMsgStop('Pasta de Origem não encontrada !' )
	Return(.F.)
	EndIf

	If !ExistDir(AllTrim(cDirDest))
		ApMsgStop('Pasta de Destino não encontrada !' )
	Return(.F.)
	EndIf

	If Substr(AllTrim(cDirOrig),Len(AllTrim(cDirOrig)),1) <> cChar
		ApMsgStop('A pasta de Origem precisa terminar com "'+cChar+'" !' )
	Return(.F.)
	EndIf

	If Substr(AllTrim(cDirDest),Len(AllTrim(cDirDest)),1) <> cChar
		ApMsgStop('A pasta de Destino precisa terminar com "'+cChar+'" !' )
	Return(.F.)
	EndIf


	If AllTrim(cDirOrig) == AllTrim(cDirDest)
		ApMsgStop("As pastas de origem e destino não podem ser iguais !")
	Return(.F.)
	EndIf

	///Verifica se tem item selecionado
	For j := 1 to Len(aVetImp)
		If !Empty(aVetImp[j,POS("ARQ")]) .and. aVetImp[j,POS("_MRK")]
			If !File(AllTrim(cDirDest) + aVetImp[j,POS("ARQ")])
				lCopia := .T.
				nCopia += 1
			Else
				If ApMsgYesNo("Arquivo já existente na pasta de destino ==> " + aVetImp[j,POS("ARQ")] + CRLF + "Deseja sobrescrever o arquivo já existente ?")
					lCopia := .T.
					nCopia += 1
				EndIf
			EndIf
		EndIf
	Next

	If lCopia
		Processa({|| CopiaArq(nCopia)})
	Else
		ApMsgStop("Nenhum arquivo selecionado !")
	Return(.F.)
	EndIf


Return(.T.)
	





///----------------------------------------------------------------------------------------------
/// Função que retorna o conteúdo de uma coluna
///----------------------------------------------------------------------------------------------
Static Function RetVt(nLin)
///----------------------------------------------------------------------------------------------
	Local aVt := {}
///----------------------------------------------------------------------------------------------
	
	For f:=1 to Len(aCpoImp)
		If aCpoImp[f,5]
			AADD(aVt,aVetImp[nLin,f])
		EndIf
	Next
Return(aVt)




Static Function CopiaArq(nCopIt)

	ProcRegua(nCopIt)
	///Executa a cópia dos itens selecionados
	For j := 1 to Len(aVetImp)
		If !Empty(aVetImp[j,POS("ARQ")]) .and. aVetImp[j,POS("_MRK")]
			IncProc(OEMtoAnsi("Copiando arquivo => " +AllTrim(aVetImp[j,POS("ARQ")]) ))
			Inkey(2)
			__CopyFile(AllTrim(cDirOrig) + aVetImp[j,POS("ARQ")],AllTrim(cDirDest) + aVetImp[j,POS("ARQ")])
		EndIf
	Next

Return




///----------------------------------------------------------------------------------------------
/// FUNCAO QUE MONTA O VETOR CONTENDO OS DADOS DOS ARQUIVOS A SEREM IMPORTADOS
///----------------------------------------------------------------------------------------------
Static Function MONT_VET(cPar01,cPar02)
///----------------------------------------------------------------------------------------------
	Local aDirect	:= {}
	Local cDirect 	:= Space(200)
	Local nPos		:= 0
///----------------------------------------------------------------------------------------------
	
	If cPar01 == "2" .or. cPar01 == "3"
		cDirect := cDirOrig
		If Empty(cBusca)
		Return()
		EndIf
	EndIf

	nArqs 	:= 0
	aVetImp	:= {}
 
///----------------------------------------------------------------------------------------------
/// Busca no diretorio especificado os arquivos disponíveis para importação
///----------------------------------------------------------------------------------------------
	If cPar01 == "1"
		Do case
		Case cPar02 <> Nil .and. cPar02 = 1
			cDirect := ALLTRIM(cGetFile("Arquivos |*.*",'Selecão de pasta', 0,"SERVIDOR\",.T., GETF_RETDIRECTORY,.T.,.T.)) //GETF_ONLYSERVER
		Case cPar02 <> Nil .and. cPar02 = 2
			cDirect := ALLTRIM(cGetFile("Arquivos |*.*",'Selecão de pasta', 0,'', .T., GETF_LOCALHARD + GETF_RETDIRECTORY,.F.))  //GETF_OVERWRITEPROMPT
		OtherWise
			cDirect := ALLTRIM(cGetFile("Arquivos |*.*",'Selecão de pasta', 0,"SERVIDOR\",.T., GETF_LOCALHARD + GETF_RETDIRECTORY,.T.,.T. )) //GETF_OVERWRITEPROMPT
		EndCase
	EndIf
	If !Empty(cDirect)
		aDirect:= directory(AllTrim(cDirect)+"*.*")
		asort(aDirect,,, { |x,y| (x[1]) < (y[1]) })
		If cPar02 <> Nil
			If cpar02 = 1 .or. cpar02 = 2 .or. cpar02 = 3
				cDirOrig := AllTrim(cDirect) + Replicate(" ", 200 - Len(AllTrim(cDirect)))
			EndIf
		EndIf
	EndIf
//-----------------------------------------------------------------------------

	If Len(aDirect) > 0
		For i:=1 to Len(aDirect)
			xcArq 	:= Upper(aDirect[i,1])
			xcArq	:= AllTrim(xcArq) +  Replicate(" ", 150 - Len(AllTrim(xcArq)))
			xcTam	:= aDirect[i,2]
			xcData	:= aDirect[i,3]
			xcTpArq	:= Substr(xcArq,1,4)
			If cPar01 == "1" .or. cPar01 == "3" .or. (cPar01 == "2" .and. AllTrim(cBusca) $ AllTrim(xcArq))
				aCpo := {}
				AADD(aCpo,oNo)
				For f:=2 to Len(aCpoImp)
					cCpo := aCpoImp[f,3]
					AADD(aCpo,&cCpo)
				Next
				AADD(aVetImp,aCpo)
				nArqs += 1
			EndIf
		Next
	EndIf

	If Len(aVetImp)<=0
		aCpo := {}
		AADD(aCpo,oNo)
		For f:=2 to Len(aCpoImp)
			AADD(aCpo,"")
		Next
		AADD(aVetImp,aCpo)
	EndIf

	If cPar01 <> "0"
		oLbImp:SetArray( aVetImp )
		oLbImp:bLine := {|| RetVt(oLbImp:nAt)}
		oLbImp:Refresh()
		oDlg:Refresh()
	EndIf


Return()



///------------------------------------------------------------------------------------------------
/// Função que Cria nova pasta no caminho de destino.
///------------------------------------------------------------------------------------------------
Static Function INC_DIR()
	Local cNewDir := "\TESTE"
	Local nRet := -1

	If Empty(cDirDest)
		ApMsgStop("Pasta de destino não informada !")
	Return(.F.)
	EndIf

		If !ExistDir(AllTrim(cDirDest))
		ApMsgStop('Pasta de Destino não encontrada !' )
	Return(.F.)
	EndIf
	
		If Substr(AllTrim(cDirDest),Len(AllTrim(cDirDest)),1) <> cChar
		ApMsgStop('A pasta de Destino precisa terminar com "'+cChar+'" !' )
	Return(.F.)
	EndIf
	

	If ApMsgYesNo("Confirma a criação da nova pasta " + AllTrim(cNewDir) + " ? ")
		nRet := MakeDir(AllTrim(cDirDest) + Alltrim(cNewDir))

		if nRet != 0
			ApMsgInfo( "Não foi possível criar o diretório !" )
		Else
			cDirDest	:= AllTrim(cDirDest) + Substr(AllTrim(cNewDir),2) + cChar
			cDirDest 	:= AllTrim(cDirDest) +  Replicate(" ", 200 - Len(AllTrim(cDirDest)))	
		endIf
	EndIf
	
Return



///------------------------------------------------------------------------------------------------
/// Função que retorna o caminho de uma pasta do servidor ou local.
///------------------------------------------------------------------------------------------------
Static Function GET_DIR(cPar)
	
	cDirDest := Space(200)
	 
	If cPar = "S"
		cDirDest	:= ALLTRIM(cGetFile("Arquivos |*.*",'Selecão de pasta', 0,"SERVIDOR\",.T., GETF_RETDIRECTORY,.T.,.T.)) //GETF_ONLYSERVER
	EndIf
	
	If cPar = "L"
		cDirDest 	:= ALLTRIM(cGetFile("Arquivos |*.*",'Selecão de pasta', 0,'', .T., GETF_LOCALHARD + GETF_NETWORKDRIVE + GETF_RETDIRECTORY,.F.))
	EndIf
	cDirDest 	:= AllTrim(cDirDest) +  Replicate(" ", 200 - Len(AllTrim(cDirDest)))
	
Return()


///----------------------------------------------------------------------------------------------
// Função para marcar e desmarcar registro no mark browse
///----------------------------------------------------------------------------------------------
Static Function Recalc()
///----------------------------------------------------------------------------------------------
	Local nPosAtu 		:= oLbImp:nAt
	Local cArqAtu 		:= aVetImp[oLbImp:nAt,POS("ARQ")]
///----------------------------------------------------------------------------------------------
	Private aValid 	:= {}
///----------------------------------------------------------------------------------------------
	
	If !Empty(cArqAtu)
		aVetImp[nPosAtu,POS("_MRK")] 	:= !aVetImp[nPosAtu,POS("_MRK")]
		aVetImp[nPosAtu,1]				:= Iif(aVetImp[nPosAtu,POS("_MRK")],oOk,oNo)
	EndIf

Return(.T.)




///----------------------------------------------------------------------------------------------
/// Função que retorna o número da coluna.
///----------------------------------------------------------------------------------------------
Static Function POS(xPar)
///----------------------------------------------------------------------------------------------
	Local nPos := 0
///----------------------------------------------------------------------------------------------

	For f:=1 to Len(aCpoImp)
		If aCpoImp[f,1] == xPar
			nPos := f
		EndIf
	Next
Return(nPos)



///----------------------------------------------------------------------------------------------
/// Localizar arquivo
///----------------------------------------------------------------------------------------------
Static Function BUSCAR()
	Local nLinAtu := oLbImp:nAt
	If Len(aVetImp)>0 .and. !Empty(cBusca)
		For j := nLinAtu to Len(aVetImp)
			If !Empty(aVetImp[j,POS("ARQ")])
				If AllTrim(cBusca) $ aVetImp[j,POS("ARQ")]
					oLbImp:nAt 	:=  j
					If nLinAtu < j
						Exit
					EndIf
				EndIf
			EndIf
		Next
	EndIf
	oLbImp:Refresh()
Return()
