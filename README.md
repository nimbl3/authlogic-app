# README

Simple Rails authentication app built with Authlogic

## Setup and run the app

- `bundle install`
- `bundle exec rake db:setup`
- `rails s -b 0.0.0.0`

## About Authlogic
Authlogic provides the authentication solution to Rails apps. 

To setup

1. Create the user model. Some extra columns needed to be add to the migration.
```ruby
class CreateUser < ActiveRecord::Migration
  def change
    create_table :users do |t|
      # Authlogic::ActsAsAuthentic::Email
      t.string    :email

      # Authlogic::ActsAsAuthentic::Password
      t.string    :crypted_password
      t.string    :password_salt

      # Authlogic::ActsAsAuthentic::PersistenceToken
      t.string    :persistence_token
      t.index     :persistence_token, unique: true

      # Authlogic::ActsAsAuthentic::SingleAccessToken
      t.string    :single_access_token
      t.index     :single_access_token, unique: true

      # Authlogic::ActsAsAuthentic::PerishableToken
      t.string    :perishable_token
      t.index     :perishable_token, unique: true

      # Authlogic::Session::MagicColumns
      t.integer   :login_count, default: 0, null: false
      t.integer   :failed_login_count, default: 0, null: false
      t.datetime  :last_request_at
      t.datetime  :current_login_at
      t.datetime  :last_login_at
      t.string    :current_login_ip
      t.string    :last_login_ip

      # Authlogic::Session::MagicStates
      t.boolean   :active, default: false
      t.boolean   :approved, default: false
      t.boolean   :confirmed, default: false

      t.timestamps
    end
  end
end
```

Please note that if some features are not needed. We shouldn't include it to the migration because Authlogic is going to enable that feature automatically.

2. Create `UserSession` model
```ruby
class UserSession < Authlogic::Session::Base
end
```

3. Include `acts_as_authentic` to the user model
```ruby
class User < ApplicationRecord
  acts_as_authentic
end
```

4. Add the helper method to the controller
```ruby
  helper_method :current_user_session, :current_user

  private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end
```

5. Overrides the `handle_unverified_request` to protect the Cross Site Request Forgery

```ruby
protected

def handle_unverified_request
  # raise an exception
  # fail ActionController::InvalidAuthenticityToken
  # or destroy session, redirect
  if current_user_session
    current_user_session.destroy
  end
  redirect_to root_url
end
```

This is because Authlogic introduces its own methods for storing user sessions,
the CSRF (Cross Site Request Forgery) protection that is built into Rails will not work out of the box.

6. Add the `UserSessionsController`
```ruby
class UserSessionsController < ApplicationController
  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(user_session_params.to_h)

    if @user_session.save
      redirect_to root_path
    else
      render :new
    end
  end

  def destroy
    current_user_session.destroy
    redirect_to login_path
  end

  private

  def user_session_params
    params.require(:user_session).permit(:email, :password)
  end
end
```

Please note that we need to use `.to_h` for strong parameters
Because Authlogic deprecated the use of ActionController::Parameters and move to the plain hash.
- https://github.com/binarylogic/authlogic/issues/512
- https://github.com/binarylogic/authlogic/pull/558
- https://github.com/binarylogic/authlogic/pull/577
