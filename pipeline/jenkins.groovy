pipeline {
    agent any
    parameters {

        choice(name: 'OS', choices: ['linux', 'darwin', 'windows', 'all'], description: 'Pick OS')
        choice(name: 'ARCH', choices: ['arm64', 'amd64'], description: 'Pick Arch')

    }
    stages {
        stage('Example') {
            steps {
                echo "Build for platform ${params.OS}"

                echo "Build for arch: ${params.ARCH}"

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

        stage('make image') {
            steps {
                echo 'Make image'
                sh "TARGETOS=${params.OS} TARGETARCH=${params.ARCH} make image"
            }
        }
    }
}
