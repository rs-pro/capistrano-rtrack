namespace :rtrack do
  USER_TOKEN_FILE = "~/.rtrack-api-token"
  task :collect_env do
    @data = {
      #local_user: fetch(:local_user),
      branch: fetch(:branch),
      commit_hash: fetch(:current_revision, "HEAD"),
      stage: fetch(:stage),
      environment: fetch(:rails_env),
      repo_url: fetch(:repo_url),
      hosts: [],
    }
  end

  task :notify_deploy_started => [:collect_env] do
    data = @data
    on roles(:app) do |host|
      host_url = "#{host&.user}.#{host&.hostname}"
      data[:hosts].push(host_url)
    end

    client = fetch(:rtrack_client)
    r = client.deploy_started(@data)
    if r.nil?
      raise "response of rtrack is nil"
    elsif r['id'].blank?
      p r
      raise "no deploy id"
    else
      @deploy_id = r['id']
    end
  end

  task :notify_deploy_finished do
    client = fetch(:rtrack_client)

    client = fetch(:rtrack_client)
    if @deploy_id.nil?
      puts "Rtrack: no deploy_id, cant report"
    else
      client.deploy_finished(@deploy_id)
    end
  end

  task :notify_deploy_failed do
    client = fetch(:rtrack_client)
    if @deploy_id.nil?
      puts "Rtrack: no deploy_id, cant report"
    else
      client.deploy_failed(@deploy_id)
    end
  end

  puts "install rtrack cap tasks"
  after "git:set_current_revision", "rtrack:notify_deploy_started"
  after "deploy:finished", "rtrack:notify_deploy_finished"
  before "deploy:failed", "rtrack:notify_deploy_failed"
  before "deploy:reverted", "rtrack:notify_deploy_failed"
end

namespace :load do
  task :defaults do
    if !File.file?(USER_TOKEN_FILE)
      puts "Пожалуйста перейдите на страницу настроек проекта и добавьте токен деплоя"
      puts "в настройки деплоя set :rtrack_token, 'ваш токен'"
      puts "Он находится внизу раздела настроек 'общие'"
      raise "rtrack no project api token"
    end
    set(:rtrack_user_token, File.read(USER_TOKEN_FILE))
    set(:rtrack_client, -> {
      base_url = fetch(:rtrack_server) || "https://rtrack.ru/"
      token = fetch(:rtrack_token)
      if token.blank?
        puts "Пожалуйста перейдите на страницу https://rtrack.ru/keys и создайте ключ деплоя"
        puts "при помощи кнопки + Deploy"
        puts "Ключ необходимо поместить в файл ~/.rtrack-api-token"
        raise "rtrack no project api token"
      end
      Capistrano::Rtrack::Client.new(base_url, token)
    })
  end
end
