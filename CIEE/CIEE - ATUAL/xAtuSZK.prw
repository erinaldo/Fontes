# include "rwmake.ch"
# include "Topconn.ch"
# include "PROTHEUS.CH"

User Function xAtuSZK()

FT_FUSE("\1TOTVS\emailSZK.TXT")
FT_FGOTOP()
ProcRegua(FT_FLASTREC())

While !FT_FEOF()

	_cNumCart	:= ""
	_cCC1		:= ""

	IncProc("Processando Leitura do Arquivo Texto...")
	cBuffer		:= Alltrim(FT_FREADLN())
	_cNumCart	:=	Substr(cBuffer,1,(At(";",cBuffer)-1))

	cBuffer		:=	Substr(cBuffer,(At(";",cBuffer)+1),500)
	_cCC1		:=	Alltrim(cBuffer)

	DbSelectArea("SZK")
	DbSetOrder(4)
	If DbSeek(xFilial("SZK")+"00"+_cNumCart)
		RecLock("SZK",.F.)
		SZK->ZK_E_CC2	:= alltrim(SZK->ZK_E_CC2) + iif(!Empty(alltrim(SZK->ZK_E_CC1)),";" +alltrim(SZK->ZK_E_CC1),"")
		SZK->ZK_E_CC1	:= alltrim(_cCC1)
		MsUnLock()
	EndIf

	FT_FSKIP()
EndDo
	
FT_FUSE()

Return