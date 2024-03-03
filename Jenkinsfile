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
  stage('testing the new deplyment') {
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

  }
}

  