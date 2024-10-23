CREATE OR ALTER PROCEDURE Pa_insert_User_Elemento_Asignado (
    @pUserName VARCHAR(30)
	,@pElemento_Asignado INT
)
AS
BEGIN
    INSERT INTO [dbo].[tbl_User_Elemento_Asignado] (
        UserName, 
        Elemento_Asignado, 
        Fecha_Hora)
    VALUES 
        (@pUserName, 
         @pElemento_Asignado, 
         GETDATE());
END