pipeline {
    agent any
    stages {
        // stage('Build') {
        //     agent {
        //         docker {
        //             image 'node:18-alpine'
        //             reuseNode true
        //         }
        //     }
        //     steps {
        //         sh '''
        //             ls -la
        //             node --version
        //             npm --version
        //             npm ci
        //             npm run build
        //         '''
        //     }
        // }
        stage('Test'){
            agent {
                docker {
                    image 'node:18-alpine'
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
                    image 'node:18-alpine'
                    reuseNode true
                    args '-u root:root'
                }
            }
            steps {
                sh '''
                    npm install serve
                    node_modules/.bin/serve -s build
                    npx playwright test
                ''' 
            }
            
        }
    }
    post {
        always {
            junit 'test-results/junit.xml'
        }
    }
}
