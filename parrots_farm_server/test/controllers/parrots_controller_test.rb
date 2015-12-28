require 'test_helper'

class ParrotsControllerTest < ActionController::TestCase
  setup do
    @parrot = parrots(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:parrots)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create parrot" do
    assert_difference('Parrot.count') do
      post :create, parrot: { age: @parrot.age, brood: @parrot.brood, color: @parrot.color, name: @parrot.name, sex: @parrot.sex }
    end

    assert_redirected_to parrot_path(assigns(:parrot))
  end

  test "should show parrot" do
    get :show, id: @parrot
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @parrot
    assert_response :success
  end

  test "should update parrot" do
    patch :update, id: @parrot, parrot: { age: @parrot.age, brood: @parrot.brood, color: @parrot.color, name: @parrot.name, sex: @parrot.sex }
    assert_redirected_to parrot_path(assigns(:parrot))
  end

  test "should destroy parrot" do
    assert_difference('Parrot.count', -1) do
      delete :destroy, id: @parrot
    end

    assert_redirected_to parrots_path
  end
end
