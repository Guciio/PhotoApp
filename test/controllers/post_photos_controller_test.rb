require 'test_helper'

class PostPhotosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @post_photo = post_photos(:one)
  end

  test "should get index" do
    get post_photos_url
    assert_response :success
  end

  test "should get new" do
    get new_post_photo_url
    assert_response :success
  end

  test "should create post_photo" do
    assert_difference('PostPhoto.count') do
      post post_photos_url, params: { post_photo: { content: @post_photo.content, title: @post_photo.title } }
    end

    assert_redirected_to post_photo_url(PostPhoto.last)
  end

  test "should show post_photo" do
    get post_photo_url(@post_photo)
    assert_response :success
  end

  test "should get edit" do
    get edit_post_photo_url(@post_photo)
    assert_response :success
  end

  test "should update post_photo" do
    patch post_photo_url(@post_photo), params: { post_photo: { content: @post_photo.content, title: @post_photo.title } }
    assert_redirected_to post_photo_url(@post_photo)
  end

  test "should destroy post_photo" do
    assert_difference('PostPhoto.count', -1) do
      delete post_photo_url(@post_photo)
    end

    assert_redirected_to post_photos_url
  end
end
