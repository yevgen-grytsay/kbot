pipeline {
    agent any
    parameters {

        choice(name: 'OS', choices: ['linux', 'darwin', 'windows', 'all'], description: 'Pick OS')
        choice(name: 'ARCH', choices: ['arm64', 'amd64'], description: 'Pick Arch')

    }
    stages {
        stage('Prepare') {
            steps {
                echo "Build for platform ${params.OS}"
                echo "Build for arch: ${params.ARCH}"

                sh "TARGETOS=${params.OS} TARGETARCH=${params.ARCH}"
            }
        }

        stage('Git Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/yevgen-grytsay/kbot.git'
            }
        }

        stage('test') {
            steps {
                echo 'Testing'
                sh 'make test'
            }
        }

        stage('make build') {
            steps {
                echo 'Make build'
                sh "make build"
            }
        }

        stage('make image') {
            steps {
                echo 'Make image'
                sh "make image"
            }
        }

        stage('push image') {
            steps {
                script {
                    docker.withRegistry('', 'dockerhub-credentials') {
                        sh 'make push'
                    }
                }
            }
        }
    }
}
