CREATE TABLE CargaLiquidacionFinDeLabores (
    nitEmpleado VARCHAR(50),
    rentaPatronoActual DECIMAL(18, 2),
    bonoAnualDeTrabajadores14 DECIMAL(18, 2),
    aguinaldo DECIMAL(18, 2),
    nitOtroPatrono1 VARCHAR(50),
    rentaOtroPatrono1 DECIMAL(18, 2),
    retencionOtroPatrono1 DECIMAL(18, 2),
    nitOtroPatrono2 VARCHAR(50),
    rentaOtroPatrono2 DECIMAL(18, 2),
    retencionOtroPatrono2 DECIMAL(18, 2),
    nitOtroPatrono3 VARCHAR(50),
    rentaOtroPatrono3 DECIMAL(18, 2),
    retencionOtroPatrono3 DECIMAL(18, 2),
    nitOtroPatrono4 VARCHAR(50),
    rentaOtroPatrono4 DECIMAL(18, 2),
    retencionOtroPatrono4 DECIMAL(18, 2),
    nitOtroPatrono5 VARCHAR(50),
    rentaOtroPatrono5 DECIMAL(18, 2),
    retencionOtroPatrono5 DECIMAL(18, 2),
    nitExPatrono1 VARCHAR(50),
    rentaExPatrono1 DECIMAL(18, 2),
    retencionExPatrono1 DECIMAL(18, 2),
    nitExPatrono2 VARCHAR(50),
    rentaExPatrono2 DECIMAL(18, 2),
    retencionExPatrono2 DECIMAL(18, 2),
    nitExPatrono3 VARCHAR(50),
    rentaExPatrono3 DECIMAL(18, 2),
    retencionExPatrono3 DECIMAL(18, 2),
    nitExPatrono4 VARCHAR(50),
    rentaExPatrono4 DECIMAL(18, 2),
    retencionExPatrono4 DECIMAL(18, 2),
    nitExPatrono5 VARCHAR(50),
    rentaExPatrono5 DECIMAL(18, 2),
    retencionExPatrono5 DECIMAL(18, 2),
    otrosIngresosGravadosYExentosObtenidosEnElPeriodo DECIMAL(18, 2),
    indemnizacionesOPensionesPorCausaDeMuerte DECIMAL(18, 2),
    indemnizacionesPorTiempoServido DECIMAL(18, 2),
    remuneracionesDeLosDiplomaticos DECIMAL(18, 2),
    gastosDeRepresentacionYViaticosComprobables DECIMAL(18, 2),
    cuotasIgssYOtrosPlanesDeSeguridadSocial DECIMAL(18, 2),
    fechaDeFinDeLabores DATE,
    ultimaRetencion DECIMAL(18, 2)
);



INSERT INTO CargaLiquidacionFinDeLabores (
    nitEmpleado, rentaPatronoActual, bonoAnualDeTrabajadores14, aguinaldo, 
    nitOtroPatrono1, rentaOtroPatrono1, retencionOtroPatrono1, 
    nitOtroPatrono2, rentaOtroPatrono2, retencionOtroPatrono2, 
    nitOtroPatrono3, rentaOtroPatrono3, retencionOtroPatrono3, 
    nitOtroPatrono4, rentaOtroPatrono4, retencionOtroPatrono4, 
    nitOtroPatrono5, rentaOtroPatrono5, retencionOtroPatrono5, 
    nitExPatrono1, rentaExPatrono1, retencionExPatrono1, 
    nitExPatrono2, rentaExPatrono2, retencionExPatrono2, 
    nitExPatrono3, rentaExPatrono3, retencionExPatrono3, 
    nitExPatrono4, rentaExPatrono4, retencionExPatrono4, 
    nitExPatrono5, rentaExPatrono5, retencionExPatrono5, 
    otrosIngresosGravadosYExentosObtenidosEnElPeriodo, indemnizacionesOPensionesPorCausaDeMuerte, 
    indemnizacionesPorTiempoServido, remuneracionesDeLosDiplomaticos, 
    gastosDeRepresentacionYViaticosComprobables, cuotasIgssYOtrosPlanesDeSeguridadSocial, 
    fechaDeFinDeLabores, ultimaRetencion
)
VALUES (
    '1234567890', 35000.00, 5000.00, 1500.00, 
    '9876543210', 20000.00, 1500.00, 
    '1122334455', 18000.00, 1400.00, 
    '2233445566', 16000.00, 1200.00, 
    '3344556677', 14000.00, 1000.00, 
    '4455667788', 12000.00, 900.00, 
    '5566778899', 10000.00, 800.00, 
    '6677889900', 8000.00, 600.00, 
    '7788990011', 7000.00, 500.00, 
    '8899001122', 6000.00, 400.00, 
    '9900112233', 5000.00, 300.00, 
    4500.00, 1000.00, 500.00, 2000.00, 
    1500.00, 1000.00, 
    '01-01-2025', 1300.00
);

select * from CargaLiquidacionFinDeLabores