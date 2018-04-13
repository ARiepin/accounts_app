require 'grape'
require './requests/api'
require 'spec_helper'
require 'rack/test'
require './models/user'
require 'pg'

describe Api do
  include Rack::Test::Methods

  def app
    Api
  end

  describe '#get' do
    context 'when account_id exists' do
      let(:account_id) {7}
      it 'returns users' do
        get "/api/v1/instructure/accounts/#{account_id}/users"
        parsed_response = JSON.parse(last_response.body)

        expect(last_response.status).to eq(200)
        expect(parsed_response.first.keys).to eq(['uuid', 'name',
                                             'sortable_name', 'workflow_state'])
        expect(parsed_response.first['name']).to eq('John Doe')
      end
    end

    context 'when account_id incorrect' do
      let(:account_id) {3}
      it 'raises error' do
        get "/api/v1/instructure/accounts/#{account_id}/users"
        expect(last_response.status).to eq(404)
      end
    end
  end
end
