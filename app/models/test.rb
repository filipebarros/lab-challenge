# frozen_string_literal: true

class Test
  TYPE = 'test'

  DATA = [
    {
      id: 'CHO',
      name: 'Cholesterol',
      sample_volume_requirement: 100,
      sample_tube_type: :yellow
    },
    {
      id: 'LFT',
      name: 'Liver function',
      sample_volume_requirement: 60,
      sample_tube_type: :yellow
    },
    {
      id: 'VITD',
      name: 'Vitamin D',
      sample_volume_requirement: 120,
      sample_tube_type: :yellow
    },
    {
      id: 'B12',
      name: 'Vitamin B12',
      sample_volume_requirement: 180,
      sample_tube_type: :yellow
    },
    {
      id: 'HBA1C',
      name: 'HbA1C',
      sample_volume_requirement: 40,
      sample_tube_type: :purple
    },
    {
      id: 'FBC',
      name: 'Full blood count',
      sample_volume_requirement: 80,
      sample_tube_type: :purple
    }
  ].freeze

  class << self
    def to_jsonapi(id:)
      model = model_from_id(id: id)
      {
        'type': TYPE,
        'id': id,
        'attributes': {
          'name': name(model),
          'sample_volume_requirement': sample_volume_requirement(model),
          'sample_tube_type': sample_tube_type(model)
        }
      }
    end

    def to_relationship_data(id:)
      {
        'id': id,
        'type': TYPE
      }
    end

    def tube_type_for_test(id:)
      model = model_from_id(id: id)
      sample_tube_type(model)
    end

    def tube_sample_volume_for_test(id:)
      model = model_from_id(id: id)
      sample_volume_requirement(model)
    end

    private

    def id(model)
      model.fetch(:id)
    end

    def name(model)
      model.fetch(:name)
    end

    def sample_volume_requirement(model)
      model.fetch(:sample_volume_requirement)
    end

    def sample_tube_type(model)
      model.fetch(:sample_tube_type)
    end

    def model_from_id(id:)
      DATA.find do |test|
        id(test) == id
      end
    end
  end
end
