#include 'protheus.ch'
#include 'parmtype.ch'


// Permite a inclus�o de uma condicao adicional para a Query
// Esta condicao obrigatoriamente devera ser tratada em um AND ()
// para nao alterar as regras basicas da mesma.
/*
IF lFa060Qry
	cQueryADD := ExecBlock("FA060QRY",.F.,.F.,{cAgen060,cConta060})
	IF ValType(cQueryADD) == "C"
		cQuery += " AND (" + cQueryADD + ")"
		ENDIF
ENDIF
*/
user function FA060QRY()
Local aParam	:= {}
Local aRet		:= {}
Local cQueryADD := ""
Local cFiltro := 1 //Filtro para trazer somente titulos que ser�o enviado ao banco (Boleto)
//aAdd(aParam,{3,"Forma Recebimento" ,1,{"Boleto","Debito Conta"},50,"",.F.})
//		
//ParamBox(aParam,"Filtro - Par�metros",@aRet)
//cFiltro := aRet[1] //1- Boleto / 2- Debito Conta

//No Fonte Padr�o espera receber da variavel cQueryADD um CARACTER para acrescentar no AND da query
//no Else entra a configura��o inversa
If cFiltro == 1 
	cQueryADD := "E1_CLIENTE = (SELECT A1_COD FROM SA1010 WHERE E1_CLIENTE = A1_COD AND E1_LOJA = A1_LOJA AND A1_BLEMAIL  ='1')"
Else
	cQueryADD := "E1_CLIENTE = (SELECT A1_COD FROM SA1010 WHERE E1_CLIENTE = A1_COD AND E1_LOJA = A1_LOJA AND (A1_BLEMAIL  ='' OR A1_BLEMAIL  ='2'))"
EndIf
	
return(cQueryADD)