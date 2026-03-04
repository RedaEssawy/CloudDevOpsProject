def call(Map params) {
    def imageName = params.imageName
    def tag = params.tag
    def credentialsId = params.credentialsId
    
    withDockerRegistry([credentialsId: credentialsId, url: '']) {
        sh """
            docker push ${imageName}:${tag}
        """
    }
}