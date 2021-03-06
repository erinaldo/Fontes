if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[rj_cry01_01]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[rj_cry01_01]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[rj_cry02_01]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[rj_cry02_01]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_cry01_01]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_cry01_01]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_cry02_01]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_cry02_01]
GO

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO


/*
------------------------------------------------------------------------------------------------------------
ANALISTA    JOAO MARCELO SELLEIRO
EMPRESA     MICROSIGA SOFTWARE
DEPARTAMENTO    BUSINESS INTELLIGENCE
------------------------------------------------------------------------------------------------------------
*/

CREATE PROCEDURE rj_cry01_01 (
    @PAR_FILIAL CHAR(2),
    @PAR_NUMDE      CHAR(6),
    @PAR_NUMATE     CHAR(6),
    @PAR_VIA1   CHAR(2),
    @PAR_VIA2   CHAR(2),
    @PAR_VIA3   CHAR(2),
    @PAR_VIA4   CHAR(2),
    @PAR_USADO  CHAR(1),
    @PAR_END1   CHAR(60),
    @PAR_END2   CHAR(60),
    @PAR_END3   CHAR(60),
    @PAR_END4   CHAR(60)
)
AS
BEGIN

    SET ANSI_WARNINGS   OFF
    SET ARITHABORT      OFF
    SET NOCOUNT     OFF

    SELECT
    C7_FILIAL,
    C7_NUM,
    SX5_Z2.X5_DESCRI,
    C7_FORNECE,
    A2_NOME,
    A2_END,
    A2_BAIRRO,
    A2_MUN,
    A2_EST,
    A2_CEP,
    A2_TEL,
    A2_FAX,
    A2_CONTATO,
    A2_CGC,
    CONVERT(DATETIME,C7_EMISSAO) C7_EMISSAO,
    C7_ITEM,
    C7_PRODUTO,
    B1_DESC,
    COALESCE(CONVERT(TEXT, CONVERT(VARCHAR(8000), UPPER(CONVERT(VARBINARY(8000), B1_ESPEC)))),'') B1_ESPEC,
    C7_QUANT,
    C7_UM,
    C7_PRECO,
    C7_TOTAL-C7_VLDESC C7_TOTAL,
    C7_NUMSC,
    COALESCE(C1_NUMCIEE,'') C1_NUMCIEE,
    C7_DESC,
    C7_VLDESC,
    CONVERT(DATETIME,C7_DATPRF) C7_DATPRF,
    C7_CC,
    C7_COND,
    COALESCE(E4_DESCRI, '') E4_DESCRI,
    COALESCE(ZH_PESSOA1, '') ZH_PESSOA1,
    COALESCE(ZH_PESSOA2, '') ZH_PESSOA2,
    COALESCE(ZH_PESSOA3, '') ZH_PESSOA3,
    COALESCE(ZH_PESSOA4, '') ZH_PESSOA4,
    COALESCE(ZH_PESSOA5, '') ZH_PESSOA5,
    COALESCE(ZH_LOCAL, '') ZH_LOCAL,
    COALESCE(CONVERT(TEXT, CONVERT(VARCHAR(8000), CONVERT(VARBINARY(8000), ZH_OBS))),'') ZH_OBS

    FROM SC7030 SC7
               JOIN SB1030 SB1      ON (B1_FILIAL = C7_FILIAL AND B1_COD = C7_PRODUTO  AND SB1.D_E_L_E_T_ = ' ')
               JOIN SA2030 SA2      ON (A2_FILIAL = '  '      AND A2_COD = C7_FORNECE  AND A2_LOJA = C7_LOJA AND SA2.D_E_L_E_T_ = ' ')
    LEFT OUTER JOIN SE4030  SE4      ON (E4_FILIAL = C7_FILIAL AND E4_CODIGO = C7_COND  AND SE4.D_E_L_E_T_ = ' ')
    LEFT OUTER JOIN SZH030 SZH      ON (ZH_FILIAL = C7_FILIAL AND ZH_NUM    = C7_NUM   AND SZH.D_E_L_E_T_ = ' ')
    LEFT OUTER JOIN SC8030  SC8      ON (C8_FILIAL = C7_FILIAL AND C8_NUMPED = C7_NUM AND C8_ITEMPED = C7_ITEM AND C8_PRODUTO = C7_PRODUTO AND C8_FORNECE = C7_FORNECE AND C8_LOJA = C7_LOJA AND SC8.D_E_L_E_T_ = ' ')
    LEFT OUTER JOIN VIEW_SC1030 SC1 ON (C1_FILIAL = C7_FILIAL AND C1_NUM    = C7_NUMSC AND C1_ITEM = C7_ITEMSC AND SC1.D_E_L_E_T_ = ' ')
           JOIN SX5030 SX5_Z2 ON (SX5_Z2.X5_TABELA = 'Z2' AND LEFT(SX5_Z2.X5_CHAVE,2) IN (@PAR_VIA1,@PAR_VIA2,@PAR_VIA3,@PAR_VIA4) AND SX5_Z2.D_E_L_E_T_ = ' ')
    WHERE   C7_FILIAL = @PAR_FILIAL
    AND C7_NUM = @PAR_NUMDE
    AND SC7.D_E_L_E_T_ = ' '
    ORDER BY
    C7_FILIAL,
    C7_NUM,
    SX5_Z2.X5_DESCRI,
    C7_ITEM

END
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO





CREATE  PROCEDURE rj_cry02_01 (   -- Parametros utilizados
    @PAR_PROD_DE       CHAR(15), -- Cod produto de
    @PAR_PROD_ATE      CHAR(15), -- Cod produto até */
    @PAR_NUM_DE        CHAR(6),  -- Pedido de Compra de
    @PAR_NUM_ATE       CHAR(6),  -- Pedido de Compra ate
    @PAR_DT_EMI_DE     DATETIME, -- Data de emissao de
    @PAR_DT_EMI_ATE    DATETIME, -- Data de emissao ate
    @PAR_DT_ENT_DE     DATETIME, -- Data de entrega de
    @PAR_DT_ENT_ATE    DATETIME, -- Data de entrega ate
    @PAR_IMPRIME_ESPEC INT,      -- Imprime especificação ? 1-SIM ,2-NÃO
    @PAR_GRUPO_DE      CHAR(4),  -- Grupo de Produto de
    @PAR_GRUPO_ATE     CHAR(4),  -- Grupo de Produto ate
    @PAR_NAO_GRUPO     CHAR(99),  -- Grupo que não deve ser considerado. Usado apenas no relatório
    @PAR_NAO_PRODUTO   CHAR(99)  -- Produto que não deve ser considerado. Usado apenas no relatório
)
as
BEGIN
    SET ANSI_WARNINGS   OFF
    SET ARITHABORT      OFF
    SET NOCOUNT     OFF

    SELECT
        C7_NUM,
        C7_FORNECE,
        A2_NOME,
        B1_DESC,
        COALESCE(CONVERT(TEXT, CONVERT(VARCHAR(8000), UPPER(CONVERT(VARBINARY(8000), B1_ESPEC)))),'') B1_ESPEC,
        C7_CC,
        CASE WHEN C7_CC = '' THEN 'Almoxarifado'
            ELSE I3_DESC END
        AS I3_DESC,
        C7_QUANT,
        C7_UM,
        C7_PRECO,
        (C7_TOTAL-C7_VLDESC) as C7_TOTAL,
        B1_GRUPO,
        B1_COD

    FROM SC7030 SC7
        LEFT OUTER JOIN SB1030 SB1      ON (B1_FILIAL = C7_FILIAL AND B1_COD = C7_PRODUTO  AND SB1.D_E_L_E_T_ = ' ')
        LEFT OUTER JOIN SA2030 SA2      ON (A2_FILIAL = '  '      AND A2_COD = C7_FORNECE  AND A2_LOJA = C7_LOJA AND SA2.D_E_L_E_T_ = ' ')
        LEFT OUTER JOIN SI3030 SI3      ON (I3_FILIAL = C7_FILIAL AND I3_CUSTO = C7_CC  AND I3_CONTA = '' AND SI3.D_E_L_E_T_ = ' ')

    WHERE C7_FILIAL = '01'
        AND C7_NUM BETWEEN @PAR_NUM_DE AND @PAR_NUM_ATE
        AND C7_EMISSAO BETWEEN Convert(CHAR(8),@PAR_DT_EMI_DE,112) AND Convert(CHAR(8),@PAR_DT_EMI_ATE,112)
        AND C7_DATPRF  BETWEEN Convert(CHAR(8),@PAR_DT_ENT_DE,112) AND Convert(CHAR(8),@PAR_DT_ENT_ATE,112)
        AND C7_PRODUTO BETWEEN @PAR_PROD_DE AND @PAR_PROD_ATE
        AND B1_GRUPO BETWEEN @PAR_GRUPO_DE AND @PAR_GRUPO_ATE
        AND SC7.D_E_L_E_T_ = ' '

    ORDER BY
    C7_NUM, C7_PRODUTO

END




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


/*
------------------------------------------------------------------------------------------------------------
ANALISTA    JOAO MARCELO SELLEIRO
EMPRESA     MICROSIGA SOFTWARE
DEPARTAMENTO    BUSINESS INTELLIGENCE
------------------------------------------------------------------------------------------------------------
*/

CREATE PROCEDURE sp_cry01_01 (
    @PAR_FILIAL CHAR(2),
    @PAR_NUMDE      CHAR(6),
    @PAR_NUMATE     CHAR(6),
    @PAR_VIA1   CHAR(2),
    @PAR_VIA2   CHAR(2),
    @PAR_VIA3   CHAR(2),
    @PAR_VIA4   CHAR(2),
    @PAR_USADO  CHAR(1),
    @PAR_END1   CHAR(60),
    @PAR_END2   CHAR(60),
    @PAR_END3   CHAR(60),
    @PAR_END4   CHAR(60)
)
AS
BEGIN

    SET ANSI_WARNINGS   OFF
    SET ARITHABORT      OFF
    SET NOCOUNT     OFF

    SELECT
    C7_FILIAL,
    C7_NUM,
    SX5_Z2.X5_DESCRI,
    C7_FORNECE,
    A2_NOME,
    A2_END,
    A2_BAIRRO,
    A2_MUN,
    A2_EST,
    A2_CEP,
    A2_TEL,
    A2_FAX,
    A2_CONTATO,
    A2_CGC,
    CONVERT(DATETIME,C7_EMISSAO) C7_EMISSAO,
    C7_ITEM,
    C7_PRODUTO,
    B1_DESC,
    COALESCE(CONVERT(TEXT, CONVERT(VARCHAR(8000), UPPER(CONVERT(VARBINARY(8000), B1_ESPEC)))),'') B1_ESPEC,
    C7_QUANT,
    C7_UM,
    C7_PRECO,
    C7_TOTAL-C7_VLDESC C7_TOTAL,
    C7_NUMSC,
    COALESCE(C1_NUMCIEE,'') C1_NUMCIEE,
    C7_DESC,
    C7_VLDESC,
    CONVERT(DATETIME,C7_DATPRF) C7_DATPRF,
    C7_CC,
    C7_COND,
    COALESCE(E4_DESCRI, '') E4_DESCRI,
    COALESCE(ZH_PESSOA1, '') ZH_PESSOA1,
    COALESCE(ZH_PESSOA2, '') ZH_PESSOA2,
    COALESCE(ZH_PESSOA3, '') ZH_PESSOA3,
    COALESCE(ZH_PESSOA4, '') ZH_PESSOA4,
    COALESCE(ZH_PESSOA5, '') ZH_PESSOA5,
    COALESCE(ZH_LOCAL, '') ZH_LOCAL,
    COALESCE(CONVERT(TEXT, CONVERT(VARCHAR(8000), CONVERT(VARBINARY(8000), ZH_OBS))),'') ZH_OBS

    FROM SC7010 SC7
               JOIN SB1010 SB1      ON (B1_FILIAL = C7_FILIAL AND B1_COD = C7_PRODUTO  AND SB1.D_E_L_E_T_ = ' ')
               JOIN SA2010 SA2      ON (A2_FILIAL = '  '      AND A2_COD = C7_FORNECE  AND A2_LOJA = C7_LOJA AND SA2.D_E_L_E_T_ = ' ')
    LEFT OUTER JOIN SE4010 SE4      ON (E4_FILIAL = C7_FILIAL AND E4_CODIGO = C7_COND  AND SE4.D_E_L_E_T_ = ' ')
    LEFT OUTER JOIN SZH010 SZH      ON (ZH_FILIAL = C7_FILIAL AND ZH_NUM    = C7_NUM   AND SZH.D_E_L_E_T_ = ' ')
    LEFT OUTER JOIN SC8010      SC8 ON (C8_FILIAL = C7_FILIAL AND C8_NUMPED = C7_NUM AND C8_ITEMPED = C7_ITEM AND C8_PRODUTO = C7_PRODUTO AND C8_FORNECE = C7_FORNECE AND C8_LOJA = C7_LOJA AND SC8.D_E_L_E_T_ = ' ')
    LEFT OUTER JOIN VIEW_SC1010 SC1 ON (C1_FILIAL = C7_FILIAL AND C1_NUM    = C7_NUMSC AND C1_ITEM = C7_ITEMSC AND SC1.D_E_L_E_T_ = ' ')
           JOIN SX5010 SX5_Z2 ON (SX5_Z2.X5_TABELA = 'Z2' AND LEFT(SX5_Z2.X5_CHAVE,2) IN (@PAR_VIA1,@PAR_VIA2,@PAR_VIA3,@PAR_VIA4) AND SX5_Z2.D_E_L_E_T_ = ' ')
    WHERE   C7_FILIAL = @PAR_FILIAL
    AND C7_NUM = @PAR_NUMDE
    AND SC7.D_E_L_E_T_ = ' '
    ORDER BY
    C7_FILIAL,
    C7_NUM,
    SX5_Z2.X5_DESCRI,
    C7_ITEM

END


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO



CREATE PROCEDURE sp_cry02_01 (   -- Parametros utilizados
    @PAR_PROD_DE       CHAR(15), -- Cod produto de
    @PAR_PROD_ATE      CHAR(15), -- Cod produto até */
    @PAR_NUM_DE        CHAR(6),  -- Pedido de Compra de
    @PAR_NUM_ATE       CHAR(6),  -- Pedido de Compra ate
    @PAR_DT_EMI_DE     DATETIME, -- Data de emissao de
    @PAR_DT_EMI_ATE    DATETIME, -- Data de emissao ate
    @PAR_DT_ENT_DE     DATETIME, -- Data de entrega de
    @PAR_DT_ENT_ATE    DATETIME, -- Data de entrega ate
    @PAR_IMPRIME_ESPEC INT,      -- Imprime especificação ? 1-SIM ,2-NÃO
    @PAR_GRUPO_DE      CHAR(4),  -- Grupo de Produto de
    @PAR_GRUPO_ATE     CHAR(4),  -- Grupo de Produto ate
    @PAR_NAO_GRUPO     CHAR(99),  -- Grupo que não deve ser considerado. Usado apenas no relatório
    @PAR_NAO_PRODUTO   CHAR(99)  -- Produto que não deve ser considerado. Usado apenas no relatório
)
as
BEGIN
    SET ANSI_WARNINGS   OFF
    SET ARITHABORT      OFF
    SET NOCOUNT     OFF

    SELECT
        C7_NUM,
        C7_FORNECE,
        A2_NOME,
        B1_DESC,
        COALESCE(CONVERT(TEXT, CONVERT(VARCHAR(8000), UPPER(CONVERT(VARBINARY(8000), B1_ESPEC)))),'') B1_ESPEC,
        C7_CC,
        CASE WHEN C7_CC = '' THEN 'Almoxarifado'
            ELSE I3_DESC END
        AS I3_DESC,
        C7_QUANT,
        C7_UM,
        C7_PRECO,
        (C7_TOTAL-C7_VLDESC) as C7_TOTAL,
        B1_GRUPO,
        B1_COD

    FROM SC7010 SC7
        LEFT OUTER JOIN SB1010 SB1      ON (B1_FILIAL = C7_FILIAL AND B1_COD = C7_PRODUTO  AND SB1.D_E_L_E_T_ = ' ')
        LEFT OUTER JOIN SA2010 SA2      ON (A2_FILIAL = '  '      AND A2_COD = C7_FORNECE  AND A2_LOJA = C7_LOJA AND SA2.D_E_L_E_T_ = ' ')
        LEFT OUTER JOIN SI3010 SI3      ON (I3_FILIAL = C7_FILIAL AND I3_CUSTO = C7_CC  AND I3_CONTA = '' AND SI3.D_E_L_E_T_ = ' ')

    WHERE C7_FILIAL = '01'
        AND C7_NUM BETWEEN @PAR_NUM_DE AND @PAR_NUM_ATE
        AND C7_EMISSAO BETWEEN Convert(CHAR(8),@PAR_DT_EMI_DE,112) AND Convert(CHAR(8),@PAR_DT_EMI_ATE,112)
        AND C7_DATPRF  BETWEEN Convert(CHAR(8),@PAR_DT_ENT_DE,112) AND Convert(CHAR(8),@PAR_DT_ENT_ATE,112)
        AND C7_PRODUTO BETWEEN @PAR_PROD_DE AND @PAR_PROD_ATE
        AND B1_GRUPO BETWEEN @PAR_GRUPO_DE AND @PAR_GRUPO_ATE
        AND SC7.D_E_L_E_T_ = ' '

    ORDER BY
    C7_NUM, C7_PRODUTO

END


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

