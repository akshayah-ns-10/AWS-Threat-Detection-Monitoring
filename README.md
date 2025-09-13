# End-to-End AWS Threat Detection & Monitoring System

## Project Overview
This project implements a **fully automated cloud threat detection and monitoring system** on AWS.  
It covers the full security pipeline — from **raw log collection** (CloudTrail) to **automated detection** (Athena + Lambda), **continuous monitoring** (GuardDuty + Security Hub), **real-time alerts** (EventBridge + SNS), and **visualization** (QuickSight).

---

## Features
- **Automated detection** of unusual login activity, high-risk actions, and resource changes.  
- **Event-driven alerts** through EventBridge + SNS.  
- **Visualization dashboards** in QuickSight for monitoring critical metrics.  
- **Simulated GuardDuty findings** for anomaly detection (IAM compromise, S3 exfiltration, EC2 compromise).  
- **Scheduled Lambda automation** to fetch and run Athena queries periodically.  
- Fully **end-to-end SOC pipeline** demonstration for learning and documentation purposes.

---

## Architecture
CloudTrail → S3 → Athena → Lambda → EventBridge (schedules queries) → S3 (results) → QuickSight
          ↘ GuardDuty → Security Hub → EventBridge (alerts) → SNS → Notifications

 - CloudTrail → S3: Raw log collection.
 - Athena → Lambda → EventBridge → S3: Automated detection; EventBridge schedules Lambda to run queries periodically.
 - QuickSight: Visualizes Athena query results.
 - GuardDuty → Security Hub → EventBridge → SNS: Detects anomalies and high-risk activity, sends real-time alerts.

---

## Repository Structure

```text
/aws-threat-detection-monitoring/
│── 1-Athena-Queries/              (SQL queries for CloudTrail analysis)
│     ├── 1-FailedLogins.sql
│     ├── 2-IAMChanges.sql
│     └── ...                      # Other queries
│
│── 2-Lambda/                      (Lambda functions for automation and Security Hub export)
│     ├── ThreatDetectionMonitoringLambda-aksh/
│     └── SecurityHub-s3/
│
│── 3-Athena-Results/              (CSV outputs generated from Athena query runs)
│     ├── 1-FailedLogins.csv
│     ├── 2-IAMChanges.csv
│     └── ...                      # Result files for all queries
│
│── 4-QuickSight-Screenshots/      (Exports of the 6 QuickSight dashboard visuals)
│     ├── 1-FailedLogins_Screenshot.png
│     ├── 2-IAMChanges_Screenshot.png
│     ├── 3-Region_Screenshot.png
│     ├── 4-TopSourceIPs_Screenshot.png
│     ├── 5-ErrorCode_Screenshot.png
│     └── 6-UserAgent_Screenshot.png
│
│── 5-Docs/
│     └── Documentation.docx       (Detailed documentation)
│
└── README.md                      (Main project overview and instructions)
```

---

## How To Run

### 1. CloudTrail Setup
- Enable CloudTrail for all regions.
- Ensure logs are delivered to your S3 bucket.

### 2. Athena Queries
- Use the `cloudtrail_logs` database and `cloudtrail_events` table.
- Place SQL files in the S3 folder `Athena-Queries`.
- **Core queries include:**
  1. Failed Logins / Brute Force Detection
  2. IAM Policy/Role Changes
  3. Root Account Usage
  4. Unusual Region Access
  5. Suspicious API Calls / High-Risk Actions
  6. Multiple Resource Deletions / Bulk Suspicious Changes
  7. Error Codes Analysis
  8. Top Source IPs
- Save Athena query results as CSV in S3 (`Athena-Results`).

### 3. Lambda Automation
- Deploy a Lambda function to **dynamically read SQL files from S3**.
- Run queries automatically on a schedule using **EventBridge** (e.g., every 15 minutes).
- Store results in S3 (`Lambda-Results`) automatically.
- This provides **end-to-end automation** without manual query execution.

### 4. GuardDuty & Security Hub
- Enable GuardDuty to detect threats like IAM compromise, S3 exfiltration, EC2 compromise.
- Enable Security Hub to consolidate findings.
- Security Hub findings can be optionally stored in S3 and visualized in QuickSight.

### 5. EventBridge + SNS Alerts
- Create EventBridge rules to capture GuardDuty findings.
- Forward alerts to an SNS topic.
- Subscribe via email/SMS to receive notifications in real-time.

### 6. QuickSight Dashboard
- Connect QuickSight to the Athena workgroup (`cloudtrail_logs`) and S3 datasets.
- Build visuals:
  - Failed Logins by Source IP
  - IAM Changes
  - Unusual Region Access
  - Top Source IPs
  - Error Code Distribution
  - User Agent Breakdown

---

## Results
**Key metrics from the current run (example from Sept 2025):**  
- Total Events: 31,100+  
- Failed Logins: 44  
- IAM Changes: 71
    - Includes only: CreateUser, DeleteUser, AttachRolePolicy, DetachRolePolicy  
- Error Codes Observed: 20+ distinct errors (ResourceNotFoundException, AccessDenied, InvalidRequestException)  
- GuardDuty & Security Hub Findings: Simulated alerts confirmed detection of IAM credential misuse, S3 data compromise, and EC2 compromise attempts  

> Note: Values are from a specific run. The pipeline works on **live CloudTrail logs**, so numbers will naturally change over time.

---

## Future Improvements
- Add **anomaly detection** using Amazon Detective or ML models.
- Integrate **SIEM tools** (Splunk, ELK) for hybrid monitoring.
- Automate **dashboard refresh** and alerting pipeline.

---

## Notes
- All experiments were performed in a safe AWS account.  
- Errors during setup (permissions, workgroup issues) were resolved.  
- IAM policies were updated to allow Lambda & QuickSight access to S3 buckets.  

---

## License
- This project is for **educational purposes**. No real or sensitive data was used.  
- Do not use in production without **proper security hardening**.

---

## Author
Akshayah N S (Sept 2025)


