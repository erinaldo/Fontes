#include 'protheus.ch'
#include 'parmtype.ch'
#include 'topconn.ch'                                                    
#INCLUDE 'AP5MAIL.CH'
//-----------------------------------------------------------------------
/*{Protheus.doc} ASCTBA07
@Executa a consolidação entre as empresas, executado via StartJob rotina ASCTBA06
@param		_aParNew
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------
USER FUNCTION ASCTBA07(_aParNew)         
Local cQ   		:= ""
Local cSeqAtu	:= ""
Local aEmpOri	:= {} 
Local lRet      := .T.
Local cMail 	:= _aParNew[8]
Private cEstr    	:= 	_aParNew[3]
Private dDataIni 	:= 	_aParNew[4]
Private dDataFim 	:= 	_aParNew[5]
Private lSche		:= 	_aParNew[6]
Private cEmpList	:=  ""
Private cContaList	:=  ""

cEmpAnt		:=	_aParNew[1]
cFilAnt		:=	_aParNew[2]

RpcSetType( 3 )
RpcSetEnv( cEmpAnt, cFilAnt ,,,'CTB')

cUserName := _aParNew[7]

cQ := "SELECT Z6_CODIGO, Z6_EMP, Z6_SEQ , Z6_EMPCONS, Z6_TPSALDO, Z6_PER, Z6_EMPPAR "
cQ += " FROM "+RetSqlName("SZ6")+" SZ6 "   
cQ += " WHERE Z6_CODIGO = '"+cEstr+"'"
cQ += " AND D_E_L_E_T_ = ' '"
cQ += " ORDER BY Z6_SEQ, Z6_EMP ASC "
TcQuery ChangeQuery(cQ) ALIAS "XSZ6" NEW	
		                                                                             
//Exclui LOG Antigo - CV8
TCSQLEXEC("DELETE FROM "+U_RtTab("CV8",cEmpAnt)+" WHERE  CV8_INFO = '6' and CV8_PROC = 'ASCTBA07' and CV8_FILIAL = '" + xFilial("CV8") + "' " )
TcRefresh(U_RtTab("CV8",cEmpAnt))	    
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿     
//³ Inicializa o log de processamento   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ProcLogIni( {},"ASCTBA07")
ProcLogAtu("MENSAGEM",OemToAnsi("*** INICIO ***  da consolidacao")    							,"","ASCTBA07")
ProcLogAtu("MENSAGEM",OemToAnsi("<Parâmetros> Estrutura: "+cEstr)							 	,"","ASCTBA07") 
ProcLogAtu("MENSAGEM",OemToAnsi("<Parâmetros> Periodo: "+DTOC(dDataIni)+" a "+DTOC(dDataFim))	,"","ASCTBA07") 
ProcLogAtu("MENSAGEM",OemToAnsi("<Parâmetros> Email: "+cMail)									,"","ASCTBA07") 

WHILE XSZ6->(!EOF())
	cSeqAtu := XSZ6->Z6_SEQ
	aEmpOri:= {}
		     
	// Carrega a lista de consolidação da sequencia atual			     
    WHILE XSZ6->(!EOF()) .AND. XSZ6->Z6_SEQ == cSeqAtu          
		AADD(aEmpOri,	{SUBSTR(XSZ6->Z6_EMPCONS,3,7),;	  				//1- Codigo da empresa origem
						SUBSTR(XSZ6->Z6_EMPCONS,1,2),;			      	//2- Codigo do grupo de empresa origem
						RetSqlName("CT2"),;  							//3- CT2 da consolidada
						RetSqlName("CTF"),;  							//4- CTF da consolidada			
						U_RtTab("CT2",SUBSTR(XSZ6->Z6_EMPCONS,1,2)),; 	//5- CT2 da origem
						XSZ6->Z6_TPSALDO,;                            	//6- Tipo de Saldo
						100,;                                			//7- Percentual de consolidação
						SUBSTR(XSZ6->Z6_EMP,3,7),;                    	//8- Codigo da empresa consolidada
						SUBSTR(XSZ6->Z6_EMP,1,2),;					  	//9- Codigo do grupo de empresa consolidada
						XSZ6->Z6_CODIGO,;                              	//10-Codigo da estrutura de consolidação
						XSZ6->Z6_EMPCONS,;                            	//11-Codigo completo da origem
						XSZ6->Z6_EMPPAR,;                             	//12-Codigo completo da empresa de participação
						XSZ6->Z6_SEQ})     		              		    //13-Sequencia de consolidação    
				
		cQ := "SELECT Z0_CONTA, Z0_ITEMCTA FROM "+RetSqlName("SZ0")+" WHERE Z0_DTREVIS = '"+DTOS(FirstDay(dDataIni))+"' AND Z0_EMPRESA = '"+XSZ6->Z6_EMPCONS+"' AND D_E_L_E_T_ = ' ' "
		TcQuery ChangeQuery(cQ) ALIAS "XSZ0" NEW
		
		IF XSZ0->(!EOF()) 
			IF !EMPTY(XSZ0->Z0_ITEMCTA)
				IF !EMPTY(cEmpList)
					cEmpList += ","
				ENDIF
				cEmpList += XSZ0->Z0_ITEMCTA
			ELSE        
				IF !EMPTY(XSZ0->Z0_CONTA)                    
					IF !EMPTY(cContaList)
						cContaList += ","
					ENDIF
					cContaList += XSZ0->Z0_CONTA
				ENDIF
			ENDIF
   		ENDIF
   	 	XSZ0->(DBCLOSEAREA())
		XSZ6->(DBSKIP())        
	END
			      
   	IF LEN(aEmpOri) > 0                                                                                        
						
		ProcLogAtu("MENSAGEM",OemToAnsi("Consolidação para: "+aEmpOri[1][9]+aEmpOri[1][8]),"Itens contábeis: "+cEmpList,"ASCTBA07")

		lRet := CONSOLIDA(aEmpOri)      
		
	ENDIF					
			            
	IF !lRet

		ProcLogAtu("ERRO",OemToAnsi("Erro de consolidação para Consolidada: "+aEmpOri[1][9]+aEmpOri[1][8]),"","ASCTBA07")

		EXIT
	ENDIF

	ProcLogAtu("MENSAGEM",OemToAnsi("Reprocessa saldos contábeis: "+aEmpOri[1][9]+aEmpOri[1][8]),"","ASCTBA07")
				        
	// Reprocesso a empresa/filial consolidada para atualizar os movimentos consolidados
	Processa( { || REPROCES({dDataIni, dDataFim, aEmpOri[1][9],aEmpOri[1][8]} ) }, "Reprocessando CTB . . .")              	       			
                                               
	ProcLogAtu("MENSAGEM",OemToAnsi("Gera lançamentos de eliminação dos investimentos: "+aEmpOri[1][9]+aEmpOri[1][8]),"","ASCTBA07")

	// Efetua os lançamentos de eliminação da árvore
  	ELIMINA(aEmpOri,dDataIni, dDataFim)
				    
	ProcLogAtu("MENSAGEM",OemToAnsi("Fim da Consolidação para: "+aEmpOri[1][9]+aEmpOri[1][8]),"","ASCTBA07")

END			
XSZ6->(DBCLOSEAREA())    

ProcLogAtu("MENSAGEM",OemToAnsi("*** FIM *** das consolidações."),"","ASCTBA07")

IF !EMPTY(cMail)
	EnvMailA( "PROTHEUS - Consolidação." , "Concluido o processo de consolidação do periodo: "+DTOC(dDataIni)+" a "+DTOC(dDataFim) ,cMail )   	
ENDIF
ProcLogAtu("FIM","ASCTBA07")

RpcClearEnv()                         

FreeUsedCode(.T.)
                                                      
RETURN                            
//-----------------------------------------------------------------------
/*{Protheus.doc} CONSOLIDA
@Processa a consolidação entre as empresas
@param		aEmpOri
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------
Static Function CONSOLIDA(aEmpOri)
Local cProc		:= ""
Local cSQL		:= ''  
Local cCT2		:= aEmpOri[1][3]
Local cCT2Ori   := aEmpOri[1][5]
Local cOper		:= IIf(Upper(TcGetDb())$'ORACLE.POSTGRES.DB2.INFORMIX','||','+')
Local cDataIni	:= DTOS(dDataIni)
Local cDataFim	:= DTOS(dDataFim)
Local cQ  		:= ""                                
Local cFilCons  := aEmpOri[1][8]                     
Local nRegMin   := 0
Local nRegMax   := 0
Local nConta    := 0
Local cSemaforo := "" 
Local aSemaforo := {}        
Local aSema		:= {}        
Local _aPar1	:= {}
Local lContinua	:= .T.
Local nRegIni	:= 0
Local nRegCons  := 0
Local nRet		:= 0
Local nVezes	:= 0
Local nX                    
Local aCons     := {}                                                               

ProcLogAtu("MENSAGEM",OemToAnsi("Exclusão do periodo existente."),"","CONSOLIDA")	
                                                                
// Exclui os registros da consolidadora 

cQ:= "Select IsNull(Min( R_E_C_N_O_), 0) MinRecno , IsNull(Max( R_E_C_N_O_ ), 0 ) MaxRecno"+CRLF
cQ+= "     From "+CCT2
cQ+= "     Where CT2_FILIAL = '"+SUBSTR(cFilCons,1,LEN(ALLTRIM(XFILIAL("CT2"))))+"'"+CRLF  
cQ+= "     and CT2_DATA >= '"+cDataIni+"' AND CT2_DATA <= '"+cDataFim+"'"+CRLF
cQ+= "     and D_E_L_E_T_ = ' '"+CRLF 
TcQuery ChangeQuery(cQ) ALIAS "XCT2" NEW
nRegMin := XCT2->MinRecno
nRegMax := XCT2->MaxRecno
XCT2->(DBCLOSEAREA())

_aPar1 := {}
aAdd(_aPar1, aEmpOri[1][09])   
aAdd(_aPar1, aEmpOri[1][08])
aAdd(_aPar1, cDataIni)
aAdd(_aPar1, cDataFim)
aAdd(_aPar1, CCT2)  
aAdd(_aPar1, cFilCons)                                                                            
aAdd(_aPar1, nRegMin)                                                                            		
aAdd(_aPar1, nRegMax)                                                                            		
			
lContinua := U_ASCTBA7E(_aPar1) 
		
ProcLogAtu("MENSAGEM",OemToAnsi("Termino das exclusões."),"","CONSOLIDA")				

TcRefresh(CCT2)	    

IF !lContinua
	Return(lContinua)
ENDIF
                                                                                    
// Consolidação dos movimentos 

ProcLogAtu("MENSAGEM",OemToAnsi("Procedure de consolidacao CTB."),"","CONSOLIDA")	

aSemaforo := {}  

// Pega o maior recno atual
cQ :="SELECT isnull(max(R_E_C_N_O_),0) MAXREC from "+cCT2+" "+CRLF		
TcQuery ChangeQuery(cQ) ALIAS "XCT2" NEW
nRegIni := XCT2->MAXREC + 1000
XCT2->(DBCLOSEAREA())
      
For nX:=1 to Len(aEmpOri)       
                     
	IF aEmpOri[nX][7] <> 0  // Percentual de consolidação
    
		_aPar1 := {}
		aAdd(_aPar1, aEmpOri[1][09])   
		aAdd(_aPar1, aEmpOri[1][08])
               
        cSemaforo := "CONSOLIDA_CONSOLIDA_"+aEmpOri[nX][11]+"_"+StrTran(TIME(), ":", "")
		aAdd(_aPar1, cSemaforo)                                                                            	            
                
		cProc := 'ASCTBA07_'+CriaTrab(nil,.F.) 		

		ProcLogAtu("MENSAGEM",OemToAnsi("Verifica quantos registros serao processados."),"","CONSOLIDA")				

		cCT2Ori   := aEmpOri[nX][5]           

        // Verifica quantos registros serão processados
		cQ:="SELECT COUNT(*) TOTREG "
		cQ+="from "+cCT2Ori+" CT2 "
		cQ+="where CT2_FILIAL='"+SUBSTR(aEmpOri[nX][1],1,3)+"' AND CT2_EMPORI = '"+aEmpOri[nX][2]+"'"
		cQ+="and CT2_DATA >= '"+cDataIni+"' and CT2_DATA <= '"+cDataFim+"'"
		IF aEmpOri[nX][6] <> '*'
			cQ+=" 	and CT2_TPSALD = '"+aEmpOri[nX][6]+"'"
		ELSE
			cQ+=" 	and CT2_TPSALD <> '9' "
		ENDIF	                           
		cQ+=" 	and CT2.D_E_L_E_T_=' '"

		TcQuery ChangeQuery(cQ) ALIAS "XCT2" NEW
		nRegCons := XCT2->TOTREG
		XCT2->(DBCLOSEAREA())
                                                   
		ProcLogAtu("MENSAGEM",OemToAnsi("Cria procedure empresa: "+aEmpOri[nX][11]),"","CONSOLIDA")				

		// Cria a Stored Procedure
		cSQL:="create procedure "+cProc+" (@OUT_RET int output) as"+CRLF
		cSQL+=" "+CRLF
		cSQL+="declare @empori		varchar(2)"+CRLF  
		cSQL+="declare @filori		varchar("+STR(TAMSX3("CT2_FILIAL")[1])+")"+CRLF   
		cSQL+="declare @filial		varchar("+STR(TAMSX3("CT2_FILIAL")[1])+")"+CRLF  
		cSQL+="declare @tpsald		char(1)"+CRLF
		cSQL+="declare @ctadb		varchar("+STR(TAMSX3("CT2_DEBITO")[1])+")"+CRLF
		cSQL+="declare @ccdb		varchar("+STR(TAMSX3("CT2_CCD")[1])+")"+CRLF
		cSQL+="declare @itemdb		varchar("+STR(TAMSX3("CT2_ITEMD")[1])+")"+CRLF
		cSQL+="declare @clvldb		varchar("+STR(TAMSX3("CT2_CLVLDB")[1])+")"+CRLF
		cSQL+="declare @ctacr		varchar("+STR(TAMSX3("CT2_CREDIT")[1])+")"+CRLF
		cSQL+="declare @cccr		varchar("+STR(TAMSX3("CT2_CCD")[1])+")"+CRLF
		cSQL+="declare @itemcr		varchar("+STR(TAMSX3("CT2_ITEMC")[1])+")"+CRLF
		cSQL+="declare @clvlcr		varchar("+STR(TAMSX3("CT2_CLVLDB")[1])+")"+CRLF  
		cSQL+="declare @bkctadb		varchar("+STR(TAMSX3("CT2_DEBITO")[1])+")"+CRLF
		cSQL+="declare @bkccdb		varchar("+STR(TAMSX3("CT2_CCD")[1])+")"+CRLF
		cSQL+="declare @bkitemdb	varchar("+STR(TAMSX3("CT2_ITEMD")[1])+")"+CRLF
		cSQL+="declare @bkclvldb	varchar("+STR(TAMSX3("CT2_CLVLDB")[1])+")"+CRLF
		cSQL+="declare @bkctacr		varchar("+STR(TAMSX3("CT2_CREDIT")[1])+")"+CRLF
		cSQL+="declare @bkcccr		varchar("+STR(TAMSX3("CT2_CCD")[1])+")"+CRLF
		cSQL+="declare @bkitemcr	varchar("+STR(TAMSX3("CT2_ITEMC")[1])+")"+CRLF
		cSQL+="declare @bkclvlcr	varchar("+STR(TAMSX3("CT2_CLVLDB")[1])+")"+CRLF  
		cSQL+="declare @valor		numeric("+STR(TAMSX3("CT2_VALOR")[1])+","+STR(TAMSX3("CT2_VALOR")[2])+")"+CRLF
		cSQL+="declare @dlan		char(8)"+CRLF
		cSQL+="declare @hist		varchar("+STR(TAMSX3("CT2_HIST")[1])+")"+CRLF  
		cSQL+="declare @dtlp		char(8)"+CRLF
		cSQL+="declare @moeda		varchar(2)"+CRLF
		cSQL+="declare @tipo		char(1)"+CRLF
		cSQL+="declare @lote		varchar("+STR(TAMSX3("CT2_LOTE")[1])+")"+CRLF
		cSQL+="declare @sub		    varchar("+STR(TAMSX3("CT2_SBLOTE")[1])+")"+CRLF
		cSQL+="declare @docx	    varchar("+STR(TAMSX3("CT2_DOC")[1])+")"+CRLF
		cSQL+="declare @doc		    varchar("+STR(TAMSX3("CT2_DOC")[1])+")"+CRLF
		cSQL+="declare @linha		varchar("+STR(TAMSX3("CT2_LINHA")[1])+")"+CRLF
		cSQL+="declare @linhax		varchar("+STR(TAMSX3("CT2_LINHA")[1])+")"+CRLF
		cSQL+="declare @recCT2		int"+CRLF
		cSQL+="declare @i			int"+CRLF
		cSQL+="declare @dtant		char(8)"+CRLF
		cSQL+="declare @docant		varchar("+STR(TAMSX3("CT2_DOC")[1])+")"+CRLF      
		cSQL+="declare @xemp		varchar(9)"+CRLF  
		cSQL+="declare @xorigem     varchar("+STR(TAMSX3("CT2_ORIGEM")[1])+")"+CRLF         
		cSQL+="declare @seqlan      varchar(3)"+CRLF
		cSQL+="declare @seqhis      varchar(3)"+CRLF      
		cSQL+="declare @iBegin      integer"+CRLF   
		cSQL+="declare @elimind		varchar(1)"+CRLF  
		cSQL+="declare @eliminc		varchar(1)"+CRLF 
		cSQL+="declare @cttrans		varchar("+STR(TAMSX3("CT2_CREDIT")[1])+")"+CRLF		 
		cSQL+="declare @rotina		varchar("+STR(TAMSX3("CT2_ROTINA")[1])+")"+CRLF	  
		cSQL+="declare @debcre		char(1)"+CRLF 
			 
		cSQL+="select  @recCT2 = "+ALLTRIM(STR(nRegIni))+CRLF   // Atribui R_E_C_N_O_ inicial devido a mult-thread
		cSQL+="select  @OUT_RET=0"+CRLF                
		cSQL+= " "+CRLF

        cSQL+="Begin "+CRLF
		cSQL+=""+CRLF		
		cSQL+="		declare "+"cur"+STRZERO(nX,4)+" cursor for"+CRLF
		cSQL+="		select "+CRLF
		cSQL+="		'"+aEmpOri[nX][9]+"' as EMPORI,"+CRLF  //1
		cSQL+="		'"+aEmpOri[nX][8]+"' as FILORI,"+CRLF  //2
		cSQL+="		CT2_TPSALD,"+CRLF                      //3
		cSQL+="		CT2_DEBITO,"+CRLF                      //4
		cSQL+="		CT2_CCD,"+CRLF                         //5
		cSQL+="		CT2_ITEMD,"+CRLF                       //6
		cSQL+="		CT2_CLVLDB,"+CRLF                      //7
		cSQL+="		CT2_CREDIT,"+CRLF                      //8
		cSQL+="		CT2_CCC,"+CRLF                         //9
		cSQL+="		CT2_ITEMC,"+CRLF                       //10
		cSQL+="		CT2_CLVLCR,"+CRLF                      //11
		cSQL+="		CT2_VALOR  as VALOR,"+CRLF //20
		cSQL+="		CT2_DATA,"+CRLF 					   //21
		cSQL+="		CT2_HIST,"+CRLF                        //22
		cSQL+="		CT2_DTLP,"+CRLF                        //23
		cSQL+="		CT2_MOEDLC,"+CRLF                      //24
		cSQL+="		CT2_DC,"+CRLF                          //25
		IF SUBSTR(cCT2Ori,4,2) == aEmpOri[nX][09]                 // Verifica se é consolidadora da consolidadora, se for mantem a empresa original
			cSQL+="		CT2_XEMP as XEMP,"+CRLF			   //30
		ELSE                              
			cSQL+="		'"+aEmpOri[nX][11]+"' as XEMP,"+CRLF //30			          
		ENDIF	
		cSQL+="		CT2_ORIGEM,"+CRLF	                   //31
		cSQL+="		CT2_FILIAL, "+CRLF				       //33
		cSQL+="		CT2_LOTE, "+CRLF				       //34		
		cSQL+="		CT2_SBLOTE, "+CRLF				       //35				
		cSQL+="		CT2_LINHA, "+CRLF				       //36				
		cSQL+="		CT2_DOC, "+CRLF				           //37						
		cSQL+="		CT2_SEQHIS, "+CRLF				       //38								
		cSQL+="		CT2_SEQLAN, "+CRLF				       //39										
		cSQL+="		CT2_ROTINA  "+CRLF				       //40												
		cSQL+=" 	from "+cCT2Ori+" CT2 "+CRLF            
		cSQL+=" 	where CT2_EMPORI='"+aEmpOri[nX][2]+"'"+CRLF
		cSQL+="		and CT2_FILIAL = '"+SUBSTR(aEmpOri[nX][1],1,3)+"'"+CRLF
		cSQL+=" 	and CT2_DATA >= '"+cDataIni+"' and CT2_DATA <= '"+cDataFim+"'"+CRLF
		IF aEmpOri[nX][6] <> '*'
			cSQL+=" 	and CT2_TPSALD = '"+aEmpOri[nX][6]+"'"+CRLF
		ELSE
			cSQL+=" 	and CT2_TPSALD <> '9' "+CRLF		
		ENDIF	                           
		cSQL+=" 	and CT2.D_E_L_E_T_=' '"+CRLF
		cSQL+="     order by CT2_FILIAL,CT2_DATA,CT2_LOTE,CT2_SBLOTE,CT2_DOC,CT2_LINHA,CT2_TPSALD,EMPORI,FILORI,CT2_MOEDLC"+CRLF
		cSQL+="     For read only"+CRLF
		cSQL+=" "+CRLF		
		cSQL+="		open "+"cur"+STRZERO(nX,4)+" "+CRLF
		cSQL+=" 	fetch next from "+"cur"+STRZERO(nX,4)+" into "+CRLF
		cSQL+=" 	@empori,"+CRLF                        //01
		cSQL+=" 	@filori,"+CRLF                        //02
		cSQL+=" 	@tpsald,"+CRLF                        //03
		cSQL+=" 	@ctadb,"+CRLF                         //04
		cSQL+=" 	@ccdb,"+CRLF                          //05
		cSQL+=" 	@itemdb,"+CRLF                        //06
		cSQL+=" 	@clvldb,"+CRLF                        //07
		cSQL+=" 	@ctacr,"+CRLF                         //08
		cSQL+=" 	@cccr,"+CRLF                          //09
		cSQL+=" 	@itemcr,"+CRLF                        //10
		cSQL+=" 	@clvlcr,"+CRLF                        //11
		cSQL+=" 	@valor,"+CRLF                         //20
		cSQL+=" 	@dlan,"+CRLF                          //21
		cSQL+=" 	@hist,"+CRLF                          //22         
		cSQL+=" 	@dtlp,"+CRLF                          //23
		cSQL+=" 	@moeda,"+CRLF                         //24
		cSQL+=" 	@tipo,"+CRLF                          //25
		cSQL+=" 	@xemp,"+CRLF                          //30
		cSQL+=" 	@xorigem,"+CRLF                       //31
		cSQL+=" 	@filial,"+CRLF                        //33		
		cSQL+=" 	@lote,"+CRLF                          //34				
		cSQL+=" 	@sub,"+CRLF                           //35				
		cSQL+=" 	@linha,"+CRLF                         //36				
		cSQL+=" 	@doc,"+CRLF                           //37						
		cSQL+=" 	@seqhis,"+CRLF                        //38								
		cSQL+=" 	@seqlan,"+CRLF                        //39								
		cSQL+=" 	@rotina "+CRLF                        //40								
		
		cSQL+=" "+CRLF
		cSQL+="		select @dtant='XXXXXXXX', @linhax='000', @seqhis = '001', @seqlan = '000', @iBegin = 0"+CRLF
		cSQL+="     select @lote = '"+aEmpOri[nX][6]+LEFT(aEmpOri[nX][11],5)+"'"+CRLF   // Tipo de saldo + empresa
		cSQL+="     select @sub = '"+aEmpOri[nX][10]+"'"+CRLF  // Estrutura de consolidação		
		cSQL+=" "+CRLF
		cSQL+="		while @@FETCH_STATUS = 0 "+CRLF                         
		cSQL+="		begin"+CRLF     
		cSQL+=" 		Select @debcre = 'X'"+CRLF				                                                                            		                                                                                                                                    

		cSQL+=" 		IF @tipo <> '4' Begin "+CRLF				                                                                            		
		
		// Eliminação de partes relacionadas
		
//DEBITO + CREDITO		

		cSQL+=" 		Select @elimind = CT1_XELIM from "+RetSqlName("CT1")+" where CT1_FILIAL = '"+XFILIAL("CT1")+"' and CT1_CONTA = @ctadb and D_E_L_E_T_ = ' ' "+CRLF                       
		cSQL+=" 		Select @eliminc = CT1_XELIM from "+RetSqlName("CT1")+" where CT1_FILIAL = '"+XFILIAL("CT1")+"' and CT1_CONTA = @ctacr and D_E_L_E_T_ = ' ' "+CRLF                       
		IF !EMPTY(cEmpList) .AND. !EMPTY(cContaList)
			cSQL+=" 		if ( @elimind = 'S' and ( @itemdb in "+Formatin(cEmpList,",")+" or @ctadb in "+Formatin(cContaList,",")+" ) ) and ( @eliminc = 'S' and ( @itemcr in "+Formatin(cEmpList,",")+" or @ctacr in "+Formatin(cContaList,",")+") ) "+CRLF
		ELSEIF !EMPTY(cEmpList) 
			cSQL+=" 		if ( @elimind = 'S' and ( @itemdb in "+Formatin(cEmpList,",")+" ) ) and ( @eliminc = 'S' and ( @itemcr in "+Formatin(cEmpList,",")+") ) "+CRLF
		ELSEIF !EMPTY(cContaList) 
			cSQL+=" 		if ( @elimind = 'S' and ( @ctadb in "+Formatin(cContaList,",")+" ) ) and ( @eliminc = 'S' and ( @ctacr in "+Formatin(cContaList,",")+") ) "+CRLF
		ELSE
			cSQL+=" 		if ( @elimind = 'S' and @eliminc = 'S' ) "+CRLF		
		ENDIF
		cSQL+=" 			begin"+CRLF
		cSQL+=" 				select @cttrans = @ctadb"+CRLF
		cSQL+=" 				select @ctadb 	= @ctacr"+CRLF		
		cSQL+=" 				select @ctacr 	= @cttrans"+CRLF				
		
		cSQL+=" 				select @cttrans = @ccdb"+CRLF
		cSQL+=" 				select @ccdb 	= @cccr"+CRLF		
		cSQL+=" 				select @cccr 	= @cttrans"+CRLF				
		
		cSQL+=" 				select @cttrans = @itemdb"+CRLF
		cSQL+=" 				select @itemdb 	= @itemcr"+CRLF		
		cSQL+=" 				select @itemcr 	= @cttrans"+CRLF				
		
		cSQL+=" 				select @cttrans = @clvldb"+CRLF
		cSQL+=" 				select @clvldb 	= @clvlcr"+CRLF		
		cSQL+=" 				select @clvlcr 	= @cttrans"+CRLF				
		
		cSQL+=" 				select @tpsald = 'E'"+CRLF
		cSQL+=" 				select @debcre = 'S'"+CRLF		
		cSQL+=" 			end"+CRLF       

                                                       
// APENAS DEBITO

		IF !EMPTY(cEmpList) .AND. !EMPTY(cContaList)
			cSQL+=" 		if  @debcre = 'X' and @elimind = 'S' and ( @itemdb in "+Formatin(cEmpList,",")+" or @ctadb in "+Formatin(cContaList,",")+")"+CRLF
		ELSEIF !EMPTY(cEmpList) 
			cSQL+=" 		if  @debcre = 'X' and @elimind = 'S' and ( @itemdb in "+Formatin(cEmpList,",")+")"+CRLF
		ELSEIF !EMPTY(cContaList) 
			cSQL+=" 		if  @debcre = 'X' and @elimind = 'S' and ( @ctadb in "+Formatin(cContaList,",")+")"+CRLF
		ELSE
			cSQL+=" 		if ( @elimind = 'S' ) "+CRLF		
		ENDIF

		cSQL+=" 			begin"+CRLF
		cSQL+=" 				select @bkctacr  = @ctacr "+CRLF				
		cSQL+=" 				select @bkcccr   = @cccr "+CRLF				
		cSQL+=" 				select @bkitemcr = @itemcr "+CRLF				
		cSQL+=" 				select @bkclvlcr = @clvlcr "+CRLF				
		cSQL+=" 				select @bkctadb  = @ctadb "+CRLF				
		cSQL+=" 				select @bkccdb   = @ccdb "+CRLF				
		cSQL+=" 				select @bkitemdb = @itemdb "+CRLF				
		cSQL+=" 				select @bkclvldb = @clvldb "+CRLF				

		cSQL+=" 				select @ctacr 	= @ctadb"+CRLF				
		cSQL+=" 				select @cccr 	= @ccdb"+CRLF				
		cSQL+=" 				select @itemcr 	= @itemdb"+CRLF				
		cSQL+=" 				select @clvlcr 	= @clvldb"+CRLF				

		cSQL+=" 				select @ctadb 	= ''"+CRLF				
		cSQL+=" 				select @ccdb 	= ''"+CRLF				
		cSQL+=" 				select @itemdb 	= ''"+CRLF				
		cSQL+=" 				select @clvldb 	= ''"+CRLF				

		cSQL+=" 				select @debcre = 'D'"+CRLF		
		cSQL+=" 			end"+CRLF       

// APENAS CREDITO
		IF !EMPTY(cEmpList) .AND. !EMPTY(cContaList)
			cSQL+=" 		if  @debcre = 'X' and @eliminc = 'S' and ( @itemcr in "+Formatin(cEmpList,",")+" or @ctacr in "+Formatin(cContaList,",")+")"+CRLF
		ELSEIF !EMPTY(cEmpList) 
			cSQL+=" 		if  @debcre = 'X' and @eliminc = 'S' and ( @itemcr in "+Formatin(cEmpList,",")+")"+CRLF
		ELSEIF !EMPTY(cContaList) 
			cSQL+=" 		if  @debcre = 'X' and @eliminc = 'S' and ( @ctacr in "+Formatin(cContaList,",")+")"+CRLF
		ELSE
			cSQL+=" 		if ( @elimicr = 'S' ) "+CRLF		
		ENDIF
		cSQL+=" 			begin"+CRLF
		cSQL+=" 				select @bkctacr  = @ctacr "+CRLF				
		cSQL+=" 				select @bkcccr   = @cccr "+CRLF				
		cSQL+=" 				select @bkitemcr = @itemcr "+CRLF				
		cSQL+=" 				select @bkclvlcr = @clvlcr "+CRLF				
		cSQL+=" 				select @bkctadb  = @ctadb "+CRLF				
		cSQL+=" 				select @bkccdb   = @ccdb "+CRLF				
		cSQL+=" 				select @bkitemdb = @itemdb "+CRLF				
		cSQL+=" 				select @bkclvldb = @clvldb "+CRLF				

		cSQL+=" 				select @ctadb 	= @ctacr"+CRLF				
		cSQL+=" 				select @ccdb 	= @cccr"+CRLF				
		cSQL+=" 				select @itemdb 	= @itemcr"+CRLF				
		cSQL+=" 				select @clvldb 	= @clvlcr"+CRLF				

		cSQL+=" 				select @ctacr 	= ''"+CRLF				
		cSQL+=" 				select @cccr 	= ''"+CRLF				
		cSQL+=" 				select @itemcr 	= ''"+CRLF				
		cSQL+=" 				select @clvlcr 	= ''"+CRLF				

		cSQL+=" 				select @debcre = 'C'"+CRLF		
		cSQL+=" 			end"+CRLF       
		cSQL+=" "+CRLF
		cSQL+="			if @dtant<>@dlan "+CRLF
		cSQL+="				begin"+CRLF
		cSQL+="					select @dtant=@dlan"+CRLF 
		cSQL+="					select @linhax='000', @seqhis='001', @seqlan='000'"+CRLF
		cSQL+="					select @docx= '000000'"+CRLF				
		cSQL+="					select @i=convert(int,@docx)+1"+CRLF
		cSQL+="					select @docx=convert(varchar(6),@i)"+CRLF
		cSQL+="					while len(@docx)<6 "+CRLF
		cSQL+="		    			begin "+CRLF		                            			
		cSQL+=" 						select @docx='0' "+cOper+" @docx"+CRLF		
		cSQL+="             		end "+CRLF				
		cSQL+="             end "+CRLF		

		cSQL+="			if @linhax='998'"+CRLF // ATINGIU O LIMITE DA NUMERAÇÃO DE LINHA, REINICIA O CONTADOR DE LINHA E INCREMENTA O DOCUMENTO
		cSQL+="		    	begin "+CRLF		                            	
		cSQL+=" 	    		select @linhax='001', @seqhis='001', @seqlan='001'"+CRLF		                            	
		cSQL+="					select @i=convert(int,@docx)+1"+CRLF
		cSQL+="					select @docx=convert(varchar(6),@i)"+CRLF
		cSQL+="					while len(@docx)<6 "+CRLF
		cSQL+="		    			begin "+CRLF		                            			
		cSQL+=" 						select @docx='0' "+cOper+" @docx "+CRLF		
		cSQL+="             		end "+CRLF				
		cSQL+="				end"+CRLF	
		cSQL+="			else"+CRLF              
		cSQL+="				begin"+CRLF
		cSQL+="					select @i=convert(int,@linhax)+1"+CRLF
		cSQL+="					select @linhax=convert(varchar(3),@i)"+CRLF
		cSQL+="					while len(@linhax)<3 "+CRLF 		
		cSQL+="		    			begin "+CRLF		                            			
		cSQL+=" 						select @linhax='0' "+cOper+" @linhax "+CRLF		
		cSQL+="             		end "+CRLF				
		cSQL+="				end "+CRLF	

		cSQL+="         if @tipo <> '4'"+CRLF
		cSQL+="             Begin "+CRLF							                              
		cSQL+="					select @i=convert(int,@seqlan)+1, @seqhis='001'"+CRLF
		cSQL+="					select @seqlan=convert(varchar(3),@i)"+CRLF
		cSQL+="					while len(@seqlan)<3 "+CRLF 		
		cSQL+="		    			begin "+CRLF		                            			
		cSQL+=" 						select @seqlan='0' "+cOper+" @seqlan"+CRLF		
		cSQL+="             		end "+CRLF				
		cSQL+="				end"+CRLF
		cSQL+=" "+CRLF		
        cSQL+="			if @debcre = 'D'"+CRLF
        cSQL+="				Begin
		cSQL+="				select @recCT2 = @recCT2 + 1"+CRLF		   
		cSQL+=" "+CRLF
		cSQL+="				insert into "+cCT2+" "+CRLF
		cSQL+=" 			(CT2_FILIAL,"+CRLF
		cSQL+=" 			CT2_DATA,"+CRLF
		cSQL+=" 			CT2_LOTE,"+CRLF
		cSQL+=" 			CT2_SBLOTE,"+CRLF
		cSQL+=" 			CT2_DOC,"+CRLF
		cSQL+=" 			CT2_LINHA,"+CRLF
		cSQL+=" 			CT2_MOEDLC,"+CRLF
		cSQL+=" 			CT2_DC,"+CRLF
		cSQL+=" 			CT2_DEBITO,"+CRLF
		cSQL+=" 			CT2_CREDIT,"+CRLF
		cSQL+=" 			CT2_VALOR,"+CRLF
		cSQL+=" 			CT2_HIST,"+CRLF
		cSQL+=" 			CT2_CCD,"+CRLF
		cSQL+=" 			CT2_CCC,"+CRLF
		cSQL+=" 			CT2_ITEMD,"+CRLF                                
		cSQL+=" 			CT2_ITEMC,"+CRLF
		cSQL+=" 			CT2_CLVLDB,"+CRLF
		cSQL+=" 			CT2_CLVLCR,"+CRLF
		cSQL+=" 			CT2_EMPORI,"+CRLF
		cSQL+=" 			CT2_FILORI,"+CRLF
		cSQL+=" 			CT2_TPSALD,"+CRLF
		cSQL+=" 			CT2_DTLP,"+CRLF
		cSQL+=" 			CT2_MANUAL,"+CRLF
		cSQL+=" 			CT2_ROTINA,"+CRLF
		cSQL+=" 			CT2_AGLUT,"+CRLF
		cSQL+=" 			CT2_SEQHIS,"+CRLF
		cSQL+=" 			CT2_SEQLAN,"+CRLF
		cSQL+=" 			CT2_TAXA,"+CRLF
		cSQL+=" 			CT2_VLR01,"+CRLF
		cSQL+=" 			CT2_VLR02,"+CRLF
		cSQL+=" 			CT2_VLR03,"+CRLF
		cSQL+=" 			CT2_VLR04,"+CRLF
		cSQL+=" 			CT2_VLR05,"+CRLF
		cSQL+=" 			CT2_CRCONV,"+CRLF
		cSQL+=" 			CT2_CTLSLD,"+CRLF
		cSQL+=" 			CT2_XEMP,"+CRLF
		cSQL+=" 			CT2_ORIGEM,"+CRLF  
		cSQL+=" 			R_E_C_N_O_,"+CRLF
		cSQL+=" 			R_E_C_D_E_L_ )"+CRLF
		cSQL+=" 			values "+CRLF
		cSQL+=" 			( '"+SUBSTR(cFilCons,1,LEN(ALLTRIM(XFILIAL("CT2"))))+"',"+CRLF
		cSQL+=" 			@dlan,"+CRLF
		cSQL+=" 			@lote,"+CRLF
		cSQL+=" 			@sub,"+CRLF
		cSQL+=" 			@docx,"+CRLF
		cSQL+=" 			@linhax,"+CRLF
		cSQL+=" 			@moeda,"+CRLF
		cSQL+=" 			'2',"+CRLF
		cSQL+=" 			@ctadb,"+CRLF
		cSQL+=" 			@ctacr,"+CRLF
		cSQL+=" 			@valor,"+CRLF
		cSQL+=" 			@hist,"+CRLF
		cSQL+=" 			@ccdb,"+CRLF
		cSQL+=" 			@cccr,"+CRLF
		cSQL+=" 			@itemdb,"+CRLF
		cSQL+=" 			@itemcr,"+CRLF
		cSQL+=" 			@clvldb,"+CRLF
		cSQL+=" 			@clvlcr,"+CRLF
		cSQL+=" 			@empori,"+CRLF
		cSQL+=" 			@filori,"+CRLF
		cSQL+=" 			'E',"+CRLF
		cSQL+=" 			@dtlp,"+CRLF
		cSQL+=" 			'1',"+CRLF
		cSQL+=" 			@rotina,"+CRLF
		cSQL+=" 			'1',"+CRLF
		cSQL+=" 			@seqhis,"+CRLF
		cSQL+="    			@seqlan,"+CRLF
		cSQL+=" 			0,"+CRLF
		cSQL+=" 			0,"+CRLF
		cSQL+=" 			0,"+CRLF
		cSQL+=" 			0,"+CRLF
		cSQL+=" 			0,"+CRLF
		cSQL+=" 			0,"+CRLF
		cSQL+=" 			'1',"+CRLF
		cSQL+=" 			'0',"+CRLF
		cSQL+=" 			@xemp,"+CRLF
		cSQL+=" 			@xorigem,"+CRLF
		cSQL+=" 			@recCT2,"+CRLF
		cSQL+=" 			0)"+CRLF            

		cSQL+=" 			select @ctacr  = @bkctacr "+CRLF				
		cSQL+=" 			select @cccr   = @bkcccr "+CRLF				
		cSQL+=" 			select @itemcr = @bkitemcr "+CRLF				
		cSQL+=" 			select @clvlcr = @bkclvlcr "+CRLF				
		cSQL+="				select @tipo = '2'
		cSQL+=" 			End "+CRLF            		

		cSQL+=" "+CRLF		
        cSQL+="			if @debcre = 'C'"+CRLF
        cSQL+="				Begin
		cSQL+="				select @recCT2 = @recCT2 + 1"+CRLF		   
		cSQL+=" "+CRLF
		cSQL+="				insert into "+cCT2+" "+CRLF
		cSQL+=" 			(CT2_FILIAL,"+CRLF
		cSQL+=" 			CT2_DATA,"+CRLF
		cSQL+=" 			CT2_LOTE,"+CRLF
		cSQL+=" 			CT2_SBLOTE,"+CRLF
		cSQL+=" 			CT2_DOC,"+CRLF
		cSQL+=" 			CT2_LINHA,"+CRLF
		cSQL+=" 			CT2_MOEDLC,"+CRLF
		cSQL+=" 			CT2_DC,"+CRLF
		cSQL+=" 			CT2_DEBITO,"+CRLF
		cSQL+=" 			CT2_CREDIT,"+CRLF
		cSQL+=" 			CT2_VALOR,"+CRLF
		cSQL+=" 			CT2_HIST,"+CRLF
		cSQL+=" 			CT2_CCD,"+CRLF
		cSQL+=" 			CT2_CCC,"+CRLF
		cSQL+=" 			CT2_ITEMD,"+CRLF                                
		cSQL+=" 			CT2_ITEMC,"+CRLF
		cSQL+=" 			CT2_CLVLDB,"+CRLF
		cSQL+=" 			CT2_CLVLCR,"+CRLF
		cSQL+=" 			CT2_EMPORI,"+CRLF
		cSQL+=" 			CT2_FILORI,"+CRLF
		cSQL+=" 			CT2_TPSALD,"+CRLF
		cSQL+=" 			CT2_DTLP,"+CRLF
		cSQL+=" 			CT2_MANUAL,"+CRLF
		cSQL+=" 			CT2_ROTINA,"+CRLF
		cSQL+=" 			CT2_AGLUT,"+CRLF
		cSQL+=" 			CT2_SEQHIS,"+CRLF
		cSQL+=" 			CT2_SEQLAN,"+CRLF
		cSQL+=" 			CT2_TAXA,"+CRLF
		cSQL+=" 			CT2_VLR01,"+CRLF
		cSQL+=" 			CT2_VLR02,"+CRLF
		cSQL+=" 			CT2_VLR03,"+CRLF
		cSQL+=" 			CT2_VLR04,"+CRLF
		cSQL+=" 			CT2_VLR05,"+CRLF
		cSQL+=" 			CT2_CRCONV,"+CRLF
		cSQL+=" 			CT2_CTLSLD,"+CRLF
		cSQL+=" 			CT2_XEMP,"+CRLF
		cSQL+=" 			CT2_ORIGEM,"+CRLF  
		cSQL+=" 			R_E_C_N_O_,"+CRLF
		cSQL+=" 			R_E_C_D_E_L_ )"+CRLF
		cSQL+=" 			values "+CRLF
		cSQL+=" 			( '"+SUBSTR(cFilCons,1,LEN(ALLTRIM(XFILIAL("CT2"))))+"',"+CRLF
		cSQL+=" 			@dlan,"+CRLF
		cSQL+=" 			@lote,"+CRLF
		cSQL+=" 			@sub,"+CRLF
		cSQL+=" 			@docx,"+CRLF
		cSQL+=" 			@linhax,"+CRLF
		cSQL+=" 			@moeda,"+CRLF
		cSQL+=" 			'1',"+CRLF
		cSQL+=" 			@ctadb,"+CRLF
		cSQL+=" 			@ctacr,"+CRLF
		cSQL+=" 			@valor,"+CRLF
		cSQL+=" 			@hist,"+CRLF
		cSQL+=" 			@ccdb,"+CRLF
		cSQL+=" 			@cccr,"+CRLF
		cSQL+=" 			@itemdb,"+CRLF
		cSQL+=" 			@itemcr,"+CRLF
		cSQL+=" 			@clvldb,"+CRLF
		cSQL+=" 			@clvlcr,"+CRLF
		cSQL+=" 			@empori,"+CRLF
		cSQL+=" 			@filori,"+CRLF
		cSQL+=" 			'E',"+CRLF
		cSQL+=" 			@dtlp,"+CRLF
		cSQL+=" 			'1',"+CRLF
		cSQL+=" 			@rotina,"+CRLF
		cSQL+=" 			'1',"+CRLF
		cSQL+=" 			@seqhis,"+CRLF
		cSQL+="    			@seqlan,"+CRLF
		cSQL+=" 			0,"+CRLF
		cSQL+=" 			0,"+CRLF
		cSQL+=" 			0,"+CRLF
		cSQL+=" 			0,"+CRLF
		cSQL+=" 			0,"+CRLF
		cSQL+=" 			0,"+CRLF
		cSQL+=" 			'1',"+CRLF
		cSQL+=" 			'0',"+CRLF
		cSQL+=" 			@xemp,"+CRLF
		cSQL+=" 			@xorigem,"+CRLF
		cSQL+=" 			@recCT2,"+CRLF
		cSQL+=" 			0)"+CRLF            

		cSQL+=" 			select @ctadb  = @bkctadb "+CRLF				
		cSQL+=" 			select @ccdb   = @bkccdb "+CRLF				
		cSQL+=" 			select @itemdb = @bkitemdb "+CRLF				
		cSQL+=" 			select @clvldb = @bkclvldb "+CRLF				
		cSQL+="				select @tipo = '1'
		cSQL+=" 			End "+CRLF            		
		cSQL+=" 		End "+CRLF            		
  
		cSQL+="			select @i=convert(int,@linhax)+1"+CRLF
		cSQL+="			select @linhax=convert(varchar(3),@i)"+CRLF
		cSQL+="			while len(@linhax)<3 "+CRLF 		
		cSQL+="		    	begin "+CRLF		                            			
		cSQL+=" 				select @linhax='0' "+cOper+" @linhax "+CRLF		
		cSQL+="         	end "+CRLF				

		cSQL+="			select @recCT2 = @recCT2 + 1"+CRLF		   
		cSQL+=" "+CRLF
		cSQL+="			insert into "+cCT2+" "+CRLF
		cSQL+=" 		(CT2_FILIAL,"+CRLF
		cSQL+=" 		CT2_DATA,"+CRLF
		cSQL+=" 		CT2_LOTE,"+CRLF
		cSQL+=" 		CT2_SBLOTE,"+CRLF
		cSQL+=" 		CT2_DOC,"+CRLF
		cSQL+=" 		CT2_LINHA,"+CRLF
		cSQL+=" 		CT2_MOEDLC,"+CRLF
		cSQL+=" 		CT2_DC,"+CRLF
		cSQL+=" 		CT2_DEBITO,"+CRLF
		cSQL+=" 		CT2_CREDIT,"+CRLF
		cSQL+=" 		CT2_VALOR,"+CRLF
		cSQL+=" 		CT2_HIST,"+CRLF
		cSQL+=" 		CT2_CCD,"+CRLF
		cSQL+=" 		CT2_CCC,"+CRLF
		cSQL+=" 		CT2_ITEMD,"+CRLF                                
		cSQL+=" 		CT2_ITEMC,"+CRLF
		cSQL+=" 		CT2_CLVLDB,"+CRLF
		cSQL+=" 		CT2_CLVLCR,"+CRLF
		cSQL+=" 		CT2_EMPORI,"+CRLF
		cSQL+=" 		CT2_FILORI,"+CRLF
		cSQL+=" 		CT2_TPSALD,"+CRLF
		cSQL+=" 		CT2_DTLP,"+CRLF
		cSQL+=" 		CT2_MANUAL,"+CRLF
		cSQL+=" 		CT2_ROTINA,"+CRLF
		cSQL+=" 		CT2_AGLUT,"+CRLF
		cSQL+=" 		CT2_SEQHIS,"+CRLF
		cSQL+=" 		CT2_SEQLAN,"+CRLF
		cSQL+=" 		CT2_TAXA,"+CRLF
		cSQL+=" 		CT2_VLR01,"+CRLF
		cSQL+=" 		CT2_VLR02,"+CRLF
		cSQL+=" 		CT2_VLR03,"+CRLF
		cSQL+=" 		CT2_VLR04,"+CRLF
		cSQL+=" 		CT2_VLR05,"+CRLF
		cSQL+=" 		CT2_CRCONV,"+CRLF
		cSQL+=" 		CT2_CTLSLD,"+CRLF
		cSQL+=" 		CT2_XEMP,"+CRLF
		cSQL+=" 		CT2_ORIGEM,"+CRLF  
		cSQL+=" 		R_E_C_N_O_,"+CRLF
		cSQL+=" 		R_E_C_D_E_L_ )"+CRLF
		cSQL+=" 		values "+CRLF
		cSQL+=" 		( '"+SUBSTR(cFilCons,1,LEN(ALLTRIM(XFILIAL("CT2"))))+"',"+CRLF
		cSQL+=" 		@dlan,"+CRLF
		cSQL+=" 		@lote,"+CRLF
		cSQL+=" 		@sub,"+CRLF
		cSQL+=" 		@docx,"+CRLF
		cSQL+=" 		@linhax,"+CRLF
		cSQL+=" 		@moeda,"+CRLF
		cSQL+=" 		@tipo,"+CRLF
		cSQL+=" 		@ctadb,"+CRLF
		cSQL+=" 		@ctacr,"+CRLF
		cSQL+=" 		@valor,"+CRLF
		cSQL+=" 		@hist,"+CRLF
		cSQL+=" 		@ccdb,"+CRLF
		cSQL+=" 		@cccr,"+CRLF
		cSQL+=" 		@itemdb,"+CRLF
		cSQL+=" 		@itemcr,"+CRLF
		cSQL+=" 		@clvldb,"+CRLF
		cSQL+=" 		@clvlcr,"+CRLF
		cSQL+=" 		@empori,"+CRLF
		cSQL+=" 		@filori,"+CRLF
		cSQL+=" 		@tpsald,"+CRLF
		cSQL+=" 		@dtlp,"+CRLF
		cSQL+=" 		'1',"+CRLF
		cSQL+=" 		@rotina,"+CRLF
		cSQL+=" 		'1',"+CRLF
		cSQL+=" 		@seqhis,"+CRLF
		cSQL+="    		@seqlan,"+CRLF
		cSQL+=" 		0,"+CRLF
		cSQL+=" 		0,"+CRLF
		cSQL+=" 		0,"+CRLF
		cSQL+=" 		0,"+CRLF
		cSQL+=" 		0,"+CRLF
		cSQL+=" 		0,"+CRLF
		cSQL+=" 		'1',"+CRLF
		cSQL+=" 		'0',"+CRLF
		cSQL+=" 		@xemp,"+CRLF
		cSQL+=" 		@xorigem,"+CRLF
		cSQL+=" 		@recCT2,"+CRLF
		cSQL+=" 		0)"+CRLF            

		cSQL+=" 		fetch next from "+"cur"+STRZERO(nX,4)+" into "+CRLF
		cSQL+=" 		@empori,"+CRLF
		cSQL+="		 	@filori,"+CRLF
		cSQL+=" 		@tpsald,"+CRLF
		cSQL+=" 		@ctadb,"+CRLF
		cSQL+=" 		@ccdb,"+CRLF
		cSQL+=" 		@itemdb,"+CRLF	
		cSQL+=" 		@clvldb,"+CRLF
		cSQL+=" 		@ctacr,"+CRLF
		cSQL+=" 		@cccr,"+CRLF
		cSQL+=" 		@itemcr,"+CRLF
		cSQL+=" 		@clvlcr,"+CRLF
		cSQL+=" 		@valor,"+CRLF
		cSQL+=" 		@dlan,"+CRLF
		cSQL+=" 		@hist,"+CRLF
		cSQL+=" 		@dtlp,"+CRLF
		cSQL+=" 		@moeda,"+CRLF
		cSQL+=" 		@tipo,"+CRLF
		cSQL+=" 		@xemp,"+CRLF
		cSQL+=" 		@xorigem,"+CRLF
		cSQL+=" 		@filial,"+CRLF                        //33		
		cSQL+=" 		@lote,"+CRLF                          //34				
		cSQL+=" 		@sub,"+CRLF                           //35				
		cSQL+=" 		@linha,"+CRLF                         //36				
		cSQL+=" 		@doc,"+CRLF                           //37						
		cSQL+=" 		@seqhis,"+CRLF                        //37								
		cSQL+=" 		@seqlan,"+CRLF                        //39								
		cSQL+=" 		@rotina "+CRLF                        //40								

		cSQL+="  	    select @lote = '"+aEmpOri[nX][6]+LEFT(aEmpOri[nX][11],5)+"'"+CRLF   // Tipo de saldo + empresa
		cSQL+="    	    select @sub = '"+aEmpOri[nX][10]+"'"+CRLF  // Estrutura de consolidação		
		cSQL+=" 		select @iBegin = @iBegin + 1 "+CRLF

IF Upper(TcGetDb())$'ORACLE.POSTGRES.DB2.INFORMIX'		

		cSQL+=" 		if @iBegin > 4095 Begin "+CRLF
		cSQL+="				commit "+CRLF
		cSQL+=" 			select @iBegin = 0"+CRLF
		cSQL+=" 		end "+CRLF                
ENDIF		
		cSQL+="		End "+CRLF			

IF Upper(TcGetDb())$'ORACLE.POSTGRES.DB2.INFORMIX'

		cSQL+="		if @iBegin > 0 Begin "+CRLF
		cSQL+="			commit"+CRLF
		cSQL+="		end "+CRLF                    
ENDIF		
		cSQL+=" 	close "+"cur"+STRZERO(nX,4)+" "+CRLF
		cSQL+=" 	deallocate "+"cur"+STRZERO(nX,4)+" "+CRLF
		cSQL+="		select @OUT_RET=1"+CRLF  // INDICA QUE EXCLUSAO FOI CONCLUIDA
		cSQL+="		commit"+CRLF
		cSQL+="End "+CRLF	
                                      
		ProcLogAtu("MENSAGEM","Antes do Parse: "+aEmpOri[nX][1],cSQL,"CONSOLIDA")	

//		MEMOWRITE("ZEMA"+cProc,cSQL)
		
		// Ajusta a expressão para o Banco de Dados
		cSQL:=MsParse(cSQL,Alltrim(TcGetDB()))

		ProcLogAtu("MENSAGEM","Antes do depois do Parse: "+aEmpOri[nX][1],cSQL,"CONSOLIDA")	

		IF EMPTY(cSQL)                                                                      
			ProcLogAtu("ERRO",OemToAnsi("Erro ao criar a stored procedure de consolidacao (PARSE)."),"","CONSOLIDA")	
			ApMsgAlert("Erro ao criar a stored procedure - CTB 1.")
			lContinua := .F.
		ELSE            
			cSQL:=StrTran(cSQL, " numeric", " numeric("+alltrim(str(TamSX3('CT2_VALOR')[1]))+","+alltrim(str(TamSX3('CT2_VALOR')[2]))+")")                      
			nRet:=TcSqlExec(cSQL)
			IF nRet <> 0
				ProcLogAtu("ERRO",OemToAnsi("Erro ao criar a procedure de consolidacao (TCSQLEXEC)."),"","CONSOLIDA")	
				ApMsgAlert("Erro ao criar a stored procedure - CTB 2.")
				lContinua := .F.
			ENDIF
		ENDIF                                   

        IF !lContinua
        	EXIT
        ELSE
			ProcLogAtu("MENSAGEM",OemToAnsi("Criada procedure: "+cProc+" empresa: "+aEmpOri[nX][11]),"","CONSOLIDA")				        
			aAdd(_aPar1, cSQL)
			aAdd(_aPar1, cProc)
			aAdd(_aPar1, aEmpOri[nX][1])

   			AADD(aCons,_aPar1)
		                              
			nRegIni := nRegIni + nRegCons + 1000

        ENDIF

	ENDIF	

Next                 
IF lContinua

	nVezes := 0
                   
	// Chama execução dos JOB´s
	FOR nX := 1 TO LEN(aCons)
		ProcLogAtu("MENSAGEM",OemToAnsi("Chamada da THREAD procedure: "+aCons[nX][5]),"","CONSOLIDA")				

		RECLOCK("SZ4",.T.)
		SZ4->Z4_FILIAL := XFILIAL("SZ4")
		SZ4->Z4_SEMAF  := aCons[nX][3]
		SZ4->Z4_STATUS := "A"
		MsUnlock()

		AADD(aSemaforo,{aCons[nX][3],"A"})							
		AADD(aSema,{aCons[nX][3],"A"})
											
		StartJob('U_ASCTBA7C', GetEnvServer(), .F. , aCons[nX]) 
		
		nVezes++  // Determina o número de THREADS que podem ser abertas
		
		IF nVezes == 10  .OR. nX == LEN(aCons) // No máximo 10 ou a ultima
		
			nVezes := 0
		
			// Aguarda a finalização das THREADS
			ProcLogAtu("MENSAGEM",OemToAnsi("Aguardando termino das THREADs de consolidação."),"","CONSOLIDA")				
		
			lContinua := U_ASCTBA09(aSemaforo)

			TcRefresh(CCT2)	    

			aSemaforo := {}
         
            IF !lContinua
            	EXIT
            ENDIF

		ENDIF		

	NEXT                        
	
    
	IF lContinua

		// limpa os arquivos de log´s 
		FOR nConta := 1 TO LEN(aSema)
			TCSQLEXEC("DELETE FROM "+U_RtTab("SZ4",cEmpAnt)+" WHERE Z4_SEMAF = '"+ALLTRIM(aSema[nConta][1])+"'")
		NEXT	
		TcRefresh(U_RtTab("SZ4",cEmpAnt))
                   
		ProcLogAtu("MENSAGEM",OemToAnsi("Termino das THREADs de consolidacao."),"","CONSOLIDA")				
	ELSE                                                                                                    
		ProcLogAtu("ERRO",OemToAnsi("Termino anormal das THREADs de consolidacao."),"","CONSOLIDA")				
	ENDIF	

ENDIF
Return(lContinua)                 
//-----------------------------------------------------------------------
/*{Protheus.doc} REPROCES
@Chamada do Reprocessamento Contábil
@param		{dDataIni, dDataFim, cEmp, cFil}
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------
Static Function REPROCES(_aParam)
ProcLogAtu("MENSAGEM",OemToAnsi("Inicio do reprocessamento contabil (CTBA190)"),"","ASCTBA07")
CTBA190(.T.,_aParam[1]-1,_aParam[2],_aParam[4],_aParam[4],"*",.T.,"01")                         
ProcLogAtu("MENSAGEM",OemToAnsi("Fim do reprocessamento contabil (CTBA190)"),"","ASCTBA07")
Return
//-----------------------------------------------------------------------
/*{Protheus.doc} RtTab
@Retorna o código da tabela da empresa selecionada
@param		_cTab,_cEmp
@return		_cName - Codigo da tabela
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
//-----------------------------------------------------------------------

User Function RtTab(_cTab,_cEmp)
Local _cName		:= ""
Local _aArea		:= GetArea()
Local _aAreaSX2		:= SX2->( GetArea() )
Local cSX2, cIndSX2, cAliSX2

Default _cEmp	:= SM0->M0_CODIGO

If _cEmp <> SM0->M0_CODIGO
	cAliSX2	:= "ALISX"
	cSX2		:= "SX2" + _cEmp + '0'
	cIndSX2	:= cSX2
	If File(cSX2 + GetDbExtension() )
		MsOpEndbf(.T.,__LocalDriver,cSX2,cAliSX2,.T.,.F.)
		
		dbSelectArea(cAliSX2)
		If Empty(IndexKey(1))
			MsOpenIdx(cIndSX2 + "1","X2_CHAVE",.T.,,,cIndSX2)
			dbSetIndex(cIndSX2)
		EndIf
		
		dbSetOrder(1)
		_cName := If(dbSeek(_cTab),(cAliSX2)->X2_ARQUIVO,NIL)
		
		dbSelectArea(cAliSX2)
		USE
	EndIf
Else
	_cName := RetSqlName(_cTab)
EndIf

RestArea(_aArea)
RestArea(_aAreaSX2)

Return _cName
//-----------------------------------------------------------------------
/*{Protheus.doc} ASCTBA7E
@Procedure de exclusão do movimento consolidado do periodo
@param		_aParams
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
User Function ASCTBA7E(_aParams)
Local cDataIni 	:= _aParams[3]
Local cDataFim 	:= _aParams[4]
Local CCT2     	:= _aParams[5]
Local cFilCons 	:= _aParams[6]
Local nRegIni  	:= _aParams[7]
Local nRegFim  	:= _aParams[8]
Local cProc	 	:= 'ASCTBA7E_'+CriaTrab(nil,.F.)
Local lRet     	:= .T.
Local aResult 	:= {}       
Local cSQL		:= ""                                                                    
Local nRet		:= 0 
                    
// Cria a Stored Procedure
cSQL:="create procedure "+cProc+" (@OUT_RET int output) as"+CRLF
cSQL+=" "+CRLF
cSQL+="Declare @iMinRecno   Integer"+CRLF
cSQL+="Declare @iMaxRecno   Integer"+CRLF                            
cSQL+="Declare @iBegin      integer"+CRLF
cSQL+="select @OUT_RET=0"+CRLF 
cSQL+= " "+CRLF
cSQL+= "Begin"+CRLF
cSQL+= "   select @iMinRecno   = "+ALLTRIM(STR(nRegIni))+CRLF
cSQL+= "   select @iMaxRecno   = "+ALLTRIM(STR(nRegFim))+CRLF
cSQL+= "   IF @iMaxRecno > 0 Begin "+CRLF 
cSQL+= "    	While @iMinRecno <= @iMaxRecno begin"+CRLF
cSQL+= "      	  		Update "+CCT2
cSQL+= "           		Set D_E_L_E_T_ = '*'"+CRLF	
cSQL+= "           		, R_E_C_D_E_L_ = R_E_C_N_O_"+CRLF
cSQL+= " 			    Where CT2_FILIAL = '"+SUBSTR(cFilCons,1,LEN(ALLTRIM(XFILIAL("CT2"))))+"'"+CRLF   
cSQL+= "     			and CT2_DATA >= '"+cDataIni+"' AND CT2_DATA <= '"+cDataFim+"'"+CRLF
cSQL+= "    			and D_E_L_E_T_ = ' '"+CRLF 
cSQL+= "     	       	and R_E_C_N_O_ between @iMinRecno and @iMinRecno + 4096"+CRLF
cSQL+= "        		commit "+CRLF                    
cSQL+= "         		select @iMinRecno = @iMinRecno + 4096"+CRLF                    	
cSQL+= "   		end"+CRLF   
cSQL+= "     end"+CRLF   	
cSQL+= "end"+CRLF	                     
cSQL+= "select @OUT_RET=1"+CRLF                 

// Ajusta a expressão para o Banco de Dados
cSQL:=MsParse(cSQL,Alltrim(TcGetDB()))

IF EMPTY(cSQL)                                                                      
	ProcLogAtu("ERRO",OemToAnsi("Erro - "+cProc+", criar procedure (PARSE)."),"","ASCTBA7E")
	lRet := .F.
ELSE                                  
	nRet:=TcSqlExec(cSQL)
	IF nRet <> 0                                                                                
		ProcLogAtu("ERRO",OemToAnsi("Erro - "+cProc+", criar procedure (TCSQLEXEC)."),cSQL,"ASCTBA7E")	
		lRet := .F.
	ENDIF
ENDIF

// Executa a Stored no Banco
if lRet
                                                                                                
	ProcLogAtu("MENSAGEM",OemToAnsi("Executa procedure - "+cProc+", exclusao do CT2 "),"","ASCTBA7E")

	aResult := TCSPExec( cProc, '' )

	if empty(aResult)                                                                                   
		ProcLogAtu("ERRO",OemToAnsi("Erro - "+cProc+", executar procedure (TCSPEEXEC)."),"","ASCTBA7E")		
		lRet := .F.    
	elseif aResult[1] != 1                                  
		ProcLogAtu("ERRO",OemToAnsi("Erro - "+cProc+", executar procedure (RETORNO)."),"","ASCTBA7E")		
		lRet := .F.
	endif      
endif


//EXCLUE A PROCEDURE		
 
IF TCSPExist( cProc ) 
	TcSqlExec('DROP PROCEDURE '+cProc)
endif                

IF lRet
	ProcLogAtu("MENSAGEM",OemToAnsi("Concluido a procedure - "+cProc+", exclusao do CT2 "),"","ASCTBA7E")
ELSE                                                                                   
	ProcLogAtu("MENSAGEM",OemToAnsi("Falha na procedure - "+cProc+", exclusao do CT2 "),"","ASCTBA7E")
ENDIF	                                                                
 
Return(lRet)
//-----------------------------------------------------------------------
/*{Protheus.doc} ASCTBA7C
@Procedure de consolidacao do movimento consolidado do periodo
@param		_aParams
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
User Function ASCTBA7C(_aParams)
Local cLog  	:= _aParams[3]  
Local cSQL  	:= _aParams[4]  
Local cProc 	:= _aParams[5]  
Local cOri		:= _aParams[6]  
Local aResult := {}
Local lRet    := .T.

RpcSetType( 3 )
RpcSetEnv( _aParams[1], _aParams[2],,,'CTB')           

ProcLogIni( {},"ASCTBA7C")                                        

ProcLogAtu("MENSAGEM",OemToAnsi("Inicio - JOB de consolidacao: "+cProc),"","ASCTBA7C")
aResult := TCSPExec( cProc, '' )

if empty(aResult)                                                                                   
	ProcLogAtu("ERRO",OemToAnsi("Erro - "+cProc+", executar procedure (TCSPEEXEC)."),"","ASCTBA7C")		
	lRet := .F.    
elseif aResult[1] != 1                                  
	ProcLogAtu("ERRO",OemToAnsi("Erro - "+cProc+", executar procedure (RETORNO)."),"","ASCTBA7C")		
	lRet := .F.
endif      

//EXCLUE A PROCEDURE		
 
IF TCSPExist( cProc ) 
	TcSqlExec('DROP PROCEDURE '+cProc)
endif                

IF lRet
	ProcLogAtu("MENSAGEM",OemToAnsi("Fim - JOB de consolidacao: "+cProc),"","ASCTBA7C")         
	ProcLogAtu("MENSAGEM",OemToAnsi("Empresa: "+cOri+", consolidação concluida."),"","ASCTBA07")		
	TCSQLEXEC("UPDATE "+U_RtTab("SZ4",cEmpAnt)+" SET Z4_STATUS = 'B' WHERE Z4_SEMAF = '"+ALLTRIM(cLog)+"'")
ELSE                                                                   
	ProcLogAtu("ERRO",OemToAnsi("Empresa: "+cOri+", erro de consolidação."),"","ASCTBA07")		
	TCSQLEXEC("UPDATE "+U_RtTab("SZ4",cEmpAnt)+" SET Z4_STATUS = 'E' WHERE Z4_SEMAF = '"+ALLTRIM(cLog)+"'")     
ENDIF	                                                             

TCREFRESH(U_RtTab("SZ4",cEmpAnt))
TCREFRESH(U_RtTab("CT2",cEmpAnt))
  

RpcClearEnv()

Return(NIL)
//-----------------------------------------------------------------------
/*{Protheus.doc} ELIMINA
@Chama a rotina externa de eliminação na consolidada corrente
@param		aEmpOri
@return		Nenhum
@author 	Zema
@since 		20/04/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
*/
Static Function ELIMINA(aEmpOri)
Local _aParams 	:= {}                                                          
aAdd(_aParams, aEmpOri)   
aAdd(_aParams, dDataIni)
aAdd(_aParams, dDataFim)                        

ProcLogAtu("MENSAGEM",OemToAnsi("Inicio-eliminacao etapa: "+aEmpOri[1][13]),"","ELIMINA")
      
U_ASCTBA10(_aParams)                                 

RETURN

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ EnvMailA   ³ Autor ³ALexandre Tosta Ribeiro³ Data ³ 28/12/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rotina para o envio de emails - Preparacao                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³ ExpC1 : Assunto					                            ³±±
±±³          ³ ExpC2 : Mensagem			                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CLIENTES MICROSIGA                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                                                                                 
Static Function EnvMailA( cAssunto, cMensagem, cEmailDest )
cError := ""
aAttach := {}                              
AADD(aAttach,"")
IF ! EnvMail( cEmailDest, cAssunto, cMensagem , aAttach , "", @cError )
	ProcLogAtu("Nâo foi possivel enviar o e-mail de confirmação.","ASCTBA07")
ENDIF           

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ EnvMail   ³ Autor ³ Antonio Marcos       ³ Data ³ 28/12/07   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rotina para o envio de emails                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³ ExpC1 : Conta de destino do e-mail.                          ³±±
±±³          ³ ExpC2 : Assunto do e-mail.                                   ³±±
±±³          ³ ExpC3 : Corpo da mensagem a ser enviada.               	    |±±
±±³          | ExpC4 : Array com arquivos a serem atachados                 |±±
±±³          ³ ExpC5 : Email para envio como copia oculta                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CLIENTES MICROSIGA                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function EnvMail( cEmailTo, cAssunto, cMensagem, aAttach, cEmailBcc, cError )
Local cAccount	:= GetMV( "MV_RELACNT" )
Local cPassword	:= GetMV( "MV_RELPSW"  )
Local cServer   := GetMV( "MV_RELSERV" )
Local lResult  	:= .F.
Local cAnex		:= ""
Local nX		:= 0

DEFAULT  cError   	:= ""

If Len( aAttach ) > 0
	
	For nX := 1 to Len( aAttach )
		cAnex += aAttach[ nX ] +"; "
	Next
	
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Envia o e-mail para a lista selecionada. Envia como BCC para que a pessoa pense³
//³que somente ela recebeu aquele email, tornando o email mais personalizado.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lResult
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se o Servidor de EMAIL necessita de Autenticacao³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if lResult .and. GetMv("MV_RELAUTH")
	//Primeiro tenta fazer a Autenticacao de E-mail utilizando o e-mail completo
	lResult := MailAuth(cAccount, cPassword)
	//Se nao conseguiu fazer a Autenticacao usando o E-mail completo, tenta fazer a autenticacao usando apenas o nome de usuario do E-mail
	if !lResult
		nAt 	:= At("@",cAccount)
		cUser 	:= If(nAt>0,Subs(cAccount,1,nAt-1),cAccount)
		lResult := MailAuth(cUser, cPassword)
	endif
endif

If lResult
  //	lResult:=MailSend( cAccount, { cEmailTo }, { }, { cEmailBcc }, cAssunto, cMensagem, { cAnexos }, .F. )
	lResult:=MailSend( cAccount, { cEmailTo }, { }, { cEmailBcc }, cAssunto, cMensagem, {cAnex} , .F. )	
	If !lResult
		//Erro no envio do email
		GET MAIL ERROR cError
		ProcLogAtu("Erro envio e-mail: "+cError,"ASCTBA07")
	EndIf
	
	DISCONNECT SMTP SERVER
	
Else
	//Erro na conexao com o SMTP Server
	GET MAIL ERROR cError            
	ProcLogAtu("Erro envio e-mail: "+cError,"ASCTBA07")	
EndIf

Return(lResult)