# Speech-to-Text API

Repository contains the code to deploy a wrapper around Google's Speech-to-Text API on the Google API Gateway. The API Gateway
service leverages a Cloud Run backend.

## Deploy Speech-to-Text manually

The Speech-to-Text backend in a simple Flask Application that was deployed to Cloud Run. 

The `services/api/scripts` directory includes a series of test scripts to:

### Local testing:

- Run the following scripts
    - `001_build_local.sh`: Build a local Docker image of the backend application
    - `002_run_local.sh`: Run the local Docker image of the application
    - `003_invoke_api.sh`: Invoke the text-to-speech endpoint of the backend application
    
### Create the API gateway:

- Run the following scripts
    - `010_push_to_gcr.sh`: Build the docker image and push it to Google Container Registry
    - `011_deploy_cloud_run.sh`: Deploy the docker image to Cloud Run`
    - `012_create_api.sh`: Create the API gateway API and API gateway config
    - `013_deploy_api.sh`: Deploy API gateway Gateway using the `speech-api.yaml
    - `014_invoke_remote.sh`: Invoke the remote version of the API gateway
    - `015_enable_security.sh`: Grant service ability to key management
    
> Note: various scripts contain hardcoded references to Terraform resources. Most of these
> were extracted into separate variables. Make sure that these reflect your own configuration.  
    
## Deploy the Speech-to-Text through Terraform

The repository also includes code to deploy the API using Terraform. The Terraform codebase
is merely a Proof-of-concept and is by no means final. Navigate to the `infrastructure/terraform` directory and complete the steps below:

1. Add an `acount.json` file to `infrastructure/terraform` containing SA credentials of a project owner
1. Run `terraform init` to initialize Terraform
1. Run `terraform plan` to inspect the plan generated by Terraform
1. Run `terraform apply --auto-approve` to apply the Terraform plan

> Note: the `services.tf` is best applied in a separate scope or project. Initial attempts
> to apply the Terraform may fail due to dependencies.

> Note: the `services.tf` includes a pointer to the API gateway service. The path to this service
> was currently hardcoded due to Terraform not exposing the service name. I'm currently unsure how
> this could be improved (did not investigate this in-depth).

> Note: the `speech-api.yaml` contains hardcoded references to Terraform. Ideally these should
> be injected via Terraform. There exists various libraries that could be used to this end.

 
 