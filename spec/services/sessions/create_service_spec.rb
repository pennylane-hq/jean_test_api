# frozen_string_literal: true

require 'rails_helper'

describe Sessions::CreateService do
  let(:session_name) { 'Thierry Deo' }
  let!(:customers) { create_list(:customer, 5) }
  let!(:products) { create_list(:product, 3) }

  describe '.call' do
    it 'creates a new session with the given name' do
      expect do
        described_class.call(session_name)
      end.to change(Session, :count).by(1)

      session = Session.last
      expect(session.name).to eq(session_name)
      expect(session.token).to be_present
    end

    it 'creates 15 invoices for the new session' do
      expect do
        described_class.call(session_name)
      end.to change(Invoice, :count).by(15).and change(InvoiceLine, :count)

      session = Session.last
      expect(Invoice.where(session_id: session.id).count).to eq(15)
    end
  end
end
