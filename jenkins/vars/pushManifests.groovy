def call(Map params) {
    def manifestsRepo = params.manifestsRepo
    def branch = params.branch ?: 'main'
    def credentialsId = params.credentialsId
    def sourceDeploymentFile = params.sourceDeploymentFile  // Path in project repo
    def targetDeploymentFile = params.targetDeploymentFile ?: 'deployment.yaml'  // Path in manifests repo
    def commitMessage = params.commitMessage ?: 'Update manifests'
    
    echo "Pushing manifests to separate repo: ${manifestsRepo}"
    
    // Create a unique directory for the manifests repo
    dir('manifests-repo') {
        // Clean up any existing content
        sh 'rm -rf *'
        
        // Clone the manifests repository with credentials
        withCredentials([string(credentialsId: credentialsId, variable: 'GITHUB_TOKEN')]) {
            // Use the token for authentication
            def cloneUrl = manifestsRepo.replace('https://', "https://${GITHUB_TOKEN}@")
            sh """
                git clone ${cloneUrl} .
                git checkout ${branch} || git checkout -b ${branch}
            """
        }
        
        // Create the directory structure if needed
        def targetDir = targetDeploymentFile.substring(0, targetDeploymentFile.lastIndexOf('/') + 1)
        if (targetDir != targetDeploymentFile) {
            sh "mkdir -p ${targetDir}"
        }
        
        // Copy the updated deployment.yaml from the project repo
        sh """
            echo "Copying from project repo: ../${sourceDeploymentFile}"
            echo "Copying to manifests repo: ./${targetDeploymentFile}"
            
            # Check if source file exists
            if [ ! -f "../${sourceDeploymentFile}" ]; then
                echo "ERROR: Source deployment file not found at ../${sourceDeploymentFile}"
                echo "Current directory: \$(pwd)"
                echo "Contents of parent directory:"
                ls -la ../
                exit 1
            fi
            
            # Copy the file
            cp ../${sourceDeploymentFile} ./${targetDeploymentFile}
            
            # Show the changes
            echo "Updated deployment.yaml content:"
            cat ./${targetDeploymentFile} | grep -A2 -B2 "image:"
            
            # Configure git
            git config user.email "redaessawy81@gmail.com"
            git config user.name "RedaEssawy"
            
            # Add and commit the changes
            git add ${targetDeploymentFile}
            
            # Check if there are changes to commit
            if git diff --staged --quiet; then
                echo "No changes to commit"
            else
                git commit -m "${commitMessage}"
                
                # Push the changes
                echo "Pushing to ${branch} branch..."
                git push origin ${branch}
                
            fi
        """
    }
}