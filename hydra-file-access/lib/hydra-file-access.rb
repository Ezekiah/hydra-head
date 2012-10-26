module Hydra
  module FileAccess
    require 'hydra/file_access/engine' if defined?(Rails) && Rails::VERSION::MAJOR == 3
  end
  autoload :Assets
  autoload :AssetsControllerHelper
  autoload :SubmissionWorkflow
  autoload :UI

  module Controller
    extend ActiveSupport::Autoload
    autoload :FileAssetsBehavior
    autoload :DatastreamsBehavior
    autoload :AssetsControllerBehavior
  end
end
