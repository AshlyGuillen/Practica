CREATE OR REPLACE PROCEDURE SP_CARGAR_MACHINE_INV AS 
 
-- tabla donde están los datos en crudo 
---------------------------------------------------------------- 
CURSOR C_INV IS 
   SELECT * 
   FROM EXT_INVENTARIO_VMS 
   WHERE NVL(PROCESADO,'N')='N'; 
 
---------------------------------------------------------------- 
-- VARIABLES IDS 
---------------------------------------------------------------- 
 
V_ID_AMBIENTE             VARCHAR2(100); 
V_ID_SERVICIOS            VARCHAR2(100); 
V_ID_PAIS                 VARCHAR2(100); 
V_ID_UBICACION            VARCHAR2(100); 
V_ID_CLUSTER_VM           VARCHAR2(100);  
V_ID_DATACENTER           VARCHAR2(100); 
V_ID_FABRICANTE           VARCHAR2(100); 
V_ID_CATEGORIA_OS         VARCHAR2(100); 
V_ID_SISTEMA_OPERATIVO    VARCHAR2(100); 
 
 
BEGIN 
 
FOR R IN C_INV LOOP 
 
SAVEPOINT SP_FILA; 
 
-- LIMPIAR VARIABLES DE LA ITERACION 
      
       V_ID_AMBIENTE := NULL; 
       V_ID_SERVICIOS := NULL; 
       V_ID_PAIS := NULL; 
       V_ID_UBICACION := NULL; 
       V_ID_CLUSTER_VM := NULL;  
       V_ID_DATACENTER := NULL; 
       V_ID_FABRICANTE := NULL; 
       V_ID_CATEGORIA_OS := NULL; 
       V_ID_SISTEMA_OPERATIVO := NULL; 
 
 
  BEGIN 
 
------------- AMBIENTE ------------------------------------ 
    BEGIN
    SELECT ID_AMBIENTE
    INTO V_ID_AMBIENTE
    FROM AMBIENTE_INV
    WHERE AMBIENTE = R.AMBIENTE;
 
EXCEPTION
    WHEN NO_DATA_FOUND THEN
 
        INSERT INTO AMBIENTE_INV
        (
            ID_AMBIENTE,
            AMBIENTE
        )
        VALUES
        (
            SEQ_AMBIENTE_INV.NEXTVAL,
            R.AMBIENTE
        )
        RETURNING ID_AMBIENTE
        INTO V_ID_AMBIENTE;
END; 
 
 
   -- SERVICIO
BEGIN
    SELECT ID_SERVICIOS
    INTO V_ID_SERVICIOS
    FROM SERVICIOS_INV
    WHERE SERVICIOS = R.SERVICIOS;
 
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        INSERT INTO SERVICIOS_INV
        (
            ID_SERVICIOS,
            SERVICIOS
        )
        VALUES
        (
            SEQ_SERVICIOS_INV.NEXTVAL,
            R.SERVICIOS
        )
        RETURNING ID_SERVICIOS
        INTO V_ID_SERVICIOS;
END;
 
 
      -- PAIS
BEGIN
    SELECT ID_PAISINV
    INTO V_ID_PAIS
    FROM PAIS_INV
    WHERE PAISINV = R.PAIS;
 
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        INSERT INTO PAIS_INV
        (
            ID_PAISINV,
            PAISINV
        )
        VALUES
        (
            SEQ_PAIS_INV.NEXTVAL,
            R.PAIS
        )
        RETURNING ID_PAISINV
        INTO V_ID_PAIS;
END;
 
       -- UBICACION
BEGIN
    SELECT ID_UBICACION
    INTO V_ID_UBICACION
    FROM UBICACION_INV
    WHERE UBICACION = R.UBICACION
      AND ID_PAISINV = V_ID_PAIS;
 
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        INSERT INTO UBICACION_INV
        (
            ID_UBICACION,
            UBICACION,
            ID_PAISINV
        )
        VALUES
        (
            SEQ_UBICACION_INV.NEXTVAL,
            R.UBICACION,
            V_ID_PAIS
        )
        RETURNING ID_UBICACION
        INTO V_ID_UBICACION;
END;
 
       --------------------------------------------------------
-- CLUSTER (GET OR CREATE)
--------------------------------------------------------
BEGIN
 
    SELECT ID_CLUSTER_vm
    INTO V_ID_CLUSTER_VM
    FROM CLUSTER_vm
    WHERE CLUSTER_vm = R.CLUSTER_vm;
 
EXCEPTION
    WHEN NO_DATA_FOUND THEN
 
        INSERT INTO CLUSTER_vm
        (
            ID_CLUSTER_vm,
            CLUSTER_vm
        )
        VALUES
        (
            SEQ_CLUSTER_INV.NEXTVAL,
            R.CLUSTER_vm
        )
        RETURNING ID_CLUSTER_vm
        INTO V_ID_CLUSTER_VM;
 
END;
 
       --------------------------------------------------------
-- DATACENTER (GET OR CREATE)
--------------------------------------------------------
BEGIN
 
    SELECT ID_DATACENTER_INV
    INTO V_ID_DATACENTER
    FROM DATACENTER_INV
    WHERE DATACENTER = R.DATACENTER
      AND ID_CLUSTER_vm = V_ID_CLUSTER_VM;
 
EXCEPTION
    WHEN NO_DATA_FOUND THEN
 
        INSERT INTO DATACENTER_INV
        (
            ID_DATACENTER_INV,
            DATACENTER,
            ID_CLUSTER_vm
        )
        VALUES
        (
            SEQ_DATACENTER_INV.NEXTVAL,
            R.DATACENTER,
            V_ID_CLUSTER_VM
        )
        RETURNING ID_DATACENTER_INV
        INTO V_ID_DATACENTER;
 
END;
 
--------------------------------------------------------
-- FABRICANTE (GET OR CREATE)
--------------------------------------------------------
BEGIN
 
    SELECT ID_FABRICANTE
    INTO V_ID_FABRICANTE
    FROM FABRICANTE_OS_INV
    WHERE FABRICANTE = R.FABRICANTE_OS;
 
EXCEPTION
    WHEN NO_DATA_FOUND THEN
 
        INSERT INTO FABRICANTE_OS_INV
        (
            ID_FABRICANTE,
            FABRICANTE
        )
        VALUES
        (
            SEQ_FABRICANTE_OS_INV.NEXTVAL,
            R.FABRICANTE_OS
        )
        RETURNING ID_FABRICANTE
        INTO V_ID_FABRICANTE;
 
END;
--------------------------------------------------------
-- CATEGORIA OS (GET OR CREATE)
--------------------------------------------------------
BEGIN
 
    SELECT ID_CATEGORIA_OS
    INTO V_ID_CATEGORIA_OS
    FROM CATEGORIA_OS_INV
    WHERE CATEGORIA = R.CATEGORIA_OS;
 
EXCEPTION
    WHEN NO_DATA_FOUND THEN
 
        INSERT INTO CATEGORIA_OS_INV
        (
            ID_CATEGORIA_OS,
            CATEGORIA
        )
        VALUES
        (
            SEQ_CATEGORIA_OS_INV.NEXTVAL,
            R.CATEGORIA_OS
        )
        RETURNING ID_CATEGORIA_OS
        INTO V_ID_CATEGORIA_OS;
 
END;
 
--------------------------------------------------------
-- SISTEMA OPERATIVO (GET OR CREATE)
--------------------------------------------------------
BEGIN
 
    SELECT ID_SISTEMA_OPERATIVO
    INTO V_ID_SISTEMA_OPERATIVO
    FROM SISTEMA_OPERATIVO_INV
    WHERE SISTEMA_OPERATIVO = R.SISTEMA_OPERATIVO
      AND VERSION = R.VERSION
      AND ID_CATEGORIA_OS = V_ID_CATEGORIA_OS
      AND ID_FABRICANTE = V_ID_FABRICANTE;
 
EXCEPTION
    WHEN NO_DATA_FOUND THEN
 
        INSERT INTO SISTEMA_OPERATIVO_INV
        (
            ID_SISTEMA_OPERATIVO,
            SISTEMA_OPERATIVO,
            VERSION,
            ID_CATEGORIA_OS,
            ID_FABRICANTE
        )
        VALUES
        (
            SEQ_SISTEMA_OPERATIVO_INV.NEXTVAL,
            R.SISTEMA_OPERATIVO,
            R.VERSION,
            V_ID_CATEGORIA_OS,
            V_ID_FABRICANTE
        )
        RETURNING ID_SISTEMA_OPERATIVO
        INTO V_ID_SISTEMA_OPERATIVO;
 
END;
 
 
      -------------------------------------------------------- 
       -- INSERT MAESTRO 
       -------------------------------------------------------- 
 
       INSERT INTO MACHINE_MASTER_INV 
       ( 
           ID_SISTEMA_OPERATIVO, 
           ID_AMBIENTE, 
           ACTIVO, 
           ID_UBICACION, 
           ID_SERVICIOS, 
           TIPO, 
           VIRTUALIZADOR, 
           ESTADO, 
           ID_DATACENTER, 
           MEMORIA, 
           CPU, 
           ULTIMA_ACTUALIZACION, 
           ESX, 
           FECHA_CREACION, 
           SITE_PRIMARIO_SECUNDARIO, 
           HORA_CREACION, 
           N_IPS_V4, 
           N_IPS_V6, 
           IPSV6, 
           LISTADO_IPSV4_V6, 
           TAGS, 
           OBSERVACIONES, 
           ESTADO_PROCESAMIENTO, 
           ERROR, 
           IPV4, 
           DNS, 
           NOMBRE_VM, 
           DISCOS, 
           ESPACIO, 
           TENABLE, 
           REPOSITORIO_TENABLE, 
           ANTIVIRUS, 
           DESGLOSE_ANTIVIRUS, 
           TRELLIX, 
           TREND, 
           CORTEX, 
           ESTADO_ANTIVIRUS, 
           LUMU, 
           SENTINEL, 
           CYBERARK, 
           CYBERARK_LISTADO, 
           USUARIOS_CYBERARK, 
           ENDPOINT_CENTRAL, 
           AD, 
           VEEAM_BACKUP, 
           VEEAM_REPLICA, 
           BACKUP_ACTIVO, 
           REPLICA_ACTIVA, 
           JOB_BK, 
           JOB_REPLICA, 
           SIEM, 
           HARDENING, 
           PUPPET, 
           EXCEPCIONES, 
           EXCEPCION_TENABLE, 
           EXCEPCION_SENTINEL, 
           EXCEPCION_AD, 
           EXCEPCION_VEEAM, 
           EXCEPCION_CYBERARK, 
           EXCEPCION_ANTIVIRUS, 
           EXCEPCION_DC, 
           EXCEPCION_LUMU, 
           EXCEPCION_SIEM, 
           EXCEPCION_PUPPET, 
           EXCEPCION_HARDENING 
       ) 
       VALUES 
       ( 
           V_ID_SISTEMA_OPERATIVO, 
           V_ID_AMBIENTE, 
           R.ACTIVO, 
           V_ID_UBICACION, 
           V_ID_SERVICIOS, 
           R.TIPO, 
           R.VIRTUALIZADOR, 
           R.ESTADO, 
           V_ID_DATACENTER, 
           R.MEMORIA, 
           R.CPU, 
           R.ULTIMA_ACTUALIZACION, 
           R.ESX, 
           R.FECHA_CREACION, 
           R.SITE_PRIMARIO_SECUNDARIO, 
           R.HORA_CREACION, 
           R.N_IPS_V4, 
           R.N_IPS_V6, 
           R.IPSV6, 
           R.LISTADO_IPSV4_V6, 
           R.TAGS, 
           R.OBSERVACIONES, 
           R.ESTADO_PROCESAMIENTO, 
           R.ERROR, 
           R.IPV4, 
           R.DNS, 
           R.NOMBRE_VM, 
           R.DISCOS, 
           R.ESPACIO, 
           R.TENABLE, 
           R.REPOSITORIO_TENABLE, 
           R.ANTIVIRUS, 
           R.DESGLOSE_ANTIVIRUS, 
           R.TRELLIX, 
           R.TREND, 
           R.CORTEX, 
           R.ESTADO_ANTIVIRUS, 
           R.LUMU, 
           R.SENTINEL, 
           R.CYBERARK, 
           R.CYBERARK_LISTADO, 
           R.USUARIOS_CYBERARK, 
           R.ENDPOINT_CENTRAL, 
           R.AD, 
           R.VEEAM_BACKUP, 
           R.VEEAM_REPLICA, 
           R.BACKUP_ACTIVO, 
           R.REPLICA_ACTIVA, 
           R.JOB_BK, 
           R.JOB_REPLICA, 
           R.SIEM, 
           R.HARDENING, 
           R.PUPPET, 
           R.EXCEPCIONES, 
           R.EXCEPCION_TENABLE, 
           R.EXCEPCION_SENTINEL, 
           R.EXCEPCION_AD, 
           R.EXCEPCION_VEEAM, 
           R.EXCEPCION_CYBERARK, 
           R.EXCEPCION_ANTIVIRUS, 
           R.EXCEPCION_DC, 
           R.EXCEPCION_LUMU, 
           R.EXCEPCION_SIEM, 
           R.EXCEPCION_PUPPET, 
           R.EXCEPCION_HARDENING 
       ); 
 
 
-- Procesado correctamente 
 
UPDATE EXT_INVENTARIO_VMS SET PROCESADO = 'S', FECHA_PROCESO = SYSDATE WHERE ID = R.ID; 
 
EXCEPTION 
 
WHEN OTHERS THEN 
 
    ROLLBACK TO SP_FILA; 
 
    UPDATE EXT_INVENTARIO_VMS 
    SET PROCESADO = 'E', 
        FECHA_PROCESO = SYSDATE, 
        ERROR = SUBSTR(SQLERRM,1,4000)   -- << ACTIVADA: ahora sí guarda el motivo del error
    WHERE ID = R.ID; 
 
END; 
 
END LOOP; 
 
COMMIT; 
 
END SP_CARGAR_MACHINE_INV;
/
