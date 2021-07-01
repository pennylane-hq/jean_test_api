# frozen_string_literal: true

require 'rails_helper'

describe 'schema' do # rubocop:disable RSpec/DescribeClass
  schema = YAML.safe_load(File.open(Rails.root.join('schema.yml'))).deep_symbolize_keys

  xdescribe 'components' do
    describe 'schemas' do
      schema[:components][:schemas].each_key do |subschema|
        next if subschema.in?(%i[Pagination])

        describe subschema.to_s do
          it 'is namespaced correctly' do
            controller_hint = subschema.to_s.split('__')

            # last element is name of schema: no constraint
            controller_hint.pop

            # second-to-last element is name of controller
            controller_name = controller_hint.pop

            # remainder is namespace of controller
            module_name = controller_hint.join('::')

            expect { "#{module_name}::#{controller_name}Controller".constantize }.not_to raise_error
          end
        end
      end
    end
  end

  describe 'paths' do
    http_verbs = %i[get put post delete options patch]

    schema[:paths].each do |openapi_path, verbs|
      verbs.slice(*http_verbs).each do |verb, operation|
        describe "#{verb} #{openapi_path}" do
          it 'operationId matches corresponding route name' do
            matching_route = Rails.application.routes.routes.find do |rails_route|
              rails_route.path.spec.to_s.sub('(.:format)', '') == openapi_path.to_s.gsub(/\{([^}]*)\}/, ':\1')
            end

            expect(matching_route).not_to be_nil
            expect(operation[:operationId].to_s).to eq "#{verb}#{matching_route.name.camelize}"
          end
        end
      end
    end
  end
end
