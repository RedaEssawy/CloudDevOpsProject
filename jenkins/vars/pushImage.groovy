def call(String IMAGE_NAME, String IMAGE_TAGC, String USERNAME, String PASSWORD) {
    sh "echo ${PASSWORD} | docker login -u ${USERNAME} --password-stdin"
    sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
    
}