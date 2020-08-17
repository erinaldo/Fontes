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
User Function CSVALETR()
Local cbcont   := 0
Local cabec1   := ""//OemToAnsi(STR0007) //"RELACAO DO CADASTRO DE USUÁRIOS"
Local cabec2   := ""
Local cabec3   := ""
Local nPos
Local wnrel:= "VALE TRANSPORTE"
Local CbTxt
Local cString  := ""
Local tamanho    := "M"
Local limite     := 132
Local titulo     := "Relação do VT "
Local cDesc1     := "Relação do VT "
Local cDesc2     := "Ira imprimir o VT dos funcionários "
Local cDesc3     := "de acordo com a situação."
Local Pg		 := "CSVALETR"
Private cGrpAnt    := ""
Private cUsrAnt    := ""
Private aReturn  := { OemToAnsi(STR0005), 1,OemToAnsi(STR0006), 2, 2, 1, "",1 } //"Zebrado"###"Administração"
Private aLinha   := { }
Private nomeprog := "CSVALETR"
Private AParDef  := {}
Private nLastKey
Private cString  := ""
PRIVATE M_PAG:=1
Private nTipo

wnrel := SetPrint(cString,wnrel,Pg,@Titulo,cDesc1,cDesc2,cDesc3,.T.,{},,tamanho,,.T.)
If nLastKey = 27
	Return
EndIf
SetDefault(aReturn,cString)
If nLastKey = 27
	Return
EndIf
nTipo := IF(aReturn[4] == 1, 15, 18)
RptStatus({|lEnd| CSVALE(@lEnd,Cabec1,Cabec2,Cabec3,limite,tamanho,cbCont,wnrel)},Titulo)
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
Static Function CSVALE(lEnd,Cabec1,Cabec2,Cabec3,limite,tamanho,cbCont,wnrel)
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
Private nPadr	:= 6
Private nPadr2	:= 12
Private nPadr3	:= 12
Private nPadr4	:= 12
Private nPadr5	:= 20
Private nPadr6	:= 25
Private nPadr7	:= 50  
PRIVATE cFilat:=''
PRIVATE cMatat:=''

If aModulos == Nil
	aModulos := RetModName()
	Aadd(aModulos,{99,"SIGAGPE",STR0076,.F.})
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


IF Select("FUNAT")>0
	FUNAT->(dbCloseArea())
Endif
cQuery := "SELECT distinct RA_FILIAL,RA_MAT,RA_NOME,RA_SITFOLH,R0_MEIO,RN_DESC,SR0.D_E_L_E_T_ AS DEL FROM "+RetSqlName('SRA') + " SRA "
cQuery += " LEFT JOIN "+RetSqlName('SR0') + " SR0 ON RA_FILIAL=R0_FILIAL AND RA_MAT=R0_MAT "
cQuery += " LEFT JOIN "+RetSqlName('SRN') + " SRN ON R0_MEIO=RN_COD WHERE RA_FILIAL IN ('02','03') "
cQuery += " AND RA_SITFOLH!='D' and SRA.D_E_L_E_T_='' ORDER BY RA_FILIAL,RA_MAT"


TCQUERY cQuery NEW ALIAS "FUNAT"
FUNAT->(dbGoTop())

cCabec2:=Padr("FIL",nPadr) +" | "+Padr("MAT",nPadr2) +" | "+Padr("NOME",nPadr7)+" | ";
+Padr("SIT",nPadr)+" | "+Padr("MEIO",nPadr)+" | "+Padr("DESCRICAO",nPadr7)
li := 0
Cabec(cTitulo,cCabec2,cCabec1,NomeProg,nTamanho,nTipo)
Procregua(reccount())
WHILE !FUNAT->(eof())  
	
		cFil:=FUNAT->RA_FILIAL
		cMat:=ALLTRIM(FUNAT->RA_MAT)
		cNome:=FUNAT->RA_NOME
		cSIT:=FUNAT->RA_SITFOLH   
		cMEIO:=FUNAT->R0_MEIO   
		cDESC:=FUNAT->RN_DESC   
		
	if (cFilat==cFil) .AND. (cMatat==cMat)
		cFilat:=cFil
   		cMatat:=cMat
	else		
		IF FUNAT->DEL=='*'
			cMEIO:='NULL'
			cDESC:='NULL'
		ENDIF
		IncProc("Processando: Filial: "+cFil+" |Mat: "+cMat)
	
		LinhaPrint(Padr(cFil,nPadr) +" | "; //"Filial"
		+Padr(cMat,nPadr2)+" | "; //"Matricula"
		+Padr(cNome,nPadr7)+" | "; //"Login"
		+Padr(cSIT,nPadr)+" | "; //"Nome Completo"
		+Padr(cMEIO,nPadr)+" | "; //CPF
		+Padr(cDESC,nPadr7))	 //"Cargo"   
		cFilat:=cFil
   		cMatat:=cMat
	ENDIF
	
	DBSKIP()
enddo

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
If li > 75
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



