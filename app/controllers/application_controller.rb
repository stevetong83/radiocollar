class ApplicationController < ActionController::Base
  protect_from_forgery
before_filter :set_access_control_headers

def set_access_control_headers
  response.headers["Access-Control-Allow-Methods"] = "GET, PUT, POST, DELETE"
  response.headers["Access-Control-Allow-Headers"] = "Content-Type, X-Requested-With"
end

end