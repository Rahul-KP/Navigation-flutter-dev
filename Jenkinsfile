/* Requires the Docker Pipeline plugin */
node {
    stage('Build') {
        docker.image('am271/flutter-apk-builder').pull()
        docker.image('am271/flutter-apk-builder').inside {
            sh 'whoami'
            sh 'pwd'
            sh 'flutter version'
            sh 'flutter pub get'
        }
    }
}