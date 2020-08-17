#include "topconn.ch"
#include "rwmake.ch"

User Function Compet(MV_PAR01)

CPERG   := PADR("COPETE",LEN(SX1->X1_GRUPO))
_cKind  := 'EMPRESA + CLIENTE'

validperg()

If !Pergunte(cPerg,.T.)
	
	Return
	
Endif

Processa({ ||Prep_Dados() } )

Processa({ ||Proc_Ini() } )

Return

Static Function Proc_Ini()  

_Prep2Temp()

//EMPRESA CARDSYSTEM - PARA OS REGISTRO QUE ESTAO DENTRO DA COMPETENCIA
DBSelectArea("TRD2")
ProcRegua (Reccount())

While !EOF()
	IncProc("Analisando")
	
	_cQuery := " SELECT R_E_C_N_O_ AS REC,* FROM SC6020 WHERE D_E_L_E_T_ <> '*' "
	_cQuery += " AND C6_NOTA = '"+TRD2->C5_NOTA+"'AND C6_SERIE ='"+TRD2->C5_SERIE+"'"
	
	If Select("TRD5") >0
		DBSelectArea("TRD5")
		DBCloseArea()
	EndIf
	
	TCQUERY _cQuery NEW ALIAS "TRD5"
	
	DbSelectArea ("SE1")
	DbSetOrder (01)
	
	If	DbSeek (XFilial("SE1")+"02 "+TRD2->C5_NOTA+" "+"NF ")
		
		RecLock("CSUTMPFAT",.T.)
		CSUTMPFAT->EMPRESA	:="02 CARDSYSTEM "
		CSUTMPFAT->CLIENTE	:=SE1->E1_NOMCLI
		CSUTMPFAT->EMISSAO	:=SE1->E1_EMISSAO
		CSUTMPFAT->DTVENCTO:=SE1->E1_VENCREA
		CSUTMPFAT->VALOR	:=SE1->E1_VALOR
		CSUTMPFAT->DTPAGTO	:=SE1->E1_BAIXA
		CSUTMPFAT->VRPG  	:=IIF(SE1->E1_VALLIQ=0,SE1->E1_VALLIQ,(SE1->E1_VALLIQ-SE1->E1_ACRESC)+SE1->E1_IRRF+SE1->E1_INSS+SE1->E1_ISS+SE1->E1_DECRESC)      
		CSUTMPFAT->SALDO	:=IIF(SE1->E1_VALLIQ=0,SE1->E1_VALOR,(SE1->E1_VALOR+SE1->E1_ACRESC)-(SE1->E1_VALLIQ+SE1->E1_IRRF+SE1->E1_INSS+SE1->E1_ISS+SE1->E1_DECRESC))
		CSUTMPFAT->INSS	:=SE1->E1_INSS
		CSUTMPFAT->NF		:=SE1->E1_NUM
		DBSelectArea("TRD5")
		
		IF !EMPTY(TRD5->C6_DESCRI) .AND. !EMPTY(TRD5->C6_DESCOMP)
			CSUTMPFAT->SERVICO:=ALLTRIM(TRD5->C6_DESCRI)+"-"+ALLTRIM(TRD5->C6_DESCOMP)
		ELSE
			IF !EMPTY(TRD5->C6_DESCRI)
				CSUTMPFAT->SERVICO:=ALLTRIM(TRD5->C6_DESCRI)
			ENDIF
			
			IF !EMPTY(TRD5->C6_DESCOMP)
				CSUTMPFAT->SERVICO:=ALLTRIM(TRD5->C6_DESCOMP)
			ENDIF
		ENDIF
		
		MsUnLock()
		
	Endif    
	
	DBSelectArea("TRD2")
	DBSkip()  

EndDo   

//EMPRESA CARDSYSTEM - PARA OS REGISTRO QUE ESTAO FORA DA COMPETENCIA
DBSelectArea("TRD8")
ProcRegua (Reccount())

While !EOF()
	IncProc("Analisando")
	
	_cQuery := " SELECT R_E_C_N_O_ AS REC,* FROM SC6020 WHERE D_E_L_E_T_ <> '*' "
	_cQuery += " AND C6_NOTA = '"+TRD8->C5_NOTA+"'AND C6_SERIE ='"+TRD8->C5_SERIE+"'"
	
	If Select("TRD51") >0
		DBSelectArea("TRD51")
		DBCloseArea()
	EndIf
	
	TCQUERY _cQuery NEW ALIAS "TRD51"
	
	DbSelectArea ("SE1")
	DbSetOrder (01)
	
	If	DbSeek (XFilial("SE1")+"02 "+TRD8->C5_NOTA+" "+"NF ")
		
		RecLock("CSUTMPFAT",.T.)
		CSUTMPFAT->EMPRESA	:="99 OUTROS"
		CSUTMPFAT->CLIENTE	:=SE1->E1_NOMCLI
		CSUTMPFAT->EMISSAO	:=SE1->E1_EMISSAO
		CSUTMPFAT->DTVENCTO	:=SE1->E1_VENCREA
		CSUTMPFAT->VALOR		:=SE1->E1_VALOR
		CSUTMPFAT->DTPAGTO	:=SE1->E1_BAIXA
		CSUTMPFAT->VRPG  		:=IIF(SE1->E1_VALLIQ=0,SE1->E1_VALLIQ,(SE1->E1_VALLIQ-SE1->E1_ACRESC)+SE1->E1_IRRF+SE1->E1_INSS+SE1->E1_ISS+SE1->E1_DECRESC)      
		CSUTMPFAT->SALDO		:=IIF(SE1->E1_VALLIQ=0,SE1->E1_VALOR,(SE1->E1_VALOR+SE1->E1_ACRESC)-(SE1->E1_VALLIQ+SE1->E1_IRRF+SE1->E1_INSS+SE1->E1_ISS+SE1->E1_DECRESC))
		CSUTMPFAT->INSS		:=SE1->E1_INSS
		CSUTMPFAT->NF			:=SE1->E1_NUM
		DBSelectArea("TRD51")
		
		IF !EMPTY(TRD51->C6_DESCRI) .AND. !EMPTY(TRD51->C6_DESCOMP)
			CSUTMPFAT->SERVICO:=ALLTRIM(TRD51->C6_DESCRI)+"-"+ALLTRIM(TRD51->C6_DESCOMP)
		ELSE
			IF !EMPTY(TRD51->C6_DESCRI)
				CSUTMPFAT->SERVICO:=ALLTRIM(TRD51->C6_DESCRI)
			ENDIF
			
			IF !EMPTY(TRD51->C6_DESCOMP)
				CSUTMPFAT->SERVICO:=ALLTRIM(TRD51->C6_DESCOMP)
			ENDIF
		ENDIF
		
		MsUnLock()
		
	Endif    
	
	DBSelectArea("TRD8")
	DBSkip()  

EndDo   
	 

//EMPRESA CREDIT&rISK

DBSelectArea("TRD3")
ProcRegua (Reccount())

While !EOF()
	IncProc("Analisando")
	
	_cQuery := " SELECT R_E_C_N_O_ AS REC,* FROM SC6030 WHERE D_E_L_E_T_ <> '*' "
	_cQuery += " AND C6_NOTA = '"+TRD3->C5_NOTA+"'AND C6_SERIE ='"+TRD3->C5_SERIE+"'"
	
	If Select("TRD6") >0
		DBSelectArea("TRD6")
		DBCloseArea()
	EndIf
	
	TCQUERY _cQuery NEW ALIAS "TRD6"
	
	DbSelectArea ("SE1")
	DbSetOrder (01)
	
	If	DbSeek (XFilial("SE1")+"03 "+TRD3->C5_NOTA+" "+"NF ")
		
		RecLock("CSUTMPFAT",.T.)
		CSUTMPFAT->EMPRESA	:="03 TELESYSTEM "
		CSUTMPFAT->CLIENTE	:=SE1->E1_NOMCLI
		CSUTMPFAT->EMISSAO	:=SE1->E1_EMISSAO
		CSUTMPFAT->DTVENCTO	:=SE1->E1_VENCREA
		CSUTMPFAT->VALOR	:=SE1->E1_VALOR
		CSUTMPFAT->DTPAGTO	:=SE1->E1_BAIXA
		CSUTMPFAT->VRPG  	:=IIF(SE1->E1_VALLIQ=0,SE1->E1_VALLIQ,SE1->E1_VALLIQ+SE1->E1_IRRF+SE1->E1_INSS+SE1->E1_ISS)
		CSUTMPFAT->SALDO	:=IIF(SE1->E1_VALLIQ=0,SE1->E1_VALOR,(SE1->E1_VALOR+SE1->E1_ACRESC)-(SE1->E1_VALLIQ+SE1->E1_IRRF+SE1->E1_INSS+SE1->E1_ISS+SE1->E1_DECRESC))
		CSUTMPFAT->INSS		:=SE1->E1_INSS
		CSUTMPFAT->NF		:=SE1->E1_NUM
		DBSelectArea("TRD6")
		
		IF !EMPTY(TRD6->C6_DESCRI) .AND. !EMPTY(TRD6->C6_DESCOMP)
			CSUTMPFAT->SERVICO:=ALLTRIM(TRD6->C6_DESCRI)+"-"+ALLTRIM(TRD6->C6_DESCOMP)
		ELSE
			IF !EMPTY(TRD6->C6_DESCRI)
				CSUTMPFAT->SERVICO:=ALLTRIM(TRD6->C6_DESCRI)
			ENDIF
			
			IF !EMPTY(TRD6->C6_DESCOMP)
				CSUTMPFAT->SERVICO:=ALLTRIM(TRD6->C6_DESCOMP)
			ENDIF
		ENDIF
		
		MsUnLock()
		
	Endif
	
	DBSelectArea("TRD3")
	DBSkip()
EndDo   


//EMPRESA CREDIT&rISK - PARA OS REGISTRO QUE ESTAO FORA DA COMPETENCIA     

DBSelectArea("TRD9")
ProcRegua (Reccount())

While !EOF()
	IncProc("Analisando")
	
	_cQuery := " SELECT R_E_C_N_O_ AS REC,* FROM SC6020 WHERE D_E_L_E_T_ <> '*' "
	_cQuery += " AND C6_NOTA = '"+TRD9->C5_NOTA+"'AND C6_SERIE ='"+TRD9->C5_SERIE+"'"
	
	If Select("TRD61") >0
		DBSelectArea("TRD61")
		DBCloseArea()
	EndIf
	
	TCQUERY _cQuery NEW ALIAS "TRD61"
	
	DbSelectArea ("SE1")
	DbSetOrder (01)
	
	If	DbSeek (XFilial("SE1")+"02 "+TRD9->C5_NOTA+" "+"NF ")
		
		RecLock("CSUTMPFAT",.T.)
		CSUTMPFAT->EMPRESA	:="99 OUTROS"
		CSUTMPFAT->CLIENTE	:=SE1->E1_NOMCLI
		CSUTMPFAT->EMISSAO	:=SE1->E1_EMISSAO
		CSUTMPFAT->DTVENCTO	:=SE1->E1_VENCREA
		CSUTMPFAT->VALOR		:=SE1->E1_VALOR
		CSUTMPFAT->DTPAGTO	:=SE1->E1_BAIXA
		CSUTMPFAT->VRPG  		:=IIF(SE1->E1_VALLIQ=0,SE1->E1_VALLIQ,(SE1->E1_VALLIQ-SE1->E1_ACRESC)+SE1->E1_IRRF+SE1->E1_INSS+SE1->E1_ISS+SE1->E1_DECRESC)      
		CSUTMPFAT->SALDO		:=IIF(SE1->E1_VALLIQ=0,SE1->E1_VALOR,(SE1->E1_VALOR+SE1->E1_ACRESC)-(SE1->E1_VALLIQ+SE1->E1_IRRF+SE1->E1_INSS+SE1->E1_ISS+SE1->E1_DECRESC))
		CSUTMPFAT->INSS		:=SE1->E1_INSS
		CSUTMPFAT->NF			:=SE1->E1_NUM
		DBSelectArea("TRD61")
		
		IF !EMPTY(TRD61->C6_DESCRI) .AND. !EMPTY(TRD61->C6_DESCOMP)
			CSUTMPFAT->SERVICO:=ALLTRIM(TRD61->C6_DESCRI)+"-"+ALLTRIM(TRD61->C6_DESCOMP)
		ELSE
			IF !EMPTY(TRD61->C6_DESCRI)
				CSUTMPFAT->SERVICO:=ALLTRIM(TRD61->C6_DESCRI)
			ENDIF
			
			IF !EMPTY(TRD61->C6_DESCOMP)
				CSUTMPFAT->SERVICO:=ALLTRIM(TRD61->C6_DESCOMP)
			ENDIF
		ENDIF
		
		MsUnLock()
		
	Endif    
	
	DBSelectArea("TRD9")
	DBSkip()  

EndDo   

//EMPRESA TELESYSTEM

DBSelectArea("TRD4")
ProcRegua (Reccount())

While !EOF()
	IncProc("Analisando")
	
	_cQuery := " SELECT R_E_C_N_O_ AS REC,* FROM SC6040 WHERE D_E_L_E_T_ <> '*' "
	_cQuery += " AND C6_NOTA = '"+TRD4->C5_NOTA+"'AND C6_SERIE ='"+TRD4->C5_SERIE+"'"
	
	If Select("TRD7") >0
		DBSelectArea("TRD7")
		DBCloseArea()
	EndIf
	
	TCQUERY _cQuery NEW ALIAS "TRD7"
	
	DbSelectArea ("SE1")
	DbSetOrder (01)
	
	If	DbSeek (XFilial("SE1")+"04 "+TRD4->C5_NOTA+" "+"NF ")
		
		RecLock("CSUTMPFAT",.T.)
		CSUTMPFAT->EMPRESA	:="04 CREDIT&RISK"
		CSUTMPFAT->CLIENTE	:=SE1->E1_NOMCLI
		CSUTMPFAT->EMISSAO	:=SE1->E1_EMISSAO
		CSUTMPFAT->DTVENCTO	:=SE1->E1_VENCREA
		CSUTMPFAT->VALOR		:=SE1->E1_VALOR
		CSUTMPFAT->DTPAGTO	:=SE1->E1_BAIXA
		CSUTMPFAT->VRPG  		:=IIF(SE1->E1_VALLIQ=0,SE1->E1_VALLIQ,SE1->E1_VALLIQ+SE1->E1_IRRF+SE1->E1_INSS+SE1->E1_ISS) 
		CSUTMPFAT->SALDO		:=IIF(SE1->E1_VALLIQ=0,SE1->E1_VALOR,(SE1->E1_VALOR+SE1->E1_ACRESC)-(SE1->E1_VALLIQ+SE1->E1_IRRF+SE1->E1_INSS+SE1->E1_ISS+SE1->E1_DECRESC))
		CSUTMPFAT->INSS		:=SE1->E1_INSS
		CSUTMPFAT->NF			:=SE1->E1_NUM
		DBSelectArea("TRD7")
		
		IF !EMPTY(TRD7->C6_DESCRI) .AND. !EMPTY(TRD7->C6_DESCOMP)
			CSUTMPFAT->SERVICO:=ALLTRIM(TRD7->C6_DESCRI)+"-"+ALLTRIM(TRD7->C6_DESCOMP)
		ELSE
			IF !EMPTY(TRD7->C6_DESCRI)
				CSUTMPFAT->SERVICO:=ALLTRIM(TRD7->C6_DESCRI)
			ENDIF
			
			IF !EMPTY(TRD7->C6_DESCOMP)
				CSUTMPFAT->SERVICO:=ALLTRIM(TRD7->C6_DESCOMP)
			ENDIF
		ENDIF
		
		MsUnLock()
		
	Endif
	
	DBSelectArea("TRD4")
	DBSkip()
	
EndDo

//EMPRESA TELESYSTEM - PARA OS REGISTRO QUE ESTAO FORA DA COMPETENCIA
DBSelectArea("TRD10")
ProcRegua (Reccount())

While !EOF()
	IncProc("Analisando")
	
	_cQuery := " SELECT R_E_C_N_O_ AS REC,* FROM SC6020 WHERE D_E_L_E_T_ <> '*' "
	_cQuery += " AND C6_NOTA = '"+TRD10->C5_NOTA+"'AND C6_SERIE ='"+TRD10->C5_SERIE+"'"
	
	If Select("TRD71") >0
		DBSelectArea("TRD71")
		DBCloseArea()
	EndIf
	
	TCQUERY _cQuery NEW ALIAS "TRD71"
	
	DbSelectArea ("SE1")
	DbSetOrder (01)
	
	If	DbSeek (XFilial("SE1")+"02 "+TRD10->C5_NOTA+" "+"NF ")            
		
		RecLock("CSUTMPFAT",.T.)
		CSUTMPFAT->EMPRESA	:="99 OUTROS"
		CSUTMPFAT->CLIENTE	:=SE1->E1_NOMCLI
		CSUTMPFAT->EMISSAO	:=SE1->E1_EMISSAO
		CSUTMPFAT->DTVENCTO	:=SE1->E1_VENCREA
		CSUTMPFAT->VALOR		:=SE1->E1_VALOR
		CSUTMPFAT->DTPAGTO	:=SE1->E1_BAIXA
		CSUTMPFAT->VRPG  		:=IIF(SE1->E1_VALLIQ=0,SE1->E1_VALLIQ,(SE1->E1_VALLIQ-SE1->E1_ACRESC)+SE1->E1_IRRF+SE1->E1_INSS+SE1->E1_ISS+SE1->E1_DECRESC)      
		CSUTMPFAT->SALDO		:=IIF(SE1->E1_VALLIQ=0,SE1->E1_VALOR,(SE1->E1_VALOR+SE1->E1_ACRESC)-(SE1->E1_VALLIQ+SE1->E1_IRRF+SE1->E1_INSS+SE1->E1_ISS+SE1->E1_DECRESC))
		CSUTMPFAT->INSS		:=SE1->E1_INSS
		CSUTMPFAT->NF			:=SE1->E1_NUM
		DBSelectArea("TRD71")
		
		IF !EMPTY(TRD71->C6_DESCRI) .AND. !EMPTY(TRD71->C6_DESCOMP)
			CSUTMPFAT->SERVICO:=ALLTRIM(TRD71->C6_DESCRI)+"-"+ALLTRIM(TRD71->C6_DESCOMP)
		ELSE
			IF !EMPTY(TRD71->C6_DESCRI)
				CSUTMPFAT->SERVICO:=ALLTRIM(TRD71->C6_DESCRI)
			ENDIF
			
			IF !EMPTY(TRD71->C6_DESCOMP)
				CSUTMPFAT->SERVICO:=ALLTRIM(TRD71->C6_DESCOMP)
			ENDIF
		ENDIF
		
		MsUnLock()
		
	Endif    
	
	DBSelectArea("TRD10")
	DBSkip()  

EndDo  

// Impressao do relatório
                                      
CallCrys ("COMPET",,"01;0;1;COMPET") 

DBCloseArea()   

Return

//PREPARA DADOS SC5 DE TODAS AS EMPRESAS
Static Function Prep_Dados()

ProcRegua(3)

//Empresa CSUCARSYSTEM

_cQuery := " SELECT R_E_C_N_O_ AS REC,* FROM SC5020 WHERE D_E_L_E_T_ <> '*' "
_cQuery += " AND C5_COMPETE IN ('"+MV_PAR01+"') AND C5_NOTA<>''"
_cQuery += " ORDER BY C5_NOTA "

If Select("TRD2") >0
	DBSelectArea("TRD2")
	DBCloseArea()
EndIf

IncProc("Obtendo Dados ")
TCQUERY _cQuery NEW ALIAS "TRD2"

DBSelectArea("TRD2")
dbGoTop()  


  // EMPRESA CARDSYSTEM - Query para selecionar OUTROS.   
	_cQuery := "SELECT R_E_C_N_O_ AS REC, * FROM SC5020 WHERE D_E_L_E_T_ <> '*'"
	_cQuery += "AND C5_EMISSAO>='"+DTOS(MV_PAR02)+"'AND C5_EMISSAO<='"+DTOS(MV_PAR03)+"' AND C5_COMPETE NOT IN('"+MV_PAR01+"')"   
    _cQuery += "AND C5_NOTA<>''"
   
   //Criacao de tabela temporaria para selecionar OUTROS.
   
	If Select("TRD8") >0
	DBSelectArea("TRD8")
	DBCloseArea()
	EndIf

	IncProc("Obtendo Dados ")
	TCQUERY _cQuery NEW ALIAS "TRD8"

	DBSelectArea("TRD8")
	dbGoTop()

//Empresa CREDIT&RISK

_cQuery := " SELECT R_E_C_N_O_ AS REC,* FROM SC5030 WHERE D_E_L_E_T_ <> '*' "
_cQuery += " AND C5_COMPETE = '"+MV_PAR01+"' AND C5_NOTA<>''"
_cQuery += " ORDER BY C5_NOTA "

If Select("TRD3") >0
	DBSelectArea("TRD3")
	DBCloseArea()
EndIf

IncProc("Obtendo Dados ")
TCQUERY _cQuery NEW ALIAS "TRD3"

DBSelectArea("TRD3")
dbGoTop() 

// EMPRESA CREDIT&RISK - Query para selecionar OUTROS.   
	_cQuery := "SELECT R_E_C_N_O_ AS REC, * FROM SC5030 WHERE D_E_L_E_T_ <> '*'"
	_cQuery += "AND C5_EMISSAO>='"+DTOS(MV_PAR02)+"'AND C5_EMISSAO<='"+DTOS(MV_PAR03)+"' AND C5_COMPETE<>'"+MV_PAR01+"'"   
    _cQuery += "AND C5_NOTA<>''"
   
   //Criacao de tabela temporaria para selecionar OUTROS.
   
	If Select("TRD9") >0
	DBSelectArea("TRD9")
	DBCloseArea()
	EndIf

	IncProc("Obtendo Dados ")
	TCQUERY _cQuery NEW ALIAS "TRD9"

	DBSelectArea("TRD9")
	dbGoTop()

//Empresa TELESYSTEM
_cQuery := " SELECT R_E_C_N_O_ AS REC,* FROM SC5040 WHERE D_E_L_E_T_ <> '*' "
_cQuery += " AND C5_COMPETE = '"+MV_PAR01+"' AND C5_NOTA<>''"
_cQuery += " ORDER BY C5_NOTA "

If Select("TRD4") >0
	DBSelectArea("TRD4")
	DBCloseArea()
EndIf

IncProc("Obtendo Dados ")
TCQUERY _cQuery NEW ALIAS "TRD4"

DBSelectArea("TRD4")
dbGoTop()     
 
// EMPRESA TELESYSTEM - Query para selecionar OUTROS.   
	_cQuery := "SELECT R_E_C_N_O_ AS REC, * FROM SC5040 WHERE D_E_L_E_T_ <> '*'"
	_cQuery += "AND C5_EMISSAO>='"+DTOS(MV_PAR02)+"'AND C5_EMISSAO<='"+DTOS(MV_PAR03)+"' AND C5_COMPETE<>'"+MV_PAR01+"'"   
    _cQuery += "AND C5_NOTA<>''"
   
   //Criacao de tabela temporaria para selecionar OUTROS.
   
	If Select("TRD10") >0
	DBSelectArea("TRD10")
	DBCloseArea()
	EndIf

	IncProc("Obtendo Dados ")
	TCQUERY _cQuery NEW ALIAS "TRD10"

	DBSelectArea("TRD10")
	dbGoTop()

Return()
 

Static Function _Prep2Temp()

IF TCCanOpen("TMPFAT")
	TCDelFile("TMPFAT") 
Endif

_aCampos := {}

AADD(_aCampos,{"EMPRESA"     ,"C", 020 , 0	})  
AADD(_aCampos,{"CLIENTE"     ,"C", 020 , 0	})  
AADD(_aCampos,{"SERVICO"     ,"C", 210 , 0	})
AADD(_aCampos,{"EMISSAO"     ,"D", 008 , 0  })  
AADD(_aCampos,{"DTAPRES"     ,"D", 008 , 0	})  
AADD(_aCampos,{"DTVENCTO"    ,"D", 008 , 0	})  
AADD(_aCampos,{"VALOR"       ,"N", 015 , 2	})  
AADD(_aCampos,{"DTPAGTO"     ,"D", 008 , 0	})  
AADD(_aCampos,{"VRPG"        ,"N", 015 , 2	})  
AADD(_aCampos,{"SALDO"       ,"N", 015 , 2	})  
AADD(_aCampos,{"INSS"        ,"N", 015 , 2	})  
AADD(_aCampos,{"NF"          ,"C", 006 , 0	})  
AADD(_aCampos,{"STATUS"      ,"C", 040 , 0	})  

_cInd := CriaTrab(NIL,.F.)
_cArq := CriaTrab(NIL,.F.)

_cArq := "TMPFAT"

IF !TCCanOpen(_cArq)
	dbCreate(_cArq, _aCampos, "TOPCONN")
Endif

dbUseArea(.T., "TOPCONN", _cArq, "CSUTMPFAT", .T.)

IndRegua("CSUTMPFAT",_cInd,_cKind,,," Criando Indice    ")
DBSelectArea("CSUTMPFAT")
DBGotop()

Return


Static Function ValidPerg()

_sAlias := Alias()

dbSelectArea("SX1") // abre arquivo sx1 de perguntas
dbSetOrder(1)       // coloca na ordem 1 do sindex
cPerg := PADR(cPerg,LEN(SX1->X1_GRUPO)) 
aRegs:={}


// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
AADD(aRegs,{cPerg,"01"," Competência     ?","","","mv_ch1","C",30,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02"," Período de      ?","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03"," Até             ?","","","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)



Return
