class Person < Mongomatic::Base
  include Matic

  field :first_name
  field :last_name

  private

  def before_update
    @called_back = true
  end

  def before_insert
    @called_back = true
  end
end
