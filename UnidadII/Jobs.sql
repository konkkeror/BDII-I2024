
CREATE TABLE DEPARTMENTS AS
SELECT * FROM HR.DEPARTMENTS;


--EXTRACT TRANSFORM LOAD
    --DESNORMALIZAR
    --EVITAR LLAVES FORANEAS DENTRO LO POSIBLE



SELECT * FROM DEPARTMENTS;
--LIMPIAR LA INFORMACION
--EXTRAER E INSERTAR LA INFORMACIÓN DE LA TABLA ORIGEN A LA DESTINO

--EXTRACCIONES VOLATILES
CREATE OR REPLACE PROCEDURE P_ETL_DEPARMENTS AS
    V_FECHA_HORA_INICIO DATE := SYSDATE;
BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE DEPARTMENTS';

    INSERT INTO departments (
        department_id,
        department_name,
        manager_id,
        location_id
    ) SELECT 
        department_id,
        department_name,
        manager_id,
        location_id
    FROM HR.DEPARTMENTS;
    
    COMMIT;
    
    --GUARDAR LOG EXITOSO
    INSERT INTO ETL_LOG(
        ID_LOG,
        NOMBRE_ETL,
        FECHA_HORA_INICIO,
        FECHA_HORA_FIN,
        ESTATUS,
        ERROR
    ) VALUES (
        SQ_ETL_LOG.NEXTVAL,
        $$PLSQL_UNIT,
        V_FECHA_HORA_INICIO,
        SYSDATE,
        'S',
        NULL
    );
    
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
    ROLLBACK;
    --GUARDAR LOG FALLIDO
    INSERT INTO ETL_LOG(
        ID_LOG,
        NOMBRE_ETL,
        FECHA_HORA_INICIO,
        FECHA_HORA_FIN,
        ESTATUS,
        ERROR
    ) VALUES (
        SQ_ETL_LOG.NEXTVAL,
        $$PLSQL_UNIT,
        V_FECHA_HORA_INICIO,
        SYSDATE,
        'F',
        SQLCODE || ' - ' || SQLERRM
    );
    
    COMMIT;
END;

begin
    P_ETL_DEPARMENTS;
end;

select * from DEPARTMENTS;



CREATE TABLE ETL_LOG(
    ID_LOG NUMBER,
    NOMBRE_ETL VARCHAR2(3000),
    FECHA_HORA_INICIO DATE,
    FECHA_HORA_FIN DATE,
    ESTATUS VARCHAR2(1),
    ERROR VARCHAR2(3000)
);


CREATE SEQUENCE SQ_ETL_LOG;


SELECT * FROM ETL_LOG;

select SQ_ETL_LOG.currval from dual;




CREATE OR REPLACE PROCEDURE P_ETL_LOG (
    P_NOMBRE_ETL VARCHAR2,
    P_FECHA_HORA_INICIO DATE,
    P_ESTATUS VARCHAR2,
    P_ERROR VARCHAR2
) AS
BEGIN
    INSERT INTO ETL_LOG(
        ID_LOG,
        NOMBRE_ETL,
        FECHA_HORA_INICIO,
        FECHA_HORA_FIN,
        ESTATUS,
        ERROR
    ) VALUES (
        SQ_ETL_LOG.NEXTVAL,
        P_NOMBRE_ETL,
        P_FECHA_HORA_INICIO,
        SYSDATE,
        P_ESTATUS,
        P_ERROR
    );
    COMMIT;
END;

BEGIN 
    P_ETL_LOG(
        P_NOMBRE_ETL => 'PRUEBA',
        P_FECHA_HORA_INICIO => SYSDATE,
        P_ESTATUS => 'F',
        P_ERROR => 'ESTE ES EL ERROR'
    );
END;


BEGIN
    P_ETL_DEPARMENTS;
END;


SELECT * FROM ETL_LOG;


begin
    dbms_scheduler.create_job (
        job_name => 'JOB_ETL_DEPARTMENTS',
        job_type => 'PLSQL_BLOCK',
        job_action => 'begin P_ETL_DEPARMENTS; end;',
        number_of_arguments => 0,
        start_date => sysdate + 1/24/59, -- sysdate + 10 minutos
        job_class => 'DEFAULT_JOB_CLASS', -- Priority Group
        enabled => TRUE,
        auto_drop => TRUE,
        comments => 'JOB de EXTRACCIÓN DE DEPARTAMENTOS'
    );
end;

SELECT * FROM ALL_JOBS;

SELECT TO_CHAR(sysdate + 1/24/59, 'DD/MM/YYYY HH24:MI:SS') FROM DUAL;
