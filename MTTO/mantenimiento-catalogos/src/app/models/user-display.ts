export interface PaBscUserDisplay2M {
    userDisplay:       number;
    userDisplayFather: number;
    userName:          string;
    name:              string;
    active:            boolean;
    visible:           boolean;
    rol:               boolean;
    display:           string;
    application:       number;
    param:             number;
    orden:             boolean;
    consecutivoInterno: number;
    displayURL:         string;
    diplayMenu:         string;
    display_URL_Alter?: string | null;
    languageID:         boolean;
    tipoDocumento?:     number | null;
    desTipoDocumento?:  string | null; 
}

export interface ParametrosUserDisplay{
    UserName:    string;
    Application: number;
}