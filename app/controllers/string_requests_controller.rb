class StringRequestsController < ApplicationController
  before_action :set_string_request, only: [:show]
  before_action :set_string_requests, only: [:index]

  def index
    @string_requests = @string_requests.paginate(page: params[:page], per_page: 100)
  end

  def show
  end

  private
    def set_string_request
      @string_request = StringRequest.find(params[:id])
    end

    def set_string_requests
      @string_requests = StringRequest.all.reverse_chronological
      @num_records = @string_requests.count
    end
end
