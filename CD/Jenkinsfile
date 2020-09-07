pipeline {
    agent any
    parameters{ 

        choice(name: 'ENV', choices: ['dev', 'test'], description: 'which namesapce')

        }

    
    stages {

        stage('deploy app') {

            steps {
            // sh "sed -i 's/ht/${env.HOST}/g' ./node-app-configmap.yml"
            sh "sed -i 's/user/${env.USER}/g' ./node-app-configmap.yml"
            sh "sed -i 's/pd/${env.PASSWORD}/g' ./node-app-configmap.yml"
            sh "sed -i 's/db/${env.DATABASE}/g' ./node-app-configmap.yml"
            sh 'cat ./node-app-configmap.yml'


            // sh "kubectl apply -f mysql-service.yml --namespace ${params.ENV}"
            // sh "kubectl apply -f node-app-service.yml --namespace ${params.ENV}"
            // sh "kubectl apply -f node-app-configmap.yml --namespace ${params.ENV}"
            // sh "kubectl apply -f node-app-pod.yml --namespace ${params.ENV}"
            sh "ansible-playbook -e 'env=${params.ENV}'  ansible_playbook.yml "


            }
        }

    }
}

