/* Requires the Docker Pipeline plugin */
pipeline {
    agent {
        docker {
            image 'am271/flutter-apk-builder:heresdk'
        }
    }
    stages {
        stage('extract-sdk') {
            steps {
                sh '''
                    sudo chown $UID:$GID -R $(pwd)
                    mkdir -p plugins/here_sdk
                    find / -name heresdk-explore-flutter.tar.gz
                    tar xzf heresdk-explore-flutter.tar.gz -C plugins/here_sdk
                '''
            }
        }
        stage('build') {
            environment {
                CREDS = credentials('navigation-credentials')
                FIREBASE_CREDS = credentials('navigation-firebase-options')
            }
            steps {
                sh '''
                    cat ${CREDS} > credentials.env
                    cat ${FIREBASE_CREDS} > lib/firebase_options.dart
                    flutter pub get
                    flutter build apk --debug
                '''
            }
        }
    }
}