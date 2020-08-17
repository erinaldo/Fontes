#include "rwmake.ch"

User Function  VFSRASRB()

Local	oDlg   		:= NIL
Private cEOL   		:= 	"CHR(13)+CHR(10)"
Private aInfo		:= {}
Private _caracter	:=""
Private _cInf		:=""
Private _carray		:={}   

_cPerg := PADR("VF",LEN(SX1->X1_GRUPO))

validperg()

Pergunte(_cPerg,.F.)

// *** Montagem da tela de Inicial de apresentação da rotina.

@ 200,1 TO 380,450 DIALOG oLeTxt TITLE OemToAnsi("Analise dos caracteres")
@ 02,10 TO 060,215
@ 10,018 Say " A rotina analisa os caracteres conforme parâmetros informados."        SIZE 196,0

@ 70,128 BMPBUTTON TYPE 05 ACTION Pergunte(_cPerg,.T.)
@ 70,158 BMPBUTTON TYPE 01 ACTION Proctit()
@ 70,188 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)

Activate Dialog oLeTxt Centered

Static Function Proctit()
Processa({ ||Caracter() },"Analisando tabela" )
Return

Static Function Caracter()

Private _carq		:= MV_PAR01
Private _ccampo		:= MV_PAR02  
Private _mat		:=""          
Private _filial		:=""   
Private _carray		:={}

DBSELECTAREA(_carq)
dbGoTop()

ProcRegua(RecCount())

DO WHILE !EOF()
	
	RECLOCK(_carq ,.F.) //alocando o registro
	_caracter:=&_ccampo 	  //passa para a variável _caracter o conteudo do registro
	_mat:=&(substr(_ccampo,1,9)+"MAT")
	_filial:=&(substr(_ccampo,1,9)+"FILIAL")
	MSUNLOCK()
	_caracter:=alltrim(_caracter) //tira espacos em branco
	
	For i:=1 to len(_caracter)  // leitura dos caracteres um a um
		
		_cinf:=substr(_caracter,i,1)
		
		if _cinf $":*-*1*2*3*4*5*6*7*8*9*0*,*'*.* *-*/*Q*W*E*R*T*Y*U*I*O*P*A*S*D*F*G*H*J*K*L*Z*X*C*V*B*N*M*q*w*e*r*t*y*u*i*o*p*a*s**d*f*g*h*j*k*l*z**x*c*v*b*n*m"
			
		Else
			aAdd(_carray,{_caracter,_mat,_filial})
		Endif
		
	Next
	
	DBSELECTAREA(_carq)
	DBSKIP()   //muda de registro na tabela
	INCPROC()
	
ENDDO

GeraTXT() 

DBSELECTAREA(_carq)
DBCLOSEAREA()

Static Function GeraTXT()              

Private cFile  		:= 	"c:\"+Alltrim(MV_PAR03)+".TXT"
Private _cFile   	:= 	cFile
Private nHdl   		:= 	fCreate(_cFile)

For i:=1 to len(_carray)
	
	cCpo	:=_carray[i,1]  
	cCpo2	:=_carray[i,2]  
	cCpo3	:=_carray[i,3]
	cCpo	:=cCpo3+" - "+cCpo2+" - "+cCpo+&cEOL
	
	FWrite(nHdl,Ccpo)   //grava a linha do lançamento
	
Next
fClose(nHdl)
Return                                                       

//Close(oLeTxt)   	   //fecha a tela de parâmetros/perguntas

#IFDEF WINDOWS
	MsgAlert ("Fim")
#ELSE
	Alert(" Fim ")
#ENDIF

RETURN

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³VALIDPERG ³ Autor ³  Luiz Carlos Vieira   ³ Data ³ 18/11/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica as perguntas inclu¡ndo-as caso n„o existam        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Espec¡fico para clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

// Substituido pelo assistente de conversao do AP5 IDE em 07/06/00 ==> Function ValidPerg

Static Function ValidPerg()

_sAlias := Alias()

dbSelectArea("SX1")
dbSetOrder(1)
_cPerg := PADR(_cPerg,LEN(SX1->X1_GRUPO))
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{_cPerg,"01","Tabela         ?","","","mv_ch1","C",03,0,0,"G","","mv_par01","","","","","","","","","","","","","",""})
aAdd(aRegs,{_cPerg,"02","Campo da Tabela?","","","mv_ch2","C",20,0,0,"G","","mv_par02","","","","","","","","","","","","","",""})
aAdd(aRegs,{_cPerg,"03","Arq. de Saída  ?","","","mv_ch3","C",10,0,0,"G","","mv_par03","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(_cPerg+aRegs[i,2])
		RecLock("SX1",.T.)     //RESERVA DENTRO DO BANCO DE PERGUNTAS
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()    //SALVA O CONTEUDO DO ARRAY NO BANCO
	Endif
Next

dbSelectArea(_sAlias)

Return