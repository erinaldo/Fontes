User Function CONTCNA()

Local cCount

cCount := GETMV("MV_CNABCON")   
cCount ++

//��������������������������������������������������������������Ŀ
//� Atualiza MV_cCount contador do CNAB bradesco                                        
//��������������������������������������������������������������

PUTMV("MV_CNABCON", cCount) 
    
Return(cCount)