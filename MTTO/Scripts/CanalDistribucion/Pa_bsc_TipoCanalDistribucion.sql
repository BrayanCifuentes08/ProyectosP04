CREATE OR ALTER PROCEDURE Pa_bsc_TipoCanalDistribucion(
    @accion                 INT,
    @pCriterioBusqueda      VARCHAR(100) = NULL,
    @pTipoCanalDistribucion SMALLINT     = NULL,
    @pDescripcion           VARCHAR(200) = NULL,
    @pEstado                TINYINT      = NULL,
    @pFecha_Hora            DATETIME     = NULL,
    @pUserName              VARCHAR(30)  = NULL
)
AS
BEGIN
    DECLARE @Mensaje VARCHAR(255);
    DECLARE @Resultado BIT;
	DECLARE @NuevoTipoCanalDistribucion SMALLINT;

    -- 1. Verificaci�n de par�metros obligatorios
    IF @pTipoCanalDistribucion IS NULL AND @accion IN (3, 4)
    BEGIN
        SET @Mensaje = 'El par�metro @pTipoCanalDistribucion es obligatorio para las acciones de actualizaci�n y eliminaci�n.';
        SET @Resultado = 0;
        SELECT @Mensaje AS Mensaje, @Resultado AS Resultado;
        RETURN;
    END

    IF @accion = 1
    BEGIN
		IF @pCriterioBusqueda IS NULL
		BEGIN
            SELECT 
                [TipoCanalDistribucion],
                [Descripcion],
                [Estado],
                [Fecha_Hora],
                [UserName],
                @Mensaje AS Mensaje,
                1 AS Resultado -- Operaci�n exitosa
            FROM TipoCanalDistribucion;
		END
		ELSE
		BEGIN
		IF EXISTS (
				SELECT 1 
				FROM TipoCanalDistribucion 
				WHERE Descripcion LIKE '%' + @pCriterioBusqueda + '%'
			)
		 BEGIN
		 SELECT 
                [TipoCanalDistribucion],
                [Descripcion],
                [Estado],
                [Fecha_Hora],
                [UserName],
                @Mensaje AS Mensaje,
                1 AS Resultado -- Operaci�n exitosa
            FROM TipoCanalDistribucion
			WHERE Descripcion LIKE '%' + @pCriterioBusqueda + '%'
		END
			ELSE
			BEGIN
				-- Si no hay coincidencias
				SET @Mensaje = 'No se encontraron resultados para el criterio de b�squeda proporcionado.';
				SET @Resultado = 0;
				SELECT @Mensaje AS Mensaje, @Resultado AS Resultado;
				RETURN;
			END
		END
    END
    ELSE IF @accion = 2
    BEGIN

        -- 2. Generar nuevo valor para @pTipoCanalDistribucion
        SELECT @NuevoTipoCanalDistribucion = ISNULL(MAX(TipoCanalDistribucion), 0) + 1 FROM TipoCanalDistribucion;


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
        IF NOT EXISTS (SELECT 1 FROM TipoCanalDistribucion WHERE TipoCanalDistribucion = @pTipoCanalDistribucion)
        BEGIN
            SET @Mensaje   = 'No se encontr� un registro con el TipoCanalDistribucion para actualizar.';
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
            TipoCanalDistribucion = @pTipoCanalDistribucion;

        SET @Mensaje = 'Registro actualizado exitosamente.';
        SET @Resultado = 1;
        SELECT @Mensaje AS Mensaje, @Resultado AS Resultado;
    END
    ELSE IF @accion = 4
    BEGIN
		-- Verificar si el registro est� relacionado con la tabla CanalDistribucion
		IF EXISTS (SELECT 1 FROM CanalDistribucion WHERE TipoCanalDistribucion = @pTipoCanalDistribucion)
		BEGIN
			SET @Mensaje   = 'No se puede eliminar el registro porque tiene asociados otros registros.';
			SET @Resultado = 0;
			SELECT @Mensaje AS Mensaje, @Resultado AS Resultado;
			RETURN;
		END
        -- 4. Error al intentar eliminar un registro inexistente
        IF NOT EXISTS (SELECT 1 FROM TipoCanalDistribucion WHERE TipoCanalDistribucion = @pTipoCanalDistribucion)
        BEGIN
            SET @Mensaje = 'No se encontr� un registro con el TipoCanalDistribucion para eliminar.';
            SET @Resultado = 0;
            SELECT @Mensaje AS Mensaje, @Resultado AS Resultado;
            RETURN;
        END

        -- DELETE
        DELETE FROM TipoCanalDistribucion
        WHERE TipoCanalDistribucion = @pTipoCanalDistribucion;

        SET @Mensaje = 'Registro eliminado exitosamente.';
        SET @Resultado = 1;
        SELECT @Mensaje AS Mensaje, @Resultado AS Resultado;
    END
END;

