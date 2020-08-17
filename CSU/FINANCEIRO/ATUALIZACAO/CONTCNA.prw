User Function CONTCNA()

Local cCount

cCount := GETMV("MV_CNABCON")   
cCount ++

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Atualiza MV_cCount contador do CNAB bradesco                                        
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

PUTMV("MV_CNABCON", cCount) 
    
Return(cCount)