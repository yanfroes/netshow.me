require 'rails_helper'

feature 'Admin creates streaming' do
  before(:each) do
    @user = login_admin
  end

  scenario 'successfully' do

    streaming = build(:streaming, user: @user, status: :confirmed)

    visit new_streaming_path

    fill_in 'Título', with: streaming.title
    fill_in 'Descrição', with: streaming.description
    fill_in 'Link da Transmissão', with: streaming.url
    fill_in 'Data', with: streaming.date
    attach_file("Imagem", Rails.root + "spec/fixtures/image.png")

    click_on 'Salvar'
    human_status = Streaming.human_attribute_name(streaming.status.to_sym)
    expect(page).to have_content streaming.title
    expect(page).to have_content streaming.description
    expect(page).to have_content streaming.date
    expect(page).to have_content streaming.user.name
    expect(page).to have_content human_status
    expect(page).to have_xpath("//img[contains(@src,'/uploads/streamings/image/')]")
  end

  scenario 'With invalid data' do

    visit new_streaming_path

    click_on 'Salvar'

    expect(page).to have_content 'A transmissão não pode ser cadastrada, verifique os dados'
  end
end
