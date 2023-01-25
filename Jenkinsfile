pipeline {
    agent { docker { 
        image 'am271/flutter-apk-builder'
        args '-v ${env.WORKSPACE}:/app'
        }
    }
    stages {
        stage('build') {
            steps {
                sh 'ls'
            }
        }
    }
}