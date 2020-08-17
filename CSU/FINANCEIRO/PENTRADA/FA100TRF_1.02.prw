//LIMITA AS TRANSFERENCIAS BANCARIAS SOMENTE A UMA EMPRESA - CSU
#include "rwmake.ch"

User Function FA100TRF()

DO CASE
	CASE PROCNAME(2) == "FA100TRAN"
		IF ALLTRIM(SM0->M0_CODIGO) == "05"
			_bRet := .T.
		Else
			Alert("As Transferencias bancarias so podem ser realizadas na empresa 05 - CSU!!!!!")
			_bRet := .F.
			
		EndIf
	CASE PROCNAME(2) =="FA100EST"
		//ALTERADO POR RRM - CONFORME SOLICITACAO OS.3541/05
		IF  SE5->E5_DATA <> DDATABASE
			
			Aviso("Operacao invalida","Altere a data base para "+Dtoc(SE5->E5_DATA),{"Ok"} ,1,"Nao pode cancelar a Transferencia")
			_bRet := .F.
			
		ELSE
			_bRet := .T.
			
		ENDIF
		
	OTHERWISE
		_bRet := .T.
ENDCASE

Return(_bret)
