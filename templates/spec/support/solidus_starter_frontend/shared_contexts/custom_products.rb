# frozen_string_literal: true

RSpec.shared_context "custom products" do
  before(:each) do
    create(:store)

    categories = FactoryBot.create(:taxonomy, name: 'Categories')
    categories_root = categories.root
    clothing_taxon = FactoryBot.create(:taxon, name: 'Clothing', parent_id: categories_root.id, taxonomy: categories)
    accessories_taxon = FactoryBot.create(:taxon, name: 'Accessories', parent_id: categories_root.id, taxonomy: categories)
    stickers_taxon = FactoryBot.create(:taxon, name: 'Stickers', parent_id: categories_root.id, taxonomy: categories)
    image = FactoryBot.create(:image)
    variant = FactoryBot.create(:variant, images: [image, image])
  
    FactoryBot.create(:custom_product, name: 'Solidus hoodie', price: '29.99', taxons: [clothing_taxon], variants: [variant])
    FactoryBot.create(:custom_product, name: 'Solidus Water Bottle', price: '19.99', taxons: [accessories_taxon])
    FactoryBot.create(:custom_product, name: 'Solidus tote', price: '19.99', taxons: [clothing_taxon])
    FactoryBot.create(:custom_product, name: 'Solidus mug set', price: '19.99', taxons: [accessories_taxon])
    FactoryBot.create(:custom_product, name: 'Solidus winter hat', price: '22.99', taxons: [clothing_taxon])
    FactoryBot.create(:custom_product, name: 'Solidus circle sticker', price: '5.99', taxons: [stickers_taxon])
    FactoryBot.create(:custom_product, name: 'Solidus notebook', price: '26.99', taxons: [accessories_taxon])
    FactoryBot.create(:custom_product, name: 'Solidus t-shirt', price: '9.99', taxons: [clothing_taxon])
    FactoryBot.create(:custom_product, name: 'Solidus long sleeve tee', price: '15.99', taxons: [clothing_taxon])
    FactoryBot.create(:custom_product, name: 'Solidus dark tee', price: '15.99', taxons: [clothing_taxon])
    FactoryBot.create(:custom_product, name: 'Solidus canvas tote bag', price: '15.99', taxons: [accessories_taxon])
    FactoryBot.create(:custom_product, name: 'Solidus cap', price: '24.00', taxons: [clothing_taxon])
  end
end
