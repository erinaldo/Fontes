#INCLUDE "rwmake.ch"
#include "topconn.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Muda Cheque ºAutor  ³                    º Data ³  09/10/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Este programa tem a finalidade de alterar o numero de um      º±±
±±º          ³cheque que foi emitido com o numero errado no sistema         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CSUALTCH()

Private cPerg := PADR("CHEQUE",LEN(SX1->X1_GRUPO))

validperg()

If !Pergunte(cPerg,.T.)
	
	Return
	
Else
	Processa({ ||cheque() } ) // chama a função cheque
	
Endif

Return

                                               
//Função altera cheque

Static Function Cheque()

dbselectarea("SEF")
dbsetorder(4)
If dbseek (xFilial()+MV_PAR02+MV_PAR03+MV_PAR04+MV_PAR05,.T.)
	
		
		Alert("Numero de cheque a ser alterado ja existe")
		
		Return
		
                   
	
Else
	
	ProcRegua(3)
	_cQuery := " SELECT EF_NUM,EF_PREFIXO,EF_TITULO,EF_PARCELA,EF_TIPO,EF_FORNECE,EF_LOJA,EF_DATA,EF_BANCO,EF_AGENCIA,EF_CONTA "
	_cQuery += " FROM "+RETSQLNAME("SEF")+ " "
	_cQuery += " WHERE D_E_L_E_T_ <> '*' AND EF_FILIAL='"+xfilial()+"' AND EF_NUM = '"+ALLTRIM(MV_PAR01)+"'AND EF_BANCO = '"+ALLTRIM(MV_PAR03)+"' AND EF_AGENCIA = '"+ALLTRIM(MV_PAR04)+"' AND EF_CONTA = '"+ALLTRIM(MV_PAR05)+"'" 

	
	
	If Select("TABELA") >0
		DBSelectArea("TABELA")
		DBCloseArea()
	Endif
	
	
	IncProc("Buscando Dados")
	TCQUERY _cQuery NEW ALIAS "TABELA"
	
	
	DBSelectArea("TABELA")
	dbGotop()
	
	If EOF()
		Alert("Nao existem dados para este numero de cheque "+alltrim(MV_PAR01))
	EndIf
	
	While !EOF()
		
		IncProc("Alterando o Cheque..." + TABELA->EF_NUM)
		
		DBSelectArea("SEF")
		DBSetOrder(4)
		If DBSeek(xFilial()+TABELA->EF_BANCO+TABELA->EF_AGENCIA+TABELA->EF_CONTA,.T.)
			
			Reclock("SEF",.F.)
			SEF->EF_NUM := MV_PAR02
			MsUnlock()
			
		Else
			
			Alert("Cheque "+TABELA->EF_NUM+" nao encontrado na tabela SEF")
			
		Endif
		
		
		DBSelectArea("SE2")
		DBSetOrder(1)
		If DBSeek(xfilial()+TABELA->EF_PREFIXO+TABELA->EF_TITULO+TABELA->EF_PARCELA+TABELA->EF_TIPO+TABELA->EF_FORNECE+TABELA->EF_LOJA,.T.)
			
			
			Reclock("SE2",.F.)
			SE2->E2_NUMBCO := MV_PAR02
			MsUnlock()
			
		Endif
		
		
		DBSelectArea("SE5")
		DBSetOrder(1)
		If DBSeek(xfilial()+TABELA->EF_DATA+TABELA->EF_BANCO+TABELA->EF_AGENCIA+TABELA->EF_CONTA+TABELA->EF_NUM,.T.)
			
			
			Reclock("SE5",.F.)
			SE5->E5_NUMCHEQ := MV_PAR02
			MsUnlock()
			
		Else
			
			Alert("Cheque "+TABELA->EF_NUM+" nao encontrado na tabela SE5")
			
		Endif
		
		
		
		
		DBSelectArea("TABELA")
		DBSKIP()
		
		
	EndDo
Endif  

Return




//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
//±±³Fun‡…o    ³VALIDPERG ³ Autor ³  Luiz Carlos Vieira   ³ Data ³ 18/11/97 ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Descri‡…o ³ Verifica as perguntas inclu¡ndo-as caso n„o existam        ³±±
//±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//±±³Uso       ³ Espec¡fico para clientes Microsiga                         ³±±
//±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/


// Substituido pelo assistente de conversao do AP5 IDE em 07/06/00 ==> Function ValidPerg

Static Function ValidPerg()

_sAlias := Alias()

dbSelectArea("SX1") // abre arquivo sx1 de perguntas
dbSetOrder(1)       // coloca na ordem 1 do sindex
cPerg := PADR(cPerg,LEN(SX1->X1_GRUPO))
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cPerg,"01"," Do Cheque     ?","","","mv_ch1","C",15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02"," Para o cheque ?","","","mv_ch2","C",15,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03"," Do Banco      ?","","","mv_ch3","C", 3,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SA6","007"})
AADD(aRegs,{cPerg,"04"," Da Agencia    ?","","","mv_ch4","C", 5,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","008"})
AADD(aRegs,{cPerg,"05"," Da Conta      ?","","","mv_ch5","C",10,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","009"})
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
