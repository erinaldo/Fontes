#INCLUDE "protheus.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "topconn.ch"

User Function WFDemDia()
Return u_CSWFDemDia()

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CSWFDEMDIA� Autor � RENATO CARLOS/Isamu� Data �  19/12/2011 ���
�������������������������������������������������������������������������͹��
���Descricao � Gera o arquivo para importa��o no sistema WFM              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Exclusivo da CSU.                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function CSWFDEMDIA()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

PREPARE ENVIRONMENT EMPRESA "05" FILIAL "03" MODULO "GPE"

Private _aArea := GetArea()
Private oGeraTxt
Private oHTML
Private cDirDocs := MsDocPath()            // Diretorio de docs do servidor
Private cTmpTxt  := CriaTrab(Nil,.f.)
Private cCmd     := cDirDocs+"\"+cTmpTxt+".txt"

u_OkGeraArq(cCmd)

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
User Function OkGeraArq(cCmd)

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local _dData := If(Type("dDataBase")=="U",Date(),dDataBase)
Local _cQrySRA := ""
Local cTmpSRA  := "cTmpSRA"
Local dOntem   := dDataBase-1
Local cOntem   := Dtos(dOntem)
Local _cArqWFM := "\WFM\Demitidos\DEM"+cOntem+".TXT"

Private lOk := .F.
Private cLinSRA
Private cLinAfa
Private bLinSRA
Private bLinMail
Private nHdl := fCreate(cCmd)

bLinSRA := {|| cLin1 := @RA_CIC+@RA_NOME+CHR(13)+CHR(10)}

_cQrySRA := " SELECT MAX(A.RA_DEMISSA), A.RA_NOME, A.RA_CIC "
_cQrySRA += " FROM "+RetSqlName("SRA")+" A, "+RetSqlName("SRG")+" "
_cQrySRA += " WHERE NOT EXISTS "

_cQrySRA += " (SELECT B.RA_NOME, B.RA_CIC FROM "+RetSqlName("SRA")+" B "
_cQrySRA += " WHERE B.RA_MAT != A.RA_MAT AND B.RA_DEMISSA = '' AND B.RA_CIC = A.RA_CIC) "

_cQrySRA += " AND A.RA_MAT = RG_MAT "
_cQrySRA += " AND A.RA_FILIAL = RG_FILIAL "
_cQrySRA += " AND A.RA_DEMISSA = '"+cOntem+"' "
_cQrySRA += " AND A.RA_RESCRAI NOT IN('31') "
_cQrySRA += " AND A.D_E_L_E_T_ = '' "
_cQrySRA += " GROUP BY A.RA_NOME, A.RA_CIC "
_cQrySRA += " ORDER BY A.RA_NOME "

//MemoWrite("C:\PCS.TXT",_cQrySRA)

dbUseArea( .T., 'TOPCONN', TcGenQry(,,_cQrySRA), cTmpSRA, .T., .F. )

(cTmpSRA)->( DbGoTop() )

DbSelectArea("cTmpSRA")

IF EOF()
	
	Memowrite("\WFM\DEMITIDOS\DEM"+cOntem+".TXT","NAO EXISTEM FUNCIONARIOS DEMITIDOS ONTEM")
	
	RETURN
	
ENDIF

GeraCsv(cCmd,cLinSRA,cTmpSRA,_cArqWFM,bLinSRA)
cTmpSRA->(DbCloseArea())

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Geracsv   �Autor  �Renato Carlos       � Data �             ���
�������������������������������������������������������������������������͹��
���Desc.     �  Gera CSV                                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP10-CSU                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function GeraCsv(cCmd,cLin1,_cAlias,cArq,bLin1)

DbSelectArea(_cAlias)

While (_cAlias)->( !EOF() )
	Eval(bLin1)
	fWrite(nHdl,cLin1,Len(cLin1))
	(_cAlias)->(dbSkip())
	
EndDo
fClose(nHdl)
__CopyFile(cCmd, cArq)

RETURN
