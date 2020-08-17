#INCLUDE "rwmake.ch" 
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณATUGPCM   บ Autor ณ ADALBERTO ALTHOFF  บ Data ณ  18/02/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado para atender a OS 0515/06                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function Atugpcm
Processa({|lEnd| AtugpcmProcessa(),"OS 0515/06"})

STATIC FUNCTION AtugpcmProcessa()
ProcRegua( 2100 )
	
_cQuery := "SELECT RD_FILIAL,RD_MAT,SUM(RD_VALOR) AS MEDIAL FROM SRD050 "
_cQuery += "WHERE RD_PD = '509' AND RD_DATPGT BETWEEN '20050700' AND '20051299' AND D_E_L_E_T_ <> '*' "
_cQuery += "GROUP BY RD_FILIAL,RD_MAT "


If Select("MEDIAL") >0
	DBSelectArea("MEDIAL")
	DBCloseArea()
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณExecuta a Queryณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

IncProc("Selecionando Medial...")

TCQUERY _cQuery NEW ALIAS "MEDIAL"



_cQuery := "SELECT RD_FILIAL,RD_MAT,SUM(RD_VALOR) AS UNIMED FROM SRD050 "
_cQuery += "WHERE RD_PD = '509' AND RD_DATPGT BETWEEN '20050100' AND '20050699' AND D_E_L_E_T_ <> '*' "
_cQuery += "GROUP BY RD_FILIAL,RD_MAT "

If Select("UNIMED") >0
	DBSelectArea("UNIMED")
	DBCloseArea()
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณExecuta a Queryณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

IncProc("Selecionando Unimed...")

TCQUERY _cQuery NEW ALIAS "UNIMED"


// varre RCS deletando tudo. no primeiro, guarda dados principais
dbSelectArea("RCS")
dbSetOrder(1)
dbGoTop()
lprim := .t.
IncProc("Limpando dados...")
do while !eof()
	if lprim .and. RCS_VERBA $ '509/650'
		aCampos := {}
		AADD(aCampos,{RCS_TIPOFJ,RCS_CPFBEN,RCS_CODRET,RCS_ANO,RCS_NOME,RCS_CPFCGC,RCS_TIPORE})
		lprim := .f.
		reclock("RCS")
		dbdelete()    
		msUnlock()   
		dbskip()
		loop
	endif
	if RCS_VERBA $ '509/650'	
		reclock("RCS")
		dbdelete()       
		msUnlock()
		dbskip()
	ELSE
		dbskip()	
	endif      
enddo		

// varre unimed criando verbas 509 no RCS

dbSelectArea("UNIMED")
dbGoTop()
Do While !eof()
	IncProc("Criando Unimed...")
	cCpf := fAcha("SRA",UNIMED->RD_FILIAL+UNIMED->RD_MAT,1,"RA_CIC")
	dbselectarea("RCS")
	reclock("RCS",.t.)
	RCS_FILIAL  := UNIMED->RD_FILIAL
	RCS_MAT     := UNIMED->RD_MAT
	RCS_TIPOFJ  := aCampos[1,1]
	RCS_CPFBEN  := cCpf
	RCS_CODRET  := aCampos[1,3]
	RCS_ANO     := aCampos[1,4]
	RCS_NOME    := aCampos[1,5]
	RCS_CPFCGC  := aCampos[1,6]
	RCS_VERBA   := "509"
	RCS_TIPORE  := aCampos[1,7]
	RCS_DESCRI  := "UNIMED"
	RCS_VALOR   := UNIMED->UNIMED
	MsUnLock()
	dbSelectArea("UNIMED")
	dbSkip()
enddo	

// varre medial criando verbas 650 no RCS

dbSelectArea("MEDIAL")
dbGoTop()
Do While !eof()
	IncProc("Criando Medial...")
	cCpf := fAcha("SRA",MEDIAL->RD_FILIAL+MEDIAL->RD_MAT,1,"RA_CIC")
	dbselectarea("RCS")
	reclock("RCS",.t.)
	RCS_FILIAL  := MEDIAL->RD_FILIAL
	RCS_MAT     := MEDIAL->RD_MAT
	RCS_TIPOFJ  := aCampos[1,1]
	RCS_CPFBEN  := cCpf
	RCS_CODRET  := aCampos[1,3]
	RCS_ANO     := aCampos[1,4]
	RCS_NOME    := aCampos[1,5]
	RCS_CPFCGC  := aCampos[1,6]
	RCS_VERBA   := "650"
	RCS_TIPORE  := aCampos[1,7]
	RCS_DESCRI  := "MEDIAL"
	RCS_VALOR   := MEDIAL->MEDIAL
	MsUnLock()
	dbSelectArea("MEDIAL")
	dbSkip()
enddo



Return
