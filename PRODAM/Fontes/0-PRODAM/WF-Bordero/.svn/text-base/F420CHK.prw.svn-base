#Include 'Protheus.ch'

User Function F420CHK()

Local _nRet		:= 1 //1- Grava 0- Nao Grava 
Local _cArqSE2 	:= CriaTrab(nil,.f.)
// verifica se esta totalmente liberado
_cQuery := "SELECT E2_XSTSAPV, E2_NUMBOR FROM "+RetSqlName("SE2")+" "
_cQuery += "WHERE D_E_L_E_T_ = ' ' AND E2_NUMBOR BETWEEN '"+MV_PAR01+"' AND  '"+MV_PAR02+"' AND E2_XSTSAPV IN ('2','3') "
_cQuery := ChangeQuery(_cQuery)
			
dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQuery),_cArqSE2,.t.,.t.)

	IF (_cArqSE2)->(Eof())
		_nRet := 1
	Else
		_nRet := 0
		If _lFirstBord
			MsgInfo(	"Existem Titulos não aprovados nos Borderos selecionados "+chr(10)+chr(13) + "os registros não serão gravados no arquivo CNAB")
			_lFirstBord := .F.
		EndIf 
	EndIF

Return(_nRet)

