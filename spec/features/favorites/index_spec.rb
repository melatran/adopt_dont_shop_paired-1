require "rails_helper"

RSpec.describe "Favorite a Pet" do
  before :each do
    @shelter_1 = Shelter.create(
      name: "Paws For You",
      address: "1234 W Elf Ave",
      city: "Denver",
      state: "Colorado",
      zip: "90210",
    )

    @pet_1 = Pet.create(
      image: 'https://www.petful.com/wp-content/uploads/2014/01/maltese-1.jpg',
      name: "MoMo",
      approximate_age: "4",
      sex: "male",
      shelter_id: @shelter_1.id
    )

    @pet_2 = Pet.create(
      image: 'https://www.petful.com/wp-content/uploads/2014/01/maltese-1.jpg',
      name: "Lucy",
      approximate_age: "4",
      sex: "male",
      shelter_id: @shelter_1.id
    )

    visit "/pets/#{@pet_1.id}"

    within ".pets-#{@pet_1.id}" do
      click_link "Favorite"
    end
  end

  it "I can see all pets I've favorited" do
    visit "/favorites"

    expect(page).to have_content(@pet_1.name)
    expect(page).to have_css("img[src='#{@pet_1.image}']")
    expect(page).to_not have_content(@pet_2.name)
  end

  it "I can click on pet's name on favorites and go to pet show page" do
    visit "/favorites"

    expect(page).to have_content(@pet_1.name)
    click_on @pet_1.name
    expect(current_path).to eq("/pets/#{@pet_1.id}")
    expect(page).to have_content("MoMo")
    expect(page).to_not have_content("Lucy")
  end

  it "I can click on favorite indicator to go to favorites" do
    visit "/favorites"
    click_on "Favorites: 1"
    expect(current_path).to eq("/favorites")
  end

  it "I can see all pets that have approved apps" do
    visit "/favorites"

    application = Application.create(
      name: "Jae Park",
      address: "1245 S Ahgase Way",
      city: "Arcadia",
      state: "CA",
      zip: "910023",
      phone_number: "626-111-1111",
      description: "I work from home so I have plenty of time to be with the pet"
    )

    PetApplication.create(pet_id: @pet_1.id, application_id: application.id)

    visit "/applications/#{application.id}"
    click_link "Approve #{@pet_1.name}"

    visit "/favorites"
    within ".approved_pets" do
      expect(page).to have_content(@pet_1.name)
    end
  end
end
