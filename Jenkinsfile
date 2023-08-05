pipeline {
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