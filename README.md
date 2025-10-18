# Hospital Wait Time Quality Control System

## Table of Contents
1. [Project Overview](#project-overview)
2. [Project Objective](#project-objective)
3. [Features](#features)
4. [Setup and Installation](#setup-and-installation)
5. [Goals and Assumptions](#goals-and-assumptions)

## Project Overview
Long hospital wait times delay treatment and lower patient satisfaction. Many hospitals currently rely on manual systems that make it difficult for doctors to determine which patients should be visited next. <br /><br />
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
 
 
## Goals and Assumptions
The goal of the dashboard is to display all who are admitted as inpatients and quantify the order in which the hospital should prioritize based on time since checked by the doctors, the original admitted time and date, and their injury severity scores. This dashboard will be known as the patient priority table.

The first two metrics, admission time and time since last checked, simply state when the patient has been last seen for care by a doctor. The injury severity score, or ISS, is assessed by triage before a patient is admitted into a hospital and is an evaluation of how stable a patient is. The evaluation accounts for all body regions and how severe the injury is to each as well as the patients vitals.

There are several assumptions that the team is currently operating under. The first is that wait times and "checked-in" times are based on when a patient sees a doctor and does not include any other supporting staff. The second assumption is that the ISS is assumed to be already calculated by the hospitals and is easily accessible as it is a widely accepted practice in hospitals. Lastly, the main emphasis of the dashboard is the patients themselves and is not contingent on the staff supporting the hospital.

The numerical method used to rank each patient based on their symptoms and wait times is based on a common Systems Engineering approach from a decision matrix. Criteria that are vital for a system are identified and are represented within a given sample size. Weights are assigned to each to represent factors that are more important than others. In this case, a random survey of 15 people was conducted to evaluate the weights of each criteria used to assess the prioirty table. These values can be seen below:

- ISS: 40%
- Time Waited: 33%
- Average Check - Ratio: 27%

Afterwards, the maximum desired values wihtin each of these criteria are defined by the team and are used to normalize the data. The purpose of normalizing the data is so that it can be multiplied by the defined weights. The final scores of each are then added up to obtain a value from 0-1, representing how much a patient should be prioritized, from 0 being deprioritized to 1 being crticial.
