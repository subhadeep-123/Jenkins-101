import sys
import os

# Add the project root directory to the Python path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from src.main import app

def test_api():
    client = app.test_client()
    response = client.get('/')
    assert response.status_code == 200
    data = response.json
    assert data == {
        "name": "Jenkins-101",
        "description": "Dockerized Python flask application, CI/CD with Jenkins and deployed to AWS ECR",
        "version": '1.0.0'
    }
