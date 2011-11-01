class FamiliesController < ApplicationController
  def index
    @families = Family.all
  end

  def show
    @family = Family.find(params[:id])
  end

  def new
    if user_signed_in?
      unless current_user.has_role?('Librarian')
        access_denied; return
      end
    end
    user_list(params)
    @family = Family.new
  end

  def create
    @family = Family.new(params[:family])
    respond_to do |format|
      if @family.save
        @family.add_user(params[:family_users])                      
        flash[:notice] = t('controller.successfully_created', :model => t('activerecord.models.family'))
        format.html { redirect_to(@family) }
        format.xml  { render :xml => @family, :status => :created, :location => @family }
      else
        user_list
        format.html { render :action => "new" }
        format.xml  { render :xml => @family.errors, :status => :unprocessable_entity }
      end
    end    
  end

  def edit
    user_list(params)
    @family = Family.find(params[:id])
    @already_family_users = @family.users
  end

  def update
    @family = Family.find(params[:id])
    family_users = @family.family_users
    family_users.each do |user|
      user.destroy
    end
    @family.add_user(params[:family_users])
    respond_to do |format|
      flash[:notice] = t('controller.successfully_created', :model => t('activerecord.models.family'))
      format.html { redirect_to(@family) }
      format.xml  { render :xml => @family, :status => :created, :location => @family }
    end
  end

  def search_user
    logger.error "EMIKO SEARCH USER"
    user_list(params)
    html = render_to_string :partial => "user_list"
    render :json => {:success => 1, :html => html}
  end

private
  def user_list(params)
    query = params[:query].to_s
    @query = query.dup
    @count = {}

    sort = {:sort_by => 'created_at', :order => 'desc'}
    case params[:sort_by]
    when 'username'
      sort[:sort_by] = 'username'
    when 'telephone_number_1'
      sort[:sort_by] = 'patrons.telephone_number_1'
    when 'full_name'
      sort[:sort_by] = 'patrons.full_name_transcription'
    end
    case params[:order]
    when 'asc'
      sort[:order] = 'asc'
    when 'desc'
      sort[:order] = 'desc'
    end

    query = params[:query]
    page = params[:page] || 1
    role = current_user.try(:role) || Role.default_role
    @date_of_birth = params[:birth_date].to_s.dup
    birth_date = params[:birth_date].to_s.gsub!(/\D/, '') if params[:birth_date]
    flash[:message] = nil
    unless params[:birth_date].blank?
      begin
        date_of_birth = Time.zone.parse(birth_date).beginning_of_day.utc.iso8601
      rescue
        flash[:message] = t('user.birth_date_invalid')
      end
    end
    date_of_birth_end = Time.zone.parse(birth_date).end_of_day.utc.iso8601 rescue nil
    address = params[:address]
    @address = address

    query = "#{query} date_of_birth_d: [#{date_of_birth} TO #{date_of_birth_end}]" unless date_of_birth.blank?
    query = "#{query} address_text: #{address}" unless address.blank?

    logger.error "query: #{query}"
    unless query.blank?
      @users = User.search do
        fulltext query
        order_by sort[:sort_by], sort[:order]
        with(:required_role_id).less_than role.id
      end.results
    else
      if sort[:sort_by] == 'patrons.telephone_number_1'|| sort[:sort_by] == 'patrons.full_name_transcription'
        @users = User.joins(:patron).order("#{sort[:sort_by]} #{sort[:order]}").page(page)
      else
        @users = User.order("#{sort[:sort_by]} #{sort[:order]}").page(page)
      end
      logger.error @users
    end
    @count[:query_result] = @users.total_entries
  end

end
