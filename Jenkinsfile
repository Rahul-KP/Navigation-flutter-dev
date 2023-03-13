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
                APITOKEN = credentials('navigation-api-token')
                FIREBASE_CREDS = credentials('navigation-firebase-options')
                FILENAME = "b6518b0e.apk"
                NGROK_URL = "https://fa27-106-51-242-245.in.ngrok.io"
                RELEASE_NOTES = "\"Testing with w3w\""
            }
            steps {
                sh '''
                    cat ${CREDS} > credentials.env
                    cat ${FIREBASE_CREDS} > lib/firebase_options.dart
                    curl -X POST --url $NGROK_URL/newindex -H "Content-Type: application/json" -H "X-Access-Token: $APITOKEN" -d "\'{\"commit_hash\" : \"b6518b0e5d4e332048abf75f74904778db2132a3\", \"commit_msg\" : \"none\", \"date\" : \"$(date '+%d-%m-%Y')\", \"filename\" : \"$FILENAME\", \"release_notes\" : \"$RELEASE_NOTES\"}\'"
                    flutter pub get
                    flutter build apk --debug
                    cp build/app/outputs/flutter-apk/app-debug.apk ./$FILENAME
                '''
            }
        }
        stage('upload-apk') {
            environment {
                APITOKEN = credentials('navigation-api-token')
                NGROK_URL = "https://fa27-106-51-242-245.in.ngrok.io"
                FILENAME = "b6518b0e.apk"
                RELEASE_NOTES = "\"Testing with w3w\""
            }
            steps {
                sh '''
                    curl -X POST -H "Content-Type: multipart/form-data" -H "X-Access-Token: $APITOKEN" -F apk=@$FILENAME $NGROK_URL/newbuild
                '''
            }
        }
    }
}