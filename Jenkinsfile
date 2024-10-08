pipeline {
    agent any
    stages {
        stage('Build') {
            agent {
                docker {
                    image 'node:22-alpine' // was node:18
                    reuseNode true
                }
            }
            steps {
                sh '''
                    ls -la
                    node --version
                    npm --version
                    npm ci
                    npm run build
                '''
            }
        }
        stage('Test'){
            agent {
                docker {
                    image 'node:22-alpine'
                    reuseNode true
                }
            }
            steps {
                sh '''
                    test -f build/index.html
                    npm test
                ''' 
            }
            
        }
        stage('E2E'){
            agent {
                docker {
                    image 'node:22-alpine'
                    reuseNode true
                    args '-u root:root'
                }
            }
            steps {
                //npx playwright install
                sh '''                   
                    npm install serve                 
                    node_modules/.bin/serve -s build &
                    sleep 40
                    npx playwright test
                ''' 
            }
            
        }
    }
    post {
        always {
            junit 'tjest-results/junit.xml'
        }
    }
}
