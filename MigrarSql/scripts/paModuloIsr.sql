CREATE OR ALTER PROCEDURE paModuloIsr (@pOpcion INT)
AS
BEGIN
    -- Verificamos el valor del par�metro pOpcion
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
        -- Si el par�metro no coincide con ninguna opci�n v�lida
        PRINT 'Opci�n no v�lida';
    END
END;

execute paModuloIsr 1

