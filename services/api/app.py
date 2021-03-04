import os

from flask import Flask
from flask import request


app = Flask(__name__)


if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0', port=int(os.environ.get('PORT', 8080)))


@app.route('/')
def hello_world():
    target = os.environ.get('TARGET', 'World')
    print(request.headers)
    return 'Hello {}!\n'.format(target)