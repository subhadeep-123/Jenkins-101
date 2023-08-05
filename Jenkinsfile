pipeline {
    environment {
        REGION = "us-east-1"
        ECR_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com"
        REPOSITORY_URI = "${ECR_URI}/jenkins-101"
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
                sh "docker tag jenkins-101:latest $REPOSITORY_URI:$BUILD_NUMBER"

                script {
                  dockerImage = "$REPOSITORY_URI" + ":$BUILD_NUMBER"
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
                        sh('aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY')
                        sh """
                        aws configure set aws_access_key_id ${AWS_ACCESS_KEY_ID}
                        aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${ECR_URI}
                        """
                    }
                }
            }
        }
        
        stage('Push Docker Image') {
            steps {
                sh "docker push $dockerImage"
            }
        }
    }
}
