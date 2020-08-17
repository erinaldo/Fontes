#Include 'Rwmake.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRcomm02   บAutor  ณSergio Oliveira     บ Data ณ  Dez/2007   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Efetua o de-para de compradores entre os pedidos de comprasบฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU - Suprimentos.                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function Rcomm02()

Local mkwdlg
Local cPerg := PADR('RCOMM2',LEN(SX1->X1_GRUPO))
_cMsg  := "Selecione o comprador destino e origem."
aRegs  := {}
_aStru := {}
Aadd( _aStru, {'C7_NUM' ,'C',06,0} )
Aadd( _aStru, {'C7_EMISSAO' ,'D',8,0} )
Aadd( _aStru, {'C7_DESCRI' ,'C',TamSX3('C7_DESCRI')[1],0} )
Aadd( _aStru, {'C7_USER'   ,'C',06,0} )
Aadd( _aStru, {'COMPRADOR' ,'C',40,0} )
Aadd( _aStru, {'OK'        ,'C',02,0} )

_xTmp     := U_CriaTmp( _aStru, 'Work' )

aCampos   := {}
Aadd( aCampos, {'OK'       ,'Ok'                    ,'@!'   ,'02','0'} )
Aadd( aCampos, {'C7_EMISSAO','Emissao'              ,''   ,'08','0'} )
Aadd( aCampos, {'C7_NUM'   ,'Pedido'                ,'@!'   ,'06','0'} )
Aadd( aCampos, {'C7_DESCRI','Descricao do Produto'  ,'@!S30',TamSX3('C7_DESCRI')[1],'0'} )
Aadd( aCampos, {'COMPRADOR','Comprador de Origem'   ,'@!'   ,'40','0'} )

aAdd(aRegs,{cPerg,"01","Emissao De.........:","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Emissao Ate........:","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

U_ValidPerg( cPerg, aRegs )

If !Pergunte( cPerg,.t. )
	Return
EndIf

Private _cPesq  := Space(06), _cPesq2 := Space(06)
_cCombo := ""
_cComp  := "  "
_aCombo := {}
Private oObj

@ 187,108 To 611,916 Dialog mkwdlg Title "Pesquisa Especial - Troca de Compradores"
@ 002,003 To 210,398
@ 002,003 To 210,113
@ 007,118 To 206,394 Title "Resultados da Pesquisa"
@ 177,118 To 205,394
@ 024,006 To 094,110 Title "Digite o Comprador (ID)"
@ 014,120 To 174,392 Browse "Work" Mark "OK" Fields aCampos Object oObj
@ 047,008 Get _cPesq Size 100,10 F3 "SY1_" Valid( Vazio().Or.UsrExist( _cPesq ) )
@ 068,038 Button OemToAnsi("_Pesquisar") Size 36,16 Action(_Pesquisar())

@ 098,006 To 130,110 Title "Comprador Destino"
@ 110,020 Get _cPesq2 F3 "SY1_" Size 76,10 Valid( Vazio().Or.UsrExist( _cPesq2 ) )

@ 185,208 BmpButton Type 19 Action( IIF( !Empty( _cPesq2 ).And. !Empty( _cPesq ), _Atualiza(), Alert(_cMsg) ) )
@ 185,245 BmpButton Type 05 Action( Pergunte(cPerg,.t.) )
@ 185,279 BmpButton Type 02 Action( Work->(DbCloseArea()), Close(mkwdlg) )

Activate Dialog mkwdlg Centered

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ_PesquisarบAutor  ณSergio Oliveira     บ Data ณ  Dez/2007   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processamento da rotina.                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rcomm02.prw                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _Pesquisar()

If Empty(_cPesq)
	Return
EndIf

DbSelectArea('Work')
DbGoTop()
While !Eof()
	RecLock('Work',.f.)
	DbDelete()
	MsUnLock()
	DbSkip()
EndDo

_xSelect := "C7_FILIAL = '"+xFilial('SC7')+"' .And. DTOS(C7_EMISSAO) >= '"+Dtos(MV_PAR01)+"' "
_xSelect += " .And. DTOS(C7_EMISSAO) <= '"+Dtos(MV_PAR02)+"'  .And. C7_QUJE < C7_QUANT "
_xSelect += " .And. C7_USER = '"+_cPesq+"' .And. Empty( C7_RESIDUO ) "

// Apendar o SY1_ no SXB da producao.

DbSelectArea('SC7')
Set Filter To &_xSelect
DbGoTop()
While !Eof()
	
	DbSelectArea('Work')
	RecLock('Work',.t.)
	Field->C7_NUM    := SC7->C7_NUM
	Field->C7_DESCRI := SC7->C7_DESCRI
	Field->C7_USER   := SC7->C7_USER
	Field->C7_EMISSAO:= SC7->C7_EMISSAO
	Field->COMPRADOR := UsrFullName( SC7->C7_USER )
	MsUnLock()
	
	DbSelectArea('SC7')
	DbSkip()
	
EndDo

DbSelectArea('SC7')
Set Filter To

DbSelectArea('Work')
DbGoTop()

If Work->( Eof() )
	Aviso("Sem Dados","Nao existe pedido para este comprador.",{"&Fechar"},3,"Comprador",,"PMSAPONT")   
EndIf

oObj:oBrowse:Refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ_Atualiza บAutor  ณSergio Oliveira     บ Data ณ  Dez/2007   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza o comprador destino.                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Rcomm02.prw                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function _Atualiza()

If !U_ConfSeg('Transferencia de Comprador')
   Return
EndIf

SC7->( DbSetOrder(1) )

Work->( DbGoTop() )

While !Work->( Eof() )
    
    If Empty( Work->OK )                 

	    If SC7->( DbSeek( xFilial('SC7')+Work->C7_NUM ) )
		    SC7->( RecLock('SC7',.f.) )
			SC7->C7_USER := _cPesq2
		    SC7->( MsUnLock() )
	    EndIf

	    Work->( RecLock('Work',.f.) )
		Work->C7_USER   := _cPesq2
		Work->COMPRADOR := UsrFullName( _cPesq2 )
	    Work->( MsUnLock() )
    
    EndIf

	Work->( DbSkip() )
	
EndDo

DbSelectArea('Work')
DbGoTop()

oObj:oBrowse:Refresh()

_cPesq  := _cPesq2
_cPesq2 := Space(06)

Return                     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณConfSeg   บAutor  ณ Sergio Oliveira    บ Data ณ  Ago/2007   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Validar se o codigo de seguranca foi digitado corretamente.บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico.                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ConfSeg(pcOperacao)

Local cCodSeg  := Right( CriaTrab( Nil,.f. ),6 )
Local cConfSeg := Space(6)
Local cTxtMens := pcOperacao
Local oMens1
Local oFont  := TFont():New("Tahoma",8,,,.T.,,,,,.F.) // Com Negrito
Private lVai := .t.

Define MsDialog MkwDlg Title "" From 173,165 To 380,565 Of oMainWnd Pixel
@ 000,001 To 104,194
@ 000,001 To 023,194
@ 057,010 To 099,134 Title "Confirme o Codigo de Seguran็a Abaixo:"
@ 020,141 To 104,194
@ 027,147 To 098,190 Title "Op็๕es"
@ 009,013 Say cTxtMens Color 8388608 Object oMens1 Size 174,8
@ 028,008 Say "Queira por gentileza digitar no quadro abaixo o codigo"  Size 130,8
@ 035,008 Say "de seguranca que esta sendo exibido como referencia" Size 130,8
@ 042,008 Say "ao lado:" Size 69,8
@ 044,082 Get cCodSeg  Picture "@!" Size 45,10 When .f.
@ 073,034 Get cConfSeg Picture "@!" Size 45,10
@ 044,150 Button "_Confirmar" Size 36,16 Action( ConfSeg01(MkwDlg, cCodSeg, cConfSeg) )
@ 066,150 Button "_Abandonar" Size 36,16 Action( lVai := .f., Close( Mkwdlg ) )

oMens1:ofont:=ofont

Activate MsDialog Mkwdlg Centered

Return( lVai )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao    ณ ConfSeg01บAutor  ณ Sergio Oliveira    บ Data ณ  Ago/2007   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Validar se o codigo de seguranca foi digitado corretamente.บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Confseg()                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ConfSeg01( poDialogo, pcCodSeg, pcConfSeg, pcCodRateio, pcBusca )

Local cTxtBlq := "Codigo de seguranca invalido. Verifique a sua digitacao."
Local cExec

If pcCodSeg # pcConfSeg
	Aviso("Codigo de Seguranca",cTxtBlq,{"&Fechar"},3,"Confirma็ใo Invแlida",,"PCOLOCK")   
	lVai := .f.
Else
    Close( poDialogo )
    lVai := .t.
EndIf

Return