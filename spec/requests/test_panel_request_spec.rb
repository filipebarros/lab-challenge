# frozen_string_literal: true

require 'rails_helper'

describe 'Requesting a test panel', type: :request do
  context 'with an invalid test panel ID' do
    let(:test_panel_id) { 'TR1' }

    it 'responds with an HTTP 200 status' do
      get "/test_panels/#{test_panel_id}"

      expect(response).to have_http_status(:not_found)
    end
  end

  context 'with a valid test panel ID' do
    let(:test_panel_id) { 'TP1' }

    describe 'without query params' do
      it 'responds with an HTTP 200 status' do
        get "/test_panels/#{test_panel_id}"

        expect(response).to have_http_status(:ok)
      end
    end

    context 'with include query param' do
      describe 'when include is the test model' do
        it 'includes the `include` section' do
          get "/test_panels/#{test_panel_id}?include=test"

          json_body = JSON.parse(response.body)
          expect(json_body).to include('include')
        end
      end

      describe 'when include is a random model' do
        it 'does not include the `include` section' do
          get "/test_panels/#{test_panel_id}?include=wow"

          json_body = JSON.parse(response.body)
          expect(json_body).not_to include('include')
        end
      end
    end
  end
end
