# Speech-to-Text API

Repository contains the code to deploy a wrapper around Google's Speech-to-Text API on the Google API Gateway. The API Gateway
service leverages a Cloud Run backend. The image below visualizes the final deployment.

![alt text](https://github.com/LaurensVijnck/speech-api/blob/main/doc/speech-to-text.png?raw=true)

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

> Note: the scripts outlined above do not adhere the principle of least privilege to simplify testing. The
> Terraform code, on the other hand, maintains this security principle.

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

Make sure to replace the `SERVICE_ACCOUNT_EMAIL` occurrences above with the email of the service account that you intend to use. Additionally, replace `AUDIENCE` with anything arbitrary. The only requirement is that this should match the audience in
the YAML file describing the API Gateway configuration.

To generate a JWT with access to the API, execute the command below. The resulting token should be included in the HTTP authentication header. The `jwt_token_gen.py` source
code can be found in the `services/api/` directory.

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

To access the API with API key security enabled, execute the command below. Ensure that `GATEWAY_ENDPOINT_PATH` is a valid endpoint
as defined by the gateway configuration.

```bash
curl ${GATEWAY_ENDPOINT_PATH}?key=${TOKEN}
```
    
## Deploy the Speech-to-Text through Terraform

1. Navigate to the `infrastructure/terraform` directory
1. Adjust the `terraform.tfvars` to reflect your project
1. Add an `acount.json` file to `infrastructure/terraform` containing SA credentials of a project owner
1. Run `terraform init` to initialize Terraform
1. Run `terraform apply -target module.gcp_services` to enable the relevant GCP services
1. Run `terraform apply -target module.speech-api` to deploy the resources of the Speech API
1. Run `terraform apply -target module.custom_services` to enable the custom created service

### Known limitations

- The deployment assumes that the `speech-to-text` Container Registry image is deployed via 
a separate CI/CD pipeline. Hence, the Cloud Run resource references a hardcoded GCR image. Before deploying
make sure that the image exists, this can be done by executing script `010_push_to_gcr.sh`.

- The versioning strategy for the API gateway is not entirely clear to me yet. When updating `speech-api.yaml` the 
Terraform provider attempts to create a new version of the configuration. A possible solution may be 
to version the configuration (did not investigate this in-depth). The current work around is to delete the getaway and config
manually and re-apply Terraform hereafter.
 
 
