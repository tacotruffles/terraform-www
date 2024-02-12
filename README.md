# Configure and Stand Up WWW

## Pattern

A basic basic React.js app to demonstrate the CI/CD pipeline via Terraform:

* An S3 bucket configured for static web site
* Route53 host for full domain name
* Deployed behind CloudFront for faster load times across the Internet and forced SSL url
* SSL certicate for full domain name

## Teardown Process

1. Create the following branch name to tear down the corresponding environment: i.e. `destroy-stage` or `destroy-prod`
2. All S3 upload buckets will be preserved so it can be imported later
3. DBs are not created as part of the Terraform Infrastruce so the same connection strings is used to stand data back up
4. The state file buckets are untouched as they were created with a sepereate Terraform processing on the `seed` branch so re-seeding will not be necessary to recover staging or production.