class ComicsController < ApplicationController
rescue_from "MarvelApi::V1::Client::CharacterNotFound", with: :comic_not_found

  def index
    client = MarvelApi::V1::Client.new
    @comics= client.comics
  end

  def show
    client = MarvelApi::V1::Client.new
    @comic = client.comic(params[:id])
    @characters = client.characters_in_a_comic(params[:id])
  end

  private

  def comic_not_found
    render plain: 'comic not found'
  end

end