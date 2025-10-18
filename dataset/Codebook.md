# 📘 Patient Monitoring Dataset – Codebook

<img width="812" height="24" alt="Screenshot 2025-10-18 at 1 36 49 AM" src="https://github.com/user-attachments/assets/ace3f384-e56a-4116-8e4a-e8c6c8d91f99" />

---

## 📊 Variable Descriptions

| **Variable**           | **Description** |
|---------------------|-----------------|
| `PatientName`       | A randomly generated patient name (via ChatGPT). Used as a primary identifier, following hospital conventions. |
| `Birthdate`         | Patient's date of birth (format: `MM-DD-YYYY`), randomly generated (via ChatGPT). Used as a secondary identifier, following hospital conventions. |
| `TimeAdmitted`      | Time of day the patient was admitted, in 24-hour format without colons (ex: `0830` = 8:30 AM), randomly generated (via ChatGPT). Matches common hospital time entry systems. Used to track how long a patient has been at the hospital. |
| `DateAdmitted`      | Admission date in `MM-DD-YYYY` format, randomly generated (via ChatGPT), from the past month with majority within the past week. Used to track duration of hospital stay and as part of the check ratio. |
| `TimeChecked`       | Time of last doctor check-up (24-hour format, no colons), randomly generated (via ChatGPT) within standard hospital hours (9 AM – 5 PM). Used to track how long since a patient was last checked. |
| `DateChecked`       | Date of last doctor check-up (format: `MM-DD-YYYY`), chosen manually from within the past 3 days based on injury severity score. Used to track how long since a patient was last checked. |
| `ISS` (Injury Severity Score) | A typical hospital metric (range: 1–75) used to assess trauma severity. Values were chosen manually to be primarily within the typical severity range (75 being most severe). Values here generally fall into:<br>• `1–8`: Minor injuries<br>• `9–15`: Moderate injuries<br>• `16–24`: Severe injuries<br>Higher ISS indicates a greater need for medical attention. |
| `Checks`            | Number of times a doctor has checked on the patient. Chosen manually by a combination of earlier admission dates and higher ISS scores. Used to calculate check ratio. |

---

## 🧠 Notes

- All data is not based on real patients or clinical records.
- Time values are presented without colons (ex: `1345` for 1:45 PM) to reflect hospital record conventions.
- The dataset simulates routine hospital operations only; no emergency or edge-case data is included.

---

## 📌 Definitions

- Check Ratio: A derived metric calculated as:  `Check Ratio = TimeWaited ÷ Checks`
    - TimeWaited = CurrentDateTime (m-d-y H-M-S format) - Admitted
    - Admitted = convert DateAdmitted and TimeAdmitted to m-d-y H-M-S format
    - CurrentDateTime = 10-17-2025 2214 (during Hackathon!)  

---
