--Ejecutar por cambio de nombre
CREATE OR ALTER PROCEDURE paCrudUser(
    @accion                 INT,
    @pCriterioBusqueda      VARCHAR(100) = NULL,
	@pUserName              VARCHAR(30)  = NULL,
	@pEmpresa               INT		     = NULL,	
	@pEstacion_Trabajo		INT			 = NULL,
	@pApplication			INT			 = NULL,
    @pName					VARCHAR(200) = NULL,
    @pFecha_Hora            DATETIME     = NULL,
	@pCelular				varchar(50)	 = NULL,
	@pEMail					varchar(100) = NULL,
	@pPass					varchar(256) = NULL,
	@pDisable				bit			 = NULL
)
AS
BEGIN
    DECLARE @Mensaje VARCHAR(255);
    DECLARE @Resultado BIT;
	DECLARE @NuevoUserName SMALLINT;
	DECLARE  @Pass_Key VARBINARY(64);

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
				Celular,
				EMail,
				Pass_Key,
				[Disable],
				Empresa,
				[Estacion_Trabajo],
				[Application],
				Language_ID,
				Fecha_Hora,
				M_Fecha_Hora,
				M_UserName,
				Fecha_Ini,
				Fecha_Fin,
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
				Celular,
				EMail,
				Pass_Key,
				[Disable],
				Empresa,
				[Estacion_Trabajo],
				[Application],
				Language_ID,
				Fecha_Hora,
				M_Fecha_Hora,
				M_UserName,
				Fecha_Ini,
				Fecha_Fin,
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
        -- INSERT
		SET @Pass_Key = HASHBYTES('SHA2_512', @pPass);
        INSERT INTO tbl_User 
        (
            UserName,
            [Name],
			Celular,
			EMail,
			[Fecha_Usuario],
            [Fecha_Hora],
			Pass_Key,
			[Disable],
			Empresa,
			[Estacion_Trabajo],
			[Application],
			Language_ID,
			Fecha_Ini,
			Val_Nomenclatura_Contable,
			Pass_Key_Dias,
			Val_Serie_Documento,
			Ocultar_SAE,
			Val_Rol_Poliza,
			Permitir_CxC,
			Asignar_Rango_Fecha,
			Pass_Key_Len
        )
        VALUES 
        (
            @pName,
			@pName,
			@pCelular,
			@pEMail,
			GETDATE(),
            GETDATE(),
			@Pass_Key,
			0,
			@pEmpresa,
			@pEstacion_Trabajo,
			@pApplication,
			1,
			GETDATE(),
			0,
			0,
			0,
			0,
			0,
			1,
			1,
			0
        );

        SET @Mensaje = 'Registro insertado exitosamente.';
        SET @Resultado = 1;
        SELECT @Mensaje AS Mensaje, @Resultado AS Resultado;
    END
    ELSE IF @accion = 3
    BEGIN
        -- 3. Error al intentar actualizar un registro inexistente
        IF NOT EXISTS (SELECT 1 FROM tbl_User WHERE UserName = @pUserName)
        BEGIN
            SET @Mensaje   = 'No se encontró un registro con el UserName para actualizar.';
            SET @Resultado = 0;
            SELECT @Mensaje AS Mensaje, @Resultado AS Resultado;
            RETURN;
        END

		
		SET @Pass_Key = HASHBYTES('SHA2_512', @pPass);

        -- UPDATE
        UPDATE tbl_User
        SET 
            [Name]		 = @pName,
			Celular      = @pCelular,
			EMail        = @pEMail,
			M_Fecha_Hora = GETDATE(),
			M_UserName	 = @pUserName,
			[Disable]	 = @pDisable,
			Fecha_Fin    = CASE WHEN @pDisable = 1 THEN GETDATE() ELSE Fecha_Fin END,
			Pass_Key	 = @Pass_Key
		
        WHERE 
            UserName = @pUserName;

        SET @Mensaje = 'Registro actualizado exitosamente.';
        SET @Resultado = 1;
        SELECT @Mensaje AS Mensaje, @Resultado AS Resultado;
    END
    ELSE IF @accion = 4
    BEGIN
		-- Verificar si el registro está relacionado con la tabla CanalDistribucion
		IF EXISTS (SELECT 1 FROM tbl_User_Elemento_Asignado WHERE UserName = @pUserName)
		BEGIN
			SET @Mensaje   = 'No se puede eliminar el registro porque tiene asociados otros registros.';
			SET @Resultado = 0;
			SELECT @Mensaje AS Mensaje, @Resultado AS Resultado;
			RETURN;
		END
        -- 4. Error al intentar eliminar un registro inexistente
        IF NOT EXISTS (SELECT 1 FROM tbl_User WHERE UserName = @pUserName)
        BEGIN
            SET @Mensaje = 'No se encontró un registro con el UserName para eliminar.';
            SET @Resultado = 0;
            SELECT @Mensaje AS Mensaje, @Resultado AS Resultado;
            RETURN;
        END

        -- DELETE
        DELETE FROM tbl_User
        WHERE UserName = @pUserName;

        SET @Mensaje = 'Registro eliminado exitosamente.';
        SET @Resultado = 1;
        SELECT @Mensaje AS Mensaje, @Resultado AS Resultado;
    END
END;

