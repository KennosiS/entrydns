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

describe MxesController do

  # This should return the minimal set of attributes required to create a valid
  # Mx. As you add validations to Mx, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  describe "GET index" do
    it "assigns all mxes as @mxes" do
      mx = Mx.create! valid_attributes
      get :index
      assigns(:mxes).should eq([mx])
    end
  end

  describe "GET show" do
    it "assigns the requested mx as @mx" do
      mx = Mx.create! valid_attributes
      get :show, :id => mx.id.to_s
      assigns(:mx).should eq(mx)
    end
  end

  describe "GET new" do
    it "assigns a new mx as @mx" do
      get :new
      assigns(:mx).should be_a_new(Mx)
    end
  end

  describe "GET edit" do
    it "assigns the requested mx as @mx" do
      mx = Mx.create! valid_attributes
      get :edit, :id => mx.id.to_s
      assigns(:mx).should eq(mx)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Mx" do
        expect {
          post :create, :mx => valid_attributes
        }.to change(Mx, :count).by(1)
      end

      it "assigns a newly created mx as @mx" do
        post :create, :mx => valid_attributes
        assigns(:mx).should be_a(Mx)
        assigns(:mx).should be_persisted
      end

      it "redirects to the created mx" do
        post :create, :mx => valid_attributes
        response.should redirect_to(Mx.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved mx as @mx" do
        # Trigger the behavior that occurs when invalid params are submitted
        Mx.any_instance.stub(:save).and_return(false)
        post :create, :mx => {}
        assigns(:mx).should be_a_new(Mx)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Mx.any_instance.stub(:save).and_return(false)
        post :create, :mx => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested mx" do
        mx = Mx.create! valid_attributes
        # Assuming there are no other mxes in the database, this
        # specifies that the Mx created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Mx.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => mx.id, :mx => {'these' => 'params'}
      end

      it "assigns the requested mx as @mx" do
        mx = Mx.create! valid_attributes
        put :update, :id => mx.id, :mx => valid_attributes
        assigns(:mx).should eq(mx)
      end

      it "redirects to the mx" do
        mx = Mx.create! valid_attributes
        put :update, :id => mx.id, :mx => valid_attributes
        response.should redirect_to(mx)
      end
    end

    describe "with invalid params" do
      it "assigns the mx as @mx" do
        mx = Mx.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Mx.any_instance.stub(:save).and_return(false)
        put :update, :id => mx.id.to_s, :mx => {}
        assigns(:mx).should eq(mx)
      end

      it "re-renders the 'edit' template" do
        mx = Mx.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Mx.any_instance.stub(:save).and_return(false)
        put :update, :id => mx.id.to_s, :mx => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested mx" do
      mx = Mx.create! valid_attributes
      expect {
        delete :destroy, :id => mx.id.to_s
      }.to change(Mx, :count).by(-1)
    end

    it "redirects to the mxes list" do
      mx = Mx.create! valid_attributes
      delete :destroy, :id => mx.id.to_s
      response.should redirect_to(mxes_url)
    end
  end

end