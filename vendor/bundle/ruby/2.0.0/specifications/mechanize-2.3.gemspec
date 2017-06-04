# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "mechanize"
  s.version = "2.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Eric Hodel", "Aaron Patterson", "Mike Dalessio", "Akinori MUSHA"]
  s.cert_chain = ["-----BEGIN CERTIFICATE-----\nMIIDVzCCAj+gAwIBAgIBATANBgkqhkiG9w0BAQUFADBBMRAwDgYDVQQDDAdkcmJy\nYWluMRgwFgYKCZImiZPyLGQBGRYIc2VnbWVudDcxEzARBgoJkiaJk/IsZAEZFgNu\nZXQwHhcNMTIwMTMxMDEwMzUyWhcNMTMwMTMwMDEwMzUyWjBBMRAwDgYDVQQDDAdk\ncmJyYWluMRgwFgYKCZImiZPyLGQBGRYIc2VnbWVudDcxEzARBgoJkiaJk/IsZAEZ\nFgNuZXQwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCbbgLrGLGIDE76\nLV/cvxdEzCuYuS3oG9PrSZnuDweySUfdp/so0cDq+j8bqy6OzZSw07gdjwFMSd6J\nU5ddZCVywn5nnAQ+Ui7jMW54CYt5/H6f2US6U0hQOjJR6cpfiymgxGdfyTiVcvTm\nGj/okWrQl0NjYOYBpDi+9PPmaH2RmLJu0dB/NylsDnW5j6yN1BEI8MfJRR+HRKZY\nmUtgzBwF1V4KIZQ8EuL6I/nHVu07i6IkrpAgxpXUfdJQJi0oZAqXurAV3yTxkFwd\ng62YrrW26mDe+pZBzR6bpLE+PmXCzz7UxUq3AE0gPHbiMXie3EFE0oxnsU3lIduh\nsCANiQ8BAgMBAAGjWjBYMAkGA1UdEwQCMAAwCwYDVR0PBAQDAgSwMB0GA1UdDgQW\nBBS5k4Z75VSpdM0AclG2UvzFA/VW5DAfBgNVHREEGDAWgRRkcmJyYWluQHNlZ21l\nbnQ3Lm5ldDANBgkqhkiG9w0BAQUFAAOCAQEAge3LmAU2QbrS2/grAEmRu3bCCHrQ\nNSc6j+p53VJ1DraNWEMY3D90F/SKzsI0SYgZb71i49k+pNA2CVXzEJAY7agZbjWJ\nUbgGKN8u9SGbIoQPBPIl97JPIGlR7AoEdmlWyFySaZD4o6+Q0onUXIV+P/KrYTVb\nZj/NEjHGrvskpDzlYI2LvG71DFp1o0hfIZzdvfWLAMVqtuEjJ6QrUm9FttR06rNo\nitgEKl/tNI4M9oKJT0faQ5PvJ70ualcLnwkBLyJVd2r8qwxfjUAjKF8iMpBSb98s\nYJY7T/W2n+eWy8WuPhzVUkyzguj0bQe27NDeabgCh2mHd4Hynk2AkYh8MQ==\n-----END CERTIFICATE-----\n"]
  s.date = "2012-02-21"
  s.description = "The Mechanize library is used for automating interaction with websites.\nMechanize automatically stores and sends cookies, follows redirects,\nand can follow links and submit forms.  Form fields can be populated and\nsubmitted.  Mechanize also keeps track of the sites that you have visited as\na history."
  s.email = ["drbrain@segment7.net", "aaronp@rubyforge.org", "mike.dalessio@gmail.com", "knu@idaemons.org"]
  s.extra_rdoc_files = ["Manifest.txt", "CHANGELOG.rdoc", "EXAMPLES.rdoc", "GUIDE.rdoc", "LICENSE.rdoc", "README.rdoc"]
  s.files = ["Manifest.txt", "CHANGELOG.rdoc", "EXAMPLES.rdoc", "GUIDE.rdoc", "LICENSE.rdoc", "README.rdoc"]
  s.homepage = "http://mechanize.rubyforge.org"
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.7")
  s.rubyforge_project = "mechanize"
  s.rubygems_version = "2.0.14"
  s.summary = "The Mechanize library is used for automating interaction with websites"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<net-http-digest_auth>, [">= 1.1.1", "~> 1.1"])
      s.add_runtime_dependency(%q<net-http-persistent>, [">= 2.5.2", "~> 2.5"])
      s.add_runtime_dependency(%q<mime-types>, [">= 1.17.2", "~> 1.17"])
      s.add_runtime_dependency(%q<nokogiri>, ["~> 1.4"])
      s.add_runtime_dependency(%q<ntlm-http>, [">= 0.1.1", "~> 0.1"])
      s.add_runtime_dependency(%q<webrobots>, [">= 0.0.9", "~> 0.0"])
      s.add_runtime_dependency(%q<domain_name>, [">= 0.5.1", "~> 0.5"])
      s.add_development_dependency(%q<minitest>, ["~> 2.10"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.10"])
      s.add_development_dependency(%q<hoe>, ["~> 2.13"])
    else
      s.add_dependency(%q<net-http-digest_auth>, [">= 1.1.1", "~> 1.1"])
      s.add_dependency(%q<net-http-persistent>, [">= 2.5.2", "~> 2.5"])
      s.add_dependency(%q<mime-types>, [">= 1.17.2", "~> 1.17"])
      s.add_dependency(%q<nokogiri>, ["~> 1.4"])
      s.add_dependency(%q<ntlm-http>, [">= 0.1.1", "~> 0.1"])
      s.add_dependency(%q<webrobots>, [">= 0.0.9", "~> 0.0"])
      s.add_dependency(%q<domain_name>, [">= 0.5.1", "~> 0.5"])
      s.add_dependency(%q<minitest>, ["~> 2.10"])
      s.add_dependency(%q<rdoc>, ["~> 3.10"])
      s.add_dependency(%q<hoe>, ["~> 2.13"])
    end
  else
    s.add_dependency(%q<net-http-digest_auth>, [">= 1.1.1", "~> 1.1"])
    s.add_dependency(%q<net-http-persistent>, [">= 2.5.2", "~> 2.5"])
    s.add_dependency(%q<mime-types>, [">= 1.17.2", "~> 1.17"])
    s.add_dependency(%q<nokogiri>, ["~> 1.4"])
    s.add_dependency(%q<ntlm-http>, [">= 0.1.1", "~> 0.1"])
    s.add_dependency(%q<webrobots>, [">= 0.0.9", "~> 0.0"])
    s.add_dependency(%q<domain_name>, [">= 0.5.1", "~> 0.5"])
    s.add_dependency(%q<minitest>, ["~> 2.10"])
    s.add_dependency(%q<rdoc>, ["~> 3.10"])
    s.add_dependency(%q<hoe>, ["~> 2.13"])
  end
end
