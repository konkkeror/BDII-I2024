
--INSERTAR INFORMACIÓN EN TABLA ORIGEN
DECLARE
    v_fecha_inicio date := to_date('14/03/2024', 'DD/MM/YYYY');
    v_fecha_fin date := sysdate; --13
BEGIN

    WHILE V_FECHA_INICIO <= V_FECHA_FIN LOOP
        for i in 1 ..TRUNC(dbms_random.value(5,11)) loop
            INSERT INTO TBL_VENTAS (
                FECHA_VENTA,
                DESCRIPCION,
                MONTO
            ) 
            VALUES (
                V_FECHA_INICIO,
                dbms_random.string('A',15),
                ROUND(dbms_random.value(1,1000),2)
            );
        END LOOP;
        COMMIT;
        
        V_FECHA_INICIO := V_FECHA_INICIO + 1;
    END LOOP;
END;

--TABLA PARA CONSULTAR LOS JOBS CALENDARIZADOS
SELECT * FROM ALL_scheduler_jobs;


CREATE TABLE TBL_VENTAS (
    FECHA_VENTA DATE,
    DESCRIPCION VARCHAR2(500),
    MONTO NUMBER
);

SELECT * FROM TBL_VENTAS;

SELECT max(FECHA_VENTA) --INTO V_FECHA_INICIO 
FROM TBL_VENTAS;


--EXTRACCIÓN INCREMENTAL
CREATE OR REPLACE PROCEDURE P_ETL_VENTAS AS 
    V_FECHA_INICIO DATE;
    V_FECHA_FIN DATE := SYSDATE - 1;
    V_HORA_INICIO_PROCESO DATE := SYSDATE;
BEGIN

    DBMS_OUTPUT.PUT_LINE('CONSULTAR TABLA DESTINO');
    --fecha más reciente en la tabla de destino
    SELECT max(FECHA_VENTA) + 1 INTO V_FECHA_INICIO 
    FROM TBL_VENTAS;
   
    IF (V_FECHA_INICIO IS NULL) THEN
        DBMS_OUTPUT.PUT_LINE('CONSULTAR TABLA ORIGEN');
        --fecha más antigua en la tabla de origen
        SELECT MIN(FECHA_VENTA) INTO V_FECHA_INICIO 
        FROM HR.TBL_VENTAS;
    END IF;

    DBMS_OUTPUT.PUT_LINE('FECHA INICIO: ' ||V_FECHA_INICIO);
    DBMS_OUTPUT.PUT_LINE('FECHA FINNN: ' ||V_FECHA_FIN);
    
    WHILE V_FECHA_INICIO <= V_FECHA_FIN LOOP
        DELETE FROM TBL_VENTAS
        WHERE TRUNC(FECHA_VENTA) = TRUNC(V_FECHA_INICIO);
        INSERT INTO TBL_VENTAS (
                FECHA_VENTA,
                DESCRIPCION,
                MONTO
        ) 
        SELECT FECHA_VENTA,
                DESCRIPCION,
                MONTO
        FROM HR.TBL_VENTAS
        WHERE TRUNC(FECHA_VENTA) = TRUNC(V_FECHA_INICIO);
        DBMS_OUTPUT.PUT_LINE('SE EXTRAJO LA INNFORMACION PARA LA FECHA' ||V_FECHA_INICIO);
        COMMIT;
        V_FECHA_INICIO := V_FECHA_INICIO + 1;
    END LOOP;
    
    --GUARDAR LOG EXITOSO
    P_ETL_LOG(
        P_NOMBRE_ETL => $$PLSQL_UNIT,
        P_FECHA_HORA_INICIO => V_HORA_INICIO_PROCESO,
        P_ESTATUS => 'S',
        P_ERROR => ''
    );
EXCEPTION
    WHEN OTHERS THEN
        --GUARDAR LOG FALLIDO
        P_ETL_LOG(
            P_NOMBRE_ETL => $$PLSQL_UNIT,
            P_FECHA_HORA_INICIO => V_HORA_INICIO_PROCESO,
            P_ESTATUS => 'F',
            P_ERROR => SQLCODE || ' - ' || SQLERRM
        );
END;



BEGIN
    P_ETL_VENTAS;
END;

SET SERVEROUTPUT ON;

TRUNCATE TABLE TBL_VENTAS;


--VERIFICACION DE LA EXTRACCIÓN, COMPARACIÓN ORIGEN VS DESTINO
with origen as (
    SELECT trunc(fecha_venta) FECHA, COUNT(1) CANTIDAD, sum(monto) monto
    FROM HR.TBL_VENTAS
    group by trunc(fecha_venta)
),
destino AS (
    SELECT trunc(fecha_venta) FECHA, COUNT(1) CANTIDAD, sum(monto) monto
    FROM TBL_VENTAS
    group by trunc(fecha_venta)
)
SELECT * 
FROM (
    SELECT ORIGEN.FECHA, ORIGEN.CANTIDAD AS CANTIDAD_ORIGEN, DESTINO.CANTIDAD AS CANTIDAD_DESTINO,
            ORIGEN.CANTIDAD - DESTINO.CANTIDAD diferencia_cantidades,
            ORIGEN.monto - DESTINO.monto diferencia_montos
    FROM ORIGEN, DESTINO
    WHERE ORIGEN.FECHA = DESTINO.FECHA(+)
) 
WHERE diferencia_cantidades != 0
OR diferencia_montos != 0 
OR diferencia_cantidades is null
OR diferencia_montos is null;


SELECT * FROM ETL_LOG
WHERE NOMBRE_ETL = 'P_ETL_VENTAS';






