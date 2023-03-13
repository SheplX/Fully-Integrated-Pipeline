pipeline {
  
    environment {
        REPO_NAME = "test"
        ID = 'shepl.dev@gmail.com'
        NEXUS_URL = 'http://10.103.37.81:5000'
        DOCKER_IMAGE_NAME = "shepl/python_app"
        DOCKER_REGISTRY_URL = '10.103.37.81:5000'
        DOCKER_IMAGE_TAG = "${env.BUILD_NUMBER}-prod"
        BRANCH_NAME = 'main'
        NAMESPACE = 'app'
    }
  
    agent {
      kubernetes {
        yaml '''
          apiVersion: v1
          kind: Pod
          metadata:
            name: kaniko
          spec:
            containers:
            - name: kubectl
              image: shepl/deployment-kit
              imagePullPolicy: IfNotPresent
              command:
              - /bin/cat
              tty: true
            - name: docker
              image: shepl/docker.aws:alpine
              imagePullPolicy: IfNotPresent
              command: ["sleep", "infinity"]
              volumeMounts:
              - name: docker-socket
                mountPath: /var/run/docker.sock
            volumes:
            - name: docker-socket
              hostPath:
                path: /var/run/docker.sock
          '''   
      }
    }

    stages {     

        stage('New Job Notification') {
            steps {
                script {
                    slackSend color: 'warning', message: """
                    New Job Started! :rocket:
                    - Job Name: ${env.JOB_NAME.toUpperCase()}
                    - Job Number: ${env.BUILD_NUMBER}
                    - Info: ${currentBuild.description}
                    - Job Link: <${env.BUILD_URL}|Open>
                    """.stripIndent()
                }
            }
        }

        stage('Static code analysis') {
            steps {
                dir('App/') {
                    script {
                        def scannerHome = tool 'SonarScanner';
                        withSonarQubeEnv() {
                            sh """
                                ${scannerHome}/bin/sonar-scanner
                            """
                        }
                    }
                }
            }

            post {
                success {
                    slackSend color: 'good', message: """
                    - :white_check_mark: Stage > '${env.STAGE_NAME.toUpperCase()}' < has completed successfully.
                    """.stripIndent()
                }
                failure {
                    slackSend color: 'danger', message: """
                    - :exclamation: Stage > '${env.STAGE_NAME.toUpperCase()}' < has failed.
                    """.stripIndent()
                }
            }
        }

        stage('Quality Gate Status') {
            steps{
                script{
                    waitForQualityGate abortPipeline: false, credentialsId: 'SONARQUBE'
                }
            }

            post {
                success {
                    slackSend color: 'good', message: """
                    - :white_check_mark: Stage > '${env.STAGE_NAME.toUpperCase()}' < has completed successfully.
                    """.stripIndent()
                }
                failure {
                    slackSend color: 'danger', message: """
                    - :exclamation: Stage > '${env.STAGE_NAME.toUpperCase()}' < has failed.
                    """.stripIndent()
                }
            }
        }

        stage('Building and Pushing Docker Image To Nexus') {
            steps {
                container('docker') {
                    dir('App/') {
                        script {
                            def dockerImage = docker.build("${DOCKER_REGISTRY_URL}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}")
                            docker.withRegistry("${NEXUS_URL}", 'NEXUS') {
                                dockerImage.push()
                            }
                        }
                    }
                }
            }
          
            post {
                success {
                    slackSend color: 'good', message: """
                    - :white_check_mark: Stage > '${env.STAGE_NAME.toUpperCase()}' < has completed successfully.
                    """.stripIndent()
                }
                failure {
                    slackSend color: 'danger', message: """
                    - :exclamation: Stage > '${env.STAGE_NAME.toUpperCase()}' < has failed.
                    """.stripIndent()
                }
            }
        }

        stage('Pushing New Tags To Git') {
            steps {
                dir('Deployment/') {
                    script {
                        withCredentials([usernamePassword(credentialsId: 'GIT', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                            sh """
                                git config user.email ${ID}
                                git config user.name ${USERNAME}
                                cat app.yaml
                                sed -i 's+${DOCKER_REGISTRY_URL}/${DOCKER_IMAGE_NAME}.*+${DOCKER_REGISTRY_URL}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}+g' app.yaml
                                cat app.yaml
                                git add .
                                git commit -m 'Tag "${DOCKER_IMAGE_TAG}" Added !'
                                git push https://${USERNAME}:${PASSWORD}@github.com/${USERNAME}/${REPO_NAME}.git HEAD:${BRANCH_NAME}
                            """ 
                        }
                    }
                }
            }

            post {
                success {
                    slackSend color: 'good', message: """
                    - :white_check_mark: Stage > '${env.STAGE_NAME.toUpperCase()}' < has completed successfully.
                    """.stripIndent()
                }
                failure {
                    slackSend color: 'danger', message: """
                    - :exclamation: Stage > '${env.STAGE_NAME.toUpperCase()}' < has failed.
                    """.stripIndent()
                }
            }
        }

        stage('Deploying Manifests To Kubernetes') {     
            steps {
                container('kubectl') {
                    sh 'kubectl apply -f Deployment/ -n ${NAMESPACE}'
                }
            }

            post {
                success {
                    slackSend color: 'good', message: """
                    - :white_check_mark: Stage > '${env.STAGE_NAME.toUpperCase()}' < has completed successfully.
                    """.stripIndent()
                }
                failure {
                    slackSend color: 'danger', message: """
                    - :exclamation: Stage > '${env.STAGE_NAME.toUpperCase()}' < has failed.
                    """.stripIndent()
                }
            }
        }
      
    }
        
            post {
                success {
                    slackSend color: 'good', message: 
                    """
                    - Build SUCCESS! :tada:
                    - Finished in: ${currentBuild.durationString}
                    - Link: <${env.BUILD_URL}|Open>
                    """.stripIndent()
                }
                failure {
                    slackSend color: 'danger', failOnError: true, message: 
                    """
                    - Build FAILED! :x:
                    - Finished in: ${currentBuild.durationString}
                    - Link: <${env.BUILD_URL}|Open>
                    """.stripIndent()
                }
            }

}
