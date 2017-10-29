module Jekyll
  module HG
    class Generator < Jekyll::Generator
      safe true
      priority :low

      def check_config(config)
        # Check github
        if !config.key?('github')
          Jekyll.logger.warn "'github' is not set"
          return false
        end
        github = config['github']
        if !github.is_a?(String)
          raise Jekyll::Errors::InvalidConfigurationError,
            "'github' should be a string"
        end
        if github.count('/') != 1
          raise Jekyll::Errors::InvalidConfigurationError,
            "'#{github}' is a invalid github repository identifier"
        end

        # Check token
        if !config.key?('token')
          Jekyll.logger.warn "'token' is not set, the request may be limited"
        end

        return true
      end

      def generate(site)
        config = site.config
        if config.key?('project')
          Jekyll.logger.info 'Fetched, using cache...'
          return
        end

        if !check_config(config)
          return
        end

        project = {}
        owner_name, repo_name = config['github'].split('/', 2)
        repo = HG::GithubRepo.new(owner_name, repo_name, config['token'])

        # Information from github repository name
        project['name'] = repo.info['name']
        project['owner'] = repo.info['owner']
        project['url'] = repo.info['url']
        project['description'] = repo.info['description']

        project['readme'] = repo.info['readme']

        project['releases'] = repo.info['releases']

        site.config['project'] = project
      end
    end
  end
end

# vim: set expandtab:
# vim: set tabstop=2:
# vim: set shiftwidth=2:
# vim: set softtabstop=2:
