/* Requires the Docker Pipeline plugin */
pipeline {
    agent {
        docker {
            image 'am271/flutter-apk-builder:heresdk'
        }
    }
    stages {
        stage('build') {
            steps {
                sh '''
                    mkdir -p plugins/here_sdk
                    tar xzf /app/heresdk-explore-flutter.tar.gz -C plugins/here_sdk
                    flutter pub get
                    flutter build apk --debug
                '''
            }
        }
    }
}