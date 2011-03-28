module FIDIUS
  # This module provides active-record wrappers for an existing preludemanager database.
  module PreludeDB
    # Base class for all other PreludeManager Models.
    # It is handy for establishing connection for all models 
    class Connection < ActiveRecord::Base

    end
  end
end
