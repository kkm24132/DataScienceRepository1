
---------------------------------------------------------------------------------------------------------------------
-- Create table scripts for Asset / Inventory related information (ASSET, MODEL, MANUFACTURER, SUBCONTRACTOR, CLIENT)
---------------------------------------------------------------------------------------------------------------------

-- Table Name: ATM_ICBC.MODEL
-- Create table definitions for MODEL table which contains information where Asset Model information such as - CINEO 2060, CINEO 2070, PC 2000 XE are stored
CREATE TABLE ATM_ICBC.MODEL (
	                     IDMODEL        INT           NOT NULL GENERATED ALWAYS AS IDENTITY(START WITH 1, INCREMENT BY 1)
	                    ,MODEL          VARCHAR(45)   NOT NULL
	                    ,RELEASED       DATE          NULL
	                    ,MEMORY         VARCHAR(20)   NULL
	                    ,PROCESSOR      VARCHAR(100)  NULL
	                    ,PRIMARY KEY (IDMODEL)
);
CREATE UNIQUE INDEX ATM_ICBC.MODEL_IDX 
                 ON ATM_ICBC.MODEL (MODEL);

-- Table Name: ATM_ICBC.MANUFACTURER
-- Create table definitions for MANUFACTURER table which contains manufacturer information such as WINCOR etc.
CREATE TABLE ATM_ICBC.MANUFACTURER (
	                            IDMANUFACTURER        INT           NOT NULL GENERATED ALWAYS AS IDENTITY(START WITH 1, INCREMENT BY 1)
	                           ,MANUFACTURER          VARCHAR(45)   NOT NULL
	                           ,COMMENT               VARCHAR(100)  NULL
	                           ,PRIMARY KEY (IDMANUFACTURER)
);
CREATE UNIQUE INDEX ATM_ICBC.MANUFACTURER_IDX 
                 ON ATM_ICBC.MANUFACTURER (MANUFACTURER);

-- Table Name: ATM_ICBC.SUBCONTRACTOR
-- Create table definitions for SUBCONTRACTOR table which contains subcontractor related information. e.g. IBM is one of the subcontractor here
CREATE TABLE ATM_ICBC.SUBCONTRACTOR (
	                             IDSUBCONTRACTOR      INT           NOT NULL GENERATED ALWAYS AS IDENTITY(START WITH 1, INCREMENT BY 1)
	                            ,SUBCONTRACTOR        VARCHAR(45)   NOT NULL
	                            ,COMMENT              VARCHAR(100)  NULL
	                            ,PRIMARY KEY (IDSUBCONTRACTOR)
);
CREATE UNIQUE INDEX ATM_ICBC.SUBCONTRACTOR_IDX 
                 ON ATM_ICBC.SUBCONTRACTOR (SUBCONTRACTOR);

-- Table Name: ATM_ICBC.CLIENT
-- Create table definitions for CLIENT table which contains customer specific information such contract, location, customer name etc.
CREATE TABLE ATM_ICBC.CLIENT (
	                      IDCLIENT        INT           NOT NULL GENERATED ALWAYS AS IDENTITY(START WITH 1, INCREMENT BY 1)
	                     ,CLIENT          VARCHAR(45)   NOT NULL
	                     ,CONTRACT        VARCHAR(100)  NULL
	                     ,LOCATION        VARCHAR(100)  NULL
	                     ,REQUIREMENTS    VARCHAR(100)  NULL
	                     ,PRIMARY KEY (IDCLIENT)
);
CREATE UNIQUE INDEX ATM_ICBC.CLIENT_IDX 
                 ON ATM_ICBC.CLIENT (CLIENT);

-- Table Name: ATM_ICBC.ASSET
-- Create table definitions for ASSET table which contains Asset / Inventory data 
CREATE TABLE ATM_ICBC.ASSET (
	                     IDASSET               INT           NOT NULL generated always AS identity(start WITH 1, increment BY 1)
	                    ,IDCLIENT              INT           NOT NULL
	                    ,IDMODEL               INT           NOT NULL
	                    ,IDMANUFACTURER        INT           NOT NULL
	                    ,IDSUBCONTRACTOR       INT           NOT NULL
	                    ,IDORIGINAL            VARCHAR(20)   NOT NULL   --for UNIQUE_ATM_ID
	                    ,IDORIGINALIBM         VARCHAR(20)   NULL       --for IBM_SERIAL_NUMBER
	                    ,MODULE_DEPOSITOR      VARCHAR(1)    NULL
	                    ,MODULE_DISPENSER      VARCHAR(1)    NULL
	                    ,MODULE_RECYCLING      VARCHAR(1)    NULL
	                    ,MODULE_CCDM           VARCHAR(1)    NULL
	                    ,INSTALLATION_OUTSIDE  VARCHAR(1)    NULL
	                    ,LOCATION              VARCHAR(100)  NULL
	                    ,SCHEDULE              VARCHAR(45)   NULL
	                    ,INSTALLED             DATE          NULL
	                    ,DEINSTALLED           DATE          NULL
	                    ,SNAPSHOT              DATE          NULL
	                    ,SOFTWARE              VARCHAR(100)  NULL
	                    ,PRIMARY KEY (IDASSET)
	                    ,CONSTRAINT IDMODEL FOREIGN KEY (IDMODEL) 
                                           REFERENCES ATM_ICBC.MODEL(IDMODEL) 
                                            ON DELETE no action 
                                            ON UPDATE no action
	                    ,CONSTRAINT IDCLIENT FOREIGN KEY (IDCLIENT) 
                                           REFERENCES ATM_ICBC.CLIENT(IDCLIENT) 
                                            ON DELETE no action 
                                            ON UPDATE no action
	                    ,CONSTRAINT IDMANUFACTURER FOREIGN KEY (IDMANUFACTURER) 
                                           REFERENCES ATM_ICBC.MANUFACTURER(IDMANUFACTURER) 
                                            ON DELETE no action 
                                            ON UPDATE no action
	                    ,CONSTRAINT IDSUBCONTRACTOR FOREIGN KEY (IDSUBCONTRACTOR) 
                                           REFERENCES ATM_ICBC.SUBCONTRACTOR(IDSUBCONTRACTOR) 
                                            ON DELETE no action 
                                            ON UPDATE no action
);

---------------------------------------------------------------------------------------------------------------------
-- Create table scripts for Ticket, Component related information (COMPONENT, TICKET, AVAILABILITY)
---------------------------------------------------------------------------------------------------------------------
-- Table Name: ATM_ICBC.COMPONENT
-- Create table definitions for COMPONENT table which contains Component / Module related information of Assets
CREATE TABLE ATM_ICBC.COMPONENT (
	                          IDCOMPONENT      INT           NOT NULL GENERATED ALWAYS AS IDENTITY(START WITH 1, INCREMENT BY 1)
	                         ,IDASSET          INT           NOT NULL
	                         ,COMPONENT        VARCHAR(100)  NOT NULL
	                         ,VERSION          VARCHAR(100)  NULL
	                         ,PRIMARY KEY (IDCOMPONENT)
	                         ,CONSTRAINT IDASSET FOREIGN KEY (IDASSET) 
	                                              REFERENCES ATM_ICBC.ASSET(IDASSET) 
	                                               ON DELETE NO ACTION 
	                                               ON UPDATE NO ACTION
);
--CREATE UNIQUE INDEX ATM_ICBC.IDASSET_IDX 
--                 ON ATM_ICBC.COMPONENT (IDASSET); -- The unique index is disabled for data load and not used
--CREATE UNIQUE INDEX ATM_ICBC.IDASSET_COMPONENT_IDX
--                 ON ATM_ICBC.COMPONENT (IDASSET, COMPONENT); -- The unique index is disabled for data loads and not used

-- Table Name: ATM_ICBC.TICKET
-- Create table definitions for TICKET table which contains service tickets related information 
CREATE TABLE ATM_ICBC.TICKET (
	                       IDTICKET          INT           NOT NULL GENERATED ALWAYS AS IDENTITY(START WITH 1, INCREMENT BY 1)
	                      ,IDASSET           INT           NOT NULL
	                      ,IDCOMPONENT       INT           NOT NULL
	                      ,OPENED            TIMESTAMP     NOT NULL
	                      ,CLOSED            TIMESTAMP     NULL
	                      ,ASSIGNED          TIMESTAMP     NULL
	                      ,ACTION            VARCHAR(100)  NULL   -- Proposed to be added from TAR_CODE (1st digit)
	                      ,TAR_MODULE        VARCHAR(100)  NULL   -- Proposed to be added from TAR_CODE (2nd and 3rd digits)
	                      ,RESOLUTION        VARCHAR(100)  NULL   -- This is 4th digit in TAR_CODE which is Problem Determination or Resolution
	                      ,DESCRIPTION       VARCHAR(100)  NULL
	                      ,SERVICE_LEVEL     VARCHAR(45)   NULL
	                      ,PART_REPLACED     VARCHAR(1)    NULL
	                      ,TYPE              VARCHAR(20)   NULL
	                      ,PRIMARY KEY (IDTICKET)
	                      ,CONSTRAINT IDASSET FOREIGN KEY (IDASSET) 
	                                           REFERENCES ATM_ICBC.ASSET(IDASSET) 
	                                            ON DELETE NO ACTION 
	                                            ON UPDATE NO ACTION
	                      ,CONSTRAINT IDCOMPONENT FOREIGN KEY (IDCOMPONENT) 
	                                               REFERENCES ATM_ICBC.COMPONENT(IDCOMPONENT) 
	                                                ON DELETE NO ACTION 
	                                                ON UPDATE NO ACTION
);

--CREATE UNIQUE INDEX ATM_ICBC.IDASSET_IDX
--                 ON ATM_ICBC.TICKET (IDASSET); -- The unique index is disabled for data load and not used
--CREATE UNIQUE INDEX ATM_ICBC.IDCOMPONENT_IDX
--                 ON ATM_ICBC.TICKET (IDCOMPONENT); -- The unique index is disabled for data load and not used

-- Table Name: ATM_ICBC.AVAILABILITY
-- Create table definitions for AVAILABILITY table which contains availability related information. No data loaded yet, not required from modeling standpoint for ICBC at the moment
CREATE TABLE ATM_ICBC.AVAILABILITY (
	                             IDAVAILABILITY         INT        NOT NULL GENERATED ALWAYS AS IDENTITY(START WITH 1, INCREMENT BY 1)
	                            ,IDASSET                INT        NOT NULL
	                            ,IDCOMPONENT            INT        NOT NULL
	                            ,DAYS_TOTAL             DOUBLE     NOT NULL
	                            ,DAYS_DOWN              DOUBLE     NOT NULL
	                            ,PRIMARY KEY (IDAVAILABILITY)
	                            ,CONSTRAINT IDASSET FOREIGN KEY (IDASSET) 
	                                                 REFERENCES ATM_ICBC.ASSET(IDASSET) 
	                                                  ON DELETE NO ACTION 
	                                                  ON UPDATE NO ACTION
	                            ,CONSTRAINT IDCOMPONENT FOREIGN KEY (IDCOMPONENT) 
	                                                 REFERENCES ATM_ICBC.COMPONENT(IDCOMPONENT) 
	                                                  ON DELETE NO ACTION 
	                                                  ON UPDATE NO ACTION
);
--CREATE UNIQUE INDEX ATM_ICBC.IDASSET_IDX
--                ON ATM_ICBC.AVAILABILITY (IDASSET); -- The unique index is disabled for data load and not used
--CREATE UNIQUE INDEX ATM_ICBC.IDCOMPONENT_IDX
--                 ON ATM_ICBC.AVAILABILITY (IDCOMPONENT); -- The unique index is disabled for data load and not used


---------------------------------------------------------------------------------------------------------------------
-- Create table scripts for Monitoring related information (STATUS, DISPOSITION, MONITORING)
---------------------------------------------------------------------------------------------------------------------
-- Table Name: ATM_ICBC.STATUS
-- Create table definitions for STATUS table which contains Event/Error codes and description (i.e. Error Dictionary data)
CREATE TABLE ATM_ICBC.STATUS (
	                       IDSTATUS         INT           NOT NULL GENERATED ALWAYS AS IDENTITY(START WITH 1, INCREMENT BY 1)
	                      ,STATUS           VARCHAR(45)   NOT NULL
	                      ,COMMENT          VARCHAR(100)  NULL
	                      ,PRIMARY KEY (IDSTATUS)
);
CREATE UNIQUE INDEX ATM_ICBC.STATUS_IDX
                 ON ATM_ICBC.STATUS (STATUS);

-- Table Name: ATM_ICBC.DISPOSITION
-- Create table definitions for DISPOSITION table, No data loaded yet, not required from modeling standpoint for ICBC at the moment
CREATE TABLE ATM_ICBC.DISPOSITION (
	                            IDDISPOSITION        INT           NOT NULL GENERATED ALWAYS AS IDENTITY(START WITH 1, INCREMENT BY 1)
	                           ,DISPOSITION          VARCHAR(45)   NOT NULL
	                           ,COMMENT              VARCHAR(100)  NULL
	                           ,PRIMARY KEY (IDDISPOSITION)
);
CREATE UNIQUE INDEX ATM_ICBC.DISPOSITION_IDX
                 ON ATM_ICBC.DISPOSITION (DISPOSITION);

-- Table Name: ATM_ICBC.MONITORING
-- Create table definitions for MONITORING table, that is Error / Event information
CREATE TABLE ATM_ICBC.MONITORING (
	                           IDMONITORING         INT        NOT NULL GENERATED ALWAYS AS IDENTITY(START WITH 1, INCREMENT BY 1)
	                          ,IDASSET              INT        NOT NULL
	                          ,IDCOMPONENT          INT        NULL      -- changed from NOT NULL to NULL
	                          ,IDDISPOSITION        INT        NULL      -- changed from NOT NULL to NULL
	                          ,IDSTATUS             INT        NOT NULL
	                          ,DATE                 TIMESTAMP  NOT NULL
	                          ,PRIMARY KEY (IDMONITORING)
	                          ,CONSTRAINT IDASSET FOREIGN KEY (IDASSET) 
	                                               REFERENCES ATM_ICBC.ASSET(IDASSET) 
	                                                ON DELETE NO ACTION 
	                                                ON UPDATE NO ACTION
--	                          ,CONSTRAINT IDCOMPONENT FOREIGN KEY (IDCOMPONENT) 
--	                                               REFERENCES ATM_ICBC.COMPONENT(IDCOMPONENT) 
--	                                                ON DELETE NO ACTION 
--	                                                ON UPDATE NO ACTION
	                          ,CONSTRAINT IDSTATUS FOREIGN KEY (IDSTATUS) 
	                                                REFERENCES ATM_ICBC.STATUS (IDSTATUS) 
	                                                 ON DELETE NO ACTION 
	                                                 ON UPDATE NO ACTION
--	                          ,CONSTRAINT IDDISPOSITION FOREIGN KEY (IDDISPOSITION) 
--	                                               REFERENCES ATM_ICBC.DISPOSITION(IDDISPOSITION) 
--	                                                ON DELETE NO ACTION 
--	                                                ON UPDATE NO ACTION
);
CREATE UNIQUE INDEX ATM_ICBC.IDASSET_IDX
                 ON ATM_ICBC.MONITORING (IDASSET);
CREATE UNIQUE INDEX ATM_ICBC.IDSTATUS_IDX
                 ON ATM_ICBC.MONITORING (IDSTATUS);
--CREATE UNIQUE INDEX ATM_ICBC.IDCOMPONENT_IDX
--                 ON ATM_ICBC.MONITORING (IDCOMPONENT); -- The unique index is disabled for data load and not used
--CREATE UNIQUE INDEX ATM_ICBC.IDDISPOSITION_IDX
--                 ON ATM_ICBC.MONITORING (IDDISPOSITION); -- The unique index is disabled for data load and not used



---------------------------------------------------------------------------------------------------------------------
-- Create table scripts for Transaction related information (TRANSACTION_TYPE, TRANSACTION)
---------------------------------------------------------------------------------------------------------------------
-- Table Name: ATM_ICBC.TRANSACTION_TYPE
-- Create table definitions for TRANSACTION_TYPE table which contains details of different types of transactions
-- Currently 4 types of transactions - Withdraw (Cash withdrawal), Deposit(Envelope and bunch deposits), Checks (Standard Depositor only), Non-Cash (Payments, PIN change, Inquiries etc.)
CREATE TABLE ATM_ICBC.TRANSACTION_TYPE (
	                                 IDTTYPE        INT           NOT NULL GENERATED ALWAYS AS IDENTITY(START WITH 1, INCREMENT BY 1)
	                                ,TTYPE          VARCHAR(45)   NOT NULL
	                                ,COMMENT        VARCHAR(100)  NULL
	                                ,PRIMARY KEY (IDTTYPE)
);
CREATE UNIQUE INDEX ATM_ICBC.TTYPE_IDX
                 ON ATM_ICBC.TRANSACTION_TYPE (TTYPE);

-- Table Name: ATM_ICBC.TRANSACTION
-- Create table definitions for TRANSACTION table which contains daily transactions (Granularity = 1 for daily)
CREATE TABLE ATM_ICBC.TRANSACTION (
	                            IDTRANSACTION      INT         NOT NULL GENERATED ALWAYS AS IDENTITY(START WITH 1, INCREMENT BY 1)
	                           ,IDASSET            INT         NOT NULL            
	                           ,IDTTYPE            INT         NOT NULL
	                           ,DATE               TIMESTAMP   NOT NULL            -- transaction date / timestamp
	                           ,COUNT              INT         NULL                -- transaction count, can be NULL
	                           ,VALUE              NUMERIC     NOT NULL            -- transaction amount 
	                           ,GRANULARITY        INT         NULL     DEFAULT 1  -- e.g. 1 for daily, 7 for weekly etc, for now : default 1 for transactions aggregated at daily level
	                           ,PRIMARY KEY (IDTRANSACTION)
--	                           ,CONSTRAINT IDASSET FOREIGN KEY (IDASSET)           -- remove constraint while data load
--	                                                REFERENCES ATM_ICBC.ASSET(IDASSET) 
--	                                                 ON DELETE NO ACTION 
--	                                                 ON UPDATE NO ACTION
	                           ,CONSTRAINT IDTTYPE FOREIGN KEY (IDTTYPE) 
	                                                REFERENCES ATM_ICBC.TRANSACTION_TYPE(IDTTYPE) 
	                                                 ON DELETE NO ACTION 
	                                                 ON UPDATE NO ACTION
);
--CREATE UNIQUE INDEX ATM_ICBC.IDASSET_IDX
--                 ON ATM_ICBC.TRANSACTION (IDASSET);  --The unique index is disabled for data load and not used 
CREATE UNIQUE INDEX ATM_ICBC.IDTTYPE_IDX
                 ON ATM_ICBC.TRANSACTION (IDTTYPE);

---------------------------------------------------------------------------------------------------------------------
-- Create table scripts for Result / Prediction related information (INTERVAL, FEATURE, EXPERIMENT, CONFIGURATION,
-- DATASET, SELECTION, RESULT)
---------------------------------------------------------------------------------------------------------------------
-- Table Name: ATM_ICBC.INTERVAL
-- Create table definitions for INTERVAL table which contains observation and prediction start and end dates for every run / round.
CREATE TABLE ATM_ICBC.INTERVAL (
	                         IDINTERVAL          INT    NOT NULL GENERATED ALWAYS AS IDENTITY(START WITH 1, INCREMENT BY 1)
	                        ,OBSERVE_FROM        DATE   NOT NULL
	                        ,OBSERVE_TO          DATE   NOT NULL
	                        ,PREDICT_FROM        DATE   NOT NULL
	                        ,PREDICT_TO          DATE   NOT NULL
	                        ,PRIMARY KEY (IDINTERVAL)
);

-- Table Name: ATM_ICBC.FEATURE
-- Create table definitions for FEATURE table which will contain all features used in model development for arriving results or predictions.
-- This is not loaded currently for ICBC
CREATE TABLE ATM_ICBC.FEATURE (
	                        IDFEATURE            INT            NOT NULL GENERATED ALWAYS AS IDENTITY(START WITH 1, INCREMENT BY 1)
	                       ,NAME                 VARCHAR(45)    NOT NULL
	                       ,DESCRIPTION          VARCHAR(100)   NULL
	                       ,PRIMARY KEY (IDFEATURE)
);

-- Table Name: ATM_ICBC.EXPERIMENT
-- Create table definitions for EXPERIMENT table which contains information related to various model experiments and
-- captures cutoff, precision, recall and F1-score for an experiment
CREATE TABLE ATM_ICBC.EXPERIMENT (
	                           IDEXPERIMENT        INT         NOT NULL GENERATED ALWAYS AS IDENTITY(START WITH 1, INCREMENT BY 1)
	                          ,PERFORMED           TIMESTAMP   NOT NULL
	                          ,CUTOFF              DOUBLE      NULL
	                          ,RECALL              DOUBLE      NULL
	                          ,PRECISION           DOUBLE      NULL
	                          ,F1_SCORE            DOUBLE      NULL
	                          ,PRIMARY KEY (IDEXPERIMENT)
);

-- Table Name: ATM_ICBC.CONFIGURATION
-- Create table definitions for CONFIGURATION table. This is a master table to capture module information for every interval and for every experiment.
CREATE TABLE ATM_ICBC.CONFIGURATION (
	                              IDEXPERIMENT        INT           NOT NULL
	                             ,IDINTERVAL          INT           NOT NULL
	                             ,COMPONENT           VARCHAR(45)   NOT NULL
	                             ,CONSTRAINT IDEXPERIMENT FOREIGN KEY (IDEXPERIMENT) 
	                                                       REFERENCES ATM_ICBC.EXPERIMENT(IDEXPERIMENT) 
	                                                        ON DELETE NO ACTION 
	                                                        ON UPDATE NO ACTION
	                             ,CONSTRAINT IDINTERVAL FOREIGN KEY (IDINTERVAL) 
	                                                     REFERENCES ATM_ICBC.INTERVAL(IDINTERVAL) 
	                                                      ON DELETE NO ACTION 
	                                                      ON UPDATE NO ACTION
);
--CREATE UNIQUE INDEX CONFIGURATION.IDEXPERIMENT_IDX
--                 ON ATM_ICBC.CONFIGURATION (IDEXPERIMENT); --The unique index is disabled for data load and not used
--CREATE UNIQUE INDEX CONFIGURATION.IDINTERVAL_IDX
--                 ON ATM_ICBC.CONFIGURATION (IDINTERVAL); --The unique index is disabled for data load and not used

-- Table Name: ATM_ICBC.RESULT
-- Create table definitions for RESULT table which contains predicted and actual results for the model experiment for an asset
CREATE TABLE ATM_ICBC.RESULT (
	                       IDEXPERIMENT       INT       NOT NULL
	                      ,IDASSET            INT       NOT NULL
	                      ,ACTUAL             DOUBLE    NOT NULL
	                      ,PREDICTED          DOUBLE    NOT NULL
);
--CREATE UNIQUE INDEX RESULT.IDEXPERIMENT_IDX 
--                 ON ATM_ICBC.RESULT (IDEXPERIMENT); --The unique index is disabled for data load and not used

-- Table Name: ATM_ICBC.DATASET
-- Create table definitions for DATASET table which contains information of experiments for assets. 
-- This is not populated for ICBC unified schema as of now
CREATE TABLE ATM_ICBC.DATASET (
	                        IDEXPERIMENT      INT   NOT NULL
	                       ,IDASSET           INT   NOT NULL
	                       ,CONSTRAINT IDEXPERIMENT FOREIGN KEY (IDEXPERIMENT) 
	                                                 REFERENCES ATM_ICBC.EXPERIMENT(IDEXPERIMENT) 
	                                                  ON DELETE NO ACTION 
	                                                  ON UPDATE NO ACTION
);
--CREATE UNIQUE INDEX DATASET.IDEXPERIMENT_IDX 
--                 ON ATM_ICBC.DATASET (IDEXPERIMENT); --The unique index is disabled for data load and not used

-- Table Name: ATM_ICBC.SELECTION
-- Create table definitions for SELECTION table which contains features used in every experiments
CREATE TABLE ATM_ICBC.SELECTION (
	                          IDEXPERIMENT      INT   NOT NULL
	                         ,IDFEATURE         INT   NOT NULL
	                         ,CONSTRAINT IDEXPERIMENT FOREIGN KEY (IDEXPERIMENT) 
	                                                   REFERENCES ATM_ICBC.EXPERIMENT(IDEXPERIMENT) 
	                                                    ON DELETE NO ACTION 
	                                                    ON UPDATE NO ACTION
	                         ,CONSTRAINT IDFEATURE FOREIGN KEY (IDFEATURE) 
	                                                REFERENCES ATM_ICBC.FEATURE(IDFEATURE) 
	                                                 ON DELETE NO ACTION 
	                                                 ON UPDATE NO ACTION
);


