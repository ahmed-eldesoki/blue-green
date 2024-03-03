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
                    def curlOutput = sh(script: 'curl -s http://example.com | grep -oP \'<h1>\\K(.*?)(?=<\\/h1>)\'', returnStatus: true).trim()

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
                    '''
   }
  }

  }
}

  