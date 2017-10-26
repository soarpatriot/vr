namespace :docker do 
  task :upload_compose do 
    on roles :web do 
      dest = "#{shared_path}/docker-compose.yml"
      upload! from_template("docker-compose.yml.erb"), dest
      info "Uploaded to '#{fetch(:server_name)}@#{dest}'"
    end
  end
end
