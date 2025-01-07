CREATE OR ALTER PROCEDURE paModuloIsr (@pOpcion INT)
AS
BEGIN
    -- Verificamos el valor del parámetro pOpcion
    IF @pOpcion = 1
    BEGIN
        SELECT * FROM CargaLiquidacionFinPeriodo;
    END
    ELSE IF @pOpcion = 2
    BEGIN
        SELECT * FROM RetencionPorPago;
    END
    ELSE IF @pOpcion = 3
    BEGIN
        SELECT * FROM CargasAjustesYSuspensiones;
    END
    ELSE IF @pOpcion = 4
    BEGIN
        SELECT * FROM CargaProyeccionesYActualizacion;
    END
    ELSE IF @pOpcion = 5
    BEGIN
        SELECT * FROM CargaLiquidacionFinDeLabores;
    END
    ELSE
    BEGIN
        -- Si el parámetro no coincide con ninguna opción válida
        PRINT 'Opción no válida';
    END
END;

execute paModuloIsr 1

