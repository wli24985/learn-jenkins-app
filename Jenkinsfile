pipeline {
    agent any

    environment {
        NETLIFY_SITE_ID = '7550f1e5-9ea3-4e27-a3c6-1871c7c112da'
        //netlify-token created in netlify and saved in Jenkins Dashboard -> Manage Jenkins -> Credentials -> System -> Global credentials (unrestricted)
        NETLIFY_AUTH_TOKEN = credentials('netlify-token')
        REACT_APP_VERSION = "1.0.$BUILD_ID"
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
        
        stage('Tests'){
            parallel {
                stage('Unit Tests'){
                    agent {
                        docker {
                            image 'node:18-alpine'
                            reuseNode true
                        }
                    }
                    steps {
                        sh '''
                            #test -f build/index.html
                            npm test
                        ''' 
                    }

                    post {
                        always {
                            junit 'tjest-results/junit.xml'
                        }
                    }
                    
                }
                stage('E2E'){
                    agent {
                        docker {
                            image 'my-plywright'
                            reuseNode true
                        }
                    }
                    steps {
                        //npx playwright install
                        sh '''                                    
                            serve -s build &
                            sleep 10
                            npx playwright test --reporter=html
                        ''' 
                    }

                    post {
                        always {
                            publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: 'playwright-report', reportFiles: 'index.html', reportName: 'Playwright Local', reportTitles: '', useWrapperFileDirectly: true])
                        }
                    }
                    
                }
            }
        }
        stage('Deploy Staging w E2E'){
            agent {
                docker {
                    image 'my-plywright'
                    reuseNode true
                }
            }
            environment {
                CI_ENVIRONMENT_URL = 'STAGING_URL_TO_BE_SET'
            }
            steps {
                sh '''
                    netlify --version
                    echo "Deploying to staging with site ID $NETLIFY_SITE_ID"
                    netlify status
                    netlify deploy --dir=build --json > deploy-output.json                    
                    CI_ENVIRONMENT_URL=$(node-jq -r '.deploy_url' deploy-output.json)
                    #no spaces around the URL=$ above!
                    npx playwright test --reporter=html
                '''
            }
            post {
                always {
                    publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: 'playwright-report', reportFiles: 'index.html', reportName: 'Staging E2E', reportTitles: '', useWrapperFileDirectly: true])
                }
            }
            
        }
        /* by default time out value is minute
        stage('Approval') {
            steps {
                timeout(10) {
                    input message: 'Do you wich to deploy to production?', ok: 'Yes, I am sure I want to deploy.'
                }
            }
        }
        */
        stage('Deploy Prod w E2E'){
            agent {
                docker {
                    image 'my-plywright'
                    reuseNode true
                }
            }
            environment {
                // NETLIFY_SITE_ID = '7550f1e5-9ea3-4e27-a3c6-1871c7c112da'
                // NETLIFY_AUTH_TOKEN = credentials('netlify-token')
                CI_ENVIRONMENT_URL = 'https://exquisite-toffee-ec4866.netlify.app'
            }
            steps {
                //npx playwright install
                sh '''
                    echo "Deploying to production with site ID $NETLIFY_SITE_ID"
                    netlify status
                    netlify deploy --dir=build --prod
                    sleep 10                   
                    npx playwright test --reporter=html
                ''' 
            }

            post {
                always {
                    publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: 'playwright-report', reportFiles: 'index.html', reportName: 'Production E2E', reportTitles: '', useWrapperFileDirectly: true])
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
