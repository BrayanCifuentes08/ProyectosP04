CREATE OR ALTER PROCEDURE Pa_bsc_Elementos_No_Asignados
AS
BEGIN
	SELECT 
		ea.Elemento_Asignado, 
		ea.Descripcion
	FROM 
		[dbo].[tbl_Elemento_Asignado] ea
	LEFT JOIN 
		[dbo].[tbl_User_Elemento_Asignado] uea 
		ON ea.Elemento_Asignado = uea.Elemento_Asignado 
	WHERE 
		uea.Elemento_Asignado IS NULL;
END