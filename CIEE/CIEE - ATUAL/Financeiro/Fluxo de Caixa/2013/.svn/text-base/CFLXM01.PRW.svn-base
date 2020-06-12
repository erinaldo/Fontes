#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
/*
+---------------+--------------------+---------+----------------------+--------+-----------------+
| Programa  	| CFLXM01     		 | Autor   |  AF Custom           | Data   |    05/2013      |
+---------------+--------------------+---------+----------------------+--------+-- --------------+
| Descricao 	| Baca Fluxo de Caixa  C0IEE                                                     |
+---------------+--------------------------------------------------------------------------------+
| Uso          	| CIEE                      							 	                     |
+---------------+--------------------------------------------------------------------------------+
*/


User Function CFLXM01()

MsgStop("Rotina Vai Executar Atualização do campo CT1->CT1_NATURE!")

While CT1->(!Eof())
    If !Empty(CT1->CT1_NATURE)     
		CT1->(RecLock("CT1",.F.))
	   		CT1->CT1_NATURE := U_DePaNat2013(ALLTRIM(CT1->CT1_NATURE))
		CT1->(MsUnlock())
    EndIf
	CT1->(dbSkip())
EndDo    

MsgStop("Finalizada!")

Return
/*
dbSelectArea("SED")
SED->(dbSetOrder(1))
SED->(dbGoTop())

While SED->(!Eof())  /// Tomar cuidado que está mexendo com campo chave, mudando a ordem, ficou apenas mais lento... e a lõgica permite, caso contrário teria de fazer de outra maneira
	
	
	If !Empty(SED->ED_CODIGO) .And. (Len(AllTrim(SED->ED_CODIGO)) == 1 .Or. Len(AllTrim(SED->ED_CODIGO)) == 3 .Or. Len(AllTrim(SED->ED_CODIGO)) == 5 .Or. Len(AllTrim(SED->ED_CODIGO)) == 7)
		cCodigo := "0" + AllTrim(SED->ED_CODIGO)
		RecLock("SED",.F.)
		SED->ED_CODIGO:=cCodigo
		msUnlock()
	EndIf
	If !Empty(SED->ED_SUPORC) .And. ( Len(AllTrim(SED->ED_SUPORC)) == 3 .Or. Len(AllTrim(SED->ED_SUPORC)) == 5 )
		If Len(AllTrim(SED->ED_SUPORC)) == 3
			cCodAnt := SubStr(AllTrim(SED->ED_SUPORC),1,1)+"."+SubStr(AllTrim(SED->ED_SUPORC),2,2)
		Else
			cCodAnt := SubStr(AllTrim(SED->ED_SUPORC),1,1)+"."+SubStr(AllTrim(SED->ED_SUPORC),2,2)+"."+SubStr(AllTrim(SED->ED_SUPORC),4,2)
		EndIf
		RecLock("SED",.F.)
		SED->ED_SUPORC:=cCodAnt
		msUnlock()
	EndIf
	
	SED->(dbSkip())
	
EndDo

Return




/*
User Function CFLXM01()

Local aRet			:= {}
Local _cArqTrab 	:= "\DATA\SED010.DBF"
Local _cIndex    	:= CriaTrab(nil, .F.)
dbUseArea(.T., "DBFCDX", _cArqTrab, "TMP", .F., .F.)
TMP->(dbGoTop())

While TMP->(!Eof())

RecLock("TMP",.F.)
TMP->ED_CODIGO:=StrTran(TMP->ED_CODIGO, ".", "")
msUnlock()

TMP->(dbSkip())

EndDo

IndRegua("TMP", _cIndex, "ED_CODIGO",,, "Criando indice...", .T.)

dbSelectArea("SED")
SED->(dbSetOrder(1))
SED->(dbGoTop())

While SED->(!Eof())

If TMP->(dbSeek(SED->ED_SUPORC))
RecLock("SED",.F.)
SED->ED_FECHA 	:= TMP->ED_FECHA
SED->ED_FECHA_B := TMP->ED_FECHA_B
msUnlock()
EndIf

SED->(dbSkip())

EndDo

Return
