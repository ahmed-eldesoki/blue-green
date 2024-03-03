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
   stage('rolling update to green app') {
            steps {
          sh '''
               kubectl patch deployment blue-app -p '{"spec": {"template": {"spec": {"containers": [{"name": "blue", "image": "ahmedeldesoki/tomcat:green"}]}}}}'
                    '''
   }
  }
  }
}

  