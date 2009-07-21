module NumberToWords
  module Numeric
    def self.included(recipient)
      recipient.extend(ClassMethods)
      recipient.class_eval do
        include InstanceMethods
      end
    end

    module ClassMethods
    end

    module InstanceMethods


      def to_words

        words = Array.new

        number = self.to_i

        if number.to_i == 0
         words << self.zero_string
        else

          number = number.to_s.rjust(33,'0')
          groups = number.scan(/.{3}/).reverse


          words << number_to_words(groups[0])

          (1..10).each do |number|
            if groups[number].to_i > 0
              case number
              when 1,3,5,7,9
                words << "thousand"
              else
                words << (groups[number].to_i > 1 ? "#{self.quantities[number]}" : "#{self.quantities[number]}")
              end
              words << number_to_words(groups[number])
            end
          end

        end

        return "#{words.reverse.join(' ')}"
      end

      protected

      def and_string
        ""
      end

      def zero_string
        "zero"
      end

      def units
        %w[ ~ one two three four five six seven eight nine ]
      end

      def tens
        %w[ ~ ten twenty thirty fourty fifty sixty seventy eighty ninety ]
      end

      def hundreds
        [ nil, 'one hundred', 'two hundred', 'three hundred', 'four hundred', 'five hundred', 'six hundred', 
'seven hundred', 'eight hundred', 'nine hundred']
      end

      def teens
        %w[ ten eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen ]
      end

      def quantities
        %w[ ~ ~ million ~ billion ~ trillion ~ ]
      end

      def number_to_words(number)

        hundreds = number[0,1].to_i
        tens = number[1,1].to_i
        units = number[2,1].to_i

        text = Array.new

        if hundreds > 0
          if hundreds == 1 && (tens + units == 0)
            text << self.hundreds[0]
          else
            text << self.hundreds[hundreds]
          end
        end

        if tens > 0
          case tens
            when 1
              text << (units == 0 ? self.tens[tens] : self.teens[units])
            else
              text << self.tens[tens]
          end
        end

        if units > 0
          if tens == 0
            text << self.units[units]
          elsif tens > 1
            text << "#{self.and_string} #{self.units[units]}"
          end
        end

        return text.join(' ')

      end

    end
  end
end

Numeric.send :include, NumberToWords::Numeric
