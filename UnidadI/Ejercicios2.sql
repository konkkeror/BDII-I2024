
/*Cree un procedimiento almacenado llamado update_employee_department 
que actualice el departamento de un empleado. 
El procedimiento debe tomar tres parámetros: 
el ID del empleado, el ID del nuevo departamento y el ID del nuevo administrador 
del empleado.

Antes de actualizar, el procedimiento debe verificar si el nuevo 
ID de departamento y el ID de administrador existen en la tabla de 
departamentos y en la tabla de empleados, respectivamente. 

Si el departamento o el gerente no existe, el procedimiento debería 
generar una excepción personalizada denominada Invalid_Department_or_Manager.

Si el departamento y el gerente existen, el procedimiento debe 
actualizar el departamento y el gerente del empleado en consecuencia.
*/



CREATE OR REPLACE PROCEDURE p_update_employee_department (
    P_EMPLOYEE_ID EMPLOYEES.EMPLOYEE_ID%TYPE,
    P_DEPARMENT_ID DEPARTMENTS.DEPARTMENT_ID%TYPE,
    P_MANAGER_ID EMPLOYEES.EMPLOYEE_ID%TYPE
) AS
    V_Invalid_Department_or_Manager EXCEPTION;
    V_CANTIDAD_DEPARTAMENTOS NUMBER;
    V_CANTIDAD_EMPLEADOS NUMBER;
    
BEGIN
    SELECT COUNT(1) 
    INTO V_CANTIDAD_DEPARTAMENTOS
    FROM DEPARTMENTS
    WHERE DEPARTMENT_ID  = P_DEPARMENT_ID;
    
    SELECT COUNT(1) 
    INTO V_CANTIDAD_EMPLEADOS
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID  = P_MANAGER_ID;
    
    IF (V_CANTIDAD_DEPARTAMENTOS <= 0 OR V_CANTIDAD_EMPLEADOS <= 0) THEN
        RAISE V_Invalid_Department_or_Manager;
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('EL PROGRAMA CONTINUA PORQUE SI EXISTEN..');
    
    UPDATE EMPLOYEES
    SET DEPARTMENT_ID = P_DEPARMENT_ID,
    MANAGER_ID = P_MANAGER_ID
    WHERE EMPLOYEE_ID = P_EMPLOYEE_ID;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('SE ACTUALIZÓ EL EMPLEADO');
    
EXCEPTION
    WHEN V_Invalid_Department_or_Manager THEN
        DBMS_OUTPUT.PUT_LINE('NO EXISTE EL DEPARTAMENTO O EL MANAGER');
        ROLLBACK;
END;

SELECT * FROM EMPLOYEES;


BEGIN
    p_update_employee_department(
        P_DEPARMENT_ID => 50, 
        P_MANAGER_ID => 123,
        P_EMPLOYEE_ID => 206
    );
END;

SELECT COUNT(1) FROM DEPARTMENTS
WHERE DEPARTMENT_ID  = 3453534;


SELECT * FROM EMPLOYEES;

205 => 123
110 => 50