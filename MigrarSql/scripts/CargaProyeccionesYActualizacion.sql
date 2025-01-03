CREATE TABLE CargaProyeccionesYActualizacion (
    nitEmpleadoSinGuion VARCHAR(50),
    nombreDelEmpleado VARCHAR(100),
    fechaDeAltaInicioDeLabores DATE,
    rentaPatronoActualRentaPercibidaConElAgenteRetenedor DECIMAL(18, 2),
    bonoAnualDeTrabajadores14RentaPercibidaConElAgenteRetenedor DECIMAL(18, 2),
    aguinaldoRentaPercibidaConElAgenteRetenedor DECIMAL(18, 2),
    nitOtroPatrono1SinGuion VARCHAR(50),
    rentaOtroPatrono1 DECIMAL(18, 2),
    retencionOtroPatrono1 DECIMAL(18, 2),
    nitOtroPatrono2SinGuion VARCHAR(50),
    rentaOtroPatrono2 DECIMAL(18, 2),
    retencionOtroPatrono2 DECIMAL(18, 2),
    nitOtroPatrono3SinGuion VARCHAR(50),
    rentaOtroPatrono3 DECIMAL(18, 2),
    retencionOtroPatrono3 DECIMAL(18, 2),
    nitOtroPatrono4SinGuion VARCHAR(50),
    rentaOtroPatrono4 DECIMAL(18, 2),
    retencionOtroPatrono4 DECIMAL(18, 2),
    nitOtroPatrono5SinGuion VARCHAR(50),
    rentaOtroPatrono5 DECIMAL(18, 2),
    retencionOtroPatrono5 DECIMAL(18, 2),
    nitExPatrono1SinGuion VARCHAR(50),
    rentaExPatrono1 DECIMAL(18, 2),
    retencionExPatrono1 DECIMAL(18, 2),
    nitExPatrono2SinGuion VARCHAR(50),
    rentaExPatrono2 DECIMAL(18, 2),
    retencionExPatrono2 DECIMAL(18, 2),
    nitExPatrono3SinGuion VARCHAR(50),
    rentaExPatrono3 DECIMAL(18, 2),
    retencionExPatrono3 DECIMAL(18, 2),
    nitExPatrono4SinGuion VARCHAR(50),
    rentaExPatrono4 DECIMAL(18, 2),
    retencionExPatrono4 DECIMAL(18, 2),
    nitExPatrono5SinGuion VARCHAR(50),
    rentaExPatrono5 DECIMAL(18, 2),
    retencionExPatrono5 DECIMAL(18, 2),
    otrosIngresosGravados DECIMAL(18, 2),
    aguinaldoRentaExentasConElAgenteRetenedo DECIMAL(18, 2),
    bonoAnualDeTrabajadores14RentaExentasConElAgenteRetenedor DECIMAL(18, 2),
    cuotasIgssYOtrosPlanesDeSeguridadSocial DECIMAL(18, 2),
    fechaDeActualizacionDeRenta DATE
);



INSERT INTO CargaProyeccionesYActualizacion (
    nitEmpleadoSinGuion, nombreDelEmpleado, fechaDeAltaInicioDeLabores, rentaPatronoActualRentaPercibidaConElAgenteRetenedor,
    bonoAnualDeTrabajadores14RentaPercibidaConElAgenteRetenedor, aguinaldoRentaPercibidaConElAgenteRetenedor, nitOtroPatrono1SinGuion, rentaOtroPatrono1,
    retencionOtroPatrono1, nitOtroPatrono2SinGuion, rentaOtroPatrono2, retencionOtroPatrono2,
    nitOtroPatrono3SinGuion, rentaOtroPatrono3, retencionOtroPatrono3, nitOtroPatrono4SinGuion,
    rentaOtroPatrono4, retencionOtroPatrono4, nitOtroPatrono5SinGuion, rentaOtroPatrono5,
    retencionOtroPatrono5, nitExPatrono1SinGuion, rentaExPatrono1, retencionExPatrono1,
    nitExPatrono2SinGuion, rentaExPatrono2, retencionExPatrono2, nitExPatrono3SinGuion,
    rentaExPatrono3, retencionExPatrono3, nitExPatrono4SinGuion, rentaExPatrono4,
    retencionExPatrono4, nitExPatrono5SinGuion, rentaExPatrono5, retencionExPatrono5,
    otrosIngresosGravados, aguinaldoRentaExentasConElAgenteRetenedo, bonoAnualDeTrabajadores14RentaExentasConElAgenteRetenedor,
    cuotasIgssYOtrosPlanesDeSeguridadSocial, fechaDeActualizacionDeRenta
)
VALUES (
    '1234567890', 'Juan Pérez', '01-01-2025', 35000.00,
    5000.00, 1500.00, '9876543210', 20000.00,
    1500.00, '1122334455', 18000.00, 1400.00,
    '2233445566', 16000.00, 1200.00, '3344556677',
    14000.00, 1000.00, '4455667788', 12000.00,
    900.00, '5566778899', 10000.00, 800.00,
    '6677889900', 8000.00, 600.00, '7788990011',
    7000.00, 500.00, '8899001122', 6000.00,
    400.00, '9900112233', 5000.00, 300.00,
    4500.00, 1200.00, 4000.00, 1000.00, '01-01-2025'
);


select * from CargaProyeccionesYActualizacion