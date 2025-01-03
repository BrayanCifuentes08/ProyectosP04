CREATE TABLE RetencionPorPago (
    nitEmpleado VARCHAR(50),
    baseGravadaOPagada DECIMAL(18, 2),
    retencionPorPago DECIMAL(18, 2),
    fechaDeRetencion DATE
);



INSERT INTO RetencionPorPago (nitEmpleado, baseGravadaOPagada, retencionPorPago, fechaDeRetencion)
VALUES ('1234567890', 50000.00, 1200.00, '03/01/2025');

select * from RetencionPorPago