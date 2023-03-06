/* Requires the Docker Pipeline plugin */
pipeline {
    agent {
        docker {
            image 'am271/flutter-apk-builder'
            args '-u builder -w /app -v /home/jenkins-agent/work_dir/workspace/navigation_jenkins-ci:/app'
        }
    }
    stages {
        stage('build') {
            steps {
                sh 'whoami'
                sh 'pwd'
                sh 'flutter version'
                sh 'flutter pub get'
            }
        }
    }
}