#include "rwmake.ch"
#include "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ATU_SB1   º Autor ³ Antonio Cordeiro   º Data ³  OUT/2009   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Programa atualiza cadastro de produtos a partir de tabela  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SHARK                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ATU_CT5()

Processa({|| RunCont() },"Processando...")
Return()

Static Function Runcont()

_cArq:='CT5.DBF'
If !File('\TEMP\'+_cArq)
	msgbox("Não existe a tabela de origem: \TEMP\"+_cArq)
Else
	if MSGYESNO('Arquivo localizado !!  confirmar processamento')
		DBUseArea(.T.,"DBFCDX","\TEMP\"+_cArq,"T_CT5",.F.,.F.)
		DBSELECTAREA('T_CT5')
		DBGOTOP()
		ProcRegua(Reccount())
		X:=1
		WHILE ! EOF()
			IncProc('Processando Produto: '+T_CT5->COD)
		        _cCod:=T_CT5->COD
			_cSeq:=STRZERO(VAL(T_CT5->SEQ),3)
			DBSELECTAREA('CT5')
			DBSETORDER(1)
			IF DBSEEK(XFILIAL('CT5')+_cCod+_cSeq)
				RECLOCK('CT5',.F.)
				CT5->CT5_X_DESC:=T_CT5->GRUPO
				MSUNLOCK('CT5')
			ENDIF
            DBSELECTAREA('T_CT5')
            DBSKIP()
            X+=1
        ENDDO
    ENDIF
ENDIF             
RETURN()
