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
               kubectl get pods -l app=blue
                    '''
   }
  }
  }
}

  