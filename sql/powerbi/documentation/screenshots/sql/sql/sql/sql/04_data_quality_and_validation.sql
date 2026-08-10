-- ============================================================
-- DIABETES HEALTHCARE ANALYTICS
-- 04 - DATA QUALITY AND VALIDATION
-- PostgreSQL
-- ============================================================


-- ============================================================
-- 1. PATIENT UNIQUENESS
-- ============================================================

SELECT
    COUNT(*) AS total_patient_records,
    COUNT(DISTINCT patient_nbr) AS unique_patients
FROM dim_patient;


-- Check duplicate patient identifiers
SELECT
    patient_nbr,
    COUNT(*) AS duplicate_count
FROM dim_patient
GROUP BY patient_nbr
HAVING COUNT(*) > 1;


-- ============================================================
-- 2. HOSPITAL VISIT VALIDATION
-- ============================================================

SELECT
    COUNT(*) AS total_visits,
    COUNT(DISTINCT encounter_id) AS unique_encounters,
    COUNT(DISTINCT patient_key) AS unique_patients
FROM fact_hospital_visit;


-- Check for duplicate encounter IDs
SELECT
    encounter_id,
    COUNT(*) AS duplicate_count
FROM fact_hospital_visit
GROUP BY encounter_id
HAVING COUNT(*) > 1;


-- ============================================================
-- 3. FACT TABLE RECORD COUNTS
-- ============================================================

SELECT
    'dim_patient' AS table_name,
    COUNT(*) AS records
FROM dim_patient

UNION ALL

SELECT
    'dim_hospital',
    COUNT(*)
FROM dim_hospital

UNION ALL

SELECT
    'dim_medication',
    COUNT(*)
FROM dim_medication

UNION ALL

SELECT
    'dim_healthcare_access',
    COUNT(*)
FROM dim_healthcare_access

UNION ALL

SELECT
    'dim_health_profile',
    COUNT(*)
FROM dim_health_profile

UNION ALL

SELECT
    'dim_risk_factor',
    COUNT(*)
FROM dim_risk_factor

UNION ALL

SELECT
    'fact_hospital_visit',
    COUNT(*)
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


-- ============================================================
-- 4. HOSPITAL DIMENSION LINKAGE
-- ============================================================

SELECT
    COUNT(*) AS total_visits,
    COUNT(hospital_key) AS linked_hospital_records,
    COUNT(*) - COUNT(hospital_key) AS missing_hospital_links
FROM fact_hospital_visit;


-- ============================================================
-- 5. MEDICATION DIMENSION LINKAGE
-- ============================================================

SELECT
    COUNT(*) AS total_visits,
    COUNT(medication_key) AS linked_medication_records,
    COUNT(*) - COUNT(medication_key) AS missing_medication_links
FROM fact_hospital_visit;


-- ============================================================
-- 6. HEALTHCARE ACCESS LINKAGE
-- ============================================================

SELECT
    COUNT(*) AS total_visits,
    COUNT(access_key) AS linked_access_records,
    COUNT(*) - COUNT(access_key) AS missing_access_links
FROM fact_hospital_visit;


-- ============================================================
-- 7. HOSPITAL READMISSION DATA COMPLETENESS
-- ============================================================

SELECT
    COUNT(*) AS total_records,
    COUNT(readmitted) AS readmission_records,
    COUNT(*) - COUNT(readmitted) AS missing_readmission_records
FROM fact_hospital_visit;


-- ============================================================
-- 8. DIABETES CARE QUALITY DATA COMPLETENESS
-- ============================================================

SELECT
    COUNT(*) AS total_records,
    COUNT(a1cresult) AS hba1c_records,
    COUNT(insulin) AS insulin_records,
    COUNT(diabetesmed) AS medication_records,
    COUNT(care_quality_score) AS populated_quality_scores,
    COUNT(care_quality_category) AS populated_quality_categories
FROM fact_hospital_visit;


-- ============================================================
-- 9. READMISSION PRIORITY DATA COMPLETENESS
-- ============================================================

SELECT
    COUNT(*) AS total_records,
    COUNT(readmission_priority_score) AS populated_scores,
    COUNT(*) - COUNT(readmission_priority_score) AS null_scores
FROM fact_hospital_visit;


SELECT
    priority_category,
    COUNT(*) AS total_visits
FROM fact_hospital_visit
GROUP BY priority_category
ORDER BY total_visits DESC;


-- ============================================================
-- 10. RISK FACTOR VALIDATION
-- ============================================================

SELECT
    rf.risk_factor_name,
    COUNT(*) AS total_records,
    COUNT(*) FILTER (WHERE f.risk_present = TRUE) AS risk_cases
FROM fact_risk_factor f
JOIN dim_risk_factor rf
    ON f.risk_factor_key = rf.risk_factor_key
GROUP BY rf.risk_factor_name
ORDER BY risk_cases DESC;


-- ============================================================
-- 11. BMI CATEGORY VALIDATION
-- ============================================================

SELECT
    bmi_category,
    COUNT(*) AS total_people
FROM dim_health_profile
GROUP BY bmi_category
ORDER BY bmi_sort;


-- ============================================================
-- 12. DIABETES PREVENTION DATA VALIDATION
-- ============================================================

SELECT
    COUNT(*) AS total_records,
    COUNT(diabetes_binary) AS diabetes_records,
    COUNT(*) - COUNT(diabetes_binary) AS missing_diabetes_records
FROM fact_prevention;


-- ============================================================
-- 13. SAMPLE DATA REVIEW
-- ============================================================

SELECT *
FROM dim_patient
LIMIT 10;

SELECT *
FROM dim_health_profile
LIMIT 10;

SELECT *
FROM fact_hospital_visit
LIMIT 10;

SELECT *
FROM fact_prevention
LIMIT 10;

SELECT *
FROM fact_risk_factor
LIMIT 10;
