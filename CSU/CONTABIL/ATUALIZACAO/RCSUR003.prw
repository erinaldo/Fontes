#INCLUDE "rwmake.ch"                
#include "TOPCONN.ch"    

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออออออหออออออัออออออออออออออออออออออบฑฑ
ฑฑบPrograma  ณ RCSUR003 บ Autor ณROBERTO ROGERIO MEZZALIRA  บ Data ณ  01/02/06            บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออออออฯออออออฯออออออออออออออออออออออบฑฑ
ฑฑบDescricao ณ Relatorio de Inconsistencia Centro de Custo X Conta Contabil               บฑฑ
ฑฑบ          ณ                                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑบUso       ณ  Especifico - CSU                                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function RCSUR003()

Processa({|| PROCESINC() },"Aguarde Processamento das Inconsistencia...") 
RETURN

STATIC FUNCTION PROCESINC()               

LOCAL _cContaSint   := 0 
LOCAL _cDescSint    := 0 
LOCAL _nVLRCT       := 0
LOCAL _cContSi1     := 0 
LOCAL _cDescSi1     := 0 
LOCAL _nVLRCT1      := 0
LOCAL _nX           := 0  
LOCAL _nR 	        := 0
Local _nPoscon      := 0  
Local _cANTCUS      := ""
Local _cAntcon      := "" 
Private aOrd 		:= {}
Private cDesc1      := "Este programa lista as possiveis inconsistencia nos centros de custos"
Private cDesc2      := ""
Private cDesc3      := ""
Private lEnd        := .F.
Private lAbortPrint := .F.
Private limite      := 80
Private tamanho     := "M"
Private nomeprog    := "RCSUR03"
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private titulo      := " Rel. de inconsisitencia de Centro de Custo x Conta Contabil"
Private nLin        := 80
Private Cabec1      := "Centro Custo             Conta Contabil           Descricao                                                       Valor"
Private Cabec2      := ""
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private imprime     := .T.
Private wnrel       := "IMPSE2"
Private cPerg       := ""  
Private _cString    := "CT3"
PRIVATE _aVeterr    := {} //// Vetor contento os Centros de Custo x Conta Contabil 
Private _aVetimp    := {} //vetor com as contas inconsistentes Totalizadas nas sinteticas correspondentes 
Private _aVetimp2    := {} //vetor com as contas inconsistentes Totalizadas nas sinteticas correspondentes 
Private _aVetimp3   := {} //vetor com as contas inconsistentes Totalizadas nas sinteticas correspondentes 

_cCDesp             :=  "50100/5015520/50200/50300/50400/50873/50880/50881/50900/50910/50920/50930/50940/51120/51200" //Lista do centro de custo de despesas
_aCtadespini        := "302"   //Conta contabil inicial de despesas
_aCtadespfin        := "30213" //Conta contabil final de despesas

cQuery := "SELECT  CT3.CT3_CUSTO ,CT3.CT3_CONTA,CT3.CT3_DATA,CT3.CT3_ATUDEB"
cQuery := cQuery + ",CT3.CT3_ATUCRD,CT3.CT3_DEBITO,CT3.CT3_CREDIT"
cQuery := cQuery + " FROM "+retsqlname("CT3")+"  CT3  "
cQuery := cQuery + " WHERE CT3.CT3_CONTA BETWEEN '301' And '302213' "
//cQuery := cQuery + " AND CT3.CT3_DATA BETWEEN '20051201' And '20051231'  "
cQuery := cQuery + " AND CT3.CT3_DATA BETWEEN '20050101' And '20051231'  "
cQuery := cQuery + " AND CT3.D_E_L_E_T_ = ' ' "
cQuery := cQuery + " ORDER BY CT3.CT3_CUSTO,CT3.CT3_CONTA"

IF Select("TMP") > 0
     DbSelectArea("TMP")
     DbCloseArea()
Endif

TCQUERY cQuery NEW ALIAS "TMP"
DbSelectArea("TMP")
DBGOTOP()             
DO WHILE TMP->(!Eof())                                  

    Incproc("Processando Centro de custo "+TMP->CT3_CUSTO) 
    // VERIFICA OS CENTRO DE CUSTO DE DESPESA 
    IF ALLTRIM(TMP->CT3_CUSTO)$_cCDesp                 
        
         //VERIRFICA AS CONTAS DE DESPESAS
        IF TMP->CT3_CONTA >= _aCtadespini .AND. TMP->CT3_CONTA <=_aCtadespfin
           DBSKIP()
           LOOP
        ELSE   
           // Vetor contento os Centros de Custo x Conta Contabil 
           aAdd(_aVeterr,{TMP->CT3_CUSTO,TMP->CT3_CONTA,TMP->CT3_DATA,TMP->CT3_DEBITO,TMP->CT3_CREDIT})
        
        ENDIF
    ELSE
       // CENTRO DE CUSTO DE CUSTO  
       // //VERIRFICA AS CONTAS DE DESPESAS
       IF TMP->CT3_CONTA >= _aCtadespini .AND. TMP->CT3_CONTA <=_aCtadespfin
         
          aAdd(_aVeterr,{TMP->CT3_CUSTO,TMP->CT3_CONTA,TMP->CT3_DATA,TMP->CT3_DEBITO,TMP->CT3_CREDIT})
    
       ELSE
          DBSKIP()
          LOOP
       ENDIF
       
    ENDIF
    
    DBSELECTAREA("TMP")
    DBSKIP()
    
Enddo  
//
//EFETUA A TOTALIZACAO DAS CONTA NAS SINTETICAS
//
FOR _nX:=1 TO LEN(_aVeterr)
       
      IF  _aVeterr[_nX][1] <> _cANTCUS  
           _nVLRCT := 0 
           DbSelectArea("CT1")
		   DbSetOrder(1)
           If dbSeek(xFilial("CT1")+_aVeterr[_nX][2])
                _nPosCT1 	:= Recno()
                _cContaPai	:= CT1->CT1_CTASUP
                If dbSeek(xFilial("CT1")+_cContaPai)
           		      _cContaSint 	:= CT1->CT1_CONTA
           		      _cDescSint	:= &("CT1->CT1_DESC"+"01")
           		      If Empty(_cDescSint)
			                  _cDescSint := CT1->CT1_DESC01
           		      Endif
              	EndIf	
              	
	            dbGoto(_nPosCT1)
           EndIf	
           
           IF _aVeterr[_nX][4] > 0
                    _nVLRCT := _nVLRCT + _aVeterr[_nX][4]
           ENDIF 
           IF _aVeterr[_nX][5] > 0
                   _nVLRCT := _nVLRCT - _aVeterr[_nX][5]
           ENDIF
           aAdd(_aVetimp,{_aVeterr[_nX][1],_cContaSint,_cDescSint,_nVLRCT})
           _cAntcon  := _aVeterr[_nX][2]
           _cAntcus  := _aVeterr[_nX][1]
      ELSE 
          IF  _aVeterr[_nX][2] <> _cANTCON  
                _nVLRCT := 0 
                DbSelectArea("CT1")
				DbSetOrder(1)
                If dbSeek(xFilial("CT1")+_aVeterr[_nX][2])
             	     _nPosCT1 	:= Recno()
            	     _cContaPai	:= CT1->CT1_CTASUP
             	     If dbSeek(xFilial("CT1")+_cContaPai)
            		      _cContaSint 	:= CT1->CT1_CONTA
            		      _cDescSint	:= &("CT1->CT1_DESC"+"01")
            		      If Empty(_cDescSint)
			                  _cDescSint := CT1->CT1_DESC01
             		      Endif
              	     EndIf	
	                 dbGoto(_nPosCT1)
                EndIf	
                IF _aVeterr[_nX][4] > 0
                     _nVLRCT := _nVLRCT + _aVeterr[_nX][4]
                ENDIF 
                IF _aVeterr[_nX][5] > 0
                     _nVLRCT := _nVLRCT - _aVeterr[_nX][5]
                ENDIF
                aAdd(_aVetimp,{_cAntcus,_cContaSint,_cDescSint,_nVLRCT})
                _cAntcon  := _aVeterr[_nX][2]
           
           ELSE
                IF _aVeterr[_nX][4] > 0
                     _nVLRCT := _nVLRCT + _aVeterr[_nX][4]
                ENDIF 
                IF _aVeterr[_nX][5] > 0
                     _nVLRCT := _nVLRCT - _aVeterr[_nX][5]
                ENDIF                                                            
                
                _nPoscon  := Ascan(_aVetimp,{|x| x[1] == _cAntcus .and. x[2] == _cContaSint    })
                _aVetimp [_nPoscon][4] := _nVLRCT 

           ENDIF
           
      ENDIF

NEXT _nX

// verifica  se gerou inconsistencia e gera o relatorio

IF LEN(_aVetimp) > 0         

   aSort(_aVetimp,,,{|x,y| x[2] < y[2] })
   _cANTCTA  := ""            
   _nVLRCT   := 0 
   _cANTCTA1 := ""            
   _nVLRCT1  := 0 
   
   For _nY:= 1 to Len(_aVetimp)
        
          
           DbSelectArea("CT1")
		   DbSetOrder(1)
           If dbSeek(xFilial("CT1")+_aVetimp[_nY][2])
                _nPosCT1 	:= Recno()
                _cContaPai	:= CT1->CT1_CTASUP
                If dbSeek(xFilial("CT1")+_cContaPai)
           		      _cContaSint 	:= CT1->CT1_CONTA
           		      _cDescSint	:= &("CT1->CT1_DESC"+"01")
           		      If Empty(_cDescSint)
			                  _cDescSint := CT1->CT1_DESC01
           		      Endif
              	EndIf	
                dbGoto(_nPosCT1)
           EndIf	
           
           DbSelectArea("CT1")
		   DbSetOrder(1)
           If dbSeek(xFilial("CT1")+_cContaSint)
                _nPosCT1 	:= Recno()
                _cContaP1	:= CT1->CT1_CTASUP
                If dbSeek(xFilial("CT1")+_cContaP1)
           		      _cContaS1 	:= CT1->CT1_CONTA
           		      _cDescS1	    := &("CT1->CT1_DESC"+"01")
           		      If Empty(_cDescS1)
			                  _cDescS1 := CT1->CT1_DESC01
           		      Endif
              	EndIf	
                dbGoto(_nPosCT1)
           EndIf	
           
           IF  _cContaP1 <> _cANTCTA1 
              
               _nVLRCT1 := 0 
               _nVLRCT  := _nVLRCT + _aVetimp[_nY][4]
               aAdd(_aVetimp2,{_cContaP1,_cDescS1,0})
               _cANTCTA1  := _cContaP1
               
               IF  _cContaPai <> _cANTCTA 
                   _nVLRCT := 0 
                   _nVLRCT := _nVLRCT + _aVetimp[_nY][4]
                   aAdd(_aVetimp2,{_cContaSint,_cDescSint,_nVLRCT})
                   _cANTCTA  := _cContaPai
               ELSE                                  
                  _nPoscon  := Ascan(_aVetimp2,{|x| x[1] == _cContaSint})
                  _nVLRCT := _aVetimp[_nY][4] + _aVetimp2 [_nPoscon][3]
                  _aVetimp2[_nPoscon][3] := _nVLRCT  
           
               Endif
	       
           Else
              IF  _cContaPai <> _cANTCTA 
                  
                  _nVLRCT := 0 
                  _nVLRCT := _nVLRCT + _aVetimp[_nY][4]
                  aAdd(_aVetimp2,{_cContaSint,_cDescSint,_nVLRCT})
                 _cANTCTA  := _cContaPai
              
              ELSE                                  
                  _nPoscon  := Ascan(_aVetimp2,{|x| x[1] == _cContaSint})
                  _nVLRCT := _aVetimp[_nY][4] + _aVetimp2 [_nPoscon][3]
                  _aVetimp2[_nPoscon][3] := _nVLRCT  
           
              Endif
	       
	       Endif    
	           _nPoscon1  := Ascan(_aVetimp2,{|x| x[1] == _cContaS1})
               _nVLRCT1   := _aVetimp2 [_nPoscon1][3] + _aVetimp[_nY][4]
               _aVetimp2[_nPoscon1][3] := _nVLRCT1  
           
	       //Endif
	
	Next _nY
	         
	wnrel := SetPrint(_cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,_cString)

	If nLastKey == 27
		Return
	Endif

    RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

ENDIF


Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ ROBERTO R.MEZZALIRAบ Data ณ  01/02/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local _nLin    := 66
Local _nCont   := 0
Local cbtxt    := SPACE(10)
Local cbcont   := 0                  
Local _cCtavel := ""
local _nTotcta := 0

//aSort(_aVetimp,,,{|x,y| x[1] < y[1] })
//aSort(_aVetimp,,,{|x,y| x[2] < y[2] }) 
_cCtavel := _aVetimp[1][2]

FOR _nI:= 1 TO LEN(_aVetimp)  

    If _nLin > 60 
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
		_nLin := 08
    Endif     
    
    IF _aVetimp[_nI][2] <> _cCtavel 
      
       _nLin := _nLin+1
       @ _nLin , 001 PSAY "Total Conta: "+_cCtavel
       @ _nLin , 100 PSAY _nTotcta PICTURE "@E 99,999,999,999.99"
       _nTotcta := 0
       _nTotcta := _nTotcta + _aVetimp[_nI][4]
       _cCtavel := _aVetimp[_nI][2]
       _nLin := _nLin + 2
       
    ELSE
       _nTotcta := _nTotcta + _aVetimp[_nI][4]
    
    ENDIF  
    
    @ _nLin , 001 PSAY _aVetimp[_nI][1]  
    @ _nLin , 025 PSAY _aVetimp[_nI][2] 
    @ _nLin , 050 PSAY _aVetimp[_nI][3] 
    @ _nLin , 100 PSAY _aVetimp[_nI][4] PICTURE "@E 99,999,999,999.99"
      _nLin := _nLin+1

Next _nI
_nLin := _nLin+1
@ _nLin , 001 PSAY "Total Conta: "+_cCtavel
@ _nLin , 100 PSAY _nTotcta PICTURE "@E 99,999,999,999.99"
       
roda(cbcont,cbtxt,"M")

aSort(_aVetimp,,,{|x,y| x[1] < y[1] })

_nLin :=80  
Cabec1      := "Conta Contabil           Descricao                                            Custo                Despesa"
                                                                                           
FOR _nI:= 1 TO LEN(_aVetimp2)  

    If _nLin > 60 
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
		_nLin := 08
    Endif     
    IF len(alltrim(_aVetimp2[_nI][1])) == 3   
      _nLin := _nLin+1
    Endif
    
    @ _nLin , 001 PSAY _aVetimp2[_nI][1]  
    @ _nLin , 025 PSAY _aVetimp2[_nI][2] 
    IF substr(_aVetimp2[_nI][1],1,3) == "301"   
        @ _nLin , 70 PSAY _aVetimp2[_nI][3] PICTURE "@E 99,999,999,999.99"
    Else
        @ _nLin , 100 PSAY _aVetimp2[_nI][3] PICTURE "@E 99,999,999,999.99"
    Endif
    _nLin := _nLin+1
    IF len(alltrim(_aVetimp2[_nI][1])) == 3   
      _nLin := _nLin+1
    Endif
    
Next _nI


roda(cbcont,cbtxt,"M")
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return()


