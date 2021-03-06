class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  # set user enum roles
  enum role: {admin: 0, client: 1}
  after_initialize :set_default_role, :if => :new_record?

  def set_default_role
    self.role ||= :client
  end

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :invoices

  # Before deleting user, delete user's invoices first
  before_destroy :delete_invoices

  validates :first_name, :last_name, :email,
    presence: true,
    length: {maximum: 255}, on: :create

  validates :email,
    uniqueness: true,
    format: {
      with: /(.+)@(.+)/,
      message: "not a valid email format"
    }, on: :create

    # Callback function for cascade delete
    def delete_invoices
      self.invoices.delete_all
    end

end
