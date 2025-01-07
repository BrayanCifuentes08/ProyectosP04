CREATE TABLE CargasAjustesYSuspensiones (
    nitEmpleado VARCHAR(50),
    ajusteSuspension DECIMAL
);

INSERT INTO CargasAjustesYSuspensiones (nitEmpleado, ajusteSuspension)
VALUES 
    ('1234567890', 305.02),
    ('9876543210', 305.02),
    ('1122334455', 805.02);


select * from CargasAjustesYSuspensiones