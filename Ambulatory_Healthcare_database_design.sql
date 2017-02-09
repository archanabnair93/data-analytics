
-- author archanab

-- SATISFYING USE CASE #1

-- Health center management requests the first and last names of all 
-- physicians that work in the ”Agnes” or “Palladius” buildings. 
-- Write a single query that retrieves this information for management. 


-- Step 1 : Creating tables- physician and building

-- Creating PHYSICIAN table

CREATE TABLE physician(
physician_ID DECIMAL(10) NOT NULL, physician_first VARCHAR(30),
physician_last VARCHAR(40),
building_ID DECIMAL(10) NOT NULL,
PRIMARY KEY (physician_ID),
FOREIGN KEY (building_ID) REFERENCES building);

INSERT INTO physician VALUES(1,'John','Smith',1);
INSERT INTO physician VALUES(2,'Mary','Berman',2);
INSERT INTO physician VALUES(3,'Elizabeth','Johnson',1);
INSERT INTO physician VALUES(4,'Peter','Quigley',3);
INSERT INTO physician VALUES(5,'Stanton','Hurley',2);
INSERT INTO physician VALUES(6,'Yvette','Presley',1);
INSERT INTO physician VALUES(7,'Hilary','Marsh',3);
INSERT INTO physician VALUES(8,'Jim','Denver',4);
INSERT INTO physician VALUES(9,'Codie','Smith',4);
INSERT INTO physician VALUES(10,'Kasey','Joseph',2);
INSERT INTO physician VALUES(11,'Joe','Jacobs',3);
INSERT INTO physician VALUES(12,'Sharon','Steve',1);
INSERT INTO physician VALUES(13,'Steve','Madison',1);
INSERT INTO physician VALUES(14,'Jeniffer','Sullivan',2);
INSERT INTO physician VALUES(15,'Philip','Benz',3);

select * from physician;



-- Creating BUILDING table

CREATE TABLE building(
building_ID DECIMAL(10) NOT NULL, building_name VARCHAR(30),
PRIMARY KEY (building_ID));

INSERT INTO building VALUES(1,'Agnes');
INSERT INTO building VALUES(2,'Palladius');
INSERT INTO building VALUES(3,'Dandellion');
INSERT INTO building VALUES(4,'Lilacville');

select * from building;


-- Step 2 : Query the physician table, and look up the building table by matching building_id
-- This query satisfies use case 2. All physicians working in Palladius or Agnes buildings are retrieved
-- buildingID is also displayed for proof

Select physician_first,physician_last, building_id  from physician where building_id 
IN (select building_id from building where building_name= 'Agnes' OR building_name='Palladius');



-- SATISFYING USE CASE #2 

-- Auditors request the names of all patients that currently have insurance, 
-- as well as the name of their current insurance plan. 
-- Write a single query that retrieves this information for the auditors. 

-- Step 1: Create PATIENT table

CREATE TABLE patient(
patient_ID DECIMAL(10) NOT NULL, patient_first VARCHAR(30),
patient_last VARCHAR(40),insurance_ID DECIMAL(10),
PRIMARY KEY (patient_ID),
FOREIGN KEY (insurance_ID) REFERENCES insurance);

INSERT INTO patient VALUES(1,'Jeff','Berenz',1);
INSERT INTO patient VALUES(2,'Halley','Cullan',2);
INSERT INTO patient VALUES(3,'Stephan','John',NULL);
INSERT INTO patient VALUES(4,'Justin','Jacob',3);
INSERT INTO patient VALUES(5,'Will','Dazler',2);
INSERT INTO patient VALUES(6,'John','Smiths',NULL);
INSERT INTO patient VALUES(7,'Denver','Kristen',4);
INSERT INTO patient VALUES(8,'Christine','Ann',2);
INSERT INTO patient VALUES(9,'Carole','Vetter',2);
INSERT INTO patient VALUES(10,'Yu','Won',NULL);
select * from patient;



-- STEP 2: Create INSURANCE table

CREATE TABLE insurance(
insurance_ID DECIMAL(10) NOT NULL, insurance_name VARCHAR(30),
PRIMARY KEY (insurance_ID));

INSERT INTO insurance VALUES(1,'Plan A');
INSERT INTO insurance VALUES(2,'Plan B');
INSERT INTO insurance VALUES(3,'Plan C');
INSERT INTO insurance VALUES(4,'Plan D');

select * from insurance;
select * from patient;

-- Step 3: Query to retireve names of all patients that currently have insurance, 
--         as well as the name of their current insurance plan

SELECT patient_first, patient_last, insurance_name
  FROM patient JOIN insurance
    ON patient.insurance_ID = insurance.insurance_ID
	where patient.insurance_ID IS NOT NULL;


-- SATISFYING USE CASE 3

-- Requirement: A patient phones a physician’s administrative assistant asking for an appointment, 
-- and the administrative assistant decides to add the patient to the waiting list so 
-- that the patient will be the next one to be scheduled for a canceled appointment. 
-- Develop a parameterized stored procedure that accomplishes this, then invoke the 
-- stored procedure for a patient of your choosing. 

-- Step 1: create appointment table with patient_ID, physician_ID, appointment_ID


CREATE TABLE appointment(
appointment_ID DECIMAL(10), 
patient_ID DECIMAL(10) NOT NULL, 
physician_ID DECIMAL(10),
PRIMARY KEY (appointment_ID),
FOREIGN KEY (patient_ID) REFERENCES patient,
FOREIGN KEY (physician_ID) REFERENCES physician,
);


select * from appointment;


-- Step 2: Create waitlist table with waitlist_ID, patient_ID, physician_ID 

CREATE TABLE waitlist(
waitlist_ID DECIMAL(10) IDENTITY(1,1), 
patient_ID DECIMAL(10) NOT NULL, 
physician_ID DECIMAL(10),
PRIMARY KEY (waitlist_ID) ,
);

select * from waitlist;


-- Step 3: Query to add a patient to a waitlist

CREATE PROCEDURE ADD_PATIENT    -- creating procedure with name ADD_PATIENT

   @patient_id_arg DECIMAL,  -- The  patient's ID
   @phy_id_arg DECIMAL,  -- The  doctor's ID.
   @wait_list_id_arg INT,
   @appt_date_arg DATE 
AS -- This "AS" is required by the syntax of stored procedures.
BEGIN
  INSERT INTO waitlist(waitlist_ID,patient_ID,physician_ID,appt_date)
  VALUES(@wait_list_id_arg,@patient_id_arg,@phy_id_arg,@appt_date_arg);
END;

 EXECUTE ADD_PATIENT 1,2,1,'12-12-2016';


 -- Select all tables
  select * from waitlist;
  select * from appointment;
  select * from physician;
  select * from patient;

 -- SATISFYING USE CASE #4

 -- A receptionist requests the first and last names of all physicians that a specific patient 
 -- has never visited. Write a single query that retrieves this information for the receptionist. 

-- INSERTING DATA INTO TABLE APPOINTMENT FOR PATIENT 1'S APPT FOR PHYSICIANS 1 AND 2

	-- Inserting 2 rows into appointment table having columns appointment_ID, patient_ID, physician_ID. waitlist_ID,
	
	INSERT INTO appointment values(1,1,1,'2016-12-12',1);
	INSERT INTO appointment values(2,2,1,'2016-12-12',2);
	select * from appointment;

	 -- Step 1 : APPOINTMENT table has confirmed physician visit info. Refer APPOINTMENT table
     --          Get physician_IDs for the particular patient into a list. Check PHYSICIAN table for
     --          physican IDs NOT in the array. Refer the PHYSICIAN table and display their first and last names
 -- Solution: For patient ID=1, retrieving all physician this patient has never visited.
 -- At this point, patient_ID=1, has only visited physician_ID=1(John Smith). Thus all other physicians should be displayed. 

  select physician_first,physician_last from physician 
  where physician_ID NOT IN (select physician_ID from appointment where patient_ID=1);


  -- SATISFYING USE CASE #5

  -- A patient visits a physician but fails to render copayment at the time of visit, 
  -- necessitating that $30 be added to the balance of that patient. Develop a parameterized stored procedure 
  -- that accomplishes this, then invoke the stored procedure for a patient of your choosing. 

  -- Step 1: Adding balance column of decimal type in patient table
    ALTER  TABLE patient add balance DECIMAL(10);
	UPDATE patient SET balance=0;
	select * from patient;

	-- Step 2: Creating parameterized stored procedure called ADD_BALANCE

	-- Self note : drop procedure ADD_BALANCE
CREATE PROCEDURE ADD_BALANCE        -- Create a new balance
   @patient_id_arg DECIMAL,         -- The patient's ID.
   @balance_arg DECIMAL            -- The patient's balance
AS -- This "AS" is required by the syntax of stored procedures.
BEGIN
  -- Insert the $30 copay to patient's balance
  UPDATE patient set balance=balance+@balance_arg
  WHERE patient_ID=@patient_id_arg;
END;

     -- Step 3 Invoking the stored procedure for patient with patient_ID=1
	  EXECUTE ADD_BALANCE 1,30


	  -- Verifying Patient table for new balance entry for patient_ID=1
	  select * from patient; 
	  



-- SATISFYING USE CASE #6

-- A patient cancels their insurance plan, and the hospital staff 
-- must update the system to reflect this cancelation. Develop a parameterized 
-- stored procedure that accomplishes this, then invoke the stored procedure for a patient of your choosing.

-- Notes: The cancellation of an insurance plan should update INSURANCE_PLAN table and also should 

	-- Step 1: Creating parameterized stored procedure called CANCEL_PLAN
	
CREATE PROCEDURE CANCEL_PLAN       -- Create a new balance
   @patient_id_arg DECIMAL        -- The patient's ID
AS -- This "AS" is required by the syntax of stored procedures.
BEGIN
  UPDATE patient set insurance_ID=NULL
  WHERE patient_ID=@patient_id_arg;
END;

    -- Step 2: Involking the stored procedure for patient ID = 1

	  EXECUTE CANCEL_PLAN 1

	-- Verifying Patient table  for patient_ID=1
	  select * from patient; 


-- SATISFYING USE CASE #7 
-- A receptionist needs to know the names of all physicians that are booked for the next two days. 
-- Being booked means the physicians have no available appointments for either day.


-- Procedure: 
-- 1. Add appointment_date and slot_no columns in Appointment table. slot_no is unique for the columns (appointment_date, physician_ID,slot_no). 
--    Thus,UNIQUE constraint is created for tuple (appointment_date, physician_ID, slot_no) 
-- 2. Add max_capacity in Physician table for storing a daily capacity for each Physician
-- 3. Create SLOT table, maintaining slot_no(PK) and time_slot information. 
-- 4. Count the number of unique (physician_ID, appointment_date) rows for Dec 12 and Dec 13
-- 5. If count=max_capacity for physician_id in PHYSICIAN table, display the physician_name, physician_ID


	 -- ON CREATING APPOINTMENTS, ADDING A NEW ROW IN WAITLIST 
 ALTER table waitlist1 ADD appt_date date;

 ALTER table  waitlist1 MODIFY waitlist_ID int IDENTITY (1,1) PRIMARY KEY



	 -- CREATION OF SLOTS TABLE
	 CREATE TABLE slots(slot_no INT,time_slot varchar(50), PRIMARY KEY(slot_no)); 
	 INSERT INTO slots(slot_no,time_slot) VALUES(1,'9:30a-10:30a');
	 INSERT INTO slots(slot_no,time_slot) VALUES(2,'10:30a-11:30a');
	 INSERT INTO slots(slot_no,time_slot) VALUES(3,'11:30a-12:30p');
	 INSERT INTO slots(slot_no,time_slot) VALUES(4,'1:30p-2:30p');
	 INSERT INTO slots(slot_no,time_slot) VALUES(5,'2:30p-3:30p');
	 select * from slots;

	 -- ALTERING APPOINTMENT TABLE:  ADDING COLUMNS APPT_DATE,SLOT_NO. ADDING UNIQUE CONSTRAINT
	 ALTER table appointment ADD appt_date date;
	 ALTER table appointment ADD slot_no INT REFERENCES slots(slot_no);
	 ALTER TABLE appointment ADD CONSTRAINT uc_slotdetails UNIQUE(physician_ID,appt_date,slot_no);

	 -- ALTERING PHYSICIAN TABLE TO ADD COLUMN MAX_CAPACITY
	 ALTER table physician ADD max_capacity INT;

	 -- SETTING MAX_CAPACITY=5 for physician_IDs 1,3,5,7,9,11,13,15, and capacity = 3 for IDs 2,4,6,8,10,12,14

	 UPDATE physician SET max_capacity=5 WHERE physician_ID IN (1,3,5,7,9,11,13,15);
	 UPDATE physician SET max_capacity=3 WHERE physician_ID IN (2,4,6,8,10,12,14);


-- ADDITIONAL: To make the database more automated, a trigger can be increated to 
-- automatically update the waitlist table each tim an entry into appointment table has been made. 
-- This code is beyond the scope of this project, but has been provided
-- only to explore the possibility for scope expansion.


CREATE TRIGGER update_waitlist_on_appt_insert
ON appointment FOR INSERT
AS 
BEGIN
   
    DECLARE  @patient_ID DECIMAL(10),@physician_ID DECIMAL(10), @appt_date DATE
	SELECT  @patient_ID=patient_ID, @physician_ID=physician_ID, @appt_date=appt_date FROM INSERTED

	INSERT INTO waitlist(patient_ID,physician_ID,appt_date) VALUES (@patient_ID,@physician_ID,@appt_date)
END


	 -- SCENARIO: Physicians 1 and 2 are fully booked for Dec 12 and Dec 13. Physician 3 is partially booked.
	 -- INSERTING the relevant records




-- INSERTING APPOINTMENT ENTRIES INTO APPOINTMENT TABLE



     INSERT INTO appointment(appointment_ID,patient_ID,physician_ID, appt_date, slot_no) VALUES (3,1,1,'12-12-2016',1);
	 INSERT INTO appointment(appointment_ID,patient_ID,physician_ID, appt_date, slot_no) VALUES (4,2,1,'12-12-2016',2);
	 INSERT INTO appointment(appointment_ID,patient_ID,physician_ID, appt_date, slot_no) VALUES (5,5,1,'12-12-2016',3);
	 INSERT INTO appointment(appointment_ID,patient_ID,physician_ID, appt_date, slot_no) VALUES (6,3,1,'12-12-2016',4);
	 INSERT INTO appointment(appointment_ID,patient_ID,physician_ID, appt_date, slot_no) VALUES (7,7,1,'12-12-2016',5);


	 INSERT INTO appointment(appointment_ID,patient_ID,physician_ID,appt_date, slot_no) VALUES (8,2,1,'12-13-2016',1);
	 INSERT INTO appointment(appointment_ID,patient_ID,physician_ID,appt_date, slot_no) VALUES (9,4,1,'12-13-2016',2);
	 INSERT INTO appointment(appointment_ID,patient_ID,physician_ID,appt_date, slot_no) VALUES (10,6,1,'12-13-2016',3);
	 INSERT INTO appointment(appointment_ID,patient_ID,physician_ID,appt_date, slot_no) VALUES (11,8,1,'12-13-2016',4);
	 INSERT INTO appointment(appointment_ID,patient_ID,physician_ID,appt_date, slot_no) VALUES (12,10,1,'12-13-2016',5);
	  -- THUS, Physician 1 fully booked for Dec 13

	 INSERT INTO appointment(appointment_ID,patient_ID,physician_ID,appt_date, slot_no) VALUES (13,3,2,'12-12-2016',1);
	 INSERT INTO appointment(appointment_ID,patient_ID,physician_ID,appt_date, slot_no) VALUES (14,4,2,'12-12-2016',2);
	 INSERT INTO appointment(appointment_ID,patient_ID,physician_ID,appt_date, slot_no) VALUES (15,6,2,'12-12-2016',3);
	
	  -- THUS, Physician 2 fully booked for Dec 12

	  
	 INSERT INTO appointment(appointment_ID,patient_ID,physician_ID,appt_date, slot_no) VALUES (14,1,2,'12-13-2016',1);
	 INSERT INTO appointment(appointment_ID,patient_ID,physician_ID,appt_date, slot_no) VALUES (15,5,2,'12-13-2016',2);
	 INSERT INTO appointment(appointment_ID,patient_ID,physician_ID,appt_date, slot_no) VALUES (16,7,2,'12-13-2016',3);
	
	  -- THUS, Physician 2 fully booked for Dec 13

	 INSERT INTO appointment(appointment_ID,patient_ID,physician_ID,appt_date, slot_no) VALUES (17,5,3,'12-12-2016',1);
	 INSERT INTO appointment(appointment_ID,patient_ID,physician_ID,appt_date, slot_no) VALUES (18,3,3,'12-12-2016',2);
	 INSERT INTO appointment(appointment_ID,patient_ID,physician_ID,appt_date, slot_no) VALUES (19,2,3,'12-12-2016',3);
	  -- THUS, Physician 3 PARTIALLY booked for Dec 12
	 INSERT INTO appointment(appointment_ID,patient_ID,physician_ID,appt_date, slot_no) VALUES (20,5,4,'12-13-2016',3);
	  -- THUS, Physician 4 PARTIALLY booked for Dec 13


	-- FINAL Query to satisfy Use case #7
	-- The query returns John Smith(ID=1) and Mary Berman(ID=2)

	SELECT DISTINCT physician_first, physician_last
    FROM physician S
    INNER JOIN
    (
        SELECT physician_ID, appt_date
        FROM appointment A
        GROUP BY physician_ID, appt_date
        HAVING COUNT(*) = (select max_capacity from physician where a.physician_ID=physician.physician_ID)  
		AND appt_date IN ('12-12-2016','12-13-2016')
    ) T
    ON S.physician_ID=T.physician_ID 


	-- SATISFYING USE CASE #8

	-- Health center management requests the insurance plan with the most patient enrollees, and for that plan, 
	-- its name, required copayment amount, 
	-- and the number of patient enrollees. Write a single query that retrieves this information for the management.

	select * from insurance;
	-- making changes to insurance table using parameterized stored procedure -- 
ALTER TABLE insurance ADD copay_amt DECIMAL(10);

CREATE PROCEDURE ADD_COPAY       -- Create a new procedure
   @insur_id_arg DECIMAL,        -- The insurance ID
   @copay_arg VARCHAR(30)        -- Thecopay amount
 
AS -- This "AS" is required by the syntax of stored procedures.
BEGIN
  -- update the row 
  UPDATE insurance set copay_amt=@copay_arg where insurance_ID=@insur_id_arg;
END;


EXECUTE ADD_COPAY 1,20
EXECUTE ADD_COPAY 2,10
EXECUTE ADD_COPAY 3,30
EXECUTE ADD_COPAY 4,40
	select * from insurance;


-- FINAL Query for Use case #8
SELECT insurance_name, copay_amt, number_of_enrollees 
FROM insurance I
INNER JOIN
(
 select top 1 insurance_ID, count(*) AS number_of_enrollees from patient
 group by insurance_ID
 order by count(*) desc
 ) T 
 ON I.insurance_ID=T.insurance_ID;



-- SATISFYING USE CASE #9

-- Health center management requests the names of all patients, and for each patient, 
-- the names of the physicians that they visited more than once, along with the number 
-- of visits to each of these physicians. If a patient has not visited any physicians, 
-- or did not visit any physicians more than once, management does not want to see them in the list. 
-- Write a single query that retrieves this information for the management.

-- By executing the query below which displays the appointments sorted by patient_ID, 
-- it can be seen that patient_ID=2 made multiple visits to physician_ID=1
select * from appointment ORDER BY patient_ID ASC;


-- FINAL QUERY
select P.patient_ID, patient_first,patient_last, T.physician_ID,physician_first, physician_last, visit_count 
from patient P  
 INNER JOIN
   (
      SELECT physician_ID , patient_ID, count(*) AS visit_count
        FROM appointment A
        GROUP BY physician_ID, patient_ID
        HAVING COUNT(*)>1  ) T
    ON P.patient_ID=T.patient_ID 
 JOIN physician R ON R.physician_Id = T.physician_ID 


 -- SATISFING USE CASE #10

 -- Health center management requests the names of all physicians, and for each physician, 
 -- the number of different patients that visited the physician. 
 -- Management would like to this to be ordered from the highest number of different visitors to the lowest number. 
 -- Multiple visits to the same physician by the same patient only count as one unique visit for purposes of this request. 
 -- Management is interested in the number of different visitors, but not whether the same patient visited the 
 -- same physician multiple times. Write a single query that retrieves this information for the management.


 -- Physician and Appointment tables are joined, to retrieve distinct visits to physicians

select  T.physician_ID,physician_first, physician_last, visit_count 
from physician P  
 INNER JOIN
   (
      SELECT physician_ID , count(distinct patient_ID) AS visit_count
        FROM appointment A
        GROUP BY physician_ID) T
    ON P.physician_ID=T.physician_ID 
	ORDER BY visit_count DESC




 -- INDEXES 

 -- To explain the strategic creation of an index, the Bill table is created below. 

 create table bill(bill_no INT PRIMARY KEY, appt_ID DECIMAL(10), FOREIGN KEY(appt_ID) REFERENCES appointment);
 

-- 1 Composite index
CREATE INDEX patient_name_index
on patient (patient_first, patient_last);

CREATE INDEX bill_lookup_index
on bill(bill_no);





	--  END OF HEALTHCARE DATABASE PROJECT -- 