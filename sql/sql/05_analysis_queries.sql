-- ============================================================
-- Diabetes Healthcare Decision Support System
-- File: 05_analysis_queries.sql
-- Purpose: Key analytical queries for healthcare decision support
-- ============================================================

---

-- 1. Diabetes prevalence

---

SELECT
COUNT(*) AS total_records,
COUNT(*) FILTER (WHERE diabetes_binary = TRUE) AS diabetes_cases,
ROUND(
COUNT(*) FILTER (WHERE diabetes_binary = TRUE) * 100.0
/ NULLIF(COUNT(*), 0),
2
) AS diabetes_prevalence_percentage
FROM fact_prevention;

---

-- 2. Readmission distribution

---

SELECT
readmitted,
COUNT(*) AS total_visits,
ROUND(
COUNT(*) * 100.0 /
NULLIF(SUM(COUNT(*)) OVER (), 0),
2
) AS percentage
FROM fact_hospital_visit
GROUP BY readmitted
ORDER BY total_visits DESC;

---

-- 3. Average hospital stay by readmission status

---

SELECT
readmitted,
COUNT(*) AS total_visits,
ROUND(AVG(time_in_hospital), 2) AS average_length_of_stay
FROM fact_hospital_visit
GROUP BY readmitted
ORDER BY average_length_of_stay DESC;

---

-- 4. Medication utilization

---

SELECT
m.metformin,
m.insulin,
m.diabetesMed,
COUNT(*) AS total_visits
FROM fact_hospital_visit f
LEFT JOIN dim_medication m
ON f.medication_key = m.medication_key
GROUP BY
m.metformin,
m.insulin,
m.diabetesMed
ORDER BY total_visits DESC;

---

-- 5. Patient demographics and readmission

---

SELECT
p.gender,
p.race,
p.age,
f.readmitted,
COUNT(*) AS total_visits
FROM fact_hospital_visit f
LEFT JOIN dim_patient p
ON f.patient_key = p.patient_key
GROUP BY
p.gender,
p.race,
p.age,
f.readmitted
ORDER BY total_visits DESC;

---

-- 6. Diabetes risk categories

---

SELECT
risk_category,
COUNT(*) AS total_people,
ROUND(
COUNT(*) * 100.0 /
NULLIF(SUM(COUNT(*)) OVER (), 0),
2
) AS percentage
FROM vw_diabetes_risk_category
GROUP BY risk_category
ORDER BY total_people DESC;

---

-- 7. Risk index distribution

---

SELECT
risk_index,
COUNT(*) AS total_people
FROM vw_diabetes_risk_index
GROUP BY risk_index
ORDER BY risk_index;

---

-- 8. BMI category and diabetes

---

SELECT
h.bmi_category,
COUNT(*) AS total_people,
COUNT(*) FILTER (
WHERE f.diabetes_binary = TRUE
) AS diabetes_cases,
ROUND(
COUNT(*) FILTER (
WHERE f.diabetes_binary = TRUE
) * 100.0 /
NULLIF(COUNT(*), 0),
2
) AS diabetes_percentage
FROM fact_prevention f
JOIN dim_health_profile h
ON f.health_key = h.health_key
GROUP BY h.bmi_category
ORDER BY diabetes_percentage DESC;

---

-- 9. Healthcare access

---

SELECT
any_healthcare,
no_docbc_cost,
COUNT(*) AS total_records
FROM dim_healthcare_access
GROUP BY
any_healthcare,
no_docbc_cost
ORDER BY total_records DESC;

---

-- 10. Hospital resource utilization

---

SELECT
readmitted,
ROUND(AVG(num_lab_procedures), 2)
AS average_lab_procedures,
ROUND(AVG(num_procedures), 2)
AS average_procedures,
ROUND(AVG(num_medications), 2)
AS average_medications,
ROUND(AVG(number_emergency), 2)
AS average_emergency_visits,
ROUND(AVG(number_inpatient), 2)
AS average_inpatient_visits
FROM fact_hospital_visit
GROUP BY readmitted
ORDER BY readmitted;

---

-- 11. A1C testing patterns

---

SELECT
A1Cresult,
COUNT(*) AS total_visits,
ROUND(
COUNT(*) * 100.0 /
NULLIF(SUM(COUNT(*)) OVER (), 0),
2
) AS percentage
FROM fact_hospital_visit
GROUP BY A1Cresult
ORDER BY total_visits DESC;

---

-- 12. High-risk patients requiring attention

---

SELECT
health_key,
bmi,
bmi_category,
risk_index
FROM vw_diabetes_risk_index
WHERE risk_index >= 5
ORDER BY risk_index DESC;

---

-- 13. Readmission priority analysis

---

SELECT
f.encounter_id,
f.patient_key,
p.gender,
p.race,
p.age,
f.time_in_hospital,
f.number_inpatient,
f.number_emergency,
f.number_diagnoses,
f.readmitted,

```
(
    CASE WHEN f.readmitted = '<30' THEN 3 ELSE 0 END +
    CASE WHEN f.number_inpatient >= 2 THEN 2 ELSE 0 END +
    CASE WHEN f.number_emergency >= 2 THEN 1 ELSE 0 END +
    CASE WHEN f.number_diagnoses >= 8 THEN 1 ELSE 0 END +
    CASE WHEN f.time_in_hospital >= 7 THEN 1 ELSE 0 END
) AS readmission_priority_score
```

FROM fact_hospital_visit f
LEFT JOIN dim_patient p
ON f.patient_key = p.patient_key
ORDER BY readmission_priority_score DESC;
