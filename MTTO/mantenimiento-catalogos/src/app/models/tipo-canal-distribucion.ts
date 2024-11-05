export interface tipoCanalDistribucion {
    tipoCanalDistribucion: number,
    descripcion: string,
    estado: boolean,
    fecha_hora: Date,
    userName: string,
    mensaje: string,
    resultado: boolean,
}

export interface ParamsTipoCanalDistribucion {
    accion: number,
    pDescripcion: string,
    pCriterioBusqueda: string
    pTipoCanalDistribucion: number,
    pEstado: number,
    pFecha_Hora: Date,
    pUserName: string
}

export interface InputEstadoTipoCanal {
    [key: string]: boolean; // La clave es el nombre del input y el valor es true si está bloqueado, false si está editable
}
export interface TiposCampo {
    [key: string]: string; // La clave es el nombre del campo y el valor es el tipo de campo
}
//Model para bloquear inputs para tipoCanalDistribucion
export const estadoInputsTipoCanalDistribucionInsert: InputEstadoTipoCanal = {
    "tipoCanalDistribucion": false, // Editable
    "descripcion": false, // Editable
    "estado": true, // Bloqueado
    "fecha_Hora": true, // Bloqueado
    "userName": true // Bloqueado
};

export const estadoInputsTipoCanalDistribucionUpdate: InputEstadoTipoCanal = {
    "tipoCanalDistribucion": true, // Bloqueado
    "descripcion": false, // Editable
    "estado": false, // Editable
    "fecha_Hora": true, // Bloqueado
    "userName": true // Bloqueado
};

// Model para tipos de campo para tipoCanalDistribucion
export const tiposCampoTipoCanalDistribucion: TiposCampo = {
    "tipoCanalDistribucion": "int", // Definido como entero
    "descripcion": "text", // Campo de texto
    "estado": "int", // Campo entero
    "fecha_Hora": "date", // Campo de fecha
    "userName": "text", // Campo de texto
};