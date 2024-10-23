import { Injectable } from '@angular/core';
import { ReCaptchaV3Service } from 'ng-recaptcha'; 

@Injectable({
  providedIn: 'root'
})
export class RecaptchaService {

constructor(private recaptchaV3Service: ReCaptchaV3Service) { }

  ejecutarRecaptcha(action: string): Promise<string> {
    return new Promise((resolve, reject) => {
      this.recaptchaV3Service.execute(action).subscribe(
        (token: string) => {
          resolve(token);
        },
        (error) => {
          console.error('Error al ejecutar reCAPTCHA', error);
          reject(error);
        }
      );
    });
  }
}
