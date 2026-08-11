-- ============================================================
-- Diabetes Healthcare Decision Support System
-- File: 02_dimension_tables.sql
-- Purpose: Create dimension tables for the data warehouse
-- PostgreSQL
-- ============================================================


-- ============================================================
-- 1. PATIENT DIMENSION
-- ============================================================

CREATE TABLE dim_patient (
    patient_key SERIAL PRIMARY KEY,
    patient_nbr BIGINT UNIQUE,
    gender VARCHAR(20),
    race VARCHAR(50),
    age_group VARCHAR(20),
    weight VARCHAR(20)
);

INSERT INTO dim_patient (
    patient_nbr,
    gender,
    race,
    age_group,
    weight
)
SELECT DISTINCT ON (patient_nbr)
    patient_nbr,
    gender,
    race,
    age,
    NULLIF(weight, '?')
FROM stg_hospital
ORDER BY patient_nbr;

-- Validation
SELECT COUNT(*) AS total_patients
FROM dim_patient;

SELECT patient_nbr, COUNT(*)
FROM dim_patient
GROUP BY patient_nbr
HAVING COUNT(*) > 1;

SELECT gender, COUNT(*) AS total_patients
FROM dim_patient
GROUP BY gender;

SELECT race, COUNT(*) AS total_patients
FROM dim_patient
GROUP BY race
ORDER BY total_patients DESC;

SELECT age_group, COUNT(*) AS total_patients
FROM dim_patient
GROUP BY age_group
ORDER BY age_group;


-- ============================================================
-- 2. HOSPITAL DIMENSION
-- ============================================================

CREATE TABLE dim_hospital (
    hospital_key SERIAL PRIMARY KEY,
    admission_type_id INT,
    discharge_disposition_id INT,
    admission_source_id INT,
    payer_code VARCHAR(20),
    medical_specialty VARCHAR(100)
);

INSERT INTO dim_hospital (
    admission_type_id,
    discharge_disposition_id,
    admission_source_id,
    payer_code,
    medical_specialty
)
SELECT DISTINCT
    admission_type_id,
    discharge_disposition_id,
    admission_source_id,
    NULLIF(payer_code, '?'),
    NULLIF(medical_specialty, '?')
FROM stg_hospital;

-- Validation
SELECT COUNT(*) AS hospital_dimension_records
FROM dim_hospital;

SELECT *
FROM dim_hospital
LIMIT 10;


-- ============================================================
-- 3. MEDICATION DIMENSION
-- ============================================================

CREATE TABLE dim_medication (
    medication_key SERIAL PRIMARY KEY,
    insulin VARCHAR(20),
    diabetesmed VARCHAR(10),
    medication_change VARCHAR(10),
    metformin VARCHAR(20),
    glipizide VARCHAR(20),
    glyburide VARCHAR(20),
    pioglitazone VARCHAR(20),
    rosiglitazone VARCHAR(20)
);

INSERT INTO dim_medication (
    insulin,
    diabetesmed,
    medication_change,
    metformin,
    glipizide,
    glyburide,
    pioglitazone,
    rosiglitazone
)
SELECT DISTINCT
    NULLIF(insulin, '?'),
    NULLIF(diabetesmed, '?'),
    NULLIF(change, '?'),
    NULLIF(metformin, '?'),
    NULLIF(glipizide, '?'),
    NULLIF(glyburide, '?'),
    NULLIF(pioglitazone, '?'),
    NULLIF(rosiglitazone, '?')
FROM stg_hospital;

-- Validation
SELECT COUNT(*) AS medication_dimension_records
FROM dim_medication;

SELECT *
FROM dim_medication
LIMIT 10;


-- ============================================================
-- 4. HEALTHCARE ACCESS DIMENSION
-- ============================================================

CREATE TABLE dim_healthcare_access (
    access_key SERIAL PRIMARY KEY,
    admission_source_id INT,
    payer_code VARCHAR(50),
    medical_specialty VARCHAR(100)
);

INSERT INTO dim_healthcare_access (
    admission_source_id,
    payer_code,
    medical_specialty
)
SELECT DISTINCT
    admission_source_id,
    CASE
        WHEN payer_code = '?' THEN 'Unknown'
        ELSE payer_code
    END AS payer_code,
    CASE
        WHEN medical_specialty = '?' THEN 'Unknown'
        ELSE medical_specialty
    END AS medical_specialty
FROM stg_hospital;

-- Validation
SELECT COUNT(*) AS healthcare_access_records
FROM dim_healthcare_access;

SELECT *
FROM dim_healthcare_access
LIMIT 10;


-- ============================================================
-- 5. HEALTH PROFILE DIMENSION
-- ============================================================

CREATE TABLE dim_health_profile (
    health_key SERIAL PRIMARY KEY,
    bmi INT,
    highbp BOOLEAN,
    highchol BOOLEAN,
    smoker BOOLEAN,
    stroke BOOLEAN,
    heart_disease BOOLEAN,
    physical_activity BOOLEAN,
    fruits BOOLEAN,
    veggies BOOLEAN,
    alcohol BOOLEAN,
    general_health INT
);

INSERT INTO dim_health_profile (
    bmi,
    highbp,
    highchol,
    smoker,
    stroke,
    heart_disease,
    physical_activity,
    fruits,
    veggies,
    alcohol,
    general_health
)
SELECT DISTINCT
    bmi,
    highbp = 1,
    highchol = 1,
    smoker = 1,
    stroke = 1,
    heartdiseaseorattack = 1,
    physactivity = 1,
    fruits = 1,
    veggies = 1,
    hvyalcoholconsump = 1,
    genhlth
FROM stg_brfss;

-- Validation
SELECT COUNT(*) AS health_profile_records
FROM dim_health_profile;

SELECT *
FROM dim_health_profile
LIMIT 10;


-- ============================================================
-- 6. BMI CATEGORY
-- ============================================================

ALTER TABLE dim_health_profile
ADD COLUMN IF NOT EXISTS bmi_category VARCHAR(20);

UPDATE dim_health_profile
SET bmi_category =
    CASE
        WHEN bmi < 18.5 THEN 'Underweight'
        WHEN bmi >= 18.5 AND bmi < 25 THEN 'Normal'
        WHEN bmi >= 25 AND bmi < 30 THEN 'Overweight'
        ELSE 'Obese'
    END;

ALTER TABLE dim_health_profile
ADD COLUMN IF NOT EXISTS bmi_sort INTEGER;

UPDATE dim_health_profile
SET bmi_sort =
    CASE
        WHEN bmi_category = 'Underweight' THEN 1
        WHEN bmi_category = 'Normal' THEN 2
        WHEN bmi_category = 'Overweight' THEN 3
        WHEN bmi_category = 'Obese' THEN 4
    END;

-- Validate BMI categories
SELECT
    bmi_category,
    COUNT(*) AS total_people
FROM dim_health_profile
GROUP BY bmi_category
ORDER BY bmi_sort;


-- ============================================================
-- 7. RISK FACTOR DIMENSION
-- ============================================================

CREATE TABLE dim_risk_factor (
    risk_factor_key SERIAL PRIMARY KEY,
    risk_factor_name VARCHAR(100) NOT NULL
);

INSERT INTO dim_risk_factor (risk_factor_name)
VALUES
    ('High Blood Pressure'),
    ('High Cholesterol'),
    ('Smoking'),
    ('Stroke'),
    ('Heart Disease'),
    ('Physical Inactivity'),
    ('Poor Fruit Intake'),
    ('Poor Vegetable Intake'),
    ('Alcohol Consumption');

-- Validation
SELECT *
FROM dim_risk_factor;

