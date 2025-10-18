## Datasheet Codebook

**PatientName**: Name of patient, generated randomly using ChatGPT. Used since hospitals use names as identifiers for patients.

**Birthdate**: Birthdate of patient, generated randomly using ChatGPT. Used since hospitals use birthdates as identifiers for patients.

**TimeAdmitted**: Time in day when the patient was admitted, generated randomly using ChatGPT. Used to track how long a patient has been at the hospital. 24-hour time used without colons to follow hospital time conventions.

**DateAdmitted**: Date the patient was admitted to the hospital, generated randomly using ChatGPT for the past month. Used to track how long a patient has been at the hospital and the check ratio. Format of MM-DD-YYYY used to follow hospital date conventions.

**TimeChecked**: Time in day when the patient was last checked by a doctor, generated randomly using ChatGPT for a 9-5 workday. Used to track how long since a patient was last checked. 24-hour time used without colons to follow hospital time conventions.

**DateChecked**: Date the patient was last checked by a doctor, chosen at random within the last 3 days by a human based on injury severity score. Used to track how long since a patient was last checked. Format of MM-DD-YYYY used to follow hospital date conventions.

**ISS**: Injury Severity Score, a metric used in hospitals to determine how severe trauma is, on a scale of 1 to 75 (75 being most severe), chosen by a human with most scores to be within the 1-8, 9-15, and 16-24 “minor” to “severe” buckets. Used by hospitals to track which patients will require more care due to the nature of their injuries.

**Checks**: How many visits from a doctor a patient has received, chosen by a human with earlier admittance dates and higher ISS values receiving more visits. Used to calculate the check ratio.
