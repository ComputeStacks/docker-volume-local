require_relative 'lib/docker_volume_local/version'

Gem::Specification.new do |spec|
  spec.name          = "docker_volume_local"
  spec.version       = DockerVolumeLocal::VERSION
  spec.authors       = ["Kris Watson"]
  spec.email         = ["kris@computestacks.com"]

  spec.summary       = "Provides local storage for Docker & ComputeStacks"
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/ComputeStacks/docker-volume-local"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.pkg.github.com"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/ComputeStacks/docker-volume-local"
  spec.metadata["changelog_uri"] = "https://github.com/ComputeStacks/docker-volume-local"
  spec.metadata['github_repo'] = "ssh://github.com/ComputeStacks/docker-volume-local.git"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'activesupport', '> 5.0'
  spec.add_runtime_dependency 'docker-api'
  spec.add_runtime_dependency 'net-ssh', '> 6.0'
  spec.add_runtime_dependency 'ed25519', '> 1.2'
  spec.add_runtime_dependency 'bcrypt_pbkdf', '> 1.0'

  spec.add_development_dependency "minitest", "~> 5.13"
  spec.add_development_dependency "minitest-reporters", "> 1"
  spec.add_development_dependency "rake", "~> 12.3"
  spec.add_development_dependency "vcr", "~> 5.0"

end
