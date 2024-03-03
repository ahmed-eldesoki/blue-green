pipeline {
  environment {
     
        KUBECONFIG = credentials('kubernetescred')
    }
  agent any
  
  stages {
    stage('Deploy Blue app') {
            steps {
          sh '''
               kubectl delete -f ./blue-app
               kubectl delete -f ./green-app
               kubectl delete -f ./prod-service.yaml
             
               
                    '''
   }
  }

   }
  }


  