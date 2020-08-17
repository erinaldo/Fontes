User Function RetNome()

  paramixb := "01/08/2003"
  _dataini := CTOD(alltrim(paramixb))

  _plaqueta := {}
  aadd(_plaqueta,{" "," "})

  dbselectarea("SRA")
  cIndice := "DTOS(RA_ADMISSA)"
  //cFiltro := "RA_FILIAL >= '  ' .AND. RA_FILIAL <= 'ZZ'"
  cArqTRB := CriaTrab(NIL,.F.)
  IndRegua("SRA",cArqTRB,cIndice,,,'Selecionando Registros...')
  nIndex:=RetIndex("SRA")
  DBSetOrder(nIndex+1)
  DBSEEK(DTOS(_DATAINI))
  WHILE !EOF()

    IF SRA->RA_ADMISSA >= _DATAINI
       aadd(_plaqueta,{SRA->RA_NOME,SRA->RA_MAT})
       DBSKIP()
       LOOP
    ELSE
       DBSKIP()
       LOOP
    ENDIF
    
  ENDDO

DBSetOrder(1)           
Return(_plaqueta)

