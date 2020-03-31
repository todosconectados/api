set :deploy_to, '/home/ec2-user/projects/todosconectados'

# Rails environment
set :rails_env, 'production'

# Git config
set :branch, 'master'

# ssh config
server ENV.fetch('EC2_INSTANCE_PROD'),
  user: 'ec2-user',
  roles: %w(web db app)
