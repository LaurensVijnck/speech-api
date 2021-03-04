import os

from flask import Flask, request
from werkzeug.utils import secure_filename
from werkzeug.exceptions import BadRequest


# Configuration
app = Flask(__name__)
app.config['MAX_CONTENT_LENGTH'] = 2048 * 2048
app.config['UPLOAD_EXTENSIONS'] = ['.mp3', '.wav']
app.config['UPLOAD_PATH'] = 'var/www/uploads/'


@app.route('/')
def hello_world():
    target = os.environ.get('TARGET', 'World')
    print(request.headers)
    return 'Hello {}!\n'.format(target)


@app.route('/v1/speech', methods=['POST'])
def speech_to_text():

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

        return "ok"

    app.logger.error(f"Encountered request without speech file.")
    raise BadRequest(f"Request did not included a speech file.")


if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0', port=int(os.environ.get('PORT', 8080)))

