# Terraform Templates
Terraform evolves at a rapid pace. Currently most articles and tutorials out there are not updated fast enough to keep up with the changes in the syntax. I spent hours reading the documentation when I dived into terraform for the first time. I always wished I had well commented snippets at my disposal for carrying out common tasks. So thats what this is. This repo will be regularly updated with new snippets, templates and will keep up with the changes and updates to the framework and its providers.

You can use these snippets to learn or you can combine them to create your own fully fledged complex templates. Feel free to contribute your own templates or links to external resources.

### Execution Steps
1. Download and install terraform from [terraform.io](https://terraform.io).
2. Run ``terraform init`` inside the directory housing your template configuration files.
3. The terraform cli will download and configure the provider used in the template files
4. Run ``terraform validate`` to validate the configuration
5. Run ``terraform plan`` to get a detailed report on what will be created, updated or destroyed by terraform
6. Use ``terraform plan -out=file`` to save the plan to a file. Useful when you want to apply specific plans in the future.
7. Run ``terraform apply`` to apply the configuration or run ``terraform apply planFile`` to apply a specific plan.
8. Run ``terraform destroy`` to destroy the deployed resources 
