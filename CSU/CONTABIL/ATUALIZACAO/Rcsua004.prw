#INCLUDE "rwmake.ch"
#include "TOPCONN.ch"    
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออออออหออออออัออออออออออออออออออออออบฑฑ
ฑฑบPrograma  ณ RCSUA004 บ Autor ณROBERTO ROGERIO MEZZALIRA  บ Data ณ  08/02/03            บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออออออฯออออออฯออออออออออออออออออออออบฑฑ
ฑฑบDescricao ณ Importar Lancamentos contabeis da MarketSystem X Csu                       บฑฑ
ฑฑบ          ณ                                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑบUso       ณ  Especifico - CSU                                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function RCSUA004()

Private oLeTxt 

SetPrvt("CCOL,aItems2,cBANC0")
cPerg   := PADR("RCSUA4",LEN(SX1->X1_GRUPO))
ValidPerg()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Parametros utilizados                  ณ
//ณ mv_par01 - Data  de                    ณ
//ณ mv_par02 - Data  Ate                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montagem da tela de processamento.                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
PERGUNTE(cPerg,.f.)
@ 200,1 TO 380,380 DIALOG oLeTxt TITLE OemToAnsi("Importar Movimentcao Contabil")
@ 02,10 TO 080,175
@ 10,018 Say " Este programa ira fazer Importacao da Movimentacao    "
@ 18,018 Say " Contabil da MarketSystem para CSU                     "
@ 60,080 BMPBUTTON TYPE 05 ACTION PERGUNTE(cPerg)
@ 60,110 BMPBUTTON TYPE 01 ACTION OkLeTxt()
@ 60,138 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)

Activate Dialog oLeTxt Centered

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัอออออออออออออออออออออออออออหออออออหอออออออออออออปฑฑ
ฑฑบFuno    ณ OKLETXT  บ Autor ณ Roberto Rogerio Mezzalira บ Data บ  23/01/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯอออออออออออออออออออออออออออสออออออสอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao chamada pelo botao OK na tela inicial de processamen       บฑฑ
ฑฑบ          ณ to. Executa o Import do arquivo de instrumentos                   บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico - CSU                                                  บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function OkLeTxt

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private _cString  := "CT2"

Close(oLeTxt)
Processa({|| IMPORTRA() },"Aguarde Selecionando Registros...") 

Return(Nil)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ IMPORTRA บ Autor ณROBERTO R.MEZZALIRA บ Data ณ  23/01/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Executando aqui a importacao dos dados                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function ImporTRA()

LOCAL   cQuery   := ""
LOCAL   cQuegr   := ""
LOCAL   nREG     := 0
LOCAL   _nR      := 0 
Private aOrd 		:= {}
Private cDesc1      := "Este programa lista as possiveis inconsistencia na importacao dos lancamentos contabeis ou de/para"
Private cDesc2      := ""
Private cDesc3      := ""
Private lEnd        := .F.
Private lAbortPrint := .F.
Private limite      := 80
Private tamanho     := "M"
Private nomeprog    := "RCSUR04"
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private titulo      := " Rel. de inconsistencia dos lancamentos contabeis"
Private nLin        := 80
Private Cabec1      := "Conta Contabil            Descricao                                             Data+Lote+Sublote+Documento+Linha"
Private Cabec2      := ""
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private imprime     := .T.
Private wnrel       := "IMPCT2"
Private cPerg       := ""  
Private _cString    := "CT2"

Private _aVeterr := {}
aDepara := {}
aDepar1 := {}
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVetor contendo as contas contabeis para importacao ณ
//ณdos lancamentos contabeis                          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
/*
aDepara :={{"101010201","101010279"},{"101010203","101010281"},{"101010205","101010282"},;
            {"101010207","101010283"},{"101010213","101010284"},{"101010215","101010285"},;
            {"101010216","101010286"},{"101020101","101020201"},{"101020102","101020201"},;
            {"101020106","101020201"},{"101020110","101020201"},{"101020134","101020201"},;
            {"101020149","101020201"},{"101020153","101020201"},{"101020155","101020201"},;
            {"101020303","101020201"},{"101020305","101020201"},{"101020308","101020201"},;
            {"101020323","101020201"},{"101020326","101020201"},{"101030203","101020301"},;
            {"101030205","101020302"},{"101030206","101020303"},{"101030207","101020398"},;
            {"101030209","101020307"},{"101030302","101020607"},{"101030305","101020602"},;
            {"101030306","101020616"},{"101030307","101020610"},{"101030310","101020614"},;
            {"101030401","101020403"},{"101050101","101020506"},{"101050102","101020505"},;
            {"101050104","101020507"},{"101050107","101020511"},{"101050108","101020512"},;
            {"101050109","101020517"},{"101050110","101020513"},{"101050112","101020518"},;
            {"101050114","101020519"},{"101050115","101020516"},{"101050117","101020523"},;
            {"101050118","101020524"},{"101050119","101020522"},{"101050123","101020521"},;
            {"101050201","101020522"},{"102010306","102010405"},{"103020102","103020101"},;
            {"103020103","103020103"},{"103020104","103020103"},{"103020105","103020104"},;
            {"103020106","103020107"},{"103020108","103020102"},{"103020202","103020201"},;
            {"103020203","103020203"},{"103020204","103020203"},{"103020205","103020204"},;
            {"103020206","103020205"},{"103020208","103020202"},{"201010102","201010111"},;
            {"201010109","201010112"},{"201030101","2010201"},{"201030103","2010201"},;
            {"201030104","2010204"},{"201030105","2010209"},{"201030106","2010201"},;
            {"201040101","2010412"},{"201040103","2010410"},{"201040104","2010411"},;
            {"201040105","2010404"},{"201040106","2010405"},{"201040107","2010413"},;
            {"201040108","2010401"},{"201040109","2010402"},{"201040111","2010409"},;
            {"201040112","2010408"},{"201050101","2010301"},{"201050102","2010308"},;
            {"201050103","2010301"},{"201050104","2010304"},{"201050105","2010309"},;
            {"201050106","2010305"},{"201050107","2010306"},{"201050108","2010302"},;
            {"201050109","2010303"},{"201050110","2010202"},{"201060210","2010599"},;
            {"201060212","2010599"},{"203010101","2030101"},{"203050101","2030401"},;
            {"20305110","2030404"},{"301010101","301050104"},{"301010102","301050103"},;
            {"301010107","301050105"},{"301010117","301050107"},{"301010118","301050112"},;
            {"301010121","301050113"},{"301010125","301050110"},{"301010126","301050111"},;
            {"301010127","301050117"},{"301010130","301050114"},{"301010131","301050115"},;         
            {"301010132","301050116"},{"301020101","301060101"},{"301020103","301060102"},;
            {"301040102","301030105"},{"301040105","301020306"},{"301040106","301021130"},;
            {"301040107","301030105"},{"301040108","301020901"},{"301040109","301020708"},;
            {"301040110","301021101"},{"301040111","301021101"},{"301040112","301020901"},;
            {"301040113","301021103"},{"301040114","302021101"},{"301040115","302021001"},;
            {"301040118","301020503"},{"301050103","301010502"},{"302010101","302010101"},;
            {"302010102","302010102"},{"302010103","302010104"},{"302010104","302010103"},;
            {"302010105","302010105"},{"302010106","302010601"},{"302010107","302010601"},;
            {"302010110","302010404"},{"302010111","302010502"},{"302010112","302010501"},;
            {"302010113","302010301"},{"302010115","302010201"},{"302010117","302010401"},;
            {"302010118","302010402"},{"302010119","302010403"},{"302010121","302010404"},;
            {"302010122","302010103"},{"302010123","302010105"},{"302010124","302010602"},;
            {"302020101","302021101"},{"302020102","302021102"},{"302020104","302021106"},;
            {"302020106","302021113"},{"302020107","302040104"},{"302020108","302021114"},;
            {"302020109","302021001"},{"302020110","302021130"},{"302020111","302021120"},;
            {"302020113","302021001"},{"302020114","302021125"},{"302020115","302021103"},;
            {"302020117","302020701"},{"302020118","302020901"},{"302020120","302021132"},;
            {"302020122","302021126"},{"302020123","302021131"},{"302020124","302020801"},;
            {"302020125","302021101"},{"302020128","302020708"},{"302020129","302020402"}}

aDepar1 :={{"302020130","302021101"},{"302020132","302020509"},{"302020133","302020503"},;
            {"302020134","302020505"},{"302020135","302020405"},{"302020139","302021104"},;
            {"302020149","302021001"},{"302020150","302021130"},{"302020155","302010102"},;
            {"302020203","302021133"},{"302020205","302020505"},{"302020208","302040101"},;
            {"302020212","302040105"},{"302020214","302020402"},{"302020217","302040107"},;
            {"302030101","302060101"},{"302030102","302060102"},{"302040101","302070108"},;
            {"302040102","302070104"},{"302040103","302070105"},{"302040104","302070103"},;
            {"302040105","302070106"},{"302040109","302070103"},{"302040403","302070102"},;
            {"401010101","4010501"},{"401010102","4010502"},{"401010106","4010503"},;
            {"401010110","4010504"},{"401010120","4010509"},{"401010127","4010510"},;
            {"401010133","4010505"},{"401010136","4010506"},{"401010138","4010511"},;
            {"401010140","4010507"},{"401010141","4010513"},{"401010142","4010508"},;
            {"401010201","4010501"},{"401010202","4010502"},{"401010206","4010503"},;
            {"401010220","4010509"},{"401010233","4010505"},{"401010236","4010511"},;
            {"401010238","4010507"},{"401010239","4010512"},{"401030102","302050102"},;
            {"401030103","302050102"},{"401030104","302050101"},{"401040102","4020103"},;
            {"401040104","4020102"}}

FOR _nD:= 1 TO LEN(aDepara)
    Dbselectarea("SZD")
 	Reclock("SZD",.T.)                
      SZD->ZD_FILIAL := XFILIAL("SZD")
      SZD->ZD_CTADE := aDepara[_nD,1] 
      SZD->ZD_CTATE := aDepara[_nD,2]
    MSUNLOCK()
    
NEXT _nD

FOR _nE:= 1 TO LEN(aDepar1)
    Dbselectarea("SZD")
 	Reclock("SZD",.T.)
 	  SZD->ZD_FILIAL := XFILIAL("SZD")
      SZD->ZD_CTADE := aDepar1[_nE,1] 
      SZD->ZD_CTATE := aDepar1[_nE,2]
    MSUNLOCK()
    
NEXT _nE
                    
RETURN  */
//
// MONTA DEPARA COM BASE NO CT1 CORRENTE 
//
cQuect1 := "Select SZD.ZD_CTATE,SZD.ZD_CTADE"
cQuect1 := cQuect1 + " FROM "+retsqlname("SZD")+"  SZD "
cQuect1 := cQuect1 + " WHERE SZD.D_E_L_E_T_ = ' '" 
cQuect1 := cQuect1 + " ORDER BY SZD.ZD_CTATE"

If Select("TM1") > 0
     DbSelectArea("TM1")
     DbCloseArea()
Endif
TCQUERY cQuect1 NEW ALIAS "TM1"
DbSelectArea("TM1")
DBGOTOP()             
DO WHILE TM1->(!Eof())

     aAdd(aDepara ,{ALLTRIM(TM1->ZD_CTADE),ALLTRIM(TM1->ZD_CTATE)}) 
     DBSELECTAREA("TM1")
     DBSKIP()

ENDDO
DbSelectArea("TM1")
DbCloseArea()

cQuery := "SELECT  * "
//cQuery := cQuery + " FROM dadosmrl1..CT2300 CT2" 
cQuery := cQuery + " FROM DADOSMP8MRL..CT2300 CT2"
cQuery := cQuery + " WHERE CT2.CT2_DATA BETWEEN '" +DTOS(MV_PAR01)+ "' And '"+DTOS(MV_PAR02)+ "' AND "
cQuery := cQuery + " CT2.CT2_IMP = ' ' AND CT2.D_E_L_E_T_ = ' ' "
cQuery := cQuery + "ORDER BY CT2_FILIAL+CT2_DATA,CT2_LOTE,CT2_SBLOTE,CT2_DOC,CT2_SEQLAN,CT2_EMPORI,CT2_FILORI+CT2_MOEDLC"

If Select("TMP") > 0
     DbSelectArea("TMP")
     DbCloseArea()
Endif
TCQUERY cQuery NEW ALIAS "TMP"
DbSelectArea("TMP")
DBGOTOP()             
DO WHILE TMP->(!Eof())
    
    Incproc("Proc.Import.Lancto: "+TMP->CT2_LOTE+TMP->CT2_SBLOTE+TMP->CT2_DOC) 
   
    //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
    //ณVerifica se a conta debito esta no deparaณ
    //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
    IF !EMPTY(TMP->CT2_DEBITO) 
    
         _nPosdeb  := Ascan(aDepara,{|x| x[1] == ALLTRIM(TMP->CT2_DEBITO)})
        IF _nPosdeb <> 0 
	       cDeb  := ALLTRIM(aDepara[_nPosdeb,2])
        ELSE
           cDeb  := TMP->CT2_DEBITO
        ENDIF
    
    ELSE
         cDeb  := TMP->CT2_DEBITO
    Endif
    
    //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
    //ณVerifica se a conta credito esta no deparaณ
    //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
    IF !EMPTY(TMP->CT2_CREDITO)
         
        _nPoscred := Ascan(aDepara,{|x| x[1] == ALLTRIM(TMP->CT2_CREDITO)})
        IF _nPoscred <> 0 
	       cCred  := ALLTRIM(aDepara[_nPoscred,2])
        ELSE
           cCred := TMP->CT2_CREDITO
        ENDIF
        
    ELSE
         cCred := TMP->CT2_CREDITO
    ENDIF 
    
    IF !EMPTY(cDeb)  
    
       DBSELECTAREA("CT1")
       DBSETORDER(1)
       IF DBSEEK(XFILIAL("CT1")+alltrim(cDeb)) 
       ELSE 
           aAdd(_aVeterr,{cDeb,"Conta contabil nao cadastrada,lcto nao importado",(SUBSTR(TMP->CT2_DATA,7,2)+"/"+SUBSTR(TMP->CT2_DATA,5,2)+"/"+SUBSTR(TMP->CT2_DATA,1,4))+" - "+TMP->CT2_LOTE+" "+TMP->CT2_SBLOTE+" "+TMP->CT2_DOC+" "+TMP->CT2_LINHA,TMP->R_E_C_N_O_}) 
           IF _nPosdeb == 0 
              aAdd(_aVeterr,{cDeb,"Conta contabil nao existe no De/Para","",TMP->R_E_C_N_O_})
           ENDIF 
           DBSELECTAREA("TMP")
           DBSKIP()
           LOOP 
       ENDIF

    ENDIF
    
    IF !EMPTY(cCred)  
       DBSELECTAREA("CT1")
       DBSETORDER(1)
       IF DBSEEK(XFILIAL("CT1")+alltrim(cCred)) 
       ELSE 
           aAdd(_aVeterr,{cCred,"Conta contabil nao cadastrada,lcto nao importado",(SUBSTR(TMP->CT2_DATA,7,2)+"/"+SUBSTR(TMP->CT2_DATA,5,2)+"/"+SUBSTR(TMP->CT2_DATA,1,4))+" - "+TMP->CT2_LOTE+" "+TMP->CT2_SBLOTE+" "+TMP->CT2_DOC+" "+TMP->CT2_LINHA,TMP->R_E_C_N_O_}) 
           IF _nPoscred == 0 
              aAdd(_aVeterr,{cCred,"Conta contabil nao existe no De/Para","",TMP->R_E_C_N_O_})
           ENDIF 
           DBSELECTAREA("TMP")
           DBSKIP()
           LOOP 
       ENDIF

    ENDIF
    Dbselectarea("CT2")
	Reclock("CT2",.T.)
		CT2_FILIAL := XFILIAL("CT2")
		CT2_DATA   := CTOD(SUBSTR(TMP->CT2_DATA,7,2)+"/"+SUBSTR(TMP->CT2_DATA,5,2)+"/"+SUBSTR(TMP->CT2_DATA,1,4))
    	CT2_LOTE   := "M"+SUBSTR(TMP->CT2_LOTE,2,5)
    	CT2_SBLOTE := TMP->CT2_SBLOTE
    	CT2_DOC    := TMP->CT2_DOC 
    	CT2_LINHA  := TMP->CT2_LINHA 
        CT2_DC     := TMP->CT2_DC
        CT2_DEBITO := IIF(EMPTY(TMP->CT2_DEBITO),"",cDeb)
        CT2_CREDIT := IIF(EMPTY(TMP->CT2_CREDIT),"",cCred) 
        CT2_CCD    := IIF(EMPTY(TMP->CT2_DEBITO),"","51300")
        CT2_CCC    := IIF(EMPTY(TMP->CT2_CREDIT),"","51300")
		CT2_DCD    := TMP->CT2_DCD                          
		CT2_DCC    := TMP->CT2_DCC 
		CT2_VALOR  := TMP->CT2_VALOR
        CT2_HP     := TMP->CT2_HP
        CT2_HIST   := TMP->CT2_HIST
		CT2_MOEDLC := TMP->CT2_MOEDLC
		CT2_MOEDAS := TMP->CT2_MOEDAS
		CT2_ATIVDE := TMP->CT2_ATIVDE
		CT2_EMPORI := "09" 
		CT2_FILORI := TMP->CT2_FILORI
		CT2_TPSALD := TMP->CT2_TPSALD
		CT2_MANUAL := TMP->CT2_MANUAL
		CT2_ORIGEM := "09" 
		CT2_ATIVCR := TMP->CT2_ATIVCR
		CT2_FILORI := TMP->CT2_FILORI
		CT2_INTERC := TMP->CT2_INTERC
		CT2_IDENTC := TMP->CT2_IDENTC
        CT2_SEQUEN := TMP->CT2_SEQUEN
        CT2_MANUAL := TMP->CT2_MANUAL
        CT2_TPSALD := TMP->CT2_TPSALD
        CT2_ROTINA := TMP->CT2_ROTINA
        CT2_AGLUT  := TMP->CT2_AGLUT
        CT2_LP     := TMP->CT2_LP
        CT2_SLBASE := TMP->CT2_SLBASE
        CT2_SEQHIS := TMP->CT2_SEQHIS
        CT2_DTLP   := CTOD(SUBSTR(TMP->CT2_DTLP,7,2)+"/"+SUBSTR(TMP->CT2_DTLP,5,2)+"/"+SUBSTR(TMP->CT2_DTLP,1,4))
        CT2_SEQLAN := TMP->CT2_SEQLAN
        CT2_DTVENC := CTOD(SUBSTR(TMP->CT2_DTVENC,7,2)+"/"+SUBSTR(TMP->CT2_DTVENC,5,2)+"/"+SUBSTR(TMP->CT2_DTVENC,1,4))
        CT2_MES    := TMP->CT2_MES
        CT2_VLR01  := TMP->CT2_VLR01
        CT2_VLR02  := TMP->CT2_VLR02
        CT2_VLR03  := TMP->CT2_VLR03
        CT2_VLR04  := TMP->CT2_VLR04
        CT2_VLR05  := TMP->CT2_VLR05
        CT2_CRITER := TMP->CT2_CRITER
        CT2_DATATX := CTOD(SUBSTR(TMP->CT2_DATATX,7,2)+"/"+SUBSTR(TMP->CT2_DATATX,5,2)+"/"+SUBSTR(TMP->CT2_DATATX,1,4))
        CT2_TAXA   := TMP->CT2_TAXA
        CT2_CRCONV := TMP->CT2_CRCONV

    MsUnlock()        
    nREG := nREG + 1 
    dbselectarea("TMP")
    dbskip()

ENDDO  
IF nREG = 0
   MsgInfo("Nao existe registro para o periodo"+CHR(13),"Importacao Contabil")
ELSE 
   cQuegr := " BEGIN TRAN "
   cQuegr := cQuegr + " UPDATE DADOSMP8MRL..CT2300 " 
   cQuegr := cQuegr + " SET "
   cQuegr := cQuegr + " CT2_IMP = 'S'"
   cQuegr := cQuegr + " WHERE CT2_DATA BETWEEN '" +DTOS(MV_PAR01)+ "' And '"+DTOS(MV_PAR02)+"'"
   cQuegr := cQuegr + " AND CT2_IMP = ' '" 
   cQuegr := cQuegr + " COMMIT TRAN"
   TCSQLExec(cQuegr)
  
   _cNum := ""
   FOR _nR:=1 TO LEN(_aVeterr)

        _cNum := str(_aVeterr[_nR][4])
        cQuegr := " BEGIN TRAN "
        cQuegr := cQuegr + " UPDATE DADOSMP8MRL..CT2300 " 
        cQuegr := cQuegr + " SET "    
        cQuegr := cQuegr + " CT2_IMP = ' '"
        cQuegr := cQuegr + " WHERE R_E_C_N_O_ = '"+alltrim(_cNum)+ "'"
        cQuegr := cQuegr + " COMMIT TRAN"
        TCSQLExec(cQuegr)
 
   NEXT _nR 
   
   IF LEN(_aVeterr) > 0
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
ENDIF
DbSelectArea("TMP")    
DbCloseArea()

Return(Nil)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ ROBERTO R.MEZZALIRAบ Data ณ  18/02/06   บฑฑ
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

aSort(_aVeterr,,,{|x,y| x[1] < y[1] })

FOR _nI:= 1 TO LEN(_aVeterr)  

    If _nLin > 60 
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
		_nLin := 08
    Endif     
    @ _nLin , 001 PSAY _aVeterr[_nI][1]  
    @ _nLin , 025 PSAY _aVeterr[_nI][2] 
    @ _nLin , 080 PSAY _aVeterr[_nI][3] 
      _nLin := _nLin+1

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

/*/
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟฑ
ฑณFuncao    ณVALIDPERGณ Autor ณ ROBERTO R.MEZZALIRA   ณ Data ณ 08.02.06  ณฑ
ฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑ
ฑณDescricao ณ Verifica perguntas, incluindo-as caso nao existam          ณฑ
ฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑ
ฑณUso       ณ SX1                                                        ณฑ
ฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
/*/
Static Function ValidPerg()

   ssAlias      := Alias()
   cPerg        := PADR(cPerg,len(sx1->x1_grupo))
   aRegs        := {}
   dbSelectArea("SX1")
   dbSetOrder(1)                                                                                                     
   AADD(aRegs,{cPerg,"01","Data  de    ?","Data  de  ?","Data de ?","mv_ch1","D",8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
   AADD(aRegs,{cPerg,"02","Data  Ate   ?","Data  Ate ?","Data    ?","mv_ch2","D",8,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
   For i := 1 to Len(aRegs)
     If !DbSeek(cPerg+aRegs[i,2])
       RecLock("SX1",.T.)
       For j := 1 to FCount()
         FieldPut(j,aRegs[i,j])
       Next
       MsUnlock()
     Endif
   Next
   DbSelectArea(ssAlias)
Return
