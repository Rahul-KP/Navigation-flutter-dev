pipeline {
    agent { docker { 
        image 'am271/flutter-apk-builder'
        args '-v $HOME:/app --entrypoint=\'\''
        }
    }
    stages {
        stage('build') {
            steps {
                sh 'flutter build apk --debug'
            }
        }
    }
}