# 🏥 Patient Monitoring Dataset

## 📘 Overview

These datasets contains representative patient data from a **typical hospital environment**, focusing on routine monitoring situations. **Abnormal or emergency cases are excluded** to maintain a baseline of standard patient care data. These datasets can be used by doctors as part of a quality control system to help track which patients have faced the longest wait times on the hospital floor and should be prioritized for treatment.

The dataset is designed for applications such as patient check-up prioritization, hospital workflow simulation, and healthcare data analysis.

---

## 📊 Dataset Features

Each record includes the selected following fields:

- **`PatientName`** – Identifier for the patient.
- **`TimeChecked`** – Time the patient was last checked by a doctor (in 24-hour time).
- **`Injury Severity Score (ISS)`** – Numerical indicator of injury severity, assigned by the hospital. Higher scores suggest more serious conditions (integer).

---

## ✅ Intended Use

This dataset is suitable for:

- 📈 Tracking wait times for inpatient care while on the hospital floor  
- 🏥 Alerting doctors to patients who most need to be checked on using quantifiable metrics  
- 🎓 Educational purposes in six sigma, data science, or healthcare analytics 

---

## ⚠️ Limitations

- Only includes **typical** (non-critical) patient scenarios.
- Patient names and other data are **fictitious** and not based on real individuals.
- Not suitable for training emergency detection systems or models requiring edge-case data.

---
