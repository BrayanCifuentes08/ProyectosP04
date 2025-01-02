USE [test_cuenta_corriente]
GO
/****** Object:  StoredProcedure [dbo].[paCrudLiquidacion]    Script Date: 20/12/2024 17:47:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER   PROCEDURE [dbo].[paCrudLiquidacion]
    @accion INT, 
    @pNit VARCHAR(15) = NULL,
    @pNombresYApellidos VARCHAR(255)= NULL,
    @pRentasBrutas DECIMAL(15, 2)= NULL,
    @pRentasExentas DECIMAL(15, 2)= NULL,
    @pDeducSinComprobacion DECIMAL(15, 2)= NULL,
    @pDeduccionesPlanillaIva DECIMAL(15, 2)= NULL,
    @pDonaciones DECIMAL(15, 2)= NULL,
    @pCuotasSeguroSocial DECIMAL(15, 2)= NULL,
    @pPrimaSeguroVida DECIMAL(15, 2)= NULL,
    @pRentaImponible DECIMAL(15, 2)= NULL,
    @pImpuestoAnualAPagar DECIMAL(15, 2)= NULL,
    @pOtrosCreditos DECIMAL(15, 2)= NULL,
    @pRetencionesPracticadas DECIMAL(15, 2)= NULL,
    @pImpuestoPendientePago DECIMAL(15, 2)= NULL,
    @pLoDevueltoEmpleados DECIMAL(15, 2)= NULL,
    @pImpuestoADevolver DECIMAL(15, 2) = NULL
AS
BEGIN
    IF @accion = 1 
    BEGIN
        -- Realizar SELECT
        SELECT * FROM liquidacion
    END
    ELSE IF @accion = 2
    BEGIN
        -- Realizar INSERT
        INSERT INTO liquidacion (
            Nit, 
            NombresYApellidos, 
            RentasBrutas, 
            RentasExentas, 
            DeducSinComprobacion, 
            DeduccionesPlanillaIva, 
            Donaciones, 
            CuotasSeguroSocial, 
            PrimaDeSeguroVida, 
            RentaImponible, 
            ImpuestoAnualAPagar, 
            OtrosCreditos, 
            RetencionesPracticadas, 
            ImpuestoPendienteDePago, 
            LoDevueltoAEmpleados, 
            ImpuestoADevolver
        ) VALUES (
            @pNit, 
            @pNombresYApellidos, 
            @pRentasBrutas, 
            @pRentasExentas, 
            @pDeducSinComprobacion, 
            @pDeduccionesPlanillaIva, 
            @pDonaciones, 
            @pCuotasSeguroSocial, 
            @pPrimaSeguroVida, 
            @pRentaImponible, 
            @pImpuestoAnualAPagar, 
            @pOtrosCreditos, 
            @pRetencionesPracticadas, 
            @pImpuestoPendientePago, 
            @pLoDevueltoEmpleados, 
            @pImpuestoADevolver
        )
    END
END