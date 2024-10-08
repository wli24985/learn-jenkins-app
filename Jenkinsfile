pipeline {
    agent any

    environment {
        NETLIFY_SITE_ID = '7550f1e5-9ea3-4e27-a3c6-1871c7c112da'
        NETLIFY_AUTH_TOKEN = credentials('netlify-token')
    }
    stages {
        /*
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
        */
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
                            image 'mcr.microsoft.com/playwright:v1.39.0-jammy'
                            reuseNode true
                        }
                    }
                    steps {
                        //npx playwright install
                        sh '''                   
                            npm install serve                 
                            node_modules/.bin/serve -s build &
                            sleep 20
                            npx playwright test --reporter=html
                        ''' 
                    }

                    post {
                        always {
                            publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: 'playwright-report', reportFiles: 'index.html', reportName: 'Playwright HTML Report', reportTitles: '', useWrapperFileDirectly: true])
                        }
                    }
                    
                }
            }
        }
        stage('Deploy') {
            agent {
                docker {
                    image 'node:18-alpine' // was node:18
                    reuseNode true
                }
            }
            steps {
                sh '''
                    npm install netlify-cli
                    node_modules/.bin/netlify --version
                    echo "Deploying to production with site ID $NETLIFY_SITE_ID"
                    node_modules/.bin/netlify status
                    node_modules/.bin/netlify deploy --dir=build --prod
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
