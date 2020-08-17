#Include 'Rwmake.ch'
#Include 'TopConn.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CSCOMR11  ºAutor  ³ Antonio Cordeiro   º Data ³  NOV/2009   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relacao de pedido eliminados por residuo.                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico cliente CSU.                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CSCOMR11()

Private cDesc1        := "Relacao dos pedidos restaurados de eliminacao por residuo  "
Private cDesc2       := ""
Private cDesc3       := ""
Private titulo       := " Pedidos Restaurados de Eliminaçao por residuo "+SM0->M0_NOME
Private nLin         := 66
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "CSCOMR11"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private m_pag        := 01
Private wnrel        := "CSCOMR11"
Private cString      := ""
Private aRegs        := {}
Private cPerg        := 'COMR11'


Private Cabec1       := "Pedido Item  Dt.Emissao  Dt.Eliminacao  Valor Item      Descriçao Item                 Area Demandante      Responsavel           Dt. Retorno  Motivo Retorno "
//999999 9999  99/99/99     99/99/99     99,999,999.99   XXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXX    99/99/99   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
//0      8     14           27           40              56                             87                   108                     132        143                    
Private Cabec2       := ""
                                                                                       //  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30
aAdd(aRegs,{cPerg,"01","Pedidos de:.........:","","","mv_cha","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SC7","","","","",""})  
aAdd(aRegs,{cPerg,"02","Pedidos Ate:........:","","","mv_chb","C",06,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SC7","","","","",""})  
aAdd(aRegs,{cPerg,"03","Emissao de:.........:","","","mv_chc","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})  
aAdd(aRegs,{cPerg,"04","Emissao Ate:........:","","","mv_chd","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})  
aAdd(aRegs,{cPerg,"05","Fornecedor de:......:","","","mv_che","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SC7","","","","",""})  
aAdd(aRegs,{cPerg,"06","Fornecedor Ate:.....:","","","mv_chf","C",06,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SC7","","","","",""})  
AADD(aRegs,{cPerg,"07","Atendimento.........:","","","mv_chg","N",01,0,0,"C","","mv_par07","Todos","","","","","100%","","","","","Todos","","","","","","","","","","","","","","","","","","",""})

U_ValidPerg(cPerg, aRegs) // Cria as perguntas --> YpfxFun.prw

Pergunte(cPerg,.F.)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.f.,,.f.,Tamanho,,.f.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

Processa( {|| RunProc() },Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ RunProc  º Autor ³ Antonio Cordeiro   º Data ³ Out/2007    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Processamento do Relatorio.                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ProR01.prw                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunProc()

IF SELECT("TM1")>0
	DBSELECTAREA('TM1')
	DBCLOSEAREA()
ENDIF


_cQuery:= " SELECT ZB5.*,SC7.* "
_cQuery+= " FROM "+RetSqlName('ZB5')+" ZB5, "+RetSqlName('SC7')+" SC7 "
_cQuery+= " WHERE ZB5.ZB5_FILIAL  = '"+XFILIAL('ZB5')+"' AND "
_cQuery+= "       ZB5.ZB5_PEDIDO >= '"+MV_PAR01+"' AND "
_cQuery+= "       ZB5.ZB5_PEDIDO <= '"+MV_PAR02+"' AND "
_cQuery+= "       ZB5.ZB5_FILIAL = SC7.C7_FILIAL AND "
_cQuery+= "       ZB5.ZB5_PEDIDO = SC7.C7_NUM    AND "
_cQuery+= "       ZB5.ZB5_ITEMPC = SC7.C7_ITEM   AND "
_cQuery+= "       SC7.C7_FORNECE >= '"+MV_PAR05+"' AND "
_cQuery+= "       SC7.C7_FORNECE <= '"+MV_PAR06+"' AND "
_cQuery+= "       SC7.C7_EMISSAO >= '"+DTOS(MV_PAR03)+"' AND " 
_cQuery+= "       SC7.C7_EMISSAO <= '"+DTOS(MV_PAR04)+"' AND " 
_cQuery+= "       ZB5.D_E_L_E_T_ = ' '   AND   "
_cQuery+= "       SC7.D_E_L_E_T_ = ' '  "
_cQuery+= "       ORDER BY ZB5.ZB5_PEDIDO,ZB5.ZB5_ITEMPC  "
TCQUERY _cQuery New Alias "TM1"
_nRet  := U_MontaView( _cQuery, "TM1" )
nLin:=70
TcSetField("TM1","ZB5_DATA","D")
TcSetField("TM1","ZB5_DTELI","D")
TcSetField("TM1","C7_EMISSAO","D")

DBSELECTAREA('TM1')
ProcRegua(_nRet)
DBGOTOP()
_cPedido:=""
While !Eof()
	If nLin > 58
		nLin := Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin += 2
	ENDIF
	nLin+=1
    IF _cPedido<>TM1->ZB5_PEDIDO
       @ nLin,000 PSAY TM1->ZB5_PEDIDO
       _cPedido:=TM1->ZB5_PEDIDO
    ENDIF
    @ nLin,008 PSAY TM1->C7_ITEM    
    @ nLin,014 PSAY TM1->C7_EMISSAO
    @ nLin,027 PSAY TM1->ZB5_DTELI 
    @ nLin,040 PSAY TM1->C7_TOTAL PICTURE "@E 99,999,999.99"  
    @ nLin,056 PSAY SUBSTR(TM1->C7_DESCRI,1,30) 
    @ nLin,087 PSAY TM1->ZB5_AREA  
    @ nLin,108 PSAY TM1->ZB5_RESP  
    @ nLin,132 PSAY TM1->ZB5_DATA  
    @ nLin,143 PSAY SUBSTR(TM1->ZB5_MOTIVO,1,80)
	IF nLin>58
		nLin+=2
		Roda(0," ",Tamanho)
	ENDIF
    DBSELECTAREA('TM1')
    DBSKIP()
EndDo
Roda(0," ",Tamanho)
IF SELECT("TM1")>0
	DBSELECTAREA('TM1')
	DBCLOSEAREA()
ENDIF

Set Device To Screen
If aReturn[5]==1
	DbCommitAll()
	Set Printer To
	OurSpool(wnrel)
Endif
Ms_Flush()
Return


