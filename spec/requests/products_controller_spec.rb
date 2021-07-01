require 'rails_helper'

describe ProductsController do
  include Committee::Rails::Test::Methods

  def committee_options
    @committee_options ||= {
      schema_path: Rails.root.join('schema.yml').to_s,
      parse_response_by_content_type: true,
    }
  end

  describe '#search' do
    let!(:clio) { create(:product, label: 'Renault Clio') }
    let!(:clio_2) { create(:product, label: 'Renault Clio 2') }
    let!(:scenic) { create(:product, label: 'Renault Scenic') }
    let!(:peugeot_207) { create(:product, label: 'Peugeot 207') }
    let!(:peugeot_307) { create(:product, label: 'Peugeot 307') }
    let!(:peugeot_407) { create(:product, label: 'Peugeot 407') }

    it 'works when searching a brand' do
      get '/products/search', params: { query: 'Renault' }
      assert_request_schema_confirm
      assert_response_schema_confirm

      results = response.parsed[:products]

      expect(results.size).to eq 3
      expect(results.map { _1[:id] }).to match_array [
        clio,
        clio_2,
        scenic,
      ].map(&:id)
    end

    it 'works when searching with a space' do
      get '/products/search', params: { query: 'Renault Clio' }
      assert_request_schema_confirm
      assert_response_schema_confirm

      results = response.parsed[:products]

      expect(results.size).to eq 2
      expect(results.map { _1[:id] }).to match_array [
        clio,
        clio_2,
      ].map(&:id)
    end

    it 'works when searching part of word' do
      get '/products/search', params: { query: '07' }
      assert_request_schema_confirm
      assert_response_schema_confirm

      results = response.parsed[:products]

      expect(results.size).to eq 3
      expect(results.map { _1[:id] }).to match_array [
        peugeot_207,
        peugeot_307,
        peugeot_407,
      ].map(&:id)
    end
  end

  describe 'pagination' do
    let!(:products) do
      create_list(:product, 30, label: 'Renault').concat(
        create_list(:product, 30, label: 'Peugeot')
      )
    end

    it 'paginates by 25 without params' do
      get '/products/search', params: { query: 'Renault' }
      assert_request_schema_confirm
      assert_response_schema_confirm

      expect(response.parsed[:products].size).to eq 25

      pagination = response.parsed[:pagination]
      expect(pagination).to eq({
        page: 1,
        page_size: 25,
        total_pages: 2,
        total_entries: 30,
      })
    end

    it 'respects page param' do
      get '/products/search', params: { query: 'Renault', page: 2 }
      assert_request_schema_confirm
      assert_response_schema_confirm

      expect(response.parsed[:products].size).to eq 5

      pagination = response.parsed[:pagination]
      expect(pagination).to eq({
        page: 2,
        page_size: 25,
        total_pages: 2,
        total_entries: 30,
      })
    end

    it 'respects per_page param' do
      get '/products/search', params: { query: 'Renault', per_page: 7 }
      assert_request_schema_confirm
      assert_response_schema_confirm

      expect(response.parsed[:products].size).to eq 7

      pagination = response.parsed[:pagination]
      expect(pagination).to eq({
        page: 1,
        page_size: 7,
        total_pages: 5,
        total_entries: 30,
      })
    end
  end
end
