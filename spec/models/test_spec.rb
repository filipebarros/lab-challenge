# frozen_string_literal: true

require 'rails_helper'

describe Test, type: :model do
  let(:id) { 'VITD' }

  it 'should store the data in a DATA constant' do
    expect(described_class::DATA.empty?).not_to eq(true)
  end

  describe '.to_jsonapi' do
    let(:expected) do
      {
        'type': 'test',
        'id': 'VITD',
        'attributes': {
          'name': 'Vitamin D',
          'sample_volume_requirement': 120,
          'sample_tube_type': :yellow
        }
      }
    end
    subject(:jsonapi) { described_class.to_jsonapi(id: id) }

    it 'returns the hash respecting jsonapi format' do
      expect(jsonapi).to eq(expected)
    end
  end

  describe '.to_relationship_data' do
    let(:expected) do
      {
        'id': 'VITD',
        'type': 'test'
      }
    end
    subject(:relationship) { described_class.to_relationship_data(id: id) }

    it 'returns a relationship hash' do
      expect(relationship).to eq(expected)
    end
  end

  describe '.tube_type_for_test' do
    let(:expected) { :yellow }
    subject(:tube_type) { described_class.tube_type_for_test(id: id) }

    it 'returns the sample_tube_type for the test' do
      expect(tube_type).to be(expected)
    end
  end

  describe '.tube_sample_volume_for_test' do
    let(:expected) { 120 }
    subject(:tube_sample_volume) { described_class.tube_sample_volume_for_test(id: id) }

    it 'returns the sample_tube_type for the test' do
      expect(tube_sample_volume).to be(expected)
    end
  end
end
