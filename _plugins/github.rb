#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-
#
# References:
#   - https://developer.github.com/v3/projects/
#   - https://developer.github.com/v3/repos
#   - https://developer.github.com/v3/repos/contents/

require 'logger'
require 'date'
require 'net/http'
require 'net/https'
require 'base64'
require 'json'
require 'yaml'

module Jekyll
  module HG
    class GithubRepo
      def initialize(owner, repo, token)
        @url = 'https://api.github.com'

        @owner = owner
        @repo = repo
        @token = token
        @info = {}

        Jekyll.logger.info 'Fetching repo info...'
        fetch_repo_info
        Jekyll.logger.info 'Fetching releases...'
        fetch_releases
        Jekyll.logger.info 'Fetching readme...'
        fetch_readme
      end

      def get(api, headers: {})
        uri = URI(@url + api)
        http = Net::HTTP.new(uri.host, uri.port)
        if uri.scheme == 'https'
          http.use_ssl = true
        end
        req = Net::HTTP::Get.new(uri.path, {})

        if @token != nil
          req ['Authorization'] = "token #{@token}"
        end
        for k, v in headers
          req[k] = v
        end

        resp = http.request(req)
        resp.body
      end

      def fetch_repo_info()
        api = "/repos/#{@owner}/#{@repo}"
        resp = get(api)
        json = JSON.parse(resp)

        @info['name'] = json['name']
        @info['full_name'] = json['full_name']
        @info['description'] = json['description']
        @info['url'] = json['html_url']
        @info['forks_count'] = json['forks_count']
        @info['stargazers_count'] = json['stargazers_count']

        if json.key?('owner')
          owner = {}
          o = json['owner']

          owner['name'] = o['login']
          owner['url'] = o['html_url']
          owner['avatar_url'] = o['avatar_url']
          owner['gravatar_id'] = o['gravatar_id']

          @info['owner'] = owner
        end
      end

      def fetch_releases()
        api = "/repos/#{@owner}/#{@repo}/releases"
        resp = get(api)
        json = JSON.parse(resp)

        @info['releases'] = json.map { |r|
          release = {}

          release['name'] = r['name']
          release['version'] = r['tag_name']
          release['date'] = DateTime.strptime(r['published_at'], '%Y-%m-%dT%H:%M:%S%z')
          release['url'] = r['html_url']
          release['prerelease'] = r['prerelease']
          release['notes'] = r['body']

          # Source
          source = {}
          source['tar'] = r['tarball_url']
          source['zip'] = r['zipball_url']
          release['source'] = source

          # Artifacts
          # TODO
          artifacts = {}
          release['artifacts'] = artifacts

          release
        }
      end

      def fetch_readme()
        api = "/repos/#{@owner}/#{@repo}/readme"
        resp = get(api)
        json = JSON.parse(resp)

        name = json['name']
        encoding = json['encoding']
        content = json['content']

        raw = ''
        if encoding == 'base64'
          raw = Base64.decode64(content)
        end

        # Get rendered readme
        html = get(api, headers: {
          'Accept' => 'application/vnd.github.v3.html',
        })

        readme = {}
        readme['name'] = name
        readme['raw'] = raw
        readme['html'] = html

        @info['readme'] = readme
      end

      # Export varibles
      attr_reader :info
    end
  end
end

# Run without Jekyll
if !Jekyll.respond_to? :logger
  module Jekyll
    class << self
      def logger
        @logger = Logger.new(STDOUT)
      end
    end
  end
  repo = Jekyll::HG::GithubRepo.new('SilverRainZ', 'srain', nil)
  puts repo.info.to_yaml
end

# vim: set expandtab:
# vim: set tabstop=2:
# vim: set shiftwidth=2:
# vim: set softtabstop=2:
