# Hospital Wait Time Quality Control System

## Table of Contents
1. [Project Overview](#project-overview)
2. [Features](#features)
3. [Setup and Installation](#setup-and-installation)
4. [Usage](#usage)
5. [Functions](#functions)
6. [Example Output](#example-output)
7. [Contributing](#contributing)
8. [License](#license)

## Project Overview
This Patient Priority Dashboard provides a quality control system for tracking and mitigating wait times for inpatient care while on the hospital floor. Based on customer discovery and analyzing a hospital's needs, a six sigma informed monitoring dashboard was created to display information about all thoses currently inpatient. It provides an easy to read visualization tool for doctors to help them manage patient prioritization on a standardized scale. 


## Features
- **Patient Overview Table**: A sortable and interactive table displaying patient information and calculated metrics (wait time since last checked by a doctor, injury severity score, and their priority number).
- **SPC Chart**: Displays a chart for monitoring wait times with Upper Control Limit (UCL) and Lower Control Limit (LCL) to track process stability.
- **Color Legend**: A legend for understanding color-coded Priority Scores based on Wait Time.
- **High Risk Priority Warning**: Flags the number of high-risk patients that should be attended to immediately.
- **PPk**:
- **PPk expected**:

## Setup and Installation

### Prerequisites
Ensure that you have the following software installed:
- **R** (version 3.6 or higher)
- **Shiny** package
- **shinydashboard** package
- **DT** package
- **dplyr** package
- **ggplot2** package

### Installation Instructions

```bash
git clone https://github.com/your-username/your-repository-name.git

```
 
 
 # Hackathon_Team13
The goal of the dashboard is to display all who are admitted as inpatients and quantify the order in which the hosptial should prioritize based on time since checked from the doctors, the original admitted time and date, and their injury severity scores. This dashboard will be known as the patient priority table.

The first two metrics, admited time and time since last checked, simply state when the patient has been last been seen for care by a doctor. The injury severity score, or ISS, is assessed by triage before a patient is admitted into a hospital and is an evaluation of how stable a patient is. The evaluation accounts for all body regions and how severe the injury is to each as well as the patients vitals.

There are several assumptions that the team is currently operating under. The first is that wait times and "checked-in" times are based on when a patient sees a doctor and does not include any other supporting staff. The second assumption is that the ISS is assumed to be already calculated by the hospitals and is easily accessible as it is a widely accepted practice in hospitals. Lastly, the main emphasis of the dashboard is the patients themselves and is not contingent on the staff supporting the hospital.

The numerical method used to rank each patient based on their symptomns and wait times is based on a common Systems Engineering appraoch from a decision matrix. Critera that are vital for a system are identified and are represented within a given sample size. Weights are assigned to each to represent factors that are more important than others. In this case, a random survey of 15 people was conducted to evaluate the weights of each criteria used to assess the prioirty table. These values can be seen below:

ISS - 40%

Time Waited - 33%

Average Check - Ratio 27%

Afterwards, the maximum desired values wihtin each of these critertia are defined by the team and are used to normalize the data. The purpose of normalizing the data is so that they can be multiplied by the defined weights. The final scores of each are then added up to obtain a value form 0-1, representing how much a patient should be prioritized, from 0 being deprioritized to 1 being crticial.



