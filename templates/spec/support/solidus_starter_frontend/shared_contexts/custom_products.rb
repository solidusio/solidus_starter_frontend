# frozen_string_literal: true

RSpec.shared_context "custom products" do
  before(:each) do
    create(:store)

    categories = FactoryBot.create(:taxonomy, name: 'Categories')
    categories_root = categories.root
    clothing_taxon = FactoryBot.create(:taxon, name: 'Clothing', parent_id: categories_root.id, taxonomy: categories)
    bags_taxon = FactoryBot.create(:taxon, name: 'Bags', parent_id: categories_root.id, taxonomy: categories)
    mugs_taxon = FactoryBot.create(:taxon, name: 'Mugs', parent_id: categories_root.id, taxonomy: categories)

    brands = FactoryBot.create(:taxonomy, name: 'Brands')
    brands_root = brands.root
    apache_taxon = FactoryBot.create(:taxon, name: 'Apache', parent_id: brands_root.id, taxonomy: brands)
    rails_taxon = FactoryBot.create(:taxon, name: 'Ruby on Rails', parent_id: brands_root.id, taxonomy: brands)
    ruby_taxon = FactoryBot.create(:taxon, name: 'Ruby', parent_id: brands_root.id, taxonomy: brands)

    FactoryBot.create(:custom_product, name: 'Ruby on Rails Ringer T-Shirt', price: '19.99', taxons: [rails_taxon, clothing_taxon])
    FactoryBot.create(:custom_product, name: 'Ruby on Rails Mug', price: '15.99', taxons: [rails_taxon, mugs_taxon])
    FactoryBot.create(:custom_product, name: 'Ruby on Rails Tote', price: '15.99', taxons: [rails_taxon, bags_taxon])
    FactoryBot.create(:custom_product, name: 'Ruby on Rails Bag', price: '22.99', taxons: [rails_taxon, bags_taxon])
    FactoryBot.create(:custom_product, name: 'Ruby on Rails Baseball Jersey', price: '19.99', taxons: [rails_taxon, clothing_taxon])
    FactoryBot.create(:custom_product, name: 'Ruby on Rails Stein', price: '16.99', taxons: [rails_taxon, mugs_taxon])
    FactoryBot.create(:custom_product, name: 'Ruby on Rails Jr. Spaghetti', price: '19.99', taxons: [rails_taxon, clothing_taxon])
    FactoryBot.create(:custom_product, name: 'Ruby Baseball Jersey', price: '19.99', taxons: [ruby_taxon, clothing_taxon])
    FactoryBot.create(:custom_product, name: 'Apache Baseball Jersey', price: '19.99', taxons: [apache_taxon, clothing_taxon])
  end
end
