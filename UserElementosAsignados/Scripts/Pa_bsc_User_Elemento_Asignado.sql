CREATE or ALTER PROCEDURE Pa_bsc_User_Elemento_Asignado(
	@pUserName VARCHAR(30) 
) 
AS
BEGIN
SELECT 
	uea.UserName 
	,uea.Elemento_Asignado
	,ea.Descripcion
	,uea.Fecha_Hora 
		FROM 
			[dbo].[tbl_User_Elemento_Asignado]  uea
		inner join 
			[dbo].[tbl_Elemento_Asignado] ea ON ea.Elemento_Asignado = uea.Elemento_Asignado 
		WHERE @pUserName = uea.UserName 
END
