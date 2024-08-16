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
                 jacoco execPatterns: 'target/jacoco.exec'
                }
              }
         }
    }
}