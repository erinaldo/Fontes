#INCLUDE "rwmake.ch"

// *** Rotina de alteração da data de um lançamento contábil.
// *** Data: 25/02/2002

User Function CSUCTB04()

If !(SM0->M0_CODIGO $ "02/03/04/09")
	MsgAlert("A rotina em questão somente está disponível para as empresas Cardsystem, Telesystem, Credit & Risk e Institucional !!!","Atencao!")
	Return
EndIf

_cPerg := PADR("ZZ0004",LEN(SX1->X1_GRUPO))

dbSelectArea("SX1")
dbSetOrder(1)
dbSeek( _cPerg )

If Eof()
	
	RecLock("SX1",.T.)
	SX1->X1_GRUPO    := _cPerg
	SX1->X1_ORDEM    := "01"
	SX1->X1_PERGUNT  := "No. Lote a alterar?"
	SX1->X1_VARIAVL  := "mv_ch1"
	SX1->X1_TIPO     := "C"
	SX1->X1_TAMANHO  := 6
	SX1->X1_GSC      := "G"
	SX1->X1_VAR01    := "mv_par01"
	MsUnlock()
	
	RecLock("SX1",.T.)
	SX1->X1_GRUPO    := _cPerg
	SX1->X1_ORDEM    := "02"
	SX1->X1_PERGUNT  := "No. SubLote ?"
	SX1->X1_VARIAVL  := "mv_ch2"
	SX1->X1_TIPO     := "C"
	SX1->X1_TAMANHO  := 3
	SX1->X1_GSC      := "G"
	SX1->X1_VAR01    := "mv_par02"
	MsUnlock()
	
	RecLock("SX1",.T.)
	SX1->X1_GRUPO    := _cPerg
	SX1->X1_ORDEM    := "03"
	SX1->X1_PERGUNT  := "No. Documento ?"
	SX1->X1_VARIAVL  := "mv_ch3"
	SX1->X1_TIPO     := "C"
	SX1->X1_TAMANHO  := 6
	SX1->X1_GSC      := "G"
	SX1->X1_VAR01    := "mv_par03"
	MsUnlock()
	
	RecLock("SX1",.T.)
	SX1->X1_GRUPO    := _cPerg
	SX1->X1_ORDEM    := "04"
	SX1->X1_PERGUNT  := "Data Atual ?"
	SX1->X1_VARIAVL  := "mv_ch4"
	SX1->X1_TIPO     := "D"
	SX1->X1_TAMANHO  := 8
	SX1->X1_GSC      := "G"
	SX1->X1_VAR01    := "mv_par04"
	MsUnlock()
	
	RecLock("SX1",.T.)
	SX1->X1_GRUPO    := _cPerg
	SX1->X1_ORDEM    := "05"
	SX1->X1_PERGUNT  := "Nova Data ?"
	SX1->X1_VARIAVL  := "mv_ch5"
	SX1->X1_TIPO     := "D"
	SX1->X1_TAMANHO  := 8
	SX1->X1_GSC      := "G"
	SX1->X1_VAR01    := "mv_par05"
	MsUnlock()
	
EndIf

Pergunte(_cPerg,.F.)

// Mv_Par01 - Lote ref. ao Doc que terá a data alterada.
// Mv_Par02 - Sub Lote ref. ao Doc
// Mv_Par03 - Doc que terá a data alterada.
// Mv_Par04 - Data atual do documento a ser alterado.
// Mv_Par05 - Nova Data

// *** Montagem da tela de Inicial de apresentação da rotina.

@ 200,1 TO 380,450 DIALOG oLeTl01 TITLE OemToAnsi("Alteração Data Lançamento Contábil")
@ 02,10 TO 060,215
@ 10,018 Say " Esta rotina tem como objetivo efetuar a alteração da data de um "	SIZE 196,0
@ 18,018 Say " lançamento contábil.                                            "	SIZE 196,0
@ 34,018 Say " IMPORTANTE: Após a(s) alteração(ões) em questão, é de suma      "	SIZE 196,0
@ 44,018 Say " importância a execução do REPROCESSAMENTO CONTÁBIL.             "	SIZE 196,0
@ 60,018 Say " Informe parâmetros ref. ao lançamento contábil a ser alterado..."	SIZE 196,0

@ 70,128 BMPBUTTON TYPE 05 ACTION Pergunte(_cPerg,.T.)
@ 70,158 BMPBUTTON TYPE 01 ACTION (Prvalid(),Close(oLeTl01))
@ 70,188 BMPBUTTON TYPE 02 ACTION Close(oLeTl01)

Activate Dialog oLeTl01 Centered

Return

// *****************************************************************
// *** Funcao chamada pelo botao OK na tela inicial de processamento
Static Function Prvalid()

// *** Valida parametros informados.

If 	Empty(Mv_Par01) .or. Empty(Mv_Par02) .or. Empty(Mv_Par03) .or. Empty(Mv_Par04) .or. Empty(Mv_Par05)
	MsgAlert("Existe parâmetro não preenchido, verifique !!!","Atencao!")
	Return
EndIf

// Se a nova data for igual a data atual, não ha o que alterar.
If Mv_Par04 == Mv_Par05
	MsgAlert("A data atual do lançamento é igual a nova data informada, verifique !!!","Atencao!")
	Return
EndIf

// Verifica se a nova data está dentro do mesmo exercício contábil.
If Year(Mv_Par04) <> Year(Mv_Par05)
	MsgAlert("A nova data informada não corresponde ao mesmo exercício contábil da atual (ANO), verifique !!!","Atencao!")
	Return
EndIf
       
// Verifica se a nova data do lançamento é = ou > 01/02/02, data inicio permitida 
// para a utilizaçao desta rotina (alteraçoes.
If Mv_Par05 < ctod("01/02/02")
	MsgAlert("Devido a conceitos envolvidos, esta rotina somente permite alterações para datas após 01/02/02.","Atencao!")
	Return
EndIf

// Pesquisa lançamento contábil a ser alterado (informado nos parametros) na base de dados.
DbSelectArea("CT2")
DbSetOrder(1)
DbSeek( xFilial()+DTOS(Mv_Par04)+Mv_Par01+Mv_Par02+Mv_Par03 )

If Eof()
	MsgAlert("Lançamento contábil informado não encontrado na base de dados, verifique parâmetros !!!","Atencao!")
	Return
ElseIf !Empty(CT2->CT2_LP)
	MsgAlert("O lançamento informado nos parâmetros foi gerado automaticamente pelo sistema, via integração com outros módulos. O mesmo não pode ser alterado !!! Efetue a devida alteração na fonte.","Atencao!")
//	Close(oLeTl01)
	Return
EndIf

// Guarda o numero dos registros a serem alterados (RECNO), referente ao lancamento.
aRecLan := {}

// ProcRegua(999)
	
While !Eof() .and. CT2->CT2_DATA = Mv_Par04 .and. CT2->CT2_LOTE == Mv_Par01 .and. CT2->CT2_SBLOTE == Mv_Par02 .and. CT2->CT2_DOC == Mv_Par03
  	
	// IncProc("Analisando informações...")
	aAdd( aRecLan,REcno())
	DbSkip()
	
End
	
// *** Pesquisa o novo numero de documento a ser gerado por motivo da alteracao em
// *** questao.

DbSelectArea("CT2")
DbSetOrder(1)
DbSeek( xFilial()+DTOS(Mv_Par05)+Mv_Par01+Mv_Par02+"999999",.T. )
		
DbSkip(-1)
		
If CT2->CT2_DATA == Mv_Par05 .and. CT2->CT2_LOTE == Mv_Par01 .and. CT2->CT2_SBLOTE == Mv_Par02
	cDOC := StrZero(Val(CT2->CT2_DOC) + 1,6)
Else
	cDoc := "000001"
EndIf
	
// *** Exibe tela de confirmação da alteração.
	
cMens1 := " LANÇAMENTO ATUAL"
cMens2 := " Data: "+dtoc(Mv_Par04)+"  Lote: "+Mv_Par01+"  SubLote: "+Mv_Par02+"  Documento: "+Mv_Par03
cMens3 := " LANÇAMENTO A SER GERADO (ALTERADO)"
cMens4 := " Data: "+dtoc(Mv_Par05)+"  Lote: "+Mv_Par01+"  SubLote: "+Mv_Par02+"  Documento: "+cDoc
	
@ 200,1 TO 380,450 DIALOG oLeTl02 TITLE OemToAnsi("Alteração Data Lançamento Contábil")
@ 02,10 TO 060,215

@ 10,018 Say cMens1 SIZE 196,0
@ 18,018 Say cMens2 SIZE 196,0
@ 34,018 Say cMens3 SIZE 196,0
@ 44,018 Say cMens4 SIZE 196,0
@ 60,018 Say "Click OK para confirmar a alteração acima..."  SIZE 196,0
	
@ 70,158 BMPBUTTON TYPE 01 ACTION Processa({ ||OkLeTxt(),,close(oLeTl02)})
@ 70,188 BMPBUTTON TYPE 02 ACTION Close(oLeTl02)
	
Activate Dialog oLeTl02 Centered
	
// **********************************************************
// *** Funcao chamada pela rotina de validação de parâmetros.
Static Function OkLeTxt()

DbSelectArea("CT2")
DbSetOrder(1)
	
ProcRegua(Len(aRecLan))
	
For x := 1 to Len(aRecLan)
		
	IncProc("Efetuando Alteraçao...")
	Go aRecLan[x]
		
	RecLock("CT2",.F.)
	CT2->CT2_DATA := Mv_Par05
	CT2->CT2_DOC := cDoc		
	MsUnLock()
			
Next
	
ALERT("ALTERAÇÃO DE DATA EFETUADA COM SUCESSO !")
	
//Close(oLeTl01)
//Close(oLeTl02)
	
Return