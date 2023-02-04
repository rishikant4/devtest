pipeline {
    agent any
    environment {
        def git_branch = 'master'
        def git_url = 'https://github.com/rishikant4/devtest.git'

        def mvntest = 'mvn test '
        def mvnpackage = 'mvn clean install'

        def sonar_cred = 'sonar'
        def code_analysis = 'mvn clean install sonar:sonar'
        
        def utest_url = 'target/surefire-reports/**/*.xml'
        
        def nex_cred = 'nexus'
        def grp_ID = 'com.example'
        def nex_url = '43.204.140.112:8081'
        def nex_ver = 'nexus3'
        def proto = 'http'
    }
    stages {
        stage('Git Checkout') {
            steps {
                script {
                    git branch: "${git_branch}", url: "${git_url}"
                    echo 'Git Checkout Completed'
                }
            }
        } 
        stage('Maven Build') {
            steps {
                sh "${env.mvnpackage}"
                echo 'Maven Build Completed'
            }
        }
        stage('Unit Testing and publishing reports') {
            steps {
                script {
                    sh "${env.mvntest}"
                    echo 'Unit Testing Completed'
                }
            }
            post {
                success {
                        junit "$utest_url"
                        jacoco()
                }
            }
        }
        stage('Static code analysis and Quality Gate Status') {
            steps {
                script {
                    withSonarQubeEnv(credentialsId: "${sonar_cred}") {
                        sh "${code_analysis}"
                    }
                    waitForQualityGate abortPipeline: true, credentialsId: "${sonar_cred}"
                }
            }
        } 
        stage('Upload Artifact to nexus repository') {
            steps {
                script {
                    
                    def mavenpom = readMavenPom file: 'pom.xml'
                    nexusArtifactUploader artifacts: [
                    [
                        artifactId: 'Java_app',
                        classifier: '',
                        file: "target/Java_app-${mavenpom.version}.war",
                        type: 'war'
                    ]
                ],
                    credentialsId: "${env.nex_cred}",
                    groupId: "${env.grp_ID}",
                    nexusUrl: "${env.nex_url}",
                    nexusVersion: "${env.nex_ver}",
                    protocol: "${env.proto}",
                    repository: 'demoproject-Release',
                    version: "${mavenpom.version}"
                    echo 'Artifact uploaded to nexus repository'
                }
            }
        } 
    }
}

