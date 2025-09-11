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
                      ┌─────────────┐
                      │ CloudTrail  │
                      │  (Logs all  │
                      │  AWS events)│
                      └─────┬──────┘
                            │
                            ▼
                      ┌─────────────┐
                      │    S3       │
                      │ (Log storage)
                      └─────┬──────┘
                            │
            ┌───────────────┼─────────────────┐
            │                               │
            ▼                               ▼
      ┌─────────────┐                 ┌───────────────┐
      │  Athena     │                 │ GuardDuty     │
      │  (Runs SQL  │                 │ (Detects     │
      │  queries on │                 │ threats &    │
      │  CloudTrail │                 │ anomalies)   │
      │  logs)      │                 └─────┬────────┘
      └─────┬──────┘                       │
            │                               │
            ▼                               ▼
      ┌─────────────┐                 ┌───────────────┐
      │  Lambda     │                 │ Security Hub  │
      │  (Automates │                 │ (Consolidates│
      │  Athena     │                 │  GuardDuty & │
      │  queries,   │                 │  other findings)
      │  saves CSV) │                 └─────┬────────┘
      └─────┬──────┘                       │
            │                               │
            └───────────────┬───────────────┘
                            ▼
                      ┌─────────────┐
                      │ EventBridge │
                      │ + SNS       │
                      │ (Alerts)    │
                      └─────┬──────┘
                            │
                            ▼
                      ┌─────────────┐
                      │ QuickSight  │
                      │ (Dashboards │
                      │  & KPIs)    │
                      └─────────────┘

- **CloudTrail** → Logs all AWS account activity to S3.  
- **Athena** → Runs SQL queries on CloudTrail logs.  
- **Lambda** → Automates queries on a schedule/test event and stores structured results in S3.  
- **GuardDuty** → Detects malicious activity and anomalies.  
- **EventBridge + SNS** → Sends real-time alerts.  
- **QuickSight** → Visualizes activity with dashboards.

---

## Repository Structure
```plaintext
/AWS-Threat-Detection-Monitoring/
│── 1-Lambda/                   (AWS Lambda function code for Athena automation)
│    ├── lambda_function_basic.py      # Simple test function to validate Athena connectivity
│    └── lambda_function_dynamic.py    # Dynamic function to run queries from test events
│
│── 2-Athena-Queries/           (SQL queries for CloudTrail log analysis)
│    ├── 01_total_events.sql           # Validate event ingestion
│    ├── 02_user_identity.sql          # Analyze userIdentity details
│    ├── 05_failed_logins.sql          # Detect failed logins
│    └── ...                           # Other queries (03–10)
│
|── 3-Results/                  (Outputs saved from Athena queries)                
│     ├── total-events.csv
│     ├── failed-logins.csv
│     ├── iam-changes.csv
│     └── ...                           # CSV output for all 10 queries
|
│── 4-Quicksight-Screenshots/   (Exports of dashboard visuals)
│     ├── dashboard-kpis.png
│     ├── activity-by-region.png
│     ├── top-source-ips.png
│     ├── iam-actions.png
│     ├── login-over-time.png
│     └── top-event-sources.png
│
│── 5-Docs/                     (Detailed documentation and report)
│    └── Documentation.md              
│
└── README.md                 (Main project overview)

```
---

## How To Run

### 1. CloudTrail Setup
- Enable CloudTrail and send logs to an S3 bucket.  
- Confirm events are arriving in the S3 bucket.  

### 2. Athena Queries
- Create a database (`cloudtrail_logs`) and table (`cloudtrail_events`) in Athena.  
- Run queries

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


