#include "rwmake.ch"
//------------------------------------------------------
User Function BDIWhen()

_lRet := IIF(INCLUI .OR. ALTERA .OR. M->ZO_IMPRES=="S" .OR. M->ZO_BDI=="2",.F.,.T.)      

Return(_lRet)
//------------------------------------------------------
User Function ContWhen()

_lRet := IIF(INCLUI .OR. ALTERA .OR. M->ZO_IMPRES=="S" .OR. M->ZO_CONTATO=="2",.F.,.T.)      

Return(_lRet)
//------------------------------------------------------
User Function EntWhen()

_lRet := IIF(INCLUI .OR. ALTERA .OR. M->ZO_IMPRES=="S" .OR. M->ZO_ENTID=="2",.F.,.T.)      

Return(_lRet)
//------------------------------------------------------
User Function CargWhen()

_lRet := IIF(INCLUI .OR. ALTERA .OR. M->ZO_IMPRES=="S" .OR. M->ZO_CARGO=="2",.F.,.T.)      

Return(_lRet)
//------------------------------------------------------
User Function CatgWhen()

_lRet := IIF(INCLUI .OR. ALTERA .OR. M->ZO_IMPRES=="S" .OR. M->ZO_CATEG=="2",.F.,.T.)      

Return(_lRet)