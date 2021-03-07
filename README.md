# Speech-to-Text API

Repository contains the code to deploy a wrapper around Google's Speech-to-Text API on the Google API Gateway. The API Gateway
service leverages a Cloud Run backend.

## Deploy Speech-to-Text manually

The Speech-to-Text backend is a simple Flask Application that was deployed to Cloud Run. 

The `services/api/scripts` directory includes a series of test scripts to:

### Local testing:

- Run the following scripts
    - `001_build_local.sh`: Build a local Docker image of the backend application
    - `002_run_local.sh`: Run the local Docker image of the application
    - `003_invoke_api.sh`: Invoke the text-to-speech endpoint of the backend application
    
### Create the API gateway:

The API Gateway features two endpoints, i.e., `/hello` and `/v1/speech` respectively. The former 
leverages API key based authentication, while the latter uses service account based authentication.

- Run the following scripts
    - `010_push_to_gcr.sh`: Build the docker image and push it to Google Container Registry
    - `011_deploy_cloud_run.sh`: Deploy the docker image to Cloud Run
    - `012_create_api.sh`: Create the API gateway API and API gateway config
    - `013_deploy_api.sh`: Deploy API gateway Gateway using the `speech-api.yaml
    - `014_invoke_remote.sh`: Invoke the remote version of the API gateway
    - `015_enable_security.sh`: Grant service ability to key management
    
> Note: various scripts contain hardcoded references to Terraform resources. Most of these
> were extracted into separate variables. Make sure that these reflect your own configuration.

### Important pitfalls  

#### Service Account Authentication

The authentication strategy specified in [the OpenAPI documentation](https://cloud.google.com/endpoints/docs/openapi/authenticating-users-google-id) appears to be invalid. Token based authentication for a
Service Account can be enabled using the following security definition:

```yaml
securityDefinitions:
  google_service_account:
    authorizationUrl: ""
    flow: "implicit"
    type: "oauth2"
    x-google-issuer: "SERVICE_ACCOUNT_EMAIL"
    x-google-jwks_uri: "https://www.googleapis.com/robot/v1/metadata/x509/SERVICE_ACCOUNT_EMAIL"
    x-google-audiences: "AUDIENCE"
```

Make sure to replace the `SERVICE_ACCOUNT_EMAIL` occurrences above with the email of the service account that you intend to use. Additionally, replace `CLOUD_RUN_INSTANCE` with anything arbitrary. The only requirement is that this should match the audience in
the JWT.

To generate a JWT with access to the API, execute the command below. The resulting token should be included in the HTTP authentication header.

```bash
python jwt_token_gen.py \
    --file=${PATH_TO_SERVICE_ACCOUNT_CREDENTIALS} \
    --audiences=${AUDIENCE} \
    --issuer=${SERVICE_ACCOUNT_EMAIL}
```

#### API Key Authentication

GCP features a [video tutorial](https://www.youtube.com/watch?v=MhZ99z6TsJA) on enabling API key authentication
on API gateways. Unfortunately, the video does _not_ include the following security block.

```yaml
securityDefinitions:
  api_key:
    type: "apiKey"
    name: "key"
    in: "query"
```

To access the API with API key security enabled, add the `key=${TOKEN}` query argument when invoking the API.

    
## Deploy the Speech-to-Text through Terraform

The repository also includes code to deploy the API using Terraform. The Terraform codebase
is merely a Proof-of-concept and is by no means final. Refer to `doc/text-to-speech.png` for a visual representation of the deployment.

1. Navigate to the `infrastructure/terraform` directory
1. Adjust the `terraform.tfvars` to reflect your project
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

> Note: the deployment assumes that the `speech-to-text` Container Registry image is deployed via 
> a separate CI/CD pipeline. Hence, the Cloud Run resource references a hardcoded GCR image. Before deploying
> make sure that the image exists, this can be done by executing script `010_push_to_gcr.sh`.

> Note: the versioning strategy for the API gateway is not entirely clear to me yet. When updating `speech-api.yaml` the
> Terraform provider attempts to create a new version of the configuration. A possible solution may be 
> to version the configuration (did not investigate this in-depth).
 
 