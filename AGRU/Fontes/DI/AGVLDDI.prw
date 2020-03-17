#include 'protheus.ch'
#include 'parmtype.ch'

//Programa de Validação do Layout
user function AGVLDDI(cArq)

//Local cArq := "C:\temp\IMPORTACAO\AGRU_0201SA-01688-19 - invoice 992019005680.TXT"
Local lVldLayout 	:= .T.
Local _lN02			:= .T.
Local _lN04			:= .T.
Local nHandle 		:= FT_FUSE (AllTrim(cArq))
Local aVldLay		:= {}
Local nPos
Local cObrig		:= "B|H|I|I18|I25|N02|N04|O07|O10|P|Q02|S02|W02|W|X|X04|X26|Z|"
Local aObrig		:= {"H","I","I18","I25","N02","N04","P","Q02","S02"} //{"H","I","I18","I25","N02","N04","O07","O10","P","Q02","S02"}

If nHandle < 0
	Alert("Não foi possível abrir o arquivo especificado.")
	Return
Endif

FT_FGOTOP()
cLinha := FT_FREADLN()
If !("NOTA FISCAL" $ cLinha) 
	If !("NOTAFISCAL" $ cLinha)
		Alert ("Arquivo não é de nota fiscal!")
		Return
	Endif
EndIf
FT_FSKIP()
While !FT_FEOF()
	cLinha :=	FT_FREADLN()
	If !(Substr(cLinha,1,at("|",cLinha)-1) $ cObrig)
		FT_FSKIP()
	Else
		nPos := ascan(aVldLay, { |x| AllTrim(UPPER(x[1])) == Substr(cLinha,1,at("|",cLinha)-1)})
		If nPos == 0
			aadd(aVldLay, {Substr(cLinha,1,at("|",cLinha)-1),1})
		Else
			aVldLay[nPos,2] := aVldLay[nPos,2] + 1 
		EndIf
		FT_FSKIP()
	EndIf
EndDo

asort(aVldLay,,,{| x,y | x[1] < y[1] })

_nItem_H := 0

For _nI:=1 to Len(aObrig) //{"H","I","I18","I25","N02","N04","P","Q02","S02"}

	nPos2 := ascan(aVldLay, { |x| AllTrim(UPPER(x[1])) == aObrig[_nI] })
	
	If nPos2 > 0 //Encontrou o H (referente ao Item)
		_nItem_H := iif(aObrig[_nI]=="H", aVldLay[nPos2,2], _nItem_H)
		
		If _nItem_H <> aVldLay[nPos2,2]
			//Não achou Item erro no Layout
			lVldLayout := .F.
		EndIf
	Else
		If aObrig[_nI]=="N02"
			_lN02 := .F.
		ElseIf aObrig[_nI]=="N04"
			_lN04 := .F.
		Else
			//Não achou Item erro no Layout
			lVldLayout := .F.
		EndIf
	EndIf
	
Next _nI

If !(lVldLayout) .or. !(_lN02 .or. _lN04)
	lVldLayout := .F.
EndIf

FT_FUSE()
	
return(lVldLayout)