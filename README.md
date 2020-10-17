# AWS-S3-CRR-Using-TF
Amazon S3 Cross Region Replication Using Terraform

S3 Replication
	- S3 replication can be "Cross Region Replication (CRR)" or "Same Region Replication (SRR)". 
	- MUST enable version on source and destination
	- Buckets can be in different AWS accounts
	- Copying is asynchronous 
	- Must have proper IAM permissions to S3.  

CRR Use Cases:  Compliance, lower latency access replication across accounts.
SRR Use Cases:  Log aggregation, live replication between prod and lower environments. 

There is no "chaining" of replication.  Means, if bucket A is replicated to bucket B which has replication into bucket C, then objects created in bucket A are not replicated to bucket C. 

After activating replication, if bucket is an existing one then only new objects will be replicated. 
ANY DELETE ACTION WILL NOT BE REPLICATED TO DESTINATION BUCKET
Object Locking MUST NOT be enabled !
