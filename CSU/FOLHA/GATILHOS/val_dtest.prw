User Function val_dtest()                  

valida:=.t.

IF !Empty(M->RA_DTCONCL)
 IF M->RA_CATFUNC $"E*G" .AND. M->RA_VCTEXP2 >= M->RA_DTCONCL
    MsgAlert("Data de Prorrogacao de Estagio esta maior que a Data de Conclusao do Curso!!!!")
	valida:=.f.
 Endif
Endif 
	
Return valida