#Include 'Protheus.ch'

User Function CQDOG001()

cDirect    := "\imagens\atualizacao\"
cDirectImp := "\imagens\"
aDirect    := Directory(cDirect+"*.*")

//Copia e Deleta o arquivo da pasta Origem para a pasta Importado. De qualquer Banco
For _nI := 1 to Len(adirect)
	If alltrim(M->PA4_CODDOC) == alltrim(adirect[_nI,1])
		__copyfile(cDirect+adirect[_nI,1],cDirectImp+adirect[_nI,1])
		ferase(cDirect+adirect[_nI,1])
	EndIf
Next

Return(alltrim(M->PA4_CODDOC))

