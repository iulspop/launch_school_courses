notification :libnotify, display_message: false

directories %w(courses)

guard :minitest, test_folders: ['courses'] do
  watch(%r{courses/(.*/)?(.*/)?(?!test_)([^/]+)\.rb}) do |match|
    "courses/#{match[1]}#{match[2]}test_#{match[3]}.rb"
  end
  watch(%r{courses/(.*/)?(.*/)?test_([^/]+)\.rb})
end