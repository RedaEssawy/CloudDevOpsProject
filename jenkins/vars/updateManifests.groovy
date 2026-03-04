// vars/updateManifests.groovy
def call(Map params) {
    def imageName = params.imageName
    def newTag = params.newTag
    def deploymentFile = params.deploymentFile
    
    echo "Updating ${deploymentFile} with image ${imageName}:${newTag}"
    
    
    // Check if the file exists
    sh """
        if [ -f "${deploymentFile}" ]; then
            echo "Found deployment file at ${deploymentFile}"
            sed -i "s|image: ${imageName}:.*|image: ${imageName}:${newTag}|g" ${deploymentFile}
            echo "Updated ${deploymentFile} with new image tag"
            grep "image:" ${deploymentFile} || echo "No image line found"
        else
            echo "ERROR: Deployment file not found at ${deploymentFile}"
            echo "Current directory: \$(pwd)"
            echo "Directory contents:"
            ls -la
            echo "Looking for kubernetes directory:"
            ls -la kubernetes/ || echo "kubernetes directory not found"
            exit 1
        fi
    """
}