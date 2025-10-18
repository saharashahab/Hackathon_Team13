# Hospital Wait Time Quality Control System

## Table of Contents
1. [Project Overview](#project-overview)
2. [Project Objective](#project-objective)
3. [Features](#features)
4. [Setup and Installation](#setup-and-installation)
5. [Usage](#usage)
6. [Goals and Assumptions](#goals-and-assumptions)

## Project Overview
Long hospital wait times delay treatment and lower patient satisfaction. Many hospitals currently rely on manual systems that make it difficult for doctors to determine which patients should be visited next.\
The Patient Priority Dashboard was developed to provide a quality control tool for tracking and mitigating wait times for inpatient care while on the hospital floor. Based on customer discovery and analyzing a hospital's needs, a six sigma-informed monitoring dashboard displays real-time information about all current inpatients using a standardized scoring system to highlight those requiring the most urgent attention. This easy-to-read visualization tool helps doctors manage patient prioritization, ultimately improving hospital operating efficiency and the overall quality of care offered.

## Project Objective
The goal of the Patient Priority Dashboard is to display all current patients on the floor and order how they should be prioritized in being checked based on: 
- Admitted time and date
- Time since last checked by doctor
- Injury Severity Score (ISS)
The first two metrics, admitted time and time since last checked, simply state when the patient has been last seen for care by a doctor. The injury severity score, or ISS, is assessed by triage before a patient is admitted into a hospital and is an evaluation of how stable a patient is. The evaluation accounts for all body regions and how severe the injury is to each as well as the patient's vitals.
The patient priority table in the dashboard includes a priority score, which was calculated using the normalized value of the inputs and its weights. The score ranges from 0 to 1 for each patient, where higher values correspond to greater urgency. 

## Features
- **Patient Overview Table**: A sortable and interactive table displaying patient information and calculated metrics (wait time since last checked by a doctor, injury severity score, and their priority number).
- **Display Option Dropdown**: Allows the user to sort displayed data based on calculated metrics.
- **SPC Chart**: Displays a chart for monitoring wait times with Upper Control Limit (UCL) and Lower Control Limit (LCL) to track process stability.
- **Color Legend**: A legend for understanding color-coded Priority Scores based on Wait Time.
- **High Risk Priority Warning**: Flags the number of high-risk patients that should be attended to immediately.
- **PPk**: Performance process indices that measure whether the current patient priority scores stay within expected specification limits.
- **PPk expected**: Predicted performance process indices after all high-priority patients have been visited.

## Setup and Installation

### Prerequisites
Ensure that you have the following software installed:
- **R** (version 3.6 or higher)
- **Shiny** package
- **shinydashboard** package
- **DT** package
- **dplyr** package
- **ggplot2** package
- **readr** package
- **readxl** package
- **lubridate** package

### Installation Instructions

```bash
git clone https://github.com/your-username/your-repository-name.git

```
 
## Usage

### Patient Priority Table
The patient priority table determines which patients have the highest priority to be seen next by doctors. There are four columns within the table: patient name, time since last checked, injury severity score, and priority score. Based on the patient priority score, the patients are categorized into three different groups:
| Color | Description | Priority Score Range |
| :------- | :------- | :------- |
| Red (High Risk) | Immediate attention needed | >0.675 |
| Yellow (Medium Risk) | Monitor closely | 0.4-0.675 |
| Green (Low Risk) | Stable patients | <0.4 |

Priority table output:\
<img width="579" height="346" alt="Screenshot 2025-10-18 at 12 08 32 PM" src="https://github.com/user-attachments/assets/b38741f6-eac0-4e05-962f-71034fd77c4e" />\
<img width="583" height="363" alt="image" src="https://github.com/user-attachments/assets/4be4cb5d-7fc7-40b6-b0aa-10e7cbef12d6" />

The patient priority table for the second dataset displays the patients listed in order from highest to lowest priority score, with each score highlighted based on their risk level. According to the output table, 13% of patients are categorized as high risk, 79% are categorized as medium risk, and the remaining are low risk. This reflects the idea that most admitted patients require prompt clinical review or intervention but are not in immediate danger. As a result, the determined thresholds for the priority score range appropriately prioritizes this group to ensure timely care delivery while reserving red status for truly critical cases and green for stable patients who can safely wait longer.

### Sort By Feature
The Sort by feature improves the usability of the dashboard by allowing the user to quickly reorganize the patient data in the priority table based on their desired metric and current priorities. Different situations may result in different decision criteria, so this feature helps them adapt the dashboard to their workflow instantly. The three sort options are: 
- Sorting by Priority Score: Allows the user to instantly see which patients have the most urgent need for a visit based on the combined weighting of the injury severity score, time since last check in, and admitted time. 
- Sorting by Hours Since Last Checked: Helps the user easily see which patients in general have gone the longest without a visit. 
- Sorting by Injury Severity Score (ISS): Allows the user to focus on the most critically injured patients. 

Dashboard sorted by ISS:\
<img width="811" height="671" alt="image" src="https://github.com/user-attachments/assets/58dbe852-7824-4fdb-bb04-a8193afe03bf" />\
This image shows how the dashboard will look when sorted by ISS. The data is ordered in descending order with the first row showing the patient with the highest ISS and the last row shown on the screen showing the patient with the tenth highest ISS. This option allows the user to quickly identify and prioritize patients with the most critical injuries, ensuring that the high severity cases receive quicker attention.

Dashboard sorted by Hours Since Last Checked:\
<img width="810" height="667" alt="image" src="https://github.com/user-attachments/assets/0aa17762-b43c-4615-bf9e-d967b2afeea6" />\
This image shows how the dashboard will look when sorted by Hours since Last Checked. The data is arranged in descending order, with the patient who has gone the longest without being seen appearing at the top row. This sorting option allows users to identify patients who may have been waiting too long for a check in, ensuring that no patient experiences too long of a wait time in care.

Dashboard sorted by Priority Score:\
<img width="817" height="669" alt="image" src="https://github.com/user-attachments/assets/a72041dc-8107-4e82-ac14-f22a31e6d585" />\
This image shows how the dashboard will look when sorted by the priority score. The data appears in descending order, with the patient with the highest priority score being on the first row. This sorting method accounts for multiple criteria (wait time, ISS, duration/number of checks), and results in a balanced evaluation of urgency and stability.

This flexibility transforms the dashboard from a static display into an interactive decision support tool. It is easy for doctors to interact with and prioritize patients by whichever metric they feel is most important, and be able to quickly see and verify which patient requires their attention.

### High Priority Risk Warning

<img width="215" height="121" alt="image" src="https://github.com/user-attachments/assets/d4009ac1-6c51-42c2-910a-55300cbdd0ba" />\
The High Priority Risk Warning is a section of the dashboard that prints the number of patients who have a high priority risk warning, defined as a priority score range above 0.675. It allows for doctors to quickly see the number of patients who are high risk and may need to be attended to.

### SPC Chart

The SPC (Statistical Process Control) Chart helps track process stability of the data through control limits calculated from the mean wait time and the moving ranges since we have only one data point for each sub-group. These control limits help identify outliers or unstable wait time patterns. If points fall outside these limits, it signals that a patient’s wait time has deviated from the normal process pattern. This can signal a breakdown in workflow as a result of, for example, insufficient staffing or a sudden increase in patients. 

The SPC Chart also serves as a visualization aid for patient data. Instead of reading through the patient priority table, doctors can easily estimate how many high priority patients need to be attended to at the moment since patient wait time data points are color coded.

Once the hospital identifies several points above the upper control limit, they can either investigate the root causes (ex: shift change delays, understaffing), implement process improvements (ex: reallocate resources, call in more workers), and track whether the new changes bring the process back within the control limits.

This is directly related to the Six Sigma DMAIC Framework: 
- Define: Identify long wait times as the problem
- Measure: Track time since last check-in by doctor
- Analyze: Use SPC to detect unstable behavior
- Improve: Adjust shift scheduling
- Control: Use SPC chart to verify process behavior is stable again

<img width="876" height="679" alt="image" src="https://github.com/user-attachments/assets/7621474f-110e-4c1e-a17e-ba672c1489d3" />

The above image shows the SPC Chart for Hours Since Last Checked. The SPC Chart clearly indicates that though wait times are critical parameters to determine the priority, patients could have have high waiting times but comparatively low priority scores. This can also be seen in the figure where no high priority patient is above the SPC since there are other parameters (Injury Severity Score and Check Ratio) affecting the priority score.

### Ppk and Predicted Ppk

Process performance index, or Ppk, is oftentimes used in quality control to evaluate how well a current process is meeting specifications. Based on the value, it tells us the capability of the process. The value approaching 1 or going beyond 1 would make it a capable process. The predicted process performance index, or predicted Ppk, is used to evaluate how well a process could meet specifications if a metric had an idealized value (ex: no high priority risk warning patients).

<img width="408" height="166" alt="image" src="https://github.com/user-attachments/assets/65664402-73c0-4235-a9dd-0419ca5cb709" />

The above image shows the Ppk and predicted Ppk for the data. The predicted Ppk is always expected to increase, since there will no longer be any high priority patients.

## Goals and Assumptions
The goal of the dashboard is to display all who are admitted as inpatients and quantify the order in which the hospital should prioritize based on time since checked by the doctors, the original admitted time and date, and their injury severity scores. This dashboard will be known as the patient priority table.

The first two metrics, admission time and time since last checked, simply state when the patient has been last seen for care by a doctor. The injury severity score, or ISS, is assessed by triage before a patient is admitted into a hospital and is an evaluation of how stable a patient is. The evaluation accounts for all body regions and how severe the injury is to each as well as the patients vitals.

There are several assumptions that the team is currently operating under. The first is that wait times and "checked-in" times are based on when a patient sees a doctor and does not include any other supporting staff. The second assumption is that the ISS is assumed to be already calculated by the hospitals and is easily accessible as it is a widely accepted practice in hospitals. Lastly, the main emphasis of the dashboard is the patients themselves and is not contingent on the staff supporting the hospital.

The numerical method used to rank each patient based on their symptoms and wait times is based on a common Systems Engineering approach from a decision matrix. Criteria that are vital for a system are identified and are represented within a given sample size. Weights are assigned to each to represent factors that are more important than others. In this case, a random survey of 15 people was conducted to evaluate the weights of each criteria used to assess the prioirty table. These values can be seen below:
- ISS: 40%
- Time Waited: 33%
- Average Check - Ratio: 27%

Afterwards, the maximum desired values wihtin each of these criteria are defined by the team and are used to normalize the data. The purpose of normalizing the data is so that it can be multiplied by the defined weights. The final scores of each are then added up to obtain a value from 0-1, representing how much a patient should be prioritized, from 0 being deprioritized to 1 being crticial.
