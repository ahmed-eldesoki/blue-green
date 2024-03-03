pipeline {
  environment {
     
        KUBECONFIG = credentials('kubernetescred')
    }
  agent any
  
  stages {
    stage('Deploy Blue app') {
            steps {
          sh '''
               kubectl apply -f ./blue-app
               sleep 10
               kubectl get pods -l app=blue-app
                    '''
   }
    }
    stage('testing the current deplyment') {
            steps {
             script {
                    def serviceIP = sh(script: "kubectl get services tomcat-test-blue -o jsonpath='{.status.loadBalancer.ingress[0].ip}'", returnStdout: true).trim()
                    def curlOutput = sh(script: "curl -s http://${serviceIP}:8080 | grep -oP '<h1>\\K(.*?)(?=<\\/h1>)'", returnStdout: true).trim()
                    echo "Exit status: ${curlOutput}"
                    if (curlOutput == 'Hello from blue app') {
                        echo "it's the blue app"
                    } else {
                        error "the blue app in not up"
                    }
                }
   }
  }
   stage('rolling update to green app') {
            steps {
          sh '''
               kubectl patch deployment blue-app -p '{"spec": {"template": {"spec": {"containers": [{"name": "blue", "image": "ahmedeldesoki/tomcat:green"}]}}}}'
               sleep 10
                    '''
   }
  }
  stage('testing the new deplyment & rollback if fails') {
            steps {
             script {
                    try {
                    def serviceIP = sh(script: "kubectl get services tomcat-test-blue -o jsonpath='{.status.loadBalancer.ingress[0].ip}'", returnStdout: true).trim()
                    def curlOutput = sh(script: "curl -s http://${serviceIP}:8080 | grep -oP '<h1>\\K(.*?)(?=<\\/h1>)'", returnStdout: true).trim()
                    echo "Exit status: ${curlOutput}"
                    if (curlOutput == 'Hello from blue app') {
                        echo "it's the green app"
                    } else {
                        error "the green app in not up"
                    }
                    } catch (Exception e) {
                        sh 'kubectl rollout undo deploy/blue-app'

                    }
                }
   }
  }
  stage('Sending notifications') {
            steps {
                emailext (
                    subject: "Blue Green Deployment Status",
                    body: """<p>SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]':</p>
        <p>Check console output at &QUOT;<a href='${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]</a>&QUOT;</p>""",
                    to: "ahmedeldesoki78@gmail.com",
                    attachLog: true
                )
            }
        }

  }
}

  