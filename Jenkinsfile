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
                    curl -o heresdk-explore-flutter.tar.gz https://dl.dropboxusercontent.com/s/2rgack3gpf0j5kp/heresdk-explore-flutter-4.13.0.0.3315.tar.gz?dl=0
                    tar xzf /app/heresdk-explore-flutter.tar.gz -C plugins/here_sdk
                    dart pub global activate flutterfire_cli
                    curl -sL https://firebase.tools | bash
                    flutter pub get
                    flutter build apk --debug
                '''
            }
        }
    }
}