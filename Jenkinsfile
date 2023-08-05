pipeline {
    environment {
        region = "us-east-1"
        registry = "593100728347.dkr.ecr.${region}.amazonaws.com/jenkins-101"
        dockerImage = ""
    }
    
    agent any
    
    stages {
        stage('Clone Project') {
            steps {
                git branch: 'dev', changelog: false, poll: false, url: 'https://github.com/subhadeep-123/Jenkins-101'
            }
        }
        
        stage('Build Application') {
            steps {
                sh "docker build -t jenkins-101:latest ."
            }
        }
        
        stage('Test Application') {
            steps {
                sh "docker run --rm jenkins-101:latest pytest"
            }
        }
    }
}