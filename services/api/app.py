# FUTURE: Use GRPc driven, proto based, API.
import os
import time

import google.auth.crypt
import google.auth.jwt

from flask import Flask, request, jsonify
from werkzeug.utils import secure_filename
from werkzeug.exceptions import BadRequest

from google.cloud import speech

# Configuration
app = Flask(__name__)
app.config['MAX_CONTENT_LENGTH'] = 2048 * 2048
app.config['UPLOAD_EXTENSIONS'] = ['.wav']
app.config['SUPPORTED_LANGUAGE_CODES'] = ['en-US']


@app.route("/auth")
def auth():
    """Generates a signed JSON Web Token using a Google API Service Account."""

    sa_email = 'account@project-id.iam.gserviceaccount.com',
    audience = 'your-service-name',
    expiry_length = 3600
    now = int(time.time())

    # build payload
    payload = {
        'iat': now,
        # expires after 'expiry_length' seconds.
        "exp": now + expiry_length,
        # iss must match 'issuer' in the security configuration in your
        # swagger spec (e.g. service account email). It can be any string.
        'iss': sa_email,
        # aud must be either your Endpoints service name, or match the value
        # specified as the 'x-google-audience' in the OpenAPI document.
        'aud': audience,
        # sub and email should match the service account's email address
        'sub': sa_email,
        'email': sa_email
    }

    # sign with keyfile
    signer = google.auth.crypt.RSASigner.from_service_account_file(sa_keyfile)
    jwt = google.auth.jwt.encode(signer, payload)

    return jwt


@app.route('/hello')
def hello_world():
    target = os.environ.get('TARGET', 'World')
    print(request.headers)
    return jsonify('Hello {}!\n'.format(target))


@app.route('/v2/speech', methods=['POST'])
def speech_to_text_json():
    """
     Octet-centric approach to speech to text.

     :return: JSON representation of the transcripts
     """
    try:
        raw_data = request.get_data()
        return jsonify(submit_speech_api_request(raw_data))
    except:
        raise BadRequest(f"Invalid request.")


@app.route('/v1/speech', methods=['POST'])
def speech_to_text():
    """
    Form-centric approach to speech to text.

    :return: JSON representation of the transcripts
    """

    # Validate presence of speech file
    if 'speech_file' in request.files:

        # Extract file
        uploaded_file = request.files['speech_file']
        filename = secure_filename(uploaded_file.filename)
        file_ext = os.path.splitext(filename)[1]

        # Validate file extension
        if file_ext not in app.config["UPLOAD_EXTENSIONS"]:
            app.logger.error(f"Encountered invalid extension '{file_ext}'.")
            raise BadRequest(f"Invalid file extension '{file_ext}' (supported extensions: {', '.join(app.config['UPLOAD_EXTENSIONS'])})")

        # Validate language code
        app.logger.error(request.form)
        language_code = request.form.get("language_code", "en-US")
        if language_code not in app.config["SUPPORTED_LANGUAGE_CODES"]:
            raise BadRequest(f"Invalid language code '{language_code}' (supported languages codes: {', '.join(app.config['SUPPORTED_LANGUAGE_CODES'])})")

        # FUTURE: Set content type application-wide
        return jsonify(submit_speech_api_request(uploaded_file.read(), language_code))

    app.logger.error(f"Encountered request without speech file.")
    raise BadRequest(f"Request did not included a speech file.")


def submit_speech_api_request(file: bytes, language_code: str = "en-US") -> dict:
    """
    Function to submit a speech-to-text API request.

    :return: transcripts extracted from the speech file, in json format
    """

    # FUTURE: Avoid scoping lifetime of the client to function?
    client = speech.SpeechClient()

    # Source: https://cloud.google.com/speech-to-text/docs/sync-recognize
    # Did not dig into all the API options
    audio = speech.RecognitionAudio(content=file)
    config = speech.RecognitionConfig(audio_channel_count=2, language_code=language_code)
    response = client.recognize(config=config, audio=audio)

    # Format JSON output
    return {
        # Each result is for a consecutive portion of the audio. Iterate through
        # them to get the transcripts for the entire audio file.
        # The first alternative is the most likely one for this portion.
        # FUTURE: Check if alternatives[0] always exists
        "transcripts": [f"{result.alternatives[0].transcript}" for result in response.results]
    }


if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0', port=int(os.environ.get('PORT', 8080)))

