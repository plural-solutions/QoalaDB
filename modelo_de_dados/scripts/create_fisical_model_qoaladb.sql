-- Gerado por Oracle SQL Developer Data Modeler 4.1.5.907
--   em:        2016-10-05 17:12:04 BRT
--   site:      Oracle Database 12c
--   tipo:      Oracle Database 12c




CREATE TABLE ACCESSCONTROL
  (
    TOKEN      INTEGER NOT NULL ,
    CREATED_AT DATE ,
    EXPIRED_AT DATE ,
    REMOTEIP   VARCHAR2 (15 BYTE) ,
    ID_USER    INTEGER NOT NULL
  )
  LOGGING ;
COMMENT ON COLUMN ACCESSCONTROL.REMOTEIP
IS
  '000.000.000.000' ;
ALTER TABLE ACCESSCONTROL ADD CONSTRAINT ACCESSCONTROL_PK PRIMARY KEY ( TOKEN ) ;


CREATE TABLE COMMENTS
  (
    ID_COMMENT INTEGER NOT NULL ,
    CONTENT CLOB NOT NULL ,
    CREATED_AT  DATE NOT NULL ,
    UPDATED_AT  DATE ,
    APPROVED_AT DATE ,
    DELETED_AT  DATE ,
    ID_POST     INTEGER NOT NULL ,
    ID_USER     INTEGER NOT NULL
  )
  LOGGING ;
ALTER TABLE COMMENTS ADD CONSTRAINT COMMENTS_PK PRIMARY KEY ( ID_COMMENT ) ;


CREATE TABLE COMMENT_LOGS
  (
    LOG CLOB NOT NULL ,
    COMMENTS_ID INTEGER NOT NULL ,
    CREATED_AT  DATE NOT NULL
  )
  LOGGING ;


CREATE TABLE DEVICES
  (
    ID_DEVICE        INTEGER NOT NULL ,
    ALIAS            VARCHAR2 (50) NOT NULL ,
    COLOR            VARCHAR2 (15) ,
    FREQUENCY_UPDATE INTEGER NOT NULL ,
    LAST_LONGITUDE   NUMBER (10,7) ,
    LAST_LATITUDE    NUMBER (10,7) ,
    ALARM            NUMBER (1) ,
    ID_USER          INTEGER NOT NULL ,
    CREATED_AT       DATE NOT NULL ,
    UPDATED_AT       DATE ,
    DELETED_AT       DATE
  )
  LOGGING ;
ALTER TABLE DEVICES ADD CONSTRAINT DEVICE_PK PRIMARY KEY ( ID_DEVICE ) ;


CREATE TABLE DEVICE_GEO_LOCATIONS
  (
    ID_DEVICE_GEO_LOCATION INTEGER NOT NULL ,
    ID_DEVICE              INTEGER NOT NULL ,
    VERIFIED_AT            DATE NOT NULL ,
    LATITUDE               NUMBER (10,7) NOT NULL ,
    LONGITUDE              NUMBER (10,7) NOT NULL
  )
  LOGGING ;
ALTER TABLE DEVICE_GEO_LOCATIONS ADD CONSTRAINT DEVICE_GEO_LOCATION_PK PRIMARY KEY ( ID_DEVICE_GEO_LOCATION ) ;


CREATE TABLE DEVICE_GEO_LOCATIONS_JN
 (JN_OPERATION CHAR(3) NOT NULL
 ,JN_ORACLE_USER VARCHAR2(30) NOT NULL
 ,JN_DATETIME DATE NOT NULL
 ,JN_NOTES VARCHAR2(240)
 ,JN_APPLN VARCHAR2(35)
 ,JN_SESSION NUMBER(38)
 ,ID_DEVICE_GEO_LOCATION INTEGER NOT NULL
 ,ID_DEVICE INTEGER NOT NULL
 ,VERIFIED_AT DATE NOT NULL
 ,LATITUDE NUMBER (10,7) NOT NULL
 ,LONGITUDE NUMBER (10,7) NOT NULL
 );

CREATE OR REPLACE TRIGGER DEVICE_GEO_LOCATIONS_JNtrg
  AFTER 
  INSERT OR 
  UPDATE OR 
  DELETE ON DEVICE_GEO_LOCATIONS for each row 
 Declare 
  rec DEVICE_GEO_LOCATIONS_JN%ROWTYPE; 
  blank DEVICE_GEO_LOCATIONS_JN%ROWTYPE; 
  BEGIN 
    rec := blank; 
    IF INSERTING OR UPDATING THEN 
      rec.ID_DEVICE_GEO_LOCATION := :NEW.ID_DEVICE_GEO_LOCATION; 
      rec.ID_DEVICE := :NEW.ID_DEVICE; 
      rec.VERIFIED_AT := :NEW.VERIFIED_AT; 
      rec.LATITUDE := :NEW.LATITUDE; 
      rec.LONGITUDE := :NEW.LONGITUDE; 
      rec.JN_DATETIME := SYSDATE; 
      rec.JN_ORACLE_USER := SYS_CONTEXT ('USERENV', 'SESSION_USER'); 
      rec.JN_APPLN := SYS_CONTEXT ('USERENV', 'MODULE'); 
      rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID'); 
      IF INSERTING THEN 
        rec.JN_OPERATION := 'INS'; 
      ELSIF UPDATING THEN 
        rec.JN_OPERATION := 'UPD'; 
      END IF; 
    ELSIF DELETING THEN 
      rec.ID_DEVICE_GEO_LOCATION := :OLD.ID_DEVICE_GEO_LOCATION; 
      rec.ID_DEVICE := :OLD.ID_DEVICE; 
      rec.VERIFIED_AT := :OLD.VERIFIED_AT; 
      rec.LATITUDE := :OLD.LATITUDE; 
      rec.LONGITUDE := :OLD.LONGITUDE; 
      rec.JN_DATETIME := SYSDATE; 
      rec.JN_ORACLE_USER := SYS_CONTEXT ('USERENV', 'SESSION_USER'); 
      rec.JN_APPLN := SYS_CONTEXT ('USERENV', 'MODULE'); 
      rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID'); 
      rec.JN_OPERATION := 'DEL'; 
    END IF; 
    INSERT into DEVICE_GEO_LOCATIONS_JN VALUES rec; 
  END; 
  /
CREATE TABLE DEVICE_GEO_LOCATION_LOGS
  (
    LOG CLOB NOT NULL ,
    DEVICE_GEO_LOCATION_ID INTEGER NOT NULL ,
    CREATED_AT             DATE NOT NULL
  )
  LOGGING ;


CREATE TABLE DEVICE_LOGS
  (
    LOG CLOB NOT NULL ,
    DEVICE_ID  INTEGER NOT NULL ,
    CREATED_AT DATE NOT NULL
  )
  LOGGING ;


CREATE TABLE INFO_COMPANY
  ( KEY VARCHAR2 (20) , VALUE CLOB
  ) LOGGING ;


CREATE TABLE POSTS
  (
    ID_POST INTEGER NOT NULL ,
    TITLE   VARCHAR2 (255 BYTE) NOT NULL ,
    CONTENT CLOB NOT NULL ,
    CREATED_AT   DATE NOT NULL ,
    UPDATED_AT   DATE ,
    PUBLISHED_AT DATE ,
    DELETED_AT   DATE ,
    ID_USER      INTEGER NOT NULL
  )
  LOGGING ;
ALTER TABLE POSTS ADD CONSTRAINT POST_PK PRIMARY KEY ( ID_POST ) ;


CREATE TABLE POST_LOGS
  (
    LOG CLOB NOT NULL ,
    POST_ID    INTEGER NOT NULL ,
    CREATED_AT DATE NOT NULL
  )
  LOGGING ;


CREATE TABLE USERS
  (
    ID_USER    INTEGER NOT NULL ,
    NAME       VARCHAR2 (255 CHAR) NOT NULL ,
    PASSWORD   VARCHAR2 (255 CHAR) NOT NULL ,
    EMAIL      VARCHAR2 (255 CHAR) NOT NULL ,
    PERMISSION NUMBER (2) DEFAULT 1 NOT NULL ,
    CREATED_AT DATE NOT NULL ,
    UPDATED_AT DATE ,
    DELETED_AT DATE ,
    ADDRESS    VARCHAR2 (255 CHAR) ,
    DISTRICT   VARCHAR2 (255 CHAR) ,
    CITY       VARCHAR2 (100) ,
    STATE      VARCHAR2 (20 CHAR) ,
    ZIPCODE    VARCHAR2 (9 CHAR)
  )
  LOGGING ;
ALTER TABLE USERS ADD CONSTRAINT CK_USER_PERMISSION CHECK ( PERMISSION IN (1, 2, 3)) ;
COMMENT ON COLUMN USERS.PERMISSION
IS
  '1: Normal Public, 2: Editor/Writer, 3: Administrator' ;
CREATE UNIQUE INDEX IDX_USERS_EMAIL ON USERS ( EMAIL ASC , DELETED_AT DESC ) LOGGING ;
ALTER TABLE USERS ADD CONSTRAINT USER_PK PRIMARY KEY ( ID_USER ) ;


CREATE TABLE USERS_JN
 (JN_OPERATION CHAR(3) NOT NULL
 ,JN_ORACLE_USER VARCHAR2(30) NOT NULL
 ,JN_DATETIME DATE NOT NULL
 ,JN_NOTES VARCHAR2(240)
 ,JN_APPLN VARCHAR2(35)
 ,JN_SESSION NUMBER(38)
 ,ID_USER INTEGER NOT NULL
 ,NAME VARCHAR2 (255 CHAR) NOT NULL
 ,PASSWORD VARCHAR2 (255 CHAR) NOT NULL
 ,EMAIL VARCHAR2 (255 CHAR) NOT NULL
 ,PERMISSION NUMBER (2) NOT NULL
 ,CREATED_AT DATE NOT NULL
 ,UPDATED_AT DATE
 ,DELETED_AT DATE
 ,ADDRESS VARCHAR2 (255 CHAR)
 ,DISTRICT VARCHAR2 (255 CHAR)
 ,CITY VARCHAR2 (100)
 ,STATE VARCHAR2 (20 CHAR)
 ,ZIPCODE VARCHAR2 (9 CHAR)
 );

CREATE OR REPLACE TRIGGER USERS_JNtrg
  AFTER 
  INSERT OR 
  UPDATE OR 
  DELETE ON USERS for each row 
 Declare 
  rec USERS_JN%ROWTYPE; 
  blank USERS_JN%ROWTYPE; 
  BEGIN 
    rec := blank; 
    IF INSERTING OR UPDATING THEN 
      rec.ID_USER := :NEW.ID_USER; 
      rec.NAME := :NEW.NAME; 
      rec.PASSWORD := :NEW.PASSWORD; 
      rec.EMAIL := :NEW.EMAIL; 
      rec.PERMISSION := :NEW.PERMISSION; 
      rec.CREATED_AT := :NEW.CREATED_AT; 
      rec.UPDATED_AT := :NEW.UPDATED_AT; 
      rec.DELETED_AT := :NEW.DELETED_AT; 
      rec.ADDRESS := :NEW.ADDRESS; 
      rec.DISTRICT := :NEW.DISTRICT; 
      rec.CITY := :NEW.CITY; 
      rec.STATE := :NEW.STATE; 
      rec.ZIPCODE := :NEW.ZIPCODE; 
      rec.JN_DATETIME := SYSDATE; 
      rec.JN_ORACLE_USER := SYS_CONTEXT ('USERENV', 'SESSION_USER'); 
      rec.JN_APPLN := SYS_CONTEXT ('USERENV', 'MODULE'); 
      rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID'); 
      IF INSERTING THEN 
        rec.JN_OPERATION := 'INS'; 
      ELSIF UPDATING THEN 
        rec.JN_OPERATION := 'UPD'; 
      END IF; 
    ELSIF DELETING THEN 
      rec.ID_USER := :OLD.ID_USER; 
      rec.NAME := :OLD.NAME; 
      rec.PASSWORD := :OLD.PASSWORD; 
      rec.EMAIL := :OLD.EMAIL; 
      rec.PERMISSION := :OLD.PERMISSION; 
      rec.CREATED_AT := :OLD.CREATED_AT; 
      rec.UPDATED_AT := :OLD.UPDATED_AT; 
      rec.DELETED_AT := :OLD.DELETED_AT; 
      rec.ADDRESS := :OLD.ADDRESS; 
      rec.DISTRICT := :OLD.DISTRICT; 
      rec.CITY := :OLD.CITY; 
      rec.STATE := :OLD.STATE; 
      rec.ZIPCODE := :OLD.ZIPCODE; 
      rec.JN_DATETIME := SYSDATE; 
      rec.JN_ORACLE_USER := SYS_CONTEXT ('USERENV', 'SESSION_USER'); 
      rec.JN_APPLN := SYS_CONTEXT ('USERENV', 'MODULE'); 
      rec.JN_SESSION := SYS_CONTEXT ('USERENV', 'SESSIONID'); 
      rec.JN_OPERATION := 'DEL'; 
    END IF; 
    INSERT into USERS_JN VALUES rec; 
  END; 
  /
CREATE TABLE USER_LOGS
  (
    LOG CLOB NOT NULL ,
    USER_ID    INTEGER NOT NULL ,
    CREATED_AT DATE NOT NULL
  )
  LOGGING ;

CREATE TABLE PLANS
  (
    ID_PLAN    INTEGER DEFAULT seq_plans.NEXTVAL NOT NULL,
    NAME       VARCHAR2 (50 CHAR) NOT NULL ,
    PRICE_CENTS   NUMBER NOT NULL ,
    LEFT          number not null,
    REWARDS     VARCHAR2 (350 CHAR) NOT NULL ,
    CREATED_AT DATE NOT NULL
  )
  LOGGING ;
CREATE UNIQUE INDEX IDX_PLANS_NAME ON PLANS ( NAME ASC ) LOGGING ;
ALTER TABLE PLANS ADD CONSTRAINT PLAN_PK PRIMARY KEY ( ID_PLAN ) ;


CREATE UNIQUE INDEX IDX_PLANS_REWARD ON PLANS_REWARDS ( ID_PLAN ASC , ID_REWARD DESC ) LOGGING ;
ALTER TABLE PLANS_REWARDS ADD CONSTRAINT PLAN_REWARD_PK PRIMARY KEY ( ID_PLAN, ID_REWARD ) ;

ALTER TABLE ACCESSCONTROL ADD CONSTRAINT ACCESSCONTROL_USERS_FK FOREIGN KEY ( ID_USER ) REFERENCES USERS ( ID_USER ) NOT DEFERRABLE ;

ALTER TABLE COMMENTS ADD CONSTRAINT COMMENTS_POST_FK FOREIGN KEY ( ID_POST ) REFERENCES POSTS ( ID_POST ) NOT DEFERRABLE ;

ALTER TABLE COMMENTS ADD CONSTRAINT COMMENTS_USER_FK FOREIGN KEY ( ID_USER ) REFERENCES USERS ( ID_USER ) NOT DEFERRABLE ;

ALTER TABLE DEVICES ADD CONSTRAINT DEVICES_USER_FK FOREIGN KEY ( ID_USER ) REFERENCES USERS ( ID_USER ) NOT DEFERRABLE ;

ALTER TABLE DEVICE_GEO_LOCATIONS ADD CONSTRAINT DEVICE_GEO_LOCATION_DEVICE_FK FOREIGN KEY ( ID_DEVICE ) REFERENCES DEVICES ( ID_DEVICE ) NOT DEFERRABLE ;

ALTER TABLE POSTS ADD CONSTRAINT POST_USER_FK FOREIGN KEY ( ID_USER ) REFERENCES USERS ( ID_USER ) NOT DEFERRABLE ;


ALTER TABLE Users
  ADD document VARCHAR(20);
  
ALTER TABLE Users
  ADD id_plan VARCHAR(20);
  


-- Relatório do Resumo do Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                            12
-- CREATE INDEX                             1
-- ALTER TABLE                             13
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- TSDP POLICY                              0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
