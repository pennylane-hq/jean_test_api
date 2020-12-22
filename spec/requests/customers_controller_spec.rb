require 'rails_helper'

describe CustomersController do
  describe '#search' do
    let!(:martin_dupont) { create(:customer, first_name: 'Martin', last_name: 'Dupont') }
    let!(:pierre_dupont) { create(:customer, first_name: 'Pierre', last_name: 'Dupont') }
    let!(:jean_dupont) { create(:customer, first_name: 'Jean', last_name: 'Dupont') }
    let!(:jean_dupond) { create(:customer, first_name: 'Jean', last_name: 'Dupond') }
    let!(:jean_bonneau) { create(:customer, first_name: 'Jean', last_name: 'Bonneau') }
    let!(:jacques_martin) { create(:customer, first_name: 'Jacques', last_name: 'Martin') }

    it 'works when searching a first_name' do
      get '/customers/search', params: { query: 'Jean' }

      results = response.parsed[:customers]

      expect(results.size).to eq 3
      expect(results.map { _1[:id] }).to match_array [
        jean_dupond,
        jean_dupont,
        jean_bonneau,
      ].map(&:id)
    end

    it 'works when searching with a last_name case-insensitively' do
      get '/customers/search', params: { query: 'dupont' }
      results = response.parsed[:customers]

      expect(results.size).to eq 3
      expect(results.map { _1[:id] }).to match_array [
        martin_dupont,
        pierre_dupont,
        jean_dupont,
      ].map(&:id)
    end

    it 'works when searching part of last name' do
      get '/customers/search', params: { query: 'dupon' }
      results = response.parsed[:customers]

      expect(results.size).to eq 4
      expect(results.map { _1[:id] }).to match_array [
        martin_dupont,
        pierre_dupont,
        jean_dupont,
        jean_dupond,
      ].map(&:id)
    end

    it 'mixes results for first and last name' do
      get '/customers/search', params: { query: 'martin' }
      results = response.parsed[:customers]

      expect(results.size).to eq 2
      expect(results.map { _1[:id] }).to match_array [
        martin_dupont,
        jacques_martin,
      ].map(&:id)
    end
  end
end
