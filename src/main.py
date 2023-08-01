from flask import Flask, jsonify

app = Flask(__name__)


@app.route("/")
def api():
    return jsonify({
        "name": "Jenkins-101",
        "description": "Dockerized Python flask application, CI/CD with Jenkins and deployed to AWS ECR",
        "version": '1.0.0'
    })


if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=False, port=8080)
