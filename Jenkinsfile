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
                sh '''
                    cat ${CREDS} > credentials.env
                    cat ${FIREBASE_CREDS} > lib/firebase_options.dart
                    flutter pub get
                    flutter build apk --debug
                    cp build/app/outputs/flutter-apk/app-debug.apk ./$FILENAME
                '''
            }
        }
        stage('upload-apk') {
            environment {
                APITOKEN = credentials('navigation-api-token')
                NGROK_URL = "https://75cb-106-51-242-245.in.ngrok.io"
                FILENAME = sh (script: """git log -n 1 --pretty=format:\"%H\" | cut -c 1-8 | sed 's/\$/.apk/'""", returnStdout:true)
                RELEASE_NOTES = sh (script: """cat release-notes.txt""", returnStdout:true)
                COMMIT_HASH = sh (script: """git log -n 1 --pretty=format:\"%H\"""", returnStdout:true)
                COMMIT_MSG = sh (script: """git log -n 1 --pretty=format:\"%H\"""", returnStdout:true)
                DATE = sh (script: """date '+%d-%m-%Y'""", returnStdout:true)
            }
            steps {
                // sh 'sudo chown $UID:$GID /usr/local/bin/newbuild.sh'
                sh 'newbuild.sh'
            }
        }
    }
}
