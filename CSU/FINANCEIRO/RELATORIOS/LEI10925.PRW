#INCLUDE "rwmake.ch"
#INCLUDE "common.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LEI10925    ºAutor  ³Adriana Sarro       º Data ³  16/08/04   º±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºDesc.     ³Relatório de títulos pagos por fornecedor, p/apoio lei 10925  º±±
±±º          ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³CSU CARDSYSTEM S/A                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LEI10925()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*******PARAMETROS ***********
Da data da baixa      ?mv_par01
Até a data da Baixa   ?mv_par02
De fornecedor         ?mv_par03
Até fornecedor        ?mv_par04
******************************/

Private cPerg  := PADR("LEI10925",LEN(SX1->X1_GRUPO))
Private Courier, cCode, CGC, Empresa, _codForn, _cnomefornece, _cQuery  

Private	_nVlLEI:=0
Private	_nValor:=0
Private	_nVrImp:=0
Private	_nVrTotal:=0
Private	_nVrTotalRecolher:=0
Private	_nVrImpRetido:=0
Private	_nVrImpRecolhe:=0
Private lin:=50
Private Col:=50

nHeight:=15
lBold:= .F.
lUnderLine:= .F.
lPixel:= .T.
lPrint:=.F.

Private Times10   := TFont():New( "Times New Roman",,10,,.t.,,,,,.f. )
Private Times14   := TFont():New( "Times New Roman",,14,,.t.,,,,,.f. )
Private Times28   := TFont():New( "Times New Roman",,18,,.t.,,,,,.f. )

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

_cQuery := " SELECT E5_DATA,E2_PREFIXO,E2_NUM,E2_TIPO, E2_FORNECE, E2_LOJA, A2_NOME,ED_DESCRIC,"
_cQuery += " E5_VALOR, E2_PIS, E2_COFINS, E2_CSLL, E2_EMISSAO,E2_VENCTO,E2_VENCREA,A2_CGC "
_cQuery += " FROM "+RETSQLNAME('SE2')+","+RETSQLNAME('SE5')+","
_cQuery += ""+RETSQLNAME('SA2')+","+RETSQLNAME('SED')+" "
_cQuery += " WHERE "
_cQuery += " A2_COD+A2_LOJA=E2_FORNECE+E2_LOJA "
_cQuery += " AND ED_CODIGO=E2_NATUREZ "
_cQuery += " AND E2_PREFIXO=E5_PREFIXO "       
_cQuery += " AND E2_NUM=E5_NUMERO "
_cQuery += " AND E2_TIPO=E5_TIPO "
_cQuery += " AND E2_PARCELA=E5_PARCELA "
_cQuery += " AND E2_FORNECE=E5_CLIFOR "
_cQuery += " AND E2_LOJA=E5_LOJA "
_cQuery += " AND E5_DATA  BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "'"
_cQuery += " AND E2_FORNECE BETWEEN '" + MV_PAR03 + "'AND '" + MV_PAR04 + "'"
_cQuery += " AND (E2_TIPO<>'TX ' AND E2_TIPO<>'ISS' AND E2_TIPO<>'INS')"
_cQuery += " AND "+RETSQLNAME('SE2')+".D_E_L_E_T_ <> '*'"
_cQuery += " AND "+RETSQLNAME('SE5')+".D_E_L_E_T_ <> '*'"
_cQuery += " AND "+RETSQLNAME('SA2')+".D_E_L_E_T_ <> '*'"
_cQuery += " AND "+RETSQLNAME('SED')+".D_E_L_E_T_ <> '*'"
_cQuery += " ORDER BY E2_FILIAL,E2_FORNECE,E2_LOJA,E5_DATA,E2_PREFIXO,E2_NUM,E2_TIPO,E2_PARCELA"

If Select("TRDEXC") >0
	DBSelectArea("TRDEXC")
	DBCloseArea()
Endif

TCQUERY _cQuery NEW ALIAS "TRDEXC"

DBSelectArea("TRDEXC")
DBGotop()

SetRegua(RecCount())

// ORDEM (01) => E2_FILIAL+E2_FORNECE+E2_LOJA+E2_BAIXA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
oPrn := TMSPrinter():New()
    
IF !EOF()   
	//Cabeçalho do relatório
	relat()
	//Cabeçalho do grupo
	grupo()
	lin:= lin+50
Endif

//Detalhe do relatório
WHILE !EOF()
	
	IncRegua("Gerando os registros...")
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	oPrn:Say(lin,050, TRDEXC->E2_PREFIXO,Times10,100 )
	oPrn:Say(lin,200, TRDEXC->E2_NUM,Times10,100 )
	oPrn:Say(lin,400, TRDEXC->E2_TIPO,Times10,100 )
	oPrn:Say(lin,600, TRDEXC->ED_DESCRIC,Times10,100 )
	oPrn:Say(lin,1300, SUBS(TRDEXC->E2_EMISSAO,7,2)+"/"+SUBS(TRDEXC->E2_EMISSAO,5,2)+"/"+SUBS(TRDEXC->E2_EMISSAO,1,4),Times10,100)
	oPrn:Say(lin,1500, SUBS(TRDEXC->E2_VENCTO,7,2)+"/"+SUBS(TRDEXC->E2_VENCTO,5,2)+"/"+SUBS(TRDEXC->E2_VENCTO,1,4),Times10,100 )
	oPrn:Say(lin,1700, SUBS(TRDEXC->E2_VENCREA,7,2)+"/"+SUBS(TRDEXC->E2_VENCREA,5,2)+"/"+SUBS(TRDEXC->E2_VENCREA,1,4),Times10,100 )
	oPrn:Say(lin,1900, SUBS(TRDEXC->E5_DATA,7,2)+"/"+SUBS(TRDEXC->E5_DATA,5,2)+"/"+SUBS(TRDEXC->E5_DATA,1,4),Times10,100 )
	oPrn:Say(lin,2200, Transform(TRDEXC->E5_VALOR,"@E 999,999,999,999.99"),Times10,100 )
	//soma os impostos de PIS+COFINS+CSLL
	_nVrImp:=TRDEXC->E2_PIS+TRDEXC->E2_COFINS+TRDEXC->E2_CSLL
	oPrn:Say(lin,2650, Transform(_nVrImp,"@E 999,999,999,999.99"),Times10,100 )
	
	//** Acumula   
	_nVlLEI  := GETMV("MV_VL10925")
	if TRDEXC->E5_VALOR > _nVlLEI                  // 5000 NUMERICO 
		_nVrTotal		:=_nVrTotal+TRDEXC->E5_VALOR //Acumula o valor do título
		_nVrImpRetido   :=_nVrImpRetido+_nVrImp //Acumula o valor dos impostos retidos
	Else
		_nVrTotal		:=_nVrTotal+TRDEXC->E5_VALOR //Acumula o valor do título
		_nVrTotalRecolher:=_nVrTotalRecolher+TRDEXC->E5_VALOR //acumula valor dos títulos a serem recolhidos
	Endif
	
	//Grava registro Fornecedor + Loja atual para ser comparado depois com o próximo registro
	Flag:=TRDEXC->E2_FORNECE+TRDEXC->E2_LOJA
	
	DBSelectArea("TRDEXC")
	dbSkip()
	
	//Compara o próximo registro Fornecedor + Loja com o atual
	if TRDEXC->E2_FORNECE+TRDEXC->E2_LOJA<>Flag
		
		// Verifica se o total de títulos do fornecedor é maior que o parâmetro MV_VL10925           
		
		_nVl135 := GETMV("MV_%MP135")
		if _nVrTotal>_nVlLEI
			_nVrImpRecolhe:=(_nVrTotalRecolher*_nVl135)/100       
		Else
			_nVrImpRecolhe:=0
		Endif
		               
		lin:=lin+100   
		oPrn:Say(lin,700, "Lei 10925/04",Times10,100 )
		lin:=lin+050   
		oPrn:Say(lin,050, "Total de Títulos",Times10,100)
		oPrn:Say(lin,400, "Impostos retidos",Times10,100)
		oPrn:Say(lin,900, "Impostos a recolher",Times10,100)
		lin:=lin+50
		oPrn:Say(lin,050,Transform(_nVrTotal,"@E 999,999,999.99"),Times10,100 )
		oPrn:Say(lin,400,Transform(_nVrImpRetido,"@E 999,999,999.99"),Times10,100 )
		oPrn:Say(lin,900,Transform(_nVrImpRecolhe,"@E 999,999,999.99"),Times10,100 )
		lin:=lin+100
		
		if !eof()
			grupo()
			_nVrTotal      		:=0
			_nVrImpRetido   	:=0
			_nVrTotalRecolher 	:=0
			_nVrImpRecolhe      :=0
			_nVrImpRetido       :=0
		endif
		
	Endif
	
	lin:=lin+50
	
	if lin>2000 .and. !eof()
		lin:=50
		col:=50
		oPrn:EndPage()
		oPrn:StartPage() 
		relat()       
		grupo()
		lin:= lin+50
	Endif
	
Enddo
oPrn:EndPage()

oPrn:Preview()
MS_FLUSH()
DBCloseArea("TRDEXC")

Return

//*** Retorna o nome da empresa corrente
Static Function LocNome()

Private NomEmpresa

dbselectarea("SM0")
dbsetorder(1)
NomEmpresa:=SM0->M0_NOMECOM

Return(NomEmpresa)


//Cabeçalho do relatório
Static Function Relat()

oPrn:Say(lin,0050,LocNome(),Times28,100 )
oPrn:Say(lin,2800,Transform(Ddatabase,"@E"),Times28,100 )
lin:=lin+50
oPrn:Say(lin,1200,"Relação de baixas de títulos por fornecedor",Times28,100 )
lin:=lin+200

Return

//Cabeçalho do Grupo
Static Function Grupo()

oPrn:Say(lin,050,"Fornecedor :"+TRDEXC->A2_NOME+" LOJA: "+TRDEXC->E2_LOJA+" CGC: "+Transform(TRDEXC->A2_CGC,"@R ##.###.###/####-##"),Times10,100 )
lin:=lin+50
oPrn:Say(lin,050,"Prefixo",Times10,100)
oPrn:Say(lin,200,"No. Título",Times10,100)
oPrn:Say(lin,400,"Tipo",Times10,100)
oPrn:Say(lin,600,"Natureza",Times10,100)
oPrn:Say(lin,1300,"Emissão",Times10,100)
oPrn:Say(lin,1500,"Vcto",Times10,100)
oPrn:Say(lin,1700,"Vcto Real",Times10,100)
oPrn:Say(lin,1900,"Baixa",Times10,100)
oPrn:Say(lin,2200,"Valor",Times10,100)
oPrn:Say(lin,2650,"Retido Lei 10925/04",Times10,100)

Return


//perguntas do relatório
Static Function ValidPerg()

_sAlias := Alias()

dbSelectArea("SX1") // abre arquivo sx1 de perguntas
dbSetOrder(1)       // coloca na ordem 1 do sindex
cPerg := PADR(cPerg,LEN(SX1->X1_GRUPO))
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cPerg,"01","Da  Dt da Baixa?","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Até Dt da Baixa?","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Do Fornecedor  ?","","","mv_ch3","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Até Fornecedor ?","","","mv_ch4","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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
