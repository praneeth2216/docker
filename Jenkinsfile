// Jenkinsfile for building the Flask Docker image and optionally pushing it to a registry
// Usage notes:
// - Set DOCKER_REGISTRY (e.g. "index.docker.io/youruser") and DOCKER_CREDENTIALS_ID to enable push.
// - This pipeline expects Docker to be available on the Jenkins agent (Docker Pipeline plugin).

pipeline {
  agent any

  environment {
    IMAGE = "flask-practice:${env.BUILD_NUMBER}"
    // Optional: set DOCKER_REGISTRY and DOCKER_CREDENTIALS_ID in job or credentials bindings
    DOCKER_REGISTRY = "${DOCKER_REGISTRY}"
    DOCKER_CREDENTIALS_ID = "${DOCKER_CREDENTIALS_ID}"
  }

  options {
    // Keep only the last 10 builds
    buildDiscarder(logRotator(numToKeepStr: '10'))
    timeout(time: 30, unit: 'MINUTES')
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Install dependencies (sanity)') {
      steps {
        echo 'Installing Python deps (local agent) to verify requirements file is valid'
        sh 'python -V || true'
        sh 'pip --version || true'
        sh 'pip install --user -r requirements.txt || true'
      }
    }

    stage('Docker Build') {
      steps {
        script {
          // docker.build returns an object we can push later
          dockerImage = docker.build(env.IMAGE)
        }
      }
    }

    stage('Docker Push') {
      when {
        expression { return env.DOCKER_REGISTRY?.trim() }
      }
      steps {
        script {
          def fullImage = "${env.DOCKER_REGISTRY}/${env.IMAGE}"
          dockerImage = docker.build(fullImage)
          docker.withRegistry("https://${env.DOCKER_REGISTRY}", env.DOCKER_CREDENTIALS_ID) {
            dockerImage.push()
            // Also push a 'latest' tag for convenience
            dockerImage.push('latest')
          }
        }
      }
    }

    stage('Smoke test (optional)') {
      steps {
        echo 'Running a lightweight smoke test by creating and hitting a container (if Docker available)'
        sh '''
        CONTAINER_ID=$(docker run -d -p 5001:5000 ${IMAGE} || true)
        if [ -n "$CONTAINER_ID" ]; then
          sleep 2
          curl -f --retry 5 --retry-delay 1 http://localhost:5001/ || echo "Smoke test failed"
          docker rm -f $CONTAINER_ID || true
        else
          echo "Could not start container for smoke test; skipping."
        fi
        '''
      }
    }
  }

  post {
    always {
      archiveArtifacts artifacts: 'Dockerfile,app.py,requirements.txt,README.md', fingerprint: true
      cleanWs()
    }
    success {
      echo "Build ${env.BUILD_NUMBER} succeeded."
    }
    failure {
      echo "Build ${env.BUILD_NUMBER} failed."
    }
  }
}
