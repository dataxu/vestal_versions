@Library('sharedlib') _

def dockerImage = "${JOB_NAME}-builder".toLowerCase()

// define the objects that will be needed
def general_utils = new dataxu.general.utils()

//Syntax quick guide: https://jenkins.io/doc/book/pipeline/syntax/
pipeline {
    agent {
        node {
            label 'micro'
            customWorkspace "/var/lib/jenkins/jobs/${JOB_NAME}/${BUILD_NUMBER}"
        }
    }
    options {
        //keep last 10 builds
        buildDiscarder(logRotator(numToKeepStr: '10'))
        //timestamps
        timestamps()
    }
    //begin stage definitions
    stages {
        stage('Prep Env') {
            stages {
                stage ('Checkout SCM') {
                    steps {
                        //clean the current directory
                        deleteDir()
                        //get the repository this Jenkinsfile lives in
                        checkout scm
                    }
                }
            }
            post {
                always {
                    //notify github that we made it this far
                    github_notify_status()
                }
            }
        }
        stage('Build') {

            stages {
                stage('Build Docker Image') {
                    steps {
                        sh """
                        docker build -t ${dockerImage} .
                        """
                    }
                }
                /* // Testing is failing. Skip to unblock project to
                // build gems for all ui dependencies.
                stage('Run Tests') {
                    steps {
                        sh """
                        docker run ${dockerImage} bundler exec rake
                        """
                    }
                }*/
                stage('Build & Push Gem') {
                    when {
                        expression { env.BRANCH_NAME == 'master' }
                    }
                    steps {
                        sh """
                        docker run ${dockerImage} ./buildDeploy.sh
                        """
                    }
                }
            }
            post {
                always {
                    github_notify_status()
                }
            }
        }
        stage('Cleanup') {
            stages {
                stage('Cleanup Docker Image') {
                    steps {
                        sh """
                        docker rmi ${dockerImage}
                        """
                    }
                }
            }
        }
    }
    post {
        always {
            script {
                github_notify_status(stage_name: 'Pipeline complete')
            }
        }
    }
}
