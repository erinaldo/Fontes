#INCLUDE "rwmake.ch"
#include "_FixSX.ch"
#DEFINE _EOL CHR(13) + CHR(10)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CESTM02   º Autor ³ Andy Pudja         º Data ³  14/05/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Programa para fazer acerto de registros em SD3,            º±±
±±º          ³ gerando registro unico para os egistros de mesmo           º±±
±±º          ³ codigo de produto com a mesma numeracao de documento       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ Nenhum.                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³ Nenhum.                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CIEE                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CESTM02()

_cMsg:= "Esta Rotina acerta registros de Requisicoes Internas   " + _EOL;
       +"(SD3), incluindo um registro de Soma e excluindo  os   " + _EOL;
       +"registros somados, ou seja registros possuem o mesmo   " + _EOL;       
       +"codigo de produto (D3_COD) no mesmo Documento (D3_DOC)." 
       
MsgBox(OemToAnsi(_cMsg), "Aviso", "ALERT")

_cMsg := "Deseja prosseguir com a Rotina?"

If !MsgYesNo(_cMsg)
	Return
Endif

cPerg := "ESTM02    "
_aSX1 := {;
{cPerg,"01","Data de            ?"," "," ","mv_ch1","D",8,0,0,"G","","mv_par01","","","","dDatabase","","","","","","","","","","","","","","","","","","","","","","",""},;
{cPerg,"02","Data Ate           ?"," "," ","mv_ch2","D",8,0,0,"G","","mv_par02","","","","dDatabase","","","","","","","","","","","","","","","","","","","","","","",""}}
AjustaSX1(_aSX1) // _FixSX.ch

// Se o usuario nao confirmar, nao processar.
If !Pergunte(cPerg, .T.)                     
	Return
Else
	_cMsg := "Processando o arquivo de SD3..."
	Processa({|| U_Tira_Dupli()}, _cMsg)
	
EndIf

User Function Tira_Dupli()

dbSelectArea("SD3")
dbSetOrder(2)
ProcRegua(RecCount())
dbGoTop()
Do While !Eof()
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Incrementa a regua                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IncProc()
	
	If SD3->D3_CF <> "RE0"
		dbSkip()
		Loop
	EndIf
	
	_cD3_DOC := SD3->D3_DOC
	_aMatriz := {}
	_nRegOri := SD3->(RecNo())
	Do While !Eof().And.  _cD3_DOC == SD3->D3_DOC
		
		If SD3->D3_CF <> "RE0" .Or. SD3->D3_EMISSAO < MV_PAR01 .Or. SD3->D3_EMISSAO > MV_PAR02
			dbSkip()
			Loop
		EndIf
		_nPos := aScan( _aMatriz,{|x| AllTrim(x[1]) == AllTrim(SD3->D3_COD)	})
		If _nPos == 0
			aAdd(_aMatriz,{SD3->D3_COD,SD3->D3_QUANT, SD3->D3_CUSTO1, SD3->(RecNo())})
		Else
			_aMatriz[_nPos,2]:=_aMatriz[_nPos,2]+SD3->D3_QUANT
			_aMatriz[_nPos,3]:=_aMatriz[_nPos,3]+SD3->D3_CUSTO1
		EndIf
		dbSkip()
		
	EndDo
	
	dbGoto(_nRegOri)
	
	Do While !Eof() .And. _cD3_DOC == SD3->D3_DOC
		
		If D3_CF <> "RE0"
			dbSkip()
			Loop
		EndIf
		
		_nPos := aScan( _aMatriz,{|x| AllTrim(x[1]) == AllTrim(SD3->D3_COD)	})
		
		If _nPos <> 0 .And. _aMatriz[_nPos,2]<> SD3->D3_QUANT .And. _aMatriz[_nPos,2]<> -1
			
			
			_cCampo:={}
			_cVal  :={}
			
			RecLock("SD3",.F.)
			For _nConta := 1 To Fcount()
				AADD(_cCampo, FieldName(_nConta) )
				AADD(_cVal,FieldGet(FieldPos(FieldName(_nConta))) )
			Next                          

			SD3->D3_USUARIO  := "CESTM02"
//			msgstop("Vou Deletar Documento: "+SD3->D3_DOC+", Produto: "+SD3->D3_COD+" Com Qtd: "+STR(SD3->D3_QUANT,14,2)+" Com Custo: "+STR(SD3->D3_CUSTO1,14,2))
			
			_nQtdAux          := _aMatriz[_nPos,2]
			_nCusto1          := _aMatriz[_nPos,3]
			_aMatriz[_nPos,2]:= -1
			
			dbDelete()
			MsUnlock()
			
			_nRegOri := SD3->(RecNo())
			
			RecLock("SD3",.T.)
			For _nConta := 1 To Fcount()
				_nPos2	:= FieldPos(_cCampo[_nConta])
				FieldPut(_nPos2,_cVal[_nConta])
			Next
			
//			msgstop("Vou Incluir Documento: "+SD3->D3_DOC+", Produto: "+SD3->D3_COD+" Com qtd: "+STR(_nQtdAux,14,2)+" Com Custo: "+STR(_nCusto1,14,2))
			
			SD3->D3_FILIAL   := xFilial("SD3")
			SD3->D3_QUANT    := _nQtdAux
			SD3->D3_CUSTO1   := _nCusto1
			SD3->D3_CUSTO3   := -1
			SD3->D3_USUARIO  := "CESTM02"
			MsUnlock()
			
			dbGoto(_nRegOri)
			
		ElseIf _nPos <> 0 .And. _aMatriz[_nPos,2]<> SD3->D3_QUANT .And. _aMatriz[_nPos,2] == -1
			If SD3->D3_CUSTO3   == -1
				
				RecLock("SD3",.F.)
//				msgstop("Vou Mudar CUSTO2: "+SD3->D3_DOC+", Produto: "+SD3->D3_COD+" Com qtd: "+STR(SD3->D3_QUANT,14,2)+" Com Custo: "+STR(SD3->D3_CUSTO1,14,2))
				SD3->D3_CUSTO3   := 0
    			SD3->D3_USUARIO  := "CESTM02"				
				MsUnlock()
			Else
				
				RecLock("SD3",.F.)
//				msgstop("Vou Deletar Documento: "+SD3->D3_DOC+", Produto: "+SD3->D3_COD+" Com qtd: "+STR(SD3->D3_QUANT,14,2)+" Com Custo: "+STR(SD3->D3_CUSTO1,14,2))
    			SD3->D3_USUARIO  := "CESTM02"
				dbDelete()
				MsUnlock()
			EndIf
		EndIf
		
		dbSkip()
	EndDo
	
EndDo

Return


