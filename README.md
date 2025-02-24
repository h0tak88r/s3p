# S3P - S3 Permission Tester

**S3P (`s3p.sh`)** is a **bash script** that helps you test various **AWS S3 bucket permissions**, including:
- ✅ Read
- ✅ Write
- ✅ READ_ACP (Read Access Control List)
- ✅ WRITE_ACP (Write Access Control List)
- ✅ FULL_CONTROL

This tool is useful for **bug bounty hunters, security researchers, and developers** who want to check **bucket misconfigurations**.

---

## 📌 Features
✅ **Tests all major S3 permissions**  
✅ **Works with and without AWS credentials**  
✅ **Supports unauthenticated (`--no-sign-request`) mode**  
✅ **Provides clean, readable output**  
✅ **No duplicate or redundant results**  

---

## 📥 Installation
Clone the repository or download the script:
```sh
git clone https://github.com/h0tak88r/s3p.git
cd s3p
chmod +x s3p.sh
```

Or simply download:

curl -O https://your-website.com/s3p.sh && chmod +x s3p.sh

# 🚀 Usage

## Basic Usage

```sh
bash s3p.sh -b <bucket_name>
``
🔹 Example:

```sh
bash s3p.sh -b mobile-app-configuration-production
```
Test without authentication (--no-sign-request)

If you want to check publicly accessible buckets, use the -n flag:

```sh
bash s3p.sh -b <bucket_name> -n
```

🔹 Example:

```sh
bash s3p.sh -b mobile-app-configuration-production -n
```

# 🛠️ How It Works
	1.	Read Check - Tries to list bucket objects (aws s3 ls).
	2.	Write Check - Attempts to upload and delete a test file (aws s3 cp & aws s3 rm).
	3.	READ_ACP Check - Checks bucket ACL permissions (aws s3api get-bucket-acl).
	4.	WRITE_ACP Check - Attempts to modify the ACL (aws s3api put-bucket-acl).
	5.	FULL_CONTROL Check - Tests a combination of read, write, and ACL modifications.

# 📌 Example Output

```sh
📊 Testing S3 Bucket Permissions: test-bucket

🔍 Checking Read permission... ⏳ ✅ ALLOWED
🔍 Checking Write permission... ⏳ ❌ DENIED
🔍 Checking READ_ACP permission... ⏳ ❌ DENIED
🔍 Checking WRITE_ACP permission... ⏳ ❌ DENIED
🔍 Checking FULL_CONTROL permission... ⏳ ❌ DENIED

✅ Permission check complete.
```



# ⚠️ Disclaimer

This script is for educational and security testing purposes only.
Do not use it on unauthorized S3 buckets. The author is not responsible for any misuse.

🔗 Related Tools
	•	AWS CLI - Required for running the script
	•	YesWeHack - Abusing S3 Buckets - Reference for this tool

# 💡 Contributing

Feel free to submit issues, suggestions, or improvements via GitHub!
