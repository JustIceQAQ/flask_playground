import os

from flask import Flask, request, redirect
from flask.helpers import send_from_directory, send_file
from werkzeug.utils import secure_filename

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = "file"
app.config['MAX_CONTENT_LENGTH'] = 16 * 1024 * 1024  # 16MB


@app.route("/")
def hello_world():
    return "<p>Hello, World!</p>"


@app.route('/video/', methods=['POST'])
@app.route("/video/<filename>", methods=['GET'])
def video(filename=None):
    if request.method == 'POST':
        file = request.files['file']
        if file:
            return upload_file(file)

    elif request.method == 'GET':
        return download_file(filename)


def download_file(filename):
    return send_file(
        os.path.join(app.config['UPLOAD_FOLDER'],
                     filename)
        , as_attachment=True)


def upload_file(file):
    filename = secure_filename(file.filename)
    file.save(os.path.join(app.config['UPLOAD_FOLDER'],
                           filename))
    return {"filename": filename}


if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000)
