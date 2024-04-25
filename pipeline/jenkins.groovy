pipeline {
    agent any
    parameters {

        choice(name: 'OS', choices: ['linux', 'darwin', 'windows', 'all'], description: 'Pick OS')

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
    }
}
