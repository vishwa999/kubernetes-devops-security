pipeline {
  agent any

  stages {
      stage('Build Artifact Maven') {
            steps {
              sh "mvn clean package -DskipTests=true"
              archive 'target/*.jar'
            }
        } 

      stage('Unit test coverage using JACOCO') {
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

      stage('Mutation test, Test Unit Test -> PIT'){
           steps {
               sh "mvn org.pitest:pitest-maven:mutationCoverage"
           }
          //  post{
          //    always{
          //     pitmutation mutationStatsFile: '**/target/pit-reports/**/mutations.xml'
          //    }
          //  }
      }

      stage('SonarQube Analysis') {
            steps{
                 withSonarQubeEnv('SonarQube'){
                   // sh "mvn sonar:sonar -Dsonar.projectKey=Numeric-devsecops -Dsonar.host.url=http://13.201.77.16:9000'"
                 }
                //  timeout(time:2,unit: 'MINUTES'){
                //   script{
                //     waitForQualityGate abortPipeline: true
                //   }
                //  }
                  
            }
        }

                  stage('Vulnerability scan - Docker using Trivy and Dep scan') {
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

      stage('Valunerability scan for k8s using KubeSec'){
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

      stage('OWASP -ZAP using open API'){
         steps{
          withKubeConfig([credentialsId: "kubeconfig"]){
            sh "bash zap.sh"
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
                 publishHTML([allowMissing: false, alwaysLinkToLastBuild: true, keepAll: true, reportDir: 'owasp-zap-report', reportFiles: 'zap_report.html', reportName: 'OWASP ZAP HTML Report', reportTitles: 'OWASP ZAP HTML Report', useWrapperFileDirectly: true])
              }

            }

      

    



 }
