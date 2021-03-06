#include "protheus.ch"
#include "apcfg40.ch"
#include "TOPCONN.CH"

Static aAcessos
Static aModulos
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �CSULIQFER � Autor � FERNANDO BARRETO      � Data � FEV/2012 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � RELATORIO DE FUNCIONARIOS DEMITIDOS						  ���
���			 � com o objetivo de atender o chamado 0259/12				  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CSU                                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CSUFUNDEM()                                  

Local wnrel:= "CSUFUNDEM"
Local cString  := ""
Local tamanho    := "G"
Local limite     := 132
Local titulo     := "RELATORIO DOS FUNCIONARIOS DEMITIDOS"
Local cDesc1     := "RELATORIO DOS FUNCIONARIOS DEMITIDOS"
Local cDesc2     := "Ira imprimir os funcion�rios demitidos"
Local cDesc3     := "de um periodo determinado."
Local Pg		 := "CSUFDEMI"
Private aReturn  := { OemToAnsi(STR0005), 1,OemToAnsi(STR0006), 2, 2, 1, "",1 } //"Zebrado"###"Administra��o"
Private nomeprog := "DEMITIDOS"
Private nLastKey
Private cString  := ""
PRIVATE M_PAG:=1

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
Processa( {|lEnd| CSUFD(@lEnd)}, "Aguarde...","Processando...", .T. )
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � CSUFUNDEM| Autor � FERNANDO BARRETO      � Data � FEV/2012 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Fun��o de processamento do relatorio                       ���
���		     �	                                                          ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CSU                                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function CSUFD(lEnd)
Local nCnt := 0
Local nLogTam := 0  
Local wnrel:= "CSUFUNDEM"
Local cMat:='' //"Matricula"
Local cNome:=''
Local TMP := "TMP"
Local cTMP:=" "
Local titulo     := "RELATORIO DOS FUNCIONARIOS DEMITIDOS"
Private cCabec1  := ''
Private cCabec2  := ''
Private cCabec3  := ""
Private nTamanho := "G"
Private ctitulo     := "RELATORIO DOS FUNCIONARIOS DEMITIDOS"
Private li            
Private nPadr	:= 6
Private nPadr2	:= 9
Private nPadr3	:= 45
Private nPadr4	:= 11
Private nPadr5	:= 8
Private nPadr6	:= 35

/*
����������������������������������������������������Ŀ
|	RELATORIO DOS FUNCIONARIOS DEMITIDOS             |
������������������������������������������������������
*/
	//CRIA CABECALHO
	cCabec2:=Padr("FILIAL",nPadr) +" | "+Padr("MATRICULA",nPadr2)+" | "+Padr("NOME",nPadr3)+" | "	+Padr("CPF",nPadr4)+" | ";
	+Padr("RG",nPadr5)+" | "+Padr("C. CUSTO",nPadr6)+" | "+Padr("DT ADMISS�O",nPadr4)+" | "+Padr("DT DEMISS�O",nPadr4)+" | ";
	+Padr("MOTIVO",nPadr3)+" | "			
	li := 0
	Cabec(cTitulo,cCabec2,cCabec1,NomeProg,nTamanho,nTipo)
		
	IF Select("CONS")>0
		CONS->(dbCloseArea())
	Endif 

	
	cCONS :="SELECT RA_FILIAL, RA_MAT, RA_NOME, RA_DEMISSA, RA_ADMISSA, CTT_DESC01, RA_RG, RA_CIC, RA_RESCRAI "
	cCONS +="FROM "+ RetSqlName('SRA') + " SRA, "+ RetSqlName('SRG') + " SRG, "+ RetSqlName('CTT') + " CTT "
	cCONS +="WHERE RA_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
	cCONS +="AND RA_DEMISSA BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' "
	cCONS +="AND RA_SITFOLH='D' "
	cCONS +="AND RA_CC=CTT_CUSTO "
	cCONS +="AND RA_MAT=RG_MAT "
	cCONS +="AND RA_FILIAL=RG_FILIAL "
	cCONS +="AND SRA.D_E_L_E_T_='' "
	cCONS +="AND SRG.D_E_L_E_T_='' "
	cCONS +="AND CTT.D_E_L_E_T_='' "
	cCONS +="ORDER BY RA_FILIAL,RA_NOME"
	
	nCnt:= U_MontaView(cCons,"CONS")
	DBSELECTAREA("CONS")    
	CONS->(dbGoTop())  
	ProcRegua(nCnt)          
	
	WHILE !CONS->(eof()) 
  		IncProc("Processando Filial+Matricula: "+CONS->RA_FILIAL+"-"+CONS->RA_MAT)
		cFil:= CONS->RA_FILIAL
		cMat:= CONS->RA_MAT
		cNome:= CONS->RA_NOME			
		cDemiss:=STOD(CONS->RA_DEMISSA)
		cAdmiss:=STOD(CONS->RA_ADMISSA)
		cCC:=CONS->CTT_DESC01		
		cRG:=CONS->RA_RG
		cCPF:=CONS->RA_CIC
		cCodDem:=CONS->RA_RESCRAI
		
		DBSELECTAREA("SX5")
		DBSETORDER(1)
		DBSEEK(XFILIAL("SX5")+'27'+cCodDem)
		cMotivo:=SX5->X5_DESCRI
			
		LinhaPrint(Padr(cFil,nPadr) +" | "; //"Filial"
				  +Padr(cMat,nPadr2)+" | "; //"Matricula"
				  +Padr(cNome,nPadr3)+" | "; //"Nome"				  
			   	  +Padr(cCPF,nPadr4)+" | "; //CPG
				  +Padr(cRG,nPadr5)+" | ";	 //RG    
				  +Padr(cCC,nPadr6)+" | "; //"CC"
				  +Padr(cAdmiss,nPadr4)+" | ";	 //DT ADMISSAO
				  +Padr(cDemiss,nPadr4)+" | ";	 //DT DEMISSAO
				  +Padr(cMotivo,nPadr3)+" | ")	 //MOTIVO												
		DBSELECTAREA("CONS")		  
		DBSKIP()
	ENDDO
	

If aReturn[5]== 1
	SET Print TO
	Commit
	ourspool(wnrel)
EndIf
MS_FLUSH()

Return nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �LinhaPrint� Autor � TOTVS                 � Data � FEV/2012 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � FUNCAO PARA IMPRESSAO DA LINHA NO REL                      ���
���		     �	                                                          ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CSU                                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �ValidPerg � Autor � Fernando Barreto      � Data � FEV/2012 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Fun��o para cria��o do SX1 da rotina                       ���
���		     �	                                                          ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � CSU                                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ValidPerg(Pg)

_sAlias := Alias()

dbSelectArea("SX1")
dbSetOrder(1)
_cPerg := PADR(Pg,LEN(SX1->X1_GRUPO))
aRegs:={}
aAdd(aRegs,{_cPerg,"01","Filial de           		  ?","","","mv_ch1","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SM0","","","          "})
aAdd(aRegs,{_cPerg,"02","Filial ate           		  ?","","","mv_ch2","C",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SM0","","","          "})
aAdd(aRegs,{_cPerg,"03","Data de     				  ?","","","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","          "})
aAdd(aRegs,{_cPerg,"04","Data ate    				  ?","","","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","          "})

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


