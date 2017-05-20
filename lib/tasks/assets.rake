# lib/tasks/assets.rake
# The webpack task must run before assets:environment task.
# Otherwise Sprockets cannot find the files that webpack produces.
# This is the secret sauce for how a Heroku deployment knows to create the webpack generated JavaScript files.
Rake::Task["assets:precompile"]
  .clear_prerequisites
  .enhance([
             "js:routes",
             "i18n:js:export",
             "assets:compile_environment"
           ])

namespace :assets do
  # In this task, set prerequisites for the assets:precompile task
  task compile_environment: :webpack do
    Rake::Task["assets:environment"].invoke
  end
  desc "Compile assets with webpack"
  task :webpack do
    # => prefix commands with /tmp/amplo/nvm-exec.sh on AWS servers
    # => http://stackoverflow.com/questions/41174807/capistrano-deploy-fails-with-react-on-rails-when-npm-is-installed-via-nvm
    nvm_prefix = '/tmp/city-commerces.com/nvm-exec.sh' if File.exist?('/tmp/city-commerces.com/nvm-exec.sh')
    sh "cd client && #{nvm_prefix} npm install"
    sh "cd client && #{nvm_prefix} npm run build:client"
    sh "cd client && #{nvm_prefix} npm run build:server"
  end
  desc "Compile assets with webpack"
  task :webpack do
    nvm_prefix = '/tmp/city-commerces.com/nvm-exec.sh' if File.exist?('/tmp/city-commerces.com/nvm-exec.sh')
    
    sh "cd client && #{nvm_prefix} npm run build:client"

    # Skip next line if not doing server rendering
    sh "cd client && #{nvm_prefix} npm run build:server"
  end

  task :clobber do
    # Remove compiled webpack files
    rm_r Dir.glob(Rails.root.join("app/assets/webpack/*"))

    # Remove compiled language bundles
    rm_r Dir.glob(Rails.root.join("app/assets/javascripts/i18n/*"))
    rm_r Dir.glob(Rails.root.join("client/app/i18n/*"))

    # Remove routes
    rm_r Dir.glob(Rails.root.join("client/app/routes/*"))
  end
end
