User Function vali_SZ2()
            
dbselectarea("SZ2")
dbsetorder(1)        
dbseek(xfilial()+Alltrim(M->C5_CLIENTE)+AllTrim(M->C5_LOJACLI))  

Xval:=M->C5_LOJACLI

IF !Found()
	MsgAlert("Endereço não cadastrado no Complemento do cadastro de clientes!")
Endif 

Return xVal