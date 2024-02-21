--
--Cree un procedimiento almacenado denominado calcular_salario_incremento 
--que calcule el aumento salarial de los empleados en función de su puesto de trabajo 
--y departamento. 
--El procedimiento debe tomar dos parámetros: el puesto de trabajo y el nombre del 
--departamento. 
--Luego debe calcular el salario promedio de los empleados con ese puesto de 
--trabajo en el departamento especificado.
--Si el salario promedio es superior a 5000, el procedimiento debe aumentar 
--el salario de todos los empleados con ese puesto en el departamento especificado 
--en un 10%. Si el salario medio está entre 3000 y 5000 (inclusive), 
--el procedimiento debería aumentar el salario en un 5%.
--Si el salario medio es inferior a 3000, el procedimiento debería aumentar 
--el salario en un 2%.



CREATE OR REPLACE PROCEDURE P_calcular_salario_incremento(
    P_PUESTO JOBS.JOB_TITLE%TYPE,
    P_DEPARTAMENTO DEPARTMENTS.DEPARTMENT_NAME%TYPE
) IS
    V_SALARIO_PROMEDIO NUMBER;
    V_PORCENTAJE NUMBER;
BEGIN
    SELECT AVG(A.SALARY) 
    INTO V_SALARIO_PROMEDIO
    FROM EMPLOYEES A
    LEFT JOIN JOBS B
    ON (A.JOB_ID = B.JOB_ID)
    LEFT JOIN DEPARTMENTS C
    ON (A.DEPARTMENT_ID = C.DEPARTMENT_ID)
    WHERE B.JOB_TITLE = P_PUESTO
    AND C.DEPARTMENT_NAME = P_DEPARTAMENTO;

    DBMS_OUTPUT.PUT_LINE('SALARIO PROMEDIO: ' || V_SALARIO_PROMEDIO);

    CASE 
        WHEN V_SALARIO_PROMEDIO > 5000 THEN
            V_PORCENTAJE := 0.1;
        WHEN V_SALARIO_PROMEDIO BETWEEN 3000 AND 5000 THEN
            V_PORCENTAJE := 0.05;
        WHEN V_SALARIO_PROMEDIO < 3000 THEN
            V_PORCENTAJE := 0.02;
        ELSE  
            V_PORCENTAJE := 0;
    END CASE;

    UPDATE EMPLOYEES 
    SET SALARY = SALARY + (SALARY * V_PORCENTAJE)
    WHERE JOB_ID = (SELECT JOB_ID FROM JOBS WHERE JOB_TITLE = P_PUESTO)
    AND DEPARTMENT_ID = (SELECT DEPARTMENT_ID FROM DEPARTMENTS WHERE DEPARTMENT_NAME = P_DEPARTAMENTO);
    
    DBMS_OUTPUT.PUT_LINE('EMPLEADOS ACTUALIZADOS CON EXITO');
    
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ALGO FALLÓ');
        ROLLBACK;
END;



SET SERVEROUTPUT ON;

BEGIN
    P_calcular_salario_incremento('Programmer', 'IT');
END;


CREATE TABLE EMPLOYEES_BACKUP AS 
SELECT * FROM EMPLOYEES;



select a.*, ((b.salary - a.salary )/ a.salary) * 100 as aumennto
from employees_backup a
inner join employees b
on (a.employee_id = b.employee_id);


SELECT * FROM HR.EMPLOYEES
WHERE;
SELECT * FROM HR.JOBS;
SELECT * FROM HR.DEPARTMENTS;


SELECT A.DEPARTMENT_ID, B.JOB_TITLE, AVG(A.SALARY) 
    --INTO V_SALARIO_PROMEDIO
    FROM EMPLOYEES A
    LEFT JOIN JOBS B
    ON (A.JOB_ID = B.JOB_ID)
    LEFT JOIN DEPARTMENTS C
    ON (A.DEPARTMENT_ID = C.DEPARTMENT_ID)
    WHERE B.JOB_TITLE = 'Programmer'
    AND C.DEPARTMENT_NAME = 'IT'
    GROUP BY A.DEPARTMENT_ID, B.JOB_TITLE;

    