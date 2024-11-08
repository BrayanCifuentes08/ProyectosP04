--Ejecutar por cambio de nombre
CREATE OR ALTER PROCEDURE paCrudUser(
    @accion                 INT,
    @pCriterioBusqueda      VARCHAR(100) = NULL,
	@pUserName              VARCHAR(30)  = NULL,
    @pName					VARCHAR(200) = NULL,
    @pEstado                TINYINT      = NULL,
    @pFecha_Hora            DATETIME     = NULL
)
AS
BEGIN
    DECLARE @Mensaje VARCHAR(255);
    DECLARE @Resultado BIT;
	DECLARE @NuevoUserName SMALLINT;

    -- 1. Verificación de parámetros obligatorios
    IF @pUserName IS NULL AND @accion IN (3, 4)
    BEGIN
        SET @Mensaje = 'El parámetro @pUserName es obligatorio para las acciones de actualización y eliminación.';
        SET @Resultado = 0;
        SELECT @Mensaje AS Mensaje, @Resultado AS Resultado;
        RETURN;
    END

    IF @accion = 1
    BEGIN
		IF @pCriterioBusqueda IS NULL
		BEGIN
            SELECT 
                UserName,
                [Name],
				Estado,
				Fecha_Hora,
                @Mensaje AS Mensaje,
                1 AS Resultado -- Operación exitosa
            FROM tbl_User;
		END
		ELSE
		BEGIN
		IF EXISTS (
				SELECT 1 
				FROM tbl_User 
				WHERE [Name] LIKE '%' + @pCriterioBusqueda + '%'
			)
		 BEGIN
		 SELECT 
                UserName,
                [Name],
				Estado,
				Fecha_Hora,
                @Mensaje AS Mensaje,
                1 AS Resultado -- Operación exitosa
            FROM tbl_User
			WHERE [Name] LIKE '%' + @pCriterioBusqueda + '%'
		END
			ELSE
			BEGIN
				-- Si no hay coincidencias
				SET @Mensaje = 'No se encontraron resultados para el criterio de búsqueda proporcionado.';
				SET @Resultado = 0;
				SELECT @Mensaje AS Mensaje, @Resultado AS Resultado;
				RETURN;
			END
		END
    END
    ELSE IF @accion = 2
    BEGIN

        -- 2. Generar nuevo valor para @pTipoCanalDistribucion
        SELECT @NuevoUserName = ISNULL(MAX(TipoCanalDistribucion), 0) + 1 FROM TipoCanalDistribucion;


        -- INSERT
        INSERT INTO TipoCanalDistribucion 
        (
            [TipoCanalDistribucion],
            [Descripcion],
            [Estado],
            [Fecha_Hora],
            [UserName]
        )
        VALUES 
        (
            @NuevoTipoCanalDistribucion,
            @pDescripcion,
            1,
            GETDATE(), 
            @pUserName
        );

        SET @Mensaje = 'Registro insertado exitosamente.';
        SET @Resultado = 1;
        SELECT @Mensaje AS Mensaje, @Resultado AS Resultado;
    END
    ELSE IF @accion = 3
    BEGIN
        -- 3. Error al intentar actualizar un registro inexistente
        IF NOT EXISTS (SELECT 1 FROM TipoCanalDistribucion WHERE TipoCanalDistribucion = @pUserName)
        BEGIN
            SET @Mensaje   = 'No se encontró un registro con el TipoCanalDistribucion para actualizar.';
            SET @Resultado = 0;
            SELECT @Mensaje AS Mensaje, @Resultado AS Resultado;
            RETURN;
        END

        -- UPDATE
        UPDATE TipoCanalDistribucion
        SET 
            Descripcion = @pDescripcion,
            Estado = @pEstado,
			M_Fecha_Hora = GETDATE(),
			M_UserName = @pUserName
        WHERE 
            TipoCanalDistribucion = @pUserName;

        SET @Mensaje = 'Registro actualizado exitosamente.';
        SET @Resultado = 1;
        SELECT @Mensaje AS Mensaje, @Resultado AS Resultado;
    END
    ELSE IF @accion = 4
    BEGIN
		-- Verificar si el registro está relacionado con la tabla CanalDistribucion
		IF EXISTS (SELECT 1 FROM CanalDistribucion WHERE TipoCanalDistribucion = @pUserName)
		BEGIN
			SET @Mensaje   = 'No se puede eliminar el registro porque tiene asociados otros registros.';
			SET @Resultado = 0;
			SELECT @Mensaje AS Mensaje, @Resultado AS Resultado;
			RETURN;
		END
        -- 4. Error al intentar eliminar un registro inexistente
        IF NOT EXISTS (SELECT 1 FROM TipoCanalDistribucion WHERE TipoCanalDistribucion = @pUserName)
        BEGIN
            SET @Mensaje = 'No se encontró un registro con el TipoCanalDistribucion para eliminar.';
            SET @Resultado = 0;
            SELECT @Mensaje AS Mensaje, @Resultado AS Resultado;
            RETURN;
        END

        -- DELETE
        DELETE FROM TipoCanalDistribucion
        WHERE TipoCanalDistribucion = @pUserName;

        SET @Mensaje = 'Registro eliminado exitosamente.';
        SET @Resultado = 1;
        SELECT @Mensaje AS Mensaje, @Resultado AS Resultado;
    END
END;

