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

describe PermissionsController do

  # This should return the minimal set of attributes required to create a valid
  # Permission. As you add validations to Permission, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  describe "GET index" do
    it "assigns all permissions as @permissions" do
      permission = Permission.create! valid_attributes
      get :index
      assigns(:permissions).should eq([permission])
    end
  end

  describe "GET show" do
    it "assigns the requested permission as @permission" do
      permission = Permission.create! valid_attributes
      get :show, :id => permission.id.to_s
      assigns(:permission).should eq(permission)
    end
  end

  describe "GET new" do
    it "assigns a new permission as @permission" do
      get :new
      assigns(:permission).should be_a_new(Permission)
    end
  end

  describe "GET edit" do
    it "assigns the requested permission as @permission" do
      permission = Permission.create! valid_attributes
      get :edit, :id => permission.id.to_s
      assigns(:permission).should eq(permission)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Permission" do
        expect {
          post :create, :permission => valid_attributes
        }.to change(Permission, :count).by(1)
      end

      it "assigns a newly created permission as @permission" do
        post :create, :permission => valid_attributes
        assigns(:permission).should be_a(Permission)
        assigns(:permission).should be_persisted
      end

      it "redirects to the created permission" do
        post :create, :permission => valid_attributes
        response.should redirect_to(Permission.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved permission as @permission" do
        # Trigger the behavior that occurs when invalid params are submitted
        Permission.any_instance.stub(:save).and_return(false)
        post :create, :permission => {}
        assigns(:permission).should be_a_new(Permission)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Permission.any_instance.stub(:save).and_return(false)
        post :create, :permission => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested permission" do
        permission = Permission.create! valid_attributes
        # Assuming there are no other permissions in the database, this
        # specifies that the Permission created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Permission.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => permission.id, :permission => {'these' => 'params'}
      end

      it "assigns the requested permission as @permission" do
        permission = Permission.create! valid_attributes
        put :update, :id => permission.id, :permission => valid_attributes
        assigns(:permission).should eq(permission)
      end

      it "redirects to the permission" do
        permission = Permission.create! valid_attributes
        put :update, :id => permission.id, :permission => valid_attributes
        response.should redirect_to(permission)
      end
    end

    describe "with invalid params" do
      it "assigns the permission as @permission" do
        permission = Permission.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Permission.any_instance.stub(:save).and_return(false)
        put :update, :id => permission.id.to_s, :permission => {}
        assigns(:permission).should eq(permission)
      end

      it "re-renders the 'edit' template" do
        permission = Permission.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Permission.any_instance.stub(:save).and_return(false)
        put :update, :id => permission.id.to_s, :permission => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested permission" do
      permission = Permission.create! valid_attributes
      expect {
        delete :destroy, :id => permission.id.to_s
      }.to change(Permission, :count).by(-1)
    end

    it "redirects to the permissions list" do
      permission = Permission.create! valid_attributes
      delete :destroy, :id => permission.id.to_s
      response.should redirect_to(permissions_url)
    end
  end

end
