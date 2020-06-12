#include "rwmake.ch"
#include "TOPCONN.ch"
#Include "Protheus.Ch"
#INCLUDE "MSOLE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCBDIR03   บAutor  ณEmerson Natali      บ Data ณ  09/21/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Etiquetas - Integracao com o WORD                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CIEE                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CBDIR04()

PRIVATE cWord    := OLE_CreateLink()
/*
PRIVATE cPath    := "M:\Protheus_Data\dirdoc\BDI\"
*/
PRIVATE cPath    := "C:\AP8\Protheus_Data\dirdoc\BDI\"
PRIVATE cArquivo := cPath+"ETIQUETA_CONTATO.DOT"

If (cWord < "0")
	Help(" ",1,"A9810004") //"MS-WORD nao encontrado nessa maquina !!"
	Return
Endif

OLE_SetProperty(cWord, oleWdVisible  ,.F. )

dbSelectArea("TMP1")
dbGotop()

If (cWord >= "0")
	OLE_CloseLink(cWord) //fecha o Link com o Word
	cWord:= OLE_CreateLink()
	OLE_NewFile( cWord,cArquivo)
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณFuncao que faz o Word aparecer na Area de Transferencia do Windows,     ณ
	//ณsendo que para habilitar/desabilitar e so colocar .T. ou .F.            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	OLE_SetProperty(cWord, oleWdVisible  ,.T. )
	OLE_SetProperty(cWord, oleWdPrintBack,.T. )
	nCont := 1
	Do While !EOF()

		Do Case
			Case marked(TMP1->OK)
				If Empty(TMP1->OK)
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณ -Funcao que atualiza as variaveis do Word. - Cabecalho da Carta ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					If nCont == 1
						OLE_SetDocumentVar(cWord, "c_nome"    , TMP1->NOME  )
						OLE_SetDocumentVar(cWord, "c_cargo"   , TMP1->CARGO  )
						OLE_SetDocumentVar(cWord, "c_entidade", TMP1->NOME1  )
						OLE_SetDocumentVar(cWord, "c_end"     , TMP1->ENDERECO  )
						OLE_SetDocumentVar(cWord, "c_bairro"  , "CENTRO"  )
						OLE_SetDocumentVar(cWord, "c_mun"     , "SAO PAULO"  )
						OLE_SetDocumentVar(cWord, "c_est"     , "SP"  )
						OLE_SetDocumentVar(cWord, "c_cep"     , "9999-999"  )
					Else
						c_nome		:= "c_nome" 	+ str(nCont,1)
						c_cargo		:= "c_cargo"	+ str(nCont,1)
						c_entidade	:= "c_entidade"	+ str(nCont,1)
						c_end		:= "c_end"		+ str(nCont,1)
						c_bairro	:= "c_bairro"	+ str(nCont,1)
						c_mun		:= "c_mun"		+ str(nCont,1)
						c_est		:= "c_est"		+ str(nCont,1)
						c_cep		:= "c_cep"		+ str(nCont,1)

						OLE_SetDocumentVar(cWord, c_nome    , TMP1->NOME  )
						OLE_SetDocumentVar(cWord, c_cargo   , TMP1->CARGO  )
						OLE_SetDocumentVar(cWord, c_entidade, TMP1->NOME1  )
						OLE_SetDocumentVar(cWord, c_end     , TMP1->ENDERECO  )
						OLE_SetDocumentVar(cWord, c_bairro  , "CENTRO"  )
						OLE_SetDocumentVar(cWord, c_mun     , "SAO PAULO"  )
						OLE_SetDocumentVar(cWord, c_est     , "SP"  )
						OLE_SetDocumentVar(cWord, c_cep     , "9999-999"  )
					EndIf
			    EndIf
			Case TMP1->OK == cMarca
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณ -Funcao que atualiza as variaveis do Word. - Cabecalho da Carta ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					If nCont == 1
						OLE_SetDocumentVar(cWord, "c_nome"    , TMP1->NOME  )
						OLE_SetDocumentVar(cWord, "c_cargo"   , TMP1->CARGO  )
						OLE_SetDocumentVar(cWord, "c_entidade", TMP1->NOME1  )
						OLE_SetDocumentVar(cWord, "c_end"     , TMP1->ENDERECO  )
						OLE_SetDocumentVar(cWord, "c_bairro"  , "CENTRO"  )
						OLE_SetDocumentVar(cWord, "c_mun"     , "SAO PAULO"  )
						OLE_SetDocumentVar(cWord, "c_est"     , "SP"  )
						OLE_SetDocumentVar(cWord, "c_cep"     , "9999-999"  )
					Else
						c_nome		:= "c_nome" 	+ str(nCont,1)
						c_cargo		:= "c_cargo"	+ str(nCont,1)
						c_entidade	:= "c_entidade"	+ str(nCont,1)
						c_end		:= "c_end"		+ str(nCont,1)
						c_bairro	:= "c_bairro"	+ str(nCont,1)
						c_mun		:= "c_mun"		+ str(nCont,1)
						c_est		:= "c_est"		+ str(nCont,1)
						c_cep		:= "c_cep"		+ str(nCont,1)

						OLE_SetDocumentVar(cWord, c_nome    , TMP1->NOME  )
						OLE_SetDocumentVar(cWord, c_cargo   , TMP1->CARGO  )
						OLE_SetDocumentVar(cWord, c_entidade, TMP1->NOME1  )
						OLE_SetDocumentVar(cWord, c_end     , TMP1->ENDERECO  )
						OLE_SetDocumentVar(cWord, c_bairro  , "CENTRO"  )
						OLE_SetDocumentVar(cWord, c_mun     , "SAO PAULO"  )
						OLE_SetDocumentVar(cWord, c_est     , "SP"  )
						OLE_SetDocumentVar(cWord, c_cep     , "9999-999"  )
					EndIf
		EndCase

		TMP1->(DBSkip())
		nCont++
	EndDo
EndIf

OLE_UpdateFields(cWord)

//OLE_PrintFile(cWord,,,,)

//OLE_CloseLink(cWord) //fecha o Link com o Word

Return