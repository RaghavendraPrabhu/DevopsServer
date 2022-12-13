pipeline {
    agent any;
    
    stages {
        stage('Pull-Dummy'){
          steps{
			echo "Pulling The Dummy Code From Git Hub Repo Master......"
            dir('/var/lib/jenkins/workspace/SiddhatechDevopsJenkins/dummyservices') {
                git branch: 'master', credentialsId: 'e7fdeab5-08f3-4d82-b72c-b4647a2fb387', url: 'https://github.com/RaghavendraPrabhu/DevopsServer.git'
                }
            }
        }
               
        stage('Package War'){
		
          steps{
			echo "Packaging The Code Into ProductosServicios War File......"
            dir('/var/lib/jenkins/workspace/SiddhatechDevopsJenkins/dummyservices') {
                echo "Packaging The Updated Code......"
                sh 'jar -cvf ProductosServicios.war *'
              }
            }
        }
               
        stage('Pull-MAM'){
          steps{
		  	echo "Pulling The Updated MAM Code From Git Hub Repo dummyMAM......"
            dir('/var/lib/jenkins/workspace/SiddhatechDevopsDemo/MAM') {
                git branch: 'dummyMAM', credentialsId: 'e7fdeab5-08f3-4d82-b72c-b4647a2fb387', url: 'https://github.com/Siddhatech/MAM-BPD.git'
                }
            }
        }
        
        stage('PackageMAM'){
          steps{
			echo "Packaging The MAM Code MAMBPD ZIP File......"
            dir('/var/lib/jenkins/workspace/SiddhatechDevopsDemo/MAM') {
		        sh '/usr/local/sbin/activator compile'
                sh '/usr/local/sbin/activator dist'
                }
            }
        }
        
        stage('Unzip-Jar/Copy'){
          steps{
			echo "UNZIP MAMBPD File And Copy The MAM Jar To Docker MAM Folder......"
            dir('/var/lib/jenkins/workspace/SiddhatechDevopsDemo/MAM/target/universal') {
		    sh 'unzip -o mambpd-1.0-SNAPSHOT.zip'
		    sh 'cp /var/lib/jenkins/workspace/SiddhatechDevopsDemo/build.gradle /var/lib/jenkins/workspace/SiddhatechDevopsDemo/android-app/SSC_BPDContainer'
            sh 'chmod -R 777 /var/lib/jenkins/workspace/SiddhatechDevopsDemo'
            sh 'chmod -R 777 /var/lib/jenkins/workspace/SiddhatechDevopsJenkins'
			sh 'cp -r /var/lib/jenkins/workspace/SiddhatechDevopsDemo/MAM/target/universal/mambpd-1.0-SNAPSHOT/lib /var/lib/jenkins/workspace/SiddhatechDevopsJenkins/mam'
            
                
            }
            dir('/var/lib/jenkins/workspace/SiddhatechDevopsJenkins') {
			sh 'docker-compose down --rmi all'  
            }    
                
            }
        }
        
        stage('Pull-AndroidAPP'){
          steps{
			echo "Pulling The Updated ANDROID Code From Git Hub Repo master......"
            dir('/var/lib/jenkins/workspace/SiddhatechDevopsDemo/android-app') {
                sh 'rm -r /var/lib/jenkins/workspace/SiddhatechDevopsDemo/android-app/SignApksBuilder-out'
                git branch: 'master', credentialsId: 'e7fdeab5-08f3-4d82-b72c-b4647a2fb387', url: 'https://github.com/Siddhatech/Android_Demo.git'
              
              }
            }
        }
        
        stage('App-Build'){
            steps{
                echo "Builing Android APK......"
                dir('/var/lib/jenkins/workspace/SiddhatechDevopsDemo/android-app') {
                                                sh """
                export ANDROID_HOME=/var/lib/jenkins/android-sdk/android-sdk;
                export ANDROID_NDK_HOME=/var/lib/jenkins/android-sdk/android-sdk/android-ndk-r21d;
                export PATH=\$PATH:\$ANDROID_HOME/tools:\$ANDROID_HOME/platform-tools;
                
                bash ./gradlew clean build
"""
                //step([$class: 'SignApksBuilder', androidHome: '/var/lib/jenkins/android-sdk/android-sdk', apksToSign: '/var/lib/jenkins/workspace/EmpressaAPK/**/*.apk', keyAlias: 'banco popular', keyStoreId: 'Android_Key', skipZipalign: true]) 
                //step([$class: 'SignApksBuilder', apksToSign: '/var/lib/jenkins/workspace/EmpressaAPK/**/*.apk', keyAlias: 'banco popular', keyStoreId: 'JenkinsKey'])
                //step([$class: 'SignApksBuilder', apksToSign: '/var/lib/jenkins/workspace/EmpressaAPK/*.apk', keyAlias: 'banco popular', keyStoreId: 'Android-Key'])
                //step([$class: 'SignApksBuilder', androidHome: '/var/lib/jenkins/android-sdk/android-sdk', archiveSignedApks: false, apksToSign: '/var/lib/jenkins/workspace/EmpressaAPK/*.apk', keyAlias: 'banco popular', keyStoreId: 'Android-Key',skipZipalign: true])
                //step([$class: 'SignApksBuilder', apksToSign: '/var/lib/jenkins/workspace/APP-EMPRESSA-ANDROID/build/outputs/apk/**/*.apk', keyAlias: 'banco popular', keyStoreId: 'Android-Key'])
                step([$class: 'SignApksBuilder', androidHome: '/var/lib/jenkins/android-sdk/android-sdk', apksToSign: 'SSC_BPDContainer/build/outputs/apk/dev/*.apk', keyAlias: 'banco popular', keyStoreId: 'Android-Key', signedApkMapping: unsignedApkNameDir(), skipZipalign: true])
                
                            }

                //Sign APK    
                //([$class: 'SignApksBuilder', androidHome: '/opt/android-sdk', archiveSignedApks: false,apksToSign: 'SSC_BPDContainer/build/outputs/apk/**/*.apk', keyAlias: 'banco popular', keyStoreId: 'bpd-android-key', skipZipalign: true])                
            }
        }
		
		
		stage('Send-APK'){
            steps{
            echo "Sending Android APK To Concern Person......"   
            dir('/var/lib/jenkins/workspace/SiddhatechDevopsDemo/android-app/SignApksBuilder-out') {
emailext attachmentsPattern: 'SSC_BPDContainer-dev-unsigned.apk/*.apk', body: '''Hi Raghavendra,
Attached Is  Android Build For Siddhatech Server Demo
Jenkins Build Number - $BUILD_NUMBER''', subject: 'Siddhatech Demo Jenkins Build APK - ${BUILD_TIMESTAMP}', to: 'raghavendrap@siddhatech.com'
                }
            }
        }
		
        stage('Dockerise'){
          steps{
		  	echo "Dockerise DummyService MAM & MAM-APPS......"
            dir('/var/lib/jenkins/workspace/SiddhatechDevopsJenkins') {
                sh 'docker-compose up -d'
                }
            }
        }
        
    }

}

