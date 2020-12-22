module Searchable
  extend ActiveSupport::Concern

  OPERATORS = %i[search eq not_eq lt gt lteq gteq in not_in].freeze

  module ClassMethods
    def searchable_by(*fields, any: [])
      raise unless fields.all? { |f| f.is_a?(Symbol) }
      raise unless any.all? { |f| f.is_a?(Symbol) }

      scope :search_by, lambda { |queries|
        queries.reduce(self) do |memo, query|
          field = query[:field]&.to_sym
          value = query[:value]
          operator = query[:operator].to_sym

          if operator == :search_any
            query = any.reduce(Invoice.default_scoped.none) do |acc, field|
              final_model = attribute = nil
              if field.to_s.include?('.')
                *relation_names, attribute = field.to_s.split('.')

                final_model = relation_names.reduce(model) do |final_class, relation|
                  final_class.reflect_on_association(relation).klass
                end
              else
                attribute = field
                final_model = self.klass
              end

              acc.or(
                Invoice.default_scoped.where(
                  "LOWER(UNACCENT(#{final_model.table_name}.#{attribute}::TEXT)) ILIKE ?",
                  "%#{sanitize_sql_like(value)}%",
                ),
              )
            end

            next memo.merge(query)
          end

          next memo unless (fields.include?(field) || any.include?(field)) && OPERATORS.include?(operator)

          final_model = attribute = nil
          if field.to_s.include?('.')
            *relation_names, attribute = field.to_s.split('.')

            final_model = relation_names.reduce(model) do |final_class, relation|
              final_class.reflect_on_association(relation).klass
            end
          else
            attribute = field
            final_model = self.klass
          end

          if operator == :search
            next memo.where(
              "LOWER(UNACCENT(#{final_model.table_name}.#{attribute}::TEXT)) ILIKE ?",
              "%#{sanitize_sql_like(value)}%",
            )
          else
            next memo.where(
              final_model.arel_table[attribute].send(operator, value),
            )
          end
        end
      }
    end
  end
end
