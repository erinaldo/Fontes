#include 'protheus.ch'
#include 'parmtype.ch'

user function IMP_AJUSTES()

RpcSetType(3)
RpcSetEnv( "01","01")

// Abre o arquivo
nHandle := FT_FUse("c:\temp\CLIENTE.csv" )
// Se houver erro de abertura abandona processamento
if nHandle = -1
	return
endif
// Posiciona na primeria linha
FT_FGoTop()
// Retorna o número de linhas do arquivo
nLast := FT_FLastRec()

cLine  := FT_FReadLn() //Primeira Linha Cabeçalho
FT_FSKIP()

While !FT_FEOF()
	cLine  := FT_FReadLn()
	// Retorna a linha corrente
	nRecno := FT_FRecno()
	// Retorna o recno da Linha

	cCod	:= subs(cLine,1,(at(";",cLine)-1))
	cLine	:= subs(cLine,(at(";",cLine)+1),500)

	cLoja	:= subs(cLine,1,(at(";",cLine)-1))
	cLine	:= subs(cLine,(at(";",cLine)+1),500)

	cNome	:= subs(cLine,1,(at(";",cLine)-1))
	cLine	:= subs(cLine,(at(";",cLine)+1),500)

	cReduz	:= subs(cLine,1,(at(";",cLine)-1))
	cLine	:= subs(cLine,(at(";",cLine)+1),500)

	cEnd	:= subs(cLine,1,(at(";",cLine)-1))
	cLine	:= subs(cLine,(at(";",cLine)+1),500)

	cCodMun	:= subs(cLine,1,(at(";",cLine)-1))
	cLine	:= subs(cLine,(at(";",cLine)+1),500)

	cMun	:= subs(cLine,1,(at(";",cLine)-1))
	cLine	:= subs(cLine,(at(";",cLine)+1),500)

	cBairro	:= subs(cLine,1,(at(";",cLine)-1))
	cLine	:= subs(cLine,(at(";",cLine)+1),500)

	cContat	:= subs(cLine,1,500)

	DbSelectArea("SA1")
	DbSetOrder(1)
	If DbSeek(xFilial("SA1")+ strzero(val(cCod),6) + cLoja)
	
		RecLock("SA1",.F.)
		SA1->A1_NOME 	:=	cNome
		SA1->A1_NREDUZ 	:=	cReduz
		SA1->A1_END		:=	cEnd
		SA1->A1_COD_MUN	:=	subs(cCodMun,3,10)
		SA1->A1_MUN		:=	cMun
		SA1->A1_BAIRRO	:=	cBairro
		SA1->A1_CONTATO	:=	cContat
		MsUnLock()
	EndIf

	// Pula para próxima linha
	FT_FSKIP()
End

// Fecha o Arquivo
FT_FUSE()

return