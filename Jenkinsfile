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
        sh 'cat $BRANCH_NAME.tfvars'
        sh 'terraform init -no-color'
      }
    }
    stage('plan') {
      steps {
        sh 'terraform plan -no-color -var-file="$BRANCH_NAME.tfvars"'
      }
    }
    stage('validate apply') {
      when {
        beforeInput true
        branch "dev"
      }
      input {
        message "do you want to apply this plan?"
        ok "apply this plan"
      }
      steps {
        echo 'Apply Accepted'
      }
    }
    stage('apply') {
      steps {
        sh 'terraform apply -auto-approve -no-color -var-file="$BRANCH_NAME.tfvars"'
      }
    }
    stage('Inventory') {
      steps {
        sh '''printf \\
          "\\n$(terraform output -json instance_ips | jq -r \'.[]\')" \\
            >> aws_hosts'''
      }
    }
    stage('ec2 wait') {
      steps {
        sh '''aws ec2 wait instance-status-ok \\
                      --instance-ids $(terraform output -json instance_ids | jq -r \'.[]\') \\
                      --region us-west-1'''
      }
    }
    stage('validate ansible') {
      when {
        beforeInput true
        branch "dev"
      }
      input {
        message "do you want to run Ansible?"
        ok "apply run Ansible!"
      }
      steps {
        echo 'Ansible Accepted'
      }
    }
    stage('Ansible') {
      steps {
        ansiblePlaybook(credentialsId: 'ec2-ssh-key', inventory: 'aws_hosts', playbook: 'playbooks/main-playbook.yml')
      }
    }
    stage('Test Grafana and Prometheus') {
      steps {
        ansiblePlaybook(credentialsId: 'ec2-ssh-key', inventory: 'aws_hosts', playbook: 'playbooks/node-test.yml') 
      }
    }
    stage('validate Destory') {
      input {
        message "do you want to destroy everything?"
        ok "Destroy!"
      }
      steps {
        echo 'Destroy Accepted'
      }
    }
    stage('destroy') {
      steps {
        sh 'terraform destroy -auto-approve -no-color -var-file="$BRANCH_NAME.tfvars"'
      }
    }
  }
  post {
    success {
      echo 'success'
    }
    failure {
      sh 'terraform destroy -auto-approve -no-color -var-file="$BRANCH_NAME.tfvars"'
    }
    aborted {
      sh 'terraform destroy -auto-approve -no-color -var-file="$BRANCH_NAME.tfvars"'
    }
  }
}