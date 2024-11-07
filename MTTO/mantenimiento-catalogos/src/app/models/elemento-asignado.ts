export interface ElementoAsignado {
  elementoAsignado:      number;
  descripcion:           string;
  elementoId:            number;
  empresa:               number;
  elementoAsignadoPadre: string;
  estado:                number;
  fechaHora:             Date;
  userName:              string;
  mensaje:               string;
  resultado:             boolean;
}


export interface InputEstadoElementoAsignado {
  [key: string]: boolean; // La clave es el nombre del input y el valor es true si está bloqueado, false si está editable
}
export interface TiposCampo {
  [key: string]: string; // La clave es el nombre del campo y el valor es el tipo de campo
}
//Model para bloquear inputs para elementoAsignado
export const estadoInputsElementoAsignadoInsert: InputEstadoElementoAsignado = {
  "Elemento Asignado": true, // Bloqueado
  "Descripción": false, // Editables
  "Elemento Id": true, // Bloqueado
  "Empresa": true, // Bloqueado
  "Elemento Asignado Padre": false, // Editables
  "Estado": true, // Bloqueado
  "Fecha y Hora": true, // Bloqueado
  "UserName": true, // Bloqueado
};

export const estadoInputsElementoAsignadoUpdate: InputEstadoElementoAsignado = {
  "Elemento Asignado": true, // Bloqueado
  "Descripción": false, // Editables
  "Elemento Id": true, // Bloqueado
  "Empresa": true, // Bloqueado
  "Elemento Asignado Padre": true, // Bloqueado
  "Estado": false, // Editable
  "Fecha y Hora": true, // Bloqueado
  "UserName": true, // Bloqueado
};

// Model para tipos de campo para elementoAsignado
export const tiposCampoElementoAsignado: TiposCampo = {
  "Elemento Asignado": "number", // tipo int
  "Descripción": "text", //  Campo de texto
  "Elemento Id": "text", // Campo de texto
  "Empresa": "number", // tipo int
  "Elemento Asignado Padre": "dropdown", // tipo dropdown
  "Estado": "switch", // tipo switch
  "Fecha y Hora": "Date", // Campo de fecha
  "UserName": "text", // Campo de texto
};