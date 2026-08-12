# Diabetes Healthcare Decision Support System

### A Data-Driven Analytics Project for Diabetes Prevention, Care Quality, Hospital Readmission Management, and Decision Support

## Project Overview

The **Diabetes Healthcare Decision Support System** is a healthcare analytics project designed to transform diabetes-related healthcare data into actionable insights for **diabetes prevention, care quality improvement, hospital readmission management, and data-driven decision-making**.

The project combines **PostgreSQL, SQL, and Power BI** to build a structured data warehouse, perform analytical queries, develop healthcare performance indicators, and present findings through interactive dashboards for healthcare executives, clinicians, and public health decision-makers.

The analysis focuses on:

* Diabetes prevention and population health
* Diabetes risk factor analysis
* Patient risk stratification
* Diabetes care quality monitoring
* Hospital readmission management
* Healthcare resource utilization
* Data-driven decision support

---

## Business Problem

Healthcare systems face increasing pressure from rising diabetes prevalence, avoidable hospital readmissions, and variations in care quality.

Decision-makers need integrated analytics that combine demographic, clinical, lifestyle, healthcare-access, and hospital-utilization data to identify high-risk populations, monitor healthcare performance, and improve patient outcomes.

This project addresses these challenges by building a structured **PostgreSQL data warehouse and analytical layer** that feeds Power BI dashboards.

---

## Project Objectives

* Analyze diabetes prevalence across population groups.
* Identify major diabetes risk factors.
* Evaluate hospital readmission patterns.
* Assess healthcare resource utilization.
* Monitor diabetes care quality indicators.
* Develop diabetes risk classifications.
* Analyze demographic, lifestyle, clinical, and healthcare-access factors associated with diabetes risk.
* Develop hospital readmission priority classifications.
* Analyze the relationship between healthcare access and hospital outcomes.
* Build decision-support dashboards for healthcare and operational decision-making.
* Demonstrate practical application of SQL and business intelligence in healthcare analytics.

---

## Datasets

### 1. BRFSS Diabetes Health Indicators

The population health dataset contains indicators related to:

* Diabetes status
* BMI
* High blood pressure
* High cholesterol
* Smoking
* Stroke
* Heart disease
* Physical activity
* Fruit and vegetable consumption
* Alcohol consumption
* General health
* Mental health
* Physical health
* Education
* Income

### 2. Diabetes Hospital Utilization Dataset

The hospital dataset contains more than **100,000 hospital encounter records** and includes:

* Patient demographics
* Hospital admissions
* Diagnoses
* Laboratory procedures
* Medications
* Insulin treatment
* HbA1c testing
* Blood glucose testing
* Healthcare access
* Length of hospital stay
* Emergency visits
* Inpatient visits
* Outpatient visits
* Readmission status

---

## Data Architecture

The project uses a **star-schema data warehouse** implemented in PostgreSQL.

### Staging Tables

* `stg_brfss`
* `stg_hospital`

### Dimension Tables

* `dim_patient`
* `dim_health_profile`
* `dim_healthcare_access`
* `dim_hospital`
* `dim_medication`
* `dim_risk_factor`

### Fact Tables

* `fact_hospital_visit`
* `fact_prevention`
* `fact_risk_factor`

### Analytics Layer

SQL analytical views were developed to support:

* Healthcare access analysis
* Diabetes prevention KPIs
* Patient demographic analysis
* Hospital readmission analysis
* Diabetes care quality analysis
* Diabetes risk factor analysis
* Community Diabetes Risk Index
* Hospital Readmission Priority Score

---

## Project Workflow

```text
Raw Healthcare Data
        ↓
PostgreSQL Staging
        ↓
Data Cleaning & Transformation
        ↓
Dimensional Data Warehouse
        ↓
Fact & Dimension Tables
        ↓
Data Quality Validation
        ↓
SQL Analytics Views
        ↓
Power BI Dashboard
        ↓
Business & Healthcare Insights
        ↓
Decision Support
```

---

## Technology Stack

| Technology     | Purpose                                          |
| -------------- | ------------------------------------------------ |
| **PostgreSQL** | Database development and data warehousing        |
| **SQL**        | Data cleaning, transformation, and analysis      |
| **Power BI**   | Interactive dashboards and visualization         |
| **Excel**      | Data exploration and supporting analysis         |
| **GitHub**     | Project documentation and portfolio presentation |

---

## Key Analytical Components

### Community Diabetes Risk Index

A rule-based diabetes risk scoring framework was developed using selected health and lifestyle indicators, including:

* BMI
* High blood pressure
* High cholesterol
* Smoking
* Stroke
* Heart disease
* Physical inactivity
* General health

The resulting population risk categories are:

* **Low Risk**
* **Medium Risk**
* **High Risk**

### Hospital Readmission Priority Score

A rule-based hospital readmission priority framework was developed using indicators including:

* Previous inpatient utilization
* Emergency visits
* Length of hospital stay
* Number of medications
* Number of diagnoses
* Readmission status

Patients are classified into:

* **Low Priority**
* **Medium Priority**
* **High Priority**

---

## Dashboard Highlights

| KPI                    |         Value |
| ---------------------- | ------------: |
| Total Hospital Visits  |      **102K** |
| Diabetes Prevalence    |       **50%** |
| Total Readmissions     |       **47K** |
| Readmission Rate       |     **46.1%** |
| High Priority Patients |     **5,467** |
| Average Length of Stay | **4.40 days** |
| Average Diagnoses      |      **7.42** |
| Average Medications    |     **16.02** |
| Insulin Therapy Rate   |     **53.4%** |
| HbA1c Testing Rate     |       **17%** |

---

## Key Findings

### Population and Risk

* The **70–80-year** age group recorded the highest diabetes burden.
* Obesity was strongly associated with diabetes risk.
* High blood pressure and high cholesterol were among the most common risk factors.

### Hospital Operations

* Readmitted patients showed higher healthcare-utilization patterns.
* Readmission analysis highlighted differences in length of stay, medication utilization, diagnoses, and emergency or inpatient utilization.
* Emergency/Trauma and Internal Medicine contributed substantially to hospital activity and readmission volume.

### Diabetes Care Quality

* Medication management was documented in approximately **77% of visits**.
* HbA1c testing coverage was relatively low at approximately **17%**, highlighting an opportunity for clinical quality improvement.
* Insulin therapy and medication-management patterns were analyzed alongside readmission outcomes.

---

## Business Questions Addressed

### Diabetes Prevention

1. What is the prevalence of diabetes in the population?
2. Which population groups have the highest diabetes burden?
3. Which health and lifestyle factors are most associated with diabetes?
4. How does BMI relate to diabetes risk?
5. Which populations should receive greater prevention attention?

### Hospital Management

6. What proportion of hospital visits involve readmission?
7. Which patient groups experience higher readmission rates?
8. How does hospital length of stay vary across readmission groups?
9. How does medication utilization relate to hospital outcomes?
10. Which patients may require enhanced discharge planning and follow-up?

### Diabetes Care Quality

11. What proportion of patients receive HbA1c testing?
12. How are insulin and diabetes medication management associated with outcomes?
13. Where are opportunities for improving diabetes care quality?

---

## SQL Techniques Demonstrated

* Data cleaning and transformation
* Staging tables
* Dimensional data modeling
* Star-schema design
* Fact and dimension tables
* Primary and foreign keys
* Data validation
* Data quality checks
* SQL joins
* Aggregations
* Conditional logic
* `CASE` statements
* `FILTER` clauses
* Analytical views
* KPI development
* Risk scoring
* Data classification

---

## Dashboard Pages

The Power BI dashboard is structured around the following analytical areas:

1. **Executive Summary**
2. **Diabetes Prevention & Risk Analysis**
3. **Population Risk Segmentation**
4. **Hospital Operations & Readmission**
5. **Diabetes Care Quality**
6. **Actionable Recommendations**

---

## Repository Structure

```text
diabetes-healthcare-decision-support-system/
│
├── README.md
│
├── sql/
│   ├── 01_staging_tables.sql
│   ├── 02_dimension_tables.sql
│   ├── 03_fact_tables.sql
│   ├── 04_data_quality_and_validation.sql
│   └── 05_analytics_views.sql
│
├── powerbi/
│   └── dashboard/
│
├── screenshots/
│
└── documentation/
```

---

## Business Value

The project demonstrates how healthcare data can be transformed from raw datasets into structured analytical information that supports:

* Diabetes prevention planning
* Population health management
* Hospital performance monitoring
* Patient risk identification
* Readmission management
* Healthcare resource planning
* Clinical quality improvement
* Data-driven decision-making

---

## Recommendations

Based on the analytical framework, healthcare organizations could consider:

* Strengthening community-based diabetes prevention programs.
* Expanding early screening for higher-risk population groups.
* Implementing risk-based patient management for high-priority patients.
* Improving discharge planning and post-discharge follow-up.
* Strengthening medication-adherence monitoring.
* Increasing routine HbA1c testing.
* Using healthcare-utilization data to improve resource allocation.
* Conducting regular clinical quality audits.

---

## Project Status

**Completed**

- PostgreSQL data warehouse
- Data cleaning and transformation
- Data quality validation
- SQL analytics layer
- Analytical views
- Healthcare KPIs
- Risk classification frameworks
- Power BI dashboard development
- Dashboard screenshots
- README project documentation
- Business insights and recommendations

## 📸 Dashboard Screenshots

### Dashboard 1 — Executive Summary

![Executive Summary](Power%20BI/Dashboard%20Screenshots/01_executive_summary.png)

### Dashboard 2 — Diabetes Prevention & Risk Analysis

![Diabetes Prevention & Risk Analysis](Power%20BI/Dashboard%20Screenshots/02_prevention_risk_analysis.png)
### Dashboard 3 — Population Risk Segmentation

![Population Risk Segmentation](Power%20BI/Dashboard%20Screenshots/03_risk_segmentation.png)

### Dashboard 4 — Hospital Operations & Readmission

![Hospital Operations & Readmission](Power%20BI/Dashboard%20Screenshots/04_hospital_readmission.png)

### Dashboard 5 — Diabetes Care Quality

![Diabetes Care Quality](Power%20BI/Dashboard%20Screenshots/05_Care_quality.png)

### Dashboard 6 — Actionable Recommendations

![Actionable Recommendations](Power%20BI/Dashboard%20Screenshots/06_actionable_recommendations.png)
## Skills Demonstrated

* Healthcare Data Analytics
* Business Analytics
* Population Health Analytics
* PostgreSQL
* SQL
* Data Warehousing
* Dimensional Data Modeling
* Star-Schema Design
* Data Quality Validation
* KPI Development
* Risk Scoring
* Power BI
* Dashboard Development
* Clinical and Operational Reporting
* Decision-Support Analytics

---

## About the Analyst

### Ogechi Godson Ogu

**Environmental Scientist | Environmental Consultant | Data Analyst**

My interests sit at the intersection of **environmental science, healthcare analytics, research, and data-driven decision-making**.

I am particularly interested in applying data analytics and scientific research to real-world problems in **healthcare, environmental management, environmental health, sustainability, and public health**.

---

⭐ **Explore the repository to see the SQL data warehouse, analytical views, Power BI dashboard, and supporting project documentation.**
