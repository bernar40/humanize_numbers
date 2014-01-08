Gem::Specification.new do |s|
  s.name = %q{humanize_numbers}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ivan Torres"]
  s.date = %q{2014-01-07}
  s.description = %q{Gem for Ruby on Rails to describe a number in words for english or spanish}
  s.email = %q{gab.edera@gmail.com}
  s.extra_rdoc_files = ["README.rdoc", "lib/humanize_numbers.rb"]
  s.files = ["humanize_numbers.gemspec", "Manifest", "README.rdoc", "Rakefile", "init.rb", "lib/humanize_numbers.rb"]
  s.has_rdoc = true
  s.homepage = %q{https://github.com/gedera/humanize_numbers}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Humanize_numbers", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Gem for Ruby on Rails to describe a number in words for english or spanish}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
