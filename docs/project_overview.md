## Project Overview

The **Secure File Storage in S3** project is a cloud-native solution built on **Amazon Web Services (AWS)** that offers encrypted, auditable, and role-based file storage. It enables three types of users — **Uploaders**, **Viewers**, and **Admins** — to interact securely with an S3 bucket using **pre-signed URLs**. This approach ensures access control without exposing AWS credentials or granting direct access to the bucket.

Infrastructure is provisioned using **Terraform**, ensuring consistent and automated deployment through Infrastructure as Code (IaC). The system incorporates:

- **AWS Key Management Service (KMS)** for encryption  
- **AWS CloudTrail** for activity logging  
- **CloudWatch** with **SNS** for real-time alerts  

Together, these form a secure and resilient architecture by design.

A notable feature is support for **multipart uploads**, allowing large files to be uploaded in smaller, manageable chunks. This improves performance, increases reliability, and enables users to resume uploads if interrupted.

---

## Security at the Core

Security is a foundational principle of this project. Key measures include:

- **IAM roles** with least privilege access to restrict user capabilities  
- **Pre-signed URLs** to control and limit access to S3 resources by time and operation  
- **SSE-KMS encryption** for protecting data at rest  
- **CloudTrail logs** and **CloudWatch alerts** for proactive monitoring and auditing  

---

## Real-World Motivation

This project was driven by the growing need for secure file-sharing solutions in industries that handle sensitive information — such as legal, healthcare, and finance.

As someone pursuing a career in **cloud security and automation**, I set out to demonstrate how to design a **secure**, **auditable**, and **scalable** storage system using native AWS services and modern DevOps practices. The result is a solution that prioritizes:

- **Access control**  
- **Compliance readiness**  
- **Operational transparency**  
