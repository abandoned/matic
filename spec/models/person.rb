class Person < Mongomatic::Base
  include Matic

  fields :first_name,
         :last_name

  private

  def before_update
    @called_back = true
  end

  def before_insert
    @called_back = true
  end
end
