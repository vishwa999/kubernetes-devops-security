pipeline {
  agent any

  stages {
      stage('Build Artifact') {
            steps {
              sh "mvn clean package -DskipTests=true"
              archive 'target/*.jar' //so that they can be downloaded late
            }
        }

       stage(' Unit Test- Junit and jacoco') {
           steps{
                sh "mvn test"
              }
             post{
               always{
                 junit 'target/surefire-reports/*.xml'
                 jacoco execPattern: 'target/jacoco.exec'
                }
              }
        }
        stage('Docker Build and push'){
          steps{
             withDockerRegistry([credentialsId: "docker-hub", url: ""]){
                sh 'printenv'
                sh 'docker build -t ski00026/numeric-app:""$GIT_COMMIT"". '
                sh 'docker push ski00026/numeric-app:""$GIT_COMMIT""'
              }
           }
        }
    }
}