export interface DeleteUserElementoAsignadoM {
    UserName: string,
    Elemento_Asignado: number,
    mensaje: string,
    resultado: boolean
}

export interface DeleteUserElementoAsignadoParams {
    pUserName: string,
    pElemento_Asignado: number
}
