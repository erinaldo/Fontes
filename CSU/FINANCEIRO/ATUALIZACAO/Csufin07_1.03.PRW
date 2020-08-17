
// Execblock que tem a função de gerar o número dos Títulos a Pagar de forma 
// automática.
// Para a geração automatica do número dos titulos, será verificado o parametro 
// MV_NRAUTCP. O mesmo guarda a relação de Tipos de Titulos que devem ter geração
// automatica. Os Tipos de Titulos que não estivem relacionados neste parametro, não
// terão geração automatica. O número deverá ser digitado pelos usuarios.
// Data: 24/05/2002.    
// Ponto de Disparo: Gatilho disparado do campo E2_TIPO.
//
// 09/09/2004 - Alteracao para execucao multi-usuario - Ricardo - Dts

User Function CSUFIN07()

local _cTabela:="Z1"
static _cUltimo
if _cUltimo<>nil.and.empty(m->e2_num)
   _cUltimo:=""
endif   
     
_cArINI := GetArea()
_lOk    := .f.
_cNum   := ""

DbSelectArea("SX6")
DbSetOrder(1)
DbSeek( xFilial()+"MV_NRAUTCP",.F.)

If Found()
	If M->E2_TIPO $ AllTrim(SX6->X6_CONTEUD)
		_lOk := .t.
	EndIf		
Else
	MsgAlert("Não encontrado o parâmetro MV_NRAUTCP, específico CSU, o mesmo deve conter a relação dos Tipo de Títulos que terão a geração do número de forma automática !!!","Atencao!")
EndIf	

If _lOk = .t.  
    
	DbSelectArea("SE2")

	_cAreaE2 := GetArea()
	_cTipoE2 := M->E2_TIPO
	_lMudou:=.t.

    if _cUltimo<>nil.and._cUltimo==_cTipoE2
       _lMudou:=.f.
    endif      
	
	_cUltimo:=_cTipoE2
	if _lMudou
	
       // Primeiro tenta determinar o proximo numero da sequencia
       // pela tabela especifica
       _vAmbSx5:=sx5->(getarea())
       sx5->(dbsetorder(1)) // X5_FILIAL+X5_TABELA+X5_CHAVE
       if sx5->(dbseek(xfilial()+_cTabela+_cTipoE2,.f.).and.reclock(alias(),.f.))
          _cNum:=padl(alltrim(sx5->x5_descri),6,"0")
          sx5->x5_descri:=soma1(_cNum)
          sx5->(msunlock())
       else
	
          DbSetOrder(14)
          DbSeek( xFilial()+_cTipoE2+"999999",.T. )

          DbSkip(-1)

          If SE2->E2_TIPO = _cTipoE2
             _cNum := StrZero(Val(SE2->E2_NUM)+1,6)
          Else 
             _cNum := "000001"
          EndIf

          RestArea(_cAreaE2)

          u_CriaTab(_cTabela,"SEQUENCIA PARA TITULO A PAGAR POR TIPO",_cTipoE2,_cNum)
       endif   
    else
       _cNum:=m->e2_num
    endif   
EndIf	

RestArea(_cArINI)

Return _cNum