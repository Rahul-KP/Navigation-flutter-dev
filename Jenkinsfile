/* Requires the Docker Pipeline plugin */
node {
    stage('Build') {
        docker.image('am271/flutter-apk-builder').inside {
            sh 'flutter pub get'
        }
    }
}