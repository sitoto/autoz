# encoding: utf-8
require 'carrierwave'
require 'carrierwave/processing/mime_types'
class PhotoUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  # include Sprockets::Helpers::RailsHelper
  # include Sprockets::Helpers::IsolatedHelper

  # storage :file
   storage :grid_fs

  def store_dir
    "#{model.class.to_s.underscore}"
  end

  def default_url
    "/images/default.png"
  end

  # process :scale => [200, 300]

  # Create different versions of your uploaded files:
  version :thumb do
    process :resize_to_fill => [50,50]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def filename
    if super.present?
      # current_path 是 Carrierwave 上传过程临时创建的一个文件，有时间标记，所以它将是唯一的
      @name ||= Digest::MD5.hexdigest(File.dirname(current_path))
      "#{@name}.#{file.extension.downcase}"
    end
  end

end
