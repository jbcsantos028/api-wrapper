class CharactersController < ApplicationController
rescue_from "MarvelApi::V1::Client::CharacterNotFound", with: :character_not_found

  def index
    client = MarvelApi::V1::Client.new
    @characters = client.characters
  end

  def show
    client = MarvelApi::V1::Client.new
    @character = client.character(params[:id])
    @comics = client.comics_of_a_character(params[:id])
  end

  private

  def character_not_found
    render plain: 'character not found'
  end

end