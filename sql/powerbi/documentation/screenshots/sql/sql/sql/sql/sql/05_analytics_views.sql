-- ============================================================
-- DIABETES HEALTHCARE ANALYTICS
-- 05 - ANALYTICS VIEWS
-- PostgreSQL
-- ============================================================


-- ============================================================
-- 1. HEALTHCARE ACCESS ANALYSIS
-- ============================================================

CREATE VIEW vw_healthcare_access_analysis AS
SELECT
    ha.payer_code,
    ha.medical_specialty,
    ha.admission_source_id,
    COUNT(*) AS total_visits,
    COUNT(DISTINCT fh.patient_key) AS unique_patients,
    ROUND(AVG(fh.time_in_hospital), 2) AS average_stay,
    ROUND(AVG(fh.num_medications), 2) AS average_medications,
    ROUND(
        COUNT(*) FILTER (WHERE fh.readmitted <> 'NO') * 100.0
        / COUNT(*),
        2
    ) AS readmission_rate_percent
FROM fact_hospital_visit fh
JOIN stg_hospital sh
    ON fh.encounter_id = sh.encounter_id
JOIN dim_healthcare_access ha
    ON sh.admission_source_id = ha.admission_source_id
    AND sh.payer_code = ha.payer_code
    AND sh.medical_specialty = ha.medical_specialty
GROUP BY
    ha.payer_code,
    ha.medical_specialty,
    ha.admission_source_id;


-- ============================================================
-- 2. PREVENTION KPIs
-- ============================================================

CREATE VIEW vw_prevention_kpis AS
SELECT
    COUNT(*) AS total_population_records,

    COUNT(*) FILTER (
        WHERE diabetes_binary = TRUE
    ) AS diabetes_cases,

    ROUND(
        COUNT(*) FILTER (
            WHERE diabetes_binary = TRUE
        ) * 100.0 / COUNT(*),
        2
    ) AS diabetes_prevalence_percent,

    ROUND(
        AVG(mental_health_days),
        2
    ) AS average_mental_health_days,

    ROUND(
        AVG(physical_health_days),
        2
    ) AS average_physical_health_days

FROM fact_prevention;


-- ============================================================
-- 3. READMISSION ANALYSIS
-- ============================================================

CREATE VIEW vw_readmission_analysis AS
SELECT
    readmitted,
    COUNT(*) AS total_visits,
    COUNT(DISTINCT patient_key) AS unique_patients,
    ROUND(AVG(time_in_hospital), 2) AS average_stay,
    ROUND(AVG(num_medications), 2) AS average_medications,
    ROUND(AVG(num_lab_procedures), 2) AS average_lab_procedures,
    ROUND(AVG(number_diagnoses), 2) AS average_diagnoses
FROM fact_hospital_visit
GROUP BY readmitted
ORDER BY total_visits DESC;


-- ============================================================
-- 4. PATIENT DEMOGRAPHICS
-- ============================================================

CREATE VIEW vw_patient_demographics AS
SELECT
    dp.age_group,
    dp.gender,
    CASE
        WHEN dp.race = '?' THEN 'Unknown'
        ELSE dp.race
    END AS race,

    COUNT(*) AS total_visits,

    COUNT(DISTINCT dp.patient_key) AS unique_patients,

    ROUND(
        AVG(fh.time_in_hospital),
        2
    ) AS average_stay,

    ROUND(
        AVG(fh.num_medications),
        2
    ) AS average_medications,

    ROUND(
        COUNT(*) FILTER (
            WHERE fh.readmitted <> 'NO'
        ) * 100.0 / COUNT(*),
        2
    ) AS readmission_rate_percent

FROM fact_hospital_visit fh
JOIN dim_patient dp
    ON fh.patient_key = dp.patient_key

GROUP BY
    dp.age_group,
    dp.gender,
    CASE
        WHEN dp.race = '?' THEN 'Unknown'
        ELSE dp.race
    END;


-- ============================================================
-- 5. DIABETES CARE QUALITY
-- ============================================================

CREATE VIEW vw_diabetes_care_quality AS
SELECT
    a1cresult,
    insulin,
    diabetesmed,
    medication_change,

    COUNT(*) AS total_visits,

    ROUND(
        AVG(num_lab_procedures),
        2
    ) AS average_lab_procedures,

    ROUND(
        AVG(num_medications),
        2
    ) AS average_medications,

    ROUND(
        COUNT(*) FILTER (
            WHERE readmitted <> 'NO'
        ) * 100.0 / COUNT(*),
        2
    ) AS readmission_rate_percent

FROM fact_hospital_visit

GROUP BY
    a1cresult,
    insulin,
    diabetesmed,
    medication_change;


-- ============================================================
-- 6. DIABETES RISK FACTORS
-- ============================================================

CREATE VIEW vw_diabetes_risk_factors AS
SELECT
    dh.highbp,
    dh.highchol,
    dh.smoker,
    dh.heart_disease,
    dh.physical_activity,

    COUNT(*) AS total_records,

    COUNT(*) FILTER (
        WHERE fp.diabetes_binary = TRUE
    ) AS diabetes_cases,

    ROUND(
        COUNT(*) FILTER (
            WHERE fp.diabetes_binary = TRUE
        ) * 100.0 / COUNT(*),
        2
    ) AS diabetes_rate_percent

FROM fact_prevention fp

JOIN dim_health_profile dh
    ON fp.health_key = dh.health_key

GROUP BY
    dh.highbp,
    dh.highchol,
    dh.smoker,
    dh.heart_disease,
    dh.physical_activity;


-- ============================================================
-- 7. COMMUNITY DIABETES RISK INDEX
-- ============================================================

CREATE VIEW vw_diabetes_risk_index AS
SELECT
    health_key,
    bmi,
    highbp,
    highchol,
    smoker,
    stroke,
    heart_disease,
    physical_activity,
    general_health,

    (
        CASE WHEN bmi >= 30 THEN 1 ELSE 0 END
        +
        CASE WHEN highbp = TRUE THEN 1 ELSE 0 END
        +
        CASE WHEN highchol = TRUE THEN 1 ELSE 0 END
        +
        CASE WHEN smoker = TRUE THEN 1 ELSE 0 END
        +
        CASE WHEN stroke = TRUE THEN 1 ELSE 0 END
        +
        CASE WHEN heart_disease = TRUE THEN 1 ELSE 0 END
        +
        CASE WHEN physical_activity = FALSE THEN 1 ELSE 0 END
        +
        CASE WHEN general_health >= 4 THEN 1 ELSE 0 END
    ) AS diabetes_risk_score

FROM dim_health_profile;


-- ============================================================
-- 8. DIABETES RISK CATEGORIES
-- ============================================================

CREATE VIEW vw_diabetes_risk_category AS
SELECT
    health_key,
    diabetes_risk_score,

    CASE
        WHEN diabetes_risk_score <= 2
            THEN 'Low Risk'

        WHEN diabetes_risk_score BETWEEN 3 AND 5
            THEN 'Medium Risk'

        WHEN diabetes_risk_score >= 6
            THEN 'High Risk'
    END AS risk_category

FROM vw_diabetes_risk_index;


-- ============================================================
-- 9. HOSPITAL READMISSION PRIORITY SCORE
-- ============================================================

CREATE VIEW vw_readmission_priority_score AS
SELECT
    encounter_id,
    patient_key,
    time_in_hospital,
    num_medications,
    number_diagnoses,
    number_inpatient,
    number_emergency,
    number_outpatient,
    readmitted,

    (
        CASE
            WHEN number_inpatient > 0 THEN 2
            ELSE 0
        END

        +

        CASE
            WHEN number_emergency > 0 THEN 1
            ELSE 0
        END

        +

        CASE
            WHEN time_in_hospital > 7 THEN 1
            ELSE 0
        END

        +

        CASE
            WHEN number_diagnoses > 5 THEN 1
            ELSE 0
        END

        +

        CASE
            WHEN num_medications > 10 THEN 1
            ELSE 0
        END

        +

        CASE
            WHEN readmitted <> 'NO' THEN 2
            ELSE 0
        END

    ) AS readmission_priority_score

FROM fact_hospital_visit;


-- ============================================================
-- 10. READMISSION PRIORITY CATEGORY
-- ============================================================

CREATE VIEW vw_readmission_priority_category AS
SELECT
    encounter_id,
    patient_key,
    readmission_priority_score,

    CASE
        WHEN readmission_priority_score <= 2
            THEN 'Low Priority'

        WHEN readmission_priority_score BETWEEN 3 AND 5
            THEN 'Medium Priority'

        WHEN readmission_priority_score >= 6
            THEN 'High Priority'
    END AS priority_category

FROM vw_readmission_priority_score;


-- ============================================================
-- 11. VIEW VALIDATION
-- ============================================================

SELECT *
FROM vw_prevention_kpis;

SELECT *
FROM vw_readmission_analysis;

SELECT *
FROM vw_patient_demographics
LIMIT 20;

SELECT *
FROM vw_diabetes_care_quality
LIMIT 20;

SELECT *
FROM vw_diabetes_risk_factors
LIMIT 20;

SELECT *
FROM vw_diabetes_risk_index
LIMIT 20;

SELECT *
FROM vw_diabetes_risk_category
LIMIT 20;

SELECT *
FROM vw_readmission_priority_score
LIMIT 20;

SELECT *
FROM vw_readmission_priority_category
LIMIT 20;
