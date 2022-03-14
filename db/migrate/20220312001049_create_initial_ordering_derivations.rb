class CreateInitialOrderingDerivations < ActiveRecord::Migration[6.1]
  def change
    create_view :initial_ordering_derivations
  end
end
