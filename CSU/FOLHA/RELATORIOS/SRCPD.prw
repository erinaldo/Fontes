#Include "Rwmake.ch"

User Function SRCPD()

Local   aRegs := {}
Private cPerg := "SRCPD"

AADD(aRegs,{cPerg,"01","Informe Diretorio(S/ Arquivo):","","","mv_ch1","C",70,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","DIR","","","","",""})

U_ValidPerg(cPerg, aRegs)

If !Pergunte( cPerg, .t. )
   Return
EndIf

Processa( { || OkProc() }, "Executando o Processamento..." )

Return

Static Function OkProc()

Local cSelekt, cQryCpos, nCntView
Local aCampos := {}
Local nConta  := 0

//=> Criacao do DBF com os dados básicos:

AADD(aCampos,{"RC_FILIAL"  ,"C",002,0})
AADD(aCampos,{"RC_MAT"     ,"C",006,0})
AADD(aCampos,{"RA_NOME"    ,"C",TamSX3('RA_NOME')[1],0})
AADD(aCampos,{"RA_SALARIO" ,"N",TamSX3('RA_SALARIO')[1],TamSX3('RA_SALARIO')[2]})
AADD(aCampos,{"RA_ADMISSA" ,"D",008,0})
AADD(aCampos,{"RA_DEMISSA" ,"D",008,0})
AADD(aCampos,{"RC_SITFOLH" ,"C",TamSX3('RA_SITFOLH')[1],0})

//=> Query para gerar o restante dos campos do DBF com todos os nomes de colunas atraves de todas as verbas:

cQryCpos := " SELECT DISTINCT RC_PD "
cQryCpos += " FROM SRC050 "
cQryCpos += " WHERE D_E_L_E_T_ = ' ' "

U_MontaView( cQryCpos, "cQryCpos" )

cQryCpos->( DbGoTop() )

While !cQryCpos->( Eof() )

	AADD(aCampos,{ "V"+cQryCpos->RC_PD ,"N",TamSX3('RC_VALOR')[1],TamSX3('RC_VALOR')[2]})

	cQryCpos->( DbSkip() )

EndDo

//DbCreate("\WORKFLOW\FUNCIONA.DBF",aCampos,"DBFCDX")
//DbUseArea(.t.,"DBFCDX","\WORKFLOW\FUNCIONA.DBF","SRASRC",.t.,.f.)
cArquivo := U_CriaTMP( aCampos, 'SRASRC' )
//cArquivo := U_CriaTmp(aCampos,'SRASRC',"DBFCDX")

// => Query para todos os funcionarios que constam no SRC:

cSelekt := " SELECT	SRC.RC_FILIAL, SRC.RC_MAT, SRA.RA_NOME, SRA.RA_SALARIO, SRC.RC_CC, SRA.RA_ADMISSA, SRA.RA_DEMISSA, RA_SITFOLH "
cSelekt += " FROM SRC050 SRC, SRA050 SRA "
cSelekt += " WHERE  SRC.RC_FILIAL  = SRA.RA_FILIAL "
cSelekt += "    AND SRC.RC_MAT 	   = SRA.RA_MAT "
cSelekt += "    AND SRC.RC_FILIAL  >= '0 '	      AND SRC.RC_FILIAL	<= '99' "
cSelekt += "    AND SRC.RC_MAT	   >= '0     '	  AND SRC.RC_MAT	<= '999999' "
cSelekt += "    AND SRC.RC_CC	   >= '0        ' AND SRC.RC_CC		<= '999999999' "
cSelekt += "    AND SRC.D_E_L_E_T_ =  ' ' "
cSelekt += "    AND SRA.D_E_L_E_T_ =  ' ' "
cSelekt += " GROUP BY SRC.RC_FILIAL, SRC.RC_MAT, SRA.RA_NOME, SRA.RA_SALARIO, SRC.RC_CC , SRA.RA_ADMISSA, SRA.RA_DEMISSA, RA_SITFOLH "
cSelekt += " ORDER BY SRC.RC_FILIAL, SRC.RC_MAT, SRA.RA_NOME, SRC.RC_CC "

// => Query para um determinado funcionario:

nCntView := U_MontaView( cSelekt, "QryMestre" )

ProcRegua( nCntView )

QryMestre->( DbGoTop() )

While !QryMestre->( Eof() )

    nConta ++

    IncProc( "Processando "+AllTrim(Str(nConta))+" - De: "+AllTrim(Str(nCntView)) )

    SRASRC->( RecLock( 'SRASRC',.t. ) )
	SRASRC->RC_FILIAL  := QryMestre->RC_FILIAL
	SRASRC->RC_MAT     := QryMestre->RC_MAT
	SRASRC->RA_NOME    := QryMestre->RA_NOME
	SRASRC->RA_SALARIO := QryMestre->RA_SALARIO
	SRASRC->RA_ADMISSA := Stod(QryMestre->RA_ADMISSA)
	SRASRC->RA_DEMISSA := Stod(QryMestre->RA_DEMISSA)
	SRASRC->RC_SITFOLH := QryMestre->RA_SITFOLH

	cFunc := " SELECT RC_PD, RC_VALOR "
	cFunc += " FROM SRC050 "
	cFunc += " WHERE RC_FILIAL  = '"+QryMestre->RC_FILIAL+"' "
	cFunc += " AND   RC_MAT     = '"+QryMestre->RC_MAT+"' "
	cFunc += " AND   D_E_L_E_T_ = ' ' "
	
	U_MontaView( cFunc, "cFunc" )
	
	cFunc->( DbGoTop() )

	While !cFunc->( Eof() )
	
        cCpoGrv := cFunc->RC_PD
        SRASRC->&( "V"+cCpoGrv ) := cFunc->RC_VALOR

		cFunc->( DbSkip() )

	EndDo

    SRASRC->( MsUnLock() )
	    
	QryMestre->( DbSkip() )

EndDo

SRASRC->( DbCloseArea() )

__CopyFile( GetSrvProfString("StartPath","")+cArquivo, AllTrim(MV_PAR01)+"Funcionarios.xls" )

Return