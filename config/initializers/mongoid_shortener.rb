if Rails.env == "production"
  MongoidShortener.root_url = "http://radiocollarapp.herokuapp.com/"
  MongoidShortener.prefix_url = "http://radiocollarapp.herokuapp.com/~"
else
  MongoidShortener.root_url = "http://localhost:3000/"
  MongoidShortener.prefix_url = "http://localhost:3000/~"
end