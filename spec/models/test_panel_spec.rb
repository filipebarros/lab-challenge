# frozen_string_literal: true

require 'rails_helper'

describe TestPanel, type: :model do
  let(:id) { 'TP1' }

  it 'stores the data in a DATA constant' do
    expect(TestPanel::DATA.empty?).not_to eq(true)
  end

  describe '.to_jsonapi' do
    subject(:jsonapi) { described_class.to_jsonapi(id: id, included: included) }

    let(:expected) do
      {
        'data': {
          'type': 'test_panels',
          'id': 'TP1',
          'attributes': {
            'price': 1700,
            'sample_tube_types': %i[yellow yellow],
            'sample_volume_requirement': 220
          }
        },
        'relationships': {
          'test': {
            'data': [
              {
                'id': 'CHO',
                'type': 'test'
              },
              {
                'id': 'VITD',
                'type': 'test'
              }
            ]
          }
        }
      }
    end

    context 'without include parameter' do
      let(:included) { nil }

      it 'returns the hash respecting jsonapi format' do
        expect(jsonapi).to eq(expected)
      end
    end

    context 'with include parameter' do
      describe 'with valid include parameter' do
        let(:included) { 'test' }
        let(:extra_include) do
          {
            'include': [
              {
                'type': 'test',
                'id': 'CHO',
                'attributes': {
                  'name': 'Cholesterol',
                  'sample_volume_requirement': 100,
                  'sample_tube_type': :yellow
                }
              },
              {
                'type': 'test',
                'id': 'VITD',
                'attributes': {
                  'name': 'Vitamin D',
                  'sample_volume_requirement': 120,
                  'sample_tube_type': :yellow
                }
              }
            ]
          }
        end
        let(:expected) { super().merge(extra_include) }

        it 'returns the hash respecting jsonapi format' do
          expect(jsonapi).to eq(expected)
        end
      end

      describe 'with invalid include parameter' do
        let(:included) { 'invalid' }

        it 'returns the hash respecting jsonapi format' do
          expect(jsonapi).to eq(expected)
        end
      end
    end
  end
end
