pipeline {
    agent { docker { 
        image 'am271/flutter-apk-builder'
        args '-v $HOME:/app'
        }
    }
    stages {
        stage('build') {
            steps {
                sh 'flutter pub get'
            }
        }
    }
}