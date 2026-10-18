# 🔧 AWS CLI Cheat Sheet

## 📋 Services Overview

- **S3** – Object storage service for storing and retrieving data.
- **SQS** – Simple Queue Service for message queuing and decoupling applications.
- **SNS** – Simple Notification Service for sending messages and notifications.

---

## 📦 S3 (Simple Storage Service)

### Bucket Operations:

- `aws s3 ls` – List all S3 buckets.
- `aws s3 mb s3://bucket-name` – Create a new bucket.
- `aws s3 rb s3://bucket-name` – Delete an empty bucket.
- `aws s3 rb s3://bucket-name --force` – Delete bucket and all contents.
- `aws s3api get-bucket-versioning --bucket bucket-name` – Check versioning status.
- `aws s3api put-bucket-versioning --bucket bucket-name --versioning-configuration Status=Enabled` – Enable versioning.

### Object Operations:

- `aws s3 ls s3://bucket-name` – List objects in a bucket.
- `aws s3 ls s3://bucket-name --recursive` – List all objects recursively.
- `aws s3 cp file.txt s3://bucket-name/` – Upload a file.
- `aws s3 cp s3://bucket-name/file.txt .` – Download a file.
- `aws s3 cp s3://bucket-name/file.txt s3://bucket-name2/` – Copy between buckets.
- `aws s3 mv s3://bucket-name/file.txt s3://bucket-name2/` – Move object between buckets.
- `aws s3 rm s3://bucket-name/file.txt` – Delete a file.
- `aws s3 rm s3://bucket-name --recursive` – Delete all objects in bucket.
- `aws s3 sync local-folder/ s3://bucket-name/` – Sync local folder to S3.
- `aws s3 sync s3://bucket-name/ local-folder/` – Sync S3 to local folder.

### Object Metadata & Details:

- `aws s3api head-object --bucket bucket-name --key object-key` – Get object metadata.
- `aws s3api get-object-acl --bucket bucket-name --key object-key` – Get object ACL.
- `aws s3api put-object-acl --bucket bucket-name --key object-key --acl public-read` – Set object ACL.
- `aws s3api list-object-versions --bucket bucket-name` – List all object versions.

### Bucket Policies & Access:

- `aws s3api get-bucket-policy --bucket bucket-name` – Get bucket policy.
- `aws s3api put-bucket-policy --bucket bucket-name --policy file://policy.json` – Set bucket policy.
- `aws s3api delete-bucket-policy --bucket bucket-name` – Delete bucket policy.
- `aws s3api put-bucket-acl --bucket bucket-name --acl private` – Set bucket ACL.

---

## 📨 SQS (Simple Queue Service)

### Queue Operations:

- `aws sqs create-queue --queue-name queue-name` – Create a new queue.
- `aws sqs list-queues` – List all queues.
- `aws sqs list-queues --queue-name-prefix prefix` – List queues with specific prefix.
- `aws sqs delete-queue --queue-url queue-url` – Delete a queue.
- `aws sqs get-queue-url --queue-name queue-name` – Get queue URL.
- `aws sqs get-queue-attributes --queue-url queue-url --attribute-names All` – Get all queue attributes.
- `aws sqs set-queue-attributes --queue-url queue-url --attributes VisibilityTimeout=30` – Set queue attributes.

### Message Operations:

- `aws sqs send-message --queue-url queue-url --message-body "message text"` – Send a single message.
- `aws sqs send-message-batch --queue-url queue-url --entries file://messages.json` – Send multiple messages.
- `aws sqs receive-message --queue-url queue-url` – Receive a message from queue.
- `aws sqs receive-message --queue-url queue-url --max-number-of-messages 10` – Receive up to 10 messages.
- `aws sqs receive-message --queue-url queue-url --wait-time-seconds 20` – Long polling (wait up to 20 seconds).
- `aws sqs delete-message --queue-url queue-url --receipt-handle receipt-handle` – Delete a message.
- `aws sqs delete-message-batch --queue-url queue-url --entries file://delete-batch.json` – Delete multiple messages.
- `aws sqs change-message-visibility --queue-url queue-url --receipt-handle receipt-handle --visibility-timeout 60` – Change message visibility timeout.

### Queue Monitoring:

- `aws sqs get-queue-attributes --queue-url queue-url --attribute-names ApproximateNumberOfMessages` – Get message count.
- `aws sqs get-queue-attributes --queue-url queue-url --attribute-names ApproximateAgeOfOldestMessage` – Get oldest message age.

---

## 🔔 SNS (Simple Notification Service)

### Topic Operations:

- `aws sns create-topic --name topic-name` – Create a new topic.
- `aws sns list-topics` – List all topics.
- `aws sns delete-topic --topic-arn topic-arn` – Delete a topic.
- `aws sns get-topic-attributes --topic-arn topic-arn` – Get topic attributes.
- `aws sns set-topic-attributes --topic-arn topic-arn --attribute-name DisplayName --attribute-value "My Topic"` – Set topic attributes.
- `aws sns list-subscriptions` – List all subscriptions.
- `aws sns list-subscriptions-by-topic --topic-arn topic-arn` – List subscriptions for a topic.

### Publishing Messages:

- `aws sns publish --topic-arn topic-arn --message "message text"` – Publish a message to topic.
- `aws sns publish --topic-arn topic-arn --message "message text" --subject "subject"` – Publish with subject line.
- `aws sns publish --phone-number +1234567890 --message "message text"` – Send SMS directly to phone number.
- `aws sns publish --target-arn endpoint-arn --message "message text"` – Publish to mobile app endpoint.

### Subscription Operations:

- `aws sns subscribe --topic-arn topic-arn --protocol email --notification-endpoint user@example.com` – Subscribe email to topic.
- `aws sns subscribe --topic-arn topic-arn --protocol sqs --notification-endpoint queue-arn` – Subscribe SQS queue to topic.
- `aws sns subscribe --topic-arn topic-arn --protocol sms --notification-endpoint +1234567890` – Subscribe phone number to topic.
- `aws sns subscribe --topic-arn topic-arn --protocol https --notification-endpoint https://example.com/endpoint` – Subscribe HTTPS endpoint to topic.
- `aws sns unsubscribe --subscription-arn subscription-arn` – Unsubscribe from topic.
- `aws sns set-subscription-attributes --subscription-arn subscription-arn --attribute-name FilterPolicy --attribute-value file://filter.json` – Set subscription filter policy.

### Subscription Management:

- `aws sns get-subscription-attributes --subscription-arn subscription-arn` – Get subscription attributes.
- `aws sns set-subscription-attributes --subscription-arn subscription-arn --attribute-name RawMessageDelivery --attribute-value true` – Enable raw message delivery.

---

## 🚀 Advanced & Useful Tips

### S3 Advanced:

- `aws s3 cp s3://bucket-name/file.txt . --sse-c-algorithm AES256 --sse-c-key key-string` – Download with encryption.
- `aws s3api put-object --bucket bucket-name --key object-key --body local-file --metadata key1=value1,key2=value2` – Upload with metadata.
- `aws s3api get-object --bucket bucket-name --key object-key --response-content-disposition attachment output.txt` – Download with custom filename.
- `aws s3api list-multipart-uploads --bucket bucket-name` – List in-progress multipart uploads.

### SQS Advanced:

- `aws sqs send-message --queue-url queue-url --message-body "message" --delay-seconds 300` – Delay message by 5 minutes.
- `aws sqs send-message --queue-url queue-url --message-body "message" --message-group-id group-id` – Send to FIFO queue.
- `aws sqs purge-queue --queue-url queue-url` – Delete all messages from queue.

### SNS Advanced:

- `aws sns create-platform-application --name app-name --platform APNS --attributes PlatformCredential=certificate` – Create mobile app platform.
- `aws sns create-platform-endpoint --platform-application-arn app-arn --token device-token` – Register device for push notifications.
- `aws sns publish --topic-arn topic-arn --message file://message.txt` – Publish message from file.

### Cross-Service Integration:

- `aws sns subscribe --topic-arn topic-arn --protocol sqs --notification-endpoint queue-arn` – Connect SNS to SQS.
- `aws sqs set-queue-attributes --queue-url queue-url --attributes Policy=file://policy.json` – Set SQS queue policy for SNS.

---

## 📌 Common ARN Formats

- **S3 Bucket** – `arn:aws:s3:::bucket-name`
- **S3 Object** – `arn:aws:s3:::bucket-name/object-key`
- **SQS Queue** – `arn:aws:sqs:region:account-id:queue-name`
- **SNS Topic** – `arn:aws:sns:region:account-id:topic-name`
- **SNS Subscription** – `arn:aws:sns:region:account-id:topic-name:subscription-id`

---

## 🔐 General AWS CLI Tips

- `aws configure` – Set up AWS credentials and default region.
- `aws s3 --version` – Check AWS CLI version.
- `aws s3api help` – Get help for specific service commands.
- `aws s3 --debug` – Enable debug logging for troubleshooting.
- `--profile profile-name` – Use specific AWS profile for command.
- `--region region-name` – Override default region for command.
- `--output json|table|text` – Change output format.
