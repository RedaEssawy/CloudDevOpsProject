def call(Map params) {
    def imageName = params.imageName
    def tag = params.tag
    def dockerfilePath = params.dockerfilePath ?: 'Dockerfile'
    def buildContext = params.buildContext ?: '.'
    
    sh """
        docker build -f ${dockerfilePath} -t ${imageName}:${tag} ${buildContext}
    """
}