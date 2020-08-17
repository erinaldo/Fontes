#include "protheus.ch"
#include "apcfg40.ch"
#include "TOPCONN.CH"

Static aAcessos
Static aModulos
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ CSURELFU ³ Autor ³ FERNANDO BARRETO      ³ Data ³ Jan/2012 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relatorio de funcionarios com o objetivo de atender        ³±±
±±³		     ³ o chamado 0026/12                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CSU                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CSURELFU()
Local cbcont   := 0
Local cabec1   := ""//OemToAnsi(STR0007) //"RELACAO DO CADASTRO DE USUÁRIOS"
Local cabec2   := ""
Local cabec3   := ""
Local nPos
Local wnrel:= "CSURELFU"
Local CbTxt
Local cString  := ""
Local tamanho    := "G"
Local limite     := 132
Local titulo     := "Relação dos funcionários"
Local cDesc1     := "Relação dos status dos funcionários "
Local cDesc2     := "Ira imprimir os dados dos funcionários "
Local cDesc3     := "de acordo com a situação."
Local Pg		 := "CSURELFU"
Private cGrpAnt    := ""
Private cUsrAnt    := ""
Private aReturn  := { OemToAnsi(STR0005), 1,OemToAnsi(STR0006), 2, 2, 1, "",1 } //"Zebrado"###"Administração"
Private aLinha   := { }
Private nomeprog := "CSURELFU"
Private AParDef  := {}
Private nLastKey
Private cString  := ""
PRIVATE M_PAG:=1
Private nTipo
Private cDirDocs    := MsDocPath()
Private cArquivo	:= CriaTrab(Nil,.f.)
Private cCmd		:= cDirDocs+"\"+cArquivo+".xls"
Private cArq		:= "c:\relatorio.xls"
Private cPath := alltrim(GetTempPath())

ValidPerg(Pg)
Pergunte(Pg,.T.)
wnrel := SetPrint(cString,wnrel,Pg,@Titulo,cDesc1,cDesc2,cDesc3,.T.,{},,tamanho,,.T.)
If nLastKey = 27
	Return
EndIf
SetDefault(aReturn,cString)
If nLastKey = 27
	Return
EndIf
nTipo := IF(aReturn[4] == 1, 15, 18)
RptStatus({|lEnd| CSURELFUN(@lEnd,Cabec1,Cabec2,Cabec3,limite,tamanho,cbCont,wnrel)},Titulo)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ CSURUNRPT³ Autor ³ FERNANDO BARRETO      ³ Data ³ Jan/2012 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Função de processamento do relatorio                       ³±±
±±³		     ³	                                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CSU                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CSURELFUN(lEnd,Cabec1,Cabec2,Cabec3,limite,tamanho,cbCont,wnrel)
Local xnCont    := 0
Local nCount:=0
Local nLogTam := 0
Local cMat:='' //"Matricula"
Local cLogn:=''
Local cLognA:=''
Local cNome:=''
Local cCPF:=''
Local cCargo:=''
Local cDepart:=''
Local cLogn:=''
Local aCabExcel :={}
Local aItensExcel :={}
Local TMP := "TMP"
Local cTMP:=" "
Private cCabec1  := Cabec1
Private cCabec2  := Cabec2
Private cCabec3  := ""
Private nTamanho := Tamanho
Private ctitulo     := "Relação dos funcionários"
Private li
Private nPadr	:= 3
Private nPadr2	:= 6
Private nPadr3	:= 7
Private nPadr4	:= 11
Private nPadr5	:= 20
Private nPadr6	:= 25
Private nPadr7	:= 30

If aModulos == Nil
	aModulos := RetModName()
	Aadd(aModulos,{99,"SIGACFG",STR0076,.F.})
EndIf
If aAcessos == Nil
	#IFNDEF AP710
		aAcessos := GetAccessList()
	#ELSE
		aAcessos := {}
		If File("SIGAMAT"+RetAcsName())
			FT_FUSE("SIGAMAT"+RetAcsName())
			FT_FGOTOP()
			While !FT_FEof()
				AADD(aAcessos,{,OemToAnsi(FT_FREADLN()),"",""})
				FT_FSKIP()
			End
			FT_Fuse()
		Else
			ApMsgAlert(STR0008,STR0009) //"Arquivo de acessos não Encontrado!"###"Atenção"
		Endif
	#ENDIF
EndIf

if mv_par07 == 1 //ORDER BY
	cOrder:="RA_FILIAL"
ELSE
	cOrder:="RA_NOME"
ENDIF
/*
ÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
|		FUNCIONARIOS ATIVOS             |
ÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁ
*/
If mv_par02 == 1 //SITUACAO DOS ATIVOS
	nPadr	:= 3
	nPadr2	:= 6
	nPadr3	:= 7
	nPadr4	:= 11
	nPadr5	:= 20
	nPadr6	:= 30
	nPadr7	:= 35
	
	IF Select("FUNAT")>0
		FUNAT->(dbCloseArea())
	Endif
	cQuery := "SELECT DISTINCT RA_FILIAL, RA_MAT, RA_NOME, RA_CIC, RJ_DESC, CTT_DESC01 "
	cQuery += "FROM "+RetSqlName('SRA') + " SRA, " +RetSqlName('SRJ') + " SRJ, " +RetSqlName('CTT') + " CTT "
	cQuery += "WHERE RA_DEMISSA='' AND RA_SITFOLH='' AND RJ_FUNCAO=RA_CODFUNC AND RA_CC=CTT_CUSTO and RA_FILIAL between '"+mv_par05+"' and '"+mv_par06+"' "
	cQuery += "AND RA_ADMISSA >= '"+DTOS(mv_par03)+ "' AND RA_ADMISSA <= '"+DTOS(mv_par04)+"' AND CTT.D_E_L_E_T_='' order by "+cOrder
	
	TCQUERY cQuery NEW ALIAS "FUNAT"
	FUNAT->(dbGoTop())
	
	IF mv_par01 == 2   //GERA ARQUIVO PARA EXCEL
		AADD(aCabExcel, {"FILIAL" ,"C", 02, 0})
		AADD(aCabExcel, {"MAT" ,"C", 06, 0})
		AADD(aCabExcel, {"LOGIN" ,"C", 07, 0})
		AADD(aCabExcel, {"NOME" ,"C", 70, 0})
		AADD(aCabExcel, {"CPF" ,"C", 11, 0})
		AADD(aCabExcel, {"CARGO" ,"C", 70, 0})
		AADD(aCabExcel, {"DEPART" ,"C", 70, 0})
		aUsuarios := AllUsers(,.T.)
		
		WHILE !FUNAT->(eof())
			cFil:="'"+FUNAT->RA_FILIAL
			cMat:="'"+ALLTRIM(FUNAT->RA_MAT)
			cNome:=FUNAT->RA_NOME
			cCpf:="'"+FUNAT->RA_CIC
			cCargo:=FUNAT->RJ_DESC
			cDepart:=FUNAT->CTT_DESC01
			cMat1:=''
			IncProc("Processando: Mat: "+cMat)
			//PROCURA SE TEM USUÁRIO MICROSIGA
			
			For x:= 1 to len(aUsuarios)
				cString := alltrim(aUsuarios[x,1,22])
				if len(cString) > 6
					cMat1 := substr(cString,5,10)
				endif
				IF cMat1 == FUNAT->RA_MAT
					cLogn:= aUsuarios[x,1,2]
					x:=Len(aUsuarios)
				else
					cLogn:='VAZIO'
				ENDIF
			next
			AADD(aItensExcel,{cFil,cMat,cLogn,cNome,cDepart,cCPF,cCargo,})
			dbSkip()
		enddo
		MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",;
		{||DlgToExcel({{"GETDADOS", "RELATÓRIOS DOS FUNCIONÁRIOS ATIVOS DA CSU", aCabExcel,aItensExcel}})})
		
		return
	ENDIF
	
	IF mv_par01 == 1 //GERA CABECALHO TEXTO
		cCabec2:=Padr("FIL",nPadr) +" | "+Padr("MATRICULA",nPadr2)+" | "+Padr("LOGIN",nPadr3)+" | "+Padr("NOME",nPadr7)+" | ";
		+Padr("CPF",nPadr4)+" | "+Padr("CARGO",nPadr7)+" | "+Padr("DEPARTAMENTO",nPadr7)
		aUsuarios := AllUsers(,.T.)
		li := 0
		Cabec(cTitulo,cCabec2,cCabec1,NomeProg,nTamanho,nTipo)
		Procregua(reccount())
		WHILE !FUNAT->(eof())
			cFil:=FUNAT->RA_FILIAL
			cMat:=ALLTRIM(FUNAT->RA_MAT)
			cNome:=FUNAT->RA_NOME
			cCpf:=FUNAT->RA_CIC
			cCargo:=FUNAT->RJ_DESC
			cDepart:=FUNAT->CTT_DESC01
			x:=0
			cMat1:=''
			IncProc("Processando: Filial: "+cFil+" |Mat: "+cMat)
			//PROCURA SE TEM USUÁRIO MICROSIGA
			
			For x:= 1 to len(aUsuarios)
				cString := alltrim(aUsuarios[x,1,22])
				if len(cString) > 6
					cMat1 := substr(cString,5,10)
				endif
				IF cMat == cMat1
					cLogn:= aUsuarios[x,1,2]
					x:=Len(aUsuarios)
				else
					cLogn:='VAZIO'
				ENDIF
			next
			LinhaPrint(Padr(cFil,nPadr) +" | "; //"Filial"
			+Padr(cMat,nPadr2)+" | "; //"Matricula"
			+Padr(cLogn,nPadr3)+" | "; //"Login"
			+Padr(cNome,nPadr7)+" | "; //"Nome Completo"
			+Padr(cCPF,nPadr4)+" | "; //CPF
			+Padr(cCargo,nPadr7)+" | ";	 //"Cargo"
			+Padr(cDepart,nPadr7)) //"Departamento"
			
			DBSKIP()
		enddo
	ENDIF
	//
	
endif


/*
ÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
|		FUNCIONARIOS DEMITIDOS          |
ÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁ
*/
if mv_par02 == 2 //SITUACAO DOS DEMITIDOS
	
	nPadr	:= 3
	nPadr2	:= 6
	nPadr3	:= 7
	nPadr4	:= 11
	nPadr5	:= 20
	nPadr6	:= 30
	nPadr7	:= 40
	
	IF SELECT('FUNAT')>0
		DBSELECTAREA('FUNAT')
		DBCLOSEAREA()
	ENDIF
	aUsuarios := AllUsers(,.T.)
	li := 0
	cQuery := "SELECT RA_FILIAL, RA_MAT, RA_NOME, RA_CIC, RA_DEMISSA, RJ_DESC,CTT_DESC01  "
	cQuery += "FROM "+RetSqlName('SRA')+ " SRA, "+RetSqlName('SRJ') + " SRJ," +RetSqlName('CTT') + " CTT  "
	cQuery += "WHERE RA_SITFOLH='D' AND RJ_FUNCAO=RA_CODFUNC "
	cQuery += "AND RA_FILIAL between '"+mv_par05+"' and '"+mv_par06+"' AND RA_CC=CTT_CUSTO "
	cQuery += "AND RA_DEMISSA >= '"+DTOS(mv_par03)+"' AND RA_DEMISSA <= '"+DTOS(mv_par04)+"' AND CTT.D_E_L_E_T_='' order by "+cOrder
	
	TCQUERY cQuery NEW ALIAS "FUNAT"
	DBSELECTAREA('FUNAT')
	FUNAT->(dbGoTop())
	
	IF mv_par01 == 2   //GERA ARQUIVO PARA EXCEL
		AADD(aCabExcel, {"FILIAL" ,"C", 02, 0})
		AADD(aCabExcel, {"MAT" ,"C", 06, 0})
		AADD(aCabExcel, {"LOGIN" ,"C", 07, 0})
		AADD(aCabExcel, {"NOME" ,"C", 70, 0})
		AADD(aCabExcel, {"CPF" ,"C", 11, 0})
		AADD(aCabExcel, {"CARGO" ,"C", 70, 0})
		AADD(aCabExcel, {"DEPART" ,"C", 70, 0})
		AADD(aCabExcel, {"DATA DEMISSÃO" ,"C", 10, 0})
		
	Else
		//GERA CABECALHO TEXTO
		cCabec2:=Padr("FIL",nPadr) +" | "+Padr("MATRICULA",nPadr2)+" | "+Padr("LOGIN",nPadr3)+" | "+Padr("NOME",nPadr7)+" | ";
		+Padr("CPF",nPadr4)+" | "+Padr("CARGO",nPadr7)+" | "+Padr("DEPARTAMENTO",nPadr7)+" | "+Padr("DEMISSAO",nPadr4)
		Cabec(cTitulo,cCabec2,cCabec1,NomeProg,nTamanho,nTipo)
	ENDIF
	
	WHILE !FUNAT->(eof())
		
		cFil:=FUNAT->RA_FILIAL
		cMat:=ALLTRIM(FUNAT->RA_MAT)
		cNome:=ALLTRIM(FUNAT->RA_NOME)
		cCpf:=FUNAT->RA_CIC
		cCargo:=FUNAT->RJ_DESC
		cDataD:=FUNAT->RA_DEMISSA
		cDepart:=FUNAT->CTT_DESC01
		
		IF Select("FUNAT2")>0
			DBSELECTAREA('FUNAT2')
			DBCLOSEAREA()
		Endif
		//VERIFICA QTD DE LINHAS CONTEM O FUNCIONARIO
		cQuery2 := "SELECT COUNT(*) as CONTA FROM "+RetSqlName('SRA') + " SRA WHERE RA_CIC='"+cCpf+"'"
		TCQUERY cQuery2 NEW ALIAS "FUNAT2"
		
		
		DBSELECTAREA('FUNAT2')
		FUNAT2->(dbGoTop())
		nCount:=FUNAT2->CONTA
		
		//imprime se encontra apenas uma linha
		IF nCount==1
			x:=0
			cMat1:=''
			//PROCURA SE TEM USUÁRIO MICROSIGA
			
			For x:= 1 to len(aUsuarios)
				cString := alltrim(aUsuarios[x,1,22])
				
				if len(cString) > 6
					cMat1 := substr(cString,5,10)
				endif
				
				IF cMat == cMat1
					cLogn:= aUsuarios[x,1,2]
					x:=Len(aUsuarios)
				else
					cLogn:='VAZIO'
				ENDIF
			next
			cDataD:=STOD(cDataD)
			
			IF mv_par01 == 2   //GERA ARQUIVO PARA EXCEL
				cFil:="'"+FUNAT->RA_FILIAL
				cMat:="'"+ALLTRIM(FUNAT->RA_MAT)
				cCpf:="'"+FUNAT->RA_CIC
				AADD(aItensExcel,{cFil,cMat,cLogn,cNome,cCPF,cCargo,cDepart,cDataD,})
			ELSE
				LinhaPrint(Padr(cFil,nPadr) +" | "; //"Filial"
				+Padr(cMat,nPadr2)+" | "; //"Matricula"
				+Padr(cLogn,nPadr3)+" | "; //"Login"
				+Padr(cNome,nPadr7)+" | "; //"Nome Completo"    //
				+Padr(cCPF,nPadr4)+" | "; //CPF
				+Padr(cCargo,nPadr7)+" | ";	 //"Cargo"
				+Padr(cDepart,nPadr7)+" | ";	 //"Departamento"
				+Padr(cDataD,nPadr4)) //"DATA DEMISSAO"
			ENDIF
			//procura se está ativo em caso de mais de uma linha de registro
		ENDIF
		
		IF nCount>1
			
			IF Select("FUNAT3")>0
				DBSELECTAREA("FUNAT3")
				DBCLOSEAREA()
			Endif
			
			cQuery2 := "SELECT COUNT(RA_NOME)AS CONTA FROM "+RetSqlName('SRA') + " SRA WHERE RA_CIC='"+cCpf+"' AND RA_SITFOLH!='D'"
			TCQUERY cQuery2 NEW ALIAS "FUNAT3"
			
			DBSELECTAREA('FUNAT3')
			FUNAT3->(dbGoTop())
			nCount:=FUNAT3->CONTA+0
			
			//SE NAO ESTÁ ATIVO ELE PROCURA A MAIOR DATA DE DEMISSAO E IMPRIME
			IF nCount==0
				IF Select("FUNAT3")>0
					FUNAT3->(dbCloseArea())
				Endif
				
				cQuery3 := "SELECT MAX(RA_DEMISSA) AS D FROM "+RetSqlName('SRA') + " SRA WHERE RA_CIC ='"+cCpf+"'
				TCQUERY cQuery3 NEW ALIAS "FUNAT3"
				cDataD:=FUNAT3->D
				
				IF Select("FUNAT4")>0
					DBSELECTAREA('FUNAT4')
					DBCLOSEAREA()
				Endif
				
				cQuery3 := "SELECT RA_FILIAL, RA_MAT, RA_NOME,RA_DTTRANS, RA_CIC, RA_SITFOLH, RA_DEMISSA ,RJ_DESC, CTT_DESC01 "
				cQuery3 += "FROM "+RetSqlName('SRA') + " SRA, "+RetSqlName('SRJ') + " SRJ, "+RetSqlName('CTT') + " CTT WHERE RA_DEMISSA='"+cDataD+"' "
				cQuery3 += "AND RA_CC=CTT_CUSTO AND RA_CIC = '"+cCpf+"' AND RA_SITFOLH='D' AND RJ_FUNCAO=RA_CODFUNC AND CTT.D_E_L_E_T_='' order by "+cOrder
				
				TCQUERY cQuery3 NEW ALIAS "FUNAT4"
				DBSELECTAREA('FUNAT4')
				FUNAT4->(dbGoTop())
				
				cFil:=FUNAT4->RA_FILIAL
				cMat:=FUNAT4->RA_MAT
				cNome:=FUNAT4->RA_NOME
				cCpf:=FUNAT4->RA_CIC
				cCargo:=FUNAT4->RJ_DESC
				cDepart:=FUNAT4->CTT_DESC01
				x:=0
				cMat1:=''
				//PROCURA SE TEM USUÁRIO MICROSIGA
				
				For x:= 1 to len(aUsuarios)
					cString := alltrim(aUsuarios[x,1,22])
					
					if len(cString) > 6
						cMat1 := substr(cString,5,10)
					endif
					
					IF cMat == cMat1
						cLogn:= aUsuarios[x,1,2]
						x:=Len(aUsuarios)
					else
						cLogn:='VAZIO'
					ENDIF
				next
				cDataD:=STOD(cDataD)
				IF mv_par01 == 2   //GERA ARQUIVO PARA EXCEL
					cFil:="'"+FUNAT4->RA_FILIAL
					cMat:="'"+FUNAT4->RA_MAT
					cCpf:="'"+FUNAT4->RA_CIC
					AADD(aItensExcel,{cFil,cMat,cLogn,cNome,cCPF,cCargo,cDepart,cDataD,})
				ELSE
					LinhaPrint(Padr(cFil,nPadr) +" | "; //"Filial"
					+Padr(cMat,nPadr2)+" | "; //"Matricula"
					+Padr(cLogn,nPadr3)+" | "; //"Login"
					+Padr(cNome,nPadr7)+" | "; //"Nome Completo"    //
					+Padr(cCPF,nPadr4)+" | "; //CPF
					+Padr(cCargo,nPadr7)+" | ";	 //"Cargo"
					+Padr(cDepart,nPadr7)+" | ";	 //"Departamento"
					+Padr(cDataD,nPadr4)) //"DATA DEMISSAO"
				ENDIF
			endif
		endif
		DBSELECTAREA('FUNAT')
		DBSKIP()
	enddo
	IF mv_par01 == 2   //GERA ARQUIVO PARA EXCEL
		MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",;
		{||DlgToExcel({{"GETDADOS", "RELATÓRIOS DOS FUNCIONÁRIOS DEMITIDOS DA CSU", aCabExcel,aItensExcel}})})
		
		return
	endif
ENDIF


/*
ÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
|   	FUNCIONÁRIOS TRANSFERIDOS       |
ÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁ
*/

if mv_par02 == 3 //SITUACAO DOS TRANSFERIDOS
	
	cLinha := "------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ "
	nPadr	:= 5
	nPadr2	:= 6
	nPadr3	:= 7
	nPadr4	:= 10
	nPadr5	:= 20
	nPadr6	:= 30
	nPadr7	:= 40
	nPadr8	:= 45
	aUsuarios := AllUsers(,.T.)
	li := 0
	
	IF SELECT('FUNAT')>0
		DBSELECTAREA('FUNAT')
		DBCLOSEAREA()
	ENDIF
	
	IF mv_par01 == 2   //GERA ARQUIVO PARA EXCEL
		AADD(aCabExcel, {"DE FILIAL" ,"C", 02, 0})
		AADD(aCabExcel, {"PARA FILIAL" ,"C", 02, 0})
		AADD(aCabExcel, {"DE MAT" ,"C", 06, 0})
		AADD(aCabExcel, {"PARA MAT" ,"C", 06, 0})
		AADD(aCabExcel, {"DE LOGIN" ,"C", 07, 0})
		AADD(aCabExcel, {"PARA LOGIN" ,"C", 07, 0})
		AADD(aCabExcel, {"NOME" ,"C", 70, 0})
		AADD(aCabExcel, {"CPF" ,"C", 11, 0})
		AADD(aCabExcel, {"DE CARGO" ,"C", 70, 0})
		AADD(aCabExcel, {"PARA CARGO" ,"C", 70, 0})
		AADD(aCabExcel, {"DE DEPART" ,"C", 70, 0})
		AADD(aCabExcel, {"PARA DEPART" ,"C", 70, 0})
		AADD(aCabExcel, {"DATA TRANSFERENCIA" ,"C", 10, 0})
	ELSE
		cCabec2:=Padr("D.FIL",nPadr) +" | "+Padr("P.FIL",nPadr) +" | "+Padr("DE MAT.",nPadr2)+" | "+Padr("P MAT.",nPadr2)	+" | ";
		+Padr("D LOGIN",nPadr3)+" | "+Padr("P LOGIN",nPadr3)+" | "+Padr("NOME",nPadr6)+" | ";
		+Padr("CPF",nPadr4)+" | "+Padr("DE CARGO",nPadr5)+" | "+Padr("PARA CARGO",nPadr5)+" | ";
		+Padr("DE DEPARTAMENTO",nPadr6)+" | "+Padr("PARA DEPARTAMENTO",nPadr6)+" | "+Padr("TRANSFER.",nPadr6)
		Cabec(cTitulo,cCabec2,cCabec1,NomeProg,nTamanho,nTipo)
	ENDIF
	//busca oS funcionarioS ativoS e transferidoS
	cQuery := "SELECT RA_FILIAL, RA_MAT, RA_CIC FROM "+RetSqlName('SRA') + " SRA WHERE RA_FILIAL between '"+mv_par05+"' and '"+mv_par06+"' "
	cQuery += "AND RA_SITFOLH!='D' AND RA_DTTRANS >= '"+DTOS(mv_par03)+"' AND RA_DTTRANS<='"+DTOS(mv_par04)+"'	order by "+cOrder
	
	TCQUERY cQuery NEW ALIAS "FUNAT"
	DBSELECTAREA('FUNAT')
	FUNAT->(dbGoTop())
	
	WHILE !FUNAT->(eof())
		cCic:=ALLTRIM(FUNAT->RA_CIC)
		cFilA:=ALLTRIM(FUNAT->RA_FILIAL)
		IF SELECT('FUNAT2')>0
			DBSELECTAREA('FUNAT2')
			DBCLOSEAREA()
		ENDIF
		
		//PROCURA AS TRANSFERENCIAS DO FUNCIONARIO
		cQuery2:="SELECT RA_DEMISSA,RE_FILIALD,RE_MATD,RE_FILIALP,RE_MATP,RA_FILIAL,RA_MAT,RA_NOME,RA_DTTRANS,RA_CIC, RJ_DESC, CTT_DESC01 "
		cQuery2+=" FROM SRE050,SRA050,SRJ050,CTT050 "
		cQuery2+=" WHERE RE_MATP=RA_MAT "
		cQuery2+=" AND RE_FILIALP=RA_FILIAL "
		cQuery2+=" AND RE_FILIALD!=RE_FILIALP "
		cQuery2+=" AND RA_CIC='"+cCic+"' "
		cQuery2+=" AND RA_CC=CTT_CUSTO "
		cQuery2+=" AND RJ_FUNCAO=RA_CODFUNC"
		cQuery2+=" AND CTT050.D_E_L_E_T_=''"
		cQuery2+=" ORDER BY SRE050.R_E_C_N_O_"
		
		TCQUERY cQuery2 NEW ALIAS "FUNAT2"
		DBSELECTAREA('FUNAT2')
		FUNAT2->(dbGoTop())
		
		WHILE !FUNAT2->(eof())
			cFild:=FUNAT2->RE_FILIALD
			cFilP:=FUNAT2->RE_FILIALP
			cMatD:=FUNAT2->RE_MATD
			cMatP:=FUNAT2->RE_MATP
			cNome:=FUNAT2->RA_NOME
			cCpf :=FUNAT2->RA_CIC
			cCargop:=FUNAT2->RJ_DESC
			cDepartp:=FUNAT2->CTT_DESC01
			DtTrans:=STOD(RA_DTTRANS)
			cLogP:=''
			cLogd:=''
			
			cQuery2:="SELECT RA_FILIAL, RA_MAT, RA_NOME, RA_CIC, RJ_DESC, CTT_DESC01 "
			cQuery2+=" FROM SRA050,SRJ050,CTT050 "
			cQuery2+=" WHERE RA_CIC ='"+cCpf+"' "
			cQuery2+=" AND RA_FILIAL='"+cFild+"' "
			cQuery2+=" AND RA_CC=CTT_CUSTO "
			cQuery2+=" AND RJ_FUNCAO=RA_CODFUNC "
			cQuery2+=" AND CTT050.D_E_L_E_T_='' "
			
			IF SELECT('FUNT')>0
				DBSELECTAREA('FUNT')
				DBCLOSEAREA()
			ENDIF
			
			TCQUERY cQuery2 NEW ALIAS "FUNT"
			DBSELECTAREA('FUNT')
			FUNT->(dbGoTop())
			
			cCargoD:=FUNT->RJ_DESC
			cDepartD:=FUNT->CTT_DESC01
			
			DBSELECTAREA('FUNAT2')
			x:=0
			cMatL:=ALLTRIM(cFilD)+ALLTRIM(cMatD)
			cMat1:=''
			//PROCURA SE TEM USUÁRIO MICROSIGA
			For x:= 1 to len(aUsuarios)
				cString := alltrim(aUsuarios[x,1,22])
				
				if len(cString) > 6
					cMat1 := substr(cString,3,8)
				endif
				
				IF cMatL == cMat1
					cLogD:= aUsuarios[x,1,2]
					x:=Len(aUsuarios)
				else
					cLogD:='VAZIO'
				ENDIF
			next
			X:=0
			cMat1:=''
			cMatL:=ALLTRIM(cFilP)+ALLTRIM(cMatP)
			//PROCURA SE TEM USUÁRIO MICROSIGA APOS TRANSFERENCIA
			For x:= 1 to len(aUsuarios)
				cString := alltrim(aUsuarios[x,1,22])
				
				if len(cString) > 6
					cMat1 := substr(cString,3,8)
				endif
				
				IF cMatL == cMat1
					cLogP:= aUsuarios[x,1,2]
					x:=Len(aUsuarios)
				else
					cLogP:='VAZIO'
				ENDIF
			next
			
			
			IF mv_par01 == 2   //GERA ARQUIVO PARA EXCEL
				AADD(aItensExcel,{"'"+cFilD,"'"+cFilP,"'"+cMatD,"'"+cMatP,cLogD,cLogP,cNome,"'"+cCPF,cCargoD,cCargoP,cDepartD,cDepartP,DtTrans,})
			ELSE
				LinhaPrint(Padr(cFilD,nPadr)+" | "; //"Filial"
				+Padr(cFilP,nPadr)+ " | "; //"Filial"
				+Padr(cMatD,nPadr2)+" | "; //"Matricula"
				+Padr(cMatP,nPadr2)+" | "; //"Matricula"
				+Padr(cLogD,nPadr3)+" | "; //"Login"
				+Padr(cLogP,nPadr3)+" | "; //"Login"
				+Padr(cNome,nPadr6)+" | "; //"Nome Completo"
				+Padr(cCPF,nPadr4)+ " | "; //CPF
				+Padr(cCargoD,nPadr5)+ " | ";	 //"Cargo"
				+Padr(cCargoP,nPadr5)+ " | ";	 //"Cargo"
				+Padr(cDepartD,nPadr6)+" | "; //"Departamento"
				+Padr(cDepartP,nPadr6)+" | "; //"Departamento"
				+Padr(DtTrans,nPadr4))	 //"DATA TRANSFERENCIA"
			ENDIF
			DBSKIP()
		ENDDO
		DBSELECTAREA('FUNAT')
		DBSKIP()
	ENDDO
	IF mv_par01 == 2   //GERA ARQUIVO PARA EXCEL
		MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",;
		{||DlgToExcel({{"GETDADOS", "RELATÓRIOS DOS FUNCIONARIOS TRANSFERIDOS DA CSU", aCabExcel,aItensExcel}})})
		return
	endif
endif

/*
ÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
|		FERIAS DOS FUNCIONARIOS         |
ÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁ
*/

if mv_par02 == 4 //SITUACAO DE FERIAS
	
	nPadr	:= 3
	nPadr2	:= 6
	nPadr3	:= 7
	nPadr4	:= 11
	nPadr5	:= 20
	nPadr6	:= 30
	nPadr7	:= 40
	
	IF SELECT('FUNAT')>0
		DBSELECTAREA('FUNAT')
		DBCLOSEAREA()
	ENDIF
	aUsuarios := AllUsers(,.T.)
	li := 0
	
	IF mv_par01 == 2   //GERA ARQUIVO PARA EXCEL
		AADD(aCabExcel, {"FILIAL" ,"C", 02, 0})
		AADD(aCabExcel, {"MAT" ,"C", 06, 0})
		AADD(aCabExcel, {"LOGIN" ,"C", 07, 0})
		AADD(aCabExcel, {"NOME" ,"C", 70, 0})
		AADD(aCabExcel, {"CPF" ,"C", 11, 0})
		AADD(aCabExcel, {"CARGO" ,"C", 70, 0})
		AADD(aCabExcel, {"DEPART" ,"C", 70, 0})
		AADD(aCabExcel, {"INICIO FERIAS" ,"C", 70, 0})
		AADD(aCabExcel, {"FIM FERIAS" ,"C", 70, 0})
	ELSE
		//GERA CABECALHO TEXTO
		cCabec2:=Padr("FIL",nPadr) +" | "+Padr("MATRICULA",nPadr2)+" | "+Padr("LOGIN",nPadr3)+" | "+Padr("NOME",nPadr7)+" | ";
		+Padr("CPF",nPadr4)+" | "+Padr("CARGO",nPadr7)+" | "+Padr("DEPARTAMENTO",nPadr7)+" | "+Padr("INI.FERIAS",nPadr4)+" | "+Padr("FIM.FERIAS",nPadr4)
		Cabec(cTitulo,cCabec2,cCabec1,NomeProg,nTamanho,nTipo)
		
	ENDIF
	
	cQuery:="SELECT DISTINCT RA_FILIAL, RA_MAT, RA_NOME, RA_CIC, RJ_DESC, RH_DATAINI, RH_DATAFIM,CTT_DESC01 "
	cQuery+="FROM "+RetSqlName('SRA') + " SRA, "+RetSqlName('SRJ') + " SRJ, "+RetSqlName('SRH') + " SRH, "+RetSqlName('CTT') + " CTT "
	cQuery+="WHERE RJ_FUNCAO=RA_CODFUNC "
	cQuery+="AND RA_FILIAL=RH_FILIAL "
	cQuery+="AND RA_FILIAL between '"+mv_par05+"' and '"+mv_par06+"' AND RA_CC=CTT_CUSTO "
	cQuery+="AND RH_DATAINI >= '"+DTOS(mv_par03)+"' AND RH_DATAINI<='"+DTOS(mv_par04)+"'  "
	cQuery+="AND RA_MAT=RH_MAT AND CTT.D_E_L_E_T_='' order by "+cOrder
	
	TCQUERY cQuery NEW ALIAS "FUNAT"
	
	DBSELECTAREA('FUNAT')
	FUNAT->(dbGoTop())
	
	WHILE !FUNAT->(eof())
		cFil:=FUNAT->RA_FILIAL
		cMat:=FUNAT->RA_MAT
		cNome:=FUNAT->RA_NOME
		cCpf:=FUNAT->RA_CIC
		cCargo:=FUNAT->RJ_DESC
		cDataI:=FUNAT->RH_DATAINI
		cDataF:=FUNAT->RH_DATAFIM
		cDepart:=FUNAT->CTT_DESC01
		x:=0
		cMat1:=''
		//PROCURA SE TEM USUÁRIO MICROSIGA
		
		For x:= 1 to len(aUsuarios)
			cString := alltrim(aUsuarios[x,1,22])
			
			if len(cString) > 6
				cMat1 := substr(cString,5,10)
			endif
			
			IF cMat == cMat1
				cLogn:= aUsuarios[x,1,2]
				x:=Len(aUsuarios)
			else
				cLogn:='VAZIO'
			ENDIF
		next
		cDataI:=STOD(cDataI)
		cDataF:=STOD(cDataF)
		IF mv_par01 == 2   //GERA ARQUIVO PARA EXCEL
			cFil:="'"+FUNAT->RA_FILIAL
			cMat:="'"+FUNAT->RA_MAT
			cCpf:="'"+FUNAT->RA_CIC
			AADD(aItensExcel,{cFil,cMat,cLogn,cNome,cCPF,cCargo,cDepart,cDataI,cDataF,})
		ELSE
			LinhaPrint(Padr(cFil,nPadr) +" | "; //"Filial"
			+Padr(cMat,nPadr2)+" | "; //"Matricula"
			+Padr(cLogn,nPadr3)+" | "; //"Login"
			+Padr(cNome,nPadr7)+" | "; //"Nome Completo"
			+Padr(cCPF,nPadr4)+" | "; //CPF
			+Padr(cCargo,nPadr7)+" | ";	 //"Cargo"
			+Padr(cDepart,nPadr7)+" | "; //"Departamento"
			+Padr(cDataI,nPadr4)+" | ";	 //"DATA FERIAS"
			+Padr(cDataF,nPadr4)) //"DATA FERIAS"
		ENDIF
		DBSKIP()
	ENDDO
	IF mv_par01 == 2   //GERA ARQUIVO PARA EXCEL
		MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",;
		{||DlgToExcel({{"GETDADOS", "RELATÓRIOS DE FÉRIAS DOS FUNCIONÁRIOS DA CSU", aCabExcel,aItensExcel}})})
		return
	endif
ENDIF

/*
ÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
|		FUNCIONARIOS AFASTADOS         |
ÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁ
*/

if mv_par02 == 5 //SITUACAO DOS AFASTADOS
	nPadr	:= 3
	nPadr2	:= 6
	nPadr3	:= 7
	nPadr4	:= 11
	nPadr5	:= 20
	nPadr6	:= 30
	nPadr7	:= 40
	
	IF SELECT('FUNAT')>0
		DBSELECTAREA('FUNAT')
		DBCLOSEAREA()
	ENDIF
	aUsuarios := AllUsers(,.T.)
	li := 0
	
	IF mv_par01 == 2   //GERA ARQUIVO PARA EXCEL
		AADD(aCabExcel, {"FILIAL" ,"C", 02, 0})
		AADD(aCabExcel, {"MAT" ,"C", 06, 0})
		AADD(aCabExcel, {"LOGIN" ,"C", 07, 0})
		AADD(aCabExcel, {"NOME" ,"C", 70, 0})
		AADD(aCabExcel, {"CPF" ,"C", 11, 0})
		AADD(aCabExcel, {"CARGO" ,"C", 70, 0})
		AADD(aCabExcel, {"DEPART" ,"C", 70, 0})
		AADD(aCabExcel, {"DATA AFAST." ,"C", 70, 0})
		AADD(aCabExcel, {"DATA FIM AFAST." ,"C", 70, 0})
	ELSE
		//GERA CABECALHO TEXTO
		cCabec2:=Padr("FIL",nPadr) +" | "+Padr("MATRICULA",nPadr2)+" | "+Padr("LOGIN",nPadr3)+" | "+Padr("NOME",nPadr7)+" | ";
		+Padr("CPF",nPadr4)+" | "+Padr("CARGO",nPadr7)+" | "+Padr("DEPARTAMENTO",nPadr7)+" | "+Padr("INIC. AFAST",nPadr5)+" | "+Padr("FIM AFAST",nPadr5)
		Cabec(cTitulo,cCabec2,cCabec1,NomeProg,nTamanho,nTipo)
	ENDIF
	
	cQuery:="SELECT DISTINCT RA_FILIAL, RA_MAT, RA_NOME, RA_CIC, RJ_DESC, R8_DATAINI,R8_DATAFIM, CTT_DESC01 "
	cQuery+="FROM "+RetSqlName('SRA') + " SRA, "+RetSqlName('SRJ') + " SRJ, "+RetSqlName('CTT') + " CTT, "+RetSqlName('SR8') + " SR8 "
	cQuery+="WHERE R8_TIPO in ('P','O','Q','6','7') AND RJ_FUNCAO=RA_CODFUNC AND RA_FILIAL=R8_FILIAL AND RA_MAT=R8_MAT "
	cQuery+="AND RA_FILIAL between '"+mv_par05+"' and '"+mv_par06+"' AND RA_CC=CTT_CUSTO "
	cQuery+="AND R8_DATAINI >= '"+DTOS(mv_par03)+"' AND R8_DATAINI<='"+DTOS(mv_par04)+"'  "
	cQuery+="AND CTT.D_E_L_E_T_='' order by "+cOrder
	
	TCQUERY cQuery NEW ALIAS "FUNAT"
	
	DBSELECTAREA('FUNAT')
	FUNAT->(dbGoTop())
	
	WHILE !FUNAT->(eof())
		cFil:=FUNAT->RA_FILIAL
		cMat:=FUNAT->RA_MAT
		cNome:=FUNAT->RA_NOME
		cCpf:=FUNAT->RA_CIC
		cCargo:=FUNAT->RJ_DESC
		cDataA:=STOD(FUNAT->R8_DATAINI)
		cDataB:=STOD(FUNAT->R8_DATAFIM)
		cDepart:=FUNAT->CTT_DESC01
		x:=0
		cMat1:=''
		//PROCURA SE TEM USUÁRIO MICROSIGA
		
		For x:= 1 to len(aUsuarios)
			cString := alltrim(aUsuarios[x,1,22])
			
			if len(cString) > 6
				cMat1 := substr(cString,5,10)
			endif
			
			IF cMat == cMat1
				cLogn:= aUsuarios[x,1,2]
				x:=Len(aUsuarios)
			else
				cLogn:='VAZIO'
			ENDIF
		next
		
		IF mv_par01 == 2   //GERA ARQUIVO PARA EXCEL
			cFil:="'"+FUNAT->RA_FILIAL
			cMat:="'"+FUNAT->RA_MAT
			cCpf:="'"+FUNAT->RA_CIC
			AADD(aItensExcel,{cFil,cMat,cLogn,cNome,cCPF,cCargo,cDepart,cDataA,cDataB,})
		ELSE
			LinhaPrint(Padr(cFil,nPadr) +" | "; //"Filial"
			+Padr(cMat,nPadr2)+" | "; //"Matricula"
			+Padr(cLogn,nPadr3)+" | "; //"Login"
			+Padr(cNome,nPadr7)+" | "; //"Nome Completo"
			+Padr(cCPF,nPadr4)+" | "; //CPF
			+Padr(cCargo,nPadr7)+" | ";	 //"Cargo"
			+Padr(cDepart,nPadr7)+" | "; //"Departamento"
			+Padr(cDataA,nPadr5)+" | ";
			+Padr(cDataB,nPadr5))	 //"DATA Afastamento"
		ENDIF
		DBSKIP()
	ENDDO
	IF mv_par01 == 2   //GERA ARQUIVO PARA EXCEL
		MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",;
		{||DlgToExcel({{"GETDADOS", "RELATÓRIOS DOS FUNCIONÁRIOS AFASTADOS DA CSU", aCabExcel,aItensExcel}})})
		return
	endif
ENDIF


If aReturn[5]== 1
	SET Print TO
	Commit
	ourspool(wnrel)
EndIf
MS_FLUSH()

Return nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³LinhaPrint³ Autor ³ TOTVS                 ³ Data ³ Jan/2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ FUNCAO PARA IMPRESSAO DA LINHA NO REL                      ³±±
±±³		     ³	                                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CSU                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function LinhaPrint(cvar1,cvar2)
If li > 70
	li :=0
	li := Cabec(cTitulo,cCabec2,cCabec1,NomeProg,nTamanho,nTipo)
EndIf
If !Empty(cVar1)
	@ li,0  Psay cVar1
EndIf
If !Empty(cVar2)
	@ li,40 Psay cVar2
EndIf
Li := li + 1
Return NIL

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ValidPerg ³ Autor ³ Fernando Barreto      ³ Data ³ Jan/2012 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Função para criação do SX1 da rotina                       ³±±
±±³		     ³	                                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CSU                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ValidPerg(Pg)

_sAlias := Alias()

dbSelectArea("SX1")
dbSetOrder(1)
_cPerg := PADR(Pg,LEN(SX1->X1_GRUPO))
aRegs:={}

aAdd(aRegs,{_cPerg,"01","Tipo de Impressão      	  ?","","","mv_ch1","N",01,0,0,"C","","mv_par01","Texto","","","","","Excel","","","","","","","","","","","","","","","","","","","","","","          "})
aAdd(aRegs,{_cPerg,"02","Sit. Folha            	  	  ?","","","mv_ch2","N",01,0,0,"C","","mv_par02","Ativos","","","","","Demitidos","","","","","Transferidos","","","","","Ferias","","","","","Afastados","","","","","","","          "})
aAdd(aRegs,{_cPerg,"03","Data de           	     	  ?","","","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","          "})
aAdd(aRegs,{_cPerg,"04","Data ate          	     	  ?","","","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","          "})
aAdd(aRegs,{_cPerg,"05","Filial de           		  ?","","","mv_ch5","C",02,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SM0","","","          "})
aAdd(aRegs,{_cPerg,"06","Filial ate           		  ?","","","mv_ch6","C",02,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SM0","","","          "})
aAdd(aRegs,{_cPerg,"07","Ordem                   	  ?","","","mv_ch7","N",01,0,0,"C","","mv_par07","Filial","","","","","Nome","","","","","","","","","","","","","","","","","","","","","","          "})

For i:=1 to Len(aRegs)
	If !dbSeek(_cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])//SALVA O CONTEUDO DO ARRAY NO BANCO
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Pergunte(Pg,.F.)

Return


