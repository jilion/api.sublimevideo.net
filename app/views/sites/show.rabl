object @site => :site

attributes :token, :hostname, :accessible_stage

node(:extra_domains) { |site| site.extra_hostnames.try(:split, ', ') || [] }
node(:dev_domains) { |site| site.dev_hostnames.try(:split, ', ') || [] }
node(:staging_domains) { |site| site.staging_hostnames.try(:split, ', ') || [] }
node(:wildcard) { |site| site.wildcard? }
node(:path) { |site| site.path || '' }
