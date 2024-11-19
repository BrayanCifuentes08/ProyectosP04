export interface User {
    userName:         string;
    name:             string;
    celular:          string;
    eMail:            string;
    fecha_Hora:       string;
    pass_Key:         Uint8Array;
    disable:          boolean;
    empresa:          number;
    estacion_Trabajo: number;
    application:      number;
    language_Id:      number;
    mensaje:          string;
    resultado:        boolean;
}

  export interface InputEstadoUser {
    [key: string]: boolean; // La clave es el nombre del input y el valor es true si está bloqueado, false si está editable
  }
  export interface TiposCampo {
    [key: string]: string; // La clave es el nombre del campo y el valor es el tipo de campo
  }
  //Model para bloquear inputs para elementoAsignado
  export const estadoInputsUserInsert: InputEstadoUser = {
    "userName": true, // Bloqueado
    'name': false, // Editables
    "celular": false, // Editables
    "eMail": false, // Editables
    "fecha_Hora": true, // Bloqueado
  };
  
  export const estadoInputsUserUpdate: InputEstadoUser = {
    "userName": true, //Bloqueado
    'name': false, //Editables
    "celular": false, //Editables
    "eMail": false, //Editables
    "fecha_Hora": true, // Bloqueado
  };