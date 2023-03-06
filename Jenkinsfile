/* Requires the Docker Pipeline plugin */
pipeline {
    agent {
        docker {
            image 'am271/flutter-apk-builder'
            args '-u builder'
        }
    }
    stages {
        stage('build') {
            steps {
                sh 'whoami'
                sh 'pwd'
                sh 'flutter version'
                sh 'flutter pub get'
            }
        }
    }
}