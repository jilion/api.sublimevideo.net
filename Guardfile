notification :gntp

guard :rspec, bundler: false, all_after_pass: false, all_on_start: false, keep_failed: false do
  watch(%r{^((app|lib)/.+)\.rb}) { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^spec/.+\.rb})
end
