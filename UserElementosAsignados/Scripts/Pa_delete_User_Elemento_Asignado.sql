CREATE OR ALTER PROCEDURE Pa_delete_User_Elemento_Asignado(
    @pUserName VARCHAR(30)
	,@pElemento_Asignado INT
)
AS
BEGIN
    DELETE 
		FROM [dbo].[tbl_User_Elemento_Asignado]
    WHERE 
		UserName		  = @pUserName 
		AND 
		Elemento_Asignado = @pElemento_Asignado;
END
