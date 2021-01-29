/

// -----------------------------------------------------------------------------------------
//
// Global variables
//

def timestamp = new Date().format("yyyy-MM-dd-HH-mm")
def version = "1.0.0"
def sqScannerMsBuildHome = "D:/Jenkins/tools/sonarqube-4.8.0-netcoreapp3.0"
def workspace_Dir = "D:/BuildZone/workspace/CSS/NTNT"

// -----------------------------------------------------------------------------------------
//
// The main pipeline section
//

pipeline {

    options {
        // Ensure each branch only has 1 job running at a time
        disableConcurrentBuilds()
        // Discard old build logs
        buildDiscarder(logRotator(numToKeepStr: '5', artifactNumToKeepStr: '5'))
    }
    
    agent {
        node {
            label "qa-windows-agent0"
            customWorkspace "${workspace_Dir}"
        }
    }

    environment {
        // OpenCover and VS Test Environment variables
        OpenCover = "D:/BuildZone/OpenCover"
        VSTest = "C:/Program Files (x86)/Microsoft Visual Studio/2017/Enterprise/Common7/IDE/CommonExtensions/Microsoft/TestWindow"
        // Nuget Environment variables
        Nuget_Proxy = "https://nexus.nednet.co.za/repository/nuget-group"
        Npm_Proxy = "https://nexus.nednet.co.za/repository/npm-group/"
        // SonarQube Environment variables
        SonarQube_Project_Key = "NTNT-Api"
        SonarQube_Project_Name = "Nedbank Track and Trace Api"
        SonarQube_Project_Exclusions = "**/Scripts/*,**/*.js,**/*.json,**/*.ts"
        // MSBuild Environment variables
        Api_Sln = "NedbankTrackAndTrace.API.sln"
        UI_Sln = "NTnT.UI.sln"
        UI_Support_Sln = "SupportUI.sln"
        ApiTests_Sln = "NTnT.APITest.sln"
        Api_Path = "Source/API"
        UI_Path = "Source/UI/NTNT.WebFE"
        UI_Support_Path = "Source/UI/NTnT.SupportUI/SupportUI"
        ApiTests_Path = "Source/APITests/APITest V2/NTnT.APITest"
        Test_Component = "NTnT.APITest/bin/Debug/NTnT.APITest.dll"
        // UCD
        UCD_Component_Name_Api = "NTNT-Api"
        UCD_Component_Name_UI = "NTNT-UI"
        UCD_Component_Name_UI_Support = "NTNT-Support-UI"
        // Email Addresses
        To_Email = "temp@nedbank.co.za"
        From_Email = "devops@nedbank.co.za"
    }

    stages {    
        stage("SonarQube Initialise"){
            steps {
                script{
                    dir ("${workspace}/${env.Api_Path}") {
                       // Set-up the SonarQube environment, which is defined in Jenkins under 'Global Tools Configuration'
                        withSonarQubeEnv('SonarQube') {
                            bat "echo \"${SONAR_HOST_URL}\""
                            bat "dotnet ${sqScannerMsBuildHome}/SonarScanner.MSBuild.dll begin /k:\"${env.SonarQube_Project_Key}\" \
                                /n:\"${env.SonarQube_Project_Name}\" \
                                /v:\"${env.Version}\" \
                                /d:sonar.verbose=\"true\" \
                                /d:sonar.branch.name=\"${BRANCH_NAME}\" \
                                /d:sonar.host.url=\"${SONAR_HOST_URL}\" \
                                /d:sonar.login=\"${SONAR_AUTH_TOKEN}\" \
                                /d:sonar.cs.opencover.reportsPaths=\"${workspace}/${env.ApiTests_Path}/opencover.xml\" \
                                /d:sonar.exclusions=\"${env.SonarQube_Project_Exclusions}\" \
                                /d:sonar.buildbreaker.skip=\"true\""
                        }
                    }
                }
            }
        }
        
        stage('DotNet Build Api'){
            steps{         
                script {
                    dir ("${workspace}/${env.Api_Path}") {   
                        bat "dotnet restore ${env.Api_Sln} -s ${Nuget_Proxy}"
                        bat "dotnet build ${env.Api_Sln}"
                    }
                }
            }
        }

        stage('DotNet Build UI'){
            steps{         
                script {
                    dir ("${workspace}/${env.UI_Path}") {       
                        bat "dotnet restore ${env.UI_Sln} -s ${Nuget_Proxy}"
                        bat "dotnet build ${env.UI_Sln}"
                    }
                }
            }
        }

        stage('DotNet Build Support UI'){
            steps{         
                script {
                    dir ("${workspace}/${env.UI_Support_Path}") {       
                        bat "dotnet restore ${env.UI_Support_Sln} -s ${Nuget_Proxy}"
                        bat "dotnet build ${env.UI_Support_Sln}"
                    }
                }
            }
        }

        stage('DotNet Build Unit Testing'){
            steps{         
                script {
                    dir ("${workspace}/${env.ApiTests_Path}") {
                        def MSBuild = tool 'MSBuild VS 2017'
                        bat "nuget restore ${env.ApiTests_Sln} -Source ${env.Nuget_Proxy}"
                        bat "dotnet build ${env.ApiTests_Sln}"
                    }
                }
            }
        }

        stage('Api Unit Testing'){
            steps{
                script{
                    dir ("${workspace}/${env.ApiTests_Path}") {
                        try {
                            echo "=====> Running unit tests"
                            // Run all the unit tests for this project, outputting the results to a MS Test (.trx) file 
                            bat "${env.OpenCover}/OpenCover.Console -output:\"opencover.xml\" -register:user -target:\"${env.VSTest}/vstest.console.exe\" -targetargs:\"${env.Test_Component}\""          
                        } catch (err) {
                            echo err.getMessage()
                            echo "Error detected, but we will continue."
                        }
                    }
                }
            }
        }

        stage ('SonarQube End') {
            steps {
                script {
                    dir ("${workspace}/${env.Api_Path}") {
                        withSonarQubeEnv('SonarQube') {
                            // Complete the build process and upload the results to the SonarQube server for processing
                            bat "dotnet ${sqScannerMsBuildHome}/SonarScanner.MSBuild.dll end /d:sonar.login=${SONAR_AUTH_TOKEN}"
                        }
                    }
                }
            }
        }      
        
        stage('DotNet Publish Api'){
            steps{
                dir("${workspace}/${env.Api_Path}"){
                    bat "rm -rf ../../Api-Out"
                    bat "dotnet publish ${env.Api_Sln} -c Release -o ../../Api-Out"        
                }
                bat "cp -r ${workspace}/Source/SwashbuckleComponents/* ${workspace}/Api-Out"
            }
        }

        stage('DotNet Publish UI'){
            steps{
                dir("${workspace}/${env.UI_Path}"){
                    bat "rm -rf ../../../UI-Out"
                    bat "dotnet publish ${env.UI_Sln} -c Release -o ../../../UI-Out"                 
                }
            }
        }

        stage('DotNet Publish Support UI'){
            steps{
                dir("${workspace}/${env.UI_Support_Path}"){
                    bat "rm -rf ../../../../UI-Support-Out"
                    bat "dotnet publish ${env.UI_Support_Sln} -c Release -o ../../../../UI-Support-Out"                 
                }
            }
        }

        stage ('UCD Publish') {
            when {
                anyOf {
                    branch "master"
                    branch "feature/*"
                    branch "hotfix/*"
                    branch "devops"
                }
            }
            steps {
                script {
                    step([$class: 'UCDeployPublisher',
                    siteName: 'UCD PROD',
                    component: [
                        $class: 'com.urbancode.jenkins.plugins.ucdeploy.VersionHelper$VersionBlock',
                        componentName: "${env.UCD_Component_Name_Api}",
                        delivery: [
                            $class: 'com.urbancode.jenkins.plugins.ucdeploy.DeliveryHelper$Push',
                            pushVersion: "${BRANCH_NAME}_${BUILD_NUMBER}",
                            baseDir: "${workspace}/Api-Out", 
                            fileIncludePatterns: '**/*',
                            fileExcludePatterns: '',
                            pushProperties: 'jenkins.server=Local\njenkins.reviewed=false',
                            pushDescription: 'Pushed from Jenkins'
                        ]
                      ]
                    ])
					step([$class: 'UCDeployPublisher',
                    siteName: 'UCD PROD',
                    component: [
                        $class: 'com.urbancode.jenkins.plugins.ucdeploy.VersionHelper$VersionBlock',
                        componentName: "${env.UCD_Component_Name_UI}",
                        delivery: [
                            $class: 'com.urbancode.jenkins.plugins.ucdeploy.DeliveryHelper$Push',
                            pushVersion: "${BRANCH_NAME}_${BUILD_NUMBER}",
                            baseDir: "${workspace}/UI-Out", 
                            fileIncludePatterns: '**/*',
                            fileExcludePatterns: '',
                            pushProperties: 'jenkins.server=Local\njenkins.reviewed=false',
                            pushDescription: 'Pushed from Jenkins'
                        ]
                      ]
                    ])
                    step([$class: 'UCDeployPublisher',
                    siteName: 'UCD PROD',
                    component: [
                        $class: 'com.urbancode.jenkins.plugins.ucdeploy.VersionHelper$VersionBlock',
                        componentName: "${env.UCD_Component_Name_UI_Support}",
                        delivery: [
                            $class: 'com.urbancode.jenkins.plugins.ucdeploy.DeliveryHelper$Push',
                            pushVersion: "${BRANCH_NAME}_${BUILD_NUMBER}",
                            baseDir: "${workspace}/UI-Support-Out", 
                            fileIncludePatterns: '**/*',
                            fileExcludePatterns: '',
                            pushProperties: 'jenkins.server=Local\njenkins.reviewed=false',
                            pushDescription: 'Pushed from Jenkins'
                        ]
                      ]
                    ])
                }
            }
		}
    }

    post {
        success {
            emailext attachLog: true, body: "Result: SUCCESS<br> URL: ${BUILD_URL}<br><br> Nice One! :-)", subject: "SUCCESS Jenkins: Build #${BUILD_NUMBER} for ${JOB_NAME}", from: "${env.From_Email}", to: "${env.To_Email}"
        }

        failure {
            emailext attachLog: true, body: "Result: FAILED<br> URL: ${BUILD_URL}<br><br> Lets Try Again! :-(", subject: "FAILED Jenkins: Build #${BUILD_NUMBER} for ${JOB_NAME}", from: "${env.From_Email}", to: "${env.To_Email}"
        }  
    }
}



withSonarQubeEnv('SonarQube') {
                    sh "mvn sonar:sonar " + 
                    '-f agents/pom.xml '+
                    '-Dsonar.projectKey=ngi-was-agents ' +
                    '-Dsonar.login=ee59061ac50a322beaee87a498477a0a9626b5bb ' +
                    '-Dsonar.host.url=https://sonarqube.nednet.co.za ' +
                    '-Dsonar.java.binaries=.'                    
                }


                sh "mvn -f agents/pom.xml clean install"

stage ('trigger xlr') {
            steps {
                xlrCreateRelease releaseTitle: 'test pipeline for $BUILD_TAG', serverCredentials: 'Tool-Admin', startRelease: true, overrideCredentialId: 'XLR-Admin', template: 'BizDevOps Toolchain/henk-test', variables: [[propertyName: "jira_tasks", propertyValue: "${tasks}"]]                
            }
        }