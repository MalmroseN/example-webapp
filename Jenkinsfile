def builderImage
def productionImage
def ACCOUNT_REGISTRY_PREFIX
def GIT_COMMIT_HASH

pipeline {
    agent any
    stages {
        stage('Check lein') {
            steps {
                sh 'lein version'
            }
        }
        
        stage('Checkout Source Code and Logging Into Registry') {
            steps {
                echo "Logging Into the Private ECR Registry"
                script {
                    GIT_COMMIT_HASH = sh (script: "git log -n 1 --pretty=format:'%H'", returnStdout: true)
                    ACCOUNT_REGISTRY_PREFIX = "211125420342.dkr.ecr.us-east-1.amazonaws.com"
                    sh """
                    \$(aws ecr get-login --no-include-email --region us-east-1)
                    """
                }
            }
        }
        
        stage('Make A Builder Image') {
            steps {
                echo "Starting to build the builder docker image"
                script {
                    builderImage = docker.build("${ACCOUNT_REGISTRY_PREFIX}/example-webapp-builder:${GIT_COMMIT_HASH}")
                    builderImage.push()
                    builderImage.push("${env.GIT_BRANCH}")
                    builderImage.inside('-v $WORKSPACE:/output -u root') {
                        sh """
                            cd /output
                            lein uberjar
                        """
                    }
                }
            }
        }
        
        stage('Unit Tests') {
            steps {
                echo "running unit tests in the builder image"
                script {
                    builderImage.inside('-v $WORKSPACE:/output -u root') {
                        sh """
                            cd /output
                            lein test
                        """
                    }
                }
            }
        }

        stage('Build Production Image') {
            steps {
                echo "Starting to build docker image"
                script {
                    productionImage = docker.build("${ACCOUNT_REGISTRY_PREFIX}/example-webapp:${GIT_COMMIT_HASH}")
                    productionImage.push()
                    productionImage.push("${env.GIT_BRANCH}")
                }
            }
        }
    }
}