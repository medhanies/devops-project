pipeline {
  agent any
  environment {
    TF_IN_AUTOMATION = 'true'
    TF_CLI_CONFIG_FILE = credentials('tf-creds')
    AWS_SHARED_CREDENTIALS_FILE='/home/ubuntu/.aws/credentials'
  }
  stages {
    stage('init') {
      steps {
        sh 'ls'
        sh 'terraform init -no-color'
      }
    }
    stage('plan') {
      steps {
        sh 'terraform plan -no-color'
      }
    }
    stage('validate apply') {
      input {
        message "do you want to apply this plan?"
        ok "apply this plan"
      }
    }
    stage('apply') {
      steps {
        sh 'terraform apply -auto-approve -no-color'
      }
    }
    stage('ec2 wait') {
      steps {
        sh 'aws ec2 wait instance-status-ok --region us-west-1'
      }
    }
    stage('Ansible') {
      steps {
        ansiblePlaybook(credentialsId: 'ec2-ssh-key', inventory: 'aws_hosts', playbook: 'playbooks/main-playbook.yml')
      }
    }
    stage('destroy') {
      steps {
        sh 'terraform destroy -auto-approve -no-color'
      }
    }
  }
}
