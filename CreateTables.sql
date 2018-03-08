
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

