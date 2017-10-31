require "test_helper"

describe SessionsController do

  let(:user) {users(:dan)}

  # describe "login_form" do
  #   # The login form is a static page - no real way to make it fail
  #   it "succeeds" do
  #     get login_path
  #     must_respond_with :success
  #   end
  # end

  describe "login oauth through github" do
    # This functionality is complex!
    # There are definitely interesting cases I haven't covered
    # here, but these are the cases I could think of that are
    # likely to occur. More test cases will be added as bugs
    # are uncovered.
    #
    # Note also: some more behavior is covered in the upvote tests
    # under the works controller, since that's the only place
    # where there's an interesting difference between a logged-in
    # and not-logged-in user.

    describe "#create" do
      it "should update the session with user ID" do
        login_github(user)

        session[:user_id].must_equal user.id
        flash.keys.must_include "success"
        must_redirect_to root_path
      end

      it "should create a new user upon first login" do
        proc {
          login_github
        }.must_change "User.count", 1
      end

      it "should not create a new user on repeat logins" do
        proc {
          3.times do
            login_github(user)
          end
        }.wont_change "User.count"
      end
    end

    # describe "#login" do
    #   it "responds with bad request if given invalid user data" do
    #
    #     start_count = User.count
    #     user1 = User.new(uid: 99998, provider: 'not-github')
    #
    #     login_github(user1)
    #     must_respond_with :bad_request
    #     User.count.must_equal start_count
    #
    #   end
    # end
    
    #DAN'S TESTS:
    # it "succeeds for a new user" do
    #   username = "test_user"
    #   # Precondition: no user with this username exists
    #   User.find_by(username: username).must_be_nil
    #
    #   post login_path, params: { username: username }
    #   must_redirect_to root_path
    # end

    # it "succeeds for a returning user" do
    #   username = User.first.username
    #   post login_path, params: { username: username }
    #   must_redirect_to root_path
    # end
    #
    # it "renders 400 bad_request if the username is blank" do
    #   post login_path, params: { username: "" }
    #   must_respond_with :bad_request
    # end
    #
    # it "succeeds if a different user is already logged in" do
    #   username = "user_1"
    #   post login_path, params: { username: username }
    #   must_redirect_to root_path
    #
    #   username = "user_2"
    #   post login_path, params: { username: username }
    #   must_redirect_to root_path
    # end
  end

  describe "#logout" do

    it "logged-in user can log out" do

      login_github(user)
      post logout_path
      session[:user_id].must_be_nil
      must_redirect_to root_path
    end


    #DAN'S TEST:
    # it "succeeds if the user is logged in" do
    #   # Gotta be logged in first
    #   post login_path, params: { username: "test user" }
    #   must_redirect_to root_path
    #
    #   post logout_path
    #   must_redirect_to root_path
    # end

    it "succeeds if the user is not logged in" do
      post logout_path
      must_redirect_to root_path
    end
  end
end
