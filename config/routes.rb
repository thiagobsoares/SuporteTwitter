Rails.application.routes.draw do
  match 'tweets' => 'tweets#index', via: 'get'
end
