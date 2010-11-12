class Book < Mongomatic::Base
  include Matic

  fields :title     => 't',
         :authors   => 'a',
         :publisher => 'p',
         :isbn      => 'i'
end
