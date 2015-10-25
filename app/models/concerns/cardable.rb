module Cardable
  extend ActiveSupport::Concern

  included do
    include InstanceMethods
  end

  module InstanceMethods
    def remove_card(card)
      cards.delete card
    end
  end
end
