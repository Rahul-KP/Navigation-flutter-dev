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
                cache(maxCacheSize: 3072, caches: [
                    arbitraryFileCache(path: 'build', cacheValidityDecidingFile: 'pubspec.yaml'),
                    arbitraryFileCache(path: '.dart_tools', cacheValidityDecidingFile: 'pubspec.yaml'),
                    arbitraryFileCache(path: '.packages/', cacheValidityDecidingFile: 'pubspec.yaml')
                ]) {
                    sh '''
                        cat ${CREDS} > credentials.env
                        cat ${FIREBASE_CREDS} > lib/firebase_options.dart
                        flutter pub get
                        flutter build apk --debug
                        cp build/app/outputs/flutter-apk/app-debug.apk ./$FILENAME
                    '''
                }
            }
        }
        stage('upload-apk') {
            environment {
                APITOKEN = credentials('navigation-api-token')
                NGROK_URL = "https://a107-106-51-242-245.in.ngrok.io"
                FILENAME = "b6518b0e.apk"
            }
            steps {
                sh '''
                    curl -X POST -H "Content-Type: application/json" -H "X-Access-Token: $APITOKEN" -d "{\"commit_hash\" : \"b6518b0e5d4e332048abf75f74904778db2132a3\", \"commit_msg\" : \"test 1 w3w grid\", \"date\" : \"$(date '+%d-%m-%Y')\", \"filename\" : \"$FILENAME\", \"release_notes\" : \"Test 1 w3w with Hive\"}" $NGROK_URL/newindex
                    curl -X POST -H "Content-Type: multipart/form-data" -H "X-Access-Token: $APITOKEN" -F apk=@$FILENAME $NGROK_URL/newbuild
                '''
            }
        }
    }
}