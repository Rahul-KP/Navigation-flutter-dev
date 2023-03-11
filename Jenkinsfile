/* Requires the Docker Pipeline plugin */
pipeline {
    agent {
        docker {
            image 'am271/flutter-apk-builder:heresdk'
        }
    }
    stages {
        stage('build') {
            environment {
                CREDS = credentials('navigation-credentials')
            }
            steps {
                sh '''
                    mkdir -p plugins/here_sdk
                    tar xzf /app/heresdk-explore-flutter.tar.gz -C plugins/here_sdk
                    cat ${CREDS} > credentials.env
                    dart pub global activate flutterfire_cli
                    curl -sL https://firebase.tools | bash
                    flutter pub get
                    flutter build apk --debug
                '''
            }
        }
    }
}