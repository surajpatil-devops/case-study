#!groovy
pipeline {
	agent { label 'docker' }
	parameters {
		string(name: 'IMAGE_NAME', defaultValue: 'mydockerimage', description: 'Enter a image name', trim: true)
		string(name: 'TAG_NAME', defaultValue: '', description: 'Image tag no', trim: true)
		booleanParam(name: 'DEPLOY?', defaultValue: false, description: 'Check the box to deploy')
	
	}
	
	stages {
		stage("Checkout") {
			checkout scm
		}
		
		stage("Build Image") {
			steps {
				sh "docker build -t ${params.IMAGE_NAME}:${params.TAG_NAME}
			}
		}
		
		stage("Docker Push") {
			steps {
				withCredentials([usernamePassword(credentialsId: 'dockerHub', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
					sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPassword}"
					sh "docker push ${params.IMAGE_NAME}:${params.TAG_NAME}"
				}
			}
		}
		
		stage("Deploy App") {
			when {
				expression { params.DEPLOY}
			}
			steps {
				sh "docker run -ti --name mydocker -v mydata:/mnt ${params.IMAGE_NAME}:${params.TAG_NAME}"
			}
		}
	}

}
