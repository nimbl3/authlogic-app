class CreateUser < ActiveRecord::Migration[5.2]
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

      # NOTE:
      # Do not add the Magic columns and Magic states if it is not used
      # The Authlogic will enabled those features automatically if the columns are defined

      # Authlogic::Session::MagicColumns
      # t.integer   :login_count, default: 0, null: false
      # t.integer   :failed_login_count, default: 0, null: false
      # t.datetime  :last_request_at
      # t.datetime  :current_login_at
      # t.datetime  :last_login_at
      # t.string    :current_login_ip
      # t.string    :last_login_ip

      # Authlogic::Session::MagicStates
      # t.boolean   :active, default: false
      # t.boolean   :approved, default: false
      # t.boolean   :confirmed, default: false

      t.timestamps
    end
  end
end
