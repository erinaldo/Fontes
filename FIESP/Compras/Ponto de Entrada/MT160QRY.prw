#include "rwmake.ch"
#include "protheus.ch"
#include "TOPCONN.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT160QRY  �Autor  �L�gia Sarnauskas    � Data �  25/11/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada executado para aplicar filtro na Analise  ���
���          � de Cota��es carregadas no browse.                          ���
�������������������������������������������������������������������������͹��
���Uso       � FIESP                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT160QRY()

Local cFiltraSC8
Local cCRLF			:= CRLF

_cCodUser	:=__CUSERID

cFiltraSC8	:= "C8_GRUPCOM "
cFiltraSC8	+= "			IN" + cCRLF
cFiltraSC8	+= "			(" + cCRLF
cFiltraSC8	+= "				SELECT"+ cCRLF
cFiltraSC8	+= "					SAJ.AJ_GRCOM "+cCRLF
cFiltraSC8	+= "				FROM                                      " + cCRLF
cFiltraSC8	+= "					" + RetSqlName( "SAJ" ) + " SAJ       " + cCRLF
cFiltraSC8	+= "				WHERE                                     " + cCRLF 
cFiltraSC8	+= "					SAJ.D_E_L_E_T_ = ' '                  " + cCRLF 
cFiltraSC8	+= "					AND SAJ.AJ_USER = '"+_cCodUser+"'    )" + cCRLF 


Return(cFiltraSC8)
