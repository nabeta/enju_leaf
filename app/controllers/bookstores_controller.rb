class BookstoresController < InheritedResources::Base
  respond_to :html, :xml
  before_filter :check_client_ip_address
  load_and_authorize_resource

  def update
    @bookstore = Bookstore.find(params[:id])
    if params[:move]
      move_position(@bookstore, params[:move])
      return
    end
    update!
  end

  def index
    @bookstores = Bookstore.page(params[:page])
  end
end
