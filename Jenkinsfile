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
                FILENAME = "b6518b0e.apk"
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
                FILENAME_PART = sh (script: """git log -n 1 --pretty=format:\"%H\" | cut -c 1-8""", returnStdout:true)
                FILENAME = sh (script: """${env.WORKSPACE}/${FILENAME_PART}.apk""", returnStdout:true)
                RELEASE_NOTES = "\"Testing with w3w\""
                COMMIT_HASH = sh (script: """git log -n 1 --pretty=format:\"%H\"""", returnStdout:true)
                COMMIT_MSG = sh (script: """git log -n 1 --pretty=format:\"%H\"""", returnStdout:true)
                DATE = sh (script: """date '+%d-%m-%Y'""", returnStdout:true)
            }
            steps {
                sh newbuild.sh
            }
        }
    }
}