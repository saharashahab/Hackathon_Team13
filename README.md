 # Hackathon_Team13
Team 13 decide to chose prompt 3 regarding the development a quality control system for tracking and mitigating wait times for inpatient care iun hospitals.

Based on customer discovery and analyzing a hospital's needs, the team decided to create a dashboard that can display information abot all thoses currently inpatient. 

The goal of the dashboard is to display all who are admitted as inpatients and quantify the order in which the hosptial should prioritize based on time since checked from the doctors, the original admitted time and date, and their injury severity scores. This dashboard will be known as the patient priority table.

The first two metrics, admited time and time since last checked, simply state when the patient has been last been seen for care by a doctor. The injury severity score, or ISS, is assessed by triage before a patient is admitted into a hospital and is an evaluation of how stable a patient is. The evaluation accounts for all body regions and how severe the injury is to each as well as the patients vitals.

There are several assumptions that the team is currently operating under. The first is that wait times and "checked-in" times are based on when a patient sees a doctor and does not include any other supporting staff. The second assumption is that the ISS is assumed to be already calculated by the hospitals and is easily accessible as it is a widely accepted practice in hospitals. Lastly, the main emphasis of the dashboard is the patients themselves and is not contingent on the staff supporting the hospital.

The numerical method used to rank each patient based on their symptomns and wait times is based on a common Systems Engineering appraoch from a decision matrix. Critera that are vital for a system are identified and are represented within a given sample size. Weights are assigned to each to represent factors that are more important than others. In this case, a random survey of 15 people was conducted to evaluate the weights of each criteria used to assess the prioirty table. These values can be seen below:

ISS - 40%

Time Waited - 33%

Average Check - Ratio 27%


Afterwards, the maximum desired values wihtin each of these critertia are defined by the team and are used to normalize the data.



