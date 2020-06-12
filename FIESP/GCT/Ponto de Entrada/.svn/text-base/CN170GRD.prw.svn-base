
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CN170GRD  ºAutor  ³TOTVS               º Data ³  08/23/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada na Gravacao do Documento de Contratos     º±±
±±º          ³ Tratamento para copiar o arq.Anexo para a pasta CONTRATOS  º±±
±±º          ³ no servidor                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FIESP                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CN170GRD()

Local _cDestino := Alltrim(GetNewPar("FI_CONTRATO","\contratos\")) // Informa a pasta destino dos arquivos de contrato

IF !lIsDir( _cDestino )
	//Cria diretorio
	IF !MontaDir( _cDestino ) // Verifica se criou o diretorio
		Conout("GCT --> Erro na criação do diretorio "+_cDestino+". Consulte ADM do Sistema!")
		Return()
	ENDIF
ENDIF

_cArq	:= alltrim(CNK->CNK_XARQ)
For _nI := 1 to len(_cArq)
	_nPosBar := AT("\",_cArq)
	_cArq := substr(_cArq,_nPosBar+1,len(_cArq))
	If _nPosBar == 0
		exit
	EndIf
Next _nI

__CopyFile(alltrim(CNK->CNK_XARQ),"\contratos\"+_cArq)

RecLock("CNK",.F.)
CNK->CNK_XARQ := _cArq
MsUnLock()

Return