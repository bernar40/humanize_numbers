module HumanizeNumbers
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

      def humanize

        words = []

        number = self.to_f

        if number.to_i == 0
          words << self.zero_string
        else
          decimal = number.to_s.split(".")[1].nil? ? 0 : number.to_s.split(".")[1].to_i
          number = number.to_s.split(".")[0]

          number = number.rjust(33,'0').reverse
          groups = number.scan(/.../)

          words << number_to_words(groups[0].reverse)

          (1..10).each do |number|
            if groups[number].to_i > 0
              case number
              when 1,3,5,7,9
                words << "thousand" if I18n.locale == :en
                words << "mil" if I18n.locale == :es
                words << "mil" if I18n.locale == :pt
              else
                words << (groups[number].reverse.to_i > 1 ? "#{self.quantities[number]}" : "#{self.quantities[number]}") if I18n.locale == :en
                words << (groups[number].reverse.to_i > 1 ? "#{self.quantities[number]}" : "#{self.quantities[number]}") if I18n.locale == :pt
                words << (groups[number].reverse.to_i > 1 ? "#{self.quantities[number]}ones" : "#{self.quantities[number]}ón") if I18n.locale == :es
              end
              words << number_to_words(groups[number].reverse)
            end
          end
        end
        return "#{words.reverse.join(' ')} #{conector} #{decimal}/100"
      end

      protected

      def conector
        case I18n.locale
        when :en
          "with"
        when :es
          "con"
        when :pt
          "com"
        end
      end

      def and_string
        return "y" if I18n.locale == :es
        return "e" if I18n.locale == :pt
      end

      def zero_string
        case I18n.locale
        when :en
          "zero"
        when :es
          "cero"
        end
      end

      def units
        # 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
        case I18n.locale
        when :en
          %w[ ~ one two three four five six seven eight nine ]
        when :es
          %w[ ~ un dos tres cuatro cinco seis siete ocho nueve ]
        when :pt
          %w[ ~ um dois três quatro cinco seis sete oito nove ]
        end
      end

      def tens
        # 10, 20, 30, 40, 50, 60, 70, 80, 90
        case I18n.locale
        when :en
          %w[ ~ ten twenty thirty forty fifty sixty seventy eighty ninety ]
        when :es
          %w[ ~ diez veinte treinta cuarenta cincuenta sesenta setenta ochenta noventa ]
        when :pt
          %w[ ~ dez veinte trinta quarenta cinquenta sessenta setenta oitenta noventa ]
        end
      end

      def hundreds
        # 100, 200, 300, 400 , 500, 600, 700, 800, 900
        case I18n.locale
        when :en
          [ nil, 'one hundred', 'two hundred', 'three hundred', 'four hundred', 'five hundred', 'six hundred', 'seven hundred', 'eight hundred', 'nine hundred' ]
        when :es
          %w[ cien ciento doscientos trescientos cuatrocientos quinientos seiscientos setecientos ochocientos novecientos ]
        when :pt
          %w[ ~ cem duzentos trezentos quatrocentos quinhentos seiscentos setecentos oitocentos novecentos ]
        end
      end

      def teens
        # 10, 11, 12, 13, 14, 15, 16, 17, 18, 19
        case I18n.locale
        when :en
          %w[ ten eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen ]
        when :es
          %w[ diez once doce trece catorce quince dieciseis diecisiete dieciocho diecinueve ]
        when :pt
          %W[ dez onze doze treze catorze quinze dezesseis dezessete dezoito dezenove ]
        end
      end

      def quantities
        case I18n.locale
        when :en
          %w[ ~ ~ mill ~ bill ~ trill ~ cuatrill ~ quintill ~ ]
        when :es
          %w[ ~ ~ milli ~ billi ~ trilli ~ ]
        when :pt
          %[ ~ ~ milhão ~ bilhão ~ trilhão ~  mil bilhões ~ quintilhões ]
        end
      end

      def number_to_words(number)

        hundreds = number[0,1].to_i
        tens = number[1,1].to_i
        units = number[2,1].to_i

        text = []

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
          when 2
            text << (units == 0 ? self.tens[tens] : "veniti#{self.units[units]}") if I18n.locale == :es
            text << self.tens[tens] if I18n.locale == :en
            text <<  "#{self.and_string} #{self.tens[tens]}" if I18n.locale == :pt
          else
            text << self.tens[tens] if I18n.locale == :en
            text << self.tens[tens] if I18n.locale == :es
            text << "#{self.and_string} #{self.tens[tens]}" if I18n.locale == :pt
          end
        end

        if units > 0
          if tens == 0
            text << self.units[units]
          elsif tens > 2
            text << "#{self.and_string} #{self.units[units]}" if I18n.locale == :es
            text << "#{self.and_string} #{self.units[units]}" if I18n.locale == :pt
            text << self.units[units] if I18n.locale == :en
          else
            text << "#{self.and_string} #{self.units[units]}" if I18n.locale == :pt
            text << self.units[units] if I18n.locale == :en
          end
        end
        return text.join(' ')
      end

    end
  end
end

Numeric.send :include, HumanizeNumbers::Numeric
