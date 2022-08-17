# Hosting static websites on AWS with Terraform

A Terraform Module to host static files in AWS using S3, Route53, ACM, CloudFront and WAF for whitelisting IPs

Configuration Notes

1. Configure the AWS Provider to work with your environment
2. This module generates a AWS SSL Certificate. It assumes you are hosting your Domain in Route53 so we can use DNS verification. If you have your own certificate already, insert the ARN in the file cloudfront.tf
3. In main.tf configure the 3 variables needed for the module to work

    ```domain_name  =  "abcd.com"```

    ```bucket_name  =  "abc-123"```

    ```ip-addresses  =  ["10.10.10.10/32"]```
    
Keep in mind that:
 
a) The S3 Bucket name must be unique 
	
b) Your website will be bucket_name.domain_name
	
c) ```ip-addresses``` is a comma separated list
