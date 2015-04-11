require 'spec_helper'

describe Chef::Validation::Validator do
  describe '.validate' do
    context '#validate_type' do
      it 'string' do
        rules = {'type' => 'string'}
        expect(described_class.validate(node, 'cookbook/fun/stuff', rules)).to be_empty
        expect(described_class.validate(node, 'cookbook/tags', rules))
            .to eq(["Must be of type 'string' but got: Array."])
      end

      it 'numeric' do
        rules = {'type' => 'numeric'}
        expect(described_class.validate(node, 'cookbook/timeout', rules)).to be_empty
        expect(described_class.validate(node, 'cookbook/fun/stuff', rules))
            .to eq(["Must be of type 'numeric' but got: String."])
      end

      it 'hash' do
        rules = {'type' => 'hash'}
        expect(described_class.validate(node, 'cookbook/memory', rules)).to be_empty
        expect(described_class.validate(node, 'cookbook/fun/stuff', rules))
            .to eq(["Must be of type 'hash' but got: String."])
      end

      it 'array' do
        rules = {'type' => 'array'}
        expect(described_class.validate(node, 'cookbook/tags', rules)).to be_empty
        expect(described_class.validate(node, 'cookbook/fun/stuff', rules))
            .to eq(["Must be of type 'array' but got: String."])
      end

      it 'boolean' do
        rules = {'type' => 'boolean'}
        expect(described_class.validate(node, 'cookbook/works', rules)).to be_empty
        expect(described_class.validate(node, 'cookbook/fun/stuff', rules))
            .to eq(["Must be of type 'boolean' but got: String."])
      end

      it 'symbol' do
        rules = {'type' => 'symbol'}
        expect(described_class.validate(node, 'cookbook/simba', rules)).to be_empty
        expect(described_class.validate(node, 'cookbook/fun/stuff', rules))
            .to eq(["Must be of type 'symbol' but got: String."])
      end
    end

    context '#validate_choice' do
      context 'string' do
        it 'choice exists' do
          rules = {
            'type' => 'string',
            'choice' => ['production', 'secret', 'value']
          }
          expect(described_class.validate(node, 'cookbook/fun/stuff', rules)).to be_empty
        end

        it 'choice does not exist' do
          rules = {
            'type' => 'string',
            'choice' => ['production', 'public']
          }
          expect(described_class.validate(node, 'cookbook/fun/stuff', rules))
              .to eq(["Must be one of the following choices: production, public."])
        end
      end

      context 'array' do
        it 'choices exist' do
          rules = {
            'type' => 'array',
            'choice' => ['production', 'secret', 'value']
          }
          expect(described_class.validate(node, 'cookbook/fun/stuff2', rules)).to be_empty
        end

        it 'choices do not exist' do
          rules = {
            'type' => 'array',
            'choice' => ['production', 'public']
          }
          expect(described_class.validate(node, 'cookbook/fun/stuff2', rules))
              .to eq(["Must be any of the following choices: production, public."])
        end
      end
    end

    context '#validate_required' do
      context 'is required' do
        it 'value is string' do
          rules = {'required' => 'required'}
          expect(described_class.validate(node, 'cookbook/fun/stuff', rules)).to be_empty

          expect(described_class.validate(node, 'cookbook/fun/stuff-gone', rules))
              .to eq(["Attribute cookbook/fun/stuff-gone is required but was not present."])

        end

        it 'value is boolean' do
          rules = {'required' => true}
          expect(described_class.validate(node, 'cookbook/fun/stuff', rules)).to be_empty

          expect(described_class.validate(node, 'cookbook/fun/stuff-gone', rules))
              .to eq(["Attribute cookbook/fun/stuff-gone is required but was not present."])

        end
      end

      context 'is optional' do
        it 'value is string' do
          rules = {'required' => 'optional'}
          expect(described_class.validate(node, 'cookbook/fun/stuff', rules)).to be_empty
          expect(described_class.validate(node, 'cookbook/fun/stuff-gone', rules)).to be_empty
        end

        it 'value is boolean' do
          rules = {'required' => false}
          expect(described_class.validate(node, 'cookbook/fun/stuff', rules)).to be_empty
          expect(described_class.validate(node, 'cookbook/fun/stuff-gone', rules)).to be_empty
        end
      end
    end

    context '#recipe_present' do
      it 'config is an available recipe' do
        rules = {'type' => 'string', 'recipes' => ['config']}
        expect(described_class.validate(node, 'cookbook/fun/stuff', rules, recipes)).to be_empty
      end

      it 'config2 is not an available recipe' do
        rules = {'type' => 'string', 'recipes' => ['config2']}
        expect(described_class.validate(node, 'cookbook/fun/stuff', rules, recipes)).to be_empty
      end
    end
  end
end
