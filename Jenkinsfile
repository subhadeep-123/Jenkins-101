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
                sh "docker tag jenkins-101:latest 593100728347.dkr.ecr.us-east-1.amazonaws.com/jenkins-101:$BUILD_NUMBER"

                script {
                  dockerImage = "593100728347.dkr.ecr.us-east-1.amazonaws.com/jenkins-101" + ":$BUILD_NUMBER"
                }
            }
        }
        
        stage('Test Application') {
            steps {
                sh "docker run --rm ${dockerImage} pytest"
            }
        }

        stage('Login to ECR') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'jenkins-101-aws-creds', passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID')]) {
                        sh('aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY') // String Interpolation
                        sh """
                        aws configure set aws_access_key_id ${AWS_ACCESS_KEY_ID}
                        aws ecr get-login --region ${region} --no-include-email
                        """
                    }
                }
            }
        }
    }
}
