# End-to-End AWS Threat Detection & Monitoring System

## Project Overview
This project implements an end-to-end cloud threat detection and monitoring system on AWS.  
It is called “end-to-end” because it covers the full pipeline — from raw log collection (CloudTrail) to automated detection (Athena/Lambda), continuous monitoring (GuardDuty), real-time alerts (EventBridge/SNS), and visualization (QuickSight).  

---

## Features
- Automated detection of unusual login activity and high-risk actions.
- Real-time alerts via SNS/EventBridge.
- Visual dashboards in QuickSight for security monitoring.
- Tested against multiple IAM roles and network scenarios.

---

## Architecture
- **CloudTrail** → Logs all AWS account activity to S3.  
- **Athena** → Runs SQL queries on CloudTrail logs.  
- **Lambda** → Automates queries on a schedule/test event and stores structured results in S3.  
- **GuardDuty** → Detects malicious activity and anomalies.  
- **EventBridge + SNS** → Sends real-time alerts.  
- **QuickSight** → Visualizes activity with dashboards.

---

## Athena Queries
| Query   | Purpose                              |
|---------|--------------------------------------|
| 01      | Validate total CloudTrail data count |
| 02      | Analyze `userIdentity` details       |
| 03      | Check actions being taken by users   |
| 04      | Track sign-in events                 |
| 05      | Detect failed logins                 |
| 06      | List users with failed logins        |
| 07      | Monitor root account activity        |
| 08      | Track IAM changes                    |
| 09      | Detect unusual region activity       |
| 10      | High-risk actions                    |

---

## Lambda Functions
- `lambda_function_basic.py`: Test script to confirm Athena connectivity.
- `lambda_function_dynamic.py`: Accepts queries via test events and executes them automatically.
- **S3 Output**: Query results saved to `s3://athena-query-results-aksh/`.

---

## GuardDuty
- Findings exported to EventBridge & optionally to S3.
- Findings were simulated and categorized into Critical, High, Medium, and Low severity levels (counts vary over time).
- Monitored threats include: potential data compromise, EC2 DNS attacks, credential compromises, container escapes.

---

## Alerts Example  
- Email alerts via SNS for critical GuardDuty findings (e.g., compromised IAM user, malicious IP).  
- Notifications grouped and filtered using EventBridge frequency rules.

---

## QuickSight Dashboard
- **Tabs / Visuals**:
  1. **Summary KPIs**: Total Events, Failed Logins, IAM Changes.
  2. **Activity by Region**: Donut chart + filled map using `Region` field.
  3. **Top Source IPs**: Table of IPs sorted by event counts.
  4. **IAM Actions**: Bar chart of IAM activity (CreateUser, AttachRolePolicy, etc.).
  5. **Login Activity Over Time**: Line chart by day/week.
  6. **Top Event Sources**: Bar chart of services generating events.

- **Calculated Fields**: `SuccessFailure`, `Day`, `Week`, `IAMChanges`, `FailedLogins`  

---

## Repository Structure
```plaintext
/AWS-Threat-Detection-Monitoring/
│── Lambda/                   (Lambda function code)
│── Athena-Queries/           (saved SQL queries)
│── Quicksight-Screenshots/   (your dashboard screenshots)
│── Results/                  (CSV outputs from Athena)
│── Docs/                     (documentation and report)
└── README.md                 (main documentation)
```
---

## Project Steps

### 1. CloudTrail Setup
- Enable CloudTrail and send logs to an S3 bucket.  
- Confirm events are arriving in the S3 bucket.  

### 2. Athena Queries
- Create a database (`cloudtrail_logs`) and table (`cloudtrail_events`) in Athena.  
- Run queries to detect:  
  - Failed login attempts  
  - IAM policy/role changes  
  - Root account activity  
  - Unusual region activity  
- Save results in CSV format.  

### 3. Lambda Automation
- Deploy a Lambda function to execute Athena queries automatically.  
- Store query results in a separate S3 bucket.  
- Configure event payloads to test different queries.  

### 4. GuardDuty
- Enable GuardDuty.  
- Run sample simulations (IAM compromise, S3 data exfiltration, EC2 crypto-mining).  
- Collect findings by severity (Critical, High, Medium, Low).  

### 5. Alerts (SNS + EventBridge)
- Create EventBridge rules to detect GuardDuty findings.  
- Forward alerts to an SNS topic.  
- Subscribe with email or SMS to receive notifications.  

### 6. QuickSight Dashboard
- Connect QuickSight to Athena workgroup.  
- Create calculated fields:  
  - `SuccessFailure`  
  - `Day`  
  - `Week`
  - `IAMChanges`
  - `FailedLogins`   
- Build visuals:  
  - KPIs (Total Events, Failed Logins, IAM Changes)  
  - Activity by Region (donut chart + filled map)  
  - Top Source IPs (table)  
  - IAM Actions (bar chart)  
  - Login Activity Over Time (line chart)  
  - Top Event Sources (bar chart)  

---

## Results

Key metrics from the final snapshot (Sept 2025):

- **Total Events:** 10,313  
- **Failed Logins:** 480  
- **IAM Changes (subset):** 49  
   - Includes only: `CreateUser`, `DeleteUser`, `CreateRole`,  `AttachRolePolicy`, `DetachRolePolicy`  
- **Error Codes Observed:** 20+ distinct errors (e.g., `ResourceNotFoundException`, `AccessDenied`, `InvalidRequestException`). Diversity of error codes shows visibility into authentication issues, missing permissions, and API misuse.  
- **GuardDuty Findings:** Simulated alerts confirmed detection of IAM credential misuse, S3 data compromise and EC2 compromise attempts  

**Note:** The values above are from a specific run (Sept 2025). Since this pipeline works on live CloudTrail logs and GuardDuty findings, the actual numbers will naturally change over time.

---

## Future Improvements
- Add anomaly detection using Amazon Detective.  
- Integrate SIEM tools like Splunk/ELK for hybrid monitoring.  
- Automate dashboard refresh and alerting pipeline.

---

## Notes
- All experiments are performed in a safe AWS account.
- Failed executions and mistakes (workgroup issues, S3 permissions) were resolved during testing.
- IAM policies were updated to allow Lambda & QuickSight access to necessary S3 buckets.

---

## License
This project is for educational purposes. No real data or sensitive information was used. Do not use it in production without proper security hardening.  

---

**Author**: Akshayah N S (Sept 2025)


