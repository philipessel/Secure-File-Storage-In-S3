# Project Overview

This project brings together multiple AWS services and technologies to create a **secure**, **monitored**, and **role-based file storage system**.

## 1. Users Authenticate Through IAM Roles

- Users (Uploader, Viewer, Admin) assume their respective IAM roles using **temporary credentials** issued by **AWS STS**.
- A **Python script** handles role assumption and uses the credentials to request **pre-signed URLs**.

## 2. File Access is Performed via Pre-signed URLs

- Pre-signed URLs are generated using **Boto3** and provide **temporary**, **permission-bound access** to specific S3 objects.
- **Uploaders** can upload files (including large files via **multi-part upload**) into a **main S3 bucket**.
- **Viewers** can download files from the main S3 bucket.
- **Admins** have full control and can both upload and download files.

## 3. Amazon S3 Stores the Files Securely

- The S3 bucket has:
  - **Public access blocked**
  - **SSE-KMS encryption**
  - **Versioning enabled**
- **Multi-part uploads** ensure efficient transfer of large files.

## 4. Activity is Monitored and Logged

- All operations on the main S3 bucket are tracked by **AWS CloudTrail**.
  - CloudTrail records API activity and delivers logs to a **dedicated S3 bucket** for log storage.
- **Amazon CloudWatch Logs** ingest these logs for further analysis.

## 5. Alerts are Triggered for Abnormal Behaviour

- **CloudWatch Insights** queries detect patterns such as repeated failed uploads.
- **CloudWatch Alarms** are configured based on these metrics.
- For all API activities in the main S3 bucket, **AWS CloudTrail** triggers **Amazon SNS** to send notifications to administrators for immediate response.

## 6. Terraform Automates the Entire Setup

- All infrastructure is deployed and managed using **Terraform**, including:
  - S3
  - IAM roles and policies
  - KMS keys
  - CloudTrail
  - CloudWatch
  - SNS

This ensures **consistency**, **version control**, and **ease of maintenance**.

---

This architecture ensures that file storage is **secure**, **scalable**, and **monitored**. Users are given **controlled access**, and administrators have **full visibility** into system behaviour.
