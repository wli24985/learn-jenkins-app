pipeline {
    agent any

    environment {
        REACT_APP_VERSION = "1.0.$BUILD_ID"
        AWS_DEFAULT_REGION = 'us-east-2'
    }
    stages {
        stage('Deploy to AWS') {
            agent {
                docker {
                    image 'amazon/aws-cli:latest'
                    reuseNode true
                    args "--entrypoint=''"
                }
            }
            // environment {
            //     AWS_S3_BUCKET = 'learn-jenkins-wenyi'
            // }
            steps {
                withCredentials([usernamePassword(credentialsId: 'my-awsID', passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID')]) {
                    sh '''
                        aws --version
                        #aws s3 sync build s3://$AWS_S3_BUCKET
                        aws ecs register-task-definition --cli-input-json file://aws/task-definition-prod.json
                        aws ecs update-service --cluster LearnJenkinsWenyi-Cluster-Prod --service LearnJenkinsApp-Service-Prod --task-definition LearnJenkinsWenyi-TaskDefinition-Prod:2
                    '''
                }
                
            }
        }
        
        stage('Build') {
            agent {
                docker {
                    image 'node:18-alpine' // was node:18
                    reuseNode true
                    //args '-u root:root'
                }
            }
            steps {
                // sh '''
                //     # for cleaning build files
                //     rm -rf '/var/jenkins_home/workspace/learn jekins app/build'
                //     rm -rf "/var/jenkins_home/workspace/learn jekins app/node_modules"
                //     #npm cache clean --force
                // '''
                sh '''
                    ls -la
                    node --version
                    npm --version
                    npm ci
                    npm run build
                    ls -la
                '''
            }
        }
    }
    post {
        always {
            echo "Done."
        }
    }
}
