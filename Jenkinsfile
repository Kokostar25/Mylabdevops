pipeline {
    //Directives - agent, tools env etc any means it will run this pipeline on any available agent. 
    //This will instruct jenkins to allocate an executor and at the same time create the workspace 
    //for the entire pipeline also tool section to pre install any tool we may require or add the tool to the path
    agent any
    tools {
        maven 'maven'
    }
    stages {
        // You specify various stages with in a stage
        stage ('Build') {
            steps {
                sh 'mvn clean install package'
            }

        }
        stage ('Test') {
            steps {
                echo 'testing code .....'
            }
        }
        stage ('Deploy') {
            steps {
                echo 'Deploying code...'
            }
        }

    }


}