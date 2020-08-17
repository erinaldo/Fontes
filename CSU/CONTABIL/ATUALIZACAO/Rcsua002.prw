#INCLUDE "rwmake.ch"

/*/
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͺ��
���Programa  � RCSUA002 � Autor �ROBERTO ROGERIO MEZZALIRA  � Data �  04/02/03            ���
�����������������������������������������������������������������������������������������ͺ��
���Descricao � Prog. para preencher a conta contabil na tabela de titulos a pagar         ���
���          � confo. o cadastro de fornecedores                                                                          ���
�����������������������������������������������������������������������������������������ͺ��
���Uso       �  Especifico - CSU                                                          ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
/*/
User Function RCSUA002()

Private oLeTxt 

SetPrvt("CCOL,aItems2,cBANC0")
aItems2  := {"Cadastro de TITULOS A PAGAR"} 
cCOL     := SPACE(1)

//���������������������������������������������������������������������Ŀ
//� Montagem da tela de processamento.                                  �
//�����������������������������������������������������������������������

@ 200,1 TO 360,360 DIALOG oLeTxt TITLE OemToAnsi("Atualizacao dos Titulos a Pagar")
@ 02,05 TO 080,170
@ 10,018 Say " Este programa ira fazer preenchimento da conta contabil         "
@ 18,018 Say " no arquivo de contas a pagar                                                   "
@ 60,108 BMPBUTTON TYPE 01 ACTION (OkLeTxt(),Close(oLeTxt))
@ 60,138 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)

Activate Dialog oLeTxt Centered

Return

/*/
������������������������������������������������������������������������������������
������������������������������������������������������������������������������������
��������������������������������������������������������������������������������ͻ��
���Fun��o    � OKLETXT  � Autor � Roberto Rogerio Mezzalira � Data �  23/01/06   ���
��������������������������������������������������������������������������������͹��
���Descri��o � Funcao chamada pelo botao OK na tela inicial de processamen       ���
���          � to. Executa o Import do arquivo de instrumentos                   ���
��������������������������������������������������������������������������������͹��
���Uso       � Especifico - CSU                                                  ���
��������������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������������
������������������������������������������������������������������������������������
/*/
Static Function OkLeTxt

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private _cString  := "SE2"
Processa({|| ALTERA() },"Aguarde atualizacao do Tabela do contas a pagar...") 
DbSelectArea(_cString)    

Return(Nil)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � altera   � Autor �ROBERTO R.MEZZALIRA � Data �  23/01/06   ���
�������������������������������������������������������������������������͹��
���Descri��o � Executando aqui a alteracao dos dados                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function ALTERA()


PRIVATE _aFALCTA    := {}
Private aOrd 		:= {}
Private cDesc1      := "Este programa lista possiveis inconsistencia na base "
Private cDesc2      := ""
Private cDesc3      := ""
Private lEnd        := .F.
Private lAbortPrint := .F.
Private limite      := 80
Private tamanho     := "M"
Private nomeprog    := "RCSUR02"
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private titulo      := "Critica da Alteracao dos Titulos a Pagar"
Private nLin        := 80
Private Cabec1      := "Titulo  Forn loja - Incosistencia"
Private Cabec2      := ""
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private imprime     := .T.
Private wnrel       := "IMPSE2"
Private cPerg       := ""  

DbSelectArea(_cString)  
DBSetOrder(1)           
dBGoTop()
ProcRegua(Reccount())

While !eof()       
  
  	IncProc("Alterando Titulo a Pagar - No.: "+SE2->E2_NUM)
    
    IF !EMPTY(SE2->E2_CONTA)
     
     	DBSelectArea(_cString)
    	dBSkip()
        LOOP
    
    ENDIF                    
    
	DBSelectArea("SA2")
	DBSETORDER(1)
	IF DBSEEK(XFILIAL("SA2")+SE2->(E2_FORNECE+E2_LOJA))
	   IF EMPTY(SA2->A2_CONTA)
     	   
	       aAdd(_aFALCTA,{SE2->E2_NUM+" "+SA2->A2_COD+"-"+SA2->A2_LOJA+" - Fornecedor possui conta contabil"})
	   
	   ELSE
	      DBSelectArea("SE2")
	      Reclock("SE2",.F.)
	    	SE2->E2_CONTA := SA2->A2_CONTA 
	      MsUnlock()
	   ENDIF   
	ELSE
  	    
  	    aAdd(_aFALCTA,{SE2->E2_NUM+" "+SE2->E2_FORNECE+"-"+SE2->E2_LOJA+" - Fornecedor Nao encontrado"})
	   	dBSelectArea(_cString)
    	dBSkip()
        LOOP
	ENDIF  
	
	dBSelectArea(_cString)
	dBSkip()

Enddo

IF LEN(_aFALCTA) > 0 
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � ROBERTO R.MEZZALIRA� Data �  23/01/06   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local _nLin := 66
Local _nCont:= 0

FOR _nI:= 1 TO LEN(_aFALCTA)  

    If _nLin > 60 
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho)
		_nLin := 08
    Endif     

    @ _nLin , 001 PSAY _aFALCTA[_nI][1] 
      _nLin := _nLin+1

Next _nI

//���������������������������������������������������������������������Ŀ
//� Finaliza a execucao do relatorio...                                 �
//�����������������������������������������������������������������������

SET DEVICE TO SCREEN

//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return()
