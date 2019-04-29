# gitlab-docker-execturor

Docker image to be used as GitlabCI build runner. The image is distributed via DockerHub: [dmitrybelyakov/gitlab-docker-execturor](https://cloud.docker.com/u/dmitrybelyakov/repository/docker/dmitrybelyakov/gitlab-docker-execturor)

Your exact CI scenario is executed by the runner as an Ansible playbook ran against your target server(s).

In order to set up CI for your GitLab project you will first need to set up a few secrets injected via environment variables. Go to your project > Settings > CI/CD > Environment variables and set:

  * `PROVISIONER_CHECKOUT_KEY` private key that is allowed to checkout provisioner playbooks
  * `PROVISIONER_GIT_URL` git repository containing the playbooks
  * `SERVER_ACCESS_KEY` private key with access to the server

### .gitlab-ci.yml

Here is an example CI configuration for a project with two environments:

```yaml
image: dmitrybelyakov/gitlab-docker-execturor

# configure ssh
before_script:
  - 'which ssh-agent || ( apt-get update -y && apt-get install openssh-client -y )'
  - 'eval $(ssh-agent -s)'
  - 'ssh-add <(echo "$PROVISIONER_CHECKOUT_KEY")'
  - 'ssh-add <(echo "$SERVER_ACCESS_KEY")'
  - 'mkdir -p ~/.ssh'
  - '[[ -f /.dockerenv ]] && echo -e "Host *\n\tStrictHostKeyChecking no\n\n" > ~/.ssh/config'

# staging
staging:
  type: deploy
  script:
    - git clone $PROVISIONER_GIT_URL $CI_PROJECT_DIR/ansible/
    - ansible-playbook -i $CI_PROJECT_DIR/ansible/inventory.ini $CI_PROJECT_DIR/ansible/staging.yml
  only:
    - staging

# production
production:
  type: deploy
  script:
    - git clone $PROVISIONER_GIT_URL $CI_PROJECT_DIR/ansible/
    - ansible-playbook -i $CI_PROJECT_DIR/ansible/inventory.ini $CI_PROJECT_DIR/ansible/production.yml
  only:
    - master

# cleanup
after_script:
  - rm -rf $CI_PROJECT_DIR/ansible
  - rm -rf ~/.ssh



```

 
