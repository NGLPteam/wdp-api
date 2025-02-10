class CreateTemplatesDerivedInstanceDigests < ActiveRecord::Migration[7.0]
  def change
    create_view :templates_derived_instance_digests
  end
end
