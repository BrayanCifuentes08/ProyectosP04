CREATE OR ALTER PROCEDURE Pa_delete_User_Elemento_Asignado(
    @pUserName VARCHAR(30),
    @pElemento_Asignado INT
)
AS
BEGIN
    DECLARE @mensaje NVARCHAR(100); 
    DECLARE @resultado BIT;
	DECLARE @descripcion NVARCHAR(100);

	SELECT @descripcion = descripcion 
    FROM [dbo].[tbl_Elemento_Asignado] 
    WHERE Elemento_Asignado = @pElemento_Asignado;

    -- Verifica si el elemento asignado es valido
    IF NOT EXISTS (SELECT 1 FROM [dbo].[tbl_Elemento_Asignado] WHERE Elemento_Asignado = @pElemento_Asignado)
    BEGIN
        SET @mensaje = 'El elemento especificado no existe o no es válido.';
        SET @resultado = 0;
        SELECT @resultado AS Resultado, @mensaje AS Mensaje;
        RETURN;
    END

    -- Verifica si existe una asignacion entre el usuario y el elemento
    IF NOT EXISTS (SELECT 1 FROM [dbo].[tbl_User_Elemento_Asignado]
                   WHERE UserName = @pUserName AND Elemento_Asignado = @pElemento_Asignado)
    BEGIN
        SET @mensaje =  CONCAT('No existe una asignación previa entre el usuario y el elemento "', @descripcion, '".');
        SET @resultado = 0;
        SELECT @resultado AS Resultado, @mensaje AS Mensaje;
        RETURN;
    END

    -- Elimina la asignación si todas las validaciones pasan
    DELETE FROM [dbo].[tbl_User_Elemento_Asignado]
    WHERE UserName = @pUserName 
      AND Elemento_Asignado = @pElemento_Asignado;

    SET @resultado = 1;
    SELECT @resultado AS Resultado
END