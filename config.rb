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
languages = ['de', 'en']
active_nav = {:class => "Active"}

# This declares the variables which are to be used in every template
variables = {  'index' => { :nav_home => active_nav },
               'faq' => { :nav_faq => active_nav },
               'payment' => {}, 
               'pricing' => { :nav_pricing => active_nav },
               'contact_us' => { :bottom_nav_contact => active_nav },
               'privacy_statement' => { :bottom_nav_privacy => active_nav },
               'conditions_of_use' => { :bottom_nav_conditions => active_nav },
               'about_us' => { :bottom_nav_about => active_nav },
               'searching' => {},
               'multiple' => {},
               'thinking' => {},
               'thankyou' => {},
               'allmailblocked' => {},
               'allmailimap' => {},
               'sitemap' => {},
               'busyforus' => {},
               'contacted' => {}
             }

# This maps layouts directly to existing physical template files
layouts = { 'layouts/floating_content_without_logo_layout' => [ 'index' ],
  'layouts/floating_content_with_logo_layout' => [ 'faq' ],
  'layouts/centered_content_with_logo_layout' => [  'payment', 'pricing', 'searching', 
    'contact_us', 'privacy_statement', 'conditions_of_use', 'about_us', 'multiple', 
    'thinking', 'thankyou', 'allmailblocked', 'allmailimap', 'busyforus' , 'contacted' ],
  'layouts/xml_layout' => [ 'sitemap' ]
  }

class Hashit
  def initialize(hash)
    hash.each do |k,v|
      self.instance_variable_set("@#{k}", v)  ## create and initialize an instance variable for this key/value pair
      self.class.send(:define_method, k, proc{self.instance_variable_get("@#{k}")})  ## create the getter that returns the instance variable
      self.class.send(:define_method, "#{k}=", proc{|v| self.instance_variable_set("@#{k}", v)})  ## create the setter that sets the instance variable
    end
  end
end

def set_common_page_variables(params)
  params.reverse_merge! :nav_home => {}, :nav_pricing => {}, 
    :nav_faq => {}, :bottom_nav_contact => {}, :bottom_nav_privacy => {},
    :bottom_nav_conditions => {}, :bottom_nav_about => {}
  
  params.each do |name,value|
    self.instance_variable_set("@#{name}", value)
  end

  @t = @lang[@page_id]
  site_links = generate_site_links(@lang.paths, @lang_name)
  @links = Hashit.new(site_links)
end

def generate_site_links(paths, language)
  links = Hash.new
  
  paths.each do |page_id,page_name|
    if true  # if we're building for production - UNDONE!
      links[page_id] = page_id == "index" ? "/" : "/#{page_name}"
    else
      links[page_id] = "/#{language}/#{page_name}.html"
    end
  end
  
  return links
end

def self.get_page_path(paths, page_id, language)
  page_name = paths[page_id]
  
  if page_id == "index"
    return "/#{language}/index.html"
  else
    return "/#{language}/#{page_name}.html"
  end
end

layouts.each do |layout,page_ids|
  with_layout :"#{layout}" do
    page_ids.each do |page_id|
      page_variables = variables[page_id]
  
      languages.each do |lang_name|
        lang = data.method_missing(lang_name)
        page_path = get_page_path(lang.paths, page_id, lang_name)
        
        page page_path, :proxy => "/#{page_id}.html", :ignore => false do
          page_variables.merge! :lang_name => lang_name, :lang => lang, :page_id => page_id
          set_common_page_variables page_variables
        end
      end
    end
  end
end

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

###
# Helpers
###

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

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
