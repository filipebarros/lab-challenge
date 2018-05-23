# frozen_string_literal: true

class TestPanel
  class RecordNotFound < StandardError; end

  TYPE = 'test_panels'

  DATA = [
    {
      id: 'TP1',
      tests: %w[CHO VITD],
      price: 1700
    },
    {
      id: 'TP2',
      tests: %w[HBA1C B12],
      price: 2100
    },
    {
      id: 'TP3',
      tests: %w[LFT VITD CHO],
      price: 1800
    }
  ].freeze

  class << self
    def to_jsonapi(id:, included: nil)
      model = model_from_id(id: id)
      raise RecordNotFound, 'Test Panel Not Found' if model.nil?

      test_ids = tests(model)

      hash = {
        'data': {
          'type': 'test_panels',
          'id': id(model),
          'attributes': {
            'price': price(model),
            'sample_tube_types': tube_type_for_tests(test_ids: test_ids),
            'sample_volume_requirement': total_volume_requirement(test_ids: test_ids)
          }
        },
        'relationships': {
          'test': {
            'data': relationships(test_ids: test_ids)
          }
        }
      }

      hash.merge!(included(test_ids: test_ids)) if included.eql?(Test::TYPE)
      hash
    end

    private

    def id(model)
      model.fetch(:id)
    end

    def tests(model)
      model.fetch(:tests)
    end

    def price(model)
      model.fetch(:price)
    end

    def tube_type_for_tests(test_ids:)
      test_ids.map do |test_id|
        Test.tube_type_for_test(id: test_id)
      end
    end

    def total_volume_requirement(test_ids:)
      test_ids.inject(0) do |sum, test_id|
        sum + Test.tube_sample_volume_for_test(id: test_id)
      end
    end

    def relationships(test_ids:)
      test_ids.map do |test_id|
        Test.to_relationship_data(id: test_id)
      end
    end

    def included(test_ids:)
      {
        'include': test_ids.map do |test_id|
          Test.to_jsonapi(id: test_id)
        end
      }
    end

    def model_from_id(id:)
      DATA.find do |test_panel|
        id(test_panel) == id
      end
    end
  end
end
