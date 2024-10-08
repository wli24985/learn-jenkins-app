pipeline {
    agent any
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
        // stage('Test'){
        //     agent {
        //         docker {
        //             image 'node:18-alpine'
        //             reuseNode true
        //         }
        //     }
        //     steps {
        //         sh '''
        //             #test -f build/index.html
        //             npm test
        //         ''' 
        //     }
            
        // }
    //     stage('E2E'){
    //         agent {
    //             docker {
    //                 image 'mcr.microsoft.com/playwright:v1.39.0-jammy'
    //                 reuseNode true
    //             }
    //         }
    //         steps {
    //             //npx playwright install
    //             sh '''                   
    //                 npm install serve                 
    //                 node_modules/.bin/serve -s build &
    //                 sleep 40
    //                 npx playwright test
    //             ''' 
    //         }
            
    //     }
    }
    // post {
    //     always {
    //         junit 'tjest-results/junit.xml'
    //     }
    // }
}
