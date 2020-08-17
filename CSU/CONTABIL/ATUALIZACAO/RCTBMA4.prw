#Include "Protheus.ch"
#Include "TopConn.ch"   
#Include "Jpeg.ch"  
#Include "TbiConn.ch"    
#DEFINE c_BR Chr(13)+Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRCTBMA4   บAutor  ณVinํcius Greg๓rio                    บ Data ณ  20/01/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Tela de marcacao para estorno e exclusใo de rateios.                        บฑฑ
ฑฑบ          ณ                                                                             บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                                         บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RCTBMA4()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variแveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cPerg 		:= PADR("CTBMA4",Len(SX1->X1_GRUPO))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aCampos 		:= {}
Local aDescCpo		:= {}
Local aTamSX3		:= {}
Local nA 			:= 0
Local cArq 			:= ""
Local aRegs			:= {}
Private aInd  		:= {}
Private cMarca		:= ""
Private cCadastro	:= OemToAnsi("Estorno de Documentos de Entrada")
Private Qry 		:= GetNextAlias()

//VG - 2011.01.12 - Fun็ใo Visualizar desabilitada. A pr๓pria rotina de visualiza็ใo
//da MATA103, nesse caso, nใo permite a visualiza็ใo do documento jแ rateado.
/*Private aRotina 	:= {	{"Pesquisar",		'U_CTBMA4PE()'			,0,4},;
							{"Proc. Marcados",	'U_CTBMA4PR()'			,0,4},;
							{"Inverter Marca",	'U_CTBMA4IM()' 			,0,4},;							
							{"Visualizar",		'U_CTBMA4VI()'			,0,4},;
							{"Legenda",			'U_CTBMA4LEG()'			,0,4}}*/
							
Private aRotina 	:= {	{"Pesquisar",		'U_CTBMA4PE()'			,0,4},;
							{"Estorna Selec.",	'U_CTBMA4PR(.F.)'		,0,4},;
							{"Exclui Selec.",	'U_CTBMA4EX()' 			,0,4},;							
							{"Inverte Marca",	'U_CTBMA4IM()' 			,0,4},;
							{"Legenda",			'U_CTBMA4LEG()'			,0,4}}
							
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria os parametros da rotina                                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู   
//aAdd(aRegs,{cPerg,"01","Emissใo De"				,"","","mv_ch1","D",08,0,0,"G","","MV_PAR01","","","","", "","","","","","","","","","","","","","","","","","","","","","","","","" })
//aAdd(aRegs,{cPerg,"02","Emissใo At้"			,"","","mv_ch2","D",08,0,0,"G","","MV_PAR02","","","","", "","","","","","","","","","","","","","","","","","","","","","","","","" })
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVG - 2011.06.06 - Altera็ใo para filtrar pela data deณ
//ณdigita็ใo da nota.                                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aAdd(aRegs,{cPerg,"01","Digita็ใo De"			,"","","mv_ch1","D",08,0,0,"G","","MV_PAR01","","","","", "","","","","","","","","","","","","","","","","","","","","","","","","" })
aAdd(aRegs,{cPerg,"02","Digita็ใo At้"			,"","","mv_ch2","D",08,0,0,"G","","MV_PAR02","","","","", "","","","","","","","","","","","","","","","","","","","","","","","","" })
aAdd(aRegs,{cPerg,"03","Tabela Rateio De"		,"","","mv_ch3","C",06,0,0,"G","","MV_PAR03","","","","", "","","","","","","","","","","","","","","","","","","","","ZB7COD","","","","" })
aAdd(aRegs,{cPerg,"04","Tabela Rateio At้"		,"","","mv_ch4","C",06,0,0,"G","","MV_PAR04","","","","", "","","","","","","","","","","","","","","","","","","","","ZB7COD","","","","" }) 
aAdd(aRegs,{cPerg,"05","NF De" 					,"","","mv_ch5","C",09,0,0,"G","","MV_PAR05","","","","", "","","","","","","","","","","","","","","","","","","","","SF1","","","","" })
aAdd(aRegs,{cPerg,"06","NF At้"					,"","","mv_ch6","C",09,0,0,"G","","MV_PAR06","","","","", "","","","","","","","","","","","","","","","","","","","","SF1","","","","" })
aAdd(aRegs,{cPerg,"07","Serie De"				,"","","mv_ch7","C",03,0,0,"G","","MV_PAR07","","","","", "","","","","","","","","","","","","","","","","","","","","","","","","" })
aAdd(aRegs,{cPerg,"08","Serie At้"				,"","","mv_ch8","C",03,0,0,"G","","MV_PAR08","","","","", "","","","","","","","","","","","","","","","","","","","","","","","","" })

CriaSx1(aRegs)     
If !Pergunte(cPerg,.T.) 
	Return .F.
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta os campos do arquivo temporario para markbrowse ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู 
Aadd(aCampos, { "TMP_OK"    	,"C",02,0 })                        

aTamSX3 := TAMSX3("F1_FILIAL")
Aadd(aCampos, { "TMP_FILIAL"	,aTamSX3[3],aTamSX3[1],aTamSX3[2]})    

aTamSX3 := TAMSX3("F1_DOC")
Aadd(aCampos, { "TMP_DOC"		,aTamSX3[3],aTamSX3[1],aTamSX3[2]})

aTamSX3 := TAMSX3("F1_SERIE")
Aadd(aCampos, { "TMP_SERIE"		,aTamSX3[3],aTamSX3[1],aTamSX3[2]})

aTamSX3 := TAMSX3("F1_FORNECE")
Aadd(aCampos, { "TMP_FORNEC"	,aTamSX3[3],aTamSX3[1],aTamSX3[2]})

aTamSX3 := TAMSX3("F1_LOJA")
Aadd(aCampos, { "TMP_LOJA"		,aTamSX3[3],aTamSX3[1],aTamSX3[2]})

aTamSX3 := TAMSX3("A2_NREDUZ")
Aadd(aCampos, { "TMP_NREDUZ"	,aTamSX3[3],aTamSX3[1],aTamSX3[2]})

aTamSX3 := TAMSX3("ZB7_CODRAT")
Aadd(aCampos, { "TMP_CODRAT"	,aTamSX3[3],aTamSX3[1],aTamSX3[2]})    

aTamSX3 := TAMSX3("ZB7_DESCRI")
Aadd(aCampos, { "TMP_DESCRI"	,aTamSX3[3],aTamSX3[1],aTamSX3[2]})    

aTamSX3 := TAMSX3("F1_DUPL")
Aadd(aCampos, { "TMP_DUPL"		,aTamSX3[3],aTamSX3[1],aTamSX3[2]})

aTamSX3 := TAMSX3("F1_EMISSAO ")
Aadd(aCampos, { "TMP_EMISSA "	,aTamSX3[3],aTamSX3[1],aTamSX3[2]})    

aTamSX3 := TAMSX3("F1_DTDIGIT ")
Aadd(aCampos, { "TMP_DTDIGI "	,aTamSX3[3],aTamSX3[1],aTamSX3[2]})    

aTamSX3 := TAMSX3("ED_CODIGO")
Aadd(aCampos, { "TMP_NATURE"	,aTamSX3[3],aTamSX3[1],aTamSX3[2]})    

aTamSX3 := TAMSX3("ED_DESCRIC")
Aadd(aCampos, { "TMP_NATDES"	,aTamSX3[3],aTamSX3[1],aTamSX3[2]})    

Aadd(aCampos, { "TMP_MARCA"    	,"C",01,0 })//VG - campo que irแ permitir marcar ou nใo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta array com a descricao dos campos a serem exibidos ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aCpos := { {"TMP_OK"		,,""},; //"OK" 
	  	   {"TMP_FILIAL"	,,"Filial"},; //"Filial"	 
	  	   {"TMP_DOC"		,,"Documento"},; //"Documento"	 
	  	   {"TMP_SERIE"		,,"Serie"},; //"Serie"
   		   {"TMP_DUPL"		,,"Duplicata"},; //"Duplicata"
   	  	   {"TMP_FORNEC"	,,"Fornecedor"},; //"Forneceodr"
		   {"TMP_LOJA"		,,"Loja"},; //"Loja"
   		   {"TMP_NREDUZ"	,,"Nome"},; //"Nome"
   		   {"TMP_NATURE"	,,"Cod Natureza"},; //"Cod Natureza"
   		   {"TMP_NATDES"	,,"Nome Natureza"},; //"Descricao Natureza"
   		   {"TMP_CODRAT"	,,"Cod. Rateio"},; //"Nome"
   		   {"TMP_DESCRI"	,,"Descr. Rateio"},; //"Nome"
   		   {"TMP_DTDIGI"	,,"Digitacao"},;  //"Nome"     
   		   {"TMP_EMISSA"	,,"Emissao"} }  //"Nome" 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria o arquivo temporario								ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cArq := CriaTrab(aCampos,.T.)
dbUseArea(.T.,"DBFCDX",cArq,"TRB",.f.)
DbSelectArea("TRB")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria os indices temporarios								ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aInd	:= {}
Aadd(aInd,{CriaTrab(Nil,.F.),"TMP_FILIAL+TMP_DOC+TMP_SERIE+TMP_FORNEC+TMP_LOJA","Filial+Doc+Serie+Fornece+Loja"})

For nA := 1 to Len(aInd)
	IndRegua("TRB",aInd[nA,1],aInd[nA,2],,,OemToAnsi("Criando อndice Temporแrio...") )
Next nA
DbClearIndex()

For nA := 1 to Len(aInd)
	dbSetIndex(aInd[nA,1]+OrdBagExt())
Next nA

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Alimenta a variavel utilizada para marcacao           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cMarca := GetMark(,"TRB","TMP_OK")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Gera os dados temporarios 								ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Processa({|| GERAQRY()} ,"Gerando dados...")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Seta o arquivo                							ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DbSelectArea("TRB")
DbSetOrder(1)
dbGotop()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Executa o browse da rotina    							ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
MarkBrow("TRB","TMP_OK","TMP_MARCA=='N'",aCpos,,cMarca, "U_CTBMA4MT()",,,,"U_CTBMA4MC()",)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Apaga os arquivos temporarios 							ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Select("TRB") > 0
	DbSelectArea("TRB")
	TRB->(DbCloseArea())
//	MsgStop("Ae Mirian")
	FErase(cArq+GetDbExtension())
	For nA := 1 to Len(aInd)
		FErase(aInd[nA,1]+OrdBagExt())
	Next nA
Endif
   
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออหออออออออออออออออออออออออออออออออออออออหออออออหอออออออออออออปฑฑ
ฑฑบPrograma  ณGeraQry   บAutor  บEdival Alves Junior/Vinํcius Greg๓rio บ Data บ  07/01/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออสออออออออออออออออออออออออออออออออออออออสออออออสอออออออออออออนฑฑ
ฑฑบDescri…o ณ Processa a query do MarkBrowse.                                              บฑฑ
ฑฑบ          ณ                                                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ                                                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณCSU        		                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
                                                                    
Static Function GERAQRY()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variแveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local nTotRegs		:= 0
Local cQry			:= ""
Local nX			:= 0
Local nCountReg		:= 1

Local cDataDe 	:=	DtoS(MV_PAR01)
Local cDataAte	:= 	DtoS(MV_PAR02)
Local cRatDe	:= 	MV_PAR03
Local cRatAte	:= 	MV_PAR04
Local cNfDe 	:= 	MV_PAR05
Local cNfAte	:= 	MV_PAR06 
Local cSerieDe	:= 	MV_PAR07
Local cSerieAte	:= 	MV_PAR08
Local cBranco	:= ""

Local aIndisp	:= {}

Local cUltRev	:= ""
Local cAnoMes	:= ""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณQuery para pegar os Documentos de Entradaณ
//ณque ainda nใo foram processados.         ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//VG - 2011.03.03 - Removi a filial da query na SF1 a pedido da usuแria Mirian. As tabelas SEV e SED sใo compartilhadas.
BeginSql alias Qry

	SELECT F1_FILIAL, F1_DOC,F1_SERIE,F1_FORNECE,F1_LOJA,F1_DUPL,F1_EMISSAO, F1_DTDIGIT, EV_XCODRAT ZB7_CODRAT, ED_CODIGO, ED_DESCRIC 
	FROM %table:SF1% SF1(NOLOCK),%table:SEV% SEV(NOLOCK), %table:SED% SED(NOLOCK)
	WHERE F1_FILIAL >= ' '
		AND F1_DOC BETWEEN %Exp:cNfDe% AND %Exp:cNfAte%
		AND F1_SERIE BETWEEN %Exp:cSerieDe% AND %Exp:cSerieAte%
		AND F1_XPRORAT = '1'
		AND F1_DTDIGIT BETWEEN %Exp:cDataDe% AND %Exp:cDataAte%
		AND F1_DTLANC <> '        '
		AND SF1.%notDel%             
    	AND EV_FILIAL = %xfilial:SEV%
	    AND EV_NUM = F1_DOC 
    	AND EV_PREFIXO = F1_PREFIXO      
    	AND EV_CLIFOR = F1_FORNECE
    	AND EV_LOJA = F1_LOJA
    	AND EV_XCODRAT BETWEEN %Exp:cRatDe% AND %Exp:cRatAte%
	    AND SEV.%notDel%   
       	AND ED_FILIAL = %xfilial:SED%
	    AND ED_CODIGO = EV_NATUREZ
   	    AND SED.%notDel%   
	    		
EndSql                              

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Define a quantidade de registros a processar			ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
(Qry)->( DbEval( {|| nTotRegs++},,{ || !Eof()} ))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Alimenta o arquivo de trabalho                			ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DbSelectArea(Qry)
DbGoTop()
ProcRegua(nTotRegs)
While !Eof()
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Incrementa a regua de processanto            			ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	IncProc("Processando registro "+Alltrim(Str(nCountReg))+" de "+Alltrim(Str(nTotRegs))+".")
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Grava os registros na tabela temporaria      			ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	DbSelectArea("TRB")
	DbSetOrder(1)
	RecLock("TRB",.T.)
	
	TRB->TMP_FILIAL	:= (QRY)->F1_FILIAL
	TRB->TMP_OK		:= Space(02)//cMarca
	TRB->TMP_DOC		:= (QRY)->F1_DOC
	TRB->TMP_SERIE  	:= (QRY)->F1_SERIE
	TRB->TMP_FORNEC	:= (QRY)->F1_FORNECE
	TRB->TMP_LOJA 	:= (QRY)->F1_LOJA
	TRB->TMP_NREDUZ 	:= Posicione("SA2",1,xFilial("SA2")+(QRY)->F1_FORNECE+(QRY)->F1_LOJA,"A2_NREDUZ")
	TRB->TMP_CODRAT	:= (QRY)->ZB7_CODRAT
	TRB->TMP_DESCRI	:= Posicione("ZB7",1,xFilial("ZB7")+(QRY)->ZB7_CODRAT,"ZB7_DESCRI")
	TRB->TMP_DUPL	:= (QRY)->F1_DUPL
	TRB->TMP_EMISSA 	:= Stod((QRY)->F1_EMISSAO)
	TRB->TMP_DTDIGI 	:= Stod((QRY)->F1_DTDIGIT)
	TRB->TMP_NATURE	:= (QRY)->ED_CODIGO
	TRB->TMP_NATDES 	:= (QRY)->ED_DESCRIC
	TRB->TMP_MARCA	:= Space(01)
    
	MsUnlock()
	
	nCountReg++
	
	DbSelectArea(QRY)
	DbSkip()
	
Enddo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณBuscar os lan็amentos contแbeis relativos เ nota.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("TRB")
dbSetOrder(1)//TMP_FILIAL+TMP_DOC+TMP_SERIE+TMP_FORNEC+TMP_LOJA
dbGoTop()

Do While !EOF()

	If Empty(TRB->TMP_CODRAT)
		If aScan(aIndisp,TRB->(TMP_FILIAL+TMP_DOC+TMP_SERIE+TMP_FORNEC+TMP_LOJA)) == 0
			aAdd(aIndisp,TRB->(TMP_FILIAL+TMP_DOC+TMP_SERIE+TMP_FORNEC+TMP_LOJA))     
		Endif
	Endif
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVG - 2011.01.14 - Verificar se o c๓digo de rateioณ
	//ณtem uma revisใo ativa vแlida para o perํodo.     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	//cAnoMes	:= SUBSTR(DTOS(TRB->TMP_EMISSA),1,6)
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVG - 2011.06.06 - Altera็ใo para pegarณ
	//ณo ano/m๊s da tabela de rateio com baseณ
	//ณna compet๊ncia da nota.               ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cAnoMes	:= U_GetCompetencia(TMP_FILIAL+TMP_DOC+TMP_SERIE+TMP_FORNEC+TMP_LOJA)
	cUltRev	:= U_RZB7ULTR(TRB->TMP_CODRAT,cAnoMes,.T.)

	If !Empty(Alltrim(cUltRev))
	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณVG - 2011.01.14 - Verificar se a tabelaณ
		//ณde rateio tem ZB8 atrelada.            ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		dbSelectArea("ZB8")
		dbSetOrder(1)
		dbSeek(xFilial("ZB8")+TRB->TMP_CODRAT+cAnoMes+cUltRev,.F.)
	
		If !Found()
			If aScan(aIndisp,TRB->(TMP_FILIAL+TMP_DOC+TMP_SERIE+TMP_FORNEC+TMP_LOJA)) == 0
				aAdd(aIndisp,TRB->(TMP_FILIAL+TMP_DOC+TMP_SERIE+TMP_FORNEC+TMP_LOJA))	     
			Endif	
		Endif

	Endif
     
	dbSelectArea("TRB")
	dbSkip()
EndDo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMarca como indisponํvel ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For nX	:= 1 to Len(aIndisp)

	dbSelectArea("TRB")
	dbSetOrder(1)//TMP_DOC+TMP_SERIE+TMP_FORNEC+TMP_LOJA
	If dbSeek(aIndisp[nX],.F.)

		Do while !EOF() .and. TRB->(TMP_FILIAL+TMP_DOC+TMP_SERIE+TMP_FORNEC+TMP_LOJA)==aIndisp[nX]

			RecLock("TRB",.F.)
			TRB->TMP_MARCA	:= 'N'
			MsUnlock()
			
			dbSelectArea("TRB")
			dbSkip()
			
		EndDo	
		
	Endif

Next nX

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a area do arquivo de execucao da query ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Select(QRY) > 0
	DbSelectArea(QRY)
	DbCloseArea()
Endif

Return(Nil)  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCTBMA4IM  บAutor  ณ Vinํcius Greg๓rio  บ Data ณ 11/01/2011  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณRotina para inverter a marca็ใo dos registros               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CTBMA4IM()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclaracao de variaveis                            		ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aArea		:= GetArea()
Local aAreaTMP	:= SF1->(GetArea())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณProcessa a marcacao                              		ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
CursorWait()                        

DbSelectArea("TRB")
DbGotop()

While !Eof()  
	
	If TRB->TMP_OK == ThisMark()//GetMark(,"SF1","TMP_OK") //ThisMark()
		Reclock("TRB",.F.)
		TRB->TMP_OK := Space(02)
		MsUnlock()
	Else                          
		Reclock("TRB",.F.)
		TRB->TMP_OK := ThisMark()//GetMark(,"SF1","TMP_OK") //ThisMark()
		MsUnlock()
	Endif
	
	TRB->(dbSkip())
	
EndDo

CursorArrow()

RestArea(aArea)
Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCTBMA4MT  บAutor  ณ Vinํcius Greg๓rio  บ Data ณ 11/01/2011  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณRotina para marcar todos os registros                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CTBMA4MT()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclaracao de variaveis                            		ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aArea		:= GetArea()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณProcessa a marcacao                              		ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
CursorWait()

DbSelectArea("TRB")
DbGoTop()

While !Eof()          

	If TRB->TMP_MARCA <> 'N'
		Reclock("TRB",.F.)
		TRB->TMP_OK := ThisMark()
		MsUnlock()
	Endif
	
	TRB->(dbSkip())
	
EndDo

CursorArrow()

RestArea(aArea)
Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCTBMA4MC  บAutor  ณ Vinํcius Greg๓rio  บ Data ณ 11/01/2011  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณRotina para marcar e desmarcar o registro corrente.         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ          ณA rotina deverแ marcar todos os registros do documento      บฑฑ
ฑฑบ          ณselecionado.                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CTBMA4MC()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variแveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aArea		:= GetArea()
Local cChave	:= TRB->(TMP_FILIAL+TMP_DOC+TMP_SERIE+TMP_FORNEC+TMP_LOJA)
Local nRecNo	:= TRB->(RecNo())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclaracao de variaveis                            		ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
CursorWait()       

dbSelectArea("TRB")
dbSetOrder(1)//TMP_FILIAL+TMP_DOC+TMP_SERIE+TMP_FORNEC+TMP_LOJA
dbGoTop()           

If dbSeek(cChave,.F.)

		Do while !EOF() .and. TRB->(TMP_FILIAL+TMP_DOC+TMP_SERIE+TMP_FORNEC+TMP_LOJA)==cChave
	 
			MarcaBrowse()
		     
			dbSelectArea("TRB")
			TRB->(dbSkip())
		EndDo                 
		
Endif

TRB->(dbGoTo(nRecNo))     

MarkBRefresh()

CursorArrow()                 

RestArea(aArea)
Return(Nil)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMarcaBrowseบAutor  ณVinํcius Greg๓rio   บ Data ณ  11/01/11   บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para marcar um registro no markBrowse                บฑฑ
ฑฑบ          ณ                                                             บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                         บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MarcaBrowse()

If TRB->TMP_OK == ThisMark()//cMarca //ThisMark()
	Reclock("TRB",.F.)
	TRB->TMP_OK := Space(02)
	MsUnlock()
Else                          
	Reclock("TRB",.F.)
	TRB->TMP_OK := ThisMark()//cMarca //ThisMark()
	MsUnlock()
Endif

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออัออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบ Programa    ณ CriaSx1  ณ Verifica e cria um novo grupo de perguntas com base nos      บฑฑ
ฑฑบ             ณ          ณ parโmetros fornecidos                                        บฑฑ
ฑฑฬอออออออออออออุออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Solicitante ณ 23.05.05 ณ Modelagem de Dados                                           บฑฑ
ฑฑฬอออออออออออออุออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Autor       ณ 28.04.04 ณ TI0607 - Almir Bandina                                       บฑฑ
ฑฑฬอออออออออออออุออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Produ็ใo    ณ 99.99.99 ณ Ignorado                                                     บฑฑ
ฑฑฬอออออออออออออุออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Parโmetros  ณ ExpA1 = array com o conte๚do do grupo de perguntas (SX1)                บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Retorno     ณ Nil                                                                     บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Observa็๕es ณ                                                                         บฑฑ
ฑฑบ             ณ                                                                         บฑฑ
ฑฑฬอออออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ Altera็๕es  ณ 99/99/99 - Consultor - Descricao da altera็ใo                           บฑฑ
ฑฑบ             ณ                                                                         บฑฑ
ฑฑศอออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CriaSx1(aRegs)

Local aAreaAtu	:= GetArea()
Local aAreaSX1	:= SX1->(GetArea())
Local nJ		:= 0
Local nY		:= 0

dbSelectArea("SX1")
dbSetOrder(1)

For nY := 1 To Len(aRegs)
	If !MsSeek(Padr(aRegs[nY,1],Len(SX1->X1_GRUPO))+aRegs[nY,2])
		RecLock("SX1",.T.)
		For nJ := 1 To FCount()
			If nJ <= Len(aRegs[nY])
				FieldPut(nJ,aRegs[nY,nJ])
			EndIf
		Next nJ
		MsUnlock()
	EndIf
Next nY

RestArea(aAreaSX1)
RestArea(aAreaAtu)
Return(Nil)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno    ณCTBMA4LEG     ณAutor  ณ Vinํcius Greg๓rio     ณ Data ณ 11/01/10 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณ Legenda.                                              		  ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณ                                                                ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ CSU                                                            ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CTBMA4LEG()

Local aLegenda := { 	{"BR_VERDE"		, "Docs Disponํveis para estorno/exclusใo" },;
						{"BR_VERMELHO"	, "Doc. Indisponํveis para estorno/exclusใo" }}

Local uRetorno := .T.

BrwLegenda(cCadastro,"Legenda",aLegenda)

Return uRetorno

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCTBMA4PE  บAutor  ณ Vinํcius Greg๓rio  บ Data ณ 11/01/2011  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณRotina para pesquisar um registro no arquivo temporแrio     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CTBMA4PE()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclaracao de variaveis                            		ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cCampo	:= Space(TamSX3("F1_FILIAL")[1]+TamSX3("F1_DOC")[1]+TamSX3("F1_SERIE")[1]+TamSX3("F1_FORNECE")[1]+TamSX3("F1_LOJA")[1])
Local aItens	:= {}
Local cCombo 	:= ""
Local lSeek		:= .F.
Local nOrd		:= TRB->(INDEXORD())
Local nX		:= 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMonta o combo com os itens a serem exibidos        		ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For nX := 1 to Len(aInd)
	If aInd[nX,3] <> Nil
		Aadd(aItens, aInd[nX,3])
	Endif
Next nX
cCombo 	:= aItens[nOrd]

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a tela de pesquisa ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
DEFINE MSDIALOG oDlg FROM 00,00 TO 100,490 PIXEL TITLE "Pesquisa"

@05,05 COMBOBOX oCBX VAR cCombo ITEMS aItens SIZE 206,36 PIXEL OF oDlg FONT oDlg:oFont
oCbx:bChange := {|| (nOrd := oCbx:nAt,cCampo := Space(TamSX3("F1_FILIAL")[1]+TamSX3("F1_DOC")[1]+TamSX3("F1_SERIE")[1]+TamSX3("F1_FORNECE")[1]+TamSX3("F1_LOJA")[1]) )}

@22,05 MSGET oPesqGet VAR cCampo SIZE 206,10 PIXEL

DEFINE SBUTTON FROM 05,215 TYPE 1 OF oDlg ENABLE ACTION (lSeek := .T.,oDlg:End())
DEFINE SBUTTON FROM 20,215 TYPE 2 OF oDlg ENABLE ACTION oDlg:End()

ACTIVATE MSDIALOG oDlg CENTERED

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Pesquisa o registro se clicado no botao Ok ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lSeek
	DbSelectArea("TRB")
	DbSetOrder(nOrd)
	DbSeek(Alltrim(cCampo),.T.)
Endif

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCTBMA4VI  บAutor  ณVinํcius Greg๓rio   บ Data ณ  12/01/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Visualiza o documento de entrada relativo ao registro.     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
/*User Function CTBMA4VI()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variแveisณ             
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู         
Local aArea	:= GetArea()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPosiciona na SF1ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("SF1")
dbSetOrder(1)//F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
If dbSeek(xFilial("SF1")+TRB->TMP_DOC+TRB->TMP_SERIE+TRB->TMP_FORNECE+TRB->TMP_LOJA,.F.)
	A103NFISCAL("SF1",SF1->(RecNo()),2)
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRetorna para o temporแrioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("TRB")

RestArea(aArea)
Return (.T.)*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCTBMA4PR  บAutor  ณV. Greg๓rio         บ Data ณ  11/01/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina que processa a contabiliza็ใo para as notas         บฑฑ
ฑฑบ          ณ selecionadas                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CTBMA4PR(lRev)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variแveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aArea		:= GetArea()
Local nLoop		:= 0
Local nLoop2	:= 0
Local nLoop3	:= 0
Local cChavSEV	:= ""  
                          
Local cLctoDeb	:= "RED"//Tabela de Rateio
Local cLctoCrd	:= "REC"//Centro de Custo Transit๓rio

Local cLote    	:= ALLTRIM(SuperGetMV("MV_XLOTRAT",,""))
Local cArquivo 	:= ''
Local nHdlPrv           

Local cAnoMes	:= ""
Local cUltRev	:= ""
Local nQtdCtb	:= 0
Local nTotal	:= 0

Local lView  	:= .F.
Local lAglu  	:= .F.   

Local aProc		:= {}
Local aCodRat	:= {}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณArray com as informa็๕es necessแrias paraณ
//ณos lan็amentos de D้bito:                ณ
//ณ                                         ณ
//ณ1- Natureza                              ณ
//ณ2- Centro de Custo                       ณ
//ณ3- Item                                  ณ
//ณ4- Classe de Valor                       ณ
//ณ5- Valor                                 ณ
//ณ6- Chave ZB7                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aLctoCrd	:= {}

Local nMenorSEV		:= 0
Local nMaiorSEV		:= 0
Local nPosMenorSEV	:= 0
Local nPosMaiorSEV	:= 0
Local nSomaSEV		:= 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVariแveis do LPณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private CXVARNAT	:= ""
Private CXCCTRAN	:= ""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVG - 2011.02.21ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private CXITTRAN	:= ""
Private CXCLTRAN	:= ""

Private CXCCDEB		:= ""
Private CXITDEB		:= ""
Private CXCLDEB		:= ""
Private CXVALOR		:= 0
Private CXVLCRD		:= 0

Private CXNOTENT	:= ""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerificar se o lan็amento padrใo existe.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !VerPadrao(cLctoDeb)
 	Aviso("Aten็ใo",OemToAnsi("Nใo localizado lan็amento padronizado "+cLctoDeb+". "),{"OK"})
 	Return
EndIf               

If !VerPadrao(cLctoCrd)
 	Aviso("Aten็ใo",OemToAnsi("Nใo localizado lan็amento padronizado "+cLctoCrd+". "),{"OK"})
 	Return
EndIf               

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPercorre a tabela temporแria gerando a   ณ
//ณcontabiliza็ใo dos documentos de entrada.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("TRB")
dbGoTop()

Do While !EOF()

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณGuardar as notas que serใo processadas.ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If !lRev
		If TRB->TMP_OK == ThisMark() .and. TRB->TMP_MARCA <> 'N'
			If aScan(aProc,TRB->(TMP_FILIAL+TMP_DOC+TMP_SERIE+TMP_FORNEC+TMP_LOJA))==0
				aAdd(aProc,TRB->(TMP_FILIAL+TMP_DOC+TMP_SERIE+TMP_FORNEC+TMP_LOJA))
			Endif	
		Endif	
	Else
		If aScan(aProc,TRB->(TMP_FILIAL+TMP_DOC+TMP_SERIE+TMP_FORNEC+TMP_LOJA))==0
			aAdd(aProc,TRB->(TMP_FILIAL+TMP_DOC+TMP_SERIE+TMP_FORNEC+TMP_LOJA))
		Endif	
	Endif
     
	dbSelectArea("TRB")
	dbSkip()
EndDo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRealiza a contabiliza็ใo das notas marcadas.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For nLoop	:= 1 to Len(aProc)

	lLancOk			:= 	.F.
	aCodRat			:= 	{}

	nTotal			:= 0
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPosicionar na SF1ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("SF1")
	dbSetOrder(1)//F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
	dbSeek(aProc[nLoop],.F.)
	
//	cAnoMes	:= SubStr(DTOS(SF1->F1_EMISSAO),1,6)
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVG - 2011.06.06 - Altera็ใo para pegarณ
	//ณo ano/m๊s da tabela de rateio com baseณ
	//ณna compet๊ncia da nota.               ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cAnoMes	:= U_GetCompetencia(aProc[nLoop])
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPosicionar na SA2ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("SA2")
	dbSetOrder(1)//A2_FILIAL+A2_COD+A2_LOJA
	dbSeek(xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,.F.)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPosicionar na SE2ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("SE2")
	dbSetOrder(6)//E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
	dbSeek(xFilial("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_PREFIXO+SF1->F1_DUPL,.F.)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPercorre a SEV gerando os lan็amentos.ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cChavSEV	:= RetChaveSEV("SE2")
	
	dbSelectArea("SEV")
	dbSetOrder(1)//EV_FILIAL+EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA+EV_NATUREZ
	dbGoTop()
//	dbSeek("  "+SUBSTR(cChavSEV,3,3)+SUBSTR(cChavSEV,6,9),.F.)		//Tatiana A. Barbosa - OS 0201/12 - 02/2012
	
	Do While !EOF() 
		If SEV->EV_PREFIXO==SUBSTR(cChavSEV,3,3) .and. SEV->EV_NUM==SUBSTR(cChavSEV,6,9) .and. SEV->EV_TIPO==SUBSTR(cChavSEV,18,3);		//Tatiana A. Barbosa - OS 0201/12 - 02/2012
				 .and. SEV->EV_CLIFOR==SUBSTR(cChavSEV,21,6) .and. SEV->EV_LOJA==SUBSTR(cChavSEV,27,2)			//SEV->(EV_FILIAL+EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA)==cChavSEV
	
		cUltRev	:= U_RZB7ULTR(SEV->EV_XCODRAT,cAnoMes,.T.)

		nPosMenorSEV	:=	0
		nPosMaiorSEV	:= 	0
		nMenorSEV		:= 	0
		nMaiorSEV		:=	0
		aLctoCrd		:= 	{}
		
		nSomaSEV		:= 	0
	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณPara cada SEV da nota,      ณ
		//ณgerar contabiliza็ใo para   ณ
		//ณa tabela de rateio relativa.ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		dbSelectArea("ZB7")
		dbSetOrder(1)//ZB7_FILIAL+ZB7_CODRAT+ZB7_ANOMES+ZB7_REVISA
		dbSeek(xFilial("ZB7")+SEV->EV_XCODRAT+cAnoMes+cUltRev,.F.)
		
		CXCCTRAN	:= ZB7->ZB7_CCTRAN
		CXITTRAN	:= ZB7->ZB7_ITTRAN
		CXCLTRAN	:= ZB7->ZB7_CLTRAN
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณVG - 2011.03.18ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู  
		CXNOTENT	:= SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO)

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณadiciona os c๓digos de rateio para marcar como processadosณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		aAdd(aCodRat,xFilial("ZB7")+SEV->EV_XCODRAT+cAnoMes+cUltRev)
		
		dbSelectArea("ZB8")
		dbSetOrder(1)//ZB8_FILIAL+ZB8_CODRAT+ZB8_ANOMES+ZB8_REVISA+ZB8_SEQUEN
		dbSeek(xFilial("ZB8")+SEV->EV_XCODRAT+cAnoMes+cUltRev,.F.)
		Do while !EOF() .and. ZB8->(ZB8_FILIAL+ZB8_CODRAT+ZB8_ANOMES+ZB8_REVISA) == xFilial("ZB8")+SEV->EV_XCODRAT+cAnoMes+cUltRev

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณDefinir as variแveis para o LPณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			aAdd(aLctoCrd,{SEV->EV_NATUREZ,;								//ณ1- Natureza                              ณ
						ZB8->ZB8_CCDBTO,;									//ณ2- Centro de Custo                       ณ
						ZB8->ZB8_ITDBTO,;									//ณ3- Item                                  ณ
						ZB8->ZB8_CLVLDB,;									//ณ4- Classe de Valor                       ณ
						Round(SEV->EV_VALOR*(ZB8->ZB8_PERCEN/100),2),;		//ณ5- Valor                                 ณ
						xFilial("ZB8")+SEV->EV_XCODRAT+cAnoMes+cUltRev})	//ณ6- Chave ZB7                             ณ						
		
			dbSelectArea("ZB8")
			dbSkip()
			
		Enddo	     
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAjusta o arredondamento dos valores.ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู   
		For nLoop2:=1 to Len(aLctoCrd)
		
			If nLoop2 == 1
				nPosMenorSEV	:= 1
				nPosMaiorSEV	:= 1
				nMenorSEV		:= 	aLctoCrd[nLoop2][5]
				nMaiorSEV		:=	aLctoCrd[nLoop2][5]
			Else
				If aLctoCrd[nLoop2][5] > nMaiorSEV
					nMaiorSEV		:= 	aLctoCrd[nLoop2][5]
					nPosMaiorSEV	:= 	nLoop2
				Endif
			                               
				If aLctoCrd[nLoop2][5] < nMenorSEV        
					nMenorSEV		:= 	aLctoCrd[nLoop2][5]
					nPosMenorSEV	:= 	nLoop2
				Endif
			Endif
		
			nSomaSEV	+= aLctoCrd[nLoop2][5]
		
		Next nLoop2 
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณCaso o valor da SEV seja maior queณ
		//ณa soma dos arredondamentos, soma  ณ
		//ณa diferen็a na menor SEV.         ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If Round(SEV->EV_VALOR,2) > nSomaSEV
			aLctoCrd[nPosMenorSEV][5]	+= Round(SEV->EV_VALOR-nSomaSEV,2)			
		Endif

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณCaso o valor da SEV seja menor que ณ
		//ณa soma dos arredondamentos, subtraiณ
		//ณa diferen็a na maior SEV.          ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู	
		If Round(SEV->EV_VALOR,2) < nSomaSEV
			aLctoCrd[nPosMaiorSEV][5]	-= Round(nSomaSEV-SEV->EV_VALOR,2) 
		Endif       
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณFaz o lan็amento a Cr้ditoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู    
		cArquivo := ""
		nHdlPrv  := HeadProva(cLote,"RCTBMA4",SubStr(cUsuario,7,6),@cArquivo)

		If nHdlPrv <= 0
			Help(" ",,1,"A100NOPRV")
			Return
		EndIf                         
	
		CXVLCRD		:= SEV->EV_VALOR
		CXVARNAT	:= SEV->EV_NATUREZ
	
		nTotal += DetProva(nHdlPrv,cLctoDeb,"RCTBMA4",cLote)  
	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณFaz os lan็amentos a D้bitoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		For nLoop2:=1 to Len(aLctoCrd)              

			CXVARNAT	:= aLctoCrd[nLoop2][1]
		
			CXCCDEB		:= aLctoCrd[nLoop2][2]
			CXITDEB		:= aLctoCrd[nLoop2][3]
			CXCLDEB		:= aLctoCrd[nLoop2][4]
			
			CXVALOR		:= aLctoCrd[nLoop2][5]
		
			nTotal 		+= DetProva(nHdlPrv,cLctoCrd,"RCTBMA4",cLote)  
	
		Next nLoop2
		
		RodaProva(nHdlPrv,nTotal)
		lLancOk := cA100Incl(cArquivo,nHdlPrv,3,cLote,lView,lAglu)		
		
		If lLancOK
		
			For nLoop2 := 1 to Len(aLctoCrd)
				dbSelectArea("ZB7")
				dbSetOrder(1)
				If dbSeek(aLctoCrd[nLoop2][6],.F.)
					RecLock("ZB7",.F.)
					ZB7->ZB7_PROCES	:= 'S'
					MsUnlock()
				Endif				
		    Next nLoop2
		
			nQtdCtb++
		
		Endif
		EndIf
		
		dbSelectArea("SEV")
		dbSkip()
		
	EndDo       	
	
	dbSelectArea("SF1")
	dbSetOrder(1)//F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
	dbSeek(aProc[nLoop],.F.)
	RecLock("SF1",.F.)
		SF1->F1_XPRORAT	:= ' '
		SF1->F1_XDTCONT	:= dDataBase
		SF1->F1_XUSRCON	:= __cUserID		
	MsUnlock()
	
Next nLoop    

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณResumo para o usuแrio.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If nQtdCtb > 0
 	Aviso("AVISO",OemToAnsi("Gerado(s) "+AllTrim(Str(nQtdCtb))+" Lancamento(s) dos Rateios"),{"OK"})
Else
	Aviso(OemToAnsi("ATENวรO"),OemToAnsi("Nใo foi gerado nenhum Lan็amento Contแbil."),{"OK"})
EndIf 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRecarregar o MarkBrowseณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
TRB->(dbGoTop())
Do While !EOF()
	RecLock("TRB",.F.)
	TRB->(dbDelete())
	TRB->(MsUnlock())
		     
	TRB->(dbSkip())
Enddo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Gera os dados temporarios 								ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !lRev
	Processa({|| GERAQRY()} ,"Gerando dados...")
	MarkBRefresh()
Endif

RestArea(aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCTBMA4EX  บAutor  ณV. Greg๓rio         บ Data ณ  20/01/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina de exclusใo dos lan็amentos contแbeis selecionados. บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CSU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CTBMA4EX()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDeclara็ใo de variแveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aArea			:= GetArea()
Local lRetorno		:= .T.

Local aProc			:= {}

Local cChvCT2		:= ""
Local nDocs			:= 0       
Local lExclui		:= .F.

Local cQry			:= ""

Local aCampos		:= {}
Local aAltera		:= {}
Local cArq1			:= ""
Local cArq2			:= ""

Private __lCusto	:= .F.
Private __lItem 	:= .F.
Private __lCLVL		:= .F.

Private aHeader		:= {}
Private aCols		:= {}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPercorre a tabela temporแria gerando a   ณ
//ณcontabiliza็ใo dos documentos de entrada.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("TRB")
dbGoTop()

Do While !EOF()

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณGuardar as notas que serใo processadas.ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If TRB->TMP_OK == ThisMark() .and. TRB->TMP_MARCA <> 'N'
		If aScan(aProc,TRB->(TMP_FILIAL+TMP_DOC+TMP_SERIE+TMP_FORNEC+TMP_LOJA))==0
			aAdd(aProc,TRB->(TMP_FILIAL+TMP_DOC+TMP_SERIE+TMP_FORNEC+TMP_LOJA))
		Endif	
	Endif	
     
	dbSelectArea("TRB")
	dbSkip()
EndDo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRealiza a contabiliza็ใo das notas marcadas.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For nLoop	:= 1 to Len(aProc)             
    
	dbSelectArea("SF1")
	dbSetOrder(1)//F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
	dbSeek(aProc[nLoop],.F.)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMonta a chave baseada na origem do lan็amentoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cChvCT2	:= "LP RLC-001 "+SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMonta query com os registros a serem excluidos do CT2                ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cQuery := "SELECT CT2_DATA, CT2_LOTE, CT2_SBLOTE, CT2_DOC, CT2_SEQUEN"
	cQuery += "FROM "+RetSqlName("CT2")+ " "
	cQuery += "WHERE CT2_FILIAL = '"+xFilial ("CT2")+"'"          
	cQuery += " AND CT2_ORIGEM = '"+cChvCT2+"'"
//	cQuery += " AND CT2_ROTINA IN " + FormatIn(cRotina, "/") + ""
//	cQuery += " AND (CT2_FILORI = '  ' OR CT2_FILORI = '" + cFilAnt + "')"//VG - permitir o processamento para qlqr filial
//	cQuery += " AND (CT2_EMPORI = '  ' OR CT2_EMPORI = '" + cEmpAnt + "')"
	cQuery += " GROUP BY CT2_DATA, CT2_LOTE, CT2_SBLOTE, CT2_DOC, CT2_SEQUEN"
	cQuery += " ORDER BY CT2_DATA, CT2_LOTE, CT2_SBLOTE, CT2_DOC, CT2_SEQUEN"
	cQuery := ChangeQuery(cQuery)

	If Select("CT2DEL") > 0
		dbSelectArea("CT2DEL")
		DbCloseArea()
	Endif
	
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"CT2DEL",.T.,.F.)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณExclui o lote contabil                                               ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู    
	DbSelectArea("CT2DEL")
	DbGoTop()
	While !EOF()

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Monta o arquivo TRB utilizado                                ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		aCampos 	:= Ctb105Head(@aAltera)  
		dDataLanc	:= STOD(CT2DEL->CT2_DATA)
		Ctb105Cria(aCampos,@cArq1,@cArq2)
		Ctb102Carr(5,@dDataLanc,CT2DEL->CT2_LOTE,CT2DEL->CT2_SBLOTE,CT2DEL->CT2_DOC)

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Exclui os lancamentos                                        ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		CTBGrava(5,STOD(CT2DEL->CT2_DATA),CT2DEL->CT2_LOTE,CT2DEL->CT2_SBLOTE,CT2DEL->CT2_DOC,.F.,CT2DEL->CT2_SEQUEN,;
				 		 		 __lCusto,__lItem,__lCLVL,0,'RCTBMA4',,,cEmpAnt,cFilAnt)			
				 		 		 
		lExclui	:= .T.

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Exclui o arquivo temporario                                  ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		TMP->(DbCloseArea())
		If Select("cArq1") = 0
			FErase( cArq1+GetDBExtension() )      
			Ferase( cArq1+OrdBagExt() )
			Ferase( cArq2+OrdBagExt() )
		EndIf

		DbSelectArea("CT2DEL")
		DbSkip()
	EndDo

	If Select("CT2DEL") > 0
		dbSelectArea("CT2DEL")
		DbCloseArea()
	Endif		
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณLimpa os flags do documento de entradaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("SF1")
	dbSetOrder(1)//F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
	dbSeek(aProc[nLoop],.F.)
	RecLock("SF1",.F.)
		SF1->F1_XPRORAT	:= ' '
		SF1->F1_XDTCONT	:= CriaVar("F1_XDTCONT",.F.)
		SF1->F1_XUSRCON	:= CriaVar("F1_XUSRCON",.F.)
	MsUnlock()
		
	nDocs++         	
	
Next nLoop    

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณResumo para o usuแrio.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If lExclui
 	Aviso("AVISO",OemToAnsi("Excluํdo(s) "+AllTrim(Str(nDocs))+" Lancamento(s) dos Rateios"),{"OK"})
Else
	Aviso(OemToAnsi("ATENวรO"),OemToAnsi("Nใo foi excluํdo nenhum Lan็amento Contแbil."),{"OK"})
EndIf 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRecarregar o MarkBrowseณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
TRB->(dbGoTop())
Do While !EOF()
	RecLock("TRB",.F.)
	TRB->(dbDelete())
	TRB->(MsUnlock())		     
	TRB->(dbSkip())
Enddo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Gera os dados temporarios 								ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Processa({|| GERAQRY()} ,"Gerando dados...")
MarkBRefresh()

RestArea(aArea)
Return lRetorno
