/* Requires the Docker Pipeline plugin */
node {
    stage('Build') {
        docker.image('python:3.10.7-alpine').inside {
            sh 'python --version'
        }
    }
}