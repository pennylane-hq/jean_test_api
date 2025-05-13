require 'rails_helper'

describe CustomersController do
  include Committee::Rails::Test::Methods

  def committee_options
    @committee_options ||= {
      schema_path: Rails.root.join('schema.yml').to_s,
      parse_response_by_content_type: true,
      query_hash_key: 'rack.request.query_hash',
    }
  end

  describe '#search' do
    let!(:martin_dupont) { create(:customer, first_name: 'Martin', last_name: 'Dupont') }
    let!(:pierre_dupont) { create(:customer, first_name: 'Pierre', last_name: 'Dupont') }
    let!(:jean_dupont) { create(:customer, first_name: 'Jean', last_name: 'Dupont') }
    let!(:jean_dupond) { create(:customer, first_name: 'Jean', last_name: 'Dupond') }
    let!(:jean_bonneau) { create(:customer, first_name: 'Jean', last_name: 'Bonneau') }
    let!(:jacques_martin) { create(:customer, first_name: 'Jacques', last_name: 'Martin') }

    it 'works when searching a first_name' do
      get '/customers/search', params: { query: 'Jean' }
      assert_request_schema_confirm
      assert_response_schema_confirm

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
      assert_request_schema_confirm
      assert_response_schema_confirm

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
      assert_request_schema_confirm
      assert_response_schema_confirm

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
      assert_request_schema_confirm
      assert_response_schema_confirm

      results = response.parsed[:customers]

      expect(results.size).to eq 2
      expect(results.map { _1[:id] }).to match_array [
        martin_dupont,
        jacques_martin,
      ].map(&:id)
    end
  end
end
