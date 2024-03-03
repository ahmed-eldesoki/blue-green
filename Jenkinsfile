pipeline {
  environment {
     
        KUBECONFIG = credentials('kubernetescred')
    }
  agent any
  
  stages {
    stage('Deploy Blue app') {
            steps {
       
   
     
          sh '''
                cd backend
                npm install
                npm run build
                ls -lh
                    '''
   }
  }
  }
}

  