
CREATE OR REPLACE TRIGGER TRG_INSERTAR_EMPLEADO 
BEFORE INSERT ON EMPLOYEES
FOR EACH ROW
DECLARE 
BEGIN
    :NEW.EMPLOYEE_ID := EMPLOYEES_SEQ.NEXTVAL;
    :NEW.FIRST_NAME := INITCAP(:NEW.FIRST_NAME); --Juan
EXCEPTION
WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR=====>> ' || SQLERRM);
END;


SET SERVEROUTPUT ON;

INSERT INTO employees (
    first_name,
    last_name,
    email,
    phone_number,
    hire_date,
    job_id,
    salary,
    commission_pct,
    manager_id,
    department_id,
    active_time,
    active
) VALUES (
    'JUAN',
    'PEREZ',
    'jperez@gmail.com',
    '590.423.4549',
    sysdate,
    'IT_PROG',
    999,
    0.5,
    100,
    20,
    NULL,
    'T'
);

select * from employees where first_name = 'JUAN';

SELECT * FROM DEPARTMENTS;



CREATE OR REPLACE TRIGGER TRG_CALCULATE_SENIORITY 
BEFORE UPDATE OF ACTIVE ON EMPLOYEES 
FOR EACH ROW 
WHEN (OLD.ACTIVE = 'T' AND NEW.ACTIVE = 'F')
DECLARE
BEGIN
    :NEW.ACTIVE_TIME := SYSDATE - :NEW.HIRE_DATE;
EXCEPTION
WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('ERROR=====>> ' || SQLERRM);
END TRG_CALCULATE_SENIORITY;


UPDATE EMPLOYEES
SET ACTIVE = 'F'
WHERE EMPLOYEE_ID = 126; 

