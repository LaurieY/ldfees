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

describe FeefilesController do

  # This should return the minimal set of attributes required to create a valid
  # Feefile. As you add validations to Feefile, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  describe "GET index" do
    it "assigns all feefiles as @feefiles" do
      feefile = Feefile.create! valid_attributes
      get :index
      assigns(:feefiles).should eq([feefile])
    end
  end

  describe "GET show" do
    it "assigns the requested feefile as @feefile" do
      feefile = Feefile.create! valid_attributes
      get :show, :id => feefile.id.to_s
      assigns(:feefile).should eq(feefile)
    end
  end

  describe "GET new" do
    it "assigns a new feefile as @feefile" do
      get :new
      assigns(:feefile).should be_a_new(Feefile)
    end
  end

  describe "GET edit" do
    it "assigns the requested feefile as @feefile" do
      feefile = Feefile.create! valid_attributes
      get :edit, :id => feefile.id.to_s
      assigns(:feefile).should eq(feefile)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Feefile" do
        expect {
          post :create, :feefile => valid_attributes
        }.to change(Feefile, :count).by(1)
      end

      it "assigns a newly created feefile as @feefile" do
        post :create, :feefile => valid_attributes
        assigns(:feefile).should be_a(Feefile)
        assigns(:feefile).should be_persisted
      end

      it "redirects to the created feefile" do
        post :create, :feefile => valid_attributes
        response.should redirect_to(Feefile.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved feefile as @feefile" do
        # Trigger the behavior that occurs when invalid params are submitted
        Feefile.any_instance.stub(:save).and_return(false)
        post :create, :feefile => {}
        assigns(:feefile).should be_a_new(Feefile)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Feefile.any_instance.stub(:save).and_return(false)
        post :create, :feefile => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested feefile" do
        feefile = Feefile.create! valid_attributes
        # Assuming there are no other feefiles in the database, this
        # specifies that the Feefile created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Feefile.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => feefile.id, :feefile => {'these' => 'params'}
      end

      it "assigns the requested feefile as @feefile" do
        feefile = Feefile.create! valid_attributes
        put :update, :id => feefile.id, :feefile => valid_attributes
        assigns(:feefile).should eq(feefile)
      end

      it "redirects to the feefile" do
        feefile = Feefile.create! valid_attributes
        put :update, :id => feefile.id, :feefile => valid_attributes
        response.should redirect_to(feefile)
      end
    end

    describe "with invalid params" do
      it "assigns the feefile as @feefile" do
        feefile = Feefile.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Feefile.any_instance.stub(:save).and_return(false)
        put :update, :id => feefile.id.to_s, :feefile => {}
        assigns(:feefile).should eq(feefile)
      end

      it "re-renders the 'edit' template" do
        feefile = Feefile.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Feefile.any_instance.stub(:save).and_return(false)
        put :update, :id => feefile.id.to_s, :feefile => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested feefile" do
      feefile = Feefile.create! valid_attributes
      expect {
        delete :destroy, :id => feefile.id.to_s
      }.to change(Feefile, :count).by(-1)
    end

    it "redirects to the feefiles list" do
      feefile = Feefile.create! valid_attributes
      delete :destroy, :id => feefile.id.to_s
      response.should redirect_to(feefiles_url)
    end
  end

end