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
               kubectl apply -f ./prod-service.yaml
               sleep 15
               kubectl get pods -l app=blue-app
               
                    '''
   }
  }

  stage('providing Blue app URL') {
        steps {
           script {
                    def serviceIP = sh(script: "kubectl get services tomcat-prod -o jsonpath='{.status.loadBalancer.ingress[0].ip}'", returnStdout: true).trim()
                   
                    echo "The service URL is: http://${serviceIP}:8080"
                    sleep 15
                    
                }
   }
   }

  stage('Deploy Green app') {
            steps {
               sh '''
               kubectl apply -f ./green-app
               sleep 10
               kubectl get pods -l app=green-app
               
                    '''
   }
  } 

  stage('testing Green app') {
        steps {
           script {
                    
                    def curlOutput = sh(script: "kubectl exec -it curl-pod -- curl -s http://tomcat-test-green:8080 | grep -oP '<h1>\\K(.*?)(?=<\\/h1>)'", returnStdout: true).trim()
                    
                    if (curlOutput == 'Hello from green app') {
                        echo "it's the Green app"
                    } else {
                        error "the Green app in not up"
                    }
                }
   }
   }
   stage('switching to the Green app') {
            steps {
          sh '''
              kubectl patch service tomcat-prod --type='json' -p='[{"op": "replace", "path": "/spec/selector", "value": {"env": "green"}}]'
               
                    '''
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

  