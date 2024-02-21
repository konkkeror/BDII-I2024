---GENERAR EL HTML NECESARIO PARA UNA TABLA DE EMPLEADOS
---QUE EL RESULTADO SEA UN PARAMETRO DE SALIDA.



CREATE OR REPLACE PROCEDURE P_GENERAR_HTML_EMPLEADOS (P_HTML OUT VARCHAR) AS
BEGIN
    P_HTML := '<table>';
    P_HTML := P_HTML || '<thead><tr><th>Nombre</th><th>Departamento</th><th>Puesto</th></tr></thead>';
    P_HTML := P_HTML || '<tbody>';
    
    -- CURSOR IMPLICITO:
    FOR V_EMPLEADO IN (
        SELECT A.FIRST_NAME || ' ' || LAST_NAME AS NAME,
            B.DEPARTMENT_NAME,
            C.JOB_TITLE
        FROM EMPLOYEES A
        LEFT JOIN DEPARTMENTS B
        ON (A.DEPARTMENT_ID = B.DEPARTMENT_ID)
        LEFT JOIN JOBS C
        ON (A.JOB_ID = C.JOB_ID)
    ) LOOP
        P_HTML :=   P_HTML || '<tr><td>' 
                    || V_EMPLEADO.NAME 
                    || '</td><td>'
                    || V_EMPLEADO.DEPARTMENT_NAME 
                    || '</td><td>'
                    || V_EMPLEADO.JOB_TITLE
                    || '</td></tr>';
    END LOOP;
    
    P_HTML := P_HTML || '</tbody>';
    P_HTML := P_HTML || '</table>';
END;



DECLARE 
    V_HTML VARCHAR2(32767);
BEGIN
    P_GENERAR_HTML_EMPLEADOS(V_HTML);
    DBMS_OUTPUT.PUT_LINE(V_HTML);
END;


SELECT A.FIRST_NAME || ' ' || LAST_NAME AS NAME,
    B.DEPARTMENT_NAME,
    C.JOB_TITLE
FROM EMPLOYEES A
LEFT JOIN DEPARTMENTS B
ON (A.DEPARTMENT_ID = B.DEPARTMENT_ID)
LEFT JOIN JOBS C
ON (A.JOB_ID = C.JOB_ID)