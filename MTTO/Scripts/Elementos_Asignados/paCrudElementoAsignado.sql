CREATE OR ALTER PROCEDURE paCrudElementoAsignado(
    @accion                 INT,
	@pCriterioBusqueda      VARCHAR(100) = NULL,
	@pElementoAsignado		INT          = NULL,	
	@pElementoId			VARCHAR(20)  = NULL,
	@pUserName              VARCHAR(30)  = NULL,
	@pEmpresa				TINYINT		 = NULL,
    @pDescripcion           VARCHAR(200) = NULL,
    @pEstado                TINYINT      = NULL,
    @pFecha_Hora            DATETIME     = NULL
)
AS
BEGIN
    DECLARE @Mensaje VARCHAR(255);
    DECLARE @Resultado BIT;
	DECLARE @NuevoElementoAsignado SMALLINT;

    -- 1. Verificación de parámetros obligatorios
    IF @pElementoAsignado IS NULL AND @accion IN (3, 4)
    BEGIN
        SET @Mensaje = 'El parámetro @pElementoAsignado es obligatorio para las acciones de actualización y eliminación.';
        SET @Resultado = 0;
        SELECT @Mensaje AS Mensaje, @Resultado AS Resultado;
        RETURN;
    END

    IF @accion = 1
    BEGIN
		IF @pCriterioBusqueda IS NULL
		BEGIN
            SELECT 
				Elemento_Asignado
				,[Descripcion]
				,[Elemento_Id]
				,[Empresa]
				,[Elemento_Asignado_Padre]
				,[Estado]
				,[Fecha_Hora]
				,[UserName]
				,[M_Fecha_Hora]
				,[M_UserName]
				,@Mensaje AS Mensaje
                ,1 AS Resultado -- Operación exitosa
            FROM tbl_Elemento_Asignado;
		END
		ELSE
		BEGIN
		IF EXISTS (
				SELECT 1 
				FROM tbl_Elemento_Asignado 
				WHERE [Descripcion] LIKE '%' + @pCriterioBusqueda + '%'
			)
		 BEGIN
		 SELECT 
               Elemento_Asignado
				,[Descripcion]
				,[Elemento_Id]
				,[Empresa]
				,[Elemento_Asignado_Padre]
				,[Estado]
				,[Fecha_Hora]
				,[UserName]
				,[M_Fecha_Hora]
				,[M_UserName]
                ,@Mensaje AS Mensaje,
                1 AS Resultado -- Operación exitosa
            FROM tbl_Elemento_Asignado
			WHERE [Descripcion] LIKE '%' + @pCriterioBusqueda + '%'
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
        SELECT @NuevoElementoAsignado = ISNULL(MAX(Elemento_Asignado), 0) + 1 FROM tbl_Elemento_Asignado;

        -- INSERT
        INSERT INTO tbl_Elemento_Asignado 
        (
			Elemento_Asignado
			,[Descripcion]
			,[Elemento_Id]
			,[Empresa]
			,[Elemento_Asignado_Padre]
			,[Estado]
			,[Fecha_Hora]
			,[UserName]
        )
        VALUES 
        (
            @NuevoElementoAsignado
            ,@pDescripcion
			,@pElementoId
			,@pEmpresa
			,1
            ,1
            ,GETDATE()
            ,@pUserName
        );
        SET @Mensaje = 'Registro insertado exitosamente.';
        SET @Resultado = 1;
        SELECT @Mensaje AS Mensaje, @Resultado AS Resultado;
    END
    ELSE IF @accion = 3
    BEGIN
        -- 3. Error al intentar actualizar un registro inexistente
        IF NOT EXISTS (SELECT 1 FROM tbl_Elemento_Asignado WHERE Elemento_Asignado = @pElementoAsignado)
        BEGIN
            SET @Mensaje   = 'No se encontró un registro con el Elemento_Asignado para actualizar.';
            SET @Resultado = 0;
            SELECT @Mensaje AS Mensaje, @Resultado AS Resultado;
            RETURN;
        END

        -- UPDATE
        UPDATE tbl_Elemento_Asignado
        SET 
            Descripcion = @pDescripcion,
            Estado = @pEstado,
			M_Fecha_Hora = GETDATE(),
			M_UserName = @pUserName
        WHERE 
            Elemento_Asignado = @pElementoAsignado;

        SET @Mensaje = 'Registro actualizado exitosamente.';
        SET @Resultado = 1;
        SELECT @Mensaje AS Mensaje, @Resultado AS Resultado;
    END
    ELSE IF @accion = 4
    BEGIN
		-- Verificar si el registro está relacionado con la tabla tbl_User_Elemento_Asignado
		IF EXISTS (SELECT 1 FROM tbl_User_Elemento_Asignado WHERE Elemento_Asignado = @pElementoAsignado)
		BEGIN
			SET @Mensaje   = 'No se puede eliminar el registro porque tiene asociados otros registros.';
			SET @Resultado = 0;
			SELECT @Mensaje AS Mensaje, @Resultado AS Resultado;
			RETURN;
		END
        -- 4. Error al intentar eliminar un registro inexistente
        IF NOT EXISTS (SELECT 1 FROM tbl_Elemento_Asignado WHERE Elemento_Asignado = @pElementoAsignado)
        BEGIN
            SET @Mensaje = 'No se encontró un registro con el Elemento Asignado para eliminar.';
            SET @Resultado = 0;
            SELECT @Mensaje AS Mensaje, @Resultado AS Resultado;
            RETURN;
        END

        -- DELETE
        DELETE FROM tbl_Elemento_Asignado
        WHERE Elemento_Asignado = @pElementoAsignado;

        SET @Mensaje = 'Registro eliminado exitosamente.';
        SET @Resultado = 1;
        SELECT @Mensaje AS Mensaje, @Resultado AS Resultado;
    END
END;

