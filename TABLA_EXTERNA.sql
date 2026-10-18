CREATE TABLE EXT_INVENTARIO_VMS (
  ID                    VARCHAR2(100),
    IPV4                    VARCHAR2(100),
    NOMBRE_VM               VARCHAR2(200),
    DNS                     VARCHAR2(200),
    ESTADO                  VARCHAR2(50),
    SISTEMA_OPERATIVO       VARCHAR2(200),
    AMBIENTE                VARCHAR2(50),
    TIPO_ACTIVO             VARCHAR2(100),
    PAIS                    VARCHAR2(50),
    SERVICIOS               VARCHAR2(1000),
    FABRICANTE_OS           VARCHAR2(100),
    VERSION                 VARCHAR2(100),
    DISCOS                  VARCHAR2(500),
    ESPACIO                 VARCHAR2(100),
    MEMORIA                 VARCHAR2(100),
    CPU                     VARCHAR2(100),
    ULTIMA_ACTUALIZACION    VARCHAR2(100),
    ESX                     VARCHAR2(200),
    SITE_PRIMARIO_SECUNDARIO VARCHAR2(100),
    FECHA_CREACION          VARCHAR2(50),
    HORA_CREACION           VARCHAR2(50),
    N_IPS_V4                VARCHAR2(20),
    N_IPS_V6                VARCHAR2(20),
    UBICACION               VARCHAR2(200),
    TIPO                    VARCHAR2(100),
    IPV6                    VARCHAR2(200),
    LISTADO_IPSV4_V6        VARCHAR2(2000),
    CATEGORIA_OS            VARCHAR2(100),
    CLUSTER_VM                 VARCHAR2(200),
    DATACENTER              VARCHAR2(200),
    VISUALIZADOR            VARCHAR2(200),
    TAGS                    VARCHAR2(1000),
    TENABLE                 VARCHAR2(50),
    REPOSITORIO_TENABLE     VARCHAR2(200),
    ANTIVIRUS               VARCHAR2(100),
    DESGLOCE_ANTIVIRUS      VARCHAR2(1000),
    TRELLIX                 VARCHAR2(50),
    TREND                  VARCHAR2(100),
    CORTEX                  VARCHAR2(50),
    ESTADO_ANTIVIRUS        VARCHAR2(100),
    LUMU                    VARCHAR2(50),
    SENTINEL                VARCHAR2(50),
    CYBERARK                VARCHAR2(50),
    CYBERARK_LISTADO        VARCHAR2(2000),
    CYBERARK_USUARIOS       VARCHAR2(2000),
    ENDPOINT_CENTRAL        VARCHAR2(50),
    AD                      VARCHAR2(50),
    VEEAM_BACKUP            VARCHAR2(50),
    VEEAM_REPLICA           VARCHAR2(50),
    BACKUP_ACTIVO           VARCHAR2(50),
    REPLICA_ACTIVA          VARCHAR2(50),
    JOB_BK                  VARCHAR2(500),
    JOB_REPLICA             VARCHAR2(500),
    OBSERVACIONES           VARCHAR2(2000),
    SIEM                    VARCHAR2(50),
    HARDENING               VARCHAR2(50),
    PUPPET                  VARCHAR2(50),
    EXCEPCIONES             VARCHAR2(1000),
    EXCEPCION_TENABLE       VARCHAR2(500),
    EXCEPCION_SENTINEL      VARCHAR2(500),
    EXCEPCION_AD            VARCHAR2(500),
    EXCEPCION_VEEAM         VARCHAR2(500),
    EXCEPCION_CYBERARK      VARCHAR2(500),
    EXCEPCION_ANTIVIRUS     VARCHAR2(500),
    EXCEPCION_DC            VARCHAR2(500),
    EXCEPCION_LUMU          VARCHAR2(500),
    EXCEPCION_SIEM          VARCHAR2(500),
    EXCEPCION_PUPPET        VARCHAR2(500),
    EXCEPCION_HARDENING     VARCHAR2(500),
     pathfinder     VARCHAR2(500),
      fim     VARCHAR2(500),
)
ORGANIZATION EXTERNAL (
    TYPE ORACLE_LOADER
    DEFAULT DIRECTORY CARGAARCHIVOS
    ACCESS PARAMETERS (
        RECORDS DELIMITED BY NEWLINE
        SKIP 1
        BADFILE  CARGAARCHIVOS:'inventario_vms.bad'
        LOGFILE  CARGAARCHIVOS:'inventario_vms.log'
        FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
        MISSING FIELD VALUES ARE NULL
        REJECT ROWS WITH ALL NULL FIELDS
    )
    LOCATION ('INFRAESTRUCTURA_INVENTARIO.csv')
)
REJECT LIMIT UNLIMITED;