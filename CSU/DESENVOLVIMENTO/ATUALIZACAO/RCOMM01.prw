
#include 'rwmake.ch'
/*                                                                                                
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RCOMM01   ºAutor  ³Renato Lucena Neves º Data ³  16/02/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para limpar o campo C7_FILENT                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8-CSU                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RCOMM01()

Local _aArea	:= GetArea()
Local _aAreaSC7	:= SC7->(GetArea())
Local _aSays	:= {}
Local _aButtons := {} 
Local _nOpca	:= 0
Local _cFiltro	:= ""  
Local cIndexName:= ""
Local cIndexKey := ""
Local cFilter	:= ""
Local _cCadastro:= "" 
Local _lOK		:= .T.        
Local _cMarca	:= ""
Private _cPerg	:= PADR("XCOM01",LEN(SX1->X1_GRUPO))
Private aMarked	:= {}         
Private oDlg

_fCriaSX1()

Pergunte(_cPerg,.F. )

_cCadastro:="Limpa filial de entrega - Pedido de Compras"

AADD(_aSays,"Este programa ira apagar o conteudo do campo C7_FILENT. Para que a rotina seja" )
AADD(_aSays,"executada com sucesso o pedido deve estar liberado e com quantidade entregue zerada. " )   

AADD(_aButtons, { 5,.T.,{|| Pergunte(_cPerg,.T. ) } } )
AADD(_aButtons, { 1,.T.,{|o| _nOpca := 1,FechaBatch() }} )
AADD(_aButtons, { 2,.T.,{|o| FechaBatch() }} )
	
FormBatch( _cCadastro, _aSays, _aButtons )

If _nOpca == 1

	DbSelectArea('SC7')   
	_cFiltro:=DBFilter()  
	Set Filter To
	
	cIndexName := Criatrab(Nil,.F.)
	cIndexKey  := 	"C7_FILIAL+C7_NUM+C7_FORNECE+C7_LOJA"
	cFilter    := 	"C7_NUM>= '" + MV_PAR01 + "' .And. C7_NUM <= '" + MV_PAR02 + "' .And. " + ;
	"C7_FORNECE >= '" + MV_PAR03 + "' .And. C7_LOJA >= '" + MV_PAR04 + "' .And. " + ;
	"C7_FORNECE <= '" + MV_PAR05 + "' .And. C7_LOJA <= '" + MV_PAR06 + "' .And. " + ;
	"C7_FILIAL == '"+xFilial('SC7')+"' .and. C7_QUJE == 0 .and. C7_ENCER<>'E' .and. C7_CONAPRO=='L'"
	
	IndRegua("SC7", cIndexName, cIndexKey,,cFilter, "Aguarde selecionando registros....")
	DbSelectArea("SC7")
   //	Set Filter to cFilter
	
	dbGoTop()
	
	If MV_PAR07==1
	
			@ 001,001 TO 400,700 DIALOG oDlg TITLE "Selecao de Titulos"
			@ 001,001 TO 170,350 BROWSE "SC7" MARK "C7_OK"
			@ 180,310 BMPBUTTON TYPE 01 ACTION (_lOk := .T.,Close(oDlg))
			@ 180,280 BMPBUTTON TYPE 02 ACTION (_lOK := .F.,Close(oDlg))
			ACTIVATE DIALOG oDlg CENTERED
	endif		
	
	If _lOk
		dbGoTop()
			
		Do While !Eof()
			if mv_par07 == 1
//				_cMarca:=ThisMark()
				If Marked("C7_OK")		
						AADD(aMarked,.T.)
				Else
						AADD(aMarked,.F.)
				EndIf
			else
					AADD(aMarked,.T.)		
			endif
			dbSkip()
		EndDo
		
		processa({||_fprocessa()},"Aguarde...")
	endif		
	DbSelectArea('SC7')
	Set Filter To _cFiltro
	RestArea(_aAreaSC7)

endif

RestArea(_aArea)	
Return 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fProcessa ºAutor  ³Renato Lucena Neves º Data ³  02/16/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Funçaõ que desmarca os pedidos de compras                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8-CSU                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function _fProcessa()

procregua(len(aMarked))

DbGoTop()

For _nI:=1 to len(aMarked)
	incproc()   
	
	If aMarked[_nI]
//		MsgAlert(str(Recno()) + 'desmarcado')
		RecLock('SC7',.F.)
			SC7->C7_FILENT:=''
		MsUnLock()	
	endif        
	
	DbSkip()
Next _nI
               
return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³_fCriaSX1 ºAutor  ³Renato Lucena Neves º Data ³  02/16/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Cria o grupo e perguntas no SX1                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function _fCriaSX1()

DbSelectArea("SX1")
DbSetOrder(1)

If ! SX1->(DbSeek(_cPerg+"01",.t.))
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := _cPerg
	SX1->X1_ORDEM   := "01"
	SX1->X1_PERGUNT := "Pedido de"
	SX1->X1_VARIAVL := "mv_ch1"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 06
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par01"
	SX1->X1_DEF01   := ""
	SX1->X1_F3		 := "SC7"
	MsUnLock()
EndIf

If ! SX1->(DbSeek(_cPerg+"02",.t.))
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := _cPerg
	SX1->X1_ORDEM   := "02"
	SX1->X1_PERGUNT := "Pedido até"
	SX1->X1_VARIAVL := "mv_ch2"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 06
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par02"
	SX1->X1_DEF01   := ""
	SX1->X1_F3		 := "SC7"
	MsUnLock()
EndIf

If ! SX1->(DbSeek(_cPerg+"03",.t.))
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := _cPerg
	SX1->X1_ORDEM   := "03"
	SX1->X1_PERGUNT := "Fornecedor de"
	SX1->X1_VARIAVL := "mv_ch3"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 06
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par03"
	SX1->X1_DEF01   := ""
	SX1->X1_F3		 := "SA2"
	MsUnLock()
EndIf                          

If ! SX1->(DbSeek(_cPerg+"04",.t.))
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := _cPerg
	SX1->X1_ORDEM   := "04"
	SX1->X1_PERGUNT := "Loja de"
	SX1->X1_VARIAVL := "mv_ch4"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 02
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par03"
	SX1->X1_DEF01   := ""
	SX1->X1_F3		 := ""
	MsUnLock()           
EndIf                    

If ! SX1->(DbSeek(_cPerg+"05",.t.))
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := _cPerg
	SX1->X1_ORDEM   := "05"
	SX1->X1_PERGUNT := "Fornecedor ate"
	SX1->X1_VARIAVL := "mv_ch5"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 06
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par05"
	SX1->X1_DEF01   := ""
	SX1->X1_F3		 := "SA2"
	MsUnLock()
EndIf                          
If ! SX1->(DbSeek(_cPerg+"06",.t.))
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := _cPerg
	SX1->X1_ORDEM   := "06"
	SX1->X1_PERGUNT := "Loja de"
	SX1->X1_VARIAVL := "mv_ch6"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 02
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "G"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par06"
	SX1->X1_DEF01   := ""
	SX1->X1_F3		 := ""
	MsUnLock()           
EndIf                    

If ! SX1->(DbSeek(_cPerg+"07",.t.))
	Reclock("SX1",.t.)
	SX1->X1_GRUPO   := _cPerg
	SX1->X1_ORDEM   := "07"
	SX1->X1_PERGUNT := "Seleciona ?"
	SX1->X1_VARIAVL := "mv_ch7"
	SX1->X1_TIPO    := "N"
	SX1->X1_TAMANHO := 01
	SX1->X1_DECIMAL := 0
	SX1->X1_PRESEL  := 0
	SX1->X1_GSC     := "C"
	SX1->X1_VALID   := ""
	SX1->X1_VAR01   := "mv_par07"
	SX1->X1_DEF01   := "Sim"
	SX1->X1_DEF02   := "Nao"
	SX1->X1_F3		 := ""
	MsUnLock()
EndIf                           

return