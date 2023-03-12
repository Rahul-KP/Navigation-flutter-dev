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
                    tar xzf /home/developer/heresdk-explore-flutter.tar.gz -C plugins/here_sdk
                '''
            }
        }
        stage('build') {
            environment {
                CREDS = credentials('navigation-credentials')
                FIREBASE_CREDS = credentials('navigation-firebase-options')
            }
            steps {
                cache(maxCacheSize: 250, caches: [
                    arbitraryFileCache(path: 'build', cacheValidityDecidingFile: 'pubspec.yaml'),
                    arbitraryFileCache(path: '.dart_tools', cacheValidityDecidingFile: 'pubspec.yaml'),
                    arbitraryFileCache(path: '.packages/', cacheValidityDecidingFile: 'pubspec.yaml')
                ]) {
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
}