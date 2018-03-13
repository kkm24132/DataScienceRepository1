---------------------------------------------------------------------------------------------------------------------
-- Insert table scripts for Asset / Inventory related information (MODEL, MANUFACTURER, SUBCONTRACTOR, CLIENT, ASSET)
---------------------------------------------------------------------------------------------------------------------

-- Insert script for Table: MODEL
INSERT INTO ATM_ICBC.MODEL (MODEL, RELEASED, MEMORY, PROCESSOR)
SELECT DISTINCT INV.WINCOR_MODEL, 
                '01/01/1900', 
		NULL, 
		NULL 
  FROM BASE_ICBC.INVENTORY AS INV;

-- Insert script for Table: MANUFACTURER
INSERT INTO ATM_ICBC.MANUFACTURER (MANUFACTURER, COMMENT)
SELECT DISTINCT INV.MANUFACTURER, 
                NULL
  FROM BASE_ICBC.INVENTORY AS INV;

-- Insert script for Table: SUBCONTRACTOR
INSERT INTO ATM_ICBC.SUBCONTRACTOR (SUBCONTRACTOR, COMMENT)
SELECT DISTINCT 'IBM', 
                NULL
  FROM BASE_ICBC.INVENTORY AS INV;

-- Insert script for Table: CLIENT
INSERT INTO ATM_ICBC.CLIENT (CLIENT, CONTRACT, LOCATION, REQUIREMENTS)
VALUES ('ICBC Argentina', 'BR583', 'Argentina', NULL);

-- Insert script for Table: ASSET
INSERT INTO ATM_ICBC.ASSET (IDCLIENT, IDMODEL, IDMANUFACTURER, IDSUBCONTRACTOR, IDORIGINAL, 
                            IDORIGINALIBM, MODULE_DEPOSITOR, MODULE_DISPENSER, MODULE_RECYCLING, 
                            MODULE_CCDM, INSTALLATION_OUTSIDE, LOCATION, SCHEDULE, INSTALLED, 
                            DEINSTALLED, SNAPSHOT, SOFTWARE)
SELECT (SELECT C.IDCLIENT
          FROM ATM_ICBC.CLIENT AS C
         WHERE C.CLIENT = 'ICBC Argentina'), 
       (SELECT M.IDMODEL
          FROM ATM_ICBC.MODEL AS M
         WHERE M.MODEL = INV.WINCOR_MODEL), 
       (SELECT MFR.IDMANUFACTURER
          FROM ATM_ICBC.MANUFACTURER AS MFR
         WHERE MFR.MANUFACTURER = INV.MANUFACTURER), 
       (SELECT S.IDSUBCONTRACTOR
          FROM ATM_ICBC.SUBCONTRACTOR AS S
         WHERE S.SUBCONTRACTOR = 'IBM'), 
       INV.UNIQUE_ATM_ID, 
       INV.IBM_SERIAL, 
       (SUBSTR(INV.ENVELOPE_MODULE, 1, 1)), 
       (SUBSTR(INV.CASH_DISPENSER, 1, 1)),
       (SUBSTR(INV.RECYLCLING_MODULE, 1, 1)), 
       (SUBSTR(INV.CCDM, 1, 1)), 
       'N', 
       (SELECT LOC.LATITUDE CONCAT ',' CONCAT LOC.LONGITUDE
          FROM NIKIFOR.ICBC_LOCATION AS LOC
         WHERE LOC.IBM_SERIAL = INV.IBM_SERIAL), 
       NULL, 
       INV.INSTALLED_DATE, 
       INV.DEINSTALLATION_DATE, 
       ('01-23-2018'), 
       NULL
  FROM BASE_ICBC.INVENTORY AS INV;
  
---------------------------------------------------------------------------------------------------------------------
-- Insert table scripts for Ticket, Component, Availability related information (COMPONENT and TICKET only)
-- Availability table is not loaded yet with data
---------------------------------------------------------------------------------------------------------------------

-- [Step1: Create temporary table] Create a cross reference temporary table to populate Component/Ticket and later it will be dropped after data entry done in Component and Ticket table
CREATE TABLE ATM_ICBC.TAR_CODE_XREF (
       CALL_NUM  VARCHAR(20)  NOT NULL, 
       TAR_CODE  VARCHAR(20)  NULL, 
       IDASSET   VARCHAR(20)  NOT NULL
);

-- [Step2: Insert into temporary table] Insert into temporary Table: TAR_CODE_XREF (Intermediate temporary table, will be dropped after loading Component and Ticket tables in ATM_ICBC schema)
INSERT INTO ATM_ICBC.TAR_CODE_XREF (CALL_NUM, TAR_CODE, IDASSET)
SELECT TICKETS.CALL_NUM, 
       TAR.TAR_CODE, 
       ASSET.IDASSET
  FROM BASE_ICBC.LAIW_DATA AS TICKETS 
       INNER JOIN ATM_ICBC.ASSET AS ASSET 
               ON RIGHT(TICKETS.SERIAL, 5) = ASSET.IDORIGINALIBM   
        LEFT JOIN BASE_ICBC.TAR_CODE_OVERRIDE AS TAR 
               ON TICKETS.CALL_NUM = TAR.CALL_NUM
 WHERE TAR.TAR_CODE IS NOT NULL;

-- [Step3] Insert script for Table: COMPONENT
INSERT INTO ATM_ICBC.COMPONENT (IDASSET, COMPONENT, VERSION)
SELECT DISTINCT TAR.IDASSET, 
                SUBSTR(TAR.TAR_CODE, 2, 2), 
		NULL
  FROM ATM_ICBC.TAR_CODE_XREF AS TAR
 WHERE SUBSTR(TAR.TAR_CODE, 2, 2) NOT IN ('**','--');

-- [Step4: for TICKET table data load] Create the view and then remove NULL values from idAsset, idComponent from that view and load the same onto TICKET table load.
CREATE VIEW ATM_ICBC.VIEW_TICKET_TEMP AS
SELECT ALL 
       (SELECT A.IDASSET 
	  FROM ATM_ICBC.ASSET AS A 
	 WHERE A.IDORIGINALIBM = RIGHT("TICKET".SERIAL, 5)) AS "IDASSET", 
       (SELECT C.IDCOMPONENT 
	  FROM ATM_ICBC.COMPONENT AS C 
	 WHERE C.IDASSET = "TAR".IDASSET 
	   AND C.COMPONENT = SUBSTR("TAR".TAR_CODE, 2, 2) 
	   AND C.IDCOMPONENT IS NOT NULL) AS "IDCOMPONENT", 
       "TICKET".OPEN_TMS AS "OPENED", 
       "TICKET".CLOSED_TMS AS "CLOSED", 
       "TICKET".TO_TMS AS "ASSIGNED",
       (SELECT SUBSTR("TAR"."TAR_CODE", 1, 1) 
	  FROM BASE_ICBC.TAR_CODE_OVERRIDE AS T 
	 WHERE T.CALL_NUM = "TICKET".CALL_NUM) AS "ACTION", --Action
       (SELECT SUBSTR("TAR"."TAR_CODE", 2, 2) 
	  FROM BASE_ICBC.TAR_CODE_OVERRIDE AS T 
	 WHERE T.CALL_NUM = "TICKET".CALL_NUM) AS "TAR_MODULE", --TAR_MODULE
       (SELECT SUBSTR("TAR"."TAR_CODE", 4, 1) 
	  FROM BASE_ICBC.TAR_CODE_OVERRIDE AS T 
	 WHERE T.CALL_NUM = "TICKET".CALL_NUM) AS "RESOLUTION", --Problem Determination or Resolution
       "TICKET".TM_DESCRIPTION AS "DESCRIPTION", -- Ticket Description
       NULL AS "SERVICE_LEVEL",
       NULL AS "PART_REPLACED",
       CASE LEFT("TICKET".ESN, 3) 
       WHEN 'PDM' THEN 'Predictive' 
       ELSE 'Others' 
       END AS "TYPE"
  FROM BASE_ICBC.LAIW_DATA AS "TICKET"
       LEFT JOIN ATM_ICBC.TAR_CODE_XREF AS "TAR" 
              ON "TICKET".CALL_NUM = "TAR".CALL_NUM;

-- [Step5] Insert script for Table: TICKET
INSERT INTO ATM_ICBC.TICKET (IDASSET, IDCOMPONENT, OPENED, CLOSED, ASSIGNED, ACTION, TAR_MODULE, RESOLUTION, DESCRIPTION, SERVICE_LEVEL, PART_REPLACED, TYPE)
SELECT T.IDASSET, 
       T.IDCOMPONENT, 
       T.OPENED, 
       T.CLOSED, 
       T.ASSIGNED, 
       T.ACTION, 
       T.TAR_MODULE, 
       T.RESOLUTION, 
       T.DESCRIPTION, 
       T.SERVICE_LEVEL, 
       T.PART_REPLACED, 
       T.TYPE
  FROM ATM_ICBC.VIEW_TICKET_TEMP AS T
 WHERE T.IDASSET IS NOT NULL 
   AND T.IDCOMPONENT IS NOT NULL;

-- [Step6] Drop intermediate temporary table TAR_CODE_XREF that is no longer needed
DROP TABLE ATM_ICBC.TAR_CODE_XREF;

-- [Step7] Drop the view_ticket_temp as well which is no longer needed
DROP VIEW ATM_ICBC.VIEW_TICKET_TEMP;
 
---------------------------------------------------------------------------------------------------------------------
-- Insert table scripts for Monitoring related information (STATUS, DISPOSITION, MONITORING)
-- Disposition table is not loaded yet
---------------------------------------------------------------------------------------------------------------------

-- Insert script for Table: STATUS
INSERT INTO ATM_ICBC.STATUS (STATUS, COMMENT)
(SELECT ED.ERRCODE_BASE24, 
        SUBSTR(ED.DESCRIPTION, 1, 100)
   FROM BASE_ICBC.ERROR_DICTIONARY AS ED)
   
  UNION

(SELECT ERR.ERR_CODE, 
 	NULL
   FROM BASE_ICBC.ERRORS AS ERR
  WHERE ERR.ERR_CODE NOT IN
        (SELECT DISTINCT ED.ERRCODE_BASE24
           FROM BASE_ICBC.ERROR_DICTIONARY AS ED));

-- Insert script for Table: MONITORING
-- Insert for specific date range: 2016-05-01 to 2018-01-31 (e.g. starting from May/2016 through January/2018)
INSERT INTO ATM_ICBC.MONITORING (IDASSET, 
				 --IDCOMPONENT,
				 --IDDISPOSITION,
				 IDSTATUS, 
				 DATE, 
				 SOURCE)
WITH DATES (START_DATE, END_DATE) AS (VALUES ('2016-05-01', '2018-01-31'))
SELECT A.IDASSET,
       (SELECT DISTINCT S.IDSTATUS
          FROM ATM_ICBC.STATUS AS S
         WHERE S.STATUS = ERR.ERR_CODE), 
       ERR.EVENT_TMS, 
       NULL
  FROM BASE_ICBC.ERRORS AS ERR 
       INNER JOIN ATM_ICBC.ASSET AS A 
               ON ERR.ATM_ID = A.IDORIGINAL 
       INNER JOIN DATES 
               ON ERR.EVENT_TMS BETWEEN DATES.START_DATE AND DATES.END_DATE;

---------------------------------------------------------------------------------------------------------------------
-- Insert table scripts for Transaction related information (TRANSACTION_TYPE, TRANSACTION)
---------------------------------------------------------------------------------------------------------------------

-- Insert script for Table: TRANSACTION_TYPE
INSERT INTO ATM_ICBC.TRANSACTION_TYPE (TTYPE, COMMENT)
SELECT TRX_MAP.TRANSACTION_TYPE, 
       TRX_MAP.OPERATION
  FROM NIKIFOR.TRX_MAPPING AS TRX_MAP;

-- Insert script for Table: TRANSACTION
INSERT INTO ATM_ICBC.TRANSACTION (IDASSET, IDTTYPE, DATE, COUNT, VALUE, GRANULARITY)
SELECT TRAN.IDASSET,
       TRAN.IDTTYPE,
       TRAN.TRANSACTION_DATE,
       TRAN.TRANSACTION_COUNT,
       TRAN.TRANSACTION_AMOUNT,
       TRAN.GRANULARITY 
  FROM (SELECT A.IDASSET AS "IDASSET",
     	       TT.IDTTYPE AS "IDTTYPE",
     	       date(TRX.TRANSACTION_TMS) AS "TRANSACTION_DATE", 
     	       SUM(CASE WHEN LEFT(TRX.REV_OPERATION, 1) = '*' THEN - 1 
     	                WHEN LEFT(TRX.RESP_CODE, 2) IN ('00', '01', '03') THEN 1 
     	                ELSE 0 
     	           END) AS "TRANSACTION_COUNT",
     	       SUM(CASE WHEN LEFT(TRX.REV_OPERATION, 1) = '*' THEN - 1 * TRX.AMOUNT 
     	                WHEN LEFT(TRX.RESP_CODE, 2) IN ('00', '01', '03') THEN TRX.AMOUNT 
     	 		ELSE 0 
     	 	   END) AS "TRANSACTION_AMOUNT",
     	       1 AS "GRANULARITY"
          FROM ICBC.TRANSACTIONS AS TRX
     	       INNER JOIN NIKIFOR.TRX_MAPPING AS TM 
     	               ON TRX.TRANSACTION_TYPE = TM.TRANSACTION_TYPE
     	       INNER JOIN ATM_ICBC.TRANSACTION_TYPE AS TT 
     	               ON TRX.TRANSACTION_TYPE = TT.TTYPE
	       INNER JOIN ATM_ICBC.ASSET AS A 
	 	       ON TRX.ATM_ID = A.IDORIGINAL
     	       INNER JOIN BASE_ICBC.INVENTORY AS INV 
     	               ON TRX.ATM_ID = INV.UNIQUE_ATM_ID 
     	              AND TRX.TRANSACTION_TMS BETWEEN INSTALLED_DATE AND value(DEINSTALLATION_DATE, CURRENT DATE)
                 GROUP BY TRX.ATM_ID, INV.IBM_SERIAL, A.IDASSET, TT.IDTTYPE, date(TRX.TRANSACTION_TMS), TM.OPERATION
        ) TRAN
 WHERE TRAN.TRANSACTION_COUNT > 0;


