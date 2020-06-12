#Include 'Rwmake.ch'

//-----------------------------------------------------------------------
/*/{Protheus.doc} MT150END()

Ponto de entrada para tratar o campo C8_XWF

Chamado pelo PE MT150END

@param		cFilPed
@return		Nenhum	
@author 	Fabiano Albuquerque
@since 		26/06/2016
@version 	1.0
@project	MAN0000001 - Aguassanta - Integra
/*/
//-----------------------------------------------------------------------

User Function ASCOMA29()        
	Local _cNum 	:= SC8->C8_NUM             
	Local _cFornece := SC8->C8_FORNECE
	Local _cLoja	:= SC8->C8_LOJA 
	
	DBSELECTAREA("SC8")
	DBSetOrder(1)
	DBSeek(xFilial("SC8")+_cNum + _cFornece + _cLoja)
	While !SC8->(EOF()) .AND. SC8->(C8_FILIAL +  C8_NUM + C8_FORNECE + C8_LOJA) == xFilial("SC8") + _cNum + _cFornece + _cLoja   

		Reclock("SC8",.F.)
		SC8->C8_XWF		:= " " 
		MSUnlock()
		SC8->(dbSkip()) 
			 
	Enddo	
	
Return