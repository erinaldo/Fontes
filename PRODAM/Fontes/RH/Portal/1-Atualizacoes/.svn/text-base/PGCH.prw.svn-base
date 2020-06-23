
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PGCH000    ºAutor  ³ Marcos Pereira    º Data ³  07/01/16  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcoes chamadas como link referente customizacoes no      º±±
±±º          ³ Portal GCH                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

///////////////////////////////////////////////////////////
// Funcao chamada pelo Link das customizações no Portal  //
// cPar1 -> string fixa passada por cada customizacao    //
// cPar2 -> Nome do arquivo texto contendo as matriculas //
//          da equipe do usuario logado, ou              //
//          Filial e Matricula do usuario logado
///////////////////////////////////////////////////////////
User Function PGCH(cPar1,cPar2)

Private cArqTemp_ := cPar2  //Esta variavel sera utilizada pela U_FiltrEq()

//varinfo("cPar1",cPar1)
//varinfo("cPar2",cPar2)
//varinfo("cModulo",cModulo)

If cPar1 == 'e8a97zb3' .and. cModulo == 'PON'     // Troca de Turno
	PONA160()
ElseIf cPar1 == '64fo2vy7' .and. cModulo == 'PON' // Autorização de Horas Extras
	PONA300("PONA300")
ElseIf cPar1 == 'u466w78i' .and. cModulo == 'MDT' // Consulta EPI
	Private cFilMDT_, cMatMDT_
	cPar2 		:= embaralha(cPar2,1)
	cPar2 		:= strtran(cPar2,"_"," ")
	cFilMDT_ 	:= substr(cPar2,11,TamSx3("RA_FILIAL")[1]) 
	cMatMDT_ 	:= substr(cPar2,(11+TamSx3("RA_FILIAL")[1]+10),6)
	varinfo("Filial",cFilMDT_)
	varinfo("Matricula",cMatMDT_)
	U_MDT001()
Else
	Alert("Tentativa de acesso não autorizado.")
EndIf

Return

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Funcao utilizada no cadastro de restricoes de acesso para filtrar as matriculas do browse da SRA de acordo  //
// com o conteudo do arquivo texto onde consta a equipe direta do usuario logado no portal                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function FiltrEq()

Local nTamFil 	:= TamSx3("RA_FILIAL")[1]
Local nTamLin 	:= nTamFil + 6
Local cFilAnt_ 	:= "@@"
Local cCond 	:= ""
Local cFil_ 	:= cMat_ := ""

//Variavel criada pela U_PGCH() contendo o nome do arquivo txt com as matriculas da equipe
//Se a mesma nao existir, nao executa este filtro. 
If Type("cArqTemp_")   == "U" 
	Return("")
EndIf

//varinfo("FiltrEq -> cArqTemp_ -> ",cArqTemp_)

//Se nao encontrar o arquivo, retorna filtro invalido para nao permitir visualização de nenhuma matricula.
If  !(File("\temp\"+cArqTemp_))
	Return("(RA_FILIAL=='@@')") 
Else

	FT_FUSE("\temp\"+cArqTemp_)
	FT_FGOTOP()
	
	While !FT_FEOF()
		cLinha	:= FT_FREADLN()
		cFil_	:= Subst(cLinha,1,nTamFil)
		cMat_	:= Subst(cLinha,nTamFil+1,6)
		If cFilAnt_ == '@@'
			cCond 		:= "(RA_FILIAL=='"+cFil_+"'.and.RA_MAT$'"+cMat_
			cFilAnt_ 	:= cFil_
		ElseIf cFil_ == cFilAnt_
			cCond += "/"+cMat_
		Else
			cCond 		+= "').or.(RA_FILIAL=='"+cFil_+"'.and.RA_MAT$'"+cMat_
			cFilAnt_ 	:= cFil_
		EndIf		
		FT_FSKIP()
	EndDo
	If len(cCond) > 0
		cCond += "')"
	EndIf
	FT_FUSE()
	If fErase("\temp\"+cArqTemp_) == -1
		varinfo("Arquivo nao foi deletado","\temp\"+cArqTemp_)
	EndIf
EndIf
  
//varinfo("filtro:",cCond)
Return(cCond)
        
	
