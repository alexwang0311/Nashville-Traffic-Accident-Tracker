DROP DATABASE IF EXISTS project2;
CREATE DATABASE project2;
USE project2;

DROP table IF EXISTS Raw_Table;
CREATE TABLE IF NOT EXISTS Raw_Table(
Accident_Number VARCHAR(255),
Accident_Date VARCHAR(255),
Accident_Time VARCHAR(255),
Num_Motor_Vehicles VARCHAR(255),
Num_Injuries VARCHAR(255),
Num_Fatalities VARCHAR(255),
Property_Damage VARCHAR(255),
Hit_and_Run VARCHAR(255),	
Reporting_Officer VARCHAR(255),
Collision_Type_Code VARCHAR(255),
Collision_Type_Desc VARCHAR(255),
Weather_Code VARCHAR(255),
Weather_Desc VARCHAR(255),
Illumination_Code VARCHAR(255),
Illumination_Desc VARCHAR(255),
Harmful_Code VARCHAR(255),
Harmful_Code_Desc VARCHAR(255),
Street_Address VARCHAR(255),
City VARCHAR(255),
State VARCHAR(255),
ZIP VARCHAR(255),
RPA VARCHAR(255), 
Precinct VARCHAR(255),
Latitude VARCHAR(255),
Longitude VARCHAR(255),
Mapped_Location VARCHAR(255)
);




LOAD DATA INFILE 'H:\\CS 3265\\Project 2\\Database_Project\\Database\\Traffic_Accidents__2019_2.csv'
INTO TABLE Raw_Table
FIELDS TERMINATED BY '$'
LINES TERMINATED BY '\n';

ALTER TABLE raw_table
ADD my_ID BIGINT AUTO_INCREMENT PRIMARY KEY;

-- Remove invalid records which do not have a date and time.
DELETE FROM raw_table
WHERE Accident_Time = '';

DROP table IF EXISTS accident_num_matching;
CREATE TABLE IF NOT EXISTS accident_num_matching(
accident_id BIGINT,
accident_ref_num VARCHAR(255),
PRIMARY KEY (accident_id),
CONSTRAINT fk_accident_id
FOREIGN KEY (accident_id)
REFERENCES raw_table(my_ID)
ON UPDATE CASCADE
ON DELETE CASCADE
);

DROP table IF EXISTS accident_info;
CREATE TABLE IF NOT EXISTS accident_info(
accident_id BIGINT,
accident_date DATE NOT NULL,
accident_time TIME NOT NULL,
hit_and_run VARCHAR(7),
report_officer VARCHAR(255),
PRIMARY KEY (accident_id),
CONSTRAINT fk_accident_id
FOREIGN KEY (accident_id)
REFERENCES raw_table(my_ID)
ON UPDATE CASCADE
ON DELETE CASCADE
);

DROP table IF EXISTS damage_info;
CREATE TABLE IF NOT EXISTS damage_info(
accident_id BIGINT,
num_vehicles INT,
num_injuries INT,
num_fatalities INT,
property_damage VARCHAR(2),
PRIMARY KEY (accident_id),
CONSTRAINT fk_accident_id
FOREIGN KEY (accident_id)
REFERENCES raw_table(my_ID)
ON UPDATE CASCADE
ON DELETE CASCADE
);

DROP table IF EXISTS collision_info;
CREATE TABLE IF NOT EXISTS collision_info(
accident_id BIGINT,
collision_cd VARCHAR(10),
collision_desc VARCHAR(255),
PRIMARY KEY (accident_id),
CONSTRAINT fk_accident_id
FOREIGN KEY (accident_id)
REFERENCES raw_table(my_ID)
ON UPDATE CASCADE
ON DELETE CASCADE
);

DROP table IF EXISTS illumination_info;
CREATE TABLE IF NOT EXISTS illumination_info(
accident_id BIGINT,
illumination_cd VARCHAR(10),
illumination_desc VARCHAR(255),
PRIMARY KEY (accident_id),
CONSTRAINT fk_accident_id
FOREIGN KEY (accident_id)
REFERENCES raw_table(my_ID)
ON UPDATE CASCADE
ON DELETE CASCADE
);


DROP table IF EXISTS harm_info;
CREATE TABLE IF NOT EXISTS harm_info(
accident_id BIGINT,
harm_cd VARCHAR(255),
harm_desc VARCHAR(255),
PRIMARY KEY (accident_id),
CONSTRAINT fk_accident_id
FOREIGN KEY (accident_id)
REFERENCES raw_table(my_ID)
ON UPDATE CASCADE
ON DELETE CASCADE
);

DROP table IF EXISTS location_info;
CREATE TABLE IF NOT EXISTS location_info(
accident_id BIGINT,
street_addr VARCHAR(255),
city VARCHAR(255),
state VARCHAR(255),
zip VARCHAR(6),
RPA VARCHAR(6),
Precinct VARCHAR(255),
latitude FLOAT(6,4),
longitude FLOAT(7,4),
mapped_location VARCHAR(255),
PRIMARY KEY (accident_id),
CONSTRAINT fk_accident_id
FOREIGN KEY (accident_id)
REFERENCES raw_table(my_ID)
ON UPDATE CASCADE
ON DELETE CASCADE
);


INSERT INTO accident_num_matching
SELECT DISTINCT my_ID, Accident_number
FROM raw_table;

INSERT INTO accident_info
SELECT DISTINCT my_ID, Accident_Date, Accident_Time, Hit_and_Run, Reporting_Officer
FROM raw_table;

INSERT INTO damage_info
SELECT DISTINCT my_ID, Num_Motor_Vehicles, Num_Injuries, Num_Fatalities, Property_Damage
FROM raw_table WHERE Num_Motor_Vehicles != '' AND Num_Injuries != '' AND Num_Fatalities != '' AND Num_Motor_Vehicles != '0.5';

INSERT INTO collision_info
SELECT DISTINCT my_ID, Collision_Type_Code, Collision_Type_Desc
FROM raw_table;

INSERT INTO illumination_info
SELECT DISTINCT my_ID, Illumination_Code, Illumination_Desc
FROM raw_table;

INSERT INTO harm_info
SELECT DISTINCT my_ID, Harmful_Code, Harmful_Code_Desc
FROM raw_table;

INSERT INTO location_info
SELECT DISTINCT my_ID, Street_Address, City, State, ZIP, RPA, Precinct, Latitude, Longitude, Mapped_Location
FROM raw_table WHERE Latitude != '' AND Longitude != '';

