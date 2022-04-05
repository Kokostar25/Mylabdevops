pipeline {
    //Directives - agent, tools env etc any means it will run this pipeline on any available agent. 
    //This will instruct jenkins to allocate an executor and at the same time create the workspace 
    //for the entire pipeline also tool section to pre install any tool we may require or add the tool to the path
    agent any
    tools {
        maven 'maven'
    }

    environment {
        ArtifactId = readMavenPom().getArtifactId()
        Version = readMavenPom().getVersion()
        Name = readMavenPom().getName()
        GroupId = readMavenPom().getGroupId()
    }
    stages {
        // You specify various stages with in a stage
        // Stage 1 - Build
        stage ('Build') {
            steps {
                sh 'mvn clean install package'
            }

        }

        // Stage 2 - Testing 
        stage ('Test') {
            steps {
                echo 'testing code .....'
            }
        }

        // Stage 3 - Publish the artifacts to Nexus
        stage ('Publish to nexus') {
            steps {
                script {
                
                def NexusRepo = Version.endsWith("SNAPSHOT") ? "VinaysDevOpsLab-SNAPSHOT" : "VinaysDevopsLab-Release"
                
                nexusArtifactUploader artifacts: 
                [[artifactId: "${ArtifactId}", classifier: '', 
                file: "target/${ArtifactId}-${Version}.war", 
                type: 'war']], 
                credentialsId: 'e639752e-d85c-45ee-922d-ed119cdf76ab', 
                groupId: "${GroupId}", 
                nexusUrl: '10.0.1.209:8081', 
                nexusVersion: 'nexus3', 
                protocol: 'http', 
                repository: "${NexusRepo}", 
                version: "${Version}"

               } 

            }
        }

        // Stage 4 - Print some information
        stage ('Print Environment Variables') {
            steps {
                echo "Artifact ID is '${ArtifactId}'"
                echo "Version is '${Version}'"
                echo "Group ID is '${GroupId}'"
                echo "Name is '${Name}'"
            }
        }

        // Stage 5 - Deploying 
        stage ('Deploy') {
            steps {
                echo 'Deploying code...'
                sshPublisher(publishers: 
                [sshPublisherDesc(
                    configName: 'Ansible_Controller', 
                    transfers: [sshTransfer(cleanRemote: false, 
                    excludes: '', execCommand: 'ansible-playbook /opt/playbooks/downloadanddeploy.yaml -i /opt/playbooks/hosts', 
                    execTimeout: 120000, flatten: false, 
                    makeEmptyDirs: false, 
                    noDefaultExcludes: false, 
                    patternSeparator: '[, ]+', 
                    remoteDirectory: '', 
                    remoteDirectorySDF: false, 
                    removePrefix: '', sourceFiles: '')], 
                    usePromotionTimestamp: false, 
                    useWorkspaceInPromotion: false, 
                    verbose: false)
                    ])
            }
        }

    }


}