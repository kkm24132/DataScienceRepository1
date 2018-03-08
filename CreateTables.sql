
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

