require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe ManifestationTypesController do

  # This should return the minimal set of attributes required to create a valid
  # ManifestationType. As you add validations to ManifestationType, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ManifestationTypesController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all manifestation_types as @manifestation_types" do
      manifestation_type = ManifestationType.create! valid_attributes
      get :index, {}, valid_session
      assigns(:manifestation_types).should eq([manifestation_type])
    end
  end

  describe "GET show" do
    it "assigns the requested manifestation_type as @manifestation_type" do
      manifestation_type = ManifestationType.create! valid_attributes
      get :show, {:id => manifestation_type.to_param}, valid_session
      assigns(:manifestation_type).should eq(manifestation_type)
    end
  end

  describe "GET new" do
    it "assigns a new manifestation_type as @manifestation_type" do
      get :new, {}, valid_session
      assigns(:manifestation_type).should be_a_new(ManifestationType)
    end
  end

  describe "GET edit" do
    it "assigns the requested manifestation_type as @manifestation_type" do
      manifestation_type = ManifestationType.create! valid_attributes
      get :edit, {:id => manifestation_type.to_param}, valid_session
      assigns(:manifestation_type).should eq(manifestation_type)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new ManifestationType" do
        expect {
          post :create, {:manifestation_type => valid_attributes}, valid_session
        }.to change(ManifestationType, :count).by(1)
      end

      it "assigns a newly created manifestation_type as @manifestation_type" do
        post :create, {:manifestation_type => valid_attributes}, valid_session
        assigns(:manifestation_type).should be_a(ManifestationType)
        assigns(:manifestation_type).should be_persisted
      end

      it "redirects to the created manifestation_type" do
        post :create, {:manifestation_type => valid_attributes}, valid_session
        response.should redirect_to(ManifestationType.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved manifestation_type as @manifestation_type" do
        # Trigger the behavior that occurs when invalid params are submitted
        ManifestationType.any_instance.stub(:save).and_return(false)
        post :create, {:manifestation_type => {}}, valid_session
        assigns(:manifestation_type).should be_a_new(ManifestationType)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        ManifestationType.any_instance.stub(:save).and_return(false)
        post :create, {:manifestation_type => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested manifestation_type" do
        manifestation_type = ManifestationType.create! valid_attributes
        # Assuming there are no other manifestation_types in the database, this
        # specifies that the ManifestationType created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        ManifestationType.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => manifestation_type.to_param, :manifestation_type => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested manifestation_type as @manifestation_type" do
        manifestation_type = ManifestationType.create! valid_attributes
        put :update, {:id => manifestation_type.to_param, :manifestation_type => valid_attributes}, valid_session
        assigns(:manifestation_type).should eq(manifestation_type)
      end

      it "redirects to the manifestation_type" do
        manifestation_type = ManifestationType.create! valid_attributes
        put :update, {:id => manifestation_type.to_param, :manifestation_type => valid_attributes}, valid_session
        response.should redirect_to(manifestation_type)
      end
    end

    describe "with invalid params" do
      it "assigns the manifestation_type as @manifestation_type" do
        manifestation_type = ManifestationType.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        ManifestationType.any_instance.stub(:save).and_return(false)
        put :update, {:id => manifestation_type.to_param, :manifestation_type => {}}, valid_session
        assigns(:manifestation_type).should eq(manifestation_type)
      end

      it "re-renders the 'edit' template" do
        manifestation_type = ManifestationType.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        ManifestationType.any_instance.stub(:save).and_return(false)
        put :update, {:id => manifestation_type.to_param, :manifestation_type => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested manifestation_type" do
      manifestation_type = ManifestationType.create! valid_attributes
      expect {
        delete :destroy, {:id => manifestation_type.to_param}, valid_session
      }.to change(ManifestationType, :count).by(-1)
    end

    it "redirects to the manifestation_types list" do
      manifestation_type = ManifestationType.create! valid_attributes
      delete :destroy, {:id => manifestation_type.to_param}, valid_session
      response.should redirect_to(manifestation_types_url)
    end
  end

end