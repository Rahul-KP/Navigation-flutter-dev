/* Requires the Docker Pipeline plugin */
pipeline {
    agent {
        docker {
            image 'am271/flutter-apk-builder'
        }
    }
    stages {
        stage('build') {
            steps {
                sh '''
                    pwd
                    ls
                    flutter pub get
                    flutter build apk --debug
                '''
            }
        }
    }
}