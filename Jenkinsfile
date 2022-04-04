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
        stage ('Publish to nexus') {
            steps {
                nexusArtifactUploader artifacts: [[artifactId: 'VinayDevOpsLab', classifier: '', file: 'target/VinayDevOpsLab-0.0.4-SNAPSHOT.war', type: 'war']], credentialsId: 'e639752e-d85c-45ee-922d-ed119cdf76ab', groupId: 'com.vinaysdevopslab', nexusUrl: '10.0.1.209:8081', nexusVersion: 'nexus3', protocol: 'http', repository: 'VinaysDevOpsLab-SNAPSHOT', version: '0.0.4-SNAPSHOT'
            }
        }
        stage ('Deploy') {
            steps {
                echo 'Deploying code...'
            }
        }

    }


}