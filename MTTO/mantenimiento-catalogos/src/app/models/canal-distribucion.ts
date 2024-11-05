export interface canalDistribucion{
    tipoCanalDistribucion: number
    bodega: number,
    descripcion: string,
    estado: number,
    fechaHora: Date,
    userName: string,
    mensaje: string,
    resultado: boolean,
}

export interface ParamsCanalDistribucion{
    accion: number
    pCriterioBusqueda: string,
    pBodega: number,
    pTipoCanalDistribucion: number,
    pDescripcion: string,
    pEstado: number,
    pFecha_Hora: Date,
}


export interface InputEstadoCanalDistribucion {
    [key: string]: boolean;
}
export interface TiposCampo {
    [key: string]: string; // La clave es el nombre del campo y el valor es el tipo de campo
}

//Model para bloquear inputs para canalDistribucion
export const estadoInputsCanalDistribucionInsert: InputEstadoCanalDistribucion = {
    "tipoCanalDistribucion": false , // Editable
    "bodega": true, // Bloqueado
    "descripcion": false, // Editable
    "estado": true, // Bloqueado
    "fecha_Hora": true, // Bloqueado
    "userName": true, // Bloqueado
};

export const estadoInputsCanalDistribucionUpdate: InputEstadoCanalDistribucion = {
    "tipoCanalDistribucion": true, // Bloqueado
    "bodega": true, // Bloqueado
    "descripcion": false, // Editable
    "estado": false, // Editable
    "fecha_Hora": true, // Bloqueado
    "userName": true, // Bloqueado
};

export const tiposCampoCanalDistribucion: TiposCampo = {
    "tipoCanalDistribucion": "int", // Definido como dropdown
    "bodega": "int", // Campo de tipo entero
    "descripcion": "text", // Campo de texto
    "estado": "int", // Puede ser un dropdown también
    "fecha_Hora": "date", // Campo de fecha
    "userName": "text", // Campo de texto
};
