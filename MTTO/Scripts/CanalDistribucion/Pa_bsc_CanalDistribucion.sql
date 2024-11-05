CREATE OR ALTER PROCEDURE Pa_bsc_CanalDistribucion(
    @accion                 INT,
    @pCriterioBusqueda      VARCHAR(100) = NULL,
    @pTipoCanalDistribucion SMALLINT     = NULL,
    @pBodega                SMALLINT     = NULL,
    @pDescripcion           VARCHAR(200) = NULL,
    @pEstado                TINYINT      = NULL,
    @pFecha_Hora            DATETIME     = NULL,
    @pUserName              VARCHAR(30)  = NULL
)
AS
BEGIN
    DECLARE @Mensaje VARCHAR(255);
    DECLARE @Resultado BIT;
	DECLARE @NuevoCanalDistribucion SMALLINT;

    -- 1. Verificaci�n de par�metros obligatorios
    IF @pBodega IS NULL AND @accion IN (3, 4)
    BEGIN
        SET @Mensaje = 'El par�metro @pBodega es obligatorio para las acciones de actualizaci�n y eliminaci�n.';
        SET @Resultado = 0;
        SELECT @Mensaje AS Mensaje, @Resultado AS Resultado;
        RETURN;
    END

    IF @accion = 1
	BEGIN
		IF @pCriterioBusqueda IS NULL
		BEGIN
			-- Si no se proporciona criterio de b�squeda, selecciona todos los registros
			SELECT 
				[TipoCanalDistribucion],
				[Bodega],
				[Descripcion],
				[Estado],
				[Fecha_Hora],
				[UserName],
				@Mensaje AS Mensaje,
				1 AS Resultado -- Operaci�n exitosa
			FROM CanalDistribucion;
		END
		ELSE 
		BEGIN
			-- Verificaci�n de b�squeda en la tabla CanalDistribucion por descripci�n
			IF EXISTS (
				SELECT 1 
				FROM CanalDistribucion 
				WHERE Descripcion LIKE '%' + @pCriterioBusqueda + '%'
			)
			BEGIN
				-- Selecci�n de registros que coincidan con el criterio en la tabla CanalDistribucion
				SELECT 
					[TipoCanalDistribucion],
					[Bodega],
					[Descripcion],
					[Estado],
					[Fecha_Hora],
					[UserName],
					@Mensaje AS Mensaje,
					1 AS Resultado -- Operaci�n exitosa
				FROM CanalDistribucion
				WHERE Descripcion LIKE '%' + @pCriterioBusqueda + '%';
			END
			ELSE IF EXISTS (
				-- Verificaci�n de b�squeda en TipoCanalDistribucion
				SELECT 1 
				FROM CanalDistribucion cd 
				INNER JOIN TipoCanalDistribucion tcd ON cd.TipoCanalDistribucion = tcd.TipoCanalDistribucion 
				WHERE tcd.Descripcion LIKE '%' + @pCriterioBusqueda + '%'
			)
			BEGIN
				-- Selecci�n de registros relacionados con TipoCanalDistribucion
				SELECT 
					cd.[TipoCanalDistribucion],
					cd.[Bodega],
					cd.[Descripcion],
					cd.[Estado],
					cd.[Fecha_Hora],
					cd.[UserName],
					@Mensaje AS Mensaje,
					1 AS Resultado -- Operaci�n exitosa
				FROM CanalDistribucion cd 
				INNER JOIN TipoCanalDistribucion tcd ON cd.TipoCanalDistribucion = tcd.TipoCanalDistribucion
				WHERE tcd.Descripcion LIKE '%' + @pCriterioBusqueda + '%';
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
        SELECT @NuevoCanalDistribucion = ISNULL(MAX(Bodega), 0) + 1 FROM CanalDistribucion;

        -- INSERT
        INSERT INTO CanalDistribucion 
        (
            [TipoCanalDistribucion],
            [Bodega],
            [Descripcion],
            [Estado],
            [Fecha_Hora],
            [UserName]
        )
        VALUES 
        (
            @pTipoCanalDistribucion,
            @NuevoCanalDistribucion,
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
        IF NOT EXISTS (SELECT 1 FROM CanalDistribucion WHERE Bodega = @pBodega)
        BEGIN
            SET @Mensaje = 'No se encontr� un registro con el Bodega para actualizar.';
            SET @Resultado = 0;
            SELECT @Mensaje AS Mensaje, @Resultado AS Resultado;
            RETURN;
        END

        -- UPDATE
        UPDATE CanalDistribucion
        SET 
            Descripcion = @pDescripcion,
            Estado = @pEstado,
			M_Fecha_Hora = GETDATE(),
			M_UserName = @pUserName
        WHERE 
            Bodega = @pBodega;

        SET @Mensaje = 'Registro actualizado exitosamente.';
        SET @Resultado = 1;
        SELECT @Mensaje AS Mensaje, @Resultado AS Resultado;
    END
    ELSE IF @accion = 4
    BEGIN
        -- 4. Error al intentar eliminar un registro inexistente
        IF NOT EXISTS (SELECT 1 FROM CanalDistribucion WHERE Bodega = @pBodega)
        BEGIN
            SET @Mensaje = 'No se encontr� un registro con el Bodega para eliminar.';
            SET @Resultado = 0;
            SELECT @Mensaje AS Mensaje, @Resultado AS Resultado;
            RETURN;
        END

        -- DELETE
        DELETE FROM CanalDistribucion
        WHERE Bodega = @pBodega;

        SET @Mensaje = 'Registro eliminado exitosamente.';
        SET @Resultado = 1;
        SELECT @Mensaje AS Mensaje, @Resultado AS Resultado;
    END
END;
