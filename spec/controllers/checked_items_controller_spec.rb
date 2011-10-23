require 'spec_helper'

describe CheckedItemsController do
  fixtures :all

  describe "GET index" do
    describe "When logged in as Administrator" do
      login_admin

      it "assigns all checked_items as @checked_items" do
        get :index
        assigns(:checked_items).should_not be_empty
        response.should be_forbidden
      end

      it "should not get index without basket_id" do
        get :index, :item_id => 1
        assigns(:checked_items).should_not be_empty
        response.should be_forbidden
      end
    end

    describe "When logged in as Librarian" do
      login_librarian

      it "should be forbidden" do
        get :index
        assigns(:checked_items).should_not be_empty
        response.should be_forbidden
      end

      describe "When basket is specified" do
        it "assigns checked_items as @checked_items" do
          get :index, :basket_id => 1
          assigns(:checked_items).should_not be_empty
          response.should be_success
        end
      end
    end

    describe "When logged in as User" do
      login_user

      it "assigns empty as @checked_items" do
        get :index
        assigns(:checked_items).should be_empty
        response.should be_forbidden
      end
    end

    describe "When not logged in" do
      it "assigns empty as @checked_items" do
        get :index
        assigns(:checked_items).should be_empty
        response.should redirect_to(new_user_session_url)
      end

      it "should not get index with basket_id and item_id" do
        get :index, :basket_id => 1, :item_id => 1
        assigns(:checked_items).should be_empty
        response.should redirect_to(new_user_session_url)
      end
    end
  end

  describe "GET show" do
    describe "When logged in as Administrator" do
      login_admin

      it "assigns the requested checked_item as @checked_item" do
        get :show, :id => 1
        assigns(:checked_item).should eq(checked_items(:checked_item_00001))
      end
    end

    describe "When logged in as Librarian" do
      login_librarian

      it "assigns the requested checked_item as @checked_item" do
        get :show, :id => 1
        assigns(:checked_item).should eq(checked_items(:checked_item_00001))
      end
    end

    describe "When logged in as User" do
      login_user

      it "assigns the requested checked_item as @checked_item" do
        get :show, :id => 1
        assigns(:checked_item).should eq(checked_items(:checked_item_00001))
        response.should be_forbidden
      end
    end

    describe "When not logged in" do
      it "assigns the requested checked_item as @checked_item" do
        get :show, :id => 1
        assigns(:checked_item).should eq(checked_items(:checked_item_00001))
        response.should redirect_to(new_user_session_url)
      end
    end
  end

  describe "GET new" do
    describe "When logged in as Administrator" do
      login_admin

      it "assigns the requested checked_item as @checked_item" do
        get :new, :basket_id => 3
        assigns(:checked_item).should_not be_valid
        response.should be_success
      end

      describe "When basket is not specified" do
        it "should be forbidden" do
          get :new
          response.should be_forbidden
        end
      end
    end

    describe "When logged in as Librarian" do
      login_librarian

      it "assigns the requested checked_item as @checked_item" do
        get :new, :basket_id => 3
        assigns(:checked_item).should_not be_valid
        response.should be_success
      end
    end

    describe "When logged in as User" do
      login_user

      it "should not assign the requested checked_item as @checked_item" do
        get :new, :basket_id => 3
        assigns(:checked_item).should_not be_valid
        response.should be_forbidden
      end
    end

    describe "When not logged in" do
      it "should not assign the requested checked_item as @checked_item" do
        get :new, :basket_id => 3
        assigns(:checked_item).should_not be_valid
        response.should redirect_to(new_user_session_url)
      end
    end
  end

  describe "GET edit" do
    describe "When logged in as Administrator" do
      login_admin

      it "assigns the requested checked_item as @checked_item" do
        checked_item = checked_items(:checked_item_00001)
        get :edit, :id => checked_item.id
        assigns(:checked_item).should eq(checked_item)
      end
    end

    describe "When logged in as Librarian" do
      login_librarian

      it "assigns the requested checked_item as @checked_item" do
        checked_item = checked_items(:checked_item_00001)
        get :edit, :id => checked_item.id
        assigns(:checked_item).should eq(checked_item)
      end
    end

    describe "When logged in as User" do
      login_user

      it "assigns the requested checked_item as @checked_item" do
        checked_item = checked_items(:checked_item_00001)
        get :edit, :id => checked_item.id
        response.should be_forbidden
      end
    end

    describe "When not logged in" do
      it "should not assign the requested checked_item as @checked_item" do
        checked_item = checked_items(:checked_item_00001)
        get :edit, :id => checked_item.id
        response.should redirect_to(new_user_session_url)
      end
    end
  end

  describe "POST create" do
    before(:each) do
      @attrs = {:item_identifier => '00011'}
      @invalid_attrs = {:item_identifier => 'invalid'}
    end

    describe "When logged in as Administrator" do
      login_admin

      describe "When the item is missing" do
        it "assigns a newly created checked_item as @checked_item" do
          post :create, :checked_item => {:item_identifier => 'not found'} , :basket_id => 1
          assigns(:checked_item).should_not be_valid
          assigns(:checked_item).errors[:base].include?(I18n.t('checked_item.item_not_found')).should be_true
        end
      end

      describe "When the item is not for checkout" do
        it "assigns a newly created checked_item as @checked_item" do
          post :create, :checked_item => {:item_identifier => '00017'} , :basket_id => 1
          assigns(:checked_item).should_not be_valid
          assigns(:checked_item).errors[:base].include?(I18n.t('checked_item.not_available_for_checkout')).should be_true
        end
      end

      describe "When the item is already checked out" do
        it "assigns a newly created checked_item as @checked_item" do
          post :create, :checked_item => {:item_identifier => '00013'} , :basket_id => 8
          assigns(:checked_item).should_not be_valid
          assigns(:checked_item).errors[:base].include?(I18n.t('checked_item.already_checked_out')).should be_true
        end
      end

      describe "When the item is in transaction" do
        it "assigns a newly created checked_item as @checked_item" do
          post :create, :checked_item => {:item_identifier => '00006'} , :basket_id => 9
          assigns(:checked_item).should_not be_valid
          assigns(:checked_item).errors[:base].include?(I18n.t('activerecord.errors.messages.checked_item.in_transcation')).should be_true
        end
      end

      describe "When the item is reserved" do
        it "assigns a newly created checked_item as @checked_item" do
          post :create, :checked_item => {:item_identifier => '00021'} , :basket_id => 11
          assigns(:checked_item).should be_valid
          assigns(:checked_item).item.manifestation.reserves.waiting.should be_empty
        end
      end
    end

    describe "When logged in as Librarian" do
      login_librarian

      it "should create checked_item" do
        post :create, :checked_item => @attrs, :basket_id => 3
        assigns(:checked_item).due_date.should_not be_nil
        response.should redirect_to user_basket_checked_items_url(assigns(:checked_item).basket.user, assigns(:checked_item).basket)
      end
    end
  end
end
