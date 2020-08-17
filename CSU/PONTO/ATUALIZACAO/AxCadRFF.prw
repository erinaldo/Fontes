#INCLUDE "PROTHEUS.CH"


/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o    � AXCADRFF   � Autor � Isamu K.              � Data � 06/04/15 ���
���������������������������������������������������������������������������Ĵ��
���Descri��o � Cadastro de Pr� ACJEF                                        ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe   � AXCADRFF                                                     ���
���������������������������������������������������������������������������Ĵ��
��� Uso      � Generico ( DOS e Windows )                                   ���
���������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.               ���
���������������������������������������������������������������������������Ĵ��
���Programador � Data     � BOPS �  Motivo da Alteracao                     ���
���������������������������������������������������������������������������Ĵ��
���            |          �      �                                          ���  
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������/*/
User Function AxCadRFF  


LOCAL cFiltraRFF			//Variavel para filtro
LOCAL aIndexRFF	:= {}		//Variavel Para Filtro 
Local cCpo 

Private bFiltraBrw := {|| Nil}		//Variavel para Filtro
PRIVATE aRotina :=  MenuDef() // ajuste para versao 9.12 - chamada da funcao MenuDef() que contem aRotina
Private cCadastro := OemToAnsi("PR� ACJEF")
Private cFilAlt
Private cMatAlt

DEFINE MSDIALOG oDlg2 TITLE OemtoAnsi('TABELA RFF - Informe a Filial, Matricula e Data a serem alterados....') FROM 0,0 TO 65,163//165,060 TO 320,400 PIXEL
		
cFilAlt  :=space(2)
cMatAlt  :=space(6)
dDtAlt   :=ctod("//") 
		
@ 007,010 SAY OemToAnsi('C�digo da Filial:') SIZE 200, 8 OF oDlg2 PIXEL
@ 005,080 MSGET oGet012 VAR cFilAlt F3 'SM0'     SIZE 030,9  OF oDlg2 PIXEL
		
@ 023,010 SAY OemToAnsi('Matr�cula:')           SIZE 200, 8 OF oDlg2 PIXEL
@ 021,080 MSGET oGet012 VAR cMatAlt F3 'SRA'      SIZE 030,9  OF oDlg2 PIXEL                

//@ 043,010 SAY OemToAnsi('Data:')          SIZE 100, 8 OF oDlg2 PIXEL
//@ 041,080 MSGET oGet028 VAR dDtAlt Picture "@R 99/99/9999" SIZE 030,10  OF oDlg2 PIXEL

		
DEFINE SBUTTON FROM 103, 010 TYPE 1 ACTION (nOpca:=1,oDlg2:End()) ENABLE OF oDlg2
DEFINE SBUTTON FROM 103, 080 TYPE 2 ACTION (oDlg2:End())  ENABLE OF oDlg2
ACTIVATE MSDIALOG oDlg2 CENTERED

//������������������������������������������������������������������������Ŀ
//� Inicializa o filtro utilizando a funcao FilBrowse                      �
//��������������������������������������������������������������������������
cFiltraRh := CHKRH("AxCadRFF","RFF","1") 
cFiltraRh += IF(!Empty(cFiltraRh),'.and. RFF_FILIAL = cFilAlt .and. RFF_MAT = cMatAlt ','RFF_FILIAL = cFilAlt .and. RFF_MAT = cMatAlt')
bFiltraBrw 	:= {|| FilBrowse("RFF",@aIndexRFF,@cFiltraRH) }
Eval(bFiltraBrw)

//��������������������������������������������������������������Ŀ
//� Endereca a funcao de BROWSE                                  �
//����������������������������������������������������������������
DbSelectArea('RFF')
DbGoTop()
//������������������������������������������������������������������������Ŀ
//� Grava registros alterados/deletados na tabela ZTE                 	   �
//��������������������������������������������������������������������������
mBrowse(06,01,22,75,'RFF',,,,)

EndFilBrw("RFF",aIndexRFF) 
  

Return Nil


/*                                	
�����������������������������������������������������������������������Ŀ
�Fun��o    � MenuDef		�Autor�  Luiz Gustavo     � Data �01/12/2006�
�����������������������������������������������������������������������Ĵ
�Descri��o �Isola opcoes de menu para que as opcoes da rotina possam    �
�          �ser lidas pelas bibliotecas Framework da Versao 9.12 .      �
�����������������������������������������������������������������������Ĵ
�Sintaxe   �< Vide Parametros Formais >									�
�����������������������������������������������������������������������Ĵ
� Uso      �GPEA030                                                     �
�����������������������������������������������������������������������Ĵ
� Retorno  �aRotina														�
�����������������������������������������������������������������������Ĵ
�Parametros�< Vide Parametros Formais >									�
�������������������������������������������������������������������������*/        
                         

Static Function MenuDef()
//��������������������������������������������������������������Ŀ
//� Define Array contendo as Rotinas a executar do programa      �
//� ----------- Elementos contidos por dimensao ------------     �
//� 1. Nome a aparecer no cabecalho                              �
//� 2. Nome da Rotina associada                                  �
//� 3. Usado pela rotina                                         �
//� 4. Tipo de Transa��o a ser efetuada                          �
//�    1 - Pesquisa e Posiciona em um Banco de Dados             �
//�    2 - Simplesmente Mostra os Campos                         �
//�    3 - Inclui registros no Bancos de Dados                   �
//�    4 - Altera o registro corrente                            �
//�    5 - Remove o registro corrente do Banco de Dados          �
//����������������������������������������������������������������
Local aRotina :=          { { 'Visualizar' , 'AxVisual' , 0 , 2},;  //'Visualizar'
							{ 'Excluir' , 'U_fDelMenu()', 0 , 5} }  //'Excluir' 
							
Return aRotina


/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � FDELMENU � Autor � Isamu K.              � Data � 06/08/02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Fun��o para deletar item no browse                         ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � GP030Alt(ExpC1,ExpN1,ExpN2)                                ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Alias do arquivo                                   ���
���          � ExpN1 = Numero do registro                                 ���
���          � ExpN2 = Numero da opcao selecionada                        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � GPEA030                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
User Function fDelMenu

Local nRecno := Recno()
Local cQuery

cUsuar   := Subs(cUsuario,7,14)
dDataAlt := dDataBase

cQuery := " UPDATE "+RetSqlName('RFF')+" "
cQuery += " SET D_E_L_E_T_ = '*' "
cQuery += " WHERE R_E_C_N_O_ = "+Alltrim(Str(nRecno))+" "
cQuery += " AND D_E_L_E_T_ = ' ' "  

TCSQLExec(cQuery)  

fGravaAlt("RFF",dDataAlt,cUsuar,cFilAlt,cMatAlt,nRecno)

Return


/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � GP030Alt � Autor � Eduardo de Souza      � Data � 06/08/02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Programa de alteracao de Funcoes                           ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � GP030Alt(ExpC1,ExpN1,ExpN2)                                ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Alias do arquivo                                   ���
���          � ExpN1 = Numero do registro                                 ���
���          � ExpN2 = Numero da opcao selecionada                        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � GPEA030                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
Static Function fGravaAlt(cTabx,dDtx,cUsux,cFilx,cMatx,nRecx)

dbSelectArea("ZTE")

RecLock("ZTE",.T.)

ZTE->ZTE_TABELA := cTabX
ZTE->ZTE_DTALT  := dDtX
ZTE->ZTE_USUARI := cUsuX
ZTE->ZTE_FILALT := cFilX
ZTE->ZTE_MATALT := cMatX 
ZTE->ZTE_RECALT := nRecX

MsUnlock()



Return  
