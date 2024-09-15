pipeline {
  agent any

  stages {
      stage('Build Artifact') {
            steps {
              sh "mvn clean package -DskipTests=true"
              archive 'target/*.jar'
            }
        } 

      stage('Unit tests') {
            steps {
              sh "mvn test"
            }
            // post{
            //   always{
            //      junit 'target/surefire-reports/*.xml'
            //      jacoco execPattern:'target/jacoco.exec'
            //   }
            // }
        } 

      stage('Mutation test stage -> PIT'){
           steps {
               sh "mvn org.pitest:pitest-maven:mutationCoverage"
           }
          //  post{
          //    always{
          //     pitmutation mutationStatsFile: '**/target/pit-reports/**/mutations.xml'
          //    }
          //  }
      }

      // stage('SonarQube Analysis') {
      //       steps{
      //            withSonarQubeEnv('SonarQube'){
      //               sh "mvn sonar:sonar -Dsonar.projectKey=Numeric-devsecops -Dsonar.host.url=http://http://43.204.233.89:9000'"
      //            }
      //            timeout(time:2,unit: 'MINUTES'){
      //             script{
      //               waitForQualityGate abortPipeline: true
      //             }
      //            }
                  
      //       }
      //   }

                  stage('Vulnerability scan - Docker') {
                    steps {
                      parallel(
                        "Dependency Scan": {
                            sh "mvn dependency-check:check"
                             },
                         "Trivy Scan": {
                            sh "bash trivy-docker-image-scan.sh"
                           }
                         )
                      }
                   }




      stage('Docker Build and Push') {
            steps {
                 withDockerRegistry([url:"", credentialsId: "dockerhublogin"]){
                       sh 'printenv'
                       sh 'sudo docker build -t ski00026/numeric-app:""$GIT_COMMIT""  .'
                       sh 'docker push ski00026/numeric-app:""$GIT_COMMIT""'
                 }
                 
            }
        }

      stage(' valunerability scan for k8s'){
        steps{
           sh "bash kube-sec-scan.sh"
        }
      }

      
      stage('K8s Deployment-DEV') {
            steps {
              withKubeConfig([credentialsId: 'kubeconfig']){
               sh "sed -i 's#replace#ski00026/numeric-app:${GIT_COMMIT}#g' k8s_deployment_service.yaml"
               sh "kubectl apply -f k8s_deployment_service.yaml"
            }
        }  
      }


   }


      post {
              always{
                 junit 'target/surefire-reports/*.xml'
                 jacoco execPattern:'target/jacoco.exec'
                 pitmutation mutationStatsFile: '**/target/pit-reports/**/mutations.xml'
                 dependencyCheckPublisher pattern: "target/dependency-check-report.xml"
              }

            }

      

    



 }
