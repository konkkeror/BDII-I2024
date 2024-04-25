create or replace TRIGGER TRG_JOB_HISTORY
AFTER UPDATE OF JOB_ID ON EMPLOYEES
FOR EACH ROW
DECLARE
    V_START_DATE DATE;
BEGIN
    SELECT  MAX(END_DATE) + 1
    INTO V_START_DATE
    FROM JOB_HISTORY
    WHERE EMPLOYEE_ID = :NEW.EMPLOYEE_ID;

    INSERT INTO job_history (
        employee_id,
        start_date,
        end_date,
        job_id,
        department_id
    ) VALUES (
        :NEW.EMPLOYEE_ID, --101
        V_START_DATE, --16/03/97
        TRUNC(SYSDATE),
        :OLD.JOB_ID, --AD_VP
        :OLD.DEPARTMENT_ID
    );

    EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR=====>> ' || SQLERRM);
        DBMS_OUTPUT.PUT_LINE('EMPLOYEE ID=====>> ' || :NEW.EMPLOYEE_ID);
        DBMS_OUTPUT.PUT_LINE('JOB ID=====>> ' || :OLD.JOB_ID);
END;