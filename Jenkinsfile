pipeline {
  environment {
     
        KUBECONFIG = credentials('kubernetescred')
    }
  agent any
  
  stages {
    stage('Deploy Blue app') {
            steps {
       
   
     
          sh '''
               kubectl get pods
                    '''
   }
  }
  }
}

  