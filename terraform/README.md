# Learn Terraform Code Organization

This repo is a companion repo to the [Learn Terraform Code Organization](https://developer.hashicorp.com/terraform/tutorials/modules/organize-configuration) tutorial.
It contains Terraform configuration you can use to learn best practices for Terraform as your organization grows.

# Setting Cloud Workspaces to run LOCAL via dashboard
https://developer.hashicorp.com/terraform/tutorials/cloud/cloud-migrate

# Upload entire directory upon any changes
https://www.packetswitch.co.uk/how-to-upload-multiple-files-to-aws-s3-bucket-using-terraform/

# Setting MIME Types for each file
Best example used file templates to infer content-type!!!
=> https://stackoverflow.com/questions/57456167/uploading-multiple-files-in-aws-s3-from-terraform
https://www.tangramvision.com/blog/abusing-terraform-to-upload-static-websites-to-s3

# Call to force local execution mode in workspace
https://github.com/hashicorp/terraform/issues/23261
```
TF_WORKSPACE="something"
MY_ORGANISATION="else"
TF_BACKEND_TOKEN="1234567890"
TF_URL="https://app.terraform.io/api/v2/organizations/${MY_ORGANISATION}/workspaces/${TF_WORKSPACE}"
terraform workspace new ${TF_WORKSPACE} && \
curl \
    --header "Authorization: Bearer ${TF_BACKEND_TOKEN}" \
    --header "Content-Type: application/vnd.api+json" \
    --request PATCH --data \
    '{"data": {"type": "workspaces", "attributes": {"execution-mode": "local"}}}' \
    ${TF_URL}
# ... later
terraform workspace select ${TF_WORKSPACE}
terraform apply -auto-approve
```

https://support.hashicorp.com/hc/en-us/articles/8025737055891-How-to-use-Local-execution-mode-by-default-via-the-terraform-workspace-command-