#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RGPE004   º Autor ³Ricardo Duarte Costaº Data ³  02/09/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Exportacao de arquivo texto para o Banco Santander.        º±±
±±º          ³ Massificado Santander                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CSU CARDSYSTEMS                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RGPE004

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private _cPerg       := PADR("RGP004",LEN(SX1->X1_GRUPO))
Private oGeraTxt
Private aStru	:= {}
Private cString := "SRA"

dbSelectArea("SRA")
dbSetOrder(3)
// Carrega as perguntas.
fPerg()
Pergunte(_cPerg,.f.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela de processamento.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 200,1 TO 400,400 DIALOG oGeraTxt TITLE OemToAnsi("Massificado Santander")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira gerar um arquivo texto, conforme os parame- "
@ 18,018 Say " tros definidos  pelo usuario,  com os registros do arquivo de "
@ 26,018 Say " Funcionarios                                                  "

@ 85,98 BMPBUTTON TYPE 01 ACTION OkGeraTxt()
@ 85,128 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
@ 85,158 BMPBUTTON TYPE 05 ACTION Pergunte(_cPerg,.T.)

Activate Dialog oGeraTxt Centered

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ OKGERATXTº Autor ³ AP5 IDE            º Data ³  02/09/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao chamada pelo botao OK na tela inicial de processamenº±±
±±º          ³ to. Executa a geracao do arquivo texto.                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function OkGeraTxt

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria o arquivo texto                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Close(oGeraTxt)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a regua de processamento                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Processa({|| RunCont() },"Processando...")
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ RUNCONT  º Autor ³ AP5 IDE            º Data ³  02/09/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunCont
aStru:={}
// Cria a estrutura e abre o arquivo temporario como TRB
aAdd(aStru,{"TIPO"		,"C",01,0})	// Fixo == D
aAdd(aStru,{"NOME"		,"C",50,0})
aAdd(aStru,{"CPF"		,"C",11,0})
aAdd(aStru,{"TIPOCPF"	,"C",02,0})	// Fixo == 01
aAdd(aStru,{"TIPODOC"	,"C",02,0})	// Fixo == 05 significa RG
aAdd(aStru,{"RG"		,"C",15,0})
aAdd(aStru,{"EMISSAORG"	,"C",08,0})	// Data de emissao do RG
aAdd(aStru,{"EXPRG"		,"C",06,0})	// Orgao Expeditor do RG
aAdd(aStru,{"UFRG"		,"C",02,0})	// Estado do Documento
aAdd(aStru,{"NASCIMENTO","C",08,0})
aAdd(aStru,{"NACIONAL"	,"C",04,0})
aAdd(aStru,{"SEXO"		,"C",02,0})	// 01 - M / 02 - F
aAdd(aStru,{"ESTCIVI"	,"C",02,0})	// 01 Solteiro 02 Casado 03 Viuvo 04 Desquitado
										// 05 Divorciado 06 Marital 99 Outros
aAdd(aStru,{"TPTELEF"	,"C",02,0})	// 01 Residencial 02 Celular
aAdd(aStru,{"DDD"		,"C",04,0})
aAdd(aStru,{"TELEFONE"	,"C",08,0})
aAdd(aStru,{"RAMAL"		,"C",05,0})
aAdd(aStru,{"OBSERVACAO","C",10,0})
aAdd(aStru,{"ENDERECO"	,"C",45,0})
aAdd(aStru,{"NUMERO"	,"C",06,0})
aAdd(aStru,{"COMPL"		,"C",15,0})
aAdd(aStru,{"BAIRRO"	,"C",30,0})
aAdd(aStru,{"MUNICIPIO"	,"C",20,0})
aAdd(aStru,{"ESTADO"	,"C",02,0})
aAdd(aStru,{"CEP"		,"C",08,0})
aAdd(aStru,{"PAIS"		,"C",10,0})	// Fixo = Brasil
aAdd(aStru,{"RENDA"		,"C",15,0})
aAdd(aStru,{"MESREF"	,"C",06,0})
aAdd(aStru,{"CARGO"		,"C",40,0})
cArqTrab	:= CriaTrab(aStru,.t.)
use &cArqTrab ALIAS TRB NEW

// Carrega os parametros
cFilde		:= mv_par01		//	Filial De
cFilAte		:= mv_par02		//	Filial Ate
//cCC			:= fCCustos()	//	Busca os centros de custos que devem ser considerados
cMatDe		:= mv_par03		//	Matricula De
cMatAte		:= mv_par04 	//	Matricula Ate
cSitFolha	:= mv_par05		//	Situacoes a imprimir
cCategoria	:= mv_par06		//	Categorias a imprimir
cCaminho	:= mv_par07		//	Caminho e nome do arquivo a exportar.
dDataRef	:= mv_par08		//	Data de referencia

//Apaga Arquivo Gravado anteriormente
If File(alltrim(cCaminho))
	If !fErase(alltrim(cCaminho)) == 0
		MsgAlert('O arquivo '+AllTrim(cCaminho)+'esta em uso por outra estacao !!! Libere o arquivo antes de tentar novamente . ')
		return
	EndIf	
Endif     


dbSelectArea(cString)
dbSetOrder(3)
dbseek(cFilDe,.t.) // primeiro registro selecionado nos parametros

ProcRegua(RecCount()) // Numero de registros a processar

While !EOF() .and. SRA->RA_FILIAL <= cFilAte

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Incrementa a regua                                                  ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    IncProc()
   //	! SRA->RA_CC $ cCC .or. ;
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra os parametros selecionados......                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If	SRA->RA_FILIAL < cFilDe .or. SRA->RA_FILIAL > cFilAte .or. ;
		SRA->RA_MAT < cMatDe .or. SRA->RA_MAT > cMatAte .or. ;
		! SRA->RA_SITFOLH $cSitFolha .or. ! SRA->RA_CATFUNC $cCategoria .or. ;
		MESANO(dDataRef) <> MESANO(SRA->RA_ADMISSA)
		dbskip()
		loop
	Endif
	

	// Alimenta arquivo temporario.                 
	IF (EMPTY(SRA->RA_CTDEPSA) .OR. SRA->RA_CTDEPSA='000000000000')
	reclock("TRB",.t.)
	TRB->TIPO			:= "D"
	cNome				:= SRA->RA_NOME
	// Retira o caracter "." do numero do Nome
	do while (nPosNome :=	at(".",cNome)) > 0
		cNome			:= substr(cNome,1,nPosNome-1)+" "+substr(cNome,nPosNome+1)
	enddo
	TRB->NOME			:= cNome
	TRB->CPF			:= SRA->RA_CIC
	TRB->TIPOCPF		:=	"01"
	TRB->TIPODOC		:= "05"
	cRG					:= alltrim(SRA->RA_RG)
	// Retira o caracter "-" do numero do RG
	do while (nPosRG :=	at("-",cRG)) > 0
		cRG				:= substr(cRG,1,nPosRG-1)+substr(cRG,nPosRG+1)
	enddo
	// Retira o caracter "." do numero do RG
	do while (nPosRG :=	at(".",cRG)) > 0
		cRG				:= substr(cRG,1,nPosRG-1)+substr(cRG,nPosRG+1)
	enddo
	// Retira o caracter "/" do numero do RG
	do while (nPosRG :=	at("/",cRG)) > 0
		cRG				:= substr(cRG,1,nPosRG-1)+substr(cRG,nPosRG+1)
	enddo
	// Retira o caracter "X" do numero do RG
	do while (nPosRG :=	at("X",cRG)) > 0
		cRG				:= substr(cRG,1,nPosRG-1)+substr(cRG,nPosRG+1)
	enddo
	TRB->RG				:= cRG
	TRB->EMISSAORG		:= SUBSTR(DTOS(SRA->RA_RGDTEMI),7,2)+SUBSTR(DTOS(SRA->RA_RGDTEMI),5,2)+SUBSTR(DTOS(SRA->RA_RGDTEMI),1,4)
	TRB->EXPRG			:= SRA->RA_RGORG+space(3)
	TRB->UFRG			:= SRA->RA_RGUF
	TRB->NASCIMENTO		:= SUBSTR(DTOS(SRA->RA_NASC),7,2)+SUBSTR(DTOS(SRA->RA_NASC),5,2)+SUBSTR(DTOS(SRA->RA_NASC),1,4)
	TRB->NACIONAL		:= fNaciona()
	TRB->SEXO			:= IF(SRA->RA_SEXO == "M","01","02")	//	01 - M / 02 - F
	cEstCivil			:= ""
	if SRA->RA_ESTCIVI == "S"
		cEstCivil			:= "01"
	elseif SRA->RA_ESTCIVI == "C"
		cEstCivil			:= "02"
	elseif SRA->RA_ESTCIVI == "V"
		cEstCivil			:= "03"
	elseif SRA->RA_ESTCIVI == "Q"
		cEstCivil			:= "04"
	elseif SRA->RA_ESTCIVI == "D"
		cEstCivil			:= "05"
	elseif SRA->RA_ESTCIVI == "M"
		cEstCivil			:= "06"
	else
		cEstCivil			:= "99"
	endif
	TRB->ESTCIVI		:= cEstCivil		// 01 Solteiro 02 Casado 03 Viuvo 04 Desquitado
											// 05 Divorciado 06 Marital 99 Outros
	TRB->TPTELEF		:= if(!EMPTY(SRA->RA_TELEFON),"01",IF(!EMPTY(SRA->RA_TELEFO2),"04","01")) // 01 Residencial 02 Celular
	TRB->DDD			:= "0011"
	cTelefone			:= if(!EMPTY(SRA->RA_TELEFON),SRA->RA_TELEFON,IF(!EMPTY(SRA->RA_TELEFO2),SRA->RA_TELEFO2,SRA->RA_TELEFON)) // 01 Residencial 02 Celular
	// retira o caracter "-" do numero do telefone
	do while (nPosTelef :=	at("-",cTelefone)) > 0
		cTelefone		:= substr(cTelefone,1,nPosTelef-1)+substr(cTelefone,nPosTelef+1)
	enddo
	TRB->TELEFONE		:= cTelefone
	TRB->RAMAL			:= "00000"
	TRB->OBSERVACAO		:= SPACE(10)
	cEndereco			:= alltrim(SRA->RA_ENDEREC)
	cNumero				:= ""
	for nx := len(cEndereco) to 1 step -1
		if substr(cEndereco,nx,1) $'0123456789'
			cNumero	:= substr(cEndereco,nx,1) + cNumero
		else
			cEndereco := substr(cEndereco,1,len(cEndereco)-len(cNumero))
			exit
		endif
	next
	// retira o caracter "-" do endereco
	do while (nPosEnd :=	at("-",cEndereco)) > 0
		cEndereco		:= substr(cEndereco,1,nPosEnd-1)+" "+substr(cEndereco,nPosEnd+1)
	enddo
	// retira o caracter "." do endereco
	do while (nPosEnd :=	at(".",cEndereco)) > 0
		cEndereco		:= substr(cEndereco,1,nPosEnd-1)+" "+substr(cEndereco,nPosEnd+1)
	enddo
	// retira o caracter "," do endereco
	do while (nPosEnd :=	at(",",cEndereco)) > 0
		cEndereco		:= substr(cEndereco,1,nPosEnd-1)+" "+substr(cEndereco,nPosEnd+1)
	enddo
	// retira o caracter "/" do endereco
	do while (nPosEnd :=	at("/",cEndereco)) > 0
		cEndereco		:= substr(cEndereco,1,nPosEnd-1)+" "+substr(cEndereco,nPosEnd+1)
	enddo
	TRB->ENDERECO		:= cEndereco
	TRB->NUMERO			:= cNumero
	TRB->COMPL			:= SRA->RA_COMPLEM
	TRB->BAIRRO			:= SRA->RA_BAIRRO
	TRB->MUNICIPIO		:= SRA->RA_MUNICIP
	TRB->ESTADO			:= SRA->RA_ESTADO
	TRB->CEP			:= SRA->RA_CEP
	TRB->PAIS			:= "Brasil"+space(10)
	TRB->RENDA			:= strzero(SRA->RA_SALARIO*100,15)
	TRB->MESREF			:= substr(mesano(dDataRef),5,2)+substr(mesano(dDataRef),1,4)
	TRB->CARGO			:= POSICIONE("SRJ",1,xfilial("SRJ")+SRA->RA_CODFUNC,"RJ_DESC")
	msunlock()
    Endif
    
    dbselectarea("SRA")
    dbSkip()
EndDo

//Copia o arquivo com o nome e o caminho indicados.
dbselectarea("TRB")
copy to &(cCaminho) DELIMITED WITH ('"')

//close TRB
dbCloseArea("TRB")
fErase(cArqTrab)

Return

/*
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡„o    ³fPerg     ³ Autor ³Ricardo Duarte Costa   ³ Data ³26/08/2003³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡„o ³Grava as Perguntas utilizadas no Programa no SX1            ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Static Function fPerg()

Local aRegs     := {}
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³           Grupo  Ordem Pergunta Portugues     Pergunta Espanhol  Pergunta Ingles Variavel Tipo Tamanho Decimal Presel  GSC Valid                              Var01      Def01         DefSPA1   DefEng1 Cnt01             Var02  Def02    		 DefSpa2  DefEng2	Cnt02  Var03 Def03      DefSpa3    DefEng3  Cnt03  Var04  Def04     DefSpa4    DefEng4  Cnt04  Var05  Def05       DefSpa5	 DefEng5   Cnt05  XF3   GrgSxg ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
aAdd(aRegs,{_CPERG,"01","Filial De          ?","","","mv_ch1","C",2,0,0,"G","naovazio","mv_par01","","","","01","","","","","","","","","","","","","","","","","","","","","SM0","","",""})
aAdd(aRegs,{_CPERG,"02","Filial Ate         ?","","","mv_ch2","C",2,0,0,"G","naovazio","mv_par02","","","","09","","","","","","","","","","","","","","","","","","","","","SM0","","",""})
aAdd(aRegs,{_CPERG,"03","Matricula De       ?","","","mv_ch3","C",6,0,0,"G","naovazio","mv_par03","","","","0","","","","","","","","","","","","","","","","","","","","","SRA","","",""})
aAdd(aRegs,{_CPERG,"04","Matricula Ate      ?","","","mv_ch4","C",6,0,0,"G","naovazio","mv_par04","","","","999999","","","","","","","","","","","","","","","","","","","","","SRA","","",""})
aAdd(aRegs,{_CPERG,"05","Situa‡”es  a Impr. ?","","","mv_ch5","C",5,0,0,"G","fSituacao","mv_par05","","",""," A*FT","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{_CPERG,"06","Categorias a Impr. ?","","","mv_ch6","C",12,0,0,"G","fCategoria","mv_par06","","","","***EG***M***","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{_CPERG,"07","Caminho do Arquivo ?","","","mv_ch7","C",30,0,0,"G","naovazio","mv_par07","","","","C:\ARQ.TXT","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{_CPERG,"08","Data de Referencia ?","","","mv_ch8","D",08,0,0,"G","naovazio","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega as Perguntas no SX1                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ValidPerg(aRegs,_CPERG)

Return NIL

/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡„o    ³fCCustos  ³ Autor ³Ricardo Duarte Costa   ³ Data ³03/09/2003³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡„o ³Busca os centros de custos dos parametros auxiliares        ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*
static function fCCustos()

Local cAux := ""
Local aArea := getarea()

dbselectarea("SZU")
dbsetorder(1)
dbseek(xfilial("SZU")+"06"+space(10))
if found()
	do while !eof() .and. SZU->ZU_TIP == "06"
		cAux := cAux + substr(SZU->ZU_TXT,1,20) + "*"
		dbskip()
	enddo
endif

restarea(aArea)

return(cAux)
/*/
/*
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡„o    ³fNaciona  ³ Autor ³Ricardo Duarte Costa   ³ Data ³03/09/2003³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡„o ³Busca o codigo correto para a nacionalidade.                ³
ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
static function fNaciona()
Local cAux := ""

do case
	case SRA->RA_NACIONA == "10"	//	BRASILEIRO
		cAux	:= "1058"	// - BRASILEIRA
	case SRA->RA_NACIONA == "20"	//	NATURALIZADO / BRASILEIRO	
		cAux	:= "1058"	// - BRASILEIRA
	case SRA->RA_NACIONA == "21"	//	ARGENTINO	
		cAux	:= "0639"	// - ARGENTINA
	case SRA->RA_NACIONA == "22"	//	BOLIVIANO	
		cAux	:= "0973"	// - BOLIVIANA
	case SRA->RA_NACIONA == "23"	//	CHILENO	
		cAux	:= "1589"	// - CHILENA
	case SRA->RA_NACIONA == "24"	//	PARAGUAIO	
		cAux	:= "5860"	// - PARAGUAIA
	case SRA->RA_NACIONA == "25"	//	URUGUAIO	
		cAux	:= "8451"	// - URUGUAIA
	case SRA->RA_NACIONA == "30"	//	ALEMAO	
		cAux	:= "0230"	// - ALEMA OCIDENTAL                          
	case SRA->RA_NACIONA == "31"	//	BELGA	
		cAux	:= "1058"	// - BRASILEIRA
	case SRA->RA_NACIONA == "32"	//	BRITANICO	
		cAux	:= "6289"	// - INGLESA
	case SRA->RA_NACIONA == "34"	//	CANADENSE	
		cAux	:= "1490"	// - CANADENSE
	case SRA->RA_NACIONA == "35"	//	ESPANHOL	
		cAux	:= "2453"	// - ESPANHOLA
	case SRA->RA_NACIONA == "36"	//	NORTE-AMERICANO (EUA)	
		cAux	:= "2496"	// - NORTE AMERICANA
	case SRA->RA_NACIONA == "37"	//	FRANCES	
		cAux	:= "2755"	// - FRANCESA
	case SRA->RA_NACIONA == "38"	//	SUICO	
		cAux	:= "7676"	// - SUÍÇA
	case SRA->RA_NACIONA == "39"	//	ITALIANO	
		cAux	:= "3867"	// - ITALIANA
	case SRA->RA_NACIONA == "41"	//	JAPONES	
		cAux	:= "1058"	// - BRASILEIRA
	case SRA->RA_NACIONA == "42"	//	CHINES	
		cAux	:= "1600"	// - CHINESA
	case SRA->RA_NACIONA == "43"	//	COREANO	
		cAux	:= "1058"	// - BRASILEIRA
	case SRA->RA_NACIONA == "45"	//	PORTUGUES	
		cAux	:= "6076"	// - PORTUGUESA
	case SRA->RA_NACIONA == "48"	//	OUTROS LATINO-AMERICANOS	
		cAux	:= "1058"	// - BRASILEIRA
	case SRA->RA_NACIONA == "49"	//	OUTROS ASIATICOS	
		cAux	:= "1058"	// - BRASILEIRA
	case SRA->RA_NACIONA == "50"	//	OUTROS	
		cAux	:= "1058"	// - BRASILEIRA
endcase

/* NACIONALIDADES POSSIVEIS CONFORME PLANILHA SANTANDER
1058 - BRASILEIRA
0230 - ALEMA OCIDENTAL                          
0639 - ARGENTINA
0647 - ARMÊNIA
0698 - AUSTRALIANA
0728 - AUSTRIACA
0973 - BOLIVIANA
1490 - CANADENSE
1589 - CHILENA
1600 - CHINESA
1961 - COSTARRIQUENHA
2321 - DINAMARQUESA
2402 - EGÍPCIA
2453 - ESPANHOLA
2518 - ESTONIANA
2755 - FRANCESA
3018 - GREGA
5738 - HOLANDESA
3557 - HÚNGARA
3883 - IUGOSLAVA
6289 - INGLESA
3727 - IRANIANA
3867 - ITALIANA
4030 - JORDANIANA
4316 - LIBANESA
4421 - LITUANA
4936 - MEXICANA
2496 - NORTE AMERICANA
5860 - PARAGUAIA
5894 - PERUANA
6033 - POLONESA
6076 - PORTUGUESA
6769 - RUSSA
6700 - ROMENA
7447 - SÍRIA
7676 - SUÍÇA
7560 - SUL AFRICANA
7919 - TCHECA
8273 - TURCA
8451 - URUGUAIA
*/

return(cAux)
