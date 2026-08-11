-- ============================================================
-- Diabetes Healthcare Decision Support System
-- File: 03_fact_tables.sql
-- Purpose: Create fact tables for hospital care and prevention
-- PostgreSQL
-- ============================================================


-- ============================================================
-- 1. HOSPITAL VISIT FACT TABLE
-- ============================================================

CREATE TABLE fact_hospital_visit (
    visit_key SERIAL PRIMARY KEY,
    encounter_id BIGINT UNIQUE,
    patient_key INT REFERENCES dim_patient(patient_key),
    hospital_key INT REFERENCES dim_hospital(hospital_key),
    medication_key INT REFERENCES dim_medication(medication_key),
    access_key INT REFERENCES dim_healthcare_access(access_key),

    time_in_hospital INT,
    num_lab_procedures INT,
    num_procedures INT,
    num_medications INT,

    number_outpatient INT,
    number_emergency INT,
    number_inpatient INT,
    number_diagnoses INT,

    diag_1 VARCHAR(20),
    diag_2 VARCHAR(20),
    diag_3 VARCHAR(20),

    a1cresult VARCHAR(20),
    max_glu_serum VARCHAR(20),

    insulin VARCHAR(50),
    diabetesmed VARCHAR(50),
    medication_change VARCHAR(50),

    readmitted VARCHAR(10),

    priority_score INTEGER,
    priority_category VARCHAR(20),

    readmission_priority_score INTEGER,

    care_quality_score INTEGER,
    care_quality_category VARCHAR(20)
);


-- ============================================================
-- LOAD HOSPITAL VISITS
-- ============================================================

INSERT INTO fact_hospital_visit (
    encounter_id,
    patient_key,
    time_in_hospital,
    num_lab_procedures,
    num_procedures,
    num_medications,
    number_outpatient,
    number_emergency,
    number_inpatient,
    number_diagnoses,
    diag_1,
    diag_2,
    diag_3,
    a1cresult,
    max_glu_serum,
    insulin,
    diabetesmed,
    medication_change,
    readmitted
)
SELECT
    sh.encounter_id,
    dp.patient_key,
    sh.time_in_hospital,
    sh.num_lab_procedures,
    sh.num_procedures,
    sh.num_medications,
    sh.number_outpatient,
    sh.number_emergency,
    sh.number_inpatient,
    sh.number_diagnoses,
    sh.diag_1,
    sh.diag_2,
    sh.diag_3,
    NULLIF(sh.a1cresult, '?'),
    NULLIF(sh.max_glu_serum, '?'),
    NULLIF(sh.insulin, '?'),
    NULLIF(sh.diabetesmed, '?'),
    NULLIF(sh.change, '?'),
    sh.readmitted
FROM stg_hospital sh
LEFT JOIN dim_patient dp
    ON sh.patient_nbr = dp.patient_nbr;


-- ============================================================
-- LINK HOSPITAL DIMENSION
-- ============================================================

UPDATE fact_hospital_visit fv
SET hospital_key = dh.hospital_key
FROM stg_hospital sh
JOIN dim_hospital dh
    ON sh.admission_type_id = dh.admission_type_id
    AND sh.discharge_disposition_id = dh.discharge_disposition_id
    AND sh.admission_source_id = dh.admission_source_id
WHERE fv.encounter_id = sh.encounter_id;


-- ============================================================
-- LINK MEDICATION DIMENSION
-- ============================================================

UPDATE fact_hospital_visit fv
SET medication_key = dm.medication_key
FROM stg_hospital sh
JOIN dim_medication dm
    ON COALESCE(sh.insulin, '') = COALESCE(dm.insulin, '')
    AND COALESCE(sh.diabetesmed, '') = COALESCE(dm.diabetesmed, '')
    AND COALESCE(sh.change, '') = COALESCE(dm.medication_change, '')
WHERE fv.encounter_id = sh.encounter_id;


-- ============================================================
-- LINK HEALTHCARE ACCESS DIMENSION
-- ============================================================

UPDATE stg_hospital
SET payer_code = 'Unknown'
WHERE payer_code = '?';

UPDATE stg_hospital
SET medical_specialty = 'Unknown'
WHERE medical_specialty = '?';

UPDATE fact_hospital_visit fv
SET access_key = ha.access_key
FROM stg_hospital sh
JOIN dim_healthcare_access ha
    ON sh.admission_source_id = ha.admission_source_id
    AND sh.payer_code = ha.payer_code
    AND sh.medical_specialty = ha.medical_specialty
WHERE fv.encounter_id = sh.encounter_id;


-- ============================================================
-- 2. PREVENTION FACT TABLE
-- ============================================================

CREATE TABLE fact_prevention (
    prevention_key SERIAL PRIMARY KEY,
    health_key INT REFERENCES dim_health_profile(health_key),
    diabetes_binary BOOLEAN,
    mental_health_days INT,
    physical_health_days INT,
    education INT,
    income INT
);


-- ============================================================
-- LOAD PREVENTION DATA
-- ============================================================

INSERT INTO fact_prevention (
    health_key,
    diabetes_binary,
    mental_health_days,
    physical_health_days,
    education,
    income
)
SELECT
    dh.health_key,
    sb.diabetes_binary = 1,
    sb.menthlth,
    sb.physhlth,
    sb.education,
    sb.income
FROM stg_brfss sb
JOIN dim_health_profile dh
    ON sb.bmi = dh.bmi
    AND (sb.highbp = 1) = dh.highbp
    AND (sb.highchol = 1) = dh.highchol
    AND (sb.smoker = 1) = dh.smoker
    AND (sb.stroke = 1) = dh.stroke
    AND (sb.heartdiseaseorattack = 1) = dh.heart_disease
    AND (sb.physactivity = 1) = dh.physical_activity
    AND (sb.fruits = 1) = dh.fruits
    AND (sb.veggies = 1) = dh.veggies
    AND (sb.hvyalcoholconsump = 1) = dh.alcohol
    AND sb.genhlth = dh.general_health;


-- ============================================================
-- 3. RISK FACTOR FACT TABLE
-- ============================================================

CREATE TABLE fact_risk_factor (
    risk_record_key SERIAL PRIMARY KEY,
    health_key INT NOT NULL,
    risk_factor_key INT NOT NULL,
    risk_present BOOLEAN,

    CONSTRAINT fk_health_profile
        FOREIGN KEY (health_key)
        REFERENCES dim_health_profile(health_key),

    CONSTRAINT fk_risk_factor
        FOREIGN KEY (risk_factor_key)
        REFERENCES dim_risk_factor(risk_factor_key)
);


-- ============================================================
-- LOAD RISK FACTORS
-- ============================================================

-- High Blood Pressure
INSERT INTO fact_risk_factor
(health_key, risk_factor_key, risk_present)
SELECT
    health_key,
    1,
    highbp
FROM dim_health_profile;


-- High Cholesterol
INSERT INTO fact_risk_factor
(health_key, risk_factor_key, risk_present)
SELECT
    health_key,
    2,
    highchol
FROM dim_health_profile;


-- Smoking
INSERT INTO fact_risk_factor
(health_key, risk_factor_key, risk_present)
SELECT
    health_key,
    3,
    smoker
FROM dim_health_profile;


-- Stroke
INSERT INTO fact_risk_factor
(health_key, risk_factor_key, risk_present)
SELECT
    health_key,
    4,
    stroke
FROM dim_health_profile;


-- Heart Disease
INSERT INTO fact_risk_factor
(health_key, risk_factor_key, risk_present)
SELECT
    health_key,
    5,
    heart_disease
FROM dim_health_profile;


-- Physical Inactivity
INSERT INTO fact_risk_factor
(health_key, risk_factor_key, risk_present)
SELECT
    health_key,
    6,
    NOT physical_activity
FROM dim_health_profile;


-- Poor Fruit Intake
INSERT INTO fact_risk_factor
(health_key, risk_factor_key, risk_present)
SELECT
    health_key,
    7,
    NOT fruits
FROM dim_health_profile;


-- Poor Vegetable Intake
INSERT INTO fact_risk_factor
(health_key, risk_factor_key, risk_present)
SELECT
    health_key,
    8,
    NOT veggies
FROM dim_health_profile;


-- Alcohol Consumption
INSERT INTO fact_risk_factor
(health_key, risk_factor_key, risk_present)
SELECT
    health_key,
    9,
    alcohol
FROM dim_health_profile;


-- ============================================================
-- FACT TABLE VALIDATION
-- ============================================================

SELECT
    'fact_hospital_visit' AS table_name,
    COUNT(*) AS records
FROM fact_hospital_visit

UNION ALL

SELECT
    'fact_prevention',
    COUNT(*)
FROM fact_prevention

UNION ALL

SELECT
    'fact_risk_factor',
    COUNT(*)
FROM fact_risk_factor;


-- Hospital visit uniqueness
SELECT
    COUNT(*) AS total_visits,
    COUNT(DISTINCT encounter_id) AS unique_encounters,
    COUNT(DISTINCT patient_key) AS unique_patients
FROM fact_hospital_visit;


-- Risk factor records
SELECT
    rf.risk_factor_name,
    COUNT(*) AS total_records,
    COUNT(*) FILTER (WHERE f.risk_present = TRUE) AS risk_cases
FROM fact_risk_factor f
JOIN dim_risk_factor rf
    ON f.risk_factor_key = rf.risk_factor_key
GROUP BY rf.risk_factor_name
ORDER BY risk_cases DESC;

