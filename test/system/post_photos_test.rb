require "application_system_test_case"

class PostPhotosTest < ApplicationSystemTestCase
  setup do
    @post_photo = post_photos(:one)
  end

  test "visiting the index" do
    visit post_photos_url
    assert_selector "h1", text: "Post Photos"
  end

  test "creating a Post photo" do
    visit post_photos_url
    click_on "New Post Photo"

    fill_in "Content", with: @post_photo.content
    fill_in "Title", with: @post_photo.title
    click_on "Create Post photo"

    assert_text "Post photo was successfully created"
    click_on "Back"
  end

  test "updating a Post photo" do
    visit post_photos_url
    click_on "Edit", match: :first

    fill_in "Content", with: @post_photo.content
    fill_in "Title", with: @post_photo.title
    click_on "Update Post photo"

    assert_text "Post photo was successfully updated"
    click_on "Back"
  end

  test "destroying a Post photo" do
    visit post_photos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Post photo was successfully destroyed"
  end
end
