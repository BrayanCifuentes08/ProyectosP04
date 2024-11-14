export interface PaBscUserDisplay2M {
    user_Display: number;
    user_Display_Father: number;
    userName: string;
    name: string;
    active: boolean;
    visible: boolean;
    rol: boolean;
    display: string;
    application: number;
    param: number;
    orden: boolean;
    consecutivoInterno: number;
    displayURL: string;
    diplayMenu: string;
    display_URL_Alter?: string | null;
    languageID: boolean;
    tipoDocumento?: number | null;
    desTipoDocumento?: string | null; 
}

export interface ParametrosUserDisplay{
    UserName: string;
    Application: number;
}