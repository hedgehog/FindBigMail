###
# Compass
###

# Susy grids in Compass
# First: gem install compass-susy-plugin
# require 'susy'

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Haml
###

# CodeRay syntax highlighting in Haml
# First: gem install haml-coderay
# require 'haml-coderay'

# CoffeeScript filters in Haml
# First: gem install coffee-filter
# require 'coffee-filter'

# Automatic image dimensions on image_tag helper
activate :automatic_image_sizes

###
# Page command
###
#

active_nav = {:class => "Active"}

# Per-page layout changes:
# 
# With no layout
# page "/path/to/file.html", :layout => false
# 
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
# 
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy (fake) files
# page "/this-page-has-no-template.html", :proxy => "/template-file.html" do
#   @which_fake_page = "Rendering a fake page with a variable"
# end

I18n.load_path += Dir[ File.join(Dir.getwd, 'locale', '*.{rb,yml}') ]

langs = Dir["locale/*.yml"].map { |file| File.basename(file).gsub(".yml", "") }
files = Dir["source/localizable/**"]

langs.each do |lang|
  I18n.locale = lang
  files.each do |file|
    src = file.split("source/").last.gsub(".haml", "")
    page_id = File.basename(src, File.extname(src))
    new_page = "/" + src.gsub("localizable", lang).
      gsub(page_id, I18n.t("paths.#{page_id}", :default => page_id))
    page new_page, :proxy => src, :ignore => true do
      I18n.locale = lang
      @lang = lang
      @page_id = page_id
    end
  end
end


###
# Helpers
###

# Methods defined in the helpers block are available in templates
helpers do
  def nav_active(page)
    @page_id == page ? {:class => "Active"} : {}
  end
  def path(page)
    t("paths.#{page}")
  end
end

# Change the CSS directory
# set :css_dir, "alternative_css_directory"

# Change the JS directory
# set :js_dir, "alternative_js_directory"

# Change the images directory
# set :images_dir, "alternative_image_directory"

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  activate :minify_css
  
  # Minify Javascript on build
  # activate :minify_javascript
  
  # Enable cache buster
  # activate :cache_buster
  
  # Use relative URLs
  # activate :relative_assets
  
  # Compress PNGs after build
  # First: gem install middleman-smusher
  # require "middleman-smusher"
  # activate :smusher
  
  # Or use a different image path
  # set :http_path, "/Content/images/"
end
