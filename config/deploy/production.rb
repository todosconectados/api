set :deploy_to, '/home/ec2-user/projects/gcomm'

# Rails environment
set :rails_env, 'production'

# Git config
set :branch, 'production'

# ssh config
server ENV.fetch('EC2_INSTANCE_PROD'),
  user: 'ec2-user',
  roles: %w(web db app)
