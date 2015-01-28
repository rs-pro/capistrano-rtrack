namespace :rtrack do
  task :after_deploy do
    on roles(:db) do
      Capistrano::Rtrack.run
    end
  end

  after 'deploy:finished', 'rtrack:after_deploy'
end

