pipeline {
    agent {
        label 'JDKJAVASPC'
    }
    stages {
        stage('GIT CHECKOUT') {
            steps {
                git url : "https://github.com/subhashreesai/spring-petclinic.git",
                branch : "main"
            }
        }
        stage('build and scan') {
            steps {
                withCredentials([string(credentialsId: 'sonar_id', variable: 'SONAR_TOKEN')]){
                withSonarQubeEnv('sonarsubha') {
                    sh '''
                        mvn package sonar:sonar \
                        -Dsonar.projectKey=subhashreesai_spring-petclinic \
                        -Dsonar.organization=subhashreesai \
                        -Dsonar.host.url=https://sonarcloud.io \
                        -Dsonar.login=$SONAR_TOKEN
                        
                    '''
                }
              }
            }
        }
        stage('upload jfrog') {
            steps {
                rtupload (
                    serverId: 'JFROG_SPC_JAVA',
                    spec: ''' {
                    "files": [
                    {
                    "pattern": "target/*.jar/",
                    "target": "jfrogjavaspc-libs-release"
                    }
                    ]
                    }
                     
                    ''',
                )
                rtPublishBuildInfo (
                    serverId: 'JFROG_SPC_JAVA'
                )
            }
        }
    }
}