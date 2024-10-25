CREATE OR ALTER PROCEDURE Pa_insert_User_Elemento_Asignado (
    @pUserName VARCHAR(30),
    @pElemento_Asignado INT
)
AS
BEGIN
    DECLARE @mensaje NVARCHAR(100); 
    DECLARE @resultado BIT;

    -- Verifica si el usuario existe
    IF NOT EXISTS (SELECT 1 FROM [dbo].[tbl_User] WHERE UserName = @pUserName)
    BEGIN
        SET @mensaje = 'El usuario no esta registrado.';
        SET @resultado = 0;
        SELECT @resultado AS Resultado, @mensaje AS Mensaje;
        RETURN;
    END

    -- Verifica si el elemento asignado es válido
    IF NOT EXISTS (SELECT 1 FROM [dbo].[tbl_Elemento_Asignado] WHERE Elemento_Asignado = @pElemento_Asignado)
    BEGIN
        SET @mensaje = 'El elemento asignado no existe o no es válido.';
        SET @resultado = 0;
        SELECT @resultado AS Resultado, @mensaje AS Mensaje;
        RETURN;
    END

    -- Verifica si el usuario ya tiene asignado el elemento
    IF EXISTS (SELECT 1 FROM [dbo].[tbl_User_Elemento_Asignado]
               WHERE UserName = @pUserName AND Elemento_Asignado = @pElemento_Asignado)
    BEGIN
        SET @mensaje = 'El usuario ya tiene asignado este elemento.';
        SET @resultado = 0;
        SELECT @resultado AS Resultado, @mensaje AS Mensaje;
        RETURN;
    END

    -- Inserta la asignación si todas las validaciones pasan
    INSERT INTO [dbo].[tbl_User_Elemento_Asignado] (
        UserName, 
        Elemento_Asignado, 
        Fecha_Hora)
    VALUES 
        (@pUserName, 
         @pElemento_Asignado, 
         GETDATE());

		SET @resultado = 1;
		SELECT @resultado AS Resultado
END
