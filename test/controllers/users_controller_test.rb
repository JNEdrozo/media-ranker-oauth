require 'test_helper'

describe UsersController do
  let(:user) { users(:dan) }

  describe "when logged in" do

    describe "index" do
      it "succeeds with many users" do
        login_github(user)
        # Assumption: there are many users in the DB
        User.count.must_be :>, 0

        get users_path
        must_respond_with :success
      end

      it "succeeds with no users" do
        login_github(user)
        # Start with a clean slate
        Vote.destroy_all # for fk constraint
        User.destroy_all

        login_github(user)

        get users_path
        must_respond_with :success
      end
    end

    describe "show" do
      it "succeeds for an existing user" do
        login_github(user)
        get user_path(user.id)
        must_respond_with :success
      end

      it "renders 404 not_found for a bogus user" do
        login_github(user)
        # User.last gives the user with the highest ID
        bogus_user_id = User.last.id + 1
        get user_path(bogus_user_id)
        must_respond_with :not_found
      end
    end
  end

  describe "when not logged in" do
    it "index" do
      get users_path
      must_redirect_to root_path
    end

    it "show" do
      get user_path(User.last)
      must_redirect_to root_path
    end
  end
end
