#INCLUDE "PROTHEUS.CH"

USER FUNCTION DIGAGEN()
Local nX 			:= 0
Local nY 			:= 0
Local aDigAg		:={ }
Local nDigVerif	:= 0
Local cDVAg		:=''
Local cAgn		:= substr(SRA->RA_BcDepSa,4,(Len(SRA->RA_BcDepSa)-3))
Local nPos		:= Len(cAgn)
Local nFMult		:= 2
                                                                   
	For nX := 1 To Len(cAgn)
		   aADD(aDigAg,substr(cAgn,nX,1))
	Next nX
	
	For nY:= 5  To 1  Step -1
		 nDigVerif += Val(aDigAg[nY]) * nFMult
		 nFMult++
	Next nY   
	
	nDigVerif	:= (nDigVerif / 11)-11  
	
	If nDigVerif <= 0 .OR. nDigVerif == 1
		nDigVerif:=0
	EndIf
	
RETURN(nDigVerif)