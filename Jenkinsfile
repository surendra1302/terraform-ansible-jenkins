pipeline {
    agent any

    environment {
        AWS_REGION = "us-east-1"
        TF_WORKING_DIR = "${WORKSPACE}/terraform"
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/surendra1302/terraform-ansible-jenkins.git'
            }
        }

        stage('Terraform Init') {
            steps {
                dir("${TF_WORKING_DIR}") {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir("${TF_WORKING_DIR}") {
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir("${TF_WORKING_DIR}") {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir("${TF_WORKING_DIR}") {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }

        stage('Extract EC2 Public IP') {
            steps {
                script {
		    def ec2Ip = sh(script: "terraform -chdir=${TF_WORKING_DIR} output -raw ec2_public_ip", returnStdout: true).trim()
            	    echo "EC2 Instance Public IP: ${ec2Ip}"
	            def inventoryContent = "[ec2-instance]\n${ec2Ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa"
	            writeFile file: 'ansible/inventory', text: inventoryContent		
                }
            }
        }

        stage('Run Ansible Playbook') {
            steps {
                sh 'ansible-playbook -i ansible/inventory ansible/playbook.yml'
            }
        }

        stage('Terraform Destroy') {
            when {
                beforeAgent true
                expression { return params.DESTROY }
            }
            steps {
                dir("${TF_WORKING_DIR}") {
                    sh 'terraform destroy -auto-approve'
                }
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'ansible/inventory', onlyIfSuccessful: true
        }
        success {
            echo "Terraform and Ansible execution completed successfully!"
        }
        failure {
            echo "Build failed! Check the logs for errors."
        }
    }
}

