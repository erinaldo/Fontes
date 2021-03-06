#Include 'Protheus.ch'

/*-----------------+---------------------------------------------------------+
!Nome              ! MA126FIL - Cliente: Madero                              !
+------------------+---------------------------------------------------------+
!Descrição         ! PE para definir chave de aglutinação de SCs             !
+------------------+---------------------------------------------------------+
!Autor             ! Pedro A. de Souza                                       !
+------------------+---------------------------------------------------------!
!Data              ! 22/05/2018                                              !
+------------------+--------------------------------------------------------*/
User Function MA126FIL()
Local cFiltro := PARAMIXB[1]
	If AllTrim(FunName()) == "EST100" 
		cFiltro += " AND C1_XORIGEM = 'EST100' "
	Endif
conOut("PE: MA126FIL: "+FunName())
return cFiltro




/*-----------------+---------------------------------------------------------+
!Nome              ! MA126QSC - Cliente: Madero                              !
+------------------+---------------------------------------------------------+
!Descrição         ! PE para definir chave de aglutinação de SCs             !
+------------------+---------------------------------------------------------+
!Autor             ! Pedro A. de Souza                                       !
+------------------+---------------------------------------------------------!
!Data              ! 22/05/2018                                              !
+------------------+--------------------------------------------------------*/
User Function MA126QSC()
	Local cKey := PARAMIXB[1]
	cKey := "C1_FILIAL+C1_PRODUTO+C1_TPOP+DTOS(C1_DATPRF)+C1_GRUPCOM"
return cKey
