def call(Map params) {
    def imageName = params.imageName
    def tag = params.tag
    def severity = params.severity ?: 'CRITICAL,HIGH'
    def ignoreUnfixed = params.ignoreUnfixed ?: 'true'
    
    sh """
        trivy image --severity ${severity} --ignore-unfixed=${ignoreUnfixed} ${imageName}:${tag} || true
    """
}