#INCLUDE "rwmake.ch"
#INCLUDE "common.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPETIQ_1.01ºAutor  ³Adriana/Adriano     º Data ³  19/11/03   º±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºDesc.     ³Impressão de etiquetas para o cartão de ponto de bh           º±±
±±º          ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³CSU CARDSYSTEM S/A                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function IMPETIQ1()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*******PARAMETROS ***********
Filial  de      ?mv_par01
Filial ate      ?mv_par02
Matricula de    ?mv_par03
Matricula ate   ?mv_par04
C.Custo de      ?mv_par05
C.Custo ate     ?mv_par06
Situacao        ?mv_par07
Categoria       ?mv_par08
Periodo de      ?mv_par09
Periodo ate     ?mv_par10
******************************/

Private cPerg  := PADR("IMPETI",LEN(SX1->X1_GRUPO))
Private Courier, cCode
Private Pag:=.F.         
Private controlPg:=1
Private lin:=50
Private _clinha:=50
Private Col:=50
Private ncont:=1
Private Codigo,_cQuery:=""
Private acampos:={}
Private ColEtiq:=1
Private ajustepg:=1
Private _cdescfun,_turno,_dtde,_dtate,_mat,	_nome:=""     
Private CGC:=0
Private Empresa:=""

cLin:={0,0,0,0,0,0,0}

nHeight:=15
lBold:= .F.
lUnderLine:= .F.
lPixel:= .T.
lPrint:=.F.

Private Courier   := TFont():New( "Courier New",,nHeight,,lBold,,,,,lUnderLine )
Private Courier08F:= TFont():New( "Courier New",,10,,.f.,,,,,.f. )
Private Courier08T:= TFont():New( "Courier New",,10,,.t.,,,,,.f. )
Private Courier10F:= TFont():New( "Courier New",,12,,.f.,,,,,.f. )
Private Courier10T:= TFont():New( "Courier New",,12,,.t.,,,,,.f. )
Private Courier12T:= TFont():New( "Courier New",,12,,.t.,,,,,.f. )
Private Courier12F:= TFont():New( "Courier New",,12,,.f.,,,,,.f. )
Private Courier14 := TFont():New( "Courier New",,14,,.t.,,,,,.f. )
Private Courier28 := TFont():New( "Courier New",,28,,.t.,,,,,.f. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

validperg()

If !Pergunte(cPerg,.T.)
	
	Return
	
Endif

RptStatus({|| RunReport()})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Return

Static Function RunReport()

_cQuery := " SELECT * FROM "+RETSQLNAME('SRA')+" "
_cQuery += " WHERE RA_FILIAL  BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' AND "
_cQuery += " RA_MAT     BETWEEN '" + MV_PAR03 +"' AND '"+ MV_PAR04 +"' AND "
_cQuery += " RA_CC      BETWEEN '" + MV_PAR05 +"' AND '"+ MV_PAR06 +"' AND "
_cQuery += " RA_SITFOLH LIKE '["+MV_PAR07+"]'AND RA_CATFUNC LIKE '["+MV_PAR08+"]' AND "
_cQuery += " D_E_L_E_T_ <> '*' "
_cQuery += " Order by RA_FILIAL,RA_MAT"

If Select("TRDEXC") >0
	DBSelectArea("TRDEXC")
	DBCloseArea()
EndIf

TCQUERY _cQuery NEW ALIAS "TRDEXC"

DBSelectArea("TRDEXC")
DBGotop()

SetRegua(RecCount())

// ORDEM (01) => FILIAL + MAT
oPrn := TMSPrinter():New()

WHILE !EOF()
	Afill(cLin,"")
	cLinha1 := ""
	nCont   := 1
	IncRegua("Gerando os registros...")
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	_cdescfun:=DescFun(TRDEXC->RA_CODFUNC,TRDEXC->RA_FILIAL)
	_turno	 :=turno(TRDEXC->RA_TNOTRAB)
	_dtde	 :=dtoc(MV_PAR09)
	_dtate	 :=dtoc(MV_PAR10)
	_mat	 :=TRDEXC->RA_MAT
	_nome	 :=TRDEXC->RA_NOME       
	CGC		 :=LocCGC()   
	Empresa  :=LocNome()
	
	//		aadd(acampos,{_mat,_nome,_cdescfun,_turno,_dtde,_dtate})
	
	cLin[nCont] := cLin[nCont] +Empresa
	ncont:=ncont+1
	cLin[nCont] := cLin[nCont] +Transform(CGC,"@R ##.###.###/####-##") 
	ncont:=ncont+1
	cLin[nCont] := cLin[nCont] +_nome
	ncont:=ncont+1
	cLin[nCont] := cLin[nCont] +"Mat.: "+_mat
	ncont:=ncont+1
	cLin[nCont] := cLin[nCont] +_cdescfun
	ncont:=ncont+1
	cLin[nCont] := cLin[nCont] +_turno
	ncont:=ncont+1
	cLin[nCont] := cLin[nCont] +_dtde +" A "+_dtate
	ncont:=ncont+1
	AADD(ACAMPOS,CLIN)
	DBSelectArea("TRDEXC")
	dbSkip()
	
	If cLin[1] # NIL
		
		If ColEtiq==3
			col:=1700
			lin:=_clinha   

		ElseIF ColEtiq==1
			lin:=_clinha
			col:=50
		    
		ElseIF ColEtiq==2
			lin:=_clinha
			col:=900
		
		ElseIF ColEtiq>3
			//	lin:=_clinha
			col:=50
			ColEtiq:=1      
			_clinha:=lin
			ajustepg:=ajustepg+1   		

			if ajustepg == 3
				lin:=lin+50
				ajustepg:=1   
				_clinha:=lin
			endif
	
		Endif
		
		For X := 1 To 7
			
			oPrn:Say(lin,col, cLin[X],Courier08F,100 )
			
			lin:=lin+30
	
		Next X
		
	Endif
	ColEtiq:=ColEtiq+1	//conta a quantidade de colunas impressas
	lin:=lin+150     //salta para proxima linha de etiqueta    
	
			if lin>3670  .AND. ColEtiq>3
		        lin:=50   
			   	_clinha:=50
				oPrn:EndPage()
				oPrn:StartPage() 
				PAG:=.F.
			Endif
	
Enddo
oPrn:EndPage()	

oPrn:Preview()
MS_FLUSH()
DBCloseArea("TRDEXC")

Return

Static Function LocCGC()
CGC:=0
dbselectarea("SM0")
dbsetorder(1)

CGC:=SM0->M0_CGC
	
Return(CGC)     

Static Function LocNome()
NomEmpresa:=""
dbselectarea("SM0")
dbsetorder(1)

NomEmpresa:=SM0->M0_NOMECOM
	
Return(NomEmpresa)


If dbseek (xFilial("SR6")+codigo)
	descricao:= SR6->R6_DESC
Endif

Return (descricao)


Static Function Turno(Codigo)

dbselectarea("SR6")
dbsetorder(1)
descricao:=""

If dbseek (xFilial("SR6")+codigo)
	descricao:= SR6->R6_DESC
Endif

Return (descricao)


//perguntas do relatório
Static Function ValidPerg()

_sAlias := Alias()

dbSelectArea("SX1") // abre arquivo sx1 de perguntas
dbSetOrder(1)       // coloca na ordem 1 do sindex
cPerg := PADR(cPerg,LEN(SX1->X1_GRUPO))
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cPerg,"01"," Filial  de      ?","","","mv_ch1","C",02,0,0,"G","","mv_par01","         ","","","","","","","","","","","","","","","","","","","","","","XM0","","",""})
AADD(aRegs,{cPerg,"02"," Filial ate      ?","","","mv_ch2","C",02,0,0,"G","","mv_par02","NaoVazio  ","","","","","","","","","","","","","","","","","","","","","","XM0","","",""})
AADD(aRegs,{cPerg,"03"," Matricula de    ?","","","mv_ch3","C",06,0,0,"G","","mv_par03","          ","","","","","","","","","","","","","","","","","","","","","","SRA","","",""})
AADD(aRegs,{cPerg,"04"," Matricula ate   ?","","","mv_ch4","C",06,0,0,"G","","mv_par04","NaoVazio  ","","","","","","","","","","","","","","","","","","","","","","SRA","","",""})
AADD(aRegs,{cPerg,"04"," C.Custo de      ?","","","mv_ch5","C",20,0,0,"G","","mv_par05","          ","","","","","","","","","","","","","","","","","","","","","","CTT","004","",""})
AADD(aRegs,{cPerg,"04"," C.Custo ate     ?","","","mv_ch6","C",20,0,0,"G","","mv_par06","NaoVazio  ","","","","","","","","","","","","","","","","","","","","","","CTT","004","",""})
AADD(aRegs,{cPerg,"05"," Situacao        ?","","","mv_ch7","C",05,0,0,"G","","mv_par07","fSituacao ","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06"," Categoria       ?","","","mv_ch8","C",15,0,0,"G","","mv_par08","fCategoria","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06"," Periodo de      ?","","","mv_ch9","D",08,0,0,"G","","mv_par09","NaoVazio   ","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06"," Periodo ate     ?","","","mv_chA","D",08,0,0,"G","","mv_par10","NaoVazio   ","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return


