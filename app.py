from flask import Flask, request

app = Flask(__name__)


@app.route("/")
def hello_world():
    return "<p>Hello, World!</p>"


@app.route("/video", methods=['GET', 'POST'])
def video():
    info = "<p>{}</p>"
    if request.method == 'POST':
        info = info.format("download video?")
    elif request.method == 'GET':
        info = info.format("upload video?")
    return info


if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000)
