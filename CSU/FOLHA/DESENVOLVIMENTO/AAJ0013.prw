user function aaj0013(cM,nD,nV)

if nD < 5 .and. nD > 0 .and. cM == "01"
	nP  := nV/nD      
	nD  := 5
	nV  := nP*5
endif

RETURN({nD,nV})