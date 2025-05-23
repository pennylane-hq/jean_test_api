# frozen_string_literal: true

require 'rails_helper'

describe SessionsController do
  include Committee::Rails::Test::Methods

  def committee_options
    @committee_options ||= {
      schema_path: Rails.root.join('private_schema.yml').to_s,
      parse_response_by_content_type: true,
      query_hash_key: 'rack.request.query_hash'
    }
  end

  describe '#create' do
    let(:token) { 'test_token' }
    let!(:customers) { create_list(:customer, 5) }
    let!(:products) { create_list(:product, 3) }

    before do
      allow(Rails.application.credentials).to receive(:jeancaisse_token).and_return(token)
    end

    context 'with valid authentication' do
      let(:headers) { { 'Authorization' => "Bearer #{token}" } }

      it 'creates a new session when name does not exist' do
        expect do
          post sessions_path, params: { name: 'Thierry Deo' }, as: :json, headers: headers
        end.to change(Session, :count).by(1).and change(Invoice, :count).by(15)

        assert_request_schema_confirm
        assert_response_schema_confirm
        expect(response).to have_http_status(:created)

        last_session = Session.last

        expect(response.parsed[:id]).to eq(last_session.id)
        expect(response.parsed[:token]).to be_present

        expect(Invoice.where(session_id: last_session.id).count).to eq(15)
      end

      context 'when a session for this name already exists' do
        let!(:existing_session) { create(:session, name: 'Thierry Deo') }

        it 'returns the existing session' do
          expect do
            post sessions_path, params: { name: 'Thierry Deo' }, as: :json, headers: headers
          end.not_to change(Session, :count)

          assert_request_schema_confirm
          assert_response_schema_confirm
          expect(response).to have_http_status(:ok)

          expect(response.parsed[:id]).to eq(existing_session.id)
          expect(response.parsed[:token]).to eq(existing_session.token)
        end
      end

      context 'when the name is not provided' do
        it 'returns a unprocessable_entity request' do
          post sessions_path, params: {}, as: :json, headers: headers

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'with invalid authentication' do
      it 'returns unauthorized when invalid token provided' do
        post sessions_path, params: { name: 'Thierry Deo' }, as: :json,
                            headers: { 'Authorization' => 'Bearer invalid_token' }

        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to eq('Invalid token')
      end
    end
  end
end
