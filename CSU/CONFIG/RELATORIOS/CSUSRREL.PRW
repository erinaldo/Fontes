#include "rwmake.ch"
#include "apcfg40.ch"

Static aAcessos
Static aModulos
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ CSUSRREL ³ Autor ³ Renato Carlos         ³ Data ³ Jan/2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Relatorio APCFG40 convertido para User Function com o      ³±±
±±³		     ³	objetivo de atender o chamado 3173-10                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CSU                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CSUSRREL()

Local CbCont
Local cabec1
Local cabec2
Local cabec3
Local nPos
Local wnrel
Local CbTxt
Local tamanho    := "M"
Local limite     := 132
Local titulo     := OemToAnsi(STR0001) //"Relação de usuários"
Local cDesc1     := OemToAnsi(STR0002) //"Emissão do Cadastro de usuários"
Local cDesc2     := OemToAnsi(STR0003) //"Ira imprimir os dados dos usuários      "
Local cDesc3     := OemToAnsi(STR0004) //"de acordo com a configuração do usuário."
Local Pg		 := "CSUSRREL"
Private cGrpAnt    := ""
Private cUsrAnt    := ""
Private aReturn  := { OemToAnsi(STR0005), 1,OemToAnsi(STR0006), 2, 2, 1, "",1 } //"Zebrado"###"Administração"
Private aLinha   := { }
Private nomeprog := "CSUSRREL"
Private AParDef  := {}
Private nLastKey

cbcont   := 0
cabec1   := OemToAnsi(STR0007) //"RELACAO DO CADASTRO DE USUÁRIOS"
cabec2   := ""
cabec3   := ""
cString  := ""
wnrel    := "CSUSRREL"
//aUsuarios := AllUsers(,.T.)
ValidPerg(Pg)

Pergunte(Pg,.F.)

wnrel := SetPrint(cString,wnrel,Pg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,{},,tamanho,,.F.)
If nLastKey = 27
	Return
EndIf
SetDefault(aReturn,cString)
If nLastKey = 27
	Return
EndIf
RptStatus({|lEnd| CSURUNRPT(@lEnd,Cabec1,Cabec2,Cabec3,limite,tamanho,cbCont,wnrel)},Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ CSURUNRPT³ Autor ³ Renato Carlos         ³ Data ³ Jan/2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Função de processamento do relatorio                       ³±±
±±³		     ³	                                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CSU                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CSURUNRPT(lEnd,Cabec1,Cabec2,Cabec3,limite,tamanho,cbCont,wnrel)
Local aAdmin
Local aGrupos
Local Ausuarios
Local x
Local y
Local z
Local cSemana
Local cGrupo
Local nPadr		:= 35
Local nPadr2	:= 9
Local nPadr3	:= 26
Local nPadr4	:= 37
Local nPadr5	:= 7
Local nPadr6	:= 13
Local nPadr7	:= 23
Local xnCont    := 0
Local cCusto :=""
Local cDemissao :=""
Local cCargo :=""
Local cMat := ""
Local cFil := ""
Local cFilCor:= ""
Local cLog := ""
Local nLogTam := 0
Local cValid:= ""
Local cCargoD :="Cargo"
Local cStr:= "Matricula"
Local cFl := "Filial"
local cCt := "Centro de Custo"
local cLogin := "Login"
Local nCount:=0
Local aFil:={}
Local aRF:={}


Private li
Private cCabec1  := Cabec1
Private cCabec2  := Cabec2
Private cCabec3  := Cabec3
Private nTamanho := Tamanho

If aModulos == Nil
	aModulos := RetModName()
	Aadd(aModulos,{99,"SIGACFG",STR0076,.F.})
EndIf
If aAcessos == Nil
	#IFNDEF AP710
		aAcessos := GetAccessList()
	#ELSE
		aAcessos := {}
		If File("SIGAMAT"+RetAcsName())
			FT_FUSE("SIGAMAT"+RetAcsName())
			FT_FGOTOP()
			While !FT_FEof()
				AADD(aAcessos,{,OemToAnsi(FT_FREADLN()),"",""})
				FT_FSKIP()
			End
			FT_Fuse()
		Else
			ApMsgAlert(STR0008,STR0009) //"Arquivo de acessos não Encontrado!"###"Atenção"
		Endif
	#ENDIF
EndIf

If mv_par07 == 1
	aGrupos := AllGroups()
  	aUsuarios := AllUsers()
Else
	aGrupos := AllGroups(.T.)
  	aUsuarios := AllUsers(,.T.)
Endif   

m_Pag  := 1
li     := 80
/*aAdmin := aConfig()

cabec(cabec1,cabec2,cabec3,nomeprog,tamanho)
LinhaPrint(__PrtCenter(STR0010)) //"Configurações do Administrador"
LinhaPrint(Padr(STR0011,nPadr)+":",aAdmin[2]) //"Numero de erros"
LinhaPrint(Padr(STR0012,nPadr)+":",aAdmin[3]) //"Numero de senhas a guardar"
LinhaPrint(Padr(STR0013,nPadr)+":",If(aAdmin[4],STR0014,STR0015)) //"Usa nome para verificar a senha"###"Sim"###"Não"
LinhaPrint(Padr(STR0016,nPadr)+":",aAdmin[5]) //"Tamanho mínimo da senha"
LinhaPrint(Padr(STR0017,nPadr)+":",If(aAdmin[6],STR0014,STR0015)) //"Usa bloqueio de usuário"###"Sim"###"Não"
LinhaPrint(Padr(STR0018,nPadr)+":",aAdmin[9]) //"E-mail" */
//LinhaPrint(__PrtFatLine())

//If mv_par02 == 1 .or. mv_par02 == 2
If 	mv_par02 == 1
	if mv_par07 ==1
		Asort(aUsuarios,,,{|A,B| A[1,1] < B[1,1]})//ORDEM POR ID
	endif 
	if mv_par07 ==2
		Asort(aUsuarios,,,{|A,B| A[1,2] < B[1,2]})//ORDEM POR USUARIO
	endif
	if mv_par07 ==3
		Asort(aUsuarios,,,{|A,B| A[1,4] < B[1,4]})//ORDEM POR NOME
	endif
	LinhaPrint()
	LinhaPrint(__PrtFatLine())
	LinhaPrint(__PrtCenter(STR0019)) //"Configurações dos Grupos"
	SetRegua(len(aGrupos))
	For x := 1 to Len(aGrupos)
		IncRegua()
		
		If Alltrim(aGrupos[x,1,1]) < Alltrim(MV_PAR03) .Or. Alltrim(aGrupos[x,1,1]) > Alltrim(MV_PAR04)
			Loop
		EndIf
		
		If MV_PAR08 == 1
			If cGrpAnt <> aGrupos[x,1,1] .AND. Li <> 80
				cGrpAnt    := aGrupos[x,1,1]
				li := 60
				LinhaPrint()
			EndIf
		EndIf
		
		LinhaPrint()
		LinhaPrint(__PrtCenter(STR0020)) //"** Grupo **"
		LinhaPrint(Padr(STR0021,nPadr)+":",aGrupos[x,1,1]) //"ID"
		LinhaPrint(Padr("Nome do Grupo",nPadr)+":",aGrupos[x,1,2]) //"Nome"
		
		/*
		For k:=1 to Len(aUsuarios[x][01][10])
		
		PswOrder(1)
		PswSeek(aUser[i][01][10][k],.f.)
		aGroup := PswRet(NIL)
		
		@ nLin,005 pSay aGroup[01][2] //Grupos
		nLin+=1
		Next k
		*/
		LinhaPrint(Padr("Usuários: ",nPadr)) //"Usuarios"
		//	LinhaPrint(Padr(" ",nPadr2)+"";
		LinhaPrint(Padr("Filial",nPadr5) +"| ";
		+ Padr("ID",nPadr5) +"| ";
		+ Padr("Matricula",nPadr2) +" | ";
		+ Padr("Login",nPadr6) +" | ";
		+ Padr(STR0047,nPadr) +" | ";
		+ Padr("Cargo",nPadr7) +" | ";
		+ Padr("Centro de Custo",nPadr4))
		
		For w := 1 to Len(aUsuarios)
			For q := 1 to Len(aUsuarios[w,1,10])  			
				If ALLTRIM(aGrupos[x,1,1]) == ALLTRIM(aUsuarios[w,1,10,q])
					cString:=''
					cString := aUsuarios[w,1,22] //pega a matricula					
					if len(cString) > 6
						cMat := substr(cString,5,10)
						cFil := substr(cString,3,2)
						
						DbSelectArea("SRA")
						dbgotop()
						dbSetOrder(1)
						DBSEEK(cFil + cMat)
						cSitua := ALLTRIM(SRA->RA_SITFOLH)
						cCpf := SRA->RA_CIC
						
						DbSelectArea("SRA")
						dbgotop()
						dbSetOrder(20)
						DBSEEK(cCpf)
						
						while (cSitua=="D" .And. cCpf==SRA->RA_CIC)
							cMat := alltrim(SRA->RA_MAT)
							cFil := alltrim(SRA->RA_FILIAL)
							cSitua := ALLTRIM(SRA->RA_SITFOLH)
							DBSKIP()
						endDo
						
						DbSelectArea("SRA")
						dbgotop()
						dbSetOrder(1)
						
						DBSEEK(cFil + cMat)
						cCust  := alltrim(SRA->RA_CC)
						cCargo := alltrim(SRA->RA_CARGO)
						
						if (cCust!="")
							DbSelectArea("CTT")
							dbgotop()
							dbSetOrder(1)
							DbSeek(xFilial()+cCust)
							cCusto := CTT->CTT_DESC01
						endif
						
						if (cCargo!="")
							DbSelectArea("SRJ")
							dbgotop()
							dbSetOrder(1)
							DbSeek(xFilial()+cCargo)
							cCargo := SRJ->RJ_DESC
						endif
					else
						cMat   := ''
						cFil   := ''
						cSitua := ''
						cCusto := ''
						cCargo := ''
					endif
					nFil := val(cFil)
					nFilt1 := val(mv_par10)
					nFilt2 := val(mv_par11)
					
					IF (nFil >= nFilt1) .AND. (nFil <= nFilt2)
						if mv_par09 == 2 //SITUACAO DOS DEMITIDOS
							if cSitua!="D"
								//							LinhaPrint(Padr(" ",nPadr2)+"";
								LinhaPrint(Padr(Alltrim(cFil),nPadr5) +"| ";
								+ Padr(Alltrim(aUsuarios[w,1,1]),nPadr5)+"| ";
								+ Padr(Alltrim(cMat),nPadr2)+" | ";
								+ Padr(Alltrim(aUsuarios[w,1,2]),nPadr6)+" | ";
								+ Padr(Alltrim(aUsuarios[w,1,4]),nPadr)+" | ";
								+ Padr(Alltrim(cCargo),nPadr7)+" | ";
								+ Padr(Alltrim(cCusto),nPadr4))
								xnCont++
							endif
						ELSEIF mv_par09 == 1
							//				LinhaPrint(Padr(" ",nPadr2)+"";
							LinhaPrint(Padr(Alltrim(cFil),nPadr5) +"| ";
							+ Padr(Alltrim(aUsuarios[w,1,1]),nPadr5)+"| ";
							+ Padr(Alltrim(cMat),nPadr2)+" | ";
							+ Padr(Alltrim(aUsuarios[w,1,2]),nPadr6)+" | ";
							+ Padr(Alltrim(aUsuarios[w,1,4]),nPadr)+" | ";
							+ Padr(Alltrim(cCargo),nPadr7)+" | ";
							+ Padr(Alltrim(cCusto),nPadr4))
							xnCont++
						endif
					endif
					
				EndIf
			Next q
		Next w
		LinhaPrint()
		LinhaPrint(Padr("Qtd Usrs no Grupo",nPadr)+":",Alltrim(str(xnCont)))
		LinhaPrint()
		xnCont := 0
	  /*	If mv_par01 == 1
				LinhaPrint(Padr(STR0023,nPadr)+":",aGrupos[x,1,4]) //"Validade da Senha"
				LinhaPrint(Padr(STR0024,nPadr)+":",aGrupos[x,1,5]) //"Qtde de dias para expirar a senha"
				LinhaPrint(Padr(STR0025,nPadr)+":",If(aGrupos[x,1,6],STR0014,STR0015)) //"Autorizado a alterar senha"###"Sim"###"Não"
				LinhaPrint(Padr(STR0026,nPadr)+":",aGrupos[x,1,8]) //"Diretório de relatório"
				LinhaPrint(Padr(STR0027,nPadr)+":",aGrupos[x,1,9]) //"Impressora"
			
				If mv_par04 == 1
			   		PrintAcessos(aGrupos[x,1,10],cabec1,cabec2,cabec3,nomeprog,tamanho)
			   		LinhaPrint()
				Endif
			  /*LinhaPrint(Padr(STR0028,nPadr)+":",SeekEmpresa(aGrupos[x,1,11])) //"Empresas"
				LinhaPrint()
			Endif              
	 	LinhaPrint(Padr(STR0029,nPadr)+":",aGrupos[x,1,12]) //"Data de última alteração"   */
	   /*	If mv_par01 == 1   
		   	LinhaPrint(Padr(STR0030,nPadr)+":",If(aGrupos[x,1,13]==1,STR0031,if(aGrupos[x,1,13]==2,STR0032,STR0033))) //"Tipo de impressão"###"Em disco"###"Via Windows"###"Direta na porta"
			LinhaPrint(Padr(STR0034,nPadr)+":",if(aGrupos[x,1,14]==1,STR0035,STR0036)) //"Formato"###"Retrato"###"Paisagem"
			LinhaPrint(Padr(STR0037,nPadr)+":",if(aGrupos[x,1,15]==1,STR0038,STR0039)) //"Ambiente"###"Servidor"###"Cliente"
			LinhaPrint(Padr(STR0040,nPadr)+":",aGrupos[x,1,16]) //"Opção de impressão"
			LinhaPrint(Padr(STR0041,nPadr)+":",If(aGrupos[x,1,17],STR0014,STR0015)) //"Acesso a outros dir. de impressão"###"Sim"###"Não"
			  */
		   /*	If mv_par03 == 1
				LinhaPrint()
				PrintMenu(aGrupos[x,2],cabec1,cabec2,cabec3,nomeprog,tamanho)
				LinhaPrint()
			Endif  
			LinhaPrint()   
			LinhaPrint(STR0042) //"Restrição de Acessos  | Domingo  | Segunda  | Terca    | Quarta   | Quinta   | Sexta    | Sábado  |"
			cSemana := STR0043 //"              Inicio "
		  /*For y := 1 To Len(aGrupos[x,1,3])
				cSemana := cSemana + " | " +  Substr(aGrupos[x,1,3,y],1,at("|",aGrupos[x,1,3,y]) - 1) + "   "
			Next
			LinhaPrint(cSemana + "|")
			cSemana := STR0044 //"                 Fim "
			For y := 1 To Len(aGrupos[x,1,3])
				cSemana := cSemana + " | " +  Substr(aGrupos[x,1,3,y],at("|",aGrupos[x,1,3,y])+1) + "   "
			Next
			LinhaPrint(cSemana+"|")    
		Endif     */
		If x < (len(aGrupos) + 1)
			LinhaPrint()
			LinhaPrint(__PrtThinLine())
		Endif
	Next
Endif

//If mv_par02 == 1 .or. mv_par02 == 3

If mv_par02 == 2
 	If mv_par07 == 1
		Asort(aUsuarios,,,{|A,B| A[1,1] < B[1,1]})//ORDEM POR ID
	Elseif mv_par07 == 2
		Asort(aUsuarios,,,{|A,B| A[1,2] < B[1,2]})//ORDEM POR USUARIO
	Elseif mv_par07 == 3
		Asort(aUsuarios,,,{|A,B| A[1,4] < B[1,4]})//ORDEM POR NOME
	endif   
	
	SetRegua(Len(aUsuarios))
	LinhaPrint()
	LinhaPrint(__PrtFatLine())
	LinhaPrint(__PrtCenter(STR0045)) //"Configurações dos Usuários"
	For x:= 1 to len(aUsuarios)
		IncRegua()
		If Val(aUsuarios[x,1,1]) == 0
			Loop
		Endif
		
		If Alltrim(aUsuarios[x,1,1]) < Alltrim(MV_PAR05) .Or. Alltrim(aUsuarios[x,1,1]) > Alltrim(MV_PAR06)
			Loop
		EndIf
		
		cString= ''
		cString := alltrim(aUsuarios[x,1,22])
		
		if len(cString)>6
			
			cMat := substr(cString,5,10)
			cFil := substr(cString,3,2)
			
			DbSelectArea("SRA")
			dbgotop()
			dbSetOrder(1)
			DBSEEK(cFil + cMat)
			cSitua := ALLTRIM(SRA->RA_SITFOLH)
			cCpf := SRA->RA_CIC
			
			DbSelectArea("SRA")
			dbgotop()
			dbSetOrder(20)
			DBSEEK(cCpf)
			
			while (cSitua=="D" .And. cCpf==SRA->RA_CIC)
				cMat := alltrim(SRA->RA_MAT)
				cFil := alltrim(SRA->RA_FILIAL)
				cSitua := ALLTRIM(SRA->RA_SITFOLH)
				DBSKIP()
			endDo
			
			DbSelectArea("SRA")
			dbgotop()
			dbSetOrder(1)
			
			DBSEEK(cFil + cMat)
			cCust := alltrim(SRA->RA_CC)
			cCargo := alltrim(SRA->RA_CARGO)
			
			if (cCust!="")
				DbSelectArea("CTT")
				dbgotop()
				dbSetOrder(1)
				DbSeek(xFilial()+cCust)
				cCusto := CTT->CTT_DESC01
			endif
			
			if (cCargo!="")
				DbSelectArea("SRJ")
				dbgotop()
				dbSetOrder(1)
				DbSeek(xFilial()+cCargo)
				cCargo := SRJ->RJ_DESC
			endif
		else
			cCusto :=""
			cCargo :=""
			cMat := ""
			cFil := ""
			cSitua :=""
		endif
		
		nFil := val(cFil)
		nFilt1 := val(mv_par10)
		nFilt2 := val(mv_par11)
		
		IF (nFil >= nFilt1) .AND. (nFil <= nFilt2)			
			if mv_par09 == 2 //SITUACAO DOS DEMITIDOS						
				if cSitua!="D"
					If MV_PAR08 == 1
				  		If cUsrAnt <> aUsuarios[x,1,1] //.AND. Li <> 80
				  			cUsrAnt    := aUsuarios[x,1,1]
				  			li := 60
				  			LinhaPrint()
				  		EndIf
			  		EndIf 
					LinhaPrint()
					LinhaPrint(__PrtCenter(STR0046)) //"** Usuário **"
					LinhaPrint(Padr(cFl,nPadr)+":",cFil) //"Filial"
					LinhaPrint(Padr(cStr,nPadr)+":",cMat) //"Matricula"
					LinhaPrint(Padr(STR0021,nPadr)+":",aUsuarios[x,1,1]) //"ID"
					LinhaPrint(Padr(cLogin,nPadr)+":",aUsuarios[x,1,2]) //"Login"
					LinhaPrint(Padr(STR0047,nPadr)+":",aUsuarios[x,1,4]) //"Nome Completo"
					LinhaPrint(Padr(cCargoD,nPadr)+":",cCargo)	 //"Cargo"
					LinhaPrint(Padr(cCt,nPadr)+":",cCusto) //"Centro de Custo"
					cGrupo := ""
					z := 0
					
					LinhaPrint(Padr(STR0052,nPadr)+":",cGrupo) //"Grupo(s)"
					For y := 1 To Len(aUsuarios[x,1,10]) // Lista de Grupos
						/*
						If z == 5
						cGrupo := cGrupo + Chr(13) + Chr(10) + Space(40)
						z := 0
						EndIf                      
						,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
						*/  
						z := z + 1
						cGrupo :=  SeekGrupo(aUsuarios[x,1,10,y],aGrupos)					
						LinhaPrint("",cGrupo)                            
						
					Next
					
					If mv_par01 == 1
						LinhaPrint(Padr(STR0048,nPadr)+":",aUsuarios[x,1,20]) //"Ramal"
						LinhaPrint(Padr(STR0049,nPadr)+":",aUsuarios[x,1,6]) //"Data de Validade"
						LinhaPrint(Padr(STR0024,nPadr)+":",aUsuarios[x,1,7]) //"Qtde de dias para expirar a senha"
						LinhaPrint(Padr(STR0050,nPadr)+":",If(aUsuarios[x,1,8],STR0014,STR0015)) //"Autorizado a alterar a senha"###"Sim"###"Não"
						LinhaPrint(Padr(STR0051,nPadr)+":",If(aUsuarios[x,1,9],STR0014,15)) //"Alterar a senha no próximo Logon"###"Sim"###"Não"
						
						PrintLogOp(aUsuarios[x,1,21])
						LinhaPrint()
					Endif
					LinhaPrint(Padr(STR0053,nPadr)+":",aUsuarios[x,1,11]) //"ID do Supervisor"
					If mv_par01 == 1
						LinhaPrint(Padr(STR0054,nPadr)+":",aUsuarios[x,1,12])    //"Departamento"
						LinhaPrint(Padr(STR0055,nPadr)+":",aUsuarios[x,1,13])    //"Cargo"
					Endif
					LinhaPrint(Padr(STR0018,nPadr)+":",aUsuarios[x,1,14])    //"E-mail"
					If mv_par01 == 1
						LinhaPrint(Padr(STR0056,nPadr)+":",aUsuarios[x,1,15]) //"Número de acessos simultâneos"
					Endif
					LinhaPrint(Padr(STR0057,nPadr)+":",aUsuarios[x,1,16])    //"Data da última alteração"
					LinhaPrint(Padr(STR0058,nPadr)+":",If(aUsuarios[x,1,17],STR0014,STR0015))    //"Usuário bloqueado"###"Sim"###"Não"
					If mv_par01 == 1
						LinhaPrint(Padr(STR0059,nPadr)+":",aUsuarios[x,1,18])       //"Número de digitos para o ano"
						LinhaPrint(Padr(STR0026,nPadr)+":",aUsuarios[x,2,3]) //"Diretório de relatório"
						LinhaPrint(Padr(STR0027,nPadr)+":",aUsuarios[x,2,4]) //"Impressora"
						/*
						If mv_par04 == 1
						LinhaPrint()
						PrintAcessos(aUsuarios[x,2,5],cabec1,cabec2,cabec3,nomeprog,tamanho)
						LinhaPrint()
						Endif
						*/
						LinhaPrint(Padr(STR0028,nPadr)+":",SeekEmpresaa(aUsuarios[x,2,6])) //"Empresas"
						LinhaPrint()
						LinhaPrint(Padr(STR0030,nPadr)+":",If(aUsuarios[x,2,8]==1,STR0031,if(aUsuarios[x,2,8]==2,STR0032,STR0033))) //"Tipo de impressão"###"Em disco"###"Via Windows"###"Direta na porta"
						LinhaPrint(Padr(STR0034,nPadr)+":",if(aUsuarios[x,2,9]==1,STR0035,STR0036)) //"Formato"###"Retrato"###"Paisagem"
						LinhaPrint(Padr(STR0037,nPadr)+":",if(aUsuarios[x,2,10]==1,STR0038,STR0039)) //"Ambiente"###"Servidor"###"Cliente"
						LinhaPrint(Padr(STR0040,nPadr)+":",aUsuarios[x,2,12])    //"Opção de impressão"
						LinhaPrint(Padr(STR0060,nPadr)+":",If(aUsuarios[x,2,11],STR0014,STR0015)) //"Prioridade de Grupo"###"Sim"###"Não"
						/*
						If mv_par03 == 1
						LinhaPrint()
						PrintMenu(aUsuarios[x,3],cabec1,cabec2,cabec3,nomeprog,tamanho)
						Endif
						*/
						LinhaPrint()
						LinhaPrint(STR0042) //"Restrição de Acessos  | Domingo  | Segunda  | Terca    | Quarta   | Quinta   | Sexta    | Sábado  |"
						cSemana := STR0043 //"              Inicio "
						For y := 1 To Len(aUsuarios[x,2,1])
							cSemana := cSemana + " | " +  Substr(aUsuarios[x,2,1,y],1,at("|",aUsuarios[x,2,1,y]) - 1) + "   "
						Next
						LinhaPrint(cSemana + "|")
						cSemana := STR0044 //"                 Fim "
						For y := 1 To Len(aUsuarios[x,2,1])
							cSemana := cSemana + " | " +  Substr(aUsuarios[x,2,1,y],at("|",aUsuarios[x,2,1,y])+1) + "   "
						Next
						LinhaPrint(cSemana+"|")
					Endif
					If x < (len(aUsuarios) + 1)
						LinhaPrint()
						LinhaPrint(__PrtThinLine())
					Endif
				endif
			elseif mv_par09 == 1   
			   		If MV_PAR08 == 1
						If cUsrAnt <> aUsuarios[x,1,1] //.AND. Li <> 80
							cUsrAnt    := aUsuarios[x,1,1]
							li := 60
							LinhaPrint()
						EndIf
				  	EndIf 
				LinhaPrint()
				LinhaPrint(__PrtCenter(STR0046)) //"** Usuário **"
				LinhaPrint(Padr(cFl,nPadr)+":",cFil) //"Filial"
				LinhaPrint(Padr(cStr,nPadr)+":",cMat) //"Matricula"
				LinhaPrint(Padr(STR0021,nPadr)+":",aUsuarios[x,1,1]) //"ID"
				LinhaPrint(Padr(cLogin,nPadr)+":",aUsuarios[x,1,2]) //"Login"
				LinhaPrint(Padr(STR0047,nPadr)+":",aUsuarios[x,1,4]) //"Nome Completo"
				LinhaPrint(Padr(cCargoD,nPadr)+":",cCargo)	 //"Cargo"
				LinhaPrint(Padr(cCt,nPadr)+":",cCusto) //"Centro de Custo"
				
				cGrupo := ""
				z := 0
				
				LinhaPrint(Padr(STR0052,nPadr)+":",cGrupo) //"Grupo(s)"
				For y := 1 To Len(aUsuarios[x,1,10]) // Lista de Grupos
					/*
					If z == 5
					cGrupo := cGrupo + Chr(13) + Chr(10) + Space(40)
					z := 0
					EndIf
					*/
					cGrupo :=  SeekGrupo(aUsuarios[x,1,10,y],aGrupos)
					z := z + 1
					LinhaPrint("",cGrupo)
				Next
				
				If mv_par01 == 1
					LinhaPrint(Padr(STR0048,nPadr)+":",aUsuarios[x,1,20]) //"Ramal"
					LinhaPrint(Padr(STR0049,nPadr)+":",aUsuarios[x,1,6]) //"Data de Validade"
					LinhaPrint(Padr(STR0024,nPadr)+":",aUsuarios[x,1,7]) //"Qtde de dias para expirar a senha"
					LinhaPrint(Padr(STR0050,nPadr)+":",If(aUsuarios[x,1,8],STR0014,STR0015)) //"Autorizado a alterar a senha"###"Sim"###"Não"
					LinhaPrint(Padr(STR0051,nPadr)+":",If(aUsuarios[x,1,9],STR0014,15)) //"Alterar a senha no próximo Logon"###"Sim"###"Não"
					
					PrintLogOp(aUsuarios[x,1,21])
					LinhaPrint()
				Endif
				LinhaPrint(Padr(STR0053,nPadr)+":",aUsuarios[x,1,11]) //"ID do Supervisor"
				If mv_par01 == 1
					LinhaPrint(Padr(STR0054,nPadr)+":",aUsuarios[x,1,12])    //"Departamento"
					LinhaPrint(Padr(STR0055,nPadr)+":",aUsuarios[x,1,13])    //"Cargo"
				Endif
				LinhaPrint(Padr(STR0018,nPadr)+":",aUsuarios[x,1,14])    //"E-mail"
				If mv_par01 == 1
					LinhaPrint(Padr(STR0056,nPadr)+":",aUsuarios[x,1,15]) //"Número de acessos simultâneos"
				Endif
				LinhaPrint(Padr(STR0057,nPadr)+":",aUsuarios[x,1,16])    //"Data da última alteração"
				LinhaPrint(Padr(STR0058,nPadr)+":",If(aUsuarios[x,1,17],STR0014,STR0015))    //"Usuário bloqueado"###"Sim"###"Não"
				If mv_par01 == 1
					LinhaPrint(Padr(STR0059,nPadr)+":",aUsuarios[x,1,18])       //"Número de digitos para o ano"
					LinhaPrint(Padr(STR0026,nPadr)+":",aUsuarios[x,2,3]) //"Diretório de relatório"
					LinhaPrint(Padr(STR0027,nPadr)+":",aUsuarios[x,2,4]) //"Impressora"
					/*
					If mv_par04 == 1
					LinhaPrint()
					PrintAcessos(aUsuarios[x,2,5],cabec1,cabec2,cabec3,nomeprog,tamanho)
					LinhaPrint()
					Endif
					*/
					LinhaPrint(Padr(STR0028,nPadr)+":",SeekEmpresaa(aUsuarios[x,2,6])) //"Empresas"
					LinhaPrint()
					LinhaPrint(Padr(STR0030,nPadr)+":",If(aUsuarios[x,2,8]==1,STR0031,if(aUsuarios[x,2,8]==2,STR0032,STR0033))) //"Tipo de impressão"###"Em disco"###"Via Windows"###"Direta na porta"
					LinhaPrint(Padr(STR0034,nPadr)+":",if(aUsuarios[x,2,9]==1,STR0035,STR0036)) //"Formato"###"Retrato"###"Paisagem"
					LinhaPrint(Padr(STR0037,nPadr)+":",if(aUsuarios[x,2,10]==1,STR0038,STR0039)) //"Ambiente"###"Servidor"###"Cliente"
					LinhaPrint(Padr(STR0040,nPadr)+":",aUsuarios[x,2,12])    //"Opção de impressão"
					LinhaPrint(Padr(STR0060,nPadr)+":",If(aUsuarios[x,2,11],STR0014,STR0015)) //"Prioridade de Grupo"###"Sim"###"Não"
					/*
					If mv_par03 == 1
					LinhaPrint()
					PrintMenu(aUsuarios[x,3],cabec1,cabec2,cabec3,nomeprog,tamanho)
					Endif
					*/
					LinhaPrint()
					LinhaPrint(STR0042) //"Restrição de Acessos  | Domingo  | Segunda  | Terca    | Quarta   | Quinta   | Sexta    | Sábado  |"
					cSemana := STR0043 //"              Inicio "
					For y := 1 To Len(aUsuarios[x,2,1])
						cSemana := cSemana + " | " +  Substr(aUsuarios[x,2,1,y],1,at("|",aUsuarios[x,2,1,y]) - 1) + "   "
					Next
					LinhaPrint(cSemana + "|")
					cSemana := STR0044 //"                 Fim "
					For y := 1 To Len(aUsuarios[x,2,1])
						cSemana := cSemana + " | " +  Substr(aUsuarios[x,2,1,y],at("|",aUsuarios[x,2,1,y])+1) + "   "
					Next
					LinhaPrint(cSemana+"|")
				Endif
				If x < (len(aUsuarios) + 1)
					LinhaPrint()
					LinhaPrint(__PrtThinLine())
				Endif
			ENDIF
		endif
		
	Next
Endif



If mv_par02 == 3
	SetRegua(Len(aUsuarios))
	LinhaPrint()
	LinhaPrint(__PrtFatLine())
	LinhaPrint(__PrtCenter(STR0045)) //"Configurações dos Usuários"
	
	For x:= 1 to len(aUsuarios)
		IncRegua()
		If Val(aUsuarios[x,1,1]) == 0
			Loop
		Endif
		
		If Alltrim(aUsuarios[x,1,1]) < Alltrim(MV_PAR05) .Or. Alltrim(aUsuarios[x,1,1]) > Alltrim(MV_PAR06)
			Loop
		EndIf
		cString:=''
		cString := alltrim(aUsuarios[x,1,22])
		//	cLog := aUsuarios[x,1,2]
		//	nLogTam := len(aUsuarios[x,1,2])
		//	alert (nLogTam)
		//	cValid := substr(cLog,nLogTam,1)
		//	alert (cValid)
		
		//	if cValid!='*'
		if len(cString)>6
			
			cMat := substr(cString,5,10)
			cFil := substr(cString,3,2)
			
			DbSelectArea("SRA")
			dbgotop()
			dbSetOrder(1)
			DBSEEK(cFil + cMat)
			cSitua := ALLTRIM(SRA->RA_SITFOLH)
			cDemissao := ALLTRIM(SRA->RA_DEMISSA)
			cCpf := SRA->RA_CIC
			
			DbSelectArea("SRA")
			dbgotop()
			dbSetOrder(20)
			DBSEEK(cCpf)
			
			while (cSitua=="D" .And. cCpf==SRA->RA_CIC)
				cMat := alltrim(SRA->RA_MAT)
				cFil := alltrim(SRA->RA_FILIAL)
				cSitua := ALLTRIM(SRA->RA_SITFOLH)
				cDemissao := ALLTRIM(SRA->RA_DEMISSA)
				DBSKIP()
			endDo
			
			DbSelectArea("SRA")
			dbgotop()
			dbSetOrder(1)
			
			DBSEEK(cFil + cMat)
			cCust := alltrim(SRA->RA_CC)
			cCargo := alltrim(SRA->RA_CODFUNC)
			
			if (cCust!="")
				DbSelectArea("CTT")
				dbgotop()
				dbSetOrder(1)
				DbSeek(xFilial()+cCust)
				cCusto := CTT->CTT_DESC01
			endif
			
			if (cCargo!="")
				DbSelectArea("SRJ")
				dbgotop()
				dbSetOrder(1)
				DbSeek(xFilial()+cCargo)
				cCargo := SRJ->RJ_DESC
			endif
		else
			cMat:=''
			cCargo:=''
			cCusto:=''
			cFil:=''
			cSitua:=''
			cDemissao:=''
		endif
		
		nFil := val(cFil)
		nFilt1 := val(mv_par10)
		nFilt2 := val(mv_par11)
		
		IF (nFil >= nFilt1) .AND. (nFil <= nFilt2)
			if mv_par09 == 2 //SITUACAO DOS DEMITIDOS
				if cSitua!="D" .and. cDemissao==''
					AADD(aFil,{cFil,cMat,aUsuarios[x,1,2] ,aUsuarios[x,1,4],cCargo,cCusto})
				endif
			elseif mv_par09 == 1
				AADD(aFil,{cFil,cMat,aUsuarios[x,1,2] ,aUsuarios[x,1,4],cCargo,cCusto})
			endif
		ENDIF
		
		//endif
	Next
	
	Asort(aFil,,,{|X,Y| x[1] < y[1]}) //organiza por filial
	cFil:=''
	cFilCor:=''
	cFilCom:=''
	
	FOR nTam := 1 to LEN(aFil)
		if cFilCor!=aFil[nTam,1]
			cFilCor:=AllTrim(aFil[nTam,1])
			AADD(aRF,{cFilCor}) //coleta as filiais existentes
			nCount+=1
		endif
	next
	
	for nCount := 1 to LEN(aRF)
		aFilP:={}
		cFilCor:=aRF[nCount,1] //pega a filial corrente
		
		for nTam := 1 to LEN(aFil)  //pega os dados dos usuarios da filial corrente
			cFilAt:=aFil[nTam,1]
			if cFilCor == cFilAt
				AADD(aFilP,{ALLTRIM(aFil[nTam,1]),ALLTRIM(aFil[nTam,2]),ALLTRIM(aFil[nTam,3]),;
				ALLTRIM(aFil[nTam,4]),ALLTRIM(aFil[nTam,5]),ALLTRIM(aFil[nTam,6])})
			endif
		next 
		
		if mv_par07 ==1
			Asort(aFilP,,,{|A,B| A[1] < B[1]})//ORDEM POR ID
   		ELSEIF mv_par07==2
			Asort(aFilP,,,{|A,B| A[3] < B[3]})//ORDEM POR LOGIN
		elseif mv_par07==3
			Asort(aFilP,,,{|A,B| A[4] < B[4]})//ORDEM POR NOME
		endif
		
		if Len(aFilP)>0
			FOR nTam := 1 to LEN(aFilP)
				If (cFilCom!='') .and. (cFilCom!=aFilP[nTam,1]) .and. (MV_PAR08 == 1)
					Li := 74
					cFil:="Filial: "+aFilP[nTam,1]
					LinhaFil(cFil)
					cFilCom:=aFilP[nTam,1]
				elseif (cFilCom=='')
					cFil:="Filial: "+aFilP[1,1]
					cFilCom:=aFilP[1,1]
					LinhaFilial(cFil)
					LinhaFilial(Padr("Matricula",nPadr2) +" | ";
					+ Padr("Login",nPadr2) +" | ";
					+ Padr(STR0047,nPadr4) +" | ";
					+ Padr(STR0055,nPadr3) +" | ";
					+ Padr("Centro de Custo",nPadr4))
				endif
				if Li >= 74
					LinhaFil(cFil)
				endif
				LinhaFilial(Padr(aFilP[nTam,2],nPadr2) +" | ";
				+ Padr(aFilP[nTam,3],nPadr2) +" | ";
				+ Padr(aFilP[nTam,4],nPadr4) +" | ";
				+ Padr(aFilP[nTam,5],nPadr3) +" | ";
				+ Padr(aFilP[nTam,6],nPadr4))
				
			next
		endif
	next
	
Endif

If aReturn[5] = 1
	SET Print TO
	Commit
	ourspool(wnrel)
EndIf
MS_FLUSH()

Return nil


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³LinhaPrint³ Autor ³ TOTVS                 ³ Data ³ Jan/2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ FUNCAO PARA IMPRESSAO DA LINHA NO REL                      ³±±
±±³		     ³	                                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CSU                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function LinhaFilial(cVar1,cVar2)
Local nPadr		:= 35
Local nPadr2	:= 9
Local nPadr3	:= 26
Local nPadr4	:= 37
Local nPadr5	:= 7
Local nPadr6	:= 13


If !Empty(cVar1)
	@ li,0  Psay cVar1
EndIf
If !Empty(cVar2)
	@ li,40 Psay cVar2
EndIf
Li := li + 1
Return NIL

Static Function LinhaFil(cvar1,cvar2)
Local nPadr		:= 35
Local nPadr2	:= 9
Local nPadr3	:= 26
Local nPadr4	:= 37
Local nPadr5	:= 7
Local nPadr6	:= 13

If li > 73
	li := cabec(cCabec1,cCabec2,cCabec3,nomeprog,nTamanho)
	
	If !Empty(cVar1)
		li += 1
		@ li,0  Psay cVar1
	EndIf
	li += 1
	@ li,0  Psay  Padr("Matricula",nPadr2) +" | ";
	+ Padr("Login",nPadr2) +" | ";
	+ Padr(STR0047,nPadr4) +" | ";
	+ Padr(STR0055,nPadr3) +" | ";
	+ Padr("Centro de Custo",nPadr4)
EndIf
Li := li + 1
Return NIL

Static Function LinhaPrint(cvar1,cvar2)
If li > 58
	li := cabec(cCabec1,cCabec2,cCabec3,nomeprog,nTamanho)
	li += 1
EndIf
If !Empty(cVar1)
	@ li,0  Psay cVar1
EndIf
If !Empty(cVar2)
	@ li,40 Psay cVar2
EndIf
Li := li + 1
Return NIL


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³SeekGrupo ³ Autor ³ TOTVS                 ³ Data ³ Jan/2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ FUNCAO PARA LOCALIZAR O GRUPO DO USUARIO                   ³±±
±±³		     ³	                                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CSU                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function SeekGrupo(cID,aGrupos)
Local x
Local cReturn  := ""
For x:= 1 to Len(aGrupos)
	If aGrupos[x,1,1] == cID
		cReturn := aGrupos[x,1,2]
	EndIf
Next
Return cReturn

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³SeekEmpresa ³ Autor ³ TOTVS               ³ Data ³ Jan/2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ FUNCAO PARA LOCALIZAR A EMPRESA NO SIGAMAT                 ³±±
±±³		     ³	                                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CSU                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function SeekEmpresa(cID)
Local cReturn := ""
Local cAlias  := Alias()
Local Y       := 0
Local Z       := 0
DbSelectArea("SM0")
For Y := 1 to Len(cID)
	If cID[y] ==  "@@@@"
		cReturn := STR0061 //"Todas"
	Else
		DbSeek(cID[y])
		If Z == 7
			cReturn := cReturn + Chr(13) + Chr(10) + Space(40)
			z := 0
		Endif
		cReturn := cReturn + AllTrim(M0_NOME) + " / " + AllTrim(M0_FILIAL) + "; "
		z := z + 1
	EndIf
Next
DbSelectArea(cAlias)
Return cReturn

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³PrintAcessos ³ Autor ³ TOTVS              ³ Data ³ Jan/2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ FUNCAO PARA IMPRIMIR OS ACESSOS CONFORME PARAMETRO         ³±±
±±³		     ³	                                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CSU                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function PrintAcessos(cString,cabec1,cabec2,cabec3,nomeprog,tamanho)
Local n := 0
Local z := 0
Local cReturn := ""
Local x

LinhaPrint()
LinhaPrint(STR0062) //"Acessos"
For x:= 1 to Len(aAcessos)
	n := n + 1
	z := z + 1
	cReturn := cReturn + "[" + If(SubStr(cString,n,1)="S","X"," ") + "] " + aAcessos[x][2]  + " "
	If z = 4
		LinhaPrint(cReturn)
		cReturn := ""
		z := 0
		If li > 58
			LinhaPrint(STR0062) //"Acessos"
		EndIf
	EndIf
Next
Return cReturn

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³PrintMenu ³ Autor ³ TOTVS                 ³ Data ³ Jan/2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ FUNCAO PARA IMPRIMIR OS MENUS CONFORME PARAMETRO           ³±±
±±³		     ³	                                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CSU                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function PrintMenu(cString,cabec1,cabec2,cabec3,nomeprog,tamanho)

Local cReturn := ""
Local x := 0
Local z := 0
Local cCabec := Space(4)+STR0063+Space(7)+STR0064+Space(2)+STR0065+space(51)+STR0063+Space(7)+STR0064+Space(2)+STR0065 //"Módulo"###"Nível"###"Menu"###"Módulo"###"Nível"###"Menu"
LinhaPrint(cCabec)
For x:= 1 to Len(cString)
	cReturn := cReturn + "[" + If(SubStr(cString[x],3,1)<>"X","X"," ") + "] " + Pad(aModulos[ Ascan(aModulos, { |b | b[1] == Val(Substr(cString[x],1,2)) } ),2],8) +  "     " + SubStr(cString[x],3,1) + "      " + SubStr(cString[x],4,54)  + " "
	z := z + 1
	If z = 2
		LinhaPrint(cReturn)
		cReturn := ""
		If li > 58
			LinhaPrint(cCabec)
		EndIf
		z := 0
	EndIf
Next
Return cReturn

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³PrintLogOp³ Autor ³ TOTVS                 ³ Data ³ Jan/2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ FUNCAO PARA IMPRIMIR OS OPERAÇÕES DO USUARIO               ³±±
±±³		     ³	                                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CSU                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function PrintLogOp(cLog)
Local cString := ""
Local aLogs
Local nI

aLogs := { 	STR0066,; //"Processos"
STR0067,; //"Inclusão de Reg."
STR0068,; //"Alteração de Reg."
STR0069,; //"Relatórios"
STR0070,; //"Transações"
STR0018,; //"e-Mail"
STR0071} //"Resposta de Parametros"

LinhaPrint(STR0072) //"Log de OperaçÕes do Sistema"
For nI := 1 To 7
	If li > 58
		LinhaPrint(STR0072) //"Log de OperaçÕes do Sistema"
	Endif
	If Subs(cLog,nI,1) == "S"
		cString := Padr(aLogs[nI],27) + STR0073 //" - Sim"
	ElseIf Subs(cLog,nI,1) == "N"
		cString := Padr(aLogs[nI],27) + STR0074 //" - Não"
	Else
		cString := Padr(aLogs[nI],27) + STR0075 //" - Padrão"
	EndIf
	LinhaPrint("",cString)
Next nI
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ValidPerg ³ Autor ³ Renato Carlos         ³ Data ³ Jan/2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Função para criação do SX1 da rotina                       ³±±
±±³		     ³	                                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CSU                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ValidPerg(Pg)

_sAlias := Alias()

dbSelectArea("SX1")
dbSetOrder(1)
_cPerg := PADR(Pg,LEN(SX1->X1_GRUPO))
aRegs:={}

aAdd(aRegs,{_cPerg,"01","Tipo de Impressão      	  ?","","","mv_ch1","N",01,0,0,"C","","mv_par01","Analitica","","","","","Sintetica","","","","","","","","","","","","","","","","","","","","","","          "})
aAdd(aRegs,{_cPerg,"02","Imprimir            	  	  ?","","","mv_ch2","N",01,0,0,"C","","mv_par02","Grupos","","","","","Usuarios","","","","","Filial","","","","","","","","","","","","","","","","","          "})
aAdd(aRegs,{_cPerg,"03","Grupo de             		  ?","","","mv_ch3","C",15,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","          "})
aAdd(aRegs,{_cPerg,"04","Grupo ate            		  ?","","","mv_ch4","C",15,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","          "})
aAdd(aRegs,{_cPerg,"05","Usuario de           		  ?","","","mv_ch5","C",15,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","          "})
aAdd(aRegs,{_cPerg,"06","Usuario ate           		  ?","","","mv_ch6","C",15,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","          "})
aAdd(aRegs,{_cPerg,"07","Ordenar Por           		  ?","","","mv_ch7","N",01,0,0,"C","","mv_par07","Id","","","","","Usuário de Rede","","","","","Nome","","","","","","","","","","","","","","   ","","","          "})
aAdd(aRegs,{_cPerg,"08","Quebra por Grupo/Usr/Filial ?","","","mv_ch8","N",01,0,0,"C","","mv_par08","Sim","","","","","Não","","","","","","","","","","","","","","","","","","","   ","","","          "})
aAdd(aRegs,{_cPerg,"09","Visualizar Demitidos		  ?","","","mv_ch9","N",01,0,0,"C","","mv_par09","Sim","","","","","Não","","","","","","","","","","","","","","","","","","","   ","","","          "})
aAdd(aRegs,{_cPerg,"10","Filial de           		  ?","","","mv_c10","C",02,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","SM0"," 	","","          "})
AAdd(aRegs,{_cPerg,"11","Filial ate           		  ?","","","mv_c11","C",02,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","SM0","","","          "})


For i:=1 to Len(aRegs)
	If !dbSeek(_cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])//SALVA O CONTEUDO DO ARRAY NO BANCO
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Pergunte(Pg,.F.)

Return
