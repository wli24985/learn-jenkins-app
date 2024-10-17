pipeline {
    agent any

    environment {
        REACT_APP_VERSION = "1.0.$BUILD_ID"
        APP_NAME = 'myjekinsapp'
        AWS_DOCKER_REGISTRY = '921738114306.dkr.ecr.us-east-2.amazonaws.com'
        AWS_DEFAULT_REGION = 'us-east-2'
        AWS_ECS_CLUSTER = 'LearnJenkinsWenyi-Cluster-Prod'
        AWS_ECS_SERVICE_PROD = 'LearnJenkinsApp-Service-Prod'
        AWS_ECS_TD_PROD = 'LearnJenkinsWenyi-TaskDefinition-Prod'
    }
    stages {
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
        stage('Build Docker image') {
            agent {
                docker {
                    image 'my-aws-cli'
                    reuseNode true
                    args "-u root -v /var/run/docker.sock:/var/run/docker.sock --entrypoint=''"
                }
            }
            steps {
                withCredentials([usernamePassword(credentialsId: 'my-awsID', passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID')]) {
                    sh '''
                        #amazon-linux-extras install docker
                        docker build -t $AWS_DOCKER_REGISTRY/$APP_NAME:$REACT_APP_VERSION .
                        aws ecr get-login-password | docker login --username AWS --password-stdin $AWS_DOCKER_REGISTRY
                        docker push $AWS_DOCKER_REGISTRY/$APP_NAME:$REACT_APP_VERSION
                    '''
                }
            }
        }
        stage('Deploy to AWS') {
            agent {
                docker {
                    image 'my-aws-cli'
                    reuseNode true
                    args "-u root --entrypoint=''"
                }
            }
            // environment {
            //     AWS_S3_BUCKET = 'learn-jenkins-wenyi'
            // }
            steps {
                withCredentials([usernamePassword(credentialsId: 'my-awsID', passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID')]) {
                    sh '''
                        aws --version
                        #yum install jq -y
                        #aws s3 sync build s3://$AWS_S3_BUCKET
                        LATEST_TD_REVISION=$(aws ecs register-task-definition --cli-input-json file://aws/task-definition-prod.json | jq '.taskDefinition.revision')
                        aws ecs update-service --cluster $AWS_ECS_CLUSTER --service $AWS_ECS_SERVICE_PROD --task-definition $AWS_ECS_TD_PROD:$LATEST_TD_REVISION
                        aws ecs wait services-stable --cluster $AWS_ECS_CLUSTER --services $AWS_ECS_SERVICE_PROD
                    '''
                }
                
            }
        }
        
        
    }
    post {
        always {
            echo "Done."
        }
    }
}
