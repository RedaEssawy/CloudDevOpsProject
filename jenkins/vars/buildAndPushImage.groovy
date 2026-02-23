def call(String imageName, String dockerCredentialsId) { 
    sh "docker build -t ${imageName}:${BUILD_NUMBER} ."
    withCredentials([usernamePassword(credentialsId: dockerCredentialsId, passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
        sh "echo ${PASSWORD} | docker login -u ${USERNAME} --password-stdin "
        sh "docker push ${imageName}:${BUILD_NUMBER}"
    }

    // Add your image building logic here
}