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
            post{
              always{
                 junit 'target/surefire-reports/*.xml'
                 jacoco execPattern:'target/jacoco.exec'
              }
            }
        } 
      stage('Docker Build and Push') {
            steps {
                 docker.withRegistry([url:"", credentialsId: "dockerhublogin"]){
                  
                       sh 'printenv'
                       sh 'docker build -t ski00026/numeric-app:""$GIT_COMMIT""'
                       sh 'docker push ski00026/numeric-app:""$GIT_COMMIT""'
                 }
                 
            }
        } 



 }
}