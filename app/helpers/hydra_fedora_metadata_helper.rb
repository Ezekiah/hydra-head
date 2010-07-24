require "inline_editable_metadata_helper"
module HydraFedoraMetadataHelper
  
  def fedora_text_field(resource, datastream_name, field_key, opts={})
    # field_params = field_update_params(resource, datastream_name, field_key, opts)
    field_name = field_name_for(field_key)
    
    field_values = get_values_from_datastream(resource, datastream_name, field_key, opts)
    if opts.fetch(:multiple, true)
      result = "<ol>"
        field_values.each_with_index do |current_value,z|
          base_id = generate_base_id(field_name, current_value, field_values, opts)
          name = "asset[#{datastream_name}][#{base_id}]"
          result << "<li id=\"#{base_id}-container\" class=\"editable\">"
            result << "<span class=\"editableText\" id=\"#{base_id}-text\">#{h(current_value)}</span>"
            result << "<input class=\"editableTarget\" id=\"#{base_id}\" name=\"#{name}\" value=\"#{h(current_value)}\"/>"
          result << "</li>"
        end
      result << "</ol>"
    else
      result = ""
      current_value = field_values.first
      base_id = field_name
      name = "asset[#{datastream_name}][#{base_id}]"
      result << "<span id=\"#{base_id}-container\" class=\"editable\">"
        result << "<span class=\"editableText\" id=\"#{base_id}-text\">#{h(current_value)}</span>"
        result << "<input class=\"editableTarget\" id=\"#{base_id}\" name=\"#{name}\" value=\"#{h(current_value)}\"/>"
      result << "</span>"
    end
    
    return result
  end
  
  def generate_base_id(field_name, current_value, values, opts)
    return field_name+"_"+values.index(current_value).to_s
  end
  
  def fedora_text_area(resource, datastream_name, field_key, opts={})
  end
  
  def fedora_select(resource, datastream_name, field_key, opts={})
  end
  
  def fedora_checkbox(resource, datastream_name, field_key, opts={})
  end
  
  def fedora_text_field_insert_link(resource, datastream_name, field_key, opts={})
  end
  
  def fedora_field_label()
  end
  
  def metadata_field_info(resource, datastream_name, field_key, opts={})
  end
  
  def field_selectors_for(datastream_name, field_key)
  end
  
  # hydra_form_for block helper 
  # allows you to construct an entire hydra form by passing a block into this method
  class HydraFormFor < BlockHelpers::Base

    def initialize(resource, opts={})
      @resource = resource
    end
    
    def fedora_label(datastream_name, field_key, opts={})
      helper.fedora_label(@resource, datastream_name, field_key, opts)
    end
    
    def fedora_text_field(datastream_name, field_key, opts={})
      helper.fedora_label(@resource, datastream_name, field_key, opts)
    end

    def fedora_text_area(datastream_name, field_key, opts={})
      helper.fedora_text_area(@resource, datastream_name, field_key, opts)
    end
    
    def fedora_select(datastream_name, field_key, opts={})
      helper.fedora_select(@resource, datastream_name, field_key, opts)
    end
    
    def fedora_checkbox(datastream_name, field_key, opts={})
      helper.fedora_checkbox(@resource, datastream_name, field_key, opts)
    end
    
    def fedora_text_field_insert_link(datastream_name, field_key, opts={})
      helper.fedora_text_field_insert_link(@resource, datastream_name, field_key, opts={})
    end
    
    def fedora_field_label(datastream_name, field_key, opts={})
      helper.fedora_field_label(@resource, datastream_name, field_key, opts)
    end

    def display(body)
      inner_html = content_tag :input, :type=>"hidden", :name=>"content_type", :value=>@resource.class.to_s.underscore
      inner_html = inner_html << body
      content_tag :form, inner_html
    end

  end
  
  # retrieve field values from datastream.
  # If :values is provided, skips accessing the datastream and returns the contents of :values instead.
  def get_values_from_datastream(resource, datastream_name, field_key, opts={})
    if opts.has_key?(:values)
      values = opts[:values]
      if values.nil? then values = [opts.fetch(:default, "")] end
      return values
    else
      return resource.get_values_from_datastream(datastream_name, field_key, opts.fetch(:default, ""))
    end
  end
  
  def field_name_for(field_key)
    if field_key.kind_of?(Array)
      return ActiveFedora::NokogiriDatastream.accessor_hierarchical_name(*field_key)
    else
      field_key.to_s
    end
  end
  
end