class HomeController < ApplicationController
  def index
    @works = Work.order(created_at: :desc).limit(10)
  end
end

