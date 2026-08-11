-- ============================================================
-- Diabetes Healthcare Decision Support System
-- File: 04_views.sql
-- Purpose: Analytical views for Power BI and decision support
-- ============================================================

---

-- 1. Patient Demographics

---

CREATE OR REPLACE VIEW vw_patient_demographics AS
SELECT
patient_key,
race,
gender,
age
FROM dim_patient;

---

-- 2. Patient Care Summary

---

CREATE OR REPLACE VIEW vw_patient_care_summary AS
SELECT
f.encounter_id,
f.patient_key,
p.race,
p.gender,
p.age,
f.time_in_hospital,
f.num_lab_procedures,
f.num_procedures,
f.num_medications,
f.number_outpatient,
f.number_emergency,
f.number_inpatient,
f.number_diagnoses,
f.max_glu_serum,
f.A1Cresult,
f.readmitted
FROM fact_hospital_visit f
LEFT JOIN dim_patient p
ON f.patient_key = p.patient_key;

---

-- 3. Hospital KPIs

---

CREATE OR REPLACE VIEW vw_hospital_kpis AS
SELECT
COUNT(DISTINCT encounter_id) AS total_hospital_visits,
COUNT(DISTINCT patient_key) AS total_patients,
ROUND(AVG(time_in_hospital), 2) AS average_length_of_stay,
ROUND(AVG(num_medications), 2) AS average_medications,
ROUND(AVG(num_lab_procedures), 2) AS average_lab_procedures
FROM fact_hospital_visit;

---

-- 4. Readmission Analysis

---

CREATE OR REPLACE VIEW vw_readmission_analysis AS
SELECT
readmitted,
COUNT(*) AS total_visits,
ROUND(
COUNT(*) * 100.0 /
NULLIF(SUM(COUNT(*)) OVER (), 0),
2
) AS percentage_of_visits
FROM fact_hospital_visit
GROUP BY readmitted
ORDER BY total_visits DESC;

---

-- 5. Diabetes Care Quality

---

CREATE OR REPLACE VIEW vw_diabetes_care_quality AS
SELECT
A1Cresult,
max_glu_serum,
COUNT(*) AS patient_visits,
COUNT(*) FILTER (
WHERE A1Cresult IS NOT NULL
AND A1Cresult <> 'None'
) AS A1C_tested
FROM fact_hospital_visit
GROUP BY A1Cresult, max_glu_serum;

---

-- 6. Healthcare Access Analysis

---

CREATE OR REPLACE VIEW vw_healthcare_access_analysis AS
SELECT
access_key,
any_healthcare,
no_docbc_cost,
payer_code,
medical_specialty
FROM dim_healthcare_access;

---

-- 7. Diabetes Risk Factors

---

CREATE OR REPLACE VIEW vw_diabetes_risk_factors AS
SELECT
health_key,
bmi,
bmi_category,
smoker,
stroke,
heart_disease_or_attack,
phys_activity,
fruits,
veggies,
heavy_alcohol_consumption,
gen_health,
ment_health,
phys_health,
diff_walk
FROM dim_health_profile;

---

-- 8. Diabetes Risk Category

---

CREATE OR REPLACE VIEW vw_diabetes_risk_category AS
SELECT
health_key,
bmi,
bmi_category,
CASE
WHEN bmi >= 30
OR smoker = TRUE
OR stroke = TRUE
OR heart_disease_or_attack = TRUE
THEN 'High Risk'

```
    WHEN bmi >= 25
         OR phys_activity = FALSE
    THEN 'Moderate Risk'

    ELSE 'Lower Risk'
END AS risk_category
```

FROM dim_health_profile;

---

-- 9. Diabetes Risk Index

---

CREATE OR REPLACE VIEW vw_diabetes_risk_index AS
SELECT
health_key,
bmi,
bmi_category,

```
(
    CASE WHEN bmi >= 30 THEN 2 ELSE 0 END +
    CASE WHEN smoker = TRUE THEN 1 ELSE 0 END +
    CASE WHEN stroke = TRUE THEN 2 ELSE 0 END +
    CASE WHEN heart_disease_or_attack = TRUE THEN 2 ELSE 0 END +
    CASE WHEN phys_activity = FALSE THEN 1 ELSE 0 END +
    CASE WHEN fruits = FALSE THEN 1 ELSE 0 END +
    CASE WHEN veggies = FALSE THEN 1 ELSE 0 END +
    CASE WHEN heavy_alcohol_consumption = TRUE THEN 1 ELSE 0 END
) AS risk_index
```

FROM dim_health_profile;

---

-- 10. Prevention KPIs

---

CREATE OR REPLACE VIEW vw_prevention_kpis AS
SELECT
COUNT(*) AS total_records,
COUNT(*) FILTER (
WHERE diabetes_binary = TRUE
) AS diabetes_cases,

```
ROUND(
    COUNT(*) FILTER (
        WHERE diabetes_binary = TRUE
    ) * 100.0 /
    NULLIF(COUNT(*), 0),
    2
) AS diabetes_prevalence_percentage,

ROUND(AVG(mental_health_days), 2)
    AS average_mental_health_days,

ROUND(AVG(physical_health_days), 2)
    AS average_physical_health_days
```

FROM fact_prevention;

