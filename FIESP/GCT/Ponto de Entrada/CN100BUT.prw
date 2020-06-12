
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCN100BUT  บAutor  ณTOTVS               บ Data ณ  08/23/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de Entrada para criar bota na Enchoice na tela de    บฑฑ
ฑฑบ          ณ Contratos. Abre Objeto da Pasta DOCUMENTO                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FIESP                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function CN100BUT

Local aButtons := {}

AAdd(aButtons,{ "clips", {|| u_FIGCTE02()  }, "Abre Objeto", "Abre Objeto" } )

Return(aButtons)

User Function FIGCTE02()

Local _nPosArq := ASCAN(aHeader6,{|x| alltrim(X[2]) == "CNK_XARQ"})
Local _cArq    := ""
Local _cDestino := Alltrim(GetNewPar("FI_CONTRATO","contratos\")) // Informa a pasta destino dos arquivos de contrato

oGetDad6:oBrowse:SetFocus()

_cArq 		:= alltrim(aCols6[oGetDad6:oBrowse:nAt,_nPosArq])
_cArqTmp	:= GetTempPath()+_cArq

__CopyFile(_cDestino+_cArq,_cArqTmp)

nRet := ShellExecute ("Open", _cArqTmp, "", "", 1)

If nRet <= 32
	Aviso("Atencao", "Documento "+_cArqTmp+"nao encontrado!" , { "OK" }, 1.5)
EndIf


Return(.T.)