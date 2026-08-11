-- ============================================================
-- Diabetes Healthcare Decision Support System
-- File: 01_staging_tables.sql
-- Purpose: Create staging tables for raw diabetes datasets
-- PostgreSQL
-- ============================================================

-- ============================================================
-- 1. BRFSS STAGING TABLE
-- ============================================================

CREATE TABLE stg_brfss (
    diabetes_binary INT,
    highbp INT,
    highchol INT,
    cholcheck INT,
    bmi INT,
    smoker INT,
    stroke INT,
    heartdiseaseorattack INT,
    physactivity INT,
    fruits INT,
    veggies INT,
    hvyalcoholconsump INT,
    anyhealthcare INT,
    nodocbccost INT,
    genhlth INT,
    menthlth INT,
    physhlth INT,
    diffwalk INT,
    sex INT,
    age INT,
    education INT,
    income INT
);

-- Dataset import
-- The original dataset was loaded locally into PostgreSQL.
-- Local file paths are intentionally excluded from this portfolio.

-- Validate staging table
SELECT *
FROM stg_brfss;


-- ============================================================
-- 2. HOSPITAL STAGING TABLE
-- ============================================================

CREATE TABLE stg_hospital (
    encounter_id BIGINT,
    patient_nbr BIGINT,
    race VARCHAR(50),
    gender VARCHAR(20),
    age VARCHAR(20),
    weight VARCHAR(20),
    admission_type_id INT,
    discharge_disposition_id INT,
    admission_source_id INT,
    time_in_hospital INT,
    payer_code VARCHAR(20),
    medical_specialty VARCHAR(100),
    num_lab_procedures INT,
    num_procedures INT,
    num_medications INT,
    number_outpatient INT,
    number_emergency INT,
    number_inpatient INT,
    diag_1 VARCHAR(20),
    diag_2 VARCHAR(20),
    diag_3 VARCHAR(20),
    number_diagnoses INT,
    max_glu_serum VARCHAR(20),
    a1cresult VARCHAR(20),
    metformin VARCHAR(20),
    repaglinide VARCHAR(20),
    nateglinide VARCHAR(20),
    chlorpropamide VARCHAR(20),
    glimepiride VARCHAR(20),
    acetohexamide VARCHAR(20),
    glipizide VARCHAR(20),
    glyburide VARCHAR(20),
    tolbutamide VARCHAR(20),
    pioglitazone VARCHAR(20),
    rosiglitazone VARCHAR(20),
    acarbose VARCHAR(20),
    miglitol VARCHAR(20),
    troglitazone VARCHAR(20),
    tolazamide VARCHAR(20),
    examide VARCHAR(20),
    citoglipton VARCHAR(20),
    insulin VARCHAR(20),
    glyburide_metformin VARCHAR(20),
    glipizide_metformin VARCHAR(20),
    glimepiride_pioglitazone VARCHAR(20),
    metformin_rosiglitazone VARCHAR(20),
    metformin_pioglitazone VARCHAR(20),
    change VARCHAR(10),
    diabetesmed VARCHAR(10),
    readmitted VARCHAR(10)
);

-- Dataset import
-- The original hospital dataset was loaded locally into PostgreSQL.
-- Local file paths are intentionally excluded from this portfolio.

-- Validate staging table
SELECT *
FROM stg_hospital;
