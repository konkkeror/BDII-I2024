

DECLARE
    --ESTE ES UN COMENTARIO
    /* 
    COMENTARIO DE VARIAS LINEAS
    */
    V_NOMBRE VARCHAR2(50);
    V_APELLIDO VARCHAR2(50) := 'PEREZ';
    V_CANTIDAD_REGISTROS NUMBER;
    V_NOMBRE_CATEGORIA tbl_categorias.NOMBRE_CATEGORIA%TYPE;
    V_CODIGO_CATEGORIA tbl_categorias.CODIGO_CATEGORIA%TYPE;
    
    type PRODUCTO IS RECORD (
        CODIGO_PRODUCTO NUMBER,
        NOMBRE VARCHAR2(500),
        PRECIO NUMBER
    );
    
    V_PRODUCTO PRODUCTO;
    V_PRIMER_PRODUCTO PRODUCTO;
    V_OTRO_PRODUCTO TBL_PRODUCTOS%ROWTYPE;
BEGIN
    V_PRODUCTO.CODIGO_PRODUCTO := 666;
    V_PRODUCTO.NOMBRE := 'SHAMPOO';
    V_PRODUCTO.PRECIO := 10000;
    
    
    SELECT COUNT(1) 
    INTO V_CANTIDAD_REGISTROS
    FROM tbl_categorias;
    
    SELECT nombre_categoria, CODIGO_CATEGORIA
    INTO V_NOMBRE_CATEGORIA, V_CODIGO_CATEGORIA
    FROM tbl_categorias
    WHERE CODIGO_CATEGORIA = 1;
    
    SELECT *
    INTO V_PRIMER_PRODUCTO
    FROM TBL_PRODUCTOS
    WHERE ROWNUM = 1;
    
    SELECT *
    INTO V_OTRO_PRODUCTO
    FROM TBL_PRODUCTOS
    WHERE ROWNUM = 1;
    
    V_NOMBRE := 'JUAN';
    DBMS_OUTPUT.PUT_LINE('HOLA ' || V_NOMBRE || ' ' || V_APELLIDO);
    DBMS_OUTPUT.PUT_LINE('CANTIDAD DE REGISTROS: ' || V_CANTIDAD_REGISTROS);
    DBMS_OUTPUT.PUT_LINE('CATEGORIA: ' || v_nombre_categoria);
    DBMS_OUTPUT.PUT_LINE('CODIGO CATEGORIA: ' || v_CODIGO_categoria);
    DBMS_OUTPUT.PUT_LINE('PRODUCTO: ' || V_PRODUCTO.NOMBRE);
    DBMS_OUTPUT.PUT_LINE('PRIMER PRODUCTO: ' || V_PRIMER_PRODUCTO.NOMBRE);
    DBMS_OUTPUT.PUT_LINE('OTRO PRODUCTO: ' || V_OTRO_PRODUCTO.NOMBRE);
END;




select  tbl_productos.*, rowid, ROWNUM 
from tbl_productos
ORDER BY 2;






SELECT A.*, ROWNUM
FROM TBL_PRODUCTOS A
    WHERE ROWNUM = 1;
    
    COMMIT;





DECLARE
    Num1 NUMBER := 30;
    Num2 NUMBER := 50; -- Como no inicializamos la variable, su valor es NULL
    EsMayor VARCHAR2(15); 
BEGIN

    IF Num1 < Num2 THEN
        EsMayor := 'Yes'; 
    ELSE
        EsMayor := 'No';
    END IF;

    dbms_output.put_line(EsMayor);
END;


declare
    precio number := 15;
    descuento number := 0;
begin 
    CASE
        WHEN precio<11 THEN descuento:=2; 
        WHEN precio>10 and precio<25 THEN descuento:=5; 
        WHEN precio>24 THEN descuento:=10; 
        ELSE descuento := 15;
    END CASE;
    dbms_output.put_line(descuento);
end;


create table Tabla (
    valor number
);



DECLARE 
    V_Contador BINARY_INTEGER:=1;
BEGIN
    LOOP
        INSERT INTO Tabla (Valor) 
        VALUES (V_Contador); 
        V_Contador:=V_Contador +1; 
        
        EXIT WHEN V_Contador =1000000;
    END LOOP;
END;


DECLARE 
    V_Contador BINARY_INTEGER:=1;
BEGIN
    while v_contador<1000000 LOOP
        INSERT INTO Tabla (Valor) 
        VALUES (V_Contador); 
        V_Contador:=V_Contador + 1; 
    END LOOP;
END;

BEGIN
    FOR V_Contador IN 1..10 LOOP
        INSERT INTO Tabla (Valor)
        VALUES (V_Contador);
    END LOOP;
END;

BEGIN
    FOR V_Contador IN REVERSE 1..10 LOOP
        INSERT INTO Tabla (Valor)
        VALUES (V_Contador);
    END LOOP;
END;

rollback;

select * from tabla;

truncate table tabla; --(DDL)
delete from tabla; --(DML)

BEGIN
    DBMS_OUTPUT.PUT_LINE('Esto es un ejemplo.'); 
    GOTO Etiqueta_1;
    DBMS_OUTPUT.PUT_LINE('No hace el GOTO.'); 
    BEGIN
        <<Etiqueta_1>>
        DBMS_OUTPUT.PUT_LINE('Entra en el GOTO.');
    END;
END;



DECLARE
    V_PRODUCTO TBL_PRODUCTOS%ROWTYPE;
    V_PRODUCTO_2 TBL_PRODUCTOS%ROWTYPE;
    CURSOR C_PRODUCTOS IS SELECT * FROM TBL_PRODUCTOS ORDER BY CODIGO_PRODUCTO;
BEGIN

    SELECT * INTO V_PRODUCTO_2 FROM TBL_PRODUCTOS WHERE CODIGO_PRODUCTO=666;
    OPEN C_PRODUCTOS;
    DBMS_OUTPUT.PUT_LINE('Lista de PRODUCTOS');
    LOOP
        FETCH C_PRODUCTOS INTO V_PRODUCTO; 
        EXIT WHEN C_PRODUCTOS%NOTFOUND; 
        DBMS_OUTPUT.PUT_LINE('PRODUCTO: ' || V_PRODUCTO.NOMBRE || '('|| V_PRODUCTO.PRECIO ||')');
    END LOOP;
    CLOSE C_PRODUCTOS;
END;



DECLARE
    CURSOR C_Estudiantes_Inf IS SELECT Num_Mat, Nombre, Apellidos
    FROM Estudiantes WHERE Titulacion = 'Informatica';
BEGIN
    FOR V_Estudiantes IN C_Estudiantes_Inf LOOP 
        INSERT INTO Estudiantes_Inf (Matricula, NombreEstudiantes)
        VALUES (V_Estudiantes.Num_Mat, V_Estudiantes.Nombre || ' ' || V_Estudiantes.Apellidos);
    END LOOP;
END;




CREATE OR REPLACE PROCEDURE P_MOSTRAR_PRODUCTO IS
    --VARIABLES
    --...
BEGIN
    FOR V_PRODUCTO IN (SELECT * FROM TBL_PRODUCTOS) LOOP ---CURSOR IMPLICITO
        DBMS_OUTPUT.PUT_LINE(V_PRODUCTO.NOMBRE);
    END LOOP;
END;


CREATE OR REPLACE PROCEDURE P_MOSTRAR_PRODUCTO(P_CODIGO_PRODUCTO IN NUMBER) IS
    --VARIABLES
    V_PRODUCTO TBL_PRODUCTOS%ROWTYPE;
BEGIN
    SELECT *
    INTO V_PRODUCTO
    FROM TBL_PRODUCTOS
    WHERE CODIGO_PRODUCTO = P_CODIGO_PRODUCTO;
    
    DBMS_OUTPUT.PUT_LINE('PRODUCTO: '||V_PRODUCTO.NOMBRE);
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('HUBO UN ERROR');
END;

DROP PROCEDURE P_MOSTRAR_PRODUCTO;


BEGIN
    P_MOSTRAR_PRODUCTO(3);
END;



