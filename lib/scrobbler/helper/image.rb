module Scrobbler
  # Defines some functions that are used nearly all Scrobbler classes which
  # have to deal with image references.
  #
  # This module defines the class functions, use "extend ImageClassFuncs" in
  # class.
  module ImageClassFuncs
    # Check if the given libxml node is an image referencing node and in case
    # of, read it into that given hash of data 
    def maybe_image_node(data, node)
      if node.name == 'image'
        data[:image_small] = node.content if node['size'] == 'small'
        data[:image_medium] = node.content if node['size'] == 'medium'
        data[:image_large] = node.content if node['size'] == 'large'
        data[:image_extralarge] = node.content if node['size'] == 'extralarge'
      end
    end
  end
  
  # Defines some functions that are used nearly all Scrobbler classes which
  # have to deal with image references.
  #
  # This module defines the object functions, use "include ImageObjectFuncs" in
  # class.
  module ImageObjectFuncs
    # Check if the given libxml node is an image referencing node and in case
    # of, read it into the object
    def check_image_node(node)
      if node.name == 'image'
        @image_small = node.content if node['size'] == 'small'
        @image_medium = node.content if node['size'] == 'medium'
        @image_large = node.content if node['size'] == 'large'
        @image_extralarge = node.content if node['size'] == 'extralarge'
      end
    end
    
    # Return the URL to the specified image size.
    #
    # If the URL to the given image size is not known and a 
    # 'load_info'-function is defined, it will be called.
    def image(which=:small)
      which = which.to_s
      raise ArgumentError unless ['small', 'medium', 'large', 'extralarge'].include?(which)      
      img_url = instance_variable_get("@image_#{which}")
      if img_url.nil? && responds_to?(:load_info) 
        load_info 
        img_url = instance_variable_get("@image_#{which}")
      end
      img_url
    end
  end
end