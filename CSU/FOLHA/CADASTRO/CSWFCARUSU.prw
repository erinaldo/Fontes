#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "topconn.ch"

User Function WFCarrUsu()
Return u_CSWFCarrUsu()

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSWCARRUSU� Autor � Isamu k.           � Data �  23/10/2017 ���
�������������������������������������������������������������������������͹��
���Descricao � Schedule para preenchimento do campo RA_CODUSU_            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Exclusivo da CSU.                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function CSWCARRUSU()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

PREPARE ENVIRONMENT EMPRESA "05" FILIAL "03" MODULO "GPE"

Private _aArea := GetArea()

u_Geraarq(cCmd)

RESET ENVIRONMENT


RestArea(_aArea)

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � OKGERATXT� Autor � AP5 IDE            � Data �  08/05/07   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao chamada pelo botao OK na tela inicial de processamen���
���          � to. Executa a geracao do arquivo texto.                    ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function Geraarq(cCmd)

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local aRet := AllUsers()
Local nI
Local cQr
Local aRet   := {}  
Local aUsers := {}

For nI := 1 to Len(aRet)
   Aadd(aUsers,{ aRet[nI][1][1],aRet[nI][1][22]} )
Next  

cQr := " SELECT RA_FILIAL, RA_MAT, R_E_C_N_O_ AS REGSRA "
cQr += " FROM "+RetSqlName("SRA")+ " "
cQr += " WHERE RA_SITFOLH <> 'D' "
cQr += " AND RA_CODUSU_ = '      ' "
cQr += " AND "+RETSQLNAME("SRA")+".D_E_L_E_T_ <> '*' "

//�������������������������������Ŀ
//�Fecha alias caso esteja aberto �
//���������������������������������
If Select("TMA") > 0
	DBSelectArea("TMA")
	DBCloseArea()
EndIf

dbUseArea(.T.,"TOPCONN", TCGENQRY(,,cQr),"TMA",.F.,.T.)

While !Tma->(Eof())

   If ( nPos := aScan( aUsers, { |x| SubStr( x[2], 1, 2 ) == '05' .and. SubStr( x[2], 3, 2 ) == Tma->Ra_Filial .and. SubStr( x[2], 5, 6 ) == Tma->Ra_Mat } ) ) > 0
      	SRA->(dbGoto(Tma->RegSra))
        Reclock("SRA",.F.)
        Sra->Ra_CodUsu_ := aUsers[nPos,1]
        Sra->(MsUnlock())                             
   Endif
   
   Tma->(dbSkip())
  
EndDo
        

Return

