pipeline {
    agent {
        label 'JDKJAVASPC'
    }
    triggers {
        pollSCM('* * * * *')
    }

    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/subhashreesai/spring-petclinic.git'
            }
        }

        stage('Build and Sonar Scan') {
            steps {
                withCredentials([string(credentialsId: 'sonar_id', variable: 'SONAR_TOKEN')]) {
                    withSonarQubeEnv('sonarsubha') {
                        sh '''
                            mvn clean package sonar:sonar \
                                -Dsonar.projectKey=subhashreesai_spring-petclinic \
                                -Dsonar.organization=subhashreesai \
                                -Dsonar.host.url=https://sonarcloud.io \
                                -Dsonar.login=$SONAR_TOKEN
                        '''
                    }
                }
            }
        }

        stage('Upload to JFrog') {
            steps {
                script {
                    def server = Artifactory.server('JFROG_SPC_JAVA')
                    def uploadSpec = """{
                        "files": [
                            {
                                "pattern": "target/*.jar",
                                "target": "jfrogjavaspc-libs-release/"
                            }
                        ]
                    }"""
                    server.upload(spec: uploadSpec)
                    server.publishBuildInfo()
                }
            }
        }
    }
}
