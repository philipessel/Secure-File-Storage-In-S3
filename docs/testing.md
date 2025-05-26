# 🔍 Testing the Application (Running Python Script)

Our Python script contains the logic that allows **Security Token Services (STS)** to assume three main roles:

### 👤 Uploader-Role  
- Allows a user to upload files into an S3 bucket through a **pre-signed URL**.  
- **Single-part upload** is used when files are less than 20MB.  
- **Multi-part upload** is used when files are above 20MB.

### 👤 Viewer-Role  
- Allows a user to **download** files from the S3 bucket through a **pre-signed URL**.

### 👤 Admin-Role  
- Gives full access to the S3 bucket.  
- Allows **direct upload** and **direct download** without using a pre-signed URL.

We’ll test whether each of these functionalities is working as expected.

---

## 🖥️ Getting Started in VS Code

1. Open **PowerShell terminal** in VS Code.  
2. Navigate to the directory where the `s3-access-script.py` file is saved.

---

## 1️⃣ Test Upload via Pre-signed URL (Uploader-Role) — Single-part Upload

> **Note**: Use files **less than 20MB**. Uploader can only upload via **pre-signed URL**.

### Steps:
> **Run**
```bash
python s3-access-script.py
```
- Choose the `upload` option.
- Enter the **filename** to be stored in S3 (e.g., `test_upload.txt`).
- Enter the **path to your local file** (e.g., `C:\Users\user\Desktop\confusion.docx`).
- Copy the **generated pre-signed URL**.
- Open a new terminal window and upload using `curl`:

```bash
curl.exe -X PUT -T C:\path\to\your\file "PRESIGNED_URL"
```

> Replace:
> - `C:\path\to\your\file` with the actual local file path.  
> - `"PRESIGNED_URL"` with the generated pre-signed URL.

### ✅ Verify:
Go to your **S3 bucket** in the AWS Console and confirm the file was uploaded.

---

## 2️⃣ Test Upload via Pre-signed URL (Uploader-Role) — Multi-part Upload

> **Note**: Use files **larger than 20MB**.

### Steps:
> **Run**
```bash
python s3-access-script.py
```
- Choose the `upload` option.
- Enter the **filename in S3** (e.g., `video.mp4`).
- Enter the **path to the local file** (e.g., `C:\Users\user\Desktop\video.mp4`).
- Multi-part upload begins. When completed, the **ETag** is outputted.

### ✅ Verify:
Check the file in your **S3 bucket** using the AWS Console.

---

## 3️⃣ Test Download via Pre-signed URL (Viewer-Role)

> **Note**: Viewer can only download via **pre-signed URL**.

### Steps:
> **Run**
```bash
python s3-access-script.py
```
- Choose the `download` option.
- Enter the **filename in S3** (e.g., `test_upload.txt`).
- Copy the **generated pre-signed URL**.
- Open a new terminal and run:

```bash
curl.exe "PRESIGNED_URL" -o downloaded_file
```

> Replace `"PRESIGNED_URL"` with the actual URL.

### ✅ Verify:
- The file is saved as `downloaded_file` in the same directory where the python script is located.
- Navigate to the folder and open it to confirm.

---

## 4️⃣ Test Direct Upload (Admin-Role)

> **Note**: Admin has **full access**. Uploads are direct—no pre-signed URL is used.  
> `upload_file()` from Boto3 handles multi-part upload **automatically** if needed.

### Steps:
> **Run**
```bash
python s3-access-script.py
```
- Choose `admin-upload`.
- Enter the **filename in S3** (e.g., `test_upload.txt`).
- The file is uploaded **directly**.

### ✅ Verify:
Check the file in your **S3 bucket** on the AWS Console.

---

## 5️⃣ Test Direct Download (Admin-Role)

> **Note**: Admin downloads are **direct**—no pre-signed URL is used.

### Steps:
> **Run**
```bash
python s3-access-script.py
```
- Choose `admin-download`.
- Enter the **filename in S3** (e.g., `test_upload.txt`).
- The file is downloaded directly.

### ✅ Verify:
- The file is saved as `downloaded_file` in the same directory where the python script is located.
- Open the file to confirm its contents.
