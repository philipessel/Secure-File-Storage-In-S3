import boto3
import os
from botocore.exceptions import ClientError
import math
import requests
from dotenv import load_dotenv

load_dotenv()  # Load environment variables from .env file


# Configuration

BUCKET_NAME = os.environ.get("S3_BUCKET_NAME")
AWS_REGION = os.environ.get("AWS_REGION")
UPLOADER_ROLE_ARN = os.environ.get("UPLOADER_ROLE_ARN")
VIEWER_ROLE_ARN = os.environ.get("VIEWER_ROLE_ARN")
ADMIN_ROLE_ARN = os.environ.get("ADMIN_ROLE_ARN")

# Initialize STS and S3 clients
sts_client = boto3.client('sts', region_name=AWS_REGION)
s3_client = boto3.client('s3', region_name=AWS_REGION)

def assume_role(role_arn, role_session_name="local-script-session"):
    """Assumes an IAM role and returns temporary credentials."""
    try:
        response = sts_client.assume_role(
            RoleArn=role_arn,
            RoleSessionName=role_session_name
        )
        return response['Credentials']
    except ClientError as e:
        print(f"Error assuming role {role_arn}: {e}")
        return None

def generate_upload_presigned_url(bucket_name, object_name, credentials, expiration=3600):
    """Generates a presigned URL for uploading an object using Signature Version 4."""
    s3_client_assumed = boto3.client(
        's3',
        region_name=AWS_REGION,
        aws_access_key_id=credentials['AccessKeyId'],
        aws_secret_access_key=credentials['SecretAccessKey'],
        aws_session_token=credentials['SessionToken'],
        config=boto3.session.Config(signature_version='s3v4')  # Explicitly set signature version
    )
    try:
        presigned_url = s3_client_assumed.generate_presigned_url(
            'put_object',
            Params={'Bucket': bucket_name, 'Key': object_name},
            ExpiresIn=expiration
        )
        return presigned_url
    except ClientError as e:
        print(f"Error generating upload presigned URL: {e}")
        return None

def generate_download_presigned_url(bucket_name, object_name, credentials, expiration=3600):
    """Generates a presigned URL for downloading an object using Signature Version 4."""
    s3_client_assumed = boto3.client(
        's3',
        region_name=AWS_REGION,
        aws_access_key_id=credentials['AccessKeyId'],
        aws_secret_access_key=credentials['SecretAccessKey'],
        aws_session_token=credentials['SessionToken'],
        config=boto3.session.Config(signature_version='s3v4')  # Explicitly set signature version
    )
    try:
        presigned_url = s3_client_assumed.generate_presigned_url(
            'get_object',
            Params={'Bucket': bucket_name, 'Key': object_name},
            ExpiresIn=expiration
        )
        return presigned_url
    except ClientError as e:
        print(f"Error generating download presigned URL: {e}")
        return None

def upload_file_direct(bucket_name, object_name, file_path, credentials):
    """Uploads a file directly to S3 using assumed role credentials."""
    s3_resource_assumed = boto3.resource(
        's3',
        region_name=AWS_REGION,
        aws_access_key_id=credentials['AccessKeyId'],
        aws_secret_access_key=credentials['SecretAccessKey'],
        aws_session_token=credentials['SessionToken']
    )
    try:
        s3_resource_assumed.Bucket(bucket_name).upload_file(file_path, object_name)
        print(f"File '{object_name}' uploaded successfully to '{bucket_name}'")
        return True
    except ClientError as e:
        print(f"Error uploading file '{object_name}': {e}")
        return False

def download_file_direct(bucket_name, object_name, file_path, credentials):
    """Downloads a file directly from S3 using assumed role credentials."""
    s3_resource_assumed = boto3.resource(
        's3',
        region_name=AWS_REGION,
        aws_access_key_id=credentials['AccessKeyId'],
        aws_secret_access_key=credentials['SecretAccessKey'],
        aws_session_token=credentials['SessionToken']
    )
    try:
        s3_resource_assumed.Bucket(bucket_name).download_file(object_name, file_path)
        print(f"File '{object_name}' downloaded successfully to '{file_path}'")
        return True
    except ClientError as e:
        print(f"Error downloading file '{object_name}': {e}")
        return False

def initiate_multipart_upload(bucket_name, object_name, credentials):
    """Initiates a multipart upload and returns the UploadId using Signature Version 4."""
    s3_client_assumed = boto3.client(
        's3',
        region_name=AWS_REGION,
        aws_access_key_id=credentials['AccessKeyId'],
        aws_secret_access_key=credentials['SecretAccessKey'],
        aws_session_token=credentials['SessionToken'],
        config=boto3.session.Config(signature_version='s3v4')  # Explicitly set signature version
    )
    try:
        response = s3_client_assumed.create_multipart_upload(Bucket=bucket_name, Key=object_name)
        return response['UploadId']
    except ClientError as e:
        print(f"Error initiating multipart upload: {e}")
        return None

def generate_multipart_upload_presigned_url(bucket_name, object_name, upload_id, part_number, credentials, expiration=3600):
    """Generates a presigned URL for uploading a specific part of a multipart upload using Signature Version 4."""
    s3_client_assumed = boto3.client(
        's3',
        region_name=AWS_REGION,
        aws_access_key_id=credentials['AccessKeyId'],
        aws_secret_access_key=credentials['SecretAccessKey'],
        aws_session_token=credentials['SessionToken'],
        config=boto3.session.Config(signature_version='s3v4')  # Explicitly set signature version
    )
    try:
        presigned_url = s3_client_assumed.generate_presigned_url(
            'upload_part',
            Params={'Bucket': bucket_name, 'Key': object_name, 'UploadId': upload_id, 'PartNumber': part_number},
            ExpiresIn=expiration
        )
        return presigned_url
    except ClientError as e:
        print(f"Error generating presigned URL for part {part_number}: {e}")
        return None

def complete_multipart_upload(bucket_name, object_name, upload_id, parts, credentials):
    """Completes the multipart upload using Signature Version 4."""
    s3_client_assumed = boto3.client(
        's3',
        region_name=AWS_REGION,
        aws_access_key_id=credentials['AccessKeyId'],
        aws_secret_access_key=credentials['SecretAccessKey'],
        aws_session_token=credentials['SessionToken'],
        config=boto3.session.Config(signature_version='s3v4')  # Explicitly set signature version
    )
    try:
        response = s3_client_assumed.complete_multipart_upload(
            Bucket=bucket_name,
            Key=object_name,
            UploadId=upload_id,
            MultipartUpload={'Parts': parts}
        )
        print(f"Multipart upload of '{object_name}' completed. ETag: {response.get('ETag')}")
        return True
    except ClientError as e:
        print(f"Error completing multipart upload: {e}")
        return False


if __name__ == "__main__":
    action = input("Enter action (upload/download/admin-upload/admin-download): ").lower()
    filename = input("Enter filename in S3: ")
    role_to_assume = None
    # ======================================================================== multipart upload starts here.
    if action == "upload":
        role_to_assume = UPLOADER_ROLE_ARN
        credentials = assume_role(role_to_assume)
        if credentials:
            local_file_path = input("Enter the path to the local file to upload: ")
            file_size = os.path.getsize(local_file_path)
            upload_threshold = 20 * 1024 * 1024  # 20MB

            if file_size >= upload_threshold:
                upload_id = initiate_multipart_upload(BUCKET_NAME, filename, credentials)
                if upload_id:
                    parts = []
                    chunk_size = 5 * 1024 * 1024
                    num_chunks = math.ceil(file_size / chunk_size)
                    with open(local_file_path, 'rb') as f:
                        for i in range(1, num_chunks + 1):
                            chunk = f.read(chunk_size)
                            if not chunk:
                                break
                            presigned_url = generate_multipart_upload_presigned_url(
                                BUCKET_NAME, filename, upload_id, i, credentials
                            )
                            if presigned_url:
                                # Instead of just printing the URL, you would need to:
                                # 1. Perform the PUT request to upload the part using the presigned_url and the chunk data.
                                # 2. Store the ETag of the uploaded part.
                                # 3. Print feedback to the user about the progress.
                                try:
                                    headers = {'Content-Length': str(len(chunk))}
                                    response = requests.put(presigned_url, data=chunk, headers=headers)
                                    response.raise_for_status()
                                    parts.append({'PartNumber': i, 'ETag': response.headers['ETag']})
                                    print(f"Uploaded part {i}/{num_chunks}")
                                except requests.exceptions.RequestException as e:
                                    print(f"Error uploading part {i}: {e}")
                                    break
                            else:
                                print(f"Failed to generate presigned URL for part {i}")
                                break

                    if len(parts) == num_chunks:
                        complete_multipart_upload(BUCKET_NAME, filename, upload_id, parts, credentials)
                    else:
                        print("Multipart upload failed.")
                else:
                    print("Failed to initiate multipart upload.")
            else:
                # Single-part upload as before
                presigned_url = generate_upload_presigned_url(BUCKET_NAME, filename, credentials)
                if presigned_url:
                    print(f"Presigned URL for upload: {presigned_url}")
                    print("Use an HTTP PUT request to this URL to upload your file.")
                    print("Example using curl: curl.exe -X PUT -T /path/to/your/local/file \"{}\"".format(presigned_url))
    # ======================================================================== multipart upload ends here
    # ======================================================================== download starts here
    elif action == "download":
        role_to_assume = VIEWER_ROLE_ARN
        credentials = assume_role(role_to_assume)
        if credentials:
            presigned_url = generate_download_presigned_url(BUCKET_NAME, filename, credentials)
            if presigned_url:
                print(f"Presigned URL for download: {presigned_url}")
                print("Use an HTTP GET request to this URL to download the file.")
                print("Example using curl: curl.exe \"{}\" -o downloaded_file".format(presigned_url))
    elif action == "admin-upload":
        role_to_assume = ADMIN_ROLE_ARN
        credentials = assume_role(role_to_assume)
        if credentials:
            local_file_path = input("Enter local file path to upload: ")
            upload_file_direct(BUCKET_NAME, filename, local_file_path, credentials)
    elif action == "admin-download":
        role_to_assume = ADMIN_ROLE_ARN
        credentials = assume_role(role_to_assume)
        if credentials:
            local_file_path = input("Enter local file path to save to: ")
            download_file_direct(BUCKET_NAME, filename, local_file_path, credentials)
    else:
        print("Invalid action.")

 # ================================================================================== Download ends here==
 
 